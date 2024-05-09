# mipstest.asm
# FPGA and Verilog Expert - 9 May 2024
#
# Test the MIPS processor.  
#  add, sub, and, or, slt, addi, lw, sw, beq, j
# If successful, it should write the value 88 to address 48

#        Assembly                  Description           Address Machine
main:   addi $t0, $zero, 10       # $t0 = 10             0000  200A000A
        addi $t1, $zero, 5        # $t1 = 5              0004  20090005
        addi $t2, $zero, -5       # $t2 = -5             0008  200AFFFB
        addi $t3, $zero, 255      # $t3 = 255            000C  200B00FF

        add  $t4, $t0, $t1        # $t4 = $t0 + $t1      0010  01095020
        sub  $t5, $t0, $t1        # $t5 = $t0 - $t1      0014  01095822
        and  $t6, $t0, $t3        # $t6 = $t0 & $t3      0018  010B6024
        or   $t7, $t0, $t2        # $t7 = $t0 | $t2      001C  010A7025
        slt  $t8, $t1, $t0        # $t8 = ($t1 < $t0)    0020  012A802A
        nor  $t9, $t0, $t1        # $t9 = ~($t0 | $t1)   0024  01095827

        lw   $s0, 0($t0)          # $s0 = Mem[$t0]       0028  8D100000
        sw   $t1, 4($t0)          # Mem[$t0+4] = $t1     002C  AD090004
        beq  $t0, $t1, label1     # if($t0==$t1) jump    0030  11090003
        addi $t2, $t1, 5          # $t2 = $t1 + 5        0034  212A0005

        beq  $t0, $t0, label2     # if($t0==$t0) jump    0038  110A0002
        addi $t2, $zero, 99       # skipped instruction  003C  200A0063

label1: addi $t2, $zero, 88       # executed instruction 0040  200A0058

label2: nop                       # No operation         0044  00000000

        j    final                # jump to final label  0048  08000013
        addi $t2, $zero, 1        # skipped instruction  004C  200A0001

final:  nop                       # No operation         0050  00000000

end:    sw   $t2, 48($zero)       # write $t2 to addr 48 0054  AC0A0030
