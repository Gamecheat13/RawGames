#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\_turret;
#include maps\_vehicle;
#include animscripts\anims;
#include maps\_skipto;
#include maps\_anim;
#include maps\_dialog;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\la.gsh;

autoexec init_la()
{
	OnPlayerConnect_Callback( ::on_player_connect );
	
	sp = GetEnt( "harper", "targetname" );
	if ( IsDefined( sp ) )
	{
		sp add_spawn_function( ::spawn_func_harper );
	}
	
	sp = GetEnt( "hillary", "targetname" );
	if ( IsDefined( sp ) )
	{
		sp add_spawn_function( ::spawn_func_hillary );
	}
	
	sp = GetEnt( "sam", "targetname" );
	if ( IsDefined( sp ) )
	{
		sp add_spawn_function( ::spawn_func_sam );
	}
	
	sp = GetEnt( "jones", "targetname" );
	if ( IsDefined( sp ) )
	{
		sp add_spawn_function( ::spawn_func_jones );
	}
}

on_player_connect()
{
	setup_challenges();
	level_settings();
}

spawn_func_harper()
{
	level.harper = self;
	//AddArgus( self, "harper", "harper" );
}

spawn_func_hillary()
{
	level.hillary = self;
	//AddArgus( self, "hillary", "hillary" );
}

spawn_func_sam()
{
	level.sam = self;
	self set_ignoreme( true );
	//AddArgus( self, "sam", "sam" );
}

spawn_func_jones()
{
	level.jones = self;
	self set_ignoreme( true );
	//AddArgus( self, "jones", "jones" );
}

init_flags()
{
	flag_init( "end_intro_screen" );
	
	if ( !level flag_exists( "intro_done" ) ) // might be initialized by _scene ( only in la_1 )
	{
		flag_init( "intro_done" );
	}
	
	// shared flags
	flag_init( "harper_dead" );
	flag_init( "pip_playing" );
	
	// la_1
	flag_init( "drone_approach", true );
	flag_init( "intro_attack_start" );
	flag_init( "near_sam_cougar" );
	flag_init( "start_sam_end_vo" );
	flag_init( "sam_success" );
	flag_init( "sam_complete" );
	flag_init( "sniper_option" );
	flag_init( "rappel_option" );
	flag_init( "left_side_rappel_started" );
	flag_init( "left_side_rappel_guys_dead" );
	flag_init( "bus_rpg_guy_spawned" );
	flag_init( "bus_rpg_guy_fired" );
	flag_init( "bus_rpg_guy_dead" );
	flag_init( "player_looking_at_rappel_guy" );
	flag_init( "player_looking_at_rpg_bus_guy" );
	flag_init( "out_of_ammo" );
	flag_init( "low_road_complete" );
	flag_init( "started_rappelling" );
	flag_init( "done_rappelling" );
	flag_init( "player_in_cougar" );
	flag_init( "drive_failing" );
	flag_init( "low_road_move_up_4" );
	flag_init( "drive_under_first_overpass" );
	flag_init( "drive_under_big_overpass" );
	flag_init( "first_drone_strike" );
	flag_init( "allow_sniper_exit" );
	flag_init( "player_approaches_convoy" );
	flag_init( "la_1_sky_transition" );
	
	// la_1b flags
	flag_init( "bdog_front_spawned" );
	flag_init( "bdog_front_wounded" );
	flag_init( "bdog_front_immobilized" );
	flag_init( "bdog_front_dead" );
	
	flag_init( "bdog_back_spawned" );
	flag_init( "bdog_back_wounded" );
	flag_init( "bdog_back_immobilized" );
	flag_init( "bdog_back_dead" );
	
	flag_init( "fl_clear_the_street" );
	flag_init( "fl_player_entered_plaza" );
	flag_init( "plaza_gunner_spawned" );
	flag_init( "plaza_gunner_dead" );
	flag_init( "brute_force_fail" );
	flag_init( "rooftop_sam_in" );
	flag_init( "intersect_vip_cougar_died" );
	flag_init( "event_6_done" );
	flag_init( "f35_la_plaza_crash_start" );
	flag_init( "f35_la_plaza_crash_end" );
	flag_init( "la_arena_start" );
	flag_init( "anderson_saved" );
	flag_init( "ending_ai_can_die" );
	flag_init( "ending_player_arrived" );
	
	flag_init( "intersect_vip_cougar_saved" );
	flag_init( "building_collapsing" );
	
	flag_init( "got_hit_by_claw" );
	//flag_init( "claw_vo_going" );
	flag_init( "someone_on_train" );
	flag_init( "someone_near_hotel" );
	flag_init( "vo_general" );
	flag_init( "police_in_hotel" );
	
	flag_init( "plaza_vo_done" );
	
	// la_2 flags
	flag_init( "player_in_f35" );
	flag_init( "player_flying" );
	flag_init( "player_awake" );
	flag_init( "no_fail_from_distance" );
	flag_init( "F35_pilot_saved" );
	flag_init( "G20_1_saved" );  // TODO: coordinate with code to determine how this data is imported
	flag_init( "G20_2_saved" );  // TODO: coordinate with code to determine how this data is imported
	flag_init( "G20_1_dead" );  // use this to check if G20_1 has died
	flag_init( "G20_2_dead" );  // use this to check if G20_2 has died
	flag_init( "convoy_movement_started" );
	flag_init( "convoy_can_move" );
	flag_init( "player_in_range_of_convoy" );
	flag_init( "convoy_in_position" );
	flag_init( "ground_targets_escape" );
	flag_init( "convoy_at_ground_targets" );
	flag_init( "ground_targets_done" );
	flag_init( "tutorial_done" );
	flag_init( "convoy_nag_override" );
	flag_init( "hotel_street_truck_group_1_spawned" );
	flag_init( "convoy_at_roadblock" );
	flag_init( "roadblock_done" );
	flag_init( "convoy_at_rooftops" );
	flag_init( "rooftops_done" );
	flag_init( "convoy_at_dogfight" );
	flag_init( "convoy_continue" );
	flag_init( "dogfight_wave_1" );
	flag_init( "dogfight_wave_2" );
	flag_init( "dogfight_wave_3" );
	flag_init( "dogfight_done" );
	flag_init( "convoy_at_trenchrun" );
	flag_init( "trenchrun_done" );
	flag_init( "trenchruns_start" );
	flag_init( "convoy_at_hotel" );
	flag_init( "hotel_done" );
	flag_init( "convoy_at_outro" );
	flag_init( "outro_start" );
	flag_init( "ejection_start" );
	flag_init( "eject_done" );
	flag_init( "outro_done" );
	flag_init( "gas_station_destroyed" );
	flag_init( "warehouse_destroyed" );
	flag_init( "ground_attack_vehicles_dead" );
	flag_init( "rooftop_enemies_dead" );
	flag_init( "eject_sequence_started" );
	flag_init( "convoy_at_apartment_building" );
	flag_init( "convoy_at_parking_structure" );
	flag_init( "la_transition_setup_done" );
	flag_init( "player_passed_garage" );
	flag_init( "start_anderson_f35_exit" );
	flag_init( "convoy_at_trenchrun_turn_2" );
	flag_init( "convoy_at_trenchrun_turn_3" );
	flag_init( "missile_event_started" );
	flag_init( "dogfights_story_done" );
	flag_init( "missile_can_damage_player" );
	flag_init( "force_flybys_available" );
	flag_init( "strafing_run_active" );
	flag_init( "strafing_wave_done" );
	flag_init( "convoy_passed_roundabout" );
	flag_init( "player_at_rooftops" );
	flag_init( "building_collapse_done" );
	flag_init( "pip_intro_done" );
	flag_init( "eject_drone_spawned" );
	flag_init( "roadblock_clear" );
	flag_init( "do_anderson_landing_vo" );
	flag_init( "ok_to_drop_building1" );
	flag_init( "ok_to_drop_building" );
	
	flag_init( "do_plaza_anderson_convo" );
}

setup_objectives()
{
	level.OBJ_SHOOT_DRONES	= maps\_objectives::register_objective( &"LA_SHARED_OBJ_SHOOT_DRONES" );
	level.OBJ_REGROUP		= maps\_objectives::register_objective( &"LA_SHARED_OBJ_REGROUP" );
	level.OBJ_RAPPEL		= maps\_objectives::register_objective( &"LA_SHARED_OBJ_RAPPEL" );
	level.OBJ_RAPPEL2		= maps\_objectives::register_objective( &"LA_SHARED_OBJ_RAPPEL2" );
	level.OBJ_SNIPE			= maps\_objectives::register_objective( &"LA_SHARED_OBJ_SNIPE" );
	level.OBJ_HIGHWAY		= maps\_objectives::register_objective( &"LA_SHARED_OBJ_HIGHWAY" );
	level.OBJ_POTUS			= maps\_objectives::register_objective( &"LA_SHARED_OBJ_POTUS" );
	level.OBJ_DRIVE			= maps\_objectives::register_objective( &"LA_SHARED_OBJ_DRIVE" );
	level.OBJ_INTERACT		= maps\_objectives::register_objective( &"" );
	level.OBJ_LOCK_PERK		= maps\_objectives::register_objective( &"" );
	level.OBJ_BRUTE_PERK	= maps\_objectives::register_objective( &"" );
	level.OBJ_INTRUDER_PERK	= maps\_objectives::register_objective( &"" );
	level.OBJ_STREET_REGROUP= maps\_objectives::register_objective( &"LA_SHARED_OBJ_STREET_REGROUP" );
	level.OBJ_STREET		= maps\_objectives::register_objective( &"LA_SHARED_OBJ_STREET" );
	level.OBJ_BIG_DOGS		= maps\_objectives::register_objective( &"LA_SHARED_OBJ_BIG_DOGS" );
	level.OBJ_PLAZA			= maps\_objectives::register_objective( &"LA_SHARED_OBJ_PLAZA" );
	level.OBJ_ARENA			= maps\_objectives::register_objective( &"LA_SHARED_OBJ_ARENA" );
	level.OBJ_FOLLOW		= maps\_objectives::register_objective( &"" );
	level.OBJ_ANDERSON		= maps\_objectives::register_objective( &"" );
	level.OBJ_SONAR_OUT		= maps\_objectives::register_objective( &"" );
	level.OBJ_FLY			= maps\_objectives::register_objective( &"LA_SHARED_OBJ_FLY" );
	level.OBJ_PROTECT		= maps\_objectives::register_objective( &"LA_SHARED_OBJ_PROTECT" );
	level.OBJ_FOLLOW_VAN	= maps\_objectives::register_objective( &"LA_SHARED_OBJ_FOLLOW_VAN" );
	level.OBJ_ROADBLOCK 	= maps\_objectives::register_objective( &"LA_SHARED_OBJ_ROADBLOCK" );
	level.OBJ_ROOFTOPS 		= maps\_objectives::register_objective( &"LA_SHARED_OBJ_ROOFTOPS" );
	level.OBJ_DOGFIGHTS 	= maps\_objectives::register_objective( &"LA_SHARED_OBJ_DOGFIGHTS" );
	level.OBJ_DOGFIGHTS_LAST= maps\_objectives::register_objective( &"" );
	level.OBJ_DOGFIGHTS_STRAFE = maps\_objectives::register_objective( &"" );
	level.OBJ_TRENCHRUN_1 	= maps\_objectives::register_objective( &"LA_SHARED_OBJ_TRENCHRUN" );
	level.OBJ_TRENCHRUN_2 	= maps\_objectives::register_objective( &"LA_SHARED_OBJ_TRENCHRUN" );
	level.OBJ_TRENCHRUN_3 	= maps\_objectives::register_objective( &"LA_SHARED_OBJ_TRENCHRUN" );
	level.OBJ_TRENCHRUN_4 	= maps\_objectives::register_objective( &"LA_SHARED_OBJ_TRENCHRUN" );
}

