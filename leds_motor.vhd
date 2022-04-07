library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity LEDS_MOTOR is
  port ( 
    SALIDACOLOR : out std_logic_vector (5 downto 0); -- color de los led         izda puerta              derecha motor ascensor
    ACC_LED     : in  unsigned (3 downto 0) ---- los  estados in
  );
end LEDS_MOTOR;

architecture BEHAVIORAL of LEDS_MOTOR is
begin
  process (ACC_LED)
  begin
    if ACC_LED = "0000" then --- S0_STOP
      SALIDACOLOR <= "001001";
    elsif ACC_LED = "0001" then --- S1_CLOSING_ST
      SALIDACOLOR <= "010001";
    elsif ACC_LED = "0010" then --- S2_CLOSING_WT
      SALIDACOLOR <= "010001";
    elsif ACC_LED = "0011" then --- S3_MOVEUP_ST
      SALIDACOLOR <= "001100";
    elsif ACC_LED = "0100" then --- S4_MOVEUP_WT
      SALIDACOLOR <= "001100";
    elsif ACC_LED = "0101" then --- S5_OPENING_ST
      SALIDACOLOR <= "100001";
    elsif ACC_LED = "0110" then --- S5_OPENING_ST
      SALIDACOLOR <= "100001";
    elsif ACC_LED = "0111" then --- S7_MOVEDN_ST
      SALIDACOLOR <= "001010";
    elsif ACC_LED = "1000" then --- S8_MOVEDN_WT
      SALIDACOLOR <= "001010";
    else 
      SALIDACOLOR <= "001001";
    end if;
  end process;
end BEHAVIORAL;
