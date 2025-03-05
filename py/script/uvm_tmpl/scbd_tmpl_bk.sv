//==========================================================
//File  :${mod+'_'}scb.sv
//Author:${usr_name}
//Date  :${today}
//==========================================================
`ifndef ${mod.upper()+'_'}SCB_SV
 `define ${mod.upper()+'_'}SCB_SV
typedef class ${mod+'_'}chk;
class ${mod+'_'}chk_subscriber#(type ITEM=uvm_sequence_item) extends uvm_subscriber#(ITEM);
  `uvm_component_param_utils(${mod+'_'}chk_subscriber)
  uvm_analysis_port#(ITEM) ap;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  function void write(ITEM tr);
    ${mod+'_'}chk chk;
    $cast(chk, m_scb);
    parent.check(tr);
  endfunction
endclass
`uvm_analysis_imp_decl(_dut)
`uvm_analysis_imp_decl(_ref)
class ${mod+'_'}chk #(type ITEM=uvm_sequence_item, type IDX=int) extends uvm_component;
  typedef ${mod+'_'}chk #(ITEM, IDX) this_type;
  `uvm_component_param_utils(this_type)

  typedef ITEM item_q[$];
  typedef IDX  idex_q[$];

  uvm_analysis_imp_dut#(ITEM, this_type) dut_imp;
  uvm_analysis_imp_ref#(ITEM, this_type) ref_imp;

  bit ooo = 0; // define this chk is an OutOfOrder chk or not
  bit ref_queued = 0;
  bit dut_queued = 0;

  protected int m_matches, m_mismatches;

  protected item_q recv_dat[IDX];
  protected int    recv_cnt[IDX];

  protected process dut_proc = null;
  protected process ref_proc = null;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern protected function void check(ITEM da, input bit is_ref);
  extern virtual function void write_ref(ITEM da);
  extern virtual function void write_dut(ITEM da);
  extern virtual function int get_matches();
  extern virtual function int get_mismatches();
  extern virtual function int get_total_missing();
  extern virtual function idex_q get_missing_indexes();
  extern virtual function int get_missing_index_count(IDX i);
endfunction // get_mismatches
endclass


function ${mod+'_'}chk::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void ${mod+'_'}chk::build_phase(uvm_phase phase);
  super.build_phase(phase);
  dut_imp = new("dut_imp", this);
  ref_imp = new("ref_imp", this);

  analysis_export = new("analysis_export", this);
  chk_subscriber = ${mod+'_'}chk_subscriber::type_id::create("chk_subscriber", this);
endfunction

function void ${mod+'_'}chk::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  analysis_export.connect(chk_subscriber.analysis_export);
endfunction // connect_phase

function void ${mod+'_'}chk::write_ref(ITEM da);
  this.check(da, 1);
endfunction // write_ref

function void ${mod+'_'}chk::write_dut(ITEM da);
  this.check(da, 0);
endfunction // write_dut

protected function void ${mod+'_'}chk::check(ITEM da, input bit is_ref);
  uvm_table_printer prt = new;
  ITEM da, da_existing;
  IDX idx;
  string rs;
  item_q tmpq;
  bit need_to_compare;

  idx = da.index_id();
  need_to_compare = (recv_cnt.exists(idx) &&
                     ((is_ref && recv_cnt[idx] > 0) ||
                     (!is_ref && recv_cnt[idx] < 0)));
  if (need_to_compare) begin
    tmpq = recv_dat[idx];
    da_existing = tmpq.pop_front();
    recv_dat[idx] = tmpq;
    if (da.compare(da_existing))
      m_matches++;
    else m_mismatch++;
  end
  else begin
    // if no compare happend, add the new entry
    tmpq = (recv_dat.exists(idx)) ? recv_dat[idx] : {};
    tmpq.push_back(da);
    recv_dat[idx] = tmpq;
  end

  //Update the index count
  if (is_ref) begin
    recv_cnt[idx] = (recv_cnt.exists(idx)) ? recv_cnt[idx]-1 : -1;
  end
  else begin
    recv_cnt[idx] = (recv_cnt.exists(idx)) ? recv_cnt[idx]+1 : 1;
  end

  if (recv_cnt[idx] = 0) begin
    recv_dat.delete(idx);
    recv_cnt.delete(idx);
  end
endfunction // check

function int ${mod+'_'}chk::get_matches();
  return m_matches;
endfunction // get_matches

function int ${mod+'_'}chk::get_mismatches();
  return m_mismatch;
endfunction // get_mismatches

function int ${mod+'_'}chk::get_total_missing();
  int   num_missing;
  foreach (recv_cnt[i]) begin
    num_missing += (recv_cnt[i] < 0 ? -recv_cnt[i] : recv_cnt[i]);
  end
  return num_missing;
endfunction // get_total_missing

function idex_q ${mod+'_'}chk::get_missing_indexes();
  idex_q rv = recv_cnt.find_index() with (item != 0);
  return rv;
endfunction // get_missing_indexes

function int ${mod+'_'}chk::get_missing_index_count(IDX i);
  // if count < 0, more "ref(before)" da were received
  // if count > 0, more "dut(after)" da were received
  if (recv_cnt.exists(i))
    return recv_cnt[i];
  else
    return 0;
endfunction // get_missing_index_count


class ${mod+'_'}scb#(type T=int) extends uvm_scoreboard;
  `uvm_component_param_utils(${mod+'_'}scb#(T))
  ${mod+'_'}chk#(T) chkr;
  ${mod+'_'}chk_subscriber#(T) scrb;
  uvm_analysis_export#(T) ref_axp;
  uvm_analysis_export#(T) dut_axp;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function bit passfail();
  extern function void summarize();
endclass //${mod+'_'}scb

function ${mod+'_'}scb::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction // new

function void ${mod+'_'}scb::build_phase(uvm_phase phase);
  super.build_phase(phase);
  chkr = ${mod+'_'}chk#(T)::type_id::create("chkr", this);
  scrb = ${mod+'_'}chk_subscriber#(T)::type_id::create("scrb", this);
  ref_axp = new("ref_axp", this);
  dut_axp = new("dut_axp", this);
endfunction // build_phase

function void ${mod+'_'}scb::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  dut_axp.connect(chkr.dut_imp);
  scrb.ap.connect(chkr.ref_imp);
  ref_axp.connect(scrb.analysis_export);
endfunction // connect_phase

function bit ${mod+'_'}scb::passfail();
  if ((chkr.get_mismatches() == 0) && (chkr.get_total_missing == 0))
    return 1'b1;
  else
    return 1'b0;
endfunction // passfail

function void ${mod+'_'}scb::summarize();
  `uvm_info("SCOREBOARD", $sformatf("\n\tMatches:%0d\n\tMismatches:%0d\n\tMissing:%0d", chkr.get_matches(), chkr.get_mismatches(), chkr.get_total_missing()), UVM_LOW);
endfunction // summarize

`endif
1