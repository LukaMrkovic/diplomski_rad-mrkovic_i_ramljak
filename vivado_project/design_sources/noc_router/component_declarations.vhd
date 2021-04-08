----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 30.03.2021 15:53:32
-- Design Name: NoC_Router
-- Module Name: component_declarations - Package
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
-- Revision 0.1 - 2021-03-30 - Mrkovic i Ramljak
-- Additional Comments: Dodane deklaracije komponenata router_interface_module, FIFO_buffer_module i buffer_decoder_module
-- Revision 0.2 - 2021-04-06 - Ramljak
-- Additional Comments: Dodana deklaracija komponente router_branch
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

package component_declarations is

    -- Deklaracija komponente router_interface_module
    component router_interface_module
        
        Generic (
            vc_num : integer;
            address_size : integer;
            payload_size : integer;
            flit_size : integer;
            buffer_size : integer
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
               
            buffer_vc_credits : in std_logic_vector(vc_num - 1 downto 0);
            
            arb_vc_busy : out std_logic_vector(vc_num - 1 downto 0);
            arb_credit_counter : out credit_counter_vector(vc_num - 1 downto 0)
        );
        
    end component;

    -- Deklaracija komponente FIFO_buffer_module
    component FIFO_buffer_module
    
        Generic (
            flit_size : integer;
            buffer_size : integer
        );
                      
        Port (
            clk : in std_logic;
            rst : in std_logic; 
                       
            data_in : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid : in std_logic;
                    
            right_shift : in std_logic;
                    
            data_out : out std_logic_vector(flit_size - 1 downto 0);
            data_next : out std_logic_vector(flit_size - 1 downto 0);
                
            empty : out std_logic; 
            almost_empty : out std_logic                          
        );
            
    end component;

    -- Deklaracija komponente buffer_decoder_module
    component buffer_decoder_module
    
        Generic (
            vc_num : integer;
            mesh_size_x : integer;
            mesh_size_y : integer;
            address_size : integer;
            payload_size : integer;
            flit_size : integer;
            buffer_size : integer;
            local_address_x : std_logic_vector(const_mesh_size_x - 1 downto 0);
            local_address_y : std_logic_vector(const_mesh_size_y - 1 downto 0);
            clock_divider : integer;
            diagonal_pref : routing_axis
        );
        
        Port (
            clk : in std_logic;
            rst : in std_logic; 
               
            int_data_in : in std_logic_vector(flit_size - 1 downto 0);
            int_data_in_valid : in std_logic_vector(vc_num - 1 downto 0);
            
            buffer_vc_credits : out std_logic_vector(vc_num - 1 downto 0);
            
            req : out destination_dir_vector(vc_num - 1 downto 0);
            head : out std_logic_vector (vc_num - 1 downto 0 );
            tail : out std_logic_vector (vc_num - 1 downto 0 );
            
            grant : in std_logic_vector (vc_num - 1 downto 0);
            vc_downstream : in std_logic_vector (vc_num - 1 downto 0);
            
            crossbar_data : out std_logic_vector (flit_size - 1 downto 0);
            crossbar_data_valid : out std_logic        
        );
        
    end component;
    
    -- Deklaracija komponente router_branch
    component router_branch
        
        Generic (
            vc_num : integer;
            mesh_size_x : integer;
            mesh_size_y : integer;
            address_size : integer;
            payload_size : integer;
            flit_size : integer;
            buffer_size : integer;
            local_address_x : std_logic_vector(const_mesh_size_x - 1 downto 0);
            local_address_y : std_logic_vector(const_mesh_size_y - 1 downto 0);
            clock_divider : integer;
            diagonal_pref : routing_axis
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
            
            arb_vc_busy : out std_logic_vector(vc_num - 1 downto 0);
            arb_credit_counter : out credit_counter_vector(vc_num - 1 downto 0);
                    
            req : out destination_dir_vector(vc_num - 1 downto 0);
            head : out std_logic_vector (vc_num - 1 downto 0 );
            tail : out std_logic_vector (vc_num - 1 downto 0 );
            
            grant : in std_logic_vector (vc_num - 1 downto 0);
            vc_downstream : in std_logic_vector (vc_num - 1 downto 0);
            
            crossbar_data : out std_logic_vector (flit_size - 1 downto 0);
            crossbar_data_valid : out std_logic;       
            
            int_data_out : in std_logic_vector (flit_size - 1 downto 0);
            int_data_out_valid : in std_logic 
        );
        
    end component;
    
    -- Deklaracija komponente crossbar_mux_module
    component crossbar_mux_module
    
        Generic (
            flit_size : integer
        );
        
        Port (
            select_vector : in std_logic_vector(4 downto 0);
        
            data_local : in std_logic_vector(flit_size - 1 downto 0);
            data_north : in std_logic_vector(flit_size - 1 downto 0);
            data_east  : in std_logic_vector(flit_size - 1 downto 0);
            data_south : in std_logic_vector(flit_size - 1 downto 0);
            data_west  : in std_logic_vector(flit_size - 1 downto 0);
            
            data_valid_local : in std_logic;
            data_valid_north : in std_logic;
            data_valid_east  : in std_logic;
            data_valid_south : in std_logic;
            data_valid_west  : in std_logic;
            
            data_out : out std_logic_vector(flit_size - 1 downto 0);
            
            data_valid_out : out std_logic
        );
    
    end component;

end package component_declarations;