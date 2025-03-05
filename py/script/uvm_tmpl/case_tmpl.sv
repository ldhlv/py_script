//==========================================================
//File  :${mod+'_'}base.sv
//Author:${usr_name}
//Date  :${today}
//==========================================================
`ifndef ${mod.upper()+'_'}SANITY_SV
`define ${mod.upper()+'_'}SANITY_SV
class ${mod+'_'}base_seq extends base_seq#(${in_item[0]}/*TODO*/);
  `uvm_object_utils(${mod+'_'}base_seq)
  function new(string name = "${mod+'_'}base_seq");
    super.new(name);
    `uvm_info("TRACE",$sformatf("%m"), UVM_HIGH);
  endfunction:new

  virtual task body();
  ////////////////////////////////////////////////////
  `uvm_do_with(req,{/*TODO*/});
  ////////////////////////////////////////////////////
  endtask:body
endclass:${mod+'_'}base_seq


class ${mod+'_'}base extends base_case;
  ${mod+'_'}env_cfg cfg;
  ${mod+'_'}env    env;

  `uvm_component_utils(${mod+'_'}base)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction:new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg = ${mod+'_'}env_cfg::type_id::create("cfg");
    env = ${mod+'_'}env::type_id::create("env", this);

    if (!this.cfg.randomize()) `uvm_fatal(get_name(), "${mod+'_'}base_cfg randomize failed!");
    uvm_config_db#(${mod+'_'}env_cfg)::set(this, "env", "cfg", this.cfg);
    uvm_config_db#(bit)::set(null, "*", "enable_print_topology", 0);

    uvm_config_db#(uvm_object_wrapper)::set(this,"env.${uvcs[0]}.seqr.main_phase","default_sequence",${mod+'_'}base_seq::type_id::get()); //TODO
    %for uvc in uvcs:
    //uvm_config_db#(uvm_object_wrapper)::set(this,"env.${uvc}.seqr.main_phase","default_sequence", ${uvc+'_'}pkg::${uvc+'_'}seq::type_id::get());
    %endfor
    %for uvc in uvc_arrays.keys():
    //uvm_config_db#(uvm_object_wrapper)::set(this,"env.${uvc}.seqr.main_phase","default_sequence", ${uvc+'_'}pkg::${uvc+'_'}seq::type_id::get());
    %endfor
    //set_type_override_by_type(${mod+'_'}env_cfg::get_type(), ${mod+'_'}base_cfg::get_type());
  endfunction : build_phase

  virtual function void setting_crg();
    m_crg_cfg.CRT_CLK("clk0",0,500);   //TODO name:clk0, id:0  freq:500M.  clk name and id must unique
    m_crg_cfg.CRT_RST("rst0",0);       //TODO name:rst0, id:0.             rst name and id must unique
    //cfg one clk
    //set_clk_all(string clk_name,real freq,real duty,bit[1:0] start_vlu,real start_time,bit assert_vlu,bit jitter_en=0,int jitter_hit_prct=0,int jitter_vlu_prct=0)
    // start_vlu: 0/2'b00, 1/2'b01, x/2'b10, z/2'b11
    m_crg_cfg.set_clk_all("clk0", 500, 0.5, 2, 20, 1); //TODO
    
    //cfg one rst
    //set_rst_all(string rst_name,int start_vlu,real start_time,int assert_vlu,real assert_time);
    m_crg_cfg.set_rst_all("rst0", 3, 40, 0, 20); //TODO
  endfunction:setting_crg

  task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info(get_type_name(), $sformatf("%m, start!!"), UVM_LOW)
    #100ns;
    `uvm_info(get_type_name(), $sformatf("%m, running!!"), UVM_LOW)
    #100ns;
    `uvm_info(get_type_name(), $sformatf("%m, finish!!"), UVM_LOW)    
    phase.phase_done.set_drain_time(this,5us); // 5us is a example, modify it according to your requirement
    phase.drop_objection(this);
  endtask

endclass : ${mod+'_'}base
`endif
