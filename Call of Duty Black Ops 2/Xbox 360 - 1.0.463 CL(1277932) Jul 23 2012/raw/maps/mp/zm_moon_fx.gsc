#include common_scripts\utility;
#include maps\mp\_utility;

main()
{
	precache_createfx_fx(); 
	maps\mp\createfx\zm_moon_fx::main();
	maps\mp\createart\zm_moon_art::main();
	precache_scripted_fx();
	footsteps();
}

footsteps()
{

}

precache_scripted_fx()
{
	level._effect["large_ceiling_dust"]		    = loadFx("env/zombie/fx_dust_ceiling_impact_lg_mdbrown" );
	level._effect["poltergeist"]			        = loadFx("misc/fx_zombie_couch_effect" );
	level._effect["gasfire"] 				          = loadFx("destructibles/fx_dest_fire_vert");
	level._effect["switch_sparks"]		      	= loadfx("env/electrical/fx_elec_wire_spark_burst");
	level._effect["wire_sparks_oneshot"]      = loadfx("electrical/fx_elec_wire_spark_dl_oneshot");
	
	// rise fx
	level._effect["rise_burst"]		            = loadFx("maps/zombie/fx_mp_zombie_hand_dirt_burst");
	level._effect["rise_billow"]	            = loadFx("maps/zombie/fx_mp_zombie_body_dirt_billowing");	
	level._effect["rise_dust"]		            = loadFx("maps/zombie/fx_mp_zombie_body_dust_falling");
	
	//fx for airlocks
	level._effect["airlock_fx"]                  = loadfx("maps/zombie_moon/fx_moon_airlock_door_forcefield");

	// LOW G Rise FX
	level._effect["rise_billow_lg"]	            = loadFx("maps/zombie_moon/fx_moon_body_dirt_billowing");
	level._effect["rise_dust_lg"] 						= loadfx("maps/zombie_moon/fx_moon_body_dust_falling");
	level._effect["rise_burst_lg"]		           = loadFx("maps/zombie_moon/fx_moon_hand_dirt_burst");
		
	
	level._effect["lght_marker"]              = loadfx("maps/zombie/fx_zombie_coast_marker");

	level._effect["betty_explode"]			      = loadfx("weapon/bouncing_betty/fx_explosion_betty_generic");
	level._effect["betty_trail"]			      	= loadfx("weapon/bouncing_betty/fx_betty_trail");

//	level._effect["electric_current"]       	= loadfx("misc/fx_zombie_elec_trail");
	level._effect["zapper_fx"] 			          = loadfx("maps/zombie/fx_zombie_zapper_powerbox_on");	
	level._effect["zapper"]				            = loadfx("maps/zombie/fx_zombie_electric_trap");
	level._effect["zapper_wall"] 	          	= loadfx("maps/zombie/fx_zombie_zapper_wall_control_on");

	level._effect["zapper_light_ready"]       = loadfx("maps/zombie/fx_zombie_zapper_light_green");
	level._effect["zapper_light_notready"]    = loadfx("maps/zombie/fx_zombie_zapper_light_red");
	level._effect["terminal_ready"]           = loadfx("maps/zombie_moon/fx_moon_trap_switch_light_on_green");
	
	level._effect["elec_room_on"] 		        = loadfx("maps/zombie/fx_zombie_light_elec_room_on");
	level._effect["elec_md"] 			            = loadfx("electrical/fx_elec_player_md");
	level._effect["elec_sm"] 			            = loadfx("electrical/fx_elec_player_sm");
	level._effect["elec_torso"] 	          	= loadfx("electrical/fx_elec_player_torso");

	level._effect["elec_trail_one_shot"]      = loadfx("maps/zombie/fx_zombie_elec_trail_oneshot");

//	level._effect["pad_bottom"]               = loadfx("maps/zombie/fx_transporter_pad_start");
//	level._effect["pad_top"]                  = loadfx("maps/zombie/fx_transporter_start");
//	level._effect["beam"]                     = loadfx("maps/zombie/fx_transporter_beam");
	
	level._effect["lght_marker_flare"]        = Loadfx("maps/zombie/fx_zombie_coast_marker_fl");
	
	// TRAP: Fire
	//level._effect["fire_trap_med"]                        = Loadfx("maps/zombie/fx_zombie_fire_trap_med");
	
	//Quad Vent Exploders	- bottom floor -1001,1002,1003,1004
	level._effect["fx_quad_vent_break"]          					= LoadFX("maps/zombie/fx_zombie_crawler_vent_break");			
	
	// quad fx
	level._effect["quad_grnd_dust_spwnr"]	                = loadfx("maps/zombie/fx_zombie_crawler_grnd_dust_spwnr");	
	
	
	level._effect["fx_weak_sauce_trail"]			       			= loadfx("maps/zombie_temple/fx_ztem_weak_sauce_trail");
	level._effect["soul_swap_trail"]					       			= loadfx("maps/zombie_moon/fx_moon_soul_swap");	   
	level._effect["vrill_glow"]														= LoadFX("maps/zombie_moon/fx_moon_vril_glow");

	level._effect["jump_pad_active"] 					     = loadfx("maps/zombie_moon/fx_moon_jump_pad_on");
	level._effect["jump_pad_jump"] 					       = loadfx("maps/zombie_moon/fx_moon_jump_pad_pulse");

	level._effect["quad_phasing"]							     = loadfx("maps/zombie_moon/fx_zombie_phasing");	

	// FX for blowing out windows
  level._effect["glass_impact"]                         = loadfx("maps/zombie_moon/fx_moon_break_window" );
	
	//digger stuff
	level._effect["digger_treadfx_fwd"] 									= loadfx("maps/zombie_moon/fx_digger_treadfx_fwd");
	level._effect["digger_treadfx_bkwd"] 									= loadfx("maps/zombie_moon/fx_digger_treadfx_rev");
	level._effect["exca_beam"]	                          = loadfx("maps/zombie_moon/fx_digger_light_beam");
  level._effect["exca_blink"]                           = loadfx("maps/zombie_moon/fx_beacon_light_red");
	level._effect["panel_on"]                             = loadfx("maps/zombie_moon/fx_moon_digger_panel_on");
	level._effect["panel_off"]                            = loadfx("maps/zombie_moon/fx_moon_digger_panel_off");
	
	//spinning lights.
	level._effect["test_spin_fx"] = LoadFX( "env/light/fx_light_warning");		
	
	level._effect["rocket_booster"]             = LoadFX( "maps/zombie_moon/fx_earth_destroy_rocket" );
	level._effect["blue_eyes"]                  = LoadFX( "maps/zombie/fx_zombie_eye_single_blue" );
	level._effect["osc_button_glow"]            = LoadFX( "maps/zombie_moon/fx_moon_button_console_glow");
}

