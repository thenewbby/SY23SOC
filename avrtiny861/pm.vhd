library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pm is
	Port (
           clk    : in std_logic;
           Rst    : in std_logic;
           PM_A   : in std_logic_vector(15 downto 0);
           PM_Drd : out std_logic_vector(15 downto 0));
end pm;

architecture Arch of pm is

   type PM_mem_type is array(0 to 85) of std_logic_vector(15 downto 0);
   signal PM_mem : PM_mem_type := (
-- begin of program words-----
     x"C012", x"C019", x"C018", x"C017", x"C016", x"C015", x"C014", x"C013",
     x"C012", x"C011", x"C010", x"C00F", x"C00E", x"C00D", x"C00C", x"C00B",
     x"C00A", x"C009", x"C008", x"2411", x"BE1F", x"E5CF", x"E0D2", x"BFDE",
     x"BFCD", x"D031", x"C039", x"CFE4", x"930F", x"931F", x"93CF", x"93DF",
     x"D000", x"D000", x"B7CD", x"B7DE", x"8219", x"821A", x"821B", x"821C",
     x"8219", x"821A", x"821B", x"821C", x"8109", x"811A", x"812B", x"813C",
     x"1706", x"0717", x"0728", x"0739", x"F468", x"8109", x"811A", x"812B",
     x"813C", x"5F0F", x"4F1F", x"4F2F", x"4F3F", x"8309", x"831A", x"832B",
     x"833C", x"CFEA", x"900F", x"900F", x"900F", x"900F", x"91DF", x"91CF",
     x"911F", x"910F", x"9508", x"E0C0", x"BBCB", x"EA60", x"E876", x"E081",
     x"E090", x"DFCA", x"5FCF", x"CFF8", x"94F8", x"CFFF");
-- end of program words -----

begin

   pmproc : process (clk)
     variable a_int : natural;
   begin
     if (clk'event and clk='1') then
        a_int := CONV_INTEGER(PM_A);
        PM_Drd <= PM_mem(a_int);
     end if;
  end process pmproc;

end architecture Arch;