setup_story_states()
{	
	if ( get_players()[0] get_story_stat( "HARPER_DEAD_IN_YEMEN" ) || GetDvarInt( "la_harperdead" ) == 1 )
	{
		flag_set( "harper_dead" );
	}
}

// sets flags for the skipto's and exits out at appropriate skipto point.  All previous skipto setups in this functions will be called before the current skipto setup is called
skipto_cleanup()
{
	load_gumps();
			
	if ( level.skipto_point == "intro" )
		return;
	
	flag_set( "intro_done" );
	
	if ( level.skipto_point == "after_the_attack" )
	{
		return;
	}
	
	if ( level.skipto_point == "sam_jump" )
	{
		return;
	}
	
	if ( level.skipto_point == "sam" )
	{
		clientnotify( "set_sam_int_context" );
		return;
	}
	
	exploder( EXPLODER_FREEWAY_DESTRUCTION );
	
	skip_objective( level.OBJ_SHOOT_DRONES );
	
	if ( level.skipto_point == "cougar_fall" )
	{
		return;
	}
	
	if ( level.script == "la_1")
	{
		aerial_vehicles_no_target();
	}
	
	if ( level.skipto_point == "sniper_rappel" )
	{
		return;
	}
	
	if ( level.skipto_point == "sniper_exit" )
	{
		return;
	}
	
	flag_set( "started_rappelling" );
	flag_set( "done_rappelling" );
	flag_set( "player_approaches_convoy" );
	
	if ( level.skipto_point == "g20_group1" )
	{
		return;
	}
	
	skip_objective( level.OBJ_HIGHWAY );
	
	if ( level.skipto_point == "drive" )
	{
		return;
	}
	
	flag_set( "la_1_sky_transition" );
	
	if ( level.skipto_point == "skyline" )
	{
		return;
	}
	
	if ( level.skipto_point == "street" )
	{
		clientnotify( "set_silent_context" );
		return;
	}
	
	exploder( 56 );
	exploder( 57 );
	exploder( 58 );
	exploder( 59 );
	
	flag_set( "bdog_front_dead" );
	flag_set( "bdog_back_dead" );
	
	if ( level.skipto_point == "plaza" )
	{
		return;
	}
	
	flag_set( "plaza_vo_done" );
	
	if ( level.skipto_point == "intersection" )
	{
		return;
	}
	
	if ( level.skipto_point == "arena" )
	{
		return;
	}
	
	if ( level.skipto_point == "arena_exit" )
	{
		return;
	}
	
	// section 3 starts - flyable f35
	if ( level.skipto_point == "f35_wakeup" )
	{
		return;
	}
	
	level.player SetClientDvar( "cg_drawHUD", 1 );
	flag_set( "player_awake" );
	
	if ( level.skipto_point == "f35_boarding" )
	{
		return;
	}
	
	if ( level.skipto_point != "f35_outro" )
	{
		flag_set( "player_flying" );
	}

	
	flag_set( "player_in_f35" );
	//flag_set( "convoy_movement_started" );
	
	if ( level.skipto_point == "f35_flying" )
	{
		return;
	}
		
	flag_set( "tutorial_done" );
		
	if ( level.skipto_point == "f35_ground_targets" )
	{
		return;
	}
	
	flag_set( "convoy_at_ground_targets" );
	flag_set( "ground_targets_done" );
	
	if ( level.skipto_point == "f35_pacing" )
	{
		return;
	}

	flag_set( "player_passed_garage" );
	flag_set( "convoy_passed_roundabout" );
	flag_set( "roadblock_done" );
	
	if ( level.skipto_point == "f35_rooftops" )
	{
		return;
	}

	flag_set( "rooftops_done" );
	flag_set( "convoy_at_dogfight" );
	
	if ( level.skipto_point == "f35_dogfights" )
	{
		return;
	}
	
	flag_set( "dogfights_story_done" );
	flag_set( "dogfight_done" );
	
	if ( level.skipto_point == "f35_trenchrun" )
	{
		return;
	}
	
	flag_set( "trenchruns_start" );
	flag_set( "trenchrun_done" );

	if ( level.skipto_point == "f35_hotel" )
	{
		return;
	}
	
	flag_set( "hotel_done" );
	
	if ( level.skipto_point == "f35_eject" )
	{
		return;
	}
	
	flag_set( "eject_done" );
		
	if ( level.skipto_point == "f35_outro" )
	{
		return;
	}
}

load_gumps()
{
	screen_fade_out( 0 );
	
	if ( level.script == "la_1" )
	{
		if ( is_after_skipto( "g20_group1" ) )
		{
			load_gump( "la_1_gump_1d" );
		}
		else if ( is_after_skipto( "cougar_fall" ) )
		{
			load_gump( "la_1_gump_1c" );
		}
		else if ( is_after_skipto( "intro" ) )
		{
			load_gump( "la_1_gump_1b" );
		}
		else
		{
			load_gump( "la_1_gump_1a" );
		}
	}
	else if ( level.script == "la_1b" )
	{
		if ( is_after_skipto( "plaza" ) )
		{
			load_gump( "la_1b_gump_2" );
		}
		else
		{
			load_gump( "la_1b_gump_1" );
		}
	}
	
	screen_fade_in( 0 );
}

level_settings()
{
//	SetSavedDvar( "wind_global_vector", "300 200 0" );	// There shouldn't be any wind on Z
//    SetSavedDvar( "wind_global_low_altitude", 5000 );
//    SetSavedDvar( "wind_global_hi_altitude", 10000 );
//    SetSavedDvar( "wind_global_low_strength_percent", 0.7 );
}

///////////////////////////////////////////////////////////////////////////////////////////////
//	CHALLENGES	///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

setup_challenges()
{
	if ( level.script == "la_1" )
	{
		self thread maps\_challenges_sp::register_challenge( "turretdrones", ::challenge_turretdrones );
		self thread maps\_challenges_sp::register_challenge( "snipekills", ::challenge_snipekills );
	}
	else if ( level.script == "la_1b" )
	{
		self thread maps\_challenges_sp::register_challenge( "qrkills", ::challenge_qrkills );
		self thread maps\_challenges_sp::register_challenge( "roofdrones", ::challenge_roofdrones );
		self thread maps\_challenges_sp::register_challenge( "rescueagents", ::challenge_rescueagents );
		self thread maps\_challenges_sp::register_challenge( "rescuesecond", ::challenge_rescuesecond );
		self thread maps\_challenges_sp::register_challenge( "saveanderson", ::challenge_saveanderson );
	}
	else if ( level.script == "la_2" )
	{
		self thread maps\_challenges_sp::register_challenge( "nodeath", ::challenge_nodeath );
		self thread maps\_challenges_sp::register_challenge( "savecougars", ::challenge_savecougars );
		self thread maps\_challenges_sp::register_challenge( "locateintel", ::challenge_locate_intel );
	}
}

weapon_is_sniper_weapon( str_weapon )
{
	return ( WeaponIsSniperWeapon( str_weapon ) || IsSubStr( str_weapon, "metalstorm" ) );
}

/// LA_1 ///

challenge_snipekills( str_notify )
{
	level endon( "rappel_option" );
	flag_wait( "sniper_option" );
	
	add_global_spawn_function( "axis", ::challenge_snipekills_death_listener, str_notify );
	
	a_enemy_ai = GetAIArray( "axis" );
	array_thread( a_enemy_ai, ::challenge_snipekills_death_listener, str_notify );
	
	flag_wait( "done_rappelling" );
	
	remove_global_spawn_function( "axis", ::challenge_snipekills_death_listener );
}

challenge_snipekills_death_listener( str_notify )
{
	while ( IsAlive( self ) )
	{
//		self waittill( "damage", damage, e_attacker, direction, point, type, tagName, modelName, partname, str_weapon );
		self waittill( "death", e_attacker, str_mod, str_weapon, str_location );
		
		if ( IsDefined( str_weapon ) && IsPlayer( e_attacker ) && weapon_is_sniper_weapon( str_weapon ) )
		{
			if ( IsDefined( self.damagelocation ) && (self.damagelocation == "head" || self.damagelocation == "helmet" || self.damagelocation ==  "neck" ) )
			{
				level.player notify( str_notify );
			}
		}
	}
}

challenge_turretdrones( str_notify )
{
	trigger_wait( "sam_jump_trig" );
	
	flag_wait( "sam_success" );
	
	if ( level.n_sam_missiles_fired == level.num_planes_shot )
	{
		self notify( str_notify );
	}
}

/// LA_1b ///

challenge_roofdrones( str_notify )
{
	level endon( "intruder_sam_end" );
	
	flag_wait( "rooftop_sam_in" );
		
	while ( true ) // TODO: end the loop if we no longer want to track this challenge
	{
		level waittill( "rooftop_drone_killed" );
		self notify( str_notify );
	}
}

challenge_qrkills( str_notify )
{
	level.player waittill_player_has_intruder_perk();		
	add_global_spawn_function( "axis", ::challenge_qrkills_death_listener, str_notify );
}

challenge_qrkills_death_listener( str_notify )
{	
	self waittill( "death", e_attacker, b_damage_from_underneath, str_weapon );
	
	if ( IsDefined( e_attacker.targetname ) && e_attacker.targetname == "attackdrone" )
	{
		level.player notify( str_notify );
	}	
}

challenge_rescueagents( str_notify )
{
	level waittill( "brute_force_done" );
	self notify( str_notify );
}

challenge_rescuesecond( str_notify )
{
	flag_wait( "intersect_vip_cougar_saved" );
	self notify( str_notify );
}

challenge_saveanderson( str_notify )
{
	flag_wait( "la_arena_start" );
	
	n_time_limit = GetTime() + ( 4 * 60 * 1000 );	// 4 minutes
	
	flag_wait( "building_collapsing" );
	
	n_complete_time = GetTime();
	if( n_complete_time < n_time_limit )
	{
		flag_set( "anderson_saved" );
		self notify( str_notify );
	}
}

/// LA_2 ///

challenge_savecougars( str_notify )  // self = player
{
	flag_wait( "eject_done" );
	
	foreach ( vh in level.convoy.vehicles )
	{
		self notify( str_notify );
		wait 0.05;
	}
}

challenge_save_f35s( str_notify )
{
	while ( true )
	{
		level waittill( "player_saved_tracked_friendly_f35" );
		
		self notify( str_notify );
	}
}

