
#include common_scripts\utility;
#include maps\_utility;
#include maps\karma_util;
#include maps\_scene;
#include maps\_objectives;
#include maps\_dialog;
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
	flag_init( "event10_complete" );
	flag_init( "final_animation_started" );
}


//
//	Need an AI to run something when spawned?  Put it here.
init_spawn_funcs()
{
//    add_spawn_function( "intro_drone", ::intro_drone );
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/
skipto_the_end()
{
//	init_hero( "hero_name_here" );

	start_teleport( "skipto_the_end" );
	
	level.ai_han = init_hero_startstruct( "han", "e10_han_start" );
	level.ai_harper = init_hero_startstruct( "harper", "e10_harper_start" );
	level.ai_salazar = init_hero_startstruct( "salazar", "e10_salazar_start" );
	level.ai_redshirt1 = init_hero_startstruct( "redshirt1", "e10_redshirt1_start" );
	level.ai_redshirt2 = init_hero_startstruct( "redshirt2", "e10_redshirt2_start" );

	level thread maps\createart\karma_art::karma_fog_sunset();
}


/* ------------------------------------------------------------------------------------------
	MAIN functions
-------------------------------------------------------------------------------------------*/
//
//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//	your skipto sequence will be called.
main()
{
	// Temp Development info
	/#
		IPrintLn( "Exit Club" );
	#/
//	level thread update_billboard( "Exit Club", "Defalco Escape", "Small", "10" );

	// Initialization
	spawn_funcs();
	maps\karma_2_anim::event_10_anims();
	
	// Objectives
	level thread the_end_objectives();

	// Make characters pacififts etc....
	level thread setup_endscene_characters();
	
	// Scene Animations
	level thread event10_anim();
//	level thread event10_enemy_guards();
	
	// Wait for Level Complete
	flag_wait( "event10_complete" );

	// Advance to the next mission
	IPrintLnBold( "Mission Complete" );
	wait( 5 );
	nextmission();
}


//
//	Need an AI to run something when spawned?  Put it here.
spawn_funcs()
{
//	add_spawn_function_veh( "intro_drone", ::intro_drone );
}


//*****************************************************************************
//
//*****************************************************************************

the_end_objectives()
{
	wait( 0.25 );

	//****************************
	// Set objective for Event10_1
	//****************************
	
	t_trigger = getent( "trigger_end_event10_1", "targetname" );
	str_struct_name = t_trigger.target;
	s_struct = getstruct( str_struct_name, "targetname" );
	
	set_objective( level.OBJECTIVE_EVENT_10_1, s_struct, "" );
	t_trigger waittill( "trigger" );
	
	set_objective( level.OBJECTIVE_EVENT_10_1, undefined, "delete" );

	wait( 0.01 );


	//***************************
	// Mission Complete
	//***************************

wait( 10000 );

	flag_set( "event10_complete" );
}


//*****************************************************************************
//*****************************************************************************

setup_endscene_characters()
{
	level.ai_han.pacifist = true;
	level.ai_harper.pacifist = true;
	level.ai_salazar.pacifist = true;
	level.ai_redshirt1.pacifist = true;
	level.ai_redshirt2.pacifist = true;
	level.ai_han.ignoreall = true;
	level.ai_harper.ignoreall = true;
	level.ai_salazar.ignoreall = true;
	level.ai_redshirt1.ignoreall = true;
	level.ai_redshirt2.ignoreall = true;

	if( !IsDefined(level.ai_defalco) )
	{	
		level.ai_defalco = simple_spawn_single( "defalco" );
		level.ai_defalco.ignoreme = true;
		level.ai_defalco.health = 99999;
	}

	if( !IsDefined(level.ai_karma) )
	{	
		level.ai_karma = simple_spawn_single( "karma" );
		level.ai_karma.ignoreme = true;
		level.ai_karma.health = 99999;
	}

	anim_init_karma_scan();
}


//*****************************************************************************
//*****************************************************************************

anim_init_karma_scan()
{
	//
	// Don't need to spawn the xmodel, simply having the spawner in the map ensures the model data is pre-cached
	//

	//level.ai_karma_scan = simple_spawn_single( "karma_scan" );
	//level.ai_karma_scan.ignoreme = true;
	//level.ai_karma.health = 99999;

	//level.ai_karma_scan.ignore_all = 1;
	//level.ai_karma_scan.pacifist = true;
	
	//level.ai_karma_scan hide();
}


//*****************************************************************************
// CONTROLS THE WHOLE EVENT 10 SHOOT EVENT
//*****************************************************************************

event10_anim()
{
	// Wait for the End Scene Animation Start Trigger
	t_trigger = getent( "trigger_start_defalco_end_anim", "targetname" );
	t_trigger waittill( "trigger" );

	// Clean up Ents from Event 9
	maps\karma_little_bird::cleanup_ents_for_event10_animation();
	wait( 0.1 );

	flag_set( "final_animation_started" );


	// Dialog - Warn Player to keep his distance
	level.ai_salazar thread say_dialog( "caution_mason_defaloc", 0.1 );

	// Turn on the Extra Cam for the shoot event
	
	

	//*******************************
	// Setup a fake player to animate
	//*******************************

	ent_fake_player = Spawn( "script_model", level.player.origin );
	ent_fake_player SetModel( "tag_origin" );
	ent_fake_player.angles = level.player.angles;
	ent_fake_player.animname = "fake_player";
	wait( 0.1 );
	
	player_hdg = 88;			// 65
	player_pitch_up = 30;		// 30
	player_pitch_down = 40;		// 40
	level.player PlayerLinkToDelta ( ent_fake_player, "tag_origin", 0.0, player_hdg, player_hdg, player_pitch_up, player_pitch_down );
	
	// Remember if the player has the stinger_sp weapon
	if ( level.player hasweapon( "stinger_sp" ) )
	{
		level.player.has_stinger = true;
	}
	
	// Take away players weapons
	level.player take_weapons();
	level thread battlechatter_off();

	// Make the primary characters invulnerable
	level thread make_scene10_characters_invulnerable();
	

	//************************
	// SCENE STARTS - BLOCKING
	//************************
	
	level thread karma_showdown_dialog();
	level run_scene_and_delete( "scene_event10_start" );


	//*****************************************
	// SETUP: Prepare for the shoot Karma Scene
	//*****************************************

	// Give the player the pistol weapon
	level.player GiveWeapon( "fiveseven_sp" );
	level.player SwitchToWeapon( "fiveseven_sp" );
//	extra_cam.angles = level.player.angles;
//	extra_cam.origin = level.player GetEye();
//	extra_cam linkto(level.player, "tag_flash");
	level thread turn_on_extra_cam();

	// Swap  Karma to the Scan Model
	level.ai_karma thread karma_swap_to_scan_model( 0.1, "c_usa_chloe_lynch_organs_fb" );

	// Get accurate damage info on Karma being shot
	level.ai_karma.overrideActorDamage = ::karma_shot_callback;
	
	// Check for defalco being shot
	//level thread defalco_shot_check_thread();
	
	level thread guard_shot_check_thread( "enemy_soldier_end_level_left_ai" );
	level thread guard_shot_check_thread( "enemy_soldier_end_level_right_ai" );

	// Check for characters being shot
	level.ai_karma notify( "shooot_karma_now" );
	
	clientnotify( "kbss" );
	level.player playsound( "evt_bodyscan_start" );
	level.player playloopsound( "evt_bodyscan_loop", .5 );

	//****************************
	// START THE SHOOT KARMA SCENE
	//****************************

	//level thread check_for_fire_button();

	level thread check_for_shootout_end_condition();

	level thread run_scene( "scene_event10_standoff_shoot_karma" );

	// Wait for the scene to finish without the player shooting
	scene_wait( "scene_event10_standoff_shoot_karma" );

	// Switch off the extra cam
	turn_off_extra_cam();

	// Swap Karma back to the normal render model
	level.ai_karma thread karma_swap_back_to_normal_body( 0.1, "c_usa_hillaryclinton_g20_fb" );
	
		
	//***********************************************************************
	// PLAY THE APPROPRIATE ENDING - Based on results of end_condition thread
	//***********************************************************************

	level notify( "shootout_finished" );
	
	clientnotify( "kbse" );
	level.player stoploopsound( 1 );
	level.player playsound( "evt_bodyscan_end" );
	
	// Take away players weapons
	level.player take_weapons();

	// SUCCESS - Karma Disabled by player
	if( IsDefined(level.ai_karma.karma_killed_by_player) && (level.ai_karma.karma_killed_by_player==0) )
	{
		level notify( "player_alive_challenge_complete" );	
		
		IPrintLnBold( "SUCCESS - Karma Disabled by Player" );
		level thread kill_enemy_guards();
		
		// Triggers MISSION SUCCESS
		level thread trigger_mission_success( 31 );		// 25
		
		// Escape Vehicle - launching
		level thread launch_escape_vehicle();
		level thread launch_raise_player_perk_weapon();
		
		run_scene( "scene_event10_standoff_success" );

		e_plane = maps\_vehicle::spawn_vehicle_from_targetname( "plane_vtol" );
		
		level notify( "player_zero_death_challenge_complete" );	

		//level.ai_defalco entity_hold_last_anim_frame( 1 );
		//level.ai_defalco LinkTo( level.launch_escape_vehicle );
		
//IPrintLnBold( "SUCCESS - Part 2" );
		run_scene_and_delete( "scene_event10_standoff_success_part2" );

//IPrintLnBold( "SUCCESS - Part 3" );
		level thread run_scene_and_delete( "scene_event10_karma_idle_shot_loop" );
		level thread run_scene_and_delete( "scene_event10_salazar_idle_shot_loop" );
	}

	// FAILURE - Karma Shot and Killed by Player
	else if( IsDefined(level.ai_karma.karma_killed_by_player) && (level.ai_karma.karma_killed_by_player==1) )
	{
		IPrintLnBold( "FAILURE - Karma Killed by Player" );
		level thread run_scene_and_delete( "scene_event10_standoff_karma_killed" );
		wait( 3 );
		MissionFailed();

	}
	
	// FAILURE - Player Shoots Defalco
	else if( IsDefined(level.ai_defalco.defalco_shot_by_player) )
	{
		IPrintLnBold( "FAILURE - Defalco Shot by Player" );
		level thread run_scene_and_delete( "scene_event10_standoff_defalco_shot" );
		wait( 3 );
		MissionFailed();
	}

	// FAILURE - Player Shoots Enemy Security Guard
	else if( IsDefined(level.guard_shot) )
	{
		IPrintLnBold( "FAILURE - Enemy Guard Shot by Player" );
		level thread run_scene_and_delete( "scene_event10_standoff_failure_to_shoot" );
		wait( 3 );
		MissionFailed();
	}

	// Failure - Player Did nothing
	else
	{
		IPrintLnBold( "FAILURE - Player FAILED TO DISABLE KARMA" );
		level thread run_scene_and_delete( "scene_event10_standoff_failure_to_shoot" );
		wait( 3 );
		MissionFailed();
	}
}



//
//	
karma_showdown_dialog()
{
	wait( 2 );
	iprintlnbold( "We can't Let Karma Leave the Ship, we have to stop her abduction" );
	wait( 9 );
	iprintlnbold( "Get Ready to Disable Karma, shoot her in the leg" );
}


check_for_fire_button()
{
	level.player waittill( "weapon_fired" );

	// Do a ray cast to simulate a 100% accurate bullet
	
//	start_pos = level.player GetCameraPos();
//	end_pos = AnglesToForward( level.player GetPlayerAngles() ) * 10000;
	
//	bullettrace

}


//*****************************************************************************
//*****************************************************************************

trigger_mission_success( delay )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}
	
	nextmission();
}


