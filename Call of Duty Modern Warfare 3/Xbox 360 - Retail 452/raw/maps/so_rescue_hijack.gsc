#include maps\_utility;
#include animscripts\utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_specialops;
#include maps\_hud_util;
#include maps\_stealth_utility;
#include maps\_stealth_shared_utilities;
#include maps\_audio;
#include maps\_audio_music;
#include maps\_vehicle;
#include maps\_specialops_code;
#include maps\_shg_common;

#include maps\hijack_code;
#include maps\hijack_tarmac;
#include maps\_blizzard_hijack;
 
CONST_regular_obj	= &"HIJACK_OBJ_DAUGHTER";
CONST_hardened_obj	= &"HIJACK_OBJ_DAUGHTER";
CONST_veteran_obj	= &"HIJACK_OBJ_DAUGHTER";

CONST_SCORE_PER_KILL 	= 25;
CONST_MAX_KILLS 		= 64;

init_level_vars()
{
	level.vars = [];
	//AI Vars
	//init_level_var(	"ai_health", 			100, 		1, 		2, 		3		);	//100=1 Shot, 200=2 Shots
	init_level_var(	"prespotted_wait",		4,			1,		0.9,	0.9		);	//Time for the player kill ai before alerting the world
	init_level_var( "ai_accuracy",			1,			1,		1.0,	1.0 	);
	init_level_var( "reinforcements",		1,			2,		2,		3	); //Number of reinforcements to spawn when players break stealth
	
	//Helicopter Vars
	init_level_var(	"heli_health", 			2000, 		1, 		1.1, 	1.2		);	//Damage required to kill helicopter
	init_level_var( "heli_lag_distance",	500.0,		1,		0.9,	0.8		);	//How far the spotlight will lag when chasing player
	init_level_var( "heli_lag_time",		3000,		1,		0.9,	0.8		); 	//How long the light will lag before speeding up
	
	//Hostage
	init_level_var( "hostage_save_time",	5,			1,		0.9,	0.8		); //Time in seconds to save a hostage.
	
	//Alena
	if(noSlowMo())
	{
		init_level_var( "alena_pre_slowmo",		1.0,		1,		1,		1,		1);		//In coop, players get a couple of seconds to get in position to start slow mo
		init_level_var(	"alena_save_time",		6.0,		1,		0.9,	0.8,	1.0	);	//Time from when the player first sees the hostage to the time when the player is killed.
		init_level_var(	"alena_min_vis_time",	1500,		1,		1,		1,		1.0 );	//Min time the terrorist must see the player before firing the kill shot
		init_level_var( "alena_delay_shot_time",2.0,		1,		.75,	0.5,	1.5 );	//Time before enemies around Alena shoot (not the guy holding Alena)
		init_level_var( "alena_dog_delay",		1.0,		1,		1,		1,		3.0);	//Time before dogs will start attacking
	}
	else
	{
		init_level_var( "alena_pre_slowmo",		1.0,		1,		1,		1,		1);		//In coop, players get a couple of seconds to get in position to start slow mo
		init_level_var(	"alena_save_time",		4.0,		1,		0.9,	0.8,	1.0	);	//Time from when the player first sees the hostage to the time when the player is killed.
		init_level_var(	"alena_min_vis_time",	1000,		1,		1,		1,		1.0 );	//Min time the terrorist must see the player before firing the kill shot
		init_level_var( "alena_delay_shot_time",1.0,		1,		.75,	0.5,	1.5 );	//Time before enemies around Alena shoot (not the guy holding Alena)
		init_level_var( "alena_dog_delay",		0.5,		1,		1,		1,		3.0);	//Time before dogs will start attacking
	}
}

main()
{
	create_dvar( "rescue_no_coop_slowmo", "0" );
	
	precache_all();
	
	default_start( ::start_so_rescue_hijack );
	add_start( "so_rescue_hijack", ::start_so_rescue_hijack );
	
	level.custom_gameskill_func = ::remove_entities_by_script_difficulty;
	maps\_load::main();
	
	maps\so_rescue_hijack_slowmo_killswitch::init();
	
	maps\hijack_aud::main();
	
	level.idle_animation_list_func 	= ::hijack_idle_animation_list;
	level.idle_proc_func			= ::hijack_idle_proc;
	
	init_ambient();
	init_anims();
	init_stealth();
	init_human_shield();
	init_flares();
	init_scoring();
	init_level_vars();
	
	//level thread watch_for_player_kills_in_air();
	
	level thread cleanup_sp();
	level thread cleanup_paths();
	
	//level thread show_ai_dist();
	
	maps\_compass::setupMiniMap("compass_map_so_rescue_hijack_tarmac", "tarmac_minimap_corner");
	setsaveddvar( "compassmaxrange", 3500 ); //default is 3500
	
	level.so_stealth = true;
	
	/#
	level thread show_ai_health();
	level thread show_stealth_events();
	level thread debug_player_visible();
	#/
}

show_ai_dist()
{
	waitTime = .05;
	
	while(!IsDefined(level.players[0]))
	{
		wait waitTime;
	}
	while(1)
	{
		playerOrigin = level.players[0].origin;
		ai_array = GetAIArray("axis");
		ai_array = SortByDistance(ai_array, playerOrigin);
		
		if(ai_array.size>0)
		{
			ai_origin = ai_array[0].origin;
			thread draw_line_for_time(ai_origin, playerOrigin, 1,0,0,waitTime);
			
			dist = distance(ai_origin, playerOrigin);
			print3d( ai_origin, string(dist),(1,0,0), 1, 1 );	// origin, text, RGB, alpha, scale
		}
		wait waitTime;
	}
}

remove_entities_by_script_difficulty()
{
	maps\_gameskill::updateGameSkill();
	
	maps\hijack_code::so_remove_entities_by_script_difficulty();
}


//----------------------------------------------------------------
// Precache (Pre Load)
//----------------------------------------------------------------
precache_all()
{
	maps\so_rescue_hijack_precache::main();
	maps\createart\so_rescue_hijack_art::main();
	maps\hijack_fx::main();
	maps\hijack_anim::main();
	maps\hijack_precache::main();
	maps\hijack::level_precache();
	maps\hijack::level_init_flags();
	maps\hijack::level_init_assets();
	maps\_blizzard_hijack::blizzard_main();
	
	precache_effects();
	precache_vo();
	precache_anims();
	precache_flags();
	precache_models();

	PrecacheMinimapSentryCodeAssets();	
}
precache_effects()
{
	level._effect[ "extraction_smoke" ] 				= loadfx( "smoke/signal_smoke_green" );	// not used right now
	level._effect[ "flashlight" ]						= loadfx( "misc/flashlight_hijack_so" );
	level._effect[ "temp_light" ]						= loadfx( "maps/hijack/hostage_light_so" );
	
	level._effect[ "heli_spotlight" ] 					= LoadFX( "misc/docks_heli_spotlight_model_hj_so" );
	level._effect[ "aircraft_light_wingtip_green" ]		= loadfx( "misc/aircraft_light_wingtip_green_hjk_so" );
	level._effect[ "aircraft_light_wingtip_red" ]		= loadfx( "misc/aircraft_light_wingtip_red_hjk_so" );
	
	level._effect[ "horizon_fireglow" ]					= loadfx( "maps/hijack/horizon_fireglow_so" );
	
	level._effect[ "snow_spray_detail_oriented_runner_400x400_rvn" ] = loadfx( "snow/snow_spray_detail_oriented_runner_400x400_rvn_so" );
	
	level._effect[ "headshot1" ]					 	= loadfx( "impacts/flesh_hit_head_fatal_exit" );	// sprays on wall
	level._effect[ "headshot2" ]					 	= loadfx( "impacts/flesh_hit_splat_large" );		// chunks
	level._effect[ "headshot3" ]					 	= loadfx( "impacts/flesh_hit_body_fatal_exit" );// big spray
	level._effect[ "blood_pool" ]					 	= loadfx( "impacts/deathfx_bloodpool" );
	level._effect[ "flesh_hit" ]					 	= loadfx( "impacts/flesh_hit" );
	
	level._effect[ "spotlight_break" ]					= loadfx( "explosions/transformer_sparks_b" );
	level._effect[ "spotlight_spark01" ]				= loadfx( "explosions/generator_sparks_a" );
	level._effect[ "spotlight_spark02" ]				= loadfx( "explosions/generator_sparks_b" );
	
	level._effect[ "ground_flare" ]						= loadfx( "maps/hijack/hijack_flare_ambient_so" );
	
	precache_heli_fx();
}

precache_heli_fx()
{
	maps\_treadfx::setvehiclefx( "script_vehicle_mi17_woodland_landing_so", "snow", "treadfx/heli_snow_hijack_so" );
	maps\_treadfx::setvehiclefx( "script_vehicle_mi17_woodland_landing_so", "slush", "treadfx/heli_snow_hijack_so" );
	maps\_treadfx::setvehiclefx( "script_vehicle_mi17_woodland_landing_so", "ice", "treadfx/heli_snow_hijack_so" );
}

precache_vo()
{
	level.scr_radio[ "hijack_mkv_weakness" ] 						= "hijack_mkv_weakness";	// every man has his weakness.  Find the girl...
	
	level.scr_sound[ "hostage" ][ "so_ste_hijack_thankyou" ]		= "so_ste_hijack_thankyou";
	level.scr_sound[ "hostage" ][ "so_ste_hijack_cantthank" ]		= "so_ste_hijack_cantthank";
	level.scr_sound[ "hostage" ][ "so_ste_hijack_savedmylife" ]		= "so_ste_hijack_savedmylife";
	level.scr_sound[ "hostage" ][ "so_ste_hijack_justintime" ] 		= "so_ste_hijack_justintime";
	
	add_radio([
		"so_milehigh_fso1_makarov",
		"so_milehigh_fso1_discretion",
		"so_milehigh_fso1_takeitout",
		"so_milehigh_fso1_executing",
		"so_milehigh_fso1_needbackup",
		"so_milehigh_fso1_allagents"
	]); 

}

add_radio(lines)
{
	foreach(line in lines)
	{
		level.scr_radio[line] = line;	
	}	
}

radio_dialogue_queue_single( line )
{
	conversation_start();
	radio_dialogue( line );
	conversation_stop();
}

#using_animtree( "generic_human" );
precache_anims()
{
	level.scr_anim[ "generic" ][ "active_patrolwalk_v5" ] 			= %active_patrolwalk_v5;
	level.scr_anim[ "generic" ][ "active_patrolwalk_v4" ]			= %active_patrolwalk_v4;
	level.scr_anim[ "generic" ][ "active_patrolwalk_v2" ]			= %active_patrolwalk_v2;
	level.scr_anim[ "generic" ][ "active_patrolwalk_v1" ] 			= %active_patrolwalk_v1;
	level.scr_anim[ "generic" ][ "active_patrolwalk_pause" ] 		= %active_patrolwalk_pause;
	level.scr_anim[ "generic" ][ "active_patrolwalk_turn" ] 		= %active_patrolwalk_turn_180;
	level.scr_anim[ "generic" ][ "cqb_stand_idle_scan" ]			= %patrol_bored_react_look_v1; 
	
	/*-----------------------
	HUMAN SHIELD
	-------------------------*/
	//Slower idles if slow mo is disabled.
	level.scr_anim[ "hostage"   ][ "human_shield_idle_slow" ][ 0 ]		 		= %so_hijack_human_shield_idle_alena_slow;				// Alena idle
	level.scr_anim[ "terrorist" ][ "human_shield_idle_slow" ][ 0 ]				= %so_hijack_human_shield_idle_terrorist_slow;			// Terrorist idle
	level.scr_anim[ "hostage"   ][ "human_shield_idle" ][ 0 ]		 			= %so_hijack_human_shield_idle_alena;				// Alena idle
	level.scr_anim[ "terrorist" ][ "human_shield_idle" ][ 0 ]					= %so_hijack_human_shield_idle_terrorist;			// Terrorist idle
	level.scr_anim[ "terrorist" ][ "human_shield_death" ]		 				= %so_hijack_human_shield_head_shot_terrorist;		// terrorist killed, head shot
	level.scr_anim[ "hostage"   ][ "human_shield_death" ]			 			= %so_hijack_human_shield_alena_death_alena;		// Alena’s death anim
	level.scr_anim[ "terrorist" ][ "human_shield_pain" ]		 				= %so_hijack_human_shield_body_shot_terrorist;		// Terrorist shot, but not killed
	level.scr_anim[ "hostage"   ][ "human_shield_breakfree_partner_dead" ]		= %so_hijack_human_shield_head_shot_run_alena;		// Hostage run away when terrorist is killed with head shot
	level.scr_anim[ "terrorist" ][ "human_shield_breakfree_partner_dead" ]	 	= %so_hijack_human_shield_alena_death_terrorist;	// Terrorist lets go of dead hostage
	level.scr_anim[ "hostage"   ][ "human_shield_breakfree_partner_wounded" ] 	= %so_hijack_human_shield_body_shot_run_alena;		// Alena break free when terrorist is wounded
	level.scr_anim[ "hostage"   ][ "human_shield_loop_partner_wounded" ][ 0 ]	= %so_hijack_human_shield_body_shot_hide_loop_alena;// Alena loop after terrorist wounded
	level.scr_anim[ "hostage"   ][ "human_shield_loop_partner_dead" ][ 0 ]		= %so_hijack_human_shield_head_shot_hide_loop_alena;// Alena loop after terrorist killed
}

precache_flags()
{
	flag_init( "so_rescue_hijack_start" );
	flag_init( "so_rescue_hijack_success" );
	flag_init( "so_rescue_hijack_trigger" );
	flag_init( "so_rescue_start_heli_sounds" );
	
	flag_init( "stop_stealth_music" );
	flag_init( "someone_became_alert" );
	flag_init( "enemy_killed" );
	
	flag_init("heli_killed");
	
	//vip human shield
	flag_init( "human_shield_actors_spawned" );
	flag_init( "terrorist_killed" );
	flag_init( "terrorist_wounded" );
	flag_init( "friendlies_killed_human_shield" );
	flag_init( "restore_timescale" );
	flag_init( "human_shield_slowmo" );
}

precache_models()
{
//	precacheitem( "mp5_silenced_thermal" );
//	precacheitem( "usp_silencer" );
	precacheitem( "usp_silencer_so" );
	
	//Chopper Turret
	precacheturret( "heli_minigun_so" );
	precacheModel( "weapon_minigun" );

	PrecacheModel( "com_flashlight_on" );
	PrecacheModel( "com_flashlight_off" );
	
	precacheshader( "compass_objpoint_helicopter");
	
	tarmac_init_assets();
}



//----------------------------------------------------------------
// Initialization (Post Load)
//----------------------------------------------------------------
init_ambient()
{
//TODO: thread tarmac_carnage();  Do we want these civilian AI standing around anymore?
//TODO:	aud_send_msg("start_tarmac");
	
	// spinning turbine
//TODO:	engine = GetEnt("crashed_plane_engine","targetname");
//TODO:	engine.animname = "engine";
//TODO:	engine SetAnimTree();
//TODO:	engine thread anim_single_solo( engine, "engine_spin_slow" );	
}

init_anims()
{
	init_hostage_executor_anims();
	init_custom_idle_anim();
	
	maps\_idle::idle_main();
	maps\_idle_coffee::main();
	maps\_idle_smoke::main();
	maps\_idle_lean_smoke::main();
	maps\_idle_phone::main();
	maps\_idle_sleep::main();
	maps\_idle_sit_load_ak::main();
	maps\_idle_smoke_balcony::main();
	maps\_patrol_anims::main();
}

init_custom_idle_anim()
{
	level.scr_anim[ "generic" ][ "cold_idle" ][ 0 ]				= %so_hijack_search_cold_loop;
	level.scr_anim[ "generic" ][ "cold_react" ]					= %so_hijack_search_cold_reaction;
	
	level.scr_anim[ "generic" ][ "gear_check_idle" ][ 0 ]		= %so_hijack_search_gear_check_loop;
	level.scr_anim[ "generic" ][ "gear_check_react" ]			= %so_hijack_search_gear_check_reaction;
	
	maps\_props::add_cellphone_notetracks( "generic" );
	level.scr_anim[ "generic" ][ "texting_idle" ][ 0 ]			= %so_hijack_search_texting_loop;
	level.scr_anim[ "generic" ][ "texting_react" ]				= %so_hijack_search_texting_reaction;
	
	add_flash_light_notetracks("generic");
	level.scr_anim[ "generic" ][ "flashlight_high_idle" ][ 0 ]	= %so_hijack_search_flashlight_high_loop;
	level.scr_anim[ "generic" ][ "flashlight_high_react" ]		= %so_hijack_search_flashlight_high_reaction;
	level.scr_anim[ "generic" ][ "flashlight_low_idle" ][ 0 ]	= %so_hijack_search_flashlight_low_loop;
	level.scr_anim[ "generic" ][ "flashlight_low_react" ]		= %so_hijack_search_flashlight_low_reaction;

}

add_flash_light_notetracks(animname)
{
	addNotetrack_customFunction( animname, "attach flashlight", 	::attach_flashlight );
	addNotetrack_customFunction( animname, "detach flashlight", 	::detach_flashlight );
}

attach_flashlight(guy)
{
	guy attach_flashlight_in_hand();
}

detach_flashlight(guy)
{
	guy attach_flashlight_on_gun();
}

