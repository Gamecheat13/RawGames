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
	flag_init( "player_rappel" );	// set by trigger
	flag_init( "setup_spiderbot" );	// set by trigger
	flag_init( "ambush_attack" );
	flag_init( "dropdown_end" );
//	flag_init( "civ_kill_walkway" );
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
skipto_dropdown()
{
	level.ai_salazar = init_hero( "salazar" );
	level.ai_harper = init_hero( "harper" );
	
	
	//open the elevator door

	
	start_teleport( "skipto_dropdown" );	

	maps\karma_anim::lobby_anims();
	
	level thread run_scene_and_delete("open_crc_lobby_entry_elevator");
	level thread run_scene_and_delete("open_crc_lobby_exit_elevator");
}

/* ------------------------------------------------------------------------------------------
	MAIN functions
-------------------------------------------------------------------------------------------*/
//
//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//	your skipto sequence will be called.
main()
{
	/#
		IPrintLn( "elevator_1" );
	#/

	level thread dropdown_objectives();

	// Hide the real Spiderbot until the scene is done
	vh_spiderbot = GetEnt( "spiderbot", "targetname" );
	vh_spiderbot Hide();
	vh_spiderbot MakeVehicleUnusable();

	trigger_wait( "t_near_rope" );
	
	run_scene_and_delete( "player_climb_hatch" );
	thread run_scene_and_delete( "team_hatch_idle" );
		
	flag_wait( "player_rappel" );
	
	level thread load_gump( "karma_gump_construction" );
	//-------------------------------------------------------------------------------------------
	// Animation of player grabbing the center elevator cable and rappeling down.
	//-------------------------------------------------------------------------------------------
	end_scene( "team_hatch_idle" );
	run_scene_and_delete( "player_rappel" );

//TODO Find out where to put this
//	level thread farid_comm_two();

	flag_wait( "karma_gump_construction" );

	// Get attacked by "security"
	thread autosave_now( "karma_dropdown" );

	// Teleport Salazar and Harper behind you
	level.ai_salazar thread ally_dropdown_think( "start_construction_elevator_salazar" );
	level.ai_harper  thread ally_dropdown_think( "start_construction_elevator_harper" );
	
	simple_spawn( "dropdown_patrol" );	// , ::ambush_guy_think );
	thread run_scene_and_delete( "player_pry_open" );
	thread run_scene_and_delete( "elevator_encounter1" );
	thread run_scene_and_delete( "elevator_encounter2" );
	thread run_scene_and_delete( "elevator_encounter3" );	// hacker
	thread ambush_description();
	scene_wait( "elevator_encounter1" );
	flag_set( "ambush_attack" );
	flag_set( "draw_weapons" );

	// Kill them all
	waittill_ai_group_cleared( "dropdown_patrol" );

   	level.ai_harper thread harper_vent_wait();
   	
	flag_wait( "setup_spiderbot" );

	run_scene_and_delete( "set_spiderbot" );

   	level.ai_harper thread harper_vent_wait2();
	
	delete_hero( level.ai_salazar );	
	wait( 2.0 );	// bootup the spiderbot
}


//
//	Teleport ally behind you and wait for combat
//	self is the ally
ally_dropdown_think( str_dest_node )
{
	self clear_run_anim();
	self change_movemode( "cqb" );

	n_spot = GetNode( str_dest_node, "targetname" );
	self forceteleport( n_spot.origin, n_spot.angles );
	self SetGoalNode( n_spot );

	flag_wait( "ambush_attack" );
	wait( 1.5 );	// Don't let your buddies be too fast on the draw

	self.ignoreall = false;
}


//-------------------------------------------------------------------------------------------
// Elevator to front CRC objectives.
//-------------------------------------------------------------------------------------------
dropdown_objectives()
{
	objective_breadcrumb( level.OBJ_FIND_CRC, "t_dropdown_start" );

	waittill_ai_group_cleared( "dropdown_patrol" );

	t_setup = GetEnt( "t_setup_spiderbot", "targetname" );
	set_objective( level.OBJ_FIND_CRC, t_setup );
	t_setup waittill( "trigger" );
	
	set_objective( level.OBJ_FIND_CRC, undefined, "done" );	
	set_objective( level.OBJ_FIND_CRC, undefined, "delete" );

	flag_set( "dropdown_end" );	
}


//
//	Security decide to kill you
ambush_description()
{
	wait( 1.5 );
	
	iPrintLnBold( "guard: Hey!  You shouldn't be in here!" );
	wait( 1.5 );
	
	iPrintLnBold( "Septic: We have clearance." );
}


//
//	Notetrack callback function
//	Open the elevator doors
pry_open_doors( ai_callback )
{
	e_fake_elevator = GetEnt( "construction_elevator", "targetname" );
	e_fake_elevator thread elevator_move_doors( true, 1.0, 0.5, 0.0, true );

}

//
//
ambush_guy_think()
{
	self.ignoreall = true;
	self disable_react();
	flag_wait( "ambush_attack" );
	
	self.ignoreall = false;
}

//TODO Find out where to put this
farid_comm_two()
{
	scene_wait( "player_rappel" );	
	
	level.ai_farid = init_hero( "farid" );	
	
	// Setup generic align node
	s_align = GetStruct( "generic_align", "targetname" );
	s_align.origin = level.ai_farid.origin;
	s_align.angles = level.ai_farid.angles;
	
	// spawn our tag_origin for the animation and link the camera to it
	m_tag_origin = Spawn( "script_model", level.ai_farid.origin ); //Important
	m_tag_origin SetModel( "tag_origin_animate" ); //Important
	m_tag_origin.animname = "farid_camera";
	level.e_extra_cam.origin = m_tag_origin.origin;
	level.e_extra_cam.angles = m_tag_origin.angles;
	level.e_extra_cam LinkTo( m_tag_origin, "origin_animate_jnt" );
	
	wait 4;

	turn_on_extra_cam();

	wait 0.5;
	
	run_scene_and_delete( "second_farid_call" );
	
	wait 1.5;
	turn_off_extra_cam();
	
	wait 1;
	
	level.e_extra_cam Unlink();
	m_tag_origin Delete();
	
	delete_hero( level.ai_farid );	
}


//
//	Hang around for a bit and then delete
//	Still don't know if this should be Harper or Salazar
//	self is Harper
harper_vent_wait()
{
	level endon( "setup_spiderbot" );

	// Harper waits outside the spiderbot setup room
	thread run_scene_and_delete( "harper_wait_outside_spiderbot" );
	self waittill( "goal" );	// Since Harper is reaching first, we can't end the scene if it hasn't started playing yet.

	trigger_wait( "t_harper_goto_vent" );
	
	end_scene( "harper_wait_outside_spiderbot" );
		
	// Harper waits outside the spiderbot setup room
	run_scene_and_delete( "harper_go_inside_spiderbot" );

	// Harper waits for us to get in place
	thread run_scene_and_delete( "harper_wait_vent_spiderbot" );
}


harper_vent_wait2()
{
	self thread run_scene_and_delete( "harper_wait" );
	flag_wait( "near_bombs" );
	
	end_scene( "harper_wait" );
}
