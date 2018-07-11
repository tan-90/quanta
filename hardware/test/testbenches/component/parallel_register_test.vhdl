--! @file
--! @brief parallel_register testbench.

--! Use standart library.
library ieee;
--! Use logic elements.
use ieee.std_logic_1164.all;
--! Use text IO for file manipulation.
use std.textio.all;
--! Use std_logic text IO for interfacing logic elements and files. 
use ieee.std_logic_textio.all;

--! @brief Empty top level entity for testbench.
entity parallel_register_test is
end entity parallel_register_test;

--! @brief Default parallel_register test behavior.
--! @details Tests the parallel_register component given the input csv file.
--! @details Outputs test results to the output file.
architecture behavioral of parallel_register_test is
    signal clock_in_s  : std_logic; --! Clock signal.
    signal reset_in_s  : std_logic; --! Active high reset signal.
    signal enable_in_s : std_logic; --! Active high enable signal.
    signal data_in_s   : std_logic_vector(7 downto 0); --! Data input.
    signal data_out_s  : std_logic_vector(7 downto 0);  --! Data output.
    
    file file_in  : text; --! Input file.
    file file_out : text; --! Output file.

    constant PATH_FILE_IN  : string := "../test/in//component/parallel_register_test.csv"; --! Input file path.
    constant PATH_FILE_OUT : string := "../test/out/component_parallel_register_test.csv"; --! Output file path (prefixed since VHDL can't create folders).

    constant SET_INPUT_DELAY    : time := 2 ps; --! Time between each input change.
    constant CHECK_OUTPUT_DELAY : time := 1 ps; --! Time to wait for output check after the input is set.
begin
    --! @brief Unit under test.
    uut: entity work.parallel_register(behavioral)
    generic map
    (
        data_width_g => 8
    )
    port map
    (
        clock_in  => clock_in_s,
        reset_in  => reset_in_s,
        enable_in => enable_in_s,
        data_in   => data_in_s,
        data_out  => data_out_s
    );

    --! @brief Test process.
    --! @details Reads inputs from file, asserts outputs and writes test result to file.
    test: process
        variable vector_v     : line; -- Holds the current line from the input file.
        variable separator_v  : character; -- Holds the input file separator_v.
        
        variable stream_out_v : line; --! Holds the string being built to write on output.
        
        variable clock_in_v   : std_logic; -- Clock signal.
        variable reset_in_v   : std_logic; -- Active high reset signal.
        variable enable_in_v  : std_logic; -- Active high enable signal.
        variable data_in_v    : std_logic_vector(7 downto 0); -- Data input.
        variable data_out_v   : std_logic_vector(7 downto 0);  -- Data output.

        variable test_count_v   : integer := 0; -- Holds the number of tests executed.
        variable passed_count_v : integer := 0; -- Holdes the number of tests passed.
    begin
        file_open(file_in , PATH_FILE_IN , read_mode );
        file_open(file_out, PATH_FILE_OUT, write_mode);

        -- Write the header of the output file.
        write(stream_out_v, string'("-- Simulation result for 'parallel_register_test' with input file '" & PATH_FILE_IN & "'."));
        writeline(file_out, stream_out_v);
        
        write(stream_out_v, string'("-- Simulation results in csv format (commented with --):"));
        writeline(file_out, stream_out_v);

        write(stream_out_v, string'(""));
        writeline(file_out, stream_out_v);        

        -- Read the first line of input file, and write it to output, as it contains column names.
        readline (file_in , vector_v);
        writeline(file_out, vector_v);

        -- Run all test cases from input file.
        while not endfile(file_in) loop
            readline(file_in, vector_v);
            
            -- Read test case inputs.
            read(vector_v, clock_in_v);
            read(vector_v, separator_v); -- Read the comma to the separator variable to discard it.

            read(vector_v, reset_in_v);
            read(vector_v, separator_v); -- Read the comma to the separator variable to discard it.

            read(vector_v, enable_in_v);
            read(vector_v, separator_v); -- Read the comma to the separator variable to discard it.

            read(vector_v, data_in_v);
            read(vector_v, separator_v); -- Read the comma to the separator variable to discard it.

            -- Read test case expected output.
            read(vector_v, data_out_v);

            -- Set UUT input signals to test case inputs.
            clock_in_s  <= clock_in_v;
            reset_in_s  <= reset_in_v;
            enable_in_s <= enable_in_v;
            data_in_s   <= data_in_v;

            -- Wait for the signals to propagate.
            wait for CHECK_OUTPUT_DELAY;
            
            -- Write test case inputs to output file.
            write(stream_out_v, clock_in_s );
            write(stream_out_v, string'(","));
            write(stream_out_v, reset_in_s );
            write(stream_out_v, string'(","));
            write(stream_out_v, enable_in_s);
            write(stream_out_v, string'(","));
            write(stream_out_v, data_in_s  );
            write(stream_out_v, string'(","));

            -- Write actual UUT output to output file.
            write(stream_out_v, data_out_s );
            
            -- Check actual outputs against the expected ones.
            if data_out_s = data_out_v then
                -- Report a passed test to output file.
                write(stream_out_v, string'(" -- Passed."));

                passed_count_v := passed_count_v + 1;
            else
                -- Report a failed test to output file.
                write(stream_out_v, string'(" -- Failed."));
                write(stream_out_v, string'(" Expected data_out: "));
                write(stream_out_v, data_out_v );
                write(stream_out_v, string'("."));

                -- Report a failed test to simulation console.
                report "Test " & integer'image(test_count_v) & " failed. Refer to output file: " & PATH_FILE_OUT & ".";
            end if;

            writeline(file_out, stream_out_v);
            test_count_v := test_count_v + 1;

            -- Wait for time left until next inputs are set.
            wait for SET_INPUT_DELAY - CHECK_OUTPUT_DELAY;
        end loop;
        
        -- Report complete test results to output file.
        write(stream_out_v, string'(""));
        writeline(file_out, stream_out_v);

        -- Check the number of passed tests against the total number of tests.
        if test_count_v = passed_count_v then
            -- Report a passed test to output file.
            write(stream_out_v, string'("-- All tests passed for 'parallel_register_test'."));
            writeline(file_out, stream_out_v);
        else
            -- Report a failed test to output file.
            write(stream_out_v, string'("-- Tests failed for 'parallel_register_test'."));
            writeline(file_out, stream_out_v);

            write(stream_out_v, string'("-- " & integer'image(passed_count_v) & "/" & integer'image(test_count_v) & " tests passed."));
            writeline(file_out, stream_out_v);

            report "Tests failed. " & integer'image(passed_count_v) & "/" & integer'image(test_count_v) & " tests passed.";
        end if;
        
        file_close(file_in );
        file_close(file_out);
        wait;
    end process test;    
end architecture behavioral;
