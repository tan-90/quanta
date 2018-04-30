import json
from Util import dec_to_fixed_length_bin, vhdl_hex_to_int


class Instruction:
    def __init__(self, attribs):

        self.name = attribs['name']
        self.description = attribs['description']
        self.opcode = attribs['opcode']
        self.args = attribs['args']

    def assemble(self, arg_values, arg_types):
        word = ''
        word += dec_to_fixed_length_bin(self.opcode, 8)

        for arg_type, arg_value in zip(self.args, arg_values):
            arg_word = Instruction.assemble_arg(arg_types, arg_type, arg_value)
            word += arg_word
        return word.ljust(32, '0')
    
    def __str__(self):
        return 'Name: ' + self.name + ', Description: ' + self.description + ', OPCODE: ' + str(self.opcode) + ', args: ' + str(self.args)

    @staticmethod
    def assemble_arg(arg_types, arg_type, arg_value):
        word = dec_to_fixed_length_bin(arg_value, arg_types[arg_type]['length'])
        return word
