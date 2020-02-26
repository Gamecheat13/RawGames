#include maps\_ambient;

main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_training_ext1";

	level.ambient_reverb["exterior"] = [];
	level.ambient_reverb["exterior"]["priority"] = "snd_enveffectsprio_level";
	level.ambient_reverb["exterior"]["roomtype"] = "alley";
	level.ambient_reverb["exterior"]["drylevel"] = .9;
	level.ambient_reverb["exterior"]["wetlevel"] = .1;
	level.ambient_reverb["exterior"]["fadetime"] = 2;
		
	thread maps\_utility::set_ambient("exterior");

	ambientDelay("exterior", 5.0, 20.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "elm_windgust1",	3.0);
	ambientEvent("exterior", "elm_windgust2",	3.0);
	ambientEvent("exterior", "elm_windgust3",	3.0);
	ambientEvent("exterior", "elm_windgust4",	3.0);
	ambientEvent("exterior", "elm_insect_fly", 3.0);
	ambientEvent("exterior", "elm_helicopter_flyover_med",	1.0);
	ambientEvent("exterior", "elm_jet_flyover_med",	1.0);
	ambientEvent("exterior", "elm_jet_flyover_dist",	1.0);


	ambientEvent("exterior", "null",			0.3);
	
	ambientEventStart("exterior");

	level waittill ("action moment");

	ambientEventStart("action ambient");
}	
	
	