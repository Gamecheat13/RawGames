#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\yemen_utility;
#include maps\_glasses;


/* ------------------------------------------------------------------------------------------
	INIT functions
-------------------------------------------------------------------------------------------*/

//	event-specific flags
init_flags()
{
	flag_init( "drones_online" );
	flag_init( "drones_hacked" );
	flag_init( "challenge_killwithdrones" );
	
	//Drone Controller
	flag_init( "drone_controller_button" );//spotlight version
	flag_init( "drone_controller_button_alt" );//texture version
	flag_init( "drone_controller_button_aoe" );//damage test
	
	//Objective flags
	flag_init( "obj_drone_control_follow" );	
	flag_init( "obj_drone_control_guantlet" );
	flag_init( "obj_drone_control_pathchoice" );
	flag_init( "obj_drone_control_bridge" );
}


//
//	event-specific spawn functions
init_spawn_funcs()
{

}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/

//	skip-to only initialization (not run if this event skip-to isn't used)
skipto_drone_control()
{
	skipto_setup();
	
	start_teleport( "skipto_drone_control_player" );
	
	//Salazar	
	if( !IsDefined( level.salazar ) )
	{
		sp_salazar = GetEnt("skipto_drone_control_salazar_spawn", "targetname");
	    level.salazar = simple_spawn_single(sp_salazar);
	    level.salazar make_hero();
	}
	
	skipto_teleport_ai( "skipto_drone_control_salazar", level.salazar );
}


/* ------------------------------------------------------------------------------------------
	MAIN functions 
-------------------------------------------------------------------------------------------*/

//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//		your skipto sequence will be called.
main()
{
	/#
		IPrintLn( "Drone Control" );
	#/
	
//	level.e_extra_cam = GetEnt( "s_drone_contlrol_extra_cam", "targetname" );
		
	//TODO: get VTOLS flying by	and being shot at
			//get mroe activity in scene before player shows up
		
	flag_set("obj_drone_control_follow");//follow Salazar
//	trigger_off( "trig_drone_control_custom_drone_kill1" );
//	trigger_off( "trig_drone_control_custom_drone_kill2" );
//	trigger_off( "trig_drone_control_custom_drone_kill3" );
	
//	level.s_drone_control_breadcrumb = GetStruct( "obj_drone_control_guantlet", "targetname" );
	
	autosave_by_name( "drone_control_start" );
	
	level thread drone_control_terrorists_cleanup();
		
	level thread drone_control_breadcrumb_door();
	level thread drone_control_breadcrumb_bridge();
	
	level thread drone_control_drones_online();
	level thread drone_control_update_breadcrumb();
	level thread drone_control_drones_offline();
	level thread drone_controller();	
	level thread drone_controller_alt();
	level thread drone_controller_aoe();
	
	level thread drone_control_enemies_shootat_vtol();
	level thread drone_control_spawn_camera_drone();
	level thread drone_control_spawn_enemy_target_vtol();
//	level thread drone_control_kill_guys();
}


/* ------------------------------------------------------------------------------------------
	EVENT functions
-------------------------------------------------------------------------------------------*/
drone_control_spawn_camera_drone()
{
	trigger_wait( "trig_vsp_drone_control_camera_drone", "targetname" );
	
	veh_camera_drone = maps\_vehicle::spawn_vehicle_from_targetname( "veh_drone_control_camera_drone");
//	veh_camera_drone.team = "allies";
//	veh_camera_drone SetTeam( "allies" );
	
	e_cam = get_extracam();	
	
//	while(true)
//	{
		e_cam.origin = veh_camera_drone.origin;
		e_cam.angles = veh_camera_drone.angles;
		
//		wait 0.05;
//	}

	
	e_cam LinkTo( veh_camera_drone );
	
	
//	CreateThreatBiasGroup( "camera_drone" );
//	CreateThreatBiasGroup( "terrorists" );
//	CreateThreatBiasGroup( "player" );
//	
//	SetThreatBias( "camera_drone", "terrorists", 5000 );
//	SetThreatBias( "camera_drone", "player", 0 );
//	SetThreatBias( "terrorists", "player", 1000 );
	
}

drone_control_spawn_enemy_target_vtol()
{
	trigger_wait( "trig_vsp_enemy_target_vtol", "targetname" );
	
	veh_vtol = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "veh_drone_control_enemy_target_vtol");

	a_terrorists = GetEntArray(	"sp_drone_control_terrorists_shooters_vtol", "targetname" );
	
