#include <stdint.h>
#include <stdbool.h>
#include "efm32gg.h"
int kvedlen = 0;
/* TIMER1 interrupt handler */
void __attribute__ ((interrupt)) TIMER1_IRQHandler()
{
	kvedlen ++;
	*TIMER1_IFC = 0x1;
	uint16_t x = 0xFF;
	uint16_t y = 0xFF;
	//if(kvedlen%8==0){
		*DAC0_CH0DATA^= y; /* right */
		*DAC0_CH1DATA^= x; /* left */
		//*GPIO_PA_DOUT^=0xFFFF;
	//}
	/*
	   TODO feed new samples to the DAC
	   remember to clear the pending interrupt by writing 1 to TIMER1_IFC
	*/
}

/* TIMER2 interrupt handler */
void __attribute__ ((interrupt)) TIMER2_IRQHandler()
{
	*TIMER2_IFC = 0x1;
	uint16_t x = 0x4F;
	uint16_t y = 0x4F;
	*DAC0_CH0DATA^= y; /* right */
	*DAC0_CH1DATA^= x; /* left */
	//*GPIO_PA_DOUT^=0xFFFF;
	/*
	   TODO feed new samples to the DAC
	   remember to clear the pending interrupt by writing 1 to TIMER1_IFC
	*/
}

/* GPIO pin interrupt handler */
void GPIO_IRQHandler(void){
	*GPIO_IFC = *GPIO_IF; /* clear interrupt flag */
	*GPIO_PA_DOUT^= (0xFF << 8);	
}

/* GPIO even pin interrupt handler */
void __attribute__ ((interrupt)) GPIO_EVEN_IRQHandler()
{	
	GPIO_IRQHandler();
	/* TODO handle button pressed event, remember to clear pending interrupt */
}

/* GPIO odd pin interrupt handler */
void __attribute__ ((interrupt)) GPIO_ODD_IRQHandler()
{
	GPIO_IRQHandler();
	/* TODO handle button pressed event, remember to clear pending interrupt */
}
