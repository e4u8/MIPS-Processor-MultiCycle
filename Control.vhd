library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control is
    Port ( Instruction : in  STD_LOGIC_VECTOR (31 downto 0);
        Clk_c : IN  std_logic;
        Reset_c : IN  std_logic;
        PC_LdEn_c : OUT  std_logic;
        RF_WrData_sel_c : OUT  std_logic;
        RF_B_sel_c : OUT  std_logic;
        Immed_Ext_c : OUT  std_logic_vector(1 downto 0);
        ALU_Bin_sel_c : OUT  std_logic;
        MEM_WrEn_c : OUT  std_logic;
        WE_RF_c : OUT  std_logic;
        Rom_registerWE_c : OUT  std_logic;
        RF_A_registerWE_c : OUT  std_logic;
        RF_B_registerWE_c : OUT  std_logic;			
        Immed_registerWE_c : OUT STD_LOGIC;
        ALU_registerWE_c : OUT  std_logic;
        Ram_registerWE_c : OUT  std_logic
           );
end Control;

architecture Behavioral of Control is
    type state is (Reset_state, exec_R_type_state, exec_li_addi_state, exec_lui_state, exec_ori_andi_state, exec_branch_state, exec_load_state, exec_store_state, first_intr_state, if_Reg_state, decode_state,
     wb_R_type_state, wb_exec_li_addi_state, wb_exec_lui_state, wb_exec_ori_andi_state, mem_load_state, mem_store_state, wb_load_state);
    signal Control_state: state;

