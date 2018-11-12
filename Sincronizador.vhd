library ieee;
use ieee. std_logic_1164.all;
use ieee. std_logic_arith.all;
use ieee. std_logic_unsigned.all;
 
entity Sincronizador is
PORT( clk: 		in std_logic;
		reset: 	in std_logic;
		pos_x:	out integer;
		pos_y: 	out integer;
		habilitado:	out std_logic;
		a_clk:	out std_logic;
		hsync:	out std_logic;
		vsync:	out std_logic);
end Sincronizador;
 
architecture behavioral of Sincronizador is
	signal clk25 : std_logic := '0';
	
	-- Constantes horizontales
	constant HD: integer := 639;		-- Resolución horizontal (640)
	constant HFP : integer := 16;		-- Horizontal Front Porch
	constant HSP : integer := 96;		-- Horizontal Sync Pulse
	constant HBP : integer := 48;		-- Horizontal Back Porch
	
	-- Constantes verticales
	constant VD : integer := 479;		-- Resolución vertical (480)
	constant VFP : integer := 10;		-- Vertical Front Porch
	constant VSP : integer := 2;		-- Vertical Sync Pulse
	constant VBP : integer := 33;		-- Vertical Back Porch
	
	signal hPos : integer := 0;		-- Contador horizontal
	signal vPos : integer := 0;		-- Contador vertical
	
	signal vid : std_logic := '0';

begin
	-- Divisor de frecuencia de 50Mhz a 25Mhz
	clk_div: process(clk)
	begin
		if(clk'event and clk = '1') then
			clk25 <= not clk25;
		end if;
	end process;
	
	-- Contador de horizontal (Toma en cuenta resolución, sync pulse y porchs)
	Horizontal: process(clk25, reset)
	begin
		if(reset = '0') then
			hPos <= 0;
		elsif(clk25'event and clk25 = '1') then
			if (hPos = HD + HFP + HSP + HBP) then
				hPos <= 0;
			else
				hPos <= hPos + 1;
			end if;
		end if;
	end process;
	
	-- Contador de vertical (Toma en cuenta resolución, sync pulse y porchs)
	Vertical: process(clk25, reset, hPos)
	begin
		if(reset = '0') then
			vPos <= 0;
		elsif(clk25'event and clk25 = '1') then
			if (hPos = HD + HFP + HSP + HBP) then
				if (vPos = VD + VFP + VSP + VBP) then
					vPos <= 0;	
				else
					vPos <= vPos + 1;
				end if;
			end if;
		end if;
	end process;
	
	-- Pulso del Sync Horizontal
	Horizontal_Sync: process(clk25, reset, hPos)
	begin
		if(reset = '0') then
			hSync <= '0';
		elsif(clk25'event and clk25 = '1') then
			if ((hPos <= HD + HFP) or (hPos > HD + HFP + HSP)) then
				hSync <= '1';
			else
				hSync <= '0';
			end if;
		end if;
	end process;
	
	-- Pulso del Sync Vertical
	Vertical_Sync: process(clk25, reset, vPos)
	begin
		if(reset = '0') then
			vSync <= '0';
		elsif(clk25'event and clk25 = '1') then
			if ((vPos <= VD + VFP) or (vPos > VD + VFP + VSP)) then
				vSync <= '1';
			else
				vSync <= '0';
			end if;
		end if;
	end process;
	
	-- Confirmar que se encuentra en el area de dibujo indicada:
	-- Lo que hace es verificar que el contador vertical y horizontal se encuentren dentro
	-- de los límites de nuestra resolución seleccionada desde las constantes.
	Video: process(clk25, reset, hPos, vPos)
	begin
		if(reset = '0') then
			vid <= '0';
		elsif(clk25'event and clk25 = '1') then
			if (hPos <= HD and vPos <= VD) then
				vid <= '1';
			else
				vid <= '0';
			end if;
		end if;
	end process;	
	
	habilitado <= vid;
	pos_x <= hPos;
	pos_y <= vPos;
	a_clk <= clk25;
	
end behavioral;