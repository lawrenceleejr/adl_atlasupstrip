--
-- Readout Unit Status Block
--
-- Drives LL out when stat_req comes in
-- 
-- 
--
-- Change log:
-- 2012-10-02 - fixed non mapped busy_en_i's
-- 2012-10-03 - reset delta  counter if not en
-- 2012-10-30 - fixed hd_delta stuck at max/min bug




library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_core_globals.all;

entity ro_unit_stat is
   --generic( 
   --   STREAM_ID : integer := 0
   --);
   port(
      STREAM_ID : in integer;
      -- locallink tx interface
      lls_o            : out    t_llsrc;
      lld_i            : in     std_logic;
      -- stats
      req_stat_i       : in     std_logic;
      strm_reg_i       : in     slv16;
      reg_busy_delta_i : in     slv16;
      header_seen_i    : in     std_logic;
      trig80_i         : in     std_logic;
      dropped_pkts_i   : in     slv8;
      fifo_count_i     : in     slv2;
      len_fifo_count_i : in     slv2;
      busy_en_delta_i  : in     std_logic;
      busy_en_fifo_i   : in     std_logic;
      --hd_delta_max_i   : in  slv6;
      deser_en_i       : in     std_logic;
      histo_en_i       : in     std_logic;
      busy_o           : out    std_logic;
      -- infrastructure
      clk              : in     std_logic;
      rst              : in     std_logic
   );

-- Declarations

end ro_unit_stat ;


architecture rtl of ro_unit_stat is
  
  signal hd_delta    : slv6;
  signal hd_delta_en : std_logic;
  signal hd_code     : slv2;

  signal hd_delta_on : integer range 0 to 63;
  signal hd_delta_off : integer range 0 to 63;

  signal busy_fifo  : std_logic;
  signal busy_delta : std_logic;


  signal statword0 : slv16;
  signal statword1 : slv16;
--  signal statword2 : slv16;


  type states is (SrcRdy, OpcodeSOF, OCSeq, Size,
                  StrmID, Data0,        --Data1,
                  DataEOF,
                  Idle);

  signal state, nstate : states;


begin



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



  prc_async_machine : process (req_stat_i, lld_i, strm_reg_i, statword0, statword1,
                               state
                               )
  begin

    -- defaults
    nstate        <= Idle;
    lls_o.src_rdy <= '1';
    lls_o.sof     <= '0';
    lls_o.eof     <= '0';
    lls_o.data    <= OC_STRM_STAT_DATA;


    case state is

      -------------------------------------------------------------------

      when Idle =>  -- Make sure we get rising edge of oc_valid
        nstate        <= Idle;
        lls_o.src_rdy <= '0';
        if (req_stat_i = '1') then
          nstate <= SrcRdy;
        end if;


      when SrcRdy =>
        nstate <= SrcRdy;
        if (lld_i = '1') then
          nstate <= OpcodeSOF;
        end if;


      when OpcodeSOF =>
        nstate     <= OpcodeSOF;
        lls_o.data <= OC_STRM_STAT_DATA;
        lls_o.sof  <= '1';
        if (lld_i = '1') then
          nstate <= OCSeq;
        end if;


      when OCSeq =>
        nstate     <= OCSeq;
        lls_o.data <= x"0000";          -- place holder
        if (lld_i = '1') then
          nstate <= Size;
        end if;


      when Size =>
        nstate     <= Size;
        lls_o.data <= x"0006";
        if (lld_i = '1') then
          nstate <= StrmID;
        end if;


      when StrmID =>
        nstate     <= StrmID;
        lls_o.data <= conv_std_logic_vector(STREAM_ID, 16);
        if (lld_i = '1') then
          nstate <= Data0;
        end if;


      when Data0 =>
        nstate     <= Data0;
        lls_o.data <= statword0;
        if (lld_i = '1') then
          nstate <= DataEOF;
        end if;

-- when Data1 =>
-- nstate <= Data1;
-- lls_o.data <= statword1;
-- if (lld_i = '1') then
-- nstate <= Data2EOF;
-- end if;


      when DataEOF =>
        nstate     <= DataEOF;
        lls_o.data <= statword1;
        lls_o.eof  <= '1';
        if (lld_i = '1') then
          nstate <= Idle;
        end if;

    end case;


  end process;


  statword0 <= strm_reg_i;
  statword1 <= dropped_pkts_i(3 downto 0) & len_fifo_count_i & fifo_count_i &
               busy_fifo & busy_delta & hd_delta;

-- statword1 <= x"00" & busy_fifo & busy_delta & hd_delta;
-- statword2 <= dropped_pkts_i(3 downto 0) & "0000" & len_fifo_count_i & fifo_count_i;




  -- Delta headers and triggers
  -----------------------------------------------------
  hd_delta_en <= (deser_en_i or histo_en_i) and busy_en_delta_i;
  hd_code     <= header_seen_i & trig80_i;

  prc_hd_delta : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') or (hd_delta_en = '0') then
        hd_delta <= (others => '0');
        
      else
        if (hd_delta /= "111111") and (hd_code = "01") then
          hd_delta <= hd_delta + '1';
          
        elsif (hd_delta /= "000000") and (hd_code = "10") then
          hd_delta <= hd_delta - '1';

        end if;
      end if;
    end if;
  end process;



  -- Busy Generate
  -------------------------------------------------------

  hd_delta_on <= conv_integer(reg_busy_delta_i(13 downto 8));
  hd_delta_off <= conv_integer(reg_busy_delta_i(5 downto 0));

  prc_busy_delta : process (clk)
    begin
      if rising_edge(clk) then
      if (rst = '1') then
        busy_delta <= '0';
        
      else
        if (hd_delta >= hd_delta_on) then
          busy_delta <= '1';

        elsif (hd_delta <= hd_delta_off) then
          busy_delta <= '0';

        end if;
      end if;
end if;
   end process;
      


  busy_fifo <= '1' when (fifo_count_i(1) = '1') or (len_fifo_count_i(1) = '1') else
               '0';


  busy_o <= (busy_delta and busy_en_delta_i) or (busy_fifo and busy_en_fifo_i);


end architecture;




