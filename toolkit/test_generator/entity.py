## @brief Holds information about a port declaration.
## @details Used as a convenient way to store parsed port declarations.
class Port:
    def __init__(self, name, direction, type, doxygen):
        ## @brief The port name.
        self.name = name
        ## @brief The direction of the port signal.
        ## @details tgen only supports in|out port directions.
        self.direction = direction
        ## @brief The type of the port signal.
        ## @details Supports use of generics in port type declarations.
        self.type = type
        ## @brief The doxygen documentation comment for the port.
        ## @details The documentation comment is required.
        self.doxygen = doxygen

    def __str__(self):
        return '{}> {}:{} {}'.format(self.direction, self.name, self.type, self.doxygen)

    def __repr__(self):
        return self.__str__()


## @brief Holds information about a generic declaration.
## @details Used as a convenient way to store parsed generic declarations.
class Generic:
    def __init__(self, name, type, default, doxygen):
        ## @brief The generic name.
        self.name = name
        ## @brief The type of the generic.
        self.type = type
        ## @brief The default value of the generic.
        ## @generic The default value is used for as the generic value on the generated testbench.
        self.default = default
        ## @brief The doxygen documentation comment for the generic.
        ## @details The documentation comment is required.
        self.doxygen = doxygen

    def __str__(self):
        return '{}> {}:{}:={} {}'.format('g>', self.name, self.type, str(self.default), self.doxygen)

    def __repr__(self):
        return self.__str__()


