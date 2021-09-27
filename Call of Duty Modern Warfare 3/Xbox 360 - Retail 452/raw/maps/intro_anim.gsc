#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;

main()
{
  player_animations();
  npc_animations();
  drone_deaths();
  drone_anim();
  drone_doors();
  script_models();
  animated_props();
  vehicles();
  destructibles();
  door_setup();
  
  level.gunless_anims = 
	[ "bunker_toss_idle_guy1" ,
	 "prague_woundwalk_wounded",
	 "prague_civ_door_peek",
	 "prague_civ_door_runin",
	 "prague_resistance_hit_idle",
	 "DC_Burning_bunker_stumble",
	 "dc_burning_bunker_stumble",
	 "civilian_crawl_1",
	 "civilian_crawl_2",
	 "dying_crawl",
	 "DC_Burning_artillery_reaction_v1_idle",
	 "DC_Burning_artillery_reaction_v2_idle",
	 "DC_Burning_artillery_reaction_v3_idle",
	 "DC_Burning_artillery_reaction_v4_idle",
	 "DC_Burning_bunker_sit_idle",
	 "civilain_crouch_hide_idle",
	 "civilain_crouch_hide_idle_loop",
	 "DC_Burning_stop_bleeding_wounded_endidle",
	 "DC_Burning_stop_bleeding_medic_endidle",
	 "DC_Burning_stop_bleeding_wounded_idle",
	 "prague_woundwalk_wounded_idle",
	 "prague_bully_civ_survive_idle",
	 "training_basketball_rest",
	 "prague_mourner_man_idle",
	 "training_locals_kneel",
	 "doorpeek_deathA",
	 "pistol_death_3",
	 "drone_stand_death",
	 "death_run_onfront",
	 "ny_manhattan_wounded_drag_wounded" ];
}

#using_animtree( "player" );
player_animations()
{
	level.scr_animtree[ "player_rig" ] 												= #animtree;
	level.scr_model[ "player_rig" ] 												= "viewhands_player_yuri";
	
	level.scr_animtree[ "player_legs" ]												= #animtree;
	level.scr_model[ "player_legs" ]												= "viewlegs_generic";
	
	//----ESCORT----//
	level.scr_anim[ "player_rig" ]["intro_opening_shot01"] 							= %intro_opening_shot01_player;
	level.scr_anim[ "player_rig" ]["intro_opening_shot02"] 							= %intro_opening_shot02_player;
	level.scr_anim[ "player_rig" ]["intro_opening_shot03"] 							= %intro_opening_shot03_player;
	level.scr_anim[ "player_rig" ]["intro_opening_shot04"] 							= %intro_opening_shot04_player;
	level.scr_anim[ "player_rig" ]["intro_opening_shot05"] 							= %intro_opening_shot05_player;
	level.scr_anim[ "player_rig" ]["intro_opening_shot06"] 							= %intro_opening_shot06_player;
	level.scr_anim[ "player_rig" ]["intro_opening_shot07"] 							= %intro_opening_shot07_player;
	level.scr_anim[ "player_rig" ]["intro_opening_shot08"] 							= %intro_opening_shot08_player;
	addnotetrack_customfunction( "player_rig", "fade_black", maps\intro_code::intro_fade_out_to_white, "intro_opening_shot01" );
	addnotetrack_customfunction( "player_rig", "slowmo_start", ::start_intro_shot1_slowmo, "intro_opening_shot01" );
	addnotetrack_customfunction( "player_rig", "slowmo_end", ::end_intro_shot1_slowmo, "intro_opening_shot01" );
	addnotetrack_customfunction( "player_rig", "fade_black", maps\intro_code::intro_fade_out_to_white, "intro_opening_shot02" );
	addnotetrack_customfunction( "player_rig", "fade_black", maps\intro_code::intro_fade_out_to_white, "intro_opening_shot03" );
	addnotetrack_customfunction( "player_rig", "fade_black", maps\intro_code::intro_fade_out_to_white, "intro_opening_shot04" );
	addnotetrack_customfunction( "player_rig", "fade_black", maps\intro_code::intro_fade_out_to_black_slow, "intro_opening_shot05" );
	//addnotetrack_customfunction( "player_rig", "fade_black", maps\intro_code::intro_fade_out_to_white, "intro_opening_shot05" );
	
	
	
	addnotetrack_customfunction( "player_rig", "fade_white", maps\intro_code::intro_flash_to_white_crash, "intro_opening_shot07" );
	addnotetrack_customfunction( "player_rig", "slowmo_start", ::start_intro_shot7_slowmo, "intro_opening_shot07" );
	addnotetrack_customfunction( "player_rig", "start_heli_dust", ::start_heli_dust, "intro_opening_shot07" );
	addnotetrack_customfunction( "player_rig", "slowmo_end", ::end_intro_shot8_slowmo, "intro_opening_shot08" );
	addnotetrack_customfunction( "player_rig", "chopper_crash", maps\intro_code::intro_room_heli_crash_as_yuri, "intro_opening_shot07" );

	level.scr_anim[ "player_rig" ][ "escort_help_soap" ]							= %intro_docdown_needle_player;
	level.scr_anim[ "player_rig" ][ "escort_help_soap_breach" ]						= %intro_docdown_breach_player;	

	//----SLIDE----//
	level.scr_anim[ "player_rig" ][ "roof_collapse_slide" ]							= %intro_rooftop_collapse_player;
	level.scr_anim[ "player_rig" ][ "river_ride" ]									= %intro_river_ride_player;
	level.scr_anim[ "player_legs" ][ "roof_collapse_slide" ]						= %intro_rooftop_collapse_player_legs;
	level.scr_anim[ "player_rig" ][ "roof_collapse_slide_loop" ]					= %intro_rooftop_collapse_loop_player;
	level.scr_anim[ "player_legs" ][ "roof_collapse_slide_loop" ]					= %intro_rooftop_collapse_loop_player_legs;
	addnotetrack_customfunction( "player_rig", "slomo_start", ::start_slowmo, "roof_collapse_slide" );
	addnotetrack_customfunction( "player_rig", "slowmo_end", ::end_slowmo, "roof_collapse_slide" );
	addnotetrack_customfunction( "player_legs", "boot_scrape_dust", maps\intro_fx::slide_player_dust, "roof_collapse_slide" );
	//addnotetrack_customfunction( "player_rig", "slomo_building_start", ::start_building_slowmo, "roof_collapse_slide" );
	//addnotetrack_customfunction( "player_rig", "slomo_building_end", ::end_building_slowmo, "roof_collapse_slide" );
	addnotetrack_customfunction( "player_rig", "water_impact", maps\intro_fx::water_impact, "roof_collapse_slide" );
	addnotetrack_customfunction( "player_rig", "slowmo_end", maps\intro_fx::slide_player_dust_hands, "roof_collapse_slide" );
	
	
	//river ride
	addnotetrack_customfunction( "player_rig", "water_emerge_1", maps\intro_fx::water_emerge, "river_ride" );
	addnotetrack_customfunction( "player_rig", "water_submerge_1", maps\intro_fx::water_submerge, "river_ride" );
	addnotetrack_customfunction( "player_rig", "stop_bubbles", maps\intro_fx::stop_bubbles, "river_ride" );
	addnotetrack_customfunction( "player_rig", "water_emerge_2", maps\intro_fx::water_emerge2, "river_ride" );
	addnotetrack_customfunction( "player_rig", "exit_river_water", maps\intro_fx::exit_river_water, "river_ride" );
	addnotetrack_customfunction( "player_rig", "hand_surface_splash", maps\intro_fx::hand_surface_splash, "river_ride" );
	addnotetrack_customfunction( "player_rig", "dialog_1", maps\intro_vo::river_ride_dialog1, "river_ride" );
	addnotetrack_customfunction( "player_rig", "dialog_2", maps\intro_vo::river_ride_dialog2, "river_ride" );
	addnotetrack_customfunction( "player_rig", "dialog_3", maps\intro_vo::river_ride_dialog3, "river_ride" );
	addnotetrack_customfunction( "player_rig", "dialog_4", maps\intro_vo::river_ride_dialog4, "river_ride" );
	addnotetrack_customfunction( "player_rig", "dialog_5", maps\intro_vo::river_ride_dialog5, "river_ride" );
	
}

