-- T flip-flop
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY T_ff IS
	PORT (Clk, Clr, T : IN STD_LOGIC;
		  Q : OUT STD_LOGIC
	);
END T_ff;

ARCHITECTURE Behavioral OF T_ff IS
	SIGNAL Qn : STD_LOGIC;
	BEGIN
		PROCESS (Clk, Clr, T, Qn)
		BEGIN
			IF Clr = '0' THEN
				Qn <= '0';
			ELSIF Clk'EVENT AND Clk = '1' THEN
				IF T = '1' THEN
					Qn <= NOT(Qn);
				END IF;
			END IF;

			Q <= Qn;
		END PROCESS;
END Behavioral;