#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_dialog;
#include maps\_glasses;
#include maps\_objectives;
#include maps\_scene;
#include maps\_vehicle;
#include maps\_music;
#include maps\karma_util;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\karma.gsh;


/* ------------------------------------------------------------------------------------------
    INIT functions
-------------------------------------------------------------------------------------------*/
//
//	Declare event-specific flags here
init_flags()
{
	flag_init( "glasses_activated" );
	flag_init( "scanner_on" );
	flag_init( "scanner_off" );
	flag_init( "team_at_tower" );
	flag_init( "alarm_on" );
	flag_init( "security_alert" );
	flag_init( "flag_left_alert_trigger" );
	flag_init( "clean_up_tower" );
	flag_init( "elevator_reached_construction" );
	flag_init( "sliding_door_open" );
	flag_init( "sliding_door_opening" );
	flag_init( "harper_exit_close" );
}


//
//	Need an AI to run something when spawned?  Put it here.
init_spawn_funcs()
{
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/
skipto_checkin()
{
	arrival_anims();

	// Turn off HUD
	//level.player hide_hud();

	level.ai_harper 		= init_hero( "harper" );
	
	if ( level.player get_story_stat( "HARPER_SCARRED" ) )
	{
		level.ai_harper SetModel( "c_usa_cia_combat_harper_burned_cin_fb" );
	}
	
	level.ai_salazar		= init_hero( "salazar_pistol");

	skipto_teleport( "skipto_checkin" );

	flag_set( "fxanim_checkin_start" );
	exploder( 101 );	// seagulls
	level thread maps\karma_arrival::set_water_dvars();
	
	level maps\karma_arrival::setup_vtol( "player_vtol" );
	level thread run_scene_and_delete( "final_approach_plane_idle" );
	//level thread run_scene_and_delete( "final_approach_stairs_idle" );

	level thread maps\karma_arrival::setup_vtol( "takeoff_vtol", "start_vtol_takeoff" );
	
	//playing vstol sounds
	playsoundatposition ("veh_vtol_1" , (6062, -11630, 1175));
	playsoundatposition ("veh_vtol_2" , (6542, -11186, 1191));
	
	level.m_duffle_bag = spawn_model( "p6_anim_duffle_bag_karma" );
	//level.m_duffle_bag.animname = "duffle_bag";
	level.m_duffle_bag set_blend_in_out_times( 0.2 );
	
	level.m_harper_briefcase = spawn_model( "p6_anim_metal_briefcase" );
	//level.m_harper_briefcase.animname = "harper_briefcase";
	level.m_harper_briefcase set_blend_in_out_times( 0.2 );

	// tarmac anims
	thread maps\karma_arrival::tarmac_worker_scenes();
	thread maps\karma_arrival::forklift_worker_scenes();
	thread maps\karma_arrival::metalstorm_worker_scenes();
	thread security_left();
	thread scanner_scenes();
	thread scanner_backdrop();
	
	wait( 0.2 );	// need to wait to make sure the player teleport completes before playing glasses scene.

	t_obj = GetEnt( "clip_scanner_blocker_2", "targetname" );
	set_objective( level.OBJ_SECURITY, t_obj );
}


skipto_tower_lift()
{
	level.ai_harper 		= init_hero( "harper" );
	
	if ( level.player get_story_stat( "HARPER_SCARRED" ) )
	{
		level.ai_harper SetModel( "c_usa_cia_combat_harper_burned_cin_fb" );
	}
	
	level.ai_salazar		= init_hero( "salazar_pistol" );

	level.m_duffle_bag = spawn_model( "p6_anim_duffle_bag_karma" );
	level.m_duffle_bag.animname = "duffle_bag";
	level.m_duffle_bag set_blend_in_out_times( 0.2 );
	
	level.m_harper_briefcase = spawn_model( "p6_anim_metal_briefcase" );
	level.m_harper_briefcase.animname = "harper_briefcase";
	level.m_harper_briefcase set_blend_in_out_times( 0.2 );

	flag_set( "fxanim_checkin_start" );
	skipto_teleport( "skipto_tower_lift" );
	
	level thread maps\createart\karma_art::vision_set_change( "sp_karma_elevators" );

	// dynamic ads
	run_thread_on_targetname( "dynamic_ad", ::dynamic_ad_swap );

	maps\karma_anim::checkin_anims();

	level thread hotel_civ();
	level thread player_railing();
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

	checkin_anims();
	
	// Slow down player speed to friendlies walk cycle.
	setsaveddvar("g_speed", 110);


	level thread checkin_squad_scenes();
	wait 0.05;
	level thread walking_lady();
	level thread sliding_door_init();
	level thread sliding_door_close_sound();

	// Move into the scanner
	flag_wait( "t_proceed_scanner" );
	level thread checkin_civ_scenes();
	level thread hotel_front_civ();

	flag_wait( "gate_open" );
	
	set_objective( level.OBJ_SECURITY, undefined, "done" );
	t_obj = GetEnt( "trig_tower_lift", "targetname" );
	set_objective( level.OBJ_FIND_CRC, t_obj );

	flag_wait( "hotel_back_civs" );

	// face swapping ads - need to initialize a little early to give time to initialize
	run_thread_on_targetname( "dynamic_ad", ::dynamic_ad_swap );
	
	level thread hotel_back_civ_scenes();
	
	flag_wait( "trig_player_blocker_2" );
	level thread hotel_back_civ();

	// Move to the elevator
	flag_wait( "t_proceed_tower" );

	// Near tower vista
	flag_wait( "start_vtol_flyby" );
	
	//triggering crowd fx below the elevator.
	exploder( 330 );
	exploder( 331 );

	level thread maps\karma_arrival::setup_vtol( "hip_top_deck_flyby" );
	level thread hotel_civ();
	level thread player_railing();

	flag_wait( "team_at_tower" );
	
	level thread checkin_cleanup();
}

sliding_door_init()
{
	e_door = GetEnt( "sliding_door_left", "targetname" );
	GetEnt( e_door.target, "targetname" ) LinkTo( e_door );
	
	e_door = GetEnt( "sliding_door_right", "targetname" );
	GetEnt( e_door.target, "targetname" ) LinkTo( e_door );
	
	GetEnt( "sliding_door_proximity_trigger", "targetname" ) thread sliding_door_think();
}

sliding_door_think()
{
	level endon( "sliding_door_reset" );
	
	self waittill( "trigger" );
	
	self thread trigger_thread( level.player, ::sliding_door_open, ::sliding_door_close );
}

sliding_door_close( ent, endon_string )
{
	level endon( "sliding_door_stop_close" );
		
	e_trigger = GetEnt( "sliding_door_proximity_trigger", "targetname" );
	e_left_door = GetEnt( "sliding_door_left", "targetname" );
	e_right_door = GetEnt( "sliding_door_right", "targetname" );
	s_left_door_closed = GetStruct( "sliding_door_left_closed", "targetname" );
	s_right_door_closed = GetStruct( "sliding_door_right_closed", "targetname" );
	
	flag_wait( "sliding_door_open" );
	
	if( !level.ai_harper IsTouching( e_trigger ) && !level.ai_salazar IsTouching( e_trigger ) && !level.player IsTouching( e_trigger ) )
	{
		level notify ("cls_dr");
		wait 0.5;
		
		e_left_door MoveTo( s_left_door_closed.origin, 1.0 );
		e_right_door MoveTo( s_right_door_closed.origin, 1.0 );
	
		flag_clear( "sliding_door_open" );
	}
		
	level notify( "sliding_door_reset" );
	GetEnt( "sliding_door_proximity_trigger", "targetname" ) thread sliding_door_think();
}

sliding_door_close_sound()
{
	while (1)
	{
		level waittill ("cls_dr");
		wait (.5);
		playsoundatposition ("amb_sliding_door_close", (4665, -9823, 991));
		//SOUND - Shawn J
		//iprintlnbold ("close");
		wait (2);
	}
}
		

sliding_door_open( ent )
{	
	level notify( "sliding_door_stop_close" );
	
	if( !flag( "sliding_door_open" ) )
	{	
		//SOUND - Shawn J
		//iprintlnbold ("open");
		playsoundatposition ("amb_sliding_door_open", (4665, -9823, 991));
		
		e_left_door = GetEnt( "sliding_door_left", "targetname" );
		e_right_door = GetEnt( "sliding_door_right", "targetname" );
		s_left_door_open = GetStruct( "sliding_door_left_open", "targetname" );
		s_right_door_open = GetStruct( "sliding_door_right_open", "targetname" );
	
		n_max_distance = Distance2DSquared( s_left_door_open.origin, GetStruct( "sliding_door_left_closed", "targetname" ).origin );
		n_current_distance = Distance2DSquared( e_left_door.origin, s_left_door_open.origin );
		n_max_time = 1.0;
		n_current_time = n_max_time * (n_current_distance / n_max_distance);
		n_current_time = Max( n_current_time, 0.05 );
		
		e_left_door MoveTo( s_left_door_open.origin, n_current_time );
		e_right_door MoveTo( s_right_door_open.origin, n_current_time );
		waittill_multiple_ents( e_left_door, "movedone", e_right_door, "movedone" );
		
		flag_set( "sliding_door_open" );
	}
	
	level notify( "sliding_door_reset" );
	GetEnt( "sliding_door_proximity_trigger", "targetname" ) thread sliding_door_think();
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
	level.sound_elevator_ent_1 = spawn( "script_origin", level.player.origin );
	level.sound_elevator_ent_2 = spawn( "script_origin", level.player.origin );
	
	level thread player_group_think();
	//level.player thread elevator_descent_dialog();

	trigger_wait( "trig_tower_lift" );
	
	Objective_Set3D( level.OBJ_FIND_CRC, false );
	level thread maps\createart\karma_art::vision_set_change( "karma_elevator_01" );

	// Start to gump out assets
	trigger_wait( "t_ship_interior" );

	tower_cleanup();
	load_gump( "karma_gump_construction" );
	
	flag_wait( "elevator_reached_construction" );
	
	autosave_by_name( "karma_lobby" );
}


/* ---------------------------------------------------------------------------
 * CHECKIN
 * --------------------------------------------------------------------------- */
//
//	All of the civ scenes as you travel through the checkin area
//
checkin_civ_scenes()
{	
	level thread receptionist_left();
	wait 1;
	level thread hotel_front_civ_scenes();
	wait 1;
	level thread civ_goto_railing();	
	wait 1;
	level thread civ_girl_goto_railing();	
}

walking_lady()
{
	run_scene_first_frame( "hotel_ladywalking" );

	flag_wait( "gate_open" );
	
	wait 3;

	run_scene_and_delete("hotel_ladywalking");
	thread run_scene_and_delete("hotel_ladywalking_idle");
	flag_wait( "clean_up_tower" );
	
//	end_scene( "hotel_ladywalking_idle" );
}

civ_goto_railing()
{
	level endon( "cleanup_checkin" );
	
	run_scene_first_frame( "hotel_goto_railing" );

	flag_wait( "t_proceed_tower" );
	
	wait 3;

	run_scene_and_delete("hotel_goto_railing");
	thread run_scene_and_delete("hotel_goto_railing_idle");
	flag_wait( "clean_up_tower" );

//	end_scene( "hotel_goto_railing_idle" );
}

civ_girl_goto_railing()
{
	level endon( "cleanup_checkin" );
	
	thread run_scene_and_delete("hotel_goto_girl_idle1");
	
	flag_wait( "t_proceed_tower" );
	wait 3;

	run_scene_and_delete("hotel_goto_girl_walk");
	thread run_scene_and_delete("hotel_goto_girl_idle2");
}


//
//	Handles squad movement anims through the tower.
//
checkin_squad_scenes()
{
	
	
	//	Squad walks to the scanner
	run_scene_and_delete( "team_walk_intro" );
	level thread run_scene_and_delete( "team_intro_idle" );
	level.ai_harper set_blend_in_out_times( 0.5 );
	level.ai_salazar set_blend_in_out_times( 0.5 );
	level.m_duffle_bag set_blend_in_out_times( 0.5 );
	level.m_harper_briefcase set_blend_in_out_times( 0.5 );
	
	// inside scanner
	flag_wait( "alert" );
		
	//walk to reception
	run_scene_and_delete("section_walk_2_1", 1);	
	level thread run_scene_and_delete("tower_lift_wait");

	level.ai_harper set_blend_in_out_times( 0 );
	level.ai_salazar set_blend_in_out_times( 0 );
	level.m_duffle_bag set_blend_in_out_times( 0 );
	level.m_harper_briefcase set_blend_in_out_times( 0 );
	
	flag_set( "team_at_tower" );
}

receptionist_left()
{	
	flag_wait( "alert" );
	run_scene_and_delete("receptionist_left");
	level thread run_scene_and_delete("receptionist_left_idle");
	flag_wait( "clean_up_tower" );

	end_scene("receptionist_left_idle");

}

// Player puts on some glasses
glasses_scene()
{
	glasses = GetEnt( "glasses", "targetname" );
	glasses setviewmodelrenderflag( true );

	run_scene_and_delete( "player_put_on_glasses" );	
}

//
//	Glasses powered up HUD turns 
//
hudsupdisplay(guy)
{
	maps\_glasses::play_bootup();
	level thread maps\createart\karma_art::vision_set_change( "sp_karma_introglasseson" );
	wait( 1.0 );	// wait for the animation to complete

	//level.player playsound( "evt_glasses_startup" );
	flag_set( "glasses_activated" );
	level.player show_hud();
	level thread maps\karma::add_argus_info();

	// Able to look around again
	//level.player LerpViewAngleClamp( 1.0, 0.0, 0.0, 35.0, 30.0, 20.0, 20.0 );
}

//
//	Receptionists
//
hotel_front_civ_scenes()
{
	thread run_scene_and_delete( "hotel_security_front" );
	wait 1;
	thread run_scene_and_delete( "hotel_reception_civs" );	
}

hotel_back_civ_scenes()
{
	
	thread run_scene_and_delete( "elevator_civs");
	wait 1;
	thread run_scene_and_delete( "lobby_guy8" );
	wait 1;
	thread run_scene_and_delete( "lobby_guy14" );
	wait 1;
	thread run_scene_and_delete( "lobby_guy15" );
	wait 1;
	
	flag_wait( "clean_up_tower" );
	
	end_scene( "elevator_civs" );
	end_scene( "lobby_guy8" );
	end_scene( "lobby_guy14" );
	end_scene( "lobby_guy15" );
}

//
//	Play an intro idle and then an idle anim if they exist.
//	self is an AI
scanner_prep()
{
	Assert( IsDefined( self.script_animname ), "Add an animname to the guy at " + self.origin );

//	self thread print3d_ent( "animname", (0,0,32), undefined, "inside_tower_lift" );
	self add_cleanup_ent( "checkin" );
	if ( IsDefined( self.script_string ) && self.script_string == "scanner" )
	{
		self thread scanner_model_swap();
	}
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

		if( self.targetname == "checkin_security_ai" )
		{
			self SetModel( "c_mul_jinan_guard_bscatter_fb" );
		}
		else
		{
			self SetModel( "c_mul_jinan_demoworker_bscatter_fb" );
		}
		flag_wait( "scanner_off" );

		self SetModel( self.model_original );
	}
}


