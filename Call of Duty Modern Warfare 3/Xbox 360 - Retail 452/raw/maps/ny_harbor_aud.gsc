#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_audio;
#include maps\_audio_zone_manager;
#include maps\_audio_mix_manager;
#include maps\_audio_reverb;
#include maps\_audio_music;
#include maps\_audio_vehicles;
#include maps\_audio_stream_manager;
#include maps\_audio_dynamic_ambi;

MIN_ZODIAC_SPEED	= 0;
MAX_ZODIAC_SPEED	= 55;
MAX_VFX_MIGS		= 3;
			
main()
{
	/********************************************************************
		Init Audio System.
	********************************************************************/
	aud_set_level_fade_time(0.25);
	aud_init();

	/********************************************************************
		Config Audio System.
	********************************************************************/
	set_stringtable_mapname("shg");
	aud_set_occlusion("med_occlusion"); // new way to do it, which uses string tables
	aud_set_timescale("shg_default");
	
	/********************************************************************
		Init Level Globals.
	********************************************************************/
 	if (!IsDefined(level.aud))
	{
		level.aud = SpawnStruct();
	}
	
	//Flags
	flag_init("aud_player_tunnel_spline");
	flag_init("aud_flag_player_underwater"); 
	flag_init("player_above_water");
	flag_init("aud_building_exploded");
	flag_init("aud_building_02_exploded"); 
	flag_init("aud_flag_scubamask_on_player");
	flag_init("aud_flag_inside_sub");
	flag_init("leaving_sub");
	flag_init("aud_end_ship_sink");
	flag_init("aud_engine_stop_monitor"); 
	flag_init("aud_engine_fade_out");
	flag_init("aud_planting_submine");
	//Sparks for intro sequence.
	flag_init("scn_gate_cut_spark_01"); 
	flag_init("aud_first_spark_played");   
	flag_init("aud_second_spark"); 
	flag_init("aud_third_spark"); 
	//Sinking Battleship
	flag_init("aud_sink_impact_done");
	flag_init("aud_kill_ship_residuals");
	//Sub top line emitters
	flag_init("stop_line_emitters");
	//Sub Door Breach
	flag_init("aud_door_slowmo_exit");
	//Zodiac Chase
	flag_init("aud_big_ship_missile_explo");
	//Boat Slowmo
	flag_init("aud_boat_slowmo_outro");
	//Zodiac Jump
	flag_init("player_zodiac_jump_ramp");
	flag_init("player_zodiac_jump_hitwater");
	//Extraction
	flag_init("aud_player_zodiac_in_chinook");
	
	// Gloabals
	level.aud.sub_stress_chance = 80;
	level.aud.next_zodiac_splash_time = 0;
	level.aud.zodiac_splash_rate_min = 250;
	level.aud.zodiac_splash_rate_max = 700;
	
	/********************************************************************
		Level Initialization.
	********************************************************************/
	aud_launch_threads();
	aud_launch_loops();
	aud_create_level_envelop_arrays();
	aud_register_trigger_callbacks();
	aud_add_note_track_data();
	aud_precache_presets();
	MM_add_submix("nyhb_level_global_mix");
	
	/********************************************************************
		Register Level Audio Message Handler Function.
		NOTE:	Should be last thing done in level init function.
	********************************************************************/
	aud_register_msg_handler(::audio_msg_handler);
	aud_register_msg_handler(::music_msg_handler);
}

aud_precache_presets()
{
	MM_precache_preset("nyhb_level_global_mix");
	MM_precache_preset("nyhb_underwater");
	MM_precache_preset("nyhb_battleship_sink");
	MM_precache_preset("nyhb_russian_sub_by");
	MM_precache_preset("nyhb_surface_breach_se");
	MM_precache_preset("nyhb_surface_battle");
	MM_precache_preset("nyhb_sub_interior");
	MM_precache_preset("sub_player_weapon");
	MM_precache_preset("sub_entry");
	MM_precache_preset("pre_bridge_breach");
	MM_precache_preset("sub_door_breach");
	MM_precache_preset("nyhb_sub_control_room");
	MM_precache_preset("nyhb_pre_board_zodiac");
	MM_precache_preset("nyhb_zodiac_escape");
	MM_precache_preset("nyhb_boat_slowmo");
	MM_precache_preset("nyhb_theres_our_bird");
	MM_precache_preset("nyhb_zodiac_jump");
	MM_precache_preset("nyhb_chinook_interior_flight");
	MM_precache_preset("nyhb_finale");
	MM_precache_preset("nyhb_finale_amb_fade");
	MM_precache_preset("nyhb_final_flyby");
}


aud_launch_loops()
{
	thread aud_ignore_slowmo();
	aud_steam_emitters();
	aud_machinery_emitters();
	aud_sub_computers();
	aud_electric_breakerboxes();
	aud_controlroom_lights();
	aud_steamy_vents();
	aud_controlroom_radios();
	aud_floodroom_water();
	aud_sub_waterfalls();
	aud_flooded_waterfalls();
	thread aud_control_room_alarms();
	aud_velocity_emitters();
	aud_fires();
	aud_uw_bubbles();
}

aud_launch_threads()
{
	//thread aud_scuba_breaths();
	thread aud_harbor_surface_water_sfx();
	thread aud_russian_sub_start();
	thread aud_player_on_zodiac();
	thread aud_zodiac_jump();
	
	// TESTING:
	//thread aud_monitor_zodiac_speed();
}

// TESTING:

//aud_monitor_zodiac_speed()
//{
//	while (1)
//	{
//		if (IsDefined(level.escape_zodiac))
//		{
//			speed = level.escape_zodiac Vehicle_GetSpeed();
//			IPrintLn("zodiac speed: " + speed);
//		}
//		wait(0.5);
//	}
//}

aud_create_level_envelop_arrays()
{
	level.aud.envs["aud_nyhb_tunnel_zone_env"]	=
		[
			[0.0, 0.0], 
			[0.2, 0.05],
			[0.5, 0.2], 
			[0.7, 0.3],
			[1.0, 1.0] 
		];

		aud_add_progress_map("aud_nyhb_tunnel_zone_env", level.aud.envs["aud_nyhb_tunnel_zone_env"]);
		
		level.aud.envs["aud_battleship_sink"]	= 	
		[	
			[0.000,	1.000],
			[0.200,	1.000],
			[0.400,	0.800],
			[0.600,	0.600],
			[0.800,	0.400],
			[1.000,	0.000]
		]; 
		
		level.aud.envs["zodiac_speed_to_ambi_vol"]	=
		[
			[0.0, 1.0], 
			[1.0, 0.0] 
		];
}

aud_register_trigger_callbacks()
{
	//callbacks = [
		//["aud_nyhb_tunnel_progress", ::aud_nyhb_tunnel_progress_exponential]];
	
			//trigger_multiple_audio_register_callback(callbacks);
}

aud_add_note_track_data()
{
	//Opening Sequence
	anim.notetracks[ "aud_start_missilekeytoss" ] = ::aud_start_missilekeytoss;
}


