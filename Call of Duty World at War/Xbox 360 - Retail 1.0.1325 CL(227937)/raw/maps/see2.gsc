#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\pel2_util;
#include maps\_vehicle_utility;
#include maps\see2_threat;
#include maps\_grenade_toss;
#include maps\_music;
#include maps\see2_vehicle_behavior;
#include maps\see2_fortifications;
#include maps\see2_sound;
#include maps\_busing;

main()
{
	
	// precache turret for popping and intermediate damage states
	precachemodel("vehicle_ger_tracked_panzer4_d_turret");
	precachemodel("vehicle_ger_tracked_panther_d_turret");
	precachemodel("vehicle_ger_tracked_king_tiger_d_turret");
	precachemodel("vehicle_ger_tracked_panzer4v1_dmg1");
	precachemodel("vehicle_ger_tracked_panther_dmg1");
	precachemodel("vehicle_ger_tracked_king_tiger_dmg1");
	precachemodel("katyusha_rocket");
	
	precachemodel("weapon_rus_reznov_knife");
	precachemodel("weapon_rus_mosinnagant_rifle");
	
	// precache rumble
	precacheRumble( "tank_damage_heavy_mp" );
	precacheRumble( "tank_damage_light_mp" );
	
	level.campaign = "russian";
	
	// All vehicles setup
	maps\_see2_panther::main( "vehicle_ger_tracked_panther" ); 
	maps\_see2_ot34::main( "vehicle_rus_tracked_ot34" );	
	maps\_see2_t34::main( "vehicle_rus_tracked_t34" );
	maps\_see2_physics_t34::main( "vehicle_rus_tracked_ot34" );
	maps\_see2_tiger::main( "vehicle_ger_tracked_king_tiger" );
	maps\_see2_panzeriv::main( "vehicle_ger_tracked_panzer4v1" );
	maps\_truck::main( "vehicle_ger_wheeled_covered_opel_blitz", "opel" );
	maps\_see2_flak88::main( "artillery_ger_flak88" );
	maps\_aircraft::main( "vehicle_rus_airplane_il2", "il2", 0, false ); // cut down from 3 turrets to 0
	
	precachemodel( "weapon_machinegun_tiger" );
	precachemodel( "vehicle_rus_tracked_ot34_d" );
	precacheturret( "allied_hull_flamethrower" );
	
	precachestring( &"SEE2_FLAMETHROWER_HINT" );
	precachestring( &"SEE2_MG_COOP_HINT" );
	precachestring( &"SEE2_ADS_HINT" );
	
	
	// Setup start points - Currently gets the level logically to this state does not warp players yet
	default_start( ::field_begin );
	add_start( "radio_tower", ::radio_tower_begin, &"STARTS_SEE2_RADIOTOWER" );
	add_start( "fuel_depot", ::fuel_depot_begin, &"STARTS_SEE2_FUELDEPOT" );
	add_start( "air_strike", ::air_strike_begin, &"STARTS_SEE2_AIRSTRIKE" );
	
	//maps\_drones::init();	

	level.drones_per_wave = 8;

	setup_level();

	maps\_drone::init();

	level.max_drones["allies"] = 32;
	level.max_drones["axis"] = 32;

	maps\see2_fx::main();
	maps\see2_drones::main();
	maps\see2_anim::main();
	maps\see2_breadcrumbs::main();
	maps\see2_amb::main();

	maps\_load::main();
	
	level thread difficulty_scale();
	level init_level_flags();
	//-- LEVEL THROTTLING SPAWN FUNCTION VARIABLES
	thread tune_max_ai_numbers();
	
	//character\char_ger_pnzgren_k98::precache();
	//character\char_rus_r_rifle::precache();
	
	// These are called everytime a drone is spawned in to set up the character.
	//level.drone_spawnFunction["axis"] = character\char_ger_pnzgren_k98::main;
	//level.drone_spawnFunction["allies"] = character\char_rus_r_rifle::main; 
	
	level tune_ai();
	
	level.enemy_armor = [];
	level.death_bucket = [];
	level.enemy_infantry = [];
	level.line_queue = [];
	level.identified_entities = [];
	
	level.radio_tower_goal_nodes = GetNodeArray( "radio tower goal", "script_noteworthy" );
	level.fuel_depot_goal_nodes = GetNodeArray( "fuel depot goal", "script_noteworthy" );
	
	level.custom_target = undefined;
	
	level.vehicle_death_thread = [];
	level.vehicle_death_thread["see2_panzeriv"] = maps\see2_vehicle_behavior::see2_veh_death_thread;
	level.vehicle_death_thread["see2_tiger"] = maps\see2_vehicle_behavior::see2_veh_death_thread;
	level.vehicle_death_thread["see2_panther"] = maps\see2_vehicle_behavior::see2_veh_death_thread;
	
	level.finished_events = [];
	thread do_friendly_consistency_check();
	thread do_radio_tower_explode();
	level thread wait_for_finalbattle_alternate(); //-- Glocke: to fit with the new objective text
	
	level.centroid = undefined;
	level thread keep_track_of_player_centroid();
	level thread wait_for_dialog_triggers();
	level thread see2_handleLineQueue();
	
	level.retreat_points = [];
	level.retreat_points = array_add( level.retreat_points, "radio tower" );
	level.retreat_points = array_add( level.retreat_points, "fuel depot" );
	level.retreat_points = array_add( level.retreat_points, "airstrike" );
	
	level.invalid_retreat_points = [];
	
	level.time_between_dialogue = 9;
	level.dialogue_timer = 0;
	level.min_close_infantry_for_warning = 3;
	level.min_distance_for_close_infantry = 120;
	
	// Idle warning variables
	level.current_idle_time = 0;
	level.min_idle_dist_sq = 0.5;
	level.idle_warn_time = 10;
	level.num_idle_lines = 6;
	
	
	level thread update_dialogue_timer();
	level thread setup_achievement_spawn_func();
	level thread spawn_func_throttle_spawns();
	
	level.callbackSaveRestored = ::see2_callback_saveRestored;
	
	/#
	level thread debug_ai_prints();
	#/
	
	BadPlacesEnable( 0 );
}

////////////////////////////////////////
// GLOBAL UTILITY FUNCTIONS
////////////////////////////////////////

tune_max_ai_numbers()
{
	level.max_ai_spawn = 20;
	level.max_vehicles = 8;
	
	level.max_ai_spawn_current 			= 20;
	level.max_vehicle_spawn_current = 8;
	
	//TODO: FINISH THIS LATER WHEN I KNOW WHAT I'M DOING WITH IT
	if(1)
	{
		return;
	}
	
	while(1)
	{
		current_number_of_vehicles = [];
		current_number_of_vehicles = GetEntArray(	"script_vehicle", "classname" );
		
		for( i=0; i < current_number_of_vehicles.size; i++)
		{
			
		}
		
		wait(1);
	}
}

// AI targeting tune values
tune_ai()
{
	level.number_miss_structs = 8;
	level.min_miss_distance = 150;
	level.max_miss_distance = 250;
	
	//Distances used for tank targeting
	level.see2_max_tank_target_dist = 4000;
	level.see2_max_tank_firing_dist = 3500;
	
	level.retreat_threshold = 0.6;
	
	min_pzrsk_dist = 500;
	max_pzrsk_dist = 2500;
	level.min_panzerschreck_eng_distsq = min_pzrsk_dist*min_pzrsk_dist;
	level.max_panzerschreck_eng_distsq = max_pzrsk_dist*max_pzrsk_dist;
}

// --- DIFFICULTY SCALING ---
difficulty_scale()
{
	switch( GetDifficulty() )
	{
		case "easy":
		level.see2_player_armor = 7500;
		level.see2_base_lag_time = 1;
		level.see2_max_targeters = 3;
		level.see2_percent_life_at_checkpoint = 1;
		level.time_before_regen = 9;
		level.no_shoot_increase = .05;
		break;
		
		case "medium":
		level.see2_player_armor = 6000;
		level.see2_base_lag_time = 0.75;
		level.see2_max_targeters = 3;
		level.see2_percent_life_at_checkpoint = 0.75;
		level.time_before_regen = 10;
		level.no_shoot_increase = .05;
		break;
		
		case "hard":
		level.see2_player_armor = 4500;
		level.see2_base_lag_time = 0.5;
		level.see2_max_targeters = 4;
		level.see2_percent_life_at_checkpoint = 0.5;
		level.time_before_regen = 11;
		level.no_shoot_increase = .03;
		break;
		
		case "fu":
		level.see2_player_armor = 3000;
		level.see2_base_lag_time = 0.25;
		level.see2_max_targeters = 4;
		level.see2_percent_life_at_checkpoint = 0.5;
		level.time_before_regen = 12;
		level.no_shoot_increase = .01;
		break;
	}
	
	level.armor_per_frame = int( level.see2_player_armor / level.time_before_regen / 20 );
}

/////////////////////////////////
// FUNCTION: keep_track_of_achievement
// CALLED ON: level
// PURPOSE: Keeps track of the status of the achievement and then awards it to all players when it has been accomplished
//
// ADDITIONS NEEDED: None
/////////////////////////////////
keep_track_of_achievement()
{
	//-- because the water towers weren't hooked to anything
	water_tower_trigs = GetEntArray( "water_tower_trig", "targetname" );
	for(i = 0; i < water_tower_trigs.size; i++)
	{
		water_tower_trigs[i] thread track_water_tower_triggers();
	}
		
	//-- The Max that are in the level
	water_tower_number = 3;
	bunker_number			 = 5;
	schreck_number 		 = 14;
	
	//-- The counters
	water_tower_achievement = 0;
	bunker_achievement = 0;
	schreck_tower_achievement = 0;
	
	
	while(1)
	{
		level waittill( "achievement_destroy_notify", item );
		
		switch( item )
		{
			case "water_tower":
				water_tower_achievement++;
			break;
			
			case "bunker":
				bunker_achievement++;
			break;
			
			case "schreck_tower":
				schreck_tower_achievement++;
			break;
			
			default:
			break;
		}
		
		//-- Check and give award
		if( water_tower_achievement >= water_tower_number && bunker_achievement >= bunker_number && schreck_tower_achievement >= schreck_number )
		{
			break;
		}
		
	}
	
	players = get_players();
	
	for(i=0; i < players.size; i++)
	{
		players[i] maps\_utility::giveachievement_wrapper( "SEE2_ACHIEVEMENT_TOWER" );
	}
	
}

track_water_tower_triggers()
{
	self waittill( "trigger" );
	level notify( "achievement_destroy_notify", "water_tower" );
}

setup_achievement_spawn_func()
{
}

spawn_func_throttle_spawns()
{
	ai_array = GetSpawnerArray();
	
	for( i=0; i<ai_array.size; i++)
	{
		//ai_array[i] add_spawn_function( ::throttle_ai_keep_time ); //called by throttle_ai_make_room
		ai_array[i] add_spawn_function( ::throttle_ai_make_room );
	}
}

throttle_ai_keep_time()
{
	self endon("death");
	
	while(true)
	{
		self.see2_life_time += 0.001;
		wait(0.1);		
	}
}

throttle_ai_make_room()
{
	ai = GetAIArray( "axis" );
	
	//-- ai setup
	
	for(i = 0; i < ai.size; i++)
	{
		if(!IsDefined(ai[i].see2_life_time))
		{
			ai[i].see2_life_time = 0;
			ai[i] thread throttle_ai_keep_time();
		}
	}
	
	if( ai.size > level.max_ai_spawn_current )
	{
		ai = sort_ai_by_life_time( ai );
		num_ai_to_remove = ai.size - level.max_ai_spawn_current;
		
		for( i=0; i < num_ai_to_remove; i++ )
		{
			//ai[i] Delete(); //-- change this to bloody death
			random_wait = RandomFloatRange(0.1, 1.0);
			ai[i] thread bloody_death( random_wait );
		}
	}
}

sort_ai_by_life_time( nodes )
{
	for( i = 0; i < nodes.size; i++ )
	{
		for( j = i; j < nodes.size; j++ )
		{
			if( nodes[j].see2_life_time > nodes[i].see2_life_time )
			{
				temp = nodes[i]; 
				nodes[i] = nodes[j]; 
				nodes[j] = temp; 
			}
		}
	}

	return nodes; 
}


/////////////////////////////////
// FUNCTION: keep_track_of_player_centroid
// CALLED ON: level
// PURPOSE: Keeps track of the centroid of all players for use by anyone who might want to stay
//          as close to the players as a whole as possible
// ADDITIONS NEEDED: None
/////////////////////////////////
keep_track_of_player_centroid()
{
	wait_for_first_player();
	while( 1 )
	{
		players = get_players();
		num_players = players.size;
		total = undefined;
		for( i = 0; i < num_players; i++ )
		{
			if( !isDefined( total ) )
			{
				total = players[i].origin;
			}
			else
			{
				total = total + players[i].origin;
			}
		}
		level.centroid = total/num_players;
		wait( 3 );
	}
}

/////////////////////////////////
// FUNCTION: keep_grenade_bags_from_spawning
// CALLED ON: level
// PURPOSE: Keeps grenade bags from spawning and saves us some entities
// ADDITIONS NEEDED: None
/////////////////////////////////
keep_grenade_bags_from_spawning()
{
	self endon( "death" );
	
	while( 1 )
	{
		level.nextGrenadeDrop = 9999;
		wait( 0.05 );	
	}
}

/////////////////////////////////
// FUNCTION: setup_flak88_guard
// CALLED ON: a guard for flak88s
// PURPOSE: Deprecated in favor of drones... I think
// ADDITIONS NEEDED: None
/////////////////////////////////
setup_flak88_guard()
{
	self.ignoreall = true;
}

/////////////////////////////////
// FUNCTION: wait_for_group_spawn
// CALLED ON: level
// PURPOSE: Waits until a predefined signal is sent then spawns a specific group
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_group_spawn( group )
{
	trigger = GetEnt( "group "+group+" spawn", "script_noteworthy" );
	trigger thread inform_on_touch_trigger( trigger.script_noteworthy );
	level waittill( trigger.script_noteworthy );
	
	if( flag( level.skipto_flag_names[group] ) )
	{
		return;
	}
	
	do_area_spawn( group );
}

/////////////////////////////////
// FUNCTION: do_friendly_consistency_check
// CALLED ON: level
// PURPOSE: This iterates through all friendly paths and makes sure all are sound in terms of
//          naming conventions
// ADDITIONS NEEDED: None
/////////////////////////////////
do_friendly_consistency_check()
{
	/#
	names = [];
	names[0] = "friendly 1";
	names[1] = "friendly 2";
	names[2] = "friendly 3";
	
	advance_triggers = GetEntArray( "friendly advance trigger", "script_noteworthy" );
	
	
	for( i = 0; i < advance_triggers.size; i++ )
	{
		advance_nodes = GetVehicleNodeArray( advance_triggers[i].script_noteworthy, "script_noteworthy" );
		if( advance_nodes.size != 3 )
		{
			iprintlnbold( "Insufficient advance nodes for trigger "+advance_triggers[i].script_noteworthy );
		}
		for( j = 0; j < names.size; j++ )
		{
			found = false;
			for( k = 0; k < advance_nodes.size; k++ )
			{
				if( advance_nodes[k].script_string == names[j] )
				{
					found = true;
					break;
				}
			}
			if( !found )
			{
				iprintlnbold( "Advance node "+advance_triggers[i].script_noteworthy+" does not exist for ent "+names[j] );
			}
		}
	}
	#/
}

/////////////////////////////////
// FUNCTION: see2_callback_saveRestored
// CALLED ON: ?
// PURPOSE: This is threaded when the level reloads from a checkpoint. It handles armor fixup
// ADDITIONS NEEDED: None
/////////////////////////////////
see2_callback_saveRestored()
{
	maps\_callbackglobal::Callback_SaveRestored();
	
	for( i = 0; i < get_players().size; i++ )
	{
		if( (get_players()[i].myTank.armor / get_players()[i].myTank.maxarmor) < 0.5 )
		{
			get_players()[i].myTank.armor = get_players()[i].myTank.maxarmor * level.see2_percent_life_at_checkpoint;
		}
	}
}

/////////////////////////////////
// FUNCTION: explosive_damage
// CALLED ON: anything
// PURPOSE: checks to see if a damage type is considered explosive for purposes of destruction
// ADDITIONS NEEDED: None
/////////////////////////////////
explosive_damage( type )
{
	return (issubstr( type, "GRENADE" ) || issubstr( type, "PROJECTILE" ) || issubstr( type, "EXPLOSIVE" ) || issubstr( type, "BURNED" ) );
}

/////////////////////////////////
// FUNCTION: inform_on_touch_trigger
// CALLED ON: a trigger
// PURPOSE: This sends a signal to the level when the trigger is breached, commented section checked
//          that the entity triggering was a player. I don't know why this was disabled. It may be
//          why the airstrike is triggering early
// ADDITIONS NEEDED: Look and see where this is being used and see why it is not checking for players
/////////////////////////////////
inform_on_touch_trigger( event )
{
	self waittill( "trigger" );
	level notify( event );
	
	/*
	breaker = false;
	while( !breaker )
	{
		for( i = 0; i < get_players().size; i++ )
		{
			if( get_players()[i] isTouching( self ) )
			{
				self notify( "trigger" );
				breaker = true;
				break;
			}
		}
		wait( 0.05 );
	}*/
}

/////////////////////////////////
// FUNCTION: inform_on_damage_trigger
// CALLED ON: a damage trigger
// PURPOSE: This sends a notify to the level if a player or friendly tank does explosive damage to
//          a trigger
// ADDITIONS NEEDED: None
/////////////////////////////////
inform_on_damage_trigger( event )
{
	while( 1 )
	{
		self waittill( "damage", damage, other, direction, origin, damage_type );
		if ( explosive_damage( damage_type ) )
		{
			if( isDefined( other.script_team ) && other.script_team == "allies" )
			{
				level notify( event );
				return;
			}
		}
		wait( 0.05 );
	}
}

/////////////////////////////////
// FUNCTION: is_in_player_arc
// CALLED ON: an object, with a player as an argument
// PURPOSE: This checks to see if the object is in the view arc of the player passed in
// ADDITIONS NEEDED: Maybe have it adjust view arc properly for widescreen FOV
/////////////////////////////////
is_in_player_arc( player )
{
	myOrigin = (self.origin[0], self.origin[1], 0);
	playerOrigin = (player.origin[0], player.origin[1], 0);
	diff = myOrigin - playerOrigin;
	angles = vectortoangles( diff );
	if( abs( angles[1] - player.angles[1] ) > 32.5 )
	{
		return true;
	}
	return false;
}

/////////////////////////////////
// FUNCTION: setup_level
// CALLED ON: level
// PURPOSE: Does all threat bias setup
// ADDITIONS NEEDED: None
/////////////////////////////////
setup_level()
{
	CreateThreatBiasGroup( "players" );
	create_see2_threat_group( "players" );
	CreateThreatBiasGroup( "player tanks" );
	create_see2_threat_group( "player tanks" );
	CreateThreatBiasGroup( "enemy antitank" );
	create_see2_threat_group( "enemy antitank" );
	CreateThreatBiasGroup( "enemy infantry" );
	create_see2_threat_group( "enemy infantry" );
	CreateThreatBiasGroup( "friendly antitank" );
	create_see2_threat_group( "friendly antitank" );
	CreateThreatBiasGroup( "friendly infantry" );
	create_see2_threat_group( "friendly infantry" );
	CreateThreatBiasGroup( "friendly armor" );
	create_see2_threat_group( "friendly armor" );
	create_see2_threat_group( "enemy armor" );
	
	//SetThreatBias( "players", "enemy antitank", 10000 );
	SetThreatBias( "player tanks", "enemy antitank", 10000 );
	SetThreatBias( "friendly armor", "enemy antitank", 15000 );
	SetIgnoreMeGroup( "players", "enemy infantry" );
	SetIgnoreMeGroup( "players", "enemy antitank" );
	SetIgnoreMeGroup( "friendly armor", "enemy infantry" );
}

