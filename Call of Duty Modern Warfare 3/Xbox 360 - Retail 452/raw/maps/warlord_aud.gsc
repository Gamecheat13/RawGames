#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_audio;
#include maps\_audio_zone_manager;
#include maps\_audio_music;
#include maps\_audio_mix_manager;
#include maps\_audio_dynamic_ambi;

main()
{
	/********************************************************************
		Init System
	********************************************************************/
	aud_set_level_fade_time(0);
	aud_init();
	aud_config();

	/********************************************************************
		Init Level
	********************************************************************/
	aud_init_level_globals();
	aud_init_level_flags();
	aud_launch_level_threads();
	MM_add_submix("warl_level_global_mix");
	
	/********************************************************************
		LAST THING: Register Level Audio Message Handler Function.
	********************************************************************/
	aud_register_msg_handler(::warlord_aud_msg_handler);
	aud_register_msg_handler(::music_msg_handler);
}

/*********************************************************************
	Level Init Support Functions.
********************************************************************/
aud_precache_presets()
{
	MM_precache_preset("warl_level_global_mix");
	MM_precache_preset("warl_level_start");
	MM_precache_preset("warl_swamp_footsteps_shallow");
	MM_precache_preset("warl_swamp_npc_footsteps_shallow");
	MM_precache_preset("warl_swamp_footsteps_deep");
	MM_precache_preset("warl_swamp_npc_footsteps_deep");
	MM_precache_preset("warl_jungle_river");
	MM_precache_preset("warl_jungle_path");
	MM_precache_preset("warl_shanty_town");
	MM_precache_preset("warl_shanty_town_dense");
	MM_precache_preset("warl_player_tech_shoot");
	MM_precache_preset("warl_player_tech_explode");
	MM_precache_preset("warl_mortar_run");
	MM_precache_preset("warl_shanty_town_mortar_run");
	MM_precache_preset("warl_shanty_town_mortar_tower");
	MM_precache_preset("warl_sewer_pipe");
	MM_precache_preset("warl_house_town_dense");
	MM_precache_preset("warl_churchtown");
	MM_precache_preset("warl_churchtown_church");
	MM_precache_preset("warl_finale");
}

aud_config()
{
	set_stringtable_mapname("shg");
	aud_set_occlusion("soft_occlusion"); // new way to do it, which uses string tables
	aud_set_timescale();
	aud_SetAllTimeScaleFactors(0);
}

aud_init_level_globals()
{
	level.aud = SpawnStruct();
	level.aud.mi17_playing = false;
	level.aud.player_height_start = -174;
	aud_create_envelopes();
}
	
aud_launch_level_threads()
{
	if (!IsDefined(level.aud.launch_level_threads))	// Make sure this happens only once.
	{
		level.aud.launch_level_threads = true;
		
		// Launch positional DAMBs.
		aud_start_positional_dambs();
		aud_start_fire_dambs();
		
		// Launch emitter loops.
		aud_start_loops();
		
		// Misc threads.
		thread aud_prepare_church_breach();
		//thread aud_snoring_guard();

		// Music threads to handle flags init through radiant trigger (for consitient msg handling).
		// OBSOLETE thread mus_water_tunnel();
		thread mus_house_shootout();
		thread mus_down_the_street();
	}
}

aud_create_envelopes()
{
	level.aud.envs["veh_drive_vol"]	=	[
											[0.000,  0.000],
											[0.050,  0.100],
											[0.100,  0.100],
											[0.200,  0.200],
											[0.300,  0.300],
											[0.400,  0.400],
											[0.500,  0.500],
											[0.600,  0.600],
											[0.800,  0.800],
											[1.000,  1.000]
										]; 

	level.aud.envs["veh_idle_vol"]	=	[
											[0.000,  1.000],
											[0.050,  0.850],
											[0.100,  0.600],
											[0.200,  0.500],
											[0.300,  0.400],
											[0.400,  0.100],
											[0.500,  0.000],
											[0.600,  0.000],
											[0.800,  0.000],
											[1.000,  0.000]
										]; 

	level.aud.envs["veh_gravel_vol"]	=	[
											[0.000,  0.000],
											[0.050,  0.250],
											[0.100,  0.500],
											[0.200,  0.750],
											[0.300,  1.000],
											[1.000,  1.000]
										];

	level.aud.envs["mi17_fake_scale"]	=	[
											[0.000,  1.000],
											[0.050,  0.800],
											[0.100,  0.600],
											[0.200,  0.500],
											[0.300,  0.400],
											[0.400,  0.300],
											[0.500,  0.300],
											[0.600,  0.200],
											[0.800,  0.100],
											[1.000,  0.000]
										];
}

aud_init_level_flags()
{
	flag_init("player_breach");
	flag_init( "aud_infiltrate_encounter_1" );
	flag_init("kill_sleeping_guard");
	flag_init( "aud_warlord_player_breach" );
	flag_init("player_using_mortar");
	flag_init("aud_grass_hide");
	flag_init("aud_river_big_moment_end");
	flag_init("aud_player_using_tech_turret");
	flag_init("aud_mortar_slowmo");
	flag_init("snoring_guard_dead");
	flag_init("aud_fake_mortar_exploded");
	flag_init("inside_prechurch_burnthouse");
	flag_init("mi17_flyby");
	flag_init("aud_finale_all_clear");
	flag_init("aud_first_heli_deleted");
	flag_init("aud_second_heli_spawned");
}

