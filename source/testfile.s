@ https://community.arm.com/arm-community-blogs/b/architectures-and-processors-blog/posts/how-to-call-a-function-from-arm-assembler

/*
.include "base.inc"
.include "timer.inc" 
*/

.section .data
@ TODO remove .equ, just here for test purposes
.equ RPI_BASE, 0x20000000 
.equ GPIO_BASE, RPI_BASE + 0x200000 

.equ GPFSEL2,GPIO_BASE + 0x8        @ GPIO select 2
.equ GPSET0, GPIO_BASE + 0x1C       @ pin is on .equ GPCLR0,
.equ GPCLR0, GPIO_BASE + 0x28       @ pin is off
@ ---------------------

@ length of morse "ingredients", should be moved to separate file
.equ DOT, 0x2F0000
.equ DASH, 2 * DOT
.equ WITHIN_LETTER_SPACE, DOT
//Because we turn the pin off again, we need to do a minus 1 on BETWEEN_LETTERS and BETWEEN_WORDS
.equ BETWEEN_LETTERS, 3 * DOT
.equ BETWEEN_WORDS, 7 * DOT


morseString:                        @ string saved in RAM
@ each letter is 8-bits (= 1 Byte) -> can use byte loader; .asciz := string, which ends with 0
.asciz "soS 9@"                     

.section .init  @ nicht sicher ob notwendig, CPUlator wollte das so
.globl _start
_start:

b main

.section .text

main:
    mov r1,#1                       @ 000 000 001
    lsl r1,#3                       @ -> 000 001 000
    ldr r0,=GPFSEL2
    str r1,[r0]
    mov r1,#1
    lsl r1,#21                      @ set pin to output


MainLoop:
    bl morseStartSignal
    ldr r10, =morseString            @ load address of string into register
    mov r9,#0                        @ r9: counter of iterations
    convertToUpperCase:              @ while loop
        add r8, r9, r10
        ldrb r0, [r8]                @ load one byte (-> one letter!) at r8 into r0
        cmp r0, #0                   @ check if value is null -> break
        beq endOfString
        cmp r0,#97                   @ check if < 97; ASCII boundary for lower case letter
        blt checkMorse
        cmp r0, #122                 @ check if > 122; ASCII boundary for lower case letter
        bgt checkMorse

        @ capitalize if lowercase letter
        sub r0,#32                   @ convert to uppercase
        strb r0,[r8]                 @ save back
        b checkMorse
    b convertToUpperCase

loopIncrement:
    add r9, #1               @ increment offset
    @ Pause zwischen Buchstaben
    b convertToUpperCase

checkMorse:
    cmp r0, #32
    beq morseSpace
    cmp r0, #57             @ 9
    ble morseNumber
    cmp r0, #65             @ A
    bge morseLetter
    b loopIncrement         @ if we do not have a morse signal (neither number, letter or space), skip symbol


@ ----- Morse instructions; TODO: extract to separate file --------------------
initialise_DOT:
   mov r2,=DOT
   ldr r0,=GPSET0
   str r1,[r0]
   bx lr
   
initialise_DASH:
   mov r2,=DASH
   ldr r0,=GPSET0
   str r1,[r0]
   bx lr
   
initialise_OFF:
   ldr r0,=GPCLR0
   str r1,[r0]
   mov r2,=WITHIN_LETTER_SPACE
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
   @ TODO: Because we turn the pin off again, we need to do a minus 1 on BETWEEN_LETTERS and BETWEEN_WORDS
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


morseSpace:
    bl morse_DOT
    bl morse_DASH
    bl morse_DOT
    bl morse_DASH
    bl morse_DOT
    b loopIncrement

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

endOfString:
    bl morseEndSignal       @ start again with morse signal
b MainLoop


@ both, morseNumber and morseLetter are implemented as (individual) binary trees
morseNumber:
    cmp r0, #48
    blt loopIncrement
    morse_0_to_9:           @ #-ASCII: [48, 57]
        cmp r0, #52         @ Test if 4
        beq morse_4
        blt morse_0_to_3
        bgt morse_5_to_9
    
morse_0_to_3:
    cmp r0, #49             @ Test if 1
    beq morse_1
    blt morse_0
    bgt morse_2_to_3

morse_2_to_3:
    cmp r0, #50             @ Test if 2
    beq morse_2
    bgt morse_3

morse_5_to_9:   
    cmp r0, #55             @ Test if 7
    beq morse_7
    blt morse_5_to_6
    bgt morse_8_to_9

morse_5_to_6:
    cmp r0, #53             @ Test if 5
    beq morse_5
    bgt morse_6

morse_8_to_9:
    cmp r0, #56             @ Test if 8
    beq morse_8
    bgt morse_9


morseLetter:
    cmp r0, #90
    bgt loopIncrement
    morse_A_to_Z:           @ #-ASCII: [65, 90]
        cmp r0, #77         @ M
        beq morse_M
        blt morse_A_to_L
        bgt morse_N_to_Z

morse_A_to_L:
    cmp r0, #70
    beq morse_F
    blt morse_A_to_E
    bgt morse_G_to_L

morse_A_to_E:
    cmp r0, #67
    beq morse_C
    blt morse_A_to_B
    bgt morse_D_to_E

morse_A_to_B:
    cmp r0, #65
    beq morse_A
    bgt morse_B

morse_D_to_E:
    cmp r0, #68
    beq morse_D
    bgt morse_E

morse_G_to_L:
    cmp r0, #73
    beq morse_I
    blt morse_G_to_H
    bgt morse_J_to_L

morse_G_to_H:
    cmp r0, #71
    beq morse_G
    bgt morse_H

morse_J_to_L:
    cmp r0, #75
    beq morse_K
    blt morse_J
    bgt morse_L

morse_N_to_Z:
    cmp r0, #84
    beq morse_T
    blt morse_N_to_S
    bgt morse_U_to_Z

morse_N_to_S:
    cmp r0, #80
    beq morse_P
    blt morse_N_to_O
    bgt morse_Q_to_S

morse_N_to_O:
    cmp r0, #78
    beq morse_N
    bgt morse_O

morse_Q_to_S:
    cmp r0, #82
    beq morse_R
    blt morse_Q
    bgt morse_S

morse_U_to_Z:
    cmp r0, #87
    beq morse_W
    blt morse_U_to_V
    bgt morse_X_to_Z

morse_U_to_V:
    cmp r0, #85
    beq morse_U
    bgt morse_V

morse_X_to_Z:
    cmp r0, #89
    beq morse_Y
    blt morse_X
    bgt morse_Z


@ ----------------------------------


@ individual cases

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
