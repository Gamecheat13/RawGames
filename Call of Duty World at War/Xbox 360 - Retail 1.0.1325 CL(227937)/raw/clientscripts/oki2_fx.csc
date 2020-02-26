//
// file: oki2_fx.gsc
// description: clientside fx script for oki2: setup, special fx functions, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility;

// load fx used by util scripts
precache_util_fx()
{	

}

precache_scripted_fx()
{
	level.mortar = loadfx("weapon/mortar/fx_mortar_exp_mud_medium");
	
	//level._effect["arty_strike_mud"] = loadfx("weapon/mortar/fx_mortar_exp_mud_medium");
	level._effect["tracerfire"] = loadfx("weapon/tracer/fx_tracer_flak_single_noExp");
	level._effect["falling_rocks"] = loadfx("maps/oki2/fx_artillery_strike_falling_rocks");
	level._effect["arty_strike_rock"] = loadfx("weapon/artillery/fx_artillery_exp_strike_rock");
	level._effect["rain"] = loadfx("env/weather/fx_rain_lght");
	//level._effect["battleship_muzzle"]		=	loadfx("weapon/ship/fx_ship_battle_14in");
	//level._effect["ship_backlight"] = loadfx("maps/oki2/fx_glow_ship_backlight");
	//level._effect["artillery_geotrail"] =  loadfx("weapon/rocket/fx_lci_rocket_geotrail");
	//level._effect["artillery_slide"] =  loadfx("maps/oki2/fx_artillery_slide");
	level._effect["gunsmoke"] = loadfx("env/smoke/thin_black_smoke_M");
	level._effect["gunflash"] = loadfx("weapon/artillery/fx_artillery_jap_200mm_no_smoke");
	level._effect["flesh_hit"] = LoadFX( "impacts/flesh_hit" );
		
	
	level._effect["flame_death1"] = loadfx("env/fire/fx_fire_player_sm");
	level._effect["flame_death2"] = loadfx("env/fire/fx_fire_player_torso");
	level._effect["flame_death3"] = loadfx("env/fire/fx_fire_player_sm");	
		
	//level._effect["bunker_inner_fire"] = loadfx("maps/pel1/fx_napalm_midair_burst");//("maps/pel1/fx_beach_bunker_explosion_lg");
	
	//level._effect["bunker_post_explosion"] = loadfx("env/fire/fx_fire_blown_md_blk_smk");	
	
	//level._effect["artillery_ling_smoke"]		= loadfx ("maps/oki2/fx_smoke_artillery_barrage");
}


