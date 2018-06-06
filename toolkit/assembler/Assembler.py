import json
import re

from Instruction import Instruction
from MIF import MIF
from Util import read_file, strip_line, write_file

class Assembler:
    def __init__(self, params, verbose=False):
        self.arg_types = params['arg_types']
        self.instruction_types = params['instruction_types']
        self.label_instructions = params['label_instructions']

        self.instructions = {attribs['alias']: Instruction(attribs) for attribs in params['instructions']}
        
        self.verbose = verbose

    def assemble(self, program):
        lines = program.split('\n')
        lines = Assembler.preprocess_lines(lines)

        lines = self.expand_labels(lines)
    
        words = []       

        for line in lines:
            alias, args = self.parse(line)
            words.append(self.instructions[alias].assemble(args, self.arg_types, self.instruction_types))
        return words

    def expand_labels(self, lines):
        instruction_index = 0
        processed_lines = []
        labels = {}

        for line in lines:            
            if line.startswith('.'):
                labels[line[1:-1]] = instruction_index
            else:
                processed_lines.append(line)
                separator = line.index(' ')
                alias = line[:separator]

                if '.' in line and alias in self.label_instructions:
                    instruction_index += 2
                else:
                    instruction_index += 1
        
        lines = list(processed_lines)
        processed_lines = []
        for line in lines:
            separator = line.index(' ')
            alias = line[:separator]

            if '.' in line and alias in self.label_instructions:
                separator = line.index('.')
                label = line[separator + 1:]
                
                processed_lines.append('li $31, ' + str(labels[label]))
                processed_lines.append(line[:separator] + '$31')
            else:
                processed_lines.append(line)

        return processed_lines

    @staticmethod
    def preprocess_lines(lines):
        processed_lines = []

        for line in lines:
            if ';' in line:
                line = line[:line.index(';')]

            while line.startswith(' '):
                line = line[1:]
            
            if len(line) == 0:
                continue
            else:
                processed_lines.append(line)

        return processed_lines
    
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
# bits = q.assemble(read_file('program.qtf'))
bits = q.assemble(read_file('C:\\Vinicius\\quanta\\Software\\Toolkit\\Assembler\\out\\artifacts\\Assembler_jar\\Label.qtf'))
mif = MIF(32, 256, 'BIN', 'BIN', bits)
write_file('C:\\Vinicius\\quanta\\Hardware\\quanta2\\quanta2inst.mif', mif.as_file())
