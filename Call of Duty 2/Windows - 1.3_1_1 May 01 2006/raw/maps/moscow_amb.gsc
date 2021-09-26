#include maps\_ambient;
main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_moscow_ext";
	level.ambient_track ["interior"] = "ambient_moscow_int";
	level.ambient_track ["exteriorbattle"] = "ambient_moscowbattle_ext";
	level.ambient_track ["interiorbattle"] = "ambient_moscowbattle_int";
	
/*	level.ambient_reverb["interiorbattle"] = [];
	level.ambient_reverb["interiorbattle"]["priority"] = "snd_enveffectsprio_level";
	level.ambient_reverb["interiorbattle"]["roomtype"] = "stoneroom";
	level.ambient_reverb["interiorbattle"]["drylevel"] = 0; //1
	level.ambient_reverb["interiorbattle"]["wetlevel"] = .7; //.7
	level.ambient_reverb["interiorbattle"]["fadetime"] = .5; // 3*/

	
	thread maps\_utility::set_ambient("exterior");
		
	ambientDelay("exterior", 6.0, 10.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "elm_windgust1",	1.0);
	ambientEvent("exterior", "elm_windgust2",	1.0);
	ambientEvent("exterior", "elm_windgust3",	1.0);
	ambientEvent("exterior", "elm_distant_explod1",	0.5);
	ambientEvent("exterior", "elm_distant_explod2",	0.5);
	ambientEvent("exterior", "elm_distant_explod3",	0.5);
	ambientEvent("exterior", "elm_distant_explod4",	0.5);
	ambientEvent("exterior", "elm_distant_explod5",	0.5);
	ambientEvent("exterior", "elm_distant_explod6",	0.5);
	ambientEvent("exterior", "elm_distant_explod7",	0.5);
	ambientEvent("exterior", "elm_distant_explod8",	0.5);
	ambientEvent("exterior", "elm_rubble1",	1.0);
	ambientEvent("exterior", "elm_rubble2",	1.0);
	ambientEvent("exterior", "elm_rubble3",	1.0);
	ambientEvent("exterior", "elm_rubble4",	1.0);
	ambientEvent("exterior", "elm_rubble5",	1.0);
	ambientEvent("exterior", "elm_rubble6",	1.0);
	ambientEvent("exterior", "elm_rubble7",	1.0);
	ambientEvent("exterior", "elm_rubble8",	1.0);
	ambientEvent("exterior", "elm_rubble9",	1.0);
	ambientEvent("exterior", "null",			0.3);

	ambientDelay("exteriorbattle", 6.0, 10.0); // Trackname, min and max delay between ambient events
	ambientEvent("exteriorbattle", "elm_windgust1",	1.0);
	ambientEvent("exteriorbattle", "elm_windgust2",	1.0);
	ambientEvent("exteriorbattle", "elm_windgust3",	1.0);
	ambientEvent("exteriorbattle", "elm_distant_explod1",	0.5);
	ambientEvent("exteriorbattle", "elm_distant_explod2",	0.5);
	ambientEvent("exteriorbattle", "elm_distant_explod3",	0.5);
	ambientEvent("exteriorbattle", "elm_distant_explod4",	0.5);
	ambientEvent("exteriorbattle", "elm_distant_explod5",	0.5);
	ambientEvent("exteriorbattle", "elm_distant_explod6",	0.5);
	ambientEvent("exteriorbattle", "elm_distant_explod7",	0.5);
	ambientEvent("exteriorbattle", "elm_distant_explod8",	0.5);
	ambientEvent("exteriorbattle", "elm_rubble1",	1.0);
	ambientEvent("exteriorbattle", "elm_rubble2",	1.0);
	ambientEvent("exteriorbattle", "elm_rubble3",	1.0);
	ambientEvent("exteriorbattle", "elm_rubble4",	1.0);
	ambientEvent("exteriorbattle", "elm_rubble5",	1.0);
	ambientEvent("exteriorbattle", "elm_rubble6",	1.0);
	ambientEvent("exteriorbattle", "elm_rubble7",	1.0);
	ambientEvent("exteriorbattle", "elm_rubble8",	1.0);
	ambientEvent("exteriorbattle", "elm_rubble9",	1.0);
	ambientEvent("exteriorbattle", "null",			0.3);

	ambientDelay("interior", 18.0, 30.0); // Trackname, min and max delay between ambient events
	ambientEvent("interior", "elm_distant_explod1",	0.5);
	ambientEvent("interior", "elm_distant_explod2",	0.5);
	ambientEvent("interior", "elm_distant_explod3",	0.5);
	ambientEvent("interior", "elm_distant_explod4",	0.5);
	ambientEvent("interior", "elm_distant_explod5",	0.5);
	ambientEvent("interior", "elm_distant_explod6",	0.5);
	ambientEvent("interior", "elm_distant_explod7",	0.5);
	ambientEvent("interior", "elm_distant_explod8",	0.5);
	ambientEvent("interior", "elm_rubble1",	1.0);
	ambientEvent("interior", "elm_rubble2",	1.0);
	ambientEvent("interior", "elm_rubble3",	1.0);
	ambientEvent("interior", "elm_rubble4",	1.0);
	ambientEvent("interior", "elm_rubble5",	1.0);
	ambientEvent("interior", "elm_rubble6",	1.0);
	ambientEvent("interior", "elm_rubble7",	1.0);
	ambientEvent("interior", "elm_rubble8",	1.0);
	ambientEvent("interior", "elm_rubble9",	1.0);
	ambientEvent("interior", "null",			0.3);

	ambientDelay("interiorbattle", 18.0, 30.0); // Trackname, min and max delay between ambient events
	ambientEvent("interiorbattle", "elm_distant_explod1",	0.5);
	ambientEvent("interiorbattle", "elm_distant_explod2",	0.5);
	ambientEvent("interiorbattle", "elm_distant_explod3",	0.5);
	ambientEvent("interiorbattle", "elm_distant_explod4",	0.5);
	ambientEvent("interiorbattle", "elm_distant_explod5",	0.5);
	ambientEvent("interiorbattle", "elm_distant_explod6",	0.5);
	ambientEvent("interiorbattle", "elm_distant_explod7",	0.5);
	ambientEvent("interiorbattle", "elm_distant_explod8",	0.5);
	ambientEvent("interiorbattle", "elm_rubble1",	1.0);
	ambientEvent("interiorbattle", "elm_rubble2",	1.0);
	ambientEvent("interiorbattle", "elm_rubble3",	1.0);
	ambientEvent("interiorbattle", "elm_rubble4",	1.0);
	ambientEvent("interiorbattle", "elm_rubble5",	1.0);
	ambientEvent("interiorbattle", "elm_rubble6",	1.0);
	ambientEvent("interiorbattle", "elm_rubble7",	1.0);
	ambientEvent("interiorbattle", "elm_rubble8",	1.0);
	ambientEvent("interiorbattle", "elm_rubble9",	1.0);
	ambientEvent("interiorbattle", "null",			0.3);
		
	thread ambientEventStart("exterior");
}	