#include maps\_utility;
#include common_scripts\utility;
#include maps\pel2_util;
#include maps\pel2_callbacks;
#include maps\_anim;
#include maps\_music;



main()
{
	
	maps\_type97::main( "vehicle_jap_tracked_type97shinhoto", "type97", undefined, 2 );
	maps\_aircraft::main( "vehicle_usa_aircraft_f4ucorsair", "corsair", 2 );
	maps\_aircraft::main( "vehicle_usa_aircraft_f4ucorsair_dist", "corsair", 2 );
	maps\_betty::main("vehicle_usa_aircraft_b17_dist");
	maps\_sherman::main( "vehicle_usa_tracked_shermanm4a3_green" );
	maps\_triple25::main( "artillery_jap_triple25mm" );
	maps\_truck::main( "vehicle_jap_wheeled_type94", "model94" );	
	maps\_artillery::main("artillery_jap_47mm", "at47", true);
	
		
	// weapon swapping for the flame thrower
	maps\_coop_weaponswap::init();
	
	// MikeD (5/5/2008): Vehicle Destructible Support
	maps\_destructible_type94truck::init();
	
	precache_assets();
	
	add_start( "bunkers", ::start_bunkers, &"STARTS_PEL2_BUNKERS" );
	add_start( "flame", ::start_flame, &"STARTS_PEL2_FLAME" );
	add_start( "forest", ::start_forest, &"STARTS_PEL2_FOREST" );
	add_start( "admin", ::start_admin, &"STARTS_PEL2_ADMIN" );
	add_start( "stairs", ::start_debug_stairs, &"STARTS_PEL2_ADMIN" );
	add_start( "airfield", ::start_airfield, &"STARTS_PEL2_AIRFIELD" );
	add_start( "aaguns", ::start_aaguns, &"STARTS_PEL2_AAGUNS" );
	add_start( "napalm", ::start_napalm, &"STARTS_PEL2_NAPALM" );
	default_start( ::mangrove );
	//default_start( ::start_bunkers );
	
	createthreatbiasgroup( "players" );
	
	init_callbacks();

	// init drones
	maps\_drones::init();		
	// init bayonet fx
	maps\_bayonet::init();
	
	maps\pel2_fx::main();
	
	maps\_load::main();
	
	maps\_tree_snipers::main();
	
	level thread maps\pel2_amb::main();
	maps\pel2_anim::main();
	setup_drone_models();
	
	level thread set_custom_approach();
	
	// init banzai
	maps\_banzai::init();
	
	// weapon swapping for the flame thrower
	level.onPlayerWeaponSwap = maps\_coop_weaponswap::flamethrower_swap;

}



precache_assets()
{

	precachemodel( "static_peleliu_crate_jpn_clsd_char" );
	precacheModel("projectile_us_smoke_grenade");
	//precachemodel( "mounted_usa_bar_bipod_lmg" );
	precachemodel( "char_usa_marine_radiohandset" );

	// glowy bits
	precachemodel( "weapon_usa_flamethrower_obj" );
	precachemodel( "char_usa_marine_helmf_obj" );
	precachemodel( "weapon_usa_bazooka_at_obj" );
	precachemodel( "weapon_usa_m1garand_rifle_grenade_obj" );
	
	// Tank gear
	precachemodel( "vehicle_usa_tracked_sherman_setA_chassis" );
	precachemodel( "vehicle_usa_tracked_sherman_setA_turret" );
	precachemodel( "vehicle_usa_tracked_sherman_setB_chassis" );
	precachemodel( "vehicle_usa_tracked_sherman_setB_turret" );
	precachemodel( "vehicle_usa_tracked_sherman_setC_chassis" );
	precachemodel( "vehicle_usa_tracked_sherman_setC_turret" );	
	precachemodel( "vehicle_usa_tracked_sherman_setD_chassis" );
	precachemodel( "vehicle_usa_tracked_sherman_setD_turret" );		
	precachemodel( "vehicle_usa_tracked_sherman_setE_chassis" );
	precachemodel( "vehicle_usa_tracked_sherman_setE_turret" );		
	precachemodel( "vehicle_usa_tracked_sherman_setF_chassis" );
	precachemodel( "vehicle_usa_tracked_sherman_setF_turret" );		
	precachemodel( "vehicle_jap_type97_seta_chassis" );
	precachemodel( "vehicle_jap_type97_seta_turret" );
	precachemodel( "vehicle_jap_type97_setb_chassis" );
	precachemodel( "vehicle_jap_type97_setb_turret" );
	precachemodel( "vehicle_jap_type97_setc_chassis" );
	precachemodel( "vehicle_jap_type97_setc_turret" );		
	
	PrecacheRumble( "explosion_generic" ); 
	PrecacheRumble( "pel2_bomber" ); 
	
	precacheshader( "hud_icon_grenade_launcher_dpad" );	
	
	// for corsair pilot
	character\char_usa_pbycrew_pel2_gunner::precache();
	
}




///////////////////
//
// Handles basic level initializing
//
///////////////////////////////

setup_level()
{
	
	setup_guzzo_hud();

	// mangrove flags
	flag_init( "corsair_trap_about_to_explode" );
	flag_init( "mangrove_click_sound" );
	flag_init( "get_a_grenade_vo" );
	flag_init( "mangrove_ambush_ai_dead" );
	flag_init( "mangrove_ambush" );
	flag_init( "mangrove_gren_lookat" );
	flag_init( "all_grenaders_in_place" );	
	flag_init( "mangrove_grenades_thrown" );
	flag_init( "mangrove_grenades_exploded" );
	// bunker flags
	flag_init( "smoke_grenade_on_the_scene" );
	flag_init( "flamethrower_now_non_glowy" );
	flag_init( "mgs_focus_on_flamer" );
	flag_init( "trig_forest_friendlies" );
	flag_init( "flame_bunker_rhythm_stop" );
	flag_init( "player_got_flamethrower" );
	flag_init( "bunker_killed_but_not_flamed" );
	flag_init( "flamer_at_first_advance_node" );
	flag_init( "flame_guy_killed" );
	flag_init( "bunker_window_1_flamed" );	
	flag_init( "bunker_window_2_flamed" );	
	flag_init( "grass_surprise" );
	flag_init( "grass_surprise_damage" );
	flag_init( "marines_advance" );
	flag_init( "bunkers_flamed" );
	flag_init( "bunker_distract_1" );
	flag_init( "bunker_distract_2" );
	flag_init( "bunker_regroup_complete" );
	flag_init( "flamer_advance_to_2" );
	flag_init( "flamer_advance_to_3" );
	flag_init( "flamer_advance_to_hide" );
	flag_init( "chain_bunkers_entrance_past" );
	// admin flags
	flag_init( "friendly_chain_admin_last" );
	flag_init( "trig_ditch_guys" );
	flag_init( "admin_camo_guys_2_startled" );
	flag_init( "admin_truck_exploded" );
	flag_init( "flame_tree_guy_dead" );
	flag_init( "flame_tree_flamed" );
	flag_init( "flame_tree_affects_grass" );
	flag_init( "grass_ambush_done" );
	flag_init( "grass_admin_surprise" );
	flag_init( "grass_admin_surprise_damage" );
	flag_init( "admin_mg_done" );
	flag_init( "berm_climb" );
	flag_init( "admin_back" );
	flag_init( "top_floor_retreat" );
	flag_init( "bunker_last_ai_dead" );
	// airfield flags
	flag_init( "player_got_bazooka" );
	flag_init( "first_tank_on_the_scene" );
	flag_init( "last_tank_on_the_scene" );
	flag_init( "tower_being_populated" );
	flag_init( "whole_damn_convoy" );
	flag_init( "so_many_reinforcements" );
	flag_init( "counterattack_trucks" );
	flag_init( "end_pacing_extra" );
	flag_init( "end_pacing_polonsky" );
	flag_init( "end_pacing_roebuck" );
	flag_init( "airfield_move_vo" );
	flag_init( "pacing_vignette_started" );
	flag_init( "aaGun_1_cleared" );
	flag_init( "aaGun_2_cleared" );
	flag_init( "aaGun_3_cleared" );
	flag_init( "aaGun_4_cleared" );
	flag_init( "aaGun_1_destroyed" );
	flag_init( "aaGun_2_destroyed" );
	flag_init( "aaGun_3_destroyed" );
	flag_init( "aaGun_4_destroyed" );
	flag_init( "chi_1b_wave_almost_dead" );
	flag_init( "chi_3c_spawned" );
	flag_init( "napalm_incoming" );
	flag_init( "airfield_rush_inplace" );
	flag_init( "truck_hit_by_shell" );
	flag_init( "sherman_1a_vulnerable" );	
	flag_init( "tank_spawn_n_move_2" );
	flag_init( "plane_strafe" );
	flag_init( "plane_strafe_shoot" );
	flag_init( "airfield_last_trench" );
	flag_init( "chi_1a_wave_dead" );
	flag_init( "chi_1b_wave_dead" );
	flag_init( "chi_1c_wave_dead" );
	flag_init( "chi_3_wave_dead" );
	flag_init( "chi_3a_death" );
	flag_init( "chi_3b_death" );
	flag_init( "chi_3c_death" );
	flag_init( "shermans_1_dead" );
	flag_init( "shermans_2_dead" );
	flag_init( "shermans_3_dead" );
	flag_init( "shermans_3b_dead" );
	flag_init( "node_sherman_2a_wait_2" );
	flag_init( "last_counterattack_start" );
	
	level.current_player_speed = 1.0;
	
	level.bunker_mg_damage_total = 0;
	level.force_player_being_targetted = false;
	level.last_tree_attacker = undefined;
	level.ladder_wait_timer = 12000;
	level.guy_going_towards_stairs = false;
	level.last_defend_tanks_killed = 0;
	level.last_defend_axis_killed = 0;
	level.smoke_grenades_on_the_scene = 0;
	level.nextmission_cleanup = maps\pel2_airfield::cleanupFadeoutHud;
			
	// setup objectives
	level thread setup_objectives();
	
	// do objective skip if using a start
	if( GetDvar( "start" ) != "" )
	{
		setup_objectives_skip();
	}		
	
	// threatbias group setups
	createthreatbiasgroup( "heroes" );
	createthreatbiasgroup( "mangrove_extra_redshirt" );
	createthreatbiasgroup( "mangrove_ambush_guys" );
	createthreatbiasgroup( "intro_igc_guys" );
	createthreatbiasgroup( "bunker_1_guys" );
	createthreatbiasgroup( "intro_frontline_axis" );
	createthreatbiasgroup( "admin_mg_left_threat_group" );
	createthreatbiasgroup( "outro_mg_guy_threat" );
	
	setup_friendlies();
	setup_players();

	// misc_turret (placed to include all the necessary stuff for bar bipod) can be deleted now
	//getent( "temp_bar_bipod", "targetname" ) delete();
	
	/#
	//setsaveddvar("loc_warnings", 0 );
	setdvar( "debug_triggers", "1" );
	setdvar( "debug_character_count", "on" );
	level thread debug_script_flag_trigs_print();
	level thread draw_goal_radius();
	level thread debug_ai_health();
	#/	
	
}




// Tuey - Sets all of the players Shellshock
set_player_shock( var1, var2 )
{
	players = get_players(); 
	for( i = 0; i < players.size; i++ )
	{
		players[i] Shellshock( var1, var2 ); 
	}
}



setup_players()
{
	
	players = get_players();
	for(i=0;i<players.size;i++)
	{			
		// give them a little extra ammo for the colt (80 is the max in the gdt currently...)
		players[i] SetWeaponAmmoStock( "colt", 80 );
		players[i] setthreatbiasgroup( "players" );
	
	}
	
}



///////////////////
//
//  Entry point into the scripting of the level events
//
///////////////////////////////

mangrove()
{
	
	setup_level();
	
	start_teleport_players( "orig_start_mangrove", true );
	
	players_speed_set( 0.8, 0.1 );

	battlechatter_off();

	level.mangrove_extra_redshirt = simple_spawn_single( "mangrove_extra_redshirt", ::mangrove_extra_redshirt_strat );
	level.mangrove_extra_redshirt thread mangrove_extra_redshirt_trap_strat();
	
	level thread mangrove_vo_intro();
	
	mangrove_intro_positions();
	
//	if ( getdvarint("introscreen") != 0 )
//	{
//		intro_wait = 8.25;
//		wait( intro_wait );
//	}

	wait( 8.25 );

	mangrove_custom_transitions();
	chain_after_vignette();
	
	array_thread( level.heroes, ::set_pacifist_on );
	array_thread( level.heroes, ::set_ignoreme_on );

	for( i  = 0; i < level.heroes.size; i++ )
	{
		level.heroes[i].previous_accuracy = level.heroes[i].baseaccuracy;
		level.heroes[i].baseaccuracy = 0.2;
	}
	
	maps\_debug::set_event_printname( "Mangroves", true );

	level thread plane_trap_vignette();
	level thread grenade_vignette();
	level thread bunker_friendlywave();
	level thread bunker_4_47mm();
	
	// turn color_chain near end of mangrove section off
	trig = getent( "chain_bunker_1", "targetname" );
	trig trigger_off();
	trig = getent( "chain_bunker_2", "targetname" );
	trig trigger_off();

	// TUEY Sets the music state to be SWAMP
	setmusicstate("SWAMP");

	bunkers();

}


mangrove_intro_positions()
{

	for( i  = 0; i < level.heroes.size; i++ )
	{
		goal_node = getnode( level.heroes[i].target, "targetname" );
		level.heroes[i] setgoalnode( goal_node );
		level.heroes[i] thread enable_cqbwalk();
		level.heroes[i].moveplaybackrate = 0.75;		
	}	
	
	goal_node = getnode( level.mangrove_extra_redshirt.target, "targetname" );
	level.mangrove_extra_redshirt setgoalnode( goal_node );
	level.mangrove_extra_redshirt thread enable_cqbwalk();
	level.mangrove_extra_redshirt.moveplaybackrate = 0.75;
	
}



///////////////////
//
// pathing for guys throughout the mangroves
//
///////////////////////////////

mangrove_custom_transitions()
{
	
	for( i  = 0; i < level.heroes.size; i++ )
	{
		level.heroes[i] thread mangrove_custom_transitions_delay();
	}

	level.mangrove_extra_redshirt thread mangrove_custom_transitions_delay();
	
}



///////////////////
//
// so they don't play their overridden exit transition for their very first movement after the introscreen fades away
//
///////////////////////////////

mangrove_custom_transitions_delay()
{
	wait( 2 );
	self set_custom_approach_fields();
}



///////////////////
//
// denny's setup for custom arrival/exit transitions
//
///////////////////////////////

set_custom_approach_fields()
{

	//self.custom_approachType = "custom_exposed"; 
	//self.custom_approachNumber = 0; 
	self.custom_approachanimrate = 0.75;
	
	self.custom_exitType = "custom_exposed";
	self.custom_exitNumber = 0;		
	self.custom_exitanimrate = 0.75;
	
}



clear_custom_approach_fields()
{

	self.custom_approachType = undefined; 
	self.custom_approachNumber = undefined; 
	self.custom_exitType = undefined;
	self.custom_exitNumber = undefined;		
	
}



///////////////////
//
// Send squad to nodes after introscreen and branch pushing anim
//
///////////////////////////////

chain_after_vignette()
{
	
	goal_node = getnode( "node_intro_polonsky", "script_noteworthy" );
	level.polonsky setgoalnode( goal_node );
	
	goal_node = getnode( "node_intro_roebuck", "script_noteworthy" );
	level.roebuck setgoalnode( goal_node );

	goal_node = getnode( "node_intro_extra_hero", "script_noteworthy" );
	level.extra_hero setgoalnode( goal_node );

	goal_node = getnode( "node_intro_extra_redshirt", "script_noteworthy" );
	level.mangrove_extra_redshirt setgoalnode( goal_node );	

}



mangrove_vo_intro()
{

	level thread mangrove_vo_trap();
	level thread mangrove_vo_2();
	level thread mangrove_vo_3();
	
	wait( 4 );
	
	play_vo( level.roebuck, "vo", "arrangements" );
	wait( 3.1 );
	play_vo( level.polonsky, "vo", "i_though_sullivan" );
	wait( 2.75 );
	play_vo( level.roebuck, "vo", "we_let_our_guard" );
	wait( 4 );
	play_vo( level.polonsky, "vo", "so_what_now" );
	wait( 2.5 );
	play_vo( level.roebuck, "vo", "tojos_gotta_tight" );
	wait( 4 );
	play_vo( level.roebuck, "vo", "direct_route" );
	wait( 3.35 );	
	play_vo( level.roebuck, "vo", "we_take_the_flank" );
	wait( 7.25 );	
	play_vo( level.roebuck, "vo", "stay_sharp" );

}



mangrove_vo_trap()
{

	flag_wait( "trig_mangrove_trap" );
	
	wait( 2 );
	
	// VO: poor bastard must've been shot down this morning
	play_vo( level.polonsky, "vo", "poor_bastard" );
	wait( 3 );
	play_vo( level.roebuck, "vo", "fuselage_smoking" );	
	
	wait( 4.25 );
	
	//TUEY Had to move this notify because the grenade click and roll was not working properly anymore.
	level notify ("trap_sprung");
	
	wait( 4 );
	
	flag_set( "mangrove_click_sound" );

	

	flag_set( "corsair_trap_about_to_explode" ); // only set if the vignette plays out; not if the player forces the trap by running ahead
	
	flag_wait( "mangrove_ambush" );

	play_vo( level.roebuck, "vo", "booby_trap!!!" );
	wait( 1.25 );
	play_vo( level.polonsky, "vo", "shit!!!" );


}



mangrove_vo_2()
{

	flag_wait( "mangrove_ambush_guys_2" );

	wait( RandomFloatRange( 1.5, 2.25 ) );

	play_vo( level.roebuck, "vo", "ambush!!!" );

	wait( RandomFloatRange( 2.1, 2.5 ) );
	
	play_vo( level.roebuck, "vo", "keep_em_back" );

	wait( RandomFloatRange( 1.75, 2.0 ) );

	play_vo( level.polonsky, "vo", "it_was_a_trap" );
	
}


mangrove_vo_3()
{

	flag_wait( "trig_mangrove_grenades" );
	
	play_vo( level.polonsky, "vo", "were_kinda_late" );
	wait( 3.5 );
	
	flag_wait( "trig_mangrove_grenades" );
	
	play_vo( level.roebuck, "vo", "mgs_in_the_bunkers" );	
	wait( 5 );
	
	flag_wait( "get_a_grenade_vo" );

	play_vo( level.roebuck, "vo", "get_a_grenade_up" );	
	
	flag_wait( "mangrove_grenades_exploded" );
	
	wait( 0.5 );
	play_vo( level.roebuck, "vo", "everyone_move" );
	wait( 1.7 );
	play_vo( level.roebuck, "vo", "go_go" );
	//wait( 3 );
	//play_vo( level.roebuck, "vo", "take_out_those_mgs" );
	
}


