// ----------------------------------------------------------------------------
// codescripts
// ----------------------------------------------------------------------------
#using scripts\codescripts\struct;

// ----------------------------------------------------------------------------
// shared
// ----------------------------------------------------------------------------
#using scripts\shared\array_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\player_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                               	                                                          	              	                                                                                           

// ----------------------------------------------------------------------------
// systems
// ----------------------------------------------------------------------------
//#using scripts\cp\_dialog;
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
#precache( "model", "c_test_decayedman_blo" );
#precache( "model", "c_test_decayedman_dec" );
#precache( "model", "c_test_decayedman_skel1" );
#precache( "model", "c_test_decayedman_skel2" );

#namespace sgen_test_chamber;

// ----------------------------------------------------------------------------
// main
// ----------------------------------------------------------------------------
function main()
{
	/# IPrintLnBold( "sgen_test_chamber::main" ); #/
	init_client_field_callback_funcs();
	setup_scenes();
	
	// hide the special lighting monitor for the time lapse scene
	dni_monitors = GetEntArray( "dni_monitors", "script_noteworthy" );	
	foreach( dni_monitor in dni_monitors )
	{
		dni_monitor hide();
	}
}

// ----------------------------------------------------------------------------
// init_client_field_callback_funcs
// ----------------------------------------------------------------------------
function init_client_field_callback_funcs()
{	
	clientfield::register("world", "sgen_test_chamber_time_lapse", 1, 1, "int");
	clientfield::register("scriptmover", "sgen_test_guys_decay", 1, 1, "int");
	clientfield::register( "world", "fxanim_hive_cluster_break", 1, 1, "int" );
	clientfield::register( "world", "fxanim_time_lapse_objects", 1, 1, "int" );
	clientfield::register( "world", "water_level", 1, 1, "int" );
}

// ----------------------------------------------------------------------------
// setup_scenes
// ----------------------------------------------------------------------------
function setup_scenes()
{
	scene::add_scene_func("cin_inf_04_humanlabdeath_3rd_sh090", &scene_flash_light , "play" );
	scene::add_scene_func("cin_inf_04_humanlabdeath_3rd_sh140", &scene_humanlabdeath_end , "done" );
	scene::add_scene_func("cin_inf_05_taylorinfected_3rd_sh010", &scene_taylorinfected_3rd_fade_nt , "play" );
	scene::add_scene_func("cin_inf_04_02_sarah_vign_01", &scene_sarah_vign_01_fade_nt , "play" );
}


// ----------------------------------------------------------------------------
function gas_release_watcher()
{
	//level waittill( "fx_explosion" );
	
	foreach ( player in level.players )
	{
		player playrumbleonentity( "damage_heavy" );
	}
	earthquake( 0.3, 3.0, level.players[0].origin, 10000 );
}

function scene_humanlabdeath_end( a_ent )
{
	level notify ( "humanlabdeath_scene_end" );
}

function scene_flash_light( a_ent )
{
	fx_flash_lights = GetEntArray( "inf_test_chamber_flashlight", "script_noteworthy" );

	e_origin =  a_ent[ "flashlight" ] gettagorigin( "tag_origin");
	
	foreach( fx_flash_light in fx_flash_lights )
	{
		
		fx_flash_light.origin =  a_ent[ "flashlight" ] gettagorigin( "tag_light_position");
		fx_flash_light linkto( a_ent[ "flashlight" ], "tag_origin" );
	}
	
	// debug light stuff
//	while(1)
//	{
//		origin =  a_ent[ "flashlight" ] gettagorigin( "tag_origin");
//		
//		foreach( fx_flash_light in fx_flash_lights )
//		{
//			/# line( origin, fx_flash_light.origin, ( 1, 0, 0 ), 1 ); #/
//		}
//		
//		wait 0.05;
//	}
}


// ----------------------------------------------------------------------------
// Needed to cache the models in the levels to avoid LOD streaming problems
// ----------------------------------------------------------------------------
function hide_decayedmen()
{	
	decayedman_reg = GetEnt( "decayedman_reg", "targetname" );
	decayedman_reg hide();
	
	decayedman_blo = GetEnt( "decayedman_blo", "targetname" );	
	decayedman_blo hide();

	decayedman_dec = GetEnt( "decayedman_dec", "targetname" );	
	decayedman_dec hide();
	
	decayedman_skel1 = GetEnt( "decayedman_skel1", "targetname" );	
	decayedman_skel1 hide();
		
	decayedman_skel2 = GetEnt( "decayedman_skel2", "targetname" );	
	decayedman_skel2 hide();			
}

