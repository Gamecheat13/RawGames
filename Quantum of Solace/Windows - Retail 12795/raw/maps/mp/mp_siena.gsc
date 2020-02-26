main()
{
	maps\mp\mp_siena_fx::main();
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_map_mp_siena");
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";

	setExpFog(500,6000,0.341,0.529,0.67,0);

	setdvar("compassmaxrange","1500");
	VisionSetNaked( "mp_siena" );
}