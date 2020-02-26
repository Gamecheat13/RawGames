//=============================================================================================================================
//============================================ E8M4 FACTORY NARRATIVE SCRIPT ================================================
//=============================================================================================================================

// ============================================	GLOBALS	========================================================

global boolean e8m4_narrative_is_on = FALSE;

// ============================================	PUP SCRIPT	========================================================



// ============================================	VO SCRIPT	========================================================



// ============================================	MISC SCRIPT	========================================================


script static void vo_e8m4_narrative_in()
e8m4_narrative_is_on = TRUE;

//dprint("Play_mus_pve_e08m4_start");
//music_start('Play_mus_pve_e08m4_start');

//dprint("Play_mus_pve_e08m4_narr_in");
//music_set_state('Play_mus_pve_e08m4_narr_in');

// Palmer : Alright, Crimson, a captured Elite offered up the crystal ball they've been using to track us, and it's in there somewhere.
sleep_s(2);
dprint ("Palmer: Alright, Crimson, a captured Elite offered up the crystal ball they've been using to track us, and it's in there somewhere.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_pelican_approach_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_pelican_approach_00100'));

end_radio_transmission();
e8m4_narrative_is_on = FALSE;

end

script static void vo_e8m4_onto_platform()
e8m4_narrative_is_on = TRUE;

// Palmer : Secure the area.
dprint ("Palmer: Secure the area.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_onto_platform_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_onto_platform_00100'));


end_radio_transmission();
e8m4_narrative_is_on = FALSE;
end

script static void vo_e8m4_movement_structure()
e8m4_narrative_is_on = TRUE;

// Miller : Movement from the structure! More bad guys inbound, Spartans.
dprint ("Miller: Movement from the structure! More bad guys inbound, Spartans.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_reinforcements_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_reinforcements_00100'));


end_radio_transmission();
e8m4_narrative_is_on = FALSE;
end

script static void vo_e8m4_once_cleared()
e8m4_narrative_is_on = TRUE;

// Miller : Area's clear, Commander.
dprint ("Miller: Area's clear, Commander.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_once_cleared_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_once_cleared_00100'));
sleep(20);

	// Palmer : Textbook example of kicking ass. Well done, Crimson.
	dprint ("Palmer: Textbook example of kicking ass. Well done, Crimson.");
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_10_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_10_00100'));
/*
// Palmer : Crimson, lets roll
dprint ("Palmer: Crimson, lets roll");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_once_cleared_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_once_cleared_00101'));
end_radio_transmission();
*/

sleep(10);
// Miller : tagging door for you now.
dprint ("Miller: tagging door for you now.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ( 'sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_miller_show_button_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_miller_show_button_00100'));
end_radio_transmission();
e8m4_narrative_is_on = FALSE;

end

script static void vo_e8m4_give_waypoint()
e8m4_narrative_is_on = TRUE;


/*// Miller : However it is the Covies are listening in on our comm traffic, it’s sourced to that structure.
dprint ("Miller: However it is the Covies are listening in on our comm traffic, it’s sourced to that structure.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_give_waypoint_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_give_waypoint_00100'));
sleep(10);*/


// Palmer : Get in there, Crimson. Anything bigger than a breadbox gets the once over.
dprint ("Palmer: Get in there, Crimson. Anything bigger than a breadbox gets the once over.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_give_waypoint_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_give_waypoint_00101'));

end_radio_transmission();
e8m4_narrative_is_on = FALSE;
end

script static void vo_e8m4_prison_area()
e8m4_narrative_is_on = TRUE;

//dprint("Play_mus_pve_e08m4_prison_area");
//music_set_state('Play_mus_pve_e08m4_prison_area');


// Miller : Commander, getting some interference around Crimson's uplink. Could explain why drones have been unreliable in that location.
dprint ("Miller: Commander, getting some interference around Crimson's uplink. Could explain why drones have been unreliable in that location.");
//start_radio_transmission("miller_transmission_name");
hud_play_pip_from_tag( "levels\dlc\shared\binks\sp_g03_60" );
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_prison_area_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_prison_area_00100'));
sleep(10);

// Palmer : So add jammers to the list of things we might be looking for.
dprint ("Palmer: So add jammers to the list of things we might be looking for.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_prison_area_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_prison_area_00101'));


end_radio_transmission();
e8m4_narrative_is_on = FALSE;
end

script static void vo_e8m4_jammers_destroy()
//dprint("Play_mus_pve_e08m4_jammers_destroy");
//music_set_state('Play_mus_pve_e08m4_jammers_destroy');
e8m4_narrative_is_on = TRUE;

/// Miller : There we go. I've got three energy signatures matching known Covenant signal jammers.
dprint ("Miller: There we go. I've got three energy signatures matching known Covenant signal jammers.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_jammers_destroy_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_jammers_destroy_00100'));
/*sleep(10);

// Palmer : Good work, Miller. Mark 'em for Crimson.
dprint ("Palmer: Good work, Miller. Mark 'em for Crimson.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_jammers_destroy_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_jammers_destroy_00101'));*/

end_radio_transmission();
e8m4_narrative_is_on = FALSE;
end

script static void vo_e8m4_jammers_destroy_02()
e8m4_narrative_is_on = TRUE;


	start_radio_transmission("miller_transmission_name");
	// Miller : That did it!
	dprint ("Miller: That did it!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_7_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_7_00100'));
	sleep(24);
		
	end_radio_transmission();
	e8m4_narrative_is_on = FALSE;
end

script static void vo_e8m4_jammers_destroy_03()
	e8m4_narrative_is_on = TRUE;
	
	start_radio_transmission("miller_transmission_name");

	// Miller : UNSC transponder, in the chamber adjacent to Crimson's position. Marking it now.
	dprint ("Miller: UNSC transponder, in the chamber adjacent to Crimson's position. Marking it now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_jammers_destroy_00104', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_jammers_destroy_00104'));
	
	end_radio_transmission();
	e8m4_narrative_is_on = FALSE;
end


script static void vo_e8m4_covenant_intelligence()
e8m4_narrative_is_on = TRUE;

//dprint("Play_mus_pve_e08m4_covenant_intelligence");
//music_set_state('Play_mus_pve_e08m4_covenant_intelligence');

// Palmer : The hell? The Covies have one of our birds?
dprint ("Palmer: The hell? The Covies have one of our birds?");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_covenant_intelligence_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_covenant_intelligence_00100'));
sleep(10);

// Miller : It’s an Army ride. Shot down near Cauldron Base, assumed destroyed.
dprint ("Miller: It’s an Army ride. Shot down near Cauldron Base, assumed destroyed.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_covenant_intelligence_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_covenant_intelligence_00101'));
sleep(10);

// Palmer : Assumed wrong.
dprint ("Palmer: Assumed wrong.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_covenant_intelligence_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_covenant_intelligence_00102'));
sleep(10);
/*
// Miller : Those energy tethers are tied into the Pelican's comm systems. Break them.
dprint ("Miller: Those energy tethers are tied into the Pelican's comm systems. Break them.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_covenant_intelligence_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_covenant_intelligence_00103'));
*/
end_radio_transmission();
e8m4_narrative_is_on = FALSE;
end

script static void vo_e8m4_covenant_intelligence_2()
	e8m4_narrative_is_on = TRUE;
	
	//dprint("Play_mus_pve_e08m4_covenant_intelligence");
	//music_set_state('Play_mus_pve_e08m4_covenant_intelligence');
	/*
	// Palmer : The hell? The Covies have one of our birds?
	dprint ("Palmer: The hell? The Covies have one of our birds?");
	start_radio_transmission("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_covenant_intelligence_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_covenant_intelligence_00100'));
	sleep(10);
	
	// Miller : It’s an Army ride. Shot down near Cauldron Base, assumed destroyed.
	dprint ("Miller: It’s an Army ride. Shot down near Cauldron Base, assumed destroyed.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_covenant_intelligence_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_covenant_intelligence_00101'));
	sleep(10);
	
	// Palmer : Assumed wrong.
	dprint ("Palmer: Assumed wrong.");
	cui_hud_show_radio_transmission_hud("palmer_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_covenant_intelligence_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_covenant_intelligence_00102'));
	sleep(10);
	*/
	
	// Miller : Those energy tethers are tied into the Pelican's comm systems. Break them.
	dprint ("Miller: Those energy tethers are tied into the Pelican's comm systems. Break them.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_covenant_intelligence_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_covenant_intelligence_00103'));
	
	end_radio_transmission();
	e8m4_narrative_is_on = FALSE;
end


script static void vo_e8m4_clear_area()
e8m4_narrative_is_on = TRUE;

// Palmer : Nobody left standing, got it Crimson?
dprint ("Palmer: Nobody left standing, got it Crimson?");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_clear_area_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_clear_area_00100'));

end_radio_transmission();
e8m4_narrative_is_on = FALSE;
end

script static void vo_e8m4_clear_area_02()
	e8m4_narrative_is_on = TRUE;
	
	//dprint("Play_mus_pve_e08m4_clear_area_02");
	//music_set_state('Play_mus_pve_e08m4_clear_area_02');
	/*
	// Miller : Area's clear.
	dprint ("Miller: Area's clear.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_clear_area_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_clear_area_00101'));
	sleep(10);
	*/
	
	// Miller : Dalton, Crimson needs a ride, and I could use some explosives to erase a problem.
	dprint ("Miller: Dalton, Crimson needs a ride, and I could use some explosives to erase a problem.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_clear_area_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_clear_area_00102'));
	sleep(10);
	
	// Dalton : Happy to oblige on both counts. Inbound on Crimson’s position now.
	dprint ("Dalton: Happy to oblige on both counts. Inbound on Crimson’s position now.");
	cui_hud_show_radio_transmission_hud("dalton_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_clear_area_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_clear_area_00103'));


	if(ai_living_count (gr_e8_m4_ff_all) >= 1)then
		// Palmer : Just a minute more, Dalton. Crimson's on the job.
		dprint ("Palmer: Just a minute more, Dalton. Crimson's on the job.");
		cui_hud_show_radio_transmission_hud("palmer_transmission_name");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_lz_hot_5_00200', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_lz_hot_5_00200'));
	end

	end_radio_transmission();
	e8m4_narrative_is_on = FALSE;

end

script static void vo_e8m4_board_pelican()
e8m4_narrative_is_on = TRUE;

// Dalton : Phantom's in position.
dprint ("Dalton: Phantom's in position.");
start_radio_transmission("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_board_pelican_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_board_pelican_00100'));
sleep(10);

// Miller : See it. Spartans, ready yourselves.
dprint ("Miller: See it. Spartans, ready yourselves.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_board_pelican_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_board_pelican_00101'));

end_radio_transmission();
e8m4_narrative_is_on = FALSE;

end

script static void vo_e8m4_board_pelican_02()
e8m4_narrative_is_on = TRUE;

// Miller : Dalton, ground’s clear and Crimson’s ready for evac.
dprint ("Miller: Dalton, ground’s clear and Crimson’s ready for evac.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_board_pelican_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_board_pelican_00102'));
sleep(10);

// Dalton : Roger that, Miller.
dprint ("Dalton: Roger that, Miller.");
cui_hud_show_radio_transmission_hud("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_board_pelican_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_board_pelican_00103'));


end_radio_transmission();
e8m4_narrative_is_on = FALSE;
end

script static void vo_e8m4_board_dusts_off()
e8m4_narrative_is_on = TRUE;

//dprint("Play_mus_pve_e08m4_dusts_off");
//music_set_state('Play_mus_pve_e08m4_dusts_off');

// Miller : Spartans are clear.
dprint ("Miller: Spartans are clear.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_dusts_off_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_dusts_off_00100'));
sleep(10);

// Dalton : Explosives deployed.
dprint ("Dalton: Explosives deployed.");
cui_hud_show_radio_transmission_hud("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_dusts_off_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_dusts_off_00101'));
sleep(10);

// Palmer : Thanks, Dalton. It’ll be nice to have the element of surprise again.
dprint ("Palmer: Thanks, Dalton. It’ll be nice to have the element of surprise again.");
cui_hud_show_radio_transmission_hud("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_dusts_off_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_dusts_off_00102'));

end_radio_transmission();
e8m4_narrative_is_on = FALSE;

end

script static void fx_e8m4_pelican_shoot_grunt1(object grunt)
	// pel_e8_m4_in is the storm_pelican_for_vignettes instance
	dprint("Pelican firing at grunts");
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, primary_trigger);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, primary_trigger, grunt, body);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, turret);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, turret, grunt, body);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, primary_trigger);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, primary_trigger, grunt, body);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, turret);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, turret, grunt, body);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, primary_trigger);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, primary_trigger, grunt, body);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, turret);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, turret, grunt, body);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, primary_trigger);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, primary_trigger, grunt, body);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, turret);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, turret, grunt, body);
	effect_new(levels\firefight\dlc01_factory\fx\grunt_bullet_impact.effect, gruntblood_01);
	effect_new(fx\material_effects\weapons\impact_bullet_medium\soft_organic_flesh_grunt.effect, gruntblood_01);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, primary_trigger);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, primary_trigger, grunt, body);
	effect_new(levels\firefight\dlc01_factory\fx\grunt_bullet_impact.effect, gruntblood_02);
	effect_new(fx\material_effects\weapons\impact_bullet_medium\soft_organic_flesh_grunt.effect, gruntblood_02);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, turret);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, turret, grunt, body);
	effect_new(levels\firefight\dlc01_factory\fx\grunt_bullet_impact.effect, gruntblood_03);
	effect_new(fx\material_effects\weapons\impact_bullet_medium\soft_organic_flesh_grunt.effect, gruntblood_03);
	sleep(2);
		

