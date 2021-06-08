.data
	msg1: .asciiz "\n\nEnter a number to verify it is a palindrome: "
	msg2: .asciiz "\nPalindrome"
	msg3: .asciiz "\nThe closest palindrome number from this is: "
	msg4: .asciiz "\nThe value entered is not in the range (9 < number < 10000)"
.text

main:

	add $t4, $zero, $zero					#necessary to clear registers becauif if the program is executed more than once they can influence the result
	add $t5, $zero, $zero

	li $v0, 4
	la $a0, msg1
	syscall
	
	li $v0, 5
	syscall
	add $t1, $v0, $zero						#t1 receive entered value
	
	bge $t1, 10000, invalid_value			#checks if the value is in the range (1 < number < 10000)
	ble $t1, 9, invalid_value				#check if number has only one digit
	
	j palindrome
	
	invalid_value:
	
	li $v0, 4
	la $a0, msg4
	syscall
	
	j main
	
	palindrome:								#function that checks if the number is palindrome
	
		add $t2, $t1, $zero					#copies the value of the entered value as it must not be overwritten, it will be uifd in the comparison
	
		while:
	
			divu $t3, $t2, 10 				#will check how many times the entered value is divisible by 10, process necessary for the inverter the value
			mfhi $t3						#mod equivalent
	
			mul $t4, $t4, 10				#t4 will store the inverted number
			add $t4, $t4, $t3
	
			divu $t2, $t2, 10
			mflo $t3						#div equivalent
	
			bne $t2, 0, while				#check if the value is different from 0
	
			beq $t1, $t4, if
			j else
	
			if:
	
				beq $t5, 1, increments_palindrome
	
				li $v0, 4
				la $a0, msg2
				syscall
				j end
	
			else:
	
				add $t4, $zero, $zero
				add $t1, $t1, 1
				add $t5, $zero, 1			#flag to find out if the palindrome was informed by the uifr or by the system
				
				j palindrome
	
		increments_palindrome:				#increments the typed value and returns to the function that checks if the number is palindrome
	
		li $v0, 4
		la $a0, msg3
		syscall	
	 
		li $v0, 1
		add $a0, $t1, $zero
		syscall

	end: