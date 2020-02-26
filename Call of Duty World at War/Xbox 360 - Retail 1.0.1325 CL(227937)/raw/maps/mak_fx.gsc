#include maps\_utility; 
main()
{
	
	precacheFX(); 
	spawnFX(); 
	maps\createart\mak_art::main();
	footsteps(); 

	event1(); 
	event2();
	event4();
	event6();
	 	
// 	fog_settings(); 
// 	level thread vision_settings(); NOW HANDLED BY mak_art.gsc
 	wind_settings(); 
 	level thread water_settings(); 
 	view_settings(); 
}

footsteps()
{
	animscripts\utility::setFootstepEffect( "asphalt",    LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "brick",      LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "carpet",     LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "cloth",      LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "concrete",   LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "dirt",       LoadFx( "bio/player/fx_footstep_sand" ) );
	animscripts\utility::setFootstepEffect( "foliage",    LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "gravel",     LoadFx( "bio/player/fx_footstep_sand" ) );
	animscripts\utility::setFootstepEffect( "grass",      LoadFx( "bio/player/fx_footstep_sand" ) );
	animscripts\utility::setFootstepEffect( "ice",        LoadFx( "bio/player/fx_footstep_snow" ) );
	animscripts\utility::setFootstepEffect( "metal",      LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "mud",        LoadFx( "bio/player/fx_footstep_mud" ) );
	animscripts\utility::setFootstepEffect( "paper",      LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "plaster",    LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "rock",       LoadFx( "bio/player/fx_footstep_sand" ) );
	animscripts\utility::setFootstepEffect( "sand",       LoadFx( "bio/player/fx_footstep_sand" ) );
	animscripts\utility::setFootstepEffect( "snow",       LoadFx( "bio/player/fx_footstep_snow" ) );
	animscripts\utility::setFootstepEffect( "water",      LoadFx( "bio/player/fx_footstep_water" ) );
	animscripts\utility::setFootstepEffect( "wood",       LoadFx( "bio/player/fx_footstep_dust" ) );
}

view_settings()
{
  SetSavedDvar( "r_motionblur_enable", 1 ); 
  SetSavedDvar( "r_motionblur_positionFactor", 0.17 ); 
  SetSavedDvar( "r_motionblur_directionFactor", 0.17 ); 
}

//vision_settings() NOW HANDLED BY mak_art.gsc
//{
//	waittillframeend; 
////	VisionSetNaked( "mak", 0.1 ); 
//
//	set_all_players_visionset( "mak", 0.1 );
//}
//
//fog_settings()
//{
//	start_dist 		= 700;
//	halfway_dist 	= 2000;
//	halfway_height 	= 350;
//	base_height 	= 0;
//	red 			= 0.115;
//	green 			= 0.123;
//	blue		 	= 0.141;
//	trans_time		= 0;
//
//	if( IsSplitScreen() )
//	{
//		halfway_height 	= 10000;
//		cull_dist 		= 2000;
//		set_splitscreen_fog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time, cull_dist );
//	}
//	else
//	{
//		SetVolFog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time );
//	}
//}

// Global Wind Settings
wind_settings()
{
	// These values are supposed to be in inches per second.
	SetSavedDvar( "wind_global_vector", "162 59 7.5" ); // 71.69 inches per second or about 4mph
	SetSavedDvar( "wind_global_low_altitude", 19 ); 
	SetSavedDvar( "wind_global_hi_altitude", 561 ); 
	SetSavedDvar( "wind_global_low_strength_percent", 0.07 ); 

	// Add a while loop to vary the strength of the wind over time.
}

water_settings()
{
	/* Water Dvars				Default Values		What They Do
	 ====================================================================== 
	r_watersim_enabled			default = true		Enables dynamic water simulation
	r_watersim_debug			default = false		Enables bullet debug markers
	r_watersim_flatten			default = false		Flattens the water surface out
	r_watersim_waveSeedDelay	default = 500.0		Time between seeding a new wave( ms )
	r_watersim_curlAmount		default = 0.5		Amount of curl applied
	r_watersim_curlMax			default = 0.4		Maximum curl limit
	r_watersim_curlReduce		default = 0.95		Amount curl gets reduced by when over limit
	r_watersim_minShoreHeight	default = 0.04		Allows water to lap over the shoreline edge
	r_watersim_foamAppear		default = 20.0		Rate foam appears at
	r_watersim_foamDisappear	default = 0.78		Rate foam disappears at
	r_watersim_windAmount 		default = 0.02		Amount of wind applied
	r_watersim_windDir			default = 45.0		Wind direction( degrees )
	r_watersim_windMax			default = 0.4 		Maximum wind limit
	r_watersim_particleGravity	default = 0.03		Particle gravity
	r_watersim_particleLimit	default = 2.5		Limit at which particles get spawned
	r_watersim_particleLength	default = 0.03		Length of each particle
	r_watersim_particleWidth	default = 2.0		Width of each particle
	*/
	
	SetDvar( "r_watersim_curlAmount", 		1 ); 
	SetDvar( "r_watersim_curlMax", 			1 ); 
	SetDvar( "r_watersim_curlReduce", 		0.95 ); 
	SetDvar( "r_watersim_minShoreHeight", 	-3.2 ); 
	SetDvar( "r_watersim_waveSeedDelay", 	250.0 ); 
	SetDvar( "r_watersim_foamAppear", 		20 ); 
	SetDvar( "r_watersim_foamDisappear", 	0.775 ); 
	SetDvar( "r_watersim_windAmount", 		0.4 ); 
	SetDvar( "r_watersim_windMax", 			0.21 ); 
	SetDvar( "r_watersim_windDir", 			340.0 ); 
	waittillframeend; 
	WaterSimEnable( true ); 
}

