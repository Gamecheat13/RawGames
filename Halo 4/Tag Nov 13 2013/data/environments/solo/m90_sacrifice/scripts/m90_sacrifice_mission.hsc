//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m90_sacrifice
//	Insertion Points:	start (or ist)	- Beginning
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

global real r_real_gravity	= 1.0;
global real r_low_gravity 	= 0.23;
global real r_zero_gravity	=	0.0;
global boolean b_ForceCleanup = FALSE;
global boolean b_M90_COMPLETE = FALSE;
global boolean b_show_intro_cinematic = FALSE;
global real DEF_R_OBJECTIVE_START 			= 0.0;
global real DEF_R_OBJECTIVE_GENERATOR 			= 21.0;
global real DEF_R_OBJECTIVE_CANNONS 			= 1.0;
global real DEF_R_OBJECTIVE_ON_FOOT_GO 			= 6.0;
global real DEF_R_OBJECTIVE_ON_FOOT_CORE 			= 7.0;
global real DEF_R_OBJECTIVE_DESTROY_SHIELDS 			= 8.0;
global real DEF_R_OBJECTIVE_DESTROY_CORE 			= 9.0;
global real DEF_R_OBJECTIVE_ALRIGHT_MESSAGE 			= 18.0;
global real DEF_R_OBJECTIVE_BOMB 			= 10.0;
global real DEF_R_OBJECTIVE_CORTANA_IN 			= 11.0;
global real DEF_R_OBJECTIVE_WALLS_HOLD 			= 12.0;
global boolean b_bomb_icon_on = FALSE;
// =================================================================================================
// =================================================================================================
// *** START-UP ***
// =================================================================================================
// =================================================================================================

script startup m90_sacrifice()		
	if b_debug then 
		print_difficulty(); 
	end
	
	dprint ("::: M90 - SACRIFICE :::");

	thread( f_disable_all_trench_kill_vols() );

	

	objectives_clear();
	
	fade_out (0, 0, 0, 0);
	wake(f_m90_sacrifice_end);



	//b_game_emulate = TRUE;

	// ============================================================================================
	// STARTING THE GAME
	// ============================================================================================
	if (b_game_emulate or ((b_editor != 1) and (player_count() > 0))) then
		// if true, start the game
		start();
		// else just fade in, we're in edit mode
	elseif b_debug then
				dprint (":::  editor mode  :::");
				fade_in (0, 0, 0, 0);
	end


		

end

script dormant f_m90_sacrifice_end()
	sleep_until( b_M90_COMPLETE == TRUE, 10 );
		game_won();

end


script command_script cs_knight_rider()

	dprint("knight cs");
	cs_phase_in();

end

script static void f_disable_all_trench_kill_vols()

	f_trench_activate_death_zone( kill_trench_a_tv, false );
	f_trench_activate_death_zone( kill_trench_b_tv, false );
	f_trench_activate_death_zone( kill_trench_e_tv, false );
	f_trench_activate_death_zone( kill_eye_tunnel, false );	
	f_trench_activate_death_zone( kill_trans_ab_1, false );	
	f_trench_activate_death_zone( kill_trans_bc_1, false );	
	f_trench_activate_death_zone( kill_trans_bc_2, false );		
	f_trench_activate_death_zone( kill_trench_c_tv, false );	
	f_trench_activate_death_zone( kill_trans_cd_1, false );	
	f_trench_activate_death_zone( kill_trench_d, false );	
	f_trench_activate_death_zone( kill_trans_de_1, false );	
	
end
/*
script command_script cs_stay_in_turret()
    dprint("Initializing Turret.");
    //cs_shoot (false);
    cs_enable_targeting (true);
    cs_enable_moving (true);
    cs_enable_looking (true);
    cs_abort_on_damage (false);
    cs_abort_on_alert (false);
    //ai_disregard (ai_actors (ai_current_actor), true);
    ai_braindead (ai_current_actor, TRUE);
    object_hide( ai_vehicle_get(ai_current_actor), true );   
    CreateDynamicTask(0, 0, ai_vehicle_get(ai_current_actor), OnTurretActivated, 0);
end


script static void OnTurretActivated(long taskIndex, long taskType, unit targetObj)
   ActivateTurret(object_get_ai(vehicle_driver(targetObj)), targetObj);
end

script static void ActivateTurret(ai turretPilot, unit turretVeh)
    dprint("Turret Activated");
    
    effect_new_on_object_marker (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ai_vehicle_get(turretPilot), "target_turret" );
    sleep(10);
    object_hide( ai_vehicle_get(turretPilot), false);
    effect_new_on_object_marker (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ai_vehicle_get(turretPilot), "target_turret" );

    ai_braindead (turretPilot, false);
    ai_disregard (ai_actors (turretPilot), false);
   // cs_shoot (turretPilot, true);
end
*/

