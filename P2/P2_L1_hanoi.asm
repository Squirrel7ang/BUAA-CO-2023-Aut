.data
  stack: .space 1600
  move1: .asciiz "move disk "
  move2: .asciiz " from "
  move3: .asciiz " to "
  enter: .asciiz "\n"
  space: .asciiz " "
  charA: .byte 'A'
  charB: .byte 'B'
  charC: .byte 'C'  
  char0: .byte '0'
  message: .asciiz "move disk 1 from f to t\n"
  
.macro end
  li $v0, 10
  syscall
.end_macro
  
.macro printstr(%str)
  la $a0, %str
  li $v0, 4
  syscall
.end_macro

.macro readint(%addr)
  li $v0, 5
  syscall
  move %addr, $v0
.end_macro

.macro printint(%value)
  move $a0, %value
  li $v0, 1
  syscall  
.end_macro 

.macro printchar(%value)
  move $a0, %value
  li $v0, 11
  syscall
.end_macro

.macro readchar(%addr)
  li $v0, 12
  syscall
  move %addr, $v0
.end_macro

.macro loadint(%reg)	# draw int out of stack
  lw %reg, 0($sp)
  addi $sp, $sp, 4
.end_macro

.macro saveint(%reg)	# save int into stack
  subi $sp, $sp, 4
  sw  %reg, 0($sp)
.end_macro

.macro loadchar(%reg)
  lb %reg, 0($sp)
  addi $sp, $sp, 4
.end_macro

.macro savechar(%reg)
  subi $sp, $sp, 4
  sb %reg, 0($sp)  
.end_macro

.macro savenext(%addr)
  subi $sp, $sp, 4
  sw %addr, 0($sp)  
.end_macro

.macro loadnext(%addr)
  lw %addr, 0($sp)
  addi $sp, $sp, 4
.end_macro

.macro mov(%int, %from, %to)
  la $t7, char0
  lb $t7, 0($t7)
  add $t7, $t7, %int
  
  la $t6, message
  sb $t7, 10($t6)
  sb %from, 17($t6)
  sb %to, 22($t6)
  addi $v0, $0, 4
  la $a0, message
  syscall
.end_macro

.text
  la $sp, stack
  addiu $sp, $sp, 1600
  addiu $sp, $sp, -800
  readint($t0)
  la $t1, charA
  lb $t1, 0($t1)
  la $t2, charB
  lb $t2, 0($t2)
  la $t3, charC
  lb $t3, 0($t3)
  saveint($t0)
  savechar($t1)
  savechar($t2)
  savechar($t3)
  jal hanoi
  addiu $sp, $sp, 800
  end
  
hanoi:
  loadchar($t3)
  loadchar($t2)
  loadchar($t1)
  loadint($t0)
  bne $t0, $zero, endif
    mov($t0, $t1, $t2)
    mov($t0, $t2, $t3)
    jr $ra
  endif:
  saveint($t0)
  savechar($t1)
  savechar($t2)
  savechar($t3)
  savenext($ra)
  
  subi $t4, $t0, 1
  saveint($t4)
  savechar($t1)
  savechar($t2)
  savechar($t3)
  jal hanoi
  
  loadnext($ra)
  loadchar($t3)
  loadchar($t2)
  loadchar($t1)
  loadint($t0)
  
  mov($t0, $t1, $t2)
  
  saveint($t0)
  savechar($t1)
  savechar($t2)
  savechar($t3)
  savenext($ra)
  
  subi $t4, $t0, 1
  saveint($t4)
  savechar($t3)
  savechar($t2)
  savechar($t1)
  jal hanoi
  
  loadnext($ra)
  loadchar($t3)
  loadchar($t2)
  loadchar($t1)
  loadint($t0)
  
  mov($t0, $t2, $t3)
  
  saveint($t0)
  savechar($t1)
  savechar($t2)
  savechar($t3)
  savenext($ra)
  
  subi $t4, $t0, 1
  saveint($t4)
  savechar($t1)
  savechar($t2)
  savechar($t3)
  jal hanoi
  
  loadnext($ra)
  loadchar($t3)
  loadchar($t2)
  loadchar($t1)
  loadint($t0)  
  
  jr $ra
  
  
  
  
  
  

  
  
  
  
  
  
  
  
  
  