#using_animtree( "script_model" );
script_models()
{
	//---- INTRO SEQUENCE ----//
	level.scr_animtree[ "wire1" ]													= #animtree;
	level.scr_model[ "wire1" ]														= "intro_props_wires_01";
	level.scr_anim[ "wire1" ][ "intro_shot01_wires" ]								= %intro_shot01_wires;
	
	level.scr_animtree[ "wire2" ]													= #animtree;
	level.scr_model[ "wire2" ]														= "intro_props_wires_02";
	level.scr_anim[ "wire2" ][ "intro_shot01_wires" ]								= %intro_shot01_wires;
	
	level.scr_animtree[ "wire3" ]													= #animtree;
	level.scr_model[ "wire3" ]														= "intro_props_wires_03";
	level.scr_anim[ "wire3" ][ "intro_shot01_wires" ]								= %intro_shot01_wires;
	
	
	level.scr_animtree[ "gurney" ]													= #animtree;
	level.scr_anim[ "gurney" ][ "intro_opening_shot01" ]							= %intro_opening_shot01_gurney;
	level.scr_anim[ "gurney" ][ "intro_opening_shot07" ]							= %intro_opening_shot07_gurney;
	level.scr_anim[ "gurney" ][ "intro_opening_shot08" ]							= %intro_opening_shot08_gurney;
	level.scr_anim[ "gurney" ][ "intro_work_on_soap" ][0]							= %intro_docdown_gurney;
	level.scr_model[ "gurney" ]														= "intro_props_gurney";
	
	level.scr_anim[ "surgery_cart" ][ "intro_opening_shot08" ] 						= %intro_opening_shot08_cart;
	level.scr_animtree[ "surgery_cart" ]					 						= #animtree;
	level.scr_model[ "surgery_cart" ]						 						= "intro_props_surgery_cart";
	
	level.scr_anim[ "forceps" ][ "intro_opening_shot07" ] 						= %intro_opening_shot07_forceps;
	level.scr_anim[ "forceps" ][ "intro_opening_shot08" ] 						= %intro_opening_shot08_forceps;
	level.scr_anim[ "forceps" ][ "escort_doctor_dies" ] 						= %intro_docdown_docdie_forceps;
	level.scr_anim[ "forceps" ][ "intro_work_on_soap" ][0] 						= %intro_docdown_forceps;
	level.scr_animtree[ "forceps" ]					 							= #animtree;
	level.scr_model[ "forceps" ]						 						= "intro_forceps";
	
	level.scr_anim[ "gauze" ][ "intro_opening_shot07" ] 						= %intro_opening_shot07_gauze;
	level.scr_anim[ "gauze" ][ "intro_opening_shot08" ] 						= %intro_opening_shot08_gauze;
	level.scr_anim[ "gauze" ][ "escort_doctor_dies" ] 						= %intro_docdown_docdie_gauze;
	level.scr_anim[ "gauze" ][ "intro_work_on_soap" ][0] 							= %intro_docdown_gauze;
	level.scr_animtree[ "gauze" ]					 							= #animtree;
	level.scr_model[ "gauze" ]						 							= "intro_gauze";
	
	level.scr_animtree["helicrash_wallshards"] 										= #animtree;
	level.scr_anim[ "helicrash_wallshards" ][ "wallshards" ]						= %intro_helicrash_wallshards;

	level.scr_animtree[ "intro_ceiling_woodbeam_01" ]							= #animtree;
	level.scr_model[ "intro_ceiling_woodbeam_01" ]								= "intro_ceiling_woodbeam_01";
	level.scr_anim[ "intro_ceiling_woodbeam_01" ][ "intro_opening_shot08" ] = %intro_opening_shot08_debris_beam;

	level.scr_animtree[ "intro_ceiling_damage_med_01" ]							= #animtree;
	level.scr_model[ "intro_ceiling_damage_med_01" ]							= "intro_ceiling_damage_med_01";
	level.scr_anim[ "intro_ceiling_damage_med_01" ][ "intro_opening_shot08" ] = %intro_opening_shot08_debris_rubble;

	
	//---- COURTYARD ----//
 	 //breach door
  	level.scr_anim[ "breach_door_model" ][ "breach" ]			 					= %breach_player_door_hinge_v1;
	level.scr_animtree[ "breach_door_model" ]					 					= #animtree;
	level.scr_model[ "breach_door_model" ]						 					= "intro_door_piece_hinge5";
	
	//cover object in courtyard
	level.scr_anim[ "cover_object" ][ "cover_object_pull_down" ] 					= %intro_npc_move_object_cover_object;
	level.scr_animtree[ "cover_object" ]					 						= #animtree;
	level.scr_model[ "cover_object" ]						 						= "intro_pillar_cover01";
	addnotetrack_customfunction( "cover_object", "brick_impact", maps\intro_fx::courtyard_brick_impacts, "cover_object_pull_down" );
	
	level.scr_anim[ "gate" ][ "price_to_nikolai" ] 									= %intro_price_reload_door;
	level.scr_animtree[ "gate" ]					 								= #animtree;
	level.scr_model[ "gate" ]						 								= "intro_props_front_gate";
	
	//---- ESCORT ----//
	level.scr_anim[ "rope" ][ "escort_rappel" ] 									= %intro_rope_rappel;
	level.scr_animtree[ "rope" ]					 								= #animtree;
	level.scr_model[ "rope" ]						 								= "weapon_rappel_rope_long";
	
	level.scr_anim[ "syringe" ][ "escort_help_soap" ] 								= %intro_docdown_needle_injector;
	level.scr_anim[ "syringe" ][ "escort_help_soap_breach" ] 						= %intro_docdown_breach_injector;
	
	level.scr_animtree[ "syringe" ]					 								= #animtree;
	level.scr_model[ "syringe" ]						 							= "weapon_syringe";
	
	
	
	//---- MAARS CONTROL ----//
	level.scr_anim[ "flashlight" ][ "intro_weapon_cache_start" ] 					= %intro_weapon_cache_flashlight_start;
	level.scr_anim[ "flashlight" ][ "intro_weapon_cache_stairs_idle" ][ 0 ] 		= %intro_weapon_cache_flashlight_price_idle;
	level.scr_anim[ "flashlight" ][ "intro_weapon_cache_idle" ][ 0 ] 				= %intro_weapon_cache_flashlight_idle;
	level.scr_anim[ "flashlight" ][ "intro_weapon_cache_pullout" ] 					= %intro_weapon_cache_flashlight_price_end;
	level.scr_anim[ "flashlight" ][ "intro_weapon_cache_end" ] 						= %intro_weapon_cache_flashlight_end ;
	level.scr_animtree[ "flashlight" ]					 							= #animtree;
	level.scr_model[ "flashlight" ]						 							= "com_flashlight_on";
	
	level.scr_anim[ "crate_door" ][ "intro_weapon_cache_pullout" ] 					= %intro_weapon_cache_crate_door;
	level.scr_animtree[ "crate_door" ]					 							= #animtree;
	level.scr_model[ "crate_door" ]						 							= "intro_crate_sidewall01";
	//addnotetrack_customfunction( "crate_door", "crate_open", maps\intro_fx::maars_crate_door_openfx, "intro_weapon_cache_start" );
	//addnotetrack_customfunction( "crate_door", "crate_door_impact", maps\intro_fx::maars_crate_door_impactfx, "intro_weapon_cache_start" );
	
	level.scr_anim[ "ugv_model" ][ "intro_weapon_cache_pullout" ] 					= %intro_weapon_cache_ugv_pullout;
	level.scr_animtree[ "ugv_model" ]					 							= #animtree;
	level.scr_model[ "ugv_model" ]						 							= "vehicle_ugv_robot";
	
	level.scr_anim[ "rolling_door" ][ "intro_weapon_cache_end" ] 					= %intro_weapon_cache_rollingdoor;
	level.scr_animtree[ "rolling_door" ]					 						= #animtree;
	level.scr_model[ "rolling_door" ]						 						= "intro_rollingdoor_01";
	addnotetrack_customfunction( "rolling_door", "rolling_door_open", maps\intro_fx::maars_rolling_door_openfx, "intro_weapon_cache_end" );
	
	level.scr_anim[ "trap_door" ][ "intro_weapon_cache_start" ] 					= %intro_weapon_cache_trapdoor;
	level.scr_animtree[ "trap_door" ]					 							= #animtree;
	level.scr_model[ "trap_door" ]						 							= "intro_trapdoor_01";
	addnotetrack_customfunction( "trap_door", "intro_trap_door_open", maps\intro_fx::maars_trap_door_openfx, "intro_weapon_cache_start" );
	addnotetrack_customfunction( "trap_door", "intro_trap_door_impact", maps\intro_fx::maars_trap_door_impactfx, "intro_weapon_cache_start" );
	
	level.scr_anim[ "crowbar" ][ "intro_weapon_cache_pullout" ] 						= %intro_weapon_cache_crowbar;
	level.scr_animtree[ "crowbar" ]					 								= #animtree;
	level.scr_model[ "crowbar" ]						 							= "paris_crowbar_01";
	
	//---- RUN ----//
	level.scr_animtree[ "animated_tree" ]											= #animtree;
	level.scr_anim[ "animated_tree" ][ "tree_fall"]									= %intro_tree_fall;
	level.scr_model[ "animated_tree" ]						 						= "foliage_intro_tree_01_destroyed";
	
	
	//---- BUILDING SLIDE MOMENT ----//
	level.scr_animtree[ "landslide_building_roof" ]													= #animtree;
	level.scr_anim[ "landslide_building_roof" ][ "intro_rooftop_collapse_sim_roof" ]				= %intro_rooftop_collapse_sim_roof;
	level.scr_animtree[ "landslide_building_roof2" ]												= #animtree;
	level.scr_anim[ "landslide_building_roof2" ][ "intro_rooftop_collapse_sim_roof2" ]				= %intro_rooftop_collapse_sim_roof2;
	level.scr_animtree[ "landslide_building_subfloor" ]												= #animtree;
	level.scr_anim[ "landslide_building_subfloor" ][ "intro_rooftop_collapse_sim_subfloor"]			= %intro_rooftop_collapse_sim_subfloor;
	level.scr_animtree[ "landslide_building_handkey" ]												= #animtree;
	level.scr_anim[ "landslide_building_handkey" ][ "intro_rooftop_collapse_handkey"]				= %intro_rooftop_collapse_handkey;
	level.scr_animtree[ "landslide_building_small_01" ]												= #animtree;
	level.scr_anim[ "landslide_building_small_01" ][ "intro_landslide_small"]				= %intro_rooftop_collapse_small_building;
	level.scr_anim[ "landslide_building_small_01" ][ "river_ride"]									= %intro_river_ride_small_building;
	level.scr_animtree[ "landslide_building_small_02" ]												= #animtree;
	level.scr_anim[ "landslide_building_small_02" ][ "intro_landslide_small"]				= %intro_rooftop_collapse_small_building;

	level.scr_animtree[ "intro_landslide_building_replaceshards" ]												= #animtree;
	level.scr_anim[ "intro_landslide_building_replaceshards" ][ "intro_rooftop_collapse_replaceshards"]				= %intro_rooftop_collapse_replaceshards;

	
	level.scr_animtree[ "landslide_building_water_heater" ]											= #animtree;
	level.scr_anim[ "landslide_building_water_heater" ][ "roof_collapse_slide"]						= %intro_rooftop_collapse_heater;
	level.scr_anim[ "landslide_building_water_heater" ][ "river_ride"]						= %intro_river_ride_heater;
	level.scr_model[ "landslide_building_water_heater" ]						 					= "com_water_heater_nopipes_rigged";

}

