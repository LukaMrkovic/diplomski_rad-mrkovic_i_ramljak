----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2021 09:38:08 PM
-- Design Name: 
-- Module Name: router_to_router_interface_module_tb1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library noc_lib;
use noc_lib.router_config.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity router_to_router_interface_module_tb1 is
--  Port ( );
end router_to_router_interface_module_tb1;

architecture simulation of router_to_router_interface_module_tb1 is

    -- Deklaracija komponente
    component router_interface_module
        
        Generic (
            vc_num : integer;
            flit_size : integer;
            payload_size : integer;
            buffer_size : integer;
            mesh_size : integer
        );
        
        Port (
            clk : in std_logic;
            rst : in std_logic; 
           
            data_in : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid : in std_logic;
            data_in_vc_busy : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits : out std_logic_vector(vc_num - 1 downto 0);
           
            data_out : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid : out std_logic;
            data_out_vc_busy : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits : in std_logic_vector(vc_num - 1 downto 0);
           
            int_data_in : out std_logic_vector(flit_size - 1 downto 0);
            int_data_in_valid : out std_logic;
           
            int_data_out : in std_logic_vector(flit_size - 1 downto 0);
            int_data_out_valid : in std_logic;
           
            buffer_vc_credits : in std_logic_vector(vc_num - 1 downto 0)
        );
        
    end component;

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal rst_sim : std_logic;
    
    -- Router 1
    signal int_data_in_sim_r1 : std_logic_vector(const_flit_size - 1 downto 0);
    signal int_data_in_valid_sim_r1 : std_logic;
    
    signal int_data_out_sim_r1 : std_logic_vector(const_flit_size - 1 downto 0);
    signal int_data_out_valid_sim_r1 : std_logic;
    
    signal buffer_vc_credits_sim_r1 : std_logic_vector(const_vc_num - 1 downto 0);
    
    -- Router 2
    signal int_data_in_sim_r2 : std_logic_vector(const_flit_size - 1 downto 0);
    signal int_data_in_valid_sim_r2 : std_logic;
        
    signal int_data_out_sim_r2 : std_logic_vector(const_flit_size - 1 downto 0);
    signal int_data_out_valid_sim_r2 : std_logic;
    
    signal buffer_vc_credits_sim_r2 : std_logic_vector(const_vc_num - 1 downto 0);

    -- Medukonekcije izmedu routera
    signal data_in_vc_busy_1_to_2_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_in_vc_credits_1_to_2_sim : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_in_vc_busy_2_to_1_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal data_in_vc_credits_2_to_1_sim : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal data_out_1_to_2_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_valid_1_to_2_sim : std_logic;
    
    signal data_out_2_to_1_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_out_valid_2_to_1_sim : std_logic;
    
    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test) Router 1
    uut_router_1: router_interface_module
    
        generic map(
            vc_num => const_vc_num,
            flit_size => const_flit_size,
            payload_size => const_payload_size,
            buffer_size => const_buffer_size,
            mesh_size => const_mesh_size
        )
        
        port map(
            clk => clk_sim,
            rst => rst_sim, 
           
            data_in => data_out_2_to_1_sim,
            data_in_valid => data_out_valid_2_to_1_sim,
            data_in_vc_busy => data_in_vc_busy_1_to_2_sim,
            data_in_vc_credits => data_in_vc_credits_1_to_2_sim,
           
            data_out => data_out_1_to_2_sim,
            data_out_valid => data_out_valid_1_to_2_sim,
            data_out_vc_busy => data_in_vc_busy_2_to_1_sim,
            data_out_vc_credits => data_in_vc_credits_2_to_1_sim,
           
            int_data_in => int_data_in_sim_r1,
            int_data_in_valid => int_data_in_valid_sim_r1,
           
            int_data_out => int_data_out_sim_r1,
            int_data_out_valid => int_data_out_valid_sim_r1,
           
            buffer_vc_credits => buffer_vc_credits_sim_r1
        );
        
        
        -- Komponenta koja se testira (Unit Under Test) Router 2
    uut_router_2: router_interface_module
        
        generic map(
            vc_num => const_vc_num,
            flit_size => const_flit_size,
            payload_size => const_payload_size,
            buffer_size => const_buffer_size,
            mesh_size => const_mesh_size
        )
        
        port map(
            clk => clk_sim,
            rst => rst_sim, 
           
            data_in => data_out_1_to_2_sim,
            data_in_valid => data_out_valid_1_to_2_sim,
            data_in_vc_busy => data_in_vc_busy_2_to_1_sim,
            data_in_vc_credits => data_in_vc_credits_2_to_1_sim,
           
            data_out => data_out_2_to_1_sim,
            data_out_valid => data_out_valid_2_to_1_sim,
            data_out_vc_busy => data_in_vc_busy_1_to_2_sim,
            data_out_vc_credits => data_in_vc_credits_1_to_2_sim,
           
            int_data_in => int_data_in_sim_r2,
            int_data_in_valid => int_data_in_valid_sim_r2,
           
            int_data_out => int_data_out_sim_r2,
            int_data_out_valid => int_data_out_valid_sim_r2,
           
            buffer_vc_credits => buffer_vc_credits_sim_r2
        );
        
        -- CLK PROCES
    clk_process : process
    
    begin
    
        clk_sim <= '1';
        wait for clk_period / 2;
        clk_sim <= '0';
        wait for clk_period / 2;
        
    end process;
    
    -- STIMULIRAJUCI PROCES
    stim_process : process
    
    begin
        
        -- Inicijalne postavke ulaznih signala
        int_data_out_sim_r1 <= (others => '0');
        int_data_out_valid_sim_r1 <= '0';
        
        buffer_vc_credits_sim_r1 <= (others => '0');
        
        int_data_out_sim_r2 <= (others => '0');
        int_data_out_valid_sim_r2 <= '0';
        
        buffer_vc_credits_sim_r2 <= (others => '0');
        
        -- Reset aktivan
        rst_sim <= '0';
        
        wait for 2us;
        
        -- Reset neaktivan
        rst_sim <= '1';
        
        wait for 2us;
        
        -- Ulazni head flit, prvi (01) virtualni kanal R1 -> R2 
        int_data_out_sim_r1 <= (43 => '1', 40 => '1', others => '0');
        int_data_out_valid_sim_r1 <= '1';
        
        -- Ulazni head flit, prvi (01) virtualni kanal R2 -> R1, PROVJERAVAO SAM KAKO SE PONASAJU KAD U ISTO VRIJEME SALJU FLITOVE (y)
     --   int_data_out_sim_r2 <= (43 => '1', 40 => '1', 3 => '1', others => '0');
     --   int_data_out_valid_sim_r2 <= '1';    
        
        wait for clk_period;
        
        -- Ulazni head flit, drugi (10) virtualni kanal R1 -> R2
        int_data_out_sim_r1 <= (43 => '1', 41 => '1', others => '0');
        int_data_out_valid_sim_r1 <= '1';
        
        -- Ulazni head flit, drugi (10) virtualni kanal R2 -> R1, PROVJERAVAO SAM KAKO SE PONASAJU KAD U ISTO VRIJEME SALJU FLITOVE (y)
     --   int_data_out_sim_r2 <= (43 => '1', 41 => '1', 3 => '1', others => '0');
     --   int_data_out_valid_sim_r2 <= '1';
        
        wait for clk_period;
                
        -- Ulazni tail flit, prvi (01) virtualni kanal R1 -> R2
        int_data_out_sim_r1 <= (42 => '1', 40 => '1', others => '0');
        int_data_out_valid_sim_r1 <= '1';
        
        wait for clk_period;
        
        -- Ulazni body flit, drugi (10) virtualni kanal R1 -> R2
        int_data_out_sim_r1 <= (41 => '1', others => '0');
        int_data_out_valid_sim_r1 <= '1';
        
        wait for clk_period;
        
        -- Ulazni headtail flit, prvi (01) virtualni kanal
        int_data_out_sim_r1 <= (42 => '1', 41 => '1', others => '0');
        int_data_out_valid_sim_r1 <= '1';
        
        wait for clk_period;
        
        -- Smireni ulazi
        int_data_out_sim_r1 <= (others => '0');
        int_data_out_valid_sim_r1 <= '0';
        
        int_data_out_sim_r2 <= (others => '0');
        int_data_out_valid_sim_r2 <= '0';
        
        wait for clk_period;
        
        -- Buffer oslobodio poziciju, prvi (01) virtualni kanal R2 -> R1
        buffer_vc_credits_sim_r2 <= (0 => '1', others => '0');
        
        wait for clk_period;
        
        -- Buffer oslobodio poziciju, prvi (01) i drugi (10) virtualni kanal R2 -> R1
        buffer_vc_credits_sim_r2 <= (others => '1');
        
        wait for clk_period;
        
        -- Buffer oslobodio poziciju, drugi (10) virtualni kanal R2 -> R1
        buffer_vc_credits_sim_r2 <= (1 => '1', others => '0');
        
        wait for clk_period;
        
        -- Buffer oslobodio poziciju, drugi (10) virtualni kanal R2 -> R1
        buffer_vc_credits_sim_r2 <= (1 => '1', others => '0');
        
        wait for clk_period;
        
        -- Smiren buffer signal
        buffer_vc_credits_sim_r2 <= (others => '0');
        
        wait;
        
    end process;

end simulation;
