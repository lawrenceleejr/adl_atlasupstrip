-- trigger_burst.vhd
-- bursts configurable bit patterns in configurable cycles
-- Alexander Law (atlaw@ucsc.edu)
-- August 2011
-- University of California, Santa Cruz

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

entity trig_burst is
   generic( 
      rptLen   : integer := 16;      -- bit length of trigger reitition counter
      rpt2Len  : integer := 16;      -- bit length of supercycle repitition counter
      waitLen  : integer := 20;      -- bit length of repeat cycle countdown timer
      wait2Len : integer := 20;      -- bit length of supercycle countdown timer (VHDL integers have max. value 2**31-1)
      sqLenExp : integer := 3        -- exponent for bit length (2**sqLenExp) of trigger bit-sequence register
   );
   port( 
      --clock         : in  std_logic;    -- global 40 MHz clock
      clock          : in     std_logic;                              -- global 80 MHz clock
      strobe40_i     : in     std_logic;                              -- 40MHz clock strobe - for 80MHz sync
      reset          : in     std_logic;                              -- global reset
      trigs_count_o  : out    std_logic_vector (15 downto 0);
      bursts_count_o : out    std_logic_vector (15 downto 0);
      ready_o        : out    std_logic;
      running_o      : out    std_logic;
      finished_o     : out    std_logic;
      -- trigger_in : in std_logic;           -- readout trigger
      giddyup_in     : in     std_logic;                              -- "go," since trigger might just mean "read config ports"
      seq_reset_i    : in     std_logic;
      -- config_in : in std_logic;            -- if received concurrently with trigger, module reads and registers config inputs.
      rpt_in         : in     std_logic_vector (rptLen-1 downto 0);   -- number of triggers within a burst
      -- *** all of our registers are 16b, so we need to make these values
      waitMin16_in   : in     std_logic_vector (15 downto 0);         -- minimum number of clock ticks between triggers w/in a burst
      waitMax16_in   : in     std_logic_vector (15 downto 0);         -- maximum number of clock ticks between triggers w/in a burst
      rpt2_in        : in     std_logic_vector (rpt2Len-1 downto 0);  -- number of trigger bursts
      wait2_16_in    : in     std_logic_vector (15 downto 0);         -- fixed number of clock ticks between bursts
      --sq_in         : in  std_logic_vector(2**sqLenExp-1 downto 0);
      --sqLen_in  : in  std_logic_vector(sqLenExp-1 downto 0);
      busy_i         : in     std_logic;                              -- input for back-pressure or flow control
      outBit_out     : out    std_logic;                              -- trigger signal output
      testFlag_out   : out    std_logic                               -- long-lived flag for oscilloscope inspection
   );

-- Declarations

end trig_burst ;

architecture rtl of trig_burst is

  -- *** >16b inputs move here
  signal waitMin_in : std_logic_vector(waitLen-1 downto 0);
  signal waitMax_in : std_logic_vector(waitLen-1 downto 0);
  signal wait2_in   : std_logic_vector(wait2Len-1 downto 0);

  signal sq_in    : std_logic_vector(2**sqLenExp-1 downto 0);
  signal sqLen_in : std_logic_vector(sqLenExp-1 downto 0) := "001";


  signal configuring : std_logic;
  signal giddyup_q   : std_logic;
  signal seq_reset_q   : std_logic;

  signal waitMinReg, waitMinReg_next, dif, dif_next : integer range 0 to 2**waitLen-1          := 0;
  signal dif_slv                                    : std_logic_vector(waitLen-1 downto 0)     := (others => '0');
  signal wait2reg, wait2reg_next, ctdn, ctdn_next   : integer range 0 to 2**wait2Len-1         := 0;
  signal rptReg, rptReg_next, rpt, rpt_next         : integer range 0 to 2**rptLen-1           := 0;
  signal rpt2, rpt2_next                            : integer range 0 to 2**rpt2Len-1          := 0;
  signal outBit, outBit_next                        : std_logic;
  signal testFlag_next                              : std_logic                                := '0';  -- testFlag_out should get testFlag_next on clock edge
  signal testFlag_ctdn, testFlag_ctdn_next          : integer range 0 to 2**wait2Len-1;
  type states is (waiting, countdown, trigger, cycle_finished);
  signal state, nextState                           : states                                   := cycle_finished;
  signal sq, sq_next                                : std_logic_vector(2**sqLenExp-1 downto 0) := (others => '0');
  signal sqLen, sqLen_next                          : integer range 1 to 2**sqLenExp-1         := 1;  -- has to have 1 bit of output, or what's the point?
-- LFSR hardcoded to 32 bits because if you change the length, you have to change the XOR taps
-- to avoid short repeat cycles, and that's too complicated to reconfigure in firmwre.
  signal LFSR, LFSR_next                            : std_logic_vector(31 downto 0)            := x"5F0BE833";
  signal jitterMask, jitterMask_next                : std_logic_vector(waitLen-1 downto 0)     := (others => '0');
  signal jitterValid_ctdn, jitterValid_ctdn_next    : integer range 0 to waitLen-1             := 0;
  signal jitter, jitter_next                        : integer range 0 to 2**30-1               := 0;  -- range restricted due to VHDL integer type range limitation


