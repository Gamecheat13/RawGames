#include maps\_utility; 
#include common_scripts\utility; 
#include maps\_anim;
#include maps\khe_sanh_util;
#using_animtree("fxanim_props");

main()
{	
	initModelAnims();
	precache_createfx_fx();
	wind_initial_setting();		
	footsteps();
	
	// calls the createfx server script (i.e., the list of ambient effects and their attributes)
	maps\createfx\khe_sanh_fx::main();
}

// Ambient effects
precache_createfx_fx()
{
	level._effect["fx_ks_sand_blowing_sm"]	            = loadFX("maps/khe_sanh/fx_ks_sand_blowing_sm");
	level._effect["fx_ks_sand_blowing_lg"]	            = loadFX("maps/khe_sanh/fx_ks_sand_blowing_lg");
	level._effect["fx_ks_sand_blow_battle"]	            = loadFX("maps/khe_sanh/fx_ks_sand_blow_battle");	
	level._effect["fx_sand_windy_heavy_md"]						  = loadfx("env/weather/fx_sand_windy_heavy_md");	
	level._effect["fx_ks_ambient_aa_flak"]	            = loadFX("maps/khe_sanh/fx_ks_ambient_aa_flak");	
	level._effect["fx_ks_b52_flying_contrails"]	        = loadFX("maps/khe_sanh/fx_ks_b52_flying_contrails");		
	level._effect["fx_ks_b52_fast_contrails"]	          = loadFX("maps/khe_sanh/fx_ks_b52_fast_contrails");		
	level._effect["fx_ks_lz_smoke"]	                    = loadFX("maps/khe_sanh/fx_ks_lz_smoke");	
	level._effect["fx_ks_lz_smoke_scattered"]	          = loadFX("maps/khe_sanh/fx_ks_lz_smoke_scattered");			
	level._effect["fx_ks_smk_plume_sm_tall"]				    = LoadFX("maps/khe_sanh/fx_ks_smk_plume_sm_tall");			
	level._effect["fx_ks_smk_plume_md_tall"]				    = LoadFX("maps/khe_sanh/fx_ks_smk_plume_md_tall");	
	level._effect["fx_ks_smk_plume_lg_tall"]				    = LoadFX("maps/khe_sanh/fx_ks_smk_plume_lg_tall");			
	level._effect["fx_ks_smk_hillside"]				          = LoadFX("maps/khe_sanh/fx_ks_smk_hillside");		
	level._effect["fx_ks_smk_hillside_sm"]				      = LoadFX("maps/khe_sanh/fx_ks_smk_hillside_sm");			
	level._effect["fx_ks_smoldering_tree"]				      = LoadFX("maps/khe_sanh/fx_ks_smoldering_tree");						
	level._effect["fx_fire_md_fuel"]				            = LoadFX("env/fire/fx_fire_md_fuel");
	level._effect["fx_fire_line_xsm_thin"]				      = LoadFX("env/fire/fx_fire_line_xsm_thin");	
	level._effect["fx_ks_fire_line_sm"]				          = LoadFX("env/fire/fx_ks_fire_line_sm");		
	level._effect["fx_fire_detail_sm_nodlight"]				  = LoadFX("env/fire/fx_fire_detail_sm_nodlight");	
	level._effect["fx_smolder_mortar_crater"]			      = LoadFX("env/fire/fx_smolder_mortar_crater");		
	level._effect["fx_ks_bunker_smk_ashes"]	            = loadFX("maps/khe_sanh/fx_ks_bunker_smk_ashes");	
	level._effect["fx_pow_insect_swarm"]	              = loadFX("maps/pow/fx_pow_insect_swarm");
	level._effect["fx_ks_bunker_dust_md"]	              = loadFX("maps/khe_sanh/fx_ks_bunker_dust_md");
	level._effect["fx_dirt_crumble_tunnel_runner"]	    = LoadFX("env/dirt/fx_dirt_crumble_tunnel_runner");	
	level._effect["fx_elec_burst_shower_lg_runner"]	    = LoadFX("env/electrical/fx_elec_burst_shower_lg_runner");		
	level._effect["fx_ks_interior_motes"]	              = LoadFX("maps/khe_sanh/fx_ks_interior_motes");
	level._effect["fx_ks_jeep_exhaust"]	                = LoadFX("maps/khe_sanh/fx_ks_jeep_exhaust");	
	level._effect["fx_heli_dust_khe_sanh"]				      = LoadFX("vehicle/treadfx/fx_heli_dust_khe_sanh");	
	level._effect["fx_grenadeexp_dirt"]				          = LoadFX("explosions/fx_grenadeexp_dirt");	
	
	level._effect["fx_ks_exit_glow_os"]	                = LoadFX("maps/khe_sanh/fx_ks_exit_glow_os");	
	level._effect["fx_ks_god_ray_os"]	                  = LoadFX("maps/khe_sanh/fx_ks_god_ray_os");	

	//dirt edge
	level._effect["fx_ks_trench_dirt_edge"]	                  = LoadFX("maps/khe_sanh/fx_ks_trench_dirt_edge");	

  // Exploders
	level._effect["fx_ks_huey_landing"]	                = loadFX("maps/khe_sanh/fx_ks_huey_landing");
	level._effect["fx_ks_bowman_landing"]	              = loadFX("maps/khe_sanh/fx_ks_bowman_landing");	
	level._effect["fx_ks_apc_mortar_hit"]	              = loadFX("maps/khe_sanh/fx_ks_apc_mortar_hit");		
	level._effect["fx_ks_apc_crash"]	                  = loadFX("maps/khe_sanh/fx_ks_apc_crash");		
	level._effect["fx_ks_c130_crash"]	                  = loadFX("maps/khe_sanh/fx_ks_c130_crash");	
	level._effect["fx_ks_jeep_crash"]	                  = loadFX("maps/khe_sanh/fx_ks_jeep_crash");
	level._effect["fx_ks_jeep_windshield_event"]	      = loadFX("maps/khe_sanh/fx_ks_jeep_windshield_event");	
	level._effect["fx_ks_fall_on_grenade"]              = loadFX("maps/khe_sanh/fx_ks_fall_on_grenade");	
	level._effect["fx_ks_napalm_drop_dist"]				      = LoadFX("maps/khe_sanh/fx_ks_napalm_drop_dist");		
	level._effect["fx_ks_smk_napalm_md"]                = LoadFX("maps/khe_sanh/fx_ks_smk_napalm_md");
	level._effect["fx_ks_fire_sm"]                      = LoadFX("maps/khe_sanh/fx_ks_fire_sm");  			
	level._effect["fx_ks_napalm_trench_fire"]				    = LoadFX("maps/khe_sanh/fx_ks_napalm_trench_fire");	
	level._effect["fx_ks_fougasse"]                     = LoadFX("maps/khe_sanh/fx_ks_fougasse");  
	level._effect["fx_ks_mortar_shack_exp"]             = LoadFX("maps/khe_sanh/fx_ks_mortar_shack_exp");   
	level._effect["fx_ks_bunker_exp"]                   = LoadFX("maps/khe_sanh/fx_ks_bunker_exp");       	  
	level._effect["fx_ks_trenchjump_dirt_edge"]         = LoadFX("env/dirt/fx_ks_trenchjump_dirt_edge");
	level._effect["fx_ks_dirt_body_impact"]				      = LoadFX("env/dirt/fx_ks_dirt_body_impact");
	level._effect["fx_ks_huey_glare"]                   = LoadFX("maps/khe_sanh/fx_ks_huey_glare"); 
	level._effect["fx_ks_napalm_drop"]				          = LoadFX("maps/khe_sanh/fx_ks_napalm_drop");	  
	level._effect["fx_ks_tent_dust"]				            = LoadFX("maps/khe_sanh/fx_ks_tent_dust");
	level._effect["fx_ks_airburst_splinters"]				    = LoadFX("maps/khe_sanh/fx_ks_airburst_splinters");
	level._effect["fx_ks_tree_burst"]				            = LoadFX("maps/khe_sanh/fx_ks_tree_burst");	
	level._effect["fx_ks_bunker_ceiling_dest"]				  = LoadFX("maps/khe_sanh/fx_ks_bunker_ceiling_dest");			 		 
	level._effect["fx_ks_napalm_3_burst"]				        = LoadFX("maps/khe_sanh/fx_ks_napalm_3_burst");		 	
	level._effect["fx_ks_b52_exp_bomb"]				          = LoadFX("maps/khe_sanh/fx_ks_b52_exp_bomb");		
	level._effect["fx_ks_b52_pressure_wave"]				    = LoadFX("maps/khe_sanh/fx_ks_b52_pressure_wave");	
	level._effect["fx_ks_b52_pressure_wave_dirt"]				= LoadFX("maps/khe_sanh/fx_ks_b52_pressure_wave_dirt");		
	level._effect["fx_ks_b52_pressure_wave_hill"]				= LoadFX("maps/khe_sanh/fx_ks_b52_pressure_wave_hill");		
	level._effect["fx_ks_jeep_crash_debris"]				    = LoadFX("maps/khe_sanh/fx_ks_jeep_crash_debris");		

	// C130 crash
	level._effect["fx_ks_c130_engine_fire"]				  = LoadFX("vehicle/vfire/fx_ks_c130_engine_fire");
	level._effect["fx_ks_c130_engine_fire2"]			  = LoadFX("vehicle/vfire/fx_ks_c130_engine_fire2");	
	level._effect["fx_ks_c130_crash_fuselage"]			= LoadFX("maps/khe_sanh/fx_ks_c130_crash_fuselage");
	level._effect["fx_ks_c130_crash_wing"]				  = LoadFX("maps/khe_sanh/fx_ks_c130_crash_wing");
	level._effect["fx_ks_c130_wing_fire"]				    = LoadFX("vehicle/vfire/fx_ks_c130_wing_fire");
	level._effect["fx_ks_c130_crash_propeller"]			= LoadFX("maps/khe_sanh/fx_ks_c130_crash_propeller");
	level._effect["fx_ks_c130_dirt_trail"]				  = LoadFX("maps/khe_sanh/fx_ks_c130_dirt_trail");
	level._effect["fx_ks_c130_wing_dirt_trail"]			= LoadFX("maps/khe_sanh/fx_ks_c130_wing_dirt_trail");

	level._effect["fx_ks_jeep_ride_glow"]			= LoadFX("maps/khe_sanh/fx_ks_jeep_ride_glow");
       	    								
	//f4 phantom fx
	level._effect["jet_exhaust"]	            = loadFX( "vehicle/exhaust/fx_exhaust_jet_afterburner" );
	level._effect["jet_contrail"]             = loadfx("trail/fx_geotrail_jet_contrail");				
	
	level._effect["huey_rotor"]					    	= Loadfx("vehicle/props/fx_huey_main_blade_full");
	level._effect["huey_tail_rotor"]				  = Loadfx("vehicle/props/fx_huey_small_blade_full");
	level._effect["heli_dust_default"]				= LoadFX("vehicle/treadfx/fx_heli_dust_khe_sanh");

	//character burn fx
	level._effect["character_fire_pain_sm"]     = LoadFX("env/fire/fx_fire_player_sm_1sec");
	level._effect["character_fire_death_sm"]    = LoadFX("env/fire/fx_fire_player_md");
	level._effect["character_fire_death_torso"] = LoadFX("env/fire/fx_fire_player_torso");

	// E1C mortars
	//level._effectType["e1c_mortar_struct"]		= "mortar";
	//level._effect["e1c_mortar_struct"]	   		= LoadFX("maps/khe_sanh/fx_ks_mortar_md");

	// Trench mortars
	level._effectType["e1c_trench_mortars"]		= "mortar";
	level._effect["e1c_trench_mortars"]	   		= LoadFX("maps/khe_sanh/fx_ks_mortar_md");

	// E2 amb mortars
	level._effectType["e2_mortar_struct"]		= "mortar";
	level._effect["e2_mortar_struct"]	   		= LoadFX("maps/khe_sanh/fx_ks_mortar_md");

	level._effectType["e1c_runway_struct"]		= "mortar";
	level._effect["e1c_runway_struct"]	   		= LoadFX("maps/khe_sanh/fx_ks_mortar_md");
	level._effect["e1c_tv_spot_mortar"]			= LoadFX("maps/khe_sanh/fx_ks_exp_plane_impact");

	// Event 4 barrels
	level._effect["fx_ks_barrel_ignite"]		    = LoadFx("maps/khe_sanh/fx_ks_barrel_ignite");
	level._effect["fx_ks_barrel_ignite_spark"]	= LoadFx("maps/khe_sanh/fx_ks_barrel_ignite_spark");

	//barrel leak
	level._effect["fx_ks_barrel_leak"]		    = LoadFx("maps/khe_sanh/fx_ks_barrel_leak");


	// E4 trans mortars
	level._effectType["e4_trans_mortar"]		= "mortar";
	level._effect["e4_trans_mortar"]	   		= LoadFX("maps/khe_sanh/fx_ks_mortar_md");
	
	//tank fx
	level._effect["fx_tank_damage"]		= LoadFx("maps/khe_sanh/fx_ks_smk_tank_dmg");
	level._effect["fx_tank_dead"]	    = LoadFx("maps/khe_sanh/fx_ks_smk_tank_dmg_final");

	//cobra fx
	level._effect["fx_cobra_fire"]		= LoadFx("vehicle/vfire/fx_ks_cobra_fire");
	level._effect["fx_cobra_explode"]	= LoadFx("vehicle/vexplosion/fx_vexp_ks_helo_ground_impact");	
	
	//coughing
	level._effect["fx_ks_smk_cough"]	= LoadFx("maps/khe_sanh/fx_ks_smk_cough");	

	// Flame thrower pop
	level._effect["fx_exp_flamethrower_tank"]		= LoadFx("explosions/fx_exp_flamethrower_tank");

	//apc bullets
	level._effect["fx_ks_m113_m2_eject"]		= LoadFx("maps/khe_sanh/fx_ks_m113_m2_eject");

	//fake shoot m60 woods
	level._effect["fx_heavy_flash_base"]		= LoadFx("weapon/muzzleflashes/fx_heavy_flash_base");

	//for bloody death utility script:
	level._effect["bloody_death"][0]			= LoadFX("impacts/flesh_hit_body_fatal_lg_exit");
	level._effect["bloody_death"][1]			= LoadFX("impacts/flesh_hit_body_fatal_exit");
	level._effect["bloody_death"][2]			= LoadFX("impacts/flesh_hit_extreme");

	//Bloody Effect Impact
	level._effect["flesh_hit"]							= LoadFX("impacts/fx_flesh_hit_body_fatal_lg_exit_mp");

	//heli impact
	level._effect["fx_ks_aerial_exp_sm"]		= LoadFx("maps/khe_sanh/fx_ks_aerial_exp_sm");

/*
	// Temp napalm/fire
	level._effect["napalm_trap"]				= LoadFX( "maps/khe_sanh/fx_napalm_barrel_trap_01" );
	level._effect["napalm_fire"]				= LoadFX("weapon/napalm/fx_napalm_ground_fire_lg_mp");

	//TEMP - Shabs: 11/30 - delete this later
	level._effect["veh_exp"]					= LoadFX( "temp_effects/fx_tmp_exp_vehicle" );
	level._effect["exp_pack_doorbreach"]	    = LoadFX("explosions/fx_large_vehicle_explosion");
	level._effect["ammo_depot_charge"]			= LoadFX( "explosions/fx_explosion_charge_large" );

	level._effect["napalm_trap"]				= LoadFX( "maps/fx_napalm_barrel_trap_01" );

	//temp effect for smoking cobra
	level._effect["chopper_burning"] 			= LoadFX("vehicle/vfire/fx_vsmoke_huey_trail");

	//NAPALM EFFECT FROM BARRY
	level._effect["napalm_trap"]				= LoadFX( "maps/khe_sanh/fx_napalm_barrel_trap_01" );

	//temp fire for napalm trap
	level._effect["fire_md_fuel"]				= LoadFX( "env/fire/fx_fire_md_fuel" );
	level._effect["fire_lg_fuel"]				= LoadFX( "env/fire/fx_fire_lg_fuel" );
	level._effect["fire_sm_fuel"]				= LoadFX("env/fire/fx_fire_sm_fuel");

	//temp!
	level._effect["veh_black_smoke"] 			= LoadFX( "env/smoke/fx_smk_column_med_blk" );

	//temp fuselage explosion
	level._effect["dust_spill"]					= LoadFX("temp_effects/fx_tmp_dust_spill_oneshot");
	level._effect[ "wing_explosion" ] 			= LoadFX( "explosions/fx_concussion_grenade" );

	//temp smoke screen for trench c
	level._effect["smoke_screen"]				= LoadFX("maps/khe_sanh/fx_ks_nva_smoke_grenade");

	//b52 carpet bomb and aftermath fx
	level._effect["b52_bomb"]					= LoadFX( "weapon/bomb/fx_exp_bomb_b52" );
	level._effect["b52_aftermath"]				= LoadFX("explosions/fx_b52_aftermath");

	//MP Napalm fx 
	level._effect["napalm_drop"] 				= LoadFX("weapon/napalm/fx_napalm_drop_mp");
	level._effect["napalm_trail"]				= LoadFX("weapon/napalm/fx_napalm_trail_em_lg_mp");
	level._effect["napalm_burst"] 				= LoadFX("weapon/napalm/fx_napalm_ground_burst_mp");
	level._effect["napalm_fire"]				= LoadFX("weapon/napalm/fx_napalm_ground_fire_lg_mp");

	level._effect["airstrike_valid"]	 		= LoadFX("misc/fx_ui_airstrike");
	level._effect["airstrike_invalid"]	 		= LoadFX("misc/fx_ui_flagbase_orange");
	level._effect["airstrike_confirmed"]	 	= LoadFX("misc/napalm_strike_confirmed");

	maps\createart\khe_sanh_art::main();
*/
}

