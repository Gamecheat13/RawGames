#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_scene.gsh;

main()
{	
	// section 3 anims
	event_7_anims();
	event_8_anims();
	event_9_anims();
	
	
	precache_assets();
	
	maps\voice\voice_pakistan_3::init_voice();
}

event_7_anims()
{
	//****************************************
	// land to water IGC jump anims
	add_scene( "land_to_water_jump", "soct_bigjump" );
	add_vehicle_anim( "player_soc_t", %vehicles::v_pakistan_7_3_land_to_water_soct01 );
	add_vehicle_anim( "salazar_soc_t", %vehicles::v_pakistan_7_3_land_to_water_soct02 );
	
	add_scene( "land_to_water_harper", "player_soc_t" );
	add_actor_anim( "harper", %generic_human::ch_pakistan_7_3_land_to_water_harper, true, true, false, true, "tag_gunner1" );
//	add_player_anim( "player_body", %player::p_pakistan_7_3_land_to_water_player, true );

	add_scene( "land_to_water_salazar", "salazar_soc_t" );
	add_actor_anim( "salazar", %generic_human::ch_pakistan_7_3_land_to_water_salazar, true, true, false, true, "tag_driver" );
	add_actor_anim( "han", %generic_human::ch_pakistan_7_3_land_to_water_redshirt, true, true, false, true, "tag_gunner1" );
	
	//****************************************
	// heli crash anims
	add_scene( "heli_approach", "soct_slant_bldg_jump" );
	add_vehicle_anim( "h_hind", %vehicles::v_pakistan_7_4_helo_crash_approach_hind );
	add_notetrack_custom_function( "h_hind", "start_fire", ::heli_start_shooting );
	
	add_scene( "heli_loop", "soct_slant_bldg_jump", false, false, true );
	add_vehicle_anim( "h_hind", %vehicles::v_pakistan_7_4_helo_crash_idle_hind );
	
	add_scene( "heli_crash", "soct_slant_bldg_jump" );
	//add_actor_anim( "heli_crash_driver", %generic_human::ch_pakistan_7_4_helo_crash_guy01, true, false, true );
	//add_actor_anim( "heli_crash_shooter", %generic_human::ch_pakistan_7_4_helo_crash_guy02, true, false, true );
	add_vehicle_anim( "h_hind", %vehicles::v_pakistan_7_4_helo_crash_hind, true );
	add_vehicle_anim( "heli_crash_soct", %vehicles::v_pakistan_7_4_helo_crash_soct, true );
	add_notetrack_custom_function( "h_hind", "end_fire", ::heli_end_shooting );
	add_notetrack_custom_function( "h_hind", "explode", ::heli_explosion );
	add_notetrack_custom_function( "heli_crash_soct", "explode", ::soct_explosion );
	
	//****************************************
	// event 7 custom AI anims
	add_scene( "di_billboard_right", "ai_billboard" );
	add_actor_anim( "di_billboard_1", %generic_human::ch_pakistan_7_1_drone_tutorial_billboard_guy01 );
	
	add_scene( "di_billboard_left", "ai_billboard" );
	add_actor_anim( "di_billboard_4", %generic_human::ch_pakistan_7_1_drone_tutorial_billboard_guy04 );
	
	add_scene( "di_billboard_side", "ai_billboard" );
	add_actor_anim( "di_billboard_3", %generic_human::ch_pakistan_7_1_drone_tutorial_billboard_guy03 );
	
	add_scene( "di_billboard_below", "ai_billboard" );
	add_actor_anim( "di_billboard_2", %generic_human::ch_pakistan_7_1_drone_tutorial_billboard_guy02 );
	
	add_scene( "di_glass_building", "ai_glassbreak" );
	add_actor_anim( "di_glass_building_1", %generic_human::ch_pakistan_7_1_drone_tutorial_glass_building_soldier01 );
	add_actor_anim( "di_glass_building_2", %generic_human::ch_pakistan_7_1_drone_tutorial_glass_building_soldier02 );
	add_prop_anim( "di_table", %animated_props::o_pakistan_7_1_drone_tutorial_glass_building_table, "anim_glo_dining_table_sq" );
	add_notetrack_custom_function( "di_table", "glass_break", ::drone_intro_glass_break );
	
	add_scene( "di_scaffolding_middle", "ai_scaffold" );
	add_actor_anim( "di_scaffolding_1", %generic_human::ch_pakistan_7_1_drone_tutorial_scafold_guy01 );
	add_actor_anim( "di_scaffolding_2", %generic_human::ch_pakistan_7_1_drone_tutorial_scafold_guy02 );
	add_actor_anim( "di_scaffolding_3", %generic_human::ch_pakistan_7_1_drone_tutorial_scafold_guy03 );
	
	add_scene( "di_scaffolding_left", "ai_balcony" );
	add_actor_anim( "di_scaffolding_4", %generic_human::ch_pakistan_7_1_drone_tutorial_scafold_guy04 );
	add_actor_anim( "di_scaffolding_5", %generic_human::ch_pakistan_7_1_drone_tutorial_scafold_guy05 );
}

