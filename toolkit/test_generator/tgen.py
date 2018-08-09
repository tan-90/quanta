import argparse
import os
import re

from entity import *
from entity_parser import parse

parser = argparse.ArgumentParser()
# The root project directory.
# Should follow the structure:
# modelsim/
# test/
# ├── in/
# ├── out/
# └── testbenchess/
# vhdl/
# The subfolder structure of the 'vhdl' folder will be manteined for the 'test/in' and 'test/testbenches'.
# As the VHDL file IO can't create directories, files in 'test/out' will be prefixed by the folder path, with '_' as a separator.
parser.add_argument('root', help='The root VHDL project folder', type=str)
parser.add_argument('source', help='The path to the VHDL entity source. Relative to the root folder.', type=str)
parser.add_argument('--template', help='The testbench template. If not set, the default template will be used.', type=str, default='template_test.vhdl.txt')
parser.add_argument('--csv', help='If specified, the testbench input file will be generated. WARNING: Replaces existing files.', action='store_true')
args = parser.parse_args()

## @brief The absolute source path.
source_path = os.path.join(args.root, args.source)
## @brief The filename without the extension relative to the vhdl folder.
## @details Used for generating file paths to save inside other folders.
clean_file_name = re.search(r'vhdl/([a-zA-Z0-9_/]+).vhdl', args.source).group(1)

with open(source_path, 'r') as file:
    data = file.read()

with open(args.template, 'r') as file:
    template = file.read()

## @brief The entity parsed from the source file.
entity = parse(data)

## @brief The path of the generated testbench.
testbench_path = '{}/{}_test.vhdl'.format('test/testbenches', clean_file_name)

## @brief The csv input for the test.
## @details Used for generating statements for opening the input file in the testbench and generating the empty csv files.
in_path = '{}/{}_test.csv'.format('test/in', clean_file_name)
## @brief The csv output for the test.
## @details Used for generating statements for opening the output file in the testbench.
## @details Changes folder separators to '_' as VHDL can't create directories.
out_path = '{}/{}_test.csv'.format('test/out', clean_file_name.replace('/', '_'))

testbench_path = os.path.join(args.root, testbench_path)
os.makedirs(os.path.dirname(testbench_path), exist_ok=True)
with open(testbench_path, 'w') as file:
    # As the modelsim project root will be on a subfolder, the paths have to be joined with a '../'
    file.write(entity.get_testbench(template, os.path.join('../', in_path), os.path.join('../', out_path)))

# Generate a csv template file if requested.
if args.csv:
    in_path = os.path.join(args.root, in_path)
    os.makedirs(os.path.dirname(in_path), exist_ok=True)
    with open(in_path, 'w') as file:
        file.write(entity.get_csv())

