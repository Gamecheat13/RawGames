#include common_scripts\utility;
#include maps\_utility;
#include maps\_audio;
#include maps\_audio_music;
#include maps\_audio_zone_manager;

// used for doing level-specific audio scripting


/*
TABLE OF CONTENTS

In order to find any section of the mission, search for one of the tags below.

Note: ESCAPE is the only one that currently exists, but I will add more next week -mkilborn

//!ESCAPE

These tags will be suffixed with a descriptor that will tell you immediately where you are.

- EVENTS
Event handlers.

- SUPPORT
Support functions.

*/

main()
{
	aud_use_string_tables(); // uses string tables for presets

	thread maps\_utility::set_ambient("castle_ruins_rain1"); // start castle ruins rain1 zone
	
	/********************************************************************
		Init Audio System.
	********************************************************************/
	aud_init();
	
	/********************************************************************
		Config Audio System.
	********************************************************************/
	aud_set_timescale("default");
	aud_set_occlusion("default");
	
	/********************************************************************
		Init Level Globals.
	********************************************************************/
	aud_init_flags();
	aud_init_globals();
	
		/********************************************************************
		Level Initialization.
	********************************************************************/
	aud_launch_loops();
	
	/********************************************************************
		Register Level Audio Message Handler Function.
		NOTE:	Should be last thing done in level init function.
	********************************************************************/
	aud_register_handlers();
}

aud_init_flags()
{
	flag_init("aud_chute_deployed");
}

aud_init_globals()
{
}

aud_launch_loops()
{
	thread aud_ignore_slowmo();
}

aud_register_handlers()
{
	aud_register_msg_handler(::castle_aud_msg_handler);
	//aud_register_msg_handler(::music_msg_handler); 
}


