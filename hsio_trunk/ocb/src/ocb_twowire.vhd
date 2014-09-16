--
-- Opcode Block TWOWIRE
-- 
-- To 2-wire serial interface for hopefully all 2-wire serial devices (I2C, SHT71, SPI etc.)
--
-- The first word contains controls applicable to the whole packet(let). These are
-- things like destination port (there are 16 serial busses possible) or clock
-- invert (if this ever needs to be implemented)
--
-- 
-- Each word sent (except the first) is in the form (8b command; 8b data). 
-- Each does a single operation and has a corrosponding response word in the reply packet
-- (even if it didn't expect any data)
-- If there is a timeout waiting for an operation to respond, the data
-- returned, and all subsequent data, will be 0xF00B.
-- As (so far) we have no sensor that returns 16b data, a 1 in the returned msb
-- used to indicate and error.
--
-- A new packetlet can be started by inserting a word of command type 7 as a separtor
--
--
-- Command Protocol:
-- 7:5: protocol: 0=i2c, 2=sht71, 4=spi, 7=new packeltlet, rest=reserved
-- 4: stop (append)
-- 3: start (prepend)
-- 2: send byte
-- 1:0 get n bytes (but 3 will be treated like 2!)

-- The command protocal allows a start + send byte + get 2 bytes + stop in a
-- single word. The must be considered amazing only because it took me 2 weeks
-- of iterating to come up with this most obvious protocol. There is no
-- accounting for Super Caravel induced stupidy.
--
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library utils;
use utils.pkg_types.all;

library hsio;
use hsio.pkg_core_globals.all;

library locallink;


entity ocb_twowire is
   port( 
      --tw_exec_i : in std_logic;
      -- oc rx interface
      oc_valid_i    : in     std_logic;
      oc_data_i     : in     slv16;
      oc_dack_no    : out    std_logic;
      -- locallink tx interface
      lls_o         : out    t_llsrc;
      lld_i         : in     std_logic;
      -- serialiser
      tick_400khz_i : in     std_logic;   --100kHz
      tick_40khz_i  : in     std_logic;   -- 10kHz
      tick_4khz_i   : in     std_logic;   -- 1kHz
      wdog_tick_i   : in     std_logic;
      sck_dbg_o     : out    std_logic;
      sda_dbg_o     : out    std_logic;
      sda_in_dbg_o  : out    std_logic;
      sda_t_dbg_o   : out    std_logic;
      sck_o         : out    slv16;
      sck_to        : out    slv16;
      sda_o         : out    slv16;
      sda_to        : out    slv16;
      sda_i         : in     slv16;
      -- infrastructure
      clk           : in     std_logic;
      rst           : in     std_logic
   );

-- Declarations

end ocb_twowire ;


architecture rtl of ocb_twowire is

  component ll_fifo_ack_gen
    port(
      data_i   : in  slv16;
      wren_i   : in  std_logic;
      eof_i    : in  std_logic;
      sof_i    : in  std_logic;
      send_i   : in  std_logic;
      opcode_i : in  slv16;
      ocseq_i  : in  slv16;
      size_i   : in  slv16;
      busy_o   : out std_logic;
      -- locallink tx interface
      lls_o    : out t_llsrc;
      lld_i    : in  std_logic;
      clk      : in  std_logic;
      rst      : in  std_logic
      );
  end component;


  component cg_spram1kx18
    port (
      clka  : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(9 downto 0);
      dina  : in  std_logic_vector(17 downto 0);
      douta : out std_logic_vector(17 downto 0)
      );
  end component;


  signal ram_we       : std_logic;
  signal ram_wea00    : std_logic_vector(0 downto 0);
  signal ram_din      : slv18;
  signal ram_dout     : slv18;
  signal ram_ocdata   : slv16;
  signal ram_ocvalid  : std_logic;
  signal ram_addr     : slv10;
  signal ram_addr_inc : std_logic;
  signal ram_addr_clr : std_logic;


  signal fifo_we   : std_logic;
  signal fifo_sof  : std_logic;
  signal fifo_eof  : std_logic;
  signal fifo_data : slv16;

  signal tx_opcode : slv16;
  signal tx_size   : slv16;

  signal rx_opcode    : slv16;
  signal rx_opcode_we : std_logic;
  signal oc_opcodepl    : slv16;

  signal rx_ocseq    : slv16;
  signal rx_ocseq_we : std_logic;

  signal rx_size     : slv16;
  signal rx_size_we  : std_logic;
  signal rx_size_int : integer range 0 to 127;

  signal rx_data    : slv16;
  signal rx_data_we : std_logic;

  signal rx_word0    : slv16;
  signal rx_word0_we : std_logic;

  signal dest_port : integer range 0 to 15;

  signal serial_on : std_logic;

  signal tick_count : slv2;

  signal sck_select : slv4;
  signal sck_clk    : std_logic;
  signal sck_tick   : std_logic;
  signal sck_2tick  : std_logic;
  signal sck_4tick  : std_logic;
  signal sck_rising : std_logic;
  signal sck_hi     : std_logic;
-- signal sck_lo : std_logic;
  signal sck_en     : std_logic;
  signal sck        : std_logic;
  signal sda        : std_logic;
  signal sda_t      : slv16;
  signal sda_in     : std_logic;

  signal ecount     : integer range 0 to 15;
  signal ecount_clr : std_logic;
  signal ecount16   : std_logic;
  signal ccount     : integer range 0 to 15;
  signal ccount_clr : std_logic;
  signal ccount_inc : std_logic;
  signal wcount     : integer range 0 to 255;
  signal wcount_clr : std_logic;
  signal wcount_inc : std_logic;

  constant WDOG_MAX : integer := 7;
  signal   wdog     : integer range 0 to WDOG_MAX;
  signal   wdog_clr : std_logic;
  signal   bark     : std_logic;

  signal reply_busy : std_logic;
  signal reply_send : std_logic;

  signal sdcmd      : slv8;
  signal sdcmd_mode : slv3;

  signal sdout    : std_logic_vector(0 to 7);  -- this is to reverse bit order
  signal sdin     : slv16;
  signal sdin_clr : std_logic;

  signal shift_en : std_logic;

  signal io_done : std_logic;


  constant DEST_TOP_DCS0 : integer := 0;
  constant DEST_TOP_DCS1 : integer := 1;
  constant DEST_TOP_DCS2 : integer := 2;
  constant DEST_BOT_DCS0 : integer := 4;
  constant DEST_BOT_DCS1 : integer := 5;
  constant DEST_BOT_DCS2 : integer := 6;
  constant DEST_SPI0     : integer := 8;
  constant DEST_AUX0     : integer := 12;

  constant B_GET1  : integer := 0;
  constant B_GET2  : integer := 1;
  constant B_SEND1 : integer := 2;
  constant B_START : integer := 3;
  constant B_STOP  : integer := 4;
  constant B_MODE0 : integer := 5;
  constant B_MODE1 : integer := 6;
  constant B_MODE2 : integer := 7;

  constant MODE_I2C : slv3 := "000";
  constant MODE_SHT : slv3 := "010";
  constant MODE_SPI : slv3 := "100";
  constant MODE_END : slv3 := "111";



  -- Bit Allocations
  -- 
  -- 7:5  Protocol  0=I2C, 2=SHT, 4=SPI, 7=new packetlet, rest=reserved
  --   4  Append Stop
  --   3  Prepend Start
  --   2  Send Byte
  -- 1:0  Get N Bytes (where N is 0,1,2)

  constant SHT_CMD_SWC  : slv4 := x"c";
  constant SHT_CMD_SB   : slv4 := x"4";
  constant SHT_CMD_GS   : slv4 := x"d";
  constant SHT_CMD_GTH  : slv4 := x"e";
  constant SHT_CMD_GTH2 : slv4 := x"f";  -- same as above, optional interp of settings

  -- SHT71
  ------------------------------------------------------
  -- 0x4c06 - Send Write command only (issue before WriteByte)
  -- 0x44nn - Send byte (issue after WriteCmdOnly)
  -- 0x4d07 - Get/Read Stats (returns 1 byte in LSB)
  -- 0x4f03 - Get/Read Temp (returns 2 bytes)
  -- 0x4f05 - Get/Read Humi (returns 2 bytes)


  -- I2C 
  -------------------------------------------------------
  -- 0x04nn - Send byte
  -- 0x01.. - Get  byte
  -- 0x02.. - Get word (2 bytes)
  -- 0x0Cnn - Start + Send byte (for addressing chips)
  -- 0x0Dnn - Start + Send byte + Get Byte
  -- 0x0Enn - Start + Send byte + Get 2 Bytes
  -- 0x1N.. - Do above + append stop



  type states is (
    FillRAM, ExecuteRAM, ExecuteRAM1,
    RXHeader0, RXHeader1, RXHeader2,
    ControlWord, DoWord, DoWord1, DoCommand,
    NextWord, NextBlock, NextBlock1,
    InvalidCmdNextWord, WaitOCEnd,
    SendReply, SendReply1, SendBark, SendBark1,
    DoI2C, DoI2C_Start, DoI2C_Send0, DoI2C_Send1,
    DoI2C_Get0, DoI2C_Get1, DoI2C_Get2, DoI2C_StopAck, DoI2C_Stop,
    DoSHT, DoSHT_SendByte, DoSHT_SendCmdOnly, DoSHT_GetStat, DoSHT_GetHT, DoneSHT,
    Idle, Init
    );

  signal state, nstate : states;

  type iostates is (
    twStart,
    i2cStart, i2cStart1, i2cStart2,
    i2cStop, i2cStop1, i2cStop2, i2cStop3,
    WaitAck, WaitAck1,
    SendAck,                            --SendAck1,
    SendNAck,
    WaitSDALo, WaitSDAHi,
    GetByte, SendByte,
    ioIdle_SDA0, Done_SDA0,
    ioIdle, Done
    );


  signal ios, nios, ioCmd : iostates;

begin


oc_opcodepl <= oc_get_opcodepl(oc_data_i);


-- State Machine
--------------------------------------------------------
  prc_controller_sync : process (clk)
  begin
    if rising_edge (clk) then
      if (rst = '1') then
        state   <= Init;
      else
        if (wdog = WDOG_MAX) then
          state <= SendBark;
        else
          state <= nstate;
        end if;
      end if;
    end if;
  end process;


  prc_controller_async : process (
    oc_valid_i, oc_data_i,
    reply_busy, sda_in, ram_ocvalid, ram_ocdata,
    sck_tick,                           --sck_2tick,
    ecount, ecount16, sdin, sdcmd, sdcmd_mode,
    wcount, rx_size_int,
    rx_data, ccount, io_done,
    state
    )
  begin

    -- defaults
    nstate       <= Init;
    ioCmd        <= ioIdle;
    oc_dack_no   <= 'Z';
    wcount_inc   <= '0';
    wcount_clr   <= '0';
    ccount_inc   <= '0';
    ccount_clr   <= '0';
    reply_send   <= '0';
    rx_opcode_we <= '0';
    rx_ocseq_we  <= '0';
    rx_size_we   <= '0';
    rx_word0_we  <= '0';
    rx_data_we   <= '0';
    wdog_clr     <= '1';
    bark         <= '0';
    fifo_eof     <= '0';
    fifo_sof     <= '0';
    fifo_we      <= '0';
    fifo_data    <= sdin;
    sdin_clr     <= '0';
    serial_on    <= '1';
    ram_we       <= '0';
    ram_addr_clr <= '0';
    ram_addr_inc <= '0';


    case state is
      -------------------------------------------------------------

      when Init =>
        nstate     <= Init;
        --oc_dack_no <= 'Z';
        --wdog_clr   <= '1';
        serial_on  <= '0';
        if (oc_valid_i = '0') then
          nstate   <= Idle;
        end if;


      when Idle =>
        nstate       <= Idle;
        --oc_dack_no   <= 'Z';
        --wdog_clr     <= '1';
        wcount_clr   <= '1';
        sdin_clr     <= '1';
        ram_addr_clr <= '1';
        serial_on    <= '0';

        --if (tw_exec_i = '1') then
        --  nstate <= ExecuteRAM;
        --els
        if (oc_valid_i = '1') then
          case oc_opcodepl is
            when OC_TWOWIRE => nstate <= FillRAM;
            when others     => nstate <= Init;
          end case;
        end if;


      when FillRAM =>
        nstate       <= FillRAM;
        ram_we       <= '1';
        ram_addr_inc <= '1';
        oc_dack_no   <= '0';
        if (oc_valid_i = '0') then
          nstate     <= ExecuteRAM;
        end if;


        -- Execute RAM contents  
        --------------------------------------------------------

      when ExecuteRAM =>
        ram_addr_clr <= '1';
        nstate       <= ExecuteRAM1;


      when ExecuteRAM1 =>               -- the RAM data is one clock behind ...
        ram_addr_inc <= '1';
        nstate       <= RXHeader0;


      when RXHeader0 =>
        ram_addr_inc <= '1';
        wcount_inc   <= '1';
        serial_on    <= '0';
        rx_opcode_we <= '1';
        nstate       <= RXHeader1;


      when RXHeader1 =>
        ram_addr_inc <= '1';
        wcount_inc   <= '1';
        serial_on    <= '0';
        rx_ocseq_we  <= '1';
        nstate       <= RXHeader2;


      when RXHeader2 =>
        --ram_addr_inc <= '1';          -- keep behind ..
        serial_on  <= '0';
        rx_size_we <= '1';
        wcount_clr <= '1';
        nstate     <= ControlWord;


      when ControlWord =>
        ram_addr_inc <= '1';
        rx_word0_we  <= '1';
        fifo_data    <= ram_ocdata;
        fifo_we      <= '1';
        fifo_sof     <= '1';
        wcount_inc   <= '1';
        serial_on    <= '0';
        nstate       <= DoWord;


      when DoWord =>                    -- wait for data to appear on ram_dout
        nstate <= DoWord1;

      when DoWord1 =>
        nstate       <= DoWord1;
        if (sck_tick = '1') then
          rx_data_we <= '1';
          nstate     <= DoCommand;
        end if;


        ------------------------------------------------------
      when DoCommand    =>
        ccount_clr                <= '1';
        case sdcmd_mode is
          when MODE_END => nstate <= NextBlock;
          when MODE_I2C => nstate <= DoI2C;
          when MODE_SHT => nstate <= DoSHT;
          when others   => nstate <= InvalidCmdNextWord;
        end case;


      when InvalidCmdNextWord =>
        fifo_data      <= x"F00B";
        fifo_we        <= '1';
        wcount_inc     <= '1';
        if (wcount < (rx_size_int/2)) and (ram_ocvalid = '1') then
          ram_addr_inc <= '1';
          nstate       <= DoWord;
        else
          fifo_eof     <= '1';
          nstate       <= WaitOCEnd;
        end if;


      when NextWord =>
        fifo_we        <= '1';          -- write result of just finished transaction
        wcount_inc     <= '1';
        wdog_clr       <= '1';
        if (wcount < (rx_size_int/2)) and (ram_ocvalid = '1') then
          ram_addr_inc <= '1';
          nstate       <= DoWord;
        else
          fifo_eof     <= '1';
          nstate       <= WaitOCEnd;
        end if;


      when NextBlock =>
        fifo_data      <= ram_ocdata;
        fifo_we        <= '1';
        wcount_inc     <= '1';
        wdog_clr       <= '1';
        if (wcount < (rx_size_int/2)) and (ram_ocvalid = '1') then
          ram_addr_inc <= '1';
          nstate       <= NextBlock1;   -- wait for ram to update
        else
          fifo_eof     <= '1';
          nstate       <= WaitOCEnd;
        end if;

      when NextBlock1 =>
        nstate <= ControlWord;


      when WaitOCEnd =>
        nstate       <= WaitOCEnd;
        ram_addr_inc <= '1';
        if (ram_ocvalid = '0') then
          nstate     <= SendReply;
        end if;


        -- Send Reply
        --------------------------------------------------------------
      when SendReply =>
        nstate     <= SendReply;
        reply_send <= '1';
        if (reply_busy = '0') then
          nstate   <= Idle;
        end if;


        -- Send Bark
        ---------------------------------------
      when SendBark =>
        nstate       <= SendBark;
        --wdog_clr     <= '1';
        fifo_data    <= x"F00B";
        fifo_we      <= '1';
        wcount_inc   <= '1';
        ram_addr_inc <= '1';
        if (ram_ocvalid = '0') then
          fifo_eof   <= '1';
          nstate     <= SendBark1;
        end if;


      when SendBark1 =>
        nstate     <= SendBark1;
        bark       <= '1';
        reply_send <= '1';
        if (reply_busy = '0') then
          nstate   <= Idle;
        end if;

        -----------------------------------------------------------------
        -----------------------------------------------------------------


      when DoI2C =>
        ccount_clr <= '1';
        sdin_clr   <= '1';
        if (sdcmd(B_START) = '1') then
          nstate   <= DoI2C_Start;
        else
          nstate   <= DoI2C_Send0;
        end if;



      when DoI2C_Start =>
        nstate   <= DoI2C_Start;
        ioCmd    <= i2cStart;
        wdog_clr <= '0';
        if (io_done = '1') then
          nstate <= DoI2C_Send0;
        end if;


      when DoI2C_Send0 =>
        ccount_clr <= '1';
        if (sdcmd(B_SEND1) = '1') then
          nstate   <= DoI2C_Send1;
        elsif (sdcmd(B_GET2) = '1') then
          nstate   <= DoI2C_Get2;
        elsif (sdcmd(B_GET1) = '1') then
          nstate   <= DoI2C_Get1;
        else
          nstate   <= DoI2C_Stop;
        end if;


      when DoI2C_Send1 =>
        nstate                   <= DoI2C_Send1;
        wdog_clr <= '0';
        ccount_inc               <= io_done;
        case ccount is
          when 0       => ioCmd  <= SendByte;
          when 1       => ioCmd  <= WaitAck;
          when 2       => nstate <= DoI2C_Get0;
          when others  => null;
        end case;


      when DoI2C_Get0 =>
        ccount_clr <= '1';
        if (sdcmd(B_GET2) = '1') then
          nstate   <= DoI2C_Get2;
        elsif (sdcmd(B_GET1) = '1') then
          nstate   <= DoI2C_Get1;
        else
          nstate   <= DoI2C_Stop;
        end if;


      when DoI2C_Get1 =>
        nstate                  <= DoI2C_Get1;
        wdog_clr <= '0';
        ccount_inc              <= io_done;
        case ccount is
          when 0      => ioCmd  <= GetByte;
                         --when 1      => ioCmd  <= SendAck;
          when 1      => nstate <= DoI2C_StopAck;
          when others => null;
        end case;


      when DoI2C_Get2 =>
        nstate                  <= DoI2C_Get2;
        wdog_clr <= '0';
        ccount_inc              <= io_done;
        case ccount is
          when 0      => ioCmd  <= GetByte;
          when 1      => ioCmd  <= SendAck;
          when 2      => ioCmd  <= GetByte;
                         --when 3      => ioCmd  <= SendAck;
          when 3      => nstate <= DoI2C_StopAck;
          when others => null;
        end case;


      when DoI2C_StopAck =>
        nstate   <= DoI2C_StopAck;
        wdog_clr <= '0';
        if (sdcmd(B_STOP) = '1') then
          ioCmd  <= SendNAck;
        else
          ioCmd  <= SendAck;
        end if;
        if (io_done = '1') then
          nstate <= DoI2C_Stop;
        end if;


      when DoI2C_Stop =>
        nstate     <= DoI2C_Stop;
        wdog_clr <= '0';
        if (sdcmd(B_STOP) = '1') then
          ioCmd    <= i2cStop;
          if (io_done = '1') then
            nstate <= NextWord;
          end if;
        else
          nstate   <= NextWord;
        end if;


        -----------------------------------------------------------------
        -----------------------------------------------------------------

        -- command byte format
        -- tp1 tp0 res stop start send1 get2 get1

      when DoSHT =>
        ccount_clr <= '1';
        sdin_clr   <= '1';

        case sdcmd(3 downto 0) is
          when SHT_CMD_SB   => nstate <= DoSHT_SendByte;
          when SHT_CMD_SWC  => nstate <= DoSHT_SendCmdOnly;
          when SHT_CMD_GS   => nstate <= DoSHT_GetStat;
          when SHT_CMD_GTH  => nstate <= DoSHT_GetHT;
          when SHT_CMD_GTH2 => nstate <= DoSHT_GetHT;
          when others       => nstate <= InvalidCmdNextWord;
        end case;



      when DoSHT_SendCmdOnly =>
        nstate     <= DoSHT_SendCmdOnly;
        wdog_clr <= '0';
        ccount_inc <= io_done;

        case ccount is
          when 0 => ioCmd  <= twStart;
          when 1 => ioCmd  <= SendByte;
          when 2 => ioCmd  <= SendNAck;
          when 3 => nstate <= DoneSHT;

          when others => null;
        end case;


      when DoSHT_SendByte =>
        nstate     <= DoSHT_SendByte;
        wdog_clr <= '0';
        ccount_inc <= io_done;

        case ccount is
          when 0      => ioCmd  <= SendByte;
          when 1      => ioCmd  <= SendNAck;
          when others => nstate <= DoneSHT;
        end case;


      when DoSHT_GetStat =>
        nstate                     <= DoSHT_GetStat;
        wdog_clr <= '0';
        ccount_inc                 <= io_done;
        case ccount is
          -- start + command
          when 0         => ioCmd  <= twStart;
          when 1         => ioCmd  <= SendByte;
          when 2         => ioCmd  <= SendNAck;  -- $%^& sht - not like the datasheet
                            -- get byte
          when 3         => ioCmd  <= GetByte;
          when 4         => ioCmd  <= SendNAck;
                            -- done                   
          when others    => nstate <= DoneSHT;
        end case;



      when DoSHT_GetHT =>
        nstate     <= DoSHT_GetHT;
        wdog_clr <= '0';
        ccount_inc <= io_done;

        case ccount is
          -- start + command
          when 0      => ioCmd  <= twStart;
          when 1      => ioCmd  <= SendByte;
          when 2      => ioCmd  <= WaitAck;
                         -- wait conv done
          when 3      => ioCmd  <= WaitSDAHi;
          when 4      => ioCmd  <= WaitSDALo;
                         -- get result
          when 5      => ioCmd  <= GetByte;
          when 6      => ioCmd  <= SendAck;
          when 7      => ioCmd  <= GetByte;
          when 8      => ioCmd  <= SendNAck;
                         -- done
          when others => nstate <= DoneSHT;
        end case;


      when DoneSHT =>
        nstate <= NextWord;






        ------ TW Mem
        ---------------------------------------------------------------

-- when TWMemLoad =>
-- ram_addr_clr <= '1';







      when others => null;
    end case;
  end process;


-----------------------------------------------------------

  prc_word_counter : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        wcount   <= 0;
      else
        if (wcount_clr = '1') then
          wcount <= 0;

        elsif (wcount_inc = '1') then
          wcount <= wcount + 1;

        end if;
      end if;
    end if;
  end process;


-----------------------------------------------------------

  prc_cmd_counter : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        ccount   <= 0;
      else
        if (ccount_clr = '1') then
          ccount <= 0;

        elsif (ccount_inc = '1') then
          ccount <= ccount + 1;

        end if;
      end if;
    end if;
  end process;

  


-- IO Worker Machine - does all IO
--------------------------------------------------------

  prc_smio_sync : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        ios   <= ioIdle;
      else
        if (wdog = WDOG_MAX) then
          ios <= ioIdle;
        else
          ios <= nios;
        end if;
      end if;
    end if;
  end process;


  prc_smio_async : process (sck_tick,   --sck_2tick,
                            reply_busy, sda_in,
                            ecount, ecount16,
                            rx_data, ioCmd, sdout,
                            ios
                            )
  begin

    -- defaults
    shift_en   <= '0';
    io_done    <= '0';
    sck_en     <= '0';
    sda        <= '1';
    ecount_clr <= '1';
    sck_hi     <= '0';
-- sck_lo <= '0';


    case ios is
      -------------------------------------------------------------

      when Done =>                      -- this releases SDA and SCK
        io_done <= '1';
        nios    <= ioIdle;


      when ioIdle =>
        nios   <= ioIdle;
        if (sck_tick = '1') then        -- always start with sck=0
          nios <= ioCmd;                -- command from control state machine
        end if;

      when Done_SDA0 =>                 -- versions of idle for keeping SDA low after e.g. a Start
        sda     <= '0';
        io_done <= '1';
        nios    <= ioIdle_SDA0;


      when ioIdle_SDA0 =>
        nios   <= ioIdle_SDA0;
        sda    <= '0';
        if (sck_tick = '1') then        -- always start with sck=0
          nios <= ioCmd;                -- command from control state machine
        end if;



        ----------------------------------------------------------
        -- Two-wire (SHT71) Stuff
        ----------------------------------------------------------

        -- tw Start                     ------------------


      when twStart =>
        nios       <= twStart;
        ecount_clr <= '0';
        sck_en     <= '1';

        case ecount is
          when 0   => sda  <= '1';      -- sck=0
          when 1   => sda  <= '1'; sck_hi <= '1';
          when 2   => sda  <= '0'; sck_hi <= '1';
          when 3   => sda  <= '0';      -- sck=1
          when 4   => sda  <= '0';      -- sck=0
          when 5   => sda  <= '0'; sck_hi <= '1';
          when 6   => sda  <= '1'; sck_hi <= '1';
          when 7   => sda  <= '1';      -- sck=1
          when 8   => sda  <= '1';      -- sck=0
                      nios <= Done;
          when
            others => null;
        end case;



        --------------------------------------------------------------
        -- I2C
        ----------------------------------------------------------

        -- I2C Start                    ----------------

      when i2cStart =>
        nios   <= i2cStart;
        sck_hi <= '1';
        if (sck_tick = '1') then
          nios <= i2cStart1;
        end if;

      when i2cStart1 =>
        nios   <= i2cStart1;
        sck_hi <= '1';
        sda    <= '0';
        if (sck_tick = '1') then
          nios <= i2cStart2;
        end if;

      when i2cStart2 =>
        nios   <= i2cStart2;
        sda    <= '0';
        if (sck_tick = '1') then
          nios <= Done_SDA0;
        end if;

        -- I2C Stop                     ----------------

      when i2cStop =>
        nios   <= i2cStop;
        sda    <= '0';
        if (sck_tick = '1') then
          nios <= i2cStop1;
        end if;

      when i2cStop1 =>
        nios   <= i2cStop1;
        sda    <= '0';
        sck_hi <= '1';
        if (sck_tick = '1') then
          nios <= i2cStop2;
        end if;

      when i2cStop2 =>
        nios   <= i2cStop2;
        sck_hi <= '1';
        if (sck_tick = '1') then
          nios <= i2cStop3;
        end if;

      when i2cStop3 =>
        nios   <= i2cStop3;
        if (sck_tick = '1') then
          nios <= Done;
        end if;


        --------------------------------------------------------------
        -- Generic Stuff
        ----------------------------------------------------------

        --  Wait Ack
        ---------------
      when WaitAck =>
        nios   <= WaitAck;
        if (sda_in = '0') and (sck_tick = '1') then
          nios <= WaitAck1;
        end if;

      when WaitAck1 =>
        nios   <= WaitAck1;
        sck_en <= '1';
        if (sck_tick = '1') then
          nios <= Done;
        end if;

        --  Send Ack
        ----------------           
      when SendAck =>
        nios   <= SendAck;
-- if ((sda_in = '1') or (sda_in = 'H')) and (sck_tick = '1') then
-- nios <= SendAck1;
-- end if;
-- when SendAck1 =>
-- nios <= SendAck1;
        sda    <= '0';
        sck_en <= '1';
        if (sck_tick = '1') then
          nios <= Done;
        end if;


        --  Send NACK
        ----------------           
      when SendNAck =>
        nios   <= SendNAck;
        sck_en <= '1';
        if (sck_tick = '1') then
          nios <= Done;
        end if;


        -- Wait SDA hi/lo
        -----------------
      when WaitSDALo =>
        nios   <= WaitSDALo;
        if (sda_in = '0') and (sck_tick = '1') then
          nios <= Done;
        end if;


      when WaitSDAHi =>
        nios   <= WaitSDAHi;
        if ((sda_in = '1') or (sda_in = 'H')) and (sck_tick = '1') then
          nios <= Done;
        end if;


        -- Get/Send Bytes
        ------------------
      when GetByte =>
        nios       <= GetByte;
        ecount_clr <= '0';
        sck_en     <= '1';
        shift_en   <= '1';
        if (ecount16 = '1') then
          nios     <= Done;
        end if;

      when SendByte =>
        nios       <= SendByte;
        ecount_clr <= '0';
        sck_en     <= '1';
        sda        <= sdout(ecount/2);
        if (ecount16 = '1') then
          nios     <= Done;
        end if;

    end case;

  end process;


-----------------------------------------------------------

  with sck_select select
    sck_4tick <= tick_4khz_i when x"2",
    tick_40khz_i             when x"1",
    tick_400khz_i            when others;


  prc_sck_gen : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        tick_count <= "00";
      else

        -- default
        sck_tick   <= '0';
        sck_2tick  <= '0';
        sck_rising <= '0';

        if (sck_4tick = '1') then
          if (tick_count = "11") then
            tick_count <= "00";
          else
            tick_count <= tick_count + '1';
          end if;

          case tick_count is
            when "00"   => sck_clk <= '1'; sck_rising <= '1';
            when "01"   => sck_clk <= '1'; sck_2tick <= '1';
            when "10"   => sck_clk <= '0';
            when "11"   => sck_clk <= '0'; sck_2tick <= '1'; sck_tick <= '1';
            when others => null;
          end case;

        end if;


      end if;
    end if;

  end process;


  prc_sck_control : process (clk)
  begin
    if rising_edge(clk) then

      if (sck_hi = '1') then
        sck <= '1';

      elsif (sck_en = '1') then
        sck <= sck_clk;

      else
        sck <= '0';

      end if;
    end if;
  end process;



---------------------------------

  prc_clockout : process (clk)
  begin
    if rising_edge(clk) then

      -- defaults
      sck_o  <= (others => '1');
      sck_to <= (others => '1');

      if (serial_on = '1') then
        if (sck = '0') then
          sck_o(dest_port)  <= '0';
          sck_to(dest_port) <= '0';

          -- sck = '1'
        elsif (sdcmd_mode = MODE_SHT) then
          sck_o(dest_port)  <= '1';
          sck_to(dest_port) <= '0';
        end if;
      end if;
    end if;
  end process;

  
  prc_sdaout : process (clk)
  begin
    if rising_edge(clk) then

      -- defaults
      sda_o <= (others => '1');
      sda_t <= (others => '1');

      if (sda = '0') and (serial_on = '1') then
        sda_o(dest_port) <= '0';
        sda_t(dest_port) <= '0';
      end if;
    end if;
  end process;

  sda_in <= sda_i(dest_port);

  sda_to <= sda_t;

  sck_dbg_o    <= sck;
  sda_dbg_o    <= sda;
  sda_t_dbg_o  <= sda_t(dest_port);
  sda_in_dbg_o <= sda_in;

-----------------------------------------------------------

  prc_clk_edge_counter : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        ecount <= 0;
      else

        -- default
        ecount16 <= '0';

        if (ecount_clr = '1') then
          ecount <= 0;

        elsif (sck_2tick = '1') then

          if (ecount = 15) then
            ecount16 <= '1';
          else
            ecount   <= ecount + 1;
          end if;

        end if;
      end if;
    end if;
  end process;


-------------------------------------------------------------------

  prc_sdin : process (clk)
  begin
    if rising_edge(clk) then
      if (sdin_clr = '1') then
        sdin <= (others => '0');

      else
        if (shift_en = '1') and (sck_rising = '1') then
          sdin <= sdin(14 downto 0) & sda_in;
        end if;

      end if;
    end if;
  end process;

-------------------------------------------------------------------


-- RX Words Store



  prc_words_store : process (clk)
  begin
    if rising_edge(clk) then

      if (rx_opcode_we = '1') then
        rx_opcode <= ram_ocdata;
      end if;

      if (rx_ocseq_we = '1') then
        rx_ocseq <= ram_ocdata;
      end if;

      if (rx_size_we = '1') then
        rx_size <= ram_ocdata;
      end if;

      if (rx_word0_we = '1') then
        rx_word0 <= ram_ocdata;
      end if;

      if (rx_data_we = '1') then
        rx_data <= ram_ocdata;
      end if;

    end if;
  end process;


  rx_size_int <= conv_integer(rx_size(6 downto 0));

  sdout      <= rx_data(7 downto 0);
  sdcmd      <= rx_data(15 downto 8);
  sdcmd_mode <= sdcmd(7 downto 5);

  dest_port  <= conv_integer(rx_word0(3 downto 0));
  sck_select <= rx_word0(7 downto 4);


------------------------------------------------------------
-- RAM Interface

  prc_ram_stores : process (clk)
  begin
    if rising_edge(clk) then

      if (ram_addr_clr = '1') then
        ram_addr <= (others => '0');
      elsif (ram_addr_inc = '1') then
        ram_addr <= ram_addr + '1';
      end if;

    end if;
  end process;
  
  opcode_ram : cg_spram1kx18
    port map (
      clka  => clk,
      wea   => ram_wea00,
      addra => ram_addr,
      dina  => ram_din,
      douta => ram_dout
      );

  ram_din   <= '0' & oc_valid_i & oc_data_i;
  ram_wea00 <= "1" when (ram_we = '1') else "0";

  ram_ocvalid <= ram_dout(16);
  ram_ocdata  <= ram_dout(15 downto 0);


------------------------------------------------------------
-- Reply Interface

  --tx_opcode <= x"F" & rx_opcode(11 downto 0) when (bark = '1') else rx_opcode;
  tx_opcode <= rx_opcode;
  tx_size   <= x"00" & conv_std_logic_vector(wcount*2, 8);


  Ureply_fifo : ll_fifo_ack_gen
    port map(
      data_i   => fifo_data,
      wren_i   => fifo_we,
      eof_i    => fifo_eof,
      sof_i    => fifo_sof,
      send_i   => reply_send,
      opcode_i => tx_opcode,
      ocseq_i  => rx_ocseq,
      size_i   => tx_size,
      busy_o   => reply_busy,
      lls_o    => lls_o,
      lld_i    => lld_i,
      clk      => clk,
      rst      => rst
      );



--================================================================================
  prc_watchdog : process (clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        wdog   <= 0;
      else
        if (wdog_clr = '1') then
          wdog <= 0;

        elsif (wdog_tick_i = '1') then
          wdog <= wdog + 1;

        end if;
      end if;
    end if;
  end process;


end architecture;