footsteps()
{
	animscripts\utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "brick", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "carpet", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "cloth", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "concrete", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "dirt", LoadFx( "bio/player/fx_footstep_sand" ) );
	animscripts\utility::setFootstepEffect( "foliage", LoadFx( "bio/player/fx_footstep_sand" ) );
	animscripts\utility::setFootstepEffect( "gravel", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "grass", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "metal", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "mud", LoadFx( "bio/player/fx_footstep_mud" ) );
	animscripts\utility::setFootstepEffect( "paper", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "plaster", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "rock", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "water", LoadFx( "bio/player/fx_footstep_water" ) );
	animscripts\utility::setFootstepEffect( "wood", LoadFx( "bio/player/fx_footstep_dust" ) );
}

wind_initial_setting()
{
	SetSavedDvar( "wind_global_vector", "-60 148 59" );    // change "0 0 0" to your wind vector
	SetSavedDvar( "wind_global_low_altitude", 0);    // change 0 to your wind's lower bound
	SetSavedDvar( "wind_global_hi_altitude", 5000);    // change 10000 to your wind's upper bound
	SetSavedDvar( "wind_global_low_strength_percent", 0.44);    // change 0.5 to your desired wind strength percentage
}

//fx for hero huey landing at start
event1_hero_huey_dust()
{
	//Exploder(101);
}
//self is F4
f4_add_contrails()
{
	playfxontag(level._effect["jet_contrail"], self, "tag_left_wingtip" );
	playfxontag(level._effect["jet_contrail"], self, "tag_right_wingtip" );
	playfxontag(level._effect["jet_exhaust"], self, "tag_engine_l" );
	playfxontag(level._effect["jet_exhaust"], self, "tag_engine_r" );
}