/********************************************************************
	Level Audio Message Handler Function.
********************************************************************/
warlord_aud_msg_handler(msg, args)
{
	msg_handled = true;
	
	switch(msg)
	{
		/*******************************/
		/***** CHECKPOINT HANDLERS *****/
		/*******************************/

		case "start_stealth_intro":
		{
			/#
			// This happens at start up and is only here for dev checkpoint-starts.
			aud_level_fadein();
			#/
			MM_add_submix("warl_level_start", 0);
			music_cue("mus_intro");
			wait(2.5);
			aud_play_2d_sound("warl_intro_player_emerge_start");
			wait(0.8);
			aud_play_2d_sound("warl_intro_player_emerge");
			thread aud_warl_start_river_rain_drops(3);
			wait(1);
			AZM_start_zone("warl_jungle_river");
			mm_clear_submix("warl_level_start",3);
			
			thread aud_warl_monitor_water_footsteps();
			thread aud_warl_monitor_npc_water_footsteps();
		}
		break;

		case "start_river_big_moment":
		{
			AZM_start_zone("warl_jungle_path");
			music_cue("mus_river_first_encounter_all_clear");
		}
		break;
		
		case "start_infiltration":
		{
			AZM_start_zone("warl_jungle_path");
			music_cue("mus_bridge_guys_dead");
		}
		break;

		case "start_advance":
		{
			AZM_start_zone("warl_shanty_town_exterior");
			music_cue("mus_go_hot");
		}
		break;

		case "start_technical":
		{
			AZM_start_zone("warl_shanty_town_exterior_dense");
			music_cue("mus_to_technical");
		}
		break;

		case "start_mortar_run":
		{
			AZM_start_zone("warl_shanty_town_exterior_sparse");
			music_cue("mus_mortar_inbound");
			MM_add_submix("warl_mortar_run", 0.3);
		}
		break;

		case "start_player_mortar":
		{
			AZM_start_zone("warl_shanty_town_exterior_sparse_mortar_tower");
			music_cue("mus_player_mortar");
		}
		break;

		case "start_assault":
		{
			AZM_start_zone("warl_shanty_town_exterior_sparse_mortar_tower");
			music_cue("mus_player_mortar_done");
		}
		break;

		case "start_super_technical":
		{
			AZM_start_zone("warl_house_prechurchzone_burnt");
			music_cue("mus_shoulder_charge_door");
		}
		break;

		case "start_player_breach":
		{
			AZM_start_zone("warl_churchtown_church_mainroom_interior");
			music_cue("mus_pre_church_door_breach"); 
		}
		break;
		
		/***********************************/
		/***** AWESOME TRIGGER HANDLERS ****/
		/***********************************/
		
		//Blend Trigger:  warl_jungle_river warl_jungle_river_shallow
		
		case "enter_warl_jungle_river_shallow":
		{
		    zone_from = args;
		    if (zone_from == "warl_jungle_river")
			{
				level notify("aud_warl_stop_river_rain_drops");
			}
		}
		break;
		
		case "exit_warl_jungle_river_shallow":
		{
		    zone_to = args;
		    if (zone_to == "warl_jungle_river")
			{
				thread aud_warl_start_river_rain_drops(3);
			}
		}
		break;  
		
		//Blend Trigger:  warl_jungle_river_shallow warl_jungle_path
		
		case "enter_warl_jungle_path":
		{
		    zone_from = args;
		    if (zone_from == "warl_jungle_river_shallow")
			{
				thread aud_warl_stop_monitor_water_footsteps();
				thread aud_warl_stop_npc_monitor_water_footsteps();
			}
		}
		break;
		
		case "exit_warl_jungle_path":
		{
		    zone_to = args;
		    if (zone_to == "warl_jungle_river_shallow")
			{
				thread aud_warl_monitor_water_footsteps();
				thread aud_warl_monitor_npc_water_footsteps();
			}
		}
		break;               
		
		//Blend Trigger:  warl_jungle_path warl_shanty_town_exterior
		
		case "enter_warl_shanty_town_exterior":
		{
			zone_from = args;
		}
		break;
		
		case "exit_warl_shanty_town_exterior":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: warl_shanty_town_exterior warl_stone_wherehouse
		
		case "enter_warl_stone_wherehouse":
		{
			zone_from = args;
		}
		break;
		
		case "exit_warl_stone_wherehouse":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: warl_shanty_town_exterior warl_shanty_town_exterior_dense
		
		case "enter_warl_shanty_town_exterior_dense":
		{
			zone_from = args;
		}
		break;
		
		case "exit_warl_shanty_town_exterior_dense":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: warl_shanty_town_exterior_dense warl_shanty_town_exterior_sparse
		
		case "enter_warl_shanty_town_exterior_sparse":
		{
			zone_from = args;
		}
		break;
		
		case "exit_warl_shanty_town_exterior_sparse":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: warl_shanty_town_exterior_dense warl_shanty_town_interior_dense_shanty_01
		
		//Blend Trigger: warl_shanty_town_exterior_sparse warl_shanty_town_exterior_dense_mortarrun

		case "enter_warl_shanty_town_exterior_dense_mortarrun":
		{
			zone_from = args;
		}
		break;
		
		case "exit_warl_shanty_town_exterior_dense_mortarrun":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: warl_shanty_town_exterior_dense_mortarrun warl_shanty_town_exterior_sparse_mortar_tower
		
		case "enter_warl_shanty_town_exterior_sparse_mortar_tower":
		{
			zone_from = args;
		}
		break;
		
		case "exit_warl_shanty_town_exterior_sparse_mortar_tower":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: warl_shanty_town_exterior_sparse_mortar_tower warl_sewer_pipe
		
		case "enter_warl_sewer_pipe":
		{
			zone_from = args;
			if (zone_from == "warl_shanty_town_exterior_sparse_mortar_tower")
			{
				aud_send_msg("mus_enter_sewer_pipe");
				thread aud_warl_start_sewer_pipe_interiorflow(1);
			}
		}
		break;
		
		case "exit_warl_sewer_pipe":
		{
			zone_to = args;
			if (zone_to == "warl_shanty_town_exterior_sparse_mortar_tower")
			{
				level notify("aud_warl_stop_sewer_pipe_interiorflow");
			}
		}
		break;
		
		//Blend Trigger: warl_sewer_pipe warl_house_town_dense
		
		case "enter_warl_house_town_dense":
		{
			zone_from = args;
			if (zone_from == "warl_sewer_pipe")
			{
				aud_send_msg("mus_exit_sewer_pipe");
				level notify("aud_warl_stop_sewer_pipe_interiorflow");
			}
		}
		break;
		
		case "exit_warl_house_town_dense":
		{
			zone_to = args;
			if (zone_to == "warl_sewer_pipe")
			{
				thread aud_warl_start_sewer_pipe_interiorflow(1);
			}
		}
		break;
		
		//Blend Trigger: warl_house_town_dense warl_werehouse_brick
		
		case "enter_warl_werehouse_brick":
		{
			zone_from = args;
			if (zone_from == "warl_house_town_dense")
			{
				aud_stop_tunnel_dambs();
			}
		}
		break;
		
		case "exit_warl_werehouse_brick":
		{
			zone_to = args;
			if (zone_to == "warl_house_town_dense")
			{
				aud_start_tunnel_dambs();
			}
		}
		break;
		
		//Blend Trigger: warl_werehouse_brick warl_house_town_dense_02
		
		case "enter_warl_house_town_dense_02":
		{
			zone_from = args;
		}
		break;
		
		case "exit_warl_house_town_dense_02":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: warl_house_town_dense_02 warl_house_shanty_interior_01
		
		case "enter_warl_house_shanty_interior_01":
		{
			zone_from = args;
		}
		break;
		
		case "exit_warl_house_shanty_interior_01":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: warl_house_town_dense_02 warl_house_prechurchzone_burnt
		
		case "enter_warl_house_prechurchzone_burnt":
		{
			zone_from = args;
			flag_set("inside_prechurch_burnthouse");
			if( !is_specialop() )
			{
				thread mi17_circle_overhead();
			}
		}
		break;
		
		case "exit_warl_house_prechurchzone_burnt":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: warl_house_prechurchzone_burnt warl_churchtown_exterior_dense
		
		case "enter_warl_churchtown_exterior_dense":
		{
			zone_from = args;
		}
		break;
		
		case "exit_warl_churchtown_exterior_dense":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: warl_churchtown_exterior_dense warl_churchtown_farmshop_interior
		
		//Blend Trigger: warl_churchtown_exterior_dense warl_churchtown_butchershop_interior
		
		//Blend Trigger: warl_churchtown_exterior_dense warl_churchtown_pharmacy_interior
		
		//Blend Trigger: warl_churchtown_exterior_dense warl_churchtown_church_mainroom_interior
		
		case "enter_warl_churchtown_church_mainroom_interior":
		{
			zone_from = args;
		}
		break;
		
		case "exit_warl_churchtown_church_mainroom_interior":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: warl_churchtown_church_mainroom_interior warl_churchtown_church_hallway_interior
		
		//Blend Trigger: warl_churchtown_church_hallway_interior warl_churchtown_church_dogroom
		
		case "enter_warl_churchtown_church_dogroom":
		{
			zone_from = args;
		}
		break;
		
		case "exit_warl_churchtown_church_dogroom":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: warl_churchtown_courtyard_exterior warl_churchtown_church_mainroom_interior
			
		/*****************************/
		/******* EVENT HANDLERS ******/
		/*****************************/
		
		case "door_open_slow":
		{
					assert(isdefined(args) && isdefined(args[0]));
					door = args[0];
					alias = args[1];

				if(isdefined(alias))
				{ 
					door playsound(alias);
				}
				else
				{
					door playsound("warl_se_dooropen1_02");
				}
		}
		break;
		
		case "door_open_slow_wide":
		{
					assert(isdefined(args) && isdefined(args[0]));
					door = args[0];
					alias = args[1];

				if(isdefined(alias))
				{ 
					door playsound(alias);
				}
				else
				{
					door playsound("warl_se_dooropen1_02");
				}
		}
		break;
					
		case "fx_dragonfly_flyby":
		{
			// Set up dragonfly sound params.
			start_point	= args[0];
			end_point	= args[1];
			flight_time	= args[2];
			yards		= distance(level.player.origin, start_point)/36.0;
			
			// Create an ent on which to play the sound, faking it on the VFX (which is not an ent).
			ent = spawn("script_origin", start_point);
			
			//iprintlnbold(">>>>>>>>>> fx_dragonfly_flyby, flight_time: " + flight_time + " yards: " + yards);

			// Play dragonfly sound.		
			ent PlayLoopSound("insect_dragonfly_single_01_lp");
			//ent ScaleVolume(2, 0.05);
			ent MoveTo(end_point, flight_time);
			wait(flight_time);
	
			// Clean up.
			ent ScaleVolume(0.0, 3);
			wait(0.5);
			ent delete();
		}
		break;		

		/****************************/
		/*** Intro River Section ***/
		/***************************/		
		case "intro_river_technicals":
		{
			tech_1 = args[0];
			tech_2 = args[1];
			
			instance_name = "intro_river_technical_01";
			instance_name_02 = "intro_river_technical_02";
			
			move_loop = "tech_drive_slow_lp";
			roll_loop = "tech_sus_bounce_fast_river_intro";
			idle_loop = "tech_idle_hi";
			gravel_loop= undefined;
				
			tech_1 thread aud_tech_loops(instance_name, move_loop, roll_loop, idle_loop, gravel_loop);
			//tech_2 thread aud_tech_loops(instance_name_02);
			
			L_pos = spawn("script_origin",(2053, -1448, 10));
			R_pos = spawn("script_origin",(2736, -1896, 92));
			
			L_pos playsound("tech_river_01_L", "sounddone");
			R_pos playsound("tech_river_01_R", "sounddone");
			
			flag_wait("river_technical_stopped");
			
			//tech_1 waittill("stealth_broken_unload");
			
			aud_fade_out_and_delete(L_pos, 3);
			aud_fade_out_and_delete(R_pos, 3);
		}
		break;	
			
		case "super_technical":	// First to spawn at river big moment; spawned up in front, away from player.
		{
			tech_1 = args;
			instance_name = "super_technical";
			
			move_loop = "tech_drive_slow_lp";
			roll_loop = "tech_dirt_roll_lp";
			idle_loop = "tech_idle_hi";
			gravel_loop = undefined;
			
			tech_1 thread aud_tech_loops(instance_name, move_loop, roll_loop, idle_loop, gravel_loop);
		}
		break;
	
		case "technical_1":
		{	
			// Can't find this one anymore...was it cut?
		}
		break;
		
		case "technical_2":	// Second one spawn at river big moment; first one to pass by player on road in, second one to pass on way out.
		{			
			tech_1 = args;
			assert(IsDefined(tech_1));
			
			// Save the technical entity so we can switch the rap music to it later.
			level.aud.rbm_tech2 = tech_1;
			
			instance_name = "technical_2";
			
			L_pos = spawn("script_origin", (1098, 2150, 110));
			R_pos = spawn("script_origin", (2088, 2071, -1));
		
			move_loop = "tech_drive_slow_lp";
			roll_loop = "tech_dirt_roll_lp";
			idle_loop = "tech_idle_hi";
			gravel_loop = "tech_gravel_lp";
				
			tech_1 thread aud_tech_loops(instance_name, move_loop, roll_loop, idle_loop, gravel_loop);
			
			L_pos playsound("tech_dist_river_L", "sounddone");
			R_pos playsound("tech_dist_river_R", "sounddone");
			
			tech_1 waittill("stealth_broken_unload");
			
			aud_fade_out_and_delete(L_pos, 3);
			aud_fade_out_and_delete(R_pos, 3);
		
		}
		break;
			
		// Third one spawn at river big moment; 
		// second one to pass by player on road in, first one to pass on way out.
		// However, it gets despawned after it passes the player.
		case "river_technical_01": 
		{
			tech_1 = args;
			assert(IsDefined(tech_1));
			
			// Play rap on this one, then link it to the other one when this one despawns.
			thread aud_play_rap_on_technical(tech_1);
			
			instance_name = "river_technical_01";
			
			L_pos = spawn("script_origin",(456, 1940, 53));
			R_pos = spawn("script_origin",(1757, 2039, 53));
		
			move_loop = "tech_drive_slow_lp";
			roll_loop = "tech_dirt_roll_lp";
			idle_loop = "tech_idle_hi";
			gravel_loop = "tech_gravel_lp";
				
			tech_1 thread aud_tech_loops(instance_name, move_loop, roll_loop, idle_loop, gravel_loop);
			
			L_pos playsound("tech_river_01_L", "sounddone");
			R_pos playsound("tech_river_01_R", "sounddone");
			
			tech_1 waittill("stealth_broken_unload");
			
			aud_fade_out_and_delete(L_pos, 2);
			aud_fade_out_and_delete(R_pos, 2);
		}
		break;
				
		case "river_prone_encounter":
		{
		}
		break;

		case "river_big_moment_second_beat":
		{
			flag_set("aud_grass_hide");
			flag_wait("aud_river_big_moment_end");
			flag_clear("aud_grass_hide");
		}
		break;
		
		case "river_big_moment_end":
		{
			flag_set("aud_river_big_moment_end");
		}
		break;
	
		case "river_driveby_technical":
		{
			// Drives close to the player out of sight.
		}
		break;
		
		case "bridge_technical":
		{			
			tech_1 = args;
			instance_name = "bridge_technical";
			
			L_pos = spawn("script_origin",(2268, 4116, 90));
			R_pos = spawn("script_origin",(3682, 4039, 90));
		
			move_loop = "tech_drive_slow_lp";
			roll_loop = "tech_dirt_roll_lp";
			idle_loop = "tech_idle_hi";
			gravel_loop = undefined;
				
			tech_1 thread aud_tech_loops(instance_name, move_loop, roll_loop, idle_loop, gravel_loop);
			
			L_pos playsound("tech_bridge_by_L", "sounddone");
			R_pos playsound("tech_bridge_by_R", "sounddone");
			
			tech_1 waittill("stealth_broken_unload");
			
			aud_fade_out_and_delete(L_pos, 2);
			aud_fade_out_and_delete(R_pos, 2);
		}
		break;
		
/**********************************/
/******** Player Technical ********/
/**********************************/

		case "player_technical_splashdown":
		{
			position = args;
			aud_play_2d_sound("warl_jump_splashdown");
		}
		break;

		case "player_technical":
		{
			// Technical that is manned by Yuri.
			tech_1 = args;
			
			instance_name = "player_technical";
			
			move_loop = "tech_drive_slow_lp";
			roll_loop = "tech_sus_bounce_fast";
			idle_loop = "tech_idle_hi";
			gravel_loop = undefined;
			
			tech_1 thread aud_tech_loops(instance_name, move_loop, roll_loop, idle_loop, gravel_loop);
					
			flag_wait( "player_technical_drivein" );
			
			aud_play_linked_sound("tech_player_inc_os", tech_1);		
		}
		break;
		
		case "player_using_tech_turret":
		{
			flag_set("aud_player_using_tech_turret");
			MM_add_submix("warl_player_tech_shoot", 0);
		}
		break;
		
		case "arena_technical_01":
		{
			tech_1 = args;
			tech_1 thread aud_tech_explode_watch();
			
			instance_name = "arena_technical_01";
			
			L_pos = spawn("script_origin",(2268, 4116, 90));
			R_pos = spawn("script_origin",(3321, 3739, 90));
		
			move_loop = "tech_dirt_roll_fast";
			roll_loop = "tech_sus_bounce_fast";
			idle_loop = "tech_idle_hi";
			gravel_loop = undefined;
				
			//tech_1 thread aud_tech_loops(instance_name, move_loop, roll_loop, idle_loop);
			tech_1 playsound("tech_arena_01_inc_os");
			//L_pos playsound("tech_river_01_L", "sounddone");
			//R_pos playsound("tech_river_01_R", "sounddone");
			
			tech_1 waittill("stealth_broken_unload");
			
			aud_fade_out_and_delete(L_pos, 2);
			aud_fade_out_and_delete(R_pos, 2);
		}
		break;
		
		case "arena_technical_02":
		{
			tech_1 = args;
			tech_1 thread aud_tech_explode_watch();
			
			instance_name = "arena_technical_02";
			
			move_loop = "tech_dirt_roll_fast";
			roll_loop = "tech_sus_bounce_fast";
			idle_loop = "tech_idle_hi";
			gravel_loop = undefined; 
				
			//tech_1 thread aud_tech_loops(instance_name, move_loop, roll_loop, idle_loop);
			tech_1 playsound("tech_arena_02_inc_os");
		}
		break;
		
/****************************/
/******** Mortar Run ********/
/***************************/

		case "tech_mortar_incoming":
		{
			flag_set("aud_mortar_slowmo");
			thread aud_turret_mortar_slowmo_setup();
		}
		break;

		case "player_turret_destroyed":
		{
			MM_add_submix("warl_player_tech_explode", 0);
			mm_clear_submix("warl_player_tech_shoot",0);
			wait(1.2);
			mm_clear_submix("warl_player_tech_explode",0);
			wait(0.5);
			thread play_sound_in_space("scn_tech_land_debris_front", level.player.origin);
			thread play_sound_in_space("scn_tech_debris_rain", level.player.origin);
			flag_clear("aud_player_using_tech_turret");
			wait(0.6);
			MM_add_submix("warl_mortar_run", 0.3);
			wait(4);
			flag_clear("aud_mortar_slowmo");	
		}
		break;
		
		case "aud_fire_mortar_shell":
		{
			thread aud_fire_mortar_shell(args);
		}
		break;	
		
		case "player_mortar_falling":
		{
			mortar_shell = args;
			thread aud_player_mortar_falling(mortar_shell);
		}
		break;	
		
		case "mortar_run_end":
		{
			MM_clear_submix("warl_mortar_run", 0.1);
		}
		break;
		
		case "player_fire_mortar":
		{
			thread play_sound_in_space("mortar_60mm_launch");
			thread play_sound_in_space("mortar_60mm_tube_elem");
			thread play_sound_in_space("mortar_60mm_fire_plr");
		}
		break;	
		
		case "pre_truck_explode_fake_mortar_incoming":
		{
			thread	aud_play_2d_sound("warl_fake_incoming_tech");
		}
		break;	
		
		case "pre_truck_explode_fake_mortar":
		{
			exp_num = args;
			exp_ent = aud_find_exploder(exp_num);
			assert(IsDefined(exp_ent));
			
			assert(IsDefined(exp_ent.v));
			hit_pos = exp_ent.v["origin"];
			assert(IsDefined(hit_pos));
			
			thread play_sound_in_space("warl_fake_mortar_explo_3d", hit_pos);
			wait(1.6);
			thread	aud_play_2d_sound("warl_fake_incoming_tech_whoosh");
			
		}
		break;	

		case "mortar_explosion":
		{
			hit_pos = args;
			thread aud_play_mortar_explosion(hit_pos);
		}
		break;
		
		case "second_house_explode":
		{
		}
		break;	
		
		case "mortar_house_explode":
		{
		}
		break;
		
		case "fall_through_roof":
		{
			level.aud.mortar_run_complete = true;
		} 
		break;	
		
		case "player_mortar_attach":
		{
			flag_set("player_using_mortar");
			level.player playsound("weap_mortar60mm_attach_plr");
			music_cue("mus_player_mortar");
		}
		break;
		
		case "player_mortar_detach":
		{
			flag_clear("player_using_mortar");
			level.player playsound("weap_mortar60mm_attach_plr");
		}
		break;
		
		case "mortar_technical_1_spawneds":
		{

		}
		break;

/****************************/
/******* Infiltration *******/
/***************************/		
		case "sleeping_guard_spawned":
		{
			snoring_guard = args;
			snoring_guard thread aud_snoring_guard();
		}
		break;
		
		case "aud_kill_sleeping_guard":
		{
			flag_set("kill_sleeping_guard");
			//iprintlnbold("snore_flag_set");
		}
		break;
		
		case "aud_wake_sleeping_guard":
		{
			flag_set("kill_sleeping_guard");
			thread play_sound_in_space("warl_folding_chair_fall", (4564, 3198, 190));
			wait(0.75);
			thread play_sound_in_space("warl_folding_chair_impact", (4564, 3198, 190));
			//iprintlnbold("snore_flag_set");
		}
		break;

/****************************/
/********Church************/
/***************************/	

		case "compound_technical_right":
		{
			technical = args;
			technical playsound("tech_arena_01_inc_os");
		}
		break;

		case "warlord_assault":
		{
//			AMSx_clear_sticky_control_val();		// Allow AMS to take over mood again.
		}
		break;
		
		case "mi17_flyby":
		{
			heli = args;
			flag_set("mi17_flyby");
			flyby = aud_play_linked_sound("warl_heli_by_overhead", heli);
			flyby scalevolume(1.0, 1);
			thread aud_heli_inbound(heli);
		}
		break;
		
		case "first_heli_deleted":
		{
			flag_set("aud_first_heli_deleted");
		}
		break;		
		
		case "warlord_end_all_clear":
		{
			flag_set("aud_finale_all_clear");
		}
		break;
		
		case "mi17_finale_flyout":
		{
			heli = args;
			if(IsDefined(heli))
			{
				level.aud.mi17_attach = heli;
				flag_set("aud_second_heli_spawned");
			}
			
			heli thread aud_warl_finale();
		}
		break;
				
		case "church_doors_open":
		{
			door = args;
			thread play_sound_in_space("warl_church_door_open", door.origin);
			wait(.3);
			thread play_sound_in_space("warl_hyena_church_reveal_01",(3454,8758,977));
			wait(.5);
			thread play_sound_in_space("warl_hyena_church_reveal_02",(3508,8878,977));
		}
		break;
		
		case "player_breach":
		{
			flag_set("player_breach");
		}
		break;	
		
		case "price_gun_sweetener":
		{
			wait(0.05);
			thread aud_price_gun_sweetener(args);
		}
		break;
		
		case "price_gun_sweetener_burst":
		{
			wait(0.05);
			thread aud_price_gun_sweetener_burst(args);
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
			wait(1.0);
			MUS_play("warl_intro", 6);
			wait(10);
			aud_set_music_submix(0.6, 6);
		}
		break;
		
		case "mus_stop_intro_music":
		{
			aud_set_music_submix(0.4, 10);
			wait(10);
			MUS_Stop(25);
		}
		break;
		
		case "mus_river_first_encounter_start":
		{
			aud_set_music_submix(1, 1);
			MUS_play("warl_tangos_approaching", 8.0);
		}
		break;

		case "mus_river_first_encounter_all_clear":
		{
			aud_set_music_submix(1, 1);
			MUS_play("warl_tangos_all_clear", 12.0);
		}
		break;
		
		case "mus_river_first_encounter_spotted":
		{
			aud_set_music_submix(1, 0.25);
			MUS_play("warl_go_hot", 0, 5);
		}
		break;

		case "mus_take_them_out":
		{
			MUS_play("warl_take_them_out", 5.0);
						
			// Start Tire Fire Taunting DAMB
			DAMB_start_preset_at_point("warl_vo_african_taunt_pos", (470, 897, 35), "tire_fire_taunts", 1500, 3);
		}
		break;

		case "mus_take_them_out_busted":
		{
			aud_set_music_submix(1, 0.25);
			MUS_play("warl_go_hot", 0, 2);
		}
		break;

		case "mus_take_them_out_all_clear":
		{
			MUS_play("warl_take_them_out", 10.0); // Ignored if already playing this cue; reverts back to it if player was busted.
		}
		break; 
			
		case "mus_tire_burning_start":
		{
			wait(25);	// Stop this when anim stops (if not already stopped by busted or all clear states).
			DAMB_stop_preset_at_point("warl_vo_african_taunt_pos", "tire_fire_taunts", 4);
		}
		break;

		case "mus_tire_burning_busted":
		{
			DAMB_stop_preset_at_point("warl_vo_african_taunt_pos", "tire_fire_taunts", 3);
			
			aud_set_music_submix(1, 0.25);
			MUS_play("warl_go_hot", 0, 2);
			level.aud.mus_tire_burning_was_busted = true;
		}
		break;

		case "mus_tire_burning_all_clear":
		{
			DAMB_stop_preset_at_point("warl_vo_african_taunt_pos", "tire_fire_taunts", 3);
			
			if (IsDefined(level.aud.mus_tire_burning_was_busted))
			{
				wait(2);	
			}
			aud_set_music_submix(1, 6);
			MUS_play("warl_tire_burning_all_clear", 10.0); // Ignored if already playing this cue; reverts back to it if player was busted.		
		}
		break;

		// When big moment guys spawn in, which is a trigger in the middle of the burn guy’s area.
		case "mus_river_big_moment_start":	// Start of entire big moment including guys on river and patrol on grass path.
		{
			// Start ambient VO chatter positioned at the tall palm tree near the river at the big-moment.
			DAMB_start_preset_at_point("warl_vo_african_big_moment_pos", (1582, 2141, -26),	"big_moment", 1500, 6);
		}
		break;
		
		// aud_river_big_moment_grass_start – sent when the player has entered the grassy area
		case "mus_river_big_moment_grass_start":
		{
			//MUS_play("warl_get_down", 5.0);	
			MUS_stop(10);
			wait(10);
			aud_set_music_submix(1.0, 1); 
		}
		break;
		
		// aud_river_big_moment_grass_prone – sent when the player has gone prone in the grassy area
		case "mus_river_big_moment_grass_prone":
		{
			//MUS_play("warl_get_down", 3.0);
		}
		break;
		
		// aud_river_big_moment_grass_stop – sent when the prone moment is done (after the guys have left and your allies have started to get up)
		case "mus_river_big_moment_grass_stop":
		{
			MUS_play("warl_get_down_all_clear", 8.0);
		}
		break;
		
		// aud_river_big_moment_grass_spotted – sent if you’re spotted during the prone moment
		case "mus_river_big_moment_busted":
		{
			aud_set_music_submix(1, 0.25);
			MUS_play("warl_go_hot", 0, 2);
			DAMB_stop_preset_at_point("warl_vo_african_big_moment_pos", "big_moment", 1);
		}
		break;
		
		case "mus_river_big_moment_all_clear": // When you’re past the bridge, almost to the corner kill.
		{
			MUS_play("warl_bridge_guys_dead", 5.0);
			aud_set_music_submix(1, 5);
			DAMB_stop_preset_at_point("warl_vo_african_big_moment_pos", "big_moment", 5);
		}
		break;
		
		case "mus_church_mouse":
		{
			aud_set_music_submix(0, 12);
		}
		break;

		case "mus_bridge_guys_dead":
		{
			MUS_play("warl_bridge_guys_dead", 5.0);
			aud_set_music_submix(0.7, 5);
			wait(20);
			MUS_stop(60);
		}
		break;

		// OVERWATCH
		case "mus_corner_kill":
		{
			aud_set_music_submix(1, 3);
			MUS_play("warl_corner_kill", 5.0);
		}
		break;
		
		case "mus_corner_kill_busted":
		{
			// Do nothing for now.
		}
		break;

		case "mus_tower_snipe":
		{
			wait(8);
			MUS_play("warl_tower_snipe", 5.0);
		}
		break;

		case "mus_overwatch_busted":
		{
			aud_set_music_submix(1, 0.25);
			MUS_play("warl_go_hot", 0, 2);
		}
		break;

		case "mus_go_hot":
		{
			aud_set_music_submix(1, 0.25);
			MUS_play("warl_go_hot", 0, 2);
		}
		break;

		// ADVANCE
		case "mus_to_technical":
		{
			wait(4);
			MUS_play("warl_to_technical", 5.0);
		}
		break;

		// TECHNICAL
		case "mus_player_on_technical":
		{
			MUS_stop(10);
		}
		break;

		case "mus_mortar_inbound":
		{
			aud_set_music_submix(1, 0.1);
			MUS_play("warl_drone_e", 1);
			wait(7);
			aud_set_music_submix(1000, 1);
			MUS_play("warl_mortar_inbound", 1);
		}
		break;

		case "mus_yuri_down":
		{
			aud_set_music_submix(1, 10);
			MUS_play("warl_yuri_down", 1.0);
		}
		break;

		case "mus_player_mortar":
		{
			aud_set_music_submix(1, 3);
			MUS_play("warl_player_mortar", 5.0);
		}
		break;

		case "mus_player_mortar_done":
		{
			MUS_play("warl_post_player_mortar", 1);
		}
		break;
		
		case "mus_enter_sewer_pipe":
		{
			if (!IsDefined(level.aud.mus_enter_sewer_pipe))
			{
				level.aud.mus_enter_sewer_pipe = true;
				MUS_stop(8);
			}
		}
		break;
		
		case "mus_exit_sewer_pipe":
		{
			if (!IsDefined(level.aud.mus_exit_sewer_pipe))
			{
				level.aud.mus_exit_sewer_pipe = true;
				MUS_play("warl_exit_sewer_pipe", 5);
			}
		}
		break;
		
		// mus_house_shootout init through radiant trigger
		case "mus_house_shootout":
		{
			// Commenting this out.  Sounds wrong to bring out music here (dv).
			//xfadetime = 15;
			//MUS_play("warl_house_shootout", xfadetime);
			//wait(5);
			//MUS_stop(30);
		}
		break;
		
		// mus_down_the_street init through radiant trigger
		case "mus_down_the_street":
		{
			//MUS_play("warl_down_the_street", 3.0);
			aud_set_music_submix(0.5, 5);
			MUS_play("warl_to_technical", 3.0);
		}
		break;
		
		case "mus_shoulder_charge_door":
		{
			wait(10);
			aud_set_music_submix(1, 5);
			MUS_play("warl_down_the_street", 5.0);
		}
		break;
		
		// SUPER TECHNICAL
		case "mus_technical_destroyed":
		{
			// OBSOLETE:  MUS_play("warl_technical_destroyed", 8);
		}
		break;

		case "mus_pre_church_door_breach":
		{
			MUS_play("warl_pre_church_door_breach", 8.0);
		}
		break;

		// CHURCH
		case "mus_dog_scene":
		{
			aud_set_music_submix(1, 1);
			MUS_play("warl_dog_fight", 3.0);
			wait(5);
			AZM_start_zone("warl_end");
			wait(15);
			MUS_play("warl_drone_e", 8);
		}
		break;

		case "mus_price_kicks_doors":
		{
			MUS_play("warl_price_kicks_doors", 3.0);
			wait(35);
			MUS_play("warl_ending_filler", 4.0);
		}
		break;	
		
		default:
		{
			msg_handled = false;
		}
	}

	return msg_handled;
}

