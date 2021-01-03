#using scripts\codescripts\struct;

//shareds
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\objpoints_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\codescripts\struct;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_vehicle;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\vehicles\_raps;
#using scripts\shared\exploder_shared;
#using scripts\cp\_objectives;
#using scripts\cp\_dialog;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_cairo_ramses2_fx;
#using scripts\cp\cp_mi_cairo_ramses2_sound;
#using scripts\cp\cp_mi_cairo_ramses_utility;

                      

#using scripts\shared\ai_shared;

#using scripts\cp\cp_mi_cairo_ramses_quad_tank_plaza;

#precache( "triggerstring", "CP_MI_CAIRO_RAMSES_VTOL_IGC_TRIG" );

#precache( "objective", "cp_level_ramses_vtol_igc" );

#namespace vtol_igc;

function vtol_igc_main()
{
	precache();
	
	level flag::init( "vtol_igc_robots_alerted" );
	level flag::init( "vtol_igc_robots_dead" );
	level flag::init( "hendricks_at_vtol_igc" );
	level flag::init( "vtol_igc_trigger_used" );
	
	setup_vtol_igc();
}

function precache()
{
	// DO ALL PRECACHING HERE
}

function hide_skipto_items()
{		
	//hide the stuff that needs to be hidden during skipto's
	// TODO - set up any of these that you can w/ delayed spawning
	a_hide_me = GetEntArray( "hide_me", "script_noteworthy" );
	foreach( e_hide_me in a_hide_me )
	{
		if ( isdefined( e_hide_me ) )
		{
			e_hide_me Hide();	
		}	
	}	
	
	//hide vtol robots
	// TODO - set up any of these that you can w/ delayed spawning
	a_hide_me = GetEntArray( "hide_vtol_robots", "script_noteworthy" );
	foreach( e_hide_me in a_hide_me )
	{
		if ( isdefined( e_hide_me ) )
		{
			e_hide_me Hide();	
		}	
	}	
	
	// TODO - set up any of these that you can w/ delayed spawning
	a_alley_bridge_destroyed_pieces = GetEntArray( "alley_bridge_destroyed", "targetname" );
	foreach( e_pieces in a_alley_bridge_destroyed_pieces )
	{
		e_pieces Hide();
	}
}

function setup_vtol_igc()
{	
	level thread vtol_igc_notetracks();
	level thread hide_vtol_wings();
	level notify( "sndvtolcollapse1" );
	level thread setAudio_snapshot();
	// Hide Shadow Card
	array::run_all( GetEntArray( "lgt_vtol_block", "targetname" ), &Hide);  
	
	// Init Scenes
	level scene::init( "cin_ram_06_05_safiya_1st_friendlydown_init" );
	level scene::init( "cin_ram_06_05_safiya_aie_breakin_pilotshoots" );
	
	scene::add_scene_func( "cin_ram_06_05_safiya_1st_friendlydown", &vtoL_igc_done, "done" );
	
	objectives::set( "cp_level_ramses_vtol_igc" );
	
	//setup IGC trigger
	t_use_vtol_igc = GetEnt( "trig_use_vtol_igc", "targetname" );
	t_use_vtol_igc thread create_interact();
	
	level thread init_robot_breakin_vignette();

	trigger::wait_till( "trig_spawn_vtol_igc" );
	
	level thread vtol_igc_vo();
	
	//kicks off spawn managers and siege bots so battle plays out upahead
	quad_tank_plaza::pre_skipto();
	
	//  Hendricks ignores all enemies in QT Plaza
	level thread initial_hendricks_scripting();
	
	level thread breakin_pilotshoots_scene();
	
	spawner::waittill_ai_group_cleared( "vtol_robots" );

	
	level flag::set( "vtol_igc_robots_dead" );
	
	level.ai_hendricks thread hendricks_vtol_igc_start_notetrack();
	
	level thread util::set_streamer_hint( 3 );
	
	level scene::init( "cin_ram_06_05_safiya_1st_friendlydown" );	
	
	level flag::wait_till( "hendricks_at_vtol_igc" );
	
	s_use_trigger_gameobject = make_interact_usable( t_use_vtol_igc );
	
	level flag::wait_till( "vtol_igc_trigger_used" );
	
	level.allowbattlechatter["bc"] = false;
	
	s_use_trigger_gameobject gameobjects::destroy_object( true );
	
	// Disable Alley spawnmanagers
	spawn_manager::disable( "sm_alley_egypt_intro" );
	spawn_manager::disable( "sm_alley_nrc_intro" );
	
	spawn_manager::disable( "sm_alley_egypt_mid" );	
	spawn_manager::disable( "sm_alley_nrc_mid" );	

	level thread scene::play( "cin_ram_06_05_safiya_1st_friendlydown" );
	
	//	Alley Cleanup
	a_alley_egypt_intro_guy = GetEntArray( "alley_egypt_intro_guy_ai", "targetname" );
	foreach( e_guy in a_alley_egypt_intro_guy )
	{
		e_guy Kill();
	}
	
	a_alley_egypt_mid_guy = GetEntArray( "alley_egypt_mid_guy_ai", "targetname" );
	foreach( e_guy in a_alley_egypt_mid_guy )
	{
		e_guy Kill();
	}

	level flag::wait_till( "vtol_igc_done" );	

	level.allowbattlechatter["bc"] = true;	
	level util::clientnotify( "pst" ); //audio snapshot\duck  (This is also being sent via notetrack in animation, but that seems to fail sometimes).
	
	skipto::objective_completed( "vtol_igc" );
}

