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
--    Filename:                 calculator.vhd                                --
--                                                                            --
--    Date of creation:         Fre Nov 24 2017                               --
--                                                                            --
--    Version:                  1                                             --
--                                                                            --
--    Date of latest Verison:                                                 --
--                                                                            --
--    Design Unit:              Top Level calculator (Entity)                 --
--                                                                            --
--    Description:  The Top Level combines the io control, calc control and   --
--                  alu of the calculator project to the final calculator     --
--                                                                            --
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity calculator is
  port(clk_i      : in  std_logic;                      -- 1 MHz clock from the board
       reset_i    : in  std_logic;                      -- asynchronous reset, active high
       ss_sel_o   : out std_logic_vector(3 downto 0);   -- 7 segment select signal
       ss_o       : out std_logic_vector(7 downto 0);   -- led's of the 7 segment digits
       sw_i       : in  std_logic_vector(15 downto 0);  -- input of the 16 switches
       pb_i       : in  std_logic_vector(3 downto 0);   -- input of the 4 pushbuttons
       led_o      : out std_logic_vector(15 downto 0)); -- 16 led's of the board

end calculator;
