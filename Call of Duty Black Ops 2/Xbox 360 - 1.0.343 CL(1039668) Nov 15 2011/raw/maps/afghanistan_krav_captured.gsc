#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_scene;
#include maps\afghanistan_utility;
#include maps\_anim;


/* ------------------------------------------------------------------------------------------
	INIT functions
-------------------------------------------------------------------------------------------*/

//
//	Declare event-specific flags here
init_flags()
{
	flag_init( "interrogation_started" );
	flag_init( "numbers_struggle_completed" );
}


//
//	Need an AI to run something when spawned?  Put it here.
init_spawn_funcs()
{
//	add_spawn_function( "intro_drone", ::intro_drone );
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions	(you may have more than one skipto in this file)
-------------------------------------------------------------------------------------------*/

//
//	This is run before your main function is executed.  Put any skipto-only initialization here.
skipto_krav_captured()
{
	skipto_setup();
	
	level.woods = init_hero("woods");
	level.zhao = init_hero("zhao");
	level.hudson = init_hero("hudson");
	level.kravchenko = init_hero("kravchenko");
	
	start_teleport( "skipto_krav_captured", level.heroes );
	
	e_hudson_pos = GetEnt("krav_capture_hudson_pos", "targetname");
	e_zhao_pos = GetEnt("krav_capture_zhao_pos", "targetname");
	e_krav_pos = GetEnt("krav_capture_krav_pos", "targetname");
	e_woods_pos = GetEnt("krav_capture_woods_pos", "targetname");
	
	level.hudson forceteleport(e_hudson_pos.origin, e_hudson_pos.angles);
	level.zhao forceteleport(e_zhao_pos.origin, e_zhao_pos.angles);
	level.kravchenko forceteleport(e_krav_pos.origin, e_krav_pos.angles);
	level.woods forceteleport(e_woods_pos.origin, e_woods_pos.angles);
}

skipto_krav_interrogation()
{
	skipto_setup();
	
	level.woods = init_hero("woods");
	level.zhao = init_hero("zhao");
	level.hudson = init_hero("hudson");
	level.kravchenko = init_hero("kravchenko");
	level.rebel_leader = init_hero("rebel_leader");
	
	start_teleport( "skipto_krav_interrogation", level.heroes );
	
	e_hudson_pos = GetEnt("krav_interrogation_hudson_pos", "targetname");
	e_zhao_pos = GetEnt("krav_interrogation_zhao_pos", "targetname");
	e_krav_pos = GetEnt("krav_interrogation_krav_pos", "targetname");
	e_woods_pos = GetEnt("krav_interrogation_woods_pos", "targetname");
	e_leader_pos = GetEnt("krav_interrogation_leader_pos", "targetname");
	
	level.hudson forceteleport(e_hudson_pos.origin, e_hudson_pos.angles);
	level.zhao forceteleport(e_zhao_pos.origin, e_zhao_pos.angles);
	level.kravchenko forceteleport(e_krav_pos.origin, e_krav_pos.angles);
	level.woods forceteleport(e_woods_pos.origin, e_woods_pos.angles);
	level.rebel_leader forceteleport(e_leader_pos.origin, e_leader_pos.angles);
	
	level.zhao SetGoalPos(e_zhao_pos.origin);
	level.woods SetGoalPos(e_woods_pos.origin);
}

skipto_beat_down()
{
	skipto_setup();
	
	level.woods = init_hero("woods");
	level.zhao = init_hero("zhao");
	level.hudson = init_hero("hudson");
	level.kravchenko = init_hero("kravchenko");
	level.rebel_leader = init_hero("rebel_leader");
	
	start_teleport( "skipto_krav_interrogation", level.heroes );
	
	e_hudson_pos = GetEnt("krav_interrogation_hudson_pos", "targetname");
	e_zhao_pos = GetEnt("krav_interrogation_zhao_pos", "targetname");
	e_krav_pos = GetEnt("krav_interrogation_krav_pos", "targetname");
	e_woods_pos = GetEnt("krav_interrogation_woods_pos", "targetname");
	e_leader_pos = GetEnt("krav_interrogation_leader_pos", "targetname");
	
	
	level.hudson forceteleport(e_hudson_pos.origin, e_hudson_pos.angles);
	level.zhao forceteleport(e_zhao_pos.origin, e_zhao_pos.angles);
	level.kravchenko forceteleport(e_krav_pos.origin, e_krav_pos.angles);
	level.woods forceteleport(e_woods_pos.origin, e_woods_pos.angles);
	level.rebel_leader forceteleport(e_leader_pos.origin, e_leader_pos.angles);
	
	level.kravchenko stop_magic_bullet_shield();
	level.kravchenko dodamage(level.kravchenko.health * 2, level.kravchenko.origin);
	
	level.zhao SetGoalPos(e_zhao_pos.origin);
	level.woods SetGoalPos(e_woods_pos.origin);
	
	//forceteleport
	//.fixednode
}
/* ------------------------------------------------------------------------------------------
	MAIN functions 
-------------------------------------------------------------------------------------------*/
//
//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//		your skipto sequence will be called.
main()
{
	// Temp Development info
	/#
	IPrintLn( "Event Name" );
	#/
	// Initialization

	// Additional event logic
	level turn_down_fog();
	level thread spawn_celebrating_scene();	
	
	if(!flag("interrogation_started"))
	{
		level thread muj_celebration();
	}
	
	level thread move_heroes_interrogation_room();
		
	if(!flag("numbers_struggle_completed"))
	{
		level thread numbers_struggle_event();
	}
	
	level thread beatdown();
}

// Handles kravchenko numbers event
muj_celebration()
{
	flag_wait("second_base_visit");
	
	level.player freezecontrols(false);
	
	thread run_scene("e5_s1_walk_in");
	
	if(flag("screen_fade_out_start"))
	{
		flag_wait("screen_fade_out_end");
		screen_fade_in();
	}
	
	level.player AllowSprint(false);
	level.player setlowready(true);
	
	level.scene_sys waittill("e5_s1_walk_in_done");
	flag_set("interrogation_started");
	//level.player unlink();
	//level.player freezecontrols(false);
	
	//woods_pos = getent("krav_capture_woods_push_pos", "targetname");
	//zhao_pos = getent("krav_capture_zhao_move_pos", "targetname");
	//krav_pos = getent("krav_capture_krav_push_pos", "targetname");
	//hudson_pos = getent("krav_capture_hudson_pos", "targetname");
	
	//wait 1;
	
//	level.woods set_goalradius( 5 );
//	level.zhao set_goalradius( 5 );
//	level.kravchenko set_goalradius( 5 );
//	level.hudson set_goalradius( 5 );
//	
//	level.woods SetGoalPos(woods_pos.origin);
//	level.zhao SetGoalPos(zhao_pos.origin);
//	level.kravchenko SetGoalPos(krav_pos.origin);
//	level.hudson SetGoalPos(hudson_pos.origin);
//	
//	level.woods waittill("goal");
//	wait 1;
//	
//	krav_pos = getent("krav_capture_krav_move_pos", "targetname");
//	woods_pos = getent("krav_capture_woods_move_pos", "targetname");
//	
//	level.woods set_goalradius( 5 );
//	level.kravchenko set_goalradius( 5 );
//	level.kravchenko SetGoalPos(krav_pos.origin);
//	level.woods SetGoalPos(woods_pos.origin);
//	
//	level.woods waittill("goal");
//	wait 3;
//	
//	iprintlnbold("got past wait");
//	
//	e_hudson_pos = GetEnt("krav_interrogation_hudson_pos", "targetname");
//	e_zhao_pos = GetEnt("krav_interrogation_zhao_pos", "targetname");
//	e_krav_pos = GetEnt("krav_interrogation_krav_pos", "targetname");
//	e_woods_pos = GetEnt("krav_interrogation_woods_pos", "targetname");
//
//	iprintlnbold("got past getent");
//	
//	level.woods set_goalradius( 64 );
//	level.zhao set_goalradius( 64 );
//	level.kravchenko set_goalradius( 64 );
//	level.hudson set_goalradius( 64 );
//	
//	level.hudson SetGoalPos(hudson_pos.origin);
//	level.zhao SetGoalPos(zhao_pos.origin);
//	level.kravchenko SetGoalPos(krav_pos.origin);
//	level.woods SetGoalPos(woods_pos.origin);

	// setmovespeedscale
	// set run anim
}

move_heroes_interrogation_room()
{
	flag_wait("second_base_visit");
	trigger_wait("trigger_set_up_interrogation");
	
	if(!IsDefined(level.woods))
	{
		level.woods = init_hero("woods");
	}
	if(!IsDefined(level.zhao))
	{
		level.zhao = init_hero("zhao");
	}
	if(!IsDefined(level.hudson))
	{
		level.hudson = init_hero("hudson");
	}
	if(!IsDefined(level.kravchenko))
	{
		level.kravchenko = init_hero("kravchenko");
	}
	if(!IsDefined(level.rebel_leader))
	{
		level.rebel_leader = init_hero("rebel_leader");
	}
	
	e_hudson_pos = GetEnt("krav_interrogation_hudson_pos", "targetname");
	e_zhao_pos = GetEnt("krav_interrogation_zhao_pos", "targetname");
	e_krav_pos = GetEnt("krav_interrogation_krav_pos", "targetname");
	e_woods_pos = GetEnt("krav_interrogation_woods_pos", "targetname");
	e_leader_pos = GetEnt("krav_interrogation_leader_pos", "targetname");
	
	level.hudson forceteleport(e_hudson_pos.origin, e_hudson_pos.angles);
	level.zhao forceteleport(e_zhao_pos.origin, e_zhao_pos.angles);
	level.kravchenko forceteleport(e_krav_pos.origin, e_krav_pos.angles);
	level.woods forceteleport(e_woods_pos.origin, e_woods_pos.angles);
	level.rebel_leader forceteleport(e_leader_pos.origin, e_leader_pos.angles);
	
	level.zhao SetGoalPos(e_zhao_pos.origin);
	level.woods SetGoalPos(e_woods_pos.origin);
	level.kravchenko SetGoalPos(e_krav_pos.origin);
}

#using_animtree( "player" );
play_brainwash_animations()
{
	self endon("krav_got_shot");
	self endon("phase_complete");
	
	//self.viewmodel setanim( %int_afghan_brainwashaim_2, 1, 0, 1);
	//self.viewmodel setanim( %int_afghan_brainwashaim_4, 1, 0, 1);
	
	x_weight = (abs(self.n_gun_pos_x) / 100);
	y_weight = (abs(self.n_gun_pos_y) / 100);
	max_weight = max( x_weight, y_weight );
	self.viewmodel SetAnim( %int_afghan_brainwashaim_neutral, 1 - max_weight, 0, 1 );
	
	//down
	if(self.n_gun_pos_x < 0)
	{
		self.viewmodel SetAnimKnobLimited( %int_afghan_brainwashaim_2, 1, 0, 1);
		self.viewmodel SetAnimLimited( %int_afghan_brainwashaims_ud, x_weight, 0, 1);
	}
	//up
	else if(self.n_gun_pos_x > 0)
	{
		self.viewmodel SetAnimKnobLimited( %int_afghan_brainwashaim_8, 1, 0, 1);
		self.viewmodel SetAnimLimited( %int_afghan_brainwashaims_ud, x_weight, 0, 1);
	}
	else
	{
		self.viewmodel SetAnimLimited( %int_afghan_brainwashaims_ud, 0 );
	}
	
	//left
	if(self.n_gun_pos_y < 0)
	{
		self.viewmodel SetAnimKnobLimited( %int_afghan_brainwashaim_4, 1, 0, 1);
		self.viewmodel SetAnimLimited( %int_afghan_brainwashaims_lr, y_weight, 0, 1);
	}
	//right
	else if(self.n_gun_pos_y > 0)
	{
		self.viewmodel SetAnimKnobLimited( %int_afghan_brainwashaim_6, 1, 0, 1);
		self.viewmodel SetAnimLimited( %int_afghan_brainwashaims_lr, y_weight, 0, 1);
	}
	else
	{
		self.viewmodel ClearAnim( %int_afghan_brainwashaims_lr, 0 );
	}
}

#using_animtree( "player" );
setup_brainwash_animations()
{
	self endon("krav_got_shot");
	self endon("phase_complete");
	
	self.viewmodel = spawn("script_model",self.origin);
	self.viewmodel setmodel("c_usa_cia_masonjr_viewbody");
	
	self.viewmodel useanimtree(#animtree);
	
	self.viewmodel.origin = self.origin;
	self.viewmodel.angles = self.angles;
	
	self.viewmodel attach("t5_weapon_1911_sp_world", "tag_weapon");
	
	self hideviewmodel();
	
	self.viewmodel setanim(%int_afghan_brainwashaim_pullout, 1, 0, 1);
	
	wait level.n_pullout_anim_durration;
	
	self thread run_brainwash_anim_loop();
}

#using_animtree( "player" );
run_brainwash_anim_loop()
{
	self endon("krav_got_shot");
	self endon("phase_complete");
	
	//self.viewmodel clearanim(%root, 0.0);
	
	self.viewmodel ClearAnim( %root, 0);
	
	self.viewmodel setanim( %int_afghan_brainwashaim_idle, 1, 0, 1);
	
	while(1)
	{
		self play_brainwash_animations();
		wait 0.05;
	}
}

numbers_struggle_event()
{
	flag_wait("interrogation_started");
	//trigger_wait("trigger_start_numbers_struggle");
	
	level clientnotify( "snsc" );
	
	level thread run_scene("e5_s2_interrogation_loop");
	
	wait 1;
	
	level.new_origin = level.kravchenko.origin + (0,0,50);
	
	level.player.a_last_input = [];
	level.player.a_last_input[0] = 0;
	level.player.a_last_input[1] = 0;
	level.player.n_tween_for_look_at = 0.2;
	
	level.player.a_cam_movement = [];
	level.player.a_cam_movement[0] = 0;
	level.player.a_cam_movement[1] = 0;
	
	level.player.n_gun_pos_x = 0;
	level.player.n_gun_pos_y = 0;
	
	level.player.n_resistance_tick = 0.015;
	level.player.n_resistance_strength_x = 0;
	level.player.n_resistance_strength_y = 0;
	
	level.player.n_gun_x_quadrent_last_tick = 0;
	level.player.n_gun_y_quadrent_last_tick = 0;
	
	level.player.is_shooting = false;
	level.player.is_running_gun_center_track = false;
	
	level.n_pullout_anim_durration = getanimlength( %player::int_afghan_brainwashaim_pullout );
	level.player thread setup_brainwash_animations();
	
	wait level.n_pullout_anim_durration + 2;

	level.player.b_left_direction_last = true;
	level.player.b_up_direction_last = true;
	
	iprintlnbold("PHASE: 1");
	iprintlnbold("player gun movement active");
	iprintlnbold("HOLD LEFT / UP");
	level.player thread display_info_for_numbers_struggle();
	
	level thread manage_numbers();
	
	for(i = 0; i < 3; i++)
	{
		
		
		n_numbers_durration = 20.0;
		level.player thread gun_resistance_logic();
		
		while(n_numbers_durration > 0)
		{
			if(level.player.is_shooting)
			{
				level.kravchenko stop_magic_bullet_shield();
				thread run_scene("e5_s2_interrogation_shoot_v2");
				
				//wait 0.5;
				level.player.is_shooting = true;
				break;
			}
			
			level.player.a_cam_movement = level.player GetNormalizedCameraMovement();
			
			if((level.player.n_gun_pos_x + level.player.a_cam_movement[0]) < 100 && (level.player.n_gun_pos_x + level.player.a_cam_movement[0]) > -100)
			{
				level.player.n_gun_pos_x += level.player.a_cam_movement[0];
			}
			
			if((level.player.n_gun_pos_y + level.player.a_cam_movement[1]) < 100 && (level.player.n_gun_pos_y + level.player.a_cam_movement[1]) > -100)
			{
				level.player.n_gun_pos_y += level.player.a_cam_movement[1];
			}
			
			wait 0.05;
			n_numbers_durration -= 0.05;
		}
		
		if(level.player.is_shooting || i == 2)
		{
			break;
		}
		
		level.player.n_gun_pos_x = 0;
		level.player.n_gun_pos_y = 0;
		level.player.n_resistance_strength_x = 0;
		level.player.n_resistance_strength_y = 0;
		level.player.n_resistance_tick += 0.02;
		
		level.player notify("phase_complete");
		
		//level.player.viewmodel setanim( %int_afghan_brainwashaim_fire, 1, 0, 1 );
		
		run_scene("e5_s2_interrogation_punch");
		thread run_scene("e5_s2_interrogation_loop");
		
		level.player.viewmodel ClearAnim( %root, 0);
		
		level.player.viewmodel setanim(%int_afghan_brainwashaim_pullout, 1, 0, 1);
		wait level.n_pullout_anim_durration + 2;
		
		iprintlnbold("PHASE: " + (i+2));
		iprintlnbold("player gun movement active");
		
		level.player thread run_brainwash_anim_loop();
	}
	
	n_scene_version = 0;
	
	if(!level.player.is_shooting)
	{
		run_scene("e5_s2_interrogation_move2shoot");
		iprintlnbold("Woods killed Kravchenko");
		level clientnotify( "ensc" );
		n_scene_version = 1;
		level.kravchenko stop_magic_bullet_shield();
		thread run_scene("e5_s2_interrogation_shoot_v1");
	}
	else
	{
		level.player.viewmodel clearanim(%root, 0.0);
		
		level.player.viewmodel setanim( %int_afghan_brainwashaim_fire, 1, 0, 1 );
		level.n_pullout_anim_durration = getanimlength( %player::int_afghan_brainwashaim_fire );
		wait level.n_pullout_anim_durration;
		MagicBullet("m1911_sp", (level.player.origin + (0,0,100)), level.new_origin);
				
		iprintlnbold("Player killed Kravchenko");
		level clientnotify( "ensc" );
		n_scene_version = 2;
	}
	
	level.m_numbers_base_link delete();

	
	if(isDefined(level.m_numbers_center_link))
	{
		level.m_numbers_center_link delete();
	}
	if(isDefined(level.m_numbers_intense_link))
	{
		level.m_numbers_intense_link delete();
	}
	
	level.player notify("krav_got_shot");
	level.player.viewmodel delete();
	
	level.scene_sys waittill("e5_s2_interrogation_shoot_v" + n_scene_version + "_done");

	flag_set("numbers_struggle_completed");
}

manage_numbers()
{
	level.player endon("krav_got_shot");
	
	level.m_numbers_base_link = spawn("script_model",level.player.origin);
	level.m_numbers_base_link setmodel("tag_origin");
	level.m_numbers_base_link.angles = (0,0,0);
	PlayFX( level._effect[ "numbers_base" ], level.m_numbers_base_link.origin );
	
//	n_center_handle = -1;
//	n_intense_handle = -1;
	
	center_effect_playing = false;
	intense_effect_playing = false;
	
	while(1)
	{
		is_in_the_center = (level.player.n_gun_pos_x < 20 && level.player.n_gun_pos_x > -20 && 
			level.player.n_gun_pos_y < 20 && level.player.n_gun_pos_y > -20);
		
		if(is_in_the_center && !center_effect_playing)
		{
			//level.m_numbers_center_link = spawn("script_model",level.kravchenko.origin + (0,100,0));
			level.m_numbers_center_link = spawn("script_model",level.player.origin);
			level.m_numbers_center_link setmodel("tag_origin");
			level.m_numbers_center_link.angles = (0,0,0);
			
			PlayFXOnTag( level._effect[ "numbers_center" ], level.m_numbers_center_link, "tag_origin" );
			center_effect_playing = true;
		}
		else if(!is_in_the_center && center_effect_playing)
		{
			if(isDefined(level.m_numbers_center_link))
			{
				level.m_numbers_center_link delete();
			}
			center_effect_playing = false;
		}
		
		resistance_is_high = (level.player.n_gun_pos_x < 50 && level.player.n_gun_pos_x > -50 && 
			level.player.n_gun_pos_y < 50 && level.player.n_gun_pos_y > -50);
		
		if(resistance_is_high && !intense_effect_playing)
		{
			//level.m_numbers_intense_link = spawn("script_model",level.kravchenko.origin + (0,100,0));
			level.m_numbers_intense_link = spawn("script_model",level.kravchenko.origin);
			level.m_numbers_intense_link setmodel("tag_origin");
			level.m_numbers_intense_link.angles = (0,0,0);
			
			PlayFXOnTag( level._effect[ "numbers_mid" ], level.m_numbers_intense_link, "tag_origin" );
			intense_effect_playing = true;
		}
		else if(!resistance_is_high && intense_effect_playing)
		{
			if(isDefined(level.m_numbers_intense_link))
			{
				level.m_numbers_intense_link delete();
			}
			intense_effect_playing = false;
		}
		
		wait 0.05;
	}
}

beatdown()
{
	flag_wait("numbers_struggle_completed");
	
	level thread run_scene("e5_s4_beatdown");
	
	wait 11;
	
	screen_fade_out();
	flag_set("deserted_sequence");
	flag_wait("screen_fade_out_end");
	level.player unlink();
	
	wait 0.05;
	
	start_teleport( "skipto_deserted_player" );
}

/* ------------------------------------------------------------------------------------------
	SUPPORT functions
-------------------------------------------------------------------------------------------*/

// Everything else goes here
spawn_celebrating_scene()
{
	flag_wait("second_base_visit");
	//iprintlnbold("cele_spawned");
	level thread run_scene("e5_s1_celebrating_muj");
	level thread run_scene("e5_s1_celebrating_riders");
}

display_info_for_numbers_struggle()
{
	self endon("krav_got_shot");
	self endon("phase_complete");

	while(1)
	{
		
		if(!level.player.b_left_direction_last && level.player.n_gun_pos_y < 20 && level.player.n_resistance_strength_y < -0.1)
		{
			iprintlnbold("HOLD LEFT");
			level.player.b_left_direction_last = true;         
		}
		else if(level.player.b_left_direction_last && level.player.n_gun_pos_y > -20 && level.player.n_resistance_strength_y > 0.1)
		{
			iprintlnbold("HOLD RIGHT");
			level.player.b_left_direction_last = false;     
		}
		
		if(level.player.b_up_direction_last && level.player.n_gun_pos_x < 20 && level.player.n_resistance_strength_x < -0.1)
		{
			iprintlnbold("HOLD DOWN");
			level.player.b_up_direction_last = false;         
		}
		else if(!level.player.b_up_direction_last && level.player.n_gun_pos_x > -20 && level.player.n_resistance_strength_x > 0.1)
		{
			iprintlnbold("HOLD UP");
			level.player.b_up_direction_last = true;     
		}
		
		wait 0.05;
	}
}

gun_resistance_logic()
{
	self endon("krav_got_shot");
	self endon("phase_complete");
	
	while(1)
	{
	
		n_x_quadrent = 0;
		n_y_quadrent = 0;
		
		is_in_the_center = (self.n_gun_pos_x <= 20 && self.n_gun_pos_y <= 20 && self.n_gun_pos_x >= -20 && self.n_gun_pos_y >= -20);
		
		if(is_in_the_center && !self.is_running_gun_center_track && !self.is_shooting)
		{
			self thread track_gun_in_center_too_long();
		}
		
		if(self.n_gun_pos_x > 20 || self.n_gun_pos_x < -20)
		{
			n_x_quadrent = (self.n_gun_pos_x / abs(self.n_gun_pos_x));
		}
		
		if(self.n_gun_pos_y > 20 || self.n_gun_pos_y < -20)
		{
			n_y_quadrent = (self.n_gun_pos_y / abs(self.n_gun_pos_y));
		}
		
		if( n_x_quadrent == (self.n_gun_x_quadrent_last_tick * -1) )
		{
			self.n_resistance_strength_x = 0;
		}
		else
		{
			if(self.n_resistance_strength_x < 100 && self.n_resistance_strength_x > -100)
				self.n_resistance_strength_x += (n_x_quadrent * -1) * self.n_resistance_tick;
		}
		
		if(n_y_quadrent == (self.n_gun_y_quadrent_last_tick * -1) )
		{
			self.n_resistance_strength_y = 0;
		}
		else
		{
			if(self.n_resistance_strength_y < 100 && self.n_resistance_strength_y > -100)
				self.n_resistance_strength_y += (n_y_quadrent * -1) * self.n_resistance_tick;
		}
		
		if(n_x_quadrent != 0)
		{
			self.n_gun_x_quadrent_last_tick = n_x_quadrent;
		}
		
		if(n_y_quadrent != 0)
		{
			self.n_gun_y_quadrent_last_tick = n_y_quadrent;
		}
		
		if(self.n_gun_pos_x > 10 || self.n_gun_pos_x < -10)
		{
			self.n_gun_pos_x += self.n_resistance_strength_x;
		}
		if(self.n_gun_pos_y > 10 || self.n_gun_pos_y < -10)
		{
			self.n_gun_pos_y += self.n_resistance_strength_y;
		}
		wait 0.05;
	}
}

track_gun_in_center_too_long()
{
	self endon("krav_got_shot");
	self endon("phase_complete");
	
	n_duration = 4.0;
	
	self.is_running_gun_center_track = true;

	//self thread track_freeze_controls();
	
	while(n_duration > 0.0)
	{
		if(self.n_gun_pos_x > 20 || self.n_gun_pos_x < -20 || self.n_gun_pos_y > 20 || self.n_gun_pos_y < -20)
		{
		   	self.is_shooting = false;
		   	self.is_running_gun_center_track = false;
		   	self FreezeControls(false);
			self notify("center_too_long_ended");
		   	return;
		}
		
		wait 0.1;
		n_duration -= 0.1;
	}
	self.is_shooting = true;
	self.is_running_gun_center_track = false;
	self FreezeControls(false);
	self notify("center_too_long_ended");
}

track_freeze_controls()
{
	self endon("center_too_long_ended");
	self endon("krav_got_shot");
	self endon("phase_complete");
	
	is_frozen_controls = false;
	while(1)
	{
		if(!is_frozen_controls)
		{
			self FreezeControls(true);
			is_frozen_controls = true;
		}
		else
		{
			self FreezeControls(false);
			is_frozen_controls = false;
		}
		
		wait 0.3;
	}
		
}

gun_cosmetic_logic()
{
		self endon("krav_got_shot");
		self endon("phase_complete");
		
		if(self.a_cam_movement[0] != self.a_last_input[0])
		{
			self.a_last_input[0] = self.a_cam_movement[0];
			self.n_tween_for_look_at = 0.2;
		}
		else
		{
			if(self.n_tween_for_look_at > 0.01)
				self.n_tween_for_look_at -= 0.01;
		}
		
		if(self.a_cam_movement[1] != self.a_last_input[1])
		{
			self.a_last_input[1] = self.a_cam_movement[1];
			self.n_tween_for_look_at = 0.2;
		}
		else
		{
			if(self.n_tween_for_look_at > 0.01)
				self.n_tween_for_look_at -= 0.01;
		}
		
		self.a_last_input[0] = self.a_cam_movement[0];
		self.a_last_input[1] = self.a_cam_movement[1];
		
		self thread look_at(level.new_origin, self.n_tween_for_look_at);
}