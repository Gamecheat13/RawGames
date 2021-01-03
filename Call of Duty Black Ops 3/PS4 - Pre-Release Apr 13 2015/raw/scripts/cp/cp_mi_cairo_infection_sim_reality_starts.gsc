// ----------------------------------------------------------------------------
// codescripts
// ----------------------------------------------------------------------------
#using scripts\codescripts\struct;

// ----------------------------------------------------------------------------
// shared
// ----------------------------------------------------------------------------
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\player_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_ai_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                               	                                                          	              	                                                                                           

// ----------------------------------------------------------------------------
// systems
// ----------------------------------------------------------------------------
#using scripts\cp\_dialog;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;

// ----------------------------------------------------------------------------
// Infection
// ----------------------------------------------------------------------------
#using scripts\cp\cp_mi_cairo_infection_util;

// ----------------------------------------------------------------------------
// #precache
// ----------------------------------------------------------------------------
#precache( "triggerstring", "CP_MI_CAIRO_INFECTION_T_BABY_USE" );

#namespace sim_reality_starts;

// ----------------------------------------------------------------------------
// main
// ----------------------------------------------------------------------------
function main()
{
	/# IPrintLnBold( "sim_reality_starts::main" ); #/
	init_client_field_callback_funcs();
	setup_scenes();
}

// ----------------------------------------------------------------------------
// init_client_field_callback_funcs
// ----------------------------------------------------------------------------
function init_client_field_callback_funcs()
{	
	clientfield::register( "toplayer", "sim_out_of_bound", 1, 1, "counter" );
	
	clientfield::register( "world", "sim_lgt_tree_glow_01", 1, 1, "int" );
	clientfield::register( "world", "sim_lgt_tree_glow_02", 1, 1, "int" );
	clientfield::register( "world", "sim_lgt_tree_glow_03", 1, 1, "int" );
	clientfield::register( "world", "sim_lgt_tree_glow_04", 1, 1, "int" );
	clientfield::register( "world", "sim_lgt_tree_glow_05", 1, 1, "int" );
	
	clientfield::register( "world", "sim_lgt_tree_glow_all_off", 1, 1, "int" );
	
	clientfield::register( "toplayer", "pstfx_frost_up", 1, 1, "counter" );
	clientfield::register( "toplayer", "pstfx_frost_down", 1, 1, "counter" );
	clientfield::register( "toplayer", "pstfx_frost_up_baby", 1, 1, "counter" );
	clientfield::register( "scriptmover",    "infection_baby_shader", 1, 1, "int" );
	
	clientfield::register( "world", "toggle_sim_fog_banks", 1, 1, "int" );
	
	clientfield::register( "world", "break_baby", 1, 1, "int" );
}

// ----------------------------------------------------------------------------
// setup_scenes
// ----------------------------------------------------------------------------
function setup_scenes()
{
}

// ----------------------------------------------------------------------------
// sim_reality_starts_init
// ----------------------------------------------------------------------------
function sim_reality_starts_init( str_objective, b_starting )
{
	/# IPrintLnBold( "sim_reality_starts_init" ); #/
	objectives::set( "cp_level_infection_access_sarah" );
	infection_util::turn_on_snow_fx_for_all_players();
	clientfield::set( "toggle_sim_fog_banks", 1 );

	skipto::teleport_players( str_objective );
	
	level flag::wait_till( "all_players_spawned" );
	
	util::screen_fade_out( 0 );
	
	level thread util::screen_fade_in( 1 );
	clientfield::set( "sim_lgt_tree_glow_01", 1 );
	array::thread_all(level.players, &infection_util::player_enter_cinematic );
	
	level thread scene::play( "cin_inf_04_01_birthai_1st_crying_init" );
	
	level thread dead_bodies_anim();
	level thread vo_birth_dialog();
	level thread monitor_t_baby_use();
	level thread monitor_t_lgt_tree_glow_03();
	level thread monitor_t_lgt_tree_glow_04();
	level thread monitor_t_lgt_tree_glow_05();
	level thread sim_reality_obj();
	monitor_t_out_of_bound();
	monitor_t_pstfx_frost_up();
	monitor_t_pstfx_frost_down();
}

function dead_bodies_anim()
{
	// dead bodies anim
	level scene::play( "cin_inf_04_01_birthai_vign_deathpose" );
}

function tree_light_on_rumble()
{
	foreach ( player in level.players )
	{
		 player PlayRumbleOnEntity( "damage_heavy" );
	}
}

