library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity PWM is
-- Pour comprendre le rôle de chaque signal, consulter le fichier Timer.vhdl,
-- Section Port map du composant
  port (
          --Inputs
          cpt, OCR1x_in : in std_logic_vector(7 downto 0);
          mode_sortie : in std_logic_vector(1 downto 0);
          force, active, PFC_mode, out_inverse, rst, clk : in std_logic;
          --Outputs
          data_out : out std_logic_vector(7 downto 0);
          OC1x, OC1xbar : out std_logic);
end entity;

architecture arch_PWM of PWM is

  --definition des signaux
  signal OC1x_interne : std_logic;
  signal cpt_interne, cpt_interne_next : std_logic_vector(7 downto 0);
begin

  -- definition du process PWM
  pwm_proc : process(clk, rst, active)
    variable PFC_montant : natural;
  begin
    cpt_interne <= cpt;
    -- reset
    if rst = '1' then
      cpt_interne_next <= (others => '0');
      PFC_montant := 1;
    --sur le front montant
    elsif rising_edge(clk) then

      if (PFC_mode = '0') then --Fast PWM Mode
        cpt_interne_next <= std_logic_vector(unsigned(cpt_interne) + 1);
        if cpt_interne < OCR1x_in then
          OC1x_interne <= '0';
        elsif (cpt_interne < "11111111") then
          OC1x_interne <= '1';
        end if;
      end if;

   elsif (PFC_mode = '1') then --Phase and frequency correct PWM
     if (cpt_interne < OCR1x_in)  then
       OC1x_interne <= '0';
       if PFC_montant = 1 or  cpt = "00000000" then
         cpt_interne_next <= std_logic_vector(unsigned(cpt_interne) + 1);
         PFC_montant := 1;
       elsif PFC_montant = 0 then
         cpt_interne_next <= std_logic_vector(unsigned(cpt_interne) - 1);
       end if;
     elsif (cpt_interne <= "11111111") then
       OC1x_interne <= '1';
       if PFC_montant = 1 then
         cpt_interne_next <= std_logic_vector(unsigned(cpt_interne) + 1);
       elsif PFC_montant = 0 or cpt = "11111111" then
         cpt_interne_next <= std_logic_vector(unsigned(cpt_interne) - 1);
         PFC_montant := 0;
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

    --cas sortie forcee
    if (force ='1') then
      OC1x <= '1';
      OC1xbar <= '0';
    end if;

    --sortie compteur
    data_out <= cpt_interne_next;
  end process;
end architecture;
