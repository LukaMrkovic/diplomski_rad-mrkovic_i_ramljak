----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/05/2021 11:14:44 AM
-- Design Name: AXI_Network_Adapter
-- Module Name: MNA_req_buffer_controller - Behavioral
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
-- Additional Comments: Prva verzija MNA_req_buffer_controllera
-- Revision 0.2 - 2021-05-18 - Mrkovic
-- Additional Comments: Dotjerana verzija MNA_req_buffer_controllera
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

entity MNA_req_buffer_controller is

    Generic (
        vc_num : integer := const_vc_num;
        mesh_size_x : integer := const_mesh_size_x;
        mesh_size_y : integer := const_mesh_size_y;
        address_size : integer := const_address_size;
        payload_size : integer := const_payload_size;
        flit_size : integer := const_flit_size;
        local_address_x : std_logic_vector(const_mesh_size_x - 1 downto 0) := const_default_address_x;
        local_address_y : std_logic_vector(const_mesh_size_y - 1 downto 0) := const_default_address_y;
        
        injection_vc : integer := const_default_injection_vc;
        node_address_size : integer := const_node_address_size
    );
                  
    Port (
        clk : in std_logic;
        rst : in std_logic; 
        
        -- MNA_req_AXI_handshake_controller
        op_write : in std_logic;
        op_read : in std_logic;
        
        addr : in std_logic_vector(31 downto 0);
        data : in std_logic_vector(31 downto 0);
        prot : in std_logic_vector(2 downto 0);
        strb : in std_logic_vector(3 downto 0);
        
        -- AXI_to_noc_FIFO_buffer
        flit_in : out std_logic_vector(flit_size - 1 downto 0);
        flit_in_valid : out std_logic
    );    

end MNA_req_buffer_controller;

