#include maps\_hud_util;
#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_utility_chetan;
#include maps\paris_ac130_code;
#include maps\paris_ac130_slamzoom;

main()
{	
	// PreCache
	
	level_precache();
	
	// Add Starts

	add_start( "start_intro", 					::void, "Start Intro" );
	add_start( "start_ac130", 					::void, "Start AC130" );
	add_start( "start_fdr",						::void, "Start FDR" );
	add_start( "start_e3",						::void, "Start E3" );
	add_start( "start_street", 					::void, "Start Street" );
	add_start( "start_rpg", 					::void, "Start RPG" );
	add_start( "start_courtyard", 				::void, "Start Courtyard" );
	add_start( "start_chase", 					::void, "Start Chase" );
	add_start( "start_bridge", 					::void, "Start Bridge" );
	add_start( "start_bridge_collapse", 		::void, "Start Bridge Collapse" );
	/*
	add_start( "nogame_ac130_roundabout", 		::void, "NO GAME AC130 Roundabout" );
	*/

	maps\createart\paris_ac130_art::main();
	maps\paris_ac130_fx::main();
	maps\paris_ac130_precache::main();
	maps\paris_ac130_snd::main();
	maps\paris_ac130_anim::main();
	
	thread start_no_game();
			
	maps\_load::main();
	
	maps\_compass::setupMiniMap( "compass_map_paris_ac130_intro", "intro_minimap_corner" );
	
	maps\_audio::aud_use_string_tables(); // uses string tables for presets
	maps\_audio::aud_set_occlusion("default"); // new way to do it, which uses string tables
	maps\_audio::aud_set_timescale();
		
	level.cheap_air_strobe_fx  = 1;
	maps\_air_support_strobe::main();
	
	maps\_javelin::init();  
    level.intro_black = create_client_overlay( "black", 1, level.player );
 
    // Clear Global Struct List	
	level.struct = undefined;
	
    // Dvars
    
    _init_dvars();
    SetDvar( "pip_enabled", 1 );
    //SetDvar( "e3demo", "1" );
    SetDvar( "new_intro", 1 );
    SetSavedDvar( "fx_alphathreshold", 11 );
    
	// Flags
	
	_init_flags();
	
	// Globals
	
	init_globals();
	
	// Button Polling
	
	thread monitor_interact_button();
	thread level_sky();
	thread level_destructibles();
	thread level_swaps();
	thread level_thermal_objects();
	thread level_death_fx();
	
	// Start Level Event Manager
	
	catch_up_manager();
	thread level_manager();
}

// *************************************
// AC-130 
// *************************************

ac130_path( section )
{
	Assert( IsDefined( section ) );
	
	switch ( section )
	{
		case "loop_0":
			transition_node = GetVehicleNode( "city_area_loop_0_to_1_in", "script_noteworthy" );
			Assert( IsDefined( transition_node ) );
			transition_node waittill( "trigger" );
			
			flag_set( "FLAG_ac130_loop_0" );
			
			//thread vehicle_scripts\_ac130::autosave_ac130();
			break;
		case "loop_2":
			flag_wait( "FLAG_fdr_ac130_circling_fdr" );
			flag_wait( "FLAG_fdr_enemy_vehicles_killed" );
			
			node = GetVehicleNode( "city_area_loop_0_check", "script_noteworthy" );
			Assert( IsDefined( node ) );
			node waittill( "trigger" );
			
			starting_node = GetVehicleNode( "city_area_loop_0_to_1_in", "script_noteworthy" );
			Assert( IsDefined( starting_node ) );
			transition_node = GetVehicleNode( "city_area_loop_0_to_2_out", "script_noteworthy" );
			Assert( IsDefined( transition_node ) );
			level.ac130_vehicle switch_vehicle_between_paths_lerp( starting_node, transition_node );
			
			flag_set( "FLAG_ac130_loop_0_to_2" );

			starting_node = GetVehicleNode( "city_area_loop_2_to_0_in", "script_noteworthy" );
			Assert( IsDefined( starting_node ) );
			transition_node = GetVehicleNode( "city_area_loop_2_out", "script_noteworthy" );
			Assert( IsDefined( transition_node ) );
			level.ac130_vehicle switch_vehicle_between_paths_lerp( starting_node, transition_node );
			flag_set( "FLAG_ac130_loop_2" );
			break;
		case "loop_3":
			flag_wait( "FLAG_street_ma_3_delta_move_down" );
			
			node = GetVehicleNode( "city_area_loop_2_check", "script_noteworthy" );
			Assert( IsDefined( node ) );
			level.ac130_vehicle Vehicle_SetSpeed( 30, 1, 1 );
			node waittill( "trigger" );
			
			starting_node = GetVehicleNode( "city_area_loop_2_to_3_in", "script_noteworthy" );
			Assert( IsDefined( starting_node ) );
			transition_node = GetVehicleNode( "city_area_loop_2_to_3_out", "script_noteworthy" );
			Assert( IsDefined( transition_node ) );
			level.ac130_vehicle switch_vehicle_between_paths_lerp( starting_node, transition_node );
			flag_set( "FLAG_ac130_loop_2_to_3" );
			
			level.ac130_vehicle Vehicle_SetSpeed( 20, 1, 1 );
			
			starting_node = GetVehicleNode( "city_area_loop_3_in", "script_noteworthy" );
			Assert( IsDefined( starting_node ) );
			transition_node = GetVehicleNode( "city_area_loop_3_out", "script_noteworthy" );
			Assert( IsDefined( transition_node ) );
			level.ac130_vehicle switch_vehicle_between_paths_lerp( starting_node, transition_node );
			flag_set( "FLAG_ac130_loop_3" );
			
			transition_node = GetVehicleNode( "city_area_loop_4_out", "script_noteworthy" );
			Assert( IsDefined( transition_node ) );
			transition_node waittill( "trigger" );
			flag_set( "FLAG_ac130_loop_4" );
			break;
		case "chase":
			//level.ac130_vehicle Vehicle_SetSpeed( 70, 5, 5 );
			
			starting_node = GetVehicleNode( "chase_start_transition_in", "script_noteworthy" );
			Assert( IsDefined( starting_node ) );
			transition_node = GetVehicleNode( "chase_start_transition_out", "script_noteworthy" );
			Assert( IsDefined( transition_node ) );
			level.ac130_vehicle switch_vehicle_between_paths_lerp( starting_node, transition_node );
			break;
	}
}
    
// LEVEL STARTS

level_manager()
{
	wait 0.05; // let the start points initiate stuff first
	
	switch ( level.start_point )
	{
		case "default":
			flag_set( "FLAG_start_intro" );
		case "start_intro":
			flag_wait( "FLAG_start_intro" );

			//intro_minimap();
			delayThread( 10.0, ::fdr_setup );
			thread intro_display_introscreen();
			start_intro();
			start_osprey_crash();
			
			flag_set( "FLAG_start_ac130" );
		case "start_ac130":
			flag_wait( "FLAG_start_ac130" );
			
			start_ac130_slamout();
			
			flag_set( "FLAG_start_fdr" );
		case "start_fdr":
			flag_wait( "FLAG_start_fdr" );
			
			start_fdr();
		
			flag_set( "FLAG_start_e3" );
		case "start_e3":
			flag_wait( "FLAG_start_e3" );
			
			start_e3();
			
			flag_set( "FLAG_start_street" );
	    case "start_street":
	        flag_wait( "FLAG_start_street" );
	        
	 		start_street();
            
            flag_set( "FLAG_start_rpg" );
    	case "start_rpg":
    		flag_wait( "FLAG_start_rpg" );
    		
    		start_rpg();
            
			flag_set( "FLAG_start_courtyard" );
		case "start_courtyard":
			flag_wait( "FLAG_start_courtyard" );
			
			start_courtyard();
           	
	       	flag_set( "FLAG_start_chase" );
	    case "start_chase":
	    	flag_wait( "FLAG_start_chase" );
	    	
	    	start_chase();
	
			flag_set( "FLAG_start_bridge" );
		case "start_bridge":
			flag_wait( "FLAG_start_bridge" );
			
			start_bridge();
			
			flag_set( "FLAG_start_bridge_collapse" );
		case "start_bridge_collapse":
			flag_wait( "FLAG_start_bridge_collapse" );
			
			//thread bridge_collapse_setup();
			wait 100000;
			break;
		default:
			AssertMsg("Start point " + level.start_point + " isn't handled by level_manager" );
	}
}

catch_up_manager()
{
	wait 0.05; // let the start points initiate stuff first

	start = level.start_point;

	// DEFAULT
	/*
	if ( is_default_start() )
	{
	    flag_set( "FLAG_start_ac130" );
		return;
	}
	*/
	
	// DEMO
	
	if ( is_demo() )
	{
		start = "start_e3";
		level.start_point = start;
	}
	
	// START INTRO
	
	// catch_up_intro();
	
	if ( start == "start_intro" ) 
	{
		flag_set( "FLAG_start_intro" );
		return;
	}
	
	// START AC130
	
	catch_up_ac130();
	
	if ( start == "start_ac130" ) 
	{
		flag_set( "FLAG_start_ac130" );
		return;
	}
	
	// START FDR
	
	catch_up_fdr();
	
	if ( start == "start_fdr" ) 
	{
		flag_set( "FLAG_start_fdr" );
		return;
	}
	
	// START E3
	
	catch_up_e3();
	
	if ( start == "start_e3" )
	{
		flag_set( "FLAG_start_e3" );
		return;
	}
	
	// START STREET
	
	catch_up_street();
	
	if ( start == "start_street" )
	{
		flag_set( "FLAG_start_street" );
		return;
	}
	
	// START RPG
	
	catch_up_rpg();
	
	if ( start == "start_rpg" )
	{
		flag_set( "FLAG_start_rpg" );
		return;
	}
    
    // COURTYARD
    
    catch_up_courtyard();
     
    if ( start == "start_courtyard" )
	{
		flag_set( "FLAG_start_courtyard" );
		return;
	}
	
	// START CHASE
	
	catch_up_chase();
	
	if ( start == "start_chase" )
	{
		flag_set( "FLAG_start_chase" );
		return;
	}
	
	// START BRIDGE
	
	catch_up_bridge();
	
	if ( start == "start_bridge" )
	{
		flag_set( "FLAG_start_bridge" );
		return;
	}
	
	// BRIDGE COLLAPSE
	
	wait 0.05;
	
	thread bridge_collapse_setup();
	
	if ( start == "start_bridge_collapse" )
	{
		flag_set( "FLAG_start_bridge_collapse" );
		return;
	}
}

start_no_game()
{
	while ( !IsDefined( level.start_point ) )
		wait 0.05;
	if ( level.start_point == "no_game" )
		if ( IsDefined( level.intro_black ) )
			level.intro_black Destroy();
}

level_hints()
{
	timeout = 5.0;
	level.player delayThread( timeout + 3.0, ::display_hint_timeout, "HINT_ac130_thermal_vision", timeout );
	level.player delayThread( 2 * timeout + 3.0, ::display_hint_timeout, "HINT_ac130_using_zoom", timeout );
	level.player delayThread( 3 * timeout + 3.0, ::display_hint_timeout, "HINT_ac130_change_weapons", timeout );
}

level_sky()
{
	sky_normal = GetEnt( "sky_thermal", "targetname" ); // actually sky_normal
	Assert( IsDefined( sky_normal ) );

	sky_normal_active = true;
	
	for ( ; ; ) 
	{
		if ( flag( "FLAG_ac130_player_in_ac130" ) )
		{
			if ( flag( "FLAG_ac130_thermal_enabled" ) && sky_normal_active )
			{
				sky_normal Hide();
				sky_normal_active = false;
			}
			else 
			if ( flag( "FLAG_ac130_enhanced_vision_enabled" ) && !sky_normal_active )
			{
				sky_normal Show();
				sky_normal_active = true;
			}
		}
		else
		{
			if ( !sky_normal_active )
			{
				sky_normal Show();
				sky_normal_active = true;
			}
		}
		wait 0.05;
	}
}

level_destructibles()
{
	rpg_building = GetEnt( "rpg_building", "script_noteworthy" );
	Assert( IsDefined( rpg_building ) );
	rpg_building SetCanDamage( false );
	
	index = common_scripts\_destructible_types::getInfoIndex( "toy_building_collapse_paris_ac130" );
	if ( index > -1 )
		level.destructible_type[ index ].parts[ 0 ][ 0 ].v[ "health" ] = 1000000;
	
	chunks = getentarray( "courtyard_building_des_a_damage", "targetname" );
    array_thread( chunks, maps\paris_ac130_slamzoom::hide_me );
    
	// Clean up
	
	flag_wait( "FLAG_chase_started" );
	
	cleanup_spots = getstructarray_delete( "intro_cleanup", "targetname" );
	cleanup_spots = array_combine( cleanup_spots, getstructarray_delete( "fdr_cleanup", "targetname" ) );
	cleanup_spots = array_combine( cleanup_spots, getstructarray_delete( "street_cleanup", "targetname" ) );
	cleanup_spots = array_combine( cleanup_spots, getstructarray_delete( "courtyard_cleanup", "targetname" ) );
	
	ents_to_delete = [];
	ents = GetEntArray();
	
	foreach ( ent in ents )
	{
		if ( !IsDefined( ent ) )
			continue;
			
		foreach ( spot in cleanup_spots )
		{
			if ( dsq_2d_lt( spot.origin, ent.origin, spot.radius, 1500 ) )
			{
				ents_to_delete[ ents_to_delete.size ] = ent;
				continue;
			}
		}
	}
	
	foreach ( ent in ents_to_delete )
	{
		if ( !IsDefined( ent ) || is_in_array( level.delta, ent ) || ent == level.makarov_number_2 || 
			 ent compare_value( "targetname", "city_area_rpg_building_debris_1" )|| 
			 ent compare_value( "targetname", "city_area_rpg_building_debris_2" ) ||
			 ent compare_value( "targetname", "chase_player_focus" ) ||
			 ent compare_value( "targetname", "chase_pfr_t72" ) || 
			 ent compare_value( "targetname", "chase_pfr_mi17" ) || 
			 ent compare_value( "script_noteworthy", "intelligence_item" ) ||
			 ent compare_value( "script_noteworthy", "rpg_building" ) )
			continue;
		ent notify( "death" );
		ent notify( "stopfiring" );
		ent notify( "stop_using_built_in_burst_fire" );
		wait 0.05;
		if ( IsDefined( ent ) )
		{
			ent Delete();
			animscripts\battlechatter::update_bcs_locations();
		}
	}
}

level_swaps()
{
	 // RPG Building
    
    debris = GetEntArray( "city_area_rpg_building_debris_1", "targetname" );
    debris = array_combine( debris, GetEntArray( "city_area_rpg_building_debris_2", "targetname" ) );
    
    foreach ( item in debris )
    	item Hide();
    	
	// Courtyard Trees
	
	trees = GetEntArray( "prs_ac_courtyard_trees_ground", "targetname" );
	foreach ( tree in trees )
		tree Hide();
		
	courtyard_objects = GetEntArray( "courtyard_building_des_a_damage", "targetname" );
    courtyard_objects = array_combine( courtyard_objects, GetEntArray( "courtyard_building_des_b_damage", "targetname" ) );
    courtyard_objects = array_combine( courtyard_objects, GetEntArray( "courtyard_building_des_c_damage", "targetname" ) );
    
    array_call( courtyard_objects, ::Hide );
    array_call( courtyard_objects, ::NotSolid );
}

level_thermal_objects()
{
	/*
	rpg_com_units = GetEntArray( "rpg_building_com_units", "targetname" );
	Assert( IsDefined( rpg_com_units ) );
	
	foreach ( unit in rpg_com_units )
		unit ThermalDrawEnable();
	*/
}

level_death_fx()
{
	// Override Death FX
	
	classnames = [ "script_vehicle_t72_tank_ac130" ];
			   
	foreach ( classname in classnames )
	{
		foreach ( i, index in level.vehicle_death_fx[ classname ] )
			level.vehicle_death_fx[ classname ][ i ] = undefined;
		level.vehicle_death_fx_override[ classname ] = true;
	}
	level.vehicle_death_fx[ "script_vehicle_t72_tank_ac130" ][ 0 ] = 
		maps\_vehicle::build_fx( "explosions/vehicle_explosion_t72_ac130", "tag_deathfx", undefined, undefined, undefined, undefined, 0 );
	level.vehicle_death_fx[ "script_vehicle_t72_tank_ac130" ][ 1 ] = 
		maps\_vehicle::build_fx( "explosions/ac_prs_fx_flir_debris_explosion_a", "tag_deathfx", undefined, undefined, undefined, undefined, 0 );
}

