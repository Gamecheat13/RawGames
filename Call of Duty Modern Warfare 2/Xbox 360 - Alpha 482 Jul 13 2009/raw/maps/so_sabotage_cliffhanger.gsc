#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_specialops;
#include maps\_hud_util;
#include maps\_stealth_utility;
#include maps\_stealth_shared_utilities;
#include maps\_vehicle;
#include maps\_blizzard;

// ------------- tweakables -------------

CONST_regular_obj			= &"SO_SABOTAGE_CLIFFHANGER_OBJ_REGULAR";
CONST_hardened_obj			= &"SO_SABOTAGE_CLIFFHANGER_OBJ_HARDENED";
CONST_veteran_obj			= &"SO_SABOTAGE_CLIFFHANGER_OBJ_VETERAN";

CONST_regular_accuracy		= 2; 		// accuracy modifier
CONST_hardened_accuracy		= 2; 		// accuracy modifier
CONST_veteran_accuracy		= 1.75; 	// accuracy modifier

// ------------- ---------- -------------

main()
{
	// optimization
	setsaveddvar( "sm_sunShadowScale", 0.5 );
	setsaveddvar( "r_lightGridEnableTweaks", 1 );
	setsaveddvar( "r_lightGridIntensity", 1.5 );
	setsaveddvar( "r_lightGridContrast", 0 );
	
	precacheShader( "waypoint_checkpoint_neutral_a" );
	precacheShader( "waypoint_checkpoint_neutral_b" );
	precacheShader( "waypoint_checkpoint_neutral_c" );
	precacheShader( "waypoint_checkpoint_neutral_d" );
	precacheShader( "waypoint_checkpoint_neutral_e" );
	PreCacheShader( "overlay_frozen" );
	
	level.target_shader_array = [];
	level.target_shader_array[ 0 ] = "waypoint_checkpoint_neutral_a";
	level.target_shader_array[ 1 ] = "waypoint_checkpoint_neutral_b";
	level.target_shader_array[ 2 ] = "waypoint_checkpoint_neutral_c";
	level.target_shader_array[ 3 ] = "waypoint_checkpoint_neutral_d";
	//level.target_shader_array[ 4 ] = "waypoint_checkpoint_neutral_e";
	
	level.number_of_targets	= level.target_shader_array.size;
	
	level.strings[ "hint_c4_plant" ]					= &"SCRIPT_PLATFORM_HINTSTR_PLANTEXPLOSIVES";
	level.strings[ "leaving_while_incomplete_warning" ] = &"SO_SABOTAGE_CLIFFHANGER_LEAVING_WHILE_INCOMPLETE_WARNING";
	level.strings[ "leaving_while_incomplete" ] 		= &"SO_SABOTAGE_CLIFFHANGER_LEAVING_WHILE_INCOMPLETE";
	level.strings[ "specops_challenge_success" ] 		= &"SPECIAL_OPS_CHALLENGE_SUCCESS";
	
	// from precache script
	maps\cliffhanger_precache::main();
	
	// Special Op mode deleting all original spawn triggers, vehicles and spawners
	so_delete_all_by_type( ::type_spawn_trigger, ::type_vehicle_special, ::type_spawners_special );
	
	// delete chad's new snowmobiles
	new_sm = getentarray( "script_vehicle_snowmobile_coop_alt", "classname" );
	new_sm2 = getentarray( "script_vehicle_snowmobile_coop", "classname" );
	voltron_array = array_combine( new_sm, new_sm2 );
	foreach( sm in voltron_array )
		sm delete();
	
	// setup truck ==============================================
	truck_patrol = getent( "truck_patrol", "targetname" );
	truck_patrol.target = "truck_patrol_target" ;

	default_start( ::start_so_sabotage );
	add_start( "sabotage", ::start_so_sabotage );
	
	flags_init();

	// init stuff
	//common_scripts\_destructible_types_anim_light_fluo_on::main();
	maps\cliffhanger_fx::main();

	maps\cliffhanger_anim::generic_human();
	maps\cliffhanger_anim::script_models();
	maps\cliffhanger_anim::player_anims();
	
	maps\_load::main();

	thread maps\cliffhanger_amb::main();
	maps\createart\cliffhanger_art::main();
	
	maps\_idle::idle_main();
	maps\_idle_coffee::main();
	maps\_idle_smoke::main();
	maps\_idle_lean_smoke::main();
	maps\_idle_phone::main();
	maps\_idle_sleep::main();
	maps\_idle_sit_load_ak::main();
	
	maps\_patrol_anims::main();

	maps\_stealth::main();
	stealth_settings();
	thread so_stealth_music_control();
	
	// no weapon reloading inform during coop since this is stealth
	level.so_override[ "skip_inform_reloading" ] 	= true;
	//level.so_override[ "inform_reloading" ]		= "some kind of radio voice informing weapon reload";
	
	foreach ( player in level.players )
	{
		player stealth_plugin_basic();
		player thread playerSnowFootsteps();
	}
	
	maps\_compass::setupMiniMap( "compass_map_cliffhanger" );
}

so_stealth_music_control()
{
	level endon ( "stop_stealth_music" );
	while( 1 )
	{
		thread stealth_music_hidden_loop();
		flag_wait( "_stealth_spotted" );
		music_stop( .2 );
		wait .5;
		thread stealth_music_busted_loop();
		flag_waitopen( "_stealth_spotted" );
		music_stop( 3 );
		wait 3.25;
	}
}

stealth_music_hidden_loop()
{
	cliffhanger_stealth_music_TIME 		 		 = 174;
	level endon( "_stealth_spotted" );
	while( 1 )
	{
		MusicPlayWrapper( "cliffhanger_stealth" );
		wait cliffhanger_stealth_music_TIME;
		wait 10;
	}
}

