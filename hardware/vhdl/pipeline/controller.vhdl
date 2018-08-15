--! @file
--! @brief Processor controller.

--! Use standart library.
library ieee;
--! Use logic elements.
use ieee.std_logic_1164.all;
--! Use numeric elements for generic type and vector construction.
use ieee.numeric_std.all;

--! Use ALU function code definitions.
use work.alu_functions;
--! Use Shifter function code definitions.
use work.shifter_functions;
--! Use OPCODE definitions.
use work.opcodes;

--! @brief Processor controller.
--! @details Implements the quanta ISA.
--! @details Takes an OPCODE outputs all corresponding control signals.
--! @see alu_functions
--! @see shifter_functions
--! @see opcodes
entity controller is
	port
	(
		opcode_in            : in  std_logic_vector( 7 downto 0); --! The OPCODE to output control signals for.
		
		alu_select_out       : out std_logic; --! Selects between ALU and Shifter for execution.
		function_out         : out std_logic_vector( 3 downto 0); --! The function for the ALU/Shifter.
		
		we_out               : out std_logic; --! Enables writing result of instruction to RAM.
		ram_data_out         : out std_logic; --! Selects between instruction result or RAM output.
		immediate_select_out : out std_logic; --! Overrides the B input with the lower 16 bits of the instruction word.
		register_write_out   : out std_logic  --! Enables writing result of instruction to register addressed by A.
	);
end entity controller;

