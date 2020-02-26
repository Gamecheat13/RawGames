#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#using_animtree("fxanim_props");

main()
{	
	initModelAnims();
	precache_util_fx();
	precache_createfx_fx();
	precache_scripted_fx();
	wind_initial_setting();	
	
	// calls the createfx server script (i.e., the list of ambient effects and their attributes)
	maps\createfx\pow_fx::main();
	
	maps\createart\pow_art::main();
}

// fx used by util scripts
precache_util_fx()
{

}

// Scripted effects
precache_scripted_fx()
{
	//Bloody Effect Impact
	level._effect["flesh_hit"] = LoadFX("impacts/fx_flesh_hit_body_fatal_lg_exit_mp");

	//-- SAM
	level._effect["sam_launch"] = LoadFX("weapon/missile/fx_missile_sam_launch");
	level._effect["cave_explode"] = LoadFX("maps/pow/fx_pow_sam_cave_exp");
	
	//-- Damage FX for Enemy Hind
	level._effect["prop_smoke"] = LoadFX("vehicle/vfire/fx_vsmoke_hind_trail");
	level._effect["prop_main"] = LoadFX("vehicle/props/fx_hind_main_blade_full");
	level._effect["prop_tail"] = LoadFX("vehicle/props/fx_hind_small_blade_full"); 
	//level._effect["prop_tail_smoke"] = LoadFX("vehicle/props/fx_hind_small_blade_damaged"); //-- unused and removed
	level._effect["prop_smoke_large"] = LoadFX("vehicle/vfire/fx_vsmoke_hind_trail_lrg");
	level._effect["hip_dead"] = LoadFX("vehicle/vexplosion/fx_vexp_hip_ground_impact");
	level._effect["hind_dead"] = LoadFX("vehicle/vexplosion/fx_vexplode_hind_aerial_sm");
	level._effect["hind_dead_large"] = LoadFX("vehicle/vexplosion/fx_vexplode_hind_aerial");
	
	//-- Damage FX for Inside Player Helicopter
	level._effect["panel_dmg_sm"] = LoadFX("maps/pow/fx_dmg_helo_panel_sm");
	level._effect["panel_dmg_md"] = LoadFX("maps/pow/fx_dmg_helo_panel_md");
	level._effect["wire_fx_internal"] = LoadFX("maps/pow/fx_pow_dmg_spark_wire_cockpit");
	level._effect["wire_fx"] = LoadFX("maps/pow/fx_pow_spark_wire_cockpit_fxr");
	
	//-- Pipes
	level._effect["pipe_lg"] = LoadFX("maps/pow/fx_pow_pipebridge_explo_lg");
	level._effect["pipe_md"] = LoadFX("maps/pow/fx_pow_pipebridge_explo_md");
	level._effect["pipe_sm"] = LoadFX("maps/pow/fx_pow_pipebridge_explo_sm");
	level._effect["tank_wave"] = LoadFX("explosions/fx_exp_pressure_wave");
	
	//-- lingering pipe fires
	level._effect["pipe_fire_lg"] = LoadFX("env/fire/fx_fire_jun_pipeline_d1");
	level._effect["pipe_fire_lg_b"] = LoadFX("env/fire/fx_fire_jun_pipeline_d1_b");
	level._effect["pipe_fire_xlg"] = LoadFX("env/fire/fx_fire_jun_pipeline_d2");
	
	//-- Weather
//	level._effect["rain"] = LoadFX("maps/pow/fx_rain_pow");
	
	//-- Player Death
	level._effect["player_explo"] = LoadFX("vehicle/vexplosion/fx_vexplode_hind_aerial");
	
	//-- Drone FX
	level._effect["drone_impact"] = LoadFX("maps/pow/fx_pow_drone_impact");
	level._effect["drone_explode"] = LoadFX("maps/pow/fx_pow_water_buf_impact");
	
	level._effect["grenade_explode"] = LoadFX("explosions/fx_grenadeexp_dirt");
	
	//character burn fx
	level._effect["character_fire_pain_sm"]     = LoadFX("env/fire/fx_fire_player_sm_1sec");
	level._effect["character_fire_death_sm"]    = LoadFX("env/fire/fx_fire_player_md");
	level._effect["character_fire_death_torso"] = LoadFX("env/fire/fx_fire_player_torso");
	
	level._effect["pow_bookie_gore"] = LoadFX("maps/pow/fx_pow_bookie_gore");
	//level._effect["pow_escape_gore"] = LoadFX("maps/pow/fx_pow_escape_gore");	
	level._effect["krav_stab"] = LoadFX("maps/pow/fx_pow_stab_gore");
	
	//-- Bowman's Head
	level._effect["bowman_head_hit"] = LoadFX("maps/pow/fx_pow_shovel_gore");
	level._effect["bowman_spit"] = LoadFX("maps/pow/fx_pow_spit");
	
	//Bloody Effect Impact
	level._effect["flesh_hit"]							= LoadFX("impacts/fx_flesh_hit_body_fatal_lg_exit_mp");
	
}

