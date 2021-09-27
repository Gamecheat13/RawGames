#include maps\_hud_util;
#include maps\_utility;
#include maps\payback_main;
#include maps\payback_util;
#include maps\_vehicle;
#include common_scripts\utility;
#include maps\_audio;
#include maps\_anim;
#include maps\payback_env_code;
#include maps\payback_sandstorm_code;
#include maps\payback_sandstorm;
#include maps\_sandstorm;
#include animscripts\utility;

start_spawn_key_actors()
{
	spawn_ally("soap");
	spawn_ally("price");
	spawn_ally("nikolai");
	
	move_player_to_start();
}

// start_s3_rescue - Entering the area witnessing Nikolai's situation.
start_s3_rescue()
{

	// AUDIO: jump/checkpoints
	aud_send_msg("s3_rescue");

	start_spawn_key_actors();
	
	sandstorm_skybox_show();
	exploder(6000);
	objective_state( obj( "obj_kruger" ) , "done" );
	objective_state( obj( "obj_secondary_lz" ), "done");
	objective_state( obj( "obj_find_chopper" ), "current");
	
	init_sandstorm_env_effects("s3_rescue");
	thread set_sandstorm_level( "extreme" , 0.051 ); // .05 is smallest allowed
	thread blizzard_level_transition_extreme_sat(5);
	
	maps\payback_sandstorm::moroccan_lamp_thread();

	chopper_init_fog_brushes();
	
	maps\_compass::setupMiniMap("compass_map_payback_sandstorm","sandstorm_minimap_corner");
	
	thread rescue_thread();
	
	if (!is_specialop())
	{
		maps\payback_fx_sp::setup_sandstorm_replacement_fx();
	}
	wait 2;
	
	thread lighten_sandstorm();
	
	SetSunFlarePosition(( 343.8, 313.993, 0 ));
	
	sslight_01 = GetEnt( "sslight_01" , "targetname" );
	sslight_01 SetLightIntensity( 7 );
	thread blizzard_level_transition_extreme_sat(5);
	street_light_gate = GetEnt( "street_light_gate" , "targetname" );
	street_light_gate SetLightIntensity( 3 );
}

// start_s3_escape - Standing over Nikolai ready to pick him up.
start_s3_escape()
{

	// AUDIO: jump/checkpoints
	aud_send_msg("s3_escape");

	start_spawn_key_actors();
	
	sandstorm_skybox_show();
	exploder(6000);
	rescue_init();

	objective_state( obj( "obj_kruger" ) , "done" );
	objective_state( obj( "obj_secondary_lz" ), "done");
	objective_state( obj( "obj_find_chopper" ), "done");
	objective_state( obj( "obj_rescue" ), "current");

	init_sandstorm_env_effects("s3_escape");
	thread set_sandstorm_level( "extreme" , 0.051 ); // .05 is smallest allowed
	
	maps\payback_sandstorm::moroccan_lamp_thread();
	
	maps\_compass::setupMiniMap("compass_map_payback_sandstorm","sandstorm_minimap_corner");
	thread minimap_change_watcher();
	
	chopper_init_fog_brushes();

	rescue_spawn_initial();

	rescue_contain_player_enable(true);

	thread rescue_carry_nikolai_setup();
	
	thread rescue_advance_to_chopper();
	
	if (!is_specialop())
	{
	maps\payback_fx_sp::setup_sandstorm_replacement_fx();
	}
	wait 2;
	
	thread lighten_sandstorm();
	
	SetSunFlarePosition(( 343.8, 313.993, 0 ));
}

init_flags_rescue()
{
	flag_init( "rescue_c4_aborted" );
	flag_init( "carry_warn" );
	flag_init( "carry_kill" );
	flag_init( "slide_started" );
	flag_init( "start_flare_fade" );
	flag_init( "player_entering_jeep" );
	flag_init( "player_in_jeep" );
	flag_init( "price_at_ridge" );
	flag_init( "start_nikolai_pullout_echo" );
	flag_init( "player_in_escape_jeep" );
	flag_init( "price_in_escape_jeep_1" );
	flag_init( "spawn_follow_technical" );
	flag_init( "stop_laser_handler" );
	flag_init( "wait_to_move_follow_technical" );
}

rescue_init()
{
	if ( !IsDefined( level.rescue_init ) )
	{
//		sandstorm_stealth_off();
		
		rescue_contain_player_enable(false);
		
		trigs = GetEntArray("rescue_escape_trigger", "script_noteworthy");
		foreach ( trig in trigs )
		{
			trig trigger_off();
		}
		
		rpg_trigs = GetEntArray("rescue_trigger_rpg", "targetname");
		array_thread( rpg_trigs, ::rescue_trigger_fire_rpg );
		
		// Setup a thread that simply waits for player/allies to walk into various triggers
		//  and then notify the level when they do
		// These will also all automatically keep track of a level flag by the same name
		level thread notify_on_trigger( "rescue_begin" );
		level thread notify_on_trigger( "rescue_allies_at_chopper" );
		level thread notify_on_trigger( "rescue_player_warn" );
		level thread notify_on_trigger( "rescue_trigger_drone_wake" );
		level thread notify_on_trigger( "rescue_escape_dialogue" );
		level thread notify_on_trigger( "rescue_kill_nikolai" );
		level thread notify_on_trigger( "run_objective_spot_2" );
		level thread notify_on_trigger( "run_objective_spot_3" );
		level thread notify_on_trigger( "start_player_slide" );
		level thread notify_on_trigger( "start_flare" );
		level thread notify_on_trigger( "run_objective_spot_jeep" );
		level thread notify_on_trigger( "jeep_escape_rpg_1" );
		level thread notify_on_trigger( "jeep_escape_rpg_2" );
		level thread notify_on_trigger( "jeep_escape_rpg_3" );
		
		level thread notify_on_trigger( "price_check_anim_ref_2" );
		level thread notify_on_trigger( "price_check_anim_ref_3" );
		level thread notify_on_trigger( "price_check_anim_ref_4" );
		
		level thread notify_on_trigger( "soap_check_anim_ref_2" );
		level thread notify_on_trigger( "soap_check_anim_ref_3" );
		level thread notify_on_trigger( "soap_check_anim_ref_4" );
		level thread notify_on_trigger( "soap_check_anim_ref_5" );
		
		level thread notify_on_trigger( "final_technicals" );
		level thread notify_on_trigger( "ridge_contain" );
		level thread notify_on_trigger( "winning" );

		jeep_flare_light = GetEnt( "jeep_flare" , "targetname" );
		jeep_flare_light SetLightIntensity( 0 );
		
		if ( !IsDefined( level.nikolai ) )
		{
			spawn_ally( "nikolai", "s3_rescue_nikolai" );
			level.nikolai.ignoreall = true;
		}
		level.chopper_rescue_ref = getstruct( "chopper_rescue_reference" , "targetname" );
		
		level thread rescue_wait_kill_nikolai();
		
		//thread set_sandstorm_level( "extreme" );

		level.rescue_init = true;
		
		thread rescue_enemy_battlechatter();
		thread spawn_echo_team_near_chopper();
	}
}

rescue_thread()
{
	rescue_init();
	
	// Make sure only one of these ever active
	self notify("rescue_thread");
	self endon("rescue_thread");

	thread rescue_carry_nikolai_setup();
	thread minimap_change_watcher();

	rescue_spawn_initial();
	
	level waittill( "rescue_begin" );
	rescue_begin();
}

minimap_change_watcher()
{
	flag_wait("use_exit_minimap");
	maps\_compass::setupMiniMap("compass_map_payback_exit","exit_minimap_corner");
}

rescue_begin()
{
	aud_send_msg("begin_npc_weapon_audio_hack");
	
	thread player_out_in_open();
	
	thread rescue_intro_combat();
	
	thread clear_chopper_obj_spot();
	
	level waittill( "all_pre_rescue_enemies_dead" );
	
	objective_state( obj( "obj_find_chopper" ), "done");
	rescue_nikolai_obj_spot = getstruct( "rescue_nikolai_obj_spot" , "targetname" );
	objective_state( obj( "obj_rescue" ), "current");
	objective_position( obj( "obj_rescue" ), rescue_nikolai_obj_spot.origin );
	
	thread rescue_begin_dialogue_thread();
	
	rescue_advance_to_chopper();
}

clear_chopper_obj_spot()
{
	level endon( "disable_clear_chopper_obj_spot" );
	flag_wait( "clear_chopper_obj_spot" );
	objective_position( obj( "obj_rescue" ) , ( 0 , 0 , 0 ) );
}

rescue_intro_combat()
{
	flag_wait( "rescue_intro_firing_at_nikolai" );
	aigroup = array_spawn_targetname_allow_fail( "rescue_intro_firing_at_nikolai" );
	/*
	flag_wait( "rescue_intro_technical" );
	technical = spawn_vehicle_from_targetname_and_drive( "rescue_intro_technical" );	
	
	ai = array_combine( ai , technical.riders );
	*/
	targetEnt = getEnt( "rescue_intro_fire_at_nikolai_spot" , "targetname" );
	foreach ( ai in aigroup )
	{
		ai SetEntityTarget( targetEnt );
		ai thread flashlight_on_guy();
		ai thread cleanup_arch_enemies();
	}
	
	payback_array_waittill_combat( aigroup , "rescue_intro" );

	aigroup = array_removeDead( aigroup );
	foreach ( ai in aigroup )
	{
		ai ClearEntityTarget();
		ai notify( "rescue_end_shoot_at_target_thread" );
		ai.fixednode = false;
	}
	waittill_dead_or_dying( aigroup );
	
	activate_trigger_with_targetname( "rescue_intro_post_combat" );
	level notify( "all_pre_rescue_enemies_dead" );
}

rescue_begin_dialogue_thread()
{
	level endon( "pickup_nikolai_vo_started" );
	
	level.soap dialogue_queue( "payback_mct_theresnikschopper" ); // "There s Nikolai's chopper."
	aud_send_msg("mus_rescue_start_nikolai_music");
	
	wait .2;
	
	level.price dialogue_queue( "payback_pri_echoteampinned" ); // "Echo Team's pinned down! Let's move!"
	
	wait .2;
	
	level.price dialogue_queue( "payback_pri_fromnorthwest" ); // "Echo Team, we're approaching your position from the South!"
	
	wait .1;
	
	radio_dialogue( "payback_eol_copythat" ); // "Copy that!"
	
	aud_send_msg("mus_nikolai");
}

