library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Timer is
  port (  Data_in, adr_in: in std_logic_vector(7 downto 0);
          Rst, Clk : in std_logic;
          OC1A, OC1Abar, OC1C, OC1Cbar, OC1D, OC1Dbar : out std_logic);
end Timer;

architecture arch_timer of Timer is
    component PWM is
      Port(
        data_in_percent : in std_logic_vector(7 downto 0);
        rst, clk : in std_logic;
        clk_out : out std_logic
      );
    end component PWM;
begin
  PWM : PWM Port map(
    clk => Clk,
    rst => Rst,

  );

end architecture;