castle_aud_msg_handler(msg, args)
{
	msg_handled = true;

	switch(msg)
	{
		// INTRO	
		case "map_start":
		{
			// parachute in
			thread aud_cstl_parachute_intro_plr();
		}
		break;
			
		case "turn_off_fake_nvg":
		{
			level.player thread play_sound_on_entity("nightvision_remove_plr_default");
			level.player thread play_sound_on_entity("item_nightvision_off");
		}
		break;
		
		// COURTYARD
		case "btr_sequence_start":
		{
			wait(24);
			// btr touches down here
			play_sound_in_space("cstl_drop_btr", (1485, -841, 154));
		}
		break;
		
		case "price_sets_c4":
		{
			wait(3.3);
			level.price play_sound_on_entity("cstl_detpack_c4_plant_metal");
		}
		break;
		
		case "player_stealth_kill":
		{
			wait(0.7);
			play_sound_in_space("cstl_stealthkill_player", level.player.origin);
		}
		break;
		
		case "price_drag_body":
		{
			ent = Spawn("script_origin", level.price.origin);
			ent LinkTo(level.price);
			ent aud_prime_stream("cstl_body_drag_mud");
			wait(2);
			// price starts dragging body
			ent play_sound_on_entity("cstl_body_drag_mud");
			wait(5);
			ent aud_release_stream("cstl_body_drag_mud");
			wait(1);
			ent Delete();
		}
		break;
			
		case "player_plant_c4_platform":
		{
			// player starts to set c4
			wait(0.5);
			level.player play_sound_on_entity("cstl_detpack_c4_plant_metal2d");
		}
		break;
			
		case "guard_jumps_down":
		{
			args thread aud_prime_stream("cstl_cig_put_out");
			wait(0.9);
			// impact with ground
			args thread play_sound_on_entity("cstl_land_mud");
			wait(1.93);
			args thread play_sound_on_entity("cstl_cig_put_out");
			wait(4);
			args aud_release_stream("cstl_cig_put_out");
		}
		break;
		
		// PRISON
		case "price_enters_security_office":
		{
			wait(1);
			level.price PlaySound("cstl_price_gun_foley");
			wait(1.6);
			level.price PlaySound("cstl_price_pre_door");
			wait(5);
			play_sound_in_space("cstl_price_door_slam", (540, -296, 132));

		}
		break;
		
		case "price_use_dead_guard_hand":  
		{
			door_ent = spawn("script_origin", (741, -18, 128));
			
			wait(10.65);
			level.price PlaySound("cstl_price_gun_foley");
			
			wait(1.446);
			level.price PlaySound("cstl_price_sec_drag");
			
			wait(1.561);
			thread play_sound_in_space("cstl_sec_beep", (756, -14, 132));
			
			wait(0.33);
			door_ent PlaySound("cstl_sec_door");
			door_ent MoveTo((685, -20, 128), 2);
			
			wait(0.19);
			level.price PlaySound("cstl_price_sec_drag_2");
			
			wait(5);
			door_ent Delete();
		}
		break;
		
		case "price_cut_lights":
		{
			// price flips switch
			ent = Spawn("script_origin", level.price.origin);
			ent PlaySound("cstl_panel_off");
			ent PlayLoopSound("cstl_fusebox_sparks");
			wait(1.3);
			ent StopLoopSound();
			wait(1);
			ent Delete();
		}
		break;
		
		case "toss_flare":
		{
			flare = args;
			flare thread play_sound_on_tag("cstl_flare_start", "TAG_FIRE_FX");
			flare thread play_loop_sound_on_tag("cstl_flare_loop", "TAG_FIRE_FX");
		}
		break;
		
		case "price_open_prison_exit_door":
		{
			wait(3);
			// price unbolts door
			play_sound_in_space("cstl_prison_bolt", (35, 465, -223));
			wait(.2);
			// door swings open
			play_sound_in_space("cstl_prison_door", (35, 465, -223));
		}
		break;
		
		// BRIDGE
		case "player_plant_c4_bridge":
		{
			// plant c4
			wait(1.2);
			level.player play_sound_on_entity("cstl_detpack_wall_plant");
		}
		break;
		
		case "btr_drives_across_bridge":
		{
			ent = Spawn("script_origin", args.origin);
			ent LinkTo(args);
			ent PlayLoopSound("cstl_btr_idling_01");
			flag_wait( "wet_wall_start" );
			ent StopLoopSound();
			wait(0.5);
			ent delete();
		}
		break;
		
		case "player_shimmy_boards":
		{
			// play a wooden creak sound
			level.player PlaySound("bridge_wood_creak");
		}
		break;
		
		case "price_set_detcord":
		{
			thread aud_price_set_detcord();
		}
		break;
		
		case "price_start_climb":
		{
			// prime stream
			level.price aud_prime_stream("cstl_price_climb_wall");
			wait(9.2);     
			// start climb
			level.price PlayLoopSound("cstl_price_climb_wall");
			wait(14.9);
			level.price StopLoopSound();
			
			wait(1);
		}
		break;
		
		case "price_start_climb2":
		{
			// start climb
			level.price PlaySound("cstl_price_climb_wall_2");
			wait(17);
			
		}
		break;
		
		case "player_start_climb":
		{
			// start climb
			wait(3.5);
			level.price StopLoopSound();
			level.price aud_release_stream("cstl_price_climb_wall");
			level.price aud_prime_stream("cstl_price_climb_wall_2");
		}
		break;
		
		case "play_alarm":
		{
			thread play_alarm();
		}
		break;
		
		case "player_wetwall_jump":
		{
			thread aud_player_wetwall_jump();
		}
		break;
			
		// KITCHEN
		case "player_crash_to_kitchen":
		{
			// crash through floor
			thread aud_player_crash_to_kitchen();
		}
		break;
		
		case "enemy_roll_cart":
		{
			// enemy rolls cart at player
			args PlayLoopSound("cstl_kitchen_cart_roll");
		}
		break;
		
		case "cart_impact":
		{
			args StopLoopSound();
			play_sound_in_space("cstl_kitchen_cart_impact", args.origin);
		}
		break;
		
		
		// OUTSIDE COURTYARD
		case "rpg_hits_spire":
		{
			thread play_sound_in_space("cstl_spire_crumble", (-468, 3533, 367));
			thread play_sound_in_space("cstl_spire_crumble_2", (-468, 3533, 367));
		}
		break;
		
		case "bridge_detonate":
		{
			// detonate bridge
			args playSound("cstl_btr_metal_fall");
		}
		break;
		
		case "player_jumped_to_bridge":
		{
			wait(0.5);
			level.player play_sound_on_entity("cstl_land_truck");
		}
		break;

		
		// ESCAPE

		//called as price starts his get-in animation
		case "price_enter_vehicle_start":
		{
			thread aud_price_enter_vehicle_start();
		}
		break;
		
		//called as soon as he’s finished getting into the truck. Minimum of 1-second idle-time here before starting to drive
		case "price_in_truck":
		{
			thread aud_price_in_truck();
		}
		break;
		
		//called right as the player starts entering truck
		case "player_enters_truck":
		{
			thread aud_player_enters_truck();
		}
		break;
		
		//called exactly 1 second before the vehicle starts moving 
		case "start_driving":
		{
			thread aud_start_driving();
		}
		break;
	
		
		case "truck_ride_start":
		{
			thread aud_truck_ride_start();
		}
		break;
		
		case "detonate_c4":
		{
			thread aud_detonate_c4();
		}
		break;
		
		case "truck_doors_crash":
		{
			thread aud_truck_doors_crash();
		}
		break;
		
		case "fence_debris":
		{
			thread aud_fence_debris();
		}
		break;
		
		case "truck_off_cliff":
		{
			// logic
			thread aud_truck_off_cliff();
			thread play_fence_break();
			wait(0.5);
			thread play_freefall();
			wait(2.5);
			
			if (flag("aud_chute_deployed"))
			{
				thread play_chute_deploy();
				wait(2);
				thread play_chute_loop("player_landed_on_bank", 0);
			}
		}
		break;
		
		case "escape_truck_explodes":
		{
			thread aud_escape_truck_explodes();
		}
		break;
		
		case "chute_deployed":
		{
			// logic
			thread play_chute_ripcord();
			flag_set("aud_chute_deployed");
		}
		break;
		
		default:
		{
			aud_print("castle_aud_msg_handler() unhandled message: " + msg);
			msg_handled = false;
		}
		break;
	}

	return msg_handled;
}



