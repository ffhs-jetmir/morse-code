.section .data
.equ GPFSEL2, 0xff200000


.section .text
.global _start
_start: //Start method only works with emulator
    mov r1,#0
    ldr r0,=GPFSEL2
    str r1,[r0]
	b main

//r5 was selected randomly

initialise_DOT:
   mov r2,#3
   mov r1,#1 //truns led on
   str r1,[r0] //writes led
   bx lr
   
   
initialise_DASH:
   mov r2,#6
   mov r1,#1
   str r1,[r0]
   bx lr
   
initialise_OFF:
   mov r2,#1 //This is usally like dot
   mov r1,#0
   str r1,[r0]
   bx lr
   
execute_WAIT:
   sub r2,#1
   cmp r2,#0   
   bne execute_WAIT
   bx lr
  
morse_DOT:
   mov r5,lr
   bl initialise_DOT
   bl execute_WAIT
   bl initialise_OFF
   bl execute_WAIT
   bx r5
   
morse_DASH:
   mov r5,lr
   bl initialise_DASH
   bl execute_WAIT
   bl initialise_OFF
   bl execute_WAIT
   bx r5

main:
	bl morse_DOT
	bl morse_DASH