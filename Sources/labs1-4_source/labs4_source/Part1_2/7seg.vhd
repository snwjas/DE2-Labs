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