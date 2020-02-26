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
	// Horse tread fx
	level._effect[ "horse_treadfx" ] = LoadFX( "vehicle/treadfx/fx_afgh_treadfx_horse_sand" );
		
	// Section 1
	level._effect[ "fx_afgh_rappel_impact" ] = LoadFX( "env/dirt/fx_afgh_rappel_impact" );  //Woods start rappel
	
	//Section 2
	level._effect[ "cave_swing_light" ] = LoadFX( "maps/afghanistan/fx_afgh_light_tinhat" );
	level._effect[ "explode_large_sand" ] = LoadFX( "explosions/fx_explosion_sand_lg" );
	level._effect[ "explode_mortar_sand" ] = LoadFX( "explosions/fx_mortarexp_sand" );
	level._effect[ "explode_grenade_sand" ] = LoadFX( "explosions/fx_grenadeexp_sand" );
	level._effect[ "water_tower_brick" ] = LoadFX( "impacts/fx_afgh_large_rock" );
	level._effect[ "fire_horse" ] = LoadFX( "maps/afghanistan/fx_afgh_horse_onfire_moving" );
	level._effect[ "fire_horse_dead" ] = LoadFX( "maps/afghanistan/fx_afgh_horse_onfire_dead" );
	level._effect[ "aircraft_flares" ] = LoadFX( "vehicle/vexplosion/fx_heli_chaff_flares" );
	level._effect[ "sniper_glint" ] = LoadFX( "misc/fx_misc_sniper_scope_glint" );
	level._effect[ "cache_dmg" ] = LoadFX( "maps/afghanistan/fx_afgh_smk_weapon_cache" );
	level._effect[ "cache_dest" ] = LoadFX( "maps/afghanistan/fx_afgh_exp_weapon_cache" );
	level._effect[ "sniper_trail" ] = LoadFX( "maps/afghanistan/fx_afgh_bullet_trail_sniper" );
	level._effect[ "sniper_impact" ] = LoadFX( "weapon/bullet/fx_flesh_gib_fatal_01" );
	level._effect[ "explosion_midair_heli" ] = LoadFX( "vehicle/vexplosion/fx_vexp_afgh_hind_aerial" );
	level._effect[ "missile_impact_hip" ] = LoadFX( "explosions/fx_vexp_mi8_afgh" );  //Missile impact explosion
	level._effect[ "dmg_trail_hip" ] = LoadFX( "fire/fx_vfire_mi8_afgh" );  //Damage trail after missile hit
	level._effect[ "dead_hip_fire" ] = LoadFX( "fire/fx_vfire_mi8_destroyed_afgh" );
	level._effect[ "tank_dmg" ] = LoadFX( "smoke/fx_afgh_smk_t62_dmg" );
	level._effect[ "truck_dmg" ] = LoadFX( "maps/afghanistan/fx_afgh_truck_trail_runner" );
	level._effect[ "cratercharge_light" ] = LoadFX( "props/fx_wpn_cratercharge_light_os" );
	level._effect[ "crater_charge_bury" ] = LoadFX( "maps/afghanistan/fx_afgh_crater_charge_bury" );
	level._effect[ "krav_tank_fire" ] = LoadFX( "maps/afghanistan/fx_afgh_krav_tank_fire" );
	
	//Section 3
	level._effect[ "numbers_base" ] = LoadFX( "maps/afghanistan/fx_afgh_interrog_numbers_base" );
	level._effect[ "numbers_center" ] = LoadFX( "maps/afghanistan/fx_afgh_interrog_numbers_center" );
	level._effect[ "numbers_mid" ] = LoadFX( "maps/afghanistan/fx_afgh_interrog_numbers_mid" );
	level._effect[ "tank_numbers_base" ] = LoadFX( "maps/afghanistan/fx_afgh_tank_numbers_base" );
	level._effect[ "tank_numbers_center" ] = LoadFX( "maps/afghanistan/fx_afgh_tank_numbers_center" );
	level._effect[ "tank_numbers_mid" ] = LoadFX( "maps/afghanistan/fx_afgh_tank_numbers_mid" );	
	
	level._effect[ "kickout_dust_impact" ] = LoadFX( "dirt/fx_dust_impact_plume_lg" );
	level._effect[ "truck_kickup_dust" ] = LoadFX( "maps/afghanistan/fx_afgh_cin_truck_kickup_dust" );
	level._effect["fx_afgh_krav_tank_mortar"]	  = LoadFX("maps/afghanistan/fx_afgh_krav_tank_mortar");
	level._effect["fx_afgh_explo_krav_tank"]	  = LoadFX("maps/afghanistan/fx_afgh_explo_krav_tank");
	level._effect["fx_afgh_horse_charge_clouds"]	  = LoadFX("maps/afghanistan/fx_afgh_horse_charge_clouds");
	
	//Interrogation
	level._effect[ "choke_spit" ] = LoadFX( "maps/afghanistan/fx_afgh_choke_spit" );  //Player choked
	level._effect[ "head_punch" ] = LoadFX( "maps/afghanistan/fx_afgh_head_punch" );  //Woods hits Kravchenko
	level._effect[ "knife_tip" ] = LoadFX( "maps/afghanistan/fx_afgh_knife_tip" );  //Woods flicks knife
	level._effect[ "krav_spit" ] = LoadFX( "maps/afghanistan/fx_afgh_spit" );  //Kravchenko Spit
	level._effect[ "hand_stab" ] = LoadFX( "maps/afghanistan/fx_afgh_hand_stab" );  //Wood stabs Kravchenko’s Hand; Woods takes knife out of hand
	level._effect[ "sand_body_impact_sm" ] = LoadFX( "maps/afghanistan/fx_afgh_sand_body_impact_sm" );  //Player is knocked to the ground
	level._effect[ "pistol_flash" ] = LoadFX( "weapon/muzzleflashes/fx_pistol_flash_base" );  //Muzzle flash from Wood’s gun; Muzzle flash from player gun
	level._effect[ "head_shot" ] = LoadFX( "maps/afghanistan/fx_afgh_head_shot" );  //Headshot from Kravchenko
	
	level._effect[ "fx_punch_kravchenko" ] = LoadFX( "maps/afghanistan/fx_punch_kravchenko" );
	level._effect[ "fx_flesh_hit_neck_fatal" ] = LoadFX( "impacts/fx_flesh_hit_neck_fatal" );	
}