stealth_music_busted_loop()
{
	cliffhanger_stealth_busted_music_TIME 		 = 120;
	level endon( "_stealth_spotted" );
	while( 1 )
	{
		MusicPlayWrapper( "cliffhanger_stealth_busted" );
		wait cliffhanger_stealth_busted_music_TIME;
		wait 3;
	}
}

type_spawners_special()
{
	special_case = !( isdefined( self.script_noteworthy ) && self.script_noteworthy == "high_threat_spawner" );
	test = 0;
	if( !special_case )
		test = 0;
		
	original_case = self type_spawners();
	return special_case && original_case;	
}

type_vehicle_special()
{
	// keep all collmaps
	if ( isdefined( self.code_classname ) && self.code_classname == "script_vehicle_collmap" )
		return false;

	special_case = !( isdefined( self.script_noteworthy) && self.script_noteworthy == "tarmac_snowmobile" );
	special_case2 = !( isdefined( self.targetname) && self.targetname == "truck_patrol" );

	original_case = self type_vehicle();
	
	test = 0;
	if( original_case )
		test = 0;
		
	return special_case && special_case2 && original_case;
}

so_setup_regular()
{
	level.challenge_objective 	= CONST_regular_obj;
	level.new_enemy_accuracy	= CONST_regular_accuracy;
}

so_setup_hardened()
{
	level.challenge_objective 	= CONST_hardened_obj;
	level.new_enemy_accuracy 	= CONST_hardened_accuracy;
}

so_setup_veteran()
{
	level.challenge_objective 	= CONST_veteran_obj;
	level.new_enemy_accuracy	= CONST_veteran_accuracy;
}

flags_init()
{
	flag_init( "challenge_start" );
	flag_init( "sabotage_success" );
	flag_init( "explosives_planted" );
	flag_init( "escaped_trigger" );
	flag_init( "stop_stealth_music" );
	flag_init( "someone_became_alert" );	
	
	flag_init( "explosives_ready" );
	
	// dummy flags 
	flag_init( "destroyed_fallen_tree_cliffhanger01" );
	flag_init( "script_attack_override" );
	
	// ===========
	flag_init( "truck_guys_alerted" );
	
	flag_init( "jeep_blown_up" );
	flag_init( "jeep_stopped" );
	flag_init( "first_two_guys_in_sight" );
	
	flag_init( "done_with_stealth_camp" );
}


set_flags()
{
	flag_set( "first_two_guys_in_sight" );
	
}

// ==================================================================================
// ================================= gameplay logic =================================
// ==================================================================================

spawn_funcs()
{
	add_global_spawn_function( "axis", ::enemy_nerf );
	
	array_thread( GetEntArray( "start_crate_patroller", "script_noteworthy" ), ::add_spawn_function, ::tent_1_patrollers );
	array_thread( GetEntArray( "start_crate_patroller", "script_noteworthy" ), ::add_spawn_function, ::tent_1_crate_patroller );
	array_thread( GetEntArray( "start_quonset_patroller", "script_noteworthy" ), ::add_spawn_function, ::tent_1_patrollers );
	array_thread( GetEntArray( "right_side_start_guy", "script_noteworthy" ), ::add_spawn_function, ::right_side_start_patroller );

	array_thread( GetEntArray( "2story_leaner", "script_noteworthy" ), ::add_spawn_function, ::camp_leaner );
	array_thread( GetEntArray( "2story_sitter", "script_noteworthy" ), ::add_spawn_function, ::twostory_sitter );
	array_thread( GetEntArray( "container_leaner", "script_noteworthy" ), ::add_spawn_function, ::camp_leaner );
	
	array_thread( GetEntArray( "high_threat_spawner", "script_noteworthy" ), ::add_spawn_function, ::snowmobile_dudes );
	
	array_thread( GetEntArray( "blue_building_smoker", "script_noteworthy" ), ::add_spawn_function, maps\cliffhanger_code::reduce_footstep_detect_dist );
	array_thread( GetEntArray( "blue_building_loader", "script_noteworthy" ), ::add_spawn_function, maps\cliffhanger_code::reduce_footstep_detect_dist );
	array_thread( GetEntArray( "blue_building_smoker", "script_noteworthy" ), ::add_spawn_function, maps\cliffhanger_code::increase_fov_when_player_is_near );
	array_thread( GetEntArray( "blue_building_loader", "script_noteworthy" ), ::add_spawn_function, maps\cliffhanger_code::increase_fov_when_player_is_near );
	
	wind_blown_flags = GetEntArray( "wind_blown_flag", "targetname" );
	array_thread( wind_blown_flags, ::wind_blown_flag_think );
	
	level.tarmac_snowmobiles = GetEntArray( "tarmac_snowmobile", "script_noteworthy" );
	array_thread( level.tarmac_snowmobiles, ::tarmac_snowmobile_think );
}

