//// =============================================================================================================================
//========= BREACH SPARTAN OPS SCRIPTS ========================================================
// =============================================================================================================================

//debug

//Scenario scripts should only be used for pointing the variables to named Sapien folders, map bug fixes and map polish.  NO GENERAL SCRIPTS should be copy and pasted
//into the map scripts
// =============================================================================================================================
//===== LEVEL SCRIPTS ==================================================================
// =============================================================================================================================

// =============================================================================================================================
// =================== GLOBALS ==================================================================
// =============================================================================================================================

global boolean b_e6_m5_wait_for_narrative = false;


script startup e6_m5_breach_destroy

	//dprint( "breach_e6_m5 startup" );
	//Wait for the variant event
	if ( f_spops_mission_startup_wait("e6_m5") ) then
		wake( breach_e6_m5_init );
	end

end

script dormant breach_e6_m5_init()

	print ("************STARTING E6 M5*********************");
	
//	fade_out (0,0,0,1);

	// set standard mission init, the mission ID, the zone set, the ai_ff_all, the initial spawn folder and the initial spawn folder index
	f_spops_mission_setup( "e6_m5", e6_m5, gr_e6_m5_ff_all, sc_e6_m5_spawn_points_0, 90 );
	
	//turning off "angry sky" -- putting this here very early so that any loadout or intro cameras don't have it
	interpolator_start (angryskyoff);
	
	//start all the rest of the event scripts
	f_start_all_events_e6_m5();
	print ("starting e6_m5 all events thread");

//======== OBJECTS ==================================================================

	//creates folders at the beginning of the mission automatically and puts their names into an index (unfortunately we never really use the index)

	//set crate names
	f_add_crate_folder(sc_e6_m5_objectives); //IFF tags
	f_add_crate_folder(cr_e6_m5_cov_cover); //Cover Cover
	f_add_crate_folder(cr_e6_m5_cov_cover2); //Cover Cover
	f_add_crate_folder(cr_e6_m5_dig_cover); //Cover Cover
	//f_add_crate_folder(cr_e6_m5_other); //door barriers
	f_add_crate_folder(eq_e6_m5_unsc_ammo); //UNSC ammo
	f_add_crate_folder(wp_e6_m5_unsc); //UNSC weapons
	f_add_crate_folder(cr_e6_m5_cov_ammo); //cov ammo
	f_add_crate_folder(cr_e6_m5_unsc_ammo); //UNSC ammo crates and grenade crates
	f_add_crate_folder(cr_e6_m5_objectives);
	f_add_crate_folder(veh_e6_m5_cov); //shades and turrets
	f_add_crate_folder(dm_e6_m5_objectives);
	f_add_crate_folder(cr_e6_m5_dig_coils);


// puts spawn point folders into an index that is used to automatically turn on/off spawn points and used by designers to override current spawn folders
//set spawn folder names
	firefight_mode_set_crate_folder_at(sc_e6_m5_spawn_points_0, 90); //spawns in the main starting area
	firefight_mode_set_crate_folder_at(sc_e6_m5_spawn_points_1, 91);
	firefight_mode_set_crate_folder_at(sc_e6_m5_spawn_points_2, 92);
	firefight_mode_set_crate_folder_at(sc_e6_m5_spawn_points_3, 93);
	firefight_mode_set_crate_folder_at(sc_e6_m5_spawn_points_4, 94);
	firefight_mode_set_crate_folder_at(sc_e6_m5_spawn_points_5, 95);
	firefight_mode_set_crate_folder_at(sc_e6_m5_spawn_points_6, 96);
	firefight_mode_set_crate_folder_at(sc_e6_m5_spawn_points_7, 97);
	
//puts certain objects into an index that is used to track objectives set in the player goals in the variant tag
//set objective names
	
	firefight_mode_set_objective_name_at(dc_e6_m5_iff1,			1); //iff tag 1
	firefight_mode_set_objective_name_at(dc_e6_m5_iff2,			2); //iff tag 2
	firefight_mode_set_objective_name_at(dc_e6_m5_iff3,			3); //iff tag 3
	firefight_mode_set_objective_name_at(dc_e6_m5_iff4,			4); //iff tag 4
	firefight_mode_set_objective_name_at(dc_e6_m5_comp,			5); //computer
	firefight_mode_set_objective_name_at(dc_e6_m5_dig,			6); //computer
	firefight_mode_set_objective_name_at(sc_e6_m5_lz,				7); //LZ spot
	firefight_mode_set_objective_name_at(cr_e6_m5_exp1,				8); //LZ spot
	firefight_mode_set_objective_name_at(cr_e6_m5_exp2,				9); //LZ spot

//set LZ (location arrival) spots			
//	firefight_mode_set_objective_name_at(area_1, 51); //objective in the main spawn area

//	firefight_mode_set_objective_name_at(area_2, 52); //objective in the middle back building
//	firefight_mode_set_objective_name_at(area_3, 53); //objective in the left back area
//	firefight_mode_set_objective_name_at(area_4, 54); //objective in the right in the way back
//	firefight_mode_set_objective_name_at(area_5, 55); //objective in the back on the forerunner structure
//	firefight_mode_set_objective_name_at(area_6, 56); //objective in the back on the smooth platform
//	firefight_mode_set_objective_name_at(area_7, 57); //objective right by the tunnel entrance

//turn on Digger active audio
	if not object_valid(digger_active_hum_sfx) then 
		object_create(digger_active_hum_sfx);
	end
	
