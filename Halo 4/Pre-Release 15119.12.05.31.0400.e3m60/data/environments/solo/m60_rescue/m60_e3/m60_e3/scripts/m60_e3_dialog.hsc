
// dialog ID variables
global long 	L_dlg_infinity_start				= DEF_DIALOG_ID_NONE();
global long 	L_dlg_cortana_covenant				= DEF_DIALOG_ID_NONE();
global long 	L_dlg_covenant_scouts 				= DEF_DIALOG_ID_NONE();
global long 	L_dlg_after_derez 				= DEF_DIALOG_ID_NONE();
global long 	L_dlg_crawler_intro 				= DEF_DIALOG_ID_NONE();
global long 	L_dlg_crawler_end 				= DEF_DIALOG_ID_NONE();
global long 	L_dlg_sound_story_1 				= DEF_DIALOG_ID_NONE();
global long 	L_dlg_cortana_contact 				= DEF_DIALOG_ID_NONE();
global long 	L_dlg_knight_intro_post_kick 				= DEF_DIALOG_ID_NONE();
global long 	L_dlg_knight_intro_bishop 				= DEF_DIALOG_ID_NONE();
global long 	L_dlg_forerunner_rifle 				= DEF_DIALOG_ID_NONE();
global long 	L_dlg_sound_story_2 				= DEF_DIALOG_ID_NONE();
global long 	L_dlg_sound_story_3 				= DEF_DIALOG_ID_NONE();
global long 	L_dlg_watcher_chase 				= DEF_DIALOG_ID_NONE();
global long 	L_dlg_post_ranger_fight 				= DEF_DIALOG_ID_NONE();
global long 	L_dlg_battlewagon_jump_attack 				= DEF_DIALOG_ID_NONE();
global long 	L_dlg_infinity_callback				= DEF_DIALOG_ID_NONE();
global long 	L_dlg_overwhelm 				= DEF_DIALOG_ID_NONE();




// === f_dialog_elevator_ics_pry
script dormant f_dialog_infinity_start()
		
		Hud_play_pip_from_tag("bink\pip_e3_cortana_60"); 
		print ("play bink");
		sleep (67);

		print ("play Cortana Line 1");
		sound_impulse_start ('sound\dialog\mission\e3_demo\e3_v2_00100', NONE, 1);	
		sleep (131);

		print ("play Chief Line");
		sound_impulse_start ('sound\dialog\mission\e3_demo\e3_demo_00101', NONE, 1);	
		sleep (41);
		
		wake (f_objective_blip);
		cui_hud_set_new_objective (chtitlee3obj);
		
		sleep (4);		
		print ("play Cortana Line 2");
		sound_impulse_start ('sound\dialog\mission\e3_demo\e3_demo_00102', NONE, 1);	
		sleep (93);
	
		sleep (30 * 1);
		Hud_play_pip_from_tag(""); 

end

// === f_dialog_elevator_ics_pry
script dormant f_dialog_cortana_what_was_that()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "What was That", l_dialog_id, not dialog_foreground_id_active_check(L_dlg_cortana_covenant), DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\e3_demo\e3_demo_00136ab', FALSE, NONE, 0.0, "", "Cortana: What was that?" );	
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

// === f_dialog_elevator_ics_pry
script dormant f_dialog_cortana_covenant()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "Covenant Cortana", l_dialog_id, not dialog_foreground_id_active_check(L_dlg_cortana_covenant), DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\e3_demo\e3_v2_00106', FALSE, NONE, 0.0, "", "I don't think we're the only ones in here.  Keep your eyes open." );
		//dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\e3_demo\e3_demo_00106', FALSE, NONE, 0.0, "", "MASTER CHIEF: That doesn't make sense" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


// === f_dialog_elevator_ics_pry
script dormant f_dialog_covenant_scouts()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "Covenant Scouts", l_dialog_id, not dialog_foreground_id_active_check(L_dlg_covenant_scouts), DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\e3_demo\e3_demo_00109', FALSE, NONE, 0.0, "", "Cortana : Scouts! Hold up." );
		//dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\Mission\M10\m_m10_mc_0015', FALSE, NONE, 0.0, "", "MASTER CHIEF:  <sound of prying the door open>" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


