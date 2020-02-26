//////////////////////////////////////////////////////////
//
// khe_sanh.gsc
//
//////////////////////////////////////////////////////////

#include maps\_utility;
#include common_scripts\utility;
#include maps\khe_sanh_util;
#include maps\_rusher;
#include maps\_vehicle;
#include maps\_objectives;

main()
{

	// Keep this first for CreateFX
	maps\khe_sanh_fx::main();

	// set the global specular scale for this level to off 1-1
 	SetSavedDvar( "r_testScale","1" );
	   
	precache_items();

	//-- Skiptos
	add_skipto( "e1_intro", 				 ::skipto_e1_intro, 				 &"SKIPTO_E1_INTRO", 				  maps\khe_sanh_event1::main );
	add_skipto( "e2_trenchbattle",   ::skipto_e2_trenchbattle,   &"SKIPTO_E2_TRENCHBATTLE",   maps\khe_sanh_event2::main );
	add_skipto( "e3_trenchdefense",  ::skipto_e3_trenchdefense,  &"SKIPTO_E3_TRENCHDEFENSE",  maps\khe_sanh_event3::main );
	add_skipto( "e4_hillbattle", 		 ::skipto_e4_hillbattle, 		 &"SKIPTO_E4_HILLBATTLE",     maps\khe_sanh_event4::main );
	add_skipto( "e4b_uphillbattle",  ::skipto_e4b_uphillbattle,  &"SKIPTO_E4_UPHILLBATTLE",   maps\khe_sanh_event4b::main );
	add_skipto( "e5_siegeofkhesahn", ::skipto_e5_siegeofkhesahn, &"SKIPTO_E5_SIEGEOFKHESAHN", maps\khe_sanh_event5::main );
	
	add_skipto( "dev_e3b_law_battle", ::skipto_e3b_law_battle, 	 &"SKIPTO_E3B_LAW_BATTLE" );
	add_skipto( "dev_e4c_woods_jam", 	::skipto_e4c_woods_jam, 	 &"SKIPTO_E4C_WOODS_JAM"  );
	add_skipto( "dev_e5b_towbattle", 	::skipto_e5b_towbattle, 	 &"SKIPTO_E5B_TOWBATTLE"  );

	default_skipto( "e1_intro" );



	//detail drone
	// These are called everytime a drone is spawned in to set up the character.
	level.drone_spawnFunction["allies"] = character\c_usa_jungmar_assault::main; 
	//level.drone_spawnFunction["axis"] = character\c_vtn_nva1::main;
	
	//cheaper drone
	//level.drone_spawnFunction["axis"] = character\c_vtn_nva1_drone::main;
	level.drone_spawnFunction_passNode = true; //-- makes _drone pass the first struct of the drone path into the spawn function
	level.drone_spawnFunction["axis"] = maps\khe_sanh_util::axis_drone_spawn;
	character\c_vtn_nva1_drone::precache();

	setup_drones();

	//init tow
	maps\_tvguidedmissile::init();
	
	//Testing new objectives system
	setup_objectives();

	// Main Init 
	maps\_load::main();

	// Drones Init
	maps\_drones::init();	

	init_flags();

	// AI rushers
	maps\_rusher::init_rusher();

	// Khe Sahn other inits
	maps\createart\khe_sanh_art::main();
	level thread maps\khe_sanh_amb::main();
	maps\khe_sanh_anim::main();
	
	/#
	setdvar( "debug_character_count", "on" );
	#/

//	level thread debug_ai();

	//handles the updating of objectives
	level thread maps\_objectives::objectives();
}

/***************************************************************/
// Init Flags
/***************************************************************/
init_flags()
{
	//Objective flags start
	//event 1
	flag_init("obj_get_hudson_to_safety");
	flag_init("obj_get_hudson_to_safety_complete");
	
	//event 2
	flag_init("obj_trenches_with_woods");
	flag_init("obj_trenches_with_woods_complete");
	flag_init("all_tanks_spawned");
	
	//event 3
	flag_init("start_e3_thread");
	flag_init("picked_up_law");
	flag_init("obj_cover_woods");
	flag_init("obj_cover_woods_complete");
	flag_init("obj_hold_the_line");
	flag_init("obj_hold_the_line_complete");

	flag_init("obj_defeat_the_tanks");
	flag_init("obj_defeat_the_tanks_complete");
	flag_init("obj_rally_bunker");
	flag_init("obj_rally_bunker_complete");

	//event 4
	flag_init("start_downhill_breadcrumb");
	flag_init("obj_breakthrough");
	flag_init("obj_breakthrough_complete");
	flag_init("obj_rally_at_hill");
	flag_init("obj_rally_at_hill_complete");
	flag_init("obj_retake_the_hill");
	flag_init("obj_retake_the_hill_rally");
	flag_init("obj_retake_the_hill_complete");
	flag_init("hilltop_window_start");

	//Objective flags end

	//event 5
	flag_init("obj_repel_infantry");
	flag_init("obj_repel_infantry_complete");
	flag_init("player_on_jeep");
	flag_init("obj_get_in_jeep");
	flag_init("obj_tow_jeep_phase_2");
	flag_init("phase_2_spawn");
	flag_init("obj_tow_jeep_phase_3");
	flag_init("phase_3_spawn");
	flag_init("obj_tow_jeep_phase_end");
	flag_init("end_scene");

	//sky metal
	flag_init("e1_pause_sky_metal");

	level.e3b_jumpto = false;
	level.e4c_woods_jam = false;
	level.e5_jumpto = false;
	level.e5b_jumpto = false;

	//scriptmover client flag
	//= 0 is used by sound for heli crash in event 3
	level.SCRIPTMOVER_CHARRING = 1;
	level.ACTOR_CHARRING = 2;	

	//level.PITCH_DOWN = 3;
	//level.PITCH_UP = 4;


	//dont let fts drop until event 4b
	level.rw_ft_allowed = false;

	//drones will not ragdoll
	level.no_drone_ragdoll = true;

	//tank values
	level.DEFAULT_TANK_HEALTH = 256;
}

