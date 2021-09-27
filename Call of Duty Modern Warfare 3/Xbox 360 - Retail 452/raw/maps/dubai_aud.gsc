#include maps\_utility;
#include common_scripts\utility;
#include maps\_audio;
#include maps\_audio_zone_manager;
#include maps\_audio_mix_manager;
#include maps\_audio_reverb;
#include maps\_audio_music;
#include maps\_audio_vehicles;
#include maps\_audio_stream_manager;
#include maps\_audio_dynamic_ambi;

main()
{
	aud_init();
	aud_config_system();
	aud_init_flags();
	aud_init_globals();
	aud_launch_threads();
	aud_launch_loops();
	aud_create_level_envelop_arrays();
	aud_register_trigger_callbacks();
	aud_add_note_track_data();
	aud_precache_presets();
	aud_register_handlers();
	
	MM_add_submix("dubai_level_global_mix");
	//MM_add_submix("vo_audibility_mix_of_doom");
}

aud_config_system()
{
	set_stringtable_mapname("shg");
	aud_set_occlusion("med_occlusion");
	aud_set_timescale("shg_default", 20);
	aud_set_mission_failed_music("shg_mission_failed_stinger");
}

aud_init_flags()
{
	flag_init("1st_elevator_moving");
	flag_init("2nd_elevator_moving");	
	flag_init("turn_off_cove_alarm");
	flag_init("turn_off_top_floor_alarm");
	flag_init("elevator_glass_broken");
	flag_init("aud_heli_crash_impact");	
	flag_init("aud_finale_jump_succesful");
}

aud_init_globals()
{
	
	
	// points for the circular fountain outside of building
	
	level.aud.outside_fountain_pts = [];
	level.aud.outside_fountain_pts[level.aud.outside_fountain_pts.size] = (2817,13,68);
	level.aud.outside_fountain_pts[level.aud.outside_fountain_pts.size] = (2717,125,68);
	level.aud.outside_fountain_pts[level.aud.outside_fountain_pts.size] = (2589,74,68);
	level.aud.outside_fountain_pts[level.aud.outside_fountain_pts.size] = (2567,-44,68);
	level.aud.outside_fountain_pts[level.aud.outside_fountain_pts.size] = (2650,-114,68);
	level.aud.outside_fountain_pts[level.aud.outside_fountain_pts.size] = (2730,-120,68);
	
	// points for the distributed sound fountain in atrium
	
	// the center fountain
	level.aud.fountain_pts = [];

	level.aud.fountain_pts[level.aud.fountain_pts.size] = (1303,245,10);  // bottom level
	level.aud.fountain_pts[level.aud.fountain_pts.size] = (1296,61,10);
	level.aud.fountain_pts[level.aud.fountain_pts.size] = (1267,-157,10);
	
	level.aud.fountain_pts[level.aud.fountain_pts.size] = (1183,-186,133); // middle
	level.aud.fountain_pts[level.aud.fountain_pts.size] = (1188,126,164);

	level.aud.fountain_pts[level.aud.fountain_pts.size] = (1121,137,219); // middle 2
	level.aud.fountain_pts[level.aud.fountain_pts.size] = (1133,-162,233);

	level.aud.fountain_pts[level.aud.fountain_pts.size] = (1020,-100,312); // almost at top
	level.aud.fountain_pts[level.aud.fountain_pts.size] = (1046,103,312);
	
	level.aud.fountain_pts[level.aud.fountain_pts.size] = (955,83,327); // top
	level.aud.fountain_pts[level.aud.fountain_pts.size] = (953,-54,327);
	
	// the side fountains
	level.aud.fountain_pts_sides = [];

	level.aud.fountain_pts_sides[level.aud.fountain_pts_sides.size] = (1702,769,0);  // left side
	level.aud.fountain_pts_sides[level.aud.fountain_pts_sides.size] = (1530,780,0);
	level.aud.fountain_pts_sides[level.aud.fountain_pts_sides.size] = (1380,705,0);
	level.aud.fountain_pts_sides[level.aud.fountain_pts_sides.size] = (1335,540,0);
	level.aud.fountain_pts_sides[level.aud.fountain_pts_sides.size] = (1274,418,0);
	level.aud.fountain_pts_sides[level.aud.fountain_pts_sides.size] = (1188,373,0);
	level.aud.fountain_pts_sides[level.aud.fountain_pts_sides.size] = (1115,341,0);

	level.aud.fountain_pts_sides[level.aud.fountain_pts_sides.size] = (1692,-751,0);  // right side
	level.aud.fountain_pts_sides[level.aud.fountain_pts_sides.size] = (1572,-757,0);
	level.aud.fountain_pts_sides[level.aud.fountain_pts_sides.size] = (1380,705,0);
	level.aud.fountain_pts_sides[level.aud.fountain_pts_sides.size] = (1374,-746,0);
	level.aud.fountain_pts_sides[level.aud.fountain_pts_sides.size] = (1356,-482,0);
	level.aud.fountain_pts_sides[level.aud.fountain_pts_sides.size] = (1243,-396,0);
	level.aud.fountain_pts_sides[level.aud.fountain_pts_sides.size] = (1115,-331,0);
	
	//Elevator State Globals
	level.aud.first_floor_beep_played = false;
	level.aud.buttons_punched = false;
	level.aud.heli_death_whoosh_played = false;
}

aud_launch_threads()
{
	thread aud_elevator_stopped();
	thread aud_elevator_drop();
	thread aud_elevator_jump();
	thread aud_stop_slomo_scaling();
	thread aud_restaurant_exploders();
}

aud_launch_loops()
{
	if ( IsDefined( level.credits_active ) && level.credits_active )
	{
		return;
	}

	thread aud_start_lobby_alarms();
	
	// fountain outside of the building
	loop_fx_sound("dubai_water_fountain_large_lp", (2688,-12,60), true);
}

aud_create_level_envelop_arrays()
{
}

aud_register_trigger_callbacks()
{
}

aud_add_note_track_data()
{
}

aud_precache_presets()
{
}

aud_register_handlers()
{
	aud_register_msg_handler(::audio_msg_handler);
	aud_register_msg_handler(::music_msg_handler);
}