// === f_dialog_elevator_ics_pry
script dormant f_dialog_after_derez()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	sleep (30 * 0.5);
	l_dialog_id = dialog_start_foreground( "After Derez", l_dialog_id, not dialog_foreground_id_active_check(L_dlg_after_derez), DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
		dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\e3_demo\e3_demo_00114', FALSE, NONE, 0.0, "", "MASTER CHIEF: What was that?" );
		 dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\e3_demo\e3_demo_00115', FALSE, NONE, 0.0, "", "Cortana: Unknown." );
		//dialog_line_radio  ( l_dialog_id, 2, TRUE, sound\dialog\mission\e3_demo\e3_demo_soundstory_00107, FALSE, NONE, 0.0, "", "Del Rio : All ground forces are ordered to return to Infinity immediately! //Possible insertions on multiple (dissolves to static).", TRUE );
		//dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\e3_demo\e3_v2_00120', FALSE, NONE, 0.0, "", "Cortana: They’re being overwhelmed – GO!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

	// HAX 4/30:sleep (30 * 1);
	// HAX 4/30:wake (f_infinity_derez_play);

end



script dormant f_dialog_sound_story_1()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	//l_dialog_id = dialog_start_foreground( "Sound Story", l_dialog_id, not dialog_foreground_id_active_check(L_dlg_sound_story_1), DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
	l_dialog_id = dialog_start_background( "INFINITY_COMP_INTERCOM", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );
		//dialog_line_radio  ( l_dialog_id, 0, TRUE, sound\dialog\mission\e3_demo\e3_demo_00200, FALSE, NONE, 0.0, "", "Del Rio : Infinity to Raptor Leader! What the hell is going on out there?!?", TRUE );
		//dialog_line_radio  ( l_dialog_id, 1, TRUE, sound\dialog\mission\e3_demo\e3_demo_00201, FALSE, NONE, 0.0, "", "Raptor Leader : Sir, ground forces cannot reach battle position! Encountering hostile elements across --", TRUE );
		//dialog_line_radio  ( l_dialog_id, 2, TRUE, sound\dialog\mission\e3_demo\e3_demo_00116, FALSE, NONE, 0.0, "", "Marine Voice : INCOMING!", TRUE );

	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end 

// === f_dialog_elevator_ics_pry
script dormant f_dialog_crawler_intro()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "Crawler Intro", l_dialog_id, not dialog_foreground_id_active_check(L_dlg_crawler_intro), DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
		sleep (30 * 1.1);
		dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\e3_demo\e3_demo_00120', FALSE, NONE, 0.0, "", "Master Chief : Hostiles?" );
		// HAX 4/30: sleep (30 * 1.5);
		// HAX 4/30: dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\e3_demo\e3_demo_00122', FALSE, NONE, 0.0, "", "Cortana : Whatever gave you THAT idea?" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


// === f_dialog_elevator_ics_pry
script dormant f_dialog_crawler_end()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "Crawler End", l_dialog_id, not dialog_foreground_id_active_check(L_dlg_crawler_end), DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
	//	dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\e3_demo\e3_demo_00123', FALSE, NONE, 0.0, "", "Master Chief : What are those things?" );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\e3_demo\e3_demo_00124', FALSE, NONE, 0.0, "", "Cortana: These things are some type of defense AI's. Definitely NOT Covenant - stay sharp!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

// === f_dialog_elevator_ics_pry
script dormant f_dialog_sound_story_2()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "Sound Story 2", l_dialog_id, not dialog_foreground_id_active_check(L_dlg_sound_story_2), DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
		dialog_line_radio (l_dialog_id, 0, TRUE, sound\dialog\mission\e3_demo\e3_demo_soundstory_00107, FALSE, NONE, 0.0, "", "Del Rio: All ground forces are ordered to return to Infinity immediately! Possible insertions on multiple (dissolves into static).", TRUE);
		//dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\e3_demo\e3_demo_00125', FALSE, NONE, 0.0, "", "Master Chief : If these things are attacking Infinity-" );
		//dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\e3_demo\e3_demo_00126', FALSE, NONE, 0.0, "", "Cortana : Contact!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_dialog_cortana_contact()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "Cortana yells Contact", l_dialog_id, not dialog_foreground_id_active_check(L_dlg_cortana_contact), DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\e3_demo\e3_demo_00126', FALSE, NONE, 0.0, "", "Cortana : Movement!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


// === f_dialog_elevator_ics_pry
script dormant f_dialog_knight_intro_bishop_appear()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "Knight Intro Bishop Appear", l_dialog_id, not dialog_foreground_id_active_check(L_dlg_knight_intro_bishop), DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
		
		//sleep (30 * 0.5);
		// HAX 4/30: dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\e3_demo\e3_demo_00127', FALSE, NONE, 0.0, "", "Cortana : Well he's just a ray of sunshine, isn't he?");
		// HAX 4/30: sleep (30 * 3.5);
		// HAX 4/30: dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\e3_demo\e3_demo_00129', FALSE, NONE, 0.0, "", "Cortana : Great. And he brought a friend." );
		sleep (1);
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


// === f_dialog_elevator_ics_pry
script dormant f_dialog_forerunner_rifle()
//local long l_dialog_id = DEF_DIALOG_ID_NONE();

//	l_dialog_id = dialog_start_foreground( "Forerunner Rifle", l_dialog_id, not dialog_foreground_id_active_check(L_dlg_forerunner_rifle), DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
		//dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\e3_demo\e3_demo_00133', FALSE, NONE, 0.0, "", "Cortana : I recognize this design. It’s Forerunner." );
		//sleep_until (b_bishop_chase_line == true);
	
	//	dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\e3_demo\e3_demo_00135', FALSE, NONE, 0.0, "", "Cortana : Chief! Don't let it get away!" );
		//dialog_line_npc (l_dialog_id, 0, TRUE, sound\dialog\mission\e3_demo\e3_demo_00134, FALSE, NONE, 0.0, "", "Recon 3-1-5 requesting assistance! We've got enemy QRF in the open! Please respond- (cuts off)", TRUE);
//	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );



	sleep (30 * 0.5);
	print ("Cortnana: I recognize this, it's forerunner");
	sound_impulse_start ('sound\dialog\mission\e3_demo\e3_demo_00133', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\mission\e3_demo\e3_demo_00133'));
	
	sleep (30 * 2);
	

	sleep_until (b_bishop_chase_line == true);
	
	print ("Cortana: Don't let it get away!");
	sound_impulse_start ('sound\dialog\mission\e3_demo\e3_demo_00135', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\mission\e3_demo\e3_demo_00135'));
	


end

// === f_dialog_elevator_ics_pry
script dormant f_dialog_sound_story_3()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "Sound Story 3", l_dialog_id, not dialog_foreground_id_active_check(L_dlg_sound_story_3), DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
		dialog_line_npc (l_dialog_id, 0, TRUE, sound\dialog\mission\e3_demo\e3_demo_00134, FALSE, NONE, 0.0, "", "Recon 3-1-5 requesting assistance! We've got enemy QRF in the open! Please respond- (cuts off)", TRUE);
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

// === f_dialog_elevator_ics_pry
script dormant f_dialog_watcher_chase()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "Watcher Chase", l_dialog_id, not dialog_foreground_id_active_check(L_dlg_watcher_chase), DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\e3_demo\e3_demo_00135', FALSE, NONE, 0.0, "", "Cortana : Chief! Don't let it get away!" );
	//dialog_line_npc (l_dialog_id, 0, TRUE, sound\dialog\mission\e3_demo\e3_demo_00136, FALSE, NONE, 0.0, "", "Recon 3-1-5 requesting assistance! We've got enemy QRF in the open! Please respond- (cuts off)", TRUE);
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


// === f_dialog_elevator_ics_pry
/*script dormant f_dialog_post_ranger_fight()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "Post Ranger Fight", l_dialog_id, not dialog_foreground_id_active_check(L_dlg_post_ranger_fight), DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, sound\dialog\mission\e3_demo\e3_demo_00200, FALSE, NONE, 0.0, "", "Cortana : The decompression put the room into lockdown.", TRUE );
		dialog_line_chief( l_dialog_id, 0, TRUE, sound\dialog\mission\e3_demo\e3_demo_00200, FALSE, NONE, 0.0, "", "MASTER CHIEF: 7 : <sound of prying the door open>", TRUE );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end*/



// === f_dialog_elevator_ics_pry
script dormant f_dialog_battlewagon_jump_attack()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "Battlewagon Jump Attack", l_dialog_id, not dialog_foreground_id_active_check(L_dlg_battlewagon_jump_attack), DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\e3_demo\e3_demo_00137', FALSE, NONE, 0.0, "", "Cortana : Look out!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


// === f_dialog_elevator_ics_pry
script dormant f_dialog_infinity_callback()


	// Del Rio : MAYDAY MAYDAY - CODE RED! Hostile elements attempting to gain entrance to the Infinity bridge!
//Hud_play_pip_from_tag("bink\PiP_E3_Del_Rio"); 
//dprint ("Del Rio: MAYDAY MAYDAY - CODE RED! Hostile elements attempting to gain entrance to the Infinity bridge!");
//sound_impulse_start ('sound\dialog\mission\e3_demo\e3_demo_soundstory_00104', NONE, 1);
sleep (sound_impulse_time('sound\dialog\mission\e3_demo\e3_demo_soundstory_00104'));
//Hud_play_pip_from_tag(""); 


// Master Chief : We need to move.
dprint ("Master Chief: We need to move.");
sound_impulse_start ('sound\dialog\mission\e3_demo\e3_demo_soundstory_00106', NONE, 1);
sleep (sound_impulse_time('sound\dialog\mission\e3_demo\e3_demo_soundstory_00106'));

end


// === f_dialog_elevator_ics_pry
script dormant f_dialog_overwhelm()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "Overwhelm", l_dialog_id, not dialog_foreground_id_active_check(L_dlg_overwhelm), DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
		//dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\e3_demo\e3_demo_00144', FALSE, NONE, 0.0, "", "MASTER CHIEF : You were worried about them being easy to spot?" );
		
		sleep (30 * 1);
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\e3_demo\e3_demo_00138', FALSE, NONE, 0.0, "", "Cortana: We're not alone. Switching visor mode." );
		//sleep (30 * 1);		
		//sleep_until (b_infinity_dialog == true);
		//dialog_line_radio  ( l_dialog_id, 2, TRUE, sound\dialog\mission\e3_demo\e3_v2_00175, FALSE, NONE, 0.0, "", "INFINITY COMM : All units! Infinity bridge has been breached!", TRUE );
		//dialog_line_radio  ( l_dialog_id, 2, TRUE, sound\dialog\mission\e3_demo\e3_v2_00176, FALSE, NONE, 0.0, "", "INFINITY BACKGROUND: Oh God - what are those things?", TRUE );
		//dialog_line_radio  ( l_dialog_id, 2, TRUE, sound\dialog\mission\e3_demo\e3_v2_00177, FALSE, NONE, 0.0, "", "INFINITY COMM:  -immediate assistance! All units please respond!", TRUE );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_infinity_dialog_over

	sleep_until (b_infinity_dialog == true);
	// Infinity BG : Oh God - what are those things?
	print ("Infinity BG: Oh God - what are those things?");
	sound_impulse_start ('sound\dialog\mission\e3_demo\e3_v2_00175', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\mission\e3_demo\e3_v2_00175'));

	// Infinity Comm : ...immediate assistance! All units please respond!
	print ("Infinity Comm: ...immediate assistance! All units please respond!");
	sound_impulse_start ('sound\dialog\mission\e3_demo\e3_v2_00176', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\mission\e3_demo\e3_v2_00176'));

	// Infinity BG : They're everywhere!
	print ("Infinity BG: They're everywhere!");
	sound_impulse_start ('sound\dialog\mission\e3_demo\e3_v2_00177', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\mission\e3_demo\e3_v2_00177'));

end

script dormant f_dialog_elite

	sleep_until (volume_test_players (tv_elite_bark), 1);
	// Elite : Argh Taki!
	print ("Elite: Argh Taki!");
	sound_impulse_start ('sound\dialog\mission\e3_demo\e3_demo_00108', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\mission\e3_demo\e3_demo_00108'));

end

script dormant f_dialog_elite_grunt_cortana

	// Elite : Wort wort wort!
	print ("Elite: Wort wort wort!");
	sound_impulse_start ('sound\dialog\mission\e3_demo\e3_demo_00110', sq_e3_elite.spawn_points_0, 1);
	sleep (sound_impulse_time('sound\dialog\mission\e3_demo\e3_demo_00110'));

	// Grunt 1 : Tami Demon!
	sleep (30 * 2.4);
	
	print ("Grunt 1: Tami Demon!");
	sound_impulse_start ('sound\dialog\mission\e3_demo\e3_demo_00111', sq_e3_covenant.spawn_points_2, 1);
	sleep (sound_impulse_time('sound\dialog\mission\e3_demo\e3_demo_00111'));


	// Cortana : They spotted us!
	print ("Cortana: They spotted us!");
	sound_impulse_start ('sound\dialog\mission\e3_demo\e3_demo_00113', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\mission\e3_demo\e3_demo_00113'));

end

script dormant f_dialog_cortana_visor

	sleep (30 * 2);
	// Cortana : We're not alone. Switching visor mode.
	print ("Cortana: We're not alone. Switching visor mode.");
	sound_impulse_start ('sound\dialog\mission\e3_demo\e3_demo_00138', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\mission\e3_demo\e3_demo_00138'));

end