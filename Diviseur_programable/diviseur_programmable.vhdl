library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Use ieee.std_logic_unsigned.all;

-- diviseur programmable
-- clk : horloge systeme
-- clkdiv : vecteur pour la division
-- phase : choix du front de clk_out
-- polarite : inversion (1) ou non (0) de clk_out
-- tc : impulsion de largeur clk sur le front montant ou descendant de clk_out
-- clk_out : horloge divisee de rapport  cyclique 1/2
entity diviseur_programmable is
    Generic(Nbits : integer := 32);
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clkdiv : in std_logic_vector(Nbits-1 downto 0);
           phase : in STD_LOGIC;
           polarite : in STD_LOGIC;
           tc : out  STD_LOGIC;
           clk_out : out  STD_LOGIC);
end diviseur_programmable;

architecture architecture_diviseur_programmable of diviseur_programmable is


signal cpt : std_logic_vector(Nbits-1 downto 0);
signal clk_pol : std_logic;
signal clk_div : std_logic_vector(Nbits-1 downto 0);
-- un signal par phase
signal clk_div1,clk_div2 : std_logic_vector(Nbits-1 downto 0);

begin

  -- comptage
  comptage: process(clk)
  begin
   if rising_edge(clk) then
	 if rst = '1' then
	    cpt <= (others => '0');
    elsif cpt < clkdiv-1 then
	    cpt <= cpt + 1;
	 else
        cpt <= (others => '0');
	 end if;
	end if;
  end process comptage;

  --  impulsion et signal de sortie
  retenue: process(cpt)
	begin
		if cpt=clk_div then -- impulsion en fin
			tc <= '1';
		else
			tc <= '0';
		end if;
		-- 0 entre 0 et 50%, 1 entre 50% et 100%
		if cpt >= 0 and cpt <= (clk_div2) then
		   clk_pol <= '0';
		else
		   clk_pol <= '1';
        end if;
	end process retenue;

	-- inversion ou non du signal de sortie
	clk_out <= clk_pol xor polarite;

	-- calcul des impulsions de sortie front montant ou descendant
	clk_div1 <= clkdiv-1;
	clk_div2 <= '0' & clk_div1(Nbits-1 downto 1);

	-- choix de l'impulsion en fonction de la phase
	clk_div <= clk_div1 when phase = '0' else
	           clk_div2;


end architecture_diviseur_programmable;
