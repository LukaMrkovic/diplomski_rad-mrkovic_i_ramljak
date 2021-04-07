----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 07.04.2021 11:25:34
-- Design Name: NoC Router
-- Module Name: router_branch_tb - Simulation
-- Project Name: NoC Router
-- Target Devices: zc706
-- Tool Versions: 2020.2
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- Revision 0.1 - 2021-04-07 - Mrkovic i Ramljak
-- Additional Comments: Prva verzija simulacije router_branch modula
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

library noc_lib;
use noc_lib.router_config.ALL;
use noc_lib.component_declarations.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity router_branch_tb is
--  Port ( );
end router_branch_tb;

architecture Simulation of router_branch_tb is

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal rst_sim : std_logic;

    signal data_in_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_valid_sim : std_logic;
    signal data_in_vc_busy_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_in_vc_credits_sim : std_logic_vector(const_vc_num - 1 downto 0);

    signal data_out_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_valid_sim : std_logic;
    signal data_out_vc_busy_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_out_vc_credits_sim : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal arb_vc_busy_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal arb_credit_counter_sim : credit_counter_vector(const_vc_num - 1 downto 0);
    
    signal req_sim : destination_dir_vector(const_vc_num - 1 downto 0);
    signal head_sim : std_logic_vector (const_vc_num - 1 downto 0 );
    signal tail_sim : std_logic_vector (const_vc_num - 1 downto 0 );
    
    signal grant_sim : std_logic_vector (const_vc_num - 1 downto 0);
    signal vc_downstream_sim : std_logic_vector (const_vc_num - 1 downto 0);
    
    signal crossbar_data_sim : std_logic_vector (const_flit_size - 1 downto 0);
    signal crossbar_data_valid_sim : std_logic;

    signal int_data_out_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal int_data_out_valid_sim : std_logic;





    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test)
    uut_router_branch : router_branch
        
        generic map(
            vc_num => const_vc_num,
            mesh_size_x => const_mesh_size_x,
            mesh_size_y => const_mesh_size_y,
            address_size => const_address_size,
            payload_size => const_payload_size,
            flit_size => const_flit_size,
            buffer_size => const_buffer_size,
            local_address_x => const_default_address_x,
            local_address_y => const_default_address_y,
            clock_divider => const_clock_divider,
            diagonal_pref => const_default_diagonal_pref
        )
        
        port map(
            clk => clk_sim,
            rst => rst_sim,
               
            data_in => data_in_sim,
            data_in_valid => data_in_valid_sim,
            data_in_vc_busy => data_in_vc_busy_sim,
            data_in_vc_credits => data_in_vc_credits_sim,
            
            data_out => data_out_sim,
            data_out_valid => data_out_valid_sim,
            data_out_vc_busy => data_out_vc_busy_sim,
            data_out_vc_credits => data_out_vc_credits_sim,
            
            arb_vc_busy => arb_vc_busy_sim,
            arb_credit_counter => arb_credit_counter_sim,
                    
            req => req_sim,
            head => head_sim,
            tail => tail_sim,
            
            grant => grant_sim,
            vc_downstream => vc_downstream_sim,
            
            crossbar_data => crossbar_data_sim,
            crossbar_data_valid => crossbar_data_valid_sim,
            
            int_data_out => int_data_out_sim,
            int_data_out_valid => int_data_out_valid_sim
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
    
        -- Inicijalne postavke ulaznih signala        
        data_out_vc_busy_sim <= (others => '0');
        data_out_vc_credits_sim <= (others => '0');

        data_in_sim <= (others => '0');
        data_in_valid_sim <= '0';
        
        grant_sim <= (others => '0');
        vc_downstream_sim <= (others => '0');
        
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for (10 * clk_period);
        
        -- Reset neaktivan
        rst_sim <= '1';
        
        wait for (4.1 * clk_period);
        
        -- Head, vc1, dest: 0010-0010
        data_in_sim <= X"92211111111";
        data_in_valid_sim <= '1';
        
        wait for clk_period;
        
        -- Smireni ulazni signal
        data_in_sim <= (others => '0');
        data_in_valid_sim <= '0';
        
        wait for (3 * clk_period);
        
        -- Tail, vc1, dest: 0010-0010
        data_in_sim <= X"52233333333";
        data_in_valid_sim <= '1';
        
        wait for clk_period;
        
        -- Smireni ulazni signal
        data_in_sim <= (others => '0');
        data_in_valid_sim <= '0';
        
        wait for (3 * clk_period);
        
        -- Head, vc2, dest: 0001-0100
        data_in_sim <= X"A1422222222";
        data_in_valid_sim <= '1';
        
        wait for clk_period;
        
        -- Smireni ulazni signal
        data_in_sim <= (others => '0');
        data_in_valid_sim <= '0';
        
        wait for (5.9 * clk_period);
        
        -- Dozvola za slanje vc1 na crossbar
        -- Nizvodni vc 10
        grant_sim <= B"01";
        vc_downstream_sim <= B"10";
        
        wait for (4 * clk_period);
        
        -- Dozvola za slanje vc2 na crossbar
        -- Nizvodni vc 01
        grant_sim <= B"10";
        vc_downstream_sim <= B"01";
        
        wait for (4 * clk_period);
        
        -- Dozvola za slanje vc1 na crossbar
        -- Nizvodni vc 10
        grant_sim <= B"01";
        vc_downstream_sim <= B"10";
        
        wait for (4 * clk_period);
        
        grant_sim <= (others => '0');
        vc_downstream_sim <= (others => '0');

        wait;
        
    end process;
    
end Simulation;
