main:
    addi $t0, $zero, 4      # $t0 = 4
    j    end                # jump to end
end:
    sw $t0, 0($zero)        # Store at address 0
    