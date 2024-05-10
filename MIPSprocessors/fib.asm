# Initialization
    addi    R1, R0, 2       # R1 = 2 (start calculating from F(2))
    addi    R2, R0, 1       # R2 = F(1) = 1
    addi    R3, R0, 0       # R3 = F(0) = 0
    sw      R3, 0(R0)       # Store F(0) at address 0
    sw      R2, 4(R0)       # Store F(1) at address 4
    addi    R5, R0, 10      # Calculate Fibonacci until F(10) (example)

# Main Loop
loop:
    slt     R7, R1, R5      # Compare current index R1 with target R5
    beq     R7, R0, end     # If R7 is 0, then R1 >= R5, exit loop
    add     R4, R2, R3      # R4 = R2 + R3 (F(n) = F(n-1) + F(n-2))
    sw      R4, 0(R1)       # Store F(n) at memory address 4 * (R1)

    addi    R3, R2, 0       # Move R2 to R3 (F(n-2) = F(n-1))
    addi    R2, R4, 0       # Move R4 to R2 (F(n-1) = F(n))
    addi    R1, R1, 1       # Increment index n

    j       loop            # Jump back to start of loop

end:
    # Finish, the result is stored in memory pointed by R1
