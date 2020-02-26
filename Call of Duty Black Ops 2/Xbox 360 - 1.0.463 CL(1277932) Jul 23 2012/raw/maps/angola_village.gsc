
#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_objectives;
#include maps\angola_2_util;
#include maps\_anim;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


//*****************************************************************************
//*****************************************************************************

skipto_village()
{
	skipto_teleport_players( "player_skipto_village" );

	level.ai_woods = init_hero( "woods" );
	level.ai_hudson = init_hero( "hudson" );

	level.player_beartrap_toolshed_pickup = true;

	exploder( 200 );
	level notify( "fxanim_vines_start" );
}


//*****************************************************************************
//*****************************************************************************

init_flags()
{
	flag_init( "mason_ready_to_enter_hud_window" );
	flag_init( "mason_ready_to_grab_menendez" );

	flag_init( "menendez_meatshield_starts" );
	flag_init( "player_knows_meatshield_controls" );
	flag_init( "player_completes_meatshield_movement" );

	flag_init( "meatshield_completed" );

	flag_init( "village_cleanup" );
	flag_init( "a_village_complete" );
}


//*****************************************************************************
//*****************************************************************************

main()
{
	init_flags();

	level.meatshield_v2 = true;

	level thread spinning_fan();

	level.player thread maps\createart\angola_art::village();

	// Color System - Use the color system to move Hudson around
	level.ai_hudson set_force_color( "r" );

	// Village Animations
	level thread village_animations();
		
	// Village Objectives
	level thread village_objectives();

	// Village Events
	str_category = "meatshield_guys";
	level thread village_meatshield_events( str_category );

	level thread radio_loop();

	// Wait for the section to complete
	flag_wait( "a_village_complete" );

	// 
	maps\angola_jungle_stealth::switch_on_angola_escape_trigges();

	// Cleanup
	cleanup_ents( "meatshield_guys" );

	// Clean up animations etc...
	flag_set( "village_cleanup" );
	wait( 0.1 );
}


//*****************************************************************************
//*****************************************************************************
// Set Piece Animations
//*****************************************************************************
//*****************************************************************************

village_animations()
{
	str_cargo_guys = "village_ambient_cargo_guys";
	str_inspect_guys = "village_ambient_inspect_guys";
	str_patrol_guys = "village_ambient_patrol_guys";
	str_smoker_guys = "village_ambient_smoker_guys";
	str_inspect_b_guys = "village_ambient_inspect_b_guys";
	str_patrol_b_guys = "village_ambient_patrol_b_guys";
	str_smoker_b_guys = "village_ambient_smoker_b_guys";
	str_gaz_unloading = "village_truck_unloading";
	str_gaz_unpacking = "village_truck_unpacking";

	str_background_guys = "village_background_2guys";
	str_background_guys_part2 = "village_background_2guys_part2";

	level thread run_scene( str_cargo_guys );
	level thread run_scene( str_inspect_guys );
	level thread run_scene( str_patrol_guys );
	level thread run_scene( str_smoker_guys );
	level thread run_scene( str_inspect_b_guys );
	level thread run_scene( str_patrol_b_guys );
	level thread run_scene( str_smoker_b_guys );
	level thread run_scene( str_gaz_unloading );
	level thread run_scene( str_gaz_unpacking );

	level thread run_scene( str_background_guys );
	level thread run_scene( str_background_guys_part2 );

	flag_wait( "village_cleanup" );

	end_scene( str_cargo_guys );
	end_scene( str_inspect_guys );
	end_scene( str_patrol_guys );
	end_scene( str_smoker_guys );
	end_scene( str_inspect_b_guys );
	end_scene( str_patrol_b_guys );
	end_scene( str_smoker_b_guys );
	end_scene( str_gaz_unloading );
	end_scene( str_gaz_unpacking );

	end_scene( str_background_guys );
	end_scene( str_background_guys_part2 );
}


//*****************************************************************************
//*****************************************************************************

