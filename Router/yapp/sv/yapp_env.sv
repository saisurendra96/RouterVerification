class yapp_env extends uvm_env;

    yapp_tx_agent agent;

    `uvm_component_utils(yapp_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //agent = new("agent",this);
        agent = yapp_tx_agent::type_id::create("agent",this);
    endfunction : build_phase

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(),{"start of simulation for ", get_full_name()},UVM_HIGH)
    endfunction : start_of_simulation_phase

endclass : yapp_env