audio_msg_handler(msg, args)
{
	msg_handled = true;
	
	switch(msg)
	{
		/*************************************************/
		/***** E3 Demo Hack HANDLERS (to be removed) *****/
		/*************************************************/
		
		case "e3_demo_fade_out": 
		{
			fade_time = args;
			assert(IsDefined(fade_time));
			MM_add_submix("mute_all", fade_time);
		}
		break;
		
		case "e3_demo_fade_in": 
		{
			fade_time = args;
			assert(IsDefined(fade_time));
			level.aud.e3 = fade_time;
		}
		break;
				
		/*******************************/
		/***** CHECKPOINT HANDLERS *****/
		/*******************************/
		case "start_rendezvous_with_seals":
		{
			thread aud_gate_cut_start();
			flag_set("aud_flag_player_underwater");
			flag_set("aud_flag_scubamask_on_player");
			level.player_sdv Vehicle_TurnEngineOff();
			thread aud_player_sdv_intro();
			AZM_start_zone("nyhb_pretunnel_tube");
		}
		break;

		case "start_plant_mine_on_sub":
		{
			flag_set("aud_flag_player_underwater");
			flag_set("aud_flag_scubamask_on_player");
			level.player_sdv Vehicle_TurnEngineOff();
			thread aud_player_sdv_pause();
			AZM_start_zone("nyhb_underwater_pre_sub");
		}
		break;
		
		case "start_capture_sub":
		{
			AZM_start_zone("nyhb_surface_battle");
			aud_play_city_combat_ambi();
			music_cue("mus_sub_breach_checkpoint");
			MM_add_submix("sub_player_weapon");
			aud_start_subtop_line_emitters();
		}
		break;

		case "start_bridge_breach":
		{
			AZM_start_zone("nyhb_sub_interior_missileroom2");
			thread aud_scuttle_alarms_start();
			flag_set("aud_flag_inside_sub");
			level.aud.sub_stress_chance = 40;
			MM_add_submix("sub_player_weapon");
			
			// cleanly remove the mute_all *after* the checkpoint has been setup properly
			if (IsDefined(level.aud.e3))
			{
				music_cue("mus_e3_demo_fade_in");
				fade_in = level.aud.e3;
				MM_clear_submix("mute_all", fade_in);
			}
			else
			{
				music_cue("mus_sub_scuttle_announcement", 0);
			}
		}
		break;
			
		case "start_escape_on_zodiacs":
		{
			AZM_start_zone("nyhb_surface_battle");
			aud_play_city_combat_ambi();
			music_cue("mus_sandman_copies_all");
			MM_add_submix("nyhb_pre_board_zodiac");
		}
		break;
		
		case "start_exit_flight":
		{
			AZM_start_zone("nyhb_surface_battle");
			music_cue("mus_finale");
		}
		break;
		
		/***********************************/
		/***** AWESOME TRIGGER HANDLERS ****/
		/***********************************/
		
		//Blend Trigger: nyhb_pretunnel_tube nyhb_underwater_subway_tunnel
		
		case "enter_nyhb_underwater_subway_tunnel":
		{
			zone_from = args;
		}
		break;
		
		case "exit_nyhb_underwater_subway_tunnel":
		{

		}
		break;

		//Blend Trigger:	nyhb_surface_battle nyhb_sub_interior_engineroom
		
		case "enter_nyhb_sub_interior_engineroom":
		{
			zone_from = args;
			thread aud_siren_first();
		}
		break;
		
		case "exit_nyhb_sub_interior_engineroom":
		{
			zone_to = args;
			if (zone_to == "nyhb_sub_interior_engineroom")
			{
				flag_set("aud_flag_inside_sub");
				level notify("aud_notify_inside_sub");
				level.aud.sub_stress_chance = 80;
				aud_stop_city_combat_ambi();
			}
			else
			{
				flag_clear("aud_flag_inside_sub");
				aud_play_city_combat_ambi();
			}
		}
		break;
		
		//Blend Trigger: nyhb_sub_interior_engineroom nyhb_sub_interior_barracks
		
		case "enter_nyhb_sub_interior_barracks":
		{
			zone_from = args;
			level.aud.sub_stress_chance = 80;
		}
		break;
		
		case "exit_nyhb_sub_interior_barracks":
		{
			zone_to = args;
			level.aud.sub_stress_chance = 80;
		}
		break;
		
		//Blend Trigger: nyhb_sub_interior_barracks nyhb_sub_interior_flooded
		
		case "enter_nyhb_sub_interior_flooded":
		{
			zone_from = args;
			level.aud.sub_stress_chance = 80;
		}
		break;
		
		case "exit_nyhb_sub_interior_flooded":
		{
			zone_to = args;
			if (zone_to == "nyhb_sub_interior_flooded")
			{
				music_cue("mus_sub_interior_flooded");
			}
			level.aud.sub_stress_chance = 80;
		}
		break;
		
		//Blend Trigger: nyhb_sub_interior_flooded nyhb_sub_interior_pre_missileroom
		
		case "enter_nyhb_sub_interior_pre_missileroom":
		{
			zone_from = args;
		}
		break;
		
		case "exit_nyhb_sub_interior_pre_missileroom":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: nyhb_sub_interior_pre_missileroom nyhb_sub_interior_missileroom1
		
		case "enter_nyhb_sub_interior_missileroom1":
		{
			zone_from = args;
			if (zone_from == "nyhb_sub_interior_pre_missileroom")
			{
				thread aud_reactor_computers();
			}	
		}
		break;
		
		case "exit_nyhb_sub_interior_missileroom1":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: nyhb_sub_interior_missileroom1 nyhb_sub_interior_missileroom2
		
		case "enter_nyhb_sub_interior_missileroom2":
		{
			zone_from = args;
		}
		break;
		
		case "exit_nyhb_sub_interior_missileroom2":
		{
			zone_to = args;
		}
		break;
		
		
		//Blend Trigger: nyhb_sub_interior_missileroom2 nyhb_sub_interior_controlroom
		
		case "enter_nyhb_sub_interior_controlroom":
		{
			zone_from = args;
			if (zone_from == "nyhb_sub_interior_missileroom2")
			{
				level.aud.sub_stress_chance = 20;
			}
			else
			{
				level.aud.sub_stress_chance = 40;
			}
		}
		break;
		
		case "exit_nyhb_sub_interior_controlroom":
		{
			zone_to = args;
			if (zone_to == "nyhb_sub_interior_controlroom")
			{
				level.aud.sub_stress_chance = 20;
			}
			else
			{
				level.aud.sub_stress_chance = 40;
			}
		}
		break;
		
		//Blend Trigger: nyhb_sub_interior_controlroom nyhb_surface_battle
		
		case "enter_nyhb_surface_battle":
		{
			zone_from = args;
			if (zone_from == "nyhb_sub_interior_controlroom")
			{ 
				if(IsDefined(level.aud.exit_control_room_to_zodiac))  //Prevents from happening before the player is allowed to fully exit (after the SE)
				{
					flag_set ("leaving_sub");
					flag_clear("aud_flag_inside_sub");
					MM_add_submix("nyhb_pre_board_zodiac");
					thread aud_start_subtop_line_emitters();
					aud_play_city_combat_ambi();
					level.aud.sub_stress_chance = 0;
				}
			}
			else
			{
				// Seems like we should make this work, but causing problems now because player can walk "near" the entry back to sub.
				//flag_set("aud_flag_inside_sub");
				//level notify("aud_notify_inside_sub");
			}
		}
		break;
		
		case "exit_nyhb_surface_battle":
		{
			zone_to = args;
			if (zone_to == "nyhb_sub_interior_controlroom")
			{
				if(IsDefined(level.aud.exit_control_room_to_zodiac))  //Prevents from happening before the player is allowed to fully exit (after the SE)
				{
					aud_stop_city_combat_ambi();
					level.aud.sub_stress_chance = 20;
					flag_set("aud_flag_inside_sub");
					flag_set("stop_line_emitters");
					level notify("aud_notify_inside_sub");
				}
			}
		}
		break;
		
		//Blend Trigger: nyhb_zodiac_ride nyhb_surface_pier
		
		case "enter_nyhb_surface_pier":
		{
			zone_from = args;
			if (zone_from == "nyhb_zodiac_ride")
			{
				aud_set_filter("harb_zodiac_pier"); 
			}
		}
		break;
		
		case "exit_nyhb_surface_pier":
		{
			zone_to = args;
			if (zone_to == "nyhb_zodiac_ride")
			{
				aud_clear_filter();
			}
		}
		break;
		
		//Blend Trigger: nyhb_surface_pier nyhb_zodiac_ride
		
		case "enter_nyhb_zodiac_ride":
		{
			zone_from = args;
			if (zone_from == "nyhb_surface_pier")
			{
				aud_clear_filter();
			}
		}
		break;

		case "exit_nyhb_zodiac_ride":
		{
			zone_to = args;
			if (zone_to == "nyhb_surface_pier")
			{
				aud_set_filter("harb_zodiac_pier");
			}
		}
		break;
		
		//Blend Trigger: nyhb_underwater_subway_tunnel nyhb_underwater_open

		case "enter_nyhb_underwater_open":
		{
			zone_from = args;
		}
		break;
		
		case "exit_nyhb_underwater_open":
		{
			zone_to = args;
		}
		break;
		
		/**************************/
		/***** EVENT HANDLERS *****/
		/**************************/

		/***** SDV RIDE** *********/

		case "player_tunnel_spline":
		{
			music_msg_handler("mus_intro");
		}
		break;
		
		case "building_missile_explosion_01":
		{
			aud_building_explode();
		}
		break;  
		
		
		case "land_explosion":  // These are the boats getting hit (orange fire/black smoke).
		{
			explo_origin = args;
			thread play_sound_in_space("harb_explo_dist", explo_origin); 
			thread play_sound_in_space("nymn_explosion_mortar_distant", explo_origin);
		}
		break;  
		
		case "harbor_missile_03":
		{
			inc_ent = spawn("script_origin", level.player.origin);
			tail_ent = spawn("script_origin", level.player.origin);
			inc_ent playsound("harb_surface_missile_incoming_ext_02");
			wait(0.5);
			inc_ent ScaleVolume(0.0, 0.5);	
			level.player playsound("harb_single_missile_overhead"); 
			level.player playsound("harb_single_missile_overhead_lo"); 

			tail_ent playsound("harb_overhead_missiles_tail");
			wait(0.05);
			tail_ent ScaleVolume(1.0, 0.05);
			flag_wait("aud_building_02_exploded");
			tail_ent ScaleVolume(0.0, 0.3);
			wait(0.75);
		
			tail_ent delete();
			inc_ent delete();
		}
		break; 
	
		case "building_missile_explosion_02":
		{
			aud_building_explode_02();
		}
		break; 
		
		case "sdv_scuba_bubbles":
		{
			thread aud_sdv_scuba_bubbles();
		}
		break;
		
		case "player_scuba_bubbles":
		{
			thread aud_player_scuba_bubbles();

		}
		break;
		
		case "torch_screen_flash":
		{
			aud_torch_flash();
		}
		break;

		case "sinking_ship_debris_splash":
		{
			wait(1.25);
			level.player playsound("harb_battleship_sink_uw_splash");
			wait(0.6);
			level.player playsound("harb_battleship_sink_uw_splash");
		}
		break;
	
		case "ship_sink_flash_explosion":
		{
			explo_pos = args;
			thread MM_add_submix("nyhb_battleship_sink");
			thread play_sound_in_space("harb_battleship_sink_explosion_01", level.player.origin);
			thread aud_debris_splashes_underwater();
		}
		break;
	
		case "underwater_battleship_sink":
		{
			aud_data = args;
			
			thread aud_battleship_sink(aud_data);
			wait(4);
			level.player playsound("harb_battleship_stress");
			wait(4);
			// Sneak back to high-passed ambi here so it's disguised by sinking ship.  Makes room for russian sub low-end.
			AZM_start_zone("nyhb_underwater_pre_sub"); 
			wait(4);
			aud_russian_sub_single_ping();
			wait(3);
			aud_russian_sub_single_ping();
		}
		break;
		
		case "torpedo_1":
		{
			torpedo_1 = args;
			
			wait(0.9);
			
			if(IsDefined(torpedo_1))
			{
				aud_play_linked_sound("oscar_torpedoes_st", torpedo_1);
				//aud_play_linked_sound("torpedo_by_lo", torpedo_1);				
			}
		}
		break;
		
		case "torpedo_2":
		{
			torpedo_2 = args;
		}
		break;
		
		case "sonar_ping_hud":
		{
			thread aud_play_mine_beep();
		}
		break;
		
		case "aud_mine_explosion":
		{
			origin = args;
			play_sound_in_space("mine_explo", origin);
		}
		break;
		
		case "sonar_ping":
		{
			aud_minewarn(args);
		}
		break;
	
		case "sub_approach":
		{
			flag_set("aud_kill_ship_residuals");
		}
		break;
		
		case "aud_link_engine_entities_to_scripted_node":
		{
			scriptednode = args;
			assert(IsDefined(level.aud.cone_sound));
			assert(IsDefined(level.aud.omni_sound));
			level.aud.cone_sound LinkTo(scriptednode, "tag_origin");
			level.aud.omni_sound LinkTo(scriptednode, "tag_origin");
		}
		break;
				
		case "aud_limpet_mine_anim":
		{
			aud_player_sdv_off(1.0);

			level.player playsound("shg_sdv_plr_shutdown");
			level.player playsound("harb_se_plantmine_01");

			wait(2.0);

			flag_set("aud_engine_stop_monitor");
		}
		break;
		
		case "submine_planted":
		{
			//iprintlnbold("submine_planted");
		}
		break;

		case "sub_breach_started":	// THIS IS ACTUALLY WHEN THE SUB BOMB IS PLANTED/ARMED.
		{
			//iprintlnbold("AUDIO:  SUB BREACH STARTED");
			thread aud_player_sub_surface_breach();
			thread aud_sub_destroy();
		}
		break;
				
		case "submine_detonated":
		{
			aud_prime_city_combat_ambi();
		}
		break;
		
		case "sub_breach_finished":
		{
		}
		break;

		case "player_surfaces":	// This is the exact moment the player goes from underwater to above water.
		{
			music_cue("mus_drone_E");
			thread aud_overhead_missiles();
			flag_clear("aud_flag_player_underwater");
			AZM_start_zone("nyhb_surface_battle");
			aud_play_primed_city_combat_ambi();
			MM_add_submix("sub_player_weapon");
			
			flag_wait("aud_building_exploded");
			music_cue("mus_fist_building_explodes");
			wait(0.5);
			level.player playsound("sub_surface_breach_lead_in");
		}
		break;
		
		case "slava_missile_launch":
		{
			if (!flag("player_on_boat"))
			{
				aud_slava_missile_launch(args[0]);
			}
		}
		break;
		
		case "slava_missile_explode":
		{
			if (!flag("player_on_boat"))
			{
				explo_origin = args[0];
				thread play_sound_in_space("nymn_explosion_mortar_distant", explo_origin);
			}
		}
		break;

		case "scubamask_off_player":
		{
			flag_clear("aud_flag_scubamask_on_player");
			level.player playsound ("harb_sub_takemaskoff");
			//Fade in close proximity waves sounds.
			thread aud_start_subtop_line_emitters();
		}
		break;
		
		case "get_onto_sub":
		{
		
		}
		break;
		
		case "aud_prime_player_downladder":
		{
			level.player aud_prime_stream("harb_se_player_downladder");
		}
		break;
		
		case "aud_player_downladder":
		{
			level.player aud_release_stream("harb_se_player_downladder");
			level.player playsound("harb_se_player_downladder");
			wait(2);
			MM_add_submix("sub_entry", 2);							// Add sub_entry submix.
			thread aud_barracks_sandman_opening_door();	// Clear sub_entry submix.
			wait(1);
			flag_set("stop_line_emitters");
		}
		break;
		
		case "sub_splashes":
		{
		
		}
		break;
		
		case "big_splash":
		{

			
		}
		break;
		
		case "aud_prime_sandman_grenade_anim":
		{
			assert(!isdefined(level.aud.sandman_sound));
			level.aud.sandman_sound = spawn("script_origin", level.sandman.origin);
			level.aud.sandman_sound aud_prime_stream("harb_se_grenadethrow_foley");
		}
		break;
		
		case "aud_start_sandman_grenade_anim":
		{
			wait (.9);
			assert(IsDefined(level.aud.sandman_sound));
			is_primed = level.aud.sandman_sound aud_is_stream_primed("harb_se_grenadethrow_foley");
			assert(is_primed);
			level.aud.sandman_sound aud_release_stream("harb_se_grenadethrow_foley");
			level.aud.sandman_sound.origin = level.sandman.origin;
			level.aud.sandman_sound linkto(level.sandman, "tag_origin");
			//iprintlnbold("grenade_throw");
			level.aud.sandman_sound playsound("harb_se_grenadethrow_foley", "sounddone");
			thread delete_on_sounddone(level.aud.sandman_sound);
			wait (4.2);
			//iprintlnbold("explode");
			thread play_sound_in_space("harb_sub_grenade_metalres", (-39500, -23857, 10));
			thread play_sound_in_space("grenade_explode_metal", (-39500, -23857, 21));
			thread play_sound_in_space("grenade_explode_layer", (-39500, -23857, 20)); 
		}
		break;
		
		case "aud_sub_sandman_pairedkill_headsmash":
		{
			//wait(2.9);
			//level.sandman playsound("harb_se_pairedkill_oneshot");
		}
		break;
		
		case "hind_player_killer":
		{
			if(!IsDefined(args))
				return;
	
			aud_play_linked_sound("hind_player_killer_inc", args);				
			aud_play_linked_sound("hind_player_killer_lp", args, "loop", "aud_player_killer_kill_lp");	
		}
		break;
		
		/***** Inside Sub *********/
		
		case "if_the_sub_is_a_rocking_dont_come_a_knocking":
		{
			if (flag("aud_flag_inside_sub"))
			{
				if (aud_percent_chance(level.aud.sub_stress_chance))
				{
					aud_play_linked_sound("harb_sub_stress", level.player);
				}
			}
		}
		break;
		
		case "aud_open_bulkhead_door":
		{
			level notify("aud_bulkhead_door_open");
		}
		break;
		
		case "aud_fire_extinguisher_spray":
		{
			extinguisher = args;
		  extinguisher playsound("fire_extinguisher_spray");
		}
		break;
		
		case "aud_scuttle_alarms_start":
		{
			thread aud_scuttle_alarms_start();
			level.aud.sub_stress_chance = 40;
			
			wait(30);
			aud_do_sub_scuttle_bombshake();
		}
		break;

		case "bridge_breach":
		{
			level.sandman aud_prime_stream("harb_se_take_keys");
			music_cue("mus_sub_door_breach");
		}
		break;
		
		case"aud_control_room_pipe_burst":
		{
			thread play_loopsound_in_space("sub_emt_waterfall_pipe",(-36285,-24116,-230));//cr pipe burst
			thread play_loopsound_in_space("sub_emt_waterfall_splatter_large",(-36287,-24102,-417));//cr pipe burst
			level.player playsound("harb_exp_pipe_burst_01");
		}
		break;
		
		case"aud_flooded_room_pipe_burst":
		{
			level.player playsound("harb_exp_pipe_burst_01");
		}
		break;
		
		case "aud_premissileroom_pipeburst":
		{
			thread play_sound_in_space("sub_exp_premissileroom_pipeburst",(-37773,-23808,-418));
			thread play_sound_in_space("harb_emt_pipe_burst_premr",(-37773,-23808,-418));
		}
		break;
		
		case"aud_missile_room_pipe_burst":
		{
			level.player playsound("harb_exp_pipe_burst_02");
		}
		break;
		
		case "bridge_breach_setup":
		{
			music_cue("mus_bridge_breach_setup");
		}
		break;
		
		case "player_trigger_sub_door_breach":
		{
			thread mm_add_submix("pre_bridge_breach", 6);
		}
		break;
		
		
		case "door_breach_slowmo_start":
		{
			thread aud_door_breach_slomo();
			level.player playsound("db_sub_drop_slo_01");
			level.player playsound("db_impact_hit_01");
		}
		break;
		
		
		case"door_breach_slowmo_end":
		{
			aud_player_exit_slomo();
		}
		break;
		

		case "aud_prime_sandman_takes_key":
		{
			level.aud.harb_take_keys = spawn("script_origin", (-35670,-23983,-240));
			level.aud.harb_take_keys aud_prime_stream("harb_se_take_keys");
		}
		break;
		
		case "aud_start_sandman_takes_key":
		{
			assert(IsDefined(level.aud.harb_take_keys));
			level.aud.harb_take_keys playsound("harb_se_take_keys", "sounddone");
			level.aud.harb_take_keys waittill("sounddone");
			wait(0.05);
			level.aud.harb_take_keys delete();
		}
		break;
		
		case "aud_prime_missilekeytoss":
		{
			//level.player aud_prime_stream("harb_se_missilekeytoss");
		}
		break;
	
		
		case "aud_zodiac_slide_se":
		{
			//iprintlnbold("zodiac_slide");
			level.player playsound("harb_se_board_zodiac_locked");
		}
		break;

		/***** Zodiac Escape ******/
		
		case "begin_zodiac_ride":
		{
			MM_clear_submix("nyhb_pre_board_zodiac");
			MM_clear_submix("sub_player_weapon");
			AZM_start_zone("nyhb_zodiac_ride");
			music_cue("mus_zodiac_ride");			
			// set the whizby presets to be narrower to cut down on whizby events
			level.player SetWhizbyRadii(16, 32, 10000);
			level.player SetWhizbyProbabilities(1, 2, 10); // the more probable the 3rd value, the less likely you'll hear a whizby
			flag_set("stop_line_emitters");
		}
		break;

		case "sub_missile_door_open":
		{
			door = args;
			thread play_sound_in_space("russian_sub_missile_door", door.origin); 
		}
		break;
		
		case "sub_missile_launch":
		{
			missile = args;
			wait(1);
			thread play_sound_in_space("russian_sub_missile_launch", missile.origin);
			thread play_sound_in_space("russian_sub_rocket_launch", missile.origin);
			aud_stop_city_combat_ambi();
		}
		break;
		
		// Sky Battle	
		case "spawn_f15_fighters_7_8":
		{
			aud_play_2d_sound("skybattle_f15_flyby_7_8_front");
			level.aud.exit_control_room_to_zodiac = true;
			flag_set ("leaving_sub");
			flag_clear("aud_flag_inside_sub");
			MM_add_submix("nyhb_pre_board_zodiac");
			thread aud_start_subtop_line_emitters();
			aud_play_city_combat_ambi();
			level.aud.sub_stress_chance = 0;
		}
		break;

		case "spawn_f15_fighters_1_2":
		{
			f15 = args;
			if(IsDefined(f15))
			{
			//iprintlnbold("AUDIO: spawn_f15_fighters_1_2");
				thread aud_air_vehicle_flyby(f15, "skybattle_f15_flyby_1", 10000);
			}
		}
		break;

		case "spawn_f15_fighters_3_4":
		{
			f15 = args;
			if(IsDefined(f15))
			{
			//iprintlnbold("AUDIO: spawn_f15_fighters_3_4");
			thread aud_air_vehicle_flyby(f15, "skybattle_f15_flyby_3", 12000);
			}
		}
		break;

		case "spawn_ship_squeeze_hind":
		{
			flyby_hind = args;
			if(IsDefined(flyby_hind))
			{
			//iprintlnbold("AUDIO: spawn_ship_squeeze_hind");
			thread aud_air_vehicle_flyby(flyby_hind, "skybattle_hind_flyby_1", 800);
			}
		}
		break;

		case "tomahawk_the_hind":
		{
			missile = args;
			if(IsDefined(missile))
			{
				tomahawk = spawn("script_origin", missile.origin);
				tomahawk linkto( missile );
				tomahawk playsound("skybattle_missile_overhead", "sounddone");
				tomahawk waittill("sounddone");
				wait(0.1);
				tomahawk delete();
			}
		}
		break;

		case "spawn_f15_fighter_5":
		{
			f15 = args;
			if(IsDefined(f15))
			{
			//iprintlnbold("AUDIO: spawn_f15_fighter_5");
			thread aud_air_vehicle_flyby(f15, "skybattle_f15_flyby_5", 900);
			}
		}
		break;

		case "spawn_f15_fighter_6":
		{
			f15 = args;
			if(IsDefined(f15))
			{
			//iprintlnbold("AUDIO: skybattle_f15_flyby_6");
			thread aud_air_vehicle_flyby(f15, "skybattle_f15_flyby_6", 1000);
			}
		}
		break;

		// Patrol Boats	
		case "dvora_1":
		{
			dvora = args;
			if(IsDefined(dvora))
			{
				//iprintlnbold("DVORA_TEST");
				dvora playsound("harb_patrol_boat_by_first");
				thread aud_patrol_boats_post_Indiana_Jones(dvora);
			}
			//iprintlnbold("AUDIO: DVORA WHIZZBY'S");
			wait(1.5);
			level.player playsound("harb_patrol_boat_bullet_whizbys");
		}
		break;
		
		case "dvora_2":
		{
			dvora = args;
		}
		break;
		
		case "slow_mo_dvora":
		{
			dvora = args;
			dvora playsound("harb_patrol_boat_post_slow");
		}
		break;
		
		case "dvora_4":
		{
			dvora = args;
			//iprintlnbold("DVORA_04");
		}
		break;

		case "waterbarrage_inc_normal":
		{
			inc_dur = args;
			thread aud_zodiac_impacts_incoming_normal(inc_dur);
		}
		break;
	
		case "waterbarrage_inc_lateral":
		{
			inc_dur = args;
			thread aud_zodiac_impacts_incoming_lateral(inc_dur);
		}
		break;

		case "zodiac_water_impacts":
		{
			explo_pos = args;
			thread aud_zodiac_water_impacts(explo_pos);	
		}
		break;
		
		case "zodiac_water_impacts_lateral":
		{
			explo_pos = args;
			thread aud_zodiac_water_impacts_lateral(explo_pos);	
		}
		break;
		
		case "explode_wave":
		{
			wave_crest = args;
			wave_crest playsound("water_crash_med_close");
			wave_crest playsound("water_splats_close");		
		}
		break;
	
		case "zodiac_sway_left_light":
		{
			if(!flag("aud_player_zodiac_in_chinook"))
			{
				// splash rate throttle
				level_time = GetTime();
				if ( level_time > level.aud.next_zodiac_splash_time )
				{
					level.player playsound("zodiac_turn_splash_left");
					level.aud.next_zodiac_splash_time = level_time + RandomIntRange(level.aud.zodiac_splash_rate_min, level.aud.zodiac_splash_rate_max);
				}
			}
		}
		break;
		
		case "zodiac_sway_right_light":
		{
			if(!flag("aud_player_zodiac_in_chinook"))
			{
				// splash rate throttle
				level_time = GetTime();
				if ( level_time > level.aud.next_zodiac_splash_time )
				{
					level.player playsound("zodiac_turn_splash_right");
					level.aud.next_zodiac_splash_time = level_time + RandomIntRange(level.aud.zodiac_splash_rate_min, level.aud.zodiac_splash_rate_max);
				}
			}
		}
		break;
		
		case "zodiac_sway_left":
		{
			if(!flag("aud_player_zodiac_in_chinook"))
			{
				// splash rate throttle
				level_time = GetTime();
				if ( level_time > level.aud.next_zodiac_splash_time )
				{
					level.player playsound("zodiac_turn_splash_left");
					level.aud.next_zodiac_splash_time = level_time + RandomIntRange(level.aud.zodiac_splash_rate_min, level.aud.zodiac_splash_rate_max);
				}
			}
		}
		break;
		
		case "zodiac_sway_right":
		{
			if(!flag("aud_player_zodiac_in_chinook"))
			{
				// splash rate throttle
				level_time = GetTime();
				if ( level_time > level.aud.next_zodiac_splash_time )
				{
					level.player playsound("zodiac_turn_splash_right");
					level.aud.next_zodiac_splash_time = level_time + RandomIntRange(level.aud.zodiac_splash_rate_min, level.aud.zodiac_splash_rate_max);
				}
			}
		}
		break;

		case "big_missile_launch_1":
		{
			missile = args;
			//iprintlnbold("AUDIO: big_missile_launch_1");
			wait(0.5);
			//level.player PlaySound( "missile_boat_launch_1");
			if(IsDefined(missile))
			{
				projectile = spawn("script_origin", missile.origin);
				projectile linkto( missile );
				projectile playsound("missile_boat_travel_1", "sounddone");
				flag_wait("big_missile0_landed");
				projectile scalevolume(0.0, 0.1);
				wait(0.2);
				projectile stopsounds();
				projectile delete();
			}
		}
		break;

		case "big_ship_missile_hit":
		{
			//Missile destroys large battleship closest to the sub.
			level.player PlaySound( "missile_big_boat_explo");
			level.player PlaySound( "missile_big_boat_explo_metal");
			wait(0.5);
			level.player PlaySound( "missile_big_boat_groan");
			wait(0.5);
			flag_set("aud_big_ship_missile_explo");
		}
		break;
	
		case "big_missile_launch_2":
		{
			missile = args;
			//iprintlnbold("AUDIO: big_missile_launch_1");
			wait(0.4);
			thread aud_playsound_attach( "missile_boat_launch_2", level.player);
			wait(1.0);
			if(IsDefined(missile))
			{
				projectile = spawn("script_origin", missile.origin);
				projectile linkto( missile );
				projectile playsound("missile_boat_travel_2", "sounddone");
				projectile waittill("sounddone");
				wait(0.1);
				projectile delete();
			}
		}
		break;

		case "incoming_missile_to_boat":
		{
			missile = args;
			if(IsDefined(missile))
			{
				wait(2.8);
				level.player PlaySound("missile_boat_incoming");
			}
		}
		break;
		
		case "little_ship_missile_hit":
		{
			if(!flag("aud_player_zodiac_in_chinook"))
			{
				explo_pos = args;
				if(IsDefined(explo_pos))
				{
					//iprintlnbold("AUDIO: little_ship_missile_hit");
					if( flag( "aud_big_ship_missile_explo" ) )
					{
						aud_play_2d_sound("missile_boat_explo");
						aud_play_2d_sound("missile_boat_explo_lfe");
					}
	
					wait(0.6);
					thread play_sound_in_space("crashing_waves", explo_pos);
					//thread play_sound_in_space("water_crash_med_close", explo_pos);
					thread play_sound_in_space("water_splats_close", explo_pos);
					
					wait(0.5);
					
					dist = distance2d(level.player.origin, explo_pos);
					
					if(dist < 2500)
					{				
						wait(0.4);
						thread play_sound_in_space( "water_splats_2d" , level.player.origin);
					}
				}
			}	
		}
		break;
		
		case "zodiac_landed_big":
		{
			level.player playsound("zodiac_land_big_splash");
			level.player playsound("zodiac_land_big_splats_2d");
			level.player playsound("zodiac_land_big_collision");
		}
		break;
		
		case "zodiac_landed":
		{
			level.player playsound("burya_destroy_splash");
			level.player playsound("water_splats_2d");
			level.player playsound("zodiac_player_collision");
		}
		break;
		
		case "missile_launch":
		{
			missile = args;
			//iprintlnbold("AUDIO: missile_launch");
		}
		break;

		case "pre_slo_mo_splash":  //ACTUAL CARRIER SLOWMO START MOMENT FOR SFX
		{
			level.player playsound("water_crash_med_close_2d");
			thread MM_start_preset("nyhb_boat_slowmo", 1.5);
			level.player playsound("boat_slowmo_start");
			//thread aud_start_slow_mo_gunshot_callback(::aud_play_harb_slowmo_gunshot, ::aud_play_harb_slowmo_impact);
			//wait(2.5);
			SM_start_preset("boat_slowmo_bed_front", 4);
		}
		break;
		
		case "start_carrier_slowmotion":
		{
			music_cue("mus_start_carrier_slowmotion");
		}
		break;

		case "slowmo_dvora_destroyed":
		{
			thread aud_stop_slow_mo_gunshot_callback();
			aud_play_2d_sound("boat_slowmo_fireball");
			aud_play_2d_sound("boat_slowmo_explode_sweet");
			explode = spawn("script_origin", level.player.origin);
			explode playsound("boat_slowmo_explode");
			flag_wait("aud_boat_slowmo_outro");
			SM_stop_ambience(0);
			wait(1);
			explode scalevolume(0.0, 0.5);
			wait(1.0);
			explode stopsounds();
			explode delete();
		}
		break;

		case "boat_slowmo_outro":
		{
			flag_set("aud_boat_slowmo_outro");
			level.player playsound("boat_slowmo_outro");
			wait(1.1);
			level.player playsound("boat_slowmo_splash_lrg");
			level.player playsound("boat_slowmo_tumble");
			wait(0.2);
			level.player playsound("boat_slowmo_end");
			//wait(1.0);
			MM_clear_submix("nyhb_boat_slowmo", 3.0);
		}
		break;

		case "stop_carrier_slowmotion":
		{
			assert(IsDefined(level.escape_zodiac));
			level.escape_zodiac VM_set_range("speed", 0, 65);
			
			music_cue("mus_stop_carrier_slowmotion");
		}
		break;

		case "boat_slowmo_final_splash":
		{
			//iprintlnbold("AUDIO: boat_slowmo_final_splash");
		}
		break;
		
		case "dvora_post_carrier_splashes":
		{
			pos = args;
			thread play_sound_in_space("post_slow_splats_close", pos);
			thread play_sound_in_space("post_dvora_spash_impacts", pos);
			thread play_sound_in_space("post_slow_water_splash_lrg", pos);		
		}
		break;
		
		case "spawn_hind_flyby_5":
		{
			flyby_hind = args;
			if(IsDefined(flyby_hind))
			{
			//iprintlnbold("AUDIO: spawn_hind_flyby_5");
			thread aud_air_vehicle_flyby(flyby_hind, "skybattle_hind_flyby_2", 4500);
			}
		}
		break;

		case "spawn_hind_flyby_6":
		{
			flyby_hind = args;
			if(IsDefined(flyby_hind))
			{
			//iprintlnbold("AUDIO: spawn_hind_flyby_6");
			thread aud_air_vehicle_flyby(flyby_hind, "skybattle_hind_flyby_3", 3000);
			}
		}
		break;		
		
		case "spawn_flyby_chinook_left":
		{
			flyby_chinook = args;
			if(IsDefined(flyby_chinook))
			{
				thread aud_air_vehicle_flyby(flyby_chinook, "chinook_flyby_1", 4500);
			}
		}
		break;

		case "spawn_flyby_chinook_right":
		{
			wait(2);
			level.player playsound("chinook_flyby_rears");
		}
		break;

		case "show_exit_chinook":
		{
			//iprintlnbold("AUDIO:  show_exit_chinook");
		}
		break;

		case "start_zodiac_into_chinook":
		{
			flag_set("aud_player_zodiac_in_chinook");
			wait(1.0);
			level.player playsound("zodoac_to_chinook_splash");
			
			flag_wait("send_off_second_chinook");

		}
		break;

		case "chinook_finale_escape":
		{
			thread aud_zodiac_into_chinook();
			wait(3.4);
			level.player playsound("chinook_liftoff_fronts");
		}
		break;
		
		case "spawn_f15_fighters_finale":
		{
			wait(2.3);
			thread MM_start_preset("nyhb_final_flyby", 0.5);
			level.player playsound("f15_final_flyby_fronts");
		}
		break;

		case "fx_skybox_mig":
		{
			if (!flag("aud_flag_inside_sub") && !flag("player_on_boat"))
			{
				start_point	= args[0];
				end_point		= args[1];
				flight_time	= args[2];
				yards				= distance(level.player.origin, start_point)/36;
					
				//iprintlnbold(">>>>>>>>>> fx_skybox_mig, flight_time: " + flight_time + " yards: " + yards);
				
				// Create the data struct to keep track of things.
				if (!IsDefined(level.aud.mig_count))
				{
					level.aud.mig_count = 0;
				}
				
				if (level.aud.mig_count < MAX_VFX_MIGS && yards < 1000000)	// Eventually cull this based on distance.
				{
					level.aud.mig_count++;
					ent = spawn("script_origin", start_point);			
					aud_play_skybattle_dist_jet(ent, end_point, flight_time);	// Synchronous play that will wait till sounddone, or exit upon notify that we're in the sub.
					ent ScaleVolume(0.0, 0.5);
					wait(0.5);
					ent delete();
					level.aud.mig_count--;
					assert(level.aud.mig_count >= 0 && level.aud.mig_count < MAX_VFX_MIGS);		
				}
			}
		}
		break;
		
		case "fx_skybox_hind":
		{
//			if (flag("aud_flag_inside_sub") && !flag("player_on_boat"))
//				{
//				start_point	= args[0];
//				end_point		= args[1];
//				flight_time	= args[2];
//	
//				yards = distance(level.player.origin, start_point)/36;
//				
//				//iprintlnbold(">>>>>>>>>> fx_skybox_hind, flight_time: " + flight_time + " yards: " + yards);
//			}
		}
		break;

		// The group of hinds shooting when you first get on sub.
		case "hind_spawned":
		{
			if (!IsDefined(level.aud.skybattle_hind_playing))	// Only allow one instance of this stream.
			{
				level.aud.skybattle_hind_playing = true;
				wait(5);
								
				ent = args;
				assert(IsDefined(ent));
				ent PlayLoopSound("skybattle_hind_loop");
				
				while (IsDefined(ent))
				{
					wait(0.25);
				}
				level.aud.skybattle_hind_playing = undefined;
			}
		}
		break;

		// The group of chinooks flying by when you first get on sub.
		case "chinook_spawned":
		{
			if (!IsDefined(level.aud.skybattle_chinook_playing))	// Only allow one instance of this stream.
			{
				level.aud.skybattle_chinook_playing = true;
				wait(8);
				
				ent = args;
				assert(IsDefined(ent));
				ent PlayLoopSound("skybattle_chinook_loop");
				
				while (IsDefined(ent))
				{
					wait(0.25);
				}
				level.aud.skybattle_chinook_playing = undefined;
			}
		}
		break;

		default:
		{
			msg_handled = false;
		}
	}

	return msg_handled;
}