//
//	Notetrack function.  Let's us know when the AI is in the scanner
inside_scanner( guy )
{
	guy ent_flag_set( "in_scanner" );
	
	flag_set( "alarm_on" );
	
	ClientNotify ("alarm_on");
}


//
//	Control when the backdrop appears depending on the player's position
scanner_backdrop()
{
	level endon( "inside_tower_lift" );
	flag_wait( "start_tarmac" );
	
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
	flag_wait( "start_tarmac" );
	// This will prevent the player from leaving the scanner once they enter
	bm_clip = GetEnt( "clip_scanner_blocker", "targetname" );
	bm_clip trigger_off();
	
	// Initialization
	a_ai_security 			= simple_spawn( "checkin_security", ::scanner_prep );
	a_ai_explosives_workers = simple_spawn( "explosives_workers", ::scanner_prep );

	level thread security_left_gate();
	level thread security_middle_alert();
	level thread securityR_and_workers_alert();
	
	
	trigger_wait ("trig_workers_swap_model");
	
	// Add pings
	foreach( ai_worker in a_ai_explosives_workers )
	{
		ai_worker thread scanner_ping_fx("J_Ankle_LE", (0,0,0));
		ai_worker thread scanner_ping_fx("J_Ankle_RI", (0,0,0));
	}
	
	foreach( ai_security in a_ai_security )
	{
		if ( IsDefined( ai_security.script_string ) && ai_security.script_string == "scanner" )
		{
			ai_security thread scanner_ping_fx("TAG_WEAPON_RIGHT", (-10,0,0) );
			m_gun_tag_origin = Spawn( "script_model", ai_security.origin ); //Important
			m_gun_tag_origin SetModel( "t6_wpn_pistol_fiveseven_world_detect" ); //Important
			m_gun_tag_origin LinkTo( ai_security, "TAG_WEAPON_RIGHT", ( 0, 0, 0 ) );
			m_gun_tag_origin thread cleanup_red_guns();
		}
	}


	// inside scanner
	trigger_wait( "trig_enter_scanner" );
	
	security_gate();
	bm_clip trigger_on();
	
	exploder( 104 );	// start Gavin fx.
	stop_exploder( 105 );	// stop Gavin fx.
	
	level thread reset_player_speed();
	
	/#
//		scott_b_shader_test();
	#/
}

