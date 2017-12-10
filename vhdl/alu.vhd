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
--    Filename:                 alu.vhd                                       --
--                                                                            --
--    Date of creation:         Fre Nov 24 2017                               --
--                                                                            --
--    Version:                  1                                             --
--                                                                            --
--    Date of latest Verison:                                                 --
--                                                                            --
--    Design Unit:              Arithmetical Logical Unit (Entity)            --
--                                                                            --
--    Description:  The Arithmetical Logical Unit handels the calculations    --
--                  provided from the calculator control unit in the          --
--                  calculator project                                        --
--                                                                            --
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity alu is
  port(clk_i      : in  std_logic;                      -- 1 MHz clock
       reset_i    : in  std_logic;                      -- Asynchronous reset, high active
       op1_i      : in  std_logic_vector(11 downto 0);  -- first operand for calculation
       op2_i      : in  std_logic_vector(11 downto 0);  -- second operand for calculation
       optype_i   : in  std_logic_vector(3 downto 0);   -- operation to be performed on operands
       start_i    : in  std_logic;                      -- signal to start calculation
       finished_o : out std_logic;                      -- signal for finished calculation
       overflow_o : out std_logic;                      -- flag to indicate overflow during calculation
       sign_o     : out std_logic;                      -- flag to indicate a negative result
       error_o    : out std_logic;                      -- flag to indicate an error
       result_o   : out std_logic_vector(15 downto 0)); -- result of the calculation
 end alu;
