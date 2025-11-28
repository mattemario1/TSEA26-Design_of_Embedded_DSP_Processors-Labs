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

  constant ZERO_8_BITS : signed(7 downto 0) := (others => '0');
  constant ONE_8_BITS  : signed(7 downto 0) := (others => '1');
  constant MAX_VALUE   : signed(39 downto 0) := 0b00000000011111111111111111111111111111111;
  constant MIN_VALUE   : signed(39 downto 0) := 0b11111111100000000000000000000000000000000;

begin  -- saturation_rtl

  signal sign_bit <= value_i(39);
  signal guard_bits <= value_i(38 downto 32);


  case do_sat_i is
    when "0" =>
      value_o <= value_i
      did_sat_o <= "0"
    when "1" =>
      if (sign_bit = "0") and (guard_bits /= ZERO_8_BITS) then
        value_o <= MAX_VALUE;
        did_sat_o <= "1";
      elsif (sign_bit = "1") and (guard_bits /= ONE_8_BITS) then
        value_o <= MIN_VALUE;
        did_sat_o <= "1";
      else
        value_o <= value_i;
        did_sat_o <= "0";
      end if;
  end case;

end saturation_rtl;