architecture Behavioral of MNA_req_buffer_controller is

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
    combinatorial_process : process (current_state, op_write, op_read) is
    
    begin
    
        flit_in_valid <= '0';
    
        W_FLIT_1_enable <= '0';
        W_FLIT_2_enable <= '0';
        W_FLIT_3_enable <= '0';
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
                W_FLIT_2_enable <= '1';
                next_state <= W_FLIT_2;
                
            when W_FLIT_2 =>
            
                flit_in_valid <= '1';
                W_FLIT_3_enable <= '1';
                next_state <= W_FLIT_3;
                
            when W_FLIT_3 =>
            
                flit_in_valid <= '1';
                next_state <= IDLE;
                
            when R_FLIT_1 =>
            
                flit_in_valid <= '1';
                R_FLIT_2_enable <= '1';
                next_state <= R_FLIT_2;
                
            when R_FLIT_2 =>
            
                flit_in_valid <= '1';
                next_state <= IDLE;
            
        end case;
    
    end process;
    
    -- PROCES KOJI GRADI I ODASILJE FLITOVE
    builder_process : process (clk) is
    
        variable flit_var : std_logic_vector(flit_size - 1 downto 0);
        
        variable vc_var : std_logic_vector(vc_num - 1 downto 0);
        variable dest : std_logic_vector(node_address_size - 1 downto 0);
        variable dest_int : integer;
        variable index_x : integer;
        variable index_y : integer;
        variable dest_x : std_logic_vector(mesh_size_x - 1 downto 0);
        variable dest_y : std_logic_vector(mesh_size_y - 1 downto 0);
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
                
                flit_var := (others => '0');
                vc_var := (others => '0');
                dest := (others => '0');
                dest_int := 0;
                index_x := 0;
                index_y := 0;
                dest_x := (others => '0');
                dest_y := (others => '0');
                
                flit_in <= (others => '0');
                
            else
            
                flit_var := (others => '0');
                vc_var := (injection_vc => '1', others => '0');
                dest := addr(32 - 1 downto 32 - node_address_size);
                dest_int := conv_integer(dest);
                index_x := dest_int mod mesh_size_x;
                index_y := dest_int / mesh_size_x;
                dest_x := (others => '0');
                dest_x(index_x) := '1';
                dest_y := (others => '0');
                dest_y(index_y) := '1';
                
                if W_FLIT_1_enable = '1' then
                
                    -- FLIT LABELA
                    flit_var(flit_size - 1 downto
                             flit_size - 2) := "10";
                    -- VIRTUALNI KANAL
                    flit_var(flit_size - 2 - 1 downto
                             flit_size - 2 - vc_num) := vc_var;
                    -- X KOORDNIATA DESTINACIJE
                    flit_var(flit_size - 2 - vc_num - 1 downto
                             flit_size - 2 - vc_num - mesh_size_x) := dest_x; 
                    -- Y KOORDINATA DESTINACIJE
                    flit_var(flit_size - 2 - vc_num - mesh_size_x - 1 downto
                             flit_size - 2 - vc_num - mesh_size_x - mesh_size_y) := dest_y;
                    -- X KOORDINATA POVRATNE ADRESE
                    flit_var(flit_size - 2 - vc_num - mesh_size_x - mesh_size_y - 1 downto
                             flit_size - 2 - vc_num - mesh_size_x - mesh_size_y - mesh_size_x) := local_address_x;
                    -- Y KOORDINATA POVRATNE ADRESE
                    flit_var(flit_size - 2 - vc_num - mesh_size_x - mesh_size_y - mesh_size_x - 1 downto
                             flit_size - 2 - vc_num - mesh_size_x - mesh_size_y - mesh_size_x - mesh_size_y) := local_address_y;
                    -- WRITE STROBE
                    flit_var(7 downto 4) := strb;
                    -- WRITE PROTECTION
                    flit_var(3 downto 1) := prot;
                    -- R/W
                    flit_var(0) := '0';
                
                elsif W_FLIT_2_enable = '1' then
                
                    -- FLIT LABELA
                    flit_var(flit_size - 1 downto
                             flit_size - 2) := "00";
                    -- VIRTUALNI KANAL
                    flit_var(flit_size - 2 - 1 downto
                             flit_size - 2 - vc_num) := vc_var;
                    -- X KOORDNIATA DESTINACIJE
                    flit_var(flit_size - 2 - vc_num - 1 downto
                             flit_size - 2 - vc_num - mesh_size_x) := dest_x; 
                    -- Y KOORDINATA DESTINACIJE
                    flit_var(flit_size - 2 - vc_num - mesh_size_x - 1 downto
                             flit_size - 2 - vc_num - mesh_size_x - mesh_size_y) := dest_y;
                    -- WRITE ADDRESS
                    flit_var(31 downto 0) := addr;
                
                elsif W_FLIT_3_enable = '1' then
                
                    -- FLIT LABELA
                    flit_var(flit_size - 1 downto
                             flit_size - 2) := "01";
                    -- VIRTUALNI KANAL
                    flit_var(flit_size - 2 - 1 downto
                             flit_size - 2 - vc_num) := vc_var;
                    -- X KOORDNIATA DESTINACIJE
                    flit_var(flit_size - 2 - vc_num - 1 downto
                             flit_size - 2 - vc_num - mesh_size_x) := dest_x; 
                    -- Y KOORDINATA DESTINACIJE
                    flit_var(flit_size - 2 - vc_num - mesh_size_x - 1 downto
                             flit_size - 2 - vc_num - mesh_size_x - mesh_size_y) := dest_y;
                    -- WRITE DATA
                    flit_var(31 downto 0) := data;
                
                elsif R_FLIT_1_enable = '1' then
                
                    -- FLIT LABELA
                    flit_var(flit_size - 1 downto
                             flit_size - 2) := "10";
                    -- VIRTUALNI KANAL
                    flit_var(flit_size - 2 - 1 downto
                             flit_size - 2 - vc_num) := vc_var;
                    -- X KOORDNIATA DESTINACIJE
                    flit_var(flit_size - 2 - vc_num - 1 downto
                             flit_size - 2 - vc_num - mesh_size_x) := dest_x; 
                    -- Y KOORDINATA DESTINACIJE
                    flit_var(flit_size - 2 - vc_num - mesh_size_x - 1 downto
                             flit_size - 2 - vc_num - mesh_size_x - mesh_size_y) := dest_y;
                    -- X KOORDINATA POVRATNE ADRESE
                    flit_var(flit_size - 2 - vc_num - mesh_size_x - mesh_size_y - 1 downto
                             flit_size - 2 - vc_num - mesh_size_x - mesh_size_y - mesh_size_x) := local_address_x;
                    -- Y KOORDINATA POVRATNE ADRESE
                    flit_var(flit_size - 2 - vc_num - mesh_size_x - mesh_size_y - mesh_size_x - 1 downto
                             flit_size - 2 - vc_num - mesh_size_x - mesh_size_y - mesh_size_x - mesh_size_y) := local_address_y;
                    -- READ PROTECTION
                    flit_var(3 downto 1) := prot;
                    -- R/W
                    flit_var(0) := '1';
                
                elsif R_FLIT_2_enable = '1' then
                
                    -- FLIT LABELA
                    flit_var(flit_size - 1 downto
                             flit_size - 2) := "01";
                    -- VIRTUALNI KANAL
                    flit_var(flit_size - 2 - 1 downto
                             flit_size - 2 - vc_num) := vc_var;
                    -- X KOORDNIATA DESTINACIJE
                    flit_var(flit_size - 2 - vc_num - 1 downto
                             flit_size - 2 - vc_num - mesh_size_x) := dest_x; 
                    -- Y KOORDINATA DESTINACIJE
                    flit_var(flit_size - 2 - vc_num - mesh_size_x - 1 downto
                             flit_size - 2 - vc_num - mesh_size_x - mesh_size_y) := dest_y;
                    -- READ ADDRESS
                    flit_var(31 downto 0) := addr;
                
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