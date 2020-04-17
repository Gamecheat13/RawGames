//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					m60_rescue (E3 DEMO!)
//	Insertion Points:	(or ice3)	- Beginning
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

global short s_bishop_fly = 0;
global object g_ics_player = NONE;
global boolean b_cov_intro_done = false;
global boolean b_ff_vision_done = false;
global boolean b_knights_shoot_player = false;
global boolean b_ranger_go = false;
global boolean b_pawn_swarm_go = false;
global boolean b_pawn_log_go = false;
global boolean b_pawn_rock_show = false;
global boolean b_ranger_rear = false;
global boolean b_knight_attack_done = false;
global boolean b_knight_bishop_move_back = false;
global boolean b_pawn_pf_retreat = false;
global boolean b_fighter_show_done = false;
global boolean b_bishop_chase_line = false;
global boolean b_ranger_spawned = false;
global boolean b_pack_attack_player = false;
global boolean b_battlewagon_go = false;
global boolean b_infinity_dialog = false;


script dormant f_e3_demo


	if (not editor_mode()) 	then
	
	cinematic_enter( e3_start_m30, TRUE );
	cinematic_suppress_bsp_object_creation( TRUE );
	switch_zone_set("cinematic_zoneset");
	sleep_until( current_zone_set_fully_active() == 5, 1 );
	
	cinematic_suppress_bsp_object_creation( FALSE );
	
	hud_play_global_animtion (screen_fade_out);
	
	f_start_mission( e3_start_m30 );
	cinematic_exit_no_fade( e3_start_m30, TRUE ); 
	
	switch_zone_set("peak");
	sleep_until( current_zone_set_fully_active() == 0, 1 );
	
	fade_in(0,0,0,1);
	thread (f_audio_unmute_guns());
	
	end 
	

	// DISPLAY TEXT
	//dialog_line_temp_blurb_force_set(TRUE);

	//fade_out (0, 0, 0, 1);
	//hud_play_global_animtion (screen_fade_out);
	
	print ("deathless on");
	cheat_deathless_player = 1;
	cheat_infinite_equipment_energy = 1;
	//cheat_infinite_ammo = 1;
	cheat_omnipotent = 0;
	
	//hud_stop_global_animtion (screen_fade_out);

	wake (f_e3_pawn);
	wake (f_e3_pawn_hint_starter);

	wake (f_e3_knight_attack);
	wake (f_e3_covenant_attack);
	wake (f_pawn_pack);
	wake (f_picked_up_forerunner_rifle);
	wake (f_narrative_infinity_callback);
	wake (f_raise_weapon);
	wake (f_dialog_elite);
	wake (f_second_trails_sound);
	wake (f_over_enter);
	
	//gui_stop();
	//gui_reset();

	hud_play_global_animtion (screen_fade_in);
	//hud_stop_global_animtion (screen_fade_in);
	
	//player_set_profile (profile_xp, player0);
	
	wake (f_pick_up_forerunner_vision);
	//fade_in(0,0,0,1);
	
	//players_weapon_down( 0, 1.0 / 30, TRUE );
	//sleep (30);
	
	chud_show_crosshair( FALSE );
	hud_show_crosshair( FALSE );
	unit_lower_weapon( player0, 1.0 / 30 );
	
	//fade_in (0, 0, 0, 30);
	//fade_out(0, 0, 0, 1);s
	sleep_until (volume_test_players (e3_air_spawn), 1);
		
	//fade_in (0, 0, 0, 30 * 5);

	//unit_lower_weapon (player0, 1);
	

	
	unit_add_equipment (player0, profile_0, FALSE, FALSE);
	
	effect_attached_to_camera_new(environments\solo\m60_rescue\fx\ambient_life\forest_player_gnats.effect);

	g_ics_player = player0;
	//sleep (1 * 60);
	
	//temp
	//story_blurb_add("vo", "CORTANA TALKS ABOUT THE INFINITY" );
		
	//pup_play_show(air_show);
	//ai_place (sq_e3_amb_air_banshee);
	
	sleep_until (volume_test_players (tv_dialog_starter), 1);
	print ("dialog starter");
	wake (f_dialog_infinity_start);
	pup_play_show(air_show);
	
	sleep (1 * 60);
	
	//wake (cortana_infinity_comment); 
	
	//print ("Spawn Air - phnatoms");
	//ai_place (sq_e3_amb_air_phantom);
	
	
	
	//sleep (2.25 * 60);
	//temp
	//story_blurb_add("vo", "CORTANA TALKS ABOUT THE COVENANT" );
end

script dormant f_raise_weapon
	
	sleep_until (volume_test_players (tv_raise_weapon) or volume_test_players (tv_raise_weapon_all), 1); 
	print ("raise weapon");
	//players_weapon_down( 0, 1.1, FALSE);
	//object_hide (secret_br, FALSE);
	//unit_add_equipment (player0, profile_1, FALSE, TRUE);
	//unit_raise_weapon (player0, 30 * 1.1);
	
	//player_set_profile (profile_0, player0);
	
	unit_raise_weapon (player0, 30 * 1.1);
	
	sleep (30 * 1.1);
	
	chud_show_crosshair( TRUE );
	hud_show_crosshair( TRUE );
	
	//unit_add_equipment (player0, profile_xp, FALSE, FALSE);
	
	sleep (30);
	
	
	wake (f_disable_reticle_kr);
	wake (f_disable_reticle_sg);

end

script dormant f_e3_covenant

		//play_bink_movie("032_ending"); 
		//sleep(30 * 93);

		//play_bink_movie("060_opening"); 
		//sleep(30 * 55);

		
		sleep_until (volume_test_players (e3_covenant_spawn), 1);
		
		print ("spawn covenant");
		
		ai_place (sg_covenant);
		
		print ("waiting for grunts and jackal to die");
		sleep_until (ai_living_count (sq_e3_covenant) < 1);
		print ("elite charge now");
		sleep (30 * 0.5);
		ai_berserk(sq_e3_elite, true);   
		ai_place (sq_e3_knight_1);
		sleep (30 * 1);
		
		
end

script dormant f_e3_covenant_attack

		sleep_until (volume_test_players (tv_e3_covenant_attack), 1);
		pup_play_show(cov_intro_xp);
		
		
		//sleep_until (b_cov_intro_done == true);
		
		wake (f_phase_out); 

		//wake (cortana_after_derez);
end


