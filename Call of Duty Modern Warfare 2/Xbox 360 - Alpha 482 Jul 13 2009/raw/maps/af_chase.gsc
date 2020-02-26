#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle_spline_zodiac;
#include maps\_vehicle;
#include maps\af_chase_code;
#include maps\af_chase_zodiac;
#include maps\_hud_util;

OBJ_PURSUE = 1;
//OBJ_CRASH = 2;
OBJ_SHEPHERD = 2;

main()
{
//	PreCacheItem( "cheytac" );
	PreCacheItem( "m203" );
	PreCacheRumble( "steady_rumble" );
	PreCacheRumble( "smg_fire" );
	PreCacheItem( "m16_grenadier" );
	PreCacheItem( "rpg_straight_af_chase" );
	PreCacheItem( "rpg_af_chase" );
	PreCacheItem( "rpd" );
	PreCacheItem( "uzi" );
	PreCacheItem( "littlebird_FFAR" );
	PreCacheModel( "weapon_parabolic_knife" );
	PreCacheModel( "zodiac_head_roller" );
	PreCacheModel( "weapon_colt_anaconda" );
	PreCacheShellShock( "af_chase_under_water" );

	level.next_rpg_firetime = gettime();
	
	maps\af_chase_precache::main();
//	maps\_patrol_anims::main();
	maps\af_chase_fx::main();
	maps\_hand_signals::initHandSignals();

	//original worldspawn values;
	// sunlight 1.5;
	//	0.960784 0.827451 0.647059

	SetSunLight( 1.441176, 1.2411765, 0.9705885 );
	SetSavedDvar( "r_specularcolorscale", "3" );

	add_start( "boatdrive_nofail", 	::start_boatdrive_nofail );
	add_start( "boatdrive_begin", 	::start_boatdrive_begin );
	add_start( "boatdrive_lake", 	::start_boatdrive_lake );
	add_start( "boatdrive_lake_mid", 	::start_boatdrive_lake_mid );
	add_start( "boatdrive_rapids", 	::start_boatdrive_rapids );
	add_start( "boatdrive_below_rapids", 	::start_boatdrive_river_below_rapids );
	add_start( "boatdrive_end", 	::start_boatdrive_end );

	add_start( "wakeup_after_crash", 	::start_wakeup_after_crash );
	add_start( "Knife_Fight", 	::start_Knife_Fight );
	add_start( "on_foot_art_tweak", 	::start_Knife_Fight_art_tweak );

	add_start( "debug_boatdrive", 	::start_debug_boatdrive );
	default_start( ::start_default );

	maps\createart\af_chase_fog::main();

	maps\_load::main();

	init_flags_here();

	maps\af_chase_anim::main_anim();

	set_water_sheating_time( "bump_small_start", "bump_big_start" );

	level.DODGE_DISTANCE = 2500;
	level.POS_LOOKAHEAD_DIST = 1200;
	
	maps\_compass::setupMiniMap( "compass_map_afghan_chase" );

	maps\_zodiac_drive::zodiac_preLoad( "viewhands_player_tf141" );
	maps\_zodiac_ai::main();

	/#
	SetDevDvarIfUninitialized( "scr_zodiac_test", 0 );
	#/

//	SetExpFog( 1000, 8000, 0.60, 0.50, 0.40, 0.8, 0 );

/* - Some temp stuff for messing with level fog and vision sets.
	maps\_utility::set_vision_set( "af_chase_outdoors_2", 0 );
	Start Fog - 1000, 8000, 0.60, 0.50, 0.40, 0.8, 0
	Caves fog - 1000, 8000, 0.60, 0.50, 0.40, 0.45, 0
	resevoir fog 1 -  8000, 45000, 0.60, 0.50, 0.40, 0.3, 0
	reveoir 2 - 2000, 20000, 0.60, 0.50, 0.40, 0.2, 0
	rapids - 1000, 11000, 0.60, 0.50, 0.40, 0.55, 0
	gorge - 1500, 15000, 0.60, 0.50, 0.40, 0.45, 0
	waterfall - 10000, 50000, 0.60, 0.50, 0.40, 0.75, 0  */

	level thread maps\af_chase_amb::main();

	script_vehicle_zodiac_players = GetEntArray( "script_vehicle_zodiac_player", "classname" );
	array_thread( script_vehicle_zodiac_players, ::add_spawn_function, maps\_zodiac_drive::drive_vehicle );
	array_thread( script_vehicle_zodiac_players, ::add_spawn_function, ::setup_boat_for_drive );
	array_thread( script_vehicle_zodiac_players, ::add_spawn_function, ::zodiac_physics );

	rpg_bridge_guy = GetEntArray( "rpg_bridge_guy", "script_noteworthy" );
	array_thread( rpg_bridge_guy, ::add_spawn_function, ::rpg_bridge_guy );

	actor_enemy_arab_AT_RPG7 = getentarray( "actor_enemy_arab_AT_RPG7", "classname" );
	array_thread( actor_enemy_arab_AT_RPG7, ::add_spawn_function, ::rpg_bridge_guy_target );
	sight_range = 3000*3000;
	foreach ( object in actor_enemy_arab_AT_RPG7)
	{
		object.script_sightrange = sight_range;
	}
	

//	thread_the_needle = GetEntArray( "thread_the_needle", "targetname" );
//	array_thread( thread_the_needle, ::trigger_thread_the_needle );

	rope_splashers = GetEntArray( "rope_splashers", "script_noteworthy" );
	array_thread( rope_splashers, ::add_spawn_function, ::rope_splashers );

	GetEnt( "enemy_chase_boat", "targetname" ) add_spawn_function( ::enemy_chase_boat );

	rapids_trigger = GetEnt( "rapids_trigger", "targetname" );
	rapids_trigger thread autosave_boat_chase();
	rapids_trigger thread	trigger_set_water_sheating_time( "bump_small_after_rapids", "bump_big_after_rapids" );
	rapids_trigger thread trigger_rapids();

	on_river_trigger = GetEnt( "on_river_trigger", "targetname" );
	on_river_trigger thread trigger_on_river();

	weapon_pullout_before_waterfall = GetEnt( "weapon_pullout_before_waterfall", "targetname" );
	weapon_pullout_before_waterfall thread trigger_weapon_pullout_before_waterfall();

	increase_enemy_boats_mid_lake = GetEnt( "increase_enemy_boats_mid_lake", "script_noteworthy" );
	increase_enemy_boats_mid_lake thread trigger_set_max_zodiacs( 2 );

	end_boat_chase_trigger = GetEnt( "end_boat_chase_trigger", "targetname" );
	end_boat_chase_trigger thread trigger_end_boat_chase();

	player_in_sight_of_boarding = GetEnt( "player_in_sight_of_boarding", "targetname" );
	player_in_sight_of_boarding thread player_in_sight_of_boarding_trigger();

	trigger_multiple_speeds = GetEntArray( "trigger_multiple_speed", "classname" );
	array_thread( trigger_multiple_speeds, ::trigger_multiple_speed_think );

	script_vehicle_littlebird_armed = GetEntArray( "script_vehicle_littlebird_armed", "classname" );
	array_thread( script_vehicle_littlebird_armed, ::add_spawn_function, ::godon );

	script_vehicle_zodiacs = GetEntArray( "script_vehicle_zodiac", "classname" );
	script_vehicle_zodiac_physics = GetEntArray( "script_vehicle_zodiac_physics", "classname" ) ;
	array_thread( script_vehicle_zodiac_physics, ::add_spawn_function, ::zodiac_physics );

	all_zodicas = array_combine( script_vehicle_zodiacs, script_vehicle_zodiac_physics );
	array_thread( all_zodicas, ::add_spawn_function, ::zodiac_treadfx );
	array_thread( all_zodicas, ::add_spawn_function, ::zodiac_enemy_setup );

//	foreach ( zodiac in script_vehicle_zodiac_physics )
//		zodiac.origin += ( 0, 0, 64 );// bump them up because they were previously not physics and placed below the surface

	script_vehicle_pavelow = GetEntArray( "script_vehicle_pavelow", "classname" );
	array_thread( script_vehicle_pavelow, ::add_spawn_function, ::disable_origin_offset );

	enemy_pickup_heli = GetEnt( "enemy_pickup_heli", "targetname" );
	enemy_pickup_heli add_spawn_function( ::setup_enemy_pickup_heli );

	array_thread( GetSpawnerArray(), ::set_fixed_node_after_seeing_player );
	array_thread( GetSpawnerArray(), ::add_spawn_function, ::lower_accuracy_behind_player );

	destructible_fake = GetEntArray( "destructible_fake", "script_noteworthy" );
	array_thread( destructible_fake, ::destructible_fake );

	thread afchase_objectives();

	end_caves_trigger = GetEnt( "end_caves_trigger", "targetname" );
	end_caves_trigger thread trigger_end_caves();
	end_caves_trigger thread autosave_boat_chase();
	
//	price_tells_player_go_right = getent( "price_tells_player_go_right", "targetname" );
//	price_tells_player_go_right thread trigger_price_tells_player_go_right();
	

	heli_attack_player_idle = getstructarray( "heli_attack_player_idle", "script_noteworthy" );
	array_thread( heli_attack_player_idle, ::heli_attack_player_idle );

	heli_attack_player_idle = GetEntArray( "heli_attack_player_idle", "script_noteworthy" );
	array_thread( heli_attack_player_idle, ::heli_attack_player_idle );

	kill_ai_in_volume = GetEntArray( "kill_ai_in_volume", "targetname" );
	array_thread( kill_ai_in_volume, ::kill_ai_in_volume );
	
	kill_destructibles_and_barrels_in_volume = GetEntArray( "kill_destructibles_and_barrels_in_volume", "targetname" );
	array_thread( kill_destructibles_and_barrels_in_volume, ::kill_destructibles_and_barrels_in_volume );

	add_extra_autosave_check( "boat_check_trailing", ::autosave_boat_check_trailing, "trailing too far behind the enemy boat." );

	seaknight_pickup_boat_spot = GetEnt( "seaknight_pickup_boat_spot", "script_noteworthy" );
	seaknight_pickup_boat_spot thread seaknight_pickup_boat_spot();

	GetEnt( "water_fall_edge_trigger", "targetname" ) thread trigger_water_fall_edge();

	thread river_current( "river_flow" );

	thread slow_enemy_zodiac_for_player();

	thread maps\af_chase_zodiac::zodiac_main();

	SetSavedDvar( "ai_friendlyFireBlockDuration", "0" );// this might bite me later.

	price_position_switch = GetEntArray( "price_position_switch", "targetname" );
	array_thread( price_position_switch, ::price_position_switch );

	bobbing_boat = GetEntArray( "bobbing_boat", "script_noteworthy" );
	array_thread( bobbing_boat, ::add_spawn_function, ::bobbing_boat_spawn );

	crashable_whizby_boats = GetEntArray( "crashable_whizby_boats", "script_noteworthy" );
	array_thread( crashable_whizby_boats, ::add_spawn_function, ::crashable_whizby_boats );

	pre_rapids_trigger = GetEnt( "pre_rapids_trigger", "targetname" );
	pre_rapids_trigger thread trigger_pre_rapids();

	enemy_zodiacs_wipe_out = GetEnt( "enemy_zodiacs_wipe_out", "targetname" );
	enemy_zodiacs_wipe_out thread trigger_enemy_zodiacs_wipe_out();

	neutral_enemies = GetEntArray( "neutral_enemies", "targetname" );
	array_thread( neutral_enemies, ::trigger_neutral_enemies );

	dialog_cave = GetEnt( "dialog_cave", "targetname" );
//	dialog_cave = Spawn( "trigger_radius", (-18968, -18324, 0), 0, 730.399, 1000 );
	dialog_cave thread dialog_cave();

	thread dialog_boat_battlechatter();

	thread sunsample_after_caves();


	thread music();

	thread dvar_warn();

	thread maps\af_chase_knife_fight::knife_fight_main();

	thread set_price_autoswitch_after_caves();

	thread search_the_scrash_site();

//	boat_mount = GetEnt( "boat_mount", "targetname" );
//	boat_mount thread trigger_boat_mount();

	enable_heli_death = GetEnt( "enable_heli_death", "targetname" );
	enable_heli_death thread enable_heli_death();

	trigger_out_of_caves = GetEnt( "trigger_out_of_caves", "targetname" );
	if ( IsDefined( trigger_out_of_caves ) )
		trigger_out_of_caves thread trigger_out_of_caves();
	battlechatter_off( "allies" );
//	thread dump_on_command();
}

