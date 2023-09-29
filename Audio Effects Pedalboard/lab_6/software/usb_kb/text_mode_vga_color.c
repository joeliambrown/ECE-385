/*
 * text_mode_vga_color.c
 * Minimal driver for text mode VGA support
 * This is for Week 2, with color support
 *
 *  Created on: Oct 25, 2021
 *      Author: zuofu
 *
 *  Original VGA Support code structure altered for use as 
 *  main function in guitar effects pedal: November 14, 2022
 *  	Author: Joseph Brown
 */

#include <system.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <alt_types.h>
#include "text_mode_vga_color.h"

void textVGAColorClr()
{
	for (int i = 0; i<(ROWS*COLUMNS) * 2; i++)
	{
		vga_ctrl->VRAM[i] = 0x00;
	}
}

void textVGADrawColorText(char* str, int x, int y, alt_u8 background, alt_u8 foreground)
{
	int i = 0;
	while (str[i]!=0)
	{
		vga_ctrl->VRAM[(y*COLUMNS + x + i) * 2] = foreground << 4 | background;
		vga_ctrl->VRAM[(y*COLUMNS + x + i) * 2 + 1] = str[i];
		i++;
	}
}

void setColorPalette (alt_u8 color, alt_u8 red, alt_u8 green, alt_u8 blue)
{
	alt_u32 current = vga_ctrl->PALETTE[color/2];
	if(color%2 == 0){
		current &=0xffffe000;
		current += ( (red<<9) + (green<<5) + (blue<<1));
	}
	else{
		current &= 0x00001fff;
		current += ((red<<21) + (green<<17) + (blue<<13));
	}
	vga_ctrl->PALETTE[color/2] = current;
}