aud_play_mortar_explosion(hit_pos)
{				
	if(Isdefined (hit_pos))
	{
		if(flag("player_using_mortar"))
		{					
			thread play_sound_in_space("mortar_impact_3d", hit_pos);//ac130_main_impact_3d
			thread play_sound_in_space("player_3d_mortar",hit_pos);//ac130_layer_3d_mortar
			thread play_sound_in_space("player_mortar_debris",hit_pos);//mortar_debris

			wait(0.2);
			thread play_sound_in_space("player_mortar_debris_lyr",hit_pos);//ac130_debris_lyr
		}
		else if(!IsDefined(level.aud.mortar_run_complete))
		{
			thread play_sound_in_space("npc_mortar_lfe", hit_pos);//mortar_lfe
			thread play_sound_in_space("mortar_run_impact_2d", hit_pos);//ac130_main_impact_2d
			thread play_sound_in_space("npc_2d_mortar",hit_pos);//ac130_layer_3d_mortar
			thread play_sound_in_space("npc_mortar_debris_lyr",hit_pos);//ac130_debris_lyr
			wait(0.08);
			thread play_sound_in_space("mortar_impact_ring", hit_pos);//mortar_impact_ring
			wait(0.2);
			thread play_sound_in_space("npc_mortar_debris",hit_pos);//mortar_debris
		}
		else
		{
			//thread play_sound_in_space("npc_mortar_lfe", hit_pos);//mortar_lfe
			thread play_sound_in_space("mortar_run_impact_3d", hit_pos);//ac130_main_impact_2d
			thread play_sound_in_space("npc_3d_mortar",hit_pos);//ac130_layer_3d_mortar
			thread play_sound_in_space("npc_mortar_debris_lyr",hit_pos);//ac130_debris_lyr
			wait(0.08);
			thread play_sound_in_space("mortar_impact_ring", hit_pos);//mortar_impact_ring
			wait(0.2);
			thread play_sound_in_space("npc_mortar_debris",hit_pos);//mortar_debris
		}	
	}
}

