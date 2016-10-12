#include <stdint.h>
#include <stdbool.h>
#include "timer.h"
#include "efm32gg.h"
#include "notes.h"

int loops = 0;
/* function to setup the timer */
void setupTimer1(uint16_t period)
{
	*CMU_HFPERCLKEN0 |= CMU2_HFPERCLKEN0_TIMER1; /* enable clock timer */
	*TIMER1_TOP = period; /* setting period */
	*TIMER1_IEN = 0x1; /* enable timer interrupt generation */
	*TIMER1_CMD = 0x1; /* start the timer */
	
	/*
	   TODO enable and set up the timer

	   1. Enable clock to timer by setting bit 6 in CMU_HFPERCLKEN0
	   2. Write the period to register TIMER1_TOP
	   3. Enable timer interrupt generation by writing 1 to TIMER1_IEN
	   4. Start the timer by writing 1 to TIMER1_CMD

	   This will cause a timer interrupt to be generated every (period) cycles. Remember to configure the NVIC as well, otherwise the interrupt handler will not be invoked.
	 */
}

/* function to set up timer 2, takes number of seconds as input */
void setupTimer2(uint16_t seconds)
{
	loops = 2*seconds*sampleRate/0xFFFF;
	*CMU_HFPERCLKEN0 |= CMU2_HFPERCLKEN0_TIMER2; /* enable clock timer */
	*TIMER2_TOP = 0xFFFF; /* setting period */
	*TIMER2_IEN = 0x1; /* enable timer interrupt generation */
	*TIMER2_CMD = 0x1; /* start the timer */
}

/* function to stop the timer */
void stopTimer1(void)
{	
	*CMU_HFPERCLKEN0 &= ~CMU2_HFPERCLKEN0_TIMER1; /* disable clock timer */
	*TIMER1_CMD = 0x0; /* stop the timer */
}

void stopTimer2(void)
{
	*CMU_HFPERCLKEN0 &= ~CMU2_HFPERCLKEN0_TIMER2; /* disable clock timer */
	*TIMER2_CMD = 0x0; /* stop the timer */
}

