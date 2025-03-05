//==========================================================
//File  :${uvc+'_'}item.sv
//Author:${usr_name}
//Date  :${today}
//==========================================================
`ifndef ${uvc.upper()+'_'}ITEM_SV
`define ${uvc.upper()+'_'}ITEM_SV
class ${uvc+'_'}item #(parameter ADDR_W=32, parameter DATA_W=64) extends uvm_sequence_item;
  %if ral_agnt is not None and is_for_ral_agnt:
  rand uvm_access_e kind;
  rand uvm_status_e status;
  rand bit burst_access;
  rand int idle;
  rand bit [ADDR_W-1:0] addr;
  rand bit [DATA_W-1:0] data;
  constraint default_c {
    soft burst_access;
    burst_access -> idle == 1;
    ~burst_access-> idle inside {[5:100]};
  }
  %endif
  
  `uvm_object_param_utils_begin(${uvc+'_'}item#(ADDR_W,DATA_W))
  %if ral_agnt is not None and is_for_ral_agnt:
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(burst_access, UVM_ALL_ON)
    `uvm_field_int(idle, UVM_ALL_ON)
    `uvm_field_enum(uvm_access_e, kind, UVM_ALL_ON)
    `uvm_field_enum(uvm_status_e, status, UVM_ALL_ON)
  %endif
  `uvm_object_utils_end

  function new(string name = "${uvc+'_'}item");
    super.new(name);
  endfunction:new

  function bit item_compare(${uvc+'_'}item compare_item);
    bit result = 1; 
    /////TODO
    return result;
  endfunction:item_compare

  function string item_print();
     item_print = $sformatf("XXXXX_in_item:\n");
//     item_print = {item_print, $sformatf("this.mode is %0h",this.mode), "\n"};
  endfunction:item_print

endclass:${uvc+'_'}item
`endif