challenge_nodeath( str_notify )
{
	flag_wait( "eject_done" );
	
	n_deaths = get_player_stat( "deaths" );
	
	if ( n_deaths == 0 )
	{
		self notify( str_notify );
	}
}

challenge_locate_intel( str_notify ) 
{
	flag_wait( "eject_done" );
	
	has_player_collected_all = collected_all();
	
	if( has_player_collected_all )
	{
		self notify( str_notify );		
	}	
}	


///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

player_has_sniper_weapon()
{
	a_current_weapons = level.player GetWeaponsList();
	
	foreach ( str_weapon in a_current_weapons )
	{
		if ( weapon_is_sniper_weapon( str_weapon ) )
		{
			return true;
		}
	}
	
	return false;
}

ai_group_get_num_killed( aigroup )
{
	return level._ai_group[ aigroup ].killed_count;
}

give_max_ammo_for_sniper_weapons()
{
	a_current_weapons = level.player GetWeaponsList();
	
	foreach ( str_weapon in a_current_weapons )
	{
		if ( weapon_is_sniper_weapon( str_weapon ) )
		{
			self SetWeaponAmmoClip( str_weapon, 1000 );
			self SetWeaponAmmoStock( str_weapon, 1000 );
		}
	}
}

waittill_player_has_sniper_weapon()
{
	while ( !self player_has_sniper_weapon() )
	{
		self waittill( "weapon_change" );
	}
}

switch_player_to_sniper_weapon()
{
	Assert( IsPlayer( self ), "switch_player_to_sniper_weapon not called on a player!" );
	
	a_current_weapons = self GetWeaponsList();
	
	b_gave_weapon = false;
	foreach ( str_weapon in a_current_weapons )
	{
		if ( weapon_is_sniper_weapon( str_weapon ) )
		{
			b_gave_weapon = true;
			level.player SwitchToWeapon( str_weapon );
			break;
		}
	}
	
	Assert( b_gave_weapon, "Tried to switch player to sniper weapon but player doesn't have sniper weapon." );
}

stick_player( b_look, n_clamp_right, n_clamp_left, n_clamp_top, n_clamp_bottom )
{
	if ( !IsDefined( b_look ) )
	{
		b_look = false;
	}
	
	self.m_link = Spawn( "script_model", self.origin );
	self.m_link.angles = self.angles;
	self.m_link SetModel( "tag_origin" );
	
	if ( b_look )
	{
		self PlayerLinkToDelta( self.m_link, "tag_origin", 1, n_clamp_right, n_clamp_left, n_clamp_top, n_clamp_bottom, true );
	}
	else
	{
		self PlayerLinkToAbsolute( self.m_link, "tag_origin" );
	}
}

unstick_player()
{
	if ( IsDefined( self.m_link ) )
	{
		self.m_link Delete();
	}
}

waittill_all_axis_are_dead()
{
	while ( GetAIArray( "axis" ).size > 0 )
	{
		wait .2;
	}
}

waittill_player_approaches_ai( ai_goal, n_radius )
{
	do
	{
		wait .05;
		
		v_eye = ai_goal get_eye();
		
		b_looking = self is_player_looking_at( v_eye );
		n_dist = Distance2dSquared( v_eye, self.origin );
	}
	while ( !b_looking || ( n_dist > n_radius * n_radius ) );
}

get_player_cougar()
{
	if ( !IsDefined( level.veh_player_cougar ) )
	{
		level.veh_player_cougar = get_specific_vehicle( "g20_group1_cougar" );
		level.veh_player_cougar thread player_cougar_init();
	}
	
	return level.veh_player_cougar;
}

player_cougar_init()
{
	self HidePart( "tag_windshield_d1" );
	self HidePart( "tag_windshield_d2" );
	self MakeVehicleUnusable();
}

f35_vtol_spawn_func()
{
	self thread fa38_hover();
	self thread fa38_fly();
	
	self notify( "fly" );
}

fa38_fly()
{
	self endon( "death" );
	
	while ( true )
	{
		self waittill( "fly" );
	
		if ( !IS_FALSE( self.hovering ) )
		{
			play_fx( "f35_exhaust_fly", undefined, undefined, "hover", true, "origin_animate_jnt" );
			
			self.hovering = false;
		}
	}
}

fa38_hover()
{
	self endon( "death" );
	
	while ( true )
	{
		self waittill( "hover" );
		
		if ( !IS_TRUE( self.hovering ) )
		{
			play_fx( "f35_exhaust_hover_rear", undefined, undefined, "fly", true, "tag_fx_nozzle_left_rear" );
			play_fx( "f35_exhaust_hover_rear", undefined, undefined, "fly", true, "tag_fx_nozzle_right_rear" );
			play_fx( "f35_exhaust_hover_front", undefined, undefined, "fly", true, "tag_fx_nozzle_left" );
			play_fx( "f35_exhaust_hover_front", undefined, undefined, "fly", true, "tag_fx_nozzle_right" );
			
			self.hovering = true;
		}
	}
}

get_f35_vtol()
{
	return get_specific_vehicle( "f35_vtol" );
}

get_specific_vehicle( targetname )
{
	veh = GetEnt( targetname, "targetname" );
	if ( !IsDefined( veh ) )
	{
		veh = spawn_vehicle_from_targetname( targetname );
	}
	
	return veh;
}

use_player_cougar()
{
	level.veh_player_cougar = get_player_cougar();
	level.veh_player_cougar godon();
	level.veh_player_cougar MakeVehicleUsable();
	level.veh_player_cougar UseVehicle( level.player, 0 );
	level.veh_player_cougar MakeVehicleUnusable();
	level.player EnableInvulnerability();
	
	level.player hide_hud();
	
	level.player AllowMelee( false );
	
	flag_set( "player_in_cougar" );
}

// runs a function on self after death
func_on_death( func_after_death )
{
	Assert( IsDefined( func_after_death ), "func_after_death is a required parameter for func_on_death" );
	
	self waittill( "death" );
	
	if ( IsDefined( self ) )
	{
		self [[ func_after_death ]]();
	}
}

/@
"Name: debug_hud_elem_add( <func_debug>, [str_custom_dvar] )"
"Summary: Adds a debug hud element that prints to the lower left corner of the screen when dvar 'show_debug_hud' is set to 1. Returns hud element. Supports custom dvars."
"Module: Debug"
"CallOn: N/A"
"MandatoryArg: <func_debug> function that sets the text of the debug hud element. Note this is threaded. All debug hud elems should set text with function 'debug_hud_elem_set_text' for full functionality"
"OptionalArg: [str_custom_dvar] if you want to use a special dvar instead of 'show_debug_hud', pass the name of it here"
"Example: F35_health_elem = debug_hud_elem_add( ::monitor_F35_health, "la_debug" );"
"SPMP: singleplayer"
@/
debug_hud_elem_add( func_debug, str_custom_dvar )
{
	Assert( IsDefined( func_debug ), "func_debug is a required parameter for debug_hud_elem_add" );
	
	if ( !IsDefined( level.debug_hud ) )
	{
		level.debug_hud = SpawnStruct();
	}
	
	if ( !IsDefined( level.debug_hud.elems ) )
	{
		level.debug_hud.elems = [];
	}
	
	level.debug_hud.scale_y = 15;
	n_scale = level.debug_hud.scale_y;
	hud_elem = NewHudElem();
	level.debug_hud.elems[ level.debug_hud.elems.size ] = hud_elem;
		
	// position on screen
	hud_elem.horzAlign = "left";
	hud_elem.vertAlign = "bottom";
	hud_elem.alignX = "left";
	hud_elem.alignY = "bottom";
	hud_elem.x = 0;
	hud_elem.y = ( level.debug_hud.elems.size * n_scale ) * ( -1 );  // move this up as list populates
	
	// font/color
	hud_elem.font = "objective";
	hud_elem.font_scale = 1;
	hud_elem.color = ( 0.0, 0.0, 1.0 );
	
	hud_elem thread _debug_hud_elem_should_show( str_custom_dvar );
	hud_elem thread _debug_hud_elem_func( func_debug );  // this is where text is set and manipulated
	
	return hud_elem;
}



/@
"Name: debug_hud_elem_set_text( <str_text> )"
"Summary: sets text of a debug hud element. This text will not be seen on-screen when the dvar isn't set."
"Module: Debug"
"CallOn: N/A"
"MandatoryArg: <str_text> text to show when the debug hud element dvar is set. By default this is 'show_debug_hud'"
"Example: debug_hud_elem_set_text( "F35 health: + n_health );"
"SPMP: singleplayer"
@/
debug_hud_elem_set_text( str_text )  // self = debug hud elem
{
	Assert( IsDefined( str_text ), "str_text is a required parameter for debug_hud_elem_set_text" );
	
	self.debug_text = str_text;
}


/@
"Name: debug_hud_elem_remove( <hud_elem> )"
"Summary: Removes a debug hud element and moves all other hud elements to lowest available positions. Will automatically kill debug_funcs passed to debug_hud_elem_add"
"Module: Debug"
"CallOn: N/A"
"MandatoryArg: <hud_elem> the hud element to remove"
"Example: debug_hud_elem_remove( F35_health_elem );"
"SPMP: singleplayer"
@/
debug_hud_elem_remove( hud_elem )
{
	Assert( IsDefined( hud_elem ), "hud_elem parameter is required for debug_hud_elem_remove!" );
	
	b_has_removed = false;
	
	for ( i = 0; i < level.debug_hud.elems.size; i++ )
	{
		
		if (level.debug_hud.elems[ i ] == hud_elem )
		{
			hud_to_remove = level.debug_hud.elems[ i ];
			hud_to_remove notify( "debug_hud_remove" );
			wait 0.05;
			hud_to_remove Destroy();
			b_has_removed = true;
			continue;
		}
		
		if ( b_has_removed )
		{
			// move following hud elements down one spot (populates upward, remember)
			n_index = i - 1;
			n_scale = level.debug_hud.scale_y;
			hud_current = level.debug_hud.elems[ i ];
			hud_current.y = ( n_index * n_scale ) * ( -1 );
		}
	}
	
	ArrayRemoveValue( level.debug_hud.elems, undefined );
}

 /*==============================================================
 SELF: debug hud element
 PURPOSE: adds endon to function so user doesn't need to worry about manual additions
 RETURNS: nothing
 CREATOR: TravisJ - 6/27/2011
 ===============================================================*/
 _debug_hud_elem_func( func_debug )
 {
 	self endon( "debug_hud_remove" );
 	
 	self [[ func_debug ]]();
 }

 /*==============================================================
 SELF: debug hud element
 PURPOSE: checks dvar determine if debug hud text should print or not
 RETURNS: nothing
 CREATOR: TravisJ - 6/27/2011
 ===============================================================*/
_debug_hud_elem_should_show( str_custom_dvar )
{
	self endon( "debug_hud_remove" );
	
	str_dvar = "show_debug_hud";
	
	if ( IsDefined( str_custom_dvar ) )
	{
		str_dvar = str_custom_dvar;
	}
	
	self.dvar_name = str_dvar;
	b_should_show_debug = false;
	
	while ( true )
	{
		if( IsDefined( GetDvar( str_dvar ) ) && ( GetDvar( str_dvar ) == "1" ) )
		{
			b_should_show_debug = true;
			
			if ( IsDefined( self.debug_text ) )
			{
				self SetText( self.debug_text );
			}
		}
		else
		{
			b_should_show_debug = false;
			self SetText( "" );
		}
		
		self.hud_should_show = b_should_show_debug;
		
		wait 0.5;
	}
}

