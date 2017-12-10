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
--    Filename:                 tb_calc_ctrl_sim.vhd                          --
--                                                                            --
--    Date of creation:         Fre Nov 24 2017                               --
--                                                                            --
--    Version:                  1                                             --
--                                                                            --
--    Date of latest Verison:                                                 --
--                                                                            --
--    Design Unit:              Calculator control unit (Tb. simulation)      --
--                                                                            --
--    Description:  The Calculator Control Unit is part of the calculator     --
--                  project. It manages the processing of the data provided   --
--                  by the IO Control Unit and controls the ALU of the        --
--                  Calculator.                                               --
--                                                                            --
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture sim of tb_calc_ctrl is

  component calc_ctrl
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
  end component;

  signal clk_i      :  std_logic;                        -- 1 MHz clock
  signal reset_i    :  std_logic;                        -- asynchronous reset, high active
  signal swsync_i   :  std_logic_vector(15 downto 0);    -- debounced status of the 16 switches
  signal pbsync_i   :  std_logic_vector(3 downto 0);     -- debounced status of the 4 pushbuttons
  signal finished_i :  std_logic;                        -- flag for finished calculation
  signal result_i   :  std_logic_vector(15 downto 0);    -- result of the calculation
  signal sign_i     :  std_logic;                        -- flag for a sign of the result
  signal overflow_i :  std_logic;                        -- flag for overflow during calculation
  signal error_i    :  std_logic;                        -- flag for an error during calculation
  signal op1_o      :  std_logic_vector(11 downto 0);    -- first operand for calculation
  signal op2_o      :  std_logic_vector(11 downto 0);    -- second operand for calculation
  signal optype_o   :  std_logic_vector(3 downto 0);     -- operation to be performed on operands
  signal start_o    :  std_logic;                        -- signal for alu to start calculation
  signal dig0_o     :  std_logic_vector(7 downto 0);     -- state of respective 7 segment display
  signal dig1_o     :  std_logic_vector(7 downto 0);
  signal dig2_o     :  std_logic_vector(7 downto 0);
  signal dig3_o     :  std_logic_vector(7 downto 0);
  signal led_o      :  std_logic_vector(15 downto 0);   -- state of the 16 LED's on the board

begin
  i_calc_ctrl : calc_ctrl
  port map
  (clk_i       => clk_i,
   reset_i     => reset_i,
   swsync_i    => swsync_i,
   pbsync_i    => pbsync_i,
   finished_i  => finished_i,
   result_i    => result_i,
   sign_i      => sign_i,
   overflow_i  => overflow_i,
   error_i     => error_i,
   op1_o       => op1_o,
   op2_o       => op2_o,
   optype_o    => optype_o,
   start_o     => start_o,
   dig0_o      => dig0_o,
   dig1_o      => dig1_o,
   dig2_o      => dig2_o,
   dig3_o      => dig3_o,
   led_o       => led_o);

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
    swsync_i <= "0000000000000000";
    pbsync_i <= "0000";
    finished_i <= '0';
    result_i <= "0000000000000000";
    sign_i  <= '0';
    overflow_i <= '0';
    error_i <= '0';
    wait for 50 ns;
    reset_i <= '0';
    swsync_i <= "0000001011010101";
    wait for 2 ms;
    pbsync_i <= "0001"; -- Operand2
    wait for 1 ms;
    swsync_i <= "0000110001001110";
    wait for 2 ms;
    pbsync_i <= "0000";
    wait for 200 ns;
    pbsync_i <= "0001"; -- Operation
    wait for 2 ms;
    pbsync_i <= "0000";
    swsync_i <= "0101000000101010";
    wait for 200 ns;
    pbsync_i <= "0001"; -- Calculate
    wait for 2 ms;
    result_i <= "0000010100111001";
    overflow_i <= '1';
    finished_i <= '1';
    pbsync_i <= "0000";
    wait for 100 ns;
    finished_i <= '0';
    wait for 1 ms;
    pbsync_i <= "0001"; -- Operand1
    wait for 2 ms;
    pbsync_i <= "0000";
    wait for 100 ns;
  end process;

end sim;