//*****************************************************************************
//*****************************************************************************

kill_enemy_guards()
{
	e_enemy_soldier_left = getent( "enemy_soldier_end_level_left_ai", "targetname" );
	e_enemy_soldier_right = getent( "enemy_soldier_end_level_right_ai", "targetname" );
	
	e_enemy_soldier_left.ignoreall = true;
	e_enemy_soldier_left.ignoreme = false;

	e_enemy_soldier_right.ignoreall = true;
	e_enemy_soldier_right.ignoreme = false;
	
	level.ai_harper thread shoot_at_target( e_enemy_soldier_left );
	level.ai_salazar thread shoot_at_target(e_enemy_soldier_right );
	
	level thread run_scene( "scene_event10_standoff_death_guard" );

	wait( 2 );
	
	level.ai_harper stop_shoot_at_target();
	level.ai_salazar stop_shoot_at_target();

	scene_wait( "scene_event10_standoff_death_guard" );

	e_enemy_soldier_left entity_hold_last_anim_frame( 1 );
	e_enemy_soldier_right entity_hold_last_anim_frame( 1 );
}


//*****************************************************************************
// Handles the 'shootability' state of each character shroughout the scene(s)
//*****************************************************************************

make_scene10_characters_invulnerable()
{
	// Wait for the scene to start
	wait( 0.5 );

	//*************************************
	// Make primary characters invulnerable
	//*************************************
	
	level.ai_defalco thread magic_bullet_shield();
	level.ai_salazar thread magic_bullet_shield();
	level.ai_harper thread magic_bullet_shield();
	
	e_enemy_soldier_left = getent( "enemy_soldier_end_level_left_ai", "targetname" );
	e_enemy_soldier_right = getent( "enemy_soldier_end_level_right_ai", "targetname" );
	
	e_enemy_soldier_left thread magic_bullet_shield();
	e_enemy_soldier_right thread magic_bullet_shield();
	
	//*******************************
	// Wait for the shootout to start
	//*******************************
	
	//level.ai_karma waittill( "shooot_karma_now" );
	
	level waittill( "shootout_finished" );
	
	level.ai_defalco stop_magic_bullet_shield();
	level.ai_salazar stop_magic_bullet_shield();
	level.ai_harper stop_magic_bullet_shield();
	e_enemy_soldier_left stop_magic_bullet_shield();
	e_enemy_soldier_right stop_magic_bullet_shield();
}


