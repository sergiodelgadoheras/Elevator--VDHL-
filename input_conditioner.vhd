library ieee;
use ieee.std_logic_1164.all;

entity INPUT_CONDITIONER is
  generic (
    WIDTH : positive
  );
  port (
    CLK      : in  std_logic;
    ASYNC_IN : in  std_logic_vector(WIDTH - 1 downto 0);
    EDGE_OUT : out std_logic_vector(WIDTH - 1 downto 0)
  );
end INPUT_CONDITIONER;

architecture STRUCTURAL of INPUT_CONDITIONER is

  COMPONENT SYNCHRNZR  -- Sincronizador
    PORT (
      CLK      : in std_logic;
      ASYNC_IN : in std_logic;
      SYNC_OUT : out std_logic
    );
  END COMPONENT;

  COMPONENT EDGEDTCTR  -- Detector de flancos
    PORT (
      CLK     : in std_logic;
      SYNC_IN : in std_logic;
      EDGE    : out std_logic
    );
  END COMPONENT;

begin

  conditioners: for i in ASYNC_IN'range generate
    signal synced_input : std_logic;
  begin
    synchrnzr_i: SYNCHRNZR
      port map(
        CLK      => CLK,
        ASYNC_IN => ASYNC_IN(i),
        SYNC_OUT => synced_input
    );
    
    edgedtctr_i: EDGEDTCTR
      port map(
        CLK      => CLK,
        SYNC_IN  => synced_input,
        EDGE     => EDGE_OUT(i)
    ); 
  end generate;

end STRUCTURAL;
