//
// file: mp_socotra_fx.gsc
// description: clientside fx script for mp_socotra: setup, special fx functions, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility;
#using_animtree("fxanim_props");

precache_util_fx()
{

}

precache_scripted_fx()
{
}

// FXanim Props
precache_fxanim_props()
{
	level.scr_anim["fxanim_props"]["rope_toggle"] = %fxanim_gp_rope_toggle_anim;
	level.scr_anim["fxanim_props"]["ropes_hang"] = %fxanim_gp_ropes_hang_01_anim;
	level.scr_anim["fxanim_props"]["rope_arch"] = %fxanim_mp_socotra_rope_arch_anim;
	level.scr_anim["fxanim_props"]["wire_coil"] = %fxanim_gp_wire_coil_01_anim;
	level.scr_anim["fxanim_props"]["hang4_mango1"] = %fxanim_mp_socotra_hang4_mango01_anim;
	level.scr_anim["fxanim_props"]["hang4_mango2"] = %fxanim_mp_socotra_hang4_mango02_anim;
	level.scr_anim["fxanim_props"]["hang5_mango1"] = %fxanim_mp_socotra_hang5_mango01_anim;
	level.scr_anim["fxanim_props"]["hang5_mango2"] = %fxanim_mp_socotra_hang5_mango02_anim;
	level.scr_anim["fxanim_props"]["hang7_mango1"] = %fxanim_mp_socotra_hang7_mango01_anim;
	level.scr_anim["fxanim_props"]["hang8_mango1"] = %fxanim_mp_socotra_hang8_mango01_anim;
	level.scr_anim["fxanim_props"]["wirespark_long"] = %fxanim_gp_wirespark_long_anim;
	level.scr_anim["fxanim_props"]["wirespark_med"] = %fxanim_gp_wirespark_med_anim;
	level.scr_anim["fxanim_props"]["yemen_pent_long"] = %fxanim_gp_flag_yemen_pent_long_anim;
	level.scr_anim["fxanim_props"]["roaches"] = %fxanim_gp_roaches_anim;
	level.scr_anim["fxanim_props"]["cloth_sheet_med"] = %fxanim_gp_cloth_sheet_med_anim;
	level.scr_anim["fxanim_props"]["rope_coil"] = %fxanim_gp_rope_coil_anim;	

	level.fx_anim_level_init = ::fxanim_init;
}

