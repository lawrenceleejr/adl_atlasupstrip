-------------------------------------------------------------------------------
-- Async MUX 2 LL streams, with arrays and freeze
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;
library hsio;
use hsio.pkg_hsio_globals.all;


entity ll_asmx_unit is
  port(
    -- control
    sel_i    : in    std_logic;
    lls_o      : out t_llsrc;
    freeze_i : in    std_logic;
    s_lls_i    : in t_llsrc_array(1 downto 0);
    rst      : in    std_logic;
    clk      : in    std_logic
    );

-- Declarations

end ll_asmx_unit;

architecture rtl of ll_asmx_unit is

  signal isel : integer range 0 to 1;


begin

  isel <= conv_integer(sel_i);

  lls_o.src_rdy <= s_lls_i(isel).src_rdy;
  lls_o.sof     <= s_lls_i(isel).sof;
  lls_o.eof     <= s_lls_i(isel).eof;
  lls_o.data    <= s_lls_i(isel).data;
  
end rtl;
