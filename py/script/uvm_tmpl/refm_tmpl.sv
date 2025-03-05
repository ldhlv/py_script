//==========================================================
//File  :${mod+'_'}refm.sv
//Author:${usr_name}
//Date  :${today}
//==========================================================
`ifndef ${mod.upper()+'_'}REFM_SV
`define ${mod.upper()+'_'}REFM_SV
`uvm_analysis_imp_decl(_get)
class ${mod+"_"}refm #(type IT=${in_item[0]}/*TODO,maybe other_item_type*/, type OT=${out_item[0]}/*TODO,maybe other_item_type*/) extends uvm_component;
  typedef ${mod+"_"}refm#(IT, OT) this_type;
  uvm_analysis_imp_get#(IT, this_type) i_port;
  uvm_analysis_port#(OT)               o_port;
  IT i_q[$];

  `uvm_component_param_utils(${mod+'_'}refm#(IT, OT))

  extern function new(string name, uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
//  extern function write_get(IT item );
  function write_get(IT item );
    OT out_item;
    `uvm_info(get_type_name(), $sformatf("reference model get item:%s", item.item_print()), UVM_LOW)
    ////////////////////////process in_item/////////////////////////////////////////////////
    out_item = OT::type_id::create("out_item");   
  
    ////////////////////////create out_item as expected///////////////////////////////////
    o_port.write(out_item);
  endfunction

endclass

function ${mod+'_'}refm::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void ${mod+'_'}refm::build_phase(uvm_phase phase);
  super.build_phase(phase);
  i_port = new("i_port", this);
  o_port = new("o_port", this);
endfunction

 `endif
