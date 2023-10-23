.data
# Command-line arguments
num_args: .word 0
addr_arg0: .word 0
addr_arg1: .word 0
addr_arg2: .word 0
addr_arg3: .word 0
addr_arg4: .word 0
no_args: .asciiz "You must provide at least one command-line argument.\n"

# Output messages
straight_str: .asciiz "STRAIGHT_HAND"
four_str: .asciiz "FOUR_OF_A_KIND_HAND"
pair_str: .asciiz "TWO_PAIR_HAND"
unknown_hand_str: .asciiz "UNKNOWN_HAND"

# Error messages
invalid_operation_error: .asciiz "INVALID_OPERATION"
invalid_args_error: .asciiz "INVALID_ARGS"

# Put your additional .data declarations here, if any.
space: .asciiz " "
array: .word 0,0,0,0,0 #array
length: .word 5 #array length


# Main program starts here
.text
.globl main
main:
    # Do not modify any of the code before the label named "start_coding_here"
    # Begin: save command-line arguments to main memory  
    sw $a0, num_args
    beqz $a0, zero_args
    li $t0, 1
    beq $a0, $t0, one_arg
    li $t0, 2
    beq $a0, $t0, two_args
    li $t0, 3
    beq $a0, $t0, three_args
    li $t0, 4
    beq $a0, $t0, four_args
five_args:
    lw $t0, 16($a1)
    sw $t0, addr_arg4
four_args:
    lw $t0, 12($a1)
    sw $t0, addr_arg3
three_args:
    lw $t0, 8($a1)
    sw $t0, addr_arg2
two_args:
    lw $t0, 4($a1)
    sw $t0, addr_arg1
one_arg:
    lw $t0, 0($a1)
    sw $t0, addr_arg0
    j start_coding_here

zero_args:
    la $a0, no_args
    li $v0, 4
    syscall
    j exit
    # End: save command-line arguments to main memory

