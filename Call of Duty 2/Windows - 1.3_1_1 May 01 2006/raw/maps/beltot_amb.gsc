#include maps\_ambient;
main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_beltot_ext";
	level.ambient_track ["exteriormedium"] = "ambient_beltotmedium_ext";
	level.ambient_track ["exteriorlight"] = "ambient_beltotlight_ext";
	level.ambient_track ["interior"] = "ambient_beltot_int";
	thread maps\_utility::set_ambient("exterior");
		
	ambientDelay("exterior", 6.0, 10.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "elm_windgust1",	1.0);
	ambientEvent("exterior", "elm_windgust2",	1.0);
	ambientEvent("exterior", "elm_windgust3",	1.0);
	ambientEvent("exterior", "elm_distant_explod1",	0.9);
	ambientEvent("exterior", "elm_distant_explod2",	0.9);
	ambientEvent("exterior", "elm_distant_explod3",	0.9);
	ambientEvent("exterior", "elm_distant_explod4",	0.9);
	ambientEvent("exterior", "elm_distant_explod5",	0.9);
	ambientEvent("exterior", "elm_distant_explod6",	0.9);
	ambientEvent("exterior", "elm_distant_explod7",	0.9);
	ambientEvent("exterior", "elm_distant_explod8",	0.9);
	ambientEvent("exterior", "elm_battle_bren1",	0.5);
	ambientEvent("exterior", "elm_battle_bren2",	0.5);
	ambientEvent("exterior", "elm_battle_bren3",	0.5);
	ambientEvent("exterior", "elm_battle_bren4",	0.5);
	ambientEvent("exterior", "elm_battle_bren5",	0.5);
	ambientEvent("exterior", "elm_battle_mp40_1",	0.5);
	ambientEvent("exterior", "elm_battle_mp40_2",	0.5);
	ambientEvent("exterior", "elm_battle_mp40_3",	0.5);
	ambientEvent("exterior", "elm_battle_sten1",	0.5);
	ambientEvent("exterior", "elm_battle_sten2",	0.5);
	ambientEvent("exterior", "elm_battle_rifle1",	0.5);
	ambientEvent("exterior", "elm_battle_rifle2",	0.5);
	ambientEvent("exterior", "elm_battle_rifle3",	0.5);
	ambientEvent("exterior", "elm_battle_rifle4",	0.5);
	ambientEvent("exterior", "null",			0.3);

	ambientDelay("exteriormedium", 6.0, 10.0); // Trackname, min and max delay between ambient events
	ambientEvent("exteriormedium", "elm_windgust1",	1.0);
	ambientEvent("exteriormedium", "elm_windgust2",	1.0);
	ambientEvent("exteriormedium", "elm_windgust3",	1.0);
	ambientEvent("exteriormedium", "elm_distant_explod1",	0.9);
	ambientEvent("exteriormedium", "elm_distant_explod2",	0.9);
	ambientEvent("exteriormedium", "elm_distant_explod3",	0.9);
	ambientEvent("exteriormedium", "elm_distant_explod4",	0.9);
	ambientEvent("exteriormedium", "elm_distant_explod5",	0.9);
	ambientEvent("exteriormedium", "elm_distant_explod6",	0.9);
	ambientEvent("exteriormedium", "elm_distant_explod7",	0.9);
	ambientEvent("exteriormedium", "elm_distant_explod8",	0.9);
	ambientEvent("exteriormedium", "elm_battle_bren1",	0.5);
	ambientEvent("exteriormedium", "elm_battle_bren2",	0.5);
	ambientEvent("exteriormedium", "elm_battle_bren3",	0.5);
	ambientEvent("exteriormedium", "elm_battle_bren4",	0.5);
	ambientEvent("exteriormedium", "elm_battle_bren5",	0.5);
	ambientEvent("exteriormedium", "elm_battle_mp40_1",	0.5);
	ambientEvent("exteriormedium", "elm_battle_mp40_2",	0.5);
	ambientEvent("exteriormedium", "elm_battle_mp40_3",	0.5);
	ambientEvent("exteriormedium", "elm_battle_sten1",	0.5);
	ambientEvent("exteriormedium", "elm_battle_sten2",	0.5);
	ambientEvent("exteriormedium", "elm_battle_rifle1",	0.5);
	ambientEvent("exteriormedium", "elm_battle_rifle2",	0.5);
	ambientEvent("exteriormedium", "elm_battle_rifle3",	0.5);
	ambientEvent("exteriormedium", "elm_battle_rifle4",	0.5);
	ambientEvent("exteriormedium", "null",			0.3);

	ambientDelay("exteriorlight", 6.0, 10.0); // Trackname, min and max delay between ambient events
	ambientEvent("exteriorlight", "elm_windgust1",	1.0);
	ambientEvent("exteriorlight", "elm_windgust2",	1.0);
	ambientEvent("exteriorlight", "elm_windgust3",	1.0);
	ambientEvent("exteriorlight", "elm_distant_explod1",	0.9);
	ambientEvent("exteriorlight", "elm_distant_explod2",	0.9);
	ambientEvent("exteriorlight", "elm_distant_explod3",	0.9);
	ambientEvent("exteriorlight", "elm_distant_explod4",	0.9);
	ambientEvent("exteriorlight", "elm_distant_explod5",	0.9);
	ambientEvent("exteriorlight", "elm_distant_explod6",	0.9);
	ambientEvent("exteriorlight", "elm_distant_explod7",	0.9);
	ambientEvent("exteriorlight", "elm_distant_explod8",	0.9);
	ambientEvent("exteriorlight", "elm_battle_bren1",	0.5);
	ambientEvent("exteriorlight", "elm_battle_bren2",	0.5);
	ambientEvent("exteriorlight", "elm_battle_bren3",	0.5);
	ambientEvent("exteriorlight", "elm_battle_bren4",	0.5);
	ambientEvent("exteriorlight", "elm_battle_bren5",	0.5);
	ambientEvent("exteriorlight", "elm_battle_mp40_1",	0.5);
	ambientEvent("exteriorlight", "elm_battle_mp40_2",	0.5);
	ambientEvent("exteriorlight", "elm_battle_mp40_3",	0.5);
	ambientEvent("exteriorlight", "elm_battle_sten1",	0.5);
	ambientEvent("exteriorlight", "elm_battle_sten2",	0.5);
	ambientEvent("exteriorlight", "elm_battle_rifle1",	0.5);
	ambientEvent("exteriorlight", "elm_battle_rifle2",	0.5);
	ambientEvent("exteriorlight", "elm_battle_rifle3",	0.5);
	ambientEvent("exteriorlight", "elm_battle_rifle4",	0.5);
	ambientEvent("exteriorlight", "null",			0.3);

	ambientDelay("interior", 18.0, 30.0); // Trackname, min and max delay between ambient events
	ambientEvent("interior", "elm_distant_explod1",	0.9);
	ambientEvent("interior", "elm_distant_explod2",	0.9);
	ambientEvent("interior", "elm_distant_explod3",	0.9);
	ambientEvent("interior", "elm_distant_explod4",	0.9);
	ambientEvent("interior", "elm_distant_explod5",	0.9);
	ambientEvent("interior", "elm_distant_explod6",	0.9);
	ambientEvent("interior", "elm_distant_explod7",	0.9);
	ambientEvent("interior", "elm_distant_explod8",	0.9);
	ambientEvent("interior", "null",			0.3);

	thread ambientEventStart("exterior");
}
