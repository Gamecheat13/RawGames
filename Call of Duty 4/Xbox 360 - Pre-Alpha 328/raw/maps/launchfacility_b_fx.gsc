#include maps\_utility;

main()
{

	//ambient
	level._effect["hallway_steam_flood"]						= loadfx ("smoke/hallway_steam_flood");
	level._effect["hallway_steam_loop"]							= loadfx ("smoke/hallway_steam_loop");
	level._effect["steam_jet_med"]								= loadfx ("smoke/steam_jet_med");
	level._effect["steam_jet_med_loop"]							= loadfx ("smoke/steam_jet_med_loop");
	level._effect["steam_jet_med_loop_rand"]					= loadfx ("smoke/steam_jet_med_loop_random");

	maps\createfx\launchfacility_b_fx::main();
}
