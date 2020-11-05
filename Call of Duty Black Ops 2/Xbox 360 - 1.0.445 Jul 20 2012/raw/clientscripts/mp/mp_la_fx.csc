#include clientscripts\mp\_utility;
#using_animtree("fxanim_props");


precache_util_fx()
{	
}

precache_scripted_fx()
{
	level._effect["fx_light_police_car"] = loadfx("maps/mp_maps/fx_mp_light_police_car");
}

precache_createfx_fx()
{

	level._effect["fx_water_fire_sprinkler"]									= loadfx("water/fx_water_fire_sprinkler");
	level._effect["fx_water_fire_sprinkler_splash"]						= loadfx("water/fx_water_fire_sprinkler_splash");
	level._effect["fx_water_fire_sprinkler_sputter"]					= loadfx("water/fx_water_fire_sprinkler_sputter");
	level._effect["fx_water_fire_sprinkler_gush"]							= loadfx("water/fx_water_fire_sprinkler_gush");
	level._effect["fx_water_fire_sprinkler_gush_splash"]			= loadfx("water/fx_water_fire_sprinkler_gush_splash");	
//	level._effect["fx_water_step_splash"]											= loadfx("water/fx_water_step_splash");
	level._effect["fx_water_fountian_pool_md"]								= loadfx("water/fx_water_fountain_pool_md");
//	level._effect["fx_water_fountain_pool_sm"]								= loadfx("water/fx_water_fountain_pool_sm");
	level._effect["fx_mp_water_splash_mist_fountain"]					= loadfx("maps/mp_maps/fx_mp_water_splash_mist_fountain");	

	level._effect["fx_mp_water_drip_light_long"]							= loadfx("maps/mp_maps/fx_mp_water_drip_light_long");	
	level._effect["fx_mp_water_drip_light_shrt"]							= loadfx("maps/mp_maps/fx_mp_water_drip_light_shrt");	
	level._effect["fx_insects_swarm_md_light"]								= loadfx("bio/insects/fx_insects_swarm_md_light");
	level._effect["fx_insects_swarm_lg_light"]								= loadfx("bio/insects/fx_insects_swarm_lg_light");	

	level._effect["fx_mp_debris_papers"]											= loadfx("maps/mp_maps/fx_mp_debris_papers");
	level._effect["fx_mp_debris_papers_narrow"]								= loadfx("maps/mp_maps/fx_mp_debris_papers_narrow");	
	level._effect["fx_paper_interior_short"]									= loadfx("debris/fx_paper_interior_short");	
	level._effect["fx_paper_burning_fall_slow"]								= loadfx("debris/fx_paper_burning_fall_slow");
	level._effect["fx_leaves_falling_lite_sm_orng"]						= loadfx("foliage/fx_leaves_falling_lite_sm_orng");	
		
	level._effect["fx_mp_light_dust_motes_md"]								= loadfx("maps/mp_maps/fx_mp_light_dust_motes_md");
	level._effect["fx_dust_crumble_int_md"]										= loadfx("env/dirt/fx_dust_crumble_int_md");
	level._effect["fx_dust_crumble_lg"]												= loadfx("dirt/fx_dust_crumble_lg_runner");
	level._effect["fx_dust_crumble_md"]												= loadfx("dirt/fx_dust_crumble_md");

	level._effect["fx_mp_fire_lg"] 														= loadfx("maps/mp_maps/fx_mp_fire_lg");	
	level._effect["fx_mp_fire_md"] 														= loadfx("maps/mp_maps/fx_mp_fire_md");	
	level._effect["fx_mp_fire_sm"] 														= loadfx("maps/mp_maps/fx_mp_fire_sm");	
	level._effect["fx_mp_fire_xsm"] 													= loadfx("maps/mp_maps/fx_mp_fire_xsm");	
				
	level._effect["fx_fire_bldg_ext_dist_falling_debris"] 		= loadfx("fire/fx_fire_bldg_ext_dist_falling_debris");	
	level._effect["fx_fire_lg"] 															= loadfx("env/fire/fx_fire_lg");
	level._effect["fx_fire_md"] 															= loadfx("env/fire/fx_fire_md");
	level._effect["fx_fire_sm"] 															= loadfx("env/fire/fx_fire_sm");
	level._effect["fx_fire_detail"] 													= loadfx("env/fire/fx_fire_detail_sm_nodlight");		
	level._effect["fx_fire_bldg_int_dist_xxlg"] 							= loadfx("fire/fx_fire_bldg_int_dist_xxlg");	
	level._effect["fx_fire_bldg_int_dist_xlg"] 								= loadfx("fire/fx_fire_bldg_int_dist_xlg");	
	
//	level._effect["fx_mp_smk_haze_linger"]										= loadfx("maps/mp_maps/fx_mp_smk_haze_linger");
	level._effect["fx_mp_fire_ash_falling_lg"]								= loadfx("maps/mp_maps/fx_mp_fire_ash_falling_lg");
	level._effect["fx_mp_fire_ash_falling_door"]							= loadfx("maps/mp_maps/fx_mp_fire_ash_falling_door");	
	
	level._effect["fx_mp_ash_falling_lg"]											= loadfx("maps/mp_maps/fx_mp_ash_falling_lg");

	level._effect["fx_mp_smk_haze_linger_xlg"]								= loadfx("maps/mp_maps/fx_mp_smk_haze_linger_xlg");	

	level._effect["fx_mp_smk_plume_detail_blk"]								= loadfx("maps/mp_maps/fx_mp_smk_plume_detail_blk");		
	level._effect["fx_mp_smk_plume_sm_blk"]										= loadfx("maps/mp_maps/fx_mp_smk_plume_sm_blk");	
	level._effect["fx_mp_smk_plume_md_blk"]										= loadfx("maps/mp_maps/fx_mp_smk_plume_md_blk");	
	level._effect["fx_mp_smk_plume_lg_blk"]										= loadfx("maps/mp_maps/fx_mp_smk_plume_lg_blk");	
	level._effect["fx_mp_smk_plume_xxlg_blk_ds"]							= loadfx("maps/mp_maps/fx_mp_la_smk_plume_xxlg_blk_ds");	
	level._effect["fx_mp_smk_smolder_rubble_area"]						= loadfx("maps/mp_maps/fx_mp_smk_smolder_rubble_area");
	level._effect["fx_mp_smk_smolder_rubble_line"]						= loadfx("maps/mp_maps/fx_mp_smk_smolder_rubble_line");
	level._effect["fx_mp_smk_smolder_rubble_line_sm"]					= loadfx("maps/mp_maps/fx_mp_smk_smolder_rubble_line_sm");	
	level._effect["fx_mp_smk_smolder_detail_blk"]							= loadfx("maps/mp_maps/fx_mp_smk_smolder_detail_blk");	
	level._effect["fx_mp_smk_plume_lg_blk_distant"]						= loadfx("maps/mp_maps/fx_mp_smk_plume_lg_blk_distant");
	level._effect["fx_mp_smk_plume_md_blk_distant"]						= loadfx("maps/mp_maps/fx_mp_smk_plume_md_blk_distant");	

	level._effect["fx_fog_low_rising"]												= loadfx("fog/fx_fog_low_rising");	

	level._effect["fx_mp_elec_spark_burst_xsm_thin"]					= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_xsm_thin");
	level._effect["fx_mp_elec_spark_burst_sm_runner"]					= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_sm_runner");
	level._effect["fx_mp_elec_spark_burst_xsm_thin_runner"]		= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_xsm_thin_runner");
	level._effect["fx_mp_elec_spark_burst_md_runner"]					= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_md_runner");
	level._effect["fx_mp_elec_spark_burst_lg_runner"]					= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_lg_runner");
	
	level._effect["fx_light_emrgncy_floodlight"]							= loadfx("light/fx_light_emrgncy_floodlight");
	level._effect["fx_light_recessed_wrm"]										= loadfx("light/fx_light_recessed_wrm");
//	level._effect["fx_light_ambulance_blue"]									= loadfx("env/light/fx_light_ambulance_blue");
	level._effect["fx_light_ambulance_red"]										= loadfx("env/light/fx_light_ambulance_red");	
//	level._effect["fx_light_ceiling_sqr_wht"]									= loadfx("light/fx_light_ceiling_sqr_wht");	
//	level._effect["fx_light_ambulance_red_flash"]							= loadfx("light/fx_light_ambulance_red_flash");	
//	level._effect["fx_light_ambulance_blue_flash"]						= loadfx("light/fx_light_ambulance_blue_flash");	
	level._effect["fx_mp_light_flare_la"]											= loadfx("maps/mp_maps/fx_mp_light_flare_la");
	level._effect["fx_light_flourescent_glow_cool"]						= loadfx("light/fx_light_flourescent_glow_cool");	
	level._effect["fx_light_gray_white_ribbon_sm"]						= loadfx("light/fx_light_gray_white_ribbon_sm");	
	level._effect["fx_mp_light_police_car"]										= loadfx("maps/mp_maps/fx_mp_light_police_car");
	level._effect["fx_mp_light_ambulance"]										= loadfx("maps/mp_maps/fx_mp_light_ambulance");	
	level._effect["fx_mp_light_firetruck"]										= loadfx("maps/mp_maps/fx_mp_light_firetruck");	
	level._effect["fx_light_flourescent_ceiling_panel"]				= loadfx("light/fx_light_flourescent_ceiling_panel");
	level._effect["fx_light_pent_lamp_desk"]									= loadfx("light/fx_light_pent_lamp_desk");	
	level._effect["fx_light_outdoor_wall"]										= loadfx("light/fx_light_outdoor_wall");		
	level._effect["fx_light_recessed_cool"]										= loadfx("light/fx_light_recessed_cool");	
	level._effect["fx_light_garage_parking_green"]						= loadfx("light/fx_light_garage_parking_green");	
	level._effect["fx_light_garage_parking_red"]							= loadfx("light/fx_light_garage_parking_red");	
	
	level._effect["fx_lf_mp_la_sun1"]													= loadfx("lens_flares/fx_lf_mp_la_sun1");	

	level._effect["fx_dest_fire_hydrant_burst"]								= loadfx("maps/mp_maps/fx_mp_fire_hydrant_burst");
//	level._effect["fx_water_pipe_spray_splash"]								= loadfx("env/water/fx_water_pipe_spray_splash");	
//	level._effect["fx_water_pipe_spray"]											= loadfx("env/water/fx_water_pipe_spray");	
	level._effect["fx_rain_splash_area_100_hvy_lp"]						= loadfx("weather/fx_rain_splash_area_100_hvy_lp");	

}

//FXANIM PROPS

precache_fxanim_props()
{
 	level.scr_anim["fxanim_props"]["clearance_pipe"] = %fxanim_gp_garage_clearance_pipe_anim;
 	level.scr_anim["fxanim_props"]["elevator_doors"] = %fxanim_mp_la_elevator_doors_anim;
 	level.scr_anim["fxanim_props"]["sparking_wires_med"] = %fxanim_gp_wirespark_med_anim;
 	level.scr_anim["fxanim_props"]["sparking_wires_long"] = %fxanim_gp_wirespark_long_anim;
 	level.scr_anim["fxanim_props"]["hanging_wires"] = %fxanim_mp_la_hanging_wires_anim;

	level.fx_anim_level_init = ::fxanim_init;
}

main()
{
	clientscripts\mp\createfx\mp_la_fx::main();
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
				fxanims[i] thread fxanim_wire_think( localClientNum, i, "med_spark_06_jnt" );
			break;

			case "sparking_wires_long":
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
