main:
    addi $t0, $zero, 0       # $t0 = 0 (Fibonacci(0))
    addi $t1, $zero, 1       # $t1 = 1 (Fibonacci(1))
    addi $a0, $zero, 2       # $a0 = 2 (starting counter)
    addi $a1, $t1, 8         # $a1 = 1 + 8 (target index)

loop:
    beq  $a0, $a1, finish    # If counter ($a0) equals 8, exit loop
    add  $t2, $t0, $t1       # $t2 = $t0 + $t1 (next Fibonacci number)
    add  $t0, $zero, $t1     # $t0 = $t1 (update $t0)
    add  $t1, $zero, $t2     # $t1 = $t2 (update $t1)
    addi $a0, $a0, 1         # Increment counter ($a0)
    j    loop                # Repeat loop

finish:
    sw   $t1, 0($zero)       # Store 8th Fibonacci number in memory

end:
    j    end                 # Loop forever (end of program)
