library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TOP is
  generic(
    CLKIN_FREQ : positive := 100_000_000  -- [Hz]
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
end TOP;

architecture STRUCTURAL of TOP is

  component SISTEMA_FISICO
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
  end component;

  component CONTROL
    port (
      CLK          : in  std_logic;
      RESET        : in  std_logic;
      PISO_DESEADO : in  unsigned(1 downto 0);
      PISO_ACTUAL  : out unsigned(1 downto 0); -- 00
      ACC_LED      : out unsigned(3 downto 0)  -- puerta 00  motor 00
    );
  end component;

  component FRQNCY_DVSR_GLOBAL
    generic(
      CLKIN_FREQ  : positive
    );
    port(
      CLK_ENTRADA : in  std_logic;
      RESET       : in  std_logic;
      CLK_SALIDA  : out std_logic
    );
  end component;

  component INPUT_CONDITIONER
    generic (
      WIDTH    : positive
    );
    port (
      CLK      : in  std_logic;
      ASYNC_IN : in  std_logic_vector(WIDTH - 1 downto 0);
      EDGE_OUT : out std_logic_vector(WIDTH - 1 downto 0)
    );
  end component;

  --señales
  signal salidacolor  : std_logic_vector(5 downto 0); -- leds RGB para motores puerta y ascensor
  signal segment_n    : std_logic_vector(6 downto 0);
  signal digit        : std_logic_vector(AN'range);
  signal reset        : std_logic;
  signal piso_deseado : unsigned(1 downto 0);
  signal acc_led      : unsigned(3 downto 0);
  signal piso_actual  : unsigned(1 downto 0); -- 00
  signal clock        : std_logic;
  signal async_inputs : std_logic_vector(3 downto 0);  -- Agrupación entradas
  signal to_edge      : std_logic_vector(3 downto 0);  -- Salida de detector y entrada de sistema fisico

  alias salida        : std_logic_vector(3 downto 0) is LED(3 downto 0);

begin
  LED(15 downto 4) <= (others => '0');
  (LED16_R, LED16_G, LED16_B, LED17_R, LED17_G, LED17_B) <= salidacolor;
  
  DP <= '1';
  (CA, CB, CC, CD, CE, CF, CG) <= segment_n;
  AN <= not digit;
  digit(7 downto 4) <= (others => '0');

  reset <= not CPU_RESETN;

  async_inputs <= (BTNU, BTNL, BTNR, BTND);

  inst_sistema_fisico: SISTEMA_FISICO
    port map (
      SALIDA       => salida,
      SALIDACOLOR  => salidacolor,
      PISO_DESEADO => piso_deseado,
      SEGMENT_N    => segment_n,
      DIGIT        => digit(3 downto 0),
      ACC_LED      => acc_led,
      BOTON        => to_edge,
      PISO         => piso_actual,
      RESET        => reset,
      CLK          => clock
    );

  inst_control: CONTROL
    port map (
      CLK          => clock,
      RESET        => reset,
      PISO_DESEADO => piso_deseado, 
      PISO_ACTUAL  => piso_actual,
      ACC_LED      => acc_led
    );

  inst_frqncy_dvsr_global: FRQNCY_DVSR_GLOBAL
    generic map(
      CLKIN_FREQ  => CLKIN_FREQ
    )
    port map(
      CLK_ENTRADA => CLK100MHZ,
      RESET       => reset,
      CLK_SALIDA  => clock
    );

  inst_input_conditioner: INPUT_CONDITIONER
    generic map (
      WIDTH    => async_inputs'length
    )
    port map (
      CLK      => clock,
      ASYNC_IN => async_inputs,
      EDGE_OUT => to_edge
    );

end STRUCTURAL;
