// Test clientside script for pakistan_3

#include clientscripts\_utility;
#include clientscripts\_filter;

#insert raw\maps\pakistan.gsh;

main()
{	
	// _load!
	clientscripts\_load::main();

	clientscripts\pakistan_3_fx::main();
	
	clientscripts\_boat_soct_ride::init();

	//thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\pakistan_3_amb::main();
	
	level.b_outline_active = false;

//	init_filter_hud_projected_pip( getlocalplayers()[0] );
	init_filter_hud_outline( getlocalplayers()[0] );
	
	register_clientflag_callback( "vehicle", CLIENT_FLAG_VEHICLE_OUTLINE, ::friendly_outline );
	
	// This needs to be called after all systems have been registered.
	waitforclient(0);

	println("*** Client : pakistan_3 running...");

	set_player_viewmodel( "c_usa_cia_masonjr_armlaunch_viewbody" );  // set custom viewarms for swimming section
	
	level.localPlayers[0] SetSonarEnabled( 1 );
}

init_filter_hud_outline( player )
{
    init_filter_indices();
    map_material_helper( player, "generic_filter_hud_outline" );
}

init_filter_hud_projected_pip( player )
{
	init_filter_indices();
	map_material_helper( player, "generic_filter_hud_projected_pip" );
}

friendly_outline( localClientNum, set, newEnt )
{
	const n_filter_index = 0;
	const n_amount = 120;
	
	if ( set )
	{
    	self SetHudOutlineColor( 2 );
        
//		enable_filter_hud_projected_pip( level.localPlayers[localClientNum], n_filter_index );
//		set_filter_hud_projected_pip_radius( level.localPlayers[localClientNum], n_filter_index, 120 );
		
		enable_filter_hud_outline( level.localPlayers[ localClientNum ], n_filter_index );
		set_filter_hud_outline_reveal_amount( level.localPlayers [localClientNum ], n_filter_index, n_amount );
		
		level.b_outline_active = true;
	}
	else
	{
    	self SetHudOutlineColor( 0 );
    	
//		disable_filter_hud_projected_pip( level.localPlayers[localClientNum], n_filter_index );
    	disable_filter_hud_outline( level.localPlayers[ localClientNum ], n_filter_index );
    		
        level.b_outline_active = false;
	}
}