//*****************************************************************************
// self = level
//*****************************************************************************

check_for_shootout_end_condition()
{
	level endon ( "shootout_finished" );

	while( 1 )
	{
		// End if Karma Shot
		if( IsDefined(level.ai_karma.karma_killed_by_player) )
		{
			end_scene( "scene_event10_standoff_shoot_karma" );
			break;
		}
		
		else if( IsDefined(level.ai_defalco.defalco_shot_by_player) )
		{
			end_scene( "scene_event10_standoff_shoot_karma" );
			break;
		}
		
		else if( IsDefined(level.guard_shot) )
		{
			end_scene( "scene_event10_standoff_shoot_karma" );
			break;
		}
				
		wait( 0.01 );
	}
}


//*****************************************************************************
//*****************************************************************************

guard_shot_check_thread( str_guard_name )
{
	level endon ( "shootout_finished" );

	e_guard = getent( str_guard_name, "targetname" );
	e_guard waittill( "damage" );
	level.guard_shot = 1;
}


//*****************************************************************************
// self = karma
//*****************************************************************************

karma_shot_callback( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	//level notify( "karma_shootout_finished" );

	self.karma_killed_by_player = 0;
		
	switch( sHitLoc )
	{
		case "helmet":								// Head
		case "head":
			self.karma_killed_by_player = 1;
		break; 
	
		case "torso_upper":							// Upper Body
			self.karma_killed_by_player = 1;
		break;
		
		case "torso_lower":							// Lower Body
			self.karma_killed_by_player = 0;
		break; 
		
		case "right_arm_upper":						// Right Arm
		case "right_arm_lower":
		case "right_hand":
			self.karma_killed_by_player = 0;
		break; 
		
		case "left_arm_upper":						// Left Arm
		case "left_arm_lower":
		case "left_hand":
			self.karma_killed_by_player = 0;
		break; 

		case "right_leg_upper":						// Right Leg
		case "right_leg_lower":
		case "right_foot":
			self.karma_killed_by_player = 0;
		break; 
		
		case "left_leg_upper":						// Left Leg
		case "left_leg_lower":
		case "left_foot":
			self.karma_killed_by_player = 0;
		break;
		
		default:									// Unknown - Is it posible?
			self.karma_killed_by_player = 0;
		break;
	}

	if( self.karma_killed_by_player )
	{
		PlayFX( level._effect["karma_blood"], vPoint, vDir );
	}
	
	return( iDamage );
}