audio_msg_handler(msg, args)
{
	msg_handled = true;
	
	switch(msg)
	{
		/*******************************/
		/***** CHECKPOINT HANDLERS *****/
		/*******************************/

		case "start_intro":
		{
			AZM_start_zone("dubai_inside_truck");
			MM_add_submix("dubai_inside_truck"); 			// mutes outside bullet sounds to let dialogue, music, ambience be prominent
			MM_add_submix("dubai_mute_player_impact");
			music_cue("mus_intro");
			thread aud_clear_truck_submix_monitor(); 		// removes submix when door opens
			thread aud_monitor_player_impacts();
		}
		break;
		
		case "start_exterior":
		{
			AZM_start_zone("dubai_walkpath");
			thread aud_monitor_player_impacts();
		}
		break;
		
		case "start_exterior_circle":
		{
			AZM_start_zone("dubai_walkpath");
			music_cue("mus_first_combat");
			thread aud_monitor_player_impacts();
			MM_add_submix("dubai_mute_player_impact");
		}
		break;
		
		case "start_lobby":
		{
			AZM_start_zone("dubai_entrance_atrium");
			music_cue("mus_first_combat");
			thread aud_monitor_player_impacts();
			MM_add_submix("dubai_mute_player_impact");
			aud_start_atrium_fountain(); // starts the atrium fountain in lobby
		}
		break;

		case "start_elevator":
		{
			AZM_start_zone("dubai_second_floor_cove");
			music_cue("mus_board_escalator", 1);
			thread aud_monitor_player_impacts();
			MM_add_submix("dubai_mute_player_impact");
		}
		break;

		case "start_top_floor":
		{
			AZM_start_zone("dubai_top_floor");
			music_cue("mus_enter_top_floor", 1);
		}
		break;

		case "start_restaurant_entrance":
		{
			AZM_start_zone("dubai_restaurant");
			music_cue("mus_enter_top_floor", 1);
		}
		break;

		case "start_restaurant_destruction":
		{
			AZM_start_zone("dubai_restaurant");
			music_cue("mus_enter_top_floor", 1);
		}
		break;

		case "start_restaurant_exit":
		{
			AZM_start_zone("dubai_restaurant_blownup");
			music_cue("mus_enter_top_floor", 1); //dubai_dont_let_him_get_away
		}
		break;
		
		case "start_finale_chopper_sequence":
		{
			aud_print_debug("audio: start_finale_chopper_sequence");
			mm_add_submix("dubai_finale");
		}
		break;

		case "start_finale_crash_site":
		{
			aud_print_debug("audio: start_finale_crash_site");
			mm_add_submix("dubai_finale");
		}
		break;
		
		case "start_finale_beatdown":
		{
			aud_print_debug("audio: start_finale_beatdown");
		}
		break;
		

		/***********************************/
		/***** AWESOME TRIGGER HANDLERS ****/
		/***********************************/
		
		//Blend Trigger: dubai_inside_truck dubai_walkpath

		case "enter_dubai_walkpath":
		{
			zone_from = args;
		}
		break;
		
		case "exit_dubai_walkpath":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: dubai_walkpath dubai_entrance_atrium

		case "enter_dubai_entrance_atrium":
		{
			zone_from = args;
			if (zone_from == "dubai_walkpath")
			{
				aud_start_atrium_fountain();
			}
		}
		break;
		
		case "exit_dubai_entrance_atrium":
		{
			zone_to = args;
			if (zone_to == "dubai_walkpath")
			{
				thread aud_stop_atrium_fountain();
				level notify("aud_stop_alarm_monitor");
			}
		}
		break;

		//Blend Trigger: dubai_entrance_atrium dubai_first_floor

		case "enter_dubai_first_floor":
		{
			zone_from = args;
			if (zone_from == "dubai_entrance_atrium")
			{
				music_cue("mus_enter_hotel_lobby");
				thread aud_start_alarm_lobby();
			}
		}
		break;
		
		case "exit_dubai_first_floor":
		{
			zone_to = args;
			if (zone_to == "dubai_entrance_atrium")
			{
				level notify("aud_stop_alarm_monitor");
			}
		}
		break;

		//Blend Trigger: dubai_first_floor dubai_second_floor

		case "enter_dubai_second_floor":
		{
			zone_from = args;
		}
		break;
		
		case "exit_dubai_second_floor":
		{
			zone_to = args;
			if (zone_to == "dubai_second_floor")
			{
				music_cue("mus_second_floor");
			}
		}
		break;

		//Blend Trigger: dubai_second_floor dubai_second_floor_cove

		case "enter_dubai_second_floor_cove":
		{
			zone_from = args;
			if (zone_from == "dubai_second_floor")
			{
				// commenting out temorarily: music_cue("mus_pre_elevator");
				thread aud_stop_atrium_fountain();
			}
		}
		break;
		
		case "exit_dubai_second_floor_cove":
		{
			zone_to = args;
			if (zone_to == "dubai_second_floor")
			{
				aud_start_atrium_fountain();
			}
		}
		break;

		//Blend Trigger: dubai_second_floor_cove dubai_elevator

		case "enter_dubai_elevator":
		{
			zone_from = args;
			if (zone_from == "dubai_second_floor_cove")
			{
				if (flag("elevator_glass_broken"))
				{
					SM_start_preset("amb_dubi_elevator_blownout", 1);
				}
				else 
				{
					SM_start_preset("amb_dubi_elevator", 1);
					aud_disable_zone_filter();
					level.player SetEq("aircraft", 0, 0, "lowpass", 0, 1200, 2);//helicopter occlusion
					level.player SetEq("aircraft", 1, 0, "lowpass", 0, 1200, 2);//helicopter occlusion
				}
			}
		}
		break;
		
		case "exit_dubai_elevator":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: dubai_top_floor dubai_top_floor_open

		case "enter_dubai_top_floor_open":
		{
			zone_from = args;
		}
		break;
		
		case "exit_dubai_top_floor_open":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: dubai_top_floor_open dubai_top_floor_windows

		case "enter_dubai_top_floor_windows":
		{
			zone_from = args;
		}
		break;
		
		case "exit_dubai_top_floor_windows":
		{
			zone_to = args;
		}
		break;

		//Blend Trigger: dubai_top_floor_windows dubai_restaurant

		case "enter_dubai_restaurant":
		{
			zone_from = args;
		}
		break;
		
		case "exit_dubai_restaurant":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: dubai_restaurant_blownup dubai_roof

		case "enter_dubai_roof":
		{
			zone_from = args;
		}
		break;
		
		case "exit_dubai_roof":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: dubai_roof dubai_roof_stairwell

		case "enter_dubai_roof_stairwell":
		{
			zone_from = args;
		}
		break;
		
		case "exit_dubai_roof_stairwell":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: dubai_roof_stairwell dubai_roof_top

		case "enter_dubai_roof_top":
		{
			zone_from = args;
		}
		break;
		
		case "exit_dubai_roof_top":
		{
			zone_to = args;
		}
		break;
		
		/**************************/
		/***** EVENT HANDLERS *****/
		/**************************/


////////////////////////////////////////
/////********JUGGERNAUT INTRO ********/
//////////////////////////////////////
		
		case "aud_start_van_blackout_foley":
		{
			//iprintlnbold("blackout_foley_start");
			aud_play_2d_sound("dubai_intro_darkfoley");
		}
		break;
		
		case "aud_pip_open":
		{
			//iprintlnbold("pip_start");
			aud_play_2d_sound("dubai_pip_in");
			wait(8.8);
			aud_play_2d_sound("dubai_pip_out");
		}
		break;
		
		case "aud_pip_close":
		{
			//iprintlnbold("pip_done");
		}
		break;
		
		case "dubai_exit_van":
		{
			AZM_start_zone("dubai_walkpath");
		}
		break;
		
		case "bridge_suv_start_1":
		{
			vehicle = args;
			//vehicle Vehicle_TurnEngineOff();
			wait(0.2);
			//iprintlnbold("bridge_suv_01_start");
			aud_play_linked_sound("dubai_SUV_drivein_01", vehicle);
		}
		break;
		
		case "bridge_suv_start_2":
		{
			vehicle = args;
			//vehicle Vehicle_TurnEngineOff();
			wait(0.2);
			//iprintlnbold("bridge_suv_02_start");
			aud_play_linked_sound("dubai_SUV_drivein_02", vehicle);
		}
		break;
		
		case "suv_start_1":
		{
			vehicle = args;
			//vehicle Vehicle_TurnEngineOff();
			wait(0.2);
			//iprintlnbold("suv_01_start");
			aud_play_linked_sound("dubai_SUV_drivein_03", vehicle);
		}
		break;

		case "suv_start_2":
		{
			vehicle = args;
			//vehicle Vehicle_TurnEngineOff();
			wait(0.2);
			//iprintlnbold("suv_02_start");
			aud_play_linked_sound("dubai_SUV_drivein_04", vehicle);
		}
		break;
		
		case "suv_04_crash":
		{
			crash_location = args;
			wait(3.25);
			//iprintlnbold("crash_04");
			aud_play_linked_sound("dubai_SUV_crash_04", crash_location);
		}
		break;
		
		case "spawned_hotel_civilian":
		{
			guy = args;
			
			if(IsDefined( guy))
			{
				//iprintlnbold("civilian_spawners");
				guy play_loop_sound_on_entity("dub_civilian_walla");
			}
		}
		break;
		
		case "hotel_door_fall":
		{
			door = args;
			
			if(IsDefined(door))
			{
				wait(.8);
				aud_play_linked_sound("dub_hotel_doorfall", door);
			}
		}
		break;
		
//////////////////////////////////////////
//////******* ELEVATOR SECTION ********//
////////////////////////////////////////
		case "start_elevator_civ_runners":
		{
				elev_civs = args;
				if (IsArray(elev_civs))
				{
				  if(IsDefined( elev_civs[0] ))
				  {
						elev_civs[0] play_loop_sound_on_entity("dub_civilian_walla");
				  }
				}
		}
		break;
	
		case "aud_elevator_glass_destroy":
		{
			// hook into here for glass-destroy effects like changing ambience, etc.
			// the argument getting passed in is the glass entity itself. The elevator glass
			// section is done differently than glass elsewhere.
			glass = args;
			thread play_sound_in_space("glass_pane_blowout", glass.origin);
			
			if (!flag("elevator_glass_broken"))
			{
				flag_set("elevator_glass_broken");
				current_zone = AZM_get_current_zone();
				if (current_zone == "dubai_elevator")
				{
					// set blown out ambi
					SM_start_preset("amb_dubi_elevator_blownout", 1);
					//clear helicopter occlusion
					aud_enable_zone_filter();
					level.player DeactivateEq(0, "aircraft");//deactivate helicopter occlusion
					level.player DeactivateEq(1, "aircraft");
				}
			}
		}
		break;
		
		case "aud_elevator_glass_shatter":
		{
			glass = args;
			thread play_sound_in_space("glass_pane_shatter", glass.origin);
		}
		break;

		case "elevator_floor_change":
		{
			control_panel = args;

			if(!IsDefined(control_panel))
			return;
			
			if(!level.aud.first_floor_beep_played)
			{
				//Dont play a sound on the first floor beep, but set it up to play one on the next.
				level.aud.first_floor_beep_played = true;
				return;
			}
			else
			{
				aud_play_linked_sound("ele_floor_change_beep", control_panel);				
			}
		}
		break;

		case "1st_elevator_doors_open":
		{
			doors = args;
			if(!IsDefined(doors))
			return;
			
			thread play_sound_in_space("ele_bell_ring_lobby", doors.origin);
			thread play_sound_in_space("ele_doors_open_lobby", doors.origin);
		}
		break;
		
		case "1st_elevator_doors_close":
		{
			doors = args;
			elevator = getent( "elevator_initial_model", "script_noteworthy" );
			control_panel = elevator.origin + ( 78.5, -51, 82.5 );
			
			if(!IsDefined(doors))
			return;
	
			if(!level.aud.buttons_punched)
			{
				thread play_sound_in_space("ele_button_punch", control_panel);
				level.aud.buttons_punched = true;
				wait(0.25);					
			}
			
			thread play_sound_in_space("ele_doors_close_lobby", doors.origin);
			wait(2.5);
			flag_set("turn_off_cove_alarm");
			level notify("aud_stop_alarm_monitor");
			aud_delete_atrium_fountain();
		}
		break;
			
		case "1st_elevator_platform_start":
		{
			elevator = args;
			flag_set("1st_elevator_moving");		
			elevator thread aud_elevator_move("1");
		}
		break;
			
		case "1st_elevator_platform_stop":
		{
			platform = args;
			flag_clear("1st_elevator_moving");
		}
		break;
		

		case "2nd_elevator_doors_open":
		{
			doors = args;
			if(!IsDefined(doors))
			return;
			
			thread play_sound_in_space("ele_bell_ring_dry", doors.origin);
			thread play_sound_in_space("ele_doors_open_topfloor", doors.origin);
			thread aud_start_top_floor_alarms();
		}
		break;
			
		case "2nd_elevator_platform_start":
		{
			platform = args;
			platform thread aud_elevator_move("2");
			wait(8); // wait until the elevator has come down far enough to hear.
			aud_play_linked_sound("ele_ext_descend", platform);
		}
		break;
		
		case "2nd_elevator_platform_stop":
		{
			platform = args;
			flag_clear("2nd_elevator_moving");
		}
		break;	
		
		case "ambient_elevator_chopper":
		{
			heli = args;
			if(IsDefined(heli))
				heli thread aud_elevator_chopper(false);
		}
		break;		
		
		case "elevator_attack_chopper":
		{
			heli = args;
			if(IsDefined(heli))
				heli thread aud_elevator_chopper(true);
		}
		break;	
		
		case "littlebird_missile_ent_fired":
		{
			missile = args;
			if(isdefined(missile))
				missile thread play_sound_on_entity("littlebird_missile_whizby");
				missile thread aud_heli_missile_explo_watch();
		}
		break;	
		
		case "elevator_heli_crash_start": //Heli takes enough damage, starts deathspin towards elevator.
		{
			thread aud_prep_crash_slowmo();
			
			heli = args;
			

			
			if(IsDefined(heli))
			{
				heli_track = spawn("script_origin", heli.origin);
				heli_track linkto(heli);
				
				crash_01 = thread play_sound_in_space("heli_deathspin_impact", heli_track.origin);
				crash_02 = thread aud_play_linked_sound("helicopter_crash_mech", heli_track);	
				crash_03 = thread aud_play_linked_sound("helicopter_crash_engine", heli_track);
				crash_04 = thread aud_play_linked_sound("helicopter_crash_blades", heli_track);
				crash_05 = thread aud_play_linked_sound("helicopter_crash_turbine", heli_track);
				crash_06 = thread aud_play_linked_sound("heli_deathspin_secondary_explosion", heli_track);

				crash_sounds = [crash_01, crash_02, crash_03, crash_04, crash_05, crash_06]; 
				
				heli thread aud_whoosh_sweetner();
				
				flag_wait("aud_heli_crash_impact");
				
				foreach(crash_sound in crash_sounds)
				{
					if(IsDefined( crash_sound ))
						crash_sound stopsounds();
				}

			}
				
		}
		break;	
				
		case "elevator_heli_crashed": // Heli makes contact with elevator, explodes.
		{
			flag_set("aud_heli_crash_impact");
			aud_play_2d_sound("heli_explo_impact");
			aud_play_2d_sound("heli_explo_impact_lfe");	
			
			wait(0.4);
			
			aud_play_2d_sound("heli_explo_impact_debris");
			aud_delay_play_2d_sound("heli_explo_metal_tumble", 1.5, true);
			aud_delay_play_2d_sound("heli_explo_metal_groan", 2.5, true);
			
			aud_stop_monitor_player_impacts();//Tunr off armor bullet impacts because helmet is coming off
			wait(20.9); // Wait for foley section to end.

			aud_play_2d_sound("ele_crash_pre_fall_01");
		}
		break;	
				
		case "elevator_short_drop": // First short drop.
		{
			mainframe = args;  
			mm_add_submix("dubai_elevator_crash_se");
			aud_play_2d_sound("ele_crash_01_metal_snap");
			aud_play_2d_sound("ele_damage_fall_short_01");
			aud_play_2d_sound("ele_crash_01_lyr");	
					
			wait(1); // Wait for impact...
			aud_play_2d_sound("ele_crash_01_impact");
			aud_play_2d_sound("ele_crash_01_impact_lyr");	
			aud_play_2d_sound("ele_crash_01_impact_lfe");				
			wait(0.2);
			aud_play_2d_sound("elevator_crash_debris_03");	
			aud_play_2d_sound("ele_crash_pre_fall_groan");	
		}
		break;	
		
		case "elevator_big_drop": // Second Bigger Drop.
		{
			level notify("aud_restore_deathsdoor_audio");
			
			mainframe = args;  
			aud_play_2d_sound("ele_damage_fall_short_02");
			aud_play_2d_sound("ele_crash_02_lyr");
			
			wait(1); // Wait for Impact...
			aud_play_2d_sound("ele_crash_02_impact");
			wait(0.2);
			aud_play_2d_sound("ele_crash_02_impact_lyr");
			aud_play_2d_sound("elevator_crash_debris_01");	
			
			wait(1);
			aud_play_2d_sound("ele_crash_03_pre_fall");		
			
		}
		break;			
		
		case "elevator_freefall":
		{		
			elevator = args;
										
			if( !flag( "update_obj_pos_elevator_jump_complete" ) )
			{
				aud_play_2d_sound("ele_crash_03_mtl_snap_2d");
				
				metal_grind = aud_play_2d_sound("ele_freefall_grind_mtl_2d");	
				tracks = aud_play_2d_sound("ele_freefall_grind_tracks_2d");	
				ele_sfx = [metal_grind, tracks];
				
				level waittill("aud_elevator_hit_bottom_floor");
				
				foreach(sfx in ele_sfx)
				{
					if(IsDefined(sfx))
						sfx stopsounds();
				}
								
				aud_play_2d_sound("ele_freefall_death_impact");		
			}
			else
			{
				if(IsDefined( elevator ))
				{
					aud_play_linked_sound("ele_crash_03_mtl_snap_3d", elevator );	
					
					metal_grind = aud_play_linked_sound("ele_freefall_grind_mtl_3d", elevator );	
					tracks = aud_play_linked_sound("ele_freefall_grind_tracks_3d", elevator);
					ele_sfx = [metal_grind, tracks];	
					
					level waittill("aud_elevator_hit_bottom_floor"); // Wait for elevator to crash, then stop falling sfx.
					
					thread play_sound_in_space("ele_freefall_death_impact_3d", elevator.origin);
					
					foreach(sfx in ele_sfx)
		{
						if(IsDefined(sfx))
							sfx stopsounds();
					}		
					
				}
			}
			mm_clear_submix("dubai_elevator_crash_se");
		}
		break;
		
		case "aud_elevator_fail_fall":   // If player dosent jump fast enough, elevator falls all the way to the first floor.
		{
			level notify("aud_elevator_hit_bottom_floor");
		}
		break;	
		
		case "elevator_fire_start":
		{
			elevator_origin = args;
			//iprintlnbold("elevator_fire_start");
			DAMB_start_preset_at_point("fire_wood_med_tight", (elevator_origin + (-100, -100, 150)), "elevator_01", 1000, 1.0);//elevator
			DAMB_start_preset_at_point("fire_wood_med", (elevator_origin + (-100, -100, 150)), "elevator_02", 1000, 1.0);//elevator
			DAMB_start_preset_at_point("fire_wood_med", (elevator_origin + (-100, -100, 151)), "elevator_03", 1000, 1.0);//elevator
		}
		break;	
		
		case "start_yuri_fire":
		{
			//iprintlnbold("start yuri fire");
			DAMB_start_preset_at_point("fire_wood_med", level.yuri.origin, "yuri_01", 1000, 1.0);//yuri
			DAMB_start_preset_at_point("fire_wood_med_tight", level.yuri.origin, "yuri_02", 1000, 1.0);//yuri
		}
		break;
		
		case "stop_yuri_fire":
		{
			//iprintlnbold("stop yuri fire");
			DAMB_stop_preset_at_point("fire_wood_med", "yuri_01", 5);//yuri
			DAMB_stop_preset_at_point("fire_wood_med_tight", "yuri_02", 5);//yuri
		}
		break;
		
		case "yuri_remove_armor": // notetrack message
		{
			aud_delay_play_2d_sound("dubai_elevse_yuri_remove_plr_armor", 1.9);
			aud_delay_play_2d_sound("dubai_elevse_yuri_remove_plr_armor_vo", 4.7);
		}
		break;
		
////////////////////////////////////////
/////***** Top Floor Restaurant ******/
//////////////////////////////////////		
	
		case "top_floor_ambient_chopper":
		{
			if(!Isdefined(args))
				return;
				
			flyby_long = aud_play_linked_sound("restaurant_heli_01_flyby_long", args);	
			fly_in = aud_play_linked_sound("restaurant_heli_01_flyin", args);

		}
		break;
		
		case "restaurant_chopper":
		{
			if(!Isdefined(args))
				return;
			fly_in = aud_play_linked_sound("restaurant_heli_02_flyin_fast", args);
			fly_in_02 = aud_play_linked_sound("restaurant_heli_02_flyin", args);			
			fly_in scalevolume(0);
			wait(0.05);
			fly_in scalevolume(1, 1);
			wait(0.3);
			thread VM_start_preset("restaurant_chopper", "dubai_littlebird", args);
			
			level waittill("aud_start_restaurant_destruction");
			
			// Stop vehicle system when the restaurant destruction seuqence begins.
			thread VM_stop_preset_instance( "restaurant_chopper", 3.0 );
		}
		break;
		
		case "restaurant_destruction":
		{
			level notify("aud_start_restaurant_destruction");
			
			music_cue("mus_restaurant_destruction");
		}
		break;
		
		case "restaurant_destruction_begin":
		{
			//iprintln("restaurant_destruction_begin");
		}

		case "restaurant_chopper_fire_rocket":
		{
			if (!IsDefined(level.aud.aud_restaurant_destruction))
			{
				level.aud.aud_restaurant_destruction = true;
				//iprintlnbold("SETUP:  restaurant_destruction");
				AZM_start_zone("dubai_restaurant_destruction", 0.05);
				flag_set("turn_off_top_floor_alarm");
			}
			
			rocket = args;
			if(IsDefined(rocket))
			{
				rocket thread play_sound_on_entity("restaurant_rocket_whizby");
				if (IsDefined(level.aud.aud_restaurant_stray_rockets))
				{
					rocket waittill( "death" ); 
					aud_play_2d_sound("restaurant_rocket_impact");
				}
			}
		}
		break;
		
		case "restaurant_destruction_end":
		{
			//iprintln("restaurant_destruction_end");
		}
		break;
		
////////////////////////////////////////
/////************ FINALE *************/
//////////////////////////////////////		
		
		case "finale_se":
		{
			assert(IsString(args));
			//iprintlnbold("---->MUSIC FINALE: " + args);
			
			switch (args)
			{
				case "start_run":
					//iprintlnbold("---->FINALE: " + args);
					music_cue("mus_finale_run_to_heli");
				
				break;

				case "start_helo_sequence":
					//iprintlnbold("---->FINALE: " + args);
					thread aud_finale_helifire_start();
					music_cue("mus_finale_heli_sequence");
				break;

				case "start_chopper_fire_amb":
					//iprintlnbold("chopper_fire");
					wait(2);
					aud_play_2d_sound("dub_finale_helifire_amb");
				break;
				
				case "start_crawl":
					//iprintlnbold("---->FINALE: " + args);
					music_cue("mus_finale_crawl");
				break;

				case "start_showdown":
					//iprintlnbold("---->FINALE: " + args);
					music_cue("mus_finale_showdown");
				break;

				case "start_beatdown":
					//iprintlnbold("---->FINALE: " + args);
					music_cue("mus_finale_beatdown");
					play_loopsound_in_space("dub_finale_helifire_amb_lp", (637, -228, 8144));
				break;

				case "start_hanging":
					//iprintlnbold("---->FINALE: " + args);
					music_cue("mus_finale_hanging");
					DelayThread(18.0, ::aud_play_2d_sound, "dub_finale_makhang_creaks");
				break;

				case "start_stranger":
					music_cue("mus_start_stranger");
					wait(2.55);
					level.player thread aud_prime_stream("dub_finale_shadowman_enter", true);
					wait(1);
					aud_play_2d_sound("dub_finale_shadowman_enter");
					wait(16.18);
					exit_ent = spawn("script_origin", level.player.origin);
					exit_ent thread aud_prime_stream("dub_finale_shadowman_exit", true);
					wait(1);
					aud_play_2d_sound("dub_finale_shadowman_exit");
				break;
				
				case "finale_fail":
					//iprintlnbold("---->FINALE: " + args);
					music_cue("mus_finale_fail");
				break;			

				default:
					// Intentionally ignore here (so we don't get an unhandled audio msg warning).
				break;
			}
		}
		break;
		
		
		case "start_finale_chopper":
		{
			finale_chopper = args;
			
			if(!Isdefined(finale_chopper))
				return;
				
			thread aud_play_2d_sound("dub_chopper_roofwind");
			finale_chopper playsound("dub_chopper_distant");
			finale_chopper playloopsound("dub_mak_heli_lp");
		}
		break;
		
		case "finale_jump_succesful":
		{
			flag_set("aud_finale_jump_succesful");
			finale_chopper = args;
			aud_delay_play_2d_sound("dub_chopper_crash_turbine", 21, true);
			if(!Isdefined(finale_chopper))
				return;
			
			finale_chopper stoploopsound("dub_mak_heli_lp");
		}
		break;
		
		case "makarov_doorclose":
		{
			makarov = args;
			wait(5);
			
			if(IsDefined( makarov ))
				makarov playsound("dub_chopper_doorclose");
			
		}
		break;
		
		case "player_chopper_stab": //notetrack message
		{
			thread aud_play_2d_sound("dub_chopper_stab_clear");
			aud_delay_play_2d_sound("dub_chopper_stab_clear_gun_swtnr", 1);
		}
		break;
		
		case "player_chopper_throwguy": //notetrack message
		{
			thread aud_play_2d_sound("dub_finale_chopperthrow_vo");
		}
		break;
		
		case "set_stick":
		{
			stick_pos = args;
			aud_handle_stick_pos(stick_pos);
		}
		break;
		
		case "chopper_crash_finale":
		{
			mm_add_submix("dubai_finale");
			
			thread aud_play_2d_sound("finale_crash_impact_punch");
			thread aud_play_2d_sound("finale_crash_impact_heli_hit_ground");
			wait(0.3);
			thread aud_play_2d_sound("finale_crash_shake_01");	
			wait(0.2);
			thread aud_play_2d_sound("finale_crash_shake_02");	
			wait(0.2);
			thread aud_play_2d_sound("finale_crash_shake_03");		
		}
		break;		
		
		
		case "makarov_kneel": // notetrack message
		{
			thread aud_play_2d_sound("dub_finale_mak_kneel");
			thread aud_play_2d_sound("dub_finale_mak_kneel_vo");
		}
		break;
		
		case "makarov_fail_getgun":
		{
			//iprintlnbold("failstart");
			wait(7.1);
			aud_play_2d_sound("dub_finale_makgungrab_failstate");
			wait(2.3);
			aud_play_2d_sound("dub_finale_mak_gunraise");
			wait(.2);
			aud_play_2d_sound("dub_mak_failstate_01");
		}
		break;
		
		case "finale_shoot_makarov": // notetrack message
		{
			thread aud_play_2d_sound("dub_finale_shoot_mak");
			thread aud_play_2d_sound("dub_finale_shoot_mak_sweet");
			aud_delay_play_2d_sound("dub_finale_shoot_mak_vo", 0.15);
		}
		break;
		
		case "finale_showdown_fail":
		{
			//iprintlnbold("start_showdown_gunshot");
			wait(.7);
			aud_play_2d_sound("dub_mak_failstate_01");
		}
		break;
		
		case "finale_mak_shoots_failstate":
		{
			//iprintlnbold("mak_shoot_start");
			aud_play_2d_sound("dub_mak_failstate_02");
		}
		break;
		
		case "getup_vo": //notetrack message
		{
			thread aud_play_2d_sound("dub_finale_price_getup_vo");
			//iprintlnbold("getup");
		}
		break;
		
		case "punch1_2_vo": //notetrack message
		{
			thread aud_play_2d_sound("dub_finale_price_punch1_2_vo");
			//iprintlnbold("punch12");
		}
		break;
		
		case "punch_3_vo": //notetrack message
		{
			thread aud_play_2d_sound("dub_finale_price_punch_3_vo");
			//iprintlnbold("punch3");
		}
		break;
		
		case "slam1_vo": //notetrack message
		{
			thread aud_play_2d_sound("dub_finale_price_slam1_vo");
			//iprintlnbold("slam1");
		}
		break;
		
		case "choke_vo": //notetrack message
		{
			wait(.5);
			thread aud_play_2d_sound("dub_finale_price_choke_vo");
			//iprintlnbold("choke");
		}
		break;
		
		case "slam2_vo": //notetrack message
		{
			wait(.2);
			thread aud_play_2d_sound("dub_finale_price_slam2_vo");
			//iprintlnbold("slam2");
		}
		break;
		
		case "slam3_vo": //notetrack message
		{
			thread aud_play_2d_sound("dub_finale_price_slam3_vo");
			//iprintlnbold("slam3");
		}
		break;
		
		case "play_credits_music":
		{
			music_cue("mus_play_credits_music_from_front_end");
		}
		break;
		
		default:
		{
			msg_handled = false;
		}
	}

	return msg_handled;
}


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
			MUS_play("dubai_intro", 5);
		}
		break;

		case "mus_first_combat":
		{
			wait(0.2);
			aud_set_music_submix(1000, 0.1);
			MUS_play("dubai_first_combat", 1);
			wait(2);
			aud_set_music_submix(1, 30);
		}
		break;

		case "mus_enter_hotel_lobby":
		{
			MUS_play("dubai_enter_hotel", 5);
			wait(4);
			aud_set_music_submix(1, 2);
			wait(1);
			MUS_play("dubai_intro", 5);
		}
		break;

		case "mus_board_escalator":
		{
			MUS_play("dubai_board_escalator", 10);
		}
		break;

