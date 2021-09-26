#include maps\_ambient;
main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_elalamein";
	level.ambient_track ["cavern"] = "ambient_elalamein";
	level.ambient_track ["bunker"] = "ambient_elalamein";
	level.ambient_track ["house"] = "ambient_elalamein";

	level.ambient_reverb["cavern"] = [];
	level.ambient_reverb["cavern"]["priority"] = "snd_enveffectsprio_level";
	level.ambient_reverb["cavern"]["roomtype"] = "stoneroom";
	level.ambient_reverb["cavern"]["drylevel"] = .9; //1
	level.ambient_reverb["cavern"]["wetlevel"] = .6; //.7
	level.ambient_reverb["cavern"]["fadetime"] = 1; // 3

	level.ambient_reverb["bunker"] = [];
	level.ambient_reverb["bunker"]["priority"] = "snd_enveffectsprio_level";
	level.ambient_reverb["bunker"]["roomtype"] = "stoneroom";
	level.ambient_reverb["bunker"]["drylevel"] = .9; //1
	level.ambient_reverb["bunker"]["wetlevel"] = .75; //.7
	level.ambient_reverb["bunker"]["fadetime"] = 2; // 3
	
	level.ambient_reverb["house"] = [];
	level.ambient_reverb["house"]["priority"] = "snd_enveffectsprio_level";
	level.ambient_reverb["house"]["roomtype"] = "stoneroom";
	level.ambient_reverb["house"]["drylevel"] = .9; //1
	level.ambient_reverb["house"]["wetlevel"] = .4; //.7
	level.ambient_reverb["house"]["fadetime"] = .5; // 3

	thread maps\_utility::set_ambient("exterior");
		
	ambientDelay("exterior", 6.0, 10.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "elm_windgust1",	1.0);
	ambientEvent("exterior", "elm_windgust2",	1.0);
	ambientEvent("exterior", "elm_windgust3",	1.0);
	ambientEvent("exterior", "null",			0.3);

	ambientDelay("house", 6.0, 10.0); // Trackname, min and max delay between ambient events
	ambientEvent("house", "elm_windgust1",	1.0);
	ambientEvent("house", "elm_windgust2",	1.0);
	ambientEvent("house", "elm_windgust3",	1.0);
	ambientEvent("house", "null",			0.3);
		
	ambientDelay("cavern", 6.0, 10.0); // Trackname, min and max delay between ambient events
	ambientEvent("cavern", "elm_windgust1",	1.0);
	ambientEvent("cavern", "elm_windgust2",	1.0);
	ambientEvent("cavern", "elm_windgust3",	1.0);
	ambientEvent("cavern", "null",			0.3);

	ambientDelay("bunker", 6.0, 10.0); // Trackname, min and max delay between ambient events
	ambientEvent("bunker", "elm_windgust1",	1.0);
	ambientEvent("bunker", "elm_windgust2",	1.0);
	ambientEvent("bunker", "elm_windgust3",	1.0);
	ambientEvent("bunker", "null",			0.3);

	ambientEventStart("exterior");

	level waittill ("action moment");

	ambientEventStart("action ambient");
}	
	