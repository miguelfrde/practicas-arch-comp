.data
#              i= 0  0  0  0  0  0  1  1  1  1  1  1  2  2  2  2  2  2  3  3  3  3  3  3
#              j= 0  0  1  1  2  2  0  0  1  1  2  2  0  0  1  1  2  2  0  0  1  1  2  2  
#              k= 0  1  0  1  0  1  0  1  0  1  0  1  0  1  0  1  0  1  0  1  0  1  0  1
#  24i + 8j + 4k= 0  4  8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92
#	A: .word  1 -3  5  7  9  0  2 -4  6  8  1  3 -1  0  1  0  0  0 -5  7  9  0  1  0
	
# A size: NxMxL = 4x3x2  ==>  access: 24i + 8j + 4k     MLi + 4Lj + 4k
# B size: NxMxL = 3x4x2  ==>  access: 32i + 8j + 4k

.text
	addi $sp, $zero, 0x10011000  # Initial stack pointer
	addi $s0, $zero, 268500992   # Base address of A
	addi $s1, $zero, 268501092   # Base address of B
	addi $s2, $zero, 4           # N
	addi $s3, $zero, 3           # M
	add $t0, $zero, $zero        # i = 0
	
	addi $t0, $zero, 1
	nop
	nop
	nop
	sw $t0, 0($s0)
	addi $t0, $zero, -3
	nop
	nop
	nop
	sw $t0, 4($s0)
	addi $t0, $zero, 5
	nop
	nop
	nop
	sw $t0, 8($s0)
	addi $t0, $zero, 7
        nop
        nop
        nop
	sw $t0, 12($s0)
	addi $t0, $zero, 9
        nop
        nop
        nop
	sw $t0, 16($s0)
	addi $t0, $zero, 0
        nop
        nop
        nop
	sw $t0, 20($s0)
	addi $t0, $zero, 2
        nop
        nop
        nop
	sw $t0, 24($s0)
	addi $t0, $zero, -4
        nop
        nop
        nop
	sw $t0, 28($s0)
	addi $t0, $zero, 6
        nop
        nop
        nop
	sw $t0, 32($s0)
	addi $t0, $zero, 8
        nop
        nop
        nop
	sw $t0, 36($s0)
	addi $t0, $zero, 1
        nop
        nop
        nop
	sw $t0, 40($s0)
	addi $t0, $zero, 3
        nop
        nop
        nop
	sw $t0, 44($s0)
	addi $t0, $zero, -1
        nop
        nop
        nop
	sw $t0, 48($s0)
	addi $t0, $zero, 0
        nop
        nop
        nop
	sw $t0, 52($s0)
	addi $t0, $zero, 1
        nop
        nop
        nop
	sw $t0, 56($s0)
	addi $t0, $zero, 0
        nop
        nop
        nop
	sw $t0, 60($s0)
	addi $t0, $zero, 0
        nop
        nop
	nop
	sw $t0, 64($s0)
	addi $t0, $zero, 0
        nop
        nop
        nop
	sw $t0, 68($s0)
	addi $t0, $zero, -5
        nop
        nop
	nop
	sw $t0, 72($s0)
	addi $t0, $zero, 7
        nop
        nop
	nop
	sw $t0, 76($s0)
	addi $t0, $zero, 9
        nop
        nop
        nop
	sw $t0, 80($s0)
	addi $t0, $zero, 0
        nop
        nop
        nop
	sw $t0, 84($s0)
	addi $t0, $zero, 1
        nop
        nop
	nop
	sw $t0, 88($s0)
	addi $t0, $zero, 0
        nop
        nop
        nop
	sw $t0, 92($s0)	
	nop
	nop	
for_i: 
	add $t1, $zero, $zero        # j = 0	
	beq $t0, $s2, end_for_i      # until i == N
	nop
	nop
for_j:
	beq $t1, $s3, end_for_j      #   until j == M
        nop
        add $a0, $zero, $t0          #     t2 = access_A(i, j) => 6i + 8j
        add $a1, $zero, $t1    
        jal access_A
        nop
        nop
        add $t2, $s0, $v0            #      A[i][j]
        add $a0, $zero, $t1          #     t3 = access_B(j, i) => 8i + 8j        
        add $a1, $zero, $t0
        jal access_B
        nop
        nop
        add $t3, $s1, $v0            #      B[j][i]
        lw $t4, 0($t2)		     #     load A[i][j][0]
        nop
        nop
        nop
        sw $t4, 0($t3)               #     B[j][i][0] = A[i][j][0]
        lw $t4, 4($t2)               #     load A[i][j][1]
        nop
        nop
        nop
        sub $t4, $zero, $t4          #     compute -A[i][j][1]
        nop
        nop
        nop
        sw $t4, 4($t3)               #     B[j][i][0] = -A[i][j][0]
        addi $t1, $t1, 1             #     j++
        nop
        nop
        j for_j
        nop
end_for_j:
	addi $t0, $t0, 1             #   i++
	j for_i
	nop
end_for_i:
	j halt   
	nop
        
access_A:                         # Computes 24*i + 8*j with sums 
	add $t4, $zero, $a0       # Computes 24*i
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t5, $zero, $a1          # Computes 24*j
	add $t5, $t5, $a1
	add $t5, $t5, $a1
	add $t5, $t5, $a1
	add $t5, $t5, $a1
	add $t5, $t5, $a1
	add $t5, $t5, $a1
	add $t5, $t5, $a1
	add $v0, $t4, $t5            # Return 24*i + 8*j
	jr $ra
	nop
	nop
         
access_B:                            # Computes 32*i + 8*j with sums 
	add $t4, $zero, $a0          # Computes 32*i
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t4, $t4, $a0
	add $t5, $zero, $a1          # Computes 32*j
	add $t5, $t5, $a1
	add $t5, $t5, $a1
	add $t5, $t5, $a1
	add $t5, $t5, $a1
	add $t5, $t5, $a1
	add $t5, $t5, $a1
	add $t5, $t5, $a1
	add $v0, $t4, $t5            # Return 32*i + 8*j
	jr $ra
	nop
	nop
halt:
