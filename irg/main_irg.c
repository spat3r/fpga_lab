#include <xparameters.h>
#include <xgpio_l.h>
#include <xintc_l.h>
#include <xtmrctr_l.h>
#include <mb_interface.h>


//*****************************************************************************
//* Makrók a memória írásához és olvasásához.                                 *
//*****************************************************************************
#define MEM8(addr)   (*(volatile unsigned char *)(addr))
#define MEM16(addr)  (*(volatile unsigned short *)(addr))
#define MEM32(addr)  (*(volatile unsigned long *)(addr))


//*****************************************************************************
//* Definíciók a folyadékszint jelzõ perifériához.                            *
//*****************************************************************************
//Státusz regiszter: 32 bites, csak olvasható
#define LVL_STATUS_REG				0x00
//Megszakítás engedélyezõ regiszter: 32 bites, írható/olvasható
#define LVL_IE_REG					0x04
//Megszakítás flag regiszter: 32 bites, olvasható  és '1' beírással törölhetõ
#define LVL_IF_REG					0x08

//A folyadékszint jelzõ periféria megszakítás eseményei.
#define LVL_FULL_IRQ				(1 << 0)
#define LVL_EMPTY_IRQ				(1 << 1)
#define LVL_ERROR_IRQ				(1 << 2)


//*****************************************************************************
//* Hétszegmenses dekóder.                                                    *
//*****************************************************************************
unsigned char bin2sevenseg[] = {
	0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07,
	0x7f, 0x6f, 0x77, 0x7c, 0x39, 0x5e, 0x79, 0x71
};


//*****************************************************************************
//* Az idõzítõ megszakításkezelõ rutinja.                                     *
//*****************************************************************************
volatile unsigned char led_value;
volatile unsigned char led_blink;

void timer_int_handler(void *instancePtr)
{
	unsigned long csr;

	//Meghatározzuk a LED-ekre kiírandó új értéket és amennyiben engedélyezett
	//a villogás, akkor azt kiírjuk a LED-ekre. Ha a villogás nem engedélyezett,
	//akkor a LED-eket kikapcsoljuk.
	if ( led_blink ) {
		led_value = ~led_value;
	} else {
		led_value = 0;
	}

	XGpio_WriteReg(XPAR_GPIO_LED_DISP_BASEADDR, XGPIO_DATA_OFFSET, led_value);

	//A megszakítás jelzés törlése. A jelzés az idõzítõ kontroll/státusz
	//regiszterében 1 beírásával törölhetõ.
	csr = XTmrCtr_GetControlStatusReg(XPAR_TIMER_BASEADDR, 0);
	XTmrCtr_SetControlStatusReg(XPAR_TIMER_BASEADDR, 0, csr);


}


//*****************************************************************************
//* A GPIO periféria megszakításkezelõ rutinja.                               *
//*****************************************************************************
void gpio_int_handler(void *instancePtr)
{
	unsigned long ifr, btn;

	//A megszakítás jelzés törlése. A jelzés a GPIO megszakítás státusz
	ifr = XGpio_ReadReg(XPAR_GPIO_SW_BTN_BASEADDR, XGPIO_ISR_OFFSET);
	//regiszterében 1 beírásával törölhetõ.
	XGpio_WriteReg(XPAR_GPIO_SW_BTN_BASEADDR, XGPIO_ISR_OFFSET, ifr);

	//A GPIO CH2 állapotváltozás megszakítás vizsgálata. Ha a BTN0 gombot
	//megnyomták, akkor tiltjuk a LED-ek villogását.
	btn = XGpio_ReadReg(XPAR_GPIO_SW_BTN_BASEADDR, XGPIO_DATA2_OFFSET);
	if (btn) {
		led_blink = 0;
	}
}


//*****************************************************************************
//* A folyadékszint kijelzõ periféria megszakításkezelõ rutinja.              *
//*****************************************************************************
void lvl_int_handler(void *instancePtr)
{
	unsigned long ifr;

	//A megszakítás jelzés törlése. A jelzés a periféria megszakítás flag
	//regiszterében 1 beírásával törölhetõ.
	ifr = MEM32(XPAR_LVL_INDICATOR_0_BASEADDR+LVL_IF_REG);
	MEM32(XPAR_LVL_INDICATOR_0_BASEADDR+LVL_IF_REG) = ifr;
	//Hibajelzés esetén engedélyezzük a LED-ek villogását.
	if (ifr & LVL_ERROR_IRQ) {
		led_blink = 1;
	}

}


