----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 07.04.2021 11:51:59
-- Design Name: NoC Router
-- Module Name: router_branch_cascade_tb - Simulation
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
-- Additional Comments: Prva verzija simulacije kaskade 3 routera
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

entity router_branch_cascade_tb is
--  Port ( );
end router_branch_cascade_tb;

architecture Simulation of router_branch_cascade_tb is

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal rst_sim : std_logic;
    
    -- Router 1 ulazi
    signal data_in_1_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_valid_1_sim : std_logic;
    signal data_in_vc_busy_1_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_in_vc_credits_1_sim : std_logic_vector(const_vc_num - 1 downto 0);

    -- Router 1 out > Router 2 in
    signal data_1_to_2_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_1_to_2_sim : std_logic;
    signal data_vc_busy_1_to_2_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_vc_credits_1_to_2_sim : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- Router 2 out > Router 3 in
    signal data_2_to_3_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_2_to_3_sim : std_logic;
    signal data_vc_busy_2_to_3_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_vc_credits_2_to_3_sim : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- Router 3 izlazi
    signal data_out_3_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_valid_3_sim : std_logic;
    signal data_out_vc_busy_3_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_out_vc_credits_3_sim : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- Router 1 prespoj crossbar > int_data_out
    signal crossbar_to_int_data_1_sim : std_logic_vector (const_flit_size - 1 downto 0);
    signal crossbar_to_int_data_valid_1_sim : std_logic;
    
    -- Router 2 prespoj crossbar > int_data_out
    signal crossbar_to_int_data_2_sim : std_logic_vector (const_flit_size - 1 downto 0);
    signal crossbar_to_int_data_valid_2_sim : std_logic;
    
    -- Router 3 prespoj crossbar > int_data_out
    signal crossbar_to_int_data_3_sim : std_logic_vector (const_flit_size - 1 downto 0);
    signal crossbar_to_int_data_valid_3_sim : std_logic;
    
    -- Router 1 arbiter signali
    signal arb_vc_busy_1_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal arb_credit_counter_1_sim : credit_counter_vector(const_vc_num - 1 downto 0);
    
    signal req_1_sim : destination_dir_vector(const_vc_num - 1 downto 0);
    signal head_1_sim : std_logic_vector (const_vc_num - 1 downto 0 );
    signal tail_1_sim : std_logic_vector (const_vc_num - 1 downto 0 );
    
    signal grant_1_sim : std_logic_vector (const_vc_num - 1 downto 0);
    signal vc_downstream_1_sim : std_logic_vector (const_vc_num - 1 downto 0);
    
    -- Router 2 arbiter signali
    signal arb_vc_busy_2_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal arb_credit_counter_2_sim : credit_counter_vector(const_vc_num - 1 downto 0);
    
    signal req_2_sim : destination_dir_vector(const_vc_num - 1 downto 0);
    signal head_2_sim : std_logic_vector (const_vc_num - 1 downto 0 );
    signal tail_2_sim : std_logic_vector (const_vc_num - 1 downto 0 );
    
    signal grant_2_sim : std_logic_vector (const_vc_num - 1 downto 0);
    signal vc_downstream_2_sim : std_logic_vector (const_vc_num - 1 downto 0);
    
    -- Router 3 arbiter signali
    signal arb_vc_busy_3_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal arb_credit_counter_3_sim : credit_counter_vector(const_vc_num - 1 downto 0);
    
    signal req_3_sim : destination_dir_vector(const_vc_num - 1 downto 0);
    signal head_3_sim : std_logic_vector (const_vc_num - 1 downto 0 );
    signal tail_3_sim : std_logic_vector (const_vc_num - 1 downto 0 );
    
    signal grant_3_sim : std_logic_vector (const_vc_num - 1 downto 0);
    signal vc_downstream_3_sim : std_logic_vector (const_vc_num - 1 downto 0);
    
    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test)
    uut_router_1_branch : router_branch
        
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
               
            data_in => data_in_1_sim,
            data_in_valid => data_in_valid_1_sim,
            data_in_vc_busy => data_in_vc_busy_1_sim,
            data_in_vc_credits => data_in_vc_credits_1_sim,
            
            data_out => data_1_to_2_sim,
            data_out_valid => data_valid_1_to_2_sim,
            data_out_vc_busy => data_vc_busy_1_to_2_sim,
            data_out_vc_credits => data_vc_credits_1_to_2_sim,
            
            arb_vc_busy => arb_vc_busy_1_sim,
            arb_credit_counter => arb_credit_counter_1_sim,
                    
            req => req_1_sim,
            head => head_1_sim,
            tail => tail_1_sim,
            
            grant => grant_1_sim,
            vc_downstream => vc_downstream_1_sim,
            
            crossbar_data => crossbar_to_int_data_1_sim,
            crossbar_data_valid => crossbar_to_int_data_valid_1_sim,
            
            int_data_out => crossbar_to_int_data_1_sim,
            int_data_out_valid => crossbar_to_int_data_valid_1_sim
        );
        
    -- Komponenta koja se testira (Unit Under Test)
    uut_router_2_branch : router_branch
        
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
               
            data_in => data_1_to_2_sim,
            data_in_valid => data_valid_1_to_2_sim,
            data_in_vc_busy => data_vc_busy_1_to_2_sim,
            data_in_vc_credits => data_vc_credits_1_to_2_sim,
            
            data_out => data_2_to_3_sim,
            data_out_valid => data_valid_2_to_3_sim,
            data_out_vc_busy => data_vc_busy_2_to_3_sim,
            data_out_vc_credits => data_vc_credits_2_to_3_sim,
            
            arb_vc_busy => arb_vc_busy_2_sim,
            arb_credit_counter => arb_credit_counter_2_sim,
                    
            req => req_2_sim,
            head => head_2_sim,
            tail => tail_2_sim,
            
            grant => grant_2_sim,
            vc_downstream => vc_downstream_2_sim,
            
            crossbar_data => crossbar_to_int_data_2_sim,
            crossbar_data_valid => crossbar_to_int_data_valid_2_sim,
            
            int_data_out => crossbar_to_int_data_2_sim,
            int_data_out_valid => crossbar_to_int_data_valid_2_sim
        );
        
    -- Komponenta koja se testira (Unit Under Test)
    uut_router_3_branch : router_branch
        
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
               
            data_in => data_2_to_3_sim,
            data_in_valid => data_valid_2_to_3_sim,
            data_in_vc_busy => data_vc_busy_2_to_3_sim,
            data_in_vc_credits => data_vc_credits_2_to_3_sim,
            
            data_out => data_out_3_sim,
            data_out_valid => data_out_valid_3_sim,
            data_out_vc_busy => data_out_vc_busy_3_sim,
            data_out_vc_credits => data_out_vc_credits_3_sim,
            
            arb_vc_busy => arb_vc_busy_3_sim,
            arb_credit_counter => arb_credit_counter_3_sim,
                    
            req => req_3_sim,
            head => head_3_sim,
            tail => tail_3_sim,
            
            grant => grant_3_sim,
            vc_downstream => vc_downstream_3_sim,
            
            crossbar_data => crossbar_to_int_data_3_sim,
            crossbar_data_valid => crossbar_to_int_data_valid_3_sim,
            
            int_data_out => crossbar_to_int_data_3_sim,
            int_data_out_valid => crossbar_to_int_data_valid_3_sim
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
        data_in_1_sim <= (others => '0');
        data_in_valid_1_sim <= '0';
        
        data_out_vc_busy_3_sim <= (others => '0');
        data_out_vc_credits_3_sim <= (others => '0');
        
        grant_1_sim <= (others => '0');
        vc_downstream_1_sim <= (others => '0');
        
        grant_2_sim <= (others => '0');
        vc_downstream_2_sim <= (others => '0');
        
        grant_3_sim <= (others => '0');
        vc_downstream_3_sim <= (others => '0');
        
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for (10 * clk_period);
        
        -- Reset neaktivan
        rst_sim <= '1';
        
        wait for (6.1 * clk_period);
        
        -- Head, vc1, dest: 0010-0010
        data_in_1_sim <= X"92211111111";
        data_in_valid_1_sim <= '1';
        
        wait for clk_period;
        
        -- Smireni ulazni signal
        data_in_1_sim <= (others => '0');
        data_in_valid_1_sim <= '0';
        
        wait for (5 * clk_period);
        
        -- Tail, vc1, dest: 0010-0010
        data_in_1_sim <= X"52233333333";
        data_in_valid_1_sim <= '1';
        
        wait for clk_period;
        
        -- Smireni ulazni signal
        data_in_1_sim <= (others => '0');
        data_in_valid_1_sim <= '0';
        
        wait for (3.9 * clk_period);
        
        -- Dozvola za slanje vc1 na crossbar
        -- Nizvodni vc 10
        grant_1_sim <= B"01";
        vc_downstream_1_sim <= B"10";
        
        wait for (12 * clk_period);
        
        grant_1_sim <= (others => '0');
        vc_downstream_1_sim <= (others => '0');
        
        -- Dozvola za slanje vc2 na crossbar
        -- Nizvodni vc 01
        grant_2_sim <= B"10";
        vc_downstream_2_sim <= B"01";
        
        wait for (12 * clk_period);
        
        grant_2_sim <= (others => '0');
        vc_downstream_2_sim <= (others => '0');
        
        -- Dozvola za slanje vc1 na crossbar
        -- Nizvodni vc 10
        grant_3_sim <= B"01";
        vc_downstream_3_sim <= B"10";
        
        wait for (12 * clk_period);
        
        grant_3_sim <= (others => '0');
        vc_downstream_3_sim <= (others => '0');
    
        wait;
        
    end process;

end Simulation;