aud_mortar_run_shell_incoming(args)
{
	target_pos = args[0];
	time_to_target = args[1];

	assert(isDefined(target_pos));
	assert(isDefined(time_to_target));

	probability = RandomInt(5);
	
	if (probability < 4)
	{
		whistle_time = randomfloatrange( 0.25, 0.65 );
	}	
	else
	{
		whistle_time = randomfloatrange( 0.65, 1.0 );
	}
}

aud_play_mortar_incoming(target_pos, time_to_target)
{
	inc_time = 0.5;
	inc_delay = (time_to_target - inc_time);

	if(inc_delay < 0)
	{
		inc_delay = 0;
	}

	wait(inc_delay);
	thread	aud_play_2d_sound("warl_artillery_incoming_whoosh");
}

aud_fire_mortar_shell(args)
{
	mortar_shell = args[0];
	target_pos = args[1];
	start_pos = args[2];
	time_to_target = args[3];
	target_ent = spawn("script_origin", target_pos);

	if(flag("player_using_mortar"))
	{
		shell_ent = spawn("script_origin", mortar_shell.origin);
		shell_ent linkto(mortar_shell);
		wait(0.3);
		aud_fade_sound_in(shell_ent,"warl_artillery_incoming_plr", 1.0, 0.25, false);	
		mortar_shell waittill("death");
		shell_ent stopsounds();
		wait(0.05);
		shell_ent delete();		
	}
	else
	{
		thread play_sound_in_space("mortar_60mm_launch3d", start_pos);
		thread play_sound_in_space("mortar_60mm_tube_elem3d", start_pos);
		thread play_sound_in_space("mortar_60mm_fire3d", start_pos);

		//thread aud_play_mortar_incoming(target_pos, time_to_target);
		wait(0.15);
		
		shell_ent = spawn("script_origin", mortar_shell.origin);
		shell_ent linkto(mortar_shell);
		wait(0.1);
		aud_fade_sound_in(shell_ent,"warl_artillery_incoming_npc", 1.0, 0.25, false);	
		mortar_shell waittill("death");
		shell_ent stopsounds();
		wait(0.05);
		shell_ent delete();
	}
}

