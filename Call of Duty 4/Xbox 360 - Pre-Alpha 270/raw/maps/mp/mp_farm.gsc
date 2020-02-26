main()
{
	maps\mp\mp_farm_fx::main();
	maps\mp\_load::main();

	maps\mp\_compass::setupMiniMap("compass_map_mp_pipeline");

	setExpFog(300, 1400, 0.5, 0.5, 0.5, 0);
	ambientPlay("ambient_middleeast_ext");
	VisionSetNaked( "mp_farm" );
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";


	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");


}