/***************************************************************/
// Precache Items 
/***************************************************************/
precache_items()
{
	PreCacheRumble("damage_heavy");

	//e3 overlay
	//PreCacheShader("e3_slate");

	// Shell Shocks
	PreCacheShellShock( "default" );	
	PreCacheShellShock( "quagmire_window_break" );
	PreCacheShellShock( "tankblast" );
	PreCacheShellShock ("khe_sanh_woods");
	PreCacheShellShock ("explosion");

	// Weapons
	//commented out m16 items are precahced in _loadout.gsc
	//PreCacheItem( "m16_sp" );
	PreCacheItem( "m16_acog_sp" );
	PreCacheItem( "m16_extclip_sp" );
	PreCacheItem( "m16_dualclip_sp" );
	PreCacheItem( "m16_gl_sp" );
	PrecacheItem( "gl_m16_sp" );
	//PreCacheItem( "m16_mk_sp" );
	//PreCacheItem( "mk_m16_sp" );
	PreCacheItem( "m16_acog_mk_sp" );

	PreCacheItem( "m14_sp" );
	PreCacheItem( "m14_acog_sp" );
	PreCacheItem( "m14_extclip_sp" );
	PreCacheItem( "m14_gl_sp" );
	PreCacheItem( "gl_m14_sp" );

	PreCacheItem( "ak47_sp" );
	PreCacheItem( "ak47_acog_sp" );
	PreCacheItem( "ak47_extclip_sp" );
	PreCacheItem( "ak47_dualclip_sp" );
	PreCacheItem( "ak47_gl_sp" );
	PreCacheItem( "gl_ak47_sp" );
	PreCacheItem( "ak47_ft_sp" );
	PreCacheItem( "ft_ak47_sp" );
	PreCacheItem( "ak47_lowpoly_sp" );

	PreCacheItem( "rpk_sp" );
	PreCacheItem( "rpk_acog_sp" );
	PreCacheItem( "rpk_extclip_sp" );
	PreCacheItem( "m60_sp" );
	//PreCacheItem( "m60_acog_sp" );
	PreCacheItem( "m60_extclip_sp" );
	PreCacheItem( "m60_grip_sp" );
	PreCacheItem( "m60_bipod_stand" );
	
	//PreCacheItem( "ithaca_sp" );
	PrecacheItem( "ithaca_grip_sp" );
	PrecacheItem( "python_sp" );

	PreCacheItem( "frag_grenade_sp" );

	PreCacheItem( "china_lake_sp" );
	PreCacheItem( "rpg_player_sp" );
	PrecacheItem( "m220_tow_emplaced_khesanh_sp" );
	PrecacheItem( "m72_law_magic_bullet_sp" );
	
	PreCacheItem( "creek_satchel_charge_sp" );

	PreCacheItem("knife_sp");

	//hueys stuff
	PreCacheModel("t5_veh_helo_huey_usmc");
	PreCacheModel("t5_veh_helo_huey_att_interior");
	PrecacheModel("t5_veh_helo_huey_att_decal_usmc_gunship");
	PrecacheModel("t5_veh_helo_huey_att_decal_usmc_hvyhog");
	PreCacheModel("t5_veh_helo_huey_att_decal_usmc_std");
	PreCacheModel("t5_veh_helo_huey_att_decal_medivac");
	PrecacheModel("t5_veh_helo_huey_att_usmc_m60");
	PreCacheModel("t5_veh_helo_huey_att_rockets_usmc");
	
	//c130
	PreCacheModel("t5_veh_air_c130");
	PreCacheModel("t5_veh_air_c130_damaged_parts");
	
	//ladder
	PrecacheModel("p_rus_ladder_metal_256");

	PrecacheModel("t5_veh_jeep");
	//PrecacheModel("p_glo_barrel_objective");
	PrecacheModel("t5_knife_sog");
	PrecacheModel("t5_weapon_law_world_obj");

	PrecacheModel("anim_jun_bodybag");
	PrecacheModel("fxanim_khesanh_deadbody_tarp_mod");

	//phantom camo
	PreCacheModel("t5_veh_jet_f4_gearup_lowres_marines");

	//apc attachements
	//PrecacheModel("t5_veh_m113");
	PrecacheModel("t5_veh_m113_warchicken_turret_decals");
	PrecacheModel("t5_veh_m113_warchicken_decals");
	PrecacheModel("t5_veh_m113_sandbags");
	PrecacheModel("t5_veh_m113_outcasts_decals");

	// anim props
	PrecacheModel("anim_jun_stretcher");
	PrecacheModel("p_glo_shovel01");
	PrecacheModel("p_jun_khe_sahn_hatch");

	//chinalke world model
	PrecacheModel("t5_weapon_ex41_world");
	PrecacheModel("t5_weapon_M16A1_world");

	//woods detonator
	PrecacheModel("weapon_c4_detonator");

	//planks
	PrecacheModel("p_jun_wood_plank_large01");
	PrecacheModel("p_jun_wood_plank_small01");
	
	//crate
	PrecacheModel("p_glo_crate01");

	//woods bandana
	//PrecacheModel("c_usa_jungmar_barnes_bandana");
	//PrecacheModel("c_usa_jungmar_barnes_ks_nobdana");

	//m60
	PrecacheModel("t5_weapon_m60e3_MG");	

	//fake gib
	PrecacheModel("c_vtn_nva1_body_g_torso");
	PrecacheModel("c_vtn_nva3_head");
	PrecacheModel("c_vtn_nva3_gear");
	PrecacheModel("c_vtn_nva2_body_g_legsoff"); // //c_vtn_nva2_body_g_lowclean

	character\c_usa_jungmar_driver::precache();
	character\c_usa_jungmar_barechest::precache();
	character\c_usa_jungmar_chaplain::precache();
	character\c_usa_jungmar_wounded_torso::precache();
	character\c_usa_jungmar_wounded_knee::precache();
	character\c_usa_jungmar_headblown::precache();
	character\c_vtn_nva1_char::precache();
	character\c_usa_jungmar_bowman_nobackpack::precache();
}

