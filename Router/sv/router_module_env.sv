class router_module_env extends uvm_env;

    //Reference model connectors
    uvm_analysis_export #(hbus_transaction) hbus_in;
    uvm_analysis_export #(yapp_packet) yapp_in;

    //Scoreboard connectors
    uvm_analysis_export #(channel_packet) sb_chan0;
    uvm_analysis_export #(channel_packet) sb_chan1;
    uvm_analysis_export #(channel_packet) sb_chan2;

    //Router Reference
    router_reference reference;

    //Router Scoreboard
    router_scoreboard scoreboard;

    `uvm_component_utils(router_module_env)

    function new(string name, uvm_component parent=null);
        super.new(name, parent);
        hbus_in = new("hbus_in", this);
        yapp_in = new("yapp_in", this);
        sb_chan0 = new("sb_chan0", this);
        sb_chan1 = new("sb_chan1", this);
        sb_chan2 = new("sb_chan2", this);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        scoreboard = router_scoreboard::type_id::create("scoreboard", this);
        reference = router_reference::type_id::create("refernce", this);
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        hbus_in.connect(reference.hbus_in);
        yapp_in.connect(reference.yapp_in);
        sb_chan0.connect(scoreboard.sb_chan0);
        sb_chan1.connect(scoreboard.sb_chan1);
        sb_chan2.connect(scoreboard.sb_chan2);
        reference.sb_add_out.connect(scoreboard.sb_yapp_in);
    endfunction : connect_phase

endclass : router_module_env