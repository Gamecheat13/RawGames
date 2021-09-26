#include maps\_ambient;
main()
{
	level.ambient_track["outside"] = "ambient_trainyard_ext";
	level.ambient_track["inside"] = "ambient_trainyard_int";
	level.ambient_track["pipe"] = "ambient_trainyardpipe";
	level.ambient_reverb["pipe"] = [];
	level.ambient_reverb["pipe"]["priority"] = "snd_enveffectsprio_level";
	level.ambient_reverb["pipe"]["roomtype"] = "stoneroom";
	level.ambient_reverb["pipe"]["drylevel"] = .85; //1
	level.ambient_reverb["pipe"]["wetlevel"] = .95; //.7
	level.ambient_reverb["pipe"]["fadetime"] = .5; // 3

	ambientDelay("outside", 5.0, 10.0); // Trackname, min and max delay between ambient events
	ambientEvent("outside", "elm_windgust1",	1.0);
	ambientEvent("outside", "elm_windgust2",	1.0);
	ambientEvent("outside", "elm_windgust3",	1.0);
	ambientEvent("outside", "elm_distant_explod1",	0.5);
	ambientEvent("outside", "elm_distant_explod2",	0.5);
	ambientEvent("outside", "elm_distant_explod3",	0.5);
	ambientEvent("outside", "elm_distant_explod4",	0.5);
	ambientEvent("outside", "elm_distant_explod5",	0.5);
	ambientEvent("outside", "elm_distant_explod6",	0.5);
	ambientEvent("outside", "elm_distant_explod7",	0.5);
	ambientEvent("outside", "elm_distant_explod8",	0.5);
	ambientEvent("outside", "elm_rubble1",	1.0);
	ambientEvent("outside", "elm_rubble2",	1.0);
	ambientEvent("outside", "elm_rubble3",	1.0);
	ambientEvent("outside", "elm_rubble4",	1.0);
	ambientEvent("outside", "elm_rubble5",	1.0);
	ambientEvent("outside", "elm_rubble6",	1.0);
	ambientEvent("outside", "elm_rubble7",	1.0);
	ambientEvent("outside", "elm_rubble8",	1.0);
	ambientEvent("outside", "elm_rubble9",	1.0);
	ambientEvent("outside", "elm_industry",	30.0);
	ambientEvent("outside", "null",			0.3);
	
	ambientDelay("inside", 6.0, 10.0); // Trackname, min and max delay between ambient events
	ambientEvent("inside", "elm_distant_explod1",	0.5);
	ambientEvent("inside", "elm_distant_explod2",	0.5);
	ambientEvent("inside", "elm_distant_explod3",	0.5);
	ambientEvent("inside", "elm_distant_explod4",	0.5);
	ambientEvent("inside", "elm_distant_explod5",	0.5);
	ambientEvent("inside", "elm_distant_explod6",	0.5);
	ambientEvent("inside", "elm_distant_explod7",	0.5);
	ambientEvent("inside", "elm_distant_explod8",	0.5);
	ambientEvent("inside", "null",			0.3);

	ambientDelay("pipe", 5.0, 15.0); // Trackname, min and max delay between ambient events
	ambientEvent("pipe", "elm_windgust1",	0.1);
	ambientEvent("pipe", "elm_windgust2",	0.1);
	ambientEvent("pipe", "elm_windgust3",	0.1);
	ambientEvent("pipe", "elm_pipe_stress",		0.3);
	ambientEvent("pipe", "elm_pipe_stress",		0.3);

	ambientEventStart("inside");
}