script command_script cs_bishop_spawn()
        print("bishop sleeping");
        ai_enter_limbo(ai_current_actor);
        CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), OnCompleteProtoSpawn, 0);
end

script static void OnCompleteProtoSpawn()
	dprint("bishop spawned");
	//b_arcade_birth_done = true;
end

script command_script cs_bishop_spawn_arcade_2()
        print("bishop sleeping");
        ai_enter_limbo(ai_current_actor);
        CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), OnCompleteProtoSpawnArcade2, 0);
end

script static void OnCompleteProtoSpawnArcade2()
	dprint("bishop spawned");
	b_arcade_birth_done = true;
end
// =================================================================================================
// =================================================================================================
// START
// =================================================================================================
// =================================================================================================

script static void start()
	// Figure out what insertion point to use
	// Set these in init.txt or editor_init.txt to work on various areas quickly\
	dprint("::: START :::");

	f_insertion_index_load( game_insertion_point_get() );
end



// =================================================================================================
// =================================================================================================
// MASTER CLEANUP
// =================================================================================================
// =================================================================================================
script static void f_master_cleanup_m90()
	b_ForceCleanup = true;
	thread(f_trench_a_cleanup());
	thread(f_trench_b_cleanup());
	thread(f_trench_c_cleanup());
	thread(f_eye_flight_cleanup());
	//thread(f_interior_a_cleanup());
	sleep(1);
	b_ForceCleanup = false;
end





// =================================================================================================
// =================================================================================================
// STATION
// =================================================================================================
// =================================================================================================



script static void f_space_particles_on( boolean b_on )

	if b_on then
		effect_attached_to_camera_new( environments\solo\m90_sacrifice\fx\particulates\particulate_space.effect );	
	else
		effect_attached_to_camera_stop( environments\solo\m90_sacrifice\fx\particulates\particulate_space.effect );	
	end
	
end

script static void f_radiation_particles_on( boolean b_on )

	if b_on then
		effect_attached_to_camera_new( environments\solo\m90_sacrifice\fx\radiation\radiation_particulates.effect );	
	else
		effect_attached_to_camera_stop( environments\solo\m90_sacrifice\fx\radiation\radiation_particulates.effect );	
	end
	
end

script static void set_broadsword_respawns ( boolean b_in_vehicle )

	if b_in_vehicle then
			player_set_respawn_vehicle ( player0, "objects\vehicles\human\storm_broadsword\storm_broadsword.vehicle");
			player_set_respawn_vehicle ( player1, "objects\vehicles\human\storm_broadsword\storm_broadsword.vehicle");
			player_set_respawn_vehicle ( player2, "objects\vehicles\human\storm_broadsword\storm_broadsword.vehicle");
			player_set_respawn_vehicle ( player3, "objects\vehicles\human\storm_broadsword\storm_broadsword.vehicle");		
		else
			player_set_respawn_vehicle ( player0, none );
			player_set_respawn_vehicle ( player1, none );
			player_set_respawn_vehicle ( player2, none );
			player_set_respawn_vehicle ( player3, none );
		end
end

script static void f_m90_global_rezin( object_name obj, string_id marker)
	
	//( 2 );
	//thread( f_coldant_move_platform( platform, FALSE ) );
	//sleep( 1 );
	object_dissolve_from_marker( obj, hard_kill, marker );
end

script static void f_m90_global_rezin_soft_kill( object_name obj, string_id marker)
	
	//( 2 );
	//thread( f_coldant_move_platform( platform, FALSE ) );
	//sleep( 1 );
	object_dissolve_from_marker( obj, soft_kill, marker );
end