init_hostage_executor_anims()
{
	level.scr_anim[ "hostage" ][ "so_hijack_execution_standing_idle" ][0]		 	= %so_hijack_execution_standing_idle_agent;
	level.scr_anim[ "hostage" ][ "so_hijack_execution_to_knees" ]		 			= %so_hijack_execution_to_knees_agent_v1;
	level.scr_anim[ "hostage" ][ "so_hijack_execution_to_knees2" ]		 			= %so_hijack_execution_to_knees_agent_v2;
	level.scr_anim[ "hostage" ][ "so_hijack_execution_kneeling_idle" ][0]	 		= %so_hijack_execution_kneeling_idle_agent;
	level.scr_anim[ "hostage" ][ "so_hijack_execution_kneel_calm_kill" ]	 		= %so_hijack_execution_kneel_calm_kill_agent_v1;
	level.scr_anim[ "hostage" ][ "so_hijack_execution_kneel_calm_kill2" ]	 		= %so_hijack_execution_kneel_calm_kill_agent_v2;
	level.scr_anim[ "hostage" ][ "so_hijack_execution_kneel_alert_kill" ]	 		= %so_hijack_execution_alert_kneel_kill_agent;
	level.scr_anim[ "hostage" ][ "so_hijack_execution_stand_alert_kill" ]	 		= %so_hijack_execution_alert_stand_kill_v1_agent;
	//level.scr_anim[ "hostage" ][ "so_hijack_execution_stand_alert_kill" ]	 		= %so_hijack_execution_alert_stand_kill_v2_agent;
	
	level.scr_anim[ "hostage" ][ "so_hijack_execution_kneel_freed_r_start" ]	 	= %so_hijack_execution_kneel_freed_run_r_agent_start;
	level.scr_anim[ "hostage" ][ "so_hijack_execution_kneel_freed_r_loop" ][0]	 	= %so_hijack_execution_kneel_freed_run_r_agent_loop;
	level.scr_anim[ "hostage" ][ "so_hijack_execution_kneel_freed_r_end" ]	 		= %so_hijack_execution_kneel_freed_run_r_agent_end;
	
	level.scr_anim[ "hostage" ][ "so_hijack_execution_kneel_freed_l_start" ]	 	= %so_hijack_execution_kneel_freed_run_l_agent_start;
	level.scr_anim[ "hostage" ][ "so_hijack_execution_kneel_freed_l_loop" ][0] 		= %so_hijack_execution_kneel_freed_run_l_agent_loop;
	level.scr_anim[ "hostage" ][ "so_hijack_execution_kneel_freed_l_end" ]	 		= %so_hijack_execution_kneel_freed_run_l_agent_end;
	
	level.scr_anim[ "hostage" ][ "so_hijack_execution_stand_freed_l_start" ]	 	= %so_hijack_execution_stand_freed_run_left_agent_start;
	level.scr_anim[ "hostage" ][ "so_hijack_execution_stand_freed_l_loop" ][0] 		= %so_hijack_execution_stand_freed_run_left_agent_loop;                                    
	level.scr_anim[ "hostage" ][ "so_hijack_execution_stand_freed_l_end" ]	 		= %so_hijack_execution_stand_freed_run_left_agent_end;
	
	level.scr_anim[ "hostage" ][ "so_hijack_execution_stand_freed_r_start" ]	 	= %so_hijack_execution_stand_freed_run_right_agent_start;
	level.scr_anim[ "hostage" ][ "so_hijack_execution_stand_freed_r_loop" ][0] 		= %so_hijack_execution_stand_freed_run_right_agent_loop;
	level.scr_anim[ "hostage" ][ "so_hijack_execution_stand_freed_r_end" ]	 		= %so_hijack_execution_stand_freed_run_right_agent_end;
	
	level.scr_anim[ "executor" ][ "so_hijack_execution_standing_idle" ][0]	 	= %so_hijack_execution_standing_idle_terrorist;
	level.scr_anim[ "executor" ][ "so_hijack_execution_to_knees" ]	 			= %so_hijack_execution_to_knees_terrorist_v1;
	level.scr_anim[ "executor" ][ "so_hijack_execution_to_knees2" ]	 			= %so_hijack_execution_to_knees_terrorist_v2;
	level.scr_anim[ "executor" ][ "so_hijack_execution_kneeling_idle" ][0]	 	= %so_hijack_execution_aim_down_idle_terrorist;
	level.scr_anim[ "executor" ][ "so_hijack_execution_kneel_calm_kill" ]	 	= %so_hijack_execution_kneel_calm_kill_terrorist;
	level.scr_anim[ "executor" ][ "so_hijack_execution_kneel_alert_kill" ]	 	= %so_hijack_execution_alert_kneel_kill_terrorist;
	level.scr_anim[ "executor" ][ "so_hijack_execution_stand_alert_kill" ]	 	= %so_hijack_execution_alert_stand_kill_terrorist;
	


	
	addNotetrack_customFunction( "executor", "fire", ::executor_kill_hostage_notetrack );

}

init_stealth()
{
	battlechatter_off( "allies" );	

	maps\_stealth::main();
	maps\_stealth_utility::stealth_corpse_collect_func( ::stealth_collect_corpse_override );
	stealth_settings();
	thread stealth_music_control();

	foreach ( player in level.players )
	{
		player stealth_plugin_basic();
//		player thread playerSnowFootsteps();	// they look too big and poofy for this level
	}
}

stealth_collect_corpse_override()
{
	corpses				= GetCorpseArray();
	corpses_filtered	= [];
	
	foreach ( corpse in corpses )
	{
		// Ignore the hostages who have been executed
		if ( IsDefined( corpse.script_noteworthy ) && corpse.script_noteworthy == "ignore_corpse" )
			continue;
		
		corpses_filtered[ corpses_filtered.size ] = corpse;
	}
	
	return corpses_filtered;
}

init_scoring()
{
	level.num_hostages_rescued = 0;
	level.rescue_num_enemies = 0;
	level.custom_eog_no_defaults = 1;
	level.eog_summary_callback = ::customEOGSummary;
	level thread time_seen();
}

watch_for_player_kills_in_air()
{
	while(1)
	{
		level waittill( "specops_player_kill", player, killedEnt, weaponName );
		
		if(!player IsOnGround())
		{
			IPrintLnBold("Air Kill!");
		}
	}
}

time_seen()
{
	level endon( "special_op_terminated" );
	
	foreach ( player in level.players )
	{
		player.currently_seen = false;
		player.total_seen_time = 0;
		player thread time_seen_HUD();
		//player thread hostages_HUD();
	}
	
	while ( true )
	{
		waitframe();
		
		foreach( player in level.players)
		{
			seen_this_frame = player player_seen_recently(0.05);
			
			if(seen_this_frame)
			{
				if(player.currently_seen)
				{
					player.total_seen_time += GetTime() - player.last_seen_time;
				}
				player.currently_seen = true;
				player.last_seen_time = GetTime();
			}
			else
			{
				player.currently_seen = false;
			}
		}
	}
}

player_seen_recently(time_in_sec)
{
	all_ai = GetAIArray( "axis" );
	foreach ( guy in all_ai )
	{
		//Ignore guys on the helicopter
		if ( IsDefined( guy.vehicle_position ) )
		{
			continue;
		}
		
		if ( guy SeeRecently( self, time_in_sec ) )
		{
			return true;
		}
	}
	
	//Also check the heli
	if ( IsDefined( level.attack_heli ) )
	{
		heli_last_known_time = level.attack_heli heli_get_last_known_time(self, false);
		current_time = GetTime();
		elapsed_time = current_time - heli_last_known_time ;
		
		if ( heli_last_known_time != 0 && elapsed_time <= int(time_in_sec*1000) )
		{
			return true;
		}
	}
	
	return false;
}

time_seen_HUD()
{
	level endon( "special_op_terminated" );
	
	ypos = maps\_specialops::so_hud_ypos();
	self.hud_so_seen_msg = maps\_specialops::so_create_hud_item( 3, ypos, &"SO_RESCUE_HIJACK_TIME_SEEN_HUD", self );
	self.hud_so_seen_count = maps\_specialops::so_create_hud_item( 3, ypos, undefined, self );
	self.hud_so_seen_count.alignX = "left";
	
	self childthread maps\_specialops::info_hud_handle_fade( self.hud_so_seen_msg );
	self childthread maps\_specialops::info_hud_handle_fade( self.hud_so_seen_count );
	
	self thread time_seen_HUD_set_color();
		
	while( true )
	{
		time_string = convert_to_time_string( self.total_seen_time / 1000, true );
		self.hud_so_seen_count SetText( time_string );
		
		waitframe();
	}
}

time_seen_HUD_set_color()
{
	level endon( "special_op_terminated" );
	
	while ( true )
	{
		if ( self.currently_seen )
		{
			self.hud_so_seen_count set_hud_red();
			self.hud_so_seen_msg set_hud_red();
		}
		else
		{
			self.hud_so_seen_count set_hud_white();
			self.hud_so_seen_msg set_hud_white();
		}
		waitframe();
	}
}

hostages_HUD()
{
	level endon( "special_op_terminated" );
	
	ypos = maps\_specialops::so_hud_ypos();
	self.hud_so_hostages_msg = maps\_specialops::so_create_hud_item( 4, ypos, &"SO_RESCUE_HIJACK_HOSTAGES_RESCUED_HUD", self );
	self.hud_so_hostages_count = maps\_specialops::so_create_hud_item( 4, ypos, undefined, self );
	self.hud_so_hostages_count.alignX = "left";
	
	self childthread maps\_specialops::info_hud_handle_fade( self.hud_so_hostages_msg );
	self childthread maps\_specialops::info_hud_handle_fade( self.hud_so_hostages_count );
	
	self.hud_so_hostages_count SetText( "0/3" );
		
	while( true )
	{
		level waittill( "so_hostage_saved" );
		hostage_string = level.num_hostages_rescued + "/3";
		self.hud_so_hostages_count SetText( hostage_string );
		
		if ( level.num_hostages_rescued == 3 )
		{
			self.hud_so_hostages_count set_hud_green();
			self.hud_so_hostages_msg set_hud_green();
		}
	}
}

