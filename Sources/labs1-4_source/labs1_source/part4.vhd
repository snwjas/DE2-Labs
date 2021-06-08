-- Implements a circuit that can display five characters on a 7-segment
-- display.
-- inputs:SW2-0 selects the letter to display. The characters are:
--       0
--      ---
--     |   |
--    5|   |1
--     | 6 |
--      ---
--     |   |
--    4|   |2
--     |   |
--      ---
--       3
-- SW2-0	Char 	HEX00-6
-- ------------------------
-- 0 0 0	'H'		1001000
-- 0 0 1	'E'		0110000
-- 0 1 0 	'L'		1110001
-- 0 1 1	'O'		0000001
-- 1 0 0	' '		1111111
-- 1 0 1	' '		1111111
-- 1 1 0	' '		1111111
-- 1 1 1	' '		1111111
--
-- outputs: LEDR2-0 show the states of the switches
-- HEX0 displays the selected character

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY part4 IS
	PORT (SW   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0); -- toggle switches
		  LEDR : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- red LEDs
		  HEX0 : OUT STD_LOGIC_VECTOR(0 TO 6)); -- 7-seg display
END part4;

ARCHITECTURE Structure OF part4 IS
	SIGNAL C : STD_LOGIC_VECTOR(2 DOWNTO 0);
	BEGIN
		LEDR <= SW;
		C(2 DOWNTO 0) <= SW(2 DOWNTO 0);

		-- seg[0] k-map
		-- c2\c1c0
		--    00  01  11  10
		--   -----------------
		-- 0 | 0 | 0 | 1 | 1 |
		--   -----------------
		-- 1 | 1 | 1 | 1 | 1 |
		--   -----------------
		-- seg[0] = ~c0+c2

		HEX0(0) <= C(2) OR NOT(C(0));
		HEX0(1) <= C(2) OR (C(1) AND NOT(C(0))) OR (NOT(C(1)) AND C(0));
		HEX0(2) <= C(2) OR (C(1) AND NOT(C(0))) OR (NOT(C(1)) AND C(0));
		HEX0(3) <= C(2) OR (NOT(C(1)) AND NOT(C(0)));
		HEX0(4) <= C(2);
		HEX0(5) <= C(2);
		HEX0(6) <= C(2) OR C(1);

END Structure;