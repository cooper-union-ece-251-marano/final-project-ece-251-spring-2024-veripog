.data
result: .word 0              # Memory location to store the result

.text
main:   addi $2, $0, 4       # Initialize $2 = 4 (The number to compute factorial of)
        addi $3, $0, 1       # Initialize $3 = 1 (To store the intermediate factorial result)
        addi $4, $0, 1       # Initialize $4 = 1 (Counter starting from 1)

factorial_loop:
        slt  $5, $2, $4      # Set $5 to 1 if $4 (Counter) > $2 (Number)
        beq  $5, $0, multiply # If $5 is 0 (Counter <= Number), proceed to multiply
        j    end             # Otherwise, end the loop

multiply:
        add  $3, $3, $3      # Double the current factorial result (incorrect approach, should multiply)
        add  $4, $4, $4      # Increment the counter (incorrect approach, should increment by 1)
        j    factorial_loop  # Repeat the loop

end:
        sw   $3, result($0)  # Store the final factorial result in memory

# Corrected multiply section:
factorial_loop_corrected:
        slt  $5, $2, $4      # Set $5 to 1 if $4 (Counter) > $2 (Number)
        beq  $5, $0, multiply_corrected # If $5 is 0 (Counter <= Number), proceed to multiply
        j    end_corrected   # Otherwise, end the loop

multiply_corrected:
        mul  $3, $3, $4      # Multiply the current factorial result by the counter
        addi $4, $4, 1       # Increment the counter by 1
        j    factorial_loop_corrected  # Repeat the loop

end_corrected:
        sw   $3, result($0)  # Store the final factorial result in memory
