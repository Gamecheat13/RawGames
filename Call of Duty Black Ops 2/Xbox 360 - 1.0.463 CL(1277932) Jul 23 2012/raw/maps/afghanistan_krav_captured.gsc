#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_scene;
#include maps\afghanistan_utility;
#include maps\_anim;
#include maps\_dialog;


/* ------------------------------------------------------------------------------------------
	INIT functions
-------------------------------------------------------------------------------------------*/

//
//	Declare event-specific flags here
init_flags()
{
	flag_init( "interrogation_started" );
	flag_init( "numbers_struggle_completed" );
	flag_init( "interrogation_running" );
	flag_init( "brainwash_active" );
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
	skipto_cleanup();
	
	level maps\afghanistan_anim::init_afghan_anims_part2();
	
	level.woods = init_hero("woods");
	level.zhao = init_hero("zhao");
	level.hudson = init_hero("hudson");
	level.kravchenko = init_hero("kravchenko");
	
	skipto_teleport( "skipto_krav_captured", level.heroes );
	
	e_hudson_pos = GetEnt("krav_capture_hudson_pos", "targetname");
	e_zhao_pos = GetEnt("krav_capture_zhao_pos", "targetname");
	e_krav_pos = GetEnt("krav_capture_krav_pos", "targetname");
	e_woods_pos = GetEnt("krav_capture_woods_pos", "targetname");
	
	level.hudson forceteleport(e_hudson_pos.origin, e_hudson_pos.angles);
	level.zhao forceteleport(e_zhao_pos.origin, e_zhao_pos.angles);
	level.kravchenko forceteleport(e_krav_pos.origin, e_krav_pos.angles);
	level.woods forceteleport(e_woods_pos.origin, e_woods_pos.angles);
	
	level.player EnableInvulnerability();

	flag_wait( "afghanistan_gump_ending" );
}


skipto_krav_interrogation()
{
	skipto_setup();
	skipto_cleanup();
	
	maps\createart\afghanistan_art::interrogation();
	
	level maps\afghanistan_anim::init_afghan_anims_part2();
	
	level.woods = init_hero("woods");
	level.zhao = init_hero("zhao");
	level.hudson = init_hero("hudson");
	level.kravchenko = init_hero("kravchenko");
	level.rebel_leader = init_hero("rebel_leader");
	
	skipto_teleport( "skipto_krav_interrogation", level.heroes );
	
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
	
	//level prep_interrogation();
	
	remove_woods_facemask_util();
	level.player EnableInvulnerability();

	flag_wait( "afghanistan_gump_ending" );
}


skipto_beat_down()
{
	skipto_setup();
	skipto_cleanup();
	
	level maps\afghanistan_anim::init_afghan_anims_part2();
	
	level.woods = init_hero("woods");
	level.zhao = init_hero("zhao");
	level.hudson = init_hero("hudson");
	level.kravchenko = init_hero("kravchenko");
	level.rebel_leader = init_hero("rebel_leader");
	
	skipto_teleport( "skipto_krav_interrogation", level.heroes );
	
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
	
	level.player EnableInvulnerability();
	
	flag_wait( "afghanistan_gump_ending" );
}


skipto_cleanup()
{
	delete_scene("intruder");
	delete_scene("intruder_box_and_mine");
	delete_scene("lockbreaker");
	delete_scene("e1_s1_pulwar");
	delete_scene("e1_s1_pulwar_single");
	delete_scene("e1_player_wood_greeting");
	
	delete_scene("e1_zhao_horse_charge_player");
	delete_scene("e1_zhao_horse_charge");
	//delete_scene("e1_horse_charge_muj_endloop");
	delete_scene("e1_horse_charge_muj1_endloop");
	delete_scene("e1_horse_charge_muj2_endloop");
	delete_scene("e1_horse_charge_muj3_endloop");
	delete_scene("e1_horse_charge_muj4_endloop");
	//delete_scene("e1_s5_vulture_shoot_woods");
	//delete_scene("e1_s5_vulture_shoot_zhao");
	
	delete_scene("e1_zhao_horse_charge_woods");
}

