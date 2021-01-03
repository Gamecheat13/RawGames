#using scripts\codescripts\struct;


#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\laststand_shared;

#using scripts\shared\hud_util_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_quadtank;

#using scripts\cp\sidemissions\_sm_type_base;
#using scripts\cp\sidemissions\_sm_ui;
#using scripts\cp\sidemissions\_sm_wave_mgr;
#using scripts\cp\sidemissions\_sm_supply_manager;
#using scripts\cp\sidemissions\_sm_manager;
#using scripts\cp\_laststand;

#using scripts\cp\_laststand;
#using scripts\cp\_util;
#using scripts\cp\_pda_hack;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       



//#define WAYPOINT_HACK			"waypoint_hack"

//#define STR_WAYPOINT			"waypoint_targetneutral"

	










	
	
#namespace sm_hvt;

#precache( "material", "waypoint_kill" );
#precache( "material", "waypoint_grab_red" );
#precache( "material", "t7_hud_waypoints_arrow" );
#precache( "material", "t7_hud_prompt_press_64" );
#precache( "fx", "light/fx_light_glow_hack_blue" );

// NEW HVT OBJECTIVE STRINGS - ghs 3-24-2014
// overall
#precache( "string", "SM_TYPE_HVT_MAIN_SPLASH" );
#precache( "string", "SM_TYPE_HVT_MAIN_VO" );
// infil and vtol "Obtain Security Codes"
#precache( "string", "SM_TYPE_HVT_VTOL_TIMER" );
#precache( "string", "SM_TYPE_HVT_VTOL_INTRO_VO" );
#precache( "string", "SM_TYPE_HVT_VTOL_INTRO_SPLASH1" );
#precache( "string", "SM_TYPE_HVT_VTOL_INTRO_SPLASH2" );
#precache( "string", "SM_TYPE_HVT_VTOL_OUTRO_VO" );
#precache( "string", "SM_TYPE_HVT_VTOL_OUTRO_SPLASH1" );
#precache( "string", "SM_TYPE_HVT_VTOL_OUTRO_SPLASH2" );
#precache( "string", "SM_TYPE_HVT_VTOL_FAIL_VO" );
#precache( "string", "SM_TYPE_HVT_VTOL_FAIL_SPLASH" );
#precache( "string", "SM_TYPE_HVT_VTOL_PROGRESS_VO1" );
#precache( "string", "SM_TYPE_HVT_VTOL_PROGRESS_VO2" );
#precache( "string", "SM_TYPE_HVT_VTOL_SOFTFAIL_VO" );
#precache( "string", "SM_TYPE_HVT_VTOL_TIMER" );
#precache( "string", "SM_TYPE_HVT_VTOL" );
// "Gain Access to Research Lab"
#precache( "string", "SM_TYPE_HVT_PANEL_INTRO_SPLASH1" );
#precache( "string", "SM_TYPE_HVT_PANEL_INTRO_SPLASH2" );
#precache( "string", "SM_TYPE_HVT_PANEL_INTRO_VO" );
#precache( "string", "SM_TYPE_HVT_PANEL_OUTRO_SPLASH1" );
#precache( "string", "SM_TYPE_HVT_PANEL_OUTRO_SPLASH2" );
#precache( "string", "SM_TYPE_HVT_PANEL_OUTRO_VO" );
#precache( "string", "SM_TYPE_HVT_PANEL_PROGRESS_VO1" );
#precache( "string", "SM_TYPE_HVT_PANEL" );
// "Eliminate Quad Tank"
#precache( "string", "SM_TYPE_HVT_QUADTANK_INTRO_SPLASH1" );
#precache( "string", "SM_TYPE_HVT_QUADTANK_INTRO_SPLASH2" );
#precache( "string", "SM_TYPE_HVT_QUADTANK_INTRO_VO" );
#precache( "string", "SM_TYPE_HVT_QUADTANK_OUTRO_SPLASH1" );
#precache( "string", "SM_TYPE_HVT_QUADTANK_OUTRO_SPLASH2" );
#precache( "string", "SM_TYPE_HVT_QUADTANK_OUTRO_VO" );
#precache( "string", "SM_TYPE_HVT_QUADTANK_PROGRESS_VO1" );
#precache( "string", "SM_TYPE_HVT_QUADTANK" );
// "Extract Prototype from Quad Tank"
#precache( "string", "SM_TYPE_HVT_BLACKBOX_INTRO_SPLASH1" );
#precache( "string", "SM_TYPE_HVT_BLACKBOX_INTRO_SPLASH2" );
#precache( "string", "SM_TYPE_HVT_BLACKBOX_INTRO_VO" );
#precache( "string", "SM_TYPE_HVT_BLACKBOX_OUTRO_SPLASH1" );
#precache( "string", "SM_TYPE_HVT_BLACKBOX_OUTRO_SPLASH2" );
#precache( "string", "SM_TYPE_HVT_BLACKBOX_OUTRO_VO" );
#precache( "string", "SM_TYPE_HVT_BLACKBOX_PROGRESS_VO1" );
#precache( "string", "SM_TYPE_HVT_BLACKBOX" );
// "Reach Boat to Exfil"
#precache( "string", "SM_TYPE_HVT_EXFIL_GO_INTRO_SPLASH1" );
#precache( "string", "SM_TYPE_HVT_EXFIL_GO_INTRO_SPLASH2" );
#precache( "string", "SM_TYPE_HVT_EXFIL_GO_INTRO_VO" );
#precache( "string", "SM_TYPE_HVT_EXFIL_GO_OUTRO_SPLASH1" );
#precache( "string", "SM_TYPE_HVT_EXFIL_GO_OUTRO_SPLASH2" );
#precache( "string", "SM_TYPE_HVT_EXFIL_GO_OUTRO_VO" );
#precache( "string", "SM_TYPE_HVT_EXFIL_GO_PROGRESS_VO1" );
#precache( "string", "SM_TYPE_HVT_EXFIL_GO_PROGRESS_VO2" );
#precache( "string", "SM_TYPE_HVT_EXFIL_GO_SOFTFAIL_VO1" );
#precache( "string", "SM_TYPE_HVT_EXFIL_GO_SOFTFAIL_VO2" );
#precache( "string", "SM_TYPE_HVT_EXFIL_GO" );
// END OF NEW HVT OBJECTIVE STRINGS