// =================================================================================================
// Loadouts
// =================================================================================================
script static void f_m90_loadout_set ( short loadout )
	static short start_unsc  = 0;
	static short default_for = 1;
	static short power_for   = 2;
	dprint("loading profile ");
	inspect(loadout);
  if loadout == start_unsc then
      player_set_profile ( default_coop_respawn, player0 );
      player_set_profile ( default_coop_respawn, player1 );
      player_set_profile ( default_coop_respawn, player2 );
      player_set_profile ( default_coop_respawn, player3 );
  end
  
  if loadout == default_for or loadout > 2 then
      player_set_profile ( default_forerunner, player0 );
      player_set_profile ( default_forerunner, player1 );
      player_set_profile ( default_forerunner, player2 );
      player_set_profile ( default_forerunner, player3 );
  end
  
  if loadout == power_for then
      player_set_profile ( forerunner_power, player0 );
      player_set_profile ( forerunner_power, player1 );
      player_set_profile ( forerunner_power, player2 );
      player_set_profile ( forerunner_power, player3 );
  end
                
end

script static void f_m90_game_save()
	game_save_cancel();
	sleep(1);
	game_save();
	dprint("M90 GAME SAVE");
end


script static void f_m90_game_save_no_timeout()
	game_save_cancel();
	sleep(1);
	game_save_no_timeout();
	dprint("M90 GAME SAVE");
end



script static void f_bomb_icon( boolean b_on )
	if b_on != b_bomb_icon_on then
		cui_toggle_bomb_icon ( b_on );
		b_bomb_icon_on = not b_bomb_icon_on;
	end
end


script static void f_m90_set_low_g()
		//sleep_until(volume_test_players(tv_zero_g_eye_ext) , 1);
			dprint("low g");
			f_set_gravity( r_low_gravity );
	
end

script static void f_m90_set_low_g_r( real g )
		//sleep_until(volume_test_players(tv_zero_g_eye_ext) , 1);
			dprint("setting gravity");
			f_set_gravity( g );
	
end

script static void f_m90_set_normal_g( )
		//sleep_until(volume_test_players(tv_zero_g_eye_ext) , 1);
			dprint("setting normal gravity");
			f_set_gravity( r_real_gravity );
	
end

script static void f_set_gravity( real r_gravity )


		physics_set_gravity( r_gravity );
end

script static void f_reset_gravity( real r_gravity )
		physics_set_gravity( 1.0 );
end

script static void f_zone_num()
	inspect(current_zone_set_fully_active());
end

script static void  f_m90_show_chapter_title( cutscene_title title )
/*	
	cinematic_show_letterbox (TRUE);
	sleep_s ( 1.5 );
	thread(storyblurb_display(title, 8, FALSE, FALSE));
	sleep_s ( 6 );
	cinematic_show_letterbox (FALSE);
**/
/*
    hud_play_global_animtion (screen_fade_out);
    cinematic_show_letterbox (TRUE);
    sleep_s (1.5);
    cinematic_set_title (title);
    hud_stop_global_animtion (screen_fade_out);
    sleep_s (3.5);     
    hud_play_global_animtion (screen_fade_in);
    hud_stop_global_animtion (screen_fade_in);
    cinematic_show_letterbox (FALSE);
*/
	f_chapter_title(title);
end




// functions
// === f_mission_objective_blip: Blips an objective index
script static boolean f_mission_objective_blip( real r_index, boolean b_blip )
static boolean b_blipped = FALSE;
	// set the default return value
	b_blipped = FALSE;

	//dprint( "::: f_mission_objective_blip :::" );
	inspect( r_index );
	

	// return if something was blipped
	b_blipped;

end
script static void f_m90_trans_beep()
	sound_impulse_start( sound\game_sfx\ui\transition_beeps, NONE, 1 );
end

