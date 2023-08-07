########################################################################
# This program was written by Prithvi Sajit 
# on 2/07/2021
#
#

	# Requires:
	# - [no external symbols]
	#
	# Provides:
	# - Global variables:
	.globl	symbols
	.globl	grid
	.globl	snake_body_row
	.globl	snake_body_col
	.globl	snake_body_len
	.globl	snake_growth
	.globl	snake_tail

	# - Utility global variables:
	.globl	last_direction
	.globl	rand_seed
	.globl  input_direction__buf

	# - Functions for you to implement
	.globl	main
	.globl	init_snake
	.globl	update_apple
	.globl	move_snake_in_grid
	.globl	move_snake_in_array

	# - Utility functions provided for you
	.globl	set_snake
	.globl  set_snake_grid
	.globl	set_snake_array
	.globl  print_grid
	.globl	input_direction
	.globl	get_d_row
	.globl	get_d_col
	.globl	seed_rng
	.globl	rand_value


########################################################################
# Constant definitions.

N_COLS          = 15
N_ROWS          = 15
MAX_SNAKE_LEN   = N_COLS * N_ROWS

EMPTY           = 0
SNAKE_HEAD      = 1
SNAKE_BODY      = 2
APPLE           = 3

NORTH       = 0
EAST        = 1
SOUTH       = 2
WEST        = 3


########################################################################
# .DATA
	.data

# const char symbols[4] = {'.', '#', 'o', '@'};
symbols:
	.byte	'.', '#', 'o', '@'

	.align 2
# int8_t grid[N_ROWS][N_COLS] = { EMPTY };
grid:
	.space	N_ROWS * N_COLS

	.align 2
# int8_t snake_body_row[MAX_SNAKE_LEN] = { EMPTY };
snake_body_row:
	.space	MAX_SNAKE_LEN

	.align 2
# int8_t snake_body_col[MAX_SNAKE_LEN] = { EMPTY };
snake_body_col:
	.space	MAX_SNAKE_LEN

# int snake_body_len = 0;
snake_body_len:
	.word	0

# int snake_growth = 0;
snake_growth:
	.word	0

# int snake_tail = 0;
snake_tail:
	.word	0

# Game over prompt, for your convenience...
main__game_over:
	.asciiz	"Game over! Your score was "


########################################################################
#
# Your journey begins here, intrepid adventurer!
#
# Implement the following 6 functions, and check these boxes as you
# finish implementing each function
#
#  - [1] main
#  - [1] init_snake
#  - [1] update_apple
#  - [1] update_snake
#  - [1] move_snake_in_grid
#  - [1] move_snake_in_array
#



########################################################################
# .TEXT <main>
	.text
main:

	# Args:     void
	# Returns:
	#   - $v0: int
	#
	# Frame:    $ra
	# Uses:	    $a0, $v0, $t0, $t1
	# Clobbers: $a0, $v0, $t0, $t1
	#
	# Locals:
	#   - 'int direction' in $a0
	#   - 'int score' in $t1
	#
	# Structure:
	#   main
	#   -> [prologue]
	#   -> main__body
	#   -> main__do_loop
	#   -> [epilogue]

	# Code:
main__prologue:
	# set up stack frame
	addiu	$sp, $sp, -4
	sw	$ra, ($sp)

main__body:
	jal	init_snake		# Calling init_snake function
	jal 	update_apple		# Calling update_apple

main__do_loop:
	jal 	print_grid		# Calling print_grid function
	jal 	input_direction		# Calling input_direction

	move	$a0, $v0		# a0 = direction, which is the output of input_direction

	jal 	update_snake		# Calling update_snake function

	move 	$t0, $v0		# t0 = true or fals, which is the output of update_snake

	beq 	$t0, 1, main__do_loop	# While update_snake returns true, keep looping

	li 	$t0, 3			# t0 = 3
	lw 	$t1, snake_body_len	# t1 = snake_body_len
	div	$t1, $t1, $t0		# t1 = snake_body_len / 3
	
	la 	$a0, main__game_over	# load "Game over! Your score was" into $a0	
    	li 	$v0, 4			# printf("%c")
    	syscall

	move 	$a0, $t1		# a0 = score
	li	$v0, 1        		# printf("%d")
    	syscall

    	li 	$a0, '\n'    		# printf("%c", '\n');
    	li   	$v0, 11
    	syscall