setup_boat_for_drive()
{
	self Vehicle_TurnEngineOff();
	self maps\_vehicle::godon();
//	self MakeUnusable();
	level.players_boat = self;

	level.players_boat StartUsingHeroOnlyLighting();

	self SetModel( "vehicle_zodiac" );

	self waittill( "vehicle_mount", player );

//	thread missile_repulser();

	self SetModel( "vehicle_zodiac_viewmodel" );

	self Vehicle_TurnEngineOn();

	flag_set( "player_on_boat" );
	
	thread autosave_by_name_silent( "mount_boat" );
	
	add_extra_autosave_check( "boat_check_player_speeding_along", ::autosave_boat_check_player_speeding_along, "players boat not moving fast enough!" );
	

	level.player ent_flag_clear( "near_death_vision_enabled" );

	thread dialog_boat_nag();

	thread dialog_boat_direction_nag();

	thread raise_attacker_accuracy_on_nearby_boats();

	thread rumble_with_throttle();

	thread flip_when_player_dies();

	thread zodiac_treadfx();

	boatrider = get_boat_rider( "boatrider0" );

	if ( ! boatrider ent_flag_exist( "price_animated_into_boat" ) )
		boatrider thread boatrider_think( self );
	else
	{
		boatrider ent_flag_wait( "price_animated_into_boat" );
		level notify( "stop_animate_price_into_boat" );
		level.price StopAnimScripted();
		level.price thread boatrider_think( level.players_boat );
	}

}



enable_shoot_driver()
{
	self notify( "enable_shoot_driver" );
	self endon( "enable_shoot_driver" );

	self.allowdeath = 1;
	self SetCanDamage( true );

	self waittill( "damage" );
	maps\_zodiac_drive::driver_death( self );
}

boatrider_targets()
{
	level.price endon( "stop_boatrider_targets" );
	level.price endon( "death" );
	while ( 1 )
	{
		wait .05;
		end = level.price maps\_zodiac_drive::drive_magic_bullet_get_end( level.players_boat, level.player GetEye(), true );// piggyback this functionality. Price finds the same targets interesting.

		if ( !isdefined( end.obj ) )
		{
			level.price ClearEntityTarget();
			continue;
		}
		if ( !isai( end.obj ) )
		{
			level.price SetEntityTarget( end.obj );
			level.price.favoriteenemy = undefined;
			if ( IsDefined( end.shootable_driver ) )
				end.obj thread enable_shoot_driver();
		}
		else
		{
			level.price ClearEntityTarget();
			level.price.favoriteenemy = end.obj;
		}
	}
}

