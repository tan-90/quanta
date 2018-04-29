import json
from Util import dec_to_fixed_length_bin, vhdl_hex_to_int


class Instruction:
    def __init__(self, json_str):
        attribs = json.loads(json_str)

        self.description = attribs['description']
        self.opcode = vhdl_hex_to_int(attribs['opcode'])
        self.alias = attribs['alias']
        self.args = Argument.from_json(attribs['args'])

    def assemble(self, arg_values):
        word = ''        
        word += dec_to_fixed_length_bin(self.opcode, 8)

        for arg, arg_value in zip(self.args, arg_values):
            print(arg)
            arg_word = arg.assemble(arg_value)
            word += arg_word            
        return word


class Argument:
    @staticmethod
    def from_json(json_array):
        return [Argument(attribs) for attribs in json_array]

    def __init__(self, attribs):
        self.name = attribs['name']
        self.type = attribs['type']
        self.lenght = attribs['length']
        self.padding = attribs['padding']

    def assemble(self, value):
        word = dec_to_fixed_length_bin(value, self.lenght)
        return word.zfill(self.lenght + self.padding)

    def __str__(self):
        return 'Name: ' + self.name + ', Type: ' + self.type + ', Length: ' + str(self.lenght) + ', Padding: ' + str(self.padding)


# json_str = '''{"opcode":"16#03#", "description": "dummy", "alias": "dummy", "args": [{"name": "register_a", "type": "register", "length":5, "padding": 0}, {"name": "immediate", "type": "immediate", "length":5, "padding": 8}]}'''
# inst = Instruction(json_str)
# print(inst.assemble([3, 2]))