/////////////////////////////////
// FUNCTION: setup_player_tanks
// CALLED ON: level
// PURPOSE: Loads all players into their tanks, keeps them from exiting. It replaces any unused
//          player tanks with friendly AI tanks and threads all the friendly vehicle AI stuff on
//          them.
// ADDITIONS NEEDED: None
/////////////////////////////////
setup_player_tanks()
{
	entry_points = [];
	for( i = 0; i < 4; i++ )
	{
		entry_points = array_add( entry_points, getstruct( "orig_enter_tanks"+(i+1), "targetname" ) );
	}
	
	for( i  = 0; i < entry_points.size; i++ )
	{	
		tank = getent( entry_points[i].target, "targetname" );
		if( isDefined( get_players()[i] ) )
		{
			tank.animname = "ot34";
			
			if( i == 2 )
			{
				flag_set( "coop" );
			}
			
			// Set the players' origin to the entry point because useby() is based on distance
			//players[i] setOrigin( entry_points[i].origin );
			get_players()[i] setOrigin( tank gettagorigin( "tag_enter_driver" ) );
			get_players()[i] setThreatBiasGroup( "players" );
			tank makevehicleunusable();
			/#
			tank makevehicleusable();
			#/
			
			tank useby( get_players()[i] );
			get_players()[i].mytank = tank;
			//get_players()[i] thread check_for_flamethrower();
			tank thread update_current_targeters();
			
			delta = maps\see2_breadcrumbs::add_new_breadcrumb_ent( tank, 10, 200 );
			if( isDefined( delta ) )
			{
				tank.my_targeting_delta = delta;
			}
			
			tank thread vehicle_damage();
			tank thread disconnect_paths_around_me_based_on_speed();
			//tank thread triggered_drop_bad_areas();
			//tank thread constant_drop_bad_place();
			tank thread friendly_fire_kill_tank();
			// god mode for tanks
			tank thread keep_tank_alive();
		}
		else
		{
				level.player_tanks = array_remove( level.player_tanks, tank );
				old_script_int = tank.script_int;
				tank delete();
				spawn_trigger = getEnt( "friendly "+i+" spawn_trigger", "script_noteworthy" );
				move_trigger = getEnt( "friendly "+i+" move_trigger", "script_noteworthy" );
				spawn_trigger notify( "trigger" );
				wait( 0.05 );
				move_trigger notify( "trigger" );
				wait( 0.05 );
				new_tank = getEnt( "friendly "+i, "script_noteworthy" );
				level.player_tanks = array_add( level.player_tanks, new_tank );
				new_tank.script_int = i;
				new_tank setSpeed( 0, 1000, 1000 );
				new_tank thread do_player_support();
				new_tank thread cleanup_targeting();
				new_tank maps\_vehicle::mgoff();
				new_tank.current_node = getVehicleNode( "friendly "+i+" start", "script_noteworthy" );
		}
	}
}

//-- Whenever a set of AI wants to retreat and try to pick a new goal node, they will
//   cause the player tanks to drop bad areas, so that the AI will try and avoid them a little smarter.

triggered_drop_bad_areas()
{
	self endon("death"); //-- shouldn't ever happen with a players tank...
	
	while(1)
	{
		level waittill("ai_set_new_retreat_node");
		
		self_forward = AnglesToForward(self.angles);
		self_right = AnglesToRight(self.angles);
		
		BadPlace_Cylinder( "center", 10, 			self.origin, 64, 100, "axis" );
		BadPlace_Cylinder( "front_left", 10, 	self.origin + (self_forward * 62) - (self_right * 62), 64, 100, "axis" );
		BadPlace_Cylinder( "front_right", 10, self.origin + (self_forward * 62) + (self_right * 62), 64, 100, "axis" );
		BadPlace_Cylinder( "rear_left", 10, 	self.origin - (self_forward * 62) - (self_right * 62), 64, 100, "axis" );
		BadPlace_Cylinder( "rear_right", 10, 	self.origin - (self_forward * 62) + (self_right * 62), 64, 100, "axis" );
		
		wait(5);
	}
	
}

constant_drop_bad_place()
{
	lifetime = 2;
	old_position = self.origin;
	
	while(1)
	{
		self_forward = AnglesToForward(self.angles);
		self_right = AnglesToRight(self.angles);
		
		if( distanceSquared(self.origin, old_position) > 8*8 )
		{
			BadPlace_Cylinder( "center", 				lifetime, 	self.origin, 200, 100, "axis" );
			//BadPlace_Cylinder( "front_left", 	lifetime, 	self.origin + (self_forward * 62) - (self_right * 62), 64, 100, "axis" );
			//BadPlace_Cylinder( "front_right", lifetime, 	self.origin + (self_forward * 62) + (self_right * 62), 64, 100, "axis" );
			//BadPlace_Cylinder( "rear_left", 	lifetime, 	self.origin - (self_forward * 62) - (self_right * 62), 64, 100, "axis" );
			//BadPlace_Cylinder( "rear_right", 	lifetime, 	self.origin - (self_forward * 62) + (self_right * 62), 64, 100, "axis" );
			old_position = self.origin;	
			wait(1);
		}
		else
		{
			wait(0.1);
		}
	}
}

//-- This is done on the player's tank to try and keep AI from running through him.
//-- going to try and do this based on speed.

disconnect_paths_around_me_based_on_speed()
{
	self endon("death"); //-- this will probably never get called
	
	while(1)
	{
		while( self GetSpeed() > 1 )
		{
			wait(0.05);
		}
		
		self DisconnectPaths();
		
		while(self GetSpeed() < 1)
		{
			wait(0.05);
		}
		
		self ConnectPaths();
	}
}

/////////////////////////////////
// FUNCTION: setup_delete_triggers
// CALLED ON: level
// PURPOSE: Threads delete_trigger behavior on all triggers threaded as such.
// ADDITIONS NEEDED: None
/////////////////////////////////
setup_delete_triggers()
{
	delete_triggers = getEntArray( "trigger_delete", "script_noteworthy" );
	for( i = 0; i < delete_triggers.size; i++ )
	{
		delete_triggers[i] thread do_delete_trigger();
	}
}

/////////////////////////////////
// FUNCTION: do_delete_trigger
// CALLED ON: a trigger whose script_noteworthy is trigger_delete
// PURPOSE: Deletes any entities that contact the trigger
// ADDITIONS NEEDED: None
/////////////////////////////////
do_delete_trigger()
{
	while( 1 ) 
	{
		self waittill( "trigger", guy );
		guy delete();
		wait( 0.05 );
	}
}

/////////////////////////////////
// FUNCTION: setup_early_tanks
// CALLED ON: level
// PURPOSE: sets up all flame bunker fortifications, makes player tanks invulnerable, threads a 
//          bunch of basic level functions. Is a poorly named function :(
// ADDITIONS NEEDED: None
/////////////////////////////////
setup_early_tanks()
{
	flak88_guard_array = GetEntArray( "flak 88 guards", "script_noteworthy" );
	array_thread(flak88_guard_array, ::add_spawn_function, ::setup_flak88_guard); 
	
	flame_bunker_array = GetEntArray( "flame bunker one guard", "script_noteworthy" );
	flame_bunker_array = array_combine( flame_bunker_array, GetEntArray( "flame bunker two guard", "script_noteworthy" ) );
	flame_bunker_array = array_combine( flame_bunker_array, GetEntArray( "flame bunker three guard", "script_noteworthy" ) );
	array_thread( flame_bunker_array, ::add_spawn_function, ::setup_flame_bunker_guard);
	
	//level thread setup_spawngroup_generics( 0 );
	
	/*
	vehicle = getent("the_gun","targetname");
		
	// here's the magic, the arty move function	
	vehicle do_arty_move( "initial_arty_node" );
	*/
	

/*
	level.friendly_tanks[0] = getent( "t34_1", "targetname" );
	level.friendly_tanks[1] = getent( "t34_2", "targetname" );
	level.friendly_tanks[2] = getent( "t34_3", "targetname" );
	
	level.friendly_tanks[0] thread keep_tank_alive();
	level.friendly_tanks[1] thread keep_tank_alive();
	level.friendly_tanks[2] thread keep_tank_alive();
*/
	
	thread do_flame_bunker( "flame bunker one", "bunker one flamed" , true, true, false, true );
	thread do_flame_bunker( "flame bunker two", "bunker two flamed" , true, true, true, true );
	thread do_flame_bunker( "flame bunker three", "bunker three flamed", true );
	thread do_flame_bunker( "flame bunker four", "bunker four flamed" , true, true, true );
	thread do_flame_bunker( "flame bunker six", "bunker six flamed" , true, true, true );
	thread keep_grenade_bags_from_spawning();
	//thread wait_for_guard_tower_sploders(); // Glocke: replaced by do_fortification_spawn
	thread do_fake_schrecks();
	
	level.player_tanks = [];
	for(i = 0; i < 4; i++ )
	{
		ent = getEnt( "player_tank_"+(i+1), "targetname" );
		if( isDefined( ent ) ) 
		{
			level.player_tanks = array_add( level.player_tanks, ent );
		}
	}
	
	// TEMP put in so players don't die in tanks
	for( i = 0; i < level.player_tanks.size; i++ )
	{
		if( isDefined( level.player_tanks[i] ) )
		{
			level.player_tanks[i] thread keep_tank_alive();
		}
	}
	level thread setup_friendly_advance_triggers();
	/#
	//level thread draw_ent_locations( level.friendly_tanks, "*TANK*", "stop_draw_tank_locations" );
	#/
}

/////////////////////////////////
// FUNCTION: do_area_spawn
// CALLED ON: level
// PURPOSE: waits on any area spawn triggers that exist for listed areaNum. Sends a signal that 
//					will start the area spawn when the trigger is activated
// ADDITIONS NEEDED: None
/////////////////////////////////
do_area_spawn( areaNum )
{
	trigger_array = getEntArray( "area"+areaNum+" spawn trigger", "targetname" );
	for( i = 0; i < trigger_array.size; i++ )
	{
		trigger_array[i] notify( "trigger" );
		wait_network_frame();
	}
	
	thread setup_spawngroup_generics( areaNum ); // Vehicle Spawns
	thread do_fortification_spawn( areaNum ); // Drone Spawns
	
	/*
	if( areaNum == 3 )
	{
		level thread do_tiger_retreats();
	}
	*/
	level notify( "area"+areaNum+" spawned" );
}

/////////////////////////////////
// FUNCTION: log_finished_event
// CALLED ON: level
// PURPOSE: This keeps track of events for use by other systems that may be waiting on an event.
//          This should probably be replaced with two or three flags in the subsystems still using
//          it.
// ADDITIONS NEEDED: Should be deprecated at some point
/////////////////////////////////
Log_Finished_Event( event, waittime )
{
	if( isDefined( waittime ) )
	{
		wait( waittime );
	}
	if( array_check_for_dupes( level.finished_events, event ) )
	{
		level.finished_events = array_add( level.finished_events, event );
		level notify( event );
	}
}

////////////////////////////
// PLAYER DAMAGE AND HUD
////////////////////////////

/////////////////////////////////
// FUNCTION: begin_armor_regen
// CALLED ON: player vehicle
// PURPOSE: This begins regenerating the player armor until the player is damaged or dies
// ADDITIONS NEEDED: None
/////////////////////////////////
begin_armor_regen()
{
	self endon( "damage" );
	self endon( "death" );
	
	while( 1 )
	{
		if( self.armor > self.maxarmor )
		{
			self.armor = self.maxarmor;
		}
		if( self.armor == self.maxarmor )
		{
			break;
		}
		
		self.armor += level.armor_per_frame;
		wait( 0.05 );
	}
	self notify( "armor_full" );
}

/////////////////////////////////
// FUNCTION: check_for_flamethrower
// CALLED ON: a player
// PURPOSE: This causes the hull mounted flamethrower or mg to mirror the player's turret 
//          direction, allowing aiming
// ADDITIONS NEEDED: None
/////////////////////////////////
check_for_flamethrower()
{
	self endon( "death" );
	self endon( "disconnect" );
	self.myTank endon( "death" );
	self.mytank thread do_my_loop();
}

/////////////////////////////////
// FUNCTION: do_my_loop
// CALLED ON: player tank
// PURPOSE: actually does the aiming of the hull gun
// ADDITIONS NEEDED: none
/////////////////////////////////
do_my_loop()
{
	self endon( "stop firing" );
	
	while( 1 ) 
	{
		angles = self getTagAngles( "tag_barrel" );
		
		angles = (angles[0]-5, angles[1], angles[2] );
		
		forward = anglesToForward( angles );
		
		target_vec = self getTagOrigin( "tag_gunner_barrel1" ) + (forward*50);
		
		self setGunnerTargetVec( target_vec, 0 );
		
		wait( 0.05 );
	}
}

/////////////////////////////////
// FUNCTION: vehicle_damage
// CALLED ON: player vehicle
// PURPOSE: This does the scripted damage system for the tank. It keeps track of an armor value
//          which is decreased by enemy attacks and also sets up the placeholder vehicle damage
//          hud elements. It then threads the functions that will keep track of and act on these
//          values.
// ADDITIONS NEEDED: None
/////////////////////////////////
vehicle_damage()
{
	self endon( "death" );
	players = get_players();
	vehicle_owner = self getvehicleowner();
	vehicle_owner endon( "death" );
	vehicle_owner endon( "disconnect" );
	
	myPlayer = undefined;
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] == vehicle_owner )
		{
			myPlayer = players[i];
		}
	}
	if( !isDefined( myPlayer ) )
	{
		return;
	}
	
	self.armor = level.see2_player_armor;
	self.maxarmor = level.see2_player_armor;
	//self.armorhudelem = newClientHudElem(myPlayer);
	//self.armorhudback = newClientHudElem(myPlayer);
	//self.armorhudelem.sort = 2;
	//self.armorhudelem.x = 111;
	//self.maxhudy = 72;
	//self.armorhudelem.y = 380;
	self.starty = 380;
	//self.armorhudback.sort = 1;
	//self.armorhudback.x = 110;
	//self.armorhudback.y = 379;
	//self.armorhudback setshader( "black", 11, 74 );
	//self.armorhudelem setshader( "white", 8, 72 );
	
	self thread do_veh_damage_hud();
	self thread do_veh_extra_damage_no_play();
	
	while( 1 )
	{
		
		self waittill( "damage", amount, attacker );
		
		
		if( isGodMode( myPlayer ) )
		{
			continue;
		}
		
		// ignore mortar hits TODO check this for other cases
		if( !array_check_for_dupes( get_players(), attacker ) || !array_check_for_dupes( level.player_tanks, attacker ) )
		{
			continue;
		}
		
		if( self.armor > 0 )
		{
			dmg_faked = amount * self.do_extra_dmg_no_fire;							//-- modifier if player isn't firing main turret
			
			if( IsDefined( self.too_close_damage_modifier) )
			{
				dmg_faked = dmg_faked * self.too_close_damage_modifier;		//-- modifier if player is humping an AI tank
			}
			
			self.armor -= dmg_faked;
		}
		else
		{
			self kill_tank();
		}
	
		if( isdefined( myPlayer ) )
		{
			hurtTime = gettime();
			level.hurtTime = hurtTime;
			
			if( amount < 500 )
			{
				myPlayer PlayRumbleOnEntity( "tank_damage_light_mp" );
			}
			else
			{
				myPlayer PlayRumbleOnEntity( "tank_damage_heavy_mp" );
			}
			
			myPlayer viewkick( 127, attacker.origin );
			myPlayer player_flag_set( "player_has_red_flashing_overlay" );
			myPlayer startfadingblur( 3, 2 );
	
			playerJustGotRedFlashing = true;
		}
	}
}

//-- This monitors whether or not the player has fired their turret or not, if they haven't then
//   the damage starts to scale up on the enemy tanks

do_veh_extra_damage_no_play()
{
	self endon("death");
	
	if(!IsDefined( self.do_extra_dmg_no_fire ) )
	{
		self.do_extra_dmg_no_fire = 1;
	}
	
	while(1)
	{
		self thread do_veh_extra_damage_no_play_update();
		self waittill("weapon_fired");
		self.do_extra_dmg_no_fire = 1;
		wait(0.05);
	}
	
}

do_veh_extra_damage_no_play_update()
{
	self endon("weapon_fired");
	wait(60);
	
	while(1)
	{
		if(self.do_extra_dmg_no_fire < 3)
		{
			self.do_extra_dmg_no_fire += level.no_shoot_increase;
			wait(5);
		}
		else
		{
			wait(10); //-- kind of arbitrary
		}
	}
}



/////////////////////////////////
// FUNCTION: kill_tank
// CALLED ON: player tank
// PURPOSE: This does the vehicle model swap, plays death fx and locks player controls. This is
//          because the player or tank dying does terrible things to the engine last I checked.
// ADDITIONS NEEDED: None
/////////////////////////////////
kill_tank()
{
	if(get_players().size > 1)
	{
		self see2_fail_the_mission_coop();
		return;
	}
	
	self setModel( "vehicle_rus_tracked_ot34_d" );
	playfx( level._effect["tank_destruct"], self.origin );
	player = self getVehicleOwner();
	player freezeControls( true );
	wait( 1 );
	maps\_utility::missionFailedWrapper();
}


see2_fail_the_mission_coop()
{
	self setModel( "vehicle_rus_tracked_ot34_d" );
	playfx( level._effect["tank_destruct"], self.origin );
	player = self getVehicleOwner();
	player freezeControls( true );
	
	players = get_players(); 
	for( i = 0; i < players.size; i++ )
	{
		if( isDefined( players[i] ) )
		{
			players[i] thread maps\_quotes::displayMissionFailed(); 
			if( players[i] == player )
			{
				players[i] thread maps\_quotes::displayPlayerDead(); 
				println( "Player #"+i+" is dead" ); 
			}
			else
			{
				players[i] thread maps\_quotes::displayTeammateDead( player ); 
				println( "Player #"+i+" is alive" ); 
			}
		}
	}
	
	wait( 1 );
	maps\_utility::missionFailedWrapper();
}



/////////////////////////////////
// FUNCTION: friendly_fire_kill_tank
// CALLED ON: player tank
// PURPOSE: This will trigger a mission fail if a player repeatedly shoots a friendly AI tank
//
// ADDITIONS NEEDED: None
/////////////////////////////////

friendly_fire_kill_tank()
{
	player = self getVehicleOwner();
	
	if(!isPlayer(player))
	{
		return;
	}
	
	player.friendlyfire_count = 0;
	player thread friendly_fire_kill_tank_reduce();
	
	while(1)
	{
		level waittill( "friendly attacked by player", attacker );
		
		if( player == attacker )
		{
			player.friendlyfire_count++;
		}
		
		if(player.friendlyfire_count >= 3)
		{
			maps\_friendlyfire::missionfail();
		}
	}	
}

friendly_fire_kill_tank_reduce()
{
	self endon("death");
	
	while(1)
	{
		while(self.friendlyfire_count == 0)
		{
			wait(0.05);
		}
		
		wait(10);
		self.friendlyfire_count--;
	}
}

