main()
{
	maps\mp\_load::main();

	maps\mp\_compass::setupMiniMap("compass_map_mp_convoy");

	setExpFog(500, 14000, 0.7, 0.6, .4, 0);
//	setcullfog (128, 16000, 1, .8, .4, 0);
	ambientPlay("ambient_middleeast_ext");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["british_soldiertype"] = "normandy";
	game["german_soldiertype"] = "normandy";


	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
}