#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;
#include maps\so_stealth_prague_code;

main()
{
	spec_ops_map_prep();

	template_so_level( "prague" );
	level.loadout = "so_stealth_prague";
	
	// Precache

	//^3[{+usereload}]^7 Come with me.
	precachestring( &"SO_STEALTH_PRAGUE_OBJ_1" );
	PreCacheString( &"SO_STEALTH_PRAGUE_COLLECT_CIVILIAN" );
	PreCacheString( &"SO_STEALTH_PRAGUE_UI_KILLS_STEALTH" );
	PreCacheString( &"SO_STEALTH_PRAGUE_UI_CIVS_RESCUED" );
	PreCacheString( &"SO_STEALTH_PRAGUE_UI_HEAD_SHOTS" );
	
	PrecacheModel( "com_flashlight_on" );
	PrecacheModel( "com_flashlight_off" );
	
	PrecacheShader( "compass_map_prague_streets" );
	PrecacheShader( "compass_map_prague_church" );
	
	// Start functions
	default_start( ::start_church );
	add_start( "start_church",		::start_church );
	add_start( "start_alley",		::start_alley );
	add_start( "start_yard",		::start_yard );
	add_start( "start_apartment",	::start_apartment );
	add_start( "start_quad",		::start_quad );
	
	maps\so_stealth_prague_precache::main();
	maps\so_stealth_prague_anim::main();
	maps\_patrol_anims::main();
	maps\so_stealth_prague_fx::main();
	maps\createfx\so_stealth_prague_fx::main();
	maps\createart\so_stealth_prague_art::main();
	
	maps\_load::set_player_viewhand_model( "viewhands_player_sas" );
	maps\_load::main();
	
	init_mission_flags();
	
	setup_stealth();
	setup_idles();
	setup_weather();
	setup_gameplay();
}

// -.-.-.-.-.-.-.-.-.-.-.-. Clean Up -.-.-.-.-.-.-.-.-.-.-.-. //

spec_ops_map_prep()
{
	// Delete uneeded entities from prague
	entity_clean_up();
	
	// Open doors previously opened by Soap
	open_doors();
	
	// Adjust any dyanimc lights left over from sp
	adjust_lights();
}
	
entity_clean_up()
{
	so_make_specialops_ent( "trigger_multiple_visionset", "classname", true );
	so_make_specialops_ent( "trigger_multiple_ambient", "classname", true );
	
	so_delete_all_triggers();
	so_delete_all_spawners();
	so_delete_all_by_type( ::type_goalvolume, ::type_infovolume, ::type_weapon_placed, ::type_turret );
	
	delete_specific_ents();
//	break_window_museum();
	connect_sp_prague_blocked_paths();
	thread disconnect_so_prague_paths();
}

delete_specific_ents()
{
	array_ent_key_values = [];
	array_ent_key_values[ "targetname" ] = 	
								[
									"cargo_flyby",			// Vehicle carried by helicopter
									"alcove_cargo",			// Vehicle carried by helicopter
									"alcove_cargo2",		// Vehicle carried by helicopter
									"alley_cargo",			// Vehicle carried by helicopter
									"alley_cargo_2",		// Vehicle carried by helicopter
									"new_cargo",			// Vehicle carried by helicopter
									"new_cargo2",			// Vehicle carried by helicopter
									"cargo_flyby_two",		// Vehicle carried by helicopter
									"apartment_blocker",	// script brush model after machine gun nest
									"sewer_gate"			// Metal gate in sewers. May want this here but for now delete
								];
	array_ent_key_values[ "script_noteworthy" ] = [];
	
	foreach ( key, array_values in array_ent_key_values )
	{
		foreach( value in array_values )
		{
			ents = GetEntArray( value, key );
			AssertEx( ents.size, "No entity found with key: " + key + " and value: " + value );
			if ( ents.size )
			{
				array_thread( ents, ::_delete );
			}
		}
	}
}

break_window_museum()
{
	// Cannot grab the window entity using the "script_prefab_exploder" string
	// key so grab all entities and find the prague window pieces using
	// the dot operator... bleh
	entities = GetEntArray();
	
	foreach( ent in entities )
	{
		if ( !IsDefined( ent.script_prefab_exploder ) || ent.script_prefab_exploder != "gallery_window" )
			continue;

		if ( IsDefined( ent.targetname ) && ent.targetname == "exploder" )
		{
			// This is the damaged version of the window.
			// Remove targetname so that load scripts do 
			// not hide this
			ent.targetname = "";
		}
		else
		{
			// Delete the pristine version
			ent Delete();
		}
	}
}

open_doors()
{
	// First shop door uses targeting to organize pieces
	door = maps\_util_carlos::link_door_to_clips( "red_house_entrance" );
	thread rotate_door( door, ( 0, 110, 0 ), 0.1 );
	
	// Last door before church uses link to organize pieces
	door = maps\_util_carlos::link_door_to_clips( "white_building_door" );
	thread rotate_door( door, ( 0, 115, 0 ), 0.1 );
	
	// Gate in tunnel after shop
	door_l = get_target_ent( "tunnel_door_left" );
	door_r = get_target_ent( "tunnel_door_right" );
	door_l rotateTo( door_l.angles + ( 0,-90,0 ), 0.05 );
	door_r rotateTo( door_r.angles + ( 0,90,0 ), 0.05 );
	
	// Other two doors are composed of script_models and
	// script_brushmodels of the same name
	door_names =	[
						"red_house_backdoor_l",		// Shop back door left
						"red_house_backdoor_r",		// Shop back door right
						"apartment_gate_r",			// Apartment double door gate that Soap kicks open
						"apartment_gate_l"			// Apartment double door gate that Soap kicks open
//						"corner_bank_door"			// Door in alley after museum
					];
	
	foreach ( name in door_names )
	{
		door_pieces	= GetEntArray( name, "targetname" );
		door		= undefined;
		
		// Grab door part
		foreach ( piece in door_pieces )
		{
			if ( piece.classname == "script_brushmodel" )
			{
				door = piece;
				break;
			}
		}
		
		if ( !IsDefined( door ) )
		{
			AssertMsg( "Failed to set up door of targetname: " + name );
			continue;
		}
		
		// Link knobs to door
		foreach ( piece in door_pieces )
		{
			if ( piece.classname == "script_model" )
			{
				piece LinkTo( door );
			}
		}

		// Give each door a specific rotation according to name
		angle_adjust = undefined;
		switch ( name )
		{
			case "red_house_backdoor_l":
				angle_adjust = ( 0, 90, 0 );
				break;
			case "red_house_backdoor_r":
				angle_adjust = ( 0, 100, 0 );
				break;
			case "apartment_gate_r":
				angle_adjust = ( 0, -100, 0 );
				break;
			case "apartment_gate_l":
				angle_adjust = ( 0, 115, 0 );
				break;
			case "corner_bank_door":
				angle_adjust = ( 0, -95, 0 );
				break;
			default:
				AssertMsg( "Unhandled door name in pick angle switch: " + name );
				angle_adjust = ( 0, 75, 0 );
				break;
		}
		
		thread rotate_door( door, angle_adjust, 0.1 );
	}
}

rotate_door( door, angle_adjust, time )
{
	door RotateTo( door.angles + angle_adjust, time );
	door waittill( "rotatedone" );
	door ConnectPaths();
}

connect_sp_prague_blocked_paths()
{
	array_ent_targetnames =
							[
								"courtyard_btr_blocker",	// BTR drop location in courtyard
								"gallery_exit_blocker",		// Alley blocker
								"bank_blocker"				// Alley and bank door blocker
							];
	
	foreach ( name in array_ent_targetnames )
	{
		ent = GetEnt( name, "targetname" );
		AssertEx( IsDefined( ent ), "Invalid path blocker targetname: " + name  );
		
		if ( IsDefined( ent ) && ent.classname == "script_brushmodel" )
		{
			ent NotSolid();
			ent ConnectPaths();
			ent Delete();
		}
	}
}

disconnect_so_prague_paths()
{
	blockers = GetEntArray( "disconnect_paths", "targetname" );
	
	foreach ( blocker in blockers )
	{
		// All blockers are moved up 1600 units. This is so that
		// code doesn't assert trying to perform too many disconnect
		// path calls on script_brushmodels flagged with dynamicpath.
		// By moving these down after the fact I don't hit this
		// unknown ceiling. Gross but it works. - JC
		blocker.origin += (0,0,-1600);
		blocker DisconnectPaths();
		wait 0.05;
	}
}

adjust_lights()
{
	GetEnt( "btr_primary_light", "targetname" ) SetLightIntensity( 0.0 );
}

// -.-.-.-.-.-.-.-.-.-.-.-. General Gameplay Setup -.-.-.-.-.-.-.-.-.-.-.-. //

init_mission_flags()
{
	// Spec Ops Global Flags
	flag_init( "so_stealth_prague_start" );
	flag_init( "trig_level_success" );
	flag_init( "so_stealth_prague_complete" );
	flag_init( "compass_swap" );
	
	// Weather Flags
	flag_init( "lightning_pause" );
	flag_init( "lightning_now" );
	
	// Radio Flags
	flag_init( "axis_kill_radio_paused" );
	
	// Encounter: Church
	flag_init( "church_enc_setup" );
	flag_init( "church_enc_patrollers_start" );
	flag_init( "church_enc_reached_museum" );
	flag_init( "church_enc_balcony_spotted" );
	flag_init( "church_enc_street_ai_aware" );
	flag_init( "church_enc_street_execution_done" );
	
	// Encounter: Alley
	flag_init( "alley_enc_setup" );
	flag_init( "alley_enc_dog_attack" );
	flag_init( "alley_enc_dog_damaged" );
	flag_init( "alley_enc_dog_spotted_player" );
	flag_init( "alley_enc_ai_alert" );
	flag_init( "alley_enc_civ_killed" );
	flag_init( "alley_enc_civ_shoot" );
	flag_init( "alley_enc_enemy_damaged" );
	
	// Encounter: Yard
	flag_init( "yard_enc_setup" );
	flag_init( "yard_enc_spotted" );
	flag_init( "yard_enc_start_cqp_patrol" );
	flag_init( "yard_enc_player_exited" );
	
	// Encounter: Apartment
	flag_init( "apartment_enc_setup" );
	flag_init( "apartment_enc_first_patrol_start" );
	flag_init( "apartment_enc_flashlight_patrol" );
	flag_init( "apartment_enc_smokers_dead" );
	flag_init( "apartment_enc_flashlight_damaged" );
	flag_init( "apartment_enc_hall_patrol" );
	flag_init( "apartment_enc_exit" );
	
	// Encounter: Quad
	flag_init( "quad_enc_setup" );
	flag_init( "quad_enc_execution" );
	flag_init( "quad_enc_execution_done" );
	
	// Encounter: Shop
	flag_init( "shop_enc_exit_quad" );
	flag_init( "shop_enc_player_over_fence" );
	flag_init( "shop_enc_player_near_end" );
	flag_init( "encounter_shop_clear" );
}