/////////////////////////////////
// FUNCTION: cleanup_damage_hud
// CALLED ON: player
// PURPOSE: This gets rid of the damage hud for cutscenes, etc.
// ADDITIONS NEEDED: None
/////////////////////////////////
cleanup_damage_hud()
{
	self waittill( "stop damage hud" );
	
	//self.myTank.armorhudelem.alpha = 0;
	//self.myTank.armorhudback.alpha = 0;
}

/////////////////////////////////
// FUNCTION: do_veh_damage_hud
// CALLED ON: player vehicle
// PURPOSE: This shows the armor bar (which is temp) and decreases it appropriately. This will 
//          eventually be replaced by coloring the tank icon next to the compass red to show 
//          damage.
// ADDITIONS NEEDED: Will eventually be deprecated in favor of coloring tank icon through code
/////////////////////////////////
do_veh_damage_hud()
{
	self endon( "death" ); 
	
	vehicle_owner = self getvehicleowner();
	vehicle_owner endon( "death" );
	vehicle_owner endon( "disconnect" );
	vehicle_owner endon( "stop damage hud" );
	vehicle_owner thread cleanup_damage_hud();
	
	slow_flash_time = 1;
	slow_flash_color = (1, 1, 0);
	fast_flash_time = 0.5;
	fast_flash_color = (1, 0, 0);
	
	self thread regen_armor();
	
	current_time = 0;
	while( 1 )
	{
		percent = self.armor/self.maxarmor;
		if( percent < 0 )
		{
			percent = 0;
		}
		//current_y = int( self.maxhudy * percent );
		//if( current_y <= 0 )
		//{
			//current_y = 1;
		//}
		//self.armorhudelem setshader( "white", 8, current_y );
		//self.armorhudelem.y = self.starty + (self.maxhudy-current_y);
		
		if( percent > 0.1 && percent <= 0.25 )
		{
			if( current_time >= slow_flash_time )
			{
				current_time = 0;
			}
			percent_flash = current_time/slow_flash_time;
			//self.armorhudelem.color = ( (1-percent_flash)*(1,1,1) ) + (percent_flash*slow_flash_color);
			current_time += 0.05;
		}
		else if( percent < 0.1 )
		{
			if( current_time >= fast_flash_time )
			{
				current_time = 0;
			}
			percent_flash = current_time/fast_flash_time;
			//self.armorhudelem.color = ( (1-percent_flash)*(1,1,1) ) + (percent_flash*fast_flash_color);
			current_time += 0.05;
		}
		else
		{
			//self.armorhudelem.color = (1, 1, 1);
		}
		
		self setHealthPercent( percent );
		/*
		self.frontarmorhudelem setText( "front armor: "+self.frontarmor );
		self.backarmorhudelem setText( "back armor: "+self.backarmor );
		self.rightarmorhudelem setText( "right armor: "+self.rightarmor );
		self.leftarmorhudelem setText( "left armor: "+self.leftarmor );
		*/
		wait( 0.05 );
	}
}

/////////////////////////////////
// FUNCTION: regen_armor
// CALLED ON: player vehicle
// PURPOSE: This waits until the player has not been damaged for a sufficiently long time (set
//					in see2::difficulty_scale ) and then begins armor regeneration.
// ADDITIONS NEEDED: None
/////////////////////////////////
regen_armor()
{
	self endon( "death" );
	
	self.time_since_last_damage = 0;
	
	self thread update_damage_timer();
	self thread wait_for_damage_events();
	
	
	/*
	timer_widget = undefined;
	owner = self getVehicleOwner();
	if( isDefined( owner ) && isPlayer( owner ) )
	{
		timer_widget = newclienthudelem( owner );
		timer_widget.x = 20;
		timer_widget.y = 20;
		timer_widget settext( "Time before regen: 0" );
		timer_widget.alpha = 0;
	}
	*/
	
	while( 1 )
	{
		if( self.time_since_last_damage > level.time_before_regen )
		{
			/*
			if( isDefined( timer_widget ) )
			{
				timer_widget.alpha = 0;
			}
			*/
			self thread begin_armor_regen();
			self waittill_either( "damage", "armor_full" );
		}
		/*
		else if( isDefined( timer_widget ) )
		{
			timer_widget.alpha = 1;
			timer_widget settext( "Time before regen: "+(level.time_before_regen - self.time_since_last_damage) );
		}
		*/
		wait( 0.05 );
	}
}

/////////////////////////////////
// FUNCTION: update_damage_timer
// CALLED ON: player vehicle
// PURPOSE: Increments the time since the player tank has last been damaged
// ADDITIONS NEEDED: None
/////////////////////////////////
update_damage_timer()
{
	self endon( "death" );
	while( 1 )
	{
		self.time_since_last_damage += 0.05;
		wait( 0.05 );
	}
}

/////////////////////////////////
// FUNCTION: wait_for_damage_events
// CALLED ON: player vehicle
// PURPOSE: resets the damage timer to zero whenever the player tank is damaged
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_damage_events()
{
	self endon( "death" );
	while( 1 )
	{
		self waittill( "damage" );
		self.time_since_last_damage = 0;
		wait( 0.05 );
	}
}

/////////////////////////
// DIALOG SUPPORT
/////////////////////////

/////////////////////////////////
// FUNCTION: update_dialog_timer
// CALLED ON: level
// PURPOSE: Keeps track of the time since a dialog line has last been delivered
// ADDITIONS NEEDED: None
/////////////////////////////////
update_dialogue_timer()
{
	while( 1 )
	{
		level.dialogue_timer += 0.05;
		wait( 0.05 );
	}
}

/////////////////////////////////
// FUNCTION: wait_for_dialog_triggers
// CALLED ON: level
// PURPOSE: Creates a thread on all level dialog triggers waiting for them to trigger their
//          dialog event
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_dialog_triggers()
{
	wait_for_first_player();
	
	dialog_triggers = GetEntArray( "dialog trigger", "script_noteworthy" );
	for( i = 0; i < dialog_triggers.size; i++ )
	{
		dialog_triggers[i] thread wait_for_dialog_event();
	}
}

/////////////////////////////////
// FUNCTION: wait_for_dialog_event
// CALLED ON: dialog trigger
// PURPOSE: Waits until the dialog trigger is triggered, then plays the sound for the event
//          corresponding to its script_string (see ::init_level_flags below for examples of 
//					setting up events, their endon signals, complete signals and pertinent flags.
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_dialog_event()
{
	while( 1 )
	{
		self waittill( "trigger", guy );
		if( isPlayer( guy ) )
		{
			break;
		}
		wait( 0.05 );
	}
	
	do_sound_for_event( self.script_string );
	if( isDefined( level.kill_events[ self.script_string ] ) )
	{
		for( i = 0; i < level.kill_events[ self.script_string ].size; i++ )
		{
			level notify( level.endon_signals[ level.kill_events[self.script_string][i] ] );
		}
	}
}

/////////////////////////////////
// FUNCTION: init_level_flags
// CALLED ON: level
// PURPOSE: This initializes all level flags, including the ones used by the dialog system. The
//          dialog system does this by adding entries indexed by event name into five arrays. 
//					The arrays and their purposes are:
//					1. event_flags = this contains an array of all the flags that are used for this event.
//						              These flags will be run through ::update_target_flag below whenever
//                          this event is activated through ::do_sound_for_event. They will also
//													be passed into the function in the event_functions array. Maximum 
//													number of flags for an event is currently 6, this can be increased by
//													creating more arguments in the function calls contained in see2_sound.gsc
//					2. endon_signals = This is the signal which, if the level is notified with, will end
//													this dialogue function, stopping the playback of any future lines, but
//													not any queued lines from the event.
//          3. complete_signals = This is the signal which, if the event completes successfully, 
//													will be sent to the level as a notify.
//					4. event_functions = This is the event function that will be called with all elements
//                          of the event_flags array as arguments when the sound event is kicked 
//													off.
//					5. kill_events = This is the events that will have their kill signals sent automatically
//													when this event begins.
// ADDITIONS NEEDED: Add any new flags or events requested
/////////////////////////////////
init_level_flags()
{
	//Skipto flags
	level.skipto_flag_names = [];
	flag_init( "flak 88s destroyed" );
	level.skipto_flag_names = array_add( level.skipto_flag_names, "flak 88s destroyed" );
	flag_init( "radio tower destroyed" );
	level.skipto_flag_names = array_add( level.skipto_flag_names, "radio tower destroyed" );
	flag_init( "fuel depot cleared" );
	level.skipto_flag_names = array_add( level.skipto_flag_names, "fuel depot cleared" );
	flag_init( "final line breached" );
	level.skipto_flag_names = array_add( level.skipto_flag_names, "final line breached" );
	
	//General dialog flags
	flag_init( "playback happening" ); // used for queuing and resolving story events;
	flag_init( "battlechatter allowed" ); // allows preemption of battlechatter when appropriate during
																				// story events
	
	// Misc Flags
	flag_init( "coop" );
	flag_init( "left_path" );
	
	//EVENT FLAGS
	level.event_flags = [];
	level.endon_signals = [];
	level.complete_signals = [];
	level.event_functions = [];
	level.kill_events = [];
	
	//Battlechatter
	level.event_flags["battlechatter"] = [];
	flag_init( "do_firing" );
	level.event_flags["battlechatter"] = array_add( level.event_flags["battlechatter"], "do_firing" );
	flag_init( "heavy_damage" );
	level.event_flags["battlechatter"] = array_add( level.event_flags["battlechatter"], "heavy_damage" );
	flag_init( "damaged" );
	level.event_flags["battlechatter"] = array_add( level.event_flags["battlechatter"], "damaged" );
	flag_init( "infantry_close" );
	level.event_flags["battlechatter"] = array_add( level.event_flags["battlechatter"], "infantry_close" );
	flag_init( "retreaters" );
	level.event_flags["battlechatter"] = array_add( level.event_flags["battlechatter"], "retreaters" );
	flag_init( "destruction" );
	level.event_flags["battlechatter"] = array_add( level.event_flags["battlechatter"], "destruction" );
	flag_init( "idle" );
	level.event_flags["battlechatter"] = array_add( level.event_flags["battlechatter"], "idle" );
	level.endon_signals["battlechatter"] = "end battlechatter";
	level.complete_signals["battlechatter"] = "DNE";
	level.event_functions["battlechatter"] = ::do_battlechatter;
	
	
	//Destroy Artillery
	level.event_flags["objective intro"] = [];
	level.endon_signals["objective intro"] = "intro interrupt";
	level.complete_signals["objective intro"] = "commissar done";
	level.event_functions["objective intro"] = ::level_intro_announcements;
	
	level.event_flags["flamethrower_tutorial"] = [];
	flag_init( "flamethrower_fired_once" );
	level.event_flags["flamethrower_tutorial"] = array_add( level.event_flags["flamethrower_tutorial"], "flamethrower_fired_once" );
	flag_init( "ads_once" );
	level.event_flags["flamethrower_tutorial"] = array_add( level.event_flags["flamethrower_tutorial"], "ads_once" );
	flag_init( "flamethrower_close_to_inf" );
	level.event_flags["flamethrower_tutorial"] = array_add( level.event_flags["flamethrower_tutorial"], "flamethrower_close_to_inf" );
	flag_init( "killed_with_flamethrower" );
	level.event_flags["flamethrower_tutorial"] = array_add( level.event_flags["flamethrower_tutorial"], "killed_with_flamethrower" );
	level.endon_signals["flamethrower_tutorial"] = "engaged second 88";
	level.complete_signals["flamethrower_tutorial"] = "tank weapon tutorial complete";
	level.event_functions["flamethrower_tutorial"] = ::flamethrower_tutorial;
	
	level.event_flags["first_88_obj"] = [];
	level.event_flags["first_88_obj"] = array_add( level.event_flags["first_88_obj"], "destroyed first 88" );
	level.endon_signals["first_88_obj"] = "moved into field";
	level.complete_signals["first_88_obj"] = "first 88 destroyed";
	level.event_functions["first_88_obj"] = ::first_88_obj;
	
	level.event_flags["second_88_obj"] = [];
	level.event_flags["second_88_obj"] = array_add( level.event_flags["second_88_obj"], "destroyed second 88" );
	flag_init( "second 88 in sights" );
	level.event_flags["second_88_obj"] = array_add( level.event_flags["second_88_obj"], "second 88 in sights" );	
	level.endon_signals["second_88_obj"] = "moved past second position";
	level.complete_signals["second_88_obj"] = "second 88 destroyed";
	level.event_functions["second_88_obj"] = ::second_88_obj;
	
	level.event_flags["dead_88"] = [];
	flag_init( "destroyed first 88" );
	level.event_flags["dead_88"] = array_add( level.event_flags["dead_88"], "destroyed first 88" );
	flag_init( "destroyed second 88" );
	level.event_flags["dead_88"] = array_add( level.event_flags["dead_88"], "destroyed second 88" );
	flag_init( "destroyed third and fourth 88" );
	level.event_flags["dead_88"] = array_add( level.event_flags["dead_88"], "destroyed third and fourth 88" );
	flag_init( "destroyed second last 88" );
	level.event_flags["dead_88"] = array_add( level.event_flags["dead_88"], "destroyed second last 88" );
	flag_init( "destroyed last 88" );
	level.event_flags["dead_88"] = array_add( level.event_flags["dead_88"], "destroyed last 88" );
	level.endon_signals["dead_88"] = "stop track 88";
	level.complete_signals["dead_88"] = "all 88s dead";
	level.event_functions["dead_88"] = ::dead_88;
	
	level.event_flags["tank_move_fire_tutorial"] = [];
	flag_init( "first_fired_on_event" );
	level.event_flags["tank_move_fire_tutorial"] = array_add( level.event_flags["tank_move_fire_tutorial"], "first_fired_on_event" );
	flag_init( "first_shot" );
	level.event_flags["tank_move_fire_tutorial"] = array_add( level.event_flags["tank_move_fire_tutorial"], "first_shot" );
	level.endon_signals["tank_move_fire_tutorial"] = "skipped mf tutorial";
	level.complete_signals["tank_move_fire_tutorial"] = "tank move tutorial complete";
	level.event_functions["tank_move_fire_tutorial"] = ::tank_reload_movement_tutorial;
	
	level.event_flags["first_panther"] = [];
	flag_init( "panther_activated" );
	level.event_flags["first_panther"] = array_add( level.event_flags["first_panther"], "panther_activated" );
	flag_init( "panther_in_sights" );
	level.event_flags["first_panther"] = array_add( level.event_flags["first_panther"], "panther_in_sights" );
	flag_init( "panther_first_shot" );
	level.event_flags["first_panther"] = array_add( level.event_flags["first_panther"], "panther_first_shot" );
	flag_init( "panther_second_shot" );
	level.event_flags["first_panther"] = array_add( level.event_flags["first_panther"], "panther_second_shot" );
	flag_init( "panther_third_shot" );
	level.event_flags["first_panther"] = array_add( level.event_flags["first_panther"], "panther_third_shot" );
	flag_init( "panther_dead" );
	level.event_flags["first_panther"] = array_add( level.event_flags["first_panther"], "panther_dead" );
	level.endon_signals["first_panther"] = "engage last 88s";
	level.complete_signals["first_panther"] = "first panther dead";
	level.event_functions["first_panther"] = ::first_panther_prompt;
	
	level.event_flags["choose_path"] = [];
	level.endon_signals["choose_path"] = "path chosen";
	level.complete_signals["choose_path"] = "player chose... wisely";
	level.event_functions["choose_path"] = ::choose_path;
	
	level.event_flags["choose_right_path"] = [];
	level.event_flags["choose_right_path"] = array_add( level.event_flags["choose_right_path"], "destroyed third and fourth 88" );
	level.event_flags["choose_right_path"] = array_add( level.event_flags["choose_right_path"], "destroyed second last 88" );
	level.event_flags["choose_right_path"] = array_add( level.event_flags["choose_right_path"], "destroyed last 88" );
	level.endon_signals["choose_right_path"] = "stop choose right";
	level.complete_signals["choose_right_path"] = "all artillery destroyed";
	level.event_functions["choose_right_path"] = ::choose_right_path;
	
	level.event_flags["choose_left_path"] = [];
	level.event_flags["choose_left_path"] = array_add( level.event_flags["choose_left_path"], "destroyed third and fourth 88" );
	level.event_flags["choose_left_path"] = array_add( level.event_flags["choose_left_path"], "destroyed second last 88" );
	level.event_flags["choose_left_path"] = array_add( level.event_flags["choose_left_path"], "destroyed last 88" );
	level.endon_signals["choose_left_path"] = "stop choose left";
	level.complete_signals["choose_left_path"] = "all artillery destroyed";
	level.event_functions["choose_left_path"] = ::choose_left_path;
	
	level.event_flags["player_exposed"] = [];
	flag_init( "internal_first_warning_given" );
	level.event_flags["player_exposed"] = array_add( level.event_flags["player_exposed"], "internal_first_warning_given" );
	flag_init( "internal_second_warning_given" );
	level.event_flags["player_exposed"] = array_add( level.event_flags["player_exposed"], "internal_second_warning_given" );
	level.endon_signals["player_exposed"] = "player not exposed";
	level.complete_signals["player_exposed"] = "all warnings given";
	level.event_functions["player_exposed"] = ::player_exposed;
	
	// Radio tower
	level.event_flags["radio_tower_dialog"] = [];
	flag_init( "radio_tower_visible" );
	level.event_flags["radio_tower_dialog"] = array_add( level.event_flags["radio_tower_dialog"], "radio_tower_visible" );
	flag_init( "radio_tower_close" );
	level.event_flags["radio_tower_dialog"] = array_add( level.event_flags["radio_tower_dialog"], "radio_tower_close" );
	flag_init( "radio_tower_destroyed" );
	level.event_flags["radio_tower_dialog"] = array_add( level.event_flags["radio_tower_dialog"], "radio_tower_destroyed" );
	level.kill_events["radio_tower_dialog"] = [];
	level.kill_events["radio_tower_dialog"] = array_add( level.kill_events["radio_tower_dialog"], "first_88_obj" );
	level.kill_events["radio_tower_dialog"] = array_add( level.kill_events["radio_tower_dialog"], "second_88_obj" );
	level.kill_events["radio_tower_dialog"] = array_add( level.kill_events["radio_tower_dialog"], "dead_88" );
	level.kill_events["radio_tower_dialog"] = array_add( level.kill_events["radio_tower_dialog"], "first_panther" );
	level.kill_events["radio_tower_dialog"] = array_add( level.kill_events["radio_tower_dialog"], "choose_path" );
	level.kill_events["radio_tower_dialog"] = array_add( level.kill_events["radio_tower_dialog"], "choose_left_path" );
	level.kill_events["radio_tower_dialog"] = array_add( level.kill_events["radio_tower_dialog"], "choose_right_path" );
	level.kill_events["radio_tower_dialog"] = array_add( level.kill_events["radio_tower_dialog"], "player_exposed" );
	level.endon_signals["radio_tower_dialog"] = "do not interrupt";
	level.complete_signals["radio_tower_dialog"] = "radio tower destroyed";
	level.event_functions["radio_tower_dialog"] = ::radio_tower_dialog;
	
	// Fuel Depot
	level.event_flags["fuel_depot_dialog"] = [];
	level.endon_signals["fuel_depot_dialog"] = "do not interrupt";
	level.complete_signals["fuel_depot_dialog"] = "fuel depot done";
	level.event_functions["fuel_depot_dialog"] = ::fuel_depot_dialog;
	
	// Final Battle
	level.event_flags["final_battle_dialog"] = [];
	level.endon_signals["final_battle_dialog"] = "do not interrupt";
	level.complete_signals["final_battle_dialog"] = "final done";
	level.event_functions["final_battle_dialog"] = ::final_battle_dialog;
	
	// Victory
	//level.event_flags["victory_dialog"] = [];
	//level.endon_signals["victory_dialog"] = "do not interrupt";
	//level.complete_signals["victory_dialog"] = "victory done";
	//level.event_functions["victory_dialog"] = ::victory_dialog;
	
	// GLocke: objective flags to check if the 2 optional objectives had been completed at the end of the map.
	flag_init( "flak objective completed" );
	flag_init( "radio tower objective completed" );
	flag_init( "final battle already started" );
	
	flag_init( "player_ready_for_outro" );
	flag_init( "outro_group_1_ready" );
	flag_init( "outro_group_2_ready" );
	
}

