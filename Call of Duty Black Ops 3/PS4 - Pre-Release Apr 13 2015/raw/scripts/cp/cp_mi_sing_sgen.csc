#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\vehicles\_quadtank;

#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_sing_sgen_fx;
#using scripts\cp\cp_mi_sing_sgen_sound;

                                                                           
        	                               	                    	                                 	                                        	                            	                                                                  	                               
                                                                                       
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       






	// How long it takes to get full futz
	// How long it takes to clear up







	
#precache( "client_fx", "dirt/fx_dust_motes_player_loop" );
#precache( "client_fx", "light/fx_light_depth_charge_inactive" );
#precache( "client_fx", "light/fx_light_depth_charge_warning" );
#precache( "client_fx", "water/fx_water_rush_teleport_cover" );

function main()
{
	util::set_streamer_hint_function( &force_streamer, 5 );
	init_clientfields();

	cp_mi_sing_sgen_fx::main();
	cp_mi_sing_sgen_sound::main();
	
	callback::on_localclient_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
	
	setup_skiptos();

	load::main();

	util::waitforclient( 0 );	// This needs to be called after all systems have been registered.
	
	// Enables map switching
	SetDVAR( "sv_mapswitch", 1 );

	// Exterior Buildings
	level thread scene::init( "p7_fxanim_gp_crane_pallet_01_bundle" );
	level thread scene::init( "p7_fxanim_cp_sgen_silo_twins_revenge_flood_bldg_01_bundle" );
	level thread scene::init( "p7_fxanim_cp_sgen_silo_twins_revenge_flood_bldg_02_bundle" );
	level thread scene::init( "p7_fxanim_cp_sgen_silo_twins_revenge_flood_bldg_03_bundle" );
}


function on_player_connect( localClientNum )
{
	filter::init_filter_ev_interference( self );
}


function on_player_spawned( localClientNum )
{
	player = getlocalplayer( localClientNum );
	
	if ( player GetEntityNumber() != self GetEntityNumber() )
	{
		return;
	}

	self.n_oed_futz = 0.0;
	self.b_oed_futz_filter_on = false;
	self.n_oed_futz_increment = 0.0;
}


function init_clientfields()
{
	// FX Anim bits 
	clientfield::register( "world", "w_fxa_truck_flip",					1, 1, "int", &truck_flip,						!true, !true );	// FXANIM during Quad Tank fight
	clientfield::register( "world", "w_robot_window_break",				1, 1, "int", &robot_window_break,				!true, !true );
	clientfield::register( "world", "silo_swim_bridge_fall",			1, 1, "int", &silo_swim_bridge_fall,				!true, !true );
	clientfield::register( "world", "w_underwater_state",				1, 1, "int", &underwater_state_toggle, 			!true, !true );
	clientfield::register( "world", "w_flood_combat_windows_b",			1, 1, "int", &flood_combat_windows_b, 			!true, !true );
	clientfield::register( "world", "w_flood_combat_windows_c",			1, 1, "int", &flood_combat_windows_c, 			!true, !true );
	clientfield::register( "world", "elevator_light_probe",				1, 1, "int", &link_elevator_light_probe, 		!true, !true );
	clientfield::register( "world", "flood_defend_hallway_flood_siege",	1, 1, "int", &flood_defend_hallway_flood_siege, 	!true, !true );
	clientfield::register( "world", "tower_chunks1",					1, 1, "int", &tower_chunks1, 					!true, !true );
	clientfield::register( "world", "tower_chunks2",					1, 1, "int", &tower_chunks2, 					!true, !true );
	clientfield::register( "world", "tower_chunks3",					1, 1, "int", &tower_chunks3, 					!true, !true );
	clientfield::register( "world", "observation_deck_destroy",			1, 1, "counter", &observation_deck_destroy, 		!true, !true );	
	clientfield::register( "world", "fallen_soldiers_client_fxanims",	1, 1, "int", &fallen_soldiers_client_fxanims, 	!true, !true );
	clientfield::register( "world", "w_flyover_buoys",					1, 1, "int", &intro_flyover_client_fxanims, 		!true, !true );
	clientfield::register( "world", "w_twin_igc_fxanim",				1, 2, "int", &twin_igc_client_fxanims, 		!true, !true );
	
	//fxanim rocks
	clientfield::register( "world", "debris_catwalk",				1, 1, "int", &debris_catwalk,			!true, !true );
	clientfield::register( "world", "debris_wall",					1, 1, "int", &debris_wall,				!true, !true );
	clientfield::register( "world", "debris_fall",					1, 1, "int", &debris_fall,				!true, !true );
	clientfield::register( "world", "debris_bridge",				1, 1, "int", &debris_bridge,				!true, !true );
	
	clientfield::register( "scriptmover", "structural_weakness",		1, 1, "int",	&set_structural_weakness,		!true, !true );
	clientfield::register( "scriptmover", "sm_elevator_extracam",		1, 2, "int",	&set_elevator_extracam,			!true, !true );
	clientfield::register( "scriptmover", "sm_elevator_shader",			1, 2, "int",	&set_elevator_shader,			!true, !true );
	clientfield::register( "scriptmover", "sm_elevator_door_state",		1, 2, "int",	&set_elevator_door_state,		!true, !true );
	clientfield::register( "scriptmover", "mappy_path", 				1, 1, "int", &mappy_path, 					!true, !true );	
	duplicate_render::set_dr_filter_offscreen( "mappy_path", 25, "path_active", undefined, 2, "mc/hud_outline_model_z_red" );
	clientfield::register( "scriptmover", "weakpoint",	 				1, 1, "int", &weakpoint, 					!true, !true );
	duplicate_render::set_dr_filter_offscreen( "weakpoint_keyline", 100, "weakpoint_keyline_show_z", "weakpoint_keyline_hide_z", 2, "mc/hud_outline_model_z_white_alpha" );
	clientfield::register( "scriptmover", "sm_depth_charge_fx",	 		1, 1, "int", &set_depth_charge_fx, 			!true, !true );

	clientfield::register( "toplayer", "reduce_oed_range",  			1, 1, "int", &reduce_oed, 					!true, !true );
	clientfield::register( "toplayer", "activate_pallas_monitoring",  	1, 2, "int", &pallas_fight_monitoring, 		!true, !true );
	clientfield::register( "toplayer", "tp_water_sheeting",  			1, 1, "int", &water_sheeting_toggle, 		!true, !true );
	clientfield::register( "toplayer", "oed_interference",  			1, 1, "int", &oed_interference, 				!true, !true );
	clientfield::register( "toplayer", "sndSiloBG",  					1, 1, "int", &sndSiloBG, 					!true, !true );
	clientfield::register( "toplayer", "sndSgenUW",  					1, 1, "int", &sndSgenUW, 					!true, !true );
	clientfield::register( "toplayer", "dust_motes", 					1, 1, "int", &dust_motes, 					!true, !true );
	clientfield::register( "toplayer", "futz_interference",				1, 5, "float", &futz_interference, 			!true, !true );
	clientfield::register( "toplayer", "silo_debris",					1, 1, "counter",	&silo_debris,				!true, !true );
	clientfield::register( "toplayer", "water_teleport", 				1, 1, "int", &water_teleport_transition, 	!true, !true );
	clientfield::register( "toplayer", "pstfx_frost_up", 				1, 1, "counter", &callback_pstfx_frost_up, 	!true, !true );
	clientfield::register( "toplayer", "pstfx_frost_down", 				1, 1, "counter", &callback_pstfx_frost_down, !true, !true );	
	
	clientfield::register( "vehicle",	"extra_cam_ent",				1, 2, "int", &set_drone_cam,				!true, !true );
	clientfield::register( "vehicle",	"show_mappy_path",				1, 1, "int", &path_loop, 				!true, !true );
	clientfield::register( "scriptmover", "turn_fake_robot_eye",		1, 1, "int", &play_robot_eye_fx,			!true,	!true);
	visionset_mgr::register_overlay_info_style_blur( "earthquake_blur", 1, 1, 0.1, 0.25, 4 );
	
	clientfield::register("actor", "robot_eye_fx", 1, 1, "int", &robot_eye_fx, true, true);
	clientfield::register("actor", "sndStepSet", 1, 1, "int", &sndStepSet, true, !true);	
}