begin

  -- *** building the large registers from multiple 16b inputs
  waitMin_in <= waitMin16_in & "0000";    -- range 38Hz-40MHz, 2.5MHz steps
  waitMax_in <= waitMax16_in & "0000";    -- range 38Hz-40MHz, 2.5MHz steps
  --wait2_in   <= wait2_in & "00000000";  -- range 25ns-0.4s, 6.2us steps, 
  wait2_in   <= wait2_16_in & "0000";     -- range 25ns-26ms, 400us steps, 

  -- disabled pattern - sequencer is for that
  sqLen_in <= "001";                    --tpattern_reg_in(sqLenExp-1+8 downto 8);
  sq_in    <= x"01";                    --tpattern_reg_in(2**sqLenExp-1 downto 0);

  -- *** need to register here to stretch giddy to the 40MHz domain 
  giddyup_q <= giddyup_in when rising_edge(clock);
  seq_reset_q <= seq_reset_i when rising_edge(clock);


-------- synchronous assignments        ----------------
  process(clock, reset, sqLen)
  begin
    if(reset = '1') then
      state                      <= cycle_finished;
      rptReg                     <= 0;
      waitMinReg                 <= 0;
      wait2reg                   <= 0;
      rpt                        <= 0;
      ctdn                       <= 0;
      rpt2                       <= 0;
      outBit                     <= '0';
      testFlag_out               <= '0';
      testFlag_ctdn              <= 0;
      -- next 2 lines set default sequence to "000...001" 
      sq(2**sqLenExp-1 downto 1) <= (others => '0');
      sq(0)                      <= '1';
      sqLen                      <= 1;
      LFSR                       <= x"01121971";  -- random. Init. value: doesn't particularly matter, just can't be all 0.
      jitterMask                 <= (others => '0');
      jitterValid_ctdn           <= 0;
      jitter                     <= 0;
      dif                        <= 0;
    elsif(clock'event and clock = '1')then
      if (strobe40_i = '0') then
        if (seq_reset_i = '1') or (seq_reset_q = '1') then
          state <= waiting;
        else
          state                    <= nextState;
        end if;
        
        rptReg                   <= rptReg_next;
        waitMinReg               <= waitMinReg_next;
        wait2reg                 <= wait2reg_next;
        rpt                      <= rpt_next;
        ctdn                     <= ctdn_next;
        rpt2                     <= rpt2_next;
        outBit                   <= outbit_next;
        testFlag_out             <= testFlag_next;
        testFlag_ctdn            <= testFlag_ctdn_next;
        sq                       <= sq_next;
        sqLen                    <= sqLen_next;
        LFSR                     <= LFSR_next;
        jitterMask               <= jitterMask_next;
        jitterValid_ctdn         <= jitterValid_ctdn_next;
        jitter                   <= jitter_next;
        dif                      <= dif_next;
      end if;
    end if;
  end process;
-------------------------------------------------

--------------- persistent assignments  -------------------
  outBit_out <= outBit;
  dif_slv    <= std_logic_vector(to_unsigned(dif, waitLen));
--------------------------------------------------------------

-------------- test flag logic          -----------------------
-- raises a long-lived flag visible on 'scope/logic analyzer over full-burst timescales 
  testFlag_ctdn_next <= waitMinReg/8         when outbit = '1'
                        else testFlag_ctdn-1 when testFlag_ctdn > 0
                        else 0;
  testFlag_next      <= '1'                  when testflag_ctdn > 0 else '0';
-------------------------------------------------------

------------------ jitter mask/prng     -------------------
-- linear feedback shift register for pseudo-random number generation
-- jitter sampled by burster OR value out-of-range
-- for 32-bit LFSR, maximal cycle obtained from tapping bits 1, 2, 22, 32
  LFSR_next <= (LFSR(31) xor (LFSR(21) xor (LFSR(1) xor LFSR(0)))) & LFSR(31 downto 1) when ((state = trigger and ctdn = 0) or (jitter > dif and jitterValid_ctdn = 0))
               else LFSR;

-- LFSR mask: Only 1/2 of masked LFSR values (worst-case) are out-of-range.
  jitterMask_next       <= (others => '0')         when configuring <= '0'  -- clear on reconfig. signal
                     else dif_slv(waitLen-1) & (jitterMask(waitLen-1 downto 1) or dif_slv(waitLen-2 downto 0));  -- max-min difference should be valid on first clock after config trigger
  jitterValid_ctdn_next <= waitLen-1               when configuring = '1'
                           else jitterValid_ctdn-1 when jitterValid_ctdn > 0
                           else 0;
  jitter_next           <= to_integer(unsigned(LFSR(waitLen-1 downto 0) and jitterMask(waitLen-1 downto 0)));
-------------------------------------------------------


  process(rptReg, waitMinReg, wait2reg,
          giddyup_in, jitterValid_ctdn_next,
          rpt_in, waitMin_in, waitMax_in, rpt2_in, wait2_in,
          sq, sq_in, sqLen, sqLen_in,
          dif, state,                   --trigger_in, config_in,
          busy_i, jitter,
          rpt, ctdn, rpt2, giddyup_q, seq_reset_i, seq_reset_q
          )
  begin
----- defaults                          -------
    rptReg_next     <= rptReg;
    waitMinReg_next <= waitMinReg;
    wait2reg_next   <= wait2reg;
    rpt_next        <= rpt;
    ctdn_next       <= ctdn;
    rpt2_next       <= rpt2;
    outBit_next     <= '0';
    sq_next         <= sq;
    sqLen_next      <= sqLen;
    dif_next        <= dif;
    ready_o         <= '0';
    running_o       <= '0';
    finished_o      <= '0';

    -- *** because we don't use config_in, I need a way to update things that
    -- use it, meet "configuring" that is hi when waiting
    configuring     <= '0';
-----------------------
    case state is
      when waiting =>
        configuring <= '1';
        ready_o     <= '1';

        -- *** we already store these valuses, so I just update them until the sm moves on
        rptReg_next     <= to_integer(unsigned(rpt_in));
        waitMinReg_next <= to_integer(unsigned(waitMin_in));
        dif_next        <= to_integer(unsigned(waitMax_in)) - to_integer(unsigned(waitMin_in));
        wait2reg_next   <= to_integer(unsigned(wait2_in));
        sq_next         <= sq_in;
        sqLen_next      <= to_integer(unsigned(sqLen_in));
        rpt_next        <= to_integer(unsigned(rpt_in));
        ctdn_next       <= to_integer(unsigned(waitMax_in));
        rpt2_next       <= to_integer(unsigned(rpt2_in));

        -- *** don't need trigger_in now - we only have one "go" - giddyup
        --if(trigger_in = '1')then
        if(giddyup_in = '1') or (giddyup_q = '1') then  --*** need giddy active for 2 80M cycles
          configuring <= '0';
          nextState   <= countdown;
          ctdn_next   <= 32;            -- 32 ticks before first readout ensures jitter mask has time to stabilize.
        else
          nextState   <= waiting;
          ctdn_next   <= 0;
        end if;
        --if(config_in = '1')then
        --  -- register config. values
        --  rptReg_next     <= to_integer(unsigned(rpt_in));
        --  waitMinReg_next <= to_integer(unsigned(waitMin_in));
        --  dif_next        <= to_integer(unsigned(waitMax_in)) - to_integer(unsigned(waitMin_in));
        --  wait2reg_next   <= to_integer(unsigned(wait2_in));
        --  sq_next         <= sq_in;
        --  sqLen_next      <= to_integer(unsigned(sqLen_in));
        --  rpt_next        <= to_integer(unsigned(rpt_in));
        --  ctdn_next       <= to_integer(unsigned(waitMax_in));
        --  rpt2_next       <= to_integer(unsigned(rpt2_in));
        --end if;
        ---- else current values persist
        --else
        --  nextState <= waiting;
        --end if;                       -- end if(trigger_in='1')

      when countdown =>
        running_o <= '1';


-- should iherit ctdn = 32 from "waiting" state
-- should inherit ctdn = waitmin + jitter from "trigger" state
        if(ctdn = 0 and busy_i = '0')then
          nextState <= trigger;
          ctdn_next <= sqLen-1;
        elsif(ctdn = 0)then
          nextState <= countdown;
          ctdn_next <= 0;
        else
          nextState <= countdown;
          ctdn_next <= ctdn -1;
        end if;

      when trigger =>
        running_o   <= '1';
        outBit_next <= sq(ctdn);        -- should inherit ctdn = sqLen-1;
        if(ctdn = 0 and rpt = 0 and rpt2 = 0)then
          --***nextState <= waiting;
          nextState <= cycle_finished;
          rpt_next  <= 0;
          ctdn_next <= 0;
          rpt2_next <= 0;
        elsif(ctdn = 0 and rpt = 0)then
          nextState <= countdown;
          ctdn_next <= wait2reg;
          rpt_next  <= rptReg;
          rpt2_next <= rpt2-1;
        elsif(ctdn = 0)then
          nextState <= countdown;
          ctdn_next <= waitMinReg + jitter;
          rpt_next  <= rpt-1;
          rpt2_next <= rpt2;
        else
          ctdn_next <= ctdn-1;
          nextState <= trigger;
        end if;

      when cycle_finished =>
        nextState   <= cycle_finished;
        finished_o  <= '1';
        -- seq_reset now acts on the state variable directly - more control
        --if (seq_reset_i = '1') or (seq_reset_q = '1') then
        --  nextState <= waiting;
        --end if;

    end case;
  end process;

  trigs_count_o  <= std_logic_vector(to_unsigned(rpt, 16));
  bursts_count_o <= std_logic_vector(to_unsigned(rpt2, 16));


end rtl;