// FXanim Props
initModelAnims()
{
	
	level.scr_anim["fxanim_props"]["a_tent_open"][0] = %fxanim_khesanh_tent_open_anim;
	level.scr_anim["fxanim_props"]["a_hut_explode"][0] = %fxanim_khesanh_hut_explode_anim;
	level.scr_anim["fxanim_props"]["a_sandbags01"][0] = %fxanim_khesanh_sandbags01_anim;
	level.scr_anim["fxanim_props"]["a_sandbags_apc"][0] = %fxanim_khesanh_sandbags_apc_anim;
	level.scr_anim["fxanim_props"]["a_windsock"] = %fxanim_gp_windsock_anim;
	level.scr_anim["fxanim_props"]["a_tarp_crate_stack"] = %fxanim_gp_tarp_crate_stack_anim;
	level.scr_anim["fxanim_props"]["a_deadbody_tarp_fast"] = %fxanim_khesanh_deadbody_tarp_idle_anim;
	level.scr_anim["fxanim_props"]["a_deadbody_tarp_slow"] = %fxanim_khesanh_deadbody_tarp_idle02_anim;
	level.scr_anim["fxanim_props"]["a_barrel_01"] = %fxanim_khesanh_barrel_01_anim;
	level.scr_anim["fxanim_props"]["a_barrel_02"] = %fxanim_khesanh_barrel_02_anim;
	level.scr_anim["fxanim_props"]["a_barrel_03"] = %fxanim_khesanh_barrel_03_anim;
	level.scr_anim["fxanim_props"]["a_barrel_04"] = %fxanim_khesanh_barrel_04_anim;
	level.scr_anim["fxanim_props"]["a_barrel_05"] = %fxanim_khesanh_barrel_05_anim;			
	level.scr_anim["fxanim_props"]["a_bunker01"] = %fxanim_khesanh_bunker01_anim;			
	level.scr_anim["fxanim_props"]["a_bunker02"] = %fxanim_khesanh_bunker02_anim;
	
	addNotetrack_customFunction("fxanim_props", "barrel_01_hit_01", ::audio_barrel_impact, "a_barrel_01");
	addNotetrack_customFunction("fxanim_props", "barrel_01_hit_02", ::audio_barrel_impact, "a_barrel_01");
	addNotetrack_customFunction("fxanim_props", "barrel_01_hit_03", ::audio_barrel_impact, "a_barrel_01");
	addNotetrack_customFunction("fxanim_props", "barrel_02_hit_01", ::audio_barrel_impact, "a_barrel_02");
	addNotetrack_customFunction("fxanim_props", "barrel_02_hit_02", ::audio_barrel_impact, "a_barrel_02");
	addNotetrack_customFunction("fxanim_props", "barrel_02_hit_03", ::audio_barrel_impact, "a_barrel_02");
	addNotetrack_customFunction("fxanim_props", "barrel_02_hit_04", ::audio_barrel_impact, "a_barrel_02");	
	addNotetrack_customFunction("fxanim_props", "barrel_03_hit_01", ::audio_barrel_impact, "a_barrel_03");
	addNotetrack_customFunction("fxanim_props", "barrel_03_hit_02", ::audio_barrel_impact, "a_barrel_03");
	addNotetrack_customFunction("fxanim_props", "Barrel_03_explode", ::fxanim_set_to_detonate, "a_barrel_03");
	addNotetrack_customFunction("fxanim_props", "barrel_04_hit_01", ::audio_barrel_impact, "a_barrel_04");
	addNotetrack_customFunction("fxanim_props", "barrel_04_hit_02", ::audio_barrel_impact, "a_barrel_04");
	addNotetrack_customFunction("fxanim_props", "Barrel_04_explode", ::fxanim_set_to_detonate, "a_barrel_04");
	addNotetrack_customFunction("fxanim_props", "barrel_05_hit_01", ::audio_barrel_impact, "a_barrel_05");
	addNotetrack_customFunction("fxanim_props", "barrel_05_hit_02", ::audio_barrel_impact, "a_barrel_05");
	
	ent1 = getent( "fxanim_khesanh_tent_open_mod", "targetname" );
	ent2 = getent( "fxanim_khesanh_hut_explode_mod", "targetname" );
	ent3 = getent( "fxanim_khesanh_sandbags01", "targetname" );
	ent4 = getent( "fxanim_khesanh_sandbags02", "targetname" );
	ent5 = getent( "fxanim_khesanh_sandbags_apc_mod", "targetname" );
	ent6 = getent( "fxanim_khesanh_hut_explode_jeep", "targetname" );
	ent7 = getent( "fxanim_khesanh_bunker01", "targetname" );
	ent8 = getent( "fxanim_khesanh_bunker02", "targetname" );

	fx_anim_barrel_woods = GetEnt("kick_the_barrel_woods", "targetname");
	fx_anim_barrels = GetEntArray("kick_the_barrel", "targetname"); 
	//ent7 = getent( "khesanh_barrel_01", "script_string" );
	//ent8 = getent( "khesanh_barrel_02", "script_string" );
	//ent9 = getent( "khesanh_barrel_03", "script_string" );
	//ent10 = getent( "khesanh_barrel_04", "script_string" );
	//ent11 = getent( "khesanh_barrel_05", "script_string" );
	
	enta_windsock = getentarray( "fxanim_gp_windsock_mod", "targetname" );
	enta_tarp_crate_stack = getentarray( "fxanim_gp_tarp_crate_stack_mod", "targetname" );
	enta_deadbody_tarp_fast = getentarray( "fxanim_khesanh_deadbody_tarp_fast", "targetname" );
	enta_deadbody_tarp_slow = getentarray( "fxanim_khesanh_deadbody_tarp_slow", "targetname" );
	
	
	if (IsDefined(ent1)) 
	{
		ent1 thread tent_open();
		println("************* FX: tent_open *************");
	}
	
	if (IsDefined(ent2)) 
	{
		ent2 thread hut_explode();
		println("************* FX: hut_explode *************");
	}
	
	if (IsDefined(ent3)) 
	{
		ent3 thread sandbags01();
		println("************* FX: sandbags01 *************");
	}
	
	if (IsDefined(ent4)) 
	{
		ent4 thread sandbags02();
		println("************* FX: sandbags02 *************");
	}
	
	if (IsDefined(ent5)) 
	{
		ent5 thread sandbags_apc();
		println("************* FX: sandbags_apc *************");
	}
	
	for(i=0; i<enta_windsock.size; i++)
	{
 		enta_windsock[i] thread windsock(1,5);
 		println("************* FX: windsock *************");
	}
	
	for(i=0; i<enta_tarp_crate_stack.size; i++)
	{
 		enta_tarp_crate_stack[i] thread tarp_crate_stack(1,5);
 		println("************* FX: tarp_crate_stack *************");
	}
	
	for(i=0; i<enta_deadbody_tarp_fast.size; i++)
	{
 		enta_deadbody_tarp_fast[i] thread deadbody_tarp_fast(1,5);
 		println("************* FX: deadbody_tarp_fast *************");
	}
	
	for(i=0; i<enta_deadbody_tarp_slow.size; i++)
	{
 		enta_deadbody_tarp_slow[i] thread deadbody_tarp_slow(1,5);
 		println("************* FX: deadbody_tarp_slow *************");
	}
	
	if (IsDefined(ent6)) 
	{
		ent6 thread hut_explode_jeep();
		println("************* FX: hut_explode_jeep *************");
	}

	//barrel 1
	if (IsDefined(fx_anim_barrel_woods)) 
	{
		fx_anim_barrel_woods thread fxanim_barrel_kick();
		println("************* FX: barrel_01 *************");
	}

	//barrels 2, 3, 4, 5
	for(i = 0; i < fx_anim_barrels.size; i++)
	{
		if(IsDefined(fx_anim_barrels[i]))
		{
			fx_anim_barrels[i] thread fxanim_barrel_kick();
		}
	}
/*
	if (IsDefined(ent7)) 
	{
		ent7 thread barrel_01();
		println("************* FX: barrel_01 *************");
	}
	
	if (IsDefined(ent8)) 
	{
		ent8 thread barrel_02();
		println("************* FX: barrel_02 *************");
	}
	
	if (IsDefined(ent9)) 
	{
		ent9 thread barrel_03();
		println("************* FX: barrel_03 *************");
	}		
	
	if (IsDefined(ent10)) 
	{
		ent10 thread barrel_04();
		println("************* FX: barrel_04 *************");
	}	
	
	if (IsDefined(ent11)) 
	{
		ent11 thread barrel_05();
		println("************* FX: barrel_05 *************");
	}		
*/

if (IsDefined(ent7)) 
	{
		ent7 thread bunker01();
		println("************* FX: bunker01 *************");
	}
	
	if (IsDefined(ent8)) 
	{
		ent8 thread bunker02();
		println("************* FX: bunker02 *************");
	}
}