function setup_skiptos()
{
	skipto::add( "intro",				&skipto_intro, 					"Intro" );
	skipto::add( "post_intro",			&skipto_post_intro, 			"Post Intro" );
	skipto::add( "enter_sgen",			&skipto_enter_sgen, 			"Enter SGEN" );
	skipto::add( "enter_lobby",			&skipto_enter_lobby, 			"QTank Fight" );

	skipto::add( "discover_data", 		&skipto_discover_data,			"Discover Data" );
	skipto::add( "aquarium_shimmy", 	&skipto_aquarium_shimmy, 		"Aquarium Shimmy" );
	skipto::add( "gen_lab", 			&skipto_gen_lab, 				"Genetics Lab" );
	skipto::add( "post_gen_lab", 		&skipto_post_gen_lab, 			"Post Gen Lab" );
	skipto::add( "chem_lab", 			&skipto_chem_lab, 				"Chemical Lab" );
	skipto::add( "post_chem_lab", 		&skipto_post_chem_lab, 			"Post Chem Lab" );
	skipto::add( "silo_floor", 			&skipto_silo_floor, 			"Silo Floor Battle" );
	skipto::add( "under_silo", 			&skipto_under_silo, 			"Under Silo" );

	skipto::add( "fallen_soldiers", 	&skipto_init,					"Fallen Soldiers" );
	skipto::add( "testing_lab_igc", 	&skipto_init, 					"Human Testing Lab" );
	skipto::add( "dark_battle", 		&skipto_init, 					"Dark Battle" );
	skipto::add( "charging_station", 	&skipto_init, 					"Charging Station" );

	skipto::add( "descent", 			&skipto_init, 					"Descent" );
	skipto::add( "pallas_start", 		&skipto_pallas_start,			"pallas start" );
	skipto::add( "pallas_end", 			&skipto_init, 					"Pallas Death" );
	skipto::add( "twin_revenge", 		&skipto_init, 					"Twin Revenge" );

	skipto::add( "flood_combat", 		&skipto_init, 					"Flood Combat" );
	skipto::add( "flood_defend", 		&skipto_init, 					"Flood Defend" );
	skipto::add( "underwater_battle", 	&skipto_init, 					"Underwater Battle" );
	skipto::add( "underwater_rail", 	&skipto_init, 					"Underwater Rail" );
	skipto::add( "silo_swim", 			&skipto_init, 					"Silo Swim" );
}

function skipto_init( str_objective, b_starting )
{
	level thread stop_exterior_fxanims();	
}

function skipto_pallas_start( str_objective, b_starting )
{
	level scene::init( "p7_fxanim_cp_sgen_observation_deck_break_01_bundle" );
	
	level thread stop_exterior_fxanims();	
}

function skipto_intro( str_objective, b_starting )
{
	if ( b_starting )
	{
		
	}
	
	//init these for natural progression playthrough
	level thread init_interior_fx_anims();
	
}

function skipto_post_intro( str_objective, b_starting )
{
	if ( b_starting )
	{
		level thread init_interior_fx_anims();		
	}
}

function skipto_enter_sgen( str_objective, b_starting )
{
	if ( b_starting )
	{
		level thread init_interior_fx_anims();
	}
}

function skipto_enter_lobby( str_objective, b_starting )
{
	if ( b_starting )
	{	
		level thread init_interior_fx_anims();
	}
}

function skipto_discover_data( str_objective, b_starting )
{
	if ( b_starting )
	{	
		level thread init_interior_fx_anims();
	}
}

function skipto_aquarium_shimmy( str_objective, b_starting )
{
	if ( b_starting )
	{	
		level thread init_interior_fx_anims();
	}
}

function skipto_gen_lab( str_objective, b_starting )
{
	if ( b_starting )
	{	
		level thread init_fx_anims_from_gen_lab();
	
		level thread stop_exterior_fxanims();
	}
}

function skipto_post_gen_lab( str_objective, b_starting )
{
	if ( b_starting )
	{	
		level thread init_fx_anims_from_gen_lab();

		level thread stop_exterior_fxanims();
	}
}

