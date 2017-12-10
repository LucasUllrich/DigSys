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
--    Filename:                 calc_ctrl_rtl.vhd                             --
--                                                                            --
--    Date of creation:         Fre Nov 24 2017   Entity                      --
--                                                                            --
--    Version:                  1                                             --
--                                                                            --
--    Date of latest Verison:                                                 --
--                                                                            --
--    Design Unit:              Calculator control unit (Architecture)        --
--                                                                            --
--    Description:  The Calculator Control Unit is part of the calculator     --
--                  project. It manages the processing of the data provided   --
--                  by the IO Control Unit and controls the ALU of the        --
--                  Calculator.                                               --
--                                                                            --
--------------------------------------------------------------------------------
--                                                                            --
--  Reference:                                                                --
--    pbsync_i(0)... BTNL... Forward                                          --
--    pbsync_i(1)... BTNU... Reset                                            --
--    digx_o...      MSB: A, LSB: H (DP)                                      --
--                                                                            --
--------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture rtl of calc_ctrl is

type t_calc_state is (OPERAND1_S, OPERAND2_S, OPERATION_S, CALCULATE_S, RESULT_S);

signal s_calc_state : t_calc_state;
signal s_pbsync_old : std_logic_vector(3 downto 0);

signal s_start      : std_logic;


function set_digit_char(v_value : character)
    return std_logic_vector is

begin
  case v_value is
    when 'A' =>
      return "11101110";
      return "00010001";
    when 'd' =>
      return "10000101";
    when 'E' =>
      return "01100001";
    when 'n' =>
      return "11010101";
    when 'o' =>
      return "11000101";
    when 'q' =>
      return "00011001";
    when 'r' =>
      return "11110101";
    when 'S' =>
      return "01001001";
    when others =>
      return "11111111";
  end case;
end;

function set_digit_hex(v_value : std_logic_vector(3 downto 0))
    return std_logic_vector is

begin
  case v_value is
    when X"0" =>
      return "00000011";
    when X"1" =>
      return "10011111";
    when X"2" =>
      return "00100101";
    when X"3" =>
      return "00001101";
    when X"4" =>
      return "10011001";
    when X"5" =>
      return "01001001";
    when X"6" =>
      return "01000001";
    when X"7" =>
      return "00011111";
    when X"8" =>
      return "00000001";
    when X"9" =>
      return "00001001";
    when X"A" =>
      return "00010001";
    when X"B" =>
      return "11000001";
    when X"C" =>
      return "01100011";
    when X"D" =>
      return "10000101";
    when X"E" =>
      return "01100001";
    when X"F" =>
      return "01110001";
    when others =>
      return "11111111";
  end case;
end;

