class router_reference extends uvm_component;

    //TLM port declarations
    `uvm_analysis_imp_decl(_yapp)
    `uvm_analysis_imp_decl(_hbus)

    //TLM exports connected to interface UVC's
    uvm_analysis_imp_hbus #(hbus_transaction, router_reference) hbus_in;
    uvm_analysis_imp_yapp #(yapp_packet, router_reference) yapp_in;

    //TLM ports to connect to scoreboard
    uvm_analysis_port #(yapp_packet) sb_add_out;

    //Configuration information given in spec sheet
    bit [7:0] maxpktsize_reg = 8'h3f;
    bit [7:0] router_en_reg = 8'h01;

    //Monitor statistics
    int packet_dropped = 0;
    int packets_forwarded = 0;
    int jumbo_packets = 0;
    int bad_addr_packets = 0;

    `uvm_component_utils(router_reference)

    function new(string name = "", uvm_component parent = null);
        super.new(name,parent);
        //TLM connections to interface
        hbus_in = new("hbus_in", this);
        yapp_in = new("yapp_in", this);

        //TLM connections to scoreboard
        sb_add_out = new("sb_add_out", this);
    endfunction : new

    //HBUS transaction TLM write implementation
    function void write_hbus(hbus_transaction hbus_cmd);

        `uvm_info(get_type_name(), $sformatf("Received HBUS transaction: \n%s", hbus_cmd.sprint()), UVM_MEDIUM)

        //capture the maxpktsize_reg and router_en_reg whenever a hbus transaction is written
        if(hbus_cmd..hwr_rd == HBUS_WRITE)
            case(hbus_cmd.haddr)
                'hb1000: maxpktsize_reg = hbus_cmd.hdata;
                'hb1001: router_en_reg = hbus_cmd.hdata;
            endcase

    endfunction : write_hbus

    //YAPP transaction TLM write implementation
    function void write_yapp(yapp_packet pkt);
        `uvm_info(get_type_name(), $sformatf("Received input YAPP Packet: \n%s", pkt.sprint()), UVM_LOW)

        //check if router is enabled and    packet has valid size before sending to scoreboard
        if(pkt.addr == 3) begin
            bad_addr_packets++;
            packet_dropped++;
            `uvm_info(get_type_name(), "YAPP Packet Dropped [BAD ADDRESS]", UVM_LOW)
        end
        else if((router_en_reg !=0) && (pkt.length <= maxpktsize_reg)) begin
            sb_add_out.write(pkt);
            packets_forwarded++;
            `ucm_info(get_type_name(), "Sent YAPP packet to scoreboard", UVM_LOW)
        end
        else if((router_en_reg !=0) && (pkt.length > maxpktsize_reg)) begin
            jumbo_packets++;
            packet_dropped++;
            `uvm_info(get_type_name(), $sformatf("YAPP Packet Dropped [OVERSIZED] - pkt size %h max size %h", pkt.length, maxpktsize_reg), UVM_LOW)
        end
        else if(router_en_reg == 0) begin
            packet_dropped++;
            `uvm_info(get_type_name(), "YAPP Packet Dropped [DISABLED]", UVM_LOW )
        end
    endfunction : write_yapp    

    //uvm report_phase
    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Report: \n    Router Reference: Packet Statistics \n  Packets Dropped: %0d\n Packets Forwarded: %0d\n Oversized Packets: %0d\n", packet_dropped, packets_forwarded, jumbo_packets), UVM_LOW)
    endfunction : report_phase

endclass : router_reference