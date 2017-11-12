library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
use work.all;

entity prediviseur is
Generic(N : positive := 2);
Port (	clk : in std_logic;
		rst : in std_logic;
		pow_div : in std_logic_vector(N-1 downto 0);
		clk_out : out std_logic
	 );
end prediviseur;

architecture Behavioral of prediviseur is

shared variable state : integer;
signal cpt, cpt_next, clk_div : integer;
signal clk_interne : std_logic;
signal null_vect : std_logic_vector(N-1 downto 0);
signal undet_vect : std_logic_vector(N-1 downto 0);
begin

counter : process(cpt, clk_div,pow_div)
begin

  clk_div <= 2**to_integer(unsigned(pow_div))-1;

 if cpt = clk_div then
     clk_interne <= '1';
     cpt_next <= 0;
 else
     cpt_next <= cpt +1;
     clk_interne <= '0';
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

synchro : process(clk, rst)
begin

	if rst = '1' then

		cpt <= 0;
		state := 0;

	else if rising_edge(clk) then

		cpt <= cpt_next;

		end if;
	end if;

end process synchro;

end Behavioral;
