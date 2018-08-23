--! @file
--! @brief Top level quanta entity.
--! @details Implements the actual processor.

--! Use standart library.
library ieee;
--! Use logic elements.
use ieee.std_logic_1164.all;
--! Use numeric elements for generic type and vector construction.
use ieee.numeric_std.all;

--! Use OPCODE definitions.
use work.opcodes;

--! Use pipeline record types definition.
use work.pipeline_records;

--! @brief Top level quanta entity.
entity quanta is
    port
    (
      clock_in  : in std_logic; --! Clock signal.
      reset_in  : in std_logic; --! Active high reset signal.
      enable_in : in std_logic  --! Active high enable signal.
    );
end entity quanta;

--! @brief Default quanta behavior.
--! @details Connects all components to implement the processor.
--! @details Signals to wire components are named the same as in the component, with the component name as a prefix and _s as a suffix.
--! @details Signals to wire components are documented with references to the actual component.
architecture behavioral of quanta is
    -- FETCH
        --! @brief Used to wire fetch output signals to processor components.
        --! @see fetch
        signal fetch_instruction_s : std_logic_vector(31 downto 0);
        --! @brief Used to wire fetch output signals to processor components.
        --! @see fetch
        signal fetch_address_s : std_logic_vector(31 downto 0);

    -- DECODE
        --! @brief Used to wire decode output signals to processor components.
        --! @see decode
        signal decode_a_s : std_logic_vector(31 downto 0);
        --! @brief Used to wire decode output signals to processor components.
        --! @see decode
        signal decode_b_s : std_logic_vector(31 downto 0);
        --! @brief Used to wire decode output signals to processor components.
        --! @see decode
        signal decode_c_s : std_logic_vector(31 downto 0);
        --! @brief Used to wire decode output signals to processor components.
        --! @see decode
        signal decode_immediate_s : std_logic_vector(31 downto 0);

        --! @brief Used to wire decode output signals to processor components.
        --! @see decode
        signal decode_opcode_s : std_logic_vector( 7 downto 0);
        --! @brief Used to wire decode output signals to processor components.
        --! @see decode
        signal decode_write_back_s : std_logic_vector( 4 downto 0);

        --! @brief Used to wire decode output signals to processor components.
        --! @see decode
        signal decode_a_address_s : std_logic_vector( 4 downto 0);
        --! @brief Used to wire decode output signals to processor components.
        --! @see decode
        signal decode_b_address_s : std_logic_vector( 4 downto 0);
        --! @brief Used to wire decode output signals to processor components.
        --! @see decode
        signal decode_c_address_s : std_logic_vector( 4 downto 0);

        -- Controller
        --! @brief Used to wire controller output signals to processor components.
        --! @see controller
        signal controller_alu_select_s : std_logic;
        --! @brief Used to wire controller output signals to processor components.
        --! @see controller
        signal controller_function_s : std_logic_vector( 3 downto 0);
        --! @brief Used to wire controller output signals to processor components.
        --! @see controller
        signal controller_we_s : std_logic;
        --! @brief Used to wire controller output signals to processor components.
        --! @see controller
        signal controller_ram_data_s : std_logic;

        --! @brief Used to wire controller output signals to processor components.
        --! @see controller
        signal controller_immediate_select_s : std_logic;
        --! @brief Used to wire controller output signals to processor components.
        --! @see controller
        signal controller_register_write_s : std_logic;

        --! @brief The actual we control signal.
        --! @details Takes stall signal into consideration.
        --! @details Goes low  to become transparent when a stall was requested.
        signal controller_we_stall_s : std_logic;
        --! @brief The actual register write control signal.
        --! @details Takes stall signal into consideration.
        --! @details Goes low  to become transparent when a stall was requested.
        signal controller_register_write_stall_s : std_logic;

        -- Hazard Detection
        --! @brief Used to wire hazard detection output signals to processor components.
        --! @see hazard_detection
        signal hazard_detection_stall_s : std_logic;

    -- DECODE/EXECUTE
        --! @brief Decode/Execute register block input.
        --! @details Record of pipeline register block values.
        --! @details Each record signal is assign to the corresponding processor signal.
        --! @details Single signal input to the register block.
        signal in_decode_execute_s : pipeline_records.decode_execute;
        
        --! @brief Decode/Execute register block output.
        --! @details Record of pipeline register block values.
        --! @details All values are assigned as the register block entity output.
        signal out_decode_execute_s : pipeline_records.decode_execute;
    
    -- EXECUTE
        --! @brief Used to wire execute output signals to processor components.
        --! @see execute
        signal execute_jump_address_s : std_logic_vector(31 downto 0);
        --! @brief Used to wire execute output signals to processor components.
        --! @see execute
        signal execute_result_s : std_logic_vector(31 downto 0);
        --! @brief Used to wire execute output signals to processor components.
        --! @see execute
        signal execute_status_s : std_logic_vector( 4 downto 0);
        --! @brief Used to wire execute output signals to processor components.
        --! @see execute
        signal execute_mem_address_s : std_logic_vector(31 downto 0);
        --! @brief Used to wire execute output signals to processor components.
        --! @see execute
		signal execute_write_back_address_s : std_logic_vector( 4 downto 0);

        -- Forward Unit
        --! @brief Used to wire forward unit output signals to processor components.
        --! @see forward_unit
        signal forward_unit_a_s : std_logic_vector( 1 downto 0);
        --! @brief Used to wire forward unit output signals to processor components.
        --! @see forward_unit
        signal forward_unit_b_s : std_logic_vector( 1 downto 0);
        --! @brief Used to wire forward unit output signals to processor components.
        --! @see forward_unit
        signal forward_unit_c_s : std_logic_vector( 1 downto 0);
    
    -- EXECUTE/MEMORY ACCESS
        --! @brief Execute/Memory Access register block input.
        --! @details Record of pipeline register block values.
        --! @details Each record signal is assign to the corresponding processor signal.
        --! @details Single signal input to the register block.
        signal in_execute_memory_s : pipeline_records.execute_memory;

        --! @brief Execute/Memory Access register block output.
        --! @details Record of pipeline register block values.
        --! @details All values are assigned as the register block entity output.
        signal out_execute_memory_s : pipeline_records.execute_memory;

    -- MEMORY ACCESS
        --! @brief Used to wire memory access output signals to processor components.
        --! @see memory_access
        signal memory_access_data_s : std_logic_vector(31 downto 0); 
        --! @brief Used to wire memory access output signals to processor components.
        --! @see memory_access
        signal memory_access_ram_data_s : std_logic_vector(31 downto 0); 
        --! @brief Used to wire memory access output signals to processor components.
        --! @see memory_access
        signal memory_access_write_back_address_s : std_logic_vector( 4 downto 0);

        --Jump Controller
        --! @brief Used to wire jump controller output signals to processor components.
        --! @see jump_controller
        signal jump_controller_jump_s  : std_logic;

    -- MEMORY ACCESS/WRITE BACK
        --! @brief Memory Access/Write Back register block input.
        --! @details Record of pipeline register block values.
        --! @details Each record signal is assign to the corresponding processor signal.
        --! @details Single signal input to the register block.
        signal in_memory_writeback_s : pipeline_records.memory_writeback;
    
        --! @brief Memory Access/Write Back register block output.
        --! @details Record of pipeline register block values.
        --! @details All values are assigned as the register block entity output.
        signal out_memory_writeback_s : pipeline_records.memory_writeback;

    -- WRITE BACK
    --! @brief Used to wire write back output signals to processor components.
    --! @details The final instruction result after the last pipeline stage.
    --! @see memory_access
    signal write_back_data_s : std_logic_vector(31 downto 0);