setup_gameplay()
{
	setup_difficulty_settings();
	setup_stat_variables();
	
	// Spec Ops Init
	thread enable_challenge_timer( "so_stealth_prague_start", "so_stealth_prague_complete" );
	thread fade_challenge_in( undefined, false );
	thread fade_challenge_out( "so_stealth_prague_complete", true );
	thread enable_triggered_complete( "trig_level_success", "so_stealth_prague_complete", "all" );
	
	// Listen for rebel team updates and then
	// update the rebels saved counter
	thread on_poi_team_updated();
	
	foreach ( player in level.players )
	{
		player thread maps\_specialops::disable_kill_counter();
		
		player thread maps\_specialops::enable_challenge_counter( 2, &"SO_STEALTH_PRAGUE_UI_KILLS_STEALTH", "ui_stealth_kill_count" );
		player thread maps\_specialops::enable_challenge_counter( 3, &"SO_STEALTH_PRAGUE_UI_CIVS_RESCUED", "ui_rebel_count" );
		player thread maps\_specialops::enable_challenge_counter( 4, &"SO_STEALTH_PRAGUE_UI_HEAD_SHOTS", "ui_head_shot_count" );
		
		
		player thread dialog_on_player_weapon_change();
		player GiveMaxAmmo( player GetCurrentPrimaryWeapon() );
	}
	
	// General AI logic
	add_global_spawn_function( "axis", ::on_spawn_axis );
	add_global_spawn_function( "axis", ::on_death_axis );
	
	thread friendly_fire_think();
	
	// Mini Map
	thread compass_think();
	
	// Custom end of game logic
	level.custom_eog_no_defaults			= true;
	level.eog_summary_callback 				= ::custom_eog_summary;
}

friendly_fire_think()
{
	// In this mission killing too many civilians will fail you
	level.no_friendly_fire_penalty = undefined;
	
	// Wait till friendly fire system notifies
	flag_wait( "friendly_fire_warning" );
	
	radio_dialogue_interupt( "soap_warn_friendly_fire" );
}

compass_think()
{
	level endon( "special_op_terminated" );
	maps\_compass::setupMiniMap( "compass_map_prague_church", "church_minimap_corner" );
	flag_wait( "compass_swap" );	
	maps\_compass::setupMiniMap( "compass_map_prague_streets", "streets_minimap_corner" );
}

// AI quantity relative to difficulty is set directly on the
// spawners
setup_difficulty_settings()
{
	Assert( IsDefined( level.gameskill ) );
	
	ai_accuracy		= undefined;
	ai_prespot_time	= undefined;
	ai_backup_max	= undefined;
	poi_see_delay	= undefined;
	
	switch( level.gameSkill )
	{
		case 0:									// Easy
		case 1:									// Regular
			ai_accuracy		= 3.0;
			ai_prespot_time	= 4.0;
			ai_backup_max	= 6.0;
			poi_see_delay	= 1.0;
			break;
		case 2:									// Hardened
			ai_accuracy		= 3.75;
			ai_prespot_time	= 3.0;
			ai_backup_max	= 8.0;
			poi_see_delay	= 0.8;
			break;
		case 3:									// Veteran
			ai_accuracy		= 3.75;
			ai_prespot_time	= 2.0;
			ai_backup_max	= 10.0;
			poi_see_delay	= 0.5;
			break;
		default:
			AssertMsg( "Unhandled difficulty level: " + level.gameSkill );
			ai_accuracy		= 3.0;
			ai_prespot_time	= 4.0;
			poi_see_delay	= 1.0;
			break;
	}
	
	level.so_prague_ai_accuracy 		= ai_accuracy;
	level.so_prague_ai_prespot_time		= ai_prespot_time;
	level.so_prague_ai_backup_max		= ai_backup_max;
	level.so_prague_poi_see_delay		= poi_see_delay;
}

setup_stat_variables()
{	
	foreach ( player in level.players )
	{
		player.stat_civs_rescued	= [];
		player.stat_stealth_kills	= 0;
		player.stat_head_shots		= 0;
		player.stat_finish_time		= 0;
	}
}

// -.-.-.-.-.-.-.-.-.-.-.-. Starts -.-.-.-.-.-.-.-.-.-.-.-. //
start_generic_setup()
{	
	// Reinforcement spawn on alert for each encounter
	thread on_level_alert_spawn_backup();
	
	thread objective_think();
	
	// Update player locations according to start point
	update_player_locs( level.start_point );
	
	thread spawn_civilians_hidden();
	
	music_play( "so_stealth_prague_music" );
	
	thread on_mission_success();
	
	flag_set( "so_stealth_prague_start" );
}

update_player_locs( start_name )
{
	// No start or default start
	if ( !IsDefined( start_name ) || start_name == "default" || start_name == "start_church" )
		return;
	
	switch( start_name )
	{
		case "start_alley":
		case "start_yard":
		case "start_apartment":
		case "start_quad":
			break;
		
		default:
			AssertMsg( "Start string not handled in player location update: " + start_name );
			break;
	}
	
	foreach ( index, player in level.players )
	{
		start_struct_name	= start_name + "_loc_player" + ( index + 1 );
		start_struct		= getstruct( start_struct_name, "targetname" );
		
		if ( !IsDefined( start_struct ) )
		{
			AssertMsg( "Invalid start location for player: " + start_struct_name );
			continue;
		}
		
		player teleport_player( start_struct );
	}
}

start_church()
{
	start_generic_setup();
	
	thread encounter_church();
	thread encounter_alley();
	thread encounter_yard();
	thread encounter_apartment();
	thread encounter_quad();
	thread encounter_shop();
}

start_alley()
{
	start_generic_setup();
	
	thread encounter_alley();
	thread encounter_yard();
	thread encounter_apartment();
	thread encounter_quad();
	thread encounter_shop();
}

start_yard()
{
	start_generic_setup();

	thread encounter_yard();
	thread encounter_apartment();
	thread encounter_quad();
	thread encounter_shop();
}

start_apartment()
{
	start_generic_setup();
	
	thread encounter_apartment();
	thread encounter_quad();
	thread encounter_shop();
}

start_quad()
{
	start_generic_setup();
	
	// Player spawns ahead of trigger
	flag_set( "quad_enc_setup" );
	
	thread encounter_quad();
	thread encounter_shop();
}

// -.-.-.-.-.-.-.-.-.-.-.-. General AI Logic -.-.-.-.-.-.-.-.-.-.-.-. //

setup_idles()
{	
	maps\_idle::idle_main();
	maps\_idle_coffee::main();
	maps\_idle_lean_smoke::main();
	maps\_idle_phone::main();
	maps\_idle_sit_load_ak::main();
	maps\_idle_sleep::main();
	maps\_idle_smoke::main();
	maps\_idle_smoke_balcony::main();
}

on_spawn_axis()
{
	self.a.disableLongDeath = true;
	self.combatmode 		= "no_cover";
	
	if ( self.type == "dog" )
	{
		self record_dog();
	}
	else
	{
		if ( IsDefined( level.so_prague_ai_accuracy ) )
		{
			self.baseaccuracy = level.so_prague_ai_accuracy;
		}
		if ( IsDefined( level.so_prague_ai_prespot_time ) )
		{
			self maps\_stealth_utility::stealth_pre_spotted_function_custom( ::stealth_custom_prespotted_delay );
		}
	}
	
	if ( self ent_flag_exist( "_stealth_enabled" ) && ent_flag( "_stealth_enabled" ) )
	{
		self thread on_alert_player_seek();
	}
}

on_death_axis()
{
	level endon( "special_op_terminated" );
	
	self waittill( "death", attacker );
	
	self thread on_kill_axis_radio_comment( attacker );
	
	if ( IsPlayer( attacker ) )
	{
		if ( !flag( "_stealth_spotted" ) )
		{
			attacker.stat_stealth_kills++;
			attacker notify( "ui_stealth_kill_count", attacker.stat_stealth_kills );
		}
		
		if ( IsDefined( self.damageLocation ) && animscripts\utility::damageLocationIsAny( "helmet", "head", "neck" ) )
		{
			attacker.stat_head_shots++;
			attacker notify( "ui_head_shot_count", attacker.stat_head_shots );
		}
	}
}

on_poi_team_updated()
{
	level endon( "missionfailed" );
	level endon( "special_op_terminated" );
	
	while ( 1 )
	{
		level waittill( "poi_team_updated" );
		
		foreach ( player in level.players )
		{
			player notify( "ui_rebel_count", player count_civs_rescued() );
		}
	}
}

