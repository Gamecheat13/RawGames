#include common_scripts\utility;	
#include maps\_utility;
#include maps\karma_util;
#include maps\_scene;
#include maps\_objectives;
#include maps\_glasses;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

/* ------------------------------------------------------------------------------------------
    INIT functions
-------------------------------------------------------------------------------------------*/
//
//	Declare event-specific flags here
init_flags()
{
	flag_init( "civ_kill_club" );	
	flag_init( "salazar_start_overwatch" );
	flag_init( "salazar_in_position" );
	flag_init( "start_club_fight" );
	flag_init( "targets_marked" );
	flag_init( "salazar_target1_down" );
	flag_init( "club_melee_started" );
	flag_init( "club_melee_done" );
	flag_init( "salazar_target2_down" );
	flag_init( "club_shoot_target_down" );
	flag_init( "counterterrorists_win" );
	flag_init( "exit_club" );
	
	flag_init( "club_terrorists_alerted" );
}

//
//	Need an AI to run something when spawned?  Put it here.
init_spawn_funcs()
{
	add_spawn_function_group( "scene_63_bodyguards", 	"script_noteworthy", ::club_enemies_think );
	add_spawn_function_group( "club_terrorist", 		"targetname", 		 ::club_terrorist_think );

	trigger_off( "t_badguy_alert", "targetname" );
}

/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/
skipto_inner_solar()
{
	level.ai_salazar = init_hero( "salazar" );
	
	start_teleport( "skipto_inner_solar" );
	
	maps\karma_anim::club_anims();
}


skipto_solar_fight()
{
	level thread maps\createart\karma_art::karma_fog_club();

	maps\karma_anim::club_anims();

	level.player.ignoreme = true;
	level.player AllowStand( false );
	level.ai_salazar = init_hero( "salazar" );
	level.ai_salazar thread salazar_think();
	
	start_teleport( "skipto_solar_fight" );
	
	// Spawn other actors for the scene
	level.a_ai_club_terrorists = simple_spawn( "club_terrorist" );
	level.ai_harper		= init_hero( "harper", ::harper_think );
			
	simple_spawn( "dance_floor_civs", ::ai_evacuee_think );
	simple_spawn( "dance_floor_civs2", ::ai_evacuee_think );
	level thread run_scene_and_delete( "club_dance_civs_cower_idle" );

	exploder( 620 );	// club fx
	exploder( 621 );	// rear section shrimps
	exploder( 622 );	// left section shrimps
	exploder( 623 );	// right section shrimps

	// Delete group dancers
	a_m_groups = GetEntArray( "m_civ_club_group1", "targetname" );
	array_delete( a_m_groups );
}

/* ------------------------------------------------------------------------------------------
	MAIN functions
-------------------------------------------------------------------------------------------*/
//
//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//	your skipto sequence will be called.
//
//	Intro Defalco taking Karma
club_intro()
{
	/#
		IPrintLn( "inner_solar" );
	#/

	level thread maps\createart\karma_art::karma_fog_club();

	n_aggressivecullradius = GetDvar( "Cg_aggressivecullradius" );
	SetSavedDvar( "Cg_aggressivecullradius", 50 );
	level.player SetClientDvar( "sm_enable", 0 );
	
	exploder( 620 );	// club fx
	exploder( 621 );	// rear section shrimps
	exploder( 622 );	// left section shrimps
	exploder( 623 );	// right section shrimps
	
	level thread inner_solar_objectives();
	level thread start_civs_club( "civ_kill_club" );
	
	trigger_wait( "trig_spawn_club_actors" );
	
	level.player.ignoreme = true;
	level.ai_salazar thread salazar_think();
	
	// Spawn the actors for this scene
	level.ai_karma		= simple_spawn_single( "karma",   ::club_actor_think );
	level.ai_harper		= init_hero( "harper", ::harper_think );
	ai_dj = simple_spawn_single( "club_dj" );
	
	level thread run_scene_and_delete( "harper_and_karma_idle" );

	simple_spawn( "dance_floor_civs", ::ai_evacuee_think );
	level thread run_scene_and_delete( "club_dance_civs_idle" );
	level thread run_scene_and_delete( "group_dancing" );
	
	// Player enters the dance floor, Harper gets taken out and Defalco enters
	trigger_wait( "trig_enter_defalco" );

	end_scene( "harper_and_karma_idle" ); 

	flag_set( "player_among_civilians" );
	level.player AllowStand( false );
	
//	level.ai_defalco	= simple_spawn_single( "defalco", ::club_actor_think );
	level.a_ai_club_terrorists = simple_spawn( "club_terrorist" );
	simple_spawn( "dance_floor_civs2", ::ai_evacuee_think );
	level.player playsound("evt_club_solar_abduction");
	level thread run_scene_and_delete( "defalco_takes_karma" );
	level thread run_scene_and_delete( "club_dance_civs_react" );
	
	drones_delete_spawned( "club_rear" );
	
	// This is when AI start to evacuate and we kill Civs in club.
	// Its perfectly timed to where the player is looking down during the scene.
	wait 2.35;
	
	flag_set( "civ_kill_club" );
	clientnotify( "scm2" );
	
	level thread clear_background_civilians();

	// Timing when we turn on PIP.
	wait 1.75;

	flag_set( "salazar_start_overwatch" );

	// Wait for Defalco to depart, then start gameplay
	scene_wait( "defalco_takes_karma" );

	// DJ needs to stay down
	ai_dj entity_hold_last_anim_frame();

	level thread run_scene_and_delete( "club_dance_civs_cower_idle" );

	flag_set( "start_club_fight" );
	clientnotify( "scm3" );

	SetSavedDvar( "Cg_aggressivecullradius", n_aggressivecullradius );
	level.player SetClientDvar( "sm_enable", 1 );
	
	autosave_by_name("club_gameplay");
}