begin
    -- FETCH
        --! @brief Pipeline fetch stage component.
        --! @see fetch
        fetch: entity work.fetch(behavioral)
        generic map
        (
            data_width_g => 32
        )
        port map
        (
            clock_in         => clock_in,
            reset_in         => reset_in,
            enable_in        => enable_in,

            stall_in         => hazard_detection_stall_s,
            jump_in          => jump_controller_jump_s,
            flush_in         => jump_controller_jump_s,
            
            jump_address_in  => out_execute_memory_s.jump_address,
            
            instruction_out  => fetch_instruction_s,
            address_out      => fetch_address_s
        );

    -- DECODE
        --! @brief Pipeline decode stage component.    
        --! @see decode
        decode: entity work.decode(behavioral)
        port map
        (
            clock_in         => clock_in,
            reset_in         => reset_in,
            enable_in        => enable_in,

		    write_signal_in  => out_memory_writeback_s.control_register_write,
		    write_address_in => out_memory_writeback_s.write_back_address,
		    write_data_in    => write_back_data_s,
    
		    instruction_in   => fetch_instruction_s,
    
		    a_out            => decode_a_s,
		    b_out            => decode_b_s,
		    c_out            => decode_c_s,
		    immediate_out    => decode_immediate_s,

            opcode_out       => decode_opcode_s,
		    write_back_out   => decode_write_back_s,
    
		    a_address_out    => decode_a_address_s,
		    b_address_out    => decode_b_address_s,
		    c_address_out    => decode_c_address_s
        );

        -- Controller
        --! @brief Processor controller component.
        --! @see controller
        controller: entity work.controller(behavioral)
        port map
        (
            opcode_in            => decode_opcode_s,
            
            alu_select_out       => controller_alu_select_s,
            function_out         => controller_function_s,
            
            we_out               => controller_we_s, 
            ram_data_out         => controller_ram_data_s, 
            immediate_select_out => controller_immediate_select_s, 
            register_write_out   => controller_register_write_s
        );

        -- Hazard Detection
        --! @brief Hazard detection component.
        --! @see hazard_detection
        hazard_detection: entity work.hazard_detection(behavioral)
        port map
        (
            decoded_a_in          => decode_a_address_s,
            decoded_b_in          => decode_b_address_s,
            decoded_c_in          => decode_c_address_s,
        
            execute_ram_select_in => out_decode_execute_s.control_ram_data,
            execute_write_addr_in => out_decode_execute_s.write_back_address,

            stall_out             => hazard_detection_stall_s
        );
        
        -- Turn we signal transparent if a stall was requessted.
        controller_we_stall_s <= '0' when hazard_detection_stall_s = '1' else controller_we_s;
        -- Turn register write ssignal transparent if a stall was requested.
        controller_register_write_stall_s <= '0' when hazard_detection_stall_s = '1' else controller_register_write_s;

    -- DECODE/EXECUTE
        -- Connect corresponding signals to pipeline register block input record.
        -- {
        in_decode_execute_s.control_register_write <= controller_register_write_stall_s;
		
	    in_decode_execute_s.control_we             <= controller_we_stall_s;
		
	    in_decode_execute_s.control_alu            <= controller_alu_select_s;
	    in_decode_execute_s.control_immediate      <= controller_immediate_select_s;
	    in_decode_execute_s.control_function       <= controller_function_s;
		
	    in_decode_execute_s.control_ram_data       <= controller_ram_data_s;
		
	    in_decode_execute_s.opcode                 <= decode_opcode_s;
		
	    in_decode_execute_s.a                      <= decode_a_s;
	    in_decode_execute_s.b                      <= decode_b_s;
	    in_decode_execute_s.c                      <= decode_c_s;
	    in_decode_execute_s.immediate              <= decode_immediate_s;
	    in_decode_execute_s.write_back_address     <= decode_write_back_s;
		
	    in_decode_execute_s.address_a              <= decode_a_address_s;
	    in_decode_execute_s.address_b              <= decode_b_address_s;
	    in_decode_execute_s.address_c              <= decode_c_address_s;
		
        in_decode_execute_s.pc                     <= fetch_address_s;
        -- }

        --! @brief Decode/Execute register block.        
        decode_execute_register: entity work.decode_execute_register(behavioral)
        port map
        (
            clock_in  => clock_in,
            reset_in  => jump_controller_jump_s,
            enable_in => enable_in,
    
            data_in   => in_decode_execute_s,
            data_out  => out_decode_execute_s
        );

    -- EXECUTE
        --! @brief Pipeline execute stage component.
        --! @see execute
        execute: entity work.execute(behavioral)
        port map
        (
            function_in            => out_decode_execute_s.control_function,
            alu_select_in          => out_decode_execute_s.control_alu,
            immediate_select_in    => out_decode_execute_s.control_immediate,
            
            a_in                   => out_decode_execute_s.a,
            b_in                   => out_decode_execute_s.b,
            c_in                   => out_decode_execute_s.c,
            immediate_in           => out_decode_execute_s.immediate,
            write_back_address_in  => out_decode_execute_s.write_back_address,
            
            mem_result_in          => out_execute_memory_s.result,
            wb_result_in           => write_back_data_s,
            
            forward_a_in           => forward_unit_a_s,
            forward_b_in           => forward_unit_b_s,
            forward_c_in           => forward_unit_c_s,
            
            jump_address_out       => execute_jump_address_s,
            result_out             => execute_result_s,
            status_out             => execute_status_s,
            mem_address_out        => execute_mem_address_s,
            write_back_address_out => execute_write_back_address_s
        );

        -- Forward Unit
        --! @brief Pipeline forwarding unit component.
        --! @see forward_unit
        forward_unit: entity work.forward_unit(behavioral)
        port map
        (
            in_write_signal_mem  => out_execute_memory_s.control_register_write,
            in_write_signal_wb   => out_memory_writeback_s.control_register_write,
            
            in_write_address_mem => out_execute_memory_s.write_back_address,
            in_write_address_wb  => out_memory_writeback_s.write_back_address,
            
            in_opcode            => out_decode_execute_s.opcode,
            
            in_address_a         => out_decode_execute_s.address_a,
            in_address_b         => out_decode_execute_s.address_b,
            in_address_c         => out_decode_execute_s.address_c,
            
            out_forward_a        => forward_unit_a_s,
            out_forward_b        => forward_unit_b_s,
            out_forward_c        => forward_unit_c_s
        );

    -- EXECUTE/MEMORY ACCESS
        
        -- Connect corresponding signals to pipeline register block input record.
        -- {
        in_execute_memory_s.control_register_write <= out_decode_execute_s.control_register_write;
	    in_execute_memory_s.ram_data_select        <= out_decode_execute_s.control_ram_data;
	    in_execute_memory_s.we                     <= out_decode_execute_s.control_we;
		
	    in_execute_memory_s.opcode                 <= out_decode_execute_s.opcode;
	    in_execute_memory_s.jump_address           <= execute_jump_address_s;
	    in_execute_memory_s.result                 <= execute_result_s;
	    in_execute_memory_s.status                 <= execute_status_s;
	    in_execute_memory_s.memory_address         <= execute_mem_address_s;
	    in_execute_memory_s.write_back_address     <= execute_write_back_address_s;
		
	    in_execute_memory_s.pc                     <= out_decode_execute_s.pc;
        -- }

        --! @brief Execute/Memory Access register block.        
        execute_memory_register: entity work.execute_memory_register(behavioral)
        port map
        (
            clock_in  => clock_in,
            reset_in  => reset_in,
            enable_in => enable_in,
    
            data_in   => in_execute_memory_s,
            data_out  => out_execute_memory_s
        );

    -- MEMORY ACCESS
        --! @brief Pipeline memory access stage component.
        --! @see memory_access
        memory_access: entity work.memory_access(behavioral)
        generic map
        (
            data_width_g => 32
        )
        port map
        (
            clock_in               => clock_in,
            reset_in               => reset_in,
            enable_in              => enable_in,

            we_in                  => out_execute_memory_s.we,
            
            result_in              => out_execute_memory_s.result,
            memory_address_in      => out_execute_memory_s.memory_address,
            write_back_address_in  => out_execute_memory_s.write_back_address,
            
            data_out               => memory_access_data_s,
            ram_data_out           => memory_access_ram_data_s,
            write_back_address_out => memory_access_write_back_address_s
        );

        --! @brief Pipeline jump controller component.
        --! @see jump_controller
        jump_controller: entity work.jump_controller(behavioral)
        port map
        (
            opcode_in => out_execute_memory_s.opcode,
		    status_in => out_execute_memory_s.status,
		
		    jump_out  => jump_controller_jump_s
        );
    
    -- MEMORY ACCESS/WRITE BACK
        -- Connect corresponding signals to pipeline register block input record.
        -- {
        in_memory_writeback_s.control_register_write <= out_execute_memory_s.control_register_write;
	    in_memory_writeback_s.ram_data_select        <= out_execute_memory_s.ram_data_select;
	    in_memory_writeback_s.call_instruction       <= '1' WHEN TO_INTEGER(UNSIGNED(out_execute_memory_s.opcode)) = opcodes.OP_CALL ELSE '0';
		
	    in_memory_writeback_s.data                   <= memory_access_data_s;
	    in_memory_writeback_s.pc                     <= in_execute_memory_s.pc;
        in_memory_writeback_s.write_back_address     <= memory_access_write_back_address_s;
        -- }

        --! @brief Memory Access/Write Back register block.    
        memory_writeback_register: entity work.memory_writeback_register(behavioral)
        port map
        (
            clock_in  => clock_in,
            reset_in  => reset_in,
            enable_in => enable_in,
    
            data_in   => in_memory_writeback_s,
            data_out  => out_memory_writeback_s
        );

    -- WRITE BACK

    --! @brief Pipeline jump controller component.
    --! @see jump_controller
    write_back: entity work.write_back(behavioral)
    port map
    (
        ram_data_select_in  => in_execute_memory_s.ram_data_select,
		call_instruction_in => out_memory_writeback_s.call_instruction,
	
		data_in             => out_memory_writeback_s.data,
		ram_data_in         => memory_access_ram_data_s,
		pc_in               => out_memory_writeback_s.pc,
		
		write_back_data_out => write_back_data_s
    );
    
end architecture behavioral;