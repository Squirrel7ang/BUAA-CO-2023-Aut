.text
  lui $t1, 0x8bcd
  ori $t1, $t1, 0x12fc
  
  lui $t0, 0x3cf4
  ori $t0, $t0, 0x986a
  mult $t0, $t1
  bne $t0, $t1, L1
  nop
  add $t1, $t1, $t0
  
  L1:
    mfhi $s0
    sub $t2, $t1, $t1
  
    
  