/////////////////////////////////
// FUNCTION: do_sound_for_event
// CALLED ON: level
// PURPOSE: This is the function called through script or through the dialog_trigger setup that
//          will playback the sound for an event using the function setup specified in 
//					::init_level_flags. It also does some very basic error checking to keep it from
//					double threading events and running improperly setup events
// ADDITIONS NEEDED: None
/////////////////////////////////
do_sound_for_event( event )
{
	if( !isDefined( event ) || !isDefined( level.event_flags[event] ) || !isDefined( level.endon_signals[event] ) || !isDefined( level.complete_signals[event] ) || !isDefined( level.event_functions[event] ) )
	{
		error( "Requested sound event '"+event+"' is not setup properly" );
	}
	
	if( !array_check_for_dupes( level.finished_events, event ) )
	{
		return;
	}
	
	level.finished_events = array_add( level.finished_events, event );
	
	for( i = 0; i < level.event_flags[event].size; i++ )
	{
		if( !isSubStr( "internal_", level.event_flags[event][i] ) )
		{
			level thread update_target_flag( level.event_flags[event][i] );
		}
	}
	level thread [[ level.event_functions[event] ]]( level.endon_signals[event], level.complete_signals[event], level.event_flags[event][0], level.event_flags[event][1], level.event_flags[event][2], level.event_flags[event][3], level.event_flags[event][4], level.event_flags[event][5], level.event_flags[event][6] );
}

/////////////////////////////////
// FUNCTION: update_target_flag
// CALLED ON: level
// PURPOSE: This is threaded for each flag in a sound event. It is a giant switch statement that
//          compartmentalizes all the logic for each individual flag in a case specified by the 
//          flag name
// ADDITIONS NEEDED: Add any needed flags for new events
/////////////////////////////////
update_target_flag( flag )
{
	switch( flag )
	{
		//"heavy_damage"
		case "heavy_damage":
		player = get_players()[0];
		while( 1 )
		{
			if( !isDefined( player.myTank ) )
			{
				wait( 0.05 );
				continue;
			}
			player.myTank waittill( "damage", amount );
			old_percent = player.myTank.armor/player.myTank.maxarmor;
			new_percent = (player.myTank.armor-amount)/player.myTank.maxarmor;
			if( (old_percent > 0.2 && new_percent <= 0.2) || ( old_percent > 0.5 && new_percent <= 0.5 ) ) 
			{
				flag_set( "heavy_damage" );
				wait( 3 );
				flag_clear( "heavy_damage" );
				wait( 8 );
			}
		}
		
		//"do_firing"
		case "do_firing":
		player = get_players()[0];
		while( 1 )
		{
			if( !isDefined( player.myTank ) )
			{
				wait( 0.05 );
				continue;
			}
			angles = player.myTank getTagAngles( "tag_flash" );
			origin = player.myTank getTagOrigin( "tag_flash" );
			vec = anglestoforward( angles );
			
			trace = bullettrace( origin, origin + vec*5000, false, player.myTank );
			if( trace["fraction"] < 0.95 ) 
			{
				ent = trace["entity"];
				if( isDefined( ent ) )
				{
					if( !array_check_for_dupes( level.enemy_armor, ent ) && ent.classname != "script_vehicle_corpse" ) 
					{
						flag_set( "do_firing" );
					}
				}
			}
			
			wait( 4 );
		}
		
		//"damaged"
		case "damaged":
		player = get_players()[0];
		while( 1 )
		{
			if( !isDefined( player.myTank ) )
			{
				wait( 0.05 );
				continue;
			}
			player.myTank waittill( "damage", amount );
			flag_set( "damaged" );
			wait( 0.5 );
			flag_clear( "damaged" );
			wait( 8 );
		}
		
		//"infantry_close"
		case "infantry_close":
		player = get_players()[0];
		while( 1 )
		{
			close_count = 0;
			for( i = 0; i < level.enemy_infantry.size; i++ )
			{
				if( isDefined( level.enemy_infantry[i] ) )
				{
					if( distanceSquared( player.myTank.origin, level.enemy_infantry[i].origin ) < level.min_distance_for_close_infantry*level.min_distance_for_close_infantry )
					{
						close_count++;
					}
				}
			}
			if( close_count > level.min_close_infantry_for_warning )
			{
				flag_set( "infantry_close" );
				wait( 3 );
				flag_clear( "infantry_close" );
			}
			wait( 3 );
		}
		
		//"retreaters"
		case "retreaters":
		player = get_players()[0];
		while( 1 )
		{
			level waittill( "retreaters", ent );
			
			if( check_for_visible( player, ent, 3000 ) )
			{
				flag_set( "retreaters" );
				wait( 4 );
				flag_clear( "retreaters" );
			}
		}
		
		//"destruction"
		case "destruction":
		player = get_players()[0];
		while( 1 )
		{
			level waittill( "destruction" );
			flag_set( "destruction" );
			wait( 4 );
			flag_clear("destruction" );
		}
		
		//"idle"
		case "idle":
		player = get_players()[0];
		prev_position = player.origin;
		
		while( 1 )
		{
			if( distanceSquared( prev_position, player.origin ) < level.min_idle_dist_sq )
			{
				level.current_idle_time += 0.05;
				if( level.current_idle_time >= level.idle_warn_time )
				{
					level.current_idle_time = 0;
					flag_set( "idle" );
					wait( 4 );
					flag_clear( "idle" );
				}
			}
			else
			{
				level.current_idle_time = 0;
			}
			prev_position = player.origin;
		}
		
		//"flamethrower_fired_once"
		case "flamethrower_fired_once":
		players = get_players();
		for( i = 0; i < players.size; i++ )
		{
			players[0] thread inform_on_ft_button( "ft_pressed" );
		}
		level waittill_notify_or_timeout( "ft_pressed", 6 );
		players[0] notify( "go_past_ft_tut" );
		flag_set( "flamethrower_fired_once" );
		break;
		
		//"ads_once"
		case "ads_once":
		players = get_players();
		for( i = 0; i < players.size; i++ )
		{
			players[0] thread inform_on_ads_button( "ads_pressed" );
		}
		level waittill_notify_or_timeout( "ads_pressed", 14 ); //-- needs the extra time to wait out the ft tutorial
		players[0] notify( "go_past_ads_tut" );
		flag_set( "ads_once" );
		break;
		
		//"flamethrower_close_to_inf"
		case "flamethrower_close_to_inf":
		players = get_players();
		for( i = 0; i < players.size; i++ )
		{
			players[i] thread check_close_to_stuck_inf( "player_close", 1200 );
		}
		level waittill( "player_close" );
		flag_set( "flamethrower_close_to_inf" );
		wait( 1 );
		flag_set( "battlechatter allowed" );
		break;
		
		//"destroyed first 88"
		case "destroyed first 88":
		while( 1 )
		{
			if( (level.max_active_arty - level.active_arty) > 0 )
			{
				break;
			}
			wait( 0.05 );
		}
		flag_set( "destroyed first 88" );
		break;
		
		//"second 88 in sights"
		case "second 88 in sights":
		second_arty = getEnt( "arty 3", "targetname" );
		in_player_sights = false;
		while( in_player_sights == false ) 
		{
			if( !isDefined( second_arty ) )
			{
				break;
			}
			for( i = 0; i < get_players().size && !in_player_sights; i++ )
			{
				toVec = second_arty.origin - get_players()[i].origin;
				forward = anglesToForward( get_players()[i].angles );
				toVec = ( toVec[0], toVec[1], 0 );
				forward = ( forward[0], forward[1], 0 );
				diff = VectorDot( VectorNormalize( forward ), VectorNormalize( toVec ) );
				if( acos( diff ) < 65 )
				{
					in_player_sights = true;
				}
			}
			wait( 1 );
		}
		flag_set( "second 88 in sights" );
		break;
		
		//"destroyed second 88"
		case "destroyed second 88":
		while( 1 )
		{
			if( (level.max_active_arty - level.active_arty) > 1 )
			{
				break;
			}
			wait( 0.05 );
		}
		flag_set( "destroyed second 88" );
		break;
		
		//"destroyed third and fourth 88"
		case "destroyed third and fourth 88":
		while( 1 )
		{
			if( (level.max_active_arty - level.active_arty) > 3 )
			{
				break;
			}
			wait( 0.05 );
		}
		flag_set( "destroyed third and fourth 88" );
		break;
		
		//"destroyed second last 88"
		case "destroyed second last 88":
		while( 1 )
		{
			if( level.active_arty < 2 )
			{
				break;
			}
			wait( 0.05 );
		}
		flag_set( "destroyed second last 88" );
		break;
		
		//"destroyed last 88"
		case "destroyed last 88":
		while( 1 )
		{
			if( level.active_arty == 0 )
			{
				break;
			}
			wait( 0.05 );
		}
		flag_set( "destroyed last 88" );
		break;
		
		//"first_fired_on_event"
		case "first_fired_on_event":
		flag_set( "first_fired_on_event" );
		break;
		
		//"first_shot"
		case "first_shot":
		players = get_players();
		for( i = 0; i < players.size; i++ )
		{
			players[i] thread wait_for_player_shoot_event( "player shot" );
		}
		level waittill( "player shot" );
		flag_set( "first_shot" );
		break;
		
		//"panther_activated"
		case "panther_activated":
		trigger = GetEnt( "panther activate trigger", "targetname" );
		trigger waittill( "trigger" );
		wait( 8 );
		flag_set( "panther_activated" );
		
		//"panther_in_sights"
		case "panther_in_sights":
		flag_wait( "panther_activated" );
		panther = getEnt( "lineveh 4 group0", "script_noteworthy" );
		in_player_sights = false;
		while( in_player_sights == false ) 
		{
			if( !isDefined( panther ) )
			{
				break;
			}
			for( i = 0; i < get_players().size && !in_player_sights; i++ )
			{
				toVec = panther.origin - get_players()[i].origin;
				forward = anglesToForward( get_players()[i].angles );
				toVec = ( toVec[0], toVec[1], 0 );
				forward = ( forward[0], forward[1], 0 );
				diff = VectorDot( VectorNormalize( forward ), VectorNormalize( toVec ) );
				if( acos( diff ) < 30 )
				{
					in_player_sights = true;
				}
			}
			wait( 1 );
		}
		flag_set( "panther_in_sights" );
		break;
		
		//"panther_first_shot"
		case "panther_first_shot":
		panther = getEnt( "lineveh 4 group0", "script_noteworthy" );
		damaged_by_player = false;
		while( !damaged_by_player )
		{
			if( panther.classname == "script_vehicle_corpse" || panther.health < 1 )
			{
				break;
			}
			panther waittill( "damage", amt, guy );
			damaged_by_player = check_damaged_by_player( guy );
			wait( 0.05 );
		}
		flag_set( "panther_first_shot" );
		break;
		
		//"panther_second_shot"
		case "panther_second_shot":
		panther = getEnt( "lineveh 4 group0", "script_noteworthy" );
		flag_wait( "panther_first_shot" );
		damaged_by_player = false;
		while( !damaged_by_player )
		{
			if( panther.classname == "script_vehicle_corpse" || panther.health < 1 )
			{
				break;
			}
			panther waittill( "damage", amt, guy );
			damaged_by_player = check_damaged_by_player( guy );
			wait( 0.05 );
		}
		flag_set( "panther_second_shot" );
		break;
		
		//"panther_third_shot"
		case "panther_third_shot":
		panther = getEnt( "lineveh 4 group0", "script_noteworthy" );
		flag_wait( "panther_first_shot" );
		flag_wait( "panther_second_shot" );
		damaged_by_player = false;
		while( !damaged_by_player )
		{
			if( panther.classname == "script_vehicle_corpse" || panther.health < 1 )
			{
				break;
			}
			panther waittill( "damage", amt, guy );
			damaged_by_player = check_damaged_by_player( guy );
			wait( 0.05 );
		}
		flag_set( "panther_third_shot" );
		break;
		
		//"panther_dead"
		case "panther_dead":
		panther = getEnt( "lineveh 4 group0", "script_noteworthy" );
		panther waittill( "death" );
		flag_set( "panther_dead" );
		break;

		//"radio_tower_visible"
		case "radio_tower_visible":
		radio_tower = GetEnt( "radio tower", "script_noteworthy" );
		visible = false;
		while( !visible )
		{
			for( i = 0; i < get_players().size && !visible; i++ )
			{
				if( check_for_visible( get_players()[i], radio_tower, 8500 ) )
				{
					visible = true;
				}
			}
			wait( 0.05 );
		}
		flag_set( "radio_tower_visible" );
		break;
		
		//"radio_tower_close"
		case "radio_tower_close":
		radio_tower = GetEnt( "radio tower", "script_noteworthy" );
		close = false;
		while( !close )
		{
			for( i = 0; i < get_players().size && !close; i++ )
			{
				if( check_for_close( get_players()[i], radio_tower, 3500 ) )
				{
					close = true;
				}
				wait( 0.05 );
			}
		}
		flag_set( "radio_tower_close" );
		break;
		
		//"radio_tower_destroyed"
		case "radio_tower_destroyed":
		radio_tower = GetEnt( "radio tower", "script_noteworthy" );
		while( 1 )
		{
			if( radio_tower.model == "anim_seelow_radiotower_d" )
			{
				break;
			}
			wait( 0.05 );
		}
		wait( 3 );
		flag_set( "radio_tower_destroyed" );
		break;
	}
}

/////////////////////////////////
// FUNCTION: check_for_close
// CALLED ON: level
// PURPOSE: Helper function - checks to see if a player is within a specific distance of an object
// ADDITIONS NEEDED: None
/////////////////////////////////
check_for_close( player, object, dist ) 
{
	if( distanceSquared( player.origin, object.origin ) < dist*dist )
	{
		return true;
	}
	return false;
}

/////////////////////////////////
// FUNCTION: check_for_arty_destroyed
// CALLED ON: level
// PURPOSE: Helper function - Waits until an artillery in the passed array is destroyed then 
//          returns.
// ADDITIONS NEEDED: None
/////////////////////////////////
check_for_arty_destroyed( arty_array, inform ) 
{
	dead_arty = false;
	while( !dead_arty )
	{
		for( i = 0; i < arty_array.size; i++ )
		{
			if( check_for_arty_dead( arty_array[i] ) )
			{
				dead_arty = true;
			}
		}
	}
}

/////////////////////////////////
// FUNCTION: check_for_visible
// CALLED ON: level
// PURPOSE: Helper function - Checks to see if a player is within a certain number of units of an
//					object and if it is in the player's view arc.
// ADDITIONS NEEDED: Possibly add a trace confirmation at some point
/////////////////////////////////
check_for_visible( player, object, dist )
{
	toVec = object.origin - player.origin;
	forward = anglesToForward( player.angles );
	toVec = ( toVec[0], toVec[1], 0 );
	forward = ( forward[0], forward[1], 0 );
	diff = VectorDot( VectorNormalize( forward ), VectorNormalize( toVec ) );
	if( acos( diff ) < 65 && distanceSquared( player.origin, object.origin ) < dist * dist )
	{
		return true;
	}
	return false;
}

/////////////////////////////////
// FUNCTION: check_for_either_arty_destroyed
// CALLED ON: level
// PURPOSE: Checks for either artillery passed being dead then gives a notify once one dies.
// ADDITIONS NEEDED: Maybe deprecate since it is mostly a special case of 
//   								 ::check_for_arty_destroyed
/////////////////////////////////
check_for_either_arty_destroyed( arty1, arty2, inform )
{
	level endon( inform );
	while( 1 )
	{
		if( check_for_arty_dead( arty1 ) || check_for_arty_dead( arty2 ) )
		{
			break;
		}
		wait( 0.05 );
	}
	level notify( inform );
}

/////////////////////////////////
// FUNCTION: check_for_both_arty_destroyed
// CALLED ON: level
// PURPOSE: Checks to see that both arty are destroyed then notifies the level when they are
// ADDITIONS NEEDED: Maybe deprecate since it is mostly a special case of 
//                   ::check for arty destroyed.
/////////////////////////////////
check_for_both_arty_destroyed( arty1, arty2, inform )
{
	level endon( inform );
	while( 1 )
	{
		if( check_for_arty_dead( arty1 ) && check_for_arty_dead( arty2 ) )
		{
			break;
		}
		wait( 0.05 );
	}
	level notify( inform );
}

/////////////////////////////////
// FUNCTION: check_for_arty_dead
// CALLED ON: level
// PURPOSE: Checks to see if an artillery has no crew or has been destroyed somehow
// ADDITIONS NEEDED: None
/////////////////////////////////
check_for_arty_dead( arty )
{
	if( !isDefined( arty ) || arty.health < 1 || arty.classname == "script_vehicle_corpse" || arty.crewsize < 1 )
	{
		return true;
	}
	return false;
}

/////////////////////////////////
// FUNCTION: check_damaged_by_player
// CALLED ON: level
// PURPOSE: Helper function - Checks to see if the attacker was a player or his tank since 
//					vehicle damage gets attributed weirdly.
// ADDITIONS NEEDED: None
/////////////////////////////////
check_damaged_by_player( guy )
{
	damaged_by_player = false;
	for( i = 0; i < get_players().size; i++ )
	{
		if( guy == get_players()[i] || guy == get_players()[i].myTank )
		{
			damaged_by_player = true;
		}
	}
	return damaged_by_player;
}

/////////////////////////////////
// FUNCTION: wait_for_player_shoot_event
// CALLED ON: level
// PURPOSE: Helper Function - Waits until one player has attacked then sends a level notify
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_player_shoot_event( inform )
{
	level endon( inform );
	while( 1 )
	{
		if( self AttackButtonPressed() )
		{
			break;
		}
		wait( 0.05 );
	}
	level notify( inform );
}

/////////////////////////////////
// FUNCTION: wait_for_player_damage_event
// CALLED ON: level
// PURPOSE: Helper Function - Waits until one player has been damaged then sends a level notify
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_player_damage_event( inform )
{
	level endon( inform );
	self waittill( "tank hit" );
	level notify( inform );
}

/////////////////////////////////
// FUNCTION: check_close_to_stuck_inf
// CALLED ON: level
// PURPOSE: Checks to see if the player is within a certain distance of infantry with their 
//          script_noteworthy set to stuck infantry
// ADDITIONS NEEDED: None
/////////////////////////////////
check_close_to_stuck_inf( inform, dist ) 
{
	stuck_infantry = [];
	while( stuck_infantry.size < 1 )
	{
		stuck_infantry = get_living_ai_array( "stuck infantry", "script_noteworthy" );
		wait( 0.05 );
	}

	close_enough = false;
	while( !close_enough ) 
	{
		for( i = 0; i < stuck_infantry.size && !close_enough; i++ )
		{
			if( isDefined( stuck_infantry[i] ) )
			{
				if( distanceSquared( self.origin, stuck_infantry[i].origin ) < dist*dist)
				{
					close_enough = true;
				}
			}
		}
		wait( 0.05 );
	}
	level notify( inform );
}

