#include <xparameters.h>
#include <xgpio_l.h>
#include <xintc_l.h>
#include <xtmrctr_l.h>
#include <mb_interface.h>


//*****************************************************************************
//* Makr�k a mem�ria �r�s�hoz �s olvas�s�hoz.                                 *
//*****************************************************************************
#define MEM8(addr)   (*(volatile unsigned char *)(addr))
#define MEM16(addr)  (*(volatile unsigned short *)(addr))
#define MEM32(addr)  (*(volatile unsigned long *)(addr))


//*****************************************************************************
//* Defin�ci�k a folyad�kszint jelz� perif�ri�hoz.                            *
//*****************************************************************************
//St�tusz regiszter: 32 bites, csak olvashat�
#define LVL_STATUS_REG				0x00
//Megszak�t�s enged�lyez� regiszter: 32 bites, �rhat�/olvashat�
#define LVL_IE_REG					0x04
//Megszak�t�s flag regiszter: 32 bites, olvashat�  �s '1' be�r�ssal t�r�lhet�
#define LVL_IF_REG					0x08

//A folyad�kszint jelz� perif�ria megszak�t�s esem�nyei.
#define LVL_FULL_IRQ				(1 << 0)
#define LVL_EMPTY_IRQ				(1 << 1)
#define LVL_ERROR_IRQ				(1 << 2)


//*****************************************************************************
//* H�tszegmenses dek�der.                                                    *
//*****************************************************************************
unsigned char bin2sevenseg[] = {
	0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07,
	0x7f, 0x6f, 0x77, 0x7c, 0x39, 0x5e, 0x79, 0x71
};


//*****************************************************************************
//* Az id�z�t� megszak�t�skezel� rutinja.                                     *
//*****************************************************************************
volatile unsigned char led_value;
volatile unsigned char led_blink;

void timer_int_handler(void *instancePtr)
{
	unsigned long csr;

	//Meghat�rozzuk a LED-ekre ki�rand� �j �rt�ket �s amennyiben enged�lyezett
	//a villog�s, akkor azt ki�rjuk a LED-ekre. Ha a villog�s nem enged�lyezett,
	//akkor a LED-eket kikapcsoljuk.
	if ( led_blink ) {
		led_value = ~led_value;
	} else {
		led_value = 0;
	}

	XGpio_WriteReg(XPAR_GPIO_LED_DISP_BASEADDR, XGPIO_DATA_OFFSET, led_value);

	//A megszak�t�s jelz�s t�rl�se. A jelz�s az id�z�t� kontroll/st�tusz
	//regiszter�ben 1 be�r�s�val t�r�lhet�.
	csr = XTmrCtr_GetControlStatusReg(XPAR_TIMER_BASEADDR, 0);
	XTmrCtr_SetControlStatusReg(XPAR_TIMER_BASEADDR, 0, csr);


}


//*****************************************************************************
//* A GPIO perif�ria megszak�t�skezel� rutinja.                               *
//*****************************************************************************
void gpio_int_handler(void *instancePtr)
{
	unsigned long ifr, btn;

	//A megszak�t�s jelz�s t�rl�se. A jelz�s a GPIO megszak�t�s st�tusz
	ifr = XGpio_ReadReg(XPAR_GPIO_SW_BTN_BASEADDR, XGPIO_ISR_OFFSET);
	//regiszter�ben 1 be�r�s�val t�r�lhet�.
	XGpio_WriteReg(XPAR_GPIO_SW_BTN_BASEADDR, XGPIO_ISR_OFFSET, ifr);

	//A GPIO CH2 �llapotv�ltoz�s megszak�t�s vizsg�lata. Ha a BTN0 gombot
	//megnyomt�k, akkor tiltjuk a LED-ek villog�s�t.
	btn = XGpio_ReadReg(XPAR_GPIO_SW_BTN_BASEADDR, XGPIO_DATA2_OFFSET);
	if (btn) {
		led_blink = 0;
	}
}


//*****************************************************************************
//* A folyad�kszint kijelz� perif�ria megszak�t�skezel� rutinja.              *
//*****************************************************************************
void lvl_int_handler(void *instancePtr)
{
	unsigned long ifr;

	//A megszak�t�s jelz�s t�rl�se. A jelz�s a perif�ria megszak�t�s flag
	//regiszter�ben 1 be�r�s�val t�r�lhet�.
	ifr = MEM32(XPAR_LVL_INDICATOR_0_BASEADDR+LVL_IF_REG);
	MEM32(XPAR_LVL_INDICATOR_0_BASEADDR+LVL_IF_REG) = ifr;
	//Hibajelz�s eset�n enged�lyezz�k a LED-ek villog�s�t.
	if (ifr & LVL_ERROR_IRQ) {
		led_blink = 1;
	}

}


