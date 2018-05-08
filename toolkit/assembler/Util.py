def read_file(path):
    with open(path, 'r') as file:
        return file.read()

def write_file(path, data):
    with open(path, 'w') as file:
        file.write(data)

def vhdl_hex_to_int(hex):
    return int(hex[len('16#'):-1], 16)

def dec_to_fixed_length_bin(dec, length):
    return str(bin(int(dec)))[2:].zfill(length)

def strip_line(line):
    return line.replace(' ', '').replace('\t', '').replace('\n', '').replace('--', '')