main__epilogue:
	# tear down stack frame
	lw	$ra, ($sp)
	addiu 	$sp, $sp, 4

	li	$v0, 0
	jr	$ra			# return 0;

########################################################################
# .TEXT <init_snake>
	.text
init_snake:

	# Args:     void
	# Returns:  void
	#
	# Frame:    $ra
	# Uses:     $a0, $a1, $a2
	# Clobbers: $a0, $a1, $a2
	#
	# Locals:
	#   - None
	#
	# Structure:
	#   init_snake
	#   -> [prologue]
	#   -> init_snake__body
	#   -> [epilogue]

	# Code:
init_snake__prologue:
	# set up stack frame
	addiu	$sp, $sp, -4
	sw	$ra, ($sp)

init_snake__body:
	li	$a0, 7			# a0 = 7
	li 	$a1, 7			# a1 = 7
	li 	$a2, SNAKE_HEAD		# a2 = SNAKE_HEAD

	jal 	set_snake		# Calling set_snake function 

	li 	$a0, 7			# a0 = 7
	li 	$a1, 6			# a1 = 6
	li 	$a2, SNAKE_BODY		# a2 = SNAKE_BODY

	jal	set_snake		# Calling set_snake function

	li	$a0, 7			# a0 = 7
	li 	$a1, 5			# a1 = 5
	li 	$a2, SNAKE_BODY		# a2 = SNAKE_BODY

	jal 	set_snake		# Calling set_snake function

	li 	$a0, 7			# a0 = 7
	li	$a1, 4			# a1 = 4
	li 	$a2, SNAKE_BODY		# a2 = SNAKE_BODY

	jal	set_snake 		# Calling set_snake function

init_snake__epilogue:
	# tear down stack frame
	lw	$ra, ($sp)
	addiu 	$sp, $sp, 4

	jr	$ra			# return;



########################################################################
# .TEXT <update_apple>
	.text
update_apple:

	# Args:     void
	# Returns:  void
	#
	# Frame:    $ra, $s0, $s1
	# Uses:     $a0, $v0, $t0, $t1, $s0, $s1
	# Clobbers: $a0, $v0, $t0, $t1
	#
	# Locals:
	#   - 'int apple_row' in s0
	#   - 'int apple_col' in s1
	#
	# Structure:
	#   update_apple
	#   -> [prologue]
	#   -> update_apple__do_loop
	#   -> [epilogue]

	# Code:
update_apple__prologue:
	addiu 	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$s0, 4($sp)
	sw	$s1, ($sp)


update_apple__do_loop:
	li 	$a0, N_ROWS			# a0 = N_ROWS
	jal 	rand_value			# Calling rand_value function 
	move 	$s0, $v0			# apple_row: s0 = random number depending on N_ROWS, which is the output of rand_value

	li 	$a0, N_COLS			# a0 = N_COLS
	jal	rand_value			# Calling rand_value function 
	move 	$s1, $v0			# apple_col: s1 = random number depending on N_COLS, which is the output of rand_value

	mul 	$t0, $s0, N_COLS		# t0 = apple_row * N_COLS
	add 	$t0, $t0, $s1			# t0 = apple_row * N_COLS + apple_col

	lb 	$t1, grid($t0)			# Store value at address into t1

	bne	$t1, 0, update_apple__do_loop	# If no apple at $t1 then jump to doloop again

	li 	$t1, APPLE			# t1 = APPLE
	sb 	$t1, grid($t0)			# grid[apple_row][apple_col] = APPLE

update_apple__epilogue:
	lw	$ra, 8($sp)
	lw	$s0, 4($sp)
	lw	$s1, 0($sp)
	addiu 	$sp, $sp, 12

	jr	$ra				# return;

