#include clientscripts\_utility; 


// Scripted effects
precache_scripted_fx()
{
	level._effect[ "fx_vlight_brakelight_default" ]	= LoadFX("light/fx_vlight_brakelight_default");
	level._effect[ "fx_vlight_headlight_default" ]	= LoadFX("light/fx_vlight_headlight_default");

	//more intense AC130 fx
	level._effect[ "ac130_intense_fake" ]				= LoadFX( "maps/panama/fx_tracer_ac130_fake" );
	
	//sky light up for AC130 vulcan fire
	level._effect[ "ac130_sky_light" ]					= LoadFX( "weapon/muzzleflashes/fx_ac130_vulcan_world" );

	//fire hydrant destroyed by AC130
	level._effect["fx_dest_hydrant_water"]					= loadFX("destructibles/fx_dest_hydrant_water"); // x-up		

	//Jet fx
	level._effect[ "jet_exhaust" ]	            = LoadFX( "vehicle/exhaust/fx_exhaust_jet_afterburner" );
	level._effect[ "jet_contrail" ]             = LoadFX( "trail/fx_geotrail_jet_contrail" );			
	
	// Event 5: Slums
	level._effect[ "ambulance_siren" ]				= loadFX( "light/fx_light_ambulance_red_flashing" );
	level._effect[ "ir_strobe" ]							= loadFX( "weapon/grenade/fx_strobe_grenade_runner" );
	level._effect[ "flashlight" ]							= loadFX( "env/light/fx_flashlight_ai" );
	level._effect[ "digbat_doubletap" ]				= loadFX( "impacts/fx_head_fatal_lg_side" );
	level._effect[ "all_sky_exp" ]						= loadFX( "maps/panama/fx_sky_exp_orange" );
	level._effect[ "on_fire_tor" ]						= loadFX( "fire/fx_fire_ai_torso" );
	level._effect[ "on_fire_leg" ]						= loadFX( "fire/fx_fire_ai_leg" );
	level._effect[ "on_fire_arm" ]						= loadFX( "fire/fx_fire_ai_arm" );
	level._effect[ "molotov_lit" ]						= loadFX( "weapon/molotov/fx_molotov_wick" );
	level._effect[ "nightingale_smoke" ]			= loadFX( "weapon/grenade/fx_nightingale_grenade_smoke" );
		
	// Event 7: Apache Escape
	level._effect["apache_spotlight"]					= loadFX( "light/fx_vlight_apache_spotlight" );
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
	level._effect[ "claymore_laser" ]					= LoadFX( "weapon/claymore/fx_claymore_laser" );
	level._effect[ "claymore_explode" ] 			= LoadFX( "explosions/fx_grenadeexp_dirt" );
	level._effect[ "claymore_gib" ]						= loadFX( "explosions/fx_exp_death_gib" ); //DevTrack 6243	
	
}


