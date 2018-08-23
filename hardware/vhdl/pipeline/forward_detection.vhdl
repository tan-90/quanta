--! @file
--! @brief Processor forward detector.

--! Use standart library.
library ieee;
--! Use logic elements.
use ieee.std_logic_1164.all;
--! Use numeric elements for generic type and vector construction.
use ieee.numeric_std.all;
--! Use misc logic to replace unary operators for VHDL 2002 compatibility.
use ieee.std_logic_misc.all;

--! Use OPCODE definitions.
use work.opcodes;

--! @brief Data forwarding detection.
--! @details Detects data hazards that can be solved by forwarding.
--! @details The low bit of the output signals forwarding is needed.
--! @details The high bit of the output controls where to forward data from. A high bit means forwarding from memory, a low bit means forwarding from write back.
--! @see opcodes
entity forward_detection is
	port
	(
        register_address_in  : in  std_logic_vector( 4 downto 0); --! The address of the register to check for hazards.
		write_address_mem_in : in  std_logic_vector( 4 downto 0); --! The write address of the instruction currently in the memory stage.
		write_address_wb_in  : in  std_logic_vector( 4 downto 0); --! The write address of the instruction currently in the write back stage.
		
		write_signal_mem_in  : in  std_logic; --! The signal that controls if the result of the instruction in the memory stage will be written.
		write_signal_wb_in   : in  std_logic; --! The signal that controls if the result of the instruction in the write back stage will be written.
		
		forward_out          : out std_logic_vector( 1 downto 0) --! Signals if data should be forwarded, and from where.
 	);
end entity forward_detection;

--! @brief Default forward detection behavior.
--! @details Outputs information about forwarding data and the forward source.
architecture behavioral of forward_detection is
	--! @brief Checks if the given register address is the same as the one affected by the instruction in the memory stage.
	signal address_dirty_mem_s : std_logic;
	--! @brief Checks if the given register address is the same as the one affected by the instruction in the write back stage.
	signal address_dirty_wb_s : std_logic;
	
	--! @brief Signals that data should be forwarded.
	signal should_forward_s : std_logic;
    --! @brief Signals if data should be forwarded from the memory stage (if not set, data should be forwarded from the write back stage).
	signal forward_mem_s : std_logic;
begin
	-- Check if the address of the current register is the same as the one that will be written by the memory stage.
	address_dirty_mem_s <= and_reduce(register_address_in xnor write_address_mem_in);
	-- Check if the address of the current register is the same as the one that will be written by the write back stage.
	address_dirty_wb_s  <= and_reduce(register_address_in xnor write_address_wb_in);
	
	-- Check if the current register will be written by the instruction in the memory or write back stages.
	should_forward_s    <= (address_dirty_mem_s and write_signal_mem_in) or (address_dirty_wb_s and write_signal_wb_in);
	-- Check if data should be forwarded from the memory stage (as it would override the data from the write back stage, it takes priority).
	forward_mem_s       <= address_dirty_mem_s and write_signal_mem_in;
	
	-- Assign output forward signal.
	forward_out(0)      <= should_forward_s;
	-- Assign forward source signal.
	forward_out(1)      <= forward_mem_s;
end architecture behavioral;