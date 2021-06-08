-- KEY0 is resetn, KEY1 is the clock for reg_A
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY part5 IS
	PORT (SW: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		  KEY: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		  LEDR : OUT STD_LOGIC(15 DOWNTO 0);
		  HEX7, HEX6, HEX5, HEX4: OUT STD_LOGIC_VECTOR(0 TO 6);
		  HEX3, HEX2, HEX1, HEX0: OUT STD_LOGIC_VECTOR(0 TO 6)
	);
END part5;

ARCHITECTURE Behavior OF part5 IS
	COMPONENT hex7seg
		PORT (hex: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			  display: OUT STD_LOGIC_VECTOR(0 TO 6)
		);
	END COMPONENT;

	COMPONENT regn
		PORT (R: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
 	 		  Clock, Resetn: IN STD_LOGIC;
			  Q: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL A, B : STD_LOGIC_VECTOR(15 DOWNTO 0);
	BEGIN
		LEDR <= SW;
		-- regn (R, Clock, Resetn, Q)
		A_reg: regn PORT MAP (SW, KEY(1), KEY(0), A);
		B <= SW;

		-- drive the displays through 7-seg decoders
		digit_7: hex7seg PORT MAP (A(15 DOWNTO 12), HEX7);
		digit_6: hex7seg PORT MAP (A(11 DOWNTO 8), HEX6);
		digit_5: hex7seg PORT MAP (A(7 DOWNTO 4), HEX5);
		digit_4: hex7seg PORT MAP (A(3 DOWNTO 0), HEX4);

		digit_3: hex7seg PORT MAP (B(15 DOWNTO 12), HEX3);
		digit_2: hex7seg PORT MAP (B(11 DOWNTO 8), HEX2);
		digit_1: hex7seg PORT MAP (B(7 DOWNTO 4), HEX1);
		digit_0: hex7seg PORT MAP (B(3 DOWNTO 0), HEX0);
END Behavior;


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY regn IS
	PORT (R: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		  Clock, Resetn: IN STD_LOGIC;
	 	  Q: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END regn;

ARCHITECTURE Behavior OF regn IS
	BEGIN
		PROCESS (Clock, Resetn)
		BEGIN
			IF (Resetn = '0') THEN
				Q <= (OTHERS => '0');
			ELSIF (Clock'EVENT AND Clock = '1') THEN
				Q <= R;
			END IF;
		END PROCESS;
END Behavior;


-- 7-segment displays
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY hex7seg IS
	PORT (hex: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  display: OUT STD_LOGIC_VECTOR(0 TO 6)
	);
END hex7seg;

ARCHITECTURE Behavior OF hex7seg IS
	BEGIN
		PROCESS (hex)
		BEGIN
			CASE hex IS
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
				WHEN "1010" => display <= "0001000";
				WHEN "1011" => display <= "1100000";
				WHEN "1100" => display <= "0110001";
				WHEN "1101" => display <= "1000010";
				WHEN "1110" => display <= "0110000";
				WHEN OTHERS => display <= "0111000";
			END CASE;
		END PROCESS;
END Behavior;