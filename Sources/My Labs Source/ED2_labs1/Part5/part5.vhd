-- Implements a circuit that can display different 5-letter words on five 7-segment
-- displays. The character selected for each display is chosen by
-- a multiplexer, and these multiplexers are connected to the characters
-- in a way that ALLows a word to be rotated across the displays from
-- right-to-left as the multiplexer select lines are changed through the
-- sequence 000, 001, 010, 011, 100, 000, etc. Using the four characters H,
-- E, L, O, the displays can scroll any 5-letter word using these letters, such
-- as "HELLO", as follows:
--
-- SW 17 16 15 Displayed characters
-- 	   0  0  0	  HELLO
--     0  0  1    ELLOH
--     0  1  0    LLOHE
--     0  1  1    LOHEL
--     1  0  0    OHELL
--
-- inputs: SW17-15 provide the multiplexer select lines
--         SW14-0 provide five 3-bit codes used to select characters
-- outputs: LEDR shows the states of the switches
--          HEX4 - HEX0 displays the characters (HEX7 - HEX5 are set to "blank")


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY part5 IS
	PORT (					 SW : IN  STD_LOGIC_VECTOR(17 DOWNTO 0);
			 				LEDR: OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
		  HEX7, HEX6, HEX5, HEX4: OUT STD_LOGIC_VECTOR(0 TO 6);
		  HEX3, HEX2, HEX1, HEX0: OUT STD_LOGIC_VECTOR(0 TO 6));
END part5;

ARCHITECTURE Structure OF part5 IS
	COMPONENT mux_3bit_5to1
		PORT (S, U, V, W, X, Y : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
							 M : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
	END COMPONENT;

	COMPONENT char_7seg
		PORT (		C: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			  Display: OUT STD_LOGIC_VECTOR(0 TO 6));
	END COMPONENT;

	SIGNAL Ch_S, Ch1, Ch2, Ch3, Ch4, Ch5, Blank :STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL H4_Ch, H3_Ch, H2_Ch, H1_Ch, H0_Ch : STD_LOGIC_VECTOR(2 DOWNTO 0);

	BEGIN
		LEDR <= SW;

		Ch_S <= SW(17 DOWNTO 15);
		Ch1 <= SW(14 DOWNTO 12);
		Ch2 <= SW(11 DOWNTO 9);
		Ch3 <= SW(8 DOWNTO 6);
		Ch4 <= SW(5 DOWNTO 3);
		Ch5 <= SW(2 DOWNTO 0);
		Blank <= "111"; -- used to blank a 7-seg display (see module char_7seg)

		-- instantiate mux_3bit_5to1 (S, U, V, W, X, Y, M);
		M4: mux_3bit_5to1 PORT MAP (Ch_S, Ch1, Ch2, Ch3, Ch4, Ch5, H4_Ch);
		M3: mux_3bit_5to1 PORT MAP (Ch_S, Ch2, Ch3, Ch4, Ch5, Ch1, H3_Ch);
		M2: mux_3bit_5to1 PORT MAP (Ch_S, Ch3, Ch4, Ch5, Ch1, Ch2, H2_Ch);
		M1: mux_3bit_5to1 PORT MAP (Ch_S, Ch4, Ch5, Ch1, Ch2, Ch3, H1_Ch);
		M0: mux_3bit_5to1 PORT MAP (Ch_S, Ch5, Ch1, Ch2, Ch3, Ch4, H0_Ch);

		-- instantiate char_7seg (C, Display);
		H7: char_7seg PORT MAP (Blank, HEX7);
		H6: char_7seg PORT MAP (Blank, HEX6);
		H5: char_7seg PORT MAP (Blank, HEX5);
		H4: char_7seg PORT MAP (H4_Ch, HEX4);
		H3: char_7seg PORT MAP (H3_Ch, HEX3);
		H2: char_7seg PORT MAP (H2_Ch, HEX2);
		H1: char_7seg PORT MAP (H1_Ch, HEX1);
		H0: char_7seg PORT MAP (H0_Ch, HEX0);
END Structure;


-- Implements a 3-bit wide 5-to-1 multiplexer
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux_3bit_5to1 IS
	PORT (S, U, V, W, X, Y: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
						 M: OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
END mux_3bit_5to1;

ARCHITECTURE Behavior OF mux_3bit_5to1 IS
	SIGNAL m_0, m_1, m_2 : STD_LOGIC_VECTOR(1 TO 3); -- intermediate multiplexers
	BEGIN
		-- 5-to-1 multiplexer for bit 0
		m_0(1) <= (NOT(S(0)) AND U(0)) OR (S(0) AND V(0));
		m_0(2) <= (NOT(S(0)) AND W(0)) OR (S(0) AND X(0));
		m_0(3) <= (NOT(S(1)) AND m_0(1)) OR (S(1) AND m_0(2));
		M(0) <= (NOT(S(2)) AND m_0(3)) OR (S(2) AND Y(0)); -- 5-to-1 multiplexer output

		-- 5-to-1 multiplexer for bit 1
		m_1(1) <= (NOT(S(0)) AND U(1)) OR (S(0) AND V(1));
		m_1(2) <= (NOT(S(0)) AND W(1)) OR (S(0) AND X(1));
		m_1(3) <= (NOT(S(1)) AND m_1(1)) OR (S(1) AND m_1(2));
		M(1) <= (NOT(S(2)) AND m_1(3)) OR (S(2) AND Y(1)); -- 5-to-1 multiplexer output

		-- 5-to-1 multiplexer for bit 2
		m_2(1) <= (NOT(S(0)) AND U(2)) OR (S(0) AND V(2));
		m_2(2) <= (NOT(S(0)) AND W(2)) OR (S(0) AND X(2));
		m_2(3) <= (NOT(S(1)) AND m_2(1)) OR (S(1) AND m_2(2));
		M(2) <= (NOT(S(2)) AND m_2(3)) OR (S(2) AND Y(2)); -- 5-to-1 multiplexer output
END Behavior;


-- a character on a 7-segment display.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY char_7seg IS
	PORT (		C: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		  Display: OUT STD_LOGIC_VECTOR(0 TO 6));
END char_7seg;

ARCHITECTURE Behavior OF char_7seg IS
	BEGIN
		Display(0) <= C(2) OR NOT(C(0));
		Display(1) <= C(2) OR (C(1) AND NOT(C(0))) OR (NOT(C(1)) AND C(0));
		Display(2) <= C(2) OR (C(1) AND NOT(C(0))) OR (NOT(C(1)) AND C(0));
		Display(3) <= C(2) OR (NOT(C(1)) AND NOT(C(0)));
		Display(4) <= C(2);
		Display(5) <= C(2);
		Display(6) <= C(2) OR C(1);
		
END Behavior;