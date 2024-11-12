/*-----------------------------------------------------------------
File name     : yapp_tx_seqs.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : YAPP UVC simple TX test sequence for labs 2 to 4
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// SEQUENCE: base yapp sequence - base sequence with objections from which 
// all sequences can be derived
//
//------------------------------------------------------------------------------
class yapp_base_seq extends uvm_sequence #(yapp_packet);
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_base_seq)

  // Constructor
  function new(string name="yapp_base_seq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : yapp_base_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_5_packets
//
//  Configuration setting for this sequence
//    - update <path> to be hierarchial path to sequencer 
//
//  uvm_config_wrapper::set(this, "<path>.run_phase",
//                                 "default_sequence",
//                                 yapp_5_packets::get_type());
//
//------------------------------------------------------------------------------
class yapp_5_packets extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_5_packets)

  // Constructor
  function new(string name="yapp_5_packets");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_5_packets sequence", UVM_LOW)
     repeat(5)
      `uvm_do(req)
  endtask
  
endclass : yapp_5_packets

//single packet to address 1 class
class yapp_1_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_1_seq)

  function new(string name = "yapp_1_seq");
    super.new(name);
  endfunction : new

  virtual task body();
    `uvm_info(get_type_name(),"Sequence yapp_1_seq", UVM_HIGH)
    `uvm_do_with(req,{req.addr == 1;})
  endtask : body

endclass : yapp_1_seq

//three packets with incrementing address class 

class yapp_012_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_012_seq)

  function new(string name = "yapp_012_seq");
    super.new(name);
  endfunction : new

  virtual task body();
    `uvm_info(get_type_name(),"Sequence yapp_012_seq", UVM_HIGH)
    `uvm_do_with(req,{req.addr==0;})
    `uvm_do_with(req,{req.addr==1;})
    `uvm_do_with(req,{req.addr==2;})
  endtask : body

endclass : yapp_012_seq

//three packets to address 1

class yapp_111_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_111_seq)

  yapp_1_seq y1s;

  function new(name = "yapp_111_seq");
    super.new(name);
  endfunction : new

  virtual task body();
    `uvm_info(get_type_name,"Sequence yapp_111_seq", UVM_HIGH)
    repeat(3)
      `uvm_do(y1s)
  endtask : body

endclass : yapp_111_seq

//repeating address sequence class

class yapp_repeat_addr_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_repeat_addr_seq)

  rand bit [1:0] seqaddr;

  constraint seqaddr_not_3 {seqaddr!=3;}

  function new(string name = "yapp_repeat_addr_seq");
    super.new(name);
  endfunction : new

  virtual task body();
    `uvm_info(get_type_name(),"Sequence yapp_repeat_addr_seq", UVM_HIGH)
    repeat(2)
      `uvm_do_with(req, {req.addr == seqaddr;})

  endtask : body

endclass : yapp_repeat_addr_seq


//single packet with incrementing payload data class

class yapp_incr_payload_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_incr_payload_seq)

  function new(string name = "yapp_incr_payload_seq");
    super.new(name);
  endfunction : new

  virtual task body();
    `uvm_info(get_type_name(),"Sequence yapp_incr_payload_seq", UVM_HIGH)
    `uvm_create(req)
    assert(req.randomize());
    foreach(req.payload[i])
      req.payload[i] = i;
    req.set_parity();
    `uvm_send(req);
  endtask : body

endclass : yapp_incr_payload_seq

//random number of packets class

class yapp_rnd_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_rnd_seq)

  rand int count;

  constraint count_rnd {count inside {[1:10]};}

  function new(string name="yapp_rnd_seq");
    super.new(name);
  endfunction : new

  virtual task body();
    `uvm_info(get_type_name(), "Sequence yapp_rnd_seq", UVM_HIGH)
    repeat(count)
      `uvm_do(req)
  endtask : body



endclass : yapp_rnd_seq

// random and count with constrained to 6 class

class six_yapp_seq extends yapp_base_seq;

  `uvm_object_utils(six_yapp_seq)

  yapp_rnd_seq yrnd;

  function new(string name="six_yapp_seq");
    super.new(name);
  endfunction : new

  virtual task body();
    `uvm_info(get_type_name(),"Sequence six_yapp_seq", UVM_HIGH)
    `uvm_do_with(yrnd,{yrnd.count == 6;})
  endtask : body

endclass : six_yapp_seq

//all sequences to test class

class yapp_exhaustive_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_exhaustive_seq)

  yapp_1_seq y1;
  yapp_012_seq y012;
  yapp_111_seq y111;
  yapp_repeat_addr_seq yra;
  yapp_incr_payload_seq yincr;
  yapp_rnd_seq yrn;
  six_yapp_seq y6;


  function new(string name = "yapp_exhaustive_seq");
    super.new(name);
  endfunction : new

  virtual task body();
    `uvm_info(get_type_name(),"Sequence yapp_exhaustive_seq", UVM_HIGH)
    `uvm_do(y1);
    `uvm_do(y012);
    `uvm_do(y111);
    `uvm_do(yra);
    `uvm_do(yincr);
    `uvm_do(yrn);
    `uvm_do(y6);
  endtask : body

endclass : yapp_exhaustive_seq

//send packets to all 4 channels with incrementing payload

class test_uvc_seq extends yapp_base_seq;

  `uvm_object_utils(test_uvc_seq)

  function new(string name = "test_uvc_seq");
    super.new(name);
  endfunction : new

  virtual task body();

    `uvm_info(get_type_name(), "Executing TEST_UVC_SEQ", UVM_LOW)
    `uvm_create(req);
    req.packet_delay = 1;
    for(int ad=0; ad<4; ad++) begin
      req.addr = ad;
      for(int lgt=1;lgt<23; lgt++) begin
        req.length = lgt;
        req.payload = new[lgt];
        for(int pld=0; pld<lgt; pld++) begin
          req.payload[pld] = pld;
          randcase
            20: req.parity_type = BAD_PARITY;
            80: req.parity_type = GOOD_PARITY;
          endcase
          req.set_parity();
          `uvm_send(req);
        end
      end
    end

  endtask : body

endclass : test_uvc_seq