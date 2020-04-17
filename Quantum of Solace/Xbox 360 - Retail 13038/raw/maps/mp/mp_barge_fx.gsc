main()
{
	// List all the effects you will use in the level:
	//
	// level._effect[ "[name for tool]" ]			 = loadfx( "[name of effect file, without the .efx]" );
	//

	level._effect["science_windy_air01"] 		= loadfx ("maps/miamisciencecenter/science_windy_air01");
	level._effect["science_windy_air02"] 		= loadfx ("maps/miamisciencecenter/science_windy_air02");
	level._effect["science_windy_air03"] 		= loadfx ("maps/miamisciencecenter/science_windy_air03");
	level._effect["science_windy_air04"] 		= loadfx ("maps/miamisciencecenter/science_windy_air04");

	level._effect["science_steam_vent01"] 		= loadfx ("maps/miamisciencecenter/science_steam_vent01");
	level._effect["science_steam_vent02"] 		= loadfx ("maps/miamisciencecenter/science_steam_vent02");
	level._effect["science_steam_vent03"] 		= loadfx ("maps/miamisciencecenter/science_steam_vent03");

	level._effect["mp_birds_takeoff"] 		= loadfx ( "mp/mp_birds_takeoff" );
	level._effect["siena_room_dust1"] 			= loadfx ( "maps/siena/siena_room_dust1" );
	level._effect["chimney_small"] 			= loadfx ("smoke/chimney_small");

	level._effect["science_lightbeam01"] 		= loadfx ("maps/miamisciencecenter/science_lightbeam01");
	level._effect["science_lightbeam02"] 		= loadfx ("maps/miamisciencecenter/science_lightbeam02");
	level._effect["science_lightbeam03"] 		= loadfx ("maps/miamisciencecenter/science_lightbeam03");
	level._effect["science_lightbeam04"] 		= loadfx ("maps/miamisciencecenter/science_lightbeam04");
	level._effect["science_lightbeam05"] 		= loadfx ("maps/miamisciencecenter/science_lightbeam05");
	level._effect["science_lightbeam06"] 		= loadfx ("maps/miamisciencecenter/science_lightbeam06");
	level._effect["science_lightbeam07"] 		= loadfx ("maps/miamisciencecenter/science_lightbeam07");
	level._effect["science_lightbeam08"] 		= loadfx ("maps/miamisciencecenter/science_lightbeam08");
	level._effect["science_lightbeam08_s"] 		= loadfx ("maps/miamisciencecenter/science_lightbeam08_s");

	level._effect["vol_light01"]        = loadfx ( "maps/barge/barge_vol_light01" ); //06/22opti
	level._effect["vol_light02"]        = loadfx ( "maps/barge/barge_vol_light02" ); //06/22opti
	level._effect["vol_light03"]        = loadfx ( "maps/barge/barge_vol_light03" ); //06/22opti

	level._effect["vol_light05"]        = loadfx ( "maps/barge/barge_vol_light05" ); //06/22opti
	level._effect["vol_light06"]        = loadfx ( "maps/barge/barge_vol_light06" ); //06/22opti


	level._effect["water_spray1"] = loadfx ("maps/venice/gettler_water_spray1");
	level._effect["water_spray2"] = loadfx ("maps/venice/gettler_water_spray2");
	
	// Need looping version
	level._effect["roof_fog2"]	 	= loadfx ("maps/barge/barge_cloud_bank_thin");
	level._effect["mp_fog"]           = loadfx ("mp/mp_fog");

/#
	if ( getdvar( "clientSideEffects" ) != "1" )	
		maps\createfx\mp_barge_fx::main();
#/
}
