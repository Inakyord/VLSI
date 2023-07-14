--===========================================================
--                 Proyecto Final Diseño VLSI
--
-- Nombre proyecto: garraFinal
-- Nombre archivo: divisor
-- 
-- Función / Descripción: un divisor de frecuencia, el cual
--    va dividiendo el reloj especificado entre 2 dando la
--    mitad de la frecuencia original cada vez. 
--
-- Elaborado por: Iñaky Ordiales Caballero
-- Fecha: mayo - junio del 2022.
--===========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Divisor is
	Generic 	( 	N : integer := 24); -- N : Valor que define el índice del divisor
	Port		(	clk		: in std_logic;
					div_clk	: out std_logic);
end Divisor;

architecture Behavioral of Divisor is

begin
	
	process (clk)
		variable cuenta : std_logic_vector (27 downto 0) := X"0000000";
	begin
		if rising_edge (clk) then
			cuenta := cuenta + 1;
		end if;
		div_clk <= cuenta (N);
	end process;
	
end Behavioral;

-- Periodo de la salida en función del valor N para clk = 50 MHz:
-- 27 ~ 5.37s,	 26 ~ 2.68s, 	 25 ~ 1.34s,	 24 ~ 671ms,	23 ~ 336 ms
-- 22 ~ 168ms,	 21 ~ 83,9ms, 	 20 ~ 41.9ms,	 19 ~ 21 ms,	18 ~ 10.5ms
-- 17 ~ 5.24ms, 16 ~ 2.62ms, 	 15 ~ 1.31ms,	 14 ~ 655us,	13 ~ 328 us
-- 12 ~ 164 us, 11 ~ 81.9us, 	 10 ~ 41 us,	  9 ~ 20.5us,	 8 ~ 10.2us
--  7 ~ 5.12us,  6 ~ 2.56us,	  5 ~ 1.28us,	  4 ~ 640 ns, 	 3 ~ 320 ns
--  2 ~ 160 ns,  1 ~ 80 ns, 	  0 ~ 40 ns, 	original ~ 20 ns