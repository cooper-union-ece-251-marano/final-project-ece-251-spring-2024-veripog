import os
import re

def extract_modules(file_path):
    with open(file_path, 'r') as file:
        content = file.read()
    
    # Regular expression to find module blocks
    module_pattern = re.compile(r'(module\s+(\w+).*?endmodule)', re.DOTALL)
    modules = module_pattern.findall(content)
    
    return modules

def write_module_to_file(main_directory, module_name, module_content):
    # Create main directory if it doesn't exist
    if not os.path.exists(main_directory):
        os.makedirs(main_directory)

    # Create subdirectory for the module
    module_dir = os.path.join(main_directory, module_name)
    if not os.path.exists(module_dir):
        os.makedirs(module_dir)
    
    # Write module content to a .sv file in the directory
    module_file_path = os.path.join(module_dir, f'{module_name}.sv')
    with open(module_file_path, 'w') as module_file:
        module_file.write(module_content)

def divide_code_into_modules(file_path):
    main_directory = 'catalog'
    modules = extract_modules(file_path)
    
    for module_content, module_name in modules:
        write_module_to_file(main_directory, module_name, module_content)

if __name__ == '__main__':
    input_file = 'computer.sv'  # Replace with your input file path
    divide_code_into_modules(input_file)