customEOGSummary()
{
	points_kills		= CONST_MAX_KILLS*CONST_SCORE_PER_KILL;	//64*25 		= 1600
	points_per_hostage 	= 800;									//*3 hostage 	= 2400
	points_seen			= 1000;									//				= 1000;
	points_time			= 5000;									//				= 5000;
	
	session_time = int( min( ( level.challenge_end_time - level.challenge_start_time ), 86400000 ) );
	total_kills = 0;
	total_seen_time = 0;
	
	// grab initial stats
	//-------------------
	foreach ( player in level.players )
	{
		player.so_eog_summary_data[ "seenTime" ] 		= round_millisec_on_sec(player.total_seen_time,2);
		
		total_kills += player.so_eog_summary_data[ "kills" ];
		total_seen_time += player.so_eog_summary_data[ "seenTime" ];
	}
	
	// Determine Score
	// ---------------
	
	//Points for base difficulty
	points_from_difficulty = int( level.specops_reward_gameskill * 10000 );
	level.session_score = points_from_difficulty;
	
	//Points for rescuing Hostages
	points_from_hostages = points_per_hostage*level.num_hostages_rescued;
	level.session_score += points_from_hostages;
	
	//Points for killing guys
	kill_score = CONST_SCORE_PER_KILL * level.players[0].so_eog_summary_data[ "kills" ];
	if( is_coop() )
	{
		kill_score += CONST_SCORE_PER_KILL * get_other_player( level.players[0] ).so_eog_summary_data[ "kills" ];
	}
	kill_score = int(min(kill_score, points_kills));
	level.session_score += kill_score;
	
	//Points for not being seen at all
	max_seen_time = 60 * 1000;
	if(is_coop())
		max_seen_time *= 2;
	seen_ratio = (1.0 - min(1.0,(total_seen_time/max_seen_time)));
	points_from_seen_time = int( seen_ratio * points_seen);
	level.session_score += points_from_seen_time;
	
	//Points for completing the mission in the time frame (not possible to get all of the points)
	worst_time = level.score_time_limit * 1000;
	points_from_time = 0;
	session_time -= 40 * 1000;	//Want to take advatage of the full range of score, no player can beat the level faster then 35 seconds
	session_time = round_millisec_on_sec(session_time, 2);	//Round off the score becasue we can't display the time to the 3 decimal place
	session_time = max(0,session_time); //safty check
	if ( session_time < worst_time )
		points_from_time = int ( ( ( worst_time - session_time ) / worst_time ) * points_time );
	level.session_score += points_from_time;
	
	foreach ( player in level.players )
		player override_summary_score( level.session_score );
	
	challenge_time_string = convert_to_time_string( level.score_time_limit, true );
	
	diffString[ 0 ] = "@MENU_RECRUIT";
	diffString[ 1 ] = "@MENU_REGULAR";
	diffString[ 2 ] = "@MENU_HARDENED";
	diffString[ 3 ] = "@MENU_VETERAN";
	
	score_label = undefined;
	col1_lable = undefined;
	col2_lable = undefined;
	col3_lable = undefined;
	if ( is_coop() )
	{
		score_label = "@SPECIAL_OPS_UI_TEAM_SCORE";
		col1_lable = "@SPECIAL_OPS_PERFORMANCE_YOU";
		col2_lable = "@SPECIAL_OPS_PERFORMANCE_PARTNER";
		col3_lable = "@SPECIAL_OPS_POINTS";
	}
	else
	{
		score_label = "@SPECIAL_OPS_UI_SCORE";
		col1_lable = "";//"@SPECIAL_OPS_COUNT";
		col2_lable = "@SPECIAL_OPS_POINTS";
	}
	
	clear_custom_eog_summary();
		
	foreach ( player in level.players )
	{
		seconds 		= player.so_eog_summary_data[ "time" ] * 0.001;
		time_string 	= convert_to_time_string( seconds, true );
		diff 			= diffString[ player.so_eog_summary_data[ "difficulty" ] ];
		final_score 	= player.so_eog_summary_data[ "score" ];
		kills			= player.so_eog_summary_data[ "kills" ];
		
		seen_time = player.so_eog_summary_data[ "seenTime" ];
		seen_time_string = convert_to_time_string(seen_time*0.001, true);

		hostageString = ""+level.num_hostages_rescued+"/3";
		if ( is_coop() )
		{
			p2_seen_time 		= get_other_player( player ).so_eog_summary_data[ "seenTime" ];
			p2_seen_time_string = convert_to_time_string(p2_seen_time*0.001, true);
			p2_diff 			= diffString[ get_other_player( player ).so_eog_summary_data[ "difficulty" ] ];
			p2_kills 			= get_other_player( player ).so_eog_summary_data[ "kills" ];


			if ( level.missionfailed )
			{
				player add_custom_eog_summary_line( "",										col1_lable,			col2_lable, 			undefined,		1 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_DIFFICULTY", 			diff, 				p2_diff, 				undefined,		2 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TIME", 				time_string, 		time_string,			undefined,		3 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_KILLS", 				kills, 				p2_kills, 				undefined,		4 );
				player add_custom_eog_summary_line( "@SO_RESCUE_HIJACK_TIME_SEEN", 			seen_time_string, 	p2_seen_time_string, 	undefined, 		5 );
				player add_custom_eog_summary_line(	"@SO_RESCUE_HIJACK_HOSTAGES_RESCUED",	hostageString, 		hostageString, 			undefined, 		6 );
			}
			else
			{
				player add_custom_eog_summary_line( "",										col1_lable, 		col2_lable, 			col3_lable, 			1 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_DIFFICULTY", 			diff, 				p2_diff, 				points_from_difficulty, 2 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TIME", 				time_string, 		time_string, 			points_from_time, 		3 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_KILLS", 				kills, 				p2_kills, 				kill_score,				4 );
				player add_custom_eog_summary_line( "@SO_RESCUE_HIJACK_TIME_SEEN", 			seen_time_string, 	p2_seen_time_string, 	points_from_seen_time, 	5 );
				player add_custom_eog_summary_line(	"@SO_RESCUE_HIJACK_HOSTAGES_RESCUED",	hostageString, 		hostageString, 			points_from_hostages, 	6 );

				if( !issplitscreen() )
					player add_custom_eog_summary_line_blank();
					
				player add_custom_eog_summary_line( score_label, 							final_score, 		undefined, 				undefined);
			}
		}
		else
		{
			
			if ( level.missionfailed )
			{
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_DIFFICULTY", 			diff, 				undefined, 			undefined,			1 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TIME", 				time_string, 		undefined,			undefined,			2 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_KILLS", 				kills, 				undefined, 			undefined,			3 );
				player add_custom_eog_summary_line( "@SO_RESCUE_HIJACK_TIME_SEEN", 			seen_time_string, 	undefined, 			undefined, 			4 );
				player add_custom_eog_summary_line(	"@SO_RESCUE_HIJACK_HOSTAGES_RESCUED", 	hostageString, 		undefined, 			undefined, 			5 );
			}
			else
			{
				player add_custom_eog_summary_line( "",										col1_lable,			col2_lable, 			col3_lable, 1 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_DIFFICULTY", 			diff, 				points_from_difficulty, undefined, 	2 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TIME", 				time_string, 		points_from_time, 		undefined, 	3 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_KILLS", 				kills, 				kill_score, 			undefined,	4 );
				player add_custom_eog_summary_line( "@SO_RESCUE_HIJACK_TIME_SEEN", 			seen_time_string, 	points_from_seen_time, 	undefined, 	5 );
				player add_custom_eog_summary_line(	"@SO_RESCUE_HIJACK_HOSTAGES_RESCUED", 	hostageString, 		points_from_hostages, 	undefined, 	6 );

				if( !issplitscreen() )
					player add_custom_eog_summary_line_blank();
					
				player add_custom_eog_summary_line( score_label, 							final_score, 		undefined, 				undefined);
			}
		}
	}
	
	if ( !level.missionfailed || IsSplitScreen() )
	{
		setdvar( "ui_hide_hint", 1 );
	}
	else
	{
		setdvar( "ui_hide_hint", 0 );
	}
}

kill_String(numKills)
{
	return ""+numKills+"/"+level.rescue_num_enemies;
}

cleanup_sp()
{
	so_delete_all_triggers();
	barrels = GetEntArray("explodable_barrel", "targetname");
	foreach (barrel in barrels)
	{
		if(IsDefined(barrel.target))
		{
			collision = GetEnt(barrel.target,"targetname");
			if(IsDefined(collision))
			{
				collision Delete();
			}
		}
		barrel Delete();
	}

	bushes = GetEntArray("so_bushes", "targetname");
	foreach (bush in bushes)
	{
		bush show();
	}
	
	heli_handle = GetEnt("heli_door_handle", "targetname");
	if(isDefined(heli_handle))
	{
		heli_handle Delete();
	}
	
	heli_interior = GetEntArray("heli_interior", "targetname" );
	foreach(object in heli_interior)
	{
		object Delete();
	}
	
	blurcard_ending = GetEntArray("hijack_blurcard_ending", "targetname" );
	foreach(object in blurcard_ending)
	{
		object Delete();
	}
	
	//Remove Path blocking volumes from SP
	path_blocking_vols = GetEntArray( "monster_clip_brush" , "targetname" );
	foreach(vol in path_blocking_vols)
	{
		vol ConnectPaths();
		vol delete();
	}

	//Add Path blocking for SO
	path_blocking_vols = GetEntArray( "brush_disconnect_paths" , "targetname" );
	foreach(vol in path_blocking_vols)
	{
		vol DisconnectPaths();
		vol delete();
	}
	
	//Remove Weapons
	weapons = GetEntArray("weapon_fraggrenade", "classname");
	weapons = array_combine(weapons, GetEntArray("weapon_flash_grenade", "classname"));
	weapons = array_combine(weapons, GetEntArray("weapon_ak47_acog", "classname"));
	weapons = array_combine(weapons, GetEntArray("weapon_ak74u", "classname"));
	weapons = array_combine(weapons, GetEntArray("weapon_fnfiveseven","classname"));
	weapons = array_combine(weapons, GetEntArray("weapon_pp90m1", "classname"));
	weapons = array_combine(weapons, GetEntArray("runner_ak74u", "targetname"));
	foreach(weapon in weapons)
	{
		weapon Delete();
	}
	
	//Clean up fx - this doesn't work becase the fire lights are baked.
	//thread cleanup_sp_fx();

}

cleanup_sp_fx()
{
	fx_origins_to_delete = array( ( 9096.33, 7025.13, 120.302 ) );
	
	//Wait for initFX
	while( !isDefined(level.createFXent[0].v["up"]))
	{
		wait .05;
	}
	
	foreach(fx_delete in fx_origins_to_delete)
	{
		foreach( fx in level.createFXent )
		{
			if ( !isdefined( fx.looper ) )
				continue;
			if(fx.v["origin"] != fx_delete)
				continue;
			fx.looper Delete();
			break;
		}
	}
}

cleanup_paths()
{
	path_blocking_vols = GetEntArray( "so_path_blocker" , "targetname" );
	foreach(vol in path_blocking_vols)
	{
		vol DisconnectPaths();
	}
}

is_helicopter_calm(useSeenTime)
{
	is_heli_killed = flag("heli_killed");
	is_heli_gone = !IsDefined( level.attack_heli );
	
	if ( is_heli_killed || is_heli_gone )
	{
		return true;
	}
	
	if(!isDefined(useSeenTime))
		useSeenTime = true;
	
	heli_time_last_time = 0;
	if(useSeenTime)
	{
		heli_time_last_time = level.attack_heli heli_get_last_seen_time_any_player();
	}
	else
	{
		heli_time_last_time = level.attack_heli heli_get_last_known_time_any_player(true);
	}
	time_passed = GetTime() - heli_time_last_time;
	heli_is_calm = heli_time_last_time == 0 || time_passed > level.helicopter_time_to_reset_stealth;
	                           
	return heli_is_calm;
}

is_ai_calm()
{
	return !flag("_stealth_spotted");
}

is_world_calm()
{
	return is_ai_calm() && is_helicopter_calm();
}

is_world_calm_wait()
{
	while(!is_world_calm())
	{
		wait .05;
	}
}
is_world_not_calm_wait()
{
	while(is_world_calm())
	{
		wait .05;
	}
}

enemies_ok_to_reset_stealth()
{
	guys = getaiarray( "axis" );
	
	foreach ( guy in guys )
	{
		// if this is defined then the guy is in the helicopter
		if ( IsDefined( guy.vehicle_position ) )
		{
			continue;
		}
		
		if(IsDefined(guy.enemy))
		{
			return false;
		}
	}

	return true;
}


init_flares()
{
	lights = getstructarray("flare","targetname");
	foreach(light in lights)
	{
		Playfx(getfx("ground_flare"), light.origin);
	}
	
}

hijack_idle_animation_list(default_array)
{
	default_array[default_array.size] = "flashlight_high";
	default_array[default_array.size] = "flashlight_low";
	default_array[default_array.size] = "cold";
	default_array[default_array.size] = "texting";
	default_array[default_array.size] = "gear_check";
	
	return default_array;
}

hijack_idle_proc(node, idle_anim, react_anim, death_anim)
{
	switch(node.script_animation)
	{
		case "cold":
		case "gear_check":
			break;	//Do Nothing
		case "flashlight_high":
		case "flashlight_low":
			self.dontRemoveFlashlightOnAlert = true; //It will be removed by the notetrack
			if(!flag("heli_killed"))
			{
				self attach_flashlight_in_hand();
			}
			break;
		case"texting":
			maps\_props::attach_phone( self );
			break;
		default:
			break;
	}

}

//----------------------------------------------------------------
// Setup Difficulty Levels
//----------------------------------------------------------------
so_setup_regular()
{
	level.challenge_objective 	= CONST_regular_obj;
	level.score_time_limit 	= 5*60;
}

so_setup_hardened()
{
	level.challenge_objective 	= CONST_hardened_obj;
	level.score_time_limit 	= 4*60;
}

so_setup_veteran()
{
	level.challenge_objective 	= CONST_veteran_obj;
	level.score_time_limit 	= 3*60;
}

so_rescue_hijack_init()
{
	add_global_spawn_function( "axis", ::enemy_init );
	add_global_spawn_function( "axis", ::disable_long_death );
	add_global_spawn_function( "axis", ::enemy_check_for_heli_target );
	add_global_spawn_function( "axis", ::enemy_counter );
	add_global_spawn_function( "axis", ::seek_player );
	add_global_spawn_function( "axis", ::seek_player_no_stealth );
	add_global_spawn_function( "axis", ::clear_hidden_enemy );
	add_global_spawn_function( "axis", ::override_footstep_distance );
	
	level thread friendly_fire_setup();

	level.enemies_killed = 0;

	assert( isdefined( level.gameskill ) );
	switch( level.gameSkill )
	{
		case 0:								// Easy
		case 1:	so_setup_Regular();	break;	// Regular
		case 2:	so_setup_hardened();break;	// Hardened
		case 3:	so_setup_veteran();	break;	// Veteran
	}

	level thread init_quotes();
	
//	thread enable_escape_warning();
//	thread enable_escape_failure();

//	thread penalty_timer();
	thread enable_challenge_timer( "so_rescue_hijack_start", "so_rescue_hijack_success" );
//	thread enable_triggered_complete( "so_rescue_hijack_trigger", "so_rescue_hijack_success", "all" );
	thread fade_challenge_out( "so_rescue_hijack_success" );
}

friendly_fire_setup()
{
	level.no_friendly_fire_penalty = undefined;
	fail_on_friendly_fire();
	
	level waittill( "friendlyfire_mission_fail" );
	level notify( "so_quote", "kill_civilian", true );
}

init_quotes()
{
	// in general use these random quotes, but there are places where we force a particular deadquote that overrides this
	random_deadquotes = [];
	random_deadquotes[ random_deadquotes.size ] = "@DEADQUOTE_SO_STEALTH_LOOK_FOR_ENEMIES";
	random_deadquotes[ random_deadquotes.size ] = "@DEADQUOTE_SO_STEALTH_STAY_LOW";
	random_deadquotes[ random_deadquotes.size ] = "@DEADQUOTE_SO_STEALTH_USE_SILENCERS";
	random_deadquotes[ random_deadquotes.size ] = "@SO_RESCUE_HIJACK_QUOTE_HIDE";
	random_deadquotes[ random_deadquotes.size ] = "@SO_RESCUE_HIJACK_QUOTE_KNIFE";
	random_deadquotes[ random_deadquotes.size ] = "@SO_RESCUE_HIJACK_QUOTE_HELI_SPOTLIGHT";
	random_deadquotes[ random_deadquotes.size ] = "@SO_RESCUE_HIJACK_QUOTE_HELI_ENEMIES";
	
	maps\_specialops::so_force_deadquote_array( random_deadquotes );
	
	// catch certain player death events
	foreach ( player in level.players )
	{
		player thread player_death_quote();
	}
	
	quote = undefined;
	
	while ( true )
	{
		// wait for conditional quotes that last for a certain amount of time
		level waittill( "so_quote", quote_id, override_so_system, how_long );
		
		switch ( quote_id )
		{
			case "kill_civilian":
				quote = "@SCRIPT_MISSIONFAIL_CIVILIAN_KILLED";
				break;
			case "killed_by_terrorist":
				quote = "@SO_RESCUE_HIJACK_QUOTE_KILLED_BY_TERRORIST";
				break;
			case "coop_slowmo_fail":
				quote = "@SO_RESCUE_HIJACK_QUOTE_COOP_END";
				break;
			case "sp_slowmo_fail":
				quote = "@SO_RESCUE_HIJACK_QUOTE_SP_END";
				break;
			default:
				continue;
		}
		
		// special failure hint turns off the regular so death quotes
		if ( IsDefined( override_so_system ) && override_so_system )
		{
			maps\_specialops_code::so_special_failure_hint_set( quote );
		}
		else
		{
			maps\_specialops::so_force_deadquote( quote );
		}
		
		// wait an amount of time and then reset to random quotes
		if ( IsDefined( how_long ) )
		{
			wait how_long;
			
			maps\_specialops::so_force_deadquote_array( random_deadquotes );
		}
	}
}

player_death_quote()
{
	level endon( "so_special_failure_hint_set" );
	
	self waittill( "death", attacker, cause, weapon );
	
	if ( isdefined( self.coop_death_reason ) )
	{
		attacker = self.coop_death_reason[ "attacker" ];
		cause = self.coop_death_reason[ "cause" ];
		weapon = self.coop_death_reason[ "weapon_name" ];
	}
	
	// the so version in the special ops code doesn't work on our vehicle
	if ( so_destructible_death_rescue( attacker, cause ) )
		return;
}

so_destructible_death_rescue( attacker, cause )
{
	if ( !isdefined( cause ) )
		return false;
		
	if ( !isdefined( attacker ) )
		return false;	
				
	if ( cause != "MOD_EXPLOSIVE" )
		return false;
	
	if ( issubstr( attacker.classname, "vehicle" )  )
	{
		// You were killed by an exploding vehicle. Vehicles on fire are likely to explode.
		maps\_specialops_code::so_special_failure_hint_set( "@SCRIPT_EXPLODING_VEHICLE_DEATH", "ui_vehicle_death" );
		return true;
	}

	return false;
}

enemy_check_for_heli_target()
{
	if (flag("heli_killed"))
	{
		investigate_heli_crash = !IsDefined(self.script_noteworthy) || (self.script_noteworthy!="seek_player" && !IsSubStr(self.script_noteworthy, "terrorist_so"));
		
		//If AI is not part of the stealth system do not allow them to run this code
		if(!IsDefined(self.script_stealthgroup))
			investigate_heli_crash = false;
		
		//Act like you found a corpse
		if(investigate_heli_crash)
		{
			spawn_failed( self );		//Wait for AI to be spawned
			self enemy_invesigate_heli_crash( self.origin );
		}
	}
}

enemy_invesigate_heli_crash( heli_origin )
{
	self endon( "death" );

	level._stealth.logic.corpse.last_pos = heli_origin;

	//give a chance
	if ( self.type == "dog" && self ent_flag_exist( "_stealth_behavior_reaction_anim_in_progress" ) )
	{
		wait .1;
		self ent_flag_waitopen( "_stealth_behavior_reaction_anim_in_progress" );
		wait .1;
	}
	else
		wait .1;

	self seek_corpse();

	//self thread enemy_corpse_clear();
}

seek_corpse()
{
	self thread enemy_announce_corpse();
	wait .1;

	corpse_flag = self group_get_flagname( "_stealth_found_corpse" );
	if ( !self stealth_group_corpse_flag() )
		self group_flag_set( "_stealth_found_corpse" );
	else
		level notify( corpse_flag );
}

enemy_init()
{
	if ( self.type == "dog" )
		return;
	
	self.baseaccuracy = get_level_var( "ai_accuracy" );
	self.dieQuietly = true;
	self.combatmode = "no_cover";
	self.goalradius = 40;
	self set_enemy_health();
	
	//Setting changed_team here prevents noteTrackFireSpray() from changing AI team.
	//If an AI changes team to "team3" he can be taken as an enemy by an "axis" guy
	//In stealth levels AI with enemies that are not players can cause SREs.
	self.changed_team = false;
	
	// no grenade drop, every axis resets this value when spawned
	level.nextGrenadeDrop	= 100000;
	
	self thread auto_detect_player();
}

auto_detect_player()
{
	self endon("death");
	
	detectDist = 180;
	detectDist *= detectDist;
	while(1)
	{
		wait .1;
		
		if(IsDefined(self.enemy))
			continue;
		
		foreach(player in level.players)
		{
			if( DistanceSquared(self.origin, player.origin) >= detectDist)
				continue;
				
			ai_dir = AnglesToForward(self.angles);
			dir_to_player = VectorNormalize(player.origin - self.origin);
			dot = VectorDot(ai_dir, dir_to_player);
			
			if(dot>-.2)
			{
				
				if( SightTracePassed(self GetEye(), player GetEye(), false, self) )
				{
					self GetEnemyInfo( player );
					break;
				}
			}
		}
	}
}

enemy_counter()
{
	level.rescue_num_enemies++;
	//self thread show_text(level.rescue_num_enemies);
}

show_text(text)
{
	self endon("death");
	
	while(1)
	{
		print3d( self.origin+(0,0,72), string(text),(1,0,0), 1, 1 );	// origin, text, RGB, alpha, scale
		wait( 0.05 );
	}
}

seek_player()
{
	if(!IsDefined(self.script_noteworthy) || self.script_noteworthy!="seek_player")
	{
		return;
	}
	
	self endon("death");
	
	//This will become undefined when the rope anims are done
	while(IsDefined(self.vehicle_position))
	{
		wait .1;
	}
	
	//Make sure stealth system has been started
	while(!IsDefined(self._stealth))
	{
		wait .1;
	}
	
	level._stealth.logic.corpse.last_pos = get_last_known_player_position();
		
	self seek_corpse();
}

seek_player_no_stealth()
{
	if( !IsDefined(self.script_noteworthy) || self.script_noteworthy != "seek_player_no_stealth" )
	{
		return;
	}
	
	self endon("death");
	
	//This will become undefined when the rope anims are done
	while(IsDefined(self.vehicle_position))
	{
		wait .1;
	}
	
	setup_enemy_behavior();
	
	position = get_last_known_player_position();
	
	self SetGoalPos( position );
}

get_last_known_player_position()
{
	//Find the last know pos of the most recently seen player
	seekPlayer = level.players[0];	//Defautls
	position = level.players[0].origin; //Default 
	if(IsDefined(level.attack_heli))
	{
		last_known_time = level.attack_heli heli_get_last_known_time(seekPlayer, true);
	
		foreach ( player in level.players )
		{
			if ( player == seekPlayer )
			{
				continue;
			}
			
			time = level.attack_heli heli_get_last_known_time( player, true );
			
			if ( last_known_time == 0 || time < last_known_time )
			{
				seekPlayer = player;
				last_known_time = time;
			}
		}
		
		if(last_known_time!=0)
		{
			position = level.attack_heli heli_get_last_known_pos(seekPlayer,true);
		}
	}
	
	return position;
}

//Normal stealth system has a distance requirment that doen't work for me
clear_hidden_enemy()
{
	self endon("death");
	
	while(1)
	{
		wait .1;
		
		if(IsDefined(self.enemy) && IsDefined(self.alertLevel) && self.alertLevel=="combat")
		{
			//If we are on out way to somewhere let us get there first before deciding we
			//have lost our enemy
			if(IsDefined(self.goalpos))
			{
				dist = DistanceSquared(self.origin, self.goalpos);
				if(dist>squared(self.goalradius))
				{
					continue;
				}
			}
			
			lastTime = self LastKnownTime( self.enemy );
			if(GetTime() - lastTime > 10000)
			{
				enemy_alert_level_forget( self.enemy, 0 );
				self ClearEnemy();
			}
		}
	}
}

override_footstep_distance()
{
	if(!IsDefined(self.script_noteworthy)|| self.script_noteworthy != "override_footstep_dist")
	{
		return;
	}
	
	self endon("death");
	while(1)
	{
		playerInDot = false;
		foreach(player in level.players)
		{
			ai_dir = AnglesToForward(self.angles);
			dir_to_player = VectorNormalize(player.origin - self.origin);
			dot = VectorDot(ai_dir, dir_to_player);
			if(dot>-.2)
			{
				playerInDot = true;
				break;
			}
		}
		
		if(playerInDot)
		{
			self.footstepdetectdist = 200;
			self.footstepdetectdistwalk = 200;
		}
		else
		{
			self.footstepdetectdist = 0;	//Use gloabl footstep distance
			self.footstepdetectdistwalk = 0;
		}
		wait .1;
	}
}

set_enemy_health()
{
	//self.maxHealth 	= get_level_var_int("ai_health");
	//self.health		= self.maxHealth;	
}

//Level vars - used for difficulty tuning
init_level_var(var_name, base, regular_scale, hardened_scale, veteran_scale, coop_scale)
{
	if(!IsDefined(regular_scale))
		regular_scale = 1.0;
	if(!IsDefined(hardened_scale))
		hardened_scale = regular_scale;
	if(!IsDefined(veteran_scale))
		veteran_scale = hardened_scale;
	if(!IsDefined(coop_scale))
	{
		coop_scale = 1.0;
	}
	
	level.vars[var_name][0] = base;
	level.vars[var_name][1] = regular_scale;
	level.vars[var_name][2] = hardened_scale;
	level.vars[var_name][3] = veteran_scale;
	level.vars[var_name][4] = ter_op( is_coop(), coop_scale, 1.0);
}

get_level_var(var_name)
{
	assert( isdefined( level.vars[var_name] ) );
	assert( level.gameskill != 0 );
	
	return level.vars[var_name][0] * level.vars[var_name][level.gameskill] * level.vars[var_name][4];		
}

get_level_var_int(var_name)
{
	return int(get_level_var(var_name));
}



//----------------------------------------------------------------
// Mission Main Script
//----------------------------------------------------------------
start_so_rescue_hijack()
{
	level.challenge_time_force_on = true;
	so_rescue_hijack_init();
	
//	level.daughter = spawn_targetname("daughter_tarmac");
//	level.daughter maps\hijack::setup_daughter();

	thread blizzard_level_transition_so( 3 );
	thread maps\_blizzard_hijack::blizzard_overlay_clear(); 
	
	thread fade_challenge_in(5.5, false);
	thread so_rescue_hijack_objectives();
	thread players_start();
	thread heli_start_sound("makarov_heli_so");
	
	wait(3);
	thread spawn_first_guys();
	thread spawn_second_guys();
	thread spawn_first_hostage();
	thread spawn_second_hostage();
	thread spawn_third_hostage();
	thread reinforcements();
	thread setup_node_actions();
	
	wait(4.0);
	
	thread attack_heli_so();
	wait(2.0);
	thread makarov_heli_so();
	
	wait(1.0);
	flag_set("so_rescue_hijack_start");
	//thread so_rescue_hijack_vehicles();
}

blizzard_level_transition_so( time )
{
	blizzard_set();
	//thread blizzard_level_transition( "light_so", time );
	thread blizzard_level_transition( "med_so", time );
	thread blizzard_set_culldist( 0, 0 );
	SetHalfResParticles( false );
	flag_set( "pause_blizzard_ground_fx" );
	blizzard_overlay_alpha( time, 1.0 );
	thread blizzard_set_sunlight( 0, time );
}

setup_node_actions()
{
	nodes = getstructarray( "so_disable_cqb", "script_noteworthy" );
	foreach ( node in nodes )
	{
		node thread node_disable_cqb();
	}
	
	nodes = getstructarray( "path_end", "script_noteworthy" );
	foreach ( node in nodes )
	{
		node thread node_disable_flashligh_walk();
	}
}


spawn_first_guys()
{
	spawner_array = getentarray( "so_first_guys", "targetname" );
	foreach( spawner in spawner_array )
	{
		spawner spawn_ai( true );
	}
}

spawn_second_guys()
{
	//trigger = GetEnt("so_second_guys_trigger","targetname");
	//trigger waittill("trigger");
	//spawner_array = getentarray( trigger.target, "targetname" );
	
	spawner_array = getentarray( "so_second_guys", "targetname" );
	foreach( spawner in spawner_array )
	{
		spawner spawn_ai( true );
	}
}

//If stealth is broken extra guys will spawn
reinforcements()
{
	level thread update_reinforcement_spawners();
	
	while(1)
	{
		is_world_not_calm_wait();
		wait 1;	//player has a short time to regain stealth before reinforements arrive
		if(!is_world_calm())
		{
			spawn_reinforcements();
		}
		is_world_calm_wait();
	}
}
spawn_reinforcements()
{
	spawners = SortByDistance(level.reinforcement_spawners, level.players[0].origin);
	
	numSpawns = 0;
	maxSpawns = get_level_var_int("reinforcements");
	
	minSpawnDist = 200;
	minSpawnDist *= minSpawnDist;
	for(i=0; i<spawners.size && numSpawns<maxSpawns; i++)
	{
		spawner = spawners[i];
		if(spawner.count<=0)
		{
			continue;
		}
		
		//Min dist
		playerDist = DistanceSquared(spawner.origin, level.players[0].origin);
		if(level.players.size>1)
			playerDist = min(playerDist, DistanceSquared(spawner.origin, level.players[1].origin));
		
		if(playerDist<minSpawnDist)
			continue;
		
		ai = spawner spawn_ai();
		if(IsDefined(ai))
		{
			numSpawns++;
			//ai thread show_text("R");	//Debug
		}
	}
	
	if(numSpawns>0 && level.reinforcement_vo!="")
	{
		level thread play_reinforcement_vo(level.reinforcement_vo, 3);
		level.reinforcement_vo = "";	//Make sure it only plays once
	}
	level.reinforcement_spawners = [];	//Clear spawner so they don't spawn more then once per area.
}

play_reinforcement_vo(vo_line, delay)
{
	wait delay;
	
	if(!is_world_calm())
	{
		level thread radio_dialogue_queue_single(vo_line);
	}
}
update_reinforcement_spawners()
{
	level.reinforcement_spawners = [];
	level.reinforcement_vo = "";
	
	
	level.reinforcement_spawners = GetEntArray("reinforcements1", "targetname" );	//Spawners in tarmac area
	
	trigger_start_tarmac = GetEnt("so_third_guys_trigger", "targetname");
	trigger_start_tarmac waittill("trigger");
	
	level.reinforcement_vo = "so_milehigh_fso1_allagents";
	
	level.reinforcement_spawners = GetEntArray("reinforcements2", "targetname" ); 	//Spawners in crash area
	
	trigger_start_crash = GetEnt("so_fourth_group_trigger", "targetname");
	trigger_start_crash waittill("trigger");
	
	level.reinforcement_vo = "so_milehigh_fso1_needbackup";
	
	level.reinforcement_spawners = GetEntArray("reinforcements3", "targetname" );	//Spawners past the log.
	
	trigger_log = GetEnt("so_fifth_group_trigger", "targetname");
	trigger_log waittill("trigger");
	
	level.reinforcement_vo = "";
	level.reinforcement_spawners = []; //Clear spawners because there is no where to safly spawn new AI that isn't behind the player
	
}

so_rescue_hijack_objectives()
{
	level endon( "special_op_terminated" );
	level waittill("so_rescue_hijack_objectives_start");
	
	Objective_Add( 1, "current", level.challenge_objective );
	marker = getstruct( "so_rescue_hijack_marker", "targetname" );
	while (IsDefined(marker))
	{
		Objective_Position( 1, marker.origin );
		if(IsDefined(marker.script_noteworthy) && marker.script_noteworthy == "Alena" )
		{
			level thread update_alena_marker_pos(marker);
			Objective_SetPointerTextOverride( 1,&"SO_RESCUE_HIJACK_ALENA" );
		}
		
		while ( !is_any_player_near( marker.origin, 256 ) )
		{
			wait(0.5);
		}
		
		
		if (IsDefined(marker.target))
		{
			marker = getstruct( marker.target, "targetname" );
		}
		else
		{
			marker = undefined;
		}
	}
	
}

is_any_player_near( pos, radius )
{
	foreach( player in level.players )
	{
		if ( Distance2D( player.origin, pos ) < radius)
		{
			return true;
		}
	}
	return false;
}

update_alena_marker_pos(marker)
{
	level endon( "special_op_terminated" );
	while(!Isdefined(level.hostage))
	{
		wait .1;
	}
	
	offset = marker.origin - level.hostage.origin;
	level.hostage endon("death");
	while(1)
	{
		Objective_Position( 1, level.hostage.origin + offset );
		wait .05;
	}
	
}


players_start()
{
	//Disable weapons for the first few seconds
	level thread disable_player_weapons();
	
	wait(0.45);
	level thread so_dialog_play("hijack_mkv_weakness");
	foreach(player in level.players)
	{
		//player PlaySoundAsMaster( "hijack_mkv_weakness", "so_mkv_weakness_done" );
		player thread player_bloody_screen( 18.0, 8.0 );
	}
	wait(4.0);
	
	foreach(player in level.players)
	{
		flag_set( "so_rescue_start_heli_sounds" );
		player PlaySound( "hijk_jet_tailcrunch1" );
		player ShellShock( "default", 6.0 );
	}
	
	wait(1.0);

	level thread enable_player_weapons(3.0);
	level notify("so_rescue_hijack_objectives_start");
	
	thread radio_dialogue_queue_single ( "so_milehigh_fso1_makarov" );
	//thread temp_dialogue( "Radio", "Makarov has the president. Hostile squads are sweeping the wreckage for Alena.", 5 );
	wait 5;
	thread radio_dialogue_queue_single ( "so_milehigh_fso1_discretion" );
	//thread temp_dialogue( "Radio", "Avoid or engage the enemy at your discretion. Secure the daughter at all costs.", 5 );
}

disable_player_weapons()
{
	enablePlayerWeapons(false);
	
	foreach(player in level.players)
	{
		//HACK to force prone 
		//player setstance( "prone" ); //This stopped working with exe 1099
		player AllowStand(false);
		player AllowCrouch(false);
		player.ignoreme = true;
		player SetWeaponAmmoClip( "fraggrenade", 0 );
		player SetWeaponAmmoStock( "fraggrenade", 0 );
		player.start_origin = player.origin;
		player.start_angles = player.angles;
	}
	
	//If controlls are disabled at the same time as setting stance the comand will be ignored
	wait .5;
	foreach(player in level.players)
	{
		player FreezeControls(true);
		player SetOrigin(player.start_origin);
		player SetPlayerAngles(player.start_angles);
	}
}
enable_player_weapons(delay)
{
	wait delay;
	
	enablePlayerWeapons(true);
	
	level thread delete_temp_sight_clip();
	
	//Force reload
	foreach(player in level.players)
	{
//		weapons = player GetWeaponsListPrimaries();
//		foreach(weapon in weapons)
//		{
//			player SetWeaponAmmoClip( weapon, 0 );
//			player SetWeaponAmmoStock( weapon, 60 );
//		}
		//player ForceViewmodelAnimation( "usp_silencer", "reload" );
		
		player.ignoreme = false;
		
		//HACK : Undo prone hack
		player AllowStand(true);
		player AllowCrouch(true);
		player FreezeControls(false);
	}
	
	waittillframeend;
	
	//Give max ammo
	foreach(player in level.players)
	{
		currentWeapon = player GetCurrentWeapon();
		player SetWeaponAmmoClip( currentWeapon, 12);
		player SetWeaponAmmoStock( currentWeapon, 72);
	}
}

delete_temp_sight_clip()
{
	ents = GetEntArray("temp_sight_clip","targetname");
	foreach(ent in ents)
	{
		ent Delete();
	}
}

player_bloody_screen( duration, fadeintime )
{
	overlay = NewClientHudElem( self );
	overlay.x = 0;
	overlay.y = 0;

	if ( issplitscreen() )
	{
		overlay SetShader( "splatter_alt_sp", 640, 480 * 2 );

		// offset the blood a little so it looks different for each player
		if ( self == level.players[ 0 ] )
		{
			overlay.y -= 120;
		}
	}
	else
	{
		overlay SetShader( "splatter_alt_sp", 640, 480 );
	}

	overlay.splatter = true;
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.sort = 1;
	overlay.foreground = 0;
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 1;

	wait(duration);

	time = fadeintime;
	overlay FadeOverTime( time );
	overlay.alpha = 0;

	wait( time );
	overlay Destroy();
}



//----------------------------------------------------------------
// Vehicles
//----------------------------------------------------------------
so_rescue_hijack_vehicles()
{
	flag_wait( "so_rescue_hijack_first_vehicle" );
	so_rescue_hijack_vehicle_spawn( 600, "vehicle_guys1" );
}

so_rescue_hijack_vehicle_spawn( group_num, ai_targetname )
{
	cars = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( group_num );
	wait .25;
	
	foreach(car in cars)
	{
		car thread maps\hijack_tarmac::turn_on_headlights();
		car thread suv_setup();
	}
}

suv_setup()
{
	self maps\_vehicle::vehicle_lights_on();
	self waittill( "death" );
	self maps\_vehicle::vehicle_lights_off( "all" );
}






//----------------------------------------------------------------
// Helicopter
//----------------------------------------------------------------
heli_loop_sounds()
{
	// stop any looping sounds from the vehicle system
	self StopLoopSound();

	// initialize our chopper audio and link it to the chopper entity
	if (!IsDefined(self.chopper_audio)) 
	{
		self.chopper_audio = Spawn( "script_origin", self.origin );
		self.chopper_audio LinkTo( self, "tag_origin", ( 0, 0, 64 ), ( 0, 0, 0 ) );
	}

	if (!IsDefined(self.chopper_audio.initialized))
	{
		//IPrintLn("**** chopper loop initialized.");
		self.chopper_audio.initialized = true;
		self.chopper_audio PlayLoopSound( "chopper_main" ); // override the chopper looping sound here
		chopper_tick_time = 0.05;
		while (IsDefined(self.chopper_audio))
		{
			// doppler settings:
			//		+/- 80 doppler velocity
			//		-2/+4 semitones
			//		unmodified pitch scalar
			//		distance tweak clamped at 8192
			//		distance-doppler scalar 2.0
			//		debug 3d scale 12
			self.chopper_audio maps\hijack_aud::tick_doppler( chopper_tick_time, 80, 0.8908987181403393, 1.2599210498948732, 1.0, 8192, 2.0, 12 );
	      	wait(chopper_tick_time);
	      	waittillframeend;
	      	if (isDefined(self._doppler) && isDefined(self._doppler.enabled) && !self.chopper_audio.enabled)
	      		break;
		}
	}
}
heli_start_sound(targetname)
{
	heli = GetEnt(targetname, "targetname");
	flag_wait( "so_rescue_start_heli_sounds" );
	heli childthread heli_loop_sounds();
	
	heli waittill("death");
	if(IsDefined(heli.chopper_audio))
	{
		heli.chopper_audio StopSounds();
		heli.chopper_audio Delete();
	}
}
makarov_heli_so()
{
	makarov_heli = GetEnt("makarov_heli_so", "targetname");
	makarov_heli thread heli_exit();
	makarov_heli thread maps\_vehicle::gopath( );
}

heli_exit()
{
	self endon( "death" );
	
	if(!self ent_flag_exist("heli_can_delete"))
	{
		self ent_flag_init("heli_can_delete");
	}
	self ent_flag_wait("heli_can_delete");
	self Delete();
}

attack_heli_so()
{	
	level.helicopter_time_to_lose_player = 3000;
	level.helicopter_time_to_reset_stealth = level.helicopter_time_to_lose_player + 10000;
	wait 1; // wait for 
	thread heli_start_sound("attack_heli_so");
	
	level.attack_heli = spawn_vehicle_from_targetname_and_drive("attack_heli_so");
	level.attack_heli thread heli_init_sight();
	level.attack_heli thread heli_watch_for_damage();
	level.attack_heli thread heli_watch_for_crash();
	level.attack_heli thread heli_set_health();
	level.attack_heli thread heli_update_exit_node();
	level.attack_heli thread setup_turret_so();
	level.attack_heli thread setup_spotlight_so();
	level.attack_heli thread maps\_vehicle::gopath();
	
	level.attack_heli thread attack_heli_so_think();
}

attack_heli_so_think()
{
	self endon("death");
	self endon("exit");
	level endon( "special_op_terminated" );
	
	// eschmidt: moved the target to spawn at the beginning and not get deleted all of the time
	self.heli_target = Spawn("script_origin", self heli_get_spotlight_look_at_point());
	self thread heli_turret_monitor_targets_so();
	
	while(1)
	{
		self notify("attack_heli_search");
		
		self ClearLookAtEnt();
		self thread spotlight_random_targets_so();
		
		//Wait for heli to notice player
		while(is_helicopter_calm(false))
		{
			wait .05;
		}
	
		self notify("attack_heli_combat");
		self thread spotlight_player_targets_so();
		self thread heli_target_player();
		self thread heli_move_to_target_player();
		self thread heli_fire_at_target_player();
		
		//Wait for heli to notice player
		while(!is_helicopter_calm(false))
		{
			wait .05;
		}
		
		continuePathNode = self attack_heli_get_closest_path();
		self thread maps\_vehicle::vehicle_paths( continuePathNode, false );
	}
}

attack_heli_get_closest_path()
{
	loopNodes = getstructarray("attack_heli_loop", "script_noteworthy");
	
	closestNode = undefined;
	closestDist = undefined;
	foreach(node in loopNodes)
	{
		dist = DistanceSquared(self.origin, node.origin);
		if(!IsDefined(closestDist) || dist<closestDist)
		{
			closestNode = node;
			closestDist = dist;
		}
	}
	
	return closestNode;
}

heli_init_sight()
{	//Init sight info
	self.player_info = [];
	foreach(player in level.players)
	{
		s  = SpawnStruct();
		s.last_known_time = 0;
		s.last_known_pos = (0,0,0);
		s.last_seen_time = 0;
		self.player_info[player.unique_id] = s;
	}
}

attack_heli_exit()
{
	self notify("exit");
	self ClearLookAtEnt();
	self Vehicle_SetSpeed(30);
	
	self thread maps\_vehicle::vehicle_paths( self.exitNode, false );
	self thread heli_exit();
}

heli_update_exit_node()
{
	self endon("death");
	self.exitNode = getstruct("exit_node_start","targetname");
	
	trigger_start_tarmac = GetEnt("so_third_guys_trigger", "targetname");
	trigger_start_tarmac waittill("trigger");
	
	self.exitNode = getstruct("exit_node_tarmac","targetname");
	
	trigger_start_crash = GetEnt("so_fourth_group_trigger", "targetname");
	trigger_start_crash waittill("trigger");
	
	self.exitNode = getstruct("exit_node_crash","targetname");
}

heli_destroy_objective()
{
	//So we can safly call this more then once
	if(isDefined(level.heli_destroy_objective) && level.heli_destroy_objective)
	{
		return;
	}
	level.heli_destroy_objective = true;
	Objective_Add( 2, "current", &"SO_RESCUE_HIJACK_OBJ_DISABLE_HELI" );
	Objective_SetPointerTextOverride( 2, &"SO_RESCUE_HIJACK_DISABLE_HELI" );
	Objective_AdditionalEntity( 2, 0, self);
	//Objective_Current_NoMessage( 2 );
	//objective_icon( 2, "compass_objpoint_helicopter" );
	waitType = self waittill_any_return( "deathspin", "exit", "death", "attack_heli_search" );
	
	spotLightBroken = IsDefined(self.spotlight) && self.spotlight.broken;
	if(waitType == "attack_heli_search" || (waitType == "exit" && !spotLightBroken) )
	{
		//Remove the objective if the player regains stealth or the heli is sent away manually (ie the end sequence)
		Objective_Delete(2);
	}
	else
	{
		//Complete objective if the player destroys the light or the helicopter
		Objective_complete(2);
	}

	
	level.heli_destroy_objective = false;
}

heli_watch_for_damage()
{
	self endon("death");
	
	while(1)
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, idFlags );
		
		if(!isPlayer(attacker))
		{
			continue;
		}
		
		self heli_update_last_known(attacker, false);
		
		//Check if spot light damaged
		spotlight = self.spotlight;
		if(IsDefined(spotlight) && !spotlight.broken)
		{
			dist = Distance(spotlight.origin, point);
			if(dist<40)
			{
				spotlight.broken = true;
				level notify("stop_spotlight_fx");
				
				spotlight thread heli_broken_light_fx();
				
				self thread heli_target_attach_to_helicopter();
				
				self thread attack_heli_exit();
			}
		}
	}
}

heli_watch_for_crash()
{
	self waittill( "deathspin" );
	flag_set("heli_killed");
	wait 3;
	self waittill("death");
}

heli_set_health()
{
	self notify( "stop_friendlyfire_shield" );
	self.health = get_level_var_int("heli_health");
}

heli_update_last_known(player, actually_saw)
{
	self.player_info[player.unique_id].last_known_time = GetTime();
	self.player_info[player.unique_id].last_known_pos = player.origin;
	
	//This wasn't just damage, the spot light saw the player
	if( actually_saw )
	{
	   //Tell everyone where the player is
		ai_array = getaiarray( "axis" );
		foreach(ai in ai_array)
		{
			if(!IsDefined(ai.enemy) || ai.enemy == player)
			{
				ai GetEnemyInfo(player);
			}
		}
		
		self.player_info[player.unique_id].last_seen_time = GetTime();
		
	}
}

heli_can_see(player, ignoreFOV)
{
	if(!isDefined(player))
	{
		return false;
	}
	if(!IsDefined(ignoreFOV))
	{
		ignoreFOV = false;
	}
	spotlightDir = AnglesToForward(self.spotlight GetTagAngles( "tag_flash" ));
	//thread draw_debug_line(self.spotlight.origin, self.spotlight.origin + (spotlightDir*800), .1);
	playerDir = VectorNormalize(player.origin - self.spotlight.origin);
	dot = vectorDot(spotlightDir, playerDir);
	if(dot>heli_get_spotlight_dot(player) || ignoreFOV)
	{
		if(SightTracePassed(self.spotlight.origin, player GetEye(), false, self.spotlight))
		{
			return true;
		}
	}
	
	return false;
}


heli_get_spotlight_dot(player)
{
	dot = .99;	
	
	last_known_time = self heli_get_last_known_time(player, true);
	if(IsDefined(last_known_time) && last_known_time!=0)
	{
		shrinkDelay = 2000; //Delay before returning to default
		shrinkTime = 5000; //To to return to default dot
		delta = GetTime() - last_known_time;
		frac = clamp(1.0 - (delta-shrinkDelay)/shrinkTime, 0.0, 1.0);
		dot -= .1 * frac;
	}
	
	return dot;
}

heli_can_see_any_player(ignoreFOV)
{
	if(!IsDefined(ignoreFOV))
	{
		ignoreFOV = false;
	}
	
	foreach(player in level.players)
	{
		if(self heli_can_see(player, ignoreFOV))
		{
			return true;
		}
	}
	return false;
}

heli_get_spotlight_look_at_point()
{
	spotlightDir = AnglesToForward(self.spotlight GetTagAngles( "tag_flash" ));
	
	traceStart = self.spotlight.origin;
	traceEnd = traceStart + (spotlightDir*3000);
	trace = BulletTrace(traceStart, traceEnd, false);
	return trace["position"];
}

heli_fire_at_target_player()
{
	self endon("exit");
	self endon("death");
	self endon( "attack_heli_search" );
	
	wait 1;
	
	while(1)
	{
		//Only fire if play has been seen recently
		last_seen_time = 0;
		if(IsDefined(self.targetPlayer))
		{
			last_seen_time = self heli_get_last_seen_time(self.targetPlayer);
		}
		if(last_seen_time>0 && ((GetTime() - last_seen_time) < level.helicopter_time_to_lose_player))
		{
			burst = RandomIntRange(25,30);
			for(i=0;i<burst;i++)
			{
				self.turret ShootTurret();
				wait .1;
			}
			
			//Time between bursts
			wait RandomFloatRange(1,2);
		}
		else
		{
			wait .1;
		}

	}
}
heli_move_to_target_player()
{
	self endon("exit");
	self endon( "attack_heli_search" );
	self notify("newpath");
	
	self childthread heli_target_offset_angle_update();
	while(1)
	{
		if(self.health<=0)
		{
			return;
		}
		
		self SetLookAtEnt(self.heli_target);
		
		//dir  = self.origin - self.heli_target.origin;
		//dir  = VectorNormalize(dir);
		
		//Circle around the player
		dir = AnglesToForward(self.target_offset_angle);
		
		offset = (0,0,800) + (dir*800);
		self SetVehGoalPos(self.heli_target.origin + offset);
			
		wait 1;
	}
}

heli_target_attach_to_helicopter()
{
	self.heli_target LinkTo( self );
}

heli_target_offset_angle_update()
{
	self endon("death");
	self.target_offset_angle = (0,RandomFloatRange(0,360),0);
	waitTime = .1;
	while(1)
	{
		if(self.health<=0)
		{
			return;
		}
		self.target_offset_angle = (self.target_offset_angle[0], self.target_offset_angle[1] + (15*waitTime), self.target_offset_angle[2]);
		if(self.target_offset_angle[1]>=360)
		{
			self.target_offset_angle = (0,0,0);
		}
		wait waitTime;
	}
}

heli_target_player()
{
	self endon("death");
	self endon("exit");
	self endon( "attack_heli_search" );
	
	waitTime = .05;
	targetPlayer = undefined;
	targetPlayerStartTime = 0;
	targetOffPlayerStartTime = undefined;
	targetOnPlayerStartTime = undefined;
	targetOnPlayer = false;
	
	self thread heli_target_player_vo();
	while(1)
	{
		if(self.health<=0)
		{
			return;
		}
		if(!isDefined(targetPlayer) || is_player_down(targetPlayer))
		{
			//Find a valid player;
			targetPlayer = undefined;
			players = array_randomize(level.players);
			foreach(player in players)
			{
				if(!is_player_down(player))
				{
					targetPlayer = player;
					targetOnPlayer = undefined;
					targetPlayerStartTime = GetTime();
					break;
				}
			}
		}
		
		//Check if this player has been followed for awhile possible switch players
		if(isDefined(targetPlayer) && level.players.size>1 && targetPlayerStartTime+8000<GetTime())
		{
			players = array_randomize(level.players);
			foreach(player in players)
			{
				//Dont repick the same player
				if(player == targetPlayer)
				{
					continue;
				}
				
				if(!IsAlive(player))
				{
					continue;
				}
				
				dist = Distance(player player_get_heli_aim_pos(), self.heli_target.origin);
				if(dist<300)
				{
					targetOnPlayer = undefined;
					targetPlayer = player;
					targetPlayerStartTime = GetTime();
					break;
				}
			}
		}
		
		//
		if(isDefined(targetPlayer))
		{
			self notify("stop_circle");
			canSeeTargetPlayer = self heli_can_see(targetPlayer);

			//Init Drift
			if(!IsDefined(self.drift))
			{
				self.drift = (0,0,0);
				self.driftActive = false;
			}
			
			//Is spotlight on target
			onDesiredAimPos = false;
			if(IsDefined(self.desired_aim_pos))
			{
				distToAimPos = Distance2D(self.desired_aim_pos, self.heli_target.origin);
				if(distToAimPos<20.0)
				{
					onDesiredAimPos = true;
				}
			}
			
			//Update heli vision
			if(canSeeTargetPlayer)
			{
				heli_update_last_known(targetPlayer, true);
			}
			
			//Update drift
			targetLastKnownTime = self heli_get_last_known_time(targetPlayer, true);
			driftSet = false;
			if((onDesiredAimPos || self.driftActive) && !canSeeTargetPlayer)
			{
				lostTime = GetTime() - targetLastKnownTime;
				if(lostTime>1000)
				{
					if(onDesiredAimPos)
					{
						minDrift = 100;
						maxDrift = 1000;
						
						rangeScale = Clamp(lostTime/10000, 0, 1.0);	//drift further over time
						
						driftRange = minDrift + (maxDrift - minDrift) * rangeScale;
						self.drift  = AnglesToForward((0,RandomFloatRange(0,360),0)) * driftRange;
						self.driftActive = true;
					}
					driftSet = true;
				}
			}
			if(!driftSet)
			{
				self.drift = (0,0,0);
				self.driftActive = false;
			}
			
			//Update desired target, with aim offset and drift
			targetLastKnownPos = self heli_get_last_known_pos(targetPlayer, true);
			if(!isDefined(targetLastKnownPos))
			{
				targetLastKnownPos = self.heli_target.origin;
			}
			targetLastKnownAimPos = targetLastKnownPos + (0,0,50) + self.drift;
			
			
			//Is target on player
			playerDist = Distance2D(self.heli_target.origin, targetPlayer.origin);
			if(playerDist<30)
			{
				if(!isDefined(targetOnPlayer) || !targetOnPlayer)
				{
					targetOnPlayerStartTime = GetTime();
				}
				targetOnPlayer = true;
			}
			else
			{
				if(!isDefined(targetOnPlayer) || targetOnPlayer)
				{
					targetOffPlayerStartTime = GetTime();
				}
				targetOnPlayer = false;
			}
				
			//Is spotlight on desired origin
			dist = Distance(self.heli_target.origin, targetLastKnownAimPos);
			
			//Lag the spotlight
			lagDist = get_level_var( "heli_lag_distance" );
			dir = VectorNormalize(targetLastKnownAimPos - self.heli_target.origin);
			distScale = clamp( dist/lagDist, .4, 1.0);
			scale = distScale*distScale;
			
			//Draw current pos and desired pos
			//thread draw_line_for_time(targetLastKnownPos, targetLastKnownPos+(0,0,100), 0,1,0,waitTime);
			//thread draw_line_for_time(self.heli_target.origin + (0,0,-50), self.heli_target.origin+(0,0,100),1,0,0,waitTime);
			//Rough drawing of spot light fov
			//spotlight_height = self.spotlight GetTagOrigin( "tag_flash" )[2] - self.heli_target.origin[2];
			//spotlight_dot = self heli_get_spotlight_dot(targetplayer);
			//degrees = Acos(spotlight_dot);
			//radius = Sin(degrees)*spotlight_height;
			//draw_circle_until_notify(self.heli_target.origin-(0,0,50), radius, 1,0,0, self, "stop_circle");
			
			
			//Speed up light if not on the player for a while
			if(!targetOnPlayer && !self.driftActive)
			{
				lagTime = get_level_var_int( "heli_lag_time" );
				timeScale = GetTime() - targetOffPlayerStartTime - lagTime;
				if(timeScale > 0)
				{
					timeScale = clamp(timeScale/lagTime, 0,1);
					scale = Clamp(timeScale+scale,0,1);
				}
			}
			//Dont overshoot
			moveScale = min((scale*400.0*waitTime), dist);
			self.heli_target.origin = self.heli_target.origin + (moveScale*dir);
			
			//Record desired pos
			self.desired_aim_pos = targetLastKnownAimPos;
		}

		self.targetPlayer = targetPlayer;
		wait waitTime;
	}
	
}

heli_target_player_vo()
{
	self endon("death");
	self endon("exit");
	level endon("special_op_terminated");
	
	while(1)
	{
		while( !heli_can_see_any_player() )
		{
			wait .1;
		}
		self thread heli_destroy_objective();
		thread radio_dialogue_queue_single ( "so_milehigh_fso1_takeitout" );
		//level thread temp_dialogue("Radio", "Their chopper has you located. Take it out!", 5);
		wait 30;
	}
}
heli_get_last_known_pos(player,includeAI)
{
	return self heli_get_last_known(player,includeAI,true);
}

heli_get_last_known_time(player,includeAI)
{
	return self heli_get_last_known(player,includeAI,false);
}

heli_get_last_seen_time(player)
{
	return self.player_info[player.unique_id].last_seen_time;
}

heli_get_last_seen_time_any_player()
{
	last_seen_time = 0;
	
	foreach ( player in level.players )
	{
		time = self heli_get_last_seen_time( player );
		
		if ( time != 0 && (time < last_seen_time || last_seen_time == 0) )
		{
			last_seen_time = time;
		}
	}
	
	return last_seen_time;
}

heli_get_last_known_time_any_player(includeAI)
{
	last_known_time = 0;
	
	foreach( player in level.players )
	{
		time = self heli_get_last_known_time( player, includeAI );
		
		if ( time != 0 && (time < last_known_time || last_known_time == 0) )
		{
			last_known_time = time;
		}
	}
	
	return last_known_time;
}

heli_get_last_known(player,includeAI,returnPos)
{
	if(!IsDefined(player))
	{
		return undefined;
	}
	
	//Init with heli last known info
	time = self.player_info[player.unique_id].last_known_time;
	pos = self.player_info[player.unique_id].last_known_pos;
	
	//Check if any AI have seen the player more recently
	if(includeAI && flag("_stealth_spotted"))
	{
		aAi = getaiarray( "axis" );
		foreach (ai in aAi )
		{
			lastTime = ai LastKnownTime(player);
			if(lastTime>time)
			{
				time = lastTime;
				pos = ai LastKnownPos(player);
			}
		}
	}
	
	if(returnPos)
	{
		return pos;
	}
	else
	{
		return time;
	}
}
player_get_heli_aim_pos()
{
	return self.origin + (0,0,50);
}

setup_turret_so()
{
	
	self.turret = SpawnTurret( "misc_turret", self getTagOrigin( "tag_light_belly" ), "heli_minigun_so" );
	//self.turret = SpawnTurret( "misc_turret", self getTagOrigin( "tag_turret" ), "heli_minigun_so" );
	self.turret SetMode( "manual" );
	self.turret SetModel( "weapon_minigun" );
	self.turret LinkTo( self, "tag_turret" );
	self.turret MakeUnusable();
	//self.turret LaserForceOn();
}

setup_spotlight_so()
{
	self.spotlight = SpawnTurret( "misc_turret", self GetTagOrigin( "tag_turret" ), "heli_spotlight" );
	self.spotlight SetMode( "manual" );
	self.spotlight SetModel( "com_blackhawk_spotlight_on_mg_setup" );
	self.spotlight LinkTo( self, "tag_turret" );
	self.spotlight MakeUnusable();
	self.spotlight.broken = false;

	self.spotlight thread spot_light_so( "heli_spotlight", "tag_flash", self );
	//self.spotlight thread spotlight_show_target();
}

spotlight_show_target()
{
	while(1)
	{
		target = self GetTurretTarget(false);
		if(isDefined(target))
		{
			draw_line_for_time(target.origin, target.origin + (0,0,100), 1, 0, 0, 0.05);
		}
		wait 0.05;
	}
}

heli_turret_monitor_targets_so()
{
	self endon( "death" );
	self endon( "attack_heli_search" );
	
	self.turret SetTargetEntity(self.heli_target);
}

spot_light_so( fxname, tag_name, heli )
{
    struct = SpawnStruct();
    struct.effect_id = getfx( fxname );
    struct.entity = self;
    self.spot_light = struct;
    struct.tag_name = tag_name;
	
    self thread spot_light_delay_on( 3 );
	
	thread spot_light_death_so( heli );
	
	level waittill("stop_spotlight_fx");
	if ( isdefined(struct.entity) )
	{
		StopFXOnTag( struct.effect_id , struct.entity, struct.tag_name );
		wait(0.05);
		struct.effect_id_off = level._effect[ "spotlight_break" ];
		PlayFXOnTag( struct.effect_id_off , struct.entity, struct.tag_name );
	}
}

spot_light_delay_on(seconds)
{
	wait seconds;
	
	playFXOnTag( self.spot_light.effect_id , self.spot_light.entity, self.spot_light.tag_name );
}

heli_broken_light_fx()
{
	self endon("death");
	
	randomSparks = array("spotlight_spark01", "spotlight_spark02");
	while(1)
	{
		wait RandomFloatRange(.75,2.2);
		PlayFXOnTag(level._effect[ random(randomSparks) ], self, "tag_flash");
	}
}
spot_light_death_so( death_ent )
{
    self endon ( "death" );
    if (isdefined(death_ent))
    {
    	death_ent waittill ( "death" );
    }
    self Delete();
}

spotlight_random_targets_so()
{
	self endon( "death" );
	self endon("attack_heli_combat");
		
	self childthread update_spotlight_targets_so();
	self childthread watch_for_player_in_spotlight();
	

	self.spotlight SetTargetEntity( self.heli_target );
}
watch_for_player_in_spotlight()
{
	while(1)
	{
		foreach(player in level.players)
		{
			if(self heli_can_see(player) )
			{
				self heli_update_last_known(player, true);
			}
		}
		wait .05;
	}
}

spotlight_player_targets_so()
{
	self endon( "death" );
	self endon( "attack_heli_search" );
	
	self.spotlight SetTargetEntity( self.heli_target );
}

update_spotlight_targets_so()
{
	while(1)
	{
		waitTime = 0.05;
		scale = 0;
		rate = 0.3;
		while(1)
		{
			turretOrigin = self GetTagOrigin( "tag_turret" );
			fwdDir = AnglesToForward(self.angles);
			rightDir = AnglesToRight(self.angles);
		
			scale = scale + (waitTime*rate);
			if(scale>1.0)
			{
				scale = 1.0;
				rate *= -1;
			}
			
			if(scale<-1.0)
			{
				scale = -1.0;
				rate *= -1;
			}
			
			origin = turretOrigin + ((rightDir*30)*scale) + (fwdDir * 60) + (0,0,-100);
			origin = (origin[0], origin[1], level.player.origin[2]);
			self.heli_target.origin = origin;
			//thread draw_line_for_time(turretOrigin, origin, 1,0,0,waitTime);
			
			wait(waitTime);
		}
	}
}


//----------------------------------------------------------------
// Stealth
//----------------------------------------------------------------
stealth_settings()
{
	stealth_set_default_stealth_function( "woods", ::stealth_so_rescue_hijack );


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
	ai_event[ "ai_eventDistBullet" ][ "spotted" ]		 = 36;
	ai_event[ "ai_eventDistBullet" ][ "hidden" ] 		 = 36;
	
	ai_event[ "ai_eventDistFootstep" ] = [];
	ai_event[ "ai_eventDistFootstep" ][ "spotted" ]		 = 65; //was 50;
	ai_event[ "ai_eventDistFootstep" ][ "hidden" ] 		 = 65; //was 50;
		
	ai_event[ "ai_eventDistFootstepWalk" ] = [];
	ai_event[ "ai_eventDistFootstepWalk" ][ "spotted" ]	 = 65; //was 20, closest two characters can get is 30;
	ai_event[ "ai_eventDistFootstepWalk" ][ "hidden" ] 	 = 65; //was 20, closest two characters can get is 30;
	
	ai_event[ "ai_eventDistFootstepSprint" ] = [];
	ai_event[ "ai_eventDistFootstepSprint" ][ "spotted" ]	 = 200; // was 400, but doesn't work well in the blizzard
	ai_event[ "ai_eventDistFootstepSprint" ][ "hidden" ] 	 = 200; // was 400, but doesn't work well in the blizzard

	stealth_ai_event_dist_custom( ai_event );
	
	rangesHidden = [];
	rangesHidden[ "prone" ]		= 250;
	rangesHidden[ "crouch" ]	= 450;
	rangesHidden[ "stand" ]		= 500;

	rangesSpotted = [];
	rangesSpotted[ "prone" ]	= 500;
	rangesSpotted[ "crouch" ]	= 500;
	rangesSpotted[ "stand" ]	= 600;

	alert_duration = [];
	alert_duration[0] = 1.5;
	alert_duration[1] = 1.3;
	alert_duration[2] = 1.2;
	alert_duration[3] = 1.0;

	corpse_ranges = [];
	corpse_ranges[ "sight_dist" ]	 = 400;
	corpse_ranges[ "detect_dist" ]	 = 100;
	
	
	stealth_detect_ranges_set( rangesHidden, rangesSpotted );
	stealth_ai_event_dist_custom( ai_event );
	stealth_alert_level_duration( alert_duration[ level.gameskill ] );	
	stealth_corpse_ranges_custom( corpse_ranges );
}

hijack_enemy_state_hidden_fov()
{
	self.fovcosine = .8;
	self.fovcosinebusy = .5;
}

hijack_enemy_state_hidden()
{
	self hijack_enemy_state_hidden_fov();
	self.favoriteenemy = undefined;
	self.dontattackme = true;
	self.dontevershoot = true; 
	self thread set_battlechatter( false );

	if ( self.type == "dog" )
		return;

	self.dieQuietly = true;
	self clearenemy();
}

hijack_enemy_state_spotted( internal )
{
	maps\_stealth_behavior_enemy::enemy_state_spotted( internal );
}

stealth_so_rescue_hijack()
{
	self endon("death");
	level endon( "special_op_terminated" );
	spawn_failed( self );	//Need to make sure ai is finished spawning
	
	// since enemies in the helicopter are delayed being put completely in the stealth system, need to turn off their battlechatter now
	if ( isDefined(self.vehicle_position) )
	{
		self thread attach_flashlight_on_vehicle_unload();
		self thread set_battlechatter( false );
	}
		
	while(isDefined(self.vehicle_position))
	{
		wait .1;
	}
	
	state_array = [];
	state_array[ "hidden" ]	 	= ::hijack_enemy_state_hidden;
	state_array[ "spotted" ]	= ::hijack_enemy_state_spotted;
	
	self stealth_plugin_basic(state_array);

	if ( isplayer( self ) )
		return;
	
	if ( self.team != "axis" )
		return;

	self setup_enemy_behavior();

	// Standard Stealth Setup
	self.pathrandompercent = 0;
	self stealth_plugin_threat();
	self stealth_pre_spotted_function_custom( ::stealth_so_rescue_hijack_prespotted );

	threat_array[ "warning1" ] = maps\_stealth_threat_enemy::enemy_alert_level_warning2;
	threat_array[ "attack" ] = ::stealth_so_rescue_hijack_attack;//default
	self stealth_threat_behavior_custom( threat_array );

	self stealth_enable_seek_player_on_spotted();
	self stealth_plugin_corpse();
	self stealth_plugin_event_all();
}

stealth_so_rescue_hijack_attack()
{
	level endon( "special_op_terminated" );

	self.pathrandompercent = 200;
	self thread disable_cqbwalk();
	self thread maps\_stealth_shared_utilities::enemy_announce_spotted( self.origin );
	
	self.goalradius = 1000;

	self endon( "death" );

	self ent_flag_set( "_stealth_override_goalpos" );

	while ( isdefined( self.enemy ) && self ent_flag( "_stealth_enabled" ) )
	{
		self setgoalpos( self.enemy.origin );

		wait 4;
	}
	
	player_to_pursue = get_closest_player_healthy( self.origin );
	if ( isdefined( player_to_pursue ) )
		self setgoalpos( player_to_pursue.origin );
}

stealth_so_rescue_hijack_prespotted()
{
	level endon( "special_op_terminated" );
	self thread disable_shooting(1);	//Too often guys break through the stealth system and shoot with out delay
	wait( get_level_var("prespotted_wait") );
}







//----------------------------------------------------------------
// Enemy Behavior
//----------------------------------------------------------------
should_patrol()
{
	return isdefined( self.script_patroller );
}

should_calm_patrol()
{
	return isdefined( self.script_patroller ) && isdefined( self.script_noteworthy ) && ( self.script_noteworthy == "calm_patrol" );
}

should_cqb_patrol()
{
	return isdefined( self.script_patroller ) && isdefined( self.script_noteworthy ) && ( self.script_noteworthy == "cqb_patrol" );
}

setup_enemy_behavior()
{
	if(flag("heli_killed"))
	{
		attach_flashlight_on_gun();
		return;
	}
	
	// CQB Patrol Behavior
	if( self should_cqb_patrol() )
	{
		attach_flashlight_on_gun();
		wait .05;
		self clear_run_anim();
		self thread enable_cqbwalk();
		self.moveplaybackrate = RandomFloatRange(0.6, 1.0);	// TODO: reset this when combat starts
	}
	
	// Calm (bored) Patrol.  use this on AI who will do standard patrol anims (like phone / smoke)
	else if( self should_calm_patrol() )
	{
		attach_flashlight_on_gun();
		self.moveplaybackrate = RandomFloatRange(0.8, 1.0);	// TODO: reset this when combat starts
	}
	
	// Active Patrol Behavior (searching with flashlight)
	else if ( self should_patrol() )
	{
		self set_flash_light_walk();
		
		self thread maps\_patrol::patrol();
	}
	else
	{
		attach_flashlight_on_gun();
	}
}
clear_flashlight_walk_on_alert()
{
	self endon("death");
	self endon("flashlight_on_gun");
	
	if(IsDefined(self.dontRemoveFlashlightOnAlert) && self.dontRemoveFlashlightOnAlert)
		return;
	
	self waittill_any("death","damage", "event_awareness");
	
	self clear_flashlight_walk();
}
set_flash_light_walk()
{
	self attach_flashlight_in_hand();
	self thread clear_flashlight_walk_on_alert();
	
	self.patrol_no_stop_transition = true;
	self.patrol_walk_anim = "active_patrolwalk_v2";
	if ( IsDefined( self.script_animation ) )
		self.patrol_walk_anim = self.script_animation;

	self.patrol_anim_turn180 = "active_patrolwalk_turn";
	self.patrol_scriptedanim[ "pause" ][ 0 ] = "active_patrolwalk_pause";
	self.patrol_start[ "pause" ] = self.patrol_walk_anim; // TEMP??
}
clear_flashlight_walk()
{
	self.patrol_no_stop_transition = undefined;
	self.patrol_walk_anim = undefined;
	self.script_animation = undefined;
	self.patrol_walk_anim = undefined;
	self.patrol_anim_turn180 = undefined;
	if(IsDefined(self.patrol_scriptedanim) && IsDefined(self.patrol_scriptedanim[ "pause" ]))
		self.patrol_scriptedanim[ "pause" ][ 0 ] = undefined;
	if(IsDefined(self.patrol_start))
		self.patrol_start[ "pause" ] = undefined;
	
	attach_flashlight_on_gun();
}

node_disable_cqb()
{
	self waittill( "trigger", guy );
	

	guy disable_cqbwalk();
	guy set_flash_light_walk();
			
	guy thread maps\_patrol::patrol(self.targetname);
	
	guy gun_flashlight_off();
}

node_disable_flashligh_walk()
{
	self waittill( "trigger", guy);
	
	guy clear_flashlight_walk();
}



//----------------------------------------------------------------
// Flashlight
//----------------------------------------------------------------
attach_flashlight_on_gun()
{
	self hand_flashlight_remove();
	
	if(!IsDefined(self.gun_flashlight) || !self.gun_flashlight)
	{
		PlayFXOnTag( level._effect[ "flashlight" ], self, "tag_flash" );
		self.gun_flashlight = true;
		self notify("flashlight_on_gun");
	}
}

gun_flashlight_off()
{
	if ( IsDefined( self.gun_flashlight ) && self.gun_flashlight )
	{
		StopFXOnTag( level._effect[ "flashlight" ], self, "tag_flash" );
		self.gun_flashlight = false;
	}
}

attach_flashlight_in_hand()
{
	if(IsDefined(self.hand_flashlight))
	{
		return;
	}
	
	gun_flashlight_off();
	
	attach_tag = "TAG_INHAND";
	self.hand_flashlight = Spawn( "script_model", self.origin );
	flashlight = self.hand_flashlight;
	
	flashlight.owner = self;
	flashlight.origin = self GetTagOrigin( attach_tag );
	flashlight.angles = self GetTagAngles( attach_tag );
	flashlight SetModel( "com_flashlight_on" );
	flashlight LinkTo( self, attach_tag );
	flashlight thread hand_flashlight_watch_for_drop();
	
	self thread hand_flashlight_handle_alert();
	self thread hand_flashlight_handle_node_pause();
	self thread hand_flashlight_handle_effects();
	
	hand_flashlight_on();
}

hand_flashlight_watch_for_drop()
{
	self endon("death");
	while(1)
	{
		if( !IsDefined(self.owner) || self.owner.health<=0)
		{
			StopFXOnTag( getfx( "flashlight" ), self, "tag_light" );
			return;
		}
		wait .2;
	}
}
hand_flashlight_on()
{
	self.hand_flashlight SetModel( "com_flashlight_on" );
	PlayFXOnTag( getfx( "flashlight" ),self.hand_flashlight, "tag_light" );
}
hand_flashlight_off()
{
	self.hand_flashlight SetModel( "com_flashlight_off" );
	StopFXOnTag( getfx( "flashlight" ), self.hand_flashlight, "tag_light" );
}

hand_flashlight_remove()
{
	if(IsDefined(self.hand_flashlight))
	{
		self hand_flashlight_off();
		self.hand_flashlight Delete();			// get rid of model
		self notify( "stop_flashlight_thread" );
	}
}

hand_flashlight_should_hide( node )
{
	if ( !IsDefined( node ) )
	{
		return false;	// in the middle of patrolling still
	}
	if ( IsDefined( node.script_animation ) && node.script_animation != "pause" )
	{
		return true;	// doing a special anim (like phone or smoke)
	}
	if ( IsDefined( node.script_delay ) )
	{
		return true;	// just pausing
	}
	return false;
}

hand_flashlight_handle_alert()
{
	self endon( "death" );
	self endon( "stop_flashlight_thread" );

	self waittill_any( "death", "remove_flashlight", "enemy", "reached_path_end" );
	wait( 0.1 );
	if ( IsAlive( self ) )
	{	
		self thread attach_flashlight_on_gun();		
	}
}

hand_flashlight_handle_node_pause()
{
	self endon( "death" );
	self endon( "remove_flashlight" );
	self endon( "stop_flashlight_thread" );
	
	while ( 1 )
	{
		self waittill( "goal" );
		if (hand_flashlight_should_hide( self.last_patrol_goal ))
		{
			self notify( "flashlight_off" );
			self waittill( "release_node" );
			self notify( "flashlight_on" );
		}
	}
}

hand_flashlight_handle_effects()
{
	self endon( "death" );
	self endon( "remove_flashlight" );
	self endon( "stop_flashlight_thread" );
	
	while ( 1 )
	{
		// Turn Off
		self waittill( "flashlight_off" );
		hand_flashlight_off();

		// Turn On
		self waittill( "flashlight_on" );
		hand_flashlight_on();
	}
}

attach_flashlight_on_vehicle_unload()
{	
	// TODO: could probably be better since this notify happens for all guys at the same time
	self waittill( "jumping_out" );
	attach_flashlight_on_gun();
}





//----------------------------------------------------------------
// Music
//----------------------------------------------------------------
stealth_music_control()
{
	level endon( "special_op_terminated" );

	if( flag( "stop_stealth_music" ) )
		return;
	level endon ( "stop_stealth_music" );

	while( 1 )
	{
		stealth_music_hidden_loop();
	
		is_world_not_calm_wait();
	
		stealth_music_busted_loop();
	
		is_world_calm_wait();
	}
}


stealth_music_hidden_loop()
{
	//IPrintLnBold("Stealth Music");
	MUS_Stop( 2 );
	wait(2);
	MUS_play("hijk_mx_crash_aftermath");
}

stealth_music_busted_loop()
{
	//IPrintLnBold("Combat Music");
	level.player playsound("hijk_reveal_ground_combat");
	MUS_Stop( 2 );
	wait(3);
	MUS_play("hijk_tarmac_combat");
}

//----------------------------------------------------------------
// Human Shield
//----------------------------------------------------------------
init_human_shield()
{
	array_thread( getentarray( "human_shield", "targetname" ), ::add_spawn_function, ::AI_human_shield_think );
	thread human_shield();
}

disable_shooting(enableTime, waitForVisible)
{
	self endon("death");
	enable_dontevershoot();
	
	if(IsDefined(waitForVisible) && waitForVisible)
	{
		while(!self terrorist_can_see_any_player())
		{
			wait .05;
		}
	}
	
	wait enableTime;
	disable_dontevershoot();
}
human_shield()
{
	eTrig = getent( "player_approach_human_shield", "targetname" );
	eTrig waittill( "trigger", player );

	level.nodeShield = getstruct( "node_human_shield", "targetname" );
	level.hostage = spawn_script_noteworthy( "hostage_so_shield" );
	level.terrorist = spawn_script_noteworthy( "terrorist_so_shield" );
	array_spawn_function_targetname("so_last_group", ::no_grenades );
	array_spawn_function_targetname("so_last_group", ::terrorist_update_player_visible );
	array_spawn_function_targetname("so_last_group", ::disable_shooting, Get_level_var("alena_delay_shot_time"), true );
	array_spawn_targetname( "so_last_group" );
//	spawn_dogs( "so_nice_dog" );
	flag_set( "human_shield_actors_spawned" );
	
	level.hostage.so_no_mission_over_delete = true;
	level.hostage.no_friendly_fire_penalty = true;
	level.terrorist.so_no_mission_over_delete = true;
	level.terrorist thread terrorist_update_player_visible();
	
	thread human_shield_end();
	thread human_shield_fail_timer();
	
	//Send away attack heli
	if(IsDefined(level.attack_heli))
	{
		level.attack_heli thread attack_heli_exit();
	}

	if ( should_slowmo() )
	{
		while(1)
		{
			if(IsDefined(level.terrorist) && level.terrorist terrorist_can_see_all_players())
			{
				break;
			}
			wait .05;
		}
		
		flag_set("human_shield_slowmo");
		
		level thread fail_mission_on_leave_slowmo();
		
		if(!noSlowMo())
			setAllPlayersSlow();
		human_shield_begin_fx();
		level thread end_slowmo_on_mission_failed();

		slowmo_start();
			slowmo_setspeed_slow( .3 );
			slowmo_setlerptime_in( .05 );
			slowmo_lerp_in();
			flag_wait( "restore_timescale" );
			slowmo_setlerptime_out( .05 );
			slowmo_lerp_out();
		slowmo_end();
	}

	human_shield_end_fx();
	setAllPlayersNormal();
	
	level notify( "stop_player_heartbeat" );
}

fail_mission_on_leave_slowmo()
{
	level endon( "special_op_terminated" );
	
	trigger = GetEnt( "so_slowmo_backup_fail", "targetname" );
	trigger waittill( "trigger" );
	
	level.challenge_end_time = gettime();
	if(is_coop())
	{
		level notify( "so_quote", "coop_slowmo_fail", true );
	}
	else
	{
		level notify( "so_quote", "sp_slowmo_fail", true );
		
	}
	thread maps\_utility::missionFailedWrapper();	
}

end_slowmo_on_mission_failed()
{	
	flag_wait( "missionfailed" );
	flag_set( "restore_timescale" );
}

spawn_dogs(targetname)
{
	spawners = GetEntArray(targetname, "targetname");
	foreach( spawner in spawners )
	{
		dog = spawner spawn_ai( true );
		dog.health = 1;
		dog thread dog_ignore_all();
	}
}
dog_ignore_all()
{
	self.ignoreall = true;
	wait get_level_var("alena_dog_delay");
	self.ignoreall = false;
}

should_slowmo()
{
	return true;//!is_coop();
	// slowmo when: no coop, coop without the dvar set, coop with the dvar set and a player is downed
	//return !is_coop() || 
	//	GetDvar( "rescue_no_coop_slowmo" ) == "0" || 
	//	( GetDvar( "rescue_no_coop_slowmo" ) == "1" && ( is_player_down(level.players[0]) || is_player_down(level.players[1]) ) );
}

human_shield_end()
{
	level endon( "special_op_terminated" );
	
	flag_wait_either( "terrorist_killed", "terrorist_wounded" );
	
	// once the terrorist is shot you can only fail if you die
	if(!AlenaEscape())
		level.hostage magic_bullet_shield();
	level notify( "stop_human_shield_fail_timer" );	

	while( get_num_guys_alive() > 0 )
	{
		wait(0.1);
	}
	
	self.allowdeath = false;
	
	objective_complete(1);
	
	wait( 0.8 );
	flag_set( "restore_timescale" );
	
	wait( 0.1 );
	flag_set( "so_rescue_hijack_success" );	// this is what actually ends the mission
}

terrorist_update_player_visible()
{
	self endon("death");
	
	self.player_visible_times = [];
	foreach(player in level.players)
	{
		s =SpawnStruct();
		s.visible = false;
		s.visible_start = 0;
		
		self.player_sight_time[player.unique_id] = s;
	}
	
	while(1)
	{
		/#
		dvar_value = getDebugDvarInt( "terrorist_debug_player_visible" );
		if(dvar_value>0)
		{
			self thread terrorist_debug_player_visible();
		}
		#/
			
		foreach(player in level.players)
		{
			info = self.player_sight_time[player.unique_id];
			if(self terrorist_sight_trace(player))
			{
				if(!info.visible)
				{
					info.visible = true;
					info.visible_start = GetTime();
				}
			}
			else
			{
				info.visible = false;
			}
		}
		wait .1;
	}
}

terrorist_sight_trace(player)
{
	start = self GetEye();
	end = player GetEye();
	
	return SightTracePassed(start, end, false, self, player);
}

/#
terrorist_debug_player_visible()
{
	if(IsDefined(level.terrorist_debug_player_visible))
	{
		return;
	}
	level.terrorist_debug_player_visible = true;
	
	self endon("death");
	
	while(1)
	{
		zOffset = 72;
		playerIndex = 1;
		foreach(player in level.players)
		{
			text = string(playerIndex) + ") Not Visible";
			color = (1,0,0); //Red
			info = self.player_sight_time[player.unique_id];
			if(info.visible)
			{
				text = string(playerIndex) + ") Visible: " + (GetTime() - info.visible_start);
				color = (0,1,0);
			}
			print3d( self.origin+(0,0,zOffset), string(text),color, 1, 1 );	// origin, text, RGB, alpha, scale
			zOffset-=12;
		}
		
		wait .05;
	}
}
#/

terrorist_can_see_player(player, time)
{
	if(!IsDefined(time))
	{
		time =0;
	}
	
	info = self.player_sight_time[player.unique_id];
	return info.visible && ((GetTime() - info.visible_start) >= time);
}
terrorist_can_see_all_players(time)
{
	foreach(player in level.players)
	{
		if(!self terrorist_can_see_player(player, time))
		{
			return false;
		}
	}
	
	return true;
}

terrorist_can_see_any_player(time)
{
	foreach(player in level.players)
	{
		if(self terrorist_can_see_player(player, time))
		{
			return true;
		}
	}
	
	return false;
}


human_shield_fail_timer()
{
	level endon( "stop_human_shield_fail_timer" );
	level endon( "special_op_terminated" );
	
	level thread human_shield_trigger_fail();
	level human_shield_fail_timer_wait();
	
	flag_set( "restore_timescale" );
	
	if(!IsDefined(level.terrorist))
	{
		return;
	}
	
	level.terrorist endon("death");
	min_player_visible_time = get_level_var_int("alena_min_vis_time");
	while(1)
	{
		foreach(player in level.players)
		{
			if(IsAlive(player) && level.terrorist terrorist_can_see_player(player, min_player_visible_time))
			{
				level.terrorist Shoot();
				if ( is_coop() )
				{
					other_player = get_other_player( player );
					if ( !IsAlive( other_player ) )
					{
						level notify( "so_quote", "killed_by_terrorist", true );
					}
				}
				else
				{
					level notify( "so_quote", "killed_by_terrorist", true );
				}
				wait .1;
				player kill_wrapper();
				wait .5;
			}
		}
		
		wait .1;
	}
}

human_shield_fail_timer_wait()
{
	level endon( "trigger_terrorist_shooting" );
	
	while(IsDefined(level.terrorist) && !level.terrorist terrorist_can_see_any_player())
	{
		wait .05;
	}
	
	if(is_coop())
	{
		waittill_flag_or_timeout("human_shield_slowmo", get_level_var("alena_pre_slowmo"));
	}
	
	wait get_level_var("alena_save_time");
}

waittill_flag_or_timeout( flag, timer )
{
	if(flag( flag ))
	{
		return;
	}
	
	level endon(flag);
	wait( timer );
}

human_shield_trigger_fail()
{
	level endon( "special_op_terminated" );
	
	if(alenaEscape())
		return;
	
	// get too close and he'll just shoot anyway
	trigger = GetEnt( "so_too_close_kill", "targetname" );
	trigger waittill( "trigger", player );
	
	level notify( "trigger_terrorist_shooting" );
}

human_shield_begin_fx()
{
	delaythread( 1, ::player_hearbeat );
}

human_shield_end_fx()
{
}

setAllPlayersSlow()
{
	for ( i = 0;i < level.players.size;i++ )
		level.players[ i ] SetMoveSpeedScale( .2 );
}
setAllPlayersNormal()
{
	for ( i = 0;i < level.players.size;i++ )
		level.players[ i ] SetMoveSpeedScale( 1.0 );
}

kill_ai()
{
	aAi = getaiarray( "axis" );
	for ( i = 0;i < aAi.size;i++ )
		aAi[ i ] kill();
}

get_num_guys_alive()
{
	num_guys_alive = 0;
	guys = getaiarray( "axis" );
	foreach( guy in guys )
	{
		if ( IsAlive( guy ) && IsDefined( guy.script_noteworthy ) )
		{
			if ( guy.script_noteworthy == "terrorist_so_stand" || guy.script_noteworthy == "terrorist_so_crouch" || guy.script_noteworthy == "terrorist_so_shield" )
			{
				num_guys_alive ++;
			}
		}
	}	
	return num_guys_alive;
}

player_hearbeat()
{
	level endon( "stop_player_heartbeat" );
	while ( true )
	{
		//level.player thread play_sound_on_entity( "breathing_heartbeat_slowmo" );
		level.player thread play_sound_on_entity( "breathing_heartbeat" );
		wait .5;
	}
}


AI_human_shield_think()
{
	self endon( "death" );

	/*-----------------------
	SETUP AI
	-------------------------*/	
	self.ignoreme = true;
	self.script_grenades = 0;
	self.grenadeAmmo = 0;
	self setFlashbangImmunity( true );
	
	flag_wait( "human_shield_actors_spawned" );

	self setgoalpos( self.origin );

	ePartner = undefined;
	switch( self.script_noteworthy )
	{
		case "terrorist_so_crouch":
			self.a.pose = "crouch";
			self AllowedStances( "crouch" );
			break;

		case "terrorist_so_shield":
			self.allowdeath = false;
			self.animname = "terrorist";
			ePartner = level.hostage;
			
			if(alenaEscape())
			{
				self thread delayThread(0.05, ::terrorist_wounded );
			}
			else
			{
				self thread human_shield_terrorist_pain_monitor();
			}

			break;
			
		case "hostage_so_shield":

			self.noragdoll = 1; // goes into ragdoll too early so just skip it
			self.allowdeath = false;
			self.disablearrivals = true;
			self.disableexits = true;
			self.team = "neutral";
			self.animname = "hostage";
			self.ignoreall = true;
			ePartner = level.terrorist;
			
			self thread human_shield_death_monitor();
			self thread human_shield_hostage_pain_monitor();
			self gun_remove();
			break;

	}

	/*-----------------------
	PLAY IDLE
	-------------------------*/		
	self setgoalpos( self.origin );
	if (IsDefined(ePartner))
	{
//		playbackRate = 1.0;
//		if(noSlowMo())
//			playbackRate = 0.25;
//		level.nodeShield thread anim_loop_solo( self, "human_shield_idle", "stop_idle", undefined, playbackRate);
		if(noSlowMo() && !alenaEscape())
		{
			level.nodeShield thread anim_loop_solo( self, "human_shield_idle_slow", "stop_idle");
		}
		else
		{
			level.nodeShield thread anim_loop_solo( self, "human_shield_idle", "stop_idle");
		}
	}
}

hostage_human_shield_play_death_anim()
{
	level.nodeShield notify("stop_idle");
	level.nodeShield thread anim_single_solo(level.terrorist, "human_shield_breakfree_partner_dead");
	
	flag_set( "restore_timescale" );
	level.hostage notify("scripted_death");
	level.nodeShield anim_single_solo(level.hostage, "human_shield_death");
	
	level.hostage.noragdoll = false;
	level.hostage.a.nodeath = true;
	level.hostage.deathanim = undefined;
	level.hostage.no_ai = true;
	level.hostage.allowdeath = true;
	level.hostage.ignoreall = true;
	level.hostage.ignoreme = true;
	level.hostage.diequietly = true;
	
	level.hostage InvisibleNotSolid();
	
	level.hostage Kill();
}

terrorist_human_shield_play_death_anim(attacker, cause, weaponName)
{
	level.nodeShield notify("stop_idle");
	if(IsDefined(attacker) && IsPlayer(attacker))
		attacker maps\_player_stats::register_kill( level.terrorist, cause, weaponName );
	
	level.terrorist thread terrorist_drop_weapon();
	
	level.nodeShield anim_single_solo(level.terrorist, "human_shield_death");
	
	level.terrorist.a.nodeath = true;
	level.terrorist.deathanim = undefined;
	level.terrorist.no_ai = true;
	level.terrorist.allowdeath = true;
	level.terrorist.ignoreall = true;
	level.terrorist.ignoreme = true;
	level.terrorist.diequietly = true;
	level.terrorist.allowdeath = true;
	
	level.terrorist InvisibleNotSolid();
	
	level.terrorist Kill();
}

terrorist_drop_weapon()
{
	level endon( "special_op_terminated" );
	self endon("death");
	
	wait 0.7;
	
	self thread animscripts\shared::DropAllAIWeapons();
}


headshot_fx()
{
	angles = level.player.angles;
	forward = anglestoforward( angles );
	vec = ( forward * 5000 );
	start = level.player geteye();
	end = start + vec;
	trace = bullettrace( start, end, false, undefined );

	playfx( getfx( "flesh_hit" ), trace[ "position" ], ( 0, 0, 1 ) );
	playfx( getfx( "headshot1" ), trace[ "position" ], ( 0, 0, 1 ) );
	playfx( getfx( "headshot1" ), trace[ "position" ], ( -25, 10, -10 ) );
	playfx( getfx( "headshot2" ), trace[ "position" ], ( 0, 0, 1 ) );
	playfx( getfx( "headshot3" ), trace[ "position" ], ( 0, 0, 1 ) );
	thread play_sound_in_space( "bullet_large_flesh", level.player.origin );
}

human_shield_death_monitor()
{
	level endon( "special_op_terminated" );
	
	if(!alenaEscape())
		level endon( "stop_human_shield_fail_timer" );
	self waittill_any( "death", "scripted_death" );
	if ( self == level.hostage )
	{
		level.challenge_end_time = gettime();
		maps\_specialops::so_force_deadquote( "@SO_RESCUE_HIJACK_KILLED_ALENA" );
		thread maps\_utility::missionFailedWrapper();
	}
}

human_shield_hostage_pain_monitor()
{
	level.hostage endon( "death" );

	while ( isdefined( self ) )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, idFlags );

		/*-----------------------
		IGNORE FLASHBANG DAMAGE
		-------------------------*/			
		if ( ( isdefined( type ) ) && ( type == "MOD_IMPACT" ) )
			continue;

		/*-----------------------
		HOSTAGE HIT (KILLED)
		-------------------------*/	
		if((!IsDefined(level.hostage.magic_bullet_shield) || level.hostage.magic_bullet_shield == 0 ) )
		{
			if ( ( isdefined( attacker ) ) && ( isplayer( attacker ) ) )
			{
				if(alenaEscape())
				{
					self.allowdeath = true;
					self Kill(point, attacker);
				}
				else
				{
					thread hostage_human_shield_play_death_anim();
				}
				break;

			}
		}
	}
}

