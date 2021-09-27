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

// This is a spec-ops only file globally used on SHG spec-ops maps
// it is intended to handle audio messages for custom spec-ops content

main(mapname)
{
	aud_register_msg_handler(::so_msg_handler);
//	MM_add_submix("dubai_level_global_mix");

	thread aud_handle_map_setups(mapname);
}

aud_handle_map_setups(mapname)
{
	if (!IsDefined(mapname))
		return;
		
	switch(mapname)
	{
		case "so_nyse_ny_manhattan":
		{
			aud_start_nyse_fire();
		}
		break;
	}
}

so_msg_handler(msg, args)
{
	msg_handled = true;
	
	switch(msg)
	{
		/************************************/
		/******* so_heliswitch_berlin *******/
		/************************************/
		
		case "so_berlin_intro_littlebird_spawn":
		{
			heli = args;
			heli thread play_loop_sound_on_entity("so_littlebird_move");
		}
		break;
		
		/************************************/
		/******* so_ied_berlin *******/
		/************************************/
	 
	 case "so_ied_littlebird":
		{
			heli = args;
			heli thread play_loop_sound_on_entity("so_littlebird_move");
			heli thread aud_helicopter_deathwatch();
		}
		break;
		
		case "so_ied_wave4_littlebird":
		{
			wave4_helo = args;
			wave4_helo thread play_loop_sound_on_entity("so_littlebird_move_distant");
			wave4_helo thread aud_helicopter_deathwatch();
		}
		break;
		
		case "so_ied_wave3_tank":
		{
			tank = args;
			tank thread aud_run_tank_system();
		}
		break;
		
		/************************************/
		/******* so_ied_berlin *******/
		/************************************/
		
		case "so_paris_start_jeep":
		{
			so_jeep = args;
			//so_jeep vehicle_getspeed();
			thread VM_start_preset("so_paris_jeep_01", "so_paris_jeep", so_jeep, 2.0);
		}
		break;
		
		/************************************/
		/******* so_nyse_ny_manhattan *******/
		/************************************/
		
		case "so_nyse_littlebird_spawn":
		{
			heli = args;
			heli play_loop_sound_on_entity("so_nymn_littlebird_move");
		}
		break;	
	 
		/************************************/
		/******* so_zodiac2_nyharbor *******/
		/************************************/
		
		case "so_start_harbor_player_hind":
		{
			player_hind = args;
			player_hind play_loop_sound_on_entity("so_hind_player");
		}
		break;
		
		case "so_harbor_ally_helis":
		{
			helis = args;
			assert(isarray(helis));
			foreach(heli in helis)
			{
				heli thread play_loop_sound_on_entity("so_hind_allies");
			}
		}
		break;
		
		case "so_harbor_kill_helis":
		{
			helis = args;
			assert(isarray(helis));
			foreach(heli in helis)
			{
				heli stop_loop_sound_on_entity("so_hind_allies");
			}
		}
		break;
		
		case "so_start_harbor_exit_hind":
		{
			exit_hind = args;
			assert(Isdefined(exit_hind));
			exit_hind play_loop_sound_on_entity("so_exit_hind_player");
		}
		break;
		
		case "so_harbor_enemy_chopper_flyover":
		{
			enemy_chopper = args;
			assert(Isdefined(enemy_chopper));
			enemy_chopper play_sound_on_entity("so_sub_hind_flyover");
		}
		break;
		
		case "so_sub_missile_launch":
		{
			missile = args;
			aud_handle_so_missile(missile);
		}
		break;
		
		default:
		{
			msg_handled = false;
		}
	}

	return msg_handled;
}

aud_start_nyse_fire()
{
	DAMB_start_preset_at_point("fire_wood_med", (-945, -2847, 262), "steff_01", 1000, 1.0); //right pillar top
	DAMB_start_preset_at_point("fire_wood_med", (-1181, -2926, 55), "steff_02", 1000, 1.0); //fallen display case
	DAMB_start_preset_at_point("fire_wood_med_tight", (-1004, -2927, 42), "steff_03", 1000, 1.0); //right pillar base
	DAMB_start_preset_at_point("fire_crackle_med_tight", (-902, -2716, 66), "steff_04", 1000, 1.0); //left pillar base
	DAMB_start_preset_at_point("fire_wood_med_tight", (-909, -2636, 36), "steff_05", 1000, 1.0); //left pillar corner
	
	//Outside Stephanies Alley
	DAMB_start_preset_at_point("fire_wood_med", (-686, -2120, 91), "steff_car", 1000, 1.0); //car immediately outside stephanies
	
	//Flares
	play_loopsound_in_space("road_flare_lp_tight",(-141,271,2));//flare 1
	play_loopsound_in_space("road_flare_lp_tight",(-259,579,2));//flare 2
	play_loopsound_in_space("road_flare_lp_tight",(-475,980,10));//flare 3
	play_loopsound_in_space("road_flare_lp_tight",(-704,311,-7));//flare 4
	
	//Pre Stock exchange
	DAMB_start_preset_at_point("fire_crackle_med_tight", (-471, 1856, -22), "pre_stock_01", 1000, 1.0); //small metal fire pre escalator
}