boatrider_link( vehicle )
{
	self LinkToBlendToTag( vehicle, "tag_guy2", false );

}

boatrider_think( vehicle )
{
	boatrider_link( vehicle );

	self AllowedStances( "crouch" );
	self.vehicle = vehicle;
	self.force_canAttackEnemyNode = true;

	self thread boatrider_targets();
	self.fullAutoRangeSq = 2000 * 2000;

	// make Price know about all enemies (helps enemy selection when moving fast)
	self.highlyAwareRadius = 2048;

	self AnimCustom( maps\_zodiac_ai::think );
}

start_default()
{
	boat_common();
	level.price thread animate_price_into_boat();
	friendly_boat = spawn_vehicle_from_targetname( "players_boat" );
	enemy_boat = spawn_vehicle_from_targetname( "enemy_chase_boat" );
	thread enable_bread_crumb_chase();
	thread set_breadcrumb_fail_time( 15 );
	thread _Objective_OnEntity( OBJ_PURSUE, enemy_boat );
	thread dialog_start();
	MusicPlayWrapper( "af_chase_boat_mount" );

	wait 3;
//	vehicle_dump();
	flag_wait( "player_on_boat" );

	thread set_breadcrumb_fail_time( 10, 30 );
}

boat_common()
{
	maps\_friendlyfire::TurnOff();
	boatrider = get_boat_rider( "boatrider0" );
	level.price = boatrider;
	thread price_ai_mods( boatrider );
	thread test_m203();
}

price_ai_mods( price )
{
	price.attackeraccuracy = 0;
	price.baseaccuracy = .1;
	price.ignoreSuppression = true;
	price.dontavoidplayer = true;
	price.takedamage = false;
	price.suppressionwait = 0;
	price.pathrandompercent = 0;
	price.ignoreExplosionEvents = true;
	price disable_surprise();
	price.grenadeawareness = 0;
	price.ignoreme = true;
	price.IgnoreRandomBulletDamage = true;
	price.disableBulletWhizbyReaction = true;
	flag_wait( "player_on_boat" );
	price.baseaccuracy = 25;
}

start_boatdrive_begin()
{
	change_target_on_vehicle_spawner( "enemy_chase_boat", "enemy_boat_pos_boatdrive_begin" );
	boat_common();
	vision_set_fog_changes( "afch_fog_caves", 0 );

	friendly_boat = spawn_vehicle_from_targetname( "players_boat" );
	enemy_boat = spawn_vehicle_from_targetname_and_drive( "enemy_chase_boat" );

	waittillframeend;// let the spawned vehicle run its spawn_func to catch this useby notify.
	thread _Objective_OnEntity( OBJ_PURSUE, enemy_boat );

	friendly_boat UseBy( level.player );

//	friendly_boat Vehicle_SetSpeedImmediate( 33,90,90 );

	thread enable_bread_crumb_chase();
}

players_boat()
{

}

start_debug_boatdrive()
{
	boat_common();
	friendly_boat = spawn_vehicle_from_targetname( "players_boat" );
	friendly_boat UseBy( level.player );
	array_thread( GetEntArray( "trigger_multiple", "code_classname" ), ::trigger_off );
}

start_boatdrive_lake_mid()
{
	//fast forward to new location. speed is approximated based on pretend playthrough.
	change_target_on_vehicle_spawner( "enemy_chase_boat", "enemy_boat_pos_mid_lake" );
	boat_common();
	flag_set( "exit_caves" );
	vision_set_fog_changes( "af_chase_outdoors_2", 0 );

	// move player boat to new position
	player_boat_spawner = GetEnt( "players_boat", "targetname" );
	player_boat_spawner_position = getstruct( "lake_mid_start_pose", "targetname" );
	player_boat_spawner.origin = player_boat_spawner_position.origin;
	player_boat_spawner.angles = player_boat_spawner_position.angles;

	friendly_boat = spawn_vehicle_from_targetname( "players_boat" );
	enemy_boat = spawn_vehicle_from_targetname_and_drive( "enemy_chase_boat" );

	waittillframeend;// let the spawned vehicle run its spawn_func to catch this useby notify.
	thread _Objective_OnEntity( OBJ_PURSUE, enemy_boat );

	friendly_boat UseBy( level.player );

	friendly_boat Vehicle_SetSpeedImmediate( 60, 90, 90 );// last two params don't do anything but are required for the boat.

	thread enable_bread_crumb_chase();

	thread river_current( 	"river_current_start_boatdrive_lake" );

}

start_boatdrive_lake()
{
	//fast forward to new location. speed is approximated based on pretend playthrough.
	change_target_on_vehicle_spawner( "enemy_chase_boat", "enemy_boat_pos_lake" );
	boat_common();
	vision_set_fog_changes( "af_chase_outdoors_2", 0 );

	// move player boat to new position
	player_boat_spawner = GetEnt( "players_boat", "targetname" );
	player_boat_spawner_position = getstruct( "lake_start_pose", "targetname" );
	player_boat_spawner.origin = player_boat_spawner_position.origin;
	player_boat_spawner.angles = player_boat_spawner_position.angles;

	friendly_boat = spawn_vehicle_from_targetname( "players_boat" );
	enemy_boat = spawn_vehicle_from_targetname_and_drive( "enemy_chase_boat" );

	waittillframeend;// let the spawned vehicle run its spawn_func to catch this useby notify.
	thread _Objective_OnEntity( OBJ_PURSUE, enemy_boat );

	friendly_boat UseBy( level.player );

	friendly_boat Vehicle_SetSpeedImmediate( 48, 90, 90 );// last two params don't do anything but are required for the boat.

	thread enable_bread_crumb_chase();

	thread river_current( 	"river_current_start_boatdrive_lake" );

}

change_target_on_vehicle_spawner( boat_targetname, boat_destination_node )
{
	boat = GetEnt( boat_targetname, "targetname" );
	destnode = GetVehicleNode( boat_destination_node, "targetname" );
	boat.target = destnode.targetname;
}

change_target_ent_on_vehicle_spawner( heli_targetname, boat_destination_node )
{
	boat = GetEnt( heli_targetname, "targetname" );
	destnode = GetEnt( boat_destination_node, "targetname" );
	boat.target = destnode.targetname;

	//this stuff should probably be in another function
	boat.origin = destnode.origin;
	boat.angles = destnode.angles;
	boat.speed = destnode.speed;
}

enemy_chase_boat()
{
	level.breadcrumb = [];
	level.enemy_boat = self;
	self endon( "death" );
	thread _objective_onentity( OBJ_PURSUE, self );
	self VehPhys_DisableCrashing();
	self.veh_pathtype = "constrained";
	self thread zodiac_monitor_player_trailing_time();

	foreach ( rider in self.riders )
	{
		if ( IsDefined( rider.magic_bullet_shield ) && rider.magic_bullet_shield )
			continue;
		rider thread magic_bullet_shield();
	}

//	self.veh_pathtype = "follow";
	while ( 1 )
	{
		wait .25;
		enemy_chase_boat_breadcrumb();
	}
}

