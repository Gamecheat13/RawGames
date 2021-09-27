
main()
{
	maps\mp\mp_mogadishu_precache::main();
	maps\createart\mp_mogadishu_art::main();
	maps\mp\mp_mogadishu_fx::main();
	
	maps\mp\_load::main();

	AmbientPlay( "ambient_mp_mogadishu" );
	maps\mp\_compass::setupMiniMap( "compass_map_mp_mogadishu" );

	game["attackers"] = "allies";
	game["defenders"] = "axis";
	
	//	remove the heli turret in gun and oic
	if ( level.gameType == "oic" || level.gameType == "gun" || level.gameType == "infect" )
	{
		heliTurret = getEnt( "misc_turret", "classname" );
		assert( isDefined( heliTurret ) );
		heliTurret delete();
	}
}