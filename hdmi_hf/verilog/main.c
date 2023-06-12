//******************************************************************************
//* GPIO perifĂ©riĂˇk kezelĂ©se magasszintĹ± eszkĂ¶zmeghajtĂłval.                    *
//******************************************************************************
#include <xparameters.h>
#include <xgpio.h>
#include <xil_printf.h>
#include <sleep.h>
#include <stdio.h>
#include <xuartlite_l.h>
#include <xparameters.h>
#include <mb_interface.h>
#include <stdio.h>

#define GPIO_DATA1 0x00
#define GPIO_DATA2 0x08
#define UART_BADDR XPAR_UARTLITE_BASEADDR
#define HIST_ADDR XPAR_FIR_AXI_IF_0_BASEADDR
#define FIR_ADDR XPAR_FIR_AXI_IF_0_BASEADDR
#define MEM32(addr)   (*(volatile unsigned long *)(addr))


//void led_disp_sub(XGpio* led_disp, XGpio* sw_btn) {
//	unsigned long sw_data, btn_data, disp_data;
//	//Reading the states of the swithes and buttons
//	sw_data = XGpio_DiscreteRead(sw_btn, 1);
//	btn_data = XGpio_DiscreteRead(sw_btn, 2);
//	//...Ă©s megjelenĂ­tĂ©se a piros LED-eken.
//	switch (btn_data) {
//		case 1: disp_data = sw_data | 0x100; break;
//		case 2: disp_data = sw_data | 0x200; break;
//		case 4: disp_data = sw_data | 0x400; break;
//		case 8: disp_data = sw_data | 0x800; break;
//		default: break;
//	}
//
//	XGpio_WriteReg(XPAR_GPIO_LED_DISP_BASEADDR, GPIO_DATA2, disp_data);
//	//XGpio_DiscreteWrite(led_disp, 2, disp_data);
//	XGpio_DiscreteWrite(led_disp, 1, sw_data & 0xff);
//}

void hisztogram () {
	print("Histogram command received.\nFetching data...\n");
	int temp;
	for(u32 j=0; j<256; j++){
		temp= MEM32(HIST_ADDR);
		if (j!=0) xil_printf(",");
		xil_printf("%d", temp);
		xil_printf("\n%d\n", j);
	}
	print("\r\nHistogram finished!\n\n");
}

unsigned char fir_filler() {
	print("FIR command received.\nLoading constants...\n");
	char temp;
	unsigned char integer_part [3] = {0};
	unsigned char fraction_part [7] = {0};
	unsigned char no_int = 0, no_frac = 0, coeff_read_finish = 0, state = 0;
	signed char sign = 0;
	char* neg_sign = "-"; //
	char* pos_sign = "+";
	char* period = ".";
	char* zero_char = "0";
	char* nine_char = "9";
	char* LF = "\r";
	char* CR = "\n";


// TODO: A fir paramĂ©tereket hĂˇziban leĂ­rtak szerint fogadjuk
// TODO: A fir paramĂ©tereket Ăˇtt kell alakĂ­tani
// TODO: Az egyĂĽtthatĂłk s7.8, ennek megfelelĹ‘en kell trimmelni a DSP kimenetet.
//TODO: EA8, 29. oldal: Address[7:0] = XXXXX00, ByteENable[0:3] = 0011, adatok fordĂ­tott sorrendben
//TODO: kiderĂ­teni ennek a pontos mĹ±kĂ¶dĂ©sĂ©t
	
	temp = getchar();
	if ( (temp == *LF) || (temp == *CR) ) return 1;
	else if ( temp == *neg_sign ) { sign = -1;}
	else if ( temp == *pos_sign ) { sign =  1;}

	for(u8 j=0; j<3; j++){
		while(!coeff_read_finish) {
			coeff_read_finish = 0;
			temp = getchar();
			switch (state) {
				case 0:
					if ( (temp == *LF) || (temp == *CR) ) { return 1; }
					else if ( ( temp - *zero_char ) > 0 && ( *nine_char - temp ) > 0 ) { integer_part[no_int] = temp - *zero_char; no_int++; }
					else if ( (temp == *period) ) { state++;}
					// else { error }
					continue;

				case 1:
					if ( (temp == *LF) || (temp == *CR) ) { return 1; }
					else if ( ( temp - *zero_char ) > 0 && ( *nine_char - temp ) > 0 ) { fraction_part[no_frac] = temp - *zero_char; no_frac++; }
					else if ( temp == *neg_sign ) { sign = -1; state = 0; break; }
					else if ( temp == *pos_sign ) { sign =  1; state = 0; break;}
					// else { error }
					continue;

				default: continue;
			}

			signed long int coeff = 0;
			unsigned char minus_egy_temp = 0xFF;

			for(u8 i=0; i<no_int; i++) { coeff = (coeff * 10) + (sign * integer_part[i]); }

			for(u8 i=0; i<no_frac; i++) { coeff = (coeff * 10) + (minus_egy_temp * integer_part[i]); }

			for(u8 i=0; i<2; i++)
				if (no_frac>0){
					coeff = coeff / 10;
					coeff = coeff << 4;
					no_frac--;
				}

			while (no_frac) { coeff = coeff / 10; }

			MEM32(FIR_ADDR + (j<<2) ) = coeff;
		}
	}
	print("Constants are loaded.\n");
	return 0;
}

