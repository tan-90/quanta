import json
import re

from Instruction import Instruction
from Util import read_file, strip_line

class Assembler:
    def __init__(self, params):
        self.arg_types = params['arg_types']
        self.instructions = {attribs['alias']: Instruction(attribs) for attribs in params['instructions']}

    def assemble(self, program):
        lines = program.split('\n')
        words = []

        for line in lines:
            alias, args = self.parse(line)
            words.append(self.instructions[alias].assemble(args, self.arg_types))
        return words
    
    def parse(self, line):
        separator = line.index(' ')
        alias = line[:separator]
        
        args = []
        separator = 0
        for arg in self.instructions[alias].args:
            if(arg.startswith('padding_')):
                args.append(0)
            else:
                separator += 2 + line[separator + 1:].index(' ')
                value = re.findall(self.arg_types[arg]['regex'], line[separator:])[0]
                args.append(value)
        return alias, args

    @staticmethod
    def params_from_file(path):
        json_str = read_file(path)
        json_str = strip_line(json_str)
        return json.loads(json_str)

q = Assembler(Assembler.params_from_file('quanta.json'))
bits = q.assemble(read_file('program.qtf'))
print(bits)
