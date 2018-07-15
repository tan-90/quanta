import re

from entity import *

r_name = r'entity\s*([\w\d]*)\s*is'
r_generic = r'([\w\d]+)_g\s*:\s*(.*?)\s*:=\s*([0-9]+)\s*(--!.*)'
r_signal = r'([\w\d]+)\s*:\s*(in|out)\b\s*(.*?);?\s*(--!.*)'
r_lib = r'(--!.*\n*(library|use).*?;)'

def parse(source):
    name = re.search(r_name, source).group(1)

    generic_info = re.findall(r_generic, source)
    signal_info = re.findall(r_signal, source)

    signals = []
    for s in signal_info:
        signals.append(Signal(s[0], s[1], s[2], s[3]))
    
    generics = []
    for g in generic_info:
        generics.append(Generic(g[0], g[1], g[2], g[3]))

    libs = re.findall(r_lib, source)
    return Entity(name, signals, generics, libs)
