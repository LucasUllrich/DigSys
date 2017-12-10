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
--    Filename:                 calculator_struct.vhd                          --
--                                                                            --
--    Date of creation:         Fre Nov 24 2017                               --
--                                                                            --
--    Version:                  1                                             --
--                                                                            --
--    Date of latest Verison:                                                 --
--                                                                            --
--    Design Unit:              Top Level calculator (structure)              --
--                                                                            --
--    Description:  The Top Level combines the io control, calc control and   --
--                  alu of the calculator project to the final calculator     --
--                                                                            --
--------------------------------------------------------------------------------

architecture struct of calculator is

  component io_ctrl
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
  end component;

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

  component alu
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
  end component;


  signal s_swsync   : std_logic_vector(15 downto 0);
  signal s_pbsync   : std_logic_vector(3 downto 0);
  signal s_dig0     : std_logic_vector(7 downto 0);
  signal s_dig1     : std_logic_vector(7 downto 0);
  signal s_dig2     : std_logic_vector(7 downto 0);
  signal s_dig3     : std_logic_vector(7 downto 0);
  signal s_led      : std_logic_vector(15 downto 0);
  signal s_op1      : std_logic_vector(11 downto 0);
  signal s_op2      : std_logic_vector(11 downto 0);
  signal s_optype   : std_logic_vector(3 downto 0);
  signal s_result   : std_logic_vector(15 downto 0);
  signal s_start    : std_logic;
  signal s_finished : std_logic;
  signal s_sign     : std_logic;
  signal s_overflow : std_logic;
  signal s_error    : std_logic;


begin   -- struct

  --instantiate io control unit
  i_io_ctrl : io_ctrl
    port map(clk_i    => clk_i,
             reset_i  => reset_i,
             dig0_i   => s_dig0,
             dig1_i   => s_dig1,
             dig2_i   => s_dig2,
             dig3_i   => s_dig3,
             led_i    => s_led,
             sw_i     => sw_i,
             pb_i     => pb_i,
             ss_o     => ss_o,
             ss_sel_o => ss_sel_o,
             led_o    => led_o,
             swsync_o => s_swsync,
             pbsync_o => s_pbsync);


  -- instantiate calculator control unit
  i_calc_ctrl : calc_ctrl
    port map(clk_i      => clk_i,
             reset_i    => reset_i,
             swsync_i   => s_swsync,
             pbsync_i   => s_pbsync,
             finished_i => s_finished,
             result_i   => s_result,
             sign_i     => s_sign,
             overflow_i => s_overflow,
             error_i    => s_error,
             op1_o      => s_op1,
             op2_o      => s_op2,
             optype_o   => s_optype,
             start_o    => s_start,
             dig0_o     => s_dig0,
             dig1_o     => s_dig1,
             dig2_o     => s_dig2,
             dig3_o     => s_dig3,
             led_o      => s_led);


  -- instantiate ALU
  i_alu : alu
    port map(clk_i      => clk_i,
             reset_i    => reset_i,
             op1_i      => s_op1,
             op2_i      => s_op2,
             optype_i   => s_optype,
             start_i    => s_start,
             finished_o => s_finished,
             overflow_o => s_overflow,
             sign_o     => s_sign,
             error_o    => s_error,
             result_o   => s_result);



end struct;
