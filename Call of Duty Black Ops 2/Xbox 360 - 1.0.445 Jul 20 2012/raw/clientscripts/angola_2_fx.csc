#include clientscripts\_utility;

// Scripted effects
precache_scripted_fx()
{
	
}


// Ambient effects
precache_createfx_fx()
{
//Jungle fx
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
}


main()
{
	clientscripts\createfx\angola_2_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