/***************************************************************/
// skipto_e1_intro
/***************************************************************/
skipto_e1_intro()
{
	skipto_setup();
	//level.player = Get_Players()[0];
	start_teleport_players( "player_e1_jumpto" );
}

/***************************************************************/
// skipto_e2_trenchbattle
/***************************************************************/
skipto_e2_trenchbattle()
{
	skipto_setup();

	maps\createart\khe_sanh_art::event2_bunker_vision_settings();
	// teleport squad
	start_teleport_players( "player_e2_jumpto" );
	start_teleport("player_e2_jumpto", "hero_squad");


	//set sun sample to level default. higher at start for helicopters intro
	maps\createart\khe_sanh_art::set_level_sun_default();

	//turn on ambient effects First bunker to first M113
	//Exploder(20);
	//turn on ambient effects First M113 to e3_e4 bunker
	//Exploder(30);
}

/***************************************************************/
// skipto_e3_trenchdefense
/***************************************************************/
skipto_e3_trenchdefense()
{
	skipto_setup();
	maps\createart\khe_sanh_art::event3c_vision_settings();

	// teleport squad
	start_teleport_players( "player_e3_jumpto" );
	start_teleport("player_e3_jumpto", "hero_squad");
	level.event3_jumpto = true;
	
		//drones at APC
	level.drone_trigger_apc = GetEnt("e2_trig_drone_axis_0b", "script_noteworthy");
	level.drone_trigger_apc activate_trigger();
	
	level.e3b_jumpto = false;
	//turn on ambient effects First M113 to e3_e4 bunker
	//Exploder(30);

}

skipto_e3b_law_battle()
{
	skipto_setup();

	// vision settings and sun direction
	maps\createart\khe_sanh_art::event3c_vision_settings();

	start_teleport_players( "player_e3_jumpto" );
	start_teleport("player_e3_jumpto", "hero_squad");

	level.event3_jumpto = true;

	//drones at APC
	level.drone_trigger_apc = GetEnt("e2_trig_drone_axis_0b", "script_noteworthy");
	level.drone_trigger_apc activate_trigger();


	level.e3b_jumpto = true;

	//turn on ambient effects First M113 to e3_e4 bunker
	//Exploder(30);

	// call the main for e3
	maps\khe_sanh_event3::main();
}

