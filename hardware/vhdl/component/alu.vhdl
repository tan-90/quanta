--! @file
--! @brief Generic width ALU.

--! Use standart library.
library ieee;
--! Use logic elements.
use ieee.std_logic_1164.all;
--! Use numeric elements for generic type and vector construction.
use ieee.numeric_std.all;
--! Use misc logic to replace unary operators for VHDL 2002 compatibility.
use ieee.std_logic_misc.all;

--! Use the function code definitions.
use work.alu_functions;
--! Use the status indices definitions.
use work.alu_status;

--! @brief Generic width ALU.
--! @details Generic width ALU with 4 bit fuction selector and 5 bit status output.
--! @details Functions:
--! |Code  |Function|
--! |:-----|:-------|
--! |`x0`  |Zero    |
--! |`x1`  |Add     |
--! |`x2`  |Subtract|
--! |`x3`  |Pass A  |
--! |`x4`  |NOT     |
--! |`x5`  |AND     |
--! |`x6`  |OR      |
--! |`x7`  |XOR     |
--! |`x8`  |XOR     |
--! |`x9`  |Pass B  |
--! |`xA`  |NOOP    |
--! |`xB`  |NOOP    |
--! |`xC`  |NOOP    |
--! |`xD`  |NOOP    |
--! |`xE`  |NOOP    |
--! |`xF`  |NOOP    |
--! @details Status:
--! |Index|Value   |
--! |:----|:-------|
--! |`0`  |Zero    |
--! |`1`  |Sign    |
--! |`2`  |Carry   |
--! |`3`  |Parity  |
--! |`4`  |Overflow|
--! @see alu_functions
--! @see alu_status
entity alu is
    generic
    (
        data_width_g : integer := 32 --! Data signal width.
    );
    port
    (
        a_in        : in  std_logic_vector(data_width_g - 1 downto 0); --! ALU data input A.
        b_in        : in  std_logic_vector(data_width_g - 1 downto 0); --! ALU data input B.
        carry_in    : in  std_logic; --! ALU carry in.

        function_in : in  std_logic_vector( 3 downto 0); --! ALU function selector.

        c_out       : buffer std_logic_vector(data_width_g - 1 downto 0); --! ALU result output C.
        status_out  : buffer std_logic_vector( 4 downto 0) --! ALU status output.
    );
end entity alu;

--! @brief Default ALU behavior.
architecture behavioral of alu is
    --! @brief Temporarily holds the adder result.
    signal adder_s : std_logic_vector(data_width_g - 1 downto 0);
    --! @brief Temporarily holds the adder carry bit.
    signal adder_carry_s : std_logic;

    --! @brief Temporarily holds the subtractor result.
    signal subtractor_s : std_logic_vector(data_width_g - 1 downto 0);
    --! @brief Temporarily holds the subtractor borrow bit.
    signal subtractor_carry_s : std_logic;
begin
    --! @brief The ALU adder.
    --! @see lookahead_adder
    adder: entity work.lookahead_adder(behavioral)
    generic map
    (
        data_width_g => data_width_g
    )
    port map
    (
        a_in      => a_in,
        b_in      => b_in,
        carry_in  => carry_in,
        c_out     => adder_s,
        carry_out => adder_carry_s
    );

    --! @brief The ALU subtractor.
    --! @details Two's complement subtraction using adder.
    --! @see https://en.wikipedia.org/wiki/Adder-subtractor
    --! @see https://en.wikipedia.org/wiki/Two%27s_complement
    --! @see lookahead_adder
    subtractor: entity work.lookahead_adder(behavioral)
    generic map
    (
        data_width_g => data_width_g
    )
    port map
    (
        a_in      => a_in,
        b_in      => std_logic_vector(-signed(b_in)),
        carry_in  => carry_in,
        c_out     => subtractor_s,
        carry_out => subtractor_carry_s
    );

    -- Set the zero bit when all bits on the output are zero.
    status_out(alu_status.S_ZERO)     <= '1' when unsigned(c_out) = 0 else '0';
    -- Set the sign bit based on output.
    status_out(alu_status.S_SIGN)     <= c_out(data_width_g - 1);
    -- XOR reduce the output to get the even parity bit.
    status_out(alu_status.S_PARITY)   <= xor_reduce(c_out);

    --! @brief Function selection process.
    --! @details Assigns output depending on selected function.
    functions: process(a_in, b_in, carry_in, function_in, c_out, status_out, adder_s, adder_carry_s, subtractor_s, subtractor_carry_s)
    begin
        case function_in is
            when alu_functions.F_ZERO =>
                c_out <= std_logic_vector(to_unsigned(0, data_width_g));

            when alu_functions.F_ADD =>
                c_out <= adder_s;

            when alu_functions.F_SUBTRACT =>
                c_out <= subtractor_s;

            when alu_functions.F_PASS_A =>
                c_out <= a_in;

            when alu_functions.F_NOT =>
                c_out <= not(a_in);

            when alu_functions.F_AND =>
                c_out <= a_in and b_in;

            when alu_functions.F_OR =>
                c_out <= a_in or b_in;

            when alu_functions.F_XOR =>
                c_out <= a_in xor b_in;

            when alu_functions.F_XNOR =>
                c_out <= a_in xnor b_in;

            when alu_functions.F_PASS_B =>
                c_out <= b_in;

            when others =>
                -- When a NOOP function is selected, set everything to 0.
                -- NOOP functions shouldn't be used.
                c_out <= std_logic_vector(to_unsigned(0, data_width_g));

        end case;
    end process functions;

    --! @brief Carry out assignment process.
    --! @details Calculates and assigns the carry bit depending on selected function and inputs.
    carry_assignment: process(a_in, b_in, carry_in, function_in, c_out, status_out, adder_s, adder_carry_s, subtractor_s, subtractor_carry_s)
    begin
        case function_in is
            when alu_functions.F_ADD =>
                status_out(alu_status.S_CARRY) <= adder_carry_s;

            when alu_functions.F_SUBTRACT =>
                status_out(alu_status.S_CARRY) <= subtractor_carry_s;

            when others =>
                status_out(alu_status.S_CARRY) <= '0';
        end case;
    end process carry_assignment;

    --! @brief Overflow assignment process.
    --! @details Calculates and assigns the overflow bit depending on selected function and inputs.
    overflow_assignment: process(a_in, b_in, carry_in, function_in, c_out, status_out, adder_s, adder_carry_s, subtractor_s, subtractor_carry_s)
    begin
        case function_in is
            when alu_functions.F_ADD =>
                status_out(alu_status.S_OVERFLOW) <= adder_carry_s;

            when alu_functions.F_SUBTRACT =>
                -- Overflow occurs when the two operants have the same sign, that is different from the result.
                status_out(alu_status.S_OVERFLOW) <= (a_in(data_width_g - 1) xnor b_in(data_width_g - 1)) and (b_in(data_width_g - 1) xor c_out(data_width_g - 1));

            when others =>
                status_out(alu_status.S_OVERFLOW) <= '0';
        end case;
    end process overflow_assignment;

end architecture behavioral;
