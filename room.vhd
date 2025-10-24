library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity room is
	port(
		clk, reset, photo_enter, photo_exit: in std_logic;
		current_occupancy: out std_logic_vector(7 downto 0);
		set_capacity: in unsigned(7 downto 0);
		max_capacity: out std_logic
	);
end room;

architecture detector_arch of room is 
	signal occupancy: unsigned(7 downto 0) := (others => '0');
	signal max_capacity_int: std_logic := '0';
begin
	process(clk, reset)
	begin
		if reset = '1' then -- reset occupancy and max_capacity to 0
			occupancy <= (others => '0');
            		max_capacity_int <= '0';
		elsif clk'event and clk='1' then
			if max_capacity_int = '0' then -- compute entries / exits or both at the same time
				if (photo_enter = '1' and photo_exit = '1') or (photo_enter = '0' and photo_exit = '0') then
				    occupancy <= occupancy;
				elsif photo_enter = '1' and photo_exit = '0' then
				    occupancy <= occupancy + 1;
				elsif photo_enter = '0' and photo_exit = '1' then
				    if occupancy > 0 then -- check not zero before decrementing
					occupancy <= occupancy - 1;
				    end if;
				end if;
			elsif max_capacity_int = '1' then -- if max capacity attained, can only compute exits
				if photo_enter = '0' and photo_exit = '1' then
					if occupancy > 0 then 
				        	occupancy <= occupancy - 1;
					end if;
				end if;
			end if;

			if occupancy >= set_capacity then -- check capacity limit
				max_capacity_int <= '1';
			else 
				max_capacity_int <= '0';
			end if;
		end if;
	end process;
	
	current_occupancy <= std_logic_vector(occupancy);
	max_capacity <= max_capacity_int;
end detector_arch;
