#include common_scripts\utility;
#include maps\panama_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_turret;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_gameskill;

skipto_chase()
{
	skipto_setup();
	level.mason = init_hero( "mason" );
	level.noriega = init_hero( "noriega" );
	a_heroes = array( level.mason, level.noriega );
	
	start_teleport("player_skipto_chase", a_heroes);
}

skipto_checkpoint()
{
	skipto_setup();
	level.mason = init_hero( "mason" );
	level.noriega = init_hero( "noriega" );
	a_heroes = array( level.mason, level.noriega );
	
	trigger_off( "checkpoint_end_trigger", "targetname" );
	start_teleport("player_skipto_checkpoint", a_heroes);
	checkpoint_event();
}

main()
{	
	chase_setup();
	noriega_rescue_event();
	apache_jump_event();
	checkpoint_event();
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////**********  SETUP AND FLAGS **********////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//Performs all setup from second floor clinic to checkpoint
chase_setup()
{
	trigger_off( "noriega_rescue_trigger", "targetname" );
	trigger_off( "checkpoint_end_trigger", "targetname" );
	
	m_clinic_stairs_blocker = getEnt( "clinic_stairs_blocker", "targetname" );
	m_clinic_stairs_blocker Hide();
	m_clinic_stairs_blocker NotSolid();
}

//Initializes flags from second floor clinic to checkpoint
init_flags()
{
	flag_init( "jump_start" );
	flag_init( "chase_player_jumped" );
	flag_init( "clinic_wall_contact" );
	flag_init( "checkpoint_approach" );
	flag_init( "checkpoint_reached" );
	flag_init( "checkpoint_cleared" );
	flag_init( "checkpoint_finished" );
}

//*********************************************************************************************************************************//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////**********  APACHE CHASE EVENT **********//////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//Handles logic for Noriega rescue event
noriega_rescue_event()
{
	level thread run_scene( "noriega_fight_mason" );
	//level thread run_scene( "noriega_fight" );
	level thread run_anim_to_idle( "noriega_fight", "noriega_hanging" );
	level thread clinic_break_wall_think();
	run_scene( "noriega_fight_player" );
	//level thread run_scene( "noriega_hanging" );
	
	level thread run_scene( "dead_soldier_fell" );
	getEnt( "marine_struggler2_ai", "targetname" ) delete();
	trigger_on( "noriega_rescue_trigger", "targetname" );
	level thread noriega_rescue_timer();
	level thread run_scene( "marine_search_party" );
	
	//Wait a frame for the soldiers to be spawned by the scene system
	wait( 0.05 );
	playFxOnTag( level._effect["flashlight"], getEnt( "marine_searcher1_ai", "targetname" ), "tag_flash" );
	playFxOnTag( level._effect["flashlight"], getEnt( "marine_searcher2_ai", "targetname" ), "tag_flash" );
	trigger_wait( "noriega_rescue_trigger" );
	
	m_clinic_stairs_blocker = getEnt( "clinic_stairs_blocker", "targetname" );
	m_clinic_stairs_blocker Show();
	m_clinic_stairs_blocker Solid();
	
	level notify( "noriega_rescued" );
	getEnt( "noriega_rescue_trigger", "targetname" ) delete();
	
	level thread heli_path_manager();
	level thread heli_missile_damage_event_manager();
	level thread jump_fall_fail_think();
	run_scene( "noriega_saved" );
}

//Handles logic for apache jump event from the second floor clinic to burning building
apache_jump_event()
{
	flag_set( "jump_start" );
	//SetSavedDvar( "g_knockback", 0.0 );
	level thread run_scene( "player_look_apache" );
	level thread noriega_jump();
	run_anim_to_idle( "mason_runs_from_apache", "mason_waits_for_jump" );
	trigger_wait( "player_jump_landing_trigger" );
	
	level thread run_scene( "player_jump_landing" );
	
	//Wait for player to look back and see Mason's epic jump
	wait 2.0;
	end_scene( "noriega_balcony_idle" );
	level thread run_scene( "noriega_balcony_run" );
	end_scene( "mason_waits_for_jump" );
	level thread run_scene( "mason_balcony_jump" );
	level.noriega change_movemode( "sprint" );
	level.noriega SetGoalNode( GetNode( "noriega_checkpoint_cover", "targetname" ) );
	
	//Wait to stagger ally movement
	wait 2.0;
	level.mason change_movemode( "sprint" );
	level.mason SetGoalNode( GetNode( "mason_checkpoint_cover", "targetname" ) );
}

//Temporary function for getting Noriega to the next building
//TODO: Do this the right way when we have new animations
noriega_jump()
{
	run_scene( "noriega_runs_from_apache" );
	run_scene( "noriega_balcony_jump" );
	run_scene( "noriega_balcony_idle" );
}

//Handles logiv for Noriega breaking through wall during struggle with Marine
clinic_break_wall_think()
{
	flag_wait( "clinic_wall_contact" );
	
	level notify( "fxanim_wall_fall_start" );
}

//Handles fail condition for player not rescuing Noriega in time
noriega_rescue_timer()
{
	level endon( "noriega_rescued" );
	
	wait( 3.0 );
	
	getEnt( "noriega_rescue_trigger", "targetname" ) delete();
	level.noriega stop_magic_bullet_shield();
	run_scene( "noriega_falls" );
	
	SetDvar( "ui_deadquote", &"PANAMA_NORIEGA_DEAD_FAIL" );
	level notify( "mission failed" );
	maps\_utility::missionFailedWrapper();
}

//Handles fail condition for if the player falls into the alley between the clinic and burning building
jump_fall_fail_think()
{
	trigger_wait( "apache_jump_fall_trigger" );
	
	level notify( "mission failed" );
	maps\_utility::missionFailedWrapper();
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
	
	if ( (!IsDefined( level.player.n_previous_damage_time ) || (level.player isSprinting() && (getTime() - level.player.n_previous_damage_time) > 500)) && eAttacker == e_apache )
	{
		level.player.n_previous_damage_time = getTime();
		iDamage = 0;
		showDamage = true;
	}
	else if ( level.player isSprinting() && eAttacker == e_apache )
	{
		iDamage = 0;
		showDamage = false;
	}
	else if ( eAttacker == e_apache )
	{
		iDamage = 80;
		showDamage = true;
	}
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

//*********************************************************************************************************************************//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////**********  CHECKPOINT EVENT **********//////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//Handles logic for the checkpoint cinematic
checkpoint_event()
{	
	//Wait for animation to finish from jump event
	wait 2.0;
	flag_set( "checkpoint_approach" );
	load_gump( "panama_gump_4" );
	
	level thread run_anim_to_idle( "checkpoint_husband", "checkpoint_husband_idle" );
	level thread run_scene( "checkpoint_start_idle_allies" );
	level thread run_scene( "checkpoint_start_idle_guards" );
	level thread run_scene( "checkpoint_civ_lineup" );
	level thread run_scene( "prisoners_idle" );
	level thread run_scene( "tough_guys" );
	
	level.player SetLowReady( true );
	level.noriega waittill( "goal" );
	level.mason waittill( "goal" );
	trigger_wait( "checkpoint_approach_trigger" );
	
	flag_set( "checkpoint_reached" );
	run_scene( "checkpoint_ally_walkout" );
	run_scene( "checkpoint_stop" );
	level thread run_scene( "checkpoint_stop_idle_allies_guard_group2" );
	level thread run_scene( "checkpoint_stop_idle_guard_group1" );
	wait( 0.5 );
	run_scene( "checkpoint_advance" );
	trigger_on( "checkpoint_end_trigger", "targetname" );
	flag_set( "checkpoint_cleared" );
	level thread run_anim_to_idle( "checkpoint_cleared_guards_group1", "checkpoint_end_idle_guards_group1" );
	level thread run_anim_to_idle( "checkpoint_cleared_guards_group2", "checkpoint_end_idle_guards_group2" );
	level thread run_anim_to_idle( "checkpoint_cleared_guard_prisoner", "checkpoint_end_idle_guard_prisoner" );
	level thread run_anim_to_idle( "checkpoint_cleared_mason", "checkpoint_end_idle_mason" );
	run_anim_to_idle( "checkpoint_cleared_noriega", "checkpoint_end_idle_noriega" );
	trigger_wait( "checkpoint_end_trigger" );
	
	flag_set( "checkpoint_finished" );
	level notify( "stop_speed_think" );
	level thread old_man_woods( "mid_flashpoint_2" );
	level.player SetLowReady( false );
	level.player AllowSprint( true );
	level.player.overridePlayerDamage = undefined;
	
	end_scene( "checkpoint_end_idle_guards_group1" );
	end_scene( "checkpoint_end_idle_guards_group2" );
	end_scene( "checkpoint_end_idle_guard_prisoner" );
	end_scene( "checkpoint_husband_idle" );
	end_scene( "checkpoint_civ_lineup" );
	end_scene( "prisoners_idle" );
	end_scene( "tough_guys" );
}

//*********************************************************************************************************************************//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////**********  APACHE FLIGHT LOGIC **********//////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//Handles logic for Apache's flight paths through the chase and escape events
heli_path_manager()
{
	e_apache = spawn_vehicle_from_targetname( "attack_apache" );
	s_apache_strafe_start = getStruct( "apache_strafe_start", "targetname" );
	
	e_apache godOn();
	e_apache thread heli_go_struct_path( getStruct( "apache_attack_start", "targetname" ) );
	
	e_apache waittill( "path_finished" );
	
	e_apache thread heli_go_struct_path( s_apache_strafe_start );
	
	e_apache waittill( "path_finished" );
	
	SetDvar( "ui_deadquote", &"PANAMA_APACHE_ESCAPE_FAIL" );
	level.player.overridePlayerDamage = ::apache_player_damage_callback;
	e_apache setLookAtEnt( level.player );
	e_apache set_turret_target( level.player, undefined, 0 );
	e_apache SetSpeed( 20.0 );
	e_apache thread apache_player_kill_timer( 3.0, undefined, false );
	trigger_wait( "apache_strafe_start_trigger" );
	
	level notify( "stop_kill_timer" );
	e_apache thread shoot_turret_at_target( level.player, 2000.0, (0, 0, 32.0), 0 );
	e_apache thread heli_strafe_follow_player( s_apache_strafe_start, 512.0 );
	trigger_wait( "apache_chase_jump_trigger" );
	
	flag_set( "chase_player_jumped" );
	e_apache stop_turret( 0 );
	e_apache clearLookAtEnt();
	e_apache clear_turret_target( 0 );
	
	//Wait a frame for the thread sending the Apache to follow the player to die
	wait 0.05;
	e_apache setLookAtEnt( GetEnt( "apache_jump_attack_target", "targetname" ) );
	e_apache SetSpeed( 100.0 );
	e_apache thread heli_go_struct_path( GetStruct( "jump_missile_fire_position_start", "targetname" ) );
	e_apache waittill( "path_finished" );
	
	e_apache SetSpeed( 30.0 );
	e_apache shoot_turret_at_target_once( getEnt( "apache_missile_target1", "targetname" ), undefined, 1 );
	e_apache shoot_turret_at_target_once( getEnt( "apache_missile_target2", "targetname" ), undefined, 2 );
	
	e_apache thread heli_go_struct_path( GetStruct( "apache_spotlight_search_start", "targetname" ) );
	e_apache SetLookAtEnt( GetEnt( "apache_spotlight_search_target", "targetname" ) );
	e_apache waittill( "path_finished" );	
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
	trigger_wait( "watertower_damage_trigger" );
	
	getEnt( "watertower", "targetname" ) delete();
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
		
		if ( IsDefined( s_current.script_noteworthy ) )
		{
			self heli_event_handler( s_current.script_noteworthy );
		}
		
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

//Handles Apache events set on structs in radiant
heli_event_handler( str_event )
{
	a_event_data = strTok( str_event, " " );
		
	for ( i = 0; i < a_event_data.size; i++ )
	{
		switch ( a_event_data[i] )
		{
			case "target":
				i = i + 1;
				e_target = getEnt( a_event_data[i], "targetname" );
				self setLookAtEnt( e_target );
				self set_turret_target( e_target, undefined, 0 );
				break;
				
			case "target_player":
				self setLookAtEnt( level.player );
				self set_turret_target( level.player, undefined, 0 );
				break;
				
			case "start_machinegun":
				self enable_turret( 0 );
				break;
				
			case "stop_machinegun":
				self disable_turret( 0 );
				break;
				
			case "pitch":
				self thread set_pitch( float( a_event_data[i + 1] ), float( a_event_data[i + 2] ), float( a_event_data[i + 3] ) );
				i = i + 3;
				break;
				
			case "shoot_player":
				i = i + 1;
				self thread shoot_turret_at_target( level.player, float( a_event_data[i] ), undefined, 0 );
				break;
				
			case "wait":
				i = i + 1;
				wait( float( a_event_data[i] ) );
				break;
				
			case "clear_target":
				self clearLookAtEnt();
				self clear_turret_target( 0 );
				break;
			case "fire_missile1":
				i = i + 1;
				self shoot_turret_at_target_once( getEnt( a_event_data[i], "targetname" ), undefined, 1 );
				break;
				
			case "fire_missile2":
				i = i + 1;
				self shoot_turret_at_target_once(  getEnt( a_event_data[i], "targetname" ), undefined, 2 );
				break;
				
			case "spotlight_on":
				playFxOnTag( level._effect["apache_spotlight"], self, "tag_barrel" );
				break;
				
			default:
				AssertMsg( "Event:  \"" + a_event_data[i] + "\"does not exist for helicopter." );
				break;
		}
	}
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