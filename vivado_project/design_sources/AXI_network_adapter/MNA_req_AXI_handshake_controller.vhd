----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/04/2021 11:25:02 AM
-- Design Name: AXI_Network_Adapter
-- Module Name: MNA_req_AXI_handshake_controller - Behavioral
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
-- Additional Comments: Prva verzija MNA_req_AXI_handshake_controllera
-- Revision 0.2 - 2021-05-17 - Mrkovic
-- Additional Comments: Dotjerana verzija MNA_req_AXI_handshake_controllera
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

entity MNA_req_AXI_handshake_controller is
           
    Port (
        clk : in std_logic;
        rst : in std_logic; 

        -- AXI WRITE ADDRESS CHANNEL
        AWADDR : in std_logic_vector(31 downto 0);
        AWPROT : in std_logic_vector(2 downto 0);
        AWVALID : in std_logic;
        AWREADY : out std_logic;

        -- AXI WRITE DATA CHANNEL
        WDATA : in std_logic_vector(31 downto 0);
        WSTRB : in std_logic_vector(3 downto 0);
        WVALID : in std_logic;
        WREADY : out std_logic;

        -- AXI READ ADDRESS CHANNEL
        ARADDR : in std_logic_vector(31 downto 0);
        ARPROT : in std_logic_vector(2 downto 0);
        ARVALID : in std_logic;
        ARREADY : out std_logic;

        -- MNA_req_buffer_controller
        op_write : out std_logic;
        op_read : out std_logic;

        addr : out std_logic_vector(31 downto 0);
        data : out std_logic_vector(31 downto 0);
        prot : out std_logic_vector(2 downto 0);
        strb : out std_logic_vector(3 downto 0);
        
        -- AXI_to_noc_FIFO_buffer
        buffer_write_ready : in std_logic;
        buffer_read_ready : in std_logic
    );

end MNA_req_AXI_handshake_controller;

architecture Behavioral of MNA_req_AXI_handshake_controller is

    -- ENUMERACIJA STANJA fsm-a
    type state_type is (IDLE, WRITE, READ);
    -- TRENUTNO STANJE
    signal current_state : state_type;
    -- SLJEDECE STANJE
    signal next_state : state_type;
    -- POCETNO STANJE
    constant initial_state : state_type := IDLE;
    
    signal data_write_enable : std_logic;
    signal data_read_enable : std_logic;

begin

    -- PROCES KOJI KOORDINIRA PROCESE POJEDINIH STANJA
    combinatorial_process : process (current_state, AWVALID, WVALID, ARVALID, buffer_write_ready, buffer_read_ready) is
    
    begin
    
        AWREADY <= '0';
        WREADY <= '0';
        ARREADY <= '0';
        
        op_write <= '0';
        op_read <= '0';
        
        data_write_enable <= '0';
        data_read_enable <= '0';
    
        case current_state is
        
            when IDLE =>
            
                if AWVALID = '1' and WVALID = '1' and buffer_write_ready = '1' then
                    
                    data_write_enable <= '1';
                    
                    next_state <= WRITE;
                
                elsif ARVALID = '1' and buffer_read_ready = '1' then
                    
                    data_read_enable <= '1';
                    
                    next_state <= READ;
                    
                else
                
                    next_state <= IDLE;
                
                end if;   
            
            when WRITE =>
            
                AWREADY <= '1';
                WREADY <= '1';
                
                op_write <= '1';
                
                next_state <= IDLE;
            
            when READ =>
            
                ARREADY <= '1';
                
                op_read <= '1';
                
                next_state <= IDLE;
            
        end case;
    
    end process;
    
    -- PROCES KOJI PRIVREMENO POHRANJUJE PODATKE
    data_process : process (clk) is
    
        variable addr_var : std_logic_vector(31 downto 0);
        variable data_var : std_logic_vector(31 downto 0);
        variable prot_var : std_logic_vector(2 downto 0);
        variable strb_var : std_logic_vector(3 downto 0);
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
            
                addr_var := (others => '0');
                data_var := (others => '0');
                prot_var := (others => '0');
                strb_var := (others => '0');
                
                addr <= (others => '0');
                data <= (others => '0');
                prot <= (others => '0');
                strb <= (others => '0');
                
            else
                
                if data_write_enable = '1' then
                
                    addr_var := AWADDR;
                    data_var := WDATA;
                    prot_var := AWPROT;
                    strb_var := WSTRB;
                
                end if;
                
                if data_read_enable = '1' then
                
                    addr_var := ARADDR;
                    data_var := (others => '0');
                    prot_var := ARPROT;
                    strb_var := (others => '0');
                
                end if;
                
                addr <= addr_var;
                data <= data_var;
                prot <= prot_var;
                strb <= strb_var;
                
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