event1()
{
	// Intro
	level._effect["cigarette"]				 = LoadFx( "maps/mak/fx_cigarette_smoke" ); 
	level._effect["cigarette_exhale"]		 = LoadFx( "maps/mak/fx_cigarette_smoke_exhale_puff" ); 
	level._effect["cigarette_glow"]			 = LoadFx( "maps/mak/fx_cigarette_glow" ); 
	level._effect["cigarette_glow_puff"]	 = LoadFx( "maps/mak/fx_cigarette_glow_puff" ); 
	level._effect["cigarette_glow_puff2"]	 = LoadFx( "maps/mak/fx_cigarette_glow_puff2" ); 
	level._effect["cigarette_embers"]		 = LoadFx( "maps/mak/fx_cigarette_embers_puff" ); 
	level._effect["blood_spray"]			 = LoadFx( "maps/mak/fx_blood_spray" ); 
	level._effect["blood_spurt"]			 = LoadFx( "maps/mak/fx_blood_spurt" ); 
	level._effect["blood_pool"]				 = LoadFx( "maps/mak/fx_blood_spill_floor" ); 
	level._effect["flash_light"]			 = LoadFx( "misc/fx_flashlight_beam" ); 
	level._effect["spit"]					 = LoadFx( "maps/mak/fx_spit_mist" ); 
	level._effect["beatstick_hit"]			 = LoadFx( "maps/mak/fx_blood_spray_small" ); 

	// Huts
	level._effect["hut1_explosion"] 		 = LoadFx( "maps/mak/fx_explosion_charge_large" ); 
	level._effect["hut2_explosion"] 		 = LoadFx( "maps/mak/fx_explosion_charge_med" ); 
	level._effect["hut3_explosion"] 		 = LoadFx( "maps/mak/fx_explosion_charge_xlarge" ); 
	level._effect["hut4_explosion"] 		 = LoadFx( "maps/mak/fx_explosion_charge_xlarge_main" ); 
	level._effect["hut4_smoke_trail"] 		 = LoadFX( "maps/mak/fx_sys_element_smoke_tail_med_emitter" ); 

	level._effect["corner_hut_explosion"]	 = LoadFX( "maps/mak/fx_explosion_charge_med_corner" ); 
	level.scr_sound["corner_hut_explosion"] = "exp_hut_corner"; 

	level._effect["shed_barrel_explosion"]	 = LoadFX( "maps/mak/fx_explosion_barrel_small" ); 
	level._effect["barrel_explosion"]		 = LoadFX( "destructibles/fx_barrelExp" ); 
	level._effect["barrel_trail"]			 = LoadFx( "destructibles/fx_dest_fire_trail_med" ); 

	add_earthquake( "truck_barrels", 0.4, 2, 300 ); 

	// Tower Collapse
	level._effect["hut1_collapse"] 			 = LoadFx( "maps/mak/fx_fire_ewok_collapse_group" ); 
	level._effect["hut1_splash"] 			 = LoadFx( "maps/mak/fx_fire_ewok_splash_plume" ); 
	level._effect["hut1_smoke"] 			 = LoadFx( "maps/mak/fx_fire_ewok_smoke" ); 
	level._effect["hut1_fire_large"] 		 = LoadFx( "maps/mak/fx_fire_ewok_large" ); 
	level._effect["hut1_fire_medium"] 		 = LoadFx( "maps/mak/fx_fire_ewok_medium" ); 
	level._effect["hut1_fire_pole"] 		 = LoadFx( "maps/mak/fx_fire_ewok_medium_pole" ); 

	// Under Hut
	level._effect["under_hut"]				 = LoadFX( "maps/mak/fx_fire_hut_collapse_small" ); 

	// Guy 2 Shed
	level._effect["guy2shed"]				 = LoadFX( "maps/mak/fx_collapse_dust_plume_4" ); 

	// Water Splash for showdown
	level._effect["showdown_splash"]		 = LoadFx( "maps/mak/fx_water_splash_falling_guy" ); 

	// Smoke Fx for Fire Beatdown
	level._effect["beatdown_arm_smoke"]		 = LoadFx( "maps/mak/fx_smoke_small" ); 

	level._effect["head_shot"]				 = LoadFx( "impacts/flesh_hit_head_fatal_exit" ); 
	level._effect["head_shot_splat"]		 = LoadFx( "impacts/flesh_hit_splat" ); 
}

