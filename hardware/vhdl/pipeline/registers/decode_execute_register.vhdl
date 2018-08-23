--! @file
--! @brief Decode/Execute pipeline register block.
--! @details As VHDL 2002 does not support generic types, each resgister block needs it's own entity and architecture.

--! Use standart library.
library ieee;
--! Use logic elements.
use ieee.std_logic_1164.all;
--! Use numeric elements for generic type and vector construction.
use ieee.numeric_std.all;

--! Use pipeline register block record definitions.
use work.pipeline_records;

--! @brief Decode/Execute register block.
entity decode_execute_register is
    port
    (
        clock_in  : in  std_logic; --! Clock signal.
        reset_in  : in  std_logic; --! Active high reset signal.
        enable_in : in  std_logic; --! Active high enable signal.

        data_in   : in  pipeline_records.decode_execute; --! Data input.
        data_out  : out pipeline_records.decode_execute  --! Data output.
    );
end entity decode_execute_register;

--! @brief Default Decode/Execute register behavior.
--! @details Rising edge triggered register.
--! @details Active high clear and enable signals.
architecture behavioral of decode_execute_register is
begin
    --! @brief Clock, reset and enable process.
    --! @details Clear the output if reset is high.
    --! @details Sets output to input value at clock edge if enabled is high.
    read_write: process(clock_in, reset_in, enable_in)
    begin
        if reset_in = '1' then
            data_out <= pipeline_records.ZERO_DECODE_EXECUTE;
        elsif enable_in = '1' and rising_edge(clock_in) then
            data_out <= data_in;
        end if;
    end process read_write;
end architecture behavioral;