event_8_anims()
{
	//****************************************
	// hangar anims
	add_scene( "hangar", "harper_faceburn" );
	add_actor_anim( "han", %generic_human::ch_pakistan_8_3_hangar_event_redshirt );
	add_actor_anim( "salazar", %generic_human::ch_pakistan_8_3_hangar_event_salazar );
//	add_prop_anim( "fake_soc_t",  %animated_props::v_pakistan_8_3_hangar_event_soct01, "veh_t6_mil_soc_t", true );
	add_vehicle_anim( "player_drone",  %vehicles::v_pakistan_8_3_hangar_event_drone, true );
	add_vehicle_anim( "player_soc_t",  %vehicles::v_pakistan_8_3_hangar_event_soct01 );
	add_vehicle_anim( "salazar_soc_t",  %vehicles::v_pakistan_8_3_hangar_event_soct02 );
	add_player_anim( "player_body", %player::p_pakistan_8_3_hangar_event_player, true );
	add_notetrack_custom_function( "player_drone", "explosion_small", ::drone_explosion_small );
	add_notetrack_custom_function( "player_drone", "explosion_big", ::drone_explosion_big );
	
	add_scene( "hangar_apache", "harper_faceburn" );
	add_vehicle_anim( "boss_apache",  %vehicles::v_pakistan_8_3_hangar_event_apache, true );
	add_notetrack_custom_function( "boss_apache", "explosion_big", ::face_burn_explosion );
	
	add_scene( "hangar_super_soct", "harper_faceburn" );
	add_actor_anim( "super_driver", %generic_human::ch_pakistan_8_3_hangar_event_enemydriver, true, false, true );
	add_actor_anim( "super_gunner", %generic_human::ch_pakistan_8_3_hangar_event_enemygunner, true, false, true );
	add_vehicle_anim( "boss_soct",  %vehicles::v_pakistan_8_3_hangar_event_soct03, true );
	add_notetrack_custom_function( "boss_soct", "explosion_big", ::face_burn_explosion );
	
	add_scene( "harper_burned", "harper_faceburn" );
	add_actor_anim( "harper", %generic_human::ch_pakistan_8_3_hangar_event_burned_harper );
	add_notetrack_custom_function( "harper", "burn_face", ::burn_harper_face );
	
	add_scene( "harper_not_burned", "harper_faceburn" );
	add_actor_anim( "harper", %generic_human::ch_pakistan_8_3_hangar_event_notburned_harper );
}

