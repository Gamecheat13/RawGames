#include maps\_anim;
#include maps\_scene;
#include maps\_utility;
#include common_scripts\utility;

main()
{
	anim_load_frontend_global();
	anim_load_strikeforce();
	anim_load_strikeforce_responses();
	anim_load_ambient_scenes();
	
	precache_assets();
}

anim_load_ambient_scenes()
{
	add_scene_loop( "ambient_01", "align_frontend" );
	add_actor_model_anim( "amb01", %generic_human::ch_frontend_ambient_office1_guy1 );
	add_actor_model_anim( "amb02", %generic_human::ch_frontend_ambient_office1_guy2 );
	add_actor_model_anim( "amb03", %generic_human::ch_frontend_ambient_office1_guy3 );
	add_actor_model_anim( "amb04", %generic_human::ch_frontend_ambient_office1_guy4 );
	add_actor_model_anim( "amb05", %generic_human::ch_frontend_ambient_office1_guy5 );
		
	add_actor_spawner( "amb01", "gov" );
	add_actor_spawner( "amb02", "gov" );
	add_actor_spawner( "amb03", "gov" );
	add_actor_spawner( "amb04", "gov" );
	add_actor_spawner( "amb05", "gov" );
	
	add_scene_loop( "ambient_02", "align_frontend" );
	add_actor_model_anim( "amb01", %generic_human::ch_frontend_ambient_office2_guy1 );
	add_actor_model_anim( "amb02", %generic_human::ch_frontend_ambient_office2_guy2 );
	add_actor_model_anim( "amb03", %generic_human::ch_frontend_ambient_office2_guy3 );
	add_actor_model_anim( "amb04", %generic_human::ch_frontend_ambient_office2_guy4 );
	add_actor_model_anim( "amb05", %generic_human::ch_frontend_ambient_office2_guy5 );
	
	add_actor_spawner( "amb01", "gov" );
	add_actor_spawner( "amb02", "gov" );
	add_actor_spawner( "amb03", "gov" );
	add_actor_spawner( "amb04", "gov" );
	add_actor_spawner( "amb05", "gov" );
	
	add_scene_loop( "ambient_03", "align_frontend" );
	add_actor_model_anim( "amb01", %generic_human::ch_frontend_ambient_office3_guy1 );
	add_actor_model_anim( "amb02", %generic_human::ch_frontend_ambient_office3_guy2 );
	add_actor_model_anim( "amb03", %generic_human::ch_frontend_ambient_office3_guy3 );
	add_actor_model_anim( "amb04", %generic_human::ch_frontend_ambient_office3_guy4 );
	add_actor_model_anim( "amb05", %generic_human::ch_frontend_ambient_office3_guy5 );
	
	add_actor_spawner( "amb01", "gov" );
	add_actor_spawner( "amb02", "gov" );
	add_actor_spawner( "amb03", "gov" );
	add_actor_spawner( "amb04", "gov" );
	add_actor_spawner( "amb05", "gov" );
	
	add_scene_loop( "ambient_04", "align_frontend" );
	add_actor_model_anim( "amb01", %generic_human::ch_frontend_ambient_office4_guy1 );
	add_actor_model_anim( "amb02", %generic_human::ch_frontend_ambient_office4_guy2 );
	add_actor_model_anim( "amb03", %generic_human::ch_frontend_ambient_office4_guy3 );
	add_actor_model_anim( "amb04", %generic_human::ch_frontend_ambient_office4_guy4 );
	add_actor_model_anim( "amb05", %generic_human::ch_frontend_ambient_office4_guy5 );
	
	add_actor_spawner( "amb01", "gov" );
	add_actor_spawner( "amb02", "gov" );
	add_actor_spawner( "amb03", "gov" );
	add_actor_spawner( "amb04", "gov" );
	add_actor_spawner( "amb05", "gov" );
	
	add_scene_loop( "ambient_05", "align_frontend" );
	add_actor_model_anim( "amb01", %generic_human::ch_frontend_ambient_office5_guy1 );
	add_actor_model_anim( "amb02", %generic_human::ch_frontend_ambient_office5_guy2 );
	add_actor_model_anim( "amb03", %generic_human::ch_frontend_ambient_office5_guy3 );
	add_actor_model_anim( "amb04", %generic_human::ch_frontend_ambient_office5_guy4 );
	add_actor_model_anim( "amb05", %generic_human::ch_frontend_ambient_office5_guy5 );
	
	add_actor_spawner( "amb01", "gov" );
	add_actor_spawner( "amb02", "gov" );
	add_actor_spawner( "amb03", "gov" );
	add_actor_spawner( "amb04", "gov" );
	add_actor_spawner( "amb05", "gov" );
}

