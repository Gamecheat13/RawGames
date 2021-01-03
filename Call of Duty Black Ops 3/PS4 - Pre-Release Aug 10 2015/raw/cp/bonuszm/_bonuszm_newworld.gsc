#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#using scripts\cp\bonuszm\_bonuszm;
#using scripts\cp\bonuszm\_bonuszm_sound;
#using scripts\cp\_dialog;
#using scripts\cp\_util;

// NEWWORLD VOX
#using scripts\cp\voice\voice_z_newworld;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	

function autoexec Init()
{
	if( !( SessionModeIsCampaignZombiesGame() ) )
		return;
	
	mapname = GetDvarString( "mapname" );
	
	if( mapname != "cp_mi_zurich_newworld" )
		return;

	// Dialogue setup	
	voice_z_newworld::init_voice();	
		
	level.BZM_NEWWORLDDialogue1Callback	= &BZM_NEWWORLDDialogue1; // BONUSZM_NEWWORLD_DLG1
	level.BZM_NEWWORLDDialogue2Callback	= &BZM_NEWWORLDDialogue2; // BONUSZM_NEWWORLD_DLG2
	level.BZM_NEWWORLDDialogue3Callback	= &BZM_NEWWORLDDialogue3; // BONUSZM_NEWWORLD_DLG3
	level.BZM_NEWWORLDDialogue4Callback	= &BZM_NEWWORLDDialogue4; // BONUSZM_NEWWORLD_DLG4
	level.BZM_NEWWORLDDialogue5Callback	= &BZM_NEWWORLDDialogue5; // BONUSZM_NEWWORLD_DLG5
	level.BZM_NEWWORLDDialogue6Callback	= &BZM_NEWWORLDDialogue6; // BONUSZM_NEWWORLD_DLG6
	level.BZM_NEWWORLDDialogue7Callback	= &BZM_NEWWORLDDialogue7; // BONUSZM_NEWWORLD_DLG7
	level.BZM_NEWWORLDDialogue8Callback	= &BZM_NEWWORLDDialogue8; // BONUSZM_NEWWORLD_DLG8
	level.BZM_NEWWORLDDialogue9Callback	= &BZM_NEWWORLDDialogue9; // BONUSZM_NEWWORLD_DLG9
	level.BZM_NEWWORLDDialogue10Callback = &BZM_NEWWORLDDialogue10; // BONUSZM_NEWWORLD_DLG10
	level.BZM_NEWWORLDDialogue11Callback = &BZM_NEWWORLDDialogue11; // BONUSZM_NEWWORLD_DLG11
	level.BZM_NEWWORLDDialogue12Callback = &BZM_NEWWORLDDialogue12; // BONUSZM_NEWWORLD_DLG12

	// Add newworld specific logic in the following function
	BZM_newworldSettings();
}

function private BZM_newworldSettings()
{
	callback::on_spawned( &BZM_newworldOnPlayerSpawned );	
}

function BZM_newworldOnPlayerSpawned()
{
	self AllowDoubleJump( true );
}