########################################################################
# .TEXT <update_snake>
	.text
update_snake:

	# Args:
	#   - $a0: int direction
	# Returns:
	#   - $v0: bool
	#
	# Frame:    $ra, $s0, $s1, $s2
	# Uses:     $a0, $a1, $v0, $t0, $t1, $t2, $t3, $s0, $s1, $s2
	# Clobbers: $a0, $a1, $v0, $t0, $t1, $t2, $t3
	#
	# Locals:
	#   - 'int d_row' in s0
	#   - 'int d_col' in s1
	#   - 'int head_row' in t0
	#   - 'int head_col' in t1
	#   - 'int new_head_row' in s0
	#   - 'int new_head_col' in s1
	#   - 'bool apple' in s2
	#
	# Structure:
	#   update_snake
	#   -> [prologue]
	#   -> update_snake__body
	#   -> update_snake__apple_false
	#   -> update_snake__tail
	#   -> update_snake__return_false
	#   -> update_snake__return_true
	#   -> [epilogue]

	# Code:
update_snake__prologue:
	# set up stack frame
	addiu 	$sp, $sp, -16
	sw	$ra, 12($sp)
	sw	$s0, 8($sp)
	sw	$s1, 4($sp)
	sw	$s2, ($sp)

update_snake__body:
	move 	$s1, $a0				# s1 = direction

	jal 	get_d_row				# Calling get_d_row function
	move 	$s0, $v0				# s0 = row, which is the output of get_d_row

	move 	$a0, $s1				# a0 = direction
	jal	get_d_col				# Calling get_d_row function
	move 	$s1, $v0				# s1 = col, which is the output of get_d_col

	lb 	$t0, snake_body_row			# head_row: t0 = snake_body_row
	lb 	$t1, snake_body_col			# head_col: t1 = snake_body_col

	mul	$t2, $t0, N_COLS			# t2 = head_row * N_COLS	
	add 	$t2, $t2, $t1				# t2 = head_row * N_COLS + head_col

	li 	$t3, SNAKE_BODY				# t3 = SNAKE_BODY
	sb 	$t3, grid($t2)				# grid[head_row][head_col] = SNAKE_BODY

	add	$s0, $t0, $s0				# new_head_row: s0 = head_row + d_row
	add 	$s1, $t1, $s1				# new_head_col: s1 = head_col + d_col

	bltz 	$s0, update_snake__return_false		# if new_head_row < 0 jump to return_false
	bge	$s0, N_ROWS, update_snake__return_false	# if new_head_row >= N_ROWS jump to return false	

	bltz 	$s1, update_snake__return_false		# if new_head_col < 0 jump to return_false
	bge 	$s1, N_COLS, update_snake__return_false	# if new_head_col >= N_COLS jump to return_false

	mul 	$t1, $s0, N_COLS			# t1 = new_head_row * N_COLS
	add 	$t1, $t1, $s1				# t1 = new_head_row * N_COLS + new_head_col
	lb 	$t2, grid($t1)				# t2 = grid[new_head_row][new_head]

	bne 	$t2, APPLE, update_snake__apple_false	# If there is no apple at $t2 jump to apple_false
	li	$s2, 1					# If there is an apple at $t2 then $s2 = 1
	j 	update_snake__tail			# jump over the label which is when there is no apple

update_snake__apple_false:
	li 	$s2, 0					# Since there is no apple, s2 = 0

update_snake__tail:	
	lw 	$t0, snake_body_len			# t0 = snake_body_len
	addi 	$t1, $t0, -1				# t1 = snake_body_len - 1
	sw 	$t1, snake_tail				# snake_tail = t1

	move	$a0, $s0				# a0 = new_head_row
	move	$a1, $s1				# a1 = new_head_col

	jal 	move_snake_in_grid			# Calling move_snake_in_grid

	move 	$t0, $v0				# t0 = true or false, which is the output of move_snake_in_grid
	beqz 	$t0, update_snake__return_false		# If move_snake_in_grid returns false, return false to main

	move 	$a0, $s0				# a0 = new_head_row
	move 	$a1, $s1				# a1 = new_head_col

	jal 	move_snake_in_array			# Calling move_snake_in_array function

	
	bne 	$s2, 1, update_snake__return_true	# If apple == false then jump to end

	lw	$t0, snake_growth			# t0 = snake_growth
	addi 	$t0, $t0, 3				# t0 = snake_growth + 3
	sw 	$t0, snake_growth			# snake_growth = t0

	jal 	update_apple				# Calling update_apple function
	j 	update_snake__return_true		# Jump to the true condition