press_x_to_continue()
{
	screen_message_create( "press x to continue" );
	level.player waittill_use_button_pressed();
	screen_message_delete();
}

la_1_vehicle_damage( e_inflictor, e_attacker, n_damage, n_flags, str_mod, str_weapon, v_point, v_dir, str_hitloc, psOffsetTime, b_underneath, n_model_index, str_part_name )
{
	if ( IS_4WHEEL( self ) )
	{
		if ( IsDefined( level.veh_player_cougar ) && ( self == level.veh_player_cougar ) )
		{
			return;
		}
		
		b_plane_weapon = IsDefined( e_attacker.vehicleclass ) && ( e_attacker.vehicleclass == "plane" );
		b_explosion = IsDefined( str_mod ) && ( ( str_mod == "MOD_EXPLOSIVE" ) || ( str_mod == "MOD_PROJECTILE" ) || ( str_mod == "MOD_UNKNOWN" ) );
		
		if ( b_explosion && b_plane_weapon )
		{
			vehicle_explosion_launch( v_point );
			self FinishVehicleDamage( e_inflictor, e_attacker, n_damage, n_flags, "MOD_UNKNOWN", str_weapon, v_point, v_dir, str_hitloc, psOffsetTime, b_underneath, n_model_index, str_part_name, false );
			return;
		}
	}
	
	maps\_callbackglobal::Callback_VehicleDamage( e_inflictor, e_attacker, n_damage, n_flags, str_mod, str_weapon, v_point, v_dir, str_hitloc, psOffsetTime, b_underneath, n_model_index, str_part_name );
}

la_1b_intersection_vehicle_damage( e_inflictor, e_attacker, n_damage, n_flags, str_mod, str_weapon, v_point, v_dir, str_hitloc, psOffsetTime, b_underneath, n_model_index, str_part_name )
{
	if ( IS_4WHEEL( self ) )
	{
		b_explosion = IsDefined( str_mod ) && ( ( str_mod == "MOD_EXPLOSIVE" ) || ( str_mod == "MOD_PROJECTILE" ) || ( str_mod == "MOD_UNKNOWN" ) );
		
		if ( b_explosion )
		{
			vehicle_explosion_launch( v_point );
			self FinishVehicleDamage( e_inflictor, e_attacker, n_damage, n_flags, "MOD_UNKNOWN", str_weapon, v_point, v_dir, str_hitloc, psOffsetTime, b_underneath, n_model_index, str_part_name, false );
			return;
		}
	}
	
	maps\_callbackglobal::Callback_VehicleDamage( e_inflictor, e_attacker, n_damage, n_flags, str_mod, str_weapon, v_point, v_dir, str_hitloc, psOffsetTime, b_underneath, n_model_index, str_part_name );
}

// physics launch logic from POW - thanks Gavin
vehicle_explosion_launch( v_hit_point, n_force )  // self = physics model or vehicle
{
	s_launch = get_launch_params_from_structs();
			
	if ( IsDefined( s_launch ) )
	{
		v_impact_point = s_launch.v_impact;
		v_world_force = s_launch.v_force;
	}
	else
	{
		v_impact_pos = v_hit_point;
		v_rocket_impact_point = v_hit_point;
		
		v_forward = AnglesToforward(self.angles);
	    v_right = AnglesToright(self.angles);
	    v_up = AnglesToright(self.angles);
	    
	    n_max_x = 500;
	    n_max_y = 400;
	    
	    /*
	    n_max_x = 300;
	    n_max_y = 200;
	    */
	    
	    //-- figure out where the rocket landed in relation to the truck
	    v_impact_pos = v_rocket_impact_point - self.origin;
	    n_dist_in_front = VectorDot(v_forward, v_impact_pos); //-- 208 either way
	    n_dist_to_v_right = VectorDot(v_right, v_impact_pos); //-- 128 either way
	    
	    if(abs(n_dist_in_front) > n_max_x || abs(n_dist_to_v_right) > n_max_y)
	    {
	        return false; //-- not close enough to cause this type of behavior
	    }
	        
	    str_impact_orient = "";
	    
	    if(abs(n_dist_in_front) < n_max_x * .25)
	    {
	        str_impact_orient = "mid_";
	    }
	    else if(n_dist_in_front < 0)
	    {
	        str_impact_orient = "rear_";
	    }
	    else
	    {
	        str_impact_orient = "front_";
	    }
	    
	    if( n_dist_to_v_right < 0 )
	    {
	        str_impact_orient = str_impact_orient + "left";
	    }
	    else
	    {
	        str_impact_orient = str_impact_orient + "v_right";
	    }
	        
	    //-- get the proper v_force data and impact point
	    v_impact_point = (0,0,0);
	    v_force = (0,0,0);
	        
	    switch( str_impact_orient )
	    {
	        case "mid_left":
	            v_impact_point = (28, -46, 50);
	            v_force = (0, 308, 30);
		        break;
	        
	        case "mid_v_right":
	            v_impact_point = (28, 42, 50);
	            v_force = (0, -340, 30);
		        break;
	        
	        case "front_left":
	            v_impact_point = (108, 2, 50);
	            v_force = (-16, 132, 126);
		        break;
	        
	        case "front_v_right":
	            v_impact_point = (108, 2, 50);
	            v_force = (-32, -132, 126);
		        break;
	        
	        case "rear_left":
	            v_impact_point = (-84, -22, 26);
	            v_force = (56, 180, 150);
		        break;
	        
	        case "rear_v_right":
	            v_impact_point = (-92, 18, 26);
	            v_force = (72, -148, 150);
		        break;
	    }
	    
	    //convert the v_force to worldspace
    	v_world_force = (v_forward * v_force[0]) + (v_right * v_force[1]) + (v_up * v_force[2]);
    	
    	if ( IsDefined( n_force ) )
    	{
    		v_world_force = VectorNormalize( v_world_force ) * n_force;
    	}
	}
	
    e_fx = spawn_model( "tag_origin", self.origin, self.angles );
	e_fx LinkTo( self );
	PlayFXOnTag( getfx( "vehicle_launch_trail" ), e_fx, "tag_origin" );
    
	/#
		level thread draw_line_for_time( v_impact_point, v_impact_point + v_world_force, 1, 0, 0, 2 );
	#/
	
    if ( self.classname == "script_vehicle" )
    {
    	self LaunchVehicle( v_world_force, v_impact_point );
    }
    else if (self.classname == "script_model" )
    {
    	self PhysicsLaunch( v_impact_point, v_world_force );
    }
    
    e_fx delay_thread( 4, ::self_delete );
}

get_launch_params_from_structs()
{
	if ( IsDefined( self.target ) )
	{
		s_start = get_struct( self.target );
		
		if ( IsDefined( s_start ) )
		{
			s_end = get_struct( s_start.target );
			
			Assert( IsDefined( s_end ) );
			
			v_start = s_start.origin;
			v_end = s_end.origin;
				
			v_dir = v_end - v_start;
			
			a_trace = BulletTrace( v_start, v_end, false, undefined );
			v_hit_pos = a_trace[ "position" ];
			
			n_intensity = 200;
			if ( IsDefined( s_start.script_float ) )
			{
				n_intensity = s_start.script_float;
			}
			
			s_return = SpawnStruct();
			s_return.v_impact = v_hit_pos;
			s_return.v_force = VectorNormalize( v_dir ) * n_intensity;
		    
		    return s_return;
		}
	}
}

_av_out_of_world()
{
	self endon( "death" );
	
	while ( true )
	{
		if ( self.origin[ 2 ] < -30000 )
		{
			self notify( "crash_move_done" );
	
			if ( IS_TRUE( self.deleted ) )
			{
				self Delete();
			}
			else
			{
				VEHICLE_DELETE( self );
			}
		}
		
		wait 0.05;
	}
}

/*
fxanim_aerial_vehicles( n_fxanim_av_max )
{
	level notify( "fxanim_aerial_vehicles" );
	level endon( "fxanim_aerial_vehicles" );
	
	if ( !IsDefined( level.n_av_models ) )
	{
		level.n_av_models = 0;
	}
	
	n_player_fov = GetDvarFloat( "cg_fov" );
	n_cos_player_fov = cos( n_player_fov );
	
	if ( !IsDefined( level.fxanim_fly_zone ) )
	{
		level.fxanim_fly_zone = SpawnStruct();
	}
	
	s_fly_zone = level.fxanim_fly_zone;
	a_bb_ambient_anims = [];
	a_f35_ambient_anims = [];
	
	s_bb_ambient_1 = _create_fxanim_ambient_info( "drone_ambient_1", 10 );
	ARRAY_ADD( a_bb_ambient_anims, s_bb_ambient_1 );
	
	s_bb_ambient_2 = _create_fxanim_ambient_info( "drone_ambient_2", 15 );
	ARRAY_ADD( a_bb_ambient_anims, s_bb_ambient_2 );
	
	s_f35_ambient_1 = _create_fxanim_ambient_info( "f35_ambient_1", 10 );
	ARRAY_ADD( a_f35_ambient_anims, s_f35_ambient_1 );
	
	s_f35_ambient_2 = _create_fxanim_ambient_info( "f35_ambient_2", 15 );
	ARRAY_ADD( a_f35_ambient_anims, s_f35_ambient_2 );
	
	level.is_player_in_sam = false;
	
	while ( true )
	{
		if ( level.n_av_models < n_fxanim_av_max && !level.is_player_in_sam )
		{
			s_fly_zone update_fly_zone( 6000, 12000 );
	
			v_av_origin = ( RandomIntRange( s_fly_zone.n_x_min, s_fly_zone.n_x_max ), RandomIntRange( s_fly_zone.n_y_min, s_fly_zone.n_y_max ), RandomIntRange( s_fly_zone.n_z_min, s_fly_zone.n_z_max ) );
			while ( within_fov( level.player.origin, level.player.angles, v_av_origin, n_cos_player_fov ) )
			{
				wait 0.05;
				
				v_av_origin = ( RandomIntRange( s_fly_zone.n_x_min, s_fly_zone.n_x_max ), RandomIntRange( s_fly_zone.n_y_min, s_fly_zone.n_y_max ), RandomIntRange( s_fly_zone.n_z_min, s_fly_zone.n_z_max ) );
			}
			
			v_av_angles = ( 0, RandomIntRange( 0, 360 ), 0 );
			
			n_random_anim = RandomInt( 2 );
			//s_bb_ambient = random( a_bb_ambient_anims );
			s_bb_ambient = a_bb_ambient_anims[ n_random_anim ];
			str_ambient_anim = s_bb_ambient.str_ambient_anim;
		
			n_random_drone = RandomIntRange( 1, 3 );
			m_aerial_vehicle = spawn_anim_model( "fxanim_ambient_drone_" + n_random_drone, v_av_origin, v_av_angles );
//			m_aerial_vehicle = spawn_anim_model( "fxanim_ambient_drone_1", v_av_origin, v_av_angles );
			m_aerial_vehicle SetForceNoCull();
			m_aerial_vehicle.targetname = "fxanim_ambient_drone";
			m_aerial_vehicle.script_recordent = false;
	
			level thread anim_loop( m_aerial_vehicle, str_ambient_anim );
	
			m_aerial_vehicle thread _remove_fxanim_av( n_cos_player_fov, s_bb_ambient.n_seconds );
			
			level.n_av_models++;
			
			if ( RandomInt( 2 ) == 1 )
			{
				a_f35_ambient_anims thread _fxanim_aerial_f35( v_av_origin, v_av_angles, n_random_anim, m_aerial_vehicle, n_cos_player_fov );
			}
		}
		
		wait 0.05;
	}
}

_fxanim_aerial_f35( v_av_origin, v_av_angles, n_random_anim, m_drone, n_cos_player_fov )
{
	wait 0.4;
	
	can_player_see_f35 = within_fov( level.player.origin, level.player.angles, v_av_origin, n_cos_player_fov );
	if ( !can_player_see_f35 )
	{
		s_f35_ambient = self[ n_random_anim ];
		str_ambient_anim = s_f35_ambient.str_ambient_anim;
		
		m_f35 = spawn_anim_model( "fxanim_ambient_f35", v_av_origin, v_av_angles );
		m_f35 SetForceNoCull();
		m_f35.targetname = "fxanim_ambient_drone";
		m_f35.script_recordent = false;
		
		level thread anim_loop( m_f35, str_ambient_anim );
		
		//m_f35 thread _fxanim_shoot( m_drone );
		m_f35 thread _remove_fxanim_av( n_cos_player_fov, s_f35_ambient.n_seconds );
		
		level.n_av_models++;
	}
}

_fxanim_shoot( m_drone )
{
	self endon( "death" );
	
	while ( true )
	{
		//v_missile_org = self GetTagOrigin( "tag_turret" );
		v_gunner_org_1 = self GetTagOrigin( "tag_flash_gunner1" );
		v_gunner_org_2 = self GetTagOrigin( "tag_flash_gunner2" );
		
		if ( IsDefined( m_drone ) )
		{
			//MagicBullet( "f35_missile_turret", v_missile_org, m_drone.origin );
			MagicBullet( "f35_side_minigun", v_gunner_org_1, m_drone.origin );
			MagicBullet( "f35_side_minigun", v_gunner_org_2, m_drone.origin );
		}
		
		wait 0.24;
	}
}

_create_fxanim_ambient_info( str_ambient_anim, n_seconds )
{
	s_bb_ambient = SpawnStruct();
	s_bb_ambient.str_ambient_anim = str_ambient_anim;
	s_bb_ambient.n_seconds = n_seconds;
	
	return s_bb_ambient;
}

_remove_fxanim_av( n_cos_player_fov, n_seconds )
{
	self endon( "death" );
	
	wait n_seconds;
	
	while ( within_fov( level.player.origin, level.player.angles, self.origin, n_cos_player_fov ) )
	{
		wait 1;
	}
	
	level.n_av_models--;
	
	self Delete();
}
*/

