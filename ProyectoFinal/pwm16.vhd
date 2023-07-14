--===========================================================
--                 Proyecto Final Diseño VLSI
--
-- Nombre proyecto: garraFinal
-- Nombre archivo: PWM16
-- 
-- Función / Descripción: modulación por amplitud de pulso
--     PWM de 16 bits de resolución.
--
-- Elaborado por: Iñaky Ordiales Caballero
-- Fecha: mayo - junio del 2022.
--===========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity PWM16 is
	Port(	Reloj : in std_logic;
			D : in std_logic_vector (15 downto 0); -- 16 bits de resolución
			S : out std_logic); -- salida modulada
end PWM16;


architecture Behavioral of PWM16 is
begin

	process (Reloj)
		variable cuenta : integer range 0 to 65535 := 0;
	begin
		if Reloj = '1' and Reloj'event then
			cuenta := (cuenta + 1) mod 65536;
			if cuenta < D then
				S <= '1';
			else
				S <= '0';
			end if;
		end if;
	end process;
	
end Behavioral;