initialize_kill_axis_radio()
{
	level.so_prague_kill_radio_calls = 0;

	level.so_prague_kill_single_radio_msgs = [];
	level.so_prague_kill_single_radio_msgs[ "prague_killfirm_player_1" ] = 0;
	level.so_prague_kill_single_radio_msgs[ "prague_killfirm_other_1" ] = 0;
	level.so_prague_kill_single_radio_msgs[ "prague_killfirm_other_2" ] = 0;
	level.so_prague_kill_single_radio_msgs[ "prague_killfirm_other_4" ] = 0;
	level.so_prague_kill_single_radio_msgs[ "prague_mct_goodnight" ] = 0;
	level.so_prague_kill_single_radio_msgs[ "so_ste_prague_mct_hesdead" ] = 0;
	level.so_prague_kill_single_radio_msgs[ "so_ste_prague_mct_beautiful" ] = 0;

	level.so_prague_kill_multi_radio_msgs = [];
	level.so_prague_kill_multi_radio_msgs[ "prague_killfirm_player_3" ] = 0;
	level.so_prague_kill_multi_radio_msgs[ "prague_killfirm_other_3" ] = 0;
	level.so_prague_kill_multi_radio_msgs[ "prague_clear_1" ] = 0;
	level.so_prague_kill_multi_radio_msgs[ "prague_clear_2" ] = 0;
	level.so_prague_kill_multi_radio_msgs[ "prague_clear_3" ] = 0;
	level.so_prague_kill_multi_radio_msgs[ "so_ste_prague_mct_gotemall" ] = 0;
	level.so_prague_kill_multi_radio_msgs[ "so_ste_prague_mct_goodkills" ] = 0;
	level.so_prague_kill_multi_radio_msgs[ "so_ste_prague_mct_tangosdown" ] = 0;
	level.so_prague_kill_multi_radio_msgs[ "so_ste_prague_mct_eliminated" ] = 0;

	thread on_stealth_spotted_clear_stealth_kill_data();
}
on_kill_axis_radio_comment( attacker )
{
	if	(
			!IsDefined( attacker )
		||	!IsPlayer( attacker )
		||	flag( "_stealth_spotted" )
		)
	{
		return;
	}
	
	if ( !IsDefined( self ) )
	{
		return;
	}
	
	level notify( "axis_death_radio_bump" );
	level endon( "axis_death_radio_bump" );
	level endon( "_stealth_spotted" );
	level endon( "special_op_terminated" );
	
	loc = self.origin;
	
	if ( !IsDefined( level.so_prague_kill_radio_calls ) )
	{
		initialize_kill_axis_radio();
	}
	
	level.so_prague_kill_radio_calls++;
	
	wait 1.0;
	
	// Don't comment while ai are searching
	time_started_waiting = GetTime();
	while ( !all_stealth_normal() )
	{
		wait 0.05;
	}
	
	// Don't comment while a living enemy is
	// very close to the player
	while ( stealth_enemy_within_dist( loc, 20 * 12 ) )
	{
		wait 0.05;
	}
	
	if ( flag( "axis_kill_radio_paused" ) )
	{
		flag_waitopen( "axis_kill_radio_paused" );
	}
	
	// Clear the kill count
	kills = level.so_prague_kill_radio_calls;
	level.so_prague_kill_radio_calls = 0;
	
	// If the time spent waiting for other AI to lose
	// their warning state is greater than 1 second
	// abandon this on kill radio comment
	if ( GetTime() - time_started_waiting > 1000 )
	{
		return;
	}
	
	// Check each radio message array to make sure at least one radio message
	// is available for use. If not, reset all messages to unused.
	clean_kill_axis_radio_msg_arrays();
	
	// Choose the correct radio message array and make a copy
	array_radio_msgs = undefined;
	if ( kills == 1 )
	{
		array_radio_msgs = level.so_prague_kill_single_radio_msgs;
	}
	else
	{
		array_radio_msgs = level.so_prague_kill_multi_radio_msgs;
	}
	
	// Grab unused radio messages
	array_radio_msg_options = [];
	foreach ( msg, state_used in array_radio_msgs )
	{
		if ( !state_used )
		{
			array_radio_msg_options[ array_radio_msg_options.size ] = msg;
		}
	}
	
	AssertEx( array_radio_msg_options.size, "No unused radio messages found. This should not happen." );
	
	radio_message = array_radio_msg_options[ RandomInt( array_radio_msg_options.size ) ];
	
	// Now that a radio message has been chosen go back to the correct
	// radio message array using the number of kills and set the chosen
	// message to used.
	if ( kills == 1 )
	{
		AssertEx( array_contains( GetArrayKeys( level.so_prague_kill_single_radio_msgs ), radio_message ), "Marked the following radio message as used in an array that doesnt' contain that message: " + radio_message );
		level.so_prague_kill_single_radio_msgs[ radio_message ] = 1;
	}
	else
	{
		AssertEx( array_contains( GetArrayKeys( level.so_prague_kill_multi_radio_msgs ), radio_message ), "Marked the following radio message as used in an array that doesnt' contain that message: " + radio_message );
		level.so_prague_kill_multi_radio_msgs[ radio_message ] = 1;
	}
	
	radio_dialogue( radio_message );	
}

clean_kill_axis_radio_msg_arrays()
{
	all_used = true;
	foreach( state_used in level.so_prague_kill_single_radio_msgs )
	{
		if ( !state_used )
		{
			all_used = false;
			break;
		}
	}
	
	if ( all_used )
	{
		foreach ( msg, state_used in level.so_prague_kill_single_radio_msgs )
		{
			level.so_prague_kill_single_radio_msgs[ msg ] = 0;
		}
	}
	
	all_used = true;
	foreach( state_used in level.so_prague_kill_multi_radio_msgs )
	{
		if ( !state_used )
		{
			all_used = false;
			break;
		}
	}
	
	if ( all_used )
	{
		foreach ( msg, state_used in level.so_prague_kill_multi_radio_msgs )
		{
			level.so_prague_kill_multi_radio_msgs[ msg ] = 0;
		}
	}
}

on_stealth_spotted_clear_stealth_kill_data()
{
	level endon( "special_op_terminated" );
	
	while ( 1 )
	{
		flag_wait( "_stealth_spotted" );
		flag_waitopen( "_stealth_spotted" );
		level.so_prague_kill_radio_calls = 0;
	}
}

on_alert_player_seek()
{
	self endon( "death" );
	
	// If the AI just spawned and the _stealth_spotted flag
	// is already set just start seeking now
	if ( flag( "_stealth_spotted" ) )
	{
		self player_seek_coop();	
		return;
	}
	
	// Wait for the AI to get alerted then seek
	flag_alert = "_stealth_spotted";
	
	if ( IsDefined( self.script_stealthgroup ) )
	{
		flag_alert = self maps\_stealth_utility::stealth_get_group_spotted_flag();
	}
	
	flag_wait( flag_alert );
	
	self player_seek_coop();
}

on_level_alert_spawn_backup()
{
	foreach ( player in level.players )
	{
		player endon( "death" );
	}
	
	min_dist		= 512;
	max_dist		= 2048;
	
	max_ai_backup	= 8;
	if ( IsDefined( level.so_prague_ai_backup_max ) )
	{
		max_ai_backup = level.so_prague_ai_backup_max;
	}
	
	while ( 1 )
	{
		flag_wait( "_stealth_spotted" );
		
		//Sandman: That was sloppy, Frost.
		thread radio_dialogue( "prague_spotted_3" );
		
		spawn_loc_name = undefined;
		
		// Figure out the most recent encounter to be set up
		// and spawn the corresponding reinforceements
		if ( flag( "shop_enc_player_over_fence" ) )
		{
			spawn_loc_name = "ai_shop_spotted";
		}
		else if ( flag( "quad_enc_setup" ) )
		{
			spawn_loc_name = "ai_quad_spotted";
		}
		else if ( flag( "apartment_enc_setup" ) )
		{
			spawn_loc_name = "ai_apartment_spotted";
		}
		else if ( flag( "yard_enc_setup" ) )
		{
			spawn_loc_name = "ai_yard_spotted";
		}
		else if ( flag( "alley_enc_setup" ) )
		{
			spawn_loc_name = "ai_alley_spotted";
		}
		else if ( flag( "church_enc_setup" ) )
		{
			spawn_loc_name = "ai_church_spotted";
		}
		
		spawn_locs = getstructarray( spawn_loc_name, "targetname" );
		if ( spawn_locs.size )
		{
			// Don't spawn too close or too far from players
			foreach ( player in level.players )
			{
				// No max count is passed in here as some of the spawn calls below may fail
				spawn_locs = get_array_of_closest( player.origin, spawn_locs, undefined, undefined, max_dist, min_dist );
			}
			
			// Move the correct spawner to each location and spawn the ai
			ai_count = 0;
			foreach ( loc in spawn_locs )
			{
				if ( !IsDefined( loc.script_noteworthy ) )
				{
					AssertMsg( "Enemy backup spawn location at: " + loc.origin + " is missing script_noteworthy weapon."  );
					continue;
				}
				
				spawner_name = "ai_spotted_" + loc.script_noteworthy;
				spawner = GetEnt( spawner_name, "targetname" );
				
				if ( !IsDefined( spawner ) )
				{
					AssertMsg( "Invalid backup spawner name created: " + spawner_name );
					continue;
				}
				
				spawner.count = 1;
				spawner.origin = loc.origin;
				spawner.angles = loc.angles;
				ai = spawner spawn_ai();
				if ( !IsDefined( ai ) )
					continue;
				
				if ( loc.script_noteworthy == "SNIPER" )
				{
					ai.health = 1;
					ai.goalradius = 1;
					ai SetGoalPos( self.origin );
				}
	
				ai thread alert_and_player_seek();
				ai thread maps\_util_carlos::light_on_gun();
				
				ai_count++;
				if ( ai_count >= max_ai_backup )
					break;
				
				// Don't use the spawner twice in a frame
				wait 0.05;
			}
		}
		
		while ( 1 )
		{
			flag_waitopen( "_stealth_spotted" );
			
			// Even though the global "_stealth_spotted" flag has been cleared
			// another group of AI may be on warning, about to set "_stealth_spotted".
			while ( !all_stealth_normal() )
			{
				wait 0.01;
			}
			
			// If stealth is normal and stealth spotted is not set we can
			// assume the battle is over
			if ( !flag( "_stealth_spotted" ) )
			{
				break;
			}
		}
		
		thread dialog_spotted_recovery();
	}
}

dialog_spotted_recovery()
{
	// Soap recover from spotted lines that have been used
	if ( !IsDefined( level.so_prague_recover_lines ) )
	{
		level.so_prague_recover_lines = [];
	}
	
	// Choose a line from ones that haven't been used
	array_lines = [ "prague_recover_1", "prague_recover_2", "prague_recover_3" ];
	array_options = [];
	foreach( entry in array_lines )
	{
		if ( array_contains( level.so_prague_recover_lines, entry ) )
		{
			continue;
		}
		
		array_options[ array_options.size ] = entry;
	}
	
	// If no options were found, choose a random one
	// and record it as used
	if ( !array_options.size )
	{
		// At this point the used list should hold all options so choose
		// one at random not including the last entry as that was used last
		choice = level.so_prague_recover_lines[ RandomInt( level.so_prague_recover_lines.size - 1 ) ];
		
		// Reset the used list to only have the dialog that was just used.
		level.so_prague_recover_lines = [ choice ];
	}
	else
	{
		choice = array_options[ RandomInt( array_options.size ) ];
		level.so_prague_recover_lines[ level.so_prague_recover_lines.size ] = choice;
	}
	
	thread radio_dialogue( choice );
}

