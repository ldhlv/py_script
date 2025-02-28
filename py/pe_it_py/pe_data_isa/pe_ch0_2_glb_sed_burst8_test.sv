//==========================================================
//File  :pe_ch0_2_glb_sed_burst8_test.sv
//Author:Parker (LYG)
//Date  :2024.10.30
//==========================================================
`ifndef PE_CH0_2_GLB_SED_BURST8_TEST_SV
`define PE_CH0_2_GLB_SED_BURST8_TEST_SV


class pe_ch0_2_glb_sed_burst8_test extends pe_it_base_test;
//    pe_it_axi_mst_item      axi_tr;
//    pe_it_axi_mst_cmd_item  axi_cmd_tr;
      bit uvm_read_temp;
     
    `uvm_component_utils(pe_ch0_2_glb_sed_burst8_test)

    function new(string name = "pe_ch0_2_glb_sed_burst8_test", uvm_component parent);
        super.new(name, parent);
    endfunction:new

    task run_phase(uvm_phase phase);
        reg [7:0] burst_len_rdm;

        phase.raise_objection(this);
        set_engine_sel(4'h0);

        `uvm_info("pe_ch0_2_glb_sed_burst8_test","test start",UVM_LOW)
        axi_tr = pe_it_axi_mst_item::type_id::create("axi_tr");
        //axi_cmd_tr = pe_it_axi_mst_cmd_item::type_id::create("axi_cmd_tr");

        burst_len_rdm = 8;//$urandom_range(1,7); //{1,256}
        axi_tr.aximst_pe_wr_data    = new[burst_len_rdm];

        assert(axi_tr.randomize() with {
            //aximst_pe_id            == 2'b1;
            aximst_pe_addr          inside{'h1000};
            aximst_pe_burst_length  == burst_len_rdm;
            aximst_pe_burst_size    inside {128};
            aximst_pe_burst_type    inside {1};
            aximst_pe_awuser[0]     == 1'b1;
            aximst_pe_awuser[6]     == 1'b0;

        }); 
        axi_tr.print();
        #30ns;
        //handshake bit6 = 1 ; bit0~5 = dma_ch2_sed_len400.txt last line bit[5:0]
        uvm_hdl_force("top.u_pe_top_wrapper.u_pe_top.csr_rcv_handshake[6:0]",7'h58);

        uvm_hdl_force("top.u_pe_top_wrapper.u_pe_top.csr_src_baseaddr_offset[0][4:0]",'h0);  //ISA addr + offset
        uvm_hdl_force("top.u_pe_top_wrapper.u_pe_top.csr_dst_baseaddr_offset[0][4:0]",'h0);
        uvm_hdl_force("top.u_pe_top_wrapper.u_pe_top.csr_src_baseaddr_offset[1][4:0]",'h0);  //ISA addr + offset
        uvm_hdl_force("top.u_pe_top_wrapper.u_pe_top.csr_dst_baseaddr_offset[1][4:0]",'h0);
        uvm_hdl_force("top.u_pe_top_wrapper.u_pe_top.csr_src_baseaddr_offset[2][4:0]",'h0);  //ISA addr + offset
        uvm_hdl_force("top.u_pe_top_wrapper.u_pe_top.csr_dst_baseaddr_offset[2][4:0]",'h0);
        uvm_hdl_force("top.u_pe_top_wrapper.u_pe_top.csr_src_baseaddr_offset[3][4:0]",'h0);  //ISA addr + offset
        uvm_hdl_force("top.u_pe_top_wrapper.u_pe_top.csr_dst_baseaddr_offset[3][4:0]",'h0);
        uvm_hdl_force("top.u_pe_top_wrapper.u_pe_top.csr_src_baseaddr_offset[4][4:0]",'h0);  //ISA addr + offset
        uvm_hdl_force("top.u_pe_top_wrapper.u_pe_top.csr_dst_baseaddr_offset[4][4:0]",'h0);


        set_isa_cmd(PELS_I_CMD,"dma_test_isa/pels_i_isa_ch02.txt");
        set_isa_cmd(PELS_E_CMD,"dma_test_isa/pels_e_isa_ch02.txt");
        set_isa_cmd(PELS_O_CMD,"dma_test_isa/pels_o_isa_ch02.txt");


        set_isa_cmd(DMA0_CMD,"dma_test_isa/add1000_len400_ch0.txt");

/*
        if(axi_tr.aximst_pe_addr == 'h1000) begin
            set_isa_cmd(DMA0_CMD,"dma_test_isa/add1000_len400_ch0.txt");
            set_isa_cmd(DMA1_CMD,"dma_test_isa/add1000_len400_ch1.txt");
            end
        else if (axi_tr.aximst_pe_addr == 'h2000) begin
            set_isa_cmd(DMA0_CMD,"dma_test_isa/add2000_len400_ch0.txt");
            set_isa_cmd(DMA1_CMD,"dma_test_isa/add2000_len400_ch1.txt");
            end
        else if (axi_tr.aximst_pe_addr == 'h3000) begin
            set_isa_cmd(DMA0_CMD,"dma_test_isa/add3000_len400_ch0.txt");
            set_isa_cmd(DMA1_CMD,"dma_test_isa/add3000_len400_ch1.txt");
            end
        else begin
            set_isa_cmd(DMA0_CMD,"dma_test_isa/add4000_len400_ch0.txt");
            set_isa_cmd(DMA1_CMD,"dma_test_isa/add4000_len400_ch1.txt");
            end
*/

        fork 
        begin
            start_axi_slave();
        end

        begin


                axi_tr.aximst_pe_wr_data[0] = {128{8'h11}};
                axi_tr.aximst_pe_wr_data[1] = {128{8'h22}};
                axi_tr.aximst_pe_wr_data[2] = {128{8'h33}};
                axi_tr.aximst_pe_wr_data[3] = {128{8'h44}};
                axi_tr.aximst_pe_wr_data[4] = {128{8'h55}};
                axi_tr.aximst_pe_wr_data[5] = {128{8'h66}};
                axi_tr.aximst_pe_wr_data[6] = {128{8'h77}};
                axi_tr.aximst_pe_wr_data[7] = {128{8'h88}};

            wait_start_glb_write();

            axi_glb_write(axi_tr);
            set_ddma_channel_done(4'h1 << (axi_tr.aximst_pe_id)); 
            axi_tr.aximst_pe_wr_data.delete();

            uvm_hdl_deposit("top.u_pe_top_wrapper.u_pe_top.u_ddma_glb_if.i_axi_id_wr",1'b1);
            uvm_hdl_deposit("top.u_pe_top_wrapper.u_pe_top.u_ddma_glb_if.i_axi_id_rd",1'b1);
            set_isa_cmd(DMA2_CMD,"dma_test_isa/dma_ch2_sed_len400.txt");
            wait_pels_done();  //wait engine scheduler return done
            #300ns;
        end

        join_any


        #1000ns;
         set_check_enable(4'h5);
        #300;

        `uvm_info("pe_ch0_2_glb_sed_burst8_test","test  end",UVM_LOW)

        phase.drop_objection(this);

    endtask
    
endclass

`endif
