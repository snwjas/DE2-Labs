-- implements a two-digit bcd adder S2 S1 S0 = A1 A0 + B1 B0
-- inputs: SW15-8 = A1 A0
--         SW7-0 = B1 B0
-- outputs: A1 A0 is displayed on HEX7 HEX6
-- 			B1 B0 is displayed on HEX5 HEX4
-- S2 S1 S0 is displayed on HEX2 HEX1 HEX0

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY part6 IS
	PORT (SW: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		  LEDR: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  HEX7, HEX6, HEX5, HEX4: OUT STD_LOGIC_VECTOR(0 TO 6);  -- 7-segs
		  HEX3, HEX2, HEX1, HEX0: OUT STD_LOGIC_VECTOR(0 TO 6)  -- 7-segs
	);
END part6;

ARCHITECTURE Behavior OF part6 IS
	COMPONENT bcd7seg
		PORT (bcd: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			  display: OUT STD_LOGIC_VECTOR(0 TO 6)
	  	);
	END COMPONENT;

	SIGNAL A1, A0, B1, B0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL S2 : STD_LOGIC;
	SIGNAL S1, S0 : STD_LOGIC_VECTOR(4 DOWNTO 0);

  	-- used for BCD addition
	SIGNAL Z1, Z0 : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL T1, T0 : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL C1, C2 : STD_LOGIC;

	BEGIN
		LEDR <= SW;
		A1 <= SW(15 DOWNTO 12);
		A0 <= SW(11 DOWNTO 8);
		B1 <= SW(7 DOWNTO 4);
		B0 <= SW(3 DOWNTO 0);

		-- add lower two bcd digits. Result is five bits: C1,S0
		T0 <= ('0' & A0) + ('0' & B0);
		PROCESS (T0)
		BEGIN
			IF (T0 > "01001") THEN
				Z0 <= "01010";  -- need to subtract 10 to get least-significant digit
				C1 <= '1';
			ELSE
				Z0 <= "00000";  -- don't need to subtract anything when sum <= 9
				C1 <= '0';
			END IF;
		END PROCESS;
		S0 <= T0 - Z0;-- subtract either 10 or 0

		-- add upper two bcd digits plus C1
		T1 <= ('0' & A1) + ('0' & B1) + C1;
		PROCESS (T1)
		BEGIN
			IF (T1 > "01001") THEN
				Z1 <= "01010";
				C2 <= '1';
			ELSE
				Z1 <= "00000";
				C2 <= '0';
			END IF;
		END PROCESS;
		S1 <= T1 - Z1;  -- subtract either 10 or 0
		S2 <= C2;

		-- drive the displays through 7-seg decoders
		digit7: bcd7seg PORT MAP (A1, HEX7);
		digit6: bcd7seg PORT MAP (A0, HEX6);
		digit5: bcd7seg PORT MAP (B1, HEX5);
		digit4: bcd7seg PORT MAP (B0, HEX4);
		digit2: bcd7seg PORT MAP (("000" & S2), HEX2);
		digit1: bcd7seg PORT MAP (S1(3 DOWNTO 0), HEX1);
		digit0: bcd7seg PORT MAP (S0(3 DOWNTO 0), HEX0);

		HEX3 <= "1111111";  -- turn off HEX3
END Behavior;

-- 7-segment displays
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