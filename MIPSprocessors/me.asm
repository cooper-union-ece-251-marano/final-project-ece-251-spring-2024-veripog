# mipstest.asm
# David_Harris@hmc.edu 9 November 2005 
#
# Test the MIPS processor.  
#  add, sub, and, or, nor, slt, addi, lw, sw, beq, j
# If successful, it should write the value 7 to address 84

#       Assembly                  Description       
main:   addi $2, $0, 6          # initialize $2 = 6    
        addi $2, $0, 6          # initialize $2 = 6    
        addi $2, $0, 6          # initialize $2 = 6    
        addi $2, $0, 6          # initialize $2 = 6    
        addi $3, $0, 2         # initialize $3 = 2   
        addi $3, $0, 2         # initialize $3 = 2   
        addi $3, $0, 2         # initialize $3 = 2    
        nor  $4, $2, $3         # $4 <= 6 nor 12 = 65521    
        add  $5, $2, $3
        sw   $4, 2($0)         # write adr 84 = 65521