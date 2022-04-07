library IEEE;
use IEEE.std_logic_1164.all;

entity TEMPORIZADOR is
  port (
    CUENTA_TIMER : in  std_logic_vector(1 downto 0);
    CLK          : in  std_logic;
    RESET        : in  std_logic;
    DONE         : out std_logic
  );
end TEMPORIZADOR;

architecture BEHAVIORAL of TEMPORIZADOR is
begin

  timer: process (reset, clk)
    constant DOOR_DELAY  : time := 3 sec;
    constant CABIN_DELAY : time := 5 sec;

    constant DOOR_TICKS  : positive := 1000 * DOOR_DELAY  / 1 sec - 2;  -- Door delay [clock ticks @ 1kHz]
    constant CABIN_TICKS : positive := 1000 * CABIN_DELAY / 1 sec - 2;  -- Door delay [clock ticks @ 1kHz]

    subtype count_t is integer range 0 to 9999;
    variable count : count_t;
  begin
    if reset = '1' then
      count := 0;
    elsif rising_edge(clk) then
      case cuenta_timer is
        when "01" => -- Load door opening / closing delay
          count := DOOR_TICKS;
        when "10" => -- Load inter-floor delay
          count := CABIN_TICKS;
        when others => -- Update count-down
          if count /= 0 then
            count := count - 1;
          end if;
      end case;
    end if;
    if count = 0 then
      done <= '1';
    else
      done <= '0';
    end if;
  end process;

end BEHAVIORAL;