// FXanim Props
initModelAnims()
{
	level.scr_anim["fxanim_props"]["rappel_rope"] = %fxanim_afghan_rappel_rope_anim;
	level.scr_anim["fxanim_props"]["horse_wall_break"] = %fxanim_afghan_horses_wall_break_anim;
	level.scr_anim["fxanim_props"]["statue_crumble"] = %fxanim_afghan_statue_crumble_anim;
	level.scr_anim["fxanim_props"]["village_tower"] = %fxanim_afghan_village_tower_anim;
	level.scr_anim["fxanim_props"]["bridge01_break"] = %fxanim_afghan_rope_bridge01_anim;
	level.scr_anim["fxanim_props"]["bridge02_break"] = %fxanim_afghan_rope_bridge02_anim;
	level.scr_anim["fxanim_props"]["bridge01_long_break"] = %fxanim_afghan_rope_bridge_long01_anim;
	level.scr_anim["fxanim_props"]["bridge02_long_break"] = %fxanim_afghan_rope_bridge_long02_anim;
	level.scr_anim["fxanim_props"]["cliff_collapse"] = %fxanim_afghan_cliff_collapse_anim;
	level.scr_anim["fxanim_props"]["water_tower_a"] = %fxanim_afghan_water_tower_a_anim;
	level.scr_anim["fxanim_props"]["water_tower_b"] = %fxanim_afghan_water_tower_b_anim;
	level.scr_anim["fxanim_props"]["hitching_post_01"] = %fxanim_afghan_hitching_post_01_anim;
	level.scr_anim["fxanim_props"]["bridge_hang_rope"] = %fxanim_afghan_rope_bridge_hang_anim;
	level.scr_anim["fxanim_props"]["bridge_long_hang_rope"] = %fxanim_afghan_rope_bridge_long_hang_anim;
	level.scr_anim["fxanim_props"]["chopper_crash"] = %fxanim_afghan_chopper_crash_rocks_anim;
	level.scr_anim["fxanim_props"]["rock_slide"] = %fxanim_afghan_rock_slide_anim;
	level.scr_anim["fxanim_props"]["shrubs_norm_speed"] = %fxanim_afghan_shrubs_time_lapse_norm_anim;
	level.scr_anim["fxanim_props"]["shrubs_ramp_speed"] = %fxanim_afghan_shrubs_time_lapse_ramp_anim;
	level.scr_anim["fxanim_props"]["shrubs_fast_speed"] = %fxanim_afghan_shrubs_time_lapse_fast_anim;
	level.scr_anim["fxanim_props"]["rock_arch"] = %fxanim_afghan_rock_arch_anim;
	level.scr_anim["fxanim_props"]["rock_arch_collapse"] = %fxanim_afghan_rock_arch_collapse_anim;
	level.scr_anim["fxanim_props"]["rock_arch_pillar"] = %fxanim_afghan_rock_arch_pillar_anim;
	level.scr_anim["fxanim_props"]["rock_arch_pillar_crush"] = %fxanim_afghan_rock_arch_pillar_crush_anim;
	level.scr_anim["fxanim_props"]["cargo_hanging"] = %fxanim_gp_cargo_hanging_anim;
	level.scr_anim["fxanim_props"]["archway_collapse"] = %fxanim_afghan_archway_collapse_anim;
	level.scr_anim["fxanim_props"]["chopper_crash"] = %fxanim_afghan_chopper_crash_blades_anim;
	level.scr_anim["fxanim_props"]["statue_02_crumble"] = %fxanim_afghan_statue_02_crumble_anim;
	level.scr_anim["fxanim_props"]["statue_lrg_crumble"] = %fxanim_afghan_statue_lrg_crumble_anim;
	level.scr_anim["fxanim_props"]["rock_peak_explosion"] = %fxanim_afghan_rock_peak_explode_anim;

	maps\_anim::addNotetrack_customFunction( "fxanim_props", "bridge_short_01_cacheside", ::bridge_short_01_cacheside, "bridge01_break");
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "bridge_short_01_towerside", ::bridge_short_01_towerside, "bridge01_break");
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "bridge_short_02_cacheside", ::bridge_short_02_cacheside, "bridge02_break");
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "bridge_short_02_towerside", ::bridge_short_02_towerside, "bridge02_break");
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "bridge_long_01_cacheside", ::bridge_long_01_cacheside, "bridge01_long_break");
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "bridge_long_01_towerside", ::bridge_long_01_towerside, "bridge01_long_break");
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "bridge_long_02_cacheside", ::bridge_long_02_cacheside, "bridge02_long_break");
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "bridge_long_02_towerside", ::bridge_long_02_towerside, "bridge02_long_break");
	
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "exploder 10330 #tower_hit", ::bp1_tower_hit, "village_tower" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "exploder 10331 #impact_base", ::bp1_tower_impact_base, "village_tower" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "exploder 10332 #impact_ground", ::bp1_tower_impact_ground, "village_tower" );

	maps\_anim::addNotetrack_customFunction( "fxanim_props", "exploder 10310 #watertower_explode", ::base_tower_explode, "water_tower_a" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "brick_impact01", ::water_tower_brick_fx, "water_tower_a" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "brick_impact02", ::water_tower_brick_fx, "water_tower_a" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "brick_impact03", ::water_tower_brick_fx, "water_tower_a" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "brick_impact04", ::water_tower_brick_fx, "water_tower_a" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "brick_impact05", ::water_tower_brick_fx, "water_tower_a" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "brick_impact06", ::water_tower_brick_fx, "water_tower_a" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "brick_impact07", ::water_tower_brick_fx, "water_tower_a" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "brick_impact08", ::water_tower_brick_fx, "water_tower_a" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "brick_impact09", ::water_tower_brick_fx, "water_tower_a" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "brick_impact10", ::water_tower_brick_fx, "water_tower_a" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "brick_impact11", ::water_tower_brick_fx, "water_tower_a" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "brick_impact12", ::water_tower_brick_fx, "water_tower_a" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "brick_impact13", ::water_tower_brick_fx, "water_tower_a" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "brick_impact14", ::water_tower_brick_fx, "water_tower_a" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "brick_impact15", ::water_tower_brick_fx, "water_tower_a" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "brick_impact16", ::water_tower_brick_fx, "water_tower_a" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "brick_impact17", ::water_tower_brick_fx, "water_tower_a" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "brick_impact18", ::water_tower_brick_fx, "water_tower_a" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "brick_impact19", ::water_tower_brick_fx, "water_tower_a" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "brick_impact20", ::water_tower_brick_fx, "water_tower_a" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "brick_impact21", ::water_tower_brick_fx, "water_tower_a" );
	
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "ammo depot crush", ::arch_collapse, "rock_arch_collapse" );
}


