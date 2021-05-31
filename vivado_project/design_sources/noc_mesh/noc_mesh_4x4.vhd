----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/29/2021 01:29:50 PM
-- Design Name: NoC_Mesh
-- Module Name: noc_mesh_4x4 - Behavioral
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
-- Revision 0.1 - 2021-05-29 - Ramljak
-- Additional Comments: Genericka 4x4 noc mreza
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

entity noc_mesh_4x4 is

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
        
        -- ROUTER C (41)
        data_in_C : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid_C : in std_logic;
        data_in_vc_busy_C : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits_C : out std_logic_vector(vc_num - 1 downto 0);
        
        data_out_C : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid_C : out std_logic;
        data_out_vc_busy_C : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits_C : in std_logic_vector(vc_num - 1 downto 0);
        
        -- ROUTER D (81)
        data_in_D : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid_D : in std_logic;
        data_in_vc_busy_D : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits_D : out std_logic_vector(vc_num - 1 downto 0);
        
        data_out_D : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid_D : out std_logic;
        data_out_vc_busy_D : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits_D : in std_logic_vector(vc_num - 1 downto 0);
    
        -- ROUTER E (12)
        data_in_E : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid_E : in std_logic;
        data_in_vc_busy_E : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits_E : out std_logic_vector(vc_num - 1 downto 0);
        
        data_out_E : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid_E : out std_logic;
        data_out_vc_busy_E : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits_E : in std_logic_vector(vc_num - 1 downto 0);
        
        -- ROUTER F (22)
        data_in_F : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid_F : in std_logic;
        data_in_vc_busy_F : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits_F : out std_logic_vector(vc_num - 1 downto 0);
        
        data_out_F : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid_F : out std_logic;
        data_out_vc_busy_F : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits_F : in std_logic_vector(vc_num - 1 downto 0);
        
        -- ROUTER G (42)
        data_in_G : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid_G : in std_logic;
        data_in_vc_busy_G : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits_G : out std_logic_vector(vc_num - 1 downto 0);
        
        data_out_G : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid_G : out std_logic;
        data_out_vc_busy_G : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits_G : in std_logic_vector(vc_num - 1 downto 0);
        
        -- ROUTER H (82)
        data_in_H : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid_H : in std_logic;
        data_in_vc_busy_H : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits_H : out std_logic_vector(vc_num - 1 downto 0);
        
        data_out_H : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid_H : out std_logic;
        data_out_vc_busy_H : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits_H : in std_logic_vector(vc_num - 1 downto 0);
        
        -- ROUTER I (14)
        data_in_I : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid_I : in std_logic;
        data_in_vc_busy_I : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits_I : out std_logic_vector(vc_num - 1 downto 0);
        
        data_out_I : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid_I : out std_logic;
        data_out_vc_busy_I : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits_I : in std_logic_vector(vc_num - 1 downto 0);
        
        -- ROUTER J (24)
        data_in_J : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid_J : in std_logic;
        data_in_vc_busy_J : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits_J : out std_logic_vector(vc_num - 1 downto 0);
        
        data_out_J : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid_J : out std_logic;
        data_out_vc_busy_J : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits_J : in std_logic_vector(vc_num - 1 downto 0);
        
        -- ROUTER K (44)
        data_in_K : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid_K : in std_logic;
        data_in_vc_busy_K : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits_K : out std_logic_vector(vc_num - 1 downto 0);
        
        data_out_K : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid_K : out std_logic;
        data_out_vc_busy_K : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits_K : in std_logic_vector(vc_num - 1 downto 0);
        
        -- ROUTER L (84)
        data_in_L : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid_L : in std_logic;
        data_in_vc_busy_L : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits_L : out std_logic_vector(vc_num - 1 downto 0);
        
        data_out_L : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid_L : out std_logic;
        data_out_vc_busy_L : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits_L : in std_logic_vector(vc_num - 1 downto 0);
        
        -- ROUTER M (18)
        data_in_M : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid_M : in std_logic;
        data_in_vc_busy_M : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits_M : out std_logic_vector(vc_num - 1 downto 0);
        
        data_out_M : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid_M : out std_logic;
        data_out_vc_busy_M : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits_M : in std_logic_vector(vc_num - 1 downto 0);
        
        -- ROUTER N (28)
        data_in_N : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid_N : in std_logic;
        data_in_vc_busy_N : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits_N : out std_logic_vector(vc_num - 1 downto 0);
        
        data_out_N : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid_N : out std_logic;
        data_out_vc_busy_N : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits_N : in std_logic_vector(vc_num - 1 downto 0);
        
        -- ROUTER O (48)
        data_in_O : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid_O : in std_logic;
        data_in_vc_busy_O : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits_O : out std_logic_vector(vc_num - 1 downto 0);
        
        data_out_O : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid_O : out std_logic;
        data_out_vc_busy_O : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits_O : in std_logic_vector(vc_num - 1 downto 0);
        
        -- ROUTER P (88)
        data_in_P : in std_logic_vector(flit_size - 1 downto 0);
        data_in_valid_P : in std_logic;
        data_in_vc_busy_P : out std_logic_vector(vc_num - 1 downto 0);
        data_in_vc_credits_P : out std_logic_vector(vc_num - 1 downto 0);
        
        data_out_P : out std_logic_vector(flit_size - 1 downto 0);
        data_out_valid_P : out std_logic;
        data_out_vc_busy_P : in std_logic_vector(vc_num - 1 downto 0);
        data_out_vc_credits_P : in std_logic_vector(vc_num - 1 downto 0)
    );

end noc_mesh_4x4;

