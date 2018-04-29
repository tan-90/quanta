LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

PACKAGE constants IS
	CONSTANT DATA_WIDTH : INTEGER := 32;
	CONSTANT REGISTER_DEPTH : INTEGER := 32;
	CONSTANT INSTRUCTION_RAM_ADDR_WIDTH : INTEGER := 8;
	CONSTANT DATA_RAM_ADDR_WIDTH : INTEGER := 8;
	
	
	CONSTANT ALU_ZERO : STD_LOGIC_VECTOR( 3 DOWNTO 0) := x"0";
	CONSTANT ALU_ADD : STD_LOGIC_VECTOR( 3 DOWNTO 0) := x"1";
	CONSTANT ALU_SUBTRACT : STD_LOGIC_VECTOR( 3 DOWNTO 0) := x"2";
	CONSTANT ALU_PASS : STD_LOGIC_VECTOR( 3 DOWNTO 0) := x"3";
	CONSTANT ALU_NOT : STD_LOGIC_VECTOR( 3 DOWNTO 0) := x"4";
	CONSTANT ALU_AND : STD_LOGIC_VECTOR( 3 DOWNTO 0) := x"5";
	CONSTANT ALU_OR : STD_LOGIC_VECTOR( 3 DOWNTO 0) := x"6";
	CONSTANT ALU_XOR : STD_LOGIC_VECTOR( 3 DOWNTO 0) := x"7";
	CONSTANT ALU_XNOR : STD_LOGIC_VECTOR( 3 DOWNTO 0) := x"8";
	CONSTANT ALU_PASS_B : STD_LOGIC_VECTOR( 3 DOWNTO 0) := x"9";
	
	CONSTANT SHIFTER_PASS : STD_LOGIC_VECTOR( 3 DOWNTO 0) := x"0";
	CONSTANT SHIFTER_LEFT : STD_LOGIC_VECTOR( 3 DOWNTO 0) := x"1";
	CONSTANT SHIFTER_RIGHT : STD_LOGIC_VECTOR( 3 DOWNTO 0) := x"2";
	CONSTANT SHIFTER_ARITHMETIC_LEFT : STD_LOGIC_VECTOR( 3 DOWNTO 0) := x"3";
	CONSTANT SHIFTER_ARITHMETIC_RIGHT : STD_LOGIC_VECTOR( 3 DOWNTO 0) := x"4";
	CONSTANT SHIFTER_ROTATE_LEFT : STD_LOGIC_VECTOR( 3 DOWNTO 0) := x"5";
	CONSTANT SHIFTER_ROTATE_RIGHT : STD_LOGIC_VECTOR( 3 DOWNTO 0) := x"6";	

    @assembler.params
    {

    };
	
    @assembler
    {
        "alias": "noop"
    };
	CONSTANT OPCODE_NOOP : INTEGER := 16#00#; --set_assembler_alias(noop);
	
    @assembler.instruction
    {
        "alias": "li",
        "description": "Load Immediate",
        "args": [
            {
                "name": "REGISTER_A",
                "type": "REGISTER",
                "padding": 8
            },
            {
                "name": "IMMEDIATE",
                "type": "IMMEDIATE",
                "padding": 16
            }
        ]
    };
	CONSTANT OPCODE_LOAD_IMMEDIATE : INTEGER := 16#01#; --set_assembler_alias(li);
	CONSTANT OPCODE_MOVE : INTEGER := 16#02#; --set_assembler_alias(mov);
	CONSTANT OPCODE_LOAD : INTEGER := 16#03#; --set_assembler_alias(load);
	CONSTANT OPCODE_STORE : INTEGER := 16#04#; --set_assembler_alias(store);
	
    @assembler.instruction
	{
        "alias": "add",
        "description": "Add",
        "args": [
            {
                "name": "REGISTER_A",
                "type": "REGISTER",
                "padding": 8
            },
            {
                "name": "REGISTER_B",
                "type": "REGISTER",
                "padding": 16
            }
        ]
    };
	CONSTANT OPCODE_ADD : INTEGER := 16#05#; --set_assembler_alias(add);
	CONSTANT OPCODE_SUBTRACT : INTEGER := 16#06#; --set_assembler_alias(sub);
	CONSTANT OPCODE_AND : INTEGER := 16#07#; --set_assembler_alias(and);
	CONSTANT OPCODE_OR : INTEGER := 16#08#; --set_assembler_alias(or);
	CONSTANT OPCODE_XOR : INTEGER := 16#09#; --set_assembler_alias(xor);
	CONSTANT OPCODE_XNOR : INTEGER := 16#0A#; --set_assembler_alias(xnor);
	CONSTANT OPCODE_NOT : INTEGER := 16#0B#; --set_assembler_alias(not);
	
	CONSTANT OPCODE_SHIFT_LEFT : INTEGER := 16#0C#; --set_assembler_alias(sl);
	CONSTANT OPCODE_SHIFT_RIGHT : INTEGER := 16#0D#; --set_assembler_alias(sr);
	CONSTANT OPCODE_ARITHMETIC_SHIFT_LEFT : INTEGER := 16#0E#; --set_assembler_alias(asl);
	CONSTANT OPCODE_ARITHMETIC_SHIFT_RIGHT : INTEGER := 16#0F#; --set_assembler_alias(asr);
	CONSTANT OPCODE_ROTATE_LEFT : INTEGER := 16#10#; --set_assembler_alias(rl);
	CONSTANT OPCODE_ROTATE_RIGHT : INTEGER := 16#11#; --set_assembler_alias(rr);
	
	CONSTANT OPCODE_JUMP : INTEGER := 16#12#; --set_assembler_alias(j);
	
	CONSTANT OPCODE_JUMP_EQUALS : INTEGER := 16#13#; --set_assembler_alias(je);

	CONSTANT OPCODE_JUMP_NOT_EQUALS : INTEGER := 16#14#; --set_assembler_alias(jne);
	CONSTANT OPCODE_JUMP_LESSER_THEN : INTEGER := 16#15#; --set_assembler_alias(jl);
	CONSTANT OPCODE_JUMP_GREATER_THEN : INTEGER := 16#16#; --set_assembler_alias(jg);
END PACKAGE;