human_shield_terrorist_pain_monitor()
{
	level endon( "special_op_terminated" );
	level.hostage endon( "damage" );

	while ( isdefined( self ) )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, idFlags );

		/*-----------------------
		IGNORE FLASHBANG DAMAGE
		-------------------------*/			
		if ( ( isdefined( type ) ) && ( type == "MOD_IMPACT" )  )
			continue;

		/*-----------------------
		TERRORIST HEADSHOT
		-------------------------*/	
		if ( ( isdefined( partName ) ) && ( partName == "j_head" ))
		{
			flag_set( "terrorist_killed" );
			level.playerGotHeadshot = true;
			attacker.playerGotHeadshot = true;
			level.nodeShield notify( "stop_idle" );
			self thread headshot_fx();	
			thread terrorist_human_shield_play_death_anim(attacker,type);
			thread alena_breakfree(true);
			break;
		}
		/*-----------------------
		TERRORIST WOUNDED
		-------------------------*/	
		else if ( !flag( "terrorist_wounded" ) )
		{
			self thread terrorist_wounded();
			break;
		}
	}
}

terrorist_wounded()
{
	//play pain anim if terrorist
	flag_set( "terrorist_wounded" );

	self.allowdeath = true;
	self.deathanim = undefined;
	level.nodeShield notify( "stop_idle" );
	level.nodeShield thread anim_single_solo( self, "human_shield_pain" );
	thread alena_breakfree(false);
}

