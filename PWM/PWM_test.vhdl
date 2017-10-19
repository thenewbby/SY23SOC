library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;
use WORK.all;

entity PWM_tb is
end entity;

architecture tb_arch of PWM_tb  is

  component PWM is
    port (  data_in : in std_logic_vector(7 downto 0);
            rst, clk : in std_logic;
            clk_out : out std_logic
    );
  end component;

  signal data_in_tb : std_logic_vector(7 downto 0);

  signal rst_tb, clk_tb, clk_out_tb : std_logic;

  constant clk_period : time := 10 ns;
  constant clk_te_period : time := 2 ns;

  signal clk_te : STD_LOGIC;

  constant T : real := 400.0; -- ns
  constant dT : real := 2.0; -- ns
begin


  PWM_1 : PWM port map(data_in => data_in_tb ,clk => clk_tb, rst => rst_tb, clk_out => clk_out_tb);

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

  stim_proc : process
  begin
    rst_tb <= '1';
    data_in_tb <= "00010010";
    wait for 20 ns;
    rst_tb <= '0';

    wait for 10000 ns;
    data_in_tb <= "11001000";

    wait for 10000 ns;
    rst_tb <= '1';
    wait for 20 ns;
  end process;

  resultats: process(clk_te)
    file machine_etat_file: text open WRITE_MODE is "PMW.txt";
    variable s : line;
    variable temps :  real := 0.0;
  begin
    if rising_edge(clk_te) then
      write(s, temps);write(s, string'("    "));
      write(s, data_in_tb);write(s, string'("    "));
      write(s, clk_tb);write(s, string'("    "));
      write(s, rst_tb);write(s, string'("    "));
      write(s, clk_out_tb);write(s, string'("    "));
      writeline(machine_etat_file,s);
      temps := temps + dT;
    end if;
  end process resultats;

end architecture;