spawn_echo_team_near_chopper()
{
	level endon( "clear_echo_stuff" );
	SetLaserMaterial( "gfx_laser_bright" , "" );
	level.rescue_echo_1 = GetEnt( "rescue_echo_1_spawner" , "targetname" ) spawn_ai( true );
	level.rescue_echo_1 magic_bullet_shield();
	level.rescue_echo_1.animname = "rescue_echo_1";
	level.rescue_echo_1.dust_fx = level._effect[ "dust_kickup" ];
	level.rescue_echo_1.dust_fx_tag = "j_mainroot";
	level.rescue_echo_1 thread laser_handler();
	level.rescue_echo_1 thread crash_site_ally_prep();

	level.rescue_echo_2 = GetEnt( "rescue_echo_2_spawner" , "targetname" ) spawn_ai( true );
	level.rescue_echo_2 magic_bullet_shield();
	level.rescue_echo_2.animname = "rescue_echo_2";
	level.rescue_echo_2 thread laser_handler();
	level.rescue_echo_2.dust_fx = level._effect[ "dust_kickup" ];
	level.rescue_echo_2.dust_fx_tag = "j_mainroot";
	level.rescue_echo_2 thread crash_site_ally_prep();
	
	level.rescue_echo_3 = GetEnt( "rescue_echo_3_spawner" , "targetname" ) spawn_ai( true );
	level.rescue_echo_3 magic_bullet_shield();
	level.rescue_echo_3.animname = "rescue_echo_3";
	level.rescue_echo_3 thread crash_site_ally_prep();
	
	level.rescue_echo_3.notarget = true;
	level.rescue_echo_3.ignoreme = true;
	
	flag_wait( "start_nikolai_pullout_echo" );
	
	level.rescue_echo_3 LaserForceOff();
	
	level.chopper_rescue_ref anim_single_solo( level.rescue_echo_3 , "payback_sstorm_chopper_rescue_echo_pullout" );
	
	level.rescue_echo_3 SetGoalNode( GetNode( "rescue_echo_3_end_spot" , "targetname" ) );
	                                
	level.rescue_echo_3 waittill( "goal" );
	
	level.rescue_echo_3.notarget = false;
	level.rescue_echo_3.ignoreme = false;
	level.rescue_echo_3 thread laser_handler();
}

cleanup_arch_enemies()
{
	self endon( "death" );
	
	flag_wait( "start_nikolai_pullout_echo" );
	
	if( IsDefined( self ) && IsAlive( self ) )
	{
		self kill();
	}
}

laser_handler()
{
	level endon( "stop_laser_handler" );
	
	laser_was_off = true;
	
	while( !flag( "stop_laser_handler" ) )
	{
		if( self canSeeEnemy() && laser_was_off )
		{
			self LaserForceOn();
			laser_was_off = false;
		}
		else if( !self canseeenemy() && !laser_was_off )
		{
			self LaserForceOff();
			laser_was_off = true;
		}
		wait( RandomFloatRange( .25 , .5 ) );
	}
}

rescue_advance_to_chopper()
{
	rescue_contain_player_enable( true );
	
	level.price disable_ai_color();
	level.soap disable_ai_color();
	
	level.price.goalradius = 128;
	level.soap.goalradius = 128;
	
	level.price battlechatter_off();
	level.soap battlechatter_off();
	
	level.price thread crash_site_ally_prep();
	level.soap thread crash_site_ally_prep();
	
	thread rescue_nikolai_price();
	level.soap.script_grenades = 0;
	level.soap setgoalnode( GetNode( "rescue_soap_chopper" , "targetname" ) );
}

rescue_enemy_battlechatter()
{
	wait .5; // this happens right away on the checkpoint, and if we don't wait, the delay
	// between notify and waittill makes it so the enemy we picked has been deleted
	level.player endon( "death" );
	while( 1 )
	{
		enemies = GetAIArray( "axis" );
		enemies = get_array_of_closest( level.player.origin , enemies , undefined , 4 );
		if ( enemies.size > 0 )
		{
			index = RandomIntRange( 0 , enemies.size );
			enemy = enemies[index];
			enemy custom_battlechatter( "order_move_combat" );
		}
		wait( RandomFloatRange( 1.5 , 5.0 ));
	}
}

// rescue_chopper_extract_dialogue - this keeps going until Nikolai gets killed
// It aborts when the player uses Nikolai and picks him up
rescue_chopper_extract_dialogue()
{
	level endon( "rescue_picking_up_nikolai" );
	level notify( "pickup_nikolai_vo_started" );

	flag_wait( "player_near_crashed_chopper" );
	
	level.price dialogue_queue( "payback_pri_goodtoseeyou" ); // "Good to see you, mates! Where's the convoy?"

	wait .5;
	
	level.rescue_echo_1 dialogue_queue( "payback_eol_twovehicles" ); // "We've got two vehicles 50 meters to the northwest!"
	
	trigger_on( "ready_to_pick_up_niko_save_trig" , "targetname" );
	
	wait .5;
	
	level.price dialogue_queue( "payback_pri_suppress" ); // "All right. Yuri, grab Nikolai! Everyone else, get ready to suppress and fall back!"
	
	wait 4;

	while ( 1 )
	{
		level.price dialogue_queue( "payback_pri_getnikolai" ); // "Yuri, get Nikolai. They’re closing in."
	
		wait 4;
		
		level.price dialogue_queue( "payback_pri_grabnikolai" ); // "Grab Nikolai. We’re running out of time."
		
		wait 4;

		level.price dialogue_queue( "payback_pri_waitingfor" ); // "Yuri, what are you waiting for? Get Nikolai."
		
		wait 4;
	}
}

health_mods()
{
	level.player.gs.invultime_onshield = 2;
	level.player.gs.invultime_postshield = 2;
	level.player.gs.invultime_preshield = 2;
	level.player.gs.longregentime = 500;
	level.player.gs.player_attacker_accuracy = .1;
	level.player.gs.playerhealth_regularregendelay = 500;
	level.player.gs.invultime_postshield = 2;
	level.player.gs.regenrate = .1;
	level.player.gs.worthydamageratio = .01;
}

rescue_wait_kill_nikolai()
{
	level waittill( "rescue_kill_nikolai" );

	level.nikolai_use_trigger Delete();
	
	level.chopper_rescue_ref thread anim_single_solo( level.nikolai , "rescue_nikolai_death" );
	level.nikolai.allowdeath = true;
	level.nikolai stop_magic_bullet_shield();
	MagicBullet( "ak47", level.nikolai GetEye() + (0, 0, 10), level.nikolai GetEye());
	level.nikolai Kill();
	wait 1;
	
	// "Nikolai was killed"
	setdvar( "ui_deadquote", "@PAYBACK_NIKOLAI_KILLED" );
	maps\_utility::missionFailedWrapper();	
}

rescue_exit_setup()
{
	trigs = GetEntArray("rescue_escape_trigger", "script_noteworthy");
	foreach ( trig in trigs )
	{
		trig trigger_on();
		
		if ( IsDefined( trig.script_parameters ) && trig.script_parameters == "phantom_fire" )
		{
			trig thread rescue_phantom_trigger_wait();
		}
	}
}

rescue_exit_sequence()
{
	rescue_exit_setup();

	rescue_contain_player_enable(false);
	
	phantom_fire_source = GetStructArray( "rescue_phantom_fire_source1", "targetname" );
	thread phantom_pressure( level.player, "ak47", phantom_fire_source, 0.05, 1.5, 3000, 5000 );
		
	level waittill( "rescue_escape_dialogue" );
	
	level notify( "stop_rescue_respawns" );
}

move_allies_after_pickup()
{
	thread rescue_exit_sequence_price();
	thread rescue_exit_sequence_soap();
	thread rescue_exit_sequence_echo_1();
	thread rescue_exit_sequence_echo_2();
	thread rescue_exit_sequence_echo_3();
	
	thread flare_thread();
	
	thread new_jeep_escape_setup();
}

flare_thread()
{
	level waittill( "start_flare" );
	
	aud_send_msg("mus_rescue_music_day_saved");
	
	thread maps\_flare_no_sunchange_pb::flare_from_targetname( "jeep_escape_flare" );
	
	thread flare_light();
	
	level waittill( "flare_done" );
	flag_set( "start_flare_fade" );
}

flare_light()
{
	jeep_flare_light = GetEnt( "jeep_flare" , "targetname" );
	level waittill( "flare_explodes" );
		
	jeep_flare_light SetLightIntensity( 6.0 );
	jeep_flare_light SetLightRadius( 1800 );

	flag_wait( "start_flare_fade" );

	time = 1;
	cur_time = 0;
	intensity = jeep_flare_light GetLightIntensity();
	
	while( cur_time < time )
	{
		cur_time += 0.05;
		jeep_flare_light SetLightIntensity( ( ( time - cur_time ) / time ) * intensity );
		wait .05;
	}
}

ally_run_prep()
{
	self ClearEnemy();
	self.ignoreall = true;
	self.goalradius = 32;
	self.ignoreexplosionevents = true;
	self.grenadeawareness = 0;
	self.notarget = true;
	self.ignoreme = true;
	self.ignoresuppression = true;
	self.suppressionwait = 0;
	self.disableBulletWhizbyReaction = true;
	self.ignorerandombulletdamage = true;
	self thread disable_pain();
	self thread disable_surprise();
	self AllowedStances( "stand" );
	self.badplaceawareness = 0;
}

crash_site_ally_prep()
{
	self.ignoreexplosionevents = true;
	self.grenadeawareness = 0;
	self.ignoresuppression = true;
	self.suppressionwait = 0;
	self.disableBulletWhizbyReaction = true;
	self.ignorerandombulletdamage = true;
	self thread disable_pain();
	self thread disable_surprise();
	self.badplaceawareness = 0;
}

rescue_exit_sequence_price()
{
	level.price ally_run_prep();

	thread price_run_part_1();
}

rescue_exit_sequence_soap()
{
	level.soap ally_run_prep();
	
	thread soap_run_part_1();
}

