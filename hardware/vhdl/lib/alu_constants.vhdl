--! @file
--! @brief Defines commonly used values for the ALU.

--! Use standart library.
library ieee;
--! Use logic elements.
use ieee.std_logic_1164.all;

--! @brief Defines ALU functions.
package alu_functions is
	--! @brief Outputs a constant zero.
	constant F_ZERO     : std_logic_vector( 3 downto 0) := x"0";
	--! @brief Adds the inputs.
	constant F_ADD      : std_logic_vector( 3 downto 0) := x"1";
	--! @brief Subtracts the two inputs.
	constant F_SUBTRACT : std_logic_vector( 3 downto 0) := x"2";
	--! @brief Repeats the input A.
	constant F_PASS_A   : std_logic_vector( 3 downto 0) := x"3";
	--! @brief Negates the input A.
	constant F_NOT      : std_logic_vector( 3 downto 0) := x"4";
	--! @brief Logical ANDs between the inputs A and B.
	constant F_AND      : std_logic_vector( 3 downto 0) := x"5";
	--! @brief Logical ORs between the inputs A and B.
	constant F_OR       : std_logic_vector( 3 downto 0) := x"6";
	--! @brief Logical XORs between the inputs A and B.
	constant F_XOR      : std_logic_vector( 3 downto 0) := x"7";
	--! @brief Logical XNORs between the inputs A and B.
	constant F_XNOR     : std_logic_vector( 3 downto 0) := x"8";
	--! @brief Repeats the input B.
	constant F_PASS_B   : std_logic_vector( 3 downto 0) := x"9";
end package alu_functions;

--! @brief Defines ALU status bit indices.
package alu_status is
	--! @brief Set when the output is 0.
	constant S_ZERO     : integer := 0;
	--! @brief Sign bit of the output.
	constant S_SIGN     : integer := 1;
	--! @brief Carry out bit.
	constant S_CARRY    : integer := 2;
	--! @brief Parity of the output.
	constant S_PARITY   : integer := 3;
	--! @brief Output overflow flag.
    constant S_OVERFLOW : integer := 4;
end package alu_status;
