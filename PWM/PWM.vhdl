library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity PWM is
  port (  data_in_percent : in std_logic_vector(7 downto 0);
          rst, clk : in std_logic;
          clk_out : out std_logic
  );
end entity;

architecture arch_PWM of PWM is

  signal cpt : std_logic_vector(7 downto 0);

begin

  pwm_proc : process(clk, rst)
  begin
    if rst = '1' then
      cpt <= (others => '0');
    elsif rising_edge(clk) then
      if (cpt < data_in_percent) then
        clk_out <= '1';
      else
        clk_out <= '0';
      end if;
      cpt <= std_logic_vector(unsigned(cpt) + 1);
    end if;
  end process;

end architecture;