reset_player_speed()
{
	flag_wait( "reset_player_speed" );
	
	wait 0.05;
	
	setsaveddvar("g_speed", 110);
}
	
scanner_ping_fx(e_tag, e_fx_offset)
{
	fxOrg = Spawn("script_model", (0,0,0));
	fxOrg SetModel("tag_origin" );

	fxOrg.origin = self GetTagOrigin(e_tag);
	fxOrg.angles = self GetTagAngles(e_tag);

	fxOrg LinkTo(self, e_tag, e_fx_offset);
	//Eckert -ping sounds
	fxOrg thread ping_fx_sounds();

	PlayFXOnTag( level._effect["scanner_ping"], fxOrg, "tag_origin" );

	flag_wait("trig_player_blocker_2");
	
	fxOrg delete();
}

ping_fx_sounds()
{
	wait 6;
	self playsound ( "evt_scanner_alarm" );
	
	while (isdefined(self))
	{
		self playsound ( "evt_scanner_ping" );
		wait 2.3;
	}
}


security_left_gate()
{
	sec_gate_left_player = GetEnt("sec_gate_left_player", "targetname");
	sec_gate_right_player = GetEnt("sec_gate_right_player", "targetname");
	bm_clip_2 = GetEnt( "clip_scanner_blocker_2", "targetname" );
	
	flag_wait("gate_alert");
	
	sec_gate_left_player RotateYaw ( -90, 0.7, 0.5, 0.2 );
	sec_gate_left_player playsound( "evt_scanner_gate_close" );
	sec_gate_right_player RotateYaw ( 90, 0.7, 0.5, 0.2 );
	bm_clip_2 trigger_on();
	
	flag_wait( "gate_open" );
	
	sec_gate_left_player RotateYaw ( 90, 0.7, 0.5, 0.2 );
	sec_gate_left_player playsound( "evt_scanner_gate_open" );
	sec_gate_right_player RotateYaw ( -90, 0.7, 0.5, 0.2 );
	bm_clip_2 trigger_off();
	
	flag_wait( "trig_player_blocker_2" );
	
	sec_gate_left_player RotateYaw ( -90, 0.7, 0.5, 0.2 );
	sec_gate_left_player playsound( "evt_scanner_gate_close" );
	sec_gate_right_player RotateYaw ( 90, 0.7, 0.5, 0.2 );
	bm_clip_2 trigger_on();
}