bunkers_vo()
{
	
	flag_wait( "trig_bunkers_paths_vo" );
	
	play_vo( level.roebuck, "vo", "down_both_flanks" );
	wait( 3.5 );
	play_vo( level.roebuck, "vo", "carve_a_path" );	
	
	flag_wait( "flamer_at_first_advance_node" );
	
	play_vo( level.polonsky, "vo", "flame_moving_up" );
	wait( 2 );
	play_vo( level.roebuck, "vo", "give_em_covering" );
	
	wait( RandomIntRange( 4, 7 ) );
	
	play_vo( level.roebuck, "vo", "stay_on_them" );
	
}


	
mangrove_ambush_beat_2()
{

	level thread mangrove_ambush_beat_2_timeout();

	// flag set on trigger
	flag_wait( "mangrove_ambush_guys_2" );
	
	wait( 0.25 );
	
	simple_spawn( "mangrove_ambush_guys_2b", ::mangrove_ambush_guys_2b_strat );
	
	level thread mangrove_ambush_2_heroes_sneak();
	level thread post_trap_chain_2();

	wait( 1.9 );

	simple_spawn( "mangrove_ambush_guys_2a", ::mangrove_ambush_guys_2a_strat );

	wait_network_frame();

	// piggybacking this here to save a trigger enty
	// spawn first AT47
	maps\_vehicle::scripted_spawn( 24 );

	level thread battle_line_ambient_sound();

}



mangrove_ambush_beat_2_timeout()
{
	
	flag_wait( "mangrove_ambush" );
	wait( RandomIntRange( 12, 14 ) );
	
	trig = getent( "trig_mangrove_ambush_guys_2", "script_noteworthy" );
	// it may have been hit if player rushes up
	if( isdefined( trig ) )
	{
		trig notify( "trigger" );	
	}
	
}



mangrove_ambush_beat_3()
{

	flag_wait( "mangrove_ambush_guys_2" );

	simple_spawn( "mangrove_ambush_guys_3", ::mangrove_ambush_guys_3_strat );
	
	flag_wait( "mangrove_ambush_guys_3" );
	
	level thread mangrove_ambush_2_heroes_sneak_2();
	
	level thread post_trap_chain_3();
	
	wait( RandomFloatRange( 0.35, 0.65 ) );
		
	play_vo( level.polonsky, "vo", "another_ambush" );
	
	/////////
	simple_spawn( "intro_igc_friendlies", ::intro_igc_friendlies_strat );
	// have bunker_1_guys ignore intro_igc_guys 
	setignoremegroup( "intro_igc_guys", "bunker_1_guys" );	
	/////////
	
	wait( RandomFloatRange( 2.3, 3.2 ) );
	
	play_vo( level.polonsky, "vo", "theyre_all_around" );

	wait( RandomFloatRange( 1.75, 2.0 ) );
	
	play_vo( level.roebuck, "vo", "keep_it_tight" );

}



///////////////////
//
// Move heroes up after ambush enemies have been cleared
//
///////////////////////////////

post_trap_chain_1()
{

	waittill_aigroupcleared( "mangrove_ambush_ai" );
	
	flag_set( "mangrove_ambush_ai_dead" );
	
	objective_position( 1, ( 2562, -13802, -135 ) );	

	wait_network_frame();	// let objective clear the network.
	
	level thread battlechatter_off();
	
	for( i  = 0; i < level.heroes.size; i++ )
	{
		level.heroes[i].baseaccuracy = level.heroes[i].previous_accuracy;
	}	
	
	trig = getent( "trig_chain_post_trap_1", "targetname" );
	if( isdefined( trig ) )
	{
		trig notify( "trigger" ); 	
	}
	
}



post_trap_chain_2()
{
	
	// notify comes from flag on trigger
	level endon( "trig_mangrove_grenades" );

	waittill_aigroupcleared( "mangrove_ambush_ai_2" );

	// move up friendlies
	trig = getent( "trig_chain_post_trap_2", "targetname" );
	if( isdefined( trig ) )
	{
		trig notify( "trigger" ); 	
	}	
	
}



post_trap_chain_3()
{
	
	// notify from flag set on trigger
	level endon( "trig_mangrove_grenades" );
	
	waittill_aigroupcleared( "mangrove_ambush_ai_3" );

	level.roebuck enable_ai_color();
	set_color_chain( "chain_post_trap_3" );
	
}



///////////////////
//
// Have heroes creep forward just a bit before the 2nd beat of mangrove ambush
//
///////////////////////////////

mangrove_ambush_2_heroes_sneak()
{

	// have friendlies walk forward slightly
	for( i  = 0; i < level.heroes.size; i++ )
	{
		level.heroes[i] setgoalpos( (2944.5, -14091, -129) );
	}
	
	wait( 2 );

	// then stop them so they can engage the enemy
	for( i  = 0; i < level.heroes.size; i++ )
	{	
		level.heroes[i] setgoalpos( level.heroes[i].origin );
	}
	
}



///////////////////
//
// Have heroes creep forward just a bit before the 3rd beat of mangrove ambush
//
///////////////////////////////

mangrove_ambush_2_heroes_sneak_2()
{

//	polonsky_goal_pos = (2675, -13797, -129);
//	roebuck_goal_pos = (2477, -13954, -129);
//	extra_hero_goal_pos = (2607, -13967, -129);

	node_polonksy = getnode( "node_sneak_2_polonsky", "targetname" );
	node_roebuck = getnode( "node_sneak_2_roebuck", "targetname" );
	node_extra_hero = getnode( "node_sneak_2_extra_hero", "targetname" );

	// have friendlies walk forward slightly
	level.polonsky setgoalnode( node_polonksy );
	level.roebuck setgoalnode( node_roebuck );
	level.extra_hero setgoalnode( node_extra_hero );
	
	wait( 1.75 );

	// then stop them so they can engage the enemy
	for( i  = 0; i < level.heroes.size; i++ )
	{	
		if( level.heroes[i] == level.roebuck )
		{
			goal_node = getnode( "node_ambush_beat_3_roebuck", "targetname" );
			level.roebuck disable_ai_color();
			level.roebuck setgoalnode( goal_node );
		}
		else
		{
			level.heroes[i] setgoalpos(level.heroes[i].origin );
		}
	}
	
}



mangrove_ambush_guys_2a_strat()
{

	self endon( "death" );
	
	self toggleik( false );
	self.ignoreme = true;
	self.ignoresuppression = true;
	
	wait( 1.5 + RandomFloat( 0.5 ) );
	
	self.ignoreme = false;
	
	// if they're just standing at their goal node firing, banzai charage after a little bit
	if( isdefined( self.script_noteworthy ) && self.script_noteworthy == "late_banzai" )
	{
	
		wait( 2.25 + RandomFloat( 1 ) );
		
		self thread guzzo_print_3d( "late banzai!" );
		
		self.banzai_no_wait = 1;	
		self.ignoresuppression = 1;		
		self.script_max_banzai_distance = 2000;
		self thread maps\_banzai::banzai_force();	
	
	}
	
}



mangrove_ambush_guys_2b_strat()
{

	self endon( "death" );
	
	self.ignoreme = 1;
	
	self.banzai_no_wait = 1;	
	self.grenadeawareness = 0;
	self.ignoresuppression = 1;		
	self.script_max_banzai_distance = 2000;
	
	self thread guzzo_print_3d( "banzai!" );
	
	self thread maps\_banzai::banzai_force();
	
	wait( 1.75 + RandomFloat( 0.5 ) );
	
	self.ignoreme = 0;
	
}



///////////////////
//
// Ally from other squad that is at the bend before the corsair crash
//
///////////////////////////////

mangrove_bend_guy()
{

	bend_guy = simple_spawn_single( "friend_trap_pre_spawner" );
	bend_guy.animname = "stand";

	bend_guy endon( "death" );

	flag_wait( "mangrove_ambush" );
	
	bend_guy.deathanim = level.scr_anim["stand"]["explode_stand_2"];
	bend_guy dodamage( bend_guy.health + 1, (0,0,0) );
	
}



///////////////////
//
// Update the objective position in the mangroves
//
///////////////////////////////

bunker_friendlywave()
{

	// flag set on trigger
	flag_wait( "trig_bunker_friendlywave" );
	objective_position( 1, ( 2721, -12187, -120.7 ) );	

	autosave_by_name( "Pel2 before ambush 3" );

	// play vo only if 2nd ambush guys are dead
	ambush_beat_2_guys = get_ai_group_ai( "mangrove_ambush_ai_2" );
	if( !ambush_beat_2_guys.size )
	{
		wait( randomfloatrange( 0.6, 1.1 ) );
		play_vo( level.polonsky, "vo", "cant_believe_theyd" );
	}

	wait_network_frame();
	
	level thread bunker_1_mgs();

}



plane_trap_vignette()
{

	level thread mangrove_bend_guy();
	level thread plane_trap_fx();
	level thread mangrove_ambush_beat_2();
	level thread mangrove_ambush_beat_3();

	flag_wait( "trig_setup_trap" );

	simple_spawn_single( "friend_trap_spawner_extra", ::friend_trap_spawner_extra_strat );

	level thread trap_checkers();
	// DEMO off
	//level thread mangrove_walk();	
	level thread plane_trap_pilot();

	wait_network_frame(); // CLIENTSIDE to help snapshot size	
	
	simple_spawn( "mangrove_ambush_guys", ::mangrove_ambush_guys_strat );

	// wait till player is nearby (flag set on trigger)
	flag_wait( "trig_mangrove_trap" );
	
	level thread mangrove_ambush_timer();
	
	// if the vignette plays out or if the player triggers the 2nd group of ambush guys by running ahead
	flag_wait_either( "mangrove_ambush", "mangrove_ambush_guys_2" );
	
	flag_set( "mangrove_ambush" );
	
	// TUEY Sets the music state to be AMBUSHED
	setmusicstate("AMBUSHED");	
	
	battlechatter_on();
	
	set_color_chain( "trig_chain_trap_react" );

	level thread post_trap_chain_1();
	
	array_thread( level.heroes, ::set_pacifist_off );
	wait( 1 ); // wait a bit so they target the redshirts first
	array_thread( level.heroes, ::set_ignoreme_off );
	
	
}



mangrove_ambush_timer()
{
	
	level endon( "mangrove_ambush_guys_2" );
	wait( 12.5 );
	flag_set( "mangrove_ambush" );
	
}



trap_checkers()
{

	helper = simple_spawn_single( "friend_trap_ai_helper", ::trap_checker_strat );
	checker = simple_spawn_single( "friend_trap_ai_checker", ::trap_checker_strat );

	helper.animname = "trap_react_redshirt_1_idle";
	checker.animname = "trap_react_redshirt_2_idle";

	anim_node = getstruct( "node_anim_trap", "targetname" );	
	
	// their idle anims, before the player gets close
	level thread anim_loop_solo( helper, "mangrove_trap", undefined, "stop_mangrove_trap_loop", anim_node );	
	level thread anim_loop_solo( checker, "mangrove_trap", undefined, "stop_mangrove_trap_loop", anim_node );	
	
	flag_wait( "trig_mangrove_trap" );
	
	helper.animname = "trap_react_redshirt_1";
	checker.animname = "trap_react_redshirt_2";

	anim_guys = [];
	anim_guys[0] = helper;
	anim_guys[1] = checker;
	
	level thread anim_single( anim_guys, "mangrove_trap", undefined, undefined, anim_node );	
	
	// in case the trap goes off early because the player rushed ahead
	flag_wait( "mangrove_ambush_guys_2" );
	
	if( !flag( "corsair_trap_about_to_explode" ) )
	{
		
		for( i  = 0; i < anim_guys.size; i++ )
		{
			
			if( isdefined( anim_guys[i] ) && isalive( anim_guys[i] ) )
			{
				anim_guys[i] notify( "killanimscript" );
				anim_guys[i].animname = "stand";
				anim_guys[i].deathanim = level.scr_anim["stand"]["explode_back13"];
				anim_guys[i] dodamage( anim_guys[i].health + 1, (0,0,0) );
			}
			
		}
			
	}	
	
}



trap_checker_strat()
{
	self.ignoreall = true;	
}



plane_trap_fx()
{
	
	orig = getstruct( "orig_trap_explode", "targetname" );
	temp_orig = spawn( "script_origin", orig.origin );
	level thread plane_trap_click_fx( temp_orig );
	
	flag_wait( "mangrove_ambush" );
	
	// redundant click flag... in the case player rushes ahead, we still hear the click
	flag_set( "mangrove_click_sound" );
	
	// fx exploder
	exploder( 100 );
	
	temp_orig playsound( "mangrove_explo" );
	earthquake( 0.65, 2.4, orig.origin , 1300 );	
	PlayRumbleOnPosition( "explosion_generic", orig.origin ); 
	radiusdamage( orig.origin, 260, 90, 55 );
	
	// shellshock them if they're close enough
	players = get_players();
	for( i  = 0; i < players.size; i++ )
	{
		if( distanceSquared( players[i].origin, orig.origin ) < (270*270) )
		{
			players[i] shellshock( "default", 1.75 );
		}
	}
	
}


plane_trap_click_fx( temp_orig )
{
	// flag set on trigger
	//flag_wait( "mangrove_click_sound" );

	level waittill ("trap_sprung");
	wait(1.5);
	temp_orig playsound("ambush_click");

	//playsoundatposition( "ambush_click", (0,0,0));
}



