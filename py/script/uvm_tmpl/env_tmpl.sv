//==========================================================
//File  :${mod+'_'}env.sv
//Author:${usr_name}
//Date  :${today}
//==========================================================
`ifndef ${mod.upper()+'_'}ENV_SV
 `define ${mod.upper()+'_'}ENV_SV
class ${mod+'_'}env_cfg extends uvm_object;
  rand bit ${mod+'_'}en;
  %for agnt in uvcs:
  rand ${agnt+'_'}agnt_cfg ${agnt+'_'}cfg;
  %endfor
  %for agnt in uvc_arrays.keys():
  rand ${agnt+'_'}agnt_cfg ${agnt+'_'}cfg[${uvc_arrays[agnt]}];
  %endfor
  %if ral_agnt is not None:
  rand csr_agnt_cfg ${ral_agnt+'_'}cfg;
  %endif
  %if regmodel is not None:
  rand bit ral_en;
  rand ral_block_${mod} regmodel;
  %endif
  %for env in envs:
  rand ${env+'_'}env_cfg ${env+'_'}cfg;
  %endfor
  %for env in env_arrays.keys():
  rand ${env+'_'}env_cfg ${env+'_'}cfg[${env_arrays[env]}];
  %endfor
  rand bit refm_en;
  rand bit scb_en;
  `uvm_object_utils_begin(${mod+'_'}env_cfg)
    `uvm_field_int(${mod+'_'}en, UVM_ALL_ON)
    `uvm_field_int(scb_en, UVM_ALL_ON)
    `uvm_field_int(refm_en, UVM_ALL_ON)
  %for agnt in uvcs:
    `uvm_field_object(${agnt+'_'}cfg, UVM_ALL_ON)
  %endfor
  %for agnt in uvc_arrays.keys():
    `uvm_field_sarray_object(${agnt+'_'}cfg, UVM_ALL_ON)
  %endfor
  %if regmodel is not None:
    `uvm_field_int(ral_en, UVM_ALL_ON)
    `uvm_field_object(regmodel, UVM_ALL_ON)
  %endif
  %if ral_agnt != None and ral_agnt != "":
    `uvm_field_object(${ral_agnt+'_'}cfg, UVM_ALL_ON)
  %endif
  %for env in env_arrays.keys():
    `uvm_field_sarray_object(${env+'_'}cfg, UVM_ALL_ON)
  %endfor
  %for env in envs:
    `uvm_field_object(${env+'_'}cfg, UVM_ALL_ON)
  %endfor
  `uvm_object_utils_end

  constraint default_constraint {
    soft ${mod+'_'}en;
    soft refm_en == 1'b1;
    soft scb_en  == 1'b1;
  }
  function new(string name = "${mod+'_'}env_cfg");
    super.new(name);
  %for agnt in uvcs:
    ${agnt+'_'}cfg = ${agnt+'_'}agnt_cfg::type_id::create("${agnt+'_'}cfg");
  %endfor
  %for agnt in uvc_arrays.keys():
    foreach(${agnt+'_'}cfg[i]) ${agnt+'_'}cfg[i] = ${agnt+'_'}agnt_cfg::type_id::create($sformatf("${agnt+'_'}cfg%0d",i));
  %endfor
  %if ral_agnt is not None:
    ${ral_agnt+'_'}cfg = csr_agnt_cfg::type_id::create("${ral_agnt+'_'}cfg");
  %endif
  %for env in envs:
    ${env+'_'}cfg = ${env+'_'}env_cfg::type_id::create("${env+'_'}cfg");
  %endfor
  %for env in env_arrays.keys():
    foreach(${env+'_'}cfg[i]) ${env+'_'}cfg[i] = ${env+'_'}env_cfg::type_id::create($sformatf("${env+'_'}cfg%0d",i));
  %endfor

  %if regmodel is not None:
    this.regmodel = ral_block_${mod}::type_id::create("regmodel");
    this.regmodel.build();
  %endif
  endfunction:new
endclass:${mod+'_'}env_cfg

class ${mod+'_'}env extends uvm_env;
  ${mod+'_'}env_cfg cfg;
  %for agnt in uvcs:
  ${agnt+'_'}agnt ${agnt};
  %endfor
  %for uvc in uvc_arrays.keys():
  ${uvc+'_'}agnt ${uvc}[${uvc_arrays[uvc]}];
  %endfor
  %if ral_agnt is not None:
  ${ral_agnt+'_'}agnt ${ral_agnt};
  %endif
  %if regmodel is not  None:
  ral_block_${mod} regmodel;
  %endif
  %for env in envs:
  ${env+'_'}env ${env};
  %endfor
  %for env in env_arrays.keys():
  ${env+'_'}env ${env}[${env_arrays[env]}];
  %endfor
  // refm for ${mod}
  %if refm is not None:
  ${mod+'_'}refm/*#(TODO:)*/ refm;
  %endif
  %if scb is not None:
  // scoreboard for ${mod}
  ${mod+'_'}scb/*#(TODO:)*/ scb;
  %endif

  %for port in iports:
  uvm_tlm_analysis_fifo/*#(TODO)*/ ${port+'_'}fifo;
  %endfor
  %for port in oports:
  uvm_tlm_analysis_fifo/*#(TODO)*/ ${port+'_'}fifo;
  %endfor
  //tlm
  %for agnt in uvcs:
    %if "out" in agnt:
  uvm_tlm_analysis_fifo #(${agnt}_item) refm_scb_fifo;
  uvm_tlm_analysis_fifo #(${agnt}_item) mon_scb_fifo;
    %endif
  %endfor
