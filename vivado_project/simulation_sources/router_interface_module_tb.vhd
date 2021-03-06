----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
--
-- Create Date: 16.03.2021 15:36:08
-- Design Name: NoC_Router
-- Module Name: router_interface_module_tb - Simulation
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
-- Revision 0.1 - 2021-03-16 - Mrkovic i Ramljak
-- Additional Comments: Stvorena pocetna struktura _tb (testbench) dokumenata 
-- Revision 0.2 - 2021-03-17 - Mrkovic
-- Additional Comments: Dodani zeljeni stimulusi za testiranje modula
-- Revision 0.3 - 2021-03-18 - Mrkovic
-- Additional Comments: Prosireni i komentirani stimulusi
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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

entity router_interface_module_tb is
--  Port ( );
end router_interface_module_tb;

architecture Simulation of router_interface_module_tb is

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

    signal int_data_in_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal int_data_in_valid_sim : std_logic_vector(const_vc_num - 1 downto 0);

    signal int_data_out_sim : std_logic_vector(const_flit_size - 1 downto 0);
    signal int_data_out_valid_sim : std_logic;

    signal buffer_vc_credits_sim : std_logic_vector(const_vc_num - 1 downto 0);
    
    signal arb_vc_busy_sim : std_logic_vector(const_vc_num - 1 downto 0);
    signal arb_credit_counter_sim : credit_counter_vector(const_vc_num - 1 downto 0);

    -- Period takta
    constant clk_period : time := 200ns;

begin

    -- Komponenta koja se testira (Unit Under Test)
    uut: router_interface_module

        generic map(
            vc_num => const_vc_num,
            address_size => const_address_size,
            payload_size => const_payload_size,
            flit_size => const_flit_size,
            buffer_size => const_buffer_size
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

            buffer_vc_credits => buffer_vc_credits_sim,
            
            arb_vc_busy => arb_vc_busy_sim,
            arb_credit_counter => arb_credit_counter_sim
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

        int_data_out_sim <= (others => '0');
        int_data_out_valid_sim <= '0';

        buffer_vc_credits_sim <= (others => '0');

        -- Reset aktivan
        rst_sim <= '0';

        wait for 2us;

        -- Reset neaktivan
        rst_sim <= '1';

        wait for 2us;

        -- Ulazni head flit, prvi (01) virtualni kanal
        data_in_sim <= (43 => '1', 40 => '1', others => '0');
        data_in_valid_sim <= '1';

        wait for clk_period;

        -- Ulazni head flit, drugi (10) virtualni kanal
        data_in_sim <= (43 => '1', 41 => '1', others => '0');
        data_in_valid_sim <= '1';

        wait for clk_period;

        -- Ulazni tail flit, prvi (01) virtualni kanal
        data_in_sim <= (42 => '1', 40 => '1', others => '0');
        data_in_valid_sim <= '1';

        wait for clk_period;

        -- Ulazni body flit, drugi (10) virtualni kanal
        data_in_sim <= (41 => '1', others => '0');
        data_in_valid_sim <= '1';

        wait for clk_period;

        -- Ulazni tail flit, drugi (10) virtualni kanal
        data_in_sim <= (42 => '1', 41 => '1', others => '0');
        data_in_valid_sim <= '1';

        wait for clk_period;

        -- Ulazni headtail flit, prvi (01) virtualni kanal
        data_in_sim <= (43 => '1', 42 => '1', 40 => '1', others => '0');
        data_in_valid_sim <= '1';

        wait for clk_period;

        -- Smireni ulazi
        data_in_sim <= (others => '0');
        data_in_valid_sim <= '0';

        wait for clk_period;

        -- Buffer oslobodio poziciju, prvi (01) virtualni kanal
        buffer_vc_credits_sim <= (0 => '1', others => '0');

        wait for clk_period;

        -- Buffer oslobodio poziciju, prvi (01) i drugi (10) virtualni kanal
        buffer_vc_credits_sim <= (others => '1');

        wait for clk_period;

        -- Smiren buffer signal
        buffer_vc_credits_sim <= (others => '0');

        wait for clk_period;

        -- Izlazni head flit, prvi (01) virtualni kanal
        int_data_out_sim <= (43 => '1', 40 => '1', others => '0');
        int_data_out_valid_sim <= '1';

        wait for clk_period;

        -- Izlazni tail flit, prvi (01) virtualni kanal
        int_data_out_sim <= (42 => '1', 40 => '1', others => '0');
        int_data_out_valid_sim <= '1';

        wait for clk_period;

        -- Smireni izlazi
        int_data_out_sim <= (others => '0');
        int_data_out_valid_sim <= '0';

        wait for clk_period;

        -- Buffer susjednog routera oslobodio poziciju, prvi (01) virtualni kanal
        data_out_vc_credits_sim <= (0 => '1', others => '0');

        wait for clk_period;

        -- Smiren buffer signal susjednog routera
        data_out_vc_credits_sim <= (others => '0');

        wait for (5 * clk_period);

        -- Izlazni head flit, prvi (01) virtualni kanal
        int_data_out_sim <= (43 => '1', 40 => '1', others => '0');
        int_data_out_valid_sim <= '1';

        wait for clk_period;

        -- Izlazni head flit, drugi (10) virtualni kanal
        int_data_out_sim <= (43 => '1', 41 => '1', others => '0');
        int_data_out_valid_sim <= '1';

        wait for clk_period;

        -- Izlazni tail flit, prvi (01) virtualni kanal
        int_data_out_sim <= (42 => '1', 40 => '1', others => '0');
        int_data_out_valid_sim <= '1';

        wait for clk_period;

        -- Izlazni body flit, drugi (10) virtualni kanal
        int_data_out_sim <= (41 => '1', others => '0');
        int_data_out_valid_sim <= '1';

        wait for clk_period;

        -- Izlazni body flit, drugi (10) virtualni kanal
        int_data_out_sim <= (41 => '1', others => '0');
        int_data_out_valid_sim <= '1';

        wait for clk_period;

        -- Izlazni tail flit, drugi (10) virtualni kanal
        int_data_out_sim <= (42 => '1', 41 => '1', others => '0');
        int_data_out_valid_sim <= '1';

        wait for clk_period;

        -- Smireni izlazi
        int_data_out_sim <= (others => '0');
        int_data_out_valid_sim <= '0';

        wait for (2 * clk_period);

        -- Buffer susjednog routera oslobodio poziciju, prvi (01) i drugi (10) virtualni kanal
        data_out_vc_credits_sim <= (others => '1');

        wait for clk_period;

        -- Buffer susjednog routera oslobodio poziciju, drugi (10) virtualni kanal
        data_out_vc_credits_sim <= (1 => '1', others => '0');

        wait for clk_period;

        -- Buffer susjednog routera oslobodio poziciju, prvi (01) i drugi (10) virtualni kanal
        data_out_vc_credits_sim <= (others => '1');

        wait for clk_period;

        -- Smiren buffer signal susjednog routera
        data_out_vc_credits_sim <= (others => '0');

        wait;

    end process;

end Simulation;