init_flags_here()
{
	flag_init( "player_boat_mounted" );
	flag_init( "zodiac_catchup" );
	flag_init( "player_in_sight_of_boarding" );
	flag_init( "water_cliff_jump_splash_sequence" );
	flag_init( "player_on_boat" );
	flag_init( "exit_caves" );
	flag_init( "enemy_zodiacs_wipe_out" );
	flag_init( "on_river" );
	flag_init( "zodiac_boarding" );
	flag_init( "enemy_heli_takes_off" );
	flag_init( "killed_pickup_heli" );
	flag_init( "end_heli_crashed" );
	flag_init( "end_heli_nearly_crashed" );
	flag_init( "player_gets_up_after_waterfall" );
	flag_init( "price_anim_on_boat" );
	flag_init( "sandstorm_fully_masked" );
	flag_init( "objective_shepherd_stabbed" );
	flag_init( "fight_objective_positioned" );
	flag_init( "rapids_head_bobbing" );
	flag_init( "heli_firing" );
	flag_init( "pause_limp" );
	flag_init( "price_vanishing_now" );
	flag_init( "heli_death_enable" );
	flag_init( "blinder_effect" );
	flag_init( "goodtime_for_fog_blast" );
	flag_init( "player_moved_recently" );
	flag_init( "player_damaged" );
	flag_init( "shepherd_dialog_playing" );

	/#
	flag_init( "debug_crumbs" );
	#/

	flag_init( "shepherd_spawned" );
	flag_init( "wakeup_start" );
	flag_init( "player_standing" );
	flag_init( "player_wanders_desert" );

	flag_init( "dialog_all_finished" );
	flag_init( "fog_pulse_window_for_spawn" );

}

afchase_objectives()
{
		// Don't let Shepherd get away.
		Objective_Add( OBJ_PURSUE, "current", &"AF_CHASE_PURSUE" );
		flag_wait( "killed_pickup_heli" );
		Objective_State( OBJ_PURSUE, "done" );

		// Search the crash site.
//		Objective_Add( OBJ_CRASH, "current", &"AF_CHASE_OBJ_CRASH", GetEnt( "damaged_pavelow", "targetname" ).origin );
//		flag_wait( "objective_crash_searched" );
//		Objective_State( OBJ_CRASH, "done" );

		thread maps\af_chase_knife_fight::knife_fight_objective_handle( OBJ_SHEPHERD );

}

start_boatdrive_rapids()
{
	//fast forward to new location. speed is approximated based on pretend playthrough.
	change_target_on_vehicle_spawner( "enemy_chase_boat", "enemy_boat_pos_rapids" );

	change_target_ent_on_vehicle_spawner( "seaknight_fly_over", "enemy_heli_pos_rapids" );

	boat_common();
	flag_set( "exit_caves" );

	//af_chase_outdoors_2
	//set vision set so the water thing can work
	vision_set_fog_changes( "af_chase_outdoors_2", 0 );

	// move player boat to new position
	player_boat_spawner = GetEnt( "players_boat", "targetname" );
	player_boat_spawner_position = getstruct( "rapids_start_position", "targetname" );
	player_boat_spawner.origin = player_boat_spawner_position.origin;
	player_boat_spawner.angles = player_boat_spawner_position.angles;

	friendly_boat = spawn_vehicle_from_targetname( "players_boat" );
	enemy_boat = spawn_vehicle_from_targetname_and_drive( "enemy_chase_boat" );
	enemy_pickup_heli = spawn_vehicle_from_targetname_and_drive( "seaknight_fly_over" );

	waittillframeend;// let the spawned vehicle run its spawn_func to catch this useby notify.
	thread _Objective_OnEntity( OBJ_PURSUE, enemy_boat );

	friendly_boat UseBy( level.player );
	friendly_boat Vehicle_SetSpeedImmediate( 78, 90, 90 );// last two params don't do anything but are required. not optional for boats I guess.

	thread enable_bread_crumb_chase();

	//catch up the current
	thread river_current( 	"river_current_start_rapids" );

}

start_boatdrive_river_below_rapids()
{
	//fast forward to new location. speed is approximated based on pretend playthrough.
	change_target_on_vehicle_spawner( "enemy_chase_boat", "enemy_boat_pos_below_rapids" );
	change_target_ent_on_vehicle_spawner( "seaknight_fly_over", "enemy_heli_pos_rapids" );

	boat_common();
	flag_set( "exit_caves" );
	flag_set( "on_river" );

	//af_chase_outdoors_2
	//set vision set so the water thing can work
	vision_set_fog_changes( "af_chase_outdoors_2", 0 );

	// move player boat to new position
	player_boat_spawner = GetEnt( "players_boat", "targetname" );
	player_boat_spawner_position = getstruct( "below_rapids_start_position", "targetname" );
	player_boat_spawner.origin = player_boat_spawner_position.origin;
	player_boat_spawner.angles = player_boat_spawner_position.angles;

	friendly_boat = spawn_vehicle_from_targetname( "players_boat" );
	enemy_boat = spawn_vehicle_from_targetname_and_drive( "enemy_chase_boat" );

	waittillframeend;// let the spawned vehicle run its spawn_func to catch this useby notify.
	thread _Objective_OnEntity( OBJ_PURSUE, enemy_boat );

	friendly_boat UseBy( level.player );
	friendly_boat Vehicle_SetSpeedImmediate( 78, 90, 90 );// last two params don't do anything but are required. not optional for boats I guess.

	thread enable_bread_crumb_chase();

	//catch up the current
	thread river_current( 	"river_current_start_rapids" );

}

start_boatdrive_end()
{
	//fast forward to new location. speed is approximated based on pretend playthrough.
	change_target_on_vehicle_spawner( "enemy_chase_boat", "enemy_boat_pos_end" );

	seaknight_pickup_boat_spot = GetEnt( "seaknight_pickup_boat_spot", "script_noteworthy" );

	boat_common();
	flag_set( "exit_caves" );
	flag_set( "enemy_zodiacs_wipe_out" );

	//af_chase_outdoors_2
	//set vision set so the water thing can work
	vision_set_fog_changes( "af_chase_outdoors_2", 0 );

	// move player boat to new position
	player_boat_spawner = GetEnt( "players_boat", "targetname" );
	player_boat_spawner_position = getstruct( "end_start_position", "targetname" );
	player_boat_spawner.origin = player_boat_spawner_position.origin;
	player_boat_spawner.angles = player_boat_spawner_position.angles;

	friendly_boat = spawn_vehicle_from_targetname( "players_boat" );
	enemy_boat = spawn_vehicle_from_targetname_and_drive( "enemy_chase_boat" );
	enemy_pickup_heli = spawn_vehicle_from_targetname( "enemy_pickup_heli" );

	waittillframeend;// let the spawned vehicle run its spawn_func to catch this useby notify.
	thread _Objective_OnEntity( OBJ_PURSUE, enemy_boat );

	friendly_boat UseBy( level.player );
	friendly_boat Vehicle_SetSpeedImmediate( 57, 90, 90 );// last two params don't do anything but are required. not optional for boats I guess.

	thread enable_bread_crumb_chase();
	thread river_current( 	"river_current_start_boatdrive_end" );

}

