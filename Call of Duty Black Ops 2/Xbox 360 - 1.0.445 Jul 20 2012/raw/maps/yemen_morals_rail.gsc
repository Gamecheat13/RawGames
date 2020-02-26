#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\yemen_utility;
#include maps\_glasses;
#include maps\_vehicle;
#include maps\_objectives;
#include maps\_drones;
#include maps\_dialog;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

#define MORALS_RAIL_RPG "rpg_magic_bullet_sp"
#define FADE_IN_TIME 2


/* ------------------------------------------------------------------------------------------
	INIT functions
	*****************************************************************************************
-------------------------------------------------------------------------------------------*/

//	event-specific flags
init_flags()
{
	// rail events
	flag_init( "morals_rail_start" );
	flag_init( "morals_rail_fade_in_start" );
	flag_init( "morals_rail_suspician_started" );
	flag_init( "morals_rail_pip_scene_started" );
	flag_init( "morals_rail_done" );
	flag_init( "morals_rail_waypoint" );
	
	// general
	flag_init( "morals_rail_skipto" );
	flag_init( "morals_rail_fadein_starting" );
	flag_init( "morals_rail_fadein_done" );
}

//	event-specific spawn functions
init_spawn_funcs()
{
	add_spawn_function_group( "morals_rail_terrorist", "script_noteworthy", ::morals_rail_terrorist_spawnfunc );
	add_spawn_function_veh( "allied_quadrotor", maps\yemen_drone_control::drone_control_allied_quadrotor_spawnfunc );
}

/* ------------------------------------------------------------------------------------------
	SKIPTO functions
	*****************************************************************************************
-------------------------------------------------------------------------------------------*/

//	skip-to only initialization (not run if this event skip-to isn't used)
skipto_morals_rail()
{
	flag_set( "morals_rail_skipto" );
	
	setup_vtol_crash_site();
	level.is_farid_alive = false; // defualting to Farid dead - do rail
}

//	skip-to case where farid lives
skipto_morals_rail_skip()
{
	flag_set( "morals_rail_skipto" );
	
	setup_vtol_crash_site();
	level.is_farid_alive = true; // defualting to Farid alive - skip rail
	
	skipto_teleport( "skipto_drone_control_player" );
}

//	capture bink of Menendez running
skipto_morals_rail_menendez()
{
	flag_set( "morals_rail_skipto" );
	
	level.is_farid_alive = true; // default to Farid alive - skip rail
	
	skipto_teleport( "skipto_drone_control_player" );
	
	ai_menendez = simple_spawn_single( "menendez_morals" );
	s_spot = GetStruct( "morals_align" );
	nd_goal = GetNode( "nd_dc_men", "targetname" ); 
	
	ai_menendez.team = "allies";
	ai_menendez set_goalradius( 64 );
	
	wait 5;
	
	ai_menendez maps\yemen_utility:: teleport_ai_to_pos( s_spot.origin, s_spot.angles );
	ai_menendez set_ignoreall( true );
	ai_menendez set_ignoreme( true );
	ai_menendez force_goal( nd_goal );

	while( true )
	{
		ai_menendez maps\yemen_utility:: teleport_ai_to_pos( s_spot.origin, s_spot.angles );
		ai_menendez force_goal( nd_goal );
		ai_menendez waittill( "goal" );
	}
}

/* ------------------------------------------------------------------------------------------
	MAIN functions 
	*****************************************************************************************
-------------------------------------------------------------------------------------------*/

//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//		your skipto sequence will be called.
main()
{
/****************************************************************
 * level.is_farid_alive											
 * What this is: tells us if Farid is dead or not 
 * What this does: determines if we do rail sequence or not	
 * 				   a. if he is dead we do this event	
 * 				   b. if he is alive we skip this event								
 * *************************************************************/
	if( !level.is_farid_alive ) // do this event
	{
		/#
			IPrintLn( "Morals Rail" );
		#/
		
		level.n_rail_terrorist_kills = 0;
		
		load_gump( "yemen_gump_outskirts" );
		
		waittill_asset_loaded( "xmodel", "veh_t6_air_v78_vtol_side_gun" );
		
		morals_rail_setup();
	
		switch_player_to_mason();
		
		level thread morals_rail_fade_in();
		do_mason_custom_intro_screen();
		level thread vo_septic_rail();
			
		flag_set( "morals_rail_fade_in_start" );
		
		skipto_teleport( "skipto_morals_rail_player" );
		
		wait .05;// HACK: wait a frame to avoid strange behavior when restarting from save
		
		autosave_by_name( "morals_rail_start" );
			
		morals_rail_go();
	}
	
	else // skip this event
	{	
		load_gump( "yemen_gump_outskirts" );
		
		switch_player_to_mason();
		mr_spawn_salazar();
			
		wait .05; // HACK: wait a frame to avoid strange behavior when restarting from save
		
		do_mason_custom_intro_screen();
		level.player give_player_loadout();
	}
}