arch_collapse( arch )
{
	cache_pris = GetEnt( "ammo_cache_BP2_pristine", "targetname" );
	cache_dmg = GetEnt( "ammo_cache_BP2_damaged", "targetname" );
	cache_clip = GetEnt( "ammo_cache_BP2_clip", "targetname" );
	cache_dest = GetEnt( "ammo_cache_BP2_destroyed", "targetname" );
	
	PlayFX( level._effect[ "cache_dest" ], cache_dest.origin );
				
	wait 0.1;
				
	cache_pris Delete();
	cache_dmg Delete();
	cache_clip Delete();
	cache_dest Show();
}


bp1_tower_hit( village_tower )
{
	Earthquake( 0.3, 1, level.player.origin, 3200 );
}


bp1_tower_impact_base( village_tower )
{
	Earthquake( 0.3, 1, level.player.origin, 3200 );
}


bp1_tower_impact_ground( village_tower )
{
	level.player PlayRumbleOnEntity( "artillery_rumble" );
	
	Earthquake( 0.3, 1, level.player.origin, 3200 );
}


water_tower_brick_fx( tower )
{
	if(!IsDefined(level.fxanim_water_tower_brick_jnts))
	{
		level.fxanim_water_tower_brick_jnts = [];
		level.fxanim_water_tower_brick_jnts[0] = "tag_fx_impact01_jnt";
		level.fxanim_water_tower_brick_jnts[1] = "tag_fx_impact02_jnt";
		level.fxanim_water_tower_brick_jnts[2] = "tag_fx_impact03_jnt";
		level.fxanim_water_tower_brick_jnts[3] = "tag_fx_impact04_jnt";
		level.fxanim_water_tower_brick_jnts[4] = "tag_fx_impact05_jnt";
		level.fxanim_water_tower_brick_jnts[5] = "tag_fx_impact06_jnt";
		level.fxanim_water_tower_brick_jnts[6] = "tag_fx_impact07_jnt";
		level.fxanim_water_tower_brick_jnts[7] = "tag_fx_impact08_jnt";
		level.fxanim_water_tower_brick_jnts[8] = "tag_fx_impact09_jnt";
		level.fxanim_water_tower_brick_jnts[9] = "tag_fx_impact10_jnt";
		level.fxanim_water_tower_brick_jnts[10] = "tag_fx_impact11_jnt";
		level.fxanim_water_tower_brick_jnts[11] = "tag_fx_impact12_jnt";
		level.fxanim_water_tower_brick_jnts[12] = "tag_fx_impact13_jnt";
		level.fxanim_water_tower_brick_jnts[13] = "tag_fx_impact14_jnt";
		level.fxanim_water_tower_brick_jnts[14] = "tag_fx_impact15_jnt";
		level.fxanim_water_tower_brick_jnts[15] = "tag_fx_impact16_jnt";
		level.fxanim_water_tower_brick_jnts[16] = "tag_fx_impact17_jnt";
		level.fxanim_water_tower_brick_jnts[17] = "tag_fx_impact18_jnt";
		level.fxanim_water_tower_brick_jnts[18] = "tag_fx_impact19_jnt";
		level.fxanim_water_tower_brick_jnts[19] = "tag_fx_impact20_jnt";
		level.fxanim_water_tower_brick_jnts[20] = "tag_fx_impact21_jnt";
		
		level.fxanim_water_tower_brick_index = 0;
	}
	
	PlayFXOnTag( level._effect["water_tower_brick"], tower, level.fxanim_water_tower_brick_jnts[ level.fxanim_water_tower_brick_index ] );
	level.fxanim_water_tower_brick_index++;
	
	if(level.fxanim_water_tower_brick_index == level.fxanim_water_tower_brick_jnts.size)
	{
		level.fxanim_water_tower_brick_jnts = undefined;
		level.fxanim_water_tower_brick_index = undefined;		
	}
}