on_mission_success()
{
	flag_wait( "so_stealth_prague_complete" );
	
	if ( count_civs_rescued_all_players() >= 5 )
	{
		radio_dialogue( "so_ste_prague_mct_goodjob" );
	}
	else
	{
		radio_dialogue( "so_ste_prague_mct_somebehind" );
	}
}

dialog_on_player_weapon_change()
{
	self endon( "death" );
	level endon( "nonsilenced_weapon_pickup" );
	level endon( "special_op_terminated" );

	old_weapon_list = self GetWeaponsListPrimaries();

	while ( true )
	{
		self waittill( "weapon_change" );

		current_weapon_list = self GetWeaponsListPrimaries();

		state = false;
		foreach( weapon in current_weapon_list ) 
		{
			if ( !array_contains( old_weapon_list, weapon ) )
				state = true;
		}

		if ( state )
		{
			thread radio_dialogue( "so_ste_prague_mct_careful" );
			break;
		}
	}

	level notify( "nonsilenced_weapon_pickup" );
}
spawn_civilians_hidden()
{
	spawners = GetEntArray( "ai_civ_hidden", "targetname" );
	array_spawn_function( spawners, ::poi_make_collectible, true );
	array_spawn_function( spawners, ::on_spawn_civilian_hidden );
	array_spawn( spawners, true, true );
}

on_spawn_civilian_hidden()
{
	if ( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "over_fence" )
	{
		self.poi_over_fence = true;
	}
}

// -.-.-.-.-.-.-.-.-.-.-.-. Objectives -.-.-.-.-.-.-.-.-.-.-.-. //

objective_think()
{
	objective_add( obj( "escape" ), "active", &"SO_STEALTH_PRAGUE_OBJ_1" );
	objective_current( obj( "escape" ) );
	
	// Each objective location is a struct with information for
	// creating a trigger radius. This is to save entity counts
	// as prague is dangerously close to the limit on load.
	trigger_array	= [];
	spawn_flags		= 64; // Only touch once
	
	// Populate an array of spawned triggers at the location of each struct
	// using the settings on the struct
	trigger_struct = getstruct( "objective_area_first", "targetname" );
	while ( IsDefined( trigger_struct ) )
	{
		trigger = trigger_radius_from_struct( trigger_struct, spawn_flags );
		trigger.script_specialops = 1;
		
		trigger_array[ trigger_array.size ] = trigger;
		
		if ( !IsDefined( trigger_struct.target ) )
		{
			break;
		}
		else
		{
			trigger_struct = get_target_ent( trigger_struct.target );
		}
	}
	
	// The player doesn't actually reach the last objective
	// marker trigger so thread this success objective wait
	// off to wait for success
	thread objective_on_complete();
	
	foreach ( trigger in trigger_array )
	{
		Objective_Position( obj( "escape" ), trigger.origin );
		
		trigger waittill( "trigger" );
	}
	
	
}

objective_on_complete()
{
	flag_wait( "so_stealth_prague_complete" );
	objective_complete( obj( "escape" ) );
}

objective_set_entity( obj_index, ent_name )
{
	obj_ent = GetEnt( ent_name, "targetname" );
	
	Objective_Position( obj_index, obj_ent.origin );
	
	return obj_ent;
}

// -.-.-.-.-.-.-.-.-.-.-.-. Stealth -.-.-.-.-.-.-.-.-.-.-.-. //

setup_stealth()
{
	maps\_stealth::main();
	maps\_stealth_utility::stealth_corpse_collect_func( ::stealth_collect_corpse_override );
	stealth_event_distance_override();
	
	foreach ( player in level.players )
	{
		player thread maps\_stealth_utility::stealth_default();
	}
}

stealth_collect_corpse_override()
{
	corpses				= GetCorpseArray();
	corpses_filtered	= [];
	
	foreach ( corpse in corpses )
	{
		// Ignore the female who is executed in the quad
		if ( IsDefined( corpse.target ) && corpse.target == "ignore_corpse" )
			continue;
		
		corpses_filtered[ corpses_filtered.size ] = corpse;
	}
	
	return corpses_filtered;
}

stealth_event_distance_override()
{
	maps\_stealth_utility::stealth_alert_level_duration( 0.5 );
	
	// -.-.-.-.-.- Gun Shots -.-.-.-.-.- //
	ai_event[ "ai_eventDistGunShotTeam" ]	 = [];
	ai_event[ "ai_eventDistGunShotTeam" ][ "spotted" ]			= 850;	// Default: 750
	ai_event[ "ai_eventDistGunShotTeam" ][ "hidden" ]			= 850;	// Default: 750
	
	// -.-.-.-.-.- Footsteps -.-.-.-.-.- //
	ai_event[ "ai_eventDistFootstep" ] = [];
	ai_event[ "ai_eventDistFootstep" ][ "spotted" ]				= 15 * 12;
	ai_event[ "ai_eventDistFootstep" ][ "hidden" ]				= 15 * 12;

	ai_event[ "ai_eventDistFootstepWalk" ] = [];
	ai_event[ "ai_eventDistFootstepWalk" ][ "spotted" ]			= 40 * 12;
	ai_event[ "ai_eventDistFootstepWalk" ][ "hidden" ]			= 35 * 12;

	ai_event[ "ai_eventDistFootstepSprint" ] = [];
	ai_event[ "ai_eventDistFootstepSprint" ][ "spotted" ]		= 50 * 12;
	ai_event[ "ai_eventDistFootstepSprint" ][ "hidden" ]		= 35 * 12;

	maps\_stealth_utility::stealth_ai_event_dist_custom( ai_event );
	
	// -.-.-.-.-.- Sight Distance -.-.-.-.-.- //
	rangesHidden = [];
	rangesHidden[ "prone" ]		= 20 * 12;
	rangesHidden[ "crouch" ]	= 50 * 12;
	rangesHidden[ "stand" ]		= 60 * 12;

	rangesSpotted = [];
	rangesSpotted[ "prone" ]	= 8192;
	rangesSpotted[ "crouch" ]	= 8192;
	rangesSpotted[ "stand" ]	= 8192;

	maps\_stealth_utility::stealth_detect_ranges_set( rangesHidden, rangesSpotted );
	
	corpse_distances = [];
	corpse_distances[ "player_dist" ] 		= 125	* 12;	// this is the max distance a player can be to a corpse
	corpse_distances[ "sight_dist" ] 		= 40	* 12;	// this is how far they can see to see a corpse
	corpse_distances[ "detect_dist" ] 		= 20	* 12;	// this is at what distance they automatically see a corpse
	corpse_distances[ "found_dist" ] 		= 8		* 12;	// this is at what distance they actually find a corpse
	corpse_distances[ "found_dog_dist" ] 	= 5		* 12;	// this is at what distance they actually find a corpse

	maps\_stealth_utility::stealth_corpse_ranges_custom( corpse_distances );
}

stealth_event_distance_override_apartment()
{
	maps\_stealth_utility::stealth_alert_level_duration( 0.5 );
	
	// -.-.-.-.-.- Gun Shots -.-.-.-.-.- //
	ai_event[ "ai_eventDistGunShotTeam" ]	 = [];
	ai_event[ "ai_eventDistGunShotTeam" ][ "spotted" ]			= 850;	// Default: 750
	ai_event[ "ai_eventDistGunShotTeam" ][ "hidden" ]			= 850;	// Default: 750
	
	// -.-.-.-.-.- Footsteps -.-.-.-.-.- //
	ai_event[ "ai_eventDistFootstep" ] = [];
	ai_event[ "ai_eventDistFootstep" ][ "spotted" ]				= 8 * 12;
	ai_event[ "ai_eventDistFootstep" ][ "hidden" ]				= 8 * 12;

	ai_event[ "ai_eventDistFootstepWalk" ] = [];
	ai_event[ "ai_eventDistFootstepWalk" ][ "spotted" ]			= 10 * 12;
	ai_event[ "ai_eventDistFootstepWalk" ][ "hidden" ]			= 10 * 12;

	ai_event[ "ai_eventDistFootstepSprint" ] = [];
	ai_event[ "ai_eventDistFootstepSprint" ][ "spotted" ]		= 25 * 12;
	ai_event[ "ai_eventDistFootstepSprint" ][ "hidden" ]		= 18 * 12;

	maps\_stealth_utility::stealth_ai_event_dist_custom( ai_event );
	
	// -.-.-.-.-.- Sight Distance -.-.-.-.-.- //
	rangesHidden = [];
	rangesHidden[ "prone" ]		= 20 * 12;
	rangesHidden[ "crouch" ]	= 30 * 12;
	rangesHidden[ "stand" ]		= 50 * 12;

	rangesSpotted = [];
	rangesSpotted[ "prone" ]	= 8192;
	rangesSpotted[ "crouch" ]	= 8192;
	rangesSpotted[ "stand" ]	= 8192;

	maps\_stealth_utility::stealth_detect_ranges_set( rangesHidden, rangesSpotted );
	
	corpse_distances = [];
	corpse_distances[ "player_dist" ] 		= 125	* 12;	// this is the max distance a player can be to a corpse
	corpse_distances[ "sight_dist" ] 		= 25	* 12;	// this is how far they can see to see a corpse
	corpse_distances[ "detect_dist" ] 		= 10	* 12;	// this is at what distance they automatically see a corpse
	corpse_distances[ "found_dist" ] 		= 5		* 12;	// this is at what distance they actually find a corpse
	corpse_distances[ "found_dog_dist" ] 	= 5		* 12;	// this is at what distance they actually find a corpse

	maps\_stealth_utility::stealth_corpse_ranges_custom( corpse_distances );
}

stealth_custom_prespotted_delay()
{
	if ( IsDefined( level.so_prague_ai_prespot_time ) )
	{
		wait( level.so_prague_ai_prespot_time );
	}
	else
	{
		wait 3.0;
	}
}
// -.-.-.-.-.-.-.-.-.-.-.-. Weather -.-.-.-.-.-.-.-.-.-.-.-. //
setup_weather()
{
	thread rain_think();	
	thread lightning_think();
}

rain_think()
{
	foreach ( player in level.players )
	{
		player endon( "death" );
	}
	
	while ( 1 )
	{
		PlayFX( getfx( "rain_heavy" ), level.player.origin + (0,0,1024) );
		
		if ( IsDefined( level.player2 ) && maps\_util_carlos::distance_2d_squared( level.player.origin, level.player2.origin ) > 1450 * 1450  )
		{
			PlayFX( getfx( "rain_heavy" ), level.player2.origin + (0,0,1024) );
		}
		
		wait 0.33;
	}
}

