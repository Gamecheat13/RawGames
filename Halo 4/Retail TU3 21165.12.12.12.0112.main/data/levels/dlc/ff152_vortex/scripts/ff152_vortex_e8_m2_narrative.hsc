//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	Mission: 					SPARTAN OPS: E8M2 - Artillery
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: NARRATIVE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------

global boolean b_e8m2_narrative_is_on = FALSE;
global boolean b_e8m2_pelican_intro_deployed = FALSE;
global boolean b_e8m2_pelican_intro_destroyed = FALSE;

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_narrative_init::: Init
script dormant f_e8_m2_narrative_init()
	dprint( "f_e8_m2_narrative_init" );
	
	// initialize sub-modules
	wake( f_e8_m2_narrative_intro_init );
	wake( f_e8_m2_narrative_outro_init );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: NARRATIVE: INTRO ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_narrative_intro_init::: Init
script dormant f_e8_m2_narrative_intro_init()
	dprint( "f_e8_m2_narrative_intro_init" );

	// setup trigger
	wake( f_e8_m2_narrative_intro_trigger );

end

// === f_e8_m2_narrative_intro_trigger::: Trigger
script dormant f_e8_m2_narrative_intro_trigger()
	sleep_until( f_spops_mission_ready_complete(), 1 );
	dprint( "f_e8_m2_narrative_intro_trigger" );

	// trigger action
	wake( f_e8_m2_narrative_intro_action );

end

// === f_e8_m2_narrative_intro_action::: Action
script dormant f_e8_m2_narrative_intro_action()
local long l_pup_id = -1;
	dprint( "f_e8_m2_narrative_intro_action" );

	// prep for pup
//	ai_enter_limbo( ai_ff_all );

	//if ( TRUE ) then
	if  not editor_mode() then 

		if ( editor_mode() ) then
			sleep_until( b_players_are_alive(), 1 );
		end
	
		//cinematic_start();
		f_e8_m2_audio_intro_start();
		f_e8_m2_ai_intro_start();

		// XXX TEMP
		wake( f_e8_m2_dialog_intro );

		l_pup_id = pup_play_show( 'pup_e8_m2_intro_01' );
		sleep_until( not pup_is_playing(l_pup_id), 1 );
		object_create_anew( vh_e8_m2_warthog_lz_01 );
		f_spops_mission_intro_complete( TRUE );

		f_e8_m2_audio_intro_end();
		f_e8_m2_ai_intro_end();
		
	else
		object_create( vh_e8_m2_warthog_lz_01 );
		sleep( 1 );
		f_spops_mission_intro_complete( TRUE );
		
	end
	
	sleep_until( b_players_are_alive(), 1 );
	l_pup_id = pup_play_show( 'pup_e8_m2_intro_02' );
	thread( f_e8_m2_pup_2_start () );
	sleep( 1 );
	Camera_control( FALSE );
	Fade_in  (0, 0, 0, 10);
	sleep( 5 );
	hud_show( TRUE );
	object_set_physics( vh_e8_m2_pelican_lz_02, TRUE );
	
end
script static boolean f_e8_m2_narrative_intro_pelican_02_fallback()
	dialog_id_played_check(L_e8_m2_dialog_start) or dialog_foreground_id_line_index_check_greater_equel( L_e8_m2_dialog_start, 3 );
end

script static void f_e8_m2_pup_2_start()

	//f_e8_m2_ai_pelican_init( pup_current_puppet );
	wake( f_e8_m2_ai_intro_spartans_unload );
	ai_place( sq_e8m2_lz_murphy );
end

global boolean b_e8_m2_pelican_intro_done = FALSE;
global boolean b_e8_m2_pelican_outro_done = FALSE;