//*****************************************************************************
//*****************************************************************************

defalco_shot_check_thread()
{
	level endon ( "shootout_finished" );
	
	level.ai_defalco waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags, weapon );
	
	level.ai_defalco.defalco_shot_by_player = 1;
}


//*****************************************************************************
// Turn on the extra cam so the player can take a shot at Karma
//*****************************************************************************

//turn_on_extra_cam( delay )
//{
//	wait( delay );
//	level thread turn_on_extra_cam();
//}

//*****************************************************************************
//*****************************************************************************

start_extra_cam()
{
	level.e_extra_cam = getent( "endgame_extra_cam", "targetname" );
	if( IsDefined(level.e_extra_cam) )
	{
		// Display the extra cam as a Hud Element
		//level.hud_extra_cam  = hud_create_bar( -80, 230, 220, 220, "hud_karma_ui3d" );	// -80, 280, 170, 170
		level.hud_extra_cam = 1;
		
		level.e_extra_cam SetClientFlag( level.CLIENT_FLAG_EXTRA_CAM );
		
		// Need a small delay to allow the client script to start up
		// If we don't the client may miss the first notify
		wait( 0.1 );
		
		// Set the FOV of the extra cam based on character collision
/*
		fov_mode = "normal";
		while( 1 )
		{
			hit_character = extra_cam_character_collision_check();
			
			if( hit_character) 
			{
				if( fov_mode != "fov_zoomed_in" )
				{
					fov_mode = "fov_zoomed_in";
					clientNotify( "fov_zoomed_in" );
					//SetTimeScale( 0.2 );
				}
			}
			else
			{
				if(	fov_mode != "fov_normal" )
				{
					fov_mode = "fov_normal";
					clientNotify( "fov_normal" );
					//SetTimeScale( 1.0 );
				}
			}
			
			wait( 0.01 );
		}	
*/
	}
}