script dormant f_e3_pawn

	sleep_until (volume_test_players (e3_pawn_spawn), 1);
	
	print ("Pawn Trigger");
	
	thread (f_mus_m60_e3_e02_begin());
	
	pup_play_show(hero_pawn_xp);
	
	//wake (f_dialog_crawler_intro);
	
	
	/*sleep_until (b_pawn_swarm_go == true);
	
	wake (f_tp_a_1);
	wake (f_tp_a_2);
	wake (f_tp_a_3);
	//wake (f_tp_a_4);
	wake (f_tp_a_5);
	wake (f_tp_a_6);
	wake (f_tp_a_7);
	ai_place (sq_e3_pawn_amb_2);*/

	sleep_until (b_pawn_log_go == true);
	
	sleep (30 * 0.5);
	
	ai_place (sq_e3_pawn_log_1);
	ai_place (sq_e3_pawn_ground);
	sleep (30 * 0.5);
	ai_place (sq_e3_pawn_log_2);
	sleep (30 * 2);
	
	ai_place (sq_e3_pawn_log_stay);	
	//ai_place (sq_e3_pawn_log_left);
	
	ai_place (sq_e3_rock_pawn);
	
	//sleep (30 * 1.5);
	//wake (f_dialog_crawler_intro);
	
	
	sleep_until (ai_living_count (sg_pawns_intro) < 1);
	
	thread (f_mus_m60_e3_e02_finish());
	wake (f_dialog_crawler_end);
	sleep (30 * 1);
	thread (f_audio_knight_scream_for_crawlers());

	
	
	sleep_until (volume_test_players (tv_cure_rock_pawn), 1);
	ai_set_blind (sq_e3_rock_pawn, false);
	ai_set_deaf (sq_e3_rock_pawn, false);	
	
	wake (f_pawn_pf);
	
	pup_play_show(rock_pawn);
	
	cheat_omnipotent = 1;
	
	sleep_until (ai_living_count (sq_e3_rock_pawn) < 1);
	
		
	cheat_omnipotent = 0;
		
	//wake (f_dialog_sound_story_2);
	
	//sleep_until (volume_test_players (tv_temp_default_1), 1);
	//render_default_lighting = 1;
	


end


script dormant tv_knight_shield_pop()

	sleep_until (unit_get_shield (sq_e3_knight_2_fight) < 0.25, 1);
	print ("pop");
	cs_run_command_script(sq_e3_knight_2_fight,cs_e3_knight_2_fake_berserk);
	
	//CreateDynamicTask(TT_PROTECT, FT_PROTECTOR, ai_get_object(sq_e3_knight_2_fight), scriptCallback, 0);
	
end

script dormant f_second_trails_sound

	sleep_until (volume_test_players (tv_second_trails_sound), 1);
	print ("second sound");
	thread (f_audio_second_threat());

end

script dormant f_objective_blip

	//chud_show_screen_training (player0, chtitlee3obj);
	sleep (30 * 4);
	//sound_impulse_start (sound\game_sfx\ui\transition_beeps, NONE, 1);
	//cinematic_set_title (dash1);
	//sleep (30 * 1);
//	sound_impulse_start (sound\game_sfx\ui\transition_beeps, NONE, 1);
//	cinematic_set_title (dash2);
	//sleep (30 * 1);
	wake (f_waypoint);
//	sound_impulse_start (sound\game_sfx\ui\transition_beeps, NONE, 1);
	//cinematic_set_title (new_obj);
	//sleep (30 * 4);
//	sound_impulse_start (sound\game_sfx\ui\transition_beeps, NONE, 1);
	//cinematic_set_title (chtitlee3obj);
end

script dormant f_pawn_pf

	ai_place (sq_pf_1);
	ai_place (sq_pf_2);

	
	sleep(30 * 0.5);
	
	ai_place (sq_pf_3);
	ai_place (sq_pf_4);
	
	sleep_until (volume_test_players (tv_pf_jump), 1);
	
	//wake (f_dialog_pf_play_1);

	s_cortana_talk = 3;

	pup_play_show(pawn_pf_jump);

	//sleep(30);
	ai_place (sq_pf_5);
	
	ai_place (sq_pf_6);
	
	sleep_until (ai_living_count (sq_pf_jump) < 1);
	
//	b_pack_attack_player = false;
		
	//sleep_until (volume_test_players (tv_pawn_pf_retreat), 1);
	
	//sleep_until (ai_living_count (sg_pf) <= 6);	
	
	sleep (30 * 0.75);
	
	//thread (story_blurb_add("cutscene", "KNIGHT SCREAM IS HEARD"));
	
	thread (f_audio_knight_scream_for_crawler_retreat());

	//sleep(30);
	
	
	//b_pawn_pf_retreat = true;
	
	//pup_play_show(pawn_fighters);
	
	
	//sleep_until (b_fighter_show_done == true);
	
	cs_run_command_script(sq_pf_1,cs_pawn_pf_roar_1);
	//cs_run_command_script(sq_pf_2,cs_pawn_pf_roar_1a);
	cs_run_command_script(sq_pf_3,cs_pawn_pf_roar_3a);
	cs_run_command_script(sq_pf_4.p1,cs_pawn_pf_roar_4);
	cs_run_command_script(sq_pf_4.p2,cs_pawn_pf_roar_5);
	cs_run_command_script(sq_pf_5.p1,cs_pawn_pf_roar_6);
	cs_run_command_script(sq_pf_5.p2,cs_pawn_pf_roar_4);
	cs_run_command_script(sq_pf_6.p1,cs_pawn_pf_roar_2);
	cs_run_command_script(sq_pf_6.p2,cs_pawn_pf_roar_1);
				

	sleep (30 * 1);
	
	wake (f_dialog_pf_play_2);
	
	s_cortana_talk = 4;
	

end



script dormant f_pawn_pack

	sleep_until (volume_test_players (tv_pawn_pack), 1);
	
	print ("Pawn Pack");
	
	ai_place (sq_pawn_pack);
	//ai_place (sq_pawn_pack_2);
	
	//sleep_until (volume_test_players (tv_sound_story_2), 1);
	//wake (f_dialog_sound_story_2);

end

script static void f_end_set_equipment()

	player_set_equipment(player0,none,false,true,true);

end

script dormant f_e3_pawn_hint_starter

	sleep_until (volume_test_players (tv_pawn_1), 1);
	  pup_play_show(hint_pawns);
	  
	  
		sleep_until (volume_test_players (tv_sound_story_1), 1);
		//wake (f_dialog_sound_story_1);
		s_cortana_talk = 2;
		
	//ai_place (sq_e3_pawn_hint_1);

end

script dormant f_e3_pawn_3

	sleep_until (volume_test_players (tv_pawn_3), 1);

	ai_place (sq_e3_pawn_hint_2);
	print ("Pawn start");

end



script dormant f_contact

	sleep_until (volume_test_players (tv_contact), 1);
  wake (f_dialog_cortana_contact);
  
end