trigger_end_boat_chase()
{
	self waittill( "trigger" );

	thread conveyerbelt_set_speed_fraction( .25, 12 );

	level.enemy_pickup_heli delayThread( 3.15, ::pickup_heli_damage_handle );

	end_org = getstruct( "end_drive_to_position", "targetname" );
//	end_org = SpawnStruct();
//	end_org.origin = ( 25479.5, 25856.4, -5403.5 );

	level notify( "quit_bread_crumb" );// kills failure from falling behind script.
	remove_extra_autosave_check( "boat_check_trailing" );
	remove_extra_autosave_check( "boat_check_player_speeding_along" );
	autosave_by_name( "end_of_boatride" );

	wait 2;
	level.players_boat vehicleDriveTo( end_org.origin, 20 );
	wait 2;
	level.players_boat vehicleDriveTo( end_org.origin, 0 );

}

#using_animtree( "vehicles" );
seaknight_pickup_boat_spot()
{
	flag_wait( "enemy_boat_boarded_seaknight" );

	seaknight = level.enemy_pickup_heli;
	seaknight ClearAnim( %ch46_doors_open, 1 );
	seaknight SetAnim( %ch46_doors_close );
	time = seaknight GetAnimTime( %ch46_doors_close );

	seaknight delayCall( time, ::clearanim, %ch46_doors_close, 0 );

	level.enemy_boat delayThread( time, ::delete_end_seaknight );

	dummy = level.enemy_boat vehicle_to_dummy();
	dummy LinkTo( seaknight );

	level.price notify( "stop_boatrider_targets" );
	level.price.use_auto_pose = true;
	level.price SetEntityTarget( seaknight );

	end_heli_escape_path = GetEnt( "end_heli_escape_path", "targetname" );

	seaknight thread vehicle_paths( end_heli_escape_path );
	wait .1;

	wait 2;
}

setup_enemy_pickup_heli()
{
	self SetHoverParams( 0, 0, 0 );
	self SetAnim( %ch46_doors_open );
	level.enemy_pickup_heli = self;
	self thread godon();
}

trigger_water_fall_edge()
{
	trigger = self;
	trigger waittill( "trigger" );

//	thread lerp_fov_overtime( 1.35, 90 ); // want to complete the lerp before slowing down the server.
	thread fall_slowmo();


	level.player AllowStand( true );
	level.player AllowCrouch( false );
	level.player AllowProne( false );

	flag_set( "enemy_heli_takes_off" );

	MusicStop( 1 );

	PlayFXOnTag( getfx( "splash_over_waterfall" ), level.players_boat, "tag_guy2" );

	level.players_boat notify( "kill_treadfx" );

	linkobj = level.player_linkent;

	good_velocity = 1300;
	timer = GetTime() + 300;
	while ( GetTime() < timer && Distance( ( 0, 0, 0 ), level.players_boat Vehicle_GetVelocity() ) < good_velocity )
		wait .05;
	linkobj Unlink();

	targent = GetEnt( trigger.target, "targetname" );
	on_foot_destination = GetEnt( "on_foot_destination", "targetname" );

	rote_time = 2.3;
	angles = VectorToAngles( targent.origin - getstruct( targent.target, "targetname" ).origin );
	linkobj delayCall( 0, ::RotateTo, angles, rote_time, 0, 0 );

	thread remove_weapon_while_falling();

	moverate = Distance( ( 0, 0, 0 ), level.players_boat Vehicle_GetVelocity() ) + 150;
	new_org = ( linkobj.origin[ 0 ], linkobj.origin[ 1 ], targent.origin[ 2 ] );// fall straight down
	level notify( "player_over_the_waterfall" );
	linkobj movewithrate( targent.origin, moverate );

	AmbientStop();
	set_ambient( "af_chase_caves" );
	SetBlur( 6, 1.5 );

	level.player PlayRumbleOnEntity( "damage_heavy" );
	PlayFX( getfx( "player_hits_water_after_waterfall" ), linkobj GetTagOrigin( "tag_origin" ) + ( 0, 0, -77 ) );
	for ( i = 0; i < 20; i++ )
		PlayFX( getfx( "splashy_bubbles" ), linkobj GetTagOrigin( "tag_ac130_camera" ) + randomvectorrange( -40, 40 ) );
	thread play_sound_in_space( "scn_afchase_player_plunge", level.player.origin );
	fog_set_changes( "afch_fog_underwater", 0 );
	Earthquake( .3, 3.5, level.player.origin, 1000 );

	level.price function_stack_clear();// mo said too. keep his function stack from continuing after he's dead.
	level.price stop_magic_bullet_shield();
	level.price Delete();
	array_call( GetAIArray(), ::Delete );
//	level.player ShellShock( "af_chase_under_water",8 );

	level.player DisableWeapons();

//	exploder( "334" );
	level.player thread waterfx();
	wait 1;
	if ( !	flag( "killed_pickup_heli" ) )
	{
		// Shepherd escaped on the Helicopter.
		SetDvar( "ui_deadquote", &"AF_CHASE_FAILED_TO_SHOOT_DOWN" );
		missionFailedWrapper();
		return;
	}
//	linkobj MoveTo( on_foot_destination.origin, 2, .2, .2 );
//	level.player thread play_sound_on_entity( "surface_breathe" );
//	linkobj delayCall( 1, ::RotateTo, on_foot_destination.angles, 2, .2, .2 );

	black_overlay = create_client_overlay( "black", 0, level.player );
	black_overlay FadeOverTime( .5 );
	black_overlay.alpha = 1;

	AmbientStop( 2 );

	delayThread( 1.6, ::send_player_to_quiet_place );
	delayThread( 4.6, ::send_player_back_to_noisy_place, on_foot_destination.origin );
	wait 7;

	set_ambient( "af_chase_ext" );
	level.player Unlink();
	level.player PlayerSetGroundReferenceEnt( undefined );
	level.player teleport_player( on_foot_destination );

	flag_set( "player_gets_up_after_waterfall" );
	flag_wait( "end_heli_crashed" );

	level.player SetPlayerAngles( linkobj.angles );
	level.player EnableWeapons();

	flag_set( "water_cliff_jump_splash_sequence" );

	black_overlay delayCall( .05, ::Destroy );// leave it for a frame, then knife fight takes over with new overlays.
	thread maps\af_chase_knife_fight::knife_fight_setup();
	thread maps\af_chase_knife_fight::transition_to_knife_fight_from_shore();

}

remove_weapon_while_falling()
{
	flag_wait( "killed_pickup_heli" );
	level.player DisableWeapons();
}

enable_heli_death()
{
	self.radius = 4400;
//	self waittill( "trigger" );
	while( distance( self.origin,level.player.origin ) > 4000 )
		wait .05;
	flag_set( "heli_death_enable" );
}


pickup_heli_damage_handle()
{
	damage_to_deal = 320;
	accumulated_damage = 0;


	while ( accumulated_damage < damage_to_deal || ! flag( "heli_death_enable" ) )
	{
//		self waittill( "damage", damage, attacker, direction_vec, point, damageType, modelName, tagName );
		self waittill( "damage", damage, attacker, direction_vec, point );
		if ( attacker != level.player )
			continue;

		PlayFX( getfx( "rocket_hits_heli" ), point, direction_vec );

		accumulated_damage += damage;
	}

	thread conveyerbelt_set_speed_fraction( 2, 0 );

	flag_set( "killed_pickup_heli" );
	self.script_crashtypeoverride = "none";
	self.crashing = true;// halts vehicles script from freeing the vehicle.
	self godoff();
	self notify( "death" );
//	self SetAirResistance( 1550 );
//	self SetTurningAbility( 1 );
	self thread helicopter_crash_rotate_af();
	self thread vehicle_paths( getstruct( "helicopter_crash_path", "targetname" ) );

	crash_heli_here = getstruct( "crash_heli_here", "script_noteworthy" );
	crash_heli_here waittill( "trigger" );

	flag_set( "end_heli_crashed" );

	Earthquake( .4, 4.5, level.player.origin, 1000 );

	self notify( "stop_crash_loop_sound" );
	self notify( "crash_done" );
	self notify( "nodeath_thread" );
	wait .1;// let the sound thread stop..
	self Delete();
}

