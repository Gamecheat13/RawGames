#include common_scripts\utility;
#include common_scripts\_fx;

main()
{
	script_fx();
	airlift();
	createfx_ambient_fx();
	level thread treadfx_override();	
	if ( !getdvarint( "r_reflectionProbeGenerate" ) )
		maps\createfx\prague_escape_fx::main();
}

script_fx()
{
	// section 1
	level._effect[ "soap_steam" ]	= LoadFX( "smoke/soap_steam" );
	level._effect[ "paper_fx" ]	= LoadFX( "dust/heli_paper_kickup" );	
	level._effect[ "pigeon_gibs" ]	= LoadFX( "props/chicken_exp_white" );
	level._effect[ "suv_headlight_l" ]	= LoadFX( "lights/car_headlight_suburban_l" );
	level._effect[ "suv_headlight_r" ]	= LoadFX( "lights/car_headlight_suburban_r" );
	level._effect[ "suv_taillight_l" ]	= LoadFX( "lights/car_taillight_suburban_l" );
	level._effect[ "suv_taillight_r" ]	= LoadFX( "lights/car_taillight_suburban_r" );
	level._effect[ "tire_smoketrail" ]	= LoadFX( "maps/paris/sedan_tire_smoketrail" );
	
	level._effect[ "suv_explosion" ]		= LoadFX( "explosions/vehicle_explosion_t90_cheap" );
	level._effect[ "grenade_exp_concrete" ]	= LoadFX( "explosions/grenadeExp_concrete_1" );
	level._effect[ "bullet_geo" ]			= LoadFX( "smoke/smoke_geotrail_barret_prague_esc" );
	
	level._effect[ "dust_fall_soap_chest" ]			= LoadFX("dust/dust_fall_soap_chest");	// Attach and orient to J_Spine4. Oneshot.
	level._effect[ "blood_cough_heavy" ]			= LoadFX( "misc/blood_cough_heavy" );	// Play on TAG_EYE
	level._effect[ "blood_cough_mild" ]				= LoadFX( "misc/blood_cough_mild" );	// Play on TAG_EYE
	level._effect[ "FX_soap_walk_blood_drip" ]		= LoadFX( "misc/blood_drip_walk_heavy_soap" );
	level._effect[ "FX_soap_walk_blood_smear" ]		= LoadFX( "misc/blood_smear_walk_heavy_soap" );
	level._effect[ "FX_soap_sit_blood_pool" ]		= LoadFX( "misc/blood_pool_soap" );
	level._effect[ "FX_soap_sit_blood_pool_small" ]	= LoadFX( "misc/blood_pool_small_soap" );
	
	level._effect["smoke_grenade_prague"]		= LoadFX( "smoke/smoke_grenade_cheap" );
	level._effect[ "smoke_grenade_streamer" ]	= LoadFX( "smoke/smoke_grenade_streamer_prague_escape" );
	
	level._effect[ "muzzleflash_heavy" ]	= LoadFX( "muzzleflashes/heavy" );
	level._effect[ "geotrail_m203" ]		= LoadFX( "smoke/smoke_geotrail_m203_prague_esc" );
	
	level._effect[ "geotrail_m203" ]		= LoadFX( "smoke/smoke_geotrail_m203_prague_esc" );
	level._effect[ "cloud_bank_a" ] 		= LoadFX( "weather/cloud_bank_a" );
	level._effect[ "sunflare_intro_large" ] = LoadFX( "lights/sunflare_intro_large" );
			
	// section 2
	level._effect[ "lamp_sparks" ]				= LoadFX( "props/lamp_table1_sparks" );
	level._effect["btr_cannon_impact_burst"]	= LoadFX( "impacts/btr_cannon_impact_burst" );	// Play 200 units away from the target. Aim +X in the direction of fire.
	level._effect["lion_statue_dest"]			= LoadFX( "misc/statue_lion_break_prague_esc" );
	level._effect[ "firehydrant_leak" ]			= LoadFX( "props/firehydrant_leak" );
	level._effect[ "hedgea_dest" ] 				= LoadFX( "props/foliage_hedge_rounded_1_dest" );
	level._effect[ "hedgeb_dest" ] 				= LoadFX( "props/foliage_hedge_rounded_2_dest" );
	level._effect[ "crate_dest" ] 				= LoadFX( "props/crate32x48_dest" );
	
	
	// section 3
	level._effect[ "btr_spotlight" ]			= LoadFX( "misc/spotlight_btr80" );
	level._effect[ "spotlight_btr80_daytime" ]	= LoadFX( "misc/spotlight_btr80_daytime" );
		
	level._effect[ "bullet_geo_flashback" ]		 = LoadFX( "smoke/smoke_geotrail_barret_prague_esc_fb" );
	
	level._effect[ "blood" ]			= LoadFX( "impacts/sniper_escape_blood" );
	level._effect[ "blood_pool" ]		= LoadFX( "impacts/deathfx_bloodpool" );
	level._effect[ "zak_arm_blood" ]	= LoadFX( "misc/blood_zakhaev_arm_prague_esc" );
	
	level._effect[ "sniper_glint" ] 				= LoadFX( "misc/scope_glint_prague_esc" );
	level._effect[ "glass_exit_car_flashback" ]		= LoadFX( "impacts/glass_exit_car_flashback_prague_esc" );	// Attach and orient to vehicle's TAG_ORIGIN
	level._effect[ "car_impact_1_flashback" ]		= LoadFX( "impacts/car_impact_1_flashback_prague_esc" );	// Attach and orient to vehicle's TAG_ORIGIN
	level._effect[ "car_impact_2_flashback" ]		= LoadFX( "impacts/car_impact_2_flashback_prague_esc" );	// Attach and orient to vehicle's TAG_ORIGIN
  	level._effect[ "sniper_muzzle_flash" ]			= LoadFX( "muzzleflashes/bmp_flash_wv" );

	//cobra crash
	level._effect[ "chopper_smoke_trail" ]		 	= LoadFX( "fire/fire_smoke_trail_L" );
	level._effect[ "heli_aerial_explosion_large" ]	= LoadFX( "explosions/aerial_explosion_large" );
	level._effect[ "nuked_chopper_explosion" ] 		= LoadFX( "explosions/aerial_explosion" );
	level._effect[ "FX_nuke_background_explosion" ]	= LoadFX( "explosions/cluster_exp_variation_runner_ac130_paris" );
		
	// general
	level._effect[ "flesh_hit" ]		= LoadFX( "impacts/flesh_hit" );
	level._effect[ "ai_blood_splash" ]  = LoadFx( "misc/ai_mowdown" );
	level._effect[ "cobra_treadfx" ] 	= LoadFx( "treadfx/heli_dust_looping_prague_esc" );
	
	// no russian
	level._effect["blood_handprint"]					= LoadFX( "impacts/blood_smear_hand" );
	level._effect["desert_eagle_flash"]					= LoadFX( "muzzleflashes/desert_eagle_flash_wv_a" );
	level._effect[ "FX_airport_civ_headshot_impact" ]	= LoadFX( "maps/dubai/yuri_headshot_blood" );
	level._effect[ "FX_airport_civ_headshot_trail" ]	= LoadFX( "maps/warlord/execution_blood_fx_2" );
}