security_gate()
{
	sec_gate_left = GetEnt("sec_gate_left", "targetname");
	sec_gate_left playsound( "evt_scanner_gate_close" );
	sec_gate_left RotateYaw ( -90, 0.7, 0.5, 0.2 );
	
	sec_gate_right = GetEnt("sec_gate_right", "targetname");
	sec_gate_right RotateYaw ( 90, 0.7, 0.5, 0.2 );
	
	sec_gate_left_anim = GetEnt("sec_gate_left_anim", "targetname");
	sec_gate_left_anim RotateYaw ( -90, 0.7, 0.5, 0.2 );
	
	sec_gate_right_anim = GetEnt("sec_gate_right_anim", "targetname");
	sec_gate_right_anim RotateYaw ( 90, 0.7, 0.5, 0.2 );
	
	sec_gate_left_player_anim = GetEnt("sec_gate_left_player_anim", "targetname");
	sec_gate_left_player_anim RotateYaw ( -90, 0.7, 0.5, 0.2 );
	
	sec_gate_right_player_anim = GetEnt("sec_gate_right_player_anim", "targetname");
	sec_gate_right_player_anim RotateYaw ( 90, 0.7, 0.5, 0.2 );
}

security_left()
{
	flag_wait( "start_tarmac" );
	
	run_scene_and_delete( "security_left" );
	level thread run_scene_and_delete( "security_left_idle" );
	
	flag_wait( "alert" );
	
	run_scene_and_delete( "security_left_alert", 1);
	level thread run_scene_and_delete( "security_left_alert_idle" );
	
}