/* ------------------------------------------------------------------------------------------
	SETUP
	*****************************************************************************************
-------------------------------------------------------------------------------------------*/

morals_rail_setup()
{
	level thread enemy_target_update();
}

// crash harper's vtol
setup_vtol_crash_site()
{
	level notify( "fxanim_vtol2_crash_start" );
	level thread run_scene( "morals_vtol_crashing" );
}

//spawn salazar
mr_spawn_salazar()
{
	init_hero_startstruct( "sp_salazar", "skipto_drone_control_salazar" );
}

/********************************************************************
 * Spawns a vtol at a struct and puts it on a path
 * Mandatory: struct name (where I spawn)
 * Optional:  node name (start of path) OR stuct's target in radiant
 ********************************************************************/
spawn_vtols_at_structs( str_struct_name, str_nd_name )
{
	a_spots = GetStructArray( str_struct_name, "targetname" );
	
	foreach ( s_spot in a_spots )
	{
		v_vtol = spawn_vehicle_from_targetname( "yemen_drone_control_vtol_spawner" );
		
		if( IsDefined( str_nd_name ) || IsDefined( s_spot.target ) )
		{
			// if struct has a target then use it's target as start node
			// targeted node overrides str_nd_name
			if( IsDefined( s_spot.target ) )
			{
				str_nd_name = s_spot.target;
			}
			
			v_vtol veh_magic_bullet_shield( true );
			v_vtol thread go_path( GetVehicleNode( str_nd_name, "targetname" ) );
			return v_vtol;
		}
		
		else
		{
			v_vtol.origin = s_spot.orign;
			v_vtol.angles = s_spot.angles;
			
			return v_vtol;
		}
	}
}

/* -------------------------------------------------
 * Give player loadout based on Create a Class
 * Self = player
 **************************************************/
give_player_loadout()
{
	// Get Create a Class weapons
	w_primary = GetLoadoutItem( "primary" );
	w_secondary = GetLoadoutItem( "secondary" );
	w_specialgrenade = GetLoadoutItem( "specialgrenade" );
	
	self GiveWeapon( w_primary );
	self GiveWeapon( w_secondary );
	self GiveWeapon( "frag_grenade_sp" ); // Yemen doesn't use wrist launcher
	self GiveWeapon( w_specialgrenade );
	// TODO: find out if we want Mason to have sword is Farid had it
	self GiveWeapon( "knife_sp" );
	
	self SwitchToWeapon( w_primary );
}

// Self = terrorist
morals_rail_terrorist_spawnfunc()
{
	self.script_grenades = 0; // I don't throw grenades all over the place
	self.script_radius = 64; // I go where I am supposed to
//	self change_movemode( "sprint" ); // I get into position quickly and slide into cover
	self.deathFunction = ::morals_rail_count_terrorist_deaths; // when I die by the player's shots the script knows
	self shoot_at_target_untill_dead( GetEnt( "m_enemy_target", "targetname" ) ); // I target a scipt model that is offset from player so my shots looks cool
}

// Count player kills for challenge
// Self = terrorist
morals_rail_count_terrorist_deaths()
{
	if( self.attacker == level.player )
	{
		level.n_rail_terrorist_kills++;
	}
	
	return false;
}

/* ------------------------------------------------------------------------------------------
	Fade In
-------------------------------------------------------------------------------------------*/

