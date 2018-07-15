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

    generics = []
    for g in generic_info:
        generics.append(Generic(g[0] + '_g', g[1], g[2], g[3]))

    signals = []
    for s in signal_info:
        signal_type = s[2]
        for g in generics:
            signal_type = signal_type.replace(g.name, g.default)

        signals.append(Signal(s[0], s[1], signal_type, s[3]))

    libs = [group[0] for group in re.findall(r_lib, source)]
    return Entity(name, signals, generics, libs)
