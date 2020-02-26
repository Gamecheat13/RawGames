main()
{
	maps\mp\mp_rundown_precache::main();
	maps\mp\mp_rundown_fx::main();
	maps\createart\mp_rundown_art::main();
	maps\mp\_load::main();

	maps\mp\_compass::setupMiniMap( "compass_map_mp_rundown" );

	//setExpFog( 1695, 5200, 0.8, 0.8, 0.8, 0.2, 0 );
	ambientPlay( "ambient_mp_rural" );
	VisionSetNaked( "mp_rundown" );

	game[ "attackers" ] = "axis";
	game[ "defenders" ] = "allies";

	setdvar( "r_specularcolorscale", "1.67" );
	setdvar( "compassmaxrange", "1500" );
}
