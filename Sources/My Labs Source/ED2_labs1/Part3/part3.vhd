-- Implements a 3-bit wide 5-to-1 multiplexer.
-- inputs: SW14-0 represent data in 5 groups, U-Y
-- SW17-15 selects one group from U to Y
-- outputs: LEDR17-0 show the states of the switches
-- LEDG2-0 displays the selected group

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Simple module that connects the SW switches to the LEDR lights
ENTITY part3 IS
	PORT (SW : IN  STD_LOGIC_VECTOR(17 DOWNTO 0);
		LEDR : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);  -- red LEDs
		LEDG : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));  -- green LEDs
END part3;

ARCHITECTURE Structure OF part3 IS
	SIGNAL m_0, m_1, m_2 : STD_LOGIC_VECTOR(1 TO 3);
	-- m_0 is used for 3 intermediate
	-- multiplexers to produce the
	-- 5-to-1 multiplexer M(0), m_1 is
	-- for M(1), and m_2 is for M(2)
	SIGNAL S, U, V, W, X, Y, M : STD_LOGIC_VECTOR(2 DOWNTO 0);
	-- M is the 3-bit 5-to-1 multiplexer
	BEGIN
		S(2 DOWNTO 0) <= SW(17 DOWNTO 15);
		U <= SW(2 DOWNTO 0);
		V <= SW(5 DOWNTO 3);
		W <= SW(8 DOWNTO 6);
		X <= SW(11 DOWNTO 9);
		Y <= SW(14 DOWNTO 12);

		LEDR <= SW;

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

		LEDG(2 DOWNTO 0) <= M;
	END Structure;