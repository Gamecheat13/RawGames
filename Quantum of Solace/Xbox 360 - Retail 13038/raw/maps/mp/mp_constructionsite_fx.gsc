main()
{
	// List all the effects you will use in the level:
	//
	// level._effect[ "[name for tool]" ]			 = loadfx( "[name of effect file, without the .efx]" );
	//



	level._effect["gettler_dusty_air03"] 		= loadfx ("maps/venice/gettler_dusty_air03");
	level._effect["siena_room_dust1"] 			= loadfx ( "maps/siena/siena_room_dust1" );
	level._effect["siena_tunnel_fog1"] 			= loadfx ( "maps/siena/siena_tunnel_fog1" );
	level._effect["fxsteamvent2"] 	= loadfx ( "maps/constructionsite/const_steamventing2" );
	level._effect["mp_birds_takeoff"] 		= loadfx ( "mp/mp_birds_takeoff" );
	level._effect["dust_wind_slow_yel_loop"] 	= loadfx ("dust/dust_wind_slow_yel_loop");
/#
	if ( getdvar( "clientSideEffects" ) != "1" )	
		maps\createfx\mp_constructionsite_fx::main();
#/
}
