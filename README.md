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
