/*
 * text_mode_vga_color.c
 * Minimal driver for text mode VGA support
 * This is for Week 2, with color support
 *
 *  Created on: Oct 25, 2021
 *      Author: zuofu
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
	int index = (color/2)+0x800;
	alt_u16 rgb = 0;
	if(color%2==0){
		int i;
		for(i=1; i<=8; i=i*2){
			int temp = blue&i;
			temp = temp<<1;
			rgb = rgb + temp;
		}
		for(i=1; i<=8; i=i*2){
			int temp = green&i;
			temp = temp<<5;
			rgb = rgb + temp;
		}
		for(i=1; i<=8; i=i*2){
			int temp = red&i;
			temp = temp<<9;
			rgb = rgb + temp;
		}
		vga_ctrl->VRAM[index] = vga_ctrl[index] & 0x01ffe000;
		vga_ctrl->VRAM[index] = vga_ctrl[index]+ rgb;
	}

	if(color%2==1){
		int i;
		for(i=1; i<=8; i=i*2){
			int temp = blue&i;
			temp = temp<<13;
			rgb = rgb + temp;
		}
		for(i=1; i<=8; i=i*2){
			int temp = green&i;
			temp = temp<<17;
			rgb = rgb + temp;
		}
		for(i=1; i<=8; i=i*2){
			int temp = red&i;
			temp = temp<<21;
			rgb = rgb + temp;
		}
		vga_ctrl->VRAM[index] = vga_ctrl[index] & 0x00001ffe;
		vga_ctrl->VRAM[index] = vga_ctrl[index]+ rgb;
	}

}


void textVGAColorScreenSaver()
{
	//This is the function you call for your week 2 demo
	char color_string[80];
    int fg, bg, x, y;
	textVGAColorClr();
	//initialize palette
	for (int i = 0; i < 16; i++)
	{
		setColorPalette (i, colors[i].red, colors[i].green, colors[i].blue);
	}
	while (1)
	{
		fg = rand() % 16;
		bg = rand() % 16;
		while (fg == bg)
		{
			fg = rand() % 16;
			bg = rand() % 16;
		}
		sprintf(color_string, "Drawing %s text with %s background", colors[fg].name, colors[bg].name);
		x = rand() % (80-strlen(color_string));
		y = rand() % 30;
		textVGADrawColorText (color_string, x, y, bg, fg);
		usleep (100000);
	}
}
