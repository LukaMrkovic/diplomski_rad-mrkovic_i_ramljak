--Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
--Date        : Fri May 28 15:19:18 2021
--Host        : LukaM-GTX980TI running 64-bit major release  (build 9200)
--Command     : generate_target demo_1_design.bd
--Design      : demo_1_design
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity demo_1_design is
  port (
    clk_0 : in STD_LOGIC;
    rst_0 : in STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of demo_1_design : entity is "demo_1_design,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=demo_1_design,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=7,numReposBlks=7,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=1,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of demo_1_design : entity is "demo_1_design.hwdef";
end demo_1_design;

architecture STRUCTURE of demo_1_design is
  component demo_1_design_demo_1_0_0 is
  port (
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    MNA_0_AWADDR : in STD_LOGIC_VECTOR ( 31 downto 0 );
    MNA_0_AWPROT : in STD_LOGIC_VECTOR ( 2 downto 0 );
    MNA_0_AWVALID : in STD_LOGIC;
    MNA_0_AWREADY : out STD_LOGIC;
    MNA_0_WDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    MNA_0_WSTRB : in STD_LOGIC_VECTOR ( 3 downto 0 );
    MNA_0_WVALID : in STD_LOGIC;
    MNA_0_WREADY : out STD_LOGIC;
    MNA_0_ARADDR : in STD_LOGIC_VECTOR ( 31 downto 0 );
    MNA_0_ARPROT : in STD_LOGIC_VECTOR ( 2 downto 0 );
    MNA_0_ARVALID : in STD_LOGIC;
    MNA_0_ARREADY : out STD_LOGIC;
    MNA_0_BRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    MNA_0_BVALID : out STD_LOGIC;
    MNA_0_BREADY : in STD_LOGIC;
    MNA_0_RDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    MNA_0_RRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    MNA_0_RVALID : out STD_LOGIC;
    MNA_0_RREADY : in STD_LOGIC;
    MNA_1_AWADDR : in STD_LOGIC_VECTOR ( 31 downto 0 );
    MNA_1_AWPROT : in STD_LOGIC_VECTOR ( 2 downto 0 );
    MNA_1_AWVALID : in STD_LOGIC;
    MNA_1_AWREADY : out STD_LOGIC;
    MNA_1_WDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    MNA_1_WSTRB : in STD_LOGIC_VECTOR ( 3 downto 0 );
    MNA_1_WVALID : in STD_LOGIC;
    MNA_1_WREADY : out STD_LOGIC;
    MNA_1_ARADDR : in STD_LOGIC_VECTOR ( 31 downto 0 );
    MNA_1_ARPROT : in STD_LOGIC_VECTOR ( 2 downto 0 );
    MNA_1_ARVALID : in STD_LOGIC;
    MNA_1_ARREADY : out STD_LOGIC;
    MNA_1_BRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    MNA_1_BVALID : out STD_LOGIC;
    MNA_1_BREADY : in STD_LOGIC;
    MNA_1_RDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    MNA_1_RRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    MNA_1_RVALID : out STD_LOGIC;
    MNA_1_RREADY : in STD_LOGIC;
    SNA_0_AWADDR : out STD_LOGIC_VECTOR ( 31 downto 0 );
    SNA_0_AWPROT : out STD_LOGIC_VECTOR ( 2 downto 0 );
    SNA_0_AWVALID : out STD_LOGIC;
    SNA_0_AWREADY : in STD_LOGIC;
    SNA_0_WDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    SNA_0_WSTRB : out STD_LOGIC_VECTOR ( 3 downto 0 );
    SNA_0_WVALID : out STD_LOGIC;
    SNA_0_WREADY : in STD_LOGIC;
    SNA_0_ARADDR : out STD_LOGIC_VECTOR ( 31 downto 0 );
    SNA_0_ARPROT : out STD_LOGIC_VECTOR ( 2 downto 0 );
    SNA_0_ARVALID : out STD_LOGIC;
    SNA_0_ARREADY : in STD_LOGIC;
    SNA_0_BRESP : in STD_LOGIC_VECTOR ( 1 downto 0 );
    SNA_0_BVALID : in STD_LOGIC;
    SNA_0_BREADY : out STD_LOGIC;
    SNA_0_RDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    SNA_0_RRESP : in STD_LOGIC_VECTOR ( 1 downto 0 );
    SNA_0_RVALID : in STD_LOGIC;
    SNA_0_RREADY : out STD_LOGIC;
    SNA_1_AWADDR : out STD_LOGIC_VECTOR ( 31 downto 0 );
    SNA_1_AWPROT : out STD_LOGIC_VECTOR ( 2 downto 0 );
    SNA_1_AWVALID : out STD_LOGIC;
    SNA_1_AWREADY : in STD_LOGIC;
    SNA_1_WDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    SNA_1_WSTRB : out STD_LOGIC_VECTOR ( 3 downto 0 );
    SNA_1_WVALID : out STD_LOGIC;
    SNA_1_WREADY : in STD_LOGIC;
    SNA_1_ARADDR : out STD_LOGIC_VECTOR ( 31 downto 0 );
    SNA_1_ARPROT : out STD_LOGIC_VECTOR ( 2 downto 0 );
    SNA_1_ARVALID : out STD_LOGIC;
    SNA_1_ARREADY : in STD_LOGIC;
    SNA_1_BRESP : in STD_LOGIC_VECTOR ( 1 downto 0 );
    SNA_1_BVALID : in STD_LOGIC;
    SNA_1_BREADY : out STD_LOGIC;
    SNA_1_RDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    SNA_1_RRESP : in STD_LOGIC_VECTOR ( 1 downto 0 );
    SNA_1_RVALID : in STD_LOGIC;
    SNA_1_RREADY : out STD_LOGIC
  );
  end component demo_1_design_demo_1_0_0;
  component demo_1_design_axi_vip_0_0 is
  port (
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    m_axi_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_awvalid : out STD_LOGIC;
    m_axi_awready : in STD_LOGIC;
    m_axi_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_wvalid : out STD_LOGIC;
    m_axi_wready : in STD_LOGIC;
    m_axi_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_bvalid : in STD_LOGIC;
    m_axi_bready : out STD_LOGIC;
    m_axi_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_arvalid : out STD_LOGIC;
    m_axi_arready : in STD_LOGIC;
    m_axi_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rvalid : in STD_LOGIC;
    m_axi_rready : out STD_LOGIC
  );
  end component demo_1_design_axi_vip_0_0;
  component demo_1_design_axi_vip_1_0 is
  port (
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    m_axi_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_awvalid : out STD_LOGIC;
    m_axi_awready : in STD_LOGIC;
    m_axi_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_wvalid : out STD_LOGIC;
    m_axi_wready : in STD_LOGIC;
    m_axi_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_bvalid : in STD_LOGIC;
    m_axi_bready : out STD_LOGIC;
    m_axi_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_arvalid : out STD_LOGIC;
    m_axi_arready : in STD_LOGIC;
    m_axi_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rvalid : in STD_LOGIC;
    m_axi_rready : out STD_LOGIC
  );
  end component demo_1_design_axi_vip_1_0;
  component demo_1_design_axi_bram_ctrl_0_0 is
  port (
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 12 downto 0 );
    s_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 12 downto 0 );
    s_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    bram_rst_a : out STD_LOGIC;
    bram_clk_a : out STD_LOGIC;
    bram_en_a : out STD_LOGIC;
    bram_we_a : out STD_LOGIC_VECTOR ( 3 downto 0 );
    bram_addr_a : out STD_LOGIC_VECTOR ( 12 downto 0 );
    bram_wrdata_a : out STD_LOGIC_VECTOR ( 31 downto 0 );
    bram_rddata_a : in STD_LOGIC_VECTOR ( 31 downto 0 );
    bram_rst_b : out STD_LOGIC;
    bram_clk_b : out STD_LOGIC;
    bram_en_b : out STD_LOGIC;
    bram_we_b : out STD_LOGIC_VECTOR ( 3 downto 0 );
    bram_addr_b : out STD_LOGIC_VECTOR ( 12 downto 0 );
    bram_wrdata_b : out STD_LOGIC_VECTOR ( 31 downto 0 );
    bram_rddata_b : in STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  end component demo_1_design_axi_bram_ctrl_0_0;
  component demo_1_design_axi_bram_ctrl_1_0 is
  port (
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 12 downto 0 );
    s_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 12 downto 0 );
    s_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    bram_rst_a : out STD_LOGIC;
    bram_clk_a : out STD_LOGIC;
    bram_en_a : out STD_LOGIC;
    bram_we_a : out STD_LOGIC_VECTOR ( 3 downto 0 );
    bram_addr_a : out STD_LOGIC_VECTOR ( 12 downto 0 );
    bram_wrdata_a : out STD_LOGIC_VECTOR ( 31 downto 0 );
    bram_rddata_a : in STD_LOGIC_VECTOR ( 31 downto 0 );
    bram_rst_b : out STD_LOGIC;
    bram_clk_b : out STD_LOGIC;
    bram_en_b : out STD_LOGIC;
    bram_we_b : out STD_LOGIC_VECTOR ( 3 downto 0 );
    bram_addr_b : out STD_LOGIC_VECTOR ( 12 downto 0 );
    bram_wrdata_b : out STD_LOGIC_VECTOR ( 31 downto 0 );
    bram_rddata_b : in STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  end component demo_1_design_axi_bram_ctrl_1_0;
  component demo_1_design_blk_mem_gen_0_0 is
  port (
    clka : in STD_LOGIC;
    rsta : in STD_LOGIC;
    ena : in STD_LOGIC;
    wea : in STD_LOGIC_VECTOR ( 3 downto 0 );
    addra : in STD_LOGIC_VECTOR ( 31 downto 0 );
    dina : in STD_LOGIC_VECTOR ( 31 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 31 downto 0 );
    clkb : in STD_LOGIC;
    rstb : in STD_LOGIC;
    enb : in STD_LOGIC;
    web : in STD_LOGIC_VECTOR ( 3 downto 0 );
    addrb : in STD_LOGIC_VECTOR ( 31 downto 0 );
    dinb : in STD_LOGIC_VECTOR ( 31 downto 0 );
    doutb : out STD_LOGIC_VECTOR ( 31 downto 0 );
    rsta_busy : out STD_LOGIC;
    rstb_busy : out STD_LOGIC
  );
  end component demo_1_design_blk_mem_gen_0_0;
  component demo_1_design_blk_mem_gen_1_0 is
  port (
    clka : in STD_LOGIC;
    rsta : in STD_LOGIC;
    ena : in STD_LOGIC;
    wea : in STD_LOGIC_VECTOR ( 3 downto 0 );
    addra : in STD_LOGIC_VECTOR ( 31 downto 0 );
    dina : in STD_LOGIC_VECTOR ( 31 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 31 downto 0 );
    clkb : in STD_LOGIC;
    rstb : in STD_LOGIC;
    enb : in STD_LOGIC;
    web : in STD_LOGIC_VECTOR ( 3 downto 0 );
    addrb : in STD_LOGIC_VECTOR ( 31 downto 0 );
    dinb : in STD_LOGIC_VECTOR ( 31 downto 0 );
    doutb : out STD_LOGIC_VECTOR ( 31 downto 0 );
    rsta_busy : out STD_LOGIC;
    rstb_busy : out STD_LOGIC
  );
  end component demo_1_design_blk_mem_gen_1_0;
  signal axi_bram_ctrl_0_BRAM_PORTA_ADDR : STD_LOGIC_VECTOR ( 12 downto 0 );
  signal axi_bram_ctrl_0_BRAM_PORTA_CLK : STD_LOGIC;
  signal axi_bram_ctrl_0_BRAM_PORTA_DIN : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal axi_bram_ctrl_0_BRAM_PORTA_DOUT : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal axi_bram_ctrl_0_BRAM_PORTA_EN : STD_LOGIC;
  signal axi_bram_ctrl_0_BRAM_PORTA_RST : STD_LOGIC;
  signal axi_bram_ctrl_0_BRAM_PORTA_WE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal axi_bram_ctrl_0_BRAM_PORTB_ADDR : STD_LOGIC_VECTOR ( 12 downto 0 );
  signal axi_bram_ctrl_0_BRAM_PORTB_CLK : STD_LOGIC;
  signal axi_bram_ctrl_0_BRAM_PORTB_DIN : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal axi_bram_ctrl_0_BRAM_PORTB_DOUT : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal axi_bram_ctrl_0_BRAM_PORTB_EN : STD_LOGIC;
  signal axi_bram_ctrl_0_BRAM_PORTB_RST : STD_LOGIC;
  signal axi_bram_ctrl_0_BRAM_PORTB_WE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal axi_bram_ctrl_1_BRAM_PORTA_ADDR : STD_LOGIC_VECTOR ( 12 downto 0 );
  signal axi_bram_ctrl_1_BRAM_PORTA_CLK : STD_LOGIC;
  signal axi_bram_ctrl_1_BRAM_PORTA_DIN : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal axi_bram_ctrl_1_BRAM_PORTA_DOUT : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal axi_bram_ctrl_1_BRAM_PORTA_EN : STD_LOGIC;
  signal axi_bram_ctrl_1_BRAM_PORTA_RST : STD_LOGIC;
  signal axi_bram_ctrl_1_BRAM_PORTA_WE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal axi_bram_ctrl_1_BRAM_PORTB_ADDR : STD_LOGIC_VECTOR ( 12 downto 0 );
  signal axi_bram_ctrl_1_BRAM_PORTB_CLK : STD_LOGIC;
  signal axi_bram_ctrl_1_BRAM_PORTB_DIN : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal axi_bram_ctrl_1_BRAM_PORTB_DOUT : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal axi_bram_ctrl_1_BRAM_PORTB_EN : STD_LOGIC;
  signal axi_bram_ctrl_1_BRAM_PORTB_RST : STD_LOGIC;
  signal axi_bram_ctrl_1_BRAM_PORTB_WE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal axi_vip_0_M_AXI_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal axi_vip_0_M_AXI_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal axi_vip_0_M_AXI_ARREADY : STD_LOGIC;
  signal axi_vip_0_M_AXI_ARVALID : STD_LOGIC;
  signal axi_vip_0_M_AXI_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal axi_vip_0_M_AXI_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal axi_vip_0_M_AXI_AWREADY : STD_LOGIC;
  signal axi_vip_0_M_AXI_AWVALID : STD_LOGIC;
  signal axi_vip_0_M_AXI_BREADY : STD_LOGIC;
  signal axi_vip_0_M_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal axi_vip_0_M_AXI_BVALID : STD_LOGIC;
  signal axi_vip_0_M_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal axi_vip_0_M_AXI_RREADY : STD_LOGIC;
  signal axi_vip_0_M_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal axi_vip_0_M_AXI_RVALID : STD_LOGIC;
  signal axi_vip_0_M_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal axi_vip_0_M_AXI_WREADY : STD_LOGIC;
  signal axi_vip_0_M_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal axi_vip_0_M_AXI_WVALID : STD_LOGIC;
  signal axi_vip_1_M_AXI_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal axi_vip_1_M_AXI_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal axi_vip_1_M_AXI_ARREADY : STD_LOGIC;
  signal axi_vip_1_M_AXI_ARVALID : STD_LOGIC;
  signal axi_vip_1_M_AXI_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal axi_vip_1_M_AXI_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal axi_vip_1_M_AXI_AWREADY : STD_LOGIC;
  signal axi_vip_1_M_AXI_AWVALID : STD_LOGIC;
  signal axi_vip_1_M_AXI_BREADY : STD_LOGIC;
  signal axi_vip_1_M_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal axi_vip_1_M_AXI_BVALID : STD_LOGIC;
  signal axi_vip_1_M_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal axi_vip_1_M_AXI_RREADY : STD_LOGIC;
  signal axi_vip_1_M_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal axi_vip_1_M_AXI_RVALID : STD_LOGIC;
  signal axi_vip_1_M_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal axi_vip_1_M_AXI_WREADY : STD_LOGIC;
  signal axi_vip_1_M_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal axi_vip_1_M_AXI_WVALID : STD_LOGIC;
  signal clk_0_1 : STD_LOGIC;
  signal demo_1_0_SNA_0_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal demo_1_0_SNA_0_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal demo_1_0_SNA_0_ARREADY : STD_LOGIC;
  signal demo_1_0_SNA_0_ARVALID : STD_LOGIC;
  signal demo_1_0_SNA_0_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal demo_1_0_SNA_0_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal demo_1_0_SNA_0_AWREADY : STD_LOGIC;
  signal demo_1_0_SNA_0_AWVALID : STD_LOGIC;
  signal demo_1_0_SNA_0_BREADY : STD_LOGIC;
  signal demo_1_0_SNA_0_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal demo_1_0_SNA_0_BVALID : STD_LOGIC;
  signal demo_1_0_SNA_0_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal demo_1_0_SNA_0_RREADY : STD_LOGIC;
  signal demo_1_0_SNA_0_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal demo_1_0_SNA_0_RVALID : STD_LOGIC;
  signal demo_1_0_SNA_0_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal demo_1_0_SNA_0_WREADY : STD_LOGIC;
  signal demo_1_0_SNA_0_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal demo_1_0_SNA_0_WVALID : STD_LOGIC;
  signal demo_1_0_SNA_1_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal demo_1_0_SNA_1_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal demo_1_0_SNA_1_ARREADY : STD_LOGIC;
  signal demo_1_0_SNA_1_ARVALID : STD_LOGIC;
  signal demo_1_0_SNA_1_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal demo_1_0_SNA_1_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal demo_1_0_SNA_1_AWREADY : STD_LOGIC;
  signal demo_1_0_SNA_1_AWVALID : STD_LOGIC;
  signal demo_1_0_SNA_1_BREADY : STD_LOGIC;
  signal demo_1_0_SNA_1_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal demo_1_0_SNA_1_BVALID : STD_LOGIC;
  signal demo_1_0_SNA_1_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal demo_1_0_SNA_1_RREADY : STD_LOGIC;
  signal demo_1_0_SNA_1_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal demo_1_0_SNA_1_RVALID : STD_LOGIC;
  signal demo_1_0_SNA_1_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal demo_1_0_SNA_1_WREADY : STD_LOGIC;
  signal demo_1_0_SNA_1_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal demo_1_0_SNA_1_WVALID : STD_LOGIC;
  signal rst_0_1 : STD_LOGIC;
  signal NLW_blk_mem_gen_0_rsta_busy_UNCONNECTED : STD_LOGIC;
  signal NLW_blk_mem_gen_0_rstb_busy_UNCONNECTED : STD_LOGIC;
  signal NLW_blk_mem_gen_1_rsta_busy_UNCONNECTED : STD_LOGIC;
  signal NLW_blk_mem_gen_1_rstb_busy_UNCONNECTED : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clk_0 : signal is "xilinx.com:signal:clock:1.0 CLK.CLK_0 CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clk_0 : signal is "XIL_INTERFACENAME CLK.CLK_0, ASSOCIATED_RESET rst_0, CLK_DOMAIN demo_1_design_clk_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.000";
  attribute X_INTERFACE_INFO of rst_0 : signal is "xilinx.com:signal:reset:1.0 RST.RST_0 RST";
  attribute X_INTERFACE_PARAMETER of rst_0 : signal is "XIL_INTERFACENAME RST.RST_0, INSERT_VIP 0, POLARITY ACTIVE_LOW";