event_9_anims()
{
	//****************************************
	// standoff approach anims
	add_scene( "standoff_approach", "chinese_standoff" );
	add_actor_anim( "han", %generic_human::ch_pakistan_9_4_standoff_approach_redshirt );
	add_actor_anim( "salazar", %generic_human::ch_pakistan_9_4_standoff_approach_salazar );
	
	add_scene( "standoff_approach_soct", "chinese_standoff" );
	add_vehicle_anim( "player_soc_t", %vehicles::v_pakistan_9_4_standoff_approach_soct1 );
	add_vehicle_anim( "salazar_soc_t",  %vehicles::v_pakistan_9_4_standoff_approach_soct2 );
	
	add_scene( "standoff_approach_burned_harper", "chinese_standoff" );
	add_actor_anim( "harper", %generic_human::ch_pakistan_9_4_standoff_approach_burned_harper );
	
	add_scene( "harper_burned_walk", undefined, false, false, false, true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_9_4_harper_burned_walk );
	
	add_scene( "standoff_approach_not_burned_harper", "chinese_standoff" );
	add_actor_anim( "harper", %generic_human::ch_pakistan_9_4_standoff_approach_harper );
	
	add_scene( "standoff_approach_burned_player", "chinese_standoff" );
	add_player_anim( "player_body", %player::p_pakistan_9_4_standoff_approach_burned_player, true );
	
	add_scene( "standoff_approach_not_burned_player", "chinese_standoff" );
	add_player_anim( "player_body", %player::p_pakistan_9_4_standoff_approach_player, true );
	
	//****************************************
	// standoff idle anims
	add_scene( "standoff_idle_han", "chinese_standoff", false, false, true );
	add_actor_anim( "han", %generic_human::ch_pakistan_9_4_standoff_idle_redshirt );
	
	add_scene( "standoff_idle_salazar", "chinese_standoff", false, false, true );
	add_actor_anim( "salazar", %generic_human::ch_pakistan_9_4_standoff_idle_salazar );
	
	add_scene( "standoff_idle_burned", "chinese_standoff", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_9_4_standoff_burned_idle_harper );
	
	add_scene( "standoff_idle_not_burned", "chinese_standoff", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_pakistan_9_4_standoff_idle_harper );
	
	//****************************************
	// standoff anims
	add_scene( "standoff", "chinese_standoff" );
//	add_actor_anim( "han", %generic_human::ch_pakistan_9_4_standoff_redshirt );
//	add_actor_anim( "salazar", %generic_human::ch_pakistan_9_4_standoff_salazar );
	add_player_anim( "player_body", %player::p_pakistan_9_4_standoff_player, true );
	add_notetrack_custom_function( "player_body", "settle", ::standoff_settle );
	add_notetrack_custom_function( "player_body", "start_fade", ::next_mission );
	
	add_scene( "standoff_chinese_important", "chinese_standoff" );
	add_actor_anim( "chinese_1", %generic_human::ch_pakistan_9_4_standoff_chinese01 );
	add_actor_anim( "chinese_2", %generic_human::ch_pakistan_9_4_standoff_chinese02 );
	add_actor_model_anim( "zhao", %generic_human::ch_pakistan_9_4_standoff_zhao );
	
	add_scene( "standoff_burned", "chinese_standoff" );
	add_actor_anim( "harper", %generic_human::ch_pakistan_9_4_standoff_burned_harper );
	
	add_scene( "standoff_not_burned", "chinese_standoff" );
	add_actor_anim( "harper", %generic_human::ch_pakistan_9_4_standoff_burned_harper );
	
	//****************************************
	// soldier idles
	add_scene( "soldier_idle_chinese_1", undefined, false, false, true );
	add_actor_anim( "generic", %generic_human::ch_pakistan_9_4_standoff_soldier_idle_chin01 );
	
	add_scene( "soldier_idle_chinese_2", undefined, false, false, true );
	add_actor_anim( "generic", %generic_human::ch_pakistan_9_4_standoff_soldier_idle_chin02 );
	
	add_scene( "soldier_idle_chinese_3", undefined, false, false, true ); // crouch
	add_actor_anim( "generic", %generic_human::ch_pakistan_9_4_standoff_soldier_idle_chin03 );
	
	add_scene( "soldier_idle_seal_1", undefined, false, false, true ); // crouch
	add_actor_anim( "generic", %generic_human::ch_pakistan_9_4_standoff_soldier_idle_us01 );
	
	add_scene( "soldier_idle_seal_2", undefined, false, false, true );
	add_actor_anim( "generic", %generic_human::ch_pakistan_9_4_standoff_soldier_idle_us02 );
	
	add_scene( "soldier_idle_seal_3", undefined, false, false, true );
	add_actor_anim( "generic", %generic_human::ch_pakistan_9_4_standoff_soldier_idle_us03 );
	
	//****************************************
	// soldier reacts
	add_scene( "soldier_react_chinese_1" );
	add_actor_anim( "generic", %generic_human::ch_pakistan_9_4_standoff_soldier_react_chin01 );
	
	add_scene( "soldier_react_chinese_2" );
	add_actor_anim( "generic", %generic_human::ch_pakistan_9_4_standoff_soldier_react_chin02 );
	
	add_scene( "soldier_react_chinese_3" ); // crouch
	add_actor_anim( "generic", %generic_human::ch_pakistan_9_4_standoff_soldier_react_chin03 );
	
	add_scene( "soldier_react_seal_1" ); // crouch
	add_actor_anim( "generic", %generic_human::ch_pakistan_9_4_standoff_soldier_react_us01 );
	
	add_scene( "soldier_react_seal_2" );
	add_actor_anim( "generic", %generic_human::ch_pakistan_9_4_standoff_soldier_react_us02 );
	
	add_scene( "soldier_react_seal_3" );
	add_actor_anim( "generic", %generic_human::ch_pakistan_9_4_standoff_soldier_react_us03 );
	
	//****************************************
	// soldier settle
	add_scene( "soldier_settle_chinese_1" );
	add_actor_anim( "generic", %generic_human::ch_pakistan_9_4_standoff_soldier_settle_chin01 );
	
	add_scene( "soldier_settle_chinese_2" );
	add_actor_anim( "generic", %generic_human::ch_pakistan_9_4_standoff_soldier_settle_chin02 );
	
	add_scene( "soldier_settle_chinese_3" ); // crouch
	add_actor_anim( "generic", %generic_human::ch_pakistan_9_4_standoff_soldier_settle_chin03 );
	
	add_scene( "soldier_settle_seal_1" ); // crouch
	add_actor_anim( "generic", %generic_human::ch_pakistan_9_4_standoff_soldier_settle_us01 );
	
	add_scene( "soldier_settle_seal_2" );
	add_actor_anim( "generic", %generic_human::ch_pakistan_9_4_standoff_soldier_settle_us02 );
	
	add_scene( "soldier_settle_seal_3" );
	add_actor_anim( "generic", %generic_human::ch_pakistan_9_4_standoff_soldier_settle_us03 );
}

