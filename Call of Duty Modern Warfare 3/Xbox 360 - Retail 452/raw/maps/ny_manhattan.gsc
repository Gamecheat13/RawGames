#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_audio;

#include maps\ny_manhattan_code_intro;
#include maps\ny_manhattan_code_downtown;
#include maps\ny_manhattan_code_hind;
#include maps\ss_util;

main()
{
	template_level( "ny_manhattan" );
	level.isdemo = true;		// comment this out for the shipping version
	level.use_hind_mg = true; // uncomment to use the turretweapon rather than the vehicle weapon
	
	level.VISION_UAV = "ny_manhattan_predator";
	level.uav_missile_tag_for_camera = "tag_camera";
	level.uav_missile_override = "remote_missile_ny";
	//level.remotemissile_usethermal = true;
	
	flag_init( "entering_hind" );
	flag_init( "player_on_hindgun" );

	//intro
	flag_init( "briefing_done" );
	flag_init( "manhattan_battle_complete" );
	flag_init( "heat_battle_initial_complete" );
	flag_init( "broad_squad_moveup" );
	flag_init( "broad_squad_moveup_again" );
	flag_init( "broad_hind_strafe_setup" );
	flag_init( "broad_hind_strafe" );
	flag_init( "obj_broad_marker_off" );
	flag_init( "finished_hide_ride" );
	flag_init( "heat_combat_humvees" );
	flag_init( "hind_hover_waves_complete" );
	flag_init( "player_shot_or_advanced" );
	flag_init ( "player_shot" );
	flag_init( "player_advanced" );
	flag_init( "player_used_hybrid" );
	flag_init( "hind_start_point" );
	flag_init( "flashbang_start" );
	flag_init( "sandman_kick_start" );
	flag_init( "flashbang_done" );
	flag_init( "punish_player" );
	flag_init( "intro_rubble_impact" );
	flag_init( "reno_truck_take_left" );
	flag_init( "start_open_manhole_cinematic" );
	flag_init( "jammer1_dead" );
	flag_init( "jammer2_dead" );
	flag_init( "allies_into_chopper" );
	flag_init( "out_of_sewer" );
	flag_init ( "show_pda" );
	flag_init ( "hide_pda" );
	flag_init ( "no_briefing_start" );
	flag_init ( "sandman_ambush_lines" );
	flag_init ( "lobby_delta2_in_position" );
	flag_init ( "lobby_sandman_in_position" );
	flag_init ( "flashbang_open_door" );
	flag_init ( "thermite_planted" );
	flag_init ( "thermite_detonated" );
	flag_init ( "has_usp" );
	flag_init( "players_first_shot" );
	flag_init ( "mulekick_done" );
	flag_init ( "give_predator" );
	flag_init ( "broad_humvee_dead" );
	flag_init ( "broad_hind_attractor_first_time" );
	flag_init ( "broad_humvee_explosion" );
	flag_init ( "exchange_humvee_go" );
	flag_init ( "bravo_defended" );
	flag_init ( "predator_defend_complete" );
	flag_init ( "rooftop_defend_complete" );
	flag_init ( "predator_phase2" );
	flag_init ( "blackhawk_at_rooftop" );
	flag_init ( "predator_wave1_dead" );
	flag_init ( "predator_wave2_dead" );
	flag_init ( "bravo_killed" );
	flag_init ( "predator_hind_deadly" );
	flag_init ( "predator_hind_dead" );
	flag_init ( "player_used_predator" );
	flag_init ( "predator_player_ranaway" );
	flag_init ( "predator_player_ranaway_clear" );
	flag_init ( "predator_hit_line_success" );
	flag_init ( "obj_predator_given" );
	flag_init ( "hind_finale_start" );
	flag_init ( "jammer_guys_dead" );
	flag_init ( "predator_lookat_changed" );
	flag_init ( "nyse_start_point" );
	flag_init ( "trk_lookout" );
	flag_init ( "snd_werehit" );
	flag_init ( "rno_hangon" );
	flag_init ( "trk_goingdown" );
	flag_init ( "snd_pressureinpedals" );
	flag_init ( "rno_braceforimpact" );
	flag_init ( "snd_enroute" );
	flag_init ( "spawn_bravo_early" );
	flag_init ( "15broad_highguys_dead" );
	flag_init ( "uav_in_use" );
	flag_init ( "squad_at_roof" );
	flag_init ( "player_has_xm" );
	flag_init ( "sandman_on_blackhawk" );
	flag_init ( "player_can_jump_on_blackhawk" );
	flag_init ( "sandman_animating" );
	flag_init ( "player_backtracked" );
	flag_init ( "hind_dmg_hint" );
	flag_init ( "player_used_xm25" );
	flag_init ( "player_used_ads" );
	flag_init ( "fb_leader_flashbanged" );
	

	//nyse
	flag_init( "nyse_player_up_top" );
	
	//for fx
	flag_init("level_started_fx");
	

	//objectives
	flag_init( "obj_follow_to_hind_given" );
	flag_init( "obj_broad_given" );
	flag_init( "obj_broad_complete" );
	flag_init( "obj_follow_to_exchange_complete" );
	flag_init( "obj_capturehind_given" );
	flag_init( "obj_capturehind_complete" );
	flag_init( "obj_follow_through_buildings_given" );
	flag_init( "obj_follow_through_buildings_complete" );
	flag_init ( "obj_nyse_rally_given" );
	flag_init ( "obj_nyse_rally_complete" );
	flag_init ( "obj_follow_to_roof_given" );
	flag_init ( "obj_follow_to_roof_complete" );
	flag_init ( "obj_climb_ladder_given" );
	flag_init ( "obj_climb_ladder_complete" );
	flag_init ( "obj_jammer_given" );
	flag_init ( "obj_jammer_complete" );
	
	//global adjust specular in level
	setsaveddvar( "r_specularcolorscale", "2.5" ); 
	
	//set dvar for E3 demo "In the interest of time"
	setdvarifuninitialized ( "demo_itiot", 0 );
	
	level.default_goalradius = 64;
	
	level.missile_intro = 0;

	level.hind_target = getent( "hind_target", "targetname" );
	level.start_manhattan_battle = getent( "start_manhattan_battle", "targetname" );

	PreCacheModel( "weapon_blackhawk_minigun" );		// the blackhawk side turret
	PreCacheModel( "weapon_blackhawk_minigun_viewmodel" );		// the blackhawk side turret viewmodel
	PreCacheModel( "viewmodel_magnifier" );		// the magnifier model for the m4 hybrid

	//level.player_hind = getent( "hind_vehicle", "targetname" );
	//level.player_hind thread maps\ny_blackhawk::setup_ny_harbor_hind( true );
	thread monitor_player_in_godmode();

	maps\createart\ny_manhattan_art::main();
	maps\ny_manhattan_fx::main();
	maps\ny_manhattan_precache::main();
	maps\ny_manhattan_aud::main();
	maps\ny_manhattan_anim::main();
	maps\_compass::setupMiniMap( "compass_map_dcemp_static" );
	maps\_predator2::main();
	maps\_xm25::init();
	
	
	PreCacheString( &"NY_MANHATTAN_INTROSCREEN_LINE1" );
	PreCacheString( &"NY_MANHATTAN_INTROSCREEN_LINE2" );
	PreCacheString( &"NY_MANHATTAN_INTROSCREEN_LINE3" );
	PreCacheString( &"NY_MANHATTAN_INTROSCREEN_LINE4" );
	PreCacheString( &"NY_MANHATTAN_INTROSCREEN_LINE5" );

	PreCacheString( &"NY_MANHATTAN_BRAVO_KILLED" );
	
	//objective strings
	PreCacheString( &"NY_MANHATTAN_OBJ_CLIMB_TO_ROOF" );
	PreCacheString( &"NY_MANHATTAN_OBJ_BROAD" );
	PreCacheString( &"NY_MANHATTAN_OBJ_ROOF" );
	PreCacheString( &"NY_MANHATTAN_OBJ_RALLY_LOBBY" );
	PreCacheString( &"NY_MANHATTAN_OBJ_JAMMER" );
	PreCacheString( &"NY_MANHATTAN_OBJ_USEREAPER" );
	

	PreCacheString( &"NY_MANHATTAN_FLASHBANG" );
	PreCacheString( &"NY_MANHATTAN_PREDATOR" );
	precachestring ( &"INVASION_DRONE_PICKUP" );
	precachestring ( &"NY_MANHATTAN_ITIOT" );
	precachestring ( &"NY_MANHATTAN_HINT_ADS" );
	precachestring ( &"NY_MANHATTAN_HINT_ADS_TOGGLE" );
	precachestring ( &"NY_MANHATTAN_HINT_FRAG" );
	precachestring ( &"NY_MANHATTAN_HINT_XM25" );
	precachestring ( &"NY_MANHATTAN_HINT_SNAPTO" );
	precachestring ( &"NY_MANHATTAN_HINT_HYBRID" );
	precachestring ( &"NY_MANHATTAN_HINT_HIND_DMG" );
	precachestring ( &"NY_MANHATTAN_HINT_HIND_DMG_PRED" );
	precachestring ( &"NY_MANHATTAN_HINT_OBJECTIVE" );
	precachestring ( &"NY_MANHATTAN_DEATH_BROAD_HIND" );
	precachestring ( &"NY_MANHATTAN_HINT_THERMITE_SWITCH" );
	precachestring ( &"NY_MANHATTAN_HINT_THERMITE_DETONATE" );
	precachestring ( &"NY_MANHATTAN_HINT_SHOOT_PREDATOR" );
	precachestring ( &"NY_MANHATTAN_WARN_BACKTRACK" );
	
	add_hint_string( "hint_flashbang", &"NY_MANHATTAN_FLASHBANG" );
	add_hint_string( "hint_predator", &"NY_MANHATTAN_PREDATOR", ::should_break_predator_hint );
	add_hint_string( "hint_ads", &"NY_MANHATTAN_HINT_ADS", ::should_break_use_ads );
	add_hint_string( "hint_ads_toggle", &"NY_MANHATTAN_HINT_ADS_TOGGLE", ::should_break_use_ads );
	add_hint_string( "hint_ads_empty", "", ::should_break_use_ads );
	add_hint_string( "hint_frag", &"NY_MANHATTAN_HINT_FRAG" );
	add_hint_string( "hint_xm25", &"NY_MANHATTAN_HINT_XM25", ::should_break_use_xm25 );
	add_hint_string( "hint_snapto", &"NY_MANHATTAN_HINT_SNAPTO", ::should_break_snapto );
	add_hint_string( "hint_hybrid", &"NY_MANHATTAN_HINT_HYBRID", ::should_break_use_hybrid );
	add_hint_string( "hint_hind_dmg", &"NY_MANHATTAN_HINT_HIND_DMG", ::should_break_hind_dmg_hint );
	add_hint_string( "hint_hind_dmg_predator", &"NY_MANHATTAN_HINT_HIND_DMG_PRED", ::should_break_hind_dmg_hint );
	add_hint_string( "hint_predator_shoot", &"NY_MANHATTAN_HINT_SHOOT_PREDATOR", ::should_break_predator_shoot_hint );
	add_hint_string( "hint_thermite_detonate", &"NY_MANHATTAN_HINT_THERMITE_DETONATE", ::should_break_thermite_detonate_hint );
	add_hint_string( "hint_thermite_switch", &"NY_MANHATTAN_HINT_THERMITE_SWITCH", ::should_break_thermite_switch_hint );
	add_hint_string( "hint_obj", &"NY_MANHATTAN_HINT_OBJECTIVE", ::should_break_hint_obj );
	add_hint_string( "hint_backtrack", &"NY_MANHATTAN_WARN_BACKTRACK", ::should_break_hint_backtrack );
	
//	PreCacheItem( "mp5_silencer" );
	PreCacheItem( "m4_grunt_reflex" );	
	PreCacheItem( "m4_grunt_reflex_optim" );	
	PreCacheItem( "m4_hybrid_grunt_optim" );
	PreCacheItem( "m4_hybrid_grunt_reflex_optim" );
	PreCacheItem( "rpg_straight" );
	PreCacheItem( "rpg_cheap" );
	PreCacheItem( "tomahawk_missile" ); 
	PreCacheItem( "ssn12_missile" ); 
	PreCacheItem( "zippy_rockets" );
	PreCacheItem( "usp" );
	PreCacheItem( "ninebang_grenade" );
	
	precacheitem ( "claymore" );
	PreCacheItem( "remote_missile_detonator" );
	
	PreCacheRumble( "c130_flyby" );
	PreCacheRumble( "damage_heavy" );
	PreCacheRumble( "steady_rumble" );
	PreCacheRumble( "falling_land" );
	
	PrecacheShellShock ( "default" );
	
	precachemodel ( "body_delta_elite_assault_aa" );
	
	PreCacheShader ( "dpad_thermite_bomb_static" );
	

	// starts
	add_start( "Intro",::start_manhattan_battle, "Intro",::manhattan_battle );
	add_start( "Manhattan Skip Briefing",::start_no_briefing, "Manhattan Skip Briefing",::no_briefing );
	add_start( "15 Broad",::start_fifteen_broad, "15 Broad",::fifteen_broad );
	add_start( "Tiffanys",::start_stephanies_battle, "Tiffanys",::stephanies_battle );
	add_start( "Stock Exchange",::start_nyse, "Stock Exchange",::nyse );
	add_start( "Jammer",::start_jammer, "Jammer",::jammer );
	add_start( "Hind Ride",::start_hind_ride_flight, "Hind Ride",::hind_ride_flight ); //this start just to skip hind hover combat
	add_start( "Hind Finale",::start_hind_finale, "Hind Finale",::hind_finale ); //this start just to skip to finale


// Fire lights
	flag_init( "off_fire_light" );
	
//Fires are gone
//thread ny_manhattan_exchange_fire();
//thread ny_manhattan_distant_fire();

  thread ny_manhattan_15broad_tv();
  thread ny_manhattan_15broad_hallway();
  thread ny_manhattan_15broad_lobby();
  thread ny_manhattan_intro_fire();
  
  	maps\_minigun::main();
  
	maps\_load::main();
	maps\_c4::main( "thermite", "weapon_thermite_device", "weapon_thermite_device_obj" ); //add reference to c4 utility script's main function
	maps\_remotemissile::init();

	// more setup
	thread nyse_flag();
	thread player_backtrack_fail_setup();
	thread setup_ignore_suppression_triggers();
	thread monitor_player_used_hybrid();
	thread monitor_xm25_achievement();
	
	//rumble ent
	level.rumble = get_rumble_ent( "steady_rumble" );
	level.rumble.intensity = 0;
	//setup player participation and friendly fire thresholds
	level.friendlyfire[ "max_participation" ]	 = 2000;	// the player will stop gaining participation points once this amount is earned
	level.friendlyfire[ "point_loss_interval" ] = 2.5;		// amount of time a point lasts
	level.player.participation = 2000;
		
	//no ai should draw on minimap until jammer is done
	add_global_spawn_function ( "axis", ::compass_nodraw );
	add_global_spawn_function ( "allies", ::compass_nodraw );
	all_ai = getaiarray ();
	foreach ( guy in all_ai )
		guy.drawoncompass = false;
	
	setsaveddvar( "compassmaxrange", 6000 );
	
	obj_setup();
	
	//thread maps\ny_blackhawk::fix_hind_doors();
	if (!isdefined(level.use_hind_mg))
		level.player_hind thread maps\ny_blackhawk::swap_hind_guns(false);
	level.player_arms = spawn_anim_model( "player_rig" );
	level.player_legs = spawn_anim_model( "player_legs" );
	level.player_arms hide();
	level.player_legs hide();
}

