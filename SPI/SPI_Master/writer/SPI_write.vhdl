----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    11:25:51 10/13/2017
-- Design Name:
-- Module Name:    WRITE - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SPI_WRITE is
    Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           spi_start : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
              clk_division : in  STD_LOGIC_VECTOR (15 downto 0);
           SPI_CS : out  STD_LOGIC;
           SPI_SCK : out  STD_LOGIC;
           SPI_MOSI : out  STD_LOGIC);
end SPI_WRITE;

architecture Behavioral of spi_write is

  component diviseur_programmable is
      Generic(Nbits : integer := 32);
      Port ( clk : in  STD_LOGIC;
             rst : in  STD_LOGIC;
             clkdiv : in std_logic_vector(Nbits-1 downto 0);
             phase : in STD_LOGIC;
             polarite : in STD_LOGIC;
             tc : out  STD_LOGIC;
             clk_out : out  STD_LOGIC);
  end component;

type Etats is (idle, bitsdata);
signal next_etat, etat : Etats;
signal cpt, cpt_next : STD_LOGIC_VECTOR (3 downto 0);
signal next_data, data : STD_LOGIC_VECTOR (7 downto 0);
signal divclk, divrst, clk_divPuls : STD_LOGIC;

begin

    clkDiv : diviseur_programmable generic map (Nbits => 16)
    port map(clk =>clk,
            rst =>rst,
            clkdiv =>clk_division,
            phase => '0' ,
            polarite => '0',
            tc =>clk_divPuls,
            clk_out =>divclk);

registre_etat : process(clk,rst)
begin
if rst = '1' then
    etat <= idle;
elsif rising_edge(clk) then
    etat <= next_etat;
    data <= next_data;
    cpt <= cpt_next;
end if;

end process registre_etat;



logic_etat: process(clk_divPuls, spi_start, etat, clk)

begin

next_etat <= etat;
next_data <= data;
cpt_next <= cpt;

case etat is
    when idle =>
        SPI_MOSI <= '0';
        cpt_next <= (others => '0');
        SPI_CS <= '1';
        SPI_SCK <= '0';
        next_data <= data_in;
        if spi_start = '1' then
            next_etat <= bitsdata;
        end if;

    when bitsdata =>
        SPI_CS <= '0';
        SPI_MOSI <= data(0);
        SPI_SCK <= divclk;
        if cpt = "1000" then
            next_etat <= idle;
        elsif clk_divPuls = '1' then
            next_data <= '0' & data(7 downto 1);
            cpt_next <= STD_LOGIC_VECTOR(unsigned(cpt) + 1);
        end if;

    end case;
end process logic_etat;


end Behavioral;