--! @brief Default controller behavior.
--! @details Generates the corresponding output signals for any given OPCODE.
--! @see alu_functions
--! @see shifter_functions
--! @see opcodes
architecture behavioral of controller is
begin
	--! @brief OPCODE process.
	--! @details Sets output signals based on give OPCODE.
	--! @see alu_functions
	--! @see shifter_functions
	--! @see opcodes
	control: process(opcode_in)
	begin
		case to_integer(unsigned(opcode_in)) is
			when opcodes.OP_NOOP =>
                alu_select_out       <= '0';
                function_out         <= alu_functions.F_ZERO;
                
                we_out               <= '0';
                ram_data_out         <= '0';
                immediate_select_out <= '0';
                register_write_out   <= '0';

			when opcodes.OP_LOAD_IMMEDIATE =>
                alu_select_out       <= '1';
                function_out         <= alu_functions.F_PASS_B;
                
                we_out               <= '0';
                ram_data_out         <= '0';
                immediate_select_out <= '1';
                register_write_out   <= '1';
				
			when opcodes.OP_MOVE =>
                alu_select_out       <= '1';
                function_out         <= alu_functions.F_PASS_B;
                
                we_out               <= '0';
                ram_data_out         <= '0';
                immediate_select_out <= '0';
                register_write_out   <= '1';
				
            when opcodes.OP_LOAD =>
                alu_select_out       <= '0';
                function_out         <= alu_functions.F_ZERO;
                
                we_out               <= '0';
                ram_data_out         <= '1';
                immediate_select_out <= '0';
                register_write_out   <= '1';
				
			when opcodes.OP_STORE =>
                alu_select_out       <= '1';
                function_out         <= alu_functions.F_PASS_A;
                
                we_out               <= '1';
                ram_data_out         <= '0';
                immediate_select_out <= '0';
                register_write_out   <= '0';

			when opcodes.OP_ADD =>
                alu_select_out       <= '1';
                function_out         <= alu_functions.F_ADD;
                
                we_out               <= '0';
                ram_data_out         <= '0';
                immediate_select_out <= '0';
                register_write_out   <= '1';
                
			when opcodes.OP_SUBTRACT =>
                alu_select_out       <= '1';
                function_out         <= alu_functions.F_SUBTRACT;
                
                we_out               <= '0';
                ram_data_out         <= '0';
                immediate_select_out <= '0';
                register_write_out   <= '1';
				
			when opcodes.OP_AND =>
                alu_select_out       <= '1';
                function_out         <= alu_functions.F_AND;
                
                we_out               <= '0';
                ram_data_out         <= '0';
                immediate_select_out <= '0';
                register_write_out   <= '1';

			when opcodes.OP_OR =>
                alu_select_out       <= '1';
                function_out         <= alu_functions.F_OR;
                
                we_out               <= '0';
                ram_data_out         <= '0';
                immediate_select_out <= '0';
                register_write_out   <= '1';
                
			when opcodes.OP_XOR =>
                alu_select_out       <= '1';
                function_out         <= alu_functions.F_XOR;
                
                we_out               <= '0';
                ram_data_out         <= '0';
                immediate_select_out <= '0';
                register_write_out   <= '1';
				
			when opcodes.OP_XNOR =>
                alu_select_out       <= '1';
                function_out         <= alu_functions.F_XNOR;
                
                we_out               <= '0';
                ram_data_out         <= '0';
                immediate_select_out <= '0';
                register_write_out   <= '1';
                
			when opcodes.OP_NOT =>
                alu_select_out       <= '1';
                function_out         <= alu_functions.F_NOT;
                
                we_out               <= '0';
                ram_data_out         <= '0';
                immediate_select_out <= '0';
                register_write_out   <= '1';
				
			when opcodes.OP_SHIFT_LEFT =>
                alu_select_out       <= '0';
                function_out         <= shifter_functions.F_LEFT;
                
                we_out               <= '0';
                ram_data_out         <= '0';
                immediate_select_out <= '0';
				register_write_out   <= '1';
				
			when opcodes.OP_SHIFT_RIGHT =>
                alu_select_out       <= '0';
                function_out         <= shifter_functions.F_RIGHT;
                
                we_out               <= '0';
                ram_data_out         <= '0';
                immediate_select_out <= '0';
				register_write_out   <= '1';
				
				register_write_out <= '1';

			when opcodes.OP_ARITHMETIC_SHIFT_LEFT =>
                alu_select_out       <= '0';
                function_out         <= shifter_functions.F_ARITHMETIC_LEFT;
                
                we_out               <= '0';
                ram_data_out         <= '0';
                immediate_select_out <= '0';
				register_write_out   <= '1';
				
			when opcodes.OP_ARITHMETIC_SHIFT_RIGHT =>
                alu_select_out       <= '0';
                function_out         <= shifter_functions.F_ARITHMETIC_RIGHT;
                
                we_out               <= '0';
                ram_data_out         <= '0';
                immediate_select_out <= '0';
				register_write_out   <= '1';

			when opcodes.OP_ROTATE_LEFT =>
                alu_select_out       <= '0';
                function_out         <= shifter_functions.F_ROTATE_LEFT;
                
                we_out               <= '0';
                ram_data_out         <= '0';
                immediate_select_out <= '0';
				register_write_out   <= '1';

			when opcodes.OP_ROTATE_RIGHT =>
                alu_select_out       <= '0';
                function_out         <= shifter_functions.F_ROTATE_RIGHT;
                
                we_out               <= '0';
                ram_data_out         <= '0';
                immediate_select_out <= '0';
				register_write_out   <= '1';
			
			when opcodes.OP_JUMP =>
		        alu_select_out       <= '0';
                function_out         <= alu_functions.F_ZERO;
                
                we_out               <= '0';
                ram_data_out         <= '0';
                immediate_select_out <= '0';
				register_write_out   <= '0';
				
			when opcodes.OP_JUMP_EQUALS =>
		        alu_select_out       <= '1';
                function_out         <= alu_functions.F_SUBTRACT;
                
                we_out               <= '0';
                ram_data_out         <= '0';
                immediate_select_out <= '0';
				register_write_out   <= '0';

			when opcodes.OP_JUMP_NOT_EQUALS =>
		        alu_select_out       <= '1';
                function_out         <= alu_functions.F_SUBTRACT;
                
                we_out               <= '0';
                ram_data_out         <= '0';
                immediate_select_out <= '0';
				register_write_out   <= '0';
				
			when opcodes.OP_JUMP_LESSER_THEN =>
		        alu_select_out       <= '1';
                function_out         <= alu_functions.F_SUBTRACT;
                
                we_out               <= '0';
                ram_data_out         <= '0';
                immediate_select_out <= '0';
				register_write_out   <= '0';
					
			when opcodes.OP_JUMP_GREATER_THEN =>
		        alu_select_out       <= '1';
                function_out         <= alu_functions.F_SUBTRACT;
                
                we_out               <= '0';
                ram_data_out         <= '0';
                immediate_select_out <= '0';
				register_write_out   <= '0';
					
			when opcodes.OP_CALL =>
		        alu_select_out       <= '0';
                function_out         <= alu_functions.F_ZERO;
                
                we_out               <= '0';
                ram_data_out         <= '0';
                immediate_select_out <= '0';
				register_write_out   <= '1';
			
			-- Invalid OPCODEs result in transparent control signals.
			-- While the assembler should prevent invalid opcodes, it needs to be set to avoid latches.
			-- quanta has no support for exceptions.
			when others =>
				alu_select_out       <= '0';
                function_out         <= alu_functions.F_ZERO;
                
                we_out               <= '0';
                ram_data_out         <= '0';
                immediate_select_out <= '0';
				register_write_out   <= '0';

		end case;
	end process control;
end architecture behavioral;
