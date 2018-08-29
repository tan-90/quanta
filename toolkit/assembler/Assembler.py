## @file
## @brief quanta assembler.

import argparse
import sys

from Parser import parse
from Util import to_fixed_length_bin, format_error, format_column_marker
from MIF import *

## @brief Holds information about an instruction
## @details Used for defining instruction information for the assembler
class Instruction:
    def __init__(self, name, type, opcode, alias, description):
        ## @brief Human frindly name of the instruction
        self.name = name
        ## @brief The instruction type for the lexer.
        self.type = type
        ## @brief The instruction OPCODE for the Assembler.
        self.opcode = opcode

        ## @brief The instruction alias for the lexer.
        self.alias = alias
        ## @brief Human friendly instruction descrption for verbose assembling.
        self.description = description

## @brief The quanta instruction set.
instructions = [
    
    Instruction('NOOP', 'NOOP', 0x00, 'noop', ''),

    Instruction('Load Immediate', 'IMMEDIATE', 0x01, 'li', ''),
    
    Instruction('Not', 'SINGLE_REG', 0x0b, 'not', ''),
    Instruction('Shift Left', 'SINGLE_REG', 0x0c, 'sl', ''),
    Instruction('Arithmetic Shift Right', 'SINGLE_REG', 0x0f, 'asr', ''),
    Instruction('Shift Right', 'SINGLE_REG', 0x0d, 'sr', ''),
    Instruction('Rotate Left', 'SINGLE_REG', 0x10, 'rl', ''),

    Instruction('Move', 'DOUBLE_REG', 0x02, 'move', ''),
    Instruction('Add', 'DOUBLE_REG', 0x05, 'add', ''),
    Instruction('Subtract', 'DOUBLE_REG', 0x06, 'sub', ''),
    Instruction('AND', 'DOUBLE_REG', 0x07, 'and', ''),
    Instruction('OR', 'DOUBLE_REG', 0x08, 'or', ''),
    Instruction('XOR', 'DOUBLE_REG', 0x09, 'xor', ''),
    Instruction('XNOR', 'DOUBLE_REG', 0x0a, 'xnor', ''),

    Instruction('Jump', 'JUMP', 0x12, 'j', ''),

    Instruction('Jump Equals', 'BRANCH', 0x13, 'je', ''),
    Instruction('Jump Not Equals', 'BRANCH', 0x14, 'jne', ''),
    Instruction('Jump Lesser', 'BRANCH', 0x15, 'jl', ''),
    Instruction('Jump Greater', 'BRANCH', 0x16, 'jg', ''),

    Instruction('Call', 'CALL', 0x17, 'call', ''),

    Instruction('Load', 'MEMORY', 0x03, 'load', ''),
    Instruction('Store', 'MEMORY', 0x04, 'store', '')
]
## @brief Maps aliases to instruction classes.
## @details Avoids searchs in the instruction set.
instruction_aliases = {i.alias: i for i in instructions }

## @brief Sintax sugar. Maps register names to their value.
## @details Register aliases won't collide with labels.
register_aliases = {
    'zero': 0,
    'leds': 16,
    'hex0': 17,
    'hex1': 18,
    'hex2': 19,
    'switches': 20,
    'ra': 30,
    'a': 31
}

## @brief Checks if an instruction is using a label as argument.
## @details Label instructions translate to more then one instruction.
## @details Querying the type is needed when counting instructions.
## @param line The entire parsed line.
## @return Wether or not the instruction uses a label argument.
def is_label_instruction(line):
    instruction = instruction_aliases[line[0]]
    args = line[1]

    result = False
    result |= instruction.type == 'JUMP'   and isinstance(args[0], str)
    result |= instruction.type == 'BRANCH' and isinstance(args[2], str)
    result |= instruction.type == 'CALL'   and isinstance(args[1], str)

    return result

## @brief Creates a map of label identifiers to the corresponding instructions.
## @param lines The output of the parser.
## @return A map of labels and their corresponding instruction.
def parse_labels(lines):
    labels = {}
    
    index = 0
    for _, line in lines:
        is_label = instruction_aliases.get(line[0], 'LABEL_ID') == 'LABEL_ID'
        if is_label:
            # If a lable identifier is found, map it to the corresponding instruction.
            labels[line[0]] = index
        else:
            index += 2 if is_label_instruction(line) else 1
    
    return labels

