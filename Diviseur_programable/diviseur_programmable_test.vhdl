library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.all;

entity diviseur_programmable_tb is
end entity;

architecture tb_arch of diviseur_programmable_tb  is
  constant bits : integer := 16;

  constant bauds : integer := 115200;

  constant sysclk : real := 50.0e6 ; -- 50MHz
  constant N : integer :=  integer(sysclk / real(bauds));
  constant DIVTX : std_logic_vector(bits-1 downto 0) := std_logic_vector(to_unsigned(N,bits));



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

  signal clk_tb, rst_tb, phase_tb, polarite_tb, tc_tb, clk_out_tb : STD_LOGIC;
  signal clkdiv_tb: std_logic_vector(bits-1 downto 0);

  constant clk_period : time := 10 ns;
  constant clk_te_period : time := 2 ns;

  signal clk_te : STD_LOGIC;

  constant T : real := 400.0; -- ns
  constant dT : real := 2.0; -- ns

  begin

    clkDiv : diviseur_programmable generic map (Nbits => 16)
                                    port map(clk =>clk_tb,
                                            rst =>rst_tb,
                                            clkdiv =>clkdiv_tb,
                                            phase =>phase_tb,
                                            polarite =>polarite_tb,
                                            tc =>tc_tb,
                                            clk_out =>clk_out_tb);

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

    tim_proc : process
    begin
      clkdiv_tb <= DIVTX ;

      rst_tb <= '1';
      phase_tb <= '0';
      polarite_tb <= '0';
      wait for 20 ns;
      rst_tb <= '0';
      wait for 10000 ns;
      polarite_tb <= '1';
      phase_tb <= '1';

      wait for 10000 ns;
      clkdiv_tb <= "0000000000100000";

      wait for 20000 ns;
      rst_tb <= '1';
      wait for 20 ns;
    end process;



end architecture;