//*****************************************************************************
//*****************************************************************************

//stop_extra_cam()
//{
//	if( IsDefined(level.hud_extra_cam) )
//	{
//		level.e_extra_cam ClearClientFlag( level.CLIENT_FLAG_EXTRA_CAM );
//		//level.hud_extra_cam Destroy();
//		level.hud_extra_cam = undefined;
//	}
//}


//*****************************************************************************
//*****************************************************************************

karma_swap_to_scan_model( initial_wait, str_model )
{
	if( IsDefined(initial_wait) )
	{
		wait( initial_wait );
	}
	
	//sp_karma_scan = getent( "karma_scan", "targetname" );
	//class = sp_karma_scan.classname;
	//self getdronemodel( class );
	
	self setmodel( str_model );
}


//*****************************************************************************
//*****************************************************************************

karma_swap_back_to_normal_body( initial_wait, str_model )
{
	if( IsDefined(initial_wait) )
	{
		wait( initial_wait );
	}
	
	//sp_karma_scan = getent( "karma_scan", "targetname" );
	//class = sp_karma_scan.classname;
	//self getdronemodel( class );
	
	self setmodel( str_model );
}


//*****************************************************************************
// Do a 3 prone collision check so we stay zoomed in longer
//*****************************************************************************

extra_cam_character_collision_check()
{
	dist_ahead = ( 42*20 );

	v_dir = anglestoforward( level.player getplayerangles() );
	v_right = anglestoright( level.player getplayerangles() );
	width = (42*0.25);

	// Middle Trace
	start_pos = level.player geteye();
	end_pos = start_pos + ( v_dir * dist_ahead );
	trace1 = bullettrace( start_pos, end_pos, true, level.player );

	// Left Trace
	start_pos = level.player geteye();
	start_pos = start_pos - (v_right * width);
	end_pos = start_pos + ( v_dir * dist_ahead );
	trace2 = bullettrace( start_pos, end_pos, true, level.player );

	// Right Trace
	start_pos = level.player geteye();
	start_pos = start_pos + (v_right * width);
	end_pos = start_pos + ( v_dir * dist_ahead );
	trace3 = bullettrace( start_pos, end_pos, true, level.player );

	if( isdefined(trace1["entity"]) || isdefined(trace2["entity"]) || isdefined(trace3["entity"]))
	{
		return( 1 );
	}

	return( 0 );
}


//*****************************************************************************
// don't aproach guards
//*****************************************************************************

event10_enemy_guards()
{
	flag_wait( "final_animation_started" );

//	wait( 2 );

	sp_enemy_left = GetEnt( "enemy_soldier_end_level_left", "targetname" );
	ai_enemy_left = simple_spawn_single( sp_enemy_left );
	ai_enemy_left thread event10_enemy_guards_back_away( 0.8, "enemy_left_start_node" );

	sp_enemy_right = GetEnt( "enemy_soldier_end_level_right", "targetname" );
	ai_enemy_right = simple_spawn_single( sp_enemy_right );
	ai_enemy_right thread event10_enemy_guards_back_away( 1.3, "enemy_right_start_node" );
	
	level.defalco_baddy1 = ai_enemy_left;
	level.defalco_baddy2 = ai_enemy_right;

	a_ents = [];
	a_ents[a_ents.size] = level.defalco_baddy1;
	a_ents[a_ents.size] = level.defalco_baddy2;
	a_ents[a_ents.size] = level.ai_defalco;
	//a_ents[a_ents.size] = level.ai_karma;
	level thread enemy_guards_kill_mason_if_too_close_to_ents( a_ents, (42*4.75), (42*2.95) );
}


//*****************************************************************************
// self = enemy guard
//*****************************************************************************