anim_load_frontend_global()
{
	add_scene( "glasses_on", "player_align_node", false, false, false );
	add_player_anim( "player_body",	%player::int_sunglasses_on_frontend );
	add_prop_anim( "glasses", %animated_props::o_sunglasses_on_frontend, "p6_sunglasses", true, false);
	add_notetrack_flag("player_body", "glasses_on", "glasses_on");
	add_notetrack_flag("player_body", "glasses_tint", "glasses_tint");
	add_notetrack_flag("player_body", "tint_gone", "tint_gone");
	add_notetrack_flag("player_body", "holotable", "holotable_on");
	add_notetrack_flag("player_body", "headsupdisplay", "headsupdisplay");
		
	add_scene_loop( "data_glove_idle", "player_align_node", false, false, false );
	add_player_anim( "player_body", %player::int_data_glove_gameselect_idle );

	add_scene( "data_glove_start", "player_align_node", false, false, false, false );
	add_player_anim( "player_body", %player::int_data_glove_gameselect_pullout );
	
	add_scene( "data_glove_start_fast", "player_align_node", false, false, false, false );
	add_player_anim( "player_body", %player::int_data_glove_pullout_alt );
	
	add_scene( "data_glove_input", "player_align_node", false, false, false, false );
	add_player_anim( "player_body", %player::int_data_glove_gameselect_input );
	
	add_scene( "data_glove_finish", "player_align_node", false, false, false, false );
	add_player_anim( "player_body", %player::int_data_glove_gameselect_putaway, true );
}

anim_load_strikeforce_responses()
{
	// negative responses

	add_scene( "briggs_rts_negative_1", "align_frontend" );
	add_actor_anim( "briggs", %generic_human::ch_frontend_briggs_debrief_negative );
	add_player_anim( "player_body", %player::p_frontend_player_debrief_negative, false, 0, undefined, true, 1, 25, 25, 15, 15 );
	
	add_scene( "briggs_rts_negative_exit", "align_frontend" );
	add_actor_anim( "briggs", %generic_human::ch_frontend_briggs_debrief2_table_negative );
	add_player_anim( "player_body", %player::p_frontend_player_debrief2_table_negative, false, 0, undefined, true, 1, 25, 25, 15, 15 );	
	
	// positive responses
	
	add_scene( "briggs_rts_positive_1", "align_frontend" );
	add_actor_anim( "briggs", %generic_human::ch_frontend_briggs_debrief_positive );
	add_player_anim( "player_body", %player::p_frontend_player_debrief_positive, false, 0, undefined, true, 1, 25, 25, 15, 15 );
	
	add_scene( "briggs_rts_positive_exit", "align_frontend" );
	add_actor_anim( "briggs", %generic_human::ch_frontend_briggs_debrief2_table_positive );
	add_player_anim( "player_body", %player::p_frontend_player_debrief2_table_positive, false, 0, undefined, true, 1, 25, 25, 15, 15 );
}