/****************************************************************************
    HINT WAIT FUNCTIONS
****************************************************************************/
should_break_use_ads()
{
	if ( level.player buttonpressed ( "BUTTON_LTRIG" ) )
		return true;
	return false;
	
}

should_break_use_xm25()
{
	weapon = level.player GetCurrentPrimaryWeapon();
	if ( IsSubStr( weapon, "xm25" ) )
		return true;
	return false;
	
}

should_break_snapto()
{
	if ( level.player GetLocalPlayerProfileData( "autoAim" ) == false )
		return true;
	return false;
}

should_break_use_hybrid()
{
	if ( flag ( "backtrack_warn" ) || flag ( "player_used_hybrid" ) )
		return true;
	if ( level.player GetCurrentWeapon() != "alt_m4_hybrid_grunt_optim" )
		return true;
	return false;
}

should_break_hind_dmg_hint()
{
	if ( isdefined ( level.high_priority_hint ) && level.high_priority_hint == true )
		return true;
	if ( flag ( "uav_in_use" ) )
		return true;
	if ( flag ( "predator_hind_dead" ) )
		return true;
	return false;
	
}

should_break_hint_obj()
{
	if ( flag ( "hind_dmg_hint" ) )
		return true;
	if ( flag ( "broad_hind_strafe_setup" ) )
		return true;
	return false;
	
}
	    
