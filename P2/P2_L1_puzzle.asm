.data
  maze: .space 400 # maze[10][10]
  stack: .space 2000 # (7*7) * 8 * 4 <= 2000
  dx: .space 20 # int dx[5]
  dy: .space 20 # int dy[5]

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

.macro end
  li $v0, 10
  syscall
.end_macro

.macro maze_index(%dst, %line, %col, %rank)
  mult %line, %rank
  mflo %dst
  add %dst, %dst, %col
  sll %dst, %dst, 2
.end_macro

.macro index(%dst, %index)
  sll %dst, %index, 2
.end_macro

.macro save(%reg)
  addiu $sp, $sp, -4
  sw %reg, 0($sp)
.end_macro

.macro load(%reg)
  lw %reg, 0($sp)
  addiu $sp, $sp, 4
.end_macro

.text
  # initialization
  la $sp, stack
  addiu $sp, $sp, 2000
  
  # initialize dx[4]
  move $t0, $0
  index($t1, $t0)
  li $t2, 1
  sw $t2, dx($t1)
  
  addiu $t0, $t0, 1
  index($t1, $t0)
  li $t2, 0
  sw $t2, dx($t1)
  
  addiu $t0, $t0, 1
  index($t1, $t0)
  li $t2, -1
  sw $t2, dx($t1)
  
  addiu $t0, $t0, 1
  index($t1, $t0)
  li $t2, 0
  sw $t2, dx($t1)

  # initialize dy[4]
  move $t0, $0
  index($t1, $t0)
  li $t2, 0
  sw $t2, dy($t1)
  
  addiu $t0, $t0, 1
  index($t1, $t0)
  li $t2, -1
  sw $t2, dy($t1)
  
  addiu $t0, $t0, 1
  index($t1, $t0)
  li $t2, -0
  sw $t2, dy($t1)
  
  addiu $t0, $t0, 1
  index($t1, $t0)
  li $t2, 1
  sw $t2, dy($t1)  
  
  
  #input
  readint($s0) # n
  readint($s1) # m
  addi $t0, $0, 1 # i = 1
  loop0:
    bgt $t0, $s0, end0
    addi $t1, $0, 1 # j = 1
    loop1:
      bgt $t1, $s1, end1

      maze_index($t2, $t0, $t1, $s1)
      readint($t3) # input
      sw $t3, maze($t2)

      addiu $t1, $t1, 1
      j loop1
    end1:
    addiu $t0, $t0, 1
    j loop0
  end0:
  readint($t0) # beginx
  readint($t1) # beginy
  readint($s2) # endx
  readint($s3) # endy
  move $s4, $0 # cnt = 0
  
  maze_index($t3, $t0, $t1, $s1)
  li $t4, 1 # 1
  sw $t4, maze($t3)

  move $a0, $t0
  move $a1, $t1
  jal dfs
  printint($s4)
  end
  
dfs: 
  move $t0, $a0 # t0 = fx
  move $t1, $a1 # t1 = fy
  if2:
    bne $t0, $s2, end2
    bne $t1, $s3, end2
    addi $s4, $s4, 1
    jr $ra
  end2:

  move $t2, $0 # i
  for3:
    bge $t2, 4, end3

    index($t3, $t2)
    lw $t3, dx($t3)
    add $t3, $t3, $t0 # xx

    index($t4, $t2)
    lw $t4, dy($t4)
    add $t4, $t4, $t1 # yy

    if4:
      ble $t3, $zero, end4
      bgt $t3, $s0, end4
      ble $t4, $zero, end4
      bgt $t4, $s1, end4

      maze_index($t5, $t3, $t4, $s1)
      lw $t5, maze($t5) # maze[xx][yy]
      beq $t5, 1, end4

      maze_index($t5, $t3, $t4, $s1)
      li $t6, 1 # 1
      sw $t6, maze($t5)

      # recursion
      
      save($t0)
      save($t1)
      save($t2)
      save($t3)
      save($t4)
      save($ra)

      move $a0 $t3
      move $a1, $t4

      jal dfs

      load($ra)
      load($t4)
      load($t3)
      load($t2)
      load($t1)
      load($t0)

      # end_recursion

      maze_index($t5, $t3, $t4, $s1)
      sw $zero, maze($t5)

    end4:
    addiu $t2, $t2, 1
    j for3
  end3:
  jr $ra