function skipto_chem_lab( str_objective, b_starting )
{
	if ( b_starting )
	{	
		level thread init_fx_anims_from_chem_lab();
	
		level thread stop_exterior_fxanims();	
	}
}

function skipto_post_chem_lab( str_objective, b_starting )
{
	if ( b_starting )
	{	
		level thread init_fx_anims_from_chem_lab();
	
		level thread stop_exterior_fxanims();	
	}
}

function skipto_silo_floor( str_objective, b_starting )
{
	if ( b_starting )
	{	
		level thread init_fx_anims_from_chem_lab();

		level thread stop_exterior_fxanims();		
	}
}

function skipto_under_silo( str_objective, b_starting )
{
	if ( b_starting )
	{	
		level thread init_fx_anims_from_chem_lab();

		level thread stop_exterior_fxanims();		
	}
}

function init_interior_fx_anims()
{
	//setup the pallet so its in the intro shot
	level scene::play( "p7_fxanim_gp_crane_pallet_01_bundle" );	
	
	//setup for natural playthrough
	level scene::init( "p7_fxanim_cp_sgen_silo_debris_bridge_bundle" ); //p7_fxanim_cp_sgen_silo_debris_bridge_bundle - rocks on bridge catwalk
	level scene::init( "p7_fxanim_cp_sgen_silo_debris_wall_bundle" ); //p7_fxanim_cp_sgen_silo_debris_wall_bundle - above shimmy wall
	level scene::init( "p7_fxanim_cp_sgen_silo_debris_fall_bundle" ); //p7_fxanim_cp_sgen_silo_debris_fall_bundle - outside gen lab exit
	level scene::init( "p7_fxanim_cp_sgen_silo_debris_catwalk_bundle" ); //p7_fxanim_cp_sgen_silo_debris_catwalk_bundle	- rocks landing on bench	
}

function init_fx_anims_from_gen_lab()
{
	//setup the pallet so its in the intro shot
	level scene::play( "p7_fxanim_gp_crane_pallet_01_bundle" );	
	
	//setup for natural playthrough
	level scene::init( "p7_fxanim_cp_sgen_silo_debris_bridge_bundle" ); //p7_fxanim_cp_sgen_silo_debris_bridge_bundle - rocks on bridge catwalk
	level scene::init( "p7_fxanim_cp_sgen_silo_debris_fall_bundle" ); //p7_fxanim_cp_sgen_silo_debris_fall_bundle - outside gen lab exit
	
	//TODO: wait until we get client side functionaity
	//skipto end
//	level scene::skipto_end( "p7_fxanim_cp_sgen_silo_debris_wall_bundle" ); //p7_fxanim_cp_sgen_silo_debris_wall_bundle - above shimmy wall	
//	level scene::skipto_end( "p7_fxanim_cp_sgen_silo_debris_catwalk_bundle" ); //p7_fxanim_cp_sgen_silo_debris_catwalk_bundle	- rocks landing on bench
}

function init_fx_anims_from_chem_lab()
{
	//setup the pallet so its in the intro shot
	level scene::play( "p7_fxanim_gp_crane_pallet_01_bundle" );	
	
	//TODO: wait until we get client side functionaity	
	//skipto end
//	level scene::skipto_end( "p7_fxanim_cp_sgen_silo_debris_wall_bundle" ); //p7_fxanim_cp_sgen_silo_debris_wall_bundle - above shimmy wall	
//	level scene::skipto_end( "p7_fxanim_cp_sgen_silo_debris_catwalk_bundle" ); //p7_fxanim_cp_sgen_silo_debris_catwalk_bundle	- rocks landing on bench
//	level scene::skipto_end( "p7_fxanim_cp_sgen_silo_debris_bridge_bundle" ); //p7_fxanim_cp_sgen_silo_debris_bridge_bundle - rocks on bridge catwalk
//	level scene::skipto_end( "p7_fxanim_cp_sgen_silo_debris_fall_bundle" ); //p7_fxanim_cp_sgen_silo_debris_fall_bundle - outside gen lab exit
	
}

//*****************************************************************************
//*****************************************************************************

function robot_eye_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if(newVal)
	{
		self.eye_fx = PlayFxOnTag( localClientNum, level._effect["eye_glow"], self, "tag_eye" );
		
	}
	else
	{
		if(isdefined( self.eye_fx ))
		{
			stopfx( localClientNum, self.eye_fx );
			self.eye_fx = undefined;
		}
	}
}

function robot_window_break( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		level thread scene::play( "robot_window_break_start", "targetname" ); //p7_fxanim_cp_sgen_robot_glass_break
	}
}

function debris_bridge( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		level thread scene::play( "p7_fxanim_cp_sgen_silo_debris_bridge_bundle" ); //p7_fxanim_cp_sgen_silo_debris_bridge_bundle
	}
}


function debris_wall( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		level thread scene::play( "p7_fxanim_cp_sgen_silo_debris_wall_bundle" ); //p7_fxanim_cp_sgen_silo_debris_wall_bundle
	}
}

