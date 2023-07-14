--===========================================================
--                 Proyecto Final Diseño VLSI
--
-- Nombre proyecto: garraFinal
-- Nombre archivo: modCrono
-- 
-- Función / Descripción: es un módulo de control de un cronometro
--   que va de 30 a 0 (reversa) y entrega las decenas y unidades en
--   binario, así como el total de los segundos transcurridos de forma
--   descendente.
--
-- Elaborado por: Iñaky Ordiales Caballero
-- Fecha: mayo - junio del 2022.
--===========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity modCrono is
	Port (	reloj : in std_logic;
			ST 	: in std_logic;  -- señal de pulso para la cuenta
			UB	: out std_logic_vector(3 downto 0);  -- unidades en binario de cuenta
			DB	: out std_logic_vector(3 downto 0);  -- decenas en binario de cuenta
			C 	: out std_logic_vector(4 downto 0)); -- cuenta del 30 al 0 en binario
end modCrono;


architecture Behavioral of modCrono is

	Component RelojMS is
		Port(	clk		: in std_logic;
				Tms 		: in std_logic_vector(11 downto 0);
				reloj		: out std_logic);
	end Component RelojMS;

	signal segundo : std_logic := '0';
	signal n : std_logic;
	signal auxiliar : std_logic_vector(4 downto 0) := "11110";

begin
	
	Seg : RelojMS port map (reloj, "001111101000", segundo);
	
	
	UNIDADES : process (segundo, ST)
		variable CUENTA: STD_LOGIC_VECTOR (3 downto 0) := "0000";
	begin
		if (ST = '0') then
			CUENTA := "0000";
			auxiliar <= "11110";
		elsif rising_edge (segundo) then
			auxiliar <= auxiliar - 1;
			if CUENTA = "0000" then
				CUENTA := "1001";
				N <= '1';
			else
				CUENTA := CUENTA - 1;
				N <= '0';
			end if;
		end if;
		UB <= CUENTA;
	end process;
	
	DECENAS : process (ST, N)
		variable CUENTA: STD_LOGIC_VECTOR (3 downto 0) := "0000";
	begin
		if (ST = '0') then
			CUENTA := "1111";
		elsif (CUENTA = "1111") then
			CUENTA := "0011";
		elsif rising_edge (N) then
			CUENTA := CUENTA - 1;
		else
			CUENTA := CUENTA;
		end if;
		if (ST = '0') then
			DB <= "0000";
		else
			DB <= CUENTA;
		end if;
	end process;
	
	C <= auxiliar;


end Behavioral;