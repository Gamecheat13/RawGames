// Test clientside script for yemen

#include clientscripts\_utility;
#include clientscripts\_glasses;
#include clientscripts\_filter;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

main()
{

    // This MUST be first for CreateFX!	
    clientscripts\yemen_fx::main();

    // _load!
	clientscripts\_load::main();

	//thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\yemen_amb::main();
	thread clientscripts\_fire_direction::init();  // fire direction weapon shader

	// This needs to be called after all systems have been registered.
	waitforclient(0);
	
	println("*** Client : yemen running...");
	
	//thread yemen_sonar_control();
	thread speech_crowd_think();
}

yemen_sonar_control()
{
	level.localPlayers[0] setSonarEnabled(1); 	//have to turn it off at sometime
	
	level.localPlayers[0].sam_hud_damage_intensity = 0;
	init_filter_f35_damage( level.localPlayers[0] );
	enable_filter_f35_damage( level.localPlayers[0], 0 );		
	
	level waittill( "yemen_disable_sonar" );
	println("*** Client : Sonar off...");
	
	level.localPlayers[0] setSonarEnabled(0); 		
	disable_filter_f35_damage( level.localPlayers[0], 0 );
}



/* ------------------------------------------------------------------------------------------
	Crowd Functions
-------------------------------------------------------------------------------------------*/

speech_crowd_think()
{
	level.crowd_models = array(
								"c_yem_houthis_drone_1_a_fb",
								"c_yem_houthis_drone_1_b_fb",
								"c_yem_houthis_drone_1_c_fb",
								"c_yem_houthis_drone_1_d_fb",
								"c_yem_houthis_drone_1_e_fb",
								"c_yem_houthis_drone_1_f_fb",

								"c_yem_houthis_drone_2_a_fb",
								"c_yem_houthis_drone_2_b_fb",
								"c_yem_houthis_drone_2_c_fb",
								"c_yem_houthis_drone_2_d_fb",
								"c_yem_houthis_drone_2_e_fb",
								"c_yem_houthis_drone_2_f_fb",
								
								"c_yem_houthis_drone_3_a_fb",
								"c_yem_houthis_drone_3_b_fb",
								"c_yem_houthis_drone_3_c_fb",
								"c_yem_houthis_drone_3_d_fb",
								"c_yem_houthis_drone_3_e_fb",
								"c_yem_houthis_drone_3_f_fb"
							);
	
	level.crowd_models_close = array(
										"c_yem_houthis_light_body",
										"c_yem_houthis_light_body_2",
										"c_yem_houthis_light_body_3",
										"c_yem_houthis_light_body_4",
										"c_yem_houthis_medium_body",
										"c_yem_houthis_medium_body_2",
										"c_yem_houthis_medium_body_3",
										"c_yem_houthis_medium_body_4",
										"c_yem_houthis_heavy_body",
										"c_yem_houthis_heavy_body_2",
										"c_yem_houthis_heavy_body_3",
										"c_yem_houthis_heavy_body_4"
									);
	
	level.crowd_models_close_head = array( "c_yem_houthis_head1" );



	level.crowd_anim[ "speech_crowd_cheer" ][0]		= %fakeshooters::ch_yemen_01_04_menendez_intro_crowd_fistpump_guy01;
	level.crowd_anim[ "speech_crowd_cheer" ][1]		= %fakeshooters::ch_yemen_01_04_menendez_intro_crowd_fistpump_guy02;
	level.crowd_anim[ "speech_crowd_idle" ][0]		= %fakeshooters::ch_yemen_01_04_menendez_intro_crowd_idle_guy01;
	level.crowd_anim[ "speech_crowd_idle" ][1]		= %fakeshooters::ch_yemen_01_04_menendez_intro_crowd_idle_guy02;
	level.crowd_anim[ "speech_crowd_runaway" ][0]	= %fakeshooters::ch_yemen_01_04_menendez_intro_crowd_runaway_guy01;
	level.crowd_anim[ "speech_crowd_runaway" ][1]	= %fakeshooters::ch_yemen_01_04_menendez_intro_crowd_runaway_guy02;	
	               
	level waittill( "speech_spawn_crowd" );
	level thread speech_crowd_spawn();
}

speech_crowd_spawn()
{
	level endon( "save_restore" ); 		
	
	foreach ( struct in GetStructArray( "speech_crowd_center", "targetname" ) )
	{
		m_drone = Spawn( 0, struct.origin, "script_model" );
		m_drone.angles = struct.angles;
		
		m_drone SetModel( random( level.crowd_models ) );
		
		m_drone thread speech_crowd_animate_guy();
	}
	
	foreach ( struct in GetStructArray( "speech_crowd_close", "targetname" ) )
	{
		m_drone = Spawn( 0, struct.origin, "script_model" );
		m_drone.angles = struct.angles;
		
		m_drone SetModel( random( level.crowd_models_close ) );
		m_drone Attach( random( level.crowd_models_close_head ), "" );
		
		m_drone thread speech_crowd_animate_guy();
	}
	
	//level waittill ( "menendez_speech_start" );
	wait 13;	//TODO: replace w/ notetrack
	level notify( "crowd_cheer_start" );
}

#using_animtree( "fakeShooters" );
speech_crowd_animate_guy()
{
	self endon( "entityshutdown" );
	level endon( "save_restore" ); 		
	
	wait RandomFloat( 2 );
	self UseAnimtree( #animtree );
	
	self thread animate_drone( "idle" );
	
	level waittill( "crowd_cheer_start" );
	
	s_crowd_center = GetStruct( "speech_crowd_cheer_center", "targetname" );	
	n_dist = Distance2D( s_crowd_center.origin, self.origin );
	n_time = n_dist * 0.003;
	
	wait n_time;
	
	// TODO: need to figure out how to wait until the loop finishes before doing cheer without messing up the timing
	// Not waiting for the idle loop will mean there will always be popping
	self thread animate_drone( "cheer", false );
	
	level waittill( "delete_crowd" );
	
	self Delete();	
}

animate_drone( str_type, b_wait_for_loop )
{
	self endon( "entityshutdown" );
	self endon( "drone_death" );
	level endon( "save_restore" ); 	
	
	self notify( "animate_drone" );
	self endon( "animate_drone" );
	
	n_blend = .2;
	if ( IS_TRUE( b_wait_for_loop ) )
	{
		self waittillmatch( "current_anim", "end" );
		n_blend = 0;
	}
	
	anim_last = undefined;
	
	while( IsDefined( self ) )
	{
		anim_current = random( level.crowd_anim[ "speech_crowd_" + str_type ] );
		
		if ( !IS_EQUAL( anim_current, anim_last ) )
		{
			anim_last = anim_current;
			
			n_length = GetAnimLength( anim_current );
			self ClearAnim( %root, n_blend );
			self SetFlaggedAnim( "current_anim", anim_current, 1, n_blend, 1 );
			n_blend = 0;
		}
		
		self waittillmatch( "current_anim", "end" );
	}
}