/***************************************/
/******** MUSIC MESSAGE HANDLER ********/
/***************************************/

// For use from within the main audio msg handler.
music_cue(msg, args)
{
	thread music_msg_handler(msg, args);
}

// For use via aud_send_msg().
music_msg_handler(msg, args)
{	
	// Assume that this msg will be handled.
	msg_handled = true;
	
	// Only handle Music Messages (must start with "mus_"
	if (GetSubStr(msg, 0, 4) != "mus_")
		return false;

	// Kill any other instances of this thread that may be still active.
	level notify("kill_other_music");
	level endon("kill_other_music");
	
	// Handle Message.
	switch(msg)
	{
		//---------------------------------------------------------------------------//
		// MUS_play(alias, fade_in_time_, cross_fade_out_time_, volume_, forceplay_) //
		//---------------------------------------------------------------------------//
		
		case "mus_intro":
		{
			wait(5);
			MUS_play("harb_intro");	
		}
		break;
		
		case "mus_sub_passby":
		{
			// This is diminishing the sub sfx awesomness: MUS_play("harb_sub_passby");	
		}
		break;
		
		case "mus_sub_breach_checkpoint":
		{
			aud_set_music_submix(0, 0.05);
			wait(0.05);
			MUS_play("harb_board_sub", 4);
			aud_set_music_submix(1.0, 6);
		}
		break;

		case "mus_drone_E":
		{
			MUS_play("harb_drone_E", 1);
		}
		break;
		
		case "mus_fist_building_explodes":
		{		
			MUS_stop(3);
			wait(10);
			MUS_play("harb_board_sub", 4);
			aud_set_music_submix(1.0, 6);
		}
		break;
			
		case "mus_enter_sub":
		{
			//MUS_play("harb_enter_sub", 3);
			MUS_stop(10);
		}
		break;
			
		case "mus_sub_combat_begin":
		{
			wait(7);
			MUS_play("harb_sub_combat1", 0.2, 3);
		}
		break;
		
		case "mus_sub_interior_flooded":
		{
			MUS_stop(16);
		}
		break;
		
		case "mus_sub_scuttle_announcement":
		{
			wait(1);
			MUS_play("harb_sub_combat2", 0.1, 0.25);
			wait(25);
			MUS_play("harb_sub_combat3", 6);
		}
		break;

		case "mus_e3_demo_fade_in":
		{
			MUS_play("harb_sub_combat3", 2);
		}
		break;
		
		case "mus_bridge_breach_setup":
		{
			aud_set_music_submix(0.60, 8);
		}
		break;
		
		case "mus_sub_door_breach":
		{
			MUS_stop(1.5);
			wait(2);
			aud_set_music_submix(1, 1);
		}
		break;
		
		case "mus_sub_combat_end":
		{
			// Not used.
		}
		break;
			
		case "mus_program_launch":
		{
			MUS_play("harb_program_launch", 3);
		}
		break;
			
		case "mus_to_the_zodiac":
		{
			MUS_play("harb_to_the_zodiac", 0.2, 3);
			aud_set_music_submix(10, 0.1);
		}
		break;
			
		case "mus_zodiac_ride":
		{
			MUS_play("harb_zodiac_ride", 0, 3);
			aud_set_music_submix(1, 0.1);
		}
		break;
			
		case "mus_start_carrier_slowmotion":
		{
			aud_set_music_submix(0, 5);
		}
		break;		
			
		case "mus_stop_carrier_slowmotion":
		{
			aud_set_music_submix(1, 3);
		}
		break;			
			
		case "mus_theres_our_bird":
		{
			wait(2.5);
			MM_add_submix("nyhb_theres_our_bird", 2);
			MUS_play("harb_theres_our_bird", 0, 4);
			wait(6);
			MM_clear_submix("nyhb_theres_our_bird", 2);
		}
		break;
			
		case "mus_finale":
		{
			aud_set_music_submix(10.0, 4);
			MUS_play("harb_finale", 4);
			wait(15);
			aud_set_music_submix(1.0, 4);
		}
		break;

		default:
		{
			msg_handled = false;
		}
	}

	return msg_handled;
}

