def read_file(path):
    file = open(path)
    return file.readlines()

def vhdl_hex_to_int(hex):
    return int(hex[len('16#'):-1], 16)

def dec_to_fixed_length_bin(dec, length):
    return str(bin(dec))[2:].zfill(length)

def strip_line(line):
    return line.replace(' ', '').replace('\t', '').replace('\n', '').replace('--', '')
