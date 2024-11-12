class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    router_tb tb;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
         //                        "default_sequence",
         //                        yapp_5_packets::get_type());

        uvm_config_int::set(this,"*", "recording_detail",1);

        //tb = new("tb", this);
        tb = router_tb::type_id::create("tb", this);
        `uvm_info("router_test_lib","Executing build phase", UVM_HIGH)
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

    function void check_phase(uvm_phase phase);
        check_config_usage();
    endfunction : check_phase

    task run_phase(uvm_phase phase);
        uvm_objection obj = phase.get_objection();
        obj.set_drain_time(this, 200ns);
    endtask : run_phase

endclass : base_test

//test2 class

/*class test2 extends base_test;

    `uvm_component_utils(test2)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

endclass : test2

//short packet test class

class short_packet_test extends base_test;

    `uvm_component_utils(short_packet_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        //set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
        super.build_phase(phase);
        yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
         uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                                 "default_sequence",
                                 yapp_5_packets::get_type());

        
    endfunction : build_phase

endclass


//set config test

class set_config_test extends base_test;

    `uvm_component_utils(set_config_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_int::set(this,"tb.yapp.agent","is_active", UVM_PASSIVE);
        //uvm_config_int::set(this,"*agent*","is_active", UVM_PASSIVE);
    endfunction : build_phase

endclass : set_config_test

//incr_payload_test

class incr_payload_test extends base_test;

    `uvm_component_utils(incr_payload_test)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
        uvm_config_wrapper::set(this,"tb.yapp.agent.sequencer.run_phase","default_sequence",yapp_incr_payload_seq::get_type());
    endfunction : build_phase

endclass : incr_payload_test


//exhaustive sequence test

class exhaustive_seq_test extends base_test;

    `uvm_component_utils(exhaustive_seq_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        //super.build_phase(phase);
        yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
        uvm_config_wrapper::set(this,"tb.yapp.agent.sequencer.run_phase","default_sequence",yapp_exhaustive_seq::get_type());
        super.build_phase(phase);
    endfunction : build_phase

endclass : exhaustive_seq_test

class short_yapp_012 extends base_test;

    `uvm_component_utils(short_yapp_012)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
        uvm_config_wrapper::set(this,"tb.yapp.agent.sequencer.run_phase", "default_sequence", yapp_012_seq::get_type());
    endfunction : build_phase

endclass : short_yapp_012*/

//Simple test

class simple_test extends base_test;

    `uvm_component_utils(simple_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
        uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase", "default_sequence", yapp_012_seq::type_id::get());
        uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase", "default_sequence", clk10_rst5_seq::type_id::get());
        uvm_config_wrapper::set(this, "tb.channel?.rx_agent.sequencer.run_phase", "default_sequence", channel_rx_resp_seq::type_id::get());
    endfunction : build_phase

endclass : simple_test

//test uvc integration

class test_uvc_integration extends base_test;

    `uvm_component_utils(test_uvc_integration)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
        uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase", "default_sequence", clk10_rst5_seq::type_id::get());
        uvm_config_wrapper::set(this, "tb.hbus.masters[0].sequencer.run_phase", "default_sequence", hbus_small_packet_seq::type_id::get());
        uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase", "default_sequence", test_uvc_seq::type_id::get());
        uvm_config_wrapper::set(this, "tb.channel?.rx_agent.sequencer.run_phase", "default_sequence", channel_rx_resp_seq::type_id::get());
    endfunction : build_phase

endclass : test_uvc_integration

//test mc integration

class test_mc extends base_test;

    `uvm_component_utils(test_mc)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        
        yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
        uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase", "default_sequence", clk10_rst5_seq::type_id::get());
        uvm_config_wrapper::set(this, "tb.channel?.rx_agent.sequencer.run_phase", "default_sequence", channel_rx_resp_seq::type_id::get());
        uvm_config_wrapper::set(this,"tb.mcsequencer.run_phase", "default_sequence", router_simple_mcseq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

endclass : test_mc