/********************************************************************
	Support Functions.
********************************************************************/

aud_prime_city_combat_ambi()
{
	level.aud.city_amb_ent_L = thread aud_prime_point_source_loop("amb_harb_dist_city_combat_L", (-24370, -1271, 0));
	level.aud.city_amb_ent_R = thread aud_prime_point_source_loop("amb_harb_dist_city_combat_R", (-1441, -20956, 0));
}
			
aud_play_primed_city_combat_ambi()
{
	if (IsDefined(level.aud.city_amb_ent_L))
	{
		assert(IsDefined(level.aud.city_amb_ent_R));
		level.aud.city_amb_ent_L thread aud_play_primed_point_source_loop("amb_harb_dist_city_combat_L", 1.0, 0.25);
		level.aud.city_amb_ent_R thread aud_play_primed_point_source_loop("amb_harb_dist_city_combat_R", 1.0, 0.25);
	}
}

aud_play_city_combat_ambi()
{
	// Prime if necessary.
	if (!(IsDefined(level.aud.city_amb_ent_L) && IsDefined(level.aud.city_amb_ent_R)) 
			|| !(	level.aud.city_amb_ent_L aud_is_stream_primed("amb_harb_dist_city_combat_L") && 
						level.aud.city_amb_ent_R aud_is_stream_primed("amb_harb_dist_city_combat_R")))
	{
		aud_prime_city_combat_ambi();
		while ( !(level.aud.city_amb_ent_L aud_is_stream_primed("amb_harb_dist_city_combat_L") && level.aud.city_amb_ent_R aud_is_stream_primed("amb_harb_dist_city_combat_R")))
		{
			wait(0.05);
		}
	}
	
	// Play
	if (IsDefined(level.aud.city_amb_ent_L) && IsDefined(level.aud.city_amb_ent_R))
	{
		level.aud.city_amb_ent_L aud_error_if_not_primed("amb_harb_dist_city_combat_L");
		level.aud.city_amb_ent_R aud_error_if_not_primed("amb_harb_dist_city_combat_R");

		level.aud.city_amb_ent_L thread aud_play_primed_point_source_loop("amb_harb_dist_city_combat_L", 1.0, 0.25);
		level.aud.city_amb_ent_R thread aud_play_primed_point_source_loop("amb_harb_dist_city_combat_R", 1.0, 0.25);
	}
}

aud_stop_city_combat_ambi()
{
	if (IsDefined(level.aud.city_amb_ent_L))
	{
		assert(IsDefined(level.aud.city_amb_ent_R));
		aud_stop_point_source_loop(level.aud.city_amb_ent_L, 0.1);
		aud_stop_point_source_loop(level.aud.city_amb_ent_R, 0.1);
		level.aud.city_amb_ent_L = undefined; // Remove reference to deleted sound.
		level.aud.city_amb_ent_R = undefined; // Remove reference to deleted sound.
	}
}