//		case "mus_second_floor":
//		{
//			// Not used at this time.
//		}
//		break;
//		
//		case "mus_pre_elevator":
//		{
//			// Not used at this time.
//		}
//		break;
		
		case "mus_elevator_button_pressed":
		{
			MUS_stop(10);	//MUS_play("dubai_enter_elevator", 5);
		}
		break;

//		case "mus_elevator_battle":
//		{
//			// Not used at this time.
//		}
//		break;
		
		case "mus_elevator_heli_attack":
		{
			MUS_stop(1);
		}
		break;

		case "mus_elevator_heli_crash":
		{
			wait(2);
			MUS_play("dubai_elevator_heli_crash", 5);
			wait(10);
			MUS_play("dubai_drone_d_med", 5);
			wait(5);
			MUS_stop(10);
		}
		break;	

//		case "mus_elevator_heli_yuri_jump":
//		{
//			// Not used at this time.
//		}
//		break;

		case "mus_elevator_heli_player_jump":
		{
			aud_set_music_submix(100,0.5);
			MUS_play("dubai_elevator_heli_player_jump", 0);
			wait(5);
			aud_set_music_submix(1, 2);
			MUS_play("dubai_enter_elevator", 6); //MUS_play("dubai_drone_d_med", 6);
		}
		break;

		case "mus_enter_top_floor":
		{
			wait(1);
			MUS_play("dubai_enter_top_floor", 0);
		}
		break;
		
		case "mus_restaurant_destruction":
		{
			MUS_stop(1);
		}
		break;

		case "mus_restaurant_pillar_explodes":
		{
			MUS_play("dubai_restaurant_pillar_explodes", 5);
		}
		break;

		case "mus_dont_let_him_get_away":
		{
			aud_set_music_submix(100, 1);	// Leave it up for rest of the level.
			MUS_play("dubai_dont_let_him_get_away", 0.2, 3);
		}
		break;

		case "mus_finale_run_to_heli":
		{
			wait(1);
			MUS_play("dubai_finale_run_to_heli", 2);
		}
		break;

		case "mus_finale_heli_sequence":
		{
			MUS_play("dubai_finale_heli_sequence", 5);
		}
		break;
		
		case "mus_finale_crawl":
		{
			MUS_play("dubai_finale_crawl", 5);
		}
		break;
		
		case "mus_finale_showdown":
		{
			MUS_play("dubai_finale_showdown", 5);
		}
		break;

		case "mus_finale_beatdown":
		{
			MUS_play("dubai_finale_beatdown", 5);
		}
		break;
		
		case "mus_finale_hanging":
		{
			MUS_play("dubai_finale_hanging", 5);
			wait(65.8); 								// Wait for music to end.
			
			wait(8); 									// Leave music out an imtimate moment.
			MUS_play("dubai_finale_roll_credits", 5);	// Start credits music over picture.
			
			flag_wait("atvi_credits_go");				// Wait for fade to black and credits to roll.
			mm_add_submix("dubai_credits", 7);			// Apply the credits roll mix.
		}

