// scripting by Bloodlust
// level design by BSouds

#include maps\_utility;
#include common_scripts\utility;

// sets up FX for Berlin 1
main()
{

	maps\createart\ber1_art::main();		//added by Rich
//	level thread vison_settings();			//added by Rich
	
	footsteps();
	
	level._effect["schrek_bounce_off_tank"]			= loadfx( "maps/ber1/fx_tank_rocket_hit_nfatal" );
	
	level._effect["large_glass_blowout"]			= loadfx( "maps/ber1/fx_exp_wall_glass_exp" );
	
	level._effect["clocktower_wall_explode"]		= loadfx("maps/ber1/fx_rocket_building_impact");
	level.scr_sound["clocktower_wall_explode"] 		= "imp_stone_chunk";
	
	level._effect["flesh_hit"]						= loadFX( "impacts/flesh_hit" );
	
	level._effect["distant_muzzleflash"]			= loadfx("weapon/muzzleflashes/heavy");

	level._effect["character_fire_pain_sm"] 		= loadfx("env/fire/fx_fire_player_sm_1sec");
	level._effect["character_fire_death_sm"] 		= loadfx("env/fire/fx_fire_player_md");
	level._effect["character_fire_death_torso"] 	= loadfx("env/fire/fx_fire_player_torso");
	
	level._effect["rocket_launch"]					= loadfx("weapon/muzzleflashes/fx_rocket_katyusha_launch");
	level._effect["rocket_trail"]					= loadfx("weapon/rocket/fx_rocket_katyusha_geotrail");
	level._effect["rocket_explode"]					= loadfx("maps/ber1/fx_exp_katyusha_barrage");
	level._effect["rocket_explode_far"]				= loadfx("maps/ber1/fx_exp_katyusha_barrage_far");
	level._effect["shreck_explode"]					= loadfx("explosions/default_explosion");
	level._effect["shreck_trail"]					= loadfx("weapon/rocket/fx_trail_bazooka_geotrail");
	level._effect["barrage_aftermath"]				= loadfx("maps/ber1/fx_rocket_katusha_aftermath");
	
	level._effect["smokenade"]						= loadfx("weapon/grenade/fx_smoke_grenade_generic");
	level._effect["impactdust"]						= loadfx("explosions/tank_impact_dirt");
	
	level._effect["transformer_explode"]			= loadfx("env/electrical/fx_elec_wire_spark_huge_burst");
	level._effect["transformer_sparks"]				= loadfx("env/electrical/fx_elec_tranformer_sparks");
	level._effect["wire_sparks"]					= loadfx("env/electrical/fx_elec_wire_sparks");
	level._effect["wire_sparks_burst"]				= loadfx("env/electrical/fx_elec_wire_spark_burst");
	
	level._effect["chimney_collapse"]				= loadfx("maps/ber1/fx_chimney_collapse");
	level._effect["intro_house_collapse"]			= loadfx("maps/ber1/fx_house_artillery_collapse");
	level._effect["office_collapse"]				= loadfx("maps/ber1/fx_building_artillery_collapse");
	level._effect["explosion_papers"]				= loadfx("maps/ber1/fx_exp_burn_papers");
	
	level._effect["tank_damage"]					= loadfx("vehicle/vfire/vsmoke_t34_engine");
	level._effect["tank_shell_explode"] 			= loadfx("maps/see1/fx_explosion_tank_shell_med");
	level._effect["tank_death"] 					= loadfx("maps/see1/fx_explosion_tank_shell_default");
	level._effect["tank_thru_wall"]					= loadfx("maps/ber1/fx_tank_wall_damage_dust");	
	level._effect["tank_thru_cafe_wall"]			= loadfx("maps/ber1/fx_tank_wall_topple");
	level._effect["asylum_wall_explode"]			= loadfx("maps/ber1/fx_exp_wall_debris");
	
	level._effect["train_exhaust_smoke"]			= loadfx("vehicle/exhaust/fx_exhaust_train_smoke");
	level._effect["train_exhaust_steam"]			= loadfx("vehicle/exhaust/fx_exhaust_train_steam");
	level._effect["train_smoke_trail_fx"]			= loadfx("maps/ber1/fx_smk_train_wheel_amb");
	level._effect["train_wheel_steam"]				= loadfx("vehicle/exhaust/fx_exhaust_train_wheel_steam");
	level._effect["train_sun_rays"]					= loadfx("maps/ber1/fx_ray_sun_med_traincar");
	
	
	
	maps\createfx\ber1_fx::main();
	precacheshellshock("teargas");
	precacheshader("black");

	
	
//////////////////////////////////////////////////////////////
///////////////////////BARRY'S SECTION////////////////////////
//////////////////////////////////////////////////////////////

	level._effect["smoke_hallway_thick_dark"]		= loadfx ("env/smoke/fx_smoke_hall_ceiling_600");
	level._effect["smoke_hallway_faint_dark"]		= loadfx ("env/smoke/fx_smoke_hallway_faint_dark");
	level._effect["smoke_window_out"]				= loadfx ("env/smoke/fx_smoke_door_top_exit_drk");
	
	level._effect["smoke_plume_xlg_slow_blk"]		= loadfx ("env/smoke/fx_smoke_plume_xlg_slow_blk");
	level._effect["smoke_plume_sm_fast_blk_w"]		= loadfx ("env/smoke/fx_smoke_plume_sm_fast_blk_w");
	level._effect["smoke_plume_md_slow_def"]		= loadfx ("env/smoke/fx_smoke_plume_md_slow_def");
	level._effect["smoke_plume_lg_slow_def"]		= loadfx ("env/smoke/fx_smoke_plume_lg_slow_def");
	level._effect["brush_smoke_smolder_sm"]			= loadfx ("env/smoke/fx_smoke_brush_smolder_md");
	
	level._effect["smoke_bank"]						= loadfx ("env/smoke/fx_battlefield_smokebank_ling_lg_w");
	level._effect["battlefield_smokebank_sm_tan_w"]	= loadfx ("env/smoke/fx_battlefield_smokebank_ling_sm_w");
	level._effect["smoke_impact_smolder_w"]		    = loadfx ("env/smoke/fx_smoke_crater_w");
	level._effect["brush_smolder_w"]		      	= loadfx ("env/fire/fx_fire_brush_smolder_md");
	level._effect["brush_fire_smolder_sm"]			= loadfx ("env/fire/fx_fire_brush_smolder_sm");
	
	
	level._effect["fire_static_small"]			    = loadfx ("env/fire/fx_static_fire_sm_ndlight");
	level._effect["fire_static_blk_smk"]			= loadfx ("env/fire/fx_static_fire_md_ndlight");
	level._effect["dlight_fire_glow"]			    = loadfx ("env/light/fx_dlight_fire_glow");
	level._effect["fire_window"]			        = loadfx ("env/fire/fx_fire_win_nsmk_0x35y50z");
	level._effect["fire_bookcase_wide"]			 = loadfx ("env/fire/fx_fire_bookshelf_wide");
	
	level._effect["fire_wall_100_150"]	  			= loadfx ("env/fire/fx_fire_wall_smk_0x100y155z");
	level._effect["car_fire_large"]					= loadfx ("env/fire/fx_fire_blown_md_blk_smk");
	level._effect["bldg_fire_medium"]				= loadfx ("env/fire/fx_fire_blown_md_light_blk_smk");
	
	level._effect["fire_smoke_med"]       			= loadfx("env/fire/fx_fire_smoke_house_wood_med");
	level._effect["fire_xlarge_distant"]			= loadfx ("env/fire/fx_fire_xlarge_distant");
	
	level._effect["falling_lf_elm"]       			= loadfx("env/foliage/fx_leaves_fall_elm");
	level._effect["debris_paper_falling"]			= loadfx ("maps/ber3/fx_debris_papers_falling");
	level._effect["ash_and_embers"]					= loadfx ("env/fire/fx_ash_embers_light");
	
	level._effect["water_leak_runner"]	  			= loadfx ("env/water/fx_water_leak_runner_100");
	level._effect["water_single_leak"]			  = loadfx ("env/water/fx_water_single_leak");
	level._effect["pipe_steam"]       		= loadfx ("env/smoke/fx_pipe_steam_sm_onesht");


  level._effect["fog_thick"]		 			    = loadfx("env/smoke/fx_fog_rolling_thick_600x600");
	level._effect["glass_brk"]						= loadfx ("maps/ber1/fx_glass_wndow_brk");

	level._effect["fallingboards_fire"] 			= LoadFX( "maps/ber2/fx_debris_wood_boards_fire" );
	
	level._effect["insect_swarm"]						= loadfx ("bio/insects/fx_insects_ambient");
	
	level._effect["god_rays_large"]					   = loadfx("env/light/fx_light_god_rays_large");	
	level._effect["god_rays_medium"]				   = loadfx("env/light/fx_light_god_rays_medium");	
	level._effect["god_rays_small"]					   = loadfx("env/light/fx_light_god_rays_small");
	level._effect["god_rays_small_short"]			 = loadfx("env/light/fx_light_god_rays_small_short");
	level._effect["god_rays_dust_motes"]			 = loadfx("env/light/fx_light_god_rays_dust_motes");
	
	level._effect["smoke_door_out"]			        = loadfx ("env/smoke/fx_smoke_door_top_exit_drk");
	
	level._effect["fire_column_creep_xsm"]			       = loadfx ("env/fire/fx_fire_column_creep_xsm");
	level._effect["fire_column_creep_sm"]			         = loadfx ("env/fire/fx_fire_column_creep_sm");
  level._effect["fire_column_creep_md"]			         = loadfx ("env/fire/fx_fire_column_creep_md");
  level._effect["fire_column_creep_lg"]			         = loadfx ("env/fire/fx_fire_column_creep_lg");
	
	level._effect["fire_ceiling_50_100"]			   = loadfx ("env/fire/fx_fire_ceiling_50x100");
	level._effect["fire_ceiling_100_100"]			   = loadfx ("env/fire/fx_fire_ceiling_100x100");
	level._effect["fire_ceiling_100_150"]			     = loadfx ("env/fire/fx_fire_ceiling_100x150");		
	
	level._effect["papers_blowing_lg01"]		 		 = loadfx("maps/ber1/fx_blowing_paper3d_lg01");

  level._effect["flak_field"]		                = loadfx ("weapon/flak/fx_flak_field_8k");

}



