.data
  a1: .space 500
  a2: .space 500
  ans: .space 500
  enter: .asciiz "\n"
  space: .asciiz " "


.macro end
  li $v0, 10
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

.macro printstr(%str)
  li $v0, 4
  la $a0, %str
  syscall
.end_macro

.macro index(%dst, %line, %col, %rank)
  mult %line, %rank
  mflo %dst
  add %dst, %dst, %col
  sll %dst, %dst, 2
.end_macro

.macro penter
  li $v0, 4
  la $a0, enter
  syscall
.end_macro

.macro pspace
  li $v0, 4
  la $a0, space
  syscall
.end_macro



.text

  # input
  readint($s0)
  readint($s1)
  readint($s2)
  readint($s3)

  move $t0, $zero
  L0:
    bge $t0, $s0, E0
    move $t1, $zero
    L1:
      bge $t1, $s1, E1

      index($t2, $t0, $t1, $s1)
      readint($t3)
      sw $t3, a1($t2)
      
      addiu $t1, $t1, 1
      j L1
    E1:
    addiu $t0, $t0, 1
    j L0
  E0:
  
  move $t0, $zero
  L2:
    bge $t0, $s2, E2
    move $t1, $zero
    L3:
      bge $t1, $s3, E3

      index($t2, $t0, $t1, $s3)
      readint($t3)
      sw $t3, a2($t2)
      
      addiu $t1, $t1, 1
      j L3
    E3:
    addiu $t0, $t0, 1
    j L2
  E2:

  # processing
  sub $s4, $s0, $s2
  sub $s5, $s1, $s3
  addi $s4, $s4, 1
  addi $s5, $s5, 1

  move $t0, $zero # i
  L10:
    bge $t0, $s4, E10
    move $t1, $zero # j
    L4:
      bge $t1, $s5, E4
      move $t9, $zero # value of g[i][j]
      move $t2, $zero # k
      L5:
        bge $t2, $s2, E5
        move $t3, $zero # l
        L6:
          bge $t3, $s3, E6
          add $t4, $t0, $t2
          add $t5, $t1, $t3
          index($t6, $t4, $t5, $s1)
          lw $t4, a1($t6) # f(i+k, j+l)

          index ($t6, $t2, $t3, $s3)
          lw $t5, a2($t6) # h(k, l)

          mult $t4, $t5
          mflo $t4
          add $t9, $t9, $t4

          addiu $t3, $t3, 1
          j L6
        E6:
        addiu $t2, $t2, 1
        j L5
      E5:
      # store g(i, j)
      index($t3, $t0, $t1, $s5)
      sw $t9, ans($t3)

      addiu $t1, $t1, 1
      j L4
    E4:
    addiu $t0, $t0, 1
    j L10
  E10:

  #output
  move $t0, $zero
  L7:
    bge $t0, $s4, E7
    move $t1, $zero
    L8:
      bge $t1, $s5, E8

      index($t2, $t0, $t1, $s5)
      lw $t2, ans($t2)
      printint($t2)
      pspace

      addiu $t1, $t1, 1
      j L8
    E8:
    penter
    addiu $t0, $t0, 1
    j L7
  E7:

  end
    

    

  
  
  