should_break_thermite_detonate_hint()
{
	if ( flag ( "thermite_detonated" ) )
		return true;
	if ( level.player GetCurrentWeapon() != "thermite" )
		return true;
	
	return false;
	           
}

should_break_thermite_switch_hint()
{
	if ( level.player GetCurrentWeapon() == "thermite" )
		return true;
	return false;
	
}

should_break_predator_shoot_hint()
{
	if ( level.player AttackButtonPressed() )
		return true;
	if ( !flag ( "uav_in_use" ) )
		return true;
	return false;
	
}

should_break_hint_backtrack()
{
	if ( !flag ( "backtrack_warn" ) )
		return true;
	return false;
	
}
	    

monitor_player_used_hybrid()
{
	while (true)
	{
		level.player waittill("weapon_change", weapon);
		if ( weapon == "m4_hybrid_grunt_optim" )
		{
			flag_set("player_used_hybrid");
			break;
		}
	}
}

monitor_player_in_godmode()
{
	cur_godmode = IsGodMode(level.player);
	while (true)
	{
		if (isdefined(level.player_hind))
		{
			if (IsGodMode(level.player) != cur_godmode)
			{
				cur_godmode = IsGodMode(level.player);
				level.player_hind.godmode = cur_godmode;
			}
		}
		wait 0.5;
	}
}

should_break_predator_hint()
{
	if ( flag ( "uav_in_use" ) )
		return true;
	if ( flag ( "hind_dmg_hint" ) )
		return true;
	if ( flag( "entering_hind" ) )
		return true;
	if ( flag( "predator_hind_dead" ) )
		return true;
	if ( flag ( "backtrack_warn" ) )
		return true;
	return false;
}

