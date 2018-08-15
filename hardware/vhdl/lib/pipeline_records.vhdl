--! @file
--! @brief Defines types for each pipeline register block.

--! Use standart library.
library ieee;
--! Use logic elements.
use ieee.std_logic_1164.all;
--! Use numeric elements for generic type and vector construction.
use ieee.numeric_std.all;

--! @brief Defines types for each pipeline register block.
package pipeline_records is
    --! @brief Record for Decode/Execute register block.
    type decode_execute is record
        control_register_write : std_logic;
		
	    control_we             : std_logic;		
		
	    control_alu            : std_logic;
	    control_immediate      : std_logic;
	    control_function       : std_logic_vector( 3 downto 0);
		
	    control_ram_data       : std_logic;
		
	    opcode                 : std_logic_vector( 7 downto 0);
		
	    a                      : std_logic_vector(31 downto 0);
	    b                      : std_logic_vector(31 downto 0);		
	    c                      : std_logic_vector(31 downto 0);
	    immediate              : std_logic_vector(31 downto 0);
	    write_back_address     : std_logic_vector( 4 downto 0);
		
	    address_a              : std_logic_vector( 4 downto 0);
	    address_b              : std_logic_vector( 4 downto 0);
	    address_c              : std_logic_vector( 4 downto 0);
		
	    pc                     : std_logic_vector(31 downto 0);
    end record decode_execute;

    --! @brief Constant zero decode_execute record for register clearing.
    constant ZERO_DECODE_EXECUTE : decode_execute := (
        '0',

        '0',

        '0',
        '0',
        std_logic_vector(to_unsigned(0, decode_execute.control_function'length)),

        '0',

        std_logic_vector(to_unsigned(0, decode_execute.opcode'length)),

        std_logic_vector(to_unsigned(0, decode_execute.a'length)),
        std_logic_vector(to_unsigned(0, decode_execute.b'length)),
        std_logic_vector(to_unsigned(0, decode_execute.c'length)),
        std_logic_vector(to_unsigned(0, decode_execute.immediate'length)),
        std_logic_vector(to_unsigned(0, decode_execute.write_back_address'length)),

        std_logic_vector(to_unsigned(0, decode_execute.address_a'length)),
        std_logic_vector(to_unsigned(0, decode_execute.address_b'length)),
        std_logic_vector(to_unsigned(0, decode_execute.address_c'length)),

        std_logic_vector(to_unsigned(0, decode_execute.pc'length))
    );

    --! @brief Record for Decode/Execute register block.
    type execute_memory is record
        control_register_write : std_logic;
	    ram_data_select        : std_logic;
	    we                     : std_logic;
		
	    opcode                 : std_logic_vector( 7 downto 0);
	    jump_address           : std_logic_vector(31 downto 0);
	    result                 : std_logic_vector(31 downto 0);
	    status                 : std_logic_vector( 3 downto 0);
	    memory_address         : std_logic_vector(31 downto 0);
	    write_back_address     : std_logic_vector( 4 downto 0);
		
	    pc                     : std_logic_vector(31 downto 0);
    end record execute_memory;
    
    --! @brief Constant zero execute_memory record for register clearing.
    constant ZERO_EXECUTE_MEMORY : execute_memory := (
        '0',
	    '0',
	    '0',
		
	    std_logic_vector(to_unsigned(0, execute_memory.opcode'length)),
	    std_logic_vector(to_unsigned(0, execute_memory.jump_address'length)),
	    std_logic_vector(to_unsigned(0, execute_memory.result'length)),
	    std_logic_vector(to_unsigned(0, execute_memory.status'length)),
	    std_logic_vector(to_unsigned(0, execute_memory.memory_address'length)),
	    std_logic_vector(to_unsigned(0, execute_memory.write_back_address'length)),
		
	    std_logic_vector(to_unsigned(0, execute_memory.pc'length))
    );
	
	--! @brief Record for Memory/Write Back register block.
    type memory_writeback is record
        control_register_write : std_logic;
	    ram_data_select        : std_logic;
	    call_instruction       : std_logic;
		
	    data                   : std_logic_vector(31 downto 0);
	    pc                     : std_logic_vector(31 downto 0);
	    write_back_address     : std_logic_vector( 4 downto 0);
    end record memory_writeback;

    --! @brief Constant zero memory_writeback record for register clearing.
    constant ZERO_MEMORY_WRITEBACK : memory_writeback := (
        '0',
	    '0',
	    '0',
		
	    std_logic_vector(to_unsigned(0, memory_writeback.data'length)),
	    std_logic_vector(to_unsigned(0, memory_writeback.pc'length)),
	    std_logic_vector(to_unsigned(0, memory_writeback.write_back_address'length))
    );
end package pipeline_records;