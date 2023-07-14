--===========================================================
--                 Proyecto Final Diseño VLSI
--
-- Nombre proyecto: garraFinal
-- Nombre archivo: garraFinal
-- 
-- Función / Descripción: sería nuestra entidad principal que
--   usa las entradas y salidas globales del sistema, desde
--   donde se llaman los demás módulos para crear el 
--   funcionamiento deseado.
--
-- Elaborado por: Iñaky Ordiales Caballero
-- Fecha: mayo - junio del 2022.
--===========================================================


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity garraFinal is
	Port(	reloj	: in std_logic; -- 50 MHz reloj tarjeta
			P		: in std_logic; -- P - pagado
			U		: in std_logic; -- U - Up = arriba
			D		: in std_logic; -- D - Down = abajo
			R		: in std_logic; -- R - Right = derecha
			L 		: in std_logic; -- L - Left = izquierda
			I		: in std_logic; -- I - iniciar juego
			G		: in std_logic; -- G - activar garra
			Z		: in std_logic; -- Z - premio ganado
			M1		: out std_logic_vector(3 downto 0) := "0000"; -- motor a pasos 1: eje y
			M2		: out std_logic_vector(3 downto 0) := "0000"; -- motor a pasos 2: eje x
			M3		: out std_logic_vector(3 downto 0) := "0000"; -- motor a pasos 3: eje z
			S		: out std_logic; -- S - servomotor
			U7		: out std_logic_vector(6 downto 0) := "1111111"; -- display unidades
			D7		: out std_logic_vector(6 downto 0) := "1111111"; -- display decenas
			LD		: out std_logic_vector(9 downto 0) := "1111111111"; -- leds decoración
			LDP	: out std_logic := '0';
			LDZ	: out std_logic := '1'); -- led premio ganado
end garraFinal;


architecture Behavioral of garraFinal is

	-- DECLARACIÓN DE LAS ENTIDADES DE LOS MÓDULOS A UTILIZAR

	-- Temporizadores a utilizar:
	Component Timer is
		Port(	clk		: in std_logic;
				start		: in std_logic;
				Tms 		: in std_logic_vector (19 downto 0);
				P			: out std_logic);
	end Component Timer;
	
	Component Timer_especial is
		Port(	clk		: in std_logic;
				start		: in std_logic;
				Tms 		: in std_logic_vector (19 downto 0);
				Kill		: in std_logic;
				P			: out std_logic);
	end Component Timer_especial;
	
	
	-- Módulo de control:
	Component control is
		Port(	reloj	: in std_logic; -- 50 MHz reloj tarjeta
				P		: in std_logic; -- P - pagado
				U		: in std_logic; -- U - Up = arriba
				D		: in std_logic; -- D - Down = abajo
				R		: in std_logic; -- R - Right = derecha
				L 		: in std_logic; -- L - Left = izquierda
				I		: in std_logic; -- I - iniciar juego
				G		: in std_logic; -- G - activar garra
				ST 	: in std_logic; -- ST - temporizador 30s
				F3		: in std_logic; -- F3 - garra en posicion inicial
				Listo	: in std_logic; -- Listo - Servomotor fue abierto
				LDP	: out std_logic;
				T 		: out std_logic :='0'; -- T - iniciar temporizador 30s
				K 		: out std_logic :='0'; -- K - matar temporizador
				IM1	: out std_logic_vector(1 downto 0) :="00"; -- IM1 - inicio y dirección mot1
				IM2	: out std_logic_vector(1 downto 0) :="00"; -- IM2 - inicio y dirección mot2
				IM3	: out std_logic :='0'; -- IM3 - inicio motor 3 bajar
				Soltar: out std_logic :='0'); -- señal al servomotor para abrir garra
	end Component control;
	
	-- Módulo cronómetro:
	Component modCrono is
		Port (	reloj : in std_logic;
				ST 	: in std_logic;  -- señal de pulso para la cuenta
				UB	: out std_logic_vector(3 downto 0);  -- unidades en binario de cuenta
				DB	: out std_logic_vector(3 downto 0);  -- decenas en binario de cuenta
				C 	: out std_logic_vector(4 downto 0)); -- cuenta del 30 al 0 en binario
	end Component modCrono;
	
	-- Módulo motor 1:
	Component motor1 is
		Port(	reloj	: in std_logic;
				IM1		: in std_logic_vector(1 downto 0);
				F2		: in std_logic;
				F3		: out std_logic;
				M1 		: out std_logic_vector(3 downto 0));
	end Component motor1;
	
	-- Módulo motor 2:
	Component motor2 is
		Port(	reloj	: in std_logic;
				IM2		: in std_logic_vector(1 downto 0);
				F		: in std_logic;
				F2		: out std_logic;
				M2 		: out std_logic_vector(3 downto 0));
	end Component motor2;
	
	-- Módulo motor 3:
	Component motor3 is
		Port(	reloj	: in std_logic;
				IM3		: in std_logic;
				FS		: in std_logic;
				F		: out std_logic;
				ISE 	: out std_logic;
				M3 		: out std_logic_vector(3 downto 0));
	end Component motor3;
	
	-- Módulo servomotor:
	Component modServo is
		Port (	reloj		: in std_logic;
					ISE	 	: in std_logic;
					Soltar	: in std_logic;
					FS			: out std_logic;
					Listo	: out std_logic;
					S 			: out std_logic);
	end Component modServo;
	
	-- Módulo control de leds:
	Component modLeds is
		Port (	reloj : in std_logic;
				C 	: in std_logic_vector(4 downto 0);  -- señal de pulso para la cuenta
				LD 	: out std_logic_vector(9 downto 0));
	end Component modLeds;

	-- Servomotor
	Component Servomotor is
		Port(	clk : in std_logic;
				posicion : in std_logic_vector (6 downto 0);
				control : out std_logic);
	end Component Servomotor;

  -- declaración de señales internas para conectar los módulos
  
  signal T 		: std_logic; -- inicio temporizador 30s
  signal K 		: std_logic; -- mata (apaga) temporizador 30s
  signal ST		: std_logic; -- señal temporizador 30s
  signal ST2		: std_logic; -- señal temporizador 5s
  signal UB 	: std_logic_vector(3 downto 0); -- unidades en binario -cron
  signal DB 	: std_logic_vector(3 downto 0); -- decenas en binario -cron
  signal C		: std_logic_vector(4 downto 0); -- cuenta en binario -cron
  signal IM1	: std_logic_vector(1 downto 0); -- motor 1, inicio y direccion
  signal IM2	: std_logic_vector(1 downto 0); -- motor 2, inicio y direccion
  signal IM3aux	: std_logic; -- motor 3, inicio - bajar pinza
  signal IM3	: std_logic; -- motor 3, inicio - bajar pinza
  signal Soltar : std_logic; -- servomotor, abrir pinza
  signal Listo	: std_logic; -- servomotor, indica pinza abierta
  signal ISE	: std_logic; -- servomotor, cerrar pinza
  signal FSaux	: std_logic; -- servomotor, indica pinza cerrada
  signal FS		: std_logic; -- servomotor, indica pinza cerrada
  signal F		: std_logic; -- indica motor 3 listo, ya alzó pinza
  signal F2		: std_logic; -- indica motor 2 listo, posición inicio
  signal F3		: std_logic; -- indica motor 1 listo, posición inicio
  
  -- Constantes de tiempo temporizadores
  constant CT1 : std_logic_vector(19 downto 0) := "00000111010100110000";
  constant CT2 : std_logic_vector(19 downto 0) := "00000001001110001000";
  constant CT3 : std_logic_vector(19 downto 0) := "00000011011110001000";



