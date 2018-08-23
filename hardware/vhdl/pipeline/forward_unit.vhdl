--! @file
--! @brief Processor forward unit.

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

--! @brief Data forwarding unit.
--! @details Uses forward detectors to output forwarding data for registers A, B and C.
--! @details Only signals forwarding if required by current instruction.
--! @see opcodes
entity forward_unit is
	port
	(
		in_write_signal_mem  : in  std_logic; --! The write signal of the memory stage.
		in_write_signal_wb   : in  std_logic; --! The write signal of the write back stage.
		
		in_write_address_mem : in  std_logic_vector( 4 downto 0); --! The address the instruction in the memory stage writes to.
		in_write_address_wb  : in  std_logic_vector( 4 downto 0); --! The address the instruction in the write back stage writes to.
		
		in_opcode            : in  std_logic_vector( 7 downto 0); --! The opcode of the current instruction.
		
		in_address_a         : in  std_logic_vector( 4 downto 0); --! The address of the register A for the current instruction.
		in_address_b         : in  std_logic_vector( 4 downto 0); --! The address of the register B for the current instruction.
		in_address_c         : in  std_logic_vector( 4 downto 0); --! The address of the register C for the current instruction.
		
		out_forward_a        : out std_logic_vector( 1 downto 0); --! The forwarding data about register A for the current processor state.
		out_forward_b        : out std_logic_vector( 1 downto 0); --! The forwarding data about register B for the current processor state.
		out_forward_c        : out std_logic_vector( 1 downto 0)  --! The forwarding data about register C for the current processor state.
 	);
end entity forward_unit;

--! @brief Default forward unit behavior.
--! @details Outputs information about forwarding data and the forward source for all registers based on the current processor state.
architecture behavioral of forward_unit is
    --! @brief The forward data for input A.
    --! @details Only passed to the output if the instruction requires forwarding.
	signal s_forward_a : std_logic_vector( 1 downto 0);
    --! @brief The forward data for input B.
    --! @details Only passed to the output if the instruction requires forwarding.
	signal s_forward_b : std_logic_vector( 1 downto 0);
    --! @brief The forward data for input C.
    --! @details Only passed to the output if the instruction requires forwarding.
	signal s_forward_c : std_logic_vector( 1 downto 0);
    
    --! @brief Signals if the current instruction requires forwarding.
	signal s_opcode_should_forward : std_logic;
begin
    --! @brief Register A forward detector.
    --! @see forward_detection
	forward_detection_a: entity work.forward_detection(behavioral)
	port map
	(
        register_address_in  => in_address_a,
        write_address_mem_in => in_write_address_mem,
        write_address_wb_in  => in_write_address_wb,

        write_signal_mem_in  => in_write_signal_mem,
        write_signal_wb_in   => in_write_signal_wb,
        
        forward_out          => s_forward_a
	);
	
    --! @brief Register B forward detector.
    --! @see forward_detection
	forward_detection_b: entity work.forward_detection(behavioral)
	port map
	(
        register_address_in  => in_address_b,
        write_address_mem_in => in_write_address_mem,
        write_address_wb_in  => in_write_address_wb,

        write_signal_mem_in  => in_write_signal_mem,
        write_signal_wb_in   => in_write_signal_wb,
        
        forward_out          => s_forward_b
    );
    
    --! @brief Register C forward detector.
    --! @see forward_detection
    forward_detection_c: entity work.forward_detection(behavioral)
	port map
	(
        register_address_in  => in_address_c,
        write_address_mem_in => in_write_address_mem,
        write_address_wb_in  => in_write_address_wb,

        write_signal_mem_in  => in_write_signal_mem,
        write_signal_wb_in   => in_write_signal_wb,
        
        forward_out          => s_forward_c
    );
    
	--! @brief OPCODE process.
	--! @details Signals if the given instruction requires forwarding.
	--! @see opcodes
	should_forward: process(in_opcode)
	begin
		case to_integer(unsigned(in_opcode)) is
			when  opcodes.OP_MOVE                   |
				  opcodes.OP_LOAD                   |
				  opcodes.OP_STORE                  |
				  opcodes.OP_ADD                    |
				  opcodes.OP_SUBTRACT               |
				  opcodes.OP_AND                    |
				  opcodes.OP_OR                     |
				  opcodes.OP_XOR                    |
				  opcodes.OP_XNOR                   |
				  opcodes.OP_NOT                    |
				  opcodes.OP_SHIFT_LEFT             |
				  opcodes.OP_SHIFT_RIGHT            |
				  opcodes.OP_ARITHMETIC_SHIFT_LEFT  |
				  opcodes.OP_ARITHMETIC_SHIFT_RIGHT |
				  opcodes.OP_ROTATE_LEFT            |
				  opcodes.OP_ROTATE_RIGHT           |
				  opcodes.OP_JUMP                   |
				  opcodes.OP_JUMP_EQUALS            |
				  opcodes.OP_JUMP_NOT_EQUALS        |
				  opcodes.OP_JUMP_LESSER_THEN       |
				  opcodes.OP_JUMP_GREATER_THEN      |
				  opcodes.OP_CALL                  =>
                s_opcode_should_forward <= '1';
                
			when others =>
                s_opcode_should_forward <= '0';
                
		end case;
	end process should_forward;
    
    -- Wire signals to output.
    -- When the opcode does not require forwarding, output zeros.
    out_forward_a <= s_forward_a when s_opcode_should_forward = '1' else "00";
    out_forward_b <= s_forward_b when s_opcode_should_forward = '1' else "00";
    out_forward_c <= s_forward_c when s_opcode_should_forward = '1' else "00";
end architecture behavioral;