event10_enemy_guards_back_away( initial_wait, str_start_node )
{
	self.ignoreall = true;
	self set_pacifist( true );
	
	self.goalRadius = 32;
	
	self.disableexits = true;
	self.disablearrivals = true;

	self.maxfaceenemydist = 1024 + 1024;
	
//	self.allow_shooting = false;
	
//	self.moveplaybackrate = 0.1;

//	self change_movemode("cqb");
//	self.walk = true;

	// Thread a target for the enemy guard to look at
	e_look_at_entity = spawn( "script_origin", (self.origin[0], self.origin[1], self.origin[2]+42) );
	
	v_alt_desired_dir = AnglesToForward( self.angles );
	VectorNormalize( v_alt_desired_dir );
	e_look_at_entity.origin = e_look_at_entity.origin + (v_alt_desired_dir * (42*4));
	
	self aim_at_target( e_look_at_entity );
	
	self thread set_aim_at_target_position( e_look_at_entity, level.player, v_alt_desired_dir );
	
	if( IsDefined(initial_wait) )
	{
		wait( initial_wait );
	}
	
	if( IsDefined(str_start_node) )
	{
		self thread event10_enemy_move_along_nodes( str_start_node );
	}
}


//*****************************************************************************
// self = entity
//*****************************************************************************

set_aim_at_target_position( e_look_at_origin, e_desired_target, v_desired_direction )
{
	self endon( "death" );
	e_desired_target endon ( "death" );

	height_inc = 42*1.5;

	while( 1 )
	{
		//*****************************************************
		// If the entity can see the desired target, look at it
		//*****************************************************
	
		start_pos = ( self.origin[0], self.origin[1], self.origin[2] + height_inc );
		end_pos = ( level.player.origin[0], level.player.origin[1], level.player.origin[2] + height_inc );
				
		e_look_at_origin.origin = end_pos;
//		self aim_at_target( e_look_at_origin );
		
/*
		trace = bullettrace( start_pos, end_pos, true, self );

		//line( start_pos, end_pos, ( 1, 0, 0 ), 1 );

		e_trace = trace["entity"];
		if( IsDefined(e_trace) && (e_trace == e_desired_target) )
		{
			e_look_at_origin.origin =  end_pos;
//			self aim_at_target( e_look_at_origin );
//			IPrintLnBold( "PLAYER" );
		}

		//****************************************************************		
		// We can't see the desired target so look down the desired vector
		//****************************************************************
		
		else
		{

//			pos = start_pos + (v_desired_direction * (42*2));

			dir = vectornormalize( end_pos - start_pos );
			pos = start_pos + ( dir * (42*10) );
						
			e_look_at_origin.origin = pos;
//			self aim_at_target( e_look_at_origin );
//			IPrintLnBold( "NO" );
		}
*/

		//line( start_pos, e_look_at_origin.origin, ( 0, 1, 0 ), 1 );

		wait( 0.01 ); 
	}
}


//*****************************************************************************
// self = entity
//*****************************************************************************

event10_enemy_move_along_nodes( str_target_node )
{
	node = GetNode( str_target_node, "targetname" );
	while( IsDefined(node) )
	{
		self setgoalnode( node );
		self waittill( "goal" );

		//IPrintLnBold( "Node wait" );
		wait( 1 );
		
		if( IsDefined(node.target) )
		{		
			node = GetNode( node.target, "targetname" );
		}
		else
		{
			break;
		}
	}	
}


//*****************************************************************************
// If the player gets too close to any of these ents, kill him
//*****************************************************************************

enemy_guards_kill_mason_if_too_close_to_ents( a_ents, nag_distance, kill_distance )
{
	//level endon( "karma_shootout_finished" );

	vo_time_last_nag = 0;
	vo_time_nag_gap = 2.8;
	
	while( a_ents.size )
	{
		time = GetTime();

		// Check all the ai characters in the array are still alive
		for( i=0; i<a_ents.size; i++ )
		{
			if( a_ents[i].health <= 0 )
			{
				a_ents = array_remove( a_ents, a_ents[i] );
			}
		}
			
		// Get the entity target distances, only want to do this once
		a_dist = [];
		for( i=0; i<a_ents.size; i++ )
		{
			e_target = a_ents[ i ];
			a_dist[a_dist.size] = Distance( e_target.origin, level.player.origin );
		}
	
		// Kill Mason and mission failure if he gets too close
		for( i=0; i<a_ents.size; i++ )
		{
			if( a_dist[i] < kill_distance )
			{
				guards_kill_mason_mission_over( 0, 2 );
				return;
			}
		}
	
		// Give a VO Waring to Mason if he's getting too close
		dt = ( time - vo_time_last_nag ) /1000;
		if( dt >= vo_time_nag_gap )
		{
			for( i=0; i<a_ents.size; i++ )
			{
				if( a_dist[i] < nag_distance )
				{
					e_target = a_ents[ i ];
					level.ai_defalco thread say_dialog( "mason_stay_back", 0.01 );
					vo_time_last_nag = time;
					break;
				}	
			}
		}
		
		wait( 0.01 );
	}
}