level_enemy_killed()
{
	sounds_both = [];
    
    // ** 8-20 Yeahhheaahhh.
    //sounds_both[ sounds_both.size ] = level.scr_sound[ "fco" ][ "ac130_fco_yeah" ]; 
	// 3-23 Good kill.  Good kill.
	sounds_both[ sounds_both.size ] = level.scr_sound[ "tvo" ][ "ac130_tvo_goodkill" ];
	// 4-19 Ka-boom.
	//sounds_both[ sounds_both.size ] = level.scr_sound[ "fco" ][ "ac130_fco_kaboom" ];
    // 4-20 Niiiiiiiice.
    sounds_both[ sounds_both.size ] = level.scr_sound[ "fco" ][ "ac130_fco_nice" ];
    // 4-22 You got em.
 	sounds_both[ sounds_both.size ] = level.scr_sound[ "fco" ][ "ac130_fco_yougotem" ];
    // 4-23 Yeah, direct hits right there.
    sounds_both[ sounds_both.size ] = level.scr_sound[ "fco" ][ "ac130_fco_directhits" ];
    // 4-24 Theeeere we go.
    sounds_both[ sounds_both.size ] = level.scr_sound[ "fco" ][ "ac130_fco_therewego" ]; 
    // 4-25 Good shot.
    sounds_both[ sounds_both.size ] = level.scr_sound[ "fco" ][ "ac130_fco_goodshot" ];
    // 4-28 Wicked.
    sounds_both[ sounds_both.size ] = level.scr_sound[ "fco" ][ "ac130_fco_wicked" ];
    // 100-23 That's one down.
    //sounds_both[ sounds_both.size ] = level.scr_sound[ "tvo" ][ "ac130_tvo_onedown" ];
    // 8-9 Daaaaaaamn.
    sounds_both[ sounds_both.size ] =  level.scr_sound[ "fco" ][ "ac130_tvo_damn" ];
    // 8-24 Yeah, he's toast.
    sounds_both[ sounds_both.size ] =  level.scr_sound[ "hit" ][ "ac130_hit_hestoast" ];
    
    array_both = [];
    for ( i = 0; i < sounds_both.size; i++ )
    	array_both[ array_both.size ] = i;
    
    // T72
    
    sounds_t72 = [];
    
    // 16-1 Good. You got the tank.
    sounds_t72[ sounds_t72.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_gotthetank" ];
    // 16-18 Yeah, that tank isn't going anywhere.
    sounds_t72[ sounds_t72.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_goinganywhere" ];
    
    array_t72 = [];
    for ( i = 0; i < sounds_t72.size; i++ )
    	array_t72[ array_t72.size ] = i;
    
    // MI17
    	
   	sounds_mi17 = [];
    
    // 16-2 Enemy bird is down.
    sounds_mi17[ sounds_mi17.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_birddown" ];
    
    array_mi17 = [];
    for ( i = 0; i < sounds_mi17.size; i++ )
    	array_mi17[ array_mi17.size ] = i;
    
    // BTR
    
    sounds_btr = [];
    
    // 16-16 BTR is down.
    sounds_btr[ sounds_btr.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_btrisdown" ];
    
    array_btr = [];
    for ( i = 0; i < sounds_btr.size; i++ )
    	array_btr[ array_btr.size ] = i;
    
    // HIND
    	
    sounds_hind = [];
    
    // 16-2 Enemy bird is down.
    sounds_hind[ sounds_hind.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_birddown" ];
    // 16-17 That hind's toast.
    sounds_hind[ sounds_hind.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_hindistoast" ];
    
    array_hind = [];
    for ( i = 0; i < sounds_hind.size; i++ )
    	array_hind[ array_hind.size ] = i;
    				
    delay = 0.5;
    confirm_delay = 0.25;
    index_both = 0;
    index_t72 = 0;
    index_mi17 = 0;
    index_btr = 0;
    index_hind = 0;
	
	for ( ; ; )
	{
		if ( flag( "FLAG_ac130_player_in_ac130" ) && 
		     level.enemy_kill_dialogue_enabled && 
		     ( level.enemy_ai_killed || level.enemy_vehicle_killed ) )
		{
			both = ter_op( random_chance( 0.9 ), 1, 0 );
			
			if ( !both && level.enemy_vehicle_killed )
			{
				if ( level.enemy_t72_killed )
				{
					if ( array_t72.size == 0 )
					{
						for ( i = 0; i < sounds_t72.size; i++ )
			    			array_t72[ array_t72.size ] = i;
			    		if ( array_t72.size > 1 )
			    			array_t72 = array_remove_index( array_t72, index_t72 );
			    	}
					
					index_t72 = RandomInt( array_t72.size );
					
					wait confirm_delay;
					thread vehicle_scripts\_ac130::playSoundOverRadio( sounds_t72[ array_t72[ index_t72 ] ], false, 4.0 );
			    	array_t72 = array_remove_index( array_t72, index_t72 );
				}
				else
				if ( level.enemy_mi17_killed )
				{
					if ( array_mi17.size == 0 )
					{
						for ( i = 0; i < sounds_mi17.size; i++ )
			    			array_mi17[ array_mi17.size ] = i;
			    		if ( array_mi17.size > 1 )
			    			array_mi17 = array_remove_index( array_mi17, index_mi17 );
			    	}
					
					index_mi17 = RandomInt( array_mi17.size );
					
					wait confirm_delay;
					thread vehicle_scripts\_ac130::playSoundOverRadio( sounds_mi17[ array_mi17[ index_mi17 ] ], false, 4.0 );
			    	array_t72 = array_remove_index( array_mi17, index_mi17 );
				}
				else
				if ( level.enemy_btr_killed )
				{
					if ( array_btr.size == 0 )
					{
						for ( i = 0; i < sounds_btr.size; i++ )
			    			array_btr[ array_btr.size ] = i;
			    		if ( array_btr.size > 1 )
			    			array_btr = array_remove_index( array_btr, index_btr );
			    	}
					
					index_btr = RandomInt( array_btr.size );
					
					wait confirm_delay;
					thread vehicle_scripts\_ac130::playSoundOverRadio( sounds_btr[ array_btr[ index_btr ] ], false, 4.0 );
			    	array_btr = array_remove_index( array_btr, index_btr );
				}
				else
				if ( level.enemy_hind_killed )
				{
					if ( array_hind.size == 0 )
					{
						for ( i = 0; i < sounds_hind.size; i++ )
			    			array_hind[ array_hind.size ] = i;
			    		if ( array_hind.size > 1 )
			    			array_hind = array_remove_index( array_hind, index_hind );
			    	}
					
					index_hind = RandomInt( array_hind.size );
					
					wait confirm_delay;
					thread vehicle_scripts\_ac130::playSoundOverRadio( sounds_hind[ array_hind[ index_hind ] ], false, 4.0 );
			    	array_hind = array_remove_index( array_hind, index_hind );
				}
				else
				{
					if ( array_both.size == 0 )
		    		{
						for ( i = 0; i < sounds_both.size; i++ )
			    			array_both[ array_both.size ] = i;
			    		if ( array_both.size > 1 )
			    			array_both = array_remove_index( array_both, index_both );
			    	}
					
					index_both = RandomInt( array_both.size );
					
					wait confirm_delay;
					thread vehicle_scripts\_ac130::playSoundOverRadio( sounds_both[ array_both[ index_both ] ], false, 4.0 );
			    	array_both = array_remove_index( array_both, index_both );
		    	}
	    	}
	    	else
	    	{
	    		if ( array_both.size == 0 )
	    		{
					for ( i = 0; i < sounds_both.size; i++ )
		    			array_both[ array_both.size ] = i;
		    		if ( array_both.size > 1 )
		    			array_both = array_remove_index( array_both, index_both );
		    	}
				
				index_both = RandomInt( array_both.size );
				
				wait confirm_delay;
				thread vehicle_scripts\_ac130::playSoundOverRadio( sounds_both[ array_both[ index_both ] ], false, 4.0 );
		    	array_both = array_remove_index( array_both, index_both );
	    	}
			wait delay;
			level.enemy_ai_killed = false;
			level.enemy_vehicle_killed = false;
			level.enemy_btr_killed = false;
			level.enemy_hind_killed = false;
			level.enemy_mi17_killed = false;
			level.enemy_t72_killed = false;
		}
		else
			wait 0.05;
	}
}

// *************************************
// DELTA
// *************************************

delta_spawn_at_fast_point( location, fps )
{
	flag_clear( "FLAG_delta_spawned" );
	        
    _name = "";
    
    switch ( location )
    {
    	case "fdr":
    		_name = "fdr_delta_fast_point_";
    		break;
    	case "rpg":
    		_name = "rpg_delta_fast_point_";
    		break;
        case "street":
            _name = "street_delta_fast_point_";
            break;
        case "chase":
            _name = "chase_delta_fast_point_";
            break;
    }
    
    fast_points = get_ent_array_with_prefix( _name, "targetname", 0 );
    
    if ( !IsDefined( fast_points ) )
        return;
    
    foreach ( point in fast_points )
    {
    	point notify( "LISETN_stop_ANIM_guard_cover_idle_loop" );
		point notify( "LISTEN_stop_ANIM_guard_cover_out" );
		point notify( "LISTEN_stop_ANIM_guard_run_loop" );
		point notify( "LISTEN_stop_ANIM_guard_cover_into" );
		point notify( "LISTEN_stop_ANIM_hostage_cover_idle_loop" );
		point notify( "LISTEN_stop_ANIM_hostage_cover_out" );
		point notify( "LISTEN_stop_ANIM_hostage_run_loop" );
		point notify( "LISTEN_stop_ANIM_hostage_cover_into" );
    }
    
    // Remove old Delta + Makarov #2
    
    if ( IsDefined( level.delta ) && IsArray( level.delta ) )
    {
   	 	foreach ( guy in level.delta )
   	 	{
    		if ( IsDefined( guy ) )
    		{
    			guy notify( "reach_notify" );
    			guy notify( "death" );
    			guy Delete();
    		}
    	}
    }
   	
   	pips = [ level.sandman_fps_pip, level.sandman_shoulder_pip,
   			 level.frost_fps_pip, level.frost_shoulder_pip,
   			 level.gator_fps_pip, level.gator_shoulder_pip,
   			 level.hitman_fps_pip, level.hitman_shoulder_pip,
   			 level.bishop_fps_pip, level.bishop_shoulder_pip ];
   	
	foreach ( pip in pips )
		if ( IsDefined( pip ) )
			pip Delete();
			
   	if ( IsDefined( level.makarov_number_2 ) )
    	level.makarov_number_2 Delete();
    
    wait 0.05;
        
    level.delta = [];

    // Spawn Delta + Makarov #2
    
    array_spawn_function_pass_prefix_del_key( "delta_", "targetname", 0, ::ai_friendly_init );
    array_spawn_function_prefix( "delta_", "targetname", 0, ::ai_friendly_on_damage, 1 );
    delta_spawners = get_ent_array_with_prefix( "delta_", "targetname", 0 );
    
    foreach ( i, point in fast_points )
    {
        if ( i < ( fast_points.size - 1 ) )
        {
	        delta_spawners[ i ].count = 1;
	        delta_spawners[ i ].origin = point.origin;
	        delta_spawners[ i ].angles = point get_key( "angles" );
	        level.delta[ i ] = delta_spawners[ i ] StalingradSpawn();
	        fail = spawn_failed( level.delta[ i ] );
	        Assert( !fail );

			animset[ 0 ] = "ANIM_guard_cover_idle_loop";
			animset[ 1 ] = [ "ANIM_guard_cover_out" ];
			animset[ 2 ] = "ANIM_guard_run_loop";
			animset[ 3 ] = "ANIM_guard_cover_into";
	
			level.delta[ i ] set_parent_ai( animset );
			level.delta[ i ].animname = "generic";
    	}
    	else
    	{
    		makarov_number_2_spawner = GetEnt( "makarov_number_2", "targetname" );
			Assert( IsDefined( makarov_number_2_spawner ) );
			makarov_number_2_spawner add_spawn_function( ::ai_friendly_init, "makarov_number_2", "targetname" );
			makarov_number_2_spawner add_spawn_function( ::ai_friendly_on_damage, 0 );
			makarov_number_2_spawner.count = 1;
			makarov_number_2_spawner.origin = point.origin;
			makarov_number_2_spawner.angles = point get_key( "angles" );
			level.makarov_number_2 = makarov_number_2_spawner StalingradSpawn();
			fail = spawn_failed( level.makarov_number_2 );
			Assert( !fail );
			level.makarov_number_2 HidePart( "tag_weapon", "defaultweapon" );
			level.makarov_number_2.ignoreall = true;
			level.makarov_number_2.ignoreme = true;
			
			animset = [];
			animset[ 0 ] = "ANIM_hostage_cover_idle_loop";
			animset[ 1 ] = [ "ANIM_hostage_cover_out" ];
			animset[ 2 ] = "ANIM_hostage_run_loop";
			animset[ 3 ] = "ANIM_hostage_cover_into";
	
			level.makarov_number_2 set_child_ai( point, animset );
			level.makarov_number_2.animname = "generic";
    	}
    }
    
    level.sandman = level.delta[ 0 ];
    if ( IsDefined( level.sandman ) )
    	level.sandman.script_noteworthy = "sandman";
    level.frost = level.delta[ 1 ];
    if ( IsDefined( level.frost ) )
    	level.frost.script_noteworthy = "frost";
    level.hitman = level.delta[ 2 ];
    if ( IsDefined( level.hitman ) )
    	level.hitman.script_noteworthy = "hitman";
    level.gator = level.delta[ 3 ];
    if ( IsDefined( level.gator ) )
    	level.gator.script_noteworthy = "gator";
    level.bishop = level.delta[ 4 ];
    if ( IsDefined( level.bishop ) )
    	level.bishop.script_noteworthy = "bishop";
    
    if ( !IsDefined( fps ) )
    {
    	foreach ( guy in level.delta )
        	guy thread vehicle_scripts\_ac130::add_beacon_effect();
    }
    
	setup_friendly_pip();

    flag_set( "FLAG_delta_spawned" );
}

setup_friendly_pip()
{
	thread setup_sandman_pip();
	thread setup_frost_pip();
	thread setup_hitman_pip();
	thread setup_gator_pip();
	thread setup_bishop_pip();
	wait 0.05;
}

setup_sandman_pip()
{
	level.sandman.current_animname = level.sandman.animname;
	level.sandman.animname = "generic";
	level.sandman maps\_anim::anim_first_frame_solo( level.sandman, "setup_pose" );
			
	//PSUEDO FIRST-PERSON POV:
	spot = get_world_relative_offset( level.sandman.origin, level.sandman.angles, ( 12, 0, 0 ) );
	eye = level.sandman GetEye();	
	level.sandman_fps_pip = Spawn( "script_model", ( spot[ 0 ], spot[ 1 ], eye[ 2 ] ) );	
	level.sandman_fps_pip SetModel( "tag_origin" );
	level.sandman_fps_pip.angles = level.sandman.angles;
	level.sandman_fps_pip LinkTo( level.sandman, "j_neck" );	

	// SHOULDER CAM 
	offset = ( -14, -14, 63 );
	spot = get_world_relative_offset( level.sandman.origin, level.sandman.angles, offset );
	level.sandman_shoulder_pip = Spawn ( "script_model", spot );
	level.sandman_shoulder_pip SetModel ( "tag_origin" );
	level.sandman_shoulder_pip.angles = level.sandman.angles + ( 0, 6.8, 0 );
	level.sandman_shoulder_pip LinkTo( level.sandman, "j_neck" );

	level.sandman thread maps\_anim::anim_single_solo ( level.sandman, "setup_pose" );
	level.sandman delaycall( 0.05, ::setanimtime, level.scr_anim[ "generic" ][ "setup_pose" ], 0.99 );
		
	wait 0.05;
	
	level.sandman.animname = level.sandman.current_animname;
	level.sandman.current_animname = undefined;	
}

setup_frost_pip()
{
	level.frost.current_animname = level.frost.animname;
	level.frost.animname = "generic";
	level.frost maps\_anim::anim_first_frame_solo( level.frost, "setup_pose" );
			
	//PSUEDO FIRST-PERSON POV:
	spot = get_world_relative_offset( level.frost.origin, level.frost.angles, ( 12, 0, 0 ) );
	eye = level.frost GetEye();	
	level.frost_fps_pip = Spawn( "script_model", ( spot[ 0 ], spot[ 1 ], eye[ 2 ] ) );	
	level.frost_fps_pip SetModel( "tag_origin" );
	level.frost_fps_pip.angles = level.frost.angles;
	level.frost_fps_pip LinkTo( level.frost, "j_neck" );	

	// SHOULDER CAM 
	offset = ( -14, -14, 63 );
	spot = get_world_relative_offset( level.frost.origin, level.frost.angles, offset );
	level.frost_shoulder_pip = Spawn ( "script_model", spot );
	level.frost_shoulder_pip SetModel ( "tag_origin" );
	level.frost_shoulder_pip.angles = level.frost.angles + ( 0, 6.8, 0 );
	level.frost_shoulder_pip LinkTo( level.frost, "j_neck" );

	level.frost thread maps\_anim::anim_single_solo ( level.frost, "setup_pose" );
	level.frost delaycall( 0.05, ::setanimtime, level.scr_anim[ "generic" ][ "setup_pose" ], 0.99 );
		
	wait 0.05;
	
	level.frost.animname = level.frost.current_animname;
	level.frost.current_animname = undefined;	
}

setup_hitman_pip()
{
	level.hitman.current_animname = level.hitman.animname;
	level.hitman.animname = "generic";
	level.hitman maps\_anim::anim_first_frame_solo( level.hitman, "setup_pose" );
			
	//PSUEDO FIRST-PERSON POV:
	spot = get_world_relative_offset( level.hitman.origin, level.hitman.angles, ( 12, 0, 0 ) );
	eye = level.hitman GetEye();	
	level.hitman_fps_pip = Spawn( "script_model", ( spot[ 0 ], spot[ 1 ], eye[ 2 ] ) );	
	level.hitman_fps_pip SetModel( "tag_origin" );
	level.hitman_fps_pip.angles = level.hitman.angles;
	level.hitman_fps_pip LinkTo( level.hitman, "j_neck" );	

	// SHOULDER CAM 
	offset = ( -14, -14, 63 );
	spot = get_world_relative_offset( level.hitman.origin, level.hitman.angles, offset );
	level.hitman_shoulder_pip = Spawn ( "script_model", spot );
	level.hitman_shoulder_pip SetModel ( "tag_origin" );
	level.hitman_shoulder_pip.angles = level.hitman.angles + ( 0, 6.8, 0 );
	level.hitman_shoulder_pip LinkTo( level.hitman, "j_neck" );

	level.hitman thread maps\_anim::anim_single_solo ( level.hitman, "setup_pose" );
	level.hitman delaycall( 0.05, ::setanimtime, level.scr_anim[ "generic" ][ "setup_pose" ], 0.99 );
		
	wait 0.05;
	
	level.hitman.animname = level.hitman.current_animname;
	level.hitman.current_animname = undefined;	
}

setup_gator_pip()
{
	level.gator.current_animname = level.gator.animname;
	level.gator.animname = "generic";
	level.gator maps\_anim::anim_first_frame_solo( level.gator, "setup_pose" );
			
	//PSUEDO FIRST-PERSON POV:
	spot = get_world_relative_offset( level.gator.origin, level.gator.angles, ( 12, 0, 0 ) );
	eye = level.gator GetEye();	
	level.gator_fps_pip = Spawn( "script_model", ( spot[ 0 ], spot[ 1 ], eye[ 2 ] ) );	
	level.gator_fps_pip SetModel( "tag_origin" );
	level.gator_fps_pip.angles = level.gator.angles;
	level.gator_fps_pip LinkTo( level.gator, "j_neck" );	

	// SHOULDER CAM 
	offset = ( -14, -14, 63 );
	spot = get_world_relative_offset( level.gator.origin, level.gator.angles, offset );
	level.gator_shoulder_pip = Spawn ( "script_model", spot );
	level.gator_shoulder_pip SetModel ( "tag_origin" );
	level.gator_shoulder_pip.angles = level.gator.angles + ( 0, 6.8, 0 );
	level.gator_shoulder_pip LinkTo( level.gator, "j_neck" );

	level.gator thread maps\_anim::anim_single_solo ( level.gator, "setup_pose" );
	level.gator delaycall( 0.05, ::setanimtime, level.scr_anim[ "generic" ][ "setup_pose" ], 0.99 );
		
	wait 0.05;
	
	level.gator.animname = level.gator.current_animname;
	level.gator.current_animname = undefined;	
}

setup_bishop_pip()
{
	level.bishop.current_animname = level.bishop.animname;
	level.bishop.animname = "generic";
	level.bishop maps\_anim::anim_first_frame_solo( level.bishop, "setup_pose" );
			
	//PSUEDO FIRST-PERSON POV:
	spot = get_world_relative_offset( level.bishop.origin, level.bishop.angles, ( 12, 0, 0 ) );
	eye = level.bishop GetEye();	
	level.bishop_fps_pip = Spawn( "script_model", ( spot[ 0 ], spot[ 1 ], eye[ 2 ] ) );	
	level.bishop_fps_pip SetModel( "tag_origin" );
	level.bishop_fps_pip.angles = level.bishop.angles;
	level.bishop_fps_pip LinkTo( level.bishop, "j_neck" );	

	// SHOULDER CAM 
	offset = ( -14, -14, 63 );
	spot = get_world_relative_offset( level.bishop.origin, level.bishop.angles, offset );
	level.bishop_shoulder_pip = Spawn ( "script_model", spot );
	level.bishop_shoulder_pip SetModel ( "tag_origin" );
	level.bishop_shoulder_pip.angles = level.bishop.angles + ( 0, 6.8, 0 );
	level.bishop_shoulder_pip LinkTo( level.bishop, "j_neck" );

	level.bishop thread maps\_anim::anim_single_solo ( level.bishop, "setup_pose" );
	level.bishop delaycall( 0.05, ::setanimtime, level.scr_anim[ "generic" ][ "setup_pose" ], 0.99 );
		
	wait 0.05;
	
	level.bishop.animname = level.bishop.current_animname;
	level.bishop.current_animname = undefined;	
}

init_building_triggers()
{	
	trigger = GetEnt( "building_trigger", "targetname" );
	trigger thread building_trigger_mission_failed();
	
	trigger = GetEnt( "rpg_building_trigger", "targetname" );
	trigger thread rpg_building_trigger_mission_failed();
			
	thread building_trigger_reminder();
	thread monitor_mission_fail_points();
}

// *************************************
// INTRO
// *************************************
/*
catch_up_intro()
{
}

start_intro()
{
}
*/
intro_display_introscreen()
{
	level.player FreezeControls( true );
	
	wait 0.5;

	lines = [];
	//"Iron Lady"
	lines[ lines.size ] = &"PARIS_AC130_INTROSCREEN_LINE_1";
	//October 9th - 07:42:[{FAKE_INTRO_SECONDS:17}]
	lines[ lines.size ] = &"PARIS_AC130_INTROSCREEN_LINE_2";
	//Sgt. Derek "Frost" Westbrook
	lines[ lines.size ] = &"PARIS_AC130_INTROSCREEN_LINE_3";
	//Delta Force
	lines[ lines.size ] = &"PARIS_AC130_INTROSCREEN_LINE_4";
	//Paris, France
	lines[ lines.size ] = &"PARIS_AC130_INTROSCREEN_LINE_5";
	level thread maps\_introscreen::introscreen_feed_lines( lines );

	wait 1;
	level.intro_black FadeOverTime( 1 );
	level.intro_black.alpha = 0;
	wait 0.75;
	level.player FreezeControls( false );
	wait 0.05;
	level.intro_black Destroy();
}

intro_minimap()
{
	maps\_compass::setupMiniMap( "compass_map_paris_ac130_intro", "intro_minimap_corner" );
}

start_ac130_slamout()
{
	thread autosave_now();

	flag_wait( "FLAG_intro_osprey_1_crash_finished" );
	
	player_pos = level.player.origin;
	
	flag_wait( "FLAG_intro_slamout_start" );
	
	ac130_spawner = GetEnt( "ac130_vehicle", "targetname" );
	ac130_slamout = GetVehicleNode( "ac130_slamout", "targetname" );
	ac130_spawner.origin = ac130_slamout.origin;
	ac130_spawner.angles = ac130_slamout get_key( "angles" );
	
	thread init_building_triggers();
	war_spawn_ac130();
	war_setup_ac130_player();
	
	level.ac130_vehicle switch_vehicle_path( ac130_slamout );
	
	level.player FreezeControls( true );
	level.player delayCall( 0.05, ::FreezeControls, false );
	level.player SetPlayerAngles( ( 43.4379, 27.3719, 0 ) );
	vehicle_scripts\_ac130::ac130_set_view_arc( 0, 0, 0, 30, 45, 30, 10 );
	override_delayThread( 10.0, vehicle_scripts\_ac130::ac130_set_view_arc, [ 20, 10, 10, 45, 45, 35, 55 ] );
	override_delayThread( 30.0, vehicle_scripts\_ac130::ac130_set_view_arc, [ 20, 10, 10, 65, 65, 45, 65 ] );
	thread set_saved_dvar_over_time( "sm_sunsamplesizenear", 1.5, 30 );
	
	// Clean up any remaining ai
	
	ais = GetAIArray( "axis" );
	
	foreach( ai in ais )
	{
		ai notify( "death" );
		ai Delete();
	}
		
	vehicle_scripts\_ac130::set_badplace_max( 0 );
	musicplaywrapper("paris_ac130_flyover_war_mx");
	
	flag_set( "FLAG_building_trigger_mission_failed_on" );
	flag_set( "FLAG_delta_ac130_mission_fail" );
	flag_set( "FLAG_intro_dialogue_finished" ); // **TODO once osprey section comes live, need to resync
	flag_set( "FLAG_ac130_context_sensitive_dialog_filler" );
	flag_set( "FLAG_ac130_context_sensitive_dialog_kill" );
	flag_set( "FLAG_ac130_context_sensitive_dialog_guy_pain" );
	level.enemy_kill_dialogue_enabled = true;
	
	thread level_enemy_killed();
	thread level_hints();
	thread ac130_path( "loop_0" );
	thread war_clear_fx();
	thread ac130_slamout_dialogue();
			
	flag_set( "FLAG_war_finished" );
}

ac130_slamout_dialogue()
{
	flag_wait( "FLAG_intro_dialogue_finished" );
	flag_set( "FLAG_ac130_clear_to_engage" );
	
	// 2-1 Descending, crew.
	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_descending" ], true, 10.0 );
    
    wait 0.25;
    
    thread vehicle_scripts\_ac130::hud_recording_start();
    
    flag_set( "FLAG_fdr_mark_enemy_targets" );
	flag_set( "FLAG_fdr_mark_friendly_targets" );
	
    wait 0.25;
    
    // 17-4 Targeting system online.  TV, verify you see our friendlies.
     if ( !flag( "FLAG_fdr_enemy_vehicles_killed" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_seefriendlies" ], true, 10.0 );
    
    // 17-5 Roger that.  Friendlies are marked with white diamonds.
    if ( !flag( "FLAG_fdr_enemy_vehicles_killed" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "tvo" ][ "ac130_tvo_whitediamonds" ], true, 10.0 );
    
    wait 0.5;
    
    // 2-12 Just to, uhhhh,  confirm, crew - we are not clear to fire on the buildings.  We suspect there are civilians still inside at this point.
    if ( !flag( "FLAG_fdr_enemy_vehicles_killed" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "fco" ][ "ac130_fco_stillinside" ], true, 10.0 );
    
    // 2-13 Do not fire directly on the buildings.
    if ( !flag( "FLAG_fdr_enemy_vehicles_killed" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_donotfire" ], true, 10.0 );
    	
    wait 0.5;
    
    // 2-19 Metal Zero One, we have eyes on AO Hammer.  Confirm your location, over.
    if ( !flag( "FLAG_fdr_enemy_vehicles_killed" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_eyesonhammer" ], true, 10.0 );
    
    // 2-25 Ok. Need you to service targets 100 meters North of our location.
    if ( !flag( "FLAG_fdr_enemy_vehicles_killed" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_strobeson" ], true, 10.0 );
    
    // 2-26 Everything else except danger close is clear to shoot.
    if ( !flag( "FLAG_fdr_enemy_vehicles_killed" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_cleartoshoot" ], true, 10.0 );
    
    // 2-24 Copy that, Metal Zero One.  We gotcha.
    if ( !flag( "FLAG_fdr_enemy_vehicles_killed" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_wegotcha" ], true, 10.0 );
    
    wait 0.5;
    
    // 2-27 Crew - you are clear to engage any enemy personnel around you see.
    if ( !flag( "FLAG_fdr_enemy_vehicles_killed" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_engageany" ], true, 10.0 );
    		
    // 2-28 Keep fire south of the red smoke.
    if ( !flag( "FLAG_fdr_enemy_vehicles_killed" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_firesouth" ], true, 10.0 );
    
    flag_set( "FLAG_war_dialogue_finished" );
}

catch_up_ac130()
{
	wait 0.05;
	
	// START AC130

	flag_set( "allow_context_sensative_dialog" );
	flag_set( "FLAG_intro_opening_jet_dog_fight_starting" );
	flag_set( "FLAG_intro_opening_jet_dog_fight_finished" );
	flag_set( "FLAG_intro_ambient_jet_dog_fights_active" );
	flag_set( "FLAG_intro_osprey_event" );
	flag_set( "FLAG_intro_osprey_1_crash_ready" );
	flag_set( "FLAG_intro_player_knockout_start" );
	flag_set( "FLAG_intro_player_knockout_started" );
	flag_set( "FLAG_intro_osprey_1_minigun_stop" );
	flag_set( "FLAG_intro_osprey_1_crash_start" );
	flag_set( "FLAG_intro_osprey_1_crash_finished" );
	flag_set( "FLAG_intro_slamout_start" );
	flag_set( "FLAG_intro_ambient_jet_dog_fights_end" );
	flag_set( "FLAG_intro_dialogue_finished" );
	
	thread catch_up_ac130_fdr_setup();
	
	if ( IsDefined( level.intro_black ) && !is_demo() )
		level.intro_black Destroy();
	wait 0.05;
}

catch_up_ac130_fdr_setup()
{
	thread fdr_setup();
	flag_wait( "FLAG_fdr_t72s_spawned" );
	flag_clear( "FLAG_delta_spawned" );
	wait 0.05;
	flag_set( "FLAG_delta_spawned" );
}

war_spawn_ac130()
{
	ac130_spawner = GetEnt( "ac130_vehicle", "targetname" );
	level.ac130_vehicle = vehicle_spawn( ac130_spawner );
	wait 0.05;
	level.ac130_vehicle.targetname = "ac130_vehicle";
	level.ac130_vehicle Hide();
	ac130_spawner Delete();
}

war_setup_ac130_player()
{
	vehicle_scripts\_ac130::ac130_set_default_vision_set( "paris_ac130" );
	vehicle_scripts\_ac130::ac130_set_thermal_vision_set( "paris_ac130_thermal" );
	vehicle_scripts\_ac130::ac130_set_enhanced_vision_set( "paris_ac130_enhanced" );
	vehicle_scripts\_ac130::ac130_set_thermal_shock( "paris_ac130_thermal" );
	vehicle_scripts\_ac130::ac130_set_enhanced_shock( "paris_ac130_enhanced" );

	level.ac130_vehicle vehicle_scripts\_ac130::_ac130_init_player( level.player );
	level.ac130_projectile_callback = ::ac130_projectile_callback;

	// Shadows
    SetSavedDvar( "sm_sunenable", 1.0 );
    //SetSavedDvar( "sm_sunsamplesizenear", 2.9 );
    SetSavedDvar( "sm_sunShadowScale", 0.5 );
}

war_clear_fx()
{
	fx_ids = [ [ "cloud_bank_paris_ac130_start", 		( 0, 0, 0 ) ],
			   [ "cloud_bank_paris_ac130_start", 		( 63404.5, 25485, 8559.67 ) ],
			   [ "cloud_bank_paris_ac130_start", 		( 67451.3, 24379, 8732.65 ) ],
			   [ "FX_smoke_signal_osprey_blowing", 		( 4854.65, 46882.4, -25.0024 ) ],
			   [ "FX_c130_paratroop_aircaft", 			( -6844.95, 49043.9, 4389.57 ) ],
			   [ "FX_horizon_flash_runner_harbor", 		( 9508.63, 63816.3, 170.905 ) ],
			   [ "FX_horizon_flash_runner_harbor", 		( 23345, 55156.8, 1394.84 ) ],
			   [ "courtyard_fire", 						( 2677.99, 45474.4, 83.0253 ) ],
			   [ "firelp_cheap_mp", 					( 2811.44, 45462.9, 288.065 ) ],
			   [ "firelp_cheap_mp", 					( 2845.4, 45453.4, 257.434 ) ],
			   [ "firelp_cheap_mp", 					( 2792.94, 45391.9, 205.851 ) ],
			   [ "gazsmfire", 							( 3081.28, 45625.3, 172.126 ) ],
			   [ "gazsmfire", 							( 3021.24, 45626.6, 158.354 ) ],
			   [ "gazsmfire", 							( 3033.23, 45614.6, 235.752 ) ],
			   [ "fire_falling_runner_point_infrequent", ( 3067.53, 45622.3, 155.13 ) ],
			   [ "fire_falling_runner_point", 			( 2818.42, 45419.5, 203.23 ) ],
			   [ "FX_ac_prs_smoke_amb_1", 				( 3113.66, 45256.4, 39.4966 ) ],
			   [ "FX_ac_prs_smoke_amb_1", 				( 2525.91, 45228.1, 23.8144 ) ],
			   [ "fire_falling_runner_point", 			( 0, 0, 0 ) ],
			   [ "fire_falling_runner_point_infrequent", ( 0, 0, 0 ) ],
			   [ "battlefield_smokebank_S_warm", 		( 0, 0, 0 ) ],
			   [ "test_effect",							( 0, 0, 0 ) ] ];
	delete_createFXent_fx( fx_ids );
}

war_clean_up()
{
	clean_up_node = GetVehicleNode( "war_clean_up", "script_noteworthy" );
	Assert( IsDefined( clean_up_node ) );
	clean_up_node waittill( "trigger" );
	flag_set( "FLAG_war_clean_up" );
}

war_catch_up_clean_up()
{
	ents = [];
	
	foreach ( ent in ents )
	{
		if ( IsDefined( ent ) )
		{
			ent notify( "death" );
			ent Delete();
		}
	}	
	war_delete_structs();
}

war_delete_structs()
{
	structs =[];
	
	thread deletestructarray_ref( structs, 0.2 );
}

catch_up_fdr()
{
	wait 0.05;
	
	flag_set( "FLAG_ac130_clear_to_engage" );
	flag_set( "FLAG_building_trigger_mission_failed_on" );
	flag_set( "FLAG_delta_ac130_mission_fail" );
	flag_set( "FLAG_ac130_intro" );
	flag_set( "FLAG_war_clean_up" );
	flag_set( "FLAG_war_finished" );
	flag_set( "FLAG_war_dialogue_finished" );
	flag_set( "FLAG_fdr_mark_enemy_targets" );
	flag_set( "FLAG_fdr_mark_friendly_targets" );
			
	thread war_catch_up_clean_up();
	war_spawn_ac130();
	war_setup_ac130_player();
	war_clear_fx();
	thread vehicle_scripts\_ac130::hud_recording_start();
	
	level.enemy_kill_dialogue_enabled = true;
	
	thread level_enemy_killed();
	thread init_building_triggers();
	
	fdr_start_node = GetVehicleNode( "city_area_loop_0_check", "script_noteworthy" );
	level.ac130_vehicle switch_vehicle_path( fdr_start_node );
	
	thread ac130_path( "loop_0" );
}

ac130_minimap()
{
	// ( x, y ) -> ( -40208, 65820 )
	
	corner_1 = Spawn( "script_origin", ( -40208, 65820, 0 ) );
	corner_1.targetname = "compass_map_paris_ac130";
	corner_2 = Spawn( "script_origin", ( -40208 + 64384, 65820 - 72064, 0 ) );
	corner_2.targetname = "compass_map_paris_ac130";
	
	maps\_compass::setupMiniMap( "compass_map_paris_ac130", "compass_map_paris_ac130" );
	
	SetSavedDvar( "ui_hideMap", "1" );
}

start_fdr()
{
	flag_wait( "FLAG_war_finished" );

	ac130_minimap();		
	thread vehicle_scripts\_ac130::autosave_ac130();
	
	Objective_Add( obj( "OBJ_FDR_Clear_Area" ), "current", &"PARIS_AC130_OBJ_FDR_CLEAR_AREA_FOR_KILO_1_1" );
	
	vehicle_scripts\_ac130::set_badplace_max( 0 );
	
	fdr_osprey_setup();
	fdr_delta_init();
	vehicle_scripts\_ac130::ac130_set_view_arc( 15, 0, 0, 65, 65, 45, 55 );
	_flag = "FLAG_fdr_ac130_circling_fdr";
	level.ac130_vehicle thread set_level_flag_on_vehicle_node_notify( "city_area_loop_0_circling_fdr", "script_noteworthy", _flag );
	thread ac130_path( "loop_2" );
	
	thread fdr_vision_hints();
	thread fdr_zoom_hint();
	
	flag_set( "FLAG_ambient_ac130_effects" );
	flag_set( "FLAG_ambient_ac130_close_jets" );
	flag_set( "FLAG_ambient_ac130_close_mi17s" );
	flag_set( "FLAG_ac130_intro" );
	
	thread ambient_effects();
	
	thread fdr_delta_mark();
	thread fdr_dialogue();
	thread fdr_monitor_ac130_speed();
	thread fdr_enemy_vehicles_monitor();
	thread fdr_mi17s();
	thread fdr_enemies();
	thread fdr_carpet_bomb_timeout();
	thread fdr_carpet_bomb();
	thread fdr_signal_ac130();
	
	flag_wait( "FLAG_fdr_enemy_vehicles_killed" );
}

fdr_setup()
{
	thread fdr_t72s();
	thread fdr_btrs();
	thread fdr_bm21s();
}

fdr_vision_hints()
{
	timeout = 5.0;
	
	if ( flag( "FLAG_ac130_thermal_enabled" ) )
		level.player display_hint_timeout( "HINT_ac130_enhanced_vision", timeout );
	
	reminder = 30.0;
		
	while ( !flag( "FLAG_fdr_enemy_vehicles_killed" ) )
	{
		if ( flag( "FLAG_ac130_thermal_enabled" ) )
		level.player display_hint_timeout( "HINT_ac130_enhanced_vision", timeout );
		wait reminder;
	}
}

fdr_zoom_hint()
{
	flag_wait( "FLAG_ac130_loop_0" );
	timeout = 5.0;
	level.player thread display_hint_timeout( "HINT_ac130_using_zoom", timeout );
}

fdr_dialogue()
{
	flag_wait( "FLAG_war_dialogue_finished" );
    
    // 3-3 Confirmed - first targets.
    //if ( !flag( "FLAG_fdr_enemy_vehicles_killed" ) )
    //	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "tvo" ][ "ac130_tvo_firsttargets" ], true, 10.0 );
	
	flag_set( "FLAG_fdr_intro_dialogue_finished" );
    
    flag_wait( "FLAG_fdr_enemy_vehicles_killed" );

	if ( !flag( "FLAG_fdr_carpet_bombing_timeout" ) )
	{
		// 4-1 Warhammer, targets destroyed.  Thanks for the assist.
	    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_thanks" ], true, 10.0 );
	    
	    // 4-2 Solid copy, Metal Zero One.
	    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_solidcopy" ], true, 10.0 );
	}
    
    flag_set( "FLAG_fdr_dialogue_finished" );
}

ambient_effects()
{
	delayThread( 0.1, ::ambient_aa_fire_short );
	delayThread( 0.2, ::ambient_aa_fire_tracer );
	delayThread( 0.3, ::ambient_aa_fire_flash );
	delayThread( 0.4, ::ambient_clouds );
	//delayThread( 0.5, ::ambient_airbourne_vehicles_close_monitor_ac130 );
	delayThread( 0.6, ::ambient_jets_close );
	delayThread( 0.7, ::ambient_jets_far );
	//delayThread( 0.8, ::ambient_mi17s_close );
	//delayThread( 0.9, ::ambient_mi17s_far );
}

ambient_aa_fire_short()
{
	aa_fire_starts = getstructarray_delete( "ambient_aa_fire_short", "targetname", 0.25 );
	aa_fires = [];
	
	foreach ( i, start in aa_fire_starts )
	{
		aa_fires[ i ][ 0 ] = start;
		aa_fires[ i ][ 1 ] = getstruct_delete( start.target, "targetname" );
	}
	
	while ( !flag( "FLAG_end_ambient_ac130_effects" ) )
	{
		if ( flag( "FLAG_ambient_ac130_effects" ) )
		{
			fx = getfx( "FX_aa_fire_short_" + ( RandomInt( 4 ) + 1 ) );
			i = RandomInt( aa_fires.size );
			pos = aa_fires[ i ][ 0 ].origin;
			fwd = VectorNormalize( aa_fires[ i ][ 1 ].origin - aa_fires[ i ][ 0 ].origin );
			
			PlayFX( fx, pos, fwd );
			wait level.ambient_aa_fire_short_delay;
		}
		else
			wait 0.05;
	}
}

ambient_aa_fire_tracer()
{
	aa_fire_starts = getstructarray_delete( "ambient_aa_fire_tracer", "targetname", 0.25 );
	aa_fires = [];
	
	foreach ( i, start in aa_fire_starts )
	{
		aa_fires[ i ][ 0 ] = start;
		aa_fires[ i ][ 1 ] = getstruct_delete( start.target, "targetname" );
	}
	
	array = [];
    
    for ( i = 0; i < aa_fire_starts.size; i++ )
    	array[ array.size ] = i;
    			
	while ( !flag( "FLAG_end_ambient_ac130_effects" ) )
	{
		if ( flag( "FLAG_ambient_ac130_effects" ) )
		{
			if ( array.size == 0 )
			for ( i = 0; i < aa_fire_starts.size; i++ )
    			array[ array.size ] = i;
		
			index = RandomInt( array.size );
		
			fx = getfx( "FX_aa_fire_" + ( RandomInt( 3 ) + 1 ) );
			pos = aa_fires[ array[ index ] ][ 0 ].origin;
			fwd = VectorNormalize( aa_fires[ array[ index ] ][ 1 ].origin - aa_fires[ array[ index ] ][ 0 ].origin );
			
			thread play_fx_x_times( fx, pos, fwd, RandomInt( 4 ) + 1, 0.1 ); 
			wait level.ambient_aa_fire_tracer_delay;
			array = array_remove_index( array, index );
		}
		else
			wait 0.05;
	}
}

ambient_aa_fire_flash()
{
	aa_fire_flashes = get_connected_ents( "ambient_aa_fire_flash" );
	thread deletestructarray_ref( aa_fire_flashes, 0.25 );
	
	array = [];
    
    for ( i = 0; i < aa_fire_flashes.size; i++ )
    	array[ array.size ] = i;
    			
	while ( !flag( "FLAG_end_ambient_ac130_effects" ) )
	{
		if ( flag( "FLAG_ambient_ac130_effects" ) )
		{
			if ( array.size == 0 )
			for ( i = 0; i < aa_fire_flashes.size; i++ )
    			array[ array.size ] = i;
		
			index = RandomInt( array.size );
		
			fx = getfx( "FX_aa_fire_flash" );
			pos = aa_fire_flashes[ array[ index ] ].origin;
			fwd = ( 0, 0, 1 );
			
			PlayFX( fx, pos, fwd );
			wait level.ambient_aa_fire_flash_delay;
			array = array_remove_index( array, index );
		}
		else
			wait 0.05;
	}
}

ambient_clouds()
{
	clouds = get_connected_ents( "ambient_clouds" );
	thread deletestructarray_ref( clouds, 0.25 );
    
    fx = getfx( "FX_cloud_single" );
    
    cloud_tags = [];
    
    foreach ( i, cloud in clouds )
    {
    	cloud_tags[ i ] = Spawn( "script_model", cloud.origin );
    	cloud_tags[ i ] SetModel( "tag_origin" );
    }
    			
	while ( !flag( "FLAG_end_ambient_ac130_effects" ) )
	{
		flag_wait( "FLAG_ambient_ac130_effects" );
		
		foreach( _tag in cloud_tags )
			PlayFXOnTag( fx, _tag, "tag_origin" );
		
		flag_waitopen( "FLAG_ambient_ac130_effects" );
		
		foreach( _tag in cloud_tags )
			StopFXOnTag( fx, _tag, "tag_origin" );
	}
}

ambient_airbourne_vehicles_close_monitor_ac130()
{
	// INTRO
	
	intro_path = get_connected_ents( "open_area_slamzoom_out_out" );
	jet_node = get_ents_from_array( 1, "script_index", intro_path )[ 0 ];
	
	_flag = "FLAG_ac130_intro";
	level.ac130_vehicle thread set_level_flag_on_vehicle_node_notify( jet_node.targetname, "targetname", _flag );
	
	flag_wait( "FLAG_ac130_intro" );
	
	level.ac130_current_spline = "intro";
	level.ac130_current_spline_section = 1;
	
	// LOOP 0
	
	flag_wait( "FLAG_fdr_ac130_circling_fdr" );
	
	level.ac130_current_spline = "loop_0";
	level.ac130_current_spline_section = 2;
			
	loop_0_path = get_connected_ents( "city_area_loop_0_out" );
	jet_nodes = [];
	
	for( i = 1; i <= 4; i++ )
		jet_nodes[ i ] = get_ents_from_array( i, "script_index", loop_0_path )[ 0 ];
	
	i = 3;
		
	while( !flag( "FLAG_fdr_enemy_vehicles_killed" ) )
	{
		i = ter_op( i > 4, 1, i );
		jet_nodes[ i ] waittill( "trigger" );
		level.ac130_current_spline_section = i;
		i++;
	}
	
	// LOOP 0 to 2
	
	flag_wait( "FLAG_ac130_loop_0_to_2" );
	
	level.ac130_current_spline = "loop_0_to_2";
	level.ac130_current_spline_section = 1;
	
	// LOOP 2
	
	flag_wait( "FLAG_ac130_loop_2" );
	
	level.ac130_current_spline = "loop_2";
	level.ac130_current_spline_section = 2;
	
	loop_2_path = get_connected_ents( "city_area_loop_2_out" );
	jet_nodes = [];
	
	for( i = 1; i <= 4; i++ )
		jet_nodes[ i ] = get_ents_from_array( i, "script_index", loop_2_path )[ 0 ];
	
	i = 3;
	timeout = 25.0;

	while( !( flag( "FLAG_street_ma_3_delta_move_down" ) ) )
	{
		i = ter_op( i > 4, 1, i );
		jet_nodes[ i ] waittill_any_timeout( timeout, "trigger" );
		level.ac130_current_spline_section = i;
		i++;
	}
	
	// LOOP 2 to 3
	
	flag_wait( "FLAG_ac130_loop_2_to_3" );
	
	level.ac130_current_spline = "loop_2_to_3";
	level.ac130_current_spline_section = 1;
	
	// LOOP 3
	
	flag_wait( "FLAG_ac130_loop_3" );
	
	level.ac130_current_spline = "loop_3";
	level.ac130_current_spline_section = 2;
	
	loop_3_path = get_connected_ents( "city_area_loop_3_out" );
	jet_nodes = [];
	
	for( i = 1; i <= 4; i++ )
		jet_nodes[ i ] = get_ents_from_array( i, "script_index", loop_3_path )[ 0 ];
	
	i = 3;
	timeout = 25.0;

	while( !( flag( "FLAG_rpg_ac130_angel_flare_start" ) ) )
	{
		i = ter_op( i > 4, 1, i );
		jet_nodes[ i ] waittill_any_timeout( timeout, "trigger" );
		level.ac130_current_spline_section = i;
		i++;
	}
	
	// LOOP 4
	
	flag_wait( "FLAG_ac130_loop_4" );
	
	level.ac130_current_spline = "loop_4";
	level.ac130_current_spline_section = 3;
	
	loop_4_path = get_connected_ents( "city_area_loop_4_out" );
	jet_nodes = [];
	
	for( i = 1; i <= 4; i++ )
		jet_nodes[ i ] = get_ents_from_array( i, "script_index", loop_4_path )[ 0 ];
	
	i = 3;
	timeout = 60.0;

	while( !flag( "FLAG_courtyard_slamzoom_out_finished" ) )
	{
		i = ter_op( i > 4, 1, i );
		jet_nodes[ i ] waittill_any_timeout( timeout, "trigger" );
		level.ac130_current_spline_section = i;
		i++;
	}
	
	// LOOP 5
	
	level.ac130_current_spline = "loop_5";
	level.ac130_current_spline_section = 1;
	
	loop_5_path = get_connected_ents( "chase_start_friendly_vehicles" );
	jet_nodes = [];
	
	for( i = 1; i <= 3; i++ )
		jet_nodes[ i ] = get_ents_from_array( i, "script_index", loop_4_path )[ 0 ];
	
	timeout = 60.0;

	for( i = 1; i <= 3; i++ )
	{
		jet_nodes[ i ] waittill_any_timeout( timeout, "trigger" );
		level.ac130_current_spline_section = i;
		i++;
	}
	
	// CHASE
	
	flag_wait( "FLAG_chase_started" );
}

ambient_jets_close()
{
	ac130_far_view_plane = 14000;
	ac130_mid_view_plane = 7000;
	ac130_rear_view_plane = 20000;
	
	max_height = -2048;
	min_height = -3600;
	travel_distance = 80000;
	speed = 7500; // units / sec
	time = travel_distance * ( 1 / speed );
	arc_buffer = 5;
				// fwd, right, up 
	mig_offset = [ 64, 256, 64 ];
	jet_angle_delta = 1;
	max_delay = 15.0;
	min_delay = 10.0;
	
	while ( !flag( "FLAG_end_ambient_ac130_effects" ) )
	{
		if ( flag( "FLAG_ambient_ac130_effects" ) && flag( "FLAG_ambient_ac130_close_jets" ) )
		{
			turret_target = level.ac130_player_view_controller GetTurretTarget( 0 );
			yaw = level.ac130.angles[ 2 ];
			
			if ( IsDefined( turret_target ) )
				yaw = VectorToYaw( turret_target.origin - level.ac130_player_view_controller.origin );
			yaw = modulus_float( yaw, 360 );
			
			right_arc_180 = gt_op( modulus_float( yaw - level.ac130_current_right_arc - arc_buffer, 360 ), 1 );
			left_arc_180 = gt_op( modulus_float( yaw + level.ac130_current_left_arc + arc_buffer, 360 ), 1 );
			
			if ( right_arc_180 == left_arc_180 )
			{
				right_arc_180--;
				left_arc_180++;
			}
			
			max = ter_op( left_arc_180 > right_arc_180, left_arc_180, right_arc_180 );
			min = ter_op( left_arc_180 < right_arc_180, left_arc_180, right_arc_180 );
			
			angles = ( 0, RandomFloatRange( max, max + 360 - min ), 0 );
			
			f15_spot = level.ac130.origin + ( ac130_rear_view_plane * AnglesToForward( angles ) );
			random_view_spot = level.ac130.origin + RandomFloatRange( ac130_mid_view_plane, ac130_far_view_plane ) * AnglesToForward( ( 0, level.ac130.angles[ 1 ], 0 ) );
			f15_angles = VectorToAngles( random_view_spot - f15_spot ) + ( 0, RandomFloatRange( -1 * jet_angle_delta, jet_angle_delta ), 0 );
			
			fwd = AnglesToForward( f15_angles );
			right = AnglesToRight( f15_angles );
			up = AnglesToUp( f15_angles );
			
			f15_spots = [];
			count = 1;
			
			rand = RandomInt( 100 );
		
			if ( rand <= 4 )
				count = 4;
			else
			if ( rand <= 8 )
				count = 3;
			else
			if ( rand <= 35 )
				count = 2;
			
			last_spot = f15_spot;
			last_spot += ( 0, 0, RandomFloatRange( min_height, max_height ) );
			
			for ( i = 0; i < count; i++ )
			{
				f15_spots[ i ] = last_spot;
				f15_spots[ i ] += random_sign() * RandomFloatRange( 16, 32 ) * up;
				f15_spots[ i ] -= RandomFloatRange( 1024, 2048 ) * fwd;
				f15_spots[ i ] += random_sign() * RandomFloatRange( 512, 1024 ) * right;
				last_spot = f15_spots[ i ];
			}
			
			f15_ends = [];
			
			foreach ( spot in f15_spots )
				f15_ends[ f15_ends.size ] = spot + travel_distance * fwd;
			
			mig_spots = [];
			mig_ends = [];
			mig_angles = f15_angles;
			
			foreach ( i, spot in f15_spots )
			{
				mig_spots[ i ] = spot;
				mig_spots[ i ] += ter_op( RandomInt( 2 ), mig_offset[ 0 ], -1 * mig_offset[ 0 ] ) * fwd;
				mig_spots[ i ] += ter_op( RandomInt( 2 ), mig_offset[ 1 ], -1 * mig_offset[ 1 ] ) * right;
				mig_spots[ i ] += ter_op( RandomInt( 2 ), mig_offset[ 1 ], -1 * mig_offset[ 2 ] ) * up;
				mig_ends[ i ] = mig_spots[ i ] + travel_distance * fwd;
			}
			
			foreach ( i, spot in mig_spots )
			{
				mig = Spawn( "script_model", spot );
				mig.angles = mig_angles;
				mig SetModel( "vehicle_mig29_low" );
				
				mig thread enemy_mig29_init_fake();
				rand = RandomFloatRange( 0.25, 0.45 );
				mig thread enemy_mig29_fake_play_afterburner( rand * time );
				point = point_between_2_points( rand, spot, mig_ends[ i ] );
				mig thread enemy_mig29_fake_sonic_boom( point, "veh_paris_ac130_jet_sonic_boom" );
				
				mig MoveTo( mig_ends[ i ], time, 0.05, 0.05 );
				mig RotateRoll( RandomFloat( 360 * RandomIntRange( 2, 6 ) ), time );
				mig thread enemy_mig29_fake_delete( time );
				if ( random_chance( 0.02 ) )
					mig delayThread( 0.15 * time, ::enemy_mig29_fake_damage_and_explode );
				wait 0.05;
			}
			
			wait 0.5;
			
			foreach ( i, spot in f15_spots )
			{
				f15 = Spawn( "script_model", spot );
				f15.angles = f15_angles;
				f15 SetModel( "vehicle_f15_low" );
				
				f15 thread friendly_f15_init_fake();
				rand = RandomFloatRange( 0.25, 0.45 );
				f15 thread friendly_f15_fake_play_afterburner( rand * time );
				point = point_between_2_points( rand, spot, f15_ends[ i ] );
				f15 thread friendly_f15_fake_sonic_boom( point, "veh_paris_ac130_jet_sonic_boom" );
				
				f15 MoveTo( f15_ends[ i ], time, 0.05, 0.05 );
				if ( random_chance( 0.1 ) )
					f15 thread friendly_f15_fake_shoot_mg();
				f15 RotateRoll( RandomFloat( 360 * RandomIntRange( 2, 6 ) ), time );
				f15 thread friendly_f15_fake_delete( time );
				wait 0.05;
			}
			wait RandomFloatRange( min_delay, max_delay );
		}
		else
			wait 0.05;
	}
}

ambient_jets_far()
{
	ac130_far_view_plane = 20000;
	ac130_mid_view_plane = 12000;
	ac130_rear_view_plane = 30000;
	
	max_height = -3400;
	min_height = -3600;
	travel_distance = 90000;
	speed = 7500; // units / sec
	time = travel_distance * ( 1 / speed );
	arc_buffer = 5;
				// fwd, right, up 
	mig_offset = [ 64, 256, 64 ];
	jet_angle_delta = 1;
	max_delay = 20.0;
	min_delay = 12.0;
	
	while ( !flag( "FLAG_end_ambient_ac130_effects" ) )
	{
		if ( flag( "FLAG_ambient_ac130_effects" ) )
		{
			turret_target = level.ac130_player_view_controller GetTurretTarget( 0 );
			yaw = level.ac130.angles[ 2 ];
			
			if ( IsDefined( turret_target ) )
				yaw = VectorToYaw( turret_target.origin - level.ac130_player_view_controller.origin );
			yaw = modulus_float( yaw, 360 );
			
			right_arc_180 = gt_op( modulus_float( yaw - level.ac130_current_right_arc - arc_buffer, 360 ), 1 );
			left_arc_180 = gt_op( modulus_float( yaw + level.ac130_current_left_arc + arc_buffer, 360 ), 1 );
			
			if ( right_arc_180 == left_arc_180 )
			{
				right_arc_180--;
				left_arc_180++;
			}
			
			max = ter_op( left_arc_180 > right_arc_180, left_arc_180, right_arc_180 );
			min = ter_op( left_arc_180 < right_arc_180, left_arc_180, right_arc_180 );
			
			angles = ( 0, RandomFloatRange( max, max + 360 - min ), 0 );
			
			f15_spot = level.ac130.origin + ( ac130_rear_view_plane * AnglesToForward( angles ) );
			random_view_spot = level.ac130.origin + RandomFloatRange( ac130_mid_view_plane, ac130_far_view_plane ) * AnglesToForward( ( 0, level.ac130.angles[ 1 ], 0 ) );
			f15_angles = VectorToAngles( random_view_spot - f15_spot ) + ( 0, RandomFloatRange( -1 * jet_angle_delta, jet_angle_delta ), 0 );
			
			fwd = AnglesToForward( f15_angles );
			right = AnglesToRight( f15_angles );
			up = AnglesToUp( f15_angles );
			
			f15_spots = [];
			count = 1;
			
			rand = RandomInt( 100 );
		
			if ( rand <= 4 )
				count = 4;
			else
			if ( rand <= 8 )
				count = 3;
			else
			if ( rand <= 35 )
				count = 2;
			
			last_spot = f15_spot;
			last_spot += ( 0, 0, RandomFloatRange( min_height, max_height ) );
			
			for ( i = 0; i < count; i++ )
			{
				f15_spots[ i ] = last_spot;
				f15_spots[ i ] += random_sign() * RandomFloatRange( 16, 32 ) * up;
				f15_spots[ i ] -= RandomFloatRange( 1024, 2048 ) * fwd;
				f15_spots[ i ] += random_sign() * RandomFloatRange( 512, 1024 ) * right;
				last_spot = f15_spots[ i ];
			}
			
			f15_ends = [];
			
			foreach ( spot in f15_spots )
				f15_ends[ f15_ends.size ] = spot + travel_distance * fwd;
			
			mig_spots = [];
			mig_ends = [];
			mig_angles = f15_angles;
			
			foreach ( i, spot in f15_spots )
			{
				mig_spots[ i ] = spot;
				mig_spots[ i ] += ter_op( RandomInt( 2 ), mig_offset[ 0 ], -1 * mig_offset[ 0 ] ) * fwd;
				mig_spots[ i ] += ter_op( RandomInt( 2 ), mig_offset[ 1 ], -1 * mig_offset[ 1 ] ) * right;
				mig_spots[ i ] += ter_op( RandomInt( 2 ), mig_offset[ 1 ], -1 * mig_offset[ 2 ] ) * up;
				mig_ends[ i ] = mig_spots[ i ] + travel_distance * fwd;
			}
			
			foreach ( i, spot in mig_spots )
			{
				mig = Spawn( "script_model", spot );
				mig.angles = mig_angles;
				mig SetModel( "vehicle_mig29_low" );
				
				mig thread enemy_mig29_init_fake();
				mig thread enemy_mig29_fake_play_afterburner( RandomFloatRange( 0.25, 0.45 ) * time );
				point = point_between_2_points( RandomFloatRange( 0.25, 0.45 ), spot, mig_ends[ i ] );
				
				mig MoveTo( mig_ends[ i ], time, 0.05, 0.05 );
				mig RotateRoll( RandomFloat( 360 * RandomIntRange( 2, 6 ) ), time );
				mig thread enemy_mig29_fake_delete( time );
				wait 0.05;
			}
			
			wait 0.5;
			
			foreach ( i, spot in f15_spots )
			{
				f15 = Spawn( "script_model", spot );
				f15.angles = f15_angles;
				f15 SetModel( "vehicle_f15_low" );
				
				f15 thread friendly_f15_init_fake();
				f15 thread friendly_f15_fake_play_afterburner( RandomFloatRange( 0.25, 0.45 ) * time );
				point = point_between_2_points( RandomFloatRange( 0.25, 0.45 ), spot, f15_ends[ i ] );
				
				f15 MoveTo( f15_ends[ i ], time, 0.05, 0.05 );
				if ( random_chance( 0.1 ) )
					f15 thread friendly_f15_fake_shoot_mg();
				f15 RotateRoll( RandomFloat( 360 * RandomIntRange( 2, 6 ) ), time );
				f15 thread friendly_f15_fake_delete( time );
				wait 0.05;
			}
			wait RandomFloatRange( min_delay, max_delay );
		}
		else
			wait 0.05;
	}
}

ambient_mi17s_close()
{
	mi17_spawner = GetEnt( "ambient_close_mi17", "targetname" );
	Assert( IsDefined( mi17_spawner ) );
	mi17_spawner add_spawn_function( ::enemy_mi17_init_cheap );
	mi17_spots = getstructarray_delete( "ambient_close_mi17", "targetname", 0.25 );
	mi17_parent_spawner = GetEnt( "ambient_close_mi17_parent", "targetname" );
	Assert( IsDefined( mi17_parent_spawner ) );
	mi17_parent_spots = getstructarray_delete( "ambient_close_mi17_parent", "targetname", 0.25 );
	pilot_spawner = GetEnt( "ambient_close_mi17_pilot", "targetname" );
	Assert( IsDefined( pilot_spawner ) );
	mi17s = [];
	
	delay = 8.0;
	max_vehicles = 64;
	vehicle_buffer = 4;
	
	// **TODO: end when the player slamzooms onto the bridge
	
	while ( !flag( "FLAG_end_ambient_ac130_effects" ) )
	{
		mi17s = array_removeundefined( mi17s );
		
		if ( flag( "FLAG_ambient_ac130_effects" ) && flag( "FLAG_ambient_ac130_close_mi17s" ) )
		{
			if ( max_vehicles - Vehicle_GetArray().size < vehicle_buffer )
			{
				wait 0.05;
				continue;
			}
					
			if ( IsDefined( level.ac130_current_spline ) && IsDefined( level.ac130_current_spline_section ) )
			{
				_mi17_spots = [];
				
				foreach ( spot in mi17_spots )
					if ( spot compare_value( "script_noteworthy", level.ac130_current_spline ) && 
						 spot compare_value( "script_group", level.ac130_current_spline_section ) )
						_mi17_spots[ _mi17_spots.size ] = spot;
						
				_mi17_spots = array_index_by_script_index( _mi17_spots );
				
				_mi17_parent_spots = [];
				
				foreach ( spot in mi17_parent_spots )
					if ( spot compare_value( "script_group", level.ac130_current_spline_section ) )
						_mi17_parent_spots[ _mi17_parent_spots.size ] = spot;
						
				_mi17_parent_spots = array_index_by_script_index( _mi17_parent_spots );

				foreach ( i, spot in _mi17_spots )
				{
					if ( max_vehicles - Vehicle_GetArray().size < vehicle_buffer )
					{
						wait 0.05;
						continue;
					}
			
					mi17_parent_spawner.count = 1;
					mi17_parent_spawner.origin = _mi17_parent_spots[ i ].origin;
					mi17_parent_spawner.angles = _mi17_parent_spots[ i ] get_key( "angles" );
					mi17_parent_spawner.target = _mi17_parent_spots[ i ].target;
					mi17_parent = mi17_parent_spawner spawn_vehicle();
					
					mi17 = Spawn( "script_model", spot.origin );
					mi17.angles = spot get_key( "angles" );
					mi17.target = _mi17_parent_spots[ i ].target;
					mi17 SetModel( "vehicle_mi17_woodland_fly_cheap" );
					mi17s[ mi17s.size ] = mi17;
					
					wait 0.05;
					mi17 enemy_mi17_init_linked( mi17_parent );
					mi17 enemy_mi17_attach_fake_helis( RandomInt( 4 ) );
					mi17_parent delayThread( i * 0.75, ::gopath );
					wait 0.05;
				}
				wait ter_op( _mi17_spots.size > 0, delay, 0.05 );
			}
			else
				wait 0.05;
		}
		else
			wait 0.05;
	}
	
	// Clean Up
	
	mi17_spawner Delete();
	pilot_spawner Delete();
	
	mi17s = array_removeundefined( mi17s );
	waittill_ents_notified_timeout( mi17s, "death", 120.0 );
	foreach ( spot in mi17_spots )
		thread deletestructarray_ref( get_connected_ents( spot.target ), 0.25 );
}

ambient_mi17s_far()
{
	mi17_spawner = GetEnt( "ambient_far_mi17", "targetname" );
	Assert( IsDefined( mi17_spawner ) );
	mi17_spawner add_spawn_function( ::enemy_mi17_init_cheap );
	mi17_spots = getstructarray_delete( "ambient_far_mi17", "targetname", 0.25 );
	pilot_spawner = GetEnt( "ambient_far_mi17_pilot", "targetname" );
	Assert( IsDefined( pilot_spawner ) );
	mi17s = [];
	
	delay = 25.0;
	
	// **TODO: end when the player slamzooms onto the bridge
	
	while ( !flag( "FLAG_end_ambient_ac130_effects" ) )
	{
		mi17s = array_removeundefined( mi17s );
		
		if ( flag( "FLAG_ambient_ac130_effects" ) )
		{
			mi17_spot = mi17_spots[ RandomInt( mi17_spots.size ) ];
			_mi17_spots = [];
			
			foreach ( spot in mi17_spots )
				if ( compare_keys( [ spot, mi17_spot ], "script_index" ) )
					_mi17_spots[ _mi17_spots.size ] = spot;

			foreach ( i, spot in _mi17_spots )
			{
				mi17_spawner.count = 1;
				mi17_spawner.origin = spot.origin;
				mi17_spawner.angles = spot get_key( "angles" );
				mi17_spawner.target = spot.target;
				mi17s[ mi17s.size ] = mi17_spawner spawn_vehicle();
				wait 0.05;
				j = mi17s.size - 1;
				mi17s[ j ] enemy_mi17_load_pilot_alt( pilot_spawner );
				mi17s[ j ] delayThread( i * 0.75, ::enemy_mi17_gopath_and_die );
				wait 0.05;
			}
			wait ter_op( _mi17_spots.size > 0, delay, 0.05 );
		}
		else
			wait 0.05;
	}
	
	mi17_spawner Delete();
	pilot_spawner Delete();
	
	mi17s = array_removeundefined( mi17s );
	waittill_ents_notified_timeout( mi17s, "death", 120.0 );
	foreach ( spot in mi17_spots )
		thread deletestructarray_ref( get_connected_ents( spot.target ), 0.25 );
}

fdr_osprey_setup()
{
	osprey_ref = getstruct_delete( "fdr_osprey", "targetname" );
	osprey = Spawn( "script_model", osprey_ref.origin );
	osprey.angles = osprey_ref get_key( "angles" );
	osprey SetModel( "vehicle_v22_osprey" );
	
	car_refs = getstructarray_delete( "fdr_car", "targetname" );

	foreach ( ref in car_refs )
	{
		car = Spawn( "script_model", ref.origin );
		car.angles = ref get_key( "angles" );
		car SetModel( "vehicle_luxurysedan_2008_destroy" );
	}
}

fdr_delta_init()
{
	delta_spawn_at_fast_point( "fdr" );
}

fdr_delta_mark()
{
	flag_wait( "FLAG_fdr_mark_friendly_targets" );
	vehicle_scripts\_ac130::hud_add_friendly_targets();
	
	group = add_to_array( level.delta, level.makarov_number_2 );
	
	foreach ( guy in group )
		thread set_target_radius_over_time( guy, 100, 60, 20 );
}

fdr_signal_ac130()
{
	fx = getfx( "FX_signal_evac_hot" );
	fdr_signal_ac130_ref = getstruct_delete( "fdr_signal_ac130", "targetname" );
	Assert( IsDefined( fdr_signal_ac130_ref ) );
	fdr_signal_ac130 = Spawn( "script_model", fdr_signal_ac130_ref.origin );
	fdr_signal_ac130.angles = fdr_signal_ac130_ref get_key( "angles" );
	fdr_signal_ac130 SetModel( "tag_origin" );
	
	PlayFxOnTag( fx, fdr_signal_ac130, "tag_origin" );
	
	wait 5.0;
	
	flag_wait( "FLAG_fdr_carpet_bombing_finished" );
	StopFXOnTag( fx, fdr_signal_ac130, "tag_origin" );
	fdr_signal_ac130 Delete();
}

fdr_monitor_ac130_speed()
{
	flag_wait( "FLAG_fdr_ac130_circling_fdr" );
	flag_wait( "FLAG_fdr_enemy_vehicles_killed" );
	
	level.ac130_vehicle Vehicle_SetSpeed( 50, 3, 3 );
	
	path = get_connected_ents( "city_area_loop_0_out" );
	node = get_ents_from_array( 4, "script_index", path )[ 0 ];
	node waittill( "trigger" );
			
	level.ac130_vehicle Vehicle_SetSpeed( 30, 1, 1 );
}

fdr_t72s()
{
	t72_spawner = GetEnt( "fdr_t72", "targetname" );
	Assert( IsDefined( t72_spawner ) );
	t72_spawner add_spawn_function( ::enemy_t72_init, "fdr_t72", "targetname", 4 );
	t72_spawner add_spawn_function( ::enemy_t72_randomly_shoot_canon_fake2, add_to_array( level.delta, level.makarov_number_2 ) );
	t72_spawner add_spawn_function( ::monitor_vehicle_mission_fail_points );
	t72_spawner add_spawn_function( ::vehicle_enemy_kill_dialogue_monitor, "t72" );
	t72_spots = getstructarray_delete( "fdr_t72", "targetname", 0.25 );
	t72s = [];
	
	foreach ( i, spot in t72_spots )
	{
		t72_spawner.count = 1;
		t72_spawner.origin = spot.origin;
		t72_spawner.angles = spot get_key( "angles" );
		t72_spawner.target = spot.target;
		t72_spawner.script_badplace = ter_op( IsDefined( spot.script_badplace ), spot.script_badplace, t72_spawner.script_badplace ); 
		t72s[ i ] = t72_spawner spawn_vehicle();
		wait 0.05;
		t72s[ i ].script_index = spot.script_index;
		t72s[ i ].script_noteworthy = spot.script_noteworthy;
		level.fdr_enemy_vehicles = add_to_array( level.fdr_enemy_vehicles, t72s[ i ] );
		wait 0.05;
	}
	
	flag_wait( "FLAG_intro_osprey_1_crash_finished" );
	
	foreach ( t72 in t72s )
		if ( IsDefined( t72 ) && IsDefined( t72.target ) )
			t72 thread gopath();

	flag_set( "FLAG_fdr_t72s_spawned" );

	_t72s = [];
	
	foreach ( t72 in t72s )
		if ( t72.script_index == 1 || t72.script_index == 2 || t72.script_index == 11 )
			_t72s[ _t72s.size ] = t72;
	thread achieve_menage_a_trois( _t72s );
	
	flag_waitopen( "FLAG_delta_spawned" );
	
	foreach ( t72 in t72s )
		if ( IsDefined( t72 ) )
			t72 notify( "LISTEN_end_t72_randomly_shoot_canon_fake2" );
			
	flag_wait( "FLAG_delta_spawned" );
	
	foreach ( t72 in t72s )
		if ( IsDefined( t72 ) )
			t72 thread enemy_t72_randomly_shoot_canon_fake2( add_to_array( level.delta, level.makarov_number_2 ) );
	
	// Mark t72s
	
	flag_wait( "FLAG_fdr_mark_enemy_targets" );
	marked_t72s = array_removeundefined( t72s );
	marked_t72s = array_remove_keys( marked_t72s, [ "script_noteworthy" ] );
	thread vehicle_scripts\_ac130::hud_add_targets( marked_t72s, ter_op( flag( "FLAG_start_e3" ), 0.05, 0.25 ) );
	
	// Clean up
	
	flag_wait ( "FLAG_fdr_kill_all_enemies" );
	
	foreach ( t72 in t72s )
	{
		if ( IsDefined( t72 ) && IsAlive( t72 ) )
		{
			t72 godoff();
			t72 DoDamage( 100000, t72.origin );
		}
	}
	t72_spawner Delete();
}

fdr_btrs()
{
	btr_spawner = GetEnt( "fdr_btr", "targetname" );
	Assert( IsDefined( btr_spawner ) );
	btr_spawner add_spawn_function( ::enemy_btr_init, "fdr_btr", "targetname" );
	btr_spawner add_spawn_function( ::monitor_vehicle_mission_fail_points );
	btr_spawner add_spawn_function( ::vehicle_enemy_kill_dialogue_monitor, "btr" );
	btr_spots = getstructarray_delete( "fdr_btr", "targetname", 0.25 );
	btr_spots = array_index_by_script_index( btr_spots );
	target = GetEnt( "fdr_btr_target", "targetname" );
	btrs = [];
	
	foreach ( i, spot in btr_spots )
	{
		btr_spawner.count = 1;
		btr_spawner.origin = spot.origin;
		btr_spawner.angles = spot get_key( "angles" );
		btr_spawner.target = spot.target;
		btrs[ i ] = btr_spawner spawn_vehicle();
		wait 0.05;
		
		btrs[ i ] enemy_btr_set_passenger_callbacks_on_unload( [ ::fdr_btr_enemy_management ] );
		
		level.fdr_enemy_vehicles = add_to_array( level.fdr_enemy_vehicles, btrs[ i ] );
		wait 0.05;
	}
	
	passenger_spawner = GetEnt( "fdr_btr_enemy", "targetname" );
	Assert( IsDefined( passenger_spawner ) );
	passenger_spawner add_spawn_function( ::ai_enemy_street_patrol_on_damage );
	
	flag_wait( "FLAG_intro_osprey_1_crash_finished" );
	
	foreach ( btr in btrs )
	{
		btr thread maps\_vehicle::mgon();
		btr thread enemy_btr_randomly_shoot_at_targets( array_combine( level.delta, [ level.makarov_number_2 ] ) );
		btr SetTurretTargetEnt( target );
	}
	
	btrs[ 1 ] enemy_btr_load_passengers_alt( passenger_spawner, 3, true );
	btrs[ 2 ] enemy_btr_load_passengers_alt( passenger_spawner, 3, true );

	time_1 = ter_op( flag( "FLAG_start_e3" ), 4, 15 );
	time_2 = ter_op( flag( "FLAG_start_e3" ), 5, 20 );

	btrs[ 1 ] delayThread( time_1, ::enemy_btr_unload );
	btrs[ 2 ] delayThread( time_2, ::enemy_btr_unload );
	
	foreach ( btr in btrs )
		if ( IsDefined( btr ) && IsDefined( btr.target ) )
			btr thread gopath();
	
	flag_set( "FLAG_fdr_btrs_spawned" );
	
	// Mark btrs
	
	flag_wait( "FLAG_fdr_mark_enemy_targets" );
	vehicle_scripts\_ac130::hud_add_targets( btrs, 0.1 );
			
	// Clean up

	flag_wait ( "FLAG_fdr_kill_all_enemies" );
	
	foreach ( btr in btrs )
	{
		if ( IsDefined( btr ) && IsAlive( btr ) )
		{
			btr godoff();
			btr DoDamage( 100000, btr.origin );
		}
	}
	btr_spawner Delete();
	target Delete();
}

fdr_btr_enemy_management()
{
	self endon( "death" );
	
	goal = level.delta[ RandomInt( level.delta.size ) ];
	self thread ai_set_goal_on_notify( goal, "entity", "unload", 128, 256, 6 );
	
	self waittill( "unload" );
	thread vehicle_scripts\_ac130::hud_add_targets( [ self ] );
	self thread ai_enemy_kill_dialogue_monitor();
	flag_wait( "FLAG_fdr_kill_all_enemies" );
	self DoDamage( 10000, self.origin );
}

fdr_enemy_vehicles_monitor()
{
	flag_wait( "FLAG_fdr_btrs_spawned" );
	flag_wait( "FLAG_fdr_t72s_spawned" );
	
	thread fdr_enemy_vehicles_reminder();
	_flag = "FLAG_fdr_enemy_vehicles_killed";
	waittill_x_ents_notified_set_flag( 5, level.fdr_enemy_vehicles, "death", _flag );
	
	level.fdr_enemy_vehicles = undefined;
}

fdr_enemy_vehicles_reminder()
{
	flag_wait( "FLAG_fdr_intro_dialogue_finished" );
	
	sounds = [];

	// 3-5 Hit those guys.
	sounds[ sounds.size ] = level.scr_sound[ "tvo" ][ "ac130_tvo_hitthoseguys" ];
    // 3-6 Enemy armor still down there.  Go ahead and clean those up.
    sounds[ sounds.size ] = level.scr_sound[ "fco" ][ "ac130_fco_cleanthoseup" ];
    // 3-7 Get on that enemy armor.
    sounds[ sounds.size ] = level.scr_sound[ "fco" ][ "ac130_fco_enemyarmor" ];
    // 3-8 Go for the vehicles.
    sounds[ sounds.size ] = level.scr_sound[ "fco" ][ "ac130_fco_goforvehicles" ];
    // 4-31 Keep hittin em!
	sounds[ sounds.size ] = level.scr_sound[ "snd" ][ "ac130_snd_keephittinem" ];
	// 3-18 Go ahead and hit 'em.
    sounds[ sounds.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_goahead" ];
    // 3-22 Light 'em up.
    sounds[ sounds.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_lightemup" ];
    
    array = [];
    
    for ( i = 0; i < sounds.size; i++ )
    	array[ array.size ] = i;
    	
    delay = 7.0;
    index = 0;
    
    wait 4.5;
    	
	while ( !flag( "FLAG_fdr_enemy_vehicles_killed") )
	{
		if ( array.size == 0 )
		{
			for ( i = 0; i < sounds.size; i++ )
    			array[ array.size ] = i;
    		if ( array.size > 1 )
    			array = array_remove_index( array, index );
    	}
		
		index = RandomInt( array.size );
		
		vehicle_scripts\_ac130::playSoundOverRadio( sounds[ array[ index ] ], false );
    	array = array_remove_index( array, index );
		wait delay;
	}
}

fdr_carpet_bomb_timeout()
{
	time = 90;
	elapsed = 0;
	
	while ( elapsed < time && !flag( "FLAG_fdr_enemy_vehicles_killed" ) )
	{
		elapsed += 0.05;
		wait 0.05;
	}
	
	if ( !flag( "FLAG_fdr_enemy_vehicles_killed" ) )
		flag_set( "FLAG_fdr_carpet_bombing_timeout" );
	flag_set( "FLAG_fdr_enemy_vehicles_killed" );
}

fdr_mi17s()
{
	mi17_spawner = GetEnt( "fdr_mi17", "targetname" );
	Assert( IsDefined( mi17_spawner ) );
	mi17_spawner add_spawn_function( ::enemy_mi17_init, "fdr_mi17", "script_noteworthy" );
	mi17_spawner add_spawn_function( ::monitor_vehicle_mission_fail_points );
	mi17_spawner add_spawn_function( ::vehicle_enemy_kill_dialogue_monitor, "mi17" );

	spot_management = SpawnStruct();
	spot_management.used_spots = [];
	spot_management.used_spots[ 1 ] = false;
	spot_management.used_spots[ 2 ] = false; 
	spot_management.used_spots[ 3 ] = false;
	spot_management.used_spots[ 4 ] = false;

	_spots = getstructarray( "fdr_mi17", "targetname" );
	spots = [];
	foreach ( spot in _spots )
		spots[ spot.script_index ] = add_to_array( spots[ spot.script_index ], spot );
	
	pilot_spawner = GetEnt( "fdr_mi17_pilot", "targetname" );
	Assert( IsDefined( pilot_spawner ) );
	
	passenger_spawner = GetEnt( "fdr_mi17_enemy", "targetname" );
	Assert( IsDefined( passenger_spawner ) );
	passenger_spawner add_spawn_function( ::ai_enemy_street_patrol_on_damage );

	delay = 10.0;
	_i = 1;
	_j = 0;
	mi17s = [];
	max_vehicles = 64;
	vehicle_buffer = 4;
	
	while( !flag( "FLAG_fdr_enemy_vehicles_killed" ) )
	{
		if ( max_vehicles - Vehicle_GetArray().size < vehicle_buffer )
		{
			wait 0.05;
			continue;
		}
					
		found_unused_spot = false;
		
		foreach ( i, spot in spot_management.used_spots )
		{
			if ( !spot )
			{
				_i = i;
				found_unused_spot = true;
				break;
			}
		}
		
		if ( found_unused_spot )
		{
			found_out_of_view_spot = false;
			
			while ( !found_out_of_view_spot )
			{
				foreach ( i, spot in spots[ _i ] )
				{
					if ( !within_fov_of_players( spot.origin, cos( GetDvarFloat( "cg_fov" ) ) ) )
					{
						_j = i;
						found_out_of_view_spot = true;
						break;
					}
				}
				wait 0.05;
			}
	
			max_ai = 32;
			num_ai = ( GetAIArray() ).size;
			
			if ( ( max_ai - num_ai ) > 3 )
			{
				used_spots[ _i ] = true;
				
				mi17_spawner.count = 1;
				mi17_spawner.angles = spots[ _i ][ _j ] get_key( "angles" );
				mi17_spawner.origin = spots[ _i ][ _j ].origin;
				mi17_spawner.target = spots[ _i ][ _j ].target;
			
				mi17 = mi17_spawner spawn_vehicle();
				mi17s[ mi17s.size ] = mi17;
				
				wait 0.05;
			    mi17 thread enemy_mi17_load_pilot_alt( pilot_spawner );
			    mi17 thread enemy_mi17_quick_load_passengers_alt( passenger_spawner, RandomIntRange( 2, 4 ) );
			    callbacks = [ ::fdr_mi17_enemy_management, ::monitor_ai_mission_fail_points ];
			    mi17 enemy_mi17_set_passenger_callbacks_on_unload( callbacks );
			    mi17 thread enemy_mi17_drop_off();
			    thread fdr_mi17_spot_management( mi17, spot_management, _i );
			    vehicle_scripts\_ac130::hud_add_targets( [ mi17 ] );
			    wait delay;
			}
		}
		wait 0.05;
	}
	
	flag_wait ( "FLAG_fdr_kill_all_enemies" ); // **TODO timing may need adjusting if player can see heli far away from scene

	wait 0.1;
	
	foreach ( mi17 in mi17s )
		if ( IsDefined( mi17 ) )
			mi17 DoDamage( 100000, mi17.origin );
				
	flag_wait( "FLAG_fdr_carpet_bombing_finished" );
	
    // Clean up
    
    foreach ( spot in spots )
    {
		thread deletestructarray_ref( spot, 0.25 );
		
		foreach ( _spot in spot )
			thread deletestructarray_ref( get_connected_ents( _spot.target ), 0.25 );
	}
		
    pilot_spawner Delete();
    passenger_spawner Delete();
	mi17_spawner Delete();
}

fdr_mi17_spot_management( mi17, spot_management, index )
{
	Assert( IsDefined( mi17 ) );
	Assert( IsDefined( spot_management ) && IsDefined( spot_management.used_spots ) );
	
	index = gt_op( index, 0 );
	
	spot_management.used_spots[ index ] = true;
	mi17 waittill_any( "death", "LISTEN_helicopter_resume_path" );
	spot_management.used_spots[ index ] = false;
}

fdr_mi17_enemy_management()
{
	self endon( "death" );
	
	goal = level.delta[ RandomInt( level.delta.size ) ];
	self thread ai_set_goal_on_notify( goal, "entity", "jumpedout", 384, 512, 2 );
	self thread ai_enemy_kill_dialogue_monitor();
	delayThread( 3.0, vehicle_scripts\_ac130::hud_add_targets, [ self ] );
	flag_wait( "FLAG_fdr_kill_all_enemies" );
	self DoDamage( 10000, self.origin );
}

fdr_bm21s()
{
	bm21_spawner = GetEnt( "fdr_bm21", "targetname" );
	Assert( IsDefined( bm21_spawner ) );
	bm21_spawner add_spawn_function( ::enemy_bm21_cheap_init, "fdr_bm21", "targetname" );
	bm21_spawner add_spawn_function( ::vehicle_enemy_kill_dialogue_monitor );
	bm21_spots = getstructarray_delete( "fdr_bm21", "targetname" );
	bm21_spots = array_index_by_script_index( bm21_spots );
	bm21s = [];
	
	passenger_spawner = GetEnt( "fdr_btr_enemy", "targetname" );
	Assert( IsDefined( passenger_spawner ) );
	passenger_spawner add_spawn_function( ::ai_enemy_street_patrol_on_damage );
	
	foreach ( i, spot in bm21_spots )
	{
		bm21_spawner.count = 1;
		bm21_spawner.origin = spot.origin;
		bm21_spawner.angles = spot get_key( "angles" );
		bm21_spawner.target = spot.target;
		bm21s[ i ] = bm21_spawner spawn_vehicle();
		wait 0.05;
		bm21s[ i ] enemy_bm21_set_passenger_callbacks_on_unload( [ ::fdr_bm21_enemy_management ] );
		wait 0.05;
	}

	flag_wait( "FLAG_intro_osprey_1_crash_finished" );
	
	foreach ( bm21 in bm21s )
		bm21 enemy_bm21_load_passengers_alt( passenger_spawner, 5, true );
		
	time_1 = ter_op( flag( "FLAG_start_e3" ), 4, 12 );
	time_2 = ter_op( flag( "FLAG_start_e3" ), 5, 18 );

	bm21s[ 1 ] delayThread( time_1, ::enemy_bm21_unload );
	bm21s[ 2 ] delayThread( time_2, ::enemy_bm21_unload );
	
	// Clean up
	
	flag_wait( "FLAG_fdr_carpet_bombing_finished" );
	
	foreach ( bm21 in bm21s )
	{
		if ( IsDefined( bm21 ) )
		{
			bm21 notify( "death" );
			bm21 Delete();
		}
	}
	bm21_spawner Delete();
	passenger_spawner Delete();
}

fdr_bm21_enemy_management()
{
	self endon( "death" );
	
	goal = level.delta[ RandomInt( level.delta.size ) ];
	self thread ai_set_goal_on_notify( goal, "entity", "unload", 128, 256, 6 );
	
	self waittill( "unload" );
	thread vehicle_scripts\_ac130::hud_add_targets( [ self ] );
	self thread ai_enemy_kill_dialogue_monitor();
	flag_wait( "FLAG_fdr_kill_all_enemies" );
	self DoDamage( 10000, self.origin );
}

fdr_enemies()
{
	spawner = GetEnt( "fdr_enemy", "targetname" );
	Assert( IsDefined( spawner ) );
	spawner add_spawn_function( ::ai_enemy_kill_dialogue_monitor );
	spawner add_spawn_function( ::ai_enemy_street_patrol_on_damage );
	spots = getstructarray_delete( "fdr_enemy_spot", "targetname", 0.25 );
	Assert( IsDefined( spots ) );

	goal = level.delta[ RandomInt( level.delta.size ) ];
	
	enemies = [];
	
	foreach ( spot in spots )
	{
		spawner.count = 1;
		spawner.origin = spot.origin;
		spawner.angles = spot get_key( "angles" );
		ai = spawner spawn_ai( true );
		
		enemies[ enemies.size ] = ai;
		
		if ( IsDefined( ai ) )
		{
			ai set_goal_radius( RandomFloatRange( 384, 512 ) );
			ai delayThread( RandomFloatRange( 0, 6 ), ::set_goal_pos, goal.origin );
			wait 0.05;
		}
	}

	flag_wait( "FLAG_fdr_mark_enemy_targets" );
	thread vehicle_scripts\_ac130::hud_add_targets( enemies, 0.25 );
	
	flag_wait( "FLAG_fdr_delta_ready_to_move_to_street" );
	foreach ( guy in enemies )
		if ( IsDefined( guy ) && Target_IsTarget( guy ) )
			Target_Remove( guy );
		
	// Clean up
	
	flag_wait( "FLAG_fdr_kill_all_enemies" );
	
	foreach ( guy in enemies )
		if ( IsDefined( guy ) )
			guy DoDamage( 10000, guy.origin );
	spawner Delete();
}

fdr_carpet_bomb()
{
	time = ter_op( flag( "FLAG_start_e3" ), 3, 1 );
	
	flag_wait( "FLAG_fdr_enemy_vehicles_killed" );
	flag_wait( "FLAG_fdr_dialogue_finished" );
	flag_wait( "FLAG_ac130_loop_0" );
	flag_clear( "FLAG_ambient_ac130_close_jets" );
	flag_clear( "FLAG_ambient_ac130_close_mi17s" );
    
	// 4-7 Overlord, Metal Zero One is clear.  Greenlight - bomb run on target area - West to East.  I repeat, West to East.
	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_greenlight" ], true, 10.0 );
 
    // 4-8 Copy.  West to East.  Odin Six, you are cleared for bomb run at grid four, niner, one, five.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "hqr" ][ "ac130_hqr_bombrun" ], true, 10.0 );
    
    // 4-10 Crew, hold fire to the South - friendly birds are entering the airspace.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_friendlybirds" ], true, 10.0 );
	
	//wait time;
	
	// Start jet flyby
	
	a10_spawner = GetEnt( "fdr_a10", "targetname" );
	Assert( IsDefined( a10_spawner ) );
	a10_spawner add_spawn_function( ::friendly_a10_init );
	a10_spawner add_spawn_function( ::friendly_a10_sonic_boom, "scn_ac130_bomber_sonic_boom" );
	a10_spawner add_spawn_function( ::friendly_a10_delete_on_path_end );
	a10_spots = getstructarray_delete( "fdr_a10", "targetname" );
	a10_spots = array_index_by_script_index( a10_spots );
	
	a10s = [];
	
	foreach ( i, spot in a10_spots )
	{
		a10_spawner.count = 1;
	 	a10_spawner.origin = spot.origin;
		a10_spawner.angles = spot get_key( "angles" );
		a10_spawner.target = spot.target;
		a10s[ i ] = a10_spawner spawn_vehicle();
		wait 0.1;
	}
	
	a10s[ 1 ] delayThread( 0.05, ::gopath );
	a10s[ 2 ] delayThread( 0.5, ::gopath );
	a10s[ 3 ] delayThread( 1.0, ::gopath );
	
	delayThread( 6.0, ::flag_set, "FLAG_fdr_kill_all_enemies" );
	delayThread( 0.5, ::flag_set, "FLAG_fdr_delta_ready_to_move_to_street" );

	wait 4.25;
	
	exploder( "bombing_run" );
	
	flag_set( "FLAG_fdr_carpet_bombing_start" );
	flag_set( "FLAG_ambient_ac130_close_jets" );
	flag_set( "FLAG_ambient_ac130_close_mi17s" );
	
	wait 3.0;
	
	// 4-11 That's one helluva fireworks display.
	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "fco" ][ "ac130_fco_fireworks" ], true, 10.0 );
	thread vehicle_scripts\_ac130::autosave_ac130();
	thread set_saved_dvar_over_time( "sm_sunsamplesizenear", 1.0, 5 );
	
	flag_set( "FLAG_fdr_carpet_bombing_finished" );
	
	Objective_State( obj( "OBJ_FDR_Clear_Area" ), "done" );
	
	// Clean up
	
	a10_spawner Delete();
}

fdr_clean_up()
{
}

fdr_catch_up_clean_up()
{
	ents = [];
	ents = array_combine( ents, GetEntArray( "fdr_t72", "targetname" ) );
	ents = array_combine( ents, GetEntArray( "fdr_btr", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "fdr_btr_target", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "fdr_mi17", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "fdr_mi17_pilot", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "fdr_mi17_enemy", "targetname" ) );
	ents = array_combine( ents, GetEntArray( "fdr_bm21", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "fdr_enemy", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "fdr_a10", "targetname" ) );
	
	foreach ( ent in ents )
	{
		if ( IsDefined( ent ) )
		{
			ent notify( "death" );
			ent Delete();
		}
	}		
	fdr_delete_structs();
}

fdr_delete_structs()
{
	structs =[];
	structs = add_to_array( structs, getstruct( "fdr_signal_ac130", "targetname"  ) );
	structs = array_combine( structs, getstructarray( "fdr_t72", "targetname"  ) );
	structs = array_combine( structs, getstructarray( "fdr_btr", "targetname"  ) );
	structs = array_combine( structs, getstructarray( "fdr_bm21", "targetname"  ) );
	structs = array_combine( structs, getstructarray( "fdr_enemy_spot", "targetname"  ) );

	spots = getstructarray( "fdr_mi17", "targetname" );
	foreach ( spot in spots )
		structs = array_combine( structs, get_connected_ents( spot.target ) );
	
	structs = array_combine( structs, getstructarray( "fdr_a10", "targetname" ) );
	
	thread deletestructarray_ref( structs, 0.2 );
}

catch_up_e3()
{
}

start_e3()
{
	if ( flag( "FLAG_fdr_enemy_vehicles_killed" ) )
		return;
	
	flag_set( "FLAG_ambient_ac130_effects" );
	flag_set( "FLAG_ambient_ac130_close_jets" );
	flag_set( "FLAG_ambient_ac130_close_mi17s" );
	
	level.enemy_kill_dialogue_enabled = true;
	
	//thread level_enemy_killed();
	thread ambient_effects();
	//thread init_building_triggers();
	
	SetDvar( "pip_enabled", 0 );	
	fade_to_black( 0, 1 );
	
	if ( IsDefined( level.intro_black ) )
		level.intro_black delayCall( 0.05, ::Destroy );
		
	level.player FreezeControls( true );
	
	// Setup FDR Section before Carpet Bombing
	
	delta_spawn_at_fast_point( "fdr" );
	vehicle_scripts\_ac130::hud_add_friendly_targets();
	
	flag_set( "FLAG_fdr_mark_enemy_targets" );
	flag_set( "FLAG_fdr_mark_friendly_targets" );
	
	thread fdr_signal_ac130();
	
	thread fdr_t72s();
	thread fdr_btrs();
	thread fdr_mi17s();
	thread fdr_bm21s();
	thread fdr_enemies();
	
	// Move the player to the correct location
	
	e3_start_node = get_ents_from_array( 4, "script_index", get_connected_ents( "city_area_loop_0_out" ) )[ 0 ];
	level.ac130_vehicle switch_vehicle_path( e3_start_node );
	level.ac130_vehicle Vehicle_SetSpeedImmediate( 20, 1, 1 );
	thread ac130_path( "loop_2" );
	
	e3_dialogue();
	e3_focus = getstruct_delete( "e3_player_focus", "targetname" );
	Assert( IsDefined( e3_focus ) );
	level.player SetPlayerAngles( VectorToAngles( e3_focus.origin - level.player.origin ) );
	wait 1.0;		
	fade_in_from_black( 1, 0 );
	
	level.player FreezeControls( false );
	
	Objective_Add( obj( "OBJ_FDR_Clear_Area" ), "current", &"PARIS_AC130_OBJ_FDR_CLEAR_AREA_FOR_KILO_1_1" );
	
	thread fdr_carpet_bomb();
	
	flag_set( "FLAG_fdr_ac130_circling_fdr" );
	flag_set( "FLAG_fdr_enemy_vehicles_killed" );
}

e3_dialogue()
{
	// 4-1 Warhammer, targets destroyed.  Thanks for the assist.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_thanks" ], true, 10.0 );
    
    // 4-2 Solid copy, Metal Zero One.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_solidcopy" ], true, 10.0 );
    
    flag_set( "FLAG_fdr_dialogue_finished" );
}

street_enemy_spawners()
{
	spawners = get_ent_array_with_prefix( "city_area_ma_enemy_", "targetname", 1 );
	spawners = add_to_array( spawners, GetEnt( "city_area_pfr_enemy_1", "targetname" ) );
	
    ai_callbacks = [];
    
    ai_callbacks[ "after_spawn" ] = [];
    
    ai_callbacks[ "after_spawn" ][ "pass_value" ] = [];
    ai_callbacks[ "after_spawn" ][ "pass_value" ][ 0 ] = ::add_encounter_enemy;
    
    ai_callbacks[ "after_spawn" ][ "caller" ] = [];
    ai_callbacks[ "after_spawn" ][ "caller" ][ 0 ] = ::ai_enemy_street_patrol_init;
    ai_callbacks[ "after_spawn" ][ "caller" ][ 1 ] = ::ai_switch_team_after_spawn;
    ai_callbacks[ "after_spawn" ][ "caller" ][ 2 ] = ::ai_ignore_all_after_spawn;
    ai_callbacks[ "after_spawn" ][ "caller" ][ 3 ] = ::monitor_ai_mission_fail_points;
    ai_callbacks[ "after_spawn" ][ "caller" ][ 4 ] = ::ai_enemy_kill_dialogue_monitor;
    ai_callbacks[ "after_spawn" ][ "caller" ][ 5 ] = ::ai_enemy_street_add_hud_target;
    
    ai_callbacks[ "before_spawner_cleanup" ] = [];  
    ai_callbacks[ "before_spawner_cleanup" ][ "pass_value" ] = []; 

	// Street Section
	
	if ( !flag( "FLAG_street_ma_1_delta_reached" ) )
	{
		spawners[ 0 ]._ais = [];
	    spawners[ 0 ]._initial_count = 6;
	    spawners[ 0 ]._initial_interval = 0.75;
	    spawners[ 0 ]._max_count = 6;
	    spawners[ 0 ]._interval = 1.0;
	    spawners[ 0 ]._ai_callbacks = ai_callbacks;
	    spawners[ 0 ]._ai_callbacks[ "after_spawn" ][ "pass_value" ][ 1 ] = ::add_encounter_primary_enemy;
	    spawners[ 0 ]._ai_callbacks[ "before_spawner_cleanup" ][ "pass_value" ][ 0 ] = ::add_encounter_primary_enemies;
	    
		spawners[ 0 ] thread street_enemy_spawner( "FLAG_street_ma_1_delta_reached" );
	}

	if ( !flag( "FLAG_street_ma_2_flank_spawned" ) )
	{
		spawners[ 1 ]._ais = [];
		spawners[ 1 ]._initial_count = 8;
	    spawners[ 1 ]._initial_interval = 0.75;
	    spawners[ 1 ]._max_count = 8;
	    spawners[ 1 ]._interval = 1.0;
	    spawners[ 1 ]._ai_callbacks = ai_callbacks;
	    
		spawners[ 1 ] thread street_enemy_spawner( "FLAG_street_ma_2_flank_spawned" );
	}

	if ( !flag( "FLAG_street_ma_3_delta_reached" ) )
	{
		spawners[ 2 ]._ais = [];
		spawners[ 2 ]._initial_count = 5;
	    spawners[ 2 ]._initial_interval = 0.3;
	    spawners[ 2 ]._max_count = 6;
	    spawners[ 2 ]._interval = 0.3;
	    spawners[ 2 ]._ai_callbacks = ai_callbacks;
	
		spawners[ 2 ] thread street_enemy_spawner( "FLAG_street_ma_3_delta_reached" );
	}

	if ( !flag( "FLAG_rpg_building_destroyed" ) )
	{
		spawners[ 3 ]._ais = [];
		spawners[ 3 ]._initial_count = 2;
	    spawners[ 3 ]._initial_interval = 1.5;
	    spawners[ 3 ]._max_count = 2;
	    spawners[ 3 ]._interval = 1.5;
	    spawners[ 3 ]._ai_callbacks = ai_callbacks;
	    
		spawners[ 3 ] thread street_enemy_spawner( "FLAG_rpg_building_destroyed" );
	}
	
	// Sniper Area
	
	if ( !flag( "FLAG_chase_started" ) )
	{
		spawners[ 4 ]._ais = [];
		spawners[ 4 ]._initial_count = 0;
	    spawners[ 4 ]._initial_interval = 1.5;
	    spawners[ 4 ]._max_count = 0;
	    spawners[ 4 ]._interval = 1.5;
	    spawners[ 4 ]._ai_callbacks = ai_callbacks;
	    
		spawners[ 4 ] thread street_enemy_spawner( "FLAG_chase_started" );
	}
}

catch_up_street()
{
	wait 0.05;
	
	flag_set( "FLAG_ambient_ac130_effects" );
	flag_set( "FLAG_ambient_ac130_close_jets" );
	flag_set( "FLAG_ambient_ac130_close_mi17s" );
	
	flag_set( "FLAG_fdr_ac130_circling_fdr" );
	flag_set( "FLAG_fdr_intro_dialogue_finished" );
	flag_set( "FLAG_fdr_delta_ready_to_move_to_street" );
	flag_set( "FLAG_fdr_enemy_vehicles_killed" );
	
	flag_set( "FLAG_ac130_intro" );
	flag_set( "FLAG_ac130_loop_0_to_2" );
	flag_set( "FLAG_ac130_loop_2" );
	
	Objective_Add( obj( "OBJ_FDR_Clear_Area" ), "current", &"PARIS_AC130_OBJ_FDR_CLEAR_AREA_FOR_KILO_1_1" );
	Objective_State( obj( "OBJ_FDR_Clear_Area" ), "done" );
	
	thread ambient_effects();
	delaythread( 7.0, ::fdr_catch_up_clean_up );
	
	delta_spawn_at_fast_point( "street" );
	vehicle_scripts\_ac130::hud_add_friendly_targets();
	
	transition_node = GetVehicleNode( "city_area_loop_2_out", "script_noteworthy" );
	level.ac130_vehicle switch_vehicle_path( transition_node );
}

start_street()
{
	thread vehicle_scripts\_ac130::autosave_ac130();
    
    SetThreatBias( "axis", "team3", -10000 );
	SetThreatBias( "team3", "axis", -10000 );
	SetIgnoreMeGroup( "axis", "team3" );
	SetIgnoreMeGroup( "team3", "axis" );
	
    vehicle_scripts\_ac130::set_badplace_max( 15 );
    
    //thread ac130_path( "loop_2" );
    
    flag_wait( "FLAG_fdr_delta_ready_to_move_to_street" );
    //thread fdr_1_dialogue();
    thread street_ma_1_delta_move_down();
	
	thread ac130_path( "loop_3" );
    
    flag_wait( "FLAG_street_ma_1_delta_reached" );
    Objective_Add( obj( "OBJ_STREET_Clear_Area" ), "current", &"PARIS_AC130_OBJ_STREET_CLEAR_STREET_FOR_KILO_1_1" );
    flag_wait( "FLAG_street_ma_2_delta_move_down" );
    thread street_ma_2_delta_move_down();
    flag_wait( "FLAG_street_ma_3_delta_move_down" );
    flag_wait( "FLAG_city_area_ma_2_dialogue_finished" );
    thread street_ma_3_delta_move_down();
    thread rpg_angel_flare_moment();
}

street_hints()
{
	timeout = 5.0;

	if ( flag( "FLAG_ac130_thermal_enabled" ) )
		level.player thread display_hint_timeout( "HINT_ac130_enhanced_vision", timeout );
	wait 8.0;
	level.player display_hint_timeout( "HINT_ac130_using_zoom", timeout );
}

street_ma_1_delta_move_down()
{   
	thread street_ma_1_mi17();
    thread street_ma_1_encounter();
    thread street_ma_1_signal_ac130();
    
    // Delta + Makarov #2 move into cover
    
    cover_nodes = get_ent_array_with_prefix( "street_ma_friendly_cover_0_", "targetname", 0 );
    Assert( IsDefined( cover_nodes ) );
    
    _flag = "FLAG_street_ma_1_delta_reached";
    timeout = 20;
    thread waittill_ents_notified_set_flag_timeout( level.delta, "LISTEN_ai_goal_reached", _flag, timeout );

	level.bishop thread parent_ai_and_child_ai_go_to_node( level.makarov_number_2, cover_nodes[ 4 ], true );
	
    foreach ( i, guy in level.delta )
    {
       	if ( i < 4 )
       	{
       		guy SetCanDamage( false );
       		guy thread ai_friendly_push_forward( 15.0 );
       		guy set_goal_node( cover_nodes[ i ] );
       	}
       	range = 8.0;
		thread notify_ai_when_in_range_of_ent( guy, cover_nodes[ i ], range, "LISTEN_ai_goal_reached" );
    }
    
    flag_wait( "FLAG_street_ma_1_delta_reached" );
    
    foreach ( guy in level.delta )
    	guy SetCanDamage( true );
}

street_ma_1_signal_ac130()
{
	level.sandman waittill( "LISTEN_ai_goal_reached" );
	
	fx = getfx( "FX_signal_ac130" );
	street_ma_1_signal_ac130_ref = getstruct_delete( "street_ma_1_signal_ac130", "targetname" );
	Assert( IsDefined( street_ma_1_signal_ac130_ref ) );
	street_ma_1_signal_ac130 = Spawn( "script_model", street_ma_1_signal_ac130_ref.origin );
	street_ma_1_signal_ac130.angles = street_ma_1_signal_ac130_ref get_key( "angles" );
	street_ma_1_signal_ac130 SetModel( "tag_origin" );
	
	// Have Sandman throw a grenade
	
	angles = VectorToAngles( street_ma_1_signal_ac130_ref.origin - level.sandman.origin );
	tag = Spawn( "script_model", level.sandman.origin );
	tag.angles = level.sandman.angles;
	tag SetModel( "tag_origin" );
	level.sandman LinkTo( tag, "tag_origin" );
	tag RotateYaw( angles[ 1 ] - 180, 0.25 );
	wait 0.25;
	tag Delete();
	level.sandman thread anim_generic( level.sandman, "ANIM_throw_grenade" );
	wait 2.33;
	MagicGrenade( "fraggrenade", level.sandman GetTagOrigin( "tag_weapon_right" ), street_ma_1_signal_ac130_ref.origin, 2.5 );
	
	// 4-16 We've got red smoek on the target! You're cleared hot, Warhammer
    if ( !flag( "FLAG_street_ma_1_encounter_complete" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_clearedhot" ], true, 10.0 );
    	
	PlayFxOnTag( fx, street_ma_1_signal_ac130, "tag_origin" );
	flag_wait( "FLAG_street_ma_2_delta_move_down" );
	StopFXOnTag( fx, street_ma_1_signal_ac130, "tag_origin" );
	street_ma_1_signal_ac130 Delete();
}

street_ma_1_dialogue()
{
	flag_wait( "FLAG_fdr_carpet_bombing_finished" );

    // 4-15 Metal Zero One, we're seeing enemy activity headed your way.  Recommend you hold your position until we've swept up, over.
    if ( !flag( "FLAG_street_ma_1_encounter_complete" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_enemyactivity" ], true, 10.0 );
    
    // ** 3-3 Roger.  Wilco.
    if ( !flag( "FLAG_street_ma_1_encounter_complete" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_rogerwilco" ], true, 10.0 );

    // 4-18 Cleared to engage all those guys.
    if ( !flag( "FLAG_street_ma_1_encounter_complete" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "fco" ][ "ac130_fco_thoseguys" ], true, 10.0 );
    
    flag_set( "FLAG_street_ma_1_dialogue_finished" );
}

street_ma_1_encounter()
{	
    flag_set( "FLAG_street_ma_1_encounter_start" );

    // Init Bad Places
    
    badplaces = get_ent_array_with_prefix( "city_area_ma_badplace_0_", "targetname", 0 );
    foreach ( place in badplaces ) 
    	badplace_cylinder( place.targetname, 0, place.origin, 256, 128, "axis" );
    
    flag_wait_thread( "FLAG_street_ma_1_delta_reached", ::street_ma_1_enemies_monitor );
    
    delayThread( 1.0, ::street_ma_1_dialogue );
    thread street_enemy_spawners();
    delayThread( 5.0, ::street_ma_1_btr_spawn );
}

street_ma_1_enemies_reminder()
{
	flag_wait( "FLAG_street_ma_1_dialogue_finished" );
	
	wait 5.0;
	
	sounds = [];

	// 3-5 Hit those guys.
	sounds[ sounds.size ] = level.scr_sound[ "tvo" ][ "ac130_tvo_hitthoseguys" ];
    // 4-31 Keep hittin em!
	sounds[ sounds.size ] = level.scr_sound[ "snd" ][ "ac130_snd_keephittinem" ];
	// 3-18 Go ahead and hit 'em.
    sounds[ sounds.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_goahead" ];
    // 3-22 Light 'em up.
    sounds[ sounds.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_lightemup" ];
    // ** 2-34 Keep hittin em!
    sounds[ sounds.size ] =  level.scr_sound[ "snd" ][ "ac130_snd_keephittinem" ];
    // ** 2-34 Keep firing!!
    sounds[ sounds.size ] =  level.scr_sound[ "snd" ][ "ac130_snd_keepfiring" ];
    // ** 2-34 Keep it coming, Warhammer!!
    sounds[ sounds.size ] =  level.scr_sound[ "snd" ][ "ac130_snd_keepitcoming" ];
    // ** 2-34 Keep it up!!
    sounds[ sounds.size ] =  level.scr_sound[ "snd" ][ "ac130_snd_keepitup" ];
    // 8-5 Guys moving, right there.  Right there.
    sounds[ sounds.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_guysmoving" ];
    // 8-6 Armed personnel still approaching from the East.
    sounds[ sounds.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_armedeast" ];
    // 8-7 Guys moving in the open.
    sounds[ sounds.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_guysinopen" ];
    // 8-11 Enemies crossing in the open.
    sounds[ sounds.size ] =  level.scr_sound[ "tvo" ][ "ac130_tvo_crossingopen" ];
    // 8-12 Go ahead and take em out.
    sounds[ sounds.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_gotakeemout" ];
    
    array = [];
    
    for ( i = 0; i < sounds.size; i++ )
    	array[ array.size ] = i;
    	
    delay = 5.0;
    index = 0;
    	
	while ( !flag( "FLAG_street_ma_1_encounter_complete" ) )
	{
		if ( array.size == 0 )
		{
			for ( i = 0; i < sounds.size; i++ )
    			array[ array.size ] = i;
    		if ( array.size > 1 )
    			array = array_remove_index( array, index );
    	}
		
		index = RandomInt( array.size );
		
		vehicle_scripts\_ac130::playSoundOverRadio( sounds[ array[ index ] ], false );
    	array = array_remove_index( array, index );
		wait delay;
	}
}

street_ma_1_enemies_monitor()
{
	reset_deltas_health( 15000 );
	thread start_timed_mission_failed( 90.0 );
	set_current_street_slope( 1 );
	set_current_battle_line( 1 );
	thread street_ma_1_enemies_reminder();
    thread monitor_encounter_primary_enemies_count( 4, "FLAG_street_ma_1_encounter_complete" );
    thread monitor_encounter_enemies_count( 6, "FLAG_street_ma_1_encounter_complete" );
    flag_wait_or_timeout( "FLAG_street_ma_1_encounter_complete", 60.0 );
    end_timed_mission_failed();
    reset_deltas_health( 15000 );
    kill_encounter_primary_enemies( 1.0 );
    //encounter_primary_enemies_fallback();
    flag_set( "FLAG_street_ma_2_delta_move_down" );
    
    spawner = GetEnt( "city_area_ma_enemy_4", "targetname" );
    spawner._initial_count = 2;
    spawner._max_count = 2;
    
    badplaces = get_ent_array_with_prefix( "city_area_ma_badplace_0_", "targetname", 0 );
    foreach ( place in badplaces ) 
    	badplace_delete( place.targetname );
    deletestructarray_ref( badplaces );
}

street_ma_1_btr_spawn()
{
	btr_spawner = GetEnt( "city_area_ma_btr", "targetname" );
	Assert( IsDefined( btr_spawner ) );
	btr_spawner add_spawn_function( ::monitor_vehicle_mission_fail_points );
	btr_spawner add_spawn_function( ::vehicle_enemy_kill_dialogue_monitor, "btr" );
	
	btr_path = get_connected_ents( "city_area_ma_btr" );
	
	btr = btr_spawner spawn_vehicle();
	vehicle_scripts\_ac130::hud_add_targets( [ btr ] );
	btr gopath();
	
	_flag = "FLAG_street_ma_1_btr_reached_end_of_path";
	range = 128.0;
	thread set_flag_ent1_in_range_of_ent2( btr, btr_path[ btr_path.size - 1 ], range, _flag );
	
	thread street_ma_1_btr_reminder_1( btr );
	thread street_ma_1_btr_reminder_2( btr, btr_path[ btr_path.size - 1 ] );
	btr thread street_ma_1_btr_mission_failed( 60.0 );
	
	wait 0.05;
	
	btr_spawner Delete();
	
	group = level.delta;
    group[ group.size ] = level.makarov_number_2;
    
    btr thread enemy_btr_init( "city_area_ma_btr", "script_noteworthy" );
	btr thread enemy_btr_randomly_shoot_at_targets( group );
	
	btr waittill( "death" );
	flag_set( "FLAG_street_ma_1_btr_killed" );
	flag_set( "FLAG_street_ma_1_btr_reached_end_of_path" );
}

street_ma_1_btr_reminder_1( btr )
{
	Assert( IsDefined( btr ) );
	
	flag_wait( "FLAG_street_ma_1_dialogue_finished" );
	
	player_has_seen_btr = false;
	
	while ( !flag( "FLAG_street_ma_1_btr_killed" ) && !flag( "FLAG_street_ma_1_btr_reminder" ) )
	{
		if ( flag( "FLAG_ac130_loop_0_to_2" ) )
		{
			if ( !player_has_seen_btr )
			{
				if ( within_fov( level.player GetEye(), level.player GetPlayerAngles(), btr.origin, cos( 40 ) ) )
					player_has_seen_btr = true;
			}	
		
			if ( player_has_seen_btr )
			{
				// ** 3-6 There's a BTR moving down the alley ahead of em.
				vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "fco" ][ "ac130_fco_btrdownalley" ], true, 10.0 );
				break;
			}
		}
		wait 0.05;
	}
}
    
street_ma_1_btr_reminder_2( btr, goal )
{
	Assert( IsDefined( btr ) );
	Assert( IsDefined( goal ) );
	
	flag_wait( "FLAG_street_ma_1_dialogue_finished" );
	
	sounds = [];
	
	// ** 5-3 We need that BTR neutralized!
	sounds[ sounds.size ] = level.scr_sound[ "snd" ][ "ac130_snd_btrneutralized" ];
	// ** 5-4 Take out that BTR now!!
	sounds[ sounds.size ] = level.scr_sound[ "snd" ][ "ac130_snd_takeoutbtr" ];
	// ** 2-33 We're under heavy fire!  We need that BTR down now!
	sounds[ sounds.size ] = level.scr_sound[ "snd" ][ "ac130_snd_needbtrdown" ];

    array = [];
    
    for ( i = 0; i < sounds.size; i++ )
    	array[ array.size ] = i;
    	
    delay = 7.5;
    index = 0;
	
	group = level.delta;
    group[ group.size ] = level.makarov_number_2;
	
	delta_has_seen_btr = false;
	first_time_delta_has_seen_btr = false;

	range = 512.0;
	btr thread notify_ent1_when_in_2d_range_of_ent2( btr, goal, range, "LISTEN_btr_close_to_goal" );
	
	while ( !flag( "FLAG_street_ma_1_btr_killed" ) )
	{
		if ( !delta_has_seen_btr )
		{
			btr waittill( "LISTEN_btr_close_to_goal" );
			flag_set( "FLAG_street_ma_1_btr_reminder" );
			
			delta_has_seen_btr = true;
			
			// ** 5-1 Warhammer, we've got some enemy armor moving in.
			if ( !flag( "FLAG_street_ma_1_btr_killed" ) )
				vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_enemyarmor" ], false );
    
    		// ** 5-2 Copy that, Delta 1-1.  Engaging enemy armor.
    		if ( !flag( "FLAG_street_ma_1_btr_killed" ) )
    			vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_enemyarmor" ], false );
    		
    		wait 5.0;
		}
		else
		{
			if ( array.size == 0 )
			{
				for ( i = 0; i < sounds.size; i++ )
	    			array[ array.size ] = i;
	    		if ( array.size > 1 )
	    			array = array_remove_index( array, index );
	    	}
			
			index = RandomInt( array.size );
			
			vehicle_scripts\_ac130::playSoundOverRadio( sounds[ array[ index ] ], false );
	    	array = array_remove_index( array, index );
			wait delay;
		}
		wait 0.05;
	}
}

street_ma_1_btr_mission_failed( time )
{
	Assert( IsDefined( time ) );

	self endon( "death" );
		
	time = ter_op( time < 0, 10, time );
	
	flag_wait( "FLAG_street_ma_1_btr_reached_end_of_path" );
	wait time;
	_mission_failed( "@PARIS_AC130_MISSION_FAIL_HVI_KILLED" );
}

street_ma_1_mi17()
{
	// Spawn Helicopters
	
	mi17_spawner = GetEnt( "street_ma1_mi17", "targetname" );
	Assert( IsDefined( mi17_spawner ) );
    
    mi17_spawner add_spawn_function( ::enemy_mi17_init, "street_ma1_mi17", "targetname", "STATE_air" );
    mi17_spawner add_spawn_function( ::monitor_vehicle_mission_fail_points );
    mi17_spawner add_spawn_function( ::vehicle_enemy_kill_dialogue_monitor, "mi17" );
	
	spots = getstructarray_delete( "street_ma1_mi17", "targetname" );
	
	pilot_spawner = GetEnt( "street_ma1_mi17_pilot", "targetname" );;
	Assert( IsDefined( pilot_spawner ) );
	
	passenger_spawner = GetEnt( "street_ma1_mi17_enemy", "targetname" );
	Assert( IsDefined( passenger_spawner ) );
	    
	passenger_spawner add_spawn_function( ::ai_enemy_mi17_street_patrol_init );
	passenger_spawner add_spawn_function( ::monitor_ai_mission_fail_points );
	
	// Find spawner that is out of player's view
	
	_spot = spots[ 0 ];
	
	foreach ( spot in spots )
	{	
		if ( !within_fov_of_players( spot.origin, cos( GetDvarFloat( "cg_fov" ) ) ) )
		{
			_spot = spot;
			break;
		}
	}    
	
	// If no spawner is out of player's view ( this shouldn't happen ), find the spawner
    // that is MOST out of view ( i.e. near the edge of the screen )
    // **TODO - do this right!
	
	mi17_spawner.count = 1;
	mi17_spawner.angles = _spot get_key( "angles" );
	mi17_spawner.origin = _spot.origin;
	mi17_spawner.target = _spot.target;

	mi17 = mi17_spawner spawn_vehicle();
   
   	wait 0.05;
			    
    mi17 delayThread( 1.0, ::street_ma_1_mi17_monitor );
    mi17 delayThread( 1.0, ::street_ma_1_mi17_enemies_monitor );
          
    mi17 thread enemy_mi17_load_pilot_alt( pilot_spawner );
    mi17 thread enemy_mi17_quick_load_passengers_alt( passenger_spawner, 3 );
    mi17 thread enemy_mi17_street_drop_off();
    
    flag_wait( "FLAG_fdr_carpet_bombing_finished" );
    
    if ( IsDefined( mi17 ) && IsAlive( mi17 ) )
    	vehicle_scripts\_ac130::hud_add_targets( [ mi17 ] );
    
    // Clean up spawner
    
	mi17_spawner Delete();
	mi17 waittill( "death" );
	
	foreach( spot in spots )
		deletestructarray_ref( get_connected_ents( spot.target ), 0.25 );
}

street_ma_1_mi17_enemies_monitor()
{
	passengers = self.script_mi17_passengers;
	
	self ent_flag_wait( "FLAG_helicopter_passengers_unloading" );
	
	nodes = GetNodeArray( "city_area_ma_enemy_cover_4", "targetname" );
	
	foreach ( passenger in passengers )
	{
		if ( IsDefined( passenger ) && IsAlive( passenger ) && IsAI ( passenger ) )
		{
			passenger thread monitor_ai_mission_fail_points();
			
			_node = undefined;
			
			foreach ( node in nodes )
            {
                if ( !IsDefined( node.owner ) )
                { 
                    _node = node;
                    break;
                }
            }
            
            if ( IsDefined( _node ) )
            	passenger set_goal_node( _node );
		}		
	}
	
	delayThread( 3.0, vehicle_scripts\_ac130::hud_add_targets, passengers );
	
	flag_wait( "FLAG_street_ma_2_delta_move_down" );
	
	if ( IsDefined( passengers ) )
	{
		thread add_encounter_primary_enemies( passengers );
		
		while ( !at_least_percent_dead_array( 1.0, passengers ) && 
			    !flag( "FLAG_street_ma_1_helicopter_enemies_killed" ) )
			wait 0.05;
	}
	flag_set( "FLAG_street_ma_1_helicopter_enemies_killed" );
}

street_ma_1_mi17_monitor()
{
	self waittill( "death" );
	
	if ( !( self ent_flag( "FLAG_helicopter_passengers_unloaded" ) ) )
		flag_set( "FLAG_street_ma_1_helicopter_enemies_killed" );
	flag_set( "FLAG_street_ma_1_helicopter_killed" );
}

street_ma_2_delta_move_down()
{
    thread street_ma_2_dialogue();
    
    // Delta + Makarov #2 move into cover
       
    group = level.delta;
   
    cover_nodes = get_ent_array_with_prefix_range( "city_area_ma_friendly_cover_1_", "targetname", 0, 4 );
    Assert( IsDefined( cover_nodes ) );
    
    _flag = "FLAG_street_ma_2_delta_reached";
    timeout = 10;
    thread waittill_ents_notified_set_flag_timeout( group, "LISTEN_ai_goal_reached", _flag, timeout );
    
	level.bishop thread parent_ai_and_child_ai_go_to_node( level.makarov_number_2, cover_nodes[ 4 ], true );
	
    foreach ( i, guy in group )
    {
    	if ( i < 4 )
       		guy set_goal_node( cover_nodes[ i ] );
       	range = 8.0;
       	thread notify_ai_when_in_range_of_ent( guy, cover_nodes[ i ], range, "LISTEN_ai_goal_reached" );
    }
    delayThread( 5.0, ::street_ma_2_encounter );
    delaythread( 5.0, ::street_ma_2_signal_ac130 );
    flag_wait( "FLAG_street_ma_2_delta_reached" );
}

street_ma_2_dialogue()
{
	// ** 3-4 Alright, they're falling back!  Move up, move up!
	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_moveup" ], true, 5.0 );
	
	wait 2.0;
	
	// 4-29 Neutralizing targets, Metal Zero One.  Danger close.  Repeat, danger close.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_dangerclose" ], true, 5.0 );
}

street_ma_2_signal_ac130()
{
	level.sandman waittill( "LISTEN_ai_goal_reached" );
	
	fx = getfx( "FX_signal_ac130" );
	street_ma_2_signal_ac130_ref = getstruct_delete( "street_ma_2_signal_ac130", "targetname" );
	Assert( IsDefined( street_ma_2_signal_ac130_ref ) );
	street_ma_2_signal_ac130 = Spawn( "script_model", street_ma_2_signal_ac130_ref.origin );
	street_ma_2_signal_ac130.angles = street_ma_2_signal_ac130_ref get_key( "angles" );
	street_ma_2_signal_ac130 SetModel( "tag_origin" );
	
	// Have Sandman throw a grenade
	
	angles = VectorToAngles( street_ma_2_signal_ac130_ref.origin - level.sandman.origin );
	tag = Spawn( "script_model", level.sandman.origin );
	tag.angles = level.sandman.angles;
	tag SetModel( "tag_origin" );
	level.sandman LinkTo( tag, "tag_origin" );
	tag RotateYaw( angles[ 1 ] - 180, 0.25 );
	wait 0.25;
	tag Delete();
	level.sandman thread anim_generic( level.sandman, "ANIM_throw_grenade" );
	wait 2.33;
	MagicGrenade( "fraggrenade", level.sandman GetTagOrigin( "tag_weapon_right" ), street_ma_2_signal_ac130_ref.origin, 2.5 );
	
	PlayFxOnTag( fx, street_ma_2_signal_ac130, "tag_origin" );
	flag_wait( "FLAG_street_ma_3_delta_move_down" );
	StopFXOnTag( fx, street_ma_2_signal_ac130, "tag_origin" );
	street_ma_2_signal_ac130 Delete();
}

street_ma_2_encounter()
{
    // Init Bad Places
    
    badplaces = get_ent_array_with_prefix( "city_area_ma_badplace_1_", "targetname", 0 );
    foreach ( place in badplaces ) 
    	badplace_cylinder( place.targetname, 0, place.origin, 256, 128, "axis" );

	//delayThread( 0.05, ::city_area_ma_1_helicopter_spawn );
	
    flag_wait_thread( "FLAG_street_ma_2_flank_spawned", ::street_ma_2_enemies_monitor );
    
    delayThread( 5.0, ::street_ma_2_enemies_spawn_flank_3 );
}

street_ma_2_enemies_reminder()
{
	wait 5.0;
	
	sounds = [];

	// 3-5 Hit those guys.
	sounds[ sounds.size ] = level.scr_sound[ "tvo" ][ "ac130_tvo_hitthoseguys" ];
    // 4-31 Keep hittin em!
	sounds[ sounds.size ] = level.scr_sound[ "snd" ][ "ac130_snd_keephittinem" ];
	// 3-18 Go ahead and hit 'em.
    sounds[ sounds.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_goahead" ];
    // 3-22 Light 'em up.
    sounds[ sounds.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_lightemup" ];
    // ** 2-34 Keep hittin em!
    sounds[ sounds.size ] =  level.scr_sound[ "snd" ][ "ac130_snd_keephittinem" ];
    // ** 2-34 Keep firing!!
    sounds[ sounds.size ] =  level.scr_sound[ "snd" ][ "ac130_snd_keepfiring" ];
    // ** 2-34 Keep it coming, Warhammer!!
    sounds[ sounds.size ] =  level.scr_sound[ "snd" ][ "ac130_snd_keepitcoming" ];
    // ** 2-34 Keep it up!!
    sounds[ sounds.size ] =  level.scr_sound[ "snd" ][ "ac130_snd_keepitup" ];
    // 8-5 Guys moving, right there.  Right there.
    sounds[ sounds.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_guysmoving" ];
    // 8-6 Armed personnel still approaching from the East.
    sounds[ sounds.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_armedeast" ];
    // 8-7 Guys moving in the open.
    sounds[ sounds.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_guysinopen" ];
    // 8-11 Enemies crossing in the open.
    sounds[ sounds.size ] =  level.scr_sound[ "tvo" ][ "ac130_tvo_crossingopen" ];
    // 8-12 Go ahead and take em out.
    sounds[ sounds.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_gotakeemout" ];
    
    array = [];
    
    for ( i = 0; i < sounds.size; i++ )
    	array[ array.size ] = i;
    	
    delay = 5.0;
    index = 0;
    	
	while ( !flag( "FLAG_street_ma_2_encounter_complete" ) )
	{
		if ( array.size == 0 )
		{
			for ( i = 0; i < sounds.size; i++ )
    			array[ array.size ] = i;
    		if ( array.size > 1 )
    			array = array_remove_index( array, index );
    	}
		
		index = RandomInt( array.size );
		
		vehicle_scripts\_ac130::playSoundOverRadio( sounds[ array[ index ] ], false );
    	array = array_remove_index( array, index );
		wait delay;
	}
}

street_ma_2_enemies_monitor()
{
	spawner = GetEnt( "city_area_ma_enemy_2", "targetname" );
    spawner._ai_callbacks[ "after_spawn" ][ "pass_value" ][ 1 ] = ::add_encounter_primary_enemy;
    spawner._ai_callbacks[ "before_spawner_cleanup" ][ "pass_value" ][ 0 ] = ::add_encounter_primary_enemies;
    
	reset_deltas_health( 15000 );
	thread start_timed_mission_failed( 90.0 );
	set_current_battle_line( 2 );
    clear_encounter_primary_enemies();
    clear_encounter_enemies();
    thread street_ma_2_enemies_reminder();
    thread monitor_encounter_primary_enemies_count( 3, "FLAG_street_ma_2_encounter_complete" );
    thread monitor_encounter_primary_enemies_percent( 0.75, "FLAG_street_ma_2_encounter_complete" );
    thread monitor_encounter_enemies_count( 6, "FLAG_street_ma_2_encounter_complete" );
    flag_wait_or_timeout( "FLAG_street_ma_2_encounter_complete", 60.0 );
    end_timed_mission_failed();
    reset_deltas_health( 15000 );
    kill_encounter_primary_enemies( 1.0 );
    //encounter_primary_enemies_fallback();
    flag_wait( "FLAG_street_ma_1_helicopter_enemies_killed" );
    //flag_wait( "FLAG_street_ma_2_flank_killed" );   
    flag_set( "FLAG_street_ma_3_delta_move_down" );
    
    spawner = GetEnt( "city_area_ma_enemy_4", "targetname" );
    spawner._initial_count = 9;
    spawner._max_count = 9;
    
    badplaces = get_ent_array_with_prefix( "city_area_ma_badplace_1_", "targetname", 0 );
    foreach ( place in badplaces ) 
    	badplace_delete( place.targetname );
    deletestructarray_ref( badplaces );
}

street_ma_2_dialogue_flank()
{
	// 4-33 Enemies on our flank!!!
	if ( !flag( "FLAG_street_ma_2_flank_killed" ) )
		vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_onourflank" ], true, 10.0 );
    
    wait 1.0;
    
    // 4-34 Warhammer, we're getting hit from all directions down here!
    if ( !flag( "FLAG_street_ma_2_encounter_complete" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_gettinghit" ], true, 10.0 );
    
    flag_set( "FLAG_city_area_ma_2_dialogue_finished" );
}

street_ma_2_enemies_spawn_flank_3()
{
    delayThread( 8.0, ::street_ma_2_dialogue_flank );
    
    spawner = GetEnt( "city_area_ma_2_enemy_3", "targetname" );
    Assert( IsDefined( spawner ) );
    spawner add_spawn_function( ::monitor_ai_mission_fail_points );
    goals = get_ent_array_with_prefix( "street_ma_friendly_cover_0_", "targetname", 0 );
    
    enemies = [];
	
	for ( i = 0; i < 4; i++ )
	{
		spawner.count = 1;
		guy = spawner StalingradSpawn();
		
		if ( !spawn_failed( guy ) )
		{
			enemies[ i ] = guy;
			enemies[ i ] set_goal_node( goals[ i ] );
			enemies[ i ] thread ai_enemy_street_flanking_init();
			enemies[ i ] thread ai_switch_team_after_spawn();
			enemies[ i ] thread ai_ignore_all_after_spawn();
			enemies[ i ] delayThread( 15.0, ::ai_timed_death_out_of_sight, 45.0, 10.0 );
			wait 2.0;
			vehicle_scripts\_ac130::hud_add_targets( [ enemies[ i ] ] );
		}
	}
	flag_set( "FLAG_street_ma_2_flank_spawned" );
	waittill_ents_notified_set_flag_timeout( enemies, "death", "FLAG_street_ma_2_flank_killed", 30.0 );
	
	foreach ( guy in enemies )
	{
		if ( IsDefined( guy ) && IsAlive( guy ) )
		{
			guy DoDamage( 10000, guy.origin );
			wait 1.5;
		}
	}
	flag_set( "FLAG_street_ma_2_flank_killed" );
}

street_ma_3_delta_move_down()
{
	thread street_ma_3_dialogue();
    
    // Delta + Makarov #2 move into cover
       
    group = level.delta;
    group[ group.size ] = level.makarov_number_2;
   
    cover_nodes = get_ent_array_with_prefix( "city_area_ma_friendly_cover_2_", "targetname", 0 );
    Assert( IsDefined( cover_nodes ) );
    
    _flag = "FLAG_street_ma_3_delta_reached";
    timeout = 10;
    thread waittill_ents_notified_set_flag_timeout( group, "LISTEN_ai_goal_reached", _flag, timeout );
    
    level.bishop thread parent_ai_and_child_ai_go_to_node( level.makarov_number_2, cover_nodes[ 4 ], true );
    
    foreach ( i, guy in group )
    {
    	if ( i < 4 )
        	guy set_goal_node( cover_nodes[ i ] );
        range = 8.0;
        thread notify_ai_when_in_range_of_ent( guy, cover_nodes[ i ], range, "LISTEN_ai_goal_reached" );
    }
    delayThread( 0.05, ::street_ma_3_encounter );
    delaythread( 0.05, ::street_ma_3_signal_ac130 );
    delayThread( 0.05, ::street_ma_3_mi17_spawn );
    flag_wait( "FLAG_street_ma_3_delta_reached" );
}

street_ma_3_dialogue()
{
	// ** 3-12 Good work, Warhammer.  We're Oscar Mike.
	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_goodwork" ], true, 5.0 );
	
	wait 2.0;
	
	// 5-3 Metal Zero One, we're engaging targets ahead of you.  Hold your position.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_aheadofyou" ], true, 5.0 );
}

street_ma_3_signal_ac130()
{
	flag_wait( "FLAG_street_ma_3_delta_reached" );
	
	fx = getfx( "FX_signal_ac130" );
	street_ma_3_signal_ac130_ref = getstruct_delete( "street_ma_3_signal_ac130", "targetname" );
	Assert( IsDefined( street_ma_3_signal_ac130_ref ) );
	street_ma_3_signal_ac130 = Spawn( "script_model", street_ma_3_signal_ac130_ref.origin );
	street_ma_3_signal_ac130.angles = street_ma_3_signal_ac130_ref get_key( "angles" );
	street_ma_3_signal_ac130 SetModel( "tag_origin" );
	
	// Have Sandman throw a grenade
	
	angles = VectorToAngles( street_ma_3_signal_ac130_ref.origin - level.sandman.origin );
	tag = Spawn( "script_model", level.sandman.origin );
	tag.angles = level.sandman.angles;
	tag SetModel( "tag_origin" );
	level.sandman LinkTo( tag, "tag_origin" );
	tag RotateYaw( angles[ 1 ] - 180, 0.25 );
	wait 0.25;
	tag Delete();
	level.sandman thread anim_generic( level.sandman, "ANIM_throw_grenade" );
	wait 2.33;
	MagicGrenade( "fraggrenade", level.sandman GetTagOrigin( "tag_weapon_right" ), street_ma_3_signal_ac130_ref.origin, 2.5 );
	
	PlayFxOnTag( fx, street_ma_3_signal_ac130, "tag_origin" );
	flag_wait( "FLAG_rpg_ac130_angel_flare_start" );
	StopFXOnTag( fx, street_ma_3_signal_ac130, "tag_origin" );
	street_ma_3_signal_ac130 Delete();
}

street_ma_3_encounter()
{
    // Init / clean up Bad Places
    
    badplaces = get_ent_array_with_prefix( "city_area_ma_badplace_2_", "targetname", 0 );
    foreach ( place in badplaces )
    	badplace_cylinder( place.targetname, 0, place.origin, 256, 128, "axis" );
    
    thread street_ma_3_enemies_monitor();
}

street_ma_3_enemies_reminder()
{
	wait 5.0;
	
	sounds = [];

	// 3-5 Hit those guys.
	sounds[ sounds.size ] = level.scr_sound[ "tvo" ][ "ac130_tvo_hitthoseguys" ];
    // 4-31 Keep hittin em!
	sounds[ sounds.size ] = level.scr_sound[ "snd" ][ "ac130_snd_keephittinem" ];
	// 3-18 Go ahead and hit 'em.
    sounds[ sounds.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_goahead" ];
    // 3-22 Light 'em up.
    sounds[ sounds.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_lightemup" ];
    // ** 2-34 Keep hittin em!
    sounds[ sounds.size ] =  level.scr_sound[ "snd" ][ "ac130_snd_keephittinem" ];
    // ** 2-34 Keep firing!!
    sounds[ sounds.size ] =  level.scr_sound[ "snd" ][ "ac130_snd_keepfiring" ];
    // ** 2-34 Keep it coming, Warhammer!!
    sounds[ sounds.size ] =  level.scr_sound[ "snd" ][ "ac130_snd_keepitcoming" ];
    // ** 2-34 Keep it up!!
    sounds[ sounds.size ] =  level.scr_sound[ "snd" ][ "ac130_snd_keepitup" ];
    // 8-5 Guys moving, right there.  Right there.
    sounds[ sounds.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_guysmoving" ];
    // 8-6 Armed personnel still approaching from the East.
    sounds[ sounds.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_armedeast" ];
    // 8-7 Guys moving in the open.
    sounds[ sounds.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_guysinopen" ];
    // 8-11 Enemies crossing in the open.
    sounds[ sounds.size ] =  level.scr_sound[ "tvo" ][ "ac130_tvo_crossingopen" ];
    // 8-12 Go ahead and take em out.
    sounds[ sounds.size ] =  level.scr_sound[ "fco" ][ "ac130_fco_gotakeemout" ];
    
    array = [];
    
    for ( i = 0; i < sounds.size; i++ )
    	array[ array.size ] = i;
    	
    delay = 4.0;
    index = 0;
    	
	while ( !flag( "FLAG_street_ma_3_encounter_complete" ) )
	{
		if ( array.size == 0 )
		{
			for ( i = 0; i < sounds.size; i++ )
    			array[ array.size ] = i;
    		if ( array.size > 1 )
    			array = array_remove_index( array, index );
    	}
		
		index = RandomInt( array.size );
		
		vehicle_scripts\_ac130::playSoundOverRadio( sounds[ array[ index ] ], false );
    	array = array_remove_index( array, index );
		wait delay;
	}
}

street_ma_3_enemies_monitor()
{
	spawner = GetEnt( "city_area_ma_enemy_3", "targetname" );
    spawner._ai_callbacks[ "after_spawn" ][ "pass_value" ][ 1 ] = ::add_encounter_primary_enemy;
    spawner._ai_callbacks[ "before_spawner_cleanup" ][ "pass_value" ][ 0 ] = ::add_encounter_primary_enemies;
    
    reset_deltas_health( 15000 );
	thread start_timed_mission_failed( 90.0 );
	set_current_battle_line( 3 );
	flag_wait( "FLAG_street_ma_1_btr_killed" );
	flag_wait( "FLAG_street_ma_3_delta_reached" );
	
    clear_encounter_primary_enemies();
    clear_encounter_enemies();
    thread street_ma_3_enemies_reminder();
    thread monitor_encounter_primary_enemies_count( 2, "FLAG_street_ma_3_encounter_complete" );
    thread monitor_encounter_primary_enemies_percent( 0.5, "FLAG_street_ma_3_encounter_complete" );
    thread monitor_encounter_enemies_count( 4, "FLAG_street_ma_3_encounter_complete" );
    flag_wait_or_timeout( "FLAG_street_ma_3_encounter_complete", 60.0 );
    reset_deltas_health( 15000 );
    end_timed_mission_failed();
    reset_deltas_health( 15000 );
    kill_encounter_primary_enemies( 1.0 );
    //encounter_primary_enemies_fallback();
    flag_wait( "FLAG_street_ma_3_helicopter_1_enemies_killed" );
    flag_wait( "FLAG_street_ma_3_helicopter_2_enemies_killed" );
        
    flag_set( "FLAG_rpg_delta_move_down" );
    
    spawner = GetEnt( "city_area_ma_enemy_4", "targetname" );
    spawner._initial_count = 14;
    spawner._max_count = 14;
}

street_ma_3_mi17_spawn()
{
	// Spawn Helicopters
	
	mi17_spawner = GetEnt( "street_ma3_mi17", "targetname" );
	Assert( IsDefined( mi17_spawner ) );
    
    mi17_spawner add_spawn_function( ::enemy_mi17_init, "city_area_ma3_helicopter", "targetname", "STATE_air" );
    mi17_spawner add_spawn_function( ::monitor_vehicle_mission_fail_points );
    mi17_spawner add_spawn_function( ::vehicle_enemy_kill_dialogue_monitor, "mi17" );
	
	spots = getstructarray_delete( "street_ma3_mi17", "targetname" );
	spots = array_index_by_script_index( spots );
	
	pilot_spawner = GetEnt( "street_ma3_mi17_pilot", "targetname" );
	Assert( IsDefined( pilot_spawner ) );
	
	passenger_spawner = GetEnt( "street_ma3_mi17_enemy", "targetname" );
	Assert( IsDefined( passenger_spawner ) );
	    
	passenger_spawner add_spawn_function( ::ai_enemy_mi17_street_patrol_init );
	passenger_spawner add_spawn_function( ::monitor_ai_mission_fail_points );
	
	// Find spawner that is out of player's view
	
	_spots = [];
	_spots[ 0 ] = spots[ 0 ];
	_spots[ 1 ] = spots[ 1 ];
	
	foreach ( i, spot in spots )
	{
		if ( !( i % 2 ) )
		{
			if ( !within_fov_of_players( spot.origin, cos( GetDvarFloat( "cg_fov" ) ) ) )
			{
				_spots[ 0 ] = spot;
				_spots[ 1 ] = spots[ i + 1 ];
				break;
			}
		}
	}    
	
	mi17s = [];
	
	foreach ( i, spot in _spots )
	{
		mi17_spawner.count = 1;
		mi17_spawner.angles = spot get_key( "angles" );
		mi17_spawner.origin = spot.origin;
		mi17_spawner.target = spot.target;
	
		mi17s[ i ] = mi17_spawner spawn_vehicle();
		
		wait 0.05;
	    
	    vehicle_scripts\_ac130::hud_add_targets( [ mi17s[ i ] ] );
	    
	    switch ( i )
	    {
	    	case 0:
	    		mi17s[ 0 ] delayThread( 1.0, ::street_ma_3_mi17_1_monitor );
    			mi17s[ 0 ] delayThread( 1.0, ::street_ma_3_mi17_1_enemies_monitor );
	    		break;
	    	case 1:
	    		mi17s[ 1 ] delayThread( 1.0, ::street_ma_3_mi17_2_monitor );
    			mi17s[ 1 ] delayThread( 1.0, ::street_ma_3_mi17_2_enemies_monitor );
    			break;
	    }
	    		   
	    mi17s[ i ] thread enemy_mi17_load_pilot_alt( pilot_spawner );
	    mi17s[ i ] thread enemy_mi17_quick_load_passengers_alt( passenger_spawner, 2 );
	    mi17s[ i ] thread enemy_mi17_street_drop_off();
	    wait 2.0;
	}
    
    thread street_ma_3_mi17_sighted( mi17s );
    thread street_ma_3_mi17_death();
    
    // Clean up spawner
    
	mi17_spawner Delete();
}

street_ma_3_mi17_death()
{
	flag_wait( "FLAG_street_ma_3_helicopter_1_killed" );
	flag_wait( "FLAG_street_ma_3_helicopter_2_killed" );
	
	// 5-8 Vehicles neutralized.
	if ( !flag( "FLAG_rpg_delta_fallback" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "fco" ][ "ac130_fco_vehiclesneutralized" ], false );
}

street_ma_3_mi17_sighted( helicopters )
{
	Assert( IsDefined( helicopters ) && IsArray( helicopters ) );
	
	while ( !flag( "FLAG_street_ma_3_helicopter_sighted" ) )
	{
		foreach ( helicopter in helicopters )
		{ 
			if ( within_fov_of_players( helicopter.origin, cos( 55 ) ) )
			{
				flag_set( "FLAG_street_ma_3_helicopter_sighted" );
				break;
			}
		}
		wait 0.05;		
	}
	
	wait 4.0;
	
    // 5-2 Two enemy birds in the center of the fork, there.
    if ( !flag( "FLAG_street_ma_3_helicopter_1_killed" ) && !flag( "FLAG_street_ma_3_helicopter_2_killed" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "fco" ][ "ac130_fco_twobirds" ], true, 10.0 );
}

street_ma_3_mi17_1_enemies_monitor()
{
	passengers = self.script_mi17_passengers;
	
	self ent_flag_wait( "FLAG_helicopter_passengers_unloading" );
	
	nodes = GetNodeArray( "city_area_ma_enemy_cover_4", "targetname" );
	
	foreach ( passenger in passengers )
	{
		if ( IsDefined( passenger ) && IsAlive( passenger ) && IsAI ( passenger ) )
		{
			passenger thread monitor_ai_mission_fail_points();
			
			_node = undefined;
			
			foreach ( node in nodes )
            {
                if ( !IsDefined( node.owner ) )
                { 
                    _node = node;
                    break;
                }
            }
            
            if ( IsDefined( _node ) )
            	passenger set_goal_node( _node );
		}	
	}
	
	delayThread( 3.0, vehicle_scripts\_ac130::hud_add_targets, passengers );
	
	flag_wait( "FLAG_street_ma_3_delta_move_down" );
	
	if ( IsDefined( passengers ) )
	{
		thread add_encounter_primary_enemies( passengers );
		
		while ( !at_least_percent_dead_array( 1.0, passengers ) && 
			    !flag( "FLAG_street_ma_3_helicopter_1_enemies_killed" ) )
			wait 0.05;
	}
	flag_set( "FLAG_street_ma_3_helicopter_1_enemies_killed" );
}

street_ma_3_mi17_1_monitor()
{
	msg = self waittill_any_return( "death", "LISTEN_helicopter_passengers_unloaded" );
	
	if ( msg == "LISTEN_helicopter_passengers_unloaded" )
	{
		flag_set( "FLAG_street_ma_3_helicopter_1_unloaded" );
		self waittill( "death" );
	}
	
	flag_set( "FLAG_street_ma_3_helicopter_1_enemies_killed" );
	flag_set( "FLAG_street_ma_3_helicopter_1_killed" );
	flag_set( "FLAG_street_ma_3_helicopter_1_unloaded" );
}

street_ma_3_mi17_2_enemies_monitor()
{
	passengers = self.script_mi17_passengers;
	
	self ent_flag_wait( "FLAG_helicopter_passengers_unloading" );
	
	nodes = GetNodeArray( "city_area_ma_enemy_cover_4", "targetname" );
	
	foreach ( passenger in passengers )
	{
		if ( IsDefined( passenger ) && IsAlive( passenger ) && IsAI ( passenger ) )
		{
			passenger thread monitor_ai_mission_fail_points();
			
			_node = undefined;
			
			foreach ( node in nodes )
            {
                if ( !IsDefined( node.owner ) )
                { 
                    _node = node;
                    break;
                }
            }
            
            if ( IsDefined( _node ) )
            	passenger set_goal_node( _node );
		}			
	}
	
	delayThread( 3.0, vehicle_scripts\_ac130::hud_add_targets, passengers );
	
	flag_wait( "FLAG_street_ma_3_delta_move_down" );
	
	if ( IsDefined( passengers ) )
	{
		thread add_encounter_primary_enemies( passengers );
		
		while ( !at_least_percent_dead_array( 1.0, passengers ) && 
			    !flag( "FLAG_street_ma_3_helicopter_2_enemies_killed" ) )
			wait 0.05;
	}
	flag_set( "FLAG_street_ma_3_helicopter_2_enemies_killed" );
}

street_ma_3_mi17_2_monitor()
{
	msg = self waittill_any_return( "death", "LISTEN_helicopter_passengers_unloaded" );
	
	if ( msg == "LISTEN_helicopter_passengers_unloaded" )
	{
		flag_set( "FLAG_street_ma_3_helicopter_2_unloaded" );
		self waittill( "death" );
	}
	
	flag_set( "FLAG_street_ma_3_helicopter_2_enemies_killed" );
	flag_set( "FLAG_street_ma_3_helicopter_2_killed" );
	flag_set( "FLAG_street_ma_3_helicopter_2_unloaded" );
}


street_clean_up()
{
}

street_catch_up_clean_up()
{
	ents = [];
	ents = add_to_array( ents, GetEnt( "city_area_ma_btr", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "street_ma1_mi17", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "street_ma1_mi17_pilot", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "street_ma1_mi17_enemy", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "street_ma3_mi17", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "street_ma3_mi17_pilot", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "street_ma3_mi17_enemy", "targetname" ) );
	
	foreach ( ent in ents )
	{
		if ( IsDefined( ent ) )
		{
			ent notify( "death" );
			ent Delete();
		}
	}
	street_delete_structs();
}

street_delete_structs()
{
	structs =[];
	structs = add_to_array( structs, getstruct( "street_ma_1_signal_ac130", "targetname"  ) );
	structs = array_combine( structs, get_ent_array_with_prefix( "city_area_ma_badplace_0_", "targetname", 0 ) );
	
	structs = array_combine( structs, getstructarray( "street_ma1_mi17", "targetname" ) );
	spots = getstructarray( "street_ma1_mi17", "targetname" );
	foreach ( spot in spots )
		structs = array_combine( structs, get_connected_ents( spot.target ) );
	structs = array_combine( structs, getstructarray( "street_ma3_mi17", "targetname" ) );
	spots = getstructarray( "street_ma3_mi17", "targetname" );
	foreach ( spot in spots )
		structs = array_combine( structs, get_connected_ents( spot.target ) );
	
	thread deletestructarray_ref( structs, 0.2 );
}

catch_up_rpg()
{
	wait 0.05;
	
	flag_set( "FLAG_fdr_delta_ready_to_move_to_street" );
	
	flag_set( "FLAG_street_ma_1_encounter_start" );
	flag_set( "FLAG_street_ma_1_btr_reached_end_of_path" );
	flag_set( "FLAG_street_ma_1_btr_killed" );
	flag_set( "FLAG_street_ma_1_helicopter_killed" );
	flag_set( "FLAG_street_ma_1_helicopter_enemies_killed" );
	flag_set( "FLAG_street_ma_1_encounter_complete" );
	flag_set( "FLAG_street_ma_1_delta_reached" );
	flag_set( "FLAG_street_ma_2_delta_move_down" );
	flag_set( "FLAG_street_ma_2_delta_reached" );
	flag_set( "FLAG_street_ma_2_flank_spawned" );
	flag_set( "FLAG_street_ma_2_flank_killed" );
	flag_set( "FLAG_street_ma_2_encounter_complete" );
	flag_set( "FLAG_street_ma_3_delta_move_down" );
	flag_set( "FLAG_street_ma_3_delta_reached" );
	flag_set( "FLAG_street_ma_3_helicopter_1_unloaded" );
	flag_set( "FLAG_street_ma_3_helicopter_1_killed" );
	flag_set( "FLAG_street_ma_3_helicopter_1_enemies_killed" );
	flag_set( "FLAG_street_ma_3_helicopter_2_unloaded" );
	flag_set( "FLAG_street_ma_3_helicopter_2_killed" );
	flag_set( "FLAG_street_ma_3_helicopter_2_enemies_killed" );
	flag_set( "FLAG_street_ma_3_encounter_complete" );
	
	flag_set( "FLAG_rpg_delta_move_down" );
	
	flag_set( "FLAG_ac130_loop_2_to_3" );
	flag_set( "FLAG_ac130_loop_3" );
	
	Objective_Add( obj( "OBJ_STREET_Clear_Area" ), "current", &"PARIS_AC130_OBJ_STREET_CLEAR_STREET_FOR_KILO_1_1" );
	Objective_State( obj( "OBJ_STREET_Clear_Area" ), "done" );
	
	thread street_catch_up_clean_up();
	
	// Delete btrs from beginning

	btrs = [];
	btrs = add_to_array( btrs, GetEnt( "city_area_fdr_btr", "script_noteworthy" ) );
	btrs = add_to_array( btrs, GetEnt( "intro_fdr_btr", "script_noteworthy" ) );
	
	foreach ( btr in btrs )
	{
		btr godoff();
		btr DoDamage( 10000, ( 0, 0, 0 ), level.player );
	}
	
	delta_spawn_at_fast_point( "rpg" );
	vehicle_scripts\_ac130::hud_add_friendly_targets();
	wait 0.05;
	
	thread street_enemy_spawners();
	
	transition_node = GetVehicleNode( "city_area_loop_3_out", "script_noteworthy" );
	Assert( IsDefined( transition_node ) );
	level.ac130_vehicle switch_vehicle_path( transition_node );
	
	thread rpg_angel_flare_moment();
}

start_rpg()
{
	thread vehicle_scripts\_ac130::autosave_ac130();
	thread rpg_hints();
    		
    flag_wait( "FLAG_rpg_delta_move_down" );
    thread rpg_delta_move_down();
    
    flag_wait( "FLAG_rpg_building_valid_target" );
    Objective_Add( obj( "OBJ_RPG_Destroy_Building" ), "current", &"PARIS_AC130_OBJ_RPG_DESTROY_RPG_BUILDING" );
    
    flag_wait( "FLAG_rpg_building_dialgoue_finished" );
    Objective_State( obj( "OBJ_RPG_Destroy_Building" ), "done" );
    
    thread vehicle_scripts\_ac130::autosave_ac130();
    
    flag_wait( "FLAG_ac130_flare_event_finished" );
    Objective_State( obj( "OBJ_STREET_Clear_Area" ), "done" );
}

rpg_hints()
{
	timeout = 5.0;
	
	if ( flag( "FLAG_ac130_thermal_enabled" ) )
		level.player thread display_hint_timeout( "HINT_ac130_enhanced_vision", timeout );
	wait 8.0;
	level.player display_hint_timeout( "HINT_ac130_using_zoom", timeout );
}

ac130_angel_flare_event_dialogue()
{
	thread courtyard_cleanup_outside();
	
    // 6-7 Flares, flares!
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "fco" ][ "ac130_fco_flaresflares" ], true, 10.0 );
    
    // 6-8 Flares away, flares away.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "tvo" ][ "ac130_tvo_flaresaway" ], true, 10.0 );
    
    // 6-9 Clean up that signal.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_cleanupsignal" ], true, 10.0 );
    
    // 6-10 Jester Two Five, breaking away - in pursuit!
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "j25" ][ "ac130_j25_inpursuit" ], true, 10.0 );
    
    // 6-11 Stay on him!
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "j24" ][ "ac130_j24_stayonhim" ], true, 10.0 );
    
    // 6-12 Air speed three hundred.  Going for missile lock.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "j25" ][ "ac130_j25_missilelock" ], true, 10.0 );
	
    // 6-13 Warhammer, LANTIRN is clear in this sector, but advise you to clear out for now.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "j24" ][ "ac130_j24_clearout" ], true, 10.0 );
    
    // 6-14 Copy that, Two Four.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_copythat24" ], true, 10.0 );
    
    thread rpg_focus_on_courtyard_building();
    
    flag_set( "FLAG_ac130_flare_event_finished" );
}

rpg_focus_on_courtyard_building()
{
	vehicle_scripts\_ac130::ac130_set_view_arc( 3, 1.5, 1.5, 0, 0, 15, 0 );
	wait 3.0;
	vehicle_scripts\_ac130::ac130_set_view_arc( 1, 0.5, 0.5, 30, 30, 30, 30 );
}

rpg_angel_flare_moment()
{
	level endon( "LISTEN_end_rpg_angel_flare_moment" );
	
	thread rpg_angel_flare_moment_monitor();
	
	loop_3 = get_connected_ents( "city_area_loop_3_out" );
	starting_nodes = [];
	
	foreach ( node in loop_3 )
		if ( IsDefined( node.script_parameters ) )
			starting_nodes[ starting_nodes.size ] = node;
			
	nodes = GetVehicleNodeArray( "city_area_loop_3_angel_flare_out", "targetname" );
	transition_nodes = [];
	
	foreach ( node in nodes )
		transition_nodes[ node.script_parameters ] = node;

	i = 1;
		
	while( !flag( "FLAG_ac130_flare_event_started" ) )
	{
		i = ter_op( i >= starting_nodes.size, 0, i );
		
		starting_nodes[ i ] waittill( "trigger" );
		
		if ( flag( "FLAG_rpg_ac130_angel_flare_start" ) )
		{
			level.ac130_vehicle switch_vehicle_path_lerp( transition_nodes[ starting_nodes[ i ].script_parameters ] );
			
			rpg_angel_flare_pre_event( starting_nodes[ i ].script_parameters );
			
			flare_event_node = GetVehicleNode( "city_area_loop_3_to_4_angel_flare_in", "script_noteworthy" );
			Assert( IsDefined( flare_event_node ) );
			level.ac130_vehicle switch_vehicle_path( flare_event_node );
	
			thread ac130_angel_flare_event( "city_area_loop_3_to_4_angel_flare", i );
			thread ac130_angel_flare_event_dialogue();
			break;
		}
		i++;
	}
}

rpg_angel_flare_pre_event( index )
{
	index = ter_op( IsDefined( index ), index, "1" );
	
	delaythread( 0.05, ::rpg_angel_flare_pre_event_set_view );
	thread rpg_angel_flare_pre_event_shake();
	thread rpg_angel_flare_pre_event_static();
	wait 3.0;
}

rpg_angel_flare_pre_event_dog_fight()
{	
	delayThread( 3.0, ::rpg_angel_flare_pre_event_dog_fight_dialogue );
	delayThread( 7.0, ::rpg_angle_flare_pre_event_missile_warning );
	delayThread( 5.0, ::ac130_angel_flare_missiles, "city_area_loop_3_angel_flare" );
	
	level.player thread play_sound_on_entity( "scn_ac130_avoid_missile_rev" );
	
	// f15s
	
	f15_spawner = GetEnt( "rpg_f15", "targetname" );
	Assert( IsDefined( f15_spawner ) );
	f15_spawner add_spawn_function( ::friendly_f15_init );
	f15_spawner add_spawn_function( ::friendly_f15_sonic_boom, "scn_ac130_bomber_sonic_boom" );
	f15_spawner add_spawn_function( ::friendly_f15_delete_on_path_end );
	f15_spots = getstructarray_delete( "rpg_f15", "targetname", 0.25 );
	
	// migs
	
	mig_spawner = GetEnt( "rpg_mig", "targetname" );
	Assert( IsDefined( mig_spawner ) );
	mig_spawner add_spawn_function( ::enemy_mig29_init );
	mig_spawner add_spawn_function( ::enemy_mig29_sonic_boom, "scn_ac130_bomber_sonic_boom" );
	mig_spawner add_spawn_function( ::enemy_mig29_delete_on_path_end );
	mig_spots = getstructarray_delete( "rpg_mig", "targetname", 0.25 );
	
	delay = 0.5;
	
	_f15_spots = [];
	
	foreach ( spot in f15_spots )
		if ( spot compare_value( "script_index", level.ac130_current_spline_section ) )
			_f15_spots[ _f15_spots.size ] = spot;
	
	foreach ( i, f15_spot in _f15_spots )
	{
		mig_spot = undefined;
		
		foreach ( spot in mig_spots )
		{
			if ( spot compare_value( "script_index", f15_spot.script_index ) )
			{
				mig_spot = spot;
				break;
			}
		}
		
		time = 1.5;
		elapsed = 0;
		start = f15_spot.origin;
		end = start + 100 * AnglesToForward( f15_spot get_key( "angles" ) );
		fwd = VectorNormalize( end - start );
		while ( elapsed < time )
		{
			PlayFX( getfx( "FX_jet_20mm_tracer_close_ac130" ), start + random_vector( -64, 64 ), fwd );
			elapsed += 0.05;
			wait 0.05;
		}
	
		// **TODO: see if we want to have the migs explode / get damaged
		
		mig = undefined;
		
		if ( IsDefined( mig_spot ) )
		{
			mig_spawner.count = 1;
			mig_spawner.origin = mig_spot.origin;
			mig_spawner.angles = mig_spot get_key( "angles" );
			mig_spawner.target = mig_spot.target;
			mig = mig_spawner spawn_vehicle();
			
			mig delayThread( 0.05, ::gopath );
			//mig delayThread( 0.05, ::enemy_mig29_randomly_die, info[ 0 ], info[ 1 ], info[ 2 ] );
		}
	
		f15 = undefined;
		
		if ( IsDefined( f15_spot ) )
		{
			f15_spawner.count = 1;
			f15_spawner.origin = f15_spot.origin;
			f15_spawner.angles = f15_spot get_key( "angles" );
			f15_spawner.target = f15_spot.target;
			f15 = f15_spawner spawn_vehicle();
			
			f15 delayThread( 0.75, ::gopath );
		}
		_delay = ter_op( IsDefined( f15 ) || IsDefined( mig ), delay, 0.1 );
		_delay = ter_op( i == _f15_spots.size, 0.05, delay );
		wait _delay;
	}
	
	// Clean Up
	
	f15_spawner Delete();
	mig_spawner Delete();
}

rpg_angel_flare_pre_event_dog_fight_dialogue()
{	
	// 6-5 MiG inbound!  Ten o' clock!
   	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "j25" ][ "ac130_j25_miginbound" ], true, 10.0 );
   	
   	wait 2.0;
   	
   	// 6-6 Shit!  Broke lock!
   	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "j25" ][ "ac130_j25_brokelock" ], true, 10.0 );
}

rpg_angle_flare_pre_event_missile_warning()
{
	level.player thread play_loop_sound_on_entity( "missile_warning" );
	thread vehicle_scripts\_ac130::hud_lock_on_flash_start( 0.1 );
}

rpg_angel_flare_pre_event_set_view()
{
	level.player FreezeControls( true );
	
	delay = 0;
	
	// Set vision to "Enhanced"
	
	if ( flag( "FLAG_ac130_thermal_enabled" ) )
	{
		level.player notify( "LISTEN_ac130_change_vision" );
		delay += 0.05;
	}
	
	SetDvar( "ac130_zoom_enabled", 0 );
	level.ac130_current_fov = 55;
	SetSavedDvar( "cg_fov", level.ac130_current_fov );
	level.player LerpFOV( level.ac130_current_fov , ( 1 / 60 ) );
	wait delay;
	SetDvar( "ac130_zoom_enabled", 1 );
	level.player FreezeControls( false );
}

rpg_angel_flare_pre_event_shake()
{	
	level.player PlayRumbleLoopOnEntity( "damage_light" );
	earthquake_at_ent( 0.25, 1.0, level.player, 1000 );
	level.player StopRumble( "damage_light" );
	
	level.player PlayRumbleLoopOnEntity( "damage_light" );
	earthquake_at_ent( 0.1, 3.0, level.player, 1000 );
	level.player StopRumble( "damage_light" );
	
	level.player PlayRumbleLoopOnEntity( "damage_heavy" );
	earthquake_at_ent( 0.5, 0.75, level.player, 1000 );
	level.player StopRumble( "damage_heavy" );
	
	level.player PlayRumbleLoopOnEntity( "damage_light" );
	earthquake_at_ent( 0.1, 0.75, level.player, 1000 );
	level.player StopRumble( "damage_light" );
}

rpg_angel_flare_pre_event_static()
{
	vehicle_scripts\_ac130::hud_toggle_static_over_time( 0.5, 1 );
	
	wait 2.0;
	
	level.player FreezeControls( true );
	vehicle_scripts\_ac130::hud_off();
	level.player SetBlurForPlayer( 10, 0 );
	vehicle_scripts\_ac130::hud_set_static( 5.0 );
	vehicle_scripts\_ac130::hud_set_grain( 5.0 );
	
	flag_set( "FLAG_ac130_angel_flare_teleport" );
			
	wait 1.5;
	blur = ter_op( flag( "FLAG_ac130_thermal_enabled" ), level.ac130_thermal_blur, level.ac130_enhanced_blur );
	level.player SetBlurForPlayer( blur, 0 );
	vehicle_scripts\_ac130::hud_set_static( 0.0 );
	grain = ter_op( flag( "FLAG_ac130_thermal_enabled" ), level.ac130_thermal_grain, level.ac130_enhanced_grain );
	vehicle_scripts\_ac130::hud_set_grain( grain );
	vision = ter_op( flag( "FLAG_ac130_thermal_enabled" ), "thermal", "enhanced" );
	vehicle_scripts\_ac130::hud_on( vision );
	
	// Set view again
	
	// **TODO: Set Player's look at
		
	//flag_clear( "FLAG_ac130_change_weapons_enabled" );
	SetDvar( "ac130_zoom_enabled", 0 );
	level.ac130_current_fov = 55;
	SetSavedDvar( "cg_fov", level.ac130_current_fov );
	level.player LerpFOV( level.ac130_current_fov , ( 1 / 60 ) );
	level.player FreezeControls( false );
}

rpg_angel_flare_moment_monitor()
{
	thread rpg_angel_flar_moment_monitor_ac130_position();

	flag_wait( "FLAG_street_ma_1_btr_killed" );
	flag_wait( "FLAG_street_ma_3_delta_reached" );
	flag_wait( "FLAG_street_ma_3_helicopter_1_unloaded" );
	flag_wait( "FLAG_street_ma_3_helicopter_2_unloaded" );
	flag_set( "FLAG_street_ma_3_encounter_complete" );
	
	if ( !flag( "FLAG_ac130_loop_3" ) )
		level.ac130_vehicle Vehicle_SetSpeed( 45, 5, 5 );
		
	flag_wait( "FLAG_rpg_building_falling_down" );
	
	vehicle_scripts\_ac130::ac130_set_view_arc( 2.0, 1.0, 1.0, 65, 65, 35, 55 );
	
	if ( !flag( "FLAG_ac130_flare_event_finished" ) )
	{
		flag_wait( "FLAG_rpg_building_dialgoue_finished" );
		rpg_angel_flare_pre_event_dog_fight();
		flag_set( "FLAG_rpg_ac130_angel_flare_start" );
	
		level.ac130_vehicle Vehicle_SetSpeed( 40, 5, 5 );
	}
}

rpg_angel_flar_moment_monitor_ac130_position()
{
	flag_wait( "FLAG_ac130_loop_3" );
	
	level.ac130_current_spline = "loop_3";
	level.ac130_current_spline_section = 2;
	
	loop_3_path = get_connected_ents( "city_area_loop_3_out" );
	jet_nodes = [];
	
	for( i = 1; i <= 4; i++ )
		jet_nodes[ i ] = get_ents_from_array( i, "script_index", loop_3_path )[ 0 ];
	
	i = 3;
	timeout = 25.0;

	while( !( flag( "FLAG_rpg_ac130_angel_flare_start" ) ) )
	{
		i = ter_op( i > 4, 1, i );
		jet_nodes[ i ] waittill_any_timeout( timeout, "trigger" );
		level.ac130_current_spline_section = i;
		i++;
	}
}


rpg_delta_move_down_dialogue()
{   
    // 5-10 Heh, copy that. We're moving up now.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_movinnow" ], true, 10.0 );
    
    // 5-11 Copy.  Left at the fork.
    //vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_leftatfork" ], true ); //**TODO after e3
}

rpg_delta_move_down()
{	
	// 5-9 Metal Zero One, looks like you're clear to move up.  We'll keep an eye on you.
	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_cleartomoveup" ], true, 10.0 );
	
	// Make Enemies move toward delta
	
	ais = GetAIArray( "axis" );
	ais = array_combine( ais, GetAIArray( "team3" ) );
	enemy_goal = getstruct( "rpg_street_enemy_goal", "targetname" );
	
	foreach ( ai in ais )
	{
		ai set_goal_radius( RandomFloatRange( 256, 512 ) );
		ai SetGoalPos( enemy_goal.origin );
	}
	
	spawner = GetEnt( "city_area_ma_enemy_4", "targetname" );
	spawner._ai_callbacks[ "after_spawn" ][ "caller" ][ 6 ] = ::rpg_street_enemy_management;
		
    // Move Down Street
    
    thread rpg_pip_event();
    thread rpg_delta_move_down_dialogue();
    
    goals = getstructarray( "rpg_friendly_point", "targetname" );
    goals = array_index_by_script_index( goals );
    
    look_at = GetEnt( "rpg_building_look_at", "targetname" );
    Assert( IsDefined( look_at ) );
    
    foreach ( guy in level.delta )
    	guy SetLookAtEntity( look_at );
    
    level.sandman delayCall( 1.0, ::SetGoalPos, goals[ 0 ].origin );
    level.frost SetGoalPos( goals[ 1 ].origin );
    level.hitman SetGoalPos( goals[ 2 ].origin );
    level.gator SetGoalPos( goals[ 3 ].origin );
    
   	thread rpg_encounter();
    
    level.bishop parent_ai_and_child_ai_go_to_node( level.makarov_number_2, goals[ 4 ], true );
    //deletestructarray_ref( goals );
    
    // Scatter
    
    goals = getstructarray( "rpg_friendly_scatter_point", "targetname" );
    goals = array_index_by_script_index( goals );
    
    foreach ( i, guy in level.delta )
    {
    	if ( i < 4 )
        	guy SetGoalPos( goals[ i ].origin );
    }
    
    level.bishop parent_ai_and_child_ai_go_to_node( level.makarov_number_2, goals[ 4 ], true );
    //deletestructarray_ref( goals );
    
    // Fallback
    
    cover_nodes = get_ent_array_with_prefix( "city_area_ma_friendly_cover_2_", "targetname", 0 );
    Assert( IsDefined( cover_nodes ) );

    level.bishop thread parent_ai_and_child_ai_go_to_node( level.makarov_number_2, cover_nodes[ 4 ], true );
    
    foreach ( i, guy in level.delta )
    {
    	if ( i < 4 )
        	guy set_goal_node( cover_nodes[ i ] );
    }
    
    flag_set( "FLAG_rpg_delta_fallback" );
    
    flag_wait( "FLAG_ac130_flare_event_started" );
    
    // Get Delta Inside Building
   	
   	goals = getstructarray_delete( "building_friendly_point", "targetname" );
   	goals = array_index_by_script_index( goals );
   	level.frost InvisibleNotSolid();
   	level.frost Hide();
   	if ( Target_IsTarget( level.frost ) )
   		Target_Remove( level.frost );
   	level.bishop clear_parent_ai();
	level.makarov_number_2 clear_child_ai();
	wait 0.05;
	group = [ level.sandman, level.hitman, level.gator, level.bishop, level.makarov_number_2 ];
	foreach ( i, guy in group )
	{
		guy SetGoalPos( goals[ i ].origin );
		guy ForceTeleport( goals[ i ].origin, goals[ i ] get_key( "angles" ) );
	}
	
	if ( Target_IsTarget( level.bishop ) )
		Target_Remove( level.bishop );
	if ( Target_IsTarget( level.makarov_number_2 ) )
		Target_Remove( level.makarov_number_2 );
}

rpg_street_enemy_management()
{
	self endon( "death" );
	wait RandomFloatRange( 1.0, 3.0 );
	enemy_goal = getstruct( "rpg_street_enemy_goal", "targetname" );
	self set_goal_radius( RandomFloatRange( 256, 512 ) );
	self SetGoalPos( enemy_goal.origin );
}

rpg_encounter()
{
    // Init / clean up Bad Places
    
    badplaces = get_ent_array_with_prefix( "city_area_ma_badplace_2_", "targetname", 0 );
    foreach ( place in badplaces )
    	badplace_delete( place.targetname );
    deletestructarray_ref( badplaces );
    
    // Spawn Enemies
    
    spawner = GetEnt( "city_area_ma_enemy_4", "targetname" );
    spawner._initial_count = 12;
    spawner._max_count = 12;
    
    delayThread( 0.05, ::rpg_enemies_spawn_rpgs );
    delayThread( 0.05, ::flag_wait_any_set_flags, [ "FLAG_ac130_loop_3" ], [ "FLAG_rpg_building_valid_target" ] );
    delayThread( 5.5, ::rpg_encounter_dialogue );
    
    level.ac130_vehicle delayCall( 2.0, ::Vehicle_SetSpeed, 20, 1, 1 );
    
    thread rpg_building();
    delaythread( 9.0, ::rpg_building_dialogue );
    thread rpg_enemies_monitor();
}

rpg_encounter_dialogue()
{   
	// 5-12 Woah!
	if ( !flag( "FLAG_rpg_building_falling_down" ) )
		vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "tvo" ][ "ac130_tvo_woah" ], true, 10.0 );
    
    // 5-13 Warhammer, we got RPG fire from the building in front of us!  Need you to hit it now!
    if ( !flag( "FLAG_rpg_building_falling_down" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_rpgfire3" ], true, 10.0 );
}

rpg_pip_event()
{
	level.sandman set_ignoreall( true );
	level.sandman set_ignoreme( true );
	level.sandman SetCanDamage( false );
	level.sandman disable_bulletWhizbyReaction();
	level.sandman set_grenadeawareness( 0 );
	level.sandman setFlashbangImmunity( true );
	level.sandman set_neverEnableCQB( true );
	level.sandman disable_arrivals();
	level.sandman disable_exits();
	level.sandman disable_pain();
	level.sandman disable_surprise();
	level.sandman disable_danger_react();
	level.sandman set_ignoresuppression( true );
	
	wait 2.0;
	
	level.ac130player thread play_sound_on_entity( "scn_ac130_pip_onfoot" );
	level.pip.clipdistance 	= 5000;
	level.pip.dofnear		= ( 0, 0, 10 );
	level.pip.doffar		= ( 4000, 10000, 4 );
	//level.pip.lod			= 2048;
	level.pip.blurradius	= 1;
	if ( GetDvarInt( "pip_enabled", 0 ) )
		maps\paris_ac130_pip::ac130_pip_init( level.sandman_fps_pip );
	
	wait 5.5;
	
	if ( GetDvarInt( "pip_enabled", 0 ) )
		maps\paris_ac130_pip::ac130_pip_close();
	level.pip.clipdistance = 0;
	
	level.sandman set_ignoreall( false );
	level.sandman set_ignoreme( false );
	level.sandman SetCanDamage( true );
	level.sandman enable_bulletWhizbyReaction();
	level.sandman set_grenadeawareness( 1 );
	level.sandman setFlashbangImmunity( false );
	level.sandman set_neverEnableCQB( undefined );
	level.sandman enable_arrivals();
	level.sandman enable_exits();
	level.sandman enable_pain();
	level.sandman enable_danger_react( 0 );
	level.sandman set_ignoresuppression( false );
}

rpg_building()
{
	flag_wait( "FLAG_rpg_building_valid_target" );
	
	thread rpg_building_reminder();
	thread rpg_building_mission_failed();

	rpg_building = GetEnt( "rpg_building", "script_noteworthy" );
	Assert( IsDefined( rpg_building ) );
	//rpg_building SetCanDamage( true );
	
	//self.dontAllowExplode
	//self.godmode
	
	
	//rpg_building thread rpg_building_monitor();
	thread rpg_building_trigger_monitor();
	
	flag_wait( "FLAG_rpg_building_damaged" );
	rpg_building SetCanDamage( true );
	rpg_building DoDamage( 1000000, rpg_building.origin );
	thread exploder( "rpg_building_collapse" );
	
	sound_spot = getstruct_delete( "rpg_building_sound", "targetname" );
	level thread play_sound_in_space( "scn_ac130_rpg_building_destruct", sound_spot.origin );
	
	rpg_com_units = GetEntArray( "rpg_building_com_units", "targetname" );
	Assert( IsDefined( rpg_com_units ) );
	
	foreach ( unit in rpg_com_units )
		unit Delete();
		
	flag_set( "FLAG_rpg_building_falling_down" );
	flag_set( "FLAG_rpg_building_destroyed" );
	
	badplace = getstruct_delete( "rpg_badplace", "targetname" );
    Badplace_Cylinder( badplace.targetname, 0, badplace.origin, 1280, 128, "axis" );
    
    thread rpg_building_falling( badplace.origin, 10.0 );
    	
	// Debris
	
	flag_wait( "FLAG_ac130_angel_flare_teleport" );
	
	debris_1 = GetEntArray( "city_area_rpg_building_debris_1", "targetname" );
    foreach ( item in debris_1 )
    	item Show();
    
    debris_2 = GetEntArray( "city_area_rpg_building_debris_2", "targetname" );
    foreach ( item in debris_2 )
    	item Show();
    	
    debris_3 = GetEntArray( "city_area_rpg_building_debris_3", "targetname" );
    foreach ( item in debris_3 )
    	item Delete();
   	Badplace_Delete( badplace.targetname );
}

rpg_building_falling( point, time )
{
	Assert( IsDefined( point ) );
	
	time = gt_op( time, 0.05 );

	interval = 0.5;
	elapsed = 0;
	
	while ( elapsed < time )
	{
		ais = GetAIArray( "axis" );
		ais = array_combine( ais, GetAIArray( "team3" ) );
		
		foreach ( ai in ais )
		{
			if ( dsq_2d_lt( point, ai.origin, 1536 ) )
			{
				ai ai_disable_magic_bullet_shield();
				ai DoDamage( 10000, ai.origin );
			}
		}
		wait interval;
		elapsed += interval;
	}
}

rpg_building_mission_failed()
{
	flag_wait_or_timeout( "FLAG_rpg_building_falling_down", 180 );
	
	if ( !flag( "FLAG_rpg_building_falling_down" ) )
		_mission_failed( "@PARIS_AC130_MISSION_FAIL_DELTA_KILLED" );
}

rpg_building_monitor()
{
	building_alive = true;
	building_hits_with_40 = 0;
	building_hits_with_40_to_kill = 5;
	
	while ( IsDefined( self ) && building_alive && !flag( "FLAG_rpg_building_damaged" ) )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
		
		index = common_scripts\_destructible_types::getInfoIndex( "toy_building_collapse_paris_ac130" );
		if ( index > -1 )
			level.destructible_type[ index ].parts[ 0 ][ 0 ].v[ "health" ] = 1000000;
			
		if ( compare( attacker, level.player ) && compare( type, "MOD_PROJECTILE" ) )
		{
			if ( damage > 990 )
				building_alive = false;
			else 
			if ( damage > 200 )
			{
				building_hits_with_40++;
				
				if ( building_hits_with_40 > building_hits_with_40_to_kill )
					building_alive = false;
			}
		}
	}
	flag_set( "FLAG_rpg_building_damaged" );
}

rpg_building_trigger_monitor()
{
	trigger = GetEnt( "rpg_building_trigger", "targetname" );
	
	building_alive = true;
	building_hits_with_40 = 0;
	building_hits_with_40_to_kill = 5;
	
	while ( building_alive && !flag( "FLAG_rpg_building_damaged" ) )
	{
		trigger waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
			
		if ( compare( attacker, level.player ) && compare( type, "MOD_PROJECTILE" ) )
		{
			if ( damage > 990 )
				building_alive = false;
			else 
			if ( damage > 200 )
			{
				building_hits_with_40++;
				
				if ( building_hits_with_40 > building_hits_with_40_to_kill )
					building_alive = false;
			}
		}
	}
	flag_set( "FLAG_rpg_building_damaged" );
}

rpg_building_dialogue()
{
	// 5-14 Copy that, we got smoke trails from RPG fire to the North West.
	if ( !flag( "FLAG_rpg_building_falling_down" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "fco" ][ "ac130_fco_smoketrails" ], true, 10.0 );
    
    if ( !flag( "FLAG_rpg_building_falling_down" ) )
    {
    	flag_set( "FLAG_rpg_building_marked" );
		thread rpg_vision_hints();
	}
		
    // 5-15 Overlord, we're seeing small-arms, RPG fire from the corner building to the North West.  Request permission to engage.
    if ( !flag( "FLAG_rpg_building_falling_down" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_rpgfire" ], true, 10.0 );
    
    // ** 12-2 Copy.  Standby ...
    if ( !flag( "FLAG_rpg_building_falling_down" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "hqr" ][ "ac130_hqr_copystandby" ], true, 10.0 );
    if ( !flag( "FLAG_rpg_building_falling_down" ) )
    	wait 1.0;
    
    // 5-16 Affirmative, Warhammer.  You are cleared to fire on any buildings with enemy personnel.
    if ( !flag( "FLAG_rpg_building_falling_down" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "hqr" ][ "ac130_hqr_anybuildings" ], true, 10.0 );
    
    // 5-17 Crew, you are cleared to engage the corner building.
    if ( !flag( "FLAG_rpg_building_falling_down" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_cornerbuilding" ], true, 10.0 );
    
    // 5-18 Switch to the one-oh-five.  We're gonna need to hit it with something big.
    if ( !flag( "FLAG_rpg_building_falling_down" ) )
    {
    	//vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "fco" ][ "ac130_fco_oneohfive" ], true, 10.0 );
    	thread rpg_105_hint();
    }
    
    // 5-19 Go ahead and level it.
    //if ( !flag( "FLAG_rpg_building_falling_down" ) )
    //	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "fco" ][ "ac130_fco_levelit" ], true, 10.0 );
    	
    flag_set( "FLAG_rpg_building_callout_dialgoue_finished" );
    flag_wait( "FLAG_rpg_building_falling_down" );
    flag_clear( "FLAG_ac130_context_sensitive_dialog_filler" );
    
    wait 0.05;
    
    // 16-21 That building is done.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "fco" ][ "ac130_fco_buildingsdone" ], true, 10.0 );
    
    // Thanks for the assist! We're gonna cut through the hotel across the street!
    thread vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_cutthrough" ], true, 10.0 );
    
    flag_set( "FLAG_rpg_building_dialgoue_finished" );
}

rpg_building_reminder()
{
	flag_wait( "FLAG_rpg_building_callout_dialgoue_finished" );
	
	sounds = [];

	// 5-13 Warhammer, we got RPG fire from the building in front of us!  Need you to hit it now!
	sounds[ sounds.size ] = level.scr_sound[ "snd" ][ "ac130_snd_rpgfire3" ];
    // 5-19 Go ahead and level it.
    sounds[ sounds.size ] = level.scr_sound[ "fco" ][ "ac130_fco_levelit" ];
    // 5-21 Hit that building.
    sounds[ sounds.size ] = level.scr_sound[ "fco" ][ "ac130_fco_hitbuilding" ];
    // 10-1 We're getting pinned down by RPG fire!  Give us a hand, Warhammer!
    sounds[ sounds.size ] = level.scr_sound[ "snd" ][ "ac130_snd_rpgfire2" ];
    // 10-2 We're getting hammered!!  Take out those RPGs!!!
    //sounds[ sounds.size ] = level.scr_sound[ "snd" ][ "ac130_snd_takeoutrpgs" ];
    // 10-6 Fire on that building.
    sounds[ sounds.size ] = level.scr_sound[ "tvo" ][ "ac130_tvo_fireonbuilding" ];
    // 10-13 Hit that building with heavy rounds.
    //sounds[ sounds.size ] = level.scr_sound[ "tvo" ][ "ac130_tvo_hitbuilding" ];
    // 10-21 Take it out.
    //sounds[ sounds.size ] = level.scr_sound[ "tvo" ][ "ac130_tvo_takeitout" ];
    // 10-22 Hit it now.
    //sounds[ sounds.size ] = level.scr_sound[ "fco" ][ "ac130_fco_hititnow" ];
    // 5-18 Switch to the one-oh-five.  We're gonna need to hit it with something big.
    sounds[ sounds.size ] = level.scr_sound[ "fco" ][ "ac130_fco_oneohfive" ];
    
    array = [];
    
    for ( i = 0; i < sounds.size; i++ )
    	array[ array.size ] = i;
    	
    delay = 2.0;
    index = 0;
    	
	while ( !flag( "FLAG_rpg_building_falling_down" ) )
	{
		if ( array.size == 0 )
		{
			for ( i = 0; i < sounds.size; i++ )
    			array[ array.size ] = i;
    		if ( array.size > 1 )
    			array = array_remove_index( array, index );
    	}
		
		index = RandomInt( array.size );
		
		vehicle_scripts\_ac130::playSoundOverRadio( sounds[ array[ index ] ], false );
    	array = array_remove_index( array, index );
		wait delay;
	}
}

rpg_105_hint()
{
	timeout = 5.0;
	
	if ( !IsSubStr( level.current_weapon, "105" ) )
		level.player display_hint_timeout( "HINT_ac130_change_weapons", timeout );
	
	reminder = 30.0;
		
	while ( !flag( "FLAG_rpg_building_falling_down" ) )
	{
		if ( !IsSubStr( level.current_weapon, "105" ) )
			level.player display_hint_timeout( "HINT_ac130_change_weapons", timeout );
		wait reminder;
	}
}

rpg_vision_hints()
{
	timeout = 5.0;
	
	if ( flag( "FLAG_ac130_thermal_enabled" ) )
		level.player display_hint_timeout( "HINT_ac130_enhanced_vision", timeout );
	
	reminder = 30.0;
		
	while ( !flag( "FLAG_rpg_building_falling_down" ) )
	{
		if ( flag( "FLAG_ac130_thermal_enabled" ) )
			level.player display_hint_timeout( "HINT_ac130_enhanced_vision", timeout );
		wait reminder;
	}
}

rpg_enemies_monitor()
{
    clear_encounter_primary_enemies();
    clear_encounter_enemies();
}

rpg_enemies_spawn_rpgs()
{
    spawners = get_ent_array_with_prefix( "city_area_ma_4_enemy_", "targetname", 2 );
    
    // [ sequence ][ type ][ callback ]
    ai_callbacks = [];

    ai_callbacks[ "after_spawn" ] = [];
    
    ai_callbacks[ "after_spawn" ][ "pass_value" ] = [];
    ai_callbacks[ "after_spawn" ][ "pass_value" ][ 0 ] = ::rpg_enemies_rpg_hud_targets;
    
    ai_callbacks[ "before_spawner_cleanup" ] = [];
    
    ai_callbacks[ "before_spawner_cleanup" ][ "caller" ] = [];
    ai_callbacks[ "before_spawner_cleanup" ][ "caller" ][ 0 ] = ::proc_delete;
    
    _flag = "FLAG_rpg_building_falling_down";
    
    foreach ( i, spawner in spawners )
    {
    	spawner add_spawn_function( ::ai_enemy_rpg_init, spawner.targetname, "targetname" );
    	spawner delayThread( i*0.5 + 0.05, ::burst_infinite_spawn_ai, 1, 0.05, 1, 6.0, _flag, ai_callbacks );
    }
}

rpg_enemies_rpg_hud_targets( rpg )
{
	flag_wait( "FLAG_rpg_building_marked" );
	vehicle_scripts\_ac130::hud_add_targets( [ rpg ] );
}

rpg_clean_up()
{
}

rpg_catch_up_clean_up()
{
	rpg_building = GetEnt( "rpg_building", "script_noteworthy" );
	rpg_building SetCanDamage( true );
	rpg_building DoDamage( 10000, rpg_building.origin );

	debris_1 = GetEntArray( "city_area_rpg_building_debris_1", "targetname" );
    foreach ( item in debris_1 )
    	item Show();
    
    debris_2 = GetEntArray( "city_area_rpg_building_debris_2", "targetname" );
    foreach ( item in debris_2 )
    	item Show();   
    	
	ents = [];
	ents = add_to_array( ents, GetEnt( "rpg_building_look_at", "targetname" ) );
	ents = array_combine( ents, GetEntArray( "rpg_building_com_units", "targetname" ) );
	ents = array_combine( ents, GetEntArray( "city_area_rpg_building_debris_3", "targetname" ) );
	
	foreach ( ent in ents )
	{
		if ( IsDefined( ent ) )
		{
			ent notify( "death" );
			ent Delete();
		}
	}	
	rpg_delete_structs();
}

rpg_delete_structs()
{
	structs =[];
	structs = array_combine( structs, get_ent_array_with_prefix( "rpg_friendly_point_", "targetname", 0 ) );
	structs = array_combine( structs, getstructarray( "building_friendly_point", "targetname" ) );
	structs = add_to_array( structs, getstruct( "courtyard_building_entrance", "targetname" ) );
	structs = array_combine( structs, get_ent_array_with_prefix( "city_area_ma_4_enemy_", "targetname", 2 ) );
	structs = array_combine( structs, getstructarray( "rpg_ma_4_enemy_rpg_target_1", "targetname" ) );
	structs = array_combine( structs, getstructarray( "rpg_ma_4_enemy_rpg_target_2", "targetname" ) );
	structs = add_to_array( structs, getstruct( "city_area_ma_4_enemy_2_start", "targetname" ) );
	structs = add_to_array( structs, getstruct( "city_area_ma_4_enemy_3_start", "targetname" ) );
	structs = add_to_array( structs, getstruct( "city_area_ma_4_enemy_4_start", "targetname" ) );
	structs = add_to_array( structs, getstruct( "city_area_ma_4_enemy_5_start", "targetname" ) );
	structs = add_to_array( structs, getstruct( "rpg_badplace", "targetname" ) );

	thread deletestructarray_ref( structs, 0.2 );
}

catch_up_courtyard()
{
	flag_set( "FLAG_ac130_flare_event_finished" );
	flag_set( "FLAG_rpg_building_falling_down" );
	flag_set( "FLAG_rpg_building_destroyed" );
    
    level notify( "LISTEN_end_rpg_angel_flare_moment" );
    
    Objective_Add( obj( "OBJ_RPG_Destroy_Building" ), "current", &"PARIS_AC130_OBJ_RPG_DESTROY_RPG_BUILDING" );
    Objective_State( obj( "OBJ_RPG_Destroy_Building" ), "done" );
    
    // Handle Spawners
    
    spawners = [ GetEnt( "city_area_ma_enemy_1", "targetname" ),
    			 GetEnt( "city_area_ma_enemy_2", "targetname" ),
    			 GetEnt( "city_area_ma_enemy_3", "targetname" ),
    			 GetEnt( "city_area_ma_enemy_4", "targetname" ) ];
	
	foreach ( spawner in spawners )
	{
    	spawner._initial_count = 0;
    	spawner._initial_interval = 0.05;
    	spawner._max_count = 0;
    	spawner._interval = 0.05;
    }
    
    wait 2.0;
    
   	ais = GetAIArray( "axis" );
   	ais = array_combine( ais, GetAIArray( "team3" ) );
		
	foreach ( ai in ais )
	{
		ai notify( "death" );
		ai Delete();
	}
   
   	// Get Delta into position
   	
   	goals = getstructarray_delete( "building_friendly_point", "targetname" );
   	goals = array_index_by_script_index( goals );
   	level.frost InvisibleNotSolid();
   	level.frost Hide();
   	if ( Target_IsTarget( level.frost ) )
   		Target_Remove( level.frost );
	wait 0.05;
	group = [ level.sandman, level.hitman, level.gator, level.bishop, level.makarov_number_2 ];
	foreach ( i, guy in group )
	{
		guy SetGoalPos( goals[ i ].origin );
		guy ForceTeleport( goals[ i ].origin, goals[ i ] get_key( "angles" ) );
	}
	wait 0.05;
		
    transition_node = GetVehicleNode( "city_area_loop_4_out", "script_noteworthy" );
	Assert( IsDefined( transition_node ) );
	level.ac130_vehicle switch_vehicle_path( transition_node );
	flag_set( "FLAG_ac130_loop_4" );
}

start_courtyard()
{
	thread vehicle_scripts\_ac130::autosave_ac130(); // **TODO: this probably is not needed
    
    flag_clear( "FLAG_building_trigger_mission_failed_on" );
	
	level.bishop clear_parent_ai();
	level.makarov_number_2 clear_child_ai();
		
	flag_clear( "FLAG_delta_ac130_mission_fail" );
	flag_clear( "FLAG_ac130_context_sensitive_dialog_filler" );
	flag_clear( "FLAG_ac130_context_sensitive_dialog_kill" );
	flag_clear( "FLAG_ac130_context_sensitive_dialog_guy_pain" );
		
    thread hvt_escape();
    
   	flag_wait( "player_shot_yellow_building" );
   	courtyard_clear_fx();
   	courtyard_minimap();
   	flag_clear( "FLAG_ambient_ac130_effects" );
   	flag_wait( "FLAG_hvt_escape_hvt_captured" );
   	courtyard_slamzoom_out();
}

courtyard_clear_fx()
{
	fx_ids = [ [ "fire_falling_runner_point_nocull", 			( 331.269, 38772.7, 1361.35 ) ] ];
	delete_createFXent_fx( fx_ids );
}

courtyard_minimap()
{	
	// ( x, y ) -> ( 736, 42464 )
	
	corner_1 = Spawn( "script_origin", ( 736, 42464, 0 ) );
	corner_1.targetname = "compass_map_paris_ac130_courtyard";
	corner_2 = Spawn( "script_origin", ( 736 + 5152, 42464 - 4768, 0 ) );
	corner_2.targetname = "compass_map_paris_ac130_courtyard";
	maps\_compass::setupMiniMap( "compass_map_paris_ac130_courtyard", "compass_map_paris_ac130_courtyard" );
	
	SetSavedDvar( "ui_hideMap", "0" );
}

courtyard_cleanup_outside()
{
	// Handle outside spawners
	
	spawn_points = getstructarray( "city_area_pfr_enemy_1", "targetname" );
	spawn_points = array_index_by_script_index( spawn_points );
	spawn_points[ 1 ].script_noteworthy = "city_area_pfr_enemy_cover_1";
	spawn_points[ 2 ].script_noteworthy = "city_area_pfr_enemy_cover_1";
	spawn_points[ 3 ].script_noteworthy = "city_area_pfr_enemy_cover_0";
	spawn_points[ 4 ].script_noteworthy = "city_area_pfr_enemy_cover_0";
	spawn_points[ 5 ].script_noteworthy = "city_area_pfr_enemy_cover_0";
	
	spawner = GetEnt( "city_area_pfr_enemy_1", "targetname" );
    spawner._initial_count = 0;
    spawner._max_count = 0;
    
   	duration = 4.0;
   	elapsed = 0;
   	
   	while ( elapsed < duration )
   	{
		ais = GetAIArray( "axis" );
		ais = array_combine( ais, GetAIArray( "team3" ) );
		
		foreach ( ai in ais )
		{
			ai notify( "death" );
			ai Delete();
		}
		elapsed += 0.05;
		wait 0.05;
    }
}

courtyard_enable_fps_player()
{
	level.player TakeAllWeapons();
	level.player SetViewmodel( "viewmodel_base_viewhands" );
	level.player GiveWeapon( "m4m203_reflex" );
	level.player GiveMaxAmmo( "m4m203_reflex" );
	level.player GiveWeapon( "usp_no_knife" );
	level.player Givemaxammo( "usp_no_knife" );
	
	level.player SetOffhandPrimaryClass( "frag" );
	level.player GiveWeapon( "fraggrenade" );
	level.player SetOffhandSecondaryClass( "flash" );
	level.player GiveWeapon ( "flash_grenade" );
	
	level.player SwitchtoWeapon( "m4m203_reflex" );
	
	level.player AllowCrouch( true );
	level.player AllowProne( true );
	
	SetSavedDvar( "compass", 1 );
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "hud_showStance", 1 );
	SetSavedDvar( "sm_sunsamplesizenear", 0.25 );
}

courtyard_slamzoom_out()
{
	// Reposition ac130
	
	level.ac130_vehicle Vehicle_SetSpeedImmediate( 0, 5, 5 );
	slamout_node = GetVehicleNode( "chase_start_friendly_vehicles", "script_noteworthy" );
	Assert( IsDefined( slamout_node ) );
	level.ac130_vehicle Vehicle_Teleport( slamout_node.origin, slamout_node.angles );
	
	thread chase_pfr_enemies();
	
	level.player FreezeControls( true );
	
	level.ac130_vehicle vehicle_scripts\_ac130::_ac130_init_player( level.player );
	wait 0.05;
	level.ac130_vehicle Vehicle_SetSpeedImmediate( 30, 5, 5 );
	level.ac130_vehicle switch_vehicle_path( slamout_node );
	
	focus = GetEnt( "chase_player_focus", "targetname" );
	Assert( IsDefined( focus ) );

	level.ac130_player_view_controller SnapToTargetEntity( focus );
	wait 0.2;
	
	// Shadows
    SetSavedDvar( "sm_sunenable", 1.0 );
    SetSavedDvar( "sm_sunsamplesizenear", 1.0 );
    SetSavedDvar( "sm_sunShadowScale", 0.5 );
	
	flag_set( "FLAG_courtyard_slamzoom_out_finished" );
}

catch_up_chase()
{
	flag_set( "FLAG_rpg_ac130_angel_flare_start" );
	flag_set( "FLAG_courtyard_slamzoom_out_finished" );
	flag_set( "FLAG_hvt_escape_hvt_captured" );
	flag_set( "FLAG_interact_button_pressed" );
	
	// Handle Spawners
	
	spawners = [ GetEnt( "city_area_ma_enemy_1", "targetname" ),
				 GetEnt( "city_area_ma_enemy_2", "targetname" ),
				 GetEnt( "city_area_ma_enemy_3", "targetname" ),
				 GetEnt( "city_area_pfr_enemy_1", "targetname" ) ];
	
	foreach ( spawner in spawners )
	{
		spawner._initial_count = 0;
	    spawner._initial_interval = 0.05;
	    spawner._max_count = 0;
	    spawner._interval = 0.05;
	}
	
	wait 5.0;
	
	ais = GetAIArray( "axis" );
	ais  = array_combine( ais, GetAIArray( "team3" ) );
	
	foreach ( ai in ais )
	{
		ai notify( "death" );
		ai Delete();
	}
		
	thread chase_pfr_enemies();
	
	node = GetVehicleNode( "chase_start_friendly_vehicles", "script_noteworthy" );
	Assert( IsDefined( node ) );
	level.ac130_vehicle switch_vehicle_path( node );
	
	focus = GetEnt( "chase_player_focus", "targetname" );
	Assert( IsDefined( focus ) );
	
	level.ac130_player_view_controller SnapToTargetEntity( focus );
	wait 0.2;
}

start_chase()
{
	thread vehicle_scripts\_ac130::autosave_ac130();
	
	Objective_Add( obj( "OBJ_CHASE_Escort" ), "current", &"PARIS_AC130_OBJ_CHASE_ESCORT_KILO_1_1" );
			
    flag_wait( "FLAG_courtyard_slamzoom_out_finished" );
    flag_set( "FLAG_ambient_ac130_effects" );
    flag_set( "FLAG_building_trigger_mission_failed_on" );
    flag_set( "FLAG_delta_ac130_mission_fail" );
    flag_set( "FLAG_ac130_context_sensitive_dialog_kill" );
	flag_set( "FLAG_ac130_context_sensitive_dialog_guy_pain" );
    
    maps\_compass::setupMiniMap( "compass_map_paris_ac130", "compass_map_paris_ac130" );
    
    SetSavedDvar( "ui_hideMap", "1" );
    
    level.ac130_friendly_fire_dialogue_priority = false;
    
    // Align player's view to Building Exit
	
	building_exit = getstruct( "courtyard_building_exit", "targetname" );
	vehicle_scripts\_ac130::ac130_set_view_arc( 0, 0, 0, 0, 0, 0, 0 );
	wait 0.05;
	level.player FreezeControls( false );
	 
	delta_spawn_at_fast_point( "chase" );
	thread chase_friendlies_add_hud_targets( building_exit );
	
	thread chase_hints();
	thread chase_rb_dialogue();
    delaythread( 0.05, ::chase_rb_exit_building );
    delayThread( 0.05, ::chase_rb_exit_building_pip_event );
    flag_wait( "FLAG_chase_rb_delta_exiting_building" );
    thread chase_pfr_delta_move_down();
	thread chase_pfr_mission_failed();
	
	vehicle_scripts\_ac130::set_badplace_max( 5 );
	
	chase_fx();
	thread chase_friendlies_init();
	thread chase_enemies_init();

	flag_wait( "FLAG_chase_started" );
	
	level.ac130_friendly_fire_dialogue_priority = true;
	
	thread chase_hints();
	thread chase_dialogue();
	
	_flag = "FLAG_chase_end_chase";
	level.ac130_vehicle thread set_level_flag_on_vehicle_node_notify( "chase_end_transition_out", "script_noteworthy", _flag );
	flag_wait( "FLAG_chase_end_chase" );

	thread chase_clean_up();
}

chase_hints()
{
	timeout = 5.0;
	
	if ( flag( "FLAG_ac130_thermal_enabled" ) )
		level.player thread display_hint_timeout( "HINT_ac130_enhanced_vision", timeout );
	
	wait 8.0;
	level.player thread display_hint_timeout( "HINT_ac130_using_zoom", timeout );
	wait 13.0;
	
	if ( !IsSubStr( level.current_weapon, "25" ) )
		level.player thread display_hint_timeout( "HINT_ac130_use_25", timeout );
}

chase_dialogue()
{
	// ** 12-9 Personnel cam online.
    //vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "tvo" ][ "ac130_tvo_personnelcam" ], true, 10.0 );
    
    // "Warhammer, this is Uniform Six Two!  We're moving out!"
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "hmv" ][ "ac130_hmv_movingout" ], true, 10.0 );
    
    // "Copy that, Six Two"
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_copythat24" ], true, 10.0 );                                                                                                         
    
	// ** 8-11 Damn that was close!
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "hit" ][ "ac130_hit_damnclose" ], true, 10.0 );
    
    // 9-1 Hitman, get on that .50!
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_getonthat50" ], true, 10.0 );
    
    // ** 12-32 Get on that 50! <-- needs to be sandman
    //vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "brvl" ][ "ac130_brvl_getonthatfifty" ], true, 10.0 );	
    
    // 9-2 On it!
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "hit" ][ "ac130_hit_onit" ], true, 10.0 );
    
      // ** 12-11 Kilo 1-1, you have two enemy vehicles on your six, over.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_twovehicles" ], true, 10.0 );
    
    // 9-10 This should be interesting ...
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "tvo" ][ "ac130_tvo_interesting" ], true, 10.0 );
    
    // 9-3 Get these guys off our tail!
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "hmv" ][ "ac130_hmv_offourtail" ], true, 10.0 );
    
    // ** 12-16 Roger.  Go ahead and take em out.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "fco" ][ "ac130_fco_takeemout2" ], true, 10.0 );		
    
    // 9-8 Crew, you are cleared to engage the enemy vehicles, but keep fire as far behind the convoy as possible.
    //vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_behindconvoy" ], true, 10.0 );
    
    // -------------- 1.5
    
    // 9-11 Goin' left!
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_goinleft" ], true, 10.0 );	
    
    wait  1.0;
    
    // ** 12-29 Keep your foot on the gas!
    //vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_footongas" ], true, 10.0 );	
    
    // We got enemy armor behind us!  Take em out!
    if ( !flag( "FLAG_chase_vehicles_1_2_killed" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_armorbehind" ], true, 10.0 );
    else
    	wait 2.0;
    
    // 9-13 Makin' a hard left!
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_makinhardleft" ], true, 10.0 );	
    
   // ** 12-12 Enemy armor up the road, there.  Clear to engage all those.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_armoruproad" ], true, 10.0 );	
    
    // ** 12-13 Copy that.  Get on those tanks.
    //vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "fco" ][ "ac130_fco_getontanks" ], true, 10.0 );		
    
    wait 3.5;
    
    // -------------- 4.5
    
    // 9-11 Goin' left!
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_goinleft" ], true, 10.0 );
    
    // They're right on us!  Take care of em!
    if ( !flag( "FLAG_chase_vehicles_7_8_killed" ) )
    	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_rightonus" ], true, 10.0 );
    else
    	wait 2.0;
    
   	vehicle_scripts\_ac130::ac130_set_view_arc( 2, 1.25, 1.25, 65, 65, 30, 55 );
    
    wait 1.0;
    
    // -------------- 4.0
    
    // 9-13 Makin' a hard left!
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_makinhardleft" ], true, 10.0 );		
    
    wait 3.5;
    
    // -------------- 5.0
    
    // 9-12 Go right!  Go right!
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_gorightgoright" ], true, 10.0 );
    
    // ** 12-15 Enemy birds inbound.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_birdsinbound" ], true, 10.0 );	
    
    wait 1.5;
    
    vehicle_scripts\_ac130::ac130_set_view_arc( 2, 1.25, 1.25, 70, 70, 30, 55 );
    	
    // 9-15 Multiple enemy birds are engaging the convoy.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "tvo" ][ "ac130_tvo_engagingconvoy" ], true, 10.0 );	
    
    wait 1.0;
    
    // 9-16 Wait for a clear shot.  Don't want to hit our guys.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_clearshot" ], true, 10.0 );	
    
    // -------------- 9.0
    
    vehicle_scripts\_ac130::ac130_set_view_arc( 2, 1.25, 1.25, 65, 65, 30, 55 );
    
    // ** 12-30 Floor it!
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_floorit" ], true, 10.0 );
    
    flag_set( "FLAG_chase_dialogue_finished" );
}

chase_friendlies_add_hud_targets( building_exit )
{
	Assert( IsDefined( building_exit ) );
	
	group = array_combine( level.delta, [ level.makarov_number_2 ] );
	
	foreach ( guy in group )
		guy thread thread_func_ent1_in_2d_range_of_ent2_timeout( guy, building_exit, 96.0, ::chase_friendlies_add_hud_target, 15 );
}

chase_friendlies_add_hud_target()
{
	vehicle_scripts\_ac130::hud_add_targets( [ self ] );
}

chase_pfr_enemies()
{
	thread chase_pfr_enemy_spawn();
	thread chase_pfr_t72s();
	thread chase_pfr_mi17s();
}

chase_pfr_mission_failed()
{
	clear_encounter_primary_enemies();
	enemies_to_kill = 1;
	
	switch( level.gameSkill )
	{
		case 0:
			enemies_to_kill = 1;
			break;
		case 2:
			enemies_to_kill = 3;
			break;
		case 3:
			enemies_to_kill = 6;
			break;
	}
	thread monitor_encounter_primary_enemies_count( enemies_to_kill, "FLAG_chase_pfr_encounter_complete" );
	flag_wait( "FLAG_chase_pfr_encounter_check" );
	if ( !flag( "FLAG_chase_pfr_encounter_complete" ) )
		_mission_failed( "@PARIS_AC130_MISSION_FAIL_HUMVEE_SUPPORT" );
}

chase_pfr_enemy_spawn()
{
	// Clean up any ai left over in hvt escape
	
	ais = GetAIArray( "axis" );
	ais  = array_combine( ais, GetAIArray( "team3" ) );
	
	foreach( ai in ais )
		ai Delete();
		
	goals = [];
	goals = array_combine( goals, GetNodeArray( "city_area_pfr_enemy_cover_0", "targetname" ) );
	goals = array_combine( goals, GetNodeArray( "city_area_pfr_enemy_cover_1", "targetname" ) );
	goals = array_randomize( goals );
	
	spots = get_connected_ents( "chase_pfr_enemy_spot" );
	deletestructarray_ref( spots );
	
	_spawner = GetEnt( "city_area_pfr_enemy_1", "targetname" );
	Assert( IsDefined( _spawner ) );
	
	spawners = [ GetEnt( _spawner.targetname + "_AR", "targetname" ),
   				 GetEnt( _spawner.targetname + "_SMG", "targetname" ),
   				 GetEnt( _spawner.targetname + "_RPG", "targetname" ) ];
	
	count = lt_op( spots.size, goals.size );
	i = 0;
	
	while ( i < count )
	{
		spawner = ter_op( random_chance( 0.3 ), spawners[ 2 ], spawners[ RandomInt( 2 ) ] );
		spawner.count = 1;
		spawner.origin = spots[ i ].origin;
		spawner.angles = spots[ i ] get_key( "angles" );
		ai = spawner StalingradSpawn();

		if ( !spawn_failed( ai ) )
		{
			thread vehicle_scripts\_ac130::hud_add_targets( [ ai ] );
			_spawner._ais = add_to_array( _spawner._ais, ai );
			add_encounter_enemy( ai );
			add_encounter_primary_enemy( ai );
			ai set_goal_radius( 192.0 );
			ai SetGoalPos( goals[ i ].origin );
			ai set_baseaccuracy( 0.01 );
			i++;
		}
		wait 0.05;
	}
	
	_spawner._initial_count = 18;
    _spawner._max_count = 18;
    _spawner._ai_callbacks[ "after_spawn" ][ "pass_value" ][ 1 ] = ::add_encounter_primary_enemy;
	_spawner._ai_callbacks[ "before_spawner_cleanup" ][ "pass_value" ][ 0 ] = ::add_encounter_primary_enemies;
}

chase_pfr_t72s()
{
	t72_spawner = GetEnt( "chase_pfr_t72", "targetname" );
	Assert( IsDefined( t72_spawner ) );
	t72_spawner add_spawn_function( ::enemy_t72_init, "chase_pfr_t72", "targetname", 4 );
	t72_spawner add_spawn_function( ::monitor_vehicle_mission_fail_points );
	t72_spawner add_spawn_function( ::vehicle_enemy_kill_dialogue_monitor, "t72" );
	t72_spots = getstructarray_delete( "chase_pfr_t72", "targetname" );
	t72_spots = array_index_by_script_index( t72_spots );
	t72s = [];
	_t72s = [];
	
	foreach ( i, spot in t72_spots )
	{
		t72_spawner.count = 1;
		t72_spawner.origin = spot.origin;
		t72_spawner.angles = spot get_key( "angles" );
		t72_spawner.target = spot.target;
		t72s[ i ] = t72_spawner spawn_vehicle();
		wait 0.05;
		vehicle_scripts\_ac130::hud_add_targets( [ t72s[ i ] ] );
		add_encounter_primary_enemy( t72s[ i ] );
		wait 0.05;
	}
	
	foreach ( t72 in t72s )
		t72 thread gopath();

	targets_1 = get_connected_ents( "chase_pfr_tank_target_1" );
	targets_2 = get_connected_ents( "chase_pfr_tank_target_2" );
	targets_3 = get_connected_ents( "chase_pfr_tank_target_3" );
	
	t72s[ 1 ] delayThread( 6.0, ::enemy_t72_randomly_shoot_canon_fake, targets_1[ RandomInt( targets_1.size ) ] );
	t72s[ 3 ] delayThread( 8.0, ::enemy_t72_randomly_shoot_canon_fake, targets_1[ RandomInt( targets_1.size ) ] );
	t72s[ 1 ] delayThread( 10.0, ::enemy_t72_randomly_shoot_canon_fake, targets_1[ RandomInt( targets_1.size ) ] );
	t72s[ 3 ] delayThread( 10.25, ::enemy_t72_randomly_shoot_canon_fake, targets_1[ RandomInt( targets_1.size ) ] );
	t72s[ 1 ] delayThread( 14.0, ::enemy_t72_randomly_shoot_canon_fake, targets_1[ RandomInt( targets_1.size ) ] );
	t72s[ 3 ] delayThread( 15.0, ::enemy_t72_randomly_shoot_canon_fake, targets_1[ RandomInt( targets_1.size ) ] );
	
	t72s[ 1 ] delayThread( 20.0, ::enemy_t72_randomly_shoot_canon_fake, targets_2[ RandomInt( targets_2.size ) ] );
	t72s[ 3 ] delayThread( 21.0, ::enemy_t72_randomly_shoot_canon_fake, targets_2[ RandomInt( targets_2.size ) ] );
	t72s[ 2 ] delayThread( 22.0, ::enemy_t72_randomly_shoot_canon_fake, targets_2[ RandomInt( targets_2.size ) ] );
	t72s[ 4 ] delayThread( 24.5, ::enemy_t72_randomly_shoot_canon_fake, targets_2[ RandomInt( targets_2.size ) ] );
	t72s[ 2 ] delayThread( 26.0, ::enemy_t72_randomly_shoot_canon_fake, targets_2[ RandomInt( targets_2.size ) ] );
	t72s[ 4 ] delayThread( 27.5, ::enemy_t72_randomly_shoot_canon_fake, targets_2[ RandomInt( targets_2.size ) ] );
	
	t72s[ 1 ] delayThread( 30.0, ::enemy_t72_randomly_shoot_canon_fake, targets_1[ RandomInt( targets_1.size ) ] );
	t72s[ 3 ] delayThread( 31.0, ::enemy_t72_randomly_shoot_canon_fake, targets_1[ RandomInt( targets_1.size ) ] );
	t72s[ 2 ] delayThread( 34.0, ::enemy_t72_randomly_shoot_canon_fake, targets_1[ RandomInt( targets_1.size ) ] );
	t72s[ 4 ] delayThread( 35.5, ::enemy_t72_randomly_shoot_canon_fake, targets_1[ RandomInt( targets_1.size ) ] );
	
	t72s[ 1 ] delayThread( 36.0, ::enemy_t72_randomly_shoot_canon_fake, targets_3[ RandomInt( targets_3.size ) ] );
	t72s[ 3 ] delayThread( 37.0, ::enemy_t72_randomly_shoot_canon_fake, targets_3[ RandomInt( targets_3.size ) ] );
	t72s[ 2 ] delayThread( 37.5, ::enemy_t72_randomly_shoot_canon_fake, targets_3[ RandomInt( targets_3.size ) ] );
	t72s[ 4 ] delayThread( 38.5, ::enemy_t72_randomly_shoot_canon_fake, targets_3[ RandomInt( targets_3.size ) ] );
	
	t72s[ 1 ] delayThread( 40.0, ::enemy_t72_randomly_shoot_canon_fake, targets_3[ RandomInt( targets_3.size ) ] );
	t72s[ 3 ] delayThread( 41.0, ::enemy_t72_randomly_shoot_canon_fake, targets_3[ RandomInt( targets_3.size ) ] );
	t72s[ 2 ] delayThread( 41.5, ::enemy_t72_randomly_shoot_canon_fake, targets_3[ RandomInt( targets_3.size ) ] );
	t72s[ 4 ] delayThread( 42.5, ::enemy_t72_randomly_shoot_canon_fake, targets_3[ RandomInt( targets_3.size ) ] );
	
	t72s[ 1 ] delayThread( 44.0, ::enemy_t72_randomly_shoot_canon_fake, targets_3[ RandomInt( targets_3.size ) ] );
	t72s[ 3 ] delayThread( 45.0, ::enemy_t72_randomly_shoot_canon_fake, targets_3[ RandomInt( targets_3.size ) ] );
	t72s[ 2 ] delayThread( 45.5, ::enemy_t72_randomly_shoot_canon_fake, targets_3[ RandomInt( targets_3.size ) ] );
	t72s[ 4 ] delayThread( 46.5, ::enemy_t72_randomly_shoot_canon_fake, targets_3[ RandomInt( targets_3.size ) ] );
	
	// Clean up
	
	flag_wait( "FLAG_chase_started" );
	
	foreach ( t72 in t72s )
		if ( IsDefined( t72 ) && Target_IsTarget( t72 ) )
			Target_Remove( t72 );

	wait 20.0;
	
	foreach ( t72 in t72s )
	{
		if ( IsDefined( t72 ) )
		{
			t72 godoff();
			t72 DoDamage( 10000, t72.origin );
		}
	}
			
	flag_wait( "FLAG_start_bridge" );
	
	t72s = array_removeundefined( t72s );
	
	foreach ( t72 in t72s )
	{
		if ( IsDefined( t72 ) )
		{
			t72 notify( "death" );
			t72 Delete();
		}
	}
	t72_spawner Delete();
}

chase_pfr_mi17s()
{
	mi17_spawner = GetEnt( "chase_pfr_mi17", "targetname" );
	Assert( IsDefined( mi17_spawner ) );
	mi17_spawner add_spawn_function( ::enemy_mi17_init, "chase_pfr_mi17", "script_noteworthy" );
	mi17_spawner add_spawn_function( ::monitor_vehicle_mission_fail_points );
	mi17_spawner add_spawn_function( ::vehicle_enemy_kill_dialogue_monitor, "mi17" );
	spots = getstructarray_delete( "chase_pfr_mi17", "targetname" );
	spots = array_index_by_script_index( spots );
	
	pilot_spawner = GetEnt( "chase_pfr_mi17_pilot", "targetname" );
	Assert( IsDefined( pilot_spawner ) );
	
	passenger_spawner = GetEnt( "chase_pfr_mi17_enemy", "targetname" );
	Assert( IsDefined( passenger_spawner ) );

	mi17s 	= [];
	delays 	= [ -1, 0, 18.0, 0, 0 ];
	
	foreach ( i, spot in spots )
	{
		mi17_spawner.count = 1;
		mi17_spawner.angles = spot get_key( "angles" );
		mi17_spawner.origin = spot.origin;
		mi17_spawner.target = spot.target;
	
		mi17 = mi17_spawner spawn_vehicle();
		mi17s[ mi17s.size ] = mi17;
		
		wait 0.05;
		delaythread( delays[ i ], vehicle_scripts\_ac130::hud_add_targets, [ mi17 ] );
	    mi17 thread enemy_mi17_load_pilot_alt( pilot_spawner );
	    mi17 thread enemy_mi17_quick_load_passengers_alt( passenger_spawner, 1 );
	    mi17 enemy_mi17_set_passenger_callbacks_on_unload( [ ::chase_pfr_mi17_enemy_management ] );
	    mi17 thread enemy_mi17_drop_off();
	    add_encounter_primary_enemy( mi17 );
		wait ( ter_op( i < 4, 0.05, 10 ) );
	}
	
	flag_wait( "FLAG_chase_started" );
	
	foreach ( mi17 in mi17s )
		if ( IsDefined( mi17 ) && Target_IsTarget( mi17 ) )
			Target_Remove( mi17 );
					
    // Clean up
    
    flag_wait( "FLAG_chase_end_chase" );
	
	wait 20;
		
    pilot_spawner Delete();
    passenger_spawner Delete();
	mi17_spawner Delete();
	
	override_array_delete( mi17s, [ "death", "newpath", "crash_done" ] );
	
	foreach ( spot in spots )
		deletestructarray_ref( get_connected_ents( spot.target ) );
}

chase_pfr_mi17_enemy_management()
{
	self endon( "death" );
	
	delayThread( 3.0, vehicle_scripts\_ac130::hud_add_targets, [ self ] );
	if ( !flag( "FLAG_chase_started" ) )
	{
		add_encounter_enemy( self );
		add_encounter_primary_enemy( self );
	}
	flag_wait( "FLAG_chase_started" );
	if ( Target_IsTarget( self ) )
		Target_Remove( self );
	wait 5.0;
	self DoDamage( 10000, self.origin );
}

chase_rb_dialogue()
{   
	flag_clear( "FLAG_ac130_context_sensitive_dialog_filler" );
	
	thread chase_rb_focus_player_view();
	
	// “Metal Zero One, this is Uniform Six Two.  En route to your location.”
	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "hmv" ][ "ac130_hmv_enroute" ], true, 10.0 );
    
    // “Copy that!  We're almost at the intersection.  One minute out!”
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_almost" ], true, 10.0 );
    
    // 8-11 Enemies crossing in the open.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "tvo" ][ "ac130_tvo_crossingopen" ], true, 10.0 );
    
    // 8-3 Go ahead and take em out before Delta gets there.
  	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_beforedelta" ], true, 10.0 );
  	
    // ** 12-9 Personnel cam online.
    //vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "tvo" ][ "ac130_tvo_personnelcam" ], true, 10.0 );
    
    // ** 12-10 My guys, let's go!
    //vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_myguysgo" ], true, 10.0 );
    
  	// 8-16 Do not fire on the humvees, those are our guys.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "fco" ][ "ac130_fco_donotfire" ], true, 10.0 );
    
  	// 8-15 Crew, we have friendly vehicles on the ground.  West of the fountain.  That's WEST of the fountain.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_friendlyvehicles" ], true, 10.0 );

    // 8-13 We're right around the corner, Metal Zero One!
    //vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "hmv" ][ "ac130_hmv_aroundcorner" ], true, 10.0 );
    
    // ** 8-56 Lot's of guys movin in.  We've stirred up a hornet's nest.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "fco" ][ "ac130_fco_lotsofguys" ], true, 10.0 );
  
  	// 8-2 Heh.  I think we got their attention.
  	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "tvo" ][ "ac130_tvo_attention" ], true, 10.0 );
    
    // 8-17 The LZ is two klicks North of here.  Let's get a move on!
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "hmv" ][ "ac130_hmv_getamoveon" ], true, 10.0 );
    
    // 8-18 Get Volk in the Humvee, let's go!
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_volkinhumvee" ], true, 10.0 );
    
    // ** 9-5 Speed up the timeline if we can.
    //vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "tvo" ][ "ac130_tvo_timeline" ], true, 10.0 );
    
    wait 1.5;
    
    // ** 9-6 Going as fast as we can, crew.
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_fastaswecan" ], true, 10.0 );
    
    flag_wait( "FLAG_chase_main_vehicle_arrived" );
    flag_wait( "FLAG_chase_second_vehicle_arrived" );
    flag_wait( "FLAG_chase_delta_ready_to_enter_vehicles" );
   
   	level.ac130_vehicle Vehicle_SetSpeed( 80, 5, 5 );

   	wait 2.0;
   	
   	flag_set( "FLAG_chase_pfr_encounter_check" );
   	
   	// 8-21 We secure?!
   	vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "hmv" ][ "ac130_hmv_wesecure" ], true, 10.0 );
    
    // 8-22 Secure!  Let's roll!
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "snd" ][ "ac130_snd_letsroll" ], true, 10.0 );
    
    thread vehicle_scripts\_ac130::autosave_ac130();
}

chase_rb_focus_player_view()
{
	focus = GetEnt( "chase_player_focus", "targetname" );
	Assert( IsDefined( focus ) );
	building_exit = getstruct_delete( "courtyard_building_exit", "targetname" );
	fdr_center = getstruct_delete( "fdr_center", "targetname" );
	
	focus MoveTo( building_exit.origin, 2.0, 1.0, 1.0 );
	wait 2.0;
	focus MoveTo( fdr_center.origin, 5.0, 2.5, 2.5 );
	vehicle_scripts\_ac130::ac130_set_view_arc( 2, 1.25, 1.25, 90, 90, 30, 65 );
	
	flag_wait( "FLAG_chase_pfr_encounter_check" );
	
	focus MoveTo( level.chase_main_vehicle.origin, 1.25, 0.5, 0.5 );
	wait 1.3;
	focus LinkTo( level.chase_main_vehicle );
	wait 2.0;

	vehicle_scripts\_ac130::ac130_set_view_arc( 5.5, 2.5, 2.5, 0, 0, 0, 0 );
	wait 5.55;
	focus thread move_to_ent_over_time( level.ac130_player_view_controller_target, 1.0, ( 0, 0, 0 ), "tag_origin" );
	//wait 1.0;
	//focus delayCall( 1.0, ::LinkTo, level.ac130_player_view_controller_target, "tag_origin" );
	vehicle_scripts\_ac130::ac130_set_view_arc( 2, 1.25, 1.25, 60, 60, 25, 40 );
}

chase_rb_exit_building()
{
	goals = get_ent_array_with_prefix( "city_area_rb_building_exit_", "targetname", 0 );
    fast_points = get_ent_array_with_prefix( "chase_delta_fast_point_", "targetname", 0 );
	
	foreach ( i, guy in level.delta )
	{
		level.delta[ i ] ai_friendly_set_scripted();
		level.delta[ i ] ForceTeleport( goals[ i ].origin, fast_points[ i ].angles );
		level.delta[ i ] clear_parent_ai();
		level.delta[ i ] Show();
	}
	
	level.makarov_number_2 ForceTeleport( goals[ goals.size - 1 ].origin, goals[ goals.size - 1 ].angles );
	
	// **TODO: remove ... should be cleaner
	
	ent_path_list = get_connected_ents( "hvt_carry_fountain" );
	
	foreach ( node in ent_path_list )
	{
		node notify( "stop_carried_loop" );
		node notify( "stop_wounded_idle" );
	}
	
	level.makarov_number_2 notify( "stop_carried_loop" );
	level.makarov_number_2 notify( "stop_wounded_idle" );
	level.bishop endon( "end_carry_ai" );
	level.bishop clear_generic_run_anim();
	
	hvt_downed_pos = getstruct_delete( "hvt_escape_hvt_downed", "targetname" );
	Assert( IsDefined( hvt_downed_pos ) );
	hvt_downed_pos notify( "LISTEN_stop_ANIM_hvt_idle_loop" );
	hvt_downed_pos notify( "stop_wounded_idle" );
	
	wait 0.05;
	
	level.makarov_number_2 clear_child_ai();
	
	// Move Frost + Makarov #2 into position
	
	start = goals[ goals.size - 1 ];
	
	animset = [];
	animset[ 0 ] = "ANIM_hostage_cover_idle_loop";
	animset[ 1 ] = [ "ANIM_hostage_cover_out" ];
	animset[ 2 ] = "ANIM_hostage_run_loop";
	animset[ 3 ] = "ANIM_hostage_cover_into";
	
	level.makarov_number_2.animname = undefined;
	level.makarov_number_2 set_child_ai( start, animset );
	wait 0.05;

	animset[ 0 ] = "ANIM_guard_cover_idle_loop";
	animset[ 1 ] = [ "ANIM_guard_cover_out" ];
	animset[ 2 ] = "ANIM_guard_run_loop";
	animset[ 3 ] = "ANIM_guard_cover_into";
	
	level.bishop.animname = undefined;
	level.bishop set_parent_ai( animset );
	wait 0.05;
	
	level.bishop parent_ai_go_to_child_ai( level.makarov_number_2 );
	
	flag_set( "FLAG_chase_rb_delta_exiting_building" );
}

chase_rb_exit_building_pip_event()
{
	wait 1.0;
	
	look_at = GetEnt( "rpg_building_look_at", "targetname" );
    Assert( IsDefined( look_at ) );
    
    level.sandman SetLookAtEntity( look_at );
    
	level.sandman set_ignoreall( true );
	level.sandman set_ignoreme( true );
	level.sandman SetCanDamage( false );
	level.sandman disable_bulletWhizbyReaction();
	level.sandman set_grenadeawareness( 0 );
	level.sandman setFlashbangImmunity( true );
	level.sandman set_neverEnableCQB( true );
	level.sandman disable_arrivals();
	level.sandman disable_exits();
	level.sandman disable_pain();
	level.sandman disable_surprise();
	level.sandman disable_danger_react();
	level.sandman set_ignoresuppression( true );
	
	wait 1;
	
	level.ac130player thread play_sound_on_entity( "scn_ac130_pip_humvee_1" );
	level.pip.clipdistance 	= 5000;
	level.pip.dofnear		= ( 0, 0, 10 );
	level.pip.doffar		= ( 4000, 10000, 4 );
	//level.pip.lod			= 2048;
	level.pip.blurradius	= 1;
	if ( GetDvarInt( "pip_enabled", 0 ) )
		maps\paris_ac130_pip::ac130_pip_init( level.sandman_fps_pip );
	
	wait 6;
	
	if ( GetDvarInt( "pip_enabled", 0 ) )
		maps\paris_ac130_pip::ac130_pip_close();
	level.pip.clipdistance = 0;
	
	level.sandman SetLookAtEntity();
	look_at Delete();
	
	level.sandman set_ignoreall( false );
	level.sandman set_ignoreme( false );
	level.sandman SetCanDamage( true );
	level.sandman enable_bulletWhizbyReaction();
	level.sandman set_grenadeawareness( 1 );
	level.sandman setFlashbangImmunity( false );
	level.sandman set_neverEnableCQB( undefined );
	level.sandman enable_arrivals();
	level.sandman enable_exits();
	level.sandman enable_pain();
	level.sandman enable_danger_react( 0 );
	level.sandman set_ignoresuppression( false );
}

chase_pfr_delta_move_down()
{   
    // Delta + Makarov #2 move ditch in pfr 
       
    group = level.delta;
    
    // Get Cover Nodes
    
    nodes = get_ent_array_with_prefix( "city_area_pf_friendly_cover_0_", "targetname", 0 );
    Assert( IsDefined( nodes ) && IsArray( nodes ) && nodes.size >= level.delta.size );
    
    // Set a flag when all members of delta reach their cover nodes
    
    _flag = "FLAG_city_area_pfr_delta_move_down";
    thread waittill_ents_notified_set_flag( group, "LISTEN_ai_goal_reached", _flag );
    
    thread chase_pfr_signal_ac130();
    
    // Send each member of delta to a cover node. Notify when they reach.
        
    foreach ( i, guy in group )
    {
    	if ( i < 4 )
    	{
        	guy.fixednode = true;
        	guy.ignoreall = true;
        	range = 4.0;
        	thread notify_ai_when_in_range_of_ent( guy, nodes[ i ], range, "LISTEN_ai_goal_reached" );
    	}
    }
    
    level.sandman delayCall( 1.0, ::SetGoalNode, nodes[ 0 ] );
    level.frost SetGoalNode( nodes[ 1 ] );
    level.hitman SetGoalNode( nodes[ 2 ] );
    level.gator SetGoalNode( nodes[ 3 ] );

    goal = getstruct( "city_area_pfr_frost_cover_point", "targetname" );
    thread notify_ai_when_in_range_of_ent( level.bishop, goal, 4.0, "LISTEN_ai_goal_reached" );
    level.makarov_number_2 SetGoalPos( goal.origin );
	level.bishop parent_ai_and_child_ai_go_to_node( level.makarov_number_2, goal, true );
	level.makarov_number_2 clear_child_ai();
	level.bishop clear_parent_ai();
	deletestruct_ref( goal );
	flag_set( "FLAG_chase_delta_ready_to_enter_vehicles" );
}

chase_pfr_signal_ac130()
{
	flag_wait( "FLAG_city_area_pfr_delta_move_down" );
	
	fx = getfx( "FX_signal_ac130" );
	chase_pfr_signal_ac130_ref = getstruct_delete( "chase_pfr_signal_ac130", "targetname" );
	Assert( IsDefined( chase_pfr_signal_ac130_ref ) );
	chase_pfr_signal_ac130 = Spawn( "script_model", chase_pfr_signal_ac130_ref.origin );
	chase_pfr_signal_ac130.angles = chase_pfr_signal_ac130_ref get_key( "angles" );
	chase_pfr_signal_ac130 SetModel( "tag_origin" );
	
	PlayFxOnTag( fx, chase_pfr_signal_ac130, "tag_origin" );
	flag_wait( "FLAG_chase_started" );	
	StopFXOnTag( fx, chase_pfr_signal_ac130, "tag_origin" );
	chase_pfr_signal_ac130 Delete();
}

chase_fx()
{
	// Override Tread FX
	
	maps\_treadfx::setvehiclefx( "script_vehicle_hummer", "concrete", "treadfx/tread_concrete_ac130" );
	maps\_treadfx::setvehiclefx( "script_vehicle_hummer_minigun_ac130", "concrete", "treadfx/tread_concrete_ac130" );
	maps\_treadfx::setvehiclefx( "script_vehicle_bm21_mobile_bed_troops", "concrete", "treadfx/tread_concrete_ac130" );
	maps\_treadfx::setvehiclefx( "script_vehicle_gaz_tigr_turret_physics", "concrete", "treadfx/tread_concrete_ac130" );
	
	maps\_treadfx::setvehiclefx( "script_vehicle_hummer", "water", "treadfx/tread_water_ac130" );
	maps\_treadfx::setvehiclefx( "script_vehicle_hummer_minigun_ac130", "water", "treadfx/tread_water_ac130" );
	maps\_treadfx::setvehiclefx( "script_vehicle_bm21_mobile_bed_troops", "water", "treadfx/tread_water_ac130" );
	maps\_treadfx::setvehiclefx( "script_vehicle_gaz_tigr_turret_physics", "water", "treadfx/tread_water_ac130" );
	
	// Override Death FX
	
	classnames = [ "script_vehicle_bm21_mobile_bed_troops", 
				   "script_vehicle_gaz_tigr_turret_physics" ];
				   
	foreach ( classname in classnames )
	{
		foreach ( i, index in level.vehicle_death_fx[ classname ] )
			level.vehicle_death_fx[ classname ][ i ] = undefined;
		level.vehicle_death_fx_override[ classname ] = true;
	}
}

chase_clear_fx()
{
	fx_ids = [ [ "battlefield_smokebank_S_warm", 			( 2757.76, 40713.3, -25 ) ],
			   [ "fire_falling_runner_point", 				( 2469.52, 41063.7, 174.875 ) ],
			   [ "fire_falling_runner_point_infrequent", 	( 2484.91, 41129.1, 183.239 ) ],
			   [ "fire_falling_runner_point_infrequent",	( 2609.44, 41162.6, 103.012 ) ],
			   [ "firelp_small_pm_a_nolight", 				( 2473.85, 41067.8, 164.875 ) ],
			   [ "firelp_small_pm_a_nolight",				( 2540.01, 41098.3, 16.0206 ) ],
			   [ "fire_falling_runner_point_infrequent", 	( 2609.44, 41162.6, 103.012 ) ],
			   [ "firelp_small_pm_a_nolight",				( 2473.85, 41067.8, 164.875 ) ],
			   [ "firelp_small_pm_a_nolight",				( 2540.01, 41098.3, 16.0206 ) ],
			   [ "firelp_small_pm_a_nolight",				( 2601.78, 41159.5, 95.901 ) ],
			   [ "firelp_small_pm_a_nolight",				( 2601.42, 41161.1, 136.441 ) ],
			   [ "firelp_small_pm_a_nolight",				( 2432.19, 41022.5, 33.1685 ) ],
			   [ "firelp_small_pm_a_nolight",				( 2601.78, 41159.5, 95.901 ) ],
			   [ "firelp_small_pm_a_nolight",				( 2601.42, 41161.1, 136.441 ) ],
			   [ "firelp_small_pm_a_nolight",				( 2432.19, 41022.5, 33.1685 ) ],
			   [ "firelp_small_pm_a_nolight",				( 2484.71, 41072, 175.128 ) ],
			   [ "insect_trail_runner_icbm", 				( 2561.92, 40854.7, -22.4893 ) ],
			   [ "insect_trail_runner_icbm", 				( 2702.27, 40961.8, -0.875 ) ],
			   [ "firelp_small_pm_a_nolight",				( 2492.03, 41072.6, 190.128 ) ],
			   [ "insect_trail_runner_icbm",				( 2561.92, 40854.7, -22.4893 ) ],
			   [ "insect_trail_runner_icbm",				( 2702.27, 40961.8, -0.875 ) ],
			   [ "insect_trail_runner_icbm",				( 2650.09, 40504.1, 5.77715 ) ],
			   [ "insect_trail_runner_icbm",				( 3177.67, 40521.3, 0.34885 ) ],
			   [ "insect_trail_runner_icbm", 				( 3587.48, 39773.8, -25 ) ],
			   [ "insect_trail_runner_icbm", 				( 2467.44, 39433.8, -25 ) ],
			   [ "insect_trail_runner_icbm", 				( 2591.95, 40263.9, -23.5519 ) ],
			   [ "leaves_fall_gentlewind", 					( 2365.74, 39661.4, 182.265 ) ],
			   [ "leaves_fall_gentlewind", 					( 2322.06, 39208.6, 176.378 ) ],
			   [ "insect_trail_runner_icbm", 				( 0, 0, 0 ) ],
			   [ "leaves_fall_gentlewind", 					( 2454.9, 40648.3, 129.621 ) ],
			   [ "insect_trail_runner_icbm", 				( 2591.95, 40263.9, -23.5519 ) ],
			   [ "leaves_fall_gentlewind", 					( 2365.74, 39661.4, 182.265 ) ],
			   [ "leaves_fall_gentlewind",					( 2322.06, 39208.6, 176.378 ) ],
			   [ "leaves_fall_gentlewind", 					( 2454.9, 40648.3, 129.621 ) ],
			   [ "leaves_fall_gentlewind", 					( 3436.7, 40177.4, 163.563 ) ],
			   [ "leaves_fall_gentlewind", 					( 3713.07, 39843, 183.618 ) ],
			   [ "battlefield_smokebank_S_warm", 			( 3000, 39834.1, 6.37475 ) ],
			   [ "leaves_fall_gentlewind", 					( 3436.7, 40177.4, 163.563 ) ],
			   [ "leaves_fall_gentlewind",					( 3713.07, 39843, 183.618 ) ],
			   [ "battlefield_smokebank_S_warm", 			( 3000, 39834.1, 6.37475 ) ],
			   [ "battlefield_smokebank_S_warm", 			( 2457.7, 39874.9, -26.2166 ) ],
			   [ "battlefield_smokebank_S_warm", 			( 3428.63, 40787, -24.9592 ) ],
			   [ "battlefield_smokebank_S_warm", 			( 2457.7, 39874.9, -26.2166 ) ],
			   [ "battlefield_smokebank_S_warm", 			( 3428.63, 40787, -24.9592 ) ],
			   [ "battlefield_smokebank_S_warm", 			( 3654, 39693, -25 ) ],
			   [ "battlefield_smokebank_S_warm", 			( 2649.3, 38588.6, -22 ) ],
			   [ "insects_light_invasion", 					( 2765.12, 41228.3, -26.9327 ) ],
			   [ "insects_light_invasion", 					( 2411.51, 40946.2, -27.9369 ) ],
			   [ "insects_light_invasion", 					( 0, 0, 0 ) ],
			   [ "battlefield_smokebank_S_warm", 			( 3654, 39693, -25 ) ],
			   [ "battlefield_smokebank_S_warm", 			( 2649.3, 38588.6, -22 ) ],
			   [ "insects_light_invasion", 					( 3546.77, 41566.2, 18 ) ],
			   [ "insects_light_invasion", 					( 3711.28, 40772.6, 4.81613 ) ],
			   [ "room_smoke_200", 							( 2457.38, 41196.1, 43.5921 ) ],
			   [ "firelp_med_pm_cheap_nolight", 			( 2458.21, 41090.2, -9.95584 ) ],
			   [ "firelp_small_pm_a_nolight", 				( 2427.72, 41072.4, -13.3787 ) ],
			   [ "firelp_small_pm_a_nolight", 				( 2419.92, 41152.2, -15.5087 ) ],
			   [ "firelp_small_pm_a_nolight", 				( 2477.3, 41128.5, -8.13709 ) ],
			   [ "firelp_small_pm_a_nolight", 				( 2437.64, 41017.8, 130.863 ) ],
			   [ "firelp_small_pm_a_nolight", 				( 2445.98, 41105.4, 174.875 ) ],
			   [ "firelp_med_pm_cheap_nolight", 			( 2448.96, 41104.5, 194.382 ) ],
			   [ "firelp_med_pm_cheap_nolight", 			( 3391.24, 46811.2, 623.654 ) ],
			   [ "firelp_med_pm_cheap_nolight", 			( 3254.92, 46806.1, 904.973 ) ],
			   [ "firelp_med_pm_cheap_nolight", 			( 3459.64, 46789.1, 638.125 ) ],
			   [ "firelp_med_pm_cheap_nolight", 			( 3401.75, 46860.3, 916.125 ) ],
			   [ "FX_firelight", 							( 2242.61, 41164.1, -6.87499 ) ],
			   [ "firelp_med_pm_cheap_nolight", 			( 2270.65, 41146, -21.875 ) ],
			   [ "firelp_med_pm_cheap_nolight", 			( 2260.76, 41277.8, -19.7228 ) ],
			   [ "FX_lights_firelight_small", 				( 2349.81, 41266.9, -19.0447 ) ] ];
	delete_createFXent_fx( fx_ids );
}

chase_friendlies_init()
{
	// Friendlies
	
	// Main Vehicle
	
	main_vehicle_spawner = GetEnt( "chase_main_vehicle", "targetname" );
	Assert( IsDefined( main_vehicle_spawner ) );
	main_vehicle_spawner add_spawn_function( ::friendly_hummer_init, "chase_main_vehicle", "targetname" );
	level.chase_main_vehicle = main_vehicle_spawner spawn_vehicle();
	Assert( IsDefined( level.chase_main_vehicle ) );
	
	friendly_spawners = GetEntArray( "delta_group_1", "targetname" );
	Assert( IsDefined( friendly_spawners ) );
	array_spawn_function( friendly_spawners, ::ai_friendly_hummer_init );
	friendlies = [];
	
	foreach ( spawner in friendly_spawners )
		friendlies[ friendlies.size ] = spawner StalingradSpawn();
	wait 0.05;
	level.chase_main_vehicle friendly_hummer_teleport_and_load( friendlies );
	level.chase_main_vehicle.dontunloadonend = true;
	//level.uniform_64
	
	slide_nodes = GetVehicleNodeArray( "chase_main_vehicle_slide", "script_noteworthy" );
	
	if ( IsDefined( slide_nodes ) )
		foreach ( node in slide_nodes )
			level.chase_main_vehicle thread friendly_hummer_slide( node );
		
	// Second Vehicle
	
	second_vehicle_spawner = GetEnt( "chase_second_vehicle", "targetname" );
	Assert( IsDefined( second_vehicle_spawner ) );
	second_vehicle_spawner add_spawn_function( ::friendly_hummer_init, "chase_second_vehicle", "targetname" );
	//second_vehicle_spawner add_spawn_function( ::friendly_hummer_fire_mg );
	level.chase_second_vehicle = second_vehicle_spawner spawn_vehicle();
	
	Assert( IsDefined( level.chase_second_vehicle ) );
	chase_friendly_vehicle_pip_setup();
	delaythread(.2,  ::chase_friendly_gunner_pip_setup);
	friendly_spawners = GetEntArray( "delta_group_2", "targetname" );
	Assert( IsDefined( friendly_spawners ) );
	array_spawn_function( friendly_spawners, ::ai_friendly_hummer_init );
	friendlies = [];
	
	foreach ( spawner in friendly_spawners )
		friendlies[ friendlies.size ] = spawner StalingradSpawn();
	wait 0.05;
	/*
	foreach ( guy in friendlies )
		if ( IsDefined( guy.script_startingposition ) && guy.script_startingposition == 4 )
			guy  chase_friendly_gunner_pip_setup();
			*/
	level.chase_second_vehicle friendly_hummer_teleport_and_load( friendlies );
	level.chase_second_vehicle.dontunloadonend = true;
	
	slide_nodes = GetVehicleNodeArray( "chase_second_vehicle_slide", "script_noteworthy" );
	
	if ( IsDefined( slide_nodes ) )
		foreach ( node in slide_nodes )
			level.chase_second_vehicle thread friendly_hummer_slide( node );
			
	level.chase_second_vehicle thread friendly_hummer_fire_mg();
	level.chase_second_vehicle thread chase_friendlies_target_pfr_enemies();
	
	// Drive to Delta
	
	vehicle_scripts\_ac130::hud_add_targets( [ level.chase_main_vehicle, level.chase_second_vehicle ] );
	
	delayThread( 0.05, ::gopath, level.chase_main_vehicle );
	delayThread( 0.5, ::gopath, level.chase_second_vehicle );
	
	_flag = "FLAG_chase_main_vehicle_arrived";
	level.chase_main_vehicle thread set_level_flag_on_vehicle_node_notify( "chase_main_vehicle_pickup_in", "script_noteworthy", _flag );
	_flag = "FLAG_chase_second_vehicle_arrived";
	level.chase_second_vehicle thread set_level_flag_on_vehicle_node_notify( "chase_second_vehicle_pickup_in", "script_noteworthy", _flag );
	
	flag_wait( "FLAG_chase_main_vehicle_arrived" );
    flag_wait( "FLAG_chase_second_vehicle_arrived" );
    flag_wait( "FLAG_chase_delta_ready_to_enter_vehicles" );
		
	// Load Delta
	
	// - Set delta + makarov back to default values
	
	level.frost clear_parent_ai();
	level.makarov_number_2 clear_child_ai();
	
	group = level.delta;
    group[ group.size ] = level.makarov_number_2;
    
    foreach ( guy in group )
    {
    	guy notify( "LISTEN_end_ai_scripts" );
    	
    	guy.fixednode = false;
    	guy.accuracy = friendlies[ 0 ].accuracy;
		guy.baseaccuracy = friendlies[ 0 ].baseaccuracy;
		guy.health = friendlies[ 0 ].health;
		guy.enemy_damage_recieved = undefined;
		guy set_goal_radius( friendlies[ 0 ].goalradius );
		guy thread chase_friendlies_turn_off_target_on_enteredvehicle();
		
		guy set_ignoreall( true );
		guy SetCanDamage( false );
		guy disable_bulletWhizbyReaction();
		guy set_grenadeawareness( 0 );
		guy setFlashbangImmunity( true );
		guy set_neverEnableCQB( true );
		guy disable_arrivals();
		guy disable_exits();
		guy disable_pain();
		guy disable_surprise();
		guy disable_danger_react();
		guy set_ignoresuppression( true );
    }
	
	_flag = "FLAG_chase_delta_entered_chase_vehicles";
	thread waittill_ents_notified_set_flag( group, "enteredvehicle", _flag );
	
	// ( other guy ) + Volk in "Main Chase Vehicle"
	
	main_group = [ level.gator, level.bishop, level.makarov_number_2 ];
	level.chase_main_vehicle thread vehicle_load_ai( main_group );
	
	foreach ( guy in main_group )
		guy thread notify_ent1_when_in_2d_range_of_ent2( guy, level.chase_main_vehicle, 96, "LISTEN_ai_near_vehicle" );
		
	// Sandman + Hitman in "Second Chase Vehicle"
	
	second_group = [ level.sandman, level.frost, level.hitman ];
	level.chase_second_vehicle thread vehicle_load_ai( second_group );
	
	foreach ( guy in second_group )
		guy thread notify_ent1_when_in_2d_range_of_ent2( guy, level.chase_second_vehicle, 96, "LISTEN_ai_near_vehicle" );
	
	flag_wait_or_timeout( "FLAG_chase_delta_entered_chase_vehicles", 10 );
	flag_set( "FLAG_chase_delta_entered_chase_vehicles" );
	
	foreach ( guy in group )
	{
		guy set_ignoreall( false );
		guy SetCanDamage( true );
		guy enable_bulletWhizbyReaction();
		guy set_grenadeawareness( 1 );
		guy setFlashbangImmunity( false );
		guy set_neverEnableCQB( undefined );
		guy enable_arrivals();
		guy enable_exits();
		guy enable_pain();
		guy enable_surprise();
		guy enable_danger_react( 0 );
		guy set_ignoresuppression( false );
	}
	
	ac130_path( "chase" );
	flag_set( "FLAG_chase_started" );
	flag_clear( "FLAG_building_trigger_mission_failed_on" );
	level notify( "LISTEN_end_monitor_mission_fail_points" );
	thread chase_clear_fx();
	delayThread( 5.0, ::set_saved_dvar_over_time, "sm_sunsamplesizenear", 2.0, 2 );
	
	musicplaywrapper("paris_ac130_chase_mx");
	
	level.chase_main_vehicle thread friendly_hummer_on_damage();
	level.chase_second_vehicle thread friendly_hummer_on_damage();
	
	level.ambient_aa_fire_short_delay = 0.25;
	level.ambient_aa_fire_tracer_delay = 0.25;
	level.ambient_aa_fire_flash_delay = 0.25;
	
	// Set Vehicles onto new paths	
	thread chase_friendly_vehicle_pip();
	
	node = GetVehicleNode( "chase_main_vehicle_pickup_out", "script_noteworthy" );
	Assert( IsDefined( node ) );
	level.chase_main_vehicle delayThread( 0.05, ::switch_vehicle_path, node );
	node = GetVehicleNode( "chase_second_vehicle_pickup_out", "script_noteworthy" );
	Assert( IsDefined( node ) );
	level.chase_second_vehicle delayThread( 0.5, ::switch_vehicle_path, node );

}

chase_friendly_gunner_pip_setup()
{	
	spot = get_world_relative_offset( level.chase_second_vehicle.origin, level.chase_second_vehicle.angles,  ( -25, -5, 100 ) ) ; //-25, -13, 113
	gunner_ent = spawn ( "script_origin", spot );
	gunner_ent.angles = level.chase_second_vehicle.angles +(6, 0, 0);
	gunner_ent.targetname = "chase_gunner_pip";
	gunner_ent linkto ( level.chase_second_vehicle.mgturret[0], "TAG_BARREL");//TAG_PIVOT TAG_barrel TAG_flash
}

chase_friendly_vehicle_pip_setup()
{
	spot = get_world_relative_offset( level.chase_second_vehicle.origin, level.chase_second_vehicle.angles,  ( 8, 36, 66 ) ) ; //-63x
	ent = spawn ( "script_origin", spot );
	ent.angles = level.chase_second_vehicle.angles +(0, 328, 0);
	ent.targetname = "chase_vehicle_pip";
	ent linkto ( level.chase_second_vehicle );
}

chase_friendly_vehicle_pip()
{	
	gunner_ent = GetEnt( "chase_gunner_pip", "targetname" );
	Assert( IsDefined( gunner_ent ) );		
	ent = GetEnt( "chase_vehicle_pip", "targetname" );
	Assert( IsDefined( ent ) );
	
	while ( level.chase_second_vehicle.riders.size != 5 )
		wait 0.05;
	
	gunner = level.chase_second_vehicle.riders[ 4 ];
	
	foreach ( guy in level.chase_second_vehicle.riders )
		if ( IsDefined( guy.script_startingposition ) && guy.script_startingposition == 4 )
			gunner = guy;
				
	gunner set_ignoreme( true );
	gunner SetCanDamage( false );
	gunner disable_bulletWhizbyReaction();
	gunner set_grenadeawareness( 0 );
	gunner setFlashbangImmunity( true );
	gunner set_neverEnableCQB( true );
	gunner disable_arrivals();
	gunner disable_exits();
	gunner disable_pain();
	gunner disable_surprise();
	gunner disable_danger_react();
	gunner set_ignoresuppression( true );
			
	delay = 10; //5
	toggle = 1;
	
	level.ac130player thread play_sound_on_entity( "scn_ac130_pip_humvee_2" );
	level.pip.clipdistance 	= 6000;
	level.pip.dofnear		= ( 0, 0, 10 );
	level.pip.doffar		= ( 5000, 10000, 4 );
	//level.pip.lod			= 2048;
	level.pip.blurradius	= 1;
	if ( GetDvarInt( "pip_enabled", 0 ) )
		maps\paris_ac130_pip::ac130_pip_init( ent, undefined, undefined, 65 );
	wait delay;
	if ( GetDvarInt( "pip_enabled", 0 ) )
		maps\paris_ac130_pip::ac130_pip_close();
	wait 0.05;
	
	level.pip.clipdistance 	= 4000;
	level.pip.dofnear		= ( 0, 0, 10 );
	level.pip.doffar		= ( 3500, 10000, 4 );
	//level.pip.lod			= 2048;
	level.pip.blurradius	= 1;
	level.ac130player thread play_sound_on_entity( "scn_ac130_pip_50cal" );
	if ( GetDvarInt( "pip_enabled", 0 ) )
		maps\paris_ac130_pip::ac130_pip_init( gunner_ent, undefined, undefined, 60 );
	wait delay;
	if ( GetDvarInt( "pip_enabled", 0 ) )
		maps\paris_ac130_pip::ac130_pip_close();
	level.pip.clipdistance = 0;
	
	gunner set_ignoreme( false );
	gunner SetCanDamage( true );
	gunner enable_bulletWhizbyReaction();
	gunner set_grenadeawareness( 1 );
	gunner setFlashbangImmunity( false );
	gunner set_neverEnableCQB( undefined );
	gunner enable_arrivals();
	gunner enable_exits();
	gunner enable_pain();
	gunner enable_danger_react( 0 );
	gunner set_ignoresuppression( false );
	
	// Clean Up
	
	gunner_ent Delete();
	ent Delete();
}

chase_friendlies_turn_off_target_on_enteredvehicle()
{
	self waittill( "LISTEN_ai_near_vehicle" );
	vehicle_scripts\_ac130::hud_remove_targets( [ self ] );
}

chase_friendlies_target_pfr_enemies()
{
	while ( !flag( "FLAG_chase_started" ) )
	{
		enemies = GetAIArray( "axis" );
		
		foreach ( guy in enemies )
			level.chase_second_vehicle friendly_hummer_add_turret_target( guy );
		wait 0.05;
	}
	kill_encounter_enemies( 0.05 );
}

chase_enemies_init()
{
	flag_wait( "FLAG_chase_started" );
	
	thread chase_t72s();
	thread chase_vehicles();
	thread chase_rpgs();
	
	delayThread( 15.0, ::chase_t72_mobilize_group_1 );
	delayThread( 1.0, ::chase_t72_mobilize_group_2 );
	delayThread( 1.0, ::chase_t72_mobilize_group_3 );
	delayThread( 5.0, ::chase_mi17s );
	delayThread( 12.0, ::chase_hinds );
	
	delaythread( 7.0, ::chase_mission_failed );
}


chase_mission_failed()
{
	// "Kill enemies pursuing Delta."
	deadquote 		= "PARIS_AC130_DEADQUOTE_CHASE_1";
	enemies_to_kill = 2;
	
	switch( level.gameSkill )
	{
		case 0:
			enemies_to_kill = 1;
			break;
		case 2:
			enemies_to_kill = 3;
			break;
		case 3:
			enemies_to_kill = 4;
			// "Kill ALL enemies pursuing Delta."
			deadquote 		= "PARIS_AC130_DEADQUOTE_CHASE_2";
			break;
	}
	flag_count_set( "FLAG_chase_encounter_1_complete", enemies_to_kill );
			
	fail_node = get_ents_from_array( "check_fail", "script_noteworthy", get_connected_ents( level.chase_second_vehicle.target ) )[ 0 ];
	Assert( IsDefined( fail_node ) );
	fail_node waittill( "trigger" );
	
	if ( !flag( "FLAG_chase_encounter_1_complete" ) )
		_mission_failed( "@" + deadquote );
	thread vehicle_scripts\_ac130::autosave_ac130();
}

chase_enemy_flag_count_decrement_on_notify( msg, flag )
{
	Assert( IsDefined( msg ) );
	Assert( IsDefined( flag ) );
	self waittill( msg );
	flag_count_decrement( flag );
}

chase_hind_flag_count_decrement_on_notify( msg, flag )
{
	Assert( IsDefined( msg ) );
	Assert( IsDefined( flag ) );
	self waittill( msg );
	flag_count_decrement( flag );
}

chase_hinds_mission_failed( enemies )
{
	enemies_to_kill = 1;
	
	switch( level.gameSkill )
	{
		case 0:
			enemies_to_kill = 1;
			break;
		case 2:
			enemies_to_kill = 2;
			break;
		case 3:
			enemies_to_kill = 4;
			break;
	}
	flag_count_set( "FLAG_chase_encounter_2_complete", enemies_to_kill );
	
	flag_wait( "FLAG_chase_encounter_2_check" );
	if ( !flag( "FLAG_chase_encounter_2_complete" ) )
		_mission_failed( "@PARIS_AC130_MISSION_FAIL_HUMVEE_SUPPORT" );
}

chase_rpgs()
{
	rpg_spawner = GetEnt( "chase_rpg_enemy", "targetname" );
	Assert( IsDefined( rpg_spawner ) );
	spots = getstructarray_delete( "chase_rpg_enemy", "targetname" );
	spots = array_index_by_script_index( spots );
	rpgs = [];
	
	foreach ( i, spot in spots )
	{
		rpg_spawner.count = 1;
		rpg_spawner.origin = spot.origin;
		rpg_spawner.angles = spot get_key( "angles" );
		rpg_spawner.target = spot.target;
		
		rpgs[ i ] = rpg_spawner SpawnDrone();
		wait 0.05;
		rpgs[ i ] thread ai_enemy_rpg_drone_init();
	}
	
	targets = [];
	
	foreach ( i, spot in spots )
		targets[ i ] = getstruct_delete( spot.target, "targetname" );
		
	rpgs[ 1 ] delayThread( 19.0, ::ai_enemy_rpg_shoot_at_target, targets[ 1 ] );
	rpgs[ 2 ] delayThread( 19.5, ::ai_enemy_rpg_shoot_at_target, targets[ 2 ] );
	rpgs[ 3 ] delayThread( 20.0, ::ai_enemy_rpg_shoot_at_target, targets[ 3 ] );
	rpgs[ 4 ] delayThread( 20.5, ::ai_enemy_rpg_shoot_at_target, targets[ 4 ] );
	rpgs[ 5 ] delayThread( 21.0, ::ai_enemy_rpg_shoot_at_target, targets[ 5 ] );
	
	rpgs[ 6 ] delayThread( 22.0, ::ai_enemy_rpg_shoot_at_target, targets[ 6 ] );
	rpgs[ 7 ] delayThread( 22.5, ::ai_enemy_rpg_shoot_at_target, targets[ 7 ] );
	rpgs[ 8 ] delayThread( 23.0, ::ai_enemy_rpg_shoot_at_target, targets[ 8 ] );
	rpgs[ 9 ] delayThread( 23.5, ::ai_enemy_rpg_shoot_at_target, targets[ 9 ] );
	
	rpgs[ 10 ] delayThread( 25.0, ::ai_enemy_rpg_shoot_at_target, targets[ 10 ] );
	rpgs[ 11 ] delayThread( 25.5, ::ai_enemy_rpg_shoot_at_target, targets[ 11 ] );
	
	rpgs[ 12 ] delayThread( 29.0, ::ai_enemy_rpg_shoot_at_target, targets[ 12 ] );
	rpgs[ 13 ] delayThread( 29.5, ::ai_enemy_rpg_shoot_at_target, targets[ 13 ] );
	rpgs[ 14 ] delayThread( 30.0, ::ai_enemy_rpg_shoot_at_target, targets[ 14 ] );
	rpgs[ 15 ] delayThread( 30.5, ::ai_enemy_rpg_shoot_at_target, targets[ 15 ] );
	
	rpgs[ 16 ] delayThread( 41.5, ::ai_enemy_rpg_shoot_at_target, targets[ 16 ] );
	rpgs[ 17 ] delayThread( 42.0, ::ai_enemy_rpg_shoot_at_target, targets[ 17 ] );
	rpgs[ 18 ] delayThread( 42.5, ::ai_enemy_rpg_shoot_at_target, targets[ 18 ] );
	rpgs[ 19 ] delayThread( 43.0, ::ai_enemy_rpg_shoot_at_target, targets[ 19 ] );
	
	flag_wait( "FLAG_chase_end_chase" );
	
	foreach ( rpg in rpgs )
	{
		if ( IsDefined( rpg ) )
		{
			rpg notify( "death" );
			rpg Delete();
		}
	}
	rpg_spawner Delete();
}

chase_vehicles()
{
	gaz_spawner = GetEnt( "chase_gaz", "targetname" );
	Assert( IsDefined( gaz_spawner ) );
	gaz_spawner add_spawn_function( ::enemy_gaz_init );
	gaz_spawner add_spawn_function( ::enemy_gaz_fire_mg, level.chase_second_vehicle );
	gaz_spawner add_spawn_function( ::monitor_vehicle_mission_fail_points );
	gaz_spawner add_spawn_function( ::vehicle_enemy_kill_dialogue_monitor );
	
	gaz_passenger_spawner = GetEnt( "chase_gaz_enemy", "targetname" );
	Assert( IsDefined( gaz_passenger_spawner ) );
	gaz_passenger_spawner add_spawn_function( ::ai_enemy_chase_init );
	gaz_passenger_spawner add_spawn_function( ::monitor_ai_mission_fail_points );
	
	bm21_spawner = GetEnt( "chase_bm21", "targetname" );
	Assert( IsDefined( bm21_spawner ) );
	bm21_spawner add_spawn_function( ::enemy_bm21_init );
	bm21_spawner add_spawn_function( ::monitor_vehicle_mission_fail_points );
	bm21_spawner add_spawn_function( ::vehicle_enemy_kill_dialogue_monitor );
	
	bm21_passenger_spawner = GetEnt( "chase_bm21_enemy", "targetname" );
	Assert( IsDefined( bm21_passenger_spawner ) );
	bm21_passenger_spawner add_spawn_function( ::ai_enemy_chase_init );
	bm21_passenger_spawner add_spawn_function( ::monitor_ai_mission_fail_points );
	
	spots = getstructarray_delete( "chase_vehicle", "targetname" );
	spots = array_index_by_script_index( spots );
	
	// 1
	delaythread( 2.05, ::chase_vehicle_spawn, gaz_spawner, spots[ 1 ], gaz_passenger_spawner );
	delaythread( 2.75, ::chase_vehicle_spawn, bm21_spawner, spots[ 2 ], bm21_passenger_spawner );
	delayThread( 3.0, ::chase_vehicles_monitor, 1, 2 );
	
	// 2
	delaythread( 8.55, ::chase_vehicle_spawn, gaz_spawner, spots[ 3 ], gaz_passenger_spawner );
	delaythread( 9.25, ::chase_vehicle_spawn, bm21_spawner, spots[ 4 ], bm21_passenger_spawner );
	delayThread( 10.0, ::chase_vehicles_monitor, 3, 4 );

	// 3
	delaythread( 10.05, ::chase_vehicle_spawn, gaz_spawner, spots[ 5 ], gaz_passenger_spawner );
	delaythread( 10.05, ::chase_vehicle_spawn, bm21_spawner, spots[ 6 ], bm21_passenger_spawner );
	delayThread( 11.0, ::chase_vehicles_monitor, 5, 6 );
	
	// 4
	delaythread( 20.05, ::chase_vehicle_spawn, gaz_spawner, spots[ 7 ], gaz_passenger_spawner );
	delaythread( 20.5, ::chase_vehicle_spawn, bm21_spawner, spots[ 8 ], bm21_passenger_spawner );
	delayThread( 21.0, ::chase_vehicles_monitor, 7, 8 );
	
	// Clean up
	
	flag_wait( "FLAG_chase_end_chase" );
	
	gaz_spawner Delete();
	gaz_passenger_spawner Delete();
	bm21_spawner Delete();
	bm21_passenger_spawner Delete();
}

chase_vehicles_monitor( index_1, index_2 )
{
	chase_vehicles = Vehicle_GetArray();
	vehicles = [];
	
	foreach ( vehicle in chase_vehicles )
		if ( ( vehicle compare_value( "script_index", index_1 ) ||
			   vehicle compare_value( "script_index", index_2 ) ) && 
			 ( vehicle compare_value( "script_parameters", "gaz" ) ||
			   vehicle compare_value( "script_parameters", "bm21" ) ) )
			 vehicles = add_to_array( vehicles, vehicle );
	
	thread waittill_ents_notified_set_flag( vehicles, "death", "FLAG_chase_vehicles_" + index_1 + "_" + index_2 + "_killed" );
}

chase_vehicle_spawn( vehicle_spawner, spot, passenger_spawner )
{
	Assert( IsDefined( vehicle_spawner ) );
	Assert( IsDefined( spot ) );
	Assert( IsDefined( passenger_spawner ) );
	
	vehicle_spawner.count = 1;
	copy_keys( [ vehicle_spawner ], spot, [ "origin", "angles", "target" ] );
	vehicle = vehicle_spawner spawn_vehicle();
	wait 0.05;
	copy_keys( [ vehicle ], spot, [ "script_index", "script_parameters" ] );
	vehicle thread chase_enemy_flag_count_decrement_on_notify( "LISTEN_killed_by_player", "FLAG_chase_encounter_1_complete" );
	
	level.chase_second_vehicle friendly_hummer_add_turret_target( vehicle );
	
	// FX
	
	slide_nodes = GetVehicleNodeArray( "chase_enemy_vehicle_" + spot.script_index + "_slide", "script_noteworthy" );
	
	if ( IsDefined( slide_nodes ) )
		foreach ( node in slide_nodes )
			if ( spot compare_value( "script_parameters", "gaz" ) )
				vehicle thread enemy_gaz_slide( node );
			else
				vehicle thread enemy_bm21_slide( node );
			
	// Load enemies
	
	if ( spot compare_value( "script_parameters", "gaz" ) )
		vehicle thread enemy_gaz_load_passengers_alt( passenger_spawner, 2 );
	else
		vehicle thread enemy_bm21_load_passengers_alt( passenger_spawner, 10 );
	
	// - Count number of crash paths for vehicle, then thread checks for each crash path
	
	crash_node_prefix = spot.script_noteworthy + "_";
	crash_path_ins = get_ent_array_with_prefix_suffix( crash_node_prefix, "script_noteworthy", 1, "_in" );
	
	for ( i = 1; i < crash_path_ins.size; i ++ )
		if ( spot compare_value( "script_parameters", "gaz" ) )
			vehicle thread enemy_gaz_crash_path( crash_node_prefix + i );
		else
			vehicle thread enemy_bm21_crash_path( crash_node_prefix + i );
	if ( spot compare_value( "script_parameters", "gaz" ) )
		vehicle thread enemy_gaz_last_crash_path( crash_node_prefix + crash_path_ins.size );
	else
		vehicle thread enemy_bm21_last_crash_path( crash_node_prefix + crash_path_ins.size );
	thread gopath( vehicle );
	vehicle_scripts\_ac130::hud_add_targets( [ vehicle ] );
}

chase_hinds()
{
	hind_spawner = GetEnt( "chase_hind", "targetname" );
	Assert( IsDefined( hind_spawner ) );
	hind_spawner add_spawn_function( ::enemy_hind_init, "chase_hind" );
	hind_spawner add_spawn_function( ::monitor_vehicle_mission_fail_points );
	hind_spawner add_spawn_function( ::vehicle_enemy_kill_dialogue_monitor, "hind" );
	hind_spots = getstructarray_delete( "chase_hind", "targetname" );
	hind_spots = array_index_by_script_index( hind_spots );
	
	pilot_spawner = GetEnt( "chase_hind_pilot", "targetname" );
	Assert( IsDefined( pilot_spawner ) );
	
	look_at = GetEnt( "chase_enemy_hind_look_at", "targetname" );
	Assert( IsDefined( look_at ) );
	
	targets = getstructarray_delete( "chase_enemy_hind_rocket_point", "targetname" );
	targets = array_randomize( targets );

	foreach ( enemy in level.encounter_primary_enemies )
		enemy notify( "LISTEN_end_monitor_encounter_primary_enemy_on_death" );
	
	hinds =[];
	
	foreach ( i, spot in hind_spots )
	{
		hind_spawner.count = 1;
		copy_keys( [ hind_spawner ], spot, [ "origin", "angles", "target" ] );
		hinds[ i ] = hind_spawner spawn_vehicle();
		
		wait 0.05;
		
		hinds[ i ] thread enemy_hind_load_pilot_alt( pilot_spawner );
		hinds[ i ] thread chase_hind_flag_count_decrement_on_notify( "LISTEN_killed_by_player", "FLAG_chase_encounter_2_complete" );
		
		if ( i <= 2 )
		{
			hinds[ i ] thread enemy_hind_gopath_and_die();
			hinds[ i ] thread enemy_hind_stop_and_shoot_rockets( look_at, [ targets[ i % targets.size ] ] );
		}
		wait ter_op( i > 2, 1.0, 0.05 );
	}
	
	thread chase_hinds_mission_failed( hinds );
	
	hinds[ 3 ] delayThread( 18.0, ::enemy_hind_gopath_and_die );
	hinds[ 4 ] delayThread( 17.5, ::enemy_hind_gopath_and_die );
	
	vehicle_scripts\_ac130::hud_add_targets( hinds );
	
	_flag = "FLAG_chase_hinds_killed";
	thread waittill_ents_notified_set_flag( hinds, "death", _flag );
	
	thread chase_hinds_reminder();
	
	_notify = "LISTEN_hind_finished_shooting_rockets";
	_flag = "FLAG_chase_hinds_finished_shooting_rockets";
	thread waittill_ents_notified_set_flag( [ hinds[ 1 ], hinds[ 2 ] ], _notify, _flag );
	
	flag_wait( "FLAG_chase_hinds_finished_shooting_rockets" );
	
	level.chase_second_vehicle friendly_hummer_add_turret_target( hinds[ 1 ] );
	level.chase_second_vehicle friendly_hummer_add_turret_target( hinds[ 2 ] );
	
	foreach ( i, hind in hinds )
	{
		if ( IsDefined( hind ) && IsAlive( hind ) )
		{
			switch ( i )
			{
				case 1:
					hind SetLookAtEnt( level.chase_main_vehicle );
					break;
				case 2:
					hind SetLookAtEnt( level.chase_second_vehicle );
					break;
				default:
					target = ter_op( RandomInt( 2 ), level.chase_main_vehicle, level.chase_second_vehicle );
					hind SetLookAtEnt( target );
					hind thread enemy_hind_fire_mg( target );
					break;
			}
		}
	} 
	
	wait 4.0;
	
	thread chase_hind_hints();
	
	if ( IsDefined( hinds[ 1 ] ) && IsAlive( hinds[ 1 ] ) )
	{
		hinds[ 1 ] delayThread( 1.0, ::enemy_hind_fire_mg, level.chase_second_vehicle );
		hinds[ 1 ] delayCall( 3.0, ::Vehicle_SetSpeedImmediate, 35, 7, 7 );
		
		points_1 = get_connected_ents( "chase_enemy_hind_1_rocket_points" );
		deletestructarray_ref( points_1 );
		
		hinds[ 1 ] delayThread( 1.0, ::enemy_hind_shoot_rocket_at_target, points_1[ 0 ] );
		hinds[ 1 ] delayThread( 3.0, ::enemy_hind_shoot_rocket_at_target, points_1[ 1 ] );
		hinds[ 1 ] delayThread( 5.0, ::enemy_hind_shoot_rocket_at_target, points_1[ 2 ] );
		hinds[ 1 ] delayThread( 7.0, ::enemy_hind_shoot_rocket_at_target, points_1[ 3 ] );
	}
	
	if ( IsDefined( hinds[ 2 ] ) && IsAlive( hinds[ 2 ] ) )
	{
		hinds[ 2 ] delayThread( 1.0, ::enemy_hind_fire_mg, level.chase_second_vehicle );
		hinds[ 2 ] delayCall( 3.25, ::Vehicle_SetSpeedImmediate, 35, 7, 7 );
	
		points_2 = get_connected_ents( "chase_enemy_hind_2_rocket_points" );
		deletestructarray_ref( points_2 );
	
		hinds[ 2 ] delayThread( 2.0, ::enemy_hind_shoot_rocket_at_target, points_2[ 0 ] );
		hinds[ 2 ] delayThread( 4.0, ::enemy_hind_shoot_rocket_at_target, points_2[ 1 ] );
		hinds[ 2 ] delayThread( 6.0, ::enemy_hind_shoot_rocket_at_target, points_2[ 2 ] );
		hinds[ 2 ] delayThread( 8.0, ::enemy_hind_shoot_rocket_at_target, points_2[ 3 ] );
	}
	
	foreach ( i, hind in hinds )
		if ( IsDefined( hind ) && IsAlive( hind ) && i > 2 )
			hind delayCall( 2.0, ::Vehicle_SetSpeedImmediate, 62, 30, 30 );
	
	if ( IsDefined( hinds[ 3 ] ) && IsAlive( hinds[ 3 ] ) )
	{
		points_3 = get_connected_ents( "chase_enemy_hind_3_rocket_points" );
		deletestructarray_ref( points_3 );
		
		hinds[ 3 ] delayThread( 14.0, ::enemy_hind_shoot_rocket_at_target, points_3[ 0 ] );
		hinds[ 3 ] delayThread( 18.0, ::enemy_hind_shoot_rocket_at_target, points_3[ 1 ] );
	}
	
	if ( IsDefined( hinds[ 4 ] ) && IsAlive( hinds[ 4 ] ) )
	{
		points_4 = get_connected_ents( "chase_enemy_hind_4_rocket_points" );
		deletestructarray_ref( points_4 );
		
		hinds[ 4 ] delayThread( 16.0, ::enemy_hind_shoot_rocket_at_target, points_4[ 0 ] );
		hinds[ 4 ] delayThread( 20.0, ::enemy_hind_shoot_rocket_at_target, points_4[ 1 ] );
	}
		
	flag_wait( "FLAG_chase_hinds_killed" );
	
	hind_spawner Delete();
	pilot_spawner Delete();
	
	foreach ( spot in hind_spots )
		deletestructarray_ref( get_connected_ents( spot.target ) );
}

chase_hind_hints()
{
	timeout = 5.0;
	if ( !IsSubStr( level.current_weapon, "25" ) )
		level.player display_hint_timeout( "HINT_ac130_use_25", timeout );
}

chase_hinds_reminder()
{
	flag_wait( "FLAG_chase_dialogue_finished" );
	
	sounds = [];
    
	// ** 12-18 Get these choppers off our ass, Warhammer!
	sounds[ sounds.size ] = level.scr_sound[ "snd" ][ "ac130_snd_choppersoffass" ];
	// ** 12-19 Hit those birds, NOW!
    sounds[ sounds.size ] = level.scr_sound[ "snd" ][ "ac130_snd_hitbirdsnow" ];
    // ** 12-20 Take out those choppers!
    sounds[ sounds.size ] = level.scr_sound[ "snd" ][ "ac130_snd_takeoutchoppers" ];
    
    array = [];
    
    for ( i = 0; i < sounds.size; i++ )
    	array[ array.size ] = i;
    	
    delay = 4.0;
    index = 0;
    	
	while ( !flag( "FLAG_chase_hinds_killed" ) )
	{	
		if ( array.size == 0 )
		{
			for ( i = 0; i < sounds.size; i++ )
    			array[ array.size ] = i;
    		if ( array.size > 1 )
    			array = array_remove_index( array, index );
    	}
		
		index = RandomInt( array.size );
		
		vehicle_scripts\_ac130::playSoundOverRadio( sounds[ array[ index ] ], false );
    	array = array_remove_index( array, index );
		wait delay;
	}
}

chase_t72s()
{
	t72_spawner = GetEnt( "chase_t72", "targetname" );
	Assert( IsDefined( t72_spawner ) );
	t72_spawner add_spawn_function( ::enemy_t72_init, "chase_t72", "targetname", 1 );
	t72_spawner add_spawn_function( ::monitor_vehicle_mission_fail_points );
	t72_spawner add_spawn_function( ::vehicle_enemy_kill_dialogue_monitor, "t72" );
	spots = getstructarray_delete( "chase_t72", "targetname" );
	spots = array_index_by_script_index( spots );
	t72s = [];
	
	foreach ( i, spot in spots )
	{
		t72_spawner.count = 1;
		t72_spawner.origin = spot.origin;
		t72_spawner.angles = spot get_key( "angles" );
		t72_spawner.target = spot.target;
		t72s[ i ] = t72_spawner spawn_vehicle();
		wait 0.1;
		t72s[ i ] thread chase_enemy_flag_count_decrement_on_notify( "LISTEN_killed_by_player", "FLAG_chase_encounter_1_complete" );
		t72s[ i ].script_index = spot.script_index;
	}
	
	thread achieve_menage_a_trois( [ t72s[ 2 ], t72s[ 3 ], t72s[ 4 ] ] );
	thread achieve_menage_a_trois( [ t72s[ 5 ], t72s[ 6 ], t72s[ 7 ] ] );
	
	look_at = GetEnt( "chase_enemy_tank_look_at_1", "targetname" );
	Assert( IsDefined( look_at ) );
	
	t72s[ 1 ] SetTurretTargetEnt( look_at );
	t72s[ 2 ] SetTurretTargetEnt( look_at );
	t72s[ 3 ] SetTurretTargetEnt( look_at );
	t72s[ 4 ] SetTurretTargetEnt( look_at );
	
	flag_wait( "FLAG_chase_end_chase" );
	
	foreach ( t72 in t72s )
	{
		if ( IsDefined( t72 ) )
		{
			t72 notify( "death" );
			t72 Delete();
		}
	}
	t72_spawner Delete();
	look_at Delete();
}

chase_t72_mobilize_group_1()
{
	t72s = GetEntArray( "chase_t72", "targetname" );
	t72s = array_index_by_script_index( t72s );
	
	thread vehicle_safe_gopath( t72s[ 1 ] );
	thread vehicle_safe_gopath( t72s[ 2 ] );

	// Fix for letting Veteran players be aware of other targets they can kill
	if( level.gameSkill == 3 )
	{
		delayThread( 4.0, vehicle_scripts\_ac130::hud_add_targets, [ t72s[ 1 ], t72s[ 2 ] ] );
		delayThread( 25.0, vehicle_scripts\_ac130::hud_remove_targets, [ t72s[ 1 ], t72s[ 2 ] ] );
	}
	
	wait 6.5;
	
	t72s = array_removeundefined( t72s );
	t72s = array_removedead( t72s );
	t72s = array_index_by_script_index( t72s );
	
	delayThread( 15.0, vehicle_scripts\_ac130::hud_add_targets, [ t72s[ 3 ], t72s[ 4 ] ] );
	delayThread( 30.0, vehicle_scripts\_ac130::hud_remove_targets, [ t72s[ 3 ], t72s[ 4 ] ] );
	
	shoot_ats = get_ent_array_with_prefix_suffix_1_to_1( "chase_enemy_tank_", "targetname", 1, "_shoot_at_1" );
	
	t72s[ 1 ] delayThread( 1.0, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 1 ] );
	t72s[ 2 ] delayThread( 1.25, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 2 ] );
	t72s[ 3 ] delayThread( 1.5, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 3 ] );
	t72s[ 4 ] delayThread( 2.5, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 4 ] );
	
	shoot_ats = get_ent_array_with_prefix_suffix_range_1_to_1( "chase_enemy_tank_", "targetname", 1, 2, "_shoot_at_2" );
	
	t72s[ 1 ] delayThread( 9.5, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 1 ] );
	t72s[ 2 ] delayThread( 4.5, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 2 ] );
	
	shoot_ats = get_ent_array_with_prefix_suffix_range_1_to_1( "chase_enemy_tank_", "targetname", 1, 2, "_shoot_at_3" );
	
	t72s[ 1 ] delayThread( 12.5, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 1 ] );
	t72s[ 2 ] delayThread( 11.5, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 2 ] );
	
	_t72s = [ t72s[ 1 ], t72s[ 2 ] ];
	
	foreach ( t72 in _t72s )
	{
		starting_node = GetVehicleNode( t72.targetname + "_" + t72.script_index + "_in", "script_noteworthy" );
		transition_node = GetVehicleNode( t72.targetname + "_" + t72.script_index + "_out", "script_noteworthy" );
		t72 thread switch_vehicle_between_paths( starting_node, transition_node );
	}
	
	delayThread( 16.5, ::vehicle_safe_gopath, t72s[ 3 ] );
	delayThread( 16.5, ::vehicle_safe_gopath, t72s[ 4 ] );
	
	shoot_ats = get_ent_array_with_prefix_suffix_range_1_to_1( "chase_enemy_tank_", "targetname", 3, 4, "_shoot_at_2" );
	
	t72s[ 3 ] delayThread( 20.0, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 3 ] );
	t72s[ 4 ] delayThread( 21.5, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 4 ] );
	
	shoot_ats = get_ent_array_with_prefix_suffix_range_1_to_1( "chase_enemy_tank_", "targetname", 3, 4, "_shoot_at_3" );
	
	t72s[ 3 ] delayThread( 22.5, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 3 ] );
	t72s[ 4 ] delayThread( 24.0, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 4 ] );
	
	shoot_ats = get_ent_array_with_prefix_suffix_range_1_to_1( "chase_enemy_tank_", "targetname", 3, 4, "_shoot_at_4" );
	
	t72s[ 3 ] delayThread( 25.5, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 3 ] );
	t72s[ 4 ] delayThread( 26.5, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 4 ] );
}

chase_t72_mobilize_group_2()
{
	t72s = GetEntArray( "chase_t72", "targetname" );
	t72s = array_index_by_script_index( t72s );
	
	delayThread( 0.05, ::vehicle_safe_gopath, t72s[ 5 ] );
	delaythread( 2.5, ::vehicle_safe_gopath, t72s[ 6 ] );
	delayThread( 1.0, ::vehicle_safe_gopath, t72s[ 7 ] );
	
	wait 33.0;
	
	t72s = array_removeundefined( t72s );
	t72s = array_removedead( t72s );
	t72s = array_index_by_script_index( t72s );
	
	vehicle_scripts\_ac130::hud_add_targets( [ t72s[ 5 ], t72s[ 6 ], t72s[ 7 ] ] );
	delayThread( 10.0, vehicle_scripts\_ac130::hud_remove_targets, [ t72s[ 5 ], t72s[ 6 ], t72s[ 7 ] ] );
	
	shoot_ats = get_ent_array_with_prefix_suffix_range_1_to_1( "chase_enemy_tank_", "targetname", 5, 7, "_shoot_at_1" );
	
	t72s[ 5 ] delayThread( 1.0, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 5 ] );
	t72s[ 6 ] delayThread( 1.25, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 6 ] );
	t72s[ 7 ] delayThread( 1.5, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 7 ] );
	
	shoot_ats = get_ent_array_with_prefix_suffix_range_1_to_1( "chase_enemy_tank_", "targetname", 5, 7, "_shoot_at_2" );
	
	t72s[ 5 ] delayThread( 5.0, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 5 ] );
	t72s[ 6 ] delayThread( 5.25, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 6 ] );
	t72s[ 7 ] delayThread( 5.5, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 7 ] );
}