alena_breakfree(terrorist_dead)
{
	//level endon( "special_op_terminated" );
	level.hostage endon("death");
	
	// this function needs to end after this anim, so thread the looping one
	if ( terrorist_dead )
	{
		level.nodeShield anim_single_solo( level.hostage, "human_shield_breakfree_partner_dead" );
		level.nodeShield thread anim_loop_solo( level.hostage, "human_shield_loop_partner_dead" );
	}
	else
	{
		level.nodeShield anim_single_solo( level.hostage, "human_shield_breakfree_partner_wounded" );
		level.nodeShield thread anim_loop_solo( level.hostage, "human_shield_loop_partner_wounded" );
	}
}


mission_failed_veteran_no_headshot()
{
	level notify( "mission failed" );
	level notify( "kill_timer" );
	// The hostage was killed. True veterans get headshots...not flesh wounds.
	setDvar( "ui_deadquote", &"AIRPLANE_HOSTAGE_NO_HEADSHOT" );
	maps\_utility::missionFailedWrapper();
}

//--------------------------------
//Hostage
//--------------------------------
spawn_first_hostage()
{
	flag = "so_first_hostage_ready";
	flag_init(flag);
	trigger = GetEnt("so_second_guys_trigger", "targetname");
	trigger thread trigger_set_first_hostage_flag(flag);
	spawn_hostage("so_first_hostage", "so_first_executor", false, flag);
}
trigger_set_first_hostage_flag(flag)
{
	self waittill("trigger");
	flag_set(flag);
	if(level.hostage_death_count==0)
	{
		thread radio_dialogue_queue_single ( "so_milehigh_fso1_executing" );
		//thread temp_dialogue("Radio", "They are executing our men. Engage at your discretion. Securing Alena is our top priority.", 6);
	}
}

