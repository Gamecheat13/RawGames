main()
{
	//maps\mp\mp_shipment_fx::main();
	maps\mp\_load::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_shipment");
	
	setExpFog(0, 2842, 0.642709, 0.626383, 0.5, 3.0);	
	ambientPlay("ambient_middleeast_ext");
	VisionSetNaked( "bog_b" );

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setdvar("compassmaxrange","1400");

}
