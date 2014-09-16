-------------------------------------------------------------------------------
-- Title         : Version Constant File
-- Project       : HSIO 
-------------------------------------------------------------------------------
-- File          : Version.vhd
-- Author        : Martin Kocian, kocian@slac.stanford.edu
-- Created       : 01/07/2013
-------------------------------------------------------------------------------
-- Description:
-- Version Constant Module
-------------------------------------------------------------------------------
-- Copyright (c) 2012 by SLAC. All rights reserved.
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

package Version is

constant FpgaVersion : std_logic_vector(31 downto 0) := x"00000003"; -- MAKE_VERSION

end Version;

-------------------------------------------------------------------------------
-- Revision History:
-- 01/07/2013 (0x00000001): Initial XST version
-- 03/22/2013 (0x00000002): HSIO trigger/busy added to opto ucf file
-- 04/02/2013 (0x00000003): Memory buffer for triggering.

-------------------------------------------------------------------------------