#using_animtree( "door" );
door_setup()
{
	level.scr_anim[ "door" ][ "door_breach" ] 						= %shotgunbreach_door_immediate;

	level.scr_animtree[ "door" ] = #animtree;
	level.scr_model[ "door" ] = "com_door_01_handleleft2";
	precachemodel( level.scr_model[ "door" ] );
}

#using_animtree( "animated_props" );
animated_props()
{
	
}

#using_animtree( "generic_human" );
npc_animations()
{
	//---- INTRO ----//
	level.scr_anim[ "nikolai" ][ "intro_opening_shot01" ] 			= %intro_opening_shot01_nikolai;
	level.scr_anim[ "price" ][ "intro_opening_shot01" ] 			= %intro_opening_shot01_price;
	level.scr_anim[ "player_body" ][ "intro_opening_shot01" ]		= %intro_opening_shot01_playerbody;
	level.scr_anim[ "player_body" ][ "intro_opening_shot02" ]		= %intro_opening_shot02_playerbody;
	level.scr_anim[ "player_body" ][ "intro_opening_shot03" ]		= %intro_opening_shot03_playerbody;
	level.scr_anim[ "player_body" ][ "intro_opening_shot04" ]		= %intro_opening_shot04_playerbody;
	level.scr_anim[ "player_body" ][ "intro_opening_shot05" ]		= %intro_opening_shot05_playerbody;
	level.scr_model[ "player_body" ]						 		= "body_hero_soap_wounded";
	level.scr_animtree[ "player_body" ]					 			= #animtree;







	level.scr_face[ "nikolai" ][ "intro_opening_shot02_nikolai_face" ] 	= %intro_opening_shot02_nikolai_face;
	level.scr_anim[ "nikolai" ][ "intro_opening_shot02" ] 			= %intro_opening_shot02_nikolai;
	level.scr_anim[ "price" ][ "intro_opening_shot02" ] 			= %intro_opening_shot02_price;
	level.scr_face[ "price" ][ "intro_opening_shot02_price_face" ] 	= %intro_opening_shot02_price_face;
	
	level.scr_anim[ "bystander1" ][ "intro_opening_shot02" ] 		= %intro_opening_shot02_bystander_1;
	level.scr_anim[ "bystander2" ][ "intro_opening_shot02" ] 		= %intro_opening_shot02_bystander_2;
	level.scr_anim[ "bystander3" ][ "intro_opening_shot02" ] 		= %intro_opening_shot02_bystander_3;
		

	level.scr_anim[ "nikolai" ][ "intro_opening_shot03" ] 			= %intro_opening_shot03_nikolai;
	level.scr_anim[ "price" ][ "intro_opening_shot03" ] 			= %intro_opening_shot03_price;
	level.scr_anim[ "bystander1" ][ "intro_opening_shot03" ] 		= %intro_opening_shot03_bystander_1;
	level.scr_anim[ "bystander2" ][ "intro_opening_shot03" ] 		= %intro_opening_shot03_bystander_2;
	level.scr_anim[ "bystander3" ][ "intro_opening_shot03" ] 		= %intro_opening_shot03_bystander_3;
	level.scr_anim[ "bystander4" ][ "intro_opening_shot03" ] 		= %intro_opening_shot03_bystander_4;
	level.scr_anim[ "bystander5" ][ "intro_opening_shot03" ] 		= %intro_opening_shot03_bystander_5;
	

	level.scr_anim[ "nikolai" ][ "intro_opening_shot04" ] 			= %intro_opening_shot04_nikolai;
	level.scr_face[ "nikolai" ][ "intro_opening_shot04_face" ] 		= %intro_opening_shot04_nikolai_face;
	 
	level.scr_anim[ "price" ][ "intro_opening_shot04" ] 			= %intro_opening_shot04_price;
	level.scr_face[ "price" ][ "intro_opening_shot04_price_face" ] 		= %intro_opening_shot04_price_face;
	level.scr_anim[ "bystander1" ][ "intro_opening_shot04" ] 		= %intro_opening_shot04_bystander_1;
	level.scr_anim[ "bystander2" ][ "intro_opening_shot04" ] 		= %intro_opening_shot04_bystander_2;
	level.scr_anim[ "bystander3" ][ "intro_opening_shot04" ] 		= %intro_opening_shot04_bystander_3;
	level.scr_anim[ "bystander4" ][ "intro_opening_shot04" ] 		= %intro_opening_shot04_bystander_4;
	level.scr_anim[ "bystander5" ][ "intro_opening_shot04" ] 		= %intro_opening_shot04_bystander_5;
	level.scr_anim[ "bystander6" ][ "intro_opening_shot04" ] 		= %intro_opening_shot04_bystander_6;
	level.scr_anim[ "bystander7" ][ "intro_opening_shot04" ] 		= %intro_opening_shot04_bystander_7;

	level.scr_anim[ "nikolai" ][ "intro_opening_shot05" ] 			= %intro_opening_shot05_nikolai;
	level.scr_anim[ "price" ][ "intro_opening_shot05" ] 			= %intro_opening_shot05_price;
	level.scr_anim[ "doctor" ][ "intro_opening_shot05" ] 			= %intro_opening_shot05_doc;

	level.scr_anim[ "nikolai" ][ "intro_opening_shot06" ] 			= %intro_opening_shot06_nikolai;
	level.scr_anim[ "price" ][ "intro_opening_shot06" ] 			= %intro_opening_shot06_price;
	level.scr_anim[ "doctor" ][ "intro_opening_shot06" ] 			= %intro_opening_shot06_doc;
	level.scr_anim[ "yuri" ][ "intro_opening_shot06" ] 				= %intro_opening_shot06_yuri;

	level.scr_anim[ "nikolai" ][ "intro_opening_shot07" ] 			= %intro_opening_shot07_nikolai;
	level.scr_face[ "nikolai" ][ "intro_opening_shot07_face" ] 			= %intro_opening_shot07_nikolai_face;
	
	level.scr_anim[ "price" ][ "intro_opening_shot07" ] 			= %intro_opening_shot07_price;
	level.scr_anim[ "doctor" ][ "intro_opening_shot07" ] 			= %intro_opening_shot07_doc;
	level.scr_anim[ "soap" ][ "intro_opening_shot07" ] 				= %intro_opening_shot07_soap;
	addnotetrack_customfunction( "soap", "fx_blood_cough", ::fx_blood_cough, "intro_opening_shot07" );

	level.scr_anim[ "nikolai" ][ "intro_opening_shot08" ] 			= %intro_opening_shot08_nikolai;
	level.scr_face[ "nikolai" ][ "intro_opening_shot08_face" ] 		= %intro_opening_shot08_nikolai_face;
	
	level.scr_anim[ "price" ][ "intro_opening_shot08" ] 			= %intro_opening_shot08_price;
	level.scr_anim[ "doctor" ][ "intro_opening_shot08" ] 			= %intro_opening_shot08_doc;
	level.scr_anim[ "soap" ][ "intro_opening_shot08" ] 				= %intro_opening_shot08_soap;

	
	level.scr_anim[ "doctor" ][ "intro_work_on_soap" ][0]			= %intro_docdown_idle1_doc;
	level.scr_anim[ "nikolai" ][ "intro_work_on_soap" ][0]			= %intro_docdown_idle1_nikolai;
	level.scr_anim[ "soap" ][ "intro_work_on_soap" ][0]				= %intro_docdown_idle1_soap;
	
	


	
	

	//---- COURTYARD ----//
	// courtyard breach
	level.scr_anim[ "breacher1" ][ "courtyard_breach" ] 			= %intro_courtyard_breach_guy1;
	level.scr_anim[ "breacher2" ][ "courtyard_breach" ] 			= %intro_courtyard_breach_guy2;
	level.scr_anim[ "breacher3" ][ "courtyard_breach" ] 			= %intro_courtyard_breach_guy3;
	level.scr_anim[ "breacher4" ][ "courtyard_breach" ] 			= %intro_courtyard_breach_guy4;
	level.scr_anim[ "breacher5" ][ "courtyard_breach" ] 			= %intro_courtyard_breach_guy5;
	level.scr_anim[ "breacher6" ][ "courtyard_breach" ] 			= %intro_courtyard_breach_guy6;
	
	//friendly intro
	level.scr_anim[ "generic" ][ "coverstand_hide_idle_wave02" ] 		= %coverstand_hide_idle_wave02;
	
	//pull down cover objective_add
	level.scr_anim[ "object_puller1" ][ "cover_object_pull_down" ] 		= %intro_npc_move_object_for_cover_2;
	level.scr_anim[ "object_puller2" ][ "cover_object_pull_down" ] 		= %intro_npc_move_object_for_cover_3;
	
	//---- ESCORT ----//
	//doctor killed
	level.scr_anim[ "doctor" ][ "escort_doctor_dies" ]					= %intro_docdown_docdie_doc;
	level.scr_anim[ "nikolai" ][ "escort_doctor_dies" ]					= %intro_docdown_docdie_nikolai;
	level.scr_anim[ "soap" ][ "escort_doctor_dies" ]					= %intro_docdown_docdie_soap;
	
	//price throw smoke
	level.scr_anim[ "price" ][ "exposed_grenadeThrowB" ]					= %exposed_grenadeThrowB;
	
	
	//wait for player to help
	level.scr_anim[ "nikolai" ][ "escort_wait_for_player_idle" ][0]		= %intro_docdown_idle2_nikolai;
	level.scr_anim[ "soap" ][ "escort_wait_for_player_idle" ][0]		= %intro_docdown_idle2_soap;
	
	//help soap
	level.scr_anim[ "nikolai" ][ "escort_help_soap" ]					= %intro_docdown_needle_nikolai;
	level.scr_anim[ "soap" ][ "escort_help_soap" ]						= %intro_docdown_needle_soap;
	level.scr_anim[ "price" ][ "escort_help_soap" ]						= %intro_docdown_needle_price;	
	level.scr_anim[ "soap" ][ "soap_lie_down_idle" ][0]					= %intro_docdown_idle3_soap;
	addnotetrack_customfunction( "soap", "fx_soap_stop_bleeding", ::fx_soap_stop_bleeding, "escort_help_soap" );
	
	
	//help soap breach
	level.scr_anim[ "nikolai" ][ "escort_help_soap_breach" ]			= %intro_docdown_breach_nikolai;
	level.scr_anim[ "price" ][ "escort_help_soap_breach" ]				= %intro_docdown_breach_price;
	level.scr_face[ "price" ][ "escort_help_soap_breach_price_face" ]		= %intro_docdown_breach_price_face;
	level.scr_anim[ "soap" ][ "escort_help_soap_breach" ]				= %intro_docdown_breach_soap;
	level.scr_anim[ "breacher1" ][ "escort_help_soap_breach" ]			= %intro_docdown_breach_npc1;
	level.scr_anim[ "breacher2" ][ "escort_help_soap_breach" ]			= %intro_docdown_breach_npc2;
	addnotetrack_customfunction( "breacher1", "door_breach", ::breach_hotel_door, "escort_help_soap_breach" );
	addnotetrack_customfunction( "breacher1", "dropgun", ::drop_weapon, "escort_help_soap_breach" );
	addnotetrack_customfunction( "breacher1", "die", ::kill_me, "escort_help_soap_breach" );
	addnotetrack_customfunction( "price", "chest_2_hand", ::equip_main_weapon, "escort_help_soap_breach" );
	addnotetrack_customfunction( "price", "fx_pistolfire", maps\intro_fx::price_pistolfire, "escort_help_soap_breach" );

	//rappeler
	level.scr_anim[ "generic" ][ "escort_rappel" ]						= %intro_npc_rappel;
	
	//price open door to downstairs
	level.scr_anim[ "price" ][ "door_kick_in" ]							= %doorkick_2_cqbrun;
	
	//nikolai pick up soap
	level.scr_anim[ "nikolai" ][ "pickup_soap" ]						= %intro_docdown_exit_nikolai;
	level.scr_anim[ "soap" ][ "pickup_soap" ]							= %intro_docdown_exit_soap;
	
	level.scr_anim[ "nikolai" ][ "putdown_soap_init" ]					= %intro_fireman_carry_drop_guy_carrier_init;
	level.scr_anim[ "soap" ][ "putdown_soap_init" ]						= %intro_fireman_carry_drop_guy_carried_init;
	
	//---- REGROUP ----//
	//price to nikolai
	level.scr_anim[ "price" ][ "price_to_nikolai_transition" ]			= %intro_radio_price_to_idle;
	level.scr_anim[ "price" ][ "price_to_nikolai" ]				 		= %intro_radio_price_reload;
	level.scr_face[ "price" ][ "price_to_nikolai_face" ]				= %intro_radio_price_reload_face;
	
	//addnotetrack_customfunction( "price", "price_gate_breach", maps\intro_fx::regroup_price_gate_breach, "price_to_nikolai" );
	
	//break and rake
	level.scr_anim[ "price" ][ "price_break_and_rake" ]					= %intro_price_break_and_rake_entrance;
	
	
	//price cover slide
	//level.scr_anim[ "price" ][ "price_cover_slide" ]					= %intro_price_slide_cover_like_magpul;
	
	//rus friend move up
	level.scr_anim[ "generic" ][ "coverstand_hide_idle_wave01" ] 		= %coverstand_hide_idle_wave01;
	
	//civilian drag
	//level.scr_anim["wounded_guy"]["wounded_idle"][0]					= %intro_wounded_drag_idle_wounded;
	//level.scr_anim["wounded_carrier"]["run_to"] 						= %intro_wounded_run_to_carrier;
	level.scr_anim["generic"]["intro_wounded_drag_carrier"] 		= %intro_wounded_drag_carrier;
	level.scr_anim["generic"]["intro_wounded_drag_wounded"] 		= %intro_wounded_drag_wounded;
	level.scr_anim["generic"]["intro_wounded_drag_carrier_idle"][0] 	= %intro_wounded_help_carrier;
	level.scr_anim["generic"]["intro_wounded_drag_wounded_idle"][0] 	= %intro_wounded_help_wounded;
	
	//civ wounded 1
	level.scr_anim["generic"]["regroup_wounded_civ_1"][0] 				= %arcadia_ending_sceneA_dead_civilian;
	
	//civ_wounded 2
	level.scr_anim["generic"]["regroup_wounded_civ_2"] 					= %civilian_crawl_2;
	level.scr_anim["generic"]["regroup_wounded_civ_2_death"] 			= %civilian_crawl_2_death_A;
	
	//fire rocket at mi28_2
	level.scr_anim[ "generic" ][ "fire_rocket" ]						= %contengency_rocket_moment;
	
	//friends cover and move up
	level.scr_anim[ "guy1" ][ "car_cover_start" ]						= %intro_move_from_cover_start_guy1;
	level.scr_anim[ "guy2" ][ "car_cover_start" ]						= %intro_move_from_cover_start_guy2;
	level.scr_anim[ "generic" ][ "car_cover_idle1" ][0]					= %intro_move_from_cover_idle_guy1;
	level.scr_anim[ "generic" ][ "car_cover_idle2" ][0]					= %intro_move_from_cover_idle_guy2;
	level.scr_anim[ "guy1" ][ "car_cover_end" ]							= %intro_move_from_cover_end_guy1;
	level.scr_anim[ "guy2" ][ "car_cover_end" ]							= %intro_move_from_cover_end_guy2;
	
	//guy opens car door and takes cover
	level.scr_anim[ "generic" ][ "car_door_cover" ]						= %intro_npc_use_car_door_cover_entrance;
	
	
	//regroup ending 
	level.scr_anim[ "left_guy" ][ "breach_kick_stackL1_idle" ][ 0 ]	= %breach_kick_stackL1_idle;
	level.scr_anim[ "left_guy" ][ "breach_kick" ]					= %breach_kick_stackL1_enter;
	
	level.scr_anim[ "right_guy" ][ "breach_kick" ]					= %breach_kick_kickerR1_enter;
	
	level.scr_anim[ "right_guy" ][ "door_breach_setup" ]			= %intro_breach_shotgun_hinge_v1;
	level.scr_anim[ "right_guy" ][ "door_breach_setup_idle" ][ 0 ] 	= %shotgunbreach_v1_shoot_hinge_idle;
	level.scr_anim[ "right_guy" ][ "door_breach_idle" ][ 0 ]		= %intro_breach_shotgun_hinge_ready_idle_v1;
	level.scr_anim[ "right_guy" ][ "door_breach" ]					= %intro_breach_shotgun_hinge_runin_v1;

	level.scr_anim[ "left_guy" ][ "door_breach_setup" ]			 	= %intro_breach_stackb_v1;
	level.scr_anim[ "left_guy" ][ "door_breach_setup_idle" ][ 0 ]	= %shotgunbreach_v1_stackB_idle;
	level.scr_anim[ "left_guy" ][ "door_breach_idle" ][ 0 ]			= %shotgunbreach_v1_stackB_ready_idle;
	level.scr_anim[ "left_guy" ][ "door_breach" ]					= %intro_breach_stackb_runin_v1;
	
	
	
	
	//---- MAARS ----//
	
	//maars open door

	
	level.scr_anim[ "yuri" ][ "control_ugv" ][0]						= %intro_weapon_cach_yuri_idle;
	
	//maars intro
	level.scr_anim[ "price" ][ "intro_weapon_cache_upto_shed" ]			= %intro_price_upto_shed;
	level.scr_anim[ "price" ][ "intro_weapon_cache_upto_shed_idle" ][0]	= %intro_price_upto_shed_idle;
	level.scr_anim[ "price" ][ "intro_weapon_cache_start" ]				= %intro_weapon_cache_price_start;
	level.scr_anim[ "price" ][ "intro_weapon_cache_stairs_idle" ][0]	= %intro_weapon_cache_price_stairs_idle;
	level.scr_anim[ "price" ][ "intro_weapon_cache_pullout" ]			= %intro_weapon_cache_price_pullout;
	level.scr_face[ "price" ][ "intro_weapon_cache_pullout_face" ]		= %intro_weapon_cache_price_pullout_face;
	level.scr_anim[ "price" ][ "intro_weapon_cache_idle" ][0]			= %intro_weapon_cache_price_signal_idle;
	level.scr_anim[ "price" ][ "intro_weapon_cache_end" ]				= %intro_weapon_cache_price_end;
	level.scr_anim[ "price" ][ "intro_weapon_cache_end_idle" ][0]		= %intro_weapon_cache_price_end_idle;
	addnotetrack_customfunction( "price", "light_on", ::maars_control_flashlight_on, "intro_weapon_cache_start" );
	addnotetrack_customfunction( "price", "light_off", ::maars_control_flashlight_off, "intro_weapon_cache_end" );
	//addnotetrack_customfunction( "price", "price_ugv_pull", maps\intro_fx::maars_ugv_dust, "intro_weapon_cache_start" );
    
    
    //maars control end SEQUENCE
    level.scr_anim[ "soap" ][ "intro_ugv_helicopter" ]					= %intro_helicopter_guy1;
    level.scr_anim[ "nikolai" ][ "intro_ugv_helicopter" ]				= %intro_helicopter_guy2;
    level.scr_anim[ "price" ][ "intro_ugv_helicopter" ]					= %intro_helicopter_guy3;
    level.scr_anim[ "soap" ][ "intro_ugv_helicopter_idle" ][0]			= %intro_helicopter_idle_guy1;
    level.scr_anim[ "nikolai" ][ "intro_ugv_helicopter_idle" ][0]		= %intro_helicopter_idle_guy2;
    level.scr_anim[ "price" ][ "intro_ugv_helicopter_idle" ][0]			= %intro_helicopter_idle_guy3;
      
    //---- RIVER RIDE ----//
    level.scr_anim[ "soap" ][ "river_ride" ]							= %intro_river_ride_soap;
    level.scr_anim[ "nikolai" ][ "river_ride" ]							= %intro_river_ride_nikolai;
    level.scr_anim[ "price" ][ "river_ride" ]							= %intro_river_ride_price;
      
}



