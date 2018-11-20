#Title:							#Filename:
#Author;						#Date:
#Description:
#Input:
#Output:
# # # # # # # # # # # # # # # # Data segment # # # # # # # # # # # # # # # # #
.data
nhap_A: .asciiz " Nhap so thuc a"
nhap_B: .asciiz "Nhap so thuc b"
text_ketqua: .asciiz"Tong a + b = "
A: .float 0
B: .float 0
sum: .float 0
# # # # # # # # # # # # # # # # Code segment # # # # # # # # # # # # # # # # #
.text
.globl main
main:	#Nhap gia tri a va b
	la $a0,nhap_A
	li $v0,4
	syscall
	li $v0,6
	syscall
	swc1 $f0,A
	la $a0,nhap_B
	li $v0,4
	syscall
	li $v0,6
	syscall
	swc1 $f0,B	
	
	
	la $a0,A		#Load d?a ch? c?a A vào a0
	lw $t0,0($a0)		#Load giá tr? c?a A vào t0
	addi $t1,$t0,0		#coppy giá tr? A vào trong t1
	srl $t5,$t5,31		#D?ch ph?i t5 1 bit d? get abs c?a A
	sll $t0,$t0,1		#D?ch trái t0 1 bit và l?u giá tr? vào t5 xóa bit d?u c?a A
	srl $t0,$t0,24		#D?ch ph?i t5 24 bit và l?u giá tr? vào t0, so exponent ? t0
	
	
	la $a1,B		#Load d?a ch? c?a B vào a0
	lw $t2,0($a1)		#Load giá tr? c?a B vào t0
	addi $t3,$t2,0		#Coppy giá tr? B vào trong t2
	srl $t6,$t2,31		#D?ch ph?i t5 1 bit d? get abs c?a B
	sll $t2,$t2,1		#D?ch trái t0 1 bit và l?u giá tr? vào t5 xóa bit d?u c?a B
	srl $t2,$t2,24		#D?ch ph?i t5 24 bit và l?u giá tr? vào t0, so exponent ? t2
	
	
	sll $t1,$t1,9
	sll $t3,$t3,9
	srl $t1,$t1,9
	srl $t3,$t3,9
	lui $t4,128
	add $t1,$t1,$t4
	add $t3,$t3,$t4
	
	beq $t0,$t2,sign
	blt $t0,$t2,expAlessthanB
expBlessthanA:
	addi $t2,$t2,1
	srl $t3,$t3,1
	beq $t0,$t2,sign
	j expBlessthanA
expAlessthanB:
	addi $t0,$t0,1
	srl $t1,$t1,1
	bne $t0,$t2,expAlessthanB
sign:
	beq $t5,$t6,signEqual
	blt $t1,$t3,fracAlessthansigB
	sub $t1,$t1,$t3
	j exponent
fracAlessthansigB:
	sub $t1,$t3,$t1
	addi $t5,$t6,0
	j exponent
signEqual:
	add $t1,$t3,$t1
exponent:
	lui $t4,128
	lui $t6,255
	ori $t6,$t6,65535
	addi $t7,$zero,254
	beq $t1,$zero,zero
	blt $t1,$t4,expDecrease
	blt $t6,$t1,expIncrease
	j assembleFP
expDecrease:
	addi $t0,$t0,-1
	blt $t0,$zero,underflow
	sll $t1,$t1,1
	blt $t1,$t4,expDecrease
	j assembleFP
expIncrease:
	addi $t0,$t0,1
	blt $t7,$t0,overflow
	srl $t1,$t1,1
	blt $t6,$t1,expIncrease
	j assembleFP
underflow:
zero:
	j print
overflow:
	addi $t0,$zero,255
	addi $t1,$zero,0
assembleFP:
	sll $t5,$t5,31
	sll $t0,$t0,23
	or $t9,$t0,$t5
	addi $t4,$t4,-1
	and $t1,$t4,$t1
	or $t9,$t9,$t1
	sw $t9,sum
print:
	la $a0,text_ketqua
	li $v0,4
	syscall
	lwc1 $f12,sum
	li $v0,2
	syscall
	
	
	
	
	
	
