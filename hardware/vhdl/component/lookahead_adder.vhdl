--! @file
--! @brief Generic width carry lookahead adder.

--! Use standart library.
library ieee;
--! Use logic elements.
use ieee.std_logic_1164.all;

--! @brief Generic width carry lookahead adder.
--! @details https://en.wikipedia.org/wiki/Carry-lookahead_adder
entity lookahead_adder is
    generic
    (
        data_width_g : integer := 32 --! Data signal width.
    );
    port
    (
        a_in       : in  std_logic_vector(data_width_g - 1 downto 0); --! Data input a.
        b_in       : in  std_logic_vector(data_width_g - 1 downto 0); --! Data input b.
        carry_in   : in  std_logic; --! Carry input.

        c_out      : out std_logic_vector(data_width_g - 1 downto 0);  --! Data output c.
        carry_out  : out std_logic --! Carry output.
    );
end entity lookahead_adder;

--! @brief Default lookahead adder behavior.
--! @details Improves speed by reducing the time needed to calculate carry bits.
architecture behavioral of lookahead_adder is
    --! @brief The result of the sum ignoring carry.
    signal sum_s : std_logic_vector(data_width_g - 1 downto 0);
    
    --! @brief Carry generators.
    signal carry_generate_s  : std_logic_vector(data_width_g - 1 downto 0);
    --! @brief Carry propagators.
    signal carry_propagate_s : std_logic_vector(data_width_g - 1 downto 0);
    
    --! @brief Calculated carry bits.
    signal carry_s : std_logic_vector(data_width_g - 1 downto 0);
begin
    -- Calculate the sum a + b ignoring carry.
    sum_s <= a_in xor b_in;

    -- Calculate the carry generators.
    carry_generate_s <= a_in and b_in;
    -- Calculate the carry propagators.
    carry_propagate_s <= a_in or b_in;

    --! @brief Carry lookahead process.
    --! @details Calculate each of the carry bits for the sum.
    --! @details Uses carry_in to calculate the first carry bit:
    --! @details $carry_1 = generate_0 or (propagate_0 and carry_in)$
    --! @details Uses each carry bit to calculate the next, up to carry_out:
    --! @details $carry_{i + 1} = generate_i or (propagate_i and carry_i)$
    --! @details Calculates the final sum:
    --! @details $c_0 = sum_0 \oplus carry_in$
    --! @details $c_i = sum_i \oplus carry_i$
    lookahead: process(carry_generate_s, carry_propagate_s,carry_s, carry_in)
    begin
        -- $carry_1 = generate_0 or (propagate_0 and carry_in)$
        carry_s(1) <= carry_generate_s(0) or (carry_propagate_s(0) and carry_in);

        for i in 1 to data_width_g - 2 loop
            -- $carry_{i + 1} = generate_i or (propagate_i and carry_i)$
            carry_s(i + 1) <= carry_generate_s(i) or (carry_propagate_s(i) and carry_s(i));
        end loop;

        -- Calculate carry_out.
        carry_out <= carry_generate_s(data_width_g - 1) or (carry_propagate_s(data_width_g - 1) and carry_s(data_width_g - 1));
    end process lookahead;

    -- Calculate the final sum.
    c_out(0) <= sum_s(0) xor carry_in;
    c_out(data_width_g - 1 downto 1) <= sum_s(data_width_g - 1 downto 1) xor carry_s(data_width_g - 1 downto 1);
end architecture behavioral;