/****************************************************************************
    HINT WAIT FUNCTIONS
****************************************************************************/

should_break_open_manhole()
{
	return flag( "start_open_manhole_cinematic" );
}



/****************************************************************************
    ACHIEVEMENT MONITORING
****************************************************************************/
monitor_xm25_achievement()
{
	level.xm25_death_count = 0;
	add_global_spawn_function("axis", ::monitor_xm25_death);	
}

monitor_xm25_death()
{
	Assert( IsAI( self ) );
	
	if ( !IsAlive( self ) )
		return;
	
	self waittill( "death", attacker, type, weapon );
	
	if ( IsDefined( weapon ) && IsSubStr( weapon, "xm25" ) )
	{
		level.xm25_death_count++;
		
		if ( level.xm25_death_count == 30 )
		{
			level.player player_giveachievement_wrapper( "THIS_IS_MY_BOOMSTICK" );
		}
	}
}


/****************************************************************************
    DEBUG CHECKPOINTS
****************************************************************************/

do_temp_vo_test()
{
	wait( 3 );

	/*** Fire off continual random conversations. ***/
	// NOTE:  TEMP VO TEST (see ny_harbor_aud.gcs for actual usage example:  EXAMPLE_play_random_temp_vo_conversation())
	aud_send_msg( "play_random_temp_vo", 5 ); // Play 5 random temp vo lines.	

}


// this routine is used only for setting up the debug starts
create_and_position_allies_and_player( targetname )
{
	level.squad1 = [];
	allies = getentarray( "squad_1", "targetname" );
	loc =[];
	loc[loc.size] = getent( targetname + "_1", "targetname" );
	loc[loc.size] = getent( targetname + "_2", "targetname" );
	loc[loc.size] = getent( targetname + "_3", "targetname" );
	idx = 0;

	foreach( ally in allies )
	{
		squad_guy = ally spawn_ai();
		
		if ( squad_guy.script_noteworthy == "leader" )
		{
			level.sandman = squad_guy;
			level.sandman.animname = "lonestar";
		}
		else if ( squad_guy.script_noteworthy == "truck" )
		{
			level.truck = squad_guy;
			level.truck.animname = "truck";
		}
		else
		{
			level.reno = squad_guy;
			level.reno.animname = "reno";
		}
		squad_guy teleport_ent( loc[idx] );
		squad_guy magic_bullet_shield();
		level.squad1[level.squad1.size] = squad_guy;
		idx++;
				
	}
	
	player_pos = getent( targetname, "targetname" );
	level.player teleport_ent( player_pos );
	give_player_weapon( level.isdemo );
	thread define_squad_leader();
}

start_manhattan_battle()
{
	aud_send_msg("start_manhattan_battle");
	flag_set ( "level_started_fx" );
	level.player setchannelvolume("ambdist1", 0);
	level.player setchannelvolume("ambdist2", 0);
	//create_and_position_allies_and_player( "start_manhattan_battle" );

	//turn off hind sfx
	//thread vision_set_fog_changes("ny_manhattan_sewer",0);
}

start_no_briefing()
{
	aud_send_msg("start_no_briefing");
	flag_set ( "briefing_done" );
	flag_set ( "out_of_sewer" );
	flag_set ( "sandman_sewer_exit_moveup" );
	flag_set ( "no_briefing_start" );
	flag_set ( "level_started_fx" );
	//flag_set ( "give_predator" );
	flag_set ( "player_shot_or_advanced" );
	create_and_position_allies_and_player ( "start_post_sewer" );
	activate_trigger_with_targetname("ally_colors_first_combat");	
	activate_trigger_with_targetname("ally_colors_first_combat_blue");
	thread vision_set_fog_changes("ny_manhattan",0);
	thread broad_start();
	
	level.sandman.name = "Sandman" ;
	
}

start_fifteen_broad()
{
	aud_send_msg("start_fifteen_broad");
	flag_set ( "level_started_fx" );
	thread broad_breach();
	
	//set vision set and number of spotlight shadows
	thread vision_set_fog_changes("ny_manhattan_15broad",0);
	setsaveddvar("sm_spotlimit",4);
	
	level.broad_hind_fly = spawn_vehicle_from_targetname_and_drive ( "broad_hind" );
	level.broad_hind_fly thread hind_dmg_hint();
	//start_node = getstruct ( "broad_hind_strafe", "targetname" );
	//level.broad_hind_fly thread vehicle_paths_helicopter( start_node );
	thread broad_hind_strafe();
	create_and_position_allies_and_player ( "start_15broad" );
	flag_set ( "obj_follow_through_buildings_given" );
	flag_set ( "broad_squad_moveup" );
	thread broad_hind_strafe_setup();
	thread setup_tvs();
	
	level.sandman.name = "Sandman" ;
	
}

start_nyse()
{
	//thread setup_uav();
	aud_send_msg("start_nyse");
	flag_set ( "level_started_fx" );
	d2_leader_spawner = getent ( "d2_leader", "script_noteworthy" );
	level.delta2_leader = d2_leader_spawner spawn_ai (true);
	level.delta2_leader.animname = "delta2_leader";
	
	flag_set ( "obj_nyse_rally_given" );
	flag_set ( "nyse_start_point" );
	flag_set ( "broad_squad_moveup" );
	flag_set ( "give_xm25" );

	CreateThreatBiasGroup ( "sandman_15_broad" );
	//set vision set and number of spotlight shadows
	thread vision_set_fog_changes("ny_manhattan_nyse",0);
	setsaveddvar("sm_spotlimit",4);
	
	create_and_position_allies_and_player ( "start_nyse" );
	
	thread tiff_main();
	thread wait_for_player_entering_hind();	// we may disable this until the battle is done.
	thread player_enter_hind();
	thread setup_tvs();
	
	battlechatter_on ( "allies" );
	
	//give the objective
	flag_set ( "obj_follow_to_roof_given" );
	
	level.sandman.name = "Sandman" ;
}