// Ambient effects
precache_createfx_fx()
{
  level._effect["fx_pow_smoke_napalm_md"]           = LoadFX("maps/pow/fx_pow_smoke_napalm_md");		
  level._effect["fx_pow_smoke_napalm_xlg"]          = LoadFX("maps/pow/fx_pow_smoke_napalm_xlg");	
  level._effect["fx_pow_cloud_md"]                  = LoadFX("env/weather/fx_pow_cloud_md");
  level._effect["fx_pow_cloud_lg"]                  = LoadFX("env/weather/fx_pow_cloud_lg");
  level._effect["fx_pow_floating_wood"]             = LoadFX("maps/pow/fx_pow_floating_wood");
  level._effect["fx_leaves_falling_mangrove_lg"]    = LoadFX("env/foliage/fx_leaves_falling_mangrove_lg"); 
  level._effect["fx_pow_waterfall_giant"]           = LoadFX("maps/pow/fx_pow_waterfall_giant");   

  level._effect["fx_water_river_wake_md"]           = LoadFX("env/water/fx_water_river_wake_md");  
  level._effect["fx_water_river_wake_lg"]           = LoadFX("env/water/fx_water_river_wake_lg"); 
  level._effect["fx_pow_river_wake_short"]          = LoadFX("maps/pow/fx_pow_river_wake_short");  
  level._effect["fx_pow_river_wake_thin"]           = LoadFX("maps/pow/fx_pow_river_wake_thin");  
  level._effect["fx_pow_waterfall_bottom"]          = LoadFX("maps/pow/fx_pow_waterfall_bottom");     
  level._effect["fx_water_conc_bridge_wake"]        = LoadFX("env/water/fx_water_conc_bridge_wake");   
  
  level._effect["fx_quag_birds_gen_right"]          = LoadFX("maps/quagmire/fx_quag_birds_gen_right");
  level._effect["fx_quag_birds_gen_left"]           = LoadFX("maps/quagmire/fx_quag_birds_gen_left"); 
	level._effect["fx_pow_insect_lamps"]	            = LoadFX("maps/pow/fx_pow_insect_lamps");
	level._effect["fx_pow_insect_swarm"]	            = LoadFX("maps/pow/fx_pow_insect_swarm");
	level._effect["fx_pow_dragonfly"]	               = LoadFX("maps/pow/fx_pow_dragonfly");
	level._effect["fx_pow_godray_sm"]	               = LoadFX("maps/pow/fx_pow_godray_sm");		
	level._effect["fx_pow_godray_md"]	               = LoadFX("maps/pow/fx_pow_godray_md");
	level._effect["fx_pow_godray_lg"]	               = LoadFX("maps/pow/fx_pow_godray_lg");
	level._effect["fx_pow_ground_mist"]	             = LoadFX("maps/pow/fx_pow_ground_mist");  
	
	level._effect["fx_pow_cave_bulb_light"]	       = loadfx("maps/pow/fx_pow_cave_bulb_light"); 		
	level._effect["fx_pow_cave_tinhat_light"]	     = loadfx("maps/pow/fx_pow_cave_tinhat_light"); 
	level._effect["fx_pow_cave_water_fall"]	       = loadfx("maps/pow/fx_pow_cave_water_fall"); 		
	level._effect["fx_pow_cave_water_fall_sm"]     = loadfx("maps/pow/fx_pow_cave_water_fall_sm"); 				
	level._effect["fx_pow_cave_water_splash"]	     = loadfx("maps/pow/fx_pow_cave_water_splash"); 
  level._effect["fx_pow_cave_water_wake"]	       = loadfx("maps/pow/fx_pow_cave_water_wake");
  level._effect["fx_pow_cave_water_wake_fast"]	 = loadfx("maps/pow/fx_pow_cave_water_wake_fast");
  level._effect["fx_pow_dust_motes_med"]	       = loadfx("maps/pow/fx_pow_dust_motes_med");    
  level._effect["fx_pow_tunnel_drip"]	           = loadfx("maps/pow/fx_pow_tunnel_drip"); 	    	  	
	level._effect["fx_pow_mist_tunnel"]	           = loadfx("maps/pow/fx_pow_mist_tunnel");
	level._effect["fx_pow_cave_debris_falling"]	   = loadfx("maps/pow/fx_pow_cave_debris_falling");	
	
	level._effect["fx_pow_window_break"]	         = loadfx("maps/pow/fx_pow_window_break");
	level._effect["fx_pow_finale_explo"]	         = loadfx("maps/pow/fx_pow_finale_explo");			 			 				      				        
    
// Exploders
 level._effect["pow_woodbridge_explo"]           = LoadFX("destructibles/fx_pow_woodbridge_explo"); 
 level._effect["pow_woodbridge_splash"]          = LoadFX("destructibles/fx_pow_woodbridge_splash");
 level._effect["pow_concbridge_explo"]				  	= LoadFX("destructibles/fx_dest_concrete_bridge");
 
 level._effect["exp_pressure_wave"]             = LoadFX("explosions/fx_exp_pressure_wave"); 
 level._effect["pow_fire_column_md"]            = LoadFX("maps/pow/fx_pow_fire_column_md");
 level._effect["pow_fire_column_lg"]            = LoadFX("maps/pow/fx_pow_fire_column_lg");
 level._effect["pow_fire_line_lg"]              = LoadFX("maps/pow/fx_pow_fire_line_lg"); 
 level._effect["pow_fire_fuel_sm"]              = LoadFX("maps/pow/fx_pow_fire_fuel_sm"); 
 level._effect["pow_fire_fuel_lg"]              = LoadFX("maps/pow/fx_pow_fire_fuel_lg");

 level._effect["pow_sam_cave_exp_sm"]           = LoadFX("maps/pow/fx_pow_sam_cave_exp_sm");
 level._effect["pow_cave_collapse_exp"]         = LoadFX("maps/pow/fx_pow_cave_collapse_exp");
 level._effect["pow_cave_collapse_smoke"]       = LoadFX("maps/pow/fx_pow_cave_collapse_smoke");         
 
 level._effect["fx_heli_dust_cockpit_view_1"]   = LoadFX("vehicle/treadfx/fx_heli_dust_cockpit_view_1");
 
 level._effect["fx_pow_ceiling_trapdoor_dust"]  = LoadFX("maps/pow/fx_pow_ceiling_trapdoor_dust");   
}