base_tower_explode( tower )
{
	Earthquake( 0.3, 1, level.player.origin, 3200 );
	
	wait 3.5;
	
	level.player PlayRumbleOnEntity( "artillery_rumble" );
	
	Earthquake( 0.5, 2, level.player.origin, 3200 );
	
	RadiusDamage( tower.origin, 600, 200, 80, undefined, "MOD_PROJECTILE" );
}


// --- FX DEPT SECTION ---//
precache_createfx_fx()
{
	// Ambient
	level._effect["fx_afgh_sandstorm_intro"]			    = LoadFX("maps/afghanistan/fx_afgh_sandstorm_intro");		
	level._effect["fx_afgh_mirage_distant"]		        = LoadFX("maps/afghanistan/fx_afgh_mirage_distant");
	level._effect["fx_afgh_sand_ledge_sml"]		        = LoadFX("maps/afghanistan/fx_afgh_sand_ledge_sml");	
	level._effect["fx_afgh_sand_ledge_sml_intro"]		  = LoadFX("maps/afghanistan/fx_afgh_sand_ledge_sml_intro");		
//	level._effect["fx_afgh_sand_ledge"]		            = LoadFX("maps/afghanistan/fx_afgh_sand_ledge");
	level._effect["fx_afgh_sand_ledge_wide_distant"]  = LoadFX("maps/afghanistan/fx_afgh_sand_ledge_wide_distant");
  level._effect["fx_afgh_sand_windy_fast_md"]		    = LoadFX("maps/afghanistan/fx_afgh_sand_windy_fast_md");	
	level._effect["fx_afgh_sand_windy_detail_sm"]		  = LoadFX("maps/afghanistan/fx_afgh_sand_windy_detail_sm");		
	level._effect["fx_afgh_sand_windy_heavy_sm"]		  = LoadFX("maps/afghanistan/fx_afgh_sand_windy_heavy_sm");					
	level._effect["fx_afgh_sand_windy_heavy_md"]		  = LoadFX("maps/afghanistan/fx_afgh_sand_windy_heavy_md");
	level._effect["fx_afgh_sandstorm_close_intro"]			    = LoadFX("maps/afghanistan/fx_afgh_sandstorm_close_intro");			
	level._effect["fx_afgh_sandstorm_close_tall"]			= LoadFX("maps/afghanistan/fx_afgh_sandstorm_close_tall");		
	level._effect["fx_afgh_sandstorm_distant"]			  = LoadFX("maps/afghanistan/fx_afgh_sandstorm_distant");
	level._effect["fx_afgh_sandstorm_distant_detail"]	= LoadFX("maps/afghanistan/fx_afgh_sandstorm_distant_detail");	
	level._effect["fx_afgh_sandstorm_distant_lrg"]	  = LoadFX("maps/afghanistan/fx_afgh_sandstorm_distant_lrg");
	level._effect["fx_birds_circling"]				        = LoadFX("bio/animals/fx_birds_circling");		
		
	level._effect["fx_afgh_sand_body_impact"]	        = LoadFX("env/dirt/fx_afgh_sand_body_impact");
	
	level._effect["fx_afgh_light_lamp"]	              = LoadFX("maps/afghanistan/fx_afgh_light_lamp");
	level._effect["fx_afgh_light_tinhat"]	            = LoadFX("maps/afghanistan/fx_afgh_light_tinhat");
	level._effect["fx_afgh_ceiling_dust_cavern"]	    = LoadFX("maps/afghanistan/fx_afgh_ceiling_dust_cavern");			
	level._effect["fx_afgh_ceiling_dust_tunnel"]	    = LoadFX("maps/afghanistan/fx_afgh_ceiling_dust_tunnel");	
	level._effect["fx_afgh_steam_cook_pot"]	          = LoadFX("maps/afghanistan/fx_afgh_steam_cook_pot");
	level._effect["fx_afgh_fire_cooking"]	            = LoadFX("maps/afghanistan/fx_afgh_fire_cooking");				
			
		 
	// Fires and Smoke
	level._effect["fx_fire_sm_smolder"]				      = LoadFX("env/fire/fx_fire_sm_smolder");
	level._effect["fx_fire_md_smolder"]				      = LoadFX("env/fire/fx_fire_md_smolder");
	level._effect["fx_smoke_building_xlg"]			    = LoadFX("env/smoke/fx_la_smk_plume_buidling_xlg");	
	
	// Exploders
	level._effect["fx_afgh_wall_edge_crumble"]			 = LoadFX("maps/afghanistan/fx_afgh_wall_edge_crumble");
	level._effect["fx_afgh_ceiling_dust_tunnel_os"]  = LoadFX("maps/afghanistan/fx_afgh_ceiling_dust_tunnel_os");			
	level._effect["fx_mortarexp_sand"]			         = LoadFX("explosions/fx_mortarexp_sand");	
	level._effect["fx_grenadeexp_sand"]			         = LoadFX("explosions/fx_grenadeexp_sand");
	level._effect["fx_afgh_tower_explo"]	           = LoadFX("maps/afghanistan/fx_afgh_tower_explo");
	level._effect["fx_afgh_tower_explo_collide"]	   = LoadFX("maps/afghanistan/fx_afgh_tower_explo_collide");			
	level._effect["fx_afgh_interrog_numbers_amb"]	   = LoadFX("maps/afghanistan/fx_afgh_interrog_numbers_amb");	
	level._effect["fx_afgh_dest_bridge"]			       = LoadFX("maps/afghanistan/fx_afgh_dest_bridge");
	level._effect["fx_afgh_cliff_explo"]	           = LoadFX("maps/afghanistan/fx_afgh_cliff_explo");		
	level._effect["fx_afgh_cliff_explo_grnd_impact"] = LoadFX("maps/afghanistan/fx_afgh_cliff_explo_grnd_impact");			
	level._effect["fx_afgh_water_tower_explo"]	     = LoadFX("maps/afghanistan/fx_afgh_water_tower_explo");
	level._effect["fx_afgh_water_tower_impact"]	     = LoadFX("maps/afghanistan/fx_afgh_water_tower_impact");
	level._effect["fx_afgh_heli_cliff_impact"]	     = LoadFX("maps/afghanistan/fx_afgh_heli_cliff_impact");
	level._effect["fx_afgh_heli_cliff_crash"]	       = LoadFX("maps/afghanistan/fx_afgh_heli_cliff_crash");				
	level._effect["fx_exp_afgh_heli_ground"]			   = LoadFX("explosions/fx_exp_afgh_heli_ground");	
	level._effect["fx_afgh_statue_explo"]	           = LoadFX("maps/afghanistan/fx_afgh_statue_explo");		
	level._effect["fx_afgh_statue_grnd_impact"]	     = LoadFX("maps/afghanistan/fx_afgh_statue_grnd_impact");
	level._effect["fx_afgh_statue_grnd_impact_sm"]	 = LoadFX("maps/afghanistan/fx_afgh_statue_grnd_impact_sm");			
	level._effect["fx_afgh_explo_bp1_dome"]	         = LoadFX("maps/afghanistan/fx_afgh_explo_bp1_dome");
	level._effect["fx_afgh_explo_wave_bp1_dome"]	   = LoadFX("maps/afghanistan/fx_afgh_explo_wave_bp1_dome");
	level._effect["fx_afgh_mortar_launch_fake"]	     = LoadFX("maps/afghanistan/fx_afgh_mortar_launch_fake");					
	level._effect["fx_afgh_time_lapse_clouds"]	     = LoadFX("maps/afghanistan/fx_afgh_time_lapse_clouds");	
	level._effect["fx_afgh_clouds"]                  = LoadFX("maps/afghanistan/fx_afgh_clouds");		
	level._effect["fx_afgh_time_lapse_sand"]	       = LoadFX("maps/afghanistan/fx_afgh_time_lapse_sand");
	level._effect["fx_afgh_pulwar_spark"]	           = LoadFX("maps/afghanistan/fx_afgh_pulwar_spark");	
	level._effect["fx_afgh_mortar_cook_off"]	       = LoadFX("maps/afghanistan/fx_afgh_mortar_cook_off");			
	level._effect["fx_afgh_pillar_fall"]	           = LoadFX("maps/afghanistan/fx_afgh_pillar_fall");
	level._effect["fx_afgh_cliff_crumble"]	         = LoadFX("maps/afghanistan/fx_afgh_cliff_crumble");					
	
	level._effect["fx_afgh_gas_cloud_lg"]	           = LoadFX("maps/afghanistan/fx_afgh_gas_cloud_lg");
	level._effect["fx_afgh_gas_cloud_lg_push"]	     = LoadFX("maps/afghanistan/fx_afgh_gas_cloud_lg_push");

	// Spotlights
	level._effect[ "spotlight_intro" ] = LoadFX( "light/fx_afgh_spot_intro" );
	level._effect[ "spotlight_cave" ] = LoadFX( "light/fx_afgh_spot_cave" );
}