tent_open()
{
	level waittill("tent_open_start");
	self UseAnimTree(#animtree);
	anim_single(self, "a_tent_open", "fxanim_props");
}

hut_explode()
{
	level waittill("hut_explode_start");
	self UseAnimTree(#animtree);
	anim_single(self, "a_hut_explode", "fxanim_props");
	//playsoundatposition ("exp_khe_house_explo", (0,0,0));
}

sandbags01()
{
	level waittill("sandbags01_start");
	self UseAnimTree(#animtree);
	anim_single(self, "a_sandbags01", "fxanim_props");
}

sandbags02()
{
	level waittill("sandbags02_start");
	self UseAnimTree(#animtree);
	anim_single(self, "a_sandbags01", "fxanim_props");
}

sandbags_apc()
{
	level waittill("sandbags_apc_start");
	self UseAnimTree(#animtree);
	anim_single(self, "a_sandbags_apc", "fxanim_props");
}

windsock(delay_min,delay_max)
{
	wait(delay_min);
	wait(randomfloat(delay_max-delay_min));
	self UseAnimTree(#animtree);
	anim_single(self, "a_windsock", "fxanim_props");
}

tarp_crate_stack(delay_min,delay_max)
{
	wait(delay_min);
	wait(randomfloat(delay_max-delay_min));
	self UseAnimTree(#animtree);
	anim_single(self, "a_tarp_crate_stack", "fxanim_props");
}

deadbody_tarp_fast(delay_min,delay_max)
{
	wait(delay_min);
	wait(randomfloat(delay_max-delay_min));
	self UseAnimTree(#animtree);
	anim_single(self, "a_deadbody_tarp_fast", "fxanim_props");
}

deadbody_tarp_slow(delay_min,delay_max)
{
	wait(delay_min);
	wait(randomfloat(delay_max-delay_min));
	self UseAnimTree(#animtree);
	anim_single(self, "a_deadbody_tarp_slow", "fxanim_props");
}

hut_explode_jeep()
{
	level waittill("hut_explode_jeep_start");
	playsoundatposition ("exp_mortar_dirt", self.origin);
	playsoundatposition( "exp_guard_tower_l" , self.origin );
	level thread custom_rumble(0.02, 20);
	self UseAnimTree(#animtree);
	anim_single(self, "a_hut_explode", "fxanim_props");
}

//self is barrel
fxanim_barrel_kick()
{
	/#
//	Debugstar(self.origin, 10000, (0,0,1));
	#/
	level waittill(self.script_string);
	self UseAnimTree(#animtree);
	anim_single(self, "a_barrel_0" +self.script_int, "fxanim_props");
	//self.kicked = "true";
}

fxanim_set_to_detonate(guy)
{
	self.kicked = "true";
}

/*
barrel_01()
{
	level waittill("barrel_01_start");
	self UseAnimTree(#animtree);
	anim_single(self, "a_barrel_01", "fxanim_props");
}

barrel_02()
{
	level waittill("khesanh_barrel_02");
	self UseAnimTree(#animtree);
	anim_single(self, "a_barrel_02", "fxanim_props");
}

barrel_03()
{
	level waittill("khesanh_barrel_03");
	self UseAnimTree(#animtree);
	anim_single(self, "a_barrel_03", "fxanim_props");
}

barrel_04()
{
	level waittill("khesanh_barrel_04");
	self UseAnimTree(#animtree);
	anim_single(self, "a_barrel_04", "fxanim_props");
}

barrel_05()
{
	level waittill("khesanh_barrel_05");
	self UseAnimTree(#animtree);
	anim_single(self, "a_barrel_05", "fxanim_props");
}
*/

bunker01()
{
	level waittill("bunker01_start");
	self UseAnimTree(#animtree);
	anim_single(self, "a_bunker01", "fxanim_props");
}

bunker02()
{
	level waittill("bunker02_start");
	self UseAnimTree(#animtree);
	anim_single(self, "a_bunker02", "fxanim_props");
}

audio_barrel_impact( barrel )
{
    origin = barrel.origin + (15, -200, 0);
    
    playsoundatposition( "evt_barrel_impact", origin );
}
