
main()
{
	maps\mp\mp_docks_fx::main();
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_map_mp_docks");
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	setdvar("compassmaxrange","1500");
	setdvar("r_godraysPosX2",  "11.2969");
	setdvar("r_godraysPosY2",  "-19.7254");
	VisionSetNaked( "mp_docks" );
}