//		case "mus_finale_hanging":
//		{
//			MUS_play("dubai_finale_hanging", 5);
//			
//			flag_wait("atvi_credits_go");
//			MUS_play("dubai_finale_roll_credits", 5);
//			wait(25);
//			mm_add_submix("dubai_credits", 7);
//		}
//		break;

		case "mus_play_credits_music_from_front_end":
		{
			MUS_play("dubai_finale_roll_credits", 0);
		}
		break;
		
		case "mus_start_stranger":
		{
			MUS_stop(10);
			wait(6);
			MUS_play("dubai_finale_stranger_appears", 5);
		}
		break;
		
		case "mus_finale_fail":
		{
			MUS_play("shg_fail_stinger", 0, 1);
		}
		break;
		
		default:
		{
			msg_handled = false;
		}
	}

	return msg_handled;
}

aud_clear_truck_submix_monitor()
{
	wait(1);
	level.player seteq("weapon", 0, 0, "lowpass", 0, 1000, 1);
	level.player seteq("weapon", 1, 0, "lowpass", 0, 1000, 1);

	level.player seteq("bulletimpact", 0, 0, "lowpass", 0, 5000, 1);
	level.player seteq("bulletimpact", 1, 0, "lowpass", 0, 5000, 1);

	level.player seteq("bulletwhizby", 0, 0, "lowpass", 0, 400, 1);
	level.player seteq("bulletwhizby", 1, 0, "lowpass", 0, 400, 1);
	
	wait(39);
	
	level.player deactivateeq(0, "weapon");
	level.player deactivateeq(1, "weapon");
	level.player deactivateeq(0, "bulletimpact");
	level.player deactivateeq(1, "bulletimpact");
	level.player deactivateeq(0, "bulletwhizby");
	level.player deactivateeq(1, "bulletwhizby");

	MM_clear_submix("dubai_inside_truck", 1.0);
}