aud_gate_cut_start()
{
	
	wait(3);
	level.player playsound("scn_gate_cut_tube_drone");
	ent = spawn("script_origin", level.player.origin);
	wait(7);
	ent playloopsound("scn_gate_cut_weld_lp");
	
	ent scalevolume(0.0, 0.05);
	wait(0.1);
	ent scalevolume(1.0, 9.0);
	wait(15.5);
	
	ent scalevolume(0.0, 0.3);
	wait(3);
	ent delete();
}

aud_torch_flash()
{
	if(!flag( "aud_first_spark_played" ))
	{
		level.player playsound( "scn_gate_cut_spark_02" );
		flag_set( "aud_first_spark_played" );
		flag_set( "aud_second_spark" );
	}
	else if( flag( "aud_second_spark" ))
	{
		level.player playsound( "scn_gate_cut_spark_03" );
		flag_clear( "aud_second_spark" );
		flag_set( "aud_third_spark" );
	}
	else if( flag( "aud_third_spark" ))
	{
		level.player playsound( "scn_gate_cut_spark_03" );
	}
}

aud_sdv_scuba_bubbles()
{
	if (flag("aud_flag_player_underwater"))
	{
		level.player playsound("nyhb_scuba_breathe_player_bubbles");
		wait(3.5);
	}
	
	if (flag("aud_flag_scubamask_on_player"))
	{
		level.player playsound("nyhb_scuba_breaths"); 
	}
}

aud_player_scuba_bubbles()
{
	if (flag("aud_flag_player_underwater"))
	{
		level.player playsound("nyhb_scuba_breathe_player_bubbles");
		wait(3.5);
	}
	
	if (flag("aud_flag_scubamask_on_player"))
	{	
		level.player playsound("nyhb_scuba_breaths");
	}
}

aud_battleship_sink(aud_data)
{
	ship_ent = aud_data[0];
	sink_time = aud_data[1];
	dest_pos = aud_data[2];

	ship_ent thread aud_play_sink_impact_stop(sink_time);
	//ship_ent thread aud_play_sink_loops(sink_time, dest_pos, ship_ent);
	//thread aud_battle_bubbles();
	
	threshold = 4500;
	map_max = 4500;
	map_min = 1500;

	while(1)
	{
		level endon("aud_end_ship_sink");
		
		dist = distance(level.player.origin, ship_ent.origin);
		wait(0.2);
		if(threshold > dist) // If player is close enough to the ship.
		{
			ship_ent playsound("harb_battleship_sink");

			//iprintlnbold("AUDIO: SINK GROANS");
			while(1)
			{		
				level endon("aud_end_ship_sink");	
					
				dist = distance(level.player.origin, ship_ent.origin);
				vol_map = aud_map_range(dist, map_min, map_max, level.aud.envs["aud_battleship_sink"]);
				ship_ent ScaleVolume(vol_map, 0.1);
				wait(0.2);
				if(flag("aud_sink_impact_done"))
				{
					ship_ent ScaleVolume(0.0, 5.0);
					wait(5.2);
					ship_ent stopsounds();
					flag_set("aud_end_ship_sink");
				}
			}
		}
	}
}

aud_debris_splashes_underwater()
{
	wait(0.6);
	level.player playsound("harb_battleship_sink_uw_splash");
	wait(1);
	level.player playsound("harb_battleship_sink_uw_splash");
	wait(0.5);
	level.player playsound("harb_battleship_sink_uw_splash");
	wait(0.6);
	level.player playsound("harb_battleship_sink_uw_splash");
	wait(1);
	level.player playsound("harb_battleship_sink_uw_splash");
}

aud_play_sink_impact_stop(sink_time)
{
	wait(sink_time);
	thread play_sound_in_space("harb_battleship_sink_impact_stop_01", self.origin);
	thread MM_clear_submix("nyhb_battleship_sink", 2.5);
	flag_set("aud_sink_impact_done");
}	
	
aud_play_sink_loops(sink_time, dest_pos, ship_ent)
{
	ship_ent2 = spawn("script_origin", self.origin);
	ship_ent2 linkto(self);
	randwait = randomintrange(5,15);
	
	wait(sink_time);
	ship_ent2 playloopsound("harb_battleship_sink_bubbles_post");
	
	//Turned off until after E3.
	//thread aud_creaks_ship_sunk();
	
	flag_wait("aud_end_ship_sink");
	ship_ent2 ScaleVolume(0.0, 4.0);
	wait(5);
	ship_ent2 stopsounds();
	wait(0.2);
	ship_ent2 delete();
}

aud_battle_bubbles()
{
	flag_wait("aud_sink_impact_done");
	//iprintlnbold("AUDIO: SHIP SINK BUBBLES");
	bubble_stax_L = spawn("script_origin", (-25538,-19991,-676));
	bubble_stax_R = spawn("script_origin", (-25157,-19391,-484));
	under_center = spawn("script_origin", (-25157,-19391,-484));
	under_left = spawn("script_origin", (-25993,-19981,-1023));
	
	bubble_stax_L playloopsound("harb_battleship_sink_bubbles_post");
	bubble_stax_L ScaleVolume (0.0, 0.05);
	
	wait(0.25);
	
	bubble_stax_R playloopsound("harb_battleship_sink_bubbles");
	bubble_stax_R	ScaleVolume (0.0, 0.05);
	
	wait(0.25);
	
	under_center playloopsound("harb_battleship_sink_bubbles_post");
	under_center	ScaleVolume (0.0, 0.05);
	
	wait(0.25);
	
	under_left playloopsound("harb_battleship_sink_bubbles");
	under_left		ScaleVolume (0.0, 0.05);
	
	bubble_stax_L ScaleVolume (1.0, 0.2);
	bubble_stax_R	ScaleVolume (1.0, 0.2);
	under_center	ScaleVolume (1.0, 0.2);
	under_left		ScaleVolume (1.0, 0.2);	
	
	flag_wait("aud_kill_ship_residuals");
	
	bubble_stax_L ScaleVolume (0.0, 0.3);
	bubble_stax_R	ScaleVolume (0.0, 0.3);
	under_center	ScaleVolume (0.0, 0.3);
	under_left		ScaleVolume (0.0, 0.3);
	
	wait(0.4);

	bubble_stax_L delete();
	bubble_stax_R delete();
	under_center delete();
	under_left delete();
}

aud_ignore_slowmo()
{
	SoundSetTimeScaleFactor( "norestrict2d", 0 );
	SoundSetTimeScaleFactor( "music", 0 );
	SoundSetTimeScaleFactor( "local", 0.25 );
	SoundSetTimeScaleFactor( "local3", 0.25 );
	SoundSetTimeScaleFactor( "weapon", 0.15 );
	
	SoundSetTimeScaleFactor( "grondo2d", 0 );
	SoundSetTimeScaleFactor( "bulletimpact", 0 );
	SoundSetTimeScaleFactor( "bulletflesh1", 0 );
	SoundSetTimeScaleFactor( "bulletflesh2", 0 );
	SoundSetTimeScaleFactor( "bulletwhizby", 0 );
}

aud_door_breach_slomo()
{
	thread aud_start_slow_mo_gunshot_callback(::aud_play_harb_door_breach_gunshot, ::aud_play_harb_door_breach_impact);
	thread mm_clear_submix("pre_bridge_breach", 0.05);
	thread mm_add_submix("sub_door_breach", 0.05);
	thread AZM_start_zone("nyhb_breach_slomo", 0.05);
	
	hi_ent = spawn("script_origin", level.player.origin);
	lo_ent = spawn("script_origin", level.player.origin);
	
	hi_ent playloopsound("surreal_hi_lp");
	lo_ent playloopsound("surreal_lo_lp");
	
	flag_wait("aud_door_slowmo_exit");
	thread aud_stop_slow_mo_gunshot_callback();
	thread mm_clear_submix("sub_door_breach", 0.3);	
	level.player playsound("db_fast_forward");
	wait(0.5);
	thread AZM_start_zone("nyhb_sub_interior_controlroom", 1.5);
	
	hi_ent ScaleVolume(0.0, 0.1);
	lo_ent ScaleVolume(0.0, 0.1);
	wait(0.15);
	
	lo_ent delete();
	hi_ent delete();
}

aud_player_exit_slomo()
{
	flag_set("aud_door_slowmo_exit");
}

aud_overhead_missiles()
{
	inc_ent = spawn("script_origin", level.player.origin);
	dist_ent = spawn("script_origin", level.player.origin);
	wait(0.3);
	inc_ent playsound("harb_surface_missile_incoming_ext");
	wait(1);
	level.player playsound("harb_surface_missile_overhead");
	inc_ent ScaleVolume(0.0, 1.2);
	wait(0.55);
	level.player playsound("harb_surface_missile_overhead_lo");
	wait(0.35);
	dist_ent playsound("harb_overhead_missiles_tail");
	wait(0.05);
	dist_ent ScaleVolume(1.0, 1);
	flag_wait("aud_building_exploded");
	dist_ent ScaleVolume(0.0, 0.3);
	
	wait(0.75);
	dist_ent delete();
	inc_ent delete();
}

aud_building_explode()
{
	flag_set("aud_building_exploded");
	level.player playsound("harb_missile_dist_city_explo_02");
}

aud_building_explode_02()
{
	flag_set("aud_building_02_exploded");
	play_sound_in_space("harb_missile_dist_city_explo_02", (-38106, -16892, 2417) );
}

aud_start_subtop_line_emitters()
{
	thread aud_play_line_emitter("sub_waves_right", "sub_surfaced_side_water_close_lp", (-40261,-24354,-130), (-35223,-24524,-130), 1.0, 2.0);
	thread aud_play_line_emitter("sub_waves_right_lyr", "sub_surfaced_churn_lyr_lp", (-40261,-24354,-130), (-35223,-24524,-130), 1.0, 2.0);
	
	thread aud_play_line_emitter("sub_waves_left", "sub_surfaced_side_water_close_lp", (-40254,-23394,-130), (-35165,-23366,-130), 1.0, 2.0);
	thread aud_play_line_emitter("sub_waves_left_lyr", "sub_surfaced_churn_lyr_lp", (-40254,-23394,-130), (-35165,-23366,-130), 1.0, 2.0);
	
	flag_wait("stop_line_emitters");
	level notify("sub_waves_right_line_emitter_stop");
	level notify("sub_waves_right_lyr_line_emitter_stop");
	level notify("sub_waves_left_line_emitter_stop");
	level notify("sub_waves_left_lyr_line_emitter_stop");
	wait(0.05);
	flag_clear("stop_line_emitters");
}

aud_steam_emitters()
{
	//EngineRoom
	loop_fx_sound("sub_emt_med_steam_lp_01",(-39450, -23922, -308),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-39367, -23762, -311),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-39154, -23918, -311),true);
	
	//Barracks
	loop_fx_sound("sub_emt_med_steam_lp_01",(-38801, -23701, -385),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-38912, -23853, -332),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-38914, -23729, -332),true);

	//FloodedRoom
	loop_fx_sound("sub_emt_med_steam_lp_01",(-38508, -24115, -557),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-38506, -23916, -487),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-38394, -23595, -547),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-38273, -23678, -479),true);
	
	//Pre_Missileroom
	loop_fx_sound("sub_emt_med_steam_lp_01",(-37772, -23810, -418),true);
	
	//MissileRoom1
	loop_fx_sound("sub_emt_med_steam_lp_01",(-37300, -23717, -453),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-37048, -23715, -465),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-37128, -23984, -427),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-37387, -23994, -432),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-37348, -24006, -444),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-37382, -23896, -454),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-37487, -23800, -430),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-37387, -23897, -435),true);
	
	//MissileRoom2
	loop_fx_sound("sub_emt_med_steam_lp_01",(-36485, -23720, -431),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-36284, -23847, -434),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-36482, -23992, -423),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-36651, -23991, -439),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-36169, -23706, -235),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-36529, -23637, -219),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-36386, -24069, -221),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-36564, -24065, -218),true);
	
	//ControlRoom
	loop_fx_sound("sub_emt_med_steam_lp_01",(-35722, -24071, -209),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-35496, -23919, -204),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-35548, -23829, -206),true);
	loop_fx_sound("sub_emt_med_steam_lp_01",(-35913, -23651, -212),true);
	
}	

