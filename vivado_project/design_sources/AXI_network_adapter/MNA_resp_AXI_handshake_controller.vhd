----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/04/2021 01:30:55 PM
-- Design Name: AXI_Network_Adapter
-- Module Name: MNA_resp_AXI_handshake_controller - Behavioral
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
-- Revision 0.1 - 2021-05-04 - Mrkovic, Ramljak
-- Additional Comments: Prva verzija MNA_resp_AXI_handshake_controllera
-- Revision 0.2 - 2021-05-17 - Mrkovic
-- Additional Comments: Dotjerana verzija MNA_resp_AXI_handshake_controllera
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

entity MNA_resp_AXI_handshake_controller is

    Port (
        clk : in std_logic;
        rst : in std_logic; 

        -- AXI WRITE RESPONSE CHANNEL
        BRESP : out std_logic_vector(1 downto 0);
        BVALID : out std_logic;
        BREADY : in std_logic;
        
        -- AXI READ RESPONSE CHANNEL
        RDATA : out std_logic_vector(31 downto 0);
        RRESP : out std_logic_vector(1 downto 0);
        RVALID : out std_logic;
        RREADY : in std_logic;
        
        -- MNA_resp_buffer_controller
        op_write : in std_logic;
        op_read : in std_logic;
        
        data : in std_logic_vector(31 downto 0);
        resp : in std_logic_vector(1 downto 0)
    );

end MNA_resp_AXI_handshake_controller;

architecture Behavioral of MNA_resp_AXI_handshake_controller is

    -- ENUMERACIJA STANJA fsm-a
    type state_type is (IDLE, WRITE, READ);
    -- TRENUTNO STANJE
    signal current_state : state_type;
    -- SLJEDECE STANJE
    signal next_state : state_type;
    -- POCETNO STANJE
    constant initial_state : state_type := IDLE;

begin

    -- PROCES KOJI KOORDINIRA PROCESE POJEDINIH STANJA
    combinatorial_process : process (current_state, BREADY, RREADY, op_write, op_read) is

    begin
    
        BVALID <= '0';
        RVALID <= '0';
    
        case current_state is
        
            when IDLE =>
                
                if op_write = '1' then
                
                    next_state <= WRITE;
                
                elsif op_read = '1' then
                
                    next_state <= READ;
                
                else
                
                    next_state <= IDLE;
                
                end if;
            
            when WRITE =>
                
                BVALID <= '1';
                
                if BREADY = '1' then
                    
                    next_state <= IDLE;
                    
                else
                
                    next_state <= WRITE;
                    
                end if;
            
            when READ =>
            
                RVALID <= '1';
                
                if RREADY = '1' then
                
                    next_state <= IDLE;
                    
                else
                
                    next_state <= READ;
                
                end if;
        
        end case;
    
    end process;
    
    -- PROCES KOJI PRIVREMENO POHRANJUJE PODATKE
    data_process : process (clk) is
    
        variable bresp_var : std_logic_vector(1 downto 0);
        variable rdata_var : std_logic_vector(31 downto 0);
        variable rresp_var : std_logic_vector(1 downto 0);
        
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
            
                bresp_var := (others => '0');
                rdata_var := (others => '0');
                rresp_var := (others => '0');
                
                BRESP <= (others => '0');
                RDATA <= (others => '0');
                RRESP <= (others => '0');
                
            else
                
                if op_write = '1' then
                
                    bresp_var := resp;
                
                end if;
                
                if op_read = '1' then
                
                    rdata_var := data;
                    rresp_var := resp;
                
                end if;
                
                BRESP <= bresp_var;
                RDATA <= rdata_var;
                RRESP <= rresp_var;
                
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