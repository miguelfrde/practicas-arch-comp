	addi $s0, $zero, 4
	addi $a0, $zero, 0
	addi $s1, $zero, 3
	addi $t0, $zero, 0
for_i:
	add $zero, $zero, $zero
	add $zero, $zero, $zero
	beq $a0, $s0, end_for_i
	add $zero, $zero, $zero
	addi $a1, $zero, 0
for_j:
	add $zero, $zero, $zero
	add $zero, $zero, $zero
	add $zero, $zero, $zero
	beq $a1, $s1, end_for_j
	add $zero, $zero, $zero
	addi $t0, $t0, 1
	addi $a1, $a1, 1
	j for_j
	add $zero, $zero, $zero
end_for_j:
	addi $a0, $a0, 1
	j for_i
	add $zero, $zero, $zero
end_for_i:
	addi $t0, $t0, 100