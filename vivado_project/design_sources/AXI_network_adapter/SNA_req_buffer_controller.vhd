----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 10.05.2021 16:30:21
-- Design Name: AXI_Network_Adapter
-- Module Name: SNA_req_buffer_controller - Behavioral
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
-- Revision 0.1 - 2021-05-10 - Mrkovic
-- Additional Comments: Prva verzija SNA_req_buffer_controllera
-- Revision 0.2 - 2021-05-18 - Mrkovic
-- Additional Comments: Dotjerana verzija SNA_req_buffer_controllera
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

entity SNA_req_buffer_controller is

    Generic (
        vc_num : integer := const_vc_num;
        address_size : integer := const_address_size;
        payload_size : integer := const_payload_size;
        flit_size : integer := const_flit_size
    );
                  
    Port (
        clk : in std_logic;
        rst : in std_logic; 
        
        -- SNA_req_AXI_handshake_controller
        op_write : out std_logic;
        op_read : out std_logic;
        
        addr : out std_logic_vector(31 downto 0);
        data : out std_logic_vector(31 downto 0);
        prot : out std_logic_vector(2 downto 0);
        strb : out std_logic_vector(3 downto 0);
        
        -- noc_to_AXI_FIFO_buffer
        flit_out : in std_logic_vector(flit_size - 1 downto 0);
        has_tail : in std_logic;
        
        right_shift : out std_logic;
        
        -- noc_receiver
        vc_credits : out std_logic_vector(vc_num - 1 downto 0);
        
        -- resp_flow (SNA_resp_AXI_handshake_controller)
        resp_write : out std_logic;
        resp_read : out std_logic;
        
        -- resp_flow (SNA_resp_buffer_controller)
        r_addr : out std_logic_vector(address_size - 1 downto 0);
        r_vc : out std_logic_vector(vc_num - 1 downto 0);
        
        -- t_monitor
        SNA_ready : in std_logic;
        t_begun : out std_logic
    );

end SNA_req_buffer_controller;

architecture Behavioral of SNA_req_buffer_controller is

    -- ENUMERACIJA STANJA fsm-a
    type state_type is (IDLE, W_FLIT_1, W_FLIT_2, W_FLIT_3, R_FLIT_1, R_FLIT_2);
    -- TRENUTNO STANJE
    signal current_state : state_type;
    -- SLJEDECE STANJE
    signal next_state : state_type;
    -- POCETNO STANJE
    constant initial_state : state_type := IDLE;
    
    -- enable SIGNALI PROCESA INDIVIDUALNIH STANJA
    signal W_FLIT_1_enable : std_logic;
    signal W_FLIT_2_enable : std_logic;
    signal W_FLIT_3_enable : std_logic;
    signal R_FLIT_1_enable : std_logic;
    signal R_FLIT_2_enable : std_logic;

begin

    -- PROCES KOJI KOORDINIRA PROCESE POJEDINIH STANJA
    combinatorial_process : process (current_state, flit_out, has_tail, SNA_ready) is
    
    begin
    
        op_write <= '0';
        op_read <= '0';
        
        resp_write <= '0';
        resp_read <= '0';
        
        right_shift <= '0';
        
        vc_credits <= (others => '0');
        
        t_begun <= '0';
        
        W_FLIT_1_enable <= '0';
        W_FLIT_2_enable <= '0';
        W_FLIT_3_enable <= '0';
        R_FLIT_1_enable <= '0';
        R_FLIT_2_enable <= '0';
        
        case current_state is
        
            when IDLE =>
            
                if has_tail = '1' and SNA_ready = '1' then
                
                    right_shift <= '1';
                    vc_credits <= flit_out(flit_size - 2 - 1 downto flit_size - 2 - vc_num);
                    t_begun <= '1';
                
                    if flit_out(0) = '0' then
                    
                        W_FLIT_1_enable <= '1';
                        next_state <= W_FLIT_1;
                    
                    else
                    
                        R_FLIT_1_enable <= '1';
                        next_state <= R_FLIT_1;
                    
                    end if;
                
                else
                
                    next_state <= IDLE;
                
                end if;
            
            when W_FLIT_1 =>
            
                right_shift <= '1';
                vc_credits <= flit_out(flit_size - 2 - 1 downto flit_size - 2 - vc_num);
                W_FLIT_2_enable <= '1';
                next_state <= W_FLIT_2;
            
            when W_FLIT_2 =>
            
                right_shift <= '1';
                vc_credits <= flit_out(flit_size - 2 - 1 downto flit_size - 2 - vc_num);
                W_FLIT_3_enable <= '1';
                next_state <= W_FLIT_3;
            
            when W_FLIT_3 =>
            
                op_write <= '1';
                resp_write <= '1';
                next_state <= IDLE;
            
            when R_FLIT_1 =>
            
                right_shift <= '1';
                vc_credits <= flit_out(flit_size - 2 - 1 downto flit_size - 2 - vc_num);
                R_FLIT_2_enable <= '1';
                next_state <= R_FLIT_2;
            
            when R_FLIT_2 =>
            
                op_read <= '1';
                resp_read <= '1';
                next_state <= IDLE;
                
        end case;
                
    end process;
    
    -- PROCES KOJI RASTVARA FLITOVE I PROSLJEDJUJE PODATKE
    unboxer_process : process (clk) is
    
        variable addr_var : std_logic_vector(31 downto 0);
        variable data_var : std_logic_vector(31 downto 0);
        variable prot_var : std_logic_vector(2 downto 0);
        variable strb_var : std_logic_vector(3 downto 0);
        variable r_addr_var : std_logic_vector(address_size - 1 downto 0);
        variable r_vc_var : std_logic_vector(vc_num - 1 downto 0);
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
            
                addr_var := (others => '0');
                data_var := (others => '0');
                prot_var := (others => '0');
                strb_var := (others => '0');
                r_addr_var := (others => '0');
                r_vc_var := (others => '0');
                
                addr <= (others => '0');
                data <= (others => '0');
                prot <= (others => '0');
                strb <= (others => '0');
                r_addr <= (others => '0');
                r_vc <= (others => '0');
            
            else
            
                if W_FLIT_1_enable = '1' then
                
                    addr_var := (others => '0');
                    data_var := (others => '0');
                    prot_var := flit_out(3 downto 1);
                    strb_var := flit_out(7 downto 4);
                    r_addr_var := flit_out(payload_size - 1 downto payload_size - address_size);
                    r_vc_var := flit_out(flit_size - 2 - 1 downto flit_size - 2 - vc_num);
                
                elsif W_FLIT_2_enable = '1' then
                
                    addr_var := flit_out(31 downto 0);
                
                elsif W_FLIT_3_enable = '1' then
                
                    data_var := flit_out(31 downto 0);
                
                elsif R_FLIT_1_enable = '1' then
                
                    addr_var := (others => '0');
                    data_var := (others => '0');
                    prot_var := flit_out(3 downto 1);
                    strb_var := (others => '0');
                    r_addr_var := flit_out(payload_size - 1 downto payload_size - address_size);
                    r_vc_var := flit_out(flit_size - 2 - 1 downto flit_size - 2 - vc_num);
                
                elsif R_FLIT_2_enable = '1' then
                
                    addr_var := flit_out(31 downto 0);
                
                end if;
                
                addr <= addr_var;
                data <= data_var;
                prot <= prot_var;
                strb <= strb_var;
                r_addr <= r_addr_var;
                r_vc <= r_vc_var;
            
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