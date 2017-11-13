library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.all;

entity  ioport_tb is
end entity;

architecture arch of ioport_tb is

  component ioport is
  	 Generic (BASE_ADDR	: integer := 16#19#);
      Port (
            --Inputs
            clk : in  STD_LOGIC;
            Rst : in  STD_LOGIC;
            addr : in  STD_LOGIC_VECTOR (5 downto 0);
            iowrite : in  STD_LOGIC_VECTOR (7 downto 0);
            rd : in  STD_LOGIC;
            wr : in  STD_LOGIC;
            --Outputs
            ioread : out  STD_LOGIC_VECTOR (7 downto 0);
            --in/out-puts
            ioport : inout  STD_LOGIC_VECTOR (7 downto 0));
  end component;

  --signaux du test_bench
  signal clk_tb : STD_LOGIC := '0';
  signal Rst_tb : STD_LOGIC := '0';
  signal rd_tb : STD_LOGIC := '0';
  signal wr_tb : STD_LOGIC := '0';
  signal addr_tb : STD_LOGIC_VECTOR (5 downto 0 ) := (others => '0');
  signal ioread_tb : STD_LOGIC_VECTOR (7 downto 0 ) := (others => '0');
  signal iowrite_tb : STD_LOGIC_VECTOR (7 downto 0 ) := (others => '0');
  signal ioport_tb : STD_LOGIC_VECTOR (7 downto 0 ) := (others => '0');

  -- periode des horlogues
  constant clk_period : time := 10 ns;
  constant clk_te_period : time := 2 ns;
  -- horloge echantillonnage
  signal clk_te : STD_LOGIC := '0';
  -- definitions pour la simulation
  constant T : real := 100.0 ; -- us
  constant dT : real := 1.0 ; -- us

begin

  -- composant IOport
  uut : ioport port map (
  clk => clk_tb,
  Rst => Rst_tb,
  addr => addr_tb,
  rd => rd_tb,
  wr => wr_tb,
  ioread => ioread_tb,
  iowrite => iowrite_tb,
  ioport => ioport_tb
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

  -- process des stimulis
  stim_proc: process
  begin

    --reset
      rst_tb <= '1';
    wait for 100 ns;
      rst_tb <= '0';
    wait for 10 ns;

    -- ecriture dans le registre DDRA
      iowrite_tb <= "11111111";
      addr_tb <= "011010"; --1A
    wait for 10 ns;
      wr_tb <= '1';
    wait for 10 ns;
      wr_tb <= '0';
    wait for 100 ns;

    -- ecriture dans le registre PORTA
      iowrite_tb <= "00000000";
      addr_tb <= "011011"; --1B
    wait for 10 ns;
      wr_tb <= '1';
    wait for 10 ns;
      wr_tb <= '0';
    wait for 200 ns;

    -- ecriture dans le registre PORTA
      iowrite_tb <= "11111111";
      addr_tb <= "011011"; --1B
    wait for 10 ns;
      wr_tb <= '1';
    wait for 10 ns;
      wr_tb <= '0';
    wait for 100 ns;

    -- lecture dans le registre PINA
      addr_tb <= "011001"; --19
      wait for 10 ns;
        rd_tb <= '1';
      wait for 10 ns;
        rd_tb <= '0';
    wait for 100 ns;

    -- ecriture dans le registre DDRA
      iowrite_tb <= "00010001";
      addr_tb <= "011010"; --1A
      wait for 10 ns;
        wr_tb <= '1';
      wait for 10 ns;
        wr_tb <= '0';
    wait for 100 ns;

    -- lecture dans le registre PINA
      addr_tb <= "011001"; --19
    wait for 10 ns;
      rd_tb <= '1';
    wait for 10 ns;
      rd_tb <= '0';
    wait for 100 ns;

     wait;
  end process;

end architecture;