rescue_exit_sequence_echo_1()
{
	//level waittill( "move_echo_1" );
	slide_ref = getstruct( "slide_ref" , "targetname" );
	level waittill( "move_echo_2_and_3" );
	level.rescue_echo_1 teleport_ai( GetNode( "rescue_echo_1_run_start_spot" , "targetname" ) );
	level.rescue_echo_1 ally_run_prep();
	level.rescue_echo_1 LaserForceOff();
	
	slide_ref anim_reach_solo( level.rescue_echo_1 , "rescue_echo_1_slide" );
	
	slide_ref anim_single_solo( level.rescue_echo_1 , "rescue_echo_1_slide" );
	
	level.rescue_echo_1 SetGoalNode( GetNode( "rescue_echo_1_goal", "targetname") );
	shoot_echo_1_and_2_bullet_spot = getstruct( "shoot_echo_1_and_2_bullet_spot" , "targetname" );
	
	level.rescue_echo_1 waittill( "goal" );
	
	level.rescue_echo_1 stop_magic_bullet_shield();
	MagicBullet( "ak47", shoot_echo_1_and_2_bullet_spot.origin , level.rescue_echo_1 GetTagOrigin( "J_SpineUpper" ) + ( 4 , 2 , 10 ) );
	wait .1;
	MagicBullet( "ak47", shoot_echo_1_and_2_bullet_spot.origin , level.rescue_echo_1 GetTagOrigin( "J_SpineUpper" ) + ( 10 , 12 , 5 ));
	wait .1;
	MagicBullet( "ak47", shoot_echo_1_and_2_bullet_spot.origin , level.rescue_echo_1 GetTagOrigin( "J_SpineUpper" ) + ( 7 , 3 , 8 ));
	wait .1;
	MagicBullet( "ak47", shoot_echo_1_and_2_bullet_spot.origin , level.rescue_echo_1 GetTagOrigin( "J_SpineUpper" ) + ( 4 , 2 , 10 ) );

	if ( IsDefined( level.rescue_echo_1 ) && IsAlive( level.rescue_echo_1 ) )
	{
		level.rescue_echo_1 Kill();
	}
}

rescue_exit_sequence_echo_2()
{
	slide_ref = getstruct( "slide_ref" , "targetname" );
	level waittill( "move_echo_2_and_3" );
	level.rescue_echo_2 teleport_ai( GetNode( "rescue_echo_2_run_start_spot" , "targetname" ) );
	level.rescue_echo_2 ally_run_prep();
	level.rescue_echo_2 LaserForceOff();
	
	slide_ref anim_reach_solo( level.rescue_echo_2 , "rescue_echo_2_slide" );
	
	slide_ref anim_single_solo( level.rescue_echo_2 , "rescue_echo_2_slide" );
	
	level.rescue_echo_2 SetGoalNode( GetNode( "rescue_echo_2_goal", "targetname") );
	shoot_echo_1_and_2_bullet_spot = getstruct( "shoot_echo_1_and_2_bullet_spot" , "targetname" );
	
	level.rescue_echo_2 waittill( "goal" );
	
	level.rescue_echo_2 stop_magic_bullet_shield();
	MagicBullet( "ak47", shoot_echo_1_and_2_bullet_spot.origin , level.rescue_echo_2 GetTagOrigin( "J_SpineUpper" ) + ( 4 , 2 , 10 ) );
	wait .1;
	MagicBullet( "ak47", shoot_echo_1_and_2_bullet_spot.origin , level.rescue_echo_2 GetTagOrigin( "J_SpineUpper" ) + ( 10 , 12 , 5 ));
	wait .1;
	MagicBullet( "ak47", shoot_echo_1_and_2_bullet_spot.origin , level.rescue_echo_2 GetTagOrigin( "J_SpineUpper" ) + ( 7 , 3 , 8 ));
	wait .1;
	MagicBullet( "ak47", shoot_echo_1_and_2_bullet_spot.origin , level.rescue_echo_2 GetTagOrigin( "J_SpineUpper" ) + ( 4 , 2 , 10 ) );

	if ( IsDefined( level.rescue_echo_2 ) && IsAlive( level.rescue_echo_2 ) )
	{
		level.rescue_echo_2 Kill();
	}
}

rescue_exit_sequence_echo_3()
{
	rescue_echo_3_bullet_spot = getstruct( "rescue_echo_3_bullet_spot" , "targetname" );
	level waittill( "move_echo_2_and_3" );
	level.rescue_echo_3 teleport_ai( GetNode( "rescue_echo_3_run_start_spot" , "targetname" ) );
	level.rescue_echo_3 ally_run_prep();
	level.rescue_echo_3 SetGoalNode( GetNode( "rescue_echo_3_goal", "targetname") );

	level.rescue_echo_3.deathanim = getGenericAnim( "echo_stumble_forward_death" );
		
	level.rescue_echo_3 waittill( "goal" );
	
	level.rescue_echo_3 stop_magic_bullet_shield();
	MagicBullet( "ak47", rescue_echo_3_bullet_spot.origin , level.rescue_echo_3 GetTagOrigin( "J_SpineUpper" ) + ( 4 , 2 , 10 ) );
	wait .1;
	MagicBullet( "ak47", rescue_echo_3_bullet_spot.origin , level.rescue_echo_3 GetTagOrigin( "J_SpineUpper" ) + ( 10 , 12 , 5 ));
	wait .1;
	MagicBullet( "ak47", rescue_echo_3_bullet_spot.origin , level.rescue_echo_3 GetTagOrigin( "J_SpineUpper" ) + ( 7 , 3 , 8 ));
	wait .1;
	MagicBullet( "ak47", rescue_echo_3_bullet_spot.origin , level.rescue_echo_3 GetTagOrigin( "J_SpineUpper" ) + ( 4 , 2 , 10 ) );

	if ( IsDefined( level.rescue_echo_3 ) && IsAlive( level.rescue_echo_3 ) )
	{
		level.rescue_echo_3 Kill();
	}
}

keep_up_or_die()
{
	level endon( "notify_slide_started" );
	
	while( !flag( "slide_started" ) )
	{
		dist_from_soap = DistanceSquared( level.player.origin , level.soap.origin );
		dist_from_price = DistanceSquared( level.player.origin , level.price.origin );
		
		if( dist_from_soap > 1000000 && dist_from_price > 1000000 )
		{
			level notify( "disable_ignore_player_triggers" );
			level.player EnableDeathShield( false );
			level.player.death_shield = 0;
			level.player DisableInvulnerability();
			setdvar( "ui_deadquote", "@PAYBACK_KEEP_UP" );
			magicbullet("ak47", level.player.origin + (0,50,200), level.player.origin);
			wait 0.05;
			magicbullet("ak47", level.player.origin + (0,40,220), level.player.origin);
			wait 0.05;
			magicbullet("ak47", level.player.origin + (0,50,230), level.player.origin);
			wait 0.05;
			magicbullet("ak47", level.player.origin + (0,30,180), level.player.origin);
			wait 0.05;
			if( IsAlive( level.player ) )
			{
				level.player Kill();
				maps\_utility::missionFailedWrapper();
			}
			return;
		}
		wait 1;	
	}
}

street_run_allow_damage()
{
	level endon( "notify_slide_started" );
	
	flag_wait( "price_at_ridge" );
	
	wait 7;
	
	level.player DisableInvulnerability();
	
	wait 7;
	
	setdvar( "ui_deadquote", "@PAYBACK_KEEP_UP" );
	magicbullet("ak47", level.player.origin + (0,50,200), level.player.origin);
	wait 0.05;
	magicbullet("ak47", level.player.origin + (0,40,220), level.player.origin);
	wait 0.05;
	magicbullet("ak47", level.player.origin + (0,50,230), level.player.origin);
	wait 0.05;
	magicbullet("ak47", level.player.origin + (0,30,180), level.player.origin);
	wait 0.05;
	if( IsAlive( level.player ) )
	{
	level.player Kill();
	maps\_utility::missionFailedWrapper();
	}
}

// price run funcs
price_run_part_1()
{
	level endon( "notify_slide_started" );
	
	level.price.moveplaybackrate = 1.2;
	level.price.animplaybackrate = 1.2;
	
	wait 1;
	
	price_run_anim_ref_1 = getstruct( "price_run_anim_ref_1" , "targetname" );
	price_run_anim_ref_2 = getstruct( "price_run_anim_ref_2" , "targetname" );
	price_run_anim_ref_2_debris = getstruct( "price_run_anim_ref_2_debris" , "targetname" );
	
	escape_debris = spawn_anim_model( "escape_debris" );
	escape_debris.animplaybackrate = 1.2;
	price_run_anim_ref_2_debris thread anim_first_frame_solo( escape_debris , "escape_debris_dodge" );	
	
	price_run_anim_ref_3 = getstruct( "price_run_anim_ref_3" , "targetname" );
	
	price_dodge_rpg_spot = getstruct( "price_dodge_rpg_spot" , "targetname" );
	price_dodge_rpg_spot_target = getstruct( price_dodge_rpg_spot.target , "targetname" );
	
	price_run_anim_ref_4 = getstruct( "price_run_anim_ref_4" , "targetname" );
	
	price_run_spot_4 = GetNode( "price_run_spot_4" , "targetname" );
	
	price_rpg_dodge_alt = GetNode( "price_rpg_dodge_alt" , "targetname" );
	
	price_run_anim_ref_1 anim_first_frame_solo( level.price , "payback_escape_start_backpedal_price" );
		
	wait 3.5;
	
	//backing up wave
	level.price.a.pose = "stand";
	level.price.a.movement = "run";
	price_run_anim_ref_1 anim_single_solo_run( level.price , "payback_escape_start_backpedal_price" );
	
	level notify( "move_echo_1" );
	
	price_run_anim_ref_2 anim_reach_solo( level.price , "escape_debris_dodge" );
	
	//dodge corrigated metal
	if( !flag( "price_check_anim_ref_2" ) )
	{
		price_run_anim_ref_2_debris thread anim_single_solo( escape_debris , "escape_debris_dodge" );
		price_run_anim_ref_2 anim_single_solo_run( level.price , "escape_debris_dodge" );
	}

	price_run_anim_ref_3 anim_reach_solo( level.price , "payback_escape_rpg_react_price" );
	
	//fire the rpg even if price won't dodge it
	magicBullet( "rpg_straight" , price_dodge_rpg_spot.origin , price_dodge_rpg_spot_target.origin , level.player );
	
	if( !flag( "price_check_anim_ref_3" ) )
	{
		//rpg reaction
		price_run_anim_ref_3 anim_single_solo_run( level.price , "payback_escape_rpg_react_price" );
	}
	
	else
	{
		level.price SetGoalNode( price_rpg_dodge_alt );
		level.price waittill( "goal" );
	}
	
	price_run_anim_ref_4 anim_reach_solo( level.price , "payback_escape_forward_wave_right_price" );
	
	if( !flag( "price_check_anim_ref_4" ) )
	{
		//forward wave
		price_run_anim_ref_4 anim_single_solo_run( level.price , "payback_escape_forward_wave_right_price" );
	}
	
	level.price.goalradius = 64;
	level.price SetGoalNode( price_run_spot_4 );
	
	level.price waittill( "goal" );
	
	flag_set( "price_at_ridge" );
	
	level.price AllowedStances( "stand" );
	
	level.price.animplaybackrate = 1;
	level.price.moveplaybackrate = 1;
	
	level.price.ignoreall = false;
	level.price.notarget = false;
	level.price.ignoreme = false;
}