chase_t72_mobilize_group_3()
{
	t72s = GetEntArray( "chase_t72", "targetname" );
	t72s = array_index_by_script_index( t72s );
	
	wait 5.0;
	
	delayThread( 0.05, ::vehicle_safe_gopath, t72s[ 8 ] );
	delaythread( 2.5, ::vehicle_safe_gopath, t72s[ 9 ] );
	delayThread( 1.0, ::vehicle_safe_gopath, t72s[ 10 ] );
	
	wait 18.0;
	
	t72s = array_removeundefined( t72s );
	t72s = array_removedead( t72s );
	t72s = array_index_by_script_index( t72s );
	
	vehicle_scripts\_ac130::hud_add_targets( [ t72s[ 8 ], t72s[ 9 ], t72s[ 10 ] ] );
	delayThread( 15.0, vehicle_scripts\_ac130::hud_remove_targets, [ t72s[ 8 ], t72s[ 9 ], t72s[ 10 ] ] );
	
	/*
	shoot_ats = get_ent_array_with_prefix_suffix_range_1_to_1( "chase_enemy_tank_", "targetname", 5, 7, "_shoot_at_1" );
	
	t72s[ 5 ] delayThread( 1.0, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 5 ] );
	t72s[ 6 ] delayThread( 1.25, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 6 ] );
	t72s[ 7 ] delayThread( 1.5, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 7 ] );
	
	shoot_ats = get_ent_array_with_prefix_suffix_range_1_to_1( "chase_enemy_tank_", "targetname", 5, 7, "_shoot_at_2" );
	
	t72s[ 5 ] delayThread( 5.0, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 5 ] );
	t72s[ 6 ] delayThread( 5.25, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 6 ] );
	t72s[ 7 ] delayThread( 5.5, ::enemy_t72_randomly_shoot_canon_fake, shoot_ats[ 7 ] );
	*/
}

