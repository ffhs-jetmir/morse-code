@ TODO: übernehmen und anpassen

initialise_PAUSE_BTWN_LETTERS:
   ldr r0,=GPCLR0
   str r1,[r0]
   mov r2,=BETWEEN_LETTERS

initialise_BETWEEN_WORDS:
   ldr r0,=GPCLR0
   str r1,[r0]
   mov r2,=BETWEEN_WORDS
@ --------------------------------



initialise_DOT:
   ldr r2,=DOT
   ldr r0,=GPSET0
   str r1,[r0]
   bx lr

initialise_DASH:
   ldr r2,=DASH
   ldr r0,=GPSET0
   str r1,[r0]
   bx lr   

initialise_Off:
   ldr r0,=GPCLR0
   str r1,[r0]
   ldr r2,=WITHIN_LETTER_SPACE
   bx lr




/*
Letter 'S'
 */
initialise_DOT_on

execute_s_on:
   sub r2,#1
   cmp r2,#0   
   bne execute_s_on

initialise_Off
   
execute_s_off:
   sub r2,#1
   cmp r2,#0
   bne execute_s_off
   

executeMorse_S:
   add r8,#1
   cmp r8,#4
   bne initialise_sOn
   bx lr


// Morse the letter 'O'

initialise_DASH

execute_o_on:
   sub r2,#1
   cmp r2,#0   
   bne execute_o_on   

initialise_Off @ Pause war vorher DASH

execute_o_off:
   sub r2,#1
   cmp r2,#0
   bne execute_o_off

executeMorse_O:
   add r8,#1
   cmp r8,#4
   bne initialise_oOn
   bx lr