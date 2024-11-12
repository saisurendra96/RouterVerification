class router_simple_mcseq extends uvm_sequence;

    `uvm_object_utils(router_simple_mcseq)

    `uvm_declare_p_sequencer(router_mcsequencer)

    //YAPP Sequences
    six_yapp_seq yapp_six;
    yapp_012_seq yapp_012;

    //HBUS Sequences
    hbus_small_packet_seq hbus_small_pkt;
    hbus_read_max_pkt_seq hbus_rd_maxpkt;
    hbus_set_default_regs_seq hbus_large_pkt;

    function new(string name = "router_simple_mcseq");
        super.new(name);
    endfunction : new

    task pre_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
            //get starting phase from method
            phase = get_starting_phase();
        `else
            phase = starting_phase;
        `endif
        if(phase != null) begin
            phase.raise_objection(this, get_type_name());
            `uvm_info(get_type_name(),"raise objection", UVM_MEDIUM)
        end
    endtask : pre_body

    task post_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
            //get starting phase from method
            phase = get_starting_phase();
        `else
            phase = starting_phase;
        `endif
        if(phase != null) begin
            phase.drop_objection(this, get_type_name());
            `uvm_info(get_type_name(),"drop objection", UVM_MEDIUM)
        end
    endtask : post_body

    virtual task body();
        `uvm_info("router_simple_mcseq", "Executing router_simple_mcseq", UVM_LOW)
        //configure small packets
        `uvm_do_on(hbus_small_pkt, p_sequencer.hbus_seqr)
        //Read the YAPP MAXPKTSIZE Register
        `uvm_do_on(hbus_rd_maxpkt, p_sequencer.hbus_seqr)
        //sequence stores read value in property max_pkt_reg
        `uvm_info(get_type_name(), $sformatf("router MAXPKTSIZE register read: %0h", hbus_rd_maxpkt.max_pkt_reg), UVM_LOW)
        //send 6 consecutive packets to addresses to 0,1,2 cycling the address
        `uvm_do_on(yapp_012, p_sequencer.yapp_seqr)
        `uvm_do_on(yapp_012, p_sequencer.yapp_seqr)
        //configure for large packets (drfault)
        `uvm_do_on(hbus_large_pkt, p_sequencer.hbus_seqr)
        //Read the YAPP MAXPKTSIZE register (address 0)
        `uvm_do_on(hbus_rd_maxpkt, p_sequencer.hbus_seqr)
        //sequence stores read values in property max_pkt_reg
        `uvm_info(get_type_name(), $sformatf("Router MAXPKTSIZE register read: %0h", hbus_rd_maxpkt.max_pkt_reg), UVM_LOW)
        // send 6 random packets
        `uvm_do_on(yapp_six, p_sequencer.yapp_seqr)
    endtask : body

endclass : router_simple_mcseq