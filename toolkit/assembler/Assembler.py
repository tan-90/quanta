import json

def read_file(path):
    file = open(path)
    return file.readlines()

def strip_line(line):
    return line.replace(' ', '').replace('\t', '').replace('\n', '').replace('--', '')

def get_assembler_annotations(lines):
    current_line = 0
    while current_line < len(lines):
        line = strip_line(lines[current_line])
        if line.startswith('@assembler'):
            line = line[len('@assembler.'):]
            if line.startswith('instruction'):
                pass
            elif line.startswith('params'):
                pass

            json_string = ''
            while not line.startswith('};'):
                current_line += 1
                line = strip_line(lines[current_line])
                json_string += line
            print(json.loads(json_string[:-1]))
            
        current_line += 1

get_assembler_annotations(read_file('Constants.vhdl'))
exit()

file = open('Constants.vhdl')
lines = file.readlines()

current_line = 0

while True:
    line = lines[current_line]
    line = line.replace(" ", "")
    if line.startswith('--@assembler'):
        line = line[len('--@assembler.'):]
        
        if line.startswith('instruction'):
            current_line += 1
            line = lines[current_line]
            line = line.replace(" ", "")
            line = line.replace("--", "")
            while not line.startswith('};'):
                print(line)
                current_line += 1
                line = lines[current_line]
                line = line.replace(" ", "")
                line = line.replace("--", "")
    
    current_line += 1            
