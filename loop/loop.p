; Run a simple delay loop on the PRU 

.setcallreg r29.w0
.origin 0
.entrypoint START 

#define PRU0_ARM_INTERRUPT 19

#define DELAY_COUNT 50000000

#define LOOP_ITERATIONS 20

START:
  MOV r1, LOOP_ITERATIONS

MAIN_LOOP:
  CALL DELAY
  SUB r1, r1, 1
  QBNE MAIN_LOOP, r1, 0

  MOV r31.b0, PRU0_ARM_INTERRUPT + 16 

  HALT


DELAY:
  MOV r0, DELAY_COUNT

DELAY_LOOP:
  SUB r0, r0, 1
  QBNE DELAY_LOOP, r0, 0
  RET
