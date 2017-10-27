library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity IOport is
  port (
    data_in: in std_logic_vector(7 downto 0);
    rw: in STD_LOGIC;
    data_out: out std_logic_vector(7 downto 0);
    clk: in STD_LOGIC;

    ioport : inout std_logic_vector(7 downto 0)
  );
end entity;

architecture arch of IOport is



begin

proc : process(clk)
begin
  if rw = '1' then --sortie
    ioport <= data_in;
  elsif rw = '0' then --entrée
    data_out <= ioport;
  end if;
end process;


end architecture;