script dormant f_e3_knight_attack

	wake (f_contact);

  sleep_until (volume_test_players (tv_knight_attack), 1);
  pup_play_show(knight_attack);
  wake (tv_knight_shield_pop);
  ai_allow_resurrect(sq_e3_knight_2_fight, false);
  
  print ("waiting for knight to die");
	sleep_until (ai_living_count (sq_e3_knight_2_fight) < 1);
	print ("fly away bishop");
	//sleep_s(1);

        thread (f_mus_m60_e3_e03_begin());	
  
	cs_run_command_script(sq_e3_bishop_1.bishop,cs_bishop_helper);
	
	s_cortana_talk = 5;
	
	//s_bishop_fly = 1;
	
	sleep (30 * 3.5);
	// Cortana : On the ground. It dropped something.
	dprint ("Cortana: On the ground. It dropped something.");
	sound_impulse_start ('sound\dialog\mission\e3_demo\e3_demo_00129a', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\mission\e3_demo\e3_demo_00129a'));

	dprint("waiting for bishop to reach shard");
	
	wake (f_grenade_bishop_death);

	sleep_until (volume_test_object (tv_bishop_at_shard, (ai_get_unit (sq_e3_bishop_1.bishop))));
	
	thread (f_mus_m60_e3_e03_finish());
	
	cheat_omnipotent = 1;
	
	thread (f_mus_m60_e3_e04_final_begin());
		
	dprint("shard spawn");
	ai_set_blind (sq_e3_bishop_1.bishop,false);
	ai_set_deaf (sq_e3_bishop_1.bishop,false);
	ai_place_with_shards(pawns_shards);
	
	dprint("Placing pawns with shards");
	ai_cannot_die (sq_e3_bishop_1.bishop, false);
	
	
	
	s_cortana_talk = 6;
	
	sleep(3 * 30);
	ai_place(pawns_ranger);
	
	sleep(2 * 30);
	//s_bishop_fly = 3;

	sleep_until (volume_test_players (tv_e3_knight_3_spawn), 1);
	
	print ("waiting to look");
	sleep_until (volume_test_players_lookat (tv_ranger_lookat, 45, 1), 1);
	
	cheat_omnipotent = 0;
	
	//sleep (30 * 1);

	print ("SPAWNED");
	ai_place_in_limbo (sq_e3_knight_ranger);
	ai_allow_resurrect(sq_e3_knight_ranger, false);
	sleep (30);
	
	
	
	//sleep_until (ai_living_count (pawns_shards) < 1);
	
	b_ranger_rear = true;
	
	sleep_until ((ai_living_count (pawns_ranger) < 1) and (ai_living_count (pawns_shards) < 1));

	print (":: Go Ranger ::");
	
	//cs_phase_to_point (sq_e3_knight_ranger, 1, e3_ranger_distance.p0);
	
	wake (f_ranger_omni);
	
	sleep (15);
	ai_advance_immediate(sq_e3_knight_ranger);
	
	b_ranger_rear = false;
	
	//sleep_until (ai_living_count (sq_e3_knight_ranger) < 1);
	
	local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "Battlewagon Jump Attack", l_dialog_id, not dialog_foreground_id_active_check(L_dlg_battlewagon_jump_attack), DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );
	
	/*sleep_until (volume_test_players (tv_spread_gun), 1);	
		
	ai_place (sq_e3_knight_battlewagon);
		
	sleep_until (unit_has_weapon (player0, objects\weapons\rifle\storm_spread_gun\storm_spread_gun.weapon), 1);
	
	sleep_until (ai_combat_status(sq_e3_knight_battlewagon) >= 5);
	ai_advance_immediate(sq_e3_knight_battlewagon);
	
	sleep (30 * 1.6); */
	
	sleep_until (volume_test_players (tv_spread_gun), 1);	
		
	ai_place (sq_e3_knight_battlewagon);
		
	sleep_until (unit_has_weapon (player0, objects\weapons\rifle\storm_spread_gun\storm_spread_gun.weapon), 1);
	
	//wake (f_disable_reticle_sg);
	
	b_battlewagon_go = true;
	
	sleep (30 * 1.75);
	
	print ("Lookout!");
	
	sys_dialog_line_thread( l_dialog_id, 0, DEF_DIALOG_SPEAKER_ID_CORTANA(), 'sound\dialog\mission\e3_demo\e3_demo_00137', FALSE, NONE, 0.0, "Cortana : Look out!" );


  thread (f_mus_m60_e3_e04_final_finish());
	
	//cheat_omnipotent = 1;
	//sleep(1 * 30);
	//s_bishop_fly = 3;
	
	//ai_place (sq_e3_knight_battlewagon);
	//ai_allow_resurrect(sq_e3_knight_battlewagon, false);
	
	//sleep(1 * 30);
	//ai_advance_immediate(sq_e3_knight_3_left);
	
	//sleep_until (ai_living_count (sq_e3_knight_battlewagon) < 1);
	//object_create (aa_vision_drop);

	//sleep_until (ai_living_count (sq_e3_bishop_1) < 1);
	//sleep(1 * 30);
	//ai_place (sg_pawn_pack_over);
	//sleep_until (ai_living_count (sg_pawn_pack_over) < 1);
	//	sleep(2 * 30);
	
	//sleep(2.5 * 30);
	//thread (story_blurb_add("domain", "CORTANA TELLS CHEIF TO PICKUP FORERUNNER TECH"));
	//sleep(2 * 30);
	//f_blip_object( aa_vision_drop, "activate" );

end

script dormant f_ranger_omni 

	sleep_until (volume_test_object (tv_ranger_here_1, (ai_get_unit (sq_e3_knight_ranger.ranger))));
	
	print ("Ranger Here 1");
	
	sleep_until (volume_test_object (tv_ranger_here_2, (ai_get_unit (sq_e3_knight_ranger.ranger))));
	
	print ("Ranger Here 2");

	cheat_omnipotent = 1;

end



script dormant f_drop_f_rifle

		print ("waiting to drop");
		//sleep_until (ai_living_count (sq_e3_pawn_4) < 1);
		print ("drop rifle");
		
		object_create (e3_fr_rifle);
		
end



script dormant f_grenade_bishop_death

		print ("waiting to drop grenade");
		sleep_until (ai_living_count (sq_e3_bishop_1) < 1);
		sleep (30 * 0.9);
		print ("drop rifle");
		
		damage_new (objects\weapons\grenade\storm_frag_grenade\damage_effects\storm_frag_grenade_explosion.damage_effect, flag_bishop_death);
		effect_new (objects\weapons\grenade\storm_frag_grenade\fx\detonation.effect, flag_bishop_death);
		
end

script dormant f_phase_out

		
		//sleep_until (volume_test_players (tv_phase_out_starter), 1);	
				print ("waiting to Phase Out");
		
		sleep_until (volume_test_players_lookat (tv_phase_out, 90, 1), 1);
		print ("Phase Out");
		effect_new (objects\characters\storm_knight\fx\phase_teleport\knight_spawn_in_e3.effect, flag_phase_out);
		
		
		//effect_new_on_object_marker (objects\characters\storm_elite_ai\fx\derez\derez_smoke_e3.effect, pup_current_puppet,shield_recharge);


end

