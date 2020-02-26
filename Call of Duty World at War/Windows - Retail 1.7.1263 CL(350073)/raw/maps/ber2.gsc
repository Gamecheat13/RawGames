//
// file: ber2.gsc
// description: main level script for berlin2
// scripter: slayback
//

#include maps\_utility;
#include common_scripts\utility;
#include maps\ber2_util;

main()
{
	// check if it's a demo
	level.isDemo = IsCoopEPD();
	
	level thread onPlayerConnect();
	
	setdvar("r_watersim_enabled","0");
	maps\ber2_fx::main();

	maps\_t34::main( "vehicle_rus_tracked_t34_wet", "t34_wet" );
	maps\_katyusha::main( "vehicle_rus_wheeled_bm13_dist", "katyusha" );
		
	maps\_destructible_opel_blitz::init();
		
	maps\ber2_util::setup_eventname_triggers();
	
	build_starts();
	init_flags();
	precache_assets();
	
	setup_friendlies();
	setup_drones();
	
	level thread maps\_pipes::main();

	maps\_load::main();  // COD magic
		
	level thread coop_optimize();
		
	level.default_goalradius = 768;
		
	trigger_setup();
	
	maps\ber2_anim::ber2_anim_init();
	level thread maps\ber2_amb::main();
		
	setup_threatbiases();
	setup_strings();
	
	setup_spawn_functions();
	
	level thread undead_ai_cleanup();
	
	// this coop warp trigger gets re-enabled later when the metrogate execution scene starts
	disable_trigger_with_noteworthy( "trig_coop_warp_metrogate_execution" );
	
	/#
	doDebug = GetDvarInt( "debug_ai" );
	if( IsDefined( doDebug ) && doDebug > 0 )
	{
		level thread debug_ai();
	}
	#/
	
	/#
	doDebug = GetDvarInt( "debug_bldg_collapse" );
	if( IsDefined( doDebug ) && doDebug > 0 )
	{
		level thread maps\ber2_event1::building_collapse_debug();
	}
	#/
}

// setup the start functions for the level start system
build_starts()
{
	// apartment starts
	add_start( "event1", maps\ber2_event1::event1_start, &"STARTS_BER2_EVENT1" );
	add_start( "e1_start_action", maps\ber2_event1::event1_start_action, &"STARTS_BER2_EVENT1_ACTION" );
	add_start( "apt2", maps\ber2_event1::event1_start_apt2, &"STARTS_BER2_APT2" );
	add_start( "atrium", maps\ber2_event1::event1_start_atrium, &"STARTS_BER2_ATRIUM" );
	add_start( "loadingdock", maps\ber2_event1::event1_start_loadingdock, &"STARTS_BER2_LOADINGDOCK" );
	
	// street starts
	add_start( "e1_outside", maps\ber2_event1::event1_start_outside, &"STARTS_BER2_OUTSIDE" );
	add_start( "street_regroup", maps\ber2_event1::event1_start_street_regroup, &"STARTS_BER2_STREET_REGROUP" );
		
	// metro starts
	add_start( "event2", maps\ber2_event2::event2_start, &"STARTS_BER2_EVENT2" );
	add_start( "metrowave", maps\ber2_event2::event2_start_metrowave, &"STARTS_BER2_EVENT2_METROWAVE" );
	
	// default start
	default_start( level.start_functions[ "event1" ] );
	
	// turn off the introscreen if necessary
	/#
	start = tolower( GetDvar( "start" ) );
	if( IsDefined( start ) && start != "" && start != "default" && start != "event1" && !IsSubStr( start, "**" ) )
	{
		SetDvar( "introscreen", "0" );  // disable the introscreen
	}
	#/
}

