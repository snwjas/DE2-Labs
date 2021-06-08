-- 
-- inputs:
--		Clk: manual clock
--		D: data input
-- outputs:
--		Qa: gated D-latch output
--		Qb: positive edge-triggered D flip-flop output
--		Qc: negative edge-triggered D flip-flop output
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY part4 IS
	PORT (Clk, D: IN STD_LOGIC;
		  Qa, Qb, Qc: OUT STD_LOGIC
	);
END part4;

ARCHITECTURE Behavior OF part4 IS
	BEGIN
		-- gated D-latch
		PROCESS (D, Clk)
		BEGIN
			IF (Clk = '1') THEN
				Qa <= D;
			END IF;
		END PROCESS;

		PROCESS (Clk)
		BEGIN
			IF (Clk'EVENT AND Clk = '1') THEN
				Qb <= D;
			END IF;
		END PROCESS;

		PROCESS (Clk)
		BEGIN
			IF (Clk'EVENT AND Clk = '0') THEN
				Qc <= D;
			END IF;
		END PROCESS;
END Behavior;