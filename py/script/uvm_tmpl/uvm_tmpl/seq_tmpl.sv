//==========================================================
//File  :${uvc+'_'}seq.sv
//Author:${usr_name}
//Date  :${today}
//==========================================================
`ifndef ${uvc.upper()+'_'}SEQ_SV
`define ${uvc.upper()+'_'}SEQ_SV
%if is_for_ral_agnt:
class csr_base_seq extends base_seq;
  `uvm_object_utils(csr_base_seq)
  function new(string name = "csr_base_seq");
    super.new(name);
  endfunction
  virtual task body();
    ral_${mod}_pkg::ral_block_${mod} regmodel;
    uvm_status_e  status;
    uvm_reg_data_t exp_data,act_data;
    uvm_reg regs[$];
    super.body();
    if (!uvm_config_db#(ral_${mod}_pkg::ral_block_${mod})::get(null, "", "regmodel", regmodel)) begin
      `uvm_fatal(get_full_name(), "regmodel for csr_base_seq is not set!")
    end
    #100ns;
    regmodel.get_registers(regs);
    `uvm_info(get_full_name(), $sformatf("Total Regs Num:%0d", regs.size()), UVM_MEDIUM)
    foreach(regs[i]) begin
      std::randomize(exp_data);
      regs[i].write(status, exp_data, UVM_FRONTDOOR);
      regs[i].read(status, act_data, UVM_FRONTDOOR);
    end
  endtask
endclass
%else:
class ${uvc+'_'}seq extends base_seq#(${uvc+'_'}item);
  `uvm_object_utils(${uvc+'_'}seq)
  function new(string name = "${uvc+'_'}seq");
    super.new(name);
  endfunction : new
  virtual task body();
    super.body();
    // Add your code below

    //
  endtask
endclass:${uvc+'_'}seq
%endif
`endif