script command_script cs_pelican_murphy()
sleep_until( spops_ai_get_vehicle(ai_current_actor) != NONE, 1 );
local vehicle vh_pelican = spops_ai_get_vehicle( ai_current_actor );

	object_cannot_die( vh_pelican, TRUE);
	ai_cannot_die( ai_current_actor, TRUE );

	if b_e8_m2_pelican_intro_done then

		object_cannot_take_damage( vh_pelican );
		object_move_to_point( vh_pelican, 0,  ps_e8_m2_pelican_murphy.pOutroStart);
		object_set_scale( vh_pelican, 0.8, 0 );
		cs_vehicle_speed ( 0.6 );
		cs_fly_to(ps_e8_m2_pelican_murphy.p7 );
		
		object_set_scale( vh_pelican, 1, 3 * 40 );
		cs_fly_to(ps_e8_m2_pelican_murphy.p5 );
		spops_blip_object( vh_pelican, TRUE, "default" );
		cs_vehicle_speed ( 0.45 );
		cs_fly_to_and_dock(ps_e8_m2_pelican_murphy.pOutroEnd, ps_e8_m2_pelican_murphy.p4, 3 );
		cs_vehicle_speed ( 0.2 );
		cs_fly_to_and_dock(ps_e8_m2_pelican_murphy.pOutroEnd, ps_e8_m2_pelican_murphy.p4, 0.5 );
		b_e8_m2_pelican_outro_done = TRUE;
	else
	
		b_e8_m2_pelican_intro_done  = TRUE;
		object_move_to_point( vh_pelican, 0,  ps_e8_m2_pelican_murphy.pIntroStart);
		cs_vehicle_speed ( 0.3 );
		ai_braindead( ai_current_actor, TRUE );
		sleep_s( 3.5 );
		ai_braindead( ai_current_actor, FALSE );
		cs_fly_to(ps_e8_m2_pelican_murphy.p0 );
		cs_vehicle_speed ( 0.6 );
		cs_fly_by(ps_e8_m2_pelican_murphy.p1 );
		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.8, 3 * 30 );
		cs_fly_by(ps_e8_m2_pelican_murphy.p2 );
		object_set_scale( ai_vehicle_get( ai_current_actor ), 0.5, 3 * 30 );
		cs_fly_by(ps_e8_m2_pelican_murphy.p3 );
		object_cannot_die( vh_pelican, FALSE);
		object_destroy( vh_pelican );		
		ai_erase(ai_current_actor);

	end


end

//vehicle_hover( ai_vehicle_get( sq_e8m2_lz_murphy.murphy ), TRUE )

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: NARRATIVE: OUTRO ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_narrative_outro_init::: Init
script dormant f_e8_m2_narrative_outro_init()
	dprint( "f_e8_m2_narrative_outro_init" );
	
end