sabotage_init()
{
	add_hint_string( "leaving_while_incomplete_warning", level.strings[ "leaving_while_incomplete_warning" ] );
	
	spawn_funcs();
	
	assert( isdefined( level.gameskill ) );
	switch( level.gameSkill )
	{
		case 0:								// Easy
		case 1:	so_setup_Regular();	break;	// Regular
		case 2:	so_setup_hardened();break;	// Hardened
		case 3:	so_setup_veteran();	break;	// Veteran
	}
	level.challenge_objective_escape	= &"SO_SABOTAGE_CLIFFHANGER_OBJ_ESCAPE";
	
	level.trig_leaving_warning 	= getent( "leaving_while_incomplete_warning", "script_noteworthy" );
	level.trig_leaving 			= getent( "leaving_while_incomplete", "script_noteworthy" );
	
	thread set_flags();			 // set off flags to trigger original cliffhanger stuff
	thread leaving_while_incomplete( level.trig_leaving );
	thread leaving_while_incomplete_warning( level.trig_leaving_warning );
	thread setup_explosives();
	thread explosives_planted_monitor();
	thread blizzard_control();
	thread start_truck_patrol();
	thread start_final_truck();
	thread start_final_truck2();
	thread start_snowmobiles();
	thread players_sliding();
	
	thread maps\cliffhanger_code::script_chatgroups();
	
	thread challenge_success_wrapup( "sabotage_success" );
	thread enable_escape_warning();
	thread enable_escape_failure();
	thread enable_triggered_complete( "escaped_trigger", "sabotage_success" );
	thread fade_challenge_out( "sabotage_success" );
}

start_so_sabotage()
{
	sabotage_init();

	thread fade_challenge_in();
	thread enable_challenge_timer( "challenge_start", "sabotage_success" );
}

challenge_success_wrapup( success_flag )
{
	flag_wait( success_flag );	
	level.challenge_end_time = gettime();
}

snowmobile_dudes()
{
	self endon( "death" );
	level waittill( "tarmac_snowmobile_unload" );
	wait 6;
	if ( level.players.size == 2 )
	{
		if ( randomint( 100 ) > 50 )
			self setgoalentity( level.players[ 0 ] );
		else
			self setgoalentity( level.players[ 1 ] );
	}
	else
		self setgoalentity( level.player );

	self.goalradius = 512;
}


// ==================================================================================
// ================================ explosives logic ================================
// ==================================================================================

setup_explosives()
{
	level.plant_targets	= [];
	
	plant_targets = getentarray( "explosive_obj_model", "script_noteworthy" );
	assertex( plant_targets.size >= level.number_of_targets, "there arent enough explosives in the level" );
	
	// hide everything first, will show only selected targets
	foreach( obj_model in plant_targets )
	{
		obj_model hide();
		planted_model = getent( obj_model.target, "targetname" );
		planted_model hide();
	}
	
	//random_plant_targets = array_randomize( plant_targets );	
	truncated_plant_targets = [];
	
	for( i=0; i<level.number_of_targets; i++ )
	{
		truncated_plant_targets[ i ] = plant_targets[ i ];
		truncated_plant_targets[ i ] show();
	}
	
	array_thread( truncated_plant_targets, ::setup_explosive );
	waittillframeend;
	
	flag_set( "explosives_ready" );
	array_thread( level.plant_targets, ::explosive_think );
	waittillframeend;
	
	update_obj_location();
}

update_obj_location()
{
	player_origin = [];
	Objective_Add( 1, "current", level.challenge_objective );
	
	while ( 1 )
	{
		wait 1;
		
		if ( level.players.size > 1 )
			player_origin = VectorLerp( level.player.origin, level.player2.origin, 0.5 );
		else
			player_origin = level.player.origin;
		
		targets_to_draw = [];
		foreach ( plant_target in level.plant_targets )
		{
			if ( plant_target.planted )
				continue;
			targets_to_draw[ targets_to_draw.size ] = plant_target;
		}
		
		if ( targets_to_draw.size < 1 )
			return;
		
		//active_obj_loc = get_closest_index( player_origin, targets_to_draw, 10000 );
		objective_location = (0,0,0);
		objective_id = 999;
		
		foreach ( target_to_draw in targets_to_draw )
		{
			id = target_to_draw.objective_id;
			if( id <= objective_id)
			{	
				objective_id = id;	
				objective_location = target_to_draw.origin;
			}			
		}
		Objective_Position( 1, objective_location );
	}
}

setup_explosive()
{
	// self is the explosive_obj_model script model that glows
	// struct is the container of the explosive info related to self
	
	ID = level.plant_targets.size;
	planted_model = getent( self.target, "targetname" );
	planted_model hide();
			
	struct 					= SpawnStruct();
	struct.obj_model		= self;
	struct.objective_id		= int( strTok( self.targetname, "_" )[1] ); // an int in string form
	struct.planted_model	= planted_model;
	struct.origin			= self.origin;
	struct.plant_flag		= "explosive_" + ID;
	struct.id				= ID;
	struct.planted 			= false;
	struct.hint_icon_shader = level.target_shader_array[ ID ];
	
	struct.planted_model.health	= 100; // using model since ent_flag_wait was giving it crap about its not alive...
	
	struct.planted_model ent_flag_init( struct.plant_flag ); 
	level.plant_targets[ level.plant_targets.size ] = struct;
}

explosive_think( exp_struct )
{
	// self is the data container of this explosive
	self thread threeD_objective_hint();
		
	self.obj_model 		MakeUsable();
	self.obj_model		SetCursorHint( "HINT_ACTIVATE" );
	self.obj_model 		SetHintString( level.strings[ "hint_c4_plant" ] );

	self.obj_model waittill( "trigger" );

	self.obj_model 		MakeUnusable();
	self.obj_model 		hide();
	self.planted_model 	show();
	
	self.planted_model thread maps\_c4::playC4Effects();
	self.planted_model thread play_sound_on_entity( "detpack_plant" );
	
	// planted!
	self.planted = true;
	self.planted_model ent_flag_set( self.plant_flag );
	level notify( "an_explosive_planted" );
	
	level waittill( "player_sliding" );
	wait randomint( 60 ) * 0.05;
	
	level.explosion_sound_origins[ self.id ] playsound ( "mack_truck_explode" );
}

