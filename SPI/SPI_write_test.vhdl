--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:   12:31:02 10/13/2017
-- Design Name:
-- Module Name:   /home/uvs/SY23/alexKyrie/echauffement/SPI/tb_spi_write.vhd
-- Project Name:  SPI
-- Target Device:
-- Tool versions:
-- Description:
--
-- VHDL Test Bench Created by ISE for module: spi_write
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes:
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation
-- simulation model.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;



ENTITY spi_write_tb IS
END spi_write_tb;

ARCHITECTURE behavior OF spi_write_tb IS
    constant bauds : integer := 115200;

    constant sysclk : real := 50.0e6 ; -- 50MHz
    constant N : integer :=  integer(sysclk / real(bauds));
    constant DIVTX : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(N,16));

    -- Component Declaration for the Unit Under Test (UUT)

    component spi_write is
        Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           spi_start : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
              clk_div : in  STD_LOGIC_VECTOR (15 downto 0);
           SPI_CS : out  STD_LOGIC;
           SPI_SCK : inout  STD_LOGIC;
           SPI_MOSI : out  STD_LOGIC);
        end component;


   --Inputs
   signal data_in_tb : std_logic_vector(7 downto 0) := (others => '0');
   signal spi_start_tb : std_logic := '0';
   signal rst_tb : std_logic := '0';
   signal clk_tb : std_logic := '0';
    signal clk_div_tb :  STD_LOGIC_VECTOR (15 downto 0);
    --BiDirs
   signal SPI_SCK_tb : std_logic;

     --Outputs
   signal SPI_CS_tb : std_logic;
   signal SPI_MOSI_tb : std_logic;

   constant clk_period : time := 20 ns;
   constant clk_te_period : time := 1000 ns;
   -- horloge echantillonnage
   signal clk_te : STD_LOGIC := '0';
   -- definitions pour la simulation
   constant T : real := 100.0 ; -- us
   constant dT : real := 1.0 ; -- us
BEGIN

    -- Instantiate the Unit Under Test (UUT)
   uut: spi_write PORT MAP (
          data_in => data_in_tb,
          spi_start => spi_start_tb,
          rst => rst_tb,
          clk => clk_tb,
          clk_div => clk_div_tb,
          SPI_CS => SPI_CS_tb,
          SPI_SCK => SPI_SCK_tb,
          SPI_MOSI => SPI_MOSI_tb
        );

   -- Clock process definitions
   clk_process :process
   begin
        clk_tb <= '0';
        wait for clk_period/2;
        clk_tb <= '1';
        wait for clk_period/2;
   end process;

   clk_te_process :process
   begin
        clk_te <= '0';
        wait for clk_te_period/2;
        clk_te <= '1';
        wait for clk_te_period/2;
   end process;


   -- Stimulus process
   stim_proc: process
   begin
      -- hold reset state for 100 ns.
        clk_div_tb <= DIVTX ;
        rst_tb <= '1';
        data_in_tb <= "10110111";
      wait for 100 ns;
        rst_tb <= '0';
        spi_start_tb <= '1';
      wait for 10000 ns;
        spi_start_tb <= '0';
      -- wait for 10000 ns;
      --   rst_tb <= '1';
      -- wait for 10000 ns;
      --   rst_tb <= '0';

      wait for clk_period*10000;
        data_in_tb <= "11010101";
      wait for 100 ns;
        spi_start_tb <= '1';
      wait for 10000 ns;
        spi_start_tb <= '0';


        spi_start_tb <= '0';
        -- rst_tb <= '1';
      -- insert stimulus here

      wait;
   end process;

END;