// Ambient effects
precache_createfx_fx()
{
	// Exploders
	// Event 5: Slums
	level._effect["fx_ac130_dropping_paratroopers"]	= loadFX("bio/shrimps/fx_ac130_dropping_paratroopers");	// 500
	level._effect[ "fx_all_sky_exp" ]								= loadFX( "maps/panama/fx_sky_exp_orange" ); // 504	
	level._effect["fx_gazebo_rubble_falling"]				= loadFX("maps/panama/fx_gazebo_rubble_falling");	// 5201
	level._effect["fx_gazebo_roof_impact"]					= loadFX("maps/panama/fx_gazebo_roof_impact");	// 5201
	level._effect["fx_gazebo_pillar_break"]					= loadFX("maps/panama/fx_gazebo_pillar_break");
	level._effect["fx_gazebo_roof_collapse"]				= loadFX("maps/panama/fx_gazebo_roof_collapse");	
	level._effect["fx_gazebo_roof_collapse_start"]			= loadFX("maps/panama/fx_gazebo_roof_collapse_start");	
	// sky light: 501-504
	level._effect["fx_apc_store_front_crash"]				= loadFX("maps/panama/fx_apc_store_front_crash");	// 10540
	// Gasoline fires: 520
	level._effect["fx_bulletholes"]									= loadFX("impacts/fx_bulletholes");	// 540
	level._effect["fx_building_collapse_exp_sm"]		= loadFX("maps/panama/fx_building_collapse_exp_sm");	// 550
	level._effect["fx_building_collapse_front"]			= loadFX("maps/panama/fx_building_collapse_front");	// 550
	level._effect["fx_building_collapse_side"]			= loadFX("maps/panama/fx_building_collapse_side");	// 550
	// Event 6: Slums Burned Building
	level._effect["fx_exp_window_fire"]							= loadFX("explosions/fx_exp_window_fire");	// 560-562
	level._effect[ "fx_clinic_ceiling_collapse" ]		= loadFX( "maps/panama/fx_clinic_ceiling_collapse" ); // 10620	
	level._effect[ "fx_digbat_thru_wall" ]					= loadFX( "maps/panama/fx_digbat_thru_wall" ); // 640	
	// Event 7: Apache Escape
	level._effect[ "fx_noriega_thru_wall" ]					= loadFX( "maps/panama/fx_noriega_thru_wall" ); // 710
	level._effect[ "fx_noriega_wall_dust" ]					= loadFX( "maps/panama/fx_noriega_wall_dust" ); // 720
	level._effect[ "fx_impacts_apache_escape" ]					= loadFX( "maps/panama/fx_impacts_apache_escape" ); // 730
	level._effect[ "fx_exp_water_tower" ]						= loadFX( "explosions/fx_exp_water_tower" );	// 750
	// Event 8: Take the Shot
	level._effect["fx_gate_crash"]									= loadFX("impacts/fx_gate_crash");	// 801
	// Event 9: By My Hand
	level._effect["fx_heli_rotor_wash_finale"]			= loadFX( "maps/panama/fx_heli_rotor_wash_finale" ); // 920	
	// Event 10: Old Man Woods
	
	// Ambient Effects
	level._effect["fx_shrimp_paratrooper_ambient"]	= loadFX("bio/shrimps/fx_shrimp_paratrooper_ambient");
	//level._effect["fx_insects_ambient"]							= loadFX("bio/insects/fx_insects_ambient");
	level._effect["fx_insects_swarm_less_md_light"]	= loadFX("maps/panama/fx_pan_insects_swarm_md_light");
	//level._effect["fx_insects_roaches_short"]				= loadFX("bio/insects/fx_insects_roaches_short");
	//level._effect["fx_insects_roaches"]							= loadFX("bio/insects/fx_insects_roaches");
	//level._effect["fx_insects_fly_swarm"]						= loadFX("bio/insects/fx_insects_fly_swarm");
	level._effect[ "fx_pan_fire_light" ]					= loadFX( "maps/panama/fx_pan_fire_light" );
	level._effect[ "fx_pan_fire_light_2" ]					= loadFX( "maps/panama/fx_pan_fire_light_2" );
	
	level._effect["fx_dust_crumble_md_runner"]			= loadFX("dirt/fx_dust_crumble_md_runner"); // x or z-up y-length
	level._effect["fx_dust_crumble_sm_runner"]			= loadFX("dirt/fx_dust_crumble_sm_runner"); //x or z-up y-length
	level._effect["fx_dust_crumble_int_sm_runner"]					= loadFX("env/dirt/fx_dust_crumble_int_sm_runner"); //x-up
	
	level._effect["fx_elec_transformer_sparks_runner"]			= loadFX("electrical/fx_elec_transformer_sparks_runner"); //x-up
	level._effect["fx_elec_ember_shower_os_la_runner"]	= loadFX("electrical/fx_elec_ember_shower_os_la_runner"); //x-for z-up
	
	level._effect["fx_light_runway_line"]						= loadFX("env/light/fx_light_runway_line");
	level._effect["fx_spotlight"]										= loadFX("env/light/fx_spotlight");
	//level._effect["fx_light_dust_motes_xsm_short"]	= loadFX("light/fx_light_dust_motes_xsm_short"); // x-toward light source
	level._effect["fx_light_dust_motes_xsm_wide"]		= loadFX("light/fx_light_dust_motes_xsm_wide"); // x-toward light source
	level._effect[ "fx_vlight_headlight_foggy_default" ]	= LoadFX("light/fx_vlight_headlight_foggy_default");	

	level._effect["fx_smk_fire_md_black"]						= loadFX("smoke/fx_smk_fire_md_black");
	level._effect["fx_smk_fire_lg_black"]						= loadFX("smoke/fx_smk_fire_lg_black");
	level._effect["fx_smk_fire_lg_white"]						= loadFX("smoke/fx_smk_fire_lg_white");
	level._effect["fx_smk_linger_lit"]							= loadFX("smoke/fx_smk_linger_lit"); //z-up x-for
	level._effect["fx_smk_smolder_rubble_md"]				= loadFX("smoke/fx_smk_smolder_rubble_md"); //z-up x-for
	level._effect["fx_smk_smolder_rubble_lg"]				= loadFX("maps/panama/fx_pan_smk_smolder_rubble"); //z-up x-for
	level._effect["fx_smk_smolder_sm_int"]					= loadFX("smoke/fx_smk_smolder_sm_int"); //x-up z-for
	level._effect["fx_smk_ceiling_crawl"]						= loadFX("smoke/fx_smk_ceiling_crawl"); //z-up x-for
	level._effect["fx_smk_plume_lg_wht"]						= loadFX("smoke/fx_smk_plume_lg_wht"); //z-up
	//level._effect["fx_smk_fire_md_gray_int"]				= loadFX("env/smoke/fx_smk_fire_md_gray_int"); //x-for
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
	level._effect["fx_embers_falling_md"]						= loadFX("env/fire/fx_embers_falling_md"); // x-down
	level._effect["fx_embers_falling_sm"]						= loadFX("env/fire/fx_embers_falling_sm"); //x-down	
	level._effect["fx_ash_embers_heavy"]						= loadFX("env/fire/fx_ash_embers_heavy");
	level._effect["fx_embers_up_dist"]							= loadFX("env/fire/fx_embers_up_dist");
	
	level._effect["fx_debris_papers_fall_burning"]	= loadFX("env/debris/fx_debris_papers_fall_burning");
	level._effect["fx_debris_papers_narrow"]				= loadFX("env/debris/fx_debris_papers_narrow");
	level._effect["fx_debris_papers_obstructed"]		= loadFX("env/debris/fx_debris_papers_obstructed");
	level._effect["fx_debris_papers_windy_slow"]		= loadFX("env/debris/fx_debris_papers_windy_slow"); //z-up x-for; up off surface
	
	//level._effect["fx_light_pan_ray_street"]				= loadFX("maps/panama/fx_light_pan_ray_street"); // x-away from light source
	//level._effect["fx_sand_pan_windy_street"]				= loadFX("maps/panama/fx_sand_pan_windy_street"); //x-for z-up
	level._effect["fx_pan_light_overhead"]					= loadFX("light/fx_pan_light_overhead");
		level._effect["fx_pan_light_overhead_no_beam"]					= loadFX("light/fx_pan_light_overhead_no_beam");
	level._effect["fx_pan_light_overhead_cool"]					= loadFX("light/fx_pan_light_overhead_cool");
	level._effect["fx_pan_light_overhead_flicker"]					= loadFX("light/fx_pan_light_overhead_flicker");

		
	level._effect["fx_smk_pan_hallway_med"]					= loadFX("maps/panama/fx_smk_pan_hallway_med"); //z-up
	level._effect["fx_smk_pan_room_med"]						= loadFX("maps/panama/fx_smk_pan_room_med"); //z-up
	level._effect["fx_cloud_layer_fire_close"]			= loadFX("maps/panama/fx_cloud_layer_fire_close"); //x-up, y-length
	level._effect["fx_cloud_layer_rolling_3_lg"]		= loadFX("maps/panama/fx_cloud_layer_rolling_3_lg"); //x-up, y-length
	
	level._effect["fx_flak_field_30k"]							= loadFX("explosions/fx_flak_field_30k");
	level._effect["fx_tracers_antiair_night"]				= loadFX("weapon/antiair/fx_tracers_antiair_night");
	level._effect["fx_pan_flak_field_flash"]				= loadFX("maps/panama/fx_pan_flak_field_flash");
	level._effect["fx_ambient_bombing_10000"]				= loadFX("weapon/bomb/fx_ambient_bombing_10000");
	
	level._effect["fx_water_drip_light_long_noripple"]		= loadFX("env/water/fx_water_drip_light_long_noripple");
	level._effect["fx_water_drip_light_short_noripple"]		= loadFX("env/water/fx_water_drip_light_short_noripple");
	
	//NEW EXPLODERS (organize later)
	level._effect["fx_exp_window_smoke"]						= loadFX("explosions/fx_exp_window_smoke");
	level._effect["fx_exp_pan_window_glass"]				= loadFX("maps/panama/fx_exp_pan_window_glass"); //x-for
	level._effect["fx_slums_roof_collapse"]					= loadFX("maps/panama/fx_slums_roof_collapse"); // x-for y-length
	level._effect["fx_slums_roof_collapse_2"]					= loadFX("maps/panama/fx_slums_roof_collapse_2"); // x-for y-length
	level._effect["fx_slums_roof_collapse_3"]					= loadFX("maps/panama/fx_slums_roof_collapse_3");
	level._effect["fx_slums_roof_collapse_4"]					= loadFX("maps/panama/fx_slums_roof_collapse_4");
	level._effect["fx_civ_smallwagon_light"]					= loadFX("vehicle/light/fx_civ_smallwagon_light");
	level._effect["fx_civ_van_headlight_r"]					= loadFX("vehicle/light/fx_civ_van_headlight_r");
	level._effect["fx_civ_van_headlight_l"]					= loadFX("vehicle/light/fx_civ_van_headlight_l");
	level._effect["fx_civ_van_taillight_r"]					= loadFX("vehicle/light/fx_pan_civ_van_taillight_r");
	level._effect["fx_civ_van_taillight_l"]					= loadFX("vehicle/light/fx_pan_civ_van_taillight_l");
	level._effect["fx_pan_fire_xsml"]								= loadFX("maps/panama/fx_pan_fire_xsml");
	level._effect["fx_clinic_flourescent_glow"]								= loadFX("maps/panama/fx_clinic_flourescent_glow");
	level._effect["fx_pan_slums_dust"]								= loadFX("maps/panama/fx_pan_slums_dust");
}

/*footsteps()
{
	clientscripts\_utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "concrete", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "mud", LoadFx( "bio/player/fx_footstep_mud" ) );
	clientscripts\_utility::setFootstepEffect( "water", LoadFx( "bio/player/fx_footstep_water" ) );	
}*/

main()
{
	clientscripts\createfx\panama_2_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_createfx_fx();
	
//	footsteps();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