#precache( "triggerstring", "SM_TYPE_HVT_HACK_VTOL" );
#precache( "triggerstring", "SM_TYPE_HVT_HACK_TERMINAL" );


#precache( "string", "SM_TYPE_SABOTAGE_TIMER_A" );
#precache( "string", "SM_TYPE_HVT_HACK_BLACKBOX" );

//temp
#precache( "string", "SM_TYPE_SECURE_GOODS_PROMPT_SECURITY_LEFT_WIRE" );
#precache( "string", "SM_TYPE_SECURE_GOODS_PROMPT_SECURITY_RIGHT_WIRE" );

function autoexec sidemission_hvt_precache()
{

}

function _update_waypoint( str_waypoint, n_z_offset, b_track_health = true )
{
	hvt_hud_waypoint = sm_ui::create_objective_waypoint( str_waypoint, self.origin, n_z_offset);
	hvt_hud_waypoint SetWayPoint( true, str_waypoint, false, false );
	self.max_health = self.health;
	
	while( isdefined( self) && ( !b_track_health || isalive( self ) ) )
	{
		hvt_hud_waypoint.x = self.origin[0];
		hvt_hud_waypoint.y = self.origin[1];
		hvt_hud_waypoint.z = self.origin[2] + n_z_offset;
		
		{wait(.05);};
	}
	
	hvt_hud_waypoint destroy();
}

function _open_garage()
{	
	garage_door = GetEnt( "HVT_garage_door", "targetname" );
	
	if ( ( isdefined( garage_door.garage_open ) && garage_door.garage_open ) )
	{
		return;
	}
	
	sm_hvt::_spawn_quadtank();
	
	garage_door playsound ("evt_garage_open");
	
	garage_door MoveZ( 1000.0, 5.0, 2.0, 0.5 );
	garage_door.garage_open = true;
	garage_door waittill( "movedone" );
	
	garage_door ConnectPaths();
	
	level flag::set( "garage_open" );
}

function _spawn_quadtank()
{
	if ( isdefined( level.vh_hvt_quadtank ) )
	{
		return;
	}
	
	a_locs = struct::get_array( level.s_hvt_loc.target, "targetname" );
	
	a_hvt_quadtank_loc = [];
	
	foreach( s_loc in a_locs )
	{
		if ( s_loc.script_string == "quadtank" )
		{
			if ( !isdefined( a_hvt_quadtank_loc ) ) a_hvt_quadtank_loc = []; else if ( !IsArray( a_hvt_quadtank_loc ) ) a_hvt_quadtank_loc = array( a_hvt_quadtank_loc ); a_hvt_quadtank_loc[a_hvt_quadtank_loc.size]=s_loc;;
		}
		level._effect[ "blue_glow" ] = "light/fx_light_glow_hack_blue";
	}
	
	assert( a_hvt_quadtank_loc.size, "cHVT - no spawn location struct for HVT quadtank found!" );
	
	spawner_quadtank = GetEnt( "hvt_quadtank", "script_noteworthy" );
	s_spawnpos = array::random( a_hvt_quadtank_loc );
	spawner_quadtank.origin = s_spawnpos.origin;
	vh_qtank = spawner_quadtank spawner::spawn();
	
	level.vh_hvt_quadtank = vh_qtank;
}

class cObjHVTInfil : cSideMissionObjective
{
	var m_vh_vtol; // VTOL lands, hack the blackbox before it takes off
	var m_hackable; // hackable point on the VTOL
	var m_s_hack; // struct for the hackable point's location
	var m_ai_vtol_pilot; // VTOL pilot, goes to VTOL if timer runs out; if he reaches his destination and the players haven't already acquired the codes, the players fail the mission
	var m_n_hud_objective; // objective reference (need so we can set the timer if enemies are alerted)
	
