#include maps\_utility; 
#include common_scripts\utility;

#using_animtree("fxanim_props");

main()
{
	init_model_anims();
	precache_scripted_fx();
	precache_createfx_fx();
	wind_init();
	footsteps();	
	
	// calls the createfx server script (i.e., the list of ambient effects and their attributes)
	maps\createfx\panama_3_fx::main();
}


// Scripted effects
precache_scripted_fx()
{
	//temp- fuel tanks explosion for jeeps docks
	level._effect[ "fuel_tank_explosion" ]	= LoadFX("maps/panama/fx_pan_fuel_tank_explosion");
	//level._effect["fuel_tank_explosion"]			= LoadFX( "explosions/fx_explosion_charge_large" );
	
	//temp foliage fx for jeeps docks
	level._effect[ "jeep_foliage_hit" ]				= loadFX( "impacts/fx_xtreme_foliage_hit" );
	
	level._effect[ "jeep_spot_light" ] 				= loadfx( "maps/panama/fx_pan_jeep_spot_light" );
	
	
	level._effect[ "jeep_headlight" ] 				= loadfx( "light/fx_vlight_jeep_headlight" );
	level._effect[ "jeep_taillight" ] 				= loadfx( "light/fx_vlight_jeep_taillight" );
	level._effect[ "jeep_guagelight" ] 				= loadfx( "light/fx_vlight_jeep_gauges" );
	
	//vehicle lights
	level._effect[ "fx_vlight_brakelight_default" ]	= LoadFX("light/fx_vlight_brakelight_default");
	level._effect[ "fx_vlight_headlight_default" ]	= LoadFX("maps/panama/fx_vlight_headlight_default_pan");
	level._effect[ "fx_vlight_headlight_foggy_default" ]	= LoadFX("light/fx_vlight_headlight_foggy_default");		

	//more intense AC130 fx
	level._effect[ "ac130_intense_fake" ]				= LoadFX( "maps/panama/fx_tracer_ac130_fake" );
	
	//sky light up for AC130 vulcan fire
	level._effect[ "ac130_sky_light" ]					= LoadFX( "weapon/muzzleflashes/fx_ac130_vulcan_world" );

	//fire hydrant destroyed by AC130
	level._effect["fx_dest_hydrant_water"]					= loadFX("destructibles/fx_dest_hydrant_water"); // x-up		

	//Jet fx
	level._effect[ "jet_exhaust" ]	            = LoadFX( "vehicle/exhaust/fx_exhaust_jet_afterburner" );
	level._effect[ "jet_contrail" ]             = LoadFX( "trail/fx_geotrail_jet_contrail" );			
	
	//Clinic hanging light (rope tech)
	level._effect["clinic_hanging_light"]			= loadFX("maps/panama/fx_pan_clinic_tinhat_light");
	
	// Event 5: Slums
	//level._effect[ "ambulance_siren" ]				= loadFX( "light/fx_light_ambulance_red_flashing" );
	level._effect[ "ir_strobe" ]							= loadFX( "weapon/grenade/fx_strobe_grenade_runner" );
	level._effect[ "flashlight" ]							= loadFX( "env/light/fx_flashlight_ai" );
	level._effect[ "digbat_doubletap" ]				= loadFX( "impacts/fx_head_fatal_lg_side" );
	//level._effect[ "all_sky_exp" ]						= loadFX( "maps/panama/fx_sky_exp_orange" );
	level._effect[ "on_fire_tor" ]						= loadFX( "fire/fx_fire_ai_torso" );
	level._effect[ "on_fire_leg" ]						= loadFX( "fire/fx_fire_ai_leg" );
	level._effect[ "on_fire_arm" ]						= loadFX( "fire/fx_fire_ai_arm" );
	level._effect[ "molotov_lit" ]						= loadFX( "weapon/molotov/fx_molotov_wick" );
	level._effect[ "nightingale_smoke" ]			= loadFX( "weapon/grenade/fx_nightingale_grenade_smoke" );
		
	// Event 7: Apache Escape
	level._effect["apache_spotlight"]					= loadFX( "maps/panama/fx_pan_heli_spot_light" );
	level._effect["apache_spotlight_cheap"]		= loadFX( "light/fx_vlight_apache_spotlight_cheap" );
	level._effect["apache_exterior_lights"]		= loadFX( "vehicle/light/fx_apache_exterior_lights" );
	level._effect["soldier_impact_blood"]			= loadFX( "impacts/fx_flesh_hit_body_nogib_yaxis" );
	
	// Event 8: Take the Shot
	level._effect["elevator_light"]						= loadFX("env/light/fx_light_flicker_warm_sm");
	level._effect["mason_fatal_shot"]					= loadFX( "impacts/fx_flesh_hit_head_fatal_mason" );
	
	// Event 9: By my Hand
	level._effect["player_knee_shot_l"]					= loadFX( "impacts/fx_flesh_hit_knee_blowout_l" );
	level._effect["player_knee_shot_r"]					= loadFX( "impacts/fx_flesh_hit_knee_blowout_r" );	
	
	// Sniper Glint
	level._effect[ "sniper_glint" ]						= LoadFX( "misc/fx_misc_sniper_scope_glint" );
	
	// Claymore 
	//level._effect[ "claymore_laser" ]					= LoadFX( "weapon/claymore/fx_claymore_laser" );
	//level._effect[ "claymore_explode" ] 			= LoadFX( "explosions/fx_grenadeexp_dirt" );
	//level._effect[ "claymore_gib" ]						= loadFX( "explosions/fx_exp_death_gib" ); //DevTrack 6243	
	level._effect[ "fx_pan_light_canal" ]	= LoadFX("maps/panama/fx_pan_light_canal");
	level._effect[ "fx_pan_light_canal_lensflare" ]	= LoadFX("maps/panama/fx_pan_light_canal_lensflare");
	
	level._effect[ "irstrobe_ac130" ] = LoadFX("maps/panama/fx_pan_light_strobe");
	
	level._effect[ "pdf_sniper_blood" ] = LoadFX("maps/panama/fx_pan_docks_headshot");
	level._effect[ "pdf_armstrong_fire_Fx" ] = LoadFX("fire/fx_fire_ai_torso");
	
	
}