unsigned char fir_controller_func () {
	//	for(;;) {
		if (!XUartLite_IsReceiveEmpty(UART_BADDR)) {
			char command = 0;
			u8 stateHIST = 0;
			u8 stateNFIR = 0;
			char* wordHist = "H"; //
			char* wordNFIR = "F";
			char* LF = "\r";
			char* CR = "\n";

	// TODO: A main.c-ben a parancsok jelenjenek a hf specnek megfelelĹ‘en : H karakter majd (kocsi vissza + Ăşj sor) az egyes hisztogram bin-ek Ă©rtĂ©ke vesszĹ‘vel elvĂˇlasztva.
			for(u8 i=0; i<1; i++) {
				command = getchar(); //XUartLite_RecvByte(UART_BADDR);
				if ( (command == *LF) || (command == *CR) ) {
					i--;
					continue;
				} else if (command == *(wordHist)){
					hisztogram ();
				} else if (command == *(wordNFIR)){
					fir_filler();
				} else {
					print("Your command was unrecognisable.\nYou typed: ");
					putchar(command);
					print(".\n");
				}
			}

			}
			while (!XUartLite_IsReceiveEmpty(UART_BADDR)){
				print("flushing\n");
				char c;
				c = getchar();
				putchar(c);
				print("\n");
			}
			return 0;
//		}
}
//
//void vezerlo (XGpio* led_disp, XGpio* sw_btn) {
//	//	for(;;) {
//		if (!XUartLite_IsReceiveEmpty(UART_BADDR)) {
//			char command[4];
//			u8 stateHIST = 0;
//			u8 stateNFIR = 0;
//			char* wordHist = "H"; //
//			char* wordNFIR = "F";
//			char* LF = "\r", CR = "\n";
//
//	// TODO: A main.c-ben a parancsok jelenjenek a hf specnek megfelelĹ‘en : H karakter majd (kocsi vissza + Ăşj sor) az egyes hisztogram bin-ek Ă©rtĂ©ke vesszĹ‘vel elvĂˇlasztva.
//			for(u8 i=0; i<1; i++) {
//				command[i] = getchar(); //XUartLite_RecvByte(UART_BADDR);
//				if ( (command[i] == *LF) || (command[i] == *CR) ) {
//					i--;
//					continue;
//				} else if (command[i] == *(wordHist)){
//					stateHIST = 1;
//				} else if (command[i] == *(wordNFIR)){
//					stateNFIR = 1;
//				} else {
//					stateHIST = 0;
//					stateNFIR = 0;
//				}
//			}
//
//
//			if(stateHIST) {
//				print("Histogram command received.\nFetching data...\n");
//				int temp;
//
//				temp= XGpio_DiscreteRead(sw_btn, 1);
//				usleep_MB(2000000);
//				xil_printf("Red: %d\n", temp);
//
//				temp = XGpio_DiscreteRead(sw_btn, 1);
//				usleep_MB(2000000);
//				xil_printf("Green: %d\n", temp);
//
//				temp = XGpio_DiscreteRead(sw_btn, 1);
//				usleep_MB(2000000);
//				xil_printf("Blue: %d\n", temp);
//
//
//			} else if(stateNFIR) {
//				print("FIR command received.\nPlease suply data...\n");
//				char temp;
//				for(u8 i=0; i<4; i++){
//// TODO: A fir paramĂ©tereket hĂˇziban leĂ­rtak szerint fogadjuk
//					temp = getchar();
//					if ( (temp == *LF) || (temp == *CR) ) {
//						i--;
//						continue;
//					}
//// TODO: A fir paramĂ©tereket Ăˇtt kell alakĂ­tani
//// TODO: Az egyĂĽtthatĂłk s7.8, ennek megfelelĹ‘en kell trimmelni a DSP kimenetet.
//					switch (i) {
//						//TODO: EA8, 29. oldal: Address[7:0] = XXXXX00, ByteENable[0:3] = 0011, adatok fordĂ­tott sorrendben
//						//TODO: kiderĂ­teni ennek a pontos mĹ±kĂ¶dĂ©sĂ©t
//						case 0: XGpio_WriteReg(XPAR_GPIO_LED_DISP_BASEADDR, GPIO_DATA2, 0x100 | temp); break;
//						case 1: XGpio_WriteReg(XPAR_GPIO_LED_DISP_BASEADDR, GPIO_DATA2, 0x200 | temp); break;
//						case 2: XGpio_WriteReg(XPAR_GPIO_LED_DISP_BASEADDR, GPIO_DATA2, 0x400 | temp); break;
//						case 3: XGpio_WriteReg(XPAR_GPIO_LED_DISP_BASEADDR, GPIO_DATA2, 0x800 | temp); break;
//						default: break;
//					}
//					putchar(temp);
////					XGpio_DiscreteWrite(led_disp, 2, temp & 0xff);
//				}
//				print("Constants are loaded.\n");
//
//			} else {
//				print("Your command was unrecognisable.\nYou typed: ");
//				putchar(command[0]);
//				putchar(command[1]);
//				putchar(command[2]);
//				putchar(command[3]);
//				print(".\n");
//			}
//			while (!XUartLite_IsReceiveEmpty(UART_BADDR)){
//				print("flushing\n");
//				char c;
//				c = getchar();
//				putchar(c);
//			}
////		}
//	}


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
//}


int main() {
	// Initialization
	//GPIO peripheral structs
	XGpio led_disp;
	XGpio sw_btn;
	//UART struct

	//A perifĂ©ria leĂ­rĂł struktĂşrĂˇk inicializĂˇlĂˇsa.
	XGpio_Initialize(&led_disp, XPAR_GPIO_LED_DISP_DEVICE_ID);
	XGpio_Initialize(&sw_btn, XPAR_GPIO_SW_BTN_DEVICE_ID);

	for (;;)
	{
		//led_disp_sub(&led_disp, &sw_btn);
		//vezerlo(&led_disp, &sw_btn);
		fir_controller_func();
	}


	return 0;
}



