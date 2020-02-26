main()
{
	
	maps\mp\mp_brecourt_precache::main();	
	maps\mp\mp_brecourt_fx::main();
	maps\createart\mp_brecourt_art::main();
	maps\mp\_load::main();

	maps\mp\_compass::setupMiniMap( "compass_map_mp_brecourt" );

	ambientPlay( "ambient_mp_rural" );

	game[ "attackers" ] = "allies";
	game[ "defenders" ] = "axis";

	setdvar( "r_specularcolorscale", "1" );

	setdvar( "compassmaxrange", "2000" );
	
	setdvar( "sm_sunShadowScale", 0.5 );
}