radio_loop()
{
	//iprintlnbold (" GOT IT");
	radio_loop_sound = spawn ( "script_origin", (-18601, -3066, 673));
	radio_loop_sound playloopsound ( "amb_angola_radio_lp");
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

village_objectives()
{
	wait( 0.1 );


	//********************************************************************
	// OBJECTIVE: Approach the open window by the Communication Building
	//********************************************************************

	t_trigger = getent( "objective_player_enter_hut_trigger", "targetname" );
	str_struct_name = t_trigger.target;
	s_struct = getstruct( str_struct_name, "targetname" );
	set_objective( level.OBJ_MASON_GOTO_HUT_WINDOW, s_struct, "" );

	t_trigger waittill( "trigger" );
	set_objective( level.OBJ_MASON_GOTO_HUT_WINDOW, undefined, "delete" );

	flag_set( "mason_ready_to_enter_hud_window" );


	//********************************************************************
	// OBJECTIVE: Approach the open window by the Communication Building
	//********************************************************************

	t_trigger = getent( "objective_locates_menendez_in_hut_trigger", "targetname" );
	str_struct_name = t_trigger.target;
	s_struct = getstruct( str_struct_name, "targetname" );
	set_objective( level.OBJ_MASON_GRAB_MENENDEZ, s_struct, "" );

	t_trigger waittill( "trigger" );
	set_objective( level.OBJ_MASON_GRAB_MENENDEZ, undefined, "delete" );

	flag_set( "mason_ready_to_grab_menendez" );


	//****************************************
	// OBJECTIVE: Use Menendez as a meatshield
	//****************************************

	flag_wait( "menendez_meatshield_starts" );

	//set_objective( level.OBJ_MENENDEZ_MEATSHIELD );

	flag_wait( "meatshield_completed" );

	//set_objective( level.OBJ_MENENDEZ_MEATSHIELD, undefined, "delete" );
}


//*****************************************************************************
//*****************************************************************************
// 
//*****************************************************************************
//*****************************************************************************

village_meatshield_events( str_category )
{
	level.meatshield_fails = false;
	
	// Puts Menendez at the Radio Station
	level thread run_scene( "menendez_radio_room_idle" );

	// Player Climbs through window into Radio Hut
	flag_wait( "mason_ready_to_enter_hud_window" );

	autosave_by_name( "ready_to_enter_the_hut" );

	str_scene = "player_climb_into_radio_room";
	level thread player_lower_weapons( str_scene );
	run_scene( str_scene );

	// Wait for player to walk into the Menendex trigger box, then player grabs Menendez into a meat shield
	flag_wait( "mason_ready_to_grab_menendez" );


	//******************************************************
	// Enemy crowd enters the hut and advances on the player
	//******************************************************

	str_scene_enemy_attack = "meatshield_enemy_attack";

	level thread enemy_enter_meatshield_room( str_scene_enemy_attack );


	//************************************
	// The player Grabs Menendez Animation
	//************************************

	player_grabs_menendez_in_meatshield_hold();

	
	//************************************************************
	// Controls the players meatshield escape
	// We are not using the scene system for the meatshield escape
	//************************************************************

	player_speed = 1.62;		// 1.62
	e_menendez = getent( "menendez_drone", "targetname" );

	level.player thread player_meatshield_move_and_rotate( e_menendez, player_speed );


	//**********************************************
	// Wait for the meatshield scene to succeed fail
	//**********************************************

	while( flag("meatshield_completed") == false )
	{
		if( level.meatshield_fails == true )
		{
			return;
		}
		
		wait( 0.01 );
	}
	

	//******************************************************
	// Success, retreat out of the hut
	//******************************************************
	
	delete_scene( str_scene_enemy_attack );

	level thread grenade_explosion_effect();

	level thread run_scene( "meatshield_enemy_retreat_guy4" );

	// sb43 - HACK FOR AN FXANIM THAT IS PLAYING 2 SECONDS TOO LATE
	level thread hack_fxanim_notify_fix();

	run_scene( "meatshield_enemy_retreat" );
	
	
	//******************************************************
	// 
	//******************************************************
	
	//SOUND - Shawn J
	clientNotify ("esc_alrm");
	
	//TUEY set music to ANGOLA_JUNGLE_ESCAPE
	setmusicstate ("ANGOLA_JUNGLE_ESCAPE");

	autosave_by_name( "meatsield_complete" );

	//run_scene( "meatshield_player_window_escape" );

	level.mason_meatshield_weapon delete();

	player_restore_weapons();
	
	// End of Event
	flag_set( "a_village_complete" );
}

hack_fxanim_notify_fix()
{
	wait( 10+1 );
	level notify( "hostage_hut_start" );
}


//*****************************************************************************
//*****************************************************************************

enemy_enter_meatshield_room( str_scene_enemy_attack )
{
	// Randomize the two aggressive soldiers
	if( !IsDefined(level.meatshield_random_attacker_index) )
	{
		rval = randomint( 999 );
		if( rval < 500 )
		{
			level.meatshield_random_attacker_index = 0;
		}
		else
		{
			level.meatshield_random_attacker_index = 1;
		}
	}

	else
	{
		level.meatshield_random_attacker_index++;
		if( level.meatshield_random_attacker_index > 1 )
		{
			level.meatshield_random_attacker_index = 0;
		}
	}

	// Play the main scene thats always the same
	level thread run_scene( str_scene_enemy_attack );

	// Select two random attackers
	if( level.meatshield_random_attacker_index == 0 )
	{
		level thread meatshield_ai_attacker( "meatshield_enemy_attack_ai2", "guy_soldier2_ai" );
		level thread meatshield_ai_attacker( "meatshield_enemy_attack_ai4", "guy_soldier4_ai" );
	}
	else
	{
		level thread meatshield_ai_attacker( "meatshield_enemy_attack_ai2_variation", "guy_soldier2_ai" );
		level thread meatshield_ai_attacker( "meatshield_enemy_attack_ai4_variation", "guy_soldier4_ai" );
	}
}


//*****************************************************************************
//*****************************************************************************

meatshield_attacker_attack_target( e_target )
{
	self.ignoreall = true;
	self.favoriteenemy = e_target;
	self.script_ignore_suppression = 1;

	//self.fixednode = true;

	self thread aim_at_target( e_target );
	self thread shoot_at_target( e_target, undefined, 0.2, 3 );

	//self setgoalpos( e_target.origin );
	//self.goalradius = 64;
}


//*****************************************************************************
//*****************************************************************************

player_grabs_menendez_in_meatshield_hold()
{
	str_scene_name = "player_grabs_menendez";

	level thread run_scene( str_scene_name );
	wait( 0.1 );

	// Create a player body - Actually use player rig from previous scene
	//m_player_rig = spawn_anim_model( "player_body", level.player.origin, s_start.angles );
	// todo - fix this, a progression bug somwhere
	a_rigs = getentarray( "player_body", "targetname" );
	m_player_rig = a_rigs[0];

	level.m_player_rig = m_player_rig;
	
	// Creating and linking the pistol weapon
	level.mason_meatshield_weapon = spawn_model( "t6_wpn_pistol_browninghp_prop_view", level.m_player_rig GetTagOrigin( "tag_weapon1" ), level.m_player_rig GetTagAngles( "tag_weapon1" ) );
	level.mason_meatshield_weapon LinkTo( level.m_player_rig, "tag_weapon1" );
	
	// Creating the knife
	//wait( 0.1 );
	//e_menendez = getent( "menendez_drone", "targetname" );
	//level.mason_knife_weapon = spawn_model( "viewmodel_knife", e_menendez GetTagOrigin( "tag_weapon_left" ), e_menendez GetTagAngles( "tag_weapon_left" ) );
	//level.mason_knife_weapon LinkTo( e_menendez, "tag_weapon_left" );

	scene_wait( str_scene_name );
}


//*****************************************************************************
//*****************************************************************************

player_lower_weapons( str_scene )
{
	level.player AllowAds( false );
	level.player DisableWeaponCycling();
	level.player GiveWeapon( "fnp45_sp" );
	switch_to_pistol();
	wait( 1 );
	scene_wait( str_scene );
	//IPrintLnBold( "LOW READY" );
	level.player SetLowReady( true );
}


//*****************************************************************************
//*****************************************************************************

player_restore_weapons()
{
	level.player EnableWeaponCycling();
	level.player SetLowReady( false );
	level.player AllowAds( true );
}


//*****************************************************************************
//*****************************************************************************
// PLAYER holding Menendez in a Meatshield
//
// self = player
//*****************************************************************************
//*****************************************************************************

player_meatshield_move_and_rotate( e_menendez, player_speed )
{
	flag_set( "menendez_meatshield_starts" );

	v_offset = e_menendez.origin - level.m_player_rig.origin;
	v_ang_offset = e_menendez.angles - level.m_player_rig.angles;
	
	// Thread the player meatshield controls
	level.meatshield_rot = 0.0;
	level thread meatshield_check_for_player_rotation( 1.5 );	// 1.5

	// Create an origin we will link the player rig to
	s_start = getent( "village_meatshield_start_struct", "targetname" );
		
	// Link Player
	level.player PlayerLinkToAbsolute( level.m_player_rig, "tag_player" );
	
	// Animate Player
	//m_player_rig thread anim_loop( level.m_player_rig, "mason_move_loop" );
	level.m_player_rig SetAnim( level.scr_anim["player_body"]["mason_move_loop"][0], 1, 0, 1 );
	
	// Link Menendez to player
	e_menendez linkto( level.m_player_rig, "tag_origin", v_offset, v_ang_offset );

	//level.player HideViewModel();
	// level.player DisableWeapons();
	
	// Animate Menendez
	e_menendez SetAnim( level.scr_anim[ "menendez" ][ "walk" ][0], 1, 0, 1 );

	
	// Move the player towards the exit eindow once the controls have been acknowledged
	level thread meatshield_screen_message( 3 );
	level thread meatshield_player_movement( player_speed );


	//****************************************************************************
	// Player meatshield rotating via blended animations
	//
	// get the angle facing (vs max)	
	//	if some input registers call a function to play the turn animations
	//	else if facing someone threatening - play threatening anim and stop motion
	//	else if - play animations based on facing
	//****************************************************************************
	
	// Setup
	meatshield_blend = 0.3;				// 0.3
	rotate_threshold = 20.0;			// 0.2
	back_right_threshold = 40.0;		// 200.5
	back_left_threshold = -40.0;		// -200.5
	n_facing_diff = 0.0;

	e_end = getent( "village_meatshield_end_struct", "targetname" );

	level thread player_meatshield_facing_rumble( 1.0 );
	
	while( flag("player_completes_meatshield_movement") == false )
	{
		//************************************
		// Check input for left/right rotation
		//************************************

		if( IsDefined(level.meatshield_v2) && (level.meatshield_v2 == true) )
		{
			// LDS: Do Dot product and Cross product
			// LDS: Store resulting angle in facing_diff

			// Walking perfefctly back, this would be our facing
			v_end = ( e_end.origin[0], e_end.origin[1], 0 );
			v_start = ( level.m_player_rig.origin[0], level.m_player_rig.origin[1], 0 );
			v_norm_vec = VectorNormalize( v_end - v_start );
			v_norm_vec = v_norm_vec * -1;

			// Convert facing to normalized
			v_angles = anglesToForward( level.m_player_rig.angles );
			v_angles = VectorNormalize( v_angles );
			
			// Get cos of angle beteeen
			n_dot = vectordot( v_norm_vec, v_angles );
			
			// Have an angle, but is it left or right?
			n_facing_diff = acos( n_dot );
			
			v_cross = VectorCross( v_norm_vec, v_angles );
			if( v_cross[2] > 0 )
			{
				n_facing_diff = n_facing_diff * -1;
			}
			

			// IPrintLnBold( "MS ROT" + level.meatshield_rot );
			// NOTE: level.meatshield_rot (RSTICK) goes from (-3.47 to 3.47)

			// Do we want to rotate the meatshield pair?
			if( abs(level.meatshield_rot) > rotate_threshold )
			{
				// Do we want to Rotate Left?
				if( level.meatshield_rot < 0.0 )
				{
					time = 0.0;
					if( n_facing_diff > back_right_threshold )
					{
						level.m_player_rig SetAnimKnobAll( %player::int_meatshield_angola_player_backright_to_back, %player::root, 1, meatshield_blend, 1 );
						e_menendez SetFlaggedAnimKnobAll( "meatshield_transition", %generic_human::ai_meatshield_angola_hostage_backright_to_back, %generic_human::body );
						time = GetAnimLength( %generic_human::ai_meatshield_angola_hostage_backright_to_back );
					}
					else if( n_facing_diff > back_left_threshold )
					{
						level.m_player_rig SetAnimKnobAll( %player::int_meatshield_angola_player_back_to_backleft, %player::root, 1, meatshield_blend, 1 );
						e_menendez SetFlaggedAnimKnobAll( "meatshield_transition", %generic_human::ai_meatshield_angola_hostage_back_to_backleft, %generic_human::body );
						time = GetAnimLength( %generic_human::ai_meatshield_angola_hostage_back_to_backleft );
					}
				}
				else
				{
					if( n_facing_diff < back_left_threshold )
					{
						level.m_player_rig SetAnimKnobAll( %player::int_meatshield_angola_player_backleft_to_back, %player::root, 1, meatshield_blend, 1 );
						e_menendez SetFlaggedAnimKnobAll( "meatshield_transition", %generic_human::ai_meatshield_angola_hostage_backleft_to_back, %generic_human::body );
						time = GetAnimLength( %generic_human::ai_meatshield_angola_hostage_backleft_to_back );
					}
					else if( n_facing_diff < back_right_threshold )
					{
						level.m_player_rig SetAnimKnobAll( %player::int_meatshield_angola_player_back_to_backright, %player::root, 1, meatshield_blend, 1 );
						e_menendez SetFlaggedAnimKnobAll( "meatshield_transition", %generic_human::ai_meatshield_angola_hostage_back_to_backright, %generic_human::body );
						time = GetAnimLength( %generic_human::ai_meatshield_angola_hostage_back_to_backright );
					}
				}
				
				if( time > 0.0 )
				{
					level.player PlayRumbleOnEntity( "damage_light" );
					wait( time );
				}
			}
			// else if for threaten transitions
			if( n_facing_diff < back_left_threshold )
			{
				level.player notify( "ms_rumble" );
				level.m_player_rig SetAnimKnobAll( %player::int_meatshield_angola_player_backleft, %player::root, 1, meatshield_blend, 1 );
				e_menendez SetAnimKnobAll( %generic_human::ai_meatshield_angola_hostage_backleft, %generic_human::body, 1, meatshield_blend, 1 );
			}
			else if( n_facing_diff > back_right_threshold )
			{
				level.player notify( "ms_rumble" );
				level.m_player_rig SetAnimKnobAll( %player::int_meatshield_angola_player_backright, %player::root, 1, meatshield_blend, 1 );
				e_menendez SetAnimKnobAll( %generic_human::ai_meatshield_angola_hostage_backright, %generic_human::body, 1, meatshield_blend, 1 );
			}
			else
			{
				level.player notify( "ms_rumble" );
				level.m_player_rig SetAnimKnobAll( %player::int_meatshield_angola_player_back, %player::root, 1, meatshield_blend, 1 );
				e_menendez SetAnimKnobAll( %generic_human::ai_meatshield_angola_hostage_back, %generic_human::body, 1, meatshield_blend, 1 );
			}
		}
		
		wait( 0.01 );
	}

	//level.player ShowViewModel();
	//level.player EnableWeapons();

	//level.player unlink();
	//m_player_rig delete();

	e_menendez unlink();

	flag_set( "meatshield_completed" );
}


//*****************************************************************************
// Meatshield - Move backwards towards the window exit
//*****************************************************************************

meatshield_player_movement( player_speed )
{
	level endon( "meatshield_grenade_explosion" );

	// Destination position to exit the hut via the window
	e_end = getent( "village_meatshield_end_struct", "targetname" );

	flag_wait( "player_knows_meatshield_controls" );

	while( 1 )	
	{
		v_end = ( e_end.origin[0], e_end.origin[1], level.m_player_rig.origin[2] );
		v_dir = VectorNormalize( v_end - level.m_player_rig.origin );

		level.m_player_rig.origin = level.m_player_rig.origin + (v_dir * player_speed);
	
		dist = distance( level.m_player_rig.origin, v_end );
		if( dist < (player_speed*3) )	// 64
		{
			break;
		}
		
		//IPrintLnBold( "Meatshield Exit Dist: " + dist );

		wait( 0.01 );
	}

	flag_set( "player_completes_meatshield_movement" );
}


//*****************************************************************************
// Notes: using v_vec = GetNormalizedCameraMovement
//				v_vec[0] = up/down ( -1, 1 )
//				v_vec[1] = left.right ( -1, 1 )
//*****************************************************************************

meatshield_check_for_player_rotation( rot_scale )
{
	level endon( "meatshield_grenade_explosion" );

	while( flag("player_completes_meatshield_movement") == false )
	{
		v_rstick = level.player GetNormalizedCameraMovement();	// right stick

		//IPrintLnBold( "RStick: " + v_rstick[0] + "  " + v_rstick[1] );

		dead_zone = 0.02;	// 0.1

		left_right = v_rstick[1];
		if( (left_right < dead_zone) && (left_right > -dead_zone) )
		{
			left_right = 0.0;
		}

		level.meatshield_rot = left_right * rot_scale;

		level.meatshield_rot = level.meatshield_rot * -1.0;

		if( level.meatshield_rot != 0.0 )
		{
			v_rot = ( 0 , level.meatshield_rot, 0 );
			v_rot = v_rot + level.m_player_rig.angles;
			level.m_player_rig RotateTo( v_rot, 0.05 );
		}

		wait( 0.01 );
	}
}


//*****************************************************************************
//*****************************************************************************

player_meatshield_facing_rumble( min_gap )
{
	last_time = 0;
	
	while( 1 )
	{
		level.player waittill( "ms_rumble" );
		
		time = gettime();
		dt = ( time - last_time ) / 1000;
		if( dt > min_gap )
		{
			last_time = time;
			level.player PlayRumbleOnEntity( "damage_light" );			
		}
	}
}


//*****************************************************************************
//*****************************************************************************

meatshield_screen_message( display_time )
{
	screen_message_create( &"ANGOLA_2_RSTICK_MEATSHIELD" );

	start_time = gettime();
	rstick_has_moved = 0;
	while( 1 )
	{
		// Check if rstick has moved
/*
		if( rstick_has_moved == 0 )
		{
			if( level.meatshield_rot != 0 )
			{
				flag_set( "player_knows_meatshield_controls" );
				rstick_has_moved = 1;
			}	
		}
*/

		time = gettime();
		dt = ( time - start_time ) / 1000;
	
		// Move yet?
		if( (dt >= display_time) || (rstick_has_moved) )
		{
			break;
		}

		wait( 0.01 );
	}
		
	screen_message_delete();

	flag_set( "player_knows_meatshield_controls" );
}


//*****************************************************************************
// Grenade explosion effect
//*****************************************************************************

grenade_explosion_effect()
{
	level waittill( "meatshield_grenade_explosion" );

	//IPrintLnBold( "EXPLOSION NOTIFY" );

	// sb43 - TODO FIX THIS
	//level notify( "hostage_hut_start" );
	
	// explode the grenade
	e_grenade = getent( "nada", "targetname" );
	playfx( level._effect["def_explosion"], e_grenade.origin );

	//SOUND - Shawn J
	clientNotify ("grn_dgs");
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

// self = level
meatshield_ai_attacker( str_enemy_scene, str_enemy_ai_name )
{
	level endon( "meatshield_failed" );

	level thread run_scene( str_enemy_scene );

	start_time = gettime();
	wait( 0.1 );
	ai_enemy = getent( str_enemy_ai_name, "targetname" );

	ai_enemy endon( "death" );

	ai_enemy.ignoreall = true;
	ai_enemy.ignoreme = true;
	ai_enemy.dontmelee = true;

	// Wait for the gun attack notetracks to register
	while( !IsDefined(ai_enemy.meatshield_threat) )
	{
		wait( 0.01 );
	}

	shoot_thread = false;
	while( 1 )
	{
		if( (ai_enemy.meatshield_threat == true) && (shoot_thread == false) )
		{
			shoot_thread = true;
			ai_enemy thread meatshild_ai_try_and_shoot_target( str_enemy_scene, level.player, 999, 0.5 );	// 0.34
		}

		if( (ai_enemy.meatshield_threat == false) && (shoot_thread == true) )
		{
			shoot_thread = false;
			ai_enemy notify( "kill_shoot_thread" );
		}

		if( flag("meatshield_completed") )
		{
			ai_enemy notify( "kill_shoot_thread" );
			return;
		}

		wait( 0.01 );
	}
}


//*****************************************************************************
//*****************************************************************************

// self = ai meatshield attacker (with raised gun)
meatshild_ai_try_and_shoot_target( str_enemy_scene, e_target, attack_time, player_initial_prep_time )
{
	self endon( "death" );
	level endon( "meatshield_failed" );
	self endon( "kill_shoot_thread" );

	min_dot = 0.80;						// 0.9
	max_allowed_missed_frames = 2;		// 2
	num_missed = 0;

	start_time = gettime();

	while( 1 )
	{
		// Has the player had time to get into position?
		time = gettime();
		dt = ( time - start_time ) / 1000;

		if( dt >= player_initial_prep_time )
		{ 
			// Has the player been looking around for too long?
			v_dir = vectornormalize( self.origin - e_target.origin );
			v_forward = AnglesToForward( e_target.angles );
			dot = vectordot( v_dir, v_forward );

			if( dot < min_dot )
			{
				num_missed++;
				if( num_missed >= max_allowed_missed_frames )
				{
					level thread meatshield_attacker_scene_fails();
					wait( 5 );
					return;
				}
			}

			//iprintlnbold( "DOT: " + dot );
		}

		// Set by a notetrack callback on the animation
		if( self.meatshield_threat == false )
		{
			break;
		}

		if( flag("meatshield_completed") )
		{
			break;
		}

		if( dt >= attack_time )
		{
			break;
		}

		wait( 0.01 );
	}
}


//*****************************************************************************
//*****************************************************************************

meatshield_attacker_scene_fails()
{
/*
	iprintlnbold( "MEATSHIELD FAILS" );
*/

	level.meatshield_fails = true;
	level notify( "meatshield_failed" );

	e_soldier = getent( "guy_soldier_ai", "targetname" );
	e_soldier2 = getent( "guy_soldier2_ai", "targetname" );
	//e_soldier3 = getent( "guy_soldier3_ai", "targetname" );
	e_soldier4 = getent( "guy_soldier4_ai", "targetname" );

	end_scene( "meatshield_enemy_attack" );
	end_scene( "meatshield_enemy_attack_ai2" );
	//end_scene( "meatshield_enemy_attack_ai3" );
	end_scene( "meatshield_enemy_attack_ai4" );
	
	wait( 0.01 );

	e_soldier.ignoreall = true;

	e_soldier2 meatshield_attacker_attack_target( level.player );
	//e_soldier3 meatshield_attacker_attack_target( level.player );
	e_soldier4 meatshield_attacker_attack_target( level.player );

	wait( 1.75 ); 
	MissionFailedWrapper( &"ANGOLA_2_MEATSHIELD_FAILURE" );
}


//*****************************************************************************
//*****************************************************************************

spinning_fan()
{
	e_fan = getent( "fan_spin", "targetname" );

	yaw_angle = -360;
	rotate_time = 2.0;
	while( 1 )
	{
		e_fan RotateYaw( yaw_angle, rotate_time );
		e_fan waittill( "rotatedone" );
		if( flag("village_cleanup") )
		{
			break;
		}
	}
}