lightning_think()
{
	// used in thunder logic
	level.rainlevel = 9;
	
	while ( 1 )
	{
		flash_type = undefined;
		delay = RandomFloatRange( 6.0, 18.0 );
		
		msg = level waittill_any_timeout( delay, "lightning_now", "lightning_pause" );
		
		if ( msg == "lightning_pause" && flag_exist( "lightning_pause" ) )
		{
			flag_waitopen( "lightning_pause" );
		}
		else if ( msg == "lightning_now" )
		{
			// Triple flash
			flash_type = 2;
			
			if ( flag_exist( "lightning_now" ) )
			{
				flag_clear( "lightning_now" );
			}
		}
		
		thread maps\_weather::lightningFlash( maps\prague_fx::lightning_normal, maps\prague_fx::lightning_flash, flash_type );
	}
}

// -.-.-.-.-.-.-.-.-.-.-.-. Encounter: Church -.-.-.-.-.-.-.-.-.-.-.-. //
encounter_church()
{
	flag_set( "church_enc_setup" );
	thread encounter_church_spawn_ai();
	
	radio_dialogue( "soap_intro" );
}

encounter_church_spawn_ai()
{
	spawners_church_enc = [];
	
	// AI near church steps
	spawners = GetEntArray( "ai_church_steps", "targetname" );
	array_spawn_function( spawners, ::on_spawn_ai_church_steps );
	array_spawn_function( spawners, ::on_alert_ai_church_reset_moveplayback );
	spawners_church_enc = array_combine( spawners_church_enc, spawners );
	
	thread encounter_church_spawn_street_patrol();
	
	// AI in museum
	spawners = GetEntArray( "ai_church_museum", "targetname" );
	array_spawn_function( spawners, ::on_spawn_ai_active_patrol, "church_enc_reached_museum", 0.8 );
	spawners_church_enc = array_combine( spawners_church_enc, spawners );
	
	array_spawn( spawners_church_enc, true, true );
}

encounter_church_spawn_street_patrol()
{
	level endon( "church_enc_street_ai_aware" );
	
	// AI further down the street
	spawners = GetEntArray( "ai_church_street", "targetname" );

	ai_enemies = array_spawn( spawners, true, true );
	foreach ( ai_enemy in ai_enemies )
	{
		ai_enemy thread on_spawn_ai_church_street();
		ai_enemy thread maps\_util_carlos::light_on_gun();
		ai_enemy thread on_aware_ai_church_street();
		ai_enemy thread on_alert_ai_church_reset_moveplayback();
	}
	
	// AI civilian being escorted
	spawner_civ = GetEnt( "ai_church_civ_escort", "targetname" );
	ai_civ = spawner_civ spawn_ai( true );
	
	ai_civ.aim_target = Spawn( "script_origin", ai_civ GetEye() );
	ai_civ.aim_target LinkTo( ai_civ, "tag_eye" );
	ai_civ thread on_spawn_ai_church_civ_street();
	ai_civ thread on_rescued_ai_church_civ_street();
	ai_civ thread on_death_ai_church_civ_street();
	
	// Once the Civilian is at his path end, shoot him
	ai_civ waittill( "reached_path_end" );
	ai_civ thread anim_generic_loop( ai_civ, "civ_escort_idle", "stop_preshot_idle" );
	
	foreach ( ai_enemy in ai_enemies )
	{
		ai_enemy notify( "end_patrol" );
		ai_enemy SetEntityTarget( ai_civ.aim_target );
		wait 0.2;
	}
	
	wait 0.3;
	
	thread church_enc_street_execution_disable_stealth_events();
	
	for ( i = 0; i < 8; i++ )
	{
		ai_enemy = ai_enemies[ RandomInt( ai_enemies.size ) ];
		if ( IsAlive( ai_civ ) )
			ai_enemy Shoot( 1.0, ai_civ GetEye() );
		else
			ai_enemy Shoot( 1.0 );
		
		wait( RandomFloatRange( 0.08, 0.15 ) );
	}
	
	if ( IsAlive( ai_civ ) )
	{
		ai_civ Kill( ai_enemies[ 0 ].origin, ai_enemies[ 0 ] );
	}
	
	foreach ( ai_enemy in ai_enemies )
	{
		ai_enemy ClearEntityTarget();
		wait 0.3;
	}
	
	flag_set( "church_enc_street_execution_done" );
	
	foreach ( index, ai_enemy in ai_enemies )
	{
		if ( index > 0 )
		{
			self.patrol_walk_anim = undefined;
		}
		ai_enemy thread maps\_patrol::patrol( "path_struct_church_execute" + index );
		wait 0.25;
	}
}

church_enc_street_execution_disable_stealth_events()
{
	ai_living = get_stealth_ai_living();
	foreach ( ai in ai_living )
	{
		ai RemoveAIEventListener( "bulletwhizby" );
		ai RemoveAIEventListener( "gunshot_teammate" );
	}
	
	flag_wait_any( "_stealth_spotted", "church_enc_street_ai_aware", "church_enc_street_execution_done" );
	
	// Slight delay for shooting to finish
	wait 0.4;
	
	ai_living = get_stealth_ai_living();
	foreach ( ai in ai_living )
	{
		ai AddAIEventListener( "bulletwhizby" );
		ai AddAIEventListener( "gunshot_teammate" );
	}
}

on_spawn_ai_church_steps()
{
	self.moveplaybackrate = RandomFloatRange( 0.75, 0.9 );
	self thread active_patrol_light_swap();
}

on_spawn_ai_church_street()
{
	self.patrol_walk_anim = "casual_killer_walk_F";
	self maps\_patrol::patrol();
}

on_alert_ai_church_reset_moveplayback()
{
	self endon( "death" );
	
	self ent_flag_waitopen( "_stealth_normal" );
	self.moveplaybackrate = 1.0;
}

on_aware_ai_church_street()
{
	self waittill_any( "death", "damage", "event_awareness" );
	
	flag_set( "church_enc_street_ai_aware" );
}

on_spawn_ai_church_civ_street()
{
	self.ignoreall			= true;
	self.ignoreme			= true;

	self.patrol_walk_anim = "civ_escort_walk";
	self maps\_patrol::patrol();
}

on_rescued_ai_church_civ_street()
{
	self endon( "death" );
	
	flag_wait( "church_enc_street_ai_aware" );
	
	self notify( "stop_preshot_idle" );
	
	self poi_make_collectible( false, level.so_prague_poi_see_delay );
}

on_death_ai_church_civ_street()
{
	self waittill( "death", attacker );
	
	if ( IsDefined( self.aim_target ) )
	{
		self.aim_target Unlink();
		self.aim_target Delete();
	}
	
	if ( IsDefined( attacker ) && IsDefined( attacker.team ) && attacker.team == "axis" )
	{
		self.target = "ignore_corpse";
	}
}

// -.-.-.-.-.-.-.-.-.-.-.-. Encounter: Alley -.-.-.-.-.-.-.-.-.-.-.-. //
encounter_alley()
{
	flag_wait( "alley_enc_setup" );
	
	encounter_alley_create_threat_bias();
	thread encounter_alley_spawn_ai();
	thread encounter_alley_alert();
}

encounter_alley_create_threat_bias()
{
	CreateThreatBiasGroup( "threatgroup_dog" );
	CreateThreatBiasGroup( "threatgroup_civ" );
	CreateThreatBiasGroup( "threatgroup_ignore" );
	
	SetThreatBias( "threatgroup_dog", "threatgroup_civ", 100000 );	// Dog attacks female civilian
	SetIgnoreMeGroup( "threatgroup_ignore", "axis" );				// Enemies ignore group ignore
	SetIgnoreMeGroup( "allies", "threatgroup_dog" );				// Dog ignores allies
	SetIgnoreMeGroup( "axis", "threatgroup_dog" );					// Dog ignores axis
	SetIgnoreMeGroup( "threatgroup_civ", "axis" );					// Enemies ignore female civilian
}

encounter_alley_spawn_ai()
{	
	// Civilian - gets mauled by dog
	spawner_female = GetEnt( "ai_alley_civ", "targetname" );
	spawner_female add_spawn_function( ::on_spawn_ai_alley_civ );
	spawner_female add_spawn_function( ::on_death_ai_alley_civ );
	spawner_female add_spawn_function( ::on_escape_ai_alley_civ );
	ai_female = spawner_female spawn_ai( true );
	
	// Enemy dog - chase down and kill civilian
	// The dog has a lot of logic here because it is not 
	// part of the stealth system but still needs to behave
	// in line with other stealthing enemies. Not being
	// stealthed allows the dog to attack the civilian without
	// causing stealth spotted.
	spawner_dog = GetEnt( "ai_alley_dog", "targetname" );
	spawner_dog add_spawn_function( ::on_spawn_ai_alley_dog );
	spawner_dog add_spawn_function( ::on_damage_ai_alley_dog );
	spawner_dog add_spawn_function( ::on_death_ai_alley_dog );
	spawner_dog add_spawn_function( ::on_dog_attack_alley_think );
	spawner_dog add_spawn_function( ::on_enemy_ai_alley_dog );
	
	ai_dog = spawner_dog spawn_ai( true );
	
	encounter_alley_dog_attack( ai_dog, ai_female );
	
	// Enemies - chasing civilian and dog
	spawners_enemy = GetEntArray( "ai_alley", "targetname" );
	array_spawn_function( spawners_enemy, ::on_spawn_ai_alley_enemy );
	array_spawn_function( spawners_enemy, ::on_alley_enemy_damaged );
	
	ai_enemies = array_spawn( spawners_enemy, true, true );
}

on_alley_enemy_damaged()
{	
	// Handle pain, death, flashbang, etc
	self waittill_either( "death", "damage" );
	
	flag_set( "alley_enc_enemy_damaged" );
}

on_spawn_ai_alley_civ()
{
	// Prevent civilian from getting an enemy. Allows patrol
	// to always work
	self.ignoreall			= true;
	
	self.ignoreme			= true;
	self.patrol_walk_anim	= "civilian_run_upright";
	self.moveplaybackrate	= 0.9;
	
	self SetThreatBiasGroup( "threatgroup_civ" );
	self maps\_patrol::patrol();
}

on_death_ai_alley_civ()
{
	self waittill( "death" );
	
	flag_set( "alley_enc_civ_killed" );
}

