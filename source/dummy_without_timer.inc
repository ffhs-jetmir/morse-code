.global _start
_start: b main

//r5 was selected randomly

initialise_DOT:
   mov r2,#3
   bx lr
   
initialise_DASH:
   mov r2,#6
   bx lr
   
initialise_OFF:
   mov r2,#1 //This is usally like dot
   bx lr
   
execute_WAIT:
   sub r2,#3
   cmp r2,#0   
   bne execute_WAIT
   bx lr
  
morse_DOT:
   mov r5,lr
   bl initialise_DOT
   bl execute_WAIT
   //Because we turn the pin off again, we need to do a minus 1 on BETWEEN_LETTERS and BETWEEN_WORDS
   bl initialise_OFF
   bl execute_WAIT
   bx r5
   
morse_DASH:
   mov r5,lr //Saves lr to r5
   bl initialise_DASH //lr gets overwritten
   bl execute_WAIT
   bl initialise_OFF
   bl execute_WAIT
   bx r5 //Jumps Back to main

main:
//This is the letter
	bl morse_DOT
	bl morse_DASH