//
//	Eliminate the guards left behind
club_fight()
{
	level thread change_club_lights();
	
//	Spawn( "weapon_tar21_sp", level.player.origin );

	level thread run_scene_and_delete( "harper_unconscious_idle" );

	// Call functions that checks player faults.
	level thread check_player_on_dance_floor();
	level thread wait_for_alert();

	// Mark 2 targets for Salazar
	mark_targets();

	// Player must melee a target
 	level.player melee_target();
 	
 	// Pick up the target's weapons
	level.player GiveWeapon( "tar21_sp" );
	level.player SwitchToWeapon( "tar21_sp" );
 	
 	// If the player got the same target that Salazar was supposed to shoot, then bail
 	if ( flag( "club_terrorists_alerted" ) )
	{
		return;
	}


	// Now there's three targets left:
	//		Salazar's 2nd target
	//		One will become the shoot target
	//		One will become the meatshield guy
	// Pick the shoot target and then the meatshield guy 
	ai_shoot_target = undefined;
	ai_meatshield_attacker = undefined;
	foreach( ai_terrorist in level.a_ai_club_terrorists )
	{	
		if ( ai_terrorist != level.a_salazar_targets[1] )
		{
			if ( !IsDefined( ai_shoot_target ) )
			{
				ai_shoot_target = ai_terrorist;
				continue;
			}
			if ( !IsDefined( ai_meatshield_attacker ) )
			{
				ai_meatshield_attacker  = ai_terrorist;
				break;
			}
		}
	}

	// Initiate meatshield sequence
	level thread meatshield_sequence( ai_meatshield_attacker );

	// "Help" Salazar line up his target
	level.player stick_player( true, 15, 15, 15, 15 );
	level.player lookat_salazar_target2();
	
	// Civs panic and run
//	end_scene( "club_civ_cower" );

	level thread club_exit_doors();

	// Force the player to aim at the target
	level.player shoot_target( ai_shoot_target );
	level.player bullet_cam_sequence( ai_shoot_target );

	flag_wait( "counterterrorists_win" );
	wait( 1.0 );	// natural waiting time after guy is shot

	karma_2_transition();
	
	nextmission();

//	level thread load_gump( "karma_gump_exit_club_mall" );
//	delete_hero( level.ai_salazar );
//	
//	// Give back the player's weapons and control
//	level.player TakeWeapon( "tar21_sp" );
//	Spawn( "weapon_tar21_sp", level.player.origin );
//	level.player unstick_player();
//	flag_set( "draw_weapons" );
}



/* ------------------------------------------------------------------------------------------
	SUPPORT functions
-------------------------------------------------------------------------------------------*/

//
//	Club objective management
inner_solar_objectives()
{
	objective_breadcrumb( level.OBJ_MEET_KARMA, "trig_club_hallway" );
	
	trigger_wait( "trig_enter_defalco" );
	
	set_objective( level.OBJ_MEET_KARMA, undefined, "done" );
	flag_wait( "start_club_fight" );
	
	set_objective( level.OBJ_TAG_TWO_GUARDS );
	flag_wait( "targets_marked" );

	set_objective( level.OBJ_TAG_TWO_GUARDS, undefined, "done" );
	set_objective( level.OBJ_TAG_TWO_GUARDS, undefined, "delete" );
	set_objective( level.OBJ_KILL_CLUB_GUARDS );
	flag_wait( "counterterrorists_win" );

	set_objective( level.OBJ_KILL_CLUB_GUARDS, undefined, "done" );
}


