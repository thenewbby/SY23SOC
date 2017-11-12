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

COMPONENT PWM
Port (cpt, OCR1x_in : in std_logic_vector(7 downto 0);
				-- data_out : out std_logic_vector(7 downto 0);
				mode_sortie : in std_logic_vector(1 downto 0);
				force, active, PFC_mode, out_inverse, rst, clk : in std_logic;
				OC1x, OC1xbar : out std_logic
);
end COMPONENT;

COMPONENT prediviseur
port (clk : in std_logic;
		rst,rst_addr : in std_logic;
		pow_div : in std_logic_vector(1 downto 0);
		clk_out : out std_logic);
	end component;

COMPONENT diviseurN4
Port (clk : in std_logic;
		rst : in std_logic;
		pow_div : in std_logic_vector(3 downto 0);
		clk_out : out std_logic);
	end component;

constant OCR1A : integer := BASE_ADDR ;
constant TCNT1 : integer := BASE_ADDR + 1;
constant TCCR1B : integer := BASE_ADDR + 2;
constant TCCR1A : integer := BASE_ADDR + 3;
constant TCCR1C : integer := BASE_ADDR - 6;
constant TCCR1D : integer := BASE_ADDR - 7;


signal reg_OCR1A : STD_LOGIC_VECTOR (7 downto 0);
signal reg_TCNT1 : STD_LOGIC_VECTOR (7 downto 0);
signal reg_TCCR1A : STD_LOGIC_VECTOR (7 downto 0);
signal reg_TCCR1B : STD_LOGIC_VECTOR (7 downto 0);
signal reg_TCCR1C : STD_LOGIC_VECTOR (7 downto 0);
signal reg_TCCR1D : STD_LOGIC_VECTOR (7 downto 0);
signal clk_predivDiv, clk_PWM : std_logic;



begin

pwm_1 : pwm port map(
  cpt => reg_TCNT1(7 downto 0),
  OCR1x_in => reg_OCR1A,
  mode_sortie => reg_TCCR1A(7 downto 6),
  force => reg_TCCR1A(3),
  active => reg_TCCR1A(1),
  PFC_mode => reg_TCCR1D(0),
  out_inverse => reg_TCCR1B(7),
  rst => Rst,
  clk => clk_PWM,
  OC1x => OC1A,
  OC1xbar => OC1Abar
  -- data_out => reg_TCNT1(7 downto 0)
);

prediv : prediviseur port map(
  rst_addr => reg_TCCR1B(6),
  rst => Rst,
  clk => clk,
  pow_div => reg_TCCR1B(5 downto 4),
  clk_out => clk_predivDiv
);

divGeneral : diviseurN4 port map(
	clk => clk_predivDiv,
	rst => Rst,
	pow_div => reg_TCCR1B (3 downto 0),
	clk_out => clk_PWM

);

  proc : process(clk, rst)
    variable adr_int : natural;
    variable rdwr : std_logic_vector(1 downto 0);
		variable PFC_montant : natural;
  begin

    if Rst = '1' then
			reg_TCNT1 <= (others => '0');

    elsif rising_edge(clk) then
      adr_int := TO_INTEGER(unsigned(addr));

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

			elsif adr_int = TCCR1D then

				if rdwr = "10" then
					ioread <= reg_TCCR1D;
				elsif rdwr = "01" then
					reg_TCCR1D <= iowrite;
				end if;
      end if;

			if (reg_TCCR1D(0) = '0') then --Fast PWM Mode
        reg_TCNT1 <= std_logic_vector(unsigned(reg_TCNT1) + 1);

			elsif (reg_TCCR1D(0) = '1') then --Phase and frequency correct PWM
				if (reg_TCNT1 < reg_OCR1A)  then
					if PFC_montant = 1 or  reg_TCNT1 = "00000000" then
						reg_TCNT1 <= std_logic_vector(unsigned(reg_TCNT1) + 1);
					elsif PFC_montant = 0 then
						reg_TCNT1 <= std_logic_vector(unsigned(reg_TCNT1) - 1);
					end if;
				elsif (reg_TCNT1 <= "11111111") then
					if PFC_montant = 1 then
						reg_TCNT1 <= std_logic_vector(unsigned(reg_TCNT1) + 1);
					elsif PFC_montant = 0 or reg_TCNT1 = "11111111" then
						reg_TCNT1 <= std_logic_vector(unsigned(reg_TCNT1) - 1);
					end if;
				end if;
			end if;
    end if;
end process;


end timer_architecture;