spawn_second_hostage()
{
	trigger = GetEnt("so_second_hostage_trigger","targetname");
	trigger waittill("trigger");
	spawn_hostage("so_second_hostage", "so_second_executor", false);
}

spawn_third_hostage()
{
	trigger = GetEnt("so_fifth_group_trigger","targetname");
	trigger waittill("trigger");
	spawn_hostage("so_third_hostage", "so_third_executor", true);
}

spawn_hostage(hostagename, executorname, right, wait_flag)
{
	//Spawn
	///////
	spawner_hostage = getent( hostagename, "targetname" );
	spawner_executor = getent( executorname, "targetname" );
	
	if(!IsDefined(spawner_hostage) || !IsDefined(spawner_executor))
	{
		return;
	}
	
	//
	hostage = spawner_hostage spawn_ai(true);
	hostage hostage_init();

	executor = spawner_executor spawn_ai(true);
	executor executor_init();
	
	anim_node = getstruct(executorname + "_node", "targetname");
	
	s = SpawnStruct();
	s.hostage = hostage;
	s.executor = executor;
	s.kneel_flag = wait_flag;
	s.dropping_to_knees = false;
	s.kneeling = false;
	s.alerted = false;
	s.kill_started = false;
	s.right = right;	//Direction the hostage runs when freed
	s.hostage_anim_node = hostage;
	s.executor_anim_node = executor;
	
	executor.hostage_execution_struct = s; //Need a way to get this in a notetrack call back
	hostage.hostage_execution_struct = s;
	
	//Kill the hostage if the player is not stealth
	if(!is_world_calm()||flag("heli_killed"))
	{
		s finish_hostage_execution();
		return;
	}
	
	s thread hostage_execution_alert();
	s thread hostage_executor_killed();
	s thread hostage_executor_damage();
	s thread run_hostage_execution();
}

