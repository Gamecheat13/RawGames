#include clientscripts\_utility; 

// Scripted effects
precache_scripted_fx()
{
	
}

// Ambient effects
precache_createfx_fx()
{
	// Exploders
	level._effect["fx_ac130_dropping_paratroopers"]	= loadFX("bio/shrimps/fx_ac130_dropping_paratroopers");	// 500

	level._effect["fx_bulletholes"]									= loadFX("impacts/fx_bulletholes");	// 540

	level._effect["fx_exp_window_fire"]							= loadFX("explosions/fx_exp_window_fire");	// 560-562
	level._effect[ "fx_clinic_ceiling_collapse" ]		= loadFX( "maps/panama/fx_clinic_ceiling_collapse" ); // 10620	
	level._effect[ "fx_clinic_ceiling_collapse_impact" ]		= loadFX( "maps/panama/fx_clinic_ceiling_collapse_impact" ); // 10621
	level._effect[ "fx_digbat_thru_wall" ]					= loadFX( "maps/panama/fx_digbat_thru_wall" ); // 640	
	level._effect[ "fx_exp_water_tower" ]						= loadFX( "explosions/fx_exp_water_tower" );	// 700
	level._effect[ "fx_noriega_thru_wall" ]					= loadFX( "maps/panama/fx_noriega_thru_wall" ); // 710
	level._effect[ "fx_noriega_wall_dust" ]					= loadFX( "maps/panama/fx_noriega_wall_dust" ); // 720
	level._effect[ "fx_impacts_apache_escape" ]			= loadFX( "maps/panama/fx_impacts_apache_escape" ); // 730	
	level._effect[ "fx_impacts_apache_escape_tracer" ]			= loadFX( "maps/panama/fx_impacts_apache_escape_tracer" ); // 730	
	level._effect["fx_heli_rotor_wash_finale"]			= loadFX( "maps/panama/fx_heli_rotor_wash_finale" ); // 920
	level._effect[ "fx_vlight_headlight_default" ]	= LoadFX("maps/panama/fx_vlight_headlight_default_pan");
	level._effect[ "fx_pan_fence_crash" ]	= LoadFX("maps/panama/fx_pan_fence_crash");
	
	// Ambient Effects
	level._effect["fx_shrimp_paratrooper_ambient"]	= loadFX("bio/shrimps/fx_shrimp_paratrooper_ambient");
	level._effect["fx_insects_swarm_less_md_light"]	= loadFX("bio/insects/fx_insects_swarm_less_md_light");	

	level._effect["fx_dust_crumble_sm_runner"]			= loadFX("dirt/fx_dust_crumble_sm_runner"); //x or z-up y-length
	level._effect["fx_dust_crumble_int_md_gray"]			= loadFX("dirt/fx_dust_crumble_int_md_gray");
	level._effect["fx_dust_crumble_int_sm"]					= loadFX("env/dirt/fx_dust_crumble_int_sm"); //x-up


	level._effect["fx_fog_lit_overhead_amber"]			= loadFX("fog/fx_fog_lit_overhead_amber");
	level._effect["fx_pan_fire_sml"]								= loadFX("maps/panama/fx_pan_fire_sml");
	level._effect["fx_pan_dust_linger"]								= loadFX("maps/panama/fx_pan_dust_linger");

	level._effect["fx_pan_light_overhead_indoor"]			= loadFX("light/fx_pan_light_overhead_indoor");
	level._effect["fx_pan_light_overhead"]						= loadFX("light/fx_pan_light_overhead");
	level._effect[ "fx_vlight_headlight_foggy_default" ]	= LoadFX("light/fx_vlight_headlight_foggy_default");
	level._effect["fx_light_portable_flood_beam"]		= loadFX("light/fx_light_portable_flood_beam");	
	level._effect["fx_pan_light_tower_red_blink"]		= loadFX("light/fx_pan_light_tower_red_blink");

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
	
	level._effect["fx_debris_papers_fall_burning"]	= loadFX("env/debris/fx_debris_papers_fall_burning");
	level._effect["fx_debris_papers_narrow"]				= loadFX("env/debris/fx_debris_papers_narrow");
	level._effect["fx_debris_papers_obstructed"]		= loadFX("env/debris/fx_debris_papers_obstructed");

	level._effect["fx_cloud_layer_fire_close"]			= loadFX("maps/panama/fx_cloud_layer_fire_close"); //x-up, y-length
	level._effect["fx_cloud_layer_rolling_3_lg"]		= loadFX("maps/panama/fx_cloud_layer_rolling_3_lg"); //x-up, y-length		
	level._effect["fx_cloud_layer_rolling_end"]		= loadFX("maps/panama/fx_cloud_layer_rolling_end"); //x-up, y-length
	
	level._effect["fx_flak_field_30k"]							= loadFX("explosions/fx_flak_field_30k");
	level._effect["fx_tracers_antiair_night"]				= loadFX("weapon/antiair/fx_tracers_antiair_night");
	level._effect["fx_pan_flak_field_flash"]				= loadFX("maps/panama/fx_pan_flak_field_flash");
	level._effect["fx_ambient_bombing_10000"]				= loadFX("weapon/bomb/fx_ambient_bombing_10000");

	level._effect["fx_water_drip_light_long_noripple"]		= loadFX("env/water/fx_water_drip_light_long_noripple");
	level._effect["fx_water_drip_light_long_noripple"]		= loadFX("env/water/fx_water_drip_light_long_noripple");	
	
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
	level._effect[ "fx_pan_light_bridge_red_blink" ] 				= loadfx( "light/fx_pan_light_bridge_red_blink" );
	level._effect[ "fx_pan_light_bridge_traffic" ] 				= loadfx( "light/fx_pan_light_bridge_traffic" );
	level._effect[ "fx_pan_light_canal" ]								= LoadFX("maps/panama/fx_pan_light_canal");
	level._effect[ "fx_pan_light_canal_lensflare" ]	= LoadFX("maps/panama/fx_pan_light_canal_lensflare");
	level._effect[ "fx_pan_light_docks_tall" ]								= LoadFX("maps/panama/fx_pan_light_docks_tall");
	level._effect[ "fx_pan_light_docks_short" ]								= LoadFX("maps/panama/fx_pan_light_docks_short");
	level._effect[ "fx_tracer_ac130_fake" ]								= LoadFX("maps/panama/fx_tracer_ac130_fake");
	level._effect[ "fx_pan_clinic_blinds_dust" ]					= loadFX( "maps/panama/fx_pan_clinic_blinds_dust" ); 
			level._effect[ "fx_vlight_jeep_headlight" ] 				= loadfx( "light/fx_vlight_jeep_headlight" );
	level._effect[ "fx_vlight_jeep_taillight" ] 				= loadfx( "light/fx_vlight_jeep_taillight" );
	level._effect[ "fx_vlight_brakelight_pan" ] 				= loadfx( "light/fx_vlight_brakelight_pan" );
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
	clientscripts\createfx\panama_3_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_createfx_fx();
	
//	footsteps();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}