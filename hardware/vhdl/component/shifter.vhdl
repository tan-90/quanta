--! @file
--! @brief Generic width shifter.

--! Use standart library.
library ieee;
--! Use logic elements.
use ieee.std_logic_1164.all;
--! Use numeric elements for generic type and vector construction.
use ieee.numeric_std.all;
--! Use misc logic to replace unary operators for VHDL 2002 compatibility.
use ieee.std_logic_misc.all;

--! Use the function code definitions.
use work.shifter_functions;
--! Use the status indices definitions (same as used by ALU).
use work.alu_status;

--! @brief Generic width shifter.
--! @details Generic width shifter with 4 bit fuction selector and 5 bit status output.
--! @details Functions:
--! |Code  |Function                   |
--! |:-----|:--------------------------|
--! |`x0`  |Zero                       |
--! |`x1`  |Pass                       |
--! |`x2`  |Left                       |
--! |`x3`  |Right                      |
--! |`x4`  |Arithmetic left            |
--! |`x5`  |Arithmetic right           |
--! |`x6`  |Rotate left                |
--! |`x7`  |Rotate right               |
--! |`x8`  |Rotate right through carry |
--! |`x9`  |Rotate right through carry |
--! |`xA`  |NOOP                       |
--! |`xB`  |NOOP                       |
--! |`xC`  |NOOP                       |
--! |`xD`  |NOOP                       |
--! |`xE`  |NOOP                       |
--! |`xF`  |NOOP                       |
--! @details Status:
--! |Index|Value   |
--! |:----|:-------|
--! |`0`  |Zero    |
--! |`1`  |Sign    |
--! |`2`  |Carry   |
--! |`3`  |Parity  |
--! |`4`  |Overflow|
--! @see shifter_functions
--! @see alu_status
entity shifter is
    generic
    (
        data_width_g : integer := 32 --! Data signal width.
    );
    port
    (
        a_in        : in  std_logic_vector(data_width_g - 1 downto 0); --! Shifter data input A.
        carry_in    : in  std_logic; --! Shifter carry in.

        function_in : in  std_logic_vector( 3 downto 0); --! Shifter function selector.

        c_out       : buffer std_logic_vector(data_width_g - 1 downto 0); --! Shifter result output C.
        status_out  : buffer std_logic_vector( 4 downto 0) --! Shifter status output.
    );
end entity shifter;

--! @brief Default shifter behavior.
architecture behavioral of shifter is
begin
    -- Set the zero bit when all bits on the output are zero.
    status_out(alu_status.S_ZERO)     <= '1' when unsigned(c_out) = 0 else '0';
    -- Set the sign bit based on output.
    status_out(alu_status.S_SIGN)     <= c_out(data_width_g - 1);
    -- XOR reduce the output to get the even parity bit.
    status_out(alu_status.S_PARITY)   <= xor_reduce(c_out);

    --! @brief Function selection process.
    --! @details Assigns output depending on selected function.
    functions: process(a_in, carry_in, function_in, c_out, status_out)
    begin
        case function_in is
            when shifter_functions.F_ZERO =>
                c_out     <= std_logic_vector(to_unsigned(0, data_width_g));
                
            when shifter_functions.F_PASS =>
                c_out <= a_in;

            when shifter_functions.F_LEFT =>
                c_out(data_width_g - 1 downto 1) <= a_in(data_width_g - 2 downto 0);
                c_out(0) <= '0';

            when shifter_functions.F_RIGHT =>
                c_out(data_width_g - 2 downto 0) <= a_in(data_width_g - 1 downto 1);
                c_out(data_width_g - 1) <= '0';

            when shifter_functions.F_ARITHMETIC_LEFT =>
                c_out(data_width_g - 1) <= a_in(data_width_g - 1);
                c_out(data_width_g - 2 downto 1) <= a_in(data_width_g - 3 downto 0);
                c_out(0) <= '0';

            when shifter_functions.F_ARITHMETIC_RIGHT =>
                c_out(data_width_g - 2 downto 0) <= a_in(data_width_g - 1 downto 1);
                c_out(data_width_g - 1) <= a_in(data_width_g - 1);

            when shifter_functions.F_ROTATE_LEFT =>
                c_out(data_width_g - 1 downto 1) <= a_in(data_width_g - 2 downto 0);
                c_out(0) <= a_in(data_width_g - 1);

            when shifter_functions.F_ROTATE_RIGHT =>
                c_out(data_width_g - 2 downto 0) <= a_in(data_width_g - 1 downto 1);
                c_out(data_width_g - 1) <= a_in(data_width_g - 1);

            when shifter_functions.F_CARRY_ROTATE_LEFT =>
                c_out(data_width_g - 1 downto 1) <= a_in(data_width_g - 2 downto 0);
                c_out(0) <= carry_in;

            when shifter_functions.F_CARRY_ROTATE_RIGHT =>
                c_out(data_width_g - 2 downto 0) <= a_in(data_width_g - 1 downto 1);
                c_out(data_width_g - 1) <= carry_in;

            when others =>
                c_out <= std_logic_vector(to_unsigned(0, data_width_g));

        end case;
    end process functions;

    --! @brief Overflow assignment process.
    --! @details Calculates and assigns the overflow bit depending on selected function and inputs.
    carry_assignment: process(a_in, carry_in, function_in, c_out, status_out)
    begin
        case function_in is
            when shifter_functions.F_LEFT | shifter_functions.F_ARITHMETIC_LEFT =>
                status_out(alu_status.S_CARRY) <= a_in(data_width_g - 1);

            when shifter_functions.F_RIGHT | shifter_functions.F_ARITHMETIC_RIGHT=>
                status_out(alu_status.S_CARRY) <= a_in(0);

            when others =>
                status_out(alu_status.S_CARRY) <= '0';
        end case;
    end process carry_assignment;

    --! @brief Overflow assignment process.
    --! @details Calculates and assigns the overflow bit depending on selected function and inputs.
    overflow_assignment: process(a_in, carry_in, function_in, c_out, status_out)
    begin
        case function_in is
            when shifter_functions.F_LEFT | shifter_functions.F_ARITHMETIC_LEFT =>
                status_out(alu_status.S_OVERFLOW) <= a_in(data_width_g - 1);

            when others =>
                status_out(alu_status.S_OVERFLOW) <= '0';
        end case;
    end process overflow_assignment;
end architecture behavioral;