aud_machinery_emitters()
{
	loop_fx_sound("sub_emt_engine_turbine_01",(-39342, -23987, -396),1);//engine near wall
	loop_fx_sound("sub_emt_engine_turbine_02",(-39308, -23722, -360),1);//engine near ladder
	loop_fx_sound("sub_emt_turbine_diesel_01",(-39342, -23987, -396),1);//engine near wall
	loop_fx_sound("sub_emt_turbine_diesel_02",(-39308, -23722, -360),1);//engine near ladder
	
	// CUT for RAM: 	loop_fx_sound("sub_emt_bigpump_01",(-38308, -23857, -570),1);//pump base
	// CUT for RAM: 	loop_fx_sound("sub_emt_pipe_run_med",(-38311, -23860, -475),1);//pump top
	// CUT for RAM: 	loop_fx_sound("sub_emt_pipe_run_high",(-38263, -23862, -546),1);//pump pipe_01
	// CUT for RAM: 	loop_fx_sound("sub_emt_pipe_run_high",(-38310, -23819, -546),1);//pump pipe_02
	// CUT for RAM: 	loop_fx_sound("sub_emt_pipe_run_high",(-38358, -23864, -546),1);//pump pipe_03
	// CUT for RAM: 	loop_fx_sound("sub_emt_pipe_run_high",(-38310, -23910, -546),1);//pump pipe_04
}

aud_electric_breakerboxes()
{
	loop_fx_sound("sub_emt_electric_hum", (-37693, -23667, -414),1);//pre steamroom breaker
	loop_fx_sound("sub_emt_electric_hum", (-39101, -23686, -370),1);
	loop_fx_sound("sub_emt_electric_hum", (-39134, -23667, -341),1);
	loop_fx_sound("sub_emt_electric_hum", (-37512, -23640, -409),1);
	loop_fx_sound("sub_emt_electric_hum", (-36837, -24082, -415),1);
	loop_fx_sound("sub_emt_electric_hum", (-36387, -24072, -270),1);
	loop_fx_sound("sub_emt_electric_hum", (-35921, -24087, -251),1);
	loop_fx_sound("sub_emt_electric_hum", (-35467, -24057, -228),1);
	loop_fx_sound("sub_emt_electric_hum", (-35877, -23623, -253),1);
	loop_fx_sound("sub_emt_electric_hum", (-35466, -23677, -224),1);
}	

aud_sub_computers()
{
	//loop_fx_sound("sub_emt_comp_med_idle",(-39233,-23664,-379),1);
	loop_fx_sound("sub_emt_comp_med_on_01",(-36807,-23594,-249),1);
	loop_fx_sound("sub_emt_comp_small_idle",(-37751,-23638,-417),1);
	loop_fx_sound("sub_emt_comp_large_on",(-37410,-23627,-353),1);
	loop_fx_sound("sub_emt_comp_small_idle_02",(-37210,-24081,-363),1);
	loop_fx_sound("sub_emt_comp_small_idle",(-37278,-23634,-387),1);
	loop_fx_sound("sub_emt_comp_small_idle",(-36556,-24077,-258),1);
	loop_fx_sound("sub_emt_comp_small_idle_02",(-36967,-24077,-280),1);
	loop_fx_sound("sub_emt_comp_small_idle",(-36697,-24077,-282),1);
	loop_fx_sound("sub_emt_comp_small_idle_02",(-36529,-23638,-282),1);
	loop_fx_sound("sub_emt_comp_large_on",(-37086,-24076,-264),1);
	loop_fx_sound("sub_emt_comp_med_idle",(-37092,-24078,-282),1);
	loop_fx_sound("sub_emt_comp_med_idle",(-36834,-23893,-264),1);
	loop_fx_sound("sub_emt_comp_med_on_01",(-36834,-23893,-265),1);
	loop_fx_sound("sub_emt_comp_small_idle_02",(-37028,-23561,-387),1);
	loop_fx_sound("sub_emt_comp_small_idle",(-37099,-24083,-358),1);
	loop_fx_sound("sub_emt_comp_small_idle",(-36907,-24083,-358),1);
	loop_fx_sound("sub_emt_comp_small_idle",(-36087,-24154,-358),1);
	//control_room
	loop_fx_sound("sub_emt_comp_med_on_01",(-35831,-24081,-253),1);
	//loop_fx_sound("sub_emt_comp_large_on",(-35923,-23834,-276),1);
	//loop_fx_sound("sub_emt_comp_small_idle",(-36010,-23875,-272),1);
	//loop_fx_sound("sub_emt_comp_small_idle_02",(-36009,-23764,-272),1);
	loop_fx_sound("sub_emt_comp_med_on_02",(-35656,-24071,-249),1);
	loop_fx_sound("sub_emt_comp_large_on",(-35825,-23642,-240),1);//computer sandman uses
}	

aud_floodroom_water()
{
	loop_fx_sound("harb_emt_water_flooding_large_lp",(-38532,-24093,-574),1);//flooded_water_test
	loop_fx_sound("harb_emt_water_flooding_large_lp",(-38494,-23921,-569),1);
	loop_fx_sound("harb_emt_water_flooding_large_lp",(-38490,-23798,-569),1);
	loop_fx_sound("harb_emt_water_flooding_large_lp",(-38477,-23647,-569),1);
	loop_fx_sound("harb_emt_water_flooding_large_lp",(-38357,-23649,-569),1);
	loop_fx_sound("harb_emt_water_flooding_large_lp",(-38245,-23654,-569),1);
	loop_fx_sound("harb_emt_water_flooding_large_lp",(-38123,-23674,-569),1);
	loop_fx_sound("harb_emt_water_flooding_large_lp",(-38126,-23796,-569),1);
	loop_fx_sound("harb_emt_water_flooding_large_lp",(-38127,-23901,-569),1);
	loop_fx_sound("harb_emt_water_flooding_large_lp",(-38117,-24056,-569),1);
	loop_fx_sound("harb_emt_water_flooding_large_lp",(-38228,-24049,-569),1);
	loop_fx_sound("harb_emt_water_flooding_large_lp",(-38345,-24048,-569),1);
	loop_fx_sound("harb_emt_water_flooding_large_lp",(-37982,-24036,-566),1);
}

aud_reactor_computers()
{
	wait(4);
	play_loopsound_in_space("sub_emt_comp_med_on_02",(-37642,-23797,-433));
	play_loopsound_in_space("sub_emt_comp_med_on_01",(-37639,-23938,-441));
}

aud_controlroom_lights()
{
	loop_fx_sound("emt_light_fluorescent_hum_harb",(-35789,-24027,-205),1);
	loop_fx_sound("emt_light_fluorescent_hum_harb",(-35625,-24026,-211),1);
	loop_fx_sound("emt_light_fluorescent_hum_harb",(-35608,-23701,-210),1);
	loop_fx_sound("emt_light_fluorescent_hum_harb",(-35808,-23703,-210),1);
}

aud_steamy_vents()
{
	loop_fx_sound("sub_emt_vent_steamy",(-39241,-23751,-431),1);
	loop_fx_sound("sub_emt_vent_steamy",(-39384,-23749,-428),1);
}

aud_siren_first()
{
	wait(1);
	siren_01 = Spawn("script_origin",(-38895,-23724,-360)); // unoccluded siren
	siren_01 PlayLoopSound("sub_emt_small_alarm_01_intro");
	wait(0.1);
	siren_01 scalevolume(0.0, 0.05);
		
	siren_01_occluded = Spawn( "script_origin", (-38895,-23724,-360)); // occluded
	siren_01_occluded PlayLoopSound("sub_emt_small_alarm_01_intro_occ");
	
	level waittill("aud_bulkhead_door_open");
	wait(7.0); // wait for a bit
	siren_01 scalevolume(1.0, 1.0);
	siren_01_occluded scalevolume(0.0, 1.0);
	// LEAK
}

aud_scuttle_alarms_start()
{
	scuttle_alarm_01 = Spawn("script_origin", (-37770,-23772,-348));
	scuttle_alarm_01 PlayLoopSound("sub_emt_alarm_01_tight");//pre reactor room
	scuttle_alarm_02 = Spawn("script_origin", (-37207,-23853,-192));
	scuttle_alarm_02 PlayLoopSound("sub_emt_large_alarm_01");//reactor room 1
	scuttle_alarm_03 = Spawn("script_origin", (-36470,-23856,-192));
	scuttle_alarm_03 PlayLoopSound("sub_emt_alarm_01_reactor");//reactor room 2
	
	flag_wait("player_on_boat");
	scuttle_alarm_01 delete();
	scuttle_alarm_02 delete();
	scuttle_alarm_03 delete();
}

aud_control_room_alarms()
{
	//loop_fx_sound("sub_emt_small_alarm_03",(-35586,-23644,-261),1);
	loop_fx_sound("sub_emt_small_alarm_02",(-35865,-23727,-238),1);
	small_alarm = Spawn("script_origin",(-35755,-23879,-234));
	small_alarm PlayLoopSound("sub_emt_small_alarm_01");
	flag_wait("leaving_sub");
	small_alarm scalevolume(0.0, 1.0);
	wait 1.0;
	small_alarm Delete();
}

aud_start_missilekeytoss( note, flagName )
{
	//level.player aud_error_if_not_primed("harb_se_missilekeytoss");
	//level.player playsound("harb_se_missilekeytoss_start");
	wait(8.5);
	play_loopsound_in_space("harb_emt_missilekeytoss_alarm",(-35545,-23648,-261));
}

aud_flooded_waterfalls()
{
	loop_fx_sound("sub_emt_waterfall_flooded",(-38491,-24081,-557),1);
	loop_fx_sound("sub_emt_waterfall_flooded",(-38136,-23636,-520),1);
	loop_fx_sound("sub_emt_waterfall_flooded",(-36099,-23717,-313),1);
}

aud_sub_waterfalls()
{
	//splatter
	loop_fx_sound("sub_emt_waterfall_splatter_large",(-37052,-23603,-422),1);//MR1 Left
	loop_fx_sound("sub_emt_waterfall_splatter_large",(-36126,-23685,-431),1);//MR2 Far Left
	loop_fx_sound("sub_emt_waterfall_splatter_small",(-36147,-23610,-423),1);//MR1 FarFar Left
	loop_fx_sound("sub_emt_waterfall_splatter_large",(-36619,-24058,-434),1);//MR2 First Right
	loop_fx_sound("sub_emt_waterfall_splatter_large",(-36048,-23886,-439),1);//MR2 Middle Far
	
	//pipes
	loop_fx_sound("sub_emt_waterfall_pipe",(-36622,-24035,-242),1);//MR2 Early Right
	//loop_fx_sound("sub_emt_waterfall_pipe",(-36038,-23882,-245),1);//MR2 Far Middle
	loop_fx_sound("sub_emt_waterfall_pipe",(-36112,-23656,-242),1);//MR2 Far Left
	loop_fx_sound("sub_emt_waterfall_pipe",(-36143,-23578,-241),1);//MR2 Far Far Left
}

aud_controlroom_radios()
{
	loop_fx_sound("sub_emt_rus_radio_01",(-35548,-24070,-245),1);//far right corner
	loop_fx_sound("sub_emt_rus_radio_02",(-35500,-23653,-250),1);//far left corner
	loop_fx_sound("sub_emt_rus_radio_02",(-35805,-23652,-250),1);//sandman console
}

aud_fires()
{
	//flooded_reactor_fire
	loop_fx_sound("harb_emt_fire_metal_large",(-38541,-23707,-520));
	//gasfires
	loop_fx_sound("harb_emt_fire_metal_small",(-39485,-23872,-400),1);//by ladder
	loop_fx_sound("harb_emt_fire_metal_small",(-39397,-23885,-400),1);//by engine
	loop_fx_sound("harb_emt_fire_metal_small",(-39465,-23809,-400),1);//left of ladder
	//control room electric fires
	loop_fx_sound("harb_emt_fire_electrical_small",(-35506,-23630,-224),1);//far left corner
	loop_fx_sound("harb_emt_fire_electrical_small",(-35552,-24066,-224),1);//
}

aud_uw_bubbles()
{
	loop_fx_sound("harb_emt_uw_bubbles",(-16391,-24217,-1626),1);
	loop_fx_sound("harb_emt_uw_bubbles",(-16912,-23948,-1638),1);
	loop_fx_sound("harb_emt_uw_bubbles",(-17111,-23671,-1638),1);
	loop_fx_sound("harb_emt_uw_bubbles",(-17730,-23752,-1686),1);
	loop_fx_sound("harb_emt_uw_bubbles",(-19143,-23864,-1715),1);
}

aud_velocity_emitters()
{
	loop_fx_sound("peer_velo_whoosh",(-22365,-18856,-171),1);	// 1st, left
	loop_fx_sound("peer_velo_whoosh",(-22581,-19179,-171),1);	// 1st, right
	
	loop_fx_sound("peer_velo_whoosh",(-21995,-19050,-171),1);	// 2nd, left
	loop_fx_sound("peer_velo_whoosh",(-22208,-19422,-171),1);	// 2nd, right
	
	loop_fx_sound("peer_velo_whoosh",(-21775,-19481,-171),1);	// 3rd
	
	loop_fx_sound("peer_velo_whoosh",(-21300,-19519,-171),1);	// 4th
	
	loop_fx_sound("peer_velo_whoosh",(-20937,-19757,-171),1);	// 5th
	
	loop_fx_sound("peer_velo_whoosh",(-20548,-20024,-171),1);	// 6th
	
	loop_fx_sound("peer_velo_whoosh",(-20209,-20237,-171),1);	// 7th
	
	loop_fx_sound("peer_velo_whoosh",(-19859,-20482,-171),1);	// 8th
}