script dormant f_over_enter

		
		/*sleep_until (b_ff_vision_done == true);
		sleep(1 * 30);
		
		thread (story_blurb_add("cutscene", "INFINITY CALL BACK HERE"));
		Hud_play_pip("TEMP_PIP_INFINITY");
		sleep_s (4);
		Hud_play_pip("");
	
		
		//print ("Over Start");
		//ai_place(pawn_pack_loop);*/
		
		//ai_place (sg_pawn_pack_over);
		//wake (f_spawn_pawn_over);
		
		//OLD
		/*sleep_until (volume_test_players (tv_jumped_down), 1);	
		
		s_cortana_talk = 8;
		
		ai_place_in_limbo (knight_pack.first_in); 
		
		sleep_until (volume_test_players (tv_knight_pack), 1);	
		
		wake (f_spawn_knight_pack);
		wake (f_spawn_pawn_over); */
		
		sleep_until (volume_test_players (tv_jumped_down), 1);	
		
		wake (f_dialog_cortana_visor);
		wake (f_infinity_dialog_over);
		thread (f_audio_chief_jumped_down_into_fog());
		
		//ai_Place (sq_head_fake);
		pup_play_show(fog_squad);
		//wake (f_jumped_down_story);
		
		 wake (f_stop_moving);
		
		sleep_until (player_action_test_equipment());
		thread (f_audio_activate_forerunner_vision());
		
		sleep (30 * 0.5);
		pup_play_show(head_fake);
		
		/*sleep (30 * 1);
		
		object_create(hf_1a);
		sleep (30 * 1);
		object_hide(hf_1a, true);
		object_create(hf_1b);
		sleep (30 * 1);
		object_hide(hf_1b, true);
		
		wake (f_hf_1);
		wake (f_hf_2);*/
		
		sleep (30 * 3.3);
		
		wake (f_spawn_knight_pack);
end	
	
script dormant f_jumped_down_story

	sleep (30 * 1);
	//thread (story_blurb_add("cutscene", "The Sounds of Forerunners are heard"));
	sleep (30 * 2);
	//thread (story_blurb_add("domain", "CORTANA: Movement! [PLACEHOLDER]"));
	sleep (30 * 4.5);
	//thread (story_blurb_add("domain", "CORTANA: Use vision Cheif [PLACEHOLDER]"));


end

global boolean g_knight_end	= false;

script dormant f_spawn_knight_pack


	//overwhelm here
		
		
		thread (f_mus_overwhelm_begin());
		
		ai_erase (sg_pawn_pack_over);
		//sleep (30 * 0.5);
		
		ai_place_in_limbo (knight_pack.p1);
		sleep (30 * 0.5);
		
		ai_place_in_limbo (knight_pack.p10);
		sleep (30 * 0.35);

		ai_place_in_limbo (knight_pack.first_in);
		pup_play_show(pawn_over);
		sleep (30 * 0.5);
		
		//ai_place_in_limbo (knight_pack.p5);
		ai_place_in_limbo (knight_pack.p12);
		//wake (f_dialog_overwhelm);
		sleep (30 * 0.35);
		
		//ai_place_in_limbo (knight_pack.p12);
		ai_place_in_limbo (knight_pack.p5);
		sleep (30 * 0.35);
		
		//ai_place_in_limbo (knight_pack.p11);
		ai_place_in_limbo (knight_pack.p7);
		sleep (30 * 0.35);
		
		//ai_place_in_limbo (knight_pack.p6);
		ai_place_in_limbo (knight_pack.p2);
		sleep (30 * 0.35);
		
		ai_place_in_limbo (knight_pack.p3);
		sleep (30 * 0.35);
		
		ai_place_in_limbo (knight_pack.p6);	
		sleep (30 * 0.8);

		g_ics_player = player0;
		g_knight_end = false;
		sleep (30 * 0.2);
		local long show=pup_play_show(knight_end);
		
		
		sleep (82);
		//sleep_until(g_knight_end == true);

		b_knights_shoot_player = true;
				
		thread (f_mus_overwhelm_finish());
		thread (f_audio_mute_guns());
		
		//sleep (2);
		
		data_mine_upload();
		
		
		sleep (2);
		cui_load_screen('environments\solo\m10_crash\ui\oyo_title.cui_screen' );
		
		sleep (30 * 6);
		
		game_won();
		
				

end

script dormant f_spawn_pawn_over
	//object_create (po_1);
	sleep (30 * 0.5);
	//object_create (po_2);
		sleep (30 * 0.5);
	//object_create (po_8);
	sleep (30 * 0.5);			
	//object_create (po_3);
		sleep (30 * 0.5);
	//object_create (po_9);
	sleep (30 * 0.5);
	object_create (po_4);
		sleep (30 * 0.5);
	//object_create (po_10);
	sleep (30 * 0.5);	
	//object_create (po_5);
		sleep (30 * 0.5);
	//object_create (po_11);
	sleep (30 * 0.5);	
	//object_create (po_6);
		sleep (30 * 0.5);
	//object_create (po_12);
	sleep (30 * 0.5);	
	//object_create (po_13);
	sleep (30 * 0.5);
	//object_create (po_14);
	
		
end

script dormant f_picked_up_forerunner_rifle
	sleep_until (unit_has_weapon (player0, objects\weapons\rifle\storm_forerunner_rifle\storm_forerunner_rifle.weapon));
	thread (f_mus_picked_up_forerunner_rifle_begin());
	//sleep (30 * 0.75);
	//thread (f_mus_picked_up_forerunner_rifle_finish());
	//wake (f_dialog_forerunner_rifle);
end

script dormant f_phantom_trails

		sleep_until (volume_test_players (tv_phantom_trails), 1);	
	
		ai_place (sq_e3_air_trails);
		
		
		sleep (30 * 1.0);
		camera_shake_player (player0, 1, 1, 1, 3);
	
end


script dormant f_stop_moving

		sleep_until (volume_test_players (tv_stop_moving), 1);	
		player_disable_movement (TRUE);

end


;==================================================================================================
; COMMAND SCRIPTS
;==================================================================================================

script command_script cs_pawn_pf

	//sleep_until (b_pawn_pf_retreat == true);
	
	//cs_custom_animation (objects\characters\storm_pawn\storm_pawn.model_animation_graph, "combat:any:taunt", FALSE);
	
	cs_go_to (ps_pf.p0, 1);
	ai_erase (ai_current_actor);

end


script command_script cs_pawn_pf_roar_1a

	//sleep (random_range (30, 35));
	cs_custom_animation (objects\characters\storm_pawn\storm_pawn.model_animation_graph, "vin_global_solo_reaction_var1", TRUE);
	unit_stop_custom_animation (ai_current_actor);

	cs_go_to (ps_pf.p3, 1);
	cs_go_to (ps_pf.p2, 1);
	cs_go_to (ps_pf.p4, 1);
	cs_go_to (ps_pf.p0, 1);
	ai_erase (ai_current_actor);

end


script command_script cs_pawn_pf_roar_1

	//sleep (random_range (30, 35));
	cs_custom_animation (objects\characters\storm_pawn\storm_pawn.model_animation_graph, "vin_global_solo_reaction_var1", TRUE);
	unit_stop_custom_animation (ai_current_actor);

	//cs_go_to (ps_pf.p3, 1);
	//cs_go_to (ps_pf.p2, 1);
	//cs_go_to (ps_pf.p4, 1);
	cs_go_to (ps_pf.p0, 1);
	ai_erase (ai_current_actor);

