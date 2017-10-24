library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Addr_Decoder is
  port (  data_out_percent : out std_logic_vector(7 downto 0);
          DTPS1X : out std_logic_vector(1 downto 0);
          data_IN, addr_IN : in std_logic_vector(7 downto 0);
          CS1X : out std_logic_vector(31 downto 0);
          CSA,CSB,rst_prediv : out std_logic; --PWM Select
          rst,clk : in std_logic);
end entity;

architecture arch_Addr_Decoder of Addr_Decoder is

  signal TCCR1A : std_logic_vector(7 downto 0);
  signal TCCR1B : std_logic_vector(7 downto 0);
  signal TCNT1 : std_logic_vector(7 downto 0);
  signal OCR1A : std_logic_vector(7 downto 0);
  signal TCCR1C : std_logic_vector(7 downto 0);
  signal TCCR1D : std_logic_vector(7 downto 0);

begin
  case addr_IN is
    when 0x"30" =>
    --écriture registre TCCR1A
      TCCR1A <= data_IN;
      case TCCR1A(7 downto 6) is
        --COM1A1 et COM1A0
        when "00" =>
          -- FAST PWM mode
          data_out_percent <= 0x"FF";
          CSA <= '1'; --il faudra déconnecter OC1A
        when "01" =>

        when "10" =>

      end case


    when 0x"2F" =>
    --ecriture TCCR1B
      TCCR1B <= data_IN;
      rst_prediv <= TCCR1B(6); --reset prediviseur
      DTPS1X <= TCCR1B(5 downto 4); --valeur du prédiviseur
      CS1X <= (others => '0');
      CS1X(3 downto 0) <= TCCR1B(3 downto 0);

    when 0x"2E" =>
    --mode TCNT1
      TCNT1 <= data_IN;

    when 0x"2D" =>
    --mode OCR1A
      OCR1A <= data_IN;

      value_compA <= data_IN;
    when 0x"27" =>
    --mode TCCR1C
      TCCR1C <= data_IN;
    when 0x"26" =>
    --mode TCCR1D
      TCCR1D <= data_IN;
      if data_IN(2 downto 0) == "0" then
      end if;
  end case
end architecture;
