
// =================================================================================================
// =================================================================================================
// NARRATIVE SCRIPTING M60 E3
// =================================================================================================
// =================================================================================================


// =================================================================================================
// *** GLOBALS ***

//	global boolean b_has_used_radio_once = FALSE;

	global short s_cortana_talk = 0;

// =================================================================================================

///////////////////////////////////////////////////////////////////////////////////
// MAIN
///////////////////////////////////////////////////////////////////////////////////

script startup M60_narrative_main()

print ("::: M60 E3 Narrative Start :::");

	wake (f_heard_knight);
	//wake (f_heard_covenant);
	//wake (f_infinity_callback);
	//wake (f_cortana_talk);
	wake (f_dialog_del_rio_pawn);

end

//34343434343434343434343434343434343434343434343434343434343434343434343434343

//////////////////////////////////NARRATIVE SCRIPTS////////////////////////////

//34343434343434343434343434343434343434343434343434343434343434343434343434343


script dormant cortana_infinity_comment()
	// fire this at level start
	
	//thread (story_blurb_add("domain", "CORTANA: If my scans are correct, that's the largest ship humans have ever constructed."));
	
	//wake (f_dialog_infinity_start);
	
	sleep_s (3);
	//Hud_play_pip("TEMP_PIP_CORTANA"); 
	
	//thread (story_blurb_add("domain", "CORTANA: The modulation in that sound doesn't match anything in my databanks, Chief."));
	
	//wake (f_dialog_cortana_pip);
	
	//sleep_s (9);
	//Hud_play_pip("");


end


script dormant f_heard_knight()

	
	// fired by trigger volume of same name
	sleep_until (volume_test_players(tv_heard_knight), 1);
	
	//thread (story_blurb_add("cutscene", "We hear a Knight off in the distance"));
	thread (f_audio_knight_in_distance());

	// rustling in the underbrush causes leaves to fall out
	//dprint("HEARD KNIGHT");
	effect_new(environments\solo\m60_rescue\fx\plant\fallingleaf_burst.effect, fx_00_knightheardleaves1);
	
	sleep (10);
	effect_new(environments\solo\m60_rescue\fx\plant\fallingleaf_burst.effect, fx_00_knightheardleaves2);
	
	sleep (20);
	wake (f_dialog_cortana_covenant);

	effect_new(environments\solo\m60_rescue\fx\plant\fallingleaf_burst.effect, fx_00_knightheardleaves3);

	sleep (20);
	effect_new(environments\solo\m60_rescue\fx\plant\fallingleaf_burst.effect, fx_00_knightheardleaves4);
	
	sleep (20);
	effect_new(environments\solo\m60_rescue\fx\plant\fallingleaf_burst.effect, fx_00_knightheardleaves5);
	
	sleep (20);
	effect_new(environments\solo\m60_rescue\fx\plant\fallingleaf_burst.effect, fx_00_knightheardleaves6);

	sleep_until (volume_test_players(tv_scout_vo), 1);
	wake (f_dialog_covenant_scouts);
	
end




script dormant f_heard_covenant()
	// fired by trigger volume of same name
	
	sleep_until (volume_test_players(tv_heard_covenant), 1);
	
	thread (f_audio_elite_giving_orders());
	sleep_s (2);
	
	sleep_until (volume_test_players(tv_scout_vo), 1);
	wake (f_dialog_covenant_scouts);
	
end


script dormant cortana_after_derez()
	// fires after Elite was de-rez'd by the hidden Knight
	
	wake (f_dialog_after_derez);
	
end



script dormant f_cortana_talk

	//s_cortana_talk = 1;

	//sleep_until (s_cortana_talk == 1);
	//sleep(30 * 1);
	//thread (story_blurb_add("domain", "CORTANA: Phantom patrol. [PLACEHOLDER]"));
	
	sleep_until (s_cortana_talk == 2);
	//thread (story_blurb_add("domain", "CORTANA: What was that? [PLACEHOLDER]"));
	wake (f_dialog_cortana_what_was_that);
	
	sleep_until (s_cortana_talk == 3);
	thread (story_blurb_add("domain", "CORTANA: There sure are a lot of them. [PLACEHOLDER]"));
		
	sleep_until (s_cortana_talk == 4);
	thread (story_blurb_add("domain", "CORTANA: They're running away? [PLACEHOLDER]"));
	
	sleep_until (s_cortana_talk == 5);
	sleep(30 * 2.0);
	thread (story_blurb_add("domain", "CORTANA: His weapon [PLACEHOLDER]"));

	sleep_until (s_cortana_talk == 6);
	sleep(30 * 2.0);
	thread (story_blurb_add("domain", "CORTANA: If it can do that whenever it likes, Infinity's in more trouble than I thought."));
	//JESSE AD VO HERE	
	//sleep_until (s_cortana_talk == 7);
	
	//thread (story_blurb_add("domain", "CORTANA: Chief! [PLACEHOLDER]"));
		
	sleep_until (s_cortana_talk == 8);

	
end

script dormant f_dialog_del_rio_pawn

	sleep_until (volume_test_players (tv_dialog_del_rio_pawn), 1);	

	// Del Rio : All ground forces are ordered to return to Infinity immediately! Possible insertions on multiple levels.
	print ("Del Rio: All ground forces are ordered to return to Infinity immediately! Possible insertions on multiple levels.");
	sound_impulse_start ('sound\dialog\mission\e3_demo\e3_demo_soundstory_00107', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\mission\e3_demo\e3_demo_soundstory_00107'));

end