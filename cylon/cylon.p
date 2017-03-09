; Blink some of the PRU cape LEDs in a cylon fashion

.setcallreg r29.w0
.origin 0
.entrypoint START

#define PRU0_ARM_INTERRUPT 19

; 25 * 10ns (2 instr) = 250 ms
#define LED_DELAY 25000000

#define CYLON_LOOPS 10

START:
  MOV r1, CYLON_LOOPS ; total repeats

CYLON:
  SET r30.t0  ; set GPIO output 0
  CALL LED_PAUSE
  CLR r30.t0
  SET r30.t1 
  CALL LED_PAUSE
  CLR r30.t1
  SET r30.t2
  CALL LED_PAUSE
  CLR r30.t2
  SET r30.t3 
  CALL LED_PAUSE
  CLR r30.t3
  SET r30.t2
  CALL LED_PAUSE
  CLR r30.t2
  SET r30.t1
  CALL LED_PAUSE
  CLR r30.t1

  SUB r1, r1, 1
  QBNE CYLON, r1, 0 ; loop until r1 = 0

  MOV r31.b0, PRU0_ARM_INTERRUPT + 16 ; notify caller we are done

  HALT

; function to pause for LED_DELAY cycles
LED_PAUSE:
  MOV r0, LED_DELAY
DELAY: 
  SUB r0, r0, 1
  QBNE DELAY, r0, 0
  RET