fall_slowmo()
{
	slowmo_start();
	slowmo_setspeed_slow( 0.33 );
	slowmo_setlerptime_in( 0.5 );
	slowmo_lerp_in();

	flag_wait( "enemy_heli_takes_off" );
	wait( 1.3 );

	slowmo_setlerptime_out( .5 );
	slowmo_lerp_out();
	slowmo_end();
}

dialog_start()
{
//	thread add_dialogue_line( "Price", "They're just around the corner, come on." );
	level.price thread generic_dialogue_queue( "afchase_pri_aroundcorner" );
	wait 4;
//	thread add_dialogue_line( "Price", "We need to get on that boat. " );
	level.price thread generic_dialogue_queue( "afchase_pri_getonboat" );

	wait 2;
}

dialog_boat_direction_nag()
{
	nagtime = 4000;
	next_nag = GetTime() + nagtime;
	wrong_way_time = 2;
	wrong_way_time_count = 0;

	dialog = [];
	dialog = array_add( dialog, "afchase_pri_wrongway" );
	dialog = array_add( dialog, "afchase_pri_turntoobjective" );
	dialog = array_add( dialog, "afchase_pri_wheregoing" );

	unused_dialog = dialog;

	picked = undefined;

	wait 1;// let enemy boat get defined..

	/#
	if ( GetDvarInt( "scr_zodiac_test" ) )
		return;
	#/

	self endon( "death" );
	level.enemy_boat endon( "death" );
	level.player endon ( "death" );
	while ( 1 )
	{
		if ( !in_front_by_velocity( level.players_boat, level.enemy_boat ) && next_nag < GetTime() )
			wrong_way_time_count += .05;
		else
			wrong_way_time_count = 0;

		if ( flag( "price_anim_on_boat" ) )
		{
			wait .05;
			continue;
		}

		if ( wrong_way_time_count > wrong_way_time )
		{
			picked = random( unused_dialog );
			level.price thread generic_dialogue_queue( picked );
			unused_dialog = array_remove( unused_dialog, picked );
			next_nag = GetTime() + nagtime;
			if ( !unused_dialog.size )
				unused_dialog = dialog;
		}

		wait .05;
		if ( flag( "player_in_sight_of_boarding" ) )
			return;
	}
}

dialog_boat_battlechatter()
{

	dialog_direction = [];
	dialog_direction = array_add( dialog_direction, "TF_pri_callout_targetclock_" );

	dialog_helicopter_six = [];
	dialog_helicopter_six = array_add( dialog_helicopter_six, "afchase_pri_evasive" );
	dialog_helicopter_six = array_add( dialog_helicopter_six, "afchase_pri_shakeemoff" );
	dialog_helicopter_six = array_add( dialog_helicopter_six, "afchase_pri_miniguns" );

	dialog_helicopter_ahead = [];
	dialog_helicopter_ahead = array_add( dialog_helicopter_ahead, "afchase_pri_dodgeheli" );
	dialog_helicopter_ahead = array_add( dialog_helicopter_ahead, "afchase_pri_gunsspinup" );
	dialog_helicopter_ahead = array_add( dialog_helicopter_ahead, "afchase_pri_steerclear" );

	dialog_rpg_bridge_guy = [];
	dialog_rpg_bridge_guy = array_add( dialog_rpg_bridge_guy, "afchase_pri_rpgsonbridge" );

	dialog = [];
	dialog[ "dialog_direction" ] = 	dialog_direction;
	dialog[ "dialog_helicopter_six" ] = 	dialog_helicopter_six;
	dialog[ "dialog_helicopter_ahead" ] = 	dialog_helicopter_ahead;
	dialog[ "dialog_rpg_bridge_guy" ] = 	dialog_rpg_bridge_guy;

	timeout[ "dialog_direction" ] = .5;
	timeout[ "dialog_helicopter_six" ] = 1;
	timeout[ "dialog_helicopter_ahead" ] = 1;
	timeout[ "dialog_rpg_bridge_guy" ] = .7;

	nagtime[ "dialog_direction" ] = 5500;
	nagtime[ "dialog_helicopter_six" ] = 9300;
	nagtime[ "dialog_helicopter_ahead" ] = 2000;
	nagtime[ "dialog_rpg_bridge_guy" ] = 10000;

	last_nagtime[ "dialog_direction" ] = GetTime();
	last_nagtime[ "dialog_helicopter_six" ] = GetTime();
	last_nagtime[ "dialog_helicopter_ahead" ] = GetTime();
	last_nagtime[ "dialog_rpg_bridge_guy" ] = GetTime();

	unused_dialog = dialog;

	picked = undefined;

	wait 1;// let enemy boat get defined..

	/#
	if ( GetDvarInt( "scr_zodiac_test" ) )
		return;
	#/

	level.player endon( "death" );
	self endon( "death" );
	flag_wait ( "exit_caves" );
	while ( 1 )
	{
		type = level waittill_any_return( "dialog_direction", "dialog_helicopter_six", "dialog_helicopter_ahead", "dialog_rpg_bridge_guy" );
		if ( flag( "price_anim_on_boat" ) )
			continue;
		if ( flag( "rapids_head_bobbing" ) )
			continue;
		picked = random( unused_dialog[ type ] );

		if ( GetTime() - last_nagtime[ type ] < nagtime[ type ] )
			continue;

		last_nagtime[ type ] = GetTime();
		
		if( type == "dialog_direction" )
			level.price thread generic_dialogue_queue( picked + level.dialog_dir, timeout[ type ] );
		else
			level.price thread generic_dialogue_queue( picked, timeout[ type ] );
		
		
		unused_dialog[ type ] = array_remove( unused_dialog[ type ], picked );
		if ( !unused_dialog[ type ].size )
			unused_dialog[ type ] = dialog[ type ];
		wait .05;
		if ( flag( "player_in_sight_of_boarding" ) )
			return;
	}
}

dialog_boat_nag()
{
	nagtime = 8000;
	next_nag = GetTime() + nagtime;

	dialog = [];
	dialog = array_add( dialog, "afchase_pri_gettingaway" );
	dialog = array_add( dialog, "afchase_pri_gogogo" );
	dialog = array_add( dialog, "afchase_pri_cantlet" );
	dialog = array_add( dialog, "afchase_pri_losinghim" );
	dialog = array_add( dialog, "afchase_pri_drivingtheboat" );
	dialog = array_add( dialog, "afchase_pri_fullpower" );

	unused_dialog = dialog;

	picked = undefined;

	self endon( "death" );
	level.price endon( "death" );

	while ( 1 )
	{
		if ( bread_crumb_get_player_trailing_fraction() > .5 && next_nag < GetTime() && ! level.price ent_flag( "transitioning_positions" ) )
		{
			picked = random( unused_dialog );
//			level.price thread radio_dialogue( picked );
			side = level.price.a.boat_pose;
			Assert( IsDefined( side ) && ( side == "left" || side == "right" ) );

			doradio = false;

			if ( level.price.a.lastShootTime > GetTime() - 2000 && ! player_full_heath() )
				doradio = true;
			if ( flag( "rapids_head_bobbing" ) )
			{
				wait .05;
				continue;
			}

			if ( doradio )
				level.price thread generic_dialogue_queue( picked, 1 );
			else
				level.price thread price_anim_single_on_boat( side + "_" + picked );

			unused_dialog = array_remove( unused_dialog, picked );
			next_nag = GetTime() + nagtime;
			if ( !unused_dialog.size )
				unused_dialog = dialog;
		}
		wait .05;
		if ( flag( "player_in_sight_of_boarding" ) )
			return;
	}
}

