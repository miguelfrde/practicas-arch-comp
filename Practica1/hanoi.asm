# Author: Miguel Flores, Juan Carlos Nuno
# Date: Feb 19, 2014
# Description: program that solves Hanoi Towers puzzle
# Allowed instructions: add, addi, sub, or, ori, and, andi, nor, srl, sll, lw, sw, beq, bne, j, jal, jr.

# Registers:
#   - a0 -> n, represents the disk to move
#   - a1 -> pointer to source tower (A)
#   - a2 -> pointer to auxiliary tower (B)
#   - a3 -> pointer to goal tower (C)
#   - s1 -> $a1 + $s1 = pointer to disk on top of source tower
#   - s2 -> $a2 + $s2 = pointer to disk on top of aux tower
#   - s3 -> $a3 + $s3 = pointer to disk on top of goal tower

.data

.text 

	addi $sp, $zero, 0x10011000
	addi $a0, $zero, 4	#  n = number of disks
	addi $a1, $zero, 268500992
	addi $a2, $zero, 268501024
	addi $a3, $zero, 268501056
	
	#la $a1, A		# Pointer to source tower A
	#la $a2, B		# Load pointers to the first item of each tower (towers are empty, so they
	#la $a3, C		#   point to the first position)
	addi $s1, $zero, -4	# No disks initially
	addi $s2, $zero, -4
	addi $s3, $zero, -4

	add $t0, $zero, $a0	# Counter i = n
	addi $t1, $zero, 268500992		# Pointer to first position of source tower
A_for:	beq $t0, $zero, main	# Loads disks numbers to A tower (from n to 1)
	sw $t0, 0($t1)		# Store i
	addi $t1, $t1, 4	# Increment pointer
	addi $s1, $s1, 4	# Add one disk
	addi $t0, $t0, -1	# Decrement i
	j A_for 	
main:				
	jal hanoi		
	j return


hanoi:  # Non-recursive section
	addi $t0, $zero, 1
	bne $a0, $t0, else	# If n == 1: moves smallest disc from source to destiny
	add $t1, $zero, $ra
	jal simulate
	jr $t1
else:	# Recursive section
	addi $sp, $sp, -20	# Push arguments and $ra to the stack
	sw $a0, 0($sp)		#   n
	sw $a1, 4($sp)		#   pointer to from_0
	sw $a2, 8($sp)		#   pointer to aux_0
	sw $a3, 12($sp)		#   pointer to to_0
	sw $ra, 16($sp)

	add $t1, $zero, $a2	# Swap $a2 (aux) and $a3 (to)
	add $a2, $zero, $a3
	add $a3, $zero, $t1
	add $t2, $zero, $s2	# if we swap pointers, we also need to swap $s2 and $s3
	add $s2, $zero, $s3
	add $s3, $zero, $t2
	addi $a0, $a0, -1
	jal hanoi		# hanoi(n - 1 [a0], from=from [a1], aux=to [a2], to=aux [a3])

	add $t2, $zero, $s2	# unswap $s2 and $s3, needed so that $si always matches $ai
	add $s2, $zero, $s3
	add $s3, $zero, $t2			
				# load arguments from stack
	lw $a0, 0($sp)		#   n
	lw $a1, 4($sp)		#   from
	lw $a2, 8($sp)		#   aux
	lw $a3, 12($sp)		#   to
	lw $ra, 16($sp)
	jal simulate

	add $t1, $zero, $a2	# swap $a1 (from) and $a2 (aux)
	add $a2, $zero, $a1
	add $a1, $zero, $t1
	add $t2, $zero, $s2	# if we swap pointers, we also need to swap $s1 and $s2
	add $s2, $zero, $s1
	add $s1, $zero, $t2
	addi $a0, $a0, -1
	jal hanoi 		# hanoi(n - 1 [a0], from=aux [a1], aux=from [a2], to=to [a3])

	add $t2, $zero, $s2	# unswap $s1 and $s2, needed so that $si always matches $ai
	add $s2, $zero, $s1
	add $s1, $zero, $t2

	lw $ra, 16($sp)
	addi $sp, $sp, 20
	jr $ra


simulate:  # n = $a0, from = $a1, to = $a3
	add $t0, $a1, $s1 	# Point to disk on top of source tower
	sw $zero, 0($t0)	# Remove disk from top of source tower
	addi $s1, $s1, -4

	addi $s3, $s3, 4		# Point to next free space on top of destiny tower
	add $t0, $a3, $s3	
	sw $a0, 0($t0)		# Store disk from top of source tower
	jr $ra

return: 
