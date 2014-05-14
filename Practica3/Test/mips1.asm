.text

	addi $a0, $zero, 10
	jal test
	nop
	nop
	addi $t3,$zero,100
	addi $t3,$zero,100
	nop
	j end
	nop
	
test:
        addi $a0, $zero, 1
	addi $t0, $zero, 1
	addi $t1, $zero, 2	
	nop
	nop
	nop
	beq $a0,$t1, end
	nop
	add $t0, $t0, 1
	jr $ra
	nop
	nop

end:
	addi $t1, $zero, 4