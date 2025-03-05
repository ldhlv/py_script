//==========================================================
//File  :${mod+'_'}_case_package.sv
//Author:${usr_name}
//Date  :${today}
//==========================================================
`ifndef ${mod.upper()+'_'}CASE_PACKAGE_SV
`define ${mod.upper()+'_'}CASE_PACKAGE_SV
package ${mod+'_'}case_pkg;
  import uvm_pkg::*;
  import base_pkg::*;
%for agnt in uvcs:
  import ${agnt+'_'}pkg::*;
%endfor  
  import ${mod+'_'}env_pkg::*;
  
  `include "${mod+'_'}base.sv"
endpackage
`endif
