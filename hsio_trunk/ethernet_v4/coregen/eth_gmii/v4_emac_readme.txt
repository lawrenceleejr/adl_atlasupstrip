                                       

                    Core Name: Xilinx Virtex 4 Embedded Tri-Mode Ethernet MAC
                    Version: 4.6
                    Release Date: March 24, 2008


================================================================================

This document contains the following sections: 

1. Introduction
2. New Features
3. Resolved Issues
4. Known Issues 
5. Technical Support
6. Other Information
7. Core Release History
 
================================================================================
 
1. INTRODUCTION

For the most recent updates to the IP installation instructions for this core,
please go to:

   http://www.xilinx.com/ipcenter/coregen/ip_update_install_instructions.htm

 
For system requirements:

   http://www.xilinx.com/ipcenter/coregen/ip_update_system_requirements.htm 


This file contains release notes for the Xilinx LogiCORE Virtex-4 Embedded MAC
solution. For the latest core updates, see the product page at:
 
  http://www.xilinx.com/products/ipcenter/Embedded_TEMAC_Wrapper.htm


2. NEW FEATURES  
 
   - ISE 10.1i software support
   - New 16-bit client example design runs at 2 Gbps

 
3. RESOLVED ISSUES 
 
   - Incorrect data can be read out of the RX LL FIFO if rd_dst_rdy_n has been de-asserted
      - See AR #29660
      - A pipelined version of the frame_in_fifo signal is now used to ensure valid frame data
   - In the simulation scripts, $XILINX has been changed to $env(XILINX) for
     better TCL support.
   - Addresses entered in for UNICAST_PAUSE_ADDRESS in the GUI now are written correctly
     to the wrapper.

 
4. KNOWN ISSUES 
   
  The most recent information, including known issues, workarounds, and
  resolutions for this version is provided in the release notes Answer Record
  for the ISE 10.1i IP Update at 

  http://www.xilinx.com/support/answers/29767.htm


5. TECHNICAL SUPPORT 

   To obtain technical support, create a WebCase at www.xilinx.com/support.
   Questions are routed to a team with expertise using this product.  
     
   Xilinx provides technical support for use of this product when used
   according to the guidelines described in the core documentation, and
   cannot guarantee timing, functionality, or support of this product for
   designs that do not follow specified guidelines.


6. OTHER INFORMATION

   Please refer to the Getting Started Guide for more information
   on how to set up and use the Virtex-4 Embedded MAC wrapper and
   example design.

7. CORE RELEASE HISTORY 

Date       By          Version     Description
=================================================================
3/24/2008  Xilinx, Inc   4.6       Release for ISE 10.1i
8/1/2007   Xilinx, Inc   4.5       Release for ISE 9.2i
3/1/2007   Xilinx, Inc   4.4       Release for ISE 9.1i
9/21/2006  Xilinx, Inc   4.3       Updated hierarchy.
7/13/2006  Xilinx, Inc   4.2
1/18/2006  Xilinx, Inc.  4.1       Release for ISE 8.1i
=================================================================



(c) 2002-2007 Xilinx, Inc. All Rights Reserved. <Enter range of dates starting
with first year core released>


XILINX, the Xilinx logo, and other designated brands included herein are
trademarks of Xilinx, Inc. All other trademarks are the property of their
respective owners.

Xilinx is disclosing this user guide, manual, release note, and/or
specification (the Documentation) to you solely for use in the development
of designs to operate with Xilinx hardware devices. You may not reproduce, 
distribute, republish, download, display, post, or transmit the Documentation
in any form or by any means including, but not limited to, electronic,
mechanical, photocopying, recording, or otherwise, without the prior written 
consent of Xilinx. Xilinx expressly disclaims any liability arising out of
your use of the Documentation.  Xilinx reserves the right, at its sole 
discretion, to change the Documentation without notice at any time. Xilinx
assumes no obligation to correct any errors contained in the Documentation, or
to advise you of any corrections or updates. Xilinx expressly disclaims any
liability in connection with technical support or assistance that may be
provided to you in connection with the information. THE DOCUMENTATION IS
DISCLOSED TO YOU AS-IS WITH NO WARRANTY OF ANY KIND. XILINX MAKES NO 
OTHER WARRANTIES, WHETHER EXPRESS, IMPLIED, OR STATUTORY, REGARDING THE
DOCUMENTATION, INCLUDING ANY WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
PARTICULAR PURPOSE, OR NONINFRINGEMENT OF THIRD-PARTY RIGHTS. IN NO EVENT 
WILL XILINX BE LIABLE FOR ANY CONSEQUENTIAL, INDIRECT, EXEMPLARY, SPECIAL, OR
INCIDENTAL DAMAGES, INCLUDING ANY LOSS OF DATA OR LOST PROFITS, ARISING FROM
YOUR USE OF THE DOCUMENTATION.