function stop_exterior_fxanims()
{
	//give time for the autorun in fxanims to play so we can stop
	wait 1;
	
	//tents
	if ( level scene::is_active( "p7_fxanim_gp_tent_yellow_military_modular_dmg_end_side_dbl_bundle" ) )
	{
		level scene::stop( "p7_fxanim_gp_tent_yellow_military_modular_dmg_end_side_dbl_bundle", true );
	}
	
	if ( level scene::is_active( "p7_fxanim_gp_tent_yellow_military_modular_dmg_end_r_bundle" ) )
	{		
		level scene::stop( "p7_fxanim_gp_tent_yellow_military_modular_dmg_end_r_bundle", true );
	}

	if ( level scene::is_active( "p7_fxanim_gp_tent_yellow_military_modular_dmg_end_r_dbl_bundle" ) )
	{		
		level scene::stop( "p7_fxanim_gp_tent_yellow_military_modular_dmg_end_r_dbl_bundle", true );
	}

	if ( level scene::is_active( "p7_fxanim_gp_tent_yellow_military_modular_dmg_end_l_bundle" ) )
	{		
		level scene::stop( "p7_fxanim_gp_tent_yellow_military_modular_dmg_end_l_bundle", true );
	}

	if ( level scene::is_active( "p7_fxanim_gp_tent_yellow_military_modular_dmg_end_l_dbl_bundle" ) )
	{
		level scene::stop( "p7_fxanim_gp_tent_yellow_military_modular_dmg_end_l_dbl_bundle", true );
	}		
	
	//white tent
	if ( level scene::is_active( "p7_fxanim_gp_tent_white_military_modular_dmg_end_l_dbl_bundle" ) )
	{
		level scene::stop( "p7_fxanim_gp_tent_white_military_modular_dmg_end_l_dbl_bundle", true ); 
	}

	if ( level scene::is_active( "p7_fxanim_gp_tent_white_military_modular_dmg_end_r_dbl_bundle" ) )
	{
		level scene::stop( "p7_fxanim_gp_tent_white_military_modular_dmg_end_r_dbl_bundle", true ); 
	}
	
	if ( level scene::is_active( "p7_fxanim_gp_tent_white_military_modular_dmg_end_l_bundle" ) )
	{
		level scene::stop( "p7_fxanim_gp_tent_white_military_modular_dmg_end_l_bundle", true ); 
	}	
	
	if ( level scene::is_active( "p7_fxanim_gp_tent_white_military_modular_dmg_end_r_bundle" ) )
	{
		level scene::stop( "p7_fxanim_gp_tent_white_military_modular_dmg_end_r_bundle", true ); 
	}	

	//bouys
	if ( level scene::is_active( "p7_fxanim_gp_floating_water_container_plastic_small_red_upright_bundle" ) )
	{		
		level scene::stop( "p7_fxanim_gp_floating_water_container_plastic_small_red_upright_bundle", true );
	}			

	if ( level scene::is_active( "p7_fxanim_gp_floating_water_container_plastic_small_blue_upright_bundle" ) )
	{		
		level scene::stop( "p7_fxanim_gp_floating_water_container_plastic_small_blue_upright_bundle", true );
	}			
	
	//ravens
	if ( level scene::is_active( "p7_fxanim_gp_raven_circle_ccw_01_bundle" ) )
	{		
		level scene::stop( "p7_fxanim_gp_raven_circle_ccw_01_bundle", true );
	}				
}

function debris_fall( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		level thread scene::play( "p7_fxanim_cp_sgen_silo_debris_fall_bundle" ); //p7_fxanim_cp_sgen_silo_debris_fall_bundle
	}
}

function debris_catwalk( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		level thread scene::play( "p7_fxanim_cp_sgen_silo_debris_catwalk_bundle" ); //p7_fxanim_cp_sgen_silo_debris_catwalk_bundle
	}
}

function truck_flip( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		level thread scene::play( "truck_flip", "targetname" );
	}
}

function set_structural_weakness( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self duplicate_render::set_item_enemy_equipment( newVal );
}



function silo_swim_bridge_fall( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		level thread scene::play( "bridge_collapse", "targetname");
	}
}

//	Turn on extracam on the drone
function set_drone_cam( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal == 1 )
	{
		v_offset = AnglesToForward( self.angles ) * 10;	// place camera in front of the drone
		v_origin = self.origin + v_offset;
		self.e_xcam_ent = Spawn( localClientNum, v_origin, "script_origin" );
		self.e_xcam_ent.angles = self.angles + (0, 0, -90);
		self.e_xcam_ent LinkTo( self, "tag_origin" );
		
		self.e_xcam_ent SetExtraCam( 0 );
		playsound( 0, "uin_pip_open", (0,0,0) );
	}
	else if ( newVal == 2 )
	{
		v_offset = AnglesToForward( self.angles ) * 10;	// place camera in front of the drone
		v_origin = self.origin + v_offset;
		self.e_xcam_ent = Spawn( localClientNum, v_origin, "script_origin" );
		self.e_xcam_ent.angles = self.angles;
		self.e_xcam_ent LinkTo( self, "tag_origin" );
		
		self.e_xcam_ent SetExtraCam( 0 );
		playsound( 0, "uin_pip_open", (0,0,0) );		
	}
	else
	{
		if ( isdefined( self.e_xcam_ent ) )
		{
			playsound( 0, "uin_pip_close", (0,0,0) );
			self.e_xcam_ent Delete();
		}
	}
}



function reduce_oed( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal == 1)
	{
		SetDvar( "r_thermalRange",			750 );	//TODO This needs to be replaced by an API call
		SetDvar( "r_thermalLineRange",		500 );	//TODO This needs to be replaced by an API call
		SetDvar( "r_thermalTargetRange",	250 );	//TODO This needs to be replaced by an API call
	}
	else
	{
		SetDvar( "r_thermalRange",			1500 );	//TODO This needs to be replaced by an API call
		SetDvar( "r_thermalLineRange",		1000 );	//TODO This needs to be replaced by an API call
		SetDvar( "r_thermalTargetRange",	2000 );	//TODO This needs to be replaced by an API call
		
	}
}

function futz_interference( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal > 0 )
	{
		filter::enable_filter_ev_interference( self, 1 );
		filter::set_filter_ev_interference_amount( self, 1, newVal );
	}
	else
	{
		filter::disable_filter_ev_interference( self, 1 );
	}
}

function oed_interference( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		self.n_oed_futz_increment = .016 / 4;
		self._remove_oed_futz = false;
	}
	else
	{
		self.n_oed_futz_increment = -1 * ( .016 / 3 );
		self._remove_oed_futz = true;
	}

	self thread oed_futz_think();
}
	

