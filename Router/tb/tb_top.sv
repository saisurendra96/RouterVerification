/*-----------------------------------------------------------------
File name     : top.sv
Description   : lab01_data top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module tb_top;
// import the UVM library
import uvm_pkg::*;
// include the UVM macros
`include "uvm_macros.svh"

// import the YAPP package
import yapp_pkg::*;

//import the HBUS UVC package
import hbus_pkg::*;

//import the channel UVC package
import channel_pkg::*;

//import the clock and reset UVC package
import clock_and_reset_pkg::*;

//import the router module package
import router_module_pkg::*;

//include the multichannel sequencer
`include "router_mcsequencer.sv"

//include the multichannel sequencer sequences
`include "router_mcseqs_lib.sv"

//include the router scoreboard
//`include "router_scoreboard.sv"

`include "router_tb.sv"
`include "router_test_lib.sv"

// generate 5 random packets and use the print method
// to display the results
initial begin

yapp_vif_config::set(null,"*.tb.yapp.agent.*","vif",hw_top.in0);

hbus_vif_config::set(null, "*.tb.hbus.*", "vif", hw_top.hif);
channel_vif_config::set(null, "*.tb.channel0.*", "vif", hw_top.ch0);
channel_vif_config::set(null, "*.tb.channel1.*", "vif", hw_top.ch1);
channel_vif_config::set(null, "*.tb.channel2.*", "vif", hw_top.ch2);

clock_and_reset_vif_config::set(null, "*.tb.clock_and_reset.*", "vif", hw_top.clk_rst_if);

run_test();

end

// experiment with the copy, clone and compare UVM method
endmodule : tb_top