function BZM_NEWWORLDDialogue1() // THE WHITE INFINITE
{
	wait 7;
	//Think back to 2065. You're on a train...
	bonuszmsound::BZM_PlayDrSalimVox( "salm_think_back_to_2065_0" );
		
	//You open your eyes, what do you see?...	
	bonuszmsound::BZM_PlayDrSalimVox( "salm_you_open_your_eyes_0" );
		
	//Snow... country... Switzerland. (recalling) We're on a train heading to Zurich.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_snow_country_s_0" );
	
	//What about Taylor?	
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_about_taylor_0" );
	
	//That's him. Commander John Taylor. The first Deadkiller.Calm. Cool. The definition of determination. We were rookies, fresh blood.  (beat) There weren't many of us. We had more rumors about our division than there were actual recruits.  (beat) They said we couldn't get bitten. We were immune to 61-15. We were manics, thirsty to maim the undead. Some of that was true. (beat) They compared us to Vikings. We were Beserkers -- we sought the slaughter. Relished it. I kinda liked the ring of that.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_that_s_him_commande_0" );
	
	//It was our first mission. Five years after the disaster. While most major cities had at least one containment zone, Zurich had managed to stay outbreak free. Someone wanted to change that.	
	bonuszmsound::BZM_PlayPlayerVox( "plyz_it_was_our_first_mis_0" );
	
	wait 1;
	//This... this is wrong.	
	bonuszmsound::BZM_PlayPlayerVox( "plyz_this_this_is_wron_0" );
	
	//This doesn't feel real. It feels... unnatural. How are you doing this?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_this_doesn_t_feel_re_0" );
	
	//I'm not doing anything. This is your mind, your memory. I am merely the passenger, not the pilot.  (beat) But tell me -- do you remember the train exploding?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_i_m_not_doing_anythi_0" );
	
	//NO! STOP, MAKE IT STOP!
	bonuszmsound::BZM_PlayPlayerVox( "plyz_no_stop_make_it_st_0" );
		
	//...Dr. Salim?? What happened? This is impossible, this can't be real.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_dr_salim_what_0" );
	
	wait 2;
	//It isn't, it's your memory. Your mind may dictate the truth, but it can play tricks on you. It can deceive you. Spread misinformation. Lie.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_it_isn_t_it_s_your_0" );
	
	//What do you mean, lie? The explosion, the train, this...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_what_do_you_mean_li_0" );
	
	wait 1;
	//This never happened, but it nearly did. You and Taylor stopped it.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_this_never_happened_0" );
	
	//Then what the hell am I seeing? If it's not real... how can I see something that never happened?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_then_what_the_hell_a_0" );
	
	//The human mind is fragile, it can be easily swayed by an incorrect recounting of events. This, for example, was one outcome of the event you feared.	
	bonuszmsound::BZM_PlayDrSalimVox( "salm_the_human_mind_is_fr_0" );
	
	wait 2;
	//So what do I do? How do I fix it?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_so_what_do_i_do_how_0" );
	
	wait 2;
	//Start from the beginning. Take me through the mission. Once we organize everything correctly, we'll be able to change your memory back to the truth. (beat) Tell me about the Raid...
	bonuszmsound::BZM_PlayDrSalimVox( "salm_start_from_the_begin_0" );	
}

function BZM_NEWWORLDDialogue2() // DIAZ INTRO
{
	wait 1;
	//The Raid... there was a Terrorist Group, they were planning something big. They knew we were coming.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_raid_there_wa_0" );
	
	wait 2;
	//Stop... Relax... Don't rush it.  (beat) Who was there with you?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_stop_relax_don_0" );	
	
	wait 1;
	//Taylor. He told us they'd received a tip about a 'Cotardist' Terrorist group. Undead-Sympathizers.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_taylor_he_told_us_t_0" );
	
	wait 2;
	//Undead-Sympathizers?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_undead_sympathizers_0" );
	
	wait 1;
	//Cotardists believe the Undead were the 'next step' in human evolution. To become Undead was to live. They believed the Dead should inherit the earth. Crazy right?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_cotardists_believe_t_0" );
	
	//Who's that with Taylor?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_who_s_that_with_tayl_0" );
	
	//That's Sebastian Diaz. Taylor's Second in Command.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_that_s_sebastian_dia_0" );
	
	//The man who would disable the Undead Defenses in Corvus?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_the_man_who_would_di_0" );
	
	//Yeah... but that was a long way off.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_yeah_but_that_was_0" );
		
	//Taylor told us Diaz would lead the raid on the robotics factory.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_taylor_told_us_diaz_0" );
		
	//They were so relaxed. The Dead threatened to take over Zurich... they were fearless.  (beat) Didn't take away our own fears.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_they_were_so_relaxed_0" );
	
	//Why not? Did you not say you were a Beserker? Seeker of the slaughter?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_why_not_did_you_not_0" );
	
	//No. Not yet. With the Undead outbreak at the factory our training had been cut short.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_no_not_yet_with_th_0" );
		
	//If we were gonna learn our shit, it would be on the job. This Mission was our Training.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_if_we_were_gonna_lea_0" );
	
	//Was Diaz worried?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_was_diaz_worried_0" );
	
	//About babysitting some kid? No... he didn't seem concerned.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_about_babysitting_so_0" );
	
	//For him it was just another day in the life. Business as usual. And business was boomin'.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_for_him_it_was_just_0" );	
}

