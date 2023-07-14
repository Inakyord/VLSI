--===========================================================
--                 Proyecto Final Diseño VLSI
--
-- Nombre proyecto: garraFinal
-- Nombre archivo: timer_especial
-- 
-- Función / Descripción: un temporizador modificado que entrega
--   un pulso alto mientras el tiempo establecido no haya pasado.
--   Tiene una sensibilidad de ms y se puede cancelar en cualquier
--   momento mediante una señal kill.
--
-- Elaborado por: Iñaky Ordiales Caballero
-- Fecha: mayo - junio del 2022.
--===========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Timer_especial is
	Port(	clk		: in std_logic;
			start		: in std_logic; -- señal inicio
			Tms 		: in std_logic_vector (19 downto 0); -- tiempo en alto
			Kill		: in std_logic; -- abortar tiempo
			P			: out std_logic); -- señal salida
end Timer_especial;

architecture Behavioral of Timer_especial is
	constant fclk : integer := 50_000_000;
	signal clk1ms : std_logic;
	signal previo : std_logic := '0';
	signal previoK : std_logic := '0';
	
begin
	
	process (clk)						-- Reloj de 1ms
		variable cuenta : integer := 0;
	begin
		if rising_edge (clk) then
			if cuenta >= fclk/1000-1 then
				cuenta := 0;
				clk1ms <= '1';
			else
				cuenta := cuenta + 1;
				clk1ms <= '0';
			end if;
		end if;
	end process;
	
	process (clk1ms, start, kill) 		-- Temporizador en ms
		variable cuenta : std_logic_vector (19 downto 0) := X"00000";
		variable contando : bit := '0';
	begin
	    if (kill = '1') then
	    	P <= '0';
	    	contando := '0';
		elsif rising_edge (clk1ms) then
			if contando = '0' then
				if start /= previo and start = '1' then
					cuenta := X"00000";
					contando := '1';
					P <= '1';
				else
					P <= '0';
				end if;
			else
				cuenta := cuenta + 1;
				if cuenta < Tms then
					P <= '1';
				else
					P <= '0';
					contando := '0';
				end if;
			end if;
			previo <= start;
		end if;
	end process;
	
	
end Behavioral;
