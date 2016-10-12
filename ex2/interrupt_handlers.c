#include <stdint.h>
#include <stdbool.h>
#include "efm32gg.h"
#include "timer.h"
#include "notes.h"
#include "dac.h"

int cnt = 0;
int notenumber = 0;
int int_flag = 0;
/* TIMER1 interrupt handler */
void __attribute__ ((interrupt)) TIMER1_IRQHandler()
{
	*TIMER1_IFC = 0x1;
	uint16_t x = 0x5F;
	uint16_t y = 0x5F;
	*DAC0_CH0DATA^= y; /* right */
	*DAC0_CH1DATA^= x; /* left */
	/*
	   TODO feed new samples to the DAC
	   remember to clear the pending interrupt by writing 1 to TIMER1_IFC
	*/
}

/* TIMER2 interrupt handler */
void __attribute__ ((interrupt)) TIMER2_IRQHandler()
{
	*TIMER2_IFC = 0x1;
	if(cnt%loops==0)
	{	
		/*notenumber++;
		if(notenumber == 3){
			stopTimer1();
			stopTimer2();
			stopDAC();
			notenumber = 0;
		}
		else {
			setupTimer1(notenumber);
			//setupTimer2(melody1.note_length[notenumber]);
		}
		int_flag=1;*/
	}
	cnt++;
}

/* GPIO pin interrupt handler */
void GPIO_IRQHandler(void){
	*GPIO_IFC = *GPIO_IF; /* clear interrupt flag */
	*SCR=0x00;
	uint8_t buttonPressed=0;
	while((*GPIO_PC_DIN&(1<<buttonPressed))){
		buttonPressed++;
	}
	
	playMelody(2);
	//int i;
	//for (i=0;i<8;i++){
	//setupDAC();
	//setupTimer1(notesFreqs[i]);		
 	//setupTimer2(2);
	//while(!int_flag){}
	//int_flag=0;
	//}
	//*GPIO_PA_DOUT = (*GPIO_PC_DIN << 8);	
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