// === f_mission_objective_title: Returns the index title title
script static string_id f_mission_objective_title( real r_index )
local string_id sid_return = SID_objective_none;
		
	//dprint("want to go?")';
	// DEF_R_OBJECTIVE_INFINITY_PELICAN

	if ( r_index == DEF_R_OBJECTIVE_START ) then
		sid_return = 'chapter_01';

	end		

	if ( r_index == DEF_R_OBJECTIVE_GENERATOR ) then
		sid_return = 'chapter_02a';

	end	


	if ( r_index == DEF_R_OBJECTIVE_CANNONS ) then
		sid_return = 'chapter_02';

	end	
	if ( r_index == DEF_R_OBJECTIVE_ON_FOOT_GO ) then
		sid_return = 'chapter_04';
		//dprint("got chpt 4?");
	end		
	
	if ( r_index == DEF_R_OBJECTIVE_WALLS_HOLD ) then
		sid_return = 'obj_hold_area';
		//dprint("got chpt 4?");
	end
	
	if ( r_index == DEF_R_OBJECTIVE_DESTROY_SHIELDS ) then
		sid_return = 'chapter_06';
		//dprint("got chpt 4?");
	end

	if ( r_index == DEF_R_OBJECTIVE_DESTROY_CORE ) then
		sid_return = 'chapter_07';
		//dprint("got chpt 4?");
	end
	
	if ( r_index == DEF_R_OBJECTIVE_BOMB ) then
		sid_return = 'chapter_08';
		dprint("got chpt 4?");
	end

	if ( r_index == DEF_R_OBJECTIVE_CORTANA_IN ) then
		sid_return = 'chapter_cortana';
		//dprint("got chpt 4?");
	end
	
	if ( r_index == DEF_R_OBJECTIVE_ALRIGHT_MESSAGE ) then
		sid_return = 'chapter_07a';
		//dprint("got chpt 4?");
	end

	// return
	sid_return;

end

global short s_m90_enc_music_track = 1;
global short s_m90_enc_track_playing = -1;

script static void f_m90_begin_encounter_music()	
	dprint("begin encounter music");
	
	if s_m90_enc_track_playing == -1 then
		dprint("");
	end

	
end


script static void f_clear_equipment()
	f_insertion_playerprofile( ics_empty, FALSE );
end


script static void fm90_blip_flag (cutscene_flag f, string type)

	
	if fg_cold_curret_blip_flag != f and fg_cold_curret_blip_flag_2 != f and fg_cold_curret_blip_flag_3 != f then
	
		if fg_cold_curret_blip_flag == flag_empty then
			fg_cold_curret_blip_flag = f;

		elseif fg_cold_curret_blip_flag_2 == flag_empty then
			fg_cold_curret_blip_flag_2 = f;	

		elseif fg_cold_curret_blip_flag_3 == flag_empty then
			fg_cold_curret_blip_flag_3 = f;

		else
			dprint("warning, no available blip flags");
		end	

		chud_track_flag_with_priority (f, f_return_blip_type (type));	
		navpoint_track_flag_named (f, f_return_blip_type_cui (type));
		//dprint("beep");
		sound_impulse_start (sfx_blip, NONE, 1);
	end
end

script static void fm90_unblip_flag (cutscene_flag f)


	chud_track_flag (f, false);
	
	navpoint_track_flag (f, false);
	if fg_cold_curret_blip_flag == f or fg_cold_curret_blip_flag_2 == f or fg_cold_curret_blip_flag_3 == f then	

		if fg_cold_curret_blip_flag == f then
			fg_cold_curret_blip_flag = flag_empty;
		end
		
		if fg_cold_curret_blip_flag_2 == f then
			fg_cold_curret_blip_flag_2 = flag_empty;
		end	
			
		if fg_cold_curret_blip_flag_3 == f then
			fg_cold_curret_blip_flag_3 = flag_empty;
		end

		sound_impulse_start (sfx_blip, NONE, 1);
		

	end
end

// blip an object temporarily
script static void fm90_blip_object (object obj, string type)
	chud_track_object_with_priority( obj, f_return_blip_type(type) );
	
	navpoint_track_object_named (obj, f_return_blip_type_cui (type));
	
	//sound_impulse_start (sfx_blip, NONE, 1);
end

// turn off a blip on an object that was blipped forever
script static void fm90_unblip_object (object obj)
	chud_track_object (obj, false);
	
	navpoint_track_object (obj, false);
	
	//sound_impulse_start (sfx_blip, NONE, 1);
end	

script static void f_activator_get( object trigger, unit activator )
	dprint(" -activator- ");
  if ( trigger == dc_comp_switch_left ) then
		g_ics_player_left = activator;
  elseif ( trigger == dc_comp_switch_right ) then
		g_ics_player_right = activator;
	else
		g_ics_player = activator;
  end

  if ( trigger == terminal_button ) then
     f_narrative_domain_terminal_interact( 6, domain_terminal, terminal_button, activator, 'pup_domain_terminal' );
  end
	
end


global object o_the_bomb = NONE;
global object p_bomb_carrier = NONE;

