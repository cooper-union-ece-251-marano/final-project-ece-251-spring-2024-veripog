import re

# Register mapping
registers = {
    'zero': 0, '0': 0,
    'at': 1, '1': 1,
    'v0': 2, '2': 2, 'v1': 3, '3': 3,
    'a0': 4, '4': 4, 'a1': 5, '5': 5, 'a2': 6, '6': 6, 'a3': 7, '7': 7,
    't0': 8, '8': 8, 't1': 9, '9': 9, 't2': 10, '10': 10, 't3': 11, '11': 11,
    't4': 12, '12': 12, 't5': 13, '13': 13, 't6': 14, '14': 14, 't7': 15, '15': 15,
    's0': 16, '16': 16, 's1': 17, '17': 17, 's2': 18, '18': 18, 's3': 19, '19': 19,
    's4': 20, '20': 20, 's5': 21, '21': 21, 's6': 22, '22': 22, 's7': 23, '23': 23,
    't8': 24, '24': 24, 't9': 25, '25': 25,
    'k0': 26, '26': 26, 'k1': 27, '27': 27,
    'gp': 28, '28': 28,
    'sp': 29, '29': 29,
    'fp': 30, '30': 30,
    'ra': 31, '31': 31
}

def to_signed_bin(value, bits):
    """Convert an integer to a signed binary string with the given number of bits."""
    if value < 0:
        value = (1 << bits) + value
    return format(value, f'0{bits}b')

def get_register_bin(reg):
    """Get the binary representation of a register."""
    if reg.startswith('$'):
        reg = reg[1:]
    return format(registers[reg], '05b')

def assemble_instruction(instruction, label_addresses, current_address):
    # Dictionary for opcode, function and register binary mappings
    opcodes = {
        'addi': '001000', 'lw': '100011', 'sw': '101011', 'beq': '000100', 'j': '000010',
        'add': '000000', 'sub': '000000', 'and': '000000', 'or': '000000', 'nor': '000000',
        'slt': '000000'
    }
    
    funct_codes = {
        'add': '100000', 'sub': '100010', 'and': '100100', 'or': '100101', 'slt': '101010', 'nor': '100111'
    }
    
    # Split the instruction into its components
    parts = instruction.replace(',', '').split()
    instr = parts[0]
    fields = parts[1:]

    if instr in opcodes:
        opcode = opcodes[instr]

        if instr in ['addi', 'lw', 'sw']:
            rt = get_register_bin(fields[0])
            if instr in ['lw', 'sw']:
                offset, base = fields[1].split('(')
                base = base[:-1]
                rs = get_register_bin(base)
                imm = to_signed_bin(int(offset), 16)
            else:
                rs = get_register_bin(fields[1])
                imm = to_signed_bin(int(fields[2]), 16)
            return f'{opcode}{rs}{rt}{imm}'
        
        elif instr in ['beq']:
            rs = get_register_bin(fields[0])
            rt = get_register_bin(fields[1])
            if fields[2] in label_addresses:
                target_address = label_addresses[fields[2]]
                offset = (target_address - (current_address + 4)) // 4
                imm = to_signed_bin(offset, 16)
            else:
                imm = to_signed_bin(int(fields[2]), 16)
            return f'{opcode}{rs}{rt}{imm}'
        
        elif instr in ['j']:
            if fields[0] in label_addresses:
                target_address = label_addresses[fields[0]] // 4
                address = format(target_address, '026b')
            else:
                address = format(int(fields[0]), '026b')
            return f'{opcode}{address}'
        
        elif instr in ['add', 'sub', 'and', 'or', 'slt', 'nor']:
            rs = get_register_bin(fields[1])
            rt = get_register_bin(fields[2])
            rd = get_register_bin(fields[0])
            shamt = '00000'
            funct = funct_codes[instr]
            return f'{opcode}{rs}{rt}{rd}{shamt}{funct}'

    return None

def assemble_mips(assembly_code):
    # First pass to identify label addresses
    label_addresses = {}
    instructions = []
    address = 0

    lines = assembly_code.strip().split('\n')
    for line in lines:
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        label_match = re.match(r'(\w+):', line)
        if label_match:
            label = label_match.group(1)
            label_addresses[label] = address
            line = line[label_match.end():].strip()
        if line:
            instructions.append((address, line))
            address += 4

    # Second pass to assemble instructions
    machine_code = []
    detailed_output = []
    for address, instr in instructions:
        binary_instr = assemble_instruction(instr, label_addresses, address)
        if binary_instr:
            machine_code.append(binary_instr)
            detailed_output.append((address, instr, binary_instr))

    return machine_code, detailed_output

def main():
    program_name = input("Enter the program name: ")
    input_file = f"{program_name}.asm"
    output_file = f"{program_name}.dat"
    detailed_output_file = f"{program_name}.txt"

    try:
        with open(input_file, 'r') as file:
            assembly_code = file.read()
        
        machine_code, detailed_output = assemble_mips(assembly_code)
        
        # Write machine code to output file
        with open(output_file, 'w') as file:
            for code in machine_code:
                file.write(f"{int(code, 2):08x}\n")

        # Write detailed output to detailed output file
        with open(detailed_output_file, 'w') as file:
            for address, instr, code in detailed_output:
                file.write(f"{address:08x}: {instr} -> {int(code, 2):08x}\n")
        
        print(f"Machine code successfully written to {output_file}")
        print(f"Detailed output successfully written to {detailed_output_file}")

    except FileNotFoundError:
        print(f"Error: File {input_file} not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    main()