aud_monitor_player_impacts()
{
	level endon("aud_stop_player_impacts");
	
	while(true)
	{
		level.player waittill( "damage", amount, attacker, direction, point, damage_type );
		level.player playsound("armor_impact");
		// play armor impact sound that is *not* on impact_plr volmod
	}
}

aud_stop_monitor_player_impacts()
{
	level notify("aud_stop_player_impacts");
}

aud_start_outside_fountain()
{
	wait(0.05);
	if (!IsDefined(level.aud.outside_fountain_ent))
	{
		level.aud.outside_fountain_ent = spawn("script_origin", (0,0,0));
		assert(isArray(level.aud.outside_fountain_pts));
		level.aud.outside_fountain_ent aud_play_distributed_sound("dubai_water_fountain_lp", level.aud.outside_fountain_pts, 20, 0, 200);
	}
	else
	{
		level.aud.outside_fountain_ent aud_start_distributed_sound();
	}
}

aud_stop_outside_fountain()
{
	if (IsDefined(level.aud.outside_fountain_ent))
	{
		level.aud.outside_fountain_ent aud_stop_distributed_sound();
	}
}

aud_delete_outside_fountain()
{
	if (IsDefined(level.aud.outside_fountain_ent))
	{
		level.aud.outside_fountain_ent delete();
	}
}

