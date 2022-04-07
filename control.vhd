library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CONTROL is
  port (
    CLK          : in  std_logic;
    RESET        : in  std_logic;
    PISO_DESEADO : in  unsigned(1 downto 0);
    PISO_ACTUAL  : out unsigned(1 downto 0); -- 00
    ACC_LED      : out unsigned(3 downto 0)  -- puerta 00  motor 00
  );
end CONTROL;

architecture STRUCTURAL of CONTROL is

  component TEMPORIZADOR
    port (
      CUENTA_TIMER : in  std_logic_vector(1 downto 0);
      CLK          : in  std_logic;
      RESET        : in  std_logic;
      DONE         : out std_logic 
    );
  end component;

  component FSM
    port (
      CLK          : in  std_logic;
      RESET        : in  std_logic;
      PISO_DESEADO : in  unsigned(1 downto 0);
      DONE         : in  std_logic;
      CUENTA_TIMER : out std_logic_vector(1 downto 0); -- "10" ASCENSOR "01"  PUERTA
      PISO_ACTUAL  : out unsigned(1 downto 0); -- 00
      ACC_LED      : out unsigned(3 downto 0)  -- puerta 00  motor 00
    );    
  end component;

  signal cuenta : std_logic_vector(1 downto 0);
  signal done   : std_logic;

begin

  inst_fsm: FSM
    port map (
      CLK          => CLK,
      RESET        => RESET,
      PISO_DESEADO => PISO_DESEADO,
      DONE         => done,
      CUENTA_TIMER => cuenta,
      PISO_ACTUAL  => PISO_ACTUAL,
      ACC_LED      => ACC_LED
    );

  inst_temporizador: TEMPORIZADOR
    port map (
      CUENTA_TIMER => cuenta,
      RESET        => RESET,
      CLK          => CLK,
      DONE         => done
    );

end STRUCTURAL;