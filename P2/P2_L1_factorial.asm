.data
  a: .space 5000 # 1250 words

.macro printint(%val)
  move $a0, %val
  li $v0, 1
  syscall
.end_macro

.macro readint(%addr)
  li $v0, 5
  syscall
  move %addr, $v0
.end_macro

.macro end
  li $v0, 10
  syscall
.end_macro

.macro index(%dst, %index)
  sll %dst, %index, 2
.end_macro

.text
  readint($s0) # n
  addiu $t0, $zero, 1 # i = 1
  sw $t0, a

  move $t2, $0 # l = 0

  for0:
    bgt $t0, $s0, end0
    move $t3, $0 # s = 0
    move $t1, $0 # j = 0

    for1:
      bgt $t1, $t2, end1
      index($t4, $t1)
      lw $t4, a($t4) # t4 = a[j]
      mult $t4, $t0
      mflo $t5 # t5 = a[j] * i
      add $t3, $t3, $t5

      li $t6, 10
      div $t3, $t6 
      mfhi $t4 
      index($t5, $t1)
      sw $t4, a($t5)

      li $t6, 10
      divu $t3, $t6
      mflo $t3
      
      addiu $t1, $t1, 1
      j for1
    end1:

    while2:
      beq $t3, $0, end2

      addiu $t2, $t2, 1
      li $t6, 10
      divu $t3, $t6
      mfhi $t4
      index($t5, $t2)
      sw $t4, a($t5)      

      li $t6, 10
      divu $t3, $t6
      mflo $t3
      j while2
    end2:

    addiu $t0, $t0, 1
    j for0
  end0:

  move $t0, $t2
  for3:
    blt $t0, $0, end3
    
    index($t1, $t0)
    lw $t1, a($t1)
    printint($t1)

    addiu $t0, $t0, -1
    j for3
  end3:
  end
