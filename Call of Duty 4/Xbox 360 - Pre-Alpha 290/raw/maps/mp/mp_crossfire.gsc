main()
{
	//maps\mp\mp_crossfire_fx::main();
	maps\mp\_load::main();

	maps\mp\_compass::setupMiniMap("compass_map_mp_crossfire");

	VisionSetNaked( "mp_crossfire" );
	ambientPlay("ambient_crossfire");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	//setdvar("r_glowbloomintensity0",".25");
	//setdvar("r_glowbloomintensity1",".25");
	//setdvar("r_glowskybleedintensity0",".3");


}