chase_mi17s()
{
	mi17_spawner = GetEnt( "chase_mi17", "targetname" );
	Assert( IsDefined( mi17_spawner ) );
	mi17_spawner add_spawn_function( ::enemy_mi17_init, "chase_mi17", "script_noteworthy" );
	mi17_spawner add_spawn_function( ::monitor_vehicle_mission_fail_points );
	mi17_spawner add_spawn_function( ::vehicle_enemy_kill_dialogue_monitor, "mi17" );
	
	spots = getstructarray_delete( "chase_mi17", "targetname" );
	
	pilot_spawner = GetEnt( "chase_mi17_pilot", "targetname" );
	Assert( IsDefined( pilot_spawner ) );
	
	passenger_spawner = GetEnt( "chase_mi17_enemy", "targetname" );
	Assert( IsDefined( passenger_spawner ) );

	sets = [ "1", "2", "3" ];
	set_delays = [ 7.0, 0.05, 0.05 ];
	
	foreach ( i, set in sets )
	{
		index = 1;
		spot_found = false;
		
		while ( !spot_found )
		{
			foreach ( spot in spots )
			{
				if ( spot compare_value( "script_parameters", set ) && !within_fov_of_players( spot.origin, cos( GetDvarFloat( "cg_fov" ) ) ) )
				{
					index = ter_op( IsDefined( spot.script_index ), spot.script_index, index );
					spot_found = true;
					break;
				}
			}
			wait 0.05;
		}
		
		j = 0;
		delay = 2.0;
				
		foreach ( spot in spots )
		{
			if ( spot compare_value( "script_parameters", set ) && spot compare_value( "script_index", index ) )
			{
				mi17_spawner.count = 1;
				mi17_spawner.angles = spot get_key( "angles" );
				mi17_spawner.origin = spot.origin;
				mi17_spawner.target = spot.target;
			
				mi17 = mi17_spawner spawn_vehicle();
				
				wait 0.05;
				
				// Fix for letting Veteran players be aware of other targets they can kill
				if ( level.gameSkill == 3 )
				{
					delayThread( 6.0, vehicle_scripts\_ac130::hud_add_targets, [ mi17 ] );
					delayThread( 32.0, vehicle_scripts\_ac130::hud_remove_targets, [ mi17 ] );
				}
				
				mi17 thread chase_enemy_flag_count_decrement_on_notify( "LISTEN_killed_by_player", "FLAG_chase_encounter_1_complete" );
			    mi17 thread enemy_mi17_load_pilot_alt( pilot_spawner );
			    mi17 thread enemy_mi17_quick_load_passengers_alt( passenger_spawner, 1 );
			    mi17 enemy_mi17_set_passenger_callbacks_on_unload( [ ::chase_mi17_enemy_management ] );
			    mi17 thread enemy_mi17_drop_off();
			    j++;
				wait j * delay;
			}
		}
		wait set_delays[ i ];
	}
	
	flag_wait( "FLAG_chase_end_chase" );
	
	mi17_spawner Delete();
	pilot_spawner Delete();
	passenger_spawner Delete();
}

