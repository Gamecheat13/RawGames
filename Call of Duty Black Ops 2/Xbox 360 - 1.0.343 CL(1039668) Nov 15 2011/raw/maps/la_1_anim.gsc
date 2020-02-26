#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_turret;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_scene.gsh;

main()
{
	add_scene( "intro_gunner", "intro_cougar3", false, false, true );
	add_actor_anim( "intro_gunner", %generic_human::ch_la_06_04_interception_guy01_loop, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, !SCENE_ALLOW_DEATH, "tag_gunner_turret2" );
	
	add_scene( "intro", "intro_cougar" );
	
	add_player_anim( "player_body",		%player::p_la_01_01_110_intro_player, SCENE_DELETE, PLAYER_1, "tag_body_animate_jnt", SCENE_DELTA, 1, 30, 30, 30, 30 );
	
	add_actor_anim( "hillary",			%generic_human::ch_la_01_01_110_intro_hill,		SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	SCENE_DELETE,	!SCENE_ALLOW_DEATH,	"tag_body_animate_jnt" );
	add_actor_anim( "bill",				%generic_human::ch_la_01_01_110_intro_bill,		SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	SCENE_DELETE,	!SCENE_ALLOW_DEATH, "tag_body_animate_jnt" );
	add_actor_anim( "harper",			%generic_human::ch_la_01_01_110_intro_harp,		SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	SCENE_DELETE,	!SCENE_ALLOW_DEATH, "tag_body_animate_jnt" );
	add_actor_anim( "secretary",		%generic_human::ch_la_01_01_110_intro_sec,		SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	SCENE_DELETE,	!SCENE_ALLOW_DEATH, "tag_body_animate_jnt" );
	add_actor_anim( "jones",			%generic_human::ch_la_01_01_110_intro_jones,	SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	SCENE_DELETE,	!SCENE_ALLOW_DEATH, "tag_body_animate_jnt" );
	add_actor_anim( "johnson",			%generic_human::ch_la_01_01_110_intro_johnson,	SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	SCENE_DELETE,	!SCENE_ALLOW_DEATH, "tag_body_animate_jnt" );
	add_actor_anim( "intro_driver", 	%generic_human::ch_la_01_01_110_intro_driver,	SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	SCENE_DELETE,	!SCENE_ALLOW_DEATH,	"tag_body_animate_jnt" );
	
	add_actor_anim( "chopper_guy1", 	%generic_human::ch_la_01_01_110_intro_troop1,	!SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON,	SCENE_DELETE,	!SCENE_ALLOW_DEATH,	"tag_origin" );
	add_actor_anim( "chopper_guy2", 	%generic_human::ch_la_01_01_110_intro_troop2,	!SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON,	SCENE_DELETE,	!SCENE_ALLOW_DEATH,	"tag_origin" );
	add_actor_anim( "chopper_guy3", 	%generic_human::ch_la_01_01_110_intro_troop3,	!SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON,	SCENE_DELETE,	!SCENE_ALLOW_DEATH,	"tag_origin" );
	
	add_actor_model_anim( "bike_guy1",	%generic_human::ch_la_01_01_110_intro_bikecop1,	undefined, SCENE_DELETE, "tag_origin" );
	add_actor_model_anim( "bike_guy2", 	%generic_human::ch_la_01_01_110_intro_bikecop2,	undefined, SCENE_DELETE, "tag_origin" );
	add_actor_model_anim( "bike_guy3", 	%generic_human::ch_la_01_01_110_intro_bikecop3,	undefined, SCENE_DELETE, "tag_origin" );
	
	add_vehicle_anim( "intro_cougar",	%vehicles::v_la_01_01_110_intro_cougar,		SCENE_DELETE, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG, !SCENE_ANIMATE_ORIGIN );
	
	add_vehicle_anim( "intro_drone1",	%vehicles::v_la_01_01_110_intro_drone1,		SCENE_DELETE, SCENE_NO_HIDE_PARTS, "tag_origin", SCENE_ANIMATE_ORIGIN, "drone_avenger", "veh_t6_drone_avenger" );
	add_vehicle_anim( "intro_drone2",	%vehicles::v_la_01_01_110_intro_drone2,		SCENE_DELETE, SCENE_NO_HIDE_PARTS, "tag_origin", SCENE_ANIMATE_ORIGIN, "drone_avenger", "veh_t6_drone_avenger" );
	add_vehicle_anim( "intro_drone3",	%vehicles::v_la_01_01_110_intro_drone3,		SCENE_DELETE, SCENE_NO_HIDE_PARTS, "tag_origin", SCENE_ANIMATE_ORIGIN, "drone_avenger", "veh_t6_drone_avenger" );
	add_vehicle_anim( "intro_drone4",	%vehicles::v_la_01_01_110_intro_drone4,		SCENE_DELETE, SCENE_NO_HIDE_PARTS, "tag_origin", SCENE_ANIMATE_ORIGIN, "drone_avenger", "veh_t6_drone_avenger" );
		
	add_vehicle_anim( "intro_cougar2",	%vehicles::v_la_01_01_110_intro_cougar2,	SCENE_DELETE, SCENE_NO_HIDE_PARTS, "tag_origin", SCENE_ANIMATE_ORIGIN, "apc_cougar_sam_turret_nophysics", "veh_t6_mil_cougar" );
	add_vehicle_anim( "intro_cougar3",	%vehicles::v_la_01_01_110_intro_cougar3,	SCENE_DELETE, SCENE_NO_HIDE_PARTS, "tag_origin", SCENE_ANIMATE_ORIGIN, "apc_cougar_sam_turret_nophysics", "veh_t6_mil_cougar" );
	add_vehicle_anim( "intro_cougar4",	%vehicles::v_la_01_01_110_intro_cougar4,	SCENE_DELETE, SCENE_NO_HIDE_PARTS, "tag_origin", SCENE_ANIMATE_ORIGIN, "apc_cougar_sam_turret_nophysics", "veh_t6_mil_cougar" );
	
	add_prop_anim( "intro_blackhawk",	%animated_props::v_la_01_01_110_intro_blkhwk, "veh_t6_air_blackhawk_stealth_dead", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	add_prop_anim( "intro_blackhawk2",	%animated_props::v_la_01_01_110_intro_blkhwk2, "veh_t6_air_blackhawk_stealth_dead", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	add_prop_anim( "intro_blackhawk3",	%animated_props::v_la_01_01_110_intro_blkhwk3, "veh_t6_air_blackhawk_stealth_dead", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	add_prop_anim( "intro_blackhawk4",	%animated_props::v_la_01_01_110_intro_blkhwk4, "veh_t6_air_blackhawk_stealth_dead", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	
	add_prop_anim( "intro_bike1",		%animated_props::v_la_01_01_110_intro_bike1, "veh_t6_civ_police_motorcycle", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	add_prop_anim( "intro_bike2",		%animated_props::v_la_01_01_110_intro_bike2, "veh_t6_civ_police_motorcycle", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	add_prop_anim( "intro_bike3",		%animated_props::v_la_01_01_110_intro_bike3, "veh_t6_civ_police_motorcycle", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	add_prop_anim( "intro_bike4",		%animated_props::v_la_01_01_110_intro_bike4, "veh_t6_civ_police_motorcycle", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	
	add_prop_anim( "intro_copcar1",		%animated_props::v_la_01_01_110_intro_copcar1, "veh_iw_civ_policecar_radiant", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	add_prop_anim( "intro_copcar2",		%animated_props::v_la_01_01_110_intro_copcar2, "veh_iw_civ_policecar_radiant", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	add_prop_anim( "intro_copcar3",		%animated_props::v_la_01_01_110_intro_copcar3, "veh_iw_civ_policecar_radiant", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	add_prop_anim( "intro_copcar4",		%animated_props::v_la_01_01_110_intro_copcar4, "veh_iw_civ_policecar_radiant", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	add_prop_anim( "intro_copcar5",		%animated_props::v_la_01_01_110_intro_copcar5, "veh_iw_civ_policecar_radiant", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	
	add_prop_anim( "intro_missile_target1",			%animated_props::o_la_01_01_110_intro_missletarget1,	"tag_origin_animate", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	add_prop_anim( "intro_missile_target2",			%animated_props::o_la_01_01_110_intro_missletarget2,	"tag_origin_animate", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	add_prop_anim( "intro_missile_target3",			%animated_props::o_la_01_01_110_intro_missletarget3,	"tag_origin_animate", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	add_prop_anim( "intro_missile_target4",			%animated_props::o_la_01_01_110_intro_missletarget4,	"tag_origin_animate", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	
	add_notetrack_custom_function( "player_body", "warp", maps\la_intro::warp );
	add_notetrack_custom_function( "player_body", "fade_out", maps\la_intro::fade_out );
	
	add_notetrack_custom_function( "player_body", "slowmo_start", maps\la_intro::slowmo_start );
	add_notetrack_custom_function( "player_body", "slowmo_end", maps\la_intro::slowmo_end );
	
	add_notetrack_custom_function( "player_body", "slowmo_med_start", maps\la_intro::slowmo_med_start );
	add_notetrack_custom_function( "player_body", "slowmo_med_end", maps\la_intro::slowmo_med_end );
	
	add_notetrack_custom_function( "intro_blackhawk", "explosion", maps\la_intro::blackhawk_explosion );
	
	add_notetrack_custom_function( "intro_cougar3", "start_aiming", maps\la_intro::cougar3_aim );
		
	add_notetrack_fx_on_tag( "intro_blackhawk", "hit_ground", "blackhawk_hit_ground", "tag_origin" );
		
	add_scene( "intro_reflection", "cougar_reflection_scene" );
	add_actor_anim( "mason_reflection",			%generic_human::ch_la_01_01_110_intro_mason,	true, true, SCENE_DELETE, true, "tag_body_animate_jnt" );
	add_actor_anim( "hillary_reflection",		%generic_human::ch_la_01_01_110_intro_hill,		true, true, SCENE_DELETE, true, "tag_body_animate_jnt" );
	add_actor_anim( "bill_reflection",			%generic_human::ch_la_01_01_110_intro_bill,		true, true, SCENE_DELETE, true, "tag_body_animate_jnt" );
	add_actor_anim( "harper_reflection",		%generic_human::ch_la_01_01_110_intro_harp,		true, true, SCENE_DELETE, true, "tag_body_animate_jnt" );
	add_actor_anim( "secretary_reflection",		%generic_human::ch_la_01_01_110_intro_sec,		true, true, SCENE_DELETE, true, "tag_body_animate_jnt" );
	add_actor_anim( "jones_reflection",			%generic_human::ch_la_01_01_110_intro_jones,	true, true, SCENE_DELETE, true, "tag_body_animate_jnt" );
	add_actor_anim( "johnson_reflection",		%generic_human::ch_la_01_01_110_intro_johnson,	true, true, SCENE_DELETE, true, "tag_body_animate_jnt" );
	add_actor_anim( "intro_driver_reflection", 	%generic_human::ch_la_01_01_110_intro_driver,	true, true, SCENE_DELETE, false, "tag_body_animate_jnt" );
	
//	add_scene( "intro_cougar", "intro_cougar", false, false, false, true );
//	add_vehicle_anim( "intro_cougar",	%vehicles::v_la_01_01_110_intro_cougar, true );
	
	add_scene( "cougar_crawl_player", "align_cougar_crawl" );
	add_player_anim( "player_body", %player::ch_la_03_01_cougarcrawl_player, true, 0, undefined, true, 1, 30, 30, 30, 30 );
	
	add_scene( "cougar_crawl", "align_cougar_crawl" );
	add_actor_anim( "hillary",			%generic_human::ch_la_03_01_cougarcrawl_hilary,		SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	!SCENE_DELETE,	!SCENE_ALLOW_DEATH );
	add_actor_anim( "bill",				%generic_human::ch_la_03_01_cougarcrawl_bill,		SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	!SCENE_DELETE,	!SCENE_ALLOW_DEATH );
	add_actor_anim( "harper",			%generic_human::ch_la_03_01_cougarcrawl_jack, 		!SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	!SCENE_DELETE,	!SCENE_ALLOW_DEATH );
	add_actor_anim( "intro_driver",		%generic_human::ch_la_03_01_cougarcrawl_redshirt, 	!SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	!SCENE_DELETE,	!SCENE_ALLOW_DEATH  );
	add_actor_anim( "ss1",				%generic_human::ch_la_03_01_cougarcrawl_ss01, 		!SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	!SCENE_DELETE,	!SCENE_ALLOW_DEATH  );
	add_actor_anim( "jones",			%generic_human::ch_la_03_01_cougarcrawl_ss02, 		!SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	!SCENE_DELETE,	!SCENE_ALLOW_DEATH  );
	add_actor_anim( "johnson",			%generic_human::ch_la_03_01_cougarcrawl_ss03, 		!SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	!SCENE_DELETE,	!SCENE_ALLOW_DEATH  );
	add_prop_anim( "cougar_destroyed",	%animated_props::v_la_03_01_cougarcrawl_cougar, "veh_t6_mil_cougar_destroyed" );
		
	add_scene( "cougar_crawl_dead_loop", "align_cougar_crawl", false, false, true );
	add_actor_anim( "secretary", %generic_human::ch_la_03_01_cougarcrawl_secretary,	true );

	add_scene( "sam_cougar_align", "align_cougar_crawl" );
	add_vehicle_anim( "sam_cougar", %vehicles::v_la_03_02_mountturret_cougar_loop );
	
	add_scene( "sam_cougar_mount", "align_cougar_crawl" );
	add_vehicle_anim( "sam_cougar", %vehicles::v_la_03_02_mountturret_cougar );
	add_player_anim( "player_body", %player::ch_la_03_02_mountturret_player, true );
	add_notetrack_custom_function( "player_body", "dof1", maps\createart\la_1_art::mount_turret_dof1 );
	add_notetrack_custom_function( "player_body", "dof2", maps\createart\la_1_art::mount_turret_dof2 );
	add_notetrack_custom_function( "player_body", "dof3", maps\createart\la_1_art::mount_turret_dof3 );
	add_notetrack_custom_function( "player_body", "dof4", maps\createart\la_1_art::mount_turret_dof4 );
	add_notetrack_custom_function( "player_body", "dof5", maps\createart\la_1_art::mount_turret_dof5 );
	
	add_scene( "close_call_drone", "align_cougar_crawl" );
	add_vehicle_anim( "cougar_crawl_drone",	%vehicles::v_la_03_04_cougarfalls_f35intro_drone, !SCENE_DELETE );
	
	add_scene( "sam_cougar_fall", "align_cougar_crawl" );
	
	add_player_anim( "player_body",		%player::ch_la_03_04_cougarfalls_f35intro_player, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, 1, 30, 30, 30, 30 );
	add_notetrack_custom_function( "player_body", "dof1", maps\createart\la_1_art::cougar_fall_dof1 );
	add_notetrack_custom_function( "player_body", "dof2", maps\createart\la_1_art::cougar_fall_dof2 );
	add_notetrack_custom_function( "player_body", "dof3", maps\createart\la_1_art::cougar_fall_dof3 );
	add_notetrack_custom_function( "player_body", "dof4", maps\createart\la_1_art::cougar_fall_dof4 );
	
	add_vehicle_anim( "sam_cougar",	%vehicles::v_la_03_04_cougarfalls_f35intro_cougar );
	add_vehicle_anim( "f35_vtol", 	%vehicles::v_la_03_04_cougarfalls_f35intro_f35, SCENE_DELETE, "tag_gear" );
	
	add_actor_anim( "anderson", %generic_human::ch_la_03_04_cougarfalls_f35intro_anderson,	SCENE_HIDE_WEAPON, false, true );
	add_actor_anim( "bill", 	%generic_human::ch_la_03_04_cougarfalls_f35intro_bill,		SCENE_HIDE_WEAPON, false, true );
	add_actor_anim( "hillary", 	%generic_human::ch_la_03_04_cougarfalls_f35intro_hillary,	SCENE_HIDE_WEAPON, false, true );
	add_actor_anim( "harper", 	%generic_human::ch_la_03_04_cougarfalls_f35intro_harper,	!SCENE_HIDE_WEAPON, false, true );
	add_actor_anim( "jones", 	%generic_human::ch_la_03_04_cougarfalls_f35intro_ssa,		!SCENE_HIDE_WEAPON, false, true );
	
	add_prop_anim( "highway_rubble_1", %animated_props::o_la_03_04_cougarfalls_f35intro_debris01, undefined, false, true );
	add_prop_anim( "highway_rubble_2", %animated_props::o_la_03_04_cougarfalls_f35intro_debris02, undefined, false, true );
	
	add_scene( "sam_cougar_fall_vehilces", "align_cougar_crawl" );
	add_vehicle_anim( "cougarfalls_f35intro_car01", %vehicles::v_la_03_04_cougarfalls_f35intro_car01, false );
	add_vehicle_anim( "cougarfalls_f35intro_car02", %vehicles::v_la_03_04_cougarfalls_f35intro_car02, false );
	add_vehicle_anim( "cougarfalls_f35intro_van", %vehicles::v_la_03_04_cougarfalls_f35intro_van, false );
	
	add_scene( "squad_rappel_approach", "align_rappel" );
	add_actor_anim( "hillary",	%generic_human::ch_3_8_groupcover_approach_hilary,	SCENE_HIDE_WEAPON );
	add_actor_anim( "bill",		%generic_human::ch_3_8_groupcover_approach_bill,	SCENE_HIDE_WEAPON );
	add_actor_anim( "jones",	%generic_human::ch_3_8_groupcover_approach_ss02,	!SCENE_HIDE_WEAPON );
	add_actor_anim( "harper",	%generic_human::ch_3_8_groupcover_approach_jack,	!SCENE_HIDE_WEAPON );
	add_actor_anim( "ss1",		%generic_human::ch_3_8_groupcover_approach_ss01, 	!SCENE_HIDE_WEAPON );
	
	add_scene( "squad_rappel_cover", "align_rappel", false, false, true );
	add_actor_anim( "hillary",	%generic_human::ch_3_8_groupcover_hilary,	SCENE_HIDE_WEAPON );
	add_actor_anim( "bill",		%generic_human::ch_3_8_groupcover_bill,		SCENE_HIDE_WEAPON );
	add_actor_anim( "jones",	%generic_human::ch_3_8_groupcover_ss02,		!SCENE_HIDE_WEAPON );
	add_actor_anim( "harper",	%generic_human::ch_3_8_groupcover_jack,		!SCENE_HIDE_WEAPON );
	add_actor_anim( "ss1",		%generic_human::ch_3_8_groupcover_ss01,		!SCENE_HIDE_WEAPON );
	
	add_scene( "player_rappel", "align_rappel" );	
	add_player_anim( "player_body",		%player::ch_3_10_grouprappel_player, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, 1, 15, 15, 15, 15 );
	
	add_scene( "squad_rappel", "align_rappel" );
	add_actor_anim( "hillary",	%generic_human::ch_3_10_grouprappel_hilary,	SCENE_HIDE_WEAPON );
	add_actor_anim( "bill",		%generic_human::ch_3_10_grouprappel_bill,	SCENE_HIDE_WEAPON );
	add_actor_anim( "jones",	%generic_human::ch_3_10_grouprappel_ss02,	!SCENE_HIDE_WEAPON );
	add_actor_anim( "harper",	%generic_human::ch_3_10_grouprappel_jack,	!SCENE_HIDE_WEAPON );
	add_actor_anim( "ss1",		%generic_human::ch_3_10_grouprappel_ss01,	!SCENE_HIDE_WEAPON );
	
	add_prop_anim( "rope_jack",		%animated_props::o_3_10_grouprappel_jack_rope,		"iw_prague_rope_rappel_building" );
	add_prop_anim( "rope_bill",		%animated_props::o_3_10_grouprappel_bill_rope, 		"iw_prague_rope_rappel_building" );
	add_prop_anim( "rope_hilary",	%animated_props::o_3_10_grouprappel_hilary_rope,	"iw_prague_rope_rappel_building" );
	
	add_scene( "terrorist_rappel", "enemy_repel_struct" );
	add_actor_anim( "terrorist_rappel1",	%generic_human::ch_la_03_08_ai_rappel_guy01 );
	add_actor_anim( "terrorist_rappel2",	%generic_human::ch_la_03_08_ai_rappel_guy02 );
	add_actor_anim( "terrorist_rappel3",	%generic_human::ch_la_03_08_ai_rappel_guy03 );
	add_actor_anim( "terrorist_rappel4",	%generic_human::ch_la_03_08_ai_rappel_guy04 );
	
	add_scene( "player_fast_rope", "align_rappel" );
	add_player_anim( "player_body", %player::ch_3_9_exitsniper_player, true );
		
	add_scene( "freeway_bigrig_entry", "align_ground_battle" );
	add_actor_anim( "freeway_bigrig_entry_guy1",	%generic_human::ch_la_03_09_bigrig_entries_guy01 );
	add_actor_anim( "freeway_bigrig_entry_guy2",	%generic_human::ch_la_03_09_bigrig_entries_guy02 );
	add_actor_anim( "freeway_bigrig_entry_guy3",	%generic_human::ch_la_03_09_bigrig_entries_guy03 );
	add_actor_anim( "freeway_bigrig_entry_guy4",	%generic_human::ch_la_03_09_bigrig_entries_guy04 );
	
	add_scene( "low_road_enemy_group1_loop", "align_rappel", false, false, true );
	add_actor_anim( "low_road_enemy1",	%generic_human::ch_la_3_9_enemyreact_loop_guy01 );
	add_actor_anim( "low_road_enemy2",	%generic_human::ch_la_3_9_enemyreact_loop_guy02 );
	add_actor_anim( "low_road_enemy3",	%generic_human::ch_la_3_9_enemyreact_loop_guy03 );
	add_actor_anim( "low_road_enemy4",	%generic_human::ch_la_3_9_enemyreact_loop_guy03 );
	
	add_scene( "low_road_enemy_group1_react", "align_rappel" );
	add_actor_anim( "low_road_enemy1",	%generic_human::ch_la_3_9_enemyreact_guy01 );
	add_actor_anim( "low_road_enemy2",	%generic_human::ch_la_3_9_enemyreact_guy02 );
	add_actor_anim( "low_road_enemy3",	%generic_human::ch_la_3_9_enemyreact_guy03 );
	add_actor_anim( "low_road_enemy4",	%generic_human::ch_la_3_9_enemyreact_guy04 );
	
	add_scene( "jack_low_road_van", "align_rappel" );
	add_actor_anim( "harper",	%generic_human::ch_la_3_11_streetfight_jack2van );
	
	add_scene( "group_cover_go1", "align_rappel" );
	add_actor_anim( "bill",		%generic_human::ch_la_3_11_streetfight_run2cover01_bill,	SCENE_HIDE_WEAPON );
	add_actor_anim( "hillary",	%generic_human::ch_la_3_11_streetfight_run2cover01_hilary,	SCENE_HIDE_WEAPON );
	add_actor_anim( "jones",	%generic_human::ch_la_3_11_streetfight_run2cover01_ss02,	!SCENE_HIDE_WEAPON );
	
	add_scene( "group_cover_idle1", "align_rappel", false, false, true );
	add_actor_anim( "bill",		%generic_human::ch_la_3_11_streetfight_run2cover01_wait_bill,	SCENE_HIDE_WEAPON );
	add_actor_anim( "hillary",	%generic_human::ch_la_3_11_streetfight_run2cover01_wait_hilary,	SCENE_HIDE_WEAPON );
	add_actor_anim( "jones",	%generic_human::ch_la_3_11_streetfight_run2cover01_wait_ss02,	!SCENE_HIDE_WEAPON );
			
	add_scene( "group_cover_go2", "align_rappel" );
	add_actor_anim( "bill",		%generic_human::ch_la_3_11_streetfight_run2cover02_bill,	SCENE_HIDE_WEAPON );
	add_actor_anim( "hillary",	%generic_human::ch_la_3_11_streetfight_run2cover02_hilary,	SCENE_HIDE_WEAPON );
	add_actor_anim( "jones",	%generic_human::ch_la_3_11_streetfight_run2cover02_ss02,	!SCENE_HIDE_WEAPON );
	
	add_scene( "group_cover_idle2", "align_rappel", false, false, true );
	add_actor_anim( "bill",		%generic_human::ch_la_3_11_streetfight_run2cover02_wait_bill,	SCENE_HIDE_WEAPON );
	add_actor_anim( "hillary",	%generic_human::ch_la_3_11_streetfight_run2cover02_wait_hilary,	SCENE_HIDE_WEAPON );
	add_actor_anim( "jones",	%generic_human::ch_la_3_11_streetfight_run2cover02_wait_ss02,	!SCENE_HIDE_WEAPON );
	
	add_scene( "group_cover_go3", "align_rappel" );
	add_actor_anim( "bill",		%generic_human::ch_la_3_11_streetfight_run2cover03_bill,	SCENE_HIDE_WEAPON );
	add_actor_anim( "hillary",	%generic_human::ch_la_3_11_streetfight_run2cover03_hilary,	SCENE_HIDE_WEAPON );
	add_actor_anim( "jones",	%generic_human::ch_la_3_11_streetfight_run2cover03_ss02,	!SCENE_HIDE_WEAPON );
	
	add_scene( "group_cover_idle3", "align_rappel", false, false, true );
	add_actor_anim( "bill",		%generic_human::ch_la_3_11_streetfight_run2cover03_wait_bill,	SCENE_HIDE_WEAPON );
	add_actor_anim( "hillary",	%generic_human::ch_la_3_11_streetfight_run2cover03_wait_hilary,	SCENE_HIDE_WEAPON );
	add_actor_anim( "jones",	%generic_human::ch_la_3_11_streetfight_run2cover03_wait_ss02,	!SCENE_HIDE_WEAPON );
		
	add_scene( "group_to_convoy", "align_rappel" );
	add_actor_anim( "bill",		%generic_human::ch_la_3_11_streetfight_run2convoy_bill,		SCENE_HIDE_WEAPON );
	add_actor_anim( "hillary",	%generic_human::ch_la_3_11_streetfight_run2convoy_hilary,	SCENE_HIDE_WEAPON );
	add_actor_anim( "jones",	%generic_human::ch_la_3_11_streetfight_run2convoy_ss02,		!SCENE_HIDE_WEAPON );
	
	add_scene( "group_convoy_loop", "align_rappel", false, false, true );
	add_actor_anim( "bill",		%generic_human::ch_la_3_11_streetfight_run2convoy_loop_bill,	SCENE_HIDE_WEAPON );
	add_actor_anim( "hillary",	%generic_human::ch_la_3_11_streetfight_run2convoy_loop_hilary,	SCENE_HIDE_WEAPON );
	add_actor_anim( "jones",	%generic_human::ch_la_3_11_streetfight_run2convoy_loop_ss02,	!SCENE_HIDE_WEAPON );
		
	add_scene( "g20_group1_greet", "g20_group1_cougar" );
	add_actor_anim( "g20_group1_ss1",	%generic_human::ch_la_03_12_meetconvoy_ss04 );
	
	add_scene( "g20_group1_greet_harper", "g20_group1_cougar" );
	add_actor_anim( "harper",			%generic_human::ch_la_03_12_meetconvoy_mike );
	
	add_scene( "harper_wait_in_cougar", "g20_group1_cougar", false, false, true );
	add_actor_anim( "harper",			%generic_human::ch_la_03_12_meetconvoy_mike_loop );
		
	add_scene( "enter_cougar", "g20_group1_cougar" );
	add_player_anim( "player_body", %player::ch_la_03_12_entercougar_player, true );
	
	add_scene( "skyline", "anim_align_offramp_intersection" );
	add_vehicle_anim( "f35_vtol", %vehicles::v_la_04_02_dronebattle_f35, !SCENE_DELETE, "tag_gear" );
	add_vehicle_anim( "skyline_drone", %vehicles::v_la_04_02_dronebattle_drone, true );
	
	add_scene( "cougar_crash", "g20_group1_cougar" );
	add_actor_anim( "harper", %generic_human::ch_la_04_04_crash_harper,	SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, !SCENE_ALLOW_DEATH, "tag_passenger" );
	add_notetrack_custom_function( "harper", "crash", maps\la_drive::crash );
		
	fxanim_test();
	
	precache_assets();
	maps\voice\voice_la_1::init_voice();
}

#using_animtree( "animated_props" );
fxanim_test()
{
	level.scr_animtree[ "fxanim_ambient_drone_1" ] = #animtree;
	level.scr_model[ "fxanim_ambient_drone_1" ] = "veh_t6_drone_avenger";
	level.scr_anim[ "fxanim_ambient_drone_1" ][ "drone_ambient_1" ][ 0 ] =  %animated_props::fxanim_la_drone_ambient_01_anim;
	level.scr_anim[ "fxanim_ambient_drone_1" ][ "drone_ambient_2" ][ 0 ] =  %animated_props::fxanim_la_drone_ambient_02_anim;
	
	level.scr_animtree[ "fxanim_ambient_drone_2" ] = #animtree;
	level.scr_model[ "fxanim_ambient_drone_2" ] = "veh_t6_drone_pegasus";
	level.scr_anim[ "fxanim_ambient_drone_2" ][ "drone_ambient_1" ][ 0 ] =  %animated_props::fxanim_la_drone_ambient_01_anim;
	level.scr_anim[ "fxanim_ambient_drone_2" ][ "drone_ambient_2" ][ 0 ] =  %animated_props::fxanim_la_drone_ambient_02_anim;
	
	level.scr_animtree[ "fxanim_ambient_f35" ] = #animtree;
	level.scr_model[ "fxanim_ambient_f35" ] = "veh_t6_air_f35";
	level.scr_anim[ "fxanim_ambient_f35" ][ "f35_ambient_1" ][ 0 ] =  %animated_props::fxanim_la_drone_ambient_01_anim;
	level.scr_anim[ "fxanim_ambient_f35" ][ "f35_ambient_2" ][ 0 ] =  %animated_props::fxanim_la_drone_ambient_02_anim;
}