/////////////////////////////////
// FUNCTION: inform_on_ft_button
// CALLED ON: player
// PURPOSE: sends a level notify when the player has pressed their +frag button
// ADDITIONS NEEDED: None
/////////////////////////////////
inform_on_ft_button( inform )
{
	while( 1 )
	{
		if( self FragButtonPressed() )
		{
			level notify( inform );
			return;
		}
		wait( 0.05 );
	}
}

/////////////////////////////////
// FUNCTION: inform_on_ads_button
// CALLED ON: player
// PURPOSE: sends a level notify when the player has pressed their +speed_throw button
// ADDITIONS NEEDED: None
/////////////////////////////////
inform_on_ads_button( inform )
{
	while( 1 )
	{
		if( self AdsButtonPressed() )
		{
			level notify( inform );
			return;
		}
		wait( 0.05 );
	}
}

//////////////////////////
// INFANTRY
//////////////////////////

/////////////////////////////////
// FUNCTION: spawn_guys
// CALLED ON: anything
// PURPOSE: spawns infantry from an array of spawners, using network gating
// ADDITIONS NEEDED: None
/////////////////////////////////
spawn_guys( spawners, target_name, ok_to_spawn )
{
	guys = [];

	for( i = 0; i < spawners.size; i++ )
	{
		if(NumRemoteClients() == 0) //-- If there are no remote clients, then do not use OkToSpawn
		{
			guy = spawn_guy( spawners[i], target_name, false );
		}
		else
		{
			guy = spawn_guy( spawners[i], target_name, ok_to_spawn );
		}
		if( IsDefined( guy ) )
		{
			guys[guys.size] = guy;
		}
	}

	// We do not want to return the guys if ok_to_spawn is used. Since a guy in the array may be dead.
	// So, only return the guys array if we do not want to ok_to_spawn.
	if( !IsDefined( ok_to_spawn ) || !ok_to_spawn )
	{
		return guys;
	}
}

/////////////////////////////////
// FUNCTION: spawn_guy
// CALLED ON: anything
// PURPOSE: spawns a guy, potentially observing networking
// ADDITIONS NEEDED: None
/////////////////////////////////
spawn_guy( spawner, target_name, ok_to_spawn )
{
	if( IsDefined( ok_to_spawn ) && ok_to_spawn )
	{
		while( !OkToSpawn() )
		{
			wait( 0.1 );
		}
	}

	if( IsDefined( spawner.script_forcespawn ) && spawner.script_forcespawn )
	{
		guy = spawner StalingradSpawn(); 
	}
	else
	{
		guy = spawner DoSpawn(); 
	}

	if( !spawn_failed( guy ) )
	{
		if( IsDefined( target_name ) )
		{
			guy.targetname = target_name;
		}

		return guy; 
	}

	return undefined; 
}

/////////////////////////////////
// FUNCTION: do_floodspawners
// CALLED ON: level
// PURPOSE: Does network gated floodspawning for the radio tower area
// ADDITIONS NEEDED: Generalize so it can be used at the train station as well
/////////////////////////////////
do_floodspawners( areaname, time )
{
	trigger = getEnt( "radio tower back half", "script_noteworthy" );
	
	level endon( trigger.script_noteworthy );
	
	trigger thread inform_on_touch_trigger( trigger.script_noteworthy );
	
	floodspawners = getEntArray( areaname+" floodspawner", "script_noteworthy" );
	spawners = [];
	
	
	//NETWORK: throttle for only 2+ player (changed to throttle all the time because of it was slowing down the game);
	//flood_spawner_max_size = level.max_ai_spawn_current;
	//if(get_players().size > 1)
	//{
  //  flood_spawner_max_size = 24; //32 for single player
	//}
	
	x = 0; //-- we want to force the spawners the first time
	y = 0;
	
	while( 1 )
	{
		ai = getaiarray( "axis" );
		
		if( ( ai.size < level.max_ai_spawn_current || x < 5 ) && y < 10)
		{
			spawners[0] = floodspawners[randomint(floodspawners.size)];
			spawn_guys( spawners, undefined, true );
			spawners[0].count++;
			x++;
			y++;
		}
		wait( time );
	}
}

/////////////////////////////////
// FUNCTION: fuel_depot_infantry_evasion
// CALLED ON: an infantryman
// PURPOSE: This causes the infantry in the fuel depot to choose a retreat position and take it
//          when the player hits a trigger
// ADDITIONS NEEDED: Generalize this function and improve the name
/////////////////////////////////
fuel_depot_infantry_evasion()
{
	self endon( "death" );
	
	trigger = GetEnt( "fuel depot retreat trigger", "script_noteworthy" );
	
	trigger waittill( "trigger" );
	
	wait( randomfloatrange( 0.5, 3 ) );
	
	retreat_node = level.fuel_depot_goal_nodes[ randomint( level.fuel_depot_goal_nodes.size ) ];
	
	self setGoalNode( retreat_node );
}

/////////////////////////////////
// FUNCTION: enforce_flame_deaths
// CALLED ON: an infantryman
// PURPOSE: Since the damageweapon for the player tank is misattributed, this tries to override
//          it and force a flame death whenever the AI receives MOD_BURNED damage. 
// ADDITIONS NEEDED: This currently doesn't work consistently, need to figure out how to prevent
//									 subsequent frame's damage from overriding the flame death anim
/////////////////////////////////
enforce_flame_deaths()
{
	self endon( "death" );
	
	while( 1 )
	{
		self waittill( "damage", amount, other, direction_vec, point, type );
		if( type == "MOD_BURNED" )
		{
			self.a.forceflamedeath = true;
			self doDamage( self.health * 2, self.origin );
		}
	}
}

/////////////////////////////////
// FUNCTION: radio_tower_infantry_evasion
// CALLED ON: an infantryman
// PURPOSE: This causes an infantryman to shift between a variety of cover nodes and try to stay
//					out of player view arcs.
// ADDITIONS NEEDED: This should be generalized and renamed for application elsewhere
/////////////////////////////////
radio_tower_infantry_evasion()
{
	self endon( "death" );
	
	players = get_players();
	timer = 0;
	min_time_before_shift = 6;
	max_time_before_shift = 12;
	
	while( 1 )
	{
		inArc = false;
		for( i = 0; i < players.size && !inArc; i++ )
		{
			if( isDefined( players[i] ) )
			{
				inArc = self is_in_player_arc( players[i] );
			}
		}
		if( timer > randomfloatrange( min_time_before_shift, max_time_before_shift ) || ( timer > min_time_before_shift && inArc ) )
		{
			//self setGoalNode( level.radio_tower_goal_nodes[ randomint( level.radio_tower_goal_nodes.size ) ] );
			self notify("radio_set_new_goal_node");
			self waittill( "goal" );
		}
		timer += 0.5;
		wait( 0.5 );
	}
}


radio_tower_infantry_grenades()
{
	self endon("death");
	
	while( 1 )
	{
		
		self waittill( "radio_set_new_goal_node" );
		
		if( self.classname != "actor_axis_ger_ber_wehr_reg_kar98k" )
		{
			self setGoalNode( level.radio_tower_goal_nodes[ randomint( level.radio_tower_goal_nodes.size ) ] );
			return;
		}
			
		random_grenade_chance = RandomIntRange(0, 100);
		
		if( random_grenade_chance > 70 )
		{
			players = get_players();
			
			my_target = players[0].myTank;
			for( i=1; i < players.size; i++ )
			{
				if( distanceSquared(self.origin, my_target.origin) > distanceSquared(self.origin, players[i].myTank.origin) )
				{
					my_target = players[i].myTank;
				}
			}
			
			self maps\_grenade_toss::force_grenade_toss(	my_target.origin, undefined, 3, undefined, undefined );
		}
		
		self setGoalNode( level.radio_tower_goal_nodes[ randomint( level.radio_tower_goal_nodes.size ) ] );
	}
}


/////////////////////////////////
// FUNCTION: do_antitank_AI
// CALLED ON: an infantryman
// PURPOSE: This causes panzershreck guys to manually target the tank rather than the player camera
//          position.
// ADDITIONS NEEDED: This should be fleshed out into better behavior for small arms guys and should
//										make panzershreck guys a little less deadly.
/////////////////////////////////
do_antitank_AI()
{
	self endon( "death" );
	
	while( 1 )
	{
		best_target = self maps\_vehicle::get_nearest_target( level.player_tanks );
		if( isDefined( best_target ) )
		{
			dist = distanceSquared( best_target.origin, self.origin );
			if( dist < level.max_panzerschreck_eng_distsq && dist > level.min_panzerschreck_eng_distsq ) 
			{
				self setEntityTarget( best_target );
			}
			else
			{
				self clearEntityTarget();
			}
		}
		wait( 0.05 );
	}
}

//////////////////////////////////
// MISS STRUCT TARGETING
//////////////////////////////////

/////////////////////////////////
// FUNCTION: remove_old_targeters
// CALLED ON: an entity with miss structs 
// PURPOSE: This removes entity A from the list of entities targeting the miss struct entity B
//          allowing another entity to request entity B as a target
// ADDITIONS NEEDED: None
/////////////////////////////////
remove_old_targeters()
{
	self endon( "death" );
	while( 1 )
	{
		self waittill( "stopped targeting", ent );
		for( i = 0; i < self.current_targeters.size; i++ )
		{
			if( self.current_targeters[i] == ent ) 
			{
				self.current_targeters = array_remove( self.current_targeters, ent );
			}
		}
		
		for( i = 0; i < self.queued_targeters.size; i++ )
		{
			if( self.queued_targeters[i] == ent )
			{
				self.queued_targeters = array_remove( self.queued_targeters, ent );
			}
		}
	}
}

/////////////////////////////////
// FUNCTION: update_current_targeters
// CALLED ON: an entity
// PURPOSE: This creates an array of x miss structs and gives the closest targeters a direct target
//          of the miss_struct entity on a frame by frame basis, otherwise tells them to target
//          the miss structs
// ADDITIONS NEEDED: None
/////////////////////////////////
update_current_targeters()
{
	self endon( "death" );
	self endon( "disconnect" );
	self thread remove_old_targeters();
	if( !isDefined( self.current_targeters ) )
	{
		self.current_targeters = [];
	}
	if( !isDefined( self.queued_targeters ) )
	{
		self.queued_targeters = [];
	}
	if( !isDefined( self.miss_structs ) )
	{
		self.miss_structs = [];
	}
	
	x_sign = 1;
	y_sign = 1;
	
	for( i = 0; i < level.number_miss_structs; i++ )
	{
		x = randomfloat( 0-level.max_miss_distance, level.max_miss_distance );
		y = randomfloat( 0-level.max_miss_distance, level.max_miss_distance );
		if( x < level.min_miss_distance && x > 0 )
		{
			x = level.min_miss_distance;
		}
		else if( x > 0-level.min_miss_distance )
		{
			x = 0-level.min_miss_distance;
		}
		
		if( y < level.min_miss_distance && x > 0 )
		{
			y = level.min_miss_distance;
		}
		else if( y > 0-level.min_miss_distance )
		{
			y = 0-level.min_miss_distance;
		}
		miss_struct = spawn( "script_origin", (0,0,0) );
		miss_struct.origin = (self.origin[0]+x, self.origin[1]+y, self.origin[2]);
		miss_struct.origin = groundpos( miss_struct.origin );
		self.miss_structs = array_add( self.miss_structs, miss_struct );
		miss_struct linkto( self );
	}
	
	while( 1 ) 
	{
		best_dist = 10000000000;
		best_index = -1;
		for( i = 0; i < level.see2_max_targeters; i++ )
		{
			if( !isDefined( self.current_targeters[i] ) )
			{
				for( j = 0; j < self.queued_targeters.size; j++ )
				{
					if( isDefined( self.queued_targeters[j] ) )
					{
						dist = distanceSquared( self.origin, self.queued_targeters[i].origin );
						if( dist < best_dist )
						{
							best_index = j;
							best_dist = dist;
						}
					}
				}
				if( best_index > 0 )
				{
					self.queued_targeters[best_index] notify( "switch targets", self );
					self.current_targeters[i] = self.queued_targeters[best_index];
					self.queued_targeters = array_remove( self.queued_targeters, self.queued_targeters[best_index] );
				}
			}
		}
		wait( 0.5 );
	}
}

/////////////////////////////////
// FUNCTION: request_target
// CALLED ON: an entity
// PURPOSE: This allows an entity to request the target of a miss struct entity and receive
//          a miss struct if there are already too many entities targeting that entity.
// ADDITIONS NEEDED: None
/////////////////////////////////
request_target( target )
{
	if( !isDefined( target ) || !isDefined( target.miss_structs ) )
	{
		return target;
	}
	
	targeted = undefined;
	for( i = 0; i < level.see2_max_targeters; i++ )
	{
		if( !isDefined( target.current_targeters[i] ) || target.current_targeters[i] == self )
		{
			target.current_targeters[i] = self;
			targeted = target;
			break;
		}
	}
	
	if( !isDefined( targeted ) ) 
	{
		rand = randomint( level.number_miss_structs );
		targeted = target.miss_structs[rand];
		if( array_check_for_dupes( target.queued_targeters, self ) )
		{
			target.queued_targeters = array_add( target.queued_targeters, self );
		}
	}
	
	return targeted;
}




/////////////////////////////
// EVENT 1
/////////////////////////////

/////////////////////////////////
// FUNCTION: field_begin
// CALLED ON: level
// PURPOSE: This sets up all the variables for a start in area 1 where you destroy the artillery
// ADDITIONS NEEDED: None
/////////////////////////////////
field_begin()
{
	thread setup_stuck_event();
	
	thread setup_early_tanks();
	
	wait_for_first_player();
	wait( 4 );
	
	
	players = get_players();
	//4x4 Achievement script
	for(i=0; i < players.size; i++)
	{
		players[i].squishcount = 0; 
	}
	//-- Switch out the other players weapons
	for(i = 1; i < players.size; i++)
	{
		players[i] TakeWeapon("m2_flamethrower");
		players[i] SwitchToWeapon( "ppsh" );
	}
	
	setup_player_tanks();
	
	thread keep_track_of_achievement();
	
	thread do_sound_for_event( "battlechatter" );
	
	do_area_spawn( 0 );
	wait_network_frame();
	do_arty_spawn( 0 );
	
	arty_flaps = getEntArray( "arty tarp", "targetname" );
	for( i = 0; i < arty_flaps.size; i++ )
	{
		arty_flaps[i] thread do_tarp_flap();
		arty_flaps[i] thread cleanup_tarp();
	}
	
	level waittill( "controls_active" );
	
	level clientNotify("aaa_begin");	
	level notify("aaa_begin");
	level clientNotify("start_distance_planes_field_1");
	level notify("start_distance_planes_field_1");
	level thread field_begin_planes_end();
	
	level thread arcademode_water_tower_setup();
	
	
	arty_array = getEntArray( "group1 arty", "script_noteworthy" );
	assert( arty_array.size > 1 );
	objective_add(1, "current" );

	for( i = 0; i < arty_array.size; i++ )
	{
		arty_array[i].health = 1;
		arty_array[i] thread arty_behavior();
		objective_additionalPosition( 1, i, arty_array[i].origin ); 
	}
	
	level.active_arty = arty_array.size;
	level.max_active_arty = arty_array.size;
	objective_string( 1, &"SEE2_DESTROY_ARTILLERY", level.active_arty );
	
	third_tier = GetEntArray( "third tier", "targetname" );
	third_tier = array_merge( third_tier, GetEntArray( "third tier two", "targetname" ) );
	third_tier = array_merge( third_tier, GetEntArray( "third tier three", "targetname" ) );
	
	for( i = 0; i < third_tier.size; i++ )
	{
		third_tier[i].script_forcespawn = 1;
	}
	
	for( i = 0; i < arty_array.size; i++ )
	{
		arty_array[i] thread wait_for_neutralize(i);
	}
	
	level thread wait_for_third_wave();
	level thread wait_for_area_two_infantry();
	level thread wait_for_area_three_infantry();
	level thread wait_for_area_four_infantry();
	level thread setup_airstrike_triggers();
	
	//level thread move_radio_tower_blocker( false );
	
	level thread do_retreat_trucks();
	level thread do_stop_wait_triggers();
	
	thread do_bunker_group( "first bunker", "fourth bunker", "first bunker taken" );
	thread do_bunker_group( "second bunker", "fourth bunker", "second bunker taken", "second tier" );
	thread do_bunker_group( "third bunker", "fifth bunker", "third bunker taken", "third tier" );
	thread do_bunker_group( "fourth bunker", "third bunker", "fourth bunker taken", "second tier" );
	thread do_bunker_group( "fifth bunker", "third bunker", "fifth bunker taken" );
	
	thread wait_for_group_spawn( 1 );
	thread wait_for_group_spawn( 2 );
	thread wait_for_group_spawn( 3 );
	thread keep_grenade_bags_from_spawning();
	thread do_fake_schrecks();
	
	//TUEY Set Music State to INTRO
	setmusicstate("INTRO");
	setbusstate("TANKS");

	
	build_retreat_generics();
}

arcademode_water_tower_setup()
{
	water_tower_trigs = [];
	water_tower_trigs = GetEntArray("water_tower_trig", "targetname");
	
	for(i = 0; i < water_tower_trigs.size; i++)
	{
		water_tower_trigs[i] thread arcademode_water_tower_give_points();
	}
}

arcademode_water_tower_give_points()
{
	self waittill( "trigger", ent );
	
	if( IsPlayer( ent ) )
	{
		arcademode_assignpoints( "arcademode_score_banzai", ent );
	}
}

move_radio_tower_blocker( proper_position )
{
	radio_tower_blocker = GetEnt("radio_tower_blocker", "targetname");
	if(!proper_position)
	{
		radio_tower_blocker.origin = radio_tower_blocker.origin - (0,0,5000);
	}
	else
	{
		radio_tower_blocker.origin = radio_tower_blocker.origin + (0,0,5000);
	}
}

field_begin_planes_end()
{
	trig = GetEnt("stop field planes", "targetname");
	trig waittill("trigger");
	
	level clientNotify("start_distance_planes_field_1_stop");
	level notify("start_distance_planes_field_1_stop");
}

/////////////////////////////////
// FUNCTION: do_stop_wait_triggers
// CALLED ON: level
// PURPOSE: This sets up all the subsequent retreat triggers for the opel trucks in the level
// ADDITIONS NEEDED:
/////////////////////////////////
do_stop_wait_triggers()
{
	triggers = getEntArray( "stop wait trigger", "targetname" );
	for( i = 0; i < triggers.size; i++ )
	{
		triggers[i] thread wait_for_stop_wait();
	}
}

/////////////////////////////////
// FUNCTION: wait_for_stop_wait
// CALLED ON: a retreater truck
// PURPOSE: This waits until a stop wait trigger is hit and the trucks continue their retreat.
// ADDITIONS NEEDED:
/////////////////////////////////
wait_for_stop_wait()
{
	while( 1 )
	{
		self waittill( "trigger", guy );
		if( isPlayer( guy ) )
		{
			break;
		}
	}
	if( array_check_for_dupes( level.invalid_retreat_points, self.script_noteworthy ) )
	{
		level.invalid_retreat_points = array_add( level.invalid_retreat_points, self.script_noteworthy );
	}
}