chase_mi17_enemy_management()
{
	self endon( "death" );
	
	//delayThread( 3.0, vehicle_scripts\_ac130::hud_add_targets, [ self ] );
	flag_wait( "FLAG_chase_end_chase" );
	self DoDamage( 10000, self.origin );
}

chase_clean_up()
{
	structs = [];
	structs = array_combine( structs, getstructarray( "city_area_ma_enemy_1", "targetname" ) );
	structs = array_combine( structs, getstructarray( "city_area_ma_enemy_2", "targetname" ) );
	structs = array_combine( structs, getstructarray( "city_area_ma_enemy_3", "targetname" ) );
	structs = array_combine( structs, getstructarray( "city_area_ma_enemy_4", "targetname" ) );
	structs = array_combine( structs, getstructarray( "city_area_pfr_enemy_1", "targetname" ) );

	thread deletestructarray_ref( structs, 0.2 );
}

chase_catch_up_clean_up()
{
	ents = [];
	ents = add_to_array( ents, GetEnt( "city_area_pfr_enemy_1", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "chase_pfr_t72", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "chase_pfr_mi17", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "chase_pfr_mi17_pilot", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "chase_pfr_mi17_enemy", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "chase_rpg_enemy", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "chase_gaz", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "chase_gaz_enemy", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "chase_bm21", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "chase_bm21_enemy", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "chase_hind", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "chase_hind_pilot", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "chase_enemy_hind_look_at", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "chase_t72", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "chase_enemy_tank_look_at_1", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "chase_mi17", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "chase_mi17_pilot", "targetname" ) );
	ents = add_to_array( ents, GetEnt( "chase_mi17_enemy", "targetname" ) );
	
	foreach ( ent in ents )
	{
		if ( IsDefined( ent ) )
		{
			ent notify( "death" );
			ent Delete();
		}
	}	
	chase_delete_structs();
}

