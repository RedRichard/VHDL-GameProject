library ieee;
use ieee. std_logic_1164.all;
use ieee. std_logic_arith.all;
use ieee. std_logic_unsigned.all;
use ieee.math_real.all;

-- Esta entidad es la encargada de administrar lo que se dibuja de acuerdo a las coordenadas

entity GeneradorVideo is
PORT( control_x:	in integer;
		control_y:	in integer;
		pos_x:	in integer;
		pos_y:	in integer;
		habilitado:	in std_logic;
		clk:		in std_logic;
		rgb: out std_logic_vector(11 downto 0));
end GeneradorVideo;
 
architecture behavioral of GeneradorVideo is
	constant midnight_blue : std_logic_vector(11 downto 0) := x"653";
	constant dark_orchid : std_logic_vector(11 downto 0) := x"225";
begin

	-- Proceso de dibujo. Test: dibujo de un cuadrado entre 10<=x<=60 y 10<=y<=60
	Draw: process(clk, pos_x, pos_y, habilitado, control_y, control_x)
	begin
		if(clk'event and clk = '1') then
			if(habilitado = '1') then
				-- Cuadrado
				if((pos_x >= control_x and pos_x <= 60+control_x) and (pos_y >= control_y and pos_y <= 60+control_y))then
					rgb <= x"F00";
				-- Grid
				elsif (pos_x >= 0 and pos_x <= 2) and (pos_y >= 0 and pos_y <= 400) then
					rgb <= x"FFF";
				elsif (pos_x >= 77 and pos_x <= 81) and (pos_y >= 0 and pos_y <= 400) then
					rgb <= x"FFF";
				elsif (pos_x >= 157 and pos_x <= 161) and (pos_y >= 0 and pos_y <= 400) then
					rgb <= x"FFF";
				elsif (pos_x >= 237 and pos_x <= 241) and (pos_y >= 0 and pos_y <= 400) then
					rgb <= x"FFF";
				elsif (pos_x >= 317 and pos_x <= 321) and (pos_y >= 0 and pos_y <= 400) then
					rgb <= x"FFF";
				elsif (pos_x >= 397 and pos_x <= 401) and (pos_y >= 0 and pos_y <= 400) then
					rgb <= x"FFF";
				elsif (pos_x >= 477 and pos_x <= 481) and (pos_y >= 0 and pos_y <= 400) then
					rgb <= x"FFF";
				elsif (pos_x >= 557 and pos_x <= 561) and (pos_y >= 0 and pos_y <= 400) then
					rgb <= x"FFF";
				elsif (pos_x >= 637 and pos_x <= 639) and (pos_y >= 0 and pos_y <= 400) then
					rgb <= x"FFF";
				else
					rgb <= x"000";
				end if;
			else
				rgb <= x"000";
			end if;
		end if;
	end process;
	
	
end behavioral;