	function level_init()
	{
		thread init_vtol();
		thread init_vtol_pilot();

		//  VO and splash
		add_intro_vo( &"SM_TYPE_HVT_VTOL_INTRO_VO", "vox_dt_net_interface" );
		add_intro_splash( &"SM_TYPE_HVT_VTOL_INTRO_SPLASH1", &"SM_TYPE_HVT_VTOL_INTRO_SPLASH2" );
		add_outro_vo( &"SM_TYPE_HVT_VTOL_OUTRO_VO", "vox_dt_received_codes" );
		add_outro_splash( &"SM_TYPE_HVT_VTOL_OUTRO_SPLASH1", &"SM_TYPE_HVT_VTOL_OUTRO_SPLASH2" );
		add_pause_objective( &"SM_TYPE_HVT_VTOL" );
	
		// TODO: add
		// progress reminder
		//#precache( "string", "SM_TYPE_HVT_VTOL_PROGRESS_VO1" );
		//#precache( "string", "SM_TYPE_HVT_VTOL_PROGRESS_VO2" );
		
		m_hackable = undefined;
	}
	
	function init_vtol()
	{
		// get ents
		sp_vtol = GetEnt( "spawner_hvt_vtol", "targetname" );
		nd_first = GetVehicleNode( sp_vtol.target, "targetname" );
		
		// spawn vtol, fly in and land
		m_vh_vtol = vehicle::simple_spawn_single( "spawner_hvt_vtol" );
		m_vh_vtol AttachPath( nd_first );
		m_vh_vtol StartPath();

		// play landing sound
		//m_vh_vtol waittill( "landing" );
		//m_vh_vtol playsound ("veh_osp_land");
		
		m_vh_vtol waittill( "reached_end_node" );

		// turn engines off
		m_vh_vtol vehicle::toggle_sounds(0);
		
		// swap out for model, so we can have pathing inside it
		scriptmodel_vtol = GetEnt( "hvt_vtol_model", "targetname" );
		scriptmodel_vtol NotSolid();
		scriptmodel_vtol.origin = m_vh_vtol.origin;
		// play ground idle loop
		scriptmodel_vtol playloopsound ("veh_osp_ground_idle", 1);
		nd_hidden_place = GetVehicleNode( "vtol_hidden_place", "targetname" );
		m_vh_vtol AttachPath( nd_hidden_place );
		m_vh_vtol StartPath();

		// time for vtol to depart
		level waittill( "vtol_takeoff" );
		
		// turn on audio
		m_vh_vtol playsound ("veh_osp_takeoff");
		m_vh_vtol vehicle::toggle_sounds(1);		
		
		// delete fake vtol
		scriptmodel_vtol Delete();
		scriptmodel_vtol_clip = GetEnt( "vtol_fake_clip", "targetname" );
		scriptmodel_vtol_clip Delete();

		// vtol take off
		nd_depart = GetVehicleNode( "intercept_vtol_path", "targetname" );
		m_vh_vtol AttachPath( nd_depart );
		m_vh_vtol StartPath();
		
		// mission failed

		// remove hackable
		m_hackable.wp_hack Destroy();
		[[m_hackable]]->clean_up();
		// mission fail stuff
		mission_fail( &"SM_TYPE_HVT_VTOL_FAIL_SPLASH" );
		sm_ui::temp_vo( &"SM_TYPE_HVT_VTOL_FAIL_VO" );
		cSidemissionObjective::mission_fail();
	}

	function init_vtol_pilot()
	{
		m_ai_vtol_pilot = vtol_pilot_spawn();
		Assert( isdefined( m_ai_vtol_pilot ), "init_vtol_pilot: m_ai_vtol_pilot undefined!" );
	}

	function vtol_pilot_spawn()
	{
		sp_spawner = GetEnt( "sm_hvt_vtol_pilot", "targetname" );
		
		ai = sp_spawner spawner::spawn();
		
		return ai;
	}
	
	function vtol_pilot_watch_for_threat()
	{
		m_ai_vtol_pilot endon ( "death" );
		level endon( "pilot_going_to_vtol" );
		
		thread sidemission_type_base::set_jumpto( m_ai_vtol_pilot.origin, "HVT/Pilot" );
		
		/*
		while( !m_ai_vtol_pilot ai::is_awareness_combat() )
		{
			util::wait_network_frame();
		}
		*/

		// soft fail - "you've been discovered!" line
		sm_ui::temp_vo( &"SM_TYPE_HVT_VTOL_SOFTFAIL_VO", "vox_dt_kill_pilot" );
		
		// end the timer, if it hasn't already been
		n_time = sm_ui::hud_objective_timer_get_time( m_n_hud_objective );
		if ( n_time > 1 )
		{
			sm_ui::hud_objective_set_timer( m_n_hud_objective, 1 ); // set the timer to 1, should trigger the pilot being sent to the vtol
		}
	}