update_snake__return_false:
	li 	$v0, 0					# Set return value to 0
	j 	update_snake__epilogue			# Jumping to end

update_snake__return_true:
	li	$v0, 1					# Set return value to 1

update_snake__epilogue:
	# tear down stack frame
	lw	$ra, 12($sp)
	lw	$s0, 8($sp)
	lw	$s1, 4($sp)
	lw	$s2, 0($sp)
	addiu 	$sp, $sp, 16

	jr	$ra					# return true or false

########################################################################
# .TEXT <move_snake_in_grid>
	.text
move_snake_in_grid:

	# Args:
	#   - $a0: new_head_row
	#   - $a1: new_head_col
	# Returns:
	#   - $v0: bool
	#
	# Frame:    $ra, $s0, $s1
	# Uses:     $a0, $a1, $v0, $t0, $t1, $t2, $t3, $t4, $s0, $s1
	# Clobbers: $a0, $a1, $v0, $t0, $t1, $t2, $t3, $t4
	#
	# Locals:
	#   - 'int tail' in $t0
	#   - 'int tail_row' in $t1
	#   - 'int tail_col' in $t2
	#
	# Structure:
	#   move_snake_in_grid
	#   -> [prologue]
	#   -> move_snake_in_grid__body
	#   -> move_snake_in_grid__else
	#   -> move_snake_in_grid__bodyV2
	#   -> move_snake_in_grid__return_false
	#   -> move_snake_in_grid__return_true
	#   -> [epilogue]

	# Code:
move_snake_in_grid__prologue:
	addiu 	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$s0, 4($sp)
	sw	$s1, ($sp)

move_snake_in_grid__body:
	move 	$s0, $a0			# s0 = new_head_row
	move 	$s1, $a1			# s1 = new_head_col

	lw 	$t0, snake_growth		# t0 = snake_growth
	
	blez 	$t0, move_snake_in_grid__else	# If snake_growth <= 0 jump to else condition

	lw 	$t0, snake_tail			# t0 = snake_tail
	addi 	$t0, $t0, 1			# t0 = snake_tail + 1
	sw 	$t0, snake_tail			# snake_tail = t0

	lw 	$t0, snake_body_len		# t0 = snake_body_len
	addi	$t0, $t0, 1			# t0 = snake_body_len + 1
	sw 	$t0, snake_body_len		# snake_body_len = t0

	lw 	$t0, snake_growth		# t0 = snake_growth
	addi 	$t0, $t0, -1			# t0 = snake_growth - 1
	sw 	$t0, snake_growth		# snake_growth = t0

	j 	move_snake_in_grid__bodyV2	# Jump over the else condition

move_snake_in_grid__else:
	lw 	$t0, snake_tail			# t0 = snake_tail 

	lb 	$t1, snake_body_row($t0)	# tail_row: t1 = snake_body_row + snake_tail
	lb 	$t2, snake_body_col($t0)	# tail_col: t2 = snake_body_col + snake_taik

	mul 	$t3, $t1, N_COLS		# t3 = tail_row * N_COLS
	add 	$t3, $t3, $t2			# t3 = tail_row * N_COLS + tail_col

	li 	$t4, EMPTY			# t4 = EMPTY
	sb 	$t4, grid($t3)			# grid[tail_row][tail_col] = EMPTY