begin
    control_FSM: PROCESS
    BEGIN

    WAIT UNTIL Clk_c'EVENT AND Clk_c = '1' ;


    IF Reset_c = '1' THEN
        Control_state <= Reset_state;
    ELSE
        CASE Control_state IS
            when Reset_state =>
                
                PC_LdEn_c <= '0';
                RF_WrData_sel_c <= '0';
                RF_B_sel_c <= '0';
                Immed_Ext_c <= "00";
                ALU_Bin_sel_c <= '0';
                MEM_WrEn_c <= '0';
                WE_RF_c <= '0';
                Rom_registerWE_c <= '0';
                RF_A_registerWE_c <= '0';
                RF_B_registerWE_c <= '0';
                Immed_registerWE_c <= '0';
                ALU_registerWE_c <= '0';
                Ram_registerWE_c <= '0';
                Control_state <= first_intr_state;

            when first_intr_state =>
                
                PC_LdEn_c <= '1';
                RF_WrData_sel_c <= '0';
                RF_B_sel_c <= '0';
                Immed_Ext_c <= "00";
                ALU_Bin_sel_c <= '0';
                MEM_WrEn_c <= '0';
                WE_RF_c <= '0';
                Rom_registerWE_c <= '0';
                RF_A_registerWE_c <= '0';
                RF_B_registerWE_c <= '0';
                Immed_registerWE_c <= '0';
                ALU_registerWE_c <= '0';
                Ram_registerWE_c <= '0';
                Control_state <= if_Reg_state;

            when if_Reg_state =>
                
                PC_LdEn_c <= '0';
                RF_WrData_sel_c <= '0';
                RF_B_sel_c <= '0';
                Immed_Ext_c <= "00";
                ALU_Bin_sel_c <= '0';
                MEM_WrEn_c <= '0';
                WE_RF_c <= '0';
                Rom_registerWE_c <= '1';
                RF_A_registerWE_c <= '0';
                RF_B_registerWE_c <= '0';
                Immed_registerWE_c <= '0';
                ALU_registerWE_c <= '0';
                Ram_registerWE_c <= '0';
                Control_state <= decode_state;

            when decode_state =>
                if Instruction(31 downto 26) =  "100000" then
                    
                    PC_LdEn_c <= '0';
                    RF_WrData_sel_c <= '0';
                    RF_B_sel_c <= '0';
                    Immed_Ext_c <= "00";
                    ALU_Bin_sel_c <= '0';
                    MEM_WrEn_c <= '0';
                    WE_RF_c <= '0';
                    Rom_registerWE_c <= '0';
                    RF_A_registerWE_c <= '1';
                    RF_B_registerWE_c <= '1';
                    Immed_registerWE_c <= '0';
                    ALU_registerWE_c <= '0';
                    Ram_registerWE_c <= '0';
                    Control_state <= exec_R_type_state;
                elsif Instruction(31 downto 26) = "111000" or Instruction(31 downto 26) = "110000" then
                    
                    PC_LdEn_c <= '0';
                    RF_WrData_sel_c <= '0';
                    RF_B_sel_c <= '1';
                    Immed_Ext_c <= "01";
                    ALU_Bin_sel_c <= '1';
                    MEM_WrEn_c <= '0';
                    WE_RF_c <= '0';
                    Rom_registerWE_c <= '0';
                    RF_A_registerWE_c <= '1';
                    RF_B_registerWE_c <= '1';
                    Immed_registerWE_c <= '1';
                    ALU_registerWE_c <= '0';
                    Ram_registerWE_c <= '0';
                    Control_state <= exec_li_addi_state;

                elsif Instruction(31 downto 26) = "111001" then

                    PC_LdEn_c <= '0';
                    RF_WrData_sel_c <= '0';
                    RF_B_sel_c <= '1';
                    Immed_Ext_c <= "11";
                    ALU_Bin_sel_c <= '1';
                    MEM_WrEn_c <= '0';
                    WE_RF_c <= '0';
                    Rom_registerWE_c <= '0';
                    RF_A_registerWE_c <= '1';
                    RF_B_registerWE_c <= '1';
                    Immed_registerWE_c <= '1';
                    ALU_registerWE_c <= '0';
                    Ram_registerWE_c <= '0';
                    Control_state <= exec_lui_state;

                elsif Instruction(31 downto 26) = "110011" or Instruction(31 downto 26) = "110010" then

                    PC_LdEn_c <= '0';
                    RF_WrData_sel_c <= '0';
                    RF_B_sel_c <= '1';
                    Immed_Ext_c <= "00";
                    ALU_Bin_sel_c <= '1';
                    MEM_WrEn_c <= '0';
                    WE_RF_c <= '0';
                    Rom_registerWE_c <= '0';
                    RF_A_registerWE_c <= '1';
                    RF_B_registerWE_c <= '1';
                    Immed_registerWE_c <= '1';
                    ALU_registerWE_c <= '0';
                    Ram_registerWE_c <= '0';
                    Control_state <= exec_ori_andi_state;

                elsif Instruction(31 downto 26) = "111111" or Instruction(31 downto 26) = "010000" or Instruction(31 downto 26) = "010001" then

                    PC_LdEn_c <= '0';
                    RF_WrData_sel_c <= '0';
                    RF_B_sel_c <= '1';
                    Immed_Ext_c <= "10";
                    ALU_Bin_sel_c <= '0';
                    MEM_WrEn_c <= '0';
                    WE_RF_c <= '0';
                    Rom_registerWE_c <= '0';
                    RF_A_registerWE_c <= '1';
                    RF_B_registerWE_c <= '1';
                    Immed_registerWE_c <= '1';
                    ALU_registerWE_c <= '0';
                    Ram_registerWE_c <= '0';
                    Control_state <= exec_branch_state;

                elsif Instruction(31 downto 26) = "000011" or Instruction(31 downto 26) = "001111" then

                    PC_LdEn_c <= '0';
                    RF_WrData_sel_c <= '1';
                    RF_B_sel_c <= '0';
                    Immed_Ext_c <= "01";
                    ALU_Bin_sel_c <= '1';
                    MEM_WrEn_c <= '0';
                    WE_RF_c <= '0';
                    Rom_registerWE_c <= '0';
                    RF_A_registerWE_c <= '1';
                    RF_B_registerWE_c <= '1';
                    Immed_registerWE_c <= '1';
                    ALU_registerWE_c <= '0';
                    Ram_registerWE_c <= '0';
                    Control_state <= exec_load_state;

                elsif Instruction(31 downto 26) = "011111" then

                    PC_LdEn_c <= '0';
                    RF_WrData_sel_c <= '1';
                    RF_B_sel_c <= '1';
                    Immed_Ext_c <= "01";
                    ALU_Bin_sel_c <= '1';
                    MEM_WrEn_c <= '0';
                    WE_RF_c <= '0';
                    Rom_registerWE_c <= '0';
                    RF_A_registerWE_c <= '1';
                    RF_B_registerWE_c <= '1';
                    Immed_registerWE_c <= '1';
                    ALU_registerWE_c <= '0';
                    Ram_registerWE_c <= '0';
                    Control_state <= exec_store_state;

                else

                    PC_LdEn_c <= '0';   
                    RF_WrData_sel_c <= '0';
                    RF_B_sel_c <= '0';
                    Immed_Ext_c <= "00";
                    ALU_Bin_sel_c <= '0';
                    MEM_WrEn_c <= '0';
                    WE_RF_c <= '0';
                    Rom_registerWE_c <= '0';
                    RF_A_registerWE_c <= '0';
                    RF_B_registerWE_c <= '0';
                    Immed_registerWE_c <= '0';
                    ALU_registerWE_c <= '0';
                    Ram_registerWE_c <= '0';
                    Control_state <= if_Reg_state;     -- nop state

                end if;

            when exec_R_type_state =>
                
                PC_LdEn_c <= '0';
                RF_WrData_sel_c <= '0';
                RF_B_sel_c <= '0';
                Immed_Ext_c <= "00";
                ALU_Bin_sel_c <= '0';
                MEM_WrEn_c <= '0';
                WE_RF_c <= '0';
                Rom_registerWE_c <= '0';
                RF_A_registerWE_c <= '0';
                RF_B_registerWE_c <= '0';
                Immed_registerWE_c <= '0';
                ALU_registerWE_c <= '1';
                Ram_registerWE_c <= '0';
                Control_state <= wb_R_type_state;

            when exec_li_addi_state =>
                
                PC_LdEn_c <= '0';
                RF_WrData_sel_c <= '0';
                RF_B_sel_c <= '1';
                Immed_Ext_c <= "01";
                ALU_Bin_sel_c <= '1';
                MEM_WrEn_c <= '0';
                WE_RF_c <= '0';
                Rom_registerWE_c <= '0';
                RF_A_registerWE_c <= '0';
                RF_B_registerWE_c <= '0';
                Immed_registerWE_c <= '0';
                ALU_registerWE_c <= '1';
                Ram_registerWE_c <= '0';
                Control_state <= wb_exec_li_addi_state;

            when exec_lui_state =>
                
                PC_LdEn_c <= '0';
                RF_WrData_sel_c <= '0';
                RF_B_sel_c <= '1';
                Immed_Ext_c <= "11";
                ALU_Bin_sel_c <= '1';
                MEM_WrEn_c <= '0';
                WE_RF_c <= '0';
                Rom_registerWE_c <= '0';
                RF_A_registerWE_c <= '0';
                RF_B_registerWE_c <= '0';
                Immed_registerWE_c <= '0';
                ALU_registerWE_c <= '1';
                Ram_registerWE_c <= '0';
                Control_state <= wb_exec_lui_state;

            when exec_ori_andi_state =>
                
                PC_LdEn_c <= '0';
                RF_WrData_sel_c <= '0';
                RF_B_sel_c <= '1';
                Immed_Ext_c <= "00";
                ALU_Bin_sel_c <= '1';
                MEM_WrEn_c <= '0';
                WE_RF_c <= '0';
                Rom_registerWE_c <= '0';
                RF_A_registerWE_c <= '0';
                RF_B_registerWE_c <= '0';
                Immed_registerWE_c <= '0';
                ALU_registerWE_c <= '1';
                Ram_registerWE_c <= '0';
                Control_state <= wb_exec_ori_andi_state;

            when exec_branch_state =>
                
                PC_LdEn_c <= '1';
                RF_WrData_sel_c <= '0';
                RF_B_sel_c <= '1';
                Immed_Ext_c <= "10";
                ALU_Bin_sel_c <= '0';
                MEM_WrEn_c <= '0';
                WE_RF_c <= '0';
                Rom_registerWE_c <= '0';
                RF_A_registerWE_c <= '0';
                RF_B_registerWE_c <= '0';
                Immed_registerWE_c <= '0';
                ALU_registerWE_c <= '0';
                Ram_registerWE_c <= '0';
                Control_state <= if_Reg_state;

            when exec_load_state =>
                
                PC_LdEn_c <= '0';
                RF_WrData_sel_c <= '1';
                RF_B_sel_c <= '0';
                Immed_Ext_c <= "01";
                ALU_Bin_sel_c <= '1';
                MEM_WrEn_c <= '0';
                WE_RF_c <= '0';
                Rom_registerWE_c <= '0';
                RF_A_registerWE_c <= '0';
                RF_B_registerWE_c <= '0';
                Immed_registerWE_c <= '0';
                ALU_registerWE_c <= '1';
                Ram_registerWE_c <= '0';
                Control_state <= mem_load_state;

            when exec_store_state =>
                
                PC_LdEn_c <= '0';
                RF_WrData_sel_c <= '1';
                RF_B_sel_c <= '1';
                Immed_Ext_c <= "01";
                ALU_Bin_sel_c <= '1';
                MEM_WrEn_c <= '0';
                WE_RF_c <= '0';
                Rom_registerWE_c <= '0';
                RF_A_registerWE_c <= '0';
                RF_B_registerWE_c <= '0';
                Immed_registerWE_c <= '0';
                ALU_registerWE_c <= '1';
                Ram_registerWE_c <= '0';
                Control_state <= mem_store_state;

            when wb_R_type_state =>
                
                PC_LdEn_c <= '1';
                RF_WrData_sel_c <= '0';
                RF_B_sel_c <= '0';
                Immed_Ext_c <= "00";
                ALU_Bin_sel_c <= '0';
                MEM_WrEn_c <= '0';
                WE_RF_c <= '1';
                Rom_registerWE_c <= '0';
                RF_A_registerWE_c <= '0';
                RF_B_registerWE_c <= '0';
                Immed_registerWE_c <= '0';
                ALU_registerWE_c <= '0';
                Ram_registerWE_c <= '0';
                Control_state <= if_Reg_state;

            when wb_exec_li_addi_state =>
                
                PC_LdEn_c <= '1';
                RF_WrData_sel_c <= '0';
                RF_B_sel_c <= '1';
                Immed_Ext_c <= "01";
                ALU_Bin_sel_c <= '1';
                MEM_WrEn_c <= '0';
                WE_RF_c <= '1';
                Rom_registerWE_c <= '0';
                RF_A_registerWE_c <= '0';
                RF_B_registerWE_c <= '0';
                Immed_registerWE_c <= '0';
                ALU_registerWE_c <= '0';
                Ram_registerWE_c <= '0';
                Control_state <= if_Reg_state;

            when wb_exec_lui_state =>
            
                PC_LdEn_c <= '1';                   -- kai auto
                RF_WrData_sel_c <= '0';             -- mono auto mas niazei
                RF_B_sel_c <= '1';
                Immed_Ext_c <= "01";
                ALU_Bin_sel_c <= '1';
                MEM_WrEn_c <= '0';
                WE_RF_c <= '1';
                Rom_registerWE_c <= '0';
                RF_A_registerWE_c <= '0';
                RF_B_registerWE_c <= '0';
                Immed_registerWE_c <= '0';
                ALU_registerWE_c <= '0';
                Ram_registerWE_c <= '0';
                Control_state <= if_Reg_state;

            when wb_exec_ori_andi_state =>
                
                PC_LdEn_c <= '1';
                RF_WrData_sel_c <= '0';
                RF_B_sel_c <= '1';
                Immed_Ext_c <= "01";
                ALU_Bin_sel_c <= '1';
                MEM_WrEn_c <= '0';
                WE_RF_c <= '1';
                Rom_registerWE_c <= '0';
                RF_A_registerWE_c <= '0';
                RF_B_registerWE_c <= '0';
                Immed_registerWE_c <= '0';
                ALU_registerWE_c <= '0';
                Ram_registerWE_c <= '0';
                Control_state <= if_Reg_state;

            when mem_load_state =>
                
                PC_LdEn_c <= '0';
                RF_WrData_sel_c <= '1';
                RF_B_sel_c <= '0';
                Immed_Ext_c <= "01";
                ALU_Bin_sel_c <= '1';
                MEM_WrEn_c <= '0';
                WE_RF_c <= '0';
                Rom_registerWE_c <= '0';
                RF_A_registerWE_c <= '0';
                RF_B_registerWE_c <= '0';
                Immed_registerWE_c <= '0';
                ALU_registerWE_c <= '0';
                Ram_registerWE_c <= '1';
                Control_state <= wb_load_state;

            when wb_load_state =>
                
                PC_LdEn_c <= '1';
                RF_WrData_sel_c <= '1';
                RF_B_sel_c <= '0';
                Immed_Ext_c <= "01";
                ALU_Bin_sel_c <= '1';
                MEM_WrEn_c <= '0';
                WE_RF_c <= '1';
                Rom_registerWE_c <= '0';
                RF_A_registerWE_c <= '0';
                RF_B_registerWE_c <= '0';
                Immed_registerWE_c <= '0';
                ALU_registerWE_c <= '0';
                Ram_registerWE_c <= '0';
                Control_state <= if_Reg_state;

            when mem_store_state =>
                
                PC_LdEn_c <= '1';
                RF_WrData_sel_c <= '1';
                RF_B_sel_c <= '0';
                Immed_Ext_c <= "01";
                ALU_Bin_sel_c <= '1';
                MEM_WrEn_c <= '1';
                WE_RF_c <= '0';
                Rom_registerWE_c <= '0';
                RF_A_registerWE_c <= '0';
                RF_B_registerWE_c <= '0';
                Immed_registerWE_c <= '0';
                ALU_registerWE_c <= '0';
                Ram_registerWE_c <= '0';
                Control_state <= if_Reg_state;

            when others =>
                Control_state <= Reset_state;

        END CASE;
    end if;
    end process;


end Behavioral;

