`ifndef ${uvc.upper()+'_'}_PKG_SV
`define ${uvc.upper()+'_'}_PKG_SV
package ${uvc+'_'}pkg;
  import uvm_pkg::*;
  import base_pkg::*;
  import ${uvc+'_'}param::*;

  `include "${uvc+'_'}item.sv"
  `include "${uvc+'_'}drvr.sv"
  `include "${uvc+'_'}monr.sv"
  %if ral_agnt is not None and is_for_ral_agnt:
  `include "${uvc+'_'}adpt.sv"
  %endif
  `include "${uvc+'_'}agnt.sv"
  `include "${uvc+'_'}seq.sv"
endpackage:${uvc+'_'}pkg
`endif
