#include common_scripts\utility;
#include maps\_utility;
#include maps\karma_util;
#include maps\_objectives;
#include maps\_scene;
#include maps\_vehicle;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


/* ------------------------------------------------------------------------------------------
    INIT functions
-------------------------------------------------------------------------------------------*/
//
//	Declare event-specific flags here
init_flags()
{
	flag_init( "fxanim_checkin_start" );
	flag_init( "start_tarmac" );
	flag_init( "start_vtol_takeoff" );	// set via trigger
	flag_init( "start_vtol_flyby" );	// set via trigger
	flag_init( "deplaned" );
}


//
//	Need an AI to run something when spawned?  Put it here.
init_spawn_funcs()
{
	add_spawn_function_veh( "player_vtol", ::player_vtol_start );
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/
skipto_arrival()
{
//	skipto_teleport( "skipto_arrival" );
}

/* ------------------------------------------------------------------------------------------
	MAIN functions
-------------------------------------------------------------------------------------------*/
//
//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//	your skipto sequence will be called.
arrival()
{
	// Temp Development info
	/#
		IPrintLn( "Arrival" );
	#/

		// Turn off HUD
	level.player hide_hud();

	maps\karma_anim::arrival_anims();
	
	//TUEY Set music to KARMA_1_INTRO
	setmusicstate("KARMA_1_INTRO");
	//Eckert - setting reverb for cockpit
	level clientnotify ( "ospree_rm" );

	// Initialization
	level.ai_harper 		= init_hero( "harper" );
	
	if ( level.player get_story_stat( "HARPER_SCARRED" ) )
	{
		level.ai_harper SetModel( "c_usa_cia_combat_harper_burned_cin_fb" );
	}
	
	level.ai_harper set_blend_in_out_times( 0.2 );
	
	level.ai_salazar		= init_hero( "salazar_pistol" );
	level.ai_salazar set_blend_in_out_times( 0.2 );
	
	level thread setup_vtol( "player_vtol" );

	level.m_duffle_bag = GetEnt( "duffle_bag", "targetname" );
	level.m_duffle_bag set_blend_in_out_times( 0.2 );
	
	level.m_harper_briefcase = GetEnt( "harper_briefcase", "targetname" );
	level.m_harper_briefcase set_blend_in_out_times( 0.2 );
	
	level.m_player_briefcase = spawn_model( "p6_spiderbot_case_anim" );
	level.m_player_briefcase.animname = "player_briefcase";
	
	a_m_metal_storm = GetEntArray( "metal_storm", "targetname" );
	foreach( m_metal_storm in a_m_metal_storm )
	{
		m_metal_storm Attach("veh_t6_drone_asd_attch", 		"body_animate_jnt");
		m_metal_storm Attach("veh_t6_drone_asd_attch_torso",	"tag_turret");
	}
	
	vtol_clip = GetEnt( "clip_vtol_blocker", "targetname" );
	vtol_clip trigger_off();
	
	a_ai_security_single =  simple_spawn_single( "security1" );
	a_ai_security_single add_cleanup_ent( "cleanup_checkin" );

	level thread set_water_dvars();
	set_env_dvars();
	level thread setup_tarmac_fx();
	level thread setup_cagelight_fx( "cagelight" );
	level thread setup_cagelight_fx( "L_pad_cagelight" );

	flag_set( "fxanim_checkin_start" );

	
	exploder( 101 );	// seagulls
	exploder( 103 );	// background fx
	exploder( 105 );	// intro fx

	flag_wait( "starting final intro screen fadeout" );

	exploder( 102 );	// sun flare

	playsoundatposition ("evt_jet_intro", (0, 0, 0));

	
	// aaaaaand action!
	level thread setup_vtol( "takeoff_vtol", "start_vtol_takeoff" );
	level thread setup_vtol( "intro_vtol" );

	level thread landing_pilot_scenes();
	level thread tarmac_worker_scenes();
	level thread forklift_worker_scenes();
	level thread metalstorm_worker_scenes();
	level thread timescale_glasses();
	level thread adjust_player_speed();
	level thread start_workers();
	level thread start_workers_walking();
	level thread maps\karma_checkin::security_left();
	level thread maps\karma_checkin::scanner_scenes();
	level thread maps\karma_checkin::scanner_backdrop();
	
	scene_wait( "final_approach_plane" );
	flag_set( "start_tarmac" );
	
	//Eckert - Change reverb
	level clientnotify ( "verb_reset");	
	
	if ( level.player get_story_stat( "HARPER_SCARRED" ) )
	{
		run_scene_and_delete( "landing_squad" );
	}
	else
	{
		run_scene_and_delete( "landing_squad_alt" );
	}
	
	// Additional event logic
	flag_set( "deplaned" );
	level thread arrival_cleanup();
}


//
//	Spawn vtol and make it fly around when triggered
//		str_vtol_name - targetname of the spawner
//		str_wait_flag - if specified, flag_wait before moving on spline
//
setup_vtol( str_vtol_name, str_wait_flag )
{
	a_vh_vtols = spawn_vehicles_from_targetname( str_vtol_name );
	foreach( vh_vtol in a_vh_vtols )
	{
		if ( vh_vtol.vehicletype == "heli_vtol" )
		{
			PlayFxOnTag( level._effect["flight_lights_3p"], vh_vtol, "tag_origin" );
		}
		
		// Argus ID
//		vh_vtol thread add_argus_on_flag( "glasses_activated" );
		vh_vtol add_cleanup_ent( "cleanup_tower" );
		
		//PlayFxOnTag( level._effect["flight_lights_3p"], vh_vtol, "tag_origin" );

		// Gear up or down?
		if ( IsDefined( vh_vtol.script_string ) && 
		    IsDefined( level.scr_anim[ "vtol" ][ vh_vtol.script_string ] ) )
		{
			//PlayFxOnTag( level._effect["flight_lights_3p"], vh_vtol, "tag_origin" );
			vh_vtol.animname = "vtol";
			vh_vtol thread maps\_anim::anim_single( vh_vtol, "gear_down" );
			
			//TODO: Temp fixed the SRE error that causing by _vehicle_death.gsc. PC (4/14/12)
			vh_vtol notify ("nodeath_thread");
			
			vh_vtol thread vtol_fly( str_vtol_name, str_wait_flag );
			
			flag_wait( "glasses_activated" );
			wait 8;
			vh_vtol thread maps\_anim::anim_single( vh_vtol, "gear_up" );		
		}
		else
		{	
			//TODO: Temp fixed the SRE error that causing by _vehicle_death.gsc. PC (4/14/12)
			vh_vtol notify ("nodeath_thread");
			
			vh_vtol thread vtol_fly( str_vtol_name, str_wait_flag );
		
		}
	}
}


//
//	Startup FX for the tarmac
setup_tarmac_fx()
{
	// These FX require precise placement so we're using the exact in-game values.
	a_m_hazard_lights = GetEntArray( "hazard_light", "targetname" );
	foreach( m_light in a_m_hazard_lights )
	{
		m_light thread delay_fx();
		m_light add_cleanup_ent( "cleanup_checkin" );
	}	
}


//
// self is the entity to play the fx on
delay_fx()
{
	if ( IsDefined( self.script_delay ) )
	{
		wait( self.script_delay );
	}
	
	PlayFXOnTag( level._effect["light_caution_orange_flash"], self, "tag_origin"  );
}

setup_cagelight_fx(light)
{
	// These FX require precise placement so we're using the exact in-game values.
	a_m_cagelights = GetEntArray( light, "targetname" );
	foreach( m_light in a_m_cagelights )
	{
		m_light thread delay_cagelight_fx();
		m_light add_cleanup_ent( "cleanup_checkin" );
	}	
}

// self is the entity to play the fx on
delay_cagelight_fx()
{
	if ( IsDefined( self.script_delay ) )
	{
		wait( self.script_delay );
	}
	
	PlayFXOnTag( level._effect["light_caution_red_flash"], self, "tag_origin"  );
}

//
//	Wait for the appropriate flag and then add the argus element
//	self is a vtol... for now
//add_argus_on_flag( str_flag )
//{
//	self endon( "death" );
//	
//	flag_wait( str_flag );
//	
//	switch( self.vehicletype )
//	{
//		case "heli_vtol":
//			level.player maps\_ar::add_ar_target( self, &"KARMA_ARGUS_HELI_VTOL", 3000, 2500, (0, 0, 103) );
//			break;
//		case "heli_blackhawk_stealth":
//			level.player maps\_ar::add_ar_target( self, &"KARMA_ARGUS_HELI_HIP", 15000, 5500, (0, 0, -65) );
//			break;
//	}
//}


//
//	waittill flag and then fly on path
//		str_vtol_name - targetname of the spawner
//		str_wait_flag - if specified, flag_wait before moving on spline
//	self is a vtol
vtol_fly( str_vtol_name, str_wait_flag )
{
	if ( !IsDefined( self.target ) )
	{
		return;
	}
	
	nd_flyby_start = GetVehicleNode( self.target, "targetname" );
	assert( IsDefined( nd_flyby_start ), "setup_vtol: No path defined for vtol : " + self.target );

	if ( IsDefined( str_wait_flag ) )
	{	
		flag_wait( str_wait_flag );
	}

	// sounds/FX
	switch( self.vehicletype )
	{
		case "heli_vtol":
			PlayFXOnTag(level._effect["vtol_exhaust"], self, "tag_origin");
			self playsound ("evt_vtol_takeoff");
			break;
		case "heli_hip":
			break;
	}
	
	self go_path(nd_flyby_start);
	self waittill("reached_end_node");
	
	self delete();
}
	

//
//	start the FX and player scenes once the player's vtol is spawned
//	self is the player's vtol
player_vtol_start()
{
	// Check so that a skipto for checkin works.
	if ( flag( "deplaned" ) )
	{
		return;
	}
	
	//vh_player_vtol = GetEnt( "player_vtol", "targetname" );
	level thread landing_player_scenes( self );

	//thread run_scene_and_delete( "final_approach_stairs_idle" );
	run_scene_first_frame("final_approach_plane");

	flag_wait( "starting final intro screen fadeout" );
	
	self HidePart("tag_window_solid");
	self thread hide_show_vtol_parts();
	
	// Spawn speed cloud FX
	self play_fx( "parting_clouds",			(0,0,0), (0,0,0), "vtol_landed", true, "tag_origin" );
	self play_fx( "flight_spotlight",		(0,0,0), (0,0,0), "vtol_landed", true, "tag_flashlight" );
	self play_fx( "flight_hologram",		(0,0,0), (0,0,0), "vtol_landed", true, "tag_hologram_fx" );
	self play_fx( "flight_lights_glows1", 			(0,0,0), (0,0,0), "vtol_landed", true, "tag_cockpit_fx" );
	self play_fx( "flight_lights_centers1", 			(0,0,0), (0,0,0), "vtol_landed", true, "tag_cockpit_fx" );
	self play_fx( "flight_lights_glows2", 			(0,0,0), (0,0,0), "vtol_landed", true, "tag_cockpit_fx" );
	self play_fx( "flight_lights_centers2", 			(0,0,0), (0,0,0), "vtol_landed", true, "tag_cockpit_fx" );
	self play_fx( "flight_overhead_panel_centers",	(0,0,0), (0,0,0), "vtol_landed", true, "tag_overhead_panel_fx" );
	self play_fx( "flight_overhead_panel_glows",	(0,0,0), (0,0,0), "vtol_landed", true, "tag_overhead_panel_fx" );
	self play_fx( "flight_overhead_panel_centers2",	(0,0,0), (0,0,0), "vtol_landed", true, "tag_overhead_panel_fx" );
	self play_fx( "flight_overhead_panel_glows2",	(0,0,0), (0,0,0), "vtol_landed", true, "tag_overhead_panel_fx" );
	self play_fx( "flight_access_panel_01",	(0,0,0), (0,0,0), "vtol_landed", true, "tag_access_panel_01_fx" );
	self play_fx( "flight_access_panel_02",	(0,0,0), (0,0,0), "vtol_landed", true, "tag_access_panel_02_fx" );

	run_scene_and_delete( "final_approach_plane" );
	self veh_toggle_tread_fx( false );
	
	thread run_scene_and_delete( "final_approach_plane_idle" );
	
	flag_wait("start_workers");
	self HidePart("Tag_cockpit");
	self HidePart("Tag_cabin");
	self HidePart("tag_copilot_yoke");
	self HidePart("tag_pilot_yoke");
	self HidePart("tag_copilot_yoke_base");
	self HidePart("tag_pilot_yoke_base");
	self ShowPart("tag_window_solid");
	
	scene_wait("landing_player");
	self notify ("vtol_landed");

}


//
//	vh_vtol is the vtol we're riding in
//
landing_player_scenes( vh_vtol )
{	
	// Need to lock Harper and Salazar in because they won't move with the plane
	//	even though it is their align "node".
	run_scene_first_frame( "final_approach_squad" );
	level.ai_harper LinkTo( vh_vtol );
	level.ai_salazar LinkTo( vh_vtol );
	level.m_duffle_bag LinkTo( vh_vtol );
	level.m_harper_briefcase LinkTo( vh_vtol );
	level.m_player_briefcase LinkTo( vh_vtol );
	                       
	flag_wait( "starting final intro screen fadeout" );
	
	level thread visionset_flyin();
	
	run_scene_and_delete( "final_approach_squad" );
	level.ai_harper Unlink();
	level.ai_salazar Unlink();
	level.m_duffle_bag Unlink();
	level.m_harper_briefcase Unlink();
	level.m_player_briefcase Unlink();

	glasses = GetEnt( "glasses", "targetname" );
	glasses setviewmodelrenderflag( true );

	thread run_scene_and_delete( "landing_player" );
	
	level thread maps\createart\karma_art::vision_set_change( "sp_karma_intro" );
	
	thread maps\karma_checkin::PA_dialog();
	
	vtol_clip = GetEnt( "clip_vtol_blocker", "targetname" );
	vtol_clip trigger_on();

	scene_wait( "landing_player" );

	t_obj = GetEnt( "clip_scanner_blocker_2", "targetname" );
	set_objective( level.OBJ_SECURITY, t_obj );
}

visionset_flyin()
{
	level thread maps\createart\karma_art::vision_set_change( "sp_karma_flyin_desat" );
	wait 3;
	level thread maps\createart\karma_art::vision_set_change( "sp_karma_flyin" );
}

hide_show_vtol_parts()
{
	self HidePart("Tag_cabin");
	
	flag_wait("hide_cabin");
	self ShowPart("Tag_cabin");
	
	wait 20;
	self play_fx( "flight_tread_player",		(0,0,0), (0,0,0), "vtol_landed", true, "tag_origin" );
	
	flag_wait("hide_cockpit");
	self ShowPart("Tag_cockpit");
		
}

//
//	Scenes for the pilots flying the player's VTOL
//
landing_pilot_scenes()
{	
	run_scene_and_delete( "final_approach_pilots" );
	run_scene_and_delete( "landing_pilots" );
	thread run_scene_and_delete( "landing_pilots_idle" );
	flag_wait( "trig_enter_scanner" );

	end_scene( "landing_pilots_idle" );
}
	
	
//
//	Worker anims
tarmac_worker_scenes()
{
	run_scene_first_frame( "worker_01_intro" );
	
	thread run_scene_and_delete("intro_workers");
	thread run_scene_and_delete("intro_workers2");
	thread run_scene_and_delete("intro_workers3");
	thread run_scene_and_delete("intro_workers4");
	thread run_scene_and_delete("intro_workers5");
	thread run_scene_and_delete("intro_workers8");

	//TODO - this may need to be on a notetrack eventually
	flag_wait( "hide_cabin" );
	
	run_scene_and_delete("worker_01_intro");
	thread run_scene_and_delete("worker_01_idle");
	
	flag_wait( "trig_enter_scanner" );

	end_scene( "worker_01_idle" );
	end_scene( "intro_workers" );
	end_scene( "intro_workers2" );
	end_scene( "intro_workers3" );
	end_scene( "intro_workers4" );
	end_scene( "intro_workers5" );
	end_scene( "intro_workers8" );

}

forklift_worker_scenes()
{
	run_scene_first_frame( "worker_forklift_intro" );

	flag_wait( "pa_vo_flag" );

	run_scene_and_delete("worker_forklift_intro");
	thread run_scene_and_delete("worker_forklift_idle");
	flag_wait( "trig_enter_scanner" );

	end_scene( "worker_forklift_idle" );
}

metalstorm_worker_scenes()
{
	run_scene_first_frame( "worker_metalstorm_intro" );

	flag_wait( "pa_vo_flag" );

	run_scene_and_delete("worker_metalstorm_intro");
	thread run_scene_and_delete("worker_metalstorm_idle");
	flag_wait( "trig_enter_scanner" );

	end_scene( "worker_metalstorm_idle" );
}

timescale_glasses()
{
	flag_wait("glasses_on");
	wait 1.7;
	
	level thread maps\createart\karma_art::vision_set_change( "sp_karma_IntroGlassesTint" );
	level.player SetBlur( 18, 4 );
	wait 0.85;

	level thread maps\createart\karma_art::vision_set_change( "sp_karma_introglasseson" );
	level.player SetBlur( 0, 0.5);
	wait 0.5;

	maps\_glasses::play_bootup();
	wait 1;

	level.player show_hud();
	level thread maps\karma::add_argus_info();
	flag_set( "glasses_activated" );
	
	//TUEY - set music to Checkin
	setmusicstate ("KARMA_1_CHECKIN");
}


adjust_player_speed( n_units )
{
	level endon("reset_player_speed");
	
	CONST N_DIST_MAX = 256;
	CONST N_DIST_MIN = 64;
	CONST N_SPEED_MAX = 110;
	CONST N_SPEED_MIN = 60;
	
	setsaveddvar("g_speed", 45);
	
	trigger_wait("trig_player_speed");
	
	while(1)
	{
		n_dist = Distance(level.ai_harper.origin, level.player.origin);
		if ( n_dist >= N_DIST_MAX )
		{
			n_speed = N_SPEED_MAX;
		}
		else if ( n_dist <= N_DIST_MIN )
		{
			n_speed = N_SPEED_MIN;
		}	
		else
		{
			n_percent = ( n_dist - N_DIST_MIN ) / ( N_DIST_MAX - N_DIST_MIN );
			n_speed = ( n_percent * ( N_SPEED_MAX - N_SPEED_MIN ) ) + N_SPEED_MIN;
		}
		setsaveddvar("g_speed", n_speed);
		
		wait(0.05);
	}
}

start_workers()
{
	flag_wait( "start_workers" );

	stop_exploder( 103 );	// background fx
	
	run_scene_and_delete("explosives_workers_intro");
	thread run_scene("explosives_workers_idle");
	
	trigger_wait ("trig_workers_alert");
	end_scene("explosives_workers_idle");
	delete_scene("explosives_workers_idle");

	delete_ais_from_scene( "explosives_workers_idle" );

}

start_workers_walking()
{
	flag_wait( "start_workers" );

	run_scene_and_delete("worker_walking_intro");
	thread run_scene("worker_walking_intro_idle");
	
	trigger_wait ("trig_workers_alert");
	end_scene("worker_walking_intro_idle");
	delete_scene("worker_walking_intro_idle");
	
}

//
//	Set the motion of the ocean
set_water_dvars()
{
	SetDvar( "r_waterwaveangle", "0 52.7305 164.841 0" );
	SetDvar( "r_waterwavewavelength", "592 357 286 1" );	
	SetDvar( "r_waterwaveamplitude", "25 6 5 0" );
	SetDvar( "r_waterwavespeed", "0.72 1.21 1.14 1" );
	
	flag_wait("gate_alert");
	
	SetDvar( "r_waterwaveamplitude", "0 0 0 0" );	// flatten the water
}

set_env_dvars()
{
	SetSavedDvar( "wind_global_vector", "86 149 18" );    // wind vector                 
}

arrival_cleanup()
{
	wait( 0.5 );	// in case of blending issues
	
	if ( level.player get_story_stat( "HARPER_SCARRED" ) )
	{
		delete_scene( "landing_squad_alt" );
	}
	else
	{
		delete_scene( "landing_squad" );
	}
}
