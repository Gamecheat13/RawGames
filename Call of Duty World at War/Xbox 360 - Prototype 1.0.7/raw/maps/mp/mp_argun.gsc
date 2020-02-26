main()
{
	//maps\mp\mp_argun_fx::main();
	maps\mp\_load::main();
	
	//maps\mp\_compass::setupMiniMap("compass_map_mp_crash");
	
	setExpFog(500, 3500, .2, 0.2, 0.35, 0);
	ambientPlay("ambient_fallujah_ext");

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
