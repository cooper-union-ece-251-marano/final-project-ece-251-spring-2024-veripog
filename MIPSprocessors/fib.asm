# fib.asm
# Calculate and store the first 10 Fibonacci numbers starting at address 100
#
#       Assembly                   Description                         Address Machine
main:   la   $t1, N               # Load address of N into $t1         0x0000  3C011000
        lw   $t0, 0($t1)          # Load N into $t0                    0x0004  8C290004
        li   $t2, 0               # Initialize $t2 = 0 (F(0))          0x0008  34020000
        li   $t3, 1               # Initialize $t3 = 1 (F(1))          0x000C  34030001
        la   $t4, FIB_START       # Load address of FIB_START          0x0010  3C041000
        lw   $t4, 0($t4)          # Load start address into $t4        0x0014  8C840000
        sw   $t2, 0($t4)          # Store F(0)                         0x0018  AC820000
        addi $t4, $t4, 4          # Increment address for F(1)         0x001C  20840004
        sw   $t3, 0($t4)          # Store F(1)                         0x0020  AC830000
        addi $t4, $t4, 4          # Increment address                  0x0024  20840004
        subi $t0, $t0, 2          # Decrement N by 2                   0x0028  2108FFFE
loop:   beq  $t0, $zero, end      # If N == 0, end loop                0x002C  11000006
        add  $t5, $t2, $t3        # $t5 = $t2 + $t3 (next Fib)         0x0030  014B5020
        sw   $t5, 0($t4)          # Store next Fib                     0x0034  AC850000
        addi $t4, $t4, 4          # Increment address                  0x0038  20840004
        move $t2, $t3             # Update $t2                         0x003C  016A4020
        move $t3, $t5             # Update $t3                         0x0040  01AE4820
        subi $t0, $t0, 1          # Decrement N by 1                   0x0044  2108FFFF
        j    loop                 # Repeat the loop                    0x0048  08000008
end:    j    end                  # End of program (halt)              0x004C  0800000C