aerial_vehicles_no_target()
{
	level.aerial_vehicles_no_target = true;
	
	a_veh = get_vehicle_array();
	foreach ( veh in a_veh )
	{
		if ( Target_IsTarget( veh ) )
		{
			Target_Remove( veh );
		}
	}
}

fade_with_shellshock_and_visionset()
{
	current_vision_set = level.player GetVisionSetNaked();
	if ( current_vision_set == "" )
	{
		current_vision_set = "default";
	}
	level thread maps\_shellshock::main( level.player.origin, 15, 256, 0, 0, 0, undefined, "la_1_crash_exit", 0 );
	VisionSetNaked( "sp_la_1_crash_exit" );
		
	wait 5;
		
	screen_fade_in( 0 );
		
	VisionSetNaked( current_vision_set, 25);
}

veh_brake_unload()
{
	self endon( "death" );
	
	self playsound( "evt_truck_incoming" );
	
	self waittill( "brake" );
	
	self playsound( "evt_truck_stop" );
	
	while ( self GetSpeedMPH() > 2 )
	{
		wait .1;
	}
	
	self notify( "unload" );
}

/@
"Name: func_on_notify( <str_notify>, <func>, [param_1], [param_2], [param_3], [param_4], [param_5] )"
"Summary: self waits for a notify, then runs a function with up to five optional input arguments."
"Module: Utility"
"CallOn: Anything. Entities, vehicles, level, etc."
"MandatoryArg: <str_notify> : notify that self will wait for"
"MandatoryArg: <func> : pointer to a script function"
"OptionalArg: [param_1] : parameter 1 to pass to the func"
"OptionalArg: [param_2] : parameter 2 to pass to the func"
"OptionalArg: [param_3] : parameter 3 to pass to the func"
"OptionalArg: [param_4] : parameter 4 to pass to the func"
"OptionalArg: [param_5] : parameter 5 to pass to the func"
"Example: vh_van thread func_on_notify( "break_formation", ::roadblock_behavior );"
"SPMP: SP"
@/
func_on_notify( str_notify, func, param_1, param_2, param_3, param_4, param_5 )
{
	Assert( IsDefined( str_notify ), "str_notify is a required parameter for func_on_notify" );
	Assert( IsDefined( func ), "func is a required parameter for func_on_notify" );
	
	self thread _func_on_notify( str_notify, func, param_1, param_2, param_3, param_4, param_5 );
}

_func_on_notify( str_notify, func, param_1, param_2, param_3, param_4, param_5 )
{
	self endon( "death" );
	self waittill( str_notify );
	single_thread( self, func, param_1, param_2, param_3, param_4, param_5 );
}

get_forward( b_flat, str_tag )
{
	if ( !IsDefined( b_flat ) )
	{
		b_flat = false;
	}
	
	if ( IsPlayer( self ) )
	{
		v_angles = level.player GetPlayerAngles();
	}
	else
	{
		if ( IsDefined( str_tag ) )
		{
			v_angles = self GetTagAngles( str_tag );
		}
		else
		{
			v_angles = self.angles;
		}
	}
	
	if ( b_flat )
	{
		v_angles = FLAT_ANGLES( v_angles );
	}
	
	v_forward = AnglesToForward( v_angles );
	return v_forward;
}

/@
"Name: delete_ents( <str_name>, [str_key] )"
"Summary: Deletes entities and ingores if they don't exist."
"Module: Utility"
"CallOn: level"
"MandatoryArg: <str_name> : identifier of entity."
"OptionalArg: [str_key] : the key of the specified id. defaults to targetname."
"Example: delete_ents( "event3_ents", "script_noteworthy" );"
"SPMP: SP"
@/
delete_ents( str_name, str_key )
{
	Assert( IsDefined( str_name ), "str_name is a required argument for delete_ents()" );
	
	if ( !IsDefined( str_key ) )
	{
		str_key = "targetname";
	}
	
	array_func( GetEntArray( str_name, str_key ), ::self_delete );
}

delete_vehicle_on_flag( str_flag )
{
	self endon( "death" );
	flag_wait( "str_flag" );
	VEHICLE_DELETE( self );
}

// get the local coordinates to a common volume between LA_1 and LA_2, which is centered at the F35
get_relative_position_string( e_ent )
{
	v_local = e_ent WorldToLocalCoords( self.origin );
	str_local_coordinates = ( v_local[ 0 ] + " " + v_local[ 1 ] + " " + v_local[ 2 ] );	
	return str_local_coordinates;
}

cleanup( ent )
{
	if ( IsDefined( ent ) )
	{
		ent Delete();
	}
}

cleanup_array( a_ents )
{
	array_delete( a_ents );
}

cleanup_kvp( str_value, str_key = "targetname" )
{
	a_ents = GetEntArray( str_value, str_key );
	cleanup_array( a_ents );
}

set_goal_to_current_pos()
{
	self SetGoalPos( self.origin );
}

police_car()
{
	self endon( "death" );
	wait RandomFloatRange( .05, 1 );
	self thread police_car_audio();
	//play_fx( "siren_light", undefined, undefined, "death", true, "tag_fx_siren_lights" );
	play_fx( "siren_light", undefined, undefined, "death", true, "tag_body" );
}

police_car_audio()
{
	sound_ent = spawn( "script_origin" , self.origin);
	sound_ent playloopsound( "amb_radio_chatter_loop" ,  .5 );
	self waittill( "death" );
	sound_ent delete();
}

police_motorcycle()
{
	self endon( "death" );
	wait RandomFloatRange( .05, 1 );
	play_fx( "siren_light_bike", undefined, undefined, "death", true, "tag_fx_lights_front" );
}

is_police_car( ent )
{
	if ( IsDefined( ent.model ) )
	{
		if ( ent.model == "veh_t6_police_car"
		    || ent.model == "veh_t6_police_car_low"
		    || ent.model == "veh_t6_police_car_static" )
		{
			return true;
		}
	}
	
	return false;
}

is_police_motorcycle( ent )
{
	if ( IsDefined( ent.model ) )
	{
		if ( ent.model == "veh_t6_civ_police_motorcycle" )
		{
			return true;
		}
	}
	
	return false;
}

is_suv( ent )
{
	return ( IsDefined( ent.model ) && IsSubStr( ent.model, "veh_iw_civ_suv" ) );
}

waittill_not_god_mode()
{
	while ( IsGodMode( self ) )
	{
		wait .05;
	}
}

new_timer()
{
	s_timer = SpawnStruct();
	s_timer.n_time_created = GetTime();
	return s_timer;
}

get_time()
{
	t_now = GetTime();
	return t_now - self.n_time_created;
}

get_time_in_seconds()
{
	return get_time() / 1000;
}


/@
"Name: add_scripted_damage_state( <n_percentage_to_change_state>, <func_on_state_change> )"
"Summary: Adds a custom damage state to an entity, such as a vehicle. To add several states, just call this function multiple times. Also supports custom health values (.armor)."
"Module: level"
"CallOn: Any entity that can take damage. Use as a spawn function."
"MandatoryArg: <n_percentage_to_change_state>: Percentage health to change state and run func_on_state_change. Should be between 0 and 1."
"MandatoryArg: <func_on_state_change>: function pointer that points to a function to run when state changes. For instance, it could play a sound and FX."
"Example: vh_presidents_vehicle add_scripted_damage_state( 0.25, ::play_low_health_fx );"
"SPMP: singleplayer"
@/
add_scripted_damage_state( n_percentage_to_change_state, func_on_state_change )  // self = entity that can receive the 'damage' notify
{
	Assert( IsDefined( n_percentage_to_change_state ), "n_percentage_to_change_state is a required argument for add_scripted_damage_state!" );
	Assert( ( ( n_percentage_to_change_state > 0 ) && ( n_percentage_to_change_state < 1 ) ), "add_scripted_damage_state was passed an invalue percentage to change state. Passed " + n_percentage_to_change_state + ", but valid range is between 0 and 1." );
	Assert( IsDefined( func_on_state_change ), "func_on_state_change is a required argument for add_scripted_damage_state!" );
	Assert( ( IsDefined( self.health ) || IsDefined( self.armor ) ), "no .health or .armor parameter found on entitiy" + self GetEntityNumber() + " at position " + self.origin );

	// use .health if no .armor value is used
	b_use_custom_health = IsDefined( self.armor );
	
	n_health_max = self.health;
	
	if ( b_use_custom_health )
	{
		n_health_max = self.armor;
	}
	
	b_state_changed = false;
	n_damage_to_change_state = n_health_max * n_percentage_to_change_state;
	
	while ( !b_state_changed )
	{
		self waittill( "damage", n_damage );
		
		n_current_health = self.health;
		
		if ( b_use_custom_health )
		{
			n_current_health = self.armor;
		}
		
		if ( n_current_health < n_damage_to_change_state )
		{
			b_state_changed = true;
		}
	}
	
	self [[ func_on_state_change ]]();
}

