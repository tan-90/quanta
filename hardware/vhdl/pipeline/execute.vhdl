--! @file
--! @brief Pipeline instruction execute stage.

--! Use standart library.
library ieee;
--! Use logic elements.
use ieee.std_logic_1164.all;
--! Use numeric elements for generic type and vector construction.
use ieee.numeric_std.all;

--! @brief Pipeline instruction execute stage.
--! @details Executes a decoded instruction.
entity execute is
	port
	(
		function_in            : in  std_logic_vector( 3 downto 0); --! Combined ALU/Shifter function signal.
		alu_select_in          : in  std_logic; --! Selects between ALU and Shifter.
		immediate_select_in    : in  std_logic; --! Enables immediate signal (replaces B value).
		
		a_in                   : in  std_logic_vector(31 downto 0); --! Decoded value for input A.
		b_in                   : in  std_logic_vector(31 downto 0); --! Decoded value for input A.
		c_in                   : in  std_logic_vector(31 downto 0); --! Decoded value for input A.
		immediate_in           : in  std_logic_vector(31 downto 0); --! Decoded immediate.
		write_back_address_in  : in  std_logic_vector( 4 downto 0); --! Address to write back the result for the current instruction.
		
		mem_result_in          : in  std_logic_vector(31 downto 0); --! Result of the instruction in the mem stage. Used for forwarding.
		wb_result_in           : in  std_logic_vector(31 downto 0); --! Result of the instruction in the wb stage. Used for forwarding.
		
		forward_a_in           : in  std_logic_vector( 1 downto 0); --! Controls the forwarding logic for input A. Bit 0 controls if data should be forwarded and bit 1 controls the forwarded data origin.
		forward_b_in           : in  std_logic_vector( 1 downto 0); --! Controls the forwarding logic for input B. Bit 0 controls if data should be forwarded and bit 1 controls the forwarded data origin.
		forward_c_in           : in  std_logic_vector( 1 downto 0); --! Controls the forwarding logic for input C. Bit 0 controls if data should be forwarded and bit 1 controls the forwarded data origin.
		
		jump_address_out       : out std_logic_vector(31 downto 0); --! Jump address for jump instructions.
		result_out             : out std_logic_vector(31 downto 0); --! Result of the current instruction.
		status_out             : out std_logic_vector( 4 downto 0); --! Status of the ALU/Shifter for the current instruction.
		mem_address_out        : out std_logic_vector(31 downto 0); --! Memory address for load/stor instructions.
		write_back_address_out : out std_logic_vector( 4 downto 0)  --! Address to write back the result for the current instruction.
	);
end entity execute;

--! @brief Default execute behavior.
--! @details Executes a given instruction and outputs the result and status.
--! @details Execution can occurr on ALU or Shifter (controled by input signal).
--! @details Handles data forwarding based on forward unit output.
--! @details Passes relevant instruction data to next stage.
architecture behavioral of execute is
	--! @brief Holds the input B. Overriden by the Immediate if selected.
	signal b_immediate_s : std_logic_vector(31 downto 0);
	
	--! @brief The input A value after forwarding is applied.
	signal forwarded_a_s : std_logic_vector(31 downto 0);
	--! @brief The input B value after forwarding is applied.
	signal forwarded_b_s : std_logic_vector(31 downto 0);
	
	--! @brief Holds the source of the data to be forwarded to A.
	--! @details chooses between the result from the mem or write back stages based on the forward signal.
	signal forward_a_source_s : std_logic_vector(31 downto 0);
	--! @brief Holds the source of the data to be forwarded to B.
	--! @details chooses between the result from the mem or write back stages based on the forward signal.
	signal forward_b_source_s : std_logic_vector(31 downto 0);
	--! @brief Holds the source of the data to be forwarded to C.
	--! @details chooses between the result from the mem or write back stages based on the forward signal.
	signal forward_c_source_s : std_logic_vector(31 downto 0);
	
	--! @brief Holds the ALU result.
	--! @details Wired to the execute stage result 4output if ALU is selected.
	signal alu_result_s : std_logic_vector(31 downto 0);
	--! @brief Holds the ALU status.
	--! @details Wired to the execute stage status output if ALU is selected.
	signal alu_status_s : std_logic_vector( 4 downto 0);
      
	--! @brief Holds the Shifter result.
	--! @details Wired to the execute stage result output if Shifter is selected.
	signal shifter_result_s : std_logic_vector(31 downto 0);
	--! @brief Holds the Shifter status.
	--! @details Wired to the execute stage status output if Shifter is selected.
	signal shifter_status_s : std_logic_vector( 4 downto 0);
begin
    --! @TODO Take signals only passed trough out of the component.
	write_back_address_out <= write_back_address_in;
    
	-- The address for memory operations is always the value of B.
    mem_address_out <= forwarded_b_s;
    
    -- The B value is replaced by the immediate value when it's selected.
    b_immediate_s <= immediate_in when immediate_select_in = '1' else b_in;
	
	-- The forward source is controlled by bit 1 of the forward unit data.
	-- An high bit sets the forward data to the memory access stage, while a low one sets it to the write back stage.
	-- Forwarding logic is applied to all decoded inputs.

	-- Forwarding logic for input A.
	forward_a_source_s <= mem_result_in when forward_a_in(1) = '1' else wb_result_in;
    forwarded_a_s <= forward_a_source_s when forward_a_in(0) = '1' else a_in;
	
	-- Forwarding logic for input B.
	forward_b_source_s <= mem_result_in when forward_b_in(1) = '1' else wb_result_in;
	-- The default (non-forwarded) value takes the input B or the Immediate input.
	-- No forwarding should ever be applied to immediate.
	-- This assumes the forward unit will not try to forward immediate type instructions.
	-- Makes code cleaner at the cost of assuming something simple to achieve.
    forwarded_b_s <= forward_b_source_s when forward_b_in(0) = '1' else b_immediate_s;
		
	-- Forwarding logic for input C.
	forward_c_source_s <= mem_result_in when forward_c_in(1) = '1' else wb_result_in;
    jump_address_out <= forward_c_source_s when forward_c_in(0) = '1' else c_in;
    
	--! @brief Execute stage Shifter.
	--! @details Shifter input is the A value of the decoded instruction (after forwarding logic is applied).
	--! @details Function is set by the controller.
	--! @details No carry in support as of now.
    shifter: entity work.shifter(behavioral)
    generic map
    (
        data_width_g => 32
    )
	port map
	(
        a_in        => forwarded_a_s,
        carry_in    => '0', -- Carry in values are not supported yet.

        function_in => function_in,
        
        c_out       => shifter_result_s,
        status_out  => shifter_status_s
    );

	--! @brief Execute stage ALU.
	--! @details ALU inputs are the A and B value of the decoded instruction (after forwarding logic is applied).
	--! @details Function is set by the controller.
	--! @details No carry in support as of now.
    alu: entity work.alu(behavioral)
    generic map
    (
        data_width_g => 32
    )
	port map
	(
        a_in        => forwarded_a_s,
        b_in        => forwarded_b_s,
        carry_in    => '0', -- Carry in values are not supported yet.

        function_in => function_in,

        c_out       => alu_result_s,
        status_out  => alu_status_s
	);
    
    -- Select the appropriate result between alu and shifter based on wether or not the alu is selected.
    result_out <= alu_result_s when alu_select_in = '1' else shifter_result_s;
    -- Select the appropriate status between alu and shifter based on wether or not the alu is selected.
    status_out <= alu_status_s when alu_select_in = '1' else shifter_status_s;
end architecture behavioral;
