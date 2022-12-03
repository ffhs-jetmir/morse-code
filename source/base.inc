.equ RPI_BASE, 0x20000000 
.equ GPIO_BASE, RPI_BASE + 0x200000 

.equ GPFSEL2,GPIO_BASE + 0x8        @ GPIO select 2
.equ GPSET0, GPIO_BASE + 0x1C       @ pin is on .equ GPCLR0,
.equ GPCLR0, GPIO_BASE + 0x28       @ pin is off
@ ---------------------

@ length of morse "ingredients"
.equ DOT, 0x2F0000
.equ DASH, 2 * DOT
.equ WITHIN_LETTER_SPACE, DOT
//Because we turn the pin off again, we need to do a minus 1 on BETWEEN_LETTERS and BETWEEN_WORDS
.equ BETWEEN_LETTERS, DASH  @ 3 * Dot - 1 for compensation
.equ BETWEEN_WORDS, 6 * DOT @ 7 * Dot - 1 for compensation