//*****************************************************************************
//* F�program.                                                                *
//*****************************************************************************
int main()
{
	unsigned long data;

	led_value = 0;
	led_blink = 0;

	//A megszak�t�skezel� rutinok regisztr�l�sa:
	//  a) Id�z�t�
	XIntc_RegisterHandler(
		XPAR_INTC_0_BASEADDR,
		XPAR_MICROBLAZE_0_AXI_INTC_TIMER_INTERRUPT_INTR,
		(XInterruptHandler)timer_int_handler,
		NULL
	);

	//  b) Nyom�gombok (GPIO)
	XIntc_RegisterHandler(
		XPAR_INTC_0_BASEADDR,
		XPAR_MICROBLAZE_0_AXI_INTC_GPIO_SW_BTN_IP2INTC_IRPT_INTR,
		(XInterruptHandler)gpio_int_handler,
		NULL
	);
	//  c) Folyad�kszint jelz� perif�ria
	XIntc_RegisterHandler(
		XPAR_INTC_0_BASEADDR,
		XPAR_MICROBLAZE_0_AXI_INTC_LVL_INDICATOR_0_IRQ_INTR,
		(XInterruptHandler)lvl_int_handler,
		NULL
	);

	//A haszn�lt megszak�t�sok enged�lyez�se a megszak�t�s vez�rl�ben.
	XIntc_MasterEnable(XPAR_INTC_0_BASEADDR);
	XIntc_EnableIntr(
			XPAR_INTC_0_BASEADDR
		,	XPAR_TIMER_INTERRUPT_MASK
		|	XPAR_GPIO_SW_BTN_IP2INTC_IRPT_MASK
		|	XPAR_LVL_INDICATOR_0_IRQ_MASK
			);


	//A CH2 �llapotv�ltoz�s megszak�t�s enged�lyez�se a kapcsol�/nyom�gomb GPIO perif�ri�ban:
	//CH2 flag t�rl�se, CH2 megszak�t�s enged�lyez�s, glob�lis megszak�t�s enged�lyez�s.
	XGpio_WriteReg(XPAR_GPIO_SW_BTN_BASEADDR, XGPIO_ISR_OFFSET, XGPIO_IR_MASK);
	XGpio_WriteReg(XPAR_GPIO_SW_BTN_BASEADDR, XGPIO_IER_OFFSET, XGPIO_IR_CH2_MASK);
	XGpio_WriteReg(XPAR_GPIO_SW_BTN_BASEADDR, XGPIO_GIE_OFFSET, XGPIO_GIE_GINTR_ENABLE_MASK);

	//A hiba megszak�t�s enged�lyez�se a folyad�kszint kijelz� perif�ri�ban:
	//ERROR flag t�rl�se, ERROR megszak�t�s enged�lyez�se.
	MEM32(XPAR_LVL_INDICATOR_0_BASEADDR + LVL_IF_REG) = 0x07;
	MEM32(XPAR_LVL_INDICATOR_0_BASEADDR + LVL_IE_REG) = LVL_ERROR_IRQ;
	//A megszak�t�sok enged�lyez�se a MicroBlaze processzoron.
	microblaze_enable_interrupts();

	//A timer LOAD regiszter�nek be�ll�t�sa (megszak�t�s 0,25 m�sodpercenk�nt).
	XTmrCtr_SetLoadReg(
			XPAR_TIMER_BASEADDR,
			0,
			XPAR_TIMER_CLOCK_FREQ_HZ / 4
		);

	//A timer alap�llapotba �ll�t�sa:
	//- a timer le�ll�t�sa
	//- a megszak�t�s jelz�s t�rl�se
	//- a LOAD regiszter bet�lt�se a sz�ml�l�ba
	XTmrCtr_SetControlStatusReg(
		XPAR_TIMER_BASEADDR,
		0,
		XTC_CSR_INT_OCCURED_MASK | XTC_CSR_LOAD_MASK
	);

	//A timer elind�t�sa:
	//- a timer enged�lyez�se
	//- a megszak�t�s enged�lyez�se
	//- automatikus sz�ml�l� �jrat�lt�s (periodikus) m�d
	//- a sz�ml�l� lefele sz�ml�l (0 a v�g�llapot)
	XTmrCtr_SetControlStatusReg(
		XPAR_TIMER_BASEADDR,
		0
	,	XTC_CSR_ENABLE_TMR_MASK
	| 	XTC_CSR_ENABLE_INT_MASK
	| 	XTC_CSR_AUTO_RELOAD_MASK
	|	XTC_CSR_DOWN_COUNT_MASK
	);


	//A v�gtelen ciklusban folyamatosan beolvassuk a folyad�kszint
	//�rt�k�t �s kijelezz�k a h�tszegmenses kijelz� DIG0 digitj�re.
	for (;;)
	{
		char szint;
		szint = MEM32(XPAR_LVL_INDICATOR_0_BASEADDR);
		XGpio_WriteReg(XPAR_GPIO_SW_BTN_BASEADDR)
	}

	return 0;
}