	function vtol_pilot_go_to_vtol()
	{
		m_ai_vtol_pilot endon ( "death" );
		sm_ui::hud_objective_timer_wait( m_n_hud_objective );

		level notify( "pilot_going_to_vtol" );
//		/# IPrintLn( "PILOT GO TO VTOL" ); #/
		//m_ai_vtol_pilot ai::force_awareness_to_combat();
		m_ai_vtol_pilot.ignoreall = true;
		sm_ui::icon_add( m_ai_vtol_pilot, "kill" );
		
		// send to VTOL
		s_vtol_pilot_seat = struct::get( "hvt_vtol_pilot_seat" );
		v_pos = s_vtol_pilot_seat.origin;
		m_ai_vtol_pilot.goalradius = 64;
		is_valid = m_ai_vtol_pilot SetGoal( v_pos, true );
		Assert( is_valid, "vtol_pilot_go_to_vtol() - m_ai_vtol_pilot's SetGoalPos returned invalid" );

		// wait for pilot to reach the vtol
		m_ai_vtol_pilot waittill( "goal" );
		level notify( "vtol_takeoff" );
		// remove pilot
		m_ai_vtol_pilot Delete();
	}
	
	function main()
	{
		m_s_hack = struct::get( "hack_blackbox", "targetname" );

		m_hackable = new cHackableObject();
		[[m_hackable]]->setup_hackable_object( m_s_hack.origin + (0,0,4), &"SM_TYPE_HVT_HACK_VTOL", m_s_hack.angles );
		[[m_hackable]]->set_custom_hack_time( 1.0 );
		
		m_hackable.wp_hack = sm_ui::create_objective_waypoint( "t7_hud_prompt_press_64", m_s_hack.origin, 0);
		m_hackable.wp_hack SetWayPoint( true, "t7_hud_prompt_press_64", false, false );
		sm_ui::icon_add( m_hackable.m_e_origin, "interact" ); // BLUE DIAMOND
		
		// set objective status and timer
//		m_n_hud_objective = sm_ui::hud_objective_register( &"SM_TYPE_HVT_VTOL_INTRO_SPLASH2" );
		m_n_hud_objective = sm_ui::hud_objective_register( &"SM_TYPE_HVT_VTOL_TIMER" );
		sm_ui::hud_objective_set( m_n_hud_objective, 180 );
		sm_ui::hud_objective_add_timer( m_n_hud_objective, 180 );

		thread vtol_pilot_go_to_vtol(); // thread that will send the pilot to the vtol if the timer runs out
		thread vtol_pilot_watch_for_threat(); // thread that will set the timer to zero, if the pilot is alerted
		
		thread sidemission_type_base::set_jumpto( m_s_hack.origin, "HVT/Hackable (VTOL)" );
		
		// block until codes have been retrieved from the VTOL
		[[m_hackable]]->wait_till_hacking_completed();
		m_hackable.wp_hack Destroy();
		sm_ui::icon_remove( m_hackable.m_e_origin );
		
		// clear the objective display
		sm_ui::hud_objective_remove_timer( m_n_hud_objective );
		sm_ui::hud_objective_remove_all();
		
		level flag::set( "sm_vtol_accessed" ); // will allow reinforcements to spawn next time that enemies are alerted
		
		level notify( "sm_respawn_spectators" );
	}
}

class cObjHVTPanel : cSidemissionObjective
{
	var m_hackable;
	var m_s_hack;
	
	function level_init()
	{
		add_intro_vo( &"SM_TYPE_HVT_PANEL_INTRO_VO", "vox_dt_sec_terminal" );
		add_intro_splash( &"SM_TYPE_HVT_PANEL_INTRO_SPLASH1", &"SM_TYPE_HVT_PANEL_INTRO_SPLASH2" );
		add_outro_vo( &"SM_TYPE_HVT_PANEL_OUTRO_VO", "vox_dt_nice_job" );
		add_outro_splash( &"SM_TYPE_HVT_PANEL_OUTRO_SPLASH1", &"SM_TYPE_HVT_PANEL_OUTRO_SPLASH2" );
		
		add_pause_objective( &"SM_TYPE_HVT_PANEL" );
		
		m_hackable = undefined;
	}
	
	function main()
	{
		m_s_hack = struct::get( "hack_garage", "targetname" );
		
		hack_snd_ent = spawn( "script_origin", (m_s_hack.origin) );
		hack_snd_ent playloopsound( "amb_terminal_loop", .5 );

		m_hackable = new cHackableObject();
		[[m_hackable]]->setup_hackable_object( m_s_hack.origin + (0,0,4), &"SM_TYPE_HVT_HACK_TERMINAL", m_s_hack.angles );
		[[m_hackable]]->set_custom_hack_time( 1.0 );
		
		m_hackable.wp_hack = sm_ui::create_objective_waypoint( "t7_hud_prompt_press_64", m_s_hack.origin, 0);
		m_hackable.wp_hack SetWayPoint( true, "t7_hud_prompt_press_64", false, false );
		sm_ui::icon_add( m_hackable.m_e_origin, "interact" ); // BLUE DIAMOND
		
		thread sidemission_type_base::set_jumpto( m_s_hack.origin, "HVT/Hackable (Garage)" );
		
		[[m_hackable]]->wait_till_hacking_completed();
		
		level notify( "sm_respawn_spectators" );
		
		hack_snd_ent playsound("evt_garage_hacked");
		m_hackable.wp_hack Destroy();
		sm_ui::icon_remove( m_hackable.m_e_origin );
		
		thread sm_hvt::_open_garage();
	}
}

