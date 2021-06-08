-- 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY part1 IS
	PORT (SW : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		  KEY : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		  LEDR : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		  HEX7, HEX6, HEX5, HEX4: OUT STD_LOGIC_VECTOR(0 TO 6);
		  HEX3, HEX2, HEX1, HEX0: OUT STD_LOGIC_VECTOR(0 TO 6)
	);
END part1;

ARCHITECTURE Behavioral OF part1 IS
	COMPONENT counter4
		PORT (Clock, Clear, Enable : IN STD_LOGIC;
			  Q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT hex7seg
		PORT (hex : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			  display : OUT STD_LOGIC_VECTOR(0 TO 6)
		);
	END COMPONENT;

	SIGNAL Clock, Clear, Enable : STD_LOGIC;
	SIGNAL Qn : STD_LOGIC_VECTOR(3 DOWNTO 0);

	BEGIN
		LEDR <= SW;
		Clock <= KEY(0);
		Clear <= SW(0);
		Enable <= SW(1);

		counter: counter4 PORT MAP (Clock, Clear, Enable, Qn);
		
		-- turn off the unrelated displays
		d7 : hex7seg PORT MAP ("ZZZZ", HEX7);
		d6 : hex7seg PORT MAP ("ZZZZ", HEX6);
		d5 : hex7seg PORT MAP ("ZZZZ", HEX5);
		d4 : hex7seg PORT MAP ("ZZZZ", HEX4);
		d3 : hex7seg PORT MAP ("ZZZZ", HEX3);
		d2 : hex7seg PORT MAP ("ZZZZ", HEX2);
		d1 : hex7seg PORT MAP ("ZZZZ", HEX1);
		
		d0 : hex7seg PORT MAP (Qn(3 DOWNTO 0), HEX0);
END Behavioral;