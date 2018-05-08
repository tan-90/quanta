import math

from Util import dec_to_fixed_length_bin

class MIF:
    def __init__(self, width, depth, address_radix, data_radix, data):
        self.width = width
        self.depth = depth
        self.address_width = int(math.log2(depth))

        self.address_radix = address_radix
        self.data_radix = data_radix

        self.data = data

    def format_data(self):
        data_str = ''
        line = 0

        for word in self.data:
            data_str += '\t'
            data_str += dec_to_fixed_length_bin(line, self.address_width)
            data_str += ':'
            data_str += word
            data_str += ';\n'
            line += 1

        return data_str

    def as_file(self):
        data = ''

        data += 'WIDTH=' + str(self.width) + ';\n'
        data += 'DEPTH=' + str(self.depth) + ';\n'

        data += 'ADDRESS_RADIX=' + self.address_radix + ';\n'
        data += 'DATA_RADIX=' + self.data_radix + ';\n'
        data += 'CONTENT BEGIN\n'

        data += self.format_data()

        data += 'END;\n'

        return data