players_sliding()
{
	level.explosion_sound_origins = getentarray( "explosion_sound", "targetname" );
	
	slide_trigger = getent( "slide_trigger", "targetname" );
	
	if( level.players.size > 1 )
		wait_both_players_touched( slide_trigger );
	else
		slide_trigger waittill ( "trigger" );
	
	level notify( "player_sliding" );
}

wait_both_players_touched( trigger_ent )
{
	player1_touched = false;
	player2_touched = false;
	for ( ;; )
	{
		trigger_ent waittill( "trigger" );
		if ( level.player IsTouching( trigger_ent ) )
		{
			player1_touched = true;
			if ( !player2_touched && !level.player2 IsTouching( trigger_ent ) )
				continue;
		}
		if ( level.player2 IsTouching( trigger_ent ) )
		{
			player2_touched = true;
			if ( !player1_touched && !level.player IsTouching( trigger_ent ) )
				continue;
		}
		break;
	}
}

explosives_planted_monitor()
{
	flag_wait( "explosives_ready" );
	
	while( 1 )
	{
		all_planted = true;
		foreach ( plant_target in level.plant_targets )
			if ( plant_target.planted == false )
				all_planted = false;
		
		if ( all_planted )
			break;
			
		level waittill( "an_explosive_planted" );
	}
	
	level.trig_leaving_warning 	notify( "trigger_off" );
	level.trig_leaving 			notify( "trigger_off" );
	
	// set new objective
	Objective_State( 1, "done" );
	escape_obj_origin = getent( "escaped_trigger", "script_noteworthy" ).origin;
	Objective_Add( 2, "current", level.challenge_objective_escape, escape_obj_origin );
}

// ==================================================================================
// ==================================== utilities ===================================
// ==================================================================================

blizzard_control()
{
	short_sight_ranges();
	level.sight_range = 0;
	
	maps\_blizzard::blizzard_level_transition_hard( 8 );
	thread maps\_utility::set_ambient( "snow_base" );	
	
	med 	= getent( "med_blizzard", "targetname" );
	time 	= 4;
	
	//while( 1 ) 
	//{
		//thread lower_blizzard( lower, time );
		thread med_blizzard( med, time );
		//thread higher_blizzard( higher, time );

	//	waittill_either_trigger( lower, higher, med );
	//	wait time/2;
	//}
}

waittill_either_trigger( trig1, trig2, trig3 )
{
	trig1 endon( "trigger" );
	trig2 endon( "trigger" );
	trig3 waittill( "trigger" );
}
/*
lower_blizzard( trigger, time )
{
	if( level.sight_range == 0 )
		return;
		
	trigger waittill( "trigger" );
	level.sight_range = 0;
	maps\_blizzard::blizzard_level_transition_light( time );
	thread maps\_utility::set_ambient( "snow_base" );
}*/

med_blizzard( trigger, time )
{
	//if( level.sight_range == 1 )
	//	return;
		
	trigger waittill( "trigger" );
	//level.sight_range = 1;
	thread long_sight_ranges();
	maps\_blizzard::blizzard_level_transition_med( time );
	thread maps\_utility::set_ambient( "snow_base_white" );	
}
/*
higher_blizzard( trigger, time )
{
	if( level.sight_range == 2 )
		return;
		
	trigger waittill( "trigger" );
	level.sight_range = 2;
	thread long_sight_ranges();
	maps\_blizzard::blizzard_level_transition_hard( time );
	thread maps\_utility::set_ambient( "snow_base_white" );	
}*/

threeD_objective_hint()
{
	/*
	self.hint_icon = NewHudElem();
	self.hint_icon SetShader( self.hint_icon_shader, 1, 1 );
	self.hint_icon.alpha = .5;
	self.hint_icon.color = ( 1, 1, 1 );
	self.hint_icon.x = self.origin[ 0 ];
	self.hint_icon.y = self.origin[ 1 ];
	self.hint_icon.z = self.origin[ 2 ];
	self.hint_icon SetWayPoint( false, true );
	*/
	
	self.planted_model ent_flag_wait( self.plant_flag );
	//self.hint_icon destroy();
}

enemy_nerf()
{
	self.baseaccuracy = level.new_enemy_accuracy;
}

leaving_while_incomplete( trigger )
{
	trigger endon( "trigger_off" );
	
	while( 1 )
	{
		trigger waittill( "trigger", player );
		if ( !isPlayer( player ) )
			continue;
		
		if( flag( "explosives_planted" ) )
			return;	
		
		setDvar( "ui_deadquote", level.strings[ "leaving_while_incomplete" ] );
		missionfailedwrapper();
	}
}

leaving_while_incomplete_warning( trigger )
{
	trigger endon( "trigger_off" );
	
	while ( 1 )
	{
		trigger waittill( "trigger", player );
		if ( !isPlayer( player ) )
			continue;
			
		if( flag( "explosives_planted" ) )
			return;	
			
		while ( player istouching( trigger ) )
		{
			player thread display_hint( "leaving_while_incomplete_warning" );
			wait 4;
		}
	}
}

// ==================================================================================
// ======================= modified functions from cliffhanger ======================
// ==================================================================================

return_spawning()
{
	to_be_spawned = [];
	to_be_spawned[ to_be_spawned.size ] = "north_patroler";
	to_be_spawned[ to_be_spawned.size ] = "north_patroler_buddy";

	if ( flag( "truckguys_dead" ) )
	{
		to_be_spawned[ to_be_spawned.size ] = "center_road_patrol";
		to_be_spawned[ to_be_spawned.size ] = "center_road_patrol_buddy";
	}

	foreach ( noteworthy_name in to_be_spawned )
	{
		guy = GetEnt( noteworthy_name, "script_noteworthy" );
		if ( IsDefined( guy ) )
		{
			guy.count = 1;
			guy = guy spawn_ai();
		}
	}
}

