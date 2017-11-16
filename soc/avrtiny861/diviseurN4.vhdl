library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.all;

entity diviseurN4 is
Generic(N : positive := 4);
Port (
		--Inputs
		clk : in std_logic;
		rst : in std_logic;
		pow_div : in std_logic_vector(N-1 downto 0);
		--Outputs
		clk_out : out std_logic
	 );
end diviseurN4;

architecture Behavioral of diviseurN4 is

--definition des signaux
signal cpt, cpt_next, clk_div : integer;
signal clk_interne : std_logic;
signal null_vect : std_logic_vector(N-1 downto 0);
signal undet_vect : std_logic_vector(N-1 downto 0);
begin

	--liaison physique
	null_vect <= (others => '0');
	clk_out <= clk_interne;

	--process counter
counter : process(clk, rst, cpt, clk_div,pow_div, clk_interne)
begin

	--reset
	if rst = '1' then
		cpt_next <= 0;
		cpt <= 0;
	else
		--sur le front montant de la clk
		if rising_edge(clk) then
			--on passe sur l'etat suivant
			cpt <= cpt_next;
		end if;

		--division de la clock
  	if (pow_div = null_vect) then
    	clk_interne <= '0';
  	else
    	clk_div <= 2**(to_integer(unsigned(pow_div)-1));

			if cpt = clk_div then
         clk_interne <= '1';
         cpt_next <= 0;
     	else
         cpt_next <= cpt +1;
         clk_interne <= '0';
     	end if;

	 end if;
  end if;
end process counter;

end Behavioral;