wind_initial_setting()
{
	SetSavedDvar( "wind_global_vector", "-172 28 0" );		// change "0 0 0" to your wind vector
	SetSavedDvar( "wind_global_low_altitude", 0);			// change 0 to your wind's lower bound
	SetSavedDvar( "wind_global_hi_altitude", 2775);			// change 10000 to your wind's upper bound
	SetSavedDvar( "wind_global_low_strength_percent", 1.0);	// change 0.5 to your desired wind strength percentage
}


main()
{
	precache_util_fx();
	precache_createfx_fx();
	precache_scripted_fx();
	initModelAnims();	

	footsteps();

	// calls the createfx server script (i.e., the list of ambient effects and their attributes)
	maps\createfx\afghanistan_fx::main();

	wind_initial_setting();
}

footsteps()
{
	LoadFX( "bio/player/fx_footstep_dust" );
	LoadFX( "bio/player/fx_footstep_dust" );
}

bridge_short_01_cacheside(bridge)
{
	short_01_cacheside = getent( "short_01_cacheside", "targetname");
	short_01_cacheside playsound ( "fxa_bridge_fall_short_1_cache");
	short_01_cacheside delete();
}

bridge_short_01_towerside(bridge)
{
	short_01_towerside = spawn ( "script_origin" , (3744, -5128, 144));
	//short_01_towerside = getent( "short_01_towerside", "targetname");
	//I couldn't figure out why script did not see the entity in Radiant, so I used brute force. --GS
	short_01_towerside playsound ( "fxa_bridge_fall_short_1_tower");
	short_01_towerside delete();
}

