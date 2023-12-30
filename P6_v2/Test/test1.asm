.text
  ori $t0, $0, 0x1234
  ori $t1, $0, 0xffff
  ori $t2, $0, 0x0001
  lui $t3, 0xabcd
  ori $t3, $0, 0x0010
  
  # testing cal ins
  add $s0, $t0, $t1
  addi $s0, $s0, 0x1234
  sub $s1, $s0, $t0
  or $s2, $t1, $t0
  ori $s0, $s2, 0x5263
  and $s0, $t0, $s0
  andi $s1, $s0, 0xdfea
  
  andi $s0, $s0, 0x4321
  lui $t4, 0xffff
  ori $t4, $t4, 0xffff
  slt $s1, $t4, $t4
  slt $s1, $t4, $t0
  slt $s1, $t0, $t4
  sltu $s1, $t0, $t4
  sltu $s1, $t4, $t0
  
  # testing md
  lui $t1, 0xabcd
  ori $t1, $t1, 0x1234
  lui $t0, 0xdcba
  ori $t0, $t0, 0x4321
  
  mult $t1, $t0
  mfhi $s0
  mflo $s1
  multu $t1, $t0
  mfhi $s2
  mflo $s3
  
  lui $t1, 0xabcd
  ori $t1, $t1, 0x1234
  lui $t0, 0x0001
  ori $t0, $t0, 0x4321
  
  mult $t1, $t0
  div $t1, $t0
  mfhi $s0
  mflo $s1
  divu $t1, $t0
  mfhi $s2
  mflo $s3
  
  mthi $t1
  mtlo $t3
  mflo $s6
  mfhi $s5
  
  sw $t1, 0($0)
  lw $t2, 0($0)
  mult $t1, $t2
  mfhi $s0
  mflo $s1
  multu $t1, $t2
  mfhi $s2
  mflo $s3
  div $t1, $t2
  mfhi $s0
  mflo $s1
  divu $t1, $t2
  mfhi $s2
  mflo $s3
  
  