begin
  clk_0_1 <= clk_0;
  rst_0_1 <= rst_0;
axi_bram_ctrl_0: component demo_1_design_axi_bram_ctrl_0_0
     port map (
      bram_addr_a(12 downto 0) => axi_bram_ctrl_0_BRAM_PORTA_ADDR(12 downto 0),
      bram_addr_b(12 downto 0) => axi_bram_ctrl_0_BRAM_PORTB_ADDR(12 downto 0),
      bram_clk_a => axi_bram_ctrl_0_BRAM_PORTA_CLK,
      bram_clk_b => axi_bram_ctrl_0_BRAM_PORTB_CLK,
      bram_en_a => axi_bram_ctrl_0_BRAM_PORTA_EN,
      bram_en_b => axi_bram_ctrl_0_BRAM_PORTB_EN,
      bram_rddata_a(31 downto 0) => axi_bram_ctrl_0_BRAM_PORTA_DOUT(31 downto 0),
      bram_rddata_b(31 downto 0) => axi_bram_ctrl_0_BRAM_PORTB_DOUT(31 downto 0),
      bram_rst_a => axi_bram_ctrl_0_BRAM_PORTA_RST,
      bram_rst_b => axi_bram_ctrl_0_BRAM_PORTB_RST,
      bram_we_a(3 downto 0) => axi_bram_ctrl_0_BRAM_PORTA_WE(3 downto 0),
      bram_we_b(3 downto 0) => axi_bram_ctrl_0_BRAM_PORTB_WE(3 downto 0),
      bram_wrdata_a(31 downto 0) => axi_bram_ctrl_0_BRAM_PORTA_DIN(31 downto 0),
      bram_wrdata_b(31 downto 0) => axi_bram_ctrl_0_BRAM_PORTB_DIN(31 downto 0),
      s_axi_aclk => clk_0_1,
      s_axi_araddr(12 downto 0) => demo_1_0_SNA_0_ARADDR(12 downto 0),
      s_axi_aresetn => rst_0_1,
      s_axi_arprot(2 downto 0) => demo_1_0_SNA_0_ARPROT(2 downto 0),
      s_axi_arready => demo_1_0_SNA_0_ARREADY,
      s_axi_arvalid => demo_1_0_SNA_0_ARVALID,
      s_axi_awaddr(12 downto 0) => demo_1_0_SNA_0_AWADDR(12 downto 0),
      s_axi_awprot(2 downto 0) => demo_1_0_SNA_0_AWPROT(2 downto 0),
      s_axi_awready => demo_1_0_SNA_0_AWREADY,
      s_axi_awvalid => demo_1_0_SNA_0_AWVALID,
      s_axi_bready => demo_1_0_SNA_0_BREADY,
      s_axi_bresp(1 downto 0) => demo_1_0_SNA_0_BRESP(1 downto 0),
      s_axi_bvalid => demo_1_0_SNA_0_BVALID,
      s_axi_rdata(31 downto 0) => demo_1_0_SNA_0_RDATA(31 downto 0),
      s_axi_rready => demo_1_0_SNA_0_RREADY,
      s_axi_rresp(1 downto 0) => demo_1_0_SNA_0_RRESP(1 downto 0),
      s_axi_rvalid => demo_1_0_SNA_0_RVALID,
      s_axi_wdata(31 downto 0) => demo_1_0_SNA_0_WDATA(31 downto 0),
      s_axi_wready => demo_1_0_SNA_0_WREADY,
      s_axi_wstrb(3 downto 0) => demo_1_0_SNA_0_WSTRB(3 downto 0),
      s_axi_wvalid => demo_1_0_SNA_0_WVALID
    );
