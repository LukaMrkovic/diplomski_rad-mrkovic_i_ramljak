----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 21.04.2021 11:18:44
-- Design Name: NoC Router
-- Module Name: noc_router - Behavioral
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
-- Revision 0.1 - 2021-04-21 - Mrkovic, Ramljak
-- Additional Comments: Prva verzija integriranog noc_routera
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

entity noc_router is
    
    Generic (
        vc_num : integer := const_vc_num;
        mesh_size_x : integer := const_mesh_size_x;
        mesh_size_y : integer := const_mesh_size_y;
        address_size : integer := const_address_size;
        payload_size : integer := const_payload_size;
        flit_size : integer := const_flit_size;
        buffer_size : integer := const_buffer_size;
        local_address_x : std_logic_vector(const_mesh_size_x - 1 downto 0) := const_default_address_x;
        local_address_y : std_logic_vector(const_mesh_size_y - 1 downto 0) := const_default_address_y;
        clock_divider : integer := const_clock_divider;
        diagonal_pref : routing_axis := const_default_diagonal_pref
    );
    
    Port (
        clk : in std_logic;
        rst : in std_logic;
        
        -- ROUTER TO ROUTER INTERFACE
        -- LOCAL
        data_in_local : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid_local : in std_logic;
        data_in_vc_busy_local : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits_local : out std_logic_vector(vc_num - 1 downto 0);
        
        data_out_local : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid_local : out std_logic;
        data_out_vc_busy_local : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits_local : in std_logic_vector(vc_num - 1 downto 0);
        
        -- ROUTER TO ROUTER INTERFACE
        -- NORTH
        data_in_north : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid_north : in std_logic;
        data_in_vc_busy_north : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits_north : out std_logic_vector(vc_num - 1 downto 0);
        
        data_out_north : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid_north : out std_logic;
        data_out_vc_busy_north : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits_north : in std_logic_vector(vc_num - 1 downto 0);
        
        -- ROUTER TO ROUTER INTERFACE
        -- EAST
        data_in_east : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid_east : in std_logic;
        data_in_vc_busy_east : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits_east : out std_logic_vector(vc_num - 1 downto 0);
        
        data_out_east : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid_east : out std_logic;
        data_out_vc_busy_east : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits_east : in std_logic_vector(vc_num - 1 downto 0);
        
        -- ROUTER TO ROUTER INTERFACE
        -- SOUTH
        data_in_south : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid_south : in std_logic;
        data_in_vc_busy_south : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits_south : out std_logic_vector(vc_num - 1 downto 0);
        
        data_out_south : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid_south : out std_logic;
        data_out_vc_busy_south : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits_south : in std_logic_vector(vc_num - 1 downto 0);
        
        -- ROUTER TO ROUTER INTERFACE
        -- WEST
        data_in_west : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid_west : in std_logic;
        data_in_vc_busy_west : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits_west : out std_logic_vector(vc_num - 1 downto 0);
        
        data_out_west : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid_west : out std_logic;
        data_out_vc_busy_west : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits_west : in std_logic_vector(vc_num - 1 downto 0)
    );
    
end noc_router;