begin

	-- Declaración uso de modulos/componentes
	Timer1 : Timer_especial port map (reloj, T, CT1, K, ST);
	Timer2 : Timer port map (reloj, Z, CT2, ST2); -- temporizador de 5 segundos, led premio ganado
	Timer3 : Timer port map (reloj, IM3aux, CT3, IM3);
	Timer4 : Timer port map (reloj, FSaux, CT3, FS);
	ModControl : Control port map(reloj, P,U,D,R,L,I,G,ST,F3,Listo,LDP,T,K,IM1,IM2,IM3aux,Soltar);
	ModCronom : modCrono port map(reloj, ST, UB, DB, C);
	ModLDS : modLeds port map(reloj, C, LD);
	ModMotor1 : motor1 port map(reloj, IM1, F2, F3, M1);
	ModMotor2 : motor2 port map(reloj, IM2, F, F2, M2);
	ModMotor3 : motor3 port map(reloj, IM3, FS, F, ISE, M3);
	Modservomot : modservo port map(reloj, ISE, Soltar, FSaux, Listo, S);


	-- Decodificador salida display 7 segmentos unidades
	with UB select
		U7 <=	"1000000" when "0000",	--0
				"1111001" when "0001",	--1
				"0100100" when "0010",	--2
				"0110000" when "0011",	--3
				"0011001" when "0100",	--4
				"0010010" when "0101",	--5
				"0000010" when "0110",	--6
				"1111000" when "0111",	--7
				"0000000" when "1000",	--8
				"0010000" when "1001",	--9
				"1000000" when others;
				
	-- Decodificador salida display 7 segmentos decenas
	with DB select
		D7 <=	"1000000" when "0000",	--0
				"1111001" when "0001",	--1
				"0100100" when "0010",	--2
				"0110000" when "0011",	--3
				"0011001" when "0100",	--4
				"0010010" when "0101",	--5
				"0000010" when "0110",	--6
				"1111000" when "0111",	--7
				"0000000" when "1000",	--8
				"0010000" when "1001",	--9
				"1000000" when others;
	
	-- salida led premio ganado
   LDZ <= ST2;

end Behavioral;


