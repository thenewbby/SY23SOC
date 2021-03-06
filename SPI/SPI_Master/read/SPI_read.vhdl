library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity SPI_READ is
  port (
  SPI_MISO : in STD_LOGIC;
  spi_start : in STD_LOGIC;
  rst : in STD_LOGIC;
  clk : in STD_LOGIC;
  clk_division : in  STD_LOGIC_VECTOR (15 downto 0);
  SPI_CS : out STD_LOGIC;
  SPI_SCK : out STD_LOGIC;
  data_out: out std_logic_vector(7 downto 0)
  );
end entity;

architecture arch_spi_read of SPI_READ is

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
      data <= (others => '0');
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
          data_out <=  data;
          cpt_next <= (others => '0');
          SPI_CS <= '1';
          SPI_SCK <= '0';
          -- next_data <= data_in;
          if spi_start = '1' then
              next_etat <= bitsdata;
          end if;

      when bitsdata =>
          SPI_CS <= '0';
          SPI_SCK <= divclk;
          if cpt = "1000" then
              next_etat <= idle;
          elsif clk_divPuls = '1' then
              next_data <= SPI_MISO & data(7 downto 1);
              cpt_next <= STD_LOGIC_VECTOR(unsigned(cpt) + 1);
          end if;

      end case;
  end process logic_etat;
end architecture;
