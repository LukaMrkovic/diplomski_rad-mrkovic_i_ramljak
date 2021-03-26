----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
--
-- Create Date: 18.03.2021 21:38:08
-- Design Name: NoC_Router
-- Module Name: router_interface_interaction_2_routers_tb1 - Simulation
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
-- Revision 0.1 - 2021-03-18 - Ramljak
-- Additional Comments: Stvorena inicijalna verzija testa interakcije 2 routera
-- Revision 0.2 - 2021-03-20 - Mrkovic
-- Additional Comments: Dorada, signali preimenovani u skladu sa dogovorenim nazivima sa sheme
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library noc_lib;
use noc_lib.router_config.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity router_interface_interaction_2_routers_tb1 is
--  Port ( );
end router_interface_interaction_2_routers_tb1;

architecture simulation of router_interface_interaction_2_routers_tb1 is

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
            int_data_in_valid : out std_logic_vector(vc_num - 1 downto 0);

            int_data_out : in std_logic_vector(flit_size - 1 downto 0);
            int_data_out_valid : in std_logic;

            buffer_vc_credits : in std_logic_vector(vc_num - 1 downto 0)
        );

    end component;

    -- Simulirani signali
    signal clk_sim : std_logic;
    signal rst_sim : std_logic;

    -- Router 1
    signal int_data_in_1_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal int_data_in_valid_1_sim : std_logic_vector(const_vc_num - 1 downto 0);

    signal int_data_out_1_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal int_data_out_valid_1_sim : std_logic;

    signal buffer_vc_credits_1_sim : std_logic_vector(const_vc_num - 1 downto 0);

    -- Router 2
    signal int_data_in_2_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal int_data_in_valid_2_sim : std_logic_vector(const_vc_num - 1 downto 0);

    signal int_data_out_2_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal int_data_out_valid_2_sim : std_logic;

    signal buffer_vc_credits_2_sim : std_logic_vector(const_vc_num - 1 downto 0);

    -- Medukonekcije izmedu routera
    signal vc_busy_1_to_2_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_1_to_2_sim : std_logic_vector(const_vc_num - 1 downto 0);

    signal vc_busy_2_to_1_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal vc_credits_2_to_1_sim : std_logic_vector(const_vc_num - 1 downto 0);

    signal data_1_to_2_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_1_to_2_sim : std_logic;

    signal data_2_to_1_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal data_valid_2_to_1_sim : std_logic;

    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test)
    -- Router 1
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

            data_in => data_2_to_1_sim,
            data_in_valid => data_valid_2_to_1_sim,
            data_in_vc_busy => vc_busy_1_to_2_sim,
            data_in_vc_credits => vc_credits_1_to_2_sim,

            data_out => data_1_to_2_sim,
            data_out_valid => data_valid_1_to_2_sim,
            data_out_vc_busy => vc_busy_2_to_1_sim,
            data_out_vc_credits => vc_credits_2_to_1_sim,

            int_data_in => int_data_in_1_sim,
            int_data_in_valid => int_data_in_valid_1_sim,

            int_data_out => int_data_out_1_sim,
            int_data_out_valid => int_data_out_valid_1_sim,

            buffer_vc_credits => buffer_vc_credits_1_sim
        );


    -- Komponenta koja se testira (Unit Under Test)
    -- Router 2
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

            data_in => data_1_to_2_sim,
            data_in_valid => data_valid_1_to_2_sim,
            data_in_vc_busy => vc_busy_2_to_1_sim,
            data_in_vc_credits => vc_credits_2_to_1_sim,

            data_out => data_2_to_1_sim,
            data_out_valid => data_valid_2_to_1_sim,
            data_out_vc_busy => vc_busy_1_to_2_sim,
            data_out_vc_credits => vc_credits_1_to_2_sim,

            int_data_in => int_data_in_2_sim,
            int_data_in_valid => int_data_in_valid_2_sim,

            int_data_out => int_data_out_2_sim,
            int_data_out_valid => int_data_out_valid_2_sim,

            buffer_vc_credits => buffer_vc_credits_2_sim
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
        
        -- Router 1
        int_data_out_1_sim <= (others => '0');
        int_data_out_valid_1_sim <= '0';
        buffer_vc_credits_1_sim <= (others => '0');
        
        -- Router 2
        int_data_out_2_sim <= (others => '0');
        int_data_out_valid_2_sim <= '0';
        buffer_vc_credits_2_sim <= (others => '0');

        -- Reset aktivan
        rst_sim <= '0';

        wait for 2us;

        -- Reset neaktivan
        rst_sim <= '1';

        wait for 2us;

        -- R1 -> R2 (head flit, prvi (01) virtualni kanal)
        int_data_out_1_sim <= (43 => '1', 40 => '1', others => '0');
        int_data_out_valid_1_sim <= '1';

        -- R1 -> R2 (head flit, prvi (01) virtualni kanal)
        -- PROVJERAVAO SAM KAKO SE PONASAJU KAD U ISTO VRIJEME SALJU FLITOVE (y)
        -- int_data_out_sim_r2 <= (43 => '1', 40 => '1', 3 => '1', others => '0');
        -- int_data_out_valid_sim_r2 <= '1';

        wait for clk_period;

        -- R1 -> R2 (head flit, drugi (10) virtualni kanal)
        int_data_out_1_sim <= (43 => '1', 41 => '1', others => '0');
        int_data_out_valid_1_sim <= '1';

        -- R2 -> R1 (head flit, drugi (10) virtualni kanal)
        -- PROVJERAVAO SAM KAKO SE PONASAJU KAD U ISTO VRIJEME SALJU FLITOVE (y)
        -- int_data_out_sim_r2 <= (43 => '1', 41 => '1', 3 => '1', others => '0');
        -- int_data_out_valid_sim_r2 <= '1';

        wait for clk_period;

        -- R1 -> R2 (tail flit, prvi (01) virtualni kanal)
        int_data_out_1_sim <= (42 => '1', 40 => '1', others => '0');
        int_data_out_valid_1_sim <= '1';

        wait for clk_period;

        -- R1 -> R2 (body flit, drugi (10) virtualni kanal)
        int_data_out_1_sim <= (41 => '1', others => '0');
        int_data_out_valid_1_sim <= '1';

        wait for clk_period;
        
        -- R1 -> R2 (tail flit, drugi (10) virtualni kanal)
        int_data_out_1_sim <= (42 => '1', 41 => '1', others => '0');
        int_data_out_valid_1_sim <= '1';

        wait for clk_period;

        -- R1 -> R2 (headtail flit, prvi (01) virtualni kanal)
        int_data_out_1_sim <= (43 => '1', 42 => '1', 40 => '1', others => '0');
        int_data_out_valid_1_sim <= '1';

        wait for clk_period;

        -- Smireni ulazi
        int_data_out_1_sim <= (others => '0');
        int_data_out_valid_1_sim <= '0';

        int_data_out_2_sim <= (others => '0');
        int_data_out_valid_2_sim <= '0';

        wait for clk_period;

        -- R2 -> R1 (buffer oslobodio poziciju, prvi (01) virtualni kanal) 
        buffer_vc_credits_2_sim <= (0 => '1', others => '0');

        wait for clk_period;

        -- R2 -> R1 (buffer oslobodio poziciju, prvi (01) i drugi (10) virtualni kanal)
        buffer_vc_credits_2_sim <= (others => '1');

        wait for clk_period;

        -- R2 -> R1 (buffer oslobodio poziciju, drugi (10) virtualni kanal)
        buffer_vc_credits_2_sim <= (1 => '1', others => '0');

        wait for clk_period;

        -- R2 -> R1 (buffer oslobodio poziciju, drugi (10) virtualni kanal)
        buffer_vc_credits_2_sim <= (1 => '1', others => '0');

        wait for clk_period;

        -- Smiren buffer signal
        buffer_vc_credits_2_sim <= (others => '0');
        
        wait for (3 * clk_period);
        
        -- R1 -> R2 (head flit, prvi (01) virtualni kanal)
        int_data_out_1_sim <= (43 => '1', 40 => '1', others => '0');
        int_data_out_valid_1_sim <= '1';
        
        wait for clk_period;
        
        -- Smireni ulazi
        int_data_out_1_sim <= (others => '0');
        int_data_out_valid_1_sim <= '0';
        
        wait for clk_period;
        
        -- R1 -> R2 (tail flit, prvi (01) virtualni kanal)
        int_data_out_1_sim <= (42 => '1', 40 => '1', others => '0');
        int_data_out_valid_1_sim <= '1';
        
        wait for clk_period;
        
        -- Smireni ulazi
        int_data_out_1_sim <= (others => '0');
        int_data_out_valid_1_sim <= '0';

        wait;

    end process;

end simulation;