//
//	Handle interference on the OED
//		Once interference is on, we'll slowly increment or decrement until we're
//	fully interfered or not.
function oed_futz_think( b_interference )
{
	self endon( "death" );
	
	self notify( "oed_futz_think_end" );	// kill previous threads
	
	self endon( "oed_futz_think_end" );

	//TODO Figure out why these variables get erased after being set in the on spawn function
	//	OR are we spawning a new player entity without triggering the callback?
	if ( !isdefined( self.n_oed_futz ) )
	{
		self.n_oed_futz = 0.0;
	}
	if ( !isdefined( self.b_oed_futz_filter_on ) )
	{
		self.b_oed_futz_filter_on = false;
	}
	if ( !isdefined( self.n_oed_futz_increment ) )
	{
		self.n_oed_futz_increment = 0.0;
	}
	if ( !isdefined( self.b_ev_active ) )
	{
		self.b_ev_active = false;
	}

	//TODO Figure out why the player can become removed at the start of the level.  Could be related to the above variable
	//		issue.  Is the initial player getting destroyed and then reconstructed without triggerring the callback?
	while ( isdefined( self ) )
	{
		self.n_oed_futz += self.n_oed_futz_increment;
		if (self.n_oed_futz < 0.0) {     self.n_oed_futz = 0.0;    }    else if (self.n_oed_futz > 1.0) {     self.n_oed_futz = 1.0;    };

		// No futz on normal vision OR if there is no futz currently
		if ( ( !self.b_ev_active || self.n_oed_futz == 0.0 ) && !self._remove_oed_futz )
		{
			// Turn off futz
			if ( self.b_oed_futz_filter_on )
			{
				self.b_oed_futz_filter_on = false;
				filter::disable_filter_ev_interference( self, 0 );
			}
		}
		else if ( self.n_oed_futz > 0.0 )
		{
			// Turn on Futz if it isn't on already
			if ( !self.b_oed_futz_filter_on )
			{
				self.b_oed_futz_filter_on = true;
				filter::enable_filter_ev_interference( self, 0 );
			}
			
			// Tune filter			
			if ( self.b_oed_futz_filter_on )
			{
				//	If EV is not on, only halve the interference
				filter::set_filter_ev_interference_amount( self, 0, self.n_oed_futz );
				
				// OED Range is inversely proportionate to the interference
				n_range			= 150 		+ ( (1-self.n_oed_futz) * ( 1500 - 150 ) );
				n_line_range	= 100	+ ( (1-self.n_oed_futz) * ( 1000 - 100 ) );
				n_target_range	= 50	+ ( (1-self.n_oed_futz) * ( 2500 - 50 ) );
				SetDvar( "r_thermalRange",			n_range );			//TODO This needs to be replaced by an API call
				SetDvar( "r_thermalLineRange",		n_line_range );		//TODO This needs to be replaced by an API call
				SetDvar( "r_thermalTargetRange",	n_target_range );	//TODO This needs to be replaced by an API call
			}
		}
		wait .016;
	}

}


function set_elevator_extracam( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	e_local_player = GetLocalPlayer( localClientNum );	
	
	if( newVal == 2 )
	{
		if( isdefined( e_local_player.a_e_monitors ) )
		{
			for(i = 0; i < e_local_player.a_e_monitors.size; i++ )
			{
				e_local_player.a_e_monitors[i] delete();
			}
		}
		
		return;
	}
	
	level thread toggle_pallas_monitors( localClientNum, false );//Turn off main area monitors
	if ( !isdefined( e_local_player.a_e_monitors ) )
	{
		s_boss_extracam = struct::get( "doppelganger_extracam", "targetname" );
		
		e_local_player.e_extracam = Spawn( localClientNum, s_boss_extracam.origin, "script_origin" );
		e_local_player.e_extracam.angles = s_boss_extracam.angles;
		
		e_local_player.a_e_monitors = [];

		a_s_monitors = struct::get_array( "boss_fight_monitor" );

		foreach ( s_monitor in a_s_monitors )
		{
			e_monitor = util::spawn_model( localClientNum, "p7_monitor_server_room_extra_cam_01", s_monitor.origin, s_monitor.angles );
			e_monitor LinkTo( self );
			SetExtraCamEntity( localClientNum, e_monitor );
			if ( !isdefined( e_local_player.a_e_monitors ) ) e_local_player.a_e_monitors = []; else if ( !IsArray( e_local_player.a_e_monitors ) ) e_local_player.a_e_monitors = array( e_local_player.a_e_monitors ); e_local_player.a_e_monitors[e_local_player.a_e_monitors.size]=e_monitor;;
		}
	}
	
	e_local_player.e_extracam SetExtraCam( 0 );
}

function pallas_fight_monitoring( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon( "pallas_fight_over" );
	self endon( "death" );
	
	if( !isdefined( self.e_extracam ) )
	{
		s_boss_extracam = struct::get( "doppelganger_extracam", "targetname" );
		self.e_extracam = Spawn( localClientNum, s_boss_extracam.origin, "script_origin" );
		self.e_extracam.angles = s_boss_extracam.angles;
		self.e_extracam SetExtraCam( 0 );
	}
	
	if( newVal == 2 )
	{
		self.e_extracam Delete();
		
		if ( isdefined( self._pallas_monitors ) )
		{
			for(i = 0; i < self._pallas_monitors.size; i++ )
			{
				self._pallas_monitors[i] Delete();
			}
		}
		
		self notify ( "pallas_fight_over" );
		return;
	}
	
	level thread toggle_pallas_monitors( localClientNum, true );
	
//	self._pallas_monitors = GetEntArray( localClientNum, "pallas_xcam_model", "targetname" );
//
//	while( true )//TODO - we need to evaluate what look we want. All monitors on or only the ones around the player. Testing currently with all
//	{
//		if( isdefined( self ) && isdefined( self._pallas_monitors ) )//HACK - fix until code can look into why a hot joining player is undefined
//		{
//			for( i = 0; i < self._pallas_monitors.size; i ++ )
//			{
//				if( DistanceSquared( self.origin, self._pallas_monitors[i] .origin ) < MONITOR_DISPLAY_DISTANCE * MONITOR_DISPLAY_DISTANCE ) 
//				{
//					self._pallas_monitors[i] Show();
//				}
//				else
//				{
//					self._pallas_monitors[i] Hide();
//				}
//			}
//		}		
//		wait 0.1;	
//	}	
}

function toggle_pallas_monitors( localClientNum, b_power = false )
{
	a_pallas_monitors = GetEntArray( localClientNum, "pallas_xcam_model", "targetname" );
	foreach( e_monitor in a_pallas_monitors )
	{
		if( b_power )
		{
			e_monitor Show();
		}
		else
		{
			e_monitor Hide();
		}
	}
}

function water_sheeting_toggle( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		StartWaterSheetingFX( localClientNum, 0 );
	}
	else
	{
		StopWaterSheetingFX( localClientNum, 1 );
	}
}

