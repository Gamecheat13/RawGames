#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#using scripts\cp\bonuszm\_bonuszm;
#using scripts\cp\bonuszm\_bonuszm_sound;
#using scripts\cp\_dialog;
#using scripts\cp\_util;

// LOTUS VOX
#using scripts\cp\voice\voice_z_lotus;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	

function autoexec Init()
{
	if( !( SessionModeIsCampaignZombiesGame() ) )
		return;
	
	mapname = GetDvarString( "mapname" );
	
	if( !IsSubstr( mapname, "lotus" ) )
		return;

	// Dialogue setup	
	voice_z_lotus::init_voice();	
		
	level.BZM_LOTUSDialogue1Callback	= &BZM_LOTUSDialogue1; // BONUSZM_LOTUS_DLG1
	level.BZM_LOTUSDialogue2Callback	= &BZM_LOTUSDialogue2; // BONUSZM_LOTUS_DLG2
	level.BZM_LOTUSDialogue3Callback	= &BZM_LOTUSDialogue3; // BONUSZM_LOTUS_DLG3
	level.BZM_LOTUSDialogue4Callback	= &BZM_LOTUSDialogue4; // BONUSZM_LOTUS_DLG4
	level.BZM_LOTUSDialogue5Callback	= &BZM_LOTUSDialogue5; // BONUSZM_LOTUS_DLG5 // PART OF THE LOADING MOVIE
	level.BZM_LOTUSDialogue6Callback	= &BZM_LOTUSDialogue6; // BONUSZM_LOTUS_DLG6
	level.BZM_LOTUSDialogue7Callback	= &BZM_LOTUSDialogue7; // BONUSZM_LOTUS_DLG7
	level.BZM_LOTUSDialogue8Callback	= &BZM_LOTUSDialogue8; // BONUSZM_LOTUS_DLG8
	level.BZM_LOTUSDialogue9Callback	= &BZM_LOTUSDialogue9; // BONUSZM_LOTUS_DLG9
	level.BZM_LOTUSDialogue10Callback	= &BZM_LOTUSDialogue10; // BONUSZM_LOTUS_DLG10
	level.BZM_LOTUSDialogue11Callback	= &BZM_LOTUSDialogue11; // BONUSZM_LOTUS_DLG11
			
	// Add lotus specific logic in the following function
	BZM_lotusSettings();
}

function private BZM_lotusSettings()
{
	callback::on_spawned( &BZM_lotusOnPlayerSpawned );	
}

function BZM_lotusOnPlayerSpawned()
{
	self AllowDoubleJump( true );
}

function BZM_LOTUSDialogue1() // APARTMENT
{
	wait 1;
	
	//Lotus Tower was one of many massive megatowers in Cairo. Hakim was the self-appointed slumlord of the vertical city, that fucker was a maniac, an undead sympathizer who was providing Taylor with safe passage from Cairo to Zurich.  (beat) Khalil and the Egyptian Army came with us. At the time we thought this was our chance. We took out Taylor we'd have a chance to save the world.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_lotus_tower_was_one_0" );
	
	//We took out Hakim's men. If we were gonna get Taylor, we first had kill the slumlord, then move to the security station on the 25th floor. From there we could locate Taylor and shut down the DEAD systems Hakim installed, allowing the rest of the Egyptian Army to join us. (beat) So here we were. Humanities last hope. If we failed, we were fucked.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_took_out_hakim_s_0" );	
}

function BZM_LOTUSDialogue2() // HAKIM (IGC)
{
	wait 4;
	//We made quick work of Hakim.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_made_quick_work_o_0" );	
	
	//Khalil spoke to the people -- this was their time. Time for the living to take back this city of the dead.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_khalil_spoke_to_the_0" );	
	
	//Khalil had a mobile shop across the way, we could use it to get to the 25th floor. But first we had to battle our way around the atrium.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_khalil_had_a_mobile_0" );		
	
	//NEEDS TO MOVE WHEN HENDRICKS SHOOTS THE VENT
	//The security station had gone under lock down, but Kane found us a way through the air ducts ahead.  (beat) Hendricks wasn't happy with the detour, but then he wasn't himself.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_security_station_0" );		
		
	//What happened to Hendricks?
	bonuszmsound::BZM_PlayDeimosVox( "deim_what_happened_to_hen_0" );		
	
	//You know damn well what happened to Hendricks.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_you_know_damn_well_w_0" );			
}

