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
-- Revision 0.3 - 2021-05-03 - Mrkovic, Ramljak
-- Additional Comments: Dodane deklracije komponenata crossbar_mux_module, crossbar, arbiter, noc_router, AXI_to_noc_FIFO_buffer, noc_to_AXI_FIFO_buffer 
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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
    
    -- Deklaracija komponente crossbar
    component crossbar
    
        Generic (
            flit_size : integer
        );
        
        Port (
            select_vector_local : in std_logic_vector(4 downto 0);
            select_vector_north : in std_logic_vector(4 downto 0);
            select_vector_east : in std_logic_vector(4 downto 0);
            select_vector_south : in std_logic_vector(4 downto 0);
            select_vector_west : in std_logic_vector(4 downto 0);
        
            data_in_local : in std_logic_vector(flit_size - 1 downto 0);
            data_in_north : in std_logic_vector(flit_size - 1 downto 0);
            data_in_east  : in std_logic_vector(flit_size - 1 downto 0);
            data_in_south : in std_logic_vector(flit_size - 1 downto 0);
            data_in_west  : in std_logic_vector(flit_size - 1 downto 0);
            
            data_in_valid_local : in std_logic;
            data_in_valid_north : in std_logic;
            data_in_valid_east  : in std_logic;
            data_in_valid_south : in std_logic;
            data_in_valid_west  : in std_logic;
            
            data_out_local : out std_logic_vector(flit_size - 1 downto 0);
            data_out_north : out std_logic_vector(flit_size - 1 downto 0);
            data_out_east  : out std_logic_vector(flit_size - 1 downto 0);
            data_out_south : out std_logic_vector(flit_size - 1 downto 0);
            data_out_west  : out std_logic_vector(flit_size - 1 downto 0);
            
            data_out_valid_local : out std_logic;
            data_out_valid_north : out std_logic;
            data_out_valid_east  : out std_logic;
            data_out_valid_south : out std_logic;
            data_out_valid_west  : out std_logic
        );
    
    end component;
    
    -- Deklaracija komponente arbiter
    component arbiter
    
        Generic (
            vc_num : integer
        );
        
        Port (
            clk : in std_logic;
            rst : in std_logic;
            
            vc_busy_local : in std_logic_vector(vc_num - 1 downto 0);
            vc_busy_north : in std_logic_vector(vc_num - 1 downto 0);
            vc_busy_east : in std_logic_vector(vc_num - 1 downto 0);
            vc_busy_south : in std_logic_vector(vc_num - 1 downto 0);
            vc_busy_west : in std_logic_vector(vc_num - 1 downto 0);
            
            credit_counter_local : in credit_counter_vector(vc_num - 1 downto 0);
            credit_counter_north : in credit_counter_vector(vc_num - 1 downto 0);
            credit_counter_east : in credit_counter_vector(vc_num - 1 downto 0);
            credit_counter_south : in credit_counter_vector(vc_num - 1 downto 0);
            credit_counter_west : in credit_counter_vector(vc_num - 1 downto 0);
            
            req_local : in destination_dir_vector(vc_num - 1 downto 0);
            req_north : in destination_dir_vector(vc_num - 1 downto 0);
            req_east : in destination_dir_vector(vc_num - 1 downto 0);
            req_south : in destination_dir_vector(vc_num - 1 downto 0);
            req_west : in destination_dir_vector(vc_num - 1 downto 0);
            
            head_local : in std_logic_vector (vc_num - 1 downto 0 );
            head_north : in std_logic_vector (vc_num - 1 downto 0 );
            head_east : in std_logic_vector (vc_num - 1 downto 0 );
            head_south : in std_logic_vector (vc_num - 1 downto 0 );
            head_west : in std_logic_vector (vc_num - 1 downto 0 );
            
            tail_local : in std_logic_vector (vc_num - 1 downto 0 );
            tail_north : in std_logic_vector (vc_num - 1 downto 0 );
            tail_east : in std_logic_vector (vc_num - 1 downto 0 );
            tail_south : in std_logic_vector (vc_num - 1 downto 0 );
            tail_west : in std_logic_vector (vc_num - 1 downto 0 );
            
            grant_local : out std_logic_vector (vc_num - 1 downto 0);
            grant_north : out std_logic_vector (vc_num - 1 downto 0);
            grant_east : out std_logic_vector (vc_num - 1 downto 0);
            grant_south : out std_logic_vector (vc_num - 1 downto 0);
            grant_west : out std_logic_vector (vc_num - 1 downto 0);
            
            vc_downstream_local : out std_logic_vector (vc_num - 1 downto 0);
            vc_downstream_north : out std_logic_vector (vc_num - 1 downto 0);
            vc_downstream_east : out std_logic_vector (vc_num - 1 downto 0);
            vc_downstream_south : out std_logic_vector (vc_num - 1 downto 0);
            vc_downstream_west : out std_logic_vector (vc_num - 1 downto 0);
            
            select_vector_local : out std_logic_vector(4 downto 0);
            select_vector_north : out std_logic_vector(4 downto 0);
            select_vector_east : out std_logic_vector(4 downto 0);
            select_vector_south : out std_logic_vector(4 downto 0);
            select_vector_west : out std_logic_vector(4 downto 0)
        );    
    
    end component;
    
    component noc_router
        
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
            
            -- ROUTER TO ROUTER INTERFACE
            -- LOCAL
            data_in_local : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_local : in std_logic;
            data_in_vc_busy_local : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_local : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_local : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_local : out std_logic;
            data_out_vc_busy_local : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_local : in std_logic_vector(vc_num - 1 downto 0);
            
            -- ROUTER TO ROUTER INTERFACE
            -- NORTH
            data_in_north : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_north : in std_logic;
            data_in_vc_busy_north : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_north : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_north : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_north : out std_logic;
            data_out_vc_busy_north : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_north : in std_logic_vector(vc_num - 1 downto 0);
            
            -- ROUTER TO ROUTER INTERFACE
            -- EAST
            data_in_east : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_east : in std_logic;
            data_in_vc_busy_east : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_east : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_east : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_east : out std_logic;
            data_out_vc_busy_east : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_east : in std_logic_vector(vc_num - 1 downto 0);
            
            -- ROUTER TO ROUTER INTERFACE
            -- SOUTH
            data_in_south : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_south : in std_logic;
            data_in_vc_busy_south : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_south : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_south : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_south : out std_logic;
            data_out_vc_busy_south : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_south : in std_logic_vector(vc_num - 1 downto 0);
            
            -- ROUTER TO ROUTER INTERFACE
            -- WEST
            data_in_west : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_west : in std_logic;
            data_in_vc_busy_west : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_west : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_west : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_west : out std_logic;
            data_out_vc_busy_west : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_west : in std_logic_vector(vc_num - 1 downto 0)
        );
        
    end component;
    
    component AXI_to_noc_FIFO_buffer
    
        Generic (
            flit_size : integer;
            buffer_size : integer;
            write_threshold : integer;
            read_threshold : integer
        );
                      
        Port (
            clk : in std_logic;
            rst : in std_logic; 
                       
            flit_in : in std_logic_vector(flit_size - 1 downto 0);
            flit_in_valid : in std_logic;
            
            flit_out : out std_logic_vector(flit_size - 1 downto 0);
            empty : out std_logic;
                    
            right_shift : in std_logic;
            
            buffer_write_ready : out std_logic;        
            buffer_read_ready : out std_logic
        );
    
    end component;
    
    component noc_to_AXI_FIFO_buffer
    
        Generic (
            flit_size : integer;
            buffer_size : integer
        );
                      
        Port (
            clk : in std_logic;
            rst : in std_logic; 
                       
            flit_in : in std_logic_vector(flit_size - 1 downto 0);
            flit_in_valid : in std_logic;
            
            flit_out : out std_logic_vector(flit_size - 1 downto 0);
            has_tail : out std_logic;
                    
            right_shift : in std_logic;
            
            full : out std_logic
        );
    
    end component;
    
    component MNA_req_AXI_handshake_controller
    
        Port (
            clk : in std_logic;
            rst : in std_logic; 
                       
            AWADDR : in std_logic_vector(31 downto 0);
            AWVALID : in std_logic;
            AWREADY : out std_logic;
            
            WDATA : in std_logic_vector(31 downto 0);
            WVALID : in std_logic;
            WREADY : out std_logic;
            
            AWPROT : in std_logic_vector(2 downto 0);
            WSTRB : in std_logic_vector(3 downto 0);
            
            ARADDR : in std_logic_vector(31 downto 0);
            ARVALID : in std_logic;
            ARREADY : out std_logic;
            
            ARPROT : in std_logic_vector(2 downto 0);
            
            op_write : out std_logic;
            op_read : out std_logic;
            
            buffer_read_ready : in std_logic;
            buffer_write_ready : in std_logic;
            
            addr : out std_logic_vector(31 downto 0);
            data : out std_logic_vector(31 downto 0);
            prot : out std_logic_vector(2 downto 0);
            strb : out std_logic_vector(3 downto 0)
        );
    
    end component;
    
    component MNA_resp_AXI_handshake_controller
    
        Port (
            clk : in std_logic;
            rst : in std_logic; 
                       
            BREADY : in std_logic;
            BRESP : out std_logic_vector(1 downto 0);
            BVALID : out std_logic;
            
            RREADY : in std_logic;
            RDATA : out std_logic_vector(31 downto 0);
            RRESP : out std_logic_vector(1 downto 0);
            RVALID : out std_logic;
            
            op_write : in std_logic;
            op_read : in std_logic;
            
            data : in std_logic_vector(31 downto 0);
            resp : in std_logic_vector(1 downto 0)
        );
    
    end component;
    
    component MNA_req_buffer_controller
    
        Generic (
            vc_num : integer;
            mesh_size_x : integer;
            mesh_size_y : integer;
            address_size : integer;
            payload_size : integer;
            flit_size : integer;
            node_address_size : integer;
            injection_vc : integer;
            local_address_x : std_logic_vector(const_mesh_size_x - 1 downto 0);
            local_address_y : std_logic_vector(const_mesh_size_y - 1 downto 0)
        );
                      
        Port (
            clk : in std_logic;
            rst : in std_logic; 
                       
            flit_in : out std_logic_vector(flit_size - 1 downto 0);
            flit_in_valid : out std_logic;
            
            op_write : in std_logic;
            op_read : in std_logic;
            
            addr : in std_logic_vector(31 downto 0);
            data : in std_logic_vector(31 downto 0);
            prot : in std_logic_vector(2 downto 0);
            strb : in std_logic_vector(3 downto 0)
        );
    
    end component;
    
    component MNA_resp_buffer_controller
    
        Generic (
            flit_size : integer
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
        
    end component;
    
end package component_declarations;