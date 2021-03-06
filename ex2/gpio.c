#include <stdint.h>
#include <stdbool.h>
#include "gpio.h"
#include "efm32gg.h"

/* function to set up GPIO mode and interrupts*/
void setupGPIO()
{
	/* TODO set input and output pins for the joystick */

	/* Example of HW access from C code: turn on joystick LEDs D4-D8
	   check efm32gg.h for other useful register definitions
	 */
	*CMU_HFPERCLKEN0 |= CMU2_HFPERCLKEN0_GPIO;	/* enable GPIO clock */
	*GPIO_PA_CTRL = 2;	/* set high drive strength */
	*GPIO_PA_MODEH = 0x55555555;	/* set pins A8-15 as output */
	*GPIO_PA_DOUT = 0xFF00;	/* turn off LEDs (LEDs are active low) */

	*GPIO_PC_MODEL = 0x33333333; /* set pins C0-7 as input */
	*GPIO_PC_DOUT = 0xFF; /* enable internal pull-up */

	*GPIO_EXTIPSELL = 0x22222222;
	*GPIO_EXTIFALL = 0xFF; /* enable interrupt on falling edge */
	//*GPIO_EXTIRISE = 0xFF; /* enable interrupt on rising edge */
	*GPIO_IEN = 0xFF; /* enable interrupt generation */
}
