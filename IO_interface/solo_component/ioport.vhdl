library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity ioport is
	 Generic (BASE_ADDR	: integer := 16#19#);
    Port (
						--Inputs
						clk : in  STD_LOGIC;
	       		Rst : in  STD_LOGIC;
           	addr : in  STD_LOGIC_VECTOR (5 downto 0);
           	iowrite : in  STD_LOGIC_VECTOR (7 downto 0);
           	rd : in  STD_LOGIC;
           	wr : in  STD_LOGIC;
						--Outputs
						ioread : out  STD_LOGIC_VECTOR (7 downto 0);
						--in/out-puts
		   			ioport : inout  STD_LOGIC_VECTOR (7 downto 0));
end ioport;

architecture ioport_architecture of ioport is

--definitions des adresses des registres
constant PORT_ADDR : integer := BASE_ADDR + 2;
constant DDR_ADDR : integer := BASE_ADDR + 1;
constant PIN_ADDR : integer := BASE_ADDR;

--definitions des registres
signal port_reg, pin_reg, ddr_reg: std_logic_vector(7 downto 0);

begin

	  proc : process(clk,Rst)
	    variable adr_int : natural;
	    variable rdwr : std_logic_vector(1 downto 0);

	  begin

			--reset
	    if Rst = '1' then
	      ddr_reg <= (others =>'0');

	    elsif rising_edge(clk) then
	      adr_int := CONV_INTEGER(unsigned(addr));
	      rdwr := rd & wr;

				--bloc read/write des registres
	      if addr = PORT_ADDR then
							if rdwr = "10" then
								ioread <= port_reg;
							elsif rdwr = "01" then
								port_reg <= iowrite;
							end if;
	      elsif addr = DDR_ADDR then
							if rdwr = "10" then
								ioread <= ddr_reg;
							elsif rdwr = "01" then
								ddr_reg <= iowrite;
							end if;
	      elsif addr = PIN_ADDR then
							if rdwr = "10" then
								ioread <= pin_reg;
							end if;
	      end if;

				--mise à jours du port
	      read_write : for i in 0 to 7 loop
	        if ddr_reg(i) = '1' then --sortie
	          ioport(i) <= port_reg(i);
	          pin_reg(i) <= '0';
	        elsif ddr_reg(i) = '0' then --entrée
						port_reg(i) <= 'Z';
	          pin_reg(i) <= ioport(i);
	        end if;
	      end loop;
	    end if;
	  end process;

end ioport_architecture;