//////////////////////////////////////////////////////////////
///////////////////////RICH'S SECTION/////////////////////////
//////////////////////////////////////////////////////////////
//
// vison_settings() //calls the default fog and vision settings
// {
//
//  	set_all_players_visionset( "ber1", 1 );
//	
//	if( IsSplitScreen() )
//	{
//		halfway_height 	= 10000;
//		cull_dist 		= 2000;
//		set_splitscreen_fog( 350, 2986.33, halfway_height, -480, 0.805, 0.715, 0.61, 0.0, cull_dist );
//	}
//	else
//	{
//		setVolFog( 350, 2986.33, 240, -480, 0.805, 0.715, 0.61, 0 );
//	}
//
//}



footsteps()

{

    animscripts\utility::setFootstepEffect( "asphalt",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "brick",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "carpet",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "cloth",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "concrete",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "dirt",		LoadFx( "bio/player/fx_footstep_sand" ) ); 
    animscripts\utility::setFootstepEffect( "foliage",	LoadFx( "bio/player/fx_footstep_sand" ) ); 
    animscripts\utility::setFootstepEffect( "gravel",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "grass",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "metal",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "mud",		LoadFx( "bio/player/fx_footstep_mud" ) ); 
    animscripts\utility::setFootstepEffect( "paper",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "plaster",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "rock",		LoadFx( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "sand",		LoadFx( "bio/player/fx_footstep_sand" ) ); 
    animscripts\utility::setFootstepEffect( "water",	LoadFx( "bio/player/fx_footstep_water" ) ); 
    animscripts\utility::setFootstepEffect( "wood",		LoadFx( "bio/player/fx_footstep_dust" ) ); 

}