script static void f_m90_bomb_attach()
	dprint("attach bomb");
	object_create( sn_the_bomb );
	sleep(1);
	o_the_bomb = sn_the_bomb;
	p_bomb_carrier = player_get_first_valid();
	objects_attach ( p_bomb_carrier, "package", o_the_bomb, "attach_point" );
end

script static void f_m90_bomb_detach()
	objects_detach ( p_bomb_carrier,  o_the_bomb );
	object_destroy ( o_the_bomb );
end
//pause_menu_goal_1 "Fly To The Composer"
//pause_menu_goal_2 "Locate The Composer";
//pause_menu_goal_3 "Destroy Composer";

script static void f_m90_pause_menu_objectives()
	objectives_set_string ( 0, pause_menu_goal_3 );
	//objectives_set_string ( 1, pause_menu_goal_2 );
	objectives_secondary_set_string ( 0, pause_menu_goal_1 );
	objectives_secondary_set_string ( 1, pause_menu_goal_2 );
	sleep(1);
end

script static void f_m90_start_objectives()
		objectives_clear();
		objectives_show ( 0 );
		objectives_secondary_show( 0 );
end

script static void f_m90_update_1_objectives()

		//objectives_finish ( 0 );
		objectives_secondary_finish( 0 );
end

script static void f_m90_update_2_objectives()

		//objectives_finish ( 0 );
		objectives_secondary_show( 1 );
end

script static void f_m90_update_3_objectives()

		//objectives_finish ( 0 );
		objectives_secondary_finish( 1 );
end

script static void f_m90_update_4_objectives()

		//objectives_finish ( 0 );
		objectives_finish( 0 );
end
//EXIT SLIPSPACE
/*

script static void f_inf_create_guns()
	ai_place(infinity_guns);
	sleep(1);
	objects_attach(infinity_eye, "m_gun_mid_starboard", ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_1), "" );
	objects_attach(infinity_eye, "m_gun_mid_port", ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_2), "" );
	objects_attach(infinity_eye, "m_gun_mid_rear_starboard", ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_3), "" );
	objects_attach(infinity_eye, "m_gun_mid_rear_port", ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_4), "" );
	objects_attach(infinity_eye, "m_gun_fore_starboard", ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_5), "" );
	objects_attach(infinity_eye, "m_gun_fore_port", ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_6), "" );
	objects_attach(infinity_eye, "m_gun_aft_starboard", ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_7), "" );
	objects_attach(infinity_eye, "m_gun_aft_port", ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_8), "" );
	dprint("attached infinity guns");
	sleep(10);
	load_inf_gunners();
end

*/
/*
script static void load_inf_gunners()


       ai_place (inf_gunners);

       ai_cannot_die (inf_gunners, TRUE);

       vehicle_load_magic (ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_1), "", ai_get_unit (inf_gunners.gunner_1));
       vehicle_load_magic (ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_2), "", ai_get_unit (inf_gunners.gunner_2));
       vehicle_load_magic (ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_3), "", ai_get_unit (inf_gunners.gunner_3));
       vehicle_load_magic (ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_4), "", ai_get_unit (inf_gunners.gunner_4));
       vehicle_load_magic (ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_5), "", ai_get_unit (inf_gunners.gunner_5));
       vehicle_load_magic (ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_6), "", ai_get_unit (inf_gunners.gunner_6));
       vehicle_load_magic (ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_7), "", ai_get_unit (inf_gunners.gunner_7));
       vehicle_load_magic (ai_vehicle_get_from_spawn_point(infinity_guns.inf_gun_8), "", ai_get_unit (inf_gunners.gunner_8));
end
*/


/*
script static void f_loadout_set (string area)
	if (area == "default") then
		if (game_is_cooperative()) then
			unit_add_equipment (player0, default_coop, TRUE, FALSE);
			unit_add_equipment (player1, default_coop, TRUE, FALSE);
			unit_add_equipment (player2, default_coop, TRUE, FALSE);
			unit_add_equipment (player3, default_coop, TRUE, FALSE);
			player_set_profile (default_coop_respawn, player0);
			player_set_profile (default_coop_respawn, player1);
			player_set_profile (default_coop_respawn, player2);
			player_set_profile (default_coop_respawn, player3);
		else
			player_set_profile (default_single_respawn, player0);
		end
	end
end
*/