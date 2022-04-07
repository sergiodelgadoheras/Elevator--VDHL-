library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SISTEMA_FISICO is
  port (
    SALIDA       : out std_logic_vector(3 downto 0); --salida led puerta abierta y lista para usarse
    SALIDACOLOR  : out std_logic_vector(5 downto 0); -- leds RGB para motores puerta y ascensor
    PISO_DESEADO : out unsigned(1 downto 0);
    SEGMENT_N    : out std_logic_vector(6 downto 0); -- los 7 segmentos de cada display
    DIGIT        : out std_logic_vector(3 downto 0);
    ACC_LED      : in  unsigned(3 downto 0);
    BOTON        : in  std_logic_vector(3 downto 0);
    PISO         : in  unsigned(1 downto 0);   --piso actual
    RESET        : in  std_logic;
    CLK          : in  std_logic
  );
end SISTEMA_FISICO;

architecture STRUCTURAL of SISTEMA_FISICO is

  component DISPLAY
    port (
      PISO      : in  unsigned(1 downto 0);  -- son del 0 al 3 de los display
      SEGMENT_N : out std_logic_vector(6 downto 0); -- los 7 segmentos de cada display
      DIGIT     : out std_logic_vector(3 downto 0)
    );
  end component;

  component BOTONERA
    port (
      PISO_DESEADO : out unsigned(1 downto 0); --selección de los botones de la cabina
      BOTON        : in  std_logic_vector(3 downto 0);
      ACC_LED      : in  unsigned(3 downto 0);   --si 00 00 podemos cambiar el piso deseado, si no, NO SE PUEDE
      RESET        : in  std_logic;
      CLK          : in  std_logic
    );
  end component;

  component LEDS_MOTOR
    port (
      SALIDACOLOR : out std_logic_vector(5 downto 0); -- color de los led     izda puerta       derecha motor ascensor
      ACC_LED     : in  unsigned(3 downto 0) ---- los  estados in
    );
  end component;

  component LEDS_PISO
    port (
      SALIDA  : out std_logic_vector(3 downto 0); -- los 15 leds, solo usamos 4
      PISO    : in  unsigned(1 downto 0); -- representa en que piso estamos
      ACC_LED : in  unsigned(3 downto 0)
    );
  end component;

begin

  inst_display: DISPLAY
    port map (
      PISO      => PISO,
      SEGMENT_N => SEGMENT_N,
      DIGIT     => DIGIT
    );

  inst_botonera: BOTONERA
    port map (
      PISO_DESEADO => PISO_DESEADO,
      BOTON        => BOTON,
      ACC_LED      => ACC_LED,
      RESET        => RESET,
      CLK          => CLK
    );

  inst_leds_motor: LEDS_MOTOR
    port map (
      SALIDACOLOR => SALIDACOLOR,
      ACC_LED     => ACC_LED
    );

  inst_leds_piso: LEDS_PISO
    port map (
      SALIDA  => SALIDA,
      PISO    => PISO,
      ACC_LED => ACC_LED
    );

end STRUCTURAL;