//*****************************************************************************
//* Fõprogram.                                                                *
//*****************************************************************************
int main()
{
	unsigned long data;

	led_value = 0;
	led_blink = 0;

	//A megszakításkezelõ rutinok regisztrálása:
	//  a) Idõzítõ
	XIntc_RegisterHandler(
		XPAR_INTC_0_BASEADDR,
		XPAR_MICROBLAZE_0_AXI_INTC_TIMER_INTERRUPT_INTR,
		(XInterruptHandler)timer_int_handler,
		NULL
	);

	//  b) Nyomógombok (GPIO)
	XIntc_RegisterHandler(
		XPAR_INTC_0_BASEADDR,
		XPAR_MICROBLAZE_0_AXI_INTC_GPIO_SW_BTN_IP2INTC_IRPT_INTR,
		(XInterruptHandler)gpio_int_handler,
		NULL
	);
	//  c) Folyadékszint jelzõ periféria
	XIntc_RegisterHandler(
		XPAR_INTC_0_BASEADDR,
		XPAR_MICROBLAZE_0_AXI_INTC_LVL_INDICATOR_0_IRQ_INTR,
		(XInterruptHandler)lvl_int_handler,
		NULL
	);

	//A használt megszakítások engedélyezése a megszakítás vezérlõben.
	XIntc_MasterEnable(XPAR_INTC_0_BASEADDR);
	XIntc_EnableIntr(
			XPAR_INTC_0_BASEADDR
		,	XPAR_TIMER_INTERRUPT_MASK
		|	XPAR_GPIO_SW_BTN_IP2INTC_IRPT_MASK
		|	XPAR_LVL_INDICATOR_0_IRQ_MASK
			);


	//A CH2 állapotváltozás megszakítás engedélyezése a kapcsoló/nyomógomb GPIO perifériában:
	//CH2 flag törlése, CH2 megszakítás engedélyezés, globális megszakítás engedélyezés.
	XGpio_WriteReg(XPAR_GPIO_SW_BTN_BASEADDR, XGPIO_ISR_OFFSET, XGPIO_IR_MASK);
	XGpio_WriteReg(XPAR_GPIO_SW_BTN_BASEADDR, XGPIO_IER_OFFSET, XGPIO_IR_CH2_MASK);
	XGpio_WriteReg(XPAR_GPIO_SW_BTN_BASEADDR, XGPIO_GIE_OFFSET, XGPIO_GIE_GINTR_ENABLE_MASK);

	//A hiba megszakítás engedélyezése a folyadékszint kijelzõ perifériában:
	//ERROR flag törlése, ERROR megszakítás engedélyezése.
	MEM32(XPAR_LVL_INDICATOR_0_BASEADDR + LVL_IF_REG) = 0x07;
	MEM32(XPAR_LVL_INDICATOR_0_BASEADDR + LVL_IE_REG) = LVL_ERROR_IRQ;
	//A megszakítások engedélyezése a MicroBlaze processzoron.
	microblaze_enable_interrupts();

	//A timer LOAD regiszterének beállítása (megszakítás 0,25 másodpercenként).
	XTmrCtr_SetLoadReg(
			XPAR_TIMER_BASEADDR,
			0,
			XPAR_TIMER_CLOCK_FREQ_HZ / 4
		);

	//A timer alapállapotba állítása:
	//- a timer leállítása
	//- a megszakítás jelzés törlése
	//- a LOAD regiszter betöltése a számlálóba
	XTmrCtr_SetControlStatusReg(
		XPAR_TIMER_BASEADDR,
		0,
		XTC_CSR_INT_OCCURED_MASK | XTC_CSR_LOAD_MASK
	);

	//A timer elindítása:
	//- a timer engedélyezése
	//- a megszakítás engedélyezése
	//- automatikus számláló újratöltés (periodikus) mód
	//- a számláló lefele számlál (0 a végállapot)
	XTmrCtr_SetControlStatusReg(
		XPAR_TIMER_BASEADDR,
		0
	,	XTC_CSR_ENABLE_TMR_MASK
	| 	XTC_CSR_ENABLE_INT_MASK
	| 	XTC_CSR_AUTO_RELOAD_MASK
	|	XTC_CSR_DOWN_COUNT_MASK
	);


	//A végtelen ciklusban folyamatosan beolvassuk a folyadékszint
	//értékét és kijelezzük a hétszegmenses kijelzõ DIG0 digitjére.
	for (;;)
	{
		char szint;
		szint = MEM32(XPAR_LVL_INDICATOR_0_BASEADDR);
		XGpio_WriteReg(XPAR_GPIO_SW_BTN_BASEADDR)
	}

	return 0;
}