// Ambient Effects
precache_createfx_fx()
{

	level._effect["fx_mp_light_dust_motes_md"]								= loadfx("maps/mp_maps/fx_mp_sand_dust_motes");
	level._effect["fx_light_gray_stain_glss_pink"]						= loadfx("light/fx_light_gray_stain_glss_pink");
	level._effect["fx_light_gray_stain_glss_blue"]						= loadfx("light/fx_light_gray_stain_glss_blue");
	level._effect["fx_light_gray_stain_glss_purple"]					= loadfx("light/fx_light_gray_stain_glss_purple");
	level._effect["fx_light_gray_stain_glss_warm_sm"]					= loadfx("light/fx_light_gray_stain_glss_warm_sm");	
	level._effect["fx_mp_sun_flare_socotra"]									= loadfx("maps/mp_maps/fx_mp_sun_flare_socotra");		
	level._effect["fx_light_gray_blue_ribbon"]								= loadfx("light/fx_light_gray_blue_ribbon");	

	level._effect["fx_insects_butterfly_flutter"]							= loadfx("bio/insects/fx_insects_butterfly_flutter");
	level._effect["fx_insects_butterfly_static_prnt"]					= loadfx("bio/insects/fx_insects_butterfly_static_prnt");
	level._effect["fx_insects_roaches_short"]									= loadfx("bio/insects/fx_insects_roaches_short");
	level._effect["fx_insects_fly_swarm_lng"]									= loadfx("bio/insects/fx_insects_fly_swarm_lng");
	level._effect["fx_insects_fly_swarm"]											= loadfx("bio/insects/fx_insects_fly_swarm");
	level._effect["fx_insects_swarm_md_light"]								= loadfx("bio/insects/fx_insects_swarm_md_light");
	level._effect["fx_seagulls_circle_below"]									= loadfx("bio/animals/fx_seagulls_circle_below");	
	level._effect["fx_seagulls_circle_swarm"]									= loadfx("bio/animals/fx_seagulls_circle_swarm");

	level._effect["fx_leaves_falling_lite_sm"]								= loadfx("foliage/fx_leaves_falling_lite_sm");
	level._effect["fx_debris_papers"]													= loadfx("env/debris/fx_debris_papers");
	level._effect["fx_debris_papers_narrow"]									= loadfx("env/debris/fx_debris_papers_narrow");

	level._effect["fx_mp_smk_plume_sm_blk"]										= loadfx("maps/mp_maps/fx_mp_smk_plume_sm_blk");
	level._effect["fx_mp_smk_plume_md_blk"]										= loadfx("maps/mp_maps/fx_mp_socotra_smk_plume_blck");
	level._effect["fx_smk_cigarette_room_amb"]								= loadfx("smoke/fx_smk_cigarette_room_amb");	
	level._effect["fx_smk_smolder_gray_slow_shrt"]						= loadfx("smoke/fx_smk_smolder_gray_slow_shrt");
	
	level._effect["fx_fire_fuel_sm"]													= loadfx("fire/fx_fire_fuel_sm");
	
	level._effect["fx_mp_water_drip_light_long"]							= loadfx("maps/mp_maps/fx_mp_water_drip_light_long");
	level._effect["fx_mp_water_drip_light_shrt"]							= loadfx("maps/mp_maps/fx_mp_water_drip_light_shrt");
	level._effect["fx_water_faucet_on"]												= loadfx("water/fx_water_faucet_on");     
	level._effect["fx_water_faucet_splash"]										= loadfx("water/fx_water_faucet_splash");	
//	level._effect["fx_mp_waves_shorebreak_socotra"]						= loadfx("maps/mp_maps/fx_mp_waves_shorebreak_socotra");	
//	level._effect["fx_mp_water_shoreline_socotra"]						= loadfx("maps/mp_maps/fx_mp_water_shoreline_socotra");		
	
	level._effect["fx_mp_sand_kickup_md"]											= loadfx("maps/mp_maps/fx_mp_sand_kickup_md");
	level._effect["fx_mp_sand_kickup_thin"]										= loadfx("maps/mp_maps/fx_mp_sand_kickup_thin");
	level._effect["fx_mp_sand_windy_heavy_sm_slow"]						= loadFX("maps/mp_maps/fx_mp_sand_windy_heavy_sm_slow");
	level._effect["fx_sand_ledge"]														= loadFX("dirt/fx_sand_ledge");
	level._effect["fx_sand_ledge_sml"]												= loadFX("dirt/fx_sand_ledge_sml");
	level._effect["fx_sand_ledge_md"]													= loadFX("dirt/fx_sand_ledge_md");
	level._effect["fx_sand_ledge_wide_distant"]								= loadFX("dirt/fx_sand_ledge_wide_distant");
	level._effect["fx_sand_windy_heavy_md"]										= loadFX("dirt/fx_sand_windy_heavy_md");
	level._effect["fx_sand_swirl_sm_runner"]									= loadFX("dirt/fx_sand_swirl_sm_runner");
	level._effect["fx_sand_moving_in_air_md"]									= loadFX("dirt/fx_sand_moving_in_air_md");
	level._effect["fx_sand_moving_in_air_pcloud"]							= loadFX("dirt/fx_sand_moving_in_air_pcloud");	

	level._effect["fx_mp_elec_spark_burst_xsm_thin"]					= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_xsm_thin");
	level._effect["fx_fire_fireplace_md"]					                  = loadfx("fire/fx_fire_fireplace_md");
	level._effect["fx_sand_ledge_wide_distant_thin"]				  = loadfx("dirt/fx_sand_ledge_wide_distant_thin");
	level._effect["fx_mp_socotra_flicker_light"]				     = loadfx("maps/mp_maps/fx_mp_socotra_flicker_light");
	level._effect["fx_sparks_bounce_socotra"]				      = loadfx("electrical/fx_sparks_bounce_socotra");
	level._effect["fx_window_god_ray"]				                = loadfx("light/fx_window_god_ray");
	
	level._effect["fx_mp_sun_flare_socotra"]									= loadfx("lens_flares/fx_lf_mp_socotra_sun1");	
}

fxanim_init( localClientNum )
{
	fxanims = GetEntArray( localClientNum, "fxanim_level", "targetname" );

	// need to be on a level variable to be synchronized for splitscreen players
	if ( !IsDefined( level.fxanim_waits ) )
	{
		level.fxanim_waits = [];
		level.fxanim_speeds = [];

		for ( i = 0; i < fxanims.size; i++ )
		{
			level.fxanim_waits[i] = RandomFloatRange( 0.1, 1.5 );
			level.fxanim_speeds[i] = RandomFloatRange( 0.75, 1.4 );
		}
	}

	for ( i = 0; i < fxanims.size; i++ )
	{
		assert( IsDefined( fxanims[i].fxanim_scene_1 ) );

		switch( fxanims[i].fxanim_scene_1 )
		{
		case "sparking_wires_med":
		case "wirespark_med":
			fxanims[i] thread fxanim_wire_think( localClientNum, i, "med_spark_06_jnt" );
			break;

		case "sparking_wires_long":
		case "wirespark_long":
			fxanims[i] thread fxanim_wire_think( localClientNum, i, "long_spark_06_jnt" );
			break;
		}
	}
}

#using_animtree( "fxanim_props" );

fxanim_wire_think( localClientNum, index, bone )
{
	self endon( "death" );
	self endon( "entityshutdown" );
	self endon( "delete" );

	self waittill_dobj( localClientNum );

	self UseAnimTree( #animtree );
	wait( level.fxanim_waits[index] );

	self SetFlaggedAnim( "wire_fx", level.scr_anim["fxanim_props"][self.fxanim_scene_1], 1.0, 0.0, level.fxanim_speeds[index] );

	for ( ;; )
	{
		self waittill( "wire_fx", note );
		//println( "@@@ got note: " + note );

		PlayFxOnTag( localClientNum, level._effect["fx_mp_elec_spark_burst_xsm_thin"], self, bone );
	}
}

main()
{
	clientscripts\mp\createfx\mp_socotra_fx::main();
	clientscripts\mp\_fx::reportNumEffects();

	precache_util_fx();
	precache_createfx_fx();
	precache_fxanim_props();


	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}


