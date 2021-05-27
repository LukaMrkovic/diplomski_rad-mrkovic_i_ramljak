----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 27.05.2021 11:53:14
-- Design Name: NoC_Mesh
-- Module Name: noc_mesh_2x2 - Behavioral
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
-- Revision 0.1 - 2021-05-27 - Mrkovic
-- Additional Comments: Genericka 2x2 noc mreza
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

entity noc_mesh_2x2 is

    Generic (
        vc_num : integer := const_vc_num;
        mesh_size_x : integer := const_mesh_size_x;
        mesh_size_y : integer := const_mesh_size_y;
        address_size : integer := const_address_size;
        payload_size : integer := const_payload_size;
        flit_size : integer := const_flit_size;
        buffer_size : integer := const_buffer_size;
        clock_divider : integer := const_clock_divider
    );
    
    Port (
        clk : in std_logic;
        rst : in std_logic;
        
        -- MESH INJECTION INTERFACES
        
        -- ROUTER A (11)
        data_in_A : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid_A : in std_logic;
        data_in_vc_busy_A : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits_A : out std_logic_vector(vc_num - 1 downto 0);
        
        data_out_A : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid_A : out std_logic;
        data_out_vc_busy_A : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits_A : in std_logic_vector(vc_num - 1 downto 0);
        
        -- ROUTER B (21)
        data_in_B : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid_B : in std_logic;
        data_in_vc_busy_B : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits_B : out std_logic_vector(vc_num - 1 downto 0);
        
        data_out_B : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid_B : out std_logic;
        data_out_vc_busy_B : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits_B : in std_logic_vector(vc_num - 1 downto 0);
        
        -- ROUTER C (12)
        data_in_C : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid_C : in std_logic;
        data_in_vc_busy_C : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits_C : out std_logic_vector(vc_num - 1 downto 0);
        
        data_out_C : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid_C : out std_logic;
        data_out_vc_busy_C : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits_C : in std_logic_vector(vc_num - 1 downto 0);
        
        -- ROUTER D (22)
        data_in_D : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid_D : in std_logic;
        data_in_vc_busy_D : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits_D : out std_logic_vector(vc_num - 1 downto 0);
        
        data_out_D : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid_D : out std_logic;
        data_out_vc_busy_D : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits_D : in std_logic_vector(vc_num - 1 downto 0)
    );

end noc_mesh_2x2;

architecture Behavioral of noc_mesh_2x2 is

    -- INTERNI SIGNALI
    
    -- MEDUKONEKCIJE ROUTER A (11) - ROUTER B (21)
    signal data_A_to_B : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_A_to_B : std_logic;
    signal vc_busy_B_to_A : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_B_to_A : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_B_to_A : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_B_to_A : std_logic;
    signal vc_busy_A_to_B : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_A_to_B : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER A (11) - ROUTER C (12)
    signal data_A_to_C : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_A_to_C : std_logic;
    signal vc_busy_C_to_A : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_C_to_A : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_C_to_A : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_C_to_A : std_logic;
    signal vc_busy_A_to_C : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_A_to_C : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER B (21) - ROUTER D (22)
    signal data_B_to_D : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_B_to_D : std_logic;
    signal vc_busy_D_to_B : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_D_to_B : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_D_to_B : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_D_to_B : std_logic;
    signal vc_busy_B_to_D : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_B_to_D : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER C (12) - ROUTER D (22)
    signal data_C_to_D : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_C_to_D : std_logic;
    signal vc_busy_D_to_C : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_D_to_C : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_D_to_C : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_D_to_C : std_logic;
    signal vc_busy_C_to_D : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_C_to_D : std_logic_vector(const_vc_num - 1 downto 0);