//==== DECLARE AI ====
	//puts AI squads and groups into an index used by the variant tag to spawn in AI automatically
	//set squad group names
	//guards
	firefight_mode_set_squad_at(sq_e6_m5_guards_1, 1);	//left building
	firefight_mode_set_squad_at(sq_e6_m5_guards_2, 2);	//front by the main start area
	firefight_mode_set_squad_at(sq_e6_m5_guards_3, 3);	//back middle building
	firefight_mode_set_squad_at(sq_e6_m5_guards_4, 4); //in the main start area
	firefight_mode_set_squad_at(sq_e6_m5_guards_5, 5); //right side in the back
	firefight_mode_set_squad_at(sq_e6_m5_guards_6, 6); //right side in the back at the back structure
	firefight_mode_set_squad_at(sq_e6_m5_guards_7, 7); //middle building at the front
	firefight_mode_set_squad_at(sq_e6_m5_guards_8, 8); //on the bridge
	
	
	firefight_mode_set_squad_at(sq_e6_m5_other_1, 11);	//left building
	firefight_mode_set_squad_at(sq_e6_m5_other_2, 12);	//left building	
	firefight_mode_set_squad_at(sq_e6_m5_other_3, 13);	//left building	
	firefight_mode_set_squad_at(sq_e6_m5_other_4, 14);	//left building
		
	//digger guards
	firefight_mode_set_squad_at(sq_e6_m5_dig_1, 31); //on the bridge
	firefight_mode_set_squad_at(sq_e6_m5_dig_2, 32); //on the bridge
	firefight_mode_set_squad_at(sq_e6_m5_dig_3, 33); //on the bridge
	firefight_mode_set_squad_at(sq_e6_m5_dig_4, 34); //on the bridge
	firefight_mode_set_squad_at(sq_e6_m5_dig_5, 35); //on the bridge

//waves (enemies that come from drop pods or phantoms
	firefight_mode_set_squad_at(sq_e6_m5_waves_1, 81);	//left building
	firefight_mode_set_squad_at(sq_e6_m5_waves_2, 82);	//front by the main start area
	firefight_mode_set_squad_at(sq_e6_m5_waves_3, 83);	//front by the main start area
	firefight_mode_set_squad_at(sq_e6_m5_waves_2_bishops, 84);	//front by the main start area
//	firefight_mode_set_squad_at(sq_e8_m1_waves_5, 85);	//front by the main start area	

	//shades
//	firefight_mode_set_squad_at(sq_e8_m1_shades_1, 31);	//left building

//	//phantoms
	firefight_mode_set_squad_at(sq_e6_m5_phanny, 21); //phantoms 


//create the maw
	object_create (dm_maw);

	//call the setup complete
	f_spops_mission_setup_complete( TRUE );	

end



// ==============================================================================================================
//====== START SCRIPTS ===============================================================================
// ==============================================================================================================


//start all the scripts that get kicked off at the beginning and end of player goals and all scripts that are required to start at the beginning of the mission
script static void f_start_all_events_e6_m5
	
//start all the event scripts	
	print ("starting all events");

	//start the intro thread
	thread(f_start_player_intro_e6_m5());

	//start the first starting event
	thread (f_start_events_e6_m5_1());
	print ("starting e6_m5_1");

	thread (f_start_events_e6_m5_2());
	print ("starting e6_m5_2");
	
	thread (f_start_events_e6_m5_3());
	print ("starting e6_m5_3");

	thread (f_start_events_e6_m5_4());
	print ("starting e6_m5_4");
	
	thread (f_start_events_e6_m5_5());
	print ("starting e6_m5_5");
	
	thread (f_start_events_e6_m5_6());
	print ("starting e6_m5_6");

//	thread (f_end_events_e6_m5_6());
//	print ("ending e6_m5_6");

	thread (f_start_events_e6_m5_7());
	print ("starting e6_m5_7");
	
	thread (f_start_events_e6_m5_8());
	print ("starting e6_m5_8");
	
end



//========STARTING E6 M5==============================
// here's where the scripts that control the mission go linearly and chronologically


//===== GET THE IFF tags
//players spawn and must get the IFF tags, prometheans spawn around the tags as players get close
script static void f_start_events_e6_m5_1
	sleep_until (LevelEventStatus("start_e6_m5_1"), 1);
	print ("started e6_m5_1 script");

	b_wait_for_narrative_hud = true;
	
	//sleep until mission complete
	sleep_until( f_spops_mission_start_complete(), 1 );
	//sleep_until (b_players_are_alive(), 1);
	
	//start music
	thread (f_e6_m5_music_start());
	thread (f_e6_m5_event0_start());
	
	//start guard, etc. trackers
	thread (f_e6_m5_start_guards());
	thread (f_e6_m5_start_other());
	thread (f_e6_m5_vo_tracker());

	//create some objective props
	//thread (f_e8_m1_props());
	
	//prep the digger explosives
	thread (f_e6_m5_prep_digger_expl());
	
	//commenting out the sleep and speeding up the fade to improve narrative of the intro
	fade_in (0,0,0,1);
	//sleep_s (0.5);
	//fade_in (0,0,0,15);

	//play the explosions
	thread (f_e6_m5_post_intro_effects());

	//play vo
	//vo_e6m5_collect_crimson();
	vo_e6m5_find_tags();
	
	f_new_objective (ch_6_5_1);
	//cinematic_set_title (ch_6_5_1);

	b_wait_for_narrative_hud = false;
	
	//power on the switches
	thread (f_e6_m5_tag_track());
	
end


script static void f_e6_m5_start_guards
	print ("start guards thread");
	thread (f_e6_m5_guards_ai (tv_e6_m5_guards1, sq_e6_m5_guards_1, sq_e6_m5_bishops_1));
	thread (f_e6_m5_guards_ai (tv_e6_m5_guards2, sq_e6_m5_guards_2, sq_e6_m5_bishops_2));
	thread (f_e6_m5_guards_ai (tv_e6_m5_guards3, sq_e6_m5_guards_3, sq_e6_m5_bishops_3));
	thread (f_e6_m5_guards_ai (tv_e6_m5_guards4, sq_e6_m5_guards_4, sq_e6_m5_bishops_4));
	
