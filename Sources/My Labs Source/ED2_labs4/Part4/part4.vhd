-- Part IV of Laboratory Exercise 4 (Counters) :
-- Design and implement a circuit that successively flashes digits 0 through 9
-- on the 7-segment display HEX0. Each digit should be displayed for about one second.
-- Use a counter to determine the one-second intervals. The counter should be incremented
-- by the 50-MHz clock signal provided on the DE2 board. Do not derive any other clock signals
-- in your design make sure that all flip-flops in your circuit are clocked directly by the 50 MHz clock signal.

-- 50MHZ = 5e7HZ
-- 1s --> 1HZ

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY part4 IS
    PORT (CLOCK_50 : IN STD_LOGIC;
		  HEX7, HEX6, HEX5, HEX4 : OUT STD_LOGIC_VECTOR(0 TO 6);
		  HEX3, HEX2, HEX1, HEX0 : OUT STD_LOGIC_VECTOR(0 TO 6)
	);
END part4;

ARCHITECTURE behavioral OF part4 IS
	SIGNAL clk : STD_LOGIC;
    SIGNAL count : INTEGER RANGE 0 TO 9 := 0;
    SIGNAL countsec : INTEGER RANGE 0 TO 49999999 := 0;

    BEGIN
		clk <= CLOCK_50;

		clk_counter: PROCESS (clk)
		BEGIN
			IF clk'EVENT AND clk = '1' THEN
				IF countsec = 49999999 THEN
					countsec <= 0;
					IF count < 9 THEN
						count <= count+1;
					ELSE
						count <= 0;
					END IF;
				ELSE
					countsec <= countsec+1;
				END IF;
			END IF;
		END PROCESS;
		
		HEX7 <= "1111111";
		HEX6 <= "1111111";
		HEX5 <= "1111111";
		HEX4 <= "1111111";
		HEX3 <= "1111111";
		HEX2 <= "1111111";
		HEX1 <= "1111111";
		HEX0 <= "0000001" WHEN count=0  ELSE
				"1001111" WHEN count=1  ELSE
				"0010010" WHEN count=2  ELSE
				"0000110" WHEN count=3  ELSE
				"1001100" WHEN count=4  ELSE
				"0100100" WHEN count=5  ELSE
				"0100000" WHEN count=6  ELSE
				"0001111" WHEN count=7  ELSE
				"0000000" WHEN count=8  ELSE
				"0000100" WHEN count=9  ELSE
				"1111111";

END behavioral;