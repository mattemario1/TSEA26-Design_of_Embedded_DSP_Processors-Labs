library ieee;
use ieee.std_logic_1164.all;

entity min_max_ctrl is
  port (
    function_i  : in  std_logic_vector(2 downto 0);
    opa_sign_i  : in  std_logic;
    opb_sign_i  : in  std_logic;
    carry_i     : in  std_logic;
    mx_minmax_o : out std_logic);
end min_max_ctrl;

architecture min_max_ctrl_rtl of min_max_ctrl is

  signal maxmin : std_logic := '0';

begin  -- min_max_ctrl_rtl
-- maxmin <= (((not carry_i) and (opb_sign_i)) or ((carry_i) and (not opa_sign_i)));
maxmin <= not ((not opa_sign_i) and opb_sign_i) or ((opa_sign_i xnor opb_sign_i) and (not carry_i));
-- maxmin <= ((not opb_sign_i) and (not carry_i)) or (opa_sign_i and carry_i);

process (function_i, maxmin) begin
  case function_i is
    when "110" =>
      mx_minmax_o <= maxmin;
    when "111" =>
      mx_minmax_o <= not maxmin;
    when others => mx_minmax_o <= 'X';
  end case;
  end process;

end min_max_ctrl_rtl;