init_flags()
{
	flag_init( "friends_setup" );
	
	flag_init( "event1_fakefire_start" );
	flag_init( "street_fakefire_start" );
	
	flag_init( "intro_execution_done" );
	flag_init( "intro_execution_friendlies_moveup" );
	flag_init( "intro_execution_dialogue_done" );
	
	flag_init( "fallingsign_dialogue_done" );
	
	flag_init( "aisneak_dialogue_thread_started" );
	flag_init( "aisneak_sarge_firstdialogue_done" );
	flag_init( "aisneak_mapreaders_dead" );
	flag_init( "aisneak_riflemen_dead" );
	flag_init( "aisneak_telegrapher_dead" );
	
	flag_init( "execution_interrupted" );
	flag_init( "execution_done" );
	
	flag_init( "atrium_mger_alerted" );
	
	flag_init( "player_outside" );
	flag_init( "tank2_dead" );
	flag_init( "street_charge_friendlies_pared_down" );
	
	flag_init( "ground_mg_hit1" );
	flag_init( "building_hit1" );
	flag_init( "building_critical_hit" );
	flag_init( "building_collapse_fallout_done" );
	flag_init( "building_collapsed" );
	
	flag_init( "e1_street_executions_done" );
	flag_init( "metrogate_reach_done" );
	flag_init( "metrogate_execution_player_close" );
	flag_init( "metrogate_executions_done" );
	
	flag_init( "subway_gate_closed" );
	
	flag_init( "lights_back_on" );
	
	flag_init( "wave_sequence_started" );
	flag_init( "wave_near_players" );
	flag_init( "metrowave_blackout" );
}

precache_assets()
{
	PrecacheModel( "tag_origin" );
	PrecacheModel( "tag_origin_animate" );
	PrecacheModel( "katyusha_rocket" );
	PrecacheModel( "sewer_rat" );
	PrecacheModel( "weapon_rus_molotov_grenade" );
	PrecacheModel( "weapon_rus_zippo" );
	PrecacheModel( "berlin_wood_beam_short" );
	
	PrecacheItem( "panzerschrek" );
	
	PrecacheRumble( "explosion_generic" );
	PrecacheRumble( "explosion_generic_no_broadcast" );
	PrecacheRumble( "ber2_generic_light" );
	PrecacheRumble( "ber2_generic_heavy" );
	
	// for the EPD demo
	//PrecacheShader( "ber2_epd_end_slate" );
	PrecacheShader( "ber2_epd_coming_soon" );
}

setup_strings()
{
	level.obj_clear_bldgs = &"BER2_OBJ_CLEAR_BLDGS";
	level.obj_move_thru_street = &"BER2_OBJ_MOVE_THRU_STREET";
	level.obj_stay_with_tank = &"BER2_OBJ_STAY_WITH_TANK";
	level.obj_execute = &"BER2_OBJ_EXECUTE";
	level.obj_regroup = &"BER2_OBJ_REGROUP";
	level.obj_get_to_metro = &"BER2_OBJ_GET_TO_METRO";
	level.obj_fight_thru_metro = &"BER2_OBJ_FIGHT_THRU_METRO";
	level.obj_defend_sarge = &"BER2_OBJ_DEFEND_SARGE";
}

set_objective( num, origin )
{
	if( num == 0 )
	{
		objective_add( 0, "active", level.obj_clear_bldgs, ( 4112, -800, 0 ) );
		objective_current( 0 );
	}
	else if( num == 1 )
	{
		objective_state( 0, "done" );
		objective_add( 1, "active", level.obj_move_thru_street, ( 752, -32, -100 ) );
		objective_current( 1 );
	}
	else if( num == 2 )
	{
		objective_state( 1, "done" );
		objective_add( 2, "active", level.obj_stay_with_tank, ( 1616, -32, -100 ) );
		objective_current( 2 );
	}
	else if( num == 3 )
	{
		objective_state( 2, "done" );
		Objective_Delete( 2 );
		objective_add( 3, "active", level.obj_execute, ( 642, 88, -100 ) );
		objective_current( 3 );
	}
	/* removed objective 4
	else if( num == 4 )
	{
		objective_state( 3, "done" );
		Objective_Delete( 3 );
		objective_add( 4, "active", level.obj_regroup, ( 700, 788, -100 ) );
		objective_current( 4 );
	}*/
	else if( num == 5 )
	{
		//objective_state( 4, "done" );  // removed objective 4
		objective_state( 3, "done" );
		Objective_Delete( 3 );
		objective_add( 5, "active", level.obj_get_to_metro, ( 1072, 368, -244 ) );
		objective_current( 5 );
	}
	else if( num == 6 )
	{
		objective_state( 5, "done" );
		Objective_Delete( 5 );
		objective_add( 6, "active", level.obj_fight_thru_metro, ( -2824, 3088, -532 ) );
		objective_current( 6 );
	}
	else if( num == 7 )
	{
		objective_state( 6, "done" );
		objective_add( 7, "active", level.obj_regroup, ( -3400, 3632, -562 ) );
		objective_current( 7 );
	}
	else if( num == 8 )
	{
		objective_state( 7, "done" );
		Objective_Delete( 7 );
		objective_add( 8, "active", level.obj_defend_sarge, ( -3400, 3632, -562 ) );
		objective_current( 8 );
	}
	
	wait_network_frame();
}

