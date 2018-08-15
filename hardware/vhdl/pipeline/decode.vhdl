--! @file
--! @brief Pipeline instruction decode stage.

--! Use standart library.
library ieee;
--! Use logic elements.
use ieee.std_logic_1164.all;
--! Use numeric elements for generic type and vector construction.
use ieee.numeric_std.all;

--! @brief Pipeline instruction decode stage.
--! @details Decodes a fetched instruction.
entity decode is
	port
	(
        clock_in         : in  std_logic; --! Clock signal.
        reset_in         : in  std_logic; --! Active high reset signal.
        enable_in        : in  std_logic; --! Active high enable signal.

		write_signal_in  : in  std_logic; --! Register file write signal.
		write_address_in : in  std_logic_vector( 4 downto 0); --! Register file write address.
		write_data_in    : in  std_logic_vector(31 downto 0); --! Register file write data input.
		
		instruction_in   : in  std_logic_vector(31 downto 0); --! The instruction to decode.
		
		a_out            : out std_logic_vector(31 downto 0); --! Value of register A pointed by the current instruction.
		b_out            : out std_logic_vector(31 downto 0); --! Value of register B pointed by the current instruction.
		c_out            : out std_logic_vector(31 downto 0); --! Value of register C pointed by the current instruction.
		immediate_out    : out std_logic_vector(31 downto 0); --! Immediate carried by the current instruction.

        opcode_out       : out std_logic_vector( 7 downto 0); --! OPCODE of the current instruction.
		write_back_out   : out std_logic_vector( 4 downto 0); --! Destination register of the current instruction result.
		
		a_address_out    : buffer std_logic_vector( 4 downto 0); --! Address of register A pointed by the current instruction.
		b_address_out    : buffer std_logic_vector( 4 downto 0); --! Address of register C pointed by the current instruction.
		c_address_out    : buffer std_logic_vector( 4 downto 0)  --! Address of register A pointed by the current instruction.
 	);
end entity decode;

--! @brief Default decode behavior.
--! @details Decodes a given instruction and writes data to register file.
--! @details Write to register file is out of sync with main clock to allow read/write in the same cycle.
--! @details Outputs specific bits of instruction word as separate signals for clarity.
--! @details Active high clear and enable signals.
architecture behavioral of decode is
begin
	immediate_out(31 downto 16) <= std_logic_vector(to_unsigned(0, 16));
	immediate_out(15 downto 0)  <= instruction_in(15 downto  0);
	opcode_out                  <= instruction_in(31 downto 24);
	write_back_out              <= instruction_in(23 downto 19);
	
	a_address_out               <= instruction_in(23 downto 19);
	b_address_out               <= instruction_in(18 downto 14);
   c_address_out               <= instruction_in(13 downto  9);
	
   --! @brief Pipeline register file.
	--! @details Accepts data from the decode stage input.
	--! @details Outputs the registers pointed by the current instruction.
    register_file: entity work.register_file(behavioral)
	port map
	(
        clock_in         => clock_in,
        reset_in         => reset_in,
        enable_in        => enable_in,

        write_data_in    => write_data_in,
        write_address_in => write_address_in,
        write_signal_in  => write_signal_in,
        
        address_a_in     => a_address_out,
        address_b_in     => b_address_out,
        address_c_in     => c_address_out,
        
        data_a_out       => a_out,
        data_b_out       => b_out,
        data_c_out       => c_out
	);
end architecture behavioral;