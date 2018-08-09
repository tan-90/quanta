--! @file
--! @brief Pipeline instruction fetch stage.

--! Use standart library.
library ieee;
--! Use logic elements.
use ieee.std_logic_1164.all;
--! Use numeric elements for generic type and vector construction.
use ieee.numeric_std.all;


--! @brief Pipeline instruction fetch stage.
--! @details Fetches data at program counter on rising edge.
entity fetch is
    generic
    (
        data_width_g : integer := 32 --! data signal width.
    );
	port
	(
		clock_in         : in  std_logic; --! Clock signal.
        reset_in         : in  std_logic; --! Active high reset signal.
        enable_in        : in  std_logic; --! Active high enable signal.

		stall_in         : in  std_logic; --! Stall signal prevents writing to program counter.
		jump_in          : in  std_logic; --! Jump signal controls wringing jump address to program counter.
		flush_in         : in  std_logic; --! Flush signal clears RAM output (fetched instruction).
		
		jump_address_in  : in  std_logic_vector(31 downto 0); --! Jump address from currently executing instruciton.
		
		instruction_out  : out std_logic_vector(31 downto 0); --! Fetched instruction.
		address_out      : out std_logic_vector(31 downto 0)  --! The current value of the program counter.
 	);
end entity fetch;

--! @brief Default fetch behavior.
--! @details Fetches instruction from memory at program counter address on rising edge.
--! @details Increments program counter on each fetch, or sets it to jump address.
--! @details Active high clear and enable signals.
architecture behavioral of fetch is
    --! @brief The current value of the program counter.
    signal pc_value_s : std_logic_vector(31 downto 0);
	--! @brief The next value of the program counter.
	--! @details needed for selecting jump address or increented program counter as program counter source.
	signal pc_next_s : std_logic_vector(31 downto 0);
    
    --! @brief The program counter incrementer output.
    signal incrementer_value_s : std_logic_vector(31 downto 0);
begin
	address_out <= pc_value_s;
	pc_next_s   <= jump_address_in when jump_in = '1' else incrementer_value_s;

	--! @brief Program counter register.
	--! @details Holds the memory address for the next instruction to be fetched.
	--! @details Incremented after every fetch, except on jumps, when it's set to the jump address.
	--! @details Writing can be prevented by signaling a stall with stall_in.
    pc: entity work.parallel_register(behavioral)
    generic map
    (
        data_width_g => data_width_g
    )
	port map 
	(
        clock_in  => clock_in,
        reset_in  => reset_in,
        enable_in => enable_in and not(stall_in),

        data_in   => pc_next_s,
        data_out  => pc_value_s
	);
	
	--! @brief Program counter incrementer adder.
	--! @details Increments the current program counter value.
	pc_incrementer: entity work.lookahead_adder(behavioral)
	port map
	(
        a_in       => pc_value_s,
        b_in       => std_logic_vector(to_unsigned(1, data_width_g)),
        carry_in   => '0',
		
		c_out      => incrementer_value_s,
		carry_out  => open
	);

	--! @brief Instruction RAM.
	--! @details Holds the sequential list of instructions to be executed.
	--! @details Output can be set to zero for flushing the fetched instruction with flush_in.
	instruction_ram: entity work.ram(behavioral)
	generic map
	(
		data_width_g    => data_width_g,
		address_width_g => 8,
		init_file_g     => "../vhdl/data/inst.mif"
	)
	port map
	(
		clock_in   => clock_in,
		reset_in   => reset_in or flush_in,
		enable_in  => enable_in and not(stall_in),

		address_in => pc_value_s(8 - 1 downto 0),
		data_in    => std_logic_vector(to_unsigned(0, data_width_g)),
		
		we_in      => '0',
		
		data_out   => instruction_out
	);
end architecture behavioral;