axi_bram_ctrl_1: component demo_1_design_axi_bram_ctrl_1_0
     port map (
      bram_addr_a(12 downto 0) => axi_bram_ctrl_1_BRAM_PORTA_ADDR(12 downto 0),
      bram_addr_b(12 downto 0) => axi_bram_ctrl_1_BRAM_PORTB_ADDR(12 downto 0),
      bram_clk_a => axi_bram_ctrl_1_BRAM_PORTA_CLK,
      bram_clk_b => axi_bram_ctrl_1_BRAM_PORTB_CLK,
      bram_en_a => axi_bram_ctrl_1_BRAM_PORTA_EN,
      bram_en_b => axi_bram_ctrl_1_BRAM_PORTB_EN,
      bram_rddata_a(31 downto 0) => axi_bram_ctrl_1_BRAM_PORTA_DOUT(31 downto 0),
      bram_rddata_b(31 downto 0) => axi_bram_ctrl_1_BRAM_PORTB_DOUT(31 downto 0),
      bram_rst_a => axi_bram_ctrl_1_BRAM_PORTA_RST,
      bram_rst_b => axi_bram_ctrl_1_BRAM_PORTB_RST,
      bram_we_a(3 downto 0) => axi_bram_ctrl_1_BRAM_PORTA_WE(3 downto 0),
      bram_we_b(3 downto 0) => axi_bram_ctrl_1_BRAM_PORTB_WE(3 downto 0),
      bram_wrdata_a(31 downto 0) => axi_bram_ctrl_1_BRAM_PORTA_DIN(31 downto 0),
      bram_wrdata_b(31 downto 0) => axi_bram_ctrl_1_BRAM_PORTB_DIN(31 downto 0),
      s_axi_aclk => clk_0_1,
      s_axi_araddr(12 downto 0) => demo_1_0_SNA_1_ARADDR(12 downto 0),
      s_axi_aresetn => rst_0_1,
      s_axi_arprot(2 downto 0) => demo_1_0_SNA_1_ARPROT(2 downto 0),
      s_axi_arready => demo_1_0_SNA_1_ARREADY,
      s_axi_arvalid => demo_1_0_SNA_1_ARVALID,
      s_axi_awaddr(12 downto 0) => demo_1_0_SNA_1_AWADDR(12 downto 0),
      s_axi_awprot(2 downto 0) => demo_1_0_SNA_1_AWPROT(2 downto 0),
      s_axi_awready => demo_1_0_SNA_1_AWREADY,
      s_axi_awvalid => demo_1_0_SNA_1_AWVALID,
      s_axi_bready => demo_1_0_SNA_1_BREADY,
      s_axi_bresp(1 downto 0) => demo_1_0_SNA_1_BRESP(1 downto 0),
      s_axi_bvalid => demo_1_0_SNA_1_BVALID,
      s_axi_rdata(31 downto 0) => demo_1_0_SNA_1_RDATA(31 downto 0),
      s_axi_rready => demo_1_0_SNA_1_RREADY,
      s_axi_rresp(1 downto 0) => demo_1_0_SNA_1_RRESP(1 downto 0),
      s_axi_rvalid => demo_1_0_SNA_1_RVALID,
      s_axi_wdata(31 downto 0) => demo_1_0_SNA_1_WDATA(31 downto 0),
      s_axi_wready => demo_1_0_SNA_1_WREADY,
      s_axi_wstrb(3 downto 0) => demo_1_0_SNA_1_WSTRB(3 downto 0),
      s_axi_wvalid => demo_1_0_SNA_1_WVALID
    );