#using_animtree( "generic_human" );

drone_anim()
{
	level.scr_anim[ "generic" ][ "bunker_toss_idle_guy1" ][ 0 ] = %bunker_toss_idle_guy1;
	//level.scr_anim[ "generic" ][ "DC_Burning_artillery_reaction_v1_idle" ][ 0 ] = %DC_Burning_artillery_reaction_v1_idle;
	//level.scr_anim[ "generic" ][ "DC_Burning_artillery_reaction_v2_idle" ][ 0 ] = %DC_Burning_artillery_reaction_v2_idle;
	level.scr_anim[ "generic" ][ "DC_Burning_artillery_reaction_v3_idle" ][ 0 ] = %DC_Burning_artillery_reaction_v3_idle;
//	level.scr_anim[ "generic" ][ "DC_Burning_artillery_reaction_v4_idle" ][ 0 ] = %DC_Burning_artillery_reaction_v4_idle;
	level.scr_anim[ "generic" ][ "DC_Burning_bunker_sit_idle" ][ 0 ] = %DC_Burning_bunker_sit_idle;
	level.scr_anim[ "generic" ][ "civilain_crouch_hide_idle" ][ 0 ] = %civilain_crouch_hide_idle;
	level.scr_anim[ "generic" ][ "civilain_crouch_hide_idle_loop" ][ 0 ] = %civilain_crouch_hide_idle_loop;
	//level.scr_anim[ "generic" ][ "roadkill_cover_soldier_idle" ][ 0 ] = %roadkill_cover_soldier_idle;
	//level.scr_anim[ "generic" ][ "roadkill_cover_soldier" ][ 0 ] = %roadkill_cover_soldier;
	level.scr_anim[ "generic" ][ "DC_Burning_stop_bleeding_wounded_endidle" ][ 0 ] = %DC_Burning_stop_bleeding_wounded_endidle;
	level.scr_anim[ "generic" ][ "DC_Burning_stop_bleeding_medic_endidle" ][ 0 ] = %DC_Burning_stop_bleeding_medic_endidle;
	level.scr_anim[ "generic" ][ "DC_Burning_stop_bleeding_wounded_idle" ][ 0 ] = %DC_Burning_stop_bleeding_wounded_idle;
	//level.scr_anim[ "generic" ][ "roadkill_cover_active_soldier1" ][ 0 ] = %roadkill_cover_active_soldier1;
	//level.scr_anim[ "generic" ][ "roadkill_cover_active_soldier2" ][ 0 ] = %roadkill_cover_active_soldier2;
	//level.scr_anim[ "generic" ][ "roadkill_cover_active_soldier3" ][ 0 ] = %roadkill_cover_active_soldier3;
	//level.scr_anim[ "generic" ][ "prague_bully_civ_survive_idle" ][ 0 ] = %prague_bully_civ_survive_idle;
	
	//level.scr_anim[ "generic" ][ "airport_security_guard_pillar_death_R" ] = %airport_security_guard_pillar_death_R;
	//level.scr_anim[ "generic" ][ "RPG_stand_death_stagger" ] = %RPG_stand_death_stagger;
	level.scr_anim[ "generic" ][ "death_explosion_run_R_v1" ] = %death_explosion_run_R_v1;
	level.scr_anim[ "generic" ][ "death_explosion_stand_F_v4" ] = %death_explosion_stand_F_v4;
	//level.scr_anim[ "generic" ][ "stand_death_stumbleforward" ] = %stand_death_stumbleforward;
	level.scr_anim[ "generic" ][ "stand_death_tumbleback" ] = %stand_death_tumbleback;
	//level.scr_anim[ "generic" ][ "death_shotgun_spinL" ] = %death_shotgun_spinL;

	level.scr_anim[ "generic" ][ "prague_resistance_hit" ] = %prague_resistance_hit;
	level.scr_anim[ "generic" ][ "prague_resistance_hit_idle" ][ 0 ] = %prague_resistance_hit_idle;
	
	level.scr_anim[ "generic" ][ "prague_woundwalk_wounded" ] = %prague_woundwalk_wounded;
	level.scr_anim[ "generic" ][ "prague_woundwalk_helper" ] = %prague_woundwalk_helper;
	level.scr_anim[ "generic" ][ "prague_woundwalk_wounded_idle" ][ 0 ] = %prague_woundidle_wounded;
	level.scr_anim[ "generic" ][ "prague_woundwalk_helper_idle" ][ 0 ] = %prague_woundidle_helper;
	
	level.scr_anim[ "generic" ][ "prague_civ_door_peek" ]			= %prague_civ_door_peek;
	//level.scr_anim[ "generic" ][ "prague_civ_door_runin" ]			= %prague_civ_door_runin;
	
	//level.scr_anim[ "generic" ][ "prague_resistance_cover_idle_once_l" ] = %prague_resistance_cover_idle_l; 
	//level.scr_anim[ "generic" ][ "prague_resistance_cover_idle_l" ][ 0 ] = %prague_resistance_cover_idle_l; 
	//level.scr_anim[ "generic" ][ "prague_resistance_cover_shoot_l" ] = %prague_resistance_cover_shoot_l; 
	//level.scr_anim[ "generic" ][ "prague_resistance_cover_l2r" ] = %prague_resistance_cover_l2r; 
	
	//level.scr_anim[ "generic" ][ "prague_resistance_cover_idle_once_r" ] = %prague_resistance_cover_idle_r; 
	//level.scr_anim[ "generic" ][ "prague_resistance_cover_idle_r" ][ 0 ] = %prague_resistance_cover_idle_r; 
	//level.scr_anim[ "generic" ][ "prague_resistance_cover_shoot_r" ] = %prague_resistance_cover_shoot_r; 
	//level.scr_anim[ "generic" ][ "prague_resistance_cover_r2l" ] = %prague_resistance_cover_r2l;
	
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_pull" ] = %airport_civ_dying_groupB_pull;
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_wounded" ] = %airport_civ_dying_groupB_wounded;
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_pull_death" ] = %airport_civ_dying_groupB_pull_death;
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_wounded_death" ] = %airport_civ_dying_groupB_wounded_death;
	
	//civ_wounded 2
	level.scr_anim["generic"]["civilian_crawl_2"] 					= %civilian_crawl_2;
	level.scr_anim["generic"]["civilian_crawl_2_death"] 			= %civilian_crawl_2_death_A;
	
	/*
	level.combat_runs = [];
	level.combat_runs[ level.combat_runs.size ] = %prague_bully_a_run;
	level.combat_runs[ level.combat_runs.size ] = %huntedrun_1_look_right;
	level.combat_runs[ level.combat_runs.size ] = %crouch_sprint;
	*/
	
	level.civ_runs = [];
	level.civ_runs[ level.civ_runs.size ] = %civilian_run_hunched_C_relative;
	level.civ_runs[ level.civ_runs.size ] = %civilian_run_hunched_A_relative;
	level.civ_runs[ level.civ_runs.size ] = %unarmed_scared_run;
	level.civ_runs[ level.civ_runs.size ] = %civilian_run_upright_relative;
	level.civ_runs[ level.civ_runs.size ] = %ny_harbor_running_coughing_guy1_relative;
	level.civ_runs[ level.civ_runs.size ] = %afchase_shepherd_flee_loop_relative;
	level.civ_runs[ level.civ_runs.size ] = %prague_bully_civ_run_relative;


	
	
	//regroup_reactions
	level.scr_anim["generic"]["unarmed_cowercrouch_react_A"] 			= %unarmed_cowercrouch_react_A;
	level.scr_anim["generic"]["unarmed_cowercrouch_react_A_idle"][0] 	= %unarmed_cowerstand_pointidle;
	
	level.scr_anim["generic"]["unarmed_cowercrouch_idle_duck"] 			= %unarmed_cowercrouch_idle_duck;
	level.scr_anim["generic"]["unarmed_cowercrouch_idle_duck_idle"][0] 	= %unarmed_cowercrouch_idle;
	
	level.scr_anim["generic"]["intro_docdown_idle1_soap"][0] 			= %intro_docdown_idle1_soap;
	
	level.scr_anim["generic"]["unarmed_close_garage"]					= %intro_garage_door_closing;
	
	

}
drone_deaths()
{
	level.drone_deaths = [];
	level.drone_deaths[ level.drone_deaths.size ] = %stand_death_tumbleback;
	level.drone_deaths[ level.drone_deaths.size ] = %run_death_fallonback;
	level.drone_deaths[ level.drone_deaths.size ] = %run_death_roll;
	level.drone_deaths[ level.drone_deaths.size ] = %exposed_death_blowback;
	level.drone_deaths[ level.drone_deaths.size ] = %exposed_death_firing_02;

	level.drone_deaths_f = [];
	level.drone_deaths_f[ level.drone_deaths_f.size ] = %death_run_forward_crumple;
	level.drone_deaths_f[ level.drone_deaths_f.size ] = %run_death_roll;
	level.drone_deaths_f[ level.drone_deaths_f.size ] = %run_death_skid;
	level.drone_deaths_f[ level.drone_deaths_f.size ] = %run_death_roll_02;
	level.drone_deaths_f[ level.drone_deaths_f.size ] = %run_death_roll_03;
	level.drone_deaths_f[ level.drone_deaths_f.size ] = %run_death_legshot;
	/*
	level.random_explosion_deaths = [];
	level.random_explosion_deaths[ level.random_explosion_deaths.size ] = %death_explosion_run_b_v1;
	level.random_explosion_deaths[ level.random_explosion_deaths.size ] = %death_explosion_run_b_v2;
	level.random_explosion_deaths[ level.random_explosion_deaths.size ] = %exposed_death_blowback;
	level.random_explosion_deaths[ level.random_explosion_deaths.size ] = %stand_death_tumbleback;
	*/
	/*
	level.explosion_deaths = [];
	level.explosion_deaths[ "u" ] = [];
	level.explosion_deaths[ "u" ][ level.explosion_deaths[ "u" ].size ] = %death_explosion_up10;
	level.explosion_deaths[ "f" ] = [];
	level.explosion_deaths[ "f" ][ level.explosion_deaths[ "f" ].size ] = %death_explosion_run_f_v1;
	level.explosion_deaths[ "f" ][ level.explosion_deaths[ "f" ].size ] = %death_explosion_run_f_v2;
	level.explosion_deaths[ "f" ][ level.explosion_deaths[ "f" ].size ] = %death_explosion_run_f_v3;
	level.explosion_deaths[ "f" ][ level.explosion_deaths[ "f" ].size ] = %death_explosion_run_f_v4;
	level.explosion_deaths[ "b" ] = [];
	level.explosion_deaths[ "b" ][ level.explosion_deaths[ "b" ].size ] = %death_explosion_run_b_v1;
	level.explosion_deaths[ "b" ][ level.explosion_deaths[ "b" ].size ] = %death_explosion_run_b_v2;
	level.explosion_deaths[ "l" ] = [];
	level.explosion_deaths[ "l" ][ level.explosion_deaths[ "l" ].size ] = %death_explosion_run_l_v1;
	level.explosion_deaths[ "l" ][ level.explosion_deaths[ "l" ].size ] = %death_explosion_run_l_v2;
	level.explosion_deaths[ "r" ] = [];
	level.explosion_deaths[ "r" ][ level.explosion_deaths[ "r" ].size ] = %death_explosion_run_r_v1;
	level.explosion_deaths[ "r" ][ level.explosion_deaths[ "r" ].size ] = %death_explosion_run_r_v2;
	*/
	/*
	level.violent_deaths = [];
	level.violent_deaths[ level.violent_deaths.size ] = %death_shotgun_legs;
	level.violent_deaths[ level.violent_deaths.size ] = %death_stand_sniper_leg;
	level.violent_deaths[ level.violent_deaths.size ] = %death_shotgun_back_v1;
	level.violent_deaths[ level.violent_deaths.size ] = %exposed_death_blowback;
	level.violent_deaths[ level.violent_deaths.size ] = %death_stand_sniper_chest1; 
	level.violent_deaths[ level.violent_deaths.size ] = %death_stand_sniper_chest2;
	level.violent_deaths[ level.violent_deaths.size ] = %death_stand_sniper_spin1;
	*/
	
	//level.scr_anim[ "generic" ][ "exposed_death_02" ]			= %exposed_death_02;
	//level.scr_anim[ "generic" ][ "CornerCrR_alert_death_slideout" ]			= %CornerCrR_alert_death_slideout;
	//level.scr_anim[ "generic" ][ "civilian_leaning_death" ]			= %civilian_leaning_death;
	level.scr_anim[ "generic" ][ "civilian_leaning_death_shot" ]			= %civilian_leaning_death_shot;
	level.scr_anim[ "generic" ][ "CornerCrL_death_side" ]			= %CornerCrL_death_side;
	level.scr_anim[ "generic" ][ "pistol_death_3" ]			= %pistol_death_3;
	level.scr_anim[ "generic" ][ "drone_stand_death" ]			= %drone_stand_death;
	level.scr_anim[ "generic" ][ "death_run_onfront" ]			= %death_run_onfront;
	level.scr_anim[ "generic" ][ "doorpeek_deathA" ]			= %doorpeek_deathA;
	//level.scr_anim[ "generic" ][ "death_pose_on_desk" ]			= %death_pose_on_desk;
	//level.scr_anim[ "generic" ][ "covercrouch_death_1" ]			= %covercrouch_death_1;
	//level.scr_anim[ "generic" ][ "covercrouch_death_2" ]			= %covercrouch_death_2;
	//level.scr_anim[ "generic" ][ "covercrouch_death_3" ]			= %covercrouch_death_3;
	//level.scr_anim[ "generic" ][ "corner_standR_death_grenade_slump" ]			= %corner_standR_death_grenade_slump;
	level.scr_anim[ "generic" ][ "death_run_onfront" ]			= %death_run_onfront;
	//level.scr_anim[ "generic" ][ "death_run_onfront" ]			= %death_run_onfront;
	//level.scr_anim[ "generic" ][ "hostage_stand_idle" ][ 0 ]			= %hostage_stand_idle;
	//level.scr_anim[ "generic" ][ "hostage_knees_idle" ][ 0 ]			= %hostage_knees_idle;	
	//level.scr_anim[ "generic" ][ "prague_deadguy_movement_01" ][ 0 ]			= %prague_deadguy_movement_01;	
	
	//level.scr_anim[ "generic" ][ "london_enemy_capture_enemy_death_01" ]			= %london_enemy_capture_enemy_death_01;
	//level.scr_anim[ "generic" ][ "london_enemy_capture_enemy_death_04" ]			= %london_enemy_capture_enemy_death_04;
	
	//level.scr_anim[ "generic" ][ "technical_driver_fallout" ]			= %technical_driver_fallout;
	
	//level.scr_anim[ "generic" ][ "roadkill_cover_radio_soldier3" ][0] = %roadkill_cover_radio_soldier3;
	//level.scr_anim[ "generic" ][ "training_basketball_rest" ][0] = %training_basketball_rest;
	//level.scr_anim[ "generic" ][ "roadkill_humvee_map_sequence_quiet_idle" ][0] = %roadkill_humvee_map_sequence_quiet_idle;
	//level.scr_anim[ "generic" ][ "training_locals_groupB_guy1" ][0] = %training_locals_groupB_guy1;
	//level.scr_anim[ "generic" ][ "training_locals_groupB_guy2" ][0] = %training_locals_groupB_guy2;
	//level.scr_anim[ "generic" ][ "training_locals_groupA_guy1" ][0] = %training_locals_groupA_guy1;
	//level.scr_anim[ "generic" ][ "training_locals_groupA_guy2" ][0] = %training_locals_groupA_guy2;
	//level.scr_anim[ "generic" ][ "training_locals_kneel" ][0] = %training_locals_kneel;
	//level.scr_anim[ "generic" ][ "casual_stand_idle" ][0] = %casual_stand_idle;
	//level.scr_anim[ "generic" ][ "casual_stand_v2_idle" ][0] = %casual_stand_v2_idle;
	//level.scr_anim[ "generic" ][ "casual_crouch_idle" ][0] = %casual_crouch_idle;
	//level.scr_anim[ "generic" ][ "casual_crouch_point" ][0] = %casual_crouch_point;
	//level.scr_anim[ "generic" ][ "training_intro_foley_idle_1" ][0] = %training_intro_foley_idle_1;
	
	//level.scr_anim[ "generic" ][ "dead_body_floating_1" ][0]			= %dead_body_floating_1;
	//level.scr_anim[ "generic" ][ "dead_body_floating_2" ][0]			= %dead_body_floating_2;
	//level.scr_anim[ "generic" ][ "dead_body_floating_3" ][0]			= %dead_body_floating_3;
	//level.scr_anim[ "generic" ][ "harbor_floating_idle_02" ][0]			= %harbor_floating_idle_02;
	//level.scr_anim[ "generic" ][ "harbor_floating_idle_03" ][0]			= %harbor_floating_idle_03;
	
	//level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v09" ][0]			= %paris_npc_dead_poses_v09;
	//level.scr_anim[ "generic" ][ "ny_harbor_doorway_headsmash_enemy_deadpose" ][0]			= %ny_harbor_doorway_headsmash_enemy_deadpose;
	//level.scr_anim[ "generic" ][ "hijack_hallway_dead_pose_assistant" ][0]			= %hijack_hallway_dead_pose_assistant;
	//level.scr_anim[ "generic" ][ "hijack_hallway_dead_pose_agent" ][0]			= %hijack_hallway_dead_pose_agent;
	//level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v02" ][0]			= %paris_npc_dead_poses_v02;
	
	//level.scr_anim[ "generic" ][ "hijack_hallway_dead_pose_terrorist" ][0]			= %hijack_hallway_dead_pose_terrorist;
	//level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v22" ][0]			= %paris_npc_dead_poses_v22;
	//level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v23" ][0]			= %paris_npc_dead_poses_v23;
	//level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v24_chair_sq" ][0]			= %paris_npc_dead_poses_v24_chair_sq;
	//level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v07" ][0]			= %paris_npc_dead_poses_v07;
	//level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v20" ][0]			= %paris_npc_dead_poses_v20;
	//level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v10" ][0]			= %paris_npc_dead_poses_v10;
	//level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v01" ][0]			= %paris_npc_dead_poses_v01;
	//level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v17" ][0]			= %paris_npc_dead_poses_v17;
	level.scr_anim[ "generic" ][ "arcadia_ending_sceneA_dead_civilian" ][0]			= %arcadia_ending_sceneA_dead_civilian;
	//level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v05" ][0]			= %paris_npc_dead_poses_v05;
	//level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v11" ][0]			= %paris_npc_dead_poses_v11;
	//level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v14" ][0]			= %paris_npc_dead_poses_v14;
	
	//level.scr_anim[ "generic" ][ "dcburning_elevator_corpse_idle_B" ][0]			= %dcburning_elevator_corpse_idle_B;
	//level.scr_anim[ "generic" ][ "dcburning_elevator_corpse_bump_B" ]				= %dcburning_elevator_corpse_bump_B;
	
	level.scr_anim[ "generic" ][ "prague_mourner_woman_idle" ][0]			= %prague_mourner_woman_idle;
	level.scr_anim[ "generic" ][ "prague_mourner_man_idle" ][0]			= %prague_mourner_man_idle;
}

