--! @file
--! @brief Defines instruction OPCODEs.

--! Use standart library.
library ieee;
--! Use logic elements.
use ieee.std_logic_1164.all;

--! @brief  Defines instruction OPCODEs.
package opcodes is
    constant OP_NOOP                   : integer := 16#00#;
	
	constant OP_LOAD_IMMEDIATE         : integer := 16#01#;
	constant OP_MOVE                   : integer := 16#02#;
	constant OP_LOAD                   : integer := 16#03#;
	constant OP_STORE                  : integer := 16#04#;
	
	constant OP_ADD                    : integer := 16#05#;
	constant OP_SUBTRACT               : integer := 16#06#;
	constant OP_AND                    : integer := 16#07#;
	constant OP_OR                     : integer := 16#08#;
	constant OP_XOR                    : integer := 16#09#;
	constant OP_XNOR                   : integer := 16#0A#;
	constant OP_NOT                    : integer := 16#0B#;
	
	constant OP_SHIFT_LEFT             : integer := 16#0C#;
	constant OP_SHIFT_RIGHT            : integer := 16#0D#;
	constant OP_ARITHMETIC_SHIFT_LEFT  : integer := 16#0E#;
	constant OP_ARITHMETIC_SHIFT_RIGHT : integer := 16#0F#;
	constant OP_ROTATE_LEFT            : integer := 16#10#;
	constant OP_ROTATE_RIGHT           : integer := 16#11#;
	
	constant OP_JUMP                   : integer := 16#12#;
	
	constant OP_JUMP_EQUALS            : integer := 16#13#;

	constant OP_JUMP_NOT_EQUALS        : integer := 16#14#;
	constant OP_JUMP_LESSER_THEN       : integer := 16#15#;
	constant OP_JUMP_GREATER_THEN      : integer := 16#16#;
	
	constant OP_CALL                   : integer := 16#17#;
end package opcodes;