wind_initial_setting()
{
	SetSavedDvar( "wind_global_vector", "150 -35 0" );      // change "0 0 0" to your wind vector
	SetSavedDvar( "wind_global_low_altitude", 0);           // change 0 to your wind's lower bound
	SetSavedDvar( "wind_global_hi_altitude", 580);          // change 10000 to your wind's upper bound
	SetSavedDvar( "wind_global_low_strength_percent", 0.05); // change 0.5 to your desired wind strength percentage
}

// FXanim Props
initModelAnims()
{

	level.scr_anim["fxanim_props"]["a_pipebridge_rope"] = %fxanim_pow_pipebridge_rope_anim;
	level.scr_anim["fxanim_props"]["a_tree_01_a"] = %fxanim_gp_tree_aquilaria_dest01_anim;
	level.scr_anim["fxanim_props"]["a_tree_01_b"] = %fxanim_gp_tree_aquilaria_dest02_anim;
	level.scr_anim["fxanim_props"]["a_tree_02_a"] = %fxanim_gp_tree_palm_coco02_dest01_anim;
	level.scr_anim["fxanim_props"]["a_tree_02_b"] = %fxanim_gp_tree_palm_coco02_dest02_anim;
	level.scr_anim["fxanim_props"]["a_tent"] = %fxanim_pow_tent_collapse01_anim;
	level.scr_anim["fxanim_props"]["a_cave_debris"] = %fxanim_pow_cave_debris_anim;
	level.scr_anim["fxanim_props"]["a_tarp_crate_stack"] = %fxanim_gp_tarp_crate_stack_anim;
	level.scr_anim["fxanim_props"]["a_radar_tower"] = %fxanim_pow_radar_tower_anim;
	level.scr_anim["fxanim_props"]["a_hind_dashboard_break"] = %fxanim_gp_hind_dashboard_break_anim;
	level.scr_anim["fxanim_props"]["a_hind_dashboard_dmg"] = %fxanim_gp_hind_dashboard_dmg_anim;
	level.scr_anim["fxanim_props"]["a_hind_periscope_dmg"] = %fxanim_gp_hind_periscope_dmg_anim;
	level.scr_anim["fxanim_props"]["a_hind_top_light_idle"] = %fxanim_gp_hind_top_light_idle_anim;
	level.scr_anim["fxanim_props"]["a_hind_top_light_break"] = %fxanim_gp_hind_top_light_break_anim;
	level.scr_anim["fxanim_props"]["a_hind_top_light_dmg"] = %fxanim_gp_hind_top_light_dmg_anim;
	level.scr_anim["fxanim_props"]["a_hind_wire01_break"] = %fxanim_gp_hind_wire01_break_anim;
	level.scr_anim["fxanim_props"]["a_hind_wire01_dmg"] = %fxanim_gp_hind_wire01_dmg_anim;
	level.scr_anim["fxanim_props"]["a_hind_wire02_break"] = %fxanim_gp_hind_wire02_break_anim;
	level.scr_anim["fxanim_props"]["a_hind_wire02_dmg"] = %fxanim_gp_hind_wire02_dmg_anim;
	level.scr_anim["fxanim_props"]["a_tent_flap01"] = %fxanim_pow_tent_flap01_anim;
	level.scr_anim["fxanim_props"]["a_tent_flap02"] = %fxanim_pow_tent_flap02_anim;
	level.scr_anim["fxanim_props"]["a_rat_01"] = %fxanim_pow_rat_01_anim;	
	level.scr_anim["fxanim_props"]["a_rat_02"] = %fxanim_pow_rat_02_anim;		
	level.scr_anim["fxanim_props"]["a_rat_03"] = %fxanim_pow_rat_03_anim;
	level.scr_anim["fxanim_props"]["a_cargohanging_hang"] = %fxanim_pow_cargohanging_hang_anim;
	level.scr_anim["fxanim_props"]["a_cargohanging_lean"] = %fxanim_pow_cargohanging_lean_anim;
	level.scr_anim["fxanim_props"]["a_cliff_debris1_01"] = %fxanim_pow_cliff_debris1_01_anim;			
	level.scr_anim["fxanim_props"]["a_cliff_debris1_02"] = %fxanim_pow_cliff_debris1_02_anim;	
	level.scr_anim["fxanim_props"]["a_cliff_debris2_01"] = %fxanim_pow_cliff_debris2_01_anim;	
	level.scr_anim["fxanim_props"]["a_cliff_debris2_02"] = %fxanim_pow_cliff_debris2_02_anim;	
	level.scr_anim["fxanim_props"]["a_cliff_debris3_03"] = %fxanim_pow_cliff_debris3_03_anim;
	level.scr_anim["fxanim_props"]["a_armored_window"] = %fxanim_pow_armoredwindow_break_anim;		
	
	addNotetrack_customFunction( "fxanim_props", "house_crush", ::radar_crush_house, "a_radar_tower" );


	ent1 = getent( "fxanim_pow_woodbridge_mod", "targetname" );
	ent2 = getent( "concbridge_lrg_sect01", "targetname" );
	ent3 = getent( "concbridge_lrg_sect02", "targetname" );
	ent4 = getent( "concbridge_lrg_sect03", "targetname" );
	ent5 = getent( "concbridge_lrg_sect04", "targetname" );
	ent6 = getent( "concbridge_sm_sect01", "targetname" );
	ent7 = getent( "concbridge_sm_sect02", "targetname" );
	ent8 = getent( "fxanim_pow_pipebridge_01_mod", "targetname" );
	ent9 = getent( "fxanim_pow_pipebridge_02_mod", "targetname" );
	ent10 = getent( "fxanim_pow_pipebridge_03_mod", "targetname" );
	ent11 = getent( "fxanim_pow_tent_mod_01", "targetname" );
	ent12 = getent( "fxanim_pow_tent_mod_02", "targetname" );
	ent13 = getent( "fxanim_pow_tent_mod_03", "targetname" );
	ent14 = getent( "fxanim_pow_tent_mod_04", "targetname" );
	ent15 = getent( "fxanim_pow_cave_debris_mod", "targetname" );
	ent16 = getent( "fxanim_gp_tarp_crate_stack_mod", "targetname" );
	ent17 = getent( "fxanim_pow_radar_tower_mod", "targetname" );
	ent18 = getent( "fxanim_gp_hind_dashboard_mod", "targetname" );
	ent19 = getent( "fxanim_gp_hind_periscope_mod", "targetname" );
	ent20 = getent( "fxanim_gp_hind_top_light_mod", "targetname" );
	ent21 = getent( "fxanim_gp_hind_wire01_mod", "targetname" );
	ent22 = getent( "fxanim_gp_hind_wire02_mod", "targetname" );
	ent23 = getent( "fxanim_pow_tent_flap_mod", "targetname" );
	ent24 = getent( "fxanim_pow_rat_01_anim", "targetname" );
	ent25 = getent( "fxanim_pow_rat_02_anim", "targetname" );
	ent26 = getent( "fxanim_pow_rat_03_anim", "targetname" );
	ent27 = getent( "cargohanging_01", "targetname" );
	ent28 = getent( "cargohanging_02", "targetname" );
	ent29 = getent( "cargohanging_03", "targetname" );
	ent30 = getent( "cargohanging_04", "targetname" );	
	ent31 = getent( "cargohanging_05", "targetname" );
	ent32 = getent( "cliff_debris1_01", "targetname" );
	ent33 = getent( "cliff_debris1_02", "targetname" );
	ent34 = getent( "cliff_debris1_03", "targetname" );
	ent35 = getent( "cliff_debris1_04", "targetname" );
	ent36 = getent( "cliff_debris1_05", "targetname" );	
	ent37 = getent( "cliff_debris1_06", "targetname" );	
	ent38 = getent( "cliff_debris1_07", "targetname" );		
	ent39 = getent( "cliff_debris2_01", "targetname" );
	ent40 = getent( "cliff_debris2_02", "targetname" );
	ent41 = getent( "cliff_debris2_03", "targetname" );
	ent42 = getent( "cliff_debris2_04", "targetname" );
	ent43 = getent( "cliff_debris2_05", "targetname" );	
	ent44 = getent( "cliff_debris2_06", "targetname" );	
	ent45 = getent( "cliff_debris2_07", "targetname" );	
	ent46 = getent( "fxanim_pow_armoredwindow_break_mod", "targetname" );	
	
	
	if (IsDefined(ent1)) 
	{
		ent1 thread woodbridge();
		println("************* FX: woodbridge *************");
	}
	
	if (IsDefined(ent2)) 
	{
		ent2 thread concbridge_lrg_sect01();
		println("************* FX: concbridge_lrg_sect01 *************");
	}
	
	if (IsDefined(ent3)) 
	{
		ent3 thread concbridge_lrg_sect02();
		println("************* FX: concbridge_lrg_sect02 *************");
	}
	
	if (IsDefined(ent4)) 
	{
		ent4 thread concbridge_lrg_sect03();
		println("************* FX: concbridge_lrg_sect03 *************");
	}
	
	if (IsDefined(ent5)) 
	{
		ent5 thread concbridge_lrg_sect04();
		println("************* FX: concbridge_lrg_sect04 *************");
	}
	
	if (IsDefined(ent6)) 
	{
		ent6 thread concbridge_sm_sect01();
		println("************* FX: concbridge_sm_sect01 *************");
	}
	
	if (IsDefined(ent7)) 
	{
		ent7 thread concbridge_sm_sect02();
		println("************* FX: concbridge_sm_sect02 *************");
	}
	
	if (IsDefined(ent8)) 
	{
		ent8 thread pipebridge_01();
		println("************* FX: pipebridge_01 *************");
	}
	
	if (IsDefined(ent9)) 
	{
		ent9 thread pipebridge_02();
		println("************* FX: pipebridge_02 *************");
	}
	
	if (IsDefined(ent10)) 
	{
		ent10 thread pipebridge_03();
		println("************* FX: pipebridge_03 *************");
	}
	
	if (IsDefined(ent11)) 
	{
		ent11 thread tent_01();
		println("************* FX: tent_01 *************");
	}
	
	if (IsDefined(ent12)) 
	{
		ent12 thread tent_02();
		println("************* FX: tent_02 *************");
	}
	
	if (IsDefined(ent13)) 
	{
		ent13 thread tent_03();
		println("************* FX: tent_03 *************");
	}
	
	if (IsDefined(ent14)) 
	{
		ent14 thread tent_04();
		println("************* FX: tent_04 *************");
	}
	
	if (IsDefined(ent15)) 
	{
		ent15 thread cave_debris();
		println("************* FX: cave_debris *************");
	}
	
	if (IsDefined(ent16)) 
	{
		ent16 thread tarp_crate_stack();
		println("************* FX: tarp_crate_stack *************");
	}
	
	if (IsDefined(ent17)) 
	{
		ent17 thread radar_tower();
		println("************* FX: radar_tower *************");
	}
	
	if (IsDefined(ent18)) 
	{
		ent18 thread hind_dashboard();
		println("************* FX: hind_dashboard *************");
	}
	
	if (IsDefined(ent19)) 
	{
		ent19 thread hind_periscope();
		println("************* FX: hind_periscope *************");
	}
	
	if (IsDefined(ent20)) 
	{
		ent20 thread hind_top_light();
		ent20 thread hind_top_light_break();
		println("************* FX: hind_top_light *************");
	}
	
	if (IsDefined(ent21)) 
	{
		ent21 thread hind_wire01();
		println("************* FX: hind_wire01 *************");
	}
	
	if (IsDefined(ent22)) 
	{
		ent22 thread hind_wire02();
		println("************* FX: hind_wire02 *************");
	}
	
	if (IsDefined(ent23)) 
	{
		ent23 thread tent_flap();
		println("************* FX: tent_flap *************");
	}
	
	if (IsDefined(ent24)) 
	{
		ent24 thread rat_01();
		println("************* FX: rat_01 *************");
	}

	if (IsDefined(ent25)) 
	{
		ent25 thread rat_02();
		println("************* FX: rat_02 *************");
	}
	
	if (IsDefined(ent26)) 
	{
		ent26 thread rat_03();
		println("************* FX: rat_03 *************");
	}	
		
	if (IsDefined(ent27)) 
	{
		ent27 thread cargohanging_01();
		println("************* FX: cargohanging_01 *************");
	}			

	if (IsDefined(ent28)) 
	{
		ent28 thread cargohanging_02();
		println("************* FX: cargohanging_02 *************");
	}			
		
	if (IsDefined(ent29)) 
	{
		ent29 thread cargohanging_03();
		println("************* FX: cargohanging_03 *************");
	}			
		
	if (IsDefined(ent30)) 
	{
		ent30 thread cargohanging_04();
		println("************* FX: cargohanging_04 *************");
	}			

		
	if (IsDefined(ent31)) 
	{
		ent31 thread cargohanging_05();
		println("************* FX: cargohanging_05 *************");
	}			

	if (IsDefined(ent32)) 
	{
		ent32 thread cliff_debris1_01();
		println("************* FX: cliff_debris1_01 *************");
	}	

	if (IsDefined(ent33)) 
	{
		ent33 thread cliff_debris1_02();
		println("************* FX: cliff_debris1_02 *************");
	}	

	if (IsDefined(ent34)) 
	{
		ent34 thread cliff_debris1_03();
		println("************* FX: cliff_debris1_03 *************");
	}	
	
	if (IsDefined(ent35)) 
	{
		ent35 thread cliff_debris1_04();
		println("************* FX: cliff_debris1_04 *************");
	}	
	
	if (IsDefined(ent36)) 
	{
		ent36 thread cliff_debris1_05();
		println("************* FX: cliff_debris1_05 *************");
	}			
	
	if (IsDefined(ent37)) 
	{
		ent37 thread cliff_debris1_06();
		println("************* FX: cliff_debris1_06 *************");
	}		
	
	if (IsDefined(ent38)) 
	{
		ent38 thread cliff_debris1_07();
		println("************* FX: cliff_debris1_07 *************");
	}			

	if (IsDefined(ent39)) 
	{
		ent39 thread cliff_debris2_01();
		println("************* FX: cliff_debris2_01 *************");
	}	

	if (IsDefined(ent40)) 
	{
		ent40 thread cliff_debris2_02();
		println("************* FX: cliff_debris2_02 *************");
	}	

	if (IsDefined(ent41)) 
	{
		ent41 thread cliff_debris2_03();
		println("************* FX: cliff_debris2_03 *************");
	}	
	
	if (IsDefined(ent42)) 
	{
		ent42 thread cliff_debris2_04();
		println("************* FX: cliff_debris2_04 *************");
	}	
	
	if (IsDefined(ent43)) 
	{
		ent43 thread cliff_debris2_05();
		println("************* FX: cliff_debris2_05 *************");
	}			
	
	if (IsDefined(ent44)) 
	{
		ent44 thread cliff_debris2_06();
		println("************* FX: cliff_debris2_06 *************");
	}		
	
	if (IsDefined(ent45)) 
	{
		ent45 thread cliff_debris2_07();
		println("************* FX: cliff_debris2_07 *************");
	}
	
	if (IsDefined(ent46)) 
	{
		ent46 thread armored_window();
		println("************* FX: armored_window *************");
	}			


	
// ARRAYS
	tree_array = GetEntArray( "fxanim_tree", "targetname" );
	
	if(tree_array.size > 0) 
	{
		array_thread( tree_array, ::fx_treefall );
		println("************* FX: trees *************");
	}
}

