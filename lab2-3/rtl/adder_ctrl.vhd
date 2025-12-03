library ieee;
use ieee.std_logic_1164.all;

entity adder_ctrl is
  port (
    function_i   : in  std_logic_vector(2 downto 0);
    opa_sign_i   : in  std_logic;
    mx_opa_inv_o : out std_logic;
    mx_ci_o      : out std_logic_vector(1 downto 0));
end adder_ctrl;

architecture adder_ctrl_rtl of adder_ctrl is
begin  -- adder_ctrl_rtl

  process (function_i, opa_sign_i) begin
    case function_i is
      when "000" =>
        mx_ci_o <= "00";
        mx_opa_inv_o <= '0';
      when "001" =>
        mx_ci_o <= "10";
        mx_opa_inv_o <= '0';
      when "010" =>
        mx_ci_o <= "01";
        mx_opa_inv_o <= '1';
      when "011" =>
        mx_ci_o <= "10";
        mx_opa_inv_o <= '1';
      when "100" =>
        mx_ci_o <= '0' & opa_sign_i;
        mx_opa_inv_o <= opa_sign_i;
      when "101" =>
        mx_ci_o <= "01";
        mx_opa_inv_o <= '1';
      when "110" =>
        mx_ci_o <= "01";
        mx_opa_inv_o <= '1';
      when "111" =>
        mx_ci_o <= "01";
        mx_opa_inv_o <= '1';
      when others =>
        mx_ci_o <= "00";
        mx_opa_inv_o <= '0';
    end case;
  end process;

end adder_ctrl_rtl;
