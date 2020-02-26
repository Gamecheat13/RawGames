#include maps\_utility; 
#include common_scripts\utility;
#using_animtree("fxanim_props");

main()
{	
	initModelAnims();
	precache_scripted_fx();
	precache_createfx_fx();
	wind_init();
	footsteps();
	
	// calls the createfx server script (i.e., the list of ambient effects and their attributes)
	maps\createfx\angola_2_fx::main();
}

// Scripted effects
precache_scripted_fx()
{
	//level._effect["fx_ango_intro_truck_fade"]	= loadFX("maps/angola/fx_ango_intro_truck_fade");

	//level._effect["drone_impact"] = LoadFX("impacts/fx_deathfx_drone_gib");
	
	//level._effectType["mortar_savannah"] = "mortar";
	//level._effect["mortar_savannah"]	= LoadFX("maps/angola/fx_ango_explosion_child");
	
	level._effect[ "ship_explosion" ]			= LoadFX( "maps/angola/fx_ango_ship_explosion" );
	level._effect[ "ship_fire" ] = LoadFx( "maps/angola/fx_ango_ship_fire" );
	level._effect[ "heli_fire" ] = LoadFx( "maps/angola/fx_ango_heli_fire_crash" );
	level._effect[ "turret_explosion" ] = LoadFX( "maps/angola/fx_ango_turret_exp" );
	level._effect[ "aircraft_flares" ] = LoadFX( "vehicle/vexplosion/fx_heli_chaff_flares" );
	level._effect[ "medium_boat_explosion" ] = LoadFX( "maps/angola/fx_ango_exp_med_boat" );
	level._effect[ "medium_boat_damage" ] = LoadFX( "maps/angola/fx_ango_sparks_med_boat" );
	level._effect[ "water_explosion" ] = LoadFX( "maps/angola/fx_ango_water_explosion" );
	level._effect[ "small_flak" ] = LoadFX( "maps/angola/fx_ango_exp_flak_sml" );
	level._effect[ "medium_flak" ] = LoadFX( "maps/angola/fx_ango_exp_flak_med" );
	level._effect[ "large_flak" ] = LoadFX( "maps/angola/fx_ango_exp_flak_lrg" );
	level._effect[ "hind_damage" ] = LoadFX( "maps/angola/fx_ango_hind_damage" );
	level._effect[ "hind_rotor_damage"] = Loadfx("maps/angola/fx_ango_heli_fire_crash_2");
	level._effect[ "barge_sinking" ] = LoadFx("maps/angola/fx_ango_water_barge_sink_main");
	level._effect[ "woods_cough_water" ] = LoadFx("maps/angola/fx_ango_cough_water");
	level._effect[ "barge_aft_exp" ] = LoadFx("maps/angola/fx_ango_barge_aft_exp");
	level._effect[ "barge_wheelhouse_exp" ] = LoadFx("maps/angola/fx_ango_barge_wheelhouse_exp");
	level._effect[ "barge_woods_exp" ] = LoadFx("maps/angola/fx_ango_barge_woods_exp");
	level._effect[ "barge_truck_exp" ] = LoadFx("maps/angola/fx_ango_barge_truck_exp");
	level._effect[ "barge_truck_exp_2" ] = LoadFx("maps/angola/fx_ango_barge_truck_exp_2");
	level._effect[ "barge_truck_quarter_explosion" ] = LoadFx("maps/angola/fx_ango_barge_crew_quarter_exp");
	
	level._effect[ "medium_boat_second_explosion" ] = LoadFx("maps/angola/fx_ango_sparks_med_boat_2");
	
	level._effect[ "small_boat_damage_1" ] = LoadFX( "maps/angola/fx_ango_small_boat_damage_1" );
	level._effect[ "small_boat_damage_2" ] = LoadFX( "maps/angola/fx_ango_small_boat_damage_2" );

	
	level._effect[ "medium_boat_damage_1" ] = LoadFX( "maps/angola/fx_ango_damage_med_boat_ai" );
	level._effect[ "medium_boat_damage_2" ] = LoadFX( "maps/angola/fx_ango_damage_med_boat_ai_2" );
	
	                                            
	level._effect[ "head_blood" ] = LoadFx( "maps/angola/fx_ango_blood_head" );
	
	level._effect[ "fx_ango_container_light" ] = LoadFx( "maps/angola/fx_ango_container_light" );
	
	level._effect[ "water_splash_effect" ] = LoadFx( "maps/angola/fx_ango_wake_player" );
	
	//air trail
	
	level._effect[ "air_trail" ] = LoadFx( "maps/angola/fx_ango_motion_lines" );
	level._effect[ "heli_trail" ] = LoadFx("maps/angola/fx_ango_motion_lines_heli");
	                                            
}