end

script command_script cs_pawn_pf_roar_2
	
	//sleep (random_range (20, 30));
	sleep(20);
	cs_custom_animation (objects\characters\storm_pawn\storm_pawn.model_animation_graph, "vin_global_solo_reaction_var2", TRUE);
	unit_stop_custom_animation (ai_current_actor);
	
	//cs_go_to (ps_pf.p3, 1);
	//cs_go_to (ps_pf.p2, 1);
	cs_go_to (ps_pf.p4, 1);
	
	cs_go_to (ps_pf.p0, 1);
	ai_erase (ai_current_actor);

end

script command_script cs_pawn_pf_roar_3
	
	//sleep (random_range (30, 40));
		sleep(5);
	cs_custom_animation (objects\characters\storm_pawn\storm_pawn.model_animation_graph, "vin_global_solo_reaction_var3", TRUE);
	unit_stop_custom_animation (ai_current_actor);
	
	//cs_go_to (ps_pf.p3, 1);
	//cs_go_to (ps_pf.p2, 1);
	
	cs_go_to (ps_pf.p0, 1);
	ai_erase (ai_current_actor);

end

script command_script cs_pawn_pf_roar_3a
	
	//sleep (random_range (30, 40));
		sleep(5);
	cs_custom_animation (objects\characters\storm_pawn\storm_pawn.model_animation_graph, "vin_global_solo_reaction_var3", TRUE);
	unit_stop_custom_animation (ai_current_actor);
	
	sleep(5);
	cs_go_to (ps_pf.p3, 1);
	cs_go_to (ps_pf.p2, 1);
	cs_go_to (ps_pf.p5, 1);
	cs_go_to (ps_pf.p0, 1);
	ai_erase (ai_current_actor);

end

script command_script cs_pawn_pf_roar_4
	
	//sleep (random_range (45, 55));

	cs_custom_animation (objects\characters\storm_pawn\storm_pawn.model_animation_graph, "vin_global_solo_reaction_var4", TRUE);
	unit_stop_custom_animation (ai_current_actor);
	cs_go_to (ps_pf.p0, 1);
	ai_erase (ai_current_actor);

end

script command_script cs_pawn_pf_roar_5
	
	//sleep (random_range (50, 55));
	sleep(15);
	cs_custom_animation (objects\characters\storm_pawn\storm_pawn.model_animation_graph, "vin_global_solo_reaction_var5", TRUE);
	unit_stop_custom_animation (ai_current_actor);
	cs_go_to (ps_pf.p0, 1);
	ai_erase (ai_current_actor);

end

script command_script cs_pawn_pf_roar_6
	
	sleep (random_range (25, 40));
	cs_custom_animation (objects\characters\storm_pawn\storm_pawn.model_animation_graph, "vin_global_solo_reaction_var6", TRUE);
	unit_stop_custom_animation (ai_current_actor);
	cs_go_to (ps_pf.p0, 1);
	ai_erase (ai_current_actor);

end

script command_script cs_bishop_helper

	ai_set_blind (sq_e3_bishop_1.bishop,true);
	ai_set_deaf (sq_e3_bishop_1.bishop,true);
	cs_fly_to_and_face (ps_bishop_helper.p0,ps_bishop_helper.face);
	cs_fly_to_and_face (ps_bishop_helper.p1,ps_bishop_helper.face);
	
	sleep_until (unit_has_weapon (player0, objects\weapons\rifle\storm_forerunner_rifle\storm_forerunner_rifle.weapon));
	//wake (f_disable_reticle_kr);
	
	sleep_until (volume_test_players (tv_bishop_move), 1);
	
	//wake (f_dialog_watcher_chase);
	
	print("waiting to Loook at Bishop");
	
	sleep_until (volume_test_players_lookat (tv_bishop_lookat, 45, 1), 1);

	b_bishop_chase_line = true;
	
	//	sound_impulse_start ('sound\dialog\mission\e3_demo\e3_demo_00135', NONE, 1);		

	print("LOOKED AT");
	cs_fly_to_and_face (ps_bishop_helper.shard,ps_bishop_helper.face);
	s_bishop_fly = 1;


end


script command_script e3_banshee_1

	//ai_disregard (player0, TRUE);
	cs_vehicle_boost (TRUE);
	//cs_fly_to (e3_banshee_1.p0);
	//cs_fly_to (e3_banshee_1.p1);
	//cs_vehicle_boost (FALSE);
	cs_fly_to (e3_banshee.center);
	ai_erase (ai_current_actor);
	

end

script command_script e3_banshee_2

	//ai_disregard (player0, TRUE);
	cs_vehicle_boost (TRUE);
	//cs_fly_to (e3_banshee_2.p0);
	//cs_fly_to (e3_banshee_2.p1);
	//cs_vehicle_boost (FALSE);
	cs_fly_to (e3_banshee.left);
	ai_erase (ai_current_actor);

end

script command_script e3_banshee_3

	//ai_disregard (player0, TRUE);
	cs_vehicle_boost (TRUE);
	//cs_fly_to (e3_banshee_2.p0);
	//cs_fly_to (e3_banshee_2.p1);
	//cs_vehicle_boost (FALSE);
	cs_fly_to (e3_banshee.right);
	ai_erase (ai_current_actor);

end

script command_script e3_phantom

	//ai_disregard (player0, TRUE);
	cs_vehicle_boost (TRUE);
	cs_vehicle_speed (1.5);
	thread (e3_phantom_shake());
	//cs_fly_to (e3_phantom.p0);
	cs_fly_to (e3_phantom.p1);
	cs_vehicle_boost (FALSE);
	cs_fly_to (e3_phantom.p2);
	ai_erase (ai_current_actor);

end


script command_script e3_phantom_trails

	//ai_disregard (player0, TRUE);
	cs_vehicle_boost (TRUE);
	//cs_vehicle_speed (1.5);
	//thread (e3_phantom_shake());
	//cs_fly_to (e3_phantom.p0);
	cs_fly_to (e3_phantom.trails_1);
	cs_vehicle_boost (FALSE);
	cs_fly_to (e3_phantom.trails_2);
	ai_erase (ai_current_actor);

end

script command_script e3_phantom_2

	//ai_disregard (player0, TRUE);
	cs_vehicle_boost (TRUE);
	cs_vehicle_speed (1.5);
	cs_fly_to (e3_phantom_2.p0);
	cs_fly_to (e3_phantom_2.p1);
	cs_vehicle_boost (FALSE);
	cs_fly_to (e3_phantom_2.p2);
	ai_erase (ai_current_actor);

end

script command_script e3_phantom_3

	//ai_disregard (player0, TRUE);
	cs_vehicle_boost (TRUE);
	cs_vehicle_speed (1.5);
	cs_fly_to (e3_phantom_3.p0);
	cs_fly_to (e3_phantom_3.p1);
	cs_vehicle_boost (FALSE);
	cs_fly_to (e3_phantom_3.p2);
	ai_erase (ai_current_actor);

