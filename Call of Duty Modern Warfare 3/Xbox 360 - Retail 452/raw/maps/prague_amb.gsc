#include maps\_audio;

// used for doing level-specific audio scripting

main()
{
	aud_use_string_tables(); // uses string tables for presets
	aud_set_occlusion("default"); // new way to do it, which uses string tables
	aud_set_timescale();

	//thread maps\_utility::set_ambient("prague_underwater"); // start prague_underwater zone
	thread maps\_utility::set_ambient("prague_sewers"); // start prague_docks zone
}



