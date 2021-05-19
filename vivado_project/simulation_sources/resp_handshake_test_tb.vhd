----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/13/2021 01:35:01 PM
-- Design Name: AXI_Network_Adapter
-- Module Name: resp_handshake_test_tb - Simulation
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
-- Additional Comments: Prva verzija simulacije resp_handshakea
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

entity resp_handshake_test_tb is
--  Port ( );
end resp_handshake_test_tb;

architecture Simulation of resp_handshake_test_tb is

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal rst_sim : std_logic;
    
    signal BRESP_sim : std_logic_vector(1 downto 0);
    signal BVALID_sim : std_logic;
    signal BREADY_sim : std_logic;
    
    signal RDATA_sim : std_logic_vector(31 downto 0);
    signal RRESP_sim : std_logic_vector(1 downto 0);
    signal RVALID_sim : std_logic;
    signal RREADY_sim : std_logic;
    
    signal MNA_op_write_sim : std_logic;
    signal MNA_op_read_sim : std_logic;
    
    signal MNA_data_sim : std_logic_vector(31 downto 0);
    signal MNA_resp_sim : std_logic_vector(1 downto 0);
    
    signal SNA_op_write_sim : std_logic;
    signal SNA_op_read_sim : std_logic;
    
    signal SNA_data_sim : std_logic_vector(31 downto 0);
    signal SNA_resp_sim : std_logic_vector(1 downto 0);
    
    signal SNA_buffer_write_ready_sim : std_logic;
    signal SNA_buffer_read_ready_sim : std_logic;
    
    signal SNA_resp_write_sim : std_logic;
    signal SNA_resp_read_sim : std_logic;
    
    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test)
    uut_1: MNA_resp_AXI_handshake_controller
    
        port map(
            clk => clk_sim,
            rst => rst_sim,
            
            -- AXI WRITE RESPONSE CHANNEL
            BRESP => BRESP_sim,
            BVALID => BVALID_sim,
            BREADY => BREADY_sim,
            
            -- AXI READ RESPONSE CHANNEL
            RDATA => RDATA_sim,
            RRESP => RRESP_sim,
            RVALID => RVALID_sim,
            RREADY => RREADY_sim,
            
            -- MNA_resp_buffer_controller
            op_write => MNA_op_write_sim,
            op_read => MNA_op_read_sim,
            
            data => MNA_data_sim,
            resp => MNA_resp_sim
        );
        
    -- Komponenta koja se testira (Unit Under Test)
    uut_2: SNA_resp_AXI_handshake_controller
    
        port map(
            clk => clk_sim,
            rst => rst_sim,
            
            -- AXI WRITE RESPONSE CHANNEL
            BRESP => BRESP_sim,
            BVALID => BVALID_sim,
            BREADY => BREADY_sim,
            
            -- AXI READ RESPONSE CHANNEL
            RDATA => RDATA_sim,
            RRESP => RRESP_sim,
            RVALID => RVALID_sim,
            RREADY => RREADY_sim,
            
            -- SNA_resp_buffer_controller
            op_write => SNA_op_write_sim,
            op_read => SNA_op_read_sim,
            
            data => SNA_data_sim,
            resp => SNA_resp_sim,
            
            -- AXI_to_noc_FIFO_buffer
            buffer_write_ready => SNA_buffer_write_ready_sim,
            buffer_read_ready => SNA_buffer_read_ready_sim,
            
            -- req_flow (SNA_req_buffer_controller)
            resp_write => SNA_resp_write_sim,
            resp_read => SNA_resp_read_sim
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
    
        -- > Inicijalne postavke ulaznih signala
        MNA_op_write_sim <= '0';
        MNA_op_read_sim <= '0';
        
        MNA_data_sim <= (others => '0');
        MNA_resp_sim <= (others => '0');
        
        SNA_buffer_write_ready_sim <= '0';
        SNA_buffer_read_ready_sim <= '0';
        
        SNA_resp_write_sim <= '0';
        SNA_resp_read_sim <= '0';
        -- < Inicijalne postavke ulaznih signala
        
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for (10 * clk_period);
        
        -- Reset neaktivan
        rst_sim <= '1';
        
        wait for (4.1 * clk_period);
        
        SNA_buffer_write_ready_sim <= '1';
        SNA_buffer_read_ready_sim <= '1';
        
        wait for (4 * clk_period);
        
        SNA_resp_write_sim <= '1';
        
        wait for clk_period;
        
        SNA_resp_write_sim <= '0';
        
        wait for clk_period;
        
        MNA_op_write_sim <= '1';
        
        MNA_data_sim <= (others => '0');
        MNA_resp_sim <= "01";
        
        wait for clk_period;
        
        MNA_op_write_sim <= '0';
        
        wait for (4 * clk_period);
        
        SNA_resp_read_sim <= '1';
        
        wait for clk_period;
        
        SNA_resp_read_sim <= '0';
        
        wait for clk_period;
        
        MNA_op_read_sim <= '1';
        
        MNA_data_sim <= X"12345678";
        MNA_resp_sim <= "10";
        
        wait for clk_period;
        
        MNA_op_read_sim <= '0';
    
        wait;
    
    end process;

end Simulation;