// soap run funcs
soap_run_part_1()
{
	level endon( "notify_slide_started" );
	
	level.soap.moveplaybackrate = 1.2;
	
	level.soap.dust_fx_tag = "j_mainroot";
	level.soap.dust_fx = level._effect[ "dust_kickup" ];
	level.soap.animplaybackrate = 1.3;
	soap_run_anim_ref_1 = getstruct( "soap_run_anim_ref_1" , "targetname" );
	soap_run_anim_ref_2 = getstruct( "soap_run_anim_ref_2" , "targetname" );
	soap_run_anim_ref_3 = getstruct( "soap_run_anim_ref_3" , "targetname" );
	soap_run_anim_ref_4 = getstruct( "soap_run_anim_ref_4" , "targetname" );
	soap_run_anim_ref_5 = getstruct( "soap_run_anim_ref_5" , "targetname" );
	soap_slide_goal = GetNode( "soap_slide_goal" , "targetname" );
	
	soap_run_anim_ref_1 anim_first_frame_solo( level.soap , "payback_escape_start_wave_soap" );
	
	wait 4.4;
	
	level notify( "move_echo_2_and_3" );
	
	//start wave
	level.soap.a.pose = "stand";
	level.soap.a.movement = "run";
	soap_run_anim_ref_1 anim_single_solo_run( level.soap , "payback_escape_start_wave_soap" );

	soap_run_anim_ref_2 anim_reach_solo( level.soap , "payback_escape_turn_shoot_wave_soap" );
	
	//standing wave
	if( !flag( "soap_check_anim_ref_2" ) )
	{
		soap_run_anim_ref_2 anim_single_solo_run( level.soap , "payback_escape_turn_shoot_wave_soap" );
	}

	soap_run_anim_ref_3 anim_reach_solo( level.soap , "payback_escape_hood_slide_soap" );
	
	//hood slide
	if( !flag( "soap_check_anim_ref_3" ) )
	{
		aud_send_msg("soap_hood_slide");
		soap_run_anim_ref_3 anim_single_solo_run( level.soap , "payback_escape_hood_slide_soap" );
	}
	
	soap_run_anim_ref_4 anim_reach_solo( level.soap , "payback_escape_forward_wave_left_soap" );
	
	//forward wave
	if( !flag( "soap_check_anim_ref_4" ) )
	{
		soap_run_anim_ref_4 anim_single_solo_run( level.soap , "payback_escape_forward_wave_left_soap" );
	}
	
	soap_run_anim_ref_5 anim_reach_solo( level.soap , "payback_escape_turn_shoot_wave_soap" );
	
	//standing wave 2
	if( !flag( "soap_check_anim_ref_5" ) )
	{
		soap_run_anim_ref_5 anim_single_solo_run( level.soap , "payback_escape_turn_shoot_wave_soap" );
	}
	
	level.soap.goalradius = 64;
	
	level.soap SetGoalNode( soap_slide_goal );
	
	level.soap waittill( "goal" );
	
	level.price AllowedStances( "stand" );
	
	level.soap.animplaybackrate = 1;
	level.soap.moveplaybackrate = 1;
	
	level.soap.ignoreall = false;
	level.soap.notarget = false;
	level.soap.ignoreme = false;
}

waittill_player_triggers_jeep()
{
	level.player_enter_jeep_trigger waittill( "trigger" );
	
	flag_set( "player_in_escape_jeep" );
	level notify( "player_jumping_in_jeep" );
}

enter_jeep_player_blend_to_anim( rig , time )
{
	level.player PlayerLinkToBlend( rig , "tag_player" , time );
}


/////////////////////////////NEW JEEP ESCAPE/////////////////////////////

new_jeep_escape_setup()
{
	level.player endon( "death" );
	//jeep escape ambient rpg
	thread jeep_escape_ambient_rpg();
	
	thread jeep_escape_path_triggers();

	//setup slide ent array so we can start all the actors animations at the same time
	slide_ents = [];

	//setup the scripted node for all the slide anims
	level.slide_ref = getstruct( "slide_ref" , "targetname" );
	
	//setup the jeep that the player and price get into
	level.escape_jeep_1 = spawn_vehicle_from_targetname( "escape_jeep_1" );
	level.escape_jeep_1 SetCanDamage( false );
	level.escape_jeep_1 vehicle_lights_on();
	level.player_enter_jeep_trigger = GetEnt( "player_enter_jeep_trigger" , "targetname" );
	level.jeep_obj_spot = spawn( "script_model" , level.escape_jeep_1.origin );
	level.jeep_obj_spot linkto( level.escape_jeep_1 , "tag_brakelight_right" , ( 0 , 0 , 0 ) , ( 0 , 0 , 0 ) );
	
	//setup the jeep that soap and nikolai get into
	level.escape_jeep_2 = spawn_vehicle_from_targetname( "escape_jeep_2" );
	level.escape_jeep_2 SetCanDamage( false );
	level.escape_jeep_2 vehicle_lights_on();
	
	//setup the technical the jeep swerves to miss
//	level.swerve_technical = spawn_anim_model( "swerve_technical" );
//	level.slide_ref thread anim_first_frame_solo( level.swerve_technical , "jeep_slide_escape" );
	
	//setup the technical the jeep smashes into
//	level.smash_technical = spawn_anim_model( "smash_technical" );
//	level.slide_ref thread anim_first_frame_solo( level.smash_technical , "jeep_slide_escape" );
	
	thread player_enter_jeep();
	
	thread soap_attach_to_jeep();
	thread nikolai_attach_to_jeep();
	
	//escape jeep 1 driver
	level.escape_jeep_1_driver = GetEnt( "escape_jeep_1_driver" , "targetname" ) spawn_ai( true );
	level.escape_jeep_1_driver magic_bullet_shield();
	level.escape_jeep_1_driver battlechatter_off();
	level.escape_jeep_1_driver gun_remove();
	level.escape_jeep_1_driver.animname = "escape_jeep_1_driver";
	level.escape_jeep_1_driver LinkTo( level.escape_jeep_1 , "tag_driver" , ( 0 , 0 , 0 ) , ( 0 , 0 , 0 ) );
	level.escape_jeep_1 thread anim_loop_solo( level.escape_jeep_1_driver , "escape_jeep_1_driver_loop" , "stop_escape_jeep_1_driver_loop_1" , "tag_driver" );
	
	//escape jeep 2 driver
	level.escape_jeep_2_driver = GetEnt( "escape_jeep_2_driver" , "targetname" ) spawn_ai( true );
	level.escape_jeep_2_driver magic_bullet_shield();
	level.escape_jeep_2_driver battlechatter_off();
	level.escape_jeep_2_driver gun_remove();
	level.escape_jeep_2_driver.animname = "escape_jeep_2_driver";
	level.escape_jeep_2_driver LinkTo( level.escape_jeep_2 , "tag_driver" , ( 0 , 0 , 0 ) , ( 0 , 0 , 0 ) );
	level.escape_jeep_2 thread anim_loop_solo( level.escape_jeep_2_driver , "escape_jeep_2_driver_loop" , "stop_escape_jeep_2_driver_loop_1" , "tag_driver" );
	
	//escape jeep 1 gunner
	level.escape_jeep_1_gunner = GetEnt( "escape_jeep_1_gunner" , "targetname" ) spawn_ai( true );
	level.escape_jeep_1_gunner magic_bullet_shield();
	level.escape_jeep_1_gunner LaserForceOn();
	level.escape_jeep_1_gunner.animname = "escape_jeep_1_gunner";
	level.escape_jeep_1_gunner LinkTo( level.escape_jeep_1 , "tag_passenger" , ( 0 , 0 , 0 ) , ( 0 , 0 , 0 ) );
	level.escape_jeep_1 thread anim_loop_solo( level.escape_jeep_1_gunner , "escape_jeep_1_gunner_shoot_loop" , "stop_gunner_1_shoot_loop" , "tag_passenger" );
	
	//escape jeep 2 gunner
	level.escape_jeep_2_gunner = GetEnt( "escape_jeep_2_gunner" , "targetname" ) spawn_ai( true );
	level.escape_jeep_2_gunner magic_bullet_shield();
	level.escape_jeep_2_gunner LaserForceOn();
	level.escape_jeep_2_gunner.animname = "escape_jeep_2_gunner";
	level.escape_jeep_2_gunner LinkTo( level.escape_jeep_2 , "tag_guy0" , ( 0 , 0 , 0 ) , ( 0 , 0 , 0 ) );
	level.escape_jeep_2 thread anim_loop_solo( level.escape_jeep_2_gunner , "escape_jeep_2_gunner_shoot_loop" , "stop_gunner_2_shoot_loop" , "tag_guy0" );
	
	//nikolai
	level.nikolai_jeep_escape = GetEnt( "nikolai_jeep_escape" , "targetname" ) spawn_ai( true );
	level.nikolai_jeep_escape.animname = "nikolai_jeep_escape";
	level.nikolai_jeep_escape SetCanDamage( false );
	level.nikolai_jeep_escape battlechatter_off();
	level.nikolai_jeep_escape.ignoreall = true;
	level.nikolai_jeep_escape.ignoreme = true;
	level.nikolai_jeep_escape gun_remove();
	level.nikolai_jeep_escape Hide();
	level.nikolai_jeep_escape.dust_fx = level._effect[ "dust_kickup" ];
	level.nikolai_jeep_escape.dust_fx_tag = "j_mainroot";
	slide_ents = array_add( slide_ents , level.nikolai_jeep_escape );
	level.slide_ref thread anim_first_frame_solo( level.nikolai_jeep_escape , "jeep_slide_escape" );
	
	slide_ents = array_add( slide_ents , level.price );
	level.price.dust_fx_tag = "j_mainroot";
	level.price.dust_fx = level._effect[ "dust_kickup" ];
	
	slide_ents = array_add( slide_ents , level.soap );
	
	//setup the slide player arms
	level.escape_player_arms = spawn_anim_model( "player_slide_arms" );
	slide_ents = array_add( slide_ents , level.escape_player_arms );
	level.escape_player_arms Hide();
	level.slide_ref thread anim_first_frame_solo( level.escape_player_arms , "jeep_slide_escape" );
	level.escape_player_arms thread player_escape_notetracks();
	
	//setup the slide player legs
	level.escape_player_legs = spawn_anim_model( "player_slide_legs" );
	slide_ents = array_add( slide_ents , level.escape_player_legs );
	level.escape_player_legs Hide();
	level.escape_player_legs.dust_fx = level._effect[ "dust_kickup" ];
	level.escape_player_legs.dust_fx_tag = "j_ankle_le";
	level.slide_ref thread anim_first_frame_solo( level.escape_player_legs , "jeep_slide_escape" );
	
	//setup the enter jeep arms for the player
	level.jeep_player_arms = spawn_anim_model( "player_jeep_arms" );
	level.jeep_player_arms Hide();
	level.jeep_player_arms linkto( level.escape_jeep_1 , "tag_guy1" , ( 0 , 0 , 0 ) , ( 0 , 0 , 0 ) );
	level.jeep_player_arms thread anim_first_frame_solo( level.jeep_player_arms , "end_mount" );
	level.jeep_player_arms thread player_enter_jeep_notetracks();
	
	flag_wait( "start_player_slide" );
	
	level.price_repulsor = Missile_CreateRepulsorEnt( level.price, 5000, 200 );
	level.soap_repulsor = Missile_CreateRepulsorEnt( level.soap, 5000, 200 );
	level.player_repulsor = Missile_CreateRepulsorEnt( level.player, 5000, 200 );
	level.nikolai_repulsor = Missile_CreateRepulsorEnt( level.nikolai_jeep_escape, 5000, 200 );
	
	escape_jeep_1_repulsor = Missile_CreateRepulsorEnt( level.escape_jeep_1, 5000, 200 );
	escape_jeep_2_repulsor = Missile_CreateRepulsorEnt( level.escape_jeep_2, 5000, 200 );
	
	level.player EnableInvulnerability();
	level.player.health = level.player.maxhealth;
	level.player FreezeControls( true );
	level.player SetStance( "stand" );
	level.player DisableWeapons();
	
	thread rescue_carry_nikolai_drop();
	
	flag_set( "slide_started" );
	
	level notify( "notify_slide_started" );
	
	level.nikolai_jeep_escape delaycall( 1 , ::Show );
	
	level.price anim_stopanimscripted();
	level.soap anim_stopanimscripted();
	
	level.soap.animplaybackrate = 1;
	level.soap.moveplaybackrate = 1;
	
	level.price.animplaybackrate = 1;
	level.price.moveplaybackrate = 1;
	
	wait .05;
	
	aud_send_msg( "outro_slide_start" );
	
	level.slide_ref thread anim_single( slide_ents , "jeep_slide_escape" );
	level.escape_player_arms thread player_slide_rumbles();
	level.price thread price_escape_notetracks();
	level.soap thread soap_escape_notetracks();
	level.nikolai_jeep_escape thread nikolai_escape_notetracks();
	delayThread( 0.05 , ::enter_jeep_player_blend_to_anim , level.escape_player_arms , 0.25 );
	level.escape_player_legs delaycall( 1 , ::Show );
}