axi_vip_0: component demo_1_design_axi_vip_0_0
     port map (
      aclk => clk_0_1,
      aresetn => rst_0_1,
      m_axi_araddr(31 downto 0) => axi_vip_0_M_AXI_ARADDR(31 downto 0),
      m_axi_arprot(2 downto 0) => axi_vip_0_M_AXI_ARPROT(2 downto 0),
      m_axi_arready => axi_vip_0_M_AXI_ARREADY,
      m_axi_arvalid => axi_vip_0_M_AXI_ARVALID,
      m_axi_awaddr(31 downto 0) => axi_vip_0_M_AXI_AWADDR(31 downto 0),
      m_axi_awprot(2 downto 0) => axi_vip_0_M_AXI_AWPROT(2 downto 0),
      m_axi_awready => axi_vip_0_M_AXI_AWREADY,
      m_axi_awvalid => axi_vip_0_M_AXI_AWVALID,
      m_axi_bready => axi_vip_0_M_AXI_BREADY,
      m_axi_bresp(1 downto 0) => axi_vip_0_M_AXI_BRESP(1 downto 0),
      m_axi_bvalid => axi_vip_0_M_AXI_BVALID,
      m_axi_rdata(31 downto 0) => axi_vip_0_M_AXI_RDATA(31 downto 0),
      m_axi_rready => axi_vip_0_M_AXI_RREADY,
      m_axi_rresp(1 downto 0) => axi_vip_0_M_AXI_RRESP(1 downto 0),
      m_axi_rvalid => axi_vip_0_M_AXI_RVALID,
      m_axi_wdata(31 downto 0) => axi_vip_0_M_AXI_WDATA(31 downto 0),
      m_axi_wready => axi_vip_0_M_AXI_WREADY,
      m_axi_wstrb(3 downto 0) => axi_vip_0_M_AXI_WSTRB(3 downto 0),
      m_axi_wvalid => axi_vip_0_M_AXI_WVALID
    );
