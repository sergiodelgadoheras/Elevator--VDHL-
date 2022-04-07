library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity LEDS_PISO is
  port (
    SALIDA  : out std_logic_vector(3 downto 0); -- los 15 leds, solo usamos 4
    PISO    : in  unsigned(1 downto 0); -- representa en que piso estamos
    ACC_LED : in  unsigned(3 downto 0)
 );
end LEDS_PISO;

architecture BEHAVIORAL of LEDS_PISO is
begin
  process (PISO, ACC_LED)
  begin
    SALIDA <= "0000";
    if ACC_LED = "0000" then
      if PISO = "00" then
        SALIDA <= "1000";---- salida del led encendido    led 32Jy on el de la izda del todo
      elsif PISO = "01" then
        SALIDA <= "0100";-- el del ctro izda
      elsif PISO = "10" then
        SALIDA <= "0010";  --el de ctro drcha
      elsif PISO = "11" then
        SALIDA <= "0001";  --el de derecha
      end if;
    end if;
  end process;
end BEHAVIORAL;