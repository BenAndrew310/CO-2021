.data
msg:		.asciiz "Please input a number: "
char1:		.asciiz " "
char2:		.asciiz "*"
char3:		.asciiz "\n"

.text
.globl main
#-------------------------------------------------- main --------------------------------------------

main:
		li 	$v0, 4		# call system call: print string
		la	$a0, msg	# load address of string into $a0
		syscall			# run syscall
		li	$v0, 5		# call system call: read integer
		syscall			# run syscall
		move	$s0, $v0	# store input n in $s0
		j 	LOOP1_SETUP	# jump to LOOP1_SETUP

LOOP1_SETUP:		
		li	$t0, 1 		# set i = 1
		li	$t1, 1		# set j = 1
		j 	LOOP1		# jump to loop 1
		
LOOP1:
		slt	$t2, $s0, $t0 			# check if n < i
		bne	$t2, $zero, LOOP2_SETUP		# if n < i, branch to LOOP2_SETUP
		j 	LOOP1_INNER1_SETUP		# jump to LOOP1_INNER1_SETUP
		
LOOP1_INNER1_SETUP:
		li	$t1, 1		# set j = 1
		j 	LOOP1_INNER1	# jump to LOOP1_INNER1

LOOP1_INNER1:
		sub	$t3, $s0, $t0 				# set t3 = n-i
		slt	$t2, $t3, $t1 				# set t3 < j
		bne	$t2, $zero, LOOP1_INNER2_SETUP		# if t3 < j, branch to LOOP1_INNER2,SETUP
		
		li	$v0, 4		# call sytem call: print string
		la	$a0, char1	# load address of string into $a0
		syscall			# run syscall
		
		addi	$t1, $t1, 1	# set j += 1
		j 	LOOP1_INNER1	# jump to LOOP1_INNER1
		
LOOP1_INNER2_SETUP:
		sub	$t1, $s0, $t0	# set j = n-i
		addi	$t1, $t1, 1	# set j += 1
		j 	LOOP1_INNER2	# jump to LOOP1_INNER2
		
LOOP1_INNER2:
		add	$t3, $s0, $t0 			# set t3 = n+i
		slt	$t2, $t1, $t3  			# check if j < t3
		beq	$t2, $zero, NEXT_LINE_LOOP1	# if j >= t3, jump to NEXT_LINE_LOOP1
		
		li	$v0, 4		# call system call: print string
		la	$a0, char2	# load address of string into $a0
		syscall			# run syscall
		
		addi	$t1, $t1, 1	# set j += 1
		j 	LOOP1_INNER2	# jump to LOOP1_INNER2	
		
NEXT_LINE_LOOP1:
		li	$v0, 4		# call system call: print string
		la	$a0, char3	# load address pf string into $a0
		syscall			# run syscall
		
		addi	$t0, $t0, 1	# set i += 1
		j 	LOOP1		# jump to LOOP1	
		
LOOP2_SETUP:
		subi	$t0, $s0, 1	# set i = n-1
		li	$t1, 1		# set j = 1
		j 	LOOP2		# jump to LOOP2

LOOP2:
		slti	$t2, $t0, 1		# check if i<1
		bne	$t2, $zero, EXIT	# if i<1, EXIT
		j 	LOOP2_INNER1_SETUP	# jump to LOOPO2_INNER1_SETUP
		
LOOP2_INNER1_SETUP:
		li	$t1, 1		# set j = 1
		j 	LOOP2_INNER1	# jump to LOOP2_INNER1
		
LOOP2_INNER1:
		sub	$t3, $s0, $t0			# set t3 = n-i
		slt	$t2, $t3, $t1			# check if t3 < j
		bne	$t2, $zero, LOOP2_INNER2_SETUP	# if t3 < j, branch to LOOP2_INNER2_SETUP
		
		li	$v0, 4		# call system call: print string
		la	$a0, char1	# load address of string into $a0
		syscall			# run syscall
		
		addi	$t1, $t1, 1	# set j += 1
		j 	LOOP2_INNER1	# jump to LOOP2_INNER1 
		
LOOP2_INNER2_SETUP:
		sub	$t1, $s0, $t0	# set j = n - i
		addi	$t1, $t1, 1    	# set j += 1
		j 	LOOP2_INNER2	# jump to LOOP2_INNER2

LOOP2_INNER2:
		add	$t3, $s0, $t0			# set t3 = n+i
		slt	$t2, $t1, $t3  			# check if j < t3
		beq	$t2, $zero, NEXT_LINE_LOOP2	# if j >= t3, branch to NEXT_LINE_LOOP2
		li	$v0, 4		# call system call: print string
		la	$a0, char2	# load address of string into $a0
		syscall			# run syscall
		
		addi	$t1, $t1, 1	# set j += 1
		j 	LOOP2_INNER2	# jump to LOOOP2_INNER2
		
NEXT_LINE_LOOP2:
		li	$v0, 4		# call system call: print string
		la	$a0, char3	# load address of string into $a0
		syscall			# run syscall
		
		subi	$t0, $t0, 1	# set i -= 1
		j 	LOOP2		# jump to LOOP2 
		
EXIT:
		li $v0, 10		# call system call: exit
  		syscall			# run the syscall		
				  
				  		  
		  