//Ambient Effects
precache_createfx_fx()
{
	level._effect["fx_mp_fog_xsm_int"] 			            = Loadfx("maps/zombie_old/fx_mp_fog_xsm_int");
	level._effect["fx_moon_fog_spawn_closet"] 	        = Loadfx("maps/zombie_moon/fx_moon_fog_spawn_closet");	
	level._effect["fx_zmb_fog_thick_300x300"] 			    = Loadfx("maps/zombie/fx_zmb_fog_thick_300x300");	
	level._effect["fx_zmb_fog_thick_600x600"] 			    = Loadfx("maps/zombie/fx_zmb_fog_thick_600x600");	
	level._effect["fx_moon_fog_canyon"] 			          = Loadfx("maps/zombie_moon/fx_moon_fog_canyon");
	level._effect["fx_moon_vent_wall_mist"] 			      = Loadfx("maps/zombie_moon/fx_moon_vent_wall_mist");	
	level._effect["fx_dust_motes_blowing"] 			        = Loadfx("env/debris/fx_dust_motes_blowing");			
	level._effect["fx_zmb_coast_sparks_int_runner"] 	  = Loadfx("maps/zombie/fx_zmb_coast_sparks_int_runner");			
	level._effect["fx_moon_floodlight_narrow"] 			    = Loadfx("maps/zombie_moon/fx_moon_floodlight_narrow");		
	level._effect["fx_moon_floodlight_wide"] 	   		    = Loadfx("maps/zombie_moon/fx_moon_floodlight_wide");	
	level._effect["fx_moon_tube_light"] 	   		        = Loadfx("maps/zombie_moon/fx_moon_tube_light");
	level._effect["fx_moon_lamp_glow"] 			            = Loadfx("maps/zombie_moon/fx_moon_lamp_glow");
	level._effect["fx_moon_trap_switch_light_glow"] 		= Loadfx("maps/zombie_moon/fx_moon_trap_switch_light_glow");												
		
	level._effect["fx_moon_teleporter_beam"] 			      = Loadfx("maps/zombie_moon/fx_moon_teleporter_beam");	
	level._effect["fx_moon_teleporter_start"] 			    = Loadfx("maps/zombie_moon/fx_moon_teleporter_start");	
	level._effect["fx_moon_teleporter_pad_start"] 			= Loadfx("maps/zombie_moon/fx_moon_teleporter_pad_start");
	level._effect["fx_moon_teleporter2_beam"] 			    = Loadfx("maps/zombie_moon/fx_moon_teleporter2_beam");	
	level._effect["fx_moon_teleporter2_pad_start"] 			= Loadfx("maps/zombie_moon/fx_moon_teleporter2_pad_start");
	
	level._effect["fx_moon_pyramid_egg"] 	  	  	      = Loadfx("maps/zombie_moon/fx_moon_pyramid_egg");	
	level._effect["fx_moon_pyramid_drop"] 		  	      = Loadfx("maps/zombie_moon/fx_moon_pyramid_drop");
	level._effect["fx_moon_pyramid_opening"] 		  	    = Loadfx("maps/zombie_moon/fx_moon_pyramid_opening");					
	
	level._effect["fx_moon_ceiling_cave_dust"] 			    = Loadfx("maps/zombie_moon/fx_moon_ceiling_cave_dust");		
	level._effect["fx_moon_ceiling_cave_collapse"] 			= Loadfx("maps/zombie_moon/fx_moon_ceiling_cave_collapse");
	level._effect["fx_moon_digger_dig_dust"] 			      = Loadfx("maps/zombie_moon/fx_moon_digger_dig_dust");		
	level._effect["fx_moon_airlock_hatch_forcefield"] 	= Loadfx("maps/zombie_moon/fx_moon_airlock_hatch_forcefield");
	level._effect["fx_moon_biodome_ceiling_breach"] 	  = Loadfx("maps/zombie_moon/fx_moon_biodome_ceiling_breach");	
	level._effect["fx_moon_biodome_breach_dirt"] 	      = Loadfx("maps/zombie_moon/fx_moon_biodome_breach_dirt");
	
	level._effect["fx_moon_breach_debris_room_os"] 	    = Loadfx("maps/zombie_moon/fx_moon_breach_debris_room_os");	
	level._effect["fx_moon_breach_debris_out_os"] 	    = Loadfx("maps/zombie_moon/fx_moon_breach_debris_out_os");	
	
//	level._effect["fx_earth"] 	                        = Loadfx("maps/zombie_moon/fx_earth");	
	level._effect["fx_earth_destroyed"] 	              = Loadfx("maps/zombie_moon/fx_earth_destroyed");																
	
	
	// TRAP: Fire
//	level._effect["fire_trap_med"]                      = Loadfx("maps/zombie/fx_zombie_fire_trap_med");		
	
}
