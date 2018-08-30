--! @file
--! @brief quanta's generic width 32 register register file.

--! use standart library.
library ieee;
--! use logic elements.
use ieee.std_logic_1164.all;
--! use unsigned logic for converting logic vectors to integers.
use ieee.std_logic_unsigned.all;
--! use numeric elements for address derreferencing.
use ieee.numeric_std.all;

--! @brief quanta's generic width parallel in/out register file.
--! @details Designed to be used exclusively for quanta, as some registers are hard wired to defaults.
--! @details Writes input data to the register at the given address on falling edge.
--! @details Only one register is written at any give time.
--! @details Write on falling edge ensures no data hazards occur when trying to read and write at the same cycle.
--! @details Triple output allows to take addresses from instruction decoder and output all values at the same time.
--! @details Reset signal is applied to all registers, except those that override it.
--! @details Following quanta's design choices, some registers are hard wired to default values.
--! @details Hard wired registers will sometimes override default behavior.
--! @details Default registers:
--! |Register  |Value                 |Behavior                                                  |
--! |:---------|:---------------------|:---------------------------------------------------------|
--! |`0`       |Hard wired zero.      |Constant register data input. Ignores write instructions. |
--! |`16`      |Inspect signal leds.  |Wired to the inspect output signals.                      |
--! |`17`      |Inspect signal hex0.  |Wired to the inspect output signals.                      |
--! |`18`      |Inspect signal hex1.  |Wired to the inspect output signals.                      |
--! |`19`      |Inspect signal hex2.  |Wired to the inspect output signals.                      |
--! |`12`      |Inspect signal in.    |Register value is replaced by inspect signal in.          |
entity register_file is
    generic
    (
        data_width_g : integer := 32 --! Data signal width.
    );
    port
    (
        clock_in         : in  std_logic; --! Clock signal.
        reset_in         : in  std_logic; --! Active high reset signal.
        enable_in        : in  std_logic; --! Active high enable signal.
		
		write_data_in    : in  std_logic_vector(data_width_g - 1 downto 0); --! Input data.
		write_address_in : in  std_logic_vector( 4 downto 0); --! Write address.
		write_signal_in  : in  std_logic; --! Write signal.
		
		address_a_in     : in  std_logic_vector( 4 downto 0); --! Read address a.
		address_b_in     : in  std_logic_vector( 4 downto 0); --! Read address b.
		address_c_in     : in  std_logic_vector( 4 downto 0); --! Read address c.

		inspect_in : in std_logic_vector(31 downto 0); --! Debug IO system. Conected to a register to work as input.

		data_a_out       : out std_logic_vector(data_width_g - 1 downto 0); --! Output data a.
		data_b_out       : out std_logic_vector(data_width_g - 1 downto 0); --! Output data b.
		data_c_out       : out std_logic_vector(data_width_g - 1 downto 0); --! Output data c.
        
        inspect_0_out    : out std_logic_vector(31 downto 0); --! Debug IO system. Conected to a resgister to work as output.
		inspect_1_out    : out std_logic_vector(31 downto 0); --! Debug IO system. Conected to a resgister to work as output.
		inspect_2_out    : out std_logic_vector(31 downto 0); --! Debug IO system. Conected to a resgister to work as output.
		inspect_3_out    : out std_logic_vector(31 downto 0)  --! Debug IO system. Conected to a resgister to work as output.
    );
end entity register_file;

--! @brief Default register file behavior.
--! @details Rising edge triggered generic width register file.
--! @details Active high clear and enable signals.
architecture behavioral of register_file is
    --! @brief Data word type.
    subtype word is std_logic_vector(data_width_g - 1 downto 0);
    --! @brief Variable range data word array.
    type word_array is array(natural range<>) of word;
    
    --! @brief The number of registers in the file.
    constant REGISTER_FILE_DEPTH : INTEGER := 32;

    --! @brief Register file data.
    --! @details Holds the current output of each register.
    signal register_file_s : word_array(REGISTER_FILE_DEPTH - 1 downto 0);
    --! @brief Bit decoded write address.
    --! @details Sets the n-th bit when register n is to be written to.
    --! @details Implementation ensures only one register is written at a time.
    signal decoded_address_s : std_logic_vector(REGISTER_FILE_DEPTH - 1 downto 0);
    
begin
    --! @brief Address decoder process.
    --! @details Clear the decoded address vector and writes a 1 to the address that will be written.
	address_decode: process(write_address_in)
	begin
		decoded_address_s <= std_logic_vector(to_unsigned(0, decoded_address_s'length));
		decoded_address_s(to_integer(unsigned(write_address_in))) <= '1';
	end process address_decode;
    
    --! @brief Register 0 as default zero.
    --! @details Register input tied to a constant zero.
    default_zero: entity work.parallel_register(behavioral)
    generic map
    (
        data_width_g => data_width_g
    )
    port map
    (
        clock_in  => not(clock_in),
        reset_in  => reset_in,
        enable_in => enable_in and write_signal_in and decoded_address_s(0),
        data_in   => write_data_in,
        data_out  => register_file_s(0)
    );

    --! @brief Register file generator.
    --! @details Generates common registers.
    registers_0: for i in 1 to 19 generate
	begin
		current_register: entity work.parallel_register(behavioral)
        generic map
        (
            data_width_g => data_width_g
        )
        port map
        (
            clock_in  => not(clock_in),
            reset_in  => reset_in,
            enable_in => enable_in and write_signal_in and decoded_address_s(i),
            data_in   => write_data_in,
            data_out  => register_file_s(i)
        );
	end generate registers_0;
    
    register_file_s(20) <= inspect_in;

    --! @brief Register file generator.
    --! @details Generates common registers.
    registers_1: for i in 21 to register_file_depth - 1 generate
	begin
		current_register: entity work.parallel_register(behavioral)
        generic map
        (
            data_width_g => data_width_g
        )
        port map
        (
            clock_in  => not(clock_in),
            reset_in  => reset_in,
            enable_in => enable_in and write_signal_in and decoded_address_s(i),
            data_in   => write_data_in,
            data_out  => register_file_s(i)
        );
    end generate registers_1;
    
    inspect_0_out <= register_file_s(16);
    inspect_1_out <= register_file_s(17);
    inspect_2_out <= register_file_s(18);
    inspect_3_out <= register_file_s(19);

    data_a_out    <= register_file_s(to_integer(unsigned(address_a_in)));
    data_b_out    <= register_file_s(to_integer(unsigned(address_b_in)));
    data_c_out    <= register_file_s(to_integer(unsigned(address_c_in)));
end architecture behavioral;