end



script static void e3_phantom_shake()

	sleep (30 * 3.5);
	camera_shake_player (player0, 0.65, 0.65, 1, 3);
	
	// Shows leaves falling all around due to the shaking
	print("***** LEAVES FALLING *****");
	effect_new(environments\solo\m60_rescue\fx\plant\fallingleaf_burst.effect, fx_00_fallingleaves);

end


script static void e3_start_shake()

	camera_shake_player (player0, 0.65, 0.65, 1, 3);

end



script command_script cs_e3_knight_2_fake_berserk
	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", FALSE);
	//sleep (30 * 2);
	//cs_phase_to_point (e3_phase_1.p0);
	//ai_erase (ai_current_actor);
	
	
end

script command_script cs_e3_knight_2_fight
		
		print("waiting for show to finish");
		
		sleep_until (b_knight_attack_done == true);
		
		print("show finished");
		
		sleep (20);
		
		ai_place (sq_e3_bishop_1.bishop);
		print("bishop sleeping");
		ai_enter_limbo(sq_e3_bishop_1);
		CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(sq_e3_bishop_1), OnCompleteProtoSpawn, 0);
		ai_cannot_die (sq_e3_bishop_1.bishop, true);
		
		b_knight_bishop_move_back = true;
	
end

script dormant oncompleteprotospawn()
dprint( "pawns be spawning, dawg." );
end

script dormant f_shard()
	dprint("shard start");
	ai_place(bishop_shards);
	sleep_s(1);
	ai_place_with_shards(pawns_shards);
	dprint("Placing pawns with shards");

end

script command_script cs_e3_knight_1

	cs_phase_in();
	sleep (30 * 0.5);
	print (":  : Shooting Elite :  :");
	cs_shoot (TRUE, (ai_get_object(sq_e3_elite)));
	sleep (30 * 3.5);
	ai_kill (sq_e3_elite);

	sleep (30 * 3);
	ai_erase (ai_current_actor);
	
end

script command_script e3_knight_2

	cs_phase_in();
	sleep (30 * 2);
	
end



script command_script e3_pawn_amb_1

	sleep (60);
	cs_go_to (e3_pawn_amb.p0);
	ai_erase (ai_current_actor);
	
end

script command_script e3_pawn_amb_2

	//sleep (35);
	cs_go_to (e3_pawn_amb.p2);
	ai_erase (ai_current_actor);
	
end

script command_script e3_pawn_amb_3

	sleep (0.5*60);
	cs_go_to (e3_pawn_amb.p3);
	ai_erase (ai_current_actor);
	
end

script command_script e3_pawn_log_1

	//sleep (35);
	cs_go_to (pawn_temp.p0);
	
end


script dormant f_tp_a_1()


	print ("move tp_a_1");
	//object_create (tp_a_1);
	object_move_to_point (tp_a_1, 1.5, ps_tp_a_1.p0);
	object_move_to_point (tp_a_1, 1.5, ps_tp_a_1.p1);
	object_move_to_point (tp_a_1, 1.5, ps_tp_a_1.p2);

	object_destroy (tp_a_1);

end

script dormant f_hf_1()

	object_create (hf_1);
	print ("move tp_a_1");
	object_move_to_point (hf_1, 1.5, ps_head_fake.p0);
	object_move_to_point (hf_1, 1.5, ps_head_fake.p1);


end

script dormant f_hf_2()

	object_create (hf_2);
	print ("move tp_a_2");
	object_move_to_point (hf_2, 1.5, ps_head_fake.p2);
	object_move_to_point (hf_2, 1.5, ps_head_fake.p3);


end

script dormant f_tp_a_2()


	print ("move tp_a_2");
	//object_create (tp_a_2);
	object_move_to_point (tp_a_2, 1.5, ps_tp_a_2.p0);
	object_move_to_point (tp_a_2, 1.5, ps_tp_a_2.p1);
	object_move_to_point (tp_a_2, 1.5, ps_tp_a_2.p2);

	object_destroy (tp_a_2);

end

script dormant f_tp_a_3()


	print ("move tp_a_3");
	//object_create (tp_a_3);
	object_move_to_point (tp_a_3, 1.5, ps_tp_a_3.p0);
	object_move_to_point (tp_a_3, 1.5, ps_tp_a_3.p1);
	object_move_to_point (tp_a_3, 1.5, ps_tp_a_3.p2);

	object_destroy (tp_a_3);

end

script dormant f_tp_a_4()


	print ("move tp_a_4");
	//object_create (tp_a_3);
	object_move_to_point (tp_a_4, 1.5, ps_tp_a_4.p0);
	object_move_to_point (tp_a_4, 1.5, ps_tp_a_4.p1);
	object_move_to_point (tp_a_4, 1.5, ps_tp_a_4.p2);

	object_destroy (tp_a_4);

end

script dormant f_tp_a_5()


	print ("move tp_a_5");
	//object_create (tp_a_3);
	object_move_to_point (tp_a_5, 1.5, ps_tp_a_5.p0);
	object_move_to_point (tp_a_5, 1.5, ps_tp_a_5.p1);
	object_move_to_point (tp_a_5, 1.5, ps_tp_a_5.p2);

	object_destroy (tp_a_5);

end

script dormant f_tp_a_6()


	print ("move tp_a_6");
	//object_create (tp_a_3);
	object_move_to_point (tp_a_6, 1.5, ps_tp_a_6.p0);
	object_move_to_point (tp_a_6, 1.5, ps_tp_a_6.p1);
	object_move_to_point (tp_a_6, 1.5, ps_tp_a_6.p2);

	object_destroy (tp_a_5);

end

script dormant f_tp_a_7()


	print ("move tp_a_7");
	//object_create (tp_a_3);
//	object_move_to_point (tp_a_7, 1.5, ps_tp_a_7.p0);
//	object_move_to_point (tp_a_7, 1.5, ps_tp_a_7.p1);
//	object_move_to_point (tp_a_7, 1.5, ps_tp_a_7.p2);

	object_destroy (tp_a_5);

end

script command_script cs_shard_animate_1

	//sleep (random_range (30, 60));
	sleep (30);
	cs_custom_animation (objects\characters\storm_pawn\storm_pawn.model_animation_graph, "combat:any:taunt", FALSE);
	
end

script command_script cs_shard_animate_2

	//sleep (random_range (30, 60));
	sleep (30);
	cs_custom_animation (objects\characters\storm_pawn\storm_pawn.model_animation_graph, "combat:any:go_berserk", FALSE);
	
end

script command_script cs_shard_animate_3

	//sleep (random_range (30, 60));
	sleep (30);
	cs_custom_animation (objects\characters\storm_pawn\storm_pawn.model_animation_graph, "combat:any:brace", FALSE);
	
end

script command_script e3_pawn_pack_1

	//sleep (35);
	cs_go_to (ps_pawn_pack.p0);
	ai_erase (ai_current_actor);
	
end

