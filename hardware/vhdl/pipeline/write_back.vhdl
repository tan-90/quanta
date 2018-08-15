--! @file
--! @brief Pipeline instruction fetch stage.

--! Use standart library.
library ieee;
--! Use logic elements.
use ieee.std_logic_1164.all;
--! Use numeric elements for generic type and vector construction.
use ieee.numeric_std.all;

entity write_back is
	port
	(
		ram_data_select_in : in  std_logic;
		call_instruction_in : in std_logic;
	
		data_in : in  std_logic_vector(31 downto 0);
		ram_data_in : in  std_logic_vector(31 downto 0);
		pc_in : in std_logic_vector(31 downto 0);
		
		write_back_data_out: out std_logic_vector(31 downto 0)
 	);
end entity write_back;

architecture behavioral of write_back is
    signal s_data_out : std_logic_vector(31 downto 0);
begin
    s_data_out <= ram_data_in when ram_data_select_in = '1' else data_in;
    write_back_data_out <= pc_in when call_instruction_in = '1' else s_data_out;
end architecture behavioral;
