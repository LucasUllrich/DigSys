--------------------------------------------------------------------------------
--                                                                            --
--  XXXXXXX  X      X  XXXXXXXXX  X         X       XXXXXXXX   XXXXXXX        --
--  X        X      X      X      X         X       X          X       X      --
--  X        X      X      X      X         X       X          X       X      --
--  X        X      X      X      X         X       X          X       X      --
--  XXXXXX   XXXXXXXX      X      X         X  XXX  XXXXXXXX   X       X      --
--  X        X      X      X      X    X    X              X   X       X      --
--  X        X      X      X      X   X X   X              X   X       X      --
--  X        X      X      X      X X     X X              X   X       X      --
--  X        X      X      X      X         X       XXXXXXXX   XXXXXXX        --
--                                                                            --
--      F A C H H O C H S C H U L E  -  T E C H N I K U M   W I E N           --
--                                                                            --
--                      Embedded Systems Department                           --
--                                                                            --
--------------------------------------------------------------------------------
--                                                                            --
--    Author:                   Lucas Ullrich                                 --
--                                                                            --
--    Filename:                 tb_calculator_sim.vhd                         --
--                                                                            --
--    Date of creation:         Fre Nov 24 2017                               --
--                                                                            --
--    Version:                  1                                             --
--                                                                            --
--    Date of latest Verison:                                                 --
--                                                                            --
--    Design Unit:              Top Level calculator (TB Simulation)          --
--                                                                            --
--    Description:  The Top Level combines the io control, calc control and   --
--                  alu of the calculator project to the final calculator     --
--                                                                            --
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

architecture sim of tb_calculator is

  component calculator
  port(clk_i      : in  std_logic;                      -- 1 MHz clock from the board
       reset_i    : in  std_logic;                      -- asynchronous reset, active high
       ss_sel_o   : out std_logic_vector(3 downto 0);   -- 7 segment select signal
       ss_o       : out std_logic_vector(7 downto 0);   -- led's of the 7 segment digits
       sw_i       : in  std_logic_vector(15 downto 0);  -- input of the 16 switches
       pb_i       : in  std_logic_vector(3 downto 0);   -- input of the 4 pushbuttons
       led_o      : out std_logic_vector(15 downto 0)); -- 16 led's of the board
   end component;


  signal clk_i      : std_logic;
  signal reset_i    : std_logic;
  signal ss_sel_o   : std_logic_vector(3 downto 0);
  signal ss_o       : std_logic_vector(7 downto 0);
  signal sw_i       : std_logic_vector(15 downto 0);
  signal pb_i       : std_logic_vector(3 downto 0);
  signal led_o      : std_logic_vector(15 downto 0);

begin

  i_calculator : calculator
  port map(clk_i     => clk_i,
           reset_i   => reset_i,
           ss_sel_o  => ss_sel_o,
           ss_o      => ss_o,
           sw_i      => sw_i,
           pb_i      => pb_i,
           led_o     => led_o);


  p_clock : process
  begin
    clk_i <= '1';
    wait for 5 ns;
    clk_i <= '0';
    wait for 5 ns;
  end process;


  p_test : process
  begin
    reset_i <= '1';
    pb_i <= "0000";
    sw_i <= "0000000000000000";
    wait for 50 ns;
    reset_i <= '0';
    wait for 50 ns;
    ------------------------
    -- 0 + 0
    -----------------------
    -- OP1
    sw_i <= "0000000000000000";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- OP2
    sw_i <= "0000000000000000";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- +
    sw_i <= "0000000000000000";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- wait for result;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;

    ------------------------
    -- 1 + 1
    -----------------------
    -- OP1
    sw_i <= "0000000000000001";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- OP2
    sw_i <= "0000000000000001";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- +
    sw_i <= "0000000000000000";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- wait for result;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;

    ------------------------
    -- 42 + 127 = 169
    -----------------------
    -- OP1
    sw_i <= "0000000000101010";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- OP2
    sw_i <= "0000000001111111";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- +
    sw_i <= "0000000000000000";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- wait for result;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;

    ------------------------
    -- 0 ^ 2
    -----------------------
    -- OP1
    sw_i <= "0000000000000001";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- ^ 2
    sw_i <= "0101000000000000";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- wait for result;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;

    ------------------------
    -- 1 ^ 2
    -----------------------
    -- OP1
    sw_i <= "0000000000000001";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- ^ 2
    sw_i <= "0101000000000000";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- wait for result;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;

    ------------------------
    -- 42 ^ 2 = 1764
    -----------------------
    -- OP1
    sw_i <= "0000000000101010";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- ^ 2
    sw_i <= "0101000000000000";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- wait for result;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;

    ------------------------
    -- 260 ^ 2 = overflow
    -----------------------
    -- OP1
    sw_i <= "0000000100000100";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- ^ 2
    sw_i <= "0101000000000000";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- wait for result;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;

    ------------------------
    -- NOT all 0
    -----------------------
    -- OP1
    sw_i <= "0000000000000000";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- ^ 2
    sw_i <= "1000000000000000";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- wait for result;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;

    ------------------------
    -- NOT all 1
    -----------------------
    -- OP1
    sw_i <= "0000111111111111";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- ^ 2
    sw_i <= "1000000000000000";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- wait for result;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;

    ------------------------
    -- NOT 110001010011 = 001110101100
    -----------------------
    -- OP1
    sw_i <= "0000110001010101";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- ^ 2
    sw_i <= "1000000000000000";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- wait for result;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;

    ------------------------
    -- all 0 XOR all 0 = all 0
    -----------------------
    -- OP1
    sw_i <= "0000000000000000";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- OP2
    sw_i <= "0000000000000000";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- +
    sw_i <= "1011000000000000";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- wait for result;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;

    ------------------------
    -- all 1 XOR all 1 = all 0
    -----------------------
    -- OP1
    sw_i <= "0000111111111111";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- OP2
    sw_i <= "0000111111111111";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- +
    sw_i <= "1011000000000000";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- wait for result;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;

    ------------------------
    -- all 0 XOR all 1
    -----------------------
    -- OP1
    sw_i <= "0000000000000000";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- OP2
    sw_i <= "0000111111111111";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- +
    sw_i <= "1011000000000000";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- wait for result;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;

    ------------------------
    -- 100010011100 XOR
    -- 010010101110 = 110000110010
    -----------------------
    -- OP1
    sw_i <= "0000100010011100";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- OP2
    sw_i <= "0000010010101110";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- +
    sw_i <= "0000000000000000";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- wait for result;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;

    ------------------------
    -- midway reset
    -----------------------
    reset_i <= '1';
    wait for 10 ms;
    reset_i <= '0';
    wait for 10 ms;

    ------------------------
    -- produce error by wrong optype
    -----------------------
    -- OP1
    sw_i <= "0000100010011100";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- OP2
    sw_i <= "0000010010101110";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- +
    sw_i <= "0110000000000000";
    wait for 10 ms;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;
    -- wait for result;
    pb_i <= "0001";
    wait for 10 ms;
    pb_i <= "0000";
    wait for 10 ms;

  end process;


end sim;