//
//	Change the lights
change_club_lights()
{
	// Turn off blue scrolling lights
	a_e_lights = GetEntArray( "gobo_lights", "targetname" );
	foreach( e_light in a_e_lights )
	{
		e_light SetLightIntensity( 0.0 );
	}
	
	// Turn on spotlights
	a_e_lights = GetEntArray( "soldier_spot", "targetname" );
	foreach( e_light in a_e_lights )
	{
		e_light SetLightIntensity( 30.0 );
	}
	
}

	
// 	Initial civilians in the dance club
//	They will clear out when Defalco arrives
start_civs_club( str_kill_flag )
{
	trigger_wait( "trig_club_hallway" );
	
	// Light Drones
	maps\karma_civilians::assign_civ_spawners( "civ_club_male_light", "civ_club_female_light" );
	maps\karma_civilians::assign_civ_drone_spawners( "club_drones_light" );

	// Drones
	maps\karma_civilians::assign_civ_spawners( "civ_club_male", "civ_club_female" );
	maps\karma_civilians::assign_civ_drone_spawners( "club_drones" );

//	maps\_drones::drones_setup_unique_anims( "club_drones", level.drones.anims[ "civ_walk" ] );
//	maps\_drones::drones_speed_modifier( "club_drones", -0.1, 0.1 );
	maps\_drones::drones_set_max( 256 );
	
	// Spawn static drones
	level maps\karma_civilians::spawn_static_drones( "club_drones_light", "static_club_hallway" );
	level maps\karma_civilians::spawn_static_drones( "club_drones_light", "static_club_patrons" );
	level maps\karma_civilians::spawn_static_drones( "club_drones_light", "static_club_dancers" );

//	level thread maps\_drones::drones_start( "club_drones" );
}

// Scene callback function
corral_left( ai_guy )
{
	run_scene_and_delete( "civs_corralled_left" );
}

// Scene callback function
corral_right( ai_guy )
{
	run_scene_and_delete( "civs_corralled_right" );
}

//###############################################################
//	AI Think logic
//###############################################################

//
// Civs dance on the dance floor until Defalco arrives
//	then they cower
ai_scared_think()
{
	self endon( "death" );

	add_cleanup_ent( "club", self );
	self.goalradius = 16;	
	self gun_remove();
	self.ignoreall = true;
	self.ignoreme = true;

	flag_wait( "civ_kill_club" );
	wait( 0.05 );	// for skipto
	
//	nd_cower = GetNode( self.target, "targetname" );

//	self SetGoalNode( nd_cower );
//	self waittill( "goal" );
}


//
//	People spawned in to run away
ai_evacuee_think()
{
	self endon( "death" );
	
	add_cleanup_ent( "club", self );
	
	self.goalradius = 8;
	self gun_remove();
	self.ignoreall = true;
	self.ignoreme = true;
	
	nd_exit_club = GetNode( "club_exit_node_01", "targetname" );
	self SetGoalNode( nd_exit_club );
	self waittill( "goal" );
	self delete();
}

//
//	A generic actor with no weapon
club_actor_think()
{
	self endon( "death" );

	add_cleanup_ent( "club", self );

	self.goalradius = 8;
	self gun_remove();
	self.ignoreall = true;
	self.ignoreme = true;
}


//
//	Delete all of the dancing drones
clear_background_civilians()
{
	stop_exploder( 620 );	// club fx
	stop_exploder( 621 );	// rear section shrimps
	stop_exploder( 622 );	// left section shrimps
	stop_exploder( 623 );	// right section shrimps

	// Delete group dancers
	a_m_groups = GetEntArray( "m_civ_club_group1", "targetname" );
	array_delete( a_m_groups );
	
	// Clear out the civs
	level thread maps\_drones::drones_delete_spawned( "club_left" );
	level thread maps\_drones::drones_delete_spawned( "club_right" );
//	level thread maps\karma_civilians::delete_all_civs();
}

club_enemies_think()
{
	self.ignoreall = true;
	self.ignoreme = true;
}


//###############################################################
//	TERRORIST LOGIC
//	The terrorists surrounding the dance floor
club_terrorist_think()
{
	self endon( "death" );
	self endon( "club_terrorists_alerted" );
	
	self.goalradius = 8;	
	self.ignoreall = true;
	self.ignoreme = true;
	self.fixednode = true;
	
	flag_wait( "start_club_fight" );

//	self thread wait_for_melee_range();
	nd_target_pos = GetNode( self.target, "targetname" );
	self SetGoalNode( nd_target_pos );
	flag_wait( "salazar_target1_down" );
	
	self thread ai_shoot_wildly();
}


