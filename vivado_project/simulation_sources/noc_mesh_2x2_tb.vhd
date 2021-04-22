----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 04/22/2021 09:43:03 PM
-- Design Name: NoC Router
-- Module Name: noc_mesh_2x2_tb - Simulation
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
-- Revision 0.1 - 2021-04-22 - Ramljak
-- Additional Comments: Prva verzija simulacije noc mreze 2x2
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

entity noc_mesh_2x2_tb is
--  Port ( );
end noc_mesh_2x2_tb;

architecture Simulation of noc_mesh_2x2_tb is

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal rst_sim : std_logic;
    
    -- ROUTER A
    -- LOCAL
    signal data_in_A_local : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_valid_A_local : std_logic;
    signal data_in_vc_busy_A_local : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_in_vc_credits_A_local : std_logic_vector(const_vc_num - 1 downto 0);

    signal data_out_A_local : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_valid_A_local : std_logic;
    signal data_out_vc_busy_A_local : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_out_vc_credits_A_local : std_logic_vector(const_vc_num - 1 downto 0);
    
    --NORTH
    signal data_in_A_north : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_valid_A_north : std_logic;
    signal data_in_vc_busy_A_north : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_in_vc_credits_A_north : std_logic_vector(const_vc_num - 1 downto 0);

    signal data_out_A_north : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_valid_A_north : std_logic;
    signal data_out_vc_busy_A_north : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_out_vc_credits_A_north : std_logic_vector(const_vc_num - 1 downto 0);
    
    --WEST
    signal data_in_A_west : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_valid_A_west : std_logic;
    signal data_in_vc_busy_A_west : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_in_vc_credits_A_west : std_logic_vector(const_vc_num - 1 downto 0);

    signal data_out_A_west : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_valid_A_west : std_logic;
    signal data_out_vc_busy_A_west : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_out_vc_credits_A_west : std_logic_vector(const_vc_num - 1 downto 0);
    
    
    -- ROUTER B
    -- LOCAL
    signal data_in_B_local : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_valid_B_local : std_logic;
    signal data_in_vc_busy_B_local : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_in_vc_credits_B_local : std_logic_vector(const_vc_num - 1 downto 0);

    signal data_out_B_local : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_valid_B_local : std_logic;
    signal data_out_vc_busy_B_local : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_out_vc_credits_B_local : std_logic_vector(const_vc_num - 1 downto 0);
    
    --NORTH
    signal data_in_B_north : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_valid_B_north : std_logic;
    signal data_in_vc_busy_B_north : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_in_vc_credits_B_north : std_logic_vector(const_vc_num - 1 downto 0);

    signal data_out_B_north : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_valid_B_north : std_logic;
    signal data_out_vc_busy_B_north : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_out_vc_credits_B_north : std_logic_vector(const_vc_num - 1 downto 0);
    
    --EAST
    signal data_in_B_east : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_valid_B_east : std_logic;
    signal data_in_vc_busy_B_east : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_in_vc_credits_B_east : std_logic_vector(const_vc_num - 1 downto 0);

    signal data_out_B_east : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_valid_B_east : std_logic;
    signal data_out_vc_busy_B_east : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_out_vc_credits_B_east : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- ROUTER C
    -- LOCAL
    signal data_in_C_local : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_valid_C_local : std_logic;
    signal data_in_vc_busy_C_local : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_in_vc_credits_C_local : std_logic_vector(const_vc_num - 1 downto 0);

    signal data_out_C_local : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_valid_C_local : std_logic;
    signal data_out_vc_busy_C_local : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_out_vc_credits_C_local : std_logic_vector(const_vc_num - 1 downto 0);
    
    --SOUTH
    signal data_in_C_south : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_valid_C_south : std_logic;
    signal data_in_vc_busy_C_south : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_in_vc_credits_C_south : std_logic_vector(const_vc_num - 1 downto 0);

    signal data_out_C_south : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_valid_C_south : std_logic;
    signal data_out_vc_busy_C_south : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_out_vc_credits_C_south : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- WEST
    signal data_in_C_west : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_valid_C_west : std_logic;
    signal data_in_vc_busy_C_west : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_in_vc_credits_C_west : std_logic_vector(const_vc_num - 1 downto 0);

    signal data_out_C_west : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_valid_C_west : std_logic;
    signal data_out_vc_busy_C_west : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_out_vc_credits_C_west : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- ROUTER D
    -- LOCAL
    signal data_in_D_local : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_valid_D_local : std_logic;
    signal data_in_vc_busy_D_local : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_in_vc_credits_D_local : std_logic_vector(const_vc_num - 1 downto 0);

    signal data_out_D_local : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_valid_D_local : std_logic;
    signal data_out_vc_busy_D_local : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_out_vc_credits_D_local : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- EAST
    signal data_in_D_east : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_valid_D_east : std_logic;
    signal data_in_vc_busy_D_east : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_in_vc_credits_D_east : std_logic_vector(const_vc_num - 1 downto 0);

    signal data_out_D_east : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_valid_D_east : std_logic;
    signal data_out_vc_busy_D_east : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_out_vc_credits_D_east : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- SOUTH
    signal data_in_D_south : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_in_valid_D_south : std_logic;
    signal data_in_vc_busy_D_south : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_in_vc_credits_D_south : std_logic_vector(const_vc_num - 1 downto 0);

    signal data_out_D_south : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_valid_D_south : std_logic;
    signal data_out_vc_busy_D_south : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_out_vc_credits_D_south : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER A - ROUTER B
    signal data_A_to_B : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_A_to_B : std_logic;
    signal vc_busy_B_to_A : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_B_to_A : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_B_to_A : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_B_to_A : std_logic;
    signal vc_busy_A_to_B : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_A_to_B : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER A - ROUTER C
    signal data_A_to_C : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_A_to_C : std_logic;
    signal vc_busy_C_to_A : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_C_to_A : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_C_to_A : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_C_to_A : std_logic;
    signal vc_busy_A_to_C : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_A_to_C : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER B - ROUTER D
    signal data_B_to_D : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_B_to_D : std_logic;
    signal vc_busy_D_to_B : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_D_to_B : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_D_to_B : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_D_to_B : std_logic;
    signal vc_busy_B_to_D : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_B_to_D : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER C - ROUTER D
    signal data_C_to_D : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_C_to_D : std_logic;
    signal vc_busy_D_to_C : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_D_to_C : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_D_to_C : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_D_to_C : std_logic;
    signal vc_busy_C_to_D : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_C_to_D : std_logic_vector(const_vc_num - 1 downto 0); 

    -- Period takta
    constant clk_period : time := 200ns;
    
    -- Spori clk za usporedbu
    signal int_clk_sim : std_logic;
    
