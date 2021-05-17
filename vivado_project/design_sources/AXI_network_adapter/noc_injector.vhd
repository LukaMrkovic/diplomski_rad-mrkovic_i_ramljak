----------------------------------------------------------------------------------
-- Company: FER
-- Engineer: Mrkovic, Ramljak
-- 
-- Create Date: 07.05.2021 12:11:00
-- Design Name: AXI_Network_Adapter
-- Module Name: noc_injector - Behavioral
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
-- Additional Comments: Prva verzija noc_injectora
-- Revision 0.2 - 2021-05-17 - Mrkovic
-- Additional Comments: Dotjerana verzija noc_injectora
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

entity noc_injector is

    Generic (
        vc_num : integer := const_vc_num;
        flit_size : integer := const_flit_size;
        buffer_size : integer := const_buffer_size;
        clock_divider : integer := const_clock_divider
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

end noc_injector;

architecture Behavioral of noc_injector is

    -- ENABLE SIGNAL SLANJA U noc MREZU
    signal enable_output : std_logic;
    
    -- > TESTNI SIGNALI
    signal output_counter_test : integer;
    signal credit_counter_test : credit_counter_vector(vc_num - 1 downto 0);
    signal vc_test : integer;
    -- < TESTNI SIGNALI

begin

    -- INJECTOR PROCES
    injector_process : process (clk) is
    
        variable AXI_noc_data_var : std_logic_vector(flit_size - 1 downto 0);
        variable AXI_noc_data_valid_var : std_logic;
        
        variable right_shift_var : std_logic;
    
        variable credit_counter : credit_counter_vector(vc_num - 1 downto 0);
        variable vc : integer;
    
    begin
    
        if rising_edge(clk) then
            if rst = '0' then
            
                AXI_noc_data_var := (others => '0');
                AXI_noc_data_valid_var := '0';

                right_shift_var := '0';
                
                credit_counter := (others => buffer_size);
                vc := 0;
                
                AXI_noc_data <= (others => '0');
                AXI_noc_data_valid <= '0';

                right_shift <= '0';
            
            else
            
                AXI_noc_data_var := (others => '0');
                AXI_noc_data_valid_var := '0';

                right_shift_var := '0';
                vc := 0;
            
                -- AKO JE POSTAVLJEN enable_output
                if enable_output = '1' then
                
                    -- AKO JE empty = 0
                    if empty = '0' then
                    
                        for i in vc_num - 1 downto 0 loop
                        
                            if flit_out(flit_size - 2 - 1 - i) = '1' then
                            
                                vc := vc_num - 1 - i;
                            
                            end if;
                        
                        end loop;
                    
                        -- AKO JE (vc_busy(vc) = 0 I flit_out(flit_size - 1) = 1)
                        --    ILI (vc_busy(vc) = 1 I flit_out(flit_size - 1) = 0)
                        if (noc_AXI_vc_busy(vc) = '0' and flit_out(flit_size - 1) = '1') or
                           (noc_AXI_vc_busy(vc) = '1' and flit_out(flit_size - 1) = '0') then
                           
                           -- AKO JE credit_counter > 0
                           if credit_counter(vc) > 0 then
                           
                                AXI_noc_data_var := flit_out;
                                AXI_noc_data_valid_var := '1';
                                
                                right_shift_var := '1';
                                
                                credit_counter(vc) := credit_counter(vc) - 1;
                           
                           end if;
                           
                        end if;
                        
                    end if;
                
                end if;
                
                for i in vc_num - 1 downto 0 loop
                
                    if noc_AXI_vc_credits(i) = '1' then
                
                        credit_counter(i) := credit_counter(i) + 1;
                    
                    end if;
                
                end loop;
                
                AXI_noc_data <= AXI_noc_data_var;
                AXI_noc_data_valid <= AXI_noc_data_valid_var;

                right_shift <= right_shift_var;
                
                credit_counter_test <= credit_counter;
                vc_test <= vc;
            
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
                
                -- POSTAVI IZLAZ NA '0'
                enable_output <= '0';
            
            else
            
                -- POVECAJ BROJILO ZA 1
                output_counter := (output_counter + 1) mod (clock_divider * 2);
                
                -- POSTAVI IZLAZ AKO JE BROJILO JEDNAKO 3
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