/* ------------------------------------------------------------------------------------------
	MAIN functions 
-------------------------------------------------------------------------------------------*/
main()
{
	//TODO - restore after fixing entity count
	level maps\createart\afghanistan_art::turn_down_fog();
	
	maps\createart\afghanistan_art::interrogation();
	
	cleanup_for_walkin();
	
	flag_wait( "afghanistan_gump_ending" );
		
	//level thread prep_interrogation();
	
	level thread muj_celebration();
	
	move_heroes_interrogation_room();
	
	// GOTO interrogation
}


cleanup_for_walkin()
{
	a_ai_guys = GetAIArray( "all" );
	
	if ( IsDefined( level.woods ) )
	{
		a_ai_guys = array_exclude( a_ai_guys, level.woods );
	}
	
	if ( IsDefined( level.zhao ) )
	{
		a_ai_guys = array_exclude( a_ai_guys, level.zhao );
	}
	
	if ( IsDefined( level.kravchenko ) )
	{
		a_ai_guys = array_exclude( a_ai_guys, level.kravchenko );
	}
	
	array_delete( a_ai_guys );
}


#using_animtree( "player" );
interrogation()
{
	level.b_player_failed_brainwash = false;
	
	// get rid of magic bullet shield so krav can die
	level.kravchenko stop_magic_bullet_shield();
	level thread play_interrogation_player_anims();
	
	autosave_by_name( "interrogation_start" );
	
	level thread run_scene("e5_s2_interrogation_start");
	
	m_guard1 = get_model_or_models_from_scene( "e5_s2_interrogation_start", "interrogation_guard1" );
	m_guard1 attach_weapon( "ak47_sp" );
	m_guard2 = get_model_or_models_from_scene( "e5_s2_interrogation_start", "interrogation_guard2" );
	m_guard2 attach_weapon( "ak47_sp" );
	m_guard3 = get_model_or_models_from_scene( "e5_s2_interrogation_start", "beatdown_guard2" );
	m_guard3 attach_weapon( "ak47_sp" );
	m_guard4 = get_model_or_models_from_scene( "e5_s2_interrogation_start", "beatdown_guard3" );
	m_guard4 attach_weapon( "ak47_sp" );	
	ai_woods = get_ais_from_scene( "e5_s2_interrogation_start", "woods" );
	ai_woods Attach( "t6_wpn_pistol_m1911_prop_view", "tag_weapon_right" );
	
	scene_wait( "e5_s2_interrogation_start" );
	
	run_scene("e5_s2_interrogation_threat");
	
	// if the player ever fails make sure you don't play the next set of animation for a section
	if( !level.b_player_failed_brainwash )
	{
		run_scene("e5_s2_interrogation_first_intel");
	}
	
	if( !level.b_player_failed_brainwash )
	{
		run_scene("e5_s2_interrogation_second_intel");
	}
	
	if( !level.b_player_failed_brainwash )
	{
		end_scene("e5_s2_interrogation_second_intel");
		run_scene("e5_s2_interrogation_third_intel");
	}
	
	if( !level.b_player_failed_brainwash )
	{
		level notify( "krav_gives_all_intel" ); // player resisted brainwashing, got intel
		
		krav_tag_head_origin = level.kravchenko GetTagOrigin("J_Neck");
		krav_tag_head_angles = level.kravchenko GetTagAngles("J_Neck");
		
		//level.kravchenko play_fx( "fx_flesh_hit_neck_fatal", krav_tag_head_origin, krav_tag_head_angles, undefined, false, "J_Neck");
		
		run_scene( "e5_s2_interrogation_succeed" );
		
		level.player set_story_stat( "KRAVCHENKO_INTERROGATED", 1 );
	}
	
	//wait 0.05;
	
	if( level.fail_animation == "e5_s2_interrogation_test1_fail")
	{
		level waittill("interrogation_done");
	}
	
	level.player notify( "stop_numbers" );
	level.player notify( "stop_face" );

	autosave_by_name( "interrogation_done" );
	// GOTO beatdown
}


