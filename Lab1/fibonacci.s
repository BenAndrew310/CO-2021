.data
msg1:	.asciiz "Please input a number: "

.text
.globl main

main:
		li	$v0, 4		# call system call: print string
		la	$a0, msg1	# load address of string into $a0
		syscall			# run the syscall
		li	$v0, 5		# call system call: read integer
		syscall			# run the syscall
		move	$a0, $v0	# store input in $a0 (set arugument of procedure fibo)
		jal 	fibo		# call fibo
		move	$a0, $v0	# store return value in $a0
		li	$v0, 1		# call system call: print integer
		syscall			# run the syscall
		j 	EXIT		# jump to EXIT
		
EXIT:
		li	$v0, 10		# call system call: exit
		syscall			# run the syscall
		
fibo:
		addi 	$sp, $sp, -12	# adjust stack for 3 items
		sw 	$ra, 8($sp)	# save return address
		sw 	$s0, 4($sp) 	# save a copy of n in the stack
		sw 	$s1, 0($sp)	# save fibo(n-1) in the stack
		move 	$s0, $a0	# copy argument to register 
		li 	$v0, 0 		# return 0
		beq 	$s0, 0, L0	# branch if n==0
		li 	$v0, 1 		# return 1
		beq 	$s0, 1, L1	# branch if n==1
		addi 	$a0, $s0, -1 	# n >= 2, set argument to n-1
		jal 	fibo		# call fibo with argument (n-1)
		move 	$s1, $v0 	# store result of fibo(n-1) to s1
		addi 	$a0, $s0, -2 	# set argument to n-2
		jal 	fibo		# call fibo with argument (n-2)
		add 	$v0, $s1, $v0 	# add fibo(n-1) to fibo(n-2)
L0:
		lw 	$ra, 8($sp)	# n==0, load return address
		lw 	$s0, 4($sp)	# load n
		lw 	$s1, 0($sp)	# load s1
		addi 	$sp, $sp, 12	# pop 3 items off the stack
		jr 	$ra		# jump to return address
L1:
		lw 	$ra, 8($sp)	# n==1, load return address
		lw 	$s0, 4($sp)	# load n
		lw 	$s1, 0($sp)	# load s1
		addi 	$sp, $sp, 12	# pop 3 items off the stack
		jr 	$ra		# jump to return address

		
		
				
	
