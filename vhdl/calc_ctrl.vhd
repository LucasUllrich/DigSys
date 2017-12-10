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
--    Filename:                 calc_ctrl.vhd                                 --
--                                                                            --
--    Date of creation:         Fre Nov 24 2017   Entity                      --
--                                                                            --
--    Version:                  1                                             --
--                                                                            --
--    Date of latest Verison:                                                 --
--                                                                            --
--    Design Unit:              Calculator control unit                       --
--                                                                            --
--    Description:  The Calculator Control Unit is part of the calculator     --
--                  project. It manages the processing of the data provided   --
--                  by the IO Control Unit and controls the ALU of the        --
--                  Calculator.                                               --
--                                                                            --
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity calc_ctrl is
  port(clk_i      : in  std_logic;                        -- 1 MHz clock
       reset_i    : in  std_logic;                        -- asynchronous reset, high active
       swsync_i   : in  std_logic_vector(15 downto 0);    -- debounced status of the 16 switches
       pbsync_i   : in  std_logic_vector(3 downto 0);     -- debounced status of the 4 pushbuttons
       finished_i : in  std_logic;                        -- flag for finished calculation
       result_i   : in  std_logic_vector(15 downto 0);    -- result of the calculation
       sign_i     : in  std_logic;                        -- flag for a sign of the result
       overflow_i : in  std_logic;                        -- flag for overflow during calculation
       error_i    : in  std_logic;                        -- flag for an error during calculation
       op1_o      : out std_logic_vector(11 downto 0);    -- first operand for calculation
       op2_o      : out std_logic_vector(11 downto 0);    -- second operand for calculation
       optype_o   : out std_logic_vector(3 downto 0);     -- operation to be performed on operands
       start_o    : out std_logic;                        -- signal for alu to start calculation
       dig0_o     : out std_logic_vector(7 downto 0);     -- state of respective 7 segment display
       dig1_o     : out std_logic_vector(7 downto 0);
       dig2_o     : out std_logic_vector(7 downto 0);
       dig3_o     : out std_logic_vector(7 downto 0);
       led_o      : out std_logic_vector(15 downto 0));   -- state of the 16 LED's on the board
end calc_ctrl;
