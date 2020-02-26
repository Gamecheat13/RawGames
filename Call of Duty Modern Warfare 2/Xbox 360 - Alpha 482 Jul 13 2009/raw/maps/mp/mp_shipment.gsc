main()
{
	maps\mp\mp_shipment_precache::main();
	maps\mp\mp_shipment_fx::main();
	maps\createart\mp_shipment_art::main();
	maps\mp\_load::main();

	maps\mp\_compass::setupMiniMap( "compass_map_mp_shipment" );

	ambientPlay( "ambient_mp_rural" );

	game[ "attackers" ] = "axis";
	game[ "defenders" ] = "allies";

	setdvar( "r_specularcolorscale", "1" );
	setdvar( "compassmaxrange", "1400" );
}
