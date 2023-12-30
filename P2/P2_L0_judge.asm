.data
  space: .asciiz " "
  enter: .asciiz "\n"
  array: .space 80

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

.macro saveint(%n)	# save int into stack
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
  readint($s0)
  move $t0, $zero
  L0:
    bge $t0, $s0, E0

    sll $t1, $t0, 2
    la $t9, array
    add $t1, $t1, $t9

    readchar($t2)
    sw $t2, 0($t1)    

    addiu $t0, $t0, 1
    j L0
  E0:

  move $t0, $zero
  move $t1, $s0
  addi $t1, $t1, -1
  move $s1, $zero
  L1:
    bge $t0, $t1, E1
    la $t2, array
    move $t3, $t2
    sll $t4, $t0, 2
    add $t2, $t2, $t4
    sll $t4, $t1, 2
    add $t3, $t3, $t4
    
    lw $t2, 0($t2)
    lw $t3, 0($t3)
    bne $t2, $t3, EF0
    IF0:
      j E2
    EF0:
      addi $s1, $s1, 1
      j E1
      j E2
    E2:

    addiu $t0, $t0, 1
    addiu $t1, $t1, -1
    j L1
  E1:
  
  bne $s1, $zero, EF1
  IF1:
    move $t0, $zero
    addiu $t0, $t0, 1
    printint($t0)
    j E3
  EF1:
    printint($zero)
    j E3
  E3:
  
end
  
  
  
  
  
  
  
  