/********************************************************************
	Support Functions.
********************************************************************/


//!INTRO - SUPPORT

aud_cstl_parachute_intro_plr()
{
	ent = Spawn("script_origin", level.player.origin);
	ent PlaySound("cstl_parachute_intro_plr", "sounddone");
	ent waittill("sounddone");
	ent Delete();
}

//!WETWALL -SUPPORT

aud_price_set_detcord()
{
	level.price_wires_bomb = spawn("script_origin", level.price.origin);
	level.price_wires_bomb playsound("cstl_price_wires_bomb", "sounddone");
	level.price_wires_bomb LinkTo( level.price ); 
	thread delete_on_sounddone(level.price_wires_bomb);
}

play_alarm()
{
	ent = spawn("script_origin", (841, 3286, 603));
	ent PlayLoopSound("cstl_wetwall_siren");
	
	flag_wait( "stop_peeping" );
	wait(2);
	aud_fade_out_and_delete(ent, 1.5);
}

aud_player_wetwall_jump()
{
	level.wetwall_jump01 = spawn("script_origin", level.player.origin);
	level.wetwall_jump01 playsound("cstl_wetwall_fall_01", "sounddone");
	thread delete_on_sounddone(level.wetwall_jump01);
}

aud_player_crash_to_kitchen()
{
	level.wetwall_jump02 = spawn("script_origin", level.player.origin);
	level.wetwall_jump02 playsound("cstl_wetwall_fall_02", "sounddone");
	level.wetwall_jump03 = spawn("script_origin", level.player.origin);
	level.wetwall_jump03 playsound("cstl_wetwall_fall_03", "sounddone");
	
	thread delete_on_sounddone(level.wetwall_jump02);
	thread delete_on_sounddone(level.wetwall_jump03);
	
	AZM_start_zone("castle_kitchen_int");
}

aud_ignore_slowmo()
{
	SoundSetTimeScaleFactor( "norestrict2d", 0 );
	SoundSetTimeScaleFactor( "grondo2d", 0 );
}
		

//!ESCAPE - SUPPORT

aud_price_enter_vehicle_start()
{	
	wait(0.4);
	level.price PlaySound("cstl_price_into_jeep"); 
}

aud_price_in_truck()
{	
	level.jeep_engine_no_start = spawn("script_origin", level.price.origin);
	level.jeep_engine_no_start playloopsound("cstl_jeep_engine_no_start", "sounddone"); 
}

