.data
msg1:	.asciiz "Please input a number: "
msg2:	.asciiz "It's a prime\n"
msg3:   .asciiz "It's not a prime\n"

.text
.globl main
#------------------------- main -----------------------------
main:
		li      $v0, 4			# call system call: print string
		la      $a0, msg1		# load address of msg1 into $a0
		syscall                 	# run the syscall

 		li      $v0, 5          	# call system call: read integer
  		syscall                 	# run the syscall
  		move    $a0, $v0      		# store input in $a0 (set arugument of procedure prime)

  		jal PRIME			# call procedure PRIME
		move 	$t0, $v0		# save return value in t0 (because v0 will be used by system call) 
		beq	$t0, $zero, ELSE  	# branch to ELSE if it is not a prime number

		li      $v0, 4			# call system call: print string
		la      $a0, msg2		# load address of msg2 into $a0
		syscall                 	# run the syscall
		j 	EXIT			# jump to EXIT
			
ELSE:
		li      $v0, 4			# call system call: print string
		la      $a0, msg3		# load address of msg3 into $a0
		syscall                 	# run the syscall
		j 	EXIT			# jump to EXIT
  		
EXIT:
		li 	$v0, 10			# call system call: exit
  		syscall				# run the syscall
		
.text
#--------------------------------------------------------- PRIME --------------------------------------------------------------------
PRIME:
 		addi 	$sp, $sp, -4		# adjust stack for 1 item
 		sw 	$ra, 0($sp)		# store the return address in the stack
 		li 	$s0, 2               	# set i = 2
 		beq 	$a0, 1, FLAG_0  	# if  n == 1, branch to FLAG_0
 		j 	LOOP			# jump to LOOP		
  				
LOOP:
		mul 	$s1, $s0, $s0		# set s1 = i*i
 		slt 	$t2, $a0, $s1		# check if n < s1
 		bne 	$t2, $zero, FLAG_1  	# if n >= s1, branch to FLAG_1
		div 	$a0, $s0   		# n / i
		mfhi 	$t0       		# get remainder value from register hi
		beq 	$t0, $zero, FLAG_0 	# if remainder if 0, branch to FLAG_0
		addi 	$s0, $s0, 1   		# set i += 1
		j 	LOOP  			# jump back in the loop
		
FLAG_0: 
 		li 	$v0, 0			# return 0
 		j 	RETURN			# jump to RETURN
		
FLAG_1:                    
		li 	$v0, 1			# return 1
		j 	RETURN			# jump to RETURN
		
RETURN:
		lw 	$ra, 0($sp)  		# pop return address from sp
 		addi 	$sp, $sp, 4 		# free the stack
 		jr 	$ra       		# jump register