chase_delete_structs()
{
	structs =[];
	structs = add_to_array( structs, getstruct( "courtyard_building_exit", "targetname" ) );
	structs = add_to_array( structs, getstruct( "chase_pfr_signal_ac130", "targetname" ) );
	structs = add_to_array( structs, getstruct( "city_area_pfr_frost_cover_point", "targetname" ) );
	structs = array_combine( structs, get_connected_ents( "chase_pfr_enemy_spot" ) );
	structs = array_combine( structs, getstructarray( "chase_pfr_t72", "targetname" ) );
	structs = array_combine( structs, getstructarray( "chase_pfr_mi17", "targetname" ) );
	structs = array_combine( structs, getstructarray( "chase_rpg_enemy", "targetname" ) );
	structs = array_combine( structs, getstructarray( "chase_vehicle", "targetname" ) );
	structs = array_combine( structs, getstructarray( "chase_hind", "targetname" ) );
	structs = array_combine( structs, getstructarray( "chase_enemy_hind_rocket_point", "targetname" ) );
	structs = array_combine( structs, get_ent_array_with_prefix_1_to_1( "chase_enemy_hind_1_rocket_point_", "targetname", 1 ) );
	structs = array_combine( structs, get_ent_array_with_prefix_1_to_1( "chase_enemy_hind_2_rocket_point_", "targetname", 1 ) );
	structs = array_combine( structs, getstructarray( "chase_t72", "targetname" ) );
	structs = array_combine( structs, getstructarray( "chase_t72", "targetname" ) );
	structs = array_combine( structs, getstructarray( "chase_mi17", "targetname" ) );
		
	thread deletestructarray_ref( structs, 0.2 );
}