start_jammer()
{
	//thread setup_uav();
	aud_send_msg("start_jammer");
	flag_set ( "level_started_fx" );

	//set vision set and number of spotlight shadows
	thread vision_set_fog_changes("ny_manhattan",0);
	setsaveddvar("sm_spotlimit",1);
	
	create_and_position_allies_and_player ( "start_jammer" );
	bravo_start1 = getent ( "start_nyse_grizzly", "targetname" );
	bravo_start2 = getent ( "start_nyse_worm", "targetname" );
	bravo_start3 = getent ( "start_nyse_thumper", "targetname" );
	
	level.delta2 = [];
	bravo_spawners = getentarray ( "delta2_spawners", "targetname" );
	
	foreach (spawner in bravo_spawners )
	{
		guy = spawner stalingradspawn ();
		guy thread magic_bullet_shield ( true );
		guy set_force_color ( "r" );
		level.delta2 [ level.delta2.size ] = guy;
		
		if ( guy.script_noteworthy == "d2_leader" )
		{
			level.delta2_leader = guy;
			level.delta2_leader.animname = "delta2_leader";
		}
		
		else if ( guy.script_noteworthy == "worm" )
			level.worm = guy;
		
		else if ( guy.script_noteworthy == "thumper" )
			level.thumper = guy;
	}
	
	level.delta2_leader teleport_ent ( bravo_start1 );
	level.worm teleport_ent ( bravo_start2 );
	level.thumper teleport_ent ( bravo_start3 );
	
	wait 0.05;
	grizzly_node = getnode ( "node_d2_lobby", "targetname" );
	level.delta2_leader set_force_color ( "o" );
	level.delta2_leader setgoalnode ( grizzly_node );
	
	activate_trigger_with_targetname ( "jammer_start_r_colors" );
	
	thread tiff_main();
	thread wait_for_player_entering_hind();	// we may disable this until the battle is done.
	thread player_enter_hind();
	
	battlechatter_on ( "allies" );
	
	//give the objective
	flag_set ( "obj_jammer_given" );
	
	level.sandman.name = "Sandman" ;
}

start_stephanies_battle()
{
	flag_set ( "level_started_fx" );
	flag_set ( "flashbang_done" );
	flag_set ( "obj_follow_through_buildings_given" );
	
	//set vision set and number of spotlight shadows
	thread vision_set_fog_changes("ny_manhattan_alley",0);
	setsaveddvar("sm_spotlimit",2);
	setsaveddvar("sm_qualityspotshadow",0);
	
	aud_send_msg("start_stephanies_battle");

	// spawn all of the allies that would normally be riding in the tigr
	create_and_position_allies_and_player( "start_stephanies_battle" );
	
	level.sandman.name = "Sandman" ;
}


start_hind_ride()
{
	aud_send_msg("start_hind_ride");
	flag_set ( "level_started_fx" );
	
	//set vision set and number of spotlight shadows
	//hind visionset is set via "thread player_enter_hind()"
	setsaveddvar("sm_spotlimit",1);
	setsaveddvar("sm_sunsamplesizenear",.8);
	setsaveddvar("sm_sunshadowscale",.65);
	
	hover_node = getstruct ( "blackhawk_hover", "targetname" );
	start_node = getstruct ( "blackhawk_startpath", "targetname" );
	level.player_hind = spawn_vehicle_from_targetname ( "hind_vehicle" );
	level.player_hind vehicle_teleport ( hover_node );
	
	hind = level.player_hind;
	
	assert( isdefined( level.player_hind ) );
	hind.health = 99999;
	start_squad_on_hind();
	teleport_player( hind );
	thread player_enter_hind(true);

	flag_set( "entering_hind" );
	
	thread maps\_compass::setupMiniMap("compass_map_ny_manhattan"); 
	
	level.sandman.name = "Sandman" ;
}


start_hind_ride_flight()
{
	flag_init ("end_new_orders_dialogue"); 

	flag_set ( "level_started_fx" );
	
	//set vision set and number of spotlight shadows
	//hind visionset is set via "thread player_enter_hind()"
	setsaveddvar("sm_spotlimit",1);
	setsaveddvar("sm_sunsamplesizenear",.8);
	setsaveddvar("sm_sunshadowscale",.65);
	
	hover_node = getstruct ( "blackhawk_hover", "targetname" );
	start_node = getstruct ( "blackhawk_startpath", "targetname" );
	level.player_hind = spawn_vehicle_from_targetname ( "hind_vehicle" );
	aud_send_msg("start_hind_ride_flight");	
	level.player_hind thread maps\ny_blackhawk::setup_ny_harbor_hind( true );
	
	wait 0.05;
	
	level.player_hind vehicle_teleport ( hover_node.origin, (0, 0, 0) );
	
	hind = level.player_hind;
	
	wait 0.05;
	
	assert( isdefined( hind ) );
	hind.health = 99999;
	start_squad_on_hind();
	teleport_player( hind );
	flag_set( "hind_start_point" );
	thread player_enter_hind(true);

	flag_set( "entering_hind" );
	
	level.sandman.name = "Sandman" ;
}

start_hind_finale()
{
	flag_init ("end_new_orders_dialogue"); 
	
	//set vision set and number of spotlight shadows
	//hind visionset is set via "thread player_enter_hind()"
	setsaveddvar("sm_spotlimit",1);
	setsaveddvar("sm_sunsamplesizenear",.8);
	setsaveddvar("sm_sunshadowscale",.65);
	
	hind = spawn_vehicle_from_targetname( "hind_vehicle" );
	assert( isdefined( hind ) );
	hind.health = 99999;
	level.player_hind = hind;
	aud_send_msg("start_hind_finale");
	level.player_hind thread maps\ny_blackhawk::setup_ny_harbor_hind( true );
	start_squad_on_hind();
	teleport_player( hind );
	flag_set( "hind_start_point" );
	thread player_enter_hind(true, true);
	level.just_finale = true;	// so we don't shoot missiles at end

	flag_set( "entering_hind" );
	// teleport to the starting points
	final_player_path= getstruct ("get_to_player_anim_pos", "targetname");
	final_enemy_path = getstruct ("get_to_enemy_anim_pos", "targetname");
	flag_set( "surprise_follower" );
	level.player_hind vehicle_pathdetach();
	wait 0.2;
	level.player_hind notify("newpath");	// get it off current path
	level.hind_battle_hind03c notify("newpath");	// get it off current path
	level.player_hind SetGoalYaw( flat_angle( final_player_path.angles )[ 1 ] );
	level.player_hind SetVehGoalPos( final_player_path.origin , 1 );
	wait 0.2;
	
	level.player_hind Vehicle_Teleport(final_player_path.origin, final_player_path.angles);	
	level.hind_battle_hind03c Vehicle_Teleport(final_enemy_path.origin, final_enemy_path.angles);	
	
	wait 0.2;
	flag_set("start_finale");
	
	level.sandman.name = "Sandman" ;
}

