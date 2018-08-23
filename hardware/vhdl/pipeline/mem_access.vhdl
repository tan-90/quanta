--! @file
--! @brief Pipeline instruction decode stage.
--! @TODO As this is just a wrapper around a RAM, it should be refactored out.
--! @TODO All signals should be extracted out, and a RAM block used instead.

--! Use standart library.
library ieee;
--! Use logic elements.
use ieee.std_logic_1164.all;
--! Use numeric elements for generic type and vector construction.
use ieee.numeric_std.all;

--! @brief Pipeline instruction memory access stage.
entity memory_access is
    generic
    (
        data_width_g : integer := 32 --! data signal width.
    );
	port
	(
        clock_in               : in  std_logic; --! Clock signal.
        reset_in               : in  std_logic; --! Active high reset signal.
        enable_in              : in  std_logic; --! Active high enable signal.

		we_in                  : in std_logic; --! RAM active high write enable.
		
		result_in              : in  std_logic_vector(31 downto 0); --! Execute stage result output.
		memory_address_in      : in  std_logic_vector(31 downto 0); --! The memory address the current instruciton refers to.
		write_back_address_in  : in  std_logic_vector( 4 downto 0); --! The write back register address.
		
		
		data_out               : out std_logic_vector(31 downto 0); --! Pass through data signal.
		ram_data_out           : out std_logic_vector(31 downto 0); --! RAM read data signal.
		write_back_address_out : out std_logic_vector( 4 downto 0) --! Pass trough write back register address.
		
 	);
end entity memory_access;

--! @brief Default memory access behavior.
architecture behavioral of memory_access is
begin
	data_out <= result_in;
	write_back_address_out <= write_back_address_in;
    
    --! @brief Data RAM.
    --! @details The RAM used by load/store instructions.
	data_ram: entity work.ram(behavioral)
	generic map
	(
		data_width_g    => data_width_g,
		address_width_g => 8,
		init_file_g     => "../vhdl/data/data.mif"
	)
	port map
	(
		clock_in   => clock_in,
		reset_in   => reset_in,
		enable_in  => enable_in,

		address_in => memory_address_in(8 - 1 downto 0),
		data_in    => result_in,
		
		we_in      => we_in,
		
		data_out   => ram_data_out
	);
end architecture behavioral;