/////////////////////////////////
// FUNCTION: wait_for_third_wave
// CALLED ON: level
// PURPOSE: This waits until the player has proceeded sufficiently then tries to spawn
//          the third tier of bunker guards in the artillery area
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_third_wave()
{
	spawners = getEntArray( "third tier", "targetname" );
	
	level waittill_either( "second bunker taken", "fourth bunker taken" );
	spawn_guys( spawners, undefined, true );
}

/////////////////////////////////
// FUNCTION: wait_for_neutralize
// CALLED ON: a flak 88
// PURPOSE: This waits until an artillery is destroyed or has had its crew killed. It then 
//          updates the "Destroy artillery" objective
// ADDITIONS NEEDED:
//
//
//
//
//////////////////////////////////
wait_for_neutralize( objNum )
{
	self waittill_either( "death", "crew dead" );
	level.active_arty--;
	if( level.active_arty == 0 )
	{
		Objective_AdditionalPosition( 1, objNum, ( 0, 0, 0 ) );
		Objective_String_NoMessage( 1, &"SEE2_DESTROY_ARTILLERY", level.active_arty );
		flag_set( "flak objective completed" );
		Objective_State( 1, "done" );
		autosave_by_name( "first area arty destroyed" );
		level notify( "begin event 2" );
		wait( 5 );
		thread do_sound_for_event( "radio_tower_dialog" );
	}
	else
	{
		Objective_AdditionalPosition( 1, objNum, ( 0, 0, 0 ) );
		Objective_String( 1, &"SEE2_DESTROY_ARTILLERY", level.active_arty );
		if(level.active_arty == 2)
		{
			autosave_by_name( "first area arty destroyed"+ level.active_arty );
		}
	}
}

/////////////////////////////////
// FUNCTION: do_death_tank_sequence
// CALLED ON: the death tank from ::setup_stuck_event
// PURPOSE: This does the intial tank in front of the player rolling out and getting pwned by
//          the panzershreck group near the first artillery
// ADDITIONS NEEDED: The panzershreck guys are currently starting to target the player instead
//                   of the death tank, this should be investigated and fixed.
/////////////////////////////////
do_death_tank_sequence( target_node, death_node )
{
	self setWaitNode( target_node );
	
	self waittill( "reached_wait_node" );
	
	has_target = false;
	
	stuck_infantry = [];
	while( stuck_infantry.size < 1 )
	{
		stuck_infantry = get_living_ai_array( "stuck infantry", "script_noteworthy" );
		wait( 0.05 ); 
	}
	
	for( i = 0; i < stuck_infantry.size; i++ )
	{
		if( isDefined( stuck_infantry[i] ) )
		{
			if( !has_target ) 
			{
				has_target = true;
				self setTurretTargetEnt( stuck_infantry[i] );
			}
			stuck_infantry[i].ignoreall = false;
			stuck_infantry[i] setEntityTarget( self );
		}
	}

	wait( 0.05 );
	
	self setWaitNode( death_node );
	wait( 0.05 );
	self waittill( "reached_wait_node" );
	
	//self thread stop_keep_tank_alive();
	
	self.health = 1;
	
	self waittill( "death" );
	flag_set( "death tank dead" );
}

/////////////////////////////////
// FUNCTION: setup_stuck_event
// CALLED ON: level
// PURPOSE: This does all the setup for the do_death_tank_event event
// ADDITIONS NEEDED: None
/////////////////////////////////
setup_stuck_event()
{
	flag_init( "death tank dead" );
	
	stuck_infantry = GetEntArray( "stuck infantry", "script_noteworthy" );
	
	/*
	for( i = 0; i < stuck_infantry.size; i++ )
	{
		stuck_infantry[i].ignoreall = true;
	}
	*/
	
	level waittill( "controls_active" );
	
	stuck_tanknode = GetEnt( "stuck tank node", "script_noteworthy" );
	stuck_flee_nodes = GetNodeArray( "stuck flee node", "script_noteworthy" );
	stuck_flee_panzer_nodes = GetNodeArray( "stuck panzer flee node", "script_noteworthy" );
	stuck_trigger = GetEnt( "stuck trigger", "script_noteworthy" );
	stuck_ammo_boxes = GetEntArray( "stuck ammo crate", "script_noteworthy" );
	stuck_damage_trigger = GetEnt( "stuck damage trigger", "script_noteworthy" );
	death_tank_move_trigger = getEnt( "death tank move_trigger", "script_noteworthy" );
	death_tank_spawn_trigger = getEnt( "death tank spawn_trigger", "script_noteworthy" );
	target_node = getVehicleNode( "start targeting", "script_noteworthy" );
	death_node = getVehicleNode( "death node", "script_noteworthy" );
	
	/*
	for( i = 0; i < stuck_infantry.size; i++ )
	{
		stuck_infantry[i].goalradius = 32;
		stuck_infantry[i] setGoalNode( GetNode( stuck_infantry[i].target, "targetname" ) );
		stuck_infantry[i].ignoreall = true;
		stuck_infantry[i] thread setup_bunker_infantry();
	}
	*/
	
	array_thread( stuck_infantry, ::add_spawn_function, ::setup_stuck_infantry );
	
	death_tank_spawn_trigger notify( "trigger" );
	wait( 0.05 );		
	death_tank = getEnt( "death tank", "script_noteworthy" );	
	
	//death_tank thread keep_tank_alive();
	
	death_tank_move_trigger notify( "trigger" );
	
	death_tank thread do_death_tank_sequence( target_node, death_node );
		
	stuck_trigger waittill( "trigger" );
	
	while( !flag( "death tank dead" ) )
	{
		wait( 0.05 );
		continue;
	}
	
	//do_sound_for_event( "tank_move_fire_tutorial" );
	
	wait( 2 );
	
	stuck_infantry = get_living_ai_array( "stuck infantry", "script_noteworthy" );
	
	for( i = 0; i < stuck_infantry.size; i++ )
	{
		if( isDefined( stuck_infantry[i] ) )
		{
			stuck_infantry[i] ClearEntityTarget();
		  stuck_infantry[i] thread setup_bunker_infantry();
			stuck_infantry[i].goalradius = 32;
			if( stuck_infantry[i].classname == "actor_axis_ger_ber_wehr_reg_panzerschrek" )
			{
				stuck_infantry[i].maxsightdistsqrd = 3000*3000;
				stuck_infantry[i] setGoalNode( stuck_flee_panzer_nodes[i] );
			}
			else
			{
				stuck_infantry[i] setGoalNode( stuck_flee_nodes[i] );
				stuck_infantry[i].script_noteworthy = "first bunker guard";
			}
			wait( randomfloatrange( 0.25, 0.5 ) );
		}
	}
	
	stuck_damage_trigger thread inform_on_damage_trigger( "blow up ammo boxes" );
	
	level waittill( "blow up ammo boxes" );
	
	for( i = 0; i < stuck_ammo_boxes.size; i++ )
	{
		playfx( level._effect["dummy_tank_explode"], stuck_ammo_boxes[i].origin );
		radiusDamage( stuck_ammo_boxes[i].origin, 1000, 500, 500 );
		stuck_ammo_boxes[i] delete();
		wait( randomintrange( 1, 5 ) );
	}
}

/////////////////////////////////
// FUNCTION: setup_stuck_infantry
// CALLED ON: a member of the death tank infantry
// PURPOSE: Sets up some basic variables for this entity
// ADDITIONS NEEDED: None
/////////////////////////////////
setup_stuck_infantry()
{
	self.goalradius = 32;
	self.ignoreall = true;
}

/////////////////////////////////
// FUNCTION: setup_field_ambushes
// CALLED ON: level
// PURPOSE: sets up guys in fields with panzerschrecks
// ADDITIONS NEEDED: None
/////////////////////////////////
setup_field_ambushes()
{
	for( i = 1;; i++ )
	{
		trigger = GetEnt( "field "+i+" ambush trigger" );
		if( isDefined( trigger ) )
		{
			level thread setup_single_ambush( i, trigger );
		}
		else
		{
			break;
		}
	}
}

/////////////////////////////////
// FUNCTION: setup_single_ambush
// CALLED ON: ambush trigger
// PURPOSE: sets up a single field ambush
// ADDITIONS NEEDED: None
/////////////////////////////////
setup_single_ambush( field, trigger ) 
{
	guys = GetEntArray( "field "+field+" ambush", "script_noteworthy" );
	for( i = 0; i < guys.size; i++ )
	{
		guys.ignoreall = true;
		guys.ignoreme = true;
		guys allowedstances( "prone" );
		guys.a.no_switch_weapon = true;
	}
	trigger inform_on_touch_trigger( trigger.script_noteworthy );
	level waittill( trigger.script_noteworthy );
	for( i = 0; i < guys.size; i++ )
	{
		guys.ignoreall = false;
		guys.ignoreme = false;
		guys allowedstances( "stand", "crouch", "prone" );
	}
}

/////////////////////////////////
// FUNCTION: find_farthest_retreat_point
// CALLED ON: Bunker guards whose positions have been overrun
// PURPOSE: This finds the farthest retreat point from an enemy and heads towards it
// ADDITIONS NEEDED: Try and make this take into account the player[0] tank
/////////////////////////////////
find_farthest_retreat_point( enemy )
{
	best_dist = 0;
	ref_pt = -1;
	
	for( i = 0; i < level.retreat_reference_points.size; i++ )
	{
		dist = distanceSquared( level.retreat_reference_points[i].origin, enemy.origin );
		if( dist > best_dist )
		{
			//-- check to see if its in the direction of the players tank
			tank_dir = level.retreat_reference_points[i].origin - enemy.origin;
			retreat_dir = enemy.origin - self.origin;
			
			if( VectorDot(  VectorNormalize( tank_dir ), VectorNormalize( retreat_dir ))  > 0 )
			{
				continue;
			}
			
			best_dist = dist;
			ref_pt = i;
		}
	}
	if( ref_pt < 0 )
	{
		return undefined;
	}
	
	node = level.retreat_nodes[ref_pt][randomint(level.retreat_nodes[ref_pt].size)];
	return node;
}

/////////////////////////////////
// FUNCTION: build_retreat_generics
// CALLED ON: level
// PURPOSE: Sets up retreat points that will be used by infantry who have been flushed out
// ADDITIONS NEEDED: None
/////////////////////////////////
build_retreat_generics()
{
	level.retreat_reference_points = [];
	level.retreat_nodes = [];
	
	for( i = 0;; i++ )
	{
		ref = getNode( "retreat "+i, "targetname" );
		if( !isDefined( ref ) )
		{
			break;
		}
		level.retreat_reference_points = array_add( level.retreat_reference_points, ref );
		level.retreat_nodes = array_add( level.retreat_nodes, GetNodeArray( "retreat "+i, "script_noteworthy" ) );
	}
}

/////////////////////////////////
// FUNCTION: setup_bunker_infantry
// CALLED ON: an infantryman
// PURPOSE: Sets up basic AI behavior for german AI
// ADDITIONS NEEDED: None
/////////////////////////////////
setup_bunker_infantry()
{
	level.enemy_infantry = array_add( level.enemy_infantry, self );
	self thread enforce_flame_deaths();
	if( self.classname == "actor_axis_ger_ber_wehr_reg_panzerschrek" )
	{
		self thread do_antitank_AI(); 
		//self thread unlimited_rocket_ammo();
		self setThreatBiasGroup( "enemy antitank" );
		self set_ent_see2_bias_group( "enemy antitank" );
		self.a.rockets = 200;
		self.maxsightdistsqrd = 3000*3000;
		self.a.no_weapon_switch = true;
	}
	else
	{
		self setThreatBiasGroup( "enemy infantry" );
		self set_ent_see2_bias_group( "enemy infantry" );
	}
}

unlimited_rocket_ammo()
{
	self endon("death");
	
	while(1)
	{
		if( self.bulletsInClip < weaponClipSize( self.weapon ) )
		{
			self.bulletsInClip = weaponClipSize( self.weapon );
		}
		wait(0.5);
	}
}

/////////////////////////////////
// FUNCTION: do_generic_retreats
// CALLED ON: a flushed out infantryman
// PURPOSE: This makes them flee based on player proximity and seek the farthest retreat point 
//          they can find
// ADDITIONS NEEDED: Need to make this so they go to their retreat node and then just chill in the wheat.
/////////////////////////////////
do_generic_retreats()
{
	self endon( "death" );
	
	while( IsDefined(self.scripted_grenade_throw) )
	{
		wait(0.05);
	}
	
	while( 1 )
	{
		for( i = 0; i < get_players().size; i++ )
		{
			if( distanceSquared( self.origin, get_players()[i].origin ) < 1000 * 1000 )
			{
				node = self find_farthest_retreat_point( get_players()[i] );
				self.goal_radius = 64;
				self setGoalNode( node );
				level notify("ai_set_new_retreat_node");
				
				self waittill("goal");
				self.ignoreme = false;
				self.ignoreall = false;
				self AllowedStances( "crouch", "prone" );
				return;
			}
		}
		wait( 0.2 );
	}
}

/////////////////////////////////
// FUNCTION: do_retreat_trucks
// CALLED ON: level
// PURPOSE:  sets up all retreat truck behavior
// ADDITIONS NEEDED: None
/////////////////////////////////
do_retreat_trucks()
{
	trucks = getEntArray( "retreat truck", "targetname" );
	for( i = 0; i < trucks.size; i++ )
	{
		trucks[i] thread retreat_truck_behavior();
		vehicle_node = GetVehicleNode( trucks[i].target, "targetname" );
		if(IsDefined( vehicle_node ))
		{
			trucks[i] thread maps\_vehicle::vehicle_paths(vehicle_node);
		}
		wait( 2 );
	}
}

////////////////////////////////////
// EVENT 2
////////////////////////////////////

/////////////////////////////////
// FUNCTION: radio_tower_begin
// CALLED ON: level
// PURPOSE: Sets up all level variables for starting at the radio tower objective
// ADDITIONS NEEDED: Needs to identify warp points for the player and warp them to an appropriate
//                   distance
/////////////////////////////////
radio_tower_begin()
{
	flag_set( "flak 88s destroyed" );
	
	thread do_sound_for_event( "battlechatter" );

	level thread setup_early_tanks();
	wait_for_first_player();
	wait( 4 );
	level thread setup_player_tanks();
	
	wait( 1 );
	new_starts = [];
	for( i = 0; i < level.player_tanks.size; i++ )
	{
		start_pt = getStruct( "radio_tower start "+i, "targetname" );
		if( isDefined( start_pt.target ) )
		{
			warp_pt = getStruct( start_pt.target, "targetname" );
		}
		else
		{
			warp_pt = start_pt;
		}
		if( isDefined( start_pt.script_noteworthy ) )
		{
			level.current_advance_level = start_pt.script_noteworthy;
		}
		level.player_tanks[i].origin = warp_pt.origin;
		if( isDefined( level.player_tanks[i].current_node ) )
		{
			level.player_tanks[i].current_node = warp_pt;
		}
		if( isDefined( level.player_tanks[i].target_node ) )
		{
			level.player_tanks[i].target_node = warp_pt;
		}
	}
	
	do_area_spawn( 1 );
	wait_network_frame();
	spawn_area_two_infantry();
	
	level thread wait_for_group_spawn( 2 );
	level thread wait_for_group_spawn( 3 );
	
	//level thread wait_for_area_three_infantry();
	//level thread wait_for_area_four_infantry();
	level thread setup_airstrike_triggers();
}

/////////////////////////////////
// FUNCTION: wait_for_area_two_infantry
// CALLED ON: level
// PURPOSE: Waits until the area two spawn trigger has been hit then spawns all radio tower 
//          infantry
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_area_two_infantry()
{
	trigger = GetEnt( "group 1 spawn", "script_noteworthy" );
	trigger waittill( "trigger" );
	
	if( flag( "radio tower destroyed" ) )
	{
		return;
	}
	
	spawn_area_two_infantry();
}

/////////////////////////////////
// FUNCTION: spawn_area_two_infantry
// CALLED ON: level
// PURPOSE: spawns all radio tower infantry and sets up their spawn functions
// ADDITIONS NEEDED: None
/////////////////////////////////
spawn_area_two_infantry()
{
	spawner_array = GetEntArray( "radio tower spawner", "script_noteworthy" );
	array_thread( spawner_array, ::add_spawn_function, ::setup_radio_tower_infantry );
	array_thread( spawner_array, ::add_spawn_function, ::radio_tower_infantry_evasion );
	array_thread( spawner_array, ::add_spawn_function, ::radio_tower_infantry_grenades );
	
	spawner_array_2 = GetEntArray( "radio tower bunker spawner", "script_noteworthy" );
	array_thread( spawner_array, ::add_spawn_function, ::setup_radio_tower_infantry );
	
	
	flood_spawner_array = GetEntArray( "radio tower floodspawners", "script_noteworthy" );
	array_thread( flood_spawner_array, ::add_spawn_function, ::radio_tower_infantry_grenades );
	
	spawn_guys( spawner_array, undefined, true );
	spawn_guys( spawner_array_2, undefined, true );

	do_floodspawners( "radio tower", 1 );
}

/////////////////////////////////
// FUNCTION: add_radio_tower_objective
// CALLED ON:  level
// PURPOSE:  This creates a series of breadcrumb target points that will be used to navigate
//           the player to the radio tower and then updates the objective once the radio tower
//           has been destroyed
// ADDITIONS NEEDED: None
//
//
// Glocke: Changed this so that the objective starts when the player hits a trigger where he can see the radio tower.
//
/////////////////////////////////
add_radio_tower_objective( radiotower )
{
	level endon ( "radio tower start alternate" );
	
	level waittill( "begin event 2" );
	level notify( "radio tower start normal" );
	
	proceed_trigger = GetEnt( "radio tower proceed trigger", "targetname" );
	next_proceed_trigger = GetEnt( "radio tower next proceed trigger", "targetname" );

	thread do_radio_tower_owned_event();
	
	objective_add(2, "current" );
	Objective_String( 2, &"SEE2_PROCEED_RADIOTOWER" );

	Objective_additionalPosition( 2, 0, proceed_trigger.origin );
	
	proceed_trigger waittill( "trigger" );
	Objective_additionalPosition( 2, 0, next_proceed_trigger.origin );
	
	next_proceed_trigger waittill( "trigger" );
	
	Objective_String( 2, &"SEE2_DESTROY_RADIOTOWER" );
	
	objective_additionalPosition( 2, 0, radiotower.origin ); 
	
	while( 1 )
	{
		if( radiotower.model == "anim_seelow_radiotower_d" )
		{
			flag_set( "radio tower objective completed" );
			Objective_State( 2, "done" );
			break;
		}
		wait( 0.05 );
	}
}

add_radio_tower_objective_alternate( radiotower )
{
	level endon( "radio tower start normal");
	
	objective_start_tower = GetEnt( "radio tower next proceed trigger", "targetname" );
	objective_start_tower waittill( "trigger" );
	
	level notify( "radio tower start alternate" );

	proceed_trigger = GetEnt( "radio tower proceed trigger", "targetname" );
	next_proceed_trigger = GetEnt( "radio tower next proceed trigger", "targetname" );

	thread do_radio_tower_owned_event();
	
	objective_add(2, "current" );
	Objective_String( 2, &"SEE2_DESTROY_RADIOTOWER" );
	objective_additionalPosition( 2, 0, radiotower.origin ); 
	
	while( 1 )
	{
		if( radiotower.model == "anim_seelow_radiotower_d" )
		{
			flag_set( "radio tower objective completed" );
			Objective_State( 2, "done" );
			break;
		}
		wait( 0.05 );
	}
	
}

