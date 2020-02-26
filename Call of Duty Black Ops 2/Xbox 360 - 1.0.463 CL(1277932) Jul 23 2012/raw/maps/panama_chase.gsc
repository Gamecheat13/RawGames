#include common_scripts\utility;
#include maps\panama_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_turret;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_gameskill;
#include maps\_music;

#insert raw\maps\panama.gsh;

skipto_chase()
{
	level.mason = init_hero( "mason" );
	level.noriega = init_hero( "noriega" );
	a_heroes = array( level.mason, level.noriega );
	
	skipto_teleport("player_skipto_chase", a_heroes);
}

skipto_checkpoint()
{
	level.mason = init_hero( "mason" );
	level.noriega = init_hero( "noriega" );
	a_heroes = array( level.mason, level.noriega );
	
	trigger_off( "checkpoint_end_trigger", "targetname" );
	skipto_teleport("player_skipto_checkpoint", a_heroes);
	
	level.player SetLowReady( true );
	
	level.noriega change_movemode( "sprint" );
	level.noriega SetGoalNode( GetNode( "noriega_checkpoint_cover", "targetname" ) );
	
	level.mason change_movemode( "sprint" );
	level.mason SetGoalNode( GetNode( "mason_checkpoint_cover", "targetname" ) );
	
	flag_set( "movie_done" );
//	checkpoint_event();
}