// ----------------------------------------------------------------------------
// sgen_test_chamber_init
// ----------------------------------------------------------------------------
function sgen_test_chamber_init( str_objective, b_starting )
{
	/# IPrintLnBold( "sgen_test_chamber_init" ); #/
	if ( b_starting )
	{
		level thread util::screen_fade_out( 0, "white" );
		level util::set_streamer_hint( 7 );
	}
	
	exploder::exploder( "lgt_chamber_ambient_01" );

	skipto::teleport_players( str_objective );
	
	level flag::wait_till( "all_players_spawned" );
	
	level thread scene::play( "cin_inf_04_humanlabdeath_3rd_sh010" );
	
	foreach ( player in level.players )
	{
		player thread clientfield::increment_to_player( "stop_post_fx", 1 );	
	};
	
	level thread clientfield::set( "fxanim_hive_cluster_break", 1 );   // hive cluster break fxanim objects

	array::thread_all(level.players, &infection_util::player_enter_cinematic );
	
	VideoStart( "cp_infection_env_dnimainmonitor" );
	
	level waittill ( "start_fade" );		// nt set in the anim "ch_inf_04_humanlabdeath_3rd_sh010_test_subject"
	level thread util::screen_fade_in( 2, "white" );
	
	level waittill ( "fx_explosion" );
	level thread clientfield::set( "fxanim_hive_cluster_break", 0 );   // hive cluster break fxanim objects
	level thread gas_release_watcher();
	
	level waittill ( "humanlabdeath_scene_end" );
	//VideoStop( "cp_infection_env_dnimainmonitor" );		//TODO: VideoStop not working yet because it couldn't find the video
	
	skipto::objective_completed( "sgen_test_chamber" );
}

// ----------------------------------------------------------------------------
// sgen_test_chamber_done
// ----------------------------------------------------------------------------
function sgen_test_chamber_done( str_objective, b_starting, b_direct, player )
{
	/# IPrintLnBold( "sgen_test_chamber_done" ); #/
}

// ----------------------------------------------------------------------------
// time_lapse_init
// ----------------------------------------------------------------------------
function time_lapse_init( str_objective, b_starting )
{
	/# IPrintLnBold( "time_lapse_init" ); #/
		
	level flag::wait_till( "all_players_spawned" );
	exploder::exploder_stop( "lgt_chamber_ambient_01" );
	
	if ( b_starting )
	{
		array::thread_all(level.players, &infection_util::player_enter_cinematic );
	}
	
	level thread time_lapse_anim_test();
	level thread dni_monitors_swap();
	level thread fx_anim_time_lapse();

	//prestream next closeup scene
	level thread util::set_streamer_hint( 3 );
	
	clientfield::set("sgen_test_chamber_time_lapse", 1);
	
	exploder::exploder( "lgt_chamber_emergency_01" );
	exploder::exploder( "lgt_chamber_door_light_01" );
	
	level thread water_time_lapse();
	
	level waittill ( "scene_time_lapse_end" );
	skipto::objective_completed( "time_lapse" );
}

function time_lapse_anim_test()
{
	scene::add_scene_func( "cin_inf_04_humanlabdeath_3rd_sh150", &scene_decayedman_skin_shader, "play" );	
	scene::add_scene_func( "cin_inf_04_humanlabdeath_3rd_sh150", &scene_time_lapse_end, "done" );			
	scene::play( "cin_inf_04_humanlabdeath_3rd_sh150" );
}

function scene_decayedman_skin_shader( a_ents )
{	
	/# IPrintLnbold( "shader start" ); #/
			
	cin_guy = a_ents["decayedman"];
	cin_guy thread Start_Decayman_Decay();
	
	level waittill( "time_lapse_cut_to_white" );
	
	util::screen_fade_out( 0, "white" );
}