prep_interrogation()
{
	for( x = 0; x < 2; x++ )
	{
		e_temp_guard = simple_spawn_single( "interrogation_guard" );
		e_temp_guard.animname = "interrogation_guard" + ( x + 1 );
	}
}


play_interrogation_player_anims()
{
	run_scene("e5_s2_interrogation_start_player");	
	run_scene("e5_s2_interrogation_threat_player");
	level.fail_animation = "none";
	
	level.player thread say_dialog("dragovich_kravche_005"); // reznov VO
	
	// this will take care of the player's camera shake and rumble
	level thread handle_interrogation_shake();

	level thread run_scene("e5_s2_interrogation_test1");
	
	//wait 18; // this is how long into the interrogation before input starts
	
	flag_set("interrogation_running");
	level.player thread say_dialog("dragovich_kravche_005"); // temp
	level.intel_round_multiplier = 2;
	level thread gun_resist_controls();
	
	body = get_model_or_models_from_scene("e5_s2_interrogation_test1", "player_body");
	
	tag_origin = body GetTagOrigin( "tag_camera" );
	tag_angles = body GetTagAngles( "tag_camera" );
	
	level.player play_fx( "numbers_base", tag_origin, tag_angles, "stop_numbers");
	//Eckert - notify to play sounds for number FX	
	level.player playsound ("evt_numbers");
	level.player thread playNumbersAudio();
	
	level scene_wait("e5_s2_interrogation_test1");
	flag_clear("interrogation_running");
	
	if( !level.b_player_failed_brainwash )
	{	
		run_scene("e5_s2_interrogation_test1_succeed");
	}
	else
	{
		Earthquake(0.25, 6, level.player.origin, 128);
		
		// FX for neck wound on Krav
		level.fail_animation = "e5_s2_interrogation_test1_fail";
		
		krav_tag_head_origin = level.kravchenko GetTagOrigin("J_Neck");
		krav_tag_head_angles = level.kravchenko GetTagAngles("J_Neck");
		
		level.kravchenko play_fx( "fx_flesh_hit_neck_fatal", krav_tag_head_origin, krav_tag_head_angles, undefined, false, "J_Neck");
		
		level run_scene("e5_s2_interrogation_test1_fail");
		
		level.player notify( "stop_numbers" );
		level.fail_animation = "e5_s2_interrogation_test1_fail";
		level notify("interrogation_done");
		
		return;
	}

	level.intel_round_multiplier = 1.5;
	
	level.player play_fx( "numbers_mid", tag_origin, tag_angles, "stop_numbers");
	//Eckert - notify to play sounds for number FX	
	level.player playsound ("evt_numbers");
	
	level.player thread say_dialog("rezn_dragovich_kravchenk_0"); //  reznov VO
	
	flag_set("interrogation_running");
	run_scene("e5_s2_interrogation_test2");
	flag_clear("interrogation_running");
	
	if( !level.b_player_failed_brainwash )
	{
		run_scene("e5_s2_interrogation_test2_succeed");
	}
	else
	{
		Earthquake(0.25, 6, level.player.origin, 128);
		
		// FX for neck wound on Krav
		level.fail_animation = "e5_s2_interrogation_test2_fail";
		
		krav_tag_head_origin = level.kravchenko GetTagOrigin("J_Neck");
		krav_tag_head_angles = level.kravchenko GetTagAngles("J_Neck");
		
		level.kravchenko play_fx( "fx_flesh_hit_neck_fatal", krav_tag_head_origin, krav_tag_head_angles, undefined, false, "J_Neck");
		
		level run_scene("e5_s2_interrogation_test2_fail");
		
		level.player notify( "stop_numbers" );
		level notify("interrogation_done");
		return;
	}
	
	level.intel_round_multiplier = 1.75;
	anim_length = GetAnimLength(%player::p_af_05_02_interrog_test3_player);
	
	level.player play_fx( "numbers_center", tag_origin, tag_angles, "stop_numbers");
	
	//Eckert - notify to play sounds for number FX	
	level.player playsound ("evt_numbers");
	
	level.player thread say_dialog("dragovich_kravche_005"); // // reznov VO
	flag_set("interrogation_running");
	run_scene("e5_s2_interrogation_test3");
	flag_clear("interrogation_running");
	
	if( !level.b_player_failed_brainwash )
	{
		run_scene("e5_s2_interrogation_test3_succeed");
	}
	else
	{
		Earthquake(0.25, 6, level.player.origin, 128);
		level.fail_animation = "e5_s2_interrogation_test3_fail";
		
		// FX for neck wound on Krav
		krav_tag_head_origin = level.kravchenko GetTagOrigin("J_Neck");
		krav_tag_head_angles = level.kravchenko GetTagAngles("J_Neck");
		
		level.kravchenko play_fx( "fx_flesh_hit_neck_fatal", krav_tag_head_origin, krav_tag_head_angles, undefined, false, "J_Neck");
		
		level run_scene("e5_s2_interrogation_test3_fail");
		
		level.player notify( "stop_numbers" );
		level notify("interrogation_done");
		return;
	}
	
	level thread run_scene("e5_s2_interrogation_all_succeed");
	
	wait 1.65;
	
	level.player notify( "stop_numbers" );
	level scene_wait("e5_s2_interrogation_all_succeed");	
	level notify("interrogation_done");
	
}