// Ambient effects
precache_createfx_fx()
{
//jungle fx
	level._effect["fx_ango_heli_fire"]	= loadFX("maps/angola/fx_ango_heli_fire");
	level._effect["fx_ango_fire_hut"]	= loadFX("maps/angola/fx_ango_fire_hut");
	level._effect["fx_elec_ember_shower_os_int_runner"]	= loadFX("electrical/fx_elec_ember_shower_os_int_runner");
	level._effect["fx_ango_fire_sm"]	= loadFX("maps/angola/fx_ango_fire_sm");
	level._effect["fx_ango_falling_fire"]	= loadFX("maps/angola/fx_ango_falling_fire");
	level._effect["fx_ango_godray_smoke_large"]	= loadFX("maps/angola/fx_ango_godray_smoke_large");
	level._effect["fx_ango_godray_md"]	= loadFX("maps/angola/fx_ango_godray_md");
	level._effect["fx_ango_falling_ash"]	= loadFX("maps/angola/fx_ango_falling_ash");
	level._effect["fx_ango_steam_body"]	= loadFX("maps/angola/fx_ango_steam_body");
	level._effect["fx_ango_lingering_dust_sml"]	= loadFX("maps/angola/fx_ango_lingering_dust_sml");
	level._effect["fx_ango_blowing_dust"]	= loadFX("maps/angola/fx_ango_blowing_dust");
	level._effect["fx_ango_waterfall_bottom"]	= loadFX("maps/angola/fx_ango_waterfall_bottom");
	level._effect["fx_ango_water_ripples"]	= loadFX("maps/angola/fx_ango_water_ripples");
	level._effect["fx_birds_circling"]	= loadFX("bio/animals/fx_birds_circling");
	level._effect["fx_ango_birds_circling_jungle"]	= loadFX("maps/angola/fx_ango_birds_circling_jungle");
	level._effect["fx_ango_birds_runner"]	= loadFX("maps/angola/fx_ango_birds_runner");
	level._effect["fx_ango_birds_runner_single"]	= loadFX("maps/angola/fx_ango_birds_runner_single");
	level._effect["fx_ango_leaves_falling_exploder"]	= loadFX("maps/angola/fx_ango_leaves_falling_exploder");
	level._effect["fx_insects_fly_swarm"]	= loadFX("bio/insects/fx_insects_fly_swarm");
	level._effect["fx_leaves_falling_lite_sm"]	= loadFX("maps/angola/fx_ango_leaves_falling");
	level._effect["fx_ango_grass_blowing"]	= loadFX("maps/angola/fx_ango_grass_blowing");
	level._effect["fx_insects_dragonflies_ambient"]	= loadFX("bio/insects/fx_insects_dragonflies_ambient");
	level._effect["fx_insects_butterfly_flutter"]	= loadFX("bio/insects/fx_insects_butterfly_flutter");
	level._effect["fx_insects_moths_flutter"]	= loadFX("bio/insects/fx_insects_moths_flutter");	
	//level._effect["fx_ango_dust_1_blocker"]	= loadFX("maps/angola/fx_ango_dust_1_blocker");
	level._effect["fx_ango_animal_dust"]	= loadFX("maps/angola/fx_ango_animal_dust");
	level._effect["fx_ango_river_wake_lrg"]	= loadFX("maps/angola/fx_ango_river_wake_lrg");
	level._effect["fx_ango_river_wake_med"]	= loadFX("maps/angola/fx_ango_river_wake_med");
	level._effect["fx_ango_river_wake_sml"]	= loadFX("maps/angola/fx_ango_river_wake_sml");
	level._effect["fx_ango_exp_rock_wall"]	= loadFX("maps/angola/fx_ango_exp_rock_wall");
	level._effect["fx_ango_exp_village_wall"]	= loadFX("maps/angola/fx_ango_exp_village_wall");
	level._effect["fx_ango_exp_village_wall_2"]	= loadFX("maps/angola/fx_ango_exp_village_wall_2");
	level._effect["fx_ango_exp_village_glass"]	= loadFX("maps/angola/fx_ango_exp_village_glass");
	level._effect["fx_ango_exp_rock_water_impact"]	= loadFX("maps/angola/fx_ango_exp_rock_water_impact");
	level._effect["fx_ango_exp_rock_dirt_impact"]	= loadFX("maps/angola/fx_ango_exp_rock_dirt_impact");
	level._effect["fx_ango_waterfall_sm"]	= loadFX("maps/angola/fx_ango_waterfall_sm");
	level._effect["fx_ango_waterfall_med"]	= loadFX("maps/angola/fx_ango_waterfall_med");
	level._effect["fx_ango_water_splash_player"]	= loadFX("maps/angola/fx_ango_water_splash_player");
	level._effect["fx_ango_shore_water"]	= loadFX("maps/angola/fx_ango_shore_water");
	level._effect["fx_ango_water_barge_sink_ext"]	= loadFX("maps/angola/fx_ango_water_barge_sink_ext");
	level._effect["fx_lf_angola2_sun1"]	= loadFX("lens_flares/fx_lf_angola2_sun1");
	
	//outro fx
	level._effect["fx_ango_outro_leaf_exploder"]	= loadFX("maps/angola/fx_ango_outro_leaf_exploder");
	level._effect["fx_ango_outro_tree_foliage"]	= loadFX("maps/angola/fx_ango_outro_tree_foliage");
	level._effect["fx_ango_outro_missile_foliage"]	= loadFX("maps/angola/fx_ango_outro_missile_foliage");
	level._effect["fx_ango_outro_impact_foliage"]	= loadFX("maps/angola/fx_ango_outro_impact_foliage");	
	level._effect["fx_ango_outro_impact_tree"]	= loadFX("maps/angola/fx_ango_outro_impact_tree");
	
	//river fx
	level._effect["fx_ango_river_fog"]	= loadFX("maps/angola/fx_ango_river_fog");
	level._effect["fx_ango_river_fog_2"]	= loadFX("maps/angola/fx_ango_river_fog_2");
	level._effect["fx_ango_river_intro_birds"]	= loadFX("maps/angola/fx_ango_river_intro_birds");
	level._effect["fx_ango_river_intro_birds_near"]	= loadFX("maps/angola/fx_ango_river_intro_birds_near");
	level._effect["fx_ango_river_waterfall_giant"]	= loadFX("maps/angola/fx_ango_river_waterfall_giant");
	level._effect["fx_ango_river_waterfall_giant_2"]	= loadFX("maps/angola/fx_ango_river_waterfall_giant_2");
	

	// Section 3 - Explosion as the Hind shoots the jungle
	level._effect["def_explosion"] = LoadFX( "maps/angola/fx_ango_outro_missile_foliage" );
	level._effect["def_muzzle_flash"] = loadFX( "weapon/muzzleflashes/fx_standard_flash" );
	level._effect["neckstab_stand_blood"] = LoadFX("impacts/fx_melee_neck_stab");

	level._effect["smoketrail"] = LoadFX( "maps/afghanistan/fx_afgh_bullet_trail_sniper" );

	level._effect["woods_muzzleflash"] = LoadFX( "maps/angola/fx_ango_woods_muzzleflash" );
}


