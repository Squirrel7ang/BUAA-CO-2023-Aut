.text
  jal STH
  nop
  and $t0, $0, $0
  lui $t1, 0x1234
  ori $t1, $t1, 0x5678
  ori $t2, $0, 0x000c
  ori $t3, $0, 0x0030
  add $t4, $0, 0x2
  IF0:
    beq $t0, $t3, END0
    nop
    sw $t1, 0($t0)
    sh $t1, 4($t0)
    sh $t1, 6($t0)
    sb $t1, 8($t0)
    sb $t1, 9($t0)
    sb $t1,10($t0)
    sb $t1,11($t0)
    lw $s0, 0($t0)
    lh $s1, 4($t0)
    lh $s2, 6($t0)
    lb $s3, 8($t0)
    lb $s4, 9($t0)
    lb $s5,10($t0)
    lb $s6,11($t0)
    
    mult $t1, $t4
    mflo $t1    
    
    add $t0, $t0, $t2
    jal IF0
    nop
  END0:
  jal FINISH
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  nop
  nop
  nop
  add $0 $t1, $t2
  STH:
  jr $ra
  add $0 $t1, $t2
  FINISH:
  add $0 $t1, $t2
  