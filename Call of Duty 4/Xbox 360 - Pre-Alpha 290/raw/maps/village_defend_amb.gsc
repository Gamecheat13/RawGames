#include maps\_ambient;

main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior0"] = "ambient_village_defend_ext0";
	level.ambient_track ["exterior3"] = "ambient_village_defend_ext3";
	level.ambient_track ["exterior4"] = "ambient_village_defend_ext4";
	level.ambient_track ["exterior5"] = "ambient_village_defend_ext5";

	level.ambient_reverb["exterior0"] = [];
	level.ambient_reverb["exterior0"]["priority"] = "snd_enveffectsprio_level";
	level.ambient_reverb["exterior0"]["roomtype"] = "forest";
	level.ambient_reverb["exterior0"]["drylevel"] = .9;
	level.ambient_reverb["exterior0"]["wetlevel"] = .1;
	level.ambient_reverb["exterior0"]["fadetime"] = 2;

	level.ambient_reverb["exterior3"] = [];
	level.ambient_reverb["exterior3"]["priority"] = "snd_enveffectsprio_level";
	level.ambient_reverb["exterior3"]["roomtype"] = "forest";
	level.ambient_reverb["exterior3"]["drylevel"] = .9;
	level.ambient_reverb["exterior3"]["wetlevel"] = .1;
	level.ambient_reverb["exterior3"]["fadetime"] = 2;

	level.ambient_reverb["exterior4"] = [];
	level.ambient_reverb["exterior4"]["priority"] = "snd_enveffectsprio_level";
	level.ambient_reverb["exterior4"]["roomtype"] = "forest";
	level.ambient_reverb["exterior4"]["drylevel"] = .9;
	level.ambient_reverb["exterior4"]["wetlevel"] = .1;
	level.ambient_reverb["exterior4"]["fadetime"] = 2;

	level.ambient_reverb["exterior5"] = [];
	level.ambient_reverb["exterior5"]["priority"] = "snd_enveffectsprio_level";
	level.ambient_reverb["exterior5"]["roomtype"] = "forest";
	level.ambient_reverb["exterior5"]["drylevel"] = .9;
	level.ambient_reverb["exterior5"]["wetlevel"] = .1;
	level.ambient_reverb["exterior5"]["fadetime"] = 2;

		
	thread maps\_utility::set_ambient("exterior3");

	ambientDelay("exterior0", 2.0, 8.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior0", "elm_wind_leafy",	12.0);
	ambientEvent("exterior0", "null",		0.3);


	ambientDelay("exterior3", 2.0, 8.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior3", "elm_wind_leafy",	12.0);
	ambientEvent("exterior3", "elm_jet_flyover_dist",	1.0);
	ambientEvent("exterior3", "elm_explosions_dist",	3.0);
	ambientEvent("exterior3", "elm_gunfire_50cal_dist",	3.0);
	ambientEvent("exterior3", "elm_gunfire_ak47_dist",	3.0);
	ambientEvent("exterior3", "elm_gunfire_m16_dist",	3.0);
	ambientEvent("exterior3", "null",			0.3);


	ambientDelay("exterior4", 2.0, 8.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior4", "elm_wind_leafy",	6.0);
	ambientEvent("exterior4", "elm_helicopter_flyover_med",	2.0);
	ambientEvent("exterior4", "elm_jet_flyover_med",	1.0);
	ambientEvent("exterior4", "elm_jet_flyover_dist",	1.0);
	ambientEvent("exterior4", "elm_explosions_dist",	3.0);
	ambientEvent("exterior4", "elm_explosions_med",	3.0);
	ambientEvent("exterior4", "elm_gunfire_50cal_dist",	3.0);
	ambientEvent("exterior4", "elm_gunfire_50cal_med",	3.0);
	ambientEvent("exterior4", "elm_gunfire_ak47_dist",	3.0);
	ambientEvent("exterior4", "elm_gunfire_ak47_med",	3.0);
	ambientEvent("exterior4", "elm_gunfire_m16_dist",	3.0);
	ambientEvent("exterior4", "elm_gunfire_m16_med",	3.0);
	ambientEvent("exterior4", "null",			0.3);


	ambientDelay("exterior5", 2.0, 8.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior5", "elm_wind_leafy",	3.0);
	ambientEvent("exterior5", "elm_helicopter_flyover_med",	3.0);
	ambientEvent("exterior5", "elm_jet_flyover_med",	1.0);
	ambientEvent("exterior5", "elm_jet_flyover_dist",	1.0);
	ambientEvent("exterior5", "elm_explosions_dist",	3.0);
	ambientEvent("exterior5", "elm_explosions_med",	3.0);
	ambientEvent("exterior5", "elm_artillery_med",	1.0);
	ambientEvent("exterior5", "elm_gunfire_50cal_dist",	3.0);
	ambientEvent("exterior5", "elm_gunfire_50cal_med",	3.0);
	ambientEvent("exterior5", "elm_gunfire_ak47_dist",	3.0);
	ambientEvent("exterior5", "elm_gunfire_ak47_med",	3.0);
	ambientEvent("exterior5", "elm_gunfire_m16_dist",	3.0);
	ambientEvent("exterior5", "elm_gunfire_m16_med",	3.0);
	ambientEvent("exterior5", "null",			0.3);
	

	ambientEventStart("exterior3");

	//level waittill ("action moment");
	
	level waittill ( "southern_hill_action_started" );
	
	thread maps\_utility::set_ambient("exterior4");
	ambientEventStart("exterior4");

	//ambientEventStart("action ambient");
}	
	
	