// checks dvar to see if this is a green light build. to skip, put '+set skip_greenlight_build 1' in remote console
is_greenlight_build()
{
	b_is_greenlight_build = false;
	
	if ( GetDvar( "skip_greenlight_build" ) != "" && GetDvarInt( "skip_greenlight_build" ) == 0 )
	{
		b_is_greenlight_build = true;
	}
	
	return b_is_greenlight_build;
}

spawn_sam_drone_group( str_spawner_name, n_count, angle_offset, override_start_angles )
{
//	if ( IsDefined( level.n_drone_wave ) && level.n_drone_wave == 1 )
//	{
		// need a consistant angle to start with
		//s_wave_1_lookat = getstruct( "wave_1_lookat_angle", "targetname" );
		//v_player_angles = s_wave_1_lookat.angles;
//	}
//	else
//	{
		v_player_angles = level.player.angles; 
		///level.sam_cougar GetTagAngles( "tag_gunner_barrel2" );
//	}
		
	if ( IsDefined( override_start_angles ) )
	{
		v_player_angles = override_start_angles;
	}

	n_spawn_yaw = AbsAngleClamp360( v_player_angles[1] + angle_offset );
	//n_spawn_yaw = clamp( n_spawn_yaw, DRONE_SPAWN_ANGLE_MIN, DRONE_SPAWN_ANGLE_MAX );
	
	//level thread sam_wave_vo( v_player_angles[1], n_spawn_yaw );
	
	v_spawn_vector_dir = -1; // need a consistant spawn vector direction
	if( angle_offset < 180 )
	{
		v_spawn_vector_dir = 1;
	}
			
	a_spawned_drones = [];
	
	for ( i = 0; i < n_count; i++ )
	{
//		n_spawn_yaw = clamp( n_spawn_yaw + RandomIntRange( -1, 1 ), DRONE_SPAWN_ANGLE_MIN, DRONE_SPAWN_ANGLE_MAX );
		
		v_spawn_org = level.player.origin + AnglesToForward( (0, n_spawn_yaw, 0) ) * DRONE_GROUP_SPAWN_DIST;
		v_spawn_org = (v_spawn_org[0], v_spawn_org[1], DRONE_GROUP_SPAWN_HEIGHT + RandomInt( 2000 ));
			
		veh_drone = spawn_vehicle_from_targetname( str_spawner_name );
		veh_drone SetModel( "veh_t6_drone_avenger_x2" );
		veh_drone.origin = v_spawn_org;
		
		v_spawn_vector = AnglesToRight( (0, n_spawn_yaw, 0) ) * v_spawn_vector_dir;
		veh_drone.v_spawn_vector = v_spawn_org + v_spawn_vector * DRONE_SPAWN_GOAL_DIST;
		
		v_start_angles = VectorToAngles( veh_drone.v_spawn_vector - veh_drone.origin );
		veh_drone SetPhysAngles( v_start_angles );
		
		veh_drone.v_escape_vector = v_spawn_org;
		 
		veh_drone thread sam_drone();
		
		ARRAY_ADD( a_spawned_drones, veh_drone );
	}
	
	return a_spawned_drones;
}

sam_drone()
{
	self SetDefaultPitch( 10 );
	self SetForceNoCull();
	self SetNearGoalNotifyDist( 500 );
	self ent_flag_init( "straffing" );
	
	Target_Set( self );
	
	self thread sam_drone_death();
	self thread strafe_player( true, level.sam_cougar, "tag_gunner_barrel2" );
	
	self thread fall_out_of_world();
	
	/#
	//self thread death_cheat();
	#/
}

sam_drone_death()
{
	level endon( "sam_success" );
	
	if ( !IsDefined( level.num_planes ) )
	{
		level.num_planes = 0;
	}
		
	level.num_planes++;
	
	self waittill( "death" );
	
	Target_Remove( self );
	
	if ( IsDefined( self ) && self.health <= 0 )
	{
		PlayFx( level._effect[ "sam_drone_explode" ], self.origin, (0, 0, 1), AnglesToForward( self.angles ) );
		
		n_dist = Distance2D( self.origin, level.player.origin );
		n_quake_scale = clamp( 1.0 - ( n_dist / DRONE_DEATH_QUAKE_SCALE_MAX_DIST ), 0.25, 1.0 );
		n_quake_time = clamp( 1.0 - ( n_dist / DRONE_DEATH_QUAKE_SCALE_MAX_DIST ), DRONE_DEATH_QUAKE_MIN_TIME, DRONE_DEATH_QUAKE_MAX_TIME );
		
		playsoundatposition ("evt_turret_shake", (0,0,0));
		Earthquake( n_quake_scale, n_quake_time, level.player.origin, 1024, level.player );
	}
	
	if ( IsDefined( level.num_planes ) )
	{
		level.num_planes--;
	}
	
	if ( !IsDefined( level.num_planes_shot ) )
	{
		level.num_planes_shot = 0;
	}
	
//	if ( ( DRONE_NUM_SUCCESS - level.num_planes_shot ) <= 2 )
//	{
//		flag_set( "start_sam_end_vo" );
//	}
	
	level.num_planes_shot++;
	level notify( "sam_hint_drone_killed" );
	
	n_drones_count = get_vehicle_array( "ambient_drone", "targetname" ).size;
	if ( level.num_planes_shot >= DRONE_NUM_SUCCESS )
	{
		level delay_thread( 1, ::flag_set, "sam_success" );
	}

	self waittill( "crash_move_done" );
	
	if ( IsDefined( self ) && self.health > 0 )
		return;
	
	if ( IsDefined( self ) )
	{
		PlayFx( level._effect[ "sam_drone_explode" ], self.origin, (0, 0, 1), AnglesToForward( self.angles ) );
		
		n_dist = Distance2D( self.origin, level.player.origin );
		n_quake_scale = clamp( 1.0 - ( n_dist / DRONE_DEATH_QUAKE_SCALE_MAX_DIST ), 0.25, 1.0 );
		n_quake_time = clamp( 1.0 - ( n_dist / DRONE_DEATH_QUAKE_SCALE_MAX_DIST ), DRONE_DEATH_QUAKE_MIN_TIME, DRONE_DEATH_QUAKE_MAX_TIME );
		
		playsoundatposition ("evt_turret_shake", (0,0,0));
		Earthquake( n_quake_scale, n_quake_time, level.player.origin, 1024, level.player );
	}
}

strafe_player( b_missiles, e_target, e_target_tag )
{
	self endon( "death" );
	
	level endon( "sam_cougar_mount_started" );
	
	self notify( "_strafe_player_" );
	self endon( "_strafe_player_" );
	
	if ( !IsDefined( e_target ) )
	{
		e_target = level.player;
	}
	
	if ( !IsDefined( b_missiles ) )
	{
		b_missiles = false;
	}
	
	self ent_flag_set( "straffing" );
	
	while ( 1 )
	{
	
		//v_forward = VectorNormalize( ); //e_target get_forward( true, e_target_tag );
		//v_goal = e_target.origin + v_forward * 10000 + ( 0, 0, 2000 );
		
		v_goal = ( IsDefined( self.v_spawn_vector ) ? self.v_spawn_vector : e_target.origin );
		v_goal += ( RandomIntRange( -5000, 5000 ), RandomIntRange( -5000, 5000 ), RandomIntRange( -5000, 5000 ) );
		
		/#
			self thread debug_goal( v_goal );
		#/
		
		self SetVehGoalPos( v_goal, 0 );
		
		if ( IsDefined( level.n_drone_wave ) && level.n_drone_wave != 2 )
		{
			self thread drone_speed_manager();
		}
		else
		{
			self SetSpeed( DRONE_SPEED_MAX - 300, 1000, 1000 );
		}
		
		self waittill( "near_goal" );
			
		if ( IsDefined( level.n_drone_wave ) && level.n_drone_wave == 2 )
		{
			v_forward = VectorNormalize( e_target.origin - self.origin );
			v_right = VectorCross( v_forward, ( 0, 0, 1 ) );
			v_goal = e_target.origin - v_right * RandomIntRange( 8000, 10000 ) + ( 0, 0, RandomIntRange( 1500, 2500 ) );
		}
		else
		{
			n_height = ( IsDefined( self.n_strafe_height_offset ) ? self.n_strafe_height_offset : 1000 );
			v_goal = e_target.origin + ( RandomIntRange( -500, 500 ), RandomIntRange( -500, 500 ), n_height + RandomIntRange( 0, 500 ) );
		}
		
		/#
			self thread debug_goal( v_goal );
		#/
			
		self thread strafe_player_plane_fire_guns( ( RandomIntRange( 0, 100 ) < 25 ? false : b_missiles ) );
		
		self SetVehGoalPos( v_goal, 0 );
			
		self waittill( "near_goal" );
		self notify( "kill_speed_manager" );
		self SetSpeed( DRONE_SPEED_MAX, 1000, 1000 );
		
		v_goal = ( IsDefined( self.v_escape_vector ) ? self.v_escape_vector : undefined );
		if ( IsDefined( v_goal ) )
		{
			self SetVehGoalPos( v_goal, 0 );
			
			self waittill( "near_goal" );
			
			//VEHICLE_DELETE( self );
		}
	}
	
	self ent_flag_clear( "straffing" );
}

/#
debug_goal( v_goal )
{
	self endon( "goal" );
	self endon( "near_goal" );
	
	while ( true )
	{
		DebugStar( v_goal, 1, ( 1, 0, 0 ) );
		wait .05;
	}
}
#/

strafe_player_plane_fire_guns( b_missles )
{
	self endon( "death" );
	self endon( "_strafe_player_" );
	
	level endon( "sam_cougar_mount_started" );
	
	if ( !IsDefined( b_missles ) )
	{
		b_missles = true;
	}

	wait( RandomFloatRange( 1, 2 ) );
	
	if ( self.health > 0 )
	{
		self set_turret_target( level.player, ( RandomIntRange( -100, 100 ), RandomIntRange( -100, 100 ), 0 ), 0 );
		self thread fire_turret_for_time( 7, 0 );
		
		if ( b_missles )
		{
			wait( RandomFloatRange( 1, 2 ) );
			
			level notify( "drone_wave_" + level.n_drone_wave );
			
			yaw = AngleClamp180( VectorToAngles( VectorNormalize( self.origin - level.player.origin ) )[1] );
			yaw += RandomIntRange( -3, 3 );
			
			shoot_point = level.player.origin + AnglesToForward( ( 0, yaw, 0 ) ) * RandomIntRange( 200, 500 );
			self SetTargetOrigin( shoot_point, 0 );
			self FireGunnerWeapon( 0 );
			
			//self thread shoot_turret_at_target( level.player, 1, ( RandomIntRange( -128, 128 ), RandomIntRange( -128, 128 ), 50 ), 1 );
			//self thread shoot_turret_at_target( level.player, 1, ( shoot_point[0], shoot_point[1], 50 ), 1 );
			//self thread shoot_turret_at_target( level.player, 1, ( 0, 0, 50 ), 2 );
		}
	}
}