axi_vip_1: component demo_1_design_axi_vip_1_0
     port map (
      aclk => clk_0_1,
      aresetn => rst_0_1,
      m_axi_araddr(31 downto 0) => axi_vip_1_M_AXI_ARADDR(31 downto 0),
      m_axi_arprot(2 downto 0) => axi_vip_1_M_AXI_ARPROT(2 downto 0),
      m_axi_arready => axi_vip_1_M_AXI_ARREADY,
      m_axi_arvalid => axi_vip_1_M_AXI_ARVALID,
      m_axi_awaddr(31 downto 0) => axi_vip_1_M_AXI_AWADDR(31 downto 0),
      m_axi_awprot(2 downto 0) => axi_vip_1_M_AXI_AWPROT(2 downto 0),
      m_axi_awready => axi_vip_1_M_AXI_AWREADY,
      m_axi_awvalid => axi_vip_1_M_AXI_AWVALID,
      m_axi_bready => axi_vip_1_M_AXI_BREADY,
      m_axi_bresp(1 downto 0) => axi_vip_1_M_AXI_BRESP(1 downto 0),
      m_axi_bvalid => axi_vip_1_M_AXI_BVALID,
      m_axi_rdata(31 downto 0) => axi_vip_1_M_AXI_RDATA(31 downto 0),
      m_axi_rready => axi_vip_1_M_AXI_RREADY,
      m_axi_rresp(1 downto 0) => axi_vip_1_M_AXI_RRESP(1 downto 0),
      m_axi_rvalid => axi_vip_1_M_AXI_RVALID,
      m_axi_wdata(31 downto 0) => axi_vip_1_M_AXI_WDATA(31 downto 0),
      m_axi_wready => axi_vip_1_M_AXI_WREADY,
      m_axi_wstrb(3 downto 0) => axi_vip_1_M_AXI_WSTRB(3 downto 0),
      m_axi_wvalid => axi_vip_1_M_AXI_WVALID
    );