function BZM_LOTUSDialogue3() // HACK THE SYSTEM/EVENT 6: TAYLOR IGC
{
	//Kane told us to interface with the central console, she could overload the DEAD system and locate Taylor.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_kane_told_us_to_inte_0" );			
	
	//And Hendricks?
	bonuszmsound::BZM_PlayDeimosVox( "deim_and_hendricks_0" );
	
	//One by one he'd watched his friends die, Taylor would be the last one. How do you think he was? (beat) Kane set the DEAD system to overheat. Egyptian Army VTOLs would join the fight in a few minutes.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_one_by_one_he_d_watc_0" );			
	
	//And your man? John Taylor?
	bonuszmsound::BZM_PlayDeimosVox( "deim_and_your_man_john_t_0" );
		
	//He was in a detention center on the 90th floor, just waiting... he could have left at any moment, but he was waiting...  (angry) We should have known. I can't believe... we were so fucking naive we should've know what the fuck you were doing!!
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_was_in_a_detentio_0" );			
	
	//He waited for you. I waited for you.
	bonuszmsound::BZM_PlayDeimosVox( "deim_he_waited_for_you_i_0" );
	
	//He, you--
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_you_0" );			
	
	//I was... curious. After you interfaced with Hall you were infected, but I couldn't possess you, not like the others. You wouldn't give up the chase, you persevered. Something in your mind... refused to bow to me. (beat) I wanted to see what you would do.
	bonuszmsound::BZM_PlayDeimosVox( "deim_i_was_curious_af_0" );
	
	//Fuck you.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_fuck_you_0" );			
}

function BZM_LOTUSDialogue4() // STAND DOWN (IGC)
{
	wait 3;
	
	//And there he was. John Taylor. The last five years, boiling down to a single moment.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_and_there_he_was_jo_0" );			
	
	//And you... hesitated. You were given control over Taylor's fate, and you hesitated. After all these years, running from your failure to stop the end of the world... and you couldn't pull the trigger.
	bonuszmsound::BZM_PlayDeimosVox( "deim_and_you_hesitated_0" );
	
	//I had what I wanted in front of me. (beat) But Hendricks lowered his weapon...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_had_what_i_wanted_0" );			
		
	//You felt compassion?
	bonuszmsound::BZM_PlayDeimosVox( "deim_you_felt_compassion_0" );
	
	//No. It was Hendricks. He tried to talk him down, change his mind. He tried to stop him. Persuade. For a moment I saw the light return to Hendricks' eyes. I saw him.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_no_it_was_hendricks_0" );			
	
	//This would be one of my last memories with Hendricks, before...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_this_would_be_one_of_0" );			
	
	wait 5;
	
	//Watching Taylor walk away from Hendricks as he pleaded, I saw the inevitability. We weren't going to win this war.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_watching_taylor_walk_0" );			
	
	//But as you always did, you pressed on.
	bonuszmsound::BZM_PlayDeimosVox( "deim_but_as_you_always_di_0" );
	
	wait 2;
	
	//This was the world we made... what else were we going to do?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_this_was_the_world_w_0" );			
}

