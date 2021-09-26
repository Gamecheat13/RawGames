#include maps\_ambient;
main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_libya";
	thread maps\_utility::set_ambient("exterior");
		
	ambientDelay("exterior", 6.0, 10.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "elm_windgust1",	1.0);
	ambientEvent("exterior", "elm_windgust2",	1.0);
	ambientEvent("exterior", "elm_windgust3",	1.0);
	ambientEvent("exterior", "elm_battle_incoming10",		0.2);	
	ambientEvent("exterior", "elm_battle_incoming11",		0.2);	
	ambientEvent("exterior", "elm_c47_flyover1",		0.1);	
	ambientEvent("exterior", "elm_c47_flyover2",		0.1);	
	ambientEvent("exterior", "elm_c47_flyover3",		0.1);	
	ambientEvent("exterior", "elm_c47_flyover4",		0.1);	
	ambientEvent("exterior", "null",			0.3);
		

	ambientEventStart("exterior");

	level waittill ("action moment");

	ambientEventStart("action ambient");
}	
	
	