architecture Behavioral of noc_router is

    -- INTERNI SIGNALI
    
    -- ROUTER_BRANCH TO CROSSBAR INTERFACE
    -- LOCAL
    signal crossbar_data_local : std_logic_vector (flit_size - 1 downto 0);
    signal crossbar_data_valid_local : std_logic;
         
    signal int_data_out_local : std_logic_vector (flit_size - 1 downto 0);
    signal int_data_out_valid_local : std_logic;
    
    -- ROUTER_BRANCH TO CROSSBAR INTERFACE
    -- NORTH
    signal crossbar_data_north : std_logic_vector (flit_size - 1 downto 0);
    signal crossbar_data_valid_north : std_logic;
         
    signal int_data_out_north : std_logic_vector (flit_size - 1 downto 0);
    signal int_data_out_valid_north : std_logic;
    
    -- ROUTER_BRANCH TO CROSSBAR INTERFACE
    -- EAST
    signal crossbar_data_east : std_logic_vector (flit_size - 1 downto 0);
    signal crossbar_data_valid_east : std_logic;
         
    signal int_data_out_east : std_logic_vector (flit_size - 1 downto 0);
    signal int_data_out_valid_east : std_logic;
    
    -- ROUTER_BRANCH TO CROSSBAR INTERFACE
    -- SOUTH
    signal crossbar_data_south : std_logic_vector (flit_size - 1 downto 0);
    signal crossbar_data_valid_south : std_logic;
         
    signal int_data_out_south : std_logic_vector (flit_size - 1 downto 0);
    signal int_data_out_valid_south : std_logic;
    
    -- ROUTER_BRANCH TO CROSSBAR INTERFACE
    -- WEST
    signal crossbar_data_west : std_logic_vector (flit_size - 1 downto 0);
    signal crossbar_data_valid_west : std_logic;
         
    signal int_data_out_west : std_logic_vector (flit_size - 1 downto 0);
    signal int_data_out_valid_west : std_logic;
    
    -- ROUTER_BRANCH TO ARBITER INTERFACE
    -- LOCAL
    signal arb_vc_busy_local : std_logic_vector(vc_num - 1 downto 0);
    signal arb_credit_counter_local : credit_counter_vector(vc_num - 1 downto 0);
    
    signal req_local : destination_dir_vector(vc_num - 1 downto 0);
    signal head_local : std_logic_vector (vc_num - 1 downto 0 );
    signal tail_local : std_logic_vector (vc_num - 1 downto 0 );
    
    signal grant_local : std_logic_vector (vc_num - 1 downto 0);
    signal vc_downstream_local : std_logic_vector (vc_num - 1 downto 0);
    
    -- ROUTER_BRANCH TO ARBITER INTERFACE
    -- NORTH
    signal arb_vc_busy_north : std_logic_vector(vc_num - 1 downto 0);
    signal arb_credit_counter_north : credit_counter_vector(vc_num - 1 downto 0);
    
    signal req_north : destination_dir_vector(vc_num - 1 downto 0);
    signal head_north : std_logic_vector (vc_num - 1 downto 0 );
    signal tail_north : std_logic_vector (vc_num - 1 downto 0 );
    
    signal grant_north : std_logic_vector (vc_num - 1 downto 0);
    signal vc_downstream_north : std_logic_vector (vc_num - 1 downto 0);
    
    -- ROUTER_BRANCH TO ARBITER INTERFACE
    -- EAST
    signal arb_vc_busy_east : std_logic_vector(vc_num - 1 downto 0);
    signal arb_credit_counter_east : credit_counter_vector(vc_num - 1 downto 0);
    
    signal req_east : destination_dir_vector(vc_num - 1 downto 0);
    signal head_east : std_logic_vector (vc_num - 1 downto 0 );
    signal tail_east : std_logic_vector (vc_num - 1 downto 0 );
    
    signal grant_east : std_logic_vector (vc_num - 1 downto 0);
    signal vc_downstream_east : std_logic_vector (vc_num - 1 downto 0);
    
    -- ROUTER_BRANCH TO ARBITER INTERFACE
    -- SOUTH
    signal arb_vc_busy_south : std_logic_vector(vc_num - 1 downto 0);
    signal arb_credit_counter_south : credit_counter_vector(vc_num - 1 downto 0);
    
    signal req_south : destination_dir_vector(vc_num - 1 downto 0);
    signal head_south : std_logic_vector (vc_num - 1 downto 0 );
    signal tail_south : std_logic_vector (vc_num - 1 downto 0 );
    
    signal grant_south : std_logic_vector (vc_num - 1 downto 0);
    signal vc_downstream_south : std_logic_vector (vc_num - 1 downto 0);
    
    -- ROUTER_BRANCH TO ARBITER INTERFACE
    -- WEST
    signal arb_vc_busy_west : std_logic_vector(vc_num - 1 downto 0);
    signal arb_credit_counter_west : credit_counter_vector(vc_num - 1 downto 0);
    
    signal req_west : destination_dir_vector(vc_num - 1 downto 0);
    signal head_west : std_logic_vector (vc_num - 1 downto 0 );
    signal tail_west : std_logic_vector (vc_num - 1 downto 0 );
    
    signal grant_west : std_logic_vector (vc_num - 1 downto 0);
    signal vc_downstream_west : std_logic_vector (vc_num - 1 downto 0);
    
    -- ARBITER TO CROSSBAR INTERFACE
    signal select_vector_local : std_logic_vector(4 downto 0);
    signal select_vector_north : std_logic_vector(4 downto 0);
    signal select_vector_east : std_logic_vector(4 downto 0);
    signal select_vector_south : std_logic_vector(4 downto 0);
    signal select_vector_west : std_logic_vector(4 downto 0);

