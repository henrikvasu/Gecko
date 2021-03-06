#include <stdint.h>
#include <stdbool.h>

#include "efm32gg.h"

void setupDAC()
{
	*CMU_HFPERCLKEN0 |= CMU2_HFPERCLKEN0_DAC0; /* enable DAC clock */
	*DAC0_CTRL = 0x50010; /* prescale DAC clock */
	*DAC0_CH0CTRL = 0x1; /* enable left audio channel */
	*DAC0_CH1CTRL = 0x1; /* enable right audio channel */
	/*
	   TODO enable and set up the Digital-Analog Converter

	   1. Enable the DAC clock by setting bit 17 in CMU_HFPERCLKEN0
	   2. Prescale DAC clock by writing 0x50010 to DAC0_CTRL
	   3. Enable left and right audio channels by writing 1 to DAC0_CH0CTRL and DAC0_CH1CTRL
	   4. Write a continuous stream of samples to the DAC data registers, DAC0_CH0DATA and DAC0_CH1DATA, for example from a timer interrupt
	 */
}

void stopDAC()
{
	*CMU_HFPERCLKEN0 &= ~CMU2_HFPERCLKEN0_DAC0; /* disable DAC clock */
	*DAC0_CH0CTRL = 0x0; /* enable left audio channel */
	*DAC0_CH1CTRL = 0x0; /* enable right audio channel */
	
}
