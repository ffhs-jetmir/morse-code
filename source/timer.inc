@Timer registers
.equ TIMER_BASE, RPI_BASE + 0x003000
.equ TIMER_CS, TIMER_BASE + 0x00 @clock status
.equ TIMER_CLO, TIMER_BASE + 0x04 @ clock low 32 bytes
.equ TIMER_CHI, TIMER_BASE + 0x08 @ clock high 32 bytes

.equ MICROS_PER_SECOND, 1000000 @ Microseconds per second
.equ MICROS_PER_MILLISECOND, 1000 @ Microseconds per millisecond

.equ T1_CLOCK_SECOND, MICROS_PER_SECOND @ RPi is microseconds

/* void wait (int r0)
   the milliseconds are specified in r0
*/

time_wait:
    mov r0,#1000

wait:
   push {lr}   
   mov r2,r0            @copy r0 to r2
   bl GetTimeStamp      @transfer time to r0
   mov r3,r0            @and copy to r3
   
   wait_loop$:
      bl GetTimeStamp   @transfer time to r0
      sub r1,r0,r3      @Subtract the stored value from r0 and write it into r1
      cmp r1,r2         @Compare the difference with the handover
      bls wait_loop$    @If less than or equal, then wait

   pop {pc}             @Wait end

GetTimeStamp:
    push {lr}
    ldr r0,=TIMER_CLO       @Address of the lower system timer counter
    ldr r0,[r0]             @Get the current value
    pop {pc}
