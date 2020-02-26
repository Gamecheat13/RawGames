-- object dm_piston_large

--## SERVER
--[[
function dm_piston_large:init()

	local secondsBetweenAnimations = 90.0;
	
	SleepUntil( [| mp_round_started() == true and mp_round_timer_is_paused() == false ], 1 );

	-- continue to loop for this amount of time
	repeat
	
		self:animate( secondsBetweenAnimations, secondsBetweenAnimations );
		
	until false;
	
end

function dm_piston_large:animate( n_down_delay:number, n_up_delay:number )

	local n_down_frame:number = 150;
	local n_max_frame:number = 300;
	local n_target_pos:number = 0.0

	-- animate down
	print( "LARGE PISTON; animating down" );
	n_target_pos = n_down_frame / n_max_frame;
	device_set_power( self, 1 );
	device_set_position( self, n_target_pos );
	
	sleep_s( n_down_delay );

	-- animate down
	print( "LARGE PISTON; animating up" );
	n_target_pos = 1.0;
	device_set_power( self, 1 );
	device_set_position( self, n_target_pos );
	
	sleep_s( n_up_delay );

end
]]--