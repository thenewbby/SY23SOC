library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity IO_interface is
  Generic (
  portA:  integer   := 16#1B#;
  ddrA:   integer   := 16#1A#;
  pinA:   integer   := 16#19#;
  portB:  integer   := 16#18#;
  ddrB:   integer   := 16#17#;
  pinB:   integer   := 16#16#
  );
  port (
    data_in: in std_logic_vector(7 downto 0);
    adr_in: in std_logic_vector(5 downto 0);
    rst: in std_logic;
    clk: in std_logic;

    data_out: out std_logic_vector(7 downto 0);

    portA_inout: inout std_logic_vector(7 downto 0);
    portB_inout: inout std_logic_vector(7 downto 0)
  );
end entity;


architecture arch of IO_interface is

signal portA_reg, portB_reg, pinA_reg, pinB_reg, ddrB_reg, ddrA_reg: std_logic_vector(7 downto 0);

component IOport is
  port (
    data_in: in std_logic_vector(7 downto 0);
    rw: in std_logic_vector(7 downto 0);
    data_out: out std_logic_vector(7 downto 0);
    clk: in STD_LOGIC;

    ioport : inout std_logic_vector(7 downto 0)
  );
end component;
begin

ioportA : IOport port map(
                          data_in => portA_reg,
                          rw => ddrA_reg,
                          data_out => pinA_reg,
                          clk => clk,
                          ioport => portA_inout
                          );

ioportB : IOport port map(
                          data_in => portB_reg,
                          rw => ddrB_reg,
                          data_out => pinB_reg,
                          clk => clk,
                          ioport => portB_inout
                          );

proc : process(clk,rst)
  variable adr_int : natural;
begin

  if rst = '1' then
    portA_reg <= (others =>'Z');
    ddrA_reg <= (others =>'0');
    -- pinA_reg <= (others =>'0');
    portB_reg <= (others =>'Z');
    ddrB_reg <= (others =>'0');
    -- pinB_reg <= (others =>'0');

  elsif rising_edge(clk) then
    adr_int := CONV_INTEGER(unsigned(adr_in));

    if adr_in = portA then
          portA_reg <= data_in;

    elsif adr_in = ddrA then
          ddrA_reg <= data_in;
    elsif adr_in = pinA then
          data_out <= pinA_reg;
    elsif adr_in = portB then
          portB_reg <= data_in;
    elsif adr_in = ddrB then
          ddrB_reg <= data_in;
    elsif adr_in = pinB then
          data_out <= pinB_reg;
    end if;

    bits : for i in 0 to 7 loop
      if ddrA_reg(i) = '0' then
        portA_reg(i) <= 'Z';

      end if;

      if ddrB_reg(i) = '0' then
        portB_reg(i) <= 'Z';

      end if;
    end loop;
  end if;
end process;
end architecture;