aud_player_enters_truck()
{	
	ent = Spawn("script_origin", level.player.origin);
	ent PlaySound("cstl_player_into_jeep", "sounddone");
	ent waittill("sounddone");
	ent Delete();
}

aud_start_driving()
{	
	if (IsDefined(level.jeep_engine_no_start))
	{
		level.jeep_engine_no_start StopLoopSound();
		thread delete_on_sounddone(level.jeep_engine_no_start);
	}

	level.jeep_engine_start = spawn("script_origin", level.price.origin);
	level.jeep_engine_start LinkTo( level.price );
	level.jeep_engine_start playsound("cstl_jeep_engine_start", "sounddone");
	thread delete_on_sounddone(level.jeep_engine_start);
	
	MUS_stop(2.5);
}


aud_truck_ride_start()
{
	level.escape_engine_01 = spawn("script_origin", level.player.origin);
	level.escape_engine_01 playloopsound("cstl_escape_engine_01", "sounddone");

	level.escape_tires_01 = spawn("script_origin", level.player.origin);
	level.escape_tires_01 playLoopsound("cstl_escape_tires_01", "sounddone");
	
	music_play( "castle_mx_escape" );
}

aud_detonate_c4()
{
	ent = spawn("script_origin", (-246, -1237, 228));
	ent PlaySound("cstl_c4_expl_ending");
	ent waittill("sounddone");
	ent Delete();
}

aud_truck_doors_crash()
{
	level.escape_tires_01 StopLoopSound();
	thread delete_on_sounddone(level.escape_tires_01);
	
	level.escape_tires_02 = spawn("script_origin", level.player.origin);
	level.escape_tires_02 playloopsound("cstl_escape_tires_02", "sounddone");
	
	level.escape_doors = spawn("script_origin", level.player.origin);
	level.escape_doors playsound("cstl_escape_doors", "sounddone");
	thread delete_on_sounddone(level.escape_doors);
}

aud_fence_debris()
{
	ent = Spawn("script_origin", level.player.origin);
	ent PlaySound("cstl_escape_fence_sml", "sounddone");
	ent waittill("sounddone");
	ent Delete();
}

aud_truck_off_cliff()
{
	level.escape_engine_01 StopLoopSound();
	level.escape_tires_02 StopLoopSound();

	level.escape_fence = spawn("script_origin", level.player.origin);
	level.escape_fence playsound("cstl_escape_fence", "sounddone");
	thread delete_on_sounddone(level.escape_fence);
	
	level.escape_engine_02 = spawn("script_origin", level.player.origin);
	level.escape_engine_02 playsound("cstl_escape_engine_02", "sounddone");
	thread delete_on_sounddone(level.escape_engine_02);
	
	wait(1.5);
	thread delete_on_sounddone(level.escape_engine_01);
	thread delete_on_sounddone(level.escape_tires_02);
}

aud_escape_truck_explodes()
{
	ent = Spawn("script_origin", level.player.origin);
	ent PlaySound("cstl_jeep_explosion", "sounddone");
	ent waittill("sounddone");
	ent Delete();	
}

play_fence_break()
{
	ent = Spawn("script_origin", level.player.origin);
	ent PlaySound("cstl_fence_break", "sounddone");
	ent waittill("sounddone");
	ent Delete();	
}

play_freefall()
{
	freefall_ent = Spawn("script_origin", level.player.origin);
	freefall_ent PlayLoopSound("cstl_wind_falling");
	wait(3);
	freefall_ent StopLoopSound();
	wait(1);
	freefall_ent Delete();
}

play_chute_deploy()
{
	ent = Spawn("script_origin", level.player.origin);
	ent PlaySound("cstl_chute_deploy", "sounddone");
	ent waittill("sounddone");
	ent Delete();
	
	music_play( "castle_mx_ending" );
}

play_chute_ripcord()
{
	ent = Spawn("script_origin", level.player.origin);
	wait(0.75);
	ent PlaySound("cstl_chute_ripcord", "sounddone");
	ent waittill("sounddone");
	ent Delete();
}

play_chute_loop(flag, waittime)
{
	ent = Spawn("script_origin", level.player.origin);
	ent PlayLoopSound("cstl_chute_glide_loop");
	flag_wait(flag);
	wait(waittime);
	aud_fade_out_and_delete(ent, 1);
}
