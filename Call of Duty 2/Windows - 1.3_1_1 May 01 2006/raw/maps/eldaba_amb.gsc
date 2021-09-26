#include maps\_ambient;
main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_eldaba";
	thread maps\_utility::set_ambient("exterior");
		
	ambientDelay("exterior", 0.1, 0.3); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "elm_windgust1",	0.9);
	ambientEvent("exterior", "elm_windgust2",	0.9);
	ambientEvent("exterior", "elm_windgust3",	0.9);
	ambientEvent("exterior", "elm_spitfly1",	1.5);	
	ambientEvent("exterior", "elm_spitfly2",	1.5);
	ambientEvent("exterior", "elm_spitfly3",	1.5);
	ambientEvent("exterior", "elm_stukafly2",	0.5);	
	ambientEvent("exterior", "elm_stukafly3",	0.5);	
	ambientEvent("exterior", "elm_stukafly4",	0.5);	
	ambientEvent("exterior", "elm_battle_rifle10",		0.2);
	ambientEvent("exterior", "elm_battle_rifle11",		0.2);
	ambientEvent("exterior", "elm_battle_smg10",		0.1);
	ambientEvent("exterior", "elm_battle_smg11",		0.1);
	ambientEvent("exterior", "elm_battle_smg12",		0.1);	
	ambientEvent("exterior", "elm_battle_incoming10",		0.2);	
	ambientEvent("exterior", "elm_battle_incoming11",		0.2);	
	ambientEvent("exterior", "elm_c47_flyover1",		0.3);	
	ambientEvent("exterior", "elm_c47_flyover2",		0.3);	
	ambientEvent("exterior", "elm_c47_flyover3",		0.3);	
	ambientEvent("exterior", "elm_c47_flyover4",		0.3);	
	ambientEvent("exterior", "null",			0.3);
		
	maps\_fx::soundfx("emt_wind_corner", (-1121,796,91));
	maps\_fx::soundfx("emt_wind_corner", (1252,1400,97));
	maps\_fx::soundfx("emt_wind_corner", (1252,1400,97));
	maps\_fx::soundfx("emt_wind_corner", (2258,1838,73));
	maps\_fx::soundfx("emt_wind_corner", (2843,938,27));
	maps\_fx::soundfx("emt_wind_corner", (2574,221,51));
	maps\_fx::soundfx("emt_wind_corner", (2484,8,53));
	maps\_fx::soundfx("emt_wind_corner", (932,-302,76));
	maps\_fx::soundfx("emt_wind_corner", (1382,-240,71));
	maps\_fx::soundfx("emt_wind_corner", (1897,516,59));
	maps\_fx::soundfx("emt_oceanwaves", (-1498,3974,13));
	maps\_fx::soundfx("emt_oceanwaves", (337,4305,6));
	maps\_fx::soundfx("emt_oceanwaves", (3486,4442,5));
	maps\_fx::soundfx("emt_oceanwaves", (1966,4445,1));
	maps\_fx::soundfx("emt_militaryradio", (-1040,253,6));
	maps\_fx::soundfx("emt_militaryradio", (745,-447,198));
	maps\_fx::soundfx("emt_radiostatic", (2740,1943,117));

	ambientEventStart("exterior");

	level waittill ("action moment");

	ambientEventStart("action ambient");
}	
	