library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity timer is
	 Generic (BASE_ADDR	: integer := 16#2D#);
    Port ( clk : in  STD_LOGIC;
	       Rst : in  STD_LOGIC;
           addr : in  STD_LOGIC_VECTOR (5 downto 0);
           ioread : out  STD_LOGIC_VECTOR (7 downto 0);
           iowrite : in  STD_LOGIC_VECTOR (7 downto 0);
           rd : in  STD_LOGIC;
           wr : in  STD_LOGIC;
		   OC1A : out  STD_LOGIC;
		   OC1Abar : out  STD_LOGIC);
end timer;

architecture timer_architecture of timer is



constant OCR1A : integer := BASE_ADDR ;
constant TCNT1 : integer := BASE_ADDR + 1;
constant TCCR1B : integer := BASE_ADDR + 2;
constant TCCR1A : integer := BASE_ADDR + 3;

signal reg_OCR1A : STD_LOGIC_VECTOR (7 downto 0);
signal reg_TCNT1 : STD_LOGIC_VECTOR (7 downto 0);
signal reg_TCCR1A : STD_LOGIC_VECTOR (7 downto 0);
signal reg_TCCR1B : STD_LOGIC_VECTOR (7 downto 0);


begin

pwm_1 : pwm port map(
  cpt_max => ,
  OCR1x_in => ,
  mode_sortie => ,
  force => ,
  active => ,
  PFC_mode => ,
  out_inverse => ,
  rst => ,
  clk => ,
  OC1x => OC1A,
  OC1xbar => OC1Abar
);

  proc : process(clk, rst)
    variable adr_int : natural;
    variable rdwr : std_logic_vector(1 downto 0);
  begin

    if Rst = '1' then


    elsif rising_edge(clk) then
      adr_int := CONV_INTEGER(unsigned(addr));
      rdwr := rd & wr;
      if adr_int = OCR1A then

        if rdwr = "10" then
          ioread <= reg_OCR1A;
        elsif rdwr = "01" then
          reg_OCR1A <= iowrite;
        end if;

      elsif adr_int = TCNT1 then

        if rdwr = "10" then
          ioread <= reg_TCNT1;
        elsif rdwr = "01" then
          reg_TCNT1 <= iowrite;
        end if;

      elsif adr_int = TCCR1B then

        if rdwr = "10" then
          ioread <= reg_TCCR1B;
        elsif rdwr = "01" then
          reg_TCCR1B <= iowrite;
        end if;

      elsif adr_int = TCCR1A then

        if rdwr = "10" then
          ioread <= reg_TCCR1A;
        elsif rdwr = "01" then
          reg_TCCR1A <= iowrite;
        end if;

      end if;

    end if;
end process;


end timer_architecture;