end


script static void fx_e8m4_pelican_shoot_grunt2(object grunt)
	// pel_e8_m4_in is the storm_pelican_for_vignettes instance
	dprint("Pelican firing at grunts");
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, primary_trigger);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, primary_trigger, grunt, body);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, turret);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, turret, grunt, body);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, primary_trigger);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, primary_trigger, grunt, body);
	effect_new(levels\firefight\dlc01_factory\fx\grunt_bullet_impact.effect, gruntblood_04);
	effect_new(fx\material_effects\weapons\impact_bullet_medium\soft_organic_flesh_grunt.effect, gruntblood_04);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, turret);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, turret, grunt, body);
	effect_new(levels\firefight\dlc01_factory\fx\grunt_bullet_impact.effect, gruntblood_05);
	effect_new(fx\material_effects\weapons\impact_bullet_medium\soft_organic_flesh_grunt.effect, gruntblood_05);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, primary_trigger);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, primary_trigger, grunt, body);
	effect_new(levels\firefight\dlc01_factory\fx\grunt_bullet_impact.effect, gruntblood_06);
	effect_new(fx\material_effects\weapons\impact_bullet_medium\soft_organic_flesh_grunt.effect, gruntblood_06);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, turret);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, turret, grunt, body);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, primary_trigger);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, primary_trigger, grunt, body);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, turret);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, turret, grunt, body);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, primary_trigger);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, primary_trigger, grunt, body);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, turret);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, turret, grunt, body);
	sleep(2);
		

