; PRU cape board demo
; Turn on some LEDs if SW1 pushed
; Halt if SW2 pushed 

.origin 0
.entrypoint start

#define PRU0_ARM_INTERRUPT 19

start:
  clr r30.t0 
  clr r30.t1
  clr r30.t2
  clr r30.t3

main:
  qbbc leds_on, r31.t5  ; jump to LEDS_ON if SW1 pushed 
  qbbc done, r31.t7     ; jump to DONE if SW2 pushed
  qba main 

done:
  mov r31.b0, PRU0_ARM_INTERRUPT + 16 ; notify caller we are done
  halt

leds_on:
  set r30.t0
  set r30.t1
  set r30.t2
  set r30.t3
  wbs r31.t5  ; wait for SW1 to be released
  clr r30.t0
  clr r30.t1
  clr r30.t2
  clr r30.t3
  qba main    ; jump back to main 
