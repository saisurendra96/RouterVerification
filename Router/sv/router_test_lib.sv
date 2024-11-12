class base_test extends uvm_env;

    `uvm_component_utils(base_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("router_test_lib","Executing build phase", UVM_HIGH)
    endfunction : build_phase

    function void end_of_eleboration_phase(uvm_phase phase);
        //super.end_of_eleboration_phase(phase);
        uvm_top.print_topology();
    endfunction : end_of_eleboration_phase

endclass