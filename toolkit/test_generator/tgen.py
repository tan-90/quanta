from entity import *
from entity_parser import parse

IN = 'D:/Projects/quanta/hardware/vhdl/component/parallel_register.vhdl'
OUT = 'out.vhdl'
TEMPLATE  = 'D:/Projects/quanta/toolkit/test_generator/template_test.vhdl.txt'

data = ''
with open(IN, 'r') as file:
    data = file.read()
template = ''
with open(TEMPLATE, 'r') as file:
    template = file.read()

# template = '{name}\n{libs}\n{signal_declarations}\n{path_file_in}\n{path_file_out}\n{generic_map}\n{port_map}\n{variable_declarations}\n{read_case}\n{signal_assignment}\n{write_signal}\n{check_signal}\n{report_fail}'


BLOCK_S  = '-----------------------------------------\n'
BLOCK_S += '-- Start of tgen generated code block. --\n'

BLOCK_E  = '\n-- End of tgen generated code block. --\n'
BLOCK_E += '-----------------------------------------'

HEADER  = '--! @details File generated by the quanta testbench generator utility.\n'
HEADER += '--! @details Refer to gitlab.com/tan90/quanta for details.\n'

e = parse(data)
with open(OUT, 'w') as file:
    file.write(e.get_testbench(template, IN, OUT, HEADER, BLOCK_S, BLOCK_E))