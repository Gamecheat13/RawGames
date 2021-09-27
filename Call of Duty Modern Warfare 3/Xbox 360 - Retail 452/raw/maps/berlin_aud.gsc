#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_audio;
#include maps\_audio_zone_manager;
#include maps\_audio_mix_manager;
#include maps\_audio_music;
#include maps\_audio_dynamic_ambi;
#include maps\_audio_vehicles;

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
}	
	
/*********************************************************************
	Level Init Support Functions.
********************************************************************/
aud_precache_presets()
{
	MM_precache_preset("berlin_level_global_mix");
	MM_precache_preset("berlin_artillery_ambush_shock");
	MM_precache_preset("berlin_intro_flight");
	MM_precache_preset("berlin_chopper_landing");
	MM_precache_preset("berlin_aa_building");
	MM_precache_preset("berlin_aa_building_stairwell");
	MM_precache_preset("berlin_rooftops_sniping");
	MM_precache_preset("berlin_granite_heli_by");
	MM_precache_preset("berlin_post_rappel");
	MM_precache_preset("berlin_street_bridge_tanks");
	MM_precache_preset("berlin_ally_tanks");
	MM_precache_preset("berlin_tank_shock");
	MM_precache_preset("berlin_building_collapse");
	MM_precache_preset("berlin_building_collapse_transition");
	MM_precache_preset("berlin_artillery_ambush");
	MM_precache_preset("berlin_artillery_ambush_off");
	MM_precache_preset("berlin_artillery_ambush_on");
	MM_precache_preset("berlin_collapse_aftermath");
	MM_precache_preset("berlin_street_prehotel");
	MM_precache_preset("berlin_hotel");
	MM_precache_preset("berlin_reverse_breach_setup");
	MM_precache_preset("berlin_reverse_breach");
	MM_precache_preset("berlin_pistol_boost");
	MM_precache_preset("berlin_finale");
}	

aud_config_system()
{
	set_stringtable_mapname("shg");
	aud_set_occlusion("med_occlusion"); // new way to do it, which uses string tables
	aud_set_timescale();
	MM_add_submix("berlin_level_global_mix");
}

aud_init_flags()
{
	flag_init("aud_all_clear");
	flag_init("aud_start_deadbird_sounds");
	flag_init("aud_intro_flight_landed");
	flag_init("aud_kill_ally_tanks");
	flag_init("aud_stop_fake_tanks");
	flag_init("aud_dist_tank_battle");
	flag_init("first_attack_chopper_spawned");
	flag_init("aud_ibeam_fall_complete");
}

aud_init_globals()
{
	level.aud = SpawnStruct();	
	level.aud.collapse_stinger = false;
}

aud_launch_threads()
{	
	if (aud_is_specops())
		return;

	// Slow motion settings.
	thread aud_ignore_slowmo();
	
	// Tanks
	thread aud_fake_tank_battle();
	
	// Environment Emitters
	thread aud_start_water();
	thread aud_start_wind();
	thread aud_start_stairwell_exterior_battle();
	thread aud_start_littlebird_fire();
	thread aud_start_collapse_fires();
	thread aud_start_level_fires();
	thread aud_start_hotel_tv();
}

aud_launch_loops()
{

}