end

script static void f_e6_m5_start_other
	print ("start other thread");
	thread (f_e6_m5_other_ai (tv_e6_m5_other1, sq_e6_m5_other_1));
	thread (f_e6_m5_other_ai (tv_e6_m5_other2, sq_e6_m5_other_2));
	thread (f_e6_m5_other_ai (tv_e6_m5_other3, sq_e6_m5_other_3));
	thread (f_e6_m5_other_ai (tv_e6_m5_other4, sq_e6_m5_other_4));
	thread (f_e6_m5_other_ai (tv_e6_m5_other5, sq_e6_m5_other_5));
	thread (f_e6_m5_other_ai (tv_e6_m5_other6, sq_e6_m5_other_6));
	thread (f_e6_m5_other_ai_single (tv_e6_m5_other6, sq_e6_m5_other_7));
	thread (f_e6_m5_other_ai_single (tv_e6_m5_other6, sq_e6_m5_other_8));
	thread (f_e6_m5_waves_2_bishop_spawn());
end


script static void f_e6_m5_tag_track
	print ("start tag track");
	thread(f_e6_m5_tag_tracker (dc_e6_m5_iff1, sc_e6_m5_iff1, 91));
	thread(f_e6_m5_tag_tracker (dc_e6_m5_iff2, sc_e6_m5_iff2, 92));	
	thread(f_e6_m5_tag_tracker (dc_e6_m5_iff3, sc_e6_m5_iff3, 93));
	thread(f_e6_m5_tag_tracker (dc_e6_m5_iff4, sc_e6_m5_iff4, 94));
end

//===== ALL IFF TAGS ACTIVATED -- start no more waves -- kill all the ai

script static void f_start_events_e6_m5_2
	sleep_until (LevelEventStatus("start_e6_m5_2"), 1);
	print ("STARTING e6_m5_2 swarm");

	//b_wait_for_narrative_hud = true;
	
	//music threads
	thread (f_e6_m5_event0_stop());
	thread (f_e6_m5_event1_start());
	
	//might need to put in more pausing here to 
	//sleep until the 4th IFF tag VO is played -- see f_e6_m5_vo() function for more info -- might lose tracking the 4th VO if it gets too complicated
	sleep_until (b_done_with_iff_VO, 1);
	sleep_s (2);
	
	//play the VO
	vo_e6m5_where_switchback();		// Palmer : Crimson, Keep an eye out for any other sign of Switchback and make sure the Covenant don't reactivate the Harvester.
	
	
	//vo_e6m5_hold_covenant();  		// Palmer : Crimson, lock down the area.
	
	//b_wait_for_narrative_hud = false;
	thread (f_e6_m5_blip_battle());
	f_new_objective (ch_6_5_2);
	//cinematic_set_title (ch_6_5_2);
	
	//sleep_until there are a few AI left, then play vo about distracting the covenant
	sleep_until (ai_living_count (ai_ff_all) < 4, 1);
	vo_e6m5_distract_covenant();	//Miller : The only way to disable this thing for sure is to get inside.
	
end

//== START COVENANT COMPUTER GOAL ======

script static void f_start_events_e6_m5_3
	sleep_until (LevelEventStatus("start_e6_m5_3"), 1);
	print ("STARTING e6_m5_3 (cov computer)");
	b_wait_for_narrative_hud = true;
	
	thread (f_e6_m5_event1_stop());
	thread (f_e6_m5_event2_start());
	
	sleep_s (2);
	
	print ("preparing to switch zone set");
	//switch zone set during VO
	prepare_to_switch_to_zone_set(e6_m5_digger);
	
	
	//cinematic_set_title (ch_6_5_3);

	vo_e6m5_blow_leg();  // Miller : If we blow a few of these computers, it should get their attention. Marking one.
	
	//sleep until there's no pause
	sleep_until(not PreparingToSwitchZoneSet(), 1);
	switch_zone_set(e6_m5_digger);
	
	f_new_objective (ch_6_5_3);
	
	//turn on the HUD marker for the switch
	b_wait_for_narrative_hud = false;
	
	//sleep for drama for the VO
	sleep_s (1);
	vo_e6m5_blow_leg2();  // Palmer : That'll do. Crimson, light it up!
	
	//turn on the switch
	device_set_power (dc_e6_m5_comp, 1);
	
	object_create_anew(dm_e6_m5_door);
	
end

//== THE DIGGER IS OPEN ==
//the door to the digger is opening, the goal is to go inside