playNumbersAudio()
{
	self endon( "stop_numbers" );
	
	a = 0;
	b = 0;
	c = 0;
	
	while(1)
	{
		a = randomintrange( -250, 250 );
		b = randomintrange( -250, 250 );
		c = randomintrange( -250, 250 );
		playsoundatposition( "evt_numbers_flux_quiet", self.origin + (a,b,c) );
		
		wait(randomfloatrange(1,3));
	}
}


#using_animtree( "player" );
beatdown()
{
	end_scene("e5_s2_interrogation_all_succeed");
	end_scene("e5_s2_interrogation_test1_fail");
	level thread run_scene("e5_s4_beatdown");
	
	level thread prep_beatdown_guards();
	
	anim_durration = getanimlength(%p_af_05_04_betrayal_player);
	wait anim_durration - 2;
	
	//C. Ayers - Turning off all other sounds for this fade to black
	clientnotify( "snp_desert" );
	
	level thread screen_fade_out(2);
	level.player VisionSetNaked("infrared_snow", 2);
	level.player lerp_dof_over_time_pass_out( 2 );
	
	level.player VisionSetNaked("afghanistan", 0.05);
	level.player reset_dof();
	
	autosave_by_name( "beatdown_done" );
	
	// GOTO Afghanistan_deserted's main
}


prep_beatdown_guards()
{
	m_guard1 = get_model_or_models_from_scene( "e5_s4_beatdown", "beatdown_guard1" );
	m_guard1 attach_weapon( "ak47_sp" );
	/*m_guard2 = get_model_or_models_from_scene( "e5_s4_beatdown", "beatdown_guard2" );
	m_guard2 attach_weapon( "ak47_sp" );
	m_guard3 = get_model_or_models_from_scene( "e5_s4_beatdown", "beatdown_guard3" );
	m_guard3 attach_weapon( "ak47_sp" );*/
}

/* ------------------------------------------------------------------------------------------
	SUPPORT functions
-------------------------------------------------------------------------------------------*/

// Everything else goes here

muj_celebration()
{	
	level.player freezecontrols(false);
	
	//SOUND - Shawn J
	//iprintlnbold ("muj_celeb");
	//level clientnotify ("battle_walla");
//	level.muj_celeb_ent_l = spawn( "script_origin", (14632, -9942, -40) );
//	level.muj_celeb_ent_r = spawn( "script_origin", (14605, -10331, -47) );
//	level.muj_celeb_ent_l playloopsound( "evt_muj_crowd_l", 1 );
//	level.muj_celeb_ent_r playloopsound( "evt_muj_crowd_r", 1 );
//
//	level.player say_dialog("we_already_knew_he_003"); // temp
//	level.player say_dialog("payback_was_just_a_004"); // temp
//
//	
//	level thread run_scene( "e5_s1_celebrate" );
//	level thread run_scene("e5_s1_celebrate_crowd");
//	wait 1;
	
	level thread krav_face_impact();
	
//	level thread run_scene("e5_s1_walk_in_zhao");
//	level thread run_scene("e5_s1_walk_in");
	
	level screen_fade_in( 2 );
	level.player SetClientDvar( "cg_fov", 65 );
	
	level.player AllowSprint(false);
	level.player setlowready(true);
	
//	scene_wait( "e5_s1_walk_in" );
//	
//	exploder(500); // Numbers exploder
//	level.player thread say_dialog("rezn_dragovich_kravchenk_0"); // Reznov VO
//	
//	level.kravchenko notify("stop_numbers");
	//level.m_numbers_base_link delete();
	
	flag_set("interrogation_started");
}

