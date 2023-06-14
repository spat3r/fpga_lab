//*****************************************************
//* FIR szuro kezelese magasszintu eszkozmeghajtoval. *
//*****************************************************
#include <xparameters.h>
#include <xgpio.h>
#include <xil_printf.h>
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

unsigned char fir_temp[512] = {0};
int max_pointer = 0;
int curr_pointer = 0;

void hisztogram () {
	print("Histogram command received.\nFetching data...\n");
	int temp;
	for(u32 j=0; j<256; j++){
		temp = MEM32(HIST_ADDR);
		xil_printf("%d", temp);
		if (j!=255) xil_printf(",");
	}
	print("\r\nHistogram finished!\n\n");
}

unsigned char fir_filler() {
	print("FIR command received.\nLoading constants...\n");
	char temp = 0;
	int no_coeff_inread = 0;
	unsigned char integer_part [3] = {0};
	unsigned char fraction_part [7] = {0};
	unsigned char no_int = 0, no_frac = 0, coeff_read_finish = 0, state = 0;
	signed char sign = 0;
	char* neg_sign = "-"; //
	char* pos_sign = "+";
	char* period = ".";
	char* comma = ",";
	char* zero_char = "0";
	char* nine_char = "9";
	char* LF = "\r";
	char* CR = "\n";


	for(u8 j=0; j<25; j++) {
		while ( (temp != *LF) & (temp != *CR)) {
			temp = getchar();
			if (temp == *comma){
				no_coeff_inread++;
				break;
			}
			fir_temp[curr_pointer] = temp;
			curr_pointer++;
		}
	}
	max_pointer = curr_pointer;
	curr_pointer = 0;
	
	temp = fir_temp[curr_pointer]; curr_pointer++;
	if ( (temp == *LF) || (temp == *CR) ) return 1;
	else if ( temp == *neg_sign ) { sign = -1;}
	else if ( temp == *pos_sign ) { sign =  1;}

	for(u8 j=0; j<25; j++){
		coeff_read_finish = 0;
		while(!coeff_read_finish) {
			coeff_read_finish = 0;
			temp = fir_temp[curr_pointer]; curr_pointer++;
			switch (state) {
				case 0:
					if ( (temp == *LF) || (temp == *CR) ) { return 1; }
					else if ( ( temp - *zero_char ) > 0 && ( *nine_char - temp ) > 0 ) { integer_part[no_int] = temp - *zero_char; no_int++; }
					else if ( (temp == *period) ) { state++;}
					continue;

				case 1:
					if ( (temp == *LF) || (temp == *CR) ) { return 1; }
					else if ( ( temp - *zero_char ) > 0 && ( *nine_char - temp ) > 0 ) { fraction_part[no_frac] = temp - *zero_char; no_frac++; }
					else if ( temp == *neg_sign ) { sign = -1; state = 0; break; }
					else if ( temp == *pos_sign ) { sign =  1; state = 0; break;}
					continue;

				default: continue;
			}

			signed long int coeff = 0;
			signed long int coeff_frac = 0; // 0.1
			signed long int egy_temp_24b = 0x01000000;// 1.0 on s1.24bits

			for(u8 i=0; i<no_int; i++) { coeff = (coeff * 10) + (sign * integer_part[i]); }

			for(u8 i=0; i<no_frac; i++) { coeff_frac = (coeff_frac / 10) + (egy_temp_24b * fraction_part[no_frac-i-1]); }
			coeff_frac = ( (sign * coeff_frac) / 10);
			coeff_frac = coeff_frac >> 16;


			coeff = coeff << 8;
			coeff = coeff & 0x0000ff00;
			coeff_frac = coeff_frac & 0x000000ff;
			coeff = coeff | coeff_frac;

			MEM32(FIR_ADDR + (j<<2) ) = coeff;
			coeff_read_finish = 1;
			no_int = 0;
			no_frac = 0;
		}
	}
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

			for(u8 i=0; i<1; i++) {
				command = getchar();
				if ( (command == *LF) || (command == *CR) ) {
					i--;
					continue;
				} else if (command == *(wordHist)){
					hisztogram ();
				} else if (command == *(wordNFIR)){
					fir_filler();
					xil_printf("Constants are loaded.\n");
				} else {
					print("Your command was unrecognisable.\nYou typed: ");
					putchar(command);
					print(".\n");
					print("flushing input:\n");
					while (!XUartLite_IsReceiveEmpty(UART_BADDR)){
						char c;
						c = getchar();
						putchar(c);
					}
					print("\n\n");
					break;
				}
			}
		}
		return 0;
}



int main() {
	// // Initialization
	// //GPIO peripheral structs
	// XGpio led_disp;
	// XGpio sw_btn;
	// //UART struct

	// //A periféria leíró struktúrák inicializálása.
	// XGpio_Initialize(&led_disp, XPAR_GPIO_LED_DISP_DEVICE_ID);
	// XGpio_Initialize(&sw_btn, XPAR_GPIO_SW_BTN_DEVICE_ID);

	for (;;)
	{
		fir_controller_func();
	}


	return 0;
}