function create_interact() // self = trigger
{
	self SetCursorHint( "HINT_NOICON" );
	self TriggerIgnoreTeam();
	self SetTeamForTrigger( "none" );
	self SetInvisibleToAll();
}

function make_interact_usable( t_use_vtol_igc )
{	
	t_use_vtol_igc SetVisibleToAll();
	
	// You can add multiple models into the gameobjects model array, each with their own relative offset
	v_offset = ( 0, 0, 0 );
	a_visuals = [];

	// This is an objective indicator defined in the cp_objectives gdt
	str_objective_type = &"cp_level_ramses2_vtol_igc";

	// Create the gameobject
	str_team = "allies";
	s_gameobject = gameobjects::create_use_object( str_team, t_use_vtol_igc, a_visuals, v_offset, str_objective_type );

	// Setup gameobject params
	s_gameobject gameobjects::allow_use( "any" );
	s_gameobject gameobjects::set_use_time( 0 );  // How long the progress bar takes to complete
	s_gameobject gameobjects::set_use_hint_text( &"CP_MI_CAIRO_RAMSES_VTOL_IGC_TRIG" );
	s_gameobject gameobjects::set_visible_team( "any" );				// Who can see the gameobject

	// Setup gameobject callbacks
	s_gameobject.onUse = &callback_gameobject_vtol_igc_trigger_on_use;
	
	return s_gameobject;
}

// Called when gameobject has been "used"
function callback_gameobject_vtol_igc_trigger_on_use( e_player )
{
	level flag::set( "vtol_igc_trigger_used" );
}

function vtol_igc_notetracks( b_vtol_igc_skipto = true )
{		
	level flag::init( "vtol_igc_started" );
	ramses_util::co_op_teleport_on_igc_end( "cin_ram_06_05_safiya_1st_friendlydown", "vtol_igc_teleport" );
	
	scene::add_scene_func( "cin_ram_06_05_safiya_1st_friendlydown", &vtoL_igc_started, "play" );
	
	if( b_vtol_igc_skipto )
	{
		level thread through_fire_notetrack();

		exploder::exploder( "fx_expl_igc_vtol_ext_smoke" );
		exploder::exploder( "fx_expl_vtol_int" );

		level thread stop_exploder_ext_smoke();
	
		level thread stop_exploder_vtol_int();		
	}
	
	level thread hunter_fxanim_notetrck();
	
	level thread truck_hit_notetrack();
}

function vtoL_igc_started( a_ents )
{
	level flag::set( "vtol_igc_started" );
	array::run_all( GetEntArray( "lgt_vtol_block", "targetname" ), &Show);	
}

function vtoL_igc_done( a_ents )
{
	level flag::set( "vtol_igc_done" );
	
	exploder::exploder_stop( "fx_expl_qtplaza_hotel" );	
	array::run_all( GetEntArray( "lgt_vtol_block", "targetname" ), &Hide);
	
	util::clear_streamer_hint();
}

function init_robot_breakin_vignette()
{
	scene::add_scene_func( "cin_ram_06_05_safiya_aie_breakin_02", &robot_breakin_init_scene_func, "init" );
	level thread scene::init( "cin_ram_06_05_safiya_aie_breakin_02" );	
}

function breakin_pilotshoots_scene()
{
	scene::add_scene_func( "cin_ram_06_05_safiya_aie_breakin_pilotshoots", &breakin_pilotshoots_done, "done" );
	
	a_flags = [];
	a_flags[0] = "player_looking_at_vtol_igc";
	a_flags[1] = "vtol_igc_robots_alerted";
	level flag::wait_till_any( a_flags );
	
	level thread scene::play( "cin_ram_06_05_safiya_aie_breakin_pilotshoots" );	
}

function breakin_pilotshoots_done( a_ents )
{
	a_keys = GetArrayKeys( a_ents );
	foreach( str_key in a_keys )
	{
		if( IsSubstr( str_key, "robot" ) )
		{
			ai_robot = a_ents[ str_key ];
			if( IsAlive( ai_robot ) )
			{
				ai_robot Kill();
			}
		}
	}	
}

