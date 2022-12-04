@ ----- Morse instructions --------------------
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
   
initialise_OFF:
   ldr r2,=WITHIN_LETTER_SPACE
   ldr r0,=GPCLR0
   str r1,[r0]
   bx lr

initialise_OFF_BETWEEN_LETTERS:
   ldr r2,=BETWEEN_LETTERS
   ldr r0,=GPCLR0
   str r1,[r0]
   bx lr

initialise_OFF_BETWEEN_WORDS:
   ldr r2,=BETWEEN_WORDS
   ldr r0,=GPCLR0
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
   mov r5,lr                    @ Saves lr to r5
   bl initialise_DASH           @ lr gets overwritten
   bl execute_WAIT
   bl initialise_OFF
   bl execute_WAIT
   bx r5                        @ Jumps Back to main

@ ---------------------------------------
morseStartSignal:
    mov r6,lr                    @ Saves lr to r6
    bl morse_DASH
    bl morse_DOT
    bl morse_DASH
    bl morse_DOT
    bl morse_DASH
    bx r6

morseEndSignal:
    mov r6,lr                    @ Saves lr to r6
    bl morse_DOT
    bl morse_DASH
    bl morse_DOT
    bl morse_DASH
    bl morse_DOT
    bx r6

@ ---------------------------------------

morseSpace:
    bl initialise_OFF_BETWEEN_WORDS
    bl execute_WAIT
    b loopIncrement
    b loopIncrement


@ numbers ------------------------- 
morse_0:
    bl morse_DASH
    bl morse_DASH
    bl morse_DASH
    bl morse_DASH
    bl morse_DASH
    b loopIncrement

morse_1:
    bl morse_DOT
    bl morse_DASH
    bl morse_DASH
    bl morse_DASH
    bl morse_DASH
    b loopIncrement

morse_2:
    bl morse_DOT
    bl morse_DOT
    bl morse_DASH
    bl morse_DASH
    bl morse_DASH
    b loopIncrement

morse_3:
    bl morse_DOT
    bl morse_DOT
    bl morse_DOT
    bl morse_DASH
    bl morse_DASH
    b loopIncrement

morse_4:
    bl morse_DOT
    bl morse_DOT
    bl morse_DOT
    bl morse_DOT
    bl morse_DASH
    b loopIncrement

morse_5:
    bl morse_DOT
    bl morse_DOT
    bl morse_DOT
    bl morse_DOT
    bl morse_DOT
    b loopIncrement

morse_6:
    bl morse_DASH
    bl morse_DOT
    bl morse_DOT
    bl morse_DOT
    bl morse_DOT
    b loopIncrement

morse_7:
    bl morse_DASH
    bl morse_DASH
    bl morse_DOT
    bl morse_DOT
    bl morse_DOT
    b loopIncrement

morse_8:
    bl morse_DASH
    bl morse_DASH
    bl morse_DASH
    bl morse_DOT
    bl morse_DOT
    b loopIncrement

morse_9:
    bl morse_DASH
    bl morse_DASH
    bl morse_DASH
    bl morse_DASH
    bl morse_DOT
    b loopIncrement


@ Letters --------------------------
morse_A:
    bl morse_DOT
    bl morse_DASH
    b loopIncrement

morse_B:
   bl morse_DASH
   bl morse_DOT
   bl morse_DOT
   bl morse_DOT
   b loopIncrement

morse_C:
   bl morse_DASH
   bl morse_DOT
   bl morse_DASH
   bl morse_DOT
   b loopIncrement

morse_D:
   bl morse_DASH
   bl morse_DOT
   bl morse_DOT
   b loopIncrement

morse_E:
   bl morse_DOT
   b loopIncrement

morse_F:
   bl morse_DOT
   bl morse_DOT
   bl morse_DASH
   bl morse_DOT
   b loopIncrement

morse_G:
   bl morse_DASH
   bl morse_DASH
   bl morse_DOT
   b loopIncrement

morse_H:
   bl morse_DOT
   bl morse_DOT
   bl morse_DOT
   bl morse_DOT
   b loopIncrement

morse_I:
   bl morse_DOT
   bl morse_DOT
   b loopIncrement

morse_J:
   bl morse_DOT
   bl morse_DASH
   bl morse_DASH
   bl morse_DASH    
   b loopIncrement

morse_K:
   bl morse_DASH
   bl morse_DOT
   bl morse_DASH
   b loopIncrement

morse_L:
   bl morse_DOT
   bl morse_DASH
   bl morse_DOT
   bl morse_DOT
   b loopIncrement

morse_M:
   bl morse_DASH
   bl morse_DASH
   b loopIncrement

morse_N:
    bl morse_DASH
    bl morse_DOT
    b loopIncrement

morse_O:
    bl morse_DASH
    bl morse_DASH
    bl morse_DASH
    b loopIncrement

morse_P:
    bl morse_DOT
    bl morse_DASH
    bl morse_DASH
    bl morse_DOT
    b loopIncrement

morse_Q:
    bl morse_DASH
    bl morse_DASH
    bl morse_DOT
    bl morse_DASH
    b loopIncrement

morse_R:
    bl morse_DOT
    bl morse_DASH
    bl morse_DOT
    b loopIncrement

morse_S:
    bl morse_DOT
    bl morse_DOT
    bl morse_DOT
    b loopIncrement

morse_T:
    bl morse_DASH
    b loopIncrement

morse_U:
    bl morse_DOT
    bl morse_DOT
    bl morse_DASH
    b loopIncrement

morse_V:
    bl morse_DOT
    bl morse_DOT
    bl morse_DOT
    bl morse_DASH
    b loopIncrement

morse_W:
    bl morse_DOT
    bl morse_DASH
    bl morse_DASH
    b loopIncrement

morse_X:
    bl morse_DASH
    bl morse_DOT
    bl morse_DOT
    bl morse_DASH
    b loopIncrement

morse_Y:
    bl morse_DASH
    bl morse_DOT
    bl morse_DASH
    bl morse_DASH
    b loopIncrement

morse_Z:
    bl morse_DASH
    bl morse_DASH
    bl morse_DOT
    bl morse_DOT
    b loopIncrement

@ ----------------------------------