/****************************************************************************
    REAL GAME (SEQUENCED)
****************************************************************************/

manhattan_battle()
{
	
	if ( !level.missile_intro )
	{
		thread maps\_introscreen::introscreen_generic_black_fade_in( 8.5, 5 );
		
		//level.player shellshock ( "default", 17 );
		//create and spawn player's squad
		squad1_spawners = getentarray ( "squad_1", "targetname" );
		level.squad1 = [];
		
		foreach ( spawner in squad1_spawners )
		{
			squad1_guy = spawner spawn_ai (true);
			level.squad1[level.squad1.size] = squad1_guy;
			
			if ( squad1_guy.script_noteworthy == "leader" )
			{
				level.sandman = squad1_guy;
				level.sandman.animname = "lonestar";
			}
			else if ( squad1_guy.script_noteworthy == "truck" )
			{
				level.truck = squad1_guy;
				level.truck.animname = "truck";
			}
			else
			
			level.reno = squad1_guy;
			level.reno.animname = "reno";
		}
		//start intro
		thread humvee_intro();
		
		//give the player his weapon
		give_player_weapon();
		
		level.player FreezeControls( true );
		level.player setplayerangles ( (15, 81, 0) );
		level.player DisableWeapons();
		
		wait 4;
			
		lines = [];
	
		// D Day + 1
		lines[ lines.size ] = &"NY_MANHATTAN_INTROSCREEN_LINE1";
		// Day 10 - 10:18:[{FAKE_INTRO_SECONDS:02}]
		lines[ lines.size ] = &"NY_MANHATTAN_INTROSCREEN_LINE2";
		//Sgt. Derek "Frost" Westbrook
		lines[ lines.size ] = &"NY_MANHATTAN_INTROSCREEN_FROST";
		// Delta
		lines[ lines.size ] = &"NY_MANHATTAN_INTROSCREEN_LINE3";
		// US BattleGroup 2nd Battalion
		//lines[ lines.size ] = &"NY_MANHATTAN_INTROSCREEN_LINE4";
		// Manhattan, New York
		lines[ lines.size ] = &"NY_MANHATTAN_INTROSCREEN_LINE5";
	
		maps\_introscreen::introscreen_feed_lines( lines );
		
	}
	
	define_squad_leader();
	
	//start broad street scripting
	thread broad_start();

	//give objective to follow dude to heat battle
	flag_set( "obj_follow_to_hind_given" );

	//start thread for heat humvees
	thread heat_combat_humvees();
	
	//wait till	you get to Stephanie's and end this section
	flag_wait( "player_at_stephanies" );
	flag_set( "manhattan_battle_complete" );

	//save
	thread maps\_autosave::_autosave_game_now( false );
	
}



no_briefing()
{
	return;
}

fifteen_broad()
{
	return;
}

stephanies_battle()
{
	thread tiff_main();
	thread wait_for_player_entering_hind();	// we may disable this until the battle is done.
	thread player_enter_hind();
}


nyse()
{
	return;
}

jammer()
{
	return;
}

hind_ride()
{
	level waittill( "player_entered_hind" );
	autosave_by_name( "starting_blackhawk" ); 
	flag_wait( "finished_hide_ride" );	// this will never happen (we jump to movie)
}


hind_ride_flight()
{
	thread hind_ride();
	flag_wait( "finished_hide_ride" );	// this will never happen (we jump to movie)
}

hind_finale()
{
	thread hind_ride();
	flag_wait( "finished_hide_ride" );	// this will never happen (we jump to movie)
}

/****************************************************************************
    OBJECTIVE FUNCTIONS
****************************************************************************/
obj_setup()
{
	thread obj_follow_to_exchange();
	thread obj_broad();
	thread obj_follow_through_buildings();
	thread obj_follow_after_tiff();
	thread obj_rally_nyse();
	thread obj_follow_to_roof();
	thread obj_jammer();
	thread obj_predator();
	thread obj_capturehind();
		
}

obj_follow_to_exchange()
{
	marker = getent ( "exchange_marker", "targetname" );
	flag_wait( "sandman_sewer_exit_moveup" );
	wait 0.05;	// wait to be sure the server is running before
	objective_add( obj( "obj_follow_to_exchange" ), "active", &"NY_MANHATTAN_OBJ_BROAD", marker.origin );
	//objective_onentity( obj( "obj_follow_to_exchange" ), level.squad_leader );
	objective_current( obj( "obj_follow_to_exchange" ) );
	
}

obj_broad()
{
	marker = getent ( "broad_marker", "targetname" );
	flag_wait( "obj_broad_given" );
	
	wait 0.05;	// wait to be sure the server is running before
	objective_add( obj( "obj_follow_to_exchange" ), "active", &"NY_MANHATTAN_OBJ_BROAD", (marker.origin) );
	objective_current( obj( "obj_follow_to_exchange" ) );
	
	flag_wait_either ( "obj_broad_marker_off", "broad_hind_start" );
	objective_position ( obj( "obj_follow_to_exchange" ), (0, 0, 0) );
	
	flag_wait ( "obj_follow_through_buildings_given" );
	marker = getent ( "broad_marker_2", "targetname" );
	objective_add( obj( "obj_follow_to_exchange" ), "active", &"NY_MANHATTAN_OBJ_BROAD", (marker.origin) );
	objective_current( obj( "obj_follow_to_exchange" ) );
	
}

obj_follow_through_buildings()
{
	flag_wait( "player_reached_15_broad" );	
	flag_wait ( "squad_reached_15_broad" );
	
	wait 0.05;	// wait to be sure the server is running before
	objective_delete( obj( "obj_follow_to_exchange" ) );
	objective_add( obj( "obj_follow_to_exchange" ), "active", &"NY_MANHATTAN_OBJ_FOLLOW_THROUGH_BUILDINGS", (0, 0, 0) );
	objective_onentity( obj( "obj_follow_to_exchange" ), level.squad_leader );
	objective_current( obj( "obj_follow_to_exchange" ) );
	
}