anim_load_strikeforce()
{
	{
		add_scene( "sf_player_intro", "align_war_room" );
		add_player_anim( "player_body", %player::p_war_hub_a_intro_player, false, 0, undefined, true, 1, 25, 25, 15, 15 );
		add_actor_anim( "briggs", %generic_human::ch_war_hub_a_intro_briggs );
		
		add_scene( "sf_table_to_corner", "align_frontend" );
		add_player_anim( "player_body", %player::p_frontend_mapchoice_exit_idle, true, 0, undefined, true, 1, 25, 25, 15, 15 );
		
		add_scene( "sf_corner_to_table", "align_frontend" );
		add_player_anim( "player_body", %player::p_frontend_mapchoice_enter_idle, false, 0, undefined, true, 1, 25, 25, 15, 15 );
		
		add_scene( "sf_player_choice", "align_war_room", false, false, true );
		add_player_anim( "player_body", %player::p_war_hub_a_idle_player, false, 0, undefined, true, 1, 25, 25, 15, 15 );
		
		add_scene( "sf_briggs_idle", "align_war_room", false, false, true );
		add_actor_anim( "briggs", %generic_human::ch_war_hub_a_idle_briggs );
		
		add_scene( "sf_a_player_reenter", "align_frontend" );
		add_player_anim( "player_body", %player::p_frontend_mapchoice_enter, false, 0, undefined, true, 1, 25, 25, 15, 15 );
	}
	
	{
		add_scene( "sf_audience_intro", "align_frontend" );
		add_actor_model_anim( "gov01", %generic_human::ch_frontend_ambient_team_idle_guy1 );
		add_actor_model_anim( "gov02", %generic_human::ch_frontend_ambient_team_idle_guy2 );
		add_actor_model_anim( "gov03", %generic_human::ch_frontend_ambient_team_idle_guy3 );		
		add_actor_model_anim( "seal01", %generic_human::ch_frontend_ambient_team_idle_guy4 );
		add_actor_model_anim( "seal02", %generic_human::ch_frontend_ambient_team_idle_guy5 );		
		add_actor_spawner( "gov01", "gov" );
		add_actor_spawner( "gov02", "gov" );
		add_actor_spawner( "gov03", "gov" );
		add_actor_spawner( "seal01", "gov" );
		add_actor_spawner( "seal02", "gov" );
	}

	{			
		add_scene( "sf_audience_loop", "align_frontend", false, false, true );
		add_actor_model_anim( "gov01", %generic_human::ch_frontend_ambient_team_idle_guy1, undefined, false, undefined, undefined, "" );
		add_actor_model_anim( "gov02", %generic_human::ch_frontend_ambient_team_idle_guy2 );
		add_actor_model_anim( "gov03", %generic_human::ch_frontend_ambient_team_idle_guy3 );
		add_actor_model_anim( "seal01", %generic_human::ch_frontend_ambient_team_idle_guy4 );
		add_actor_model_anim( "seal02", %generic_human::ch_frontend_ambient_team_idle_guy5 );
		add_actor_spawner( "gov01", "gov" );
		add_actor_spawner( "gov02", "gov" );
		add_actor_spawner( "gov03", "gov" );
		add_actor_spawner( "seal01", "gov" );
		add_actor_spawner( "seal02", "gov" );
		
		add_scene( "sf_audience_exit", "align_frontend" );
		add_actor_model_anim( "gov01", %generic_human::ch_frontend_team_exit_guy1 );
		add_actor_model_anim( "gov02", %generic_human::ch_frontend_team_exit_guy2 );
		add_actor_model_anim( "gov03", %generic_human::ch_frontend_team_exit_guy3 );
		add_actor_model_anim( "seal01", %generic_human::ch_frontend_team_exit_guy4 );
		add_actor_model_anim( "seal02", %generic_human::ch_frontend_team_exit_guy5 );
		add_actor_spawner( "gov01", "gov" );
		add_actor_spawner( "gov02", "gov" );
		add_actor_spawner( "gov03", "gov" );
		add_actor_spawner( "seal01", "gov" );
		add_actor_spawner( "seal02", "gov" );
	}
	
	{
		add_scene( "so_rts_mp_dockside_briefing", "align_frontend" );
		add_player_anim( "player_body", %player::p_frontend_singapore_player, true, 0, undefined, true, 1, 25, 25, 15, 15 );
		add_actor_anim( "briggs", %generic_human::ch_frontend_singapore_briggs );
		
		add_scene( "so_rts_mp_carrier_briefing", "align_frontend" );
		add_player_anim( "player_body", %player::p_frontend_singapore_player, true, 0, undefined, true, 1, 25, 25, 15, 15 );
		add_actor_anim( "briggs", %generic_human::ch_frontend_singapore_briggs );
		
		add_scene( "so_rts_afghanistan_briefing", "align_frontend" );
		add_player_anim( "player_body", %player::p_frontend_singapore_player, true, 0, undefined, true, 1, 25, 25, 15, 15 );
		add_actor_anim( "briggs", %generic_human::ch_frontend_singapore_briggs );
		
		add_scene( "so_rts_mp_drone_briefing", "align_frontend" );
		add_player_anim( "player_body", %player::p_frontend_singapore_player, true, 0, undefined, true, 1, 25, 25, 15, 15 );
		add_actor_anim( "briggs", %generic_human::ch_frontend_singapore_briggs );
		
		add_scene( "so_rts_mp_socotra_briefing", "align_frontend" );
		add_player_anim( "player_body", %player::p_frontend_singapore_player, true, 0, undefined, true, 1, 25, 25, 15, 15 );
		add_actor_anim( "briggs", %generic_human::ch_frontend_singapore_briggs );
		
		add_scene( "so_rts_mp_overflow_briefing", "align_frontend" );
		add_player_anim( "player_body", %player::p_frontend_singapore_player, true, 0, undefined, true, 1, 25, 25, 15, 15 );
		add_actor_anim( "briggs", %generic_human::ch_frontend_singapore_briggs );
	}
}
