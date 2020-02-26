main()
{
	// List all the effects you will use in the level:
	//
	// level._effect[ "[name for tool]" ]			 = loadfx( "[name of effect file, without the .efx]" );
	//


level._effect["mp_birds_takeoff"] 		= loadfx ( "mp/mp_birds_takeoff" );
level._effect["venice_insects02"] 		= loadfx ("maps/venice/venice_insects02");
level._effect["gettler_dusty_air03"] 		= loadfx ("maps/venice/gettler_dusty_air03");
level._effect["siena_room_dust1"] 			= loadfx ( "maps/siena/siena_room_dust1" );
level._effect["siena_dripping02"]	 		= loadfx ( "maps/siena/siena_dripping02");
level._effect["siena_dripping01"]	 		= loadfx ( "maps/siena/siena_dripping01");
level._effect["fxdusthaze1"] 	= loadfx ( "maps/constructionsite/const_dusthaze1" );
level._effect["venice_insects01"] 			= loadfx ("maps/venice/venice_insects01");
	level._effect["venice_insects02"] 			= loadfx ("maps/venice/venice_insects02");
	level._effect["venice_insects03"] 			= loadfx ("maps/venice/venice_insects03");
	level._effect["venice_insects04"] 			= loadfx ("maps/venice/venice_insects04");
	
	//level._effect["fxsteamvent2"] 			= loadfx ( "maps/constructionsite/const_steamventing2" );
	//Make LOOPlevel._effect["venice_birds_flying01"] 		= loadfx ("maps/venice/venice_birds_flying01");
	//level._effect["venice_cloud_whisp01"] 		= loadfx ("maps/venice/venice_cloud_whisp01");
	//level._effect["venice_cloud_whisp02"] 		= loadfx ("maps/venice/venice_cloud_whisp02");
	//level._effect["venice_cloud_whisp03"] 		= loadfx ("maps/venice/venice_cloud_whisp03");
	//level._effect["venice_chimney1"] 		= loadfx ("maps/venice/venice_chimney1");
	//level._effect["venice_floating_trash1"] 	= loadfx ("maps/venice/venice_floating_trash1");
	//level._effect["venice_floating_trash2"] 	= loadfx ("maps/venice/venice_floating_trash2");
	//level._effect["dust_wind_slow_yel_loop"] 	= loadfx ("dust/dust_wind_slow_yel_loop");
	//Make Looplevel._effect["dust_wnd_slw_lp_mpcrash_fld"] 	= loadfx ("dust/dust_wnd_slw_lp_mpcrash_fld");
	//Make Looplevel._effect["insects_light_flies"] 		= loadfx ("misc/insects_light_flies");
	//level._effect["chimney_small"] 			= loadfx ("smoke/chimney_small");
	//Make Looplevel._effect["thin_light_smoke_S"] 		= loadfx ("smoke/thin_light_smoke_S");
	//level._effect["siena_tunnel_fog1"] 			= loadfx ( "maps/siena/siena_tunnel_fog1" );
	//level._effect["siena_dripping01"]	 		= loadfx ( "maps/siena/siena_dripping01");
	//Make LOOPlevel._effect["siena_water_splash1"]	 	= loadfx ( "maps/siena/siena_water_splash1");
	//level._effect["siena_water_splash2"]	 	= loadfx ( "maps/siena/siena_water_splash2");
	//level._effect["Shanty_dustywind"]						= loadfx ("maps/shantytown/Shanty_dustywind");
	//level._effect["shanty_windy_trash"]					= loadfx ("maps/shantytown/shanty_windy_trash");
	//MakeLOOPlevel._effect["shanty_windy_dust1"]					= loadfx ("maps/shantytown/shanty_windy_dust01");	
	//level._effect["science_steam_vent01"] 				= loadfx ("maps/miamisciencecenter/science_steam_vent01");	
	//level._effect["science_dripping_water01"] 		= loadfx ("maps/miamisciencecenter/science_dripping_water01");
	//level._effect["science_dripping_water02"] 		= loadfx ("maps/miamisciencecenter/science_dripping_water02");
	//level._effect["science_water_floor"] 					= loadfx ("maps/miamisciencecenter/science_water_floor01");
	//MAKE LOOPlevel._effect["science_cockroaches"] 					= loadfx ("maps/miamisciencecenter/science_cockroaches");
	//level._effect["science_drainpipe_water01"] 		= loadfx ("maps/miamisciencecenter/science_drainpipe_water01");
	//level._effect["science_drainpipe_water02"] 		= loadfx ("maps/miamisciencecenter/science_drainpipe_water02");








	 					


/#
	if ( getdvar( "clientSideEffects" ) != "1" )	
		maps\createfx\mp_embassy_fx::main();
#/
}