/***************************************************************/
// skipto_e4_hillbattle
/***************************************************************/
skipto_e4_hillbattle()
{
	skipto_setup();
	maps\createart\khe_sanh_art::event4_vision_settings();

	// teleport squad
	start_teleport_players( "player_e4_jumpto" );	 
	start_teleport("player_e4_jumpto", "hero_squad");
	
	
	level.e4c_woods_jam = false;
	
		//turn on ambient effects Downhill areas
	//Exploder(40);
}

/***************************************************************/
// jumpto_e4b_uphillbattle
/***************************************************************/
skipto_e4b_uphillbattle()
{
	skipto_setup();
	maps\createart\khe_sanh_art::event4b_vision_settings();

	// teleport squad
	start_teleport_players( "player_e4b_jumpto" );
	start_teleport("player_e4b_jumpto", "hero_squad");
	
		//activate drone trigs
	level.drone_e4_hill_trans = GetEnt("e4_trig_drone_hill_trans", "script_noteworthy");
	level.drone_e4_hill_trans activate_trigger();

	level.e4c_woods_jam = false;
		
		//turn on ambient effects Uphill areas to entrance of destroyed bunker
	//Exploder(41);
		//turn on ambient effects Tunnel entrance to destroyed bunker to tunnel exit
	//Exploder(42);
}

skipto_e4c_woods_jam()
{
	skipto_setup();

	flag_set("obj_rally_at_hill_complete");
	flag_set("obj_retake_the_hill");
	flag_set("obj_retake_the_hill_rally");

	// vision settings and sun direction
	maps\createart\khe_sanh_art::event4b_vision_settings();

	start_teleport_players( "player_e4c_jumpto" );
	start_teleport("player_e4b_jumpto", "hero_squad");

	//activate drone trigs
	level.drone_e4_hill_trans = GetEnt("e4_trig_drone_hill_trans", "script_noteworthy");
	level.drone_e4_hill_trans activate_trigger();

	level.e4c_woods_jam = true;

	//turn on ambient effects Uphill areas to entrance of destroyed bunker
	//Exploder(41);
	//turn on ambient effects Tunnel entrance to destroyed bunker to tunnel exit
	//Exploder(42);

	// call the main for e4
	maps\khe_sanh_event4b::main();

}

/***************************************************************/
// skipto_e5_airfieldbattle
/***************************************************************/
skipto_e5_siegeofkhesahn()
{
	skipto_setup();
	maps\createart\khe_sanh_art::event5_vision_settings();
	
	start_teleport_players( "player_e5_jumpto" );
	start_teleport("player_e5_jumpto", "hero_squad");
	
	level.e5_jumpto = true;
	
		//turn on ambient effects Tunnel entrance to destroyed bunker to tunnel exit
	//Exploder(42);

}

skipto_e5b_towbattle()
{
	skipto_setup();

	maps\createart\khe_sanh_art::event5_vision_settings();

	// teleport squad
	start_teleport_players( "player_e5_jumpto" );
	start_teleport("player_e5_jumpto", "hero_squad");

	level.e5b_jumpto = true;

	//Exploder(42);

	// call the main for e5
	maps\khe_sanh_event5::main();
}

