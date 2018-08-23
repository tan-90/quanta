--! @file
--! @brief Processor jump controller.

--! Use standart library.
library ieee;
--! Use logic elements.
use ieee.std_logic_1164.all;
--! Use numeric elements for generic type and vector construction.
use ieee.numeric_std.all;
--! Use misc logic to replace unary operators for VHDL 2002 compatibility.
use ieee.std_logic_misc.all;

--! @brief Hazard detection unit.
--! @details Checks for hazards that cannot be solved by forwarding.
--! @details Signals the need for a pipeline stall.
entity hazard_detection is
	port
	(
		decoded_a_in          : in  std_logic_vector( 4 downto 0); --! The address of register A for the current decoded instruction.
		decoded_b_in          : in  std_logic_vector( 4 downto 0); --! The address of register B for the current decoded instruction.
		decoded_c_in          : in  std_logic_vector( 4 downto 0); --! The address of register C for the current decoded instruction.
	
		execute_ram_select_in : in  std_logic; --! Signals if the currently executing instruction uses data from RAM.
		execute_write_addr_in : in  std_logic_vector( 4 downto 0); --! Signals if the currently executing instruction writes to the register file.

        stall_out             : out std_logic --! Signals the need for a pipeline stall.
 	);
end entity hazard_detection;

--! @brief Default hazard detection unit behavior.
--! @details Signals a stall if a hazard is detected.
architecture behavioral of hazard_detection is
    --! @brief Check if any of the register addresses for the current instruction will be written by the execute stage.
	signal s_address_dirty : std_logic;
begin
    -- Compare the address of each register with the one that will be written by the execute stage.
    s_address_dirty <= and_reduce(execute_write_addr_in xnor decoded_a_in) or and_reduce(execute_write_addr_in xnor decoded_b_in) or and_reduce(execute_write_addr_in xnor decoded_c_in);
    
    -- Signal a stall if RAM data will be written to any of the registers.
	stall_out <= execute_ram_select_in and s_address_dirty;
end architecture behavioral;