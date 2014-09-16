-------------------------------------------------------------------------------
-- Title      : Virtex-4 FX GT11 to Virtex-II Pro MGT RocketIO Logic Shim
-- Project    : Virtex-4 Embedded Tri-Mode Ethernet MAC Wrapper
-- File       : gt11_to_gt_rxclkcorcnt_shim.vhd
-- Version    : 4.8
-------------------------------------------------------------------------------
--
-- (c) Copyright 2004-2010 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
--
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