script static void f_start_events_e6_m5_4
	sleep_until (LevelEventStatus("start_e6_m5_4"), 1);
	print ("STARTING e6_m5_4");
	b_wait_for_narrative_hud = true;
	
	//set the respawn points for inside the digger once a player reaches mid-way through
	thread (f_e6_m5_respawn1());
	
	//music call
	thread (f_e6_m5_event2_stop());
	
	//sleep until the computer screen is fully animated
	sleep_until (device_get_position (dm_e6_m5_blow_digger) == 1, 1);
	
	thread (f_e6_m5_event3_start());
	
	//shake the camera for opening the door
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_breach\dm\spops_dm_e6m5_digger_ramp_open_rumble_mnde850', NONE, 1 ); //AUDIO!
	camera_shake_all_coop_players_breach (0.8, 0.8, 60, 0.6);

	sleep_s (1);
	
	//blow up first leg
	effect_new (objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, fl_e6_m5_computer);
	damage_new( 'fx\reach\fx_library\explosions\covenant_explosion_small\covenant_explosion_small.damage_effect', fl_e6_m5_computer);
	
	sleep_s (1);
	
	//blow the second leg
	effect_new (objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, fl_e6_m5_computer2);
	damage_new( 'fx\reach\fx_library\explosions\covenant_explosion_small\covenant_explosion_small.damage_effect', fl_e6_m5_computer2);
	//damage_new( 'objects\weapons\pistol\storm_target_laser\projectiles\damage_effects\airstrike_turret_round.damage_effect', fl_e6_m5_computer);
	
	sleep_s (2);
	
	device_set_position (dm_maw, 1);
	
	sleep_until (device_get_position (dm_maw) >= 0.5, 1);
	
	//play the VO
	vo_e6m5_after_explosion();  // Miller : Digger's opening. You got their attention alright!
	//need a clear them out line here

	f_new_objective (ch_6_5_5);
	//	cinematic_set_title (ch_6_5_5);
	
	b_wait_for_narrative_hud = false;
	
	//this is used twice -- might put this in it's own function
	//sleep until the final wave, then sleep until 5 people then blip
	sleep_until (firefight_mode_wave_get() == firefight_mode_waves_in_player_goal() - 1, 1);
		
	sleep_until (ai_living_count (ai_ff_all) <= 5, 1);
	print ("enemies alive playing VO");
	
	vo_glo15_palmer_fewmore_04();
	f_blip_ai_cui (ai_ff_all, "navpoint_enemy");
	
end

//== ALL AI ARE DEAD ==
//the players have killed all the AI in the digger and are about to be told to ensure the digger is disabled

script static void f_start_events_e6_m5_5
	sleep_until (LevelEventStatus("start_e6_m5_5"), 1);
	print ("STARTING e6_m5_5");

	b_wait_for_narrative_hud = true;
	
	//music scripts
	thread (f_e6_m5_event3_stop());
	thread (f_e6_m5_event4_start());
	
	//sleep for a bit to ensure the dead covenant don't get cleaned up too quickly
	sleep_s (2);
	
	//switch zone set during VO
	prepare_to_switch_to_zone_set(e6_m5);
	
	vo_e6m5_digger_offline();  // Palmer : Miller, where's the control center?
	vo_e6m5_ensure_digger();  // Miller : Digger is down but it won’t take much to get it back in working order.
	f_new_objective (ch_6_5_4);
	//cinematic_set_title (ch_6_5_4);
	//sleep_s (3);
	
	//sleep until there's no pause
	sleep_until(not PreparingToSwitchZoneSet(), 1);
	switch_zone_set(e6_m5);
	
	//sleep_s (1);
	
	b_wait_for_narrative_hud = false;
	//device_set_power (dc_e6_m5_dig, 1);
	e6_m5_digger_xpl();
end

script static void e6_m5_digger_xpl
	print ("start digger objective explosion");
	object_can_take_damage (coil1);
	object_can_take_damage (coil2);
	object_can_take_damage (coil3);
	object_can_take_damage (coil4);
	object_can_take_damage (coil5);
	object_can_take_damage (coil6);
	object_can_take_damage (coil7);
	object_can_take_damage (cr_e6_m5_exp1);
	object_can_take_damage (cr_e6_m5_exp2);

	//sleep until one of the fuel cells are destroyed
	sleep_until (object_get_health (cr_e6_m5_exp1) <= 0 or object_get_health (cr_e6_m5_exp2) <= 0, 1);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_breach\dm\spops_dm_e6m5_digger_disable_mnde6295', digger_active_hum_sfx, 1 ); //AUDIO!
	object_destroy ( digger_active_hum_sfx ); //DESTROY AUDIO!

// TJP - REMOVED 12-7: https://trochia:8443/browse/MN-3970 (causing crash)
//	sound_impulse_start ( 'sound\storm\multiplayer\pve\events\spops_rumble_med', NONE, 1 ); //SCREEN SHAKE AUDIO!
	camera_shake_all_coop_players_breach (0.3, 0.3, 30, 0.1);
	
end

//== KILL THE NEWLY SPAWNED PROMETHEANS ==
//with the digger disabled, some prometheans spawn (mainly through the bonobo tags), the player must kill them all to proceed

script static void f_start_events_e6_m5_6
	sleep_until (LevelEventStatus("start_e6_m5_6"), 1);
	print ("STARTING e6_m5_6");
	b_wait_for_narrative_hud = true;
	
	//set the respawn points for outside the digger once a player reaches just out of the digger
	thread (f_e6_m5_respawn2());
	//set the respawn points for close to the LZ once a player gets mid-way there
	thread (f_e6_m5_respawn3());
	
	
	//place the bishops
	ai_place_with_birth (sq_e6_m5_bishops_1);
	ai_place_with_birth (sq_e6_m5_bishops_2);
	ai_place_with_birth (sq_e6_m5_bishops_3);
	ai_place_with_birth (sq_e6_m5_bishops_4);	
	
	//change AI to obj_survival (try this to see if we can stop the rushing, if not then we'll need new squads
	ai_set_objective (gr_e6_m5_guards, obj_e6_m5_survival);
	
	//stop previous music
	thread (f_e6_m5_event4_stop());
	
	//start music
	thread (f_e6_m5_event5_start());
	
	//shake the camera for disabling the digger
	sound_impulse_start ( 'sound\storm\multiplayer\pve\events\spops_rumble_high', NONE, 1 ); //AUDIO!
	camera_shake_all_coop_players_breach (0.6, 0.6, 60, 0.6);
	
	sleep_s (1);
	
	//play the VO
	vo_e6m5_controls_down();  // Palmer : Enthusiasm, Crimson, I like it. Fall out. Murphy, prep for pickup.
	
	b_wait_for_narrative_hud = false;
	
	//marking the LZ
	thread (f_e6_m5_blip_end_battle());
	
	f_new_objective (ch_6_5_6);
	//cinematic_set_title (ch_6_5_6);
	
	//might need to time this out with the prometheans appearing
	sleep_until (ai_living_count (ai_ff_all) > 0, 1);
	
	sleep_s (1);
	
	vo_e6m5_the_lz();  // Miller : A few more Prometheans, late to the party!
	
	thread(f_e6_m5_need_to_kill_enemies());
	
	//sleep until the final wave, then sleep until 20 people then blip
	sleep_until (firefight_mode_wave_get() == firefight_mode_waves_in_player_goal() - 1, 1);
		
	sleep_until (ai_living_count (ai_ff_all) <= 20, 1);
	print ("enemies alive playing VO");
	
	vo_glo15_palmer_fewmore_07();
	f_blip_ai_cui (ai_ff_all, "navpoint_enemy");
	
