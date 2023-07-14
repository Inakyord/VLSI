--===========================================================
--                 Proyecto Final Diseño VLSI
--
-- Nombre proyecto: garraFinal
-- Nombre archivo: motor1
-- 
-- Función / Descripción: es el control del motor 1 del sistema,
--   se encarga del movimiento hacia adelante y hacia atrás de
--   la garra.
--
-- Elaborado por: Iñaky Ordiales Caballero
-- Fecha: mayo - junio del 2022.
--===========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity motor1 is
	Port(	reloj	: in std_logic;
			IM1		: in std_logic_vector(1 downto 0); -- encendido y dirección
			F2		: in std_logic; -- volver al inicio
			F3		: out std_logic; -- se volvió al inicio
			M1 		: out std_logic_vector(3 downto 0)); -- motor 1 salida
end motor1;


architecture Behavioral of motor1 is

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

	Component Timer is
		Port(	clk		: in std_logic;
				start		: in std_logic;
				Tms 		: in std_logic_vector (19 downto 0);
				P			: out std_logic);
	end Component Timer;

	signal paso : std_logic := '0';
	signal direccion : std_logic;
	constant modo : std_logic_vector(1 downto 0) := "01";
	--signal clks : std_logic;
	signal clks2 : std_logic;
	signal bandera : std_logic_vector(1 downto 0) := "00";
	--signal cuenta : std_logic_vector(9 downto 0) := "0000000000";
	constant CT : std_logic_vector(19 downto 0) := "00000000001111111111";
	signal aux :std_logic := '0';
	signal anterior : std_logic := '0';
	signal anteriorAux : std_logic := '0';

begin
	
	Div : divisor generic map(16) port map(reloj, clks2);
	--Div2 : divisor generic map(14) port map(reloj, clks);
	FSM1 : motpasos port map(paso, direccion, modo, M1);
	Timer1 : Timer port map (reloj, F2, CT, aux);

	process(clks2, IM1)
	begin
		if (aux = '1') then
			anterior <= '1';
		else
			anterior <= '0';
		end if;
		anteriorAux <= anterior;
		if (anteriorAux <= '1' and anterior <= '0') then
			F3 <= '1';
		else 
			F3 <= '0';
		end if;
		if IM1(1) = '1' then
			paso <= clks2;
			if IM1(0) = '0' then -- atrás
				direccion <= '1';
			elsif IM1(0) = '1' then -- adelante
				direccion <= '0';
			end if;
		else
			paso <= '0';
		end if;
	end process;


	--process(clks, clks2, F2, IM1)
	--	variable cuenta : integer range 0 to 3000 := 0;
	--begin

	--	if clks = '1' and clks'event then
	--		if F2 = '1' then
	--			bandera <= "11";
	--		elsif (bandera = "00" and IM1(0)='1') then
	--			bandera <= "01";
	--		elsif (bandera = "01") then
	--			bandera <= "00";
	--		end if;
			
	--		if bandera <= "00" then
	--			paso <= '0';
	--		elsif bandera <= "01" then
	--			if (cuenta < 2500 and IM1(1)='0') then
	--				paso <= clks2;
	--				direccion <= '0';
	--				cuenta := cuenta + 1;
	--			elsif (cuenta > 2 and IM1(1)='1') then
	--				paso <= clks2;
	--				cuenta := cuenta - 1;
	--				direccion <= '1';
	--			else 
	--				paso <= '0';
	--			end if;
	--		elsif bandera <= "11" then
	--			if (cuenta > 1) then
	--				paso <= clks2;
	--				direccion <= '0';
	--			else
	--				F3 <= '1';
	--				bandera <= "00";
	--			end if;
	--		end if;
	--	end if;
	--end process;

end Behavioral;