catch_up_bridge()
{
	wait 0.05;
	
	flag_set( "FLAG_chase_end_chase" );

	Objective_Add( obj( "OBJ_CHASE_Escort" ), "current", &"PARIS_AC130_OBJ_CHASE_ESCORT_KILO_1_1" );
	
	// Clean up Enemies
	
	wait 1.0;
	
	flag_set( "FLAG_chase_started" );
	
	ais = GetAIArray( "axis" );
	ais  = array_combine( ais, GetAIArray( "team3" ) );
	
	foreach ( ai in ais )
		safe_delete( ai );
	
	// Setup AC130 Vehicle
	
	transition_node = GetVehicleNode( "chase_end_transition_out", "script_noteworthy" );
	level.ac130_vehicle switch_vehicle_path( transition_node );
	wait 0.05;
	
	// Main Vehicle
	
	main_vehicle_spawner = GetEnt( "chase_main_vehicle", "targetname" );
	Assert( IsDefined( main_vehicle_spawner ) );
	main_vehicle_spawner add_spawn_function( ::friendly_hummer_init, "chase_main_vehicle", "targetname" );
	level.chase_main_vehicle = main_vehicle_spawner spawn_vehicle();
	Assert( IsDefined( level.chase_main_vehicle ) );
	
	friendly_spawners = GetEntArray( "delta_group_1", "targetname" );
	Assert( IsDefined( friendly_spawners ) );
	array_spawn_function( friendly_spawners, ::ai_friendly_hummer_init );
	friendlies = [];
	
	foreach ( spawner in friendly_spawners )
		friendlies[ friendlies.size ] = spawner StalingradSpawn();
	wait 0.05;
	level.chase_main_vehicle friendly_hummer_teleport_and_load( friendlies );
	
	// Second Vehicle
	
	second_vehicle_spawner = GetEnt( "chase_second_vehicle", "targetname" );
	Assert( IsDefined( second_vehicle_spawner ) );
	second_vehicle_spawner add_spawn_function( ::friendly_hummer_init, "chase_second_vehicle", "targetname" );
	level.chase_second_vehicle = second_vehicle_spawner spawn_vehicle();
	Assert( IsDefined( level.chase_second_vehicle ) );
	
	friendly_spawners = GetEntArray( "delta_group_2", "targetname" );
	Assert( IsDefined( friendly_spawners ) );
	array_spawn_function( friendly_spawners, ::ai_friendly_hummer_init );
	friendlies = [];
	
	foreach ( spawner in friendly_spawners )
		friendlies[ friendlies.size ] = spawner StalingradSpawn();
	wait 0.05;
	level.chase_second_vehicle friendly_hummer_teleport_and_load( friendlies );
	
	wait 5.0;
	
	// Load Delta

	// - Set delta + makarov back to default values
	
	level.frost clear_parent_ai();
	level.makarov_number_2 clear_child_ai();
	
	group = level.delta;
    group[ group.size ] = level.makarov_number_2;
    
    foreach ( guy in group )
    {
    	guy notify( "LISTEN_end_ai_scripts" );
    	
    	guy.accuracy = friendlies[ 0 ].accuracy;
		guy.baseaccuracy = friendlies[ 0 ].baseaccuracy;
		guy.health = friendlies[ 0 ].health;
		guy.enemy_damage_recieved = undefined;
		guy set_goal_radius( friendlies[ 0 ].goalradius );
		
		guy.ignoreme = true;
		guy.ignoreall = true;
    }
	
	_flag = "FLAG_chase_delta_entered_chase_vehicles";
	thread waittill_ents_notified_set_flag( group, "enteredvehicle", _flag );
	
	// ( other guy ) + Volk in "Main Chase Vehicle"
	
	main_group = [ level.gator, level.bishop, level.makarov_number_2 ];
	node = GetVehicleNode( "chase_second_vehicle_pickup_out", "script_noteworthy" );
	level.chase_main_vehicle Vehicle_Teleport( node.origin, node.angles );
	level.chase_main_vehicle friendly_hummer_teleport_and_load( main_group );
	
	// Sandman + Hitman in "Second Chase Vehicle"
	
	second_group = [ level.sandman, level.frost, level.hitman ];
	node = GetVehicleNode( "chase_main_vehicle_pickup_out", "script_noteworthy" );
	level.chase_second_vehicle Vehicle_Teleport( node.origin, node.angles );
	level.chase_second_vehicle friendly_hummer_teleport_and_load( second_group );
	
	// Start Main Vehicle
	
	transition_node = GetVehicleNode( "chase_end_main_vehicle_transition_out", "script_noteworthy" );
	level.chase_main_vehicle switch_vehicle_path( transition_node );
	level.chase_main_vehicle friendly_hummer_set_default();
	
	// Start Second Vehicle
	
	transition_node = GetVehicleNode( "chase_end_second_vehicle_transition_out", "script_noteworthy" );
	level.chase_second_vehicle switch_vehicle_path( transition_node );
	level.chase_second_vehicle friendly_hummer_set_default();
	
	focus = GetEnt( "chase_player_focus", "targetname" );
	//no need for an assert here thank you
	if( isDefined(focus) )
	{
		new_focus = GetEnt( "bridge_player_focus", "targetname" );
		if(isDefined(new_focus))
		{
			focus.origin = new_focus.origin;
			vehicle_scripts\_ac130::ac130_set_view_arc( 0, 0.05, 0.05, 65, 65, 25, 55 );
		}
	}		
}