end

script static void f_e6_m5_need_to_kill_enemies()  //Kschmitt - added for MNDE-6390
	sleep_until(volume_test_players(tv_e6_m5_exit_harvester), 1);
	vo_e6m5_kill_em_all();
end


//==GET TO THE LZ

script static void f_start_events_e6_m5_7
	sleep_until (LevelEventStatus("start_e6_m5_7"), 1);
	print ("starting e6_m5_8");
	
	//play VO for getting to LZ
	
	//music stop and start
	thread (f_e6_m5_event5_stop());
	
	//start music
	thread (f_e6_m5_event6_start());

end
//== END OF MISSION ==
//the player has killed all the prometheans and the mission ends

script static void f_start_events_e6_m5_8
	sleep_until (LevelEventStatus("start_e6_m5_8"), 1);
	//cinematic_set_title (ch_6_5_7);
	
	//place phanny the phantoms
	ai_place_in_limbo (sq_e6_m5_phanny);
	
	sleep_s (3);

	//play the VO
	vo_e6m5_covenant_cleared();  // Miller : Lieutenant Murphy, Crimson's in the clear.
	
	//music end
	f_e6_m5_music_stop();
	
	//fade out, play the outro, then end the mission
	f_e6_m5_end_mission();

	r_game_end_timer = 1;
	b_end_player_goal = true;

end


//end of last player goal




//=======ENDING E6 M5==============================

script static void f_e6_m5_end_mission
	print ("ending the mission with fadeout and chapter complete");
	fade_out (0,0,0,60);
		
	//cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
	sleep_s (2);
	
	ai_erase (sq_e6_m5_phanny);
	
	f_hide_players_outro();
	
	pup_disable_splitscreen (true);
	players_unzoom_all();
	local long show = pup_play_show(e6_m5_outro);
	thread (vo_e6m5_crimson_phantom());
	sleep_until (not pup_is_playing(show), 1);
	pup_disable_splitscreen (false);
	
	//turn on the episode complete screen
	cui_load_screen (ui\in_game\pve_outro\episode_complete.cui_screen);

end

script static void f_hide_players_outro
	print ("hiding the players");
//	player_enable_input (false);
	player_control_fade_out_all_input (.1);
	hud_show (false);
	
	if player_valid(player0) then
		 object_hide (player0, true);
	end
	
	if player_valid(player1) then
		 object_hide (player1, true);
	end
		 
	if player_valid(player2) then
		 object_hide (player2, true);
	end
	
	if player_valid(player3) then
		 object_hide (player3, true);
	end
end

//====== MISC SCRIPTS ===============================================================================

// miscellaneous or helper scripts

global boolean b_done_with_iff_VO = true;
global short s_iff_activated = 0;


//tracks when the IFF tags are picked up, plays one at a time and plays appropriate one if multiple IFF's are grabbed at around the same time.
script static void f_e6_m5_vo_tracker
	print ("starting VO tracker");
	
	local short vo_played = 0;
	//sleep until a tag is picked up, don't play them all in order, skip VO if the players pick up multiple tags during running VO
	repeat
		sleep_until (s_iff_activated > vo_played, 1);
		
		b_done_with_iff_VO = false;
		
		if s_iff_activated == 1 then
			//play VO here
				
			sleep_s (0.5);
			vo_e6m5_first_iff();
			//cinematic_set_title (ch_6_5_a);
			
		elseif s_iff_activated == 2 then
			print ("playing second tag activated");
				//play VO here
			
			sleep_s (0.5);
			vo_e6m5_second_iff();
			//cinematic_set_title (ch_6_5_b);
			
		elseif s_iff_activated == 3 then
			print ("playing third tag activated");
			//play VO here
			sleep_s (0.5);
			vo_e6m5_third_iff();
			//cinematic_set_title (ch_6_5_c);
			
		elseif s_iff_activated == 4 then
			print ("playing fourth tag activated");
			//play VO here
			sleep_s (0.5);
			vo_e6m5_fourth_iff();
			//cinematic_set_title (ch_6_5_d);
			
		end
		
		vo_played = vo_played + 1;
		
	until (s_iff_activated == 4, 1);
	

	b_done_with_iff_VO = true;

end


//this tracks the IFF tags, destroys the tags after they are picked up increased the IFF count (for VO purposes) and changes respawn points
script static void f_e6_m5_tag_tracker (device tag_dev, object tag_obj, short spawn)
	print ("start tag tracker");
	device_set_power (tag_dev, 1);
	
	//sleep until the IFF tag is picked up
	sleep_until (device_get_position (tag_dev) > 0, 1);
	print ("iff tag control activated, destroying appropriate iff scenery object");
	
	//destroy the object when it's done so it looks like the player picks it up
	object_destroy (tag_obj);
	
	//track how many IFF's have been picked up
	s_iff_activated = s_iff_activated + 1;
	
	//turn on respawn locations for the iff tags are picked up
	f_create_new_spawn_folder (spawn);
end