on_escape_ai_alley_civ()
{
	self endon( "death" );
	
	flag_wait( "alley_enc_dog_damaged" );
	
	self.moveplaybackrate = 1.0;
	
	self poi_make_collectible( false, level.so_prague_poi_see_delay );
}

on_spawn_ai_alley_dog()
{
	self.ignoreme			= true;
	self.ignoreall			= true;
	
	self SetThreatBiasGroup( "threatgroup_dog" );
}

on_damage_ai_alley_dog()
{
	msg = self waittill_any_return( "death", "damage" );
	
	flag_set( "alley_enc_dog_damaged" );
	flag_set( "alley_enc_ai_alert" );
}

on_death_ai_alley_dog()
{
	// Because this dog not in the stealth system don't allow
	// radio comments while it's alive. If they were allowed, you'd
	// here messages like "all clear" while the dog is still attacking
	flag_set( "axis_kill_radio_paused" );
	
	self waittill( "death" );
	
	flag_clear( "axis_kill_radio_paused" );
}

on_dog_attack_alley_think()
{
	self endon( "death" );
	
	msg = flag_wait_any_return( "alley_enc_civ_killed", "alley_enc_dog_damaged" );
	
	self.favoriteenemy	= undefined;
	self SetThreatBiasGroup( "axis" );
	
	if ( msg == "alley_enc_civ_killed" && !flag( "alley_enc_enemy_damaged" ) && !flag( "_stealth_spotted" ) )
	{		
		// Leave dog by the body and wait for player activity
		self.goalradius = 120;
		self SetGoalPos( self.origin );
		
		flag_wait_any( "alley_enc_dog_damaged", "alley_enc_dog_spotted_player", "alley_enc_enemy_damaged", "_stealth_spotted" );
	}
	
	// The dog is going to attack now so alert AI if they're alive
	flag_set( "alley_enc_ai_alert" );
	
	// Dog not in stealth so tell him to seek
	self player_seek_coop();
}

encounter_alley_alert()
{
	level endon( "yard_enc_setup" );
	
	flag_wait( "alley_enc_ai_alert" );
	
	// Use the appropriate delay
	stealth_custom_prespotted_delay();
	
	stealth_alert_living_ai();
}

on_enemy_ai_alley_dog()
{
	self endon( "death" );
	
	while ( 1 )
	{
		self waittill( "enemy" );
		
		if ( !IsDefined( self.enemy ) || !IsAlive( self.enemy ) || !IsPlayer( self.enemy ) )
			continue;

		flag_set( "alley_enc_dog_spotted_player" );
		return;
	}
}

encounter_alley_dog_attack( ai_dog, ai_victim )
{
	AssertEx( IsDefined( ai_dog ) && IsAlive( ai_dog ), "Dog not valid." );
	AssertEx( IsDefined( ai_victim ) && IsAlive( ai_victim ), "Victim not valid." );
	
	if ( !IsAlive( ai_dog ) || !IsAlive( ai_victim ) )
		return;
		
	ai_dog		endon( "death" );
	ai_victim	endon( "death" );
	
	// Wait for the civilian to get to his first node
	flag_wait( "alley_enc_dog_attack" );
	
	// Fire off some big lightning!
	flag_set( "lightning_now" );
	
	ai_victim.ignoreme		= false;
	ai_victim.team			= "allies";
	
	ai_dog.ignoreme			= false;
	ai_dog.ignoreall		= false;
	ai_dog.meleeAlwaysWin	= true;
	ai_dog.favoriteenemy 	= ai_victim;
	
	ai_dog GetEnemyInfo( ai_victim );
}

on_spawn_ai_alley_enemy()
{
	self endon( "death" );
	
	self thread maps\_util_carlos::light_on_gun();
	
	self.patrol_walk_anim = "_stealth_combat_jog";
	self maps\_patrol::patrol();
}

on_damage_ai_alley_enemy()
{
	self waittill_any( "damage", "death" );
	
	flag_set( "alley_enc_ai_damaged" );
}

// -.-.-.-.-.-.-.-.-.-.-.-. Encounter: Yard  -.-.-.-.-.-.-.-.-.-.-.-. //

encounter_yard()
{
	flag_wait( "yard_enc_setup" );
	
	thread encounter_yard_spawn_ai();
	thread on_trigger_encounter_yard_cqb_group();
}

encounter_yard_spawn_ai()
{
	spawners_yard = [];
	
	spawners = GetEntArray( "ai_yard_group", "targetname" );
	array_spawn_function( spawners, ::on_spawn_ai_yard_stand );
	spawners_yard = array_combine( spawners_yard, spawners );
	
	spawners = GetEntArray( "ai_yard_patroller", "targetname" );
	array_spawn_function( spawners, ::on_spawn_ai_yard_patroller );
	spawners_yard = array_combine( spawners_yard, spawners );
	
	spawners = GetEntArray( "ai_yard_cqb", "targetname" );
	array_spawn_function( spawners, ::on_spawn_ai_yard_patroller );
	spawners_yard = array_combine( spawners_yard, spawners );
	
	thread array_spawn( spawners_yard, true, true );
}

on_spawn_ai_yard_stand()
{
	self endon( "death" );
	
	if ( self.type != "dog" )
	{
		self maps\_util_carlos::light_on_gun();
	}
}

on_spawn_ai_yard_patroller()
{
	self endon( "death" );
	
	self.moveplaybackrate = 0.95;
	self maps\_util_carlos::light_on_gun();
	self thread on_path_end_remove_gun_light();
	
	self enable_cqbwalk();
	self waittill( "event_awareness" );
	self disable_cqbwalk();
}

on_spawn_ai_yard_cqb()
{
	self.pathrandompercent 	= 200;
	self maps\_util_carlos::light_on_gun();
}

on_trigger_encounter_yard_cqb_group()
{
	trigger_wait_targetname( "trigger_yard_cqb_group" );
	
	// AI spawn targetting a node that waits on this flag.
	flag_set( "yard_enc_start_cqp_patrol" );
}

// -.-.-.-.-.-.-.-.-.-.-.-. Encounter: Apartment  -.-.-.-.-.-.-.-.-.-.-.-. //

encounter_apartment()
{
	flag_wait( "apartment_enc_setup" );
	
	thread encounter_apartment_site_range_think();
	thread encounter_apartment_spawn_ai();
}

encounter_apartment_site_range_think()
{
	stealth_event_distance_override_apartment();
	flag_wait( "apartment_enc_exit" );
	stealth_event_distance_override();
}

encounter_apartment_spawn_ai()
{
	thread encounter_apartment_spawn_patroller_with_flashlight();
	
	spawners_apartment = [];
	
	spawners = GetEntArray( "ai_apt_begin", "targetname" );
	spawners_apartment = array_combine( spawners_apartment, spawners );
	
	spawners = GetEntArray( "ai_apt_smokers", "targetname" );
	array_spawn_function( spawners, ::on_death_ai_apt_smokers );
	spawners_apartment = array_combine( spawners_apartment, spawners );
	
	spawners = GetEntArray( "ai_apt_sleep", "targetname" );
	spawners_apartment = array_combine( spawners_apartment, spawners );
	
	spawners = GetEntArray( "ai_apt_end", "targetname" );
	spawners_apartment = array_combine( spawners_apartment, spawners );
	
	array_spawn( spawners_apartment, true, true );
}

encounter_apartment_spawn_patroller_with_flashlight()
{
	
	spawner = GetEnt( "ai_apt_flashlight", "targetname" );
//	spawner add_spawn_function( ::on_spawn_ai_apt_flashlight_manage_ignore );
	spawner add_spawn_function( ::on_damage_ai_apt_flashlight );
	
	// Don't spawn this AI until we have to, he's been troublesome
	// getting alerted when he shouldn't
	//group_flag_alert = self maps\_stealth_utility::stealth_get_group_spotted_flag();
	
	msg = flag_wait_any_return
				(
					"apartment_enc_flashlight_patrol", 
					"apartment_enc_smokers_dead",
					"apartment_enc_flashlight_damaged",
					"_stealth_spotted"
				);
				
	ai = spawner spawn_ai( true );
	
	if ( msg != "_stealth_spotted" )
	{
		ai endon( "damage" );
		ai endon( "death" );
	
		flag_wait( "apartment_enc_flashlight_patrol" );
	
		ai thread on_spawn_ai_active_patrol( undefined, 0.85 );
		ai thread on_alert_ai_apartment_flashlight();
	}
}

on_spawn_ai_apt_flashlight_manage_ignore()
{
	self endon( "death" );
	
	self RemoveAIEventListener( "bulletwhizby" );
	self RemoveAIEventListener( "gunshot" );
	self RemoveAIEventListener( "gunshot_teammate" );
	self RemoveAIEventListener( "projectile_impact" );
	
	group_flag_alert = self maps\_stealth_utility::stealth_get_group_spotted_flag();
	
//	msg = flag_wait_any_return
	flag_wait_any
				(
					"apartment_enc_flashlight_patrol", 
					"apartment_enc_smokers_dead",
					"apartment_enc_flashlight_damaged",
					"_stealth_spotted", 
					group_flag_alert
				);
	
//	// Incase a bullet impact happens a bit after the flags are set
//	if ( msg == "apartment_enc_smokers_dead" )
//	{
		wait 0.5;
//	}
	
	self AddAIEventListener( "bulletwhizby" );
	self AddAIEventListener( "gunshot" );
	self AddAIEventListener( "gunshot_teammate" );
	self AddAIEventListener( "projectile_impact" );
}

on_damage_ai_apt_flashlight()
{
	self waittill( "damage" );
	flag_set( "apartment_enc_flashlight_damaged" );
}

on_death_ai_apt_smokers()
{
	if ( !IsDefined( level.so_prague_apt_smokers_living ) )
	{
		level.so_prague_apt_smokers_living = 1;
	}
	else
	{
		level.so_prague_apt_smokers_living++;
	}
	
	self waittill( "death" );
	
	level.so_prague_apt_smokers_living--;
	
	// If both smokers are dead make the flashlight patroller
	// completely aware
	if ( level.so_prague_apt_smokers_living <= 0 )
	{
		flag_set( "apartment_enc_smokers_dead" );
		level.so_prague_apt_smokers_living = undefined;
	}
}

on_alert_ai_apartment_flashlight()
{
	self endon( "death" );
	
	self maps\_stealth_utility::stealth_group_spotted_flag_wait();
	
	self.moveplaybackrate = 1.0;
}

