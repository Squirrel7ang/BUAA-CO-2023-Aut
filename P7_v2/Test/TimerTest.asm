.text
  # global not enable, timer enable
  ori $t0, $0, 0x1800
  mtc0 $t0, $12
  ori $t0, $0, 0x9
  ori $t1, $0, 0x4
  sw $t1, 0x7f04($0)
  sw $t0, 0x7f00($0)
  add $t2, $t1, $t0
  add $t3, $t1, $t2
  add $t4, $t3, $t2
  add $t5, $t3, $t4  
  add $t6, $t5, $t4
  add $t7, $t5, $t6
  add $t8, $t7, $t6
  
  ori $t0, $0, 0xb
  ori $t1, $0, 0x4
  sw $t1, 0x7f14($0)
  sw $t0, 0x7f10($0)
  add $t2, $t1, $t0
  add $t3, $t1, $t2
  add $t4, $t3, $t2
  add $t5, $t3, $t4  
  add $t6, $t5, $t4
  add $t7, $t5, $t6
  add $t8, $t7, $t6
  
  # global enable, t1 enable
  ori $t0, $0, 0x1801
  mtc0 $t0, $12
  ori $t0, $0, 0x9
  ori $t1, $0, 0x4
  sw $t1, 0x7f04($0)
  sw $t0, 0x7f00($0)
  add $t2, $t1, $t0
  add $t3, $t1, $t2
  add $t4, $t3, $t2
  add $t5, $t3, $t4  
  add $t6, $t5, $t4
  add $t7, $t5, $t6
  add $t8, $t7, $t6
  
  ori $t0, $0, 0xb
  ori $t1, $0, 0x4
  sw $t1, 0x7f14($0)
  sw $t0, 0x7f10($0)
  add $t2, $t1, $t0
  add $t3, $t1, $t2
  add $t4, $t3, $t2
  add $t5, $t3, $t4  
  add $t6, $t5, $t4
  add $t7, $t5, $t6
  add $t8, $t7, $t6

  # global enable, t0 enable
  ori $t0, $0, 0x1401
  mtc0 $t0, $12
  ori $t0, $0, 0x9
  ori $t1, $0, 0x4
  sw $t1, 0x7f04($0)
  sw $t0, 0x7f00($0)
  add $t2, $t1, $t0
  add $t3, $t1, $t2
  add $t4, $t3, $t2
  add $t5, $t3, $t4  
  add $t6, $t5, $t4
  add $t7, $t5, $t6
  add $t8, $t7, $t6
  
  ori $t0, $0, 0xb
  ori $t1, $0, 0x4
  sw $t1, 0x7f14($0)
  sw $t0, 0x7f10($0)
  add $t2, $t1, $t0
  add $t3, $t1, $t2
  add $t4, $t3, $t2
  add $t5, $t3, $t4  
  add $t6, $t5, $t4
  add $t7, $t5, $t6
  add $t8, $t7, $t6
  
  # global enable, mode 1
  ori $t0, $0, 0x1c01
  mtc0, $t0, $12
  ori $t0, $0, 0x1
  ori $t1, $0, 0x4
  sw $t1, 0x7f14($0)
  sw $t0, 0x7f10($0)
  add $t2, $t1, $t0
  add $t3, $t1, $t2
  add $t4, $t3, $t2
  add $t5, $t3, $t4  
  add $t6, $t5, $t4
  add $t7, $t5, $t6
  add $t8, $t7, $t6
  
  ori $t0, $0, 0x3
  ori $t1, $0, 0x4
  sw $t1, 0x7f04($0)
  sw $t0, 0x7f00($0)
  add $t2, $t1, $t0
  add $t3, $t1, $t2
  add $t4, $t3, $t2
  add $t5, $t3, $t4  
  add $t6, $t5, $t4
  add $t7, $t5, $t6
  add $t8, $t7, $t6
  
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
.ktext 0x4180
_entry:
    mfhi $t3
    mflo $t3
    mfc0 $t3, $12
    mfc0 $t3, $13
    mfc0 $t3, $14
    
    ori $t4, $0, 0x3061
    beq $t3, $t4, JRE
    nop
    ori $t4, $0, 0x7000
    beq $t3, $t4, JALE
    nop
    addi $t3, $t3, 0x8
    jal END
    nop
    JRE:
    ori $t3, $0, 0x3068
    jal END
    nop
    JALE:
    ori $t3, $0, 0x30d8
    jal END
    nop
    END:
    mtc0 $t3, $14
    
    mfc0 $t0, $13
    andi $t0, $t0, 0x0000007c
    beq $t0, $0, INT
    nop
    jal END0
    nop
    INT:
    sw $t0, 0x7f20($0)
    END0:
    mfc0 $t1, $14
    mtc0 $t1, $14
    eret
    addi $s0, $0, 0x1234  