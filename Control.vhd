library ieee;
use ieee. std_logic_1164.all;
use ieee. std_logic_arith.all;
use ieee. std_logic_unsigned.all;

entity Control is
PORT( clk:		in std_logic;
		boton_izquierda:in std_logic;
		boton_derecha	:in std_logic;
		boton_arriba	:in std_logic;
		boton_abajo		:in std_logic;
		boton_fire		:in std_logic;
		control_fire	:out std_logic;
		control_x, control_y: out integer);
end Control;
 
architecture behavioral of Control is
	constant max_count: integer := 6000000;
	constant max_horizontal: integer := 580;
	constant max_vertical: integer := 400;
	constant centro_horizontal: integer := 640/2;
	constant centro_vertical: integer := 480/2;
	constant izquierda_horizontal: integer := 9;
	constant izquierda_vertical: integer := 329;
	constant derecha_horizontal: integer := 629;
	constant derecha_vertical: integer := 9;
	signal clk_velocidad: std_logic := '0';
	signal count: integer range 0 to max_count;
	signal pos_y: integer := izquierda_vertical;
	signal pos_x: integer := izquierda_horizontal;
	
	signal allow_fire: std_logic := '0';
begin
	ButtonDisparo: process(boton_fire)
	begin
		if(boton_fire = '0')then
			allow_fire <= '1';
		else
			allow_fire <= '0';
		end if;
	end process;
	
	ClkHz: process(clk, clk_velocidad, count)
	begin
		if(clk'event and clk = '1') then
			if(count < max_count)then
				count <= count + 1;
			else
				clk_velocidad <= not clk_velocidad;
				count <= 0;
			end if;
		end if;
	end process;
	
	Direcciones: process(clk_velocidad, boton_arriba, boton_abajo)
	begin
		if(clk_velocidad'event and clk_velocidad = '1') then
			-- Vertical:
			if(boton_arriba = '1' and pos_y > 79)then
				pos_y <= pos_y - 80;
			elsif(boton_abajo = '1' and pos_y < 319)then
				pos_y <= pos_y + 80;
			end if;
			
			-- Horizontal:
			if(boton_derecha = '1' and pos_x < 559)then
				pos_x <= pos_x + 80;
				pos_y <= pos_y;
			elsif(boton_izquierda = '1' and pos_x > 79)then
				pos_x <= pos_x - 80;
				pos_y <= pos_y;
			elsif(boton_derecha = '1' or boton_izquierda = '1')then
				pos_y <= pos_y;
			end if;
			
			-- Checar limites horizontal:
			if(pos_x > max_horizontal)then
				pos_x <= derecha_horizontal;
			elsif(pos_x < 0)then
				pos_x <= izquierda_horizontal;
			end if;
			
			-- Checar limites vertical:
			if(pos_y > max_vertical)then
				pos_y <= izquierda_vertical;
			elsif(pos_y < 0)then
				pos_y <= derecha_vertical;
			end if;
		end if;
	end process;
	
	control_fire <= allow_fire;
	control_y <= pos_y;
	control_x <= pos_x;
	
end behavioral;