//******************************************************************************
//* A folyadékszint jelzõ periféria kezelése közvetlen módon, eszközmeghajtó   *
//* nélkül. A folyadékszintet és a hibajelzést a piros LED-eken jelenítjük     *
//* meg (folyadékszint -> LD[3:0], hibajelzés -> LD[7]).                       *
//******************************************************************************
#include <xparameters.h>

//A 32 bites memória elérést biztosító makró.
#define MEM32(addr) (*(volatile unsigned long *)(addr))

//A GPIO periféria adatregisztereinek offszet címei.
#define GPIO_DATA1  0x00
#define GPIO_DATA2  0x08

//A folyadékszint jelzõ periféria regisztereinek offszet címei.
#define LVL_DATA    0x00
#define LVL_IE      0x04
#define LVL_IF      0x08

int main()
{
	unsigned long data;

	for (;;)
	{
		//Beolvassuk a folyadékszintet és a hibajelzést.
		//data[3:0]: folyadékszint, data[31]: hibajelzés.
		data = MEM32(XPAR_LVL_INDICATOR_0_BASEADDR + LVL_DATA);
		//A folyadékszint jó helyen van a változóban, a hibajelzést
		//kell 24 bittel jobbra léptetni.
		data = (data & 0x0f) | ((data >> 24) & 0x80);
		//Megjelenítés a LED-eken.
		MEM32(XPAR_GPIO_LED_DISP_BASEADDR + GPIO_DATA1) = data;
	}

	return 0;
}