function underwater_state_toggle( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		SetDvar( "phys_buoyancy", 1 );
		SetDvar( "phys_ragdoll_buoyancy", 1 );
		
		SetDvar( "player_useWaterFriction", 0 );
	}
	else
	{
		SetDvar( "phys_buoyancy", 0 );
		SetDvar( "phys_ragdoll_buoyancy", 0 );
		
		SetDvar( "player_useWaterFriction", 1 );
	}
}

function flood_combat_windows_b( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		level thread scene::play( "window_lt_01_start", "targetname" ); // p7_fxanim_cp_sgen_surgical_room_window_lt_01_bundle
	}
}

function flood_combat_windows_c( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		level thread scene::play( "window_rt_02_start", "targetname" ); //p7_fxanim_cp_sgen_surgical_room_window_rt_02_bundle
	}
}

function link_elevator_light_probe( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	a_lights = getentarray( localClientNum, "pallas_elevator_probe", "targetname" );
	a_probes = getentarray( localClientNum, "pallas_elevator_light", "targetname" );
	
	e_lift = GetEnt( localClientNum,  "boss_fight_lift", "targetname" );
	
	foreach( light in a_lights )
	{
		light linkto( e_lift );
	}

	foreach( probe in a_probes )
	{
		probe linkto( e_lift );
	}		
}

function flood_defend_hallway_flood_siege( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal )
	{
		level scene::play( "p7_fxanim_cp_sgen_water_hallway_flood_bundle" );
	}
}

function set_elevator_shader( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( !IsDefined( self.c_elevator_model ) )
	{
		self.c_elevator_model = GetEnt( localClientNum, "boss_fight_lift", "targetname" );
		self.c_elevator_model LinkTo( self );
	}

	switch ( newVal )
	{
		case 3:
		{
			self.c_elevator_model Show();
		} break;
		case 2:
		{
			self.c_elevator_model Hide();
		} break;
		case 1:
		{
			for ( i = 0; i < 2.0; i += 0.01 )
			{
				self.c_elevator_model MapShaderConstant( 0, 0, "scriptVector0", i / 2.0, 0, 0, 0 );
				wait 0.01;
			}
		} break;
		case 0:
		{		
			for ( i = 3.0; i > 0.0; i -= 0.01 )
			{
				self.c_elevator_model MapShaderConstant( 0, 0, "scriptVector0", i / 3.0, 0, 0, 0 );
				wait 0.01;
			}
	
			self.c_elevator_model Hide();
		} break;
	}
}

function set_elevator_door_state( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	switch ( newVal )
	{
		case 2:
		{
			self.c_elevator_door = GetEnt( localClientNum, "pallas_lift_back", "targetname" );
			self.c_elevator_door LinkTo( self );
		} break;
		case 1:
		{
			self.c_elevator_door = GetEnt( localClientNum, "pallas_lift_front", "targetname" );
			self.c_elevator_door LinkTo( self );
		} break;
	}
}

function observation_deck_destroy( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if(!isdefined(level.n_observation_deck_stage))level.n_observation_deck_stage=0;
	
	level.n_observation_deck_stage++;
	if( level.n_observation_deck_stage > 3 )
	{
		return;//Only three stages right now	
	}
	level scene::play( "p7_fxanim_cp_sgen_observation_deck_break_0" + level.n_observation_deck_stage + "_bundle" );
}

function tower_chunks1( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	level scene::play( "server_tower_chunks_01", "targetname" );
}

function tower_chunks2( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	level scene::play( "server_tower_chunks_02", "targetname" );
}

function tower_chunks3( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	level scene::play( "server_tower_chunks_03", "targetname" );
}

function play_robot_eye_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	str_tag = ( ( self.model === "tag_origin" ) ? "tag_origin" : "tag_eye" );

	PlayFxOnTag( localClientNum, level._effect[ "fx_glow_robot_control_gen_1_head" ], self, str_tag );	
}

function sndSiloBG( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal == 1 )
	{
		self thread sndSiloBGThink("amb_descent_bg_top","amb_descent_bg_mid","amb_descent_bg_bot");
	}
	else
	{
		level notify( "stopSiloBGend" );
	}
}
function sndSiloBGThink(arg1,arg2,arg3)
{	
	level endon( "stopSiloBGend" );
	
	startOrigin = (42,226,128);
	endOrigin = (203,865,-2671);
	distBetween = abs(startOrigin[2]-endOrigin[2]);
	
	if( !isdefined( arg1 ) && !isdefined( arg2 ) )
		return;
	
	point1 = startOrigin[2];
	point2 = endOrigin[2];
	
	if( isdefined( arg3 ) )
	{
		point1 = startOrigin;
		point2 = ( (startOrigin[0]+endOrigin[0])/2, (startOrigin[1]+endOrigin[1])/2, (startOrigin[2]+endOrigin[2])/2 );
		point3 = endOrigin;
	}
	
	sndEnt1 = spawn(0,startOrigin,"script_origin");
	sndEnt1 playloopsound( arg1, .5 );
	sndEnt1 setloopstate(arg1, 1, 1);
	
	sndEnt2 = spawn(0,startOrigin,"script_origin");
	sndEnt2 playloopsound( arg2, .5 );
	sndEnt2 setloopstate(arg2, 0, 1);
	sndEnt2 linkto( sndEnt1 );
	
	if( isdefined( arg3 ) )
	{
		sndEnt3 = spawn(0,startOrigin,"script_origin");
		sndEnt3 playloopsound( arg3, .5 );
		sndEnt3 setloopstate(arg3, 0, 1);
		sndEnt3 linkto( sndEnt1 );
	}
	
	level thread sndDeleteEnts(sndEnt1,sndEnt2,sndEnt3);
	
	wait(.5);
	if( !isdefined( self ) )
		return;
	
	while(isdefined(self))
	{
		zPoint = self.origin[2];
		zDistance1 = abs(point1[2]-zPoint);
		zDistance2 = abs(point2[2]-zPoint);
		if( isdefined( arg3 ) )
		{
			zDistance3 = abs(point3[2]-zPoint);
		}
		
		volume1 = audio::scale_speed( 0, abs(point1[2]-point2[2]), 0, 1, zDistance1 );
		volume1 = abs(1-volume1);
		sndEnt1 setloopstate(arg1, volume1, 1);
		
		volume2 = audio::scale_speed( 0, abs(point1[2]-point2[2]), 0, 1, zDistance2 );
		volume2 = abs(1-volume2);
		sndEnt2 setloopstate(arg2, volume2, 1);
		
		if( isdefined( arg3 ) )
		{
			volume3 = audio::scale_speed( 0, abs(point2[2]-point3[2]), 0, 1, zDistance3 );
			volume3 = abs(1-volume3);
			sndEnt3 setloopstate(arg3, volume3, 1);
		}
		
		percentage = zDistance1/distBetween;
		axis1 = ((endOrigin[0]-startOrigin[0])*percentage)+startOrigin[0];
		axis2 = ((endOrigin[1]-startOrigin[1])*percentage)+startOrigin[1];
		axis3 = zPoint;
		
		if( zPoint >= startOrigin[2] )
		{
			axis1 = startOrigin[0];
			axis2 = startOrigin[1];
			axis3 = startOrigin[2];
		}
		
		if( zPoint <= endOrigin[2] )
		{
			axis1 = endOrigin[0];
			axis2 = endOrigin[1];
			axis3 = endOrigin[2];
		}
		
		sndEnt1 moveto( (axis1,axis2,axis3), .2 );
		
		wait(.2);
	}
	
	level notify( "stopSiloBGend" );
}
function sndDeleteEnts(ent1,ent2,ent3)
{
	level waittill( "stopSiloBGend" );
	ent1 delete();
	ent2 delete();
	ent3 delete();
}
function sndSgenUW(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	//Using material override so every footstep actually hits
	if( newVal == 1 )
	{
		self SetMaterialOverride("tallgrass");
	}
	else
	{
		self ClearMaterialOverride();
	}
}

