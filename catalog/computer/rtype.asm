main:
    addi $t0, $zero, 4      # $t0 = 4
    addi $t1, $zero, 3      # $t1 = 3
    add $t2, $t0, $t1       # $t3 = 4 + 3 = 7
    sw $t2, 0($zero)        # Store at address 0