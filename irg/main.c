//******************************************************************************
//* A folyad�kszint jelz� perif�ria kezel�se k�zvetlen m�don, eszk�zmeghajt�   *
//* n�lk�l. A folyad�kszintet �s a hibajelz�st a piros LED-eken jelen�tj�k     *
//* meg (folyad�kszint -> LD[3:0], hibajelz�s -> LD[7]).                       *
//******************************************************************************
#include <xparameters.h>

//A 32 bites mem�ria el�r�st biztos�t� makr�.
#define MEM32(addr) (*(volatile unsigned long *)(addr))

//A GPIO perif�ria adatregisztereinek offszet c�mei.
#define GPIO_DATA1  0x00
#define GPIO_DATA2  0x08

//A folyad�kszint jelz� perif�ria regisztereinek offszet c�mei.
#define LVL_DATA    0x00
#define LVL_IE      0x04
#define LVL_IF      0x08

int main()
{
	unsigned long data;

	for (;;)
	{
		//Beolvassuk a folyad�kszintet �s a hibajelz�st.
		//data[3:0]: folyad�kszint, data[31]: hibajelz�s.
		data = MEM32(XPAR_LVL_INDICATOR_0_BASEADDR + LVL_DATA);
		//A folyad�kszint j� helyen van a v�ltoz�ban, a hibajelz�st
		//kell 24 bittel jobbra l�ptetni.
		data = (data & 0x0f) | ((data >> 24) & 0x80);
		//Megjelen�t�s a LED-eken.
		MEM32(XPAR_GPIO_LED_DISP_BASEADDR + GPIO_DATA1) = data;
	}

	return 0;
}
