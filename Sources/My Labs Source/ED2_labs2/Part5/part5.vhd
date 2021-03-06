-- implements a two-digit bcd adder S2 S1 S0 = A1 A0 + B1 B0
-- inputs: SW15-8 = A1 A0
--         SW7-0 = B1 B0
-- outputs: A1 A0 is displayed on HEX7 HEX6
-- 			B1 B0 is displayed on HEX5 HEX4
-- S2 S1 S0 is displayed on HEX2 HEX1 HEX0

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY part5 IS
	PORT (SW: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		  LEDR:OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  HEX7, HEX6, HEX5, HEX4: OUT STD_LOGIC_VECTOR(0 TO 6);  -- 7-segs
		  HEX3, HEX2, HEX1, HEX0: OUT STD_LOGIC_VECTOR(0 TO 6)  -- 7-segs
	);
END part5;

ARCHITECTURE Structure OF part5 IS
	COMPONENT part4
		PORT (A, B: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			  Cin: IN STD_LOGIC;
			  S1 : OUT STD_LOGIC;
			  S0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	  	);
	END COMPONENT;

	COMPONENT bcd7seg
		PORT (B: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			  H: OUT STD_LOGIC_VECTOR(0 TO 6)
	  	);
	END COMPONENT;

	SIGNAL A1, A0, B1, B0, S1, S0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL C1, C2, S2 : STD_LOGIC;

	BEGIN
		LEDR <= SW;
		A1 <= SW(15 DOWNTO 12);
		A0 <= SW(11 DOWNTO 8);
		B1 <= SW(7 DOWNTO 4);
		B0 <= SW(3 DOWNTO 0);

		-- part4 (A, B, Cin, S1, S0);
		BCD_0: part4 PORT MAP (A0, B0, '0', C1, S0);
		BCD_1: part4 PORT MAP (A1, B1, C1, C2, S1);
		S2 <= C2;

		-- drive the displays through 7-seg decoders
		digit7: bcd7seg PORT MAP (A1, HEX7);
		digit6: bcd7seg PORT MAP (A0, HEX6);
		digit5: bcd7seg PORT MAP (B1, HEX5);
		digit4: bcd7seg PORT MAP (B0, HEX4);
		digit2: bcd7seg PORT MAP (("000" & S2), HEX2);
		digit1: bcd7seg PORT MAP (S1, HEX1);
		digit0: bcd7seg PORT MAP (S0, HEX0);

		HEX3 <= "1111111";  -- turn off HEX3
END Structure;


-- one digit BCD adder S1 S0 = A + B + Cin
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY part4 IS
	PORT (A, B: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  Cin: IN STD_LOGIC;
		  S1 : OUT STD_LOGIC;
		  S0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END part4;

ARCHITECTURE Structure OF part4 IS
	COMPONENT fa
		PORT (a, b, ci: IN STD_LOGIC;
			  s, co : OUT STD_LOGIC
	  	);
	END COMPONENT;

	COMPONENT bcd_decimal
		PORT (V: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			  z: BUFFER STD_LOGIC;
			  M: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)  -- 7-segs
	  	);
	END COMPONENT;

	SIGNAL C : STD_LOGIC_VECTOR(4 DOWNTO 1);
	SIGNAL S, S0_M : STD_LOGIC_VECTOR(3 DOWNTO 0); -- modified S0 for sums > 15
	SIGNAL S1_M : STD_LOGIC; -- used because S1 has to be modified for sums > 15

	BEGIN
		bit0: fa PORT MAP (A(0), B(0), Cin, S(0), C(1));
		bit1: fa PORT MAP (A(1), B(1), C(1), S(1), C(2));
		bit2: fa PORT MAP (A(2), B(2), C(2), S(2), C(3));
		bit3: fa PORT MAP (A(3), B(3), C(3), S(3), C(4));

		-- convert the sum to BCD
		BCD_S: bcd_decimal PORT MAP (S, S1_M, S0_M);

		S0(3) <= (NOT(C(4)) AND S0_M(3)) OR (C(4) AND S0_M(1));
		S0(2) <= (NOT(C(4)) AND S0_M(2)) OR (C(4) AND NOT(S0_M(1)));
		S0(1) <= (NOT(C(4)) AND S0_M(1)) OR (C(4) AND NOT(S0_M(1)));
		S0(0) <= S0_M(0);

		S1 <= S1_M OR C(4);
END Structure;


-- a full adder
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY fa IS
	PORT (a, b, ci: IN STD_LOGIC;
		  s, co : OUT STD_LOGIC
  	);
END fa;

ARCHITECTURE Structure OF fa IS
	SIGNAL axorb : STD_LOGIC;
	BEGIN
		axorb <= a XOR b;
		s <= axorb XOR ci;
		co <= (NOT(axorb) AND b) OR (axorb AND ci);
END Structure;


-- Binary-to-decimal
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY bcd_decimal IS
	PORT (V: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  z: BUFFER STD_LOGIC;
		  M: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)  -- 7-segs
	);
END bcd_decimal;

ARCHITECTURE Structure OF bcd_decimal IS
	SIGNAL B : STD_LOGIC_VECTOR(2 DOWNTO 0);
	BEGIN
		-- circuit A
		z <= (V(3) AND V(2)) OR (V(3) AND V(1));

		-- Circuit B
		B(2) <= V(2) AND V(1);
		B(1) <= NOT(V(1));
		B(0) <= (V(2) AND V(1)) OR V(0);

		-- multiplexers
		M(3) <= NOT(z) AND V(3);
		M(2) <= (NOT(z) AND V(2)) OR (z AND B(2));
		M(1) <= (NOT(z) AND V(1)) OR (z AND B(1));
		M(0) <= (NOT(z) AND V(0)) OR (z AND B(0));
END Structure;


-- 7-segment displays
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY bcd7seg IS
	PORT (B: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  H: OUT STD_LOGIC_VECTOR(0 TO 6)
	);
END bcd7seg;

ARCHITECTURE Structure OF bcd7seg IS
	BEGIN
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