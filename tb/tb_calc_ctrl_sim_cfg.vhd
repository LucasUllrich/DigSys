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
--    Filename:                 tb_calc_ctrl_sim_cfg.vhd                      --
--                                                                            --
--    Date of creation:         Fre Nov 24 2017                               --
--                                                                            --
--    Version:                  1                                             --
--                                                                            --
--    Date of latest Verison:                                                 --
--                                                                            --
--    Design Unit:              Calculator control unit (Tb. configuration)   --
--                                                                            --
--    Description:  The Calculator Control Unit is part of the calculator     --
--                  project. It manages the processing of the data provided   --
--                  by the IO Control Unit and controls the ALU of the        --
--                  Calculator.                                               --
--                                                                            --
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

configuration tb_calc_ctrl_sim_cfg of tb_calc_ctrl is
  for sim
    for i_calc_ctrl : calc_ctrl
      use configuration work.calc_ctrl_rtl_cfg;
    end for;
  end for;
end tb_calc_ctrl_sim_cfg;
