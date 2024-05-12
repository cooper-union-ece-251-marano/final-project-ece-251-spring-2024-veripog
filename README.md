# Veripog

ECE-251: Spring 2024

[![ECE251: Computer Architecture - Final Project](http://img.youtube.com/vi/p2kRs5L_7Zk/0.jpg)](https://www.youtube.com/watch?v=p2kRs5L_7Zk "ECE251: Computer Architecture - Final Project")

<https://youtu.be/p2kRs5L_7Zk>

## Instruction Set

| ISA Aspect                 | Implementation                                   |
|----------------------------|--------------------------------------------------|
| ALU Operand Size           | 32 bits                                          |
| Address Bus Size           | 32 bits                                          |
| Addressability             | Byte addressable                                 |
| Register File Size         | 32 registers, each 32 bits wide                  |
| Opcode Size                | 6 bits                                           |
| Function Size              | 6 bits                                           |
| shamt Size                 | 5 bits                                           |
| Instruction Length         | 32 bits                                          |
| PC Increment               | 4 bytes                                          |
| Immediate Size             | 16 bits                                          |
| R-type Instruction Support | `ADD`, `SUB`, `AND`, `OR`, `SLT`, `NOR`          |
| I-type Instruction Support | `LW`, `SW`, `BEQ`, `ADDI`                        |
| J-type Instruction Support | `J`                                              |
| Memory Reference Support   | Yes                                              |
| Total Memory Size          | 64 words (256 bytes)                             |

### Datapath Diagram

![Alt Text](images/DatapathDiagram.jpeg)

### Instruction Formats

![Alt Text](images/instr_format.png)

### R-Type Instructions

| Name | Mnemonic | Operation                       | Opcode / Funct  | Opcode / Funct (Binary)     |
|------|----------|---------------------------------|-----------------|-----------------------------|
| ADD  | `add`    | R[rd] = R[rs] + R[rt]           | $0 / 20_{hex}$  | 000000 / 100000             |
| SUB  | `sub`    | R[rd] = R[rs] - R[rt]           | $0 / 22_{hex}$  | 000000 / 100010             |
| AND  | `and`    | R[rd] = R[rs] & R[rt]           | $0 / 24_{hex}$  | 000000 / 100100             |
| OR   | `or`     | R[rd] = R[rs] \| R[rt]          | $0 / 25_{hex}$  | 000000 / 100101             |
| NOR  | `nor`    | R[rd] = ~(R[rs] \| R[rt])       | $0 / 27_{hex}$  | 000000 / 100111             |
| SLT  | `slt`    | R[rd] = (R[rs] < R[rt]) ? 1 : 0 | $0 / 2A_{hex}$  | 000000 / 101010             |

![Alt Text](images/instr_rtype.png)

### I-Type Instructions

| Name   | Mnemonic | Operation                                      | Opcode       | Opcode (Binary)  |
|--------|----------|------------------------------------------------|--------------|------------------|
| LW     | `lw`     | R[rt] = M[R[rs]+SignExtImm]                    | $23_{hex}$   | 100011           |
| SW     | `sw`     | M[R[rs]+SignExtImm] = R[rt]                    | $2B_{hex}$   | 101011           |
| BEQ    | `beq`    | if(R[rs]==R[rt]) <br>&nbsp; PC=PC+4+BranchAddr | $14_{hex}$   | 000100           |
| ADDI   | `addi`   | R[rt] = R[rs] + SignExtImm                     | $08_{hex}$   | 001000           |

![Alt Text](images/instr_itype.png)

### J-Type Instructions

| Name | Mnemonic | Operation      | Opcode       | Opcode (Binary)  |
|------|----------|----------------|--------------|------------------|
| J    | `j`      | PC = JumpAddr  | $02_{hex}$   | 000010           |

![Alt Text](images/instr_jtype.png)

## Control Signal Mapping for MIPS Instructions

### I-type Instructions

| **Instruction** | `RegWrite` | `RegDst` | `ALUSrc` | `Branch` | `MemWrite` | `MemtoReg` | `Jump` | `ALUOp` |
|-----------------|------------|----------|----------|----------|------------|------------|--------|---------|
| `LW`            | 1          | 0        | 1        | 0        | 0          | 1          | 0      | 00      |
| `SW`            | 0          | X        | 1        | 0        | 1          | X          | 0      | 00      |
| `BEQ`           | 0          | X        | 0        | 1        | 0          | X          | 0      | 01      |
| `ADDI`          | 1          | 0        | 1        | 0        | 0          | 0          | 0      | 00      |

### R-type Instructions

| **Instruction** | `RegWrite` | `RegDst` | `ALUSrc` | `Branch` | `MemWrite` | `MemtoReg` | `Jump` | `ALUOp` |
|------------------------|------------|----------|----------|----------|------------|------------|--------|---------|
| `ADD`                  | 1          | 1        | 0        | 0        | 0          | 0          | 0      | 10      |
| `SUB`                  | 1          | 1        | 0        | 0        | 0          | 0          | 0      | 10      |
| `AND`                  | 1          | 1        | 0        | 0        | 0          | 0          | 0      | 10      |
| `OR`                   | 1          | 1        | 0        | 0        | 0          | 0          | 0      | 10      |
| `NOR`                  | 1          | 1        | 0        | 0        | 0          | 0          | 0      | 10      |
| `SLT`                  | 1          | 1        | 0        | 0        | 0          | 0          | 0      | 10      |

### Jump Instruction

| **Instruction** | `RegWrite` | `RegDst` | `ALUSrc` | `Branch` | `MemWrite` | `MemtoReg` | `Jump` | `ALUOp` |
|----------------------|------------|----------|----------|----------|------------|------------|--------|---------|
| `J`                  | 0          | X        | X        | 0        | 0          | X          | 1      | XX      |

### Explanation of Columns

- **Instruction**: MIPS assembly instruction.
- **RegWrite**: Enables writing to the register file.
- **RegDst**: Determines the destination register (1 for `rd` field, 0 for `rt` field).
- **ALUSrc**: Selects the second ALU operand (0 for register, 1 for immediate value).
- **Branch**: Determines if the instruction is a branch instruction (e.g., `BEQ`).
- **MemWrite**: Enables writing to data memory.
- **MemtoReg**: Selects the value to write back to the register (1 for data memory output, 0 for ALU result).
- **Jump**: Indicates a jump instruction.
- **ALUOp**: Specifies the type of ALU operation (00 for `LW`/`SW`, 01 for `BEQ`, 10 for R-type, and others for specific operations like `ADDI`).
- **ALUControl**: The specific ALU operation code (e.g., 010 for add, 110 for sub), often determined by the combination of `ALUOp` and the funct field for R-type instructions.

## Timing Diagrams

### R-type Timing Diagram

![Alt Text](images/timing_rtype.png)

```t
00000000: 20080004 <- addi $t0, $zero, 4      # $t0 = 4
00000004: 20090003 <- addi $t1, $zero, 3      # $t1 = 3
00000008: 01095020 <- add $t2, $t0, $t1       # $t3 = 4 + 3 = 7
0000000c: ac0a0000 <- sw $t2, 0($zero)        # Store at address 0
```

### I-type Timing Diagram

![Alt Text](images/timing_itype.png)

```t
00000000: 20080004 <- addi $t0, $zero, 4      # $t0 = 4
00000004: ac080001 <- sw $t0, 1($zero)        # Store at address 1
00000008: 8c090001 <- lw $t1, 1($zero)        # Load data
0000000c: ac090000 <- sw $t1, 0($zero)        # Store at address 0
```

### J-type Timing Diagram

![Alt Text](images/timing_jtype.png)

```t
00000000: 20080004 <- addi $t0, $zero, 4      # $t0 = 4
00000004: 08000002 <- j    end                # jump to end
00000008: ac080000 <- sw $t0, 0($zero)        # Store at address 0
```

## Registers

| NAME      | NUMBER   | USE                                                   | PRESERVED ACROSS A CALL? |
|-----------|----------|-------------------------------------------------------|--------------------------|
| $zero     | 0        | The Constant Value 0                                  | N.A.                     |
| $at       | 1        | Assembler Temporary                                   | No                       |
| \$v0-$v1  | 2-3      | Values for Function Results and Expression Evaluation | No                       |
| \$a0-$a4  | 4-8      | Arguments                                             | No                       |
| \$t0-$t9  | 9-18     | Temporaries                                           | No                       |
| \$s0-$s8  | 19-27    | Saved Temporaries                                     | Yes                      |
| $gp       | 28       | Global Pointer                                        | Yes                      |
| $sp       | 29       | Stack Pointer                                         | Yes                      |
| $fp       | 30       | Frame Pointer                                         | Yes                      |
| $ra       | 31       | Return Address                                        | No                       |

## Usage Guide

This guide demonstrates how to write a program for your ISA, load it, run it, and view the output.

### Writing a Program

1. Create a file with a `.asm` extension.
2. Write your assembly code in this file.

### Loading the Program

1. Run the assembler by executing the following command:

   ```sh
   python assembler.py
   ```

2. When prompted, enter the name of your program (excluding the `.asm` extension). For example, if your program is named `fib.asm`, enter `fib`.

3. Open the `tb_computer.sv` file.
4. Locate the line:

   ```systemverilog
   $readmemh("fib.dat", dut.imem.RAM, 0, 63);
   ```

   Replace `fib` with the name of your program.

### Running the Program

1. On a Linux system, run the following command:

   ```sh
   make clean compile simulate
   ```

   The output will be displayed in both hexadecimal and decimal formats.

2. To analyze the timing diagram, run:

   ```sh
   make display
   ```

## Fibonnaci Program

### fib.asm

```t
main:
    addi $at, $zero, 0       # Initialize $at (assembler temporary) to 0 (Fibonacci(0))
    addi $v0, $zero, 1       # Initialize $v0 (value for function result) to 1 (Fibonacci(1))
    addi $a0, $zero, 2       # Initialize $a0 (argument) to 2 (counter starts at 2)
    addi $a1, $zero, 8       # Initialize $a1 (argument) to 8 (target Fibonacci index)

loop:
    beq  $a0, $a1, finish    # If counter ($a0) equals 8, exit the loop
    add  $v1, $at, $v0       # $v1 (value for function result) = $at + $v0 (next Fibonacci number)
    add  $at, $zero, $v0     # $at = $v0 (update $at for the next iteration)
    add  $v0, $zero, $v1     # $v0 = $v1 (update $v0 for the next iteration)
    addi $a0, $a0, 1         # Increment counter ($a0)
    j    loop                # Repeat the loop

finish:
    sw   $v0, 0($zero)       # Store the 8th Fibonacci number in memory address 0

end:
    j    end                 # Loop forever (end of program)
```

### fib.txt

```t
00000000: 20010000 <- addi $at, $zero, 0       # Initialize $at (assembler temporary) to 0 (Fibonacci(0))
00000004: 20020001 <- addi $v0, $zero, 1       # Initialize $v0 (value for function result) to 1 (Fibonacci(1))
00000008: 20040002 <- addi $a0, $zero, 2       # Initialize $a0 (argument) to 2 (counter starts at 2)
0000000c: 20050008 <- addi $a1, $zero, 8       # Initialize $a1 (argument) to 8 (target Fibonacci index)
00000010: 10850005 <- beq  $a0, $a1, finish    # If counter ($a0) equals 8, exit the loop
00000014: 00221820 <- add  $v1, $at, $v0       # $v1 (value for function result) = $at + $v0 (next Fibonacci number)
00000018: 00020820 <- add  $at, $zero, $v0     # $at = $v0 (update $at for the next iteration)
0000001c: 00031020 <- add  $v0, $zero, $v1     # $v0 = $v1 (update $v0 for the next iteration)
00000020: 20840001 <- addi $a0, $a0, 1         # Increment counter ($a0)
00000024: 08000004 <- j    loop                # Repeat the loop
00000028: ac020000 <- sw   $v0, 0($zero)       # Store the 8th Fibonacci number in memory address 0
0000002c: 0800000b <- j    end                 # Loop forever (end of program)
```

### fib.dat

```t
20010000
20020001
20040002
20050008
10850005
00221820
00020820
00031020
20840001
08000004
ac020000
0800000b
```

## Factorial Program

### fact.asm

```t
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
```

### fact.txt

```t
00000000: 20080001 <- addi $t0, $zero, 1          # $t0 = 1 (loop counter)
00000004: 20090001 <- addi $t1, $zero, 1          # $t1 = 1 (factorial result)
00000008: 200a0004 <- addi $t2, $zero, 4          # $t2 = 4 (target number, set n = 4)
0000000c: 00005820 <- add $t3, $zero, $zero       # $t3 = 0 (temporary storage for result of multiplication)
00000010: 01006020 <- add $t4, $t0, $zero         # $t4 = $t0 (loop counter for repeated addition)
00000014: 11800003 <- beq $t4, $zero, MultiplyEnd # If $t4 == 0, end multiplication
00000018: 01695820 <- add $t3, $t3, $t1           # $t3 = $t3 + $t1 (accumulate the result)
0000001c: 218cffff <- addi $t4, $t4, -1           # $t4 = $t4 - 1
00000020: 08000005 <- j MultiplyLoop              # Repeat the multiplication loop
00000024: 01604820 <- add $t1, $t3, $zero         # $t1 = $t3 (store the result back in $t1)
00000028: 21080001 <- addi $t0, $t0, 1
0000002c: 214b0001 <- addi $t3, $t2, 1            # $t3 = $t2 + 1
00000030: 010b582a <- slt  $t3, $t0, $t3          # $t3 = ($t0 < $t3) ? 1 : 0
00000034: 11600001 <- beq  $t3, $zero, End        # if $t3 == 0 (i.e., $t0 >= $t2 + 1), end the loop
00000038: 08000003 <- j    Loop                   # else, continue the loop
0000003c: ac090000 <- sw   $t1, 0($zero)          # Store the result in memory (if needed)
```

### fact.dat

```t
20080001
20090001
200a0004
00005820
01006020
11800003
01695820
218cffff
08000005
01604820
21080001
214b0001
010b582a
11600001
08000003
ac090000
```
