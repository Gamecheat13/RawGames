#include maps\_ambient;

main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_hunted_ext1";

	level.ambient_reverb["exterior"] = [];
	level.ambient_reverb["exterior"]["priority"] = "snd_enveffectsprio_level";
	level.ambient_reverb["exterior"]["roomtype"] = "forest";
	level.ambient_reverb["exterior"]["drylevel"] = .9;
	level.ambient_reverb["exterior"]["wetlevel"] = .1;
	level.ambient_reverb["exterior"]["fadetime"] = 2;
		
	thread maps\_utility::set_ambient("exterior");

	ambientDelay("exterior", 2.0, 8.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "elm_wind_leafy",	12.0);
	ambientEvent("exterior", "elm_anml_wolf",	1.5);
	ambientEvent("exterior", "elm_anml_owl",	2.0);
	ambientEvent("exterior", "elm_anml_nocturnal_birds",	1.0);
	ambientEvent("exterior", "elm_dog",		0.5);


	ambientEvent("exterior", "null",			0.3);
	
	ambientEventStart("exterior");

	level waittill ("action moment");

	ambientEventStart("action ambient");
}	
	
	