trigger_end_caves()
{
	self waittill( "trigger" );
	flag_set( "exit_caves" );
	MusicStop( 1 );
	wait 1.1;

	MusicPlayWrapper( "af_chase_lake_music" );

	thread maps\_utility::set_ambient( "af_chase_exit" );
	wait 3;
	SetSavedDvar( "sm_sunSampleSizeNear", "2" );
	if ( IsDefined( level.price ) )
			level.price DontCastShadows();

}

rope_splashers()
{

//this might be cool if I could do client ragdoll..

//self waittill ( "death" );
//self endon ("death");
//
//ent = SpawnStruct();
//ent endon( "complete" );
//ent delayThread( 5, ::send_notify, "complete" );

//  while( self.origin[2] > 48 )
//  	wait .05;
//
//  PlayFX( getfx("body_falls_from_ropes_splash") , set_z( self.origin,48 ) );
// StartRagdoll();
}

trigger_set_max_zodiacs( value )
{
	self waittill( "trigger" );
	level.enemy_snowmobiles_max = value;
}

trigger_rapids()
{
	level.player endon( "death" );
	self waittill( "trigger" );
	flag_set( "rapids_trigger" );
	thread maps\_utility::set_ambient( "af_chase_rapids" );
	level.player.nooffset = true;// makes enemy boats spawn exactly behind the player.

	level.enemy_snowmobiles_max = 1;

	flag_set( "rapids_head_bobbing" );
//	price_anim_single_on_boat( "rapids_in", false );
	level.price generic_dialogue_queue( "afchase_pri_rapidsahead" );
	thread price_anim_loop_on_boat( "rapids_loop", "end_the_rapids_loop" );

	end_price_crazy = GetEnt( "end_price_crazy", "targetname" );
	end_price_crazy waittill( "trigger" );
	flag_clear( "rapids_head_bobbing" );

	level.players_boat notify( "end_the_rapids_loop" );
	level.enemy_snowmobiles_max = 2;

	wait 1;
	set_price_auto_switch_pose();

	// they get really bogged in so reduce them after a bit.
	wait 9;
	level.enemy_snowmobiles_max = 1;
}

trigger_on_river()
{
	self waittill( "trigger" );
	thread maps\_utility::set_ambient( "af_chase_river" );

	flag_set( "on_river" );

}

trigger_weapon_pullout_before_waterfall()
{
	self waittill( "trigger" );

	if( is_default_start() )
		nextmission();

	level.price thread generic_dialogue_queue( "afchase_pri_anotherchance" );

	wait 2;

	level.players_boat Vehicle_TurnEngineOff();
	level.players_boat UseBy( level.player );
	level.players_boat MakeUnusable();

	level.players_boat SetModel( "vehicle_zodiac" );

	level.player_linkent = get_new_link_obj( level.players_boat GetTagOrigin( "tag_player" ) );
	level.player_linkent LinkTo( level.players_boat );
//	level.player PlayerLinkToDelta( level.player_linkent, "tag_player", 0 );
	level.player PlayerLinkToDelta(  level.player_linkent, "tag_player", 0, 180, 180, 180, 180, true );
	level.player PlayerSetGroundReferenceEnt( level.player_linkent );
	level.player SetPlayerAngles( ( 0, 0, 0 ) );


//	level.player GiveWeapon( "rpd" );
//	level.player SetWeaponAmmoClip( "rpd", 100 );
//	level.player SwitchToWeapon( "rpd" );

	level.player TakeAllWeapons();
	level.player GiveWeapon( "rpg_af_chase" );
	level.player SwitchToWeapon( "rpg_af_chase" );

	level.price delayThread( 6, ::test_m203_again );

	cleanup_stuff_on_players_boat();

	wait 1;

//	level.player AllowStand( false );

}

cleanup_stuff_on_players_boat()
{
	level.players_boat notify ( "cleanup" );
	if ( IsDefined( level.players_boat.gun_attached ) )
	{
		level.players_boat Detach( level.zodiac_gunModel, "tag_weapon_left" );
		level.players_boat.gun_attached = undefined;
	}
	level.players_boat Detach( level.zodiac_playerHandModel, "tag_player" );
}

delete_end_seaknight()
{
	foreach ( rider in self.riders )
		rider stop_magic_bullet_shield();
	self Delete();
}

player_in_sight_of_boarding_trigger()
{
	self waittill( "trigger" );
	flag_set( "player_in_sight_of_boarding" );
}


sunsample_after_caves()
{
	flag_wait( "exit_caves" );
	SetSavedDvar( "sm_sunSampleSizeNear", "2" );
}

dialog_cave()
{
	level.player endon( "death" );
	self waittill( "trigger" );
	level.price generic_dialogue_queue( "afchase_pri_thrucave" );
}

music()
{
	flag_wait( "player_on_boat" );
//	MusicPlayWrapper( "afghan_chase_music" );
}

start_wakeup_after_crash()
{
	vision_set_changes( "af_chase_outdoors_2", 0 );
	targent = GetEnt( "on_foot_destination", "targetname" );
//	level.player teleport_player( targent );
	flag_set( "end_heli_crashed" );
	flag_set( "water_cliff_jump_splash_sequence" );
	flag_set( "killed_pickup_heli" );
	thread maps\af_chase_knife_fight::knife_fight_setup();
	thread maps\af_chase_knife_fight::transition_to_knife_fight_from_shore();
	delayThread( 1, maps\_utility::set_ambient, "af_chase_ext" );
	thread kill_all_the_ai_and_fx_from_boatride();
}

start_Knife_Fight()
{
	vision_set_changes( "af_chase_outdoors_2", 0 );

	targent = GetEnt( "on_foot_destination", "targetname" );
	targent.origin = ( 27966, 34345, -9866 );

	level.player teleport_player( targent );

	flag_set( "end_heli_crashed" );
	flag_set( "player_standing" );
	flag_set( "water_cliff_jump_splash_sequence" );
	flag_set( "killed_pickup_heli" );
	flag_set( "dialog_all_finished" );

	thread maps\af_chase_fx::blind_player_effect();
	thread maps\af_chase_fx::sand_storm_effect();
	thread maps\af_chase_fx::block_out_the_sky();
	thread maps\af_chase_fx::start_sandstorm();
	thread maps\af_chase_knife_fight::sneaky_shephard_in_sandstorm();
	thread maps\af_chase_knife_fight::give_knife_fight_weapon();

	delayThread( 1, maps\_utility::set_ambient, "af_chase_ext" );
	delayThread( 1, ::fog_set_changes, "afch_fog_dunes" );
	thread kill_all_the_ai_and_fx_from_boatride();


}

start_Knife_Fight_art_tweak()
{
	vision_set_changes( "af_chase_outdoors_2", 0 );
	targent = GetEnt( "on_foot_destination", "targetname" );
	level.player teleport_player( targent );
	thread kill_all_the_ai_and_fx_from_boatride();
}

start_boatdrive_nofail()
{
	SetDvar( "scr_zodiac_test", 1 );
	level.player EnableInvulnerability();
	thread start_default();
}