aud_player_mortar_falling(mortar_shell)
{
}

aud_snoring_guard()
{
	self thread snoring_guard_deathwatch();
	self playloopsound ("warl_guardsnore_lp");
	flag_wait_any("snoring_guard_dead","kill_sleeping_guard","inf_stealth_spotted", "infiltration_over");
	self stoploopsound ("warl_guardsnore_lp");
	play_sound_in_space("warl_guardsurprise", (4575,3191,232));
}

snoring_guard_deathwatch()
{
	self waittill("death");
	flag_set("snoring_guard_dead");
}


aud_start_loops()
{
	loop_fx_sound("warl_wind_heavy_lp",		(3876, 2546, 800),	true);	// Near sniper tower.
	loop_fx_sound("warl_wind_heavy_lp",		(7198, 5314, -208),	true);	// Near technical 50cal battle.
	loop_fx_sound("warl_wind_heavy_lp",		(6470, 7111, 1500),	true);	// Near player mortar.
	loop_fx_sound("warl_wind_med_lp",		(6508, 8932, 632),	true);	// Near player mortar.
	loop_fx_sound("warl_wind_med_lp",		(6118, 8511, 699),	true);	// Near player mortar.
	loop_fx_sound("warl_dog_in_house_lp",	(6878, 8346, 626),	true);	// Near tunnel.
	loop_fx_sound("warl_water_pipe_drips",(6444, 8368, 576), true);	// First drips interior pipe.
	loop_fx_sound("warl_water_pipe_drips",(6250, 8530, 576), true);	// Second drips interior pipe.
	loop_fx_sound("warl_water_pipe_drips",(6027, 8718, 576), true);	// Third drips interior pipe.
	loop_fx_sound("warl_water_pipe_outflow",(5883, 8853, 536), true);	// Outflow at pipe end.
	loop_fx_sound("warl_water_pipe_outflow",(5636, 9261, 468), true);	// Outflow post pipe end.
}