// --- DALE'S SECTION ---//
precache_createfx_fx()
{
	level._effect["a_cave_drip"]					= loadfx("maps/oki2/fx_rain_drip_cave_tunnel");
	level._effect["a_entrance_drip"]			= loadfx("maps/oki2/fx_drip_entrance");
	level._effect["a_cave_entrance_drip"] = loadfx("maps/oki2/fx_rain_drip_cave_entrance");
	level._effect["a_wtrfall_sm"]					= loadfx("env/water/fx_wtrfall_sm");
	level._effect["a_wtrfall_splash_sm"]	= loadfx("env/water/fx_wtrfall_splash_sm");
	level._effect["a_wtrfall_splash_sm_puddle"]	= loadfx("env/water/fx_wtrfall_splash_sm_puddle");
	level._effect["a_wtrfall_md"]					= loadfx("env/water/fx_wtrfall_md");
	level._effect["a_wtr_spill_sm"]				= loadfx("env/water/fx_wtr_spill_sm");
	level._effect["a_wtr_spill_sm_int"]				= loadfx("env/water/fx_wtr_spill_sm_int");
	level._effect["a_wtr_spill_sm_splash"]	= loadfx("env/water/fx_wtr_spill_sm_splash");
	level._effect["a_wtr_spill_sm_splash_puddle"]	= loadfx("env/water/fx_wtr_spill_sm_splash_puddle");
	level._effect["a_wtr_flow_sm"]				= loadfx("env/water/fx_wtr_flow_sm");
	level._effect["a_wtr_flow_md"]				= loadfx("env/water/fx_wtr_flow_md");
	level._effect["a_water_wake_flow_sm"]	= loadfx("env/water/fx_water_wake_flow_sm");
	level._effect["a_water_wake_flow_md"]	= loadfx("env/water/fx_water_wake_flow_md");
	level._effect["a_water_ripple"]				= loadfx("env/water/fx_water_splash_ripple_puddle");
	level._effect["a_water_ripple_md"]		= loadfx("env/water/fx_water_splash_ripple_puddle_med");
	level._effect["a_water_ripple_aisle"]	= loadfx("env/water/fx_water_splash_ripple_puddle_aisle");
	level._effect["a_water_ripple_line"]	= loadfx("env/water/fx_water_splash_ripple_line");
	level._effect["a_rain_cave_ceiling_hole"]	= loadfx("maps/oki2/fx_rain_cave_ceiling_hole");
	
	level._effect["bunker_explosion"] =				loadfx("maps/oki2/fx_explo_bunker_window");
	level._effect["bunker_side_explosion"] =	loadfx("maps/oki2/fx_explo_bunker_side");
	level._effect["cave_flame_gout"] =				loadfx("maps/oki2/fx_bunker_cave_flame_gout");
	level._effect["bunker_explosion_big"]		= loadfx("maps/oki2/fx_explo_bunker_big");
	
	//level._effect["a_godray_xsm"]	= loadfx("env/light/fx_light_godray_overcast_xsm");
	level._effect["a_godray_sm"]	= loadfx("env/light/fx_light_godray_overcast_sm");
	level._effect["a_godray_md"]	= loadfx("env/light/fx_light_godray_overcast_md");
	level._effect["a_godray_lg"]	= loadfx("env/light/fx_light_godray_overcast_lg");
	//level._effect["a_godray_sm_1side"]	= loadfx("env/light/fx_light_godray_overcast_sm_1sd");
	level._effect["a_godray_md_1side"]	= loadfx("env/light/fx_light_godray_overcast_md_1sd");
	level._effect["a_godray_lg_1side"]	= loadfx("env/light/fx_light_godray_overcast_lg_1sd");
	
	level._effect["a_fire_smoke_med"] = loadfx("env/fire/fx_fire_house_md_jp");
	level._effect["a_fire_smoke_med_dist"] = loadfx("env/fire/fx_fire_smoke_md_dist_jp");
	level._effect["a_fire_smoke_sm_dist"] = loadfx("env/fire/fx_fire_smoke_sm_dist_jp");
	level._effect["a_fire_smoke_med_int"] = loadfx("env/fire/fx_fire_md_low_smk_jp");
	level._effect["a_fire_brush_smldr_sm"] = loadfx("env/fire/fx_fire_brush_smolder_sm_jp");
	//level._effect["a_fire_brush_smldr_md"] = loadfx("env/fire/fx_fire_brush_smolder_md_jp");
	level._effect["a_fire_rubble_sm_jp"]	= loadfx("env/fire/fx_fire_rubble_sm_jp");
	level._effect["a_fire_rubble_detail_md"]	= loadfx("env/fire/fx_fire_rubble_detail_md_jp");
	level._effect["a_fire_rubble_smolder_sm_jp"]	= loadfx("env/fire/fx_fire_rubble_smolder_sm_jp");
	//level._effect["a_fire_tree_smldr_sm"] = loadfx("env/fire/fx_fire_tree_smolder_sm_jp");
	//level._effect["a_fire_tree_sm"] = loadfx("env/fire/fx_fire_tree_sm_jp");
	level._effect["a_fire_brush_detail"] = loadfx("env/fire/fx_fire_rubble_detail_jp");
	level._effect["a_fire_150x600_distant"]	= loadfx("env/fire/fx_fire_150x600_tall_distant_jp");
	
	level._effect["a_ground_fog"]					= loadfx("env/smoke/fx_battlefield_smokebank_ling_foggy_w");
	level._effect["a_ground_smoke"]					= loadfx("env/smoke/fx_battlefield_smokebank_ling_foggy");
	level._effect["a_cratersmoke"]				= loadfx("env/smoke/fx_smoke_crater_w");
	level._effect["a_smoke_smolder"]			= loadfx("env/smoke/fx_smoke_impact_smolder");
	level._effect["a_background_smoke"]		= loadfx("maps/oki2/fx_smoke_slow_black_windblown");
	level._effect["a_smk_column_md_blk_dir"]		= loadfx("env/smoke/fx_smk_column_md_blk_dir");
	level._effect["a_smoke_plume_lg_slow_def"]	= loadfx("env/smoke/fx_smoke_plume_lg_slow_def");
	level._effect["a_smoke_smolder_md_gry"]	= loadfx("env/smoke/fx_smoke_smolder_md_gry");
	//level._effect["artillery_ling_smoke"]		= loadfx ("maps/oki2/fx_smoke_artillery_barrage");
	level._effect["a_rainbow"]	= loadfx("env/weather/fx_rainbow");
}