aud_create_level_envelop_arrays()
{
	level.aud.envs["aud_artillery_ambush_mix_off"] =
		[	
			[0.000,  0.000],
			[0.082,  0.426],
			[0.238,  0.736],
			[0.408,  0.844],
			[0.756,  0.953],
			[1.000,  1.000]
		]; 

	level.aud.envs["aud_artillery_ambush_mix_on"] =
		[ 
			[0.000,  0.000],
			[0.082,  0.426],
			[0.238,  0.736],
			[0.408,  0.844],
			[0.756,  0.953],
			[1.000,  1.000]
		];

	level.aud.envs["ally_tank_fire_vol"]	=	
		[
			[0.000,  0.050],
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
}

aud_register_trigger_callbacks()
{
	callbacks = [
		["aud_artillery_ambush_mix_progress", ::aud_artillery_ambush_mix_progress]
	];
	
	trigger_multiple_audio_register_callback(callbacks);
}

aud_add_note_track_data()
{
	// Add function pointers called by notetracks here:
	// anim.notetracks[ "aud_nymn_intro_start" ] = ::aud_nymn_intro_start;
}

aud_register_handlers()
{
	aud_register_msg_handler(::audio_msg_handler);
	aud_register_msg_handler(::music_msg_handler);
}


/********************************************************************
	Level Audio Message Handler Function.
********************************************************************/

audio_msg_handler(msg, args)
{
	msg_handled = true;
	
	switch(msg)
	{
		/*******************************/
		/***** CHECKPOINT HANDLERS *****/
		/*******************************/
		case "start_berlin_intro":
		{
			MM_add_submix("berlin_artillery_ambush_shock", 0.05);
			
			aud_play_2d_sound("bln_intro_shellshock_bed_front");
		
			aud_delay_play_2d_sound("bln_intro_shellshock_voices_front", 0.77, true);
		
			aud_delay_play_2d_sound("bln_intro_shellshock_sandman", 3.35, true);
		}
		break;
		
		case "start_heli_ride":
		{
			intro_music = thread aud_prime_and_play("bln_intro_flight_music_main", 3);
			thread aud_fade_intro_flight_music_main(intro_music);
			aud_delay_play_2d_sound("bln_intro_flight_grp_bank_left", 11.17);
			if (!IsDefined(level.aud.mus_intro_flight_music_start_lng))
			{
				thread aud_prime_and_play("bln_intro_flight_music_start_sht", 1.0);
				MM_add_submix("berlin_intro_flight", 0.05);
				MM_add_submix("intro_flight_player_weapon");
			}
		}
		break;
		
		case "start_chopper_crash":
		{
			AZM_start_zone("berlin_rooftops_chopperlanding");
		}
		break;
		
		case "start_clear_roof":
		{
			AZM_start_zone("berlin_rooftops_sniping");
		}
		break;
		
		case "start_sniper":
		{
			AZM_start_zone("berlin_rooftops_sniping");
		}
		break;
		
		case "start_rappel":
		{
			AZM_start_zone("berlin_rooftops_sniping");
			music_cue("mus_sniper_complete");
		}
		break;
		
		case "start_rappel_complete":
		{
			AZM_start_zone("berlin_street_dense_postrappel");
			music_cue("mus_sniper_complete");
		}
		break;
		
		case "start_clear_bridge":
		{
			AZM_start_zone("berlin_street_dense_postrappel");
			music_cue("mus_sniper_complete");
		}
		break;
		
		case "start_advance_parkway":
		{
			AZM_start_zone("berlin_street_bridge_tanks");
			music_cue("mus_bridge_battle_all_tanks_dead");
		}
		break;
		
		case "start_building_collapse":
		{
			AZM_start_zone("berlin_street_bridge_tanks");
			// Don't start music here.
		}
		break;
		
		case "start_traverse_building":
		{
			AZM_start_zone("berlin_collapse_aftermath_exterior");
		}
		break;
		
		case "start_emerge":
		{
			AZM_start_zone("berlin_collapse_aftermath_interior");
			music_cue("mus_ceiling_collapse_complete");
		}
		break;
		
		case "start_last_stand":
		{
			AZM_start_zone("berlin_hotel_blownout");
			music_cue("mus_emerge_door_open");
		}
		break;
		
		case "start_reverse_breach":
		{
			AZM_start_zone("berlin_hotel_interior");
			music_cue("mus_player_at_top_of_hotel_stairwell");
		}
		break;
		
		/***********************************/
		/***** AWESOME TRIGGER HANDLERS ****/
		/***********************************/
		
		//Blend Trigger: berlin_rooftops_chopperlanding berlin_blownout_office
		
		case "enter_berlin_blownout_office":
		{
			zone_from = args;
		}
		break;
		
		case "exit_berlin_blownout_office":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: berlin_rooftop_windows berlin_blownout_office
		
		//Blend Trigger: berlin_blownout_office berlin_blownout_office_secondfloor_stairwell 
		
		case "enter_berlin_blownout_office_secondfloor_stairwell":
		{
			zone_from = args;
		}
		break;
		
		case "exit_berlin_blownout_office_secondfloor_stairwell":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: berlin_blownout_office_secondfloor_stairwell berlin_rooftops_sniping 
		
		case "enter_berlin_rooftops_sniping":
		{
			zone_from = args;
		}
		break;
		
		case "exit_berlin_rooftops_sniping":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: berlin_rooftops_sniping berlin_street_dense_postrappel
		
		//Blend Trigger: berlin_street_dense_postrappel berlin_street_dense_postrappel_bookstore
		
		//Blend Trigger: berlin_street_dense_postrappel berlin_street_bridge_tanks 
		
		case "enter_berlin_street_bridge_tanks":
		{
			zone_from = args;
		}
		break;
		
		case "exit_berlin_street_bridge_tanks":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: berlin_street_bridge_tanks berlin_ottobuilding_interior
		
		case "enter_berlin_ottobuilding_interior":
		{
			zone_from = args;
		}
		break;
		
		case "exit_berlin_ottobuilding_interior":
		{
			zone_to = args;
		}
		break;

		//Non-Blend Trigger: enter/exit msg's only with no zone to/from arguments.  To prime the building collapse
		
		case "enter_prime_building_collapse":
		{
		}
		break;
		
		case "exit_prime_building_collapse":
		{
		}
		break;
		
		//Blend Trigger: berlin_collapse_aftermath_exterior berlin_collapse_aftermath_interior
		
		case "enter_berlin_collapse_aftermath_interior":
		{
			zone_from = args;
			if (zone_from == "berlin_collapse_aftermath_exterior")
			{
				thread aud_collapse_trapped_man();
				thread aud_collapse_trapped_man2();
				thread aud_collapse_trapped_german();
			}
		}
		break;
		
		case "exit_berlin_collapse_aftermath_interior":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: berlin_collapse_aftermath_interior berlin_aftermath_street_prehotel
		
		case "enter_berlin_aftermath_street_prehotel":
		{
			zone_from = args;
			if (zone_from == "berlin_collapse_aftermath_interior")
			{
				level notify("exited_collapse_building");
			}
		}
		break;
		
		case "exit_berlin_aftermath_street_prehotel":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: berlin_aftermath_street_prehotel berlin_hotel_blownout
		
		case "enter_berlin_hotel_blownout":
		{
			zone_from = args;
		}
		break;
		
		case "exit_berlin_hotel_blownout":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: berlin_hotel_blownout berlin_aftermath_street_prehotel
		
		//Blend Trigger: berlin_hotel_blownout berlin_aftermath_street_prehotel
		
		//Blend Trigger: berlin_hotel_blownout berlin_hotel_stairwell
		
		case "enter_berlin_hotel_stairwell":
		{
			zone_from = args;
		}
		break;
		
		case "exit_berlin_hotel_stairwell":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: berlin_hotel_stairwell berlin_hotel_interior
		
		case "enter_berlin_hotel_interior":
		{
			zone_from = args;
		}
		break;
		
		case "exit_berlin_hotel_interior":
		{
			zone_to = args;
		}
		break;
		
		//Blend Trigger: berlin_hotel_interior berlin_hotel_exterior_heli
		
		case "enter_berlin_hotel_exterior_heli":
		{
			zone_from = args;
		}
		break;
		
		case "exit_berlin_hotel_exterior_heli":
		{
			zone_to = args;
		}
		break;
		
		/**************************/
		/***** EVENT HANDLERS *****/
		/**************************/

		////////////////////////////////////
		/***** Intro (Flash Forward) *****/
		//////////////////////////////////


		////////////////////////
		/***** Heli Ride *****/
		//////////////////////
		case "fade_in_heli_ride":
		{
			//iprintlnbold("fade_in_heli_ride");
		}
		break;

		case "spawn_playerbird":
		{
			playerbird = args;
			assert(IsDefined(playerbird));

			playerbird waittill("unloading");
			//iprintlnbold("playerbird_unloading");

			playerbird waittill("unloaded");
			//iprintlnbold("playerbird_unloaded");
			aud_play_linked_sound("bln_intro_flight_playerbird_out", playerbird);
		}
		break;

		case "spawn_deadbird":
		{
			deadbird = args;
			assert(IsDefined(deadbird));
			
			flag_wait("aud_start_deadbird_sounds");
			aud_play_linked_sound("bln_intro_flight_deadbird_move", deadbird);
		}
		break;
		
		case "intro_javelin_fire_1":
		{
			javelin = args;
			assert(IsDefined(javelin));
			//iprintlnbold("intro_javelin_attack_1");
			
			javelin waittill("death");
			//iprintlnbold("intro_javelin_hit_1");
		}
		break;
		
		case "intro_javelin_fire_2":  //javelin that hits and kills the little_bird_crasher.
		{
			javelin = args;
			assert(IsDefined(javelin));
			//iprintlnbold("intro_javelin_attack_2");
			aud_delay_play_2d_sound("bln_intro_flight_javelin_inc_01", 5.25);
			
			javelin waittill("death");
			//iprintlnbold("intro_javelin_hit_littlebird");
			aud_play_2d_sound("bln_intro_flight_javelin_explo_01");
			flag_set("aud_start_deadbird_sounds");
		}
		break;
		
		case "intro_javelin_fire_3":  //javelin that hits a nearby building and causes an screenshake.
		{
			javelin = args;
			assert(IsDefined(javelin));
			//iprintlnbold("intro_javelin_attack_3");
			aud_delay_play_2d_sound("bln_intro_flight_javelin_inc_02", 5);
			
			javelin waittill("death");
			//iprintlnbold("intro_javelin_hit_screenshake");
			aud_play_2d_sound("bln_intro_flight_javelin_explo_02");
			MM_clear_submix("intro_flight_player_weapon");
		}
		break;
		
		case "apache_fires_missiles1":
		{
			apache = args;
			assert(IsDefined(apache));
			//aud_play_linked_sound("bln_intro_flight_apache_shoot_01", apache);
		}
		break;

		case "apache_fires_missiles2":
		{
			apache = args;
			assert(IsDefined(apache));
			//aud_play_linked_sound("bln_intro_flight_apache_shoot_02", apache);
		}
		break;

		case "RPG_fires_at_deadbird":
		{
			stinger = args;
			assert(IsDefined(stinger));
			//iprintlnbold("RPG_fires_at_deadbird");
			aud_play_linked_sound("bln_intro_flight_rpg_fire", stinger);
		}
		break;

		case "deadbird_hit":
		{
			deadbird = args;
			assert(IsDefined(deadbird));
			//iprintlnbold("deadbird_hit");
			aud_play_2d_sound("bln_intro_flight_deadbird_crash_hit");
			aud_play_2d_sound("bln_intro_flight_deadbird_crash_front");
			aud_delay_play_2d_sound("bln_intro_flight_deadbird_impact", 2.4);
		}
		break;

		case "deadbird_crash":
		{
			deadbird = args;
			assert(IsDefined(deadbird));
			//iprintlnbold("deadbird_crash");
			aud_play_2d_sound("bln_intro_flight_playerbird_land");
			MM_clear_submix("berlin_intro_flight", 3);
			AZM_start_zone("berlin_rooftops_chopperlanding", 3.0);
			wait(3);
			flag_set("aud_intro_flight_landed");
		}
		break;

		///////////////////////////////////
		/***** AA Building Interior *****/
		/////////////////////////////////

		case "spawn_aabuilding_a10_flyby":
		{
			a10 = args;
			assert(IsDefined(a10));
			thread aud_play_linked_sound("bln_a10_aa_building_flyby", a10);
			wait(0.368);
			thread aud_play_linked_sound("bln_a10_aa_building_jet_flyby", a10);
		}
		break;

		////////////////////////////
		/***** Sam Destroyed *****/
		//////////////////////////
		
		//Player Destroys the SAM site closest to them.
		case "sam_detonate_player":
		{
			//iprintlnbold("sam_detonate_player");
			sam_site = args;
			sam_site playsound("exp_remote_missile_dist_sub");
			sam_site playsound("exp_remote_missile");
			aud_play_dynamic_explosion(sam_site.origin,"explo_move_mixed_01_L","explo_move_mixed_01_R");
		}
		break;
		
		case "team2_sam_detonate":
		{
			
		}
		break;

		/////////////////////////////////
		/***** ROOFTOP SKY BATLLE *****/
		///////////////////////////////

		case "hind_flyby_stairwell":
		{
			heli = args;
			if(IsDefined(heli))
			{
				sfx_ent = spawn("script_origin", heli.origin);
				sfx_ent linkto(heli);
				
				
				thread aud_fade_sound_in(heli, "bln_hind_flyby_stairwell", 1, 1.25);
				thread aud_fade_sound_in(heli, "bln_hind_flyby_stairwell_loop", 1, 1.25, true );
				wait(3);
				sfx_ent ScaleVolume(0.0, 4);
				wait(4);
				sfx_ent delete();
			}
		}
		break;
	
		case "ambient_ally_helis": //Grouping of littlebirds
		{
			heli_array = args;
			
			foreach(heli in heli_array)
			{
				heli vehicle_turnengineoff();
			}

			lead_heli = heli_array[1]; // Littlebird @ front of the pack.
			rear_heli = heli_array[3]; // Littlebird @ rear of the pack.
			
			if(Isdefined(lead_heli))
			{
				thread aud_play_linked_sound("bln_group_littlebirds_by", lead_heli);
				thread VM_aud_air_vehicle_flyby(lead_heli, "bln_group_littlebirds_by_doppler", 2000);
				//lead_heli thread aud_print_3d_on_ent("LEAD_LITTLEBIRD", 4);	
			}
			if(Isdefined(rear_heli))
			{
				littlebird_loop = spawn("script_origin", rear_heli.origin);
				littlebird_loop linkto(rear_heli);
				thread aud_fade_sound_in(littlebird_loop, "bln_group_littlebirds_loop_low", 1, 2.5, true);
				rear_heli thread stopsound_on_death_and_cleanup(littlebird_loop, 3);
				//rear_heli thread aud_print_3d_on_ent("REAR_LITTLEBIRD", 4);		
			}
		}
		break;

		case "warthog_A10_flyby_01":
		{
			warthogs = args;
			if (IsArray(warthogs))
			{
			  if(IsDefined( warthogs[0] ))
			  {
				  warthogs[0] vehicle_Turnengineoff();
					thread aud_play_linked_sound("blin_a10_skybattle_flyby_01", warthogs[0]);
			  }
			}
		}
		break;
		
		case "warthog_A10_flyby_02":
		{
			warthogs = args;
			if (IsArray(warthogs))
			{
			  if(IsDefined( warthogs[0] ))
			  {
				  warthogs[0] vehicle_Turnengineoff();
					thread aud_play_linked_sound("blin_a10_skybattle_flyby_02", warthogs[0]);
			  }
			}
		}
		break;	

		case "missile_hinds": //The pair of missile shooting hinds off to the right
		{
			// 2 Hinds Strafe the main street firing missiles.
			helis = args;
			foreach(heli_single in helis)
			{
				heli_single vehicle_Turnengineoff();
				heli_single thread monitor_hind_missiles();
			}
			if (IsArray(helis))
			{
			  if(IsDefined( helis[0] ))
			  {
					wait(1);
					thread aud_play_linked_sound("blin_missile_hind_inbound", helis[0]);
					thread VM_aud_air_vehicle_flyby(helis[0], "blin_missile_hind_by", 4000);
					hind_loop = spawn("script_origin", helis[0].origin);
					hind_loop linkto(helis[0]);
					thread aud_fade_sound_in(hind_loop,"blin_missile_hind_move_loop", 1, 5, true);
					helis[0] thread stopsound_on_death_and_cleanup(hind_loop, 3);
			  }
			}
		}
		break;
		
		case "mainstreet_hind2": //The pair of hinds that fly out from behind the building on the left and cross in front of the player (not shooting)
		{
			helis = args;
			foreach(heli_single in helis)
			{
				heli_single vehicle_Turnengineoff();
			}
			if (IsArray(helis))
			{
			  if(IsDefined( helis[0] ))
			  {
					thread aud_fade_sound_in(helis[0],"blin_flyby_hind_pair_by", 1, 4);
			  }
			}
		}
		break;
				
		case "mainstreet_hind3": // Single hind that crosses over the players head while they are in the sniping position.  Shoots missiles after it is behind the player.
		{
			helis = args;
		  if(IsDefined( helis[0] ))
		  {
				helis[0] vehicle_Turnengineoff();
				helis[0] thread monitor_hind_missiles();

				thread aud_play_linked_sound("blin_flyover_hind_single_by", helis[0]);
				thread VM_aud_air_vehicle_flyby(helis[0], "blin_flyover_hind_single_engine", 3000);
				hind_loop = spawn("script_origin", helis[0].origin);
				hind_loop linkto(helis[0]);
				thread aud_fade_sound_in(hind_loop,"blin_flyover_hind_single_move_loop", 1, 2, true);
				helis[0] thread stopsound_on_death_and_cleanup(hind_loop, 3);
		  }
		}
		break;
		
		case "hind_attack_apache3_killer": //Single hind that flies low along the street to the left of the player from front to back. 
		{
			helis = args;
		  if(IsDefined( helis[0] ))
		  {
				helis[0] vehicle_Turnengineoff();
				helis[0] thread monitor_hind_missiles();

				thread aud_play_linked_sound("blin_flyby_hind_single_by", helis[0]);
				thread VM_aud_air_vehicle_flyby(helis[0], "blin_flyby_hind_single_engine", 2000);
				hind_loop = spawn("script_origin", helis[0].origin);
				hind_loop linkto(helis[0]);
				thread aud_fade_sound_in(hind_loop,"blin_flyby_hind_single_move_loop", 1, 1, true);
				helis[0] thread stopsound_on_death_and_cleanup(hind_loop, 3);
		  }
		}
		break;
		
		case "sniper_support_helis":
		{
			helis = args;
			
			//turn off all default audio for ally helicopters.
			foreach(heli in helis)
			{
				heli Vehicle_turnengineoff();
			}
			
			//helis[0] thread aud_print_3d_on_ent("ZERO", 4, "blue"); // Second Attack Chopper.
			thread aud_fade_sound_in(helis[0], "granite_team_lowend_lp", 1, 2.5, true);
			helis[0] thread monitor_hind_missiles();
						
			//helis[1] thread aud_print_3d_on_ent("ONE", 4, "blue");	// First Attack Chopper.
			helis[1] thread monitor_hind_missiles();
			
			//helis[2] thread aud_print_3d_on_ent("TWO", 4, "red"); // "Apache" Attack Chopper that stays back and protects the granite team unload.
			thread aud_fade_sound_in(helis[2], "granite_team_apache_loop", 1, 2.5, true);
			
			//helis[3] thread aud_print_3d_on_ent("THREE", 4);	 //FIRST EXTRA LITTLEBIRD.
			thread aud_fade_sound_in(helis[3], "granite_team_move_loop", 1, 2.5, true);
			
			//helis[4] thread aud_print_3d_on_ent("FOUR", 4); // "Main" Littlebird ( Carries Granite Team ).
			thread VM_aud_air_vehicle_flyby(helis[4], "granite_team_flyby_3", 1000);
			
			//helis[5] thread aud_print_3d_on_ent("FIVE", 4);		//SECOND EXTRA LITTLEBIRD.
			thread VM_aud_air_vehicle_flyby(helis[5], "granite_team_flyby_2", 2500);

			wait(2);
			mm_add_submix("berlin_granite_heli_by", 2 );
			thread aud_fade_sound_in(helis[1], "granite_team_heli_by", 1, 3);
			wait(3);

			flag_wait("sniper_delta_support_squad_unloaded");
			thread aud_play_linked_sound("granite_team_apache_fly_out", helis[2]);
			mm_clear_submix("berlin_granite_heli_by", 2);
		}
		break;

		case "apache_fire_missile":
		{
			thread hind_missile_audio_control();
		}
		break;

		//////////////////////////////////
		/***** SNIPER TANK SECTION *****/
		////////////////////////////////

		case "sniper_tank_01":
		{
			tank_ent = args;
			tank_ent thread aud_sniper_tank();
		}
		break;	

		case "sniper_tank_02":
		{
			tank_ent = args;
			tank_ent thread aud_sniper_tank();
		}
		break;	
		
		case "sniper_tank_03":
		{
			tank_ent = args;
			tank_ent thread aud_sniper_tank();
		}
		break;	
		
		case "sniper_tank_hits_building":
		{
			exp_num = args;	
			exp_ent = aud_find_exploder(exp_num);			
			thread play_sound_in_space( "bln_artillery_explo" , exp_ent.v["origin"] );
			thread play_sound_in_space( "sniper_tank_impact_debris" , exp_ent.v["origin"] );
		}
		break;	

		/////////////////////////////////////////
		/***** A10 Goggles & Strafing Run *****/
		///////////////////////////////////////
		
		case "goggles_on":
		{
			//iprintlnbold("goggles_on");
			aud_play_2d_sound("berl_goggles_unsheath");
			wait(1);
			aud_play_2d_sound("berl_goggles_on");
		}
		break;
		
		case "goggles_off":
		{
			//iprintlnbold("goggles_off");;
			aud_play_2d_sound("berl_goggles_off");
			wait(.6);
			aud_play_2d_sound("berl_goggles_resheath");
		}
		break;
		
		case "a10_airstrike_requested":
		{
		}
		break;
		
		case "a10_first_point_confirmed":
		{
			//iprintlnbold("first_point_confirmed");
			aud_play_2d_sound("berl_goggles_target1");
			level.player thread play_loop_sound_on_entity("berl_goggles_ui_loop");
		}
		break;
		
		case "a10_second_point_confirmed":
		{
			//iprintlnbold("second_point_confirmed");
			level.player thread stop_loop_sound_on_entity("berl_goggles_ui_loop");
			aud_play_2d_sound("berl_goggles_target2");
		}
		break;
		
		case "a10_cancelled":
		{
			//iprintlnbold("a10_cancelled");
			level.player thread stop_loop_sound_on_entity("berl_goggles_ui_loop");
		}
		break;
		
		case "a10_airstrike_start":
		{
			//iprintlnbold("a10_airstrike_start");
			a10 = args;
			assert(IsDefined(a10));
			thread aud_play_linked_sound("bln_a10_airstrike_flyby", a10);
			wait(2.2);
			thread aud_play_linked_sound("bln_a10_jet_flyby", a10);
		}
		break;
		
		case "a10_airstrike_fire":
		{
			//iprintlnbold("a10_airstrike_fire");
			a10 = args;
			assert(IsDefined(a10));
			firePosition = a10.origin;
			wait(1.5);
			roar = thread aud_play_sound_at("bln_a10_airstrike_roar", firePosition);

			if(IsDefined(roar))
			{
				pitch = RandomFloatRange(1, 1.15);
				roar setpitch(pitch, 0.05);
			}
		}
		break;
		
		case "a10_airstrike_ground_impact":
		{
			ground_org = args;
			assert(IsDefined(ground_org));
			thread play_sound_in_space("bln_a10_airstrike_impact", ground_org);

			if (!IsDefined(level.aud.a10_airstrike_ground_impact))
			{
				//iprintlnbold("a10_airstrike_ground_impact");
				level.aud.a10_airstrike_ground_impact = true;
				thread play_sound_in_space("bln_a10_airstrike_fire", ground_org);
				wait(0.15);
				thread play_sound_in_space("bln_a10_airstrike_imp_explo", ground_org);
				thread aud_monitor_a10_airstrike_ground_impacts();
				earthquake( 0.5, 1, level.player.origin, 1000);
				level.player playrumbleonentity( "heavy_3s" );
			}
		}
		break;

		///////////////////////////////////////////
		/***** Granite Team Death Radiomatic *****/
		///////////////////////////////////////////
		case "prime_granite_breach":
		{
			level.aud.granite_breach_ent = spawn("script_origin", (0,0,0));
			level.aud.granite_breach_ent aud_prime_stream("granite_team_door_kick");
		}
		break;
		
		case "play_granite_breach":
		{
			assert(level.aud.granite_breach_ent aud_is_stream_primed("granite_team_door_kick"));
			thread aud_play_door_kick_subtitle();
			level.aud.granite_breach_ent PlaySound("granite_team_door_kick", "sounddone");
			level.aud.granite_breach_ent waittill("sounddone");
			wait(0.05);
			level.aud.granite_breach_ent delete();
		}
		break;
		
		case "prime_granite_explosion":
		{
			level.aud.granite_explosion_ent = spawn("script_origin", (0,0,0));
			level.aud.granite_explosion_ent aud_prime_stream("granite_team_death_explosion");
		}
		break;
		
		case "play_granite_explosion":
		{
			assert(level.aud.granite_explosion_ent aud_is_stream_primed("granite_team_death_explosion"));
			level.aud.granite_explosion_ent PlaySound("granite_team_death_explosion", "sounddone");
			level.aud.granite_explosion_ent waittill("sounddone");
			wait(0.05);
			level.aud.granite_explosion_ent delete();
		}
		break;

		case "granite_dead_room_explode":
		{
			exp_num = args;	
			exp_ent = aud_find_exploder(exp_num);			
			thread play_sound_in_space( "granite_team_room_explode" , exp_ent.v["origin"] );
			thread play_sound_in_space( "granite_team_explo_debris_01" , exp_ent.v["origin"] );
			thread play_sound_in_space( "granite_team_explo_debris_02" , exp_ent.v["origin"] );
			thread play_sound_in_space( "granite_team_room_explode_punch" , exp_ent.v["origin"] );			
		}
		break;	
	

		////////////////////////////
		/***** Player Rappel *****/
		//////////////////////////

		case "a10_rappel_fire":
		{
			//iprintlnbold("a10_rappel_fire");
			a10 = args;
			wait(0.3);
			aud_play_2d_sound("bln_a10_rappel_fire");
			wait(1.7);
			aud_play_2d_sound("bln_a10_rappel_roar");
		}
		break;

		//happens right when player hits "X" button
		case "player_rappels":
		{
			thread aud_prime_and_play("bln_a10_rappel_flyby", 1.7);
			thread aud_prime_and_play("bln_a10_rappel_flyby_low", 1.7);
			wait(4);
			aud_play_2d_sound("bln_a10_rappel_jet_flyby");
			wait(6);
			flag_set("aud_dist_tank_battle");
		}
		break;		

		///////////////////////////////
		/***** Apache Shot Down *****/
		/////////////////////////////
		
		case "bridge_battle_apache_shotdown_spawn":
		{
			apache_shotdown = args;
			assert(IsDefined(apache_shotdown));
			wait(5);
			inbound = thread aud_play_linked_sound("bln_helicopter_crash_heli_inbound", apache_shotdown);
			
			apache_shotdown waittill("deathspin");
			thread aud_play_linked_sound("bln_helicopter_crash_hit", apache_shotdown);
			thread aud_play_linked_sound("bln_helicopter_crash_turbine", apache_shotdown);
			if (IsDefined(inbound))
			{
				inbound stopsounds();
			}

			wait(1.5);
			thread aud_play_linked_sound("bln_helicopter_crash_engine", apache_shotdown);

			wait(3.3);
			thread play_sound_in_space("bln_helicopter_crash_explo", (4150, -12, 104));
			earthquake( 0.5, 1, level.player.origin, 1000);
		}
		break;

		case "bridge_battle_apache_shotdown_jav_launch":
		{
			javelin = args;
			assert(IsDefined(javelin));
			wait(2);
			thread aud_play_linked_sound("bln_helicopter_crash_jav_inc", javelin);
		}
		break;

		case "bridge_rpg_picked_up":
		{
			//iprintlnbold("bridge_rpg_picked_up");

		}
		break;

		case "destroy_tank_with_rpg_objective":
		{
			rus_tank = args;
			assert(IsDefined(rus_tank));
			rus_tank waittill("death");
			aud_play_2d_sound("bln_rpg_tank_explo");
			earthquake( 0.5, 1, level.player.origin, 1000);
		}
		break;

		//////////////////////////
		/***** Tank Battle *****/
		////////////////////////
		
		case "rus_bridge_tanks":
		{
			tank_ent = args;
			
			if(isdefined(tank_ent))
			{
				tank_ent thread aud_sniper_tank();				
			}
		}
		break;	
		
		case "ally_deadtank":
		{
			tank_ent = args;
			
			if(isdefined(tank_ent))
			{
				tank_ent thread aud_ally_tank_fire_watch();				
			}
	
			if(isdefined(tank_ent))		
			{
				aud_play_linked_sound("us_tank_idle_lp", tank_ent, "loop", "aud_kill_bridge_tank_dist_loop");	
			}		
			
		}
		break;	
		
		case "ally_tank_01":
		{
			thread MM_add_submix("berlin_ally_tanks", 0.01);
			
			tank_ent = args;
			//tank_ent thread aud_print_3d_on_ent("ONE", 4, "blue");
			instance_name = "ally_tank_01";
			move_loop = "us_tank_treads_lp_02";
			roll_loop = "us_tank_move_low_lp";
			idle_loop = "us_tank_idle_lp";
			min_speed = 1;
			max_speed = 3;
			
			tank_ent.shellshock_audio_disabled = true; // turn off default shellshock.
			
			tank_ent thread aud_ally_tank_fire_watch();
			tank_ent thread aud_ground_veh_loops(instance_name, move_loop, roll_loop, idle_loop, min_speed, max_speed);
		}
		break;	
		
		case "ally_tank_02":
		{
			tank_ent = args;
			//tank_ent thread aud_print_3d_on_ent("TWO", 4, "red");
			instance_name = "ally_tank_02";
			move_loop = "us_tank_treads_lp_02";
			roll_loop = "us_tank_move_low_lp";
			idle_loop = "us_tank_idle_lp";	
		
			tank_ent.shellshock_audio_disabled = true; // turn off default shellshock.			
			
			tank_ent thread aud_ally_tank_fire_watch();
			tank_ent thread aud_ground_veh_loops(instance_name, move_loop, roll_loop, idle_loop);
		}
		break;
		
		case "usa_tank1_start_parkway":
		{
			tank = args;	
			wait(1);
			if(IsDefined(tank))
			{
				aud_play_linked_sound("blin_us_tank_over_barricade_01", tank);
				wait(1);
				aud_play_linked_sound("blin_us_tank_barricade_lyr_01", tank);
			}
		}
		break;	
		
		case "usa_tank2_start_parkway":
		{
			tank = args;
			
			wait(6);
			if(IsDefined(tank))
			{
				aud_play_linked_sound("blin_us_tank_over_barricade_02", tank); 
				wait(0.5);
				aud_play_linked_sound("blin_us_tank_barricade_lyr_01", tank);
			}
		}
		break;		
		
		case "last_stand_tank_scripted": // Tanks Outside the Hotel at the end of the level.
		{
			thread aud_last_stand_tank();
		}
		break;	
					
		case "last_stand_tanks":  // Tanks Outside the Hotel at the end of the level.
		{
			tanks = args;
			
			foreach(tank in tanks)
			{
				tank thread aud_last_stand_tank();
			}
		}
		break;	

		////////////////////////////////
		/***** Building Collapse *****/
		//////////////////////////////
		
		//Building Demolition begins.
		case "destroyBuilding":
		{
			MM_add_submix("berlin_building_collapse", 0.05);
			MM_clear_submix("berlin_ally_tanks");
			AZM_start_zone("berlin_building_collapse_transition");
			aud_play_2d_sound("building_collapse_explo");
			aud_play_2d_sound("building_collapse_transient");
			aud_delay_play_2d_sound("building_collapse_explo_punch", 1.16, true);
			thread aud_prime_and_play("building_collapse_front", 3.66, undefined, true);
			flag_set("aud_stop_fake_tanks");
			flag_set("aud_kill_ally_tanks");
			level notify("aud_kill_bridge_tank_dist_loop");

			thread clear_building_submix_and_start_zone(20, 5);
		}
		break;	

		case "building_collide":
		{
			aud_delay_play_2d_sound("building_collapse_chunk_wsh", 2.45, true);//69
			aud_delay_play_2d_sound("building_collapse_chunk_impact", 3.20, true);
			aud_delay_play_2d_sound("building_collapse_chunk", 4.00, true);
			aud_delay_play_2d_sound("building_collapse_chunk_transient", 4.10, true);
		}
		break;	

		/////////////////////////////////
		/***** Collapse Aftermath *****/
		///////////////////////////////

		case "building_collapse_teleport_complete":
		{
			MM_add_submix("berlin_artillery_ambush_shock", 0.05);

			aud_play_2d_sound("bln_intro_shellshock_bed_front");
		
			aud_delay_play_2d_sound("bln_intro_shellshock_voices_front", 0.77, true);
		
			aud_delay_play_2d_sound("bln_intro_shellshock_sandman", 4, true);
		}
		break;
		
		case "artillery_ambush_first_incoming":
		{
			data_array = args;
			assert(IsArray(data_array));
			pos = data_array[0];
			exp_dur = data_array[1];

			aud_play_2d_sound("bln_first_artillery_incoming");
		}
		break;
		
		case "artillery_ambush_first_explosion":
		{
			pos = args;
			
			aud_play_2d_sound("bln_first_artillery_explo");
			aud_play_2d_sound("bln_first_artillery_explo_debris");
			AZM_start_zone("berlin_collapse_aftermath_exterior", 0.05);
			MM_clear_submix("berlin_artillery_ambush_shock", 0.05);
			
			wait(1);
			
			aud_play_2d_sound("bln_intro_small_arms_front"); 
		}
		break;
		
		case "artillery_ambush_incoming":
		{
			data_array = args;
			assert(IsArray(data_array));
			pos = data_array[0];
			exp_dur = data_array[1];
			
			assert(IsDefined(pos));
			assert(IsDefined(exp_dur));

			if(exp_dur < 0.8) 
			{
				thread aud_play_sound_at("bln_artillery_incoming_short", pos, exp_dur);
			}
			else
			{
				thread aud_play_sound_at("bln_artillery_incoming", pos, exp_dur);
			}
		}
		break;
		
		case "artillery_ambush_explosion":
		{
			pos = args;

			assert(IsDefined(pos));
			
			thread play_sound_in_space("bln_artillery_explo", pos);
			
		}
		break;
		
		case "artillery_ambush_final_incoming":
		{
			data_array = args;
			assert(IsArray(data_array));
			pos = data_array[0];
			exp_dur = data_array[1];

			aud_play_2d_sound("bln_intro_final_incoming_long");
			wait(0.638);
			aud_play_2d_sound("bln_intro_final_incoming_short");
		}
		break;
		
		case "artillery_ambush_final_explosion":
		{
			pos = args;
			aud_play_2d_sound("bln_intro_final_explo");
			thread aud_prime_and_play("bln_intro_flight_music_start_lng", 1.4);
			MM_add_submix("berlin_intro_flight", 1);
			level.aud.mus_intro_flight_music_start_lng = true;
			aud_slomo_wait(0.2);
			aud_play_2d_sound("bln_intro_final_debris_front");
			MM_clear_zone_mix(1);
			AZM_stop_zones(1);
		}
		break;

		case "building_falling_column":  //Stone column collapses in front of you as you run toward the entrance to the Aftermath interior
		{
			//iprintlnbold("building_falling_column");
			ent = args;			
			assert(IsDefined(ent));
			thread aud_play_linked_sound("bln_falling_column_fall", ent);
		}
		break;	

		case "ceiling_collapse_begins":  //Ceiling caves in just as you get into the Aftermath Interior (blocking your path).
		{
			//iprintlnbold("ceiling_collapse_begins");
			thread aud_play_linked_sound("bln_ceiling_collapse_start", level.player);
		}
		break;	

		case "aftermath_falling_object":  //Generic falling object message that will be handled in the falling_objects_msg_handler.
		{
			data_array = args;
			assert(IsArray(data_array));
			msg = data_array[0];
			args = data_array[1];
			
			assert(IsDefined(msg));
			assert(IsDefined(args));

			thread falling_objects_msg_handler(msg, args);
		}
		break;	

		case "start_player_slide_trigger":
			{
				player_ent = args;
				if(IsDefined(player_ent))
				{
					if ( SoundExists( "scn_player_rubble_slide" ) && SoundExists( "scn_player_rubble_slide_land" ) )
					{
						slide_ent = aud_play_2d_sound("scn_player_rubble_slide");
						player_ent waittill("aud_player_done_sliding");
						thread play_sound_in_space("scn_player_rubble_slide_land", level.player.origin);
						if (IsDefined(slide_ent))
						{
							slide_ent scalevolume(0.0, 1);
						}
					}
				}
			}
			break;		
			
			case "end_player_slide_trigger":
			{
				player_ent = args;
				
				if(IsDefined(player_ent))
				{
					player_ent notify("aud_player_done_sliding");
				}
			}
			break;
			
		/***** Building Traverse *****/
		
		case "building_shake_rumble_lg":
		{
			//iprintlnbold("building_shake_rumble_lg");
			aud_play_2d_sound("berl_bombshake_lrg");
		}
		break;	

		case "building_shake_rumble_med":
		{
			//iprintlnbold("building_shake_rumble_med");
			aud_play_2d_sound("berl_bombshake_med");
		}
		break;	

		case "building_shake_rumble_sm":
		{
			//iprintlnbold("building_shake_rumble_sm");
			aud_play_2d_sound("berl_bombshake_sml");
		}
		break;

		case "building_shake_dirt_debris":
		{
			//iprintlnbold("building_shake_rumble_sm");
			pos = args;
			assert(IsDefined(pos));
		}
		break;	

		case "building_shake_rock_falling":
		{
			//iprintlnbold("building_shake_rumble_sm");
			pos = args;
			assert(IsDefined(pos));
		}
		break;	
		
		/////////////////////////
		/***** Last Stand *****/
		///////////////////////
		
		case "US_tanks_destroyed":
		{
			
		}
		break;
		
		case "last_stand_door_kick":
		{
			door = args;
			wait(.4);
			//iprintlnbold("kick_door");
			door playsound("berl_emerge_doorbreak_break");
		}
		break;

		////////////////////////////////////
		/***** Reverse Breach Ending *****/
		//////////////////////////////////
		
		case "reverse_breach_start":
		{
			//iprintlnbold("start_reverse_breach");
			music_cue("mus_reverse_breach_start");
			MM_add_submix("berlin_reverse_breach_setup", 1.5);
			wait(0.4);
			aud_play_2d_sound("bln_rvrs_breach_plant");
			thread aud_alena_scream();
		}
		break;

		case "reverse_breach_door_explode":
		{
			aud_reverse_breach_sequence();
		}
		break;

		case "spawn_reverse_breach_heli":
		{
			heli = args;
			assert(IsDefined(heli));
			heli Vehicle_TurnEngineOff();
		}
		break;

		case "reverse_breach_getup_slowmo":
		{
			//iprintlnbold("reverse_breach_getup_slowmo");
			MM_add_submix("berlin_finale", 0.05);
			MM_clear_submix("berlin_pistol_boost", 0.05);
		}
		break;

		case "reverse_breach_getup_regular_speed":
		{
			//iprintlnbold("reverse_breach_getup_regular_speed");
			music_cue("mus_reverse_breach_getup_regular_speed");
			MM_clear_submix("berlin_finale", 1.0);
		}
		break;

		/*****************************/
		/***** PROGRESS HANDLERS *****/
		/*****************************/

		case "artillery_ambush_mix_enter":
		{
			if (args == "front") //MM_clear_submix_blend(label)
			{
				MM_add_submix_blend("berlin_artillery_ambush_on", "berlin_artillery_ambush_off", "artillery_blend", 0.0);
				level.aud.artillery_ambush_mix_blend_preset = "artillery_blend";
				level.aud.artillery_ambush_mix_env	= "aud_artillery_ambush_mix_off";
			}
			else
			{
				// should already exist, so set submixblend value to 1.0 (artillery in off state)
				MM_set_submix_blend_value("artillery_blend", 1.0);
				level.aud.artillery_ambush_mix_blend_preset = "artillery_blend";
				level.aud.artillery_ambush_mix_env	= "aud_artillery_ambush_mix_off";
			}
		}
		break;
		
		case "artillery_ambush_mix_exit":
		{
			// only clear submix when leaving from the front
			if (args == "front")
			{
				MM_clear_submix_blend("artillery_blend");			
			}
			else
			{
				MM_set_submix_blend_value("artillery_blend", 1.0);
			}
		}
		break;

		
		/**************************/
		/***** MUSIC HANDLERS *****/
		/**************************/
		
		case "bln_ivan_falling_back":
		{
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
		case "mus_player_unloaded_from_intro_flight":	
			wait(14);
			aud_set_music_submix(100, 0);
			MUS_play("bln_player_unloaded_from_intro_flight", 0);
			wait(10);
			aud_set_music_submix(1, 20);
		break;

		case "mus_enter_aa_building_stairwell":
			aud_set_music_submix(1, 10);
			MUS_play("bln_enter_aa_building_stairwell", 4);
		break;

		case "mus_enter_aa_building_combat":
			MUS_play("bln_enter_aa_building_combat", 4);
		break;

		case "mus_aa_building_roof_guys_dead":
			MUS_play("bln_aa_building_roof_guys_dead", 2);
			wait(2);
			MUS_stop(20);
		break;

		case "mus_sniper_complete":
			MUS_play("bln_sniper_complete", 0.5);
		break;
		
		case "mus_player_rappel":
			MUS_play("bln_player_rappel", 0.5);
		break;

		case "mus_bridge_battle_all_tanks_dead":
			MUS_play("bln_bridge_battle_all_tanks_dead", 10);
			wait(10);
			aud_set_music_submix(0.2, 45);
		break;

		case "mus_start_building_collapse":
			MUS_stop(1);
			wait(1);
			aud_set_music_submix(1, 1);
		break;

		case "mus_player_teleport_after_building_collapse":
			MUS_play("bln_player_teleport_after_building_collapse", 4);
		break;

		case "mus_ceiling_collapse_complete":
			wait(5);
			MUS_play("bln_ceiling_collapse_complete", 6);
			
			// Play Spacey Ambi along with this cue.
			level.aud.spacey_ambi_ent = spawn("script_origin", level.player.origin);
			level.aud.spacey_ambi_ent PlayLoopSound("amb_blin_building_aftermath_spacey");
			level.aud.spacey_ambi_ent ScaleVolume(0.0, 0.05);
			wait(0.05);
			level.aud.spacey_ambi_ent ScaleVolume(1.0, 5);
		break;

		case "mus_emerge_door_open":	// "There's the hotel!
			aud_set_music_submix(1000);
			MUS_play("bln_theres_the_hotel", 0, 3);
			
			// Kill Spacey Ambi along with this cue.
			if (IsDefined(level.aud.spacey_ambi_ent))
			{
				level.aud.spacey_ambi_ent ScaleVolume(0.0, 3);
				wait(3);
				level.aud.spacey_ambi_ent StopSounds();
				wait(0.5);
				level.aud.spacey_ambi_ent Delete();
			}
		break;

		case "mus_player_at_top_of_hotel_stairwell":	// Nearing final reverse breach moment.
			MUS_play("bln_player_at_top_of_hotel_stairwell", 10);
		break;

		case "mus_reverse_breach_start":
			MUS_stop(5);
			//wait(5);
			//aud_set_music_submix(1);
		break;

		case "mus_reverse_breach_getup_regular_speed":	// Final regular speed after chopper flys away.
			MUS_play("bln_reverse_breach_getup_regular_speed", 3);
		break;

		default:
			msg_handled = false;
			aud_print_warning("\tMUSIC MESSAGE NOT HANDLED: " + msg);
		break;
	}

	return msg_handled;
}

/********************************************************************
	Event Functions.
********************************************************************/

aud_fade_intro_flight_music_main(intro_music)
{
	flag_wait("aud_intro_flight_landed");
	
	if (Isdefined(intro_music))
	{
		intro_music scalevolume(0.65, 8);
	}
}

clear_building_submix_and_start_zone(waittime, fadetime)
{
	wait(waittime);
	thread MM_clear_submix("berlin_building_collapse", fadetime);
}


/********************************************************************
	Trigger Multiple Audio Callback Functions.
********************************************************************/

// Mix attenuation for fake artillery occlusion in Collapse Aftermath
aud_artillery_ambush_mix_progress(progress)
{
	assert(IsDefined(progress));
	assert(IsDefined(level.aud.envs[level.aud.artillery_ambush_mix_env]));
	scalevalue		= aud_map(progress, level.aud.envs[level.aud.artillery_ambush_mix_env]);
	//iprintlnbold("progress: " + progress + " scalevalue: " + scalevalue);
	fade_time 		= 0.01;
	assert(IsDefined(level.aud.artillery_ambush_mix_blend_preset));
	MM_set_submix_blend_value(level.aud.artillery_ambush_mix_blend_preset, scalevalue, fade_time);
}

/********************************************************************
	Support Functions.
********************************************************************/
aud_monitor_a10_airstrike_ground_impacts()
{
	level waittill("a10_gound_impacts_stop");
	level.aud.a10_airstrike_ground_impact = undefined;
}

aud_start_stairwell_exterior_battle()
{
	loop_fx_sound("aabuilding_stairwell_window_amb",(1892, 3891, 1315),1);//
}

aud_start_littlebird_fire()
{
	loop_fx_sound("berl_fire_heatcreaks_lp", (2493, 2640, 35),1);//center heatcreaks
	DAMB_start_preset_at_point("fire_metal_med", (2493, 2640, 35), "littlebird_metal_01", 600, 1.0); //center
	DAMB_start_preset_at_point("fire_wood_med", (2493, 2640, 35), "littlebird_wide_spread_01", 600, 1.0); //center
	DAMB_start_preset_at_point("fire_crackle_med", (2535, 2620, 22), "littlebird_wide_spread_crackle", 600, 1.0); //cockpit
	DAMB_start_preset_at_point("fire_wood_med_tight", (2249, 2801, 16), "littlebird_crackle_18", 700, 1.0); //tailpiece
}

aud_start_collapse_fires()
{
	//Collapse Entrance
	DAMB_start_preset_at_point("fire_wood_med_tight", (30715, 4294, 263), "collapse_entrance_left", 600, 1.0); //leftmost fire at collapsed entrance
	DAMB_start_preset_at_point("fire_wood_med_tight", (30656, 4333, 247), "collapse_entrance_leftmid", 600, 1.0); //leftmid fire at collapsed entrance
	DAMB_start_preset_at_point("fire_wood_med_tight", (30707, 4498, 276), "collapse_entrance_rightmid", 600, 1.0); //rightmid fire at collapsed entrance
	DAMB_start_preset_at_point("fire_crackle_med", (30741, 4549, 294), "collapse_entrance_right", 600, 1.0); //right fire at collapsed entrance
	
	//Tank
	DAMB_start_preset_at_point("fire_metal_med", (31724, 5164, 180), "collapse_tank", 600, 1.0); //tank
	
	//Pre-Emerge
	DAMB_start_preset_at_point("fire_wood_med_tight", (30301, 5750, 403), "pre_emerge_left", 600, 1.0); //pre emerge room left sheeting
	DAMB_start_preset_at_point("fire_wood_med_tight", (30273, 5849, 399), "pre_emerge_right", 600, 1.0); //pre emerge room right sheeting
	DAMB_start_preset_at_point("fire_crackle_med", (30156, 5779, 401), "pre_emerge_center", 600, 1.0); //pre emerge far center sheeting
	
	//Fire_GasJets
	loop_fx_sound("berl_emt_firejet", (31156, 5409, 310),1);//elevator jet
	DAMB_start_preset_at_point("fire_gas_med_tight", (31156, 5409, 310), "jet_01", 600, 1.0);
	loop_fx_sound("berl_emt_firejet", (30634, 6078, 319),1);//pre-emerge jet
	DAMB_start_preset_at_point("fire_gas_med_tight", (30634, 6078, 319), "jet_02", 600, 1.0);
}

aud_start_level_fires()
{
	//courtyard and pre hotel lobby
	DAMB_start_preset_at_point("fire_metal_med", (2772, 1408, 12), "car_metal_01", 600, 1.0); //carfire
	DAMB_start_preset_at_point("fire_metal_med", (30718, 7159, 83), "car_metal_02", 600, 1.0); //carfire2
	DAMB_start_preset_at_point("fire_wood_med_tight", (29800, 7610, 158), "burning_tree", 600, 1.0); //treefire
	
	//hotel_lobby
	DAMB_start_preset_at_point("fire_wood_med", (30077, 7517, 386), "hotel_lobby_L", 600, 1.0); //hotel lobby left entrance
	DAMB_start_preset_at_point("fire_wood_med", (30239, 7361, 438), "hotel_lobby_R", 600, 1.0); //hotel lobby right entrance
	DAMB_start_preset_at_point("fire_wood_med_tight", (30809, 8582, 225), "hotel_lobby_farwall", 600, 1.0); //hotel lobby far blownout
	
	//hotel_interior
	DAMB_start_preset_at_point("fire_wood_med_tight", (29906, 8194, 649), "hotel_dresser", 600, 1.0); //dresser
	DAMB_start_preset_at_point("fire_wood_med_tight", (29997, 8037, 686), "hotel_wall", 600, 1.0); //wall
	DAMB_start_preset_at_point("fire_wood_med_tight", (29849, 7789, 613), "hotel_chair", 600, 1.0); //chair
	DAMB_start_preset_at_point("fire_rock_sml", (30128, 8422, 587), "hotel_trashcan", 600, 1.0); //trashcan
}

aud_start_water()
{
	loop_fx_sound("berlin_emt_water_drips",(1700,5363,1052),1);//first floor corner conference room
	loop_fx_sound("berlin_emt_water_drips",(1566,4743,1051),1);//first floor desk
	//collapsed building
	loop_fx_sound("berlin_emt_water_drips_collapse",(30137,4572,256),1);//left ledge
	loop_fx_sound("berlin_emt_bathroom_drips",(29938,4578,376),1);//left ledge deep swtnr
	loop_fx_sound("berlin_emt_water_drips_collapse",(31077,5045,240),1);//post bathroom
	loop_fx_sound("berlin_emt_water_pipe_spray_ground",(1574,4717,1052),1);//first floor desk
	loop_fx_sound("berlin_emt_faucet_spray_splatter",(1574,4717,1052),1);//first floor desk
	loop_fx_sound("berlin_emt_bathroom_drips",(30805,5072,332),1);//bathroom drips
	loop_fx_sound("berlin_emt_water_splatter_large",(30828,4965,256),1);//big bathroom splatter
	loop_fx_sound("berlin_emt_faucet_spray_splatter",(30828,4965,256),1);//big bathroom splatter
	loop_fx_sound("berlin_emt_bathroom_sinkleak",(30971,5080,303),1);//post bathroom pipespray
	loop_fx_sound("berlin_emt_faucet_spray",(30763,4882,266),1);//inside bathroom corner pipespray
	loop_fx_sound("berlin_emt_water_drips_bathroom",(30660,5023,280),1);//prebathroom drips
	loop_fx_sound("berlin_emt_water_drips_bathroom",(30793,4922,269),1);//inside bathroom right
	loop_fx_sound("berlin_emt_water_drips_bathroom",(30797,5041,251),1);//inside bathroom left
	loop_fx_sound("berlin_emt_water_drips_bathroom",(30761,5278,298),1);//inside bathroom far left
	loop_fx_sound("berlin_emt_toilet_flooding",(30937,5009,254),1);//inside bathroom toilet flooding
	loop_fx_sound("berlin_emt_drain",(30824,5194,240),1);//bathroom drain
	loop_fx_sound("berlin_emt_water_drips_collapse",(30465,4474,150),1);//collapse_entrance right
	loop_fx_sound("berlin_emt_water_drips_collapse",(30428,4335,171),1);//collapse_entrance left
	loop_fx_sound("berlin_emt_water_drips_collapse",(31004,5002,271),1);//collapse_after bathroom
}

aud_start_wind()
{
	loop_fx_sound("blin_wind_heavy_lp", (1019, 5627, 1000), 1); //Blownout Corner of first building.
	loop_fx_sound("blin_wind_heavy_lp", (1831, 3891, 1400), 1); //Stairwell of first building.
}

aud_start_hotel_tv()
{
	thread aud_play_sound_on_tv("berlin_hotel_lobby_tv_trigger", "berlin_hotel_lobby_tv", "berl_hotel_tv_news_lp");
}

playsound_attach(alias, linktothis, soundtype_)
{
	ent = Spawn( "script_origin", linktothis.origin );
	ent LinkTo(linktothis);
			
	soundtype = "oneshot";
	if (IsDefined(soundtype_))
	{
		soundtype = soundtype_;
	}
			
	if (soundtype == "loop")
	{
		ent playloopsound(alias);
	}
	else
	{
		ent playsound(alias);	
	}
}

aud_num_enemies_near(radius)
{	
	enemies = GetAiArray("bad_guys");
	num_enemies_near = 0;
	foreach(dude in enemies)
	{
		if( IsAlive(dude) )
		{
			dist = Distance(level.player.origin, dude.origin);
			
			if (dist < radius)
			{
				num_enemies_near++;
			}
		}
	}	

	return num_enemies_near;
}


//BERLIN_CHOPPERS

stopsound_on_death_and_cleanup(sound_ent, fade_time_)
{
	assert(IsDefined(sound_ent));

	fade_time = 1;
	if(IsDefined(fade_time_))
	{
		fade_time = fade_time_;
	}	
	if(isDefined(self))
	{
		self waittill_any("deathspin", "death");
		sound_ent scalevolume(0.0, fade_time);
		wait(fade_time);
		wait(0.1);
		sound_ent stopsounds();
		wait(0.1);
		sound_ent delete();
	}
}

monitor_hind_missiles()
{
	self endon("deathspin");
	self endon("death");
	
	while(IsDefined(self))
	{
		self waittill("missile_fired", eMissile);
		if (IsDefined(eMissile))
		{
			eMissile thread hind_missile_audio_control();
		}
		wait(0.05);
	}
}

hind_missile_audio_control()
{
	thread aud_play_linked_sound("heli_missile_launch", self);
	self waittill( "explode", origin );
	thread play_sound_in_space("heli_missile_explo", origin);
}

//BERLIN_SNIPER TANKS
aud_sniper_tank()
{
	if(isDefined(self))
	{
		tread_ent = spawn("script_origin", self.origin);
		tread_ent linkto(self);
		
		tread_ent playloopsound("t90_treads_dist_01");
		tread_ent ScaleVolume(0.0, 0.05);
		wait(0.05);
		tread_ent ScaleVolume(0.5, 0.5);
		self thread aud_sniper_tank_fire_watch();
		
		self waittill("death");
		wait(0.5);
		tread_ent stopsounds();
		wait(0.5);
		tread_ent delete();
	}
}

aud_sniper_tank_fire_watch()
{	
	if(IsDefined(self))
	{	
		while(1)
		{
			self endon("death");
			self waittill("weapon_fired");
			self aud_sniper_tank_fire();
		}
	}	
}
		
aud_sniper_tank_fire()
{
	if(IsDefined(self))
	{					
		thread play_sound_in_space("ac130_main_impact_3d", self.origin);
		thread play_sound_in_space("t90_fire_dist", self.origin);
		self thread aud_sniper_tank_whizby();
		wait(0.2);
		aud_play_2d_sound("t90_dist_verb");
	}
}

aud_sniper_tank_whizby()
{
	if(IsDefined(self))
	{
		thread play_sound_in_space("t90_whizby_split_01_L", self.origin);
		thread play_sound_in_space("t90_whizby_split_01_R", (-2043, 8012, 14880));
	}
}

//BERLIN_BRIDGE TANKS
aud_rus_bridge_tank()
{
	if(isDefined(self))
	{
		while(1)
		{
			self endon( "death" );
			self waittill("weapon_fired");
			//self playsound("blin_tank_shot_distant");
			//self playsound("blin_tank_shot_dist_verb");
		}
	}
}

aud_last_stand_tank()   // Tanks Outside the Hotel at the end of the level.
{
	level endon("aud_kill_last_stand_tanks");
	self endon("death");
	
	if(IsDefined(self))
	{
		while(1)
		{
			self waittill("weapon_fired");
			
			self thread aud_ally_tank_shock_check();  // Hooks Stubbed in, will finish later.

			rand_wait = randomfloatrange(0.2, 0.4);
			
			thread play_sound_in_space("rus_tank_big_boom", self.origin);
			thread play_sound_in_space("rus_tank_fire_dist", self.origin);
			thread play_sound_in_space("rus_tank_fire_close", self.origin);
			thread play_sound_in_space("rus_tank_fire_hi_ring", self.origin);
			thread play_sound_in_space("rus_tank_fire_lfe", self.origin);
			wait(0.2);
			thread play_sound_in_space("rus_tank_dist_verb", self.origin);
			wait(rand_wait);
			self thread aud_post_tank_fire_sfx();
		}

	}
}

aud_fake_tank_battle()
{
	level endon("aud_stop_fake_tanks");
	
	flag_wait("aud_dist_tank_battle");
	
	wait(7);
	while(1)
	{
		aud_zone = AZM_get_current_zone();
		//iprintlnbold(aud_zone);
		if(aud_zone == "berlin_street_dense_postrappel" || aud_zone == "berlin_street_dense_postrappel_bookstore")
		{
			waittime = randomintrange(4, 6);
			thread aud_play_fake_tanks();
			wait(waittime);
		}
		wait(0.3);
	}
}

aud_play_fake_tanks()
{
	randsnd = randomint(7);	
	randpos = aud_select_pos_set();
	
	sndvars = ["01", "02", "03", "04", "05", "06", "07"];
	
	sndvarnum = sndvars[randsnd];
	
	thread play_sound_in_space("dist_tank_battle_L_" + sndvarnum, randpos[0]);
	wait(0.25);
	thread play_sound_in_space("dist_tank_battle_R_" + sndvarnum, randpos[1]);

//	slap_ent = spawn("script_origin", randpos[2]);
//	slap_ent playsound("dist_tank_battle_R_" + sndvarnum, "sounddone");
//	slap_ent scalevolume(0.75, 0.05);
//	slap_ent waittill("sounddone");
//	wait(0.2);
//	slap_ent delete();
}

aud_select_pos_set()
{
	rand = randomint(3);
	
	pair_01 = [(1922, -663, 723), (1179, 272, 723), (3440, 1713, 620)];
	pair_02 = [(228, 1338, 900), (1874, 1108, 739), (2808, 2797, 739)];
	pair_03 = [(5290, -755, 579), (2933, -1226, 579), (2808, 2797, 739)];
	
	if(rand == 0)
	{
		return pair_01;
	}
	else if(rand == 1)
	{
		return pair_02;
	}
	else if(rand == 2)
	{
		return pair_03;
	}
}

aud_ally_tank_fire_watch()
{
	level endon("aud_kill_ally_tanks");
	self endon("death");
		
	if(!IsDefined(self))
		return;
	
	while(1)
	{
		if(!IsDefined(self))
			return;
		
		self waittill("weapon_fired");
		
		self thread aud_ally_tank_shock_check();   //Hooks stubbed in, will finish later.

		rand_wait = randomfloatrange(0.2, 0.4);
		
		thread play_sound_in_space("us_tank_big_boom", self.origin);
		thread play_sound_in_space("us_tank_fire_dist", self.origin);
		thread play_sound_in_space("us_tank_fire_close", self.origin);
		thread play_sound_in_space("us_tank_fire_hi_ring", self.origin);
		thread play_sound_in_space("us_tank_fire_lfe", self.origin);
		wait(0.2);
		thread play_sound_in_space("us_tank_dist_verb", self.origin);
		wait(rand_wait);
		self thread aud_post_tank_fire_sfx();
	}
}

aud_ally_tank_shock_check()
{
	if(!IsDefined(self))
		return;
		
	shock_full_dist = 350;
	hold_time = 1.5;
	filter_clear_wait = 2;
	shock_clear_time = 1.5;
		
	player_dist = distance(level.player.origin, self.origin); // Get players distance from the tank.
 
	if(player_dist < shock_full_dist)
	{
		MM_add_submix("berlin_tank_shock", 0.05);
		aud_set_filter("berlin_tank_shock", 1);
		self thread ally_tank_shock_lfe_manage();
		earthquake( 1, 1, level.player.origin, 1000);
		wait(0.1);
		aud_play_2d_sound("tank_shock_impact");
		aud_play_2d_sound("tank_shock_impact");
		wait(hold_time);
		MM_clear_submix("berlin_tank_shock", shock_clear_time);
		wait(filter_clear_wait);
		aud_clear_filter(1);
	}
}	

ally_tank_shock_lfe_manage()
{
	wait(0.2);
	lfe_ent = aud_play_2d_sound("tank_shock_lfe");
	wait(1.3);
	lfe_ent scalevolume(0.0, 2);   // Fade out the lfe sweep early.	
}

aud_post_tank_fire_sfx()
{
	hydro_ent = spawn("script_origin", self.origin);
	hydro_ent linkto(self);
	
	hydro_ent playsound("us_tank_hydraulics_move", "sounddone");
	self waittill("weapon_fired");
	thread aud_fade_out_and_delete(hydro_ent, 0.05);
}

aud_ground_veh_loops(instance_name, move_loop, roll_loop, idle_loop, min_speed_, max_speed_)
{
	if(!IsDefined(self))
		return;
	
	level.aud.instance_name = spawn("script_origin", self.origin);
	
	move_ent = spawn("script_origin", self.origin);
	roll_ent = spawn("script_origin", self.origin);
	idle_ent = spawn("script_origin", self.origin);
	
	level.aud.instance_name.fade_in = true;
		
	instance = 	level.aud.instance_name;
	
	fade_in = level.aud.instance_name.fade_in;
		
	move_ent linkto(self);
	idle_ent linkto(self);
	roll_ent linkto(self);
	
	if(IsDefined(move_ent) || IsDefined(move_loop) )
	{
		move_ent playloopsound(move_loop);
	}
	
	if(IsDefined(roll_ent) || IsDefined(roll_loop) )
	{
		roll_ent playloopsound(roll_loop);
	}
	
	if(IsDefined(idle_ent) || IsDefined(idle_loop))
	{
		idle_ent playloopsound(idle_loop);
	}
	
	move_ent scalevolume(0.0);
	roll_ent scalevolume(0.0);
	idle_ent scalevolume(0.0);
	
	wait(0.3);
	
	self aud_ground_veh_speed_mapping(instance, move_ent, roll_ent, idle_ent, 1, 5, fade_in, min_speed_, max_speed_);
}

aud_ground_veh_speed_mapping(instance, move_ent, roll_ent, idle_ent, min_speed, max_speed, fade_in, min_speed_, max_speed_)
{
	if (!IsDefined(self))
		return;
			
	min_speed = 1;
	max_speed = 5;
	if(IsDefined(min_speed_))
	{
		min_speed = min_speed_;
	}

	if(IsDefined(max_speed_))
	{
		max_speed = max_speed_;
	}

	self thread aud_ground_veh_deathwatch(instance, move_ent, roll_ent, idle_ent);
	
	thread aud_create_drive_envs();

	instance endon("instance_killed");
	
	prev_veh_speed = 0;
	
	while(1)
	{ 
		if (!IsDefined(self))
			return;
			
		veh_speed = self vehicle_getspeed();
		veh_speed = min(veh_speed, max_speed);
		veh_speed = aud_smooth(prev_veh_speed, veh_speed, 0.1);

		veh_drive_vol = aud_map_range(veh_speed, min_speed, max_speed, level.aud.envs["veh_drive_vol"]);
		veh_idle_vol = aud_map_range(veh_speed, min_speed, max_speed, level.aud.envs["veh_idle_vol"]);
		
		roll_ent scalevolume(veh_drive_vol, 0.1);
		move_ent scalevolume(veh_drive_vol, 0.1);
		idle_ent scalevolume(veh_idle_vol, 0.1);
		
		prev_veh_speed = veh_speed;
		
		wait(0.1);
	}
}

aud_create_drive_envs()
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
}

aud_ground_veh_deathwatch(instance, move_ent, roll_ent, idle_ent)
{
	if(!Isdefined(self))
		return;
		
	self waittill("death");
	instance notify("instance_killed");
	thread aud_fade_loop_out_and_delete_temp(move_ent, 5);
	thread aud_fade_loop_out_and_delete_temp(roll_ent, 5);
	thread aud_fade_loop_out_and_delete_temp(idle_ent, 5);
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

aud_ent_fade_out(fadetime)
{
	assert(fadetime >= 0);
	self ScaleVolume(0.0, fadetime);
}

aud_ent_fade_in(fadetime, vol_)
{
	vol = 1.0;
	if (IsDefined(vol_))
		vol = vol_;
		
	assert(fadetime >= 0);
	self ScaleVolume(0.0);
	wait(0.01);
	self ScaleVolume(vol, fadetime);
}

falling_objects_msg_handler(msg, args)
{
	switch(msg)
	{
		case "ceiling_fall_trigger":  //Smaller chunk of concrete shifts and drops into place above you in the ceiling.
		{
			faller = args;
			assert(IsDefined(faller));
			//iprintlnbold("Gravity:  Ceiling Fall");
			thread aud_play_linked_sound("bln_gravity_ceiling_collapse", faller);
		}
		break;	
		
		case "beam_fall_trigger":  //A beam above you tips and falls just after you slide down to the lower section of the aftermath.
		{
			faller = args;
			assert(IsDefined(faller));
			//iprintlnbold("Gravity:  iBeam_01");
			thread aud_play_linked_sound("bln_gravity_beam_fall_01", faller);
		}
		break;	

		case "falling_office_objects_trigger":  //An office chair falls from above and lands right in front of the player. 
		{
			//iprintlnbold("Gravity:  Office_Chair_01");
			wait(1.5);
			thread play_sound_in_space("bln_office_chair_fall_01", (31538, 5681, 93));
		}
		break;	

		case "ibeam_fall2_trigger":  //A chunk of ibeam breaks loose from above and falls, landing almost directly in front of the player. 
		{
			faller = args;
			assert(IsDefined(faller));
			//iprintlnbold("Gravity:  iBeam_02");
			thread aud_play_linked_sound("bln_gravity_beam_fall_03", faller);
		}
		break;	
		
		case "ibeam_fall_trigger":  //A third chunk of ibeam breaks lose and tips over.
		{
			faller = args;
			assert(IsDefined(faller));
			//iprintlnbold("Gravity:  iBeam_03");
			ibeam = thread aud_play_linked_sound("bln_gravity_beam_fall_02", faller);

			if(IsDefined(ibeam))
			{
				ibeam waittill("sounddone");
				flag_set("aud_ibeam_fall_complete");
			}
		}
		break;	

		case "falling_office_objects_trigger2":  //After climbing out of the elevator shaft another office chair falls from above and lands in front of the player.
		{
			//iprintlnbold("Gravity:  Office_Chair_02");
			wait(1.6);
			thread play_sound_in_space("bln_office_chair_fall_02", (30758, 5859, 231));
		}
		break;	
		
		default:
		{
			aud_print_warning("\tFALLING OBJECT NOT HANDLED: " + msg);
		}
	}
}

aud_ignore_slowmo()
{
	SoundSetTimeScaleFactor( "announcer", 0 );
	SoundSetTimeScaleFactor( "mission", 0 );
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

aud_reverse_breach_sequence()
{
	//iprintlnbold("reverse_breach_door_explode");
	MM_add_submix("berlin_reverse_breach", 0.05);
	MM_clear_submix("berlin_reverse_breach_setup", 0.05);
	
	aud_play_2d_sound("bln_rvrs_breach_transient");

	aud_delay_play_2d_sound("bln_rvrs_breach_explo_front", 0.05, true);

	aud_delay_play_2d_sound("bln_rvrs_breach_bodyfall", 2.00, true);

	aud_delay_play_2d_sound("bln_rvrs_breach_debris_front", 2.33, true);

	aud_delay_play_2d_sound("bln_rvrs_breach_synth", 3.48, true);

	aud_delay_play_2d_sound("bln_rvrs_breach_slowmo_heli", 6.48, true);

	aud_delay_play_2d_sound("bln_rvrs_breach_slowmo_outro", 8.67, true);

	flag_wait("breach_weapon_drawn");
	//iprintlnbold("slowmo_end");
	//wait(1);
	MM_clear_submix("berlin_reverse_breach", 0.05);
	MM_add_submix("berlin_pistol_boost", 0.05);
	thread aud_berlin_finale_helicopter();

	flag_wait("reverse_breach_complete");
	//iprintlnbold("reverse_breach_complete");

	aud_delay_play_2d_sound("bln_rvrs_breach_getup_foley_start", 0.68, true);

	thread aud_prime_and_play("bln_rvrs_breach_getup_foley", 2.68);
	//aud_delay_play_2d_sound("bln_rvrs_breach_getup_foley", 2.68, true);

	aud_delay_play_2d_sound("bln_rvrs_breach_getup_slomo_heli", 2.6, true);

	aud_delay_play_2d_sound("bln_rvrs_breach_getup_whoosh_front", 2.79, true);

	aud_delay_play_2d_sound("bln_rvrs_breach_getup_tonal_1", 4.26, true);

	aud_delay_play_2d_sound("bln_rvrs_breach_getup_tonal_2", 5.75, true);

	aud_delay_play_2d_sound("bln_rvrs_breach_blowing_paper", 7.00, true);

	aud_slomo_wait(8.75);

	play_sound_in_space("bln_rvrs_breach_getup_heli_flyaway", (30504, 7019, 987));
}

aud_berlin_finale_helicopter()
{
	heli = spawn("script_origin", level.player.origin);
	heli linkto( level.player );
	heli playloopsound("bln_finale_heli_hover");
	heli ScaleVolume(0.0);
	wait(0.01);
	heli ScaleVolume(1.0, 0.5);

	flag_wait("reverse_breach_complete");

	wait(3);
	heli scalevolume(0.0, 1.5);
	wait(1.5);
	wait(0.1);
	heli stopsounds();
	heli delete();
}

aud_play_sound_on_tv(damage_trigger_name, org_name, alias)
{
	org = getent(org_name, "targetname");
	if (IsDefined(org))
	{
		org playloopsound(alias);
		trigger_wait_targetname(damage_trigger_name);
		org stoploopsound();    
	}
}

aud_alena_scream()
{
	flag_wait("reverse_breach_getup_slowmo_start");
	wait(1.2);
	aud_play_2d_sound("bln_daughter_scream_exit");
}

aud_collapse_trapped_man()
{
	level endon("exited_collapse_building");
	while(1)
	{
		play_sound_in_space("berl_emt_trapped_guy_01", (30521, 5669, -186));
		rand_wait = randomfloatrange(1.5, 3.5);
		wait(rand_wait);
		play_sound_in_space("berl_emt_trapped_guy_02", (30521, 5669, -186));
		rand_wait = randomfloatrange(2.5, 5.0);
		wait(rand_wait);
		play_sound_in_space("berl_emt_trapped_guy_03", (30521, 5669, -186));
		rand_wait = randomfloatrange(.5, 3.0);
		wait(rand_wait);
		play_sound_in_space("berl_emt_trapped_guy_04", (30521, 5669, -186));
		rand_wait = randomfloatrange(.5, 3.5);
		wait(rand_wait);
	}
}

aud_collapse_trapped_man2()
{
	level endon("exited_collapse_building");
	while(1)
	{
		play_sound_in_space("berl_emt_trapped_guy2_01", (30544, 6110, -22));
		rand_wait = randomfloatrange(1.5, 3.5);
		wait(rand_wait);
		play_sound_in_space("berl_emt_trapped_guy2_02", (30544, 6110, -22));
		rand_wait = randomfloatrange(2.5, 5.0);
		wait(rand_wait);
		play_sound_in_space("berl_emt_trapped_guy2_03", (30544, 6110, -22));
		rand_wait = randomfloatrange(.5, 3.0);
		wait(rand_wait);
		play_sound_in_space("berl_emt_trapped_guy2_04", (30544, 6110, -22));
		rand_wait = randomfloatrange(.5, 3.5);
		wait(rand_wait);
		play_sound_in_space("berl_emt_trapped_guy2_05", (30544, 6110, -22));
		rand_wait = randomfloatrange(.5, 3.5);
		wait(rand_wait);
	}
}

aud_collapse_trapped_german()
{
	level endon("exited_collapse_building");
	while(1)
	{
		play_sound_in_space("berl_emt_trapped_german_01", (30889, 5629, -109));
		rand_wait = randomfloatrange(1.0, 2.5);
		wait(rand_wait);
		play_sound_in_space("berl_emt_trapped_german_02", (30889, 5629, -109));
		rand_wait = randomfloatrange(1.5, 3.0);
		wait(rand_wait);
		play_sound_in_space("berl_emt_trapped_german_03", (30889, 5629, -109));
		rand_wait = randomfloatrange(.5, 1.5);
		wait(rand_wait);
		play_sound_in_space("berl_emt_trapped_german_04", (30889, 5629, -109));
		rand_wait = randomfloatrange(.5, 2.5);
		wait(rand_wait);
	}
}

// hack to play a subtitle at the right time
aud_play_door_kick_subtitle()
{
	wait(5.6);
	aud_play_2d_sound("granite_team_subtitle");
}