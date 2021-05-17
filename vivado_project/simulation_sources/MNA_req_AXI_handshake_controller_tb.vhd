----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/04/2021 12:05:41 PM
-- Design Name: AXI_Network_Adapter
-- Module Name: MNA_req_AXI_handshake_controller_tb - Simulation
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
-- Revision 0.1 - 2021-05-04 - Mrkovic, Ramljak
-- Additional Comments: Prva verzija simulacije MNA_req_AXI_handshake_controllera
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

library noc_lib;
use noc_lib.component_declarations.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity MNA_req_AXI_handshake_controller_tb is
--  Port ( );
end MNA_req_AXI_handshake_controller_tb;

architecture Simulation of MNA_req_AXI_handshake_controller_tb is

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal rst_sim : std_logic;
    
    signal AWADDR_sim : std_logic_vector(31 downto 0);
    signal AWPROT_sim : std_logic_vector(2 downto 0);
    signal AWVALID_sim : std_logic;
    signal AWREADY_sim : std_logic;
    
    signal WDATA_sim : std_logic_vector(31 downto 0);
    signal WSTRB_sim : std_logic_vector(3 downto 0);
    signal WVALID_sim : std_logic;
    signal WREADY_sim : std_logic;
    
    signal ARADDR_sim : std_logic_vector(31 downto 0);
    signal ARPROT_sim : std_logic_vector(2 downto 0);
    signal ARVALID_sim : std_logic;
    signal ARREADY_sim : std_logic;
    
    signal op_write_sim : std_logic;
    signal op_read_sim : std_logic;
    
    signal addr_sim : std_logic_vector(31 downto 0);
    signal data_sim : std_logic_vector(31 downto 0);
    signal prot_sim : std_logic_vector(2 downto 0);
    signal strb_sim : std_logic_vector(3 downto 0);
    
    signal buffer_write_ready_sim : std_logic;
    signal buffer_read_ready_sim : std_logic;
    
    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test)
    uut: MNA_req_AXI_handshake_controller
    
        port map(
            clk => clk_sim,
            rst => rst_sim, 
            
            -- AXI WRITE ADDRESS CHANNEL
            AWADDR => AWADDR_sim,
            AWPROT => AWPROT_sim,
            AWVALID => AWVALID_sim,
            AWREADY => AWREADY_sim,
            
            -- AXI WRITE DATA CHANNEL
            WDATA => WDATA_sim,
            WSTRB => WSTRB_sim,
            WVALID => WVALID_sim,
            WREADY => WREADY_sim,
            
            -- AXI READ ADDRESS CHANNEL
            ARADDR => ARADDR_sim,
            ARPROT => ARPROT_sim,
            ARVALID => ARVALID_sim,
            ARREADY => ARREADY_sim,
            
            -- MNA_req_buffer_controller
            op_write => op_write_sim,
            op_read => op_read_sim,
            
            addr => addr_sim,
            data => data_sim,
            prot => prot_sim,
            strb => strb_sim,
            
            -- AXI_to_noc_FIFO_buffer
            buffer_write_ready => buffer_write_ready_sim,
            buffer_read_ready => buffer_read_ready_sim
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
        AWADDR_sim <= (others => '0');
        AWPROT_sim <= (others => '0');
        AWVALID_sim <= '0';
        
        WDATA_sim <= (others => '0');
        WSTRB_sim <= (others => '0');
        WVALID_sim <= '0';
        
        ARADDR_sim <= (others => '0');
        ARPROT_sim <= (others => '0');
        ARVALID_sim <= '0';
        
        buffer_write_ready_sim <= '0';
        buffer_read_ready_sim <= '0';
        -- < Inicijalne postavke ulaznih signala
        
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for (10 * clk_period);
        
        -- Reset neaktivan
        rst_sim <= '1';
        
        wait for (2.1 * clk_period);
        
        buffer_read_ready_sim <= '1';
        
        wait for (3 * clk_period);
        
        ARADDR_sim <= X"12345678";
        ARPROT_sim <= "111";
        ARVALID_sim <= '1';
        
        wait for (2 * clk_period);
        
        ARADDR_sim <= (others => '0');
        ARPROT_sim <= (others => '0');
        ARVALID_sim <= '0';
        
        wait for (5 * clk_period);
        
        buffer_write_ready_sim <= '1';
        
        wait for clk_period;
        
        AWADDR_sim <= X"87654321";
        AWPROT_sim <= "010";
        AWVALID_sim <= '1';
        
        WDATA_sim <= X"12344321";
        WSTRB_sim <= "0101";
        WVALID_sim <= '1';
        
        wait for (2 * clk_period);
        
        AWADDR_sim <= (others => '0');
        AWPROT_sim <= (others => '0');
        AWVALID_sim <= '0';
        
        WDATA_sim <= (others => '0');
        WSTRB_sim <= (others => '0');
        WVALID_sim <= '0';
        
        buffer_write_ready_sim <= '0';
        buffer_read_ready_sim <= '0';
        
        wait for (4 * clk_period);
        
        AWADDR_sim <= X"22222222";
        AWPROT_sim <= "101";
        AWVALID_sim <= '1';
        
        WDATA_sim <= X"44444444";
        WSTRB_sim <= "1010";
        WVALID_sim <= '1';
        
        wait for clk_period;
        
        buffer_write_ready_sim <= '1';
        
        wait for (2 * clk_period);
        
        AWADDR_sim <= (others => '0');
        AWPROT_sim <= (others => '0');
        AWVALID_sim <= '0';
        
        WDATA_sim <= (others => '0');
        WSTRB_sim <= (others => '0');
        WVALID_sim <= '0';
        
        buffer_write_ready_sim <= '0';
        
        wait for (3 * clk_period);
        
        ARADDR_sim <= X"12345678";
        ARPROT_sim <= "111";
        ARVALID_sim <= '1';
        
        wait for (4 * clk_period);
        
        buffer_read_ready_sim <= '1';
        
        wait for (2 * clk_period);
        
        ARADDR_sim <= (others => '0');
        ARPROT_sim <= (others => '0');
        ARVALID_sim <= '0';
        
        buffer_read_ready_sim <= '0';
        
        wait;
    
    end process;
    
end Simulation;