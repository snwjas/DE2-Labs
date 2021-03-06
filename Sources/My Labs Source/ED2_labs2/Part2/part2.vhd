-- four-bit binary number into its two-digit decimal equivalent.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY part2 IS
	PORT (V: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  z: BUFFER STD_LOGIC;
		  M: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)  -- 7-segs
	);
END part2;

ARCHITECTURE Structure OF part2 IS
	SIGNAL A : STD_LOGIC_VECTOR(2 DOWNTO 0);
	BEGIN
		-- comparator circuit for V > 9
		z <= (V(3) AND V(2)) OR (V(3) AND V(1));

		-- Circuit A: when V > 9, this circuit allows the digit d0 to display the
		-- values 0 - 5 (for the numbers V = 10 to V = 15). Note that V3 = 1 for all of these
		-- values, and V3 isn't needed in circuit A. The circuit implements the truth table:
		--
		-- V2 V1 V0 | A2 A1 A0
		-- -------------------
		-- 0  1  0  | 0  0  0	V = 1010 -> 0
		-- 0  1  1  | 0  0  1  	V = 1011 -> 1
		-- 1  0  0  | 0  1  0  	V = 1100 -> 2
		-- 1  0  1  | 0  1  1 	V = 1101 -> 3
		-- 1  1  0  | 1  0  0  	V = 1110 -> 4
		-- 1  1  1  | 1  0  1  	V = 1111 -> 5

		A(2) <= V(2) AND V(1);
		A(1) <= NOT(V(1));
		A(0) <= (V(2) AND V(1)) OR V(0);

		-- multiplexers
		M(3) <= NOT(z) AND V(3);
		M(2) <= (NOT(z) AND V(2)) OR (z AND A(2));
		M(1) <= (NOT(z) AND V(1)) OR (z AND A(1));
		M(0) <= (NOT(z) AND V(0)) OR (z AND A(0));
END Structure;