//
script static void f_e6_m5_prep_digger_expl
	print ("start prep digger explosion");
	object_cannot_take_damage (coil1);
	object_cannot_take_damage (coil2);
	object_cannot_take_damage (coil3);
	object_cannot_take_damage (coil4);
	object_cannot_take_damage (coil5);
	object_cannot_take_damage (coil6);
	object_cannot_take_damage (coil7);
	object_cannot_take_damage (cr_e6_m5_exp1);
	object_cannot_take_damage (cr_e6_m5_exp2);
	
end

global short s_blip_distance = 20;

script static void f_e6_m5_blip_battle
	print ("blip battle started");
	if player_valid (player0) then
		thread (f_e6_m5_player_blip_distance (player0, dc_e6_m5_comp, s_blip_distance, "navpoint_generic"));
	end
	
	if player_valid (player1) then
		thread (f_e6_m5_player_blip_distance (player1, dc_e6_m5_comp, s_blip_distance, "navpoint_generic"));
	end
	
	if player_valid (player2) then
		thread (f_e6_m5_player_blip_distance (player2, dc_e6_m5_comp, s_blip_distance, "navpoint_generic"));
	end
	
	if player_valid (player3) then
		thread (f_e6_m5_player_blip_distance (player3, dc_e6_m5_comp, s_blip_distance, "navpoint_generic"));
	end

end

script static void f_e6_m5_blip_end_battle
	print ("blip end battle started");
	
	s_blip_distance = 10;
	
	if player_valid (player0) then
		thread (f_e6_m5_player_blip_distance (player0, sc_e6_m5_lz, s_blip_distance, "navpoint_goto"));
	end
	
	if player_valid (player1) then
		thread (f_e6_m5_player_blip_distance (player1, sc_e6_m5_lz, s_blip_distance, "navpoint_goto"));
	end
	
	if player_valid (player2) then
		thread (f_e6_m5_player_blip_distance (player2, sc_e6_m5_lz, s_blip_distance, "navpoint_goto"));
	end
	
	if player_valid (player3) then
		thread (f_e6_m5_player_blip_distance (player3, sc_e6_m5_lz, s_blip_distance, "navpoint_goto"));
	end

end




//blip tracking
script static void f_e6_m5_player_blip_distance (player p_player, object target, short distance, string_id blip_type)
	print ("start blip distance");
	repeat
		//turn on the navpoint tracker per player and sleep until the player gets close
		sleep_until (objects_distance_to_object (p_player, target) >= distance or b_all_waves_ended, 1);
		if b_all_waves_ended == false then
			navpoint_track_object_for_player_named(p_player, target, blip_type);
			print ("blipping target");
		end
		sleep_until ((objects_distance_to_object (p_player, target) <= distance and objects_distance_to_object (p_player, target) > 0) or b_all_waves_ended, 1);
		print ("player within distance target, unblipping");
				
		//unblip the target because the player is close or all enemies killed
		//if navpoint_is_tracking_object_for_player (player, target) then //commenting this out because it crashes unless it's the absolute index
			navpoint_track_object_for_player (p_player, target, false);
		//end
	until (b_all_waves_ended, 1);

end
//camera script that supports ticks -- can't find the other shake scripts 
script static void camera_shake_all_coop_players_breach ( real attack, real intensity, short duration, real decay)

		
	if player_valid (player0) then
		//player_effect_set_max_rotation_for_player (player0, (intensity*3), (intensity*3), (intensity*3));
		//player_effect_set_max_rumble_for_player (player0, 1, 1);
		//player_effect_start_for_player (player0, intensity, attack);
		player_shake (player0, attack, intensity);
	end

	if player_valid (player1) then
		//player_effect_set_max_rotation_for_player (player1, (intensity*3), (intensity*3), (intensity*3));
		//player_effect_set_max_rumble_for_player (player1, 1, 1);	
		//player_effect_start_for_player (player1, intensity, attack);
		player_shake (player1, attack, intensity);
	end
		
	if player_valid (player2) then	
		//player_effect_set_max_rotation_for_player (player2, (intensity*3), (intensity*3), (intensity*3));
		//player_effect_set_max_rumble_for_player (player2, 1, 1);
		//player_effect_start_for_player (player2, intensity, attack);
		player_shake (player2, attack, intensity);
	end
	
	if player_valid (player3) then		
		//player_effect_set_max_rotation_for_player (player3, (intensity*3), (intensity*3), (intensity*3));	
		//player_effect_set_max_rumble_for_player (player3, 1, 1);
		//player_effect_start_for_player (player3, intensity, attack);
		player_shake (player3, attack, intensity);
	end
	
	sleep (duration);
	
	if player_valid (player0) then
		player_shake_stop (player0, decay);
		//player_effect_stop_for_player (player0, decay);
		//player_effect_set_max_rumble_for_player (player0, 0, 0);
	end
	
	if player_valid (player1) then
		player_shake_stop (player1, decay);
		//player_effect_set_max_rumble_for_player (player1, 0, 0);
		//player_effect_stop_for_player (player1, decay);
	end
	
	if player_valid (player2) then
		player_shake_stop (player2, decay);
		//player_effect_set_max_rumble_for_player (player2, 0, 0);
		//player_effect_stop_for_player (player2, decay);
	end
	
	if player_valid (player3) then
		player_shake_stop (player3, decay);
		//player_effect_set_max_rumble_for_player (player3, 0, 0);
		//player_effect_stop_for_player (player3, decay);
	end

end

script static void player_shake (player p_player, real attack, real intensity)
	player_effect_set_max_rotation_for_player (p_player, (intensity*3), (intensity*3), (intensity*3));
	player_effect_set_max_rumble_for_player (p_player, 1, 1);
	player_effect_start_for_player (p_player, intensity, attack);
end

