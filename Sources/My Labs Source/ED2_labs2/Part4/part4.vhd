-- one-digit BCD adder S1 S0 = A + B + Cin
-- inputs: SW7-4 = A
--         SW3-0 = B
-- outputs: A is displayed on HEX6
-- 			B is displayed on HEX4
-- S1 S0 is displayed on HEX1 HEX0

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY part4 IS
	PORT (SW: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		  LEDR: OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
		  LEDG: OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
		  HEX7, HEX6, HEX5, HEX4: OUT STD_LOGIC_VECTOR(0 TO 6);
		  HEX3, HEX2, HEX1, HEX0: OUT STD_LOGIC_VECTOR(0 TO 6)
	);
END part4;

ARCHITECTURE Structure OF part4 IS
	COMPONENT fulladder
		PORT (a, b, ci: IN STD_LOGIC;
			  s, co : OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT bcd_decimal
		PORT (V: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			  z: BUFFER STD_LOGIC;
			  M: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)  -- 7-segs
	  	);
	END COMPONENT;

	COMPONENT bcd7seg
		PORT (B: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			  H: OUT STD_LOGIC_VECTOR(0 TO 6)
		);
	END COMPONENT;

	SIGNAL A, B, S : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Cin, Cout : STD_LOGIC;
	SIGNAL C : STD_LOGIC_VECTOR(3 DOWNTO 1);
	SIGNAL S0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL S0_M : STD_LOGIC_VECTOR(3 DOWNTO 0); -- modified S0 for sums > 15
	SIGNAL S1 : STD_LOGIC;

	BEGIN
		A <= SW(7 DOWNTO 4);
		B <= SW(3 DOWNTO 0);
		Cin <= SW(8);

		bit0: fulladder PORT MAP (A(0), B(0), Cin, S(0), C(1));
		bit1: fulladder PORT MAP (A(1), B(1), C(1), S(1), C(2));
		bit2: fulladder PORT MAP (A(2), B(2), C(2), S(2), C(3));
		bit3: fulladder PORT MAP (A(3), B(3), C(3), S(3), Cout);

		-- Display the inputs
		LEDR <= SW;
		LEDG(4 DOWNTO 0) <= (Cout & S);

		-- Display the inputs
		HEX7 <= "1111111";
		HEX5 <= "1111111";
		H_6: bcd7seg PORT MAP (A, HEX6);
		H_4: bcd7seg PORT MAP (B, HEX4);

		-- Detect illegal inputs, display on LEDG(8)
		LEDG(8) <= (A(3) AND A(2)) OR (A(3) AND A(1)) OR (B(3) AND B(2)) OR (B(3) AND B(1));
		LEDG(7 DOWNTO 5) <= "000";

		-- Display the sum
		BCD_S: bcd_decimal PORT MAP (S, S1, S0);
		-- multiplexers
		S0_M(3) <= (NOT(Cout) AND S0(3)) OR (Cout AND S0(1));
		S0_M(2) <= (NOT(Cout) AND S0(2)) OR (Cout AND NOT(S0(1)));
		S0_M(1) <= (NOT(Cout) AND S0(1)) OR (Cout AND NOT(S0(1)));
		S0_M(0) <= S0(0);

		H_0: bcd7seg PORT MAP (S0_M, HEX0);
		-- HEX1 <= ('1' & NOT(S1 OR Cout) & NOT(S1 OR Cout) & "1111");  -- display blank or 1
		HEX1 <= (S1 OR Cout) & "00" & (S1 OR Cout) & (S1 OR Cout) & (S1 OR Cout) & '1';  -- display 0 or 1
		HEX2 <= "1111111";
		HEX3 <= "1111111";
END Structure;


-- a full adder
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY fulladder IS
	PORT (a, b, ci: IN STD_LOGIC;
		  s, co : OUT STD_LOGIC
	);
END fulladder;

ARCHITECTURE Structure OF fulladder IS
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
	SIGNAL A : STD_LOGIC_VECTOR(2 DOWNTO 0);
	BEGIN
		-- comparator circuit for V > 9
		z <= (V(3) AND V(2)) OR (V(3) AND V(1));

		A(2) <= V(2) AND V(1);
		A(1) <= NOT(V(1));
		A(0) <= (V(2) AND V(1)) OR V(0);

		-- multiplexers
		M(3) <= NOT(z) AND V(3);
		M(2) <= (NOT(z) AND V(2)) OR (z AND A(2));
		M(1) <= (NOT(z) AND V(1)) OR (z AND A(1));
		M(0) <= (NOT(z) AND V(0)) OR (z AND A(0));
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
				(NOT(B(3)) AND B(2) AND NOT(B(1)) AND NOT(B(0))) OR 
				(NOT(B(3)) AND B(2) AND B(1) AND B(0));
		H(4) <= (NOT(B(1)) AND B(0)) OR (NOT(B(3)) AND B(0)) OR 
				(NOT(B(3)) AND B(2) AND NOT(B(1)));
		H(5) <= (B(1) AND B(0)) OR (NOT(B(2)) AND B(1)) OR 
				(NOT(B(3)) AND NOT(B(2)) AND B(0));
		H(6) <= (B(2) AND B(1) AND B(0)) OR (NOT(B(3)) AND NOT(B(2)) AND NOT(B(1)));

END Structure;