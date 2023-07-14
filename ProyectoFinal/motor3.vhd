--===========================================================
--                 Proyecto Final Diseño VLSI
--
-- Nombre proyecto: garraFinal
-- Nombre archivo: motor3
-- 
-- Función / Descripción: es el control del motor 3 del sistema,
--   se encarga del movimiento hacia abajo y arriba de la garra.
--   También avisa al servo de cerrar.
--
-- Elaborado por: Iñaky Ordiales Caballero
-- Fecha: mayo - junio del 2022.
--===========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity motor3 is
	Port(	reloj	: in std_logic;
			IM3		: in std_logic; -- señal inicio bajar
			FS		: in std_logic; -- señal inicio subir
			F		: out std_logic; -- señal listo en posición alta
			ISE 	: out std_logic; -- señal cerrar servo
			M3 		: out std_logic_vector(3 downto 0));
end motor3;

architecture Behavioral of motor3 is

	Component MotPasos is
		Port(	paso : in STD_LOGIC;
				direccion : in STD_LOGIC;
				modo : in STD_LOGIC_VECTOR(1 downto 0);
				M : out STD_LOGIC_VECTOR(3 downto 0));
	end Component MotPasos;

	Component Divisor is
		Generic 	( 	N : integer := 24); -- N : Valor que define el índice del divisor
		Port		(	clk		: in std_logic;
						div_clk	: out std_logic);
	end Component Divisor;

	signal paso : std_logic := '0';
	signal direccion : std_logic := '0';
	constant modo : std_logic_vector(1 downto 0) := "01";
	signal clks : std_logic;
	signal anterior : std_logic := '0';
	signal anteriorAux : std_logic := '0';
	signal anterior2 : std_logic := '0';
	signal anteriorAux2 : std_logic := '0';

begin

	Div : divisor generic map(16) port map(reloj, clks);
	FSM3 : motpasos port map(paso, direccion, modo, M3);

	process(IM3, FS, clks)
	begin
		if IM3 = '1' then
			anteriorAux <= anterior;
			anterior <= '1';
			paso <= clks;
			direccion <= '1';
		elsif FS = '1' then
			anteriorAux2 <= anterior2;
			anterior2 <= '1';
			paso <= clks;
			direccion <= '0';
		else 
			anteriorAux <= anterior;
			anterior <= '0';
			anteriorAux2 <= anterior2;
			anterior <= '0';
			paso <= '0';
		end if;
		if (anteriorAux <= '1' and anterior <= '0') then
			ISE <= '1';
			F <= '0';
		elsif (anteriorAux2 <= '1' and anterior2 <= '0') then
			F <= '1';
			ISE <= '0';
		else
			F <= '0';
			ISE <= '0';
		end if;
	end process;


end Behavioral;
