library IEEE;
use IEEE.std_logic_1164.all;

entity TOP_TB is
end TOP_TB;

architecture TB of TOP_TB is

  component TOP
    generic(
      CLKIN_FREQ : positive
    );
    port (
      CLK100MHZ                 : in  std_logic;
      LED                       : out std_logic_vector(15 downto 0);
      LED16_R, LED16_G, LED16_B : out std_logic;
      LED17_R, LED17_G, LED17_B : out std_logic;
      CA, CB, CC, CD            : out std_logic;
      CE, CF, CG, DP            : out std_logic;
      AN                        : out std_logic_vector(7 downto 0);
      CPU_RESETN                : in  std_logic;
      BTNU                      : in  std_logic;
      BTNL                      : in  std_logic;
      BTNR                      : in  std_logic;
      BTND                      : in  std_logic
    );
  end component;

  signal CLK100MHZ  : std_logic;
  signal LED        : std_logic_vector(15 downto 0);
  signal LED16      : std_logic_vector( 2 downto 0);
  signal LED17      : std_logic_vector( 2 downto 0);
  signal SEGMENT_N  : std_logic_vector( 7 downto 0);
  signal AN         : std_logic_vector( 7 downto 0);
  signal CPU_RESETN : std_logic;
  signal BTNU       : std_logic;
  signal BTNL       : std_logic;
  signal BTNR       : std_logic;
  signal BTND       : std_logic;

  constant CLKIN_FREQ : positive := 4_000;  -- 4 kHz
  constant CLK_PERIOD : time := 1 sec / CLKIN_FREQ;

begin

  dut: TOP
    generic map (
      CLKIN_FREQ => CLKIN_FREQ
    )
    port map (
      CLK100MHZ  => CLK100MHZ,
      LED        => LED,
      LED16_R    => LED16(0),
      LED16_G    => LED16(1),
      LED16_B    => LED16(2),
      LED17_R    => LED17(0),
      LED17_G    => LED17(1),
      LED17_B    => LED17(2),
      CA         => SEGMENT_N(0),
      CB         => SEGMENT_N(1),
      CC         => SEGMENT_N(2),
      CD         => SEGMENT_N(3),
      CE         => SEGMENT_N(4),
      CF         => SEGMENT_N(5),
      CG         => SEGMENT_N(6),
      DP         => SEGMENT_N(7),
      AN         => AN,
      CPU_RESETN => CPU_RESETN,
      BTNU       => BTNU,
      BTNL       => BTNL,
      BTNR       => BTNR,
      BTND       => BTND
    );

  clkgen: process
  begin
    CLK100MHZ <= '0';
    wait for 0.5 * CLK_PERIOD;
    CLK100MHZ <= '1';
    wait for 0.5 * CLK_PERIOD;
  end process;

  stimuli : process
  begin
    (BTNU, BTNL, BTNR, BTND) <= std_logic_vector'("0000");

    CPU_RESETN <= '0' after 0.25 * CLK_PERIOD, '1' after 0.75 * CLK_PERIOD;
    wait until CPU_RESETN = '1';

    -- Let synchronizer & edge detector be filled with 0's (quiescent state)
    for i in 1 to 28 loop
      wait until CLK100MHZ = '1';
    end loop;

    -- Go to the third floor
    wait until CLK100MHZ = '0';
    BTNU <= '1', '0' after 1sec;

    -- Program "pushing" ground floor button whilst moving
    BTND <= '1' after 3 sec + 0.5 * 5 sec, '0' after 3 sec + 0.7 * 5 sec;

    wait for 2 * 3 sec + 3 * 5 sec + 1 sec;

    -- Go to the first floor
    wait until CLK100MHZ = '0';
    BTNR <= '1', '0' after 1sec;

    wait for 2 * 3 sec + 2 * 5 sec + 1 sec;

    assert false
      report "[SUCCESS]: simulation finished."
      severity failure;
  end process;

end tb;