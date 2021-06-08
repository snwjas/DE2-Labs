LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY part5_1 IS
    PORT (CLOCK_50 : IN STD_LOGIC;
		  HEX7, HEX6, HEX5, HEX4 : OUT STD_LOGIC_VECTOR(0 TO 6);
		  HEX3, HEX2, HEX1, HEX0 : OUT STD_LOGIC_VECTOR(0 TO 6)
	);
END part5_1;

ARCHITECTURE behavioral OF part5_1 IS

    SIGNAL count : INTEGER RANGE 0 TO 9 := 0;  -- 0 - 9 count
    SIGNAL countsec : INTEGER RANGE 0 TO 49999999 := 0;  -- one second count

    -- define 7-segment signal of "HELLO" and ""(blank)
    -- display(55 DOWNTO 49) is "" -> "1111111"
    -- display(48 DOWNTO 42) is "" -> "1111111"
    -- display(41 DOWNTO 35) is "" -> "1111111"
    -- display(34 DOWNTO 28) is "H" -> "1001000"
    -- display(27 DOWNTO 21) is "E" -> "0110000"
    -- display(20 DOWNTO 14) is "L" -> "1110001"
    -- display(13 DOWNTO 7) is "L" -> "1110001"
    -- display(6 DOWNTO 0) is "O" -> "0000001"
    SIGNAL display : STD_LOGIC_VECTOR(55 DOWNTO 0);

    BEGIN
		clk_counter: PROCESS (CLOCK_50)
		BEGIN
			IF CLOCK_50'EVENT AND CLOCK_50 = '1' THEN
				IF countsec = 49999999 THEN
					countsec <= 0;
					IF count < 7 THEN
						count <= count+1;
					ELSE
						count <= 0;
					END IF;
				ELSE
					countsec <= countsec+1;
				END IF;
			END IF;
		END PROCESS;

		HEX7 <= display((55-7*count)) DOWNTO (49-7*count));
		HEX6 <= display((48-7*count)) DOWNTO (55-7*count));
		HEX5 <= display((41-7*count)) DOWNTO (55-7*count));
		HEX4 <= display((34-7*count)) DOWNTO (55-7*count));
		HEX3 <= display((27-7*count)) DOWNTO (55-7*count));
		HEX2 <= display((20-7*count)) DOWNTO (55-7*count));
		HEX1 <= display((13-7*count)) DOWNTO (55-7*count));
		HEX0 <= display((6-7*count)) DOWNTO (55-7*count));

END behavioral;