aud_zodiac_impacts_incoming_normal(inc_dur)
{	
	inc_ent = spawn("script_origin", level.player.origin);
	inc_ent playsound("harb_incoming_mortars");
	wait(inc_dur);
	inc_ent ScaleVolume(0.0, 0.1);
	wait(0.5);
	inc_ent delete();
}

aud_zodiac_impacts_incoming_lateral(inc_dur)
{	
	inc_ent = spawn("script_origin", level.player.origin);
	inc_ent playsound("harb_incoming_mortars");
	wait(inc_dur);
	inc_ent ScaleVolume(0.0, 0.1);
	wait(0.5);
	inc_ent delete();
}

aud_zodiac_water_impacts(explo_pos)
{
	thread play_sound_in_space("cannonball_water_explode", explo_pos);		
	thread play_sound_in_space("cannonball_impact_2d", explo_pos);
	wait(0.4);
	thread play_sound_in_space("cannonball_water_splats_2d", explo_pos);
	thread play_sound_in_space("cannonball_waves_spray_2d", explo_pos);
}

aud_zodiac_water_impacts_lateral(explo_pos)
{
	thread play_sound_in_space("cannonball_water_explode", explo_pos);		
	thread play_sound_in_space("cannonball_impact_2d", explo_pos);
	wait(0.4);
	thread play_sound_in_space("cannonball_water_splats_2d", explo_pos);
	thread play_sound_in_space("cannonball_waves_spray_2d", explo_pos);
}

aud_patrol_boats_post_Indiana_Jones(dvora)
{
	flag_wait("zubrs_destroyers");
	wait(2);
	dvora playsound("harb_patrol_boat_by_last");
}

aud_sub_destroy()
{
	wait(10);
	level.player playsound("harb_sub_explosion_front");
}

aud_harbor_surface_water_sfx()
{
	//Waterfall coming from bow of capsized aircraft carrier.
	play_loopsound_in_space("water_splats_lp_3d", (-31949,-11607,-161));
	play_loopsound_in_space("waterfall_lp_layer_02", (-31949,-11607,-161));
	
	play_loopsound_in_space("waves_crashing_close_lp", (-31130,-14502,-153));
}

aud_zodiac_jump()
{
	flag_wait("player_zodiac_jump_ramp");
	//iprintlnbold("jumping!");
	
	// Only play jump sound if zodiac is going fast.
	if (IsDefined(level.escape_zodiac))
	{
		speed = level.escape_zodiac Vehicle_GetSpeed();
		
		if (speed > MAX_ZODIAC_SPEED/6)
		{
			MM_add_submix("nyhb_zodiac_jump");
			//Disable VM boat throttle.
			level.escape_zodiac VM_DisableThrottleUpdate(3);
			flag_clear("player_zodiac_jump_hitwater");
			wait(0.05);
			flag_wait("player_zodiac_jump_hitwater");
			//iprintlnbold("wetandwild!");
			
			// Play land sound.
			level.player playsound("zodiac_player_collision");

			//Enable VM boat throttle.
			level.escape_zodiac VM_EnableThrottleUpdate();
			MM_clear_submix("nyhb_zodiac_jump");
			
			// Play another land sound.
			wait(0.05);
			level.player playsound("zodiac_player_collision");
		}
	}
	// Clear flag so we can do it again if necessary.
	flag_clear("player_zodiac_jump_ramp");
	flag_clear("player_zodiac_jump_hitwater");
}

aud_zodiac_into_chinook()
{
	level.player playsound("zodoac_to_chinook_motor");
	thread VM_stop_preset_instance("escape_zodiac", 1);
	thread VM_stop_preset_instance("escape_zodiac_water", 1);
	wait(0.55);
	level.player playsound("zodoac_to_chinook_impact");
	thread AZM_start_zone("nyhb_chinook_interior_flight", 1.5);
	wait(1.6);
	level.player playsound("zodoac_to_chinook_slide");
	wait(3);
	MM_start_preset("nyhb_finale", 1.5);
	wait(8);
	MM_start_preset("nyhb_finale_amb_fade", 10);
}

/********************************************************************
	Trigger Multiple Audio Callback Functions.
********************************************************************/


/********************************************************************
	Zodiac Boat Audio System.
********************************************************************/

aud_player_on_zodiac()
{
	flag_wait("player_on_boat");
	level.escape_zodiac Vehicle_TurnEngineOff();
	thread VM_start_preset("escape_zodiac", "escape_zodiac", level.escape_zodiac, 2.0, "shg_zodiac_plr_startup", (-50, 0, 0));	
	thread VM_start_preset("escape_zodiac_water", "escape_zodiac_water", level.escape_zodiac, 2.0);
	thread aud_zodiac_scrape(level.escape_zodiac);
}

aud_zodiac_scrape(zodiac_ent)
{
	flag_wait("player_zodiac_jump_ramp");
	 
	if (IsDefined(zodiac_ent))
	{
		zod_speed = zodiac_ent Vehicle_GetSpeed();
		
		if(zod_speed > 10)
		{
			level.player playsound ("zod_hit_ramp");
			level.player playsound ("zod_ramp_scrape");
			wait(0.45);
			level.player playsound ("zod_ramp_leave");
		}
	}
}

/********************************************************************
	SDV Audio System.
********************************************************************/

aud_player_sdv_intro()
{
	flag_wait ("level_fade_done");
	wait(10);
	ai_sdv = spawn("script_origin", level.player.origin);
	ai_sdv aud_prime_stream("shg_sdv_intro_npc_start");

	wait(3); // start priming the next
	pc_sdv = spawn("script_origin", level.player.origin);
	pc_sdv aud_prime_stream("shg_sdv_intro_plr_spline_fronts");
	
	wait(4.2);
	isprimed = ai_sdv aud_is_stream_primed("shg_sdv_intro_npc_start");
	assert(isprimed);
	//iprintlnbold("AUDIO: START NPC SDV MOVE");
	ai_sdv playsound("shg_sdv_intro_npc_start");
	
	flag_wait("aud_player_tunnel_spline"); 
	isprimed = pc_sdv aud_is_stream_primed("shg_sdv_intro_plr_spline_fronts");
	assert(isprimed);
	//iprintlnbold("AUDIO: START PLAYER SDV SPLINE");
	pc_sdv playsound("shg_sdv_intro_plr_spline_fronts");  

	flag_wait("player_out_of_vent");
	aud_player_sdv_on();
	thread aud_player_sdv_pause();
	wait(2);
	ai_sdv delete();
	pc_sdv delete();
}

aud_player_sdv_pause()
{
	flag_wait("russian_sub_spawned");
	aud_player_sdv_off();
	thread aud_player_sdv_unpause();
	wait(1);	
	level.player playsound( "shg_sdv_plr_shutdown" );
}

aud_player_sdv_unpause()
{
	flag_wait("sdvs_chase_sub");
	aud_player_sdv_on();
	thread aud_player_sdv_outro();	
}

aud_player_sdv_outro()
{
	flag_wait("aud_planting_submine");

	thread aud_surfacing_bubbles();
	thread aud_player_sdv_se();
	
	level.aud.sdv_temp_speed = level.player_sdv Vehicle_GetSpeed();
	
	VM_set_speed_callback("sdv_motor_player", ::aud_player_sdv_speed_callback_temp);
	VM_set_throttle_callback("sdv_motor_player", ::aud_player_sdv_throttle_callback_temp);
	VM_set_speed_callback("sdv_water_player", ::aud_player_sdv_speed_callback_temp);
	VM_set_throttle_callback("sdv_water_player", ::aud_player_sdv_throttle_callback_temp);
	
	level.player playsound( "shg_sdv_plr_shutdown" );
}

aud_player_sdv_se()
{
	wait(7);
	sdv_ent = spawn("script_origin", level.player.origin);
	sdv_ent playloopsound("shg_sdv_plr_motor_fast");
	sdv_ent ScaleVolume(0.0, 0.05);
	wait(0.05);
	sdv_ent ScaleVolume(1.0, 3);
	wait(9);
	sdv_ent ScaleVolume(0.0, 6);
	wait(6.5);
	sdv_ent delete();
}

aud_surfacing_bubbles()
{
	wait(4);
	bub_ent = spawn("script_origin", level.player.origin);
	bub_ent playloopsound("harb_post_mine_speed_bubbles");
	bub_ent ScaleVolume(0.0, 0.05);
	wait(0.05);
	level.player playsound("underwater_movement_02");
	bub_ent ScaleVolume(1, 7);
	wait(10);
	level.player playsound("underwater_movement_03");
	wait(5);
	bub_ent ScaleVolume(0.0, 6);
	wait(6.5);
	bub_ent delete();
}

aud_player_sdv_on()
{
	//level._audio.veh.print_speed = true;
	//level._audio.veh.print_throttle = true;
	thread VM_start_preset("sdv_motor_player", "sdv_motor_player", level.player_sdv, 2.0);	
	thread VM_start_preset("sdv_water_player", "sdv_water_player", level.player_sdv, 2.0);
}

aud_player_sdv_speed_callback_temp()
{
	speed = 12;
	if (isDefined(level.aud.sdv_temp_speed))
	{
		speed = level.aud.sdv_temp_speed;
	}
	return speed;
}

aud_player_sdv_throttle_callback_temp()
{
	return 1.0;
}

aud_player_sdv_off(fade_time_)
{
	fade_time = 2.0;
	if (IsDefined(fade_time_))
	{
		fade_time = fade_time_;
	}

	
	thread VM_stop_preset_instance("sdv_motor_player", fade_time);	
	thread VM_stop_preset_instance("sdv_water_player", fade_time);
}

/********************************************************************
	Air Vehicle Flyby System.
********************************************************************/

waittill_deathspin(entity)
{
	self endon("flyby_ent");
	entity waittill("deathspin");
	self notify("flyby_ent", "deathspin");
}

waittill_sounddone()
{
	self endon("flyby_ent");
	self waittill("sounddone");
	self notify("flyby_ent", "sounddone");
}


aud_air_vehicle_flyby(entity, alias_name, distance_threshold, print_distance_, dist3d_)
{
	assert(IsDefined(entity));
	assert(IsDefined(alias_name));
	assert(IsDefined(distance_threshold));
	
	debug_print = false;
	if (IsDefined(print_distance_))
		{
			debug_print = print_distance_;
		}

	distance3D = false;
	if (IsDefined(dist3d_))
		{
			distance3D = dist3d_;
		}

	while(isdefined(entity))
	{
			if (distance3D)
			{
				dist = Distance( entity.origin, level.player.origin ); //Test to see if vehicle is within range of player
			}
			else
			{
				dist = Distance2D( entity.origin, level.player.origin ); //Test to see if vehicle is within range of player				
			}

			if (debug_print)
			{
				//iprintln("Distance: " + dist);
			}
							
			if ( dist < distance_threshold )  //If vehicle is within range of player, play the flyby sound
			{
				flyby_ent = spawn("script_origin", entity.origin);
				flyby_ent linkto( entity );
				flyby_ent playsound(alias_name, "sounddone");
				flyby_ent thread waittill_deathspin(entity);
				flyby_ent thread waittill_sounddone();
				flyby_ent waittill("flyby_ent", whathappened);

				if (whathappened == "deathspin")  //If vehicle is shot down then play explosion sound ad stop the flyby sound 
				{
					hind_explo = spawn("script_origin", flyby_ent.origin);
					hind_explo playsound("skybattle_hind_rocket_imp");

					flyby_ent scalevolume(0.0, 0.3);
					wait(0.4);
					flyby_ent stopsounds();
					flyby_ent delete();
					wait 1.0;
					hind_explo Delete();
					return;
				}
				else if (whathappened == "sounddone") //Cleanup if flyby sound completes without vehicle being shot down
				{
					wait(0.1);
					flyby_ent delete();
					return;
				}
			}
			
			else
			{
				wait(0.05);
			}
	}

}


/********************************************************************
	Russian Sub Audio System.
********************************************************************/

aud_russian_sub_start()
{
	flag_wait("russian_sub_spawned");
	//iprintlnbold("AUDIO: START RUSSIAN SUB");	
	thread aud_propeller_cone(3, 2, 5, 0.25);
	thread aud_russian_sub_se_pings();
	// start priming sub_move
	sub_move = spawn("script_origin", level.player.origin);
	sub_move aud_prime_stream("russian_sub_travel_fronts");

	wait(2); 	// play sub_move
	thread MM_add_submix("nyhb_russian_sub_by");
	thread DAMB_stop_zone(3);
	isprimed = sub_move aud_is_stream_primed("russian_sub_travel_fronts");
	assert(isprimed);
	sub_move playsound("russian_sub_travel_fronts");
	music_cue("mus_sub_passby");
	thread aud_play_sub_groans();

	wait(18.5);	// start priming sub_passby
	sub_passby = spawn("script_origin", level.player.origin);
	sub_passby aud_prime_stream("russian_sub_passby_fronts");

	wait(2); 	// play sub_passby
	isprimed = sub_passby aud_is_stream_primed("russian_sub_passby_fronts");
	assert(isprimed);
	sub_passby playsound("russian_sub_passby_fronts");

	wait(22.5);
	MM_clear_submix("nyhb_russian_sub_by", 3);
	sub_move delete();
	//sub_creaks delete();
	sub_passby delete();	
}