event2()
{
	level._effect["birds_fly"] 				= LoadFx( "maps/pel2/fx_birds_tree_panic" );
	level._effect["spot_light"]				= LoadFx( "env/light/fx_light_pby_exterior_dspot" );
	level._effect["spot_light_death"]		= LoadFx( "maps/mak/fx_light_searchlight_burst_md" );
}

event4()
{
	level._effect["truck_fuel_spill"] 		= LoadFx( "maps/mak/fx_fire_fuel_spill" );
	level._effect["truck_fuel_spill_fire"]	= LoadFx( "maps/mak/fx_fire_fuel_ground_emitter" );
	// Sumeet - added a truck collision with tower effect.
	level._effect["truck_tower_collision"]	= LoadFx( "maps/mak/fx_truck_tower_collision" );
}

event6()
{
	level._effect["tower_impact"]			= LoadFx( "maps/mak/fx_collapse_dust_plume_3" );
	level._effect["end_barrel_explosion"]	= LoadFx( "destructibles/fx_barrelExp" );
	level._effect["end_hut_explosion1"]		= LoadFx( "maps/mak/fx_explosion_charge_xlarge_2" );
	level._effect["end_hut_explosion2"]		= LoadFx( "maps/mak/fx_explosion_charge_xlarge_2_ending" );
	level._effect["large_water_squib"]		= LoadFx( "impacts/large_waterhit" );
	level._effect["small_water_squib"]		= LoadFx( "impacts/small_waterhit" );
	level._effect["head_shot_big"]			= LoadFx( "impacts/flesh_head_impact03" );
	level._effect["rocket_explode"]	   		= LoadFx( "weapon/mortar/fx_mortar_exp_dirt_medium");
}