security_middle_alert()
{
	level thread run_scene_and_delete( "security_middle_idle" );
	
	flag_wait("alert");
	
	run_scene_and_delete( "security_middle_alert", 1);
	level thread run_scene_and_delete( "security_middle_alert_idle" );
}

securityR_and_workers_alert()
{
	level thread alert_trigger_check();
	level thread run_scene_and_delete( "security_right_idle" );
	
	flag_wait( "left_alert_trigger");
	
	flag_wait("flag_left_alert_trigger");
	run_scene_and_delete( "securityR_and_workers_alert" );
	level thread run_scene_and_delete( "securityR_and_workers_alert_idle" );
}

alert_trigger_check()
{
	trig = GetEnt("trig_workers_alert", "targetname");
	while( !level.player IsTouching( trig ) )
	{
			wait( 0.05 );
	}
	
	//trig trigger_on();
	flag_set ("flag_left_alert_trigger");
}


//scott_b_shader_test()
//{
//	security = getentarray("checkin_security_ai", "targetname");
//	worker = getentarray("explosives_workers_ai", "targetname");
//	
//	security[1] player_fudge_moveto( (5252, -9340, 972));
//	security[1] SetGoalPos(security[1].origin);
//	
//	worker[0] player_fudge_moveto( (5260, -9460, 972));
//	worker[0] SetGoalPos(worker[0].origin);
//	
//	
//	
//}

cleanup_red_guns()
{
	flag_wait( "trig_player_blocker_2" );
	
	self unlink();
	self delete();
}


