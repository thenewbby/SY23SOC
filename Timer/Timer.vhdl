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
  -- cpt_max => ,
  OCR1x_in => reg_OCR1A,
  mode_sortie => reg_TCCR1A(7 downto 6),
  force => ,
  active => ,
  PFC_mode => ,
  out_inverse => ,
  rst => Rst,
  clk => clk,
  OC1x => OC1A,
  OC1xbar => OC1Abar
);

  proc : process(clk, rst)
    variable adr_int : natural;
    variable rdwr : std_logic_vector(1 downto 0);
		variable PFC_montant : natural;
  begin

    if Rst = '1' then
			reg_TCNT1 <= (others => '0');

    elsif rising_edge(clk) then
      adr_int := CONV_INTEGER(unsigned(addr));
      rdwr := rd & wr;
      if adr_int = OCR1A then

        if rdwr = "10" then
          ioread <= reg_OCR1A;
        elsif rdwr = "01" then
          reg_OCR1A <= iowrite;
        end if;

      elsif adr_int = reg_TCNT1 then

        if rdwr = "10" then
          ioread <= reg_reg_TCNT1;
        elsif rdwr = "01" then
          reg_reg_TCNT1 <= iowrite;
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

				if (PFC_mode = '0') then --Fast PWM Mode
	          reg_TCNT1 <= std_logic_vector(unsigned(cpt) + 1);
	      end if;
	    elsif (PFC_mode = '1') then --Phase and frequency correct PWM
	      if (reg_TCNT1 < OCR1x_in)  then
	        if PFC_montant = 1 or  reg_TCNT1 = "00000000" then
	          reg_TCNT1 <= std_logic_vector(unsigned(cpt) + 1);
	        elsif PFC_montant = 0 then
	          reg_TCNT1 <= std_logic_vector(unsigned(cpt) - 1);
	        end if;
	      else
	        if PFC_montant = 1 then
	          reg_TCNT1 <= std_logic_vector(unsigned(cpt) + 1);
	        elsif PFC_montant = 0 or reg_TCNT1 = cpt_max then
	          reg_TCNT1 <= std_logic_vector(unsigned(cpt) - 1);
	        end if;
	      end if;

      end if;

    end if;
end process;


end timer_architecture;