// ============================================	VO SCRIPT	========================================================
// NOTE: MOVED TO e8_m2_dialog script
/*
script static void vo_e8m2_guns_fire()

b_e8m2_narrative_is_on = TRUE;

// Palmer : Majestic, hang tight. We’re about to deal with your artillery trouble.
dprint ("Palmer: Majestic, hang tight. We’re about to deal with your artillery trouble." );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_guns_fire_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_guns_fire_00100') );
sleep(10 );

// Demarco : Understood, Commander.
dprint ("Demarco: Understood, Commander." );
spops_radio_transmission_start_demarco();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_guns_fire_00101', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_guns_fire_00101') );
sleep(10 );

// Miller : Commander, the Covies were ready for us. Like they knew we were coming.
dprint ("Miller: Commander, the Covies were ready for us. Like they knew we were coming." );
spops_radio_transmission_start_miller();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_guns_fire_00102', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_guns_fire_00102') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end


script static void vo_e8m2_spartans_warthogs()

b_e8m2_narrative_is_on = TRUE;

// Dalton : Dalton to Commander Palmer. Fireteam Kodiak is on station. Warthogs deployed.
dprint ("Dalton: Dalton to Commander Palmer. Fireteam Kodiak is on station. Warthogs deployed." );
spops_radio_transmission_start_dalton();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_spartans_warthogs_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_spartans_warthogs_00100') );
sleep(10 );

// Palmer : Acknowledged, Dalton. Tell your people to be careful--
dprint ("Palmer: Acknowledged, Dalton. Tell your people to be careful--" );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_spartans_warthogs_00101', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_spartans_warthogs_00101') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end


script static void vo_e8m2_shot_down()

b_e8m2_narrative_is_on = TRUE;

// Murphy : Covies hit Kodiak’s Pelican! They’re down!
dprint ("Murphy: Covies hit Kodiak’s Pelican! They’re down!" );
spops_radio_transmission_start_general();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_shot_down_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_shot_down_00100') );
sleep(10 );

// Dalton : Fall back, Murphy. Crimson will call when they need a ride home.
dprint ("Dalton: Fall back, Murphy. Crimson will call when they need a ride home." );
spops_radio_transmission_start_dalton();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_shot_down_00101', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_shot_down_00101') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end


script static void vo_e8m2_switchback_greeting()

b_e8m2_narrative_is_on = TRUE;

// Kodiak Leader : Crimson! How’s it going? Ready to knock some Covie heads together?
dprint ("Kodiak Leader: Crimson! How’s it going? Ready to knock some Covie heads together?" );
spops_radio_transmission_start_general();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_switchback_greeting_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_switchback_greeting_00100') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end


script static void vo_e8m2_artillery()

b_e8m2_narrative_is_on = TRUE;

// Miller : Commander, I’ve identified the artillery emplacements hitting Majestic’s position. They're spread along the ridge line.
dprint ("Miller: Commander, I’ve identified the artillery emplacements hitting Majestic’s position. They're spread along the ridge line." );
spops_radio_transmission_start_miller();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_00100') );
sleep(10 );

// Palmer : Lined up in a neat little row for you, Crimson. They make it too easy.
dprint ("Palmer: Lined up in a neat little row for you, Crimson. They make it too easy." );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_00101', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_00101') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end


script static void vo_e8m2_clear_covies()

b_e8m2_narrative_is_on = TRUE;

// Miller : Area’s clear, Commander.
dprint ("Miller: Area’s clear, Commander." );
spops_radio_transmission_start_miller();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_clear_covies_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_clear_covies_00100') );
sleep(10 );

// Palmer : Then it’s time to hit those emplacements.
dprint ("Palmer: Then it’s time to hit those emplacements." );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_clear_covies_00101', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_clear_covies_00101') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end


script static void vo_e8m2_doesnt_know()

b_e8m2_narrative_is_on = TRUE;

// Palmer : Miller, best place to hit that artillery?
dprint ("Palmer: Miller, best place to hit that artillery?" );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_doesnt_know_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_doesnt_know_00100') );
sleep(10 );

// Miller : Looking now. It's a mix of Covenant and Forerunner tech... Give me just a minute.
dprint ("Miller: Looking now. It's a mix of Covenant and Forerunner tech... Give me just a minute." );
spops_radio_transmission_start_miller();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_doesnt_know_00101', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_doesnt_know_00101') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end


script static void vo_e8m2_first_artillery_1()

b_e8m2_narrative_is_on = TRUE;

// Miller : Marking the first artillery now.
dprint ("Miller: Marking the first artillery now." );
spops_radio_transmission_start_miller();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_first_artillery_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_first_artillery_00100') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end
script static void vo_e8m2_first_artillery_2()

b_e8m2_narrative_is_on = TRUE;

// Demarco : Commander! Not to be rude, but how much longer are we gonna have shells raining down on our heads?
dprint ("Demarco: Commander! Not to be rude, but how much longer are we gonna have shells raining down on our heads?" );
spops_radio_transmission_start_demarco();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_first_artillery_00101', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_first_artillery_00101') );
sleep(10 );

// Palmer : Crimson’s working on it, Demarco.
dprint ("Palmer: Crimson’s working on it, Demarco." );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_first_artillery_00102', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_first_artillery_00102') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end

script static void vo_e8m2_final_artillery()

b_e8m2_narrative_is_on = TRUE;

// Palmer : Alright, Crimson. Step it up. Take out that final piece of artillery.
dprint ("Palmer: Alright, Crimson. Step it up. Take out that final piece of artillery." );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_final_artillery_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_final_artillery_00100') );
sleep(10 );

// Palmer : Majestic, all clear. You owe Crimson a round once you’re all home.
dprint ("Palmer: Majestic, all clear. You owe Crimson a round once you’re all home." );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_final_artillery_00101', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_final_artillery_00101') );
sleep(10 );

// Demarco : Happy to pay the debt, Commander. Tell them we said thanks.
dprint ("Demarco: Happy to pay the debt, Commander. Tell them we said thanks." );
spops_radio_transmission_start_demarco();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_final_artillery_00102', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_final_artillery_00102') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end



// Demarco : Commander…
dprint ("Demarco: Commander…" );
spops_radio_transmission_start_demarco();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_powercore_00102', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_powercore_00102') );
sleep(10 );

// Palmer : Demarco. Settle. Crimson’s working on it.
dprint ("Palmer: Demarco. Settle. Crimson’s working on it." );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_powercore_00103', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_powercore_00103') );

script static void vo_e8m2_artillery_powercore()

b_e8m2_narrative_is_on = TRUE;

// Miller : Commander, that shield isn't going to come down with what Crimson is carrying. But there’s an energy conduit nearby that heats up whenever the artillery fires.
dprint ("Miller: Commander, that shield isn't going to come down with what Crimson is carrying. But there’s an energy conduit nearby that heats up whenever the artillery fires." );
spops_radio_transmission_start_miller();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_powercore_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_powercore_00100') );
sleep(10 );

// Palmer : Power source, eh? Try hitting the conduit, Crimson.
dprint ("Palmer: Power source, eh? Try hitting the conduit, Crimson." );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_powercore_00101', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_powercore_00101') );
sleep(10 );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end

script static void vo_e8m2_powercore_hit()

b_e8m2_narrative_is_on = TRUE;

// Palmer : I'm no scientist, but I'd say that did something.
dprint ("Palmer: I'm no scientist, but I'd say that did something." );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_powercore_hit_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_powercore_hit_00100') );
sleep(10 );

// Miller : Ah! I get it! Without the conduits, the gun overloads!
dprint ("Miller: Ah! I get it! Without the conduits, the gun overloads!" );
spops_radio_transmission_start_miller();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_powercore_hit_00101', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_powercore_hit_00101') );
sleep(10 );

// Palmer : Keep hitting the conduit, Crimson!
dprint ("Palmer: Keep hitting the conduit, Crimson!" );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_powercore_hit_00102', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_powercore_hit_00102') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end


script static void vo_e8m2_destroy_core()

b_e8m2_narrative_is_on = TRUE;

// Palmer : Keep hitting that conduit, Crimson!
dprint ("Palmer: Keep hitting that conduit, Crimson!" );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_destroy_core_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_destroy_core_00100') );
sleep(10 );

// Palmer : Don't leave this job half done, Crimson.
dprint ("Palmer: Don't leave this job half done, Crimson." );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_destroy_core_00101', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_destroy_core_00101') );
sleep(10 );

// Palmer : Bring the conduit down, Crimson. Now!
dprint ("Palmer: Bring the conduit down, Crimson. Now!" );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_destroy_core_00102', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_destroy_core_00102') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end

script static void vo_e8m2_first_conduit_destroyed()

b_e8m2_narrative_is_on = TRUE;

// Miller : Conduit destroyed!
dprint ("Miller: Conduit destroyed!" );
spops_radio_transmission_start_miller();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_first_conduit_destroyed_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_first_conduit_destroyed_00100') );
sleep(10 );

// Palmer : But that artillery is still firing.
dprint ("Palmer: But that artillery is still firing." );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_first_conduit_destroyed_00101', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_first_conduit_destroyed_00101') );
sleep(10 );

// Miller : Looks like the artillery is destabilizing.
dprint ("Miller: Looks like the artillery is destabilizing." );
spops_radio_transmission_start_miller();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_first_conduit_destroyed_00102', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_first_conduit_destroyed_00102') );
sleep(10 );

// Palmer : So if Crimson hits the other conduit…
dprint ("Palmer: So if Crimson hits the other conduit…" );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_first_conduit_destroyed_00103', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_first_conduit_destroyed_00103') );
sleep(10 );

// Miller : That’s what I’m thinking too. Painting a waypoint now.
dprint ("Miller: That’s what I’m thinking too. Painting a waypoint now." );
spops_radio_transmission_start_miller();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_first_conduit_destroyed_00104', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_first_conduit_destroyed_00104') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end
script static void vo_e8m2_core_destroyed()

b_e8m2_narrative_is_on = TRUE;

// Miller : That's the last conduit. Uh... you may want to back away, Crimson. When that artillery fires again, it’s gonna be a mess.
dprint ("Miller: That's the last conduit. Uh... you may want to back away, Crimson. When that artillery fires again, it’s gonna be a mess." );
spops_radio_transmission_start_miller();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_core_destroyed_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_core_destroyed_00100') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end

script static void vo_e8m2_move_away()

b_e8m2_narrative_is_on = TRUE;

// Palmer : Crimson! Fall back before that gun tries to fire again!
dprint ("Palmer: Crimson! Fall back before that gun tries to fire again!" );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_move_away_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_move_away_00100') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end

script static void vo_e8m2_artillery_explodes()

b_e8m2_narrative_is_on = TRUE;

// Miller : Success!
dprint ("Miller: Success!" );
spops_radio_transmission_start_miller();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_explodes_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_explodes_00100') );
sleep(10 );

// Palmer : Alright, one down. Hit the rest of the emplacements, Crimson.
dprint ("Palmer: Alright, one down. Hit the rest of the emplacements, Crimson." );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_explodes_00101', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_artillery_explodes_00101') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end

script static void vo_e8m2_another_artillery_destroyed()

b_e8m2_narrative_is_on = TRUE;

// Palmer : That's two.
dprint ("Palmer: That's two." );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_another_artillery_destroyed_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_another_artillery_destroyed_00100') );
sleep(10 );

// Demarco : How many more to go, Commander?
dprint ("Demarco: How many more to go, Commander?" );
spops_radio_transmission_start_demarco();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_another_artillery_destroyed_00101', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_another_artillery_destroyed_00101') );
sleep(10 );

// Palmer : Just one, Demarco. Relax.
dprint ("Palmer: Just one, Demarco. Relax." );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_another_artillery_destroyed_00102', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_another_artillery_destroyed_00102') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end
script static void vo_e8m2_final_artillery()
// Palmer : Majestic, all clear. You owe Crimson a round once you’re all home.
dprint ("Palmer: Majestic, all clear. You owe Crimson a round once you’re all home." );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_final_artillery_00101', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_final_artillery_00101') );
sleep(10 );

// Demarco : Happy to pay the debt, Commander. Tell them we said thanks.
dprint ("Demarco: Happy to pay the debt, Commander. Tell them we said thanks." );
spops_radio_transmission_start_demarco();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_final_artillery_00102', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_final_artillery_00102') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end

script static void vo_e8m2_next_artillery()

b_e8m2_narrative_is_on = TRUE;

// Miller : Covenant are falling back to the next artillery.
dprint ("" );
sound_impulse_start (, NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_next_artillery_00100') );
sleep(10 );

// Palmer : Stay on their heels, Crimson.
dprint ("" );
sound_impulse_start (, NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_next_artillery_00101') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end

script static void vo_e8m2_swarm_last_artillery()

b_e8m2_narrative_is_on = TRUE;

// Miller : Covenant massing at the final artillery.
dprint ("Miller: Covenant massing at the final artillery." );
spops_radio_transmission_start_miller();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_swarm_last_artillery_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_swarm_last_artillery_00100') );
sleep(10 );

// Palmer : If they want to go down with the ship, sink 'em.
dprint ("Palmer: If they want to go down with the ship, sink 'em." );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_swarm_last_artillery_00101', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_swarm_last_artillery_00101') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end

script static void vo_e8m2_fall_back()

b_e8m2_narrative_is_on = TRUE;

// Palmer : Fallback! Secure the LZ so Murphy can pull you out of there.
dprint ("Palmer: Fallback! Secure the LZ so Murphy can pull you out of there." );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_fall_back_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_fall_back_00100') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end

script static void vo_e8m2_pelican_inbound()

b_e8m2_narrative_is_on = TRUE;

// Palmer : Bring Crimson home, Miller.
dprint ("Palmer: Bring Crimson home, Miller." );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_pelican_inbound_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_pelican_inbound_00100') );
sleep(10 );

// Miller : You got it, Commander. Murphy, Crimson’s ready for pickup.
dprint ("Miller: You got it, Commander. Murphy, Crimson’s ready for pickup." );
spops_radio_transmission_start_miller();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_pelican_inbound_00101', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_pelican_inbound_00101') );
sleep(10 );

// Murphy : Actually, Spartans, you got Phantoms in the area.
dprint ("Murphy: Actually, Spartans, you got Phantoms in the area." );
spops_radio_transmission_start_general();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_pelican_inbound_00102', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_pelican_inbound_00102') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end

script static void vo_e8m2_phantom_down()

b_e8m2_narrative_is_on = TRUE;

// Miller : Phantom down! Air is clear! Come on down, Murphy.
dprint ("Miller: Phantom down! Air is clear! Come on down, Murphy." );
spops_radio_transmission_start_miller();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_phantom_down_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_phantom_down_00100') );
sleep(10 );

// Murphy : On my way.
dprint ("Murphy: On my way." );
spops_radio_transmission_start_general();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_phantom_down_00101', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_phantom_down_00101') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end

script static void vo_e8m2_phantom_incoming()

b_e8m2_narrative_is_on = TRUE;

// Miller : He’s right, Commander. Phantom dropping reinforcements!
dprint ("Miller: He’s right, Commander. Phantom dropping reinforcements!" );
spops_radio_transmission_start_miller();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_phantom_incoming_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_phantom_incoming_00100') );
sleep(10 );

// Palmer : You’d think after we killed the first thousand of these goons they’d give up. Crimson, second verse, same as the first.
dprint ("Palmer: You’d think after we killed the first thousand of these goons they’d give up. Crimson, second verse, same as the first." );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_phantom_incoming_00101', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_phantom_incoming_00101') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end

script static void vo_e8m2_secure_channel()

b_e8m2_narrative_is_on = TRUE;

// Miller : Oh, strange.
dprint ("Miller: Oh, strange." );
spops_radio_transmission_start_miller();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_secure_channel_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_secure_channel_00100') );
sleep(10 );

// Palmer : Elaborate, Miller.
dprint ("Palmer: Elaborate, Miller." );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_secure_channel_00101', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_secure_channel_00101') );
sleep(10 );

// Miller : Just a second after I directed Crimson to the artillery, the Covenant made for it as well.
dprint ("Miller: Just a second after I directed Crimson to the artillery, the Covenant made for it as well." );
spops_radio_transmission_start_miller();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_secure_channel_00102', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_secure_channel_00102') );
sleep(10 );

// Palmer : Could be a coincidence…
dprint ("Palmer: Could be a coincidence…" );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_secure_channel_00103', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_secure_channel_00103') );
sleep(10 );

// Miller : Yeah...
dprint ("Miller: Yeah..." );
spops_radio_transmission_start_miller();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_secure_channel_00104', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_secure_channel_00104') );
sleep(10 );

// Palmer : It’s so not a coincidence, is it?
dprint ("Palmer: It’s so not a coincidence, is it?" );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_secure_channel_00105', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_secure_channel_00105') );
sleep(10 );

// Miller : I’ll keep an eye on it.
dprint ("Miller: I’ll keep an eye on it." );
spops_radio_transmission_start_miller();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_secure_channel_00106', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_secure_channel_00106') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end


script static void vo_e8m2_dropping_supplies()

b_e8m2_narrative_is_on = TRUE;

// Miller : Dalton, can we get some extra gear for Crimson?
dprint ("Miller: Dalton, can we get some extra gear for Crimson?" );
spops_radio_transmission_start_miller();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_dropping_supplies_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_dropping_supplies_00100') );
sleep(10 );

// Demarco : You bet. Inbound on their position now.
dprint ("Demarco: You bet. Inbound on their position now." );
spops_radio_transmission_start_demarco();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_dropping_supplies_00101', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_dropping_supplies_00101') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end

script static void vo_e8m2_great_job()

b_e8m2_narrative_is_on = TRUE;

// Palmer : You make this look so easy, Crimson.
dprint ("Palmer: You make this look so easy, Crimson." );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_great_job_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_great_job_00100') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end




script static void vo_e8m2_phantom_circling()

b_e8m2_narrative_is_on = TRUE;

// Miller : Phantom’s still circling, trying to lock the area down.
dprint ("Miller: Phantom’s still circling, trying to lock the area down." );
spops_radio_transmission_start_miller();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_phantom_circling_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_phantom_circling_00100') );
sleep(10 );

// Murphy : He ain’t trying anything. He’s damn well doing it.
dprint ("Murphy: He ain’t trying anything. He’s damn well doing it." );
spops_radio_transmission_start_general();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_phantom_circling_00101', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_phantom_circling_00101') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end


script static void vo_e8m2_destroy_phantom()

b_e8m2_narrative_is_on = TRUE;

// Palmer : Crimson, get that Phantom off Murphy's tail!
dprint ("Palmer: Crimson, get that Phantom off Murphy's tail!" );
spops_radio_transmission_start_palmer();
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_destroy_phantom_00100', NONE, 1 );
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_02\e08m2_destroy_phantom_00100') );

b_e8m2_narrative_is_on = FALSE;
spops_radio_transmission_end_all();

end

*/
