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
--    Filename:                 io_ctrl_rtl.vhd                               --
--                                                                            --
--    Date of creation:         Fre Nov 24 2017   Entity                      --
--                                                                            --
--    Version:                  1                                             --
--                                                                            --
--    Date of latest Verison:                                                 --
--                                                                            --
--    Design Unit:              IO Control Unit (Architecture)                --
--                                                                            --
--    Description:  The IO Control Unit is part of the calculator project.    --
--                  It manages the interface to the 7-sgement displays,       --
--                  the LED's the push buttons and the switches of the        --
--                  Digilent Basys3 FPGA board.                               --
--                                                                            --
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of io_ctrl is

  constant C_ENCOUNTVAL : std_logic_vector(16 downto 0) := "11000011010100000";

  signal s_enctr    : std_logic_vector(16 downto 0);
  signal s_1khzen   : std_logic;
  signal s_swsync   : std_logic_vector(15 downto 0);
  signal s_pbsync   : std_logic_vector(3 downto 0);
  signal s_ss_sel   : std_logic_vector(3 downto 0);
  signal s_ss       : std_logic_vector(7 downto 0);
  signal s_led      : std_logic_vector(15 downto 0);


  type t_ss_state is (DISPLAY0_S, DISPLAY1_S, DISPLAY2_S, DISPLAY3_S, IDLE_S);
  type t_input_state is (STABLE_S, PENDING_S);

  signal s_ss_state : t_ss_state;
  signal s_input_state : t_input_state;


begin

--------------------------------------------------------------------------------
--
--  Generate 1 kHz enable signal.
--
--------------------------------------------------------------------------------
p_slowen: process (clk_i, reset_i)

begin   -- p_slowen
  if (reset_i = '1') then
    s_1khzen <= '0';
    s_enctr <= "00000000000000000";

  elsif (clk_i'event and clk_i = '1') then
    s_1khzen <= '0';
    s_enctr <= std_logic_vector(unsigned(s_enctr) + 1);
    if (s_enctr >= C_ENCOUNTVAL) then
      s_1khzen <= '1';
      s_enctr <= "00000000000000000";
    end if;

  end if;

end process p_slowen;


--------------------------------------------------------------------------------
--
-- Debounce buttons and switches
--
--------------------------------------------------------------------------------
p_debounce: process (s_1khzen, reset_i)

variable sw_counter : integer;
variable pb_counter : integer;

begin   -- p_debounce
  if (reset_i = '1') then
    s_swsync <= "0000000000000000";
    swsync_o <= "0000000000000000";
    s_pbsync <= "0000";
    pbsync_o <= "0000";
    sw_counter := 0;
    pb_counter := 0;
  elsif (s_1khzen'event and s_1khzen = '1') then
    -- probing for change on switches, else is reached in next cycle if nothing
    --  changes (the input is stable)
    if (sw_i /= s_swsync) then
      s_swsync <= sw_i;
      s_input_state <= PENDING_S;
      sw_counter := 0;
    else
      sw_counter := sw_counter + 1;
      if(sw_counter > 3) then
        swsync_o <= sw_i;
        s_input_state <= STABLE_S;
        sw_counter := 0;
      end if;
    end if;

    -- probing for change on pushbuttons, else is reached in next cycle if
    --  nothing changes (the input is stable)
    if (pb_i /= s_pbsync) then
      s_pbsync <= pb_i;
      pb_counter := 0;
    else
      pb_counter := pb_counter + 1;
      if(pb_counter > 3) then
        pbsync_o <= pb_i;
        pb_counter := 0;
      end if;
    end if;

  end if;
end process p_debounce;



--------------------------------------------------------------------------------
--
-- Display controller for the 7-segment display
--
--------------------------------------------------------------------------------
p_display_ctrl : process (s_1khzen, reset_i)
begin   -- p_display_ctrl
  if (reset_i = '1') then
    s_ss_state <= IDLE_S;
    s_ss_sel <= "1111";
    s_ss <= "11111111";
    s_led <= "1111111111111111";
  elsif (s_1khzen'event and s_1khzen = '1') then
    case s_ss_state is
      when DISPLAY0_S =>
        s_ss_sel <= "1110";
        s_ss <= dig0_i;
        s_ss_state <= DISPLAY1_S;
      when DISPLAY1_S =>
        s_ss_sel <= "1101";
        s_ss <= dig1_i;
        s_ss_state <= DISPLAY2_S;
      when DISPLAY2_S =>
        s_ss_sel <= "1011";
        s_ss <= dig2_i;
        s_ss_state <= DISPLAY3_S;
      when DISPLAY3_S =>
        s_ss_sel <= "0111";
        s_ss <= dig3_i;
        s_ss_state <= DISPLAY0_S;
      when others =>
        s_ss_sel <= "1111";
        s_ss <= "11111111";
        s_ss_state <= DISPLAY0_S;
    end case;
    s_led <= led_i;
  end if;
end process p_display_ctrl;

ss_sel_o <= s_ss_sel;
ss_o <= s_ss;
led_o <= s_led;

end rtl;
