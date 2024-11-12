/*-----------------------------------------------------------------
File name     : run.f
Description   : lab01_data simulator run template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
              : Set $UVMHOME to install directory of UVM library
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/
// 64 bit option for AWS labs
-64

 -uvmhome $UVMHOME

// include directories
//*** add incdir include directories here

-incdir ../sv       //include sv for directory files
//+UVM_TESTNAME=base_test
//+UVM_VERBOSITY=UVM_HIGH

//default timescale
-timescale 1ns/1ns


//../sv/yapp_pkg.sv   //compile yapp package
//../sv/yapp_if.sv    //UVM interfaces
//clkgen.sv           //clock generator module
//tb_top.sv              //compile top level module for UVM test environment
//hw_top.sv          //accelerated top module for interface instance

// compile files
//*** add compile files here

//YAPP incdir, UVC package and interface

-incdir ../../yapp/sv
../../yapp/sv/yapp_pkg.sv
../../yapp/sv/yapp_if.sv

//Channel incdir, UVC package and interface

-incdir ../../channel/sv
../../channel/sv/channel_pkg.sv
../../channel/sv/channel_if.sv

//HBUS incdir, UVC package and interface

-incdir ../../hbus/sv
../../hbus/sv/hbus_pkg.sv
../../hbus/sv/hbus_if.sv

//Clock and Reset incdir, UVC package and interface

-incdir ../../clock_and_reset/sv
../../clock_and_reset/sv/clock_and_reset_pkg.sv
../../clock_and_reset/sv/clock_and_reset_if.sv

../sv/router_module_pkg.sv

clkgen.sv           //clock generator module

tb_top.sv              //compile top level module for UVM test environment
hw_top.sv          //accelerated top module for interface instance


../../router_rtl/yapp_router.sv     //router RTL