move_snake_in_grid__bodyV2:
	mul 	$t1, $s0, N_COLS		# t1 = new_head_row * N_COLS
	add 	$t1, $t1, $s1			# t1 = new_head_row * N_COLS + new_head_col

	lb 	$t2, grid($t1)			# t2 = grid[new_head_row][new_head_col] 

	beq 	$t2, SNAKE_BODY, move_snake_in_grid__return_false	# If grid[new_head_row][new_head_col] == SNAKE_BODY jump to return_false

	li 	$t3, SNAKE_HEAD			# t3 = SNAKE_HEAD
	sb 	$t3, grid($t1)			# grid[new_head_row][new_head_col] = SNAKE_HEAD

	j 	move_snake_in_grid_return__true	# Jump over return_false

move_snake_in_grid__return_false:
	li 	$v0, 0				# Set return value as 0
	j 	move_snake_in_grid__epilogue	# Jump to end

move_snake_in_grid_return__true:	
	li 	$v0, 1				# Set return value as 1
	
move_snake_in_grid__epilogue:
	# tear down stack frame
	lw	$ra, 8($sp)
	lw	$s0, 4($sp)
	lw	$s1, ($sp)
	addiu 	$sp, $sp, 12

	jr	$ra				# return

########################################################################
# .TEXT <move_snake_in_array>
	.text
move_snake_in_array:

	# Arguments:
	#   - $a0: int new_head_row
	#   - $a1: int new_head_col
	# Returns:  void
	#
	# Frame:    $ra, $s0, $s1, $s2
	# Uses:     $a0, $a1, $a2, $t0, $t1, $s0, $s1, $s2
	# Clobbers: $a0, $a1, $a2, $t0, $t1
	#
	# Locals:
	# 'int i' in $s0
	#
	# Structure:
	#   move_snake_in_array
	#   -> [prologue]
	#   -> move_snake_in_array__body
	#   -> move_snake_in_array__loop
	#   -> move_snake_in_array__new_head
	#   -> [epilogue]

	# Code:
move_snake_in_array__prologue:
	addiu 	$sp, $sp, -16
	sw	$ra, 12($sp)
	sw	$s0, 8($sp)
	sw	$s1, 4($sp)
	sw	$s2, ($sp)

move_snake_in_array__body:
	lw 	$s0, snake_tail			# i: s0 = snake_tail

	move 	$s1, $a0			# s1 = new_head_row
	move 	$s2, $a1			# s2 = new_head_col

move_snake_in_array__loop:
	blt 	$s0, 1, move_snake_in_array__new_head	# If i < 1, jump to new_head

	addi 	$s0, $s0, -1			# s0 = i - 1

	la 	$t0, snake_body_row		# t0 = snake_body_row 
	add 	$t1, $s0, $t0			# t1 = snake_body_row + (i - 1)
	lb 	$a0, ($t1)			# a0 = snake_body_row[i - 1]

	la 	$t0, snake_body_col		# t0 = snake_body_col
	add 	$t1, $s0, $t0			# t1 = snake_body_col + (i - 1)
	lb	$a1, ($t1)			# a1 = snake_body_col[i - 1]

	addi 	$a2, $s0, 1			# a2 = i

	jal 	set_snake_array			# Calling set_snake_array function

	j 	move_snake_in_array__loop	# Continue looping

move_snake_in_array__new_head:
	move 	$a0, $s1			# a0 = new_head_row
	move 	$a1, $s2			# a1 = new_head_col
	li 	$a2, 0				# a2 = 0

	jal 	set_snake_array			# Calling set_snake_array function

move_snake_in_array__epilogue:
	lw	$ra, 12($sp)
	lw	$s0, 8($sp)
	lw	$s1, 4($sp)
	lw	$s2, ($sp)
	addiu 	$sp, $sp, 16

	jr	$ra 

########################################################################
####                                                                ####
####        STOP HERE ... YOU HAVE COMPLETED THE ASSIGNMENT!        ####
####                                                                ####
########################################################################

##
## The following is various utility functions provided for you.
##
## You don't need to modify any of the following.  But you may find it
## useful to read through --- you'll be calling some of these functions
## from your code.
##

	.data

last_direction:
	.word	EAST