#using_animtree( "generic_human" );
plane_trap_pilot()
{

	orig = getstruct( "orig_plane_trap_pilot", "targetname" );

	pilot = spawn( "script_model", orig.origin );
	pilot.angles = orig.angles;
	pilot character\char_usa_pbycrew_pel2_gunner::main();
	pilot UseAnimTree( #animtree );
	pilot.animname = "mangrove_trap";
	pilot.targetname = "script_pilot";

	anim_node = getstruct( "node_anim_trap", "targetname" );

	level thread anim_loop_solo( pilot, "trap_idle_pilot", undefined, "mangrove_ambush_pre", anim_node );

	flag_wait( "trig_mangrove_trap" );

	level thread anim_single_solo( pilot, "trap_death_pilot", undefined, anim_node );

	flag_wait( "mangrove_ambush" );	
	
	wait( 0.1 );
	
	pilot delete();

}



mangrove_extra_redshirt_strat()
{
	
	self.pacifist = true;
	self.pacifistwait = 0.05;
	self.ignoreme = true;
	self.ignoreall = true;
	self.goalradius = 400;
	
	self setthreatbiasgroup( "mangrove_extra_redshirt" );
	
}



mangrove_extra_redshirt_trap_strat()
{

	self endon( "death" );

	//self thread delay_mangrove_walk();

	flag_wait( "trig_extra_redshirt_trap_strat" );
	
	self allowedstances( "stand" );
	
	self disable_ai_color();
	goal_node = getnode( "node_extra_redshirt_trap", "targetname" );
	self setgoalnode( goal_node );	
	
	flag_wait( "mangrove_ambush" );
	
	self.animname = "mangrove_trap";
	
	self.baseaccuracy = 0.05;
	self.pacifist = 0;
	self.ignoreme = 0;
	self.ignoreall = 0;	
	
	if( distance( self.origin, goal_node.origin ) < 50 )
	{
		self allowedstances( "crouch" );
		anim_single_solo( self, "trap_react_redshirt_kneel", undefined, self );	
	}
	else
	{
		println( "mangrove_extra_redshirt isn't playing reaction anim cuz he was too far from his goal node!" );	
	}
	
	wait( RandomFloatRange( 2.5, 3.0 ) );
	
	if( isalive( self ) )
	{
		self thread bloody_death( true );
	}
	
}



///////////////////
//
// Strategy for enemy ai that ambush out of the trees/foliage near the plane
//
///////////////////////////////

mangrove_ambush_guys_strat()
{
	
	self endon( "death" );
	
	self thread magic_bullet_shield();
	self setcandamage( false );	
	old_sight = self.maxSightDistSqrd;
	self.maxSightDistSqrd = 0;
	self.grenadeawareness = 0;
	self.ignoreall = 1;
	self.ignoresuppression = 1;
	self.ignoreme = 1;
	self.pacifist = 1;
	self.pacifistwait = 0.05;
	self.activatecrosshair = false;
	self.drawoncompass = false;
	self disableaimassist();
	self toggleik( false );

	flag_wait( "mangrove_ambush" );
	
	self setcandamage( true );
	self stop_magic_bullet_shield();
	
	wait( RandomFloatRange( 0.5, 1.25 ) );
	
	self.activatecrosshair = true;
	self enableaimassist();
	self.drawoncompass = true;
	self.maxSightDistSqrd = old_sight;
	self.ignoreall = 0;
	self.pacifist = 0;
	
	self setthreatbiasgroup( "mangrove_ambush_guys" );
	
	// have mangrove_ambush_guys pay more attention to mangrove_extra_redshirt
	setthreatbias( "mangrove_extra_redshirt", "mangrove_ambush_guys", 30000 );
	
	if( self.script_noteworthy == "mangrove_banzai" )
	{
		self.banzai_no_wait = 1;
		self.script_max_banzai_distance = 2000;
		self thread maps\_banzai::banzai_force();
		wait( 2.5 );
		self.ignoreme = 0;
	}
	else
	{
		goal_node = getnode( self.script_noteworthy, "targetname" );
		self setgoalnode( goal_node );

		wait( 1.5 );
		self.ignoreme = 0;

		if( isdefined( goal_node.target ) )
		{
			wait( goal_node.script_delay );
			new_goal_node = getnode( goal_node.target, "targetname" );
			self setgoalnode( new_goal_node );
			
			self waittill( "goal" );
			
			wait( RandomFloatRange( 1.0, 2.0 ) );
			
			self.banzai_no_wait = 1;
			self.script_max_banzai_distance = 2000;
			self thread maps\_banzai::banzai_force();			
			
		}
		// guy that is up on the mound near the corsair will charge eventually
		else if( self.script_noteworthy == "auto5301" )
		{
			flag_wait_or_timeout( "mangrove_ambush_guys_2", 10 );
			
			self.goalradius = 50;
			goal_node = getnode( "auto5699", "targetname" );
			self setgoalnode( goal_node );
			self waittill( "goal" );
			
			self.banzai_no_wait = 1;
			self.script_max_banzai_distance = 2000;
			self thread maps\_banzai::banzai_force();		
		}

	}
	
}



///////////////////
//
// Strategy for enemy ai that ambush out of the trees/foliage near the plane
//
///////////////////////////////

mangrove_ambush_guys_3_strat()
{
	
	self endon( "death" );
	
	self thread magic_bullet_shield();
	self setcandamage( false );	
	old_sight = self.maxSightDistSqrd;
	self.maxSightDistSqrd = 0;
	self.grenadeawareness = 0;
	self.ignoreall = 1;
	self.ignoresuppression = 1;
	self.ignoreme = 1;
	self.pacifist = 1;
	self.pacifistwait = 0.05;
	self.activatecrosshair = false;
	self.drawoncompass = false;
	self disableaimassist();
	self toggleik( false );

	flag_wait( "mangrove_ambush_guys_3" );
	
	self setcandamage( true );
	self stop_magic_bullet_shield();
	
	self.activatecrosshair = true;
	self enableaimassist();
	self.drawoncompass = true;
	self.maxSightDistSqrd = old_sight;
	self.ignoreall = 0;
	self.pacifist = 0;
	
	goal_node = getnode( self.script_noteworthy, "targetname" );
	self setgoalnode( goal_node );

	wait( 1.5 );
	self.ignoreme = 0;

	wait( RandomFloatRange( 5.25, 9.0 ) );
	
	self.banzai_no_wait = 1;
	self.script_max_banzai_distance = 2000;
	self thread maps\_banzai::banzai_force();			
		
}



///////////////////
//
// Guy that is nearby plane but doesn't play an anim in the vignette
//
///////////////////////////////

friend_trap_spawner_extra_strat()
{
	
	self endon( "death" );
	
	// for some reason he is killed when arriving upon the scene. 
	// it's likely that enemy ai are firing in their first frame, before being set to pacifist
	self.health = self.health + 150; 
	
	old_sight = self.maxSightDistSqrd;
	self.maxSightDistSqrd = 0;
	self.ignoreall = true;
	self.pacifist = true;
	self.ignoreme = true;
	old_pacifist = self.pacifistwait;
	self.pacifistwait = 0.05;
	self.animname = "mangrove_trap";	
	
	flag_wait( "mangrove_ambush" );
	
	anim_single_solo( self, "trap_react_redshirt_fall_down", undefined, self );	

	self.maxSightDistSqrd = old_sight;
	self.ignoreme = false;
	self.ignoreall = false;
	self.pacifist = false;
	self.pacifistwait = old_pacifist;
	self.baseaccuracy = 0.05;

	self.health = 10;		

	goal_node = getnode( self.script_noteworthy, "targetname" );
	self setgoalnode( goal_node );
	
	wait( RandomFloatRange( 3.5, 4.75 ) );
	
	if( isalive( self ) )
	{
		self thread bloody_death( true );
	}
	
}



///////////////////
//
// Secondary squad takes cover and throws grenades at the at74
//
///////////////////////////////

grenade_vignette()
{
	
	flag_wait( "trig_mangrove_grenades" );
	
	wait_network_frame();
	
	set_color_heroes( "b" );
	set_color_chain( "trig_chain_post_trap_4" );
	
	guys = simple_spawn( "friend_bunker_spawner", ::friend_bunker_strat );	
	assertex( guys.size == 3, "grenade throwers != 3" );
	
	guys[0].animname = "gren_throw_1_in";
	guys[1].animname = "gren_throw_2_in";
	guys[2].animname = "gren_throw_3_in";
	
	goal_node = getnode( "node_mangrove_align", "targetname" );
	
	anim_single( guys, "mangrove_grenades_in", undefined, undefined, goal_node );	

	guys[0].animname = "gren_throw_1_wait";
	guys[1].animname = "gren_throw_2_wait";
	guys[2].animname = "gren_throw_3_wait";	

	level thread anim_loop( guys, "mangrove_grenades_wait", undefined, "mangrove_grenades", goal_node );	
	
	flag_set( "all_grenaders_in_place" );	
	
	event_text( "in place. waiting to regroup nearby" );
	
	regroup_trig = getent( "trig_near_grenaders", "targetname" );		
	
	level thread gren_lookat_override();
	
	// wait till player is back with squad near sandbags
	while( 1 )
	{
		if( any_player_IsTouching( regroup_trig ) || flag( "mangrove_gren_lookat" ) || flag( "trig_box_carry" ) ) // added trig_box_carry in case they run forward, create chaos, then sprint back
		{
			break;	
		}
	
		wait( 0.15 );
	}
	
	flag_set( "get_a_grenade_vo" );
	
	level notify( "mangrove_grenades" );
	
	guys[0].animname = "gren_throw_1_out";
	guys[1].animname = "gren_throw_2_out";
	guys[2].animname = "gren_throw_3_out";		
	
	guys[0] disable_arrivals( true, true );
	guys[0] thread delay_grenade_vignette_arrivals();
	guys[1] disable_arrivals( true, true );
	guys[1] thread delay_grenade_vignette_arrivals();
	guys[2] disable_arrivals( true, true );
	guys[2] thread delay_grenade_vignette_arrivals();
	
//	level thread grenade_vignette_temp_hack( guys[0], level.scr_anim["gren_throw_1_out"]["mangrove_grenades_out"] );
//	level thread grenade_vignette_temp_hack( guys[1], level.scr_anim["gren_throw_2_out"]["mangrove_grenades_out"] );
//	level thread grenade_vignette_temp_hack( guys[2], level.scr_anim["gren_throw_3_out"]["mangrove_grenades_out"] );
//	level thread anim_single( guys, "mangrove_grenades_out", undefined, undefined, goal_node );	
	level thread anim_single_earlyout( guys, "mangrove_grenades_out", undefined, undefined, goal_node, undefined, 0.25 );
	
	flag_wait( "mangrove_grenades_thrown" );
	event_text( "mangrove_grenades_thrown" );
	
	grenade_vignette_post();
	
}



delay_grenade_vignette_arrivals()
{

	flag_wait( "mangrove_grenades_thrown" );
	wait( 10 );
	self disable_arrivals( false, false );
	
}


// TEMP for debug purposes only
//grenade_vignette_temp_hack( guy, anime )
//{
//	/#
//	animtime = getanimlength( anime );
//	
//	animtime -= 0.05;
//	wait(animtime);
//	 
//	guy stopanimscripted();	
//	#/
//	
//}


///////////////////
//
// after the grenade vignette, move up both groups of guys for the bunker battle
//
///////////////////////////////

grenade_vignette_post()
{

	set_players_ignoreme( false );
	
	level.roebuck set_generic_run_anim( "roebuck_run", true ); 
	
	// get color reinforcements going...
	trig = getent( "trigger_bunker_wave_1", "script_noteworthy" );
	trig notify( "trigger" );
	
	// wait for grenade throws
	wait( 1.75 );

	flag_set( "mangrove_grenades_exploded" );

	battlechatter_on();

	// kill at47 guys if they survived the grenades
	kill_aigroup( "bunker_gun_4_ai" );

	// make squad active again
	array_thread( level.heroes, ::set_pacifist_off );
	array_thread( level.heroes, ::set_ignoreme_off );
	
	// turn nearby color_chain back on
	trig = getent( "chain_bunker_1", "targetname" );
	trig trigger_on();
	trig = getent( "chain_bunker_2", "targetname" );
	trig trigger_on();
	
	// move guys up out of mangrove swamp
	set_color_chain( "trig_chain_bunkers" );

	autosave_by_name( "Pel2 grenade vignette post" );
	
}



///////////////////
//
// player can look at grenaders to start the vignette even if he isn't close enough
//
///////////////////////////////

gren_lookat_override()
{
	trig = getent( "trig_mangrove_gren_lookat", "targetname" );
	trig waittill( "trigger" );
	
	flag_set( "mangrove_gren_lookat" );
}



///////////////////
//
// Strategy for squad that joins up with the player near the end of the mangrove swamp
//
///////////////////////////////

friend_bunker_strat()
{
	
	self thread magic_bullet_shield();
	self.ignoreme = true;
	self.ignoreall = true;
	self.pacifist = true;
	self.animname = "mangrove";
	self.goalradius = 50;

	self.disableexits = true;
	self.disablearrivals = true;

	self disable_ai_color();
	
	flag_wait( "all_grenaders_in_place" );	

	self.ignoreme = false;
	self.ignoreall = false;	
	self.pacifist = false;

	flag_wait( "mangrove_grenades_exploded" );	

	self set_force_color( "b" );
	self thread replace_on_death();
	self.allowdeath = true;
	self stop_magic_bullet_shield();
	
	self endon( "death" );
	
	wait( 3 );
	
	self.disableexits = false;
	self.disablearrivals = false;	
	
}



///////////////////
//
// Anim vignette of enemies carrying an ammo box
//
///////////////////////////////

box_carry()
{

	level endon( "box_carry_stop" );

	box_guy_health = 30;

	////// set up guys
	guy_box_host = simple_spawn_single( "guy_box_host" );
	guy_box_host.allowdeath = true;
	guy_box_host.ignoreall = true;
	guy_box_host.animname = "carry_box_host";
	guy_box_host.deathanim = level.scr_anim["carry_box_host"]["carry_box_host_death"];
	guy_box_host.health = box_guy_health;
	guy_box_host animscripts\shared::placeWeaponOn( guy_box_host.primaryweapon, "none");
	guy_box_host thread box_carry_damage();

	guy_box_host thread box_carry_drop();

	guy_box_helper = simple_spawn_single( "guy_box_helper" );
	guy_box_helper.allowdeath = true;
	guy_box_helper.ignoreall = true;
	guy_box_helper.animname = "carry_box_helper";
	guy_box_helper.deathanim = level.scr_anim["carry_box_helper"]["carry_box_helper_death"];
	guy_box_helper.health = box_guy_health;
	guy_box_helper animscripts\shared::placeWeaponOn( guy_box_helper.primaryweapon, "none");
	guy_box_helper thread box_carry_damage();

	carrier_guys = [];
	carrier_guys[0] = guy_box_host;
	carrier_guys[1] = guy_box_helper;
	///////////////////////////////////
	
	////// set up box
	guy_box_host attach( "static_peleliu_crate_jpn_clsd_char", "tag_weapon_left" );
	
	carry_node = getnode( "node_carry", "targetname" );
	anim_single( carrier_guys, "carry_box", undefined, carry_node );

	// if they completed their path safely
	if( guy_box_helper.health == box_guy_health && guy_box_host.health == box_guy_health )
	{

		level notify( "box_carry_done" );
	
		level thread box_detach_delay( guy_box_host );
	
		// the run is done, kill them both
		if( isalive( guy_box_host ) )
		{
			guy_box_host dodamage( 1000, ( 0, 0, 0 ) );		
		}
		if( isalive( guy_box_helper ) )
		{
			guy_box_helper dodamage( 1000, ( 0, 0, 0 ) );	
		}
		
	}
	
}



///////////////////
//
// Detach box from tag_weapon_left and spawn a new one where he would've dropped it
//
///////////////////////////////

box_detach_delay( guy_box_host )
{

	wait( 1 );

	orig = guy_box_host gettagorigin( "tag_weapon_left" );
	angles = guy_box_host gettagangles( "tag_weapon_left" );

	box = spawn( "script_model" , orig );
	box.angles = angles;
	box setmodel( "static_peleliu_crate_jpn_clsd_char" );	
	
	guy_box_host detach( "static_peleliu_crate_jpn_clsd_char", "tag_weapon_left" );		
	
}

///////////////////
//
// Detach the box if damaged before run is done
//
///////////////////////////////

box_carry_drop()
{

	level  endon( "box_carry_done" );
	
	level waittill( "box_carry_stop" );

	orig = self gettagorigin( "tag_weapon_left" );
	angles = self gettagangles( "tag_weapon_left" );

	ground_trace = bullettrace(  orig,  orig - (0,0,100000), 0, undefined );

	box = spawn( "script_model" , orig );
	box.angles = angles;
	box setmodel( "static_peleliu_crate_jpn_clsd_char" );

	self detach( "static_peleliu_crate_jpn_clsd_char", "tag_weapon_left" );	

	box moveto( ground_trace["position"] - (0,0,2 ), 0.2 );

}



///////////////////
//
// How box carrier guys handle being damaged
//
///////////////////////////////

box_carry_damage()
{

	level endon( "box_carry_damage" );
	
	self waittill( "damage" );

	level notify( "box_carry_stop" );

	// send them away to die
	guys = get_ai_group_ai( "box_carrier_ai" );
	
	for( i  = 0; i < guys.size; i++ )
	{
		guys[i] notify( "killanimscript" );
		guys[i] thread box_carry_death_run();

	}
	
	level notify( "box_carry_damage" );
	
}



///////////////////
//
// Box carriers retreat around a corner and are killed through script if they are shot during their anim
//
///////////////////////////////

box_carry_death_run()
{
	
	self.goalradius = 40;
	
	goal = getnode( "node_box_carry_death", "targetname" );
	
	self setgoalnode( goal );
	
	self waittill( "goal" );
	
	self dodamage( self.health + 10, ( 0, 0, 0 ) );
	
}



//////
///////////////////
//
// STARTS
//
///////////////////////////////
//////

start_bunkers()
{

	setup_level();

	getent( "trig_chain_post_trap_2", "targetname" ) delete();

	level thread battle_line_ambient_sound();

	players_speed_set( 0.8, 0.1 );

	// turn color_chain near end of mangrove section off
	trig = getent( "chain_bunker_1", "targetname" );
	trig trigger_off();
	trig = getent( "chain_bunker_2", "targetname" );
	trig trigger_off();

	maps\_vehicle::scripted_spawn( 24 );

	simple_spawn( "intro_igc_friendlies", ::intro_igc_friendlies_strat );
	
	array_thread( level.heroes, ::set_pacifist_on );
	array_thread( level.heroes, ::set_ignoreme_on );
	set_players_ignoreme( true );

	set_color_heroes( "b" );

	level thread bunker_1_mgs();
	level thread bunker_4_47mm();
	level thread bunker_friendlywave();
	level thread grenade_vignette();
	level thread mangrove_vo_3();
	
	start_teleport( "orig_start_bunkers" );		
	
	set_color_chain( "trig_chain_post_trap_4" );
	
	// have bunker_1_guys ignore intro_igc_guys
	setignoremegroup( "intro_igc_guys", "bunker_1_guys" );

	level thread bunkers();
	
}

start_flame()
{

	setup_level();
	
	level thread skipto_fog_set();
	
	BadPlacesEnable( 0 );
	
	level thread battle_line_ambient_sound();
	
	prepare_flame_bunker_aiming_origins();
	
	level.roebuck set_generic_run_anim( "roebuck_run", true ); 
	
	// put these guys closer 
	//////////////////////////

	amb_friends = simple_spawn( "bunker_2_ambient_friendlies" );
	for( i  = 0; i < amb_friends.size; i++ )
	{
		amb_friends[i] forceteleport( ( -125, -8808, -31.4 ) );
	}

	level.flamer = simple_spawn_single( "flamer_guy", ::flamer_spawn_strat );
	assertex( isdefined( level.flamer ), "level.flamer not defined! bad bad bad!" );

	level.flamer forceteleport( ( -125, -8808, -31.4 ) );
	level.flamer thread flamer_strat();
	level thread flame_squad_remainder();
	////////////////////////////////////	

	start_teleport( "orig_start_flame" );	
	
	//////////////////////////////////////////
	simple_floodspawn( "bunker_defenders", ::bunker_defenders_strat );


	level thread player_flame_bunker();

	level thread deadly_mgs();
	level thread bunker_stop_friendly_waves();

	array_thread( level.heroes, ::disable_ai_color );
	array_thread( level.heroes, ::bunkers_end_heroes_strat );
	
}



start_flamer_setup()
{
	
	level.flamer = simple_spawn_single( "flamer_guy" );
	assertex( isdefined( level.flamer ), "level.flamer not defined! bad bad bad!" );
	level.flamer.targetname = "friendly_squad";
	level.flamer.goalradius = 30;
	level.flamer.pacifist = 1;
	level.flamer.pacifistwait = 0.05;
	level.flamer.ignoreme = true;
	level.flamer.ignoresuppression = true;
	level.flamer.baseaccuracy = 0.05;
	level.flamer.dropweapon = false;
	level.flamer setcandamage( false );
	level.flamer thread magic_bullet_shield();
	level.flamer set_force_color( "y" );
	
}


start_forest()
{
	
	setup_level();

	level thread skipto_fog_set();

	level.roebuck set_generic_run_anim( "roebuck_run", true ); 

	set_color_heroes( "g" );

	flag_set( "trig_forest_friendlies" );
	
	set_color_chain( "chain_forest" );

	objective_position( 5, ( 2813, -3828, 89 ) );

	wait_network_frame();	// Let network clear out.

	// spawn drones
	if(!NumRemoteClients())
	{
		level thread maps\pel2_forest::forest_drones();
	}
	//wait( 0.1 );
	
	wait_network_frame();	// Let network clear out.
	
	// spawn friendlies
	level thread maps\pel2_forest::forest_friendlies();

	flag_set( "trig_flame_bunker_exit" );

	start_teleport( "orig_start_forest" );
	
	level thread maps\pel2_forest::forest_ambient_aa();
	level thread maps\pel2_forest::main();
	
}



start_admin()
{
	
	setup_level();

	level thread skipto_fog_set();

	level.roebuck set_generic_run_anim( "roebuck_run", true ); 

	forest_friends = simple_spawn( "friend_forest_spawner" );
	// don't want them being respawned in for any reason
	for( i  = 0; i < forest_friends.size; i++ )
	{
		forest_friends[i] disable_replace_on_death();
		forest_friends[i].targetname = "forest_friendly";
		forest_friends[i] set_force_color( "y" );
		forest_friends[i] forceteleport( ( 3078.5, -4222.5, 38.8 ) );
	}	
	
	set_color_heroes( "g" );
	set_color_chain( "trig_start_admin_delete" );

	start_teleport( "orig_start_admin" );


	// TEMP testing rifle grenade tutorial hud
	// TODO this shouldn't be done for every player
//	players = get_players();
//	for (i = 0; i < players.size; i++)
//	{
//		players[i] thread maps\pel2_forest::do_rifle_gren_hud_elem();
//	}		
	/////////////
	

	level thread maps\pel2_forest::admin_truck_victim();
	
	level thread maps\pel2_forest::forest_ambient_aa();
	level thread maps\pel2_forest::ambient_high_bombers();
	level thread maps\pel2_forest::admin_mg_guys();
	level thread maps\pel2_forest::admin_ai_pen();
	level thread maps\pel2_forest::building_battle();
	
}


// for debug only
start_debug_stairs()
{
	
	setup_level();

	getent( "trig_bunker_left_spawners", "targetname" ) delete();
	

	level.roebuck set_generic_run_anim( "roebuck_run", true ); 
	
	set_color_heroes( "g" );
	set_color_chain( "friendly_chain_admin_last" );

	level thread maps\pel2_forest::admin_staircase_run_cycle();

	start_teleport( "orig_start_stairs" );

}



start_airfield()
{

	setup_level();

	level thread skipto_fog_set();

	level.roebuck set_generic_run_anim( "roebuck_run", true ); 


	// ENTITY CLEANUP
	//////////////
	start_delete_garbage( -500, 4500, -6500, -13000 );
	
	deleted_spawners = 0;
	
	killspawner = 113;
	killspawner_2 = 207;
	
	spawners = GetSpawnerArray(); 
	
	for( i = 0 ; i < spawners.size ; i++ )
	{
		if( ( IsDefined( spawners[i].script_killspawner ) ) &&( killspawner == spawners[i].script_killspawner || killspawner_2 == spawners[i].script_killspawner ) )
		{
			spawners[i] Delete(); 
			deleted_spawners++;
		}
	}

	println( "garbage: total deleted spawners: " + deleted_spawners );
	//////////////
	// END ENTITY CLEANUP



	//level thread maps\pel2_forest::ambient_high_bombers();
	//wait( 0.05 );
	level thread maps\pel2_airfield::aa_ambient_fire();
	wait( 0.05 );
	level thread maps\pel2_airfield::airfield_mortars();
	wait( 0.05 );

	// delete spawn trigger that wouldve been hit in admin event
	trig = getent( "trig_bunker_left_spawners", "targetname" );
	trig delete();	
	trig = getent( "trig_admin_extra_middle_spawner", "script_noteworthy" );
	trig delete();		
	

	set_color_heroes( "g" );
	set_color_chain( "chain_admin_back" );
	
	// reinforcements that would be with you from admin event
	reinforcements = simple_spawn( "friend_admin_spawner" );
	extra_guy = simple_spawn( "friend_admin_spawner_2" );
	reinforcements = array_combine( reinforcements, extra_guy );
	for( i  = 0; i < reinforcements.size; i++ )
	{
		reinforcements[i] forceteleport( ( 2862, 190, 179 ) );
	}
	
	start_teleport( "orig_start_airfield" );

	wait( 0.25 );
	// start fire fx on airfield
	level thread maps\pel2_airfield::airfield_plane_fire();
	
	level thread maps\pel2_airfield::airfield_vo();
	
	/#
//	maps\pel2_airfield::debug_strafe_plane();
//	maps\pel2_airfield::debug_pole_plane();	
//	level thread debug_num_vehicles();
	#/
	
	maps\pel2_airfield::main();

}




start_aaguns()
{

	setup_level();
	
	level thread skipto_fog_set();
	
	level.roebuck set_generic_run_anim( "roebuck_run", true ); 
	
	getent( "trig_airfield_last_trench", "script_noteworthy" ) delete();
	
	flag_set( "chi_3_wave_dead" );
	
	// DEBUG TEMP
	/#
	level thread debug_tank_health();
	#/
	//		
	
	// reinforcements that would be with you from admin event
	reinforcements = simple_spawn( "friend_admin_spawner" );
	extra_guy = simple_spawn( "friend_admin_spawner_2" );
	reinforcements = array_combine( reinforcements, extra_guy );
	
	for( i  = 0; i < reinforcements.size; i++ )
	{
		reinforcements[i] forceteleport( ( 2932, 7240, 51.6 ) );
	}	
	
	start_teleport( "start_airfield_napalm" );

	set_color_heroes( "g" );
	set_color_chain( "trig_past_last_trench" );

	level thread maps\pel2_airfield::aa_ambient_fire();
	wait( 1 ); // give aaguns time to spawn
	level thread maps\pel2_airfield::trig_spawn_aa_mid_guys();
	level thread maps\pel2_airfield::plane_tower();
	level thread maps\pel2_airfield::tighten_up_color_chains();
	level thread maps\pel2_airfield::ambient_planes();
	level thread maps\pel2_airfield::last_aa_guns_objective();
	level thread maps\pel2_airfield::trig_spawn_aa_early_mid_guys();

	wait( 0.05 );
	level thread maps\pel2_airfield::plane_tower_aa_direct_fire();
	
	maps\pel2_airfield::last_aa_defense();	
	
}



start_napalm()
{

	setup_level();
	
	level thread skipto_fog_set();
	
	level.roebuck set_generic_run_anim( "roebuck_run", true ); 
	
	getent( "trig_airfield_last_trench", "script_noteworthy" ) delete();
	getent( "chain_center_of_aa_bunker", "targetname" ) delete();
	
	// get reinforcements going
	respawn_trig = getent( "auto5390", "target" );
	respawn_trig notify( "trigger" );
	
	// DEBUG TEMP
	/#
	level thread debug_tank_health();
	#/
	//		
	
	battlechatter_off();
	
	// reinforcements that would be with you from admin event
	reinforcements = simple_spawn( "friend_admin_spawner" );
	extra_guy = simple_spawn( "friend_admin_spawner_2" );
	reinforcements = array_combine( reinforcements, extra_guy );
	
	getent( "auto2608", "target" ) delete();		
	
	for( i  = 0; i < reinforcements.size; i++ )
	{
		reinforcements[i] forceteleport( ( 2619.5, 8199, 124 ) );
	}		
	
	start_teleport( "start_airfield_napalm_2" );

	// spawn aa guns
	////////////
	gun = maps\_vehicle::spawn_vehicle_from_targetname( "aaGun_2" );
	gun makevehicleusable(); 
	gun ClearTurretTarget(); 
	gun notify("change target");
	gun notify( "stop_friendlyfire_shield" );
	gun.health = 4000;
	gun = maps\_vehicle::spawn_vehicle_from_targetname( "aaGun_3" );	
	gun makevehicleusable(); 
	gun ClearTurretTarget(); 
	gun notify("change target");
	gun notify( "stop_friendlyfire_shield" );
	gun.health = 4000;
	////////////
	
	wait( 1.5 );



	// for viewing napalm reactions
	//////////////
//	level.roebuck.animname = "end_vignette_roebuck";
//	level.roebuck.end_node_goto = "node_end_roebuck";
//	
//	level.polonsky.animname = "end_vignette_polonsky";
//	level.polonsky.end_node_goto = "node_end_polonsky";
//	
//	level.extra_hero.animname = "end_vignette_radio";
//	level.extra_hero.end_node_goto = "node_end_extra_hero";
//
//	maps\pel2_airfield::post_pacing_positions( level.heroes );
//	
//	wait( 6 );
//	
//	level thread maps\pel2_airfield::napalm_reaction();
	//////////////



	// just for tank debug
	/////////////////
//	maps\pel2_airfield::spawn_aa_volume_trigs();
//	level thread maps\pel2_airfield::last_tanks_skipto_debug();
//	wait( 10000 );
	//////////////////


	// for playing out the last counterattack
	level thread maps\pel2_airfield::last_counterattack();
	wait( 10000 );
	///////////////////
	
	// for viewing napalm drops
	////////////////
//	level thread maps\pel2_airfield::napalm_planes_bomb_ridge();
//	level thread maps\pel2_airfield::napalm_planes();
//	level thread maps\pel2_airfield::napalm_destruction();
	////////////////	

	// viewing for outro fadeout
//	maps\pel2_airfield::end_of_level();
	////////////
}




skipto_fog_set()
{
	get_players()[0]SetVolFog( 940, 2560, 520, -55, 0.7, 0.62, 0.52, 1 );
}


/// DEBUG !!!!!!!!
airfield_temp_kill_axis()
{
	
	level endon( "stop_airfield_temp_kill_axis" );
	
	while( 1 )
	{
	
		ai = getaiarray( "axis" );
		
		for( i  = 0; i < ai.size; i++ )
		{
			ai[i] dodamage( 70, (0,0,0) );
		}
		
		wait( 2 );
		
	}
	
}



///////////////////
//
//  Sets up general friendly squad settings 
//
///////////////////////////////

setup_friendlies()
{

	level.heroes = [];
	
	level.roebuck = getent( "roebuck", "script_noteworthy" );
	level.roebuck.name = "Sgt. Roebuck";
	level.polonsky = getent( "polonsky", "script_noteworthy" );
	level.polonsky.name = "Pvt. Polonsky";
	level.extra_hero = getent( "king", "script_noteworthy" );

	level.heroes[0] = level.roebuck;
	level.heroes[1] = level.polonsky;
	level.heroes[2] = level.extra_hero;
	
	array_thread( level.heroes, ::friendly_setup_thread );

}



///////////////////
//
//  Set up the action in/around the bunkers
//
///////////////////////////////

bunkers()
{

	level thread clean_up_bunker_chains();

	level thread bunker_1_47mm();
	level thread bunker_2_47mm();
	level thread guys_47mm_4_radius_expand();
	level thread player_flame_bunker();
	level thread bunkers_vo();
	level thread spawn_bunkers_pickup_weapons();
	level thread save_near_first_bunker();
	level thread save_near_corsair_trap();
	level thread spawn_middle_at47();
	level thread bunker_ambient_trucks();

	// wait till players exit out of the mangroves
	// flag set on trigger
	flag_wait( "trig_setup_bunkers" );

	// cuz reflection probes process isn't checks this flag before all flags are init'ed in setup_level
	flag_set( "setup_bunkers_for_vision" );

	maps\_debug::set_event_printname( "Bunkers" );

	level notify( "obj_mangrove_complete" );
	
	// TUEY Sets the music state to be ENDSWAMP
	setmusicstate("ENDSWAMP");
	
	// TODO have these guys playerseek instead?
	// cleanup these guys in case there are any alive
	kill_aigroup( "mangrove_ambush_ai" );

	players_speed_set( 1.0, 3.5 );

	simple_spawn( "intro_frontline_axis" );

	// have frontline_axis pay more attention to intro_igc_guys
	// TEMP OFF FOR LEIPZIG
	//setthreatbias( "intro_igc_guys", "intro_frontline_axis", 600 );

  	// flag set on trigger. wait till player gets close to mg guys, then the beast awakens
	flag_wait( "trig_box_carry" );

	// TODO have these guys playerseek instead?
	// cleanup these guys in case there are any alive
	kill_aigroup( "mangrove_ambush_ai_2" );
	kill_aigroup( "mangrove_ambush_ai_3" );

	level thread box_carry();
	
	wait_network_frame(); // CLIENTSIDE to help snapshot size

	simple_floodspawn( "bunker_1_spawners" );
	wait_network_frame();
	simple_floodspawn( "bunker_1_pre_spawners", ::bunker_1_pre_spawners_strat );
	
	level thread chain_bunkers_entrance();
	level thread bunker_1_clear();
	level thread bunker_1_retreat();
	level thread spawn_bunker_2_front();
	
	level thread trig_grass_camo_guys();
	
	level thread guys_47mm_1_radius_expand();
	level thread guys_47mm_1_force_expand();
	level thread guys_47mm_2_radius_expand();
	level thread guys_frontline_radius_expand();
	level thread guys_frontline_radius_expand_2();
	level thread intro_tank_lookat();
	
	level notify( "on_dry_land" );
	array_thread( level.heroes, ::on_dry_land );	
	
	//TEMPVO TODO
	level.roebuck playsound( "bunker_clear" );
	
	bunkers_2();
	
}



///////////////////
//
// 2nd bunker action
//
///////////////////////////////

bunkers_2()
{
	
	// flag set on trigger
	flag_wait( "trig_bunker_2_start" );

	objective_position( 2, ( 669, -8859, -9 ) );

	kill_noteworthy_group( "47mm_1_noteworthy" );
	
	wait_network_frame();	// Let network clear out.

	level thread bunkers_2_spawns();
	level thread chain_bunkers_5();
	
	bunkers_end();
	
}



bunkers_2_spawns()
{

	simple_spawn( "bunker_2_mid_spawners" );
	wait_network_frame();
	simple_floodspawn( "far_trench_floodspawners" );
	wait_network_frame();
	simple_floodspawn( "bunker_2_mid_floodspawners" );	
	
	// flag set on trigger
	flag_wait( "bunker_2b_mid_spawners" );
	
	simple_floodspawn( "bunker_2b_mid_floodspawners" );
	wait( 0.05 );
	simple_spawn( "bunker_2b_mid_spawners" );
	
	wait( 1 );
	
	autosave_by_name( "Pel2 mid bunkers" );	
	
}



spawn_bunker_2_front()
{
	// flag set on trigger
	flag_wait( "trig_spawn_bunker_2_front" );
	simple_floodspawn( "bunker_2_front_floodspawners" );
}



///////////////////
//
// ambient trucks that drive off to the right side of the battle
//
///////////////////////////////

bunker_ambient_trucks()
{

	trigger_wait( "trig_ambient_bunker_trucks", "targetname" );
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 20 );
	
}



