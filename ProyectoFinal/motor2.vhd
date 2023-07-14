--===========================================================
--                 Proyecto Final Diseño VLSI
--
-- Nombre proyecto: garraFinal
-- Nombre archivo: motor2
-- 
-- Función / Descripción: es el control del motor 2 del sistema,
--   se encarga del movimiento hacia los lados de la garra.
--
-- Elaborado por: Iñaky Ordiales Caballero
-- Fecha: mayo - junio del 2022.
--===========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity motor2 is
	Port(	reloj	: in std_logic;
			IM2		: in std_logic_vector(1 downto 0); -- encendido y dirección
			F		: in std_logic;  -- volver al inicio
			F2		: out std_logic;  -- volvió al inicio
			M2 		: out std_logic_vector(3 downto 0)); -- salida motor 2
end motor2;

architecture Behavioral of motor2 is

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
	FSM1 : motpasos port map(paso, direccion, modo, M2);
	Timer1 : Timer port map (reloj, F, CT, aux);

	process(clks2, IM2)
	begin
		if (aux = '1') then
			anterior <= '1';
		else
			anterior <= '0';
		end if;
		anteriorAux <= anterior;
		if (anteriorAux <= '1' and anterior <= '0') then
			F2 <= '1';
		else 
			F2 <= '0';
		end if;
		if IM2(1) = '1' then
			paso <= clks2;
			if IM2(0) = '0' then -- izq
				direccion <= '1';
			elsif IM2(0) = '1' then -- derecha
				direccion <= '0';
			end if;
		else
			paso <= '0';
		end if;
	end process;

	
	--process(clks, clks2, F, IM2)
	--	variable cuenta : integer range 0 to 3000 := 0;
	--begin

	--	if clks = '1' and clks'event then
	--		if F = '1' then
	--			bandera <= "11";
	--		elsif (bandera = "00" and IM2(0)='1') then
	--			bandera <= "01";
	--		elsif (bandera = "01") then
	--			bandera <= "00";
	--		end if;
			
	--		if bandera <= "00" then
	--			paso <= '0';
	--		elsif bandera <= "01" then
	--			if (cuenta < 2500 and IM2(1)='0') then
	--				paso <= clks2;
	--				direccion <= '0';
	--				cuenta := cuenta + 1;
	--			elsif (cuenta > 2 and IM2(1)='1') then
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
	--				F2 <= '1';
	--				bandera <= "00";
	--			end if;
	--		end if;
	--	end if;

	--end process;

end Behavioral;