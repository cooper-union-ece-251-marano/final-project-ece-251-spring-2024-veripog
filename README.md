# Veripog

## ECE-251: Spring 2024

### Instruction Set for Single-Cycle MIPS Processor

#### R-Type Instructions

| Instruction | Function | Opcode  | Funct  | Description                |
|-------------|----------|---------|--------|----------------------------|
| `add`       | ADD      | 000000  | 100000 | rd = rs + rt               |
| `sub`       | SUB      | 000000  | 100010 | rd = rs - rt               |
| `and`       | AND      | 000000  | 100100 | rd = rs & rt               |
| `or`        | OR       | 000000  | 100101 | rd = rs \| rt              |
| `slt`       | SLT      | 000000  | 101010 | rd = (rs < rt) ? 1 : 0     |

#### I-Type Instructions

| Instruction | Opcode  | Description                    |
|-------------|---------|--------------------------------|
| `lw`        | 100011  | rt = Memory[rs + immediate]    |
| `sw`        | 101011  | Memory[rs + immediate] = rt    |
| `beq`       | 000100  | if (rs == rt) branch           |
| `addi`      | 001000  | rt = rs + immediate            |

#### J-Type Instructions

| Instruction | Opcode  | Description                    |
|-------------|---------|--------------------------------|
| `j`         | 000010  | Jump to address                |

![Alt Text](images/instruction_format.png)