//
//	Shoot up at the ceiling
ai_shoot_wildly()
{
	self endon( "death" );
	
//	self.ignoreall = false;

	// Pick a random target and shoot at it	
	a_fake_targets = GetEntArray( "enemy_fake_targets", "targetname" );
	e_fake = a_fake_targets[ randomint( a_fake_targets.size ) ];
	self thread shoot_at_target( e_fake, undefined, 0, 10 );
	wait( 8 );
	
	if ( !flag( "club_melee_started" ) )
	{
		flag_set( "club_terrorists_alerted" );
	}
}


//
//	Harper actions
harper_think()
{
	self.goalradius = 8;	
	self gun_remove();
	self.ignoreall = true;
	self.ignoreme = true;

	// Wait for it to be all over
	flag_wait( "counterterrorists_win" );
	
	self gun_switchto( "hk416_sp", "right" );	// we'll need to make sure to switch to the right weapon
	self.goalradius = 64;
	self.ignoreall = false;
	self.ignoreme = false;

	// Temp directive	
	t_spot = GetEnt( "trig_club_shutdown", "targetname" );
	self SetGoalPos( t_spot.origin );
}

//###############################################################
//	SALAZAR FUNCTIONS
//
// 	Salazar waits up top for the Player to mark two targets
//	Then he lines up and kills the first.
//	As the player ends his melee, Salazar shoots the second target.
//	Then he lines up the final shot for the meatshield
// 		self is Salazar
salazar_think()
{
	s_destination = GetStruct( "skipto_inner_solar_ai", "targetname" );
	self ForceTeleport( s_destination.origin, s_destination.angles );

	self gun_switchto( "hk416_sp", "right" );	// we'll need to make sure to switch to the right weapon
	self change_movemode( "sprint" );
	self.ignoresuppression = true;
	self.goalradius = 8;
	self.baseaccuracy = 1000;
//	self.disablearrivals = 1;
//	self.disableexits = 1;
//	self.moveplaybackrate = 1.4;
	self Hide();
	wait( 0.5 );	// this is to make skiptos work properly

	flag_wait( "salazar_start_overwatch" );

	nd_salazar_goal = getnode( "nd_target_4", "targetname" );
	self.n_position = nd_salazar_goal.script_int;
	self thread force_goal( nd_salazar_goal, 8 );
	
	self waittill( "goal" );
	
	flag_set( "salazar_in_position" );
//	self thread aim_at_target( level.e_look_at_target );

	flag_wait( "start_club_fight" );

	level thread salazar_pip_on();
	clientNotify( "fov_normal" );
	
	// Wait until the player marks two targets for you
	flag_wait( "targets_marked" );

	// Shoot and kill the first one
	self kill_marked_target( level.a_salazar_targets[0], 1.0, 2.0 );
	flag_set( "salazar_target1_down" );
	clientNotify( "fov_normal" );
	wait( 1.0 );

	v_aim_point = level.a_salazar_targets[1] GetTagOrigin( "J_head" );
	level.e_look_at_target MoveTo( v_aim_point, 1.0 );
	
	flag_wait( "club_melee_started" );
	
	// Shoot and kill the second one
	self thread kill_marked_target( level.a_salazar_targets[1], 2.0, 2.0 );

	self waittill("shoot");
	flag_set( "salazar_target2_down" );

	// Shoot the meatshield guy
	wait( 1.0 );

	clientNotify( "fov_normal" );
	
	v_aim_point = level.a_salazar_targets[2] GetTagOrigin( "J_head" );
	level.e_look_at_target MoveTo( v_aim_point, 1.0 );

	flag_wait( "club_shoot_target_down" );
	
	self kill_marked_target( level.a_salazar_targets[2], 1.0, 10.0 );
	
}


//
//	Aim at and kill the target
//		ai_target - the AI we're going to kill
//		n_traverse_time - how long it takes Salazar to get on target
//		n_aim_time - how long we need to aim
//	self is Salazar
kill_marked_target( ai_target, n_traverse_time, n_aim_time )
{
	self endon( "death" );

	if ( !IsDefined( n_aim_time ) )
	{
		n_aim_time = 2;
	}

	// Check if target is prematurely killed
	ai_target endon( "death" );
	self thread kill_marked_target_monitor( ai_target );
	
	// Move to target
	clientNotify( "fov_zoom" );
	self thread aim_at_target( level.e_look_at_target, n_traverse_time );
	v_aim_point = ai_target GetTagOrigin( "J_head" );
	level.e_look_at_target MoveTo( v_aim_point, n_traverse_time );
	wait( n_traverse_time );

	// Stay pointed at the head	
	clientNotify( "fov_zoom_hi" );
	self thread aim_at_target( ai_target, n_aim_time );
	n_end_time = GetTime() + n_aim_time*1000;
	while ( GetTime() < n_end_time )
	{
		v_aim_point = ai_target GetTagOrigin( "J_head" );
		level.e_look_at_target MoveTo( v_aim_point, 0.2 );
		wait( 0.2 );	// This moves at a slower rate because 0.05 caused bad oscillation in the camera.
	}
	self stop_aim_at_target();

	// Kill the target
	if ( IsAlive( ai_target ) )
	{
		level.a_ai_club_terrorists = array_remove( level.a_ai_club_terrorists, ai_target );
		self notify( "kill_target_monitor" );
		self shoot_and_kill( ai_target, 0 );
		if( IsAlive( ai_target ))
		{
			ai_target kill();
		}
	}
}

