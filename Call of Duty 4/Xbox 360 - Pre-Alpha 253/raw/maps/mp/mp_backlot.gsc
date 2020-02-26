main()
{
	maps\mp\mp_backlot_fx::main();
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_map_mp_backlot");

	setExpFog(100, 3500, .5, 0.5, 0.45, 0);
	VisionSetNaked( "bog_b" );
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