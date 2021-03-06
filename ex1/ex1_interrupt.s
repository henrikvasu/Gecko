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
	.long   dummy_handler 
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
GPIO_BASE_reg .req r6

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
	//register init
	ldr GPIO_PAB_reg, =GPIO_PA_BASE
	ldr GPIO_PCB_reg, =GPIO_PC_BASE
	ldr GPIO_BASE_reg, =GPIO_BASE

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

	//set high drive strength
	mov r1, #0x02
	str r1, [GPIO_PAB_reg,#GPIO_CTRL]

	//set pins 8-15 (leds) on port C to output
	mov r1, #0x55555555
	str r1, [GPIO_PAB_reg,#GPIO_MODEH]

	//leds are active low, init high
	mov r1, #0xFF00
	str r1, [GPIO_PAB_reg,#GPIO_DOUT]

	//set pins 0-7 on port A to input
	ldr r1, =#0x33333333
	str r1, [GPIO_PCB_reg,#GPIO_MODEL]

	//enable internal pull-up
	mov r1, #0xFF
	str r1, [GPIO_PCB_reg,#GPIO_DOUT]
  	
	b interrupt_init
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//
// Interrupt initialization
//
/////////////////////////////////////////////////////////////////////////////
	.thumb_func
interrupt_init:
	//write to GPIO_EXTIPSELL
	mov r1, #0x22222222	
	str r1, [GPIO_BASE_reg,#GPIO_EXTIPSELL]

	mov r1, #0xFF
	//set interrupt transition 1->0
	str r1, [GPIO_BASE_reg,#GPIO_EXTIFALL]

	//set interrupt transistion 0->1
	str r1, [GPIO_BASE_reg,#GPIO_EXTIRISE]

	//enable interrupt generation
	str r1, [GPIO_BASE_reg,#GPIO_IEN]

	//enable interrupt handling
	ldr r1, =0x802
	ldr r2, =ISER0
	str r1, [r2]

	b main
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//
// GPIO handler
// The CPU will jump here when there is a GPIO interrupt
//
/////////////////////////////////////////////////////////////////////////////
	.thumb_func
gpio_handler:
	//read interrupt register and clear interrupt  
	ldr r1, [GPIO_BASE_reg,#GPIO_IF]
	str r1, [GPIO_BASE_reg,#GPIO_IFC]

	//read input pins and set leds	
	ldr r0, [GPIO_PCB_reg,#GPIO_DIN]		
	lsl r0,r0,#8
	str r0, [GPIO_PAB_reg,#GPIO_DOUT]
	bx lr		
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//
// Main 
//
/////////////////////////////////////////////////////////////////////////////
	.thumb_func
main:
	//turn off SRAM
	mov r0, #0x7
	ldr r1, =EMU_BASE
	str r0,[r1,#EMU_MEMCTRL]		

	//enable deep sleep
	mov r0, #0x6
	ldr r1, =SCR
	str r0, [r1]
	wfi
/////////////////////////////////////////////////////////////////////////////

    .thumb_func
dummy_handler:  
	b .  // do nothing