## @brief Assembles a parsed program into binary words.
## @param lines The output of the parser.
## @return A list of the binary words corresponding to the input program.
def assemble(data):
    lines = parse(data)

    word_length = 32
    opcode_length = 8
    reg_length = 5

    reserved_reg = 31
    instruction_li = [i for i in instructions if i.alias == 'li'][0]

    # Translates register aliases to the actual value.
    def translate_named_regs(lineno, line):
        translated_regs = []
        for reg in line[1]:
            # Register aliases are parsed as tuples
            if isinstance(reg, tuple):
                # Report if alias has no corresponding register
                if reg[0] not in register_aliases:
                    # Find error line on input string
                    input_line = data.split('\n')[lineno - 1]
                    # Find index of label on input string
                    error_column = input_line.find(reg[0])

                    # Construct the error message
                    title = 'Assembler failed.\nInvalid register alias:'
                    error_pointer = 'line {}> '.format(lineno)
                    description = format_column_marker(input_line, error_column, error_pointer)
                    
                    sys.stderr.write(format_error(title, description))
                    exit(-1)
                translated_regs.append(register_aliases[reg[0]])
            else:
                translated_regs.append(reg)
        return tuple(translated_regs)

    # Utility for loading an address to the reserved register.
    # Useful when jumping to labels.
    def load_reserved_reg(label):
        if label not in labels:
                    # Find error line on input string
                    input_line = data.split('\n')[lineno - 1]
                    # Find index of label on input string
                    error_column = input_line.find(label)

                    # Construct the error message
                    title = 'Assembler failed.\nUnknown label:'
                    error_pointer = 'line {}> '.format(lineno)
                    description = format_column_marker(input_line, error_column, error_pointer)

                    sys.stderr.write(format_error(title, description))
                    exit(-1)

        address = labels[label]
        word  = to_fixed_length_bin(instruction_li.opcode, opcode_length) # OPCODE
        word += to_fixed_length_bin(reserved_reg, reg_length)             # REGISTER
        word += to_fixed_length_bin(0, 3)                                 # PADDING
        word += to_fixed_length_bin(address, 16)                          # IMMEDIATE
        return word    

    labels = parse_labels(lines)
    words = []

    index = 0
    for lineno, line in lines:
        is_label = instruction_aliases.get(line[0], 'LABEL') == 'LABEL'
        if not is_label:
            # Get the instruction class corresponding to the given alias.
            instruction = instruction_aliases[line[0]]
            # Translate register aliases after using them as arguments.
            args = translate_named_regs(lineno, line)
            # args = tuple([translate_named_regs(reg) for reg in line[1]])
            
            # Construct instruction word
            if instruction.type == 'NOOP':
                word  = to_fixed_length_bin(instruction.opcode, opcode_length) # OPCODE
                word += to_fixed_length_bin(0, 24)                             # FILL
                words.append(word)


            elif instruction.type == 'IMMEDIATE':
                word  = to_fixed_length_bin(instruction.opcode, opcode_length) # OPCODE
                word += to_fixed_length_bin(args[0], reg_length)               # REGISTER
                word += to_fixed_length_bin(0, 3)                              # PADDING
                word += to_fixed_length_bin(args[1], 16)                       # IMMEDIATE
                words.append(word)

            elif instruction.type == 'SINGLE_REG':
                word  = to_fixed_length_bin(instruction.opcode, opcode_length) # OPCODE
                word += to_fixed_length_bin(args[0], reg_length)               # REGISTER
                word += to_fixed_length_bin(0, 19)                             # FILL
                words.append(word)

            elif instruction.type == 'DOUBLE_REG' or instruction.type == 'MEMORY':
                word  = to_fixed_length_bin(instruction.opcode, opcode_length) # OPCODE
                word += to_fixed_length_bin(args[0], reg_length)               # REGISTER
                word += to_fixed_length_bin(args[1], reg_length)               # REGISTER
                word += to_fixed_length_bin(0, 14)                             # FILL
                words.append(word)

            elif instruction.type == 'JUMP':
                is_label_jump = isinstance(args[0], str)
                # Checks for a jump to label instruction.
                if is_label_jump:
                    # Load the address to the reserved register.
                    word = load_reserved_reg(args[0])
                    words.append(word)
                
                # When jumping to a label, the address is loaded to the reserved register.
                destination = reserved_reg if is_label_jump else args[0]
                word  = to_fixed_length_bin(instruction.opcode, opcode_length) # OPCODE
                word += to_fixed_length_bin(0, 10)                             # PADDING
                word += to_fixed_length_bin(destination, reg_length)           # REGISTER
                word += to_fixed_length_bin(0, 9)                              # FILL
                words.append(word)
            elif instruction.type == 'BRANCH':
                is_label_branch = isinstance(args[2], str)
                # Checks for a branch to label instruction.
                if is_label_branch:
                    # Load the address to the reserved register.
                    word = load_reserved_reg(args[2])
                    words.append(word)
                
                # When branching to a label, the address is loaded to the reserved register.
                destination = reserved_reg if is_label_branch else args[2]
                word  = to_fixed_length_bin(instruction.opcode, opcode_length) # OPCODE
                word += to_fixed_length_bin(args[0], reg_length)               # REGISTER
                word += to_fixed_length_bin(args[1], reg_length)               # REGISTER
                word += to_fixed_length_bin(destination, reg_length)           # REGISTER
                word += to_fixed_length_bin(0, 9)                              # FILL
                words.append(word)

            elif instruction.type == 'CALL':
                is_label_call = isinstance(args[1], str)
                # Checks for a call instruction.
                if is_label_call:
                    # Load the address to the reserved register.
                    word = load_reserved_reg(args[1])
                    words.append(word)

                # When calling a label, the address is loaded to the reserved register.
                destination = reserved_reg if is_label_call else args[1]
                word  = to_fixed_length_bin(instruction.opcode, opcode_length) # OPCODE
                word += to_fixed_length_bin(args[0], reg_length)               # REGISTER
                word += to_fixed_length_bin(0, 5)                              # PADDING
                word += to_fixed_length_bin(destination, reg_length)           # REGISTER
                word += to_fixed_length_bin(0, 9)                              # FILL
                words.append(word)
            
            index += 2 if is_label_instruction(line) else 1
            
    sys.stdout.write('Assembler successful.')
    return words


parser = argparse.ArgumentParser()
parser.add_argument('program', help='The path to the file to assemble.', type=str)
parser.add_argument('mif', help='The path to save the assembled file.', type=str)
args = parser.parse_args()

with open(args.program, 'r') as file:
    data = file.read()
bits = assemble(data)

mif = MIF(32, 2**8, 'BIN', 'BIN', bits)
with open(args.mif, 'w') as file:
    file.write(mif.as_file())
