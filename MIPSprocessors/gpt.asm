.data
result: .word 0          # Reserve a word in memory for the result

.text
main:
    li $t0, 5            # Load immediate 5 into register $t0
    li $t1, 10           # Load immediate 10 into register $t1
    add $t2, $t0, $t1    # Add values in $t0 and $t1, store the result in $t2
    la $t3, result       # Load address of result into $t3
    sw $t2, 0($t3)       # Store the value in $t2 into the memory address pointed by $t3
