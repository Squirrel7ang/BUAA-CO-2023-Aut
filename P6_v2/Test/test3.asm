.text
  ori $t0, $0, 0x1324
  mult $t0, $t0
  bne $t0, $0, CONTINUE
  nop
  bne $t0, $0, FINISH
  nop
  
  CONTINUE:
  lui $t0, 0xfeef
  ori $t0, $t0, 0xabba
  sh $t0, 0($0)
  lui $t1, 0xabba
  ori $t1, $t1, 0xfeef
  sh $t1, 2($0)
  jal SKIP
  nop
  BACK:
  jal FINISH
  nop
  
  
  SKIP:
  
  lh $s0, 0($0)
  lh $s1, 2($0)
  lui $t0, 0xffff
  ori $t0, $t0, 0xffff
  lui $t1, 0xffff
  ori $t1, $t1 0xffff
  bne $t0, $t1, L1
  nop
  ori $t2, $0, 0x149a
  and $t1, $t2, $t1
  bne $t0, $t1, L2
  nop
  L1:
  add $s0, $0, $t0
  nop
  nop
  L2:
  bne $t0, $t2, BACK
  nop
  
  FINISH:
  add $s1, $ra, $0