// Load some basic FX to play around with.
precacheFX()
{
	// Can be used anywhere
	level._effect["flesh_hit"] 						= LoadFX( "impacts/flesh_hit_body_fatal_exit" ); 

	// FLAME AI FX
	level._effect["character_fire_pain_sm"] 		= LoadFx( "env/fire/fx_fire_player_sm_1sec" ); 
	level._effect["character_fire_death_sm"] 		= LoadFx( "env/fire/fx_fire_player_md" ); 
	level._effect["character_fire_death_torso"] 	= LoadFx( "env/fire/fx_fire_player_torso" ); 

	// Radio Destructible
	level._effect["radio_explode"] 					= LoadFx( "env/electrical/fx_elec_short_oneshot" );

//////////////////////////////////////////////////////////////////////////////////////
///////////////////////QUINN SECTION	////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

	// For level._effect["X"]s, X can be whatever makes sense to the scripter. 
	// The loadfx() call needs to point to a valid effect, however.

	level._effect["insects_lantern1"] = LoadFX( "bio/insects/fx_insects_lantern_1" ); 
	level._effect["insects_lantern2"] = LoadFX( "bio/insects/fx_insects_lantern_2" ); 
	level._effect["campfire_smolder"] = LoadFX( "env/fire/fx_fire_campfire_smolder" ); 
	level._effect["campfire_medium"] = LoadFX( "maps/mak/fx_fire_camp_med" ); 
	level._effect["chimney_smoke"] = LoadFX( "maps/mak/fx_smoke_chimney_med" ); 
	level._effect["chimney_smoke_large"] = LoadFX( "env/smoke/fx_smoke_wood_chimney_lrg" ); 
	level._effect["searchlight_1"] = LoadFX( "misc/fx_spotlight_large" ); 
	level._effect["bats_circling"] = LoadFX( "bio/animals/fx_bats_circling" ); 
	level._effect["bats_swarm"] = LoadFX( "bio/animals/fx_bats_circling_swarm" ); 
	level._effect["floor_rays_large"] = LoadFX( "maps/mak/fx_ray_linear_large" ); 
	level._effect["floor_rays_medium"] = LoadFX( "maps/mak/fx_ray_linear_med" ); 
	level._effect["plume_collapse_dust"] = LoadFX( "explosions/fx_dust_cloud_plume_1" ); 
	level._effect["mist_rolling"] = LoadFX( "maps/mak/fx_fog_rolling_thin" ); 
	level._effect["mist_rolling2"] = LoadFX( "maps/mak/fx_fog_rolling_thin2" );  
	level._effect["fire_barrel_medium"] = LoadFX( "env/fire/fx_fire_barrel_med" ); 
	level._effect["fire_barrel_small"] = LoadFX( "env/fire/fx_fire_barrel_small" ); 
	level._effect["glow_outdoor"] = LoadFX( "env/light/fx_glow_lampost_white_dim_static" ); 
	level._effect["glow_indoor"] = LoadFX( "env/light/fx_light_indoor_white_static" ); 
	level._effect["insects_swarm"] = LoadFX( "maps/mak/fx_insects_swarm" ); 
	level._effect["glow_spotlight"] = LoadFX( "env/light/fx_glow_spotlight_white_dim_static" ); 
	level._effect["sys_e_smoke_trail"] = LoadFX( "maps/mak/fx_sys_element_smoke_tail_small" ); 
	level._effect["fire_debris_small"] = LoadFX( "maps/mak/fx_fire_debris_small" ); 
	level._effect["fire_debris_med"] = LoadFX( "maps/mak/fx_fire_debris_med" );  
	level._effect["fire_debris_large"] = LoadFX( "maps/mak/fx_fire_debris_large" );  
	level._effect["fire_debris_large_direct"] = LoadFX( "maps/mak/fx_fire_debris_large_directional" );  
	level._effect["glow_indoor_spot"] = LoadFX( "maps/mak/fx_light_glow_lantern_spot" ); 
	level._effect["fire_debris_large_single"] = LoadFX( "maps/mak/fx_fire_debris_large_single" ); 
	level._effect["fire_debris_ash_cloud"] = LoadFX( "maps/mak/fx_fire_debris_ash_cloud" ); 
	level._effect["fire_embers_patch"] = LoadFX( "maps/mak/fx_fire_debris_embers_patch" ); 
	level._effect["fire_embers_patch2"] = LoadFX( "maps/mak/fx_fire_debris_embers_patch2" ); 
	level._effect["fire_debris_med_line"] = LoadFX( "maps/mak/fx_fire_debris_med_line" ); 
	level._effect["fire_debris_med_line2"] = LoadFX( "maps/mak/fx_fire_debris_med_line2" ); 
	level._effect["fire_debris_med_line3"] = LoadFX( "maps/mak/fx_fire_debris_med_line3" ); 
	level._effect["fire_water_medium"] = LoadFX( "maps/mak/fx_fire_water_med" ); 
	level._effect["fire_water_small"] = LoadFX( "maps/mak/fx_fire_water_small" ); 
	level._effect["fire_smoke_column1"] = LoadFX( "maps/mak/fx_smoke_column" ); 
	level._effect["fire_smoke_column2"] = LoadFX( "maps/mak/fx_smoke_column2" ); 
	level._effect["fire_hut_d_light"] = LoadFX( "maps/mak/fx_fire_hut_d_light" ); 
	level._effect["god_ray_moon1"] = LoadFX( "maps/mak/fx_ray_linear_large_moon" );                      
	level._effect["god_ray_moon2"] = LoadFX( "maps/mak/fx_ray_linear_large_moon2" );         
	level._effect["god_ray_moon3"] = LoadFX( "maps/mak/fx_ray_linear_large_moon3" ); 
	level._effect["god_ray_moon4"] = LoadFX( "maps/mak/fx_ray_linear_large_moon4" );        
	level._effect["god_ray_fire"] = LoadFX( "maps/mak/fx_ray_linear_fire_small" );    
	level._effect["god_ray_fire2"] = LoadFX( "maps/mak/fx_ray_linear_fire_medium" );  	      
	level._effect["smoke_ambiance_indoor"] = LoadFX( "maps/mak/fx_smoke_ambiance_indoor" );                  
	level._effect["water_flow"] = LoadFX( "maps/mak/fx_water_wake_flow" );  
	level._effect["water_splash_rocks"] = LoadFX( "maps/mak/fx_water_splash_rocks" );                   
	level._effect["water_wake_mist"] = LoadFX( "maps/mak/fx_water_wake_mist" ); 
	level._effect["water_wake_ripples"] = LoadFX( "maps/mak/fx_water_ripples_small" );
	level._effect["glow_candle"] = LoadFX( "env/light/fx_dlight_candle_glow" );

	// Lights -- BA Section --
	level._effect["lantern_on_global"]	= LoadFX( "env/light/fx_lights_lantern_on" );              
}

spawnFX()
{
	maps\createfx\mak_fx::main(); 
}

cig_smoke( officer )
{
	wait( 1 ); 
	PlayFxOnTag( level._effect["cigarette"], officer, "tag_efx" ); 
	PlayFxOnTag( level._effect["cigarette_glow"], officer, "tag_efx" ); 
}