player_slide_rumbles()
{
	self waittillmatch("single anim", "slide_fx_on" );
	// initial plop on the ground 
	level.player PlayRumbleOnEntity( "light_1s" );
	
	wait .4;
	
	// sliding rumble
	level.player PlayRumbleLoopOnEntity( "subtle_tank_rumble" );
	
	self waittillmatch("single anim", "slide_fx_off" );
	
	// stop sliding rumble
	level.player StopRumble( "subtle_tank_rumble" );
}

jeep_escape_enemies()
{
	array_spawn_function_targetname( "jeep_escape_enemies" , ::flashlight_on_guy );
	array_spawn_targetname( "jeep_escape_enemies" , true );
}

jeep_escape_technical_wait_for_goto( targetname , wait_for )
{
	vehicle = spawn_vehicle_from_targetname( targetname );
	vehicle.dontunloadonend = true;
	
	//vehicle SetCanDamage( false );
	
	vehicle vehicle_lights_on();
	
	level waittill( wait_for );
	
	vehicle gopath();
}

ridge_contain()
{
	level endon( "player_jumping_in_jeep" );
	
	flag_wait( "ridge_contain" );
	
	if( !flag( "player_in_escape_jeep" ) )
	{
		level.player DisableInvulnerability();
		level.player EnableDeathShield( false );
		setdvar( "ui_deadquote", "@PAYBACK_RUN_TO_JEEP" );
		magicbullet("ak47", level.player.origin + (0,50,200), level.player.origin);
		wait 0.05;
		magicbullet("ak47", level.player.origin + (0,40,220), level.player.origin);
		wait 0.05;
		magicbullet("ak47", level.player.origin + (0,50,230), level.player.origin);
		wait 0.05;
		magicbullet("ak47", level.player.origin + (0,30,180), level.player.origin);
		wait 0.05;
		if( IsAlive( level.player ) )
		{
			level.player Kill();
			maps\_utility::missionFailedWrapper();
		}
	}
}

jeep_escape_path_triggers()
{
	flag_wait( "final_technicals" );
	
	thread jeep_escape_final_technical_1();
	thread jeep_escape_final_technical_2();

	flag_wait( "winning" );
	
	if( flag( "player_in_escape_jeep" ) )
	{

		thread destroy_final_technical_2();
		if( IsAlive( level.final_technical_1 ) )
		{
			level.final_technical_1 force_kill();
		}
		
		wait 1;
		
		objective_state( obj( "obj_rescue" ), "done" );
		
		level.escape_jeep_2 notify( "stop_soap_new_fire_loop" );
		
		thread jeep_escape_vo();
		
		wait 4;
	
		level.player thread set_black_fade( 1, 2 );
		
		level.jeep_rumble_loop rumble_ramp_off( 4 );
	
		wait 6;
		
		show_hud_after_scripted_sequence();
		nextmission();
	}
}

jeep_escape_vo()
{
	// "Glad you made it!"
	level.escape_jeep_1_driver dialogue_queue( "payback_eol_glad" );
	
	wait .5;
	
	// "So if Volk’s in Paris, how are we getting there in the middle of a bloody war?"
	radio_dialogue( "payback_mct_inparis" );
	
	wait .5;
	
	// "We can't. But I know who can"
	level.price dialogue_queue( "payback_pri_iknowwho" );
}

destroy_final_technical_2()
{
	wait .5;
	
	if( IsAlive( level.final_technical_2 ) )
	{
		level.final_technical_2 force_kill();
	}	
}

get_in_jeep_timer()
{
	level endon( "player_jumping_in_jeep" );
	
	level.player.ignoreme = true;
	
	wait 4;
	
	thread jeep_escape_uaz();
	
	wait 6;
	
	level.player.ignoreme = false;
	
	wait 5;
	
	if( !flag( "player_in_escape_jeep" ) )
	{
		level.player DisableInvulnerability();
		level.player EnableDeathShield( false );
		setdvar( "ui_deadquote", "@PAYBACK_RUN_TO_JEEP" );
		magicbullet("ak47", level.player.origin + (0,50,200), level.player.origin);
		wait 0.05;
		magicbullet("ak47", level.player.origin + (0,40,220), level.player.origin);
		wait 0.05;
		magicbullet("ak47", level.player.origin + (0,50,230), level.player.origin);
		wait 0.05;
		magicbullet("ak47", level.player.origin + (0,30,180), level.player.origin);
		wait 0.05;
		if( IsAlive( level.player ) )
		{
			level.player Kill();
			maps\_utility::missionFailedWrapper();
		}
	}
}

price_escape_notetracks()
{
	//controls the notetracks for price
//	self waittillmatch("single anim", "notetrack" );
	
	self waittillmatch("single anim", "end" );
	level.price LinkTo( level.escape_jeep_1 , "tag_guy0" , ( 0 , 0 , 0 ) , ( 0 , 0 , 0 ) );
	
	flag_set( "price_in_escape_jeep_1" );
	
	//wave and shoot anim
	level.escape_jeep_1 thread anim_loop_solo( level.price , "price_jeep_shoot_loop" , "stop_price_jeep_wave_and_shoot_loop" , "tag_guy0" );
	
	level.escape_jeep_1 waittill( "stop_price_jeep_wave_and_shoot_loop" );
	
	level.escape_jeep_1 anim_single_solo( level.price , "price_jeep_sit_down" , "tag_guy0" );
	
	level.escape_jeep_1 thread anim_loop_solo( level.price , "price_back_jeep_loop" , "stop_price_jeep_wave_and_shoot_loop" , "tag_guy0" );
}

soap_escape_notetracks()
{
	level endon( "player_entering_jeep" );
	//controls the notetracks for soap
//	self waittillmatch("single anim", "notetrack" );
	
	self waittillmatch("single anim", "end" );
	self LinkTo( level.escape_jeep_2 , "tag_guy1" , ( 0 , 0 , 0 ) , ( 0 , 0 , 0 ) );
	//shoot loop anim
	level.escape_jeep_2 thread anim_loop_solo( self , "soap_jeep_shoot_loop" , "stop_soap_and_nikolai_loops" , "tag_guy1" );
}

soap_attach_to_jeep()
{
	flag_wait( "player_entering_jeep" );
	
	wait .05;
	level.soap anim_stopanimscripted();
	
	level.soap LinkTo( level.escape_jeep_2 , "tag_guy1" , ( 0 , 0 , 0 ) , ( 0 , 0 , 0 ) );
	
	level.escape_jeep_2 thread anim_loop_solo( level.soap , "soap_jeep_shoot_loop_2" , "stop_soap_new_fire_loop" , "tag_guy1" );
	
	level.escape_jeep_2 waittill( "stop_soap_new_fire_loop" );
	
	level.escape_jeep_2 anim_single_solo( level.soap , "soap_jeep_sit_down" , "tag_guy1" );
	
	level.escape_jeep_2 thread anim_loop_solo( level.soap , "soap_back_jeep_loop" , undefined , "tag_guy1" );	
}

