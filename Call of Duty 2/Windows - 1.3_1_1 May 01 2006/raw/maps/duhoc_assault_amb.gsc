#include maps\_ambient;
main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_duhoc";
	level.ambient_track ["interior"] = "ambient_duhocbunker";
	level.ambient_track ["town"] = "ambient_duhoctown";
	thread maps\_utility::set_ambient("exterior");
		
	ambientDelay("exterior", 0.1, 15.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "elm_windgust1",	0.9);
	ambientEvent("exterior", "elm_windgust2",	0.9);
	ambientEvent("exterior", "elm_windgust3",	0.9);
	ambientEvent("exterior", "elm_spitfly1",	0.5);	
	ambientEvent("exterior", "elm_spitfly2",	0.5);
	ambientEvent("exterior", "elm_spitfly3",	0.4);
	ambientEvent("exterior", "elm_stukafly2",	0.4);	
	ambientEvent("exterior", "elm_stukafly3",	0.4);	
	ambientEvent("exterior", "elm_stukafly4",	0.4);	
	ambientEvent("exterior", "elm_c47_flyover1",		0.2);	
	ambientEvent("exterior", "elm_c47_flyover2",		0.2);	
	ambientEvent("exterior", "elm_c47_flyover3",		0.2);	
	ambientEvent("exterior", "elm_c47_flyover4",		0.2);	
	ambientEvent("exterior", "null",			0.3);

	ambientDelay("interior", 18.0, 30.0); // Trackname, min and max delay between ambient events
	ambientEvent("interior", "elm_distant_explod1",	0.9);
	ambientEvent("interior", "elm_distant_explod2",	0.9);
	ambientEvent("interior", "elm_distant_explod3",	0.9);
	ambientEvent("interior", "elm_distant_explod4",	0.9);
	ambientEvent("interior", "elm_distant_explod5",	0.9);
	ambientEvent("interior", "elm_distant_explod6",	0.9);
	ambientEvent("interior", "elm_distant_explod7",	0.9);
	ambientEvent("interior", "elm_distant_explod8",	0.9);
	ambientEvent("interior", "null",			2.0);	

	ambientDelay("town", 0.1, 15.0); // Trackname, min and max delay between ambient events
	ambientEvent("town", "elm_windgust1",	0.9);
	ambientEvent("town", "elm_windgust2",	0.9);
	ambientEvent("town", "elm_windgust3",	0.9);
	ambientEvent("town", "elm_spitfly1",	0.5);	
	ambientEvent("town", "elm_spitfly2",	0.5);
	ambientEvent("town", "elm_spitfly3",	0.4);
	ambientEvent("town", "elm_stukafly2",	0.4);	
	ambientEvent("town", "elm_stukafly3",	0.4);	
	ambientEvent("town", "elm_stukafly4",	0.4);	
	ambientEvent("town", "elm_c47_flyover1",		0.2);	
	ambientEvent("town", "elm_c47_flyover2",		0.2);	
	ambientEvent("town", "elm_c47_flyover3",		0.2);	
	ambientEvent("town", "elm_c47_flyover4",		0.2);	
	ambientEvent("town", "null",			0.3);

	thread ambientEventStart("exterior");

	maps\_fx::soundfx("emt_oceanwaves", (4532,-6744,-63));
	maps\_fx::soundfx("emt_oceanwaves", (-1068,-7134,-79));
	maps\_fx::soundfx("emt_oceanwaves", (3065,-6549,-79));
	maps\_fx::soundfx("emt_oceanwaves", (1681,-6771,-79));
	maps\_fx::soundfx("emt_oceanwaves", (-4375,-7472,-47));
	maps\_fx::soundfx("emt_oceanwaves", (-2576,-7136,-47));
	maps\_fx::soundfx("emt_oceanwaves", (331,-6936,-79));
	maps\_fx::soundfx("emt_fly_loop", (-1266,8393,1039));
	maps\_fx::soundfx("emt_fly_loop", (-1921,8945,1072));
}
	