//*****************************************************************************
//*****************************************************************************

guards_kill_mason_mission_over( guards_attack_wait, failure_wait )
{
	level.player endon( "death" );

	level.defalco_baddy1 guard_kill_target( level.player, guards_attack_wait );
	level.defalco_baddy2 guard_kill_target( level.player, guards_attack_wait );
	
	wait( failure_wait );

	MissionFailed();
}


//*****************************************************************************
// self = guard
//*****************************************************************************

guard_kill_target( e_target, guards_attack_wait )
{
	self.health = 99999;
	
	if( IsDefined(guards_attack_wait) )
	{
		wait( guards_attack_wait );
	}
	
	self.ignoreall = false;
	self set_pacifist( false );	
	self thread shoot_at_target( e_target, undefined, undefined, -1 );
}


//*****************************************************************************
//*****************************************************************************

#using_animtree( "animated_props" );
launch_escape_vehicle( delay )
{
	e_launcher = getent( "defalco_boat_end", "targetname" );
	level.launch_escape_vehicle = e_launcher;

	e_launcher.takedamage = true;
	e_launcher.health = 10000;
	e_launcher thread launcher_check_for_damage();
	
	wait( 12 );	// 5

	// Play animation of door closing
	level.launch_escape_vehicle UseAnimTree(#animtree);
	level.launch_escape_vehicle SetAnim( %o_karma_10_1_boat_close );

	wait( 2 );	// 3
	
	// Door is closed, now we can now kill Defalco
	level.ai_defalco delete();
	
	// Make the Scrit Model an entity that weapons can lock onto
	v_offset = ( 0, 0, 50 );
	Target_Set( e_launcher, v_offset );
	maps\_heatseekingmissile::SetMinimumSTIDistance( 100 );


	// Move the Launch Vehicle

	//IPrintLnBold( "Launch Vehicle" );
	
	//move_time = 10;
	//forward = AnglesToForward( e_launcher.angles );
	//target_pos = e_launcher.origin + (forward * (42*100) );
	//e_launcher moveto( target_pos, move_time );

	e_launcher thread launch_vehicle_move( "escape_plane_path_start" );
}
#using_animtree( "generic_human" );


//*****************************************************************************
//*****************************************************************************

// self = launcher vehicle
launcher_check_for_damage()
{
	while( 1 )
	{
		self waittill( "damage", amount, attacker, direction_vec, damage_ori, type ); 
	
		if( IsDefined(type) && (type == "MOD_PROJECTILE") )
		{
			// Only the player could have done this, so blow him up
			IPrintLnBold( "Got HIM!!!!!" );
	
			mag = (42*4);		// 42*2
	
			for( i=0; i<5; i++ )
			{
				pos = ( self.origin[0] + RandomFloatRange(-mag, mag), 
						self.origin[1] + RandomFloatRange(-mag, mag),
						self.origin[2] + RandomFloatRange(-mag, mag) );
		
				self PlaySound ("exp_metalstorm_damage");
				playfx( level._effect["def_explosion"], pos );
				wait( 0.15 );
			}

			break;
		}
	}
	
	self delete();
}


//*****************************************************************************
//*****************************************************************************

launch_raise_player_perk_weapon()
{
	wait( 11 );	// 12
	
	//get_players()[0] GiveWeapon("rocket_barrage_sp");

	// Give the player the pistol weapon
	level.player GiveWeapon( "m1911_sp" );
	
	if( IsDefined( level.player.has_stinger) )
	{
		level.player GiveWeapon( "stinger_sp" );
	}

	level.player SwitchToWeapon( "m1911_sp" );
	//level.player SwitchToWeapon( "stinger_sp" );
	
	wait( 7 );	// 6
	
	// Take away the weapon again
	level.player take_weapons();
}


//*****************************************************************************
//*****************************************************************************

launch_vehicle_move( str_start_node_name )
{
	self endon( "death" );

	node = GetVehicleNode( str_start_node_name, "targetname" );

	pos = self.origin;
	dir = AnglesToForward( self.angles );
	
	dir = node.origin - self.origin;
	dir = vectornormalize( dir );
	
	current_speed = 0;
	accel = 2.5;
	
	index = 0;
	while( IsDefined(node) )
	{
		//IPrintLnBold( "PATH INDEX: " + index );

		required_speed = get_launcher_speed( index );
		turnrate = get_launcher_turnrate( index );
		
		required_angles = get_launcher_angles( index );
		
		index++;
	
		while( 1 )
		{
			if( current_speed < required_speed )
			{
				current_speed += accel;
				if( current_speed > required_speed )
				{
					current_speed = required_speed;
				}
			}
			else if( current_speed > required_speed )
			{
				current_speed -= accel;
				if( current_speed < required_speed )
				{
					current_speed = required_speed;
				}
			}
			
		
			//temp_launcher_angles( self, required_angles, turnrate );
		
			dir = node.origin - self.origin;
			dir = vectornormalize( dir );

			self.origin = self.origin + (dir * current_speed);
		
			dist = distance( self.origin, node.origin );
			if( dist < (42*1) )
			{
				break;
			}
			
			node_dir = AnglesToForward( node.angles );
			dot = vectordot( node_dir, dir );
			if( dot < 0.2 )
			{
				break;
			}
			
			wait( 0.01 );
		}
		
		//**********
		// Next node
		//**********
		
		if( IsDefined(node.target) )
		{		
			node = GetVehicleNode( node.target, "targetname" );
		}
		else
		{
			break;
		}
	
		wait( 0.01 );
	}	

	IPrintLnBold( "Launcher at End of Path" );
}

temp_launcher_angles( ent, required_angles, inc )
{
	hdg = ent.angles[0];
	pitch = ent.angles[1];
	roll = ent.angles[2];
	
	if( hdg > required_angles[0] )
	{
		hdg -= inc;
		if ( hdg < required_angles[0] )
		{
			 hdg = required_angles[0];
		}
	}
	else if( hdg < required_angles[0] )
	{
		hdg += inc;
		if ( hdg > required_angles[0] )
		{
			 hdg = required_angles[0];
		}
	}

	if( pitch > required_angles[1] )
	{
		pitch -= inc;
		if ( pitch < required_angles[1] )
		{
			 pitch = required_angles[1];
		}
	}
	else if( pitch < required_angles[1] )
	{
		pitch += inc;
		if ( pitch > required_angles[1] )
		{
			 pitch = required_angles[1];
		}
	}

	if( roll > required_angles[2] )
	{
		roll -= inc;
		if ( roll < required_angles[2] )
		{
			 roll = required_angles[2];
		}
	}
	else if( roll < required_angles[2] )
	{
		roll += inc;
		if ( roll > required_angles[2] )
		{
			 roll = required_angles[2];
		}
	}

	ent.angles = ( hdg, pitch, roll );
}


get_launcher_speed( index )
{
	speed = 50;

	switch( index )
	{
		case 0:
			speed = 50;		// 50
		break;
		
		case 1:
			speed = 80;		// 100
		break;

		case 2:
			speed = 100;	// 120
		break;

		case 3:
			speed = 100;	// 120
		break;

		case 4:
			speed = 100;	// 120
		break;

		case 5:
			speed = 100;	// 120
		break;

		case 6:
			speed = 100;	// 120
		break;

		case 7:
			speed = 100;	// 120
		break;

		default:
			speed = 100;	// 120
		break;
		
	}
	
	return( speed );
}


get_launcher_angles( index )
{
	angles = (0,0,0);

	switch( index )
	{
		case 0:
			angles = (0,150,0);
		break;
		
		case 1:
			angles = (40,150,0);
		break;

		case 2:
			angles = (0,150,0);
		break;

		case 3:
			angles = (0,150,0);
		break;

		case 4:
			angles = (0,150,0);
		break;

		case 5:
			angles = (0,150,0);
		break;

		case 6:
			angles = (0,150,0);
		break;

		case 7:
			angles = (0,150,0);
		break;

		default:
			angles = (0,150,0);
		break;
		
	}
	
	return( angles );
}

get_launcher_turnrate( index )
{
	turn = 5;

	switch( index )
	{
		case 0:
			turn = 0.8;
		break;
		
		case 1:
			turn = 0.8;
		break;

		case 2:
			turn = 0.8;
		break;

		case 3:
			turn = 0.8;
		break;

		case 4:
			turn = 0.6;
		break;

		case 5:
			turn = 0.4;
		break;

		case 6:
			turn = 0.2;
		break;

		case 7:
			turn = 0.2;
		break;

		default:
			turn = 5;
		break;
		
	}
	
	return( turn );
}


