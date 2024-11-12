class router_tb extends uvm_env;

    `uvm_component_utils(router_tb)

    //yapp env handle

    yapp_env yapp;

    //channel env handles

    channel_env channel0;
    channel_env channel1;
    channel_env channel2;

    //hbus env handles

    hbus_env hbus;

    //clock and reset handles 

    clock_and_reset_env clock_and_reset;

    //Virtual sequencer

    router_mcsequencer mcsequencer;

    //router scoreboard
    //router_scoreboard router_sb;
    //router module UVC
    router_module_env router_mod;



    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("router_tb", "Executing build phase", UVM_HIGH)
        //yapp=new("yapp",this);
        yapp = yapp_env::type_id::create("yapp",this);

        //channel UVC with ids
        uvm_config_int::set(this, "channel0", "channel_id", 0);
        uvm_config_int::set(this, "channel1", "channel_id", 1);
        uvm_config_int::set(this, "channel2", "channel_id", 2);
        channel0 = channel_env::type_id::create("channel0", this);
        channel1 = channel_env::type_id::create("channel1", this);
        channel2 = channel_env::type_id::create("channel2", this);

        //hbus UVC - 1 Master and 0 Slave

        uvm_config_int::set(this, "hbus", "num_masters", 1);
        uvm_config_int::set(this, "hbus", "num_slaves", 0);
        hbus = hbus_env::type_id::create("hbus", this);

        //clock and reset instance

        clock_and_reset = clock_and_reset_env::type_id::create("clock_and_reset", this);

        //virtual sequencer

        mcsequencer = router_mcsequencer::type_id::create("mcsequencer", this);

        //router scoreboard
        //router_sb = router_scoreboard::type_id::create("router_sb", this);
        router_mod = router_module_env::type_id::create("router_mod", this);


    endfunction : build_phase

    //connect phase

    function void connect_phase(uvm_phase phase);
        //Virtual Sequencer connections
        mcsequencer.hbus_seqr = hbus.masters[0].sequencer;
        mcsequencer.yapp_seqr = yapp.agent.sequencer;

        //Connect the TLM ports to YAPP and Channel UVCs to the scoreboard
        yapp.agent.monitor.item_collected_port.connect(router_mod.yapp_in);
        hbus.masters[0].monitor.item_collected_port.connect(router_mod.hbus_in);
        channel0.rx_agent.monitor.item_collected_port.connect(router_mod.sb_chan0);
        channel1.rx_agent.monitor.item_collected_port.connect(router_mod.sb_chan1);
        channel2.rx_agent.monitor.item_collected_port.connect(router_mod.sb_chan2);

    endfunction : connect_phase

endclass : router_tb