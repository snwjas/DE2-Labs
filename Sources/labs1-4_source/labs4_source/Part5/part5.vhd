LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY part5 IS
    PORT (CLOCK_50 : IN STD_LOGIC;
		  HEX7, HEX6, HEX5, HEX4 : OUT STD_LOGIC_VECTOR(0 TO 6);
		  HEX3, HEX2, HEX1, HEX0 : OUT STD_LOGIC_VECTOR(0 TO 6)
	);
END part5;

ARCHITECTURE behavioral OF part5 IS
    SIGNAL count : INTEGER RANGE 0 TO 9 := 0;
    SIGNAL countsec : INTEGER RANGE 0 TO 49999999 := 0;

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

		char_7seg: PROCESS (count)
		BEGIN
			IF count = 0 THEN
				HEX7 <= "1111111";  -- blank
				HEX6 <= "1111111";  -- blank
				HEX5 <= "1111111";  -- blank
				HEX4 <= "1001000";  -- H
				HEX3 <= "0110000";  -- E
				HEX2 <= "1110001";  -- L
				HEX1 <= "1110001";  -- L
				HEX0 <= "0000001";  -- O
			ELSIF count = 1 THEN
				HEX7 <= "1111111";  -- blank
				HEX6 <= "1111111";  -- blank
				HEX5 <= "1001000";  -- H
				HEX4 <= "0110000";  -- E
				HEX3 <= "1110001";  -- L
				HEX2 <= "1110001";  -- L
				HEX1 <= "0000001";  -- O
				HEX0 <= "1111111";  -- blank
			ELSIF count = 2 THEN
				HEX7 <= "1111111";  -- blank
				HEX6 <= "1001000";  -- H
				HEX5 <= "0110000";  -- E
				HEX4 <= "1110001";  -- L
				HEX3 <= "1110001";  -- L
				HEX2 <= "0000001";  -- O
				HEX1 <= "1111111";  -- blank
				HEX0 <= "1111111";  -- blank
			ELSIF count = 3 THEN
				HEX7 <= "1001000";  -- H
				HEX6 <= "0110000";  -- E
				HEX5 <= "1110001";  -- L
				HEX4 <= "1110001";  -- L
				HEX3 <= "0000001";  -- O
				HEX2 <= "1111111";  -- blank
				HEX1 <= "1111111";  -- blank
				HEX0 <= "1111111";  -- blank
			ELSIF count = 4 THEN
				HEX7 <= "0110000";  -- E
				HEX6 <= "1110001";  -- L
				HEX5 <= "1110001";  -- L
				HEX4 <= "0000001";  -- O
				HEX3 <= "1111111";  -- blank
				HEX2 <= "1111111";  -- blank
				HEX1 <= "1111111";  -- blank
				HEX0 <= "1001000";  -- H
			ELSIF count = 5 THEN
				HEX7 <= "1110001";  -- L
				HEX6 <= "1110001";  -- L
				HEX5 <= "0000001";  -- O
				HEX4 <= "1111111";  -- blank
				HEX3 <= "1111111";  -- blank
				HEX2 <= "1111111";  -- blank
				HEX1 <= "1001000";  -- H
				HEX0 <= "0110000";  -- E
			ELSIF count = 6 THEN
				HEX7 <= "1110001";  -- L
				HEX6 <= "0000001";  -- O
				HEX5 <= "1111111";  -- blank
				HEX4 <= "1111111";  -- blank
				HEX3 <= "1111111";  -- blank
				HEX2 <= "1001000";  -- H
				HEX1 <= "0110000";  -- E
				HEX0 <= "1110001";  -- L
			ELSE
				HEX7 <= "0000001";  -- O
				HEX6 <= "1111111";  -- blank
				HEX5 <= "1111111";  -- blank
				HEX4 <= "1111111";  -- blank
				HEX3 <= "1001000";  -- H
				HEX2 <= "0110000";  -- E
				HEX1 <= "1110001";  -- L
				HEX0 <= "1110001";  -- L
			END IF;
		END PROCESS;

END behavioral;