script command_script e3_pawn_pack_2

	sleep (5);
	cs_go_to (ps_pawn_pack.p1);
	ai_erase (ai_current_actor);
	
end

script command_script e3_pawn_pack_3

	//sleep (35);
	sleep (10);
	cs_go_to (ps_pawn_pack.p0);
	ai_erase (ai_current_actor);
	
end

script command_script e3_pawn_pack_4

	sleep (15);
	cs_go_to (ps_pawn_pack.p1);
	ai_erase (ai_current_actor);
	
end

script command_script e3_pawn_pack_5

	//sleep (35);
	cs_go_to (ps_pawn_pack.p4);
	ai_erase (ai_current_actor);
	
end

script command_script e3_pawn_pack_6

	//sleep (35);
	cs_go_to (ps_pawn_pack.p5);
	ai_erase (ai_current_actor);
	
end

script command_script e3_pawn_pack_7

	//sleep (35);
	cs_go_to (ps_pawn_pack.p6);
	ai_erase (ai_current_actor);
	
end

script command_script e3_pawn_pack_e

	//sleep (35);
	cs_go_to (ps_pawn_pack.p7);
	cs_go_to (ps_pawn_pack.p8);
	ai_erase (ai_current_actor);
	
end

script command_script e3_pawn_pack_4a

	//sleep (35);
	cs_go_to (ps_pawn_pack.p9);
	cs_go_to (ps_pawn_pack.p8);
	ai_erase (ai_current_actor);
	
end

script command_script e3_pawn_pack_8

	//sleep (35);
	cs_go_to (ps_pawn_pack.p8);
	ai_erase (ai_current_actor);
	
end

script command_script cs_e3_knight_battlewagon

	//cs_phase_in();
	//sleep (30 * 1);

	sleep_until (b_battlewagon_go == true);
	//sleep_until (ai_combat_status(sq_e3_knight_battlewagon) >= 5);
	ai_advance_immediate(sq_e3_knight_battlewagon);
	
end

script command_script cs_e3_bw

	//cs_phase_in();
	//sleep (30 * 1);
	cs_phase_in();
	sleep_until (ai_combat_status(sq_e3_knight_battlewagon) >= 5);
	ai_advance_immediate(sq_e3_knight_battlewagon);
	
end

script command_script cs_e3_knight_ranger

	cs_phase_in();
	//sleep (30 * 1);
	//thread (xray_fx_play(ai_current_actor)); 


	
end

script static void xray_fx_play(ai the_guy)
	effect_new_on_object_marker ("objects\equipment\storm_forerunner_vision\fx\storm_forerunner_vision.effect", the_guy, "fx_head");
	print ("played xray fx");
end

script static void xray_fx_stop(ai the_guy)
	effect_stop_object_marker ("objects\equipment\storm_forerunner_vision\fx\storm_forerunner_vision.effect", the_guy, "fx_head");
	print ("stopped xray fx");
end



script command_script just_phase_in

	cs_phase_in();
	sleep (30 * 1);
	
end