function BZM_NEWWORLDDialogue3() // FACTORY RAID
{
	wait 5;
	
	//The Cotardists had abandoned the facility so quickly they left their primary console--
	//bonuszmsound::BZM_PlayPlayerVox( "plyz_the_cotardists_had_a_0" );								JOE WILL REMOVE IT FROM THE VO SCRIPT
		
	//Dr. Salim?? What's happening? I can't--
	bonuszmsound::BZM_PlayPlayerVox( "plyz_dr_salim_what_s_h_0" );
	
	//Stay with me. Come back to my voice.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_stay_with_me_come_b_0" );
		
	//I can't, I don't understand--
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_can_t_i_don_t_und_0" );
	
	//Can you hear me? Are you there?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_can_you_hear_me_are_1" );
	
	//Tell me what happened.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_tell_me_what_happene_0" );
	
	//I saw... I don't know. I saw robots, they were... they were ripping me apart.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_saw_i_don_t_kno_0" );
		
	//What's happening to me? What was I seeing?--
	bonuszmsound::BZM_PlayPlayerVox( "plyz_what_s_happening_to_0" );
	
	//It's a lapse. Your mind is wandering into the unknown, your subconscious is finding fears, dreams, doubts. Stay with me. Stay with my voice.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_it_s_a_lapse_your_m_0" );
		
	//You were saying: they left their console...
	bonuszmsound::BZM_PlayDrSalimVox( "salm_you_were_saying_the_0" );
	
	//We... I... Diaz told me to interface with the central server. We had to find out what the Terrorist Group was planning.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_i_diaz_told_0" );
	
	//Go to the console. Just like you did then.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_go_to_the_console_j_0" );
	
	//Had you ever extracted information with your DNI before?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_had_you_ever_extract_0" );
	
	//No... nothing can really prepare you for it. The flood of data, endless streams of infinite information. It's instantaneous and it's an eternity.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_no_nothing_can_re_0" );
	
	//What did it show you?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_did_it_show_you_0" );
	
	//The Cotardists had a Contact. An Inside Man at Coalescence World Headquarters in Zurich. We had his address, ID number, security details... the last of which was most telling.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_cotardists_had_a_1" );
	
	wait 1;
	
	//Telling in what way?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_telling_in_what_way_0" );
	
	//He had extensive security clearance at Coalescence. Specifically, he had access to 61-15. The Virus.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_had_extensive_sec_0" );
	
	//Taylor told us we'd already located the Inside Man's apartment.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_taylor_told_us_we_d_0" );
	
	wait 1;
	
	//Did you know their plan?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_did_you_know_their_p_0" );
	
	//No. But they had enough of the virus to turn the entire city into the living dead. We had to find him.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_no_but_they_had_eno_0" );
	
	//Then let's find him. Take me to his apartment.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_then_let_s_find_him_0" );
	
	wait 1;
	
	//We don't need every memory to create the bridge to the truth -- just the critical ones.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_we_don_t_need_every_0" );
}

function BZM_NEWWORLDDialogue4() // INSIDE MAN
{
	
}

function BZM_NEWWORLDDialogue5() // APARTMENT BREACH
{
	wait 1;
	
	//The Apartment...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_apartment_0" );
	
	wait 3;
	
	//It didn't go as planned.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_it_didn_t_go_as_plan_0" );
		
	//He was ready.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_was_ready_0" );
	
	wait 3;	
	
	//But it wasn't just you. Who was there with you? Taylor?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_but_it_wasn_t_just_y_0" );
	
	//Taylor... No, Taylor wasn't there, he had overwatch. He learned our Mark had released 61-15 into his building and those surrounding it. Sarah Hall, however--
	bonuszmsound::BZM_PlayPlayerVox( "plyz_taylor_no_taylor_0" );
	
	//Sarah Hall was with us. She was the point, the team's intelligence expert. She found our mark.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_sarah_hall_was_with_0" );
	
	wait 3;

	//She'd been with Taylor as long as Diaz. He practically raised her, trained her -- he made her.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_she_d_been_with_tayl_0" );
	
	wait 2;
	
	//Today John Taylor was our eyes in the sky.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_today_john_taylor_wa_0" );
	
	//Sarah Hall... she was our feet on the ground.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_sarah_hall_she_wa_0" );
	
	//And she was about to give us a lesson in target acquirement.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_and_she_was_about_to_0" );	
}

