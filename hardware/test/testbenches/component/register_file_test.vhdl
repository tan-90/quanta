--! @file
--! @brief register_file testbench.
--! @details File generated by the quanta testbench generator utility.
--! @details Refer to gitlab.com/tan90/quanta for details.


--------------------------------------
-- Start of tgen generated code block.

--! use standart library.
library ieee;
--! use logic elements.
use ieee.std_logic_1164.all;
--! use unsigned logic for converting logic vectors to integers.
use ieee.std_logic_unsigned.all;
--! use numeric elements for address derreferencing.
use ieee.numeric_std.all;

--  End of tgen generated code block.
--------------------------------------

--! Use text IO for file manipulation.
use std.textio.all;
--! Use std_logic text IO for interfacing logic elements and files. 
use ieee.std_logic_textio.all;

--! @brief Empty top level entity for testbench.
entity register_file_test is
end entity register_file_test;

--! @brief Default register_file test behavior.
--! @details Tests the register_file component given the input csv file.
--! @details Outputs test results to the output file.
architecture behavioral of register_file_test is

--------------------------------------
-- Start of tgen generated code block.

signal clock_in_s:std_logic;--! Clock signal.
signal reset_in_s:std_logic;--! Active high reset signal.
signal enable_in_s:std_logic;--! Active high enable signal.
signal write_data_in_s:std_logic_vector(32 - 1 downto 0);--! Input data.
signal write_address_in_s:std_logic_vector( 4 downto 0);--! Write address.
signal write_signal_in_s:std_logic;--! Write signal.
signal address_a_in_s:std_logic_vector( 4 downto 0);--! Read address a.
signal address_b_in_s:std_logic_vector( 4 downto 0);--! Read address b.
signal address_c_in_s:std_logic_vector( 4 downto 0);--! Read address c.
signal data_a_out_s:std_logic_vector(32 - 1 downto 0);--! Output data a.
signal data_b_out_s:std_logic_vector(32 - 1 downto 0);--! Output data b.
signal data_c_out_s:std_logic_vector(32 - 1 downto 0);--! Output data c.

