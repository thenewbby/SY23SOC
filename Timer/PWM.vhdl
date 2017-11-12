library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity PWM is -- Tu utilisais PWM et pas PWM_1
  port (  cpt, OCR1x_in : in std_logic_vector(7 downto 0);
          -- data_out : out std_logic_vector(7 downto 0);
          mode_sortie : in std_logic_vector(1 downto 0);
          force, active, PFC_mode, out_inverse, rst, clk : in std_logic;
          OC1x, OC1xbar : out std_logic);
end entity;

architecture arch_PWM of PWM is

  --signal cpt : std_logic_vector(7 downto 0);
  signal OC1x_interne : std_logic;
  -- signal cpt_interne, cpt_interne_next : std_logic_vector(7 downto 0);
begin
  --if force = '1' generate
  --  OC1x <= '1';
  --end if;
  -- OC1x <= '0'; -- Ici, tu disais de mettre OC1x toujours à 0
  --OC1x <= OC1x_interne; -- J'ai cablé OC1x_interne à la sortie
  --OC1xbar <= not OC1x_interne; -- et son inverse


  pwm_proc : process(clk, rst, active)
    variable PFC_montant : natural;
  begin
    --OC1x <= '0';
    -- cpt_interne <= cpt;
    if rst = '1' then
      -- cpt_interne_next <= (others => '0');
      PFC_montant := 1;
    elsif rising_edge(clk) then
      if (PFC_mode = '0') then --Fast PWM Mode
        -- cpt_interne_next <= std_logic_vector(unsigned(cpt_interne) + 1);

        if cpt < OCR1x_in then
          OC1x_interne <= '0';
        elsif (cpt < "11111111") then
          OC1x_interne <= '1';
        --else
        --  OC1x_interne <= '0';
        --  cpt_interne <= (others => '0');
        end if;
      end if;
   elsif (PFC_mode = '1') then --Phase and frequency correct PWM
     if (cpt < OCR1x_in)  then
       OC1x_interne <= '0';
       if PFC_montant = 1 or  cpt = "00000000" then
        --  cpt_interne_next <= std_logic_vector(unsigned(cpt_interne) + 1);
         PFC_montant := 1;
      --  elsif PFC_montant = 0 then
        --  cpt_interne_next <= std_logic_vector(unsigned(cpt_interne) - 1);
       end if;
     elsif (cpt <= "11111111") then
       OC1x_interne <= '1';
      --  if PFC_montant = 1 then
        --  cpt_interne_next <= std_logic_vector(unsigned(cpt_interne) + 1);
       if PFC_montant = 0 or cpt = "11111111" then
        --  cpt_interne_next <= std_logic_vector(unsigned(cpt_interne) - 1);
         PFC_montant := 0;
       end if;
     end if;
    end if;

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
    if (force ='1') then
      OC1x <= '1';
      OC1xbar <= '0';
    end if;
    -- data_out <= cpt_interne_next;

  end process;
end architecture;