aud_start_positional_dambs()
{
	// FUNCTION PARAMS: DAMB_start_preset_at_point(preset_name, point, label_, max_distance_, fadeoutmaxdistance_, linked_dambs_)
	
	// Jungle Trail
	DAMB_start_preset_at_point("warl_cricket1", (1477, -1764, 57), "cricket_log_encouter1", 720, 3);	
	DAMB_start_preset_at_point("warl_cricket2", (1212, -36, -24), "cricket_log_encouter2", 720, 3);
	
	DAMB_start_preset_at_point("warl_cricket1", (520, 668, 15),		"cricket_tire_encouter1", 720, 3);	
	DAMB_start_preset_at_point("warl_cricket2", (824, 1010, 49),	"cricket_tire_encouter2", 720, 3);	
	DAMB_start_preset_at_point("warl_cricket1", (1772, 3118, -1),	"cricket_after_bridgesnipe1", 720, 3);	
	DAMB_start_preset_at_point("warl_cricket2", (2925, 3487, 2),	"cricket_after_bridgesnipe2", 720, 3);	
	DAMB_start_preset_at_point("warl_cricket2", (4152, 2656, 23),	"cricket_after_cornerkill", 720, 3);	
	DAMB_start_preset_at_point("warl_cricket2", (6929, 8136, 565),	"cricket_before_tunnel", 720, 3);	
	DAMB_start_preset_at_point("warl_cricket2", (6125, 8635, 576),	"cricket_inside_tunnel", 720, 3);	
	
	// River Length
	DAMB_start_preset_at_point("warl_river_positional", (1719, 1535, 0), "river_insects_by_log", 440, 3);	
	DAMB_start_preset_at_point("warl_river_positional", (2010, 2062, 0), "river_insects_by_metal", 440, 3);
	DAMB_start_preset_at_point("warl_river_positional", (2334, 2725, 0), "river_insects_by_palette", 440, 3);
	DAMB_start_preset_at_point("warl_river_positional", (2475, 3280, 0), "river_insects_under_bridge", 440, 3);
	DAMB_start_preset_at_point("warl_river_positional", (2480, 3741, 0), "river_insects_by_trash_bags", 440, 3);

	// Tower Sniper Area
	DAMB_start_preset_at_point("warl_maggots_positional", (5169, 2961, 500), "tower_sniper_dead_cow", 360, 3);	
	DAMB_start_preset_at_point("warl_maggots_positional", (3561, 2786, 180), "tower_sniper_trash_pile1", 360, 3);
	DAMB_start_preset_at_point("warl_maggots_positional", (3930, 2562, -14), "tower_sniper_trash_pile2", 360, 3);
	DAMB_start_preset_at_point("warl_maggots_positional", (4189, 3149, 0), "tower_sniper_trash_pile3", 360, 3);
	DAMB_start_preset_at_point("warl_maggots_positional", (4309, 3364, 0), "tower_sniper_trash_pile4", 360, 3);
	DAMB_start_preset_at_point("warl_maggots_positional", (4227, 2804, 0), "tower_sniper_trash_pile5", 360, 3);
	DAMB_start_preset_at_point("warl_maggots_positional", (5188, 2630, -50), "tower_sniper_trash_pile6", 360, 3);
	DAMB_start_preset_at_point("warl_maggots_positional", (6127, 3238, -90), "tower_sniper_trash_pile7a", 360, 3);
	DAMB_start_preset_at_point("warl_maggots_positional", (6097, 3222, -90), "tower_sniper_trash_pile7b", 360, 3);
	
	// Water Tunnel Length
	DAMB_start_preset_at_point("warl_tunnel_positional", (6500, 8309, 576), "water_tunnel_1", 360, 3);	
	DAMB_start_preset_at_point("warl_tunnel_positional", (6234, 8538, 579), "water_tunnel_2", 360, 3);
	DAMB_start_preset_at_point("warl_tunnel_positional", (5976, 8767, 576), "water_tunnel_3", 360, 3);
	
	// Trash pile after tunnel.
	DAMB_start_preset_at_point("warl_maggots_positional", (5781, 9084, 538), "post_water_tunnel_trash_pile", 720, 3);
	
	// Water area of house_town_dense2 zone.
	DAMB_start_preset_at_point("warl_maggots_positional", (6720, 10516, 503), "house_town_dense2_water1", 720, 3);
	DAMB_start_preset_at_point("warl_maggots_positional", (7045, 10387, 495), "house_town_dense2_water2", 720, 3);
	DAMB_start_preset_at_point("warl_maggots_positional", (6987, 9598, 550), "house_town_dense2_water3", 720, 3);	
}

aud_start_tunnel_dambs()
{
	DAMB_start_preset_at_point("warl_tunnel_positional", (6500, 8309, 576), "water_tunnel_1", 630, 3);	
	DAMB_start_preset_at_point("warl_tunnel_positional", (6234, 8538, 579), "water_tunnel_2", 360, 3);
	DAMB_start_preset_at_point("warl_tunnel_positional", (5976, 8767, 576), "water_tunnel_3", 630, 3);
}

aud_stop_tunnel_dambs()
{
	DAMB_stop_preset_at_point("warl_tunnel_positional", "water_tunnel_1", 3);
	DAMB_stop_preset_at_point("warl_tunnel_positional", "water_tunnel_2", 3);
	DAMB_stop_preset_at_point("warl_tunnel_positional", "water_tunnel_3", 3);
}

aud_start_fire_dambs()
{
	DAMB_start_preset_at_point("fire_warlord_piles", (1208, -600, -47), "pre_hyena_01", 600, 1.0); //smoldering pile left of bodies pre hyena
	DAMB_start_preset_at_point("fire_warlord_piles_sml", (946, -2, -42), "post_hyena_01", 600, 1.0); //smoldering pile in shante pre courtyard
	DAMB_start_preset_at_point("fire_warlord_piles_sml", (883, 221, -50), "post_hyena_02", 600, 1.0); //small pile outside shante door
	DAMB_start_preset_at_point("fire_warlord_piles_sml", (789, 305, -27), "post_hyena_03", 600, 1.0); //right fence fires
	DAMB_start_preset_at_point("fire_warlord_piles_sml", (689, 237, -39), "post_hyena_04", 600, 1.0); //right side tree stumps
	DAMB_start_preset_at_point("fire_warlord_piles_sml", (798, -350, -50), "post_hyena_05", 600, 1.0); //left back corner small 
	DAMB_start_preset_at_point("fire_warlord_piles_sml", (612, -339, -47), "post_hyena_06", 600, 1.0); //left shante entrance
	DAMB_start_preset_at_point("fire_warlord_piles_sml", (541, -288, -35), "post_hyena_07", 600, 1.0); //left burning stumps
	DAMB_start_preset_at_point("fire_warlord_piles_sml", (465, -136, -38), "post_hyena_08", 600, 1.0); //wood plank 
	DAMB_start_preset_at_point("fire_warlord_piles_sml", (320, -61, -21), "post_hyena_09", 600, 1.0); //far left corner woodpile
	DAMB_start_preset_at_point("fire_warlord_piles", (391, 82, -22), "post_hyena_10", 600, 1.0); //burning body
	DAMB_start_preset_at_point("fire_warlord_piles_sml", (431, 124, -30), "post_hyena_11", 600, 1.0); //watchpoint treestump
	DAMB_start_preset_at_point("fire_warlord_piles_sml", (396, 156, 48), "post_hyena_12", 600, 1.0); //watchpoint roof crackle small
	DAMB_start_preset_at_point("fire_warlord_piles_sml", (249, 213, 64), "post_hyena_13", 600, 1.0); //watchpoint far ledge 
	DAMB_start_preset_at_point("fire_warlord_piles_sml", (351, 297, 59), "post_hyena_14", 600, 1.0); //watchpoint front roof corner
	DAMB_start_preset_at_point("fire_warlord_piles_sml", (52, 401, 2), "post_hyena_15", 600, 1.0); //post watchpoint shante doorway
}
	