aud_handle_so_missile(missile)
{
	if (!Isdefined(missile))
		return;
		
	// fake occlude missile launch and boom sound for specific zones
	if (!IsDefined(level.aud.is_occluded))
	{
		level.aud.is_occluded = false;
	}

	current_zone = AZM_get_current_zone();
	if ( (current_zone == "nyhb_sub_interior_controlroom" || current_zone == "nyhb_sub_interior_missileroom2") && !level.aud.is_occluded)
	{
		level.aud.is_occluded = true;
		// need to disable zone filtering and occluding for this to not get overridden
		aud_disable_zone_filter();
		level.player SetEq("grondo3d", 0, 0, "lowpass", 0, 400, 2);
		level.player SetEq("norestrict2d", 0, 0, "lowpass", 0, 400, 2);
		level.player seteqlerp(1, 0);
		// monitor the zone so we can disable this eq when player exists these zones
		thread monitor_zone_to_disable_eq();
	}
	wait(0.05);
	missile playsound("russian_sub_missile_launch");
	wait 1.25;
	missile playsound("russian_sub_missile_launch_boom");
}


monitor_zone_to_disable_eq()
{
	while(true)
	{
		current_zone = AZM_get_current_zone();
		if (current_zone != "nyhb_sub_interior_controlroom" && current_zone != "nyhb_sub_interior_missileroom2")
		{
			aud_enable_zone_filter();
			level.player DeactivateEq(0, "grondo3d", 0);
			level.player DeactivateEq(0, "norestrict2d", 0);
			level.aud.is_occluded = false;
			return;
		}
		level.player seteqlerp(1, 0);
		wait(0.1);
	}
}

aud_helicopter_deathwatch()
{
	level.aud.crashpos = (0,0,0);
	
	self waittill("deathspin");
	self thread aud_heli_crash_pos();
	self thread play_loop_sound_on_entity("so_littlebird_helicopter_dying_loop");
	self waittill_either("death","crash_done");
	thread play_sound_in_space("so_littlebird_helicopter_crash", level.aud.crashpos);
}

// update the position of the heli crash sound in case it's deleted before we have a chance to grab it's position
aud_heli_crash_pos()
{ 
	self endon("death");
	while(1)
	{
		if(IsDefined(self))
		{
			self.origin = level.aud.crashpos;
			wait(0.05);
		}
	}
}

aud_run_tank_system()
{
	self aud_ground_veh_loops("ied_tank_01", "us_tank_treads_lp_02", "us_tank_move_low_lp", "us_tank_idle_lp");
	self aud_tank_fire_watch();
}

aud_ground_veh_loops(instance_name, move_loop, roll_loop, idle_loop)
{
	if(IsDefined(self))
	{
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
		
		self aud_ground_veh_speed_mapping(instance, move_ent, roll_ent, idle_ent, 1, 5, fade_in);
	}
}

aud_ground_veh_speed_mapping(instance, move_ent, roll_ent, idle_ent, min_speed, max_speed, fade_in)
{
	min_speed = 1;
	max_speed = 5;
	
	self thread aud_ground_veh_deathwatch(instance, move_ent, roll_ent, idle_ent);
	
	thread aud_create_drive_envs();

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
			
			roll_ent scalevolume(veh_drive_vol, 0.1);
			move_ent scalevolume(veh_drive_vol, 0.1);
			idle_ent scalevolume(veh_idle_vol, 0.1);
			
			prev_veh_speed = veh_speed;
			
			wait(0.1);
		}
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
	if(Isdefined(self))
	{
		self waittill("death");
		instance notify("instance_killed");
		thread aud_fade_loop_out_and_delete_temp(move_ent, 5);
		thread aud_fade_loop_out_and_delete_temp(roll_ent, 5);
		thread aud_fade_loop_out_and_delete_temp(idle_ent, 5);
	}
}

aud_tank_fire_watch()
{
	self endon("death");
	
	if(IsDefined(self))
	{
		while(1)
		{
			self waittill("weapon_fired");

			rand_wait = randomfloatrange(0.2, 0.4);
			
			thread play_sound_in_space("us_tank_big_boom", self.origin);
			thread play_sound_in_space("us_tank_fire_dist", self.origin);
			thread play_sound_in_space("us_tank_fire_close", self.origin);
			thread play_sound_in_space("us_tank_fire_hi_ring", self.origin);
			thread play_sound_in_space("us_tank_fire_lfe", self.origin);
			wait(0.2);
			thread play_sound_in_space("us_tank_dist_verb", self.origin);
			wait(rand_wait);
			//self thread aud_post_tank_fire_sfx();
		}
	}
}

aud_fade_loop_out_and_delete_temp(ent, fadetime)
{
	ent scalevolume(0.0, fadetime);
	wait(fadetime + 0.05);
	ent stoploopsound();
	wait(0.05);
	ent delete();
}
