main:
    addi $1, $0, 0       # Initialize $1 to 0 (Fibonacci(0))
    addi $2, $0, 1       # Initialize $2 to 1 (Fibonacci(1))
    addi $3, $0, 2       # Initialize $3 to 2 (counter starts at 2)
    addi $4, $0, 8       # Initialize $4 to 7 (target Fibonacci index)

loop:
    beq  $3, $4, finish  # If counter ($3) equals 7, exit the loop
    add  $5, $1, $2      # $5 = $1 + $2 (next Fibonacci number)
    add  $1, $0, $2      # $1 = $2 (update $1 for the next iteration)
    add  $2, $0, $5      # $2 = $5 (update $2 for the next iteration)
    addi $3, $3, 1       # Increment counter ($3)
    j    loop            # Repeat the loop

finish:
    sw   $2, 0($0)       # Store the 7th Fibonacci number in memory address 0

end:
    j    end             # Loop forever (end of program)