begin

    -- noc_router KOMPONENTA - ROUTER A (11)
    router_A: noc_router
    
        generic map (
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => "0001",
            local_address_y => "0001",
            clock_divider => clock_divider,
            diagonal_pref => HOR
        )
        
        port map(
            clk => clk,
            rst => rst,
            
            -- ROUTER TO ROUTER INTERFACE
            -- LOCAL
            data_in_local => data_in_A,
            data_in_valid_local => data_in_valid_A,
            data_in_vc_busy_local => data_in_vc_busy_A,
            data_in_vc_credits_local => data_in_vc_credits_A,
            
            data_out_local => data_out_A,
            data_out_valid_local => data_out_valid_A,
            data_out_vc_busy_local => data_out_vc_busy_A,
            data_out_vc_credits_local =>  data_out_vc_credits_A,
            
            -- ROUTER TO ROUTER INTERFACE
            -- NORTH
            data_in_north => (others => '0'),
            data_in_valid_north => '0',
            data_in_vc_busy_north => open,
            data_in_vc_credits_north => open,
            
            data_out_north => open,
            data_out_valid_north => open,
            data_out_vc_busy_north => (others => '0'),
            data_out_vc_credits_north => (others => '0'),
            
            -- ROUTER TO ROUTER INTERFACE
            -- EAST
            data_in_east => data_B_to_A,
            data_in_valid_east => data_valid_B_to_A,
            data_in_vc_busy_east => vc_busy_A_to_B,
            data_in_vc_credits_east => vc_credits_A_to_B,
            
            data_out_east => data_A_to_B,
            data_out_valid_east => data_valid_A_to_B,
            data_out_vc_busy_east => vc_busy_B_to_A,
            data_out_vc_credits_east => vc_credits_B_to_A,
            
            -- ROUTER TO ROUTER INTERFACE
            -- SOUTH
            data_in_south => data_C_to_A,
            data_in_valid_south => data_valid_C_to_A,
            data_in_vc_busy_south => vc_busy_A_to_C,
            data_in_vc_credits_south => vc_credits_A_to_C,
            
            data_out_south => data_A_to_C,
            data_out_valid_south => data_valid_A_to_C,
            data_out_vc_busy_south => vc_busy_C_to_A,
            data_out_vc_credits_south => vc_credits_C_to_A,
            
            -- ROUTER TO ROUTER INTERFACE
            -- WEST
            data_in_west => (others => '0'),
            data_in_valid_west => '0',
            data_in_vc_busy_west => open,
            data_in_vc_credits_west => open,
            
            data_out_west => open,
            data_out_valid_west => open,
            data_out_vc_busy_west => (others => '0'),
            data_out_vc_credits_west => (others => '0')
        );
    
    -- noc_router KOMPONENTA - ROUTER B (21)
    router_B: noc_router
    
        generic map (
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => "0010",
            local_address_y => "0001",
            clock_divider => clock_divider,
            diagonal_pref => HOR
        )
        
        port map(
            clk => clk,
            rst => rst,
            
            -- ROUTER TO ROUTER INTERFACE
            -- LOCAL
            data_in_local => data_in_B,
            data_in_valid_local => data_in_valid_B,
            data_in_vc_busy_local => data_in_vc_busy_B,
            data_in_vc_credits_local => data_in_vc_credits_B,
            
            data_out_local => data_out_B,
            data_out_valid_local => data_out_valid_B,
            data_out_vc_busy_local => data_out_vc_busy_B,
            data_out_vc_credits_local =>  data_out_vc_credits_B,
            
            -- ROUTER TO ROUTER INTERFACE
            -- NORTH
            data_in_north => (others => '0'),
            data_in_valid_north => '0',
            data_in_vc_busy_north => open,
            data_in_vc_credits_north => open,
            
            data_out_north => open,
            data_out_valid_north => open,
            data_out_vc_busy_north => (others => '0'),
            data_out_vc_credits_north => (others => '0'),
            
            -- ROUTER TO ROUTER INTERFACE
            -- EAST
            data_in_east => (others => '0'),
            data_in_valid_east => '0',
            data_in_vc_busy_east => open,
            data_in_vc_credits_east => open,
            
            data_out_east => open,
            data_out_valid_east => open,
            data_out_vc_busy_east => (others => '0'),
            data_out_vc_credits_east => (others => '0'),
            
            -- ROUTER TO ROUTER INTERFACE
            -- SOUTH
            data_in_south => data_D_to_B,
            data_in_valid_south => data_valid_D_to_B,
            data_in_vc_busy_south => vc_busy_B_to_D,
            data_in_vc_credits_south => vc_credits_B_to_D,
            
            data_out_south => data_B_to_D,
            data_out_valid_south => data_valid_B_to_D,
            data_out_vc_busy_south => vc_busy_D_to_B,
            data_out_vc_credits_south => vc_credits_D_to_B,
            
            -- ROUTER TO ROUTER INTERFACE
            -- WEST
            data_in_west => data_A_to_B,
            data_in_valid_west => data_valid_A_to_B,
            data_in_vc_busy_west => vc_busy_B_to_A,
            data_in_vc_credits_west => vc_credits_B_to_A,
            
            data_out_west => data_B_to_A,
            data_out_valid_west => data_valid_B_to_A,
            data_out_vc_busy_west => vc_busy_A_to_B,
            data_out_vc_credits_west => vc_credits_A_to_B
        );
    
    -- noc_router KOMPONENTA - ROUTER C (12)
    router_C: noc_router
    
        generic map (
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => "0001",
            local_address_y => "0010",
            clock_divider => clock_divider,
            diagonal_pref => HOR
        )
        
        port map(
            clk => clk,
            rst => rst,
            
            -- ROUTER TO ROUTER INTERFACE
            -- LOCAL
            data_in_local => data_in_C,
            data_in_valid_local => data_in_valid_C,
            data_in_vc_busy_local => data_in_vc_busy_C,
            data_in_vc_credits_local => data_in_vc_credits_C,
            
            data_out_local => data_out_C,
            data_out_valid_local => data_out_valid_C,
            data_out_vc_busy_local => data_out_vc_busy_C,
            data_out_vc_credits_local =>  data_out_vc_credits_C,
            
            -- ROUTER TO ROUTER INTERFACE
            -- NORTH
            data_in_north => data_A_to_C,
            data_in_valid_north => data_valid_A_to_C,
            data_in_vc_busy_north => vc_busy_C_to_A,
            data_in_vc_credits_north => vc_credits_C_to_A,
            
            data_out_north => data_C_to_A,
            data_out_valid_north => data_valid_C_to_A,
            data_out_vc_busy_north => vc_busy_A_to_C,
            data_out_vc_credits_north => vc_credits_A_to_C,
            
            -- ROUTER TO ROUTER INTERFACE
            -- EAST
            data_in_east => data_D_to_C,
            data_in_valid_east => data_valid_D_to_C,
            data_in_vc_busy_east => vc_busy_C_to_D,
            data_in_vc_credits_east => vc_credits_C_to_D,
            
            data_out_east => data_C_to_D,
            data_out_valid_east => data_valid_C_to_D,
            data_out_vc_busy_east => vc_busy_D_to_C,
            data_out_vc_credits_east => vc_credits_D_to_C,
            
            -- ROUTER TO ROUTER INTERFACE
            -- SOUTH
            data_in_south => (others => '0'),
            data_in_valid_south => '0',
            data_in_vc_busy_south => open,
            data_in_vc_credits_south => open,
            
            data_out_south => open,
            data_out_valid_south => open,
            data_out_vc_busy_south => (others => '0'),
            data_out_vc_credits_south => (others => '0'),
            
            -- ROUTER TO ROUTER INTERFACE
            -- WEST
            data_in_west => (others => '0'),
            data_in_valid_west => '0',
            data_in_vc_busy_west => open,
            data_in_vc_credits_west => open,
            
            data_out_west => open,
            data_out_valid_west => open,
            data_out_vc_busy_west => (others => '0'),
            data_out_vc_credits_west => (others => '0')
        );
    
    -- noc_router KOMPONENTA - ROUTER A (22)
    router_D: noc_router
    
        generic map (
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => "0010",
            local_address_y => "0010",
            clock_divider => clock_divider,
            diagonal_pref => HOR
        )
        
        port map(
            clk => clk,
            rst => rst,
            
            -- ROUTER TO ROUTER INTERFACE
            -- LOCAL
            data_in_local => data_in_D,
            data_in_valid_local => data_in_valid_D,
            data_in_vc_busy_local => data_in_vc_busy_D,
            data_in_vc_credits_local => data_in_vc_credits_D,
            
            data_out_local => data_out_D,
            data_out_valid_local => data_out_valid_D,
            data_out_vc_busy_local => data_out_vc_busy_D,
            data_out_vc_credits_local => data_out_vc_credits_D,
            
            -- ROUTER TO ROUTER INTERFACE
            -- NORTH
            data_in_north => data_B_to_D,
            data_in_valid_north => data_valid_B_to_D,
            data_in_vc_busy_north => vc_busy_D_to_B,
            data_in_vc_credits_north => vc_credits_D_to_B,
            
            data_out_north => data_D_to_B,
            data_out_valid_north => data_valid_D_to_B,
            data_out_vc_busy_north => vc_busy_B_to_D,
            data_out_vc_credits_north => vc_credits_B_to_D,
            
            -- ROUTER TO ROUTER INTERFACE
            -- EAST
            data_in_east => (others => '0'),
            data_in_valid_east => '0',
            data_in_vc_busy_east => open,
            data_in_vc_credits_east => open,
            
            data_out_east => open,
            data_out_valid_east => open,
            data_out_vc_busy_east => (others => '0'),
            data_out_vc_credits_east => (others => '0'),
            
            -- ROUTER TO ROUTER INTERFACE
            -- SOUTH
            data_in_south => (others => '0'),
            data_in_valid_south => '0',
            data_in_vc_busy_south => open,
            data_in_vc_credits_south => open,
            
            data_out_south => open,
            data_out_valid_south => open,
            data_out_vc_busy_south => (others => '0'),
            data_out_vc_credits_south => (others => '0'),
            
            -- ROUTER TO ROUTER INTERFACE
            -- WEST
            data_in_west => data_C_to_D,
            data_in_valid_west => data_valid_C_to_D,
            data_in_vc_busy_west => vc_busy_D_to_C,
            data_in_vc_credits_west => vc_credits_D_to_C,
            
            data_out_west => data_D_to_C,
            data_out_valid_west => data_valid_D_to_C,
            data_out_vc_busy_west => vc_busy_C_to_D,
            data_out_vc_credits_west => vc_credits_C_to_D
        );

end Behavioral;