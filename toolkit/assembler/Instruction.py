import json

from Util import dec_to_fixed_length_bin, vhdl_hex_to_int


class Instruction:
    def __init__(self, attribs):

        self.name = attribs['name']
        self.description = attribs['description']
        self.opcode = attribs['opcode']
        self.type = attribs['type']

    def assemble(self, arg_values, arg_types, instruction_types):
        word = ''
        word += dec_to_fixed_length_bin(self.opcode, 8)

        for arg_type, arg_value in zip(instruction_types[self.type], arg_values):
            arg_word = Instruction.assemble_arg(arg_types, arg_type, arg_value)
            word += arg_word
        return word.ljust(32, '0')
    
    def __str__(self):
        return 'name: ' + self.name + ', description: ' + self.description + ', OPCODE: ' + str(self.opcode) + ', type: ' + str(self.type)

    @staticmethod
    def assemble_arg(arg_types, arg_type, arg_value):
        word = dec_to_fixed_length_bin(arg_value, arg_types[arg_type]['length'])
        return word