/////////////////////////////////
// FUNCTION: do_radio_tower_owned_event
// CALLED ON: level
// PURPOSE: Causes a T34 to pull up at the bottleneck leading to the radio tower, engage in a 
//          firefight with a panther, then get owned
// ADDITIONS NEEDED: This can be triggered after the vehicles have already been set to move
//                   It needs to accommodate this either by restructuring the move trigger setup
//                   in radiant or through a multi-trigger system that checks for the flak 88s
//                   being destroyed before starting their move
/////////////////////////////////
do_radio_tower_owned_event()
{
	vig_trigger = getEnt( "radio tower vig trigger", "script_noteworthy" );
	
	vig_trigger waittill( "trigger" );
	
	enemy_tank = undefined;
	while(!IsDefined(enemy_tank))
	{
		enemy_tank = getEnt( "radio tower vig tank", "script_noteworthy" );
		wait(0.05);
	}
	
	friendly_tank = undefined;
	while(!IsDefined(friendly_tank))
	{
		friendly_tank = getEnt( "radio tower owned tank", "script_noteworthy" );
		wait(0.05);
	}
		
	enemy_tank setTurretTargetEnt( friendly_tank );
	friendly_tank setTurretTargetEnt( enemy_tank );
	
	//enemy_tank thread keep_tank_alive();
	//friendly_tank thread keep_tank_alive();
	
	enemy_tank thread dummy_fire_behavior();
	friendly_tank thread dummy_fire_behavior();
	
	friendly_tank thread friendly_tank_wait_for_enemy_tank_to_die( enemy_tank );
	enemy_tank thread enemy_tank_wait_for_friendly_tank_to_die( friendly_tank );
	/*
	friendly_tank setWaitNode( getVehicleNode( "radio tower owned node", "script_noteworthy" ) );
	
	friendly_tank waittill( "reached_wait_node" );
	
	friendly_tank.health = 1;
	friendly_tank stop_keep_tank_alive();
	wait( 0.05 );
	enemy_tank stop_keep_tank_alive();
	
	friendly_tank waittill( "death" );
	
	enemy_tank.health = 1;
	
	friendly_tank notify( "stop dummy firing" );
	enemy_tank notify( "stop dummy firing" );
	
	enemy_tank thread moving_firing_behavior();
	*/
}

friendly_tank_wait_for_enemy_tank_to_die( enemy_tank )
{
	self endon("death");
	
	self thread friendly_tank_wait_for_enemy_tank_die_then_move( enemy_tank );
	
	enemy_tank waittill("death");
	
	self.enemy_tank_dead = true;
	self notify( "stop dummy firing" );
	self notify( "stop_burst_fire_unmanned" );
	self notify( "stop_using_built_in_burst_fire" ); 
}

friendly_tank_wait_for_enemy_tank_die_then_move( enemy_tank )
{
	self endon("death");
	self waittill("pink_tank_wait_here");
	self SetSpeed(0, 5, 5);
	
	//enemy_tank waittill("death");
	while(!IsDefined(self.enemy_tank_dead))
	{
		wait(0.05);
	}
	
	self ResumeSpeed(5);
	self waittill("pink_tank_blow_up");
	RadiusDamage( self.origin, 200, 10000, 9999 );
}

enemy_tank_wait_for_friendly_tank_to_die( friendly_tank )
{
	self endon("death");
	friendly_tank waittill("death");
	
	self notify( "stop dummy firing" );
	self thread moving_firing_behavior();
}


/////////////////////////////////
// FUNCTION: dummy_fire_behavior
// CALLED ON: a vehicle
// PURPOSE: Used to have the vignette vehicles from ::do_radio_tower_owned_event fire at each
//          other
// ADDITIONS NEEDED: None
/////////////////////////////////
dummy_fire_behavior()
{
	self endon( "stop dummy firing" );
	self endon( "death" );
	
	while( 1 )
	{
		wait( randomintrange( 2,5 ) );
		self fireweapon();
	}
}

/////////////////////////////////
// FUNCTION: do_radio_tower_explode
// CALLED ON: level
// PURPOSE: Plays the fx for the radio tower explosion and animates it falling over
// ADDITIONS NEEDED: need to update the fx, either through script or fx editor to have a dust
//                   cloud play at the right time when the radio tower falls. Also, adding
//                   dead crushed nazis in the bunker the tower falls on would be sweet.
/////////////////////////////////
#using_animtree( "see2_models" );
do_radio_tower_explode()
{
	
	radiotower = getEnt( "radio tower", "script_noteworthy" );
	flag_init( radiotower.script_noteworthy+" destroyed" );
	thread check_for_tower_damage( radiotower, 1500 );
	level thread add_radio_tower_objective( radiotower );
	level thread add_radio_tower_objective_alternate( radiotower );
	
	level flag_wait( radiotower.script_noteworthy+" destroyed" );
	
	playfx( level._effect["tower_explode"], radiotower.origin );
	radiotower setModel( "anim_seelow_radiotower_d" );
	radiotower.animname = "radiotower";
	radiotower SetAnimTree();
	
	wait( 4 );
	
	radiotower anim_single_solo( radiotower, "fall" );
	playfx( level._effect["tower_secondary_explosion"], radiotower.origin );
	//level thread move_radio_tower_blocker( true );
	
	autosave_by_name( "radio tower destroyed" );
	
	level thread fuel_depot_objectives();
}

/////////////////////////////////
// FUNCTION: check_for_tower_damage
// CALLED ON: level
// PURPOSE: keeps track of how much damage has been done to the tower
// ADDITIONS NEEDED: None
/////////////////////////////////
check_for_tower_damage( tower, amt )
{
	count = 0;
	damage_trigger = GetEnt( tower.script_noteworthy+" damage trigger", "script_noteworthy" );
	while( 1 ) 
	{
		damage_trigger waittill( "damage", damage, other, direction, origin, damage_type );
		if( array_check_for_dupes( get_players(), other ) || !explosive_damage( damage_type ) )
		{
			continue;
		}
		count += damage;
		if( count >= amt )
		{
			flag_set( tower.script_noteworthy+" destroyed" );
			return;
		}
		wait( 0.05 );
	}
}

/////////////////////////////////
// FUNCTION: setup_radio_tower_infantry
// CALLED ON: level
// PURPOSE: sets up basic AI values for radio tower infantry behavior
// ADDITIONS NEEDED: None
/////////////////////////////////
setup_radio_tower_infantry()
{
	self endon( "death" );
	
	level.enemy_infantry = array_add( level.enemy_infantry, self );
	self thread enforce_flame_deaths();
	if( self.classname == "actor_axis_ger_ber_wehr_reg_panzerschrek" )
	{
		self setThreatBiasGroup( "enemy antitank" );
		self thread do_antitank_AI(); 
		self set_ent_see2_bias_group( "enemy antitank" );
		self.a.rockets = 200;
		self.maxsightdistsqrd = 3000*3000;
		self.a.no_weapon_switch = true;
		self.goalradius = 128;
	}
	else
	{
		self setThreatBiasGroup( "enemy infantry" );
		self set_ent_see2_bias_group( "enemy infantry" );
		self.goalradius = 128;
	}
}

////////////////////////////////////////////////
// EVENT 3
////////////////////////////////////////////////

/////////////////////////////////
// FUNCTION: fuel_depot_begin
// CALLED ON: level
// PURPOSE: This sets up all the variables to start at the "Rejoin the Main Russian Army event" of
//          see2
// ADDITIONS NEEDED: Need to add a warp position and warp the player and tank to this position
/////////////////////////////////
fuel_depot_begin()
{
	flag_set( "flak 88s destroyed" );
	flag_set( "radio tower destroyed" );
	
	thread do_sound_for_event( "battlechatter" );
	
	level thread setup_early_tanks();
	wait_for_first_player();
	wait( 4 );
	level thread setup_player_tanks();
	
	do_area_spawn( 2 );
	wait_network_frame();
	
	spawn_area_three_infantry();

	level thread wait_for_group_spawn( 3 );
	
	level thread wait_for_area_four_infantry();
	level thread setup_airstrike_triggers();
}

/////////////////////////////////
// FUNCTION: fuel_depot_objectives
// CALLED ON: level
// PURPOSE: Creates an objective star where the airstrike will be triggered and cleans up once
//          the trigger has been hit.
// ADDITIONS NEEDED: None
////////////////////////////////
fuel_depot_objectives()
{
	if( flag( "final battle already started" ) )
	{
		return;
	}
	
	start_trigger = getEnt( "finalbattle_trigger", "script_noteworthy" );
	
	objective_add(3, "current" );
	Objective_String( 3, &"SEE2_REJOIN_ARMY" );
	Objective_additionalPosition( 3, 0, start_trigger.origin );
	
	//start_trigger = getEnt( "finalbattle_trigger", "script_noteworthy" );
	while( 1 )
	{
		start_trigger waittill( "trigger", guy );
		if( isPlayer( guy ) )
		{
			break;
		}
	} 
	
	autosave_by_name( "fuel supplies destroyed" );
	
	level thread wait_for_finalbattle();
}

/////////////////////////////////
// FUNCTION: wait_for_finalbattle_alternate()
// CALLED ON: level
// PURPOSE: If the player bypasses all of the objectives and ends up at the ridge, then he gets put on the last objective
// 
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_finalbattle_alternate()
{
	start_trigger = GetEnt( "finalbattle_trigger", "script_noteworthy" );
	start_trigger waittill( "trigger" );
	
	wait(0.2);
	
	if( !flag( "final battle already started" ) )
	{
		level thread wait_for_finalbattle( true );
	}
}


/////////////////////////////////
// FUNCTION: do_tiger_retreats
// CALLED ON: level
// PURPOSE: Gets two tigers on the hill to retreat down the hill, leading the player to the final
//          battle
// ADDITIONS NEEDED: None
/////////////////////////////////
do_tiger_retreats()
{
	for( i = 1; ; i++ )
	{
		retreat_tiger = GetEnt( "retreat tiger "+i, "script_noteworthy" );
		retreat_endpoint = getVehicleNode( "end retreat tiger "+i, "script_noteworthy" );
		if( !isDefined( retreat_tiger ) || !isDefined( retreat_endpoint ) )
		{
			break;
		}
		retreat_tiger setWaitNode( retreat_endpoint );
		retreat_tiger thread wait_for_retreat_done();
	}
}

/////////////////////////////////
// FUNCTION: wait_for_retreat_done
// CALLED ON: a retreating tiger
// PURPOSE: Waits until they reach the final node in their path then deletes them
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_retreat_done()
{
	self waittill( "reached_wait_node" );
	
	self delete();
}

/////////////////////////////////
// FUNCTION: wait_for_area_three_infantry
// CALLED ON: level
// PURPOSE: waits until the area three spawn trigger is hit then causes area three infantry to 
//          spawn.
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_area_three_infantry()
{
	trigger = GetEnt( "group 2 spawn", "script_noteworthy" );
	
	//GLOCKE: TODO - find out why this trigger is missing
	if(!IsDefined(trigger))
	{
		return;
	}
	
	trigger waittill( "trigger" );
	
	if( flag( "fuel depot cleared" ) )
	{
		return;
	}
	
	spawn_area_three_infantry();
}

/////////////////////////////////
// FUNCTION: spawn_area_three_infantry
// CALLED ON: level
// PURPOSE: Sets up spawn functions for area three infantry then spawns them
// ADDITIONS NEEDED: None
/////////////////////////////////
spawn_area_three_infantry()
{
	spawner_array = GetEntArray( "fuel depot spawner", "script_noteworthy" );
	array_thread( spawner_array, ::add_spawn_function, ::setup_fuel_depot_infantry );
	array_thread( spawner_array, ::add_spawn_function, ::fuel_depot_infantry_evasion );
	
	spawn_guys( spawner_array, undefined, true );
}

/////////////////////////////////
// FUNCTION: setup_fuel_depot_infantry
// CALLED ON: an infantryman
// PURPOSE: Sets up AI values and routines for area 3 infantry
// ADDITIONS NEEDED: None
/////////////////////////////////
setup_fuel_depot_infantry()
{
	self endon( "death" );
	
	level.enemy_infantry = array_add( level.enemy_infantry, self );
	self thread enforce_flame_deaths();
	if( self.classname == "actor_axis_ger_ber_wehr_reg_panzerschrek" )
	{
		self setThreatBiasGroup( "enemy antitank" );
		//self thread unlimited_rocket_ammo();
		self set_ent_see2_bias_group( "enemy antitank" );
		self.a.rockets = 200;
		self.maxsightdistsqrd = 3000*3000;
		self.a.no_weapon_switch = true;
		self.goalradius = 128;
		self thread do_antitank_AI(); 
	}
	else
	{
		self setThreatBiasGroup( "enemy infantry" );
		self set_ent_see2_bias_group( "enemy infantry" );
		self.goalradius = 128;
	}
}

//////////////////////////////////////////////
// EVENT 4
//////////////////////////////////////////////

/////////////////////////////////
// FUNCTION: air_strike_begin
// CALLED ON: level
// PURPOSE: Starts at the air strike just prior to the final battle. Sets up all variables to
//          clear out old events
// ADDITIONS NEEDED: Add warp points to warp player and tank to the appropriate area of the map
/////////////////////////////////
air_strike_begin()
{

	flag_set( "flak 88s destroyed" );
	flag_set( "radio tower destroyed" );
	flag_set( "fuel depot cleared" );
	
	thread do_sound_for_event( "battlechatter" );

	level thread setup_early_tanks();
	wait_for_first_player();
	wait( 4 );
	thread setup_player_tanks();
	wait(5);
	do_victory_scene( true );
	//do_area_spawn( 3 );
	//wait_network_frame();
	//spawn_area_four_infantry();

	//level thread setup_airstrike_triggers();
	
	
	
}

/////////////////////////////////
// FUNCTION: wait_for_area_four_infantry
// CALLED ON: level
// PURPOSE: waits until the area 4 spawn trigger is hit then spawns the area 4 infantry
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_area_four_infantry()
{
	trigger = GetEnt( "group 3 spawn", "script_noteworthy" );
	trigger waittill( "trigger" );
	
	if( flag( "final line breached" ) )
	{
		return;
	}
	
	spawn_area_four_infantry();
}

/////////////////////////////////
// FUNCTION: spawn_area_four_infantry
// CALLED ON: level
// PURPOSE: spawns all the area 4 infantry and sends them to fortify forward positions
// ADDITIONS NEEDED: Need to create a "setup_airstrike_infantry" function that sets up any
//                   unique AI behavior.
/////////////////////////////////
spawn_area_four_infantry()
{
	spawner_array = GetEntArray( "final battle spawner", "script_noteworthy" );
	
	spawn_guys( spawner_array, undefined, true );
	/*
	trigger_array = GetEntArray( "fourth area trigger", "targetname" );
	
	for( i = 0; i < trigger_array.size; i++ )
	{
		trigger_array[i] notify( "trigger" );
		wait_network_frame();
	}
	wait( 1 );
	*/
	//do_final_battle_fortify();
}

/////////////////////////////////
// FUNCTION: do_final_battle_fortify
// CALLED ON: level
// PURPOSE: Sets up the mg_turrets in this area to fire at the massed russian drones 
// ADDITIONS NEEDED:
/////////////////////////////////
do_final_battle_fortify()
{
	mg_array = getEntArray( "holdout mg", "script_noteworthy" );
	for( i = 0; i < mg_array.size; i++ )
	{
		mg_array[i].script_fireondrones = 1;
		mg_array[i] setturretignoregoals( true );
		mg_array[i] thread maps\_mgturret::mg42_target_drones( undefined, "axis", undefined );
	}
	/*
	num_fort_positions = 7;
	for( i = 1; i < num_fort_positions; i++ )
	{
		node = GetNode( "fortify_node"+i, "script_noteworthy" );
		soldiers = get_living_ai_array( "fortify soldier "+i, "script_noteworthy" );
		for( j = 0; j < soldiers.size; j++ )
		{
			if( isDefined( node ) && isDefined( soldiers[j] ) )
			{
				soldiers[j].goalradius = 512;
				soldiers[j] setGoalNode( node );
			}
		}
	}
	*/
}

/////////////////////////////////
// FUNCTION: setup_airstrike_triggers
// CALLED ON: level
// PURPOSE: Waits for all airstrike triggers.
// ADDITIONS NEEDED: None
/////////////////////////////////
setup_airstrike_triggers()
{
	airstrike_triggers = GetEntArray( "airstrike_trigger", "script_noteworthy" );
	
	for( i = 0; i < airstrike_triggers.size; i++ )
	{
		airstrike_triggers[i] thread wait_for_airstrike();
	}
}

/////////////////////////////////
// FUNCTION: wait_for_airstrike
// CALLED ON: an airstrike trigger
// PURPOSE: Waits until the trigger is hit then tells a plane to fire its rockets
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_airstrike()
{
	level.see2_max_tank_target_dist = 6000;
	level.see2_max_tank_firing_dist = 5000;
	while( 1 )
	{
		self waittill( "trigger", ent );
		
		if( flag( "final line breached" ) )
		{
			return;
		}
		
		ent notify( "fire rockets" );
		
 		wait( 0.05 );
	}
}

/////////////////////////////////
// FUNCTION: setup_airstrike_planes
// CALLED ON: level
// PURPOSE: Attaches all rocket and bomb models on airstrike planes
// ADDITIONS NEEDED: None
/////////////////////////////////
setup_airstrike_planes()
{
	rocket_planes = GetEntArray( "rocket plane", "script_noteworthy" );
	level.rocket_planes = rocket_planes;
	
	for( i = 0; i < rocket_planes.size; i++ )
	{
		rocket_planes[i].rockets = [];
		rocket_planes[i].rocket_tags = [];
		for( j = 1; j < 3; j++ )
		{
			left_tag = "tag_smallbomb0"+j+"Left";
			right_tag = "tag_smallbomb0"+j+"Right";
			shreck = spawn("script_model", rocket_planes[i] getTagOrigin( left_tag ) );
			shreck.angles = rocket_planes[i] getTagAngles( left_tag );
			shreck setmodel("katyusha_rocket");
			shreck linkto( rocket_planes[i], left_tag );
			rocket_planes[i].rockets = array_add( rocket_planes[i].rockets, shreck );
			rocket_planes[i].rocket_tags = array_add( rocket_planes[i].rocket_tags, left_tag );
			wait_network_frame();
			shreck = spawn("script_model", rocket_planes[i] getTagOrigin( right_tag ) );
			shreck.angles = rocket_planes[i] getTagAngles( right_tag );
			shreck setmodel("katyusha_rocket");
			shreck linkto( rocket_planes[i], right_tag );
			rocket_planes[i].rockets = array_add( rocket_planes[i].rockets, shreck );
			rocket_planes[i].rocket_tags = array_add( rocket_planes[i].rocket_tags, right_tag );
			wait_network_frame();
		}
		
		for( z = 0; z < rocket_planes[i].rockets.size; z++ )
		{
			rocket_planes[i].rockets[z] Hide();
		}
		
		rocket_planes[i] thread wait_for_fire_rockets();
	}
	
	level thread run_airstrike_planes();
}

