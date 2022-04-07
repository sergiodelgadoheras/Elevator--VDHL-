library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CONTROL_TB is
end CONTROL_TB;

architecture TB of CONTROL_TB is

  component CONTROL
    port (
      CLK          : in  std_logic;
      RESET        : in  std_logic;
      PISO_DESEADO : in  unsigned(1 downto 0);
      PISO_ACTUAL  : out unsigned(1 downto 0);
      ACC_LED      : out unsigned(3 downto 0)
    );
  end component;

  signal clk          : std_logic;
  signal reset        : std_logic;
  signal piso_deseado : unsigned(1 downto 0);
  signal piso_actual  : unsigned(1 downto 0);
  signal acc_led      : unsigned(3 downto 0);

  constant CLK_PERIOD : time := 1 ms;

  constant GROUND_FLOOR : unsigned := to_unsigned(0, piso_deseado'length);
  constant FIRST_FLOOR  : unsigned := to_unsigned(1, piso_deseado'length);
  constant SECOND_FLOOR : unsigned := to_unsigned(2, piso_deseado'length);
  constant THIRD_FLOOR  : unsigned := to_unsigned(3, piso_deseado'length);

begin

  dut : CONTROL
    port map (
      CLK          => clk,
      RESET        => reset,
      PISO_DESEADO => piso_deseado,
      PISO_ACTUAL  => piso_actual,
      ACC_LED      => acc_led
    );

  clkgen: process
  begin
    clk <= '0';
    wait for 0.5 * CLK_PERIOD;
    clk <= '1';
    wait for 0.5 * CLK_PERIOD;
  end process;

  stimuli : process
  begin
    piso_deseado <= GROUND_FLOOR;

    reset <= '1' after 0.25 * CLK_PERIOD, '0' after 0.75 * CLK_PERIOD;
    wait until reset = '0';

    wait until clk = '0';
    piso_deseado <= THIRD_FLOOR;

    wait for 2 * 3 sec + 3 * 5 sec + 1 sec;

    wait until clk = '0';
    piso_deseado <= FIRST_FLOOR;

    wait for 2 * 3 sec + 2 * 5 sec + 1 sec;

    assert false
      report "[SUCCESS]: simulation finished."
      severity failure;
  end process;

end TB;
