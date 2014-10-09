-------------------------------------------------------------------------------
-- Description:
-- Swaps 16-bit words in time for pgp. The number of words has to be even.
-------------------------------------------------------------------------------
-- Copyright (c) 2010 by Martin Kocian.
-------------------------------------------------------------------------------
-- Modification history:
-- 07/21/2008: created.
-------------------------------------------------------------------------------

LIBRARY ieee;
use work.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity wordswapper is 
   port (
     rst        : in std_logic;
     clk        : in std_logic;
     wordin     : in std_logic_vector(15 downto 0);
     eofin      : in std_logic;
     eeofin     : in std_logic;
     sofin      : in std_logic;
     validin    : in std_logic;
     wordout    : out std_logic_vector(15 downto 0);
     eofout     : out std_logic;
     eeofout    : out std_logic;
     sofout     : out std_logic;
     validout   : out std_logic
     );
end wordswapper;

architecture WORDSWAPPER of wordswapper is

  signal savedword : std_logic_vector(15 downto 0);
  type state_type is (idle, firsteven, odd, even, lastodd);
  signal state: state_type;
  signal eeof: std_logic;

begin

   process (rst,clk)
   begin
     if(rst='1')then
       savedword<=x"0000";
       state<=idle;
       eofout<='0';
       sofout<='0';
       eeofout<='0';
       validout<='0';
       wordout<=x"0000";
     elsif(rising_edge(clk))then
      case state is
        when idle =>
          if(validin='1' and sofin='1')then
            eofout<='0';
            eeofout<='0';
            sofout<='0';
            validout<='0';
            wordout<=x"0000";
            savedword<=wordin;
            state<=firsteven;
          else
            validout<='0';
            eofout<='0';
            eeofout<='0';
            sofout<='0';
            wordout<=x"0000";
            state<=idle;
          end if;
        when firsteven =>
          if(validin='1')then
            sofout<='1';
            wordout<=wordin;
            eofout<='0';
            eeofout<='0';
            validout<='1';
            if(eofin='1')then
              eeof<=eeofin;
              state<=lastodd;
            else
              state<=odd;
            end if;
          else
            validout<='0';
            state<=firsteven;
          end if; 
        when odd =>
          if(validin='1')then
            sofout<='0';
            eofout<='0';
            eeofout<='0';
            validout<='1';
            wordout<=savedword;
            savedword<=wordin;
            state<=even;
          else
            validout<='0';
            sofout<='0';
            eofout<='0';
            eeofout<='0';
            state<=odd;
          end if;
        when even =>
          if(validin='1')then
            sofout<='0';
            wordout<=wordin;
            eofout<='0';
            eeofout<='0';
            validout<='1';
            if(eofin='1')then
              eeof<=eeofin;
              state<=lastodd;
            else
              state<=odd;
            end if;
          else
            validout<='0';
            state<=even;
          end if; 
        when lastodd =>
          sofout<='0';
          eofout<='1';
          eeofout<=eeof;
          validout<='1';
          wordout<=savedword;
          state<=idle;
      end case;
     end if;
  end process;
       

end WORDSWAPPER;