// self == player
function dust_motes( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	wait .1;//HACK - remove once loadout is fixed
	
	if ( newVal )
	{
		self.n_fx_id = PlayViewmodelFX( localClientNum, level._effect[ "dust_motes" ], "tag_camera" );
	}
	else
	{		
		if ( isdefined( self.n_fx_id ) )
		{
			DeleteFx( localClientNum, self.n_fx_id, true );
		}
	}
}

// self = player
function water_teleport_transition( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		self.n_fx_id = PlayViewmodelFX( localClientNum, level._effect[ "water_teleport" ], "tag_camera" );
	}
	else
	{		
		if ( isdefined( self.n_fx_id ) )
		{
			DeleteFx( localClientNum, self.n_fx_id, true );
		}
	}
}

//self == player
function silo_debris( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump  )
{
	if(!isdefined(level.n_silo_debris))level.n_silo_debris=0;
	
	level.n_silo_debris++;
	
	if ( level.n_silo_debris < 6 )
	{
		level scene::play( "p7_fxanim_cp_sgen_underwater_silo_debris_0" + level.n_silo_debris + "_bundle" );
	}
	else
	{
		for ( x = 0; x < 6; x++ )
		{
			level scene::stop( "p7_fxanim_cp_sgen_underwater_silo_debris_0" + x + "_bundle" );
		}
	}
}

function force_streamer( n_zone )
{
	switch ( n_zone )
	{
		case 1:
		{
			ForceStreamBundle( "cin_sgen_01_intro_3rd_pre100_flyover" );
			ForceStreamBundle( "cin_sgen_01_intro_3rd_pre200_overlook_sh010" );
			ForceStreamBundle( "cin_sgen_01_intro_3rd_pre200_overlook_sh020" );
			ForceStreamBundle( "cin_sgen_01_intro_3rd_pre200_overlook_sh030" );
			ForceStreamBundle( "cin_sgen_01_intro_3rd_pre200_overlook_sh040" );
			ForceStreamBundle( "cin_sgen_01_intro_3rd_pre200_overlook_sh050" );
			ForceStreamBundle( "cin_sgen_01_intro_3rd_pre200_overlook_sh060" );
		} break;
		case 2:
		{
			ForceStreamBundle( "cin_sgen_14_humanlab_3rd_sh010" );
			ForceStreamBundle( "cin_sgen_14_humanlab_3rd_sh020" );
			ForceStreamBundle( "cin_sgen_14_humanlab_3rd_sh030" );
			ForceStreamBundle( "cin_sgen_14_humanlab_3rd_sh040" );
			ForceStreamBundle( "cin_sgen_14_humanlab_3rd_sh050" );
			ForceStreamBundle( "cin_sgen_14_humanlab_3rd_sh060" );
			ForceStreamBundle( "cin_sgen_14_humanlab_3rd_sh070" );
			ForceStreamBundle( "cin_sgen_14_humanlab_3rd_sh080" );
			ForceStreamBundle( "cin_sgen_14_humanlab_3rd_sh090" );
			ForceStreamBundle( "cin_sgen_14_humanlab_3rd_sh020" );
		} break;
		case 3:
		{
			ForceStreamBundle( "cin_sgen_19_ghost_3rd_sh010" );
			ForceStreamBundle( "cin_sgen_19_ghost_3rd_sh020" );
			ForceStreamBundle( "cin_sgen_19_ghost_3rd_sh030" );
			ForceStreamBundle( "cin_sgen_19_ghost_3rd_sh040" );
			ForceStreamBundle( "cin_sgen_19_ghost_3rd_sh050" );
			ForceStreamBundle( "cin_sgen_19_ghost_3rd_sh060" );
			ForceStreamBundle( "cin_sgen_19_ghost_3rd_sh070" );
			ForceStreamBundle( "cin_sgen_19_ghost_3rd_sh080" );
			ForceStreamBundle( "cin_sgen_19_ghost_3rd_sh090" );
			ForceStreamBundle( "p7_fxanim_cp_sgen_pallas_ai_tower_collapse_bundle" );
		} break;
		case 4:
		{
			ForceStreamBundle( "cin_sgen_20_twinrevenge_3rd_sh010" );
			ForceStreamBundle( "cin_sgen_20_twinrevenge_3rd_sh020" );
			ForceStreamBundle( "cin_sgen_20_twinrevenge_3rd_sh030" );
			ForceStreamBundle( "cin_sgen_20_twinrevenge_3rd_sh040" );
			ForceStreamBundle( "cin_sgen_20_twinrevenge_3rd_sh050" );
			ForceStreamBundle( "cin_sgen_20_twinrevenge_3rd_sh060" );
			ForceStreamBundle( "cin_sgen_20_twinrevenge_3rd_sh070" );
		} break;
		case 5:
		{
			ForceStreamBundle( "cin_sgen_26_01_lobbyexit_1st_escape_outro" );
			ForceStreamBundle( "p7_fxanim_cp_sgen_end_building_collapse_debris_bundle" );
		} break;
	}
}

