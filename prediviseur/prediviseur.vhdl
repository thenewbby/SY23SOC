library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.all;


entity prediviseur is
  port (  rst_addr_decoder, rst, clk : in std_logic;
          bus_div : in std_logic_vector(1 downto 0);
          clk_out : out std_logic);
end entity;

architecture arch_prediviseur of prediviseur is
  signal cpt : std_logic_vector(2 downto 0);
  signal cpt_max : std_logic_vector(2 downto 0);

begin
  affect_cpt_max : process(clk)
  begin
    if bus_div = "01" then
      cpt_max <= "001";
    elsif bus_div = "10" then
      cpt_max <= "010";
    elsif bus_div = "11" then
      cpt_max <= "100";
    end if;
  end process;

  comptage : process(clk)
  begin
    --if rising_edge(clk) then
    if rst = '1' or rst_addr_decoder = '1' then
      cpt <= (others => '0');
      clk_out <= '0';
    elsif bus_div = "00" then
      clk_out <= clk;
    end if;
    if cpt < std_logic_vector(unsigned(cpt_max) - 1) then
      cpt <= std_logic_vector(unsigned(cpt) + 1);
      clk_out <= '0';
    end if;

    if cpt = cpt_max then
      clk_out <= '1';
      cpt <= (others => '0');
  --  else
    --  clk_out <= 'Z';
    end if;
    --end if;
  end process;
end architecture;