// -.-.-.-.-.-.-.-.-.-.-.-. Encounter: Quad  -.-.-.-.-.-.-.-.-.-.-.-. //

encounter_quad()
{
	flag_wait( "quad_enc_setup" );
	
	thread encounter_quad_poi_team_hop_fence();
	thread encounter_quad_execution();
	thread encounter_quad_spawn_ai();
}

encounter_quad_poi_team_hop_fence()
{
	level endon( "special_op_terminated" );
	
	flag_wait( "shop_enc_player_over_fence" );
	
	trigger	= GetEnt( "trigger_quad_poi_over_fence", "targetname" );

	thread encounter_quad_poi_team_head_to_fence();
	thread encounter_quad_poi_team_teleport();
	
	// Ongoing thread that sends pois to the trigger area
	// and then one by one sends them over the fence
	while ( 1 )
	{	
		trigger waittill( "trigger", activator );
		
		if	(
				!IsDefined( activator )
			||	!IsAlive( activator )
			||	( IsDefined( activator.poi_over_fence ) && activator.poi_over_fence == true )
			)
		{
			continue;
		}
		
		activator encounter_quad_poi_hop_fence();
		wait 0.05;
	}
}

encounter_quad_poi_team_head_to_fence()
{
	level endon( "special_op_terminated" );
	
	wait_struct	= getstruct( "wait_struct_poi_fence", "targetname" );
	
	while ( 1 )
	{
		// If the player has not yet collected any poi continue
		if ( !IsDefined( level.so_prague_poi_array ) )
		{
			wait 0.05;
			continue;
		}
		
		// Make sure any currently gathered POIs have
		// have been sent to the over the fence trigger
		foreach ( poi in level.so_prague_poi_array )
		{
			if ( !IsDefined( poi ) || !IsAlive( poi ) )
				continue;
			
			// If the poi isn't yet over the fence, send them to the trigger
			if	(
					( !IsDefined( poi.poi_over_fence ) || poi.poi_over_fence == false )
				&&	( !IsDefined( poi.poi_mid_fence_hop ) || poi.poi_mid_fence_hop == false )
				)
			{
				poi.override_poi_pathing = true;
				poi SetGoalPos( wait_struct.origin );
			}
		}
		
		wait 0.25;
	}
}

encounter_quad_poi_team_teleport()
{
	level endon( "special_op_terminated" );
	
	trigger		= GetEnt( "trigger_player_far_from_fence", "targetname" );
	tele_struct	= getstruct( "tele_struct_poi_over_fence", "targetname" );
	while( 1 )
	{
		if ( !IsDefined( level.so_prague_poi_array ) )
		{
			wait 0.1;
			continue;
		}
		
		// Check to see if the players are touching the teleport
		// trigger
		all_players_in_trigger = true;
		foreach ( player in level.players )
		{
			if ( !player IsTouching( trigger ) )
			{
				all_players_in_trigger = false;
				break;
			}
		}
		
		// If the players are not in the trigger, wait and check again 
		if ( !all_players_in_trigger )
		{
			wait 0.1;
			continue;
		}
		
		// Teleport any POIs not currently hopping the fence
		foreach( poi in level.so_prague_poi_array )
		{
			if	(
					( IsDefined( poi.poi_over_fence ) && poi.poi_over_fence == true )
				||	( IsDefined( poi.poi_mid_fence_hop ) && poi.poi_mid_fence_hop == true )
				)
			{
				continue;
			}
			
			poi ForceTeleport( tele_struct.origin, tele_struct.angles );
			poi thread on_over_fence_manage_poi();
			
			wait 0.1;
		}
		
		wait 0.1;
	}
}

encounter_quad_poi_hop_fence()
{
	self endon( "death" );
	
	anim_struct	= getstruct( "anim_struct_poi_over_fence", "targetname" );
	finish_struct	= getstruct( "anim_struct_poi_over_fence_done", "targetname" );
	
	self.override_poi_pathing = true;
	self.poi_mid_fence_hop = true;
	goalradius_start = self.goalradius;
	self.goalradius = 12;
	
	anim_struct anim_generic_reach( self, "rebel_hop_fence" );
	anim_struct anim_generic( self, "rebel_hop_fence" );
	
	self ForceTeleport( finish_struct.origin, finish_struct.angles );
	
	self.goalradius				= goalradius_start;
	self.override_poi_pathing	= undefined;
	self.poi_mid_fence_hop		= undefined;
	
	self thread on_over_fence_manage_poi();
}

encounter_quad_player_near_fence()
{
	fence_trigger = GetEnt( "trigger_quad_player_near_fence", "targetname" );

	foreach ( player in level.players )
	{
		if ( player IsTouching( fence_trigger ) )
		{
			return true;
		}
	}
	
	return false;
}

// Keep each poi away from the fence once they've hopped it
on_over_fence_manage_poi()
{
	level endon( "special_op_terminated" );
	self endon( "death" );
	
	if ( IsDefined( self.poi_over_fence ) )
	{
		AssertMsg( "POI given over fence management logic twice!" );
		return;
	}
	
	self.poi_over_fence = true;
	
	if ( !IsDefined( level.poi_fence_loc_index ) )
	{
		level.poi_fence_loc_index = 0;
	}
	
	level.poi_fence_loc_index++;
	
	loc_struct = getstruct( "fence_wait_struct0" + level.poi_fence_loc_index, "targetname" );
	Assert( IsDefined( loc_struct ) );
	
	while ( 1 )
	{
		if ( encounter_quad_player_near_fence() )
		{
			self PushPlayer( true );
			self.override_poi_pathing = true;
			self SetGoalPos( loc_struct.origin );
		}
		else
		{
			self PushPlayer( false );
			self.override_poi_pathing = false;
		}
		
		wait 0.1;
	}
}

encounter_quad_spawn_ai()
{
	spawners_quad = [];
	
	spawners = GetEntArray( "ai_quad", "targetname" );
	array_spawn_function( spawners, ::on_spawn_ai_quad_enemy );
	array_spawn_function( spawners, ::encounter_quad_execution_ignore_teammate_fire );
	spawners_quad = array_combine( spawners_quad, spawners );

	spawners = GetEntArray( "ai_quad_cqb", "targetname" );
	array_spawn_function( spawners, ::on_spawn_ai_quad_cqb );
	spawners_quad = array_combine( spawners_quad, spawners );
	
	array_spawn( spawners_quad, true, true );
}

on_spawn_ai_quad_enemy()
{
	if ( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "gun_light" )
	{
		self maps\_util_carlos::light_on_gun();
	}
}

on_spawn_ai_quad_enemy_sniper()
{
	self.health = 1;
	self.goalradius = 1;
	self SetGoalPos( self.origin );
}

encounter_quad_execution()
{
	encounter_quad_execution_think();
	flag_set( "quad_enc_execution_done" );
}

encounter_quad_execution_think()
{
	// Spawn the civilian and the enemy hiding behind the wall
	civ = spawn_targetname( "ai_quad_civ_die", true );
	civ.ignoreme	= true;
	civ.ignoreall	= true;
	
	enemy = spawn_targetname( "ai_quad_execute", true );
	enemy endon( "death" );
	enemy endon( "damage" );
	enemy endon( "event_awareness" );
	
	// End this sequence if the execution group's stealth
	// flag gets set but not if the global flag gets set
	group_alert_flag = enemy maps\_stealth_utility::stealth_get_group_spotted_flag();
	level endon( group_alert_flag );
	
	enemy thread on_civ_keeper_death( civ );
	enemy maps\_util_carlos::light_on_gun();
	
	flag_wait( "quad_enc_execution" );
	
	if ( !IsAlive( civ ) )
		return;
	
	civ thread on_death_ai_civ_quad();
	
	enemy thread encounter_quad_execution_ignore_teammate_fire();
	
	node = get_target_ent( "struct_civ_execute" );
	
	civ thread on_saved_ai_quad_execution( enemy, node );
	civ.deathanim = getgenericanim( "prague_interrogate_2_civ_kill" );
	civ thread on_anim_ending_event( node );
	node thread anim_generic( civ, "prague_interrogate_2_civ_drag" );
	
	enemy thread on_anim_ending_event( node );
	enemy thread encounter_quad_execution_shoot();
	node anim_generic( enemy, "prague_interrogate_2_soldier_drag" );
	
	if ( IsAlive( civ ) )
	{
		civ Kill( self.origin, enemy );
	}
	
	node anim_generic_run( enemy, "prague_interrogate_2_soldier_kill" );
}

encounter_quad_execution_shoot()
{
	self endon( "death" );
	wait 1.0;
	while ( self getAnimTime( getgenericanim( "prague_interrogate_2_soldier_drag" ) ) < 0.96 )
	{
		wait ( 0.05 );
	}

	self Shoot();
	wait 0.15;
	self Shoot();
	wait 0.1;
	self Shoot();
}

encounter_quad_execution_ignore_teammate_fire()
{
	level endon( "_stealth_spotted" );
	self endon( "death" );
	
	flag_wait( "quad_enc_execution" );
	
	self RemoveAIEventListener( "gunshot_teammate" );
	
	flag_wait_any( "quad_enc_execution_done", "_stealth_spotted" );
	
	self AddAIEventListener( "gunshot_teammate" );
}

on_death_ai_civ_quad()
{
	self waittill( "death", attacker );
	
	if ( !flag( "quad_enc_execution_done" ) && IsDefined( attacker ) && IsDefined( attacker.team ) && attacker.team == "axis" )
	{
		self.target = "ignore_corpse";
	}
}

// This thread cleans up the civilian if the 
// whole kill sequence is interrupted before
// it even starts. 
on_civ_keeper_death( civilian )
{
	// Once the kill sequence starts
	// end this thread.
	level endon( "quad_enc_execution" );
	
	self waittill_any( "death", "damage", "event_awareness" );
	
	if ( IsAlive( civilian ) )
	{
		civilian Kill( self.origin, self );
	}
}

on_saved_ai_quad_execution( executioner, node )
{
	self endon( "death" );
	
	// If the civilian is still alive after this flag
	// he survived the execution.
	flag_wait( "quad_enc_execution_done" );
	
	if ( IsDefined( executioner ) && IsAlive( executioner ) )
	{
		// Have the civilian idle on the ground until the executioner is dead
		node thread anim_generic_loop( self, "prague_interrogate_2_civ_idle" );
		executioner waittill_any_timeout( 3.0, "death" );
		node notify( "stop_loop" );
	}
	else
	{
		wait 1.0;
	}
	
	self StopAnimScripted();
	self poi_make_collectible( false, level.so_prague_poi_see_delay );
}

