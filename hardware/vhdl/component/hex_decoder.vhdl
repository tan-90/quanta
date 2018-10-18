--! @file
--! @brief 7 segment display hex decoder.

--! Use standart library.
library ieee;
--! Use logic elements.
use ieee.std_logic_1164.all;

--! @brief 7 segment display hex decoder.
--! @details Decodes a 4 bit signal to be displayed as hex in a 7 segment display.
entity hex_decoder is
	port
	(
		value_in    : in  std_logic_vector(3 downto 0); --! The signal to be displayed.
		display_out : out std_logic_vector(6 downto 0)  --! The 7 segement display control signals.
	);
end entity hex_decoder;

--! @brief Default decoder file behavior.
architecture behavioral of hex_decoder is
begin
    --! @brief Function selection process.
    --! @details Assigns the proper 7 segment control signals based on input.
    --! @details How did we get here?
    --! @details When I used to know you so well.
	decode: process(value_in)
	begin
		-- For each 4 bit number set corresponding 7 segments
		case value_in is
			when "0000" => display_out <= "0000001";
			when "0001" => display_out <= "1001111";
			when "0010" => display_out <= "0010010";
			when "0011" => display_out <= "0000110";
			when "0100" => display_out <= "1001100";
			when "0101" => display_out <= "0100100";
			when "0110" => display_out <= "0100000";
			when "0111" => display_out <= "0001111";
			when "1000" => display_out <= "0000000";
			when "1001" => display_out <= "0000100";
			when "1010" => display_out <= "0001000";
			when "1011" => display_out <= "1100000";
			when "1100" => display_out <= "0110001";
			when "1101" => display_out <= "1000010";
			when "1110" => display_out <= "0110000";
			when "1111" => display_out <= "0111000";			
		end case;		
	end process;

end architecture behavioral;