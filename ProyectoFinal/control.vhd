--===========================================================
--                 Proyecto Final Diseño VLSI
--
-- Nombre proyecto: garraFinal
-- Nombre archivo: control
-- 
-- Función / Descripción: es el control central del sistema
--   implementado. Es una máquina de estado que conecta a
--   los demás componentes entre sí mediante señales de 
--   aviso (salidas) y respuestas (entradas).
--
-- Elaborado por: Iñaky Ordiales Caballero
-- Fecha: mayo - junio del 2022.
--===========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control is
	Port(	reloj	: in std_logic; -- 50 MHz reloj tarjeta
			P		: in std_logic; -- P - pagado
			U		: in std_logic; -- U - Up = arriba
			D		: in std_logic; -- D - Down = abajo
			R		: in std_logic; -- R - Right = derecha
			L 		: in std_logic; -- L - Left = izquierda
			I		: in std_logic; -- I - iniciar juego
			G		: in std_logic; -- G - activar garra
			ST 		: in std_logic; -- ST - temporizador 30s
			F3		: in std_logic; -- F3 - garra en posicion inicial
			Listo	: in std_logic; -- Listo - Servomotor fue abierto
			LDP		: out std_logic;
			T 		: out std_logic :='0'; -- T - iniciar temporizador 30s
			K 		: out std_logic :='0'; -- K - matar temporizador
			IM1		: out std_logic_vector(1 downto 0) :="00"; -- IM1 - inicio y dirección mot1
			IM2		: out std_logic_vector(1 downto 0) :="00"; -- IM2 - inicio y dirección mot2
			IM3		: out std_logic :='0'; -- IM3 - inicio motor 3 bajar
			Soltar	: out std_logic :='0'); -- señal al servomotor para abrir garra
end control;


architecture Behavioral of control is

	-- Módulo divisor de frecuencia para el control:
	Component Divisor is
		Generic 	( 	N : integer := 24); -- N : Valor que define el índice del divisor
		Port		(	clk		: in std_logic;
						div_clk	: out std_logic);
	end Component Divisor;

	type estado is (sm0, sm1, sm2, sm3, sm4, sm5, sm6, sm7, sm8, sm9, sm10);
	signal pres_S, next_S : estado;

  	signal paso : std_logic; -- periodo de 1 ms para el control