drone_speed_manager()
{
	self endon( "death" );
	self endon( "kill_speed_manager" );
	
	while ( true )
	{
		//n_dist = Distance( self.origin, level.player.origin );
		//n_dist_to_sweet_spot = abs( n_dist - DRONE_SWEET_SPOT_DIST );
		//n_speed = linear_map( n_dist_to_sweet_spot, 0, DRONE_MAX_DIST_TO_SWEET_SPOT, DRONE_SPEED_MIN, DRONE_SPEED_MAX );
		//lerp_vehicle_speed( n_speed, .5 );
		//self SetSpeed( n_speed, 1000 );
		//wait ( 0.05 );
		
		n_dist = Distance( self.origin, level.player.origin );
		
		if ( n_dist > DRONE_SWEET_SPOT_DIST )
		{
			n_dist_normalized = Min( n_dist / DRONE_SPAWN_GOAL_DIST, 1.0 );
			n_speed = LerpFloat( DRONE_SPEED_MIN, DRONE_SPEED_MAX, n_dist_normalized );
			self SetSpeed( n_speed, 1000 );
		}
		else
		{
			self SetSpeed( DRONE_SPEED_MIN, 1000, 1000 );
		}
		
		wait( 0.05 );
	}
}

sam_visionset()
{
	self endon( "death" );
	
	while ( true ) 
	{
		self waittill( "missileTurret_on" );
		ClientNotify( "sam_on" );
		
		battlechatter_off( "allies" );
		battlechatter_off( "axis" );
		
		visionset = self GetVisionSetNaked();
		self VisionSetNaked( "sam_turret", 0.5 );
		
		cin_id = Start3DCinematic( "sam_gizmos_v2", true, false );
		
		//level thread sam_hint();
		
		self waittill( "missileTurret_off" );
		ClientNotify( "sam_off" );
		
		Stop3DCinematic( cin_id );
		
		battlechatter_on( "allies" );
		battlechatter_on( "axis" );
		
		self VisionSetNaked( visionset, 0 );
	}
}

sam_hint()
{
	level endon( "sam_event_done" );
	
	screen_message_create( &"LA_1_SAM_HINT_ADS", &"LA_1_SAM_HINT_FIRE" );
	
	level waittill( "sam_hint_drone_killed" );
	
	screen_message_delete();
}

sam_cougar_player_damage_watcher()
{
	self endon( "death" );
	self endon( "exit_vehicle" );
	
	while ( 1 )
	{
		self waittill( "damage",  damage, attacker, direction, point, type, tagName, modelName, partname, weaponName );
		
		self ClearDamageIndicator();
		playsoundatposition ("evt_turret_shake", (0,0,0));		
	}
}


scale_model_LODs( n_lod_scale_rigid, n_lod_scale_skinned )
{
	Assert( IsDefined( n_lod_scale_rigid ), "n_lod_scale_rigid is a required parameter for scale_model_LODs!" );
	Assert( IsDefined( n_lod_scale_skinned ), "n_lod_scale_skinned is a required parameter for scale_model_LODs!" );
	
	level.player SetClientDvar( "r_lodScaleRigid", n_lod_scale_rigid );
	level.player SetClientDvar( "r_lodScaleSkinned", n_lod_scale_skinned );
}

vtol_hover_notetrack( veh_vtol )
{
	veh_vtol notify( "hover" );
}

vtol_fly_notetrack( veh_vtol )
{
	veh_vtol notify( "fly" );
}

dont_free_vehicle()
{
	self.dontfreeme = true;
}

manage_vehicle_turret()
{
	self endon( "death" );
	 
	//set_turret_burst_parameters( .5, 2, .5, 1, 1 );
	
	flag_wait( "player_in_cougar" );
	
	set_turret_ignore_line_of_sight( true, 1 );
	//set_turret_target_ent_array( array( level.veh_player_cougar ), 1 );
}

/#
debug_timer()
{
	hud_debug_timer = get_debug_timer();
	hud_debug_timer SetTimerUp( 0 );
}

get_debug_timer()
{
	if ( IsDefined( level.hud_debug_timer ) )
	{
		level.hud_debug_timer Destroy();
	}
	
	level.hud_debug_timer = NewHudElem();
	level.hud_debug_timer.alignX = "left";
	level.hud_debug_timer.alignY = "bottom";
	level.hud_debug_timer.horzAlign = "left";
    level.hud_debug_timer.vertAlign = "bottom";
    level.hud_debug_timer.x = 0;
    level.hud_debug_timer.y = 0;
  	level.hud_debug_timer.fontScale = 1.0;
	level.hud_debug_timer.color = (0.8, 1.0, 0.8);
	level.hud_debug_timer.font = "objective";
	level.hud_debug_timer.glowColor = (0.3, 0.6, 0.3);
	level.hud_debug_timer.glowAlpha = 1;
 	level.hud_debug_timer.foreground = 1;
 	level.hud_debug_timer.hidewheninmenu = true;
	return level.hud_debug_timer;
}
#/

delete_when_not_looking_at()
{
	self endon( "death" );
	
	while ( level.player is_player_looking_at( self.origin, .67, false ) || self.drivebysoundtime0 > 0 || self.drivebysoundtime1 > 0 )
	{
		//Print3d( self.origin, "Time 0: " + self.drivebysoundtime0 + " Time 1: " + self.drivebysoundtime1, ( 1, 1, 1 ), 1, 10, 5 );
		wait .2;
	}

	if ( IS_VEHICLE( self ) )
	{
		VEHICLE_DELETE( self );
	}
	else
	{
		self Delete();
	}
}

delete_on_goal()
{
	self endon( "death" );
	self waittill( "goal" );
	self Delete();
}

trigger_timeout( n_time, str_value, str_key, ent )
{
	if( !IsDefined( str_key ) )
    {
        str_key = "targetname";
    }
	
	if( !IsDefined( ent ) )
	{
		ent = get_players()[0];
	}

	trig = GetEnt( str_value, str_key ); 
	if( IsDefined( trig ) )
	{
		trig endon( "death" );
		trig endon( "trigger" );
		
		wait n_time;
		
		trig UseBy( ent );
		level notify( str_value, ent );
	}
}

spawn_func_scripted_flyby()
{
	self PlayRumbleOnEntity( "flyby" );
	Earthquake( .2, 3, level.player.origin, 500 );
}

set_straffing_drones( str_spawner, str_align_structs, n_height, str_delete_flag, n_wait_min, n_wait_max )
{
	level thread _set_straffing_drones_thread( str_spawner, str_align_structs, n_height, str_delete_flag, n_wait_min, n_wait_max );
}

_set_straffing_drones_thread( str_spawner, str_align_structs, n_height, str_delete_flag, n_wait_min, n_wait_max )
{
	level notify( "set_straffing_drones" );
	level endon( "set_straffing_drones" );
	
	if ( str_spawner == "off" )
	{
		return;
	}
	
	a_align_structs = get_struct_array( str_align_structs );
	
	while ( true )
	{
		spawn_straffing_drone( RANDOM( a_align_structs ), n_height, level.player, str_delete_flag, str_spawner );
		wait RandomFloatRange( n_wait_min, n_wait_max );		
	}
}

#define STRAFFING_DRONE_GROUP_SPAWN_DIST_X 15000
#define STRAFFING_DRONE_GROUP_SPAWN_DIST_Y 5000
#define STRAFFING_DRONE_SPAWN_GOAL_DIST 10000
#define STRAFFING_DRONE_GROUP_SPAWN_HEIGHT 3000
	
spawn_straffing_drone( s_align, n_height_above_player, e_target, str_delete_flag, str_spawner )
{
	DEFAULT( str_spawner, "sam_drone" );
	
	if ( cointoss() )
	{
		angle_offset = 90;
		v_spawn_vector_dir = 1;
	}
	else
	{
		angle_offset = -90;
		v_spawn_vector_dir = -1;
	}
	
	n_spawn_yaw = s_align.angles[1] + angle_offset;
	
	v_spawn_org = s_align.origin + AnglesToForward( (0, n_spawn_yaw, 0) ) * STRAFFING_DRONE_GROUP_SPAWN_DIST_Y;
	v_spawn_org = v_spawn_org - AnglesToForward( ( 0, s_align.angles[1], 0 ) ) * STRAFFING_DRONE_GROUP_SPAWN_DIST_X;
	v_spawn_org = (v_spawn_org[0], v_spawn_org[1], STRAFFING_DRONE_GROUP_SPAWN_HEIGHT + RandomInt( 2000 ));
		
	veh_drone = spawn_vehicle_from_targetname( str_spawner );
	veh_drone.origin = v_spawn_org;
	
	v_goal_org = s_align.origin + AnglesToForward( (0, n_spawn_yaw, 0) ) * STRAFFING_DRONE_GROUP_SPAWN_DIST_Y;	
	v_goal_org = v_goal_org + AnglesToForward( ( 0, s_align.angles[1], 0 ) ) * STRAFFING_DRONE_SPAWN_GOAL_DIST;
	v_goal_org = (v_goal_org[0], v_goal_org[1], STRAFFING_DRONE_GROUP_SPAWN_HEIGHT + RandomInt( 2000 ));	
	
	veh_drone.v_spawn_vector = v_goal_org;
	
	v_start_angles = VectorToAngles( veh_drone.v_spawn_vector - veh_drone.origin );
	veh_drone SetPhysAngles( v_start_angles );
			 
	veh_drone thread straffing_drone( n_height_above_player, e_target, str_delete_flag );
		
	return veh_drone;
}

straffing_drone( n_height_above_player, e_target, str_delete_flag )
{
	self endon( "death" );
	
	self thread fall_out_of_world();
	
	if ( IsDefined( str_delete_flag ) )
	{
		self thread delete_vehicle_on_flag( str_delete_flag );
	}
	
	self SetDefaultPitch( 10 );
	self SetForceNoCull();
	self SetNearGoalNotifyDist( 500 );
	self ent_flag_init( "straffing" );
	
	while ( 1 )
	{
		self SetVehGoalPos( self.v_spawn_vector, 0 );
		self waittill( "near_goal" );
		
		if ( !IS_TRUE( level.disable_straffing_drone_shooting ) && cointoss() )
		{
			self set_turret_burst_parameters( 0.5, 2, .1, .5, 0 );
			
			if ( IsDefined( e_target ) )
			{
				self thread shoot_turret_at_target( e_target, 3, (RandomIntRange( -200, 200 ), RandomIntRange( -200, 200 ), RandomIntRange( -200, 200 ) ), 0 );
			}
			else
			{
				self enable_turret( 0 );
			}
			
			if ( IS_TRUE( level.enable_straffing_drone_missiles ) )
			{
				self thread shoot_turret_at_target( e_target, 3, undefined, 1 );
				self thread shoot_turret_at_target( e_target, 3, undefined, 2 );
			}
		}
		
		goal = level.player.origin + (0, 0, n_height_above_player);
		
		self SetVehGoalPos( goal, 0 );		
		self waittill( "near_goal" );
		
		if ( !IsDefined( self.b_delete_when_not_looking_at ) )
		{
			self thread delete_when_not_looking_at();		
			self.b_delete_when_not_looking_at = true;
		}
	}
}