start_coding_here:
    # Start the assignment by writing your code here
    lbu $t1, 0($t0)    		# loading the first index byte to $t1
    li $t2, 'D'			# loading the value 'D' into $t2
    li $t3, 'E'			# loading the value 'E' into $t3
    li $t4, 'P'			# loading the value 'P' into $t4
    
    beq $t1, $t2, equal_D	#if ($t1 == $t2 aka 'D')
    beq $t1, $t3, equal_E	#if ($t1 == $t3 aka 'E')
    beq $t1, $t4, equal_P	#if ($t1 == $t4 aka 'P')
    j invalid_operation_line	# jump invalid_command_line if none
    
    # if equal not throwing errors
    equal_D:
    	j check_next_index
    	
    equal_E:
    	j check_next_index
    	
    equal_P:
    	j check_next_index
    	
    # if equal need to throw the error and end code
    invalid_operation_line:
    	la $a0, invalid_operation_error		
    	li $v0,4
    	syscall
    	li $v0,10
    	syscall
    	
    check_next_index:
    	# continue Program... Check next index if it is '\0' or not
    	addi $t0, $t0, 1 			# increment the address to point to next char
    	lbu $t1, 0($t0)				# assign the new char to $t1
    	beq $t1, $zero, valid_operation		# if == null valid
    	j invalid_operation_line		# if not need to throw the error and end code

    # continue Program
    valid_operation:
    	addi $t0, $t0, -1			# decrement the address to point to the first index
    	lbu $t1, 0($t0) 			# assign the first index to $t1
        beq $t1, $t3, e_operation		# if == 'E' check if amount of args are correct
    	beq $t1, $t2, d_operation		# if == 'D' check if amount of args are correct
    	beq $t1, $t4, p_operation		# if == 'P' check if amount of args
     
    # checking args for each special operation
    e_operation:
    	li $t5, 5           			# set $t5 to the correct value for this operation
    	beq $a0, $t5, e_opcode   			# if == 5 valid, else error
    	j invalid_args_line
     	
    d_operation:
    	li $t5, 2           			# set $t5 to the correct value for this operation
    	beq $a0, $t5, valid_d    		# if == 2 valid, else error
    	j invalid_args_line
     
    p_operation:
    	li $t5, 2           			# set $t5 to the correct value for this operation
    	beq $a0, $t5, poker_cards    	# if == 2 valid, else error
    	j invalid_args_line
    	
    invalid_args_line:
    	la $a0, invalid_args_error		
    	li $v0, 4
    	syscall
    	li $v0,10
    	syscall
     	
    # CONTINUE PART 2
    
    # input arguments
    # $a0 - address of the string
    # $a1 - max number of digits to extract
    extract_digit:
    	addi $sp, $sp, -8	  # allocate space on the stack for $t0 and $t1
    	sw $ra, 0($sp)            # save the return address on the stack

    	li $t0, 0                 # initialize the result to 0

    loop_for_extraction:
        lbu $t1, 0($a0)      	  # load a byte from the string
        beqz $t1, result_digit    # if the byte is 0, we are done
    	
    	# calculate the digit value
    	li $t2, 48
    	li $t3, 10
        subu $t1, $t1, $t2        # subtract 48 to get the digit value
        mult $t0, $t3             # multiply the current result by 10
        mflo $t0                  # move the low 32 bits of the multiplication result to $t0
        addu $t0, $t0, $t1        # add the current digit value to the result
        addi $a1, $a1, -1         # decrement the maximum number of digits to extract
        beqz $a1, result_digit    # if we have extracted the maximum number of digits, we are done

        addi $a0, $a0, 1          # increment the string pointer
        j loop_for_extraction     # jump back to the start of the loop

    result_digit:
        move $v0, $t0             # store the result in the register
        lw $ra, 0($sp)            # restore the return address from the stack
        addi $sp, $sp, 8          # free the space on the stack
        jr $ra                    # return to the calling routine
    	
    # example usage of the extract_two_digit procedure
    e_opcode:
    	lw $t0, addr_arg1           		# second arg into $t0
    	li $t4, 2				# setting max amount of digits to 2
    	move $a0, $t0               		# set the address argument for the procedure
    	move $a1, $t4               		# set the max amound of digits
    	jal extract_digit       		# call the procedure
    	move $t6, $v0
    	li $t3, -1				# setting upper bound to 64
    	li $t4, 64				# $t6
    	bge $t6, $t4, invalid_args_line
    	ble $t6, $t3, invalid_args_line

    e_rs_field:
    	lw $t0, addr_arg2           		# third arg into $t0
    	li $t4, 2				# setting max amount of digits to 2
    	move $a0, $t0               		# set the address argument for the procedure
    	move $a1, $t4               		# set the max amound of digits
    	jal extract_digit       		# call the procedure
    	move $t7, $v0
	li $t3, -1				# setting upper bound to 32
    	li $t4, 32				# $t7
    	bge $t7, $t4, invalid_args_line
    	ble $t7, $t3, invalid_args_line
    	
    e_rt_field:
    	lw $t0, addr_arg3           		# fourth arg into $t0
    	li $t4, 2				# setting max amount of digits to 2
    	move $a0, $t0               		# set the address argument for the procedure
    	move $a1, $t4               		# set the max amound of digits
    	jal extract_digit       		# call the procedure
    	move $t8, $v0
    	li $t3, -1				# setting upper bound to 63
    	li $t4, 32				# $t8
    	bge $t8, $t4, invalid_args_line
    	ble $t8, $t3, invalid_args_line
    	
    e_immediate:
    	lw $t0, addr_arg4			# fifth arg into $t0
    	li $t4, 5				# setting max amound of digits to 5
    	move $a0, $t0               		# set the address argument for the procedure
    	move $a1, $t4               		# set the max amound of digits
    	jal extract_digit       		# call the procedure
    	move $t9, $v0
    	li $t3, -1				# setting upper bound to 63
    	li $t4, 65536				# $t9
    	bge $t9, $t4, invalid_args_line
    	ble $t9, $t3, invalid_args_line
    	
    e_bit_shifting:
    	move $a0, $t9				# storing the first 16 from immediate  to $a0
    	sll $t8, $t8, 16			# shift rt left 16
    	or $a0, $a0, $t8			# or the values together rt with $a0
    	sll $t7, $t7, 21			# shift rs left 21
    	or $a0, $a0, $t7			# or the values together rs with $a0
    	sll $t6, $t6, 26			# shift opcode left 26 
    	or $a0, $a0, $t6			# or the values together opcode with $a0
    	
    	li $v0, 34
    	syscall
    	j exit
    	
    # PART 2 COMPLETE
    valid_d:
    	lw $t0, addr_arg1			# loading the arg1 at #t0
    	lbu $t1, 0($t0)				# store the first char into $t1
    	li $t2, '0'				# store 0 in #t2
    	bne $t1, $t2, invalid_args_line		# if first != 0 error
    	addi, $t0, $t0, 1			# increment pointer
    	lbu $t1, 0($t0)				# store the second char into $t2
    	li $t2, 'x'				# $t2 = 'x'
    	bne $t1, $t2, invalid_args_line		# if second != x error
    	li $t2, 2				# storing the length   	
    	
    count_dig_loop:
    	addi,$t0, $t0, 1			# increment pointer  
    	lbu $t1, 0($t0)				# getting new first byte
    	bnez $t1, increment_length		# if not \0 + 1
    	j check_size				
    	increment_length:
    	addi, $t2, $t2, 1		# add 1
    	j count_dig_loop
    check_size: 
    	li, $t3, 10				# $t3 = 10
    	bne $t2, $t3, invalid_args_line		# if != to 10 error
    
    	valid_hex:
	lw $t0, addr_arg1			# reset $t0 to second arg
	addi $t0, $t0, 2			# increment pointer by two
	li $t1, 28				# 28 shifts for full 32 bits
	li $t2, '0'
	li $t3, '9'
	li $t4, 'a'
	li $t5, 'f'
	li $t7, 0				# initialize result to 0
	
	loop_to_get_bits:
		li $t8, 0
		lbu $t6, 0($t0)				# get first char
		beqz $t6, d_immediate			# if null hop out there

		blt $t6, $t4, check_char		# $t6 < 'a'
		bge $t6, $t4, check_char2		# $t6 >= 'a'
		
		check_char:
			blt $t6, $t2, invalid_args_line	# $t6 < '0' error
			ble $t6, $t3, get_bits		# $t6 <= 9 valid
			bgt $t6, $t3, invalid_args_line	# $t6 > 9 invalid
			
		check_char2:
			ble $t6, $t5, get_bits		# $t6 <= 'f' valid
			bgt $t6, $t5, invalid_args_line	# $t6 > 'f' invalid
			
		get_bits:
		li $t8, 9
		sub $t6, $t6, $t2			# subtract '0' to get digit value
		ble $t6, $t8, store_bits		# branch if digit is 0-9
		li $t8, 39
    		sub $t6, $t6, $t8			# adjust for lowercase letters
    	store_bits:
    		li $t8, 0
    		addi $t0, $t0, 1			# increment by 1
    		or $t7, $t7, $t6			# add the bits to the result
    		beq $t1, $t8, loop_to_get_bits		# if more shifting then loop
    		li $t8, 4
    		sll $t7, $t7, 4				# shift left by 4 bits
    		sub $t1, $t1, $t8			# subtract by 4 for each shift
    		j loop_to_get_bits
    		
    d_immediate:
    	li, $t1, 0xFFFF				# the mask to get right 16
    	and $t2, $t1, $t7			# and it and set to new register
    		
    d_rt:
    	li $t1, 0x1F0000			# the mask to get next 5
    	and $t3, $t1, $t7			# and it and set to new register
    	srl $t3, $t3, 16			# shift right 16
    		
    d_rs:
    	li $t1, 0x3E00000			# the mask to get next 5
    	and $t4, $t1, $t7			# and it and set to new register
    	srl $t4, $t4, 21			# shift right 21
    		
    d_opcode: 
    	li $t1, 0xFC000000			# the mask to get next 6
    	and $t5, $t1, $t7			# and it and set to new register
    	srl $t5, $t5, 26			# shift right 26

    d_output:
    	li $t1, 10
    	li $t0, 0
    	blt $t5, $t1, pad_opcode		# less than ten put a leading zero	
    	j no_pad_opcode
    	
    	pad_opcode:
    	move $a0, $t0
    	li $v0, 1
    	syscall
    	
    	no_pad_opcode:
    	move $a0, $t5
    	li $v0, 1
    	syscall					# print opcode					
    	li $v0, 4
    	la $a0, space
    	syscall					# print space
    	
    	blt $t4, $t1, pad_rs			# less than ten put a leading zero	
    	j no_pad_rs
    	
    	pad_rs:
    	move $a0, $t0
    	li $v0, 1
    	syscall
    	
    	no_pad_rs:
    	move $a0, $t4
    	li $v0, 1
    	syscall					# print opcode					
    	li $v0, 4
    	la $a0, space
    	syscall					# print space
    	
    	blt $t3, $t1, pad_rt			# less than ten put a leading zero	
    	j no_pad_rt
    	
    	pad_rt:
    	move $a0, $t0
    	li $v0, 1
    	syscall
    	
    	no_pad_rt:
    	move $a0, $t3
    	li $v0, 1
    	syscall					# print opcode					
    	li $v0, 4
    	la $a0, space
    	syscall					# print space
    	j printing_immediate
    	
    	printing_immediate:
    	li $t0, 10
    	li $t1, 100
    	li $t3, 1000
    	li $t4, 10000
    	
    	blt $t2, $t0, pad_4_d		# if less than 10
    	blt $t2, $t1, pad_3_d		# if < 100
    	blt $t2, $t3, pad_2_d		# if < 1000
    	blt $t2, $t4, pad_1_d		# if < 10000
    	bge $t2, $t4, after_pad		# if >= 10000
    	pad_4_d:
    		li $t5, 4			# amount of zeros needed
    		j pad_immediate
    	pad_3_d:
    		li $t5, 3
    		j pad_immediate
    	pad_2_d:
    		li $t5, 2
    		j pad_immediate
    	pad_1_d:
    		li $t5, 1
    		j pad_immediate
    		
	pad_immediate:
		blez $t5, after_pad
		li $a0, 0
		li $v0, 1
		syscall
		addiu $t5, $t5, -1
		j pad_immediate
    		
    	after_pad:
    		move $a0, $t2
    		li $v0, 1
    		syscall
    		j exit
    							
    even_ranks_get_suite:
    	addi $sp, $sp, -8	  # allocate space on the stack for $t0 and $t1
    	sw $ra, 0($sp)            # save the return address on the stack
    	
    	li $t6, '='
    	ble $a0, $t6, sub_clubs			# if <= '=' - '1'
    	li $t6, 'M'
 	ble $a0, $t6, sub_spade   		# if <= 'M' = 'A'
 	li $t6, ']'
    	ble $a0, $t6, sub_diamond		# if <= ']' - 'Q'
    	li $t6, 'm'
    	ble $a0, $t6, sub_heart			# if <= 'm' - 'a'
    	
    	sub_clubs:
    		li $t6, '1'
    		sub $a0, $a0, $t6
    		li $a1, 'c'
    		j result_rank
    		
    	sub_spade:
    		li $t6, 'A'
    		sub $a0, $a0, $t6
    		li $a1, 's'
    		j result_rank
    		
    	sub_diamond:
    		li $t6, 'Q'
    		sub $a0, $a0, $t6
    	    	li $a1, 'd'	
    		j result_rank
    		
    	sub_heart:
    		li $t6, 'a'
    		sub $a0, $a0, $t6
        	li $a1, 'h'		
    		j result_rank

    	result_rank:
    		addi $a0, $a0, 1
        	move $v0, $a0             # store the result in the register
        	move $v1, $a1             # store the result in the register
        	lw $ra, 0($sp)            # restore the return address from the stack
        	addi $sp, $sp, 8          # free the space on the stack
        	jr $ra                    # return to the calling routine
    
    poker_cards:
    	lw $t0, addr_arg1			# loading the arg1 at #t0
	lbu $t1, 0($t0)				# first card at $s0
    	lbu $t2, 1($t0)				# second card at $s1
    	lbu $t3, 2($t0)				# third card at $s2	
    	lbu $t4, 3($t0)				# fourth card at $s3
    	lbu $t5, 4($t0)				# fifth card at $s0
    
    get_rank_suite:
    	# Check for straight
    	move $a0, $t1				# Register to store rank
    	li $a1, 0        			# Register to store suite
    	jal even_ranks_get_suite
	move $t1, $v0
	move $s1, $v1
	
	move $a0, $t2
    	jal even_ranks_get_suite
	move $t2, $v0
	move $s2, $v1
	
	move $a0, $t3
    	jal even_ranks_get_suite
	move $t3, $v0
	move $s3, $v1
	
	move $a0, $t4
    	jal even_ranks_get_suite
	move $t4, $v0
	move $s4, $v1
	
	move $a0, $t5
    	jal even_ranks_get_suite
	move $t5, $v0
	move $s5, $v1
	
    sort_registers:
    	la $s0, array	# $s0: base address of array
	lw $s1, length	# number of elements in the array
	sw $t1, 0($s0)
	sw $t2, 4($s0)
	sw $t3, 8($s0)
	sw $t4, 12($s0)
	sw $t5, 16($s0)
	
	# initialize outer for-loop variables
	li $t0, 0		# $t0: i = 0	
	addi $t2, $s1, -1	# $t2 is upper bound on outer loop

    outer_loop:
	bge $t0, $t2, end_outer_loop	# repeat until i >= length-1

	sll $s2, $t0, 2			# $s2 = 4*i
	add $s2, $s2, $s0		# $s2 is address of array[i]
	lw $s4, 0($s2)			# $s4 is currentMin; currentMin = array[i]
	move $s5, $s2			# $s5 is address of currentMin
	
	addi $t1, $t0, 1		# j = i + 1
    inner_loop:    
	beq $t1, $s1, end_inner_loop	# repeat until j == length

	sll $s3, $t1, 2			# $s3 = 4*j
	add $s3, $s3, $s0		# $s3 is address of array[j]

	# do we have a new minimum?
	lw $t4, 0($s3)		# $t4 is value at array[j]
	ble $s4, $t4, element_not_smaller # element not smaller than current minimum
	lw $s4, 0($s3)		# we have a new minimum: currentMin = array[j];
	move $s5, $s3		# save address of new minimum
		
    element_not_smaller:		

	addi $t1, $t1, 1	# j++
	j inner_loop
    end_inner_loop:

	# swap array[i] with array[currentMinIndex] if necessary
	beq $s5, $s2, dont_swap # addr of minimum is still addr of array[i], so don't swap
	lw $t3, 0($s2)		# $t3 = array[i]
	sw $t3, 0($s5)		# array[currentMinIndex] = array[i]
	sw $s4, 0($s2)		# array[i] = currentMin	 
	dont_swap:

	addi $t0, $t0, 1	# i++
	j outer_loop
    end_outer_loop:
    	lw $t1, 0($s0)
	lw $t2, 4($s0)
	lw $t3, 8($s0)
	lw $t4, 12($s0)
	lw $t5, 16($s0)

    done_sorting:
    	# the sorted list is now in $t1-$t5
    	# check for $t1, $t2, $t3, $t4 to be equal 4 of kind
    	# then check for $t1, $t2 and $t3, $t4 to be equal pair
    check_straight:
    	sub $t6, $t2, $t1   # compare second and first card ranks
        sub $t7, $t3, $t2   # compare third and second card ranks
        sub $t8, $t4, $t3   # compare fourth and third card ranks
        sub $t9, $t5, $t4   # compare fifth and fourth card ranks
        
    	li $t0, 1
    	bne $t6, $t0, check_fours
    	bne $t7, $t0, check_fours
    	bne $t8, $t0, check_fours
    	bne $t9, $t0, check_fours    			
	j its_a_straight
	
    its_a_straight:
    	la $a0, straight_str
	li $v0, 4
	syscall
	j exit
	
    check_fours:
    	beq $t1, $t2, first_two_match	# 11000
    	beq $t4, $t5, last_two_match	# 00011
    	j no_match
    	
    first_two_match:
    	beq $t3, $t4, double_match 	# 11110 or 11xx0
    	beq $t5, $t4, two_pair    	# 110xx or 111xx or xx111
    	j no_match
    		
    	double_match:
    		beq $t2, $t3, four_kind	# 11110
    		j two_pair		# 11xx0
    last_two_match:
    	beq $t2, $t3, double_match_2	# 001111 or 0011xx
    	j no_match
    		
    	double_match_2:
    		beq $t3, $t4, four_kind	# 001111
    		j two_pair		# 0011xx	
    	
    four_kind:
    	li $v0, 4             		# print string syscall code
    	la $a0, four_str	# load the message string
    	syscall
    	j exit
    	
    two_pair:
    	li $v0, 4             		# print string syscall code
    	la $a0, pair_str	# load the message string
    	syscall
    	j exit
     	
    no_match:
    	li $v0, 4             		# print string syscall code
    	la $a0, unknown_hand_str	# load the message string
    	syscall
    	j exit
    	
exit:
    li $v0, 10
    syscall