spawn_if_dead()
{
	if ( flag( self.dead_flag ) )
		GetEnt( self.triggername, "targetname" ) notify( "trigger" );
}

increase_fov_when_player_is_near()
{
	self endon( "death" );
	self endon( "enemy" );

	while ( 1 )
	{
		if ( DistanceSquared( self.origin, level.player.origin ) < squared( self.footstepDetectDistSprint ) )
		{
			self.fovcosine = 0.01;
			return;
		}
		wait 0.5;
	}
}

reduce_footstep_detect_dist()
{
	self.footstepDetectDistWalk = 90;
	self.footstepDetectDist = 90;
	self.footstepDetectDistSprint = 90;
}

camp_leaner()
{
	node = getstruct( self.target, "targetname" );
	node stealth_ai_idle_and_react( self, "lean_balcony", "lean_react" );
}

twostory_sitter()
{
	node = getstruct( self.target, "targetname" );
	node stealth_ai_idle_and_react( self, "sit_idle", "sit_react" );
}

right_side_start_patroller()
{
	self endon( "death" );
	self SetGoalPos( self.origin );
	self.goalradius = 64;
	//flag_wait( "dialog_take_point" );
	self ent_flag_wait( "_stealth_normal" );
	self maps\_patrol::patrol();
}

tent_1_patrollers()
{
	self endon( "death" );
	self SetGoalPos( self.origin );
	self.goalradius = 64;
	flag_wait( "near_camp_entrance" );
	self ent_flag_wait( "_stealth_normal" );
	self maps\_patrol::patrol();
}

tent_1_crate_patroller()
{
	self endon( "death" );
	nearDoorStruct = getstruct( "struct_crate_patroller_enterhut2", "targetname" );
	while ( 1 )
	{
		nearDoorStruct waittill( "trigger", other );

		if ( other == self )
		{
			break;
		}
	}
	// switch him back to regular patrol anims as he heads inside
	self.patrol_walk_anim = undefined;
	self.patrol_walk_twitch = undefined;
	self.patrol_scriptedanim = undefined;
	self.patrol_stop = undefined;
	self.patrol_start = undefined;	
	self.patrol_stop = undefined;
	self.patrol_end_idle = undefined;
	self maps\_patrol::set_patrol_run_anim_array();
}

start_snowmobiles()
{
	spawn_trig = getent( "spawn_snowmobiles", "targetname" );
	spawn_trig waittill( "trigger" );
	
	foreach( snowmobile_spawner in level.tarmac_snowmobiles )
	{
		snowmobile = snowmobile_spawner spawn_vehicle();
		snowmobile thread gopath();
	}
}

keep_max_ai( num )
{
	all_enemies = getaiarray( "axis" );
	ai_to_delete = all_enemies.size - num;
	
	if( num >= all_enemies.size )
		return;
		
	array_of_ai = [];
	foreach ( guy in all_enemies )
	{
		array_of_ai[ array_of_ai.size ] = guy;
		if( ai_to_delete < 1 )
			break;
		ai_to_delete--;
	}
	thread AI_delete_when_out_of_sight( array_of_ai, 1024 );
}

start_final_truck()
{
	flag_wait( "start_final_truck" );
	//disable_stealth_system(); 
	flag_set( "done_with_stealth_camp" );
	thread keep_max_ai( 8 );
	
	level.final_truck_patrol = maps\_vehicle::spawn_vehicle_from_targetname( "truck_patrol" );
	level.final_truck_patrol attachpath( getvehiclenode( "final_path", "targetname" ) );
	level.final_truck_patrol startpath( getvehiclenode( "final_path", "targetname" ) );
	//thread gopath( level.final_truck_patrol );
	level.final_truck_patrol thread play_loop_sound_on_entity( "cliffhanger_truck_music" );
	level.final_truck_patrol thread final_truck_think( getvehiclenode( "final_stop", "targetname" ) );
	level.final_truck_patrol thread truck_headlights();
	level.final_truck_patrol waittill( "death" );
	flag_set( "jeep_blown_up" );
	level.final_truck_patrol notify( "stop sound" + "cliffhanger_truck_music" );	
}

start_final_truck2()
{
	flag_wait( "start_final_truck2" );
	//disable_stealth_system(); 
	thread keep_max_ai( 8 );
	
	level.final_truck_patrol = maps\_vehicle::spawn_vehicle_from_targetname( "truck_patrol" );
	level.final_truck_patrol attachpath( getvehiclenode( "final_path2", "targetname" ) );
	level.final_truck_patrol startpath( getvehiclenode( "final_path2", "targetname" ) );
	//thread gopath( level.final_truck_patrol );
	level.final_truck_patrol thread play_loop_sound_on_entity( "cliffhanger_truck_music" );
	level.final_truck_patrol thread final_truck_think( getvehiclenode( "final_stop2", "targetname" ) );
	level.final_truck_patrol thread truck_headlights();
	level.final_truck_patrol waittill( "death" );
	flag_set( "jeep_blown_up" );
	level.final_truck_patrol notify( "stop sound" + "cliffhanger_truck_music" );	
}


start_truck_patrol()
{
 	array_thread( getentarray( "truck_guys", "script_noteworthy" ), ::add_spawn_function, maps\cliffhanger_stealth::base_truck_guys_think );

	flag_wait( "start_truck_patrol" );

	level.truck_patrol = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "truck_patrol" );
	level.truck_patrol thread play_loop_sound_on_entity( "cliffhanger_truck_music" );
	level.truck_patrol thread base_truck_think();
	level.truck_patrol thread truck_headlights();
	level.truck_patrol waittill( "death" );
	flag_set( "jeep_blown_up" );
	level.truck_patrol notify( "stop sound" + "cliffhanger_truck_music" );
}

