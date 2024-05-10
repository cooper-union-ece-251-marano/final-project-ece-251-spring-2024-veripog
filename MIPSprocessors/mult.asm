main:   addi $2, $0, 5         # initialize $2 = 5 (Multiplier)
        addi $3, $0, 10        # initialize $3 = 12 (Multiplicand)
        addi $5, $0, 0         # initialize $5 = 0, to store the result of multiplication
        addi $6, $0, 0         # initialize $6 = 0, as a counter

        beq  $2, $0, end       # if multiplier ($2) is 0, skip the loop, result is zero
        beq  $3, $0, end       # if multiplicand ($3) is 0, skip the loop, result is zero

multiply: add  $5, $5, $3       # add multiplicand ($3) to $5 (Accumulating result)
          addi $6, $6, 1       # increment counter ($6) by 1
          slt  $7, $6, $2      # set $7 to 1 if $6 (Counter) < $2 (Multiplier)
          beq  $7, $0, end     # if $7 is 0 (Counter >= Multiplier), exit loop
          j    multiply        # otherwise, jump back to start of multiply to continue the loop

end:     sw   $5, 0($0)        # store the result from $5 (Result) to memory address 0 (Result Address)