//
//	Change the faces when an appropriate person is in range.
//	This function is designed to work if we want more than one entity to be able to
//	activate it.
dynamic_ad_swap()
{
	level endon( "inside_tower_lift" );
	CONST n_range = 150*150;	// distance squared where you want the swap to happen
	
	self IgnoreCheapEntityFlag( true );

	// See if we need to check for another character
	ai_check_other = undefined;
	if ( IsDefined(self.script_string) && self.script_string == "harper" )
	{
		ai_check_other = level.ai_harper;
	}
	if ( IsDefined(self.script_string) && self.script_string == "salazar" )
	{
		ai_check_other = level.ai_salazar;
	}

	//Toggle on the actual callback in clientscript to setup the initial function.
	self SetClientFlag( CLIENT_FLAG_FACE_SWAP_INIT );
	b_other_in_range = false;
	b_player_in_range = false;
	wait(1);

	// Set the bit only when the state changes, don't spam it.
	while ( 1 )
	{
		n_dist = 1000000;
		// check against the player, Harper and Salazar.  Take the closest one
		if ( IsDefined( ai_check_other ) )
		{
			n_dist_other = DistanceSquared( self.origin, ai_check_other.origin );
			// Now check to see if someone is in range
			if ( !b_other_in_range && n_dist_other < n_range )
			{
				b_other_in_range = true;
				self SetClientFlag( CLIENT_FLAG_FACE_SWAP );
			}
			else if ( b_other_in_range && n_dist_other > n_range )
			{
				b_other_in_range = false;
				self ClearClientFlag( CLIENT_FLAG_FACE_SWAP );
			}
		}

		if ( !b_other_in_range )
		{
			// Check to see if the player is in range
			n_dist_player = DistanceSquared( self.origin, level.player.origin );
	
			if ( !b_player_in_range && n_dist_player < n_range )
			{
				b_player_in_range = true;
				self SetClientFlag( CLIENT_FLAG_FACE_SWAP_PLAYER );
				continue;
			}
			else if ( b_player_in_range && n_dist_player > n_range )
			{
				b_player_in_range = false;
				self ClearClientFlag( CLIENT_FLAG_FACE_SWAP_PLAYER );
			}
		}
		wait( 0.1 );
	}
}


/* ---------------------------------------------------------------------------
 * TOWER LIFT
 * --------------------------------------------------------------------------- */