final_truck_think( final_node )
{
	self endon( "death" );
	final_node waittill( "trigger" );
	self Vehicle_SetSpeed( 0, 15 );
	wait 1;
	self maps\_vehicle::vehicle_unload();
	flag_set( "jeep_stopped" );
}


base_truck_think()
{
	self endon( "death" );
	self thread unload_and_attack_if_stealth_broken_and_close();
	flag_wait( "truck_guys_alerted" );
	guys = get_living_ai_array( "truck_guys", "script_noteworthy" );
	
	if( guys.size == 0 )
	{
		self Vehicle_SetSpeed( 0, 15 );
		return;
	}
	
	screamer = random( guys );
	screamer maps\_stealth_shared_utilities::enemy_announce_wtf();

	self waittill( "safe_to_unload" );
	self Vehicle_SetSpeed( 0, 15 );
	wait 1;
	self maps\_vehicle::vehicle_unload();
	
	flag_set( "jeep_stopped" );
}

unload_and_attack_if_stealth_broken_and_close()
{	
	self endon( "truck_guys_alerted" );
	
	while( 1 )
	{
		flag_wait( "_stealth_spotted" );
		level.player waittill_entity_in_range( self, 800 );
		if( !flag( "_stealth_spotted" ) )
			continue;
		else
			break;
	}
	flag_set( "truck_guys_alerted" );
}


truck_headlights()
{
	//level.truck_patrol maps\_vehicle::lights_on( "headlights" );
	PlayFXOnTag( level._effect[ "lighthaze_snow_headlights" ], self, "TAG_LIGHT_RIGHT_FRONT" );
	PlayFXOnTag( level._effect[ "lighthaze_snow_headlights" ], self, "TAG_LIGHT_LEFT_FRONT" );
 	//level.truck_patrol maps\_vehicle::lights_on( "brakelights" );

	//taillights 
	PlayFXOnTag( level._effect[ "car_taillight_uaz_l" ], self, "TAG_LIGHT_LEFT_TAIL" );
	PlayFXOnTag( level._effect[ "car_taillight_uaz_l" ], self, "TAG_LIGHT_RIGHT_TAIL" );
 	
 	self waittill ( "death" );
 	
 	if( isdefined( self ) )
	 	delete_truck_headlights();
}	
 
delete_truck_headlights()
{
	StopFXOnTag( level._effect[ "lighthaze_snow_headlights" ], self, "TAG_LIGHT_RIGHT_FRONT" );
 	StopFXOnTag( level._effect[ "lighthaze_snow_headlights" ], self, "TAG_LIGHT_LEFT_FRONT" );
	StopFXOnTag( level._effect[ "car_taillight_uaz_l" ], self, "TAG_LIGHT_LEFT_TAIL" );
	StopFXOnTag( level._effect[ "car_taillight_uaz_l" ], self, "TAG_LIGHT_RIGHT_TAIL" );
}

long_sight_ranges()
{
	ai_event[ "ai_eventDistFootstep" ] = [];
	ai_event[ "ai_eventDistFootstep" ][ "spotted" ]		 = 300;
	ai_event[ "ai_eventDistFootstep" ][ "hidden" ] 		 = 300;

	ai_event[ "ai_eventDistFootstepWalk" ] = [];
	ai_event[ "ai_eventDistFootstepWalk" ][ "spotted" ]	 = 300;
	ai_event[ "ai_eventDistFootstepWalk" ][ "hidden" ] 	 = 300;

	ai_event[ "ai_eventDistFootstepSprint" ] = [];
	ai_event[ "ai_eventDistFootstepSprint" ][ "spotted" ]	 = 400;
	ai_event[ "ai_eventDistFootstepSprint" ][ "hidden" ] 	 = 400;

	stealth_ai_event_dist_custom( ai_event );
	
	rangesHidden = [];
	rangesHidden[ "prone" ]		= 800;
	rangesHidden[ "crouch" ]	= 800;
	rangesHidden[ "stand" ]		= 800;

	rangesSpotted = [];
	rangesSpotted[ "prone" ]	= 8192;
	rangesSpotted[ "crouch" ]	= 8192;
	rangesSpotted[ "stand" ]	= 8192;

	stealth_detect_ranges_set( rangesHidden, rangesSpotted );
	
	stealth_alert_level_duration( 0.5 );	
}

med_sight_ranges()
{
	ai_event[ "ai_eventDistFootstep" ] = [];
	ai_event[ "ai_eventDistFootstep" ][ "spotted" ]		 = 200;
	ai_event[ "ai_eventDistFootstep" ][ "hidden" ] 		 = 200;

	ai_event[ "ai_eventDistFootstepWalk" ] = [];
	ai_event[ "ai_eventDistFootstepWalk" ][ "spotted" ]	 = 120;
	ai_event[ "ai_eventDistFootstepWalk" ][ "hidden" ] 	 = 120;

	ai_event[ "ai_eventDistFootstepSprint" ] = [];
	ai_event[ "ai_eventDistFootstepSprint" ][ "spotted" ]	 = 400;
	ai_event[ "ai_eventDistFootstepSprint" ][ "hidden" ] 	 = 400;

	stealth_ai_event_dist_custom( ai_event );
	
	rangesHidden = [];
	rangesHidden[ "prone" ]		= 400;
	rangesHidden[ "crouch" ]	= 600;
	rangesHidden[ "stand" ]		= 800;

	rangesSpotted = [];
	rangesSpotted[ "prone" ]	= 700;
	rangesSpotted[ "crouch" ]	= 700;
	rangesSpotted[ "stand" ]	= 800;

	stealth_detect_ranges_set( rangesHidden, rangesSpotted );
	
	alert_duration = [];
	alert_duration[0] = 1;
	alert_duration[1] = 1;
	alert_duration[2] = 1;
	alert_duration[3] = 0.75;

	// easy and normal have 2 alert levels so the above times are effectively doubled
	stealth_alert_level_duration( alert_duration[ level.gameskill ] );	
}