//
//	Checks to see if the target is killed prematurely (by the player)
//	This means the player killed a target he had marked for Salazar.
//	This means the kill sequence is interrupted and the terrorists 
//	have just enough time to kill the hostages.
kill_marked_target_monitor( ai_target )
{
	self endon( "kill_target_monitor" );
	
	ai_target waittill( "death" );
	
	// Only gets messed up if you kill Salazar's second target
	// If you kill the meatshield guy, it's okay.
	if ( !flag( "salazar_target2_down" ) )
	{
		iPrintLn( "Sal: Dammit, that was my target!" );
		flag_set( "club_terrorists_alerted" );
	}
}


//
//	Turn on extra cam of Salazar's view
salazar_pip_on()
{
	// Stay with Salazar
	level.ai_salazar thread salazar_look_at_target();
	turn_on_extra_cam();

	flag_wait( "counterterrorists_win" );

	turn_off_extra_cam();
}


//
//	This controls what we want Salazar to look at
salazar_look_at_target()
{
	self endon( "death" );

	// Spawn the entity that we will use to simulate Salazar's look point
	t_dance_floor = GetEnt( "trig_dance_floor", "targetname" );
	level.e_look_at_target = Spawn( "script_origin", t_dance_floor.origin );
	if ( !flag( "start_club_fight" ) )
	{
		level.e_look_at_target thread view_tracking_sequence();
	}
	self LookAtEntity( level.e_look_at_target );
	
	v_salazar_eyes = self GetEye();
	level.e_extra_cam.origin = v_salazar_eyes + (0,0,10);
	level.e_extra_cam.angles = self.angles;
	wait( 0.05 );
	
	// Keep moving with Salazar
	while( true )
	{
		v_camera_pos = self GetTagOrigin( "J_EyeBall_RI" );
		v_lookat = level.e_look_at_target.origin - v_camera_pos;
		v_angle = VectorToAngles( VectorNormalize(v_lookat) );

		CONST n_time = 0.05;
		level.e_extra_cam MoveTo( v_camera_pos, n_time );
		level.e_extra_cam RotateTo( v_angle, n_time );
		level.e_extra_cam waittill( "movedone" );
//		wait( n_time );	// waiting 0.05s seems to cause camera oscillation
	}
}


//
//	Tracking movement up until the fight.
//	self is level.e_look_at_target
view_tracking_sequence()
{
	clientNotify( "fov_normal" );
	flag_wait( "salazar_in_position" );

	// Look At Karma
	self thread follow_ent( level.ai_karma, "J_EyeBall_RI" );
	clientNotify( "fov_zoom" );
	wait( 3.0 );
	clientNotify( "fov_zoom_hi" );
	wait( 5.0 );
	
	// Look At Defalco	
	self thread follow_ent( level.ai_defalco, "J_EyeBall_RI" );
	clientNotify( "fov_zoom" );
	wait( 3.0 );
	clientNotify( "fov_zoom_hi" );
	wait( 4.0 );
	scene_wait( "defalco_takes_karma" );

	self notify( "stop_following_ent" );
	clientNotify( "fov_normal" );

	self thread follow_ent( level.player );
}


//
//	Lag behind the thing you're trying to track
//	self is level.e_look_at_target
follow_ent( e_ent, str_tag )
{
	self notify( "stop_following_ent" );
	
	self endon( "stop_following_ent" );
	
	while ( IsAlive(e_ent) )
	{
		if ( IsDefined( str_tag ) )
		{
			v_origin = e_ent GetTagOrigin( str_tag );
		}
		else
		{
			v_origin = e_ent.origin;
		}
		
		self MoveTo( v_origin, 0.1 );
		wait( 0.1 );
	}
}


//#########################################################
//	PLAYER ACTIONS