script static void player_shake_stop (player p_player, real decay)
	player_effect_set_max_rumble_for_player (p_player, 0, 0);
	player_effect_stop_for_player (p_player, decay);
end


//==PUPPETEER SCRIPTS
//puppeteer for animating blowing the digger legs
global object g_ics_player = none;

script static void f_e6_m5_blow_digger (object dev, unit player)
	print ("blow digger animation");
	g_ics_player = player;
	
	local long show = pup_play_show(pup_e6_m5_blow_digger);
	sleep_until (not pup_is_playing(show), 1);
 	
 	sound_impulse_start ( 'sound\storm\multiplayer\pve\events\amb_scurve_dm_covenant_switch_activation', dm_e6_m5_blow_digger, 1 ); //AUDIO!
 	device_set_position (dm_e6_m5_blow_digger, 1);
 	sleep_until (device_get_position (dm_e6_m5_blow_digger) == 1, 1);
 	object_hide (dm_e6_m5_blow_digger, true);
 	
end

//puppeteer for animating digger switch (don't need anymore)
//script static void f_e6_m5_disable_digger (object dev, unit player)
//	print ("blow digger animation");
//	g_ics_player = player;
//	
////	local long show = pup_play_show(pup_e6_m5_disable_digger);
////	sleep_until (not pup_is_playing(show), 1);
// 	
// 	device_set_position (dm_e6_m5_disable_digger, 1);
// 	sleep_until (device_get_position (dm_e6_m5_disable_digger) == 1, 1);
// 	object_hide (dm_e6_m5_disable_digger, true);
// 	
//end


//==RESPAWN SCRIPTS
//turn these into one script
script static void f_e6_m5_respawn1
	print ("respawn1 started");
	
	sleep_until (volume_test_players (tv_e6_m5_digger2), 1);
	print ("respawn1 trigger volume hit, changing spawn points");
	f_create_new_spawn_folder (97);
end

script static void f_e6_m5_respawn2
	print ("respawn2 started");
	
	sleep_until (volume_test_players (tv_e6_m5_digger3), 1);
	print ("respawn2 trigger volume hit, changing spawn points");
	f_create_new_spawn_folder (95);
end

script static void f_e6_m5_respawn3
	print ("respawn3 started");
	
	sleep_until (volume_test_players (tv_e6_m5_guards_lg_1), 1);
	print ("respawn3 trigger volume hit, changing spawn points");
	f_create_new_spawn_folder (93);
end

// ==============================================================================================================
//====== PHANTOM COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================


//// PHANTOM 02 =================================================================================================== 

script static void test_phanny
	print ("spawn phanny");
	ai_place_in_limbo (sq_e6_m5_phanny);
	f_blip_object_cui (cr_e6_m5_exp2, "navpoint_healthbar_neutralize");
end

script command_script cs_e6_m5_phanny()
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep(2);
	ai_exit_limbo (ai_current_actor);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 30 );    //scale up to full size over time

	object_cannot_take_damage (ai_vehicle_get (ai_current_actor));
	object_immune_to_friendly_damage (ai_vehicle_get(ai_current_actor), true);

//	sleep (1);
//	object_cannot_die (v_ff_phantom_02, TRUE);
//	cs_enable_pathfinding_failsafe (TRUE);
//	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	//ai_set_blind (ai_current_squad, TRUE);
	cs_fly_by (ps_e6_m5_phanny.p0);
//		(print "flew by point 0")
	cs_fly_to (ps_e6_m5_phanny.p1);
//		(print "flew by point 1")

	sleep (30 * 1);


end


script command_script cs_e6_m5_knight_phase
	print ("knight phase in");
//	print_cs();
	sleep_rand_s (0.1, 0.6);
	cs_phase_in();
	ai_exit_limbo(ai_current_actor);
end

script command_script cs_e6_m5_knight_phase_test
	print ("knight phase in");
//	print_cs();
	sleep_rand_s (0.1, 0.6);
	cs_phase_in();
	ai_exit_limbo(ai_current_actor);
end

script command_script cs_e6_m5_pawn_spawn
	print ("pawns phase in");
	sleep_rand_s (0.1, 0.6);
	ai_exit_limbo(ai_current_actor);
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end




// ==============================================================================================================
//====== DROP POD AND TELEPORT SCRIPTS ===============================================================================
// ==============================================================================================================

//THIS SPAWNS IN THE GUARDS OF THE IFF TAGS ONCE THE PLAYER GETS CLOSE, UNLESS THERE ARE TOO MANY GUARDS
script static void f_e6_m5_guards_ai (trigger_volume tv, ai guards, ai bishop)
	print ("starting guards ai");
	sleep_until (volume_test_players (tv), 1);
	print ("trigger volume hit");
	
	if ai_living_count (ai_ff_all) <= 12 then
		print ("ai count low enough, spawning knight and bishop guards");
		
		//stinger audio
		thread (f_e6_m5_stinger_guards());
		
		ai_place_in_limbo (guards);
		sleep_until (ai_living_count (guards) > 0, 1);
		print ("guards spawned");
		ai_place_with_birth (bishop);
		sleep_until (ai_living_count (bishop) > 0, 1);
		print ("bishop spawned");
	else
		print ("ai count too high, not spawning guards");
	end
	
end

