-- a gated D_lactch
-- SW(0) is the latch's D input
-- SW(1) is as the level-sensitive Clk input
-- LEDR(0) is output Q
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY part2 IS
	PORT (SW : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		  LEDR: OUT STD_LOGIC_VECTOR(0 TO 0)
	);
END part2;

ARCHITECTURE Structural OF part2 IS
	COMPONENT D_latch
		PORT (Clk, D: IN STD_LOGIC;
			  Q: OUT STD_LOGIC
		);
	END COMPONENT;

	BEGIN
		U1: D_latch PORT MAP (SW(1), SW(0), LEDR(0));

END Structural;


-- A gated D latch described the hard way
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY D_latch IS
	PORT (Clk, D: IN STD_LOGIC;
		  Q: OUT STD_LOGIC
	);
END D_latch;

ARCHITECTURE Structural OF D_latch IS
	SIGNAL R, R_g, S_g, Qa, Qb : STD_LOGIC ;
	ATTRIBUTE keep : boolean;
	ATTRIBUTE keep of R, R_g, S_g, Qa, Qb : signal is true;

	BEGIN
		R <= NOT D;
		S_g <= NOT (D AND Clk);
		R_g <= NOT (R AND Clk);
		Qa <= NOT (S_g AND Qb);
		Qb <= NOT (R_g AND Qa);

		Q <= Qa;
END Structural;