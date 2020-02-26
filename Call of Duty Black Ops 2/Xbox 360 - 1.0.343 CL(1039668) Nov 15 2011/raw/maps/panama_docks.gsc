#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_vehicle;
#include maps\_vehicle_aianim;
#include maps\panama_utility;
#include maps\_objectives;
#include maps\_turret;
#include maps\_dynamic_nodes;

#insert raw\maps\panama.gsh;

//Sets up start for docks on skipto
skipto_docks()
{
	flag_set( "movie_done" );
	start_teleport( "player_skipto_docks" );
}

//Sets up start for sniper event in docks on skipto
skipto_sniper()
{
	start_teleport( "player_skipto_sniper" );
	
	sniper_event();
	betrayed_event();
}

main()
{	
	docks_setup();
	docks_intro();
	jeep_turret_event();	
	elevator_ride();
	sniper_event();
	betrayed_event();
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////**********  SETUP AND FLAGS **********///////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//Performs all setup before fading into the docks
docks_setup()
{
	maps\createart\panama_art::docks();
	
	trigger_off( "docks_entrance_fail_trigger", "targetname" );
	trigger_off( "sniper_turret_trigger", "targetname" );
		
	run_scene_first_frame( "elevator_bottom_open" );
}

//Initializes flags for docks section
init_flags()
{
	flag_init( "docks_battle_one_trigger_event" );
	flag_init( "docks_cleared" );
	flag_init( "docks_entering_elevator" );
	flag_init( "docks_rifle_mounted" );
	flag_init( "docks_kill_menendez" );
	flag_init( "docks_mason_down" );
	flag_init( "docks_betrayed_fade_in" );
	flag_init( "docks_betrayed_fade_out" );
	flag_init( "docks_mason_dead_reveal" );
	flag_init( "docks_final_cin_fade_in" );
	flag_init( "docks_final_cin_fade_out" );
	flag_init( "docks_final_cin_landed1" );
	flag_init( "docks_final_cin_landed2" );
	flag_init( "challenge_nodeath_check_start" );
	flag_init( "challenge_nodeath_check_end" );
}

//***************************************************************************************************************************//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////**********  JEEP TURRET EVENT **********////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//Handles intro cinematic for the docks
docks_intro()
{
	flag_wait( "movie_done" );
	
	//Forcing the spawn to make sure vehicle exists before starting scene "docks_drive_characters", because animation uses it as align object.
	spawn_vehicle_from_targetname( "blackops_jeep_docks" );
	level thread run_scene( "docks_drive" );
	run_scene( "docks_drive_player" );
}

//Handles logic for jeep turret event
jeep_turret_event()
{	
	ai_gate_guard1 = simple_spawn_single( "gate_guard1" );
	ai_gate_guard2 = simple_spawn_single( "gate_guard2" );
	
	ai_gate_guard1 thread force_goal( GetNode( "gate_guard1_cover", "targetname" ), undefined, false );
	ai_gate_guard2 thread force_goal( GetNode( "gate_guard2_cover", "targetname" ), undefined, false );
	
	level thread autosave_by_name( "jeep_turret_start" );
	level thread docks_entrance_fail();
	level.player jeep_unload_player();
	spawn_manager_enable( "wave_one_spawn_manager" );
	waittill_spawn_manager_cleared( "wave_one_spawn_manager" );
	waittill_ai_group_cleared( "docks_wave_one_guards" );
	
	//Short delay after we kill the last enemy on the left side to smooth out transition
	wait 3.0;
	level.player jeep_transition_player();
	
	spawn_manager_enable( "wave_two_spawn_manager" );
	waittill_spawn_manager_cleared( "wave_two_spawn_manager" );
	
	//Short delay after we kill the last enemy on the right side to smooth out transition
	wait 3.0;
	flag_set( "docks_cleared" );
	level.player thread jeep_unlink_player();
}

//Moves player out of jeep, links them in cover on the jeep door for the turret sequence, and handles unlinking the player
//Self is the player
jeep_unload_player()
{
	const n_right_arc = 11;
	const n_left_arc = 55;
	const n_top_arc = 21;
	const n_bottom_arc = 7;
	
	run_scene( "gate_player_unload" );
	
	self.e_jeep_door_mount = Spawn( "script_origin", self.origin );
	self.e_jeep_door_mount.angles = self.angles;
	self PlayerLinkTo( self.e_jeep_door_mount, undefined, 0, n_right_arc, n_left_arc, n_top_arc, n_bottom_arc );
}

//Animates player moving between the first cover position and second cover position on the jeep
//Self is the player
jeep_transition_player()
{		
	const n_right_arc = 77;
	const n_left_arc = 14;
	const n_top_arc = 24;
	const n_bottom_arc = 6;
	
	self Unlink();
	self.e_jeep_door_mount Delete();
	
	run_scene( "jeep_player_transition" );
	
	self.e_jeep_door_mount = Spawn( "script_origin", self.origin );
	self.e_jeep_door_mount.angles = self.angles;
	self PlayerLinkTo( self.e_jeep_door_mount, undefined, 0, n_right_arc, n_left_arc, n_top_arc, n_bottom_arc );
}

//Unlinks player from cover on the jeep
//Self is the player
jeep_unlink_player()
{
	self Unlink();
	self.e_jeep_door_mount Delete();
	
	run_scene( "jeep_player_rifle" );
}

//Handles fail condition for player trying to leave docks through front gate
docks_entrance_fail()
{
	trigger_on( "docks_entrance_fail_trigger", "targetname" );
	trigger_wait( "docks_entrance_fail_trigger" );
	
	fail_player( &"PANAMA_DOCKS_FAIL" );
}

//************************************************************************************************************************************//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////**********  SNIPER EVENT  **********////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//Handles elevator ride up to sniper position
elevator_ride()
{	
	trigger_wait( "elevator_trigger_open" );
	
	run_scene( "elevator_bottom_open" );
	level thread run_scene( "elevator_bottom_open_idle" );
	trigger_wait( "elevator_trigger_interior" );
	
	flag_set( "docks_entering_elevator" );
	run_scene( "elevator_bottom_close" );
	
	//Need to wait for the door to close and then end the scene otherwise the elevator close anim blocks forever
	wait 1.0;
	end_scene( "elevator_bottom_close" );
	
	e_elevator = GetEnt( "docks_elevator", "targetname" );
	e_elevator_move_target = GetStruct( "docks_elevator_move_target", "targetname" );
	
	e_elevator SetMovingPlatformEnabled();
	e_elevator MoveTo( e_elevator_move_target.origin, 3.0 );
	e_elevator waittill( "movedone" );
	
	level thread autosave_by_name( "sniper_start" );
	//level thread run_scene( "elevator_top_open" );
	trigger_wait( "elevator_exit_trigger" );
	
	//level thread run_scene( "elevator_top_close" );
}

//Handles sniper sequence at the end of the docks section
sniper_event()
{	
	trigger_on( "sniper_turret_trigger", "targetname" );
	trigger_wait( "sniper_turret_trigger" );
	
	e_sniper_turret = GetEnt( "barret_turret", "targetname" );
	
	flag_set( "docks_rifle_mounted" );
	run_scene( "mount_sniper_turret" );
	
	//Need to wait a frame after the mount scene, otherwise it breaks the player out of the sniper turret
	wait 0.05;
	e_sniper_turret MakeTurretUsable();
	level thread set_sniper_turret_zoom();
	e_sniper_turret UseBy( level.player );
	level.player DisableTurretDismount();
	e_sniper_aim_target = GetEnt( "sniper_aim_target", "targetname" );
	e_sniper_aim_angles = VectorToAngles( e_sniper_aim_target.origin - level.player.origin );
	level.player lerp_player_view_to_position( level.player.origin, e_sniper_aim_angles, 0.1, 1, 2, 2, 2, 2, false );	
	
	add_spawn_function_group( "sniper_guards", "targetname", ::set_ignoreall, true );
	ai_sniper_guards = simple_spawn( "sniper_guards" );
	level.mason = simple_spawn_single( "mason_prisoner" );
	
	level.mason.team = "axis";
	level.mason magic_bullet_shield();
	array_thread( ai_sniper_guards, ::sniper_guard_damage_fail );
	run_scene( "sniper_walk" );
	flag_set( "docks_kill_menendez" );
	level thread run_scene( "sniper_start_idle" );
	level.mason thread mason_damage_events();
	flag_wait( "docks_mason_down" );
}

//Sets up zoom dvars for sniper turret
set_sniper_turret_zoom()
{
	SetSavedDvar( "cg_fovmin", 3 );
	SetSavedDvar( "turretscopezoom", 7.5 );
	SetSavedDvar( "turretscopezoommax", 7.5 );
	SetSavedDvar( "turretscopezoommin", 3 );
	SetSavedDvar( "turretscopezoomrate", 7 );
}

//Tracks damage events on Mason during the sniper sequence and implementes logic for non-lethal shots
//TODO: Set global game variable (when available) if Mason is left alive
//Self is Mason
mason_damage_events()
{
	self waittill( "damage" );
	
	if( self.damageLocation == "helmet" )
	{
		PlayFxOnTag( GetFX( "mason_fatal_shot" ), self, "j_head" );
	}
	else if( !self is_fatal_shot() )
	{
		run_scene( "sniper_shot" );
		level thread run_scene( "sniper_shot_idle" );
		self waittill( "damage" );
		
		if( self.damageLocation == "helmet" )
		{
			PlayFxOnTag( GetFX( "mason_fatal_shot" ), self, "j_head" );
		}
		else if( !self is_fatal_shot() )
		{
			//Set global game variable for Mason left alive
			/#
				iprintln( "MASON LIVES!!!..." );
			#/
		}
	}
	
	self stop_magic_bullet_shield();
	self ragdoll_death();
	
	//Let the player see the results of the kill
	wait 2.0;
	flag_set( "docks_mason_down" );
	level thread old_man_woods( "mid_flashpoint_2" );
}

//Handles fail condition for player sniping Noriega's guards instead of Mason
//Self is one of the guards leading Mason out
sniper_guard_damage_fail()
{
	level endon( "sniping finished" );
	self waittill( "damage" );
	
	fail_player( &"PANAMA_SNIPER_FAIL" );
}

//Wraps logic for determining whether the shot on Mason was fatal
//Self is Mason
is_fatal_shot()
{
	if( self.damageLocation == "torso_upper" || self.damageLocation == "torso_lower" )
	{
		return true;
	}
	
	return false;
}

//*****************************************************************************************************************************************//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////**********  FINAL CINEMATIC EVENT **********////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//Handles ending cinematic
betrayed_event()
{
	level.noriega = init_hero( "noriega" );
	e_sniper_turret = GetEnt( "barret_turret", "targetname" );
	
	level.player EnableTurretDismount();
	e_sniper_turret UseBy( level.player );
	run_scene_first_frame( "betrayed" );
	
	a_corpses = GetCorpseArray();
	array_delete( a_corpses );
	flag_wait( "movie_done" );
	
	ai_mason = simple_spawn_single( "mason_prisoner" );
	level thread run_scene( "betrayed" );
	level thread run_scene( "betrayed_mason_body" );
	flag_wait( "docks_betrayed_fade_in" );
	flag_wait( "docks_betrayed_fade_out" );
	
	screen_fade_out();
	level thread run_scene( "final_cin_mason" );
	level thread run_scene( "final_cin_player" );
	
	SpawnVehicle( "veh_iw_mh6_littlebird", "final_cin_littlebird1", "heli_littlebird", (0, 0, 1024), (0, 0, 0) );
	level thread run_scene( "final_cin_chopper1" );
	level thread run_scene( "final_cin_seals1_intro_idle" );
	level thread run_scene( "final_cin_skinner_medic" );
	level thread run_scene( "final_cin_pilots1_idle" );
	
	SpawnVehicle( "veh_iw_mh6_littlebird", "final_cin_littlebird2", "heli_littlebird", (0, 0, 1024), (0, 0, 0) );
	level thread run_scene( "final_cin_chopper2" );
	level thread run_scene( "final_cin_seals2_intro_idle" );
	level thread run_scene( "final_cin_seals3" );
	level thread run_scene( "final_cin_pilots2_idle" );
	flag_wait( "docks_final_cin_fade_in" );
	
	level thread screen_fade_in();
	flag_wait( "docks_final_cin_landed1" );
	
	level thread run_scene( "final_cin_seals1_unload" );
	flag_wait( "docks_final_cin_landed2" );
	
	level thread run_scene( "final_cin_seals2_unload" );
	flag_wait( "docks_final_cin_fade_out" );
	
	screen_fade_out();
	flag_set( "challenge_nodeath_check_start" );
	flag_wait( "challenge_nodeath_check_end" );
	
	NextMission();
}

//Handles logic for first damage state during ending cinematic
swap_player_body_dmg1( e_player_body )
{
	MagicBullet( MAGIC_BULLET_ENEMY, level.noriega GetTagOrigin( "tag_flash" ), e_player_body GetTagOrigin( "J_Knee_LE" ) );
	PlayFxOnTag( GetFX( "player_knee_shot" ), e_player_body, "J_Knee_LE" );
	e_player_body SetModel( "c_usa_woods_panama_lower_dmg1_viewbody" );
	flag_set( "docks_mason_dead_reveal" );
}

//Handles logic for second damage state during ending cinematic
swap_player_body_dmg2( e_player_body )
{
	MagicBullet( MAGIC_BULLET_ENEMY, level.noriega GetTagOrigin( "tag_flash" ), e_player_body GetTagOrigin( "J_Knee_RI" )  );
	PlayFxOnTag( GetFX( "player_knee_shot" ), e_player_body, "J_Knee_RI" );
	e_player_body SetModel( "c_usa_woods_panama_lower_dmg2_viewbody" );
}

//****************************************************************************************************************************************//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////