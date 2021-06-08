-- Implements eight 2-to-1 multiplexers.
-- inputs:SW7-0 represent the 8-bit input X, and SW15-8 represent Y
-- SW17 Sects either X or Y to drive the output LEDs
-- outputs: LEDR17-0 show the states of the switches
-- LEDG7-0 shows the outputs of the multiplexers

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Simple module that connects the SW switches to the LEDR lights
ENTITY part2 IS
	PORT (SW: IN  STD_LOGIC_VECTOR(17 DOWNTO 0);
		  LEDR: OUT STD_LOGIC_VECTOR(17 DOWNTO 0);  -- red LEDs
		  LEDG: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));  -- green LEDs
END part2;

ARCHITECTURE Structure OF part2 IS
	SIGNAL 		 S : STD_LOGIC;
	SIGNAL X, Y, M : STD_LOGIC_VECTOR(7 DOWNTO 0);

	BEGIN
		LEDR <= SW;
		S <= SW(17);
		X <= SW(7 DOWNTO 0);
		Y <= SW(15 DOWNTO 8);

		-- M <= (NOT(S) AND X) OR (S AND Y)
		M(0) <= (NOT(S) AND X(0)) OR (S AND Y(0));
		M(1) <= (NOT(S) AND X(1)) OR (S AND Y(1));
		M(2) <= (NOT(S) AND X(2)) OR (S AND Y(2));
		M(3) <= (NOT(S) AND X(3)) OR (S AND Y(3));
		M(4) <= (NOT(S) AND X(4)) OR (S AND Y(4));
		M(5) <= (NOT(S) AND X(5)) OR (S AND Y(5));
		M(6) <= (NOT(S) AND X(6)) OR (S AND Y(6));
		M(7) <= (NOT(S) AND X(7)) OR (S AND Y(7));
		LEDG(7 DOWNTO 0) <= M;
	END Structure;