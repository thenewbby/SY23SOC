library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

--IF 0 => Z
entity IOport is
  port (
    data_in: in std_logic_vector(7 downto 0);
    rw: in std_logic_vector(7 downto 0);
    data_out: out std_logic_vector(7 downto 0);
    clk: in STD_LOGIC;

    ioport : inout std_logic_vector(7 downto 0)
  );
end entity;

architecture arch of IOport is

begin

proc : process(clk)
begin
  bits : for i in 0 to 7 loop
    if rw(i) = '1' then --sortie
      ioport(i) <= data_in(i);
      data_out(i) <= '0';
    elsif rw(i) = '0' then --entrée
      data_out(i) <= ioport(i);
    end if;
  end loop;
end process;


end architecture;