morals_rail_fade_in()
{
	introblack = NewHudElem(); 
	introblack.x = 0; 
	introblack.y = 0; 
	introblack.horzAlign = "fullscreen"; 
	introblack.vertAlign = "fullscreen"; 
	introblack.foreground = false;
	introblack SetShader( "black", 640, 480 );

	introblack thread morals_rail_hud_fadein();
}
	
morals_rail_hud_fadein()
{
	flag_wait( "morals_rail_fadein_starting" );
	// Fade out black
	screen_fade_in(0);	// BJOYAL - turn off the morals fade hud as well, if it is up
	self FadeOverTime( FADE_IN_TIME ); 
	self.alpha = 0; 
	
	flag_set( "morals_rail_fadein_done" );
	
	self Destroy();
}

// Custom intro screen for Mason
do_mason_custom_intro_screen()
{
	level thread yemen_custom_introscreen2( &"YEMEN_INTROSCREEN_PLACE", &"YEMEN_INTROSCREEN2_TARGET", &"YEMEN_INTROSCREEN_TEAM", &"YEMEN_OBJ_CAPTURE_MENENDEZ");
}

/*******************************************************************************
 * Wrecks Harper's VTOL - so its there during skipto
 * TODO: troubleshoot why it isn't in the right spot	   															   			   *
 ******************************************************************************/
vtol_wreck()
{
	level notify( "fxanim_vtol2_crash_start" );
	level thread run_scene( "morals_vtol_crashing" );
	wait .2;
	vh_vtol = get_model_or_models_from_scene( "morals_vtol_crashing", "morals_vtol" );
	// PlayFXOnTag( GetFX( "crashing_vtol" ), vh_vtol, "tag_origin" );
	PlayFXOnTag( level._effect[ "explosion_midair_heli" ], vh_vtol, "tag_origin" );
}

/* ------------------------------------------------------------------------------------------
	EVENT functions
	*****************************************************************************************
-------------------------------------------------------------------------------------------*/

// whole rail event
morals_rail_go()
{
	level.player magic_bullet_shield();
	player_vtol_go_on_rail();
	level.player stop_magic_bullet_shield();
}

// ride vtol event
player_vtol_go_on_rail()
{
	flag_set( "morals_rail_start" );
	
	

	veh_vtol = maps\_vehicle::spawn_vehicle_from_targetname( "yemen_morals_rail_vtol_spawner" );
	veh_vtol.script_radius = 16;
	veh_vtol.drivepath = true;
	nd_vtol_start = GetVehicleNode( "morals_rail_player_vtol_path1_start_node", "targetname" );
	nd_exit_path = GetVehicleNode( "morals_rail_player_vtol_exit_path_start", "targetname" );
	level thread do_vtol_sounds(veh_vtol);
	
	// give vtol something to look at so it turns sideways
	s_look_spot = GetStruct( "player_vtol_look_spot", "targetname" );
	m_vtol_look_at = Spawn( "script_origin", s_look_spot.origin );

	veh_vtol veh_magic_bullet_shield( true );
	veh_vtol SetVehGoalPos( nd_vtol_start.origin, true );
	
	// Sky - put player in position and facing the right way before using gunner turret
	// This is an attempt to fix problem where player is in VTOL geo or facing wrong way on turret
	v_gunner_origin = veh_vtol GetTagOrigin( "tag_gunner_mount1" ); // This is the gunner mount spot and is facing the way the gun is facing
	v_gunner_angles = veh_vtol GetTagAngles( "tag_gunner_mount1" );
	level.player.origin = v_gunner_origin;
	level.player SetPlayerAngles( v_gunner_angles );
	
	// redundancy
	level.player PlayerLinkToDelta( veh_vtol, "tag_gunner_mount1", 1, 0, 0, 0, 0, true );
	wait .05;
	level.player Unlink();

	level.player FreezeControls( true );
	
	veh_vtol UseVehicle( level.player, 1 );
	veh_vtol SetHoverParams( 128 );
	
	flag_wait( "morals_rail_fadein_starting" ); // wait until fadeup starts to move vtol
	
	level.player FreezeControls( false );

	veh_vtol thread go_path( nd_vtol_start );
	
	wait FADE_IN_TIME; // make sure fade up happens after spline starts
	
	flag_set( "morals_rail_fadein_done" );
	
	veh_vtol SetLookAtEnt( m_vtol_look_at );
	
	maps\yemen_hijacked::spawn_quadrotor_formation( 8, "morals_rail_quadrotor_spline", "allied_quadrotor", "allies" );
	
	do_rail_events( veh_vtol );
	
	level thread maps\yemen_anim::morals_rail_anims();
	
	veh_vtol MakeVehicleUnusable();
	level.player Unlink();
	
	flag_set( "morals_rail_done" );
	
	// HACK: delete lamp that clips with Harper
	m_lamp = GetEnt( "fxanim_vtol2_crash_lamp", "targetname" );
	if( IsDefined( m_lamp ) )
	{
		m_lamp Delete();
	}
	
	level.player StartCameraTween( 0.3 );
	run_scene( "mason_intro_harper_lives" );
	
	ai_sal = GetEnt( "sp_salazar_ai", "targetname" );
	ai_sal thread make_hero();
	
	veh_vtol thread player_vtol_exit_scene( nd_exit_path );
	
	trigger_use( "trig_drone_control_color_alley_start", "targetname" );
	
	level.player give_player_loadout();
	m_vtol_look_at Delete();
}

