----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 10.05.2021 13:05:41
-- Design Name: AXI_Network_Adapter
-- Module Name: SNA_resp_AXI_handshake_controller - Behavioral
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
-- Revision 0.1 - 2020-05-10 - Mrkovic, Ramljak
-- Additional Comments: Prva verzija SNA_resp_AXI_handshake_controllera
-- Revision 0.2 - 2021-05-17 - Mrkovic
-- Additional Comments: Dotjerana verzija SNA_resp_AXI_handshake_controllera
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

entity SNA_resp_AXI_handshake_controller is

    Port (
        clk : in std_logic;
        rst : in std_logic; 
        
        -- AXI WRITE RESPONSE CHANNEL
        BRESP : in std_logic_vector(1 downto 0);
        BVALID : in std_logic;
        BREADY : out std_logic;
        
        -- AXI READ RESPONSE CHANNEL
        RDATA : in std_logic_vector(31 downto 0);
        RRESP : in std_logic_vector(1 downto 0);
        RVALID : in std_logic;
        RREADY : out std_logic;
        
        -- SNA_resp_buffer_controller
        op_write : out std_logic;
        op_read : out std_logic;
        
        data : out std_logic_vector(31 downto 0);
        resp : out std_logic_vector(1 downto 0);
        
        -- AXI_to_noc_FIFO_buffer
        buffer_write_ready : in std_logic;
        buffer_read_ready : in std_logic;
        
        -- req_flow (SNA_req_buffer_controller)
        resp_write : in std_logic;
        resp_read : in std_logic
    );

end SNA_resp_AXI_handshake_controller;

architecture Behavioral of SNA_resp_AXI_handshake_controller is

    -- ENUMERACIJA STANJA fsm-a
    type state_type is (IDLE, PREWRITE, WRITE, PREREAD, READ);
    -- TRENUTNO STANJE
    signal current_state : state_type;
    -- SLJEDECE STANJE
    signal next_state : state_type;
    -- POCETNO STANJE
    constant initial_state : state_type := IDLE;
    
    signal op_write_enable : std_logic;
    signal op_read_enable : std_logic;
    signal data_write_enable : std_logic;
    signal data_read_enable : std_logic;

begin

    -- PROCES KOJI KOORDINIRA PROCESE POJEDINIH STANJA
    combinatorial_process : process (current_state, BVALID, RVALID, resp_write, resp_read, buffer_read_ready, buffer_write_ready) is
    
    begin
    
        BREADY <= '0';
        RREADY <= '0';
        
        op_write_enable <= '0';
        op_read_enable <= '0';
        
        data_write_enable <= '0';
        data_read_enable <= '0';
    
        case current_state is
        
            when IDLE =>
            
                if resp_write = '1' then
                
                    if buffer_write_ready = '1' then
                    
                        next_state <= WRITE;
                    
                    else
                    
                        next_state <= PREWRITE;
                    
                    end if;
                
                elsif resp_read = '1' then
                
                    if buffer_read_ready = '1' then
                    
                        next_state <= READ;
                    
                    else
                    
                        next_state <= PREREAD;
                    
                    end if;
                
                else
                
                    next_state <= IDLE;
                
                end if;
            
            when PREWRITE =>
            
                if buffer_write_ready = '1' then
                
                    next_state <= WRITE;
                
                else
                
                    next_state <= PREWRITE;
                
                end if;
            
            when WRITE =>
            
                BREADY <= '1';
            
                if BVALID = '1' then
                
                    data_write_enable <= '1';
                    op_write_enable <= '1';
                
                    next_state <= IDLE;
                
                else
                
                    next_state <= WRITE;
                
                end if;
            
            when PREREAD =>
            
                if buffer_read_ready = '1' then
                
                    next_state <= READ;
                
                else
                
                    next_state <= PREREAD;
                
                end if;
            
            when READ =>
            
                RREADY <= '1';
            
                if RVALID = '1' then
                
                    data_read_enable <= '1';
                    op_read_enable <= '1';
                
                    next_state <= IDLE;
                
                else
                
                    next_state <= READ;
                
                end if;
            
        end case;
    
    end process;
    
    -- PROCES KOJI PRIVREMENO POHRANJUJE PODATKE
    data_process : process (clk) is
    
        variable data_var : std_logic_vector(31 downto 0);
        variable resp_var : std_logic_vector(1 downto 0);
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
            
                data_var := (others => '0');
                resp_var := (others => '0');
                
                data <= (others => '0');
                resp <= (others => '0');
                
            else
                
                if data_write_enable = '1' then
                
                    data_var := (others => '0');
                    resp_var := BRESP;
                
                end if;
                
                if data_read_enable = '1' then
                
                    data_var := RDATA;
                    resp_var := RRESP;
                
                end if;
                
                data <= data_var;
                resp <= resp_var;
                
            end if;
        end if;
    
    end process;
    
    -- PROCES KOJI GENERIRA op_write I op_read SIGNALE
    op_process : process (clk) is
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
                
                op_write <= '0';
                op_read <= '0';
                
            else
            
                op_write <= '0';
                op_read <= '0';
                
                if op_write_enable = '1' then
                
                    op_write <= '1';
                
                end if;
                
                if op_read_enable = '1' then
                
                    op_read <= '1';
                
                end if;
                
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