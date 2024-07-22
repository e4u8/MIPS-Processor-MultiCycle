library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Askisi2 is
    Port ( Clock_a : in  STD_LOGIC;
           Reset_a : in  STD_LOGIC;
           Cout_flag_a : out  STD_LOGIC;
           Ovf_flag_a : out  STD_LOGIC
           );
end Askisi2;

architecture Structural of Askisi2 is
COMPONENT Execute
    PORT(
         RF_A : IN  std_logic_vector(31 downto 0);
         RF_B : IN  std_logic_vector(31 downto 0);
         Immed : IN  std_logic_vector(31 downto 0);
         ALU_Bin_sel : IN  std_logic;
         ALU_func : IN  std_logic_vector(3 downto 0);
         ALU_out : OUT  std_logic_vector(31 downto 0);
         Zero_flag : OUT  std_logic;
         Cout_flag : OUT  std_logic;
         Ovf_flag : OUT  std_logic
        );
    END COMPONENT;
	 
		  
COMPONENT IFStage
    PORT(
         PC_Immed : IN  std_logic_vector(31 downto 0);
         PC_sel : IN  std_logic;
         PC_LdEn : IN  std_logic;
         Reset : IN  std_logic;
         Clk : IN  std_logic;
         Instr : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
	 
COMPONENT DECSTAGE
    PORT(
         Instr : IN  std_logic_vector(31 downto 0);
         RF_WrEn : IN  std_logic;
         Reset : IN  std_logic;
         ALU_out : IN  std_logic_vector(31 downto 0);
         MEM_out : IN  std_logic_vector(31 downto 0);
         RF_WrData_sel : IN  std_logic;
         RF_B_sel : IN  std_logic;
         Clk : IN  std_logic;
         Immed_Ext : IN  std_logic_vector(1 downto 0);
         Immed : OUT  std_logic_vector(31 downto 0);
         RF_A : OUT  std_logic_vector(31 downto 0);
         RF_B : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
	 
COMPONENT MEM
    PORT(
         a : IN  std_logic_vector(9 downto 0);
         d : IN  std_logic_vector(31 downto 0);
         clk : IN  std_logic;
         we : IN  std_logic;
         spo : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;

component Register32bit is
		Port ( Data : in  STD_LOGIC_VECTOR (31 downto 0);
				 Dout : out  STD_LOGIC_VECTOR (31 downto 0);
				 WE : in  STD_LOGIC;
				 RESET: in STD_LOGIC;
             CLK : in  STD_LOGIC);
	end component;
	 
--COMPONENT StoreCloud
--	Port ( Opcode : in  STD_LOGIC_VECTOR (5 downto 0);
--           Rf_rd : in  STD_LOGIC_VECTOR (31 downto 0);
--           Mem_data : out  STD_LOGIC_VECTOR (31 downto 0));
--	END COMPONENT;
	
COMPONENT ALU_Control
    PORT(
         Opcode : IN  std_logic_vector(5 downto 0);
         Func : IN  std_logic_vector(5 downto 0);
         Alu_func : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
	 
COMPONENT Branch_Control
    PORT(
         Opcode : IN  std_logic_vector(5 downto 0);
         Zero_flag : IN  std_logic;
         Pc_sel_flag : OUT  std_logic
        );
    END COMPONENT;
	 
COMPONENT LoadModule
    PORT(
         Opcode : IN  std_logic_vector(5 downto 0);
         RamOut : IN  std_logic_vector(31 downto 0);
         LoadOut : INOUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;

COMPONENT Control
    PORT(
         Instruction : IN  std_logic_vector(31 downto 0);
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
         Immed_registerWE_c : OUT  std_logic;
         ALU_registerWE_c : OUT  std_logic;
         Ram_registerWE_c : OUT  std_logic
        );
    END COMPONENT;

signal RF_A_temp, RF_B_temp, Immed_temp, Instr_temp, ALU_out_temp, MEM_out_temp, d_temp, LoadOut_temp : STD_LOGIC_VECTOR (31 downto 0);
signal Instr_temp_Reg, RF_A_temp_Reg, RF_B_temp_Reg, Immed_temp_Reg, ALU_out_temp_Reg, MEM_out_temp_Reg: STD_LOGIC_VECTOR (31 downto 0);
signal Zero_flag_temp, PC_Sel_temp: STD_LOGIC;
signal Alu_func_temp : STD_LOGIC_VECTOR (3 downto 0);
signal Rom_registerWE_temp, RF_A_registerWE_temp, RF_B_registerWE_temp, Immed_registerWE_temp, ALU_registerWE_temp, Ram_registerWE_temp: STD_LOGIC;
signal PC_LdEn_temp, RF_WrData_sel_temp, RF_B_sel_temp, ALU_Bin_sel_temp, MEM_WrEn_temp, WE_RF_temp : STD_LOGIC;
signal Immed_Ext_temp : STD_LOGIC_VECTOR (1 downto 0);

begin
    exec: Execute PORT MAP (
          RF_A => RF_A_temp_Reg,
          RF_B => RF_B_temp_Reg,
          Immed => Immed_temp_Reg,
          ALU_Bin_sel => ALU_Bin_sel_temp,
          ALU_func => Alu_func_temp,
          ALU_out => ALU_out_temp,
          Zero_flag => Zero_flag_temp,
          Cout_flag => Cout_flag_a,
          Ovf_flag => Ovf_flag_a
        );
		  
-- Instantiate the Unit Under Test (UUT)
   ifst: IFStage PORT MAP (
          PC_Immed => Immed_temp_Reg,
          PC_sel => PC_Sel_temp,
          PC_LdEn => PC_LdEn_temp,
          Reset => Reset_a,
          Clk => Clock_a,
          Instr => Instr_temp
        );
		  
	decst: DECSTAGE PORT MAP (
          Instr => Instr_temp_Reg,  
          RF_WrEn => WE_RF_temp,
          Reset => Reset_a,
          ALU_out => ALU_out_temp_Reg,
          MEM_out => LoadOut_temp,
          RF_WrData_sel => RF_WrData_sel_temp,
          RF_B_sel => RF_B_sel_temp,
          Clk => Clock_a,
          Immed_Ext => Immed_Ext_temp,
          Immed => Immed_temp, 
          RF_A => RF_A_temp,
          RF_B => RF_B_temp 
        );
		  
	memor: MEM PORT MAP (
          a => ALU_out_temp_Reg(9 downto 0),
          d => RF_B_temp_Reg,
          clk => Clock_a,
          we => MEM_WrEn_temp,
          spo => MEM_out_temp
        );
		  
--	storeCl: StoreCloud PORT MAP (
--          Opcode => Instr_temp(31 downto 26),
--          Rf_rd => RF_B_temp,
--          Mem_data => d_temp
--        );
		  
	alu_contr: ALU_Control PORT MAP (
          Opcode => Instr_temp_Reg(31 downto 26),
          Func => Instr_temp_Reg(5 downto 0),
          Alu_func => Alu_func_temp
        );
		  
	branch_contr: Branch_Control PORT MAP (
          Opcode => Instr_temp_Reg(31 downto 26),
          Zero_flag => Zero_flag_temp,
          Pc_sel_flag => PC_Sel_temp
        );
		  
	load_mod: LoadModule PORT MAP (
          Opcode => Instr_temp_Reg(31 downto 26),
          RamOut => MEM_out_temp_Reg,
          LoadOut => LoadOut_temp
        );
	
	alu_register: Register32bit PORT MAP (
          Data => ALU_out_temp,
          Dout => ALU_out_temp_Reg,
          WE => ALU_registerWE_temp,
          RESET => Reset_a,
          CLK => Clock_a
        );
		  
	rom_register: Register32bit PORT MAP (
          Data => Instr_temp,
          Dout => Instr_temp_Reg,
          WE => Rom_registerWE_temp,
          RESET => Reset_a,
          CLK => Clock_a
        );
		  
	ram_register: Register32bit PORT MAP (
          Data => MEM_out_temp,
          Dout => MEM_out_temp_Reg,
          WE => Ram_registerWE_temp,
          RESET => Reset_a,
          CLK => Clock_a
        );
		  
	rfa_register: Register32bit PORT MAP (
          Data => RF_A_temp,
          Dout => RF_A_temp_Reg,
          WE => RF_A_registerWE_temp,
          RESET => Reset_a,
          CLK => Clock_a
        );
		  
	rfb_register: Register32bit PORT MAP (
          Data => RF_B_temp,
          Dout => RF_B_temp_Reg,
          WE => RF_B_registerWE_temp,
          RESET => Reset_a,
          CLK => Clock_a
        );

  immed_register: Register32bit PORT MAP (
          Data => Immed_temp,
          Dout => Immed_temp_Reg,
          WE => Immed_registerWE_temp,
          RESET => Reset_a,
          CLK => Clock_a
        );

    cntrl: Control PORT MAP (
        Instruction => Instr_temp,
        Clk_c => Clock_a,
        Reset_c => Reset_a,
        PC_LdEn_c => PC_LdEn_temp,
        RF_WrData_sel_c => RF_WrData_sel_temp,
        RF_B_sel_c => RF_B_sel_temp,
        Immed_Ext_c => Immed_Ext_temp,
        ALU_Bin_sel_c => ALU_Bin_sel_temp,
        MEM_WrEn_c => MEM_WrEn_temp,
        WE_RF_c => WE_RF_temp,
        Rom_registerWE_c => Rom_registerWE_temp,
        RF_A_registerWE_c => RF_A_registerWE_temp,
        RF_B_registerWE_c => RF_B_registerWE_temp,
        Immed_registerWE_c => Immed_registerWE_temp,
        ALU_registerWE_c => ALU_registerWE_temp,
        Ram_registerWE_c => Ram_registerWE_temp
      );


end Structural;

