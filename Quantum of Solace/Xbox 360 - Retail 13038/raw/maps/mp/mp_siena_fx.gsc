main()
{
	// List all the effects you will use in the level:
	//
	// level._effect[ "[name for tool]" ]			 = loadfx( "[name of effect file, without the .efx]" );
	//

level._effect["mp_birds_takeoff"] 		= loadfx ( "mp/mp_birds_takeoff" );
level._effect["venice_insects02"] 		= loadfx ("maps/venice/venice_insects02");
level._effect["siena_dripping02"]	 	= loadfx ( "maps/siena/siena_dripping02");
level._effect["venice_chimney1"] 		= loadfx ("maps/venice/venice_chimney1");
level._effect["chimney_small"] 			= loadfx ("smoke/chimney_small");
level._effect["science_dripping_water02"] 	= loadfx ("maps/miamisciencecenter/science_dripping_water02");
//level._effect["gettler_fountain01"]           = loadfx ("maps/venice/gettler_fountain01");  
//level._effect["gettler_fountain02"]           = loadfx ("maps/venice/gettler_fountain02");     
//level._effect["science_water_floor"] 					= loadfx ("maps/miamisciencecenter/science_water_floor01");
//level._effect["science_drainpipe_water01"] 		= loadfx ("maps/miamisciencecenter/science_drainpipe_water01");
//level._effect["science_drainpipe_water02"] 		= loadfx ("maps/miamisciencecenter/science_drainpipe_water02");
//level._effect["siena_dripping01"]	 		= loadfx ( "maps/siena/siena_dripping01");
//level._effect["siena_tunnel_fog1"] 			= loadfx ( "maps/siena/siena_tunnel_fog1" );
level._effect["siena_dripping01"]	 		= loadfx ( "maps/siena/siena_dripping01");
//level._effect["shanty_windy_trash"]					= loadfx ("maps/shantytown/shanty_windy_trash");
//level._effect["science_dripping_water01"] 		= loadfx ("maps/miamisciencecenter/science_dripping_water01");
//level._effect["siena_water_splash2"]	 	= loadfx ( "maps/siena/siena_water_splash2");


/#
	if ( getdvar( "clientSideEffects" ) != "1" )	
		maps\createfx\mp_siena_fx::main();
#/
}
