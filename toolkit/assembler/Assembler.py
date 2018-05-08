import json
import re

from Instruction import Instruction
from MIF import MIF
from Util import read_file, strip_line, write_file

class Assembler:
    def __init__(self, params, verbose=False):
        self.arg_types = params['arg_types']
        self.instruction_types = params['instruction_types']

        self.instructions = {attribs['alias']: Instruction(attribs) for attribs in params['instructions']}
        
        self.verbose = verbose

    def assemble(self, program):
        self.log(self)

        lines = program.split('\n')
        words = []

        for line in lines:
            alias, args = self.parse(line)
            words.append(self.instructions[alias].assemble(args, self.arg_types, self.instruction_types))
        return words
    
    def parse(self, line):
        separator = line.index(' ')
        alias = line[:separator]
        line_type = self.instructions[alias].type
        
        args = []
        separator = 0
        for arg in self.instruction_types[line_type]:
            if(arg.startswith('padding_')):
                args.append(0)
            else:
                separator += 2 + line[separator + 1:].index(' ')
                value = re.findall(self.arg_types[arg]['regex'], line[separator:])[0]
                args.append(value)
        return alias, args

    def __str__(self):
        return 'arg_types: ' + str(self.arg_types) + ', instructions: ' + str(self.instructions)

    def log(self, message):
        if self.verbose:
            print(message)

    @staticmethod
    def params_from_file(path):
        json_str = read_file(path)
        json_str = strip_line(json_str)
        return json.loads(json_str)

q = Assembler(Assembler.params_from_file('quanta.json'))
bits = q.assemble(read_file('program.qtf'))
mif = MIF(32, 256, 'BIN', 'BIN', bits)
write_file('program.mif', mif.as_file())
