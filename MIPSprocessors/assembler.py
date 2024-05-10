import re

def to_signed_bin(value, bits):
    """Convert an integer to a signed binary string with the given number of bits."""
    if value < 0:
        value = (1 << bits) + value
    return format(value, f'0{bits}b')

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
            rt = format(int(fields[0][1:]), '05b')
            if instr in ['lw', 'sw']:
                offset, base = fields[1].split('(')
                base = base[:-1]
                rs = format(int(base[1:]), '05b')
                imm = to_signed_bin(int(offset), 16)
            else:
                rs = format(int(fields[1][1:]), '05b')
                imm = to_signed_bin(int(fields[2]), 16)
            return f'{opcode}{rs}{rt}{imm}'
        
        elif instr in ['beq']:
            rs = format(int(fields[0][1:]), '05b')
            rt = format(int(fields[1][1:]), '05b')
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
            rs = format(int(fields[1][1:]), '05b')
            rt = format(int(fields[2][1:]), '05b')
            rd = format(int(fields[0][1:]), '05b')
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
    detailed_output_file = f"{program_name}_detailed.txt"

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