script command_script cs_knight_thirteen

	cs_phase_in();
	sleep (30 * 0.75);
	
	cs_custom_animation(objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", TRUE );
	
end

script command_script phase_in_then_shoot

	cs_phase_in();
	ai_grenades(FALSE);
	
	sleep (30 * 0.5);
	
	//cs_custom_animation(objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:taunt:var2", TRUE );
	
	ai_braindead (ai_current_actor, true);
	sleep_until (b_knights_shoot_player == true);
	
	ai_braindead (ai_current_actor, false);
	sleep (30 * 0.5);
	cs_face_player (true);
	sleep (30 * 1);
	print("shoot");
	cs_shoot (TRUE, (player0));
	
end

script command_script phase_in_animate_shoot_ranger_1

	cs_phase_in();
	ai_grenades(FALSE);
	
	sleep (30 * 0.5);
	
	cs_custom_animation(objects\characters\storm_knight\storm_knight.model_animation_graph, "vin_e3_sync_knight_overwhelm_ranger1", TRUE );
	
	ai_braindead (ai_current_actor, true);
	sleep_until (b_knights_shoot_player == true);
	
	ai_braindead (ai_current_actor, false);
	cs_face_player (true);
	sleep (30 * 1);
	print("shoot");
	cs_shoot (TRUE, (player0));
	
end

script command_script phase_in_animate_shoot_ranger_2
	cs_phase_in();
	ai_grenades(FALSE);
	
	sleep (30 * 0.5);
	
	cs_custom_animation(objects\characters\storm_knight\storm_knight.model_animation_graph, "vin_e3_sync_knight_overwhelm_ranger2", TRUE );
	
	ai_braindead (ai_current_actor, true);
	sleep_until (b_knights_shoot_player == true);
	
	ai_braindead (ai_current_actor, false);
	cs_face_player (true);
	sleep (30 * 1);
	print("shoot");
	cs_shoot (TRUE, (player0));
	
end

script command_script phase_in_animate_shoot_ranger_3
	cs_phase_in();
	ai_grenades(FALSE);
	
	sleep (30 * 0.5);
	
	cs_custom_animation(objects\characters\storm_knight\storm_knight.model_animation_graph, "vin_e3_sync_knight_overwhelm_ranger3", TRUE );
	
	ai_braindead (ai_current_actor, true);
	sleep_until (b_knights_shoot_player == true);
	
	ai_braindead (ai_current_actor, false);
	cs_face_player (true);
	sleep (30 * 1);
	print("shoot");
	cs_shoot (TRUE, (player0));
	
end

script command_script phase_in_animate_shoot_ranger_4
	cs_phase_in();
	ai_grenades(FALSE);
	
	sleep (30 * 0.5);
	
	sound_impulse_start ('sound\storm\characters\knight\foley\npc_knight_fly_v2\vin_e3_sync_knight_overwhelm_ranger4', NONE, 1);		
	cs_custom_animation(objects\characters\storm_knight\storm_knight.model_animation_graph, "vin_e3_sync_knight_overwhelm_ranger4", TRUE );
	
	ai_braindead (ai_current_actor, true);
	sleep_until (b_knights_shoot_player == true);
	
	ai_braindead (ai_current_actor, false);
	cs_face_player (true);
	sleep (30 * 1);
	print("shoot");
	cs_shoot (TRUE, (player0));
	
end

script command_script phase_in_animate_shoot_battlewaggon

	cs_phase_in();
	ai_grenades(FALSE);
	
	sleep (30 * 0.5);
	
	cs_custom_animation(objects\characters\storm_knight\storm_knight.model_animation_graph, "vin_e3_sync_knight_overwhelm_bw1", TRUE );
	
	ai_braindead (ai_current_actor, true);
	sleep_until (b_knights_shoot_player == true);
	
	ai_braindead (ai_current_actor, false);
	cs_face_player (true);
	sleep (30 * 1);
	print("shoot");
	cs_shoot (TRUE, (player0));
	
end

script dormant f_temp_vo_infinity

	sleep_until (volume_test_players (tv_temp_vo_infinity), 1);
	
	// Low-Normal, green text
	//story_blurb_add("vo", "INFINITY RADIO CHATTER IS HEARD HERE" );
	
end

script dormant f_temp_pip

	sleep_until (volume_test_players (tv_temp_pip), 1);

	// Low-Normal, green text
	//story_blurb_add("other", "PIP is SEEN HERE." );
	
end


script dormant f_temp_cortana_life_ahead

//sleep_until (volume_test_players (tv_temp_cortana_life_ahead), 1);
	
	// Low-Normal, green text
	story_blurb_add("vo", "CORTANA SAYS THERE'S MOVEMENT UP AHEAD" );
	
end

script dormant f_temp_pick_up_forerunner_weapon

sleep_until (volume_test_players (tv_temp_forerunner_weapon), 1);
	
	// Low-Normal, green text
	//story_blurb_add("other", "PICK-UP FORERUNNER RIFLE HERE." );
	
end

script dormant f_pick_up_forerunner_vision

	sleep_until (volume_test_players (tv_forerunner_vision), 1);
	//f_unblip_object (aa_vision_drop);
	//pup_play_show(fr_vision);
	
	
end

script dormant f_temp_1
		print ("waiting");
	sleep_until (unit_has_weapon (player0, objects\weapons\rifle\storm_spread_gun\storm_spread_gun.weapon));
	print ("HELLO WORLD");
	
end


script dormant f_temp_3
	
	sleep_until (volume_test_players (tv_e3_knight_3_spawn), 1);
	
	print ("waiting to look");
	sleep_until (volume_test_players_lookat (tv_ranger_lookat, 45, 1), 1);
	
	//sleep (30 * 1);

	print ("SPAWNED");
	ai_place_in_limbo (sq_e3_knight_ranger);
	ai_grenades(FALSE);
end

	
script dormant f_temp_4

object_create (temp_spread_gun);

sleep_until (volume_test_players (tv_spread_gun), 1);	
		
ai_place (sq_e3_knight_battlewagon);
		
sleep_until (unit_has_weapon (player0, objects\weapons\rifle\storm_spread_gun\storm_spread_gun.weapon), 1);
	
	b_battlewagon_go = true;
	
	sleep (30 * 1.6);
	
	print ("Lookout!");

end

script dormant f_temp_5

	sleep_until (volume_test_players (tv_e3_knight_3_spawn), 1);
	
	print ("waiting to look");
	sleep_until (volume_test_players_lookat (tv_ranger_lookat, 45, 1), 1);
	
	cheat_omnipotent = 0;
	
//	sleep (30 * 1);

	print ("SPAWNED");
	ai_place_in_limbo (sq_e3_knight_ranger);
	
end

script dormant f_disable_reticle_kr

		sleep_until (not unit_has_weapon (player0, objects\weapons\rifle\storm_br\storm_br.weapon), 1);
	
		wake (f_dialog_forerunner_rifle);
		print ("let's hide");
		chud_show_crosshair( FALSE );
		hud_show_crosshair( FALSE );
		
		sleep (30 * 4.5);
		
		chud_show_crosshair( TRUE );
		hud_show_crosshair( TRUE );
		thread (f_mus_picked_up_forerunner_rifle_finish());

end

script dormant f_disable_reticle_sg
		
		sleep_until (unit_has_weapon (player0, objects\weapons\rifle\storm_forerunner_rifle\storm_forerunner_rifle.weapon));
		sleep_until (not unit_has_weapon (player0, objects\weapons\rifle\storm_forerunner_rifle\storm_forerunner_rifle.weapon), 1);
		chud_show_crosshair( FALSE );
		hud_show_crosshair( FALSE );
		
		sleep (30 * 2.4);
		
		chud_show_crosshair( TRUE );
		hud_show_crosshair( TRUE );

end

script dormant f_temp_log

	ai_place (sq_e3_pawn_log_1);
	ai_place (sq_e3_pawn_ground);
	sleep (30 * 0.5);
	ai_place (sq_e3_pawn_log_2);
	sleep (30 * 2);
	
	ai_place (sq_e3_pawn_log_stay);

end

script dormant f_camera_shake

	camera_shake_player (player0, 0.4, 0.4, 1, 0);
	//thread (camera_shake_player (player0, 0.4, 0.4, 1, 0));

end

script dormant f_narrative_infinity_callback()

	sleep_until (volume_test_players(tv_infinity_callback_1), 1);
	
	print ("Infinity Call Back");
	
	//wake (f_dialog_infinity_callback);
	wake (f_infinity_callback_play);

	//sleep (30 * 1);
	//Hud_play_pip("TEMP_PIP_INFINITY");
	//sleep (30 * 6);
	//Hud_play_pip("");

end

script dormant f_infinity_callback_play

	//wake (f_del_rio_pip);
	
	Hud_play_pip_from_tag("bink\PiP_E3_DelRio_60"); 
	sleep (11);
	print ("Del Rio: MAYDAY MAYDAY - CODE RED! Hostile elements attempting to gain entrance to the Infinity bridge!");
	sound_impulse_start ('sound\dialog\mission\e3_demo\e3_demo_soundstory_00104', NONE, 1);
	
	sleep (170);
	Hud_play_pip_from_tag("");

	// Master Chief : We've got to move!
	dprint ("Master Chief: We've got to move!");
	sound_impulse_start ('sound\dialog\mission\e3_demo\e3_demo_soundstory_00106', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\mission\e3_demo\e3_demo_soundstory_00106'));

end

script dormant f_del_rio_pip

	sleep (185);
	Hud_play_pip_from_tag("");

end

script dormant f_infinity_derez_play

	// Marine 2 : Recon 3-1-5 requesting assistance! We've got enemy QRF in the open! Please respond- 
	dprint ("Marine 2: Recon 3-1-5 requesting assistance! We've got enemy QRF in the open! Please respond- ");
	sound_impulse_start ('sound\dialog\mission\e3_demo\e3_demo_00136', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\mission\e3_demo\e3_demo_00136'));

end

script dormant f_dialog_pf_play_1

	dprint ("Cortana: More of them!");
	sound_impulse_start ('sound\dialog\mission\e3_demo\e3_demo_00136c', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\mission\e3_demo\e3_demo_00136c'));

end

script dormant f_dialog_pf_play_2
	
	sleep (30 * 2.0);
	// Cortana : They're retreating!
	dprint ("Cortana: They're retreating!");
	sound_impulse_start ('sound\dialog\mission\e3_demo\e3_v2_00145', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\mission\e3_demo\e3_v2_00145'));

end

script dormant f_dialog_spotted_us
	
	// Cortana : They spotted us!
	dprint ("Cortana: They spotted us!");
	sound_impulse_start ('sound\dialog\mission\e3_demo\e3_demo_00113', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\mission\e3_demo\e3_demo_00113'));

end

script dormant f_waypoint

	f_blip_flag( flag_waypoint, "default" );
	sleep_until (volume_test_players(tv_waypoint), 1);
	f_unblip_flag( flag_waypoint );

end