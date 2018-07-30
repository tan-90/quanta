class Port:
    def __init__(self, name, direction, type, doxygen):
        self.name = name
        self.direction = direction
        self.type = type
        self.doxygen = doxygen

    def __str__(self):
        return self.direction + '>' + self.name + ':' + self.type + ' ' + self.doxygen

    def __repr__(self):
        return self.__str__()


class Generic:
    def __init__(self, name, type, default, doxygen):
        self.name = name
        self.type = type
        self.default = default
        self.doxygen = doxygen

    def __str__(self):
        return 'g>' + self.name + ':' + self.type + ':=' + str(self.default) + ' ' + self.doxygen

    def __repr__(self):
        return self.__str__()


class Entity:
    def __init__(self, name, signals, generics, libs):
        self.name = name
        self.signals = signals
        self.generics = generics

        self.testbench_data = {
            'libs': libs,
            'signal_declarations': self.get_signal_declarations(),
            'generic_map': self.get_generic_map(),
            'port_map': self.get_port_map(),
            'variable_declarations': self.get_variable_declarations(),
            'read_case': self.get_read_case(),
            'signal_assignment': self.get_signal_assignement(),
            'write_signal': self.get_write_signal(),
            'check_signal': self.get_check_signal(),
            'report_fail': self.get_report_fail()
        }

    def get_testbench(self, template, path_file_in, path_file_out, header, block_s, block_e):
        formatter = lambda l, j='\n': j.join(self.testbench_data[l])

        _libs = formatter('libs')
        _signal_declarations = formatter('signal_declarations')
        _generic_map = formatter('generic_map')
        _port_map = formatter('port_map', ',\n')
        _variable_declarations = formatter('variable_declarations')
        _read_case = formatter('read_case', '\nread(vector_v, separator_v); -- Read the comma to the separator variable to discard it.\n')
        _signal_assignment = formatter('signal_assignment', ',\n')
        _write_signal = formatter('write_signal', '\nwrite(stream_out_v, string\'(","));\n')
        _check_signal = formatter('check_signal', ' and ')
        _report_fail = formatter('report_fail')

        return template.format(
            header=header,
            block_s=block_s,
            block_e=block_e,
            name=self.name,
            libs=_libs,
            signal_declarations=_signal_declarations,
            path_file_in=path_file_in,
            path_file_out=path_file_out,
            generic_map=_generic_map,
            port_map=_port_map,
            variable_declarations=_variable_declarations,
            read_case=_read_case,
            signal_assignment=_signal_assignment,
            write_signal=_write_signal,
            check_signal=_check_signal,
            report_fail=_report_fail
        )

    def get_signal_declarations(self):
        signal_declatarion = []

        for signal in self.signals:
            line = 'signal {}_s:{};{}'.format(
                signal.name, signal.type, signal.doxygen)
            signal_declatarion.append(line)
        return signal_declatarion

    def get_generic_map(self):
        generic_map = []

        for generic in self.generics:
            line = '{} => {}'.format(
                generic.name, str(generic.default))
            generic_map.append(line)
        return generic_map

    def get_port_map(self):
        port_map = []

        for signal in self.signals:
            line = '{}=>{}_s'.format(signal.name, signal.name)
            port_map.append(line)
        return port_map

    def get_variable_declarations(self):
        variable_declarations = []
        for signal in self.signals:
            line = 'variable {}_v:{}; {}'.format(
                signal.name, signal.type, signal.doxygen)
            variable_declarations.append(line)
        return variable_declarations

    def get_read_case(self):
        read_case = []
        for signal in self.signals:
            line = 'read(vector_v, {}_v);'.format(signal.name)
            read_case.append(line)
        return read_case

    def get_signal_assignement(self):
        signal_assignement = []
        for signal in [s for s in self.signals if s.direction == 'in']:
            line = '{}_s<={}_v'.format(signal.name, signal.name)
            signal_assignement.append(line)
        return signal_assignement

    def get_write_signal(self):
        write_signal = []
        for signal in self.signals:
            line = 'write(stream_out_v, {}_s);'.format(signal.name)
            write_signal.append(line)
        return write_signal

    def get_check_signal(self):
        check_signal = []
        for signal in [s for s in self.signals if s.direction == 'out']:
            line = '{}_s = {}_v'.format(signal.name, signal.name)
            check_signal.append(line)
        return check_signal

    def get_report_fail(self):
        report_fail = []
        for signal in [s for s in self.signals if s.direction == 'out']:
            info_line = 'write(stream_out_v, string\'(" Expected {}: "));'.format(signal.name)
            value_line = 'write(stream_out_v, {}_v );'.format(signal.name)
            lines = '{}\n{}\nwrite(stream_out_v, string\'("."));'.format(info_line, value_line)
            report_fail.append(lines)
        return report_fail
