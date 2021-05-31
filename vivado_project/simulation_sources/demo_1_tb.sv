`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: FER
// Engineer: Mrkovic, Ramljak
// 
// Create Date: 28.05.2021 12:48:08
// Design Name: NoC_Mesh
// Module Name: demo_1_tb
// Project Name: NoC_Router
// Target Devices: zc706
// Tool Versions: 2020.2
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Revision 0.1 - 2021-05-28 - Mrkovic
// Additional Comments: demo funkcionalnosti cijelog projekta
// 
//////////////////////////////////////////////////////////////////////////////////


import axi_vip_pkg::*;
import demo_1_design_axi_vip_0_0_pkg::*;
import demo_1_design_axi_vip_1_0_pkg::*;

module demo_1_tb
    ();
    
    bit clk = 1;
    bit rst = 0;
    
    // adrese MNA_0
    xil_axi_ulong 
        addr_0_1=32'h50000000, addr_0_2 = 32'h50000004, addr_0_3 = 32'h50000008;
    // adrese MNA_1
    xil_axi_ulong 
        addr_1_1=32'h10000000, addr_1_2 = 32'h10000004, addr_1_3 = 32'h10000008;
    
    // protekcija MNA_0
    xil_axi_prot_t
        prot_0 = 0;
    // protekcija MNA_1
    xil_axi_prot_t
        prot_1 = 0;
    
    // podaci pisanja MNA_0
    bit [31:0] 
        data_0_wr1=32'h11000011, data_0_wr2=32'h22000022, data_0_wr3=32'h33000033;
    // podaci pisanja MNA_1
    bit [31:0] 
        data_1_wr1=32'h11111111, data_1_wr2=32'h22111122, data_1_wr3=32'h33111133;
    
    // podaci citanja MNA_0
    bit [31:0] 
        data_0_rd1, data_0_rd2, data_0_rd3;
    // podaci citanja MNA_1
    bit [31:0] 
        data_1_rd1, data_1_rd2, data_1_rd3;
    
    // resp MNA_0
    xil_axi_resp_t 
        resp_0;
    // resp MNA_1
    xil_axi_resp_t 
        resp_1;
    
    // takt
    always #5ns clk = ~clk;
    
    // portmap
    demo_1_design_wrapper DUT
    (
        . clk_0 (clk),
        . rst_0 (rst)
    );
    
    // deklaracija agenta MNA_0
    demo_1_design_axi_vip_0_0_mst_t MNA_0_agent;
    // deklaracija agenta MNA_1
    demo_1_design_axi_vip_1_0_mst_t MNA_1_agent;
    
    initial begin
    
        // kreacija agenata
        MNA_0_agent = new("master vip agent",DUT.demo_1_design_i.axi_vip_0.inst.IF);
        MNA_1_agent = new("master vip agent",DUT.demo_1_design_i.axi_vip_1.inst.IF);
        
        // postavljanje togova agenata (debug)
        MNA_0_agent.set_agent_tag("MNA_0 VIP");
        MNA_1_agent.set_agent_tag("MNA_1 VIP");
        // postavljanje verbosity levela agenata
        MNA_0_agent.set_verbosity(400);
        MNA_1_agent.set_verbosity(400);
        
        // pokretanje agenata
        MNA_0_agent.start_master();
        MNA_1_agent.start_master();
        
        // reset neaktivan
        #200ns
        rst = 1;
        
        // pisanje - MNA_0
        #20ns
        MNA_0_agent.AXI4LITE_WRITE_BURST(addr_0_1, prot_0, data_0_wr1, resp_0);
        #20ns
        MNA_0_agent.AXI4LITE_WRITE_BURST(addr_0_2, prot_0, data_0_wr2, resp_0);
        #20ns
        MNA_0_agent.AXI4LITE_WRITE_BURST(addr_0_3, prot_0, data_0_wr3, resp_0);
        
        // citanje - MNA_1
        #20ns
        MNA_1_agent.AXI4LITE_READ_BURST(addr_0_1, prot_1, data_1_rd1, resp_1);
        #20ns
        MNA_1_agent.AXI4LITE_READ_BURST(addr_0_2, prot_1, data_1_rd2, resp_1);
        #20ns
        MNA_1_agent.AXI4LITE_READ_BURST(addr_0_3, prot_1, data_1_rd3, resp_1);
        
        #500ns
        if((data_0_wr1 == data_1_rd1)&&(data_0_wr2 == data_1_rd2)&&(data_0_wr3 == data_1_rd3))
            $display("DATA MATCH - TEST 1 SUCCESSFUL");
        else
            $display("DATA MISMATCH - TEST 1 UNSUCCESSFUL");
            
        // pisanje - MNA_1
        #20ns
        MNA_1_agent.AXI4LITE_WRITE_BURST(addr_1_1, prot_1, data_1_wr1, resp_1);
        #20ns
        MNA_1_agent.AXI4LITE_WRITE_BURST(addr_1_2, prot_1, data_1_wr2, resp_1);
        #20ns
        MNA_1_agent.AXI4LITE_WRITE_BURST(addr_1_3, prot_1, data_1_wr3, resp_1);
        
        // citanje - MNA_0
        #20ns
        MNA_0_agent.AXI4LITE_READ_BURST(addr_1_1, prot_0, data_0_rd1, resp_0);
        #20ns
        MNA_0_agent.AXI4LITE_READ_BURST(addr_1_2, prot_0, data_0_rd2, resp_0);
        #20ns
        MNA_0_agent.AXI4LITE_READ_BURST(addr_1_3, prot_0, data_0_rd3, resp_0);
        
        #500ns
        if((data_1_wr1 == data_0_rd1)&&(data_1_wr2 == data_0_rd2)&&(data_1_wr3 == data_0_rd3))
            $display("DATA MATCH - TEST 2 SUCCESSFUL");
        else
            $display("DATA MISMATCH - TEST 2 UNSUCCESSFUL");
        
        $finish;
    
    end

endmodule