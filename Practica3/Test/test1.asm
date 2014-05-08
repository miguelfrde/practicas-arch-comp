#Test, please read.
addi $1,$zero,1		#result 1
addi $2,$zero,40	# result 40
addi $3,$2,20		# result 60
addi $4,$2,40		# result 80
addi $5,$4,10		# result 90

add $6,$5,1		# result 91
add $7,$6,1		# result 92
sub $8,$7,$1		# result 91
addi $9,$7,8		# result 100
addi $10,$8,10		# result 101

#Big number adding
#addi $11,$zero,0x10010040
lui $1, 0x00001001 	#upper 4 bytes are 1001
nop
nop
ori $1, $1, 0x0000040 	#lower 4 bytes
add $11,$0,$1		#add to 11

#Storing in memory
add $12,$zero,$10	# result 101
nop			#nops for waiting wb from last instruction
nop
addi $11,$11,4		#$11 is forwarded
sw $12,0($11)		#Note that $12 is not forwarded but $11 is

#Reading from memory (Worst case)
nop
nop
lw $13,	0($11) #wait two cycles before attempting to read data
nop
nop		#Wait two cycles after loading
add $14, $13, $2	#Result 141
sub $10, $10, $2	#Result 61

# two nops are needed after jump operation
j GO
nop
nop

add $1, $2, $3

GO:
add $10,$10,$2		#result 101
jal HEY			#Two nops are needed for Jump (JAL) instruction
nop
nop
j EXIT
nop
nop

HEY:
addi $15, $zero, 15	#Last relevant ALU result is 15
jr $31			#two nops are needed for Jump (JR) instruction
nop
nop

EXIT:
#Cleaning pipeline
nop
nop
nop
nop
