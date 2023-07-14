--===========================================================
--                 Proyecto Final Diseño VLSI
--
-- Nombre proyecto: garraFinal
-- Nombre archivo: modServo
-- 
-- Función / Descripción: controla el abrir y cerrar de la garra.
--   Esto mediante dos señales de entrada (ISE, Soltar) que le
--   indican cuándo abrir y cerrar la garra usando PWM y el 
--   módulo de control de porcentaje a posición del servo.
--
-- Elaborado por: Iñaky Ordiales Caballero
-- Fecha: mayo - junio del 2022.
--===========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity modServo is
	Port (	reloj	: in std_logic;
			ISE	 	: in std_logic; -- Señal para cerrar
			Soltar	: in std_logic; -- Señal para abrir
			FS		: out std_logic;  -- Señal indicar se cerró
			Listo	: out std_logic;  -- Señal indicar se abrió
			S 		: out std_logic);  -- Señal PWM para control de servo
end modServo;

architecture Behavioral of modServo is

	Component Servomotor is
		Port(	clk : in std_logic;
				posicion : in std_logic_vector (6 downto 0);
				control : out std_logic);
	end Component Servomotor;

	Component Timer is
		Port(	clk		: in std_logic;
				start		: in std_logic;
				Tms 		: in std_logic_vector (19 downto 0);
				P			: out std_logic);
	end Component Timer;
	
	signal posicion : std_logic_vector (6 downto 0);
	constant CT : std_logic_vector(19 downto 0) := "00000000000011111010";
	signal inicio : std_logic := '0';
	signal Q : std_logic;

begin

	servo : servomotor port map(reloj, posicion, S);
	tiempo : Timer port map(reloj, inicio, CT, Q);

	process (Q)
	begin
		if Q='1' then
			FS <= '1';
			Listo <= '1';
		else
			FS <= '0';
			Listo <= '0';
		end if;
	end process;

	process (ISE, Soltar)
	begin
		if (ISE = '1') then
			posicion <= "1100001";
			inicio <= '1';
		elsif (Soltar = '1') then
			posicion <= "1001111";
			inicio <= '1';
		else
			inicio <= '0';
		end if;
	end process;


end Behavioral;


