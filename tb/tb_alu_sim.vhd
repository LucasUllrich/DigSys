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
--    Filename:                 tb_alu_sim.vhd                                --
--                                                                            --
--    Date of creation:         Fre Nov 24 2017                               --
--                                                                            --
--    Version:                  1                                             --
--                                                                            --
--    Date of latest Verison:                                                 --
--                                                                            --
--    Design Unit:              Arithmetical Logical Unit (TB Simulation)     --
--                                                                            --
--    Description:  The Arithmetical Logical Unit handels the calculations    --
--                  provided from the calculator control unit in the          --
--                  calculator project                                        --
--                                                                            --
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture sim of tb_alu is

  component alu
  port(clk_i      : in  std_logic;
       reset_i    : in  std_logic;
       op1_i      : in  std_logic_vector(11 downto 0);
       op2_i      : in  std_logic_vector(11 downto 0);
       optype_i   : in  std_logic_vector(3 downto 0);
       start_i    : in  std_logic;
       finished_o : out std_logic;
       overflow_o : out std_logic;
       sign_o     : out std_logic;
       error_o    : out std_logic;
       result_o   : out std_logic_vector(15 downto 0));
  end component;


  signal clk_i      : std_logic;
  signal reset_i    : std_logic;
  signal op1_i      : std_logic_vector(11 downto 0);
  signal op2_i      : std_logic_vector(11 downto 0);
  signal optype_i   : std_logic_vector(3 downto 0);
  signal start_i    : std_logic;
  signal finished_o : std_logic;
  signal overflow_o : std_logic;
  signal sign_o     : std_logic;
  signal error_o    : std_logic;
  signal result_o   : std_logic_vector(15 downto 0);


begin
  i_alu : alu
  port map
  (clk_i      => clk_i,
   reset_i    => reset_i,
   op1_i      => op1_i,
   op2_i      => op2_i,
   optype_i   => optype_i,
   start_i    => start_i,
   finished_o => finished_o,
   overflow_o => overflow_o,
   sign_o     => sign_o,
   error_o    => error_o,
   result_o   => result_o);

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
    op1_i <= "000000000000";
    op2_i <= "000000000000";
    optype_i <= "0000";
    start_i <= '0';
    wait for 20 ns;
    reset_i <= '0';
    wait for 20 ns;
    -- Add operation
    op1_i <= "000011110001";
    op2_i <= "001100001101";
    wait for 5 ns;
    optype_i <= "0000";
    start_i <= '1';
    wait for 10 ns;
    start_i <= '0';
    wait for 1 ms;
    -- Add operation op1_i = op2_i = 0
    op1_i <= "000000000000";
    op2_i <= "000000000000";
    wait for 5 ns;
    optype_i <= "0000";
    start_i <= '1';
    wait for 10 ns;
    start_i <= '0';
    wait for 1 ms;
    -- Square operation op1_i = 1
    op1_i <= "000000000001";
    op2_i <= "001100001101"; -- don't care
    wait for 5 ns;
    optype_i <= "0101";
    start_i <= '1';
    wait for 10 ns;
    start_i <= '0';
    wait for 1 ms;
    -- Square operation overflow
    op1_i <= "000100000001";
    op2_i <= "001100001101"; -- don't care
    wait for 5 ns;
    optype_i <= "0101";
    start_i <= '1';
    wait for 10 ns;
    start_i <= '0';
    wait for 1 ms;
    -- Square operation op1_i = 12, result shall be 144
    op1_i <= "000000001100";
    op2_i <= "001100001101"; -- don't care
    wait for 5 ns;
    optype_i <= "0101";
    start_i <= '1';
    wait for 10 ns;
    start_i <= '0';
    wait for 1 ms;
    -- NOT operation
    op1_i <= "000110111000";
    op2_i <= "001100001101"; -- don't care
    wait for 5 ns;
    optype_i <= "1000";
    start_i <= '1';
    wait for 10 ns;
    start_i <= '0';
    wait for 1 ms;
    -- XOR operation
    op1_i <= "100100110100";
    op2_i <= "001100001101";
    wait for 5 ns;
    optype_i <= "1011";
    start_i <= '1';
    wait for 10 ns;
    start_i <= '0';
    wait for 1 ms;
  end process;

end sim;
