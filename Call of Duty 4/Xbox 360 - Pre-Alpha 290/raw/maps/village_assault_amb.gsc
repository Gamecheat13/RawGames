#include maps\_ambient;

main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_village_assault_ext0";
	level.ambient_track ["exterior1"] = "ambient_village_assault_ext1";

	level.ambient_reverb["exterior"] = [];
	level.ambient_reverb["exterior"]["priority"] = "snd_enveffectsprio_level";
	level.ambient_reverb["exterior"]["roomtype"] = "forest";
	level.ambient_reverb["exterior"]["drylevel"] = .9;
	level.ambient_reverb["exterior"]["wetlevel"] = .1;
	level.ambient_reverb["exterior"]["fadetime"] = 2;

	level.ambient_reverb["exterior1"] = [];
	level.ambient_reverb["exterior1"]["priority"] = "snd_enveffectsprio_level";
	level.ambient_reverb["exterior1"]["roomtype"] = "forest";
	level.ambient_reverb["exterior1"]["drylevel"] = .9;
	level.ambient_reverb["exterior1"]["wetlevel"] = .1;
	level.ambient_reverb["exterior1"]["fadetime"] = 2;
		
	thread maps\_utility::set_ambient("exterior1");

	ambientDelay("exterior", 2.0, 8.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "elm_wind_leafy",	12.0);
	ambientEvent("exterior", "elm_anml_wolf",	1.5);
	ambientEvent("exterior", "elm_anml_owl",	2.0);
	ambientEvent("exterior", "elm_anml_nocturnal_birds",	1.0);
	ambientEvent("exterior", "elm_dog",		0.5);
	ambientEvent("exterior", "null",			0.3);

	ambientDelay("exterior1", 2.0, 8.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior1", "elm_wind_leafy",	12.0);
	ambientEvent("exterior1", "elm_anml_wolf",	0.5);
	ambientEvent("exterior1", "elm_anml_owl",	1.0);
	ambientEvent("exterior1", "elm_anml_nocturnal_birds",	0.5);
	ambientEvent("exterior1", "elm_dog",		0.25);
	ambientEvent("exterior1", "elm_jet_flyover_dist",	0.1);
	ambientEvent("exterior1", "elm_explosions_dist",	3.0);
	ambientEvent("exterior1", "elm_gunfire_50cal_dist",	3.0);
	ambientEvent("exterior1", "elm_gunfire_ak47_dist",	3.0);
	ambientEvent("exterior1", "elm_gunfire_m16_dist",	3.0);
	ambientEvent("exterior1", "null",			0.3);


	ambientEventStart("exterior1");

	level waittill ("action moment");

	ambientEventStart("action ambient");
}	
	
	