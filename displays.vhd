library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DISPLAY is
  port (
    PISO      : in  unsigned(1 downto 0);  -- son del 0 al 3 de los display
    SEGMENT_N : out std_logic_vector(6 downto 0); -- los 7 segmentos de cada display
    DIGIT     : out std_logic_vector(3 downto 0)
  );
end DISPLAY;

architecture BEHAVIORAL of DISPLAY is
begin
  process (PISO)
  begin
    case piso is
      when "00" => -- abcdefg
        SEGMENT_N <= "1001111";
        DIGIT     <= "0001";
      when "01" =>
        SEGMENT_N <= "0010010";
        DIGIT     <= "0010";
      when "10" =>
        SEGMENT_N <= "0000110";
        DIGIT     <= "0100";
      when "11" =>
        SEGMENT_N <= "1001100";
        DIGIT     <= "1000";
      when others =>
        SEGMENT_N <= "1111111";
        DIGIT     <= "0000";
    end case;
  end process;
end BEHAVIORAL;