rand_seed:
	.word	0

input_direction__invalid_direction:
	.asciiz	"invalid direction: "

input_direction__bonk:
	.asciiz	"bonk! cannot turn around 180 degrees\n"

	.align	2
input_direction__buf:
	.space	2



########################################################################
# .TEXT <set_snake>
	.text
set_snake:

	# Args:
	#   - $a0: int row
	#   - $a1: int col
	#   - $a2: int body_piece
	# Returns:  void
	#
	# Frame:    $ra, $s0, $s1
	# Uses:     $a0, $a1, $a2, $t0, $s0, $s1
	# Clobbers: $t0
	#
	# Locals:
	#   - `int row` in $s0
	#   - `int col` in $s1
	#
	# Structure:
	#   set_snake
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

	# Code:
set_snake__prologue:
	# set up stack frame
	addiu	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$s0, 4($sp)
	sw	$s1,  ($sp)

set_snake__body:
	move	$s0, $a0		# $s0 = row
	move	$s1, $a1		# $s1 = col

	jal	set_snake_grid		# set_snake_grid(row, col, body_piece);

	move	$a0, $s0
	move	$a1, $s1
	lw	$a2, snake_body_len
	jal	set_snake_array		# set_snake_array(row, col, snake_body_len);

	lw	$t0, snake_body_len
	addiu	$t0, $t0, 1
	sw	$t0, snake_body_len	# snake_body_len++;

set_snake__epilogue:
	# tear down stack frame
	lw	$s1,  ($sp)
	lw	$s0, 4($sp)
	lw	$ra, 8($sp)
	addiu 	$sp, $sp, 12

	jr	$ra			# return;



########################################################################
# .TEXT <set_snake_grid>
	.text
set_snake_grid:

	# Args:
	#   - $a0: int row
	#   - $a1: int col
	#   - $a2: int body_piece
	# Returns:  void
	#
	# Frame:    None
	# Uses:     $a0, $a1, $a2, $t0
	# Clobbers: $t0
	#
	# Locals:   None
	#
	# Structure:
	#   set_snake
	#   -> body

	# Code:
	li	$t0, N_COLS
	mul	$t0, $t0, $a0		#  15 * row
	add	$t0, $t0, $a1		# (15 * row) + col
	sb	$a2, grid($t0)		# grid[row][col] = body_piece;

	jr	$ra			# return;



########################################################################
# .TEXT <set_snake_array>
	.text
set_snake_array:

	# Args:
	#   - $a0: int row
	#   - $a1: int col
	#   - $a2: int nth_body_piece
	# Returns:  void
	#
	# Frame:    None
	# Uses:     $a0, $a1, $a2
	# Clobbers: None
	#
	# Locals:   None
	#
	# Structure:
	#   set_snake_array
	#   -> body

	# Code:
	sb	$a0, snake_body_row($a2)	# snake_body_row[nth_body_piece] = row;
	sb	$a1, snake_body_col($a2)	# snake_body_col[nth_body_piece] = col;

	jr	$ra				# return;



########################################################################
# .TEXT <print_grid>
	.text
print_grid:

	# Args:     void
	# Returns:  void
	#
	# Frame:    None
	# Uses:     $v0, $a0, $t0, $t1, $t2
	# Clobbers: $v0, $a0, $t0, $t1, $t2
	#
	# Locals:
	#   - `int i` in $t0
	#   - `int j` in $t1
	#   - `char symbol` in $t2
	#
	# Structure:
	#   print_grid
	#   -> for_i_cond
	#     -> for_j_cond
	#     -> for_j_end
	#   -> for_i_end

	# Code:
	li	$v0, 11			# syscall 11: print_character
	li	$a0, '\n'
	syscall				# putchar('\n');

	li	$t0, 0			# int i = 0;

print_grid__for_i_cond:
	bge	$t0, N_ROWS, print_grid__for_i_end	# while (i < N_ROWS)

	li	$t1, 0			# int j = 0;

