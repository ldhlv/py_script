//==========================================================
//FileName:${uvc+'_'}drvr.sv
//Author  :${usr_name}
//Date    :${today}
//==========================================================
`ifndef ${uvc.upper()+'_'}DRVR_SV
`define ${uvc.upper()+'_'}DRVR_SV
class ${uvc+'_'}drvr_cfg extends drvr_cfg;
  // Add your code below if needed
  //  
  `uvm_object_utils_begin(${uvc+'_'}drvr_cfg)
  
  `uvm_object_utils_end

  function new(string name = "${uvc+'_'}drvr_cfg");
    super.new(name);
  endfunction:new
endclass:${uvc+'_'}drvr_cfg
%if ral_agnt is not None and is_for_ral_agnt:
class ${uvc+'_'}drvr extends drvr#(.BUS(virtual ral_${mod+'_'}bus), .CFG(${uvc+'_'}drvr_cfg), .REQ(${uvc+'_'}item));
%else:
class ${uvc+'_'}drvr extends drvr#(.BUS(virtual ${uvc+'_'}io), .CFG(${uvc+'_'}drvr_cfg), .REQ(${uvc+'_'}item));
%endif
  `uvm_component_utils(${uvc+'_'}drvr)
  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH)
  endfunction:new

  extern virtual task run_phase(uvm_phase phase);
endclass:${uvc+'_'}drvr

task ${uvc+'_'}drvr::run_phase(uvm_phase phase);

  @(bus.drv);                     //////initial bus value
//  bus.drv.xxxx <= '0;
//  bus.drv.xxxx <= '0;
//  bus.drv.xxxx <= '0;

  @(posedge bus.drv.rst);
  `uvm_info(get_type_name(), $sformatf("%m"), UVM_LOW)
  repeat(2)@(bus.drv);

  fork
    begin:get_item
      forever begin
        seq_item_port.get_next_item(req);
        // uncomment the code below, or overwrite it according to your requirement
        ///////////////////////////////////

        ////////////////////////////////// 
        seq_item_port.item_done();
      end
    end
  join

endtask:run_phase

`endif
