-- 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY part1 IS
	PORT (SW : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		  KEY : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		  LEDR : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		  HEX7, HEX6, HEX5, HEX4: OUT STD_LOGIC_VECTOR(0 TO 6);
		  HEX3, HEX2, HEX1, HEX0: OUT STD_LOGIC_VECTOR(0 TO 6)
	);
END part1;

ARCHITECTURE Behavioral OF part1 IS
	COMPONENT T_ff
		PORT (Clk, Clr, T : IN STD_LOGIC;
			  Q : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT hex7seg
		PORT (hex : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			  display : OUT STD_LOGIC_VECTOR(0 TO 6)
		);
	END COMPONENT;

	SIGNAL Clock, Clear : STD_LOGIC;
	SIGNAL Enable, Qn : STD_LOGIC_VECTOR(15 DOWNTO 0);

	BEGIN
		LEDR <= SW;
		Clock <= KEY(0);
		Clear <= SW(0);

		Enable(0) <= SW(1);
		T0: T_ff PORT MAP (Clock, Clear, Enable(0), Qn(0));

		Enable(1) <= SW(1) AND Qn(0);
		T1: T_ff PORT MAP (Clock, Clear, Enable(1), Qn(1));

		Enable(2) <= Enable(1) AND Qn(1);
		T2: T_ff PORT MAP (Clock, Clear, Enable(2), Qn(2));

		Enable(3) <= Enable(2) AND Qn(2);
		T3: T_ff PORT MAP (Clock, Clear, Enable(3), Qn(3));

		Enable(4) <= Enable(3) AND Qn(3);
		T4: T_ff PORT MAP (Clock, Clear, Enable(4), Qn(4));

		Enable(5) <= Enable(4) AND Qn(4);
		T5: T_ff PORT MAP (Clock, Clear, Enable(5), Qn(5));

		Enable(6) <= Enable(5) AND Qn(5);
		T6: T_ff PORT MAP (Clock, Clear, Enable(6), Qn(6));

		Enable(7) <= Enable(6) AND Qn(6);
		T7: T_ff PORT MAP (Clock, Clear, Enable(7), Qn(7));

		Enable(8) <= Enable(7) AND Qn(7);
		T8: T_ff PORT MAP (Clock, Clear, Enable(8), Qn(8));

		Enable(9) <= Enable(8) AND Qn(8);
		T9: T_ff PORT MAP (Clock, Clear, Enable(9), Qn(9));

		Enable(10) <= Enable(9) AND Qn(9);
		T10: T_ff PORT MAP (Clock, Clear, Enable(10), Qn(10));

		Enable(11) <= Enable(10) AND Qn(10);
		T11: T_ff PORT MAP (Clock, Clear, Enable(11), Qn(11));

		Enable(12) <= Enable(11) AND Qn(11);
		T12: T_ff PORT MAP (Clock, Clear, Enable(12), Qn(12));

		Enable(13) <= Enable(12) AND Qn(12);
		T13: T_ff PORT MAP (Clock, Clear, Enable(13), Qn(13));

		Enable(14) <= Enable(13) AND Qn(13);
		T14: T_ff PORT MAP (Clock, Clear, Enable(14), Qn(14));

		Enable(15) <= Enable(14) AND Qn(14);
		T15: T_ff PORT MAP (Clock, Clear, Enable(15), Qn(15));

		-- turn off the unrelated displays
		D7 : hex7seg PORT MAP ("ZZZZ", HEX7);
		D6 : hex7seg PORT MAP ("ZZZZ", HEX6);
		D5 : hex7seg PORT MAP ("ZZZZ", HEX5);
		D4 : hex7seg PORT MAP ("ZZZZ", HEX4);

		D3 : hex7seg PORT MAP (Qn(15 DOWNTO 12), HEX3);
		D2 : hex7seg PORT MAP (Qn(11 DOWNTO 8), HEX2);
		D1 : hex7seg PORT MAP (Qn(7 DOWNTO 4), HEX1);
		D0 : hex7seg PORT MAP (Qn(3 DOWNTO 0), HEX0);
END Behavioral;


-- T flip-flop
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY T_ff IS
	PORT (Clk, Clr, T : IN STD_LOGIC;
		  Q : OUT STD_LOGIC
	);
END T_ff;

ARCHITECTURE Behavioral OF T_ff IS
	SIGNAL Qn : STD_LOGIC;
	BEGIN
		PROCESS (Clk, Clr, T, Qn)
		BEGIN
			IF Clr = '0' THEN
				Qn <= '0';
			ELSIF Clk'EVENT AND Clk = '1' THEN
				IF T = '1' THEN
					Qn <= NOT(Qn);
				END IF;
			END IF;
			
			Q <= Qn;
		END PROCESS;
END Behavioral;


-- 7-segment displays
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY hex7seg IS
	PORT (hex : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  display : OUT STD_LOGIC_VECTOR(0 TO 6)
	);
END hex7seg;

ARCHITECTURE Behavioral OF hex7seg IS
BEGIN
	PROCESS (hex)
	BEGIN
		CASE hex IS
			WHEN "0000" => display <= "0000001"; -- 0
			WHEN "0001" => display <= "1001111"; -- 1
			WHEN "0010" => display <= "0010010"; -- 2
			WHEN "0011" => display <= "0000110"; -- 3
			WHEN "0100" => display <= "1001100"; -- 4
			WHEN "0101" => display <= "0100100"; -- 5
			WHEN "0110" => display <= "0100000"; -- 6
			WHEN "0111" => display <= "0001111"; -- 7
			WHEN "1000" => display <= "0000000"; -- 8
			WHEN "1001" => display <= "0000100"; -- 9
			WHEN "1010" => display <= "0001000"; -- A
			WHEN "1011" => display <= "1100000"; -- B
			WHEN "1100" => display <= "0110001"; -- C
			WHEN "1101" => display <= "1000010"; -- D
			WHEN "1110" => display <= "0110000"; -- E
			WHEN "1111" => display <= "0111000"; -- F
			WHEN OTHERS => display <= "1111111";
		END CASE;
	END PROCESS;
END Behavioral;