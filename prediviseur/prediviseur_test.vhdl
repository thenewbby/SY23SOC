--test bench file for prediviseur component
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;
use WORK.all;

entity prediviseur_test is
end entity;

architecture tb_arch of prediviseur_test  is
  component prediviseur is
  port (rst_addr_decoder, rst, clk : in std_logic;
          bus_div : in std_logic_vector(1 downto 0);
          clk_out : out std_logic);
  end component;

  signal rst_addr_decoder_tb, rst_tb, clk_tb, clk_out_tb : std_logic;
  signal bus_div_tb : std_logic_vector(1 downto 0);

  constant clk_period : time := 10 ns;
  constant clk_te_period : time := 2 ns;

  signal clk_te : STD_LOGIC;

  constant T : real := 400.0; -- ns
  constant dT : real := 2.0; -- ns
  
begin

end architecture;
