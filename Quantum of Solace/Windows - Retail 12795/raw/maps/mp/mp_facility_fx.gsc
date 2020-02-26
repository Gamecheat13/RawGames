main()
{
	// List all the effects you will use in the level:
	//
	// level._effect[ "[name for tool]" ]			 = loadfx( "[name of effect file, without the .efx]" );
	//



	level._effect["siena_room_dust1"] 			= loadfx ( "maps/siena/siena_room_dust1" );
	level._effect["siena_dripping02"]	 		= loadfx ( "maps/siena/siena_dripping02");
	level._effect["siena_dripping01"]	 		= loadfx ( "maps/siena/siena_dripping01");
	level._effect["fxsteamvent2"] 				= loadfx ( "maps/constructionsite/const_steamventing2" );
	level._effect["science_steam_vent01"] 			= loadfx ("maps/miamisciencecenter/science_steam_vent01");	
	level._effect["science_dripping_water02"] 		= loadfx ("maps/miamisciencecenter/science_dripping_water02");
	level._effect["science_water_floor"] 			= loadfx ("maps/miamisciencecenter/science_water_floor01");
	level._effect["facility_water_drip"]	 		= loadfx ( "mp/mp_facility_water_drip");
	level._effect["facility_waterfall"]	 		= loadfx ( "mp/mp_facility_waterfall");



/#
	if ( getdvar( "clientSideEffects" ) != "1" )	
		maps\createfx\mp_facility_fx::main();
#/
}