// Ambient effects
precache_createfx_fx()
{
	// Exploders
	level._effect["fx_ac130_dropping_paratroopers"]	= loadFX("bio/shrimps/fx_ac130_dropping_paratroopers");	// 500
	level._effect[ "fx_all_sky_exp" ]								= loadFX( "maps/panama/fx_sky_exp_orange" ); // 504	
	level._effect["fx_bulletholes"]									= loadFX("impacts/fx_bulletholes");	// 540
	level._effect["fx_exp_window_fire"]							= loadFX("explosions/fx_exp_window_fire");	// 560-562
	level._effect[ "fx_clinic_ceiling_collapse" ]		= loadFX( "maps/panama/fx_clinic_ceiling_collapse" ); // 10620	
	level._effect[ "fx_clinic_ceiling_collapse_impact" ]		= loadFX( "maps/panama/fx_clinic_ceiling_collapse_impact" ); // 10621
	level._effect[ "fx_digbat_thru_wall" ]					= loadFX( "maps/panama/fx_digbat_thru_wall" ); // 640	
	level._effect[ "fx_noriega_thru_wall" ]					= loadFX( "maps/panama/fx_noriega_thru_wall" ); // 710
	level._effect[ "fx_noriega_wall_dust" ]					= loadFX( "maps/panama/fx_noriega_wall_dust" ); // 720
	level._effect[ "fx_impacts_apache_escape" ]					= loadFX( "maps/panama/fx_impacts_apache_escape" ); // 730
	level._effect[ "fx_impacts_apache_escape_tracer" ]			= loadFX( "maps/panama/fx_impacts_apache_escape_tracer" ); // 730	
	level._effect[ "fx_exp_water_tower" ]						= loadFX( "explosions/fx_exp_water_tower" );	// 750
	level._effect["fx_heli_rotor_wash_finale"]			= loadFX( "maps/panama/fx_heli_rotor_wash_finale" ); // 920	
	level._effect[ "fx_pan_fence_crash" ]	= LoadFX("maps/panama/fx_pan_fence_crash");
	level._effect[ "fx_pan_clinic_blinds_dust" ]					= loadFX( "maps/panama/fx_pan_clinic_blinds_dust" ); 
	
	// Ambient Effects
	level._effect["fx_shrimp_paratrooper_ambient"]	= loadFX("bio/shrimps/fx_shrimp_paratrooper_ambient");
	level._effect["fx_insects_swarm_less_md_light"]	= loadFX("bio/insects/fx_insects_swarm_less_md_light");

	level._effect["fx_dust_crumble_sm_runner"]			= loadFX("dirt/fx_dust_crumble_sm_runner"); //x or z-up y-length
	level._effect["fx_dust_crumble_int_md_gray"]			= loadFX("dirt/fx_dust_crumble_int_md_gray");
	level._effect["fx_dust_crumble_int_sm"]					= loadFX("env/dirt/fx_dust_crumble_int_sm"); //x-up

	level._effect["fx_fog_lit_overhead_amber"]			= loadFX("fog/fx_fog_lit_overhead_amber");
	
	level._effect["fx_pan_light_overhead_indoor"]			= loadFX("light/fx_pan_light_overhead_indoor");
	level._effect["fx_pan_light_overhead"]						= loadFX("light/fx_pan_light_overhead");
	level._effect[ "fx_vlight_headlight_foggy_default" ]	= LoadFX("light/fx_vlight_headlight_foggy_default");
	level._effect["fx_light_portable_flood_beam"]		= loadFX("light/fx_light_portable_flood_beam");	

	level._effect["fx_smk_fire_md_black"]						= loadFX("smoke/fx_smk_fire_md_black");
	level._effect["fx_smk_fire_lg_black"]						= loadFX("smoke/fx_smk_fire_lg_black");
	level._effect["fx_smk_fire_lg_white"]						= loadFX("smoke/fx_smk_fire_lg_white");
	level._effect["fx_smk_linger_lit"]							= loadFX("smoke/fx_smk_linger_lit"); //z-up x-for
	level._effect["fx_smk_smolder_rubble_md"]				= loadFX("smoke/fx_smk_smolder_rubble_md"); //z-up x-for
	level._effect["fx_pan_smk_plume_black_bg_xlg"]	= loadFX("smoke/fx_pan_smk_plume_black_bg_xlg"); //z-up -x drift direction		

	level._effect["fx_fire_column_creep_xsm"]				= loadFX("env/fire/fx_fire_column_creep_xsm");
	level._effect["fx_fire_column_creep_sm"]				= loadFX("env/fire/fx_fire_column_creep_sm");
	level._effect["fx_fire_wall_md"]								= loadFX("env/fire/fx_fire_wall_md");
	level._effect["fx_fire_ceiling_md"]							= loadFX("env/fire/fx_fire_ceiling_md");
	level._effect["fx_fire_line_xsm"]								= loadFX("env/fire/fx_fire_line_xsm");
	level._effect["fx_fire_line_sm"]								= loadFX("env/fire/fx_fire_line_sm");
	level._effect["fx_fire_line_md"]								= loadFX("env/fire/fx_fire_line_md");
	level._effect["fx_fire_sm_smolder"]							= loadFX("env/fire/fx_fire_sm_smolder");
	level._effect["fx_fire_md_smolder"]							= loadFX("env/fire/fx_fire_md_smolder");
	level._effect["fx_ash_embers_heavy"]						= loadFX("env/fire/fx_ash_embers_heavy");
	level._effect["fx_embers_up_dist"]							= loadFX("env/fire/fx_embers_up_dist");
	level._effect["fx_embers_falling_md"]						= loadFX("env/fire/fx_embers_falling_md"); // x-down
	level._effect["fx_pan_fire_sml"]								= loadFX("maps/panama/fx_pan_fire_sml");
	level._effect["fx_pan_dust_linger"]								= loadFX("maps/panama/fx_pan_dust_linger");
	
	level._effect["fx_debris_papers_fall_burning"]	= loadFX("env/debris/fx_debris_papers_fall_burning");
	level._effect["fx_debris_papers_narrow"]				= loadFX("env/debris/fx_debris_papers_narrow");
	level._effect["fx_debris_papers_obstructed"]		= loadFX("env/debris/fx_debris_papers_obstructed");

	level._effect["fx_cloud_layer_fire_close"]			= loadFX("maps/panama/fx_cloud_layer_fire_close"); //x-up, y-length
	level._effect["fx_cloud_layer_rolling_3_lg"]		= loadFX("maps/panama/fx_cloud_layer_rolling_3_lg"); //x-up, y-length	
	level._effect["fx_cloud_layer_rolling_end"]		= loadFX("maps/panama/fx_cloud_layer_rolling_end"); //x-up, y-length	
	level._effect["fx_pan_light_tower_red_blink"]		= loadFX("light/fx_pan_light_tower_red_blink"); 
	
	level._effect["fx_flak_field_30k"]							= loadFX("explosions/fx_flak_field_30k");
	level._effect["fx_tracers_antiair_night"]				= loadFX("weapon/antiair/fx_tracers_antiair_night");
	level._effect["fx_pan_flak_field_flash"]				= loadFX("maps/panama/fx_pan_flak_field_flash");
	level._effect["fx_ambient_bombing_10000"]				= loadFX("weapon/bomb/fx_ambient_bombing_10000");

	level._effect["fx_water_drip_light_long_noripple"]			= loadFX("env/water/fx_water_drip_light_long_noripple");
	level._effect["fx_water_drip_light_long_noripple"]			= loadFX("env/water/fx_water_drip_light_long_noripple");	
	level._effect[ "fx_pan_light_bridge_red_blink" ] 				= loadfx( "light/fx_pan_light_bridge_red_blink" );
	level._effect[ "fx_pan_light_bridge_traffic" ] 				= loadfx( "light/fx_pan_light_bridge_traffic" );
	
	//NEW EXPLODERS (organize later)
	//level._effect["fx_exp_window_smoke"]						= loadFX("explosions/fx_exp_window_smoke");
	//level._effect["fx_exp_pan_window_glass"]				= loadFX("maps/panama/fx_exp_pan_window_glass"); //x-for
	level._effect["fx_pan_water_tower_impact"]		= loadFX("maps/panama/fx_pan_water_tower_impact");
	level._effect["fx_pan_water_tower_collapse"]		= loadFX("maps/panama/fx_pan_water_tower_collapse");
	level._effect["fx_clinic_light_godray"]				= loadFX("maps/panama/fx_clinic_light_godray");
	level._effect["fx_clinic_light_godray_2"]			= loadFX("maps/panama/fx_clinic_light_godray_2");
	level._effect["fx_clinic_light_godray_3"]			= loadFX("maps/panama/fx_clinic_light_godray_3");
	level._effect["fx_clinic_spot_light"]					= loadFX("maps/panama/fx_clinic_spot_light");
	level._effect["fx_clinic_flourescent_glow"]					= loadFX("maps/panama/fx_clinic_flourescent_glow");
	level._effect["fx_clinic_flourescent_glow_2"]					= loadFX("maps/panama/fx_clinic_flourescent_glow_2");
	level._effect["fx_clinic_flourescent_sparks"]					= loadFX("maps/panama/fx_clinic_flourescent_sparks");
		level._effect[ "fx_pan_light_docks_tall" ]								= LoadFX("maps/panama/fx_pan_light_docks_tall");
	level._effect[ "fx_pan_light_docks_short" ]								= LoadFX("maps/panama/fx_pan_light_docks_short");
	level._effect[ "fx_tracer_ac130_fake" ]								= LoadFX("maps/panama/fx_tracer_ac130_fake");
		level._effect[ "fx_vlight_jeep_headlight" ] 				= loadfx( "light/fx_vlight_jeep_headlight" );
	level._effect[ "fx_vlight_jeep_taillight" ] 				= loadfx( "light/fx_vlight_jeep_taillight" );
	level._effect[ "fx_vlight_brakelight_pan" ] 				= loadfx( "light/fx_vlight_brakelight_pan" );
}