begin

	DivisorControl : Divisor generic map (15) port map(reloj, paso);

	t_resp : process (paso)
	begin
		if paso'event and paso='1' then
			pres_S <= next_S;
		end if;
	end process;

	maqEdo : process(pres_S, P, U, D, R, L, I, G, ST, F3, Listo)
	begin
		case (pres_S) is
			
			when sm0 => -- estado inicial 0
				if (P = '1') then
					next_S <= sm1;
				else
					next_S <= sm0;
				end if;
				LDP <='0';
				T <= '0';
				K <= '0';
				IM1 <= "00";
				IM2 <= "00";
				IM3 <= '0';
				Soltar <= '0';

			when sm1 => -- estado pagado 1
				if (I = '1') then
					next_S <= sm2;
				else
					next_S <= sm1;
				end if;
				LDP <='1';
				T <= '0';
				K <= '0';
				IM1 <= "00";
				IM2 <= "00";
				IM3 <= '0';
				Soltar <= '0';

			when sm2 => -- estado iniciando 2
				if (ST='1') then
					next_S <= sm3;
				else
					next_S <= sm2;
				end if;
				LDP <='0';
				T <= '1';
				K <= '0';
				IM1 <= "00";
				IM2 <= "00";
				IM3 <= '0';
				Soltar <= '0';

			when sm3 => -- estado parado 3
				--if (ST = '0' or G = '1') then
				if (G = '1') then
					next_S <= sm8;
				elsif (U='1' and D='0' and R='0' and L='0') then
					next_S <= sm4;
				elsif (U='0' and D='1' and R='0' and L='0') then
					next_S <= sm5;
				elsif (U='0' and D='0' and R='0' and L='1') then
					next_S <= sm6;
				elsif (U='0' and D='0' and R='1' and L='0') then
					next_S <= sm7;
				else
					next_S <= sm3;
				end if;
				LDP <='0';
				T <= '0';
				K <= '0';
				IM1 <= "00";
				IM2 <= "00";
				IM3 <= '0';
				Soltar <= '0';

			when sm4 => -- estado arriba 4
				--if (ST = '0' or G = '1') then
				if (G = '1') then
					next_S <= sm8;
				elsif (U='1' and D='0' and R='0' and L='0') then
					next_S <= sm4;
				elsif (U='0' and D='1' and R='0' and L='0') then
					next_S <= sm5;
				elsif (U='0' and D='0' and R='0' and L='1') then
					next_S <= sm6;
				elsif (U='0' and D='0' and R='1' and L='0') then
					next_S <= sm7;
				else
					next_S <= sm3;
				end if;
				LDP <='0';
				T <= '0';
				K <= '0';
				IM1 <= "10";
				IM2 <= "00";
				IM3 <= '0';
				Soltar <= '0';

			when sm5 => -- estado abajo 5
				--if (ST = '0' or G = '1') then
				if (G = '1') then
					next_S <= sm8;
				elsif (U='1' and D='0' and R='0' and L='0') then
					next_S <= sm4;
				elsif (U='0' and D='1' and R='0' and L='0') then
					next_S <= sm5;
				elsif (U='0' and D='0' and R='0' and L='1') then
					next_S <= sm6;
				elsif (U='0' and D='0' and R='1' and L='0') then
					next_S <= sm7;
				else
					next_S <= sm3;
				end if;
				LDP <='0';
				T <= '0';
				K <= '0';
				IM1 <= "11";
				IM2 <= "00";
				IM3 <= '0';
				Soltar <= '0';

			when sm6 => -- estado izquierda 6
				--if (ST = '0' or G = '1') then
				if (G = '1') then
					next_S <= sm8;
				elsif (U='1' and D='0' and R='0' and L='0') then
					next_S <= sm4;
				elsif (U='0' and D='1' and R='0' and L='0') then
					next_S <= sm5;
				elsif (U='0' and D='0' and R='0' and L='1') then
					next_S <= sm6;
				elsif (U='0' and D='0' and R='1' and L='0') then
					next_S <= sm7;
				else
					next_S <= sm3;
				end if;
				LDP <='0';
				T <= '0';
				K <= '0';
				IM1 <= "00";
				IM2 <= "10";
				IM3 <= '0';
				Soltar <= '0';

			when sm7 => -- estado derecha 7
				--if (ST = '0' or G = '1') then
				if (G = '1') then
					next_S <= sm8;
				elsif (U='1' and D='0' and R='0' and L='0') then
					next_S <= sm4;
				elsif (U='0' and D='1' and R='0' and L='0') then
					next_S <= sm5;
				elsif (U='0' and D='0' and R='0' and L='1') then
					next_S <= sm6;
				elsif (U='0' and D='0' and R='1' and L='0') then
					next_S <= sm7;
				else
					next_S <= sm3;
				end if;
				LDP <='0';
				T <= '0';
				K <= '0';
				IM1 <= "00";
				IM2 <= "11";
				IM3 <= '0';
				Soltar <= '0';

			when sm8 => -- estado inicioR 8
				next_S <= sm9;
				LDP <='0';
				T <= '0';
				K <= '1';
				IM1 <= "00";
				IM2 <= "00";
				IM3 <= '1';
				Soltar <= '0';

			when sm9 => -- estado recolec 9
				if (F3 = '1') then
					next_S <= sm10;
				else
					next_S <= sm9;
				end if;
				LDP <='0';
				T <= '0';
				K <= '0';
				IM1 <= "00";
				IM2 <= "00";
				IM3 <= '0';
				Soltar <= '0';

			when sm10 => -- estado soltando 10
				if (Listo = '1') then
					next_S <= sm0;
				else
					next_S <= sm10;
				end if;
				LDP <='0';
				T <= '0';
				K <= '0';
				IM1 <= "00";
				IM2 <= "00";
				IM3 <= '0';
				Soltar <= '1';
		end case;
	end process; 



end Behavioral;