# Veripog

ECE-251: Spring 2024

## Instruction Set for Single-Cycle MIPS Processor

### R-Type Instructions

| Name | Mnemonic | Operation                       | Opcode / Funct  | Opcode / Funct (Binary)     |
|------|----------|---------------------------------|-----------------|-----------------------------|
| ADD  | `add`    | R[rd] = R[rs] + R[rt]           | \(0 / 20_{hex}\)| 000000 / 100000             |
| SUB  | `sub`    | R[rd] = R[rs] - R[rt]           | \(0 / 22_{hex}\)| 000000 / 100010             |
| AND  | `and`    | R[rd] = R[rs] & R[rt]           | \(0 / 24_{hex}\)| 000000 / 100100             |
| OR   | `or`     | R[rd] = R[rs] \| R[rt]          | \(0 / 25_{hex}\)| 000000 / 100101             |
| NOR  | `nor`    | R[rd] = ~(R[rs] \| R[rt])       | \(0 / 27_{hex}\)| 000000 / 100111             |
| SLT  | `slt`    | R[rd] = (R[rs] < R[rt]) ? 1 : 0 | \(0 / 2A_{hex}\)| 000000 / 101010             |

### I-Type Instructions

| Name   | Mnemonic | Operation                                      | Opcode       | Opcode (Binary)  |
|--------|----------|------------------------------------------------|--------------|------------------|
| LW     | `lw`     | R[rt] = M[R[rs]+SignExtImm]                    | \(23_{hex}\) | 100011           |
| SW     | `sw`     | M[R[rs]+SignExtImm] = R[rt]                    | \(2B_{hex}\) | 101011           |
| BEQ    | `beq`    | if(R[rs]==R[rt]) <br>&nbsp; PC=PC+4+BranchAddr | \(14_{hex}\) | 000100           |
| ADDI   | `addi`   | R[rt] = R[rs] + SignExtImm                     | \(08_{hex}\) | 001000           |

### J-Type Instructions

| Name | Mnemonic | Operation      | Opcode       | Opcode (Binary)  |
|------|----------|----------------|--------------|------------------|
| J    | `j`      | PC = JumpAddr  | \(02_{hex}\) | 000010           |

### Instruction Formats

![Alt Text](images/instruction_format.png)

## Control Signal Mapping for MIPS Instructions

| **Instruction** | `RegWrite` | `RegDst` | `ALUSrc` | `Branch` | `MemWrite` | `MemtoReg` | `Jump` | `ALUOp` | `ALUControl` |
|-----------------|------------|----------|----------|----------|------------|------------|--------|---------|--------------|
| `LW`            | 1          | 0        | 1        | 0        | 0          | 1          | 0      | 00      | 010 (add)    |
| `SW`            | 0          | X        | 1        | 0        | 1          | X          | 0      | 00      | 010 (add)    |
| `BEQ`           | 0          | X        | 0        | 1        | 0          | X          | 0      | 01      | 110 (sub)    |
| `ADDI`          | 1          | 0        | 1        | 0        | 0          | 0          | 0      | 00      | 010 (add)    |
 
### R-type Instructions

| **R-type Instruction** | `RegWrite` | `RegDst` | `ALUSrc` | `Branch` | `MemWrite` | `MemtoReg` | `Jump` | `ALUOp` | `ALUControl` |
|------------------------|------------|----------|----------|----------|------------|------------|--------|---------|--------------|
| `ADD`                  | 1          | 1        | 0        | 0        | 0          | 0          | 0      | 10      | 010 (add)    |
| `SUB`                  | 1          | 1        | 0        | 0        | 0          | 0          | 0      | 10      | 110 (sub)    |
| `AND`                  | 1          | 1        | 0        | 0        | 0          | 0          | 0      | 10      | 000 (and)    |
| `OR`                   | 1          | 1        | 0        | 0        | 0          | 0          | 0      | 10      | 001 (or)     |
| `NOR`                  | 1          | 1        | 0        | 0        | 0          | 0          | 0      | 10      | 011 (nor)    |
| `SLT`                  | 1          | 1        | 0        | 0        | 0          | 0          | 0      | 10      | 111 (slt)    |

### Jump Instruction

| **Jump Instruction** | `RegWrite` | `RegDst` | `ALUSrc` | `Branch` | `MemWrite` | `MemtoReg` | `Jump` | `ALUOp` | `ALUControl` |
|----------------------|------------|----------|----------|----------|------------|------------|--------|---------|--------------|
| `J`                  | 0          | X        | X        | 0        | 0          | X          | 1      | XX      | XXX (no ALU operation) |

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
