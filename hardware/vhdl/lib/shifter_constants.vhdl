--! @file
--! @brief Defines commonly used values for the shifter.

--! Use standart library.
library ieee;
--! Use logic elements.
use ieee.std_logic_1164.all;

--! @brief Defines shifter functions.
package shifter_functions is
	--! @brief Outputs a constant zero.
    constant F_ZERO               : std_logic_vector( 3 downto 0) := x"0";
	--! @brief Repeats the input A.
    constant F_PASS               : std_logic_vector( 3 downto 0) := x"1";
	--! @brief Logical shift left.
    constant F_LEFT               : std_logic_vector( 3 downto 0) := x"2";
	--! @brief Logical shift right.
    constant F_RIGHT              : std_logic_vector( 3 downto 0) := x"3";
	--! @brief Arithmetic shift left.
    constant F_ARITHMETIC_LEFT    : std_logic_vector( 3 downto 0) := x"4";
	--! @brief Arithmetic shift right.
    constant F_ARITHMETIC_RIGHT   : std_logic_vector( 3 downto 0) := x"5";
	--! @brief Left rotation.
    constant F_ROTATE_LEFT        : std_logic_vector( 3 downto 0) := x"6";
	--! @brief Right rotation.
    constant F_ROTATE_RIGHT       : std_logic_vector( 3 downto 0) := x"7";
	--! @brief Right rotation through carry.
    constant F_CARRY_ROTATE_LEFT  : std_logic_vector( 3 downto 0) := x"8";
	--! @brief Right rotation through carry.
    constant F_CARRY_ROTATE_RIGHT : std_logic_vector( 3 downto 0) := x"9";
end package shifter_functions;
