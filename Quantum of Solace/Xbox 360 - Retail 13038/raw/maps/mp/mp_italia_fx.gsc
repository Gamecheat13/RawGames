main()
{
	// List all the effects you will use in the level:
	//
	// level._effect[ "[name for tool]" ]			 = loadfx( "[name of effect file, without the .efx]" );
	//


level._effect["mp_birds_takeoff"] 		= loadfx ( "mp/mp_birds_takeoff" );
level._effect["siena_room_dust1"] 			= loadfx ( "maps/siena/siena_room_dust1" );
level._effect["venice_floating_trash1"] 	= loadfx ("maps/venice/venice_floating_trash1");
level._effect["venice_floating_trash2"] 	= loadfx ("maps/venice/venice_floating_trash2");
level._effect["chimney_small"] 			= loadfx ("smoke/chimney_small");
level._effect["science_lightbeam01"] 		= loadfx ("maps/miamisciencecenter/science_lightbeam01");
level._effect["science_lightbeam02"] 		= loadfx ("maps/miamisciencecenter/science_lightbeam02");
level._effect["vol_light01"]        = loadfx ( "maps/barge/barge_vol_light01" ); //06/22opti
	level._effect["vol_light02"]        = loadfx ( "maps/barge/barge_vol_light02" ); //06/22opti
	level._effect["vol_light03"]        = loadfx ( "maps/barge/barge_vol_light03" ); //06/22opti

	level._effect["vol_light05"]        = loadfx ( "maps/barge/barge_vol_light05" ); //06/22opti
	level._effect["vol_light06"]        = loadfx ( "maps/barge/barge_vol_light06" ); //06/22opti


/#
	if ( getdvar( "clientSideEffects" ) != "1" )	
		maps\createfx\mp_italia_fx::main();
#/
}
