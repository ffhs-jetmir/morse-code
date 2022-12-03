@ https://community.arm.com/arm-community-blogs/b/architectures-and-processors-blog/posts/how-to-call-a-function-from-arm-assembler

@ TODO implement starting signal and end of signal
/*
.include "base.inc"
.include "morse.inc"
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
.equ DOT, #0x2F0000
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

morseSpace:
    mov r2, #32
    b loopIncrement

morseStartSignal:
    mov r2, #1
    bx lr

morseEndSignal:
    mov r2, #2
    bx lr

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


morseLetter:                @ Pietro A-M, Ladina N-Z
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


@ individual cases, still formulated as test @ TODO replace with actual morse

@ numbers ------------------------- 
morse_0:
    @ TODO code for morse 0
    mov r2, #0  @ TODO remove, just here for testpurposes to see if branching works
    b loopIncrement

morse_1:
    @ TODO code for morsing 1
    mov r2, #1  @ TODO remove, just here for testpurposes to see if branching works
    b loopIncrement

morse_2:
    mov r2, #2
    b loopIncrement

morse_3:
    mov r2, #3
    b loopIncrement

morse_4:
    mov r2, #4
    b loopIncrement

morse_5:
    mov r2, #5
    b loopIncrement

morse_6:
    mov r2, #6
    b loopIncrement

morse_7:
    mov r2, #7
    b loopIncrement

morse_8:
    mov r2, #8
    b loopIncrement

morse_9:
    mov r2, #9
    b loopIncrement


@ Letters --------------------------

morse_A:
    mov r2, #65
    bl executeMorse_S

    b loopIncrement

morse_B:
    mov r2, #66
    b loopIncrement

morse_C:
    mov r2, #67
    b loopIncrement

morse_D:
    mov r2, #68
    b loopIncrement

morse_E:
    mov r2, #69
    b loopIncrement

morse_F:
    mov r2, #70
    b loopIncrement

morse_G:
    mov r2, #71
    b loopIncrement

morse_H:
    mov r2, #72
    b loopIncrement

morse_I:
    mov r2, #73
    b loopIncrement

morse_J:
    mov r2, #74
    b loopIncrement

morse_K:
    mov r2, #75
    b loopIncrement

morse_L:
    mov r2, #76
    b loopIncrement

morse_M:
    mov r2, #77
    b loopIncrement

morse_N:
    mov r2, #78
    b loopIncrement

morse_O:
    mov r2, #79
    b loopIncrement

morse_P:
    mov r2, #80
    b loopIncrement

morse_Q:
    mov r2, #81
    b loopIncrement

morse_R:
    mov r2, #82
    b loopIncrement

morse_S:
    @ TODO code for morsing S
    mov r2, #83  @ TODO remove, just here for testpurposes to see if branching works
    b loopIncrement

morse_T:
    mov r2, #84
    b loopIncrement

morse_U:
    mov r2, #85
    b loopIncrement

morse_V:
    mov r2, #86
    b loopIncrement

morse_W:
    mov r2, #87
    b loopIncrement

morse_X:
    mov r2, #88
    b loopIncrement

morse_Y:
    mov r2, #89
    b loopIncrement

morse_Z:
    mov r2, #91
    b loopIncrement

@ ----------------------------------
