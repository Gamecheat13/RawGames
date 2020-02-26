#include maps\_utility; 
#include common_scripts\utility;
#include maps\_anim;
#using_animtree("fxanim_props");

// fx used by util scripts
precache_util_fx()
{
}

// Scripted effects
precache_scripted_fx()
{
	//Terrorist Hunt
	level._effect["th_ammocrate_exp"]			= LoadFX( "maps/yemen/fx_ammocrate_explosion01" );
	level._effect["th_gascontainer_exp"]		= LoadFX( "maps/yemen/fx_gascontainer_explosion01" );
	level._effect["th_gaspipe_exp"]				= LoadFX( "maps/yemen/fx_gaspipe_explosion01" );
	level._effect["th_generator_exp"]			= LoadFX( "maps/yemen/fx_generator_explosion01" );
	level._effect["th_pipe_steam"]				= LoadFX( "maps/yemen/fx_pipes_spraying01" );
	level._effect["th_rpgammo_exp"]				= LoadFX( "maps/yemen/fx_rpg_explosion01" );
	level._effect["th_wires_sparking"]			= LoadFX( "maps/yemen/fx_wires_sparking01" );
	
	//Metal Storm
	level._effect["balcony_explosion"]			= LoadFX( "maps/yemen/fx_balcony_explosion01" );
	level._effect["balcony_debris_atplayer"]	= LoadFX( "maps/yemen/fx_debris_atplayer" );
	
	//Drone Control
	level._effect["fx_overlay_decal"]			= LoadFX("maps/yemen/fx_overlay_decal");
	level._effect["fx_overlay_light"]		    = LoadFX("maps/yemen/fx_overlay_light");
	
	//Capture
	level._effect["flesh_hit"]		               = LoadFX("impacts/fx_flesh_hit");
	level._effect[ "sniper_glint" ]                = LoadFX( "misc/fx_misc_sniper_scope_glint" );
	level._effect[ "bullet_trail_sniper" ]         = LoadFX( "maps/afghanistan/fx_afgh_bullet_trail_sniper" );
	level._effect[ "dirthit_libya" ]               = LoadFX( "impacts/fx_20mil_dirthit_libya" );
	level._effect[ "fire" ]                        = LoadFX( "env/fire/fx_fire_barrel_small" );
}

// FXanim Props
initModelAnims()
{
	level.scr_anim["fxanim_props"]["vtol1_crash"] = %fxanim_yemen_vtol1_crash_anim;
	level.scr_anim["fxanim_props"]["ceiling_collapse"] = %fxanim_yemen_ceiling_collapse_anim;
	level.scr_anim["fxanim_props"]["bridge_explode"] = %fxanim_yemen_bridge_explode_anim;
	level.scr_anim["fxanim_props"]["bridge_drop"] = %fxanim_yemen_bridge_drop_anim;
	level.scr_anim["fxanim_props"]["vtol2_crash"] = %fxanim_yemen_vtol2_crash_anim;
	level.scr_anim["fxanim_props"]["balcony_courtyard"] = %fxanim_yemen_balcony_courtyard_anim;
	level.scr_anim["fxanim_props"]["rock_slide"] = %fxanim_yemen_rock_slide_anim;
}

// --- FX DEPARTMENT SECTION ---//
precache_createfx_fx()
{
 // EXPLODERS //
  
 level._effect["fx_bridge_explosion01"]       = LoadFX("maps/yemen/fx_bridge_explosion01"); // exploder 750
 
 // END EXPLODERS //
 
 level._effect["fx_smk_fire_md_gray_int"]         = LoadFX("env/smoke/fx_smk_fire_md_gray_int");
 level._effect["fx_smk_fire_md_black"]            = LoadFX("env/smoke/fx_smk_fire_md_black");
 level._effect["fx_shrimp_group_hangout03"]       = LoadFX("bio/shrimps/fx_shrimp_group_hangout03");
}

wind_initial_setting()
{
	SetSavedDvar( "wind_global_vector", "-172 28 0" );			// change "0 0 0" to your wind vector
	SetSavedDvar( "wind_global_low_altitude", 0);						// change 0 to your wind's lower bound
	SetSavedDvar( "wind_global_hi_altitude", 2775);					// change 10000 to your wind's upper bound
	SetSavedDvar( "wind_global_low_strength_percent", 0.5);	// change 0.5 to your desired wind strength percentage
}

main()
{
	initModelAnims();
	precache_util_fx();
	precache_scripted_fx();
	precache_createfx_fx();

	footsteps();

	// calls the createfx server script (i.e., the list of ambient effects and their attributes)
	maps\createfx\yemen_fx::main();

	wind_initial_setting();
}

footsteps()
{
	LoadFx( "bio/player/fx_footstep_dust" );
	LoadFx( "bio/player/fx_footstep_dust" );
}
