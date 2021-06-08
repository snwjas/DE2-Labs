-- 4-bit ripple-carry adder
-- Switches SW7−4 to represent the inputs A
-- Switches SW3−0 to represent the inputs B
-- Switches SW8 for the carry-in Cin of the adder.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY part3 IS
	PORT (SW: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		  LEDR : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
		  LEDG : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END part3;

ARCHITECTURE Structure OF part3 IS
	COMPONENT fulladder
		PORT (a, b, ci: IN STD_LOGIC;
			  s, co : OUT STD_LOGIC
	  	);
	END COMPONENT;

	SIGNAL A, B, S : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL C : STD_LOGIC_VECTOR(4 DOWNTO 0); -- C(0) -> Cin; C(4) -> Cout

	BEGIN
		A <= SW(7 DOWNTO 4);
		B <= SW(3 DOWNTO 0);
		C(0) <= SW(8);

		bit0: fulladder PORT MAP (A(0), B(0), C(0), S(0), C(1));
		bit1: fulladder PORT MAP (A(1), B(1), C(1), S(1), C(2));
		bit2: fulladder PORT MAP (A(2), B(2), C(2), S(2), C(3));
		bit3: fulladder PORT MAP (A(3), B(3), C(3), S(3), C(4));

		-- Display the inputs
		LEDR <= SW;
		LEDG <= (C(4) & S);
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