#using_animtree( "script_model" );
drone_doors()
{
	level.scr_animtree[ "door_peek" ]			= #animtree;	
	level.scr_anim[ "door_peek" ][ "prague_civ_door_peek_door" ]			= %prague_civ_door_peek_door;
	//level.scr_anim[ "door" ][ "prague_civ_door_runin_door" ]			= %prague_civ_door_runin_door;
}

#using_animtree( "vehicles" );
vehicles()
{
	//---- INTRO SEQUENCE ----//
	
	level.scr_anim[ "littlebird" ][ "intro_opening_shot01" ] 						= %intro_opening_shot01_littlebird;
	level.scr_anim[ "littlebird" ][ "river_ride" ] 									= %intro_river_ride_littlebird;
	level.scr_animtree[ "littlebird" ]					 							= #animtree;
	level.scr_model[ "littlebird" ]						 							= "vehicle_mh_6_little_bird";
	
	level.scr_anim[ "mi28" ][ "intro_opening_shot06" ] 								= %intro_opening_shot06_mi28;
	level.scr_anim[ "mi28" ][ "intro_opening_shot07" ] 								= %intro_opening_shot07_mi28;
	level.scr_anim[ "mi28" ][ "intro_opening_shot08" ] 								= %intro_opening_shot08_mi28_destroyed;
	addnotetrack_customfunction( "mi28", "fx_heli_hit_ground", ::fx_heli_hit_ground, "intro_opening_shot08" );

	level.scr_animtree[ "mi28" ]					 								= #animtree;
	level.scr_model[ "mi28" ]						 								= "vehicle_mi_28_destroyed";
	
	//---- REGROUP ----//
	level.scr_anim[ "cover_car" ][ "car_door_cover" ] 								= %intro_npc_use_car_door_cover_car;
	level.scr_animtree[ "cover_car" ]					 							= #animtree;
	level.scr_model[ "cover_car" ]						 							= "vehicle_80s_hatch1_brn";
	
	//---- BUILDING SLIDE ----//
	level.scr_anim[ "uav" ][ "roof_collapse_slide" ] 								= %intro_rooftop_collapse_uav;
	level.scr_anim[ "uav" ][ "ugv_death" ] 											= %ugv_robot_uav_death;
	level.scr_anim[ "uav" ][ "price_to_nikolai" ] 									= %intro_price_reload_uav;
	level.scr_animtree[ "uav" ]					 									= #animtree;
	level.scr_model[ "uav" ]						 								= "russian_dozor_600";
	
	level.scr_anim[ "ugv" ][ "ugv_death" ] 											= %ugv_robot_death;
	level.scr_anim[ "ugv" ][ "ugv_death_pos" ] 										= %ugv_robot_death_pos;
	level.scr_animtree[ "ugv" ]					 									= #animtree;
	level.scr_model[ "ugv" ]													 	= "vehicle_ugv_robot_viewmodel";
	
	level.scr_anim[ "ugv_turret" ][ "ugv_death" ] 									= %ugv_robot_turret_death;
	level.scr_anim[ "ugv_turret" ][ "ugv_death_pos" ] 								= %ugv_robot_turret_death_pos;
	level.scr_anim[ "ugv_turret" ][ "ugv_fire_grenade" ] 							= %ugv_robot_grenade_launcher_fire;
	level.scr_animtree[ "ugv_turret" ]					 							= #animtree;
	level.scr_model[ "ugv_turret" ]													= "ugv_robot_gun";
	
	level.scr_anim[ "ugv_grenade_launcher" ][ "ugv_death" ] 						= %ugv_robot_grenade_launcher_death;
	level.scr_animtree[ "ugv_grenade_launcher" ]		 							= #animtree;
	level.scr_model[ "ugv_grenade_launcher" ]										= "ugv_robot_grenade_launcher";
	
	level.scr_anim[ "destructible_car" ][ "price_break_and_rake" ] 					= %intro_price_break_and_rake_car;
	level.scr_animtree[ "destructible_car" ]					 					= #animtree;
	level.scr_model[ "destructible_car" ]						 					= "vehicle_80s_hatch1_brn_destructible_mp";
	
}

