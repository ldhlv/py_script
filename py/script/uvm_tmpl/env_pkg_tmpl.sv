`ifndef ${mod.upper()+'_'}PKG_SV
`define ${mod.upper()+'_'}PKG_SV

package ${mod+'_'}env_pkg;
  import uvm_pkg::*;
%for agnt in uvcs:
  import ${agnt+'_'}pkg::*;
%endfor
%for uvc in uvc_arrays.keys():
  import ${uvc+'_'}pkg::*;
%endfor
%if ral_agnt is not None:
  import csr_pkg::*;
%endif
%for env in envs:
  import ${env+'_'}env_pkg::*;
%endfor
%for env in env_arrays.keys():
  import ${env+'_'}env_pkg::*;
%endfor
%if regmodel is not None:
  import ral_${mod+'_'}pkg::*;
%endif
  // Add your components below:
  //
%if refm is not None:
  `include "${mod+'_'}scb.sv"
%endif
%if scb is not None:
  `include "${mod+'_'}refm.sv"
%endif
  `include "${mod+'_'}env.sv"
endpackage
`endif 