obj_follow_after_tiff()
{
	marker = getent ( "wall_marker", "targetname" );
	flag_wait_either ( "tiff_fight_01a", "tiff_guys_dead" );
	wait 0.05;	// wait to be sure the server is running before
	objective_delete( obj( "obj_follow_to_exchange" ) );
	objective_add( obj( "obj_follow_to_exchange" ), "active", &"NY_MANHATTAN_OBJ_BROAD", marker.origin );
	//objective_onentity( obj( "obj_follow_to_exchange" ), level.squad_leader );
	objective_current( obj( "obj_follow_to_exchange" ) );
	
	flag_wait ( "obj_nyse_rally_given" );
	
	//objective_complete (obj ( "obj_follow_through_buildings" ) );
	
}

obj_rally_nyse()
{
	marker = getent ( "marker_nyse_rally", "targetname" );
	flag_wait( "obj_nyse_rally_given" );
	wait 0.05;	// wait to be sure the server is running before
	objective_delete( obj( "obj_follow_to_exchange" ) );
	objective_add( obj( "obj_follow_to_exchange" ), "active", &"NY_MANHATTAN_OBJ_RALLY_LOBBY", (marker.origin) );
	objective_current( obj( "obj_follow_to_exchange" ) );

	flag_wait( "obj_nyse_rally_complete" );
	objective_complete( obj( "obj_follow_to_exchange" ));
	
	flag_set ( "obj_follow_to_roof_given" );
}

obj_follow_to_roof()
{
	marker_paw = getent ( "paw_marker", "targetname" );
	marker_stair = getent ( "marker_nyse_stairs", "targetname" );
	marker_ladder = getent ( "marker_ladder", "targetname" );
	marker_roof = getent ( "marker_roof", "targetname" );
	
	flag_wait( "obj_follow_to_roof_given" );
	
	wait 0.05;	// wait to be sure the server is running before
//	objective_add( obj( "obj_follow_to_roof" ), "active", &"NY_MANHATTAN_OBJ_TAKEPAW", marker_paw.origin );
//	objective_current( obj( "obj_follow_to_roof" ) );
//	
//	flag_wait_either ( "give_paw", "skip_paw" );
		
	objective_add( obj( "obj_follow_to_roof" ), "active", &"NY_MANHATTAN_OBJ_ROOF", marker_stair.origin );
	//objective_onentity( obj( "obj_follow_to_roof" ), level.squad_leader );
	objective_current( obj( "obj_follow_to_roof" ) );
	
	flag_wait ( "dialog_head_up_top" );
	
	objective_add( obj( "obj_follow_to_roof" ), "active", &"NY_MANHATTAN_OBJ_ROOF", marker_ladder.origin );
	objective_current( obj( "obj_follow_to_roof" ) );
	
	flag_wait ( "obj_get_to_ladder" );

	objective_add( obj( "obj_follow_to_roof" ), "active", &"NY_MANHATTAN_OBJ_CLIMB_TO_ROOF", (marker_roof.origin) );
	objective_current( obj( "obj_follow_to_roof" ) );
	
	flag_wait ( "obj_climb_ladder_complete" );
	
	objective_complete ( obj( "obj_follow_to_roof" ) );
	
	flag_set ( "obj_jammer_given" );

}

obj_jammer()
{
	marker = getent ( "jammer", "targetname" );
	flag_wait( "obj_jammer_given" );
	
	wait 0.05;	// wait to be sure the server is running before
	objective_add( obj( "obj_jammer" ), "active", &"NY_MANHATTAN_OBJ_JAMMER", (marker.origin) );
	objective_current( obj( "obj_jammer" ) );
	
	flag_wait ( "thermite_planted" );
	
	objective_add( obj( "obj_jammer" ), "active", &"NY_MANHATTAN_DETONATE_THERMITE", (marker.origin) );
	objective_current( obj( "obj_jammer" ) );
	
	flag_wait( "obj_jammer_complete" );
	
	objective_complete( obj( "obj_jammer" ) );
}

obj_predator()
{
	flag_wait ( "obj_predator_given" );
	
	objective_add( obj( "obj_predator" ), "active", &"NY_MANHATTAN_OBJ_USEREAPER" );
	objective_current( obj( "obj_predator" ) );
	
	flag_wait ( "predator_lookat_changed" );
	
	objective_delete( obj( "obj_predator" ) );
	objective_add( obj( "obj_predator" ), "active", &"NY_MANHATTAN_PREDATOR_HIND" );
	objective_current( obj( "obj_predator" ) );
	objective_onentity( obj( "obj_predator" ), level.predator_hind );
	Objective_SetPointerTextOverride ( obj( "obj_predator" ), &"NY_MANHATTAN_OBJ_DOT_HIND" );
	
	flag_wait ( "predator_defend_complete" );
	
	objective_complete ( obj( "obj_predator" ) );
	
}

obj_capturehind()
{
	marker = getent ( "marker_get_on_blackhawk", "targetname" );
	
	flag_wait( "blackhawk_at_rooftop" );
	aud_send_msg( "blackhawk_at_roof");
	wait 0.05;	// wait to be sure the server is running before
	//obj_position = level.hind_target;
	objective_add( obj( "obj_capturehind" ), "active", &"NY_MANHATTAN_OBJ_CAPTURE_HIND", (marker.origin) );
	//objective_onentity( obj( "obj_capturehind" ), level.player_hind );
	objective_current( obj( "obj_capturehind" ) );

	flag_wait( "obj_capturehind_complete" );
	objective_complete ( obj( "obj_capturehind" ) );
}

// *****************************************************************************

nyse_flag()
{
	nyse_flag = getent ( "nyse_flag", "targetname" );
	nyse_flag.animname = "nyse_flag";
	nyse_flag setAnimTree();
	
	nyse_flag anim_loop_solo ( nyse_flag, "flag_flap", "stop_loop" );
	
}

// *****Fire Lights***** //