nikolai_attach_to_jeep()
{
	level endon( "nikolai_attached_to_jeep_natural" );
	
	flag_wait( "player_entering_jeep" );
	
	wait .05;
	level.nikolai_jeep_escape anim_stopanimscripted();
	
	level.nikolai_jeep_escape LinkTo( level.escape_jeep_2 , "tag_passenger" , ( 0 , 0 , 0 ) , ( 0 , 0 , 0 ) );
	level.escape_jeep_2 anim_loop_solo( level.nikolai_jeep_escape , "nikolai_passenger_loop" , undefined , "tag_passenger" );
}

nikolai_escape_notetracks()
{
	level endon( "player_entering_jeep" );
	//controls the notetracks for nikolai
//	self waittillmatch("single anim", "notetrack" );
	
	self waittillmatch("single anim", "end" );
	
	level notify( "nikolai_attached_to_jeep_natural" );
	
	self LinkTo( level.escape_jeep_2 , "tag_passenger" , ( 0 , 0 , 0 ) , ( 0 , 0 , 0 ) );
	level.escape_jeep_2 anim_loop_solo( self , "nikolai_passenger_loop" , "stop_soap_and_nikolai_loops" , "tag_passenger" );
}

player_escape_notetracks()
{
	//controls the notetracks for the player sliding down
	self waittillmatch("single anim", "gun_up" );
	
	thread price_slide_end_vo();
	
	level.player EnableWeapons();
	
	self waittillmatch("single anim", "end" );
	thread get_in_jeep_timer();
	thread ridge_contain();
	thread waittill_player_triggers_jeep();
	level.player DisableInvulnerability();
	level notify( "move_jeep_escape_technical_1" );
	level notify( "move_jeep_escape_technical_2" );
	level.player Unlink();
	//level.player EnableWeapons();
	level.player AllowJump( true );
	level.player AllowCrouch( true );
	level.escape_player_arms Delete();
	level.escape_player_legs Delete();
	autosave_now();
}

price_slide_end_vo()
{
	level.price dialogue_queue( "payback_pri_letsgocmon" );
	
	wait .5;
	
	level.price dialogue_queue( "payback_pri_gottamove" );
}

player_enter_jeep_notetracks()
{
	//controls the notetracks for the player when they get into the jeep
//	self waittillmatch("single anim", "notetrack" );
	
	self waittillmatch("single anim", "end" );
	
	level.escape_jeep_1 notify( "stop_price_jeep_wave_and_shoot_loop" );
	
	level.jeep_player_arms Hide();
	
	level.player PlayerLinkToDelta( level.jeep_player_arms , "tag_player" );
	
	level.player FreezeControls( false );
	level.player EnableWeapons();
	
	flag_set( "player_in_jeep" );
}

player_enter_jeep()
{
	level waittill( "player_jumping_in_jeep" );
	exploder(7000);
	level.sandstormSpawnrate = .3;
	aud_send_msg("mus_rescue_start_finale_music");
	
	level.player EnableInvulnerability();
	level.player.health = level.player.maxhealth;
	
	thread jeep_ride_exit_rumbles();
	
	thread radio_dialogue( "payback_pri_moveout_r" );
	
	level.escape_jeep_1_gunner battlechatter_off();
	level.escape_jeep_2_gunner battlechatter_off();
	
	thread gunner_2_sit_down_and_idle();
	
	level.escape_jeep_1 thread gopath();
	level.escape_jeep_2 delayThread( .5 , ::gopath );
	
	level.escape_jeep_1 Vehicle_SetSpeed( 41 , 10 );
	level.escape_jeep_2 Vehicle_SetSpeed( 41 , 10 );
	
	level.escape_jeep_1 jeep_tread_fx();
	level.escape_jeep_2 jeep_tread_fx();

	//maps\payback_sandstorm::setup_vehicle_inview_lights(); // swap lights
	
	level.player FreezeControls( true );
	level.player SetStance( "stand" );
	level.player DisableWeapons();
	
	level.player_enter_jeep_trigger Delete();

	level.player PlayerLinkToBlend( level.jeep_player_arms , "tag_player" , .25 );
	level.jeep_player_arms delaycall( 0.25, ::Show );
	
	flag_set( "player_entering_jeep" );
	level notify( "player_entering_jeep" );
	level.escape_jeep_2 notify( "stop_soap_and_nikolai_loops" );
	
	hide_hud_for_scripted_sequence();
	
	aud_send_msg( "outro_player_in_jeep" );
	
	level.jeep_player_arms anim_single_solo( level.jeep_player_arms , "end_mount" );
	
	thread gunner_1_sit_down_and_idle();
}

jeep_ride_exit_rumbles()
{
	wait .5;
	
	level.player PlayRumbleOnEntity( "light_1s" );
	
	wait .4;
	
	level.jeep_rumble_loop = level.player get_rumble_ent( "subtle_tank_rumble" );
}

jeep_tread_fx()
{
	PlayFXOnTag( level._effect[ "pb_jeep_trail" ] , self , "tag_wheel_back_left" );
	wait 0.05;
	PlayFXOnTag( level._effect[ "pb_jeep_trail" ] , self , "tag_wheel_back_right" );
}

gunner_1_sit_down_and_idle()
{
	level.escape_jeep_1 notify( "stop_gunner_1_shoot_loop" );
	
	level.escape_jeep_1 anim_single_solo( level.escape_jeep_1_gunner , "escape_jeep_1_gunner_sit_down" , "tag_passenger" );
	
	level.escape_jeep_1 anim_loop_solo( level.escape_jeep_1_gunner , "escape_jeep_1_gunner_passenger_loop" , undefined , "tag_passenger" );
}

gunner_2_sit_down_and_idle()
{
	wait 3;
	
	level.escape_jeep_2 notify( "stop_gunner_2_shoot_loop" );
	
	level.escape_jeep_2 anim_single_solo( level.escape_jeep_2_gunner , "escape_jeep_2_gunner_sit_down" , "tag_guy0" );
	
	level.escape_jeep_2 anim_loop_solo( level.escape_jeep_2_gunner , "escape_jeep_2_gunner_rear_loop" , undefined , "tag_guy0" );
}

jeep_escape_final_technical_1()
{
	level.final_technical_1 = spawn_vehicle_from_targetname_and_drive( "jeep_escape_final_technical_1" );
	level.final_technical_1.dontunloadonend = true;
	level.final_technical_1 vehicle_lights_on();
}

jeep_escape_final_technical_2()
{
	level.final_technical_2 = spawn_vehicle_from_targetname_and_drive( "jeep_escape_final_technical_2" );
	level.final_technical_2.dontunloadonend = true;
	level.final_technical_2 vehicle_lights_on();
}

jeep_escape_uaz()
{
	vehicle = spawn_vehicle_from_targetname_and_drive( "jeep_escape_uaz" );
	vehicle vehicle_lights_on();
}

jeep_escape_ambient_rpg()
{
	flag_wait( "jeep_escape_rpg_1" );
	
	thread jeep_escape_rpg( "jeep_escape_rpg_1" );
	
	flag_wait( "jeep_escape_rpg_2" );
	
	thread jeep_escape_rpg( "jeep_escape_rpg_2" );
	
	flag_wait( "jeep_escape_rpg_3" );
	
	thread jeep_escape_rpg( "jeep_escape_rpg_3" );
}

jeep_escape_rpg( targetname )
{
	rpg_source = getstruct( targetname , "targetname" );
	rpg_target = getstruct( rpg_source.target , "targetname" );
	MagicBullet( "rpg" , rpg_source.origin , rpg_target.origin );
}

//////////////////////////////END NEW JEEP ESCAPE////////////////////////////////


rescue_carry_nikolai_setup()
{
	level.nikolai endon( "death" );
	level endon( "rescue_kill_nikolai" );
	if ( !IsDefined(level.nikolai) )
	{
		spawn_ally("nikolai", "s3_rescue_nikolai");
	}
	
	level.nikolai disable_pain();
	level.nikolai.flashbangImmunity = true;
	level.nikolai pushplayer( true );
	level.nikolai.a.pose = "crouch";// so he doesn't get melee'd

	thread rescue_nikolai_player();
	thread crashed_chopper_prop();
	thread crashed_chopper_tail();
	
	level.nikolai thread gun_remove();
	
	level.chopper_rescue_ref thread anim_first_frame_solo( level.nikolai , "payback_sstorm_chopper_rescue_nikolai_pullout" );
	
	flag_wait( "start_nikolai_pullout" );
	
	flag_set( "start_nikolai_pullout_echo" );
	
	level.chopper_rescue_ref anim_single_solo( level.nikolai , "payback_sstorm_chopper_rescue_nikolai_pullout" );
	
	level.chopper_rescue_ref thread anim_loop_solo( level.nikolai , "rescue_nikolai_idle" , "stop_nikolai_loop" );
	
	level notify( "disable_clear_chopper_obj_spot" );
	
	thread pickup_nikolai_enable_and_disable_weapons();
		
	objective_position( obj( "obj_rescue" ), level.nikolai.origin + ( 0 , 0 , 20 ) );
	objective_setpointertextoverride( obj( "obj_rescue" ), &"PAYBACK_NIKOLAI" );
	
	level.nikolai_use_trigger sethintstring( &"PAYBACK_USE_FREE_NIKOLAI" );
	level.nikolai_use_trigger UseTriggerRequireLookAt();
	level.nikolai_use_trigger trigger_on();
}

pickup_nikolai_enable_and_disable_weapons()
{
	level endon( "rescue_picking_up_nikolai" );
	
	trig = GetEnt( "rescue_nikolai_disable_weapons_trigger" , "targetname" );
	
	fov = GetDvarInt( "cg_fov" );
	SetSavedDvar( "objectiveHide" , 0 );
	
	while( 1 )
	{
		if( level.player IsTouching( trig ) && level.player WorldPointInReticle_Circle( level.nikolai.origin , fov , 120 ) )
		{
			level.player DisableWeapons();
			SetSavedDvar( "objectiveHide" , 1 );
			
			while( level.player IsTouching( trig ) && level.player WorldPointInReticle_Circle( level.nikolai.origin , fov, 120 ) )
			{
				wait .5;
			}
			level.player EnableWeapons();
			SetSavedDvar( "objectiveHide" , 0 );
		}
		wait .05;
	}
}

player_out_in_open()
{
	level endon( "slide_started" );
	
	trig = GetEnt( "player_out_in_open" , "targetname" );
	
	while( 1 )
	{
		if( level.player IsTouching( trig ) )
		{
			level.player.gs.player_attacker_accuracy = 1.5;
			
			while( level.player IsTouching( trig ) )
			{
				wait .05;
			}
			level.player.gs.player_attacker_accuracy = .1;
		}
		wait .05;
	}
}