begin
--------------------------------------------------------------------------------
--                                                                            --
-- Display operands from switches on digx_o                                   --
--                                                                            --
--------------------------------------------------------------------------------
p_display : process (clk_i, reset_i)
begin
  if (reset_i = '1') then
    dig0_o <= "11111111";
    dig1_o <= "11111111";
    dig2_o <= "11111111";
    dig3_o <= "11111111";
    led_o <= "1111111111111111";
  elsif(clk_i'event and clk_i = '1') then
    case s_calc_state is
      when OPERAND1_S =>
        led_o <= "1111111111111111";
        dig0_o <= "01100001";
        dig1_o <= set_digit_hex(swsync_i(11 downto 8));
        dig2_o <= set_digit_hex(swsync_i(7 downto 4));
        dig3_o <= set_digit_hex(swsync_i(3 downto 0));
      when OPERAND2_S =>
        dig0_o <= "11011011";
        dig1_o <= set_digit_hex(swsync_i(11 downto 8));
        dig2_o <= set_digit_hex(swsync_i(7 downto 4));
        dig3_o <= set_digit_hex(swsync_i(3 downto 0));
      when OPERATION_S =>
        dig0_o <= "00111011";
        case swsync_i(15 downto 12) is
          when "0000" =>              -- Add
            dig1_o <= set_digit_char('A');
            dig2_o <= set_digit_char('d');
            dig3_o <= set_digit_char('d');
          when "0101" =>              -- Square
            dig1_o <= set_digit_char('S');
            dig2_o <= set_digit_char('q');
            dig3_o <= set_digit_char('r');
          when "1000" =>              -- Not
            dig1_o <= set_digit_char('n');
            dig2_o <= set_digit_char('o');
            dig3_o <= set_digit_char('0');
          when "1011" =>              -- XOR
            dig1_o <= set_digit_char('E');
            dig2_o <= set_digit_char('o');
            dig3_o <= set_digit_char('r');
          when others =>
            dig1_o <= set_digit_char('0');
            dig2_o <= set_digit_char('0');
            dig3_o <= set_digit_char('0');
        end case;
      when CALCULATE_S =>
        dig0_o <= set_digit_char('0');
        dig1_o <= set_digit_char('0');
        dig2_o <= set_digit_char('0');
        dig3_o <= set_digit_char('0');
      when RESULT_S =>
        led_o <= "1000000000000000";
        -- Error (like x / 0) not possible with given operations
        -- Signed result not possible with given operations
        if(error_i = '1') then
          dig0_o <= set_digit_char('E');
          dig1_o <= set_digit_char('r');
          dig2_o <= set_digit_char('r');
          dig3_o <= set_digit_char('0');
        elsif(overflow_i = '1') then
          dig0_o <= set_digit_char('o');
          dig1_o <= set_digit_char('o');
          dig2_o <= set_digit_char('o');
          dig3_o <= set_digit_char('o');
        else
          dig0_o <= set_digit_hex(result_i(15 downto 12));
          dig1_o <= set_digit_hex(result_i(11 downto 8));
          dig2_o <= set_digit_hex(result_i(7 downto 4));
          dig3_o <= set_digit_hex(result_i(3 downto 0));
        end if;
      when others =>
        dig0_o <= set_digit_char('0');
        dig1_o <= set_digit_char('0');
        dig2_o <= set_digit_char('0');
        dig3_o <= set_digit_char('0');
    end case;
  end if;
end process p_display;


--------------------------------------------------------------------------------
--                                                                            --
-- Set operands from switches                                                 --
--                                                                            --
--------------------------------------------------------------------------------
p_switches : process (swsync_i, reset_i)
begin
  if (reset_i = '1') then
    op1_o <= "000000000000";
    op2_o <= "000000000000";
    optype_o <= "0000";
  else
    case s_calc_state is
      when OPERAND1_S =>
        op1_o <= swsync_i(11 downto 0);
      when OPERAND2_S =>
        op2_o <= swsync_i(11 downto 0);
      when OPERATION_S =>
        optype_o <= swsync_i(15 downto 12);
      when others =>
        null;
    end case;
  end if;
end process p_switches;


--------------------------------------------------------------------------------
--                                                                            --
-- State Handler                                                              --
--                                                                            --
--------------------------------------------------------------------------------
p_pushbutton : process (clk_i, reset_i)
begin
  if(reset_i = '1') then
    s_calc_state <= OPERAND1_S;
    s_start <= '0';
    s_pbsync_old <= "0000";
  elsif(clk_i'event and clk_i = '1') then
    if(s_start = '1') then
      s_start <= '0';
    elsif(finished_i = '1') then
      s_calc_state <= RESULT_S;
    elsif(pbsync_i /= s_pbsync_old) then
      case s_calc_state is
        when OPERAND1_S =>
          if(pbsync_i(0) = '1') then
            s_calc_state <= OPERAND2_S;
          end if;
        when OPERAND2_S =>
          if(pbsync_i(0) = '1') then
            s_calc_state <= OPERATION_S;
          end if;
        when OPERATION_S =>
          if(pbsync_i(0) = '1') then
            s_calc_state <= CALCULATE_S;
            s_start <= '1';
          end if;
        when CALCULATE_S =>
          null;
        when RESULT_S =>
          if(pbsync_i(0) = '1') then
            s_calc_state <= OPERAND1_S;
          end if;
        when others =>
          if(pbsync_i(0) = '1') then
            s_calc_state <= OPERAND1_S;
          end if;
      end case;
    end if;
    s_pbsync_old <= pbsync_i;
  end if;
end process p_pushbutton;
start_o <= s_start;



end rtl;
