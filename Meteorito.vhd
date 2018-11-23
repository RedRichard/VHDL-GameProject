library ieee;
use ieee. std_logic_1164.all;
use ieee. std_logic_arith.all;
use ieee. std_logic_unsigned.all;
 
entity Meteorito is
PORT( clk: 		in std_logic;
		num_met:			in integer;
		max_c_meteor:	in integer;
		posx_met_der:			in	integer;
		posx_met_izq:			in integer;
		posy_met_inferior:	in integer;
		posy_nave_superior:	in integer;
		posy_nave_inferior:	in integer;
		posy_proyectil_superior:	in integer;
		posx_proyectil_izq:			in integer;
		posx_proyectil_der:			in integer;
		carril_nave:			in integer range 1 to 8;
		allow_fire:				in std_logic;
		aux_vida:				out std_logic;
		
		
		met_exists:				out std_logic;
		c_meteor:			out integer
	
	);
end Meteorito;
 
architecture behavioral of Meteorito is
	constant max_m_meteor: integer := 420;		-- posicion mayima en 'y' del meteorito
	signal count_c_meteor: integer := 0;		-- contador de avance en reloj
	signal clk_met: std_logic := '0';			-- reloj de velocidad de movimiento. Indica cuando avanzar un pixel.
	signal count_meteor: integer := 0;			-- contador de avance en posicion 'y'
	signal met1_exists: std_logic := '1';		-- indica si existe el meteorito o no
	signal met1_hit: std_logic := '0'; 			-- indica si el meteorito ha golpeado al jugador o no


begin
	ClkMeteor: process(clk)
	begin
		if(clk'event and clk='1')then
			if(count_c_meteor < max_c_meteor)then
				count_c_meteor <= count_c_meteor + 1;
			else
				clk_met <= not clk_met;
				count_c_meteor <= 0;
			end if;
		end if;
	end process;
	
	MeteorMovement: process(clk_met, count_meteor)
	begin
		if(clk_met'event and clk_met = '1')then
			-- if((posy_nave_superior = count_meteor+60) or (posy_nave_superior = count_meteor+30) or (posy_nave_superior = count_meteor) or (posy_nave_inferior = count_meteor + 60) or (posy_nave_inferior = count_meteor + 30) or (posy_nave_inferior = count_meteor)) and (carril_nave = 1) and (met1_exists = '1')then
			if((posy_nave_superior <= count_meteor + posy_met_inferior and posy_nave_superior >= count_meteor - 60 + posy_met_inferior) or (posy_nave_inferior <= count_meteor + posy_met_inferior and posy_nave_inferior >= count_meteor - 60 + posy_met_inferior))and (num_met = carril_nave) and (met1_exists = '1')then	
				--vida <= vida - 1; 	-- Aqui quitamos vida cuando se detecta colisión de meteorito
				met1_hit <= '1';
			-- Aquí se destruye el meteorito si choca un proyectil
			elsif (allow_fire = '1') and (posy_proyectil_superior <= posy_met_inferior) and (posx_proyectil_izq >= posx_met_izq and posx_proyectil_der <= posx_met_der) then
				met1_exists <= '0';
				--puntuacion <= puntuacion + 1;
			-- Aquí se reinstancia el meteorito después de que se alcanza el límite de la variable count_meteor 
			--elsif (met1_exists = '0') and (count_meteor = max_m_meteor) then
			elsif (met1_exists = '0') then				
				met1_exists <= '1';
				count_meteor <= 0;
			end if;
			--if(count_meteor < max_m_meteor) and ((met1_hit = '0') or (met1_exists = '0')) then
			if(count_meteor < max_m_meteor + 120) and (met1_hit = '0') and (met1_exists = '1') then
				count_meteor <= count_meteor + 1;
			else
				count_meteor <= 0;				-- Posición de reinstanciación
				met1_hit <= '0';
			end if;
		end if;
	end process;
	
	aux_vida <= met1_hit;
	met_exists <= met1_exists;		-- Enviar condición de existencia
	c_meteor <= count_meteor;
end behavioral;