// ----------------------------------------------------------------------------
// DIALOG: VO Birth of the AI Intro
// ----------------------------------------------------------------------------
function vo_birth_dialog()
{	
	wait 1;
	
	level dialog::player_say( "plyr_kane_hendricks_0", 1.0 ); // Kane?... Hendricks?
	level thread dialog::player_say( "plyr_something_s_gone_wro_0", 0.0 ); // Something’s gone wrong. Maybe a malfunction in Hall’s DNI?
	
	trigger::wait_till( "t_vo_thea_where_am_i_what_s_0" );
	
	clientfield::set( "sim_lgt_tree_glow_02", 1 );
	tree_light_on_rumble();
	
	playsoundatposition ("evt_tree_light", (-24528,-25283,3712));
	playsoundatposition ("evt_baby_cry", (0,0,0));
	
	trig_3 = GetEnt( "t_lgt_tree_glow_03", "targetname" );
	if( isdefined( trig_3 ) )
	{
		trig_3 waittill( "trigger" );
	}		
		
	level dialog::player_say( "plyr_i_hear_a_baby_crying_0", 1.0 ); // I hear a baby crying... I don’t know...Hello? Is anyone there??
	level dialog::player_say( "plyr_i_don_t_know_if_you_0", 1.0 ); // I don’t know if you’re hearing any of this, Kane. But I think whatever’s happening right now it’s running on me - I’m actually here. Like in training.

	trig_5 = GetEnt( "t_lgt_tree_glow_05", "targetname" );
	if( isdefined( trig_5 ) )
	{
		trig_5 waittill( "trigger" );
	}	
	
//	level dialog::player_say( "plyr_what_the_hell_1", 1.0 ); //What... the... hell?
//	level dialog::player_say( "plyr_oh_my_god_0", 1.0 ); //This can't be...
//	level thread dialog::player_say( "plyr_kane_can_you_hear_m_0", 0.0 ); //Kane. Can you hear me?  Are you seeing this?... Say something - Please.
}

// ----------------------------------------------------------------------------
// monitor_t_lgt_tree_glow_03
// ----------------------------------------------------------------------------
function monitor_t_lgt_tree_glow_03()
{
	trigger::wait_till( "t_lgt_tree_glow_03" );
	
	clientfield::set( "sim_lgt_tree_glow_03", 1 );
	tree_light_on_rumble();
	
	playsoundatposition ("evt_tree_light", (-24934,-23881,3803));
	playsoundatposition ("evt_baby_cry", (0,0,0));
}

// ----------------------------------------------------------------------------
// monitor_t_lgt_tree_glow_04
// ----------------------------------------------------------------------------
function monitor_t_lgt_tree_glow_04()
{
	trigger::wait_till( "t_lgt_tree_glow_04" );
		
	clientfield::set( "sim_lgt_tree_glow_04", 1 );
	tree_light_on_rumble();
	
	playsoundatposition ("evt_tree_light", (-24574,-22663,4172));
	playsoundatposition ("evt_baby_cry", (0,0,0));
}

// ----------------------------------------------------------------------------
// monitor_t_lgt_tree_glow_05
// ----------------------------------------------------------------------------
function monitor_t_lgt_tree_glow_05()
{
	trigger::wait_till( "t_lgt_tree_glow_05" );
		
	clientfield::set( "sim_lgt_tree_glow_05", 1 );
	tree_light_on_rumble();
	
	playsoundatposition ("evt_tree_light", (-23716,-21731,4429));
	playsoundatposition ("evt_baby_cry", (0,0,0));
}

// ----------------------------------------------------------------------------
// sim_reality_starts_done
// ----------------------------------------------------------------------------
function sim_reality_starts_done( str_objective, b_starting, b_direct, player )
{
	clientfield::set( "toggle_sim_fog_banks", 0 );
	clientfield::set( "sim_lgt_tree_glow_all_off", 1 );
	infection_util::turn_off_snow_fx_for_all_players();

	objectives::set( "cp_level_infection_access_sarah" );
}

// ----------------------------------------------------------------------------
// monitor_t_out_of_bound
// ----------------------------------------------------------------------------
function monitor_t_out_of_bound()
{
    a_t_sim_out_of_bound = GetEntArray( "t_sim_out_of_bound", "targetname" );
    array::thread_all( a_t_sim_out_of_bound, &monitor_out_of_bound_trigger );
}