aud_barracks_sandman_opening_door()
{
	flag_wait("barracks_sandman_opening_door");
	MM_clear_submix("sub_entry", 2);
}

aud_play_sub_groans()
{
	wait(9);
	level.player playsound("metal_groans_deep_harb_sub");
	wait(3);
	level.player playsound("harb_sub_stress_sub_by");
	level.player playsound("russian_sub_big_groan");
}


aud_russian_sub_single_ping()
{
	level.player playsound("russian_sub_sonar_ping_dist");
}

aud_russian_sub_se_pings()
{
	wait(5);
	level.player playsound("russian_sub_sonar_ping_rear");
	wait(3);
	level.player playsound("russian_sub_sonar_ping_rear");
	wait(14);
	level.player playsound("russian_sub_sonar_ping_front");
	wait(3);
	level.player playsound("russian_sub_sonar_ping_front");
}

aud_force_cone_to_min(min_volume)
{
	for(;;)
	{
		level.aud.cone_sound scalevolume(min_volume, 0.05);
		if (level.flag["aud_engine_fade_out"])
			return;
		wait(0.05);
	}
}

aud_propeller_cone(fade_in_time_, fade_out_time_, turn_off_time_, min_volume_)
{
	if (!IsDefined(level.sdv_player_arms))
		return;
		
	// turn on the loops
	assert(!isdefined(level.aud.cone_sound));
	level.aud.cone_sound = spawn("script_origin", (0,0,0));
	level.aud.cone_sound.is_playing = false;
	level.aud.cone_sound.name = "russian_sub_propellor_wake";
	
	assert(!isdefined(level.aud.omni_sound));
	level.aud.omni_sound = spawn("script_origin", (0,0,0));
	level.aud.omni_sound.is_playing = false;
	level.aud.omni_sound.name = "russian_sub_engine_rumble";
	
	fade_in_time = 1.0;
	if (IsDefined(fade_in_time_))
	{
		fade_in_time = fade_in_time_;
	}	
	fade_out_time = 1.0;
	if (IsDefined(fade_out_time_))
	{
		fade_out_time = fade_out_time_;
	}
	
	min_volume = 0.0;
	if (IsDefined(min_volume_))
	{
		min_volume = min_volume_;
	}
	
	// monitor loop (syncronous)
	aud_propeller_cone_monitor(fade_in_time, fade_out_time, min_volume);
	
	turn_off_time = 5.0;
	if (IsDefined(turn_off_time_))
	{
		turn_off_time = turn_off_time_;
	}

	// cleanup entities when done	
	flag_wait("aud_engine_stop_monitor");
	wait(5.0);
	level.aud.cone_sound unlink(); 
	level.aud.omni_sound unlink();
	wait(0.05);
	
	level.aud.cone_sound LinkTo(level.sdv_player_arms, "tag_player");
	level.aud.omni_sound LinkTo(level.sdv_player_arms, "tag_player");
	
	flag_wait("aud_engine_fade_out");
	level.aud.cone_sound setvolume(0.0, turn_off_time);
	level.aud.omni_sound setvolume(0.0, turn_off_time);
	wait(turn_off_time + 0.05);
	level.aud.cone_sound delete();
	level.aud.omni_sound delete();
}

aud_get_prop_sound_origin()
{
	if (!IsDefined(level.russian_sub_02))
		return;
		
	sound_origin = undefined;
	sub = level.russian_sub_02;
		
	left_prop_origin = sub GetTagOrigin("tag_left_porpeller");
	left_prop_angles = sub GetTagAngles("tag_left_porpeller");
	left_prop_forward = AnglesToForward(left_prop_angles);
	
	right_prop_origin = sub GetTagOrigin("tag_right_propeller");
	right_prop_angles = sub GetTagAngles("tag_right_propeller");
	
	// figure out where to place the sound ent.
	player_to_left_prop = level.player.origin - left_prop_origin;
	player_to_right_prop = level.player.origin - right_prop_origin;
	left_to_right_prop = left_prop_origin - right_prop_origin;

	// figure out if we are in front or behind the props
	player_to_prop_forward = VectorDot(player_to_left_prop, left_prop_forward);
	if (player_to_prop_forward > 0)
	{
		self.is_in_cone = false;
	}
	else
	{
		self.is_in_cone = true;
	}

	// figure out sound position
	left_to_right_prop = vectornormalize(left_to_right_prop);
	p2l_dot_l2r = VectorDot(player_to_left_prop, left_to_right_prop);
	p2r_dot_l2r = VectorDot(player_to_right_prop, left_to_right_prop);
	
	if (p2l_dot_l2r > 0 && p2r_dot_l2r > 0) // on right side, so play sound on right prop
	{
		sound_origin = left_prop_origin;
	}
	else if (p2l_dot_l2r < 0 && p2r_dot_l2r < 0) // on left side, so play sound on left prop
	{
		sound_origin = right_prop_origin;
	}
	else // somewhere in the middle, so play sound somewhere in middle
	{
		dist_l2r = distance(left_prop_origin, right_prop_origin);
		sound_origin = left_prop_origin + p2l_dot_l2r * left_to_right_prop;
	}
	
	self.sound_origin = sound_origin;
	
	assert(IsDefined(self.is_in_cone));
	assert(IsDefined(self.sound_origin));
}

aud_propeller_cone_monitor(fade_in_time, fade_out_time, min_volume)
{
	assert(IsDefined(level.aud.omni_sound));
	assert(IsDefined(level.aud.cone_sound));
	
	level endon("aud_stop_sub_propeller");
	
	current_volume = 0;
	
	for(;;)
	{
		if (!IsDefined(level.russian_sub_02))
			return;

		if (IsDefined(level.flag["aud_planting_submine"]) && level.flag["aud_planting_submine"])
		{
			thread aud_force_cone_to_min(min_volume);
			return;
		}

		results = spawnstruct();
		results aud_get_prop_sound_origin();
		
		assert(IsDefined(results.is_in_cone));
		assert(IsDefined(results.sound_origin));
		
		if (results.is_in_cone)
		{
			// play sound if not already playing
			if (!level.aud.cone_sound.is_playing)
			{
				level.aud.cone_sound.is_playing = true;
				level.aud.cone_sound.origin = results.sound_origin;
				level.aud.cone_sound playloopsound(level.aud.cone_sound.name);
				level.aud.cone_sound ScaleVolume(0.0);
				wait(0.05);
				current_volume = 0;
			}
			else
			{
				if (current_volume == 0)
				{
					current_volume = 1;
					level.aud.cone_sound setvolume(1.0, fade_in_time);
				}
			}
		}
		else
		{
			// stop sound if it is playing
			if (current_volume == 1)
			{
				current_volume = 0;
				level.aud.cone_sound setvolume(min_volume, fade_out_time);
			}
		}
		
		if (!level.aud.omni_sound.is_playing)
		{
			level.aud.omni_sound.is_playing = true;
			level.aud.omni_sound.origin = results.sound_origin;
			level.aud.omni_sound playloopsound(level.aud.omni_sound.name);
		}
				
		level.aud.omni_sound moveto(results.sound_origin, 0.1);
		level.aud.cone_sound moveto(results.sound_origin, 0.1);
		
		wait(0.1);
	}
}

aud_player_sub_surface_breach()
{
	wait(7);
	// start priming surface breach stream
	surface_breach = spawn("script_origin", level.player.origin);
	surface_breach aud_prime_stream("surface_breach_fronts");
	thread MM_add_submix("nyhb_surface_breach_se");

	flag_set("aud_engine_fade_out");

	wait(4.2); 	// play surface breach stream
	isprimed = surface_breach aud_is_stream_primed("surface_breach_fronts");
	assert(isprimed);
	surface_breach playsound("surface_breach_fronts");

	wait(5.2);	// play player breach
	level.player playsound("plyr_surface_breach_fronts");

	wait(7.4); 	// play sub_breach
	level.player playsound("sub_surface_breach_fronts");

	wait(4.2); 	// play sub_breach_lfe
	level.player playsound("sub_surface_breach_lfe");

	wait(11.5);	// clear mix
	MM_clear_submix("nyhb_surface_breach_se", 4);
	
	wait(10.5); // cleanup
	surface_breach delete();

}

aud_do_sub_scuttle_bombshake()
{
	// Prime the sound.
	ent = spawn("script_origin", level.player.origin);
	ent thread aud_prime_stream("sub_scuttle_explosion", true, 0.1);
	
	// Wait for it to be buffered.
	wait(0.5);
	
	// Play the sound.
	ent playsound("sub_scuttle_explosion"); //ent playsound("sub_scuttle_explosion", "sounddone");
	
	// Release the priming.
	ent aud_release_stream("sub_scuttle_explosion");
	
	// Do the screen shake.
	Earthquake( 0.3, 3, level.player.origin, 850 );
	
	// Clean up.
	wait(12); //ent waittill("sounddone");
	wait(0.1);
	ent delete();
}

aud_play_skybattle_dist_jet(ent, end_point, flight_time)
{
	level endon("aud_notify_inside_sub");
	ent PlaySound("skybattle_dist_jet", "sounddone");
	ent MoveTo(end_point, flight_time);
	ent waittill("sounddone");
}

aud_play_mine_beep()
{	
	if (!IsDefined(level.aud.mine_setup))
	{
		thread aud_setup_minewarn();
	}
	pitch = level.aud.mine_pitch;
	for(i = 0; i < level.aud.mine_beep_count; i++)
	{
		level.aud.mine_ents[i] playsound("veh_mine_beep");
		level.aud.mine_ents[i] setpitch(pitch);
		wait(0.1);
	}
}

aud_setup_minewarn()
{
	level.aud.mine_setup = true;
	level.aud.mine_beep_count = 1;
	level.aud.mine_min_dist = 2.0;
	level.aud.curr_dist = 2.0;
	level.aud.mine_max_num_beeps = 3;
	max_pitch_up = 0.3;
	
	level.aud.mine_pitch_env = [
		[0.0, 1.2],
		[0.2, 1.1],
		[0.7, 1.0],
		[1.0, 1.0],
		[2.0, 1.0]
	];
	
	level.aud.mine_pitch = 1.0;
	
	level.aud.mine_ents = [];
	for (i = 0; i < level.aud.mine_max_num_beeps; i++)
	{
		level.aud.mine_ents[i] = spawn("script_origin", level.player.origin);
		level.aud.mine_ents[i] linkto(level.player);
	}
	
	level waittill("aud_stop_minewarn_loop");
	
	for (i = 0; i < level.aud.mine_max_num_beeps; i++)
	{
		level.aud.mine_ents[i] delete(); 
	}
}

aud_minewarn(curr_dist)
{
	if (!IsDefined(level.aud.mine_setup))
	{
		aud_setup_minewarn();
	}
	
	if ( curr_dist != level.aud.curr_dist)
	{
		//iprintlnbold("curr_dist: " + curr_dist);
		level.aud.curr_dist = curr_dist;
		min_dist = level.aud.mine_min_dist;
		max_num_beeps = level.aud.mine_max_num_beeps;
		level.aud.mine_pitch = aud_map2(curr_dist, level.aud.mine_pitch_env);
	}
}

aud_slava_missile_launch(missile)
{
	if (!flag("aud_flag_inside_sub"))
	{
		thread play_sound_in_space("distant_slava_missile_launch", missile.origin);
		wait(0.3);
		thread aud_play_linked_sound("distant_slava_missile_travel", missile, "oneshot");
		
		ent = spawn("script_origin", missile.origin);	
		ent linkto(missile);
		ent PlaySound("distant_slava_missile_whistle_oneshot");
		target_pitch	= RandomFloatRange(0.5, 0.9);
		target_time		= RandomFloatRange(3, 9);
		ent SetPitch(target_pitch, target_time);
		
		missile waittill("death");
		ent StopSounds();
		ent delete();
	}
}

aud_play_harb_slowmo_impact(weapontype, damage, attacker, point, type)
{
	level.player playsound("slowmo_bullet_whoosh");	
}

aud_play_harb_slowmo_gunshot(weapontype)
{
	switch(weapontype)
	{
		default:
			//iprintlnbold("AUDIO:  SLOWMO GUN FIRE");
		break;
	}
}

aud_play_harb_door_breach_impact(weapontype, damage, attacker, point, type)
{
	if ( !IsDefined(level.aud.last_db_time))
	{
		level.aud.last_db_time = 0;
	}
	current_time = GetTime();
	if (current_time - level.aud.last_db_time > 200)
	{
		level.aud.last_db_time = current_time;
		level.player playsound("db_bullet_whoosh");	
	}
}

aud_play_harb_door_breach_gunshot(weapontype)
{
	switch(weapontype)
	{
		default:
			//iprintlnbold("AUDIO:  SLOWMO GUN FIRE");
		break;
	}
}
