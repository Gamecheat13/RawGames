#include maps\_ambient;
main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_cityhall_ext";
	level.ambient_reverb["exterior"]["priority"] = "snd_enveffectsprio_level";
	level.ambient_reverb["exterior"]["roomtype"] = "arena";
	level.ambient_reverb["exterior"]["drylevel"] = 0.85; //1
	level.ambient_reverb["exterior"]["wetlevel"] = .15; //.7
	level.ambient_reverb["exterior"]["fadetime"] = 2; // 3
	thread maps\_utility::set_ambient("exterior");
		
	
	maps\_fx::soundfx("medfire", (2896,-3431,137));
	maps\_fx::soundfx("medfire", (2634,-2992,4));
	maps\_fx::soundfx("medfire", (5194,-3820,107));
	maps\_fx::soundfx("medfire", (6000,-1900,82));
	maps\_fx::soundfx("medfire", (6115,-2610,42));
	maps\_fx::soundfx("medfire", (5907,-2608,86));
	maps\_fx::soundfx("medfire", (6241,-5400,104));

	maps\_fx::soundfx("bigfire", (3675,-3396,696));
		
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
		
	ambientEventStart("exterior");

	level waittill ("action moment");

	ambientEventStart("action ambient");
	
	
}	
	