#using_animtree( "destructibles" );
destructibles()
{
	//level.scr_anim[ "destructible_car" ][ "price_break_and_rake" ] 						= %intro_price_break_and_rake_car;
	//level.scr_animtree[ "destructible_car" ]					 						= #animtree;
	//level.scr_model[ "destructible_car" ]						 						= "vehicle_80s_hatch1_brn_destructible";
}

fake_notetrack_events( guys, anim_scene )
{
}

maars_control_flashlight_on( guy )
{	
	PlayFxOnTag(getfx("flashlight"), level.flashlight, "TAG_LIGHT");
}

maars_control_flashlight_off( guy )
{
	// coming from a start point doesn't have flashlight for now
	if ( IsDefined( level.flashlight ) )
	{
		StopFxOnTag( getfx("flashlight"), level.flashlight, "TAG_LIGHT" );
	}
}

breach_hotel_door( ent )
{
	breach_door = GetEnt( "escort_hotel_door", "targetname" );
	breach_door RotateTo( breach_door.angles + ( 0, 160, 0 ), .5, 0, 0 );
	breach_door ConnectPaths();
	flag_set( "escort_hotel_door_open" );
}

drop_weapon( ent )
{
	ent.dropWeapon = true;
	ent animscripts\shared::DropAIWeapon();
}

