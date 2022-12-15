// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng


int main()
{
	int i = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x70; //make a pointer to access the PIO block

	*LED_PIO = 0; //clear all LEDs
	while ( (1+1) != 3) //infinite loop
	{
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO |= 0x1; //set LSB
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO &= ~0x1; //clear LSB
	}
	return 1; //never gets here
}


#include <math.h>

int main()
{
	typedef struct{
		unsigned int volatile data;
		unsigned int volatile direction;
		unsigned int volatile intterupt_mask;
		unsigned int volatile dontcare;
	}NIOS_PIO_t;

	NIOS_PIO_t *LED_PIO = (NIOS_PIO_t*)0x70; //make a pointer to access the LED block
	NIOS_PIO_t *SW_PIO = (NIOS_PIO_t*)0x60; //make a pointer to access the SW block
	NIOS_PIO_t *ACC = (NIOS_PIO_t*)0x50; //make a pointer to access the Accumulate block


	LED_PIO->data &= 0x00;//clear all LEDs
	unsigned int pressfinish = 0;
	while(1>0){
		if(ACC->data == 0 && pressfinish == 0){
			unsigned int new_num = 0;

			new_num = LED_PIO->data + SW_PIO->data;
			while(new_num > 255){
				new_num = new_num - 256;
			}
			LED_PIO->data = new_num;
			pressfinish = 1;
		}

		if (ACC->data == 1) {
			pressfinish = 0;
		}
	}

	return 1;//never get here
}


