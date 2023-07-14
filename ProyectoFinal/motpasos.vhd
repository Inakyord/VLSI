--===========================================================
--                 Proyecto Final Diseño VLSI
--
-- Nombre proyecto: garraFinal
-- Nombre archivo: motpasos
-- 
-- Función / Descripción: Módulo elaborado en el laboratorio
--    para controlar un motor a pasos indicando su pulso de
--    paso, dirección de giro y modo. Funciona con una máquina
--    de estados.
--
-- Elaborado por: Iñaky Ordiales Caballero
-- Fecha: mayo - junio del 2022.
--===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;


entity MotPasos is
	Port(	paso : in STD_LOGIC; -- pulso de movimiento
			direccion : in STD_LOGIC; -- dirección de giro
			modo : in STD_LOGIC_VECTOR(1 downto 0); -- modo de funcionamiento
			M : out STD_LOGIC_VECTOR(3 downto 0)); -- salida del motor
end MotPasos;


architecture Behavioral of MotPasos is
	
	type estado is (sm0, sm1, sm2, sm3, sm4, sm5, sm6, sm7, sm8, sm9, sm10);
	signal pres_S, next_S : estado;
	signal motor : std_logic_vector(3 downto 0);

begin
	
	process (paso)
	begin
		if paso'event and paso='1' then
			pres_S <= next_S;
		end if;
	end process;
	
	process (pres_S, direccion, modo)
	begin
		case (pres_S) is
			when sm0 =>						-- Estado 0
				next_S <= sm1;
			when sm1 =>						-- Estado 1
				if modo = "00" then
					if direccion = '1' then
						next_S <= sm3;
					else
						next_S <= sm7;
					end if;
				elsif modo = "01" then
					if direccion = '1' then
						next_S <= sm2;
					else
						next_S <= sm8;
					end if;
				elsif modo = "10" then
					if direccion = '1' then
						next_S <= sm2;
					else
						next_S <= sm8;
					end if;
				elsif modo = "11" then
					if direccion = '1' then
						next_S <= sm9;
					else
						next_S <= sm4;
					end if;
				else
					next_S <= sm1;
				end if;
			when sm2 =>						-- Estado 2
				if modo = "00" then
					if direccion = '1' then
						next_S <= sm1;
					else
						next_S <= sm7;
					end if;
				elsif modo = "01" then
					if direccion = '1' then
						next_S <= sm4;
					else
						next_S <= sm8;
					end if;
				elsif modo = "10" then
					if direccion = '1' then
						next_S <= sm3;
					else
						next_S <= sm1;
					end if;
				elsif modo = "11" then
					if direccion = '1' then
						next_S <= sm9;
					else
						next_S <= sm4;
					end if;
				else
					next_S <= sm2;
				end if;
			when sm3 =>						-- Estado 3
				if modo = "00" then
					if direccion = '1' then
						next_S <= sm5;
					else
						next_S <= sm1;
					end if;
				elsif modo = "01" then
					if direccion = '1' then
						next_S <= sm2;
					else
						next_S <= sm8;
					end if;
				elsif modo = "10" then
					if direccion = '1' then
						next_S <= sm4;
					else
						next_S <= sm2;
					end if;
				elsif modo = "11" then
					if direccion = '1' then
						next_S <= sm9;
					else
						next_S <= sm4;
					end if;
				else
					next_S <= sm3;
				end if;
			when sm4 =>						-- Estado 4
				if modo = "00" then
					if direccion = '1' then
						next_S <= sm1;
					else
						next_S <= sm7;
					end if;
				elsif modo = "01" then
					if direccion = '1' then
						next_S <= sm6;
					else
						next_S <= sm2;
					end if;
				elsif modo = "10" then
					if direccion = '1' then
						next_S <= sm5;
					else
						next_S <= sm3;
					end if;
				elsif modo = "11" then
					if direccion = '1' then
						next_S <= sm9;
					else
						next_S <= sm10;
					end if;
				else
					next_S <= sm4;
				end if;
			when sm5 =>						-- Estado 5
				if modo = "00" then
					if direccion = '1' then
						next_S <= sm7;
					else
						next_S <= sm3;
					end if;
				elsif modo = "01" then
					if direccion = '1' then
						next_S <= sm2;
					else
						next_S <= sm8;
					end if;
				elsif modo = "10" then
					if direccion = '1' then
						next_S <= sm6;
					else
						next_S <= sm4;
					end if;
				elsif modo = "11" then
					if direccion = '1' then
						next_S <= sm9;
					else
						next_S <= sm4;
					end if;
				else
					next_S <= sm3;
				end if;
			when sm6 =>						-- Estado 6
				if modo = "00" then
					if direccion = '1' then
						next_S <= sm1;
					else
						next_S <= sm7;
					end if;
				elsif modo = "01" then
					if direccion = '1' then
						next_S <= sm8;
					else
						next_S <= sm4;
					end if;
				elsif modo = "10" then
					if direccion = '1' then
						next_S <= sm7;
					else
						next_S <= sm5;
					end if;
				elsif modo = "11" then
					if direccion = '1' then
						next_S <= sm9;
					else
						next_S <= sm4;
					end if;
				else
					next_S <= sm7;
				end if;
			when sm7 =>						-- Estado 7
				if modo = "00" then
					if direccion = '1' then
						next_S <= sm1;
					else
						next_S <= sm5;
					end if;
				elsif modo = "01" then
					if direccion = '1' then
						next_S <= sm2;
					else
						next_S <= sm8;
					end if;
				elsif modo = "10" then
					if direccion = '1' then
						next_S <= sm8;
					else
						next_S <= sm6;
					end if;
				elsif modo = "11" then
					if direccion = '1' then
						next_S <= sm9;
					else
						next_S <= sm4;
					end if;
				else
					next_S <= sm7;
				end if;
			when sm8 =>						-- Estado 8
				if modo = "00" then
					if direccion = '1' then
						next_S <= sm1;
					else
						next_S <= sm7;
					end if;
				elsif modo = "01" then
					if direccion = '1' then
						next_S <= sm2;
					else
						next_S <= sm6;
					end if;
				elsif modo = "10" then
					if direccion = '1' then
						next_S <= sm1;
					else
						next_S <= sm7;
					end if;
				elsif modo = "11" then
					if direccion = '1' then
						next_S <= sm10;
					else
						next_S <= sm9;
					end if;
				else
					next_S <= sm8;
				end if;
			when sm9 =>						-- Estado 9
				if modo = "00" then
					if direccion = '1' then
						next_S <= sm1;
					else
						next_S <= sm7;
					end if;
				elsif modo = "01" then
					if direccion = '1' then
						next_S <= sm2;
					else
						next_S <= sm8;
					end if;
				elsif modo = "10" then
					if direccion = '1' then
						next_S <= sm1;
					else
						next_S <= sm8;
					end if;
				elsif modo = "11" then
					if direccion = '1' then
						next_S <= sm8;
					else
						next_S <= sm4;
					end if;
				else
					next_S <= sm9;
				end if;
			when sm10 =>						-- Estado 10
				if modo = "00" then
					if direccion = '1' then
						next_S <= sm1;
					else
						next_S <= sm7;
					end if;
				elsif modo = "01" then
					if direccion = '1' then
						next_S <= sm2;
					else
						next_S <= sm8;
					end if;
				elsif modo = "10" then
					if direccion = '1' then
						next_S <= sm1;
					else
						next_S <= sm8;
					end if;
				elsif modo = "11" then
					if direccion = '1' then
						next_S <= sm4;
					else
						next_S <= sm8;
					end if;
				else
					next_S <= sm10;
				end if;
			when others => next_S <= sm0;
		end case;
	end process;
	
	process (pres_S)
	begin
		case pres_S is
			when sm0 => motor <= "0000";
			when sm1 => motor <= "1000";
			when sm2 => motor <= "1100";
			when sm3 => motor <= "0100";
			when sm4 => motor <= "0110";
			when sm5 => motor <= "0010";
			when sm6 => motor <= "0011";
			when sm7 => motor <= "0001";
			when sm8 => motor <= "1001";
			when sm9 => motor <= "1010";
			when sm10 => motor <= "0101";
			when others => motor <= "0000";
		end case;
	end process;
	
	M <= motor;
	
end Behavioral;
			
			