class cObjHVTQuadtank : cSidemissionObjective
{
	function level_init()
	{	
		add_intro_vo( &"SM_TYPE_HVT_QUADTANK_INTRO_VO", "vox_dt_prototype_hostile" );
		add_intro_splash( &"SM_TYPE_HVT_QUADTANK_INTRO_SPLASH1", &"SM_TYPE_HVT_QUADTANK_INTRO_SPLASH2" );
		add_outro_splash( &"SM_TYPE_HVT_QUADTANK_OUTRO_SPLASH1", &"SM_TYPE_HVT_QUADTANK_OUTRO_SPLASH2" );
//		add_outro_vo( &"SM_TYPE_HVT_QUADTANK_OUTRO_VO", "vox_Excellent_Job" );
		add_outro_vo( &"SM_TYPE_HVT_QUADTANK_OUTRO_VO", "vox_dt_tank_neutralized" );
		add_pause_objective( &"SM_TYPE_HVT_QUADTANK" );
	}
	
	function main()
	{
		// In case we skipped the hack objective, open it automagically.
		//
		thread sm_hvt::_open_garage();
		
		if ( isdefined( level.vh_hvt_quadtank ) )
		{
			/#
			// If player is in god mode, make the QT die quickly.
			//
			if ( IsGodMode( level.players[0] ) )
			{
				level.vh_hvt_quadtank.health = 1;
			}
			#/
				
			if ( IsAlive( level.vh_hvt_quadtank ) )
			{
				level.vh_hvt_quadtank thread sm_hvt::_update_waypoint("waypoint_kill",180);
				sm_ui::icon_add( level.vh_hvt_quadtank, "kill" );
				
				thread sidemission_type_base::set_jumpto( level.vh_hvt_quadtank.origin, "HVT/QuadTank" );
				
				level.vh_hvt_quadtank waittill( "death" );
			}
			
			level.v_hvt_black_box = level.vh_hvt_quadtank.origin;
		}
		
		level notify( "sm_respawn_spectators" );
	}
}

class cObjHVTBlackBox : cSidemissionObjective
{
	var m_hackable;
	
	function level_init()
	{		
		add_intro_vo( &"SM_TYPE_HVT_BLACKBOX_INTRO_VO", "vox_dt_extract_data" );
		add_intro_splash( &"SM_TYPE_HVT_BLACKBOX_INTRO_SPLASH1", &"SM_TYPE_HVT_BLACKBOX_INTRO_SPLASH2" );
		add_outro_vo( &"SM_TYPE_HVT_BLACKBOX_OUTRO_VO", "vox_dt_got_data" );
		add_outro_splash( &"SM_TYPE_HVT_BLACKBOX_OUTRO_SPLASH1", &"SM_TYPE_HVT_BLACKBOX_OUTRO_SPLASH2" );
		
		add_pause_objective( &"SM_TYPE_HVT_BLACKBOX" );
	}
	
	function main()
	{
		if ( !isdefined( level.v_hvt_black_box ) )
		{
			level.v_hvt_black_box = level.s_hvt_loc.origin;
		}
		
		const TRIGGER_SPAWN_FLAGS = 0;
		const TRIGGER_RADIUS = 100;
		const TRIGGER_HEIGHT = 100;
		
		v_offset = ( 0, 0, 16);
			
		m_trigger = Spawn( "trigger_radius_use", level.v_hvt_black_box + v_offset, TRIGGER_SPAWN_FLAGS, TRIGGER_RADIUS, TRIGGER_HEIGHT );
		m_trigger.angles = (0, 0, 0);  // used in temp anim setup for player orientation
		m_trigger SetCursorHint( "HINT_NOICON" );
		m_trigger TriggerIgnoreTeam();
		
		m_o_worldspace = sm_hvt::worldspace_prompt_create( m_trigger, 512, &"SM_TYPE_HVT_HACK_BLACKBOX", &"SM_TYPE_HVT_HACK_BLACKBOX", 52 );
		
	//	m_trigger SetHintString( &"SM_TYPE_HVT_HACK_BLACKBOX" );
		m_o_worldspace sm_hvt::worldspace_prompt_show();
		
		m_trigger flag::init( "wire_rip_right_done" );
		m_trigger flag::init( "wire_rip_left_done" );
	
		b_event_completed = false;
		
		
		m_trigger.waypoint = sm_ui::create_objective_waypoint( "t7_hud_prompt_press_64", level.v_hvt_black_box + (0,0,16), 0);
		m_trigger.waypoint SetWayPoint( true, "t7_hud_prompt_press_64", false, false );
		
		thread sidemission_type_base::set_jumpto( m_trigger.origin, "HVT/Blackbox" );
		
		while( !b_event_completed )
		{
			m_trigger waittill("trigger", player);
			
			if ( !player is_player_valid() )
			{
				continue;
			}
			
			m_o_worldspace sm_hvt::worldspace_prompt_hide();
			
			b_event_completed = m_trigger blackbox_interactive_sequence( player );

		}
		
		m_trigger.waypoint destroy();
//		m_hackable = new cHackableObject();
//		[[m_hackable]]->setup_hackable_object( level.v_hvt_black_box + (0,0,4), &"SM_TYPE_HVT_HACK_BLACKBOX" );
//		[[m_hackable]]->set_custom_hack_time( 10.0 );
//		
//		m_hackable.waypoint = sm_ui::create_objective_waypoint( WAYPOINT_HACK, level.v_hvt_black_box + (0,0,16), 0);
//		m_hackable.waypoint SetWayPoint( true, WAYPOINT_HACK, true, false );

		//[[m_hackable]]->wait_till_hacking_completed();
		
		
//		m_hackable.waypoint Destroy();

		level notify( "sm_respawn_spectators" );
	}
	