///////////////////
//
// Mgs in bunkers area that hold off marines' advance
//
///////////////////////////////

bunker_1_mgs()
{

	simple_spawn( "intro_mg_spawners" );

//	mg_1 = getent( "bunker_1_mg_1", "targetname" );
//	mg_2 = getent( "bunker_1_mg_2", "targetname" );
//	
//	mg_1 setturretignoregoals( true );
//	mg_2 setturretignoregoals( true );
	
}



///////////////////
//
// Guys that surprise the player by emerging from the foliage on the right trench path
//
///////////////////////////////

trig_grass_camo_guys()
{
	
	trigger_wait( "trig_grass_camo_guys_spawn", "targetname" );
	
	quick_text( "grass spawn" );
	
	simple_spawn( "grass_camo_guys_1", ::grass_camo_guys_1_strat );
	
	level endon( "grass_surprise" );
	
	// wait till player is close enough
	trigger_wait( "trig_grass_camo_guys", "targetname" );
	
	level thread trig_override( "trig_grass_lookat" );
	// wait for player to look in the grass guys' direction
	trigger_wait( "trig_grass_lookat", "targetname" );
	
	quick_text( "grass surprise lookat!" );
	flag_set( "grass_surprise" );
	
}



///////////////////
//
// sets a bunch of fields for the prone-to-run ambush guys (to keep them stealthy)
//
///////////////////////////////

init_ambush_fields()
{

	self allowedstances ( "prone" );
	self disableaimassist();
	self.a.pose = "prone"; 
	self.allowdeath = 1;
	self.pacifist = 1;
	self.pacifistwait = 0.05;
	self.ignoreall = 1;
	self.ignoreme = 1;
	self.ignoresuppression = 1;
	self.grenadeawareness = 0;
	self.disableArrivals = true;
	self.disableExits = true;
	self.drawoncompass = false;
	self.activatecrosshair = false;
	self.banzai_no_wait = 1;
	self.script_max_banzai_distance = 2000;
	self.animname = "bunkers";
	
	self.pel2_startled = false;
}



///////////////////
//
// resets a bunch of fields for the prone-to-run ambush guys (to make them active again)
//
///////////////////////////////

clear_ambush_fields()
{

	self.activatecrosshair = true;
	self enableaimassist();
	self.drawoncompass = true;
	self allowedstances( "stand" );
	self.a.pose = "stand"; 
	self.pacifist = 0;
	self.ignoreall = 0;
	self.grenadeawareness = 0.2;
	self.disableArrivals = false;
	self.disableExits = false;

	self notify( "clear_ambush_fields" );
	
}



///////////////////
//
// choose which variant prone-to-run anim to use
//
///////////////////////////////

choose_prone_to_run_anim_variant()
{

	prone_anims = [];
	prone_anims[prone_anims.size] = level.scr_anim["bunkers"]["prone_anim_fast_a"];
	prone_anims[prone_anims.size] = level.scr_anim["bunkers"]["prone_anim_fast_b"];
	prone_anims[prone_anims.size] = level.scr_anim["bunkers"]["prone_anim_fast_c"];
	
	return prone_anims[randomint(prone_anims.size)];
	
}
	


grass_camo_guys_1_strat()
{

	self endon( "death" );

	self thread magic_bullet_shield();
	//self setcandamage( false );
	
	// keep him stealthy
	self init_ambush_fields();
	
	self thread grass_bunkers_surprise_damage( "grass_surprise_damage" );
	// waittill either they receive damage or if the player gets close enough
	flag_wait_either( "grass_surprise_damage", "grass_surprise" );

	// stagger their emergence times if necessary
	if( isdefined( self.script_float ) )
	{
		wait( self.script_float );
	}

	self setcandamage( true );
	// shield may have been turned off already from grass_bunkers_surprise_damage()
	if( IsDefined( self.magic_bullet_shield ) && self.magic_bullet_shield )
	{
		self stop_magic_bullet_shield();
	}

	// make him active again
	self clear_ambush_fields();

	self thread grass_surprise_half_shield( 4 );
	self thread grass_camo_ignore_delay( 4 );
	
	// choose which variant anim to use
	prone_anim = choose_prone_to_run_anim_variant();
	level.animtimefudge = 0.05;
	self play_anim_end_early( prone_anim, level.animtimefudge );		
	
	self thread maps\_banzai::banzai_force();

}



///////////////////
//
// Protect the grass guys from all damage except from the player
//
///////////////////////////////

grass_surprise_half_shield( delay_time )
{

	level endon( "stop_grass_half_shields" );
	self endon( "death" );
	
	self thread grass_camo_halfshield_delay( delay_time );
	
	self.pel2_real_health = self.health;
	self.health = 10000;
	
	attacker = undefined; 
	
	while( self.health > 0 )
	{
		
		self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName );
		
		type = tolower( type );
		
		// if it's not the player, and also a bullet weapon (non-player friendlies should still be able to kill them with their grenades)
		if( !isplayer(attacker) && issubstr( type, "bullet" ) )
		{
			//iprintln( "attacked by non-player!" );
			self.health = 10000;  // give back health for these things	
		}
		else
		{
			self.health = self.pel2_real_health;
			self dodamage( amount, (0,0,0) );
			self.pel2_real_health = self.health;
			// put ff shield back on
			self.health = 10000;
		}
	}	
	
}



grass_camo_ignore_delay( wait_time )
{
	self endon( "death" );

	wait( wait_time );
	self.ignoreme = 0;
}



grass_camo_halfshield_delay( delay_time )
{
	self endon( "death" );

	wait( delay_time );
	level notify( "stop_grass_half_shields" );
	self.health = self.pel2_real_health;
}



///////////////////
//
// sets flag(s) if guy has been damaged
//
///////////////////////////////

grass_bunkers_surprise_damage( flag_name )
{

	self endon( "clear_ambush_fields" );
	level endon( flag_name );

	while( 1 )
	{

		 self waittill( "damage", amount, attacker );
	 
		if( isplayer( attacker ) )
		{
			
			// if the amount is enough to kill the guy, give achievement
			if( amount >= self.mbs_oldhealth )
			{
				attacker giveachievement_wrapper( "ANY_ACHIEVEMENT_GRASSJAP" ); 	
			}			
			
			self stop_magic_bullet_shield();
			self setcandamage( true );
			
			self dodamage( amount, (0,0,0) );
			
			self.pel2_startled = true;
			
			quick_text( "grass surprise damage!" );
			flag_set( flag_name );
			
		}
	
	}
	
}



///////////////////
//
// Initial values set for flamer when he spawns
//
///////////////////////////////

flamer_spawn_strat()
{

	self thread magic_bullet_shield();	
	self setcandamage( false );

	// flame settings
	self.a.flamethrowerShootTime_min = 10000;
	self.a.flamethrowerShootTime_max = 15000;
	self.a.flamethrowerShootDelay_min = 0;
	self.a.flamethrowerShootDelay_max = 1;

	self.animname = "flamebunker";
	self.targetname = "friendly_squad";
	self.goalradius = 20;
	self.pacifist = 1;
	self.pacifistwait = 0.05;
	self.ignoreme = true;
	self.ignoresuppression = true;
	self.grenadeawareness = 0;
	self.baseaccuracy = 0.05;
	self.dropweapon = false;

	self toggleik( false );
	
}



///////////////////
//
// Flame guy burns out bunker 2
//
///////////////////////////////