//
//	Harper and Salazar walk toward their lift, get in and brush off the workers.
player_group_think()
{
	CONST n_door_move_time = 1.0;
	CONST n_door_move_accel = 0.2;
	CONST n_door_move_decel = 0.5;
	
	bm_lift_left = setup_elevator( "tower_lift_left", "tower_elevator_1", "cleanup_dropdown" );
	//SOUND - Shawn J
	//iprintlnbold ("elevator_1st_door_open");
	playsoundatposition ("amb_elevator_open_fast", (4505, -7218, 962));
	
	e_align = GetEnt( "align_player", "targetname" );
	e_align LinkTo( bm_lift_left );

	// This is necessary to keep the guys connected to the elevator
	// Link the AI to this model and they will animate fine
	m_tag_origin = Spawn( "script_model", e_align.origin );
	m_tag_origin SetModel( "tag_origin" );
	m_tag_origin.angles = e_align.angles;
	m_tag_origin LinkTo( e_align );

	// When the player gets near, open the doors
	flag_wait( "near_tower_lift" );
	
	bm_player_clip = GetEnt( "clip_tower_lift_top", "targetname" );
	bm_player_clip trigger_off();

    bm_lift_left  thread elevator_move_doors( true, n_door_move_time, n_door_move_accel, n_door_move_decel );
	thread run_scene( "tower_elevator_open" );

	// Open the outer doors too
	m_outer_left  = GetEnt( "door_outer_elevator_1left", "targetname" );
	m_outer_right = GetEnt( "door_outer_elevator_1right", "targetname" );
	m_outer_left  MoveX( -58, n_door_move_time, n_door_move_accel, n_door_move_decel );
	m_outer_right MoveX( 58, n_door_move_time, n_door_move_accel, n_door_move_decel );

	wait( 1.0 );

	run_scene_and_delete( "tower_lift_enter" );
	level thread run_scene_and_delete( "tower_lift_enter_wait" );

	// Link AI to elevator so they stay with it
	level.ai_salazar LinkTo( m_tag_origin );
	level.ai_harper LinkTo( m_tag_origin );
	level.m_duffle_bag LinkTo( m_tag_origin );
	level.m_harper_briefcase LinkTo( m_tag_origin );
	
	// Wait until the player is inside, then Harper goes in	and workers run up
	trigger_wait( "trig_tower_lift" );

	bm_player_clip trigger_on();
	level thread run_scene_and_delete( "tower_lift_workers_run" );
	
	//TODO ANIM NOTETRACK: close the door when the workers are near
	wait( 3.0 );
	
	// SOUND - Shawn J
	//iprintlnbold ("doors_close_1");
	playsoundatposition ("amb_elevator_close", (5062, -7237, 748));
	
	bm_lift_left  thread elevator_move_doors( false, n_door_move_time, n_door_move_accel, n_door_move_decel );
	m_outer_left  MoveX( 58, n_door_move_time, n_door_move_accel, n_door_move_decel );
	m_outer_right MoveX( -58, n_door_move_time, n_door_move_accel, n_door_move_decel );
	run_scene( "tower_elevator_close" );
	
	// Get the elevator moving
	// SOUND - Shawn J
	//iprintlnbold ("going_down");
	clientnotify( "sbpv" );
	level.player playsound ("amb_elevator_start");
	level.sound_elevator_ent_1 playloopsound( "amb_elevator_loop", 1 );
	level thread elevator_stop_delay_1();

	//Descend to mid level for Harper to exit
	s_destination = GetStruct( "tower_lift_left_middle", "targetname" );
	bm_lift_left SetMovingPlatformEnabled( true );
	bm_lift_left MoveTo( s_destination.origin, 24, 3.0, 2.0 );
	bm_lift_left waittill( "movedone" );
	wait 2.0;
	
	level thread run_scene( "tower_elevator_open" );
	//SOUND - Shawn J
	//iprintlnbold ("door_open_again");
	playsoundatposition ("amb_elevator_open", (4506, -6091, -2844));
	scene_wait( "tower_lift_workers_run" );
	
	level.ai_harper Unlink();
	level.m_harper_briefcase Unlink();
	
	level thread run_scene_and_delete( "tower_lift_harper_exit" );
	level thread run_scene_and_delete( "tower_lift_karma_exit" );
	level thread run_scene_and_delete( "tower_lift_salazar_exit" );
	flag_wait( "harper_exit_close" );
	
	//SOUND - Shawn J
	//iprintlnbold ("door_close_again?");
	playsoundatposition ("amb_elevator_close_2", (4506, -6091, -2844));
	
	run_scene( "tower_elevator_close" );
	wait 1.0;
	
	//Play the music stinger
	level thread maps\_audio::switch_music_wait ("KARMA_1_CONSTRUCTION", 9);
	
	level.player playsound ("amb_elevator_start_2");
	level.sound_elevator_ent_1 playloopsound( "amb_elevator_loop", 1 );
	//iprintlnbold ("start_again");
	level thread elevator_stop_delay_2();

	wait 1.0;
	
	// Descend to construction area
	s_destination = GetStruct( "tower_lift_left_bottom", "targetname" );
	bm_lift_left SetMovingPlatformEnabled( true );
	bm_lift_left MoveTo( s_destination.origin, 5, 1.0, 1.0 );
	bm_lift_left waittill( "movedone" );

	// Link AI to elevator so they stay with it
	level.ai_salazar Unlink();
	
	flag_set( "elevator_reached_construction" );
}

elevator_stop_delay_1()
{
	wait 18;
	//iprintlnbold ("delayed_stop_1");
	level.sound_elevator_ent_1 stoploopsound(1);
	level.player playsound ("amb_elevator_stop");
	
}

elevator_stop_delay_2()
{
	wait 4.5;
	//iprintlnbold ("delayed_stop_2");
	level.sound_elevator_ent_1 stoploopsound(1);
	level.player playsound ("amb_elevator_stop");
	
	wait 3.5;
	playsoundatposition ("amb_elevator_open", (4480, -5945, -3508));	

	
	//SOUND - Shawn J - deleting temp elevator ents
	//	Added checks in case you use a skipto
	if ( IsDefined( level.sound_elevator_ent_1 ) )
	{
		level.sound_elevator_ent_1 delete();
	}
	if ( IsDefined( level.sound_elevator_ent_2 ) )
	{
		level.sound_elevator_ent_2 delete();
	}
}

//
//	Cleanup anything from the checkin section
checkin_cleanup()
{
	flag_wait( "inside_tower_lift" );
		
	cleanup_ents( "cleanup_checkin" );

	// Turn off ambient fx
	stop_exploder( 101 );
	stop_exploder( 102 );
	stop_exploder( 104 );

	end_scene( "security_left_alert_idle" );
	end_scene( "hotel_security_front" );
	end_scene( "hotel_reception_civs" );
}


//
//	Cleanup anything from the tower section
tower_cleanup()
{
	cleanup_ents( "cleanup_tower" );

	stop_exploder( 330 );
	stop_exploder( 331 );

	flag_set("clean_up_tower");
	
	level thread maps\_drones::drones_delete_spawned();
	level thread maps\_drones::drones_delete( "hotel_drones" );
	level maps\karma_civilians::delete_civs( "hotel_girl" );
}