on_spawn_ai_quad_cqb()
{
	self endon( "death" );
	
	self.moveplaybackrate = 1.05;
	self maps\_util_carlos::light_on_gun();
	
	self enable_cqbwalk();
	self waittill_any( "event_awareness", "reached_path_end" );
	self disable_cqbwalk();
}

// -.-.-.-.-.-.-.-.-.-.-.-. Encounter: Shop  -.-.-.-.-.-.-.-.-.-.-.-. //

encounter_shop()
{
	flag_wait( "shop_enc_exit_quad" );
	
	thread encounter_shop_spawn_ai();
	thread encounter_shop_level_end_think();
}

encounter_shop_spawn_ai()
{
	spawners_shop_enc = [];
	
	// AI in shop
	spawners = GetEntArray( "ai_shop_patrol", "targetname" );
	array_spawn_function( spawners, ::on_spawn_ai_active_patrol, "shop_enc_player_over_fence", 0.8 );
	spawners_shop_enc = array_combine( spawners_shop_enc, spawners );
	
	spawners = GetEntArray( "ai_shop_idle", "targetname" );
	spawners_shop_enc = array_combine( spawners_shop_enc, spawners );
	
	// AI in monument
	spawners = GetEntArray( "ai_shop_monument", "targetname" );
	array_spawn_function( spawners, maps\_util_carlos::light_on_gun );
	spawners_shop_enc = array_combine( spawners_shop_enc, spawners );
	
	// AI in monument
	spawners = GetEntArray( "ai_shop_monument_dog", "targetname" );
	spawners_shop_enc = array_combine( spawners_shop_enc, spawners );
	
	array_spawn_function( spawners, ::on_encounter_shop_clear );
	
	array_spawn( spawners_shop_enc, true, true );
}

on_encounter_shop_clear()
{
	level endon( "special_op_terminated" );
	level endon( "missionfailed" );
	
	if ( !IsDefined( level.encounter_shop_ai_count ) )
	{
		level.encounter_shop_ai_count = 0;
	}
	
	level.encounter_shop_ai_count++;
	
	self waittill( "death" );
	
	level.encounter_shop_ai_count--;
	
	if ( level.encounter_shop_ai_count <= 0 )
	{
		flag_set( "encounter_shop_clear" );
	}
}

encounter_shop_level_end_think()
{
	level endon( "special_op_terminated" );
	
	// Spawn Smoke Fx
	PlayFX( getfx( "extraction_smoke" ), getstruct( "fx_level_exit_smoke", "targetname" ).origin );
	
	flag_wait( "shop_enc_player_near_end" );
	
	if ( !flag( "encounter_shop_clear" ) )
	{
		flag_wait( "encounter_shop_clear" );
	}
	
	// No more nice kill talk
	flag_set( "axis_kill_radio_paused" );
	
	radio_dialogue( "so_ste_prague_mct_doubletime" );
}

// -.-.-.-.-.-.-.-.-.-.-.-. Custom End of Game Summary  -.-.-.-.-.-.-.-.-.-.-.-. //

CONST_POINTS_GAMESKILL		= 10000;
CONST_POINTS_STEALTH_KILL	= 50;
CONST_POINTS_HEAD_SHOT		= 25;
CONST_POINTS_CIV_RESCUED	= 300;
CONST_POINTS_TIME			= 6000;
CONST_TIME_MIL_MIN			= 420000;	// 7 minutes (420 seconds ) is the minimum time resulting in score

custom_eog_summary()
{
	// Time String
	time_mil			= level.challenge_end_time - level.challenge_start_time;
	time_string_final	= convert_to_time_string( time_mil * 0.001, true );
	
	// Figure out the total score using the following values
	//	*Type*			*Count*	*Points*	*Total*
	//	Civs			7		300			2100
	//	Headshots		45		25			1125
	//	Stealth Kills	45		50			2250
	//	Time			80/300	6000		4400
	
	//							Total		9875 < 10000

	// Score: Game Skill
	score_gameskill = level.specops_reward_gameskill * CONST_POINTS_GAMESKILL;
	
	// Score: Time
	time_mil_remain		= Int( Max( CONST_TIME_MIL_MIN - time_mil, 0 ) );
	score_time = int( ( time_mil_remain / CONST_TIME_MIL_MIN ) * CONST_POINTS_TIME );
	score_time = Int( Min( score_time, CONST_POINTS_TIME - 1 ) );
	
	// Score: Stealth Kills, Headshots and Rebels Rescued
	score_stealth_kills	= 0;
	score_civs_saved	= 0;
	score_head_shots	= 0;
	foreach ( player in level.players )
	{
		score_stealth_kills +=	player.stat_stealth_kills	*	CONST_POINTS_STEALTH_KILL;
		score_civs_saved	+=	player count_civs_rescued()	*	CONST_POINTS_CIV_RESCUED;
		score_head_shots 	+=	player.stat_head_shots 		*	CONST_POINTS_HEAD_SHOT;
	}
	
	score_final = score_gameskill + score_time + score_stealth_kills + score_civs_saved + score_head_shots;
	
	score_max = score_gameskill + CONST_POINTS_GAMESKILL - 1;
	AssertEx( score_final <= score_max, "Score should never go above gameskill * 10000 + 9999. The score came out to: " + score_final );
	score_final = Int( Min( score_final, score_max ) );
	
	// Cap the score
	score_final = int( min( score_final, score_max ) );
	
	foreach ( player in level.players )
	{
		setdvar( "ui_hide_hint", 1 );
		
		p1_diff_string			= so_get_difficulty_menu_string( player.gameskill );
		p1_stealth_kills		= player.stat_stealth_kills;
		p1_head_shots			= player.stat_head_shots;
		p1_civs_rescued			= player count_civs_rescued();
		
		if ( is_coop() )
		{
			p2_diff_string		= so_get_difficulty_menu_string( get_other_player( player ).gameskill );
			p2_stealth_kills	= get_other_player( player ).stat_stealth_kills;
			p2_head_shots		= get_other_player( player ).stat_head_shots;
			p2_civs_rescued		= get_other_player( player ) count_civs_rescued();
						
			if ( IsDefined( level.MissionFailed ) && level.MissionFailed == true )
			{
				player add_custom_eog_summary_line( "", 										"@SPECIAL_OPS_PERFORMANCE_YOU",	"@SPECIAL_OPS_PERFORMANCE_PARTNER" );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_DIFFICULTY",				p1_diff_string,					p2_diff_string );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TIME", 					time_string_final,				time_string_final );
				player add_custom_eog_summary_line( "@SO_STEALTH_PRAGUE_KILLS_STEALTH",			p1_stealth_kills,				p2_stealth_kills );
				player add_custom_eog_summary_line( "@SO_STEALTH_PRAGUE_CIVS_RESCUED",			p1_civs_rescued,				p2_civs_rescued );
				player add_custom_eog_summary_line( "@SO_STEALTH_PRAGUE_HEAD_SHOTS",			p1_head_shots,					p2_head_shots );
			}
			else
			{
				player add_custom_eog_summary_line( "", 										"@SPECIAL_OPS_PERFORMANCE_YOU",	"@SPECIAL_OPS_PERFORMANCE_PARTNER",	"@SPECIAL_OPS_UI_SCORE");
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_DIFFICULTY",				p1_diff_string,					p2_diff_string,						score_gameskill );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TIME", 					time_string_final,				time_string_final,					score_time );
				player add_custom_eog_summary_line( "@SO_STEALTH_PRAGUE_KILLS_STEALTH",			p1_stealth_kills,				p2_stealth_kills,					score_stealth_kills );
				player add_custom_eog_summary_line( "@SO_STEALTH_PRAGUE_CIVS_RESCUED",			p1_civs_rescued,				p2_civs_rescued,					score_civs_saved );
				player add_custom_eog_summary_line( "@SO_STEALTH_PRAGUE_HEAD_SHOTS",			p1_head_shots,					p2_head_shots,						score_head_shots );
				if ( !isSplitscreen() )
					player add_custom_eog_summary_line_blank();
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TEAM_SCORE",																					score_final );
			}

		}
		else
		{
			if ( IsDefined( level.MissionFailed ) && level.MissionFailed == true )
			{
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_DIFFICULTY",				p1_diff_string );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TIME", 					time_string_final );
				player add_custom_eog_summary_line( "@SO_STEALTH_PRAGUE_KILLS_STEALTH",			p1_stealth_kills );
				player add_custom_eog_summary_line( "@SO_STEALTH_PRAGUE_CIVS_RESCUED",			p1_civs_rescued );
				player add_custom_eog_summary_line( "@SO_STEALTH_PRAGUE_HEAD_SHOTS",			p1_head_shots );
			}
			else
			{
				player add_custom_eog_summary_line( "", 										"@SPECIAL_OPS_PERFORMANCE_YOU",	"@SPECIAL_OPS_UI_SCORE");
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_DIFFICULTY",				p1_diff_string,					score_gameskill );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TIME", 					time_string_final,				score_time );
				player add_custom_eog_summary_line( "@SO_STEALTH_PRAGUE_KILLS_STEALTH",			p1_stealth_kills,				score_stealth_kills );
				player add_custom_eog_summary_line( "@SO_STEALTH_PRAGUE_CIVS_RESCUED",			p1_civs_rescued,				score_civs_saved );
				player add_custom_eog_summary_line( "@SO_STEALTH_PRAGUE_HEAD_SHOTS",			p1_head_shots,					score_head_shots );				
				if ( !isSplitscreen() )
					player add_custom_eog_summary_line_blank();
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_SCORE_FINAL",												score_final );
			}
		}
		
		if ( IsDefined( level.MissionFailed ) || level.MissionFailed == false )
		{
			// Override each player's time with the final time
			player override_summary_time( time_mil );
			player override_summary_score( score_final );
		}
	}
}

count_civs_rescued()
{
	if ( !IsDefined( self.stat_civs_rescued ) )
	{
		return 0;
	}
	
	count = 0;
	
	foreach ( civ in self.stat_civs_rescued )
	{
		if ( IsDefined( civ ) && IsAlive( civ ) )
		{
			count++;
		}
	}
	return count;
}

count_civs_rescued_all_players()
{
	count = 0;
	foreach ( player in level.players )
	{
		count += player count_civs_rescued();
	}
	
	return count;
}