// manage flow of events while player is on rail
do_rail_events( veh_vtol )
{
	level thread do_rail_drones();
	level thread do_rail_ai();
	
	level waittill( "rail_ready_exit" );
	
	fire_rpgs_from_structs( "s_morals_rail_arched_balcony_rpg_struct" );
	
	flag_set( "morals_rail_pip_scene_started" );
}

// manage drones on rail
do_rail_drones()
{
	sp_drone = GetEnt( "morals_rail_first_ground_drone", "targetname" );
	
	drones_start( "s_mr_sp_second_ground_drones" );
	drones_start( "s_mr_sp_first_ground_drones" );
	drones_start( "s_mr_sp_vtol_ground_drones" );
	
	level waittill( "rail_ready_exit" );
	
	drones_delete( "s_mr_sp_second_ground_drones" );
	drones_delete( "s_mr_sp_first_ground_drones" );
	drones_delete( "s_mr_sp_vtol_ground_drones" );
	drones_delete( "s_mr_sp_fourth_ground_drones" );
	sp_drone Delete();
}

// manage spawn and cleanup of ai
do_rail_ai()
{
	level waittill( "rail_ready_exit" );
	
	level thread maps\_audio::switch_music_wait("YEMEN_MASON_ARRIVES", 4);
	
	// kill infinite spawners
	spawn_manager_kill( "morals_rail_lower_wave_1" );
	spawn_manager_kill( "morals_rail_lower_wave_2" );
	
	wait .1;
	
	a_ai_terrorists = GetEntArray( "morals_rail_terrorist", "script_noteworthy" );
	maps\yemen_hijacked::kill_units( a_ai_terrorists );
}

/*****************************************************************
 * Spawns escort VTOL, puts on path, matches another vtol's speed
 * Mandatory: struct name, vehicle to speed match with
 ****************************************************************/
escort_vtol_go_on_rail( str_struct, veh_speed_match )
{
	level endon( "morals_rail_done" );
	veh_speed_match endon( "delete" );
	
	veh_vtol = spawn_vtols_at_structs( str_struct );
	
	veh_vtol endon( "delete" );
	
	// speed match
	while( true )
	{
		n_speed = veh_speed_match GetSpeed();
		veh_vtol SetSpeed( n_speed / 17.6 );
		
		wait 1;
	}
}

// player's vtol gets on a new path and goes after he exits
player_vtol_exit_scene( nd_goal )
{
	self ClearLookAtEnt();
	self.drivepath = 1;
	self go_path( nd_goal );
	VEHICLE_DELETE( self );
	delete_models_from_scene( "mason_intro_harper_lives" );
}

/* ------------------------------------------------------------------------------------------
	AMBIENT functions
	*****************************************************************************************
-------------------------------------------------------------------------------------------*/

// returns vector target based on where ent is facing
mr_get_magic_target_position( e_shooter, n_dist )//mandatory, optional
{
	if( !IsDefined( n_dist ) )
	{
		n_dist = 5000;
	}
	
	v_aim_spot = e_shooter.origin + ( VectorNormalize( AnglesToForward( e_shooter.angles ) ) * n_dist );
	
	a_trace = BulletTrace( e_shooter.origin, v_aim_spot, true, e_shooter );

	return a_trace[ "position" ];
}