flamer_advance_bunkers()
{

	self.moveplaybackrate = 1.25;
	
	goal_node = getnode( "node_flamer_advance_1", "targetname" );
	self setgoalnode( goal_node );
	self waittill( "goal" );

	flag_set( "flamer_at_first_advance_node" );

	BadPlacesEnable( 0 );

	self.moveplaybackrate = 1;
	self.pacifist = 0;
	
	fire_spot_1 = convert_aiming_struct_to_origin( "orig_flame_advance_1" );
	fire_spot_2 = convert_aiming_struct_to_origin( "orig_flame_advance_2" );
	fire_spot_3 = convert_aiming_struct_to_origin( "orig_flame_advance_3" );
	
	vol = getent( "vol_flame_advance_1", "targetname" );
	if( !any_player_istouching( vol ) && !flag( "flamer_advance_to_hide" ) )
	{
	
		level thread flame_move_target( fire_spot_1, 2.5 );	
		self thread flame_burst( fire_spot_1, "flamer_advance_to_2" );
		level thread temp_advance( 7, "flamer_advance_to_2" );
		
		flag_wait( "flamer_advance_to_2" );
		self ClearEntityTarget();	
	
	}
	
	// if he isn't needed yet at the flame truck, advance to the next bunker 2 spot
	if( !flag( "flamer_advance_to_hide" ) )
	{
		goal_node = getnode( "node_flamer_advance_2", "targetname" );
		self setgoalnode( goal_node );
		self waittill( "goal" );
	}

	vol = getent( "vol_flame_advance_2", "targetname" );
	if( !any_player_istouching( vol ) && !flag( "flamer_advance_to_hide" ) )
	{

		level thread flame_move_target( fire_spot_2, 2.5 );	
		self thread flame_burst( fire_spot_2, "flamer_advance_to_3" );
		level thread flame_burst_ensure_dmg( "vol_flame_advance_2" );
		level thread temp_advance( 7, "flamer_advance_to_3" );
		
		flag_wait( "flamer_advance_to_3" );
		self ClearEntityTarget();		
	
	}
	
	// if he isn't needed yet at the flame truck, advance to the next bunker 2 spot
	if( !flag( "flamer_advance_to_hide" ) )
	{
		goal_node = getnode( "node_flamer_advance_3", "targetname" );
		self setgoalnode( goal_node );
		self waittill( "goal" );
	}


	vol = getent( "vol_flame_advance_3", "targetname" );
	if( !any_player_istouching( vol ) && !flag( "flamer_advance_to_hide" ) )
	{

		level thread flame_move_target( fire_spot_3, 2.5 );	
		self thread flame_burst( fire_spot_3, "flamer_advance_to_hide" );
		level thread flame_burst_ensure_dmg( "vol_flame_advance_3" );
		level thread temp_advance( 7, "flamer_advance_to_hide" );

		flag_wait( "flamer_advance_to_hide" );
		self ClearEntityTarget();
	
	}
	
	goal_node = getnode( "node_flame_hide", "targetname" );
	self setgoalnode( goal_node );	
	
	// delete fire origins
	fire_spot_1 notify( "stop_fakefire_mover" );
	fire_spot_1 delete();
	fire_spot_2 notify( "stop_fakefire_mover" );
	fire_spot_2 delete();
	fire_spot_3 notify( "stop_fakefire_mover" );
	fire_spot_3 delete();
	
}



flame_burst_ensure_dmg( vol_name )
{
	wait( 1.35 );
	
	guys = getAIarrayTouchingVolume( "axis", vol_name );
	
	for( i  = 0; i < guys.size; i++ )
	{
		guys[i].a.forceflamedeath = 1;
		guys[i] dodamage( guys[i].health + 50, (0,0,0) );	
	}	
	
}



flame_burst( fire_spot, flag_notify )
{
	
	level endon( flag_notify );
	
	while( 1 )
	{
			
		self SetEntityTarget( fire_spot );
		wait( RandomFloatRange( 2.75, 3.75 ) );
		self ClearEntityTarget();
		self StopShoot();
		wait( RandomFloatRange( 0.9, 1.6 ) );
		
	}

}



temp_advance( time, flag_name )
{
	wait( time );
	flag_set( flag_name );
}



///////////////////
//
// Strategy for guy that flames end bunkers
//
///////////////////////////////

flamer_strat()
{

	// get him near the trucks
	node_truck_flame = getnode( "node_flame_truck", "targetname" );
	self setgoalnode( node_truck_flame );
	self waittill( "goal" );
	
	// get heroes in place
	array_thread( level.heroes, ::disable_ai_color );
	level thread bunkers_end_heros_in_place();	
	level thread smoke_grenade_on_the_scene();
	
	// have him open fire on the truck
	flame_truck();

	level thread flame_bunker_vo();
	level thread flame_bunker_vo_2();
	level thread bunker_prepare_flame();
	level thread flame_bunker_continue();
	level thread flame_squad_remainder();
	level thread bunker_killed_but_not_flamed();
	level thread bunker_killed_with_barrels();
	
	// so he transitions to his cover spot (arrivals are off by default for flame ai)	
	self.disablearrivals = false;
	self.disableexits = false;	
	// have him take cover near the truck
	goal_node = getnode( "node_advance_end_bunkers_flame", "targetname" );
	self setgoalnode( goal_node );
	self set_force_cover( "hide" );
	self waittill( "goal" );

	level thread mgs_targets_move();
	
	level.current_mg_focus = "both_flamer";
	if( !level.player_being_targetted )
	{
		level thread mgs_focus_on_origins( level.current_mg_focus );
	}
	
	// have him take cover for a second before moving up
	wait( RandomFloatRange( 2.25, 3.0 ) );
	
	level.current_mg_focus = "both_berm";
	if( !level.player_being_targetted )
	{
		level thread mgs_focus_on_origins( level.current_mg_focus );
	}
	
	level thread mg_focus_both_berm_delay();
	
	// send flamer to the mound
	goal_node = getnode( "node_end_bunker_flame", "targetname" );
	self setgoalnode( goal_node ); // get him to do his transition out first, as anim_reach won't play transitions
	wait( 1.5 );
	anim_reach_solo( self, "flamebunker_a", undefined, goal_node );
	anim_single_solo( self, "flamebunker_a", undefined, goal_node );	
	level thread anim_loop_solo( self, "flamebunker_cover", undefined, "bunker_suppressed_twice", goal_node );		

	// reset value 
	level.bunker_mg_damage_total = 0;
		
	// waittill bunker mg is distracted by suppression fire	a second time
	level thread bunker_distract( "bunker_distract_2" );
	
	flag_wait( "bunker_distract_2" );

	level thread mgs_focus_on_flamer();
	
	// some time for the gunners to pick up the flamer as their target
	wait( 0.75 );


	
	quick_text( "bunker suppressed twice!", 3, true );
	level notify( "bunker_suppressed_twice" );

	self.pacifist = 0;
	
	anim_single_solo( self, "flamebunker_death", undefined, goal_node );
	
	bunker_defenders_reduce_count();
	
	self thread flamer_strat_fake_death( goal_node );
	
	level thread player_pickup_flamethrower( self );

	flag_set( "flame_guy_killed" );
	playsoundatposition("flame_stinger", (0,0,0));

	
	
}



flamer_strat_fake_death( goal_node )
{

	level endon( "stop_flamer_fake_death" );



	self thread anim_loop_solo( self, "flamebunker_death_loop", undefined, "stop_flamebunker_death_loop", goal_node );
	self.deathanim = level.scr_anim["flamebunker"]["flamebunker_death_loop"][0];

	flag_wait( "player_got_flamethrower" );

	//tuey sets music state to PLAYER_GETS_FLAMETHROWER
	setmusicstate("PLAYER_GETS_FLAMETHROWER");

	// remove glowy flamethrower; player just took it
	if( flag( "flamethrower_now_non_glowy" ) )
	{
		self detach( "char_usa_marine_helmf" );	
	}
	else
	{
		self detach( "char_usa_marine_helmf_obj" );	
	}
	
	// detach the actual weapon model (separate than the gearmodel, which includes the tank on the back)
	self animscripts\shared::placeWeaponOn( self.primaryweapon, "none");

	self notify( "stop_flamebunker_death_loop" );

	self setcandamage( true );
	self stop_magic_bullet_shield();
	self dodamage( self.health + 1, (0,0,0) );
	
}



///////////////////
//
// allow player to pickup flamethrower off flamer. he's not actually killed here, it's just faked. he needs to be alive in order
// to do the glowy model swap. he'll be killed through script as soon as the player grabs the weapon, or if they proceed to the middle
// of the next event
//
///////////////////////////////

player_pickup_flamethrower( guy )
{

	// so he doesn't try any funny business
	guy.pacifist = true;
	guy.pacifistwait = 0.05;
	guy.ignoreall = true;
	guy.ignoreme = 1;

	// make flamethrower glowy so player notices it
	guy detach( "char_usa_marine_helmf" );	
	guy attach( "char_usa_marine_helmf_obj" );	

	// spawn glowy flamethrower for player to pickup  & use
	flamethrower_origin = (-308, -7685.3, -15);
	flamethrower_pickup = spawn( "weapon_m2_flamethrower", flamethrower_origin, 1 );
	flamethrower_pickup.angles = (0, 249, -90);
	flamethrower_pickup hide();
	
	objective_string( 3, &"PEL2_RETRIEVE_FLAME" );
	objective_position( 3, flamethrower_origin );
	objective_ring( 3 );

	autosave_by_name( "Pel2 pickup flamethrower" );

}



///////////////////
//
// if player manages to kill all the enemies in the flame bunker
//
///////////////////////////////

bunker_killed_but_not_flamed()
{

	level endon( "bunkers_flamed" );
	
	waittill_aigroupcleared( "last_bunker_ai_1" );
	waittill_aigroupcleared( "last_bunker_ai_2" );
	
	// destroy barrels to start chain reaction
	radiusdamage( (-377.5, -6863.5, -31), 100, 100, 100 );
	
	wait( RandomFloatRange( 0.9, 1.7 ) );
	
	flag_set( "bunker_killed_but_not_flamed" );
	
}



///////////////////
//
// if player starts a chain-reaction by shooting the barrels inside the bunker
//
///////////////////////////////

bunker_killed_with_barrels()
{
	
	level endon( "bunkers_flamed" );

	while( 1 )
	{
	
		barrels = getentarray( "bunker_barrels", "script_noteworthy" );
		barrels_with_health = 0;
	
		// check if any of the barrels have been shot/destroyed
		for( i  = 0; i < barrels.size; i++ )
		{
			if( barrels[i].health >= 0 )
			{
				barrels_with_health++;
			}
		}
		
		if( barrels_with_health == 0 )
		{
			break;	
		}
		// others might not have been damaged by the initial splash, so give em a chance to explode and then do it manually if needed
		else if( barrels_with_health <= 3 )
		{
			wait( 2 );
			radiusdamage( (-377.5, -6863.5, -31), 100, 100, 100 );
			break;
		}
		
		wait( 0.25 );
		
	}	

	quick_text( "bunker_killed_with_barrels !!!" );
	//println( "bunker_killed_with_barrels !!!" );

	flag_wait( "flame_guy_killed" );

	flag_set( "bunker_killed_but_not_flamed" );
	
}



///////////////////
//
// Once the flamethrower is retrievable, lower the mg defenders' count so the player can kill them all and still proceed
//
///////////////////////////////

bunker_defenders_reduce_count()
{

	bunker_defender_spawners = getentarray( "bunker_defenders", "targetname" );
	for( i  = 0; i < bunker_defender_spawners.size; i++ )
	{
		if( bunker_defender_spawners[i].count > 2 )
		{
			bunker_defender_spawners[i].count = 2;
		}
	}
	
}



///////////////////
//
// want mgs to eventually start re-target flamer & berm
//
///////////////////////////////

mg_focus_both_berm_delay()
{
	
	level endon( "bunker_window_1_flamed" );	
	level endon( "bunker_distract_2" );
	
	wait( 6.5 );
	
	level.current_mg_focus = "left_flamer_right_berm";
	if( !level.player_being_targetted )
	{
		level thread mgs_focus_on_origins( level.current_mg_focus );
	}	
	
}



///////////////////
//
// Moves script origins back and forth (that the flame bunker mgs target)
//
///////////////////////////////

mgs_targets_move()
{

	// start moving mg script origins 
	mg_targets = [];
	mg_targets[0] = getent( "bunker_end_target_1_converted", "targetname" );
	mg_targets[1] = getent( "bunker_end_target_2_converted", "targetname" );
	mg_targets[2] = getent( "bunker_end_target_3_converted", "targetname" );
	mg_targets[3] = getent( "bunker_end_target_1a_converted", "targetname" );
	mg_targets[4] = getent( "bunker_end_target_2a_converted", "targetname" );
	
	level thread flame_move_target( mg_targets[0], 3.75 );
	level thread flame_move_target( mg_targets[1], 4.75 );
	level thread flame_move_target( mg_targets[2], 3.75 );	
	level thread flame_move_target( mg_targets[3], 3.75 );	
	level thread flame_move_target( mg_targets[4], 3.25 );	
	
	flag_wait( "bunkers_flamed" );
	
	// stop moving script origins
	for( i  = 0; i < mg_targets.size; i++ )
	{
		mg_targets[i] notify( "stop_fakefire_mover" );
		mg_targets[i] delete();
	}	
	
}



bunker_distract( which_flag )
{

	damage_total = 0;
	damage_trig = getent( "trig_damage_end_bunker", "targetname" );

	// make sure player hits the bunker at least a few times
	while( level.bunker_mg_damage_total < 500 )
	{
	
		damage_trig waittill( "damage", damage_amount, attacker );
	
		// only register damage from the player or heroes
		if(  IsPlayer( attacker ) )
		{
			level.bunker_mg_damage_total += damage_amount;
			quick_text( "damage_total: " + level.bunker_mg_damage_total );
		}
		else if( (level.roebuck == attacker) || (level.polonsky == attacker) || (level.extra_hero == attacker) )
		{
			level.bunker_mg_damage_total += damage_amount/6;
			quick_text( "damage_total: " + level.bunker_mg_damage_total );
		}
		
	}
	
	flag_set( which_flag );
	
}



///////////////////
//
// Player has arrived at end bunker area
//
///////////////////////////////

bunkers_end()
{

	// flag set on trigger
	flag_wait( "trig_end_bunkers" );
	
	level notify( "obj_bunkers_complete" );
	
	// prepare aiming origins
	prepare_flame_bunker_aiming_origins();
	
	flag_set( "flamer_advance_to_hide" );
	
	simple_spawn( "forest_truck_spawners", ::forest_truck_spawners_strat );
	wait_network_frame(); // CLIENTSIDE to help snapshot size
	simple_floodspawn( "bunker_defenders", ::bunker_defenders_strat );
	wait_network_frame();
	level thread flame_truck_setup();
	level thread bunker_stop_friendly_waves();


}



prepare_flame_bunker_aiming_origins()
{
	convert_aiming_struct_to_origin( "bunker_end_target_1" );
	convert_aiming_struct_to_origin( "bunker_end_target_2" );
	convert_aiming_struct_to_origin( "bunker_end_target_3" );
	convert_aiming_struct_to_origin( "bunker_end_target_1a" );
	convert_aiming_struct_to_origin( "bunker_end_target_2a" );
}



forest_truck_spawners_strat()
{
	self endon( "death" );
	self.ignoresuppression = 1;
}



///////////////////
//
// MGs in bunker that gets flamed
//
///////////////////////////////

deadly_mgs()
{

	level thread bunker_mg_killzone();

	turret = getent( "flame_bunker_mg_r", "targetname" );
	turret setTurretTeam( "axis" );
	turret SetMode( "auto_ai" );
	turret setturretignoregoals( true );
	turret thread maps\_mgturret::burst_fire_unmanned();

	turret = getent( "flame_bunker_mg_l", "targetname" );
	turret setTurretTeam( "axis" );
	turret SetMode( "auto_ai" );
	turret setturretignoregoals( true );
	turret thread maps\_mgturret::burst_fire_unmanned();
	
}



///////////////////
//
// Truck that gets flamed
//
///////////////////////////////

flame_truck_setup()
{
	
	// flag set on trigger
	flag_wait( "trig_flame_truck" );

	autosave_by_name("Pel2 flame truck" );


	
	level thread deadly_mgs();
	
	quick_text( "flame_truck", 3, true );

	assertex( isdefined( level.flamer ), "bunker_flamer not defined! bad bad bad!" );
	
	level.flamer thread flamer_strat();
	
}



///////////////////
//
// Handles the event where the player flames the bunker to progress to the dunes pacing area
// 
///////////////////////////////

player_flame_bunker()
{
	
	level endon( "bunker_killed_but_not_flamed" );
	
	flag_wait( "flame_guy_killed" );

	//tuey sets music state to FLAME_THROWER_GUY_DEAD
	setmusicstate("FLAMER_DIED");

	damage_total = 0;
	damage_trig = getent( "trig_damage_end_bunker_flame", "targetname" );
	
	flame_bunker_mg_damage_total = 0;

	// make sure player hits the bunker at least a few times
	while( flame_bunker_mg_damage_total < 35000 )
	{
	
		damage_trig waittill( "damage", damage_amount, attacker, direction_vec, point, type );
	
		type = tolower( type );
	
		// only register fire damage from the player
		if(  IsPlayer( attacker ) && type == "mod_burned" && damage_amount >= 5 )
		{
			flame_bunker_mg_damage_total += damage_amount;
			quick_text( "damage_total: " + flame_bunker_mg_damage_total + " amount: " + damage_amount, undefined, true);
		}
		
	}
	
	flag_set( "bunker_window_1_flamed" );	
	
	level thread bunker_window_1_flamed_delay();
	
	while( flame_bunker_mg_damage_total < 70000 )
	{
	
		damage_trig waittill( "damage", damage_amount, attacker, direction_vec, point, type );
	
		type = tolower( type );
	
		// only register fire damage from the player
		if(  IsPlayer( attacker ) && type == "mod_burned" && damage_amount >= 5 )
		{
			flame_bunker_mg_damage_total += damage_amount;
			quick_text( "damage_total: " + flame_bunker_mg_damage_total + " amount: " + damage_amount, undefined, true);
		}
		
	}	
	
	flag_set( "bunker_window_2_flamed" );	
	
}



///////////////////
//
// MGs target player briefly after he does some damage with the flamethrower
//
///////////////////////////////

bunker_window_1_flamed_delay()
{

	level.force_player_being_targetted = true;
	
	wait( RandomIntRange( 3, 5 ) );
	
	level.force_player_being_targetted = false;
	
}



///////////////////
//
// action that occurs during bunker flaming and afterwards
//
///////////////////////////////