	function blackbox_interactive_sequence( player )
	{
		player temp_player_lock_in_place( self );
		
		self circuit_breaker_wire_rip_left( player );
		self circuit_breaker_wire_rip_right( player );
		
		player temp_player_lock_in_place_remove();
		
		b_sequence_complete = ( flag::get( "wire_rip_right_done" ) && flag::get( "wire_rip_left_done" ) );
		
		return b_sequence_complete;	
		
	}

	function circuit_breaker_wire_rip_left( player )
	{
		if ( IsDefined( player ) && player is_player_valid() )
		{
			if ( !self flag::get( "wire_rip_left_done" ) )
			{
				// prompt player to push left on left stick
				player util::screen_message_create_client( &"SM_TYPE_SECURE_GOODS_PROMPT_SECURITY_LEFT_WIRE", undefined, undefined, -60 );
				
				// wait for input
				self wait_for_left_stick_input( player );
				
				if ( IsDefined( player ) )
				{
					player util::screen_message_delete_client();
				}
			}
		}
	}
	
	function wait_for_left_stick_input( player )  // self = trigger
	{
		player endon( "death" );
		player endon( "entering_last_stand" );
		
		const LEFT_MAGNITUDE = -0.5;
		
		n_frames_held = 0;
		
		while ( n_frames_held < ( 1 * 20 ) )
		{
			v_stick = player GetNormalizedMovement();
			n_left = v_stick[ 1 ];
			
			if ( n_left < LEFT_MAGNITUDE )
			{
				if ( n_frames_held == 0 )
				{
					m_progress_bar = player hud::createPrimaryProgressBar();
					m_progress_bar thread do_bar_update( 1 );						
				}
				
				n_frames_held++;
			}
			else 
			{
				n_frames_held = 0;
				
				if ( IsDefined( m_progress_bar ) )
				{
					m_progress_bar destroy_progress_bar();
				}
			}
			
			{wait(.05);};
		}
		
		if ( IsDefined( m_progress_bar ) )
		{
			m_progress_bar destroy_progress_bar();
		}
		
		flag::set( "wire_rip_left_done" );
	}
	
	function destroy_progress_bar()  // self = hud elem
	{
		if ( IsDefined( self ) )
		{
			self notify( "kill_bar" );
			self hud::destroyElem();				
		}
	}
	
	function wait_for_right_stick_input( player )  // self = trigger
	{
		player endon( "death" );
		player endon( "entering_last_stand" );
		
		const RIGHT_MAGNITUDE = 0.5;
		
		n_frames_held = 0;
		
		while ( n_frames_held < ( 1 * 20 ) )
		{
			v_stick = player GetNormalizedCameraMovement();
			n_right = v_stick[ 1 ];
			
			if ( n_right > RIGHT_MAGNITUDE )
			{
				if ( n_frames_held == 0 )
				{
					m_progress_bar = player hud::createPrimaryProgressBar();
					m_progress_bar thread do_bar_update( 1 );						
				}				
				
				n_frames_held++;
			}
			else 
			{
				n_frames_held = 0;
				
				if ( IsDefined( m_progress_bar ) )
				{
					m_progress_bar destroy_progress_bar();
				}				
			}
			
			{wait(.05);};
		}
		
		if ( IsDefined( m_progress_bar ) )
		{
			m_progress_bar destroy_progress_bar();
		}		
		
		flag::set( "wire_rip_right_done" );
		
		player EnableWeapons();
		
		wait 1;  // player should not immediately drop out of this sequence, so hold for a little extra time
	}	
	
	function circuit_breaker_wire_rip_right( player )
	{
		player endon("death");
		
		if ( player is_player_valid() )
		{
			if ( !self flag::get( "wire_rip_right_done" ) )
			{
				// prompt player to push left on left stick
				player util::screen_message_create_client( &"SM_TYPE_SECURE_GOODS_PROMPT_SECURITY_RIGHT_WIRE", undefined, undefined, -60 );
				
				// wait for input
				self wait_for_right_stick_input( player );
				
				if ( IsDefined( player ) )
				{
					player util::screen_message_delete_client();
				}
			}
		}
	}	
	
	function play_circuit_breaker_panel_start_anim( player )
	{
		player endon( "death" );
		player endon( "entering_last_stand" );
		
		wait 3;  // this is where the animation will play
		
		self flag::set( "start_anim_done" );
		
		self.m_panel_door Hide();  // temp: door is "open"
	}
	
	// self = progressbar hud
	function do_bar_update( n_duration )
	{
		self endon( "kill_bar" );

		self hud::updateBar( 0.01, 1 / n_duration );
		
		wait n_duration;
		
		self hud::destroyElem();;
	}

