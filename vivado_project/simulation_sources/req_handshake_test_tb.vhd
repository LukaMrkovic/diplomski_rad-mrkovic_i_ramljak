----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 13.05.2021 13:35:23
-- Design Name: AXI_Network_Adapter
-- Module Name: req_handshake_test_tb - Simulation
-- Project Name: NoC_Router
-- Target Devices: zc706
-- Tool Versions: 2020.2
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- Revision 0.1 - 2021-05-13 - Mrkovic, Ramljak
-- Additional Comments: Test potpunosti handshakea
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

library noc_lib;
use noc_lib.router_config.ALL;
use noc_lib.AXI_network_adapter_config.ALL;
use noc_lib.component_declarations.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity req_handshake_test_tb is
--  Port ( );
end req_handshake_test_tb;

architecture Simulation of req_handshake_test_tb is

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal rst_sim : std_logic;
    
    -- AXI WRITE ADDRESS CHANNEL 
    signal AWADDR_sim : std_logic_vector(31 downto 0);
    signal AWPROT_sim : std_logic_vector(2 downto 0);
    signal AWVALID_sim : std_logic;
    signal AWREADY_sim : std_logic;
    
    -- AXI WRITE DATA CHANNEL
    signal WDATA_sim : std_logic_vector(31 downto 0);
    signal WSTRB_sim : std_logic_vector(3 downto 0);
    signal WVALID_sim : std_logic;
    signal WREADY_sim : std_logic;
    
    -- AXI READ ADDRESS CHANNEL
    signal ARADDR_sim : std_logic_vector(31 downto 0);
    signal ARPROT_sim : std_logic_vector(2 downto 0);
    signal ARVALID_sim : std_logic;
    signal ARREADY_sim : std_logic;
    
    -- MNA_req_AXI_handshake_controller SIGNALI
    signal MNA_op_write_sim : std_logic;
    signal MNA_op_read_sim : std_logic;
        
    signal MNA_buffer_read_ready_sim : std_logic;
    signal MNA_buffer_write_ready_sim : std_logic;
        
    signal MNA_addr_sim : std_logic_vector(31 downto 0);
    signal MNA_data_sim : std_logic_vector(31 downto 0);
    signal MNA_prot_sim : std_logic_vector(2 downto 0);
    signal MNA_strb_sim : std_logic_vector(3 downto 0);
    
    -- SNA_req_AXI_handshake_controller SIGNALI
    signal SNA_op_write_sim : std_logic;
    signal SNA_op_read_sim : std_logic;
        
    signal SNA_buffer_read_ready_sim : std_logic;
    signal SNA_buffer_write_ready_sim : std_logic;
        
    signal SNA_addr_sim : std_logic_vector(31 downto 0);
    signal SNA_data_sim : std_logic_vector(31 downto 0);
    signal SNA_prot_sim : std_logic_vector(2 downto 0);
    signal SNA_strb_sim : std_logic_vector(3 downto 0);
    
    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test) - MNA_req_AXI_handshake_controller
    uut_1 : MNA_req_AXI_handshake_controller
    
        port map(
            clk => clk_sim,
            rst => rst_sim, 
              
            AWADDR => AWADDR_sim,
            AWVALID => AWVALID_sim,
            AWREADY => AWREADY_sim,
            
            WDATA => WDATA_sim,
            WVALID => WVALID_sim,
            WREADY => WREADY_sim,
            
            AWPROT => AWPROT_sim,
            WSTRB => WSTRB_sim,
            
            ARADDR => ARADDR_sim,
            ARVALID => ARVALID_sim,
            ARREADY => ARREADY_sim,
            
            ARPROT => ARPROT_sim,
            
            op_write => MNA_op_write_sim,
            op_read => MNA_op_read_sim,
            
            buffer_read_ready => MNA_buffer_read_ready_sim,
            buffer_write_ready => MNA_buffer_write_ready_sim,
            
            addr => MNA_addr_sim,
            data => MNA_data_sim,
            prot => MNA_prot_sim,
            strb => MNA_strb_sim
        );
        
    -- Komponenta koja se testira (Unit Under Test) - SNA_req_AXI_handshake_controller
    uut_2 : SNA_req_AXI_handshake_controller
    
        port map(
            clk => clk_sim,
            rst => rst_sim, 
              
            AWADDR => AWADDR_sim,
            AWVALID => AWVALID_sim,
            AWREADY => AWREADY_sim,
            
            WDATA => WDATA_sim,
            WVALID => WVALID_sim,
            WREADY => WREADY_sim,
            
            AWPROT => AWPROT_sim,
            WSTRB => WSTRB_sim,
            
            ARADDR => ARADDR_sim,
            ARVALID => ARVALID_sim,
            ARREADY => ARREADY_sim,
            
            ARPROT => ARPROT_sim,
            
            op_write => SNA_op_write_sim,
            op_read => SNA_op_read_sim,
            
            buffer_read_ready => SNA_buffer_read_ready_sim,
            buffer_write_ready => SNA_buffer_write_ready_sim,
            
            addr => SNA_addr_sim,
            data => SNA_data_sim,
            prot => SNA_prot_sim,
            strb => SNA_strb_sim
        );
        
    -- clk proces
    clk_process : process
    
    begin
    
        clk_sim <= '1';
        wait for clk_period / 2;
        clk_sim <= '0';
        wait for clk_period / 2;
        
    end process;
    
    -- stimulirajuci proces
    stim_process : process
    
    begin
    
        MNA_buffer_read_ready_sim <= '1';
        MNA_buffer_write_ready_sim <= '1';
        
        SNA_op_write_sim <= '0';
        SNA_op_read_sim <= '0';
            
        SNA_buffer_read_ready_sim <= '1';
        SNA_buffer_write_ready_sim <= '1';
            
        SNA_addr_sim <= (others => '0');
        SNA_data_sim <= (others => '0');
        SNA_prot_sim <= (others => '0');
        SNA_strb_sim <= (others => '0');
        
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for (10 * clk_period);
        
        -- Reset neaktivan
        rst_sim <= '1';
        
        wait for (2.1 * clk_period);
        
        -- > WRITE
        SNA_op_write_sim <= '1';
        SNA_addr_sim <= X"12345678";
        SNA_data_sim <= X"87654321";
        SNA_prot_sim <= "010";
        SNA_strb_sim <= "1111";
        
        wait for clk_period;
        
        SNA_op_write_sim <= '0';
        SNA_addr_sim <= (others => '0');
        SNA_data_sim <= (others => '0');
        SNA_prot_sim <= (others => '0');
        SNA_strb_sim <= (others => '0');
        
        wait for (4 * clk_period);
        
        SNA_op_read_sim <= '1';
        SNA_addr_sim <= X"12344321";
        SNA_prot_sim <= "101";
        
        wait for clk_period;
        
        SNA_op_read_sim <= '0';
        SNA_addr_sim <= (others => '0');
        SNA_prot_sim <= (others => '0');
    
        wait;
    
    end process;

end Simulation;