wind_init()
{
	SetSavedDvar( "wind_global_vector", "1 0 0" );						// change "1 0 0" to your wind vector
	SetSavedDvar( "wind_global_low_altitude", 0 );						// change 0 to your wind's lower bound
	SetSavedDvar( "wind_global_hi_altitude", 5000 );					// change 10000 to your wind's upper bound
	SetSavedDvar( "wind_global_low_strength_percent", 0.5 );	// change 0.5 to your desired wind strength percentage
}


// FXanim Props
init_model_anims()
{
	level.scr_anim["fxanim_props"]["wall_fall"] = %fxanim_panama_wall_fall_anim;
	level.scr_anim["fxanim_props"]["laundromat_wall"] = %fxanim_panama_laundromat_wall_anim;
	level.scr_anim["fxanim_props"]["laundromat_apc"] = %fxanim_panama_laundromat_apc_anim;
	level.scr_anim["fxanim_props"]["wall_tackle"] = %fxanim_panama_wall_tackle_anim;
	level.scr_anim["fxanim_props"]["ceiling_collapse"] = %fxanim_panama_ceiling_collapse_anim;
	level.scr_anim["fxanim_props"]["water_tower"] = %fxanim_panama_water_tower_anim;
	level.scr_anim["fxanim_props"]["library"] = %fxanim_panama_library_anim;
	level.scr_anim["fxanim_props"]["overlook_building"] = %fxanim_panama_overlook_building_anim;
	level.scr_anim["fxanim_props"]["pant01"] = %fxanim_gp_pant01_anim;
	level.scr_anim["fxanim_props"]["shirt01"] = %fxanim_gp_shirt01_anim;
  level.scr_anim["fxanim_props"]["helicopter_hallway"] = %fxanim_panama_helicopter_hallway_anim;
  level.scr_anim["fxanim_props"]["hall_blinds_start"] = %fxanim_panama_hall_blinds_start_anim;
  level.scr_anim["fxanim_props"]["hall_blinds_idle"] = %fxanim_panama_hall_blinds_idle_anim;
  level.scr_anim["fxanim_props"]["fence_break"] = %fxanim_panama_fence_break_anim;
  level.scr_anim["fxanim_props"]["ceiling_01"] = %fxanim_panama_ac130_ceiling_01_anim;
  level.scr_anim["fxanim_props"]["ceiling_02"] = %fxanim_panama_ac130_ceiling_02_anim;
  level.scr_anim["fxanim_props"]["ceiling_03"] = %fxanim_panama_ac130_ceiling_03_anim;
  level.scr_anim["fxanim_props"]["seagull_circle_01"] = %fxanim_gp_seagull_circle_01_anim;
	level.scr_anim["fxanim_props"]["seagull_circle_02"] = %fxanim_gp_seagull_circle_02_anim;
	level.scr_anim["fxanim_props"]["seagull_circle_03"] = %fxanim_gp_seagull_circle_03_anim;
}

footsteps()
{
	LoadFX( "bio/player/fx_footstep_dust" );
	LoadFX( "bio/player/fx_footstep_mud" );
	LoadFX( "bio/player/fx_footstep_water" );
}