/*------------------------------------------------------------------------------
 * Shoot rpg from struct											
 * Mandatory: struct name
 * Optional: target position (if none fire down struct's x)					   
 * 			  min wait, max wait (if only min or only max then wait that time) 
 * 								 (if none then wait a frame)				   
 *******************************************************************************/
fire_rpgs_from_structs( str_struct, v_target, n_min, n_max )
{
	n_wait = undefined;
	a_rpgs = GetStructArray( str_struct, "targetname" );
	
	foreach( s_rpg in a_rpgs )
	{
		if( !IsDefined( s_rpg.script_noteworthy ) )//defaults to fire forward
		{
			v_target = _get_target_position();
		}
		
		else
		{
			if( s_rpg.script_noteworthy == "player" ) // if target player do miss
			{		
				v_target = _get_target_position();
			}
			
			else
			{
				e_target_ent = GetStruct( s_rpg.script_notewothy, "targetname" );
				v_target = e_target_ent.origin;
			}
		}
		
		MagicBullet( MORALS_RAIL_RPG, s_rpg.origin, v_target );
		
		wait _get_custom_wait( n_min, n_max );
	}
}

/*-----------------------------------------------------------------------------
 * Returns a wait time											 			  
 * Optional: min, max - if neither then wait a frame, if one then return that
 *****************************************************************************/
_get_custom_wait( n_min, n_max )
{
	if( IsDefined( n_min ) && IsDefined( n_max ) )
	{
		n_wait =  RandomFloatRange( n_min, n_max );
	}
	else
	{
		if( IsDefined( n_min ) )
		{
			n_wait = n_min;
		}
		if( IsDefined( n_max ) )
		{
			n_wait = n_max;
		}
		if( !IsDefined( n_max ) && !IsDefined( n_min ) )
		{
			n_wait = .05; // default to one frame
		}
	}
	
	return n_wait;
}

/* ------------------------------------------------------------------------------------------
	UTILITY functions
	*****************************************************************************************
-------------------------------------------------------------------------------------------*/

// Updates postion that enemies target
enemy_target_update()
{
	level endon( "morals_rail_done" );
	
	m_aim = _get_aim_model();
	
	while( 1 )
	{
		m_aim.origin = _get_target_position();
		
		wait .2;
	}
}

_get_aim_model()
{
	m_aim = Spawn( "script_model", (0, 0, 0) );
	m_aim SetModel( "tag_origin" );
	m_aim.targetname = "m_enemy_target";
	
	return m_aim;
}

//returns vector offset from player
_get_target_position()
{	
	v_eye_pos = level.player geteye();	
	v_player_eye = level.player getPlayerAngles();
	v_player_eye = VectorNormalize( AnglesToForward( v_player_eye ) );
			
	v_trace_to_point = v_eye_pos + ( v_player_eye * 512 );
	a_trace = BulletTrace( v_eye_pos, v_trace_to_point, false, level.player );
			
	return a_trace["position"];
}

