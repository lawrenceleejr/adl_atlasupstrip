--
--
-- 
-- 
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library utils;
use utils.pkg_types.all;
use hsio.pkg_hsio_globals.all;

entity nettest_pktgen is
   port( 
      
      opcode_i  : in     slv16;
      ocseq_i  : in     slv16;
      ocsize_i  : in     slv16;

      -- ro_unit_fifo interface
      src_rdy_o  : out    std_logic;
      sof_o      : out    std_logic;
      eof_o      : out    std_logic;
      data_o     : out    slv16;
      dst_rdy_i  : in     std_logic;
      
      -- infrastructure
      clk        : in     std_logic;
      rst        : in     std_logic
   );

-- Declarations

end nettest_pktgen ;


architecture rtl of nettest_pktgen is


  type states is (SrcRdy, SOF, WaitEOF,
                  Idle1, Idle
                  );

  signal state, nstate : states;


begin


  llo.data <= oc_data_i;


  -- State Machine
  --------------------------------------------------------
  prc_sync_part : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state <= Idle;
      else
        state <= nstate;                -- after 50 ps;

      end if;
    end if;
  end process;



  prc_async_machine : process ( oc_valid_i, llo.dst_rdy, oc_data_i,
                                state
                                )
  begin

    -- defaults
    nstate <= Idle;
    oc_dtack_o     <= '0';
    llo.src_rdy <= '0';
    llo.sof     <= '0';
    llo.eof     <= '0';



    case state is

      -------------------------------------------------------------------

      when Idle =>                      -- Make sure we get rising edge of oc_valid
        nstate   <= Idle;
        if (opcode_i = x"0999" ) then
          nstate <= SendPacket;
        end if;

        

      when Idle1 =>
        nstate             <= Idle1;
        if (oc_valid_i = '1') then
          if (oc_data_i = OC_ECHO) then
            nstate         <= SrcRdy;
          else
            nstate         <= Idle;
          end if;
        end if;

        
        
      when SrcRdy => 
        nstate <= SrcRdy;
        llo.src_rdy <= '1';
        if (llo.dst_rdy = '1') then
          nstate <= SOF;
        end if;

      when SOF =>
        nstate <= SOF;
        llo.src_rdy <= '1';
        llo.sof     <= '1';
        if (llo.dst_rdy = '1') then
          oc_dtack_o <= '1';
          nstate     <= WaitEOF;
        end if;

        

      when WaitEOF =>
        nstate <= WaitEOF;
        llo.src_rdy <= '1';
        if (oc_valid_i = '0') then
          llo.eof <= '1';
        end if;
        if (llo.dst_rdy = '1') then
          oc_dtack_o <= '1';
          if (oc_valid_i = '0') then
            nstate <= Idle;
          end if;
        end if;


    end case;

    
  end process;




--   prc_dcount : process (clk)
--   begin
--     if rising_edge(clk) then
--       if (state = Idle) then
--         dcount <= x"0000";
--       elsif
        

       



end architecture;