blk_mem_gen_0: component demo_1_design_blk_mem_gen_0_0
     port map (
      addra(31 downto 13) => B"0000000000000000000",
      addra(12 downto 0) => axi_bram_ctrl_0_BRAM_PORTA_ADDR(12 downto 0),
      addrb(31 downto 13) => B"0000000000000000000",
      addrb(12 downto 0) => axi_bram_ctrl_0_BRAM_PORTB_ADDR(12 downto 0),
      clka => axi_bram_ctrl_0_BRAM_PORTA_CLK,
      clkb => axi_bram_ctrl_0_BRAM_PORTB_CLK,
      dina(31 downto 0) => axi_bram_ctrl_0_BRAM_PORTA_DIN(31 downto 0),
      dinb(31 downto 0) => axi_bram_ctrl_0_BRAM_PORTB_DIN(31 downto 0),
      douta(31 downto 0) => axi_bram_ctrl_0_BRAM_PORTA_DOUT(31 downto 0),
      doutb(31 downto 0) => axi_bram_ctrl_0_BRAM_PORTB_DOUT(31 downto 0),
      ena => axi_bram_ctrl_0_BRAM_PORTA_EN,
      enb => axi_bram_ctrl_0_BRAM_PORTB_EN,
      rsta => axi_bram_ctrl_0_BRAM_PORTA_RST,
      rsta_busy => NLW_blk_mem_gen_0_rsta_busy_UNCONNECTED,
      rstb => axi_bram_ctrl_0_BRAM_PORTB_RST,
      rstb_busy => NLW_blk_mem_gen_0_rstb_busy_UNCONNECTED,
      wea(3 downto 0) => axi_bram_ctrl_0_BRAM_PORTA_WE(3 downto 0),
      web(3 downto 0) => axi_bram_ctrl_0_BRAM_PORTB_WE(3 downto 0)
    );