aud_start_atrium_fountain()
{
	wait(0.1);
	if (!IsDefined(level.aud.fountain_ent))
	{
		level.aud.fountain_ent = spawn("script_origin", (0,0,0));
		assert(IsArray(level.aud.fountain_pts));
		level.aud.fountain_ent aud_play_distributed_sound("dubai_water_fountain_center_lp", level.aud.fountain_pts, 20, 250, 350);
		
		level.aud.fountain_side_ent = spawn("script_origin", (0,0,0));
		assert(IsArray(level.aud.fountain_pts_sides)); 
		level.aud.fountain_side_ent aud_play_distributed_sound("dubai_water_fountain_sides_lp", level.aud.fountain_pts_sides, 10, 200, 300);
	}
	else
	{
		level.aud.fountain_ent aud_start_distributed_sound();
		level.aud.fountain_side_ent aud_start_distributed_sound();
	}
}

aud_stop_atrium_fountain()
{
	if (IsDefined(level.aud.fountain_ent))
	{
		level.aud.fountain_ent aud_stop_distributed_sound();
		level.aud.fountain_side_ent aud_stop_distributed_sound();
	}
}

aud_delete_atrium_fountain()
{
	if (IsDefined(level.aud.fountain_ent))
	{
		level.aud.fountain_ent delete();
		level.aud.fountain_side_ent delete();
	}				
}

aud_start_lobby_alarms()
{
	entrance_alarm = spawn("script_origin", (1934, 42, 220));
	pre_cove_alarm = spawn("script_origin", (282, 2, 524));
	entrance_alarm thread play_loop_sound_on_entity("dubai_hotel_alarm_bell_entrance");
	pre_cove_alarm thread play_loop_sound_on_entity("dubai_hotel_alarm_bell");

	flag_wait("turn_off_cove_alarm");
	
	pre_cove_alarm thread stop_loop_sound_on_entity("dubai_hotel_alarm_bell");
	entrance_alarm thread stop_loop_sound_on_entity("dubai_hotel_alarm_bell_entrance");
	pre_cove_alarm delete();
	entrance_alarm delete();
}

