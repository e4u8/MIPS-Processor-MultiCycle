--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY Askisi2_TB IS
END Askisi2_TB;
 
ARCHITECTURE behavior OF Askisi2_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Askisi2
    PORT(
         Clock_a : IN  std_logic;
         Reset_a : IN  std_logic;
         Cout_flag_a : OUT  std_logic;
         Ovf_flag_a : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clock_a : std_logic := '0';
   signal Reset_a : std_logic := '0';

 	--Outputs
   signal Cout_flag_a : std_logic;
   signal Ovf_flag_a : std_logic;

   -- Clock period definitions
   constant Clock_a_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Askisi2 PORT MAP (
          Clock_a => Clock_a,
          Reset_a => Reset_a,
          Cout_flag_a => Cout_flag_a,
          Ovf_flag_a => Ovf_flag_a
        );

   -- Clock process definitions
   Clock_a_process :process
   begin
		Clock_a <= '0';
		wait for Clock_a_period/2;
		Clock_a <= '1';
		wait for Clock_a_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
		Reset_a <= '1';
      wait for Clock_a_period*10;
		
		Reset_a <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
