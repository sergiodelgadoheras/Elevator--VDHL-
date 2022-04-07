library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity BOTONERA is
  port (
    PISO_DESEADO : out unsigned(1 downto 0); --selección de los botones de la cabina
    BOTON        : in  std_logic_vector(3 downto 0);
    ACC_LED      : in  unsigned(3 downto 0);   --si 00 00 podemos cambiar el piso deseado, si no, NO SE PUEDE
    RESET        : in  std_logic;
    CLK          : in  std_logic
  );
end BOTONERA;

architecture BEHAVIORAL of BOTONERA is
  signal piso : unsigned(1 downto 0);
begin
  PISO_DESEADO <= piso;

  clock_proc: process (CLK, RESET, BOTON)
  begin
    if RESET = '1' then 
      piso <= "00";
    elsif rising_edge(CLK) then
      if acc_led = "0000" then
        if BOTON = "0001" then
          piso <= "00";
        elsif BOTON = "0010" then
          piso <= "01";
        elsif BOTON = "0100" then
          piso <= "10";
        elsif BOTON = "1000" then
          piso <= "11";
        end if;
      end if;
    end if;
end process;

end BEHAVIORAL; 