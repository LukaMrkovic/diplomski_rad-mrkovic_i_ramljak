----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/04/2021 01:58:06 PM
-- Design Name: AXI_Network_Adapter
-- Module Name: MNA_resp_AXI_handshake_controller_tb - Simulation
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
-- Additional Comments: Prva verzija simulacije MNA_resp_AXI_handshake_controllera
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

entity MNA_resp_AXI_handshake_controller_tb is
--  Port ( );
end MNA_resp_AXI_handshake_controller_tb;

architecture Simulation of MNA_resp_AXI_handshake_controller_tb is

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal rst_sim : std_logic;
    
    signal BREADY_sim : std_logic;
    signal BRESP_sim : std_logic_vector(1 downto 0);
    signal BVALID_sim : std_logic;
            
    signal RREADY_sim : std_logic;
    signal RDATA_sim : std_logic_vector(31 downto 0);
    signal RRESP_sim : std_logic_vector(1 downto 0);
    signal RVALID_sim : std_logic;
            
    signal op_write_sim : std_logic;
    signal op_read_sim : std_logic;
            
    signal data_sim : std_logic_vector(31 downto 0);
    signal resp_sim : std_logic_vector(1 downto 0);
    
    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test)
    uut: MNA_resp_AXI_handshake_controller
    
        port map(
            clk => clk_sim,
            rst => rst_sim, 
              
            BREADY => BREADY_sim,
            BRESP => BRESP_sim,
            BVALID => BVALID_sim,
            
            RREADY => RREADY_sim,
            RDATA => RDATA_sim,
            RRESP => RRESP_sim,
            RVALID => RVALID_sim,
            
            op_write => op_write_sim,
            op_read => op_read_sim,
            
            data => data_sim,
            resp => resp_sim
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
    
        BREADY_sim <= '0';
        
        RREADY_sim <= '0';
        
        op_write_sim <= '0';
        op_read_sim <= '0';
        
        data_sim <= (others => '0');
        resp_sim <= (others => '0');
    
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for (10 * clk_period);
        
        rst_sim <= '1';
        
        wait for (2.1 * clk_period);
        
        BREADY_sim <= '1';
        
        wait for (3 * clk_period);
        
        op_write_sim <= '1';
        
        resp_sim <= "01";
        
        wait for clk_period;
        
        op_write_sim <= '0';
        
        resp_sim <= (others => '0');
        
        wait for clk_period;
        
        BREADY_sim <= '0';
        
        wait for (2 * clk_period);
        
        RREADY_sim <= '1';
        
        wait for (4 * clk_period);
        
        op_read_sim <= '1';
        
        data_sim <= X"12345678";
        resp_sim <= "10";
        
        wait for clk_period;
        
        op_read_sim <= '0';
        
        data_sim <= (others => '0');
        resp_sim <= (others => '0');
        
        wait for clk_period;
        
        RREADY_sim <= '0';
        
        wait for (2*clk_period);
        
        op_write_sim <= '1';
        
        resp_sim <= "11";
        
        wait for clk_period;
        
        op_write_sim <= '0';
        
        resp_sim <= (others => '0');
        
        wait for (2 * clk_period);
        
        BREADY_sim <= '1';
        
        wait for clk_period;
        
        BREADY_sim <= '0';
        
        wait for (3 * clk_period);
        
        op_read_sim <= '1';
        
        data_sim <= X"87654321";
        resp_sim <= "01";
        
        wait for clk_period;
        
        op_read_sim <= '0';
        
        data_sim <= (others => '0');
        resp_sim <= (others => '0');
        
        wait for (3 * clk_period);
        
        RREADY_sim <= '1';
        
        wait for clk_period;
        
        RREADY_sim <= '0';
        
        wait;
    
    end process;

end Simulation;