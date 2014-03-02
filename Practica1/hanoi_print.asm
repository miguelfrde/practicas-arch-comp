# Author: Miguel Flores, Juan Carlos Nuno
# Date: Feb 19, 2014
# Description: program that solves Hanoi Towers puzzle
# Allowed instructions: add, addi, sub, or, ori, and, andi, nor, srl, sll, lw, sw, beq, bne, j, jal, jr.

# Registers:
#   - a0 -> n, represents the disk to move
#   - a1 -> source tower (A)
#   - a2 -> auxiliary tower (B)
#   - a3 -> goal tower (C)

.data
	printMove: .asciiz "Move disk "
	printFrom: .asciiz " from "
	printTo:   .asciiz " to "
	printBr:   .asciiz "\n"

.text 

main:		
	add $a0, $zero, 3	#  n = number of disks
	addi $a1, $zero, 0	# Source tower: A
	addi $a2, $zero, 1 	# Auxiliary tower: B
	addi $a3, $zero, 2 	# Destiny tower: C		
	jal hanoi		
	j return
	

hanoi:  # Non-recursive section
	addi $t0, $zero, 1
	bne $a0, $t0, else	# If n == 1: moves smallest disc from source to destiny
	add $t1, $zero, $ra
	jal print
	jr $t1
else:	# Recursive section
	addi $sp, $sp, -20	# Push arguments and $ra to the stack
	sw $a0, 0($sp)		#   n
	sw $a1, 4($sp)		#   from
	sw $a2, 8($sp)		#   aux
	sw $a3, 12($sp)		#   to
	sw $ra, 16($sp)
	
	add $t1, $zero, $a2	# Swap $a2 (aux) and $a3 (to)
	add $a2, $zero, $a3
	add $a3, $zero, $t1
	addi $a0, $a0, -1
	jal hanoi		# hanoi(n - 1 [a0], from=from [a1], aux=to [a2], to=aux [a3])
				# load arguments from stack
	lw $a0, 0($sp)		#   n
	lw $a1, 4($sp)		#   from
	lw $a2, 8($sp)		#   aux
	lw $a3, 12($sp)		#   to
	lw $ra, 16($sp)
	jal print
	
	add $t1, $zero, $a2	# swap $a1 (from) and $a2 (aux)
	add $a2, $zero, $a1
	add $a1, $zero, $t1
	addi $a0, $a0, -1
	jal hanoi 		# hanoi(n - 1 [a0], from=aux [a1], aux=from [a2], to=to [a3])
	
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	jr $ra
	
print:  # n = $a0, from = $a1, to = $a3
	add $t4, $zero, $a0
	addi $v0, $zero, 4	# Print "Move"	
	la $a0, printMove
	syscall
	addi $v0, $zero, 1	# Print <n>
	add $a0, $zero, $t4
	syscall
	addi $v0, $zero, 4	# Print "from"
	la $a0, printFrom
	syscall
	addi $v0, $zero, 11	# Print <from>
	add $a0, $a1, 65 
	syscall
	addi $v0, $zero, 4	# Print "To"
	la $a0, printTo	
	syscall
	addi $v0, $zero, 11	# Print <to>
	add $a0, $a3, 65
	syscall
	addi $v0, $zero, 4	# Print breakline
	la $a0, printBr
	syscall
	add $a0, $zero, $t4	# Don't forget to put $a0 back!
	jr $ra
							
return:
	