## @brief The class that represents a parsed entity.
## @details Holds entity information and allows for generating a testbench.
class Entity:
    def __init__(self, name, signals, generics, libs):
        ## @brief The entity name.
        self.name = name
        ## @brief The list of all the ports.
        self.signals = signals
        ## @brief  The list of all the generics.
        self.generics = generics

        ## @brief The cached testbench data.
        ## @details Holds the generated strings to be used on the testbench.
        ## @details Automatically created upon construction.
        self.testbench_data = {
            'libs': libs, # Copies the library declarations from the entity source file.
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

    ## @brief Constructs a testbench file.
    ## @details Injects generated data into a testbench template.
    ## @details The template can be customized and values between {} will be replaced by generated values.
    ## @param template The testbench to be used as a template.
    ## @param path_file_in The path to the input csv file with the test data.
    ## @param path_file_out The path of the output file to log test results to.
    ## @param header The header of the template file. Used to document it as a tgen generated file.
    ## @param block_s The text to use as a marker for the start of a tgen generated code block.
    ## @param block_e The text to use as a marker for the end of a tgen generated code block.
    ## @return The testbench as a string.
    def get_testbench(self, template, path_file_in, path_file_out):
        # A header to be included in the template.
        header  = '--! @details File generated by the quanta testbench generator utility.\n'
        header += '--! @details Refer to gitlab.com/tan90/quanta for details.\n'

        # A string that marks the start of a generated block.
        block_s  = '--------------------------------------\n'
        block_s += '-- Start of tgen generated code block.\n'

        # A string that marks the end of a generated block.
        block_e = '\n--  End of tgen generated code block.\n'
        block_e += '--------------------------------------'
  
        # Utility for getting and formatting the testbench data.
        # Useful for appending strings that only go in between generated ones.
        # For example, writing a comma between each expected value.
        formatter = lambda l, j='\n': j.join(self.testbench_data[l])

        _libs = formatter('libs')
        _signal_declarations = formatter('signal_declarations')
        _generic_map = ''
        if len(self.testbench_data['generic_map']) != 0:
            _generic_map = formatter('generic_map', ',\n')
            _generic_map = 'generic map\n(\n{}\n)\n'.format(_generic_map)
        else:
            _generic_map = '-- [tgen] No generics on UUT.'
        _port_map = formatter('port_map', ',\n')
        _variable_declarations = formatter('variable_declarations')
        _read_case = formatter('read_case', '\nread(vector_v, separator_v); -- Read the comma to the separator variable to discard it.\n')
        _signal_assignment = formatter('signal_assignment')
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

    ## @brief Constructs a blank csv input file.
    ## @details The csv file used to specify test values.
    ## @return The blank csv file as string.
    def get_csv(self):
        return '{}\n'.format(','.join([s.name for s in self.signals]))
    
    ## @brief Constructs the list of documented test signal declarations.
    ## @details Generates the signals that will be conected to the UUT.
    ## @details Suffixes the port name with _s.
    ## @return The list of declarations for all test signals.
    def get_signal_declarations(self):
        signal_declatarion = []

        for signal in self.signals:
            line = 'signal {}_s:{};{}'.format(signal.name, signal.type, signal.doxygen)
            signal_declatarion.append(line)
        return signal_declatarion

    ## @brief Constructs the list of generic mappings.
    ## @details Maps every generic to it's default value.
    ## @details Default generic value is required and can't be changed.
    ## @return The list of mappings for all generics.
    def get_generic_map(self):
        generic_map = []

        for generic in self.generics:
            line = '{} => {}'.format(generic.name, str(generic.default))
            generic_map.append(line)
        return generic_map

    ## @brief Constructs the list of port mappings.
    ## @detais Maps every port to it's generated test signal.
    ## @return The list of mappings for all ports.
    def get_port_map(self):
        port_map = []

        for signal in self.signals:
            line = '{}=>{}_s'.format(signal.name, signal.name)
            port_map.append(line)
        return port_map

    ## @brief Constructs the list of variable declarations.
    ## @details Generates the variables that will be used for reading/writing files.
    ## @return The list of variable declarations.
    def get_variable_declarations(self):
        variable_declarations = []
        for signal in self.signals:
            line = 'variable {}_v:{}; {}'.format(
                signal.name, signal.type, signal.doxygen)
            variable_declarations.append(line)
        return variable_declarations

    ## @brief Constructs the list of line read statements.
    ## @details Generates the statements that read values from a line into the corresponding variables.
    ## @return The list of line read statements.
    def get_read_case(self):
        read_case = []
        for signal in self.signals:
            line = 'read(vector_v, {}_v);'.format(signal.name)
            read_case.append(line)
        return read_case

    ## @brief Constructs the list of signal assignments.
    ## @details Generates the statements for assigning the value read from a file to the corresponding test signal.
    ## @return The list of test signal assignment statements.
    def get_signal_assignement(self):
        signal_assignement = []
        for signal in [s for s in self.signals if s.direction == 'in']:
            line = '{}_s<={}_v;'.format(signal.name, signal.name)
            signal_assignement.append(line)
        return signal_assignement

    ## @brief Constructs the list of file write statements.
    ## @details Generates the statements that writes signal values to file.
    ## @return The list of file write statements.
    def get_write_signal(self):
        write_signal = []
        for signal in self.signals:
            line = 'write(stream_out_v, {}_s);'.format(signal.name)
            write_signal.append(line)
        return write_signal

    ## @brief Constructss the list of comparations to check output signals.
    ## @details Generates the statements that compare the signal result to the expected value.
    ## @return The list of compare statements.
    def get_check_signal(self):
        check_signal = []
        for signal in [s for s in self.signals if s.direction == 'out' or s.direction == 'buffer']:
            line = '{}_s = {}_v'.format(signal.name, signal.name)
            check_signal.append(line)
        return check_signal

    ## @brief Constructs the list of statements to write a report of test failure to file.
    ## @details Generates the failure report along with expected value logs.
    ## @return The list of statements to log failures to file.
    def get_report_fail(self):
        report_fail = []
        for signal in [s for s in self.signals if s.direction == 'out' or s.direction == 'buffer']:
            info_line = 'write(stream_out_v, string\'(" Expected {}: "));'.format(signal.name)
            value_line = 'write(stream_out_v, {}_v );'.format(signal.name)
            lines = '{}\n{}\nwrite(stream_out_v, string\'("."));'.format(info_line, value_line)
            report_fail.append(lines)
        return report_fail