print_grid__for_j_cond:
	bge	$t1, N_COLS, print_grid__for_j_end	# while (j < N_COLS)

	li	$t2, N_COLS
	mul	$t2, $t2, $t0		#                             15 * i
	add	$t2, $t2, $t1		#                            (15 * i) + j
	lb	$t2, grid($t2)		#                       grid[(15 * i) + j]
	lb	$t2, symbols($t2)	# char symbol = symbols[grid[(15 * i) + j]]

	li	$v0, 11			# syscall 11: print_character
	move	$a0, $t2
	syscall				# putchar(symbol);

	addiu	$t1, $t1, 1		# j++;

	j	print_grid__for_j_cond

print_grid__for_j_end:

	li	$v0, 11			# syscall 11: print_character
	li	$a0, '\n'
	syscall				# putchar('\n');

	addiu	$t0, $t0, 1		# i++;

	j	print_grid__for_i_cond

print_grid__for_i_end:
	jr	$ra			# return;



########################################################################
# .TEXT <input_direction>
	.text
input_direction:

	# Args:     void
	# Returns:
	#   - $v0: int
	#
	# Frame:    None
	# Uses:     $v0, $a0, $a1, $t0, $t1
	# Clobbers: $v0, $a0, $a1, $t0, $t1
	#
	# Locals:
	#   - `int direction` in $t0
	#
	# Structure:
	#   input_direction
	#   -> input_direction__do
	#     -> input_direction__switch
	#       -> input_direction__switch_w
	#       -> input_direction__switch_a
	#       -> input_direction__switch_s
	#       -> input_direction__switch_d
	#       -> input_direction__switch_newline
	#       -> input_direction__switch_null
	#       -> input_direction__switch_eot
	#       -> input_direction__switch_default
	#     -> input_direction__switch_post
	#     -> input_direction__bonk_branch
	#   -> input_direction__while

	# Code:
input_direction__do:
	li	$v0, 8			# syscall 8: read_string
	la	$a0, input_direction__buf
	li	$a1, 2
	syscall				# direction = getchar()

	lb	$t0, input_direction__buf

input_direction__switch:
	beq	$t0, 'w',  input_direction__switch_w	# case 'w':
	beq	$t0, 'a',  input_direction__switch_a	# case 'a':
	beq	$t0, 's',  input_direction__switch_s	# case 's':
	beq	$t0, 'd',  input_direction__switch_d	# case 'd':
	beq	$t0, '\n', input_direction__switch_newline	# case '\n':
	beq	$t0, 0,    input_direction__switch_null	# case '\0':
	beq	$t0, 4,    input_direction__switch_eot	# case '\004':
	j	input_direction__switch_default		# default:

input_direction__switch_w:
	li	$t0, NORTH			# direction = NORTH;
	j	input_direction__switch_post	# break;

input_direction__switch_a:
	li	$t0, WEST			# direction = WEST;
	j	input_direction__switch_post	# break;

input_direction__switch_s:
	li	$t0, SOUTH			# direction = SOUTH;
	j	input_direction__switch_post	# break;

input_direction__switch_d:
	li	$t0, EAST			# direction = EAST;
	j	input_direction__switch_post	# break;

input_direction__switch_newline:
	j	input_direction__do		# continue;

input_direction__switch_null:
input_direction__switch_eot:
	li	$v0, 17			# syscall 17: exit2
	li	$a0, 0
	syscall				# exit(0);

input_direction__switch_default:
	li	$v0, 4			# syscall 4: print_string
	la	$a0, input_direction__invalid_direction
	syscall				# printf("invalid direction: ");

	li	$v0, 11			# syscall 11: print_character
	move	$a0, $t0
	syscall				# printf("%c", direction);

	li	$v0, 11			# syscall 11: print_character
	li	$a0, '\n'
	syscall				# printf("\n");

	j	input_direction__do	# continue;