//
//	Wait for the player to target something by pressing the attack button
//	This will only return a target that is an enemy
get_marked_target()
{
	dist_ahead = ( 12*50 );	// 50 feet

	// Wait for attack to be pressed
	while ( !level.player AttackButtonPressed() )
	{
		wait 0.05;
	}
	
	v_dir = anglestoforward( level.player getplayerangles() );
	
	start_pos = level.player geteye();
	end_pos = start_pos + ( v_dir * dist_ahead );
	trace = bullettrace( start_pos, end_pos, true, level.player );

//	line( start_pos, end_pos, ( 1, 0, 0 ), 1 );	// debug

	while( IsDefined( trace[ "entity" ] ) )
	{
		e_ent = trace[ "entity" ];
		
		// If it's an actual target then return it.
		if ( e_ent.team == "axis" )
		{
			return e_ent;
		}
		
		// Otherwise, ignore this one and continue on.
		start_pos = trace[ "position" ] + ( v_dir * 10 );	// start a few inches further out
		end_pos = start_pos + ( v_dir * dist_ahead );
		trace = bullettrace( start_pos, end_pos, true, e_ent );
	}
	
	return undefined;
}


//
//	Mark two targets for Salazar
mark_targets()
{
	iPrintLn( "Salazar: Tell me which two you want me to take." );
	
	// This is a list of the target positions that Salazar can't hit.
	// The index is the script_int on the node of Salazar's current position.
	// The array elements are the script_ints of the enemies.
	// So it if Salazar is at position 1 (	
	a_sal_invalid_targets[0] = array( 4, 5 );
	a_sal_invalid_targets[1] = array( 5, 3 );
	a_sal_invalid_targets[2] = array( 3, 1 );
	a_sal_invalid_targets[3] = array( 1, 2 );
	a_sal_invalid_targets[4] = array( 2, 4 );

	screen_message_create( &"KARMA_HINT_MARK_TARGET" );

	level.a_salazar_targets = [];
	n_targets_left = 2;
	while ( n_targets_left )
	{
		ai_marked = get_marked_target();	// blocking call

		if( IsDefined( ai_marked ) )
		{
			// Make sure you didn't already mark him
			b_invalid_target = false;
			foreach( ai_target in level.a_salazar_targets )
			{
				if ( ai_marked == ai_target )
				{
					// Salazar says you're a dumb***
					iPrintLn( "Sal: You already marked that one, boss." );
					b_invalid_target = true;
				}
			}

			// Make sure he's not a target I can't hit
			a_targets = a_sal_invalid_targets[ level.ai_salazar.n_position ];
			foreach( n_target in a_targets )
			{
				if ( ai_marked.script_int == n_target )
				{
					// Salazar says he can't hit that one
					iPrintLn( "Sal: I can't hit that one from my position" );
					b_invalid_target = true;
				}
			}
			
			// Mark the target
			if ( !b_invalid_target )
			{
				Target_set( ai_marked );				
				
				level.a_salazar_targets[ level.a_salazar_targets.size ] = ai_marked;
				screen_message_delete();
				
				iPrintLn( "Target marked" );

				n_targets_left--;
				if ( n_targets_left )
				{
					iPrintLn( "Sal: Got it.  Mark my next target." );
				}
			}
			
			// Wait for the player to release the trigger before trying again
			while ( level.player AttackButtonPressed() )
			{
				wait 0.05;
			}
		}
		wait 0.05;		
	}
	
	flag_set( "targets_marked" );
}


//
//	Allows player to melee his target
// 	self is the player
melee_target()
{
	CONST n_range = 72*72;	// detection range
	while( !flag( "salazar_target1_down" ) )
	{
		foreach( ai_terrorist in level.a_ai_club_terrorists )
		{
			if ( DistanceSquared( ai_terrorist.origin, level.player.origin ) < n_range )
			{
				flag_set( "club_terrorists_alerted" );
				return;
			}
		}
		wait( 0.1 );
	}

	self AllowStand( true );	
	flag_set( "player_act_normally" );

	// Now switch to waiting for melee logic	
	b_in_range = false;
	ai_curr_target = undefined;
	while ( !flag( "club_melee_done" ) )
	{
		b_any_in_range = false;
		foreach( ai_terrorist in level.a_ai_club_terrorists )
		{
			// If we're in melee range...
			if ( DistanceSquared( ai_terrorist.origin, level.player.origin ) < n_range )
			{
				b_any_in_range = true;
				ai_curr_target = ai_terrorist;
				
				// Should we do melee?
				if ( level.player MeleeButtonPressed() )
				{
					screen_message_delete();
					flag_set( "club_melee_started" );
					ai_terrorist.animname = "melee_target";
					ai_terrorist.script_nodropweapon = 1;
					
					// Calculate the position where we will need to place our shooter for the next phase.
					// It's approximately opposite of our current target
					level.nd_shooter_target = GetNode( ai_terrorist.script_noteworthy, "targetname" );
					
					// Check direction
					n_align = GetStruct( "generic_align", "targetname" );
					n_align.origin = ai_terrorist.origin;
					v_to_player = VectorNormalize( level.player.origin - ai_terrorist.origin );
					
					// Execute
					self SetStance( "stand" );	
					if ( within_fov( ai_terrorist.origin, ai_terrorist.angles, level.player.origin, cos(90) ) )
					{
						n_align.angles = VectorToAngles( v_to_player );
						run_scene_and_delete( "club_melee_front" );
					}
					else
					{
						run_scene_and_delete( "club_melee_back" );
					}
					level.a_ai_club_terrorists = array_removedead( level.a_ai_club_terrorists );
					flag_set( "club_melee_done" );
				}
			}
		}
		
		// We're in range and the hint was off, turn it on
		if ( b_any_in_range && !b_in_range )
		{
			b_in_range = true;
			screen_message_create( &"KARMA_HINT_MELEE" );
		}
		// If we're not in range of anyone and the hint was on, turn it off
		else if ( !b_any_in_range && b_in_range )
		{
			b_in_range = false;
			screen_message_delete();
		}
		
		wait( 0.05 );
	}
}