	function is_player_valid()  // self = player
	{
		b_is_valid = true;
		
		if ( self laststand::player_is_in_laststand() )
		{
			b_is_valid = false;
		}
		
		return b_is_valid;
	}
	
	function temp_player_lock_in_place( trigger )  // self = player
	{
		const DISTANCE_PROJECTION = 50;
		
		v_lock_position = ( trigger.origin + VectorNormalize( AnglesToForward( trigger.angles ) ) * DISTANCE_PROJECTION );
		v_lock_position_ground = BulletTrace( v_lock_position, v_lock_position - ( 0, 0, 100 ), false, undefined )[ "position" ];
		v_lock_angles = ( 0, VectorToAngles( VectorScale( AnglesToForward( trigger.angles ), -1 ) )[1], 0 );  // face the trigger (circuit breaker panel)
		
		self.circuit_breaker_lock_ent = Spawn( "script_origin", v_lock_position_ground );
		self.circuit_breaker_lock_ent.angles = self.angles;
		
		self PlayerLinkTo( self.circuit_breaker_lock_ent, undefined, 0, 0, 0, 0, 0 );  // don't allow player to look around during this sequence
		
		self DisableWeapons();
	}
	
	function temp_player_lock_in_place_remove()  // self = player
	{
		if ( IsDefined( self ) && IsDefined( self.circuit_breaker_lock_ent ) )
		{
			self Unlink();
			
			self.circuit_breaker_lock_ent Delete();
			
			self EnableWeapons();
		}
	}
}

class cObjHVTExfilGo : cSidemissionObjective
{
	var m_vtol;
	var m_t_exfil;
	
	function level_init()
	{	
		add_intro_vo( &"SM_TYPE_HVT_EXFIL_GO_INTRO_VO" );
		add_intro_splash( &"SM_TYPE_HVT_EXFIL_GO_INTRO_SPLASH1", &"SM_TYPE_HVT_EXFIL_GO_INTRO_SPLASH2" );
		add_outro_vo( &"SM_TYPE_HVT_EXFIL_GO_OUTRO_VO" );
		add_outro_splash( &"SM_TYPE_HVT_EXFIL_GO_OUTRO_SPLASH1", &"SM_TYPE_HVT_EXFIL_GO_OUTRO_SPLASH2" );
		
		add_pause_objective( &"SM_TYPE_HVT_EXFIL_GO" );
	}
	
	function main()
	{
		// BOAT APPROACHES
		m_boat = GetEnt( "hvt_exfil_boat", "targetname" );
		a_boat_clip = GetEntArray( "hvt_exfil_boat_clip", "targetname" );
		foreach( boat_clip in a_boat_clip )
		{
			boat_clip LinkTo( m_boat );
		}
		nd_boat_docked = GetNode( "hvt_boat_docked", "targetname" );
		m_boat MoveTo( nd_boat_docked.origin, 10, 1, 1 );
		m_t_exfil = GetEnt( "t_hvt_exfil_boat", "targetname" );
		sm_ui::icon_add( m_boat, "location" ); // YELLOW DIAMOND
		
		m_boat thread sm_hvt::_update_waypoint("t7_hud_waypoints_arrow", 85, false);
		
		while (!m_boat IsTouching( m_t_exfil ) )
		{
			wait 0.5;
		}
		
		// Give it a moment to settle into place.
		wait 3.0;
		
		thread sidemission_type_base::set_jumpto( m_boat.origin, "HVT/Exfil" );
		
		// Wait for all players to be inside.
		n_time_inside = 0.0;
		while ( true )
		{
			{wait(.05);};
			
			b_any_outside = false;
			foreach( e_player in level.players )
			{
				e_player.inside_exfil_trig = false;
				if ( e_player.sessionstate == "spectator" )
				{
					// doesn't count as being outside, since there's no saving them.
				}
				else if ( e_player laststand::player_is_in_laststand() )
				{
					b_any_outside = true;
				}
				else
				{
					e_player.inside_exfil_trig = e_player IsTouching( m_t_exfil );
					if ( !e_player.inside_exfil_trig )
					{
						b_any_outside = true;
					}
				}
			}
			
			if ( !b_any_outside )
			{
				n_time_inside += 0.05;
			} else {
				
				n_time_inside = 0.0;
			}
			
			// Show/hide the appropriate elements.
			foreach( e_player in level.players )
			{
				b_show_elem = b_any_outside && e_player.inside_exfil_trig;
				if ( b_show_elem && !isdefined( e_player.wait_elem ) )
				{
					e_player.wait_elem = e_player sm_ui::_create_client_hud_elem( "center", "middle", "center", "middle", 0, 0, 3.0, (1.0, 1.0, 1.0) );
					e_player.wait_elem SetText( "Waiting for Other Players" );
				} else if ( !b_show_elem && isdefined( e_player.wait_elem ) )
				{
					e_player.wait_elem Destroy();
				}
			}
			
			// Must be safely inside for 3 seconds.
			if (n_time_inside >= 3.0)
			{
				break;
			}
		}
		
		m_boat.kill_waypoint = true;
		
		// Can't move anymore, but can still look around.
		for ( i = 0; i < level.players.size; i++)
		{
			e_player = level.players[i];
			e_player.e_vh_link = util::spawn_model( "tag_origin", e_player.origin, e_player.angles );
			e_player PlayerLinkToDelta(e_player.e_vh_link, "tag_origin", 0.0, 360, 360 );
			e_player.e_vh_link LinkTo( m_boat );
			//e_player PlayerLinkToDelta(vh_vtol, "tag_guy" + (i + 1) );
		}

		// BOAT LEAVES		
		sm_ui::icon_remove( m_boat ); // remove yellow diamond
		nd_boat_departed = GetNode( "hvt_boat_departed", "targetname" );
		m_boat MoveTo( nd_boat_departed.origin, 30, 10, 1 );
	}
	