// Makes Kravchenko's face bloody
krav_face_impact()
{
	level endon("interrogation_done");
	level.kravchenko endon("death");
	
	while(1)
	{	
		
		krav_tag_head_origin = level.kravchenko GetTagOrigin("J_Head");
		krav_tag_head_angles = level.kravchenko GetTagAngles("J_Head");
		
		level.kravchenko play_fx( "fx_punch_kravchenko", krav_tag_head_origin, krav_tag_head_angles, "stop_face", true, "J_Head");
		wait 3;
	}
}


move_heroes_interrogation_room()
{
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
	
	//SHAWN J - SOUND
	//iprintlnbold ("krav_start");
	//level.player playsound ("sce_krav_interro");
	//level.muj_celeb_ent_l delete();
	//level.muj_celeb_ent_r delete();
}

#define L_STICK_INPUT_MIN -0.01
gun_resist_controls()
{	
	level.direction_input_LS = 0;
	
	level.n_time_max = GetAnimLength(%player::p_af_05_02_interrog_test1_player);
	
	//level thread animate_brainwash_anims("e5_s2_interrogation_test1");
	//watch_and_wait_scene( level.n_time_max );
	level.b_player_input = true;
	wait level.n_time_max * 0.05;
	
	if( level.b_player_failed_brainwash )
	{
		return;	
	}
	
	level.direction_input_LS = 0;
	
	level.n_time_max = GetAnimLength(%player::p_af_05_02_interrog_test2_player);
	
	level scene_wait( "e5_s2_interrogation_test1_succeed" );
	
	level thread animate_brainwash_anims( "e5_s2_interrogation_test2" );
	watch_and_wait_scene( level.n_time_max );
	
	if( level.b_player_failed_brainwash )
	{
		return;	
	}	
	
	level.direction_input_LS = 0;
	
	level.n_time_max = GetAnimLength(%player::p_af_05_02_interrog_test3_player);
	
	level scene_wait( "e5_s2_interrogation_test2_succeed" );
	
	level thread animate_brainwash_anims( "e5_s2_interrogation_test3" );
	watch_and_wait_scene( level.n_time_max );
	
	if( level.b_player_failed_brainwash )
	{
		return;	
	}
}

watch_and_wait_scene( n_timer )
{
	player_pressed_button_this_round = false;
	
	while(n_timer > 0)
	{
		player_leftstick_y = level.player GetNormalizedMovement()[0];
		
		if( (n_timer < level.n_time_max - 2) && !player_pressed_button_this_round )
		{
			level screen_message_create(&"AFGHANISTAN_BRAINWASH_PROMPT2");
		}
		else
		{
			level screen_message_delete();
		}
		
		if(player_leftstick_y < L_STICK_INPUT_MIN)//Player pushing down on L stick
		{
			level.direction_input_LS += 1;
			level.b_player_input = true;
			player_pressed_button_this_round = true;
		}
		else
		{
			level.b_player_input = false;	
		}
		
		wait 0.05;
		n_timer -= 0.05;
	}	
	level screen_message_delete();
}

