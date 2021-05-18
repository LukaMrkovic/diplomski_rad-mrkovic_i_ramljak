----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/10/2021 04:25:36 PM
-- Design Name: AXI_Network_Adapter
-- Module Name: SNA_resp_buffer_controller - Behavioral
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
-- Revision 0.1 - 2021-05-10 - Ramljak
-- Additional Comments: Prva verzija SNA_resp_buffer_controllera
-- Revision 0.2 - 2021-05-18 - Mrkovic
-- Additional Comments: Dotjerana verzija SNA_resp_buffer_controllera
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

library noc_lib;
use noc_lib.router_config.ALL;
use noc_lib.AXI_network_adapter_config.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity SNA_resp_buffer_controller is

    Generic (
        vc_num : integer := const_vc_num;
        address_size : integer := const_address_size;
        flit_size : integer := const_flit_size
    );
                  
    Port (
        clk : in std_logic;
        rst : in std_logic; 
        
        -- SNA_resp_AXI_handshake_controller
        op_write : in std_logic;
        op_read : in std_logic;
        
        data : in std_logic_vector(31 downto 0);
        resp : in std_logic_vector(1 downto 0);
        
        -- AXI_to_noc_FIFO_buffer
        flit_in : out std_logic_vector(flit_size - 1 downto 0);
        flit_in_valid : out std_logic;
        
        -- req_flow (SNA_req_buffer_controller)
        r_addr : in std_logic_vector(address_size - 1 downto 0);
        r_vc : in std_logic_vector(vc_num - 1 downto 0);
        
        -- t_monitor
        t_end : out std_logic
    );

end SNA_resp_buffer_controller;

architecture Behavioral of SNA_resp_buffer_controller is

    -- ENUMERACIJA STANJA fsm-a
    type state_type is (IDLE, W_FLIT_1, R_FLIT_1, R_FLIT_2);
    -- TRENUTNO STANJE
    signal current_state : state_type;
    -- SLJEDECE STANJE
    signal next_state : state_type;
    -- POCETNO STANJE
    constant initial_state : state_type := IDLE;

    -- enable SIGNALI PROCESA INDIVIDUALNIH STANJA
    signal W_FLIT_1_enable : std_logic;
    signal R_FLIT_1_enable : std_logic;
    signal R_FLIT_2_enable : std_logic;
    
begin

    -- PROCES KOJI KOORDINIRA PROCESE POJEDINIH STANJA
    combinatorial_process : process (current_state, op_write, op_read) is
    
    begin
    
        flit_in_valid <= '0';
        
        t_end <= '0';
    
        W_FLIT_1_enable <= '0';
        R_FLIT_1_enable <= '0';
        R_FLIT_2_enable <= '0';
    
        case current_state is
        
            when IDLE =>
            
                if op_write = '1' then
                    
                    W_FLIT_1_enable <= '1';
                    next_state <= W_FLIT_1;
                
                elsif op_read = '1' then
                    
                    R_FLIT_1_enable <= '1';
                    next_state <= R_FLIT_1;
                    
                else
                
                    next_state <= IDLE;
                
                end if;   
            
            when W_FLIT_1 =>
                
                flit_in_valid <= '1';
                t_end <= '1';
                next_state <= IDLE;
                
            when R_FLIT_1 =>
            
                flit_in_valid <= '1';
                R_FLIT_2_enable <= '1';
                next_state <= R_FLIT_2;
                
            when R_FLIT_2 =>
            
                flit_in_valid <= '1';
                t_end <= '1';
                next_state <= IDLE;
            
        end case;
    
    end process;
    
    -- PROCES KOJI GRADI I ODASILJE FLITOVE
    builder_process : process (clk) is
    
        variable flit_var : std_logic_vector(flit_size - 1 downto 0);
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
                
                flit_var := (others => '0');
                
                flit_in <= (others => '0');
                
            else
            
                flit_var := (others => '0');
                
                if W_FLIT_1_enable = '1' then
                
                    -- FLIT LABELA
                    flit_var(flit_size - 1 downto
                             flit_size - 2) := "11";
                    -- VIRTUALNI KANAL
                    flit_var(flit_size - 2 - 1 downto
                             flit_size - 2 - vc_num) := r_vc;
                    -- POVRATNA ADRESA
                    flit_var(flit_size - 2 - vc_num - 1 downto
                             flit_size - 2 - vc_num - address_size) := r_addr; 
                    -- WRITE RESPONSE
                    flit_var(2 downto 1) := resp;
                    -- R/W
                    flit_var(0) := '0';
                
                elsif R_FLIT_1_enable = '1' then
                
                    -- FLIT LABELA
                    flit_var(flit_size - 1 downto
                             flit_size - 2) := "10";
                    -- VIRTUALNI KANAL
                    flit_var(flit_size - 2 - 1 downto
                             flit_size - 2 - vc_num) := r_vc;
                    -- POVRATNA ADRESA
                    flit_var(flit_size - 2 - vc_num - 1 downto
                             flit_size - 2 - vc_num - address_size) := r_addr;
                    -- READ RESPONSE
                    flit_var(2 downto 1) := resp;
                    -- R/W
                    flit_var(0) := '1';
                
                elsif R_FLIT_2_enable = '1' then
                
                    -- FLIT LABELA
                    flit_var(flit_size - 1 downto
                             flit_size - 2) := "01";
                    -- VIRTUALNI KANAL
                    flit_var(flit_size - 2 - 1 downto
                             flit_size - 2 - vc_num) := r_vc;
                    -- POVRATNA ADRESA
                    flit_var(flit_size - 2 - vc_num - 1 downto
                             flit_size - 2 - vc_num - address_size) := r_addr;
                    -- READ DATA
                    flit_var(31 downto 0) := data;
                
                end if;
                
                flit_in <= flit_var;
                
            end if;
        end if;
    
    end process;
    
    -- PROCES KOJI IZRACUNAVA TRENUTNO STANJE
    synchronous_process : process (clk) is
    
    begin
        
        if rising_edge(clk) then
            if rst = '0' then
                current_state <= initial_state;
            else
                current_state <= next_state;
            end if;
        end if;    
        
    end process;

end Behavioral;