input_direction__switch_post:
	blt	$t0, 0, input_direction__bonk_branch	# if (0 <= direction ...
	bgt	$t0, 3, input_direction__bonk_branch	# ... && direction <= 3 ...

	lw	$t1, last_direction	#     last_direction
	sub	$t1, $t1, $t0		#     last_direction - direction
	abs	$t1, $t1		# abs(last_direction - direction)
	beq	$t1, 2, input_direction__bonk_branch	# ... && abs(last_direction - direction) != 2)

	sw	$t0, last_direction	# last_direction = direction;

	move	$v0, $t0
	jr	$ra			# return direction;

input_direction__bonk_branch:
	li	$v0, 4			# syscall 4: print_string
	la	$a0, input_direction__bonk
	syscall				# printf("bonk! cannot turn around 180 degrees\n");

input_direction__while:
	j	input_direction__do	# while (true);



########################################################################
# .TEXT <get_d_row>
	.text
get_d_row:

	# Args:
	#   - $a0: int direction
	# Returns:
	#   - $v0: int
	#
	# Frame:    None
	# Uses:     $v0, $a0
	# Clobbers: $v0
	#
	# Locals:   None
	#
	# Structure:
	#   get_d_row
	#   -> get_d_row__south:
	#   -> get_d_row__north:
	#   -> get_d_row__else:

	# Code:
	beq	$a0, SOUTH, get_d_row__south	# if (direction == SOUTH)
	beq	$a0, NORTH, get_d_row__north	# else if (direction == NORTH)
	j	get_d_row__else			# else

get_d_row__south:
	li	$v0, 1
	jr	$ra				# return 1;

get_d_row__north:
	li	$v0, -1
	jr	$ra				# return -1;

get_d_row__else:
	li	$v0, 0
	jr	$ra				# return 0;



########################################################################
# .TEXT <get_d_col>
	.text
get_d_col:

	# Args:
	#   - $a0: int direction
	# Returns:
	#   - $v0: int
	#
	# Frame:    None
	# Uses:     $v0, $a0
	# Clobbers: $v0
	#
	# Locals:   None
	#
	# Structure:
	#   get_d_col
	#   -> get_d_col__east:
	#   -> get_d_col__west:
	#   -> get_d_col__else:

	# Code:
	beq	$a0, EAST, get_d_col__east	# if (direction == EAST)
	beq	$a0, WEST, get_d_col__west	# else if (direction == WEST)
	j	get_d_col__else			# else

get_d_col__east:
	li	$v0, 1
	jr	$ra				# return 1;

get_d_col__west:
	li	$v0, -1
	jr	$ra				# return -1;

get_d_col__else:
	li	$v0, 0
	jr	$ra				# return 0;



########################################################################
# .TEXT <seed_rng>
	.text
seed_rng:

	# Args:
	#   - $a0: unsigned int seed
	# Returns:  void
	#
	# Frame:    None
	# Uses:     $a0
	# Clobbers: None
	#
	# Locals:   None
	#
	# Structure:
	#   seed_rng
	#   -> body

	# Code:
	sw	$a0, rand_seed		# rand_seed = seed;

	jr	$ra			# return;



########################################################################
# .TEXT <rand_value>
	.text
rand_value:

	# Args:
	#   - $a0: unsigned int n
	# Returns:
	#   - $v0: unsigned int
	#
	# Frame:    None
	# Uses:     $v0, $a0, $t0, $t1
	# Clobbers: $v0, $t0, $t1
	#
	# Locals:
	#   - `unsigned int rand_seed` cached in $t0
	#
	# Structure:
	#   rand_value
	#   -> body

	# Code:
	lw	$t0, rand_seed		#  rand_seed

	li	$t1, 1103515245
	mul	$t0, $t0, $t1		#  rand_seed * 1103515245

	addiu	$t0, $t0, 12345		#  rand_seed * 1103515245 + 12345

	li	$t1, 0x7FFFFFFF
	and	$t0, $t0, $t1		# (rand_seed * 1103515245 + 12345) & 0x7FFFFFFF

	sw	$t0, rand_seed		# rand_seed = (rand_seed * 1103515245 + 12345) & 0x7FFFFFFF;

	rem	$v0, $t0, $a0
	jr	$ra			# return rand_seed % n;