//
//	Salazar starts aiming again at the end of the melee
lookat_salazar_target2()
{
	ai_target = level.a_salazar_targets[1];
	
	level.player thread player_stick_face_ent( ai_target, 1.0, 0.1, 0.3 );
	wait( 1.0 );
}

//	Force the player to swing around and kill the 4th terrorist
//	self is the player
shoot_target( ai_target )
{
	// Move target into position
	ai_target ForceTeleport( level.nd_shooter_target.origin, level.nd_shooter_target.angles );
	ai_target SetGoalPos( ai_target.origin );

	flag_wait( "salazar_target2_down" );
	
	// Civs get up and escape
	level thread run_scene_and_delete( "club_dance_civs_run" );

	// Spin to target and arm up
	CONST n_time = 0.5;
	thread timescale_tween( 1.0, 0.15, 0.05, 0.0, 0.05 );

	level.player thread player_stick_face_ent( ai_target, 0.5, 0.3, 0.1 );
	level.player.ignoreme = false;

	ai_target.ignoreall = false;
	ai_target notify("stop_shoot_at_target");
	ai_target thread shoot_at_target_untill_dead( self, undefined, 1 );
	ai_target thread magic_bullet_shield();
	ai_target disable_pain();
	
	ai_target waittill( "damage", n_damage, e_attacker, v_direction, v_pos, str_type );
	level.v_bullet_impact = v_pos;

	flag_set( "club_shoot_target_down" );
}


//
//	Follow a bullet as it travels to its target
//	self is the player
bullet_cam_sequence( ai_target )
{
	thread turn_off_extra_cam();
	
	// Play bullet ejection movie
//	level.fade_screen.fadeTimer = 0.05;
//	screen_fade_out();
	level thread play_movie("bullet_time", false, false, undefined, false, "movie_done" );
	level waittill( "movie_done" );
	
	// Spawn the bullet X units in front of the camera
	v_direction = AnglesToForward(self.angles);
	v_origin = self GetEye() + ( v_direction * 6 );

	m_bullet = Spawn( "script_model", v_origin );
	m_bullet SetModel( "anim_glo_bullet_tip" );
	m_bullet.angles = self.angles;
	m_bullet.animname = "bullet";

	// This origin is what the bullet links to so I can move it while it spins
	m_bullet_origin = Spawn( "script_model", v_origin );
	m_bullet_origin SetModel( "tag_origin" );
	m_bullet_origin.angles = self.angles;

	m_bullet LinkTo( m_bullet_origin, "tag_origin" );

	// Spawn the Camera link
	//	If I try to link directly to the m_bullet_origin, 
	//	it will link my origin to the tag_origin.  =(
	s_camera = Spawn( "script_origin", self.origin );
	s_camera.angles = self.angles;
	s_camera LinkTo( m_bullet_origin );

	// Prep the player
	v_player_start = self.origin;
	self FreezeControls( true );
	self PlayerLinkToAbsolute( s_camera );
	self DisableWeapons();
	self HideViewModel();
	level thread run_scene_and_delete( "bullet_time_bullet_spin" );

	// Travel to your destination
	if ( IsDefined( ai_target ) )
	{
		v_dist = Distance( level.v_bullet_impact, m_bullet_origin.origin );
//		v_dist = Distance( ai_target.origin, m_bullet_origin.origin );
	}
	else
	{
		v_dist = 400;
	}
	CONST n_time = 0.2;	// bullet travel time
	v_dest = level.v_bullet_impact;
//	v_dest = v_origin + ( v_direction * v_dist );
	m_bullet_origin MoveTo( v_dest, n_time );
	wait( 0.05 );

//	level.fade_screen.shader = "white";
//	screen_fade_in();

	// Slow down to super slow time
	CONST n_time_scale = 0.05;
	level thread timescale_tween( 0.15, n_time_scale, 0.05, 0.0, 0.05 );

	m_bullet_origin waittill( "movedone" );

	// Cut back to normal
	end_scene( "bullet_time_bullet_spin" );
	
	ai_target stop_magic_bullet_shield();
	ai_target DoDamage( ai_target.health, v_origin, self, self );
	
	self FreezeControls( false );
	self Unlink();
	self SetOrigin( v_player_start );
	self EnableWeapons();
	self ShowViewModel();
	
	thread timescale_tween( n_time_scale, 1.0, 1.0, 0.0, 0.05 );
	
	// Sweep it up
	m_bullet_origin Delete();
	m_bullet Delete();
	s_camera Delete();	

	turn_on_extra_cam();
}