begin

    -- Komponenta koja se testira (Unit Under Test)
    uut_router_A: noc_router
    
        generic map (
            vc_num => const_vc_num,
            mesh_size_x => const_mesh_size_x,
            mesh_size_y => const_mesh_size_y,
            address_size => const_address_size,
            payload_size => const_payload_size,
            flit_size => const_flit_size,
            buffer_size => const_buffer_size,
            local_address_x => "0001",
            local_address_y => "0001",
            clock_divider => const_clock_divider,
            diagonal_pref => const_default_diagonal_pref
        )
        
        port map(
            clk => clk_sim,
            rst => rst_sim,
               
            data_in_local => data_in_A_local,
            data_in_valid_local => data_in_valid_A_local,
            data_in_vc_busy_local => data_in_vc_busy_A_local,
            data_in_vc_credits_local => data_in_vc_credits_A_local,
            
            data_out_local => data_out_A_local,
            data_out_valid_local => data_out_valid_A_local,
            data_out_vc_busy_local => data_out_vc_busy_A_local,
            data_out_vc_credits_local =>  data_out_vc_credits_A_local,
            
            data_in_north => data_in_A_north,
            data_in_valid_north => data_in_valid_A_north,
            data_in_vc_busy_north => data_in_vc_busy_A_north,
            data_in_vc_credits_north => data_in_vc_credits_A_north,
            
            data_out_north => data_out_A_north,
            data_out_valid_north => data_out_valid_A_north,
            data_out_vc_busy_north => data_out_vc_busy_A_north,
            data_out_vc_credits_north => data_out_vc_credits_A_north,
            
            data_in_east => data_B_to_A,
            data_in_valid_east => data_valid_B_to_A,
            data_in_vc_busy_east => vc_busy_A_to_B,
            data_in_vc_credits_east => vc_credits_A_to_B,
            
            data_out_east => data_A_to_B,
            data_out_valid_east => data_valid_A_to_B,
            data_out_vc_busy_east => vc_busy_B_to_A,
            data_out_vc_credits_east => vc_credits_B_to_A,
            
            data_in_south => data_C_to_A,
            data_in_valid_south => data_valid_C_to_A,
            data_in_vc_busy_south => vc_busy_A_to_C,
            data_in_vc_credits_south => vc_credits_A_to_C,
            
            data_out_south => data_A_to_C,
            data_out_valid_south => data_valid_A_to_C,
            data_out_vc_busy_south => vc_busy_C_to_A,
            data_out_vc_credits_south => vc_credits_C_to_A,
            
            data_in_west => data_in_A_west,
            data_in_valid_west => data_in_valid_A_west,
            data_in_vc_busy_west => data_in_vc_busy_A_west,
            data_in_vc_credits_west => data_in_vc_credits_A_west,
            
            data_out_west => data_out_A_west,
            data_out_valid_west => data_out_valid_A_west,
            data_out_vc_busy_west => data_out_vc_busy_A_west,
            data_out_vc_credits_west => data_out_vc_credits_A_west
        );
        
    -- Komponenta koja se testira (Unit Under Test)
    uut_router_B: noc_router
    
        generic map (
            vc_num => const_vc_num,
            mesh_size_x => const_mesh_size_x,
            mesh_size_y => const_mesh_size_y,
            address_size => const_address_size,
            payload_size => const_payload_size,
            flit_size => const_flit_size,
            buffer_size => const_buffer_size,
            local_address_x => "0010",
            local_address_y => "0001",
            clock_divider => const_clock_divider,
            diagonal_pref => const_default_diagonal_pref
        )
        
        port map(
            clk => clk_sim,
            rst => rst_sim,
               
            data_in_local => data_in_B_local,
            data_in_valid_local => data_in_valid_B_local,
            data_in_vc_busy_local => data_in_vc_busy_B_local,
            data_in_vc_credits_local => data_in_vc_credits_B_local,
            
            data_out_local => data_out_B_local,
            data_out_valid_local => data_out_valid_B_local,
            data_out_vc_busy_local => data_out_vc_busy_B_local,
            data_out_vc_credits_local =>  data_out_vc_credits_B_local,
            
            data_in_north => data_in_B_north,
            data_in_valid_north => data_in_valid_B_north,
            data_in_vc_busy_north => data_in_vc_busy_B_north,
            data_in_vc_credits_north => data_in_vc_credits_B_north,
            
            data_out_north => data_out_B_north,
            data_out_valid_north => data_out_valid_B_north,
            data_out_vc_busy_north => data_out_vc_busy_B_north,
            data_out_vc_credits_north => data_out_vc_credits_B_north,
            
            data_in_east => data_in_B_east,
            data_in_valid_east => data_in_valid_B_east,
            data_in_vc_busy_east => data_in_vc_busy_B_east,
            data_in_vc_credits_east => data_in_vc_credits_B_east,
            
            data_out_east => data_out_B_east,
            data_out_valid_east => data_out_valid_B_east,
            data_out_vc_busy_east => data_out_vc_busy_B_east,
            data_out_vc_credits_east => data_out_vc_credits_B_east,
            
            data_in_south => data_D_to_B,
            data_in_valid_south => data_valid_D_to_B,
            data_in_vc_busy_south => vc_busy_B_to_D,
            data_in_vc_credits_south => vc_credits_B_to_D,
            
            data_out_south => data_B_to_D,
            data_out_valid_south => data_valid_B_to_D,
            data_out_vc_busy_south => vc_busy_D_to_B,
            data_out_vc_credits_south => vc_credits_D_to_B,
            
            data_in_west => data_A_to_B,
            data_in_valid_west => data_valid_A_to_B,
            data_in_vc_busy_west => vc_busy_B_to_A,
            data_in_vc_credits_west => vc_credits_B_to_A,
            
            data_out_west => data_B_to_A,
            data_out_valid_west => data_valid_B_to_A,
            data_out_vc_busy_west => vc_busy_A_to_B,
            data_out_vc_credits_west => vc_credits_A_to_B
        );

    -- Komponenta koja se testira (Unit Under Test)
    uut_router_C: noc_router
    
        generic map (
            vc_num => const_vc_num,
            mesh_size_x => const_mesh_size_x,
            mesh_size_y => const_mesh_size_y,
            address_size => const_address_size,
            payload_size => const_payload_size,
            flit_size => const_flit_size,
            buffer_size => const_buffer_size,
            local_address_x => "0001",
            local_address_y => "0010",
            clock_divider => const_clock_divider,
            diagonal_pref => const_default_diagonal_pref
        )
        
        port map(
            clk => clk_sim,
            rst => rst_sim,
               
            data_in_local => data_in_C_local,
            data_in_valid_local => data_in_valid_C_local,
            data_in_vc_busy_local => data_in_vc_busy_C_local,
            data_in_vc_credits_local => data_in_vc_credits_C_local,
            
            data_out_local => data_out_C_local,
            data_out_valid_local => data_out_valid_C_local,
            data_out_vc_busy_local => data_out_vc_busy_C_local,
            data_out_vc_credits_local =>  data_out_vc_credits_C_local,
            
            data_in_north => data_A_to_C,
            data_in_valid_north => data_valid_A_to_C,
            data_in_vc_busy_north => vc_busy_C_to_A,
            data_in_vc_credits_north => vc_credits_C_to_A,
            
            data_out_north => data_C_to_A,
            data_out_valid_north => data_valid_C_to_A,
            data_out_vc_busy_north => vc_busy_A_to_C,
            data_out_vc_credits_north => vc_credits_A_to_C,
            
            data_in_east => data_D_to_C,
            data_in_valid_east => data_valid_D_to_C,
            data_in_vc_busy_east => vc_busy_C_to_D,
            data_in_vc_credits_east => vc_credits_C_to_D,
            
            data_out_east => data_C_to_D,
            data_out_valid_east => data_valid_C_to_D,
            data_out_vc_busy_east => vc_busy_D_to_C,
            data_out_vc_credits_east => vc_credits_D_to_C,
            
            data_in_south => data_in_C_south,
            data_in_valid_south => data_in_valid_C_south,
            data_in_vc_busy_south => data_in_vc_busy_C_south,
            data_in_vc_credits_south => data_in_vc_credits_C_south,
            
            data_out_south => data_out_C_south,
            data_out_valid_south => data_out_valid_C_south,
            data_out_vc_busy_south => data_out_vc_busy_C_south,
            data_out_vc_credits_south => data_out_vc_credits_C_south,
            
            data_in_west => data_in_C_west,
            data_in_valid_west => data_in_valid_C_west,
            data_in_vc_busy_west => data_in_vc_busy_C_west,
            data_in_vc_credits_west => data_in_vc_credits_C_west,
            
            data_out_west => data_out_C_west,
            data_out_valid_west => data_out_valid_C_west,
            data_out_vc_busy_west => data_out_vc_busy_C_west,
            data_out_vc_credits_west => data_out_vc_credits_C_west
        );
        
    -- Komponenta koja se testira (Unit Under Test)
    uut_router_D: noc_router
    
        generic map (
            vc_num => const_vc_num,
            mesh_size_x => const_mesh_size_x,
            mesh_size_y => const_mesh_size_y,
            address_size => const_address_size,
            payload_size => const_payload_size,
            flit_size => const_flit_size,
            buffer_size => const_buffer_size,
            local_address_x => "0010",
            local_address_y => "0010",
            clock_divider => const_clock_divider,
            diagonal_pref => const_default_diagonal_pref
        )
        
        port map(
            clk => clk_sim,
            rst => rst_sim,
               
            data_in_local => data_in_D_local,
            data_in_valid_local => data_in_valid_D_local,
            data_in_vc_busy_local => data_in_vc_busy_D_local,
            data_in_vc_credits_local => data_in_vc_credits_D_local,
            
            data_out_local => data_out_D_local,
            data_out_valid_local => data_out_valid_D_local,
            data_out_vc_busy_local => data_out_vc_busy_D_local,
            data_out_vc_credits_local =>  data_out_vc_credits_D_local,
            
            data_in_north => data_B_to_D,
            data_in_valid_north => data_valid_B_to_D,
            data_in_vc_busy_north => vc_busy_D_to_B,
            data_in_vc_credits_north => vc_credits_D_to_B,
            
            data_out_north => data_D_to_B,
            data_out_valid_north => data_valid_D_to_B,
            data_out_vc_busy_north => vc_busy_B_to_D,
            data_out_vc_credits_north => vc_credits_B_to_D,
            
            data_in_east => data_in_D_east,
            data_in_valid_east => data_in_valid_D_east,
            data_in_vc_busy_east => data_in_vc_busy_D_east,
            data_in_vc_credits_east => data_in_vc_credits_D_east,
            
            data_out_east => data_out_D_east,
            data_out_valid_east => data_out_valid_D_east,
            data_out_vc_busy_east => data_out_vc_busy_D_east,
            data_out_vc_credits_east => data_out_vc_credits_D_east,
            
            data_in_south => data_in_D_south,
            data_in_valid_south => data_in_valid_D_south,
            data_in_vc_busy_south => data_in_vc_busy_D_south,
            data_in_vc_credits_south => data_in_vc_credits_D_south,
            
            data_out_south => data_out_D_south,
            data_out_valid_south => data_out_valid_D_south,
            data_out_vc_busy_south => data_out_vc_busy_D_south,
            data_out_vc_credits_south => data_out_vc_credits_D_south,
            
            data_in_west => data_C_to_D,
            data_in_valid_west => data_valid_C_to_D,
            data_in_vc_busy_west => vc_busy_D_to_C,
            data_in_vc_credits_west => vc_credits_D_to_C,
            
            data_out_west => data_D_to_C,
            data_out_valid_west => data_valid_D_to_C,
            data_out_vc_busy_west => vc_busy_C_to_D,
            data_out_vc_credits_west => vc_credits_C_to_D
        );
        
    -- clk proces
    clk_process : process
    
    begin
    
        clk_sim <= '1';
        wait for clk_period / 2;
        clk_sim <= '0';
        wait for clk_period / 2;
        
    end process;
    
    -- simulacija sporog takta
    int_clk_process : process (clk_sim) is 
        
        variable clk_counter : integer;
        
    begin
    
        if rising_edge(clk_sim) then
            if rst_sim = '0' then
                
                -- POSTAVI BROJILO NA 0
                clk_counter := const_clock_divider - 1;
                
                -- POSTAVI INTERNI TAKT NA 0
                int_clk_sim <= '0';
            
            else
            
                -- POVECAJ BROJILO ZA 1
                clk_counter := (clk_counter + 1) mod const_clock_divider;
                
                -- PROMIJENI FAZU INTERNOG TAKTA
                if (clk_counter = 0) then
                    int_clk_sim <= not int_clk_sim;
                end if;  
                        
            end if;
        end if;
        
    end process;
    
    
    -- stimulirajuci proces
    stim_process : process
    
    begin
    
        -- Inicijalne postavke ulaznih signala
        -- ROUTER A
        -- LOCAL
        data_in_A_local <= (others => '0');
        data_in_valid_A_local <= '0';
        data_out_vc_busy_A_local <= (others => '0');
        data_out_vc_credits_A_local <= (others => '0');
        
        -- NORTH
        data_in_A_north <= (others => '0');
        data_in_valid_A_north <= '0';
        data_out_vc_busy_A_north <= (others => '0');
        data_out_vc_credits_A_north <= (others => '0');
        
        -- WEST
        data_in_A_west <= (others => '0');
        data_in_valid_A_west <= '0';
        data_out_vc_busy_A_west <= (others => '0');
        data_out_vc_credits_A_west <= (others => '0');
        
        -- ROUTER B
        -- LOCAL
        data_in_B_local <= (others => '0');
        data_in_valid_B_local <= '0';
        data_out_vc_busy_B_local <= (others => '0');
        data_out_vc_credits_B_local <= (others => '0');
        
        -- NORTH
        data_in_B_north <= (others => '0');
        data_in_valid_B_north <= '0';
        data_out_vc_busy_B_north <= (others => '0');
        data_out_vc_credits_B_north <= (others => '0');
        
        -- EAST
        data_in_B_east <= (others => '0');
        data_in_valid_B_east <= '0';
        data_out_vc_busy_B_east <= (others => '0');
        data_out_vc_credits_B_east <= (others => '0');
        
        -- ROUTER C
        -- LOCAL
        data_in_C_local <= (others => '0');
        data_in_valid_C_local <= '0';
        data_out_vc_busy_C_local <= (others => '0');
        data_out_vc_credits_C_local <= (others => '0');
        
        -- SOUTH
        data_in_C_south <= (others => '0');
        data_in_valid_C_south <= '0';
        data_out_vc_busy_C_south <= (others => '0');
        data_out_vc_credits_C_south <= (others => '0');
        
        -- WEST
        data_in_C_west <= (others => '0');
        data_in_valid_C_west <= '0';
        data_out_vc_busy_C_west <= (others => '0');
        data_out_vc_credits_C_west <= (others => '0');
                
        -- ROUTER D
        -- LOCAL
        data_in_D_local <= (others => '0');
        data_in_valid_D_local <= '0';
        data_out_vc_busy_D_local <= (others => '0');
        data_out_vc_credits_D_local <= (others => '0');
        
        -- EAST
        data_in_D_east <= (others => '0');
        data_in_valid_D_east <= '0';
        data_out_vc_busy_D_east <= (others => '0');
        data_out_vc_credits_D_east <= (others => '0');
        
        -- SOUTH
        data_in_D_south <= (others => '0');
        data_in_valid_D_south <= '0';
        data_out_vc_busy_D_south <= (others => '0');
        data_out_vc_credits_D_south <= (others => '0');
        
         -- Reset aktivan
        rst_sim <= '0';
        
        wait for (10 * clk_period);
        
        -- Reset neaktivan
        rst_sim <= '1';       



        wait;
    
    end process;
    


end Simulation;
