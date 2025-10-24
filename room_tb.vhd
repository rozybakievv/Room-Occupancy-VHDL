library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity room_tb is
end room_tb;

architecture tb_arch of room_tb is 
	-- tb signals
	signal reset, photo_enter, photo_exit: std_logic := '0';
	signal current_occupancy: std_logic_vector(7 downto 0);
	signal set_capacity: unsigned(7 downto 0) := (others => '0');
	signal max_capacity: std_logic := '0';
	signal clk : std_logic := '0';

	-- declare room component
	component room
		port(
			clk, reset, photo_enter, photo_exit: in std_logic;
			current_occupancy: out std_logic_vector(7 downto 0);
			set_capacity: in unsigned(7 downto 0);
			max_capacity: out std_logic
	);
	end component;
begin
	-- instantiate a test room from component
	room_test: room
		port map(
			clk => clk,
			reset => reset,
			photo_enter => photo_enter,
			photo_exit => photo_exit,
			current_occupancy => current_occupancy,
			set_capacity => set_capacity,
			max_capacity => max_capacity
	);

	-- simulate clk
	process
	begin
		wait for 5 ns;
		clk <= not clk;
	end process;
	
	-- simulation process
	process
	begin
		-- initial reset
		reset <= '1'; wait for 10 ns;
		reset <= '0'; wait for 10 ns;

		-- set initial max_capacity to 6
		set_capacity <= to_unsigned(6, 8);
		wait for 10 ns;
		
		-- 7 people enter (max_capacity should become 1, last photo_enter should not be counted)
		for i in 0 to 6 loop
			photo_enter <= '1'; wait for 10 ns;
			photo_enter <= '0'; wait for 10 ns;
		end loop;
		
		-- 2 people leave (max_capacity = 0, occupancy = 4)
		for i in 0 to 1 loop
			photo_exit <= '1'; wait for 10 ns;
			photo_exit <= '0'; wait for 10 ns;
		end loop;

		-- enter and exit simultaneously (max_capacity = 0, occupancy = 4)
		photo_exit <= '1';
		photo_enter <= '1';
		wait for 10 ns;
		photo_exit <= '0';
		photo_enter <= '0';
		wait for 10 ns;
		
		-- 3 people enter 
		for i in 0 to 2 loop
			photo_enter <= '1'; wait for 10 ns;
			photo_enter <= '0'; wait for 10 ns;
		end loop;

		-- test reset (max_capacity = 0, occupancy = 0)
		reset <= '1'; wait for 10 ns;
		reset <= '0'; wait for 10 ns;
		
		-- try to leave when occupancy = 0, should stay 0
		photo_exit <= '1'; wait for 10 ns;
		photo_exit <= '0'; wait for 10 ns;

		-- 3 people enter and set_capacity=3 after 2 person enter, next entry max_capacity should be activated
		for i in 0 to 5 loop
			photo_enter <= '1'; wait for 10 ns;
			photo_enter <= '0'; wait for 10 ns;
			if i = 1 then
 				set_capacity <= to_unsigned(3, 8);
				wait for 10 ns;
			end if;
		end loop;
		
		-- test reset (max_capacity = 0, occupancy = 0)
		reset <= '1'; wait for 10 ns;
		reset <= '0'; wait for 10 ns;

		wait;
	end process;
end tb_arch;
