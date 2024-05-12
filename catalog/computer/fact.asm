main:
    addi $t0, $zero, 1          # $t0 = 1 (loop counter)
    addi $t1, $zero, 1          # $t1 = 1 (factorial result)
    addi $t2, $zero, 4          # $t2 = 4 (target number, set n = 4)

Loop:
    add $t3, $zero, $zero       # $t3 = 0 (temporary storage for result of multiplication)
    add $t4, $t0, $zero         # $t4 = $t0 (loop counter for repeated addition)

MultiplyLoop:
    beq $t4, $zero, MultiplyEnd # If $t4 == 0, end multiplication
    add $t3, $t3, $t1           # $t3 = $t3 + $t1 (accumulate the result)
    addi $t4, $t4, -1           # $t4 = $t4 - 1
    j MultiplyLoop              # Repeat the multiplication loop

MultiplyEnd:
    add $t1, $t3, $zero         # $t1 = $t3 (store the result back in $t1)
    addi $t0, $t0, 1
    addi $t3, $t2, 1            # $t3 = $t2 + 1
    slt  $t3, $t0, $t3          # $t3 = ($t0 < $t3) ? 1 : 0
    beq  $t3, $zero, End        # if $t3 == 0 (i.e., $t0 >= $t2 + 1), end the loop
    j    Loop                   # else, continue the loop

End:
    sw   $t1, 0($zero)          # Store the result in memory (if needed)
