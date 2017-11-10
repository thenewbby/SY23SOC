library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity SPI_READ_SLAVE is
  port (
  SPI_MISO : in STD_LOGIC;
  spi_start : in STD_LOGIC;
  rst : in STD_LOGIC;
  clk : in STD_LOGIC;
  -- clk_division : in  STD_LOGIC_VECTOR (15 downto 0);
  SPI_CS : out STD_LOGIC;
  SPI_SCK : out STD_LOGIC;
  data_out: out std_logic_vector(7 downto 0)
  );
end entity;

architecture arch_spi_read of SPI_READ_SLAVE is

  type Etats is (idle, bitsdata);
  signal next_etat, etat : Etats;
  signal cpt, cpt_next : STD_LOGIC_VECTOR (3 downto 0);
  signal next_data, data : STD_LOGIC_VECTOR (7 downto 0);
  -- signal divclk, divrst, clk_divPuls : STD_LOGIC;

begin

  registre_etat : process(clk,rst)
  begin
  if rst = '1' then
      etat <= idle;
      data <= (others => '0');
  elsif rising_edge(clk) then
      etat <= next_etat;
      data <= next_data;
      cpt <= cpt_next;
  end if;

  end process registre_etat;

  logic_etat: process(spi_start, etat, clk, rst)

  begin

  next_etat <= etat;
  next_data <= data;

  case etat is
      when idle =>
          data_out <=  data;
          cpt_next <= (others => '0');
          SPI_CS <= '1';
          SPI_SCK <= '0';
          if spi_start = '1' then
              next_etat <= bitsdata;
          end if;

      when bitsdata =>
          SPI_CS <= '0';
          SPI_SCK <= clk;
          if cpt = "1000" then
              next_etat <= idle;
          elsif rising_edge(clk) then
              next_data <= SPI_MISO & data(7 downto 1);
              cpt_next <= STD_LOGIC_VECTOR(unsigned(cpt) + 1);
          end if;

      end case;
  end process logic_etat;


end architecture;