// skips past objectives that should have already happened (for skiptos)
objectives_skip( numToSkipPast )
{
	for( i = 0; i <= numToSkipPast; i++ )
	{
		set_objective( i );
	}
}

onPlayerConnect()
{
	for( ;; )
	{
		level waittill( "connecting", player ); 

		//player thread onPlayerDisconnect(); 
		//player thread onPlayerSpawned(); 
		//player thread onPlayerKilled(); 
	
		if( flag( "event1_fakefire_start" ) )
		{
			maps\_utility::setClientSysState("levelNotify", "e1fs", player );
		}
		
		if( flag( "street_fakefire_start" ) )
		{
			maps\_utility::setClientSysState("levelNotify", "sfs", player );
		}
	}
}

warp_players_underworld()
{
	// get the spot under the world for temp placement
	underworld = GetStruct( "struct_player_teleport_underworld", "targetname" );
	if( !IsDefined( underworld ) )
	{
		ASSERTMSG( "warp_players_underworld(): can't find the underworld warp spot! aborting." );
		return;
	}
	
	players = get_players();

	for( i = 0; i < players.size; i++ )
	{
		players[i] SetOrigin( underworld.origin );
	}
}


// warp players to a given set of points
warp_players( startValue, startKey )
{
	// get start points
	starts = GetStructArray( startValue, startKey );
	
	ASSERTEX( starts.size == 4, "warp_players(): there aren't 4 player start spots!" );
	
	// prioritize special start points for singleplayer
	spStart = undefined;
	for( i = 0; i < starts.size; i++ )
	{
		if( IsDefined( starts[i].script_noteworthy ) && starts[i].script_noteworthy == "1p_start" )
		{
			spStart = starts[i];
		}
	}
	
	if( IsDefined( spStart ) )
	{
		// sort the remaining starts into another array
		oldStarts = array_remove( starts, spStart );
		
		// clear starts
		starts = [];
		
		// set the special start as the first one in the array
		starts[0] = spStart;
		
		// repopulate with the rest of the starts
		for( i = 0; i < oldStarts.size; i++ )
		{
			starts[starts.size] = oldStarts[i];
		}
	}
	
	players = get_players();

	for( i = 0; i < players.size; i++ )
	{
		// Set the players' origin to each start point
		players[i] setOrigin( starts[i].origin );
	
		// Set the players' angles to face the right way.
		players[i] setPlayerAngles( starts[i].angles );
	}
	
	set_breadcrumbs(starts);
}

// warp player to a given set of points
warp_player( startValue, startKey )
{
	// get start points
	starts = GetEntArray( startValue, startKey );
	ASSERT( starts.size == 4 );
	
	players = get_players();
	index = players.size; 

	// figure out what start index this player should be at
	for( i = 0; i < players.size; i++ )
	{
		if ( players[i] == self )
		{
			index = i;
		}
	}
	
	ASSERT( index < 4 );
	
	// Set the players' origin to each start point
	self setOrigin( starts[index].origin );
	
	// Set the players' angles to face the right way.
	self setPlayerAngles( starts[index].angles );
}

setup_friendlies()
{
	level.friendly_startup_thread = ::ber2_friendly_startup_thread;
	
	level.friends = grab_starting_friends();	
	ASSERTEX( IsDefined( level.friends ) && level.friends.size > 0, "setup_friendlies(): can't find any friendlies!" );
	
	for( i = 0; i < level.friends.size; i++ )
	{
		guy = level.friends[i];
		
		guy.followmin = -1;
		guy thread friend_remove_on_death();
		
		if( IsDefined( guy.script_noteworthy ) )
		{
			// Sgt. Zeitzev
			if( guy.script_noteworthy == "sarge" )
			{
				level.sarge = guy;
			}
			// Pvt. Chernov
			else if( guy.script_noteworthy == "hero1" )
			{
				level.hero1 = guy;
			}
			
			// guys with script_noteworthy set are heroes and need a bullet shield
			guy thread magic_bullet_shield();
		}
	}
	
	ASSERTEX( is_active_ai( level.sarge ), "setup_friendlies(): couldn't assign level.sarge." );
	ASSERTEX( is_active_ai( level.hero1 ), "setup_friendlies(): couldn't assign level.hero1." );
	
	flag_set( "friends_setup" );
}

