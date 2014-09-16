-------------------------------------------------------------------------------
-- Title      : Virtex-4 FX GT11 to Virtex-II Pro MGT RocketIO Logic Shim
-- Project    : Virtex-4 FX Ethernet MAC Wrappers
-------------------------------------------------------------------------------
-- File       : gt11_to_gt_rxclkcorcnt_shim.vhd
-------------------------------------------------------------------------------
-- Copyright (c) 2004-2005 by Xilinx, Inc. All rights reserved.
-- This text/file contains proprietary, confidential
-- information of Xilinx, Inc., is distributed under license
-- from Xilinx, Inc., and may be used, copied and/or
-- disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc. Xilinx hereby grants you
-- a license to use this text/file solely for design, simulation,
-- implementation and creation of design files limited
-- to Xilinx devices or technologies. Use with non-Xilinx
-- devices or technologies is expressly prohibited and
-- immediately terminates your license unless covered by
-- a separate agreement.
--
-- Xilinx is providing this design, code, or information
-- "as is" solely for use in developing programs and
-- solutions for Xilinx devices. By providing this design,
-- code, or information as one possible implementation of
-- this feature, application or standard, Xilinx is making no
-- representation that this implementation is free from any
-- claims of infringement. You are responsible for
-- obtaining any rights you may require for your implementation.
-- Xilinx expressly disclaims any warranty whatsoever with
-- respect to the adequacy of the implementation, including
-- but not limited to any warranties or representations that this
-- implementation is free from claims of infringement, implied
-- warranties of merchantability or fitness for a particular
-- purpose.
--
-- Xilinx products are not intended for use in life support
-- appliances, devices, or systems. Use in such applications are
-- expressly prohibited.
--
-- This copyright and support notice must be retained as part
-- of this text at all times. (c) Copyright 2004-2005 Xilinx, Inc.
-- All rights reserved.

------------------------------------------------------------------------
-- Description:  This is the VHDL instantiation of a Virtex-4 FX GT11     
--               to Virtex-II Pro MGT RocketIO Logic Shim.
------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity gt11togt_rxclkcorcnt_shim IS
   port (
      rxusrclk2               : in std_logic;   
      rxstatus                : in std_logic_vector(5 downto 0);   
      rxnotintable            : in std_logic;   
      rxd_in                  : in std_logic_vector(7 downto 0);   
      rxcharisk_in            : in std_logic;   
      rxrundisp_in            : in std_logic;   
      rxclkcorcnt             : out std_logic_vector(2 downto 0);   
      rxd_out                 : out std_logic_vector(7 downto 0);   
      rxcharisk_out           : out std_logic;   
      rxrundisp_out           : out std_logic);   
end entity gt11togt_rxclkcorcnt_shim;


architecture rtl of gt11togt_rxclkcorcnt_shim is


begin


  ----------------------------------------------------------------------
  -- Generate Virtex-II Pro style "RXCLKCORCNT" signal from the Virtex4
  -- RXSTATUS signal
  ----------------------------------------------------------------------

   gen_rxclkcorcnt: process (rxusrclk2)
   begin
      if rxusrclk2'event and rxusrclk2 = '1' then
         if rxstatus(4) = '1' and rxstatus(3) = '0' then
            if rxstatus(0) = '1' then
               rxclkcorcnt <= "100";   -- An /I2/ has been inserted    
            else
               rxclkcorcnt <= "001";   -- An /I2/ has been removed
            end if; 
         else                           
            rxclkcorcnt <= "000";      -- Indicates no clock correction    
         end if;                
      end if;
   end process gen_rxclkcorcnt;



  ----------------------------------------------------------------------
  -- When the RXNOTINTABLE condition is detected, the Virtex4 RocketIO
  -- outputs the raw 10B code in a bit swapped order to that of the
  -- Virtex-II Pro RocketIO.
  ----------------------------------------------------------------------

  gen_rxdata : process (rxnotintable, rxcharisk_in, rxd_in, rxrundisp_in)
  begin
    if rxnotintable = '1' then
      rxd_out(0)    <= rxcharisk_in; 
      rxd_out(1)    <= rxrundisp_in;
      rxd_out(2)    <= rxd_in(7); 
      rxd_out(3)    <= rxd_in(6); 
      rxd_out(4)    <= rxd_in(5); 
      rxd_out(5)    <= rxd_in(4); 
      rxd_out(6)    <= rxd_in(3); 
      rxd_out(7)    <= rxd_in(2); 
      rxrundisp_out <= rxd_in(1);    
      rxcharisk_out <= rxd_in(0);    

    else
      rxd_out       <= rxd_in;
      rxrundisp_out <= rxrundisp_in;    
      rxcharisk_out <= rxcharisk_in;    

    end if;
  end process gen_rxdata;  



end architecture rtl;