aud_tech_explode_watch()
{
	self waittill ("death");
}

// OBSOLETE
// Music threads to handle flags init through radiant trigger (for consitient msg handling).
//mus_water_tunnel()
//{
//	wait(3);	// Wait for radiant init.
//	flag_wait("mus_water_tunnel");
//	aud_send_msg("mus_water_tunnel");
//}

mus_house_shootout()
{
	wait(3);	// Wait for radiant init.
	flag_wait("mus_house_shootout");
	aud_send_msg("mus_house_shootout");
}

mus_down_the_street()
{
	wait(3);	// Wait for radiant init.
	flag_wait("mus_down_the_street");
	aud_send_msg("mus_down_the_street");
}

aud_warl_monitor_water_footsteps()
{
	MM_add_submix("warl_swamp_footsteps_shallow", 0);
	MM_add_submix("warl_swamp_footsteps_deep", 0);
	wait(0.05);
	MM_scale_submix("warl_swamp_footsteps_shallow", 0, 0); // scale off the shallow immediately
	
	level endon("aud_warl_stop_monitor_footsteps");
	
	assert(IsDefined(level.aud.player_height_start));
	
	player_height_start = level.aud.player_height_start;
	
	while(true)
	{
		player_height = level.player.origin[2] - player_height_start;
		player_height = player_height / 40;
		deep_volume = 1.0 - player_height; // 40 is the max delta in height when going up the hill
		deep_volume = clamp(deep_volume, 0.0, 1.0);
		shallow_volume = player_height;
		player_height = clamp(player_height, 0.0, 1.0);
		
		MM_scale_submix("warl_swamp_footsteps_shallow", shallow_volume, 0.1);
		MM_scale_submix("warl_swamp_footsteps_deep", deep_volume, 0.1);
		wait(0.1);
	}
}

aud_warl_stop_monitor_water_footsteps()
{
	level notify("aud_warl_stop_monitor_footsteps");
	MM_clear_submix("warl_swamp_footsteps_shallow", 0);
	MM_clear_submix("warl_swamp_footsteps_deep", 0);
}

aud_warl_monitor_npc_water_footsteps()
{
	MM_add_submix("warl_swamp_npc_footsteps_shallow", 0);
	MM_add_submix("warl_swamp_npc_footsteps_deep", 0);
	wait(0.05);
	MM_scale_submix("warl_swamp_npc_footsteps_shallow", 0, 0); // scale off the shallow immediately
	
	level endon("aud_warl_stop_monitor_footsteps");
	
	npc_height_start = level.soap.origin[2];
	
	while(true)
	{
		npc_height = level.soap.origin[2] - npc_height_start;
		npc_height = npc_height / 40;
		deep_volume = 1.0 - npc_height; // 40 is the max delta in height when going up the hill
		deep_volume = clamp(deep_volume, 0.0, 1.0);
		shallow_volume = npc_height;
		npc_height = clamp(npc_height, 0.0, 1.0);
		
		MM_scale_submix("warl_swamp_npc_footsteps_shallow", shallow_volume, 0.1);
		MM_scale_submix("warl_swamp_npc_footsteps_deep", deep_volume, 0.1);
		wait(0.1);
	}
}

aud_warl_stop_npc_monitor_water_footsteps()
{
	level notify("aud_warl_stop_monitor_footsteps");
	MM_clear_submix("warl_swamp_npc_footsteps_shallow", 0);
	MM_clear_submix("warl_swamp_npc_footsteps_deep", 0);
}

aud_warl_start_river_rain_drops(fadetime_)
{
	fadetime = 3.0;
	if(IsDefined(fadetime_))
	{
		fadetime = fadetime_;
	}
	
	rain_drops = spawn("script_origin", level.player.origin);
	
	rain_drops playloopsound("warl_river_rain_drops_lp");
	rain_drops scalevolume(0.0,0);
	wait(0.05);
	rain_drops scalevolume(1.0, fadetime);
	thread aud_warl_stop_river_rain_drops(rain_drops, fadetime);
}

aud_warl_stop_river_rain_drops(ent, fadetime)
{
	level waittill("aud_warl_stop_river_rain_drops");
	assert(IsDefined(ent));
	assert(IsDefined(fadetime));
	
	ent scalevolume(0.0, fadetime);
	wait(fadetime + 0.05);
	ent stoploopsound();
	wait(0.05);
	ent delete();
}

aud_warl_start_sewer_pipe_interiorflow(fadetime_)
{
	fadetime = 1.0;
	if(IsDefined(fadetime_))
	{
		fadetime = fadetime_;
	}
	
	sewer_pipe = spawn("script_origin", level.player.origin);
	
	sewer_pipe playloopsound("warl_water_pipe_interiorflow");
	sewer_pipe scalevolume(0.0,0);
	wait(0.05);
	sewer_pipe scalevolume(1.0, fadetime);
	thread aud_warl_stop_sewer_pipe_interiorflow(sewer_pipe, fadetime);
}

aud_warl_stop_sewer_pipe_interiorflow(ent, fadetime)
{
	level waittill("aud_warl_stop_sewer_pipe_interiorflow");
	assert(IsDefined(ent));
	assert(IsDefined(fadetime));
	
	ent scalevolume(0.0, fadetime);
	wait(fadetime + 0.05);
	ent stoploopsound();
	wait(0.05);
	ent delete();
}

// aud - creates script origin at given position and plays sound on that ent.
aud_warl_play_sound_at(alias, pos)
{
	ent = Spawn( "script_origin", pos );
	ent PlaySound(alias, "sounddone");
	ent waittill("sounddone");
	wait(0.05); // Avoids pops.
	ent delete(); 
}

//aud_set_advance_music_intensity()
//{
//	AMS_set_sticky_control_val(1.0);		// Force mood to high energy.
//	wait(20);														// Wait a while...
//	AMSx_clear_sticky_control_val();		// Allow AMS to take over mood again.
//}
//
//aud_mus_set_first_patroller_intensity()
//{
//	flag_wait( "aud_infiltrate_encounter_1" );
//	AMS_set_sticky_control_val(0.0);		// Keep intensity at stealth.
//	
//	thread aud_wait_first_patroller_skip();
//	thread aud_wait_first_patroller_uninterruptible();
//}
//
//aud_wait_first_patroller_skip()
//{
//	level endon("paired_kill_uninterruptible");
//	level waittill("skip_encounter_1");
//	AMSx_clear_sticky_control_val();
//}
//	
//aud_wait_first_patroller_uninterruptible()
//{
//	level endon("skip_encounter_1");
//	level waittill("paired_kill_uninterruptible");
//	wait(3);
//	AMSx_clear_sticky_control_val();
//}
//
//aud_mus_set_mortar_run_intensity()
//{
//	flag_wait("warlord_mortar_run");
//	AMS_set_sticky_control_val(1.0);		// Force mood to high energy.
//}

aud_prepare_church_breach()
{
	flag_wait( "aud_warlord_player_breach" );
	thread aud_set_breach_time_scale_factors();
}

aud_tech_loops(instance_name, move_loop, roll_loop, idle_loop, gravel_loop)
{
	if(!IsDefined(gravel_loop))
	{
		gravel_loop = "null_lp";
	}
	
	level.aud.instance_name = spawn("script_origin", self.origin);
	
	move_ent = spawn("script_origin", self.origin);
	roll_ent = spawn("script_origin", self.origin);
	idle_ent = spawn("script_origin", self.origin);
	gravel_ent = spawn("script_origin", self.origin);
	
	level.aud.instance_name.fade_in = true;
		
	instance = 	level.aud.instance_name;
	
	fade_in = level.aud.instance_name.fade_in;
		
	move_ent linkto(self);
	idle_ent linkto(self);
	roll_ent linkto(self);
	gravel_ent linkto(self);
	
	move_ent playloopsound(move_loop);
	roll_ent playloopsound(roll_loop);
	idle_ent playloopsound(idle_loop);
	gravel_ent playloopsound(gravel_loop);
	
	move_ent scalevolume(0.0);
	roll_ent scalevolume(0.0);
	idle_ent scalevolume(0.0);
	gravel_ent scalevolume(0.0);
	
	wait(0.3);
	
	self aud_tech_speed_mapping(instance, move_ent, roll_ent, idle_ent, gravel_ent, 1, 10, fade_in);
}

