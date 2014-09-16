#===================================================================
# File:        Makefile
# Author:      David Burnette 
# Created:     July 5, 2007
# 
# Description: 
#  Makefile to build the HSIO firmware
# 
#  You can use Xilinx ISE interactively to add new RTL source files
#  to this project.
#
# Usage:
#  Use 'make help' to get a list of options.
#
# Dependencies:
#  Depends on makefile fragments in the 'MKFRAGS' directory.
#
# Revision History:
#   dgb  2007-07-05  Original version
#
#   dgb  2008-04-07  Split out files into fragments. Modified
#                    ROM source generation to be per src directory.
#
#   mrmw 2012-08-15  Decided to try to use this.
#                    Many thanks to all for prior effort.
#
#   
#
#
#===================================================================

# needs the longer path for sed
MKFRAGS := ../../ise/mkfiles
export MKFRAGS

HSIO_SRC_DIR := ../../hsio/src
export HSIO_SRC_DIR

#===================================================================
# User-modifiable variables
#

# This name must match the name of the design in Xilinx ISE (case
# sensitive). 
DESIGN_NAME := hsio_top

# Constraint files
UCF_FILES := ../../hsio/src/hsio_c02.ucf 
UCF_FILES += ../../hsio/src/hsio_c02_fx60.ucf
UCF_FILES += ../../ethernet_v4/src/eth_gmii.ucf
UCF_FILES += ../../ethernet_v4/src/eth2x16.ucf
UCF_FILES += ../../hsio/src/dummy.ucf
UCF_FILES += ../../hsio/src/hsio_ddr.ucf
UCF_FILES += ../../hsio/src/hsio_common.ucf
UCF_FILES += ../../hsio/src/hsio_c01_c02.ucf
UCF_FILES += ../../hsio/src/hsioib_eos.ucf
UCF_FILES += ../../hsio/src/hsio_c02.ucf

#COREGEN_SEARCH_PATH := ../../hsio/coregen
MACRO_PATHS := ../../hsio/coregen
MACRO_PATHS += ../../ise/corev4_ro_unit
#MACRO_PATHS += ../../ise/core_net_usb
MACRO_PATHS += ../../ise/corev4_abcn13_dig

TIMESTAMP_XST_DIR     := ../../ise/timestamp


#INTSTYLE         := -intstyle silent      # call Xilinx tools in silent mode
INTSTYLE :=

#NGDBUILD_FLAGS   := $(INTSTYLE) -dd _ngo -sd $(COREGEN_SEARCH_PATH) $(UCF_FILE_STRING)
NGDBUILD_FLAGS   := $(INTSTYLE) -dd _ngo 
MAP_FLAGS        := $(INTSTYLE) -global_opt off -cm balanced -ir off -pr b -c 100
PAR_FLAGS        := $(INTSTYLE) -w -ol high -t 1
TRCE_FLAGS       := $(INTSTYLE) -v 3 -s 11 -n 3 -fastpaths -xml
PROMGEN_FLAGS    := -c FF -x xcf32p 




# Technology family (unfortunately it cannot be extracted from ISE, yet)
FAMILY      := virtex4


#===================================================================
# You should not need to edit anything below this line

.PHONY: all
all: mcs

include $(MKFRAGS)/xilinx_rules.mk

#===================================================================
# OTHER TARGETS


.PHONY: bit
bit: $(DESIGN_NAME).bit

.PHONY: impact
impact: bit do_impact

mcs: $(DESIGN_NAME).mcs

.PHONY: help
help:
	@$(ECHO) "Use this Makefile to regenerate the entire HSIO bitstream"
	@$(ECHO) "after modifying any of the source RTL."
	@$(ECHO) ""
	@$(ECHO) "This makefile uses the following project files from the Xilinx ISE"
	@$(ECHO) "   $(XST_FILE)"
	@$(ECHO) ""
	@$(ECHO) "You use Xilinx ISE interactively to add new RTL source files."
	@$(ECHO) ""
	@$(ECHO) "  Availiable targets"
	@$(ECHO) 
	@$(ECHO) "  For building all or part of the system:"
	@$(ECHO) "    bit       - Rebuild the entire system and generate the bitstream file"
	@$(ECHO) "    prom      - Rebuild the entire system and generate an MCS prom file"
	@$(ECHO) "    all       - Rebuild everything incl .bit and .mcs (default)"
	@$(ECHO) 
	@$(ECHO) "  For downloading the bitstream to the board:"
	@$(ECHO) "    impact    - Download the bitstream to the FPGA via iMPACT"
	@$(ECHO) 
	@$(ECHO) "  For project maintenance:"
	@$(ECHO) "    help      - Print this help text"
	@$(ECHO) "    clean     - Clean up the ISE files"
	@$(ECHO) ""

.PHONY: clean
clean:
	-$(RM) *.ncd *.ngc *.ngd *.twr *.stx *.ucf.untf *.mrp *.ptwx *_map.map
	-$(RM) *.ncl *.ngm *.prm *_pad.txt *.twx *.log *.syr *.par *.exo *.xpi *.xrpt *.xml
	-$(RM) *.cmd_log *.ngr *.bld *_summary.html *.nc1 *.pcf *.bgn tmp.ut
	-$(RM) *.pad *.placed_ncd_tracker *.routed_ncd_tracker *_pad.csv *.drc
	-$(RM) *.pad_txt $(DESIGN_NAME)_impact.cmd *.unroutes $(DESIGN_NAME)_vhdl.prj *.xwbt
	-$(RMDIR) _ngo _xmsgs xst xlnx_auto_0_xdb xst_tmp_dirs


#*** s
#debug_vars:
#	@$(ECHO) "XST_FILE    = '$(XST_FILE)'"
#	@$(ECHO) "PRJ_FILE    = '$(PRJ_FILE)'"
#	@$(ECHO) "HDL_FILES   = '$(HDL_FILES)'"
#	@$(ECHO) "PART        = '$(PART)'"
#	@$(ECHO) "DEVICE      = '$(DEVICE)'"
#	@$(ECHO) "SPEED       = '$(SPEED)'"
#	@$(ECHO) "PACKAGE     = '$(PACKAGE)'"
#	@$(ECHO) "UCF_FILE    = '$(UCF_FILE)'"
#	@$(ECHO) "BSD_FILE    = '$(BSD_FILE)'"
#	@$(ECHO) "XSTHDPDIR   = '$(XSTHDPDIR)'"
#	@$(ECHO) "TMPDIR      = '$(TMPDIR)'"
#*** e