architecture Behavioral of noc_mesh_4x4 is

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
    
    -- MEDUKONEKCIJE ROUTER B (21) - ROUTER C (41)
    signal data_B_to_C : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_B_to_C : std_logic;
    signal vc_busy_C_to_B : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_C_to_B : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_C_to_B : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_C_to_B : std_logic;
    signal vc_busy_B_to_C : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_B_to_C : std_logic_vector(const_vc_num - 1 downto 0);

    -- MEDUKONEKCIJE ROUTER C (41) - ROUTER D (81)
    signal data_C_to_D : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_C_to_D : std_logic;
    signal vc_busy_D_to_C : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_D_to_C : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_D_to_C : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_D_to_C : std_logic;
    signal vc_busy_C_to_D : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_C_to_D : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER A (11) - ROUTER E (12)
    signal data_A_to_E : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_A_to_E : std_logic;
    signal vc_busy_E_to_A : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_E_to_A : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_E_to_A : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_E_to_A : std_logic;
    signal vc_busy_A_to_E : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_A_to_E : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER B (21) - ROUTER F (22)
    signal data_B_to_F : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_B_to_F : std_logic;
    signal vc_busy_F_to_B : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_F_to_B : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_F_to_B : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_F_to_B : std_logic;
    signal vc_busy_B_to_F : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_B_to_F : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER C (41) - ROUTER G (42)
    signal data_C_to_G : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_C_to_G : std_logic;
    signal vc_busy_G_to_C : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_G_to_C : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_G_to_C : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_G_to_C : std_logic;
    signal vc_busy_C_to_G : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_C_to_G : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER D (81) - ROUTER H (82)
    signal data_D_to_H : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_D_to_H : std_logic;
    signal vc_busy_H_to_D : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_H_to_D : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_H_to_D : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_H_to_D : std_logic;
    signal vc_busy_D_to_H : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_D_to_H : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER E (12) - ROUTER F (22)
    signal data_E_to_F : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_E_to_F : std_logic;
    signal vc_busy_F_to_E : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_F_to_E : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_F_to_E : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_F_to_E : std_logic;
    signal vc_busy_E_to_F : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_E_to_F : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER F (22) - ROUTER G (42)
    signal data_F_to_G : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_F_to_G : std_logic;
    signal vc_busy_G_to_F : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_G_to_F : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_G_to_F : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_G_to_F : std_logic;
    signal vc_busy_F_to_G : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_F_to_G : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER G (42) - ROUTER H (82)
    signal data_G_to_H : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_G_to_H : std_logic;
    signal vc_busy_H_to_G : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_H_to_G : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_H_to_G : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_H_to_G : std_logic;
    signal vc_busy_G_to_H : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_G_to_H : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER E (12) - ROUTER I (14)
    signal data_E_to_I : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_E_to_I : std_logic;
    signal vc_busy_I_to_E : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_I_to_E : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_I_to_E : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_I_to_E : std_logic;
    signal vc_busy_E_to_I : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_E_to_I : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER F (22) - ROUTER J (24)
    signal data_F_to_J : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_F_to_J : std_logic;
    signal vc_busy_J_to_F : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_J_to_F : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_J_to_F : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_J_to_F : std_logic;
    signal vc_busy_F_to_J : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_F_to_J : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER G (42) - ROUTER K (44)
    signal data_G_to_K : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_G_to_K : std_logic;
    signal vc_busy_K_to_G : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_K_to_G : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_K_to_G : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_K_to_G : std_logic;
    signal vc_busy_G_to_K : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_G_to_K : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER H (82) - ROUTER L (84)
    signal data_H_to_L : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_H_to_L : std_logic;
    signal vc_busy_L_to_H : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_L_to_H : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_L_to_H : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_L_to_H : std_logic;
    signal vc_busy_H_to_L : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_H_to_L : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER I (14) - ROUTER J (24)
    signal data_I_to_J : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_I_to_J : std_logic;
    signal vc_busy_J_to_I : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_J_to_I : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_J_to_I : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_J_to_I : std_logic;
    signal vc_busy_I_to_J : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_I_to_J : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER J (24) - ROUTER K (44)
    signal data_J_to_K : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_J_to_K : std_logic;
    signal vc_busy_K_to_J : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_K_to_J : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_K_to_J : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_K_to_J : std_logic;
    signal vc_busy_J_to_K : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_J_to_K : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER K (44) - ROUTER L (84)
    signal data_K_to_L : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_K_to_L : std_logic;
    signal vc_busy_L_to_K : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_L_to_K : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_L_to_K : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_L_to_K : std_logic;
    signal vc_busy_K_to_L : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_K_to_L : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER I (14) - ROUTER M (18)
    signal data_I_to_M : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_I_to_M : std_logic;
    signal vc_busy_M_to_I : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_M_to_I : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_M_to_I : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_M_to_I : std_logic;
    signal vc_busy_I_to_M : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_I_to_M : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER J (24) - ROUTER N (28)
    signal data_J_to_N : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_J_to_N : std_logic;
    signal vc_busy_N_to_J : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_N_to_J : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_N_to_J : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_N_to_J : std_logic;
    signal vc_busy_J_to_N : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_J_to_N : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER K (44) - ROUTER O (48)
    signal data_K_to_O : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_K_to_O : std_logic;
    signal vc_busy_O_to_K : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_O_to_K : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_O_to_K : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_O_to_K : std_logic;
    signal vc_busy_K_to_O : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_K_to_O : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER L (84) - ROUTER P (88)
    signal data_L_to_P : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_L_to_P : std_logic;
    signal vc_busy_P_to_L : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_P_to_L : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_P_to_L : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_P_to_L : std_logic;
    signal vc_busy_L_to_P : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_L_to_P : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER M (18) - ROUTER N (28)
    signal data_M_to_N : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_M_to_N : std_logic;
    signal vc_busy_N_to_M : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_N_to_M : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_N_to_M : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_N_to_M : std_logic;
    signal vc_busy_M_to_N : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_M_to_N : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER N (28) - ROUTER O (48)
    signal data_N_to_O : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_N_to_O : std_logic;
    signal vc_busy_O_to_N : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_O_to_N : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_O_to_N : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_O_to_N : std_logic;
    signal vc_busy_N_to_O : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_N_to_O : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- MEDUKONEKCIJE ROUTER O (48) - ROUTER P (88)
    signal data_O_to_P : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_O_to_P : std_logic;
    signal vc_busy_P_to_O : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_P_to_O : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_P_to_O : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_P_to_O : std_logic;
    signal vc_busy_O_to_P : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_O_to_P : std_logic_vector(const_vc_num - 1 downto 0);

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
            data_in_south => data_E_to_A,
            data_in_valid_south => data_valid_E_to_A,
            data_in_vc_busy_south => vc_busy_A_to_E,
            data_in_vc_credits_south => vc_credits_A_to_E,
            
            data_out_south => data_A_to_E,
            data_out_valid_south => data_valid_A_to_E,
            data_out_vc_busy_south => vc_busy_E_to_A,
            data_out_vc_credits_south => vc_credits_E_to_A,
            
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
            data_in_east => data_C_to_B,
            data_in_valid_east => data_valid_C_to_B,
            data_in_vc_busy_east => vc_busy_B_to_C,
            data_in_vc_credits_east => vc_credits_B_to_C,
            
            data_out_east => data_B_to_C,
            data_out_valid_east => data_valid_B_to_C,
            data_out_vc_busy_east => vc_busy_C_to_B,
            data_out_vc_credits_east => vc_credits_C_to_B,
            
            -- ROUTER TO ROUTER INTERFACE
            -- SOUTH
            data_in_south => data_F_to_B,
            data_in_valid_south => data_valid_F_to_B,
            data_in_vc_busy_south => vc_busy_B_to_F,
            data_in_vc_credits_south => vc_credits_B_to_F,
            
            data_out_south => data_B_to_F,
            data_out_valid_south => data_valid_B_to_F,
            data_out_vc_busy_south => vc_busy_F_to_B,
            data_out_vc_credits_south => vc_credits_F_to_B,
            
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
        
    -- noc_router KOMPONENTA - ROUTER C (41)
    router_C: noc_router
    
        generic map (
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => "0100",
            local_address_y => "0001",
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
            data_in_east => data_C_to_B,
            data_in_valid_east => data_valid_C_to_B,
            data_in_vc_busy_east => vc_busy_B_to_C,
            data_in_vc_credits_east => vc_credits_B_to_C,
            
            data_out_east => data_B_to_C,
            data_out_valid_east => data_valid_B_to_C,
            data_out_vc_busy_east => vc_busy_C_to_B,
            data_out_vc_credits_east => vc_credits_C_to_B,
            
            -- ROUTER TO ROUTER INTERFACE
            -- SOUTH
            data_in_south => data_G_to_C,
            data_in_valid_south => data_valid_G_to_C,
            data_in_vc_busy_south => vc_busy_C_to_G,
            data_in_vc_credits_south => vc_credits_C_to_G,
            
            data_out_south => data_C_to_G,
            data_out_valid_south => data_valid_C_to_G,
            data_out_vc_busy_south => vc_busy_G_to_C,
            data_out_vc_credits_south => vc_credits_G_to_C,
            
            -- ROUTER TO ROUTER INTERFACE
            -- WEST
            data_in_west => data_B_to_C,
            data_in_valid_west => data_valid_B_to_C,
            data_in_vc_busy_west => vc_busy_C_to_B,
            data_in_vc_credits_west => vc_credits_C_to_B,
            
            data_out_west => data_C_to_B,
            data_out_valid_west => data_valid_C_to_B,
            data_out_vc_busy_west => vc_busy_B_to_C,
            data_out_vc_credits_west => vc_credits_B_to_C
        );
        
    -- noc_router KOMPONENTA - ROUTER D (81)
    router_D: noc_router
    
        generic map (
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => "1000",
            local_address_y => "0001",
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
            data_out_vc_credits_local =>  data_out_vc_credits_D,
            
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
            data_in_south => data_H_to_D,
            data_in_valid_south => data_valid_H_to_D,
            data_in_vc_busy_south => vc_busy_D_to_H,
            data_in_vc_credits_south => vc_credits_D_to_H,
            
            data_out_south => data_D_to_H,
            data_out_valid_south => data_valid_D_to_H,
            data_out_vc_busy_south => vc_busy_H_to_D,
            data_out_vc_credits_south => vc_credits_H_to_D,
            
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

    -- noc_router KOMPONENTA - ROUTER E (12)
    router_E: noc_router
    
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
            diagonal_pref => VER
        )
        
        port map(
            clk => clk,
            rst => rst,
            
            -- ROUTER TO ROUTER INTERFACE
            -- LOCAL
            data_in_local => data_in_E,
            data_in_valid_local => data_in_valid_E,
            data_in_vc_busy_local => data_in_vc_busy_E,
            data_in_vc_credits_local => data_in_vc_credits_E,
            
            data_out_local => data_out_E,
            data_out_valid_local => data_out_valid_E,
            data_out_vc_busy_local => data_out_vc_busy_E,
            data_out_vc_credits_local =>  data_out_vc_credits_E,
            
            -- ROUTER TO ROUTER INTERFACE
            -- NORTH
            data_in_north => data_A_to_E,
            data_in_valid_north => data_valid_A_to_E,
            data_in_vc_busy_north => vc_busy_E_to_A,
            data_in_vc_credits_north => vc_credits_E_to_A,
            
            data_out_north => data_E_to_A,
            data_out_valid_north => data_valid_E_to_A,
            data_out_vc_busy_north => vc_busy_A_to_E,
            data_out_vc_credits_north => vc_credits_A_to_E,
            
            -- ROUTER TO ROUTER INTERFACE
            -- EAST
            data_in_east => data_F_to_E,
            data_in_valid_east => data_valid_F_to_E,
            data_in_vc_busy_east => vc_busy_E_to_F,
            data_in_vc_credits_east => vc_credits_E_to_F,
            
            data_out_east => data_E_to_F,
            data_out_valid_east => data_valid_E_to_F,
            data_out_vc_busy_east => vc_busy_F_to_E,
            data_out_vc_credits_east => vc_credits_F_to_E,
            
            -- ROUTER TO ROUTER INTERFACE
            -- SOUTH
            data_in_south => data_I_to_E,
            data_in_valid_south => data_valid_I_to_E,
            data_in_vc_busy_south => vc_busy_E_to_I,
            data_in_vc_credits_south => vc_credits_E_to_I,
            
            data_out_south => data_E_to_I,
            data_out_valid_south => data_valid_E_to_I,
            data_out_vc_busy_south => vc_busy_I_to_E,
            data_out_vc_credits_south => vc_credits_I_to_E,
            
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
        
    -- noc_router KOMPONENTA - ROUTER F (22)
    router_F: noc_router
    
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
            diagonal_pref => VER
        )
        
        port map(
            clk => clk,
            rst => rst,
            
            -- ROUTER TO ROUTER INTERFACE
            -- LOCAL
            data_in_local => data_in_F,
            data_in_valid_local => data_in_valid_F,
            data_in_vc_busy_local => data_in_vc_busy_F,
            data_in_vc_credits_local => data_in_vc_credits_F,
            
            data_out_local => data_out_F,
            data_out_valid_local => data_out_valid_F,
            data_out_vc_busy_local => data_out_vc_busy_F,
            data_out_vc_credits_local =>  data_out_vc_credits_F,
            
            -- ROUTER TO ROUTER INTERFACE
            -- NORTH
            data_in_north => data_B_to_F,
            data_in_valid_north => data_valid_B_to_F,
            data_in_vc_busy_north => vc_busy_F_to_B,
            data_in_vc_credits_north => vc_credits_F_to_B,
            
            data_out_north => data_F_to_B,
            data_out_valid_north => data_valid_F_to_B,
            data_out_vc_busy_north => vc_busy_B_to_F,
            data_out_vc_credits_north => vc_credits_B_to_F,
            
            -- ROUTER TO ROUTER INTERFACE
            -- EAST
            data_in_east => data_G_to_F,
            data_in_valid_east => data_valid_G_to_F,
            data_in_vc_busy_east => vc_busy_F_to_G,
            data_in_vc_credits_east => vc_credits_F_to_G,
            
            data_out_east => data_F_to_G,
            data_out_valid_east => data_valid_F_to_G,
            data_out_vc_busy_east => vc_busy_G_to_F,
            data_out_vc_credits_east => vc_credits_G_to_F,
            
            -- ROUTER TO ROUTER INTERFACE
            -- SOUTH
            data_in_south => data_J_to_F,
            data_in_valid_south => data_valid_J_to_F,
            data_in_vc_busy_south => vc_busy_F_to_J,
            data_in_vc_credits_south => vc_credits_F_to_J,
            
            data_out_south => data_F_to_J,
            data_out_valid_south => data_valid_F_to_J,
            data_out_vc_busy_south => vc_busy_J_to_F,
            data_out_vc_credits_south => vc_credits_J_to_F,
            
            -- ROUTER TO ROUTER INTERFACE
            -- WEST
            data_in_west => data_E_to_F,
            data_in_valid_west => data_valid_E_to_F,
            data_in_vc_busy_west => vc_busy_F_to_E,
            data_in_vc_credits_west => vc_credits_F_to_E,
            
            data_out_west => data_F_to_E,
            data_out_valid_west => data_valid_F_to_E,
            data_out_vc_busy_west => vc_busy_E_to_F,
            data_out_vc_credits_west => vc_credits_E_to_F
        );
        
    -- noc_router KOMPONENTA - ROUTER G (42)
    router_G: noc_router
    
        generic map (
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => "0100",
            local_address_y => "0010",
            clock_divider => clock_divider,
            diagonal_pref => VER
        )
        
        port map(
            clk => clk,
            rst => rst,
            
            -- ROUTER TO ROUTER INTERFACE
            -- LOCAL
            data_in_local => data_in_G,
            data_in_valid_local => data_in_valid_G,
            data_in_vc_busy_local => data_in_vc_busy_G,
            data_in_vc_credits_local => data_in_vc_credits_G,
            
            data_out_local => data_out_G,
            data_out_valid_local => data_out_valid_G,
            data_out_vc_busy_local => data_out_vc_busy_G,
            data_out_vc_credits_local =>  data_out_vc_credits_G,
            
            -- ROUTER TO ROUTER INTERFACE
            -- NORTH
            data_in_north => data_C_to_G,
            data_in_valid_north => data_valid_C_to_G,
            data_in_vc_busy_north => vc_busy_G_to_C,
            data_in_vc_credits_north => vc_credits_G_to_C,
            
            data_out_north => data_G_to_C,
            data_out_valid_north => data_valid_G_to_C,
            data_out_vc_busy_north => vc_busy_C_to_G,
            data_out_vc_credits_north => vc_credits_C_to_G,
            
            -- ROUTER TO ROUTER INTERFACE
            -- EAST
            data_in_east => data_H_to_G,
            data_in_valid_east => data_valid_H_to_G,
            data_in_vc_busy_east => vc_busy_G_to_H,
            data_in_vc_credits_east => vc_credits_G_to_H,
            
            data_out_east => data_G_to_H,
            data_out_valid_east => data_valid_G_to_H,
            data_out_vc_busy_east => vc_busy_H_to_G,
            data_out_vc_credits_east => vc_credits_H_to_G,
            
            -- ROUTER TO ROUTER INTERFACE
            -- SOUTH
            data_in_south => data_K_to_G,
            data_in_valid_south => data_valid_K_to_G,
            data_in_vc_busy_south => vc_busy_G_to_K,
            data_in_vc_credits_south => vc_credits_G_to_K,
            
            data_out_south => data_G_to_K,
            data_out_valid_south => data_valid_G_to_K,
            data_out_vc_busy_south => vc_busy_K_to_G,
            data_out_vc_credits_south => vc_credits_K_to_G,
            
            -- ROUTER TO ROUTER INTERFACE
            -- WEST
            data_in_west => data_F_to_G,
            data_in_valid_west => data_valid_F_to_G,
            data_in_vc_busy_west => vc_busy_G_to_F,
            data_in_vc_credits_west => vc_credits_G_to_F,
            
            data_out_west => data_G_to_F,
            data_out_valid_west => data_valid_G_to_F,
            data_out_vc_busy_west => vc_busy_F_to_G,
            data_out_vc_credits_west => vc_credits_F_to_G
        );
        
    -- noc_router KOMPONENTA - ROUTER H (82)
    router_H: noc_router
    
        generic map (
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => "1000",
            local_address_y => "0010",
            clock_divider => clock_divider,
            diagonal_pref => VER
        )
        
        port map(
            clk => clk,
            rst => rst,
            
            -- ROUTER TO ROUTER INTERFACE
            -- LOCAL
            data_in_local => data_in_H,
            data_in_valid_local => data_in_valid_H,
            data_in_vc_busy_local => data_in_vc_busy_H,
            data_in_vc_credits_local => data_in_vc_credits_H,
            
            data_out_local => data_out_H,
            data_out_valid_local => data_out_valid_H,
            data_out_vc_busy_local => data_out_vc_busy_H,
            data_out_vc_credits_local =>  data_out_vc_credits_H,
            
            -- ROUTER TO ROUTER INTERFACE
            -- NORTH
            data_in_north => data_D_to_H,
            data_in_valid_north => data_valid_D_to_H,
            data_in_vc_busy_north => vc_busy_H_to_D,
            data_in_vc_credits_north => vc_credits_H_to_D,
            
            data_out_north => data_H_to_D,
            data_out_valid_north => data_valid_H_to_D,
            data_out_vc_busy_north => vc_busy_D_to_H,
            data_out_vc_credits_north => vc_credits_D_to_H,
            
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
            data_in_south => data_L_to_H,
            data_in_valid_south => data_valid_L_to_H,
            data_in_vc_busy_south => vc_busy_H_to_L,
            data_in_vc_credits_south => vc_credits_H_to_L,
            
            data_out_south => data_H_to_L,
            data_out_valid_south => data_valid_H_to_L,
            data_out_vc_busy_south => vc_busy_L_to_H,
            data_out_vc_credits_south => vc_credits_L_to_H,
            
            -- ROUTER TO ROUTER INTERFACE
            -- WEST
            data_in_west => data_G_to_H,
            data_in_valid_west => data_valid_G_to_H,
            data_in_vc_busy_west => vc_busy_H_to_G,
            data_in_vc_credits_west => vc_credits_H_to_G,
            
            data_out_west => data_H_to_G,
            data_out_valid_west => data_valid_H_to_G,
            data_out_vc_busy_west => vc_busy_G_to_H,
            data_out_vc_credits_west => vc_credits_G_to_H
        );
        
    -- noc_router KOMPONENTA - ROUTER I (14)
    router_I: noc_router
    
        generic map (
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => "0001",
            local_address_y => "0100",
            clock_divider => clock_divider,
            diagonal_pref => HOR
        )
        
        port map(
            clk => clk,
            rst => rst,
            
            -- ROUTER TO ROUTER INTERFACE
            -- LOCAL
            data_in_local => data_in_I,
            data_in_valid_local => data_in_valid_I,
            data_in_vc_busy_local => data_in_vc_busy_I,
            data_in_vc_credits_local => data_in_vc_credits_I,
            
            data_out_local => data_out_I,
            data_out_valid_local => data_out_valid_I,
            data_out_vc_busy_local => data_out_vc_busy_I,
            data_out_vc_credits_local =>  data_out_vc_credits_I,
            
            -- ROUTER TO ROUTER INTERFACE
            -- NORTH
            data_in_north => data_E_to_I,
            data_in_valid_north => data_valid_E_to_I,
            data_in_vc_busy_north => vc_busy_I_to_E,
            data_in_vc_credits_north => vc_credits_I_to_E,
            
            data_out_north => data_I_to_E,
            data_out_valid_north => data_valid_I_to_E,
            data_out_vc_busy_north => vc_busy_E_to_I,
            data_out_vc_credits_north => vc_credits_E_to_I,
            
            -- ROUTER TO ROUTER INTERFACE
            -- EAST
            data_in_east => data_J_to_I,
            data_in_valid_east => data_valid_J_to_I,
            data_in_vc_busy_east => vc_busy_I_to_J,
            data_in_vc_credits_east => vc_credits_I_to_J,
            
            data_out_east => data_I_to_J,
            data_out_valid_east => data_valid_I_to_J,
            data_out_vc_busy_east => vc_busy_J_to_I,
            data_out_vc_credits_east => vc_credits_J_to_I,
            
            -- ROUTER TO ROUTER INTERFACE
            -- SOUTH
            data_in_south => data_M_to_I,
            data_in_valid_south => data_valid_M_to_I,
            data_in_vc_busy_south => vc_busy_I_to_M,
            data_in_vc_credits_south => vc_credits_I_to_M,
            
            data_out_south => data_I_to_M,
            data_out_valid_south => data_valid_I_to_M,
            data_out_vc_busy_south => vc_busy_M_to_I,
            data_out_vc_credits_south => vc_credits_M_to_I,
            
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
        
    -- noc_router KOMPONENTA - ROUTER J (24)
    router_J: noc_router
    
        generic map (
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => "0010",
            local_address_y => "0100",
            clock_divider => clock_divider,
            diagonal_pref => HOR
        )
        
        port map(
            clk => clk,
            rst => rst,
            
            -- ROUTER TO ROUTER INTERFACE
            -- LOCAL
            data_in_local => data_in_J,
            data_in_valid_local => data_in_valid_J,
            data_in_vc_busy_local => data_in_vc_busy_J,
            data_in_vc_credits_local => data_in_vc_credits_J,
            
            data_out_local => data_out_J,
            data_out_valid_local => data_out_valid_J,
            data_out_vc_busy_local => data_out_vc_busy_J,
            data_out_vc_credits_local =>  data_out_vc_credits_J,
            
            -- ROUTER TO ROUTER INTERFACE
            -- NORTH
            data_in_north => data_F_to_J,
            data_in_valid_north => data_valid_F_to_J,
            data_in_vc_busy_north => vc_busy_J_to_F,
            data_in_vc_credits_north => vc_credits_J_to_F,
            
            data_out_north => data_J_to_F,
            data_out_valid_north => data_valid_J_to_F,
            data_out_vc_busy_north => vc_busy_F_to_J,
            data_out_vc_credits_north => vc_credits_F_to_J,
            
            -- ROUTER TO ROUTER INTERFACE
            -- EAST
            data_in_east => data_K_to_J,
            data_in_valid_east => data_valid_K_to_J,
            data_in_vc_busy_east => vc_busy_J_to_K,
            data_in_vc_credits_east => vc_credits_J_to_K,
            
            data_out_east => data_J_to_K,
            data_out_valid_east => data_valid_J_to_K,
            data_out_vc_busy_east => vc_busy_K_to_J,
            data_out_vc_credits_east => vc_credits_K_to_J,
            
            -- ROUTER TO ROUTER INTERFACE
            -- SOUTH
            data_in_south => data_N_to_J,
            data_in_valid_south => data_valid_N_to_J,
            data_in_vc_busy_south => vc_busy_J_to_N,
            data_in_vc_credits_south => vc_credits_J_to_N,
            
            data_out_south => data_J_to_N,
            data_out_valid_south => data_valid_J_to_N,
            data_out_vc_busy_south => vc_busy_N_to_J,
            data_out_vc_credits_south => vc_credits_N_to_J,
            
            -- ROUTER TO ROUTER INTERFACE
            -- WEST
            data_in_west => data_I_to_J,
            data_in_valid_west => data_valid_I_to_J,
            data_in_vc_busy_west => vc_busy_J_to_I,
            data_in_vc_credits_west => vc_credits_J_to_I,
            
            data_out_west => data_J_to_I,
            data_out_valid_west => data_valid_J_to_I,
            data_out_vc_busy_west => vc_busy_I_to_J,
            data_out_vc_credits_west => vc_credits_I_to_J
        );
        
    -- noc_router KOMPONENTA - ROUTER K (44)
    router_K: noc_router
    
        generic map (
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => "0100",
            local_address_y => "0100",
            clock_divider => clock_divider,
            diagonal_pref => HOR
        )
        
        port map(
            clk => clk,
            rst => rst,
            
            -- ROUTER TO ROUTER INTERFACE
            -- LOCAL
            data_in_local => data_in_K,
            data_in_valid_local => data_in_valid_K,
            data_in_vc_busy_local => data_in_vc_busy_K,
            data_in_vc_credits_local => data_in_vc_credits_K,
            
            data_out_local => data_out_K,
            data_out_valid_local => data_out_valid_K,
            data_out_vc_busy_local => data_out_vc_busy_K,
            data_out_vc_credits_local =>  data_out_vc_credits_K,
            
            -- ROUTER TO ROUTER INTERFACE
            -- NORTH
            data_in_north => data_G_to_K,
            data_in_valid_north => data_valid_G_to_K,
            data_in_vc_busy_north => vc_busy_K_to_G,
            data_in_vc_credits_north => vc_credits_K_to_G,
            
            data_out_north => data_K_to_G,
            data_out_valid_north => data_valid_K_to_G,
            data_out_vc_busy_north => vc_busy_G_to_K,
            data_out_vc_credits_north => vc_credits_G_to_K,
            
            -- ROUTER TO ROUTER INTERFACE
            -- EAST
            data_in_east => data_L_to_K,
            data_in_valid_east => data_valid_L_to_K,
            data_in_vc_busy_east => vc_busy_K_to_L,
            data_in_vc_credits_east => vc_credits_K_to_L,
            
            data_out_east => data_K_to_L,
            data_out_valid_east => data_valid_K_to_L,
            data_out_vc_busy_east => vc_busy_L_to_K,
            data_out_vc_credits_east => vc_credits_L_to_K,
            
            -- ROUTER TO ROUTER INTERFACE
            -- SOUTH
            data_in_south => data_O_to_K,
            data_in_valid_south => data_valid_O_to_K,
            data_in_vc_busy_south => vc_busy_K_to_O,
            data_in_vc_credits_south => vc_credits_K_to_O,
            
            data_out_south => data_K_to_O,
            data_out_valid_south => data_valid_K_to_O,
            data_out_vc_busy_south => vc_busy_O_to_K,
            data_out_vc_credits_south => vc_credits_O_to_K,
            
            -- ROUTER TO ROUTER INTERFACE
            -- WEST
            data_in_west => data_J_to_K,
            data_in_valid_west => data_valid_J_to_K,
            data_in_vc_busy_west => vc_busy_K_to_J,
            data_in_vc_credits_west => vc_credits_K_to_J,
            
            data_out_west => data_K_to_J,
            data_out_valid_west => data_valid_K_to_J,
            data_out_vc_busy_west => vc_busy_J_to_K,
            data_out_vc_credits_west => vc_credits_J_to_K
        );
        
    -- noc_router KOMPONENTA - ROUTER L (84)
    router_L: noc_router
    
        generic map (
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => "1000",
            local_address_y => "0100",
            clock_divider => clock_divider,
            diagonal_pref => HOR
        )
        
        port map(
            clk => clk,
            rst => rst,
            
            -- ROUTER TO ROUTER INTERFACE
            -- LOCAL
            data_in_local => data_in_L,
            data_in_valid_local => data_in_valid_L,
            data_in_vc_busy_local => data_in_vc_busy_L,
            data_in_vc_credits_local => data_in_vc_credits_L,
            
            data_out_local => data_out_L,
            data_out_valid_local => data_out_valid_L,
            data_out_vc_busy_local => data_out_vc_busy_L,
            data_out_vc_credits_local =>  data_out_vc_credits_L,
            
            -- ROUTER TO ROUTER INTERFACE
            -- NORTH
            data_in_north => data_H_to_L,
            data_in_valid_north => data_valid_H_to_L,
            data_in_vc_busy_north => vc_busy_L_to_H,
            data_in_vc_credits_north => vc_credits_L_to_H,
            
            data_out_north => data_L_to_H,
            data_out_valid_north => data_valid_L_to_H,
            data_out_vc_busy_north => vc_busy_H_to_L,
            data_out_vc_credits_north => vc_credits_H_to_L,
            
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
            data_in_south => data_P_to_L,
            data_in_valid_south => data_valid_P_to_L,
            data_in_vc_busy_south => vc_busy_L_to_P,
            data_in_vc_credits_south => vc_credits_L_to_P,
            
            data_out_south => data_L_to_P,
            data_out_valid_south => data_valid_L_to_P,
            data_out_vc_busy_south => vc_busy_P_to_L,
            data_out_vc_credits_south => vc_credits_P_to_L,
            
            -- ROUTER TO ROUTER INTERFACE
            -- WEST
            data_in_west => data_K_to_L,
            data_in_valid_west => data_valid_K_to_L,
            data_in_vc_busy_west => vc_busy_L_to_K,
            data_in_vc_credits_west => vc_credits_L_to_K,
            
            data_out_west => data_L_to_K,
            data_out_valid_west => data_valid_L_to_K,
            data_out_vc_busy_west => vc_busy_K_to_L,
            data_out_vc_credits_west => vc_credits_K_to_L
        );
        
    -- noc_router KOMPONENTA - ROUTER M (18)
    router_M: noc_router
    
        generic map (
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => "0001",
            local_address_y => "1000",
            clock_divider => clock_divider,
            diagonal_pref => VER
        )
        
        port map(
            clk => clk,
            rst => rst,
            
            -- ROUTER TO ROUTER INTERFACE
            -- LOCAL
            data_in_local => data_in_M,
            data_in_valid_local => data_in_valid_M,
            data_in_vc_busy_local => data_in_vc_busy_M,
            data_in_vc_credits_local => data_in_vc_credits_M,
            
            data_out_local => data_out_M,
            data_out_valid_local => data_out_valid_M,
            data_out_vc_busy_local => data_out_vc_busy_M,
            data_out_vc_credits_local =>  data_out_vc_credits_M,
            
            -- ROUTER TO ROUTER INTERFACE
            -- NORTH
            data_in_north => data_I_to_M,
            data_in_valid_north => data_valid_I_to_M,
            data_in_vc_busy_north => vc_busy_M_to_I,
            data_in_vc_credits_north => vc_credits_M_to_I,
            
            data_out_north => data_M_to_I,
            data_out_valid_north => data_valid_M_to_I,
            data_out_vc_busy_north => vc_busy_I_to_M,
            data_out_vc_credits_north => vc_credits_I_to_M,
            
            -- ROUTER TO ROUTER INTERFACE
            -- EAST
            data_in_east => data_N_to_M,
            data_in_valid_east => data_valid_N_to_M,
            data_in_vc_busy_east => vc_busy_M_to_N,
            data_in_vc_credits_east => vc_credits_M_to_N,
            
            data_out_east => data_M_to_N,
            data_out_valid_east => data_valid_M_to_N,
            data_out_vc_busy_east => vc_busy_N_to_M,
            data_out_vc_credits_east => vc_credits_N_to_M,
            
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
        
    -- noc_router KOMPONENTA - ROUTER N (28)
    router_N: noc_router
    
        generic map (
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => "0010",
            local_address_y => "1000",
            clock_divider => clock_divider,
            diagonal_pref => VER
        )
        
        port map(
            clk => clk,
            rst => rst,
            
            -- ROUTER TO ROUTER INTERFACE
            -- LOCAL
            data_in_local => data_in_N,
            data_in_valid_local => data_in_valid_N,
            data_in_vc_busy_local => data_in_vc_busy_N,
            data_in_vc_credits_local => data_in_vc_credits_N,
            
            data_out_local => data_out_N,
            data_out_valid_local => data_out_valid_N,
            data_out_vc_busy_local => data_out_vc_busy_N,
            data_out_vc_credits_local =>  data_out_vc_credits_N,
            
            -- ROUTER TO ROUTER INTERFACE
            -- NORTH
            data_in_north => data_J_to_N,
            data_in_valid_north => data_valid_J_to_N,
            data_in_vc_busy_north => vc_busy_N_to_J,
            data_in_vc_credits_north => vc_credits_N_to_J,
            
            data_out_north => data_N_to_J,
            data_out_valid_north => data_valid_N_to_J,
            data_out_vc_busy_north => vc_busy_J_to_N,
            data_out_vc_credits_north => vc_credits_J_to_N,
            
            -- ROUTER TO ROUTER INTERFACE
            -- EAST
            data_in_east => data_O_to_N,
            data_in_valid_east => data_valid_O_to_N,
            data_in_vc_busy_east => vc_busy_N_to_O,
            data_in_vc_credits_east => vc_credits_N_to_O,
            
            data_out_east => data_N_to_O,
            data_out_valid_east => data_valid_N_to_O,
            data_out_vc_busy_east => vc_busy_O_to_N,
            data_out_vc_credits_east => vc_credits_O_to_N,
            
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
            data_in_west => data_M_to_N,
            data_in_valid_west => data_valid_M_to_N,
            data_in_vc_busy_west => vc_busy_N_to_M,
            data_in_vc_credits_west => vc_credits_N_to_M,
            
            data_out_west => data_N_to_M,
            data_out_valid_west => data_valid_N_to_M,
            data_out_vc_busy_west => vc_busy_M_to_N,
            data_out_vc_credits_west => vc_credits_M_to_N
        );
        
    -- noc_router KOMPONENTA - ROUTER O (48)
    router_O: noc_router
    
        generic map (
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => "0100",
            local_address_y => "1000",
            clock_divider => clock_divider,
            diagonal_pref => VER
        )
        
        port map(
            clk => clk,
            rst => rst,
            
            -- ROUTER TO ROUTER INTERFACE
            -- LOCAL
            data_in_local => data_in_O,
            data_in_valid_local => data_in_valid_O,
            data_in_vc_busy_local => data_in_vc_busy_O,
            data_in_vc_credits_local => data_in_vc_credits_O,
            
            data_out_local => data_out_O,
            data_out_valid_local => data_out_valid_O,
            data_out_vc_busy_local => data_out_vc_busy_O,
            data_out_vc_credits_local =>  data_out_vc_credits_O,
            
            -- ROUTER TO ROUTER INTERFACE
            -- NORTH
            data_in_north => data_K_to_O,
            data_in_valid_north => data_valid_K_to_O,
            data_in_vc_busy_north => vc_busy_O_to_K,
            data_in_vc_credits_north => vc_credits_O_to_K,
            
            data_out_north => data_O_to_K,
            data_out_valid_north => data_valid_O_to_K,
            data_out_vc_busy_north => vc_busy_K_to_O,
            data_out_vc_credits_north => vc_credits_K_to_O,
            
            -- ROUTER TO ROUTER INTERFACE
            -- EAST
            data_in_east => data_P_to_O,
            data_in_valid_east => data_valid_P_to_O,
            data_in_vc_busy_east => vc_busy_O_to_P,
            data_in_vc_credits_east => vc_credits_O_to_P,
            
            data_out_east => data_O_to_P,
            data_out_valid_east => data_valid_O_to_P,
            data_out_vc_busy_east => vc_busy_P_to_O,
            data_out_vc_credits_east => vc_credits_P_to_O,
            
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
            data_in_west => data_N_to_O,
            data_in_valid_west => data_valid_N_to_O,
            data_in_vc_busy_west => vc_busy_O_to_N,
            data_in_vc_credits_west => vc_credits_O_to_N,
            
            data_out_west => data_O_to_N,
            data_out_valid_west => data_valid_O_to_N,
            data_out_vc_busy_west => vc_busy_N_to_O,
            data_out_vc_credits_west => vc_credits_N_to_O
        );
        
    -- noc_router KOMPONENTA - ROUTER P (88)
    router_P: noc_router
    
        generic map (
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => "1000",
            local_address_y => "1000",
            clock_divider => clock_divider,
            diagonal_pref => VER
        )
        
        port map(
            clk => clk,
            rst => rst,
            
            -- ROUTER TO ROUTER INTERFACE
            -- LOCAL
            data_in_local => data_in_P,
            data_in_valid_local => data_in_valid_P,
            data_in_vc_busy_local => data_in_vc_busy_P,
            data_in_vc_credits_local => data_in_vc_credits_P,
            
            data_out_local => data_out_P,
            data_out_valid_local => data_out_valid_P,
            data_out_vc_busy_local => data_out_vc_busy_P,
            data_out_vc_credits_local => data_out_vc_credits_P,
            
            -- ROUTER TO ROUTER INTERFACE
            -- NORTH
            data_in_north => data_L_to_P,
            data_in_valid_north => data_valid_L_to_P,
            data_in_vc_busy_north => vc_busy_P_to_L,
            data_in_vc_credits_north => vc_credits_P_to_L,
            
            data_out_north => data_P_to_L,
            data_out_valid_north => data_valid_P_to_L,
            data_out_vc_busy_north => vc_busy_L_to_P,
            data_out_vc_credits_north => vc_credits_L_to_P,
            
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
            data_in_west => data_O_to_P,
            data_in_valid_west => data_valid_O_to_P,
            data_in_vc_busy_west => vc_busy_P_to_O,
            data_in_vc_credits_west => vc_credits_P_to_O,
            
            data_out_west => data_P_to_O,
            data_out_valid_west => data_valid_P_to_O,
            data_out_vc_busy_west => vc_busy_O_to_P,
            data_out_vc_credits_west => vc_credits_O_to_P
        );

end Behavioral;