end


script static void fx_e8m4_pelican_shoot_grunt3(object grunt)
	// pel_e8_m4_in is the storm_pelican_for_vignettes instance
	dprint("Pelican firing at grunts");
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, turret);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, turret, grunt, body);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, primary_trigger);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, primary_trigger, grunt, body);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, turret);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, turret, grunt, body);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, primary_trigger);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, primary_trigger, grunt, body);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, turret);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, turret, grunt, body);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, primary_trigger);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, primary_trigger, grunt, body);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, turret);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, turret, grunt, body);
	effect_new(levels\firefight\dlc01_factory\fx\grunt_bullet_impact.effect, gruntblood_07);
	effect_new(fx\material_effects\weapons\impact_bullet_medium\soft_organic_flesh_grunt.effect, gruntblood_07);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, primary_trigger);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, primary_trigger, grunt, body);
	effect_new(levels\firefight\dlc01_factory\fx\grunt_bullet_impact.effect, gruntblood_08);
	effect_new(fx\material_effects\weapons\impact_bullet_medium\soft_organic_flesh_grunt.effect, gruntblood_08);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, turret);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, turret, grunt, body);
	effect_new(levels\firefight\dlc01_factory\fx\grunt_bullet_impact.effect, gruntblood_09);
	effect_new(fx\material_effects\weapons\impact_bullet_medium\soft_organic_flesh_grunt.effect, gruntblood_09);
	sleep(2);
	
	effect_new_on_object_marker(levels\dlc\shared\fx\storm_pelican\firing.effect, pel_e8_m4_in, primary_trigger);
	effect_new_between_object_markers(levels\dlc\shared\fx\storm_pelican\turret_tracer.effect, pel_e8_m4_in, primary_trigger, grunt, body);
	sleep(2);

