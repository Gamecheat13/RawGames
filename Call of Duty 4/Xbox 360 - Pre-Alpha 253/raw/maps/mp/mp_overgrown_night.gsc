main()
{
	maps\mp\_load::main();

	maps\mp\_compass::setupMiniMap("compass_map_mp_overgrown");

	setExpFog(100, 7000, 0.045, 0.17, 0.2, 0);
	VisionSetNaked( "mp_overgrown" );
	ambientPlay("ambient_middleeast_ext");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["british_soldiertype"] = "normandy";
	game["german_soldiertype"] = "normandy";

	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");


}