// used to get _colors reinforcements set up properly
ber2_friendly_startup_thread()
{
	// make sure it's replacing a player squad guy
	if( self check_force_color( "b" ) || self check_force_color( "p" ) )
	{
		// add to level.friends
		self friend_add();
	}
}

// warp friendlies to a given set of points
warp_friendlies( startValue, startKey )
{
	ASSERTEX( flag( "friends_setup" ), "warp_friendlies(): level.friends needs to be set up before this runs." );
	
	// get start points
	friendlyStarts = GetStructArray( startValue, startKey );

	ASSERTEX( friendlyStarts.size >= 4, "warp_friendlies(): didn't find 4 or more friendly start points!" );

	for( i = 0; i < level.friends.size; i++ )
	{
		level.friends[i] Teleport( groundpos( friendlyStarts[i].origin ), friendlyStarts[i].angles );
	}
}

setup_drones()
{
	// these character model names may change as art makes new variants
	character\char_ger_wrmchtwet_k98::precache();
	character\char_rus_wet_r_rifle::precache();
		
	level.drone_spawnFunction["axis"] = character\char_ger_wrmchtwet_k98::main;
	level.drone_spawnFunction["allies"] = character\char_rus_wet_r_rifle::main; 
		
	// Call this before maps\_load::main(); to allow drone usage.
	maps\_drones::init();	
}	

// TEMP for testing
drawline_from_player( ent )
{
	self endon( "kill_lines" );
	ent endon( "death" );

	color = ( 0, 255, 0 );

	while( 1 )
	{
		if( IsDefined( ent ) )
		{
			player = get_players()[0];
			line( player.origin, ent.origin, color );
			wait( 0.05 );
		}
		else
		{
			break;
		}
	}
}

setup_threatbiases()
{
	// create threat bias groups
	CreateThreatBiasGroup( "players" );
	CreateThreatBiasGroup( "friends" );
	CreateThreatBiasGroup( "allies" );
	CreateThreatBiasGroup( "non_combat" );
	CreateThreatBiasGroup( "fight" );
	
	CreateThreatBiasGroup( "street_groundlevel_germans" );
	CreateThreatBiasGroup( "street_groundlevel_russians" );
	
	players = get_players();
	
	for( i = 0; i < players.size; i++ )
	{
		players[i] SetThreatBiasGroup( "players" );
	}
}

// makes the level friendlier for network traffic
coop_optimize()
{
	flag_wait( "all_players_connected" );
	
	level.coopOptimize = false;
	
	players = get_players();
	if( players.size > 1 )
	{
		level.coopOptimize = true;
	}
	
	override = GetDvarInt( "enable_coop_optimize" );
	if( IsDefined( override ) && override > 0 )
	{
		level.coopOptimize = true;
	}
	
	if( !level.coopOptimize )
	{
		return;
	}
	
	// upper-story drones for street battle
	ents[0] = getent_safe( "buildingdrones_allies", "target" );
	ents[1] = getent_safe( "buildingdrones_axis", "target" );
	delete_group( ents );
	
	// remove level.friends redshirt(s)
	// - redshirts are only reduced until heading into the subway,
	//   at which point more redshirts get added to the array
	flag_wait( "friends_setup" );
	
	redshirts = [];
	for( i = 0; i < level.friends.size; i++ )
	{
		if( level.friends[i] != level.sarge && level.friends[i] != level.hero1 )
		{
			redshirts[redshirts.size] = level.friends[i];
		}
	}
	array_thread( redshirts, ::coop_optimize_remove_redshirt );
	
	// TEMP NASTINESS TO REMOVE DRONES DUE TO UNRESOLVED T-POSE ISSUE - DSL
	
/*	drones = getentarray("drone_axis", "targetname");
	
	println("Removing " + drones.size + " axis drone triggers");
	
	for(i = 0; i < drones.size; i++)
	{
		drones[i] delete();
	}	

	drones = getentarray("drone_allies", "targetname");
	println("Removing " + drones.size + " ally drone triggers");
	
	for(i = 0; i < drones.size; i++)
	{
		drones[i] delete();
	}		*/
}

coop_optimize_remove_redshirt()
{
	self clear_force_color();
	self disable_replace_on_death();
	self friend_remove();
	self Delete();
}

