#include maps\_utility;
#include common_scripts\utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_turret;
#include maps\_vehicle;
#include maps\la_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_scene.gsh;

main()
{
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	/// Intro
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	add_scene( "intro_gunner", "intro_cougar3", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "intro_gunner", %generic_human::ch_la_06_04_interception_guy01_loop, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, !SCENE_ALLOW_DEATH, "tag_gunner_turret2" );
	//add_actor_model_anim( "intro_gunner", %generic_human::ch_la_06_04_interception_guy01_loop, undefined, SCENE_DELETE, "tag_body_animate_jnt" );
	
	add_scene( "intro_fxanim_loop", "intro_cougar", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_prop_anim( "intro_fxanims",	%animated_props::fxanim_la_cougar_interior_anim, "fxanim_la_cougar_interior_mod", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_body_animate_jnt" );
	
	add_scene( "intro_player", "intro_cougar" );
	add_player_anim( "player_body",		%player::p_la_01_01_110_intro_player, SCENE_DELETE, PLAYER_1, "tag_body_animate_jnt", SCENE_DELTA, 1, 30, 30, 30, 30 );
	add_notetrack_custom_function( "player_body", "data_glove_on", ::data_glove_on );
	add_notetrack_custom_function( "player_body", "dof1", maps\createart\la_1_art::intro_player_dof1 );
	add_notetrack_custom_function( "player_body", "dof2", maps\createart\la_1_art::intro_player_dof2 );
	add_notetrack_custom_function( "player_body", "dof3", maps\createart\la_1_art::intro_player_dof3 );
	add_notetrack_custom_function( "player_body", "dof4", maps\createart\la_1_art::intro_player_dof4 );
	add_notetrack_custom_function( "player_body", "dof5", maps\createart\la_1_art::intro_player_dof5 );
	add_notetrack_custom_function( "player_body", "dof6", maps\createart\la_1_art::intro_player_dof6 );
	add_notetrack_custom_function( "player_body", "dof7", maps\createart\la_1_art::intro_player_dof7 );
	add_notetrack_custom_function( "player_body", "dof8", maps\createart\la_1_art::intro_player_dof8 );
	add_notetrack_custom_function( "player_body", "dof9", maps\createart\la_1_art::intro_player_dof9 );
	add_notetrack_custom_function( "player_body", "dof10", maps\createart\la_1_art::intro_player_dof10 );
	add_notetrack_custom_function( "player_body", "dof11", maps\createart\la_1_art::intro_player_dof11 );
	add_notetrack_custom_function( "player_body", "dof12", maps\createart\la_1_art::intro_player_dof12 );
	add_notetrack_custom_function( "player_body", "dof13", maps\createart\la_1_art::intro_player_dof13 );
	add_notetrack_custom_function( "player_body", "dof14", maps\createart\la_1_art::intro_player_dof14 );
	add_notetrack_custom_function( "player_body", "dof15", maps\createart\la_1_art::intro_player_dof15 );
	add_notetrack_custom_function( "player_body", "chopper_focus", maps\la_intro::set_chopper_dof );
	add_notetrack_custom_function( "player_body", "fade_in", maps\la_intro::fade_in );
	add_notetrack_custom_function( "player_body", "shellshock", maps\la_intro::intro_shellshock );
	
	add_notetrack_custom_function( "player_body", "warp", maps\la_intro::warp );
	add_notetrack_custom_function( "player_body", "fade_out", maps\la_intro::fade_out );
	add_notetrack_custom_function( "player_body", "slowmo_start", maps\la_intro::slowmo_start );
	add_notetrack_custom_function( "player_body", "slowmo_end", maps\la_intro::slowmo_end );
	add_notetrack_custom_function( "player_body", "slowmo_med_start", maps\la_intro::slowmo_med_start );
	add_notetrack_custom_function( "player_body", "slowmo_med_end", maps\la_intro::slowmo_med_end );
	
	add_scene( "intro_player_noharper", "intro_cougar" );
	add_player_anim( "player_body",		%player::p_la_01_01_110_intro_harperdead_player, SCENE_DELETE, PLAYER_1, "tag_body_animate_jnt", SCENE_DELTA, 1, 30, 30, 30, 30 );
	add_notetrack_custom_function( "player_body", "data_glove_on", ::data_glove_on );
	add_notetrack_custom_function( "player_body", "dof1", maps\createart\la_1_art::intro_player_dof1 );
	add_notetrack_custom_function( "player_body", "dof2", maps\createart\la_1_art::intro_player_dof2 );
	add_notetrack_custom_function( "player_body", "dof3", maps\createart\la_1_art::intro_player_dof3 );
	add_notetrack_custom_function( "player_body", "dof4", maps\createart\la_1_art::intro_player_dof4 );
	add_notetrack_custom_function( "player_body", "dof5", maps\createart\la_1_art::intro_player_dof5 );
	add_notetrack_custom_function( "player_body", "dof6", maps\createart\la_1_art::intro_player_dof6 );
	add_notetrack_custom_function( "player_body", "dof7", maps\createart\la_1_art::intro_player_dof7 );
	add_notetrack_custom_function( "player_body", "dof8", maps\createart\la_1_art::intro_player_dof8 );
	add_notetrack_custom_function( "player_body", "dof9", maps\createart\la_1_art::intro_player_dof9 );
	add_notetrack_custom_function( "player_body", "dof10", maps\createart\la_1_art::intro_player_dof10 );
	add_notetrack_custom_function( "player_body", "dof11", maps\createart\la_1_art::intro_player_dof11 );
	add_notetrack_custom_function( "player_body", "dof12", maps\createart\la_1_art::intro_player_dof12 );
	add_notetrack_custom_function( "player_body", "dof13", maps\createart\la_1_art::intro_player_dof13 );
	add_notetrack_custom_function( "player_body", "dof14", maps\createart\la_1_art::intro_player_dof14 );
	add_notetrack_custom_function( "player_body", "dof15", maps\createart\la_1_art::intro_player_dof15 );
	add_notetrack_custom_function( "player_body", "chopper_focus", maps\la_intro::set_chopper_dof );
	add_notetrack_custom_function( "player_body", "fade_in", maps\la_intro::fade_in );
	add_notetrack_custom_function( "player_body", "shellshock", maps\la_intro::intro_shellshock );	
	add_notetrack_attach( "player_body", "syringe_attach", "adrenaline_syringe_small_animated", "tag_weapon_left" );
	add_notetrack_detach( "player_body", "syringe_detach", "adrenaline_syringe_small_animated", "tag_weapon_left" );		
	
	add_notetrack_custom_function( "player_body", "warp", maps\la_intro::warp );
	add_notetrack_custom_function( "player_body", "fade_out", maps\la_intro::fade_out );
	add_notetrack_custom_function( "player_body", "slowmo_start", maps\la_intro::slowmo_start );
	add_notetrack_custom_function( "player_body", "slowmo_end", maps\la_intro::slowmo_end );
	add_notetrack_custom_function( "player_body", "slowmo_med_start", maps\la_intro::slowmo_med_start );
	add_notetrack_custom_function( "player_body", "slowmo_med_end", maps\la_intro::slowmo_med_end );
	
	add_scene( "intro", "intro_cougar" );
	add_actor_model_anim( "hillary",		%generic_human::ch_la_01_01_110_intro_hill,		undefined, SCENE_DELETE, "tag_body_animate_jnt" );
	add_actor_model_anim( "sam",			%generic_human::ch_la_01_01_110_intro_bill,		undefined, SCENE_DELETE, "tag_body_animate_jnt" );
	add_actor_model_anim( "secretary",		%generic_human::ch_la_01_01_110_intro_sec,		undefined, SCENE_DELETE, "tag_body_animate_jnt" );
	add_actor_model_anim( "jones",			%generic_human::ch_la_01_01_110_intro_jones,	undefined, SCENE_DELETE, "tag_body_animate_jnt" );
	add_actor_model_anim( "johnson",		%generic_human::ch_la_01_01_110_intro_johnson,	undefined, SCENE_DELETE, "tag_body_animate_jnt" );
	add_actor_model_anim( "intro_driver",	%generic_human::ch_la_01_01_110_intro_driver,	undefined, SCENE_DELETE, "tag_body_animate_jnt" );
	
	add_notetrack_custom_function( "secretary", "blood_spit", maps\la_intro::sec_spit_and_drool );
	
	add_prop_anim( "intro_gun", %animated_props::o_la_01_01_110_intro_gun, "t6_wpn_pistol_kard_prop_view", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_body_animate_jnt" );
	
	add_prop_anim( "intro_phone1",			%animated_props::o_la_01_01_110_intro_phone1,	"p6_anim_cell_phone", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_body_animate_jnt" );
	add_prop_anim( "intro_phone2",			%animated_props::o_la_01_01_110_intro_phone2,	"p6_anim_cell_phone", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_body_animate_jnt" );
	
	add_notetrack_fx_on_tag( "intro_phone1", undefined, "cellphone_glow", "tag_animate" );
	add_notetrack_fx_on_tag( "intro_phone2", undefined, "cellphone_glow", "tag_animate" );
		
	add_actor_anim( "chopper_guy1", 	%generic_human::ch_la_01_01_110_intro_troop1,	!SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON,	SCENE_DELETE,	!SCENE_ALLOW_DEATH,	"tag_origin" );
	add_actor_anim( "chopper_guy2", 	%generic_human::ch_la_01_01_110_intro_troop2,	!SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON,	SCENE_DELETE,	!SCENE_ALLOW_DEATH,	"tag_origin" );
	add_actor_anim( "chopper_guy3", 	%generic_human::ch_la_01_01_110_intro_troop3,	!SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON,	SCENE_DELETE,	!SCENE_ALLOW_DEATH,	"tag_origin" );
	
	add_notetrack_fx_on_tag( "chopper_guy2", "onfire", "torso_fire", "J_SpineUpper" );
	
	add_actor_model_anim( "bike_guy1",	%generic_human::ch_la_01_01_110_intro_bikecop1,	undefined, SCENE_DELETE, "tag_origin" );
	add_actor_model_anim( "bike_guy2", 	%generic_human::ch_la_01_01_110_intro_bikecop2,	undefined, SCENE_DELETE, "tag_origin" );
	add_actor_model_anim( "bike_guy3", 	%generic_human::ch_la_01_01_110_intro_bikecop3,	undefined, SCENE_DELETE, "tag_origin" );
	add_actor_model_anim( "bike_guy4", 	%generic_human::ch_la_01_01_110_intro_bikecop4,	undefined, SCENE_DELETE, "tag_origin" );
	add_actor_model_anim( "bike_guy5", 	%generic_human::ch_la_01_01_110_intro_bikecop5,	undefined, SCENE_DELETE, "tag_origin" );
	
	add_actor_anim( "cop_guy1", %generic_human::ch_la_01_01_110_intro_carcop1, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON,	SCENE_DELETE, !SCENE_ALLOW_DEATH, "tag_origin" );
	add_actor_anim( "cop_guy5", %generic_human::ch_la_01_01_110_intro_carcop5, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON,	SCENE_DELETE, !SCENE_ALLOW_DEATH, "tag_origin" );
	
	add_vehicle_anim( "intro_cougar",	%vehicles::v_la_01_01_110_intro_cougar,		SCENE_DELETE, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG, !SCENE_ANIMATE_ORIGIN );
	add_notetrack_custom_function( "intro_cougar", "bike_hit", maps\la_intro::intro_windshield_swap, false );
	add_notetrack_fx_on_tag( "intro_cougar", "guy_hit", "windshield_blood", "tag_fx_window_front" );
	add_notetrack_fx_on_tag( "intro_cougar", "bike_hit", "windshield_crack", "tag_fx_window_front" );
	
	add_vehicle_anim( "intro_drone1",	%vehicles::v_la_01_01_110_intro_drone1,		SCENE_DELETE, SCENE_NO_HIDE_PARTS, "tag_origin", SCENE_ANIMATE_ORIGIN, "drone_avenger", "veh_t6_drone_avenger", undefined, !SCENE_ALLOW_DEATH );
	add_vehicle_anim( "intro_drone2",	%vehicles::v_la_01_01_110_intro_drone2,		SCENE_DELETE, SCENE_NO_HIDE_PARTS, "tag_origin", SCENE_ANIMATE_ORIGIN, "drone_avenger", "veh_t6_drone_avenger", undefined, !SCENE_ALLOW_DEATH );
	add_vehicle_anim( "intro_drone3",	%vehicles::v_la_01_01_110_intro_drone3,		SCENE_DELETE, SCENE_NO_HIDE_PARTS, "tag_origin", SCENE_ANIMATE_ORIGIN, "drone_avenger", "veh_t6_drone_avenger", undefined, !SCENE_ALLOW_DEATH );
	add_vehicle_anim( "intro_drone4",	%vehicles::v_la_01_01_110_intro_drone4,		SCENE_DELETE, SCENE_NO_HIDE_PARTS, "tag_origin", SCENE_ANIMATE_ORIGIN, "drone_avenger", "veh_t6_drone_avenger", undefined, !SCENE_ALLOW_DEATH );
	
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
	add_prop_anim( "intro_bike5",		%animated_props::v_la_01_01_110_intro_bike5, "veh_t6_civ_police_motorcycle", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	
	add_prop_anim( "intro_copcar1",		%animated_props::v_la_01_01_110_intro_copcar1, "veh_t6_police_car", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	add_prop_anim( "intro_copcar2",		%animated_props::v_la_01_01_110_intro_copcar2, "veh_t6_police_car", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	add_prop_anim( "intro_copcar3",		%animated_props::v_la_01_01_110_intro_copcar3, "veh_t6_police_car", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	add_prop_anim( "intro_copcar4",		%animated_props::v_la_01_01_110_intro_copcar4, "veh_t6_police_car", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	add_prop_anim( "intro_copcar5",		%animated_props::v_la_01_01_110_intro_copcar5, "veh_t6_police_car", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	
	add_prop_anim( "intro_missile_target1",			%animated_props::o_la_01_01_110_intro_missletarget1,	"tag_origin_animate", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	add_prop_anim( "intro_missile_target2",			%animated_props::o_la_01_01_110_intro_missletarget2,	"tag_origin_animate", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	add_prop_anim( "intro_missile_target3",			%animated_props::o_la_01_01_110_intro_missletarget3,	"tag_origin_animate", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	add_prop_anim( "intro_missile_target4",			%animated_props::o_la_01_01_110_intro_missletarget4,	"tag_origin_animate", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	
	add_prop_anim( "intro_explosionfx",	%animated_props::o_la_01_01_110_intro_explosionfx,	"tag_origin_animate", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	add_notetrack_fx_on_tag( "intro_explosionfx", "explosion", "rocket_explode", "tag_origin" );
	
	add_prop_anim( "intro_krailfx", 	%animated_props::o_la_01_01_110_intro_krailfx,		"tag_origin_animate", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	add_notetrack_fx_on_tag( "intro_krailfx", "start_scrape", "intro_krail_scrape", "tag_origin" );
	//add_notetrack_custom_function( "intro_krailfx", "stop_scrape", maps\la_utility::cleanup );
	
	add_prop_anim( "intro_missile1", %animated_props::o_la_01_01_110_intro_missile1, "iw_proj_sidewinder_missile_x2", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_origin" );
	add_notetrack_fx_on_tag( "intro_missile1", "start_smoketrail", "rocket_trail_2x", "tag_fx" );
	add_notetrack_custom_function( "intro_missile1", "missile_impact", maps\la_utility::cleanup );
	
	add_notetrack_custom_function( "intro_blackhawk", "explosion", maps\la_intro::blackhawk_explosion );	
	add_notetrack_custom_function( "intro_missile1", "missile_impact", maps\la_intro::missile_hide );	
	add_notetrack_custom_function( "intro_cougar3", "start_aiming", maps\la_intro::cougar3_aim );
	add_notetrack_fx_on_tag( "intro_blackhawk", "hit_ground", "blackhawk_hit_ground", "tag_origin" );
	
	add_scene( "intro_harper", "intro_cougar" );
	add_actor_model_anim( "harper",			%generic_human::ch_la_01_01_110_intro_harp,		undefined, SCENE_DELETE, "tag_body_animate_jnt" );
	add_notetrack_attach( "harper", "syringe_attach", "adrenaline_syringe_small_animated", "tag_weapon_left" );
	add_notetrack_detach( "harper", "syringe_detach", "adrenaline_syringe_small_animated", "tag_weapon_left" );	
	add_prop_anim( "intro_phone3",			%animated_props::o_la_01_01_110_intro_phone3,	"p6_anim_cell_phone", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_body_animate_jnt" );	
	add_notetrack_fx_on_tag( "intro_phone3", undefined, "cellphone_glow", "tag_animate" );	
	
	add_scene( "intro_reflection", "cougar_reflection_scene" );
	add_actor_model_anim( "secretary_reflection",		%generic_human::ch_la_01_01_110_intro_sec,		undefined, SCENE_DELETE, "tag_body_animate_jnt", undefined, "secretary" );
	add_actor_model_anim( "jones_reflection",			%generic_human::ch_la_01_01_110_intro_jones,	undefined, SCENE_DELETE, "tag_body_animate_jnt", undefined, "jones" );
	add_actor_model_anim( "johnson_reflection",			%generic_human::ch_la_01_01_110_intro_johnson,	undefined, SCENE_DELETE, "tag_body_animate_jnt", undefined, "johnson" );
	add_actor_anim( "mason_reflection", %generic_human::ch_la_01_01_110_intro_mason, SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, SCENE_ALLOW_DEATH, "tag_body_animate_jnt" );
	
	add_scene( "intro_reflection_harper", "cougar_reflection_scene" );
	add_actor_model_anim( "harper_reflection",			%generic_human::ch_la_01_01_110_intro_harp,		undefined, SCENE_DELETE, "tag_body_animate_jnt", undefined, "harper" );
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	/// Crawl out
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	add_scene( "cougar_crawl_player", "align_cougar_crawl" );
	add_player_anim( "player_body", %player::ch_la_03_01_cougarcrawl_player, true, 0, undefined, false, 1, 30, 30, 30, 30 );
	add_notetrack_custom_function( "player_body", "sndChangeCrawlSnapshot", maps\la_1_amb::sndChangeCrawlSnapshot );
	
	add_scene( "cougar_crawl", "align_cougar_crawl" );
	add_actor_anim( "hillary",			%generic_human::ch_la_03_01_cougarcrawl_hilary,		SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	!SCENE_DELETE,	!SCENE_ALLOW_DEATH );
	add_actor_anim( "jones",			%generic_human::ch_la_03_01_cougarcrawl_ss02, 		!SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	!SCENE_DELETE,	!SCENE_ALLOW_DEATH  );
	add_actor_anim( "johnson",			%generic_human::ch_la_03_01_cougarcrawl_johnston,	!SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	!SCENE_DELETE,	!SCENE_ALLOW_DEATH  );
	add_prop_anim( "cougar_destroyed",	%animated_props::v_la_03_01_cougarcrawl_cougar, "veh_t6_mil_cougar_destroyed" );
	add_actor_anim( "cougar_crawl_cop1",%generic_human::ch_la_03_01_cougarcrawl_lapd01,		!SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	!SCENE_DELETE,	SCENE_ALLOW_DEATH );
	add_actor_anim( "cougar_crawl_cop2",%generic_human::ch_la_03_01_cougarcrawl_lapd02,		!SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	!SCENE_DELETE,	SCENE_ALLOW_DEATH );
	add_actor_anim( "cougar_crawl_cop3",%generic_human::ch_la_03_01_cougarcrawl_lapd03,		!SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	!SCENE_DELETE,	SCENE_ALLOW_DEATH );
	add_actor_anim( "cougar_crawl_cop4",%generic_human::ch_la_03_01_cougarcrawl_lapd04,		!SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	!SCENE_DELETE,	SCENE_ALLOW_DEATH );
	//start_death
	add_notetrack_custom_function( "cougar_crawl_cop1", "start_death", ::bloody_model_death );
	add_notetrack_custom_function( "cougar_crawl_cop2", "start_death", ::bloody_model_death );
	add_notetrack_custom_function( "cougar_crawl_cop3", "start_death", ::bloody_model_death );
	add_notetrack_custom_function( "cougar_crawl_cop4", "start_death", ::bloody_model_death );
	add_notetrack_custom_function( "hillary", "start_death", maps\la_sam::on_hillary_death );
	
	add_scene( "cougar_crawl_harper", "align_cougar_crawl" );
	add_actor_anim( "harper",			%generic_human::ch_la_03_01_cougarcrawl_jack, 		!SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	!SCENE_DELETE,	!SCENE_ALLOW_DEATH );
	add_actor_anim( "sam",				%generic_human::ch_la_03_01_cougarcrawl_bill,		!SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	!SCENE_DELETE,	!SCENE_ALLOW_DEATH );	
	
	add_scene( "cougar_crawl_noharper", "align_cougar_crawl" );
	add_actor_anim( "sam",				%generic_human::ch_la_03_01_cougarcrawl_harperdead_sam,		!SCENE_HIDE_WEAPON,	!SCENE_GIVE_BACK_WEAPON,	!SCENE_DELETE,	!SCENE_ALLOW_DEATH );
	
	add_scene( "cougar_crawl_fxanim", "cougar_destroyed", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_prop_anim( "cougar_destroyed_fxanim",	%animated_props::fxanim_la_cougar_crawl_exit_anim, "fxanim_la_cougar_crawl_exit_mod", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_body" );
	add_notetrack_fx_on_tag( "cougar_destroyed_fxanim", "fx_spark1", "falling_sparks_tiny", "tag_fx_wire1" );
	add_notetrack_fx_on_tag( "cougar_destroyed_fxanim", "fx_spark2", "falling_sparks_tiny", "tag_fx_wire2" );
	add_notetrack_fx_on_tag( "cougar_destroyed_fxanim", "fx_spark3", "falling_sparks_tiny", "tag_fx_wire3" );

	add_scene( "cougar_crawl_dead_loop", "align_cougar_crawl", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "secretary", %generic_human::ch_la_03_01_cougarcrawl_secretary, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, !SCENE_ALLOW_DEATH );
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	/// SAM
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	add_scene( "sam_cougar_align", "align_cougar_crawl" );
	add_vehicle_anim( "sam_cougar", %vehicles::v_la_03_02_mountturret_cougar_loop );
	
	add_scene( "sam_cougar_mount", "align_cougar_crawl" );
	add_vehicle_anim( "sam_cougar", %vehicles::v_la_03_02_mountturret_cougar );
	add_player_anim( "player_body", %player::ch_la_03_02_mountturret_player, true, undefined, undefined, true, 1, 15, 15, 15, 15, true, true );
	add_notetrack_custom_function( "player_body", "dof1", maps\createart\la_1_art::mount_turret_dof1 );
	add_notetrack_custom_function( "player_body", "dof2", maps\createart\la_1_art::mount_turret_dof2 );
	add_notetrack_custom_function( "player_body", "dof3", maps\createart\la_1_art::mount_turret_dof3 );
	add_notetrack_custom_function( "player_body", "dof4", maps\createart\la_1_art::mount_turret_dof4 );
	add_notetrack_custom_function( "player_body", "dof5", maps\createart\la_1_art::mount_turret_dof5 );
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	/// FA-38 Intro
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	add_scene( "close_call_drone", "align_cougar_crawl" );
	add_vehicle_anim( "cougar_crawl_drone",	%vehicles::v_la_03_04_cougarfalls_f35intro_drone, !SCENE_DELETE );
	add_notetrack_level_notify( "cougar_crawl_drone", "billboard_hit",	"fxanim_billboard_drone_shoot_start" );
	add_notetrack_level_notify( "cougar_crawl_drone", "car1_hit",		"fxanim_police_car_flip_start" );
	add_notetrack_level_notify( "cougar_crawl_drone", "v_rail_impact",	"fxanim_drone_krail_start" );
	add_notetrack_level_notify( "cougar_crawl_drone", "car2_hit",		"fxanim_suv_flip_start" );
	add_notetrack_fx_on_tag( "cougar_crawl_drone", "car1_hit", "exp_la_drone_hit_by_missile", "origin_animate_jnt" );
	add_notetrack_fx_on_tag( "cougar_crawl_drone", "v_rail_impact", "fa38_drone_crash", "origin_animate_jnt" );
	
	add_scene( "sam_cougar_fall_player", "align_cougar_crawl" );
	add_player_anim( "player_body",		%player::ch_la_03_04_cougarfalls_f35intro_player, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, 1, 30, 30, 30, 30 );
	add_notetrack_custom_function( "player_body", "dof1", maps\createart\la_1_art::cougar_fall_dof1 );
	add_notetrack_custom_function( "player_body", "dof2", maps\createart\la_1_art::cougar_fall_dof2 );
	add_notetrack_custom_function( "player_body", "dof3", maps\createart\la_1_art::cougar_fall_dof3 );
	add_notetrack_custom_function( "player_body", "player_hit_ground", maps\la_sam::player_hit_ground );
	add_notetrack_level_notify( "player_body", "player_hit_ground", "fxanim_cougar_fall_debris_start" );
	add_notetrack_level_notify( "player_body", "debris", "fxanim_f35_blast_chunks_start" );
	
	add_scene( "sam_cougar_fall", "align_cougar_crawl" );
	add_vehicle_anim( "sam_cougar",	%vehicles::v_la_03_04_cougarfalls_f35intro_cougar );
	add_vehicle_anim( "f35_vtol", 	%vehicles::v_la_03_04_cougarfalls_f35intro_f35, !SCENE_DELETE );
	add_actor_anim( "sam", 	%generic_human::ch_la_03_04_cougarfalls_f35intro_bill,			!SCENE_HIDE_WEAPON, false, true );
	add_actor_anim( "hillary", 	%generic_human::ch_la_03_04_cougarfalls_f35intro_hillary,	SCENE_HIDE_WEAPON, false, true );
	add_actor_anim( "jones", 	%generic_human::ch_la_03_04_cougarfalls_f35intro_ssa,		!SCENE_HIDE_WEAPON, false, true );
	add_prop_anim( "highway_rubble_1", %animated_props::o_la_03_04_cougarfalls_f35intro_debris01, undefined, true, true );
	add_prop_anim( "highway_rubble_2", %animated_props::o_la_03_04_cougarfalls_f35intro_debris02, undefined, true, true );
	
	add_notetrack_attach( "sam_cougar", undefined, "veh_t6_mil_cougar_interior_front" );
	add_notetrack_attach( "sam_cougar", undefined, "veh_t6_cougar_hatch_shadow", "tag_origin_animate_jnt" );
	add_notetrack_custom_function( "sam_cougar", undefined, maps\la_sam::hide_hatch );
	
	add_notetrack_exploder( "f35_vtol", "dust_off", 314 );
	
	add_notetrack_custom_function( "f35_vtol", "AB_off", maps\la_sam::after_burner_off );
	add_notetrack_custom_function( "f35_vtol", "AB_on", maps\la_sam::after_burner_on );
	
	add_scene( "sam_cougar_fall_harper", "align_cougar_crawl" );
	add_actor_anim( "harper", 	%generic_human::ch_la_03_04_cougarfalls_f35intro_harper,	!SCENE_HIDE_WEAPON, false, true );
	
	add_scene( "sam_cougar_fall_vehilces", "align_cougar_crawl" );
	add_vehicle_anim( "cougarfalls_f35intro_car02", %vehicles::v_la_03_04_cougarfalls_f35intro_car02, SCENE_DELETE );
	add_vehicle_anim( "cougarfalls_f35intro_van", %vehicles::v_la_03_04_cougarfalls_f35intro_van, SCENE_DELETE );
	add_notetrack_custom_function( "cougarfalls_f35intro_car02", "car_roof_sparks", maps\la_sam::fa38_intro_car_roof_sparks );
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	/// Rappel
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	add_scene( "groupcover_approach", "align_rappel" );
	add_actor_anim( "hillary",	%generic_human::ch_la_03_08_groupcover_approach_hilary,	SCENE_HIDE_WEAPON );
	add_actor_anim( "sam",		%generic_human::ch_la_03_08_groupcover_approach_bill,	!SCENE_HIDE_WEAPON );
	add_actor_anim( "jones",	%generic_human::ch_la_03_08_groupcover_approach_ss02,	!SCENE_HIDE_WEAPON );
	
	add_scene( "groupcover_approach_harper", "align_rappel" );
	add_actor_anim( "harper",	%generic_human::ch_la_03_08_groupcover_approach_jack,	!SCENE_HIDE_WEAPON );
	
	add_scene( "groupcover", "align_rappel", !SCENE_REACH, !SCENE_GENERIC, true );
	add_actor_anim( "hillary",	%generic_human::ch_la_03_08_groupcover_hilary,	SCENE_HIDE_WEAPON );
	add_actor_anim( "sam",		%generic_human::ch_la_03_08_groupcover_bill,		!SCENE_HIDE_WEAPON );
	add_actor_anim( "jones",	%generic_human::ch_la_03_08_groupcover_ss02,		!SCENE_HIDE_WEAPON );
	
	add_scene( "groupcover_harper", "align_rappel", !SCENE_REACH, !SCENE_GENERIC, true );
	add_actor_anim( "harper",	%generic_human::ch_la_03_08_groupcover_jack,		!SCENE_HIDE_WEAPON );
	
	// RAPPEL VERSION
	
	add_scene( "grouprappel_player", "align_rappel" );
	add_player_anim( "player_body", %player::ch_la_03_10_grouprappel_player, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, 1, 15, 15, 15, 15 );
	
	add_notetrack_custom_function( "player_body", "dof_hookup", maps\createart\la_1_art::dof_hookup );
	add_notetrack_custom_function( "player_body", "dof_rappelers", maps\createart\la_1_art::dof_rappelers );
	add_notetrack_custom_function( "player_body", "dof_hands", maps\createart\la_1_art::dof_hands );
	add_notetrack_custom_function( "player_body", "dof_rappelers2", maps\createart\la_1_art::dof_rappelers2 );
	add_notetrack_custom_function( "player_body", "dof_truck", maps\createart\la_1_art::dof_truck );
	add_notetrack_custom_function( "player_body", "dof_rappelers3", maps\createart\la_1_art::dof_rappelers3 );
	add_notetrack_custom_function( "player_body", "dof_rappelers4", maps\createart\la_1_art::dof_rappelers4 );

	
	add_scene( "grouprappel", "align_rappel" );
	add_actor_anim( "hillary",	%generic_human::ch_la_03_10_grouprappel_hilary,	SCENE_HIDE_WEAPON );
	add_actor_anim( "sam",		%generic_human::ch_la_03_10_grouprappel_bill,	!SCENE_HIDE_WEAPON );
	add_actor_anim( "jones",	%generic_human::ch_la_03_10_grouprappel_ss02,	!SCENE_HIDE_WEAPON );
	add_actor_anim( "semi_driver",	%generic_human::ch_la_03_10_grouprappel_driver,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, undefined, "default_enemy" );
	add_prop_anim( "rope_bill",		%animated_props::o_la_03_10_grouprappel_bill_rope, 		"iw_prague_rope_rappel_building" );
	add_prop_anim( "rope_hilary",	%animated_props::o_la_03_10_grouprappel_hilary_rope,	"iw_prague_rope_rappel_building" );
	
	add_scene( "grouprappel_tbone", "align_rappel" );
	add_prop_anim( "low_road_car5", %animated_props::v_la_03_10_grouprappel_car05 );
	add_prop_anim( "g20_group1_cougar4", %animated_props::v_la_03_10_grouprappel_cougar, "veh_t6_mil_cougar", !SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG );
	add_prop_anim( "g20_group1_bigrig", %animated_props::v_la_03_10_grouprappel_bigrig, "veh_t6_civ_18wheeler", !SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG );
	add_notetrack_level_notify( "g20_group1_bigrig", "bigrig doors", "bigrig_trailer_doors_open" );
	
	add_scene( "grouprappel_jack", "align_rappel" );
	add_actor_anim( "harper",	%generic_human::ch_la_03_10_grouprappel_jack,	!SCENE_HIDE_WEAPON );
	add_prop_anim( "rope_jack",		%animated_props::o_la_03_10_grouprappel_jack_rope,		"iw_prague_rope_rappel_building" );
	
	add_scene( "grouprappel_ter01" );
	add_actor_anim( "freeway_bigrig_entry_guy1",	%generic_human::ch_la_03_10_grouprappel_ter01, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, "tag_origin", "default_enemy" );
	
	add_scene( "grouprappel_ter02" );
	add_actor_anim( "freeway_bigrig_entry_guy2",	%generic_human::ch_la_03_10_grouprappel_ter02, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, "tag_origin", "default_enemy" );
	
	add_scene( "grouprappel_ter03" );
	add_actor_anim( "freeway_bigrig_entry_guy3",	%generic_human::ch_la_03_10_grouprappel_ter03, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, "tag_origin", "default_enemy" );
	
	
	// SNIPER VERSION
	
	add_scene( "grouprappel_sniper", "align_rappel" );
	add_actor_anim( "hillary",	%generic_human::ch_la_03_10_grouprappel_sniper_hilary,	SCENE_HIDE_WEAPON );
	add_actor_anim( "sam",		%generic_human::ch_la_03_10_grouprappel_sniper_bill,	!SCENE_HIDE_WEAPON );
	add_actor_anim( "jones",	%generic_human::ch_la_03_10_grouprappel_sniper_ss02,	!SCENE_HIDE_WEAPON );
	add_actor_anim( "semi_driver",	%generic_human::ch_la_03_10_grouprappel_sniper_driver, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, undefined, "default_enemy" );
	add_prop_anim( "rope_jack",		%animated_props::o_la_03_10_grouprappel_sniper_jack_rope,		"iw_prague_rope_rappel_building" );
	add_prop_anim( "rope_bill",		%animated_props::o_la_03_10_grouprappel_sniper_bill_rope, 		"iw_prague_rope_rappel_building" );
	add_prop_anim( "rope_hilary",	%animated_props::o_la_03_10_grouprappel_sniper_hilary_rope,	"iw_prague_rope_rappel_building" );
	
	add_scene( "grouprappel_sniper_tbone", "align_rappel" );
	add_prop_anim( "low_road_car5", %animated_props::v_la_03_10_grouprappel_sniper_car05 );
	add_prop_anim( "g20_group1_cougar4", %animated_props::v_la_03_10_grouprappel_sniper_cougar, "veh_t6_mil_cougar", !SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG );
	add_prop_anim( "g20_group1_bigrig", %animated_props::v_la_03_10_grouprappel_sniper_bigrig, "veh_t6_civ_18wheeler", !SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG );
	add_notetrack_level_notify( "g20_group1_bigrig", "open door", "bigrig_trailer_doors_open" );
	add_actor_model_anim( "cougarguy", %generic_human::ch_la_03_10_grouprappel_sniper_cougarguy, undefined, false, undefined, undefined, "g20_group1_ss" );
	add_notetrack_attach( "g20_group1_cougar4", undefined, "veh_t6_mil_cougar_interior_front" );
	add_notetrack_fx_on_tag( "g20_group1_bigrig", undefined, "bigrig_brake_light", "tag_tail_light_left" );
	add_notetrack_fx_on_tag( "g20_group1_bigrig", undefined, "bigrig_brake_light", "tag_tail_light_right" );
	add_notetrack_fx_on_tag( "g20_group1_bigrig", undefined, "18wheeler_tire_smk_rt", "tag_wheel_back_right" );
	add_notetrack_fx_on_tag( "g20_group1_bigrig", undefined, "18wheeler_tire_smk_lf", "tag_wheel_back_left" );
	add_notetrack_exploder( "g20_group1_cougar4", undefined, 320 );
	
	add_scene( "grouprappel_sniper_jack", "align_rappel" );
	add_actor_anim( "harper",	%generic_human::ch_la_03_10_grouprappel_sniper_jack,	!SCENE_HIDE_WEAPON );
	
	add_scene( "grouprappel_sniper_ter01" );
	add_actor_anim( "freeway_bigrig_entry_guy1",	%generic_human::ch_la_03_10_grouprappel_sniper_ter01, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, "tag_origin", "default_enemy" );
	
	add_scene( "grouprappel_sniper_ter02" );
	add_actor_anim( "freeway_bigrig_entry_guy2",	%generic_human::ch_la_03_10_grouprappel_sniper_ter02, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, "tag_origin", "default_enemy" );
	
	add_scene( "grouprappel_sniper_ter03" );
	add_actor_anim( "freeway_bigrig_entry_guy3",	%generic_human::ch_la_03_10_grouprappel_sniper_ter03, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, "tag_origin", "default_enemy" );
	
	// END RAPPEL	
		
	add_scene( "terrorist_rappel1", "enemy_repel_struct", SCENE_REACH );
	add_actor_anim( "terrorist_rappel1",	%generic_human::ch_la_03_08_ai_rappel_guy01 );
	add_prop_anim( "terrorist_rappel_rope4", %animated_props::o_la_03_08_ai_rappel_rope04, "iw_prague_rope_rappel_building" );
	
	add_scene( "terrorist_rappel2", "enemy_repel_struct", SCENE_REACH );
	add_actor_anim( "terrorist_rappel3",	%generic_human::ch_la_03_08_ai_rappel_guy03 );
	add_prop_anim( "terrorist_rappel_rope2", %animated_props::o_la_03_08_ai_rappel_rope02, "iw_prague_rope_rappel_building" );
	
	add_scene( "terrorist_rappel3", "enemy_repel_struct", SCENE_REACH );
	add_actor_anim( "terrorist_rappel4",	%generic_human::ch_la_03_08_ai_rappel_guy04 );
	add_prop_anim( "terrorist_rappel_rope3", %animated_props::o_la_03_08_ai_rappel_rope03, "iw_prague_rope_rappel_building" );
	
	add_scene( "terrorist_rappel_left1", "anim_align_wall_rappel_left", SCENE_REACH );
	add_actor_anim( "terrorist_rappel_left1",	%generic_human::ch_la_03_06_ai_rappel_left_guy01 );
	add_prop_anim( "terrorist_rappel_rope_left1", %animated_props::o_la_03_06_ai_rappel_left_rope01, "iw_prague_rope_rappel_building" );
	
	add_scene( "terrorist_rappel_left2", "anim_align_wall_rappel_left", SCENE_REACH );
	add_actor_anim( "terrorist_rappel_left2",	%generic_human::ch_la_03_06_ai_rappel_left_guy02 );
	add_prop_anim( "terrorist_rappel_rope_left4", %animated_props::o_la_03_06_ai_rappel_left_rope04, "iw_prague_rope_rappel_building" );
	
	add_scene( "terrorist_rappel_left3", "anim_align_wall_rappel_left", SCENE_REACH );
	add_actor_anim( "terrorist_rappel_left3",	%generic_human::ch_la_03_06_ai_rappel_left_guy03 );
	add_prop_anim( "terrorist_rappel_rope_left2", %animated_props::o_la_03_06_ai_rappel_left_rope02, "iw_prague_rope_rappel_building" );
	
	add_scene( "terrorist_rappel_left4", "anim_align_wall_rappel_left", SCENE_REACH );
	add_actor_anim( "terrorist_rappel_left4",	%generic_human::ch_la_03_06_ai_rappel_left_guy04 );
	add_prop_anim( "terrorist_rappel_rope_left3", %animated_props::o_la_03_06_ai_rappel_left_rope03, "iw_prague_rope_rappel_building" );
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	/// Low Road
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	add_scene( "low_road_bodies", "align_ground_battle" );
	add_actor_model_anim( "low_road_body01", %generic_human::ch_la_03_05_lowroadbodies_body01 );
	add_actor_model_anim( "low_road_body02", %generic_human::ch_la_03_05_lowroadbodies_body02 );
	add_actor_model_anim( "low_road_body03", %generic_human::ch_la_03_05_lowroadbodies_body03 );
	add_actor_model_anim( "low_road_body04", %generic_human::ch_la_03_05_lowroadbodies_body04 );
	add_actor_model_anim( "low_road_body05", %generic_human::ch_la_03_05_lowroadbodies_body05 );
	add_actor_model_anim( "low_road_body06", %generic_human::ch_la_03_05_lowroadbodies_body06 );
	add_actor_model_anim( "low_road_body07", %generic_human::ch_la_03_05_lowroadbodies_body07 );
	add_actor_model_anim( "low_road_body08", %generic_human::ch_la_03_05_lowroadbodies_body08 );
	add_actor_model_anim( "low_road_body09", %generic_human::ch_la_03_05_lowroadbodies_body09 );
	add_actor_model_anim( "low_road_body10", %generic_human::ch_la_03_05_lowroadbodies_body10 );
	add_actor_model_anim( "low_road_body11", %generic_human::ch_la_03_05_lowroadbodies_body11 );
	add_actor_model_anim( "low_road_body12", %generic_human::ch_la_03_05_lowroadbodies_body12 );
	add_actor_model_anim( "low_road_body13", %generic_human::ch_la_03_05_lowroadbodies_body13 );
	add_actor_model_anim( "low_road_body14", %generic_human::ch_la_03_05_lowroadbodies_body14 );
	add_actor_model_anim( "low_road_body15", %generic_human::ch_la_03_05_lowroadbodies_body15 );
	add_actor_model_anim( "low_road_body16", %generic_human::ch_la_03_05_lowroadbodies_body16 );
	add_actor_model_anim( "low_road_body17", %generic_human::ch_la_03_05_lowroadbodies_body17 );
	
	add_scene( "sniper_bus_rock", "sniper_bus" );
	add_prop_anim( "sniper_bus", %animated_props::fxanim_la_sniper_bus_anim );
	
	add_scene( "sniper_train_rock_front", "sniper_trains" );
	add_prop_anim( "sniper_trains", %animated_props::fxanim_la_sniper_trains_02_anim );
	
	add_scene( "sniper_train_rock_middle", "sniper_trains" );
	add_prop_anim( "sniper_trains", %animated_props::fxanim_la_sniper_trains_anim );	
	
	add_scene( "low_road_intro", "align_ground_battle" );
	add_vehicle_anim( "g20_group1_cougar",	%vehicles::v_la_03_05_lowroad_cougar01, !SCENE_DELETE, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG, SCENE_ANIMATE_ORIGIN, undefined, undefined, undefined, !SCENE_ALLOW_DEATH );
	add_vehicle_anim( "g20_group1_cougar3",	%vehicles::v_la_03_05_lowroad_cougar03, !SCENE_DELETE, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG, SCENE_ANIMATE_ORIGIN, undefined, undefined, undefined, !SCENE_ALLOW_DEATH );
	add_prop_anim( "g20_group1_cougar2", %animated_props::v_la_03_05_lowroad_cougar02, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG );
	
	add_scene( "low_road_intro_cars", "align_ground_battle" );
	add_prop_anim( "low_road_car1", %animated_props::v_la_03_05_lowroad_car01, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG );
	add_prop_anim( "low_road_car2", %animated_props::v_la_03_05_lowroad_car02, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG );
	add_prop_anim( "low_road_car3", %animated_props::v_la_03_05_lowroad_car03, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG );
	add_prop_anim( "low_road_car4", %animated_props::v_la_03_05_lowroad_car04, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG );
	
	add_scene( "low_road_intro_policecars", "align_ground_battle" );
	add_prop_anim( "g20_group1_policecar1", %animated_props::v_la_03_05_lowroad_policecar01, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG );
	add_prop_anim( "g20_group1_policecar2", %animated_props::v_la_03_05_lowroad_policecar02, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG );
	
	add_scene( "low_road_intro_police1", "align_ground_battle" );
	add_actor_anim( "g20_group1_cop1",	%generic_human::ch_la_03_05_lowroad_police01, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, undefined );
	
	add_scene( "low_road_intro_police2", "align_ground_battle" );
	add_actor_anim( "g20_group1_cop2",	%generic_human::ch_la_03_05_lowroad_police02, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, undefined );
	
	add_scene( "low_road_intro_police3", "align_ground_battle" );
	add_actor_anim( "g20_group1_cop3",	%generic_human::ch_la_03_05_lowroad_police03, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, undefined );
	
	add_scene( "low_road_intro_police4", "align_ground_battle" );
	add_actor_anim( "g20_group1_cop4",	%generic_human::ch_la_03_05_lowroad_police04, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, undefined );
	
	add_scene( "low_road_intro_police1_loop", "align_ground_battle", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "g20_group1_cop1",	%generic_human::ch_la_03_05_lowroad_policeidle01 );
	
	add_scene( "low_road_intro_police2_loop", "align_ground_battle", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "g20_group1_cop2",	%generic_human::ch_la_03_05_lowroad_policeidle02 );
	
	add_scene( "low_road_intro_police4_loop", "align_ground_battle", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "g20_group1_cop4",	%generic_human::ch_la_03_05_lowroad_policeidle04 );
	
	add_scene( "low_road_car_fall_loop", "align_rappel", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_prop_anim( "low_road_car6", %animated_props::v_la_03_05_lowroad_car06_loop, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG );
	
	add_scene( "low_road_car_fall", "align_rappel", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP );
	add_prop_anim( "low_road_car6", %animated_props::v_la_03_05_lowroad_car06, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG );
	
	add_scene( "freeway_bigrig_entry", "align_ground_battle" );
	add_prop_anim( "g20_group1_bigrig2", %animated_props::v_la_03_05_lowroad_bigrig02, "veh_t6_civ_18wheeler" );
	add_actor_anim( "freeway_bigrig_entry_guy1",	%generic_human::ch_la_03_09_bigrig_entries_guy01, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, undefined );
	add_actor_anim( "freeway_bigrig_entry_guy2",	%generic_human::ch_la_03_09_bigrig_entries_guy02, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, undefined );
	add_actor_anim( "freeway_bigrig_entry_guy3",	%generic_human::ch_la_03_09_bigrig_entries_guy03, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, undefined );
	add_actor_anim( "freeway_bigrig_entry_guy4",	%generic_human::ch_la_03_09_bigrig_entries_guy04, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, undefined );
	add_actor_anim( "freeway_bigrig_entry_driver",	%generic_human::ch_la_03_09_bigrig_entries_driver, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, undefined );
	
	add_notetrack_fx_on_tag( "g20_group1_bigrig2", undefined, "bigrig_brake_light", "tag_tail_light_left" );
	add_notetrack_fx_on_tag( "g20_group1_bigrig2", undefined, "bigrig_brake_light", "tag_tail_light_right" );
	add_notetrack_fx_on_tag( "g20_group1_bigrig2", undefined, "18wheeler_tire_smk_rt", "tag_wheel_back_right" );
	add_notetrack_fx_on_tag( "g20_group1_bigrig2", undefined, "18wheeler_tire_smk_lf", "tag_wheel_back_left" );
	
	add_scene( "low_road_rpg_guy_on_bus", "nd_bus_rpg_guy" );
	add_actor_anim( "low_road_bus_rpg", %generic_human::ch_la_03_11_busrpg_guy01 );
	
	add_scene( "group_cover_idle1", "align_rappel", !SCENE_REACH, !SCENE_GENERIC, true );
	add_actor_anim( "sam",		%generic_human::ch_la_3_11_streetfight_run2cover01_wait_bill,	!SCENE_HIDE_WEAPON );
	add_actor_anim( "hillary",	%generic_human::ch_la_3_11_streetfight_run2cover01_wait_hilary,	SCENE_HIDE_WEAPON );
	add_actor_anim( "jones",	%generic_human::ch_la_3_11_streetfight_run2cover01_wait_ss02,	!SCENE_HIDE_WEAPON );
			
	add_scene( "group_cover_go2", "align_rappel" );
	add_actor_anim( "sam",		%generic_human::ch_la_3_11_streetfight_run2cover02_bill,	!SCENE_HIDE_WEAPON );
	add_actor_anim( "hillary",	%generic_human::ch_la_3_11_streetfight_run2cover02_hilary,	SCENE_HIDE_WEAPON );
	add_actor_anim( "jones",	%generic_human::ch_la_3_11_streetfight_run2cover02_ss02,	!SCENE_HIDE_WEAPON );
	
	add_scene( "group_cover_idle2", "align_rappel", !SCENE_REACH, !SCENE_GENERIC, true );
	add_actor_anim( "sam",		%generic_human::ch_la_3_11_streetfight_run2cover02_wait_bill,	!SCENE_HIDE_WEAPON );
	add_actor_anim( "hillary",	%generic_human::ch_la_3_11_streetfight_run2cover02_wait_hilary,	SCENE_HIDE_WEAPON );
	add_actor_anim( "jones",	%generic_human::ch_la_3_11_streetfight_run2cover02_wait_ss02,	!SCENE_HIDE_WEAPON );
	
	add_scene( "group_cover_bus_react", "align_rappel" );
	add_actor_anim( "sam",		%generic_human::ch_la_3_11_streetfight_bus_react_sam,	!SCENE_HIDE_WEAPON );
	add_actor_anim( "hillary",	%generic_human::ch_la_3_11_streetfight_bus_react_hilary,	SCENE_HIDE_WEAPON );
	add_actor_anim( "jones",	%generic_human::ch_la_3_11_streetfight_bus_react_ss02,	!SCENE_HIDE_WEAPON );
	
	add_scene( "group_cover_go3", "align_rappel" );
	add_actor_anim( "sam",		%generic_human::ch_la_3_11_streetfight_run2cover03_bill,	!SCENE_HIDE_WEAPON );
	add_actor_anim( "hillary",	%generic_human::ch_la_3_11_streetfight_run2cover03_hilary,	SCENE_HIDE_WEAPON );
	add_actor_anim( "jones",	%generic_human::ch_la_3_11_streetfight_run2cover03_ss02,	!SCENE_HIDE_WEAPON );
	
	add_scene( "group_cover_idle3", "align_rappel", !SCENE_REACH, !SCENE_GENERIC, true );
	add_actor_anim( "sam",		%generic_human::ch_la_3_11_streetfight_run2cover03_wait_bill,	!SCENE_HIDE_WEAPON );
	add_actor_anim( "hillary",	%generic_human::ch_la_3_11_streetfight_run2cover03_wait_hilary,	SCENE_HIDE_WEAPON );
	add_actor_anim( "jones",	%generic_human::ch_la_3_11_streetfight_run2cover03_wait_ss02,	!SCENE_HIDE_WEAPON );
		
	add_scene( "group_to_convoy", "align_rappel" );
	add_actor_anim( "sam",		%generic_human::ch_la_3_11_streetfight_run2convoy_bill,		!SCENE_HIDE_WEAPON );
	add_actor_anim( "hillary",	%generic_human::ch_la_3_11_streetfight_run2convoy_hilary,	SCENE_HIDE_WEAPON );
	add_actor_anim( "jones",	%generic_human::ch_la_3_11_streetfight_run2convoy_ss02,		!SCENE_HIDE_WEAPON );
	
	add_scene( "group_convoy_loop", "align_rappel", !SCENE_REACH, !SCENE_GENERIC, true );
	add_actor_anim( "sam",		%generic_human::ch_la_3_11_streetfight_run2convoy_loop_bill,	!SCENE_HIDE_WEAPON );
	add_actor_anim( "hillary",	%generic_human::ch_la_3_11_streetfight_run2convoy_loop_hilary,	SCENE_HIDE_WEAPON );
	add_actor_anim( "jones",	%generic_human::ch_la_3_11_streetfight_run2convoy_loop_ss02,	!SCENE_HIDE_WEAPON );
	
	add_scene( "low_road_car_push", "align_rappel" );
	add_prop_anim( "low_road_car_push_car01", %animated_props::v_la_03_11_SniperEvent_car01, "veh_t6_police_car", !SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG );
	add_actor_anim( "low_road_car_push_guy01", %generic_human::ch_la_03_11_SniperEvent_guy01, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG, "default_enemy" );
	add_actor_anim( "low_road_car_push_guy02", %generic_human::ch_la_03_11_SniperEvent_guy02, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG, "default_enemy" );
	add_actor_anim( "low_road_car_push_guy03", %generic_human::ch_la_03_11_SniperEvent_guy03, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG, "default_enemy" );
	
	add_scene( "exit_sniper_player", "align_rappel" );
	add_player_anim( "player_body",		%player::ch_la_03_09_exitsniper_player, SCENE_DELETE, PLAYER_1, undefined, SCENE_DELTA, 1, 15, 15, 15, 15 );
	add_notetrack_exploder( "player_body", "car_crash", 305 );
	
	add_notetrack_custom_function( "player_body", "dof first rpg", maps\createart\la_1_art::dof_sr_first_rpg );
	add_notetrack_custom_function( "player_body", "dof first explosion", maps\createart\la_1_art::dof_sr_first_explosion );
	add_notetrack_custom_function( "player_body", "dof hook up", maps\createart\la_1_art::dof_sr_hook_up );
	add_notetrack_custom_function( "player_body", "dof hands", maps\createart\la_1_art::dof_sr_hands );
	add_notetrack_custom_function( "player_body", "dof second rpg", maps\createart\la_1_art::dof_sr_second_rpg );
	add_notetrack_custom_function( "player_body", "dof second explosion", maps\createart\la_1_art::dof_sr_second_explosion );
	add_notetrack_custom_function( "player_body", "dof debris falling", maps\createart\la_1_art::dof_sr_debris_falling );
	add_notetrack_custom_function( "player_body", "dof car", maps\createart\la_1_art::dof_sr_car );
	add_notetrack_custom_function( "player_body", "dof get up hand", maps\createart\la_1_art::dof_sr_get_up_hand);
	
	add_scene( "exit_sniper", "align_rappel" );
	add_prop_anim( "sniper_platform", %animated_props::o_la_03_09_exitsniper_platform, undefined, !SCENE_DELETE, SCENE_SIMPLE_PROP );
	add_prop_anim( "sniper_rebar", %animated_props::o_la_03_09_exitsniper_rebar, "iw_aftermath_rebar_group_03", !SCENE_DELETE, SCENE_SIMPLE_PROP );
	add_prop_anim( "sniper_platform_car", %animated_props::o_la_03_09_exitsniper_car1, undefined, !SCENE_DELETE, SCENE_SIMPLE_PROP );
	add_prop_anim( "sniper_platform_suv", %animated_props::o_la_03_09_exitsniper_car2, undefined, !SCENE_DELETE, SCENE_SIMPLE_PROP );
	add_prop_anim( "exit_sniper_rpg", %animated_props::o_la_03_09_exitsniper_rpg, "projectile_rpg7", SCENE_DELETE, SCENE_SIMPLE_PROP );
	add_prop_anim( "exit_sniper_rpg2", %animated_props::o_la_03_09_exitsniper_rpg2, "projectile_rpg7", SCENE_DELETE, SCENE_SIMPLE_PROP );
	add_prop_anim( "exit_sniper_rpg3", %animated_props::o_la_03_09_exitsniper_rpg3, "projectile_rpg7", SCENE_DELETE, SCENE_SIMPLE_PROP );
	add_actor_anim( "exit_sniper_rpg_guy", %generic_human::ch_la_03_09_exitsniper_rpgdude, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, undefined, "exit_sniper_rpg_guy" );
	add_actor_anim( "exit_sniper_rpg_guy2", %generic_human::ch_la_03_09_exitsniper_rpgdude2, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, undefined, "exit_sniper_rpg_guy" );
	add_notetrack_fx_on_tag( "exit_sniper_rpg", "rpg fire 1", "platform_collapse_rpg_trail", "origin_animate_jnt" );
	add_notetrack_fx_on_tag( "exit_sniper_rpg2", "rpg fire 2", "platform_collapse_rpg_trail", "origin_animate_jnt" );
	add_notetrack_fx_on_tag( "exit_sniper_rpg3", "rpg fire 3", "platform_collapse_rpg_trail", "origin_animate_jnt" );
	add_notetrack_exploder( "exit_sniper_rpg", "rpg hit 1", 302 );
	add_notetrack_fx_on_tag( "sniper_platform_suv", "car_fall", "smk_fire_trail_vehicle_falling", "origin_animate_jnt" );
	add_notetrack_stop_exploder( "exit_sniper_rpg", "rpg hit 1", 300 );
	add_notetrack_exploder( "exit_sniper_rpg3", "rpg hit 3", 304 );
	add_notetrack_fx_on_tag( "sniper_platform_car", "car_fall", "smk_fire_trail_vehicle_falling", "origin_animate_jnt" );
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	/// G20 group
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	add_scene( "g20_fail", "g20_group1_cougar3" );
	add_actor_anim( "g20_fail_guy1",	%generic_human::ch_la_03_11_g20failure_guy01, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, "tag_origin" );
	add_actor_anim( "g20_fail_guy2",	%generic_human::ch_la_03_11_g20failure_guy02, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, "tag_origin" );
	add_vehicle_anim( "g20_group1_cougar3", %vehicles::v_la_03_11_g20failure_cougar );
	add_notetrack_exploder("g20_group1_cougar3", undefined, 330);

	add_scene( "g20_group1_greet", "g20_group1_ss_node" );
	add_actor_anim( "g20_group1_ss1",	%generic_human::ch_la_03_12_meetconvoy_ss04 );
	
	add_scene( "g20_group1_greet_harper", "g20_group1_cougar", true );
	add_actor_anim( "harper", %generic_human::ch_la_03_12_meetconvoy_mike, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, "tag_driver" );
	
	add_scene( "harper_wait_in_cougar", "g20_group1_cougar", !SCENE_REACH, !SCENE_GENERIC, true );
	add_actor_anim( "harper", %generic_human::ch_la_03_12_meetconvoy_mike_loop, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, "tag_driver" );
		
	add_scene( "enter_cougar", "g20_group1_cougar" );
	add_player_anim( "player_body", %player::ch_la_03_12_entercougar_player, SCENE_DELETE, PLAYER_1, "tag_driver", SCENE_DELTA, 1, 10, 10, 10, 10 );
	add_notetrack_custom_function( "player_body", "steering_hands", maps\la_drive::show_drive_hands );
	add_notetrack_custom_function( "player_body", "sndActivateDrivingSnapshot", maps\la_1_amb::sndActivateDrivingSnapshot );
	
	add_notetrack_custom_function( "player_body", "dof_player_hands", maps\createart\la_1_art::enter_cougar_hands );
	add_notetrack_custom_function( "player_body", "dof_potus", maps\createart\la_1_art::enter_cougar_potus );
	add_notetrack_custom_function( "player_body", "dof_steering_wheel", maps\createart\la_1_art::enter_cougar_wheel );	
	
	add_scene( "enter_cougar_potus", "g20_group1_cougar2" );
	add_actor_anim( "sam", %generic_human::ch_la_03_12_entercougar_bill, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, "tag_origin" );
	add_actor_anim( "hillary", %generic_human::ch_la_03_12_entercougar_hillary, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, "tag_origin"  );
	add_actor_anim( "jones", %generic_human::ch_la_03_12_entercougar_ss02, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, "tag_origin", "enter_couger_ss" );
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	/// Dominoes
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	add_scene( "cougar_drive_wires", "g20_group1_cougar", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_prop_anim( "cougar_drive_wires",	%animated_props::fxanim_la_cougar_wire_anim, "fxanim_la_cougar_wire_mod", SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, "tag_body" );
	
	level.scr_anim[ "generic" ][ "dodge1" ] = %generic_human::ch_la_04_01_fast_lane_dodging_guy_01;
	level.scr_anim[ "generic" ][ "dodge2" ] = %generic_human::ch_la_04_01_fast_lane_dodging_guy_02;
	
	add_scene( "freeway_drone", "freeway_collapse" );
	add_vehicle_anim( "hero_drone", %vehicles::fxanim_la_freeway_drone_anim, SCENE_DELETE, undefined, undefined, SCENE_ANIMATE_ORIGIN, "drone_avenger", "veh_t6_drone_avenger" );
	add_notetrack_custom_function( "hero_drone", "fa38_missle_fire", maps\la_drive::fa38_missle_fire );
	//add_notetrack_fx_on_tag( "hero_drone", "drone_hit", "fx_exp_la_drone_avenger_wall", "origin_animate_jnt" );
	add_notetrack_exploder( "hero_drone", "drone_hit", 442 );
	
	add_scene( "freeway_f35", "freeway_collapse" );
	add_vehicle_anim( "f35_vtol", %vehicles::fxanim_la_freeway_fa38_anim, !SCENE_DELETE );
	add_notetrack_custom_function( "f35_vtol", "vtol_start", maps\la_utility::vtol_hover_notetrack );
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	/// T-Bone
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	add_scene( "skyline", "anim_align_offramp_intersection" );
	add_vehicle_anim( "f35_vtol", %vehicles::v_la_04_02_dronebattle_f35, !SCENE_DELETE, "tag_gear" );
	add_vehicle_anim( "skyline_drone", %vehicles::v_la_04_02_dronebattle_drone, true );
	
	add_scene( "cougar_crash", "g20_group1_cougar" );
	add_actor_anim( "harper", %generic_human::ch_la_04_04_crash_harper,	!SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, !SCENE_ALLOW_DEATH, "tag_passenger" );
	add_notetrack_custom_function( "harper", "crash", maps\la_drive::crash );
		
	fxanim_drones();
	
	precache_assets();
	maps\voice\voice_la_1::init_voice();
	
	temp_vo();
}

#using_animtree( "animated_props" );
fxanim_drones()
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
	level.scr_model[ "fxanim_ambient_f35" ] = "veh_t6_air_fa38_no_cockpit";
	level.scr_anim[ "fxanim_ambient_f35" ][ "f35_ambient_1" ][ 0 ] =  %animated_props::fxanim_la_drone_ambient_01_anim;
	level.scr_anim[ "fxanim_ambient_f35" ][ "f35_ambient_2" ][ 0 ] =  %animated_props::fxanim_la_drone_ambient_02_anim;
}

temp_vo()
{
}

bloody_model_death( ch_lapd )
{
	a_tags = [];
	a_tags[ 0 ] = "j_hip_le";
	a_tags[ 1 ] = "j_hip_ri";
	a_tags[ 2 ] = "j_head";
	a_tags[ 3 ] = "j_spine4";
	a_tags[ 4 ] = "j_elbow_le";
	a_tags[ 5 ] = "j_elbow_ri";
	a_tags[ 6 ] = "j_clavicle_le";
	a_tags[ 7 ] = "j_clavicle_ri";
	
	const n_blood_hits = 10;
	const n_delay = 0.1;
	
	a_align_structs = get_struct_array( "sam_run_start_org" );
	
	vh_drone = spawn_drone_for_lapd_squibs( ch_lapd );
	//spawn_straffing_drone( RANDOM( a_align_structs ), 500, ch_lapd, "delete_before_sam_drones", "sam_drone" );
	
	for ( i = 0; i < n_blood_hits; i++ )
	{
		if ( is_mature() )
		{
			n_wait_min = i * n_delay;  // 0 and n_delay
			n_wait_max = ( i + 1 ) * n_delay; // n_delay and 2*n_delay
			n_thread_delay = RandomFloatRange( n_wait_min, n_wait_max );
			ch_lapd delay_thread( n_thread_delay, ::bloody_death_fx, random( a_tags ), level._effect[ "cc_policeman_death" ] );
			ch_lapd delay_thread( n_thread_delay, ::drone_squib_fire_at_lapd, vh_drone );
		}
	}
}

drone_squib_fire_at_lapd( vh_drone )
{
	tag_origin = vh_drone GetTagOrigin( "tag_gear_nose" );
	
	v_offset = ( RandomIntRange( -100, 100 ), RandomIntRange( -100, 100 ), 0 );
	
	MagicBullet( "avenger_side_minigun_no_explosion", tag_origin, self.origin + v_offset );
}

spawn_drone_for_lapd_squibs( ch_lapd )
{
	n_spawn_yaw = AbsAngleClamp360( level.player.angles[ 1 ] + RandomIntRange( 90, 270 ) );
	
	v_drone_spawn_org = level.player.origin + ( AnglesToForward( ( 0, n_spawn_yaw, 0 ) ) * 3000 );
	v_drone_spawn_org = ( v_drone_spawn_org[0], v_drone_spawn_org[1], RandomIntRange( 2000, 3000 ) );
		
	v_drone_goto = ch_lapd.origin + (ch_lapd.origin - v_drone_spawn_org);
	v_drone_goto = ( v_drone_goto[0], v_drone_goto[1], RandomIntRange( 1000, 2000 ) );
		
	vh_drone = spawn_vehicle_from_targetname( "sam_drone" );
	vh_drone.origin = v_drone_spawn_org;
	
	vh_drone SetDefaultPitch( 10 );
	vh_drone SetForceNoCull();
	vh_drone SetNearGoalNotifyDist( 500 );
	vh_drone ent_flag_init( "straffing" );
	
	vh_drone SetVehGoalPos( v_drone_goto, 0 );
	
	vh_drone thread deleted_squib_drone_near_goal();
	
	return vh_drone;
}

deleted_squib_drone_near_goal()
{
	self waittill( "near_goal" );
	self Delete();
}