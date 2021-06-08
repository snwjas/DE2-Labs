-- Display digits from 0 to 9 on the 7-segment displays, using the SW
-- toggle switches as inputs.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY part1 IS
	PORT (SW: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		  LEDR: OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- red LEDs
		  HEX3, HEX2, HEX1, HEX0: OUT STD_LOGIC_VECTOR(0 TO 6) -- 7-segs
	);
END part1;

ARCHITECTURE Structure OF part1 IS
	COMPONENT bcd7seg
		PORT (B: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			  H: OUT STD_LOGIC_VECTOR(0 TO 6));
	END COMPONENT;

	BEGIN
		LEDR <= SW;

		-- drive the displays through 7-seg decoders
		digit3: bcd7seg PORT MAP (SW(15 DOWNTO 12), HEX3);
		digit2: bcd7seg PORT MAP (SW(11 DOWNTO 8), HEX2);
		digit1: bcd7seg PORT MAP (SW(7 DOWNTO 4), HEX1);
		digit0: bcd7seg PORT MAP (SW(3 DOWNTO 0), HEX0);
END Structure;


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY bcd7seg IS
	PORT (B: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  H: OUT STD_LOGIC_VECTOR(0 TO 6));
END bcd7seg;

ARCHITECTURE Structure OF bcd7seg IS
	BEGIN
		--				B 		H
		--     0	  	-------------------
		--   -----  	0000	0  0000001;
		--   |   |		0001	1  1001111;
		--	5|   |1		0010	2  0010010;
		-- 	 | 6 |		0011	3  0000110;
		--   -----  	0100	4  1001100;
		--   |   |		0101	5  0100100;
		--  4|   |2		0110	6  0100000;
		--   |   |		0111	7  0001111;
		--   ----- 		1000	8  0000000;
		--     3		1001	9  0000100;

		H(0) <= (NOT(B(3)) AND B(2) AND NOT(B(1)) AND NOT(B(0))) OR 
				(NOT(B(3)) AND NOT(B(2)) AND NOT(B(1)) AND B(0));
		H(1) <= (B(2) AND NOT(B(1)) AND B(0)) OR 
				(B(2) AND B(1) AND NOT(B(0)));
		H(2) <= (NOT(B(2)) AND B(1) AND NOT(B(0)));
		H(3) <= (NOT(B(3)) AND NOT(B(2)) AND NOT(B(1)) AND B(0)) OR 
				(NOT(B(3)) AND B(2) AND NOT(B(1)) AND NOT(B(0))) OR (NOT(B(3)) AND B(2) AND B(1) AND B(0));
		H(4) <= (NOT(B(1)) AND B(0)) OR (NOT(B(3)) AND B(0)) OR 
				(NOT(B(3)) AND B(2) AND NOT(B(1)));
		H(5) <= (B(1) AND B(0)) OR (NOT(B(2)) AND B(1)) OR 
				(NOT(B(3)) AND NOT(B(2)) AND B(0));
		H(6) <= (B(2) AND B(1) AND B(0)) OR (NOT(B(3)) AND NOT(B(2)) AND NOT(B(1)));

END Structure;