// --- UNDEAD CLEANUP ---
undead_ai_cleanup()
{
	thread kill_aigroup_at_trigger( "trig_script_color_allies_b9", "targetname", "aigroup_sneakyaction_guys" );
	thread kill_aigroup_at_trigger( "trig_script_color_allies_b9", "targetname", "aigroup_apt1_staircase" );
	
	thread kill_aigroup_at_trigger( "trig_script_color_allies_b13", "targetname", "aigroup_apt2_executionGuys" );
	thread kill_aigroup_at_trigger( "trig_script_color_allies_b13", "targetname", "aigroup_apt2_enemies" );
	
	thread kill_aigroup_at_trigger( "trig_loadingdock_line1_spawn", "script_noteworthy", "aigroup_atrium_enemies", 5 );
	
	thread kill_aigroup_at_flag( "building_mgs_start", "ai_loadingdock_shadowrunners" );
	thread kill_aigroup_at_flag( "building_mgs_start", "ai_loadingdock_germans" );
	thread kill_aigroup_at_flag( "building_mgs_start", "ai_loadingdock_generic_enemies" );
	
	thread kill_aigroup_at_trigger( "trigger_objective1_reached", "targetname", "ai_outside_germans" );
	
	thread kill_aigroup_at_trigger( "trig_subway_exitGateArea", "targetname", "aigroup_subway_enemies_1" );
	thread kill_aigroup_at_trigger( "trig_subway_exitGateArea", "targetname", "aigroup_subway_enemies_2" );
	thread kill_aigroup_at_trigger( "trig_subway_exitGateArea", "targetname", "ai_metro_mger_left" );
	thread kill_aigroup_at_trigger( "trig_subway_exitGateArea", "targetname", "ai_metro_mger_right" );
}
// --- END UNDEAD CLEANUP ---

// --- CUSTOM SPAWN FUNCTION SETUP ---
//does add_spawn_function on all the spawners that need custom behavior.
setup_spawn_functions()
{
	// ambient roof runners
	group_add_spawn_function( "spawner_roof_ambientrunner", maps\ber2_event1::roof_ambient_runner );
	
	// ignore til goal guys
	ignoreTilPathEnders = GetEntArray( "ignore_til_path_end", "script_noteworthy" );
	array_thread( ignoreTilPathEnders, ::add_spawn_function, maps\ber2_util::ignore_til_path_end );
	
	// magic bullet shield
	bulletShielders = GetEntArray( "magic_bullet_shield", "script_noteworthy" );
	array_thread( bulletShielders, ::add_spawn_function, maps\ber2_util::magic_bullet_shield_safe );
	
	// street redshirts who execute enemies on street
	street_executioners = GetEntArray( "spawner_outside_russian_1", "targetname" );
	array_thread( street_executioners, ::add_spawn_function, ::magic_bullet_shield );
	
	balcony_mgSpawner = getent_safe( "spawner_balcony_mg", "script_noteworthy" );
	balcony_mgSpawner add_spawn_function( maps\ber2_event1::event1_balcony_mger );
		
	// atrium MGer
	atrium_mgSpawner = getent_safe( "spawner_atrium_mger", "script_noteworthy", "atrium MG spawner" );
	atrium_mgSpawner add_spawn_function( maps\ber2_event1::event1_atrium_mger );
	
	// loadingdock: shadowrunners
	group_add_spawn_function( "spawner_loadingdock_shadowrunner", maps\ber2_util::ignore_til_path_end_or_dmg );
	
	// loadingdock: patrollers	
	group_add_spawn_function( "spawner_loadingdock_patroller", maps\ber2_event1::event1_loadingdock_patroller );
		
	// subway tunnel wave runners
	group_add_spawn_function( "spawner_subway_exitRunners", maps\ber2_event2::metrowave_runner_spawnfunc );
}

// collects spawners by targetname and does add_spawn_function() on them
group_add_spawn_function( groupTN, spawnFunc, param1, param2, param3 )
{
	group = GetEntArray( groupTN, "targetname" );
	ASSERTEX( IsDefined( group ) && group.size > 0, "Couldn't find group with targetname of '" + groupTN + "'." );
	
	for( i = 0; i < group.size; i++ )
	{
		group[i] add_spawn_function( spawnFunc, param1, param2, param3 );
	}
}
// --- END CUSTOM SPAWN FUNCTION SETUP ---
