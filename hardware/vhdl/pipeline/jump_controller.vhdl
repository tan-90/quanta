--! @file
--! @brief Processor jump controller.

--! Use standart library.
library ieee;
--! Use logic elements.
use ieee.std_logic_1164.all;
--! Use numeric elements for generic type and vector construction.
use ieee.numeric_std.all;

--! Use ALU status bit definitions.
use work.alu_status;
--! Use OPCODE definitions.
use work.opcodes;

--! @brief Processor jump controller.
--! @details Takes an OPCODE and execution status to output a jump control signal.
--! @details Jump control signal is high when the jump conditions are met.
--! @see alu_status
--! @see opcodes
entity jump_controller is
	port
	(
		opcode_in : in std_logic_vector( 7 downto 0); --! The OPCODE to check for jump conditions.
		status_in : in std_logic_vector( 3 downto 0); --! The status of the executed instruction.
		
		jump_out : out std_logic --! Active high jump signal.
 	);
end entity jump_controller;

--! @brief Default jump controller behavior.
--! @details Generates the corresponding jump signal for the current OPCODE and status.
--! @see alu_status
--! @see opcodes
architecture behavioral of jump_controller is
begin
    --! @brief OPCODE and status process.
	--! @details Sets output jump signal based on given OPCODE and status.
	--! @see alu_status
	--! @see opcodes
    jump_control: process(opcode_in, status_in)
	begin
		case to_integer(unsigned(opcode_in)) is
            when opcodes.OP_JUMP | opcodes.OP_CALL =>
                -- Jump and Call always cause a jump.
				jump_out <= '1';
			
            when opcodes.OP_JUMP_EQUALS =>
                -- Jump equals triggers a jump when the result of the subtraction is zero.
				jump_out <= status_in(alu_status.S_ZERO);
				
			when opcodes.OP_JUMP_NOT_EQUALS =>
                -- Jump not equals triggers a jump when the result of the subtraction is not zero.
				jump_out <= not(status_in(alu_status.S_ZERO));
				
            when opcodes.OP_JUMP_LESSER_THEN =>
                -- Jump lesser then triggers a jump when the result of the subtraction is negative.            
				jump_out <= status_in(alu_status.S_SIGN);
				
            when opcodes.OP_JUMP_GREATER_THEN =>
                -- Jump lesser then triggers a jump when the result of the subtraction is not negative.                        
				jump_out <= not(status_in(alu_status.S_SIGN));
		
            when others =>
                -- Other instructions never trigger jumps.
				jump_out <= '0';
		end case;
	end process jump_control;

end architecture behavioral;