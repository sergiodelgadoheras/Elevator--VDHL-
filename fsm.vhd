library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FSM is
  port (
    CLK          : in  std_logic;
    RESET        : in  std_logic;
    PISO_DESEADO : in  unsigned(1 downto 0);
    DONE         : in  std_logic;
    CUENTA_TIMER : out std_logic_vector(1 downto 0); -- "10" ASCENSOR "01"  PUERTA
    PISO_ACTUAL  : out unsigned(1 downto 0); -- 00
    ACC_LED      : out unsigned(3 downto 0)  -- puerta 00  motor 00
  );
end FSM;

architecture BEHAVIORAL of FSM is

  -- Estado
  type ESTATE_T is (
    S0_STOP,                       -- Ascensor parado
    S1_CLOSING_ST, S2_CLOSING_WT,  -- Cerrando puerta (start, wait)
    S3_MOVEUP_ST,  S4_MOVEUP_WT,   -- Subiendo (start, wait)
    S5_OPENING_ST, S6_OPENING_WT,  -- Abriendo puerta (start, wait)
    S7_MOVEDN_ST,  S8_MOVEDN_WT    -- Bajando (start, wait)
  );
  signal state, next_state : ESTATE_T;
    
  signal next_contador_piso, contador_piso : unsigned(1 downto 0):="00";------------------------------

  signal statei      : integer;
  signal next_statei : integer;

begin
  statei      <= ESTATE_T'pos(state);
  next_statei <= ESTATE_T'pos(next_state);

  PISO_ACTUAL <= contador_piso; -- *********

  sync_proc: process (CLK, RESET)
  begin
    if RESET = '1' then
      state         <= S0_STOP;
      contador_piso <= (others => '0'); -- ***********
    elsif rising_edge(CLK) then
      state         <= next_state;
      contador_piso <= next_contador_piso;
    end if;
  end process;

  output_decode: process (state)
  begin
    ACC_LED <= to_unsigned(ESTATE_T'pos(state), ACC_LED'length);

    case (state) is
      when S0_STOP =>
        CUENTA_TIMER <= "00";

      when S1_CLOSING_ST =>  
        CUENTA_TIMER <= "01";

      when S2_CLOSING_WT =>  
        CUENTA_TIMER <= "00";

      when S3_MOVEUP_ST =>  
        CUENTA_TIMER <= "10";

      when S4_MOVEUP_WT =>  
        CUENTA_TIMER <= "00";

      when S5_OPENING_ST =>  
        CUENTA_TIMER <= "01";

      when S6_OPENING_WT =>  
        CUENTA_TIMER <= "00";

      when S7_MOVEDN_ST =>  
        CUENTA_TIMER <= "10";

      when S8_MOVEDN_WT =>  
        CUENTA_TIMER <= "00";
    end case;
  end process;

  NEXT_STATE_DECODE: process (state, PISO_DESEADO, contador_piso, DONE) -- *******
  begin
    next_state         <= state;
    next_contador_piso <= contador_piso;

    case (state) is
      when S0_STOP =>
        if PISO_DESEADO /= contador_piso then
          next_state <= S1_CLOSING_ST;
        end if;

      when S1_CLOSING_ST =>
        next_state <= S2_CLOSING_WT;

      when S2_CLOSING_WT =>
        if DONE = '1' then
          if PISO_DESEADO < contador_piso then
            next_state <= S7_MOVEDN_ST;  
          elsif PISO_DESEADO > contador_piso then
            next_state <= S3_MOVEUP_ST;
          else
            next_state <= S5_OPENING_ST;
          end if;
        end if;

      when S3_MOVEUP_ST =>
        next_state <= S4_MOVEUP_WT;

      when S4_MOVEUP_WT =>
        if DONE = '1' then
          next_contador_piso <= contador_piso + 1;
          if PISO_DESEADO < (contador_piso + 1) then
            next_state <= S7_MOVEDN_ST;  
          elsif PISO_DESEADO > (contador_piso + 1) then
            next_state <= S3_MOVEUP_ST;
          else
            next_state <= S5_OPENING_ST;
          end if;
        end if;

      when S5_OPENING_ST =>
        next_state <= S6_OPENING_WT;

      when S6_OPENING_WT =>
        if DONE = '1' then
          next_state <= S0_STOP;
        end if;

      when S7_MOVEDN_ST =>  
        next_state <= S8_MOVEDN_WT;

      when S8_MOVEDN_WT =>  
        if DONE = '1' then
          next_contador_piso <= contador_piso - 1;
          if PISO_DESEADO < (contador_piso - 1) then
            next_state <= S7_MOVEDN_ST;  
          elsif PISO_DESEADO > (contador_piso - 1) then
            next_state <= S3_MOVEUP_ST;
          else
            next_state <= S5_OPENING_ST;
          end if;
        end if;
    end case;
  end process;

end BEHAVIORAL;