----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 04/06/2021 03:20:07 PM
-- Design Name: NoC Router
-- Module Name: router_branch - Behavioral
-- Project Name: NoC Router
-- Target Devices: zc706
-- Tool Versions: 2020.2
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- Revision 0.1 - 2021-04-06 - Ramljak
-- Additional Comments: Prva verzija modula koji sadrži router_interface i buffer_decoder_modul
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

library noc_lib;
use noc_lib.router_config.ALL;
use noc_lib.component_declarations.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity router_branch is

    Generic (
        vc_num : integer := const_vc_num;
        mesh_size_x : integer := const_mesh_size_x;
        mesh_size_y : integer := const_mesh_size_y;
        address_size : integer := const_address_size;
        payload_size : integer := const_payload_size;
        flit_size : integer := const_flit_size;
        buffer_size : integer := const_buffer_size;
        local_address_x : std_logic_vector(const_mesh_size_x - 1 downto 0) := const_default_address_x;
        local_address_y : std_logic_vector(const_mesh_size_y - 1 downto 0) := const_default_address_y;
        clock_divider : integer := const_clock_divider;
        diagonal_pref : routing_axis := const_default_diagonal_pref
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
    
end router_branch;

architecture Behavioral of router_branch is

    -- Interni signali
    signal int_data_in : std_logic_vector(const_flit_size - 1 downto 0);
    signal int_data_in_valid : std_logic_vector(const_vc_num - 1 downto 0);

    signal buffer_vc_credits : std_logic_vector(const_vc_num - 1 downto 0);
    
begin

    -- router_interface komponenta
    comp_router_interface_module : router_interface_module

        generic map(
            vc_num => vc_num,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size
        )

        port map(
            clk => clk,
            rst => rst,

            data_in => data_in,
            data_in_valid => data_in_valid,
            data_in_vc_busy => data_in_vc_busy,
            data_in_vc_credits => data_in_vc_credits,

            data_out => data_out,
            data_out_valid => data_out_valid,
            data_out_vc_busy => data_out_vc_busy,
            data_out_vc_credits => data_out_vc_credits,

            int_data_in => int_data_in,
            int_data_in_valid => int_data_in_valid,

            int_data_out => int_data_out,
            int_data_out_valid => int_data_out_valid,

            buffer_vc_credits => buffer_vc_credits,
            
            arb_vc_busy => arb_vc_busy,
            arb_credit_counter => arb_credit_counter
        );
        
    -- buffer_decoder komponenta
    comp_buffer_decoder_module: buffer_decoder_module
    
        generic map (
            vc_num => vc_num,
            mesh_size_x => mesh_size_x,
            mesh_size_y => mesh_size_y,
            address_size => address_size,
            payload_size => payload_size,
            flit_size => flit_size,
            buffer_size => buffer_size,
            local_address_x => local_address_x,
            local_address_y => local_address_y,
            clock_divider => clock_divider,
            diagonal_pref => diagonal_pref
        )
        
        port map(
            clk => clk,
            rst => rst, 
               
            int_data_in => int_data_in,
            int_data_in_valid => int_data_in_valid,
            
            buffer_vc_credits => buffer_vc_credits,
            
            req => req,
            head => head,
            tail => tail,
            
            grant => grant,
            vc_downstream => vc_downstream,
            
            crossbar_data => crossbar_data,
            crossbar_data_valid => crossbar_data_valid    
        );        

end Behavioral;