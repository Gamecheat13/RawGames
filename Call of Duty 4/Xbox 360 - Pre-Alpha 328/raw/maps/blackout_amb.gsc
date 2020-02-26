#include maps\_ambient;

main()
{
	// Set the underlying ambient track
	level.ambient_track ["forrest"] = "ambient_blackout_ext1";

	thread maps\_utility::set_ambient("forrest");

	ambientDelay("forrest", 2.0, 8.0); // Trackname, min and max delay between ambient events
	ambientEvent("forrest", "elm_wind_leafy",	12.0);
	ambientEvent("forrest", "elm_anml_wolf",	0.5);
	ambientEvent("forrest", "elm_anml_owl",	1.0);
	ambientEvent("forrest", "elm_anml_nocturnal_birds",	0.5);
	ambientEvent("forrest", "elm_dog",		0.25);
	ambientEvent("forrest", "null",			0.3);
	
	ambientEventStart("forrest");

	level waittill ("action moment");

	ambientEventStart("action ambient");
}	
	
	