skipto_setup()
{
	wait_for_first_player();
	//level.player = Get_Players()[0];
	create_hero_squad();
	create_level_threat_groups();
	level thread khe_sanh_objectives();
	
	if (level.skipto_point == "e1_intro")
		return;
	//>----------------------------------------------------------------------------------------------------
		
	flag_set("obj_get_hudson_to_safety");
	flag_set("obj_get_hudson_to_safety_complete");
	//level.player  SetClientDvar( "r_lightTweakSunDirection", (-28, 205.317, 0)); 
	chinooks = GetEntArray("e2_jumpto_delete_chinooks", "script_noteworthy");
	if(chinooks.size > 0)
	{
		array_delete(chinooks);
	}
	maps\createart\khe_sanh_art::set_level_sun_default(); //set sun sample to level default. higher at start for helicopters intro
	
	if (level.skipto_point == "e2_trenchbattle")
		return;
	//>----------------------------------------------------------------------------------------------------
		
	flag_set("obj_trenches_with_woods");
	flag_set("obj_trenches_with_woods_complete");
	flag_set("start_e3_thread");
	maps\khe_sanh_event2::event1_cleanup();
	battlechatter_on("allies");
	battlechatter_on("axis");	
	
	if (level.skipto_point == "e3_trenchdefense" || level.skipto_point == "dev_e3b_law_battle" )
		return;
	//>----------------------------------------------------------------------------------------------------
	
	
	flag_set("obj_cover_woods");
	flag_set("obj_cover_woods_complete");
	flag_set("obj_hold_the_line");
	flag_set("obj_hold_the_line_complete");
	flag_set("obj_defeat_the_tanks");
	flag_set("all_tanks_spawned");
	flag_set("obj_defeat_the_tanks_complete");
	flag_set("obj_rally_bunker");
	flag_set("obj_rally_bunker_complete");

	//cleans up all spawners and triggers
	maps\khe_sanh_event3::event2_cleanup();
	//cleans up all spawners and triggers
	maps\khe_sanh_event3::event3_cleanup();

	if (level.skipto_point == "e4_hillbattle")
		return;
	//>----------------------------------------------------------------------------------------------------
	
	
	flag_set("obj_breakthrough");
	flag_set("start_downhill_breadcrumb");
	flag_set("trig_e4_breadcrumb");
	flag_set("obj_breakthrough_complete");
	flag_set("obj_rally_at_hill");

	if (level.skipto_point == "e4b_uphillbattle" || level.skipto_point == "dev_e4c_woods_jam")
		return;
	//>----------------------------------------------------------------------------------------------------
	
	
	
	flag_set("obj_rally_at_hill_complete");
	flag_set("obj_retake_the_hill");
	flag_set("obj_retake_the_hill_rally");
	flag_set("hilltop_window_start");
	flag_set("obj_retake_the_hill_complete");
	
	maps\khe_sanh_event5::event4_cleanup();

	if (level.skipto_point == "e5_siegeofkhesahn" || level.skipto_point == "dev_e5b_towbattle")
			return;
	//>----------------------------------------------------------------------------------------------------
	
}
	
	
create_hero_squad()
{
	if(!IsDefined(level.squad))
	{
		level.squad = [];
		// Woods setup
		level.squad["woods"] = simple_spawn_single("woods");
		level.squad["woods"].name = "Woods";
		level.squad["woods"].animname = "woods";
//		level.squad["woods"].ignoreall = true;
		level.squad["woods"].ignoresuppression = true;
		level.squad["woods"] make_hero();
		level.squad["woods"] disable_pain();

		// Hudson setup
		level.squad["hudson"] = simple_spawn_single("hudson");
		level.squad["hudson"].name = "Hudson";
		level.squad["hudson"].animname = "hudson";
//		level.squad["hudson"].ignoreall = true;
		level.squad["hudson"].ignoresuppression = true;
		level.squad["hudson"] make_hero();
		level.squad["hudson"] disable_pain();
	}
}

setup_drones()
{
	level.max_drones = [];
	level.max_drones["axis"] = 100; 
	level.max_drones["allies"] = 100;
}

create_level_threat_groups()
{
	CreateThreatBiasGroup("player");

	//event 2
	CreateThreatBiasGroup( "shoot_player" );
	CreateThreatBiasGroup( "shoot_redshirt" );
	CreateThreatBiasGroup("ally_squad");

	//event 4
	CreateThreatBiasGroup( "e4_anti_player" );
	CreateThreatBiasGroup( "e4_anti_allies" );
	CreateThreatBiasGroup("e4_player_allies");

	//event 4b
	CreateThreatBiasGroup( "anti_player" );
	CreateThreatBiasGroup( "anti_allies" );
	CreateThreatBiasGroup("player_allies");

	//event 5
	CreateThreatBiasGroup( "e5_anti_player" );
	CreateThreatBiasGroup( "e5_anti_allies" );
	CreateThreatBiasGroup( "e5_player_allies" );

}

/////////////////////////////////////
//Testing new objectives system
/////////////////////////////////////
setup_objectives()
{
	level.a_objectives = [];
	level.n_obj_index = 0;
	
	level.OBJ_HUDSON_SAFETY				= register_objective( &"KHE_SANH_OBJ_HUDSON_SAFETY" );
	level.OBJ_DEFEND_KHE						= register_objective( &"KHE_SANH_OBJ_DEFEND_KHE" );
	level.OBJ_WOODS_CLEAR_TRENCH	= register_objective( &"KHE_SANH_OBJ_WOODS_CLEAR_TRENCH" );
	level.OBJ_FOUGASSE_TRAPS				= register_objective( &"" );
	level.OBJ_HOLD_THE_LINE					= register_objective( &"KHE_SANH_OBJ_HOLD_THE_LINE" );
	level.OBJ_DEFEAT_T55						= register_objective( &"KHE_SANH_OBJ_DEFEAT_T55" );
	level.OBJ_PICKUP_LAW						= register_objective( &"" );
	level.OBJ_FOLLOW_WOODS				= register_objective( &"" );
	level.OBJ_BREAKTHROUGH					= register_objective( &"KHE_SANH_OBJ_BREAKTHROUGH" );
	level.OBJ_RETAKE_HILL						= register_objective( &"KHE_SANH_OBJ_RETAKE_HILL" );
	level.OBJ_SAVE_WOODS					= register_objective( &"KHE_SANH_OBJ_SAVE_WOODS" );
	level.OBJ_GET_JEEP							= register_objective( &"KHE_SANH_OBJ_GET_JEEP" );
	level.OBJ_REPEL_ASSAULT					= register_objective( &"KHE_SANH_OBJ_REPEL_ASSAULT" );
}