airlift()
{
	level._effect[ "nuke_explosion" ]	 	= LoadFX( "explosions/nuke_explosion" ); // Exploder ID 666
	level._effect[ "nuke_flash" ]	 		= LoadFX( "explosions/nuke_flash" ); // Exploder ID 666
	level._effect[ "nuke_dirt_shockwave" ]	= LoadFX( "explosions/nuke_dirt_shockwave" ); // Exploder ID 666
	level._effect[ "nuke_smoke_fill" ]	 	= LoadFX( "explosions/nuke_smoke_fill" ); // Exploder ID 666

}

// Ambient effects placed via CreateFX- THESE ARE CARRIED OVER FROM PRAGUE_A. This will be pruned down to what is needed and custom ones added.
createfx_ambient_fx()
{
// prefixed effects with "fx_" so I know which ones are ambient/exploders
	
	level._effect["fx_window_fire_large_smoke"]			= LoadFX( "fire/window_fire_large_short_smoke" );
	level._effect["fx_firelp_med_pm_dist"]				= LoadFX( "fire/church_fire_large" );
	level._effect["fx_trash_spiral_runner"]				= LoadFX( "misc/trash_spiral_runner" );
	level._effect["fx_ambient_ground_smoke"]			= LoadFX( "weather/ambient_ground_fog_prague_esc" );
	
	level._effect["fx_fire_generic_atlas"]				= LoadFX( "fire/fire_generic_atlas");
	level._effect["fx_fire_generic_ball_thick"]			= LoadFX( "fire/hotel_window_fire_lg_prague_esc");
	level._effect["fx_fire_generic_ball_burst_large"]	= LoadFX( "fire/hotel_window_fire_lg_prague_esc");
	level._effect["fx_fire_generic_ball_burst"]			= LoadFX( "fire/hotel_window_fire_sm_prague_esc");
	level._effect["fx_fire_generic_atlas_smoke"]		= LoadFX( "fire/fire_generic_atlas_smoke");
	level._effect["hotel_after_exp_embers"]		      = LoadFX( "fire/hotel_after_exp_embers");	
	level._effect["fire_falling_runner_point_far"]		              = LoadFX( "fire/fire_falling_runner_point_far");
	level._effect["tower_exp_fire_prague_esc"]		              = LoadFX( "fire/tower_exp_fire_prague_esc");	
	level._effect[ "firelp_cheap_mp" ] 								          = LoadFX( "fire/firelp_cheap_mp" );	
	level._effect[ "debris_pile_smoke_hang_hamburg" ] 		  = LoadFX( "dust/debris_pile_smoke_hang_hamburg" );	
	level._effect[ "wall_breach_prague_esc" ] 					    = LoadFX( "explosions/wall_breach_prague_esc" );	
	level._effect[ "room_dust_200_mp_vacant" ]						  = LoadFX( "dust/room_dust_200_blend_mp_vacant" );	
	level._effect[ "room_dust_200_z150_mp" ]						    = LoadFX( "dust/room_dust_200_z150_mp" );		
	level._effect[ "car_fire_mp" ] 									        = LoadFX( "fire/car_fire_mp" ); 	
	level._effect[ "thin_black_smoke_hamburg" ]						  = LoadFX( "smoke/thin_black_smoke_hamburg" );
	level._effect[ "insects_light_hunted" ] 						    = LoadFX( "misc/insects_light_hunted" );	
	level._effect[ "falling_dirt_hamburg_runner" ] 				= LoadFX( "dust/falling_dirt_hamburg_runner" );	
	level._effect["church_fire_large"]				              = LoadFX( "fire/church_fire_large" );	
	level._effect[ "insects_carcass_flies" ] 		            = LoadFX( "misc/insects_carcass_flies" );	
	level._effect[ "burned_vehicle_sparks_hamburg" ] 				= LoadFX( "fire/burned_vehicle_sparks_hamburg" );		
	level._effect[ "debris_pile_smoke_hang_hamburg" ] 		= LoadFX( "dust/debris_pile_smoke_hang_hamburg" );
	level._effect[ "rpg_wall_impact_prague_esc" ] 					    = LoadFX( "explosions/rpg_wall_impact_prague_esc" );	
	level._effect[ "falling_dirt_hamburg_runner" ] 				= LoadFX( "dust/falling_dirt_hamburg_runner" );	
	level._effect["building_fire_thick_tower_prague_esc"]	= LoadFX( "fire/building_fire_thick_tower_prague_esc" );			
	level._effect[ "nuke_dirt_shockwave_prague_esc" ] 					    = LoadFX( "explosions/nuke_dirt_shockwave_prague_esc" );
	level._effect[ "nuke_smoke_fill_prague_esc" ] 					        = LoadFX( "explosions/nuke_smoke_fill_prague_esc" );				
	level._effect[ "nuke_explosion_prague_esc" ] 					        = LoadFX( "explosions/nuke_explosion_prague_esc" );
	level._effect[ "nuke_flash_prague_esc" ] 					        = LoadFX( "explosions/nuke_flash_prague_esc" );	
	level._effect[ "after_nuke_ash_prague_esc" ] 					        = LoadFX( "explosions/after_nuke_ash_prague_esc" );		
	level._effect[ "after_nuke_grass_prague_esc" ] 					        = LoadFX( "explosions/after_nuke_grass_prague_esc" );			
	level._effect[ "dust_spray_detail_oriented_runner" ] 		        = LoadFX( "dust/dust_spray_detail_oriented_runner" );			
	level._effect[ "building_edge_dust_spray_runner" ] 		        = LoadFX( "dust/building_edge_dust_spray_runner" );
	level._effect[ "leaves_fall_gentlewind_prague_esc" ] 						          = LoadFX( "misc/leaves_fall_gentlewind_prague_esc" );	
	level._effect[ "building_fire_hamburg_thick_tower_small" ]		= LoadFX( "fire/building_fire_hamburg_thick_tower_small" );	
	level._effect[ "falling_dirt_dark_2_runner_prague_esc" ] 		     	   = loadfx( "dust/falling_dirt_dark_2_runner_prague_esc" );	
	level._effect[ "lights_uplight_haze" ]						                   = loadfx( "lights/lights_uplight_haze" );	
	level._effect[ "cellar_light_smoke_prague_esc" ] 		                 = LoadFX( "smoke/cellar_light_smoke_prague_esc" );
	level._effect[ "snow_spray_detail_oriented_runner" ]					       = loadfx( "snow/snow_spray_detail_oriented_runner" );	
	level._effect[ "distant_mushroom_cloud_prague_esc" ] 					       = LoadFX( "explosions/distant_mushroom_cloud_prague_esc" );
	level._effect[ "abrams_flare_runner" ] 		                           = LoadFX( "fire/abrams_flare_runner" );	
	level._effect[ "medium_fire_far_prague_esc" ] 		                   = LoadFX( "fire/medium_fire_far_prague_esc" );
	level._effect[ "small_fire_far_prague_esc" ] 		                     = LoadFX( "fire/small_fire_far_prague_esc" );	
	level._effect[ "trash_spiral_far_runner_prague_esc" ] 						   = LoadFX( "misc/trash_spiral_far_runner_prague_esc" );		
	level._effect[ "after_tower_exp_debris" ] 		                       = LoadFX( "dust/after_tower_exp_debris" );	
	level._effect[ "leaves_runner_pine" ] 						                   = LoadFX( "misc/leaves_runner_pine" );
	level._effect[ "dubai_lights_glow_white" ] 						               = LoadFX( "lights/dubai_lights_glow_white" );	
														

	// Exploders
	level._effect["fx_pigeon_plaza_static_sm"]											= LoadFX( "animals/pigeon_plaza_static_sm" );	// Exploder ID 105
	level._effect["fx_hotel_window_smash"]													= LoadFX( "explosions/window_exp_glass_strong" );	//Exploder ID 150,250,740
	level._effect["fx_flashbang_hotel"]															= LoadFX( "explosions/flashbang_prague_escape" );	// Exploder ID 151
	level._effect["fx_room_smokey_hotel"]														= LoadFX( "smoke/room_smoke_200" );	// Exploder ID 151
	level._effect["fx_red_light_blink_hotel"]												= LoadFX( "lights/lights_strobe_red_prague_escape" );	// Exploder ID 155
	level._effect["fx_pigeon_plaza_panic_takeoff_lg"]								= LoadFX( "animals/pigeon_plaza_takeoff_lg" );	// Exploder ID 160
	level._effect["fx_pigeon_plaza_takeoff_lg_rt"]									= LoadFX("animals/pigeon_plaza_takeoff_lg_rt");	// Exploder ID 160
	level._effect["fx_pigeon_plaza_panic_takeoff_sm"]								= LoadFX( "animals/pigeon_plaza_takeoff_sm" );	// Exploder ID 160		
	level._effect["fx_explosion_hotel_main"]												= LoadFX( "explosions/building_explosion_hotel_prague_esc" );	// Exploder ID 160
	level._effect["fx_building_debris_dust_impact_prague_esc"]			= LoadFX("dust/building_debris_dust_impact_prague_esc");	// Exploder ID 160
	level._effect["fx_explosion_hotel_filler"]											= LoadFX( "explosions/building_explosion_london" );	// Exploder ID 160
	
	level._effect["fx_red_light_blink_belltower"]										= LoadFX( "lights/lights_strobe_red_prague_escape" );	// Exploder ID 209
	level._effect["fx_explosion_belltower_main"]										= LoadFX( "explosions/belltower_exp_prague_esc" ); // Exploder ID 210
	level._effect["fx_body_impact_scaffolding"]											= LoadFX( "impacts/body_fall_scaffolding_prague_esc" ); // Exploder ID 220, 221, 222
	level._effect["fx_scaffolding_crash_dust_prague_esc"]						= LoadFX( "dust/scaffolding_crash_dust_prague_esc");	// Exploder ID 224
	level._effect["fx_bell_ground_impact"]													= LoadFX( "dust/scaffolding_dust_wood_debris_lg" ); // Exploder ID 225
	level._effect["fx_blood_decal_soap_fall"]												= LoadFX("misc/blood_decal_soap_fall");	// Exploder ID 226
	level._effect["fx_scaffolding_falling_dust"]										= LoadFX( "dust/scaffolding_falling_dust");					// Exploder ID 227
	level._effect["fx_dust_debris_unsettled"]												= LoadFX("dust/dust_debris_unsettled");	// Exploder ID 230
	level._effect["fx_tankshell_wallImpact"]												= LoadFX( "explosions/tankshell_wallImpact");	// Exploder ID 250
	level._effect["fx_wall_exp_rpg"]																= LoadFX( "explosions/wall_exp_rpg");	// Exploder ID 280
	
	level._effect["fx_blood_smear_back_prague_esc"]									= LoadFX( "impacts/blood_smear_back_prague_esc");	// Exploder ID 310
	
	level._effect["fx_door_kick"]																		= LoadFX( "dust/door_kick" ); // Exploder ID 420,608,610
	level._effect["fx_box_push_body_impact"]												= LoadFX( "props/box_impact_bodyfall_prague_esc" ); // Exploder ID 425
	
	level._effect["fx_blood_smear_back_rotated_prague_esc"]					= LoadFX( "impacts/blood_smear_back_rotated_prague_esc");	// Exploder ID 501, 601, 801
	
	level._effect["fx_fence_crush_lg"]															= LoadFX( "misc/fence_metal_crush_lg_prague_esc" ); // Exploder ID 820
	level._effect["fx_fence_crush_debris"]													= LoadFX( "misc/fence_metal_kickup_prague_esc" ); // Exploder ID 820
	level._effect["fx_metal_hoop_fall"]															= LoadFX( "misc/metal_hoop_fall_prague_esc" ); // Exploder ID 822
	level._effect["fx_window_blowout"]															= LoadFX( "misc/debris_window_blowout" ); // Exploder ID 830	
	level._effect["fx_leaf_fall_impact"]														= LoadFX( "misc/leaves_branch_impact_prague_esc" ); // Exploder ID 850,851,852,853,854,855,856,857
	level._effect["fx_rpg_basketball"]															= LoadFX( "explosions/rpg_basketball_prague_esc" ); // Exploder ID 860,861
	
	// Soap Death: 11
	level._effect["fx_window_shatter_prague_esc"]			= LoadFX( "breakables/window_shatter_prague_esc");		// Exploder ID 1100
	level._effect["fx_window_barrage_blinds_prague_esc"]	= LoadFX("impacts/window_barrage_blinds_prague_esc");	// Exploder ID 1101, 1102, 1103
	level._effect["fx_wall_barrage_angled"]					= LoadFX("impacts/wall_barrage_angled");				// Exploder ID 1121, 1122, 1123
	level._effect["fx_window_barrage_prague_esc"]			= LoadFX( "impacts/window_barrage_prague_esc");			// Exploder ID 1111, 1112, 1113
	level._effect["fx_deathfx_bloodpool_soap"]				= LoadFX( "impacts/deathfx_bloodpool_soap");			// Exploder ID 1105
	level._effect["fx_deathfx_bloodpool_soap_loop"]			= LoadFX("impacts/deathfx_bloodpool_soap_loop");		// Exploder ID 1105
	level._effect["fx_blood_drip_heavy_soap"]				= LoadFX( "misc/blood_drip_heavy_soap");				// Exploder ID 1105
	level._effect["fx_window_godray_blinds_dusty"]			= LoadFX("lights/window_godray_blinds_dusty");
	
	// Nuke flashback: 14
	level._effect[ "fx_fb_thin_black_smoke_M" ]			= LoadFX( "smoke/thin_black_smoke_M" );	// Exploder ID 1401
	level._effect[ "fx_fb_thin_black_smoke_L" ]			= LoadFX( "smoke/thin_black_smoke_L" );	// Exploder ID 1401
	level._effect[ "fx_fb_antiair_runner" ]				= LoadFX( "misc/antiair_runner_night" );// Exploder ID 1402
	level._effect[ "fx_fb_firelp_small_dl_a" ]			= LoadFX( "fire/firelp_small_dl_a" );	// Exploder ID 1404
	level._effect[ "fx_fb_firelp_small_dl_b" ]			= LoadFX( "fire/firelp_small_dl_b" );	// Exploder ID 1404
	level._effect[ "fx_fb_firelp_small_dl_d" ]			= LoadFX( "fire/firelp_small_dl_d" );	// Exploder ID 1404
	level._effect[ "fx_fb_battlefield_smokebank_S" ]	= LoadFX( "smoke/battlefield_smokebank_bog_a" );
	
}

treadfx_override()
{
	maps\_treadfx::setvehiclefx( "cobra", "dirt", "treadfx/heli_dust_large" );
}

