----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 10.05.2021 12:00:11
-- Design Name: AXI_Network_Adapter
-- Module Name: SNA_req_AXI_handshake_controller_tb - Simulation
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
-- Revision 0.1 - 2021-05-10 - Mrkovic, Ramljak
-- Additional Comments: Prva verzija simulacije SNA_req_AXI_handshake_controllera
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

entity SNA_req_AXI_handshake_controller_tb is
--  Port ( );
end SNA_req_AXI_handshake_controller_tb;

architecture Simulation of SNA_req_AXI_handshake_controller_tb is

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal rst_sim : std_logic; 
                   
    signal AWADDR_sim : std_logic_vector(31 downto 0);
    signal AWVALID_sim : std_logic;
    signal AWREADY_sim : std_logic;
        
    signal WDATA_sim : std_logic_vector(31 downto 0);
    signal WVALID_sim : std_logic;
    signal WREADY_sim : std_logic;
        
    signal AWPROT_sim : std_logic_vector(2 downto 0);
    signal WSTRB_sim : std_logic_vector(3 downto 0);
        
    signal ARADDR_sim : std_logic_vector(31 downto 0);
    signal ARVALID_sim : std_logic;
    signal ARREADY_sim : std_logic;
        
    signal ARPROT_sim : std_logic_vector(2 downto 0);
        
    signal op_write_sim : std_logic;
    signal op_read_sim : std_logic;
        
    signal buffer_read_ready_sim : std_logic;
    signal buffer_write_ready_sim : std_logic;
        
    signal addr_sim : std_logic_vector(31 downto 0);
    signal data_sim : std_logic_vector(31 downto 0);
    signal prot_sim : std_logic_vector(2 downto 0);
    signal strb_sim : std_logic_vector(3 downto 0);
    
    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test)
    uut: SNA_req_AXI_handshake_controller
    
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
            
            op_write => op_write_sim,
            op_read => op_read_sim,
            
            buffer_read_ready => buffer_read_ready_sim,
            buffer_write_ready => buffer_write_ready_sim,
            
            addr => addr_sim,
            data => data_sim,
            prot => prot_sim,
            strb => strb_sim
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
    
        AWREADY_sim <= '0';
        WREADY_sim <= '0';
        ARREADY_sim <= '0';
        
        op_write_sim <= '0';
        op_read_sim <= '0';
        
        buffer_read_ready_sim <= '0';
        buffer_write_ready_sim <= '0';
        
        addr_sim <= (others => '0');
        data_sim <= (others => '0');
        prot_sim <= (others => '0');
        strb_sim <= (others => '0');
    
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for (10 * clk_period);
        
        -- Reset neaktivan
        rst_sim <= '1';
        
        wait for (2.1 * clk_period);
        
        buffer_read_ready_sim <= '1';
        buffer_write_ready_sim <= '1';
        
        wait for (4 * clk_period);
        
        -- > WRITE (no PREWRITE)
        op_write_sim <= '1';
        addr_sim <= X"12345678";
        data_sim <= X"87654321";
        prot_sim <= "010";
        strb_sim <= "1111";
        
        wait for clk_period;
        
        op_write_sim <= '0';
        addr_sim <= (others => '0');
        data_sim <= (others => '0');
        prot_sim <= (others => '0');
        strb_sim <= (others => '0');
        
        wait for clk_period;
        
        AWREADY_sim <= '1';
        WREADY_sim <= '1';
        
        wait for clk_period;
        
        AWREADY_sim <= '0';
        WREADY_sim <= '0';
        -- <
        
        wait for clk_period;
        
        -- > READ (no PREREAD)
        op_read_sim <= '1';
        addr_sim <= X"12344321";
        prot_sim <= "101";
        
        wait for clk_period;
        
        op_read_sim <= '0';
        addr_sim <= (others => '0');
        prot_sim <= (others => '0');
        
        wait for clk_period;
        
        ARREADY_sim <= '1';
        
        wait for clk_period;
        
        ARREADY_sim <= '0';
        -- <
        
        wait for (2 * clk_period);
        
        buffer_read_ready_sim <= '0';
        buffer_write_ready_sim <= '0';
        
        wait for (2 * clk_period);
        
        -- > WRITE (with PREWRITE)
        op_write_sim <= '1';
        addr_sim <= X"12344321";
        data_sim <= X"87655678";
        prot_sim <= "111";
        strb_sim <= "0101";
        
        wait for clk_period;
        
        op_write_sim <= '0';
        addr_sim <= (others => '0');
        data_sim <= (others => '0');
        prot_sim <= (others => '0');
        strb_sim <= (others => '0');
        
        wait for clk_period;
        
        buffer_write_ready_sim <= '1';
        
        wait for (2 * clk_period);
        
        AWREADY_sim <= '1';
        WREADY_sim <= '1';
        
        wait for clk_period;
        
        AWREADY_sim <= '0';
        WREADY_sim <= '0';
        -- <
        
        wait for clk_period;
        
        -- > READ (with PREREAD)
        op_read_sim <= '1';
        addr_sim <= X"12345678";
        prot_sim <= "011";
        
        wait for clk_period;
        
        op_read_sim <= '0';
        addr_sim <= (others => '0');
        prot_sim <= (others => '0');
        
        wait for clk_period;
        
        buffer_read_ready_sim <= '1';
        
        wait for (2 * clk_period);
        
        ARREADY_sim <= '1';
        
        wait for clk_period;
        
        ARREADY_sim <= '0';
        -- <
    
        wait;
    
    end process;

end Simulation;