function BZM_NEWWORLDDialogue6() // BRIDGE COLLAPSE
{
	//This guy wasn't fucking around. Like us, he had DNI. He was hijacking any robotics he could, sending them after us.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_this_guy_wasn_t_fuck_0" );	
}

function BZM_NEWWORLDDialogue7() // GLASS CEILING
{
	wait 12;
	//What happened when you caught him?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_happened_when_y_0" );
	
	//Our Mark was bleeding out. We needed info, but there wasn't time.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_our_mark_was_bleedin_0" );	
	
	//So what did you do?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_so_what_did_you_do_0" );
	
	//We did what Hendricks did in Coalescence. We interfaced with him. Information extraction.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_did_what_hendrick_0" );	
	
	//You make it sound cold. You were diving into his mind, much like I am now with you. A dangerous task. A terminal task.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_you_make_it_sound_co_0" );
	
	//You have to make it cold. Detach yourself from the person. They weren't human anymore, they were a databank for pilfering.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_you_have_to_make_it_0" );	
	
	//Even though it would kill him.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_even_though_it_would_0" );
		
	//Even though... (beat) It's ironic, really.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_even_though_beat_0" );	
	
	//Ironic...?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_ironic_0" );
		
	//Hall standing there, ordering us to raid this man's mind, well... We both know what happened with Hall.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_hall_standing_there_0" );	
		
	//But we do what we have to do. This is the world we made for ourselves. If we don't do it, if we can't sacrifice the individual...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_but_we_do_what_we_ha_0" );	
		
	//How do we protect everyone else?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_how_do_we_protect_ev_0" );	
		
	//It's strange to be inside someone's mind, no? You witness the facts and the fiction. Information versus imagination...
	bonuszmsound::BZM_PlayDrSalimVox( "salm_it_s_strange_to_be_i_0" );
	
	//What did you find? What secrets did your 'databank' have to share?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_did_you_find_w_0" );
		
	//The Cotardist Group had set up shop deep in the subways. Whatever they were planning, the answers lay below.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_cotardist_group_0" );	
	
	//Information that would lead you to stop the bomb. Information that would save millions of lives. The Greater Good.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_information_that_wou_0" );	
	
	//...yeah. The greater good. It's just... (regret) A bullet to the head... that's how a person dies. But having your mind ripped to shreds by another?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_yeah_the_greater_0" );	
	
	//If only we'd known. The role this tech, this... shit in our head would play... turn us into puppets... Destroying minds, corrupting our own... (sad chuckle) The world we'd made.	
	bonuszmsound::BZM_PlayPlayerVox( "plyz_if_only_we_d_known_0" );	
		
	//Let's move on to the tunnels...
	bonuszmsound::BZM_PlayDrSalimVox( "salm_let_s_move_on_to_the_0" );	
}

function BZM_NEWWORLDDialogue8() // PINNED DOWN
{
	wait 5;
	//The tunnels... We tracked down the location of the Cotardist's operations.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_tunnels_we_tr_0" );	
	
	//Who joined you in the tunnels?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_who_joined_you_in_th_0" );	
	
	wait 1;
	
	//Taylor... and Peter Maretti. The last member of Taylor's team. An explosives expert.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_taylor_and_peter_0" );	
	
	wait 1;
	
	//And a self proclaimed “Badass Motherfucker”. (reflective) It's strange... seeing Maretti like this.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_and_a_self_proclaime_0" );	
	
	//Why is that?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_why_is_that_0" );	
	
	//Well, if it wasn't for Maretti...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_well_if_it_wasn_t_f_0" );	
	
	//At the Abandoned Refineries In Cairo?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_at_the_abandoned_ref_0" );	
	
	//He would be crucial to finding Taylor. To finding Deimos.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_would_be_crucial_0" );	
	
	wait 2;
	
	//He had a pivotal part to play. Funny... the twisted trails of fate.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_had_a_pivotal_par_0" );	
	
	//But that would come later.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_but_that_would_come_0" );	
	
	//Yes. Back then he was just a guy who liked to blow shit up.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_yes_back_then_he_wa_0" );	
	
	//And he was damn good at blowing shit up.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_and_he_was_damn_good_0" );	
	
	//He knew the way to the hideout. He took point.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_knew_the_way_to_t_0" );		
}