//---------------------------------------------------------------
//--		D I A L O G
//---------------------------------------------------------------

// Salazar talks while elevator descends
//	self is the player
elevator_descent_dialog()
{
	flag_wait( "near_tower_lift" );

    self say_dialog( "this_place_is_stil_001" );	//This place is still under construction... Split up - get familiar with the layout.
    self say_dialog( "well_regroup_when_002" );		//We?ll regroup when we access the CRC.

}

PA_dialog()
{	
	flag_wait("sndStartPAVox");
	ent = spawn( "script_origin", (4667,-10267,1150) );
	ent playPAvox( "vox_kar_1_01_001a_pa" );
	ent playPAvox( "vox_kar_1_01_002a_pa" );
	ent playPAvox( "vox_kar_1_01_003a_pa" );
	ent playPAvox( "vox_kar_1_01_004a_pa" );
	ent playPAvox( "vox_kar_1_01_005a_pa" );
	ent delete();
	
	flag_wait("t_proceed_scanner");
	ent = spawn( "script_origin", (4670,-9695,1042) );
	ent playPAvox( "vox_kar_2_02_001a_pa" );
	ent delete();
	
	flag_wait("sndPlayPAWelcome");
	ent = spawn( "script_origin", (4564,-9287,1038) );
	ent playPAvox( "vox_kar_2_02_004a_pa");
	ent playPAvox( "vox_kar_2_02_005a_pa");	
	ent delete();
}

playPAvox( alias )
{
	self playsound( alias, "sounddone" );
	self waittill( "sounddone" );
}

septic_dialog()
{
	//dialog right after salazar.
	wait(42);
	level.player say_dialog( "al_jinans_the_wea_002");
	level.player say_dialog( "proceed_as_planned_003");
}
	

hotel_civ()
{
	maps\karma_civilians::assign_civ_spawners( "civ_hotel_light_female" );
	
	level maps\karma_civilians::spawn_static_civs( "hotel_girl" );
	
	maps\karma_civilians::assign_civ_drone_spawners( "civ_hotel_light", "hotel_drones" );
	maps\_drones::drones_setup_unique_anims( "hotel_drones", level.drones.anims[ "civ_walk" ] );
	maps\_drones::drones_speed_modifier( "hotel_drones", -0.1, 0.1 );
	maps\_drones::drones_set_max( 75 );
	
	level thread maps\_drones::drones_start( "hotel_drones" );
}

hotel_front_civ()
{
	maps\karma_civilians::assign_civ_spawners( "hotel_female_dress" );
	maps\karma_civilians::assign_civ_spawners( "hotel_female_rich3" );
	wait 0.05;
	maps\karma_civilians::assign_civ_spawners( "hotel_female_rich4" );
	maps\karma_civilians::assign_civ_spawners( "hotel_male_rich4" );
	wait 0.05;
	maps\karma_civilians::assign_civ_spawners( "hotel_male_rich6" );
	maps\karma_civilians::assign_civ_spawners( "checkin_worker_new" );
	
	level maps\karma_civilians::spawn_static_civs( "hotel_front_girl" );
	level maps\karma_civilians::spawn_static_civs( "hotel_front_guy" );
	level maps\karma_civilians::spawn_static_civs( "hotel_front_worker" );
	
	flag_wait( "clean_up_tower" );
	level maps\karma_civilians::delete_civs( "hotel_front_girl" );
	level maps\karma_civilians::delete_civs( "hotel_front_guy" );
	level maps\karma_civilians::delete_civs( "hotel_front_worker" );
}

hotel_back_civ()
{
	
	level maps\karma_civilians::spawn_static_civs( "hotel_back_girl_first" );
	level maps\karma_civilians::spawn_static_civs( "hotel_back_guy_first" );
	
	wait 0.1;
	
	level maps\karma_civilians::spawn_static_civs( "hotel_back_girl_second" );
	level maps\karma_civilians::spawn_static_civs( "hotel_back_guy_second" );

	flag_wait( "clean_up_tower" );
	level maps\karma_civilians::delete_civs( "hotel_back_girl_first" );
	level maps\karma_civilians::delete_civs( "hotel_back_guy_first" );
	level maps\karma_civilians::delete_civs( "hotel_back_girl_second" );
	level maps\karma_civilians::delete_civs( "hotel_back_guy_second" );

}

player_railing()
{
	trigger_wait("t_player_railing");
	
	level thread maps\createart\karma_art::vision_set_change( "sp_karma_vista" );
 	//level.ai_harper thread say_dialog( "assholes_003" );

 	run_scene_and_delete("player_railing");

	level thread maps\createart\karma_art::vision_set_change( "sp_karma_elevators" );
}

