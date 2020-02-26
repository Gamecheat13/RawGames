main()
{
	maps\mp\mp_crash_fx::main();
	maps\mp\_load::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_crash");
	
	setExpFog(500, 3500, .5, 0.5, 0.45, 0);
	VisionSetNaked( "mp_crash" );
	ambientPlay("ambient_middleeast_ext");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["british_soldiertype"] = "normandy";
	game["german_soldiertype"] = "normandy";


	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
/*	
var = 100;

while(1)
	{
		var = var +10;
		setdvar("compassMaxRange", var);
		if (var >5000)
			var = 100;
		wait .05;
	}
*/
}
