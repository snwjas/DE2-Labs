-- a 6-bit binary number into a 2-digit decimal number represented in
-- the BCD form. Use switches SW5−0 to input the binary number and
-- 7-segment displays HEX1 and HEX0 to display the decimal number.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- input six bits using SW toggle switches, and convert to decimal (2-digit bcd)
ENTITY part7 IS
	PORT (SW: IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		  LEDR: OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
		  HEX3, HEX2, HEX1, HEX0: OUT STD_LOGIC_VECTOR(0 TO 6);  -- 7-segs
		  HEX7, HEX6, HEX5, HEX4: OUT STD_LOGIC_VECTOR(0 TO 6)  -- 7-segs
	);
END part7;

ARCHITECTURE Behavior OF part7 IS
	COMPONENT bcd7seg
		PORT (bcd: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			  display: OUT STD_LOGIC_VECTOR(0 TO 6)
		);
	END COMPONENT;

	SIGNAL bcd_h : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL bin6, bcd_l : STD_LOGIC_VECTOR(5 DOWNTO 0);

	BEGIN
		LEDR <= SW;
		bin6 <= SW;

		-- Check various ranges and set bcd digits. Note that we work with
		-- bin6(3 DOWNTO 0) just to prevent compiler warnings about bit size
		-- truncation. This is not really necessary
		PROCESS (bin6)
		BEGIN
			IF (bin6 < "001010") THEN
				bcd_h <= "0000";
				bcd_l <= bin6;
			ELSIF (bin6 < "010100") THEN
				bcd_h <= "0001";
				bcd_l <= bin6 - "001010";
			ELSIF (bin6 < "011110") THEN
				bcd_h <= "0010";
				bcd_l <= bin6 - "010100";
			ELSIF (bin6 < "101000") THEN
				bcd_h <= "0011";
				bcd_l <= bin6 - "011110";
			ELSIF (bin6 < "110010") THEN
				bcd_h <= "0100";
				bcd_l <= bin6 - "101000";
			ELSIF (bin6 < "111100") THEN
				bcd_h <= "0101";
				bcd_l <= bin6 - "110010";
			ELSE
				bcd_h <= "0110";
				bcd_l <= bin6 - "111100";
			END IF;
		END PROCESS;

	-- drive the displays
	digit1: bcd7seg PORT MAP (bcd_h, HEX1);
	digit0: bcd7seg PORT MAP (bcd_l(3 DOWNTO 0), HEX0);

	-- turn off the unrelated displays
	digit2: bcd7seg PORT MAP ("1111", HEX2);
	digit3: bcd7seg PORT MAP ("1111", HEX3);
	digit4: bcd7seg PORT MAP ("1111", HEX4);
	digit5: bcd7seg PORT MAP ("1111", HEX5);
	digit6: bcd7seg PORT MAP ("1111", HEX6);
	digit7: bcd7seg PORT MAP ("1111", HEX7);
END Behavior;


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY bcd7seg IS
	PORT (bcd: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  display: OUT STD_LOGIC_VECTOR(0 TO 6)
	);
END bcd7seg;

ARCHITECTURE Behavior OF bcd7seg IS
	BEGIN
		PROCESS (bcd)
		BEGIN
			CASE bcd IS
				WHEN "0000" => display <= "0000001";
				WHEN "0001" => display <= "1001111";
				WHEN "0010" => display <= "0010010";
				WHEN "0011" => display <= "0000110";
				WHEN "0100" => display <= "1001100";
				WHEN "0101" => display <= "0100100";
				WHEN "0110" => display <= "0100000";
				WHEN "0111" => display <= "0001111";
				WHEN "1000" => display <= "0000000";
				WHEN "1001" => display <= "0000100";
				WHEN OTHERS => display <= "1111111";
			END CASE;
		END PROCESS;
END Behavior;