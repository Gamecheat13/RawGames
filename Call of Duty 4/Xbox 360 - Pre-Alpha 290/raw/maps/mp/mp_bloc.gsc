main()
{
	maps\mp\mp_bloc_fx::main();
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_map_mp_bloc");

	setExpFog(100, 3500, .5, 0.5, 0.45, 0);
	VisionSetNaked( "mp_bloc" );
	ambientPlay("ambient_middleeast_ext");

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");


}