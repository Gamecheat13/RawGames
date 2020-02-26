main()
{
	// List all the effects you will use in the level:
	//
	// level._effect[ "[name for tool]" ]			 = loadfx( "[name of effect file, without the .efx]" );
	//

	// Venice Area //
	
	level._effect["gettler_fountain01"] 		= loadfx ("maps/venice/gettler_fountain01");
	level._effect["gettler_fountain02"] 		= loadfx ("maps/venice/gettler_fountain02");		

	level._effect["casino_pool_steam"] 		= loadfx ("maps/casino/casino_pool_steam");
	level._effect["casino_halo_shootable"] 		= loadfx ("maps/casino/casino_halo_shootable");
	
	level._effect["casino_lamp4_glow"]	 	= loadfx ("maps/casino/casino_lamp4_glow");

	level._effect["casino_spa_waterfall"]	 	= loadfx ("maps/casino/casino_spa_waterfall");
	level._effect["casino_ballroom_glass"]	 	= loadfx ("maps/casino/casino_ballroom_glass");

	level._effect["casino_spa_wading"]	 	= loadfx ("maps/casino/casino_spa_wading");

	level._effect["science_interior_light01"] 	= loadfx ("maps/miamisciencecenter/science_interior_light01");
	level._effect["science_interior_light02"] 	= loadfx ("maps/miamisciencecenter/science_interior_light02");
	level._effect["science_interior_light03"] 	= loadfx ("maps/miamisciencecenter/science_interior_light03");
	level._effect["science_interior_light04"] 	= loadfx ("maps/miamisciencecenter/science_interior_light04");

/#
	if ( getdvar( "clientSideEffects" ) != "1" )	
		maps\createfx\mp_sauna_fx::main();
#/
}