// ----------------------------------------------------------------------------
// monitor_out_of_bound_trigger
// ----------------------------------------------------------------------------
function monitor_out_of_bound_trigger( )
{
	s_sim_out_of_bound_warp = struct::get( "s_sim_out_of_bound_warp" );
	
	while ( true )
	{
		self waittill( "trigger", player );
		
		if ( IsDefined( player ) )
		{		
			player thread hud::fade_to_black_for_x_sec( 0, 1, 0.5, 1, "white" );	
	
			wait 0.25; // Wait for the full screen FX to cover the screen before warpping.
			
			player clientfield::increment_to_player( "sim_out_of_bound" );
			player clientfield::set( "player_spawn_fx", true );
			
			player SetOrigin( s_sim_out_of_bound_warp.origin );
			player SetPlayerAngles( s_sim_out_of_bound_warp.angles );	
			
			//hack fix when player are teleported
			infection_util::turn_off_snow_fx_for_all_players();
			util::wait_network_frame(); 
			infection_util::turn_on_snow_fx_for_all_players();
			
			wait 0.25; // Give the FX sometime to play before turning it off.
			player clientfield::set( "player_spawn_fx", false );
		} 
	}
}

// ----------------------------------------------------------------------------
// monitor_t_pstfx_frost_up
// ----------------------------------------------------------------------------
function monitor_t_pstfx_frost_up( )
{
    a_t_pstfx_frost_up = GetEntArray( "t_pstfx_frost_up", "targetname" );
    array::thread_all( a_t_pstfx_frost_up, &pstfx_frost_up );
}

// ----------------------------------------------------------------------------
// pstfx_frost_up
// ----------------------------------------------------------------------------
function pstfx_frost_up()
{
	while( true )
	{
		self waittill( "trigger", player );
		
		if ( IsDefined( player ) )
		{
			player clientfield::increment_to_player( "pstfx_frost_up", 1 );	
		}
	}
}

// ----------------------------------------------------------------------------
// monitor_t_pstfx_frost_down
// ----------------------------------------------------------------------------
function monitor_t_pstfx_frost_down( localClientNum )
{
    a_t_pstfx_frost_down = GetEntArray( "t_pstfx_frost_down", "targetname" );    
  	array::thread_all( a_t_pstfx_frost_down, &pstfx_frost_down );
}

// ----------------------------------------------------------------------------
// pstfx_frost_down
// ----------------------------------------------------------------------------
function pstfx_frost_down()
{
	while( true )
	{
		self waittill( "trigger", player );
		
		if ( IsDefined( player ) )
		{
			player clientfield::increment_to_player( "pstfx_frost_down", 1 );	
		}
	}
}

// ----------------------------------------------------------------------------
// monitor_t_baby_use
// ----------------------------------------------------------------------------
function monitor_t_baby_use()
{
	trigger::wait_till( "pod_open_anim_trig" );
	level thread scene::play( "cin_inf_04_01_birthai_1st_crying_init_loop" );
	
	// Stream test chamber script bundle now!
	level thread util::set_streamer_hint( 7 );
	
	t_baby_use = GetEnt( "t_baby_use", "targetname" );
	t_baby_use SetHintString( &"CP_MI_CAIRO_INFECTION_T_BABY_USE" );
	Assert( IsDefined( t_baby_use ), "trig_baby_use not found!" );
		
	t_baby_use waittill( "trigger", player );
		
	if ( IsDefined( player ) )
	{
		/# IPrintLnbold( "Player picks up the infant" ); #/		
		scene::add_scene_func( "cin_inf_04_01_birthai_1st_crying", &scene_baby_skin_shader, "play" );		
		level scene::play( "cin_inf_04_01_birthai_1st_crying" );
		
		array::thread_all(level.players, &infection_util::player_leave_cinematic );
		skipto::objective_completed( "sim_reality_starts" );
	}	
}

function scene_baby_skin_shader( a_ents )
{	
	/# IPrintLnbold( "shader start" ); #/
		
	cin_baby= a_ents["baby"];
				
	level waittill( "pickup_baby" );
	cin_baby clientfield::set("infection_baby_shader", 1);
	
	level waittill ( "Swap_baby" );
	cin_baby Ghost();
	level clientfield::set( "break_baby", 1 );
	
	level waittill ( "baby_frost_up" );
		
	foreach ( player in level.players )
	{
		player thread clientfield::increment_to_player( "pstfx_frost_up_baby", 1 );	
	};		
	
	level waittill ( "baby_whiteout" ); 		
		
	level thread util::screen_fade_out( 1, "white" );
}

function sim_reality_obj()
{
	trigger::wait_till( "t_lgt_tree_glow_05" );
	
	// Objective by the baby tree
	s_pos = struct::get( "baby_tree_obj", "targetname" );
	objectives::set( "cp_level_infection_baby_tree", s_pos );
	
	trigger::wait_till( "baby_tree_obj_trig" );
	objectives::complete( "cp_level_infection_baby_tree", s_pos );	
}