//=============================================================================================================================
//============================================ E6M1 FACTORY NARRATIVE SCRIPT ================================================
//=============================================================================================================================

// ============================================	GLOBALS	========================================================

global boolean e6m1_narrative_is_on = FALSE;

// ============================================	PUP SCRIPT	========================================================



// ============================================	VO SCRIPT	========================================================



// ============================================	MISC SCRIPT	========================================================


script static void vo_e6m1_narrative_in()
e6m1_narrative_is_on = TRUE;
//dprint("Play_mus_pve_e06m1_narr_in");
//music_set_state('Play_mus_pve_e06m1_narr_in');

// Roland : Spartan Miller, I found them!
dprint ("Roland: Spartan Miller, I found them!");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_forerunner_structure_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_forerunner_structure_00100'));
sleep(10);

// Miller : Dalton, we found Crimson. Distract the bad guys for a second?
dprint ("Miller: Dalton, we found Crimson. Distract the bad guys for a second?");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_forerunner_structure_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_forerunner_structure_00101'));
sleep(10);

// Dalton : You got it. Firing solution resolved. Incoming!
dprint ("Dalton: You got it. Firing solution resolved. Incoming!");
cui_hud_show_radio_transmission_hud("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_forerunner_structure_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_forerunner_structure_00104'));

end_radio_transmission();
e6m1_narrative_is_on = FALSE;
end



script static void vo_e6m1_elite_assassination()
e6m1_narrative_is_on = TRUE;

// Miller : Crimson, glad to have you back.
dprint ("Miller: Crimson, glad to have you back.");
start_radio_transmission("miller_transmission_name");
hud_play_pip_from_tag( "levels\dlc\shared\binks\ep6_m1_1_60" );
thread (pip_e6m1_assassination_subtitles());
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_elite_assassination_00101'));

end_radio_transmission();
e6m1_narrative_is_on = FALSE;
end


script static void pip_e6m1_assassination_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_elite_assassination_00101');
end


script static void vo_e6m1_prison_break()
e6m1_narrative_is_on = TRUE;
// Miller : Roland, have we got any intel on this place?
dprint ("Miller: Roland, have we got any intel on this place?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_prison_break_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_prison_break_00100'));
sleep(10);

// Roland : Not much, no.
dprint ("Roland: Not much, no.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_prison_break_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_prison_break_00101'));


end_radio_transmission();
e6m1_narrative_is_on = FALSE;
end

script static void vo_e6m1_more_kills()
e6m1_narrative_is_on = TRUE;
// Miller : Keep up the fight, Crimson. We'll have a plan for the shortly.
dprint ("Miller: Keep up the fight, Crimson. We'll have a plan for the shortly.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_more_kills_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_more_kills_00100'));

end_radio_transmission();
e6m1_narrative_is_on = FALSE;
end

script static void vo_e6m1_evac_zone()
e6m1_narrative_is_on = TRUE;
//dprint("Play_mus_pve_e06m1_have_a_plan");
//music_set_state('Play_mus_pve_e06m1_have_a_plan');

// Roland : Spartan Miller, there's a potential evac zone, but it's heavily shielded.
dprint ("Roland: Spartan Miller, there's a potential evac zone, but it's heavily shielded.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_evac_zone_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_evac_zone_00100'));
sleep(10);

// Miller : Heavily shielded isn't exactly an evac zone.
dprint ("Miller: Heavily shielded isn't exactly an evac zone.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_evac_zone_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_evac_zone_00101'));
sleep(10);

// Roland : I did say "potential" evac zone.
dprint ("Roland: I did say 'potential' evac zone.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_evac_zone_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_evac_zone_00102'));
sleep(10);

/*
// Miller : Actually, Crimson… I thikn Roland's onto something.
dprint ("Miller: Actually, Crimson… I thikn Roland's onto something.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_evac_zone_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_evac_zone_00103'));
*/

// Miller : Marking the shield generators for you.
dprint ("Miller: Marking the shield generators for you.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_evac_zone_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_evac_zone_00104'));
sleep(10);

// Miller : Take them down.
dprint ("Miller: Take them down.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_evac_zone_00105', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_evac_zone_00105'));

end_radio_transmission();
e6m1_narrative_is_on = FALSE;
end

script static void vo_e6m1_first_generator()
e6m1_narrative_is_on = TRUE;

// Miller : If you want out of there, Crimson, you need to deactivate the generators and drop that shield.
dprint ("Miller: If you want out of there, Crimson, you need to deactivate the generators and drop that shield.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_first_generator_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_first_generator_00100'));

end_radio_transmission();
e6m1_narrative_is_on = FALSE;
end

script static void vo_e6m1_first_generator_down()
	dprint ("deprecated");
end


script static void vo_e6m1_second_generator()
e6m1_narrative_is_on = TRUE;
// Miller : Crimson, you're not going anywhere until you bring that second generator down.
dprint ("Miller: Crimson, you're not going anywhere until you bring that second generator down.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_second_generator_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_second_generator_00100'));

end_radio_transmission();
e6m1_narrative_is_on = FALSE;
end

script static void vo_e6m1_shield_down()
	e6m1_narrative_is_on = TRUE;
  	
	// Roland : Success! Shield down!
	dprint("Roland: Success! Shield down!");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_shield_drop_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_shield_drop_00100'));
	sleep(10);

	// Miller : Dalton, Crison needs a ride.

	dprint ("Miller: Dalton, Crison needs a ride.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_shield_drop_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_shield_drop_00101'));
	sleep(10);
  			
	dprint ("Dalton: Can do.");
	cui_hud_show_radio_transmission_hud("dalton_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\glo_dalton_confirm_01', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_09_mission_02\glo_dalton_confirm_01'));
	sleep(10);
  	
	dprint ("Miller: Pack your bags and be ready to fly, Crimson.");
	end_radio_transmission();
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_shield_drop_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_shield_drop_00103'));
	
	end_radio_transmission();

	e6m1_narrative_is_on = FALSE;
end

script static void vo_e6m1_shield_drop_02()
	e6m1_narrative_is_on = TRUE;

	// Dalton : Miller, this is taking a little longer than expected. Crimson's too deep behind Covenant lines.
	dprint ("Dalton: Miller, this is taking a little longer than expected. Crimson's too deep behind Covenant lines.");
	start_radio_transmission("dalton_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_shield_drop_00104', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_shield_drop_00104'));
	sleep(10);
	/*
	// Miller : I need results, not excuses, Dalton.
	dprint ("Miller: I need results, not excuses, Dalton.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_shield_drop_00105', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_shield_drop_00105'));
	sleep(10);

	// Roland : You're starting to sound like Commander Palmer.
	dprint ("Roland: You're starting to sound like Commander Palmer.");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_shield_drop_00106', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_shield_drop_00106'));
	sleep(10);

	// Miller : I'll take that as a compliment. And Dalton, I'll also take a ride home for Crimson sooner rather than later.
	dprint ("Miller: I'll take that as a compliment. And Dalton, I'll also take a ride home for Crimson sooner rather than later.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_shield_drop_00107', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_shield_drop_00107'));
	*/

	end_radio_transmission();
	e6m1_narrative_is_on = FALSE;
end

script static void vo_e6m1_pelican_retreat()
e6m1_narrative_is_on = TRUE;

//dprint("Play_mus_pve_e06m1_pelican_retreat");
//music_set_state('Play_mus_pve_e06m1_pelican_retreat');

/*
// Dalton : I'm sorry, Miller. I'm pulling the Pelican back. Whole area's too hot.
dprint ("Dalton: I'm sorry, Miller. I'm pulling the Pelican back. Whole area's too hot.");
start_radio_transmission("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_pelican_retreat_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_pelican_retreat_00100'));
sleep(10);

// Dalton : Even if Crimson gets onboard, they aren't getting out alive.
dprint ("Dalton: Even if Crimson gets onboard, they aren't getting out alive.");
cui_hud_show_radio_transmission_hud("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_pelican_retreat_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_pelican_retreat_00101'));
sleep(10);
*/

// Miller : Crimson, apologies. We'll find you somehting.
dprint ("Miller: Crimson, apologies. We'll find you somehting.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_pelican_retreat_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_pelican_retreat_00102'));
/*sleep(10);

// Roland : I'm afraid Spartan Dalton is right. We're not getting anything in that area without suffering major losses.
dprint ("Roland: I'm afraid Spartan Dalton is right. We're not getting anything in that area without suffering major losses.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_pelican_retreat_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_pelican_retreat_00103'));
sleep(10);

// Miller : I dont care how, I want them out of there now.
dprint ("Miller: I dont care how, I want them out of there now.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_pelican_retreat_00104', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_pelican_retreat_00104'));
*/

end_radio_transmission();
e6m1_narrative_is_on = FALSE;
end

script static void vo_e6m1_go_there()
	e6m1_narrative_is_on = TRUE;

	// Miller : Crimson, there's several Covenant air craft parked in this area. Let's go see if anybody left the keys in the ignition.
	dprint ("Miller: Crimson, there's several Covenant air craft parked in this area. Let's go see if anybody left the keys in the ignition.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_go_there_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_go_there_00100'));
	sleep(10);

	// Roland : We're gonna steal a space ship? I like this idea!
	dprint ("Roland: We're gonna steal a space ship? I like this idea!");
	cui_hud_show_radio_transmission_hud("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_go_there_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_go_there_00101'));

	end_radio_transmission();
	e6m1_narrative_is_on = FALSE;
end

script static void vo_e6m1_clear_covenant()
	e6m1_narrative_is_on = TRUE;

	// Miller : Clear the area, Crimson. Roland, open Crimson a path.
	dprint ("Miller: Clear the area, Crimson. Roland, open Crimson a path.");
	start_radio_transmission("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_clear_covenant_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_clear_covenant_00100'));

	end_radio_transmission();
	e6m1_narrative_is_on = FALSE;
end

script static void vo_e6m1_open_gate()
	e6m1_narrative_is_on = TRUE;

	// Roland : Path's open.
	dprint ("Roland: Path's open.");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_open_gate_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_open_gate_00100'));
	sleep(10);

	// Miller : Perfect. Let's go, Crimson.
	dprint ("Miller: Perfect. Let's go, Crimson.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_open_gate_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_open_gate_00101'));

	end_radio_transmission();
	e6m1_narrative_is_on = FALSE;
end

script static void vo_e6m1_phantom_resistance()

dprint("deprecated");
//e6m1_narrative_is_on = TRUE;
//
//// Roland : Hey… I think maybe the Covenant are using this place as a prison center. Which is weird since they don't usually take prisoners.
//dprint ("Roland: Hey… I think maybe the Covenant are using this place as a prison center. Which is weird since they don't usually take prisoners.");
//cui_hud_show_radio_transmission_hud("roland_transmission_name");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_phantom_resistance_00102', NONE, 1);
//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_phantom_resistance_00102'));
//sleep(10);
//
//// Miller : What are they up to?
//dprint ("Miller: What are they up to?");
//cui_hud_show_radio_transmission_hud("miller_transmission_name");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_phantom_resistance_00103', NONE, 1);
//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_phantom_resistance_00103'));
//sleep(10);
//
///*
//// Roland : Getting shot in the face, mostly. Nice going down there, Crimson!
//dprint ("Roland: Getting shot in the face, mostly. Nice going down there, Crimson!");
//cui_hud_show_radio_transmission_hud("roland_transmission_name");
//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_phantom_resistance_00104', NONE, 1);
//sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_phantom_resistance_00104'));
//*/
//end_radio_transmission();
//e6m1_narrative_is_on = FALSE;
end

script static void vo_e6m1_phantom_resistance_01()
e6m1_narrative_is_on = TRUE;

//dprint("Play_mus_pve_e06m1_phantom_resistance");
//music_set_state('Play_mus_pve_e06m1_phantom_resistance');

// Dalton : Miller, Phantoms in the sky near Crimson's position.
dprint ("Dalton: Miller, Phantoms in the sky near Crimson's position.");
start_radio_transmission("dalton_transmission_name");
hud_play_pip_from_tag("levels\dlc\shared\binks\sp_g04_60"); // PiP SP_G04

sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_phantom_resistance_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_phantom_resistance_00100'));
sleep(10);

// Miller : Acknowledged, Dalton.
dprint ("Miller: Acknowledged, Dalton.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_phantom_resistance_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_phantom_resistance_00101'));
sleep(10);

end_radio_transmission();
e6m1_narrative_is_on = FALSE;
end

script static void vo_e6m1_phantom_resistance_02()
e6m1_narrative_is_on = TRUE;

// Roland : Oh! Hey! Icebreaker Squad's IFF tags just popped up.
dprint ("Roland: Oh! Hey! Icebreaker Squad's IFF tags just popped up.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_phantom_resistance_00106', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_phantom_resistance_00106'));
sleep(10);

// Miller : Icebreaker? They're listed MIA. Crimson, dodge the Phantoms and investigate.
dprint ("Miller: Icebreaker? They're listed MIA. Crimson, dodge the Phantoms and investigate.");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_phantom_resistance_00107', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_phantom_resistance_00107'));
sleep(10);

// Miller : If there's UNSC down there, I want them rescued.
dprint ("Miller: If there's UNSC down there, I want them rescued.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_phantom_resistance_00108', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_phantom_resistance_00108'));
end_radio_transmission();
e6m1_narrative_is_on = FALSE;
end

script static void vo_e6m1_phantom_resistance_03()
	e6m1_narrative_is_on = TRUE;

	//dprint("Play_mus_pve_e06m1_phantom_resistance_03");
	//music_set_state('Play_mus_pve_e06m1_phantom_resistance_03');
	
	// Roland : Spartan Miller, I found them!
	dprint ("Roland: Spartan Miller, I found them!");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_forerunner_structure_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_forerunner_structure_00100'));
	sleep(10);

	// Murphy : Spartans! Oh, man, fantastic!
	dprint ("Murphy: Spartans! Oh, man, fantastic!");
	cui_hud_show_radio_transmission_hud("murphy_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_find_marines_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_find_marines_00100'));
	sleep(10);

	// Miller : They're trapped behind a shield wall. Roland?
	dprint ("Miller: They're trapped behind a shield wall. Roland?");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_find_marines_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_find_marines_00101'));
	sleep(10);

	//Roland: working on it.
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_stillup_00101', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_10_mission_01\e10m1_stillup_00101'));
	sleep(10);

	end_radio_transmission();
	e6m1_narrative_is_on = FALSE;
end

script static void vo_e6m1_phantom_resistance_03b()
	e6m1_narrative_is_on = TRUE;

//	//Roland : done
//	dprint ("Roland: done.");
//	start_radio_transmission("miller_transmission_name");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_done_02', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_done_02'));
//	sleep(10);

	// Roland : Manual release right over there.
	dprint ("Roland: Manual release right over there.");
	start_radio_transmission("roland_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_find_marines_00102', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_find_marines_00102'));
	sleep_s(1);
	
	b_end_player_goal = TRUE;
	
	// Miller : Do it, Crimson.
	dprint ("Miller: Do it, Crimson.");
	cui_hud_show_radio_transmission_hud("miller_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_find_marines_00103', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_find_marines_00103'));

	end_radio_transmission();
	e6m1_narrative_is_on = FALSE;
end

script static void vo_e6m1_shield_disabled()
e6m1_narrative_is_on = TRUE;

// Roland : Sheld down!
dprint ("Roland: Sheld down!");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_shield_disabled_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_shield_disabled_00100'));

end_radio_transmission();
e6m1_narrative_is_on = FALSE;
end


script static void vo_e6m1_free_marines()
e6m1_narrative_is_on = TRUE;

//dprint("Play_mus_pve_e06m1_free_marines");
//music_set_state('Play_mus_pve_e06m1_free_marines');

// Murphy : Hell yes! I thought they were dead. Lieutenant TJ Murphy at your service.
dprint ("Murphy: Hell yes! I thought they were dead. Lieutenant TJ Murphy at your service.");
start_radio_transmission("murphy_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_free_marines_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_free_marines_00100'));
sleep(10);

// Murphy : Get some weapons, Marines! Time for payback!
dprint ("Murphy: Get some weapons, Marines! Time for payback!");
cui_hud_show_radio_transmission_hud("murphy_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_free_marines_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_free_marines_00101'));


end_radio_transmission();
e6m1_narrative_is_on = FALSE;
end

script static void vo_e6m1_take_off()
e6m1_narrative_is_on = TRUE;

//dprint("Play_mus_pve_e06m1_take_off");
//music_set_state('Play_mus_pve_e06m1_take_off');

// Roland : Spartan Miller, I think your plan's gonna work.
dprint ("Roland: Spartan Miller, I think your plan's gonna work.");
start_radio_transmission("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_take_off_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_take_off_00100'));
sleep(10);

// Roland : There's a Phantom nearby that should suit Crimson's needs if they can find a way to override its security systems.
dprint ("Roland: There's a Phantom nearby that should suit Crimson's needs if they can find a way to override its security systems.");
cui_hud_show_radio_transmission_hud("roland_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_take_off_00101', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_take_off_00101'));
sleep(10);

// Murphy : Hell, Infinity, hotwiring a Covenant space boat isn't exactly difficult.
dprint ("Murphy: Hell, Infinity, hotwiring a Covenant space boat isn't exactly difficult.");
cui_hud_show_radio_transmission_hud("murphy_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_take_off_00102', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_take_off_00102'));

end_radio_transmission();
e6m1_narrative_is_on = FALSE;
end

script static void vo_e6m1_fend_off()
e6m1_narrative_is_on = TRUE;

// Murphy : If Crimson gives me some cover, I'll get us airborne.
dprint ("Murphy: If Crimson gives me some cover, I'll get us airborne.");
cui_hud_show_radio_transmission_hud("murphy_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_take_off_00103', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_take_off_00103'));
sleep(10);

// Miller : Crimson, buy Lt. Murphy the time he needs.
dprint ("Miller: Crimson, buy Lt. Murphy the time he needs.");
start_radio_transmission("miller_transmission_name");
cui_hud_show_radio_transmission_hud("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_fend_off_00100', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_fend_off_00100'));


end_radio_transmission();
e6m1_narrative_is_on = FALSE;
end


script static void vo_e6m1_ready_take()
	e6m1_narrative_is_on = TRUE;
	
	// Murphy : Phantom's free and ready to fly!
	dprint ("Murphy: Phantom's free and ready to fly!");
	//start_radio_transmission("murphy_transmission_name");
	cui_hud_show_radio_transmission_hud("murphy_transmission_name");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_ready_take_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_ready_take_00100'));
	sleep(10);

//	// Miller : Well done, Lieutenant. Crimson, board up and get out of there!
//	dprint ("Miller: Well done, Lieutenant. Crimson, board up and get out of there!");
//	cui_hud_show_radio_transmission_hud("miller_transmission_name");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_ready_take_00101', NONE, 1);
//	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_ready_take_00101'));
//	sleep(10);

	end_radio_transmission();
	e6m1_narrative_is_on = FALSE;
end

script static void vo_e6m1_narr_out()
	e6m1_narrative_is_on = TRUE;

	//dprint("Play_mus_pve_e06m1_narr_out");
	//music_set_state('Play_mus_pve_e06m1_narr_out');

	// Miller : Good to have you in one piece, Crimson. See you when you get home.
	dprint ("Miller: Good to have you in one piece, Crimson. See you when you get home.");
	start_radio_transmission("miller_transmission_name");
	hud_play_pip_from_tag( "levels\dlc\shared\binks\ep6_m1_2_60" );
	thread (pip_e6m1_narrout_subtitles());
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_jump_onboard_00100'));
	sleep(10);

	end_radio_transmission();
	e6m1_narrative_is_on = FALSE;
end


script static void pip_e6m1_narrout_subtitles()
dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_06_mission_01\e06m1_jump_onboard_00100');
end
