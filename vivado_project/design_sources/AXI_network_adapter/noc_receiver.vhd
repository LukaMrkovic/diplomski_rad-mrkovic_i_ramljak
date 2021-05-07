----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 05/07/2021 02:27:31 PM
-- Design Name: AXI_Network_Adapter
-- Module Name: noc_receiver - Behavioral
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
-- Revision 0.1 - 2021-05-07 - Mrkovic, Ramljak
-- Additional Comments: Prva verzija noc_receivera
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

entity noc_receiver is

    Generic (
        vc_num : integer := const_vc_num;
        flit_size : integer := const_flit_size;
        clock_divider : integer := const_clock_divider;
        
        injection_vc : integer := const_default_injection_vc
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
        
        right_shift : in std_logic
    );

end noc_receiver;

architecture Behavioral of noc_receiver is

    -- ENABLE SIGNAL SLANJA U noc MREZU
    signal enable_output : std_logic;
    
    -- TESTNI SIGNALI
    signal output_counter_test : integer;
    signal credit_to_send_test : integer;

begin

    flit_in <= noc_AXI_data;
    flit_in_valid <= noc_AXI_data_valid;

    -- RECEIVER PROCES
    receiver_process : process (clk) is
    
        variable credits_to_send : integer;
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
            
                AXI_noc_vc_credits <= (others => '0');
                AXI_noc_vc_busy <= (others => '0');
                credits_to_send := 0;
            
            else
            
                AXI_noc_vc_credits <= (others => '0');
            
                -- AKO JE POSTAVLJEN enable_output
                if enable_output = '1' then
                
                    if credits_to_send > 0 then
                    
                        AXI_noc_vc_credits(injection_vc) <= '1';
                        credits_to_send := credits_to_send - 1; 
                    
                    end if;
                
                end if;
                
                if noc_AXI_data_valid = '1' then
                
                    if noc_AXI_data(flit_size - 1) = '1' then
                    
                        AXI_noc_vc_busy(injection_vc) <= '1';
                    
                    end if;
                    
                    if noc_AXI_data(flit_size - 2) = '1' then
                    
                        AXI_noc_vc_busy(injection_vc) <= '0';
                    
                    end if;
                
                end if;
                
                if right_shift = '1' then
                
                    credits_to_send := credits_to_send + 1;
                
                end if;
                
                credit_to_send_test <= credits_to_send;
            
            end if;
        end if;
    
    end process;

    -- OUTPUT ENABLE PROCES
    output_enable_process : process (clk) is 
        
        variable output_counter : integer;
        
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
                
                -- POSTAVI BROJILO NA 0
                output_counter := (clock_divider * 2) - 1;
                
                -- POSTAVI INTERNI TAKT NA 0
                enable_output <= '0';
            
            else
            
                -- POVECAJ BROJILO ZA 1
                output_counter := (output_counter + 1) mod (clock_divider * 2);
                
                -- PROPUSTI UBRZANE IZLAZE
                if (output_counter = 3) then 
                    enable_output <= '1';
                else
                    enable_output <= '0';
                end if;
                
                output_counter_test <= output_counter;
                             
            end if;
        end if;
        
    end process;


end Behavioral;
