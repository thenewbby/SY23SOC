library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
use work.all;

entity diviseurN4 is
Generic(N : positive := 4);
Port (	clk : in std_logic;
		rst : in std_logic;
		pow_div : in std_logic_vector(N-1 downto 0);
		clk_out : out std_logic
	 );
end diviseurN4;

architecture Behavioral of diviseurN4 is

shared variable state : integer;

signal cpt, cpt_next, clk_div : integer;
signal clk_interne : std_logic;
signal null_vect : std_logic_vector(N-1 downto 0);
signal undet_vect : std_logic_vector(N-1 downto 0);

begin
	null_vect <= (others => '0');
	undet_vect <= (others => 'U');

counter : process(rst, clk, cpt, clk_div, pow_div)
begin

	if rst = '1' then

			cpt_next <= 0;
			state:=0;

		else if rising_edge(clk) then

			cpt <= cpt_next;

		  if (pow_div = null_vect) or (pow_div = undet_vect)then
		    clk_interne <= '0';
  		else
    		clk_div <= 2**(to_integer(unsigned(pow_div)) -1);

     		if cpt = clk_div then
         	clk_interne <= '1';
         	cpt_next <= 0;
     		else
         	cpt_next <= cpt +1;
         	clk_interne <= '0';
     		end if;
	 		end if;
		end if;
  end if;
end process counter;

clock_out : process(clk_interne)
begin
  if rising_edge(clk_interne) and state = 1 then
      clk_out <= '0';
			state := 0;
	elsif rising_edge(clk_interne) and state = 0 then
		clk_out <= '1';
		state := 1;
	end if;
end process;


end Behavioral;