#define RESIST_FAIL_VALUE 0.065
check_and_set_interrogation_failure( n_scene_time, n_player_input )
{
	if( n_player_input != 0 )
	{
		if( ( ( n_scene_time/n_player_input ) >= RESIST_FAIL_VALUE && level.brainwash_weights[1] > 0.8 ) || ( level.brainwash_weights[1] > 0.9 ) )
		{
			// make the fail happen
			level.b_player_failed_brainwash = true;
			return true;
		}
		else
		{
			return false;	
		}			
	}
	else
	{
		// make the fail happen
		level.b_player_failed_brainwash = true;
		return true;//Player has done nothing, fail them		
	}
}

handle_interrogation_shake()
{
	level endon( "interrogation_done" );
	
	b_player_input_last_interation = false;
	f_earthquake_durration = 1.0;
	level.b_player_input = false;
	level.intel_round_multiplier = 1.25;
	struct_moved = false;
	f_player_input_timer = 0.0;
	
	player_anim_struct = GetStruct("by_numbers_struct_mason", "targetname");
	
	while(1)
	{
		if( flag("interrogation_running") )
		{
			if( level.b_player_input )
			{
				Earthquake(0.05 * level.intel_round_multiplier, 1, level.player.origin, 128);
				level.player PlayRumbleOnEntity( "damage_light" );
				
				wait 0.4;
			}
			else if( f_player_input_timer <= 0 )
			{
				Earthquake(0.1 * level.intel_round_multiplier, 1, level.player.origin, 128);
				level.player PlayRumbleOnEntity( "damage_light" );
				wait 0.05;
			}
			
			if(f_player_input_timer > 0)
			{
				f_player_input_timer -= 0.05;
			}
		}
		else
		{
			f_player_input_timer = 0.0;
			Earthquake(0.05, 1, level.player.origin, 128);
			wait 0.05;
		}		
	}
}

choke_spit_fx()
{
	body = get_model_or_models_from_scene("e5_s4_beatdown", "player_body");
	
	tag_origin = body GetTagOrigin( "tag_camera" );
	tag_angles = body GetTagAngles( "tag_camera" );
	
	body play_fx( "choke_spit", tag_origin, tag_angles, 5, true, "tag_camera");
}

#using_animtree( "player" );
brainwash_anims_init( str_scene )
{
	level.player_body_model = get_model_or_models_from_scene( str_scene, "player_body" );
	
	level.brainwash_model = spawn_anim_model( "player_hands_brainwash", level.player_body_model.origin, level.player_body_model.angles );
		
	level.brainwash_model linkto( level.player_body_model, "tag_origin" );
	level.brainwash_model Attach( "t6_wpn_pistol_m1911_prop_view", "tag_weapon" );
}

#define BRAINWASH_FAIL_SPEED_SLOW 0.35
#define BRAINWASH_FAIL_SPEED_FAST 0.55
animate_brainwash_anims( str_scene )
{
	n_brainwash_count = 0;
	
	brainwash_anims_init( str_scene );	
	wait 0.05;
	
	flag_set( "brainwash_active" );
	
	//start anims in downward position
	level.brainwash_weights[0] = 1;
	level.brainwash_weights[1] = 0;
	level.brainwash_model setanim(%player::p_af_05_02_interrog_player_downgun, level.brainwash_weights[0], 0, 1);
	level.brainwash_model setanim(%player::p_af_05_02_interrog_player_upgun, level.brainwash_weights[1], 0, 1);
	
	while( flag( "brainwash_active" ) )
	{
		player_leftstick_y = level.player GetNormalizedMovement()[0];
		if( player_leftstick_y != 0 )
		{
			if( check_for_bump(n_brainwash_count) && player_leftstick_y < 0 )
			{
				brainwash_bump();
			}
			else
			{
				brainwash_hands_animator( player_leftstick_y );	
			}
		}
		else
		{
			if( str_scene == "e5_s2_interrogation_test3" )
			{
				brainwash_hands_animator( BRAINWASH_FAIL_SPEED_FAST );
			}
			else
			{
				brainwash_hands_animator( BRAINWASH_FAIL_SPEED_SLOW );
			}
		}
		
		n_brainwash_count += 1;
		wait 0.05;
	}
	
	//check pass/fail
	//check_and_set_interrogation_failure()
	if( check_and_set_interrogation_failure( level.n_time_max, level.direction_input_LS ) )
	{
		level.brainwash_model setanim(%player::p_af_05_02_interrog_player_downgun, 0, 0.5, 1);
		level.brainwash_model setanim(%player::p_af_05_02_interrog_player_upgun, 1, 0.5, 1);	
		wait 0.5;
		level.brainwash_model setanim(%player::p_af_05_02_interrog_player_failshoot, 1, 0.5, 1);
		wait GetAnimLength(%player::p_af_05_02_interrog_player_failshoot);		
	}
	else
	{
		level.brainwash_model setanim(%player::p_af_05_02_interrog_player_downgun, 1, .5, 1);
		level.brainwash_model setanim(%player::p_af_05_02_interrog_player_upgun, 0, .5, 1);		
	}	
	wait 0.5;

	level.brainwash_model Delete();
}

