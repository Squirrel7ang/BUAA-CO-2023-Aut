.data
  stack: .space 400
  array: .space 100
  symbol: .space 100
  space: .asciiz " "
  enter: .asciiz "\n"


.macro end
  li $v0, 10
  syscall
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

.macro readint(%addr) 
  li $v0, 5
  syscall
  move %addr, $v0
.end_macro

.macro printint(%val)
  li $v0, 1
  move $a0, %val
  syscall
.end_macro

.macro index(%dst, %index)
  move %dst, $zero
  add %dst, %dst, %index
  sll %dst, %dst, 2
.end_macro

.macro saveint(%reg)
  addiu $sp, $sp, -4
  sw %reg, 0($sp)
.end_macro

.macro loadint(%reg)
  lw %reg, 0($sp)
  addiu $sp, $sp, 4
.end_macro

.macro savenext(%reg)
  addiu $sp, $sp, -4
  sw %reg, 0($sp)
.end_macro

.macro loadnext(%reg)
  lw %reg, 0($sp)
  addiu $sp, $sp, 4
.end_macro



.text
  la $sp, stack
  addi $sp, $sp, 400
  readint($s0) # n
  move $a0, $zero
  jal FullArray
  end

FullArray:
  move $s1, $a0 # index
  move $t0, $zero # i
  if0:
    blt $s1, $s0, end0
    L0:
      bge $t0, $s0, E0
      
      index($t1, $t0)
      lw $t2, array($t1) # array[i]
      printint($t2)
      pspace

      addiu $t0, $t0, 1
      j  L0
    E0:
    penter
    jr $ra
  end0:

  move $t0, $zero
  L1:
    bge $t0, $s0, E1
    if1:
      index($t1, $t0)
      lw $t2, symbol($t1)
      bne $t2, $zero, end1

      index($t1, $s1)
      addi $t2, $t0, 1
      sw $t2, array($t1)

      index($t1, $t0)
      move $t2, $zero
      addi $t2, $t2, 1
      sw $t2, symbol($t1)

      saveint($s1)
      saveint($t0)
      savenext($ra)

      addi $a0, $s1, 1
      jal FullArray

      loadnext($ra)
      loadint($t0)
      loadint($s1)

      index($t1, $t0)
      sw $zero, symbol($t1)
    end1:
    addiu $t0, $t0, 1
    j L1
  E1:
  jr $ra

  
