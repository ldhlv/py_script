//==========================================================
//File  :${uvc+'_'}agnt.sv
//Author:${usr_name}
//Date  :${today}
//==========================================================
`ifndef ${uvc.upper()+'_'}AGNT_SV
 `define ${uvc.upper()+'_'}AGNT_SV

class ${uvc+'_'}agnt_cfg extends agnt_cfg#(${uvc+'_'}drvr_cfg,${uvc+'_'}monr_cfg);
  `uvm_object_utils_begin(${uvc+'_'}agnt_cfg)
    // Add code if needed
  `uvm_object_utils_end

  function new(string name = "${uvc+'_'}agnt_cfg");
    super.new(name);
  endfunction:new
endclass:${uvc+'_'}agnt_cfg

%if ral_agnt is not None and is_for_ral_agnt:
typedef uvm_reg_predictor#(${uvc+'_'}item) ${uvc+'_'}pdct;
%endif
%if ral_agnt is not None and is_for_ral_agnt:
class ${uvc+'_'}agnt extends agnt#(.BUS(virtual ral_${mod+'_'}bus),.CFG(${uvc+'_'}agnt_cfg),.ITEM(${uvc+'_'}item),.DRVR(${uvc+'_'}drvr), .MONR(${uvc+'_'}monr));
%else:
class ${uvc+'_'}agnt extends agnt#(.BUS(virtual ${uvc+'_'}io),.CFG(${uvc+'_'}agnt_cfg),.ITEM(${uvc+'_'}item),.DRVR(${uvc+'_'}drvr), .MONR(${uvc+'_'}monr));
%endif
  %if ral_agnt is not None and is_for_ral_agnt:
  ${uvc+'_'}adpt#(.REQ(ITEM)) adpt;
  ${uvc+'_'}pdct pdct;
  %endif
  `uvm_component_utils(${uvc+'_'}agnt)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction:new

  %if ral_agnt is not None and is_for_ral_agnt:
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (this.is_active) begin
      adpt = ${uvc+'_'}adpt#(ITEM)::type_id::create("adpt", this);
      pdct = ${uvc+'_'}pdct::type_id::create("pdct", this);
    end
  endfunction // build_phase
  %endif

  %if ral_agnt is not None and is_for_ral_agnt:
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    this.analysis_port.connect(this.pdct.bus_in);
    this.pdct.adapter = this.adpt;
  endfunction // connect_phase
  %endif
  
  // Add Your Code if Needed
  //
  //
  //
endclass:${uvc+'_'}agnt
`endif
