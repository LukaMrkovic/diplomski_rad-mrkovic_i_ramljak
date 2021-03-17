----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic & Ramljak
-- 
-- Create Date: 16.03.2021 15:36:08
-- Design Name: NoC_Router
-- Module Name: router_interface_module_tb1 - Simulation
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
-- Revision 0.1 - 2021-03-16
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity router_interface_module_tb1 is
--  Port ( );
end router_interface_module_tb1;

architecture simulation of router_interface_module_tb1 is

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
           
    signal data_in_sim : std_logic_vector(43 downto 0);
    signal data_in_valid_sim : std_logic;
    signal data_in_vc_busy_sim : std_logic_vector(1 downto 0);
    signal data_in_vc_credits_sim : std_logic_vector(1 downto 0);
           
    signal data_out_sim : std_logic_vector(43 downto 0);
    signal data_out_valid_sim : std_logic;
    signal data_out_vc_busy_sim : std_logic_vector(1 downto 0);
    signal data_out_vc_credits_sim : std_logic_vector(1 downto 0);
           
    signal int_data_in_sim : std_logic_vector(43 downto 0);
    signal int_data_in_valid_sim : std_logic;
           
    signal int_data_out_sim : std_logic_vector(43 downto 0);
    signal int_data_out_valid_sim : std_logic;
           
    signal buffer_vc_credits_sim : std_logic_vector(1 downto 0); 
    
    -- Period clk
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se sestira (Unit Under Test)
    uut: router_interface_module
    generic map(
        vc_num => 2,
        flit_size => 44,
        payload_size => 32,
        buffer_size => 8,
        mesh_size => 8
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
           
        int_data_in => int_data_in_sim,
        int_data_in_valid => int_data_in_valid_sim,
           
        int_data_out => int_data_out_sim,
        int_data_out_valid => int_data_out_valid_sim,
           
        buffer_vc_credits => buffer_vc_credits_sim
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
        
        data_in_sim <= (others => '0');
        data_in_valid_sim <= '0';
        
        int_data_out_sim <= (others => '0');
        int_data_out_valid_sim <= '0';
        
        buffer_vc_credits_sim <= (others => '0');
        
        data_out_vc_busy_sim <= (others => '0');
        data_out_vc_credits_sim <= (others => '0');
        
        rst_sim <= '0';
        
        wait for 2us;
        
        rst_sim <= '1';
        
        wait for 2us;
        
        data_in_sim <= (43 => '1', 40 => '1', others => '0');
        data_in_valid_sim <= '1';
        
        wait for clk_period;
        
        data_in_valid_sim <= '1';
        data_in_sim <= (42 => '1', 40 => '1', others => '0');
        
        wait for clk_period;
        
        data_in_sim <= (others => '0');
        data_in_valid_sim <= '0';
        
        wait for clk_period;
        buffer_vc_credits_sim <= (0 => '1', others => '0');
        
        wait for clk_period;
        buffer_vc_credits_sim <= (others => '1');
        
        wait for clk_period;
        buffer_vc_credits_sim <= (others => '0');
        
        wait for clk_period;
        int_data_out_sim <= (43 => '1', 40 => '1', others => '0');
        int_data_out_valid_sim <= '1';
        
        wait for clk_period;
        int_data_out_sim <= (42 => '1', 40 => '1', others => '0');
        int_data_out_valid_sim <= '1';
        
        wait for clk_period;
        int_data_out_sim <= (others => '0');
        int_data_out_valid_sim <= '0';
        
        wait for clk_period;
        data_out_vc_credits_sim <= (0 => '1', others => '0');
        
        wait for clk_period;
        data_out_vc_credits_sim <= (others => '0');
        
        
       
        
        wait;
        
    end process;
    
end simulation;