ignore_player_until_looking_at_target( trigger , target )
{
	level endon( "start_player_slide" );
	level endon( "disable_ignore_player_triggers" );
	
	fov = GetDvarInt( "cg_fov" );
	
	level.player.ignoreme = true;
	level.player EnableDeathShield( true );
	level.player.death_shield = 1;
	level.player.gs.player_attacker_accuracy = .1;
	
	while( 1 )
	{
		if( level.player IsTouching( trigger ) && level.player WorldPointInReticle_Circle( target.origin , fov , 160 ) )
		{
			level.player.ignoreme = false;
			level.player EnableDeathShield( false );
			level.player.death_shield = 0;
			level.player.gs.player_attacker_accuracy = 1.5;
			
			while( level.player IsTouching( trigger ) && level.player WorldPointInReticle_Circle( target.origin , fov, 160 ) )
			{
				wait .05;
			}	
			level.player.ignoreme = true;
			level.player EnableDeathShield( true );
			level.player.death_shield = 1;
			level.player.gs.player_attacker_accuracy = .1;
		}
		wait .05;
	}
}

rescue_nikolai()
{
	level.chopper_rescue_ref notify( "stop_nikolai_loop" );
	
	level.chopper_rescue_ref anim_single_solo( level.nikolai , "rescue_nikolai" );
}

rescue_nikolai_player()
{
	player_rig = spawn_anim_model( "rescue_nikolai_player_rig" );
	player_rig hide();
	level.chopper_rescue_ref anim_first_frame_solo( player_rig , "rescue_nikolai" );
		
	level.nikolai_use_trigger = GetEnt( "nikolai_use_trigger" , "targetname" );
	level.nikolai_use_trigger trigger_off();
	
	level.nikolai_use_trigger waittill( "trigger" );
	
	thread follow_technical();
	
	trigger = GetEnt( "ignore_player_trigger_1" , "targetname" );
	target = GetEnt( "ignore_player_target_1" , "targetname" );
	thread ignore_player_until_looking_at_target( trigger , target );
	
	trigger = GetEnt( "ignore_player_trigger_2" , "targetname" );
	target = GetEnt( "ignore_player_target_2" , "targetname" );
	thread ignore_player_until_looking_at_target( trigger , target );
	
	level.player EnableInvulnerability();
	
	thread health_mods();
	
	level.price battlechatter_off();
	level.soap battlechatter_off();
	level.rescue_echo_1 battlechatter_off();
	level.rescue_echo_2 battlechatter_off();
	level.rescue_echo_3 battlechatter_off();
	
	level.player.health = level.player.maxhealth;
	
	thread move_echo_2_3_price_when_nikolai_picked_up();
	
	street_run_anim_check_triggers = GetEntArray( "street_run_anim_check_triggers", "script_noteworthy" );
	foreach ( trigger in street_run_anim_check_triggers )
	{
		trigger trigger_on();
	}
	
	level notify( "clear_echo_stuff" );
	
	level notify( "stop_laser_handler" );
	flag_set( "stop_laser_handler" );
	
	level.rescue_echo_3 LaserForceOff();
	
	thread move_allies_after_pickup();
	
	thread pickup_nikolai_radio_echo();
	
	thread carry_warn_and_kill_trigs();
	
	thread keep_up_or_die();
	thread street_run_allow_damage();

	objective_position( obj( "obj_rescue" ) , ( 0 , 0 , 0 ) );
	Objective_SetPointerTextOverride( obj( "obj_rescue" ) , "" );
	
	level.nikolai_use_trigger Delete();
	
	level notify("rescue_picking_up_nikolai");
	
	SetSavedDvar( "objectiveHide" , 0 );
	
	level.player DisableWeapons();
	
	thread max_player_ammo_for_ending();

	level.player allowcrouch( false );
	level.player allowprone( false );
	level.player SetStance( "stand" );
	
	level.player PlayerLinkToBlend( player_rig, "tag_player", 0.4, 0.2, 0.2 );
	wait 0.4;

	SetSunFlarePosition(( 345 , 253 , 0 ));
	
	player_rig Show();
	
	thread rescue_exit_sequence();
	
	aud_send_msg( "nikolai_pickup" );
	
	thread rescue_nikolai();
	
	level.chopper_rescue_ref anim_single_solo( player_rig , "rescue_nikolai" );
	
	level.player DisableInvulnerability();
	
	thread pickup_nikolai_and_escape_vo();
	
	// Disable Mantle
	SetSavedDvar( "mantle_enable" , 0 );
	
	level.player unlink();
	player_rig delete();
	
	thread run_objective_markers();

	rescue_carry_nikolai_pickup_finish();
	
	autosave_now();
}

max_player_ammo_for_ending()
{
	weap = level.player GetCurrentWeapon();
	if ( weap != "none" )
	{
		curAmt = level.player GetCurrentWeaponClipAmmo();
		clipSize = WeaponClipSize( weap );
		if ( IsDefined( clipSize ) )
		{
			giveAmt = clipSize - curAmt;
			if ( IsDefined( giveAmt ) && giveAmt > 0 )
			{
				level.player SetWeaponAmmoClip( weap , curAmt + giveAmt );
			}
		}
	}
}

follow_technical()
{
	flag_wait( "spawn_follow_technical" );
	follow_technical = spawn_vehicle_from_targetname_and_drive( "follow_technical" );
	follow_technical SetCanDamage( false );
	follow_technical.dontunloadonend = true;
	follow_technical thread vehicle_lights_on();
	
	flag_wait( "wait_to_move_follow_technical" );
	
	node = GetVehicleNode( "follow_technical_path_2" , "targetname" );
	follow_technical AttachPath( node );
	follow_technical thread gopath();
}

move_echo_2_3_price_when_nikolai_picked_up()
{
	level.price.ignoreall = true;
	level.price ClearEnemy();
	level.price setgoalnode( GetNode( "echo_2_3_price_pickup_niko_move_spot" , "targetname" ) );
	
	level.rescue_echo_2.ignoreall = true;
	level.rescue_echo_2 ClearEnemy();
	level.rescue_echo_2 setgoalnode( GetNode( "echo_2_3_price_pickup_niko_move_spot" , "targetname" ) );
	
	level.rescue_echo_3.ignoreall = true;
	level.rescue_echo_3 ClearEnemy();
	level.rescue_echo_3 setgoalnode( GetNode( "echo_2_3_price_pickup_niko_move_spot" , "targetname" ) );
}

pickup_nikolai_radio_echo()
{
	wait .5;
	
	level.price dialogue_queue( "payback_pri_headingtoexfil" ); // "Echo-2 we've got Nikolai and are heading to the exfil point."
}

pickup_nikolai_and_escape_vo()
{
	level.player endon( "death" );
	level endon( "start_player_slide" );
	
	thread pickup_nikolai_and_escape_radio_vo();
	
	level.price dialogue_queue( "payback_pri_moveout4" ); // "Move out!"

	//wait 2;
	
	//level.soap dialogue_queue( "payback_pri_gettoexfil" ); // "Let's get to the exfil point."
	
	wait 2;
	
	level.soap dialogue_queue( "payback_mct_followme" ); // "Follow me." 
	
	wait 2;
	
	level.price dialogue_queue( "payback_pri_comeonyuri" ); // "Come on, Yuri."
	
	flag_wait( "start_flare" );

	SetCullDist(0); // Restore infinite far clip plane for final bit
	
	wait 1;
	
	level.soap dialogue_queue( "payback_mct_iseethem" ); // "There's Echo Team!"
	
	wait 2;
	
	level.price dialogue_queue( "payback_pri_yurithisway" ); // "Yuri, this way."
	
	wait 2;
	
	level.soap dialogue_queue( "payback_mct_keepmoving2" ); // "We have to keep moving." 
	
	wait 2;
	
	level.price dialogue_queue( "payback_pri_letsgoyuri" );// "Let's go, Yuri! Move it!"
}

pickup_nikolai_and_escape_radio_vo()
{
	level.player endon( "death" );
	
	wait 3;
	
	level.rescue_echo_1 dialogue_queue( "payback_eol_approachingexfil" ); // "Echo-2, we're approaching the exfil point!"
	
	flag_wait( "start_flare" );
	
	wait 2;
	
	if( IsDefined( level.rescue_echo_1 ) && IsAlive( level.rescue_echo_1 ) )
	{
		level.rescue_echo_1 dialogue_queue( "payback_eol_letsgo" ); // "Let's go. They're just past the ridge."
	}
}

rescue_nikolai_price()
{
	level endon( "rescue_picking_up_nikolai" );
	level.price.script_grenades = 0;
	level.price setgoalnode( GetNode( "rescue_price_chopper" , "targetname" ) );
	
	level.price waittill( "goal" );
	
	thread rescue_chopper_extract_dialogue();
}

crashed_chopper_prop()
{
	chopper_prop = spawn_anim_model( "chopper_prop" );
	level.chopper_rescue_ref anim_loop_solo( chopper_prop , "payback_sstorm_chopper_rescue_propeller" );
}

crashed_chopper_tail()
{
	chopper_tail = spawn_anim_model( "chopper_tail" );
	chopper_tail_spot = getstruct( "crashed_chopper_tail_spot" , "targetname" );
	chopper_tail.origin = chopper_tail_spot.origin;
	chopper_tail.angles = chopper_tail_spot.angles;
	chopper_tail anim_loop_solo( chopper_tail , "payback_sstorm_chopper_rescue_tail_rotor" );
}

carry_warn_and_kill_trigs()
{
	flag_clear( "carry_warn" );
	flag_clear( "carry_kill" );
	
	dialog = [];
	// Price: "Yuri, where are you going?"
	dialog = array_add( dialog, "payback_pri_wheregoing" );
	// Price: "Get back here, Yuri!"
	dialog = array_add( dialog, "payback_pri_getbackhere2" );

	dialog_to_play = random( dialog );
	
	flag_wait( "carry_warn" );
	
	level thread radio_dialogue( dialog_to_play );
	
	flag_wait( "carry_kill" );
	
	setdvar( "ui_deadquote", "@PAYBACK_STAY_WITH_TEAM" );
	maps\_utility::missionFailedWrapper();
}
	
