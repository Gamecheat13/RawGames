#include common_scripts\utility;
#include maps\_utility;
#include maps\karma_util;
#include maps\_objectives;
#include maps\_scene;
#include maps\_anim;
#include maps\_glasses;
#include maps\_vehicle;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


/* ------------------------------------------------------------------------------------------
    INIT functions
-------------------------------------------------------------------------------------------*/
//
//	Declare event-specific flags here
init_flags()
{
	flag_init( "scanner_on" );
	flag_init( "scanner_off" );
	flag_init( "player_receptionist" );
	flag_init( "team_at_tower" );
	flag_init( "alarm_on" );
	flag_init( "security_alert" );
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
skipto_checkin()
{
	level.ai_harper 		= init_hero( "harper", ::attach_briefcase );
	level.ai_han 			= init_hero( "han", ::attach_briefcase );
	level.ai_salazar		= init_hero( "salazar", ::attach_briefcase );
	level.ai_redshirt1		= init_hero( "redshirt1", ::attach_briefcase );
	level.ai_redshirt2		= init_hero( "redshirt2", ::attach_briefcase );

	//playing vstol sounds
	playsoundatposition ("veh_vtol_1" , (6062, -11630, 1175));
	playsoundatposition ("veh_vtol_2" , (6542, -11186, 1191));
	
	start_teleport( "skipto_checkin" );

	level thread maps\createart\karma_art::karma_fog_intro();
}


skipto_tower_lift()
{
	level.ai_harper 	= init_hero( "harper" );
	level.ai_han 		= init_hero( "han" );
	level.ai_salazar	= init_hero( "salazar" );
	level.ai_redshirt1	= init_hero( "redshirt1" );
	level.ai_redshirt2	= init_hero( "redshirt2" );

	start_teleport( "skipto_tower_lift" );
	
	a_ai_workers = simple_spawn( "explosives_workers" );
	foreach( ai_worker in a_ai_workers )
	{
		add_cleanup_ent( "checkin", ai_worker );
	}

	// dynamic ads
	run_thread_on_targetname( "dynamic_ad", ::dynamic_ad_swap );

	maps\karma_anim::checkin_anims();
}


/* ------------------------------------------------------------------------------------------
	MAIN functions * 
-------------------------------------------------------------------------------------------*/
//
//	NOTE: This is a blocking function call.  When this function ends, the next function in
//	your skipto sequence will be called.
checkin()
{
	// Temp Development info
	/#
		IPrintLn( "Check-in" );
	#/
	t_obj_lift = GetEnt( "trig_tower_lift", "targetname" );
	set_objective( level.OBJ_SECURITY, t_obj_lift );
	checkin_anims();

	
	// Turn off HUD
	level.player hide_hud();

	// Initialization
	a_ai_tarmac_workers 	= simple_spawn( "tarmac_workers", ::play_anim_and_idle, "checkin" );
	a_ai_security 			= simple_spawn( "checkin_security", ::play_anim_and_idle, "checkin" );
	a_ai_explosives_workers = simple_spawn( "explosives_workers", ::play_anim_and_idle, "checkin" );
	
	level thread setup_tarmac_worker_animation();
	level thread setup_security_worker_animation();
	level thread setup_explosive_worker_animation();
	level thread setup_vtol();
	//level thread run_scene("worker_01_intro);
	
	// Additional event logic
	
//	set_screen_fade_shader( "white" );
	
	exploder( 101 );
	
	
	level thread scanner_backdrop();
	level thread scanner_scenes( a_ai_explosives_workers, a_ai_security );
	level thread checkin_cleanup();

	// dynamic ads
	run_thread_on_targetname( "dynamic_ad", ::dynamic_ad_swap );
	long_walk();
	
}

setup_vtol()
{
	vtol_player = spawn_vehicle_from_targetname("player_vtol");
	regular_vtol = spawn_vehicle_from_Targetname("regular_vtol");
	nd_flyby_start = GetVehicleNode("vtol_top_deck_flyby", "targetname");
	
	
	
	add_cleanup_ent("checkin", regular_vtol);

	trigger_wait("start_vtol_flyby");
	
	regular_vtol thread setup_amb_vtol("vtol_amb_flyby");
	
	vtol_player go_path(nd_flyby_start);
	vtol_player waittill("reached_end_node");
	wait(0.05);
	vtol_player delete();
	
}

setup_amb_vtol( nd_targetname )
{
	self endon("death");
	
	nd_start = GetVehicleNode(nd_targetname, "targetname");
	self go_path(nd_start);
}


setup_tarmac_worker_animation()
{
	run_scene_and_delete("worker_01_intro");
	run_scene_and_delete("worker_01_idle");
}

setup_security_worker_animation()
{
	run_scene_and_delete("security_01_idle");
}

setup_explosive_worker_animation()
{
	run_scene_and_delete("explosives_worker1_intro");
	run_scene_and_delete("explosives_worker1_idle");
	
}

//
//	The team splits up to enter 2 different elevators
tower_lift()
{
	// Temp Development info
	/#
		IPrintLn( "Tower Lift" );
	#/

		// Harper, Salazar and the player take the left elevator
		// Han and 2 others go to the right.
		
	level.sound_elevator_ent_1 = spawn( "script_origin", level.player.origin );
	level.sound_elevator_ent_2 = spawn( "script_origin", level.player.origin );
	
	level thread player_group_think();
	level thread han_group_think();

	flag_wait( "inside_tower_lift" );
	
	level thread maps\createart\karma_art::karma_fog_elevator();
	
	scene_wait( "tower_lift_workers_run" );

	level thread tower_cleanup();
	
//	level thread checkin_towerlift_scene_cleanup();
}


/* ---------------------------------------------------------------------------
 * CHECKIN
 * --------------------------------------------------------------------------- */
long_walk()
{
	flag_set( "player_among_civilians" );
	//-------------------------------------------------------------------------------------------------
	// Slow down player speed to friendlies walk cycle.
	//-------------------------------------------------------------------------------------------------
	setsaveddvar("g_speed", 110);
	
	//-------------------------------------------------------------------------------------------------
	// Background noise during white_out overlay here.
	//-------------------------------------------------------------------------------------------------
	level thread maps\createart\karma_art::karma_fog_intro();	
//    SetDvar( "r_exposureTweak", 1 );
//    SetDvar( "r_exposureValue", 2 );
	
	
	flag_wait( "starting final intro screen fadeout" );
	// Fade In
	
	//iprintlnbold("Loud VTOL engine playing in the background, etc.");	
	
	//sounds started in FN skipto_checkin()

	//-------------------------------------------------------------------------------------------------
	// Animation of player putting on glasses.  This should take no longer than 10 seconds.
	//-------------------------------------------------------------------------------------------------
	
	level thread glasses_scene();
	//---------------------------------------------------------------------------------------------
	// Resevoir Dogs moment
	//-------------------------------------------------------------------------------------------------
	run_scene_and_delete( "team_walk_intro" );
	
	level thread run_scene_and_delete( "team_intro_idle" );
	
	flag_wait( "t_proceed_scanner" );
	
	level thread checkin_amb_civ();
	
	walk_to_reception();
	flag_wait( "t_proceed_tower" );
	
	flag_set( "player_receptionist" );
	walk_to_elevator();
	//triggering crowd fx below the elevator.
	exploder( 330 );
	exploder( 331 );
	
	
	//run_scene_and_delete("section_walk_3");
}
walk_to_reception()
{
	level thread security_guard_animation();
	level thread redshirt_group_reception_animation();
	//blocking call.
	main_group_reception_animation();
	
}
security_guard_animation()
{
	level thread run_scene_and_delete("section_walk_2_1_security");
}
redshirt_group_reception_animation()
{
	run_scene_and_delete("section_walk_2_1_redshirt");
	run_scene_and_delete("section_idle_2_1_redshirt");
}
main_group_reception_animation()
{
	//walk to reception
	run_scene_and_delete("section_walk_2_1");
	//idle at reception
	level thread run_scene_and_delete("section_idle_2_1");
}
walk_to_elevator()
{
	
	level thread main_group_elevator_animation();
	
	//blocking call, longest animation
	level thread hans_elevator_animation();
	redshirt_group_elevator_animation();
	
}
redshirt_group_elevator_animation()
{
	run_scene_and_delete("section_walk_3_redshirt");
//	level thread run_scene_and_delete("tower_lift2_wait");
}
main_group_elevator_animation()
{
	run_scene_and_delete("section_walk_3");
//	level thread run_scene_and_delete("tower_lift_wait");
}

hans_elevator_animation()
{
	run_scene_and_delete("section_walk_3_hans");
	level thread run_scene_and_delete("tower_lift2_hans_wait");
}

glasses_scene()
{
	
	level thread maps\createart\karma_art::karma_fog_default( 3 );
	level thread reduce_exposure_overtime( 3 );
	//SetSavedDvar( "r_lightTweakSunLight", 50 );
	//level.player setviewmodelrenderflag( true );
	//setdvar("r_znear", 1);

	glasses = spawn("script_model", (0, 0, 0) );
	glasses setmodel("p6_sunglasses");
	glasses.animname = "glasses";
	glasses.targetname = "glasses";
	glasses setviewmodelrenderflag( true );
	run_scene_and_delete( "player_put_on_glasses" );
	//setdvar("r_znear", 4);
	//SetSavedDvar( "r_lightTweakSunLight", 25 );
	
	level.player show_hud();
	LUINotifyEvent( &"hud_shades_bootup" );
}
reduce_exposure_overtime( time )
{
	
	
	SetDvar( "r_exposureValue", 2.75 );
	wait(3.1);
	SetDvar( "r_exposureValue", 1 );
//	default_exp_value = .75;
//	current_value = 2;
//	decrement = (2 - .75) / (time * 20);
//	time_passed = 0;
//	while(1)
//	{
//		new_value = current_value - (time_passed * decrement * 20);
//		SetDvar( "r_exposureValue", new_value);
//		wait(0.05);
//		time_passed += 0.05;
//
//		if(time_passed >= time)
//			break;
//	}
//	//SetDvar( "r_exposureTweak", 1 );
//	SetDvar( "r_exposureValue", 0.75 );
}

walk_anim_part_two( n_section, n_ai_index )
{
	run_scene_and_delete( "section_walk_" + n_section + "_" + n_ai_index );
	
	level thread run_scene_and_delete( "section_idle_" + n_section + "_" + n_ai_index );
	
//	flag_set( "section_" + n_section + "_done" );
	
}

// Extra function call in case
walk_anim_part_three( n_section, n_ai_index )
{
	run_scene_and_delete( "section_walk_" + n_section + "_" + n_ai_index );
	
//	level thread run_scene_and_delete( "section_idle_" + n_section + "_" + n_ai_index );
}

team_badge_clearance()
{
	flag_wait( "player_receptionist" );

	run_scene( "receptionist_a_talk" );
	receptionists = get_ais_from_scene("receptionist_a_talk");
	
	foreach( receptionist in receptionists)
	{
		add_cleanup_ent( "checkin", receptionist );
	}
	delete_scene( "receptionist_a_talk" );
	
	run_scene_and_delete( "receptionist_idles" );
}


player_group_walk_test()
{
	walkanim = "teamate_walk";
	nd_tower_left = GetNode( "nd_tower_left", "targetname" );
	nd_tower_harper = GetNode( "nd_tower_harper", "targetname" );
	nd_tower_salazar = GetNode( "nd_tower_salazar", "targetname" );
	
	level.ai_harper set_run_anim( walkanim, true );
	level.ai_harper setgoalnode( nd_tower_harper );
	level.ai_salazar set_run_anim( walkanim, true );
	level.ai_salazar setgoalnode( nd_tower_salazar );
}

han_group_walk_test()
{
	walkanim = "teamate_walk";
	nd_tower_right = GetNode( "nd_tower_right", "targetname" );
	nd_tower_redshirt1 = GetNode( "nd_tower_redshirt1", "targetname" );
	nd_tower_redshirt2 = GetNode( "nd_tower_redshirt2", "targetname" );
	nd_tower_han = GetNode( "nd_tower_han", "targetname" );
	
	level.ai_redshirt1 set_run_anim( walkanim, true );
	level.ai_redshirt1 setgoalnode( nd_tower_redshirt1 );
	level.ai_redshirt2 set_run_anim( walkanim, true );
	level.ai_redshirt2 setgoalnode( nd_tower_redshirt2 );
	level.ai_han set_run_anim( walkanim, true );
	level.ai_han setgoalnode( nd_tower_han );
}

//
//	Play an intro idle and then an idle anim if they exist.
//	self is an AI
play_anim_and_idle( str_event )
{
	Assert( IsDefined( self.script_animname ), "Add an animname to the guy at " + self.origin );

//	self thread print3d_ent( "animname", (0,0,32), undefined, "inside_tower_lift" );
	add_cleanup_ent( str_event, self );
	if ( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "scanner" )
	{
		self thread scanner_model_swap();
	}
	
//	intro anim
//	str_scene_name = self.script_animname + "_intro";
//	if ( is_scene_defined( str_scene_name ) )
//	{
//		run_scene_and_delete( str_scene_name );
//	}
//
//	// idle anim
//	str_scene_name = self.script_animname + "_idle";
//	if ( is_scene_defined( str_scene_name ) )
	//    {
//		run_scene_and_delete( str_scene_name );
	//    }
}

//
//	Swap the character models when the player can't see them
scanner_model_swap()
{
	self endon( "death" );
	level endon( "inside_tower_lift" );

	self.model_original = self.model;
	self ent_flag_init( "in_scanner" );
	self ent_flag_wait( "in_scanner" );
	
	while (1)
	{
		flag_wait( "scanner_on" );

		//TODO need different models for different characters
		//self Detach( self.headmodel );
		
		if( self.targetname == "checkin_security_ai" )
		{
			self SetModel( "c_usa_jungmar_bowman_fb" );
		}
		else
		{
			self SetModel( "c_mul_jinan_demoworker_bscatter_fb" );
		}
		flag_wait( "scanner_off" );

		self SetModel( self.model_original );
		//self Attach( self.headmodel );
	}
}

//
//	Notetrack function.  Let's us know when the AI is in the scanner
inside_scanner( guy )
{
	
//	if( !guy ent_flag_exist( "in_scanner" ) )
//	{
//		guy ent_flag_init( "in_scanner" );
//	}
//
	guy ent_flag_set( "in_scanner" );
	
	flag_set( "alarm_on" );
	
	ClientNotify ("alarm_on");
}

//
//	Control when the backdrop appears depending on the player's position
scanner_backdrop()
{
	level endon( "inside_tower_lift" );
	
	bm_backdrop = GetEnt( "scanner_backdrop", "targetname" );
	e_vol_backdrop = GetEnt( "vol_scanner", "targetname" );
	while (1)
	{
		// Backdrop off
		bm_backdrop trigger_off();
		flag_clear( "scanner_on" );
		flag_set( "scanner_off" );
		while( !level.player IsTouching( e_vol_backdrop ) )
		{
			wait( 0.1 );
		}

		// Backdrop on
		bm_backdrop trigger_on();
		flag_clear( "scanner_off" );
		flag_set( "scanner_on" );
		while( level.player IsTouching( e_vol_backdrop ) )
		{
			wait( 0.1 );
		}
	}
}

//
//	Workers drop stuff, then packup until the player enters the scanner, then continue into the scanner
//	and get picked up for explosive residue
scanner_scenes( a_ai_explosives_workers, a_ai_security )
{
	bm_clip = GetEnt( "clip_scanner_blocker", "targetname" );
	bm_clip trigger_off();
	
	trigger_wait( "trig_enter_scanner" );
	
	bm_clip trigger_on();
	
	level thread run_scene( "receptionist_idles" );
	level thread team_badge_clearance();
	
	level thread run_scene_and_delete( "explosives_workers_enter_scanner" );  // Thread in order for pings to show
	
	// Add pings
	foreach( ai_worker in a_ai_explosives_workers )
	{
		PlayFXOnTag( level._effect["scanner_ping"], ai_worker, "J_Ankle_LE" );
		PlayFXOnTag( level._effect["scanner_ping"], ai_worker, "J_Ankle_RI" );
	}
	
	foreach( ai_security in a_ai_security )
	{
		if ( IsDefined( ai_security.script_noteworthy ) && ai_security.script_noteworthy == "scanner" )
		{
			PlayFXOnTag( level._effect["scanner_ping"], ai_security, "TAG_WEAPON_RIGHT" );
			
			m_gun_tag_origin = Spawn( "script_model", ai_security.origin ); //Important
			m_gun_tag_origin SetModel( "t6_wpn_pistol_fiveseven_world_detect" ); //Important
			m_gun_tag_origin LinkTo( ai_security, "TAG_WEAPON_RIGHT", ( 0, 0, 0 ) );
			m_gun_tag_origin thread cleanup_red_guns();
		}
	}

	level thread player_side_blocker();
	
	flag_set( "security_alert" );
	run_scene_and_delete( "explosives_workers_enter_scanner_alert" );
	
	//level thread run_scene( "security_05_post_alert_idle" );
	level thread run_scene_and_delete( "security_05_post_alert_idle" );
	level thread run_scene( "security_04_post_alert_idle" );
	
	/#
		scott_b_shader_test();
	#/
		
		
	
	
}


scott_b_shader_test()
{
	security = getentarray("checkin_security_ai", "targetname");
	worker = getentarray("explosives_workers_ai", "targetname");
	
	security[1] player_fudge_moveto( (5252, -9340, 972));
	security[1] SetGoalPos(security[1].origin);
	
	worker[0] player_fudge_moveto( (5260, -9460, 972));
	worker[0] SetGoalPos(worker[0].origin);
	
	
	
}

cleanup_red_guns()
{
	flag_wait( "security_alert" );
	
	wait 19;

	self unlink();
	self delete();
}

//
//	Have the security guard for your side move you along.  Nothing to see here.
player_side_blocker()
{
	
	level endon("inside_tower_lift");
	//run_scene_and_delete( "security_01_enter_scanner_alert" );
	//level thread run_scene_and_delete( "security_01_post_alert_idle" );

	while ( true )
	{
		trigger_wait( "trig_enter_scanner" );
		
		end_scene( "security_01_post_alert_idle" );
		
		run_scene( "security_01_post_alert_point" );
		level thread run_scene( "security_01_post_alert_idle" );
		wait( 3.0 );
	}
}


//
//	Change
dynamic_ad_swap()
{
	level endon( "inside_tower_lift" );
	CONST n_range = 128*128;	// distance squared where you want the swap to happen
	in_range = false;
	
	// Set the bit only when the state changes, don't spam it.
	while ( 1 )
	{
		n_dist = DistanceSquared( self.origin, level.player.origin );
		if ( n_dist < n_range && !in_range )
		{
			in_range = true;
			self SetClientFlag( level.CLIENT_FACE_SWAP );
		}
		else if ( n_dist > n_range && in_range )
		{
			in_range = false;
			self ClearClientFlag( level.CLIENT_FACE_SWAP );
		}
		wait( 0.05 );
	}
}


/* ---------------------------------------------------------------------------
 * TOWER LIFT
 * --------------------------------------------------------------------------- */

//
//	Harper and Salazar walk toward their lift, get in and brush off the workers.
player_group_think()
{
	bm_lift_left  = GetEnt( "tower_lift_left",  "targetname" );

	e_align = GetEnt( "align_player", "targetname" );
	e_align LinkTo( bm_lift_left );

	// This is necessary to keep the guys connected to the elevator
	// Link the AI to this model and they will animate fine
	m_tag_origin = Spawn( "script_model", e_align.origin );
	m_tag_origin SetModel( "tag_origin" );
	m_tag_origin.angles = e_align.angles;
	m_tag_origin LinkTo( e_align );

	bm_player_clip = GetEnt( "clip_tower_lift_top", "targetname" );
	bm_player_clip trigger_off();
	
//	level thread run_scene_and_delete( "section_idle_3_1" );
//	level thread run_scene_and_delete( "section_idle_3_2" );
	
	level thread run_scene_and_delete( "tower_lift_wait" );
	//run_scene_and_delete_first_frame("tower_lift_enter");
	// When the player gets near, open the doors
	flag_wait( "near_tower_lift" );
	
	bm_lift_left  thread elevator_move_doors( true, 2.0, 0.5, 0.5 );
	// Open the outer doors too
	m_outer_left  = GetEnt( "door_outer_elevator_1left", "targetname" );
	m_outer_right = GetEnt( "door_outer_elevator_1right", "targetname" );
	m_outer_left  MoveX( -38, 2.0, 0.5, 0.5 );
	m_outer_right MoveX( 38, 2.0, 0.5, 0.5 );
	
	// SOUND - Shawn J
	//iprintlnbold ("doors_open_1");
	//level.player playsound ("amb_elevator_open");
	playsoundatposition ("amb_elevator_open", (5062, -7237, 748));
	
	wait( 1.0 );

	run_scene_and_delete( "tower_lift_enter" );
	level thread run_scene_and_delete( "tower_lift_enter_wait" );

	// Wait until the player is inside, then Harper goes in	and workers run up
	flag_wait( "inside_tower_lift" );

	set_objective( level.OBJ_SECURITY, undefined, "done" );

	bm_player_clip trigger_on();
	level thread run_scene_and_delete( "tower_lift_workers_run" );
	
	//TODO ANIM NOTETRACK: close the door when the workers are near
	wait( 3.0 );
	bm_lift_left  thread elevator_move_doors( false, 2.0, 0.5, 0.5 );
	m_outer_left  MoveX( 38, 2.0, 0.5, 0.5 );
	m_outer_right MoveX( -38, 2.0, 0.5, 0.5 );
	
	// SOUND - Shawn J
	//iprintlnbold ("doors_close_1");
	//level.player playsound ("amb_elevator_close");
	playsoundatposition ("amb_elevator_close", (5062, -7237, 748));

	// Lock AI in place
	scene_wait( "tower_lift_workers_run" );

	// Adjust player walking speed back to normal
	setsaveddvar("g_speed", 190);
	
	// Turn off ambient fx
	stop_exploder( 101 );
	
	level thread run_scene_and_delete( "tower_lift_descent_wait" );
	level.ai_harper LinkTo( m_tag_origin, "tag_origin" );
	level.ai_salazar LinkTo( m_tag_origin, "tag_origin" );

	scene_wait( "tower_lift2_enter" );
	
	// Descend
	s_destination = GetStruct( "tower_lift_left_bottom", "targetname" );
	
	// SOUND - Shawn J
	//iprintlnbold ("going_down");
	clientnotify( "sbpv" );
	level.player playsound ("amb_elevator_start");
	level.sound_elevator_ent_1 playloopsound( "amb_elevator_loop", 1 );

	bm_lift_left SetMovingPlatformEnabled();
	bm_lift_left MoveTo( s_destination.origin, 15, 3.0, 2.0 );
	bm_lift_left waittill( "movedone" );

	// Now teleport to the lobby
	s_dest = GetStruct( "lobby_lift_left", "targetname" );
	bm_lift_left MoveTo( s_dest.origin, 0.05 );

	// wait for teleport done and lobby stuff started
	wait( 0.1 );
	autosave_by_name( "karma_lobby" );
}


//
// Han's group waits for the right elevator, which doesn't arrive until the player gets inside.
han_group_think()
{
	bm_lift_right = GetEnt( "tower_lift_right", "targetname" );

	e_align = GetEnt( "align_han", "targetname" );
	e_align LinkTo( bm_lift_right );

	// This is necessary to keep the guys connected to the elevator
	// Link the AI to this model and they will animate fine
	m_tag_origin = Spawn( "script_model", e_align.origin );
	m_tag_origin SetModel( "tag_origin" );
	m_tag_origin.angles = e_align.angles;
	m_tag_origin LinkTo( e_align );
	
//	level thread run_scene_and_delete( "section_idle_3_3" );
//	level thread run_scene_and_delete( "section_idle_3_4" );
//	level thread run_scene_and_delete( "section_idle_3_5" );

	level thread run_scene_and_delete( "tower_lift2_wait" );
	//level thread run_scene_and_delete_first_frame("tower_lift2_enter");
	
	// Wait until the player is inside
	flag_wait( "inside_tower_lift" );

	bm_lift_right thread elevator_move_doors( true, 2.0, 0.5, 0.5 );
	// Open the outer doors too
	m_outer_left  = GetEnt( "door_outer_elevator_2left", "targetname" );
	m_outer_right = GetEnt( "door_outer_elevator_2right", "targetname" );
	m_outer_left  MoveX( -38, 2.0, 0.5, 0.5 );
	m_outer_right MoveX( 38, 2.0, 0.5, 0.5 );

	// Enter elevator,
	//TODO ANIM then Han tests out his Comm interface
	//TODO ANIM NOTETRACK: close the door when the workers are near
	run_scene_and_delete( "tower_lift2_enter" );
	
	level thread load_gump( "karma_gump_hotel" );
	level thread run_scene_and_delete( "tower_lift2_descent_wait" );
	
	// Stagger elevator.
	//wait 0.25;
	
	bm_lift_right thread elevator_move_doors( false, 2.0, 0.5, 0.5 );
	m_outer_left  MoveX( 38, 2.0, 0.5, 0.5 );
	m_outer_right MoveX( -38, 2.0, 0.5, 0.5 );
	
	wait( 2.0 );
	
	// Descend
	level.ai_han 	LinkTo( m_tag_origin, "tag_origin" );
	level.ai_redshirt1	LinkTo( m_tag_origin, "tag_origin" );
	level.ai_redshirt2	LinkTo( m_tag_origin, "tag_origin" );
	
	// Turn on Glass-cam for Han
	level thread han_glasses_scene();

	s_destination = GetStruct( "tower_lift_right_bottom", "targetname" );
	bm_lift_right SetMovingPlatformEnabled();
	
	bm_lift_right MoveTo( s_destination.origin, 9.5, 0.0, 2.0 );
}


//tt
//	Han talks to the player via the glasses
han_glasses_scene()
{
	// Attach camera to Han's eyes
	
	// SOUND - Shawn J
	//iprintlnbold ("picture_in_picture_on");
	level.player playsound ("evt_pnp_on");
	level.sound_elevator_ent_2 playloopsound( "evt_pnp_loop", 1 );
	
	//v_han_eyes = level.ai_han GetEye();
	v_han_eyes = level.ai_han GetTagOrigin( "J_EyeBall_RI" );
	level.e_extra_cam = get_extracam();
	level.e_extra_cam.origin = v_han_eyes;
	level.e_extra_cam.angles = level.ai_han.angles;
	level.e_extra_cam LinkTo( level.ai_han, "J_EyeBall_RI" );
	turn_on_extra_cam();
	wait( 10.0 );

	turn_off_extra_cam();
	
	// SOUND - Shawn J
	//iprintlnbold ("picture_in_picture_off");
	level.player playsound ("evt_pnp_off");
	level.player playsound ("amb_elevator_stop");
	level.sound_elevator_ent_1 stoploopsound ();
	level.sound_elevator_ent_2 stoploopsound ();
	
	level.e_extra_cam Unlink();
}


//
//	Cleanup anything from the checkin section
checkin_cleanup()
{
	scene_wait( "tower_lift_workers_run" );
	
	cleanup_ents( "checkin" );
}


//
//	Cleanup anything from the tower section
tower_cleanup()
{
	flag_wait( "elevator_reached_lobby" );
	
	// SOUND - Shawn J
	//iprintlnbold ("doors_open");
	level.player playsound ("amb_elevator_open");
	
	stop_exploder( 330 );
	stop_exploder( 331 );
	
	delete_hero( level.ai_han );
	delete_hero( level.ai_redshirt1 );
	delete_hero( level.ai_redshirt2 );
}

//-----------------------------------------------------------------------------------------------
//-----------------------------------CHALLENGES--------------------------------------
//---------------------------------------------------------------no death ------------------
karma_no_death_challenge( str_notify ) // self == player
{
	self endon( "death" );
	
	level waittill( "player_alive_challenge_complete" );
	
	if( isAlive( self ) )
	{
		self notify( str_notify );
	}
}


//
//
//checkin_towerlift_scene_cleanup()
//{
//	delete_scene( "player_put_on_glasses" );
//	delete_scene( "team_walk_intro");
//	delete_scene( "team_intro_idle");
//
//	//-------------------------------------------------------------------------------------------------
//	// Section 2 Walk & Idle
//	//-------------------------------------------------------------------------------------------------
//	delete_scene( "section_walk_2_1");
//	delete_scene("section_walk_2_1_security");
//	delete_scene( "section_idle_2_1");
//	
//	delete_scene( "worker_01_intro");
//	delete_scene( "worker_01_idle");
//	delete_scene( "security_01_idle");
//
//	delete_scene( "explosives_worker1_intro");
//	delete_scene( "explosives_worker1_idle");
//	delete_scene( "explosives_workers_enter_scanner");
//
//	delete_scene( "explosives_workers_enter_scanner_idle");
//	delete_scene( "explosives_workers_enter_scanner_alert");
//	delete_scene( "security_05_post_alert_idle");
//	delete_scene( "security_01_enter_scanner_alert");
//	delete_scene( "security_01_post_alert_idle");
//	delete_scene( "security_01_post_alert_point");
//	delete_scene( "receptionist_a_talk");
//	end_scene("receptionist_idles");
//	delete_scene( "receptionist_idles");
//	
//	delete_scene( "tower_lift2_hans_wait" );
//	delete_scene( "section_walk_3_redshirt" );
//	delete_scene( "section_walk_3_hans");
//	
//	
//
//	//Hey Trevor, This line will trigger an assert in _scene.gsc in delete_scene:
//	//	Assert( !IsString( level.a_scenes[ str_scene_name ] ), "Attempting to delete a scene that's already been deleted." );
//	//
//	//		Try deleting that assert line in _scene, rebuild fastfiles, then add that line
//	//	back in and uncomment this one.  Then use MyChanges and run using skipto "e3_dropdown".
////	delete_scene( "section_walk_3");
//
//	flag_wait( "elevator_reached_lobby" );
//	wait( 1.0 );	// additional wait to make sure these anims have stopped playing.
//	
//	delete_scene( "section_walk_3" );
//	delete_scene( "tower_lift_wait" );
//	delete_scene( "tower_lift2_wait" );
//}



attach_briefcase()
{
	self endon("death");
	self attach("test_p_anim_karma_briefcase", "tag_weapon_right");
	
	flag_wait( "elevator_reached_lobby" );
	
	self Detach("test_p_anim_karma_briefcase", "tag_weapon_right");
}

checkin_amb_civ()
{
	//a_civ_spawner = getentarray("checkin_civ", "targetname");
	
	a_civ = simple_spawn("checkin_civ", ::play_animation_on_script_noteworthy);
	
}

play_animation_on_script_noteworthy()
{
	
	self endon("death");
	
	add_cleanup_ent( "checkin", self );	
	
	if(self.script_noteworthy == "phone_idle")
	{
		anime = "civ_checkin_idle_1";
		self anim_generic_loop( self, anime );
		
	}
	else if(self.script_noteworthy == "smoking_idle")
	{
		anime = "civ_checkin_idle_2";
		self anim_generic_loop( self, anime );
	}
	
}
