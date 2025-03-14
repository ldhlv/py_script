//==========================================================
//File  :${uvc+'_'}monr.sv
//Author:${usr_name}
//Date  :${today}
//==========================================================
`ifndef ${uvc.upper()+'_'}MONR_SV
`define ${uvc.upper()+'_'}MONR_SV
class ${uvc+'_'}monr_cfg extends monr_cfg;
  `uvm_object_utils(${uvc+'_'}monr_cfg)

  function new(string name = "${uvc+'_'}monr_cfg");
    super.new(name);
  endfunction:new
endclass:${uvc+'_'}monr_cfg
%if ral_agnt is not None and is_for_ral_agnt:
class ${uvc+'_'}monr extends monr#(.BUS(virtual ral_${mod+'_'}bus), .CFG(${uvc+'_'}monr_cfg), .REQ(${uvc+'_'}item));
%else:
class ${uvc+'_'}monr extends monr#(.BUS(virtual ${uvc+'_'}io), .CFG(${uvc+'_'}monr_cfg), .REQ(${uvc+'_'}item));
%endif
  `uvm_component_utils(${uvc+'_'}monr)
  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH)
  endfunction:new

  extern virtual task run_phase(uvm_phase phase);
   
endclass:${uvc+'_'}monr

task ${uvc+'_'}monr::run_phase(uvm_phase phase);
    REQ  mon_item;
    @(bus.mon);
    @(posedge bus.mon.rst);
    `uvm_info(get_type_name(), $sformatf("%m"), UVM_LOW)
    fork
        while(1)begin
           @(bus.mon);
           //////////////////////////////////////////////////////////
           // Add your code below, mostly you need overwrite dynamic phases
           //mon_item = REQ::type_id::create("mon_item");
           

           //analysis_port.write(mon_item);
           ///////////////////////////////////////////////////////
        end
    join
  
endtask:run_phase

`endif
