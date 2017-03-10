; Blink some of the PRU cape LEDs in a cylon fashion

.setcallreg r29.w0
.origin 0
.entrypoint start

#define PRU0_ARM_INTERRUPT 19

; 25 * 10ns (2 instr) = 250 ms
#define LED_DELAY 25000000

#define CYLON_LOOPS 10

start:
  mov r1, CYLON_LOOPS ; total repeats

main:
  set r30.t0  ; set GPIO output 0
  call led_pause
  clr r30.t0
  set r30.t1
  call led_pause
  clr r30.t1
  set r30.t2
  call led_pause
  clr r30.t2
  set r30.t3
  call led_pause
  clr r30.t3
  set r30.t2
  call led_pause
  clr r30.t2
  set r30.t1
  call led_pause
  clr r30.t1

  sub r1, r1, 1
  qbne main, r1, 0 ; loop until r1 = 0

  mov r31.b0, PRU0_ARM_INTERRUPT + 16 ; notify caller we are done

  halt

; function to pause for LED_DELAY cycles
led_pause:
  mov r0, LED_DELAY

delay:
  sub r0, r0, 1
  qbne delay, r0, 0
  ret
