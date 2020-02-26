#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\_objectives;
#include maps\yemen_utility;


/* ------------------------------------------------------------------------------------------
	INIT functions
-------------------------------------------------------------------------------------------*/

//	event-specific flags
init_flags()
{
	flag_init( "soldiers_sniped" );
	flag_init("menendez_captured");
	
	//Objective flags
	flag_init( "obj_capture_sitrep" );
//	flag_init( "obj_capture_rockarch" );
	flag_init( "obj_capture_menendez" );
}

//	event-specific spawn functions
init_spawn_funcs()
{
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/

//	skip-to only initialization (not run if this event skip-to isn't used)
skipto_capture()
{
	skipto_setup();
	
	start_teleport( "skipto_capture_player" );
	
	if( IsDefined(level.salazar))
	{
		//teleport existing salazar
	}
	else
	{
		//spawn one for testing
		sp_salazar = GetEnt("skipto_capture_salazar_spawn", "targetname");
    	level.salazar = simple_spawn_single(sp_salazar);
	}
}


/* ------------------------------------------------------------------------------------------
	MAIN functions 
-------------------------------------------------------------------------------------------*/

//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//		your skipto sequence will be called.
main()
{
	/#
		IPrintLn( "Table for One" );
	#/

		flag_set( "obj_capture_sitrep" );
	
		level.sniper_position = GetStruct("s_capture_sniper_rifle");
//		level.sniper_position_alwayshit = GetStruct("s_capture_sniper_rifle_alwayshit");		
		
		level thread capture_guys_retreat();
		level thread capture_guys_blindfire();
		level thread capture_crashed_drones();
		level thread capture_spawn_allies();
		level thread capture_sitrep();
		level thread capture_salazar_move();
		level thread capture_salazar_stop();
//		level thread capture_update_breadcrumb_to_vtol();
		level thread capture_menendez_taunt();
		level thread capture_run_and_die();
		level thread capture_sniper_death();
		level thread capture_near_miss_sniper_shot();
		level thread capture_sniper_ground_shot();
		level thread capture_menendez_surrenders();
}


/* ------------------------------------------------------------------------------------------
	EVENT functions
-------------------------------------------------------------------------------------------*/

capture_crashed_drones()
{
	s_drone1 = GetStruct("s_capture_crashed_drone1", "targetname");
	s_drone2 = GetStruct("s_capture_crashed_drone2", "targetname");
	//m_drone = GetEnt("m_capture_crashed_drone1", "targetname");
	PlayFx(level._effect["fire"], s_drone1.origin);
	PlayFx(level._effect["fire"], s_drone2.origin);
}

capture_spawn_allies()
{
	level.snipeDead = 0;
	
	
	autosave_by_name( "capture_start" );
		
	trigger_wait("trig_capture_guys_spawn");
	
	IPrintLnBold( "You hear sniper shots and the sounds of drones firing." );
		
	sp_sitrepguy = GetEnt( "capture_sitrep_guy", "targetname" );
	
	simple_spawn_single( sp_sitrepguy );
	
	//Retreat guys
	simple_spawn_single( "sp_capture_retreat_guy1" );
	simple_spawn_single( "sp_capture_retreat_guy2" );
	simple_spawn_single( "sp_capture_retreat_guy3" );
	
	//Custom sniper death guys
	simple_spawn_single( "soldier_stand_sniped_1" );
	simple_spawn_single( "soldier_stand_sniped_2" );
	simple_spawn_single( "soldier_crouch_sniped_1" );
	simple_spawn_single( "soldier_crouch_sniped_2" );
	simple_spawn_single( "soldier_crouch_sniped_3" );
	simple_spawn_single( "soldier_crouch_sniped_4" );
	simple_spawn_single( "soldier_run_sniped_1" );
	simple_spawn_single( "soldier_run_sniped_2" );
	simple_spawn_single( "soldier_run_sniped_3" );
	
	//Generic sniper deaths guys
	ai_first_guy = GetEnt( "capture_second_guy_left", "targetname" );
	ai_first_guy add_spawn_function(::capture_menendez_snipekill_death_listener);
	simple_spawn_single( ai_first_guy );
	
	ai_second_guy = GetEnt( "capture_cover_guy_wall", "targetname" );
	ai_second_guy add_spawn_function(::capture_menendez_snipekill_death_listener);
	simple_spawn_single( ai_second_guy );
	
	simple_spawn_single( "capture_steps_guy" );
	simple_spawn_single( "capture_second_guy_right" );
	simple_spawn_single( "capture_rockarch_guy" );
	//simple_spawn_single( "capture_guy_left_cover" );
	simple_spawn_single( "capture_guy_mid_left" );
	//simple_spawn_single( "capture_guy_end_cover" );
	//simple_spawn_single( "capture_cover_guy_wall_end" );
	//simple_spawn_single( "capture_mid_guy_end" );
	simple_spawn_single( "capture_second_guy_right" );
	//simple_spawn_single( "capture_cover_guy_wall_rockarch" );
	simple_spawn_single( "capture_first_guy_buddy" );
	simple_spawn_single( "capture_guy_right_cover" );
	simple_spawn_single( "capture_cover_guy_left_wall" );
	
//	simple_spawn_single( "menendez" );
//	level thread capture_objective_failed();	
	
	s_closecall = GetStruct("s_sniper_shot_miss");
		
	//Sniper Ambient
	MagicBullet( "deserttac_sp", level.sniper_position.origin, s_closecall.origin );
	wait 1;
	MagicBullet( "deserttac_sp", level.sniper_position.origin, s_closecall.origin );
	wait 0.5;
	MagicBullet( "deserttac_sp", level.sniper_position.origin, s_closecall.origin );
	wait 1;
	MagicBullet( "deserttac_sp", level.sniper_position.origin, s_closecall.origin );
} 

capture_guys_retreat()
{
	trigger_wait("trig_capture_guys_retreat_event" );
	
	ai_guy_run_shot = GetEnt( "sp_capture_retreat_guy3_ai", "targetname" );
	ai_guy_run_escape = GetEnt( "sp_capture_retreat_guy2_ai" , "targetname" );
	
	nd_guy_run_shot = GetNode( "nd_capture_guy_retreat_shot", "targetname" );
	nd_guy_run_escape = GetNode( "nd_capture_guy_escape", "targetname" );
	
	nd_guy_run_shot set_goalradius(46);
	nd_guy_run_escape set_goalradius(128);
	ai_guy_run_shot SetGoalNode( nd_guy_run_shot );
	ai_guy_run_escape SetGoalNode( nd_guy_run_escape );
	
	ai_guy_run_shot waittill("goal");
	wait 1.5;//trying to figure out what is wrong
	MagicBullet( "deserttac_sp", level.sniper_position.origin,ai_guy_run_shot.origin );
	ai_guy_run_shot bloody_death();
}

capture_guys_blindfire()
{
	trigger_wait("trig_capture_guys_retreat_event" );
	
	ai_guy_blindfire = GetEnt( "sp_capture_retreat_guy1_ai", "targetname" );

	trig_shootat = GetEnt( "trig_capture_shootat", "targetname" );
	ai_guy_blindfire shoot_at_target(trig_shootat, undefined, 0.25, 5);
}

//First guy tells you about the situation
capture_sitrep()
{
	trigger_wait("trig_sitrep");
	
	IPrintLnBold( "Soldier: Hey, are you nuts! Don't go out there. There is a sniper in the VTOL." );
	IPrintLnBold( "Mason: I've got this soldier." );
	
	s_closecall = GetStruct("s_sniper_shot_miss");
	
	PlayFX( level._effect["sniper_glint"], level.sniper_position.origin,  s_closecall.origin );
	
//	flag_set( "obj_capture_rockarch" );//change objective marker
	flag_set( "obj_capture_menendez" );	
	//scene for soldier pulling us in
	run_scene( "soldier_sitrep" );
	
	//TODO: clean this up, get rid of magic numbers
	//Sniper Ambient
	MagicBullet( "deserttac_sp", level.sniper_position.origin, level.player.origin );
	wait 1;
	MagicBullet( "deserttac_sp", level.sniper_position.origin, s_closecall.origin );
	wait 1.2;
	MagicBullet( "deserttac_sp", level.sniper_position.origin, s_closecall.origin );
	wait 1;
	MagicBullet( "deserttac_sp", level.sniper_position.origin, s_closecall.origin );
	
//	s_menendez_capture = GetStruct( "s_breadcrumb_rockarch", "targetname" );
//	set_objective( level.OBJ_CAPTURE_MENENDEZ, s_menendez_capture.origin, "breadcrumb" );
	//scene_wait( "soldier_sitrep" );
}  

//Salazar moves
capture_salazar_move()
{
	a_run_triggers = GetEntArray("trig_salazar_goal_move", "targetname");
	array_thread(a_run_triggers, ::capture_salazar_move_think);
}

capture_salazar_move_think()
{
	self waittill("trigger");
	nd_goal = GetNode( self.target, "targetname" );
	level.salazar set_goalradius(128);
	level.salazar SetGoalNode( nd_goal );
	
	PlayFX( level._effect["sniper_glint"], level.sniper_position.origin,  level.sniper_position.angles );
}

//capture_salazar_stop
capture_salazar_stop()
{	
	//level.player magic_bullet_shield();
	
	trigger_wait("trig_capture_mason_tell_salazar_stop");
	IPrintLnBold( "Mason: Salazar, wait here." );
	
	PlayFX( level._effect["sniper_glint"], level.sniper_position.origin, level.sniper_position.angles );
}

////Updates marker to VTOL
//capture_update_breadcrumb_to_vtol()
//{
//	trigger_wait("trig_capture_update_breadcrumb");
//	
////	flag_set( "obj_capture_menendez" );
////	s_menendez_capture = getstruct( "s_breadcrumb_vtol", "targetname" );
////	set_objective( level.OBJ_CAPTURE_MENENDEZ, s_menendez_capture.origin, "breadcrumb" );
//}

//Menendez taunts Mason
capture_menendez_taunt()
{
	a_run_triggers = GetEntArray("trig_capture_menendez_taunts", "targetname");
	array_thread(a_run_triggers, ::capture_menendez_taunt_think);
}

capture_menendez_taunt_think()
{
	self waittill("trigger");
	
	IPrintLnBold( "Menendez: (Taunting Mason about loss of life)" );
}

//Generic sniper deaths
capture_run_and_die()
{
	a_run_triggers = GetEntArray("trig_capture_run_and_die", "targetname");
	array_thread(a_run_triggers, ::capture_run_and_die_think);
}

capture_run_and_die_think()
{
	self waittill("trigger");
	
	ai_redshirt = GetEnt( self.target + "_ai", "targetname" );
	
	//just_die - ally doesn't run before death
	if(ai_redshirt.script_noteworthy != "just_die")
	{
		nd_goal = GetNode( ai_redshirt.script_noteworthy, "targetname" );
	
		ai_redshirt set_goalradius(128);
		ai_redshirt SetGoalNode( nd_goal );
		ai_redshirt waittill("goal");
		
		level.sniper_position = GetStruct("s_capture_sniper_rifle");
//		MagicBullet( "avenger_side_minigun", level.sniper_position.origin, ai_redshirt.origin );
		MagicBullet( "deserttac_sp", level.sniper_position.origin, ai_redshirt.origin );
		
		PlayFX( level._effect["dirthit_libya"], ai_redshirt.origin );
		PlayFX( level._effect["sniper_glint"], level.sniper_position.origin,  level.sniper_position.angles );
		ai_redshirt bloody_death();
	}
	else
	{
		wait .25;//pause before firing
		
		level.sniper_position = GetStruct("s_capture_sniper_rifle");
//		MagicBullet( "avenger_side_minigun", level.sniper_position.origin, ai_redshirt.origin );
		MagicBullet( "deserttac_sp", level.sniper_position.origin, ai_redshirt.origin );
		
		PlayFX( level._effect["sniper_glint"], level.sniper_position.origin,  level.sniper_position.angles );
		PlayFX( level._effect["dirthit_libya"], ai_redshirt.origin );
		ai_redshirt bloody_death();
	}
}

//Custom sniper deaths
capture_sniper_death()
{
	a_run_triggers = GetEntArray("trig_sniped", "targetname");
	array_thread(a_run_triggers, ::capture_sniper_death_think);
}

capture_sniper_death_think()
{
	self waittill("trigger");
	
	ai_sniped = GetEnt( self.target  + "_ai", "targetname" );
	
	run_scene( ai_sniped.script_noteworthy );
	//wait 0.5;
	ai_sniped bloody_death();
}

//Menendez fires near player
capture_near_miss_sniper_shot()
{
	a_run_triggers = GetEntArray("trig_capture_player_shock", "targetname");
	array_thread(a_run_triggers, ::capture_near_miss_sniper_shot_think);
}

capture_near_miss_sniper_shot_think()
{	
	self waittill("trigger");
	
//	level.player FreezeControls(true);
//	
	//level.player shellshock("default", 1);
	
	//MagicBullet( "avenger_side_minigun", level.sniper_position.origin, level.player.origin );
	MagicBullet( "deserttac_sp", level.sniper_position.origin, level.player.origin );
	//MagicBullet( "avenger_side_minigun",level.sniper_position_alwayshit.origin, level.player.origin );
//	MagicBullet( "deserttac_sp", level.sniper_position_alwayshit.origin, level.player.origin );
	
	PlayFX( level._effect["sniper_glint"], level.sniper_position.origin,  level.sniper_position.angles );

	m_impact_fx = Spawn( "script_model", (0, 0, 0) );
	m_impact_fx SetModel( "tag_origin" );
	 
	//PlayFXOnTag( level._effect["fx_overlay_decal"], m_drone_controller_fx, "tag_origin" );
	PlayFX( level._effect["dirthit_libya"], level.player.origin );
	
//	wait .25;
	
//	overlay = NewHudElem();
//	overlay SetShader( "fullscreen_dirt_bottom", 15, 15 );


	//IPrintLnBold( "Near miss" );
//	level.player FreezeControls(false);
}

//trig_capture_sniper_ground_hit
//Menendez fires at the ground
capture_sniper_ground_shot()
{
	a_run_triggers = GetEntArray("trig_capture_sniper_ground_hit", "targetname");
	array_thread(a_run_triggers, ::capture_sniper_ground_shot_think);
}

capture_sniper_ground_shot_think()
{	
	self waittill("trigger");
	
//	level.player FreezeControls(true);
//	
	//level.player shellshock("default", 1);
	
	s_target = GetStruct( self.target, "targetname" );
	
//	MagicBullet( "avenger_side_minigun", level.sniper_position.origin, s_target.origin );
	MagicBullet( "deserttac_sp", level.sniper_position.origin, s_target.origin );
	//MagicBullet( "avenger_side_minigun",level.sniper_position_alwayshit.origin, level.player.origin );
//	MagicBullet( "deserttac_sp", level.sniper_position_alwayshit.origin, s_target.origin );
	
	PlayFX( level._effect["sniper_glint"], level.sniper_position.origin,  level.sniper_position.angles );

	m_impact_fx = Spawn( "script_model", (0, 0, 0) );
	m_impact_fx SetModel( "tag_origin" );
	 
	//PlayFXOnTag( level._effect["fx_overlay_decal"], m_drone_controller_fx, "tag_origin" );
	PlayFX( level._effect["dirthit_libya"], s_target.origin );
	
//	wait .25;
	
//	overlay = NewHudElem();
//	overlay SetShader( "fullscreen_dirt_bottom", 15, 15 );


	//IPrintLnBold( "Near miss" );
//	level.player FreezeControls(false);
}

//Menendez captured
capture_menendez_surrenders()
{
	trigger_wait("trig_capture_menendez_surrenders");
	
	set_objective( level.OBJ_CAPTURE_MENENDEZ, undefined, "done" );
	set_objective( level.OBJ_CAPTURE_MENENDEZ, undefined, "delete" );
	
	run_scene( "surrender_menendez" );
	
	flag_set("menendez_captured");
	
	NextMission();
}

capture_sniper_shoot()
{
//	MagicBullet( "deserttac_sp", level.sniper_position.origin, s_target.origin );
}

////Menendez capture failed - in case we allow player to shoot him and fail the mission
//capture_objective_failed()
//{
//	menendez = GetEnt("menendez_ai", "targetname");
//	menendez waittill("death");
//	
//	//set_objective( level.OBJ_CAPTURE_FAIL );
//	
//	setDvar( "ui_deadquote", &"OBJ_CAPTURE_FAIL" );
//	MissionFailed();
//}

/* ------------------------------------------------------------------------------------------
	CHALLENGE functions
-------------------------------------------------------------------------------------------*/
//less than 5 get sniped
capture_menendez_snipekill_death( str_notify )
{
	flag_wait( "soldiers_sniped" );
}

capture_menendez_snipekill_death_listener()
{
	self waittill ( "death" );
	//iprintlnbold( "SNIPED" );
	level.snipeDead++;
	
	if(level.snipeDead >= 5)
	{
		flag_set("soldiers_sniped");
		IPrintLnBold( "flag set" );
	}
			
}