main()
{	
	level thread chase_dialog();
	chase_setup();
	noriega_rescue_event();
	apache_jump_event();
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////**********  SETUP AND FLAGS **********////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//Performs all setup from second floor clinic to checkpoint
chase_setup()
{
	trigger_off( "noriega_rescue_trigger", "targetname" );
	trigger_off( "checkpoint_end_trigger", "targetname" );
	
	level thread maps\createart\panama3_art::chase();
	
	//Remove collision from doorway leading to Noriega 'hands up' scene
	m_clinic_stairs_blocker = getEnt( "clinic_stairs_blocker", "targetname" );
	m_clinic_stairs_blocker NotSolid();
	
	//Closed door and bookcase against the door at top of clinic stairs start hidden
	m_noriega_bookshelf_door = getEnt( "noriega_bookshelf_door", "targetname" );
	m_noriega_bookshelf_door Hide();
	m_noriega_door_close = getEnt( "noriega_door_closed", "targetname" );
	m_noriega_door_close Hide();
	
	level thread chase_vo();
}

//Initializes flags from second floor clinic to checkpoint
init_flags()
{
	flag_init( "jump_start" );
	flag_init( "chase_player_jumped" );
	flag_init( "clinic_wall_contact" );
	flag_init( "clinic_break_window" );
	flag_init( "chase_rescue_noriega" );
	flag_init( "checkpoint_approach_one" );
	flag_init( "checkpoint_approach_two" );
	flag_init( "checkpoint_reached" );
	flag_init( "checkpoint_cleared" );
	flag_init( "checkpoint_finished" );
	flag_init( "checkpoint_fade_now" );
	flag_init( "start_mason_run" );
}

//*********************************************************************************************************************************//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////**********  APACHE CHASE EVENT **********//////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//Handles logic for Noriega rescue event
noriega_rescue_event()
{
	level.mason SetGoalNode( GetNode( "chase_mason_stairwell_cover", "targetname" ) );
	run_scene_first_frame( "noriega_fight" );
	
	guard_1 = get_ais_from_scene("noriega_fight", "marine_struggler1");
	guard_1 thread check_for_friendly_fire();
	
	guard_2 = get_ais_from_scene("noriega_fight", "marine_struggler2");
	guard_2 thread check_for_friendly_fire();
	
	trigger_wait( "chase_door_trigger" );
	
	
	SetSavedDvar( "r_enableFlashlight", "0" );
	//level thread run_scene( "noriega_fight_mason" );
	//level thread run_anim_to_idle( "noriega_fight", "noriega_hanging" );
	
	level thread clinic_break_wall_think();
	level thread clinic_break_window_think();
	//level.player SetLowReady(true);
	level.player AllowSprint(false);
	//level.player SetMoveSpeedScale(0.4);
	
	level thread maps\_audio::switch_music_wait ("PANAMA_BAD_NORIEGA", 2);
	
	run_scene( "noriega_fight" );
	//run_scene( "noriega_fight_player" );
	
	flag_set( "chase_rescue_noriega" );
	//level.player SetMoveSpeedScale(1);
	level thread run_scene( "dead_soldier_fell" );
	level thread noriega_rescue_timer();
	level thread run_scene( "marine_search_party" );
	
	//Wait a frame for the soldiers to be spawned by the scene system
	wait 0.05;
	playFxOnTag( level._effect["flashlight"], getEnt( "marine_searcher1_ai", "targetname" ), "tag_flash" );
	playFxOnTag( level._effect["flashlight"], getEnt( "marine_searcher2_ai", "targetname" ), "tag_flash" );
	trigger_on( "noriega_rescue_trigger", "targetname" );
	trigger_wait( "noriega_rescue_trigger" );
	
	//stop the spotlight exploder
	
	stop_exploder(106);
	
	level.player AllowSprint(true);
	//First framing here to lerp player view to face Noriega at the start of the animation to hide
	//the bookcase/door swap behind them
	//run_scene_first_frame( "noriega_saved" );
	
	//Wait a couple frames so we don't see the scriptmodel swap
	wait 0.15;
	
	//Swap the bookcases and doors to give illusion that Mason barricaded the door behind the player
	m_clinic_stairs_blocker = getEnt( "clinic_stairs_blocker", "targetname" );
	m_clinic_stairs_blocker Show();
	m_clinic_stairs_blocker Solid();
	m_noriega_door_open = getEnt( "noriega_door_open", "targetname" );
	m_noriega_door_open Hide();
	m_noriega_door_close = getEnt( "noriega_door_closed", "targetname" );
	m_noriega_door_close Show();
	m_noriega_bookshelf_floor = getEnt( "noriega_bookshelf_floor", "targetname" );
	m_noriega_bookshelf_floor Hide();
	m_noriega_bookshelf_door = getEnt( "noriega_bookshelf_door", "targetname" );
	m_noriega_bookshelf_door Show();
	
	level notify( "noriega_rescued" );
	
	//C. Ayers: Moved this into panama_3_anim, triggered off a notetrack
	//level thread maps\_audio::switch_music_wait ("PANAMA_APACHE", 14);
	
	//level thread heli_path_manager();
	end_scene("noriega_falls");
	level thread heli_missile_damage_event_manager();
	level thread jump_fall_fail_think();
	level thread run_scene("noriega_saved_marine");
	level thread run_scene("noriega_saved_irstrobe");
	strobe_model = get_model_or_models_from_scene("noriega_saved_irstrobe", "ir_strobe");
	PlayFXOnTag(level._effect[ "irstrobe_ac130" ], strobe_model, "tag_origin");
	run_scene( "noriega_saved" );
	level thread start_ac130_shooting();
	level thread autosave_by_name( "noriega_help_up" );
	
	
	
}

start_ac130_shooting()
{
	level.player playsound( "evt_panama_chase_gunfire" );
	//wait(1);
	exploder(730);
	level notify("fxanim_ceiling_01_start");
	initial_target = getent("apache_reveal_target", "targetname");
	level thread ac130_shoot(initial_target.origin, true);
	level thread ac130_target_player();
	trigger_wait("apache_strafe_start_trigger");
	second_target = getent("apache_jump_attack_target", "targetname");
	level thread ac130_shoot(second_target.origin, true);
	level notify("fxanim_ceiling_02_start");
	level thread ac130_target_player();
	trigger_wait("chase_go_for_it_trigger");
	level notify("fxanim_ceiling_03_start");
	third_target = getent("apache_missile_target2", "targetname");
	level thread ac130_shoot(third_target.origin, true);
	level thread ac130_target_player();
	trigger_wait( "apache_chase_jump_trigger" );
	level.player thread magic_bullet_shield();
	water_tower_target = getent("apache_missile_target1", "targetname");
	level thread ac130_shoot(water_tower_target.origin, true);
	level notify("player_moved");
}

ac130_target_player()
{
	level notify("player_moved");
	level endon("player_moved");
	
	wait(5);
	while(1)
	{		
		ac130_shoot(level.player.origin, true);
	
	}
}

check_for_friendly_fire()
{
	level endon("noriega_rescued");
	self waittill("damage");
	missionfailedwrapper(&"PANAMA_FRIENDLY_FIRE_FAILURE");
	
}

temp_run_anim_to_idle( str_start_scene, str_idle_scene )
{
	level endon( "player_jumped_first" );
	
	run_scene( str_start_scene );
	level thread run_scene( str_idle_scene );
	
}

//Handles logic for apache jump event from the second floor clinic to burning building
apache_jump_event()
{
	flag_set( "jump_start" );
	
	//Dvar disabling knockback from Apache's cannon, keeping it from pushing the player into the side
	//of the building during the jump
	//SetSavedDvar( "g_knockback", 0.0 );
	//level thread run_scene( "player_look_apache" );
	level thread noriega_jump();

	level thread run_scene("mason_waits_for_jump");
	
	trigger_wait( "player_jump_landing_trigger" );
	level notify( "player_jumped_first" );
	
	end_scene( "dead_soldier_fell" );
	end_scene( "marine_search_party" );
	level thread run_scene( "player_jump_landing" );
	level notify( "chase_jump_cleared" );
	
	//Wait for player to look back and see Mason's epic jump
	//wait 1.25;
	level.player SetLowReady( true );
	level.player.overridePlayerDamage = undefined;//Stop the override here since the apache is no longer valid and can cause a crash if triggered - CP 1/6/11
	end_scene( "noriega_balcony_idle" );
	level.player thread stop_magic_bullet_shield();

	end_scene( "mason_waits_for_jump" );
	run_scene( "mason_balcony_jump" );

	level thread run_scene("mason_noreiga_wall_hug");

	//wait 4.0;
	little_bird = spawn_vehicle_from_targetname( "little_bird_patroller" );
	little_bird_pilot = simple_spawn_single("little_bird_pilots");
	
	little_bird_pilot thread enter_vehicle(little_bird, "tag_driver");
	
	
	little_bird SetDefaultPitch(25);
	little_bird SetSpeed(15);
	PlayFXOnTag(level._effect["apache_spotlight_cheap"], little_bird, "tag_flash");
	water_tower_origin = getent("litte_bird_water_tower_origin", "targetname");
	//little_bird_start_node = GetVehicleNode("little_bird_patrol", "targetname");
	little_bird SetVehGoalPos(water_tower_origin.origin, true);
	little_bird thread look_at_water_tower();
	
	
	//level.noriega SetGoalNode( GetNode( "noriega_checkpoint_cover", "targetname" ) );
	//Wait for player's animation to finish
	
}

look_at_water_tower()
{

	self thread move_little_bird_to_checkpoint();
	self little_bird_investigate_water_tower();
	

	lb_checkpoint_destination = getent("litte_bird_checkpoint_origin", "targetname");
	lb_checkpoint_flyto = getent("litte_bird_checkpoint_destination", "targetname");
	
	lb_lookat = getent("apache_checkpoint_target", "targetname");
	
	
	
	self.origin = lb_checkpoint_destination.origin + (50, 0, 0);
	self.angles = lb_checkpoint_destination.angles;
	self SetTurretTargetEnt( level.player );
	self ClearVehGoalPos();
	self SetVehGoalPos(lb_checkpoint_flyto.origin, true);
	trigger_wait( "checkpoint_reached_trigger" );
	self SetTurretTargetEnt(level.player); 
	
	flag_wait("checkpoint_reached");
	
	wait(2);
	self SetTurretTargetEnt(level.noriega);
	
	wait(7);
	
	lb_checkpoit_goal = getent("litte_bird_checkpoint_goal", "targetname");
	self SetVehGoalPos(lb_checkpoit_goal.origin, true);
	flag_wait("checkpoint_cleared");
	self delete();
	
}

little_bird_investigate_water_tower()
{
	self endon("move_little_bird_in_position");
	
	self waittill("goal");
	
	target1 = getent("apache_spotlight_search_target1", "targetname");
	target2 = getent("apache_spotlight_search_target3", "targetname");
	
	
	lookat = spawn("script_model", target1.origin);
	lookat setmodel("tag_origin");
	
	self SetTurretTargetEnt(lookat);
	lookat MoveTo(target2.origin, 2);
	lookat waittill("movedone");
	
	self ClearTurretTarget();
	
	lb_destination = getent("litte_bird_checkpoint_1", "targetname");
	
	self SetVehGoalPos(lb_destination.origin);
	wait(2);
	

	
}

move_little_bird_to_checkpoint()
{
	trigger_wait("move_little_bird_in_place_trigger");
	self notify("move_little_bird_in_position");
}


//Runs all animations for Noriega's jump. Ends early in case player lands their jump before Noriega finishes his jump anim,
//otherwise he gets stuck in his idle.
noriega_jump()
{
	level endon( "chase_jump_cleared" );
	
	//run_scene( "noriega_runs_from_apache" );
	run_scene( "noriega_balcony_jump" );
	run_scene( "noriega_balcony_idle" );
}

//Handles logic for Noriega breaking through wall during struggle with Marine
clinic_break_wall_think()
{
	flag_wait( "clinic_wall_contact" );
	
	level notify( "fxanim_wall_fall_start" );
	activate_exploder( 710 );
}

//Handles logic for soldier breaking through window during struggle with Noriega
clinic_break_window_think()
{
	s_chase_window_impulse_position = GetStruct( "chase_window_impulse_position", "targetname" );
	ai_firing_soldier = GetEnt( "marine_struggler1_ai", "targetname" );
	
	flag_wait( "clinic_break_window" );
	
	//Takes about 5 shots to actually break the window
	MagicBullet( MAGIC_BULLET_ENEMY, ai_firing_soldier GetTagOrigin( "tag_flash" ), s_chase_window_impulse_position.origin );
	MagicBullet( MAGIC_BULLET_ENEMY, ai_firing_soldier GetTagOrigin( "tag_flash" ), s_chase_window_impulse_position.origin );
	MagicBullet( MAGIC_BULLET_ENEMY, ai_firing_soldier GetTagOrigin( "tag_flash" ), s_chase_window_impulse_position.origin );
	MagicBullet( MAGIC_BULLET_ENEMY, ai_firing_soldier GetTagOrigin( "tag_flash" ), s_chase_window_impulse_position.origin );
	MagicBullet( MAGIC_BULLET_ENEMY, ai_firing_soldier GetTagOrigin( "tag_flash" ), s_chase_window_impulse_position.origin );
}

//Handles fail condition for player not rescuing Noriega in time
noriega_rescue_timer()
{
	level endon( "noriega_rescued" );
	
	//Wait before failing the player for not saving Noriega
	
	//getEnt( "noriega_rescue_trigger", "targetname" ) delete();
	level.noriega stop_magic_bullet_shield();
	level thread run_scene( "noriega_falls" );
	
	wait( 7.0 );

	SetDvar( "ui_deadquote", &"PANAMA_NORIEGA_DEAD_FAIL" );
	level notify( "mission failed" );
	maps\_utility::missionFailedWrapper();
}

//Handles fail condition for if the player falls into the alley between the clinic and burning building
jump_fall_fail_think()
{
	level endon( "chase_jump_cleared" );
	trigger_wait( "apache_jump_fall_trigger" );
	
	level notify( "mission failed" );
	maps\_utility::missionFailedWrapper();
	
	//Wait for player to hit the ground before disabling controls
	wait( 1.0 );
	level.player FreezeControls( true );
}

//Handles fail conditions where the Apache kills the player for hanging around one area for too long
apache_player_kill_timer( n_time, v_offset, do_target_player )
{
	level endon( "stop_kill_timer" );
	wait( n_time );
	
	if( do_target_player )
	{
		self SetLookAtEnt( level.player );
		wait( 1.0 );
	}
	
	self thread shoot_turret_at_target( level.player, 120, v_offset, 0 );
}

//Handles applying damage to the player from the Apache
apache_player_damage_callback( eInflictor, eAttacker, iDamage, iDFlags, type, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	e_apache = getEnt( "attack_apache", "targetname" );
	
	//If the player is hit by the Apache's cannon and either hasn't been hit before or was hit more than 0.5 seconds ago,
	//then apply 0 damage and show the damage indicator (i.e. show some fake damage to keep the intensity up). Player takes
	//no damage as long as they're sprinting.
	if ( (!IsDefined( level.player.n_previous_damage_time ) || (level.player isSprinting() && (getTime() - level.player.n_previous_damage_time) > 500)) && eAttacker == e_apache )
	{
		level.player.n_previous_damage_time = getTime();
		iDamage = 0;
		showDamage = true;
	}
	//If the player is hit by the Apache, but it's been less than 0.5 seconds since the last hit, then do 0 damage,
	//but don't show the damage indicator (i.e. don't want the player's screen to go completely red so they can't see).
	//Player takes no damage as long as they're sprinting.
	else if ( level.player isSprinting() && eAttacker == e_apache )
	{
		iDamage = 0;
		showDamage = false;
	}
	//Player is not sprinting and was hit by the Apache, so do massive damage to them.
	else if ( eAttacker == e_apache )
	{
		iDamage = 80;
		showDamage = true;
	}
	//Failsafe for player taking damage from sources other than the Apache (e.g. fall damage on the jump)
	else
	{
		iDamage = 0;
		showDamage = true;
	}
	
	if ( showDamage == false )
	{
		self clearDamageIndicator();
	}
	return iDamage;
}

//Plays VO for chase
chase_vo()
{
	trigger_wait( "chase_door_trigger" );
	
	//Temp vo for missing lines
	/#
		iPrintlnBold( "US Soldier: Hands up!" );
		wait 1.0;
		iPrintlnBold( "Noriega: Don't shoot!" );
		wait 1.0;
		iPrintlnBold( "US Soldier: ...it's Noriega. Hey, we got him!" );
	#/
	
	trigger_wait( "chase_go_for_it_trigger" );
	
	level.mason say_dialog( "go_for_it_woods_027" );
	trigger_wait( "chase_jump_vo_trigger" );
	
	level.mason say_dialog( "jump_028" );
}

//Plays VO for checkpoint approach
checkpoint_approach_vo()
{
	trigger_wait( "checkpoint_vo_trigger" );
	
	level.player say_dialog( "mason_001" );
	level.mason say_dialog( "hudson__where_the_002", 0.5 );
	level.player say_dialog( "are_you_at_the_che_003", 1.0 );
}

//*********************************************************************************************************************************//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////**********  CHECKPOINT EVENT **********//////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//Handles logic for the checkpoint cinematic
checkpoint_event()
{	
	flag_set( "checkpoint_approach_one" );
	
	level thread run_scene( "checkpoint_start_idle_guards" );
	level thread run_scene( "gate2_guards" );
	level thread run_scene( "checkpoint_triage" );
	level thread run_scene( "checkpoint_sitgroup" );
	level thread run_scene( "checkpoint_soldiers_resting" );
	
	level thread checkpoint_approach_vo();
	trigger_wait( "checkpoint_approach_trigger" );
	
	flag_set( "checkpoint_approach_two" );
	level thread run_scene( "checkpoint_patrol1" );
	level thread run_scene( "checkpoint_patrol2" );
	level thread run_anim_to_idle( "checkpoint_patrol3", "checkpoint_patrol3_idle" );
	

	//level thread run_scene( "checkpoint_lineup" );
	level thread run_scene( "checkpoint_tieup" );
	
	level thread run_scene( "checkpoint_tieup_soldier3" );
	trigger_wait( "checkpoint_reached_trigger" );
	level thread maps\createart\panama3_art::checkpoint();
	flag_set( "checkpoint_reached" );
	//end_scene("checkpoint_start_idle_guards");
	level thread run_scene("checkpoint_player_walkout");
	level thread run_scene( "checkpoint_ally_walkout" );
	level.player SetMoveSpeedScale(0.4);
	level.player AllowSprint(false);
	//flag_wait( "checkpoint_fade_now" );
	
	wait(5);
	end_scene("checkpoint_player_walkout");
	
	scene_wait("checkpoint_ally_walkout");
	//TODO: This is a temp wait until we can address the timing of this scene correctly
//	wait 21;
	
	flag_set( "checkpoint_cleared" );
	
	flag_set( "checkpoint_finished" );
	level notify( "stop_speed_think" );
	//level thread old_man_woods( "old_woods_3" );
	old_man_woods( "old_woods_3" );
	level.player SetMoveSpeedScale(1);
	level.player SetLowReady( false );
	level.player AllowSprint( true );
	//level.player.overridePlayerDamage = undefined;//Moved to apache_jump_event() to fix potential crash - CP 1/6/11
	
	end_scene( "gate2_guards" );
	end_scene( "checkpoint_triage" );
	end_scene( "checkpoint_sitgroup" );
	end_scene( "checkpoint_soldiers_resting" );
	end_scene( "checkpoint_patrol3_idle" );
	
	//TODO: These idles are never reached, now.  Ending the previous animations which have been setup to delete their AI.
	//end_scene( "checkpoint_lineup_idle" );
	//end_scene( "checkpoint_tieup_idle" );
	//TODO: Temporary until timing of this scene can be addressed properly.
	end_scene( "checkpoint_lineup" );
	end_scene( "checkpoint_tieup" );
	
	//end_scene( "checkpoint_stop_idle_guard1" );
	
	//TODO: These idles are never reached, now.  Ending the previous animations which have been setup to delete their AI.
	//end_scene( "checkpoint_end_idle_guard2" );
	//end_scene( "checkpoint_stop_idle_allies" );
	//TODO: Temporary until timing of this scene can be addressed properly.
	end_scene( "checkpoint_advance_guard2" );
	end_scene( "checkpoint_ally_walkout" );
	
	ClearAllCorpses();
	//load_gump( "panama_gump_4" );
}

//Runs checkpoint guard 2's anims for player passing through the barricade
checkpoint_passthrough()
{
	run_anim_to_idle( "checkpoint_advance_guard2", "checkpoint_stop_idle_guard2" );
	trigger_wait( "checkpoint_passthrough_trigger" );
	
	run_anim_to_idle( "checkpoint_cleared_guard2", "checkpoint_end_idle_guard2" );
}

//*********************************************************************************************************************************//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////**********  APACHE FLIGHT LOGIC **********//////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//Handles logic for Apache's flight paths through the chase and escape events
heli_path_manager()
{
	//Spawn, setup apache with blinking lights, initial speed, and no damage. Send to starting position.
	e_apache = spawn_vehicle_from_targetname( "attack_apache" );
	PlayFXOnTag( GetFx( "apache_exterior_lights" ), e_apache, "tag_origin" );
	s_apache_strafe_start = getStruct( "apache_strafe_start", "targetname" );
	e_apache godOn();
	e_apache SetSpeed( 20.0 );
	e_apache thread heli_go_struct_path( getStruct( "apache_attack_start", "targetname" ) );
	
	//Rotate Apache during reveal to face player and position to turn spotlight on
	e_target = getEnt( "apache_reveal_target", "targetname" );
	e_apache setLookAtEnt( e_target );
	e_apache set_turret_target( e_target, undefined, 0 );
	e_apache thread set_pitch( 0, 20, 1 );
	e_apache waittill( "path_finished" );
	
	//Wait for Apache reveal to player
	wait 2.0;
	
	//Turn on spotlight
	e_apache_barrel = spawn_model( "tag_origin", e_apache GetTagOrigin( "tag_barrel" ), e_apache GetTagAngles( "tag_barrel" ) );
	e_apache_barrel LinkTo( e_apache, "tag_barrel" );
	PlayFXOnTag( GetFX( "apache_spotlight" ), e_apache_barrel, "tag_origin" );
	e_apache thread heli_go_struct_path( s_apache_strafe_start );
	e_apache waittill( "path_finished" );
	
	//Set deadquote to give players a hint if they fail the chase
	SetDvar( "ui_deadquote", &"PANAMA_APACHE_ESCAPE_FAIL" );
	
	//Apache starts tracking the player for chase sequence
	level.player.overridePlayerDamage = ::apache_player_damage_callback;
	e_apache setLookAtEnt( level.player );
	e_apache set_turret_target( level.player, undefined, 0 );
	e_apache SetSpeed( 20.0 );
	e_apache thread apache_player_kill_timer( 15.0, undefined, false );
	trigger_wait( "apache_strafe_start_trigger" );
	
	level notify("helicopter_hallway_start");
	//When player enters hallway start the strafing run and cancel fail condition for player not running
	level notify( "stop_kill_timer" );
	e_apache thread shoot_turret_at_target( level.player, 2000.0, (0, 0, 0), 0 );
	e_apache thread heli_strafe_follow_player( s_apache_strafe_start, 512.0 );
	trigger_wait( "apache_chase_jump_trigger" );
	
	//Cut the Apache's cannon off once player has made the jump
	flag_set( "chase_player_jumped" );
	e_apache stop_turret( 0 );
	e_apache clearLookAtEnt();
	e_apache clear_turret_target( 0 );
	
	//Wait a frame for the thread sending the Apache to follow the player to end
	wait 0.05;
	
	//Setup Apache to fire missiles on Mason's jump
	e_apache setLookAtEnt( GetEnt( "apache_jump_attack_target", "targetname" ) );
	e_apache SetSpeed( 60.0, 60.0, 60.0 );
	e_apache thread heli_go_struct_path( GetStruct( "jump_missile_fire_position_start", "targetname" ) );
	e_apache waittill( "path_finished" );
	
	//Fire the missiles
	e_apache SetSpeed( 30.0 );
	e_apache shoot_turret_at_target_once( getEnt( "apache_missile_target1", "targetname" ), undefined, 1 );
	e_apache shoot_turret_at_target_once( getEnt( "apache_missile_target2", "targetname" ), undefined, 2 );
	e_apache clear_turret_target( 1 );
	e_apache clear_turret_target( 2 );
	
	//Setup targets for Apache scanning their spotlight outside the player's building
	e_spotlight_search_target1 = GetEnt( "apache_spotlight_search_target1", "targetname" );
	e_spotlight_search_target2 = GetEnt( "apache_spotlight_search_target2", "targetname" );
	e_spotlight_search_target3 = GetEnt( "apache_spotlight_search_target3", "targetname" );
	
	//Position Apache for spotlight scan
	e_apache SetSpeed( 60.0 );
	e_apache thread heli_go_struct_path( GetStruct( "apache_spotlight_search_start", "targetname" ) );
	e_apache SetLookAtEnt( e_spotlight_search_target1 );
	e_apache set_turret_target( e_spotlight_search_target1, undefined, 0 );
	e_apache waittill( "path_finished" );
	
	//Delay to start search after player watches watertower collapse
	wait 3.0;
	
	e_apache SetLookAtEnt( e_spotlight_search_target2 );
	e_apache set_turret_target( e_spotlight_search_target2, undefined, 0 );
	
	//Timing out apache search
	wait 1.0;
	
	e_apache set_turret_target( e_spotlight_search_target3, undefined, 0 );
	
	//Delay before Apache withdraws to checkpoint
	wait 2.0;
	
	//Apache withdraws and waits at the checkpoint
	e_apache_checkpoint_target = GetEnt( "apache_checkpoint_target", "targetname" );
	e_apache_barrel delete();
	e_apache ClearLookAtEnt();
	e_apache clear_turret_target( 0 );
	e_apache thread heli_go_struct_path( GetStruct( "apache_checkpoint_wait_position", "targetname" ) );
	
	//Wait until Apache is out of view to set new look target for checkpoint
	wait 2.0;
	
	//Set look target for Apache at the checkpoint and setup to turn spotlight back on
	e_apache SetLookAtEnt( e_apache_checkpoint_target );
	e_apache set_turret_target( e_apache_checkpoint_target, undefined, 0 );
	e_apache_barrel = spawn_model( "tag_origin", e_apache GetTagOrigin( "tag_barrel" ), e_apache GetTagAngles( "tag_barrel" ) );
	e_apache_barrel LinkTo( e_apache, "tag_barrel" );
	trigger_wait( "checkpoint_reached_trigger" );
	
	//Turn spotlight on player as they come into the checkpoint
	PlayFXOnTag( GetFX( "apache_spotlight" ), e_apache_barrel, "tag_origin" );
	
	//Delay before sending Apache to delete offscreen
	wait 4.0;
	
	//Apache flys offscreen and deletes
	e_apache_barrel delete();
	e_apache ClearLookAtEnt();
	e_apache clear_turret_target( 0 );
	e_apache thread heli_go_struct_path( GetStruct( "apache_delete_position", "targetname" ) );
	e_apache waittill( "path_finished" );
	
	e_apache delete();
}

//Sets helicopter to follow a set distance behind the player for the main chase sequence
//Self is the helicopter
heli_strafe_follow_player( s_start_position, n_distance )
{
	while( !flag( "chase_player_jumped" ) )
	{
		wait 0.05;
		self SetVehGoalPos( (s_start_position.origin[0], level.player.origin[1] - n_distance, s_start_position.origin[2]), false, false );
	}
}

//Handles missile damage events during Apache's flight paths
heli_missile_damage_event_manager()
{
	water_tower = getent("ac130_water_tower", "targetname");
	trigger_wait( "apache_chase_jump_trigger" );
	level notify( "fxanim_water_tower_start" );
	wait(0.05);
	water_tower = getent("ac130_water_tower", "targetname");
	PlayFXOnTag(level._effect["fx_pan_water_tower_collapse"], water_tower, "base_jnt");
	activate_exploder( 700 );
}

//Flight logic for Apache following struct paths in radiant
heli_go_struct_path( s_start )
{
	s_current = s_start;
	self.is_pathing = true;
	
	self setHoverParams( 10 );
	
	while ( self.is_pathing )
	{
		if ( IsDefined( s_current.target ) )
		{
			self setVehGoalPos( s_current.origin, false, false );
		}
		else
		{
			self setVehGoalPos( s_current.origin, true, false );
		}
		
		if ( IsDefined( s_current.radius ) )
		{
			self setNearGoalNotifyDist( s_current.radius );
		}
		
		self waittill( "near_goal" );
		
		if ( IsDefined( s_current.speed ) )
		{
			self setSpeed( s_current.speed );
		}
		
		self waittill( "goal" );
		
		if ( IsDefined( s_current.target ) )
		{
			s_current = getStruct( s_current.target, "targetname" );
			assert( IsDefined( s_current ), "Target entity is not a struct or is undefined: " + s_current.targetname );
		}
		else
		{
			self.is_pathing = false;
		}
	}
	
	self notify( "path_finished" );
}

//Interpolates setting Apache's pitch manually
set_pitch( n_start_pitch, n_end_pitch, n_time )
{
	n_step_time = 0.05;
	
	n_steps = n_time / n_step_time;
	n_pitch_range = n_end_pitch - n_start_pitch;
	
	n_pitch_step = 0;
	if ( n_steps > 0 )
	{
		n_pitch_step = abs( n_pitch_range ) / n_steps;
	}
	
	n_current_pitch = n_start_pitch;
	while ( n_current_pitch != n_end_pitch )
	{
		wait( n_step_time );
		
		if ( n_pitch_range > 0 )
		{
			n_current_pitch = min( n_current_pitch + n_pitch_step, n_end_pitch );
		}
		else if ( n_pitch_range < 0 )
		{
			n_current_pitch = max( n_current_pitch - n_pitch_step, n_end_pitch );
		}
		
		self setDefaultPitch( n_current_pitch );
	}
}

//*********************************************************************************************************************************//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
chase_dialog()
{
	
	trigger_wait("chase_door_trigger");
	level.mason say_dialog("maso_awww_shit_0");
	
//	level.noriega say_dialog("sold_do_not_fucking_move_0");
//	level.noriega say_dialog("sold_hands_where_i_can_se_0", 1);
//	level.noriega say_dialog("sold_is_this_who_i_think_0");
	
	scene_wait("noriega_fight");
	
	level.player say_dialog("reds_shit_we_got_a_man_0");
	level.player thread say_dialog("reds_holy_shit_0");
	level.player say_dialog("reds_where_d_he_come_from_0");
	level.player say_dialog("reds_up_there_on_the_led_0");
	
	trigger_wait("noriega_rescue_trigger");
	
	
	wait(2);
	
	level.player say_dialog("Fuck! They went back into the building!");
	level.player say_dialog("reds_spooky_1_2_immediate_0");
	level.player say_dialog("reds_everyone_clear_out_0");
	
//	wait(5);
//	
//	level.mason say_dialog("maso_aww_fuck_gotta_mo_0");

	
}