end_hands_animator( player_body )
{
	flag_clear( "brainwash_active" );		
}

brainwash_hands_animator( player_leftstick_y )
{	
	weights = set_brainwash_weights( player_leftstick_y );
			
 	thread brainwash_aim(weights);	
}

#define BRAINWASH_BUMP_SIZE 0.1
brainwash_bump()
{
	// going up
	level.brainwash_weights[1]	+= BRAINWASH_BUMP_SIZE;
	level.brainwash_weights[0]	-= BRAINWASH_BUMP_SIZE;
	// clamp, because some of these may be negatives
	for( i = 0; i < 2; i++ )
	{
		level.brainwash_weights[i] = clamp(level.brainwash_weights[i], 0.0, 1.0);
	}	
	thread brainwash_aim(level.brainwash_weights);	
	Earthquake(0.25, 1, level.player.origin, 128);
	level.player PlayRumbleOnEntity( "damage_heavy" );
}

check_for_bump( n_time_passed )
{
	if( level.n_time_max - ( n_time_passed * 0.05 ) > 2 )
	{
		if( Int(n_time_passed) % choose_random_bump_count() )
		{
			return false;	
		}
		else
		{
			return true;
		}	
	}
	else
	{
		return false;
	}
}

choose_random_bump_count()
{
	switch( RandomInt( 3 ) )
	{
		case 0:
			return 10;
			break;
			
		case 1:
			return 20;
			break;
			
		default:
			return 25;
			break;
	}
}

brainwash_aim( weights )
{
	level.brainwash_model setanim(%player::p_af_05_02_interrog_player_downgun, weights[0], 0.05, 1);
	level.brainwash_model setanim(%player::p_af_05_02_interrog_player_upgun, weights[1], 0.05, 1);	
}

set_brainwash_weights( player_leftstick_y )
{
	player_leftstick_y = clamp(player_leftstick_y, -1.0, 1.0);
	level.brainwash_input = player_leftstick_y;

	minStickInput			= 0.01;
	weightChangeSpeedSlow	= 0.001;
	weightChangeSpeedFast	= 0.05;

	//No player input, we keep the weights as is
	if( abs(level.brainwash_input) < minStickInput )
	{
		return level.brainwash_weights;
	}

	// scale the turn speed by how much the player is pushing the stick
	stickSpeed				= (abs(level.brainwash_input) - minStickInput) / (1.0 - minStickInput);
	weightChangeSpeed		= weightChangeSpeedSlow + (weightChangeSpeedFast - weightChangeSpeedSlow) * stickSpeed;
	
	if( level.brainwash_input > 0 )
	{
		// going up
		level.brainwash_weights[1]	+= weightChangeSpeed;
		level.brainwash_weights[0]	-= weightChangeSpeed;
	}
	else
	{
		// going down
		level.brainwash_weights[0]	+= weightChangeSpeed;
		level.brainwash_weights[1]	-= weightChangeSpeed;
	}

	// clamp, because some of these may be negatives
	for( i = 0; i < 2; i++ )
	{
		level.brainwash_weights[i] = clamp(level.brainwash_weights[i], 0.0, 1.0);
	}
	
	return level.brainwash_weights;
}
