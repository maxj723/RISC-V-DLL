# This is the equivalent of:
#
# #include <stdlib.h>
#
# typedef struct dll_node{
#    int the_int;
#    struct dll_node* prev_node;
#    struct dll_node* next_node;
# }dll_node;
#
# typedef struct dllist{
#    struct dll_node* head_ptr;
#    struct dll_node* tail_ptr;
# }dllist;
# int main(){ dllist* the_list = ( dllist* )calloc( 1, sizeof(dllist) );
#
# for(int y = 3; y >= 0; --y){
#    if(the_list->head_ptr == NULL){
#        dll_node* made_node = ( dll_node* )calloc( 1, sizeof(dll_node) );
#        made_node->the_int = y;
#        the_list->head_ptr = made_node; 
#        the_list->tail_ptr = made_node; 
#    }
# }
#
# free(the_list);
# return 0;
# }



MAIN:

# Step 1 - x18 points to address 0x7ffff620
lui x5, 0x7ffff
addi x18, x5, 0x620
add x5, x0, x0

# Step 2 - Call the function calloc for the dllist struct
# 2-1 - Must pass a *copy* of the pointer to the function. Use Function arguments (leave a0, a1)
add x12, x18, x0
jal x1, CALLOC_DLLIST 
add x1, x0, x0     # FIX 1 - Empty x0 since we returned from the function call
add x12, x0, x0    # Empty x12 since it is out of scope

# Step 6 - Setting up the first main loop
addi x19, x0, 3   # y = 3
addi x5, x0, 0    # Reuse x5 = 0

BEGIN_FOR: 
blt x19, x5, END_FOR

# Step 7 - Set up the insertion loop
# 7.1 - Check if(the_list->head_node == NULL)
IF: 
lw x7, 0(x18)
bne x7, x0, ELSE

# 7.2 - Get the address of x18 + 16 bytes
addi x28, x18, 16
add x12, x28, x0
jal x1, CALLOC_DLLIST
add x1, x0, x0
add x12, x0, x0

# 7.5 - Create the node itself
sw x19, 0(x28)   	# made_node->the_int = y;
sw x28, 0(x18)		# the_list->head_node = made_node;
sw x28, 4(x18)		# the_list->tail_node = made_node;

###########################################
#### THE CHANGE FOR THE LOOP ENDS HERE ####
#### Check the return 0 comment as well####
###########################################

# 7.3 - Clear local registers and branch to END_IF
add x28, x0, x0  # x28 goes out of scope before ELSE_IF

beq x0, x0, END_IF

ELSE:

# Do nothing so far

# 7.4 - Clear x7, increment ++x, and branch back to BEGIN_FOR
END_IF:
add x7, x0, x0   # Clear x7 since it is about to go out of scope (was designed at IF)


addi x19, x19, -1      # ++i;
beq x0, x0, BEGIN_FOR # Go back to the beginning of the loop

END_FOR:
add x6, x0, x0
add x5, x0, x0

# Step 4 - Free the dllist struct main call
add x12, x18, x0    # Pointer to the_list is copied to x12
jal x1, FREE_DLLIST # free(the_list);
add x1, x0, x0     # FIX 2 - Empty x0 since we returned from the function call
add x12, x0, x0    # Empty x12
add x18, x0, x0     # x18 is no longer pointing to the memory


# Step 0 - Return 0
add x19, x0, x0    # Reset i to 0
add x6, x0, x0     # Reset x6 to 0
add x5, x0, x0     # Set temp x5 to 0 to return 0;
beq x0, x0, END


# Step 3 - Allocate the memory for the dllist struct
##########################################
# Procedure Name: CALLOC_DLLIST
# Pre-conditions: x12 contains the base address of an dll_node
# Post-conditions: x1 contains the return address of the calling procedure
#
# This procedure clears 128 bits (16 bytes) of memory 
# to be allocated to a dll_node
##########################################
CALLOC_DLLIST:

# 3-1 - calloc overwrites the memory at that location with 0
# Note - Problem says every 128 bits must be cleared, which is 16 bytes
sw x0, 0(x12)
sw x0, 4(x12)
sw x0, 8(x12)
sw x0, 12(x12)

# 3-2 Jump and link back to main
jalr x0, x1, 0



# Step 5 - Free the dllist Procedure
##########################################
# Procedure Name: FREE_DLLIST
# Pre-conditions: x12 contains the base address of an dll_node
# Post-conditions: 
#
# This procedure clears 128 bits (16 bytes) of memory 
# previously allocated to a dll_node
##########################################
FREE_DLLIST:

# 5-1 Must clear the memory pointed to by x12
sw x0, 0(x12)
sw x0, 4(x12)
sw x0, 8(x12)
sw x0, 12(x12)


# 5-2 Jump and link back to main
jalr x0, x1, 0

END:
quit
