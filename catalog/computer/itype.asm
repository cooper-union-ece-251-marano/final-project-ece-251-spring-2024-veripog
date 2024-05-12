main:
    addi $t0, $zero, 4      # $t0 = 4
    sw $t0, 1($zero)        # Store at address 1
    lw $t1, 1($zero)        # Load data
    sw $t1, 0($zero)        # Store at address 0