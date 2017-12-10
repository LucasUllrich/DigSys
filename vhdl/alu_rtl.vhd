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
--    Filename:                 alu_rtl.vhd                                   --
--                                                                            --
--    Date of creation:         Fre Nov 24 2017                               --
--                                                                            --
--    Version:                  1                                             --
--                                                                            --
--    Date of latest Verison:                                                 --
--                                                                            --
--    Design Unit:              Arithmetical Logical Unit (Architecture)      --
--                                                                            --
--    Description:  The Arithmetical Logical Unit handels the calculations    --
--                  provided from the calculator control unit in the          --
--                  calculator project                                        --
--                                                                            --
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;



architecture rtl of alu is

type t_operation_state is (RESET_S, ADD_S, SQUARE_S, NOT_S, XOR_S, RESULT_S);

signal s_operation_state : t_operation_state;

signal s_add_finished     : std_logic;
signal s_square_finished  : std_logic;
signal s_not_finished     : std_logic;
signal s_xor_finished     : std_logic;

signal s_overflow         : std_logic;

signal s_result_add       : std_logic_vector(15 downto 0);
signal s_result_square    : std_logic_vector(15 downto 0);
signal s_result_not       : std_logic_vector(15 downto 0);
signal s_result_xor       : std_logic_vector(15 downto 0);




begin
--------------------------------------------------------------------------------
--                                                                            --
-- Add                                                                        --
--                                                                            --
--------------------------------------------------------------------------------
p_add : process (clk_i, reset_i)

variable v_op1        : std_logic_vector(15 downto 0);
variable v_result_add : std_logic_vector(15 downto 0);

begin
  if(reset_i = '1') then
    s_add_finished <= '0';
    v_op1 := "0000000000000000";
    v_result_add := "0000000000000000";
    s_result_add <= "0000000000000000";
  elsif(clk_i'event and clk_i = '1') then
    if(s_operation_state = ADD_S) then
      v_op1(11 downto 0) := op1_i;
      v_op1(15 downto 12) := "0000";
      v_result_add := unsigned(v_op1) + unsigned(op2_i);
      s_result_add <= v_result_add;
      s_add_finished <= '1';
    elsif(s_operation_state = RESULT_S) then
      s_add_finished <= '0';
    end if;
  end if;
end process p_add;

--------------------------------------------------------------------------------
--                                                                            --
-- Square                                                                     --
--                                                                            --
--------------------------------------------------------------------------------
p_square : process (clk_i, reset_i)

variable v_multiply_counter : std_logic_vector(11 downto 0);
variable v_result_square       : std_logic_vector(15 downto 0);
variable v_result_square_old   : std_logic_vector(15 downto 0);

begin
  if(reset_i = '1') then
    s_square_finished <= '0';
    v_multiply_counter := "000000000000";
    v_result_square := "0000000000000000";
    v_result_square_old := "0000000000000000";
    s_overflow <= '0';
    s_result_square <= "0000000000000000";
  elsif(clk_i'event and clk_i = '1') then
    if(s_operation_state = SQUARE_S and s_square_finished = '0') then
      if(v_multiply_counter < op1_i) then
        s_overflow <= '0';
        v_result_square := unsigned(v_result_square) + unsigned(op1_i);
        if(v_result_square < v_result_square_old) then
          s_overflow <= '1';
          v_multiply_counter := op1_i;
        end if;   -- v_result_square < s_result_square
        v_result_square_old := v_result_square;
        v_multiply_counter := unsigned(v_multiply_counter) + '1';
        s_result_square <= v_result_square;
      else
        v_multiply_counter := "000000000000";
        v_result_square := "0000000000000000";
        v_result_square_old := "0000000000000000";
        s_square_finished <= '1';
      end if;     -- v_multiply_counter < op1_i
    elsif(s_operation_state = RESULT_S) then
      s_square_finished <= '0';
    end if;       -- s_operation_state
  end if;         -- reset, clk_i
end process p_square;

--------------------------------------------------------------------------------
--                                                                            --
-- Logical NOT                                                                --
--                                                                            --
--------------------------------------------------------------------------------
p_not : process (clk_i, reset_i)
begin
  if(reset_i = '1') then
    s_not_finished <= '0';
    s_result_not <= "0000000000000000";
  elsif(clk_i'event and clk_i = '1') then
    if(s_operation_state = NOT_S) then
      s_result_not <= not("0000"&op1_i);
      s_not_finished <= '1';
    elsif(s_operation_state = RESULT_S) then
      s_not_finished <= '0';
    end if;
  end if;
end process p_not;

--------------------------------------------------------------------------------
--                                                                            --
-- Logical XOR                                                                --
--                                                                            --
--------------------------------------------------------------------------------
p_xor : process (clk_i, reset_i)
begin
  if(reset_i = '1') then
    s_xor_finished <= '0';
    s_result_xor <= "0000000000000000";
  elsif(clk_i'event and clk_i = '1') then
    if(s_operation_state = XOR_S) then
      s_result_xor <= "0000"&op1_i xor "0000"&op2_i;
      s_xor_finished <= '1';
    elsif(s_operation_state = RESULT_S) then
      s_xor_finished <= '0';
    end if;
  end if;
end process p_xor;

--------------------------------------------------------------------------------
--                                                                            --
-- Input sampling                                                             --
--                                                                            --
--------------------------------------------------------------------------------
p_sampling : process (clk_i, reset_i)
begin
  if(reset_i = '1') then
    s_operation_state <= RESET_S;
    error_o <= '0';
    finished_o <= '0';
    overflow_o <= '0';
  elsif(clk_i'event and clk_i = '1') then
    if(start_i = '1') then
      overflow_o <= '0';
      case optype_i is
        when "0000" => s_operation_state <= ADD_S;
        when "0101" => s_operation_state <= SQUARE_S;
        when "1000" => s_operation_state <= NOT_S;
        when "1011" => s_operation_state <= XOR_S;
        when others =>
          error_o <= '1';
          s_operation_state <= RESULT_S;
      end case;
    elsif(s_operation_state = RESULT_S) then
      finished_o <= '0';
    elsif(s_add_finished = '1' or s_square_finished = '1' or s_not_finished = '1' or s_xor_finished = '1') then
      finished_o <= '1';
      if(s_overflow = '1' and s_operation_state = SQUARE_S) then
        overflow_o <= '1';
      end if;
      s_operation_state <= RESULT_S;
    end if;
  end if;
end process p_sampling;


--------------------------------------------------------------------------------
--                                                                            --
-- Setting result                                                             --
--                                                                            --
--------------------------------------------------------------------------------
p_result : process (clk_i, reset_i)
begin
  if(reset_i = '1') then
    sign_o <= '0';
    result_o <= "0000000000000000";
  elsif(clk_i'event and clk_i = '1') then
    if(s_operation_state = RESULT_S) then
      case optype_i is
        when "0000" => result_o <= s_result_add;
        when "0101" => result_o <= s_result_square;
        when "1000" => result_o <= s_result_not;
        when "1011" => result_o <= s_result_xor;
        when others => result_o <= "0000000000000000";
      end case;
    end if;
  end if;
end process p_result;


end rtl;