function BZM_LOTUSDialogue5() // DNI DELUSION IGC
{
	//What happened when you entered Tower Two?
	bonuszmsound::BZM_PlayDeimosVox( "deim_what_happened_when_y_0" );
	
	//A... a malfunction. My DNI...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_a_a_malfunction_0" );		
	
	wait 3;

	//Listen to me. Listen to the sound of my voice...
	bonuszmsound::BZM_PlayDolosVox( "dolo_listen_to_me_listen_0" );		
	
	//...I need you to trust me, let him win...
	bonuszmsound::BZM_PlayDolosVox( "dolo_i_need_you_to_tru_0" );		
	
	//...The only way to defeat him is to let. Him. Win...
	bonuszmsound::BZM_PlayDolosVox( "dolo_the_only_way_to_d_0" );		
	
	//You're more powerful than he can imagine.
	bonuszmsound::BZM_PlayDolosVox( "dolo_you_re_more_powerful_0" );		
	
	//You can still save them. You can still save everyone.
	bonuszmsound::BZM_PlayDolosVox( "dolo_you_can_still_save_t_0" );		
}

function BZM_LOTUSDialogue6() // LOTUS TOWER 3 START IGC
{
	wait 3;
	
	//We snapped out of our delusion. Taylor, you, you were heading for the roof, Tower Two had a small airfield on top of it. All we could do was go up.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_snapped_out_of_ou_0" );			
}

function BZM_LOTUSDialogue7() // MOBILE SHOP CONVERSATION (IGC)
{
	wait 1;
	
	//I must admit... this, talking to you now, it has been quite the journey. Even now you're still resistant to submission. I don't think I've ever met a human like you... You certainly are unique. You really gave humanity a fighting chance.
	bonuszmsound::BZM_PlayDeimosVox( "deim_i_must_admit_this_0" );
	
	wait 5;
	
	//By this time you knew I was baiting you. I was waiting for you. I had no need for Hendricks, he wasn't interesting, I wanted you.
	bonuszmsound::BZM_PlayDeimosVox( "deim_by_this_time_you_kne_0" );
	
	wait 3;
	
	//I gave him something to keep him busy. You came after me.  (beat) What's it like... looking at him for one last time? One moment, he's with you, the next...
	bonuszmsound::BZM_PlayDeimosVox( "deim_i_gave_him_something_0" );	
}

function BZM_LOTUSDialogue8() // TAYLOR INTRO (IGC)
{
	//We know what happens next.  (beat) I was leaving Cairo. I needed to get to Zurich. I had to open the gateway.
	bonuszmsound::BZM_PlayDeimosVox( "deim_we_know_what_happens_0" );	
	
	//But right then you had my full attention. Your resistance... your unwillingness to yield hope...
	bonuszmsound::BZM_PlayDeimosVox( "deim_but_right_then_you_h_0" );	
	
	//...I wanted to test what you were made of.
	bonuszmsound::BZM_PlayDeimosVox( "deim_i_wanted_to_test_0" );	
	
	wait 3;
	
	//Over comms, Kane told me the only way to bring down the airship was to shoot out its thrusters. Kane sent up mobile shops to support me with more firepower -- I'd need a shops' minigun if I wanted to take down the airship.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_over_comms_kane_tol_0" );			
}