short_sight_ranges()
{
	ai_event[ "ai_eventDistFootstep" ] = [];
	ai_event[ "ai_eventDistFootstep" ][ "spotted" ]		 = 120;
	ai_event[ "ai_eventDistFootstep" ][ "hidden" ] 		 = 120;
		
	ai_event[ "ai_eventDistFootstepWalk" ] = [];
	ai_event[ "ai_eventDistFootstepWalk" ][ "spotted" ]	 = 60;
	ai_event[ "ai_eventDistFootstepWalk" ][ "hidden" ] 	 = 60;
	
	ai_event[ "ai_eventDistFootstepSprint" ] = [];
	ai_event[ "ai_eventDistFootstepSprint" ][ "spotted" ]	 = 400;
	ai_event[ "ai_eventDistFootstepSprint" ][ "hidden" ] 	 = 400;
	
	stealth_ai_event_dist_custom( ai_event );
	
	rangesHidden = [];
	rangesHidden[ "prone" ]		= 250;
	rangesHidden[ "crouch" ]	= 450;
	rangesHidden[ "stand" ]		= 500;

	rangesSpotted = [];
	rangesSpotted[ "prone" ]	= 500;
	rangesSpotted[ "crouch" ]	= 500;
	rangesSpotted[ "stand" ]	= 600;
		
	stealth_detect_ranges_set( rangesHidden, rangesSpotted );
	
	alert_duration = [];
	alert_duration[0] = 1;
	alert_duration[1] = 1;
	alert_duration[2] = 1;
	alert_duration[3] = 0.75;

	// easy and normal have 2 alert levels so the above times are effectively doubled
	stealth_alert_level_duration( alert_duration[ level.gameskill ] );	
}

stealth_settings()
{
	stealth_set_default_stealth_function( "cliffhanger", ::stealth_cliffhanger_clifftop );
	
	ai_event = [];
	ai_event[ "ai_eventDistNewEnemy" ] = [];
	ai_event[ "ai_eventDistNewEnemy" ][ "spotted" ]		 = 512;
	ai_event[ "ai_eventDistNewEnemy" ][ "hidden" ] 		 = 256;

	ai_event[ "ai_eventDistExplosion" ] = [];
	ai_event[ "ai_eventDistExplosion" ][ "spotted" ]	 = level.explosion_dist_sense;
	ai_event[ "ai_eventDistExplosion" ][ "hidden" ] 	 = level.explosion_dist_sense;

	ai_event[ "ai_eventDistDeath" ] = [];
	ai_event[ "ai_eventDistDeath" ][ "spotted" ] 		 = 512;
	ai_event[ "ai_eventDistDeath" ][ "hidden" ] 		 = 512; // used to be 256
	
	ai_event[ "ai_eventDistPain" ] = [];
	ai_event[ "ai_eventDistPain" ][ "spotted" ] 		 = 256;
	ai_event[ "ai_eventDistPain" ][ "hidden" ] 		 	 = 256; // used to be 256
	
	ai_event[ "ai_eventDistBullet" ] = [];
	ai_event[ "ai_eventDistBullet" ][ "spotted" ]		 = 96;
	ai_event[ "ai_eventDistBullet" ][ "hidden" ] 		 = 96;
	
	ai_event[ "ai_eventDistFootstep" ] = [];
	ai_event[ "ai_eventDistFootstep" ][ "spotted" ]		 = 300;
	ai_event[ "ai_eventDistFootstep" ][ "hidden" ] 		 = 300;

	ai_event[ "ai_eventDistFootstepWalk" ] = [];
	ai_event[ "ai_eventDistFootstepWalk" ][ "spotted" ]	 = 300;
	ai_event[ "ai_eventDistFootstepWalk" ][ "hidden" ] 	 = 300;

	ai_event[ "ai_eventDistFootstepSprint" ] = [];
	ai_event[ "ai_eventDistFootstepSprint" ][ "spotted" ]	 = 400;
	ai_event[ "ai_eventDistFootstepSprint" ][ "hidden" ] 	 = 400;

	stealth_ai_event_dist_custom( ai_event );
	
	rangesHidden = [];
	rangesHidden[ "prone" ]		= 800;
	rangesHidden[ "crouch" ]	= 1200;
	rangesHidden[ "stand" ]		= 1600;

	rangesSpotted = [];
	rangesSpotted[ "prone" ]	= 8192;
	rangesSpotted[ "crouch" ]	= 8192;
	rangesSpotted[ "stand" ]	= 8192;

	stealth_detect_ranges_set( rangesHidden, rangesSpotted );
	stealth_alert_level_duration( 0.5 );	
	stealth_ai_event_dist_custom( ai_event );

	array = [];
	array[ "sight_dist" ]	 = 400;
	array[ "detect_dist" ]	 = 200;
	stealth_corpse_ranges_custom( array );
}