flame_bunker_continue()
{
	
	flag_wait_either( "bunker_window_1_flamed", "bunker_killed_but_not_flamed" );	
	
	// turn off turret 1
	turret = getent( "flame_bunker_mg_l", "targetname" );
	turret cleartargetentity();
	turret SetMode( "auto_ai" );	
	turret notify( "death" );
	
	maps\_spawner::kill_spawnernum( 111 );

	flag_wait_either( "bunker_window_2_flamed", "bunker_killed_but_not_flamed" );	

	// turn off turret 2
	turret = getent( "flame_bunker_mg_r", "targetname" );
	turret cleartargetentity();
	turret SetMode( "auto_ai" );	
	turret notify( "death" );

	maps\_spawner::kill_spawnernum( 112 );
	
	flag_set( "bunkers_flamed" );
	
	BadPlacesEnable( 1 );
	
	bunkers_flame_pre_explosions();
	
	
	guy_1 = get_ai_group_ai( "last_bunker_ai_1" );
	guy_2 = get_ai_group_ai( "last_bunker_ai_2" );
	guys = array_combine( guy_1, guy_2 );
	for( i  = 0; i < guys.size; i++ )
	{
		guys[i].a.special = "none";
		guys[i].a.forceflamedeath = 1;
	}


	kill_aigroup( "last_bunker_ai_1" );
	kill_aigroup( "last_bunker_ai_2" );	
	
	// bunker explodes, creating a hole in the wall
	level thread blow_hole_in_bunker_wall();
	
	level notify( "obj_flame_complete" );

	// turn off glowy flamethrower if not off already
	if( !flag( "player_got_flamethrower" ) )
	{
		level.flamer detach( "char_usa_marine_helmf_obj" );			
		level.flamer attach( "char_usa_marine_helmf" );	
		flag_set( "flamethrower_now_non_glowy" );
		level thread player_got_flamethrower_after_obj();
	}

	level thread bunkers_flamed_fx();
	level thread flame_bunker_inside();
	level thread chain_bunker_flame_back();	

	// bunkers are flamed, set guys back to normal
	for( i  = 0; i < level.heroes.size; i++ )
	{
		level.heroes[i].pacifist = 0;
		level.heroes[i].ignoreall = 0;
		level.heroes[i].ignoresuppression = 0;	
	}
	
	set_color_heroes( "g" );
	set_color_chain( "bunker_end_cleanup_chain" );
	
	// make no one ignored
	guys = getaiarray( "allies" );
	array_thread( guys, ::set_ignoreme_off );
	set_players_ignoreme( false );	

	wait( 1.5 );

	autosave_by_name( "Pel2 bunkers flamed" );
	
	wait( 4.5 );
	
	// flag set on trigger
	flag_wait( "trig_near_bunker_door" );
	
	set_color_chain( "chain_inside_flame_bunker" );
	
	// flag set on trigger
	flag_wait( "trig_flame_bunker_exit" );
	
	objective_position( 3, ( 2813, -3828, 89 ) );
	
	wait_network_frame();	// let network clear out.
	
	maps\pel2_forest::main();		
	
}



///////////////////
//
// in case the player picks up the flamethrower after the bunker has been destroyed
//
///////////////////////////////

player_got_flamethrower_after_obj()
{
	
	level endon( "stop_flamer_fake_death" );

	// wait till a guy gets the flamethrower
	while( !flag( "player_got_flamethrower" ) )
	{
		
		players = get_players();
		for( i  = 0; i < players.size; i++ )
		{
			if( players[i] HasWeapon( "m2_flamethrower" ) )
			{
				flag_set( "player_got_flamethrower" );
				break;
			}
			
		}
		
		wait( 0.5 );
		
	}
	
}


	

///////////////////
//
// chain reaction explosions before the big one that blows the doorway open
//
///////////////////////////////

bunkers_flame_pre_explosions()
{

	level thread chain_reaction_fx();

	// destroy barrels if they're not already blown up
	radiusdamage( (-377.5, -6863.5, -31), 170, 200, 150 );
	radiusdamage( (-126.7, -6883.5, -47.8), 30, 200, 150 );

	orig = getstruct( "orig_bunker_flame_fx_1", "targetname" );
	
	earthquake( 0.4, 1.0, orig.origin, 800 );
	PlayRumbleOnPosition( "explosion_generic", orig.origin ); 	
	playsoundatposition ("bomb_far_falloff_1", orig.origin);
	
	level thread bunkers_flame_pre_explosions_vo();
	
	wait( RandomFloatRange( 1.3, 1.7 ) );

	earthquake( 0.5, 1.2, orig.origin, 900 );
	PlayRumbleOnPosition( "explosion_generic", orig.origin ); 	
	playsoundatposition ("bomb_far_falloff_2", orig.origin);

	wait( RandomFloatRange( 1.25, 1.5 ) );

	// TUEY Sets the music state to be AFTERBUNKER
	setmusicstate("AFTERBUNKER");

	
}



chain_reaction_fx()
{

	level endon( "obj_flame_complete" );

	fx_origins = getstructarray( "orig_bunker_chain_reaction", "targetname" );

	while( 1 )
	{

		fx_orig = fx_origins[randomint(fx_origins.size)];
		playfx( level._effect["bunker_chain_reaction"], fx_orig.origin, anglestoforward(fx_orig.angles) );		
	
		wait( 0.5 );
	
	}
	
}





bunkers_flame_pre_explosions_vo()
{
	
	play_vo( level.roebuck, "vo", "its_gonna_blow" );
	wait( 1 );
	play_vo( level.roebuck, "vo", "get_outta_here" );
		
}




///////////////////
//
// fx and brush deletion for the entryway into the flame bunker
//
///////////////////////////////

blow_hole_in_bunker_wall()
{
	
	wall = getent( "brush_flame_bunker", "targetname" );
	wall connectpaths();
	wall delete();
	
	fx_orig = getstruct( "orig_bunker_flame_explode", "targetname" );
	//playfx( level._effect["orig_mortar_airfield_sw"], fx_orig.origin, anglestoforward(fx_orig.angles ) );		
	exploder( 202 );
	exploder( 201 );
	
	temp_sound_orig = spawn( "script_origin", fx_orig.origin );
	temp_sound_orig playsound( "wall_explo", "wall_explo_done" );
	temp_sound_orig waittill( "wall_explo_done"  );
	temp_sound_orig delete();
	
}



///////////////////
//
// canned guys spawned inside the flame bunker right after it explodes
//
///////////////////////////////

flame_bunker_inside()
{
	
	flag_wait( "trig_flame_bunker_inside" );
	simple_spawn( "flame_bunker_defenders_2" );
	wait( 1 );
	level thread maps\pel2_forest::forest_friendlies();
	
}



chain_bunker_flame_back()
{
	
	level endon( "trig_flame_bunker_exit" );
	
	waittill_aigroupcleared( "flame_bunker_defenders_ai_2" );
	
	chain_trig = getent( "chain_bunker_flame_back", "targetname" );
	if( isdefined( chain_trig ) )
	{
		chain_trig notify( "trigger" );	
	}
	
}



bunkers_flamed_fx()
{

	// TODO
	// sometimes this has gotten hung up at 
	// spawn waittill( "finished spawning" ); 
	// in spawn_failed() in _utility.gsc. not sure why that would happen only here, but i'm gonna thread this just to be safe. if
	// the scene ever plays out without the guys burning on the inside, then the spawn probably failed somehow
	level thread simple_spawn( "bunker_post_flame_spawners", ::bunker_post_flame_strat );
	
	// TEMP FX
	orig = getstruct( "orig_bunker_flame_fx_1", "targetname" );
	
	earthquake( 0.75, 1.75, orig.origin, 1500 );
	PlayRumbleOnPosition( "explosion_generic", orig.origin ); 
	
}



bunker_post_flame_strat()
{

	self endon( "death" );

	self.health = 1;
	self.ignoreme = true;
	self.ignoreall = true;

	if( !isdefined( self.finished_spawning ) )
	{
		wait( 0.05 );	
		println( "*** GUZZO FIX THIS IF IT'S SPAMMING! --- bunker_post_flame_strat()" );
	}

	if( isdefined( self.script_noteworthy ) && self.script_noteworthy == "table_climb_guy" )
	{

		self animscripts\shared::placeWeaponOn( self.primaryweapon, "none");
		
		self.animname = "bunkers";
		
		self.allowdeath = true;
		self.a.nodeath = true;
		
		level thread stop_table_death( self );
		
		// fire that spawns on the guy & charring behavior
		self thread animscripts\death::flame_death_fx();
		
		anim_node = getnode( "node_flame_bunker_explode", "targetname" );
		
		anim_single_solo( self, "dazed_table", undefined, anim_node );		
		self dodamage( self.health + 1, (0,0,0) );
		
	}
	else
	{
		self.a.special = "none";
		self.a.forceflamedeath = true;	
		self dodamage( self.health + 1, (0,0,0) );
	}
	
}


stop_table_death( guy )
{
	guy waittill( "death" );
	guy startRagdoll();
}




///////////////////
//
// VO for flaming the flame bunker
//
///////////////////////////////

flame_bunker_vo()
{

	level endon( "bunker_window_1_flamed" );
	level endon( "bunker_killed_but_not_flamed" );
	
	flag_wait( "flame_guy_killed" );

	wait( 2.0 );

	level thread flame_bunker_get_flame_vo();
	level thread bunker_defenders_rhythm_stop();

	// wait till a guy gets the flamethrower
	while( !flag( "player_got_flamethrower" ) )
	{
		
		players = get_players();
		for( i  = 0; i < players.size; i++ )
		{
			if( players[i] HasWeapon( "m2_flamethrower" ) )
			{
				flag_set( "player_got_flamethrower" );
				
				objective_string( 3, &"PEL2_FLAME_BUNKER" );
				objective_position( 3, (-281, -7098, -26) );
				objective_ring( 3 );
				
				break;
			}
			
		}
		
		wait( 0.5 );
		
	}
	
	// give VO support on what to do
	while( !flag( "bunker_window_1_flamed" ) )
	{
		
		random_int = randomint( 100 );
		// choose which VO variation to play
		if( random_int > 66 )
		{
			play_vo( level.roebuck, "vo", "burn_those_mgs" );
		}
		else if( random_int > 33 )
		{
			play_vo( level.roebuck, "vo", "get_that_flamethrower_on" );
		}
		else
		{
			play_vo( level.roebuck, "vo", "burn_em_out" );
		}
		
		objective_ring( 3 );
		wait( RandomIntRange( 10, 17 ) );
	}	
	
}



flame_bunker_get_flame_vo()
{
	
	wait( 1 );
	
	play_vo( level.roebuck, "vo", "get_the_flamethrower" );	
	
	level endon( "bunkers_flamed" );
	
	wait( 5 );
	
	vo_just_played = false;
	
	while( !flag( "player_got_flamethrower" ) )
	{
		
		flag_wait( "flame_bunker_rhythm_stop" );
		
		if( !vo_just_played )
		{
			wait( 1.75 );
			
			if( RandomInt( 2 ) )
			{
				play_vo( level.roebuck, "vo", "get_the_flamethrower" );	
			}
			else
			{
				play_vo( level.roebuck, "vo", "use_that_flamethrower" );	
			}
			
			vo_just_played = true;
		}
		else
		{
			vo_just_played = false;	
		}
		
		objective_ring( 3 );
		
		wait( RandomIntRange( 5, 7 ) );

	}

}



flame_bunker_vo_2()
{
	
	flag_wait( "bunkers_flamed" );
	
	wait( 1.55 );
	
	// only say this VO if the bunkers were actually flamed
	if( !flag( "bunker_killed_but_not_flamed" ) )
	{
		play_vo( level.polonsky, "vo", "hell_yeah_burn" );
		wait( 3 );
		play_vo( level.roebuck, "vo", "okay_move_up" );	
	}
	
}



///////////////////
//
// Clean up color chains
//
///////////////////////////////

clean_up_bunker_chains()
{
	flag_wait( "trig_bunker_2_start" );
	delete_noteworthy_ents( "friendly_chain_bunkers_2" );	
}



///////////////////
//
// don't advance friendlies near bunker 1's entrance until it's mostly clear
//
///////////////////////////////

chain_bunkers_entrance()
{
	
	far_trig = getent( "trig_chain_bunkers_entrance_past", "targetname" );
	level thread set_flag_on_trigger( far_trig, "chain_bunkers_entrance_past" );
	
	// end this check if the player advances far enough ahead
	level endon( "chain_bunkers_entrance_past" );
	
	// give enemies some time to get in place
	wait( 5 );
	
	waittill_aigroupcount( "bunker_1_pre_ai", 2 );
	
	main_trig = getent( "trig_chain_bunkers_entrance", "targetname" );
	main_trig notify( "trigger" );
	
}



///////////////////
//
// don't advance friendlies near bunker 2's back until it's mostly clear
//
///////////////////////////////

chain_bunkers_5()
{
	// notify comes from flag set on trigger
	level endon( "trig_chain_bunkers_5" );
	
	while( 1 )
	{
	
		guys_count = get_specific_ai( "47mm_2_noteworthy" ).size;
		guys_count += get_ai_group_count( "bunker_2_back_ai" );
		
		if( guys_count < 2 )
		{
			break;	
		}
		
		wait( 0.4 );
		
	}	
	
	chain_trig = getent( "friendly_chain_bunkers_5", "script_noteworthy" );	
	chain_trig notify( "trigger" );	
	
	// delete other triggers that are further back
	delete_noteworthy_ents( "friendly_chain_bunkers_4" );
	
}



///////////////////
//
// Get heroes in cover from mg bunker
//
///////////////////////////////

bunkers_end_heros_in_place()
{
	
	hero_nodes = getnodearray( "node_heroes_bunkers_end", "targetname" );
	assertex( hero_nodes.size >= level.heroes.size, "not enough goal_nodes for heroes!" );
	
	suppression_target = convert_aiming_struct_to_origin( "orig_flame_bunker_heroes_targ" );
	level thread flame_move_target( suppression_target, 4 );	
	
	for( i  = 0; i < level.heroes.size; i++ )
	{
		level.heroes[i].goalradius = 20;
		level.heroes[i] setgoalnode( hero_nodes[i] );
		level.heroes[i] thread bunkers_end_heroes_strat( hero_nodes[i] );
	}
	
	play_vo( level.roebuck, "vo", "everyone_on_me" );
	
	flag_wait( "bunkers_flamed" );	
	
	// stop moving script origins
	suppression_target notify( "stop_fakefire_mover" );
	suppression_target delete();
	
}



///////////////////
//
// Heroes strategy for firing at flame bunker
//
///////////////////////////////

bunkers_end_heroes_strat( goal )
{
	
	level endon( "bunkers_flamed" );
	
	self setcandamage( false );
	self waittill( "goal" );
	
	self.pacifist = 1;
	self.pacifistwait = 0.05;
	
	// TODO technically if guys weren't at their position when this happened then this waittill would never be satisfied (if this happens something 
	// else is really wrong, but i should fix this setup anyway)
	level waittill( "suppressing_fire" );
	
	if( self == level.roebuck )
	{
		play_vo( self, "vo", "suppressing_fire_on_mgs" );
	}
	
	suppression_target = getent( "orig_flame_bunker_heroes_targ_converted", "targetname" );
	self SetEntityTarget( suppression_target );
	
	self.pacifist = 0;
	self.ignoreall = 0;
	self.ignoresuppression = 1;
	
	while( 1 )
	{
		
		wait( 5.25 + RandomFloat( 0.5 ) );
		
		self.bulletsinclip = 0;
	
		self ClearEntityTarget();
	
		self.pacifist = 1;
		self.ignoreall = 1;
		self.ignoresuppression = 0;
		
		level waittill( "suppressing_fire" );
			
		wait( RandomFloat( 0.35 ) );
			
		self SetEntityTarget( suppression_target );
		
		self.pacifist = 0;
		self.ignoreall = 0;
		self.ignoresuppression = 1;	
		
	}
	
}



///////////////////
//
// VO for end bunker section
//
///////////////////////////////

bunkers_end_heroes_vo()
{

	level endon( "bunker_suppressed_twice" );

	wait( 4 );

	wait( 1 );
	
	while( !flag( "bunkers_flamed" )  )
	{
		level notify( "suppressing_fire" );
		wait( 10 );
	}
	
}



///////////////////
//
// Handles the mgs in the flame bunker
//
///////////////////////////////

bunker_mg_killzone()
{

	level endon( "bunkers_flamed" );
	level endon( "mgs_focus_on_flamer" );

	level.player_being_targetted = false;

	killzone_trigger = getent( "trig_bunker_mg_killzone", "targetname" );
	killzone_trigger_extra = getent( "trig_bunker_mg_killzone_extra", "targetname" );

	while( !flag( "bunkers_flamed" ) )
	{
		
		player_touching = get_player_touching( killzone_trigger );
		player_touching_2 = undefined;
		
		// sometimes check this extra volume
		if( !RandomInt( 9 ) )
		{
			player_touching_2 = get_player_touching( killzone_trigger_extra );
		}
		
		// if the player is touching either volume but isn't yet being targeted, or if he should be force targetted
		if( ( ( IsDefined( player_touching ) || IsDefined( player_touching_2 ) ) && !level.player_being_targetted ) || level.force_player_being_targetted )
		{

			if( level.smoke_grenades_on_the_scene )
			{
				wait( 2 );
				continue;	
			}

			level.player_being_targetted = true;

			// player is in the open, so fire at him now
			quick_text( "player is in the open", 2, false );
			level thread mgs_focus_on_ai();
			wait( 2 );
			
		}
		// if the player is no longer touching the volume but is still being targeted
		else if( !IsDefined( player_touching ) && level.player_being_targetted )
		{
			
			wait( RandomFloatRange( 1.0, 2.25 ) );
			
			if( flag( "bunkers_flamed" ) )
			{
				return;	
			}
			
			level.player_being_targetted = false;
			level thread mgs_focus_on_origins();
			
		}
		
		wait( 0.25 );
		
	}
	
}



smoke_grenade_on_the_scene()
{
	
	level endon( "bunkers_flamed" );
	
	trig = getent( "trig_bunker_regroup", "targetname" );
	
	while( 1 )
	{
	
		grenades = GetEntArray( "grenade", "classname" );
	
		for( i = 0 ; i < grenades.size; i++ )
		{
			if( grenades[i].model == "projectile_us_smoke_grenade" && grenades[i] istouching( trig ) && !isdefined( grenades[i].pel2_counted ) )
			{
				grenades[i].pel2_counted = true;
				level.smoke_grenades_on_the_scene++;
				level thread smoke_grenade_check_decrement();
			}
		}

		wait( 0.75 );
	
	}

}



smoke_grenade_check_decrement()
{
	wait( 34 ); // length of time for smoke to dissipate
	level.smoke_grenades_on_the_scene--;
}



///////////////////
//
// If all japanese defenders around the gun area are killed, these guys should hop off the gun
//
///////////////////////////////

guys_47mm_1_force_expand()
{
	
	level endon( "bunkers_flamed" );
	trig = getent( "trig_47mm_1_radius_expand", "targetname" );
	trig endon( "trigger" );
	
	waittill_aigroupcleared( "bunker_1_pre_ai" );
	
	trig notify( "trigger" );

}



///////////////////
//
// When nearby trig radius is hit, get guys off the gun and expand their goal radius so they can join the fight
//
///////////////////////////////

guys_47mm_1_radius_expand()
{

	level endon( "bunkers_flamed" );

	trigger_wait( "trig_47mm_1_radius_expand", "targetname" );
	
	change_noteworthy_goalradii( "47mm_1_noteworthy", 465 );
	
	at_gun = getent( "bunker_gun_1", "targetname" );
	at_gun notify ("shut down arty");
	
	//give guns
	for (i = 0; i < at_gun.arty_crew.size; i++)
	{	
		if( isdefined( at_gun.arty_crew[i] ) && isalive( at_gun.arty_crew[i] ) )
		{
			at_gun.arty_crew[i] animscripts\shared::placeWeaponOn( at_gun.arty_crew[i].primaryweapon, "right");	
		}
	}
	
	array_thread( at_gun.arty_crew, ::set_pacifist_off );
	
}



