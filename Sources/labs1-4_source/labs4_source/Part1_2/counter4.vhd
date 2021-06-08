-- a 4-bit counter
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY counter4 IS
	PORT (Clock, Clear, Enable : IN STD_LOGIC;
		  Q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END counter4;
	
ARCHITECTURE Behavioral OF counter4 IS
	COMPONENT T_ff
		PORT (Clk, Clr, T : IN STD_LOGIC;
			  Q : OUT STD_LOGIC
		);
	END COMPONENT;
	
	SIGNAL Qn : STD_LOGIC_VECTOR(0 TO 3);
	
	BEGIN
		T1: T_ff PORT MAP (Clock, Clear, Enable, Qn(0));
		T2: T_ff PORT MAP (Clock, Clear, Enable AND Qn(0), Qn(1));
		T3: T_ff PORT MAP (Clock, Clear, Enable AND Qn(0) AND Qn(1), Qn(2));
		T4: T_ff PORT MAP (Clock, Clear, Enable AND Qn(0) AND Qn(1) AND Qn(2), Qn(3));
		
		Q <= Qn;
END Behavioral;
		