begin

    -- router_branch KOMPONENTA - LOCAL
    router_branch_local : router_branch
        
        generic map(
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => local_address_x,
            local_address_y => local_address_y,
            clock_divider => clock_divider,
            diagonal_pref => diagonal_pref
        )
        
        port map(
            clk => clk,
            rst => rst,
               
            data_in => data_in_local,
            data_in_valid => data_in_valid_local,
            data_in_vc_busy => data_in_vc_busy_local,
            data_in_vc_credits => data_in_vc_credits_local,
            
            data_out => data_out_local,
            data_out_valid => data_out_valid_local,
            data_out_vc_busy => data_out_vc_busy_local,
            data_out_vc_credits => data_out_vc_credits_local,
            
            arb_vc_busy => arb_vc_busy_local,
            arb_credit_counter => arb_credit_counter_local,
                    
            req => req_local,
            head => head_local,
            tail => tail_local,
            
            grant => grant_local,
            vc_downstream => vc_downstream_local,
            
            crossbar_data => crossbar_data_local,
            crossbar_data_valid => crossbar_data_valid_local,
            
            int_data_out => int_data_out_local,
            int_data_out_valid => int_data_out_valid_local
        );

    -- router_branch KOMPONENTA - NORTH
    router_branch_north : router_branch
        
        generic map(
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => local_address_x,
            local_address_y => local_address_y,
            clock_divider => clock_divider,
            diagonal_pref => diagonal_pref
        )
        
        port map(
            clk => clk,
            rst => rst,
               
            data_in => data_in_north,
            data_in_valid => data_in_valid_north,
            data_in_vc_busy => data_in_vc_busy_north,
            data_in_vc_credits => data_in_vc_credits_north,
            
            data_out => data_out_north,
            data_out_valid => data_out_valid_north,
            data_out_vc_busy => data_out_vc_busy_north,
            data_out_vc_credits => data_out_vc_credits_north,
            
            arb_vc_busy => arb_vc_busy_north,
            arb_credit_counter => arb_credit_counter_north,
                    
            req => req_north,
            head => head_north,
            tail => tail_north,
            
            grant => grant_north,
            vc_downstream => vc_downstream_north,
            
            crossbar_data => crossbar_data_north,
            crossbar_data_valid => crossbar_data_valid_north,
            
            int_data_out => int_data_out_north,
            int_data_out_valid => int_data_out_valid_north
        );

    -- router_branch KOMPONENTA - EAST
    router_branch_east : router_branch
        
        generic map(
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => local_address_x,
            local_address_y => local_address_y,
            clock_divider => clock_divider,
            diagonal_pref => diagonal_pref
        )
        
        port map(
            clk => clk,
            rst => rst,
               
            data_in => data_in_east,
            data_in_valid => data_in_valid_east,
            data_in_vc_busy => data_in_vc_busy_east,
            data_in_vc_credits => data_in_vc_credits_east,
            
            data_out => data_out_east,
            data_out_valid => data_out_valid_east,
            data_out_vc_busy => data_out_vc_busy_east,
            data_out_vc_credits => data_out_vc_credits_east,
            
            arb_vc_busy => arb_vc_busy_east,
            arb_credit_counter => arb_credit_counter_east,
                    
            req => req_east,
            head => head_east,
            tail => tail_east,
            
            grant => grant_east,
            vc_downstream => vc_downstream_east,
            
            crossbar_data => crossbar_data_east,
            crossbar_data_valid => crossbar_data_valid_east,
            
            int_data_out => int_data_out_east,
            int_data_out_valid => int_data_out_valid_east
        );

    -- router_branch KOMPONENTA - SOUTH
    router_branch_south : router_branch
        
        generic map(
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => local_address_x,
            local_address_y => local_address_y,
            clock_divider => clock_divider,
            diagonal_pref => diagonal_pref
        )
        
        port map(
            clk => clk,
            rst => rst,
               
            data_in => data_in_south,
            data_in_valid => data_in_valid_south,
            data_in_vc_busy => data_in_vc_busy_south,
            data_in_vc_credits => data_in_vc_credits_south,
            
            data_out => data_out_south,
            data_out_valid => data_out_valid_south,
            data_out_vc_busy => data_out_vc_busy_south,
            data_out_vc_credits => data_out_vc_credits_south,
            
            arb_vc_busy => arb_vc_busy_south,
            arb_credit_counter => arb_credit_counter_south,
                    
            req => req_south,
            head => head_south,
            tail => tail_south,
            
            grant => grant_south,
            vc_downstream => vc_downstream_south,
            
            crossbar_data => crossbar_data_south,
            crossbar_data_valid => crossbar_data_valid_south,
            
            int_data_out => int_data_out_south,
            int_data_out_valid => int_data_out_valid_south
        );

    -- router_branch KOMPONENTA - WEST
    router_branch_west : router_branch
        
        generic map(
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => local_address_x,
            local_address_y => local_address_y,
            clock_divider => clock_divider,
            diagonal_pref => diagonal_pref
        )
        
        port map(
            clk => clk,
            rst => rst,
               
            data_in => data_in_west,
            data_in_valid => data_in_valid_west,
            data_in_vc_busy => data_in_vc_busy_west,
            data_in_vc_credits => data_in_vc_credits_west,
            
            data_out => data_out_west,
            data_out_valid => data_out_valid_west,
            data_out_vc_busy => data_out_vc_busy_west,
            data_out_vc_credits => data_out_vc_credits_west,
            
            arb_vc_busy => arb_vc_busy_west,
            arb_credit_counter => arb_credit_counter_west,
                    
            req => req_west,
            head => head_west,
            tail => tail_west,
            
            grant => grant_west,
            vc_downstream => vc_downstream_west,
            
            crossbar_data => crossbar_data_west,
            crossbar_data_valid => crossbar_data_valid_west,
            
            int_data_out => int_data_out_west,
            int_data_out_valid => int_data_out_valid_west
        );

    -- arbiter KOMPONENTA
    comp_arbiter: arbiter
    
        generic map (
            vc_num => vc_num
        )
        
        port map (
            clk => clk, 
            rst => rst, 
            
            vc_busy_local => arb_vc_busy_local,  
            vc_busy_north => arb_vc_busy_north,  
            vc_busy_east => arb_vc_busy_east,  
            vc_busy_south => arb_vc_busy_south, 
            vc_busy_west => arb_vc_busy_west,  
            
            credit_counter_local => arb_credit_counter_local,  
            credit_counter_north => arb_credit_counter_north,  
            credit_counter_east => arb_credit_counter_east,  
            credit_counter_south => arb_credit_counter_south,  
            credit_counter_west => arb_credit_counter_west,  
            
            req_local => req_local,  
            req_north => req_north,  
            req_east => req_east, 
            req_south => req_south,  
            req_west => req_west, 
            
            head_local => head_local,  
            head_north => head_north,  
            head_east => head_east,  
            head_south => head_south, 
            head_west => head_west, 
            
            tail_local => tail_local,  
            tail_north=> tail_north,  
            tail_east => tail_east, 
            tail_south => tail_south,  
            tail_west => tail_west,  
            
            grant_local => grant_local,  
            grant_north => grant_north, 
            grant_east => grant_east,  
            grant_south => grant_south,  
            grant_west => grant_west,  
            
            vc_downstream_local => vc_downstream_local,  
            vc_downstream_north => vc_downstream_north, 
            vc_downstream_east => vc_downstream_east,  
            vc_downstream_south => vc_downstream_south, 
            vc_downstream_west => vc_downstream_west,  
            
            select_vector_local => select_vector_local,  
            select_vector_north => select_vector_north,  
            select_vector_east => select_vector_east, 
            select_vector_south => select_vector_south,  
            select_vector_west => select_vector_west  
        );
    
    -- crossbar KOMPONENTA
    comp_crossbar: crossbar
    
        generic map (
            flit_size => flit_size
        )
        
        port map (
            select_vector_local => select_vector_local,
            select_vector_north => select_vector_north,
            select_vector_east => select_vector_east,
            select_vector_south => select_vector_south,
            select_vector_west => select_vector_west,
        
            data_in_local => crossbar_data_local,
            data_in_north => crossbar_data_north,
            data_in_east => crossbar_data_east,
            data_in_south => crossbar_data_south,
            data_in_west => crossbar_data_west,
            
            data_in_valid_local => crossbar_data_valid_local,
            data_in_valid_north => crossbar_data_valid_north,
            data_in_valid_east => crossbar_data_valid_east,
            data_in_valid_south => crossbar_data_valid_south,
            data_in_valid_west => crossbar_data_valid_west,
            
            data_out_local => int_data_out_local,
            data_out_north => int_data_out_north,
            data_out_east => int_data_out_east,
            data_out_south => int_data_out_south,
            data_out_west => int_data_out_west,
            
            data_out_valid_local => int_data_out_valid_local,
            data_out_valid_north => int_data_out_valid_north,
            data_out_valid_east => int_data_out_valid_east,
            data_out_valid_south => int_data_out_valid_south,
            data_out_valid_west => int_data_out_valid_west
        );

end Behavioral;