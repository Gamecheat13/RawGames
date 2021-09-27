#include maps\_audio;
#include common_scripts\utility;

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
	aud_use_string_tables(); 
	
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
		Register Level Audio Message Handler Function.
		NOTE:	Should be last thing done in level init function.
	********************************************************************/
	aud_register_handlers();
	
	thread maps\_utility::set_ambient( "hamburg_chopper_ridein" );
}

aud_init_flags()
{
	
}

aud_init_globals()
{
	level.aud.car_horn = spawn("script_origin", (-432, 18275, -30));
	level.aud.convoy_victim01 = false;
	level.aud.convoy_victim02 = false;
}

aud_register_handlers()
{
	aud_register_msg_handler(::hamburg_aud_msg_handler);
}


hamburg_aud_msg_handler(msg, args)
{
	msg_handled = true;

	switch(msg)
	{
		case "exit_tank":
		{
			// start exit sequence
			ent = spawn("script_origin", level.player.origin);
			ent aud_prime_stream("hamb_tank_foley");
			wait(1.9);
			ent PlaySound("hamb_tank_foley", "sounddone");
			ent waittill("sounddone");
			ent aud_release_stream("hamb_tank_foley");
			wait(1);
			ent delete();
		}
		break;
			
		case "humvee_pull_up":
		{
			humvee = args;
			humvee aud_prime_stream("hamb_humvee_drive_up");
			wait(5);
			humvee PlaySound("hamb_humvee_drive_up");
			humvee PlayLoopSound("hamb_humvee_loop");
			wait(7);
			humvee aud_release_stream("hamb_humvee_drive_up");
		}
		break;
		
		case "street_chopper_fly_by":
		{
			// heli flys by
			hind = args[0];
			osprey = args[1];
			thread play_chopper_loop("hamb_hind", hind);
			thread play_chopper_loop("hamb_osprey", osprey);
		}
		break;
		
		case "tank_smash_through_wall":
		{
			// tank smash through wall
			thread tank_bustout_sound((-6106, 17999, 11));
			wait(0.5);
			thread tank_drive_out();
		}
		break;

		case "f15_missile":
		{
			args waittill("death");
			if (IsDefined(args))
			{
				play_sound_in_space("hamb_f15_missile", args.origin);
			}
		}
		break;
		
		case "convoy_victim_1st_car":
		{
			thread aud_convoy_victim_1st_car();
		}
		break;
		
		case "convoy_victim_2nd_car":
		{
			thread aud_convoy_victim_2nd_car();
		}
		break;
	
		case "play_car_horn":
		{
			level.aud.car_horn PlayLoopSound("hamb_car_horn_loop");
		}
		break;
		
		case "stop_car_horn":
		{
			wait(1);
			level.aud.car_horn StopLoopSound();
			wait(1);
			level.aud.car_horn Delete();
		}
		break;
		
		case "breach_free_hostage":
		{
			thread aud_breach_free_hostage();
		}
		break;
		
		case "end_osprey":
		{
			ent = GetEnt("nest_osprey_kill", "targetname");
			sound = spawn("script_origin", ent.origin);
			sound PlayLoopSound("hamb_osprey");
			sound MoveTo((-239, 20238, 615), 5);
		}
		break;
		
		default:
		{
			aud_print("hamburg_aud_msg_handler() unhandled message: " + msg);
			msg_handled = false;
		}
		break;
	}

	return msg_handled;
}

//
//SUPPORT FUNCTIONS//
//


play_chopper_loop(alias, entity)
{
	sound = spawn("script_origin", entity.origin);
	sound LinkTo(entity);
	
	sound PlayLoopSound(alias);
	wait(6);
	aud_fade_out_and_delete(sound, 2);
}

tank_bustout_sound(loc)
{
	thread play_sound_in_space("hamb_tank_thru_wall_blast", loc);
	thread play_sound_in_space("hamb_tank_thru_wall_debris", loc);
}

tank_drive_out()
{
	ent = spawn("script_origin", (-6106, 17999, -81));
	ent PlayLoopSound("hamb_tank_one_shot");
	ent MoveTo((-6271, 18420, -81), 1.5);
	wait(5);
	aud_fade_out_and_delete(ent, 3);
}

aud_convoy_victim_1st_car()
{
	if (level.aud.convoy_victim01 == false)
	{
		level.aud.convoy_victim01 = true;
		ent = spawn("script_origin", (-414, 18345, -42));
		wait(4.25);
		ent PlaySound("hamb_convoy_victim_01");
		ent waittill("sounddone");
		ent Delete();
	}
}

aud_convoy_victim_2nd_car()
{
	if (level.aud.convoy_victim02 == false)
	{
		level.aud.convoy_victim02 = true;
		ent = spawn("script_origin", (-520, 17964, -43));
		wait(8.3);
		ent PlaySound("hamb_convoy_victim_02");
		ent waittill("sounddone");
		ent Delete();
	}
}

aud_breach_free_hostage()
{
	level.sandman_free_hostage = spawn("script_origin", level.sandman.origin);
	wait(2);
	level.sandman_free_hostage playsound("hamb_free_hostage", "sounddone");
	level.sandman_free_hostage LinkTo( level.sandman ); 
	thread delete_on_sounddone(level.sandman_free_hostage);
}