rescue_carry_nikolai_pickup_finish()
{
	payback_stance_carry_icon_enable( true );
	
	//level.player AllowSprint( false );
	
	//setSavedDvar( "player_sprintSpeedScale", 0.99 );

	level.player SetMoveSpeedScale( 0.75 );
	level.player allowCrouch( false );
	level.player allowProne( false );
	level.player allowjump( false );
	level.player allowmelee( false );
	thread rescue_carry_prevent_weapon_pickup_thread();
	rescue_set_carry_viewbob( level.player, true );
	
	if ( IsDefined( level.nikolai ) )
	{
		// Nikolai does not actually exist while being carried
		level.nikolai stop_magic_bullet_shield();
		level.nikolai delete();
		level.nikolai = undefined;
	}
}

payback_stance_carry_icon_enable( bool )
{
	if ( isdefined( bool ) && bool == false )
	{
		payback_stance_carry_icon_disable();
		return;
	}

	if ( isDefined( level.stance_carry ) )
		level.stance_carry destroy();

	SetSavedDvar( "hud_showStance", "0" );

	level.stance_carry = newHudElem();
	level.stance_carry setshader( "stance_carry", 80, 80 );
	level.stance_carry.x = -65;
	level.stance_carry.y = -10;
	level.stance_carry.alignX = "right";
	level.stance_carry.alignY = "bottom";
	level.stance_carry.horzAlign = "right_adjustable";
	level.stance_carry.vertAlign = "bottom_adjustable";
	level.stance_carry.foreground = true;
 	level.stance_carry.hidewheninmenu = true;
	level.stance_carry.hidewhendead = true;
	level.stance_carry.alpha = 1;
}

payback_stance_carry_icon_disable()
{
	if ( isDefined( level.stance_carry ) )
	{
		level.stance_carry destroy();
	}
	SetSavedDvar( "hud_showStance", "1" );
}


rescue_carry_nikolai_drop()
{
	payback_stance_carry_icon_enable( false );
	
	// Enable Mantle
	SetSavedDvar( "mantle_enable" , 1 );
	
	level.player SetMoveSpeedScale( 1 );
	//setSavedDvar( "player_sprintSpeedScale", 1 );

	level notify( "rescue_carry_prevent_weapon_pickup_thread_stop" );
	rescue_set_carry_viewbob( level.player, false );
}

rescue_carry_prevent_weapon_pickup_thread()
{
	level notify( "rescue_carry_prevent_weapon_pickup_thread" );
	level endon( "rescue_carry_prevent_weapon_pickup_thread" );
	level endon( "rescue_carry_prevent_weapon_pickup_thread_stop" );
		
	// Prevent all existing AI from dropping their weapons
	guys = GetAIArray( "axis" );
	foreach( guy in guys )
	{
		if ( IsAlive( guy ) )
		{
			guy.dontdropweapon = true;
		}
	}
	
	// Cleanup any weapons on the ground
	// Just to be sure we keep looking for any new weapons dropped for any unforseen reasons
	for(;;)
	{
		weapons = GetWeaponArray();
		if ( IsDefined( weapons ) )
		{
			foreach( weapon in weapons )
			{
				weapon delete();
			}
		}
		wait 0.05;
	}
}

rescue_set_carry_viewbob( player, carrying )
{
	if ( carrying )
    {              
	    // Carrying view bob settings
//	    SetSavedDvar("bg_viewBobAmplitudeStanding",				"0.05 0.025" );
//		SetSavedDvar("bg_viewBobAmplitudeStandingAds",			"0.05 0.025" );
//	    SetSavedDvar("bg_viewBobAmplitudeSprinting",			"0.1 0.05" );
//		SetSavedDvar("bg_weaponBobAmplitudeStanding",			"0.05 0.025" );
//		SetSavedDvar("bg_weaponBobAmplitudeSprinting",			"0.1 0.05" );
	   	SetSavedDvar("bg_viewBobAmplitudeStanding",				"0.007 0.007" );
		SetSavedDvar("bg_viewBobAmplitudeStandingAds",			"0.007 0.007" );
	    SetSavedDvar("bg_viewBobAmplitudeSprinting",			"0.02 0.014" );
		SetSavedDvar("bg_weaponBobAmplitudeStanding",			"0.055 0.025" );
		SetSavedDvar("bg_weaponBobAmplitudeSprinting",			"0.02 0.014" );
	}
	else
	{              
	    // Not Carrying (Normal) view bob settings
	    SetSavedDvar("bg_viewBobAmplitudeStanding",				"0.007 0.007" );
		SetSavedDvar("bg_viewBobAmplitudeStandingAds",			"0.007 0.007" );
	    SetSavedDvar("bg_viewBobAmplitudeSprinting",			"0.02 0.014" );
		SetSavedDvar("bg_weaponBobAmplitudeStanding",			"0.055 0.025" );
		SetSavedDvar("bg_weaponBobAmplitudeSprinting",			"0.02 0.014" );
	}              
}

rescue_spawn_initial()
{
	aud_send_msg("set_pre_rescue_mix");
	
	// Make sure any axis are cleaned up from previous sections
//	array_call( GetAIArray( "axis" ), ::delete );
	
	// phantom fire on nikolai
	phantom_fire_source = GetStructArray( "rescue_phantom_fire_source1", "targetname" );
	thread phantom_pressure( level.nikolai, "ak47", phantom_fire_source, 0.05, 1.5, 3000, 5000, 0.5 );
	
	// Player should not be hit with RPGs at all until on their way escaping to the jeeps
	thread rescue_protect_from_rpg_till( level.player, "rescue_escape_dialogue" );

	// Make end mission vista model visible now	
	GetEnt("pb_end_vista", "targetname") Show();	
}

run_objective_markers()
{
	jeep_escape_objective_spot_1 = getstruct( "jeep_escape_objective_spot_1" , "targetname" );
	Objective_Position( obj( "obj_rescue" ) , jeep_escape_objective_spot_1.origin );
	
	level waittill( "run_objective_spot_2" );
	
	check_if_ok_to_delete();
	
	jeep_escape_objective_spot_2 = getstruct( "jeep_escape_objective_spot_2" , "targetname" );
	Objective_Position( obj( "obj_rescue" ) , jeep_escape_objective_spot_2.origin );
	
	wait 1;
	
	//spawn jeep escape enemies
	thread jeep_escape_enemies();
	
	//spawn jeep escape technicals
	thread jeep_escape_technical_wait_for_goto( "jeep_escape_technical_1" , "move_jeep_escape_technical_1" );
	thread jeep_escape_technical_wait_for_goto( "jeep_escape_technical_2" , "move_jeep_escape_technical_2" );
	
	level waittill( "run_objective_spot_3" );
	
	//jeep_escape_objective_spot_3 = getstruct( "jeep_escape_objective_spot_3" , "targetname" );
	//Objective_Position( obj( "obj_rescue" ) , jeep_escape_objective_spot_3.origin );
	
	//level waittill( "run_objective_spot_jeep" );
	
	Objective_OnEntity( obj( "obj_rescue" ) , level.jeep_obj_spot );
	
	level waittill( "player_jumping_in_jeep" );
	
	objective_position( obj( "obj_rescue" ), ( 0, 0, 0 ) );
	
	// This spams the reliable server command buffer and causes crash on PC in shipping (not needed anyway)
	//objective_clearAdditionalPositions( obj( "obj_rescue" ) );
}

check_if_ok_to_delete()
{
	enemies = getaiarray( "axis" );
	foreach ( enemy in enemies )
	{
		if( IsDefined( enemy.script_noteworthy ) && enemy.script_noteworthy == "follow_technical_enemies" )
		{
			continue;
		}
		else
		{
			enemy Delete();
		}
	}
}
		
slide_fx_on( guy )
{
	PlayFXOnTag( guy.dust_fx , guy , guy.dust_fx_tag );
}

slide_fx_off( guy )
{
	StopFXOnTag( guy.dust_fx , guy , guy.dust_fx_tag );
}

rescue_contain_player_enable(enabled)
{
	triggers = GetEntArray("rescue_contain_player_triggers", "script_noteworthy");
	foreach(trigger in triggers)
	{
		if ( enabled )
		{
			trigger trigger_on();
		}
		else
		{
			trigger trigger_off();
		}
	}
	
	if ( enabled )
	{
		level thread rescue_player_contain();
	}
}

rescue_player_contain()
{
	level notify("rescue_player_contain");
	level endon("rescue_player_contain");

	level.player endon("death");
	
	dialog = [];
	// Price: "Yuri, where are you going?"
	dialog = array_add( dialog, "payback_pri_wheregoing" );
	// Price: "Get back here, Yuri!"
	dialog = array_add( dialog, "payback_pri_getbackhere2" );

	// When they get near the crush player spawners, warn them
	level waittill("rescue_player_warn");
	
	dialog_to_play = random( dialog );
	
	level thread radio_dialogue( dialog_to_play );
}

rescue_phantom_trigger_wait()
{
	if ( IsDefined( self.target ) )
	{
		self waittill("trigger");
		phantom_fire_source = GetStructArray( self.target, "targetname" );
		thread phantom_pressure( level.player, "ak47", phantom_fire_source, 0.05, 1.5, 3000, 5000 );
	}
}

// rescue_trigger_fire_rpg - runs on triggers that target magic rpg source and target structs
rescue_trigger_fire_rpg()
{
	// self is a trigger
	self endon("death");
	if ( IsDefined( self.target ) )
	{
		src = getent_or_struct( self.target, "targetname" );
		if ( IsDefined( src ) && IsDefined( src.target ) )
		{
			tgt = getent_or_struct( src.target, "targetname" );
			
			if ( IsDefined( tgt ) )
			{
				self waittill("trigger", triggered_by);
				if ( !IsDefined( self.script_parameters ) || self.script_parameters != "force" )
				{
					// wait for player to not be looking at source location
					while ( VectorDot( VectorNormalize( src.origin - level.player.origin ), AnglesToForward( level.player.angles ) ) > 0.5 )
					{
						wait 0.1;
					}
					magicBullet( "rpg_straight" , src.origin , tgt.origin );
					//tgt thread rescue_fire_magic_rpg( src.origin, tgt.origin );
				}
			}
		}
	}
}

rescue_protect_from_rpg_till( target, eventName, timeout )
{
	repulsor = Missile_CreateRepulsorEnt( target, 25000, 350 );
	
	if ( IsDefined( timeout ) )
	{
		if ( !IsDefined( eventName ) )
		{
			eventName = "rescue_protect_from_rpg_till";
		}
		target thread notify_delay( eventName, timeout );
	}
	
	if ( IsDefined( eventName ) )
	{
		target waittill( eventName );
	}
	else
	{
		return;
	}
	
	Missile_DeleteAttractor( repulsor );
}