stealth_cliffhanger_clifftop()
{
	self stealth_plugin_basic();

	if ( isplayer( self ) )
		return;

	threat_array[ "warning1" ] = maps\_stealth_threat_enemy::enemy_alert_level_warning2;
	switch( self.team )
	{
		case "axis":
			self ent_flag_init( "player_found" );
			self ent_flag_init( "not_first_attack" );
			
			self stealth_plugin_threat();
			self stealth_pre_spotted_function_custom( ::clifftop_prespotted_func );
			self stealth_threat_behavior_custom( threat_array );
			self stealth_enable_seek_player_on_spotted();
			self stealth_plugin_corpse();
			self stealth_plugin_event_all();
			self.baseaccuracy = 1;
			self.fovcosine = .76;	// for the 2nd group -z
			self.fovcosinebusy = .1;

			self maps\cliffhanger_stealth::init_cliffhanger_cold_patrol_anims();
			break;
		case "allies":
	}
}

clifftop_prespotted_func()
{
	self.battlechatter = false;
	wait 2;
	self.battlechatter = true;
}

stealth_cliffhanger()
{
	self stealth_plugin_basic();
		
	if( isplayer( self ) )
	{
		self._stealth_move_detection_cap = 0;
		return;
	}
				
	switch( self.team )
	{
		case "axis":
			self ent_flag_init( "player_found" );
			self ent_flag_init( "not_first_attack" );
			self thread maps\_stealth_shared_utilities::enemy_event_debug_print( "player_found" );
			self thread maps\_stealth_shared_utilities::enemy_event_debug_print( "not_first_attack" );
			self stealth_plugin_threat();//call first 
			
			custom_array = [];
			
			custom_array[ "warning1" ] = maps\_stealth_threat_enemy::enemy_alert_level_warning2;
			custom_array[ "attack" ] = ::small_goal_attack_behavior;//default
			/*
			if ( level.gameskill < 2 )
			{
				custom_array[ "warning1" ] = maps\_stealth_threat_enemy::enemy_alert_level_warning1;
				custom_array[ "warning2" ] = maps\_stealth_threat_enemy::enemy_alert_level_warning2;
			}
			else
			{
				custom_array[ "warning1" ] = maps\_stealth_threat_enemy::enemy_alert_level_warning2;
			}*/
			
			self stealth_threat_behavior_custom( custom_array );
			/*
			//goal radius etc for attack
			//overridding this: enemy_alert_level_attack( enemy )
			//modify this to make sure you can see the player
			b_array = [];
			b_array [ "attack" ] = maps\cliffhanger_stealth::cliffhanger_enemy_attack_behavior;
			self stealth_threat_behavior_replace( b_array, undefined );
			*/
			
			/*
			//time till attack once stealth is broken
			//overriding this: enemy_animation_attack( type )
			new_array = [];
			new_array[ "attack" ] = maps\cliffhanger_stealth::cliffhanger_enemy_animation_attack; 
			self stealth_threat_behavior_replace( undefined, new_array );
			*/

			self stealth_pre_spotted_function_custom( maps\cliffhanger_stealth::cliffhanger_prespotted_func_with_flag_wait );
			self stealth_enable_seek_player_on_spotted();
			self stealth_plugin_corpse();
			self stealth_plugin_event_all();
			
			//self maps\_stealth_shared_utilities::ai_set_goback_override_function( maps\cliffhanger_stealth::cliffhanger_enemy_goback_startfunc );
			
			self.grenadeAmmo = 0;
			self.baseaccuracy = 1.5;
			self.fovcosine = .5; // cos60
			self.fovcosinebusy = .1;			
			self maps\cliffhanger_stealth::init_cliffhanger_cold_patrol_anims();
			break;
		case "allies":
	}
}

Small_Goal_Attack_Behavior()
{
	self endon( "death" );
	self endon( "_stealth_enemy_alert_level_change" );
	
	self maps\_stealth_shared_utilities::enemy_stop_current_behavior();
	
	self.pathrandompercent = 200;
	self thread disable_cqbwalk();
	self thread maps\_stealth_shared_utilities::enemy_announce_spotted( self.origin );
	self.goalradius = 400;
		
	self ent_flag_set( "_stealth_override_goalpos" );
	while ( isdefined( self.enemy ) && self ent_flag( "_stealth_enabled" ) )
	{
		self setgoalpos( self.enemy.origin );
		wait 4;
	}
}


wind_blown_flag_think()
{
	animname = "flag_square";
	if ( IsDefined( self.script_noteworthy ) )
		animname = self.script_noteworthy;
	waving_flag = spawn_anim_model( animname );
	waving_flag.origin = self.origin;
	waving_flag.angles = self.angles;
	self Delete();

	angles = VectorToAngles( waving_flag.angles );
	forward = AnglesToForward( angles );
	//waving_flag.origin += forward * 8;
	waving_flag thread flag_waves();
}

flag_waves()
{
	animation = self getanim( "flag_waves" );
	self SetAnim( animation, 1, 0, 1 );
	for ( ;; )
	{
		if ( !isdefined( self ) )
			return;
		flap_rate = RandomFloatRange( 0.8, 1.2 );
		self SetAnim( animation, 1, 0, flap_rate );
		wait( RandomFloatRange( 0.3, 0.7 ) );
	}
}

tarmac_snowmobile_think()
{
	self waittill( "spawned", vehicle );
	vehicle thread vehicle_becomes_crashable();
	vehicle VehPhys_DisableCrashing();// so they dont go off their path inconsistently
	vehicle thread force_unload();
	vehicle waittill( "unloading" );
	level notify( "tarmac_snowmobile_unload" );
}

force_unload()
{
	self endon( "death" );
	self endon( "unloading" );
	level waittill( "tarmac_snowmobile_unload" );
	self Vehicle_SetSpeed( 0, 45 );
	wait 1.75;
	self thread vehicle_unload();
	// so both snowmobiles dismount once either reaches the end of the path
}