end


script static void e8m4_vo_packagedelivery()					//crystal ball

	sleep_until(e8m4_narrative_is_on == FALSE, 1);
	vo_e8m4_narrative_in();
	print("e8m4_vo_packagedelivery played");
	end
	
	

	
	///====================to pull from other files for jammers and switchs
//e7_m4

script static void vo_e8m4_1morejammer()

e8m4_narrative_is_on = TRUE;

// Miller : One more to go!  Great work.
dprint ("Miller: One more to go!  Great work.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00500', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00500'));
sleep(10);
e8m4_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e8m4_lastswitch()

e8m4_narrative_is_on = TRUE;

dprint ("Miller: That's it!  Last one!");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00600', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00600'));

e8m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e8m4_1stjammer()

e8m4_narrative_is_on = TRUE;

// Miller : One down.  Two to go.
dprint ("Miller: One down.  Two to go.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_1stoverride_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_1stoverride_00100'));

e8m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e8m4_2ndswitch()

e8m4_narrative_is_on = TRUE;

// Miller : That's two!
dprint ("Miller: That's two!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_2ndoverride_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_2ndoverride_00100'));

e8m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e8m4_onemoreswitch()


e8m4_narrative_is_on = TRUE;

dprint ("Roland: One to go!");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_2ndoverride_00200', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_2ndoverride_00200'));

e8m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e8m4_onarollswitchl()

e8m4_narrative_is_on = TRUE;

// Miller : You're on a roll, Crimson.  Keep it up.
dprint ("Miller: You're on a roll, Crimson.  Keep it up.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00300', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_lockprogress_00300'));

e8m4_narrative_is_on = FALSE;
end_radio_transmission();

end


script static void vo_e8m4_hunters()

e8m4_narrative_is_on = TRUE;

// Roland : Spartan!  Hunters have entered the area!
dprint ("Roland: Spartan!  Hunters have entered the area!");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_hunters_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_07_mission_04\e07m4_hunters_00100'));
e8m4_narrative_is_on = FALSE;
end_radio_transmission();

end

script static void vo_e8m4_show_button()
e8m4_narrative_is_on = TRUE;

// Miller : Tagging the door controls for you now.

dprint ("Miller: Tagging the door controls for you now.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_miller_show_button_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_08_mission_04\e08m4_miller_show_button_00100'));


end_radio_transmission();
e8m4_narrative_is_on = FALSE;
end