kill_me( ent )
{
	ent maps\intro_utility::kill_no_react();
}

equip_main_weapon( ent )
{
	ent animscripts\shared::PlaceWeaponOn( ent.weapon, "right" );
}

start_heli_dust(guy)
{
	//play dust coming through lattice as heli approaches
	exploder(24);
	//turn off lightbeams
	wait 0.5;
	pauseExploder("intro_godray");
}

fx_blood_cough(guy)
{
	playfxontag(getfx("blood_cough"), guy, "J_Jaw");
}

start_slowmo( ent )
{
	slomoLerpTime_in = 0.3; //0.5;
	
	slowmo_start();
	
	slowmo_setspeed_slow( 0.3 );
	slowmo_setlerptime_in( slomoLerpTime_in );
	slowmo_lerp_in();
}

end_slowmo( ent )
{
	slomoLerpTime_out = 0.5;
	
	slowmo_setlerptime_out( slomoLerpTime_out );
	slowmo_lerp_out();
	slowmo_end();
}

start_building_slowmo( ent )
{
	slomoLerpTime_in = 0.5; //0.5;
	
	slowmo_start();
	
	slowmo_setspeed_slow( 0.8 );
	slowmo_setlerptime_in( slomoLerpTime_in );
	slowmo_lerp_in();
}

