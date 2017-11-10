library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity SPI_MASTER is
  port (
        SPI_MISO : in STD_LOGIC;
        spi_start : in STD_LOGIC;
        rst : in STD_LOGIC;
        clk : in STD_LOGIC;
        spi_start : in  STD_LOGIC;
        clk_division : in  STD_LOGIC_VECTOR (15 downto 0);
        data_in : in  STD_LOGIC_VECTOR (7 downto 0);

        data_out: out std_logic_vector(7 downto 0)
        SPI_CS : out  STD_LOGIC;
        SPI_SCK : out  STD_LOGIC;
        SPI_MOSI : out  STD_LOGIC
           );
end entity;

architecture arch of SPI_MASTER is

  component SPI_WRITE is
      Port (
            data_in : in  STD_LOGIC_VECTOR (7 downto 0);
            spi_start : in  STD_LOGIC;
            rst : in  STD_LOGIC;
            clk : in  STD_LOGIC;
            clk_division : in  STD_LOGIC_VECTOR (15 downto 0);
            SPI_CS : out  STD_LOGIC;
            SPI_SCK : out  STD_LOGIC;
            SPI_MOSI : out  STD_LOGIC);
  end component;

  component SPI_READ is
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
  end component;

  signal SPI_SCK_r, SPI_SCK_s : STD_LOGIC;
begin

  SPI_SCK <= SPI_SCK_r or SPI_SCK_s;

  sender : SPI_WRITE port map(
      data_in => data_in,
      spi_start => spi_start,
      rst => rst,
      clk => clk,
      clk_division => clk_division,
      SPI_CS => SPI_CS,
      SPI_SCK => SPI_SCK_s,
      SPI_MOSI => SPI_MOSI
      );

  reader : SPI_READ port map (
      SPI_MISO => SPI_MISO,
      spi_start => spi_start,
      rst => rst,
      clk => clk,
      clk_division => clk_division,
      SPI_CS => SPI_CS,
      SPI_SCK => SPI_SCK_r,
      data_out=> data_out
      );



end architecture;