	//******************************************************************//
	//                     "PRIVATE" FUNCTIONS                          //
	//******************************************************************//
	function _spawn_vtol()
	{
		sp_vtol = GetEnt( "spawner_exfil_vtol", "targetname" );
		
		nd_last = sp_vtol;
		nd_first = GetVehicleNode( sp_vtol.target, "targetname" );
		
		vh_vtol = vehicle::simple_spawn_single( "spawner_exfil_vtol" );
		
		vh_vtol AttachPath( nd_first );
		vh_vtol StartPath();
		
		return vh_vtol;
	}
}

class cSideMissionHVT : cSideMissionBase
{
	var m_n_last_reminder_time;

	constructor()
	{
	}
	
	destructor()
	{
		clean_up();
	}
	
	function clean_up()
	{

	}
	
	function init()
	{
		sidemission_type_base::clear_jumpto();

		a_structs = struct::get_array( "sm_location", "targetname" );
		level.s_hvt_loc = undefined;
		
		// For now, let's just grab the first one available.
		//
		foreach( s_loc in a_structs )
		{
			if ( isdefined(s_loc.script_string) && s_loc.script_string == "HVT" )
			{
				level.s_hvt_loc = s_loc;
				break;
			}
		}
		assert( isdefined(level.s_hvt_loc), "cHVT - no spawn location struct for HVT found!" );
		
		level._effect[ "blue_glow" ] = "light/fx_light_glow_hack_blue";
	}
	
	function start_objective()
	{
		thread main();
	}
	
	function main()
	{
		level flag::init( "garage_open" );
		level flag::init( "sm_vtol_accessed" );
		
		sm_manager::add_objective(new cObjHVTInfil());
		sm_manager::add_objective(new cObjHVTPanel());
		sm_manager::add_objective(new cObjHVTQuadtank());
		sm_manager::add_objective(new cObjHVTBlackBox());
		sm_manager::add_objective(new cObjHVTExfilGo());
		
		// HACK: bug in UI that requires you to wait.
		//
		level waittill("prematch_over"); //Wait till timer has passed 
		level flag::wait_till( "all_players_spawned" );	
		level flag::wait_till( "zones_initialized" );
		
		thread wait_to_start_wave_spawning();
		
		wait 1.0;
		
		sm_ui::temp_vo( &"SM_TYPE_HVT_MAIN_VO", "vox_dt_54_quad_tank" );
		
		wait 3.0;
		
		sm_ui::splash_text( &"SM_TYPE_HVT_MAIN_SPLASH" );
		
		wait 4.0;
		
		sm_manager::start_objectives();
		sm_manager::waittill_complete();
		
		wait 5.0;
		
		sidemission_success();
	}

	// run this function to start wave spawning when infil guys go into combat, post-vtol being accessed
	function wait_to_start_wave_spawning()
	{
		level flag::wait_till( "sm_vtol_accessed" ); // we don't want reinforcements to begin until the players access the vtol
		level waittill( "sm_combat_started" );  // this notify can come from flag or scripted event
		wave_mgr::start_wave_spawning( 1 );
	}
	
}



function worldspace_prompt_create( ent, n_range_top_line, str_top_line, str_bottom_line, n_range_bottom_line )
{
	o_3d_message = new cFakeWorldspaceMessage();
	
	const TEXT_SCALE_TOP = 2.0;
	const TEXT_SCALE_BOTTOM = 1.0;
	
	[[o_3d_message]]->init( ent.origin, n_range_top_line );
	[[o_3d_message]]->set_parent( ent );
	
	if ( IsDefined( str_top_line ) )
	{
		[[o_3d_message]]->add_line( str_top_line, TEXT_SCALE_TOP, true );
	}	
	
	if ( IsDefined( str_bottom_line ) )
	{
		[[o_3d_message]]->add_line( str_bottom_line, TEXT_SCALE_BOTTOM, true );
	}
	
	if ( IsDefined( n_range_bottom_line ) )
	{
		o_3d_message.m_n_range_inner = n_range_bottom_line;	
	}
	
	return o_3d_message;
}

function worldspace_prompt_hide()
{
	[[self]]->can_display_text( false );
}

function worldspace_prompt_show()
{
	[[self]]->can_display_text( true );
}

function worldspace_prompt_delete()  // self = cFakeWorldSpaceMessage object
{
	[[self]]->uninitialize();
}