// TODO: find out if this can be folded into one intro screen for the map
yemen_custom_introscreen2( string1, string2, string3, string4, string5 )
{
	level.introstring = []; 

	const pausetime = 0.75;
	const totaltime = 14.25;
	time_to_redact = ( 0.525 * totaltime);
	rubout_time = 1;
	color = (1,1,1);

	const delay_between_redacts_min = 350; // this is a slight pause added when redacting each line, so it isn't robotically smooth
	const delay_between_redacts_max = 500;

	start_rubout_time = Int( time_to_redact*1000 );// convert to miliseconds and fraction of total time to start rubbing out the text
	totalpausetime = 0; // track how much time we've waited so we can wait total desired waittime
	rubout_time = Int(rubout_time*1000); // convert to miliseconds 

	// following 2 lines are used in and logically could exist in isdefined(string1), but need to be initialized so exist here
	redacted_line_time = Int( 1000* (totaltime - totalpausetime) ); // each consecutive line waits the total time minus the total pause time so far, so they all go away at once.

	if( IsDefined( string1 ) )
	{
		level thread maps\_introscreen::introscreen_create_redacted_line( string1, redacted_line_time, start_rubout_time, rubout_time, color ); 

		wait( pausetime );
		totalpausetime += pausetime;	
	}

	if( IsDefined( string2 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) ) + RandomIntRange(delay_between_redacts_min, delay_between_redacts_max);
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
		
		level thread maps\_introscreen::introscreen_create_redacted_line( string2, redacted_line_time, start_rubout_time, rubout_time, color);

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}

	if( IsDefined( string3 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) ) + RandomIntRange(delay_between_redacts_min, delay_between_redacts_max);	
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
	
		level thread maps\_introscreen::introscreen_create_redacted_line( string3, redacted_line_time,  start_rubout_time, rubout_time, color);

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}

	if( IsDefined( string4 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) )	+ RandomIntRange(delay_between_redacts_min, delay_between_redacts_max);		
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
	
		level thread maps\_introscreen::introscreen_create_redacted_line( string4, redacted_line_time, start_rubout_time, rubout_time, color);

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}		

	if( IsDefined( string5 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) ) + RandomIntRange(delay_between_redacts_min, delay_between_redacts_max);			
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
		
		level thread maps\_introscreen::introscreen_create_redacted_line( string5, redacted_line_time, start_rubout_time, rubout_time, color);

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}

	wait (totaltime - totalpausetime);

	//default wait time
	wait 2.5;
	
	// Fade out text
	maps\_introscreen::introscreen_fadeOutText(); 
}

/* ------------------------------------------------------------------------------------------
	VO functions
	*****************************************************************************************
-------------------------------------------------------------------------------------------*/

vo_septic_rail()
{
	//before title screen end
	level.player say_dialog( "sept_harper_harper_do_0" );			//Harper.  Harper!  Do you copy?
	wait( 2.0 );
	level.player say_dialog( "sept_dammit_something_s_0" );			//Dammit, something’s wrong.
	//-- DIALOG HERE TO MAKE SENSE OF THE TRANSITION
	wait(0.5);
	level.player say_dialog( "sept_watchtower_lineback_0" );
			
	//during fade up
	flag_set( "morals_rail_fadein_starting" );
	
	level.player say_dialog( "sept_taking_heavy_fire_fr_0" );
	wait(0.2);
	level.player say_dialog( "sept_watchtower_any_asse_0" );
	wait(1.0);
	level.player say_dialog( "watc_ah_negative_lineba_0" );
	
	flag_wait( "morals_rail_suspician_started" );
	
	//end of rail
	level.player say_dialog( "sept_salazar_bring_up_b_0" );			//Salazar - Bring up Blue Force Tracking.
	level.player say_dialog( "sept_i_need_eyes_on_harpe_0" );		//I need eyes on Harper’s location.
	
	flag_wait( "morals_rail_pip_scene_started" );	
	
	//pip start
	level.player say_dialog( "sept_no_no_no_0" );					//No. No. No.
	
	level thread play_bink_on_hud("yemen_men_ally");
	
	level.player say_dialog( "sept_no_0" );							//No.
}

/* ------------------------------------------------------------------------------------------
	CHALLENGES
	*****************************************************************************************
-------------------------------------------------------------------------------------------*/

// TODO: rename this challenge
// kill 10 terrorists during the rail
killwithdrones_challenge( str_notify )
{
	level waittill( "morals_rail_done" );
	
	if( IsDefined( level.n_rail_terrorist_kills ) && level.n_rail_terrorist_kills >= 10 )
	{
		self notify( str_notify );		
	}		
}

/* ------------------------------------------------------------------------------------------
	AUDIO
	*****************************************************************************************
-------------------------------------------------------------------------------------------*/
	
do_vtol_sounds(plr_vtol)
{
	level clientnotify("inside_osprey");
	
	level waittill( "morals_rail_done" );
	level clientnotify ("osprey_done");
	vtol_snd = spawn ("script_origin", plr_vtol.origin);
	vtol_snd linkto (plr_vtol);
	wait (3.5);
	vtol_snd playloopsound ("veh_osp_steady", 1);
	wait (30);
	vtol_snd stoploopsound(2);
	vtol_snd delete();
	                 
}