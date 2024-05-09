# Veripog

ECE-251: Spring 2024

## Instruction Set for Single-Cycle MIPS Processor

### R-Type Instructions

| Name | Mnemonic | Operation                       | Opcode / Funct  |
|------|----------|---------------------------------|-----------------|
| ADD  | `add`    | R[rd] = R[rs] + R[rt]           | \(0 / 20_{hex}\)|
| SUB  | `sub`    | R[rd] = R[rs] - R[rt]           | \(0 / 22_{hex}\)|
| AND  | `and`    | R[rd] = R[rs] & R[rt]           | \(0 / 24_{hex}\)|
| OR   | `or`     | R[rd] = R[rs] \| R[rt]          | \(0 / 25_{hex}\)|
| SLT  | `slt`    | R[rd] = (R[rs] < R[rt]) ? 1 : 0 | \(0 / 2A_{hex}\)|
| NOR  | `nor`    | R[rd] = ~(R[rs] \| R[rt])       | \(0 / 27_{hex}\)|

### I-Type Instructions

| Name   | Mnemonic | Operation                            | Opcode |
|--------|----------|--------------------------------------|--------|
| LW     | `lw`     | R[rt] = M[R[rs]+SignExtImm]          | 23     |
| SW     | `sw`     | M[R[rs]+SignExtImm] = R[rt]          | 2B     |
| BEQ    | `beq`    | if(R[rs]==R[rt]) <br>&nbsp; PC=PC+4+BranchAddr | 14     |
| ADDI   | `addi`   | R[rt] = R[rs] + SignExtImm           | 08     |

### J-Type Instructions

| Name | Mnemonic | Operation      | Opcode |
|------|----------|----------------|--------|
| J    | `j`      | PC = JumpAddr  | 02     |

### Instruction Formats

![Alt Text](images/instruction_format.png)