bridge_short_02_cacheside(bridge)
{
	short_02_cacheside = getent( "short_02_cacheside", "targetname");
	short_02_cacheside playsound ( "fxa_bridge_fall_short_2_cache");
	short_02_cacheside delete();
}

bridge_short_02_towerside(bridge)
{
	short_02_towerside = getent( "short_02_towerside", "targetname");
	short_02_towerside playsound ( "fxa_bridge_fall_short_2_tower");
	short_02_towerside delete();
}

bridge_long_01_cacheside(bridge)
{
	long_01_cacheside = getent( "long_01_cacheside", "targetname");
	long_01_cacheside playsound ( "fxa_bridge_fall_long_1_cache");
	long_01_cacheside delete();
}

bridge_long_01_towerside(bridge)
{
	long_01_towerside = getent( "long_01_towerside", "targetname");
	long_01_towerside playsound ( "fxa_bridge_fall_long_1_tower");
	long_01_towerside delete();
}

bridge_long_02_cacheside(bridge)
{
	long_02_cacheside = getent( "long_02_cacheside", "targetname");
	long_02_cacheside playsound ( "fxa_bridge_fall_long_2_cache");
	long_02_cacheside delete();
}

bridge_long_02_towerside(bridge)
{
	long_02_towerside = getent( "long_02_towerside", "targetname");
	long_02_towerside playsound ( "fxa_bridge_fall_long_2_tower");
	long_02_towerside delete();
}