blk_mem_gen_1: component demo_1_design_blk_mem_gen_1_0
     port map (
      addra(31 downto 13) => B"0000000000000000000",
      addra(12 downto 0) => axi_bram_ctrl_1_BRAM_PORTA_ADDR(12 downto 0),
      addrb(31 downto 13) => B"0000000000000000000",
      addrb(12 downto 0) => axi_bram_ctrl_1_BRAM_PORTB_ADDR(12 downto 0),
      clka => axi_bram_ctrl_1_BRAM_PORTA_CLK,
      clkb => axi_bram_ctrl_1_BRAM_PORTB_CLK,
      dina(31 downto 0) => axi_bram_ctrl_1_BRAM_PORTA_DIN(31 downto 0),
      dinb(31 downto 0) => axi_bram_ctrl_1_BRAM_PORTB_DIN(31 downto 0),
      douta(31 downto 0) => axi_bram_ctrl_1_BRAM_PORTA_DOUT(31 downto 0),
      doutb(31 downto 0) => axi_bram_ctrl_1_BRAM_PORTB_DOUT(31 downto 0),
      ena => axi_bram_ctrl_1_BRAM_PORTA_EN,
      enb => axi_bram_ctrl_1_BRAM_PORTB_EN,
      rsta => axi_bram_ctrl_1_BRAM_PORTA_RST,
      rsta_busy => NLW_blk_mem_gen_1_rsta_busy_UNCONNECTED,
      rstb => axi_bram_ctrl_1_BRAM_PORTB_RST,
      rstb_busy => NLW_blk_mem_gen_1_rstb_busy_UNCONNECTED,
      wea(3 downto 0) => axi_bram_ctrl_1_BRAM_PORTA_WE(3 downto 0),
      web(3 downto 0) => axi_bram_ctrl_1_BRAM_PORTB_WE(3 downto 0)
    );
