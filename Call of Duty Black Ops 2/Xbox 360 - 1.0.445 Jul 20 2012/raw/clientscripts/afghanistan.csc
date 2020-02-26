// Test 	clientside script for afghanistan

#include clientscripts\_utility;
#include clientscripts\_filter;

main()
{
	// _load!
	clientscripts\afghanistan_fx::main();
	clientscripts\_load::main();
	clientscripts\_horse_ride::init();

	

	//thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\afghanistan_amb::main();

	// This needs to be called after all systems have been registered.
	waitforclient(0);

	/#println("*** Client : afghanistan running...");#/


	//-- Spot light for over the table.
	level thread playfx_spot_over_table_and_delete();
	
	level thread fog_bank_controller();

	init_filter_binoculars( level.localPlayers[0] );
	
	level waittill( "binoc_on" );
	
	enable_filter_binoculars( level.localPlayers[0], 0, 0 );
	
	level waittill( "binoc_off" );
	
	disable_filter_binoculars( level.localPlayers[0], 0, 0 );
}

playfx_spot_over_table_and_delete()
{
	wait(1);
	
	a_light_room = getdynent( "map_room_light01" );
	//PlayFXOnDynEnt( level._effect["fx_afgh_spot_cave"], a_light_room );
	
	PlayFX( 0, level._effect["fx_afgh_spot_cave"], a_light_room.origin - (0,0,4), (0,0,-1), (1,0,0));
}

fog_bank_controller()
{
	level waittill( "set_deserted_fog_banks" );
	SetWorldFogActiveBank( 0, 2 );
}