end_building_slowmo( ent )
{
	slomoLerpTime_out = 0.8;
	
	slowmo_setlerptime_out( slomoLerpTime_out );
	slowmo_lerp_out();
	slowmo_end();
}

start_intro_shot1_slowmo( ent )
{
	slomoLerpTime_in = 0.5; //0.5;
	
	slowmo_start();
	
	slowmo_setspeed_slow( .85 );
	slowmo_setlerptime_in( slomoLerpTime_in );
	slowmo_lerp_in();
}

end_intro_shot1_slowmo( ent )
{
	slomoLerpTime_out = 2;
	
	slowmo_setlerptime_out( slomoLerpTime_out );
	slowmo_lerp_out();
	slowmo_end();
}

start_intro_shot6_slowmo( ent )
{
	slomoLerpTime_in = 0.5; //0.5;
	
	slowmo_start();
	
	slowmo_setspeed_slow( 0.8 );
	slowmo_setlerptime_in( slomoLerpTime_in );
	slowmo_lerp_in();
}

end_intro_shot6_slowmo( ent )
{
	slomoLerpTime_out = 0.8;
	
	slowmo_setlerptime_out( slomoLerpTime_out );
	slowmo_lerp_out();
	slowmo_end();
}

start_intro_shot7_slowmo( ent )
{
	slomoLerpTime_in = .7; //0.5;
	
	slowmo_start();
	
	slowmo_setspeed_slow( 0.3 );
	slowmo_setlerptime_in( slomoLerpTime_in );
	slowmo_lerp_in();
}

end_intro_shot8_slowmo( ent )
{
	slomoLerpTime_out = 2;
	
	slowmo_setlerptime_out( slomoLerpTime_out );
	slowmo_lerp_out();
	slowmo_end();
}

break_glass( ent )
{
	// break the front right window
	ent.glass_damage_state[3].v[ "currentState" ] = 2;
	ent maps\intro_utility::update_glass( ent, 3, true );
}

fx_heli_hit_ground(guy)
{
	//play sparks fx when the heli hits the ground after sliding out of wall
	exploder(23);
}

fx_soap_stop_bleeding(guy)
{
	level notify("msg_soap_stop_bleeding");
}
