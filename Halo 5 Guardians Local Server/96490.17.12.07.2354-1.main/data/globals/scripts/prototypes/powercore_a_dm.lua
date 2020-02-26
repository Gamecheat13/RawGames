-- object powercore_a_dm

--## SERVER

function powercore_a_dm:init()
	while(true) do

		SleepUntil( [|device_get_position(self) <= 0.1], 1 );
		object_cannot_take_damage(self);
		
		SleepUntil( [|device_get_position(self) > 0.1], 1 );
		object_can_take_damage(self);

	end

end