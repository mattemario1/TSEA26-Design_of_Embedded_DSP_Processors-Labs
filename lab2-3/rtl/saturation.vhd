library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

                                                                        
entity saturation is
  port (
    value_i   : in  signed(39 downto 0);
    do_sat_i  : in  std_logic;
    value_o   : out signed(39 downto 0);
    did_sat_o : out std_logic);
end saturation;

architecture saturation_rtl of saturation is
begin  -- saturation_rtl


process (do_sat_i, value_i) begin
  case do_sat_i is
    when '0' =>
      value_o <= value_i;
      did_sat_o <= '0';
    when '1' =>
      if (value_i(38 downto 31) /= "00000000" and value_i(39) = '0') then  --Saturate to Max Value.
        value_o <= x"007FFFFFFF";
        did_sat_o <= '1';
      elsif (value_i(38 downto 31) /= "11111111" and value_i(39) = '1') then      --Saturate to max value.
        value_o <= x"ff80000000";
        did_sat_o <= '1';
      else
        value_o <= value_i;
        did_sat_o <= '0';
      end if;
    when others => 
      value_o <= value_i;
      did_sat_o <= '0';
  end case;
end process;

end saturation_rtl;