aud_tech_speed_mapping(instance, move_ent, roll_ent, idle_ent, gravel_ent, min_speed, max_speed, fade_in)
{
	min_speed = 1;
	max_speed = 10;
	
	self thread aud_tech_deathwatch(instance, move_ent, roll_ent, idle_ent, gravel_ent);

	instance endon("instance_killed");
	
	prev_veh_speed = 0;
	
	while(1)
	{ 
		if(IsDefined(self))
		{
			veh_speed = self vehicle_getspeed();
			veh_speed = min(veh_speed, max_speed);
			veh_speed = aud_smooth(prev_veh_speed, veh_speed, 0.1);

			veh_drive_vol = aud_map_range(veh_speed, min_speed, max_speed, level.aud.envs["veh_drive_vol"]);
			veh_idle_vol = aud_map_range(veh_speed, min_speed, max_speed, level.aud.envs["veh_idle_vol"]);
			veh_gravel_vol = aud_map_range(veh_speed, min_speed, max_speed, level.aud.envs["veh_gravel_vol"]);
			
			roll_ent scalevolume(veh_drive_vol, 0.1);
			move_ent scalevolume(veh_drive_vol, 0.1);
			idle_ent scalevolume(veh_idle_vol, 0.1);
			gravel_ent scalevolume(veh_gravel_vol, 0.1);
			
			prev_veh_speed = veh_speed;
			
			wait(0.1);
		}
	}
}

aud_tech_deathwatch(instance, move_ent, roll_ent, idle_ent, gravel_ent)
{
	self waittill("death");
	instance notify("instance_killed");
	thread aud_fade_loop_out_and_delete_temp(move_ent, 5);
	thread aud_fade_loop_out_and_delete_temp(roll_ent, 5);
	thread aud_fade_loop_out_and_delete_temp(idle_ent, 5);
	thread aud_fade_loop_out_and_delete_temp(gravel_ent, 5);
}

// this will be ported to the _audio.gsc utility function when Don checks it in (hopefully)
aud_fade_loop_out_and_delete_temp(ent, fadetime)
{
	ent scalevolume(0.0, fadetime);
	wait(fadetime + 0.05);
	ent stoploopsound();
	wait(0.05);
	ent delete();
}

aud_turret_mortar_slowmo_setup()
{
	aud_disable_deathsdoor_audio();
	soundsettimescalefactor("norestrict2d", 0);
	soundsettimescalefactor("norestrict", 0);
	flag_waitopen("aud_mortar_slowmo");
	aud_enable_deathsdoor_audio();
}

aud_play_rap_on_technical(tech)
{
	// Create an ent on which to play the music, and link it to this technical.
	ent = spawn("script_origin", tech.origin);
	ent linkto(tech);
	ent.is_on = true;
	ent PlayLoopSound("warl_militia_rap1");

	// monitor the health of the tech in case it's killed before it despawns
	tech thread aud_monitor_health_of_tech(ent);
	
	// When the technical gets despawned, link the music ent to this other technical.
	tech waittill("death");
	if (ent.is_on)
	{
		assert(IsDefined(level.aud) && IsDefined(level.aud.rbm_tech2));
		ent.origin = level.aud.rbm_tech2.origin;
		assert(IsDefined(ent));
		ent linkto(level.aud.rbm_tech2);
		
		// if the second tech blows up, stop the loop
		level.aud.rbm_tech2 waittill("death");
		ent scalevolume(0, 3);
		wait(3.05);
		ent stoploopsound();
	}
	ent delete();
}

aud_monitor_health_of_tech(ent)
{
	while(true)
	{
		if (!IsDefined(self) || !IsDefined(ent))
			return;
			
		if (self.health < self.healthbuffer)
		{	
			ent.is_on = false;
			ent stoploopsound();
		}

		wait(0.05);
	}
}

mi17_circle_overhead()
{
	if(!level.aud.mi17_playing)
	{
		if(flag("inside_prechurch_burnthouse"))
		{
			mi17_overhead = aud_play_linked_sound("warl_heli_circle_overhead", level.player, "loop", "kill_heli_circle_loop");
			level.aud.mi17_playing = true;
			mi17_overhead scalevolume(0.0);
			wait(0.05);
			
			mi17_overhead thread mi17_vol_scale();
			
			flag_wait("mi17_flyby");
			
			if(IsDefined(mi17_overhead))
			{
				mi17_overhead ScaleVolume(1, 1);
				wait(1);
				mi17_overhead ScaleVolume(0.0, 3);
				wait(3.5);
				level notify("kill_heli_circle_loop");
			}					
		}
	}
}	

mi17_vol_scale()
{
	level endon("mi17_flyby");
	
	max_dist = 2000;
	scale_point = (6100,8089, 806);
	lerp_time = 2.5;
	
	while(1)
	{
		player_dist = distance2d(level.player.origin, scale_point);
		chopper_vol = aud_map_range(player_dist, 0, max_dist, level.aud.envs["mi17_fake_scale"]);
		
		self ScaleVolume(chopper_vol, lerp_time);
		wait(lerp_time);			
		lerp_time = 1;
	}
}
	
aud_heli_inbound(ent)
{
	if(IsDefined(ent))
	{
		mi17_dummy = spawn("script_origin", ent.origin);
		mi17_dummy linkto(ent);
		
		mi17_dummy_02 = spawn("script_origin", ent.origin);
		mi17_dummy_02 linkto(ent);
		
		aud_fade_sound_in(mi17_dummy,"warl_heli_blades_loop", 1.0, 3, true);

		aud_fade_sound_in( mi17_dummy_02,"warl_heli_occluded_lo_lp", 1.0, 3, true );
		
		mi17_dummy thread aud_kill_1st_heli();   // fades out and deletes 1st heli blades loop sound when it lands behind the church, leaving the occluded sound behind.
		
		flag_wait("aud_first_heli_deleted");
		mi17_dummy_02 unlink(ent);
		
		flag_wait("aud_second_heli_spawned");

		second_mi17 = level.aud.mi17_attach;
		if(IsDefined(second_mi17))
		{
			mi17_dummy_02 linkto(second_mi17);
		}
	}
}

aud_warl_finale()
{
	if(IsDefined(self))
	{
		sfx_ent = spawn("script_origin", self.origin);
		sfx_ent linkto(self);
		
		flag_wait( "aud_warlord_player_breach" );
		wait(1.1);
		thread aud_fade_sound_in(sfx_ent, "warl_heli_blades_loop_finale", 1, 0.2, true );		
		MM_add_submix("warl_finale");  // Clear Located in Aud_Heli_Escape_Dust();
		
		sfx_ent thread aud_heli_escape();
	}
}

aud_heli_escape()
{
	if(IsDefined(self))
	{		
		flag_wait("aud_finale_all_clear");
		wait(2);
		flyout = aud_play_linked_sound("warl_heli_take_off_fly_out", self);
		flyout thread aud_finale_heli_rev();
		aud_play_2d_sound("warl_heli_blades_dust_wind_2d");
		aud_play_2d_sound("warl_heli_paper_flutter_2d");
		wait(4);	
		thread play_sound_in_space("warl_heli_takeoff_close", (3173, 7867, 1306));
		//thread aud_play_linked_sound("warl_heli_takeoff_close", self);
		wait(2);
		MM_clear_submix("warl_finale", 5);
		wait(3);
		
		if(isdefined(self))
			self scalevolume(0.0, 10);
		wait(10);
		
		if(isdefined(self))
			self delete();
	}
}

aud_kill_1st_heli()
{
	wait(7.5);
	if(Isdefined(self))
	{
		thread aud_fade_out_and_delete(self, 5);		
	}
}

aud_finale_heli_rev()
{
	wait(4);
	
	if(isdefined(self))
		self scalevolume(0.3, 1);
		
	wait(1.5);
	
	if(isdefined(self))	
		self scalevolume(1.0, 3);
				
	wait(3);
	
	if(isdefined(self))
		self scalevolume(0.0, 7);		
}

aud_delay_scale_up(delay_time, fade_time)
{
	wait(delay_time);
	if(Isdefined(self))
	{
		self scalevolume(1.0, fade_time);		
	}
}

aud_delay_scale_down(delay_time, fade_time)
{
	wait(delay_time);
	if(IsDefined(self))
	{
		self scalevolume(0.0, fade_time);		
	}
}

aud_price_gun_sweetener(price)
{
	assert(IsDefined(price));
	num_gun_shots = 20;
	price_sound_ent = spawn("script_origin", price.origin);
	price_sound_ent linkto(price);
	for (i = 0; i < num_gun_shots; i++)
	{
		price_sound_ent playsound("weap_ak47_fire_npc_warl");
		wait(0.05);
	}
	price_sound_ent delete();
}

aud_price_gun_sweetener_burst(price)
{
	assert(IsDefined(price));
	num_gun_shots = 1;
	price_sound_ent = spawn("script_origin", price.origin);
	price_sound_ent linkto(price);
	for (i = 0; i < num_gun_shots; i++)
	{
		price_sound_ent playsound("weap_ak47_fire_npc_warl");
		wait(0.05);
	}
	price_sound_ent delete();
}