start_bridge()
{
	Objective_State( obj( "OBJ_CHASE_Escort" ), "done" );
	
	level.chase_main_vehicle notify( "LISTEN_end_hummer_mission_failed" );
	level.chase_second_vehicle notify( "LISTEN_end_hummer_mission_failed" );
	
	level.chase_main_vehicle friendly_hummer_set_default();
	level.chase_second_vehicle friendly_hummer_set_default();
	
	flag_clear( "FLAG_ac130_context_sensitive_dialog_filler" );
	flag_clear( "FLAG_ac130_context_sensitive_dialog_kill" );
	flag_clear( "FLAG_ac130_context_sensitive_dialog_guy_pain" );
	flag_clear( "FLAG_ambient_ac130_effects" );
	flag_clear( "FLAG_delta_ac130_mission_fail" );
	flag_set( "FLAG_end_ambient_ac130_effects" );
	delayThread( 13.0, ::flag_set, "FLAG_chase_encounter_2_check" );
	delayThread( 13.5, vehicle_scripts\_ac130::autosave_ac130 );
	
	level notify( "LISTEN_end_monitor_interact_button" );
	
	/*
	focus = GetEnt( "chase_player_focus", "targetname" );
	Assert( IsDefined( focus ) );
	new_focus = GetEnt( "bridge_player_focus", "targetname" );
	Assert( IsDefined( new_focus ) );
	
	focus MoveTo( new_focus.origin, 5.0, 2.5, 2.5 );
	*/
	
	thread setup_slamzoom();
	flag_wait( "bridge_tanks_spawned" );
	thread set_saved_dvar_over_time( "sm_sunsamplesizenear", 1.0, 1.0 );
	flag_wait( "player_shot_tank" );
	bridge_minimap();
}

bridge_minimap()
{	
	maps\_compass::setupMiniMap( "compass_map_paris_ac130_bridge", "bridge_minimap_corner" );
	
	SetSavedDvar( "ui_hideMap", "0" );
}


bridge_delete_structs()
{
}
