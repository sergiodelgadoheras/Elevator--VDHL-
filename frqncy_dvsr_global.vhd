library IEEE;
use IEEE.std_logic_1164.all;

entity FRQNCY_DVSR_GLOBAL is
  generic (
    CLKIN_FREQ  : positive;
    CLKOUT_FREQ : positive := 1_000 -- 1 kHz
  );
  port (
    CLK_ENTRADA : in  std_logic;
    RESET       : in  std_logic;
    CLK_SALIDA  : out std_logic
  );
end FRQNCY_DVSR_GLOBAL;

architecture BEHAVIORAL of FRQNCY_DVSR_GLOBAL is
  constant FACTOR   : positive := CLKIN_FREQ / (2 * CLKOUT_FREQ);
  subtype contador_t is integer range 0 to FACTOR - 1;
  signal   contador : contador_t;
  signal   aux      : std_logic;
begin
  divisor_frecuencia: process (reset, CLK_entrada)
  begin
    if RESET = '1' then
      aux      <= '0';
      contador <= 0;
    elsif rising_edge(CLK_ENTRADA) then
      if contador = contador_t'high then
        aux      <= NOT(aux);
        contador <= 0;
      else
        contador <= contador + 1;
      end if;
    end if;
  end process;
    
  CLK_SALIDA <= aux;
end BEHAVIORAL;