aud_start_top_floor_alarms()
{
	entrance_alarm = spawn("script_origin", (-428, -4, 7931));
	pre_cove_alarm = spawn("script_origin", (1205, -934, 7905));
	side_room_alarm = spawn("script_origin", (1216, 961, 7905));
	entrance_alarm thread play_loop_sound_on_entity("dubai_hotel_alarm_bell_entrance");
	side_room_alarm thread play_loop_sound_on_entity("dubai_hotel_alarm_bell_entrance");
	pre_cove_alarm thread play_loop_sound_on_entity("dubai_hotel_alarm_bell_entrance");

	flag_wait("turn_off_top_floor_alarm");
	
	entrance_alarm thread stop_loop_sound_on_entity("dubai_hotel_alarm_bell_entrance");
	side_room_alarm thread stop_loop_sound_on_entity("dubai_hotel_alarm_bell_entrance");
	pre_cove_alarm thread stop_loop_sound_on_entity("dubai_hotel_alarm_bell_entrance");
	entrance_alarm delete();
	side_room_alarm delete();
	pre_cove_alarm delete();
}

// when the elevator starts to fall (screeech!)
aud_elevator_drop()
{
	flag_wait( "drop_player_elevator" );
	//IPrintLnBold("AUDIO: ELEVATOR CRASH START");
}

aud_elevator_jump()
{
	level waittill("player_elevator_jump_successul");
	//iprintlnbold("AUDIO: JUMP START");
}

// when the elevator hits the ground, could be variable
aud_elevator_crash(crash_pos)
{
	//iprintlnbold("AUDIO: ELEVATOR CRASH END");
}

// elevator stops at top floor after the helicopter crash sequence
aud_elevator_stopped()
{
	flag_wait("player_at_top_floor");
	AZM_start_zone("dubai_top_floor");
}

aud_elevator_chopper(is_attack_chopper)
{
	if(!Isdefined(self))
	return;
	
	if(is_attack_chopper)
	{
		thread aud_play_linked_sound("elevator_littlebird_approach", self);
		thread aud_fade_sound_in(self, "littlebird_move", 1, 3.0, true);			
	}
	else
	{
		wait(3);
		thread aud_play_linked_sound("elevator_littlebird_02_dist_flyby", self);			
	}
}

aud_elevator_move(elevator_number)
{
	if(!IsDefined(self))
	return;
	
	if(elevator_number == "1")
	{
		aud_play_2d_sound("ele_move_startup_2d");
		elevator_move = aud_play_linked_sound("ele_move_loop_2d", level.player, "loop", "aud_stop_elevator_movement");
		elevator_move Scalevolume(0.0);
		wait(0.05);
		elevator_move ScaleVolume(1, 2);
		flag_waitopen("1st_elevator_moving");
		elevator_move ScaleVolume(0, 1.5);	
	}
	else
	{
		flag_wait("player_jumped_to_replacement_elevator");
		aud_play_2d_sound("ele_move_startup_02_2d");
		elevator_move = aud_play_linked_sound("ele_move_loop_2d", level.player, "loop", "aud_stop_elevator_movement");
		elevator_move Scalevolume(0.0);
		wait(0.05);
		elevator_move ScaleVolume(1, 2);
		thread aud_elevator_oneshots();
		flag_wait("player_at_top_floor");
		elevator_move ScaleVolume(0, 1.5);	
	}
}	

aud_elevator_oneshots()
{
	wait(1.5);
	aud_play_2d_sound("ele_metal_knocking_01_2d");
}

aud_heli_missile_explo_watch()
{
	if(IsDefined(self))
	{
		self waittill( "explode", origin );
		thread play_sound_in_space("littlebird_missile_big", origin);	
	}
}

audx_start_alarm_internal_lobby(ent_2d)
{
	level endon("aud_stop_alarm_monitor");

	alarm_pos = (1420,0,225);
	max_dist = 1000; // decide on max distance

	while(true)
	{
		dist = distance(alarm_pos, level.player.origin);
		vol = dist / max_dist;
		vol = 1 - clamp(vol, 0, 1);
		ent_2d scalevolume(vol, 0.1);
		wait(0.1);
	}
}

aud_start_alarm_lobby()
{
	ent_2d = spawn("script_origin", (0,0,0));
	ent_3d = spawn("script_origin", (665,12,800));
	
	thread audx_play_alarms_and_announcer(ent_2d,ent_3d);
	
	ent_2d scalevolume(0);
	
	wait(0.05);

	// synchronously loop to monitor player position
	audx_start_alarm_internal_lobby(ent_2d);
	
	// clean up
	ent_2d stoploopsound();
	ent_3d stoploopsound();
	
	wait(0.05);
	ent_2d delete();
	ent_3d delete();
}

audx_play_alarms_and_announcer(ent_2d,ent_3d)
{
	level endon("aud_stop_alarm_monitor");
	
	while(true)
	{
		ent_2d playsound("dubai_hotel_alarm_wet", "alarm_01_done"); 
		ent_3d playsound("dubai_hotel_alarm_dry");
		ent_2d waittill("alarm_01_done");
		ent_2d playsound("dubai_hotel_alarm_wet", "alarm_02_done"); 
		ent_3d playsound("dubai_hotel_alarm_dry");
		ent_2d waittill("alarm_02_done");
		ent_2d playsound("dubai_hotel_announce_wet_us", "announcer_01_done");
		ent_3d playsound("dubai_hotel_announce_dry_us");
		ent_2d waittill("announcer_01_done");
		ent_2d playsound("dubai_hotel_alarm_wet", "alarm_03_done"); 
		ent_3d playsound("dubai_hotel_alarm_dry");
		ent_2d waittill("alarm_03_done");
		ent_2d playsound("dubai_hotel_alarm_wet", "alarm_04_done"); 
		ent_3d playsound("dubai_hotel_alarm_dry");
		ent_2d waittill("alarm_04_done");
		ent_2d playsound("dubai_hotel_announce_wet_us", "announcer_02_done");
		ent_3d playsound("dubai_hotel_announce_dry_us");
		ent_2d waittill("announcer_02_done");
	}
}

aud_prep_crash_slowmo()
{
	aud_disable_deathsdoor_audio();
	soundsettimescalefactor("norestrict2d", 0);
	soundsettimescalefactor("norestrict", 0);
	soundsettimescalefactor("grondo2d", 0);
	soundsettimescalefactor("grondo3d", 0);
	soundsettimescalefactor("voice", 0);
	soundsettimescalefactor("music", 0);
	soundsettimescalefactor("mission", 0);	
	soundsettimescalefactor("critical", 0);
	soundsettimescalefactor("announcer", 0);	
	
	level waittill("aud_restore_deathsdoor_audio");
	aud_enable_deathsdoor_audio();	
}

aud_whoosh_sweetner()
{
	level endon("aud_heli_whoosh_played");
	
	if(!IsDefined(self))
	 return;
	
	while(1)
	{
		dist = distance(self.origin, level.player.origin);

		if( dist < 1000 && level.aud.heli_death_whoosh_played == false)
		{
			level.aud.heli_death_whoosh_played = true;	
			
			if(IsDefined(self))
			{
				heli_whoosh = thread aud_play_linked_sound("heli_deathspin_explo_whoosh_sweetner", self);
//				heli_whoosh scalevolume(0);
//				wait(0.05);
//				heli_whoosh scalevolume(1, 0.5);
				
				flag_wait("aud_heli_crash_impact");	
				
				if(IsDefined(heli_whoosh))
					heli_whoosh stopsounds();
				
				level notify("aud_heli_whoosh_played");
			}
		}
		wait(0.05);
	}		
}

