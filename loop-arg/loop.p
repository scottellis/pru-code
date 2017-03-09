; Run a simple delay loop on the PRU 
; Expect the main loop counter in PRU0 data[0]
; and the delay loop counter in PRU0 data[1]

.setcallreg r29.w0
.origin 0
.entrypoint START 

#define PRU0_ARM_INTERRUPT 19

START:
  MOV r0, 0            ; set r0 to start of PRU0 data
  LBBO &r2, r0, 0, 8   ; load r2/r3 from PRU0 data
  MOV r1, r2           ; load the main loop counter from r2 

MAIN_LOOP:
  CALL DELAY
  SUB r1, r1, 1
  QBNE MAIN_LOOP, r1, 0

  MOV r31.b0, PRU0_ARM_INTERRUPT + 16 

  HALT

DELAY:
  MOV r0, r3           ; load the delay loop counter from r3 

DELAY_LOOP:
  SUB r0, r0, 1
  QBNE DELAY_LOOP, r0, 0
  RET