// footsteps()
// {
// 	clientscripts\_utility::setFootstepEffect( "asphalt",    LoadFx( "bio/player/fx_footstep_dust" ) );
// 	clientscripts\_utility::setFootstepEffect( "brick",      LoadFx( "bio/player/fx_footstep_dust" ) );
// 	clientscripts\_utility::setFootstepEffect( "carpet",     LoadFx( "bio/player/fx_footstep_dust" ) );
// 	clientscripts\_utility::setFootstepEffect( "cloth",      LoadFx( "bio/player/fx_footstep_dust" ) );
// 	clientscripts\_utility::setFootstepEffect( "concrete",   LoadFx( "bio/player/fx_footstep_dust" ) );
// 	clientscripts\_utility::setFootstepEffect( "dirt",       LoadFx( "bio/player/fx_footstep_sand" ) );
// 	clientscripts\_utility::setFootstepEffect( "foliage",    LoadFx( "bio/player/fx_footstep_dust" ) );
// 	clientscripts\_utility::setFootstepEffect( "gravel",     LoadFx( "bio/player/fx_footstep_sand" ) );
// 	clientscripts\_utility::setFootstepEffect( "grass",      LoadFx( "bio/player/fx_footstep_sand" ) );
// 	clientscripts\_utility::setFootstepEffect( "ice",        LoadFx( "bio/player/fx_footstep_snow" ) );
// 	clientscripts\_utility::setFootstepEffect( "metal",      LoadFx( "bio/player/fx_footstep_dust" ) );
// 	clientscripts\_utility::setFootstepEffect( "mud",        LoadFx( "bio/player/fx_footstep_mud" ) );
// 	clientscripts\_utility::setFootstepEffect( "paper",      LoadFx( "bio/player/fx_footstep_dust" ) );
// 	clientscripts\_utility::setFootstepEffect( "plaster",    LoadFx( "bio/player/fx_footstep_dust" ) );
// 	clientscripts\_utility::setFootstepEffect( "rock",       LoadFx( "bio/player/fx_footstep_sand" ) );
// 	clientscripts\_utility::setFootstepEffect( "sand",       LoadFx( "bio/player/fx_footstep_sand" ) );
// 	clientscripts\_utility::setFootstepEffect( "snow",       LoadFx( "bio/player/fx_footstep_snow" ) );
// 	clientscripts\_utility::setFootstepEffect( "water",      LoadFx( "bio/player/fx_footstep_water" ) );
// 	clientscripts\_utility::setFootstepEffect( "wood",       LoadFx( "bio/player/fx_footstep_dust" ) );
// }


main()
{
	clientscripts\createfx\oki2_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_util_fx();
 	//footsteps();
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}