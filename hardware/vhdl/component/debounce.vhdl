--------------------------------------------------------------------------------
--
--   FileName:         debounce.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 32-bit Version 11.1 Build 173 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 3/26/2012 Scott Larson
--     Initial Public Release
--
--------------------------------------------------------------------------------

--! @file
--! @brief Debouncer.
--! @details Taken from https://www.digikey.com/eewiki/pages/viewpage.action?pageId=4980758#DebounceLogicCircuit(withVHDLexample)-ExampleVHDLCode.

--! use standart library.
library ieee;
--! use logic elements.
use ieee.std_logic_1164.all;
--! use unsigned logic for converting logic vectors to integers.
use ieee.std_logic_unsigned.all;

--! @brief Debouncer.
--! @details Only changes output signal if input is stable for some period of time.
--! @details Circuit diagram and proper explanation available 
entity debounce is
  generic
  (
    counter_size_g  : integer := 19  --! The time to wait before assuming the signal is stable.
  );
  port
  (
    clk     : in  std_logic; --! Input clock.

    button  : in  std_logic; --! Input signal to be debounced.
    result  : out std_logic  --! Debounced signal.
  );
end entity debounce;

--! @brief Default debounce behavior.
architecture behavioral of debounce is
  --! @brief Input flip flops.
  signal flipflops   : std_logic_vector(1 downto 0);
  --! @brief Sync reset to zero.
  signal counter_set : std_logic;
  --! @brief Conter output.
  signal counter_out : std_logic_vector(counter_size_g downto 0) := (others => '0');
begin

  counter_set <= flipflops(0) xor flipflops(1);   --determine when to start/reset counter
  
  --! @brief Signal debounce process.
  --! @details Waits for some time on change and checks if the input is stable.
  --! @details If stable for enough time, change output.
  debounce: process(clk)
  begin
    if(clk'event and clk = '1') then
      flipflops(0) <= button;
      flipflops(1) <= flipflops(0);
      if(counter_set = '1') then                  --reset counter because input is changing
        counter_out <= (others => '0');
      elsif(counter_out(counter_size_g) = '0') then --stable input time is not yet met
        counter_out <= counter_out + 1;
      else                                        --stable input time is met
        result <= flipflops(1);
      end if;    
    end if;
  end process;
end architecture behavioral;