wind_init()
{
	SetSavedDvar( "wind_global_vector", "142 96 0" );    // wind vector                                
	SetSavedDvar( "wind_global_low_altitude", -100);    // wind's lower bound                            
	SetSavedDvar( "wind_global_hi_altitude", 1775);    // wind's upper bound                             
	SetSavedDvar( "wind_global_low_strength_percent", 0.4);    // wind strength percentage at lower bound

}


// FXanim Props
initModelAnims()
{
	level.scr_anim["fxanim_props"]["barge_wheelhouse"] = %fxanim_angola_barge_wheelhouse_anim;
	level.scr_anim["fxanim_props"]["barge_aft_debris"] = %fxanim_angola_barge_aft_debris_anim;
	level.scr_anim["fxanim_props"]["barge_side_debris"] = %fxanim_angola_barge_side_debris_anim;
	level.scr_anim["fxanim_props"]["palm_lrg_destroy01"] = %fxanim_gp_tree_palm_lrg_dest01_anim;
	level.scr_anim["fxanim_props"]["palm_lrg_destroy02"] = %fxanim_gp_tree_palm_lrg_dest02_anim;
	level.scr_anim["fxanim_props"]["hostage_hut"] = %fxanim_angola_hostage_hut_anim;
	level.scr_anim["fxanim_props"]["hostage_hut_wall"] = %fxanim_angola_hostage_hut_wall_anim;
	level.scr_anim["fxanim_props"]["river_debris_palette"] = %fxanim_angola_river_debris_palette_anim;
	level.scr_anim["fxanim_props"]["mortar_rocks"] = %fxanim_angola_mortar_rocks_anim;
	level.scr_anim["fxanim_props"]["river_debris_tire"] = %fxanim_angola_river_debris_tire_anim;
	level.scr_anim["fxanim_props"]["river_debris_group_01"] = %fxanim_angola_river_debris_group_01_anim;
	level.scr_anim["fxanim_props"]["river_debris_group_02"] = %fxanim_angola_river_debris_group_02_anim;
	level.scr_anim["fxanim_props"]["vine_01"] = %fxanim_gp_vine_bare_med_anim;
	level.scr_anim["fxanim_props"]["vine_02"] = %fxanim_gp_vine_bare_sm_anim;
	level.scr_anim["fxanim_props"]["vine_03"] = %fxanim_gp_vine_leaf_med_anim;
	level.scr_anim["fxanim_props"]["vine_04"] = %fxanim_gp_vine_leaf_sm_anim;
}

footsteps()
{
	LoadFX( "bio/player/fx_footstep_dust" );
}
