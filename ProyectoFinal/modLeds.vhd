--===========================================================
--                 Proyecto Final Diseño VLSI
--
-- Nombre proyecto: garraFinal
-- Nombre archivo: modLeds
-- 
-- Función / Descripción: este módulo controla las luces leds
--    que se tienen para adornar el sistema, dependiendo de la
--    cuenta de entrada que se le entregue selecciona (como multiplexor)
--    una secuencia decorativa o una barra que decrementa según
--    transcurre el tiempo.
--
-- Elaborado por: Iñaky Ordiales Caballero
-- Fecha: mayo - junio del 2022.
--===========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity modLeds is
	Port (	reloj : in std_logic;
			C 	: in std_logic_vector(4 downto 0);  -- cuenta en binario 
			LD 	: out std_logic_vector(9 downto 0)); -- LEDS de salida
end modLeds;


architecture Behavioral of modLeds is

	Component Divisor is
		Generic 	( 	N : integer := 24); -- N : Valor que define el índice del divisor
		Port		(	clk		: in std_logic;
						div_clk	: out std_logic);
	end Component Divisor;

	type estado is (sm0, sm1, sm2, sm3, sm4, sm5, sm6, sm7, sm8, sm9);
	signal pres_S : estado := sm0;
	signal next_S : estado;
	signal decora : std_logic_vector(9 downto 0);
	signal paso : std_logic; -- periodo de 1 ms para el control

begin

	DivisorControl : Divisor generic map (23) port map(reloj, paso);

	t_resp : process (paso)
	begin
		if paso'event and paso='1' then
			pres_S <= next_S;
		end if;
	end process;

	--máquina de estados secuencia decorativa
	maqEdo : process(pres_S)
	begin
		case (pres_S) is
			
			when sm0 => -- E0
				next_S <= sm1;
			when sm1 => -- E1
				next_S <= sm2;
			when sm2 => -- E2
				next_S <= sm3;
			when sm3 => -- E3
				next_S <= sm4;
			when sm4 => -- E4
				next_S <= sm5;
			when sm5 => -- E5
				next_S <= sm6;
			when sm6 => -- E6
				next_S <= sm7;
			when sm7 => -- E7
				next_S <= sm8;
			when sm8 => -- E8
				next_S <= sm9;
			when sm9 => -- E9
				next_S <= sm0;

		end case;
	end process;
	
	process (pres_S)
	begin
		case pres_s is
			when sm0 => decora <= "1000000001";
			when sm1 => decora <= "0100000010";
			when sm2 => decora <= "0010000100";
			when sm3 => decora <= "0001001000";
			when sm4 => decora <= "0000110000";
			when sm5 => decora <= "0001001000";
			when sm6 => decora <= "0010000100";
			when sm7 => decora <= "0100000010";
			when sm8 => decora <= "1000000001";
			when sm9 => decora <= "0000000000";
			when others => decora <= "1111111111";
		end case;
	end process;

	-- multiplexor de seleccion
	LD <= 	decora 	 when C >= "11110" else
			"1111111111" when C > "11000" else
			"0011111111" when C > "10010" else
			"0000111111" when C > "01100" else
			"0000001111" when C > "00110" else
			"0000000011" when C > "00000";




end Behavioral;