void textVGAColorScreenSaver()
{	//This is the function you call for your week 2 demo
	typedef struct{
		unsigned int volatile data;
		unsigned int volatile direction;
		unsigned int volatile intterupt_mask;
		unsigned int volatile dontcare;
	}NIOS_PIO_t;

	NIOS_PIO_t *SW_PIO = (NIOS_PIO_t*)0x230;
	NIOS_PIO_t *KEY0_PIO = (NIOS_PIO_t*)0x220;
	NIOS_PIO_t *KEY1_PIO = (NIOS_PIO_t*)0x210;
	int key0_pressed = 0;
	int key1_pressed = 0;

	int gain_level = 0;
	int bitcrush_level = 0;
	int overdr_level = 0;
	int tremolo_level = 0;
	int delay_level = 0;
	int lowpass_level = 0;
	int mask[10];

	char color_string[80];
	int fg, bg, x_1, x_2, gain_y, bitcrush_y, overdr_y, tremolo_y, delay_y, lowpass_y;
	textVGAColorClr();
	fg = 1;
	bg = 6;
	x_1 = 10;
	x_2 = 50;
	gain_y = 6;
	bitcrush_y = 14;
	overdr_y = 22;
	delay_y = 6;
	tremolo_y = 14;
	lowpass_y = 22;

	for (int i = 0; i < 16; i++)
		{
			setColorPalette (i, colors[i].red, colors[i].green, colors[i].blue);
		}
	//initialize palette
	while(1){
		//create a bitmask for the switches
		int i;
		int temp = SW_PIO->data;
		for(i=0; i<10; i++){
			mask[i] = temp%2;
			temp = temp/2;
		}
		int select = (mask[9]*4)+(mask[8]*2)+mask[7];
		//check if up button has been pressed and update values accordingly
		if(KEY0_PIO->data == 1 && key0_pressed == 0){
			key0_pressed = 1;
			if(select==0 && gain_level<3){
				gain_level = gain_level+1;
			}
			if(select==1 && bitcrush_level<7){
				bitcrush_level = bitcrush_level+1;
			}
			if(select==2 && overdr_level<7){
				overdr_level = overdr_level+1;
			}
			if(select==3 && delay_level<7){
				delay_level = delay_level+1;
			}
			if(select==4 && tremolo_level<3){
				tremolo_level = tremolo_level+1;
			}
			if(select==5 && lowpass_level<3){
				lowpass_level = lowpass_level+1;
			}
		}
		//check if down button has been pressed and update values accordingly
		if(KEY1_PIO->data == 1 && key1_pressed == 0){
			key1_pressed = 1;
			if(select==0 && gain_level>0){
				gain_level = gain_level-1;
			}
			if(select==1 && bitcrush_level>0){
				bitcrush_level = bitcrush_level-1;
			}
			if(select==2 && overdr_level>0){
				overdr_level = overdr_level-1;
			}
			if(select==3 && delay_level>0){
				delay_level = delay_level-1;
			}
			if(select==4 && tremolo_level>0){
				tremolo_level = tremolo_level-1;
			}
			if(select==5 && lowpass_level>0){
				lowpass_level = lowpass_level-1;
			}
		}

		//gain display
		if(mask[0]==0){
			sprintf(color_string, "Gain Level: OFF");
			textVGADrawColorText (color_string, x_1, gain_y, bg, fg);
		}
		else if(gain_level==3){
			sprintf(color_string, "Gain Level: MAX");
			textVGADrawColorText (color_string, x_1, gain_y, bg, fg);

		}
		else{
			sprintf(color_string, "Gain Level: %d  ", gain_level);
			textVGADrawColorText (color_string, x_1, gain_y, bg, fg);
		}

		//bitcrusher display
		if(mask[1]==0){
			sprintf(color_string, "Bitcrush Level: OFF");
			textVGADrawColorText (color_string, x_1, bitcrush_y, bg, fg);
		}
		else if(bitcrush_level==7){
			sprintf(color_string, "Bitcrush Level: MAX");
			textVGADrawColorText (color_string, x_1, bitcrush_y, bg, fg);

		}
		else{
			sprintf(color_string, "Bitcrush Level: %d  ", bitcrush_level+1);
			textVGADrawColorText (color_string, x_1, bitcrush_y, bg, fg);
		}
		//overdrive display
		if(mask[2]==0){
			sprintf(color_string, "Overdrive Level: OFF");
			textVGADrawColorText (color_string, x_1, overdr_y, bg, fg);
		}
		else if(overdr_level==7){
			sprintf(color_string, "Overdrive Level: MAX");
			textVGADrawColorText (color_string, x_1, overdr_y, bg, fg);

		}
		else{
			sprintf(color_string, "Overdrive Level: %d  ", overdr_level+1);
			textVGADrawColorText (color_string, x_1, overdr_y, bg, fg);
		}
		//delay display
		if(mask[3]==0){
			sprintf(color_string, "Delay Level: OFF");
			textVGADrawColorText (color_string, x_2, delay_y, bg, fg);
		}
		else if(delay_level==7){
			sprintf(color_string, "Delay Level: MAX");
			textVGADrawColorText (color_string, x_2, delay_y, bg, fg);

		}
		else{
			sprintf(color_string, "Delay Level: %d  ", delay_level+1);
			textVGADrawColorText (color_string, x_2, delay_y, bg, fg);
		}
		//tremolo display
		if(mask[4]==0){
			sprintf(color_string, "Tremolo Level: OFF");
			textVGADrawColorText (color_string, x_2, tremolo_y, bg, fg);
		}
		else if(tremolo_level==3){
			sprintf(color_string, "Tremolo Level: MAX");
			textVGADrawColorText (color_string, x_2, tremolo_y, bg, fg);

		}
		else{
			sprintf(color_string, "Tremolo Level: %d  ", tremolo_level+1);
			textVGADrawColorText (color_string, x_2, tremolo_y, bg, fg);
		}

		//lowpass display
		if(mask[5]==0){
			sprintf(color_string, "Low Pass Level: OFF");
			textVGADrawColorText (color_string, x_2, lowpass_y, bg, fg);
		}
		else if(lowpass_level==3){
			sprintf(color_string, "Low Pass Level: MAX");
			textVGADrawColorText (color_string, x_2, lowpass_y, bg, fg);

		}
		else{
			sprintf(color_string, "Low Pass Level: %d  ", lowpass_level+1);
			textVGADrawColorText (color_string, x_2, lowpass_y, bg, fg);
		}

		if(KEY0_PIO->data == 0 && key0_pressed == 1){
			key0_pressed = 0;
		}
		if(KEY1_PIO->data == 0 && key1_pressed == 1){
			key1_pressed = 0;
		}
	}


}
