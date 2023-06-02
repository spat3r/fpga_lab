//******************************************************************************
//* GPIO perifériák kezelése magasszintű eszközmeghajtóval.                    *
//******************************************************************************
#include <xparameters.h>
#include <xgpio.h>
#include <xil_printf.h>
#include <sleep.h>
#include <stdio.h>
#include <xuartlite_l.h>

#define GPIO_DATA1 0x00
#define GPIO_DATA2 0x08
#define UART_BADDR XPAR_UARTLITE_BASEADDR


void led_disp_sub(XGpio* led_disp, XGpio* sw_btn)
{
	unsigned long sw_data, btn_data, disp_data;
	//Reading the states of the swithes and buttons
	sw_data = XGpio_DiscreteRead(sw_btn, 1);
	btn_data = XGpio_DiscreteRead(sw_btn, 2);
	//...és megjelenítése a piros LED-eken.
	switch (btn_data) {
		case 1: disp_data = sw_data | 0x100; break;
		case 2: disp_data = sw_data | 0x200; break;
		case 4: disp_data = sw_data | 0x400; break;
		case 8: disp_data = sw_data | 0x800; break;
		default: break;
	}

	XGpio_WriteReg(XPAR_GPIO_LED_DISP_BASEADDR, GPIO_DATA2, disp_data);
	//XGpio_DiscreteWrite(led_disp, 2, disp_data);
	XGpio_DiscreteWrite(led_disp, 1, sw_data & 0xff);
}

void vezerlo (XGpio* led_disp, XGpio* sw_btn) {
//	for(;;) {
		if (!XUartLite_IsReceiveEmpty(UART_BADDR)) {
			char command[4];
			u8 stateHIST = 0;
			u8 stateNFIR = 0;
			char* wordHist = "H"; //
			char* wordNFIR = "F";
			char* LF = "\r", CR = "\n";

// TODO: A main.c-ben a parancsok jelenjenek a hf specnek megfelelően : H karakter majd (kocsi vissza + új sor) az egyes hisztogram bin-ek értéke vesszővel elválasztva.
			for(u8 i=0; i<1; i++) {
				command[i] = getchar(); //XUartLite_RecvByte(UART_BADDR);
				if ( (command[i] == *LF) || (command[i] == *CR) ) {
					i--;
					continue;
				} else if (command[i] == *(wordHist)){
					stateHIST = 1;
				} else if (command[i] == *(wordNFIR)){
					stateNFIR = 1;
				} else {
					stateHIST = 0;
					stateNFIR = 0;
				}
			}


			if(stateHIST) {
				print("Histogram command received.\nFetching data...\n");
				int temp;

				temp= XGpio_DiscreteRead(sw_btn, 1);
				usleep_MB(2000000);
				xil_printf("Red: %d\n", temp);

				temp = XGpio_DiscreteRead(sw_btn, 1);
				usleep_MB(2000000);
				xil_printf("Green: %d\n", temp);

				temp = XGpio_DiscreteRead(sw_btn, 1);
				usleep_MB(2000000);
				xil_printf("Blue: %d\n", temp);


			} else if(stateNFIR) {
				print("FIR command received.\nPlease suply data...\n");
				char temp;
				for(u8 i=0; i<4; i++){
// TODO: A fir paramétereket háziban leírtak szerint fogadjuk
					temp = getchar();
					if ( (temp == *LF) || (temp == *CR) ) {
						i--;
						continue;
					}
// TODO: A fir paramétereket átt kell alakítani
// TODO: Az együtthatók s7.8, ennek megfelelően kell trimmelni a DSP kimenetet.
					switch (i) {
						//TODO: EA8, 29. oldal: Address[7:0] = XXXXX00, ByteENable[0:3] = 0011, adatok fordított sorrendben
						//TODO: kideríteni ennek a pontos működését
						case 0: XGpio_WriteReg(XPAR_GPIO_LED_DISP_BASEADDR, GPIO_DATA2, 0x100 | temp); break;
						case 1: XGpio_WriteReg(XPAR_GPIO_LED_DISP_BASEADDR, GPIO_DATA2, 0x200 | temp); break;
						case 2: XGpio_WriteReg(XPAR_GPIO_LED_DISP_BASEADDR, GPIO_DATA2, 0x400 | temp); break;
						case 3: XGpio_WriteReg(XPAR_GPIO_LED_DISP_BASEADDR, GPIO_DATA2, 0x800 | temp); break;
						default: break;
					}
					putchar(temp);
//					XGpio_DiscreteWrite(led_disp, 2, temp & 0xff);
				}
				print("Constants are loaded.\n");

			} else {
				print("Your command was unrecognisable.\nYou typed: ");
				putchar(command[0]);
				putchar(command[1]);
				putchar(command[2]);
				putchar(command[3]);
				print(".\n");
			}
			while (!XUartLite_IsReceiveEmpty(UART_BADDR)){
				print("flushing\n");
				char c;
				c = getchar();
				putchar(c);
			}
//		}
	}


	/*while 1:
	 * if (!isUARTbuffempty())
	 * 		readBuff( ptr, 5 char)
	 * 		if (ptr == "hist\n")
	 * 			for 3 cycle
	 * 				rH = readRedHist
	 * 				print("red hist is: %d",
	 * 				gH = readRedHist
	 * 				print("green hist is: %d",
	 * 				bH = readRedHist
	 * 				print("blue hist is: %d",
	 * 		else if (ptr == nFIR\n)
	 * 	   		for 25 cycle
	 * 				temp = getdouble
	 * 				writeREG (baseaddr, temp)
	 * 		else print("unkown utasitas

	 *
	 */
}


int main() {
	// Initialization
	//GPIO peripheral structs
	XGpio led_disp;
	XGpio sw_btn;
	//UART struct

	//A periféria leíró struktúrák inicializálása.
	XGpio_Initialize(&led_disp, XPAR_GPIO_LED_DISP_DEVICE_ID);
	XGpio_Initialize(&sw_btn, XPAR_GPIO_SW_BTN_DEVICE_ID);

	for (;;)
	{
		led_disp_sub(&led_disp, &sw_btn);
		vezerlo(&led_disp, &sw_btn);
	}


	return 0;
}