khe_sanh_objectives( )
{
	wait_for_first_player();

	DEFAULT_OBJ_DIST = 256;

	switch (level.skipto_point)
	{
		case "e1_intro":
		{
			flag_wait("obj_get_hudson_to_safety");
			
			set_objective( level.OBJ_HUDSON_SAFETY, level.squad["woods"], "follow" );
			
			flag_wait("obj_get_hudson_to_safety_complete");
			
			set_objective( level.OBJ_HUDSON_SAFETY, undefined, "done" );
			set_objective( level.OBJ_HUDSON_SAFETY, undefined, "delete" );
		}
		
		case "e2_trenchbattle":
		{
			flag_wait("obj_trenches_with_woods");
		
			set_objective( level.OBJ_DEFEND_KHE );
			
			set_objective( level.OBJ_WOODS_CLEAR_TRENCH, level.squad["woods"], "follow" );
		
			flag_wait_any("obj_trenches_with_woods_complete", "player_went_ahead");	
		}
		
		case "e3_trenchdefense":
		{
			flag_wait("obj_cover_woods");
			
			set_objective( level.OBJ_WOODS_CLEAR_TRENCH, undefined, "done" );
			set_objective( level.OBJ_WOODS_CLEAR_TRENCH, undefined, "delete" );
		
			flag_wait("obj_cover_woods_complete");
			
			//Optional Fougasse objs
			level.obj_fougasse_one = getstruct("struct_obj_fougasse", "targetname");
			level.obj_fougasse_two = getstruct("struct_obj_fougasse_two", "targetname");	
			
			level.player SetClientDvar("cg_objectiveIndicatorNearDist", 32);
			
			set_objective( level.OBJ_FOUGASSE_TRAPS, level.obj_fougasse_one, "", -1 );
			set_objective( level.OBJ_FOUGASSE_TRAPS, level.obj_fougasse_two, "", -1 );
		
			//FOLLOW WOODS TO CHINA
			flag_wait("obj_hold_the_line");
			
			set_objective( level.OBJ_HOLD_THE_LINE, level.squad["woods"], "follow" );
		
			flag_wait("obj_hold_the_line_complete");
			//turn off fougasse markers regardless 	//set 3d view back
			//fougasse optional done
			
			set_objective( level.OBJ_FOUGASSE_TRAPS, undefined, "done" );
			set_objective( level.OBJ_FOUGASSE_TRAPS, undefined, "delete" );
		
			//TANK OBJECTIVE
			flag_wait("obj_defeat_the_tanks");
			
			set_objective( level.OBJ_HOLD_THE_LINE, undefined, "done" );
			set_objective( level.OBJ_HOLD_THE_LINE, undefined, "delete" );
		
			obj_law_struct = getstruct("struct_law_ammo", "targetname");
			obj_law_struct_b = getstruct("struct_law_ammo_b", "targetname");
			obj_law_struct_c = getstruct("struct_law_ammo_c", "targetname");
			tank = 0;
			
			set_objective( level.OBJ_PICKUP_LAW, obj_law_struct, "use", -1 );
			set_objective( level.OBJ_PICKUP_LAW, obj_law_struct_b, "use", -1 );
			set_objective( level.OBJ_PICKUP_LAW, obj_law_struct_c, "use", -1 );
			
			set_objective( level.OBJ_DEFEAT_T55, undefined, undefined, tank );
			
			flag_wait("all_tanks_spawned");
		
			if(IsDefined(level.e3_t55_tank))
			{
				//create objective markers on tanks
				
				event3_show_tank_poi();
						
				level thread cleanup_law_obj(obj_law_struct, obj_law_struct_b, obj_law_struct_c);
				
				while(1)
				{
					if(flag("obj_defeat_the_tanks_complete"))
					{
						break;
					}
					
					//added size check for jump to
					if( level.e3_t55_tank.size > 0 )
					{
						waittill_any_ents( level.e3_t55_tank[0], "death", level.e3_t55_tank[1], "death", level.e3_t55_tank[2], "death");
		
						for( i = 0; i < level.e3_t55_tank.size; i++ )
						{
							if( !IsAlive( level.e3_t55_tank[i] ) && !IsDefined( level.e3_t55_tank[i].imdead ) )
							{
								//have to increment because obj index is offset by one from tank index
								//have to decrement obj number because we added two concurrent objectives so we can show 2 3d text
								level.e3_t55_tank[i].imdead = true;
								
								tank++;
								set_objective( level.OBJ_DEFEAT_T55, undefined, undefined, tank );
								set_objective( level.OBJ_DEFEAT_T55, level.e3_t55_tank[i].obj_loc, "remove" );
							}
						}
					}
					
					wait 0.05;
				}
			}
		
			flag_wait("obj_defeat_the_tanks_complete");
			level.player SetClientDvar("cg_objectiveIndicatorNearDist", DEFAULT_OBJ_DIST);
			
			set_objective( level.OBJ_DEFEAT_T55, undefined, "done" );
			set_objective( level.OBJ_DEFEAT_T55, undefined, "delete" );
		}
		
		case "e4_hillbattle":
		{	
			//RALLY TO BUNKER TO START 4
			flag_wait("obj_rally_bunker");
			
			set_objective( level.OBJ_FOLLOW_WOODS, level.squad["woods"], "follow" );
		
			flag_wait("obj_rally_bunker_complete");
			
			//START OF FOUR
			// CLEAR WEAPONS BUNKER
			flag_wait("obj_breakthrough");
			
			//set_objective( level.OBJ_FOLLOW_WOODS, undefined, "done" );
			//set_objective( level.OBJ_FOLLOW_WOODS, undefined, "delete" );
			
			set_objective( level.OBJ_FOLLOW_WOODS, level.squad["woods"], "remove" );
		
			set_objective( level.OBJ_BREAKTHROUGH, level.squad["woods"], "follow" );
		
			flag_wait("start_downhill_breadcrumb");
			
			down_hill = getstruct("e4_downhill_crumb", "targetname");
			hill_trans = getstruct("e4_transition_crumb", "targetname");
			
			set_objective( level.OBJ_BREAKTHROUGH, level.squad["woods"], "remove" );
			set_objective( level.OBJ_BREAKTHROUGH, down_hill, "breadcrumb" );
		
			flag_wait("trig_e4_breadcrumb");
			
			remove_drone_struct(down_hill);
				
			set_objective( level.OBJ_BREAKTHROUGH, down_hill, "remove" );
			set_objective( level.OBJ_BREAKTHROUGH, hill_trans, "breadcrumb" );
			
			flag_wait("obj_breakthrough_complete");
				
			set_objective( level.OBJ_BREAKTHROUGH, hill_trans, "remove" );
			set_objective( level.OBJ_BREAKTHROUGH, undefined, "done" );
		
			// RALLY WITH WOODS
			flag_wait("obj_rally_at_hill");
		}

		case "e4b_uphillbattle":
		{
			set_objective( level.OBJ_RETAKE_HILL, level.squad["woods"], "follow" );
			flag_wait("obj_rally_at_hill_complete");
			
			
			flag_wait("obj_retake_the_hill");
			
			obj_flank_struct = getstruct("struct_flank_uphill", "targetname");
			obj_hill_struct = getstruct("struct_retake_hill", "targetname");
				
			set_objective( level.OBJ_RETAKE_HILL, level.squad["woods"], "remove" );
			set_objective( level.OBJ_RETAKE_HILL, obj_flank_struct, "breadcrumb" );
		
			flag_wait("obj_retake_the_hill_rally");
				
			set_objective( level.OBJ_RETAKE_HILL, obj_flank_struct, "remove" );
			set_objective( level.OBJ_RETAKE_HILL, obj_hill_struct, "breadcrumb" );
		
			if(!level.e5_jumpto && !level.e5b_jumpto)
			{
				trigger_wait("trig_woods_jam");
			}
		
			set_objective( level.OBJ_RETAKE_HILL, obj_hill_struct, "remove" );
			
			flag_wait("hilltop_window_start");
		
			set_objective( level.OBJ_SAVE_WOODS );
		
			flag_wait("obj_retake_the_hill_complete");
				
			set_objective( level.OBJ_SAVE_WOODS, undefined, "done" );
			set_objective( level.OBJ_SAVE_WOODS, undefined, "delete" );
		
			//reneanble follow on woods from &"KHE_SANH_OBJ_RETAKE_HILL"
				
			set_objective( level.OBJ_FOLLOW_WOODS, level.squad["woods"], "follow" );
		}
		
		case "e5_siegeofkhesahn":
		{
			flag_wait("obj_repel_infantry");
			
			flag_wait("obj_repel_infantry_complete");
			
			set_objective( level.OBJ_RETAKE_HILL, undefined, "done" );
			set_objective( level.OBJ_RETAKE_HILL, undefined, "delete" );
			
			set_objective( level.OBJ_FOLLOW_WOODS, level.squad["woods"], "remove" );
		
			//reset view of 3d obj
			level.player SetClientDvar("cg_objectiveIndicatorNearDist", DEFAULT_OBJ_DIST);
			
			//set_objective( level.OBJ_GET_JEEP, level.jeep_tow, "enter" );
			set_objective( level.OBJ_GET_JEEP, ( level.jeep_tow GetTagOrigin( "tag_passenger2" ) + ( 0, 0, 25 ) ), "enter" );
		
			flag_wait("player_on_jeep");
			
			set_objective( level.OBJ_GET_JEEP, undefined, "done" );
			set_objective( level.OBJ_GET_JEEP, undefined, "delete" );
			
			flag_wait("obj_get_in_jeep");
		
			last_tank = 0;
			
			set_objective( level.OBJ_REPEL_ASSAULT, undefined, undefined, last_tank );
		
			if(IsDefined(level.e5_jeep_tanks))
			{
				flag_wait("use_the_tow");
				//create objective markers on tanks
				
				set_objective( level.OBJ_REPEL_ASSAULT, level.e5_jeep_tanks[0], "destroy", -1 );
		
				while(1)
				{
					if(flag("obj_tow_jeep_phase_2"))
					{
						break;
					}			
					
					//added size check for jump to
					if(level.e5_jeep_tanks.size > 0)
					{
						waittill_any_ents( level.e5_jeep_tanks[0], "death");//, level.e5_jeep_tanks[1], "death");
		
						for(i = 0; i < level.e5_jeep_tanks.size; i++)
						{
							if(!IsAlive(level.e5_jeep_tanks[i]) && !IsDefined(level.e5_jeep_tanks[i].imdead))
							{
								//have to increment because obj index is offset by one from tank index
								//have to decrement obj number because we added two concurrent objectives so we can show 2 3d text
								level.e5_jeep_tanks[i].imdead = true;
								last_tank++;
								
								set_objective( level.OBJ_REPEL_ASSAULT, undefined, undefined, last_tank );
								set_objective( level.OBJ_REPEL_ASSAULT, level.e5_jeep_tanks[i], "remove" );
							}
						}
					}
		
					wait 0.05;
				}
		
				flag_wait("phase_2_spawn");
				
				//wait until player is on tow to enable
				flag_wait("use_the_tow");
				//create objective markers on tanks
				
				set_objective( level.OBJ_REPEL_ASSAULT, level.e5_jeep_tanks[1], "destroy", -1 );
				set_objective( level.OBJ_REPEL_ASSAULT, level.e5_jeep_tanks[2], "destroy", -1  );
				
				while(1)
				{
					if(flag("obj_tow_jeep_phase_3"))
					{
						break;
					}					
					
					waittill_any_ents( level.e5_jeep_tanks[1], "death", level.e5_jeep_tanks[2], "death");//, level.e5_jeep_tanks[4], "death");
		
					for(i = 1; i < level.e5_jeep_tanks.size; i++)
					{
						if(!IsAlive(level.e5_jeep_tanks[i]) && !IsDefined(level.e5_jeep_tanks[i].imdead))
						{
							//have to increment because obj index is offset by one from tank index
							//have to decrement obj number because we added two concurrent objectives so we can show 2 3d text
							level.e5_jeep_tanks[i].imdead = true;
							last_tank++;
							
							set_objective( level.OBJ_REPEL_ASSAULT, undefined, undefined, last_tank );
							set_objective( level.OBJ_REPEL_ASSAULT, level.e5_jeep_tanks[i], "remove" );
						}
					}
		
					wait 0.05;
				}
		
				//new objective because additional pos caps at 8
				flag_wait("phase_3_spawn");
		
				//wait until player is on tow to enable
				flag_wait("use_the_tow");
				
				set_objective( level.OBJ_REPEL_ASSAULT, level.e5_jeep_tanks[3], "destroy", -1  );
				set_objective( level.OBJ_REPEL_ASSAULT, level.e5_jeep_tanks[4], "destroy", -1  );
				set_objective( level.OBJ_REPEL_ASSAULT, level.e5_jeep_tanks[5], "destroy", -1  );
		
				while(!flag("obj_tow_jeep_phase_end"))
				{
					waittill_any_ents( level.e5_jeep_tanks[3], "death", level.e5_jeep_tanks[4], "death", level.e5_jeep_tanks[5], "death");//,level.e5_jeep_tanks[8], "death");
		
					for(i = 3; i < level.e5_jeep_tanks.size; i++)
					{
						if(!IsAlive(level.e5_jeep_tanks[i]) && !IsDefined(level.e5_jeep_tanks[i].imdead))
						{
							//have to decrement because obj index is offset by 2 from tank index
							level.e5_jeep_tanks[i].imdead = true;
							last_tank++;
							
							set_objective( level.OBJ_REPEL_ASSAULT, undefined, undefined, last_tank );
							set_objective( level.OBJ_REPEL_ASSAULT, level.e5_jeep_tanks[i], "remove" );
						}
					}
		
					wait 0.05;
				}
			}
		
			flag_wait("obj_tow_jeep_phase_end");
			
			set_objective( level.OBJ_REPEL_ASSAULT, undefined, "done" );
			set_objective( level.OBJ_REPEL_ASSAULT, undefined, "delete" );
		
			flag_wait("end_scene");
		
			set_objective( level.OBJ_DEFEND_KHE, undefined, "done" );
		}
	}
}