//==========================================================
//File  :${mod+'_'}clk_x_rst.sv
//Author:${usr_name}
//Date  :${today}
//==========================================================
`ifndef ${mod.upper()+'_'}CLK_X_RST_SV
`define ${mod.upper()+'_'}CLK_X_RST_SV
class ${mod+'_'}clk_x_rst_seq extends base_seq#(${in_item[0]}/*TODO*/);
  `uvm_object_utils(${mod+'_'}clk_x_rst_seq)
  function new(string name = "${mod+'_'}clk_x_rst_seq");
    super.new(name);
    `uvm_info("TRACE",$sformatf("%m"), UVM_HIGH);
  endfunction:new

  virtual task body();
  ////////////////////////////////////////////////////
  //repeat(1000000)
    `uvm_do(req);
    //`uvm_do_with(req,{/*TODO*/});
  ////////////////////////////////////////////////////
  endtask:body
endclass:${mod+'_'}clk_x_rst_seq


class ${mod+'_'}clk_x_rst extends ${mod+'_'}base;
  int flag;
  int rst_times;
  `uvm_component_utils(${mod+'_'}clk_x_rst)
  function new(string name, uvm_component parent);
    super.new(name, parent);
    flag = 0;
    rst_times = $urandom_range(2,10);    
  endfunction:new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this,"env.${uvcs[0]}.seqr.main_phase","default_sequence",${mod+'_'}clk_x_rst_seq::type_id::get()); //TODO
  endfunction : build_phase

  task reset_phase(uvm_phase phase); //{
    super.reset_phase(phase);
    phase.raise_objection(this);
    if(flag>0)
      env.${uvcs[0]}.seqr.stop_sequences();  //TODO
    @(posedge env.bus.${uvcs[0]}_bus.rst);  // wait for rst finish
    phase.drop_objection(this);
  endtask:reset_phase//}
/*
  virtual function void setting_crg();
    int freq, freq_q[$];
    freq_q={400,500,600,700,800,900,1000,1200};
    freq = freq_q[$urandom_range(0,(freq_q.size()-1))];

    m_crg_cfg.CRT_CLK("clk0",0,freq);   //TODO name:clk0, id:0  freq:500M.  clk name and id must unique
    m_crg_cfg.CRT_RST("rst0",0);       //TODO name:rst0, id:0.             rst name and id must unique
    //cfg one clk
    //set_clk_all(string clk_name,real freq,real duty,bit[1:0] start_vlu,real start_time,bit assert_vlu,bit jitter_en=0,int jitter_hit_prct=0,int jitter_vlu_prct=0)
    // start_vlu: 0/2'b00, 1/2'b01, x/2'b10, z/2'b11
    m_crg_cfg.set_clk_all("clk0", real'(freq), 0.5, 2, 20, 1); //TODO
    
    //cfg one rst
    //set_rst_all(string rst_name,int start_vlu,real start_time,int assert_vlu,real assert_time);
    m_crg_cfg.set_rst_all("rst0", 3, 40, 0, 20); //TODO
  endfunction:setting_crg
*/

  task main_phase(uvm_phase phase);
    //super.main_phase(phase);
    phase.raise_objection(this);
    if(flag<rst_times)begin   //reset rst_num times
      #5000ns;  //TODO
      m_crg_cfg.usr_assert_rst("rst0");
      `uvm_info(get_type_name,$sformatf("Assert the reset\n"),UVM_LOW);
      #50ns;
      m_crg_cfg.usr_deassert_rst("rst0");
      `uvm_info(get_type_name,$sformatf("Deassert the reset\n"),UVM_LOW);
      flag++;
      phase.jump(uvm_reset_phase::get());
    end
    #100ns;
    `uvm_info(get_type_name(), $sformatf("%m, finish!!"), UVM_LOW)
    phase.drop_objection(this);    
  endtask

endclass : ${mod+'_'}clk_x_rst
`endif