//THIS SPAWNS IN THE OTHER AI ONCE THE PLAYER GETS IN THE TRIGGER VOLUME
script static void f_e6_m5_other_ai (trigger_volume tv, ai other,)
	print ("starting other ai");
	
	repeat
		//sleep until a player hits the trigger volume
		sleep_until (volume_test_players (tv), 1);
		print ("trigger volume hit");	
	
		//if the mission is at the digger then sleep this script
		if firefight_mode_goal_get() > 1 then
			sleep_forever();
			print ("mission is past the point to spawn others, killing the script");
		end
	
		//spawn others if AI count is low enough, else don't spawn :(
		if ai_living_count (ai_ff_all) <= 3 then
			print ("ai living count low enough for 6, spawning 6 in other squad");	
			
			//stinger audio
			thread (f_e6_m5_stinger_other());
			
			ai_place_in_limbo (other, 6);
			sleep_until (ai_living_count (other) > 0, 1);
			print ("other spawned");
			sleep_forever();
			print ("script didn't sleep");
		elseif ai_living_count (ai_ff_all) <= 6 then
			print ("ai living count low for 3, spawning 3 in other squad");	
			
			//stinger audio
			thread (f_e6_m5_stinger_other());
			
			ai_place_in_limbo (other, 3);
			sleep_until (ai_living_count (other) > 0, 1);
			print ("other spawned");
			sleep_forever();
		
		else
			print ("AI count too high, don't spawn");
		end	
	until (firefight_mode_goal_get() > 1, 1);
	
end

script static void f_e6_m5_waves_2_bishop_spawn
	sleep_until (LevelEventStatus("waves_2_bishops"), 1);
	print ("waves 2 bishops spawning");
	ai_place_with_birth (sq_e6_m5_waves_2_bishops);
end

//THIS SPAWNS IN THE OTHER AI ONCE THE PLAYER GETS IN THE TRIGGER VOLUME
script static void f_e6_m5_other_ai_single (trigger_volume tv, ai other,)
	print ("starting other ai");
	
	repeat
		//sleep until a player hits the trigger volume
		sleep_until (volume_test_players (tv), 1);
		print ("trigger volume hit");	
	
		//if the mission is at the digger then sleep this script
		if firefight_mode_goal_get() > 1 then
			sleep_forever();
			print ("mission is past the point to spawn others, killing the script");
		end
	
		//spawn others if AI count is low enough, else don't spawn :(
		if ai_living_count (ai_ff_all) <= 18 and not volume_test_players (tv_e6_m5_failsafe) then
			ai_place (other);
			sleep_until (ai_living_count (other) > 0, 1);
			print ("single spawned");
			//f_blip_ai_cui(other, "navpoint_enemy");
			sleep_forever();
		else
			print ("AI count too high, don't spawn");
		end
//		if ai_living_count (ai_ff_all) <= 3 then
//			print ("ai living count low enough for 6, spawning 6 in other squad");	
//			ai_place_in_limbo (other, 6);
//			sleep_until (ai_living_count (other) > 0, 1);
//			print ("other spawned");
//			sleep_forever();
//			print ("script didn't sleep");
//		elseif ai_living_count (ai_ff_all) <= 6 then
//			print ("ai living count low for 3, spawning 3 in other squad");	
//			ai_place_in_limbo (other, 3);
//			sleep_until (ai_living_count (other) > 0, 1);
//			print ("other spawned");
//			sleep_forever();
//		
//		else
//			print ("AI count too high, don't spawn");
//		end	
	until (firefight_mode_goal_get() > 1, 1);

end


// ==============================================================================================================
//====== INTRO ===============================================================================
// ==============================================================================================================

//called immediately when starting the mission, these scripts control the vignettes and scripts that start after the player spawns

script static void f_start_player_intro_e6_m5

	
	sleep_until (f_spops_mission_ready_complete(), 1);
		//intro();
	if editor_mode() then
		print ("editor mode, no intro playing");
		sleep_s(1);
		//f_e6_m5_intro_vignette();
	else
		print ("NOT editor mode play the intro");
		f_e6_m5_intro_vignette();
	end
	
	//tell engine the intro is complete
	f_spops_mission_intro_complete( TRUE );
	
		
end


script static void f_e6_m5_intro_vignette
	//set up, play and clean up the intro
	print ("playing intro");
	//sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e3m2_vin_sfx_intro', NONE, 1);
	
	ai_enter_limbo (gr_e6_m5_ff_all);
	pup_disable_splitscreen (true);

	//play the puppeteer intro, sleep until it's done	
	local long show = pup_play_show(e6_m5_intro);
	thread (vo_e6m5_entrance_roach());
	sleep_until (not pup_is_playing(show), 1);
	
	pup_disable_splitscreen (false);
	ai_exit_limbo (gr_e6_m5_ff_all);
	print ("all ai exiting limbo after the puppeteer");
end

//tells the script when the narrative is done -- called from within puppeteer
//script static void f_e6_m5_narrative_done
//	print ("narrative done");
//	b_e6_m5_wait_for_narrative = false;
//
//end

//global real s_explosion = 1;
global real r_expl1 = 0.2;
global real r_expl2 = 0.8;

//play explosions after player is spawned to simulate broadswords bombing the digger
script static void f_e6_m5_post_intro_effects
	
	print ("intro is done, player is spawned now create explosions");

	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_breach\dm\spops_dm_e6m5_airstrike_screenshake_mnde9932', NONE, 1 ); //SCREENSHAKE AUDIO!
	f_e6_m5_effects (fl_e6_m5_intro1, 15);
	f_e6_m5_effects (fl_e6_m5_intro2, 12);
	f_e6_m5_effects (fl_e6_m5_intro3, 8);
	f_e6_m5_effects (fl_e6_m5_intro4,	3);
	f_e6_m5_effects (fl_e6_m5_intro5, 3);
	

	
end

script static void f_e6_m5_effects (cutscene_flag flag, short time)
	print ("explosion boom");
	effect_new (levels\dlc\ff155_breach\fx\debris\debris_impact_explosion_large.effect, flag);
	camera_shake_all_coop_players_breach (0.6, 0.6, time, 0.1);
	//sleep_s (real_random_range (r_expl1, r_expl2));
	sleep (time);
end
// ==============================================================================================================
// ====== TEST ===============================================================================
// ==============================================================================================================