rpg_bridge_guy()
{
	trigger = Spawn( "trigger_radius", self.origin + ( 0, 0, -2000 ), 0, 4500, 2000 );
	trigger waittill( "trigger" );
	level notify( "dialog_rpg_bridge_guy" );
}

rpg_bridge_guy_target()
{
	target_ent = spawn( "script_origin", level.players_boat.origin );
	self ent_flag_init( "first_player_sighting" );
	self disable_long_death();
	self setentitytarget( target_ent );
	self.favoriteenemy = target_ent;
	self.ignoreall = true;
	self.rpg_setup_time = gettime()+randomintrange( 1000,2000 ); // "reaction time so they don't instantly shoot when you round a corner.

	random_vec = flat_origin( randomvectorrange( -64, 64) );
	firing_range = 3000;
	while( isalive( self ) )
	{
		velocity_offset = level.players_boat Vehicle_GetVelocity() * 1.4 ;
		
//		target_ent.origin = level.players_boat.origin +( level.players_boat Vehicle_GetVelocity() * 1.89 );

		forward_origin = level.players_boat.origin + velocity_offset;
		forward_origin = set_z( forward_origin , level.players_boat.origin[2]+24 );
		
//		Line( forward_origin, level.players_boat.origin, (0,1,0) );
		
		
		//when the player is headed towards something use the spline direction to influence the shot. otherwise fire away in the direct forward path.
		if( ! BulletTracePassed( level.player geteye()+(0,0,16), forward_origin, false, self ) )
		{
			offset = distance( (0,0,0), velocity_offset);
			target_ent.origin = get_position_from_spline_unlimited( level.player.targ, level.player.progress + offset-level.POS_LOOKAHEAD_DIST, level.player.offset );
			target_ent.origin = set_z( target_ent.origin , level.players_boat.origin[2]+24 );
//			Line( target_ent.origin, level.players_boat.origin, (0,0,1) );
			target_ent.origin = ( target_ent.origin + forward_origin ) / 2;
		}
		else
		{
			target_ent.origin = forward_origin;
		}
		
//		Line( target_ent.origin, level.players_boat.origin, (1,0,0) );
		self OrientMode( "face point", target_ent.origin ) ;
		
		bullettraced_to_player = false;
		if( BulletTracePassed( self gettagorigin( "tag_flash" ), level.player geteye(), false, self ) )
		{
			bullettraced_to_player = true;
			if( ! ent_flag( "first_player_sighting" )  )
				ent_flag_set( "first_player_sighting" );
		}
		
		if( ! ent_flag( "first_player_sighting" )  )
			self.rpg_setup_time = gettime()+randomintrange( 1000,2000 ); // "reaction time so they don't instantly shoot when you round a corner.
			
		if( gettime() > self.rpg_setup_time )
			if( bullettraced_to_player )
				if( BulletTracePassed( self gettagorigin( "tag_flash" ), target_ent.origin+ random_vec, false, self ) )
					if( distance( self.origin, level.player.origin) < firing_range )
						if( gettime() > level.next_rpg_firetime )
							break;
			
		wait .05;
	}
	
	ammo = "rpg_straight_af_chase";
//	if( cointoss() )
//		ammo = "rpg";
	
	if( isdefined( self ) && isdefined( self gettagorigin( "tag_flash") ) )  // Tried isalive . debugger is broken today =(.
		MagicBullet( ammo, self gettagorigin( "tag_flash"), target_ent.origin + random_vec );
		
	level.next_rpg_firetime = gettime()+randomintrange( 300,500 ); //stagger time between multiple guys
	target_ent delete();
	
}

set_price_autoswitch_after_caves()
{
	flag_wait( "exit_caves" );
	set_price_auto_switch_pose();
}


teleport_price_on_mount( node )
{
	level endon ( "end_teleport_price_on_mount" );
	level.players_boat waittill ( "vehicle_mount" );	
	level.price teleport_ai_here( node );
}

teleport_ai_here( eNode )
{
	AssertEx( IsAI( self ), "Function teleport_ai can only be called on an AI entity" );
	AssertEx( IsDefined( eNode ), "Need to pass a node entity to function teleport_ai" );
	self ForceTeleport( eNode.origin, eNode.angles );
	self SetGoalPos( self.origin );
}



animate_price_into_boat()
{
	level endon( "stop_animate_price_into_boat" );
	waittillframeend;// let players boat get spawned and defined
	pathnode = GetNode( self.target, "targetname" );
	node = Spawn( "script_origin", pathnode.origin );
	node.angles = pathnode.angles + ( 0, -90, 0 );
	level.price ent_flag_init( "price_animated_into_boat" );

	//make the scene stick to boat should player start to drive
	node delayCall( 2, ::linkto, level.players_boat );// give it time to settle before linking

	thread teleport_price_on_mount( node );
	node anim_generic_reach( level.price, "price_into_boat" );
	level notify ( "end_teleport_price_on_mount" );
	level.price LinkTo( node );

	level.price delayThread( 1.5, ::ent_flag_set, "price_animated_into_boat" );// I timed this as a good cutoff point for when the player jumps in first.
	level.players_boat delayCall( 1, ::JoltBody, level.price.origin, .15 );
	level.players_boat delayThread( 1, ::play_sound_in_space, "water_boat_splash_small", level.players_boat.origin );

	node anim_generic( level.price, "price_into_boat" );
	level.price thread boatrider_think( level.players_boat );
}

search_the_scrash_site()
{
	flag_wait( "end_heli_crashed" );
	exploder( "heli_fire" );
	damaged_heli = GetEnt( "damaged_pavelow", "targetname" );
	wait .5;
	damaged_heli Show();
	trigger = Spawn( "trigger_radius", damaged_heli.origin + ( 0, 0, -100 ), 0, 670, 600 );
	trigger waittill( "trigger" );
}

trigger_pre_rapids()
{
	self waittill( "trigger" );
	level.price.use_auto_pose = undefined;
	level.price.scripted_boat_pose = "left";
}

trigger_out_of_caves()
{
	self waittill( "trigger" );
	level.price thread generic_dialogue_queue( "afchase_pri_openareas" );
}

//trigger_boat_mount()
//{
////	self setHintString( "Press &&1 to mount" );
//
//	self waittill( "trigger" );
//	if ( flag( "player_on_boat" ) )
//		return;
//
//	origin = level.players_boat GetTagOrigin( "tag_player" );
//	angles = level.players_boat GetTagAngles( "tag_player" );
//	level.player SwitchToWeapon( "uzi" );
//	level.player FreezeControls( true );
//	level.player PlayerLinkToBlend( level.players_boat, "tag_player", .35, .2, .1 );
//	wait .35;
//	level.player FreezeControls( false );
//	level.price ent_flag_wait( "price_animated_into_boat" );
//	level.players_boat MakeUsable();
//	level.players_boat UseBy( level.player );
//
//}

send_player_to_quiet_place()
{
//	target = getstruct( "quiet_place", "targetname" );
	level.player_linkent MoveTo( ( 120144, -124592, -16076 ), 13, 0, 0 );
}

send_player_back_to_noisy_place( origin )
{
	level.player_linkent MoveTo( ( 120144, -124592, -16076 ), 6, 0, 0 );
}


trigger_price_tells_player_go_right()
{
	self.origin += (0,0,-50);
	self waittill ("trigger" );
	level.price thread generic_dialogue_queue( "afchase_pri_right" );
	
}