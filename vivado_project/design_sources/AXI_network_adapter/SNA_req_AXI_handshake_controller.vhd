----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 10.05.2021 11:14:03
-- Design Name: AXI_Network_Adapter
-- Module Name: SNA_req_AXI_handshake_controller - Behavioral
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
-- Revision 0.1 - 2021-05-10 - Mrkovic, Ramljak
-- Additional Comments: Prva verzija SNA_req_AXI_handshake_controllera
-- Revision 0.2 - 2021-05-17 - Mrkovic
-- Additional Comments: Dotjerana verzija SNA_req_AXI_handshake_controllera
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

entity SNA_req_AXI_handshake_controller is

    Port (
        clk : in std_logic;
        rst : in std_logic; 
        
        -- AXI WRITE ADDRESS CHANNEL
        AWADDR : out std_logic_vector(31 downto 0);
        AWPROT : out std_logic_vector(2 downto 0);
        AWVALID : out std_logic;
        AWREADY : in std_logic;
        
        -- AXI WRITE DATA CHANNEL
        WDATA : out std_logic_vector(31 downto 0);
        WSTRB : out std_logic_vector(3 downto 0);
        WVALID : out std_logic;
        WREADY : in std_logic;
        
        -- AXI READ ADDRESS CHANNEL
        ARADDR : out std_logic_vector(31 downto 0);
        ARPROT : out std_logic_vector(2 downto 0);
        ARVALID : out std_logic;
        ARREADY : in std_logic;
        
        -- SNA_req_buffer_controller
        op_write : in std_logic;
        op_read : in std_logic;
        
        addr : in std_logic_vector(31 downto 0);
        data : in std_logic_vector(31 downto 0);
        prot : in std_logic_vector(2 downto 0);
        strb : in std_logic_vector(3 downto 0);
        
        -- resp_flow (AXI_to_noc_FIFO_buffer)
        buffer_write_ready : in std_logic;
        buffer_read_ready : in std_logic
    );

end SNA_req_AXI_handshake_controller;

architecture Behavioral of SNA_req_AXI_handshake_controller is

    -- ENUMERACIJA STANJA fsm-a
    type state_type is (IDLE, PREWRITE, WRITE, PREREAD, READ);
    -- TRENUTNO STANJE
    signal current_state : state_type;
    -- SLJEDECE STANJE
    signal next_state : state_type;
    -- POCETNO STANJE
    constant initial_state : state_type := IDLE;
    
    -- UNUTARNJI SIGNALI
    -- UNUTARNJI WRITE SIGNALI
    signal AWADDR_int : std_logic_vector(31 downto 0);
    signal AWPROT_int : std_logic_vector(2 downto 0);
    signal WDATA_int : std_logic_vector(31 downto 0);
    signal WSTRB_int : std_logic_vector(3 downto 0);
    signal W_output_enable : std_logic_vector(31 downto 0);
    -- UNUTARNJI READ SIGNALI
    signal ARADDR_int : std_logic_vector(31 downto 0);
    signal ARPROT_int : std_logic_vector(2 downto 0);
    signal R_output_enable : std_logic_vector(31 downto 0);

begin

    -- PROCES KOJI KOORDINIRA PROCESE POJEDINIH STANJA
    combinatorial_process : process (current_state, AWREADY, WREADY, ARREADY, op_write, op_read, buffer_read_ready, buffer_write_ready) is
    
    begin
    
        AWVALID <= '0';
        WVALID <= '0';
        ARVALID <= '0';
        
        W_output_enable <= (others => '0');
        R_output_enable <= (others => '0');
    
        case current_state is
        
            when IDLE =>
            
                if op_write = '1' then
                
                    if buffer_write_ready = '1' then
                    
                        next_state <= WRITE;
                    
                    else
                    
                        next_state <= PREWRITE;
                    
                    end if;
                
                elsif op_read = '1' then
                
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
            
                AWVALID <= '1';
                WVALID <= '1';
                
                W_output_enable <= (others => '1');
            
                if AWREADY = '1' and WREADY = '1' then
                
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
            
                ARVALID <= '1';
                
                R_output_enable <= (others => '1');
            
                if ARREADY = '1' then
                
                    next_state <= IDLE;
                
                else
                
                    next_state <= READ;
                
                end if;
            
        end case;
    
    end process;
    
    -- PROCES KOJI PRIVREMENO POHRANJUJE PODATKE
    data_process : process (clk) is
    
        variable awaddr_var : std_logic_vector(31 downto 0);
        variable awprot_var : std_logic_vector(2 downto 0);
        variable wdata_var : std_logic_vector(31 downto 0);
        variable wstrb_var : std_logic_vector(3 downto 0);
        variable araddr_var : std_logic_vector(31 downto 0);
        variable arprot_var : std_logic_vector(2 downto 0);
        
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
            
                awaddr_var := (others => '0');
                awprot_var := (others => '0');
                wdata_var := (others => '0');
                wstrb_var := (others => '0');
                araddr_var := (others => '0');
                arprot_var := (others => '0');
                
                AWADDR_int <= (others => '0');
                AWPROT_int <= (others => '0');
                WDATA_int <= (others => '0');
                WSTRB_int <= (others => '0');
                ARADDR_int <= (others => '0');
                ARPROT_int <= (others => '0');
                
            else
                
                if op_write = '1' then
                
                    awaddr_var := addr;
                    wdata_var := data;
                    awprot_var := prot;
                    wstrb_var := strb;
                
                end if;
                
                if op_read = '1' then
                
                    araddr_var := addr;
                    arprot_var := prot;
                
                end if;
                
                AWADDR_int <= awaddr_var;
                WDATA_int <= wdata_var;
                AWPROT_int <= awprot_var;
                WSTRB_int <= wstrb_var;
                ARADDR_int <= araddr_var;
                ARPROT_int <= arprot_var;
                
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
    
    -- OUTPUT WRITE
    AWADDR <= AWADDR_int and W_output_enable(31 downto 0);
    WDATA <= WDATA_int and W_output_enable(31 downto 0);
    AWPROT <= AWPROT_int and W_output_enable(2 downto 0);
    WSTRB <= WSTRB_int and W_output_enable(3 downto 0);
    -- OUTPUT READ
    ARADDR <= ARADDR_int and R_output_enable(31 downto 0);
    ARPROT <= ARPROT_int and R_output_enable(2 downto 0);

end Behavioral;