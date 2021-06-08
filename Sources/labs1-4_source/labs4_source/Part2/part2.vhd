-- 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY part2 IS
	PORT (Clk, Clr, En : IN STD_LOGIC;
		  Q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END part2;

ARCHITECTURE Behavioral of part2 is
	COMPONENT counter16
		PORT (Clk, Clr, En : IN STD_LOGIC;
			  Q : BUFFER STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;

	BEGIN
		counter: counter16 PORT MAP (Clk, Clr, En, Q);
END Behavioral;


-- 16bit-counter
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY counter16 IS
	PORT (Clk, Clr, En : IN STD_LOGIC;
		  Q : BUFFER STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END counter16;

ARCHITECTURE Behavioral OF counter16 IS
	BEGIN
		PROCESS (Clk, Clr, En)
		BEGIN
			IF Clr = '0' THEN
				Q <= (OTHERS => '0');
			ELSIF Clk'EVENT AND Clk = '1' THEN
				IF En = '1' THEN
					Q <= Q + 1;
				END IF;
			END IF;
		END PROCESS;
END Behavioral;