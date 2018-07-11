--! @file
--! @brief Generic width parallel in/out register.

--! Use standart library.
library ieee;
--! Use logic elements.
use ieee.std_logic_1164.all;
--! Use numeric elements for generic type and vector construction.
use ieee.numeric_std.all;

--! @brief Generic width parallel in/out register.
--! @details Generic width parallel in/out register with reset and enable signals.
entity parallel_register is
    generic
    (
        data_width_g : integer := 32 --! Data signal width.
    );
    port
    (
        clock_in  : in  std_logic; --! Clock signal.
        reset_in  : in  std_logic; --! Active high reset signal.
        enable_in : in  std_logic; --! Active high enable signal.

        data_in   : in  std_logic_vector(data_width_g - 1 downto 0); --! Data input.
        data_out  : out std_logic_vector(data_width_g - 1 downto 0)  --! Data output.
    );
end entity parallel_register;

--! @brief Default parallel register behavior.
--! @details Rising edge triggered generic width register.
--! @details Active high clear and enable signals.
architecture behavioral of parallel_register is
begin
    --! @brief Clock, reset and enable process.
    --! @details Clear the output if reset is high.
    --! @details Sets output to input value at clock edge if enabled is high.
    read_write: process(clock_in, reset_in, enable_in)
    begin
        if reset_in = '1' then
            data_out <= std_logic_vector(to_unsigned(0, data_width_g));
        elsif enable_in = '1' and rising_edge(clock_in) then
            data_out <= data_in;
        end if;
    end process read_write;
end architecture behavioral;
