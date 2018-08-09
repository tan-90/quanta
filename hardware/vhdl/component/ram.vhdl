--! @file
--! @brief Read/Write generic width and address width RAM.
--! @details Tests are performed against the provided MIF from the data folder.
--! @details While initializing memory seems to be a problem in modelsim, quartus handles it very well.
--! @details The tests that don't depend on initializing memory will work regardless.

--! Use standart library.
library ieee;
--! Use logic elements.
use ieee.std_logic_1164.all;
--! Use unsigned logic for converting logic vectors to integers.
USE ieee.std_logic_unsigned.ALL;
--! Use numeric elements for address derreferencing.
use ieee.numeric_std.all;

--! @brief Read/Write generic width and address width RAM.
--! @details Generic word size and data bus size rising edge triggered RAM with reset and enable signals.
entity ram is
    generic
    (
        data_width_g    : integer := 32; --! Data signal width.
        address_width_g : integer :=  8; --! Read/Write address bus width.

        init_file_g     : string  := "UNKOWN" --! Memory initialization file path. 
    );
    port
    (
        clock_in   : in  std_logic; --! Clock signal.
        reset_in   : in  std_logic; --! Active high reset signal.
        enable_in  : in  std_logic; --! Active high enable signal.

        address_in : in  std_logic_vector(address_width_g - 1 downto 0); --! RAM read/write address.
        data_in    : in  std_logic_vector(data_width_g    - 1 downto 0); --! RAM data input.
        
        we_in      : in  std_logic; --! RAM active high write enable signal.

        data_out   : out std_logic_vector(data_width_g - 1 downto 0) --! RAM data output.
    );
end entity ram;

--! @brief Default data RAM behavior.
architecture behavioral of ram is
    --! @brief Data word type.
    subtype word is std_logic_vector(data_width_g - 1 downto 0);
    --! @brief Variable range data word array.
    type word_array is array(natural range<>) of word;

    --! @brief Memory signal.
    --! @detals Word array to hold RAM data.
    --! @details Depth calculated given the address width.
    signal memory_s : word_array(2**address_width_g - 1 DOWNTO 0);

    --! @brief RAM initialization file attribute.
    attribute ram_init_file : string;                                 
    --! @brief Initializes ram data using memory initialization file.
    attribute ram_init_file of memory_s: signal is init_file_g; 
begin
    --! @brief Clock and enable process.
    --! @details Clears output on reset signal.
    --! @details Sets word at given address to input on clock rising edge if we and enable are high.
    --! @details Sets output to word at given address on clock rising edge if enabled is high.
    read_write: process(clock_in, reset_in, enable_in, address_in, data_in, we_in)
    begin
        if reset_in = '1' then
            data_out <= std_logic_vector(to_unsigned(0, data_width_g));
        elsif enable_in = '1' and rising_edge(clock_in) then
            if we_in = '1' then
               -- Write input word to memory at address.
               memory_s(conv_integer(address_in)) <= data_in;
               data_out <= data_in;
            else
               -- Read output word from memory at address.
               data_out <= memory_s(conv_integer(address_in));
            end if;
        end if;
    end process read_write;
end architecture behavioral;