drone_intro_glass_break( m_table )
{	
	s_radius = getstruct( "glass_break_radius", "targetname" );
	RadiusDamage( s_radius.origin, 16, 100, 100, undefined, "MOD_PROJECTILE" );
}

heli_start_shooting( vh_heli )
{
	vh_heli notify( "shoot" );
}

heli_end_shooting( vh_heli )
{
	vh_heli notify( "stop_shooting" );
}

heli_explosion( vh_heli )
{
	v_tag_org = vh_heli GetTagOrigin( "tag_fx_flare" );
	PlayFX( level._effect[ "blockade_explosion" ], v_tag_org );
}

soct_explosion( vh_soct )
{
	vh_heli = GetEnt( "h_hind", "targetname" );
	PlayFX( level._effect[ "blockade_explosion" ], vh_heli GetTagOrigin( "tag_fx_flare" ) );
	
	vh_heli play_fx( "heli_crash_smoke_trail", vh_heli GetTagOrigin( "tag_fx_light_tail" ), vh_heli GetTagAngles( "tag_fx_light_tail" ), undefined, true, "tag_fx_light_tail" );
}

vehicle_explosion( vh_hangar )
{
	PlayFX( level._effect[ "blockade_explosion" ], vh_hangar.origin );
}

drone_explosion_small( vh_drone )
{
	PlayFX( level._effect[ "blockade_explosion" ], vh_drone.origin );
	vh_drone play_fx( "heli_crash_smoke_trail", vh_drone.origin, vh_drone.angles, undefined, true, "tag_origin" );
}

drone_explosion_big( vh_drone )
{
	exploder( 809 );
}

face_burn_explosion( vh_hangar )
{
	exploder( 810 );
}

burn_harper_face( ai_harper )
{
	ai_harper SetModel( "c_usa_cia_combat_harper_burned_fb" );
}

standoff_settle( m_player_body )
{
	level notify( "standoff_settle" );
}

next_mission( m_player_body )
{
	screen_fade_out( 0.5 );
	
	nextmission();
}