//
//	5th guy gets intercepted by Harper, but ends up in a meatshield
meatshield_sequence( ai_attacker )
{
	level.a_salazar_targets[2] = ai_attacker;
	ai_attacker.animname = "meatshield_enemy";
	
//	run_scene_and_delete( "club_meatshield_intro" );
	level thread run_scene_and_delete( "club_meatshield_struggle" );
	flag_wait( "club_shoot_target_down" );
	
	level thread run_scene_and_delete( "club_meatshield_conclusion" );
	wait( 0.1 );	// let the scene start

	level.player thread player_stick_face_ent( ai_attacker, 1.0 );
	scene_wait( "club_meatshield_conclusion" );
	
	flag_set( "counterterrorists_win" );
}
	
//###############################################################
//	Failure conditions
//###############################################################


//
//	If terrorists alerted, kill the player and civs
wait_for_alert()
{
	flag_wait( "club_terrorists_alerted" );

	// Everyone becomes a valid target
	level.player.ignoreme = false;
	a_civs = GetAIArray( "neutral" );
	foreach( ai_civ in a_civs )
	{
		ai_civ.team = "allies";
		ai_civ.ignoreme = false;
	}

	// Bad guys open up on the dance floor	
	foreach( a_guy in level.a_ai_club_terrorists )
	{
		a_guy.ignoreall = false;
		a_guy notify("stop_shoot_at_target");
		a_guy ClearEntityTarget();
		if ( DistanceSquared( a_guy.origin, level.player.origin ) < 10000 )
		{
			a_guy thread shoot_at_target_untill_dead( level.player );
		}
	}
	wait 5.0;

	// Kill the player
	foreach( a_guy in level.a_ai_club_terrorists )
	{
		a_guy notify("stop_shoot_at_target");
		a_guy thread shoot_at_target_untill_dead( level.player );
	}
	if ( !flag( "targets_marked" ) )
    {
    	iPrintLnBold( "Mark targets for Salazar, then wait for him to shoot" );
    }
	else if ( !flag( "salazar_target1_down" ) )
	{
		iprintlnbold("Wait for Salazar's first shot.");
	}
	else
	{
		iprintlnbold("The civilians were killed.");
	}
	wait 3.0;
				
	missionfailedwrapper();
}


//
//	If the player leaves the dance floor, we'll allow him to be spotted and shot at.
check_player_on_dance_floor()
{
	level endon( "salazar_target1_down" );

	// Checks if player is within gameplay area.
	t_dance_floor = getent( "trig_dance_floor", "targetname" );
	while( level.player istouching( t_dance_floor ) )
	{
		wait 0.05;
	}

	iPrintLnBold( "player left dance floor" );
	
	flag_set( "club_terrorists_alerted" );
}



//
//
//

//
// Handles the doors to the exit.  They should open up when AI run out during the shootout
//	and then
club_exit_doors()
{
	m_door_l = GetEnt( "club_door1", "targetname" );
	m_door_r = GetEnt( "club_door2", "targetname" );
	
	m_door_l ConnectPaths();
	m_door_r ConnectPaths();
	
	trigger_wait( "trig_open_club_exit" );
	
	m_door_l RotateYaw( 90, 1.0, 0.2 );
	m_door_r RotateYaw( -90, 1.0, 0.2 );

	trigger_wait( "trig_club_shutdown" );

	m_door_l RotateYaw( -90, 1.0, 0.2 );
	m_door_r RotateYaw( 90, 1.0, 0.2 );
	wait( 1.0 );
	
	club_cleanup();
}


//
//	Delete anything in the club
club_cleanup()
{
	//TODO figure out the right timing for cleanup

	stop_exploder( 620 );
	cleanup_ents( "club" );
}

//
//	Save any data we need to know about for the next mission
karma_2_transition()
{
	// Did we get the tresspasser reward
	SetDvar( "la_F35_pilot_saved", flag( "trespasser_reward_enabled" ) );
}
