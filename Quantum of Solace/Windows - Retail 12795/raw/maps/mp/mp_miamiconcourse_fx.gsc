main()
{
	// List all the effects you will use in the level:
	//
	// level._effect[ "[name for tool]" ]			 = loadfx( "[name of effect file, without the .efx]" );
	//
	
	level._effect["science_lightbeam01"] 		= loadfx ("maps/miamisciencecenter/science_lightbeam01");
	level._effect["science_lightbeam02"] 		= loadfx ("maps/miamisciencecenter/science_lightbeam02");
	level._effect["science_lightbeam03"] 		= loadfx ("maps/miamisciencecenter/science_lightbeam03");
	level._effect["science_lightbeam04"] 		= loadfx ("maps/miamisciencecenter/science_lightbeam04");
	level._effect["science_lightbeam05"] 		= loadfx ("maps/miamisciencecenter/science_lightbeam05");
	level._effect["science_lightbeam06"] 		= loadfx ("maps/miamisciencecenter/science_lightbeam06");
	level._effect["science_lightbeam07"] 		= loadfx ("maps/miamisciencecenter/science_lightbeam07");
	level._effect["science_lightbeam08"] 		= loadfx ("maps/miamisciencecenter/science_lightbeam08");
	level._effect["science_lightbeam08_s"] 		= loadfx ("maps/miamisciencecenter/science_lightbeam08_s");
	level._effect["science_flashlight_beam"] 	= loadfx ("maps/miamisciencecenter/science_flashlight_beam");
	
	level._effect["science_building_light01"] 		= loadfx ("maps/miamisciencecenter/science_building_light01");
	
	level._effect["science_interior_light01"] 	= loadfx ("maps/miamisciencecenter/science_interior_light01");
	level._effect["science_interior_light02"] 	= loadfx ("maps/miamisciencecenter/science_interior_light02");
	level._effect["science_interior_light03"] 	= loadfx ("maps/miamisciencecenter/science_interior_light03");
	level._effect["science_interior_light04"] 	= loadfx ("maps/miamisciencecenter/science_interior_light04");
	
	level._effect["science_windy_air01"] 		= loadfx ("maps/miamisciencecenter/science_windy_air01");
	level._effect["science_windy_air02"] 		= loadfx ("maps/miamisciencecenter/science_windy_air02");
	level._effect["science_windy_air03"] 		= loadfx ("maps/miamisciencecenter/science_windy_air03");
	level._effect["science_windy_air04"] 		= loadfx ("maps/miamisciencecenter/science_windy_air04");
	
	level._effect["science_steam_vent01"] 		= loadfx ("maps/miamisciencecenter/science_steam_vent01");
	level._effect["science_steam_vent02"] 		= loadfx ("maps/miamisciencecenter/science_steam_vent02");
	level._effect["science_steam_vent03"] 		= loadfx ("maps/miamisciencecenter/science_steam_vent03");
	
	level._effect["science_moths"] 			= loadfx ("maps/miamisciencecenter/science_moths");
	level._effect["science_gnats"] 			= loadfx ("maps/miamisciencecenter/science_gnats");
	level._effect["science_gnats_fiesty"] 		= loadfx ("maps/miamisciencecenter/science_gnats_fiesty");
	level._effect["science_cockroaches"] 		= loadfx ("maps/miamisciencecenter/science_cockroaches");

	level._effect["siena_tunnel_dust1"] 		= loadfx ( "maps/siena/siena_tunnel_dust1" );
	level._effect["siena_tunnel_dust2"] 		= loadfx ( "maps/siena/siena_tunnel_dust2" );
	level._effect["siena_room_dust1"] 		= loadfx ( "maps/siena/siena_room_dust1" );
	level._effect["siena_skylight_dust"]	 	= loadfx ( "maps/siena/siena_skylight_dust");

/#
	if ( getdvar( "clientSideEffects" ) != "1" )	
		maps\createfx\mp_MiamiConcourse_fx::main();
#/
}