//	a_terrorists add_spawn_function( );

	
	ai_shooter1 = simple_spawn_single("sp_drone_control_terrorists_shooters_vtol" );
	ai_shooter2 = simple_spawn_single("sp_drone_control_terrorists_shooters_vtol2" );
	
	ai_shooter1 shoot_at_target(veh_vtol, undefined, 0.25, 15);
	ai_shooter2 shoot_at_target(veh_vtol, undefined, 0.25, 15);
//	a_force_goal_guy = GetEntArray( "force_goal_guy", "script_noteworthy" );	
//	array_thread( a_terrorists, ::add_spawn_function, ::drone_control_spawn_enemies_setup  );
	
//	level thread drone_control_spawn_enemies_setup();
}

drone_control_spawn_enemies_setup()
{
	target = GetEnt( self.target, "targetname" );
	
	self shoot_at_target(target, undefined, 0.25, 15);
}

//Bredcrumbing
//TODO: make modular or move set_flags into other functions
drone_control_breadcrumb_door()
{
	trigger_wait( "trig_drone_control_obj_breadcrumb_door" );
	
	flag_set("obj_drone_control_guantlet");
}

drone_control_breadcrumb_bridge()
{
	trigger_wait( "trig_drone_control_obj_breadcrumb_bridge" );
	
	flag_set( "obj_drone_control_bridge" );
}

//v_hijacked_vtol_shotat1
drone_control_enemies_shootat_vtol()
{
//	trigger_wait( "trig_vspn_vtol_shootat1" );
//	wait 1; //give vtol time to get started
//	v_vtol = GetEnt( "v_hijacked_vtol_shotat1", "targetname" );
	
}

drone_control_vtol_cleanup()
{
//	trigger_wait( "trig_drone_control_obj_breadcrumb_bridge" );
	
}
//Cleaning up guys - trying to at least
drone_control_terrorists_cleanup()
{
	a_run_triggers = GetEntArray("trig_drone_control_cleanup_terrorists", "targetname");
	array_thread(a_run_triggers, ::drone_control_terrorists_cleanup_think);
}

drone_control_terrorists_cleanup_think()
{
	self waittill("trigger");
	
	ai_terrorist = GetEntArray( self.target, "targetname" );
	array_delete(ai_terrorist );
}

//Breadcruming Test
drone_control_update_breadcrumb()
{	
	a_run_triggers = GetEntArray("trig_drone_control_breadcrumb", "targetname");
	array_thread(a_run_triggers, ::drone_control_update_breadcrumb_think);
}

drone_control_update_breadcrumb_think()
{
	self waittill("trigger");//self is a trigger	
	flag_clear( level.s_drone_control_breadcrumb.targetname );
	level.s_drone_control_breadcrumb = GetStruct( self.target, "targetname" );
	flag_set(level.s_drone_control_breadcrumb.targetname);
}

/* ------------------------------------------------------------------------------------------
	DRONE CONTROLS functions
-------------------------------------------------------------------------------------------*/


//Drone control online
drone_control_drones_online()
{
	trigger_wait("trig_drone_conltrol_drones_online");
	
	IPrintLnBold("---------=====Drones Online=====---------");
	IPrintLnBold("------------------DPAD UP----------------");

	IPrintLnBold("(First person animation of typing on arm control panel)");
	
	wait 1;//temp - wait before starting bink
	
	level thread play_bink_on_hud_glasses("eye_v2");	
	
	turn_on_extra_cam();

	wait 15;//how long extra cam stays on
	
	turn_off_extra_cam();

	flag_toggle("drones_online");
}

//Drone control off
drone_control_drones_offline()
{
	trigger_wait("trig_drone_conltrol_drones_offline");
	
	flag_set("obj_drone_control_bridge");
	
	IPrintLnBold("---------=====Drones Offline=====---------");
	
	flag_toggle("drones_hacked");
	flag_toggle("drones_online");
	
	level thread play_bink_on_hud_glasses("crc_test_v6");
}

//These are all WIP that are dependant on how FX decides to draw the grid
//Light version
drone_controller()
{
	// level endon( "something" );
	flag_wait("drones_online");
	
	level thread drone_controller_think();
	
	while(true)
	{
		if(flag( "drones_online" )) //Drones online
		{
			//IPrintLnBold("TOGGLED");
			
			if( level.player ButtonPressed( "DPAD_UP" ) )
			{
				flag_toggle( "drone_controller_button" );
				
				while( level.player ButtonPressed( "DPAD_UP" ) )
				{
					wait 0.05;	
				}
			}	   	
		 }
		else
		{
			flag_clear( "drone_controller_button" ); //Drones hijacked
		}
		
		wait 0.05;
	}
}