guys_47mm_2_radius_expand()
{

	level endon( "bunkers_flamed" );

	flag_wait( "marines_advance" );
	
	nodes = getnodearray( "node_at47_retreat", "script_noteworthy" );
	
	guys = get_specific_ai( "47mm_2_noteworthy" );

	// kill off one if all four are alive	
	if( guys.size == 4 )
	{
		guys[0] thread bloody_death( true );
	}	
	
	wait( 0.05 );
	
	for( i  = 0; i < guys.size; i++ )
	{
		if( !isdefined( guys[i] ) || !isalive( guys[i] ) )
		{
			continue;	
		}
		
		guys[i] notify( "killanimscript" );
		guys[i].goalradius = 40;
		guys[i].health = 40;
		guys[i].ignoresuppression = 1;
		guys[i] setgoalnode( nodes[i] );
		
		// we want this guy's goalradius to expand after he gets there
		if( nodes[i].targetname == "auto1998" )
		{
			guys[i] thread delay_at47_retreat_goalradius();	
		}
		
	}
	
	
	at_gun = getent( "bunker_gun_2", "targetname" );
	at_gun notify ("shut down arty");	
	
	//give guns
	for (i = 0; i < at_gun.arty_crew.size; i++)
	{	
		if( isdefined( at_gun.arty_crew[i] ) && isalive( at_gun.arty_crew[i] ) )
		{
			at_gun.arty_crew[i] animscripts\shared::placeWeaponOn( at_gun.arty_crew[i].primaryweapon, "right");	
		}
	}	
	
	array_thread( at_gun.arty_crew, ::set_pacifist_off );
	
}



delay_at47_retreat_goalradius()
{
	self endon( "death" );
	self waittill( "goal" );
	self.goalradius = 300;
}



guys_47mm_4_radius_expand()
{

	level endon( "bunkers_flamed" );

	trigger_wait( "trig_47mm_4_radius_expand", "targetname" );
	
	change_noteworthy_goalradii( "47mm_4_noteworthy", 450 );
	
	at_gun = getent( "bunker_gun_4", "targetname" );
	at_gun notify ("shut down arty");		
	
	//give guns
	for (i = 0; i < at_gun.arty_crew.size; i++)
	{	
		if( isdefined( at_gun.arty_crew[i] ) && isalive( at_gun.arty_crew[i] ) )
		{
			at_gun.arty_crew[i] animscripts\shared::placeWeaponOn( at_gun.arty_crew[i].primaryweapon, "right");	
		}
	}	
	
	array_thread( at_gun.arty_crew, ::set_pacifist_off );
	
}



///////////////////
//
// Expand the goal radii of the axis guys on the frontline when the player surprises them from behind
//
///////////////////////////////

guys_frontline_radius_expand() {
	

	trigger_wait( "trig_frontline_radius_expand", "targetname" );
	
	level notify( "frontline_radius_expand" );
	
	change_noteworthy_goalradii( "frontline_axis_ai", 550 );
	
}



///////////////////
//
// This guy is near the at47 as backup; we want his goalradius expanding sooner than the others
//
///////////////////////////////

guys_frontline_radius_expand_2() {
	

	wait( 3.75 );
	
	change_ai_group_goalradii( "frontline_axis_ai_2", 350 );
	
}



///////////////////
//
// Guy that notices marines' ambush and signals the alarm
//
///////////////////////////////

alarm_mg_guy()
{
	
	alarm_guy = get_specific_single_ai( "bunker_gun_1_notifier" );
	
	if( isdefined( alarm_guy ) && isalive( alarm_guy ) )
	{
		
		alarm_guy endon( "death" );
	
		alarm_guy.ignoreme = true;
		alarm_guy.goalradius = 40;
		alarm_guy.pacifist = 1;
		alarm_guy.pacifistwait = 0.05;
	
		wait( 1.0 );
		
		alarm_guy.ignoreall = 1;
		goal_node = getnode( "auto793", "targetname" );
		alarm_guy setgoalnode( goal_node );
		
		alarm_guy waittill( "goal" );
		
		alarm_guy.ignoreall = 0;
		alarm_guy.pacifist = 0;
		alarm_guy.goalradius = 200;
		alarm_guy.ignoreme = false;
		
	}
	
}



bunker_1_pre_spawners_strat()
{

	self endon( "death" );
	
	self thread end_pacifist( 4 );
	
	self.ignoresuppression = 1;
	
	self waittill_either( "goal", "end_pacifist" );
	
	self.ignoresuppression = 0;
	
}



///////////////////
//
// Sends a notify to stop pacifist on very specific ai
//
///////////////////////////////

end_pacifist( wait_time )
{

	self endon( "death" );

	if( isdefined( wait_time ) )
	{
		wait( wait_time );	
	}
	else
	{
		wait( 3 );	
	}
	
	self notify( "end_pacifist" );
	
}



///////////////////
//
// Have bunker 1 back spawners retreat back near bunker 2
//
///////////////////////////////

bunker_1_retreat()
{

	// flag set on trigger
	flag_wait( "trig_mid_bunker_retreat" );

	extra_text( "bunker_1_retreat" );

	guys = get_ai_group_ai( "bunker_1_back_ai" );
	//goal_spots = getstructarray( "orig_bunker_1_back", "targetname" );
	// hard-coding these to save script vars (script_structs cost several script_vars each)
	goal_spots = [];
	goal_spots[goal_spots.size] = ((802, -8973, 3.5));
	goal_spots[goal_spots.size] = ((1078, -9089, -18.5));
	goal_spots[goal_spots.size] = ((1033, -9211, 7.5));
	goal_spots[goal_spots.size] = ((786, -9236, 5.5));
	goal_spots[goal_spots.size] = ((654, -9201, -12.5));
	goal_spots[goal_spots.size] = ((532, -9395, 1.5));
	
	goal_spots = array_randomize( goal_spots );
	
	assertex( goal_spots.size >= guys.size, "not enough goal_pos for guys!" );
	
	for( i  = 0; i < guys.size; i++ )
	{
		if( isalive( guys[i] ) )
		{
			guys[i] thread bunker_1_retreat_strat_b( goal_spots[i] );
		}
	}

}



bunker_1_retreat_strat_b( goal_pos )
{

	self endon( "death" );
	
	wait( randomfloatrange( 0.4, 3.0 ) );
	
	self.goalradius = 50;	
	self.ignoreall = 1;
	self.ignoresuppression = 1;
	
	self setgoalpos( goal_pos );
	
	self waittill( "goal" );
	
	self.goalradius = 450;	
	self.ignoreall = 0;
	self.ignoresuppression = 0;
	
}



///////////////////
//
// Stop current color reinforcements 
//
///////////////////////////////

bunker_stop_friendly_waves()
{
	
	trigger_wait( "friendly_respawn_clear_bunkers", "script_noteworthy" );

	flag_set( "trig_forest_friendlies" );

	// TODO can get rid of this now?	
	//unless this is here, friendly_spawner_vision_checker() in _colors.gsc will still spawn reinforcements in some instances
	level.respawn_spawner = undefined;
	
	// to stop guys from being respawned in as blue guys when the next friendly_respawn_trigger is hit (also done in lastSequence() in bog_b.gsc)
	allies = getaiarray( "allies" );
	for( i  = 0; i < allies.size; i++ )
	{
		allies[i] disable_replace_on_death();
	}
	
}




///////////////////
//
// When player clears bunkers, have pinned down allies move up to join the battle
//
///////////////////////////////

bunker_1_clear()
{
	
	// flag set on trigger
	flag_wait( "trig_marines_advance" );
	
	quick_text( "marines advance!", 3, true );
	flag_set( "marines_advance" );
	
	maps\_spawner::kill_spawnernum( 109 );
	
	level thread bunker_1_mgs_off();
	
	// stop allied drones in mangrove section
	level notify( "end_mangrove_drones" );
	
	// reinforcements now come from the main group of marines
	new_respawn_trig = getent( "trigger_bunker_wave_4", "script_noteworthy" );
	new_respawn_trig notify( "trigger" );
	
	// intro guys advance from cover
	intro_guys_advance();
	
	// spawn guys held off by bunker 2
	
	// Wii optimizations
	if( !level.wii )
	{
		simple_spawn( "bunker_2_ambient_friendlies", ::bunker_2_ambient_friendlies_approach );
	}
	
	// spawn flame dude
	level.flamer = simple_spawn_single( "flamer_guy", ::flamer_spawn_strat );
	assertex( isdefined( level.flamer ), "level.flamer not defined! bad bad bad!" );		

	level.flamer thread flamer_advance_bunkers();

	level thread bunker_1_axis_banzai();

}



///////////////////
//
// if player is mostly pass bunker 1, have 2 inside defenders run out and banzai charge 
// (prevents ai from shooting backwards into the bunker once they've moved up)
//
///////////////////////////////

bunker_1_axis_banzai()
{
	
	// flag set on trigger
	flag_wait( "trig_marines_advance" );
	
	wait( RandomIntRange( 2, 4 ) );
	
	guys = get_ai_group_ai( "bunker_1_ai_chargers" );
	for( i  = 0; i < guys.size; i++ )
	{
		guys[i].banzai_no_wait = 1;	
		guys[i].ignoresuppression = 1;	
		guys[i] thread maps\_banzai::banzai_force();
	}
	
}



///////////////////
//
// intro guys advance from cover and join the bunkers battle
//
///////////////////////////////

intro_guys_advance()
{

	intro_guys = get_ai_group_ai( "intro_igc_ai" );
	
	for( i  = 0; i < intro_guys.size; i++ )
	{
		
		intro_guys[i] setcandamage( true ); 
		
		if( isdefined( intro_guys[i].script_noteworthy ) )
		{
			intro_guys[i].moveplaybackrate = 1.3;
			intro_guys[i] thread maps\_spawner::go_to_node( getnode( intro_guys[i].script_noteworthy, "targetname" ) );
		}
		
		intro_guys[i] thread intro_guys_ai_stop_shield();
		
	}	
	
}



///////////////////
//
// turn off mgs in the first bunker
//
///////////////////////////////

bunker_1_mgs_off()
{
	
	wait( 3 );
	
	guys = get_ai_group_ai( "intro_mg_ai" );
	
	for( i  = 0; i < guys.size; i++ )
	{
		guys[i] StopUSeturret();
	}
	
}


bunker_2_ambient_friendlies_approach()
{

	self endon( "death" );
	
	self.health = 200;
	
	flag_wait( "flamer_advance_to_3" );
	
	goal_node = getnode( self.script_noteworthy, "targetname" );
	self setgoalnode( goal_node );
	
}



intro_guys_ai_stop_shield()
{

	self waittill( "goal" );

	self.moveplaybackrate = 1;

	if( IsDefined( self.magic_bullet_shield ) && self.magic_bullet_shield )
	{
		self stop_magic_bullet_shield(); 
	}
	
}



///////////////////
//
// When player clears bunkers, have pinned down allies move up to join the battle
//
///////////////////////////////

bunker_prepare_flame()
{

	event_text( "waiting to clear end bunkers" );
	
	regroup_trig = getent( "trig_bunker_regroup", "targetname" );
	
	event_text( "waiting to regroup" );
	
	// wait till player is back with squad near sandbags
	while( 1 )
	{
		if( any_player_IsTouching( regroup_trig ) )
		{
			break;	
		}
		wait( 0.5 );
	}
	
	level notify( "obj_bunker_regroup_complete" );
	flag_set( "bunker_regroup_complete" );
	level thread bunkers_end_heroes_vo();
	
}



///////////////////
//
// Paces out shooting of the mgs so it appears as if they take a break to reload once in a while
//
///////////////////////////////

bunker_defenders_rhythm_stop()
{
	
	level endon( "bunkers_flamed" );
	
	turret_left = getent( "flame_bunker_mg_l", "targetname" );
	turret_right = getent( "flame_bunker_mg_r", "targetname" );
	
	while( 1 )
	{
	
		wait( RandomIntRange( 11, 13 ) );
		
		guy_1 = get_ai_group_ai( "last_bunker_ai_1" );
		guy_2 = get_ai_group_ai( "last_bunker_ai_2" );
		
		// don't do the stop when the flamer death vignette is about to happen
		if( flag( "mgs_focus_on_flamer" ) )
		{
			continue;	
		}
		
		// only stop when both guys are alive and ready to stop
		if( isdefined( guy_1[0] ) && isdefined( guy_2[0] ) && guy_1[0].pel2_rhythm_stop && guy_2[0].pel2_rhythm_stop )
		{
			
			quick_text( "rhythm stop!" );
			flag_set( "flame_bunker_rhythm_stop" );
			
			turret_left notify( "stop_burst_fire_unmanned" );
			turret_left notify( "turretstatechange" );
			wait( RandomFloatRange( 1.0, 1.5 ) );
			turret_right notify( "stop_burst_fire_unmanned" );
			turret_right notify( "turretstatechange" );
			
			guy_1[0].pacifist = true;
			guy_2[0].pacifist = true;
			
			wait( RandomFloatRange( 3.5, 4.5 ) );
			
			quick_text( "rhythm start!" );
			flag_clear( "flame_bunker_rhythm_stop" );
			
			turret_left thread maps\_mgturret::burst_fire_unmanned();
			wait( RandomFloatRange( 1.0, 1.5 ) );
			turret_right thread maps\_mgturret::burst_fire_unmanned();
			
			if( isdefined( guy_1[0] ) && isalive( guy_1[0] ) )
			{
				guy_1[0].pacifist = false;
			}
			if( isdefined( guy_2[0] ) && isalive( guy_2[0] ) )
			{
				guy_2[0].pacifist = false;
			}			
			
		}
		
	}
		
}



///////////////////
//
// Guys on mgs in last bunker of E2
//
///////////////////////////////

bunker_defenders_strat()
{
	
	self thread bunker_defenders_death_watch();
	
	self endon( "death" );
	
	self.pel2_rhythm_stop = false;
	self.grenadeawareness = 0;
	self.ignoresuppression = true;
	self.ignoreall = true;
	
	self waittill( "goal" );
	
	self.ignoreall = false;
	
	wait( RandomIntRange( 5, 7 ) );
	
	self.pel2_rhythm_stop = true;
	
}



///////////////////
//
// take it as an act of suppression towards the bunker if one of the mg guys is killed
//
///////////////////////////////

bunker_defenders_death_watch()
{
	self waittill( "death" );
	level.bunker_mg_damage_total += 150;
}



///////////////////
//
// Ambient tanks in the distance get blown up from the at47s
//
///////////////////////////////

intro_tank_lookat()
{

	level thread trig_override( "trig_intro_tank_lookat" );
	// wait for player to look in the tanks' direction
	trigger_wait( "trig_intro_tank_lookat", "targetname" );

	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 200 );
	
	vnode = getvehiclenode( "node_intro_tank_die", "script_noteworthy" );
	vnode waittill( "trigger" );
	
	tank = getent( "intro_tank_1", "targetname" );
		
	playfx( level._effect["arty_dirt"], tank.origin, (1,0,0) );		
		
	radiusdamage( tank.origin, 10, tank.health, tank.health );
	
}



///////////////////
//
// Strategy for guys that are pinned down in the intro igc
//
///////////////////////////////

intro_igc_friendlies_strat()
{

	self endon( "death" );
	
	self thread magic_bullet_shield();
	self setcandamage( false ); 
	self.pacifist = true;
	self.ignoresuppression = true;
	self.baseAccuracy = 0.05;
//	self.drawoncompass = false; broken because of networking stuff
	
	level waittill( "obj_mangrove_complete" );
	
	wait( 8 );
	
//	self.drawoncompass = true;
	self.pacifist = false;
	
}



///////////////////
//
// flamethrower guy flames the truck near the flame bunkers
//
///////////////////////////////

flame_truck()
{

	level notify( "start_flame_truck" );

	self.pacifist = 0;
	
	// set up the spot (script_origin) where he fires at
	truck_spot = convert_aiming_struct_to_origin( "orig_flame_truck_2" );
	level thread flame_move_target( truck_spot, 3 );	
	self SetEntityTarget( truck_spot );
	
	wait( 3.5 );
	
	// in case flames didnt blow up truck, do it manually
	truck = getent( "flame_truck", "script_noteworthy" );
	if( truck.health > 0 )
	{
		radiusdamage( truck.origin, 1, truck.health + 1, truck.health + 1 );
	}
	
	self ClearEntityTarget();
	truck_spot notify( "stop_fakefire_mover" );
	self.pacifist = 1;
	
	// make sure they're all dead
	kill_aigroup( "forest_truck_ai" );
	
}



///////////////////
//
// Flamebunker MGs fire towards the hero squad/flame guy
//
///////////////////////////////

mgs_focus_on_origins( focus )
{

	//mgs focus fire on script origins
	mg_left = getent( "flame_bunker_mg_l", "targetname" );
	mg_right = getent( "flame_bunker_mg_r", "targetname" );
	
	targ_1 = getent( "bunker_end_target_1_converted", "targetname" );
	targ_1a = getent( "bunker_end_target_1a_converted", "targetname" );
	targ_2 = getent( "bunker_end_target_2_converted", "targetname" );
	targ_2a = getent( "bunker_end_target_2a_converted", "targetname" );
	targ_3 = getent( "bunker_end_target_3_converted", "targetname" );
	
	// set default old targets
	mg_left.pel2_old_target_ent = targ_2a;
	mg_right.pel2_old_target_ent = targ_2;	
	
	if( !isdefined( focus ) )
	{
		focus = "previous_targets";
	}
	
	quick_text( "mgs_focus on " + focus, 3, true );

	
	if( focus == "both_flamer" )
	{

		mg_left SetTargetEntity( targ_1 );
		mg_left.pel2_old_target_ent = targ_1;

		mg_right SetTargetEntity( targ_1a );
		mg_right.pel2_old_target_ent = targ_1a;	
		
	}
	else if(  focus == "both_berm" )
	{

		mg_left SetTargetEntity( targ_2a );
		mg_left.pel2_old_target_ent = targ_2a;

		mg_right SetTargetEntity( targ_2 );
		mg_right.pel2_old_target_ent = targ_2;		
		
	}
	else if(  focus == "left_flamer_right_berm" )
	{

		mg_left SetTargetEntity( targ_3 );
		mg_left.pel2_old_target_ent = targ_3;

		mg_right SetTargetEntity( targ_2 );
		mg_right.pel2_old_target_ent = targ_2;		
		
	}
	else if(  focus == "previous_targets" )
	{

		mg_left SetTargetEntity( mg_left.pel2_old_target_ent );
		mg_right SetTargetEntity( mg_right.pel2_old_target_ent );
		
	}	

	guys = getaiarray( "allies" );
	array_thread( guys, ::set_ignoreme_on );
	
	set_players_ignoreme( true );
	
}



///////////////////
//
// MGs target the flamer to kill him 
//
///////////////////////////////

