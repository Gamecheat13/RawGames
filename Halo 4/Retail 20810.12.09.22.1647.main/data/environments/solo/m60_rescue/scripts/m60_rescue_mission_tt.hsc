//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					m60_rescue
//	Insertion Points:	start (or icl)	- Beginning
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

script dormant f_trailstwo_main()
	sleep_until (b_mission_started == TRUE);
	dprint  (" - trails two - ");

	// TEMP REMOVE - WHEN DONE

	wake (f_rockies);
	wake (f_tree);
	wake (f_save_pre_rockies);
end


//----------------- X RAY



//----------------- Rockies
	
script dormant f_rockies()
	sleep_until (volume_test_players (tv_t2_rockies), 1);
	sleep_until (volume_test_players (tv_t2_rockies2), 1);
	f_unblip_object (crumb_dogtag_02);
	
	object_wake_physics (plains_dead_marine);
	object_wake_physics (bb_dead_marine);
	
	ai_place (sg_plain_preview);
	wake (f_plains);
end

//------------------Plains 

script dormant f_plains()
	sleep_until (volume_test_players (trig_plains_spawn), 1);
//	device_set_power (door_treehouse_entrance, 0);
	
	//Start Encounter Music 2
	thread (f_mus_m60_e02_begin());
	
	ai_place (sq_plain_k1);
	ai_place (sq_plain_b1);
	ai_place (sq_plain_p1_l);
	ai_place (sq_plain_p1_r);
	ai_place (sg_plain_wall);
	print ("plains placed");
	game_save_no_timeout();
	ai_place (sq_plain_p2);
	print ("Spawning Pawns");
	ai_place (sq_plain_p_sp);
end

//------------------Tree

script dormant f_tree()
	sleep_until (volume_test_players (tv_t2_tree), 1);
	ai_place (sg_t2_tree);
	
	cs_suppress_dialogue_global (sq_vig_s4, TRUE);
	ai_actor_dialogue_enable (sq_vig_s4, FALSE);
	
	print ("sniper 2 placed");
	sleep_until (volume_test_players (th_vig), 1);

	effect_attached_to_camera_stop(environments\solo\m60_rescue\fx\ambient_life\forest_player_gnats.effect);
	
	//Encounter 2 Music End
	
	sleep_until (device_get_position(crumb_dogtag_last) > 0.0, 1 );
	
	pup_play_show (s4_door);
	
	sleep (30 * 2);
	
	if
		game_difficulty_get_real() == legendary
	then
		object_create (generic_b_b);
		thread (b_b_debug());
	else
		print (" :  : Not Legendary :  :");
	end
	
	thread (f_mus_m60_e02_finish());
	
end

script dormant f_save_pre_rockies()
	sleep_until (volume_test_players (tv_save_pre_rockies), 1);
	game_save();
	print ("save now");
end

script static void b_b_debug()
	print (":  : B B :  :");
	sleep_until (device_get_position(generic_b_b) > 0.0, 1 );
	m60_tank_rally_debug = true;
	print (":  : S1 :  :");
	sound_looping_start ( "sound\vehicles\mongoose\mongoose_horn\mongoose_horn.sound_looping", none, 1);
	sleep (10);
	sound_looping_stop ("sound\vehicles\mongoose\mongoose_horn\mongoose_horn.sound_looping");
	print (":  : S2 :  :");
	sound_looping_start ( "sound\vehicles\mongoose\mongoose_horn\mongoose_horn.sound_looping", none, 1);
	sleep (45);
	sound_looping_stop ("sound\vehicles\mongoose\mongoose_horn\mongoose_horn.sound_looping");
end

// =================================================================================================
// =================================================================================================
// TRAILS COMMAND SCRIPTS
// =================================================================================================
// =================================================================================================

script command_script plains_phase
	cs_phase_to_point (ps_plains_phase.p0);
end

script command_script treehouse_shoot_1
	cs_abort_on_alert (TRUE);
	cs_shoot_point (TRUE, ps_th_shoot.p0);
end
	
script command_script treehouse_shoot_2
	cs_abort_on_alert (TRUE);
	cs_shoot_point (TRUE, ps_th_shoot.p1);
end

script command_script treehouse_shoot_3
	cs_abort_on_alert (TRUE);
	cs_shoot_point (TRUE, ps_th_shoot.p2);
end