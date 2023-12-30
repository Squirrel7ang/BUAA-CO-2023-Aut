.data
  space: .asciiz " "
  enter: .asciiz "\n"  
  m1: .space 1024
  m2: .space 1024
  m3: .space 1024

.macro caladdr(%dst, %row, %column, %rank)
    # dts: the register to save the calculated address
    # row: the row that element is in
    # column: the column that element is in
    # rank: the number of rows in the matrix
    multu %row, %rank
    mflo %dst
    addu %dst, %dst, %column
    sll %dst, %dst, 2
.end_macro

.macro end
  li $v0, 10
  syscall
.end_macro

.macro getindex(%array, %addr, %index, %sizeof, %tmp)
  la %addr, %array
  mult %index, %sizeof
  mflo %tmp
  addu %addr, %addr, %tmp
.end_macro

.macro  readint(%addr)
  la $v0, 5
  syscall
  move %addr, $v0
.end_macro

.macro printint(%value)
  move $a0, %value
  li $v0, 1
  syscall  
.end_macro  

.macro printstr(%addr)
  la $a0, %addr
  li $v0, 4
  syscall
.end_macro

.macro readchar(%c)
  li $v0, 12
  syscall
  move %c, $v0
.end_macro

.macro loadint(%n)	# draw int out of stack
	addi $sp, $sp, 4
	lw %n, 0($sp)
.end_macro

.macro save_int(%n)	# save int into stack
	sw %n, 0($sp)
	subi $sp, $sp, 4
.end_macro
  
.macro pspace
  la $a0, space
  li $v0, 4
  syscall
.end_macro

.macro penter
  la $a0, enter
  li $v0, 4
  syscall
.end_macro

.text

  # input
  readint($s0)
  move $t1, $zero
  move $t2, $zero
  move $t3, $zero
  L0:
    bge $t1, $s0, E0
    move $t2, $zero
    L1:
      bge $t2, $s0, E1
      caladdr($t3, $t1, $t2, $s0)
      la $t9, m1
      add $t3, $t3, $t9
      readint($t4)
      sw $t4, 0($t3)
      addiu $t2, $t2, 1
      j L1
    E1:
    addiu $t1, $t1, 1
    j L0
  E0:

  move $t1, $zero
  move $t2, $zero
  L2:
    bge $t1, $s0, E2
    move $t2, $zero
    L3:
      bge $t2, $s0, E3
      caladdr($t3, $t1, $t2, $s0)
      la $t9, m2
      add $t3, $t3, $t9
      readint($t4)
      sw $t4, 0($t3)
      addiu $t2, $t2, 1
      j L3
    E3:
    addiu $t1, $t1, 1
    j L2
  E2:

  # process
  move $t0, $zero # value of m3[i][j]
  move $t1, $zero # i
  move $t2, $zero # j
  move $t3, $zero # k
  move $t4, $zero # addr of m1[i][k] && value of m1[i][k] * m2[k][j]
  move $t5, $zero # addr of m2[k][j]
  move $t6, $zero # addr of m3[i][j]
  move $t7, $zero # value of 
  move $t8, $zero

  L4:
    bge $t1, $s0, E4
    move $t2, $zero
    L5:
      bge $t2, $s0, E5
      
      move $t0, $zero
      move $t3, $zero
      L6:
        bge $t3, $s0, E6

        caladdr($t4, $t1, $t3, $s0)
        la $t9, m1
        add $t4, $t4, $t9
        caladdr($t5, $t3, $t2, $s0)
        la $t9, m2
        add $t5, $t5, $t9
        
        lw $t7, 0($t4)
        lw $t8, 0($t5)
        mult $t7, $t8
        mflo $t4
        add $t0, $t0, $t4

        addiu $t3, $t3, 1
        j L6
      E6:
      # store m[i][j]
      caladdr($t6, $t1, $t2, $s0)
      la $t9, m3
      add $t6, $t6, $t9
      sw $t0, 0($t6)        
      addiu $t2, $t2, 1
      j L5
    E5:
    addiu $t1, $t1, 1
    j L4
  E4:
  
  # output
  move $t1, $zero
  L7:
    bge $t1, $s0, E7
    move $t2, $zero
    L8:
      beq $t2, $s0, E8

      caladdr($t3, $t1, $t2, $s0)
        la $t9, m3
        add $t3, $t3, $t9
      lw $t4, 0($t3)
      printint($t4)
      pspace
      
      addiu $t2, $t2, 1
      j L8
    E8:
    penter
    addiu $t1, $t1, 1
    j L7
  E7:
  end