function Start_Decayman_Decay()
{
	self waittill("StartDecay");
	self clientfield::set("sgen_test_guys_decay", 1);
	wait 2.2;
	
	self SetModel("c_test_decayedman_blo");
	self clientfield::set("sgen_test_guys_decay", 0);
	wait 2.2;
	
	self SetModel("c_test_decayedman_dec");
	self clientfield::set("sgen_test_guys_decay", 1);
	wait 2.2;
	
	self SetModel("c_test_decayedman_skel1");
	self clientfield::set("sgen_test_guys_decay", 0);
	wait 2.2;
	
	self SetModel("c_test_decayedman_skel2");
	self clientfield::set("sgen_test_guys_decay", 1);
	wait 2.2;
	
	hide_decayedmen();
}

function scene_time_lapse_end( a_ents )
{
	level notify ( "scene_time_lapse_end" );
}

function dni_monitors_swap()
{
	monitor_a = getent( "dni_monitor_a", "targetname" );
	monitor_a show();
	
	wait 3;
	monitor_b = getent( "dni_monitor_b", "targetname" );
	monitor_a delete();
	monitor_b show();
	
	wait 3;
	monitor_c = getent( "dni_monitor_c", "targetname" );
	monitor_b delete();
	monitor_c show();
	
	wait 3;
	monitor_d = getent( "dni_monitor_d", "targetname" );
	monitor_c delete();
	monitor_d show();
}

function fx_anim_time_lapse()
{
		level thread clientfield::set( "fxanim_time_lapse_objects", 1 );   // time lapse 0fxanim objects
}


// ----------------------------------------------------------------------------
// time_lapse_done
// ----------------------------------------------------------------------------
function time_lapse_done( str_objective, b_starting, b_direct, player )
{
	/# IPrintLnBold( "time_lapse_done" ); #/
}

// ----------------------------------------------------------------------------
// water_time_lapse
// ----------------------------------------------------------------------------
function water_time_lapse()
{
	level clientfield::set( "water_level", 1);
	
	wait 6;
	
	level clientfield::set( "water_level", 0 );
}
	
// ----------------------------------------------------------------------------
// change_water_height
// ----------------------------------------------------------------------------
//function change_water_height( n_height, n_time )
//{
//	n_iteration = Abs( n_time / 0.1 );
//	n_height_inc = n_height / n_iteration;
//	n_current_heihgt = GetDvarFloat( "r_waveWaterHeightOverride" );
//	
//	for ( i = 0; i < n_iteration; i++ )
//	{	
//		n_current_heihgt += n_height_inc;
//		
//		SetDvar( "r_waveWaterHeightOverride", n_current_heihgt );
//		
//		wait 0.1;
//	}
//}

// ----------------------------------------------------------------------------
// cyber_soliders_invest_init
// ----------------------------------------------------------------------------
function cyber_soliders_invest_init( str_objective, b_starting )
{
	/# IPrintLnBold( "cyber_soliders_invest_init" ); #/

	level flag::wait_till( "all_players_spawned" );
	
	if ( b_starting )
	{
		//force to black wait for streamers
		util::screen_fade_out( 0, "white" );

		array::thread_all(level.players, &infection_util::player_enter_cinematic );
		util::set_streamer_hint( 3 );
	}

	level thread util::screen_fade_in( 1.5, "white" );
	level scene::play( "cin_inf_04_02_sarah_vign_01" );
		
	level thread scene::play( "cin_inf_05_taylorinfected_3rd_sh010" );
	
	level waittill( "taylorinfected_sh80_end" );	
			
	util::screen_fade_out( 1 );
	
	//clear streamer hint after scene done
	util::clear_streamer_hint();
	
	skipto::objective_completed( "cyber_soliders_invest" );
}

// ----------------------------------------------------------------------------
// cyber_soliders_invest_done
// ----------------------------------------------------------------------------
function cyber_soliders_invest_done( str_objective, b_starting, b_direct, player )
{
	/# IPrintLnBold( "cyber_soliders_invest_done" ); #/
	exploder::exploder_stop( "lgt_chamber_emergency_01" );
	exploder::exploder_stop( "lgt_chamber_door_light_01" );
}

function scene_sarah_vign_01_fade_nt( a_ent )
{
	level waittill( "sarah_vign_start_fade" );		// NT set in "ch_inf_05_taylorinfected_3rd_sh010_corps"
	util::screen_fade_out( 1, "white" );
}

function scene_taylorinfected_3rd_fade_nt( a_ent )
{
	level waittill( "taylorinfected_start_fade" );		// NT set in "ch_inf_05_taylorinfected_3rd_sh010_corps"
	level thread util::screen_fade_in( 1.5, "white" );	
}

                                 