function BZM_LOTUSDialogue9() // TAYLOR OUTRO (IGC)
{
	wait 2;
	
	//The airship crashed and pinned me on the roof.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_airship_crashed_0" );			
	
	//I was stuck, trapped. I called out, but there was no one there.	
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_was_stuck_trapped_0" );			
	
	wait 1;
	
	//No one except Taylor.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_no_one_except_taylor_0" );			
	
	wait 1;
	
	//I tried to stop him--
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_tried_to_stop_him_0" );			

	//And then I saw it. That look in his eyes: life. Recognition. A return of clarity, a soft glimmer. I saw Taylor.	
	bonuszmsound::BZM_PlayPlayerVox( "plyz_and_then_i_saw_it_t_0" );			
	
	//He told me he had to get you out of his head.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_told_me_he_had_to_0" );			
	
	wait 5;
	
	//He was ripping out his DNI, the very method by which you controlled us.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_was_ripping_out_h_0" );		

	wait 2;

	//It was done, I felt myself fading, I felt it calling me, the hereafter...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_it_was_done_i_felt_0" );		
	
	//And this time Taylor couldn't save me.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_and_this_time_taylor_0" );		
	
	//What did he say to you?
	bonuszmsound::BZM_PlayDeimosVox( "deim_what_did_he_say_to_y_0" );	
	
	//He asked me about the Guardian Angel. Kane. Somehow, he knew who she was... (beat) He told me to trust her and do what she asks. She was more important than I could possibly imagine.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_and_this_time_taylor_0" );		
	
	wait 1;
	
	//And then my final puppet made his entrance.
	bonuszmsound::BZM_PlayDeimosVox( "deim_and_then_my_final_pu_0" );
	
	//NO!
	bonuszmsound::BZM_PlayPlayerVox( "plyz_no_0" );		
		
	//Even now you cry out to stop him. Hendricks, your greatest mistake, your friendship made you so blind you never knew I had possession over him.
	bonuszmsound::BZM_PlayDeimosVox( "deim_even_now_you_cry_out_0" );
	
	//...from Coalescence in Singapore. When he interfaced with Diaz. You'd been with him -- and me -- since the beginning.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_from_coalescence_0" );		
	
	//You humans and your beginnings and endings, it's no wonder you had destroyed yourselves...
	bonuszmsound::BZM_PlayDeimosVox( "deim_you_humans_and_your_0" );
		
	wait 1;
	
	//So I gave you your ending. I left you there. I would use Hendricks to get to Zurich.
	bonuszmsound::BZM_PlayDeimosVox( "deim_so_i_gave_you_your_e_0" );
		
	//But your... Guardian Angel. Whoever that bitch is she's a greater friend than you ever deserved. She wouldn't let you die.
	bonuszmsound::BZM_PlayDeimosVox( "deim_but_your_guardian_0" );
	
	//She saved you.
	bonuszmsound::BZM_PlayDeimosVox( "deim_she_saved_you_0" );
	
	wait 1;
	
	//What's it like? To escape death when it's all you desire?
	bonuszmsound::BZM_PlayDeimosVox( "deim_what_s_it_like_to_e_0" );
	
	//You must have been tired. Tired of fighting. Of running. Of living.
	bonuszmsound::BZM_PlayDeimosVox( "deim_you_must_have_been_t_0" );
	
	//Lucky for you, I was about to get my wish.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_lucky_for_you_i_was_0" );		
	
	//The naivety of your friend. What did she have to say to you?
	bonuszmsound::BZM_PlayDeimosVox( "deim_the_naivety_of_your_0" );
	
	//Do as he asks. Give Deimos what he wants. Trust me. It's all going to be okay.
	bonuszmsound::BZM_PlayDolosVox( "dolo_do_as_he_asks_give_0" );		
	
	wait 1;
	
	//Just that we were going to Zurich. To stop Hendricks. To stop you. To end it.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_just_that_we_were_go_0" );		
}

function BZM_LOTUSDialogue10()
{
	wait 4;
	
	//Kane gave you access to a weapons locker with special “juiced” shotguns, its bullets laced with electricity.
	bonuszmsound::BZM_PlayDeimosVox( "deim_kane_gave_you_access_0" );
	
	wait 4;

	//You needed it, more were coming your way.	
	bonuszmsound::BZM_PlayDeimosVox( "deim_you_needed_it_more_0" );	
}

function BZM_LOTUSDialogue11()
{
	wait 4;
	//Hendricks had been stretched thin. You'd broken him.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_hendricks_had_been_s_0" );

	//I enlightened him. Like I did you. (beat) Look at false memories I created for you. I tried to remove your most haunting, where you were crushed to pieces and left for dead in Ethiopia. I added myself to your memory of Ramses, so I could make you understand my motives.
	bonuszmsound::BZM_PlayDeimosVox( "deim_i_enlightened_him_l_0" );	
	
	//Right, this war with your sister, Dolos? What does it say about you that the only way you can beat her is by enslaving backup?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_right_this_war_with_0" );
	
	//Don't. You. Dare. FUCKING. MOCK. ME.
	bonuszmsound::BZM_PlayDeimosVox( "deim_don_t_you_dare_fu_0" );			
}