//self = player
function mappy_path( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	SetDvar( "r_eacPathFX_enable", newVal );
	if( newVal )
	{
		if( !isdefined( level.tmode_override ) )
		{
			level.tmode_override = &mappy_override;
		}
		if( !isdefined( level.ev_override ) )
		{
			level.ev_override = &mappy_override;
		}		
		self thread mappy_path_manager( localClientNum );
	}
	else
	{
		level.tmode_override = undefined;
		self notify( "kill_mappy_path" );
		self duplicate_render::change_dr_flags( undefined, "path_active" );
	}	
}

//self = player
function mappy_path_manager( localClientNum )
{
	self notify( "kill_mappy_path" );	
	self endon( "kill_mappy_path" );
	
	if(!isdefined(level.a_mappy_paths))level.a_mappy_paths=[];
	
	self.mappy_path_active = false;
	array::add( level.a_mappy_paths, self );
	
	while( true )
	{
		if( !level flag::get( "activate_tmode" ) && !level flag::get( "activate_thermal" ) && !self.mappy_path_active )
		{
			self.mappy_path_active = true;
			self duplicate_render::change_dr_flags( "path_active", undefined );
			self AddDuplicateRenderOption( 0, 0 );
		}
		
		{wait(.016);};
	}
}

function mappy_override()
{
	foreach( e_path in level.a_mappy_paths )
	{
		e_path.mappy_path_active = false;
		e_path duplicate_render::change_dr_flags( undefined, "path_active" );		
	}
	{wait(.016);};//Give render mgr time to disable
}

function weakpoint( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = scriptmover
{
	if ( newVal )
	{
		self duplicate_render::change_dr_flags( "weakpoint_keyline_show_z", "weakpoint_keyline_hide_z" );	 // param 1 = set, param 2 = clear
		self weakpoint_enable( 2 );
	}
	else
	{
		self duplicate_render::change_dr_flags( "weakpoint_keyline_hide_z", "weakpoint_keyline_show_z" );  // param 1 = set, param 2 = clear
		self weakpoint_enable( false );
	}
}

function fallen_soldiers_client_fxanims( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		level scene::play( "p7_fxanim_gp_wire_sparking_xsml_bundle" );
	}
}

function intro_flyover_client_fxanims( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		level scene::play( "p7_fxanim_gp_floating_buoy_02_upright_bundle" );
	}
	else
	{
		level scene::stop( "p7_fxanim_gp_floating_buoy_02_upright_bundle" );
	}
}

function sndStepSet(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump) 
{
	if( newVal )
	{
		match = "fly_water_wade";
		triggers = GetEntArray(0, "audio_step_trigger", "targetname" );
		foreach( trig in triggers )
		{	
			if( trig.script_label == match )
			{
				self thread sndStepSetThreaded( trig, match );
				return;	
			}
		}
	}
}
function sndStepSetThreaded(trigger,alias)
{
	self endon( "death" );
	self endon( "entityshutdown" );
	
	self.stepSet = false;
	
	while(1)
	{
		if( self istouching( trigger ) )
		{
			if( !self.stepSet )
			{
				self.stepSet = true;
				self SetStepTriggerSound(alias + "_npc");
			}
		}
		else if( self.stepSet )
		{
			self.stepSet = false;
			self ClearStepTriggerSound();
		}
		wait(.1);
	}
}

function set_depth_charge_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump ) 
{
	if ( isdefined( self.light_fx ) )
	{
		StopFx( localClientNum, self.light_fx );
		self.light_fx = undefined;
	}

	switch ( newVal )
	{
		case 0:
			self.light_fx = PlayFxOnTag( localClientNum, level._effect[ "yellow_light" ], self, "tag_origin" );
			break;
		case 1:
			self.light_fx = PlayFxOnTag( localClientNum, level._effect[ "green_light" ], self, "tag_origin" );
			break;
	}
}

function twin_igc_client_fxanims( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	switch ( newVal )
	{
		case 1:
			level thread scene::play( "p7_fxanim_cp_sgen_silo_twins_revenge_flood_bldg_01_bundle" );
			break;
		case 2:
			level thread scene::play( "p7_fxanim_cp_sgen_silo_twins_revenge_flood_bldg_02_bundle" );
			break;
		case 3:
			level thread scene::play( "p7_fxanim_cp_sgen_silo_twins_revenge_flood_bldg_03_bundle" );
			break;
	}
}

//self = mapper drone
function path_loop( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self notify( "kill_path_loop" );
	self endon( "kill_path_loop" );
	self endon( "death" );

	if( newVal )
	{
		while( true )
		{
			self EACPathSet( self.origin );
			{wait(.016);};
		}
	}
}

// ----------------------------------------------------------------------------
// callback_pstfx_frost_up
// ----------------------------------------------------------------------------
function callback_pstfx_frost_up( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{	
	player = GetLocalPlayer( localClientNum );
	
	if( !isdefined( player.pstfx_frost ) )
	{
		player.pstfx_frost = 0;
	}
	
	if( player.pstfx_frost == 0 )
	{
		player.pstfx_frost = 1;
		player postfx::PlayPostfxBundle( "pstfx_frost_up" );
		player postfx::PlayPostfxBundle( "pstfx_frost_loop" );
	}
}

// ----------------------------------------------------------------------------
// callback_pstfx_frost_down
// ----------------------------------------------------------------------------
function callback_pstfx_frost_down( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{	
	player = GetLocalPlayer( localClientNum );
	
	if ( ( player.pstfx_frost === 1 ) )
	{
		player.pstfx_frost = 0;
		player postfx::PlayPostfxBundle( "pstfx_frost_down" );	
	}
}
