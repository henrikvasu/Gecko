.syntax unified

.include "efm32gg.s"

/////////////////////////////////////////////////////////////////////////////
//
// Exception vector table
// This table contains addresses for all exception handlers
//
/////////////////////////////////////////////////////////////////////////////

.section .vectors

	.long   stack_top               /* Top of Stack                 */
	.long   _reset                  /* Reset Handler                */
	.long   dummy_handler           /* NMI Handler                  */
	.long   dummy_handler           /* Hard Fault Handler           */
	.long   dummy_handler           /* MPU Fault Handler            */
	.long   dummy_handler           /* Bus Fault Handler            */
	.long   dummy_handler           /* Usage Fault Handler          */
	.long   dummy_handler           /* Reserved                     */
	.long   dummy_handler           /* Reserved                     */
	.long   dummy_handler           /* Reserved                     */
	.long   dummy_handler           /* Reserved                     */
	.long   dummy_handler           /* SVCall Handler               */
	.long   dummy_handler           /* Debug Monitor Handler        */
	.long   dummy_handler           /* Reserved                     */
	.long   dummy_handler           /* PendSV Handler               */
	.long   dummy_handler           /* SysTick Handler              */

	/* External Interrupts */
	.long   dummy_handler
	.long   gpio_handler            /* GPIO even handler */
	.long   main_handler		/* Main handler */
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   gpio_handler            /* GPIO odd handler */
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler
	.long   dummy_handler

.section .text
/////////////////////////////////////////////////////////////////////////////
//
// Aliases
//
/////////////////////////////////////////////////////////////////////////////

GPIO_PAB_reg .req r4
GPIO_PCB_reg .req r5

/////////////////////////////////////////////////////////////////////////////
//
// Reset handler
// The CPU will start executing here after a reset
//
/////////////////////////////////////////////////////////////////////////////

	.globl  _reset
	.type   _reset, %function
	.thumb_func
_reset: 
	//load CMU base address
 	ldr r1, =CMU_BASE

	//load current value of HFPERCLK ENABLE
	ldr r2, [r1,#CMU_HFPERCLKEN0]

	//set bit for GPIO clk
	mov r3, #1
	lsl r3, r3, #CMU_HFPERCLKEN0_GPIO
	orr r2,r2,r3

	//store new value
	str r2, [r1,#CMU_HFPERCLKEN0]

	//set drive strength
	mov r1, #0x02

	//load GPIO_PA_BASE address
	ldr GPIO_PAB_reg, =GPIO_PA_BASE 
	str r1,[GPIO_PAB_reg,#GPIO_CTRL]

	//set pins 8-15 to output
	mov r1, #0x55555555
	str r1, [GPIO_PAB_reg,#GPIO_MODEH]

	//pins 8-15 are active low, set init high
	mov r1, #0xFF00
	str r1,[GPIO_PAB_reg,#GPIO_DOUT]

	//load GPIO_PC_BASE address
	ldr GPIO_PCB_reg, =GPIO_PC_BASE
	
	//set pin 0-7 to input
	ldr r1, =#0x33333333
	str r1,[GPIO_PCB_reg,#GPIO_MODEL]

	//enable internal pull-up
	ldr r1, =#0xff
	str r1,[GPIO_PCB_reg,#GPIO_DOUT]
  	
	b main_handler
/////////////////////////////////////////////////////////////////////////////
//
// Main 
//
/////////////////////////////////////////////////////////////////////////////

main_handler:
	ldr r0, [GPIO_PCB_reg,#GPIO_DIN]		
	lsl r0,r0,#8
	str r0,[GPIO_PAB_reg,#GPIO_DOUT]
 	b main_handler
/////////////////////////////////////////////////////////////////////////////
//
// GPIO handler
// The CPU will jump here when there is a GPIO interrupt
//
/////////////////////////////////////////////////////////////////////////////

    .thumb_func
gpio_handler:  
	b .  // do nothing

/////////////////////////////////////////////////////////////////////////////

    .thumb_func
dummy_handler:  
	b .  // do nothing
