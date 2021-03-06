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
--    Filename:                 io_ctrl.vhd                                   --
--                                                                            --
--    Date of creation:         Fre Nov 24 2017                               --
--                                                                            --
--    Version:                  1                                             --
--                                                                            --
--    Date of latest Verison:                                                 --
--                                                                            --
--    Design Unit:              IO Control Unit (Entity)                      --
--                                                                            --
--    Description:  The IO Control Unit is part of the calculator project.    --
--                  It manages the interface to the 7-sgement displays,       --
--                  the LED's the push buttons and the switches of the        --
--                  Digilent Basys3 FPGA board.                               --
--                                                                            --
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity io_ctrl is

  port(clk_i    :   in    std_logic;                      -- System clock (100 MHz)
       reset_i  :   in    std_logic;                      -- Asynchronous high active reset
       dig0_i   :   in    std_logic_vector(7 downto 0);   -- State of 7 segments and decimal point
       dig1_i   :   in    std_logic_vector(7 downto 0);   --  of respective Digit (Internal Logic)
       dig2_i   :   in    std_logic_vector(7 downto 0);
       dig3_i   :   in    std_logic_vector(7 downto 0);
       led_i    :   in    std_logic_vector(15 downto 0);  -- State of 16 LED's (Internal Logic)
       sw_i     :   in    std_logic_vector(15 downto 0);  -- State of the 16 switches
       pb_i     :   in    std_logic_vector(3 downto 0);   -- State of the 4 Pushbuttons
       ss_o     :   out   std_logic_vector(7 downto 0);   -- 7 segment display single elements
       ss_sel_o :   out   std_logic_vector(3 downto 0);   -- Selection signal for 7 segment Digit
       led_o    :   out   std_logic_vector(15 downto 0);  -- 16 LED's of the board
       swsync_o :   out   std_logic_vector(15 downto 0);  -- Debounced switches (internal logic)
       pbsync_o :   out   std_logic_vector(3 downto 0));  -- Debounced push buttons (internal logic)

end io_ctrl;