drone_controller_think()
{	
	// level endon( "something" );
	
	m_drone_controller_fx = undefined;
	
	while( true )
	{
		flag_wait( "drone_controller_button" );
		
		while( flag( "drone_controller_button" ) )
		{
			if( !IsDefined( m_drone_controller_fx ) )
			{
				m_drone_controller_fx = Spawn( "script_model", (0, 0, 0) );
				m_drone_controller_fx SetModel( "tag_origin" );
				//PlayFXOnTag( level._effect["fx_overlay_decal"], m_drone_controller_fx, "tag_origin" );
				PlayFXOnTag( level._effect["fx_overlay_light"], m_drone_controller_fx, "tag_origin" );
			}
			
			v_eye_pos = level.player geteye();
			v_player_eye = level.player GetPlayerAngles();	;
			
			m_drone_controller_fx.origin = v_eye_pos;
			m_drone_controller_fx.angles = v_player_eye;
			
			wait 0.05;
		}
		
		m_drone_controller_fx Delete();
	}
}

//Decal version
drone_controller_alt()
{
	// level endon( "something" );
	flag_wait("drones_online");
	
	level thread drone_controller_alt_think();
	
	while(true)
	{
		if(flag( "drones_online" )) //Drones online
		{
			//IPrintLnBold("TOGGLED");
			
			if( level.player ButtonPressed( "DPAD_DOWN" ) )
			{
				flag_toggle( "drone_controller_button_alt" );
				
				while( level.player ButtonPressed( "DPAD_DOWN" ) )
				{
					wait 0.05;	
				}
			}	   	
		 }
		else
		{
			flag_clear( "drone_controller_button_alt" ); //Drones hijacked
		}
		
		wait 0.05;
	}
}

drone_controller_alt_think()
{	
	// level endon( "something" );
	
	m_drone_controller_fx = undefined;
	
	while( true )
	{
		flag_wait( "drone_controller_button_alt" );
		
		while( flag( "drone_controller_button_alt" ) )
		{
			if( !IsDefined( m_drone_controller_fx ) )
			{
				m_drone_controller_fx = Spawn( "script_model", (0, 0, 0) );
				m_drone_controller_fx SetModel( "tag_origin" );
				PlayFXOnTag( level._effect["fx_overlay_decal"], m_drone_controller_fx, "tag_origin" );
				//PlayFXOnTag( level._effect["fx_overlay_light"], m_drone_controller_fx, "tag_origin" );
			}
			
			v_eye_pos = level.player geteye();
			
			v_player_eye = level.player getPlayerAngles();
			v_player_eye = VectorNormalize( AnglesToForward( v_player_eye ) );
			
			v_trace_to_point = v_eye_pos + ( v_player_eye * 5000 );
			a_trace = BulletTrace( v_eye_pos, v_trace_to_point, false, level.player );
			
			m_drone_controller_fx.origin = a_trace["position"];
			
			//m_drone_controller_light_fx.origin = v_eye_pos; // test for light
			
			wait 0.05;
		}
		
		m_drone_controller_fx Delete();
	}
}

//TEMP - kills dudes at targeted point - to test how it will feel in game
drone_controller_aoe()
{
	// level endon( "something" );
	flag_wait("drones_online");
	
	level thread drone_controller_aoe_think();
	
	while(true)
	{
		if(flag( "drones_online" )) //Drones online
		{
			//IPrintLnBold("TOGGLED");
			
			if( level.player ButtonPressed( "DPAD_RIGHT" ) )
			{
				flag_toggle( "drone_controller_button_aoe" );
				
				while( level.player ButtonPressed( "DPAD_RIGHT" ) )
				{
					wait 0.05;	
				}
			}	   	
		 }
		else
		{
			flag_clear( "drone_controller_button_aoe" ); //Drones hijacked
		}
		
		wait 0.05;
	}
}

