LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

ENTITY prediviseur_tb IS
END prediviseur_tb;

ARCHITECTURE behavior OF prediviseur_tb IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT prediviseur
    Generic(N : positive := 2);
    Port (  clk : in std_logic;
            rst : in std_logic;
            pow_div : in std_logic_vector(N-1 downto 0);
            clk_out : out std_logic
           );
    END COMPONENT;


   --Inputs
   signal clk_tb : std_logic := '0';
   signal rst_tb : std_logic := '1';
   signal pow_div_tb : std_logic_vector(1 downto 0);

 	--Outputs

  signal clk_out_tb : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant clk_te_period : time := 2 ns;

   signal clk_te : STD_LOGIC;

   constant T : real := 400.0; -- ns
   constant dT : real := 2.0; -- ns

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: prediviseur PORT MAP (
          clk => clk_tb,
          rst => rst_tb,
          pow_div => pow_div_tb,
          clk_out => clk_out_tb
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
      -- hold reset state for 100 ns.
      rst_tb <= '1';
      wait for 100 ns;

      pow_div_tb <= "00";
      rst_tb <= '0';
      wait for 1000 ns;

      pow_div_tb <= "01";
      wait for 1000 ns;

      pow_div_tb <= "10";
      wait for 1000 ns;

      pow_div_tb <= "11";
      wait for 1000 ns;

   end process;

   resultats: process(clk_te)
     file machine_etat_file: text open WRITE_MODE is "power_clock_divider.txt";
     variable s : line;
     variable temps :  real := 0.0;
   begin
     if rising_edge(clk_te) then
       write(s, temps);write(s, string'("    "));
       write(s, rst_tb);write(s, string'("    "));
       write(s, clk_tb);write(s, string'("    "));
       write(s, pow_div_tb);write(s, string'("    "));
       write(s, clk_out_tb);write(s, string'("    "));
       writeline(machine_etat_file,s);
       temps := temps + dT;
     end if;
   end process resultats;

END;
