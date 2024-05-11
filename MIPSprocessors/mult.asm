main:   
    addi $a0, $zero, 3        # Initialize $a0 (argument) = 5 (Multiplier)
    addi $a1, $zero, 2       # Initialize $a1 (argument) = 10 (Multiplicand)
    addi $t0, $zero, 0        # Initialize $t0 (temporary) = 0, to store the result of multiplication
    addi $t1, $zero, 0        # Initialize $t1 (temporary) = 0, as a counter

    beq  $a0, $zero, end      # If multiplier ($a0) is 0, skip the loop, result is zero
    beq  $a1, $zero, end      # If multiplicand ($a1) is 0, skip the loop, result is zero

multiply: 
    add  $t0, $t0, $a1        # Add multiplicand ($a1) to $t0 (Accumulating result)
    addi $t1, $t1, 1          # Increment counter ($t1) by 1
    slt  $t2, $t1, $a0        # Set $t2 (temporary) to 1 if $t1 (Counter) < $a0 (Multiplier)
    beq  $t2, $zero, end      # If $t2 is 0 (Counter >= Multiplier), exit loop
    j    multiply             # Otherwise, jump back to start of multiply to continue the loop

end:     
    sw   $t0, 0($zero)        # Store the result from $t0 (Result) to memory address 0 (Result Address)
