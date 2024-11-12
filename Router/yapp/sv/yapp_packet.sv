/*-----------------------------------------------------------------
File name     : yapp_packet.sv
Description   : lab01_data YAPP UVC packet template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

// Define your enumerated type(s) here
typedef enum {GOOD_PARITY, BAD_PARITY} parity_type_e;

class yapp_packet extends uvm_sequence_item;

// Follow the lab instructions to create the packet.
// Place the packet declarations in the following order:

  // Define protocol data
  rand bit [1:0] addr;
  rand bit [5:0] length;
  rand bit [7:0] payload[];
  bit [7:0] parity;

  // Define control knobs
  rand parity_type_e parity_type;
  rand int packet_delay;

  // Enable automation of the packet's fields
  `uvm_object_utils_begin(yapp_packet)
    `uvm_field_int(length, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_array_int(payload, UVM_ALL_ON)
    `uvm_field_int(parity, UVM_ALL_ON)
    `uvm_field_enum(parity_type_e, parity_type, UVM_ALL_ON)
    `uvm_field_int(packet_delay, UVM_ALL_ON)

  `uvm_object_utils_end

  // Define packet constraints

  constraint address {addr!=3;}
  constraint lengthc {length>0; length<64;}
  constraint payloadc {length == payload.size();}
  constraint parity_typec {parity_type dist{GOOD_PARITY:=5, BAD_PARITY:=2};}
  constraint packet_delayc {packet_delay>=0;packet_delay<=20;}


  // Add methods for parity calculation and class construction
  function new(string name="yapp_packet");
    super.new(name);
  endfunction : new

  function bit [7:0] calc_parity();
    calc_parity = {length,addr};
    for(int i=0; i<length; i++)
      calc_parity = calc_parity ^ payload[i];
  endfunction : calc_parity

  function void set_parity();
    parity = calc_parity();

    if(parity_type == BAD_PARITY)
      parity = parity++;
  endfunction : set_parity

  function void post_randomize();
    set_parity();
  endfunction : post_randomize

endclass: yapp_packet

//short packet class

class short_yapp_packet extends yapp_packet;

  `uvm_object_utils(short_yapp_packet)

  constraint short_packet_length {length < 15;}

  //constraint address_exclude_2 {addr != 2;}

  function new(string name = "short_yapp_packet");

    super.new(name);

  endfunction : new

endclass : short_yapp_packet
