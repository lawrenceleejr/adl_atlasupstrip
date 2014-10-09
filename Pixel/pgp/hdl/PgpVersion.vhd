-------------------------------------------------------------------------------
-- Title         : Pretty Good Protocol, Version Constant
-- Project       : General Purpose Core
-------------------------------------------------------------------------------
-- File          : PgpVersion.vhd
-- Author        : Ryan Herbst, rherbst@slac.stanford.edu
-- Created       : 10/24/2006
-------------------------------------------------------------------------------
-- Description:
-- Version Constant module for the Pretty Good Protocol core. 
-------------------------------------------------------------------------------
-- Copyright (c) 2006 by Ryan Herbst. All rights reserved.
-------------------------------------------------------------------------------
-- Modification history:
-- 10/24/2006: created.
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

package PgpVersion is

   constant PgpVersion : std_logic_vector(7 downto 0) := "11001110";

end PgpVersion;

-------------------------------------------------------------------------------
-- Revision History:
-- 10/24/2006 (0x00): Initial Version
-- 03/22/2006 (0xC8): Changed to non-zero version value
-- 06/08/2007 (0xC9): Changed CRC Reset and RX/TX PLL Lock Tracking
-- 06/11/2007 (0xCA): Clock now generated externally. Reverted back to original
--                    initialization sequence.
-- 06/14/2007 (0xCB): Fixed link state init to follow Xilinx spec. Fixed 
--                    generation of error increment signals.
-- 08/27/2007 (0xCC): Link init now matches xilinx exactly. Changed cell structure
--                    to close all open error cases.
-- 09/18/2007 (0xCD): Added enforcement of cell size on receive for PIC interface.
--                    Also added frame abort if SOF is received while in frame.
-- 09/19/2007 (0xCE): Changed force frame signal to PIC mode signal. Added next
--                    cell drop after error cell in order to give time to abort 
--                    the each active VC to the PIC
-------------------------------------------------------------------------------

