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
--    Filename:                 tb_io_ctrl_sim.vhd                            --
--                                                                            --
--    Date of creation:         Fre Nov 24 2017                               --
--                                                                            --
--    Version:                  1                                             --
--                                                                            --
--    Date of latest Verison:                                                 --
--                                                                            --
--    Design Unit:              IO Control Unit (Simulation)                  --
--                                                                            --
--    Description:  The IO Control Unit is part of the calculator project.    --
--                  It manages the interface to the 7-sgement displays,       --
--                  the LED's the push buttons and the switches of the        --
--                  Digilent Basys3 FPGA board.                               --
--                                                                            --
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

architecture sim of tb_io_ctrl is

  component io_ctrl
  port(clk_i    :   in    std_logic;                    -- System clock (100 MHz)
       reset_i  :   in    std_logic;                    -- Asynchronous high active reset
       dig0_i   :   in    std_logic_vector(7 downto 0); -- State of 7 segments and decimal point
       dig1_i   :   in    std_logic_vector(7 downto 0); --  of respective Digit (Internal Logic)
       dig2_i   :   in    std_logic_vector(7 downto 0);
       dig3_i   :   in    std_logic_vector(7 downto 0);
       led_i    :   in    std_logic_vector(15 downto 0);-- State of 16 LED's (Internal Logic)
       sw_i     :   in    std_logic_vector(15 downto 0);-- State of the 16 switches
       pb_i     :   in    std_logic_vector(3 downto 0); -- State of the 4 Pushbuttons
       ss_o     :   out   std_logic_vector(7 downto 0); -- 7 segment display single elements
       ss_sel_o :   out   std_logic_vector(3 downto 0); -- Selection signal for 7 segment Digit
       led_o    :   out   std_logic_vector(15 downto 0);-- 16 LED's of the board
       swsync_o :   out   std_logic_vector(15 downto 0);-- Debounced switches (internal logic)
       pbsync_o :   out   std_logic_vector(3 downto 0));-- Debounced push buttons (internal logic)
   end component;

  signal clk_i    :   std_logic;                    -- System clock (100 MHz)
  signal reset_i  :   std_logic;                    -- Asynchronous high active reset
  signal dig0_i   :   std_logic_vector(7 downto 0); -- State of 7 segments and decimal point
  signal dig1_i   :   std_logic_vector(7 downto 0); --  of respective Digit (Internal Logic)
  signal dig2_i   :   std_logic_vector(7 downto 0);
  signal dig3_i   :   std_logic_vector(7 downto 0);
  signal led_i    :   std_logic_vector(15 downto 0);-- State of 16 LED's (Internal Logic)
  signal sw_i     :   std_logic_vector(15 downto 0);-- State of the 16 switches
  signal pb_i     :   std_logic_vector(3 downto 0); -- State of the 4 Pushbuttons
  signal ss_o     :   std_logic_vector(7 downto 0); -- 7 segment display single elements
  signal ss_sel_o :   std_logic_vector(3 downto 0); -- Selection signal for 7 segment Digit
  signal led_o    :   std_logic_vector(15 downto 0);-- 16 LED's of the board
  signal swsync_o :   std_logic_vector(15 downto 0);-- Debounced switches (internal logic)
  signal pbsync_o :   std_logic_vector(3 downto 0);-- Debounced push buttons (internal logic)

begin

  i_io_ctrl : io_ctrl
  port map
  (clk_i    => clk_i,
   reset_i  => reset_i,
   dig0_i   => dig0_i,
   dig1_i   => dig1_i,
   dig2_i   => dig2_i,
   dig3_i   => dig3_i,
   led_i    => led_i,
   sw_i     => sw_i,
   pb_i     => pb_i,
   ss_o     => ss_o,
   ss_sel_o => ss_sel_o,
   led_o    => led_o,
   swsync_o => swsync_o,
   pbsync_o => pbsync_o);

   p_clock : process
   begin
     clk_i <= '0';
     wait for 5 ns;
     clk_i <= '1';
     wait for 5 ns;
   end process;

   p_test : process
   begin
     reset_i <= '1';
     dig0_i <= "00000000";
     dig1_i <= "00000000";
     dig2_i <= "00000000";
     dig3_i <= "00000000";
     led_i <= "0000000000000000";
     pb_i <= "0000";
     sw_i <= "0000000000000000";
     wait for 2 ms;
     -- Digit Test
     reset_i <= '0';
     dig0_i <= "00101100";
     dig1_i <= "11010011";
     dig2_i <= "01101011";
     dig3_i <= "10000110";
     wait for 10 ms;
     -- SW Test
     sw_i <= "0000000000001000";
     wait for 10 ns;
     sw_i <= "0000000000000000";
     wait for 7 ns;
     sw_i <= "0000000000001000";
     wait for 8 ns;
     sw_i <= "0000000000000000";
     wait for 12 ns;
     sw_i <= "0000000000001000";
     wait for 3 ms;
     -- PB Test
     pb_i <= "0010";
     wait for 10 ns;
     pb_i <= "0000";
     wait for 7 ns;
     pb_i <= "0010";
     wait for 8 ns;
     pb_i <= "0000";
     wait for 12 ns;
     pb_i <= "0010";
     wait for 5 ms;
   end process;

end sim;