--  End of tgen generated code block.
--------------------------------------
    
    file file_in  : text; --! Input file.
    file file_out : text; --! Output file.

    constant PATH_FILE_IN  : string := "../test/in/component/register_file_test.csv"; --! Input file path.
    constant PATH_FILE_OUT : string := "../test/out/component_register_file_test.csv"; --! Output file path (prefixed since VHDL can't create folders).

    constant SET_INPUT_DELAY    : time := 2 ps; --! Time between each input change.
    constant CHECK_OUTPUT_DELAY : time := 1 ps; --! Time to wait for output check after the input is set.
begin
    --! @brief Unit under test.
    uut: entity work.register_file(behavioral)
    generic map
    (

--------------------------------------
-- Start of tgen generated code block.

data_width_g => 32

--  End of tgen generated code block.
--------------------------------------

    )
    port map
    (

--------------------------------------
-- Start of tgen generated code block.

clock_in=>clock_in_s,
reset_in=>reset_in_s,
enable_in=>enable_in_s,
write_data_in=>write_data_in_s,
write_address_in=>write_address_in_s,
write_signal_in=>write_signal_in_s,
address_a_in=>address_a_in_s,
address_b_in=>address_b_in_s,
address_c_in=>address_c_in_s,
data_a_out=>data_a_out_s,
data_b_out=>data_b_out_s,
data_c_out=>data_c_out_s

--  End of tgen generated code block.
--------------------------------------

    );

    --! @brief Test process.
    --! @details Reads inputs from file, asserts outputs and writes test result to file.
    test: process
        variable vector_v     : line; -- Holds the current line from the input file.
        variable separator_v  : character; -- Holds the input file separator_v.
        
        variable stream_out_v : line; --! Holds the string being built to write on output.

--------------------------------------
-- Start of tgen generated code block.

variable clock_in_v:std_logic; --! Clock signal.
variable reset_in_v:std_logic; --! Active high reset signal.
variable enable_in_v:std_logic; --! Active high enable signal.
variable write_data_in_v:std_logic_vector(32 - 1 downto 0); --! Input data.
variable write_address_in_v:std_logic_vector( 4 downto 0); --! Write address.
variable write_signal_in_v:std_logic; --! Write signal.
variable address_a_in_v:std_logic_vector( 4 downto 0); --! Read address a.
variable address_b_in_v:std_logic_vector( 4 downto 0); --! Read address b.
variable address_c_in_v:std_logic_vector( 4 downto 0); --! Read address c.
variable data_a_out_v:std_logic_vector(32 - 1 downto 0); --! Output data a.
variable data_b_out_v:std_logic_vector(32 - 1 downto 0); --! Output data b.
variable data_c_out_v:std_logic_vector(32 - 1 downto 0); --! Output data c.

--  End of tgen generated code block.
--------------------------------------

        variable test_count_v   : integer := 0; -- Holds the number of tests executed.
        variable passed_count_v : integer := 0; -- Holdes the number of tests passed.
    begin
        file_open(file_in , PATH_FILE_IN , read_mode );
        file_open(file_out, PATH_FILE_OUT, write_mode);

        -- Write the header of the output file.
        write(stream_out_v, string'("-- Simulation result for 'register_file_test' with input file '" & PATH_FILE_IN & "'."));
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
            
            -- Read test case inputs and expected output.
            
--------------------------------------
-- Start of tgen generated code block.

read(vector_v, clock_in_v);
read(vector_v, separator_v); -- Read the comma to the separator variable to discard it.
read(vector_v, reset_in_v);
read(vector_v, separator_v); -- Read the comma to the separator variable to discard it.
read(vector_v, enable_in_v);
read(vector_v, separator_v); -- Read the comma to the separator variable to discard it.
read(vector_v, write_data_in_v);
read(vector_v, separator_v); -- Read the comma to the separator variable to discard it.
read(vector_v, write_address_in_v);
read(vector_v, separator_v); -- Read the comma to the separator variable to discard it.
read(vector_v, write_signal_in_v);
read(vector_v, separator_v); -- Read the comma to the separator variable to discard it.
read(vector_v, address_a_in_v);
read(vector_v, separator_v); -- Read the comma to the separator variable to discard it.
read(vector_v, address_b_in_v);
read(vector_v, separator_v); -- Read the comma to the separator variable to discard it.
read(vector_v, address_c_in_v);
read(vector_v, separator_v); -- Read the comma to the separator variable to discard it.
read(vector_v, data_a_out_v);
read(vector_v, separator_v); -- Read the comma to the separator variable to discard it.
read(vector_v, data_b_out_v);
read(vector_v, separator_v); -- Read the comma to the separator variable to discard it.
read(vector_v, data_c_out_v);

--  End of tgen generated code block.
--------------------------------------

            -- Set UUT input signals to test case inputs.

--------------------------------------
-- Start of tgen generated code block.

clock_in_s<=clock_in_v;
reset_in_s<=reset_in_v;
enable_in_s<=enable_in_v;
write_data_in_s<=write_data_in_v;
write_address_in_s<=write_address_in_v;
write_signal_in_s<=write_signal_in_v;
address_a_in_s<=address_a_in_v;
address_b_in_s<=address_b_in_v;
address_c_in_s<=address_c_in_v;

--  End of tgen generated code block.
--------------------------------------

            -- Wait for the signals to propagate.
            wait for CHECK_OUTPUT_DELAY;
            
            -- Write test case signals to output file.

--------------------------------------
-- Start of tgen generated code block.

write(stream_out_v, clock_in_s);
write(stream_out_v, string'(","));
write(stream_out_v, reset_in_s);
write(stream_out_v, string'(","));
write(stream_out_v, enable_in_s);
write(stream_out_v, string'(","));
write(stream_out_v, write_data_in_s);
write(stream_out_v, string'(","));
write(stream_out_v, write_address_in_s);
write(stream_out_v, string'(","));
write(stream_out_v, write_signal_in_s);
write(stream_out_v, string'(","));
write(stream_out_v, address_a_in_s);
write(stream_out_v, string'(","));
write(stream_out_v, address_b_in_s);
write(stream_out_v, string'(","));
write(stream_out_v, address_c_in_s);
write(stream_out_v, string'(","));
write(stream_out_v, data_a_out_s);
write(stream_out_v, string'(","));
write(stream_out_v, data_b_out_s);
write(stream_out_v, string'(","));
write(stream_out_v, data_c_out_s);

--  End of tgen generated code block.
--------------------------------------

            -- Check actual outputs against the expected ones.
            if data_a_out_s = data_a_out_v and data_b_out_s = data_b_out_v and data_c_out_s = data_c_out_v then
                -- Report a passed test to output file.
                write(stream_out_v, string'(" -- Passed."));

                passed_count_v := passed_count_v + 1;
            else
                -- Report a failed test to output file.
                write(stream_out_v, string'(" -- Failed."));

--------------------------------------
-- Start of tgen generated code block.

write(stream_out_v, string'(" Expected data_a_out: "));
write(stream_out_v, data_a_out_v );
write(stream_out_v, string'("."));
write(stream_out_v, string'(" Expected data_b_out: "));
write(stream_out_v, data_b_out_v );
write(stream_out_v, string'("."));
write(stream_out_v, string'(" Expected data_c_out: "));
write(stream_out_v, data_c_out_v );
write(stream_out_v, string'("."));

--  End of tgen generated code block.
--------------------------------------

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
            write(stream_out_v, string'("-- All tests passed for 'register_file'."));
            writeline(file_out, stream_out_v);
        else
            -- Report a failed test to output file.
            write(stream_out_v, string'("-- Tests failed for 'register_file_test'."));
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
