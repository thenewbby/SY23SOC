LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

ENTITY Timer_tb IS
END Timer_tb;

ARCHITECTURE behavior OF Timer_tb IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT Timer
    Port (  clk : in  STD_LOGIC;
	         Rst : in  STD_LOGIC;
           addr : in  STD_LOGIC_VECTOR (5 downto 0);
           ioread : out  STD_LOGIC_VECTOR (7 downto 0);
           iowrite : in  STD_LOGIC_VECTOR (7 downto 0);
           rd : in  STD_LOGIC;
           wr : in  STD_LOGIC;
		       OC1A : out  STD_LOGIC;
		       OC1Abar : out  STD_LOGIC);
    END COMPONENT;


   --Inputs
   signal clk_tb : std_logic := '0';
   signal rst_tb : std_logic := '1';
   signal addr_tb : std_logic_vector(5 downto 0);
   signal ioread_tb, iowrite_tb  : std_logic_vector(7 downto 0);
   signal rd_tb, wr_tb : std_logic;
   signal OC1A_tb, OC1Abar_tb : std_logic;

  --Outputs

  signal clk_out_tb : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant clk_te_period : time := 2 ns;

   signal clk_te : STD_LOGIC;

   constant T : real := 400.0; -- ns
   constant dT : real := 2.0; -- ns

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: Timer PORT MAP (
          clk => clk_tb,
          Rst => rst_tb,
          addr => addr_tb,
          ioread => ioread_tb,
          iowrite => iowrite_tb,
          rd => rd_tb,
          wr => wr_tb,
          OC1A => OC1A_tb,
          OC1Abar => OC1Abar_tb
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
      wr_tb <= '1';
      rd_tb <= '0';
      wait for 100 ns;

      addr_tb <= "101101"; --16#2D# Registre OCR1A
      rst_tb <= '0';
      iowrite_tb <= "11100000"; --Envoie de la valeur 224/255
      wait for 20 ns;

      addr_tb <= "101110"; --16#2E# Init TCNT1
      iowrite_tb <= "00000000"; -- Compteur initialisé à 0
      wait for 20 ns;

      addr_tb <= "101111"; --16#2F# Init TCCR1B
      iowrite_tb <= "00100011"; -- prédiviseur par 2² et diviseur par 2²
      wait for 20 ns;

      addr_tb <= "110000"; --16#30# Init TCCR1A
      iowrite_tb <= "01000010"; --Comparateur A mode 01; Active mode PWMA
      wait for 20 ns;

      addr_tb <= "100110"; --16#26# Init TCCR1D
      iowrite_tb <= "00000000"; --Non utilisé
      wait for 20 ns;

      wr_tb <= '0';
      rd_tb <= '1'; -- Simultaion de lecture des registres
      addr_tb <= "101110"; -- demande de lecture du registre TCNT1
      wait for 100000 ns;
   end process;

   resultats: process(clk_te)
     file machine_etat_file: text open WRITE_MODE is "Timer.txt";
     variable s : line;
     variable temps :  real := 0.0;
   begin
     if rising_edge(clk_te) then
       write(s, temps);write(s, string'("    "));
       write(s, rst_tb);write(s, string'("    "));
       write(s, clk_tb);write(s, string'("    "));
       write(s, addr_tb);write(s, string'("    "));
       write(s, ioread_tb);write(s, string'("    "));
       write(s, iowrite_tb);write(s, string'("    "));
       write(s, rd_tb);write(s, string'("    "));
       write(s, wr_tb);write(s, string'("    "));
       write(s, OC1A_tb);write(s, string'("    "));
       write(s, OC1Abar_tb);write(s, string'("    "));
       writeline(machine_etat_file,s);
       temps := temps + dT;
     end if;
   end process resultats;

END;
