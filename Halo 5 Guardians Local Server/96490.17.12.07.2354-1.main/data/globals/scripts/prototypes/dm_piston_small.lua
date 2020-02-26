-- object dm_piston_small

--## SERVER
function dm_piston_small:init()

	device_set_power( self, 1 );

	device_set_position_track (self, "flaps_in_idle", 1);
	device_set_overlay_track( self, "flaps_in_idle" );
	device_set_position_immediate( self, 1 ) ;
	print ("small piston working");
				
end


