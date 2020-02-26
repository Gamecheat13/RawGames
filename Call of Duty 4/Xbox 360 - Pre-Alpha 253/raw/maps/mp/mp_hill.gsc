main()
{
	//maps\mp\mp_hill_fx::main();
	maps\mp\_load::main();

	maps\mp\_compass::setupMiniMap("compass_map_mp_hill");

	VisionSetNaked( "mp_hill" );
	ambientPlay("ambient_middleeast_ext");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["british_soldiertype"] = "normandy";
	game["german_soldiertype"] = "normandy";

	//setdvar("r_glowbloomintensity0",".25");
	//setdvar("r_glowbloomintensity1",".25");
	//setdvar("r_glowskybleedintensity0",".3");


}