ny_manhattan_exchange_fire()
{

	light = GetEnt( "ny_manhattan_exchange_fire", "targetname" );
	if( !isdefined( light ) )
		return;
//	light SetLightColor( ( 1.000000, 0.831373, 0.439216 ) );

//make it waver intensity using strobLight functionality in _lights.gsc
//light thread maps\_lights::burning_trash_fire();
//strobeLight( intensity0, intensity1, period, kill_flag )
//flickerLight( color0, color1, minDelay, maxDelay )
//must have maxmove keypair on light in Radiant

light SetLightIntensity( ( 2.5 ) );
light thread maps\_lights::flickerLight( ( 1.000000, 0.831373, 0.439216 ), ( .2, 0.1662746, 0.0878432 ), .005, .15 );


// light thread maps\_lights::strobeLight( 1.2, 3, .25, "off_fire_light" );
	
	
//
//these numbers less than half of maxmove, and maxturn values
//	ang_range = ( 6, 6, 6);
//	org_range = ( 44, 44, 0 );
//	flare_offset = ( 50, 32, 64);
//	dir = 1;

	original_origin = light.origin;
	original_angles = light.angles;
	original_radius = light.radius;
	
	random_x		= 5;
	random_y 		= 5;
	random_z 		= 5;
	random_r 		= 5;
	min_delay 	= .075;
	max_delay 	= .35;
	
	while( !flag( "off_fire_light" ) )
		{
			delay = RandomFloatRange( min_delay, max_delay );
			amount = randomfloatrange( .1, 1 );
		
			x = ( random_x * ( randomfloatrange( .1, 1 ) ) );
			y = ( random_y * ( randomfloatrange( .1, 1 ) ) );
			z = ( random_z * ( randomfloatrange( .1, 1 ) ) );
			r = ( random_r * ( randomfloatrange( .1, 1 ) ) );

			new_position = original_origin + ( x, y, z );
			new_radius = original_radius - ( r );
			light moveto( new_position, delay ) ;
			light SetLightRadius( new_radius );
			wait delay;
		}
	light SetLightIntensity( 0 );	
}

ny_manhattan_intro_fire()
{

	light = GetEnt( "ny_manhattan_intro_fire", "targetname" );
	if( !isdefined( light ) )
		return;
		
//flickerLight( color0, color1, minDelay, maxDelay )

light SetLightIntensity( ( 1.5 ) );
light thread maps\_lights::flickerLight( ( 0.972549, 0.674510, 0.345098 ), ( .2, 0.1662746, 0.0878432 ), .005, .15 );

	original_origin = light.origin;
	original_angles = light.angles;
	original_radius = light.radius;
	
	random_x		= 5;
	random_y 		= 5;
	random_z 		= 5;
	random_r 		= 5;
	min_delay 	= .05;
	max_delay 	= .35;
	
	while( !flag( "off_fire_light" ) )
		{
			delay = RandomFloatRange( min_delay, max_delay );
			amount = randomfloatrange( .1, 1 );
		
			x = ( random_x * ( randomfloatrange( .1, 1 ) ) );
			y = ( random_y * ( randomfloatrange( .1, 1 ) ) );
			z = ( random_z * ( randomfloatrange( .1, 1 ) ) );
			r = ( random_r * ( randomfloatrange( .1, 1 ) ) );

			new_position = original_origin + ( x, y, z );
			new_radius = original_radius - ( r );
			light moveto( new_position, delay ) ;
			light SetLightRadius( new_radius );
			wait delay;
		}
	light SetLightIntensity( 0 );	
}

ny_manhattan_15broad_hallway()
{

	light = GetEnt( "ny_manhattan_15broad_hallway", "targetname" );
	if( !isdefined( light ) )
		return;

light SetLightIntensity( ( .9 ) );
light thread maps\_lights::flickerLight( ( 0.968628, 0.705882, 0.509804 ), ( 0.409804, 0.243137, 0.043137 ), .005, .15 );

	original_origin = light.origin;
	original_angles = light.angles;
	original_radius = light.radius;
	
	random_x		= 3;
	random_y 		= 3;
	random_z 		= 3;
	random_r 		= 3;
	min_delay 	= .075;
	max_delay 	= .35;
	
	while( !flag( "off_fire_light" ) )
		{
			delay = RandomFloatRange( min_delay, max_delay );
			amount = randomfloatrange( .1, 1 );
		
			x = ( random_x * ( randomfloatrange( .1, 1 ) ) );
			y = ( random_y * ( randomfloatrange( .1, 1 ) ) );
			z = ( random_z * ( randomfloatrange( .1, 1 ) ) );
			r = ( random_r * ( randomfloatrange( .1, 1 ) ) );

			new_position = original_origin + ( x, y, z );
			new_radius = original_radius - ( r );
			light moveto( new_position, delay ) ;
			light SetLightRadius( new_radius );
			wait delay;
		}
	light SetLightIntensity( 0 );	
}

ny_manhattan_15broad_lobby()
{

	light = GetEnt( "ny_manhattan_15broad_lobby", "targetname" );
	if( !isdefined( light ) )
		return;

light SetLightIntensity( ( 1.15 ) );
light thread maps\_lights::flickerLight( ( .929412, 0.570588, 0.28625 ), ( .2, 0.1662746, 0.0878432 ), .005, .15 );

	original_origin = light.origin;
	original_angles = light.angles;
	original_radius = light.radius;
	
	random_x		= 2;
	random_y 		= 2;
	random_z 		= 2;
	random_r 		= 2;
	min_delay 	= .075;
	max_delay 	= .35;
	
	while( !flag( "off_fire_light" ) )
		{
			delay = RandomFloatRange( min_delay, max_delay );
			amount = randomfloatrange( .1, 1 );
		
			x = ( random_x * ( randomfloatrange( .1, 1 ) ) );
			y = ( random_y * ( randomfloatrange( .1, 1 ) ) );
			z = ( random_z * ( randomfloatrange( .1, 1 ) ) );
			r = ( random_r * ( randomfloatrange( .1, 1 ) ) );

			new_position = original_origin + ( x, y, z );
			new_radius = original_radius - ( r );
			light moveto( new_position, delay ) ;
			light SetLightRadius( new_radius );
			wait delay;
		}
	light SetLightIntensity( 0 );	
}

ny_manhattan_15broad_tv()
{
       lights = GetEntArray( "ny_manhattan_15broad_tv", "targetname" );
       if( !isdefined( lights ) )
            return;

       foreach (light in lights)
       {                
           light SetLightIntensity( ( 1.7 ) );
           light thread maps\_lights::flickerLight( ( .690196, .8, 1.0 ), ( .337255, 0.368627, 0.411765 ), .002, .05 );
           
           light thread maps\_lights::kill_flicker_when_damaged( "trigger_static_tv" );
        }
}