function BZM_NEWWORLDDialogue9() // STAGING ROOM
{	
	//Maretti had us interface with the console.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_maretti_had_us_inter_0" );		
	
	//The Cotardist Group had planted a biochemical bomb containing 61-15 on a Maglev Train.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_cotardist_group_1" );		
		
	//They were going to detonate it in downtown Zurich. Their plan was to turn everyone.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_they_were_going_to_d_0" );		
		
	//Taylor said there wasn't much time. (beat) But we'd done good. First time at bat and we'd come through.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_taylor_said_there_wa_0" );		
	
	//Pass with flying colors?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_pass_with_flying_col_0" );	
		
	//Sure. Why not.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_sure_why_not_0" );		
	
}

function BZM_NEWWORLDDialogue10() // INBOUND
{
	wait 1;
	
	//But we had to get to the train...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_but_we_had_to_get_to_0" );		
	
	wait 1;
	
	//Good. You didn't even need my push to jump to the final memory. You've connected the events and arrived at the truth.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_good_you_didn_t_eve_0" );	
	
	//Now what happens?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_now_what_happens_0" );		
	
	//Now we set things right. Through your mind, you realign the events as they occurred.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_now_we_set_things_ri_0" );	
	
	wait 1;
	
	//And by doing this... if I work with you and remember the events leading up to Zurich...?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_and_by_doing_this_0" );		
	
	//You'll be able to open the gateway.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_you_ll_be_able_to_op_0" );	
	
	//But I died in Zurich. If I change that I'll be remembering events that never happened. I'll create an alternate memory.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_but_i_died_in_zurich_0" );		
	
	wait 1;
	
	//It's the intent that's important. To progress to your next memory you must remember this one. To open the portal... you must commit the actions necessary to do just that. (beat) But let's not get ahead of ourselves. Finish this memory first.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_it_s_the_intent_that_0" );	
}

function BZM_NEWWORLDDialogue11() // DETACH THE BOMB CARRIAGE
{
	wait 1;
	
	//How did you stop it?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_how_did_you_stop_it_0" );
		
	//We had to detach the car...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_had_to_detach_the_0" );
	
	//It detonated before we hit Zurich. It created a mini containment zone outside the city, but the damage could've been far worse...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_it_detonated_before_0" );
		
	//You've done well...
	bonuszmsound::BZM_PlayDrSalimVox( "salm_you_ve_done_well_0" );		
}

function BZM_NEWWORLDDialogue12() // WAKING UP
{
	//Wait. What's this? Where am I?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_wait_what_s_this_w_0" );
	
	//Dr. Salim, what am I seeing??
	bonuszmsound::BZM_PlayPlayerVox( "plyz_dr_salim_what_am_i_0" );	
	
	//Your mind is trying to reject the truth. This isn't real.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_your_mind_is_trying_0" );
	
	//No. No, no, no. I remember this place. What are they doing to me?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_no_no_no_no_i_re_0" );	
	
	//Stop. Stay with me. Your mind wants you to misremember. Come back to reality.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_stop_stay_with_me_0" );
	
	//No, wait. I see someone. I see...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_no_wait_i_see_some_0" );	
	
	//Taylor? Taylor?? Why can't I move?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_taylor_taylor_why_0" );

	//You must let this go.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_you_must_let_this_go_0" );	
	
	//But I see Hendricks, how, this isn't possibly--
	bonuszmsound::BZM_PlayPlayerVox( "plyz_but_i_see_hendricks_0" );	
	
	//Relax. Come back to me. Come back to the Void...
	bonuszmsound::BZM_PlayDrSalimVox( "salm_relax_come_back_to_0" );	
}