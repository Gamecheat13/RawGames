#include maps\_ambient;
main()
{
	maps\_fx::soundfx("medfire", (-827,-2708,60));
	maps\_fx::soundfx("smallfire", (-909,-1274,69));
	maps\_fx::soundfx("smallfire", (-1419,-592,158));
	
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_downtownassault_ext";
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
		
	ambientEventStart("exterior");
}	
	