aud_finale_helifire_start()
{
	DAMB_start_preset_at_point("fire_rock_lrg", (-648, 252, 8148), "helicopter_01", 1000, 1.0);//finale heli
	DAMB_start_preset_at_point("fire_wood_med", (-648, 258, 8140), "helicopter_02", 1000, 1.0);//finale heli 2
}

aud_restaurant_fire_start()
{
	//Destroyed Restaurant Fire
	DAMB_start_preset_at_point("fire_wood_med_tight", (-945, -415, 7722), "restaurant_01", 1000, 1.0);//behind player
	DAMB_start_preset_at_point("fire_wood_med_tight", (-1111, -264, 7643), "restaurant_02", 1000, 1.0);//behind player
	DAMB_start_preset_at_point("fire_wood_med_tight", (-935, -135, 7711), "restaurant_03", 1000, 1.0);//right of player
	DAMB_start_preset_at_point("fire_wood_med_tight", (-1073, 112, 7656), "restaurant_04", 1000, 1.0);//front left of player
	DAMB_start_preset_at_point("fire_wood_med_tight", (-1037, 164, 7656), "restaurant_05", 1000, 1.0);//front left/right of player
	DAMB_start_preset_at_point("fire_wood_med_tight", (-918, 152, 7729), "restaurant_06", 1000, 1.0);//front right
	DAMB_start_preset_at_point("fire_wood_med_tight", (-804, -116, 7779), "restaurant_07", 1000, 1.0);//path right
	DAMB_start_preset_at_point("fire_wood_med_tight", (-811, -28, 7901), "restaurant_08", 1000, 1.0);//path ceiling
	DAMB_start_preset_at_point("fire_wood_med_tight", (-813, 80, 7901), "restaurant_09", 1000, 1.0);//path ceiling 2
	DAMB_start_preset_at_point("fire_wood_med_tight", (-786, 420, 7784), "restaurant_10", 1000, 1.0);//pre stairs left
	DAMB_start_preset_at_point("fire_wood_med_tight", (-55, 201, 7966), "restaurant_11", 1000, 1.0);//pre stairs right
}

aud_restaurant_dest_point_damb()
{
	DAMB_start_preset_at_point("dubai_restaurant_blownup_point_01", (-302, 400, 8012), "blownup_point_01", 1000, 1.0);	
	DAMB_start_preset_at_point("dubai_restaurant_blownup_point_02", (-65, -264, 8001), "blownup_point_02", 1000, 1.0);	
	DAMB_start_preset_at_point("dubai_restaurant_blownup_point_03", (-805, 403, 7849), "blownup_point_03", 1000, 1.0);	
	
	flag_wait("aud_finale_jump_succesful");
	
	DAMB_stop_preset_at_point("dubai_restaurant_blownup_point_01", "blownup_point_01", 3);
	DAMB_stop_preset_at_point("dubai_restaurant_blownup_point_02", "blownup_point_02", 3);	
	DAMB_stop_preset_at_point("dubai_restaurant_blownup_point_03", "blownup_point_03", 3);	
}

aud_stop_slomo_scaling()
{
	soundsettimescalefactor("norestrict2d", 0);
	soundsettimescalefactor("norestrict", 0);
	soundsettimescalefactor("grondo2d", 0);
	soundsettimescalefactor("grondo3d", 0);
}

aud_handle_stick_pos(stick_pos)
{
	if (!IsDefined(level.aud.stick_pos_sound_played))
	{
		level.aud.stick_pos_sound_played = false;
	}
	
	rad = sqrt(stick_pos[0]*stick_pos[0] + stick_pos[1]*stick_pos[1]);
	threshold = 0.5;
	if (rad > threshold)
	{
		if (!level.aud.stick_pos_sound_played)
		{
			level.aud.stick_pos_sound_played = true;
			level.player playsound("dub_chopper_stick_move");
			//iprintlnbold("stick");
		}
	}
	else
	{
		level.aud.stick_pos_sound_played = false;
	}
}

aud_restaurant_exploders()
{
	thread aud_wait_till_explode_breach(150);//First Rocket Impact (knocks player down)
	thread aud_wait_till_explode(151);//Second impact (quick and small)
	thread aud_wait_till_explode(152);//Fireball Start
	thread aud_wait_till_restaurant_explode(153);//Big Explosion with lots of debris
	thread aud_wait_till_collumn_explode(191);//Column Explode
	
//	thread aud_wait_till_explode(500);//Big Explosion with lots of debris
//	thread aud_wait_till_explode(300);//Big Explosion with lots of debris
//	thread aud_wait_till_explode(250);//Big Explosion with lots of debris
//	thread aud_wait_till_explode(190);//Big Explosion with lots of debris
//	thread aud_wait_till_floor_collapse(600);//Floor Collapse
}

aud_wait_till_explode(num)
{
	level waittill("exploding_" + num);
	//iprintlnbold("EXPLODER: " + num);
	aud_play_2d_sound("restaurant_rocket_impact");
}

aud_wait_till_explode_breach(num)
{
	level waittill("exploding_" + num);
	//iprintlnbold("EXPLODER: " + num);
	aud_play_2d_sound("restaurant_breach_transient");

	aud_delay_play_2d_sound("restaurant_breach_explo_front", 0.05, true);

	aud_delay_play_2d_sound("restaurant_breach_bodyfall", 2.00, true);
}

aud_wait_till_restaurant_explode(num)
{
	level waittill("exploding_" + num);
	//iprintlnbold("EXPLODER: " + num);
	level.aud.aud_restaurant_stray_rockets = true;
	aud_play_2d_sound("restaurant_big_explo_main");

	aud_delay_play_2d_sound("restaurant_heli_se_01", 0.863, true);
}

aud_wait_till_collumn_explode(num)
{
	level waittill("exploding_" + num);
	//iprintlnbold("EXPLODER: " + num);
	aud_play_2d_sound("restaurant_column_explo_main");

	aud_delay_play_2d_sound("restaurant_column_explo_front", 0.5, true);

	aud_delay_play_2d_sound("restaurant_drop_whoosh_short", 1.4, true);
	
	aud_delay_play_2d_sound("restaurant_drop_imp_front", 1.663, true);

	aud_delay_play_2d_sound("restaurant_drop_imp_blast", 1.783, true);

	aud_delay_play_2d_sound("restaurant_drop_lfe", 1.8, true);

	aud_delay_play_2d_sound("restaurant_drop_crack", 1.8, true);

	aud_delay_play_2d_sound("restaurant_drop_slide_debris", 2.030, true);
	
	aud_delay_play_2d_sound("restaurant_drop_slide_front", 3.101, true);

	aud_delay_play_2d_sound("restaurant_wine_bottle_roll", 4.78, true);
	
	aud_delay_play_2d_sound("restaurant_city_wind", 5.905, true);

	aud_delay_play_2d_sound("restaurant_player_over_edge", 6.075, true);

	aud_delay_play_2d_sound("restaurant_cable_grab_front", 7.018, true);

	aud_delay_play_2d_sound("restaurant_hand_grip_front", 7.513, true);

	aud_delay_play_2d_sound("restaurant_heli_se_02", 7.83, true);
		
	aud_delay_play_2d_sound("restaurant_grabledge", 12.003, true);
	
	aud_delay_play_2d_sound("restaurant_getup_02", 16.523, true);

		
	wait(10);
	thread aud_restaurant_fire_start();
	thread aud_restaurant_dest_point_damb();
	AZM_start_zone("dubai_restaurant_blownup", 2);
}
