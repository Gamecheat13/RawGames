#include maps\_ambient;
main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_toujane";
	thread maps\_utility::set_ambient("exterior");
		
	ambientDelay("exterior", 1.0, 10.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "elm_windgust1",	0.5);
	ambientEvent("exterior", "elm_windgust2",	0.5);
	ambientEvent("exterior", "elm_windgust3",	0.5);
	ambientEvent("exterior", "elm_dog1",		0.1);	
	ambientEvent("exterior", "elm_dog2",		0.3);	
	ambientEvent("exterior", "elm_dog3",		0.4);
	ambientEvent("exterior", "elm_horse1",		0.1);	
	ambientEvent("exterior", "elm_donkey1",		0.1);
	ambientEvent("exterior", "elm_battle_rifle10",		0.1);
	ambientEvent("exterior", "elm_battle_rifle11",		0.1);
	ambientEvent("exterior", "elm_battle_smg10",		0.1);
	ambientEvent("exterior", "elm_battle_smg11",		0.1);
	ambientEvent("exterior", "elm_battle_smg12",		0.1);	
	ambientEvent("exterior", "elm_battle_incoming10",		0.2);	
	ambientEvent("exterior", "elm_battle_incoming11",		0.2);	
	ambientEvent("exterior", "elm_c47_flyover1",		0.1);	
	ambientEvent("exterior", "elm_c47_flyover2",		0.1);	
	ambientEvent("exterior", "elm_c47_flyover3",		0.1);	
	ambientEvent("exterior", "elm_c47_flyover4",		0.1);	
	ambientEvent("exterior", "elm_spitfly1",		0.8);	
	ambientEvent("exterior", "elm_spitfly2",		0.8);	
	ambientEvent("exterior", "elm_spitfly3",		0.8);	
	ambientEvent("exterior", "elm_stukafly2",		0.8);	
	ambientEvent("exterior", "elm_stukafly3",		0.8);	
	ambientEvent("exterior", "elm_stukafly4",		0.8);	
	ambientEvent("exterior", "null",			0.3);
		

	ambientEventStart("exterior");

	level waittill ("action moment");

	ambientEventStart("action ambient");
}	
	
