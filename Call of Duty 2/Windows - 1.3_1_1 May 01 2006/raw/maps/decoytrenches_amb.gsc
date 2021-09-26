#include maps\_ambient;
main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_decoytrenches_ext";
	level.ambient_track ["interior"] = "ambient_decoytrenches_ext";

	level.ambient_reverb["interior"] = [];
	level.ambient_reverb["interior"]["priority"] = "snd_enveffectsprio_level";
	level.ambient_reverb["interior"]["roomtype"] = "stoneroom";
	level.ambient_reverb["interior"]["drylevel"] = .9; //1
	level.ambient_reverb["interior"]["wetlevel"] = .75; //.7
	level.ambient_reverb["interior"]["fadetime"] = 2; // 3

	thread maps\_utility::set_ambient("exterior");
		
	ambientDelay("exterior", 6.0, 10.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "elm_windgust1",	2.0);
	ambientEvent("exterior", "elm_windgust2",	2.0);
	ambientEvent("exterior", "elm_windgust3",	2.0);
	ambientEvent("exterior", "elm_battle_incoming10",		0.2);	
	ambientEvent("exterior", "elm_battle_incoming11",		0.2);	
	ambientEvent("exterior", "elm_c47_flyover1",		0.1);	
	ambientEvent("exterior", "elm_c47_flyover2",		0.1);	
	ambientEvent("exterior", "elm_c47_flyover3",		0.1);	
	ambientEvent("exterior", "elm_c47_flyover4",		0.1);	
	ambientEvent("exterior", "elm_distant_explod1",	0.5);
	ambientEvent("exterior", "elm_distant_explod2",	0.5);
	ambientEvent("exterior", "elm_distant_explod3",	0.5);
	ambientEvent("exterior", "elm_distant_explod4",	0.5);
	ambientEvent("exterior", "elm_distant_explod5",	0.5);
	ambientEvent("exterior", "elm_distant_explod6",	0.5);
	ambientEvent("exterior", "elm_distant_explod7",	0.5);
	ambientEvent("exterior", "elm_distant_explod8",	0.5);
	ambientEvent("exterior", "null",			0.3);
		
	ambientDelay("interior", 6.0, 10.0); // Trackname, min and max delay between ambient events
	ambientEvent("interior", "null",			0.3);
	ambientEvent("interior", "null",			0.3);

	ambientEventStart("exterior");

	level waittill ("action moment");

	ambientEventStart("action ambient");
}	
	
	