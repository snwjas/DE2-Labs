-- a 16-bit counter
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY counter16 IS
	PORT (Clock, Clear, Enable : IN STD_LOGIC;
		  Q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END counter16;

ARCHITECTURE Behavioral OF counter16 IS
	COMPONENT counter4
		PORT (Clock, Clear, Enable : IN STD_LOGIC;
		      Q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;
	
	SIGNAL Qn : STD_LOGIC_VECTOR(0 TO 15);
	BEGIN
		C1: counter4 PORT MAP (Clock, Clear, Enable, Qn(0 TO 3));
		C2: counter4 PORT MAP (Clock, Clear, Enable AND Qn(3), Qn(4 TO 7));
		C3: counter4 PORT MAP (Clock, Clear, Enable AND Qn(3) AND 
							   Qn(7), Qn(8 TO 11));
		C4: counter4 PORT MAP (Clock, Clear, Enable AND Qn(3) AND 
							   Qn(7) AND Qn(11), Qn(12 TO 15));
		
		Q <= Qn;
END Behavioral;