function initial_hendricks_scripting()
{
	level.ai_hendricks ai::set_ignoreall( true );

	nd_start = GetNode( "vtol_igc_hendricks_start", "targetname" );
	
	// HACK: this wait shouldn't be necessary
	// I have to do this to get Hendricks to respect this force_goal call when using the VTOL_IGC skipto
	// If I don't do this, he won't respect the first force_goal call and will run off towards the Alley
	wait 1.0;
	level.ai_hendricks ai::force_goal( nd_start );
	// HACK end
	
	level flag::wait_till( "vtol_igc_robots_alerted" );
	
	level.ai_hendricks ai::set_ignoreall( false );
}

function robot_breakin_init_scene_func( a_ents )
{
	a_keys = GetArrayKeys( a_ents );
	foreach( str_key in a_keys )
	{
		if( IsSubstr( str_key, "robot" ) )
		{
			a_ents[ str_key ] thread robot_break_out_of_scene();
		}
	}
}

function robot_break_out_of_scene() // self = AI
{
	self endon( "death" );
	level endon( "stop_robot_breakout_logic" );
	
	self thread player_near_robot();
	
	self util::waittill_any( "damage", "bulletwhizby", "pain", "proximity", "player_near_vtol_igc" );
	
	level flag::set( "vtol_igc_robots_alerted" );
	
	level thread scene::play( "cin_ram_06_05_safiya_aie_breakin_02" );
	
	level.ai_hendricks ai::set_ignoreall( false );
	trigger::use( "trig_spawn_vtol_igc" );

	level notify( "stop_robot_breakout_logic" );
}

function player_near_robot() // self = ai
{
	self endon( "death" );
	
	trigger::wait_till( "vtol_igc_near_robots", "targetname" );
	
	self notify( "player_near_vtol_igc" );
}

function hendricks_vtol_igc_start_notetrack() // self = Hendricks AI
{
	// notetrack on ch_ram_06_05_safiya_vign_friendlydown_hendricks_loop
	self waittill( "hendricks_start_loop" );
	
	level flag::set( "hendricks_at_vtol_igc" );
}

function through_fire_notetrack()
{
	// notetrack on p_ram_06_05_safiya_1st_friendlydown_player
	level waittill( "vtol_igc_player_through_fire" );
	
	level thread quad_tank_plaza::ignore_players();	
}

function truck_hit_notetrack()
{
	level flag::wait_till( "vtol_igc_started" );
	
	s_scene = struct::get( "truck_flip_vtol", "targetname" );
	s_scene thread scene::init();
	
	// notetrack on p_ram_06_05_safiya_1st_friendlydown_player
	level waittill( "truck_hit" );
	
	s_scene thread scene::play();
	
	// notetrack on p_ram_06_05_safiya_1st_friendlydown_player
	level waittill( "delete_guy_that_gets_crushed_by_truck" );
	
	e_guy = GetEnt( "cin_ram_06_05_safiya_1st_friendlydown_guy06", "targetname" );
	e_guy Delete();
}

function hunter_fxanim_notetrck()
{
	// notetrack on p_ram_06_05_safiya_1st_friendlydown_player
	level waittill( "vtol_igc_hunter_fxanim" );
	
	quad_tank_plaza::vtol_igc_hunter_fx_anim();
}

function stop_exploder_ext_smoke()
{
	// notetrack on p_ram_06_05_safiya_1st_friendlydown_player
	level waittill( "stop_exploder_ext_smoke" );

	exploder::exploder_stop( "fx_expl_igc_vtol_ext_smoke" );
}

function stop_exploder_vtol_int()
{
	// notetrack on p_ram_06_05_safiya_1st_friendlydown_player
	level waittill( "stop_exploder_vtol_int" );

	exploder::exploder_stop( "fx_expl_vtol_int" );
}

function hide_vtol_wings()
{
	e_vtol = undefined;
	
	while( !IsDefined( e_vtol ) )
	{
		e_vtol = GetEnt( "cin_ram_06_05_safiya_1st_friendlydown_vtol01", "targetname" );
		wait 1.0;
	}
	
	e_vtol HidePart( "tag_wing_left_animate", "", true );
	e_vtol HidePart( "tag_wing_right_animate", "", true );
	
	a_e_probes = GetEntArray( "vtol_cockpit_probe", "script_noteworthy" );
	foreach( e_probe in a_e_probes )
	{
		e_probe LinkTo( e_vtol, "tag_cockpit_lgt" );
	}
}
function setAudio_snapshot()
{
	level flag::wait_till( "all_players_spawned" );
	wait(1);
	level util::clientnotify( "pres" ); //audio snapshot\duck
}

/***********************************
 * VO
 * ********************************/

function vtol_igc_vo()
{
	level.ai_hendricks dialog::say( "hend_kane_we_got_a_frie_0" );
	
	level dialog::remote( "kane_scanning_for_lifesig_0" );
	
	// HACK - this "player" line is playing on an AI for now. DPS, mbettelman 02/16/2015
	ai_pilot = GetEnt( "cin_ram_06_05_safiya_1st_friendlydown_guy01", "targetname" );
	ai_pilot dialog::say( "plyr_screams_from_inside_0" );
	
	level.players[0] dialog::say( "plyr_that_s_lifesign_enou_0" );
}
