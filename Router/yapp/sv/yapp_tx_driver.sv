class yapp_tx_driver extends uvm_driver #(yapp_packet);

    virtual interface yapp_if vif;

    int num_sent;

    `uvm_component_utils_begin(yapp_tx_driver)
        `uvm_field_int(num_sent,UVM_ALL_ON)
    `uvm_component_utils_end
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //UVM connect_phase

    function void connect_phase(uvm_phase phase);
        if(!yapp_vif_config::get(this, "","vif", vif))
            `uvm_error("NOVIF", {"Virtual interface must be set for: ",get_full_name(), ".vif"})
    endfunction : connect_phase

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
    endfunction : start_of_simulation_phase

    task run_phase(uvm_phase phase);
        forever begin
            //seq_item_port.get_next_item(req);
            //send_to_dut(req);
            //seq_item_port.item_done();
            get_and_drive();
            reset_signals();

        end
    endtask : run_phase

    //task send_to_dut(yapp_packet pkt);
     //   `uvm_info(get_type_name(), $sformatf("packet is \n%s",pkt.sprint()), UVM_LOW)
      //  #10ns;
    //endtask : send_to_dut

    //Get Packets from sequencer and passes them to the driver
    task get_and_drive();
        @(posedge vif.reset);
        @(negedge vif.reset);
        `uvm_info(get_type_name(), "Reset dropped", UVM_MEDIUM)
        forever begin
            //Get new item from the sequencer
            seq_item_port.get_next_item(req);

            `uvm_info(get_type_name(), $sformatf("Sending Packet :\n%s", req.sprint()),UVM_HIGH)

            //concurrent blocks for packet driving and transaction recording
            fork
                //send packet
                begin
                    // for acceleration efficiency, write unsynthesizable dynamic payload array directly into
                    //interface static payload array
                    foreach(req.payload[i])
                        vif.payload_mem[i] = req.payload[i];
                    //send rest of YAPP packet via individual arguments
                    vif.send_to_dut(req.length, req.addr, req.parity, req.packet_delay);
                end
                //trigger transaction at start of packet (trigger signal from interface)
                @(posedge vif.drvstart) void'(begin_tr(req, "Driver_YAPP_Packet"));
            join

            //End transaction recording
            end_tr(req);
            num_sent++;
            //Communicate item done to the sequencer
            seq_item_port.item_done();
        end
    endtask : get_and_drive

    //UVM report_phase
    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Report: YAPP Driver sent %0d Pacekts", num_sent), UVM_LOW)
    endfunction : report_phase

    //Reset all TX signals
    task reset_signals();
        forever
            vif.yapp_reset();
    endtask : reset_signals


endclass : yapp_tx_driver