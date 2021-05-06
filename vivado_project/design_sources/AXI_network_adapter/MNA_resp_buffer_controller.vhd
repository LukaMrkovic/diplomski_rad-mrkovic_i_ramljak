----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/05/2021 02:32:13 PM
-- Design Name: AXI_Network_Adapter
-- Module Name: MNA_resp_buffer_controller - Behavioral
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
-- Revision 0.1 - 2021-05-05 - Mrkovic, Ramljak
-- Additional Comments: Prva verzija MNA_resp_buffer_controllera
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

entity MNA_resp_buffer_controller is

    Generic (
        flit_size : integer := const_flit_size
    );
                  
    Port (
        clk : in std_logic;
        rst : in std_logic; 
                   
        flit_out : in std_logic_vector(flit_size - 1 downto 0);
        has_tail : in std_logic;
        
        right_shift : out std_logic;
        
        op_write : out std_logic;
        op_read : out std_logic;
        
        data : out std_logic_vector(31 downto 0);
        resp : out std_logic_vector(1 downto 0)
    );

end MNA_resp_buffer_controller;

architecture Behavioral of MNA_resp_buffer_controller is

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
    combinatorial_process : process (current_state, has_tail) is
    
    begin
    
        W_FLIT_1_enable <= '0';
        R_FLIT_1_enable <= '0';
        R_FLIT_2_enable <= '0';
        right_shift <= '0';
    
        case current_state is
        
            when IDLE =>
            
                if has_tail = '1' and 
                   flit_out(0) = '0' then
                    
                    next_state <= W_FLIT_1;
                    W_FLIT_1_enable <= '1';
                    right_shift <= '1';
                
                elsif has_tail = '1' and
                      flit_out(0) = '1' then
                    
                    next_state <= R_FLIT_1;
                    R_FLIT_1_enable <= '1';
                    right_shift <= '1';
                    
                else
                
                    next_state <= IDLE;
                
                end if;   
            
            when W_FLIT_1 =>
            
                next_state <= IDLE;
            
            when R_FLIT_1 =>
            
                next_state <= R_FLIT_2;
                R_FLIT_2_enable <= '1';
                right_shift <= '1';
                
            when R_FLIT_2 =>
            
                next_state <= IDLE;
            
        end case;
    
    end process;
    
    -- PROCES KOJI RASTVARA FLITOVE I ODASILJE PODATKE
    unboxer_process : process (clk) is
    
        variable data_var : std_logic_vector(31 downto 0);
        variable resp_var : std_logic_vector(1 downto 0);
        variable op_write_var : std_logic;
        variable op_read_var : std_logic;
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
                
                data_var := (others => '0');
                resp_var := (others => '0');
                op_write_var := '0';
                op_read_var := '0';
                
                
                data <= (others => '0');
                resp <= (others => '0');
                op_write <= '0';
                op_read <= '0';
                
            else
            
                op_write_var := '0';
                op_read_var := '0';
                
                if W_FLIT_1_enable = '1' then
                
                    op_write_var := '1';
                    data_var := (others => '0');
                    resp_var := flit_out(2 downto 1);
                
                elsif R_FLIT_1_enable = '1' then
                
                    data_var := (others => '0');
                    resp_var := flit_out(2 downto 1);
                
                elsif R_FLIT_2_enable = '1' then
                
                    op_read_var := '1';
                    data_var := flit_out(31 downto 0);
                
                end if;
                
                data <= data_var;
                resp <= resp_var;
                op_write <= op_write_var;
                op_read <= op_read_var;
                
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