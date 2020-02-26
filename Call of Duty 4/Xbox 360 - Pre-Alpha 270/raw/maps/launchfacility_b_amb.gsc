#include maps\_ambient;

main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_launchfacility_b_ext0";

	level.ambient_reverb["exterior"] = [];
	level.ambient_reverb["exterior"]["priority"] = "snd_enveffectsprio_level";
	level.ambient_reverb["exterior"]["roomtype"] = "stoneroom";
	level.ambient_reverb["exterior"]["drylevel"] = .9;
	level.ambient_reverb["exterior"]["wetlevel"] = .3;
	level.ambient_reverb["exterior"]["fadetime"] = 3;
	
	thread maps\_utility::set_ambient("exterior");
		
	ambientDelay("exterior", 3.0, 6.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "elm_explosions_dist",	0.1);
	ambientEvent("exterior", "elm_explosions_med",	0.1);
	ambientEvent("exterior", "elm_artillery_med",	0.1);
	ambientEvent("exterior", "elm_industry",	0.5);
	ambientEvent("exterior", "elm_stress",	0.5);
	ambientEvent("exterior", "null",			1.0);

	ambientEventStart("exterior");

	level waittill ("action moment");

	ambientEventStart("action ambient");
}	
	
	