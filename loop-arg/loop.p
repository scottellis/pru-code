; Run a simple delay loop on the PRU
; Expect the main loop counter in PRU0 data[0]
; and the delay loop counter in PRU0 data[1]

.setcallreg r29.w0
.origin 0
.entrypoint start

#define PRU0_ARM_INTERRUPT 19

start:
  mov r0, 0            ; set r0 to start of PRU0 data
  lbbo &r2, r0, 0, 8   ; load r2/r3 from PRU0 data
  mov r1, r2           ; load the main loop counter from r2

main:
  call delay
  sub r1, r1, 1
  qbne main, r1, 0
  mov r31.b0, PRU0_ARM_INTERRUPT + 16
  halt

delay:
  mov r0, r3           ; load the delay loop counter from r3

delay_loop:
  sub r0, r0, 1
  qbne delay_loop, r0, 0
  ret