fall_out_of_world()
{
	self endon( "death" );
	
	while ( self.origin[2] > -5000 )
	{
		wait .05;
	}
	
	//VEHICLE_DELETE( self );
	self Delete();
}

spawn_ambient_drones( trig_name, kill_trig_name, str_targetname, str_targetname_allies, path_start, n_count_axis, n_count_allies, min_interval, max_interval, speed = 400, delay = 0 )
{
	level endon( "end_ambient_drones" );
	level endon( "end_ambient_drones_" + path_start );
	
	if ( IsDefined( kill_trig_name ) )
	{
		level thread ambient_drones_kill_trig_watcher( kill_trig_name, path_start );
	}
	
	trigger_wait( trig_name, "targetname" );
	
	drones = [];

	vehicles = GetVehicleArray();	
	total = n_count_axis + n_count_allies;
	while ( vehicles.size + total > 60 )
	{
		wait( 0.05 );
		vehicles = GetVehicleArray();		
	}
	
	if ( delay > 0 )
	{
		wait( delay );
	}
	
	while ( 1 )
	{
		// spawn some axis
		for ( i = 0; i < n_count_axis; i++ )
		{		
			vh_plane = maps\_vehicle::spawn_vehicle_from_targetname( str_targetname );
			vh_plane SetSpeedImmediate( speed, 300 );			
			
			//vh_plane.script_vehicle_selfremove = 1;
			vh_plane thread delete_me();
			vh_plane SetForceNoCull();
			vh_plane thread ambient_drone_die();
			vh_plane PathFixedOffset( ( RandomIntRange( -1000, 1000 ), RandomIntRange( -1000, 1000 ), RandomIntRange( -500, 500 ) ) );
			vh_plane PathVariableOffset( ( 500, 500, 500 ), RandomFloatRange( 1, 2 ) );
			vh_plane thread go_path( GetVehicleNode( path_start, "targetname" ) );
			vh_plane thread play_fake_flyby();
			
			vh_plane.b_is_ambient = true;
			
			drones[ drones.size ] = vh_plane;
			
			wait( 0.25 );
		}
		
		// spawn some allies
		for ( i = 0; i < n_count_allies; i++ )
		{		
			vh_plane = maps\_vehicle::spawn_vehicle_from_targetname( str_targetname_allies );
			vh_plane SetSpeedImmediate( speed, 300 );
			
			vh_plane.drone_targets = drones;
			
			vh_plane thread ambient_allies_weapons_think( 101 );
			vh_plane thread delete_me();
			vh_plane SetForceNoCull();			
			vh_plane PathFixedOffset( ( RandomIntRange( -2000, 0 ), RandomIntRange( -1000, 1000 ), RandomIntRange( -500, 500 ) ) );
			vh_plane PathVariableOffset( ( 500, 500, 500 ), RandomFloatRange( 1, 2 ) );			
			vh_plane thread go_path( GetVehicleNode( path_start, "targetname" ) );
			//vh_plane playsound ("evt_fake_flyby");
			
			vh_plane.b_is_ambient = true;			
			
			wait( 0.1 );
		}
		
		wait( RandomFloatRange( min_interval, max_interval ) );
	}
}

play_fake_flyby()
{
	wait(0.1);
	sound_ent = spawn("script_origin", self.origin);
	sound_ent linkto (self, "tag_body");
	wait randomfloatrange(1,3);
	sound_ent playsound ("evt_fake_flyby");
	self waittill ("reached_end_node");
	sound_ent delete();
}

ambient_drones_kill_trig_watcher( trig_name, kill_name )
{
	trigger_wait( trig_name, "targetname" );
	level notify( "end_ambient_drones_" + kill_name );
}

delete_me()
{
	self waittill( "reached_end_node" );
	VEHICLE_DELETE( self )
}

ambient_drone_die()
{
	self waittill( "death" );
	
	wait( 0.05 );
	
	if ( !IsDefined( self ) )
		return;
	
	if ( !IsDefined( self.delete_on_death ) && IsDefined( level._effect[ "fireball_trail_lg" ] ) )
	{
		PlayFXOnTag( level._effect[ "fireball_trail_lg" ], self, "tag_origin" );
		playsoundatposition ("evt_pegasus_explo", self.origin);
		wait( 5 );
		
		if ( IsDefined( self ) )
			self Delete();
	}
	else
	{
		wait( 30 );
		
		if ( IsDefined( self ) )
			self Delete();
	}
}

ambient_allies_weapons_think( n_missile_pct )
{
	self endon( "death" );
	
	while ( 1 )
	{
		target = undefined;
		if ( IsDefined( self.drone_targets ) && self.drone_targets.size > 0 )
		{
			target = Random(  self.drone_targets );
			
			if ( IsDefined( target ) )
			{
				self maps\_turret::set_turret_target( target, ( 0, 0, 0 ), 1 );
				self maps\_turret::set_turret_target( target, ( 0, 0, 0 ), 2 );	

				self thread maps\_turret::fire_turret_for_time( RandomFloatRange( 3, 5 ), 1 );
				self thread maps\_turret::fire_turret_for_time( RandomFloatRange( 3, 5 ), 2 );

				if ( RandomInt( 100 ) < n_missile_pct )
				{
					self maps\_turret::set_turret_target( target, ( 0, 0, 0 ), 0 );	
					self FireWeapon( target );
				}			
			}
		}
	
		if ( !IsDefined( target ) )
		{
			wait( 0.05 );
		}
		else
		{
			wait( RandomFloatRange( 4, 6 ) );
		}
	}
}

play_pip( str_bik_name )
{
	maps\_glasses::play_bink_on_hud( str_bik_name, !BINK_IS_LOOPING, BINK_IN_MEMORY );
}

link_model_to_tag( str_model, str_tag )
{
	m_model = spawn_model( str_model );
	m_model LinkTo( self, str_tag, (0, 0, 0), (0, 0, 0) );
}

#using_animtree( "vehicles" );

open_suv_doors()
{
	self UseAnimTree( #animtree );
	self SetAnimKnobAll( %vehicles::veh_anim_suv_doors_open, %root, 1, 0, 1 );
}

data_glove_on( m_player_body )
{
	m_player_body Attach( "c_usa_cia_masonjr_viewbody_vson", "J_WristTwist_LE" );
	wait .05;
	m_player_body Detach( "c_usa_cia_masonjr_viewbody_vson", "J_WristTwist_LE" );
	wait .05;
	m_player_body Attach( "c_usa_cia_masonjr_viewbody_vson", "J_WristTwist_LE" );
	wait .05;
	m_player_body Detach( "c_usa_cia_masonjr_viewbody_vson", "J_WristTwist_LE" );
	wait .05;
	m_player_body Attach( "c_usa_cia_masonjr_viewbody_vson", "J_WristTwist_LE" );
	
	m_player_body SetClientFlag( CLIENT_FLAG_MOVER_HOLOGRAM );
	
	m_player_body play_fx( "data_glove_glow", undefined, undefined, undefined, true, "J_WristTwist_LE" );
}



///////////////////////////////////////////////////////////////////////////////////////////////
// VO  ////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

vo_callouts_intro( ai_noteworthy, str_calling_team, a_vo_lines )
{
	foreach ( str_vo_line in a_vo_lines )
	{
		if ( IsDefined( ai_noteworthy ) )
		{
			a_ai = get_ai_array( ai_noteworthy, "script_noteworthy" );
		}
		else
		{
			a_ai = GetAIArray( str_calling_team );
		}	
		
		if ( IsDefined( a_ai ) && a_ai.size && IsAlive( a_ai[0] ) )
		{
			a_ai[0] say_dialog( str_vo_line );
			wait RandomFloatRange( 0.25, 1.0 );
		}
	}
}

vo_callouts( ai_noteworthy, str_calling_team, a_vo_callouts, str_flag_ender, str_flag_ender_2 = "end_vo_callouts", n_min_wait = 2.0, n_max_wait = 6.0 )
{
	level endon( str_flag_ender_2 );
	
	while ( !flag( str_flag_ender ) )
	{
		if ( IsDefined( ai_noteworthy ) )
		{
			if ( ai_noteworthy == "player" )
			{
				a_ai = get_players();
			}
			else
			{
				a_ai = get_ai_array( ai_noteworthy, "script_noteworthy" );
				
			}
		}
		else
		{
			a_ai = GetAIArray( str_calling_team );
		}
		if ( IsDefined( a_ai ) && a_ai.size && IsAlive( a_ai[0] ) )
		{
			a_ai = array_removedead( a_ai );
			a_ai = array_randomize( a_ai );
			a_keys = GetArrayKeys( a_vo_callouts );
			a_keys = array_randomize( a_keys );
			
			foreach( str_key in a_keys )
			{		
				str_line = undefined;
				
				if ( str_calling_team == "allies" )
				{
					if ( str_key != "generic" )
					{
						if ( is_node_group_used( "node_" + str_key, "script_noteworthy", "axis" ) )
						{
							str_line = array_randomize( a_vo_callouts[ str_key ] )[0];
						}
					}
					else
					{
						str_line = array_randomize( a_vo_callouts[ str_key ] )[0];
					}
				}
				else
				{
					if ( str_key != "generic" )
					{
						if ( is_player_touching_volume( "volume_" + str_key, "script_noteworthy" ) )
						{
							str_line = array_randomize( a_vo_callouts[ str_key ] )[0];
						}
					}
					else
					{
						str_line = array_randomize( a_vo_callouts[ str_key ] )[0];
					}					
				}
			
				if ( IsDefined( str_line ) && IsAlive( a_ai[0] ) )	// extra sanity checks
				{
					a_ai[0] say_dialog( str_line );
					wait RandomFloatRange( n_min_wait, n_max_wait );	
				}
			}
		}
		
		wait 1;
	}
}

is_node_group_used( str_node_value, str_node_key, str_team )
{
	a_nodes = GetNodeArray( str_node_value, str_node_key );
	foreach (nd_node in a_nodes )
	{
		ai_guy = GetNodeOwner( nd_node );
		if ( IsDefined( ai_guy ) && ai_guy.team == str_team )
		{
			return true;
		}
	}
	
	return false;
}

is_player_touching_volume( str_volume_value, str_volume_key )
{
	a_volumes = GetEntArray( str_volume_value, str_volume_key );
	foreach ( t_volume  in a_volumes )
	{
		if ( level.player IsTouching( t_volume ) )
		{
			return true;		
		}
	}
	
	return false;
}