mgs_focus_on_flamer()
{
	
	flag_set( "mgs_focus_on_flamer" );
	
	set_players_ignoreme( true );
	
	mg_left = getent( "flame_bunker_mg_l", "targetname" );
	mg_right = getent( "flame_bunker_mg_r", "targetname" );	

	mg_left cleartargetentity();
	mg_right cleartargetentity();

	flamer_spot = convert_aiming_struct_to_origin( "orig_flamer_death_spot" );

	mg_left SetTargetEntity( flamer_spot );
	mg_right SetTargetEntity( flamer_spot );	

	guy_1 = get_ai_group_ai( "last_bunker_ai_1" );
	for( i  = 0; i < guy_1.size; i++ )
	{
		guy_1[i] setcandamage( false );
	}
	guy_2 = get_ai_group_ai( "last_bunker_ai_2" );
	for( i  = 0; i < guy_2.size; i++ )
	{
		guy_2[i] setcandamage( false );
	}
	
	flag_wait( "flame_guy_killed" );
	
	if( isdefined( guy_1[0] ) )
	{
		guy_1[0] setcandamage( true );
	}
	if( isdefined( guy_2[0] ) )
	{
		guy_2[0] setcandamage( true );
	}
	
	flag_clear( "mgs_focus_on_flamer" );
	
	level endon( "bunkers_flamed" );
	
	level.current_mg_focus = "both_berm";
	if( !level.player_being_targetted )
	{
		level thread mgs_focus_on_origins( level.current_mg_focus );
	}	
	
	// restart the killzone
	level thread bunker_mg_killzone();
	
}



///////////////////
//
// Flamebunker mgs target the player because he got too close
//
///////////////////////////////

mgs_focus_on_ai()
{

	mg_1 = getent( "flame_bunker_mg_l", "targetname" );
	mg_2 = getent( "flame_bunker_mg_r", "targetname" );

	mg_1 cleartargetentity();
	mg_2 cleartargetentity();

	set_players_ignoreme( false );

}



///////////////////
//
// Guys that escort the flame guy into the battle
//
///////////////////////////////

flame_squad_remainder()
{

	// send reinforcements up
	guys = get_ai_group_ai( "bunker_2_ambient_friendlies_ai" );
	goal_nodes = getnodearray( "node_advance_end_bunkers", "targetname" );
	assertex( goal_nodes.size >= guys.size, "not enough goal_nodes for guys!" );
	
	for( i  = 0; i < guys.size; i++ )
	{
		guys[i] setgoalnode( goal_nodes[i] );
		guys[i] thread bunker_2_ambient_friendlies_strat();
	}
	
}



///////////////////
//
// Sets up drone character models
//
///////////////////////////////

setup_drone_models()
{

	// setup drone characters
	character\char_jap_pel2_rifle::precache();
	character\char_usa_marine_r_rifle::precache();
	// These are called everytime a drone is spawned in to set up the character.
	level.drone_spawnFunction["axis"] = character\char_jap_pel2_rifle::main;
	level.drone_spawnFunction["allies"] = character\char_usa_marine_r_rifle::main; 	
	
	if(NumRemoteClients() > 1)	// Remove all drones in coop with more than 1 remote player.
	{
		spawners = GetEntArray("drone_axis", "targetname");
		
		for(i = 0; i < spawners.size; i ++)
		{
			spawners[i] delete();
		}
		
		spawners = GetEntArray("drone_allies", "targetname");
			 
		for(i = 0; i < spawners.size; i ++)
		{
			spawners[i] delete();
		}
		
	}
	
}



///////////////////
//
// Strategy for guys that are spawned and run up and flame bunkers
//
///////////////////////////////

bunker_2_ambient_friendlies_strat()
{

	self endon( "death" );

	self.baseaccuracy = 0.05;
	self.pacifist = 1;
	self.ignoreme = true;
	
	self waittill( "goal" );
	
	self.pacifist = 0;
	self.ignoreme = false;

}



///////////////////
//
// Canned impact fx from the at47s in the ambient battle
//
///////////////////////////////

arty_fire_impacts( orig )
{

	self endon( "shut down arty" );
	self endon( "stop_arty_fire_loop" );
	level endon( "obj_bunkers_complete" );
	
	while( 1 )
	{
		self waittill( "arty_fire" );
		wait( 0.5 );
		playfx( level._effect["arty_dirt"], orig + random_vector( 40 ), (1,0,0) );
	}
	
}



arty_fake_fire_impacts( orig )
{

	level endon( "stop_fake_arty_2" );
	
	while( 1 )
	{
		wait( RandomFloatRange( 3, 4.5 ) );
		playfx( level._effect["arty_dirt"], orig + random_vector( 40 ), (1,0,0) ); 
	}
	
}



///////////////////
//
// Set up AT crews
//
///////////////////////////////

bunker_1_47mm()
{

	level waittill( "spawnvehiclegroup" + 21 );

	wait( 0.05 );

	at_gun = getent( "bunker_gun_1","targetname" );

	//at_orig = getstruct( "orig_intro_at_impact_1", "targetname" );
	at_gun thread arty_fire_impacts( (-1213.5, -11928.5, -59.7) );

	array_thread( at_gun.arty_crew, ::set_ignoreme_on );	
	
	at_gun maps\_artillery::arty_fire_without_move();
	

	// put their goalradii up so if/when they get off gun b/c of damage, they can take cover easily
	for( i  = 0; i < at_gun.arty_crew.size; i++ )
	{
		if( isdefined( at_gun.arty_crew[i] ) && isalive( at_gun.arty_crew[i] ) )
		{
			at_gun.arty_crew[i].goalradius = 400;
		}
	}	
	
	wait( 0.2 );
	
	// kill off the commander; he isn't needed
	for( i  = 0; i < at_gun.arty_crew.size; i++ )
	{

		if( isdefined( at_gun.arty_crew[i] ) && isalive( at_gun.arty_crew[i] ) )
		{
	
			if( at_gun.arty_crew[i].animname == "commander" )
			{
				at_gun.arty_crew[i] dodamage( at_gun.arty_crew[i].health + 100, ( 0, 0, 0 ) );	
			}	
			
		}
	}
	
	wait( 1 );
	
	at_gun maps\_artillery::arty_fire();	
	
}



bunker_2_47mm()
{

	//at_orig = getstruct( "orig_intro_at_impact_2", "targetname" );
	level thread arty_fake_fire_impacts( (-1294, -12475, -57.7) );

	level waittill( "spawnvehiclegroup" + 22 );

	level notify( "stop_fake_arty_2" );

	wait( 0.05 );

	at_gun = getent( "bunker_gun_2","targetname" );
	
	at_gun thread arty_fire_impacts( (-1294, -12475, -57.7) );

	array_thread( at_gun.arty_crew, ::set_ignoreme_on );
	
	at_gun maps\_artillery::arty_fire_without_move();


	// put their goalradii up so if/when they get off gun b/c of damage, they can take cover easily
	for( i  = 0; i < at_gun.arty_crew.size; i++ )
	{
		if( isdefined( at_gun.arty_crew[i] ) && isalive( at_gun.arty_crew[i] ) )
		{
			at_gun.arty_crew[i].goalradius = 400;
		}
	}		
	
	wait( 0.2 );
	
	// kill off the commander; he isn't needed
	for( i  = 0; i < at_gun.arty_crew.size; i++ )
	{

		if( isdefined( at_gun.arty_crew[i] ) && isalive( at_gun.arty_crew[i] ) )
		{
	
			if( at_gun.arty_crew[i].animname == "commander" )
			{
				at_gun.arty_crew[i] dodamage( at_gun.arty_crew[i].health + 100, ( 0, 0, 0 ) );	
			}	
			
		}
	}
	
	wait( 1 );
	
	at_gun maps\_artillery::arty_fire();	
	
}



bunker_4_47mm()
{

	level waittill( "spawnvehiclegroup" + 24 );

	wait( 0.05 );

	at_gun = getent( "bunker_gun_4","targetname" );

  	for( i  = 0; i < at_gun.arty_crew.size; i++ )
	{
  		at_gun.arty_crew[i].goalradius = 30;
  		at_gun.arty_crew[i].ignoreme = true;
  		at_gun.arty_crew[i].ignoreall = true;
  		at_gun.arty_crew[i].pacifist = true;
  		at_gun.arty_crew[i].pacifistwait = 0.05;
  	}

	at_gun maps\_artillery::arty_fire_without_move();
	

	// put their goalradii up so if/when they get off gun b/c of damage, they can take cover easily
	for( i  = 0; i < at_gun.arty_crew.size; i++ )
	{
		if( isdefined( at_gun.arty_crew[i] ) && isalive( at_gun.arty_crew[i] ) )
		{
			at_gun.arty_crew[i].goalradius = 400;
		}
	}	
	
	wait( 0.2 );
	
	at_gun maps\_artillery::arty_fire();	
	
}



battle_line_ambient_sound()
{

	temp_sound_orig = spawn( "script_origin", ( -1167.89, -8756.53, -51.1988 ) );
	temp_sound_orig playloopsound( "battle_line_jap" );

	temp_sound_orig_2 = spawn( "script_origin", ( -2394.69, -8158.39, -51.1988 ) );
	temp_sound_orig_2 playloopsound( "battle_line_us" );
	
	// flag set on trigger
	flag_wait( "trig_flame_bunker_exit" );
	
	temp_sound_orig delete();
	temp_sound_orig_2 delete();
	
}



spawn_bunkers_pickup_weapons()
{

	flag_wait( "trig_bunker_2_start" );

	bunker_weapons = [];

	// weapons in flame bunker
	bunker_weapons[0] = spawnstruct();
	bunker_weapons[0].weapon_name = "weapon_type97_frag";
	bunker_weapons[0].origin = (-118.8, -6946.6, -23);
	bunker_weapons[0].angles = (270, 240.6, 0);	

	bunker_weapons[1] = spawnstruct();
	bunker_weapons[1].weapon_name = "weapon_type97_frag";
	bunker_weapons[1].origin = (-120.7, -6933.9, -23);
	bunker_weapons[1].angles = (270, 318.4, 0);	

	bunker_weapons[2] = spawnstruct();
	bunker_weapons[2].weapon_name = "weapon_nambu";
	bunker_weapons[2].origin = (-234, -6898.3, -12.5);
	bunker_weapons[2].angles = (0, 70.1, -90.0001);	

	bunker_weapons[3] = spawnstruct();
	bunker_weapons[3].weapon_name = "weapon_type99_rifle";
	bunker_weapons[3].origin = (-405.6, -6903.9, -25.9);
	bunker_weapons[3].angles = (295.642, 99.2652, -72.4286);

	bunker_weapons[4] = spawnstruct();
	bunker_weapons[4].weapon_name = "weapon_type99_rifle";
	bunker_weapons[4].origin = (-407.7, -6898, -25.6);
	bunker_weapons[4].angles = (294.595, 149.005, 167.911);


	// grenades in bunker #2 in bunker event
	bunker_weapons[5] = spawnstruct();
	bunker_weapons[5].weapon_name = "weapon_type97_frag";
	bunker_weapons[5].origin = (84.8, -8512.4, -26.5);
	bunker_weapons[5].angles = (270, 318.4, 0);	

	bunker_weapons[6] = spawnstruct();
	bunker_weapons[6].weapon_name = "weapon_type97_frag";
	bunker_weapons[6].origin = (-7.3, -8511.1, -27);
	bunker_weapons[6].angles = (270, 240.6, 0);	
	
	spawn_pickup_weapons( bunker_weapons );
	
}



///////////////////
//
// Sets up specific friendly squad settings 
//
///////////////////////////////

friendly_setup_thread()
{
	self thread magic_bullet_shield();
	self setthreatbiasgroup( "heroes" );	
	self.goalradius = 400;
	self.script_noteworthy = "friendly_squad_ai";
	self pushplayer( true );
	self.dontavoidplayer = true; 
}



on_dry_land()
{

	self endon( "death" );
	
	self.isinwater = 0;
//	if( self != level.roebuck )
//	{
//		self clear_run_anim();
//	}
//	
//	self.disableArrivals = false;	

	self disable_cqbwalk();
	self clear_custom_approach_fields();

	
}



///////////////////
//
// piggybacking autosaves onto other triggers, to save entities
//
///////////////////////////////	

save_near_first_bunker()
{
	
	trigger_wait( "trig_chain_bunkers_entrance_past", "targetname" );
	autosave_by_name( "Pel2 near bunker 1" );			
	
}



///////////////////
//
// piggybacking autosaves onto other triggers, to save entities
//
///////////////////////////////	

save_near_corsair_trap()
{
	
	trigger_wait( "trig_save_before_trap", "targetname" );
	autosave_by_name( "Pel2 near corsair trap" );			
	
}



spawn_middle_at47()
{

	trigger_wait( "trig_spawn_middle_at47", "targetname" );
	
	// piggybacking this here to save a trigger enty
	// spawn AT47 between bunker 1 and 2
	maps\_vehicle::scripted_spawn( 22 );

}



set_custom_approach() 
{ 
    
    if( !IsDefined( anim.NotFirstTime ) ) 
	{
		wait( 0.1 ); 
	} 
  
  	add_custom_exposed_approach( 0, %run_2_crouch_F ); 
	add_custom_exposed_exit( 0, %crouch_2_runCQB ); 
	//add_custom_exposed_exit( 0, %crouch_2run_F ); 
} 



add_custom_exposed_approach( index, approach_anim ) 
{ 
	type = "custom_exposed"; 
	anim.coverTrans[type][index] = approach_anim; 
	anim.coverTransDist[type][index] = getMoveDelta ( anim.coverTrans[type][index], 0, 1 ); 
	anim.coverTransAngles[type][index] = getAngleDelta( anim.coverTrans[type][index], 0, 1 ); 
} 



add_custom_exposed_exit( index, approach_anim ) 
{ 
	type = "custom_exposed"; 
	anim.coverExit[type][index] = approach_anim; 
	anim.coverExitDist[type][index] = getMoveDelta ( anim.coverExit[type][index], 0, 1 ); 
	anim.coverExitAngles[type][index] = getAngleDelta( anim.coverExit[type][index], 0, 1 ); 
}




///////////////////
//
// handles coop players connecting/disconnecting as well as spawned/killed
//
///////////////////////////////

init_callbacks()
{
	level thread onFirstPlayerConnect();
	level thread onPlayerConnect();
	level thread onPlayerDisconnect();
	level thread onPlayerSpawned();
	level thread onPlayerKilled();
}



///////////////////
//
// Sets up objectives
//
///////////////////////////////

setup_objectives()
{
	
	
	objective_add( 1, "active", &"PEL2_SECURE_MANGROVE_AREA", ( 4032, -14250, -47 ) ); 
	objective_current ( 1 ); 
	
	level waittill( "obj_mangrove_complete" );
	
	objective_state ( 1, "done" );
	
//	wait_network_frame();
//	wait_network_frame();

	objective_add( 2, "active", &"PEL2_CLEAR_BUNKERS", ( 970, -10388, -42 ) ); 
	objective_current ( 2 ); 
	
	level waittill( "obj_bunkers_complete" );
	
	objective_state ( 2, "done" );

//	wait_network_frame();
//	wait_network_frame();


	objective_add( 3, "active", &"PEL2_FLAME_MG", ( -244.7, -6972.4, -31 ) ); 
	objective_current ( 3 ); 
	
	level waittill( "obj_flame_complete" );
	
	objective_string( 3, &"PEL2_ADVANCE_TOWARDS_AIRFIELD" );
	objective_position( 3, ( -301, -6976, -260 ) );

	level waittill( "obj_forest_complete" );
	
	objective_state ( 3, "done" );

//	wait_network_frame();
//	wait_network_frame();


	objective_add( 4, "active", &"PEL2_CLEAR_THE_BUILDING", ( 2605, -602, 37 ) ); 
	objective_current ( 4 ); 
	
	level waittill( "obj_building_complete" );
	
	objective_string( 4, &"PEL2_ASSAULT_AIRFIELD" );
	objective_position( 4, ( 2755, 8112.7, 127 ) );
	
	level waittill( "obj_assault_airfield_complete" );
	
	objective_string( 4, &"PEL2_GET_BAZOOKA" );
	objective_position( 4, ( 2704.9, 4525.2, -23.1 ) );
//	Objective_additionalPosition( 4, 3, ( 2704.9, 4525.2, -23.1 ) );
	objective_ring( 4 );

	level waittill( "obj_airfield_tanks_complete" );



	objective_add( 5, "active", &"PEL2_AA_BUNKER", (4091, 7782, 58) );
	objective_current ( 5 ); 

	// flag set on trigger
	flag_wait( "trig_last_aa_guys" );

	objective_string( 5, &"PEL2_DESTROY_AA_GUNS_4" );
	wait_network_frame();		// Space out the objective set, from the following spawn a little.
	level thread maps\pel2_airfield::last_aa_guns_objective();

	level waittill( "obj_airfield_complete" );
	
	objective_state ( 5, "done" );


	
	flag_wait( "last_counterattack_start" );
	


	objective_add( 6, "active", &"PEL2_COUNTERATTACK", ( 2251.1, 8557.9, 124 ) );
	objective_current ( 6 ); 

	level waittill( "obj_counterattack_complete" );

	objective_state ( 6, "done" );
	
}



///////////////////
//
// Sets up objectives when used with starts
//
///////////////////////////////

setup_objectives_skip()
{
	
	wait ( 0.05 );
	
	obj_complete = 0;
	
	start_string = GetDvar( "start" );
	
	// determine how far to skip
	switch( start_string )
	{
		
		case "flame":
			
			obj_complete = 2;
			break;
					
		case "forest":
		
			obj_complete = 4;
			break;
		
		case "admin":
		
			obj_complete = 4;
			break;		
		
		case "airfield":
			
			obj_complete = 5;
			break;
		
		case "aaguns":
			
			obj_complete = 7;
			break;		
		
		case "napalm":
			
			obj_complete = 9;
			break;				
		
		default:
			return;
					
	}	
	
	obj_index = 1;
	
	
	// actually send out notifies that the setup_objectives() thread will receive so it can skip objectives
	while( obj_index <= obj_complete )
	{

		if( obj_index == 1 )
		{
			level notify( "obj_mangrove_complete" );
		}
		else if( obj_index == 2 )
		{
			level notify( "obj_bunkers_complete" );
		}
		else if( obj_index == 3 )
		{
			level notify( "obj_bunker_regroup_complete" );
			wait( 0.05 );
			level notify( "obj_ready_to_suppress_bunker" );
		}	
		else if( obj_index == 4 )
		{
			level notify( "obj_flame_complete" );
		}			
		else if( obj_index == 5 )
		{
			level notify( "obj_forest_complete" );
		}	
		else if( obj_index == 6 )
		{
			level notify( "obj_building_complete" );
		}	
		else if( obj_index == 7 )
		{
			level notify( "obj_assault_airfield_complete" );
		}	
		else if( obj_index == 8 )
		{
			level notify( "obj_airfield_tanks_complete" );
		}				
		else if( obj_index == 9 )
		{
			flag_set( "trig_last_aa_guys" );
			wait( 0.05 );
			level notify( "obj_airfield_complete" );
		}	
		
		obj_index++;
		wait ( 0.05 );
		
	}
	
}


