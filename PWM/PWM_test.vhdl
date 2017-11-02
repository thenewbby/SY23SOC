library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;
use WORK.all;

-- PWM module test bench
-- edited by Clément Duval 31/10/2017

entity PWM_tb is
end entity;

architecture tb_arch of PWM_tb  is

  component PWM is
    port (  cpt_max, OCR1x_in : in std_logic_vector(7 downto 0);
            mode_sortie : in std_logic_vector(1 downto 0);
            force, active, PFC_mode, out_inverse, rst, clk : in std_logic;
            OC1x, OC1xbar : out std_logic);
  end component;

  signal cpt_max_tb, OCR1x_in_tb : std_logic_vector(7 downto 0);
  signal mode_sortie_tb : std_logic_vector(1 downto 0);
  signal rst_tb, clk_tb, force_tb, active_tb, PFC_mode_tb, out_inverse_tb : std_logic;
  signal OC1x_tb, OC1xbar_tb : std_logic;

  constant clk_period : time := 10 ns;
  constant clk_te_period : time := 2 ns;

  signal clk_te : STD_LOGIC;

  constant T : real := 400.0; -- ns
  constant dT : real := 2.0; -- ns
begin


  PWM_1 : PWM port map(cpt_max => cpt_max_tb ,
                       OCR1x_in => OCR1x_in_tb,
                       mode_sortie => mode_sortie_tb,
                       force => force_tb,
                       active => active_tb,
                       PFC_mode => PFC_mode_tb,
                       out_inverse => out_inverse_tb,
                       rst => rst_tb,
                       clk => clk_tb,
                       OC1x => OC1x_tb,
                       OC1xbar => OC1xbar_tb);

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
    force_tb <= '0';
    active_tb <= '1';
    PFC_mode_tb <= '0'; --Fast PWM mode
    out_inverse_tb <= '0'; --Pas d'inversion de sortie
    mode_sortie_tb <= "01";
    cpt_max_tb <= "11111111";
    OCR1x_in_tb <= "10001000"; -- Rapport 75%
    wait for 20 ns;
    rst_tb <= '0';

    wait for 10000 ns;
    OCR1x_in_tb <= "00001000"; -- Rapport 25%

    wait for 10000 ns;
    OCR1x_in_tb <= "10001000"; -- Rapport 25%
    mode_sortie_tb <= "10"; -- déconnecte sortie inverse

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
      write(s, cpt_max_tb);write(s, string'("    "));
      write(s, OCR1x_in_tb);write(s, string'("    "));
      write(s, mode_sortie_tb);write(s, string'("    "));
      write(s, force_tb);write(s, string'("    "));
      write(s, active_tb);write(s, string'("    "));
      write(s, PFC_mode_tb);write(s, string'("    "));
      write(s, out_inverse_tb);write(s, string'("    "));
      write(s, clk_tb);write(s, string'("    "));
      write(s, rst_tb);write(s, string'("    "));
      write(s, OC1x_tb);write(s, string'("    "));
      write(s, OC1xbar_tb);write(s, string'("    "));
      writeline(machine_etat_file,s);
      temps := temps + dT;
    end if;
  end process resultats;

end architecture;
