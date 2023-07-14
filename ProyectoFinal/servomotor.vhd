--===========================================================
--                 Proyecto Final Diseño VLSI
--
-- Nombre proyecto: garraFinal
-- Nombre archivo: servomotor
-- 
-- Función / Descripción: control de un servomotor recibiendo
--    la posición en porcentaje mediante notación binaria de
--    7 bits.
--
-- Elaborado por: Iñaky Ordiales Caballero
-- Fecha: mayo - junio del 2022.
--===========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Servomotor is
	Port(	clk : in std_logic;
			posicion : in std_logic_vector (6 downto 0); -- posición porcentual del servo
			control : out std_logic); -- señal control de servo
end Servomotor;


architecture Behavioral of Servomotor is
	
	Component Divisor is
		Generic 	( 	N : integer := 24); -- N : Valor que define el índice del divisor
		Port		(	clk		: in std_logic;
						div_clk	: out std_logic);
	end Component Divisor;
		
	Component PWM16 is
		Port(	Reloj : in std_logic;
				D : in std_logic_vector (15 downto 0);
				S : out std_logic);
	end component;
	
	signal reloj : std_logic;
	signal ancho : std_logic_vector (15 downto 0) := X"1250";
	
begin
	
	U1: divisor generic map (3) port map (clk, reloj);
	U2: PWM16 port map (reloj, ancho, control);
	
	process (reloj, posicion)
		variable valor : std_logic_vector (23 downto 0) := X"001250";
		variable cuenta : integer range 0 to 262143 := 0;
	begin
		if reloj = '1' and reloj'event then
			if cuenta > 0 then
				cuenta := cuenta - 1;
			else
				if posicion = "0000000" then
					valor := X"000C35";
				elsif posicion > "1100100" then
					valor := X"00186A";
				else
					valor := X"000C35"+(posicion*"000011111");
				end if;
				cuenta := 262143;
				ancho <= valor(15 downto 0);
			end if;
		end if;
	end process;
	
	
end Behavioral;