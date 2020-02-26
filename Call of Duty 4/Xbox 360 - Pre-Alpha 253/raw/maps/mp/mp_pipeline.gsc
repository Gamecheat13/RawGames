main()
{
	maps\mp\mp_pipeline_fx::main();
	maps\mp\_load::main();

	maps\mp\_compass::setupMiniMap("compass_map_mp_pipeline");

	setExpFog(300, 1400, 0.5, 0.5, 0.5, 0);
	ambientPlay("ambient_middleeast_ext");
	VisionSetNaked( "mp_pipeline" );
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