#using_animtree("fxanim_props");
woodbridge()
{
	level waittill("woodbridge_start");
	
	//-- These are the explosions for when the bridge breaks
	exploder(101);
	exploder(102);
	
	//SOUND - Shawn J
	self PlaySound("evt_bridge_wood_explo");
	
	level thread maps\pow_utility::dialog_fly_extra("wooden_bridge");
		
	self UseAnimTree(#animtree);
	self animscripted("a_woodbridge", self.origin, self.angles, %fxanim_pow_woodbridge_anim);
}

concbridge_lrg_sect01()
{
	level waittill("concbridge_lrg_sect01_start");
	
	PlayFX(level._effect["pow_concbridge_explo"], self.origin);
	
	self thread maps\pow_utility::destroy_vehicles_disconnect_nodes();
	
	//SOUND - Shawn J
	self PlaySound("evt_bridge_lg_explo");
	
	self UseAnimTree(#animtree);
	self animscripted("a_concbridge_lrg_sect01", self.origin, self.angles, %fxanim_pow_concbridge_sect01_anim);
}

concbridge_lrg_sect02()
{
	level waittill("concbridge_lrg_sect02_start");
	
	PlayFX(level._effect["pow_concbridge_explo"], self.origin);
	
	self thread maps\pow_utility::destroy_vehicles_disconnect_nodes();
	
	//SOUND - Shawn J
	self PlaySound("evt_bridge_lg_explo");
	
	self UseAnimTree(#animtree);
	self animscripted("a_concbridge_lrg_sect02", self.origin, self.angles, %fxanim_pow_concbridge_sect02_anim);
}

concbridge_lrg_sect03()
{
	level waittill("concbridge_lrg_sect03_start");
	
	PlayFX(level._effect["pow_concbridge_explo"], self.origin);
	
	self thread maps\pow_utility::destroy_vehicles_disconnect_nodes();
	
	//SOUND - Shawn J
	self PlaySound("evt_bridge_lg_explo");
	
	self UseAnimTree(#animtree);
	self animscripted("a_concbridge_lrg_sect03", self.origin, self.angles, %fxanim_pow_concbridge_sect03_anim);
}

concbridge_lrg_sect04()
{
	level waittill("concbridge_lrg_sect04_start");
	
	PlayFX(level._effect["pow_concbridge_explo"], self.origin);
	
	self thread maps\pow_utility::destroy_vehicles_disconnect_nodes();
	
	//SOUND - Shawn J
	self PlaySound("evt_bridge_lg_explo");
	
	self UseAnimTree(#animtree);
	self animscripted("a_concbridge_lrg_sect04", self.origin, self.angles, %fxanim_pow_concbridge_sect01_anim);
}

concbridge_sm_sect01()
{
	level waittill("concbridge_sm_sect01_start");
	
	PlayFX(level._effect["pow_concbridge_explo"], self.origin);
	
	self thread maps\pow_utility::destroy_vehicles_disconnect_nodes();
	
	//SOUND - Shawn J
	self PlaySound("evt_bridge_sm_explo");
	
	self UseAnimTree(#animtree);
	self animscripted("a_concbridge_sm_sect01", self.origin, self.angles, %fxanim_pow_concbridge_sect01_anim);
}

concbridge_sm_sect02()
{
	level waittill("concbridge_sm_sect02_start");
	
	PlayFX(level._effect["pow_concbridge_explo"], self.origin);
	
	self thread maps\pow_utility::destroy_vehicles_disconnect_nodes();
	
	//SOUND - Shawn J
	self PlaySound("evt_bridge_sm_explo");
	
	self UseAnimTree(#animtree);
	self animscripted("a_concbridge_sm_sect02", self.origin, self.angles, %fxanim_pow_concbridge_sect02_anim);
}

pipebridge_01()
{
	for ( i=0; i<3; i++ )
	{
  	level waittill("pipebridge_01_start");
  	self UseAnimTree(#animtree);
  	anim_single(self, "a_pipebridge_rope", "fxanim_props");        
	}
}

pipebridge_02()
{
	for ( i=0; i<3; i++ )
	{
  	level waittill("pipebridge_02_start");
  	self UseAnimTree(#animtree);
  	anim_single(self, "a_pipebridge_rope", "fxanim_props");        
	}
}

pipebridge_03()
{
	for ( i=0; i<3; i++ )
	{
  	level waittill("pipebridge_03_start");
  	self UseAnimTree(#animtree);
  	anim_single(self, "a_pipebridge_rope", "fxanim_props");        
	}
}

fx_treefall() //self == tree
{
	level endon("kill_tree_behavior");
	
	self SetCanDamage(true);
	self.health = 1000;
	self waittill("damage");
	
	assert(IsDefined(self.script_noteworthy), "Tree does not have script_noteworthy");
	tree_anim = self.script_noteworthy;
	
	if(RandomInt(2) < 1)
	{
		tree_anim = tree_anim + "_a";
		//SOUND - Shawn J - tree fall sound A
		self PlaySound("dst_tree_A");
	}
	else
	{
		tree_anim = tree_anim + "_b";
		//SOUND - Shawn J - tree fall sound B
		self PlaySound("dst_tree_B");
	}	
	
	self UseAnimTree(#animtree);
	anim_single( self, tree_anim, "fxanim_props");
}

tent_01()
{
	self UseAnimTree(#animtree);
	self SetCanDamage(true);
	self waittill("damage");
	anim_single(self, "a_tent", "fxanim_props");
}

tent_02()
{
	self UseAnimTree(#animtree);
	self SetCanDamage(true);
	self waittill("damage");
	anim_single(self, "a_tent", "fxanim_props");
}

tent_03()
{
	self UseAnimTree(#animtree);
	self SetCanDamage(true);
	self waittill("damage");
	anim_single(self, "a_tent", "fxanim_props");
}

tent_04()
{
	self UseAnimTree(#animtree);
	self SetCanDamage(true);
	self waittill("damage");
	anim_single(self, "a_tent", "fxanim_props");
}

cave_debris()
{
	level waittill("cave_debris_start");
	
	//SOUND - Shawn J
	self PlaySound("evt_rock_fall");
	
	self UseAnimTree(#animtree);
	self thread anim_single(self, "a_cave_debris", "fxanim_props");
	
	while(1)
	{
		msg = "";
		self waittill( "single anim", msg );
		
		if(msg == "end")
		{
			return;
		}
		
		switch(msg)
		{
			
			case "upper_lip_one":
				exploder(6);
			break;
			
			case "upper_lip_two":
				exploder(8);
			break;
			
			case "cave_explode":
				exploder(7);
			break;
			
			case "chunk_water_hit":
				exploder(9);
			break;
						
			default:
			break;
		}
	}
}

tarp_crate_stack()
{
	level waittill("tarp_crate_stack_start");
	self UseAnimTree(#animtree);
	anim_single(self, "a_tarp_crate_stack", "fxanim_props");
}

radar_tower()
{
	level waittill("radar_tower_start");
	
	flag_set("vo_radar_destroyed");
	flag_set("radio_tower_destroyed"); //-- used for objectives
	
	//SOUND - Shawn J - radar tower explos & fall
	self playsound ("evt_radar_tower_hit");
	self notify("break"); //-- this is for objectives
	self UseAnimTree(#animtree);
	anim_single(self, "a_radar_tower", "fxanim_props");
}

radar_crush_house( guy )
{
	house = GetEnt("village_building_3", "script_noteworthy");
	house DoDamage( 100000, house.origin );
	
	level thread maps\pow_utility::dialog_fly_extra( "radio_tower_dead" );
	
	//-- delete the leftover vehicle clip
	vehicle_clip = GetEnt("tower_clip", "targetname");
	vehicle_clip Delete();
}

hind_dashboard()
{
	self endon("death");
	
	level waittill("hind_dashboard_start");
	self UseAnimTree(#animtree);
	anim_single(self, "a_hind_dashboard_break", "fxanim_props");
	anim_single(self, "a_hind_dashboard_dmg", "fxanim_props");
}

hind_periscope()
{
	self endon("death");
	
	level waittill("hind_periscope_start");
	self UseAnimTree(#animtree);
	anim_single(self, "a_hind_periscope_dmg", "fxanim_props");
}

hind_top_light()
{
	self endon("death");
	
	level waittill("hind_top_light_start");
	self UseAnimTree(#animtree);
	anim_single(self, "a_hind_top_light_idle", "fxanim_props");
}

hind_top_light_break()
{
	self endon("death");
	
	level waittill("hind_top_light_break_start");
	self UseAnimTree(#animtree);
	anim_single(self, "a_hind_top_light_break", "fxanim_props");
	anim_single(self, "a_hind_top_light_dmg", "fxanim_props");
}

hind_wire01()
{
	self endon("death");
	
	level waittill("hind_wire01_start");
	self UseAnimTree(#animtree);
	anim_single(self, "a_hind_wire01_break", "fxanim_props");
	anim_single(self, "a_hind_wire01_dmg", "fxanim_props");
	PlayFXOnTag( level._effect["wire_fx"], self, "tag_fx_wire01_spark1");
	PlayFXOnTag( level._effect["wire_fx"], self, "tag_fx_wire01_spark2");
}

hind_wire02()
{
	self endon("death");
	
	level waittill("hind_wire02_start");
	self UseAnimTree(#animtree);
	anim_single(self, "a_hind_wire02_break", "fxanim_props");
	anim_single(self, "a_hind_wire02_dmg", "fxanim_props");
	PlayFXOnTag( level._effect["wire_fx"], self, "tag_fx_wire02_spark1");
	PlayFXOnTag( level._effect["wire_fx"], self, "tag_fx_wire02_spark2");
}

tent_flap()
{
	level waittill("tent_flap01_start");
	self UseAnimTree(#animtree);
	self thread anim_single(self, "a_tent_flap01", "fxanim_props");
	level waittill("tent_flap02_start");
	anim_single(self, "a_tent_flap02", "fxanim_props");
}

rat_01()
{
	level waittill("rat_01_start");
	self UseAnimTree(#animtree);
	anim_single(self, "a_rat_01", "fxanim_props");
	self delete();
}

rat_02()
{
	level waittill("rat_01_start");
	self UseAnimTree(#animtree);
	anim_single(self, "a_rat_02", "fxanim_props");
	self delete();	
}

rat_03()
{
	level waittill("rat_01_start");
	self UseAnimTree(#animtree);
	anim_single(self, "a_rat_03", "fxanim_props");
	self delete();	
}

cargohanging_01()
{
	self endon("death");
  self UseAnimTree(#animtree);
  self SetCanDamage(true);
                
  while(true)
  {
  	self.health = 1000;
	  self waittill("damage");
	  anim_single(self, "a_cargohanging_hang", "fxanim_props");
  }
}

cargohanging_02()
{
	self endon("death");
  self UseAnimTree(#animtree);
  self SetCanDamage(true);
                
  while(true)
  {
  	self.health = 1000;
	  self waittill("damage");
	  anim_single(self, "a_cargohanging_lean", "fxanim_props");
  }
}

cargohanging_03()
{
	self endon("death");
  self UseAnimTree(#animtree);
  self SetCanDamage(true);
                
  while(true)
  {
  	self.health = 1000;
	  self waittill("damage");
	  anim_single(self, "a_cargohanging_lean", "fxanim_props");
  }
}

cargohanging_04()
{
	self endon("death");
  self UseAnimTree(#animtree);
  self SetCanDamage(true);
                
  while(true)
  {
  	self.health = 1000;
	  self waittill("damage");
	  anim_single(self, "a_cargohanging_hang", "fxanim_props");
  }
}

cargohanging_05()
{
	self endon("death");
  self UseAnimTree(#animtree);
  self SetCanDamage(true);
                
  while(true)
  {
  	self.health = 1000;
	  self waittill("damage");
	  anim_single(self, "a_cargohanging_hang", "fxanim_props");
  }
}

cliff_debris1_01()
{
	self UseAnimTree(#animtree);
	self SetCanDamage(true);
	self waittill("damage");
	anim_single(self, "a_cliff_debris1_02", "fxanim_props");
}

cliff_debris1_02()
{
	self UseAnimTree(#animtree);
	self SetCanDamage(true);
	self waittill("damage");
	anim_single(self, "a_cliff_debris2_01", "fxanim_props");
}

cliff_debris1_03()
{
	self UseAnimTree(#animtree);
	self SetCanDamage(true);
	self waittill("damage");
	anim_single(self, "a_cliff_debris2_02", "fxanim_props");
}

cliff_debris1_04()
{
	self UseAnimTree(#animtree);
	self SetCanDamage(true);
	self waittill("damage");
	anim_single(self, "a_cliff_debris3_03", "fxanim_props");
}

cliff_debris1_05()
{
	self UseAnimTree(#animtree);
	self SetCanDamage(true);
	self waittill("damage");
	anim_single(self, "a_cliff_debris2_02", "fxanim_props");
}

cliff_debris1_06()
{
	self UseAnimTree(#animtree);
	self SetCanDamage(true);
	self waittill("damage");
	anim_single(self, "a_cliff_debris1_02", "fxanim_props");
}

cliff_debris1_07()
{
	self UseAnimTree(#animtree);
	self SetCanDamage(true);
	self waittill("damage");
	anim_single(self, "a_cliff_debris2_02", "fxanim_props");
}

cliff_debris2_01()
{
	self UseAnimTree(#animtree);
	self SetCanDamage(true);
	self waittill("damage");
	anim_single(self, "a_cliff_debris1_02", "fxanim_props");
}

cliff_debris2_02()
{
	self UseAnimTree(#animtree);
	self SetCanDamage(true);
	self waittill("damage");
	anim_single(self, "a_cliff_debris2_01", "fxanim_props");
}

cliff_debris2_03()
{
	self UseAnimTree(#animtree);
	self SetCanDamage(true);
	self waittill("damage");
	anim_single(self, "a_cliff_debris2_02", "fxanim_props");
}

cliff_debris2_04()
{
	self UseAnimTree(#animtree);
	self SetCanDamage(true);
	self waittill("damage");
	anim_single(self, "a_cliff_debris3_03", "fxanim_props");
}

cliff_debris2_05()
{
	self UseAnimTree(#animtree);
	self SetCanDamage(true);
	self waittill("damage");
	anim_single(self, "a_cliff_debris2_02", "fxanim_props");
}

cliff_debris2_06()
{
	self UseAnimTree(#animtree);
	self SetCanDamage(true);
	self waittill("damage");
	anim_single(self, "a_cliff_debris1_02", "fxanim_props");
}

cliff_debris2_07()
{
	self UseAnimTree(#animtree);
	self SetCanDamage(true);
	self waittill("damage");
	anim_single(self, "a_cliff_debris2_02", "fxanim_props");
}

armored_window()
{
	self Hide();
	level waittill("armored_window_start");
	
	pristine = GetEnt("krav_glass_hide", "targetname");
	pristine Hide();
	
	//self PlaySound("evt_krav_window_break");
	
	self Show();
	self UseAnimTree(#animtree);
	anim_single(self, "a_armored_window", "fxanim_props");
}
