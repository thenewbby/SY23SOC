library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.all;

entity  IO_interface_tb is
end entity;

architecture arch of IO_interface_tb is

  component IO_interface is
    Generic (
    portA:  integer   := 16#1B#;
    ddrA:   integer   := 16#1A#;
    pinA:   integer   := 16#19#;
    portB:  integer   := 16#18#;
    ddrB:   integer   := 16#17#;
    pinB:   integer   := 16#16#
    );
    port (
      data_in: in std_logic_vector(7 downto 0);
      adr_in: in std_logic_vector(5 downto 0);
      rst: in std_logic;
      clk: in std_logic;

      data_out: out std_logic_vector(7 downto 0);

      portA_inout: inout std_logic_vector(7 downto 0);
      portB_inout: inout std_logic_vector(7 downto 0)
    );
  end component;

  signal data_in_tb : std_logic_vector(7 downto 0) := (others => '0');
  signal adr_in_tb : std_logic_vector(5 downto 0) := (others => '0');
  signal rst_tb : std_logic := '0';
  signal clk_tb : std_logic := '0';
  signal data_out_tb : std_logic_vector(7 downto 0) := (others => '0');
  signal portA_inout_tb : std_logic_vector(7 downto 0) := (others => '0');
  signal portB_inout_tb : std_logic_vector(7 downto 0) := (others => '0');

  constant clk_period : time := 10 ns;
  constant clk_te_period : time := 2 ns;
  -- horloge echantillonnage
  signal clk_te : STD_LOGIC := '0';
  -- definitions pour la simulation
  constant T : real := 100.0 ; -- us
  constant dT : real := 1.0 ; -- us

begin

  uut: IO_interface port map (
    data_in => data_in_tb,
    adr_in => adr_in_tb,
    rst => rst_tb,
    clk => clk_tb,
    data_out => data_out_tb,
    portA_inout => portA_inout_tb,
    portB_inout => portB_inout_tb
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


  stim_proc: process
  begin
    data_in_tb <= "00000000";
    adr_in_tb <= "000000";
    rst_tb <= '1';
    wait for 100 ns;
    rst_tb <= '0';
    wait for 10 ns;


    data_in_tb <= "11111111";
    adr_in_tb <= "011010"; --1A
    wait for 100 ns;
    data_in_tb <= "00000000";
    adr_in_tb <= "011011"; --1B
    wait for 100 ns;
    data_in_tb <= "11111111";
    adr_in_tb <= "011011"; --1B
    wait for 100 ns;
    adr_in_tb <= "011001"; --19
    wait for 100 ns;
    data_in_tb <= "00010001";
    adr_in_tb <= "011010"; --1A
    wait for 100 ns;
    adr_in_tb <= "011001"; --19
    wait for 100 ns;
     wait;
  end process;


end architecture;
