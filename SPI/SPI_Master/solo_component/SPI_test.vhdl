library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.all;

entity spi_tb is
end entity;

architecture arch of spi_tb is

  -- calcule de la division de frequence
  constant bauds : integer := 115200;

  constant sysclk : real := 50.0e6 ; -- 50MHz
  constant N : integer :=  integer(sysclk / real(bauds));
  constant DIVTX : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(N,16));

  component SPI is
    port (
    -- Inputs
    data_in : in  STD_LOGIC_VECTOR (7 downto 0);
    SPI_MISO : in STD_LOGIC;
    spi_start : in STD_LOGIC;
    rst : in STD_LOGIC;
    clk : in STD_LOGIC;
    clk_division : in  STD_LOGIC_VECTOR (15 downto 0);
    -- outputs
    SPI_CS : out STD_LOGIC;
    SPI_SCK : out STD_LOGIC;
    SPI_MOSI : out  STD_LOGIC;
    data_out: out std_logic_vector(7 downto 0)
    );
  end component;

  --Inputs
  signal data_in_tb : std_logic_vector(7 downto 0) := (others => '0');
  signal spi_start_tb : std_logic := '0';
  signal rst_tb : std_logic := '0';
  signal clk_tb : std_logic := '0';
  signal SPI_MISO_tb : std_logic;
  signal clk_division_tb :  STD_LOGIC_VECTOR (15 downto 0);

    --Outputs
  signal SPI_CS_tb : std_logic;
  signal SPI_SCK_tb : std_logic;
  signal data_out_tb : std_logic_vector(7 downto 0) := (others => '0');
  signal SPI_MOSI_tb : std_logic;

  -- periode des horlogues
  constant clk_period : time := 10 ns;
  constant clk_te_period : time := 2 ns;

  -- horloge echantillonnage
  signal clk_te : STD_LOGIC := '0';
  -- definitions pour la simulation
  constant T : real := 100.0 ; -- us
  constant dT : real := 1.0 ; -- us

begin

  -- composant SPI
 uut: spi PORT MAP (
          data_in => data_in_tb,
          SPI_MISO => SPI_MISO_tb,
          spi_start => spi_start_tb,
          rst => rst_tb,
          clk => clk_tb,
          clk_division => clk_division_tb,
          SPI_CS => SPI_CS_tb,
          SPI_SCK => SPI_SCK_tb,
          SPI_MOSI => SPI_MOSI_tb,
          data_out => data_out_tb
      );

  -- Clock process definitions
  clk_process :process
  begin
       clk_tb <= '0';
       wait for clk_period/2;
       clk_tb <= '1';
       wait for clk_period/2;
  end process;

  clk_te_process :process
  begin
       clk_te <= '0';
       wait for clk_te_period/2;
       clk_te <= '1';
       wait for clk_te_period/2;
  end process;

  -- Stimulus process
  stim_proc: process
  begin

      clk_division_tb <= DIVTX ;
      rst_tb <= '1';
      data_in_tb <= "10110111";
    wait for 100 ns;
      rst_tb <= '0';
      spi_start_tb <= '1';
    wait for 100 ns;
      spi_start_tb <= '0';
    wait for 100 ns;
      SPI_MISO_tb <= '1';
    wait for 65000 ns;
      SPI_MISO_tb <= '0';


     wait;
  end process;
end architecture;
