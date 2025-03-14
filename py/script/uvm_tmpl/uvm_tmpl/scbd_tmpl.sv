//==========================================================
//File  :${mod+'_'}scb.sv
//Author:${usr_name}
//Date  :${today}
//==========================================================
`ifndef ${mod.upper()+'_'}SCB_SV
`define ${mod.upper()+'_'}SCB_SV

class ${mod+'_'}scb#(type ITEM=${out_item[0]}/*TODO,other_item_type*/) extends uvm_component;
  ITEM exp_queue[$];
  int unsigned act_cnt, exp_cnt;
  uvm_blocking_get_port #(ITEM) expect_port;
  uvm_blocking_get_port #(ITEM) actual_port;
  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern virtual task /*main*/run_phase(uvm_phase phase);
  extern function void check_phase(uvm_phase phase);
  `uvm_component_utils(${mod+'_'}scb)
endclass

function ${mod+'_'}scb::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction:new

function void ${mod+'_'}scb::build_phase(uvm_phase phase);
  super.build_phase(phase);
  expect_port = new("expect_port", this);
  actual_port = new("actual_port", this);
  act_cnt = 0;
  exp_cnt = 0;
endfunction:build_phase

task ${mod+'_'}scb::/*main*/run_phase(uvm_phase phase);
  ITEM get_expect, get_actual, get_compare;
  bit result;
  fork
    while(1)begin
      expect_port.get(get_expect);
      exp_cnt++;
      exp_queue.push_back(get_expect);
    end
    while(1)begin
      actual_port.get(get_actual);
      //phase.raise_objection(this);
      act_cnt++;
      //#100ns;  ///TODO 
      if(exp_queue.size() > 0)begin
        get_compare = exp_queue.pop_front();
        result = get_actual.item_compare(get_compare);
        if(result)begin
          `uvm_info(get_type_name(), $sformatf("compare successfully!!! "), UVM_MEDIUM)
        end
        else begin
          `uvm_error(get_type_name(), $sformatf("compare failed!!! !"))
        end
      end
      else begin
          `uvm_error(get_type_name(), $sformatf("get acutal item ,but expect item is not received!!! "))
      end
     //phase.drop_objection(this);
    end
  join
endtask

function void ${mod+'_'}scb::check_phase(uvm_phase phase);
  super.check_phase(phase);
  if(act_cnt != exp_cnt)begin
    `uvm_error(get_type_name(), $sformatf("get item mismatch , acutal item cnt:%d  expected item cnt:%d !!! ",act_cnt,exp_cnt))
  end
endfunction:check_phase

`endif