demo_1_0: component demo_1_design_demo_1_0_0
     port map (
      MNA_0_ARADDR(31 downto 0) => axi_vip_0_M_AXI_ARADDR(31 downto 0),
      MNA_0_ARPROT(2 downto 0) => axi_vip_0_M_AXI_ARPROT(2 downto 0),
      MNA_0_ARREADY => axi_vip_0_M_AXI_ARREADY,
      MNA_0_ARVALID => axi_vip_0_M_AXI_ARVALID,
      MNA_0_AWADDR(31 downto 0) => axi_vip_0_M_AXI_AWADDR(31 downto 0),
      MNA_0_AWPROT(2 downto 0) => axi_vip_0_M_AXI_AWPROT(2 downto 0),
      MNA_0_AWREADY => axi_vip_0_M_AXI_AWREADY,
      MNA_0_AWVALID => axi_vip_0_M_AXI_AWVALID,
      MNA_0_BREADY => axi_vip_0_M_AXI_BREADY,
      MNA_0_BRESP(1 downto 0) => axi_vip_0_M_AXI_BRESP(1 downto 0),
      MNA_0_BVALID => axi_vip_0_M_AXI_BVALID,
      MNA_0_RDATA(31 downto 0) => axi_vip_0_M_AXI_RDATA(31 downto 0),
      MNA_0_RREADY => axi_vip_0_M_AXI_RREADY,
      MNA_0_RRESP(1 downto 0) => axi_vip_0_M_AXI_RRESP(1 downto 0),
      MNA_0_RVALID => axi_vip_0_M_AXI_RVALID,
      MNA_0_WDATA(31 downto 0) => axi_vip_0_M_AXI_WDATA(31 downto 0),
      MNA_0_WREADY => axi_vip_0_M_AXI_WREADY,
      MNA_0_WSTRB(3 downto 0) => axi_vip_0_M_AXI_WSTRB(3 downto 0),
      MNA_0_WVALID => axi_vip_0_M_AXI_WVALID,
      MNA_1_ARADDR(31 downto 0) => axi_vip_1_M_AXI_ARADDR(31 downto 0),
      MNA_1_ARPROT(2 downto 0) => axi_vip_1_M_AXI_ARPROT(2 downto 0),
      MNA_1_ARREADY => axi_vip_1_M_AXI_ARREADY,
      MNA_1_ARVALID => axi_vip_1_M_AXI_ARVALID,
      MNA_1_AWADDR(31 downto 0) => axi_vip_1_M_AXI_AWADDR(31 downto 0),
      MNA_1_AWPROT(2 downto 0) => axi_vip_1_M_AXI_AWPROT(2 downto 0),
      MNA_1_AWREADY => axi_vip_1_M_AXI_AWREADY,
      MNA_1_AWVALID => axi_vip_1_M_AXI_AWVALID,
      MNA_1_BREADY => axi_vip_1_M_AXI_BREADY,
      MNA_1_BRESP(1 downto 0) => axi_vip_1_M_AXI_BRESP(1 downto 0),
      MNA_1_BVALID => axi_vip_1_M_AXI_BVALID,
      MNA_1_RDATA(31 downto 0) => axi_vip_1_M_AXI_RDATA(31 downto 0),
      MNA_1_RREADY => axi_vip_1_M_AXI_RREADY,
      MNA_1_RRESP(1 downto 0) => axi_vip_1_M_AXI_RRESP(1 downto 0),
      MNA_1_RVALID => axi_vip_1_M_AXI_RVALID,
      MNA_1_WDATA(31 downto 0) => axi_vip_1_M_AXI_WDATA(31 downto 0),
      MNA_1_WREADY => axi_vip_1_M_AXI_WREADY,
      MNA_1_WSTRB(3 downto 0) => axi_vip_1_M_AXI_WSTRB(3 downto 0),
      MNA_1_WVALID => axi_vip_1_M_AXI_WVALID,
      SNA_0_ARADDR(31 downto 0) => demo_1_0_SNA_0_ARADDR(31 downto 0),
      SNA_0_ARPROT(2 downto 0) => demo_1_0_SNA_0_ARPROT(2 downto 0),
      SNA_0_ARREADY => demo_1_0_SNA_0_ARREADY,
      SNA_0_ARVALID => demo_1_0_SNA_0_ARVALID,
      SNA_0_AWADDR(31 downto 0) => demo_1_0_SNA_0_AWADDR(31 downto 0),
      SNA_0_AWPROT(2 downto 0) => demo_1_0_SNA_0_AWPROT(2 downto 0),
      SNA_0_AWREADY => demo_1_0_SNA_0_AWREADY,
      SNA_0_AWVALID => demo_1_0_SNA_0_AWVALID,
      SNA_0_BREADY => demo_1_0_SNA_0_BREADY,
      SNA_0_BRESP(1 downto 0) => demo_1_0_SNA_0_BRESP(1 downto 0),
      SNA_0_BVALID => demo_1_0_SNA_0_BVALID,
      SNA_0_RDATA(31 downto 0) => demo_1_0_SNA_0_RDATA(31 downto 0),
      SNA_0_RREADY => demo_1_0_SNA_0_RREADY,
      SNA_0_RRESP(1 downto 0) => demo_1_0_SNA_0_RRESP(1 downto 0),
      SNA_0_RVALID => demo_1_0_SNA_0_RVALID,
      SNA_0_WDATA(31 downto 0) => demo_1_0_SNA_0_WDATA(31 downto 0),
      SNA_0_WREADY => demo_1_0_SNA_0_WREADY,
      SNA_0_WSTRB(3 downto 0) => demo_1_0_SNA_0_WSTRB(3 downto 0),
      SNA_0_WVALID => demo_1_0_SNA_0_WVALID,
      SNA_1_ARADDR(31 downto 0) => demo_1_0_SNA_1_ARADDR(31 downto 0),
      SNA_1_ARPROT(2 downto 0) => demo_1_0_SNA_1_ARPROT(2 downto 0),
      SNA_1_ARREADY => demo_1_0_SNA_1_ARREADY,
      SNA_1_ARVALID => demo_1_0_SNA_1_ARVALID,
      SNA_1_AWADDR(31 downto 0) => demo_1_0_SNA_1_AWADDR(31 downto 0),
      SNA_1_AWPROT(2 downto 0) => demo_1_0_SNA_1_AWPROT(2 downto 0),
      SNA_1_AWREADY => demo_1_0_SNA_1_AWREADY,
      SNA_1_AWVALID => demo_1_0_SNA_1_AWVALID,
      SNA_1_BREADY => demo_1_0_SNA_1_BREADY,
      SNA_1_BRESP(1 downto 0) => demo_1_0_SNA_1_BRESP(1 downto 0),
      SNA_1_BVALID => demo_1_0_SNA_1_BVALID,
      SNA_1_RDATA(31 downto 0) => demo_1_0_SNA_1_RDATA(31 downto 0),
      SNA_1_RREADY => demo_1_0_SNA_1_RREADY,
      SNA_1_RRESP(1 downto 0) => demo_1_0_SNA_1_RRESP(1 downto 0),
      SNA_1_RVALID => demo_1_0_SNA_1_RVALID,
      SNA_1_WDATA(31 downto 0) => demo_1_0_SNA_1_WDATA(31 downto 0),
      SNA_1_WREADY => demo_1_0_SNA_1_WREADY,
      SNA_1_WSTRB(3 downto 0) => demo_1_0_SNA_1_WSTRB(3 downto 0),
      SNA_1_WVALID => demo_1_0_SNA_1_WVALID,
      clk => clk_0_1,
      rst => rst_0_1
    );
end STRUCTURE;