/////////////////////////////////
// FUNCTION: run_airstrike_planes
// CALLED ON: level
// PURPOSE: Sets all the airstrike planes off in order, script controlled for easier tweaking
// ADDITIONS NEEDED: None
/////////////////////////////////
run_airstrike_planes()
{
	start_move_triggers = [];
	start_move_triggers = GetEntArray( "rocket_plane_starts", "targetname");
	
	start_trigger = getEnt( "finalbattle_trigger", "script_noteworthy" );
	start_trigger waittill( "trigger" );
	
	for(i =0; i < level.rocket_planes.size; i++)
	{
		for( z = 0; z < level.rocket_planes[i].rockets.size; z++ )
		{
			level.rocket_planes[i].rockets[z] Hide();
		}
		level.rocket_planes[i] thread DeleteMeAtEndOfPath();
	}
		
	player = get_players()[0];
	for(i = 0; i < start_move_triggers.size; i++ )
	{
		start_move_triggers[i] UseBy( player );
		//Kevins plane audio
		level.rocket_planes[i] thread bomber_planes();
		wait(1.5);
	}
}
//Kevins audio for planes
bomber_planes()
{
	while(distance(self.origin,GetPlayers()[0].origin) > 10000)
		wait(.01);
	self playsound ("fly_by");
}

DeleteMeAtEndOfPath()
{
	self waittill( "reached_end_node" );
	self Delete();
}


/////////////////////////////////
// FUNCTION: wait_for_fire_rockets
// CALLED ON: an airstrike plane
// PURPOSE: waits until the "fire rockets" signal is given then fires the rockets from this plane
//          at the target points laid out in radiant for it
// ADDITIONS NEEDED: Maybe make them acquire targets rather than firing at static points
/////////////////////////////////
wait_for_fire_rockets()
{
	self endon( "death" );
	
	self waittill( "fire rockets" );
	targetnodes = [];
	for( i = 1; i <= self.rockets.size; i++ )
	{
		targetnodes = array_add( targetnodes, getStruct( self.targetname+" target node "+i, "script_noteworthy" ) );
	}
	for( j = 0; j < self.rockets.size; j++ )
	{
		self.rockets[j] thread fire_rocket_at_pos( targetnodes[j] );
		wait( randomintrange( 1, 2 ) );
	}
}

/////////////////////////////////
// FUNCTION: fire_rocket_at_pos
// CALLED ON: a rocket
// PURPOSE: Moves a rocket to it's target position and blows it up when it arrives.
// ADDITIONS NEEDED: Damage tweaking
/////////////////////////////////
fire_rocket_at_pos( target_struct )
{
	start_pos = self.origin;
	end_pos = target_struct.origin;
	angles = vectortoangles( end_pos - start_pos );
	self.angles = angles;
	distance = distance( start_pos, end_pos );
	time = distance/4200;
	
	self unlink();
	self moveTo( end_pos, time );
	playFxOnTag( level._effect["pc132_trail"], self, "tag_fx" );
	self playloopsound("rpg_rocket");
	wait time;
	
	self hide();
	
	playfx( level._effect["pc132_explode"], self.origin );
	
	self stoploopsound();
	playSoundAtPosition("rpg_impact_boom", self.origin);
	radiusdamage( self.origin, 256, 250, 250 );
	earthquake( 0.5, 1.5, self.origin, 512 );
	
	wait( 4 );
	self delete();
}

/////////////////////////////////
// FUNCTION: wait_for_finalbattle
// CALLED ON: level
// PURPOSE: Waits until the player breaches the final trigger then plays the end cutscene
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_finalbattle( skipped_radio )
{
	flag_set( "final battle already started" );
	
	wait( 1 );
	
	tanks = getEntArray( "obj tanks", "targetname" );
	
	if( !IsDefined( skipped_radio ) )
	{
		Objective_State( 3, "done" );
	}
	
	Objective_add( 4, "current" );
	Objective_String( 4, &"SEE2_BREAK_THE_LINE" );
	
	autosave_by_name( "line broken" );
	
	level thread do_victory_scene();
}

/////////////////////////////////
// FUNCTION: do_victory_scene
// CALLED ON: level
// PURPOSE: plays the end IGC
// ADDITIONS NEEDED: Need to more adequately clean up remaining enemy AI, the attempts to do
//                   radius damage to enemy vehicles and directly kill infantry seems not to be
//									 working.
//
//
// Glocke: added in the objective check so that if the 88s and radio tower aren't killed, then the level fails them
//         didn't properly handle co-op or splitscreen, fixed that (made it so that the scene always runs off of the host)
//
//
//	players = get_players();
//	
//	level.otherPlayersSpectate = true;
//	level.otherPlayersSpectateClient = players[0];
//		
//	for( i = 1; i < players.size; i++ )
//	{
//		
//		players[i] thread maps\_callbackglobal::spawnSpectator();
//	}
//
/////////////////////////////////
do_victory_scene( jumpto )
{
	if(!IsDefined(jumpto))
	{
		victory_trigger = GetEnt( "victory trigger", "targetname" );
		obj_trigger = GetEnt( "special obj trigger", "targetname" );
	
		Objective_additionalPosition( 4, 0, obj_trigger.origin );
		guy = undefined;
		
		while( 1 )
		{
			victory_trigger waittill( "trigger", guy );
			if( !isPlayer( guy ) )
			{
				continue;
			}
			else
			{
				break;
			}
		}
	}
	
	level.nextmission_cleanup = ::clean_up_fadeout_hud;
	level notify( "kill the audio queue" ); //-- kill the audio queue... this should help some of the noise problems
		
	if( !flag( "flak objective completed" ) )
	{
		Objective_state( 1, "failed" );
	}
	
	if( !flag( "radio tower objective completed" ) )
	{
		Objective_state( 2, "failed" );
	}
	
	Objective_state( 4, "done" );
	
	flag_clear( "battlechatter allowed" );
	
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] thread magic_bullet_shield();
		if(!IsDefined(jumpto))
		{
			players[i] FreezeControls( true );
		}
	}
	
	//-- moved all of this to kill the enemies sooner
	for( i = 0; i < level.enemy_armor.size; i++ )
	{
		if( isDefined( level.enemy_armor[i] ) && isDefined( level.enemy_armor[i].health ) )
		{
			level.enemy_armor[i].health = 1;
			radiusDamage( level.enemy_armor[i].origin, 1000, 10, 10 );
		}
	}
	
	level.enemy_infantry = GetAIArray( "axis" );
	for( i = 0; i < level.enemy_infantry.size; i++ )
	{
		if( isDefined( level.enemy_infantry[i] ) && isDefined( level.enemy_infantry[i].health ) )
		{
			//level.enemy_infantry[i] doDamage( level.enemy_infantry[i].health * 2, level.enemy_infantry[i].origin );
			level.enemy_infantry[i] thread bloody_death( 0.2 );
		}
	}
	
	wait(0.75);
	
	//-- Playing the commisar dialogue off of the first player
	players[0].myTank playSound( level.scr_sound["commissar"]["victory1"],  "commissar done" );
	players[0].myTank waittill_notify_or_timeout("commissar done", 10);
	
	for(i=0; i < players.size; i++)
	{
		players[i] SetClientDvar( "hud_showStance", "0" ); 
		players[i] SetClientDvar( "miniscoreboardhide", 1 );
	}
	level thread fade_to_black( 2 );
	
	players[0].myTank playSound( level.scr_sound["commissar"]["victory2"],  "commissar done" );
	players[0].myTank waittill_notify_or_timeout("commissar done", 10);
	players[0].myTank playSound( level.scr_sound["commissar"]["victory3"],  "commissar done" );
	players[0].myTank waittill_notify_or_timeout("commissar done", 10);
	
	share_screen( get_host(), true, true );
	
	wait( 1 );
	
	//Glocke: Pull everyone from their tanks so that their weapons can be disabled
	for( i = 0; i < players.size; i++ )
	{
		players[i].myTank MakeVehicleUsable();
		players[i].myTank UseBy( players[i] );
		wait(0.05);
		players[i].myTank MakeVehicleUnusable();
	}

	/*	
	player_tank = guy.myTank;
	player_tank makevehicleusable();
	player_tank useby( guy );
	wait( 0.05 );
	player_tank makevehicleunusable();
	*/
	
	wait( 0.05 );
	
	link = getent( "player_temp_ending_pos", "script_noteworthy" );
	anim_node = getent( "temp_center", "targetname" );
	
	players[0] TakeWeapon( "m2_flamethrower" );

	for( i = 0; i < players.size; i++ )
	{
		players[i] hide();
		players[i] setorigin( link.origin + (0,0,4) );
		players[i] setplayerangles( link.angles );
		players[i] notify( "stop damage hud" );
		players[i] disableWeapons();
		
		if( i != 0)
		{
			//-- put the player in spectator mode
			level.otherPlayersSpectate = true;
			level.otherPlayersSpectateClient = players[0];

			players[i] thread maps\_callbackglobal::spawnSpectator();
		}
	}
	
	//Glocke: Make this the host only
	//for( i = 0; i < players.size; i++ )
	//{
		//Kevins notify to start audio for outro
		level notify("walla");
		level thread maps\see2_anim::play_player_anim_outro( 0, players[0], anim_node );
	//}
	level thread play_center_car_anims_side();
	level thread play_center_car_anims_middle();

	while( !flag( "player_ready_for_outro" ) || !flag( "outro_group_1_ready" ) || !flag( "outro_group_2_ready" ) )
	{
		wait(0.05);
	}
	
	
	level thread fade_from_black( 2 );
	//iprintlnbold( "OUTRO: Player get on the train." );
	wait( 34 );
	//kevin fading audio
	level notify("audio_fade");
	
	level thread fade_to_black(2);
	wait(2);
	for(i=0; i < players.size; i++)
	{
		players[i] SetClientDvar( "miniscoreboardhide", 0 );
	}
	
	thread nextmission();
	wait(0.5);
	share_screen( get_host(), false, false );
}

clean_up_fadeout_hud()
{
	if(IsDefined(level.fadetoblack))
	{
		level.fadetoblack Destroy();
	}
}

/////////////////////////////////
// FUNCTION: play_center_car_anims_side
// CALLED ON: level
// PURPOSE: spawns center car side guys and plays the center car side anims
// ADDITIONS NEEDED: None
/////////////////////////////////
play_center_car_anims_side() 
{
	//anim_node = getnode( "outro_center_origin", "targetname" );
	anim_node = getent( "temp_center", "targetname" );

	guys = [];

	left_spawn_points = getstructarray( "center_car_guy_left", "targetname" );

	//guys[0] = spawn_fake_guy_outro( left_spawn_points[0].origin, left_spawn_points[0].angles, "guyl1", "chernov" );
	guys[0] = spawn_fake_guy_outro( left_spawn_points[1].origin, left_spawn_points[1].angles, "guyl2" );
	guys[1] = spawn_fake_guy_outro( left_spawn_points[2].origin, left_spawn_points[2].angles, "guyl3" );
	guys[2] = spawn_fake_guy_outro( left_spawn_points[3].origin, left_spawn_points[3].angles, "guyl4" );
	// This is chernov 4
	//guys[1] = spawn_fake_guy_outro( left_spawn_points[4].origin, left_spawn_points[4].angles, "guyl5" );
	guys[3] = spawn_fake_hero_outro( left_spawn_points[4].origin, left_spawn_points[4].angles, "guyl5", "chernov" );

	//guys[3] = spawn_fake_guy_outro( left_spawn_points[5].origin, left_spawn_points[5].angles, "guyl6" );

	right_spawn_points = getstructarray( "center_car_guy_left", "targetname" );

	guys[4] = spawn_fake_guy_outro( right_spawn_points[0].origin, right_spawn_points[0].angles, "guyr1" );
	guys[5] = spawn_fake_guy_outro( right_spawn_points[1].origin, right_spawn_points[1].angles, "guyr2" );
	
	flag_set( "outro_group_1_ready" );

	while( !flag( "player_ready_for_outro" ) || !flag( "outro_group_1_ready" ) || !flag( "outro_group_2_ready" ) )
	{
		wait(0.05);
	}

	anim_node anim_single( guys, "outro" );
}

/////////////////////////////////
// FUNCTION: play_center_car_anims_middle
// CALLED ON: level
// PURPOSE: spawns center car middle guys and playes the center car middle anims
// ADDITIONS NEEDED: None
/////////////////////////////////
#using_animtree( "generic_human" );
play_center_car_anims_middle() // ( R1-6 M1-6 L7-12 )
{
	anim_node = getent( "temp_center", "targetname" );

	guys = [];

	center_spawn_points = getstructarray( "center_car_guy_center", "targetname" );

	guys[0] = spawn_fake_hero_outro( center_spawn_points[0].origin, center_spawn_points[0].angles, "guyc1", "chernov" );
	guys[1] = spawn_fake_guy_outro( center_spawn_points[1].origin, center_spawn_points[1].angles, "guyc2" );
	// reznov is 2
	//guys[2] = spawn_fake_guy_outro( center_spawn_points[2].origin, center_spawn_points[2].angles, "guyc3" );
	guys[2] = spawn_fake_hero_outro( center_spawn_points[2].origin, center_spawn_points[2].angles, "guyc3", "reznov" );

	guys[3] = spawn_fake_guy_outro( center_spawn_points[3].origin, center_spawn_points[3].angles, "guyc4" );

	guys[4] = spawn_fake_guy_outro( center_spawn_points[4].origin, center_spawn_points[4].angles, "guyc5" );
	guys[5] = spawn_fake_guy_outro( center_spawn_points[5].origin, center_spawn_points[5].angles, "guyc6" );
	
	flag_set( "outro_group_2_ready" );

	while( !flag( "player_ready_for_outro" ) || !flag( "outro_group_1_ready" ) || !flag( "outro_group_2_ready" ) )
	{
		wait(0.05);
	}

	anim_node anim_single( guys, "outro" );
}

/////////////////////////////////
// FUNCTION: spawn_fake_guy_outro
// CALLED ON: level
// PURPOSE: spawns a drone for the level outro
// ADDITIONS NEEDED: None
/////////////////////////////////
spawn_fake_guy_outro( startpoint, startangles, anim_name )
{
	while(!OkToSpawn())
	{
		wait(0.05);
	}
	
	guy = spawn( "script_model", startpoint );
	guy.angles = startangles;
	
	guy character\char_rus_r_rifle::main();
	guy maps\_drones::drone_allies_assignWeapon_russian();
	guy attach( "weapon_rus_mosinnagant_rifle", "tag_weapon_right" );
	

	guy.team = "allies";
	guy.for_ai_print = 1;
	guy.a = guy;

	guy UseAnimTree( #animtree );
	guy.animname = anim_name;
	guy makeFakeAI();
	guy.health = 100;

	return guy;
}

/////////////////////////////////
// FUNCTION: spawn_fake_hero_outro
// CALLED ON: level
// PURPOSE: This spawns a chernov or reznov model for use in the outro
// ADDITIONS NEEDED: None
/////////////////////////////////
spawn_fake_hero_outro( startpoint, startangles, anim_name, heroname )
{
	guy = spawn( "script_model", startpoint );
	guy.angles = startangles;
	
	if( heroname == "reznov" )
	{
		guy character\char_rus_h_reznov_coat::main();
	}
	else
	{
		guy character\char_rus_p_chernova::main();
		guy attach( "weapon_rus_mosinnagant_rifle", "tag_weapon_right");
	}
	guy maps\_drones::drone_allies_assignWeapon_russian();

	guy.team = "allies";
	guy.a = guy;

	guy UseAnimTree( #animtree );
	guy.animname = anim_name;
	guy makeFakeAI();
	guy.health = 100;

	return guy;

	
}

/////////////////////////////////
// FUNCTION: fade_to_black
// CALLED ON: level
// PURPOSE: fades down to black in fadeTime
// ADDITIONS NEEDED: None
/////////////////////////////////
fade_to_black( fadeTime )
{
	if( !IsDefined( fadeTime ) )
	{
		fadeTime = 5;
	}
	
	// fade to black
	level.fadetoblack = NewHudElem(); 
	level.fadetoblack.x = 0; 
	level.fadetoblack.y = 0; 
	level.fadetoblack.alpha = 0; 
		
	level.fadetoblack.horzAlign = "fullscreen"; 
	level.fadetoblack.vertAlign = "fullscreen"; 
	level.fadetoblack.foreground = false; 
	level.fadetoblack.sort = 50; 
	level.fadetoblack SetShader( "black", 640, 480 ); 

	// Fade into black
	level.fadetoblack FadeOverTime( fadeTime );
	level.fadetoblack.alpha = 1;
}

/////////////////////////////////
// FUNCTION:fade_from_black
// CALLED ON: level
// PURPOSE: fades up from black in fadeTime
// ADDITIONS NEEDED: None
/////////////////////////////////
fade_from_black( fadeTime )
{
	if( !IsDefined( fadeTime ) )
	{
		fadeTime = 5;
	}

	// Fade into black
	level.fadetoblack FadeOverTime( fadeTime );
	level.fadetoblack.alpha = 0;
}

//////////////////////////////////
// END SEE2.GSC
/////////////////////////////////


debug_ai_prints()
{
/#
	if( GetDvar( "debug_ai_print" ) == "" )
	{
		SetDvar( "debug_ai_print", "0" );
	}

	if( GetDvar( "debug_ai_print_range" ) == "" )
	{
		SetDvar( "debug_ai_print_range", "1000" );
	}

	level.debug_ai_print = false;
	while( 1 )
	{
		wait( 0.5 );

		if( GetDvar( "debug_ai_print" ) == "0" )
		{
			level.debug_ai_print = false;
			continue;
		}

		level.debug_ai_print = true;

		//ai = GetAiArray();
		ai = GetEntArray( "script_model", "classname");
		
		for( i = 0; i < ai.size; i++ )
		{
			if(IsDefined( ai[i].for_ai_print ) )
			{
				ai[i] thread debug_ai_prints_thread();
			}
		}
	}
#/
}

debug_ai_prints_thread()
{
/#
	self endon( "death" );

	if( IsDefined( self.ai_print ) )
	{
		return;
	}

	self.ai_print = true;

	while( level.debug_ai_print )
	{
		range = GetDvarInt( "debug_ai_print_range" );
		player = get_host();
		if( DistanceSquared( player.origin, self.origin ) < range * range )
		{
			print3d( self.origin + ( 0, 0, 72 ), self get_debug_ai_print() );
			wait( 0.05 ); 
		}
		else
		{
			wait( 0.2 );
		}
	}

	self.ai_print = false;
#/
}

get_debug_ai_print()
{
	dvar = GetDvar( "debug_ai_print" );
	switch( dvar )
	{
		case "script_noteworthy":
			value = self.script_noteworthy; 
			break; 
		case "threatbias":
			value = self.threatbias; 
			break;
		case "getthreatbiasgroup":
			value = self GetThreatBiasGroup(); 
			break;
		case "accuracy":
			value = self.accuracy; 
			break;
		case "ignoreme":
			value = self.ignoreme; 
			break;
		case "ignoreall":
			value = self.ignoreall; 
			break;
		case "health":
			value = self.health; 
			break;
		case "goalradius":
			value = self.goalradius; 
			break;
		case "moveplaybackrate":
			value = self.moveplaybackrate; 
			break;
		case "animname":
			value = self.animname; 
			break;
		case "script_forcecolor":
			if( IsDefined( self.script_forceColor ) )
			{
				value = self.script_forceColor; 
			}
			else
			{
				value = "undefined"; 
			}
			break;
		case "player_seek":
			if( IsDefined( self.player_seek ) )
			{
				value = self.player_seek; 
			}
			else
			{
				value = "undefined"; 
			}
			break;
		default:
			value = "undefined";
	}
	
	if( !IsDefined( value ) )
	{
		value = "no animname";
	}

	return value;
}
