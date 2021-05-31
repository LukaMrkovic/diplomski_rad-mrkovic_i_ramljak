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
    
    -- Deklaracija komponente noc_router
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
    
    -- Deklaracija komponente AXI_to_noc_FIFO_buffer
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
    
    -- Deklaracija komponente noc_to_AXI_FIFO_buffer
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
    
    -- Deklaracija komponente noc_injector
    component noc_injector
    
        Generic (
            vc_num : integer;
            flit_size : integer;
            buffer_size : integer;
            clock_divider : integer
        );
        
        Port (
            clk : in std_logic;
            rst : in std_logic; 
                       
            flit_out : in std_logic_vector(flit_size - 1 downto 0);
            empty : in std_logic;
                    
            right_shift : out std_logic;
            
            AXI_noc_data : out std_logic_vector(flit_size - 1 downto 0);        
            AXI_noc_data_valid : out std_logic;
            
            noc_AXI_vc_busy : in std_logic_vector(vc_num - 1 downto 0);
            noc_AXI_vc_credits : in std_logic_vector(vc_num - 1 downto 0)
        );
    
    end component;
    
    -- Deklaracija komponente noc_receiver
    component noc_receiver
    
        Generic (
            vc_num : integer;
            flit_size : integer;
            clock_divider : integer
        );
        
        Port (
            clk : in std_logic;
            rst : in std_logic; 
            
            noc_AXI_data : in std_logic_vector(flit_size - 1 downto 0);        
            noc_AXI_data_valid : in std_logic;
            
            AXI_noc_vc_busy : out std_logic_vector(vc_num - 1 downto 0);
            AXI_noc_vc_credits : out std_logic_vector(vc_num - 1 downto 0);
            
            flit_in : out std_logic_vector(flit_size - 1 downto 0);
            flit_in_valid : out std_logic;
            
            vc_credits : in std_logic_vector(vc_num - 1 downto 0)
        );
    
    end component;
    
    -- Deklaracija komponente MNA_req_AXI_handshake_controller
    component MNA_req_AXI_handshake_controller
    
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
    
    end component;
    
    -- Deklaracija komponente MNA_resp_AXI_handshake_controller
    component MNA_resp_AXI_handshake_controller
    
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
    
    end component;
    
    -- Deklaracija komponente MNA_req_buffer_controller
    component MNA_req_buffer_controller
    
        Generic (
            vc_num : integer;
            mesh_size_x : integer;
            mesh_size_y : integer;
            address_size : integer;
            payload_size : integer;
            flit_size : integer;
            local_address_x : std_logic_vector(const_mesh_size_x - 1 downto 0);
            local_address_y : std_logic_vector(const_mesh_size_y - 1 downto 0);
            
            injection_vc : integer;
            node_address_size : integer
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
    
    end component;
    
    -- Deklaracija komponente MNA_resp_buffer_controller
    component MNA_resp_buffer_controller
    
        Generic (
            vc_num : integer;
            flit_size : integer
        );
                      
        Port (
            clk : in std_logic;
            rst : in std_logic;
            
            -- MNA_resp_AXI_handshake_controller
            op_write : out std_logic;
            op_read : out std_logic;
            
            data : out std_logic_vector(31 downto 0);
            resp : out std_logic_vector(1 downto 0);
            
            -- noc_to_AXI_FIFO_buffer
            flit_out : in std_logic_vector(flit_size - 1 downto 0);
            has_tail : in std_logic;
            
            right_shift : out std_logic;
            
            -- noc_receiver
            vc_credits : out std_logic_vector(vc_num - 1 downto 0)
        );
        
    end component;
    
    -- Deklaracija komponente MNA_req_flow
    component MNA_req_flow
    
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
            
            write_threshold : integer;
            read_threshold : integer;
            injection_vc : integer;
            node_address_size : integer
        );
        
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
            
            -- NOC INTERFACE - FLIT AXI -> NOC
            AXI_noc_data : out std_logic_vector(flit_size - 1 downto 0);
            AXI_noc_data_valid : out std_logic;
                    
            noc_AXI_vc_busy : in std_logic_vector(vc_num - 1 downto 0);
            noc_AXI_vc_credits : in std_logic_vector(vc_num - 1 downto 0)
        );
    
    end component;
    
    -- Deklaracija komponente MNA_resp_flow
    component MNA_resp_flow
    
        Generic (
            vc_num : integer;
            flit_size : integer;
            buffer_size : integer;
            clock_divider : integer
        );
        
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
            
            -- NOC INTERFACE - FLIT AXI <- NOC
            noc_AXI_data : in std_logic_vector(flit_size - 1 downto 0);        
            noc_AXI_data_valid : in std_logic;
            
            AXI_noc_vc_busy : out std_logic_vector(vc_num - 1 downto 0);
            AXI_noc_vc_credits : out std_logic_vector(vc_num - 1 downto 0)
        );
    
    end component;
    
    -- Deklaracija komponente AXI_master_network_adapter
    component AXI_master_network_adapter
    
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
            
            write_threshold : integer;
            read_threshold : integer;
            injection_vc : integer;
            node_address_size : integer
        );
        
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
            
            -- AXI WRITE RESPONSE CHANNEL   
            BRESP : out std_logic_vector(1 downto 0);
            BVALID : out std_logic;
            BREADY : in std_logic;
            
            -- AXI READ RESPONSE CHANNEL
            RDATA : out std_logic_vector(31 downto 0);
            RRESP : out std_logic_vector(1 downto 0);
            RVALID : out std_logic;
            RREADY : in std_logic;
            
            -- NOC INTERFACE - FLIT AXI -> NOC
            AXI_noc_data : out std_logic_vector(flit_size - 1 downto 0);
            AXI_noc_data_valid : out std_logic;
                    
            noc_AXI_vc_busy : in std_logic_vector(vc_num - 1 downto 0);
            noc_AXI_vc_credits : in std_logic_vector(vc_num - 1 downto 0);
            
            -- NOC INTERFACE - FLIT AXI <- NOC
            noc_AXI_data : in std_logic_vector(flit_size - 1 downto 0);        
            noc_AXI_data_valid : in std_logic;
            
            AXI_noc_vc_busy : out std_logic_vector(vc_num - 1 downto 0);
            AXI_noc_vc_credits : out std_logic_vector(vc_num - 1 downto 0)
        );
    
    end component;
    
    -- Deklaracija komponente SNA_req_AXI_handshake_controller
    component SNA_req_AXI_handshake_controller
    
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
    
    end component;
    
    -- Deklaracija komponente SNA_resp_AXI_handshake_controller
    component SNA_resp_AXI_handshake_controller
    
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
    
    end component;
    
    -- Deklaracija komponente SNA_req_buffer_controller
    component SNA_req_buffer_controller
    
        Generic (
            vc_num : integer;
            address_size : integer;
            payload_size : integer;
            flit_size : integer
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
    
    end component;
    
    -- Deklaracija komponente SNA_resp_buffer_controller
    component SNA_resp_buffer_controller
    
        Generic (
            vc_num : integer;
            address_size : integer;
            flit_size : integer
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
    
    end component;
    
    -- Deklaracija komponente SNA_req_flow
    component SNA_req_flow
    
        Generic (
            vc_num : integer := const_vc_num;
            address_size : integer := const_address_size;
            payload_size : integer := const_payload_size;
            flit_size : integer := const_flit_size;
            buffer_size : integer := const_buffer_size;
            clock_divider : integer := const_clock_divider
        );
        
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
            
            -- NOC INTERFACE - FLIT AXI <- NOC
            noc_AXI_data : in std_logic_vector(flit_size - 1 downto 0);        
            noc_AXI_data_valid : in std_logic;
            
            AXI_noc_vc_busy : out std_logic_vector(vc_num - 1 downto 0);
            AXI_noc_vc_credits : out std_logic_vector(vc_num - 1 downto 0);
            
            -- resp_flow (SNA_resp_AXI_handshake_controller)
            resp_write : out std_logic;
            resp_read : out std_logic;
            
            -- resp_flow (SNA_resp_buffer_controller)
            r_addr : out std_logic_vector(address_size - 1 downto 0);
            r_vc : out std_logic_vector(vc_num - 1 downto 0);
            
            -- resp_flow (AXI_to_noc_FIFO_buffer)
            buffer_write_ready : in std_logic;
            buffer_read_ready : in std_logic;
            
            -- t_monitor
            SNA_ready : in std_logic;
            t_begun : out std_logic
        );
        
    end component;

    -- Deklaracija komponente SNA_resp_flow
    component SNA_resp_flow 
    
        Generic (
            vc_num : integer := const_vc_num;
            address_size : integer := const_address_size;
            flit_size : integer := const_flit_size;
            buffer_size : integer := const_buffer_size;
            clock_divider : integer := const_clock_divider;
            
            write_threshold : integer := const_SNA_write_threshold;
            read_threshold : integer := const_SNA_read_threshold
        );
        
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
            
            -- NOC INTERFACE - FLIT AXI -> NOC
            AXI_noc_data : out std_logic_vector(flit_size - 1 downto 0);        
            AXI_noc_data_valid : out std_logic;
            
            noc_AXI_vc_busy : in std_logic_vector(vc_num - 1 downto 0);
            noc_AXI_vc_credits : in std_logic_vector(vc_num - 1 downto 0);
            
            -- req_flow (SNA_req_AXI_handshake_controller)
            buffer_write_ready : out std_logic;
            buffer_read_ready : out std_logic;
            
            -- req_flow (SNA_req_buffer_controller)
            resp_write : in std_logic;
            resp_read : in std_logic;
            
            r_addr : in std_logic_vector(address_size - 1 downto 0);
            r_vc : in std_logic_vector(vc_num - 1 downto 0);
            
            -- t_monitor
            t_end : out std_logic
        );
    
    end component;
    
    -- Deklaracija komponente AXI_slave_network_adapter
    component AXI_slave_network_adapter
    
        Generic (
            vc_num : integer;
            address_size : integer;
            payload_size : integer;
            flit_size : integer;
            buffer_size : integer;
            clock_divider : integer;
            
            write_threshold : integer;
            read_threshold : integer
        );
    
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
            
            -- AXI WRITE RESPONSE CHANNEL
            BRESP : in std_logic_vector(1 downto 0);
            BVALID : in std_logic;
            BREADY : out std_logic;
            
            -- AXI READ RESPONSE CHANNEL
            RDATA : in std_logic_vector(31 downto 0);
            RRESP : in std_logic_vector(1 downto 0);
            RVALID : in std_logic;
            RREADY : out std_logic;
            
            -- NOC INTERFACE - FLIT AXI -> NOC
            AXI_noc_data : out std_logic_vector(flit_size - 1 downto 0);        
            AXI_noc_data_valid : out std_logic;
            
            noc_AXI_vc_busy : in std_logic_vector(vc_num - 1 downto 0);
            noc_AXI_vc_credits : in std_logic_vector(vc_num - 1 downto 0);
            
            -- NOC INTERFACE - FLIT AXI <- NOC
            noc_AXI_data : in std_logic_vector(flit_size - 1 downto 0);        
            noc_AXI_data_valid : in std_logic;
            
            AXI_noc_vc_busy : out std_logic_vector(vc_num - 1 downto 0);
            AXI_noc_vc_credits : out std_logic_vector(vc_num - 1 downto 0)
        );
    
    end component;
    
    -- Deklaracija komponente noc_mesh_2x2
    component noc_mesh_2x2
    
        Generic (
            vc_num : integer := const_vc_num;
            mesh_size_x : integer := const_mesh_size_x;
            mesh_size_y : integer := const_mesh_size_y;
            address_size : integer := const_address_size;
            payload_size : integer := const_payload_size;
            flit_size : integer := const_flit_size;
            buffer_size : integer := const_buffer_size;
            clock_divider : integer := const_clock_divider
        );
        
        Port (
            clk : in std_logic;
            rst : in std_logic;
            
            -- MESH INJECTION INTERFACES
            
            -- ROUTER A (11)
            data_in_A : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_A : in std_logic;
            data_in_vc_busy_A : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_A : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_A : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_A : out std_logic;
            data_out_vc_busy_A : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_A : in std_logic_vector(vc_num - 1 downto 0);
            
            -- ROUTER B (21)
            data_in_B : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_B : in std_logic;
            data_in_vc_busy_B : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_B : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_B : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_B : out std_logic;
            data_out_vc_busy_B : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_B : in std_logic_vector(vc_num - 1 downto 0);
            
            -- ROUTER C (12)
            data_in_C : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_C : in std_logic;
            data_in_vc_busy_C : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_C : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_C : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_C : out std_logic;
            data_out_vc_busy_C : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_C : in std_logic_vector(vc_num - 1 downto 0);
            
            -- ROUTER D (22)
            data_in_D : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_D : in std_logic;
            data_in_vc_busy_D : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_D : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_D : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_D : out std_logic;
            data_out_vc_busy_D : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_D : in std_logic_vector(vc_num - 1 downto 0)
        );
    
    end component;
    
    -- Deklaracija komponente demo_1
    component demo_1
    
        Generic (
            vc_num : integer := 2;
            mesh_size_x : integer := 4;
            mesh_size_y : integer := 4;
            address_size : integer := 8;
            payload_size : integer := 32;
            flit_size : integer := 44;
            buffer_size : integer := 8;
            clock_divider : integer := 2;
            
            MNA_write_threshold : integer := 3;
            MNA_read_threshold : integer := 2;
            SNA_write_threshold : integer := 1;
            SNA_read_threshold : integer := 2;
            node_address_size : integer := 4
        );
        
        Port (
            clk : in std_logic;
            rst : in std_logic;
            
            -- > MNA_0
                -- AXI WRITE ADDRESS CHANNEL           
                MNA_0_AWADDR : in std_logic_vector(31 downto 0);
                MNA_0_AWPROT : in std_logic_vector(2 downto 0);
                MNA_0_AWVALID : in std_logic;
                MNA_0_AWREADY : out std_logic;
                
                -- AXI WRITE DATA CHANNEL
                MNA_0_WDATA : in std_logic_vector(31 downto 0);
                MNA_0_WSTRB : in std_logic_vector(3 downto 0);
                MNA_0_WVALID : in std_logic;
                MNA_0_WREADY : out std_logic;
                
                -- AXI READ ADDRESS CHANNEL
                MNA_0_ARADDR : in std_logic_vector(31 downto 0);
                MNA_0_ARPROT : in std_logic_vector(2 downto 0);
                MNA_0_ARVALID : in std_logic;
                MNA_0_ARREADY : out std_logic;
                
                -- AXI WRITE RESPONSE CHANNEL   
                MNA_0_BRESP : out std_logic_vector(1 downto 0);
                MNA_0_BVALID : out std_logic;
                MNA_0_BREADY : in std_logic;
                
                -- AXI READ RESPONSE CHANNEL
                MNA_0_RDATA : out std_logic_vector(31 downto 0);
                MNA_0_RRESP : out std_logic_vector(1 downto 0);
                MNA_0_RVALID : out std_logic;
                MNA_0_RREADY : in std_logic;
            -- < MNA_0
            
            -- > MNA_1
                -- AXI WRITE ADDRESS CHANNEL           
                MNA_1_AWADDR : in std_logic_vector(31 downto 0);
                MNA_1_AWPROT : in std_logic_vector(2 downto 0);
                MNA_1_AWVALID : in std_logic;
                MNA_1_AWREADY : out std_logic;
                
                -- AXI WRITE DATA CHANNEL
                MNA_1_WDATA : in std_logic_vector(31 downto 0);
                MNA_1_WSTRB : in std_logic_vector(3 downto 0);
                MNA_1_WVALID : in std_logic;
                MNA_1_WREADY : out std_logic;
                
                -- AXI READ ADDRESS CHANNEL
                MNA_1_ARADDR : in std_logic_vector(31 downto 0);
                MNA_1_ARPROT : in std_logic_vector(2 downto 0);
                MNA_1_ARVALID : in std_logic;
                MNA_1_ARREADY : out std_logic;
                
                -- AXI WRITE RESPONSE CHANNEL   
                MNA_1_BRESP : out std_logic_vector(1 downto 0);
                MNA_1_BVALID : out std_logic;
                MNA_1_BREADY : in std_logic;
                
                -- AXI READ RESPONSE CHANNEL
                MNA_1_RDATA : out std_logic_vector(31 downto 0);
                MNA_1_RRESP : out std_logic_vector(1 downto 0);
                MNA_1_RVALID : out std_logic;
                MNA_1_RREADY : in std_logic;
            -- < MNA_1
            
            -- > SNA_0
                -- AXI WRITE ADDRESS CHANNEL 
                SNA_0_AWADDR : out std_logic_vector(31 downto 0);
                SNA_0_AWPROT : out std_logic_vector(2 downto 0);
                SNA_0_AWVALID : out std_logic;
                SNA_0_AWREADY : in std_logic;
                
                -- AXI WRITE DATA CHANNEL
                SNA_0_WDATA : out std_logic_vector(31 downto 0);
                SNA_0_WSTRB : out std_logic_vector(3 downto 0);
                SNA_0_WVALID : out std_logic;
                SNA_0_WREADY : in std_logic;
                
                -- AXI READ ADDRESS CHANNEL
                SNA_0_ARADDR : out std_logic_vector(31 downto 0);
                SNA_0_ARPROT : out std_logic_vector(2 downto 0);
                SNA_0_ARVALID : out std_logic;
                SNA_0_ARREADY : in std_logic;
                
                -- AXI WRITE RESPONSE CHANNEL
                SNA_0_BRESP : in std_logic_vector(1 downto 0);
                SNA_0_BVALID : in std_logic;
                SNA_0_BREADY : out std_logic;
                
                -- AXI READ RESPONSE CHANNEL
                SNA_0_RDATA : in std_logic_vector(31 downto 0);
                SNA_0_RRESP : in std_logic_vector(1 downto 0);
                SNA_0_RVALID : in std_logic;
                SNA_0_RREADY : out std_logic;
            -- < SNA_0
            
            -- > SNA_1
                -- AXI WRITE ADDRESS CHANNEL 
                SNA_1_AWADDR : out std_logic_vector(31 downto 0);
                SNA_1_AWPROT : out std_logic_vector(2 downto 0);
                SNA_1_AWVALID : out std_logic;
                SNA_1_AWREADY : in std_logic;
                
                -- AXI WRITE DATA CHANNEL
                SNA_1_WDATA : out std_logic_vector(31 downto 0);
                SNA_1_WSTRB : out std_logic_vector(3 downto 0);
                SNA_1_WVALID : out std_logic;
                SNA_1_WREADY : in std_logic;
                
                -- AXI READ ADDRESS CHANNEL
                SNA_1_ARADDR : out std_logic_vector(31 downto 0);
                SNA_1_ARPROT : out std_logic_vector(2 downto 0);
                SNA_1_ARVALID : out std_logic;
                SNA_1_ARREADY : in std_logic;
                
                -- AXI WRITE RESPONSE CHANNEL
                SNA_1_BRESP : in std_logic_vector(1 downto 0);
                SNA_1_BVALID : in std_logic;
                SNA_1_BREADY : out std_logic;
                
                -- AXI READ RESPONSE CHANNEL
                SNA_1_RDATA : in std_logic_vector(31 downto 0);
                SNA_1_RRESP : in std_logic_vector(1 downto 0);
                SNA_1_RVALID : in std_logic;
                SNA_1_RREADY : out std_logic
            -- < SNA_1
        );
    
    end component;
    
    component noc_mesh_4x4 
    
        Generic (
            vc_num : integer := const_vc_num;
            mesh_size_x : integer := const_mesh_size_x;
            mesh_size_y : integer := const_mesh_size_y;
            address_size : integer := const_address_size;
            payload_size : integer := const_payload_size;
            flit_size : integer := const_flit_size;
            buffer_size : integer := const_buffer_size;
            clock_divider : integer := const_clock_divider
        );
        
        Port (
            clk : in std_logic;
            rst : in std_logic;
            
            -- MESH INJECTION INTERFACES
            
            -- ROUTER A (11)
            data_in_A : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_A : in std_logic;
            data_in_vc_busy_A : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_A : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_A : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_A : out std_logic;
            data_out_vc_busy_A : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_A : in std_logic_vector(vc_num - 1 downto 0);
            
            -- ROUTER B (21)
            data_in_B : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_B : in std_logic;
            data_in_vc_busy_B : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_B : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_B : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_B : out std_logic;
            data_out_vc_busy_B : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_B : in std_logic_vector(vc_num - 1 downto 0);
            
            -- ROUTER C (41)
            data_in_C : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_C : in std_logic;
            data_in_vc_busy_C : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_C : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_C : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_C : out std_logic;
            data_out_vc_busy_C : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_C : in std_logic_vector(vc_num - 1 downto 0);
            
            -- ROUTER D (81)
            data_in_D : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_D : in std_logic;
            data_in_vc_busy_D : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_D : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_D : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_D : out std_logic;
            data_out_vc_busy_D : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_D : in std_logic_vector(vc_num - 1 downto 0);
        
            -- ROUTER E (12)
            data_in_E : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_E : in std_logic;
            data_in_vc_busy_E : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_E : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_E : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_E : out std_logic;
            data_out_vc_busy_E : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_E : in std_logic_vector(vc_num - 1 downto 0);
            
            -- ROUTER F (22)
            data_in_F : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_F : in std_logic;
            data_in_vc_busy_F : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_F : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_F : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_F : out std_logic;
            data_out_vc_busy_F : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_F : in std_logic_vector(vc_num - 1 downto 0);
            
            -- ROUTER G (42)
            data_in_G : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_G : in std_logic;
            data_in_vc_busy_G : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_G : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_G : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_G : out std_logic;
            data_out_vc_busy_G : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_G : in std_logic_vector(vc_num - 1 downto 0);
            
            -- ROUTER H (82)
            data_in_H : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_H : in std_logic;
            data_in_vc_busy_H : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_H : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_H : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_H : out std_logic;
            data_out_vc_busy_H : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_H : in std_logic_vector(vc_num - 1 downto 0);
            
            -- ROUTER I (14)
            data_in_I : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_I : in std_logic;
            data_in_vc_busy_I : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_I : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_I : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_I : out std_logic;
            data_out_vc_busy_I : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_I : in std_logic_vector(vc_num - 1 downto 0);
            
            -- ROUTER J (24)
            data_in_J : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_J : in std_logic;
            data_in_vc_busy_J : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_J : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_J : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_J : out std_logic;
            data_out_vc_busy_J : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_J : in std_logic_vector(vc_num - 1 downto 0);
            
            -- ROUTER K (44)
            data_in_K : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_K : in std_logic;
            data_in_vc_busy_K : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_K : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_K : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_K : out std_logic;
            data_out_vc_busy_K : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_K : in std_logic_vector(vc_num - 1 downto 0);
            
            -- ROUTER L (84)
            data_in_L : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_L : in std_logic;
            data_in_vc_busy_L : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_L : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_L : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_L : out std_logic;
            data_out_vc_busy_L : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_L : in std_logic_vector(vc_num - 1 downto 0);
            
            -- ROUTER M (18)
            data_in_M : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_M : in std_logic;
            data_in_vc_busy_M : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_M : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_M : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_M : out std_logic;
            data_out_vc_busy_M : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_M : in std_logic_vector(vc_num - 1 downto 0);
            
            -- ROUTER N (28)
            data_in_N : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_N : in std_logic;
            data_in_vc_busy_N : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_N : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_N : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_N : out std_logic;
            data_out_vc_busy_N : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_N : in std_logic_vector(vc_num - 1 downto 0);
            
            -- ROUTER O (48)
            data_in_O : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_O : in std_logic;
            data_in_vc_busy_O : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_O : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_O : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_O : out std_logic;
            data_out_vc_busy_O : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_O : in std_logic_vector(vc_num - 1 downto 0);
            
            -- ROUTER P (88)
            data_in_P : in std_logic_vector(flit_size - 1 downto 0);
            data_in_valid_P : in std_logic;
            data_in_vc_busy_P : out std_logic_vector(vc_num - 1 downto 0);
            data_in_vc_credits_P : out std_logic_vector(vc_num - 1 downto 0);
            
            data_out_P : out std_logic_vector(flit_size - 1 downto 0);
            data_out_valid_P : out std_logic;
            data_out_vc_busy_P : in std_logic_vector(vc_num - 1 downto 0);
            data_out_vc_credits_P : in std_logic_vector(vc_num - 1 downto 0)
        );
    end component;
    
    component demo_4x4 
    
        Generic (
            vc_num : integer := 2;
            mesh_size_x : integer := 4;
            mesh_size_y : integer := 4;
            address_size : integer := 8;
            payload_size : integer := 32;
            flit_size : integer := 44;
            buffer_size : integer := 8;
            clock_divider : integer := 2;
            
            MNA_write_threshold : integer := 3;
            MNA_read_threshold : integer := 2;
            SNA_write_threshold : integer := 1;
            SNA_read_threshold : integer := 2;
            node_address_size : integer := 4
        );
        
        Port (
            clk : in std_logic;
            rst : in std_logic;
            
            -- > MNA_0
                -- AXI WRITE ADDRESS CHANNEL           
                MNA_0_AWADDR : in std_logic_vector(31 downto 0);
                MNA_0_AWPROT : in std_logic_vector(2 downto 0);
                MNA_0_AWVALID : in std_logic;
                MNA_0_AWREADY : out std_logic;
                
                -- AXI WRITE DATA CHANNEL
                MNA_0_WDATA : in std_logic_vector(31 downto 0);
                MNA_0_WSTRB : in std_logic_vector(3 downto 0);
                MNA_0_WVALID : in std_logic;
                MNA_0_WREADY : out std_logic;
                
                -- AXI READ ADDRESS CHANNEL
                MNA_0_ARADDR : in std_logic_vector(31 downto 0);
                MNA_0_ARPROT : in std_logic_vector(2 downto 0);
                MNA_0_ARVALID : in std_logic;
                MNA_0_ARREADY : out std_logic;
                
                -- AXI WRITE RESPONSE CHANNEL   
                MNA_0_BRESP : out std_logic_vector(1 downto 0);
                MNA_0_BVALID : out std_logic;
                MNA_0_BREADY : in std_logic;
                
                -- AXI READ RESPONSE CHANNEL
                MNA_0_RDATA : out std_logic_vector(31 downto 0);
                MNA_0_RRESP : out std_logic_vector(1 downto 0);
                MNA_0_RVALID : out std_logic;
                MNA_0_RREADY : in std_logic;
            -- < MNA_0
            
            -- > MNA_1
                -- AXI WRITE ADDRESS CHANNEL           
                MNA_1_AWADDR : in std_logic_vector(31 downto 0);
                MNA_1_AWPROT : in std_logic_vector(2 downto 0);
                MNA_1_AWVALID : in std_logic;
                MNA_1_AWREADY : out std_logic;
                
                -- AXI WRITE DATA CHANNEL
                MNA_1_WDATA : in std_logic_vector(31 downto 0);
                MNA_1_WSTRB : in std_logic_vector(3 downto 0);
                MNA_1_WVALID : in std_logic;
                MNA_1_WREADY : out std_logic;
                
                -- AXI READ ADDRESS CHANNEL
                MNA_1_ARADDR : in std_logic_vector(31 downto 0);
                MNA_1_ARPROT : in std_logic_vector(2 downto 0);
                MNA_1_ARVALID : in std_logic;
                MNA_1_ARREADY : out std_logic;
                
                -- AXI WRITE RESPONSE CHANNEL   
                MNA_1_BRESP : out std_logic_vector(1 downto 0);
                MNA_1_BVALID : out std_logic;
                MNA_1_BREADY : in std_logic;
                
                -- AXI READ RESPONSE CHANNEL
                MNA_1_RDATA : out std_logic_vector(31 downto 0);
                MNA_1_RRESP : out std_logic_vector(1 downto 0);
                MNA_1_RVALID : out std_logic;
                MNA_1_RREADY : in std_logic;
            -- < MNA_1
            
            -- > SNA_0
                -- AXI WRITE ADDRESS CHANNEL 
                SNA_0_AWADDR : out std_logic_vector(31 downto 0);
                SNA_0_AWPROT : out std_logic_vector(2 downto 0);
                SNA_0_AWVALID : out std_logic;
                SNA_0_AWREADY : in std_logic;
                
                -- AXI WRITE DATA CHANNEL
                SNA_0_WDATA : out std_logic_vector(31 downto 0);
                SNA_0_WSTRB : out std_logic_vector(3 downto 0);
                SNA_0_WVALID : out std_logic;
                SNA_0_WREADY : in std_logic;
                
                -- AXI READ ADDRESS CHANNEL
                SNA_0_ARADDR : out std_logic_vector(31 downto 0);
                SNA_0_ARPROT : out std_logic_vector(2 downto 0);
                SNA_0_ARVALID : out std_logic;
                SNA_0_ARREADY : in std_logic;
                
                -- AXI WRITE RESPONSE CHANNEL
                SNA_0_BRESP : in std_logic_vector(1 downto 0);
                SNA_0_BVALID : in std_logic;
                SNA_0_BREADY : out std_logic;
                
                -- AXI READ RESPONSE CHANNEL
                SNA_0_RDATA : in std_logic_vector(31 downto 0);
                SNA_0_RRESP : in std_logic_vector(1 downto 0);
                SNA_0_RVALID : in std_logic;
                SNA_0_RREADY : out std_logic;
            -- < SNA_0
            
            -- > SNA_1
                -- AXI WRITE ADDRESS CHANNEL 
                SNA_1_AWADDR : out std_logic_vector(31 downto 0);
                SNA_1_AWPROT : out std_logic_vector(2 downto 0);
                SNA_1_AWVALID : out std_logic;
                SNA_1_AWREADY : in std_logic;
                
                -- AXI WRITE DATA CHANNEL
                SNA_1_WDATA : out std_logic_vector(31 downto 0);
                SNA_1_WSTRB : out std_logic_vector(3 downto 0);
                SNA_1_WVALID : out std_logic;
                SNA_1_WREADY : in std_logic;
                
                -- AXI READ ADDRESS CHANNEL
                SNA_1_ARADDR : out std_logic_vector(31 downto 0);
                SNA_1_ARPROT : out std_logic_vector(2 downto 0);
                SNA_1_ARVALID : out std_logic;
                SNA_1_ARREADY : in std_logic;
                
                -- AXI WRITE RESPONSE CHANNEL
                SNA_1_BRESP : in std_logic_vector(1 downto 0);
                SNA_1_BVALID : in std_logic;
                SNA_1_BREADY : out std_logic;
                
                -- AXI READ RESPONSE CHANNEL
                SNA_1_RDATA : in std_logic_vector(31 downto 0);
                SNA_1_RRESP : in std_logic_vector(1 downto 0);
                SNA_1_RVALID : in std_logic;
                SNA_1_RREADY : out std_logic
            -- < SNA_1
        );    
    end component;
    
end package component_declarations;