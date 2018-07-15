from entity import *
from entity_parser import parse

IN = 'C:/Projects/quanta/hardware/vhdl/component/parallel_register.vhdl'
data = ''
with open(IN, 'r') as file:
    data = file.read()

e = parse(data)
