main()
{
	maps\mp\mp_strike_fx::main();
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_map_mp_strike");

	//setExpFog(250, 2700, .90625, 0.850225, 0.71311, 0);
//	setExpFog(0, 7000, 168/255, 158/255, 135/255, 3.0);	
	ambientPlay("ambient_middleeast_ext");
//	VisionSetNaked( "bog_b" );

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["british_soldiertype"] = "normandy";
	game["german_soldiertype"] = "normandy";


	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");

}