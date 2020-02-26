#include clientscripts\_utility; 

// Scripted effects
precache_scripted_fx()
{

}


// Ambient effects
precache_createfx_fx()
{
	// Exploders
	// Event 1: Let it snow
	level._effect[ "fx_prop_beer_open" ]						= loadFX( "maps/panama/fx_prop_beer_open" ); // 150
	// Event 2: The Men in Charge
	level._effect["fx_tracers_antiair_night"]				= loadFX("weapon/antiair/fx_tracers_antiair_night");	// 101
	//level._effect["fx_pan_flak_field_flash"]				= loadFX("maps/panama/fx_pan_flak_field_flash");	// 101
	level._effect["fx_flak_field_30k"]							= loadFX("explosions/fx_flak_field_30k");	// 101
	level._effect["fx_ambient_bombing_10000"]				= loadFX("weapon/bomb/fx_ambient_bombing_10000");	// 101
	//level._effect[ "fx_all_sky_exp" ]								= loadFX( "maps/panama/fx_sky_exp_orange" ); // 102-105
	level._effect[ "fx_seagulls_circle_overhead" ]	= loadFX( "bio/animals/fx_seagulls_circle_overhead" ); // 200
	//level._effect[ "fx_seagulls_circle_swarm" ]			= loadFX( "bio/animals/fx_seagulls_circle_swarm" ); // 200	
	level._effect[ "fx_pan_seagulls_near" ]							= loadFX( "maps/panama/fx_pan_seagulls_near" ); // 200
	level._effect[ "fx_pan_seagulls_shore_distant" ]		= loadFX( "maps/panama/fx_pan_seagulls_shore_distant" ); // 200	

	level._effect[ "fx_pan_exp_condo" ]							= loadFX( "maps/panama/fx_pan_exp_condo" ); // 250
	level._effect[ "fx_pan_hotel_blood_decal" ]							= loadFX( "maps/panama/fx_pan_hotel_blood_decal" ); // 260
	level._effect[ "fx_pan_hotel_blood_impact" ]							= loadFX( "maps/panama/fx_pan_hotel_blood_impact" ); 
	
	level._effect[ "fx_pan_signal_flare" ]					= loadFX("maps/panama/fx_pan_signal_flare"); 
	level._effect[ "fx_pan_signal_flare_falling" ]	= LoadFX("maps/panama/fx_pan_signal_flare_falling"); 
	level._effect[ "fx_pan_signal_flare_light" ]	= LoadFX("maps/panama/fx_pan_signal_flare_light"); //298
		
	// Event 3: Old Friends
	level._effect["fx_table_cash_drop_panama"]			= loadFX("props/fx_table_cash_drop_panama");	// 301
	level._effect[ "fx_motel_tv_destroyed" ] 				= loadFX( "props/fx_tv_motel_destroy" );	// 302 play on tag_origin	of TV	

	//Destroyed Condo
	level._effect["fx_dest_condo_dust_linger"]			= loadFX("maps/panama/fx_dest_condo_dust_linger"); //x-up	
		
	// Ambient Effects
	level._effect["fx_light_runway_line"]						= loadFX("env/light/fx_light_runway_line");
	level._effect["fx_spotlight"]										= loadFX("maps/panama/fx_pan_spotlight");
	
	level._effect["fx_shrimp_paratrooper_ambient"]	= loadFX("bio/shrimps/fx_shrimp_paratrooper_ambient");
	level._effect["fx_insects_ambient"]							= loadFX("bio/insects/fx_insects_ambient");
	level._effect["fx_insects_swarm_less_md_light"]	= loadFX("bio/insects/fx_insects_swarm_less_md_light");
	//level._effect["fx_insects_roaches_short"]				= loadFX("bio/insects/fx_insects_roaches_short");
	level._effect["fx_insects_fireflies"]						= loadFX("bio/insects/fx_insects_fireflies");		
	
	//level._effect["fx_smk_fire_md_black"]						= loadFX("smoke/fx_smk_fire_md_black");
	//level._effect["fx_smk_fire_lg_black"]						= loadFX("smoke/fx_smk_fire_lg_black");
	//level._effect["fx_smk_fire_lg_white"]						= loadFX("smoke/fx_smk_fire_lg_white");
	level._effect["fx_smk_linger_lit"]							= loadFX("smoke/fx_smk_linger_lit"); //z-up x-for
	level._effect["fx_smk_smolder_rubble_md"]				= loadFX("smoke/fx_smk_smolder_rubble_md"); //z-up x-for
	level._effect["fx_smk_smolder_rubble_lg"]				= loadFX("smoke/fx_smk_smolder_rubble_lg"); //z-up x-for
	//level._effect["fx_smk_smolder_sm_int"]					= loadFX("smoke/fx_smk_smolder_sm_int"); //x-up z-for
	//level._effect["fx_smk_ceiling_crawl"]						= loadFX("smoke/fx_smk_ceiling_crawl"); //z-up x-for
	//level._effect["fx_smk_plume_lg_wht"]						= loadFX("smoke/fx_smk_plume_lg_wht"); //z-up
	//level._effect["fx_smk_fire_md_gray_int"]				= loadFX("env/smoke/fx_smk_fire_md_gray_int"); //x-for
	//level._effect["fx_pan_smk_plume_bg_xlg"]				= loadFX("smoke/fx_pan_smk_plume_black_bg_xlg"); //z-up -x drift direction
	//level._effect["fx_pan_smk_plume_black_bg_xlg"]	= loadFX("smoke/fx_pan_smk_plume_black_bg_xlg"); //z-up -x drift direction	
	level._effect["fx_pipe_roof_steam_sm"]					= loadFX("smoke/fx_pipe_roof_steam_sm"); //x-up
	level._effect["fx_pan1_vista_smoke_hanging"]		= loadFX("smoke/fx_pan1_vista_smoke_hanging"); //z-up -x drift direction		

	level._effect["fx_fire_column_creep_xsm"]				= loadFX("env/fire/fx_fire_column_creep_xsm");
	//level._effect["fx_fire_column_creep_sm"]				= loadFX("env/fire/fx_fire_column_creep_sm");
	//level._effect["fx_fire_wall_md"]								= loadFX("env/fire/fx_fire_wall_md");
	//level._effect["fx_fire_ceiling_md"]							= loadFX("env/fire/fx_fire_ceiling_md");
	level._effect["fx_fire_line_xsm"]								= loadFX("env/fire/fx_fire_line_xsm");
	//level._effect["fx_fire_line_sm"]								= loadFX("env/fire/fx_fire_line_sm");
	//level._effect["fx_fire_line_md"]								= loadFX("env/fire/fx_fire_line_md");
	//level._effect["fx_fire_sm_smolder"]							= loadFX("env/fire/fx_fire_sm_smolder");
	level._effect["fx_fire_md_smolder"]							= loadFX("maps/panama/fx_fire_md_smolder_pan");
	//level._effect["fx_embers_falling_md"]						= loadFX("env/fire/fx_embers_falling_md"); // x-down
	//level._effect["fx_embers_falling_sm"]						= loadFX("env/fire/fx_embers_falling_sm"); //x-down	
	level._effect["fx_ash_embers_heavy"]						= loadFX("maps/panama/fx_pan_ash_embers_heavy");
	level._effect["fx_embers_up_dist"]							= loadFX("env/fire/fx_embers_up_dist");
	
	level._effect["fx_debris_papers_fall_burning"]	= loadFX("env/debris/fx_debris_papers_fall_burning");
	level._effect["fx_debris_papers_narrow"]				= loadFX("env/debris/fx_debris_papers_narrow");
	level._effect["fx_debris_papers_obstructed"]		= loadFX("env/debris/fx_debris_papers_obstructed");
	level._effect["fx_debris_papers_windy_slow"]		= loadFX("env/debris/fx_debris_papers_windy_slow"); //z-up x-for; up off surface

	level._effect["fx_elec_burst_shower_sm_runner"]	= loadFX("env/electrical/fx_elec_burst_shower_sm_runner"); //x-for z-up

	level._effect["fx_fog_lit_overhead_amber"]			= loadFX("fog/fx_fog_lit_overhead_amber");
	level._effect["fx_fog_lit_radial_amber"]				= loadFX("fog/fx_fog_lit_radial_amber");
	level._effect["fx_fog_thick_800x800"]						= loadFX("fog/fx_fog_thick_800x800");
		
	level._effect["fx_smk_pan_hallway_med"]					= loadFX("maps/panama/fx_smk_pan_hallway_med"); //z-up
	level._effect["fx_smk_pan_room_med"]						= loadFX("maps/panama/fx_smk_pan_room_med"); //z-up
	level._effect["fx_pan_powerline_sparks_runner"]						= loadFX("maps/panama/fx_pan_powerline_sparks_runner");
	//level._effect["fx_cloud_layer_still_lg"]				= loadFX("maps/panama/fx_cloud_layer_still_lg"); //x-up, y-length
	level._effect["fx_pan_shoreline_froth"]					= loadFX("maps/panama/fx_pan_shoreline_froth"); //x-for, y-length
	level._effect["fx_pan_rocks_froth"]							= loadFX("maps/panama/fx_pan_rocks_froth");
	level._effect["fx_pan_buoy_froth"]							= loadFX("maps/panama/fx_pan_buoy_froth");
	level._effect["fx_pan_fog_trench_600x1200"]			= loadFX("maps/panama/fx_pan_fog_trench_600x1200"); //x-up z-length
	level._effect["fx_fire_pan_billow_condo"]				= loadFX("maps/panama/fx_fire_pan_billow_condo"); //x-up +y drift direction
	level._effect["fx_smk_pan_billow_condo"]				= loadFX("maps/panama/fx_smk_pan_billow_condo"); //x-up +y drift direction	
	level._effect["fx_pan_truck_smk"]								= loadFX("maps/panama/fx_pan_truck_smk");	
	level._effect["fx_pan_dust_motes_med"]					= loadFX("maps/panama/fx_pan_dust_motes_med"); //z-up
	
	level._effect["fx_light_tinhat_cage_white"]			= loadFX("env/light/fx_light_tinhat_cage_white");	
	level._effect["fx_light_tinhat_cage_yellow"]		= loadFX("light/fx_light_tinhat_cage_yellow");
	level._effect["fx_pan_light_overhead"]					= loadFX("light/fx_pan_light_overhead_low");
	level._effect["fx_light_floodlight_bright"]			= loadFX("maps/panama/fx_pan_light_floodlight_bright");
	level._effect["fx_light_floodlight_dim_sm_amber"]			= loadFX("maps/panama/fx_pan_floodlight_dim_sm_amber");	
	level._effect["fx_light_flourescent_glow_cool"]	= loadFX("light/fx_light_flourescent_glow_cool");
	level._effect["fx_pan_light_flourescent_glow_workshop"]	= loadFX("light/fx_pan_light_flourescent_glow_workshop");	
	level._effect["fx_pan_streetlight_glow"]				= loadFX("light/fx_pan_streetlight_glow");	
	level._effect["fx_pan_streetlight_flicker_glow"]				= loadFX("light/fx_pan_streetlight_flicker_glow");	
	level._effect["fx_pan_light_tower_red_blink"]		= loadFX("light/fx_pan_light_tower_red_blink");	
	level._effect["fx_light_portable_flood_beam"]		= loadFX("light/fx_light_portable_flood_beam");
	level._effect["fx_light_desklamp_glow"]					= loadFX("light/fx_light_desklamp_glow");
	level._effect["fx_pan_lightbulb_glow"]					= loadFX("light/fx_pan_lightbulb_glow");
	level._effect["fx_pan_hotel_light_glow"]					= loadFX("maps/panama/fx_pan_hotel_light_glow");
	level._effect["fx_pan_hotel_light_glow_dim"]					= loadFX("maps/panama/fx_pan_hotel_light_glow_dim");
	level._effect["fx_pan_light_el_torito"]					= loadFX("maps/panama/fx_pan_light_el_torito");
	level._effect[ "fx_pan_bbq_fire" ]							= loadFX( "maps/panama/fx_pan_bbq_fire" );
	level._effect[ "fx_pan_buoy_light"]							= loadFX( "maps/panama/fx_pan_buoy_light");
	level._effect[ "fx_vlight_brakelight_default" ]	= LoadFX("light/fx_vlight_brakelight_default");
	level._effect[ "fx_vlight_brakelight_pan" ]	= LoadFX("light/fx_vlight_brakelight_pan");
	level._effect[ "fx_vlight_headlight_default" ]	= LoadFX("light/fx_vlight_headlight_default");
	level._effect[ "fx_vlight_headlight_foggy_default" ]	= LoadFX("light/fx_vlight_headlight_foggy_default");	
	level._effect[ "fx_pan_jeep_spot_light" ]	= LoadFX("maps/panama/fx_pan_jeep_spot_light");
	level._effect[ "fx_pan_fire_med" ]	= LoadFX("maps/panama/fx_pan_fire_med");
	level._effect[ "fx_pan_fire_lg" ]	= LoadFX("maps/panama/fx_pan_fire_lg");
	level._effect[ "fx_pan_fire_light" ]	= LoadFX("maps/panama/fx_pan_fire_light");
	level._effect[ "fx_elec_transformer_exp_huge_bg_ch" ]	= LoadFX("maps/panama/fx_elec_transformer_exp_huge_bg_ch");
	level._effect[ "fx_pan_shed_godray" ]	= LoadFX("maps/panama/fx_pan_shed_godray");
	level._effect[ "fx_pan_light_beam_jet" ]			= LoadFX("maps/panama/fx_pan_light_beam_jet");
	level._effect[ "fx_pan_lock_break" ]					= LoadFX("maps/panama/fx_pan_lock_break");
	level._effect[ "fx_pan_vista_glow_blue" ]					= LoadFX("maps/panama/fx_pan_vista_glow_blue");
	level._effect[ "fx_pan_vista_glow_green" ]					= LoadFX("maps/panama/fx_pan_vista_glow_green");
	level._effect[ "fx_pan_vista_glow_orange" ]					= LoadFX("maps/panama/fx_pan_vista_glow_orange");
		level._effect[ "fx_pan_light_tinhat_cage_cool" ]					= LoadFX("maps/panama/fx_pan_light_tinhat_cage_cool");
	level._effect[ "fx_pan_light_tinhat_cage_yellow" ]					= LoadFX("maps/panama/fx_pan_light_tinhat_cage_yellow");
		level._effect[ "fx_pan_spotlight_table" ]					= LoadFX("maps/panama/fx_pan_spotlight_table");
	level._effect[ "fx_pan_spotlight_garage" ]					= LoadFX("maps/panama/fx_pan_spotlight_garage");
	
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
	clientscripts\createfx\panama_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_createfx_fx();
	
//	footsteps();	
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