drone_controller_aoe_think()
{	
	// level endon( "something" );
	
	m_drone_controller_fx = undefined;
	
	while( true )
	{
		flag_wait( "drone_controller_button_aoe" );
		
		//wait 1;
		
		while( flag( "drone_controller_button_aoe" ) )
		{
			if( !IsDefined( m_drone_controller_fx ) )
			{
				m_drone_controller_fx = Spawn( "script_model", (0, 0, 0) );
				m_drone_controller_fx SetModel( "tag_origin" );
				PlayFXOnTag( level._effect["fx_overlay_decal"], m_drone_controller_fx, "tag_origin" );
				//PlayFXOnTag( level._effect["fx_overlay_light"], m_drone_controller_fx, "tag_origin" );
			}
			
			v_eye_pos = level.player geteye();
			
			v_player_eye = level.player getPlayerAngles();
			v_player_eye = VectorNormalize( AnglesToForward( v_player_eye ) );
			
			v_trace_to_point = v_eye_pos + ( v_player_eye * 5000 );
			a_trace = BulletTrace( v_eye_pos, v_trace_to_point, false, level.player );
			
			m_drone_controller_fx.origin = a_trace["position"];
			
			m_drone_controller_fx MagicGrenadeType( "frag_grenade_sp", m_drone_controller_fx.origin, (0, 5, 0), 0.5 );
			m_drone_controller_fx MagicGrenadeType( "frag_grenade_sp", m_drone_controller_fx.origin, (0, 0, 5), 0.75 );
			m_drone_controller_fx MagicGrenadeType( "frag_grenade_sp", m_drone_controller_fx.origin, (5, 0, 0), 0.75 );
			
//			set_objective( undefined, m_drone_controller_fx.origin, "breadcrumb" );
			
			wait 0.25;
		}
		
		m_drone_controller_fx Delete();
	}
}

////TEMP - kills dudes at targeted point - to test how it will feel in game
//drone_controller_aoe()
//{
//	// level endon( "something" );
//	flag_wait("drones_online");
//	
//	level thread drone_controller_aoe_think();
//	
//	while(true)
//	{
//		if(flag( "drones_online" )) //Drones online
//		{
//			//IPrintLnBold("TOGGLED");
//			
//			if( level.player ButtonPressed( "DPAD_RIGHT" ) )
//			{
//				flag_toggle( "drone_controller_button_aoe" );
//				
//				while( level.player ButtonPressed( "DPAD_RIGHT" ) )
//				{
//					wait 0.05;	
//				}
//			}	   	
//		 }
//		else
//		{
//			flag_clear( "drone_controller_button_aoe" ); //Drones hijacked
//		}
//		
//		wait 0.05;
//	}
//}
//
//drone_controller_aoe_think()
//{	
//	// level endon( "something" );
//	
//	m_drone_controller_fx = undefined;
//	
//	while( true )
//	{
//		flag_wait( "drone_controller_button_aoe" );
//		
//		//wait 1;
//		
//		while( flag( "drone_controller_button_aoe" ) )
//		{
//			if( !IsDefined( m_drone_controller_fx ) )
//			{
//				m_drone_controller_fx = Spawn( "script_model", (0, 0, 0) );
//				m_drone_controller_fx SetModel( "tag_origin" );
//				PlayFXOnTag( level._effect["fx_overlay_decal"], m_drone_controller_fx, "tag_origin" );
//				//PlayFXOnTag( level._effect["fx_overlay_light"], m_drone_controller_fx, "tag_origin" );
//			}
//			
//			v_eye_pos = level.player geteye();
//			
//			v_player_eye = level.player getPlayerAngles();
//			v_player_eye = VectorNormalize( AnglesToForward( v_player_eye ) );
//			
//			v_trace_to_point = v_eye_pos + ( v_player_eye * 5000 );
//			a_trace = BulletTrace( v_eye_pos, v_trace_to_point, false, level.player );
//			
//			m_drone_controller_fx.origin = a_trace["position"];
//			
//			m_drone_controller_fx MagicGrenadeType( "frag_grenade_sp", m_drone_controller_fx.origin, (0, 5, 0), 0.5 );
//			m_drone_controller_fx MagicGrenadeType( "frag_grenade_sp", m_drone_controller_fx.origin, (0, 0, 5), 0.75 );
//				m_drone_controller_fx MagicGrenadeType( "frag_grenade_sp", m_drone_controller_fx.origin, (5, 0, 0), 0.75 );
//			////////////////////////////////////////////////////
//			//set_objective( level.OBJ_DRONE_CONTROL_FOLLOW_SALAZAR, m_drone_controller_fx.origin, "breadcrumb" );
//			
//			//m_drone_controller_light_fx.origin = v_eye_pos; // test for light
//			
//			wait 0.25;
//		}
//		
//		m_drone_controller_fx Delete();
//	}
//}

/* ------------------------------------------------------------------------------------------
	CHALLENGE functions
-------------------------------------------------------------------------------------------*/
//Kill at least 10 guys with drones
drone_control_challenge_killwithdrones_logic()
{	
//	killcount ++;
//	
//	if( killcount == 10 )
//	{
//	}
	
	flag_set( "challenge_killwithdrones" );
}