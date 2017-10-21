library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Use ieee.std_logic_unsigned.all;

entity diviseur_programmable is
    Generic(Nbits : integer := 32);
    Port ( rst : in STD_LOGIC;
	       clk : in  STD_LOGIC;
	       division : in STD_LOGIC_VECTOR(Nbits-1 downto 0);
           tc : out STD_LOGIC);
end diviseur_programmable;

architecture architecture_diviseur of diviseur_programmable is

signal cpt : std_logic_vector(Nbits-1 downto 0);


begin

  -- compteur 0 a division
  comptage: process(clk,rst,division)
  begin
   if rst = '1' then
     cpt <= (others => '0');
   elsif rising_edge(clk) then     
    if cpt < division then
	    cpt <= cpt + 1;
	 else	
        cpt <= (others => '0');
	 end if;
	end if;
  end process comptage;
  
  -- impulsion de sortie a division
  retenue: process(cpt,division)
	begin
		if cpt=division then
			tc <= '1';
		else 
			tc <= '0';
		end if;
	end process retenue;  

end architecture_diviseur;

