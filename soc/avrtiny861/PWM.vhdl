library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity PWM is
  port (
          --Inputs
          cpt, OCR1x_in : in std_logic_vector(7 downto 0);
          mode_sortie : in std_logic_vector(1 downto 0);
          force, active, PFC_mode, out_inverse, rst, clk : in std_logic;
          --Outputs
          OC1x, OC1xbar : out std_logic);
end entity;

architecture arch_PWM of PWM is
  --definition du signal
  signal OC1x_interne : std_logic;

begin

  pwm_proc : process(clk, rst, active)
    variable PFC_montant : natural;
  begin
    --reset
    if rst = '1' then
      PFC_montant := 1;
    --sur le front montant
    elsif rising_edge(clk) then

      if (PFC_mode = '0') then --Fast PWM Mode
        if cpt < OCR1x_in then
          OC1x_interne <= '0';
        else
          OC1x_interne <= '1';
        end if;
      end if;
    end if;

    --rafraichissement de la sortie
    if (active = '1') then
      if ((mode_sortie = "01" and out_inverse = '0') or (mode_sortie = "11" and out_inverse = '1')) then
        OC1x <= OC1x_interne;
        OC1xbar <= not OC1x_interne;
      elsif ((mode_sortie = "01" and out_inverse = '1') or (mode_sortie = "11" and out_inverse = '0')) then
        OC1x <= not OC1x_interne;
        OC1xbar <= OC1x_interne;
      elsif (mode_sortie = "10"  and out_inverse = '0') then
        OC1x <= OC1x_interne;
        OC1xbar <= '0';
      elsif (mode_sortie = "10"  and out_inverse = '1') then
        OC1x <= '0';
        OC1xbar <= OC1x_interne;
      end if;
    end if;

    -- sortie force
    if (force ='1') then
      OC1x <= '1';
      OC1xbar <= '0';
    end if;
  end process;
end architecture;