//  uvm_tlm_analysis_fifo #(/****_item*/) refm_scb_fifo;
//  uvm_tlm_analysis_fifo #(/****_item*/) mon_scb_fifo;


  virtual ${mod+'_'}bus_wrapper bus;

  `uvm_component_utils(${mod+'_'}env)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction:new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH)
    if(!uvm_config_db#(virtual ${mod+'_'}bus_wrapper)::get(this, "", "bus", bus)) `uvm_fatal(get_full_name(), "bus_wrapper not set!")
    if(!uvm_config_db#(${mod+'_'}env_cfg)::get(this, "", "cfg", this.cfg)) `uvm_warning(get_full_name(), "env cfg not set!");
    if (this.cfg == null) begin
      `uvm_info(get_name(), "cfg is null, create a new one!",UVM_LOW);
      this.cfg = ${mod+'_'}env_cfg::type_id::create("cfg");
      if (!this.cfg.randomize()) `uvm_fatal(get_full_name(), "env_cfg randomize failed");
    end

    %for agnt in uvcs:
    ${agnt} = ${agnt+'_'}agnt::type_id::create("${agnt}", this);
    uvm_config_db#(virtual ${agnt+'_'}io)::set(this, "${agnt}", "bus", this.bus.${agnt+'_'}bus);
    uvm_config_db#(${agnt+'_'}agnt_cfg)::set(this, "${agnt}", "cfg", this.cfg.${agnt+'_'}cfg);
    %endfor

    %for agnt in uvc_arrays.keys():
    foreach(${agnt}[i]) begin
      ${agnt}[i] = ${agnt+'_'}agnt::type_id::create($sformatf("${agnt}%0d",i), this);
      uvm_config_db#(virtual ${agnt+'_'}io)::set(this, $sformatf("${agnt}%0d",i), "bus", this.bus.${agnt+'_'}bus[i]);
      uvm_config_db#(${agnt+'_'}agnt_cfg)::set(this, $sformatf("${agnt}%0d",i), "cfg", this.cfg.${agnt+'_'}cfg[i]);
    end
    %endfor

    %if ral_agnt is not None:
    ${ral_agnt} = csr_agnt::type_id::create("${ral_agnt}", this);
    uvm_config_db#(virtual ral_${mod}_bus)::set(this, "${ral_agnt}", "bus", this.bus.${ral_agnt+'_'}bus);
    uvm_config_db#(csr_agnt_cfg)::set(this, "${ral_agnt}", "cfg", this.cfg.${ral_agnt+'_'}cfg);
    %endif

    %for env in envs:
    ${env} = ${env+'_'}env::type_id::create("${env}",this);
    uvm_config_db#(${env+'_'}env)::type_id::create("${env}",this);
    uvm_config_db#(${env+'_'}env_cfg)::set(this, "${env}","cfg", this.cfg.${env+'_'}cfg);
    %endfor

    %for env in env_arrays.keys():
    foreach(${env}[i]) begin
      if (this.cfg.${env+'_'}cfg[i].${env+'_'}en) begin
        ${env}[i] = ${env+'_'}env::type_id::create($sformatf("${env}%0d",i), this);
        uvm_config_db#(${env+'_'}env_cfg::set(this, $sformatf("${env}%0d",i), "cfg", this.cfg.${env+'_'}cfg[i]);
      end
    end
    %endfor

    %if regmodel is not None:
    if (this.cfg.ral_en) begin
      this.regmodel = this.cfg.regmodel;
      uvm_config_db#(ral_block_${mod})::set(null, "", "regmodel", this.regmodel);
    end
    %endif

    %for port in iports:
    ${port+'_'}fifo = new("${port+'_'}fifo", this);
    %endfor
    %for port in oports:
    ${port+'_'}fifo = new("${port+'_'}fifo", this);
    %endfor

    %if refm is not None:
    if (cfg.refm_en) begin
      refm = ${mod+'_'}refm::type_id::create("refm", this);
    end
    %endif

    if (cfg.scb_en) begin
      scb = ${mod+'_'}scb::type_id::create("scb", this);
    end

    mon_scb_fifo   = new("mon_scb_fifo", this);
    refm_scb_fifo  = new("refm_scb_fifo", this);
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    %if ral_agnt is not None:
    if (this.cfg.ral_en) begin
      if (this.regmodel.get_parent() == null) begin
        this.regmodel.default_map.set_sequencer(.sequencer(this.${ral_agnt}.seqr),.adapter(this.${ral_agnt}.adpt));
        this.regmodel.default_map.set_auto_predict(.on(0));
        this.${ral_agnt}.pdct.map = this.regmodel.default_map;
      end
    end
    %endif

    // TODO: connection for ports

    %for agnt in uvcs:
      %if "in" in agnt:
    this.${agnt}.monr.analysis_port.connect(this.refm.i_port);
      %endif
    %endfor
    this.scb.actual_port.connect(mon_scb_fifo.blocking_get_export);
    %for agnt in uvcs:
      %if "out" in agnt:
    this.${agnt}.monr.analysis_port.connect(mon_scb_fifo.analysis_export);
      %endif
    %endfor
    this.scb.expect_port.connect(refm_scb_fifo.blocking_get_export);
    this.refm.o_port.connect(refm_scb_fifo.analysis_export);


  endfunction:connect_phase
endclass : ${mod+'_'}env
`endif