hostage_init()
{
	self.ignoreme	= true;
	self.ignoreall	= true;
	self.drawoncompass = false;
	self.animName	= "hostage";
	self thread hostage_death_watch();
}

executor_init()
{
	self.ignoreme	= true;
	//self.ignoreall	= true;
	self.allowdeath = true;
	self.animname	= "executor";
	self hijack_enemy_state_hidden_fov();
	self thread set_battlechatter( false );
	//self.combatmode = "no_cover";
	self  attach_flashlight_on_gun();
}
hostage_death_watch()
{
	if(!IsDefined(level.hostage_death_count))
	{
		level.hostage_death_count = 0;
	}
	self waittill("death");
	level.hostage_death_count++;
}

hostage_execution_alert()
{
	self endon("hostage_shot");
	self.executor endon("death");
	self.hostage endon("death");
	
	self hostage_execution_alert_wait();

	self.alerted = true;
	self notify("executor_alert");
	
	self thread finish_hostage_execution();
}

hostage_execution_alert_wait()
{
	self.executor endon( "bulletwhizby" );
	self.executor endon( "gunshot_teammate" );
	self.executor endon( "event_awareness" );
	self.executor endon( "corpse_found" );
	self.executor endon( "enemy" );
	
	level flag_wait("_stealth_spotted");
}


