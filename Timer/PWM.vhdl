library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity PWM is
  port (  OCR1x_in, TCNT1_in : in std_logic_vector(7 downto 0);
          mode_sortie : in std_logic_vector(1 downto 0);
          force, active, PFC_mode, out_inverse, rst, clk : in std_logic;
          OC1x, OC1xbar : out std_logic);
end entity;

architecture arch_PWM of PWM is
  -- signal cpt : std_logic_vector(7 downto 0);
  signal OC1x_interne : std_logic;

begin

  OC1x <= OC1x_interne;
  OC1xbar <= not OC1x_interne;

  pwm_proc : process(clk, rst, active)
    variable PFC_montant : natural;
  begin

    if rst = '1' then
      -- TCNT1_in <= (others => '0');
      PFC_montant := 1;
    elsif rising_edge(clk) then
      if (PFC_mode = '0') then --Fast PWM Mode
        if TCNT1_in < OCR1x_in then
          OC1x_interne <= '0';
          -- TCNT1_in <= std_logic_vector(unsigned(cpt) + 1);
        elsif (TCNT1_in < cpt_max) then
          OC1x_interne <= '1';
          -- TCNT1_in <= std_logic_vector(unsigned(cpt) + 1);
        else
          OC1x_interne <= '0';
          -- TCNT1_in <= (others => '0');
        end if;
      end if;
    elsif (PFC_mode = '1') then --Phase and frequency correct PWM
      if (TCNT1_in < OCR1x_in)  then
        OC1x_interne <= '0';
        if PFC_montant = 1 or  TCNT1_in = "00000000" then
          -- TCNT1_in <= std_logic_vector(unsigned(cpt) + 1);
          PFC_montant := 1;
        -- elsif PFC_montant = 0 then
          -- TCNT1_in <= std_logic_vector(unsigned(cpt) - 1);
        -- end if;
      elsif (TCNT1_in <= cpt_max) then
        OC1x_interne <= '1';
        -- if PFC_montant = 1 then
          -- TCNT1_in <= std_logic_vector(unsigned(cpt) + 1);
        if PFC_montant = 0 or TCNT1_in = cpt_max then
          -- TCNT1_in <= std_logic_vector(unsigned(cpt) - 1);
          PFC_montant := 0;
        end if;
      end if;
    end if;

--    if (active = '1') then
--      if ((mode_sortie = "01" and out_inverse = '0') or (mode_sortie = "11" and out_inverse = '1')) then
--        OC1x <= OC1x_interne;
--        OC1xbar <= not OC1x_interne;
--      elsif ((mode_sortie = "01" and out_inverse = '1') or (mode_sortie = "11" and out_inverse = '0')) then
--        OC1x <= not OC1x_interne;
--        OC1xbar <= OC1x_interne;
--      elsif (mode_sortie = "10"  and out_inverse = '0') then
--        OC1x <= OC1x_interne;
--        OC1xbar <= '0';
--      elsif (mode_sortie = "10"  and out_inverse = '1') then
--        OC1x <= '0';
--        OC1xbar <= OC1x_interne;
--      end if;
--    end if;
--    if (force ='1') then
--      OC1x <= '1';
--      OC1xbar <= '0';
--    end if;
  end process;
end architecture;
