main()
{
	level._effect[ "end_smoke" ] 					= loadfx( "smoke/signal_smoke_green" );
	
	// Vehicle Type: Chopper Boss
	level._effect[ "chopper_boss_light_smoke" ] 	= loadfx( "smoke/smoke_trail_white_heli" );
	level._effect[ "chopper_boss_heavy_smoke" ] 	= loadfx( "smoke/smoke_trail_black_heli" );
	level._effect[ "money" ] 						= loadfx( "props/cash_player_drop" );
	
	if ( !getdvarint( "r_reflectionProbeGenerate" ) )
		maps\createfx\so_timetrial_london_fx::main();
}