executor_watch_for_corpse()
{
	self endon("death");
	self endon("executor_alert");
	
	while(1)
	{
		corpseArray = stealth_collect_corpse_override();
		for ( i = 0; i < corpseArray.size; i++ )
		{
			corpse = corpseArray[ i ];
			
			if(Distance2D(corpse.origin, self.origin)<200.0)
			{
				self notify("corpse_found");
				return;
			}
		}
		
		wait .1;
	}
}

hostage_executor_damage()
{
	self endon("hostage_shot");
	self.executor endon("death");
	
	self.executor waittill("damage", amount, who, normal, loc );
	
	//On easy only require one shot to kill the executor
	if(level.gameskill<=1)
	{
		self.executor StopAnimScripted();
		self.executor DoDamage(self.executor.health+100, self.executor.origin, who);
	}
}

hostage_executor_killed()
{
	self.hostage endon("death");
	self endon("hostage_shot");
	
	self.executor waittill("death");
	
	self notify("executor_killed");
	
	//Let the hostage finish dropping to knees anim
	if(self.dropping_to_knees && !self.kill_started)
	{
		self waittill("hostage_on_knees");
	}
	else
	{
		self notify("stop_knee");
	}
	
	base_anim = "so_hijack_execution_" + ter_op(self.kneeling,"kneel","stand") + "_freed_"+ter_op(self.right,"r","l");
	reaction_anim = base_anim+"_start";
	wait_anim = base_anim+"_loop";
	saved_anim = base_anim+"_end";
	
	self.hostage_anim_node notify("stop_loop");
	
	//Allow player to use hostage to save
	self.hostage MakeUsable();
	self.hostage SetHintString(&"SO_RESCUE_HIJACK_SAVE_HOSTAGE");
	
	//React to executor death and idle
	self hostage_react_to_executor_death(reaction_anim, wait_anim);
	
	//Stand up and run away on saved
	self.hostage_anim_node notify("stop_loop");
	self.hostage_anim_node thread anim_single_solo(self.hostage, saved_anim );
	
	self notify("hostage_saved");
	self.hostage MakeUnusable();
	level.num_hostages_rescued++;
	level notify( "so_hostage_saved" );
	//level thread temp_dialogue("Radio", "Hostage Saved");
	thanks_vo = array( "so_ste_hijack_thankyou", "so_ste_hijack_cantthank", "so_ste_hijack_savedmylife", "so_ste_hijack_justintime" );
	self.hostage thread dialogue_queue( random(thanks_vo) );
	
	//Play civilian panic anims
	//One of the default civ idles is holding a gun. Hack to prevent that.
	level.scr_anim[ "default_civilian" ]["idle_noncombat"] 	= array( %unarmed_cowercrouch_idle_duck );
	level.scr_anim[ "default_civilian" ]["idle_combat"] 	= array( %unarmed_cowercrouch_idle_duck );
	self.hostage.animname = "default_civilian";
	
	//Find exit
	exit = GetStruct("hostage_run_to","targetname");
	self.hostage SetGoalPos(exit.origin);
	self.hostage.goalradius = 128;
	
	//Wait to reach goal
	self.hostage waittill("goal");
	
	self.hostage thread delete_when_not_visible(1500);
}

hostage_react_to_executor_death(reaction_anim, wait_anim)
{
	self.hostage endon("death");
	self.hostage endon("trigger"); //Player clicked on player to save them
	
	//Play reaction anim
	self.hostage_anim_node anim_single_solo(self.hostage, reaction_anim );

	//play idle waiting for player to save
	self.hostage_anim_node anim_loop_solo(self.hostage, wait_anim );
}

delete_when_not_visible(min_dist)
{
	self endon("death");
	
	lastVisibleTime = GetTime();
	while(1)
	{
		wait .1;
		
		if(self is_in_any_players_radius(min_dist))
		{
			lastVisibleTime = GetTime();
			continue;
		}
		
		if(self is_in_any_players_fov())
		{
			lastVisibleTime = GetTime();
			continue;
		}
		
		if(lastVisibleTime+1000<GetTime())
		{
			self Delete();
		}
	}
}

is_in_any_players_radius(dist)
{
	dist_sqr = dist*dist;
	foreach(player in level.players)
	{
		distSquared = DistanceSquared(player.origin, self.origin);
		if(distSquared<dist_sqr)
		{
			return true;
		}
	}
	return false;
}

is_in_any_players_fov()
{
	foreach(player in level.players)
	{
		playerDir = AnglesToForward(player.angles);
		dirToSelf = self.origin - player.origin;
		if(VectorDot(playerDir,dirToSelf)>0)
		{
			return true;
		}
	}
	return false;
}


run_hostage_execution()
{
	self endon("executor_alert");
	self endon("executor_killed");
	level endon( "special_op_terminated" );
	
	//Stage 1 - Play standing anims
	////////////////////////////////
	self.executor_anim_node thread anim_loop_solo(self.executor, "so_hijack_execution_standing_idle");
	self.hostage_anim_node thread anim_loop_solo(self.hostage, "so_hijack_execution_standing_idle");
	
	//Stage 1 wait
	wait 1.0;
	if(IsDefined(self.kneel_flag))
		flag_wait(self.kneel_flag);
	
	//Stage 2 - Drop To Knees
	///////////////////////////////////
	alt = RandomInt(2);
	self thread hostage_drop_to_knees(alt);
	self thread executor_order_drop_to_knees(alt);
	
	self waittill("hostage_on_knees");
	
	//Wait to give the player a chance to save hostage
	stage2wait = get_level_var( "hostage_save_time" );
	wait stage2wait;
	
	//Stage 4 - Execute hostage
	///////////////////////////
	self finish_hostage_execution();
}

finish_hostage_execution()
{
	
	self.kill_started = true;
	self thread hostage_play_death_anim();
	
	animName = "so_hijack_execution_stand_alert_kill";
	if(self.kneeling)
	{
		if(self.alerted)
		{
			animName = "so_hijack_execution_kneel_alert_kill";
		}
		else
		{
			animName = "so_hijack_execution_kneel_calm_kill";
		}
	}

	animTime = GetAnimLength(self.executor GetAnim(animName));
	self.executor thread disable_stealth_events(animTime); //Disable stealth events so we dont alert our own team
	
	self.executor_anim_node notify("stop_loop");
	self.executor_anim_node anim_single_solo(self.executor, animName);

	if(IsAlive(self.executor))
	{
		self.executor thread executor_return_to_patrol();
	}
}

hostage_play_death_anim()
{
	self endon("executor_killed");
	self endon("special_op_terminated");
	
	animName = "so_hijack_execution_stand_alert_kill";
	if(self.kneeling)
	{
		if(self.alerted)
		{
			animName = "so_hijack_execution_kneel_alert_kill";
		}
		else
		{
			animName = random(array("so_hijack_execution_kneel_calm_kill","so_hijack_execution_kneel_calm_kill2"));
		}
	}
	
	self.hostage_anim_node notify("stop_loop");
	self.hostage_anim_node anim_single_solo(self.hostage, animName);
	
	self.hostage.noragdoll = 1;
	self.hostage.a.nodeath = true;
	self.hostage.deathanim = undefined;
	self.hostage.no_ai = true;
	
	self.hostage Kill();
}

executor_kill_hostage_notetrack(guy)
{
	s = guy.hostage_execution_struct;
	
	s notify("hostage_shot");
}

hostage_drop_to_knees(use_alt_anim)
{
	self endon("stop_knee");
	self.hostage endon("death");
	self.hostage_anim_node notify("stop_loop");
	self.dropping_to_knees = true;
	self.hostage_anim_node anim_single_solo(self.hostage, ter_op(use_alt_anim, "so_hijack_execution_to_knees", "so_hijack_execution_to_knees2"));
	self.dropping_to_knees = false;
	self.kneeling = true;
	self notify("hostage_on_knees");
	self.hostage_anim_node thread anim_loop_solo(self.hostage, "so_hijack_execution_kneeling_idle");
}

executor_order_drop_to_knees(use_alt_anim)
{
	self.executor endon("death");
	self.executor_anim_node notify("stop_loop");
	self.executor_anim_node anim_single_solo(self.executor, ter_op(use_alt_anim, "so_hijack_execution_to_knees", "so_hijack_execution_to_knees2"));
	self.executor_anim_node thread anim_loop_solo(self.executor, "so_hijack_execution_kneeling_idle");
}

executor_return_to_patrol()
{
	self.ignoreme	= false;
	self.ignoreall	= false;
	self.script_patroller = 1;
	self.script_stealth = 1;
	self thread stealth_so_rescue_hijack();
	
	self thread maps\_patrol::patrol();
}

disable_stealth_events(enableTime)
{
	self notify("disable_stealth_events");
	self endon("disable_stealth_events");
	ai_living = GetAIArray( "axis" );
	foreach ( ai in ai_living )
	{
		ai RemoveAIEventListener( "bulletwhizby" );
		ai RemoveAIEventListener( "gunshot_teammate" );
	}
	
	// Slight delay for shooting to finish
	self wait_for_notify_or_timeout("death", enableTime);
	
	foreach ( ai in ai_living )
	{
		if(IsDefined(ai))
		{
			ai AddAIEventListener( "bulletwhizby" );
			ai AddAIEventListener( "gunshot_teammate" );
		}
	}
}

noSlowMo()
{
	return IsDefined(level.no_slowmo) && level.no_slowmo;
}

alenaEscape()
{
	return noSlowMo() && IsDefined(level.alena_escape) && level.alena_escape;
}

////////////
//Debug Code
////////////
/#
debug_player_visible()
{
	debugHud = undefined;
	while(1)
	{
		dvar_value = getDebugDvarInt( "debug_player_visible" );
		if(dvar_value == 0)
		{
			if(IsDefined(debugHud))
			{
				debugHud Destroy();
			}
			wait .25;
			continue;
		}
		
		if(!IsDefined(debugHud))
		{
			debugHud = NewHudElem();
			debugHud.x = 100;
			debugHud.y = 100;
			debugHud.fontScale = 2;
			debugHud.alignX = "left";
			debugHud.alignY = "top";
			debugHud.horzAlign = "fullscreen";
			debugHud.vertAlign = "fullscreen";
		}
		
		playerEye = level.player GetEye();
		if(SightTracePassed(playerEye + (0,0,1000), playerEye, false, level.attack_heli))
		{
			debugHud SetText("Player Visible");
		}
		else
		{
			debugHud SetText("Player Not Visible");
		}
		
		wait .1;
	}
}

show_ai_health()
{
	while(1)
	{
		dvar_value = getDebugDvarInt( "show_ai_health" );
		if(dvar_value == 0)
		{
			level notify("stop_ai_show_health");
			wait .25;
			continue;
		}
		
		player = level.players[0];
		ai_array = GetAIArray( "axis" );

		for(i=0;i<ai_array.size;i++)
		{
			ai = ai_array[i];
			
			ai thread ai_record_damage_history();
			
			text = "" + ai.health + "/" + ai.maxhealth;
			
			right = anglestoright(player.angles);
			right = -1 * right * ((text.size / 2) * 8); //Roughly center text
			up = (0,0,70);
			
			color = (0,1,0); //Green
			historySize = ai.damageHistory.size;
			if(historySize>0 && ai.damageHistory[historySize-1].time+1000>GetTime())
			{
				color = (1,0,0); //red
			}

			print3d( ai.origin+right+up, text, color, 1, .75 );
			
			//Print damage history
			k=0;
			for(j=ai.damageHistory.size-1; j>=0 && k<dvar_value-1; j--)
			{
				up = up + (0,0,-10);
				print3d( ai.origin+right+up, ai.damageHistory[j].text, color, 1, .75 );
				k++;
			}
		
			
		}
		wait( 0.05 );
	}
}

ai_record_damage_history()
{
	level endon("stop_ai_show_health");
	self endon("death");
	
	if(IsDefined(self.record_damage_time_active) && self.record_damage_time_active)
	{
		return;
	}
	
	self.damageHistory = [];
	self.record_damage_time_active = true;
	while(1)
	{
		self waittill("damage", damage, attacker, direction, point, type );
		
		s 			= spawnStruct();
		s.time 		= GetTime();
		s.damage 	= damage;
		s.attacker	= attacker;
		s.type		= type;
		if(IsDefined(self.damageLocation))
		{
			s.loc		= self.damageLocation;
			s.text		= "-" + damage + " " + self.damageLocation + " " + type;
		}
		s.text		= "-" + damage + " " + type;
		
		self.damageHistory[self.damageHistory.size] = s;
	}
}

show_stealth_events()
{
	while(1)
	{
		dvar_value = getDebugDvarInt( "show_stealth_events" );
		if(dvar_value == 0)
		{
			level notify("stop_show_stealth_events");
			wait .25;
			continue;
		}
		
		player = level.players[0];
		ai_array = GetAIArray( "axis" );
		for(i=0;i<ai_array.size;i++)
		{
			ai = ai_array[i];
			
			ai thread ai_record_stealth_events();
			
			up = (0,0,70);
			color = (1,0,0); //red
			
			//Print damage history
			if(dvar_value==1)
			{
				k=0;
				for(j=0;j<ai.stealthEventHistory.size && k<5; j++)
				{
					text = ai.stealthEventHistory[j].text;
					
					up = up + (0,0,-10);
					print3d( ai.origin+up,text, color, 1, .75 );
					k++;
				}
			}
			
			if(dvar_value==2)
			{
				ai thread ai_draw_fov_cone(player, 0.05);
			}
			
			
		}
		wait( 0.05 );
	}
}

//Draws fov code
ai_draw_fov_cone(player, time)
{
	dot = self.fovcosine;
	if(isDefined(self.enemy))	//this does not exectly match what native code does
	{
		dot = self.fovcosinebusy;
	}
	
	fov_yaw = ACos(dot);
	eye_yaw = self gettagangles( "TAG_EYE" )[ 1 ];
	
	leftDir = AnglesToForward((0,eye_yaw+fov_yaw,0));
	rightDir = AnglesToForward((0,eye_yaw-fov_yaw,0));
	
	viewDist = player.maxvisibledist;
	start = self.origin;
	left_end = start + leftDir*viewDist;
	right_end = start + rightDir*viewDist;
	
	thread draw_line_for_time(start,left_end,1,0,0,time);
	thread draw_line_for_time(start,right_end,1,0,0,time);
	
	//FOV Arc
	arc_segs = 10;
	arcpoints = [];
	angleFrac = (fov_yaw*2.0)/arc_segs;
	for ( j = 1; j < arc_segs-1; j++ )
	{
		angle = eye_yaw-fov_yaw + ( angleFrac * j );
		dir = AnglesToForward((0,angle,0));
		arcpoints[ arcpoints.size ] = (dir*viewDist) + start;
	}
	arcpoints[ arcpoints.size ] = left_end;
	
	arc_seg_start = right_end;
	arc_seg_end = undefined;
	for(j=0;j<arcpoints.size;j++)
	{
		arc_seg_end = arcpoints[j];
		thread draw_line_for_time(arc_seg_start,arc_seg_end,1,0,0,time);
		arc_seg_start = arc_seg_end;
	}	
}

ai_record_event(type)
{
	s 			= spawnStruct();
	s.time 		= GetTime();
	s.type		= type;
	s.text		= string(s.time) + ": " + type;
		
	self.stealthEventHistory[self.stealthEventHistory.size] = s;
}

ai_record_stealth_events()
{
	level endon("stop_show_stealth_events");
	self endon("death");
	
	if(IsDefined(self.record_stealth_events_active) && self.record_stealth_events_active)
	{
		return;
	}
	
	self.stealthEventHistory = [];
	self.record_stealth_events_active = true;
	
	self childthread ai_record_event_awareness();
	while(1)
	{
		msg = self waittill_any_return( "enemy" );
		
		ai_record_event(msg);
	}
}

ai_record_event_awareness()
{
	while(1)
	{
		self waittill("event_awareness", type );
		ai_record_event(type);
	}
}
#/
