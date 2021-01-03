#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#using scripts\cp\bonuszm\_bonuszm;
#using scripts\cp\bonuszm\_bonuszm_sound;
#using scripts\cp\_dialog;
#using scripts\cp\_util;

// ZURICH VOX
#using scripts\cp\voice\voice_z_zurich;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	

function autoexec Init()
{
	if( !( SessionModeIsCampaignZombiesGame() ) )
		return;
	
	mapname = GetDvarString( "mapname" );
	
	if( mapname != "cp_mi_zurich_coalescence" )
		return;

	// Dialogue setup	
	voice_z_zurich::init_voice();	
		
	level.BZM_ZURICHDialogue1Callback	= &BZM_ZURICHDialogue1; // BONUSZM_ZURICH_DLG1
	level.BZM_ZURICHDialogue2Callback	= &BZM_ZURICHDialogue2; // BONUSZM_ZURICH_DLG2
	level.BZM_ZURICHDialogue3Callback	= &BZM_ZURICHDialogue3; // BONUSZM_ZURICH_DLG3
	level.BZM_ZURICHDialogue4Callback	= &BZM_ZURICHDialogue4; // BONUSZM_ZURICH_DLG4
	level.BZM_ZURICHDialogue5Callback	= &BZM_ZURICHDialogue5; // BONUSZM_ZURICH_DLG5
	level.BZM_ZURICHDialogue6Callback	= &BZM_ZURICHDialogue6; // BONUSZM_ZURICH_DLG6
	level.BZM_ZURICHDialogue7Callback	= &BZM_ZURICHDialogue7; // BONUSZM_ZURICH_DLG7
	level.BZM_ZURICHDialogue8Callback	= &BZM_ZURICHDialogue8; // BONUSZM_ZURICH_DLG8
	level.BZM_ZURICHDialogue9Callback	= &BZM_ZURICHDialogue9; // BONUSZM_ZURICH_DLG9
	level.BZM_ZURICHDialogue10Callback	= &BZM_ZURICHDialogue10; // BONUSZM_ZURICH_DLG10 - un-implemented
	level.BZM_ZURICHDialogue11Callback	= &BZM_ZURICHDialogue11; // BONUSZM_ZURICH_DLG11
	level.BZM_ZURICHDialogue12Callback	= &BZM_ZURICHDialogue12; // BONUSZM_ZURICH_DLG12
	level.BZM_ZURICHDialogue13Callback	= &BZM_ZURICHDialogue13; // BONUSZM_ZURICH_DLG13
	level.BZM_ZURICHDialogue14Callback	= &BZM_ZURICHDialogue14; // BONUSZM_ZURICH_DLG14
	level.BZM_ZURICHDialogue15Callback	= &BZM_ZURICHDialogue15; // BONUSZM_ZURICH_DLG15
	level.BZM_ZURICHDialogue16Callback	= &BZM_ZURICHDialogue16; // BONUSZM_ZURICH_DLG16
	level.BZM_ZURICHDialogue17Callback	= &BZM_ZURICHDialogue17; // BONUSZM_ZURICH_DLG17
	level.BZM_ZURICHDialogue18Callback	= &BZM_ZURICHDialogue18; // BONUSZM_ZURICH_DLG18
	level.BZM_ZURICHDialogue19Callback	= &BZM_ZURICHDialogue19; // BONUSZM_ZURICH_DLG19
	level.BZM_ZURICHDialogue20Callback	= &BZM_ZURICHDialogue20; // BONUSZM_ZURICH_DLG20
	level.BZM_ZURICHDialogue21Callback	= &BZM_ZURICHDialogue21; // BONUSZM_ZURICH_DLG21
	level.BZM_ZURICHDialogue22Callback	= &BZM_ZURICHDialogue22; // BONUSZM_ZURICH_DLG22
	level.BZM_ZURICHDialogue23Callback	= &BZM_ZURICHDialogue23; // BONUSZM_ZURICH_DLG23
	level.BZM_ZURICHDialogue24Callback	= &BZM_ZURICHDialogue24; // BONUSZM_ZURICH_DLG24
	
	// Add zurich specific logic in the following function
	BZM_ZurichSettings();
}

function private BZM_ZurichSettings()
{
	callback::on_spawned( &BZM_ZurichOnPlayerSpawned );	
}

function BZM_ZurichOnPlayerSpawned()
{
	//self AllowDoubleJump( false );
}

function BZM_ZURICHDialogue1() // SH*T ST*RM
{
	wait 1;
	
	//With Hendricks as my vehicle, I stampeded toward Coalescence, anarchy and panic following in my wake.
	bonuszmsound::BZM_PlayDeimosVox( "deim_with_hendricks_as_my_0" );
	
	wait 3;
	
	//Zurich was one of the few remaining standing cities. With control over  my undead army and the city's Robotic security force I decimated it in hours.
	bonuszmsound::BZM_PlayDeimosVox( "deim_zurich_was_one_of_th_0" );
	
	wait 2;
	
	//I needed to separate you from your 'Guardian Angel', Kane. I didn't have control over her... and she was pulling my power from you. That would come later. (beat) I'd taken Coalescence Headquarters, surrounding it with an impenetrable armada. Except for you. I was waiting. I was still curious, I was in your head, but I couldn't take control. I wanted, no, I needed, to know how before I opened the gateway.
	bonuszmsound::BZM_PlayDeimosVox( "deim_i_needed_to_separate_0" );
		
	//But before that you had to get through my undead army.
	bonuszmsound::BZM_PlayDeimosVox( "deim_but_before_that_you_0" );	
}

function BZM_ZURICHDialogue2() // SACRIFICE
{
	wait 4;
	
	//Once we were inside you released this chemical...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_once_we_were_inside_0" );
	
	wait 4;
	
	//61-15. The virus that caused the outbreak in Singapore.
	bonuszmsound::BZM_PlayDeimosVox( "deim_61_15_the_virus_tha_0" );	
	
	wait 3;
	
	//And I had enough to wipe out all of Zurich...
	bonuszmsound::BZM_PlayDeimosVox( "deim_and_i_had_enough_to_0" );	

	wait 1;
	
	//You had triggered multiple breaches and containment failures... (beat) I interfaced with the system to see how bad the damage was...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_you_had_triggered_mu_0" );	
	
	level flag::wait_till( "flag_start_kane_sacrifice_igc" );
	
	//And Kane acted as I predicted.
	bonuszmsound::BZM_PlayDeimosVox( "deim_and_kane_acted_as_i_0" );		
	
	wait 1;
	
	//She sacrificed herself. The room was flooded with 61-15, and the system reset was in there.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_she_sacrificed_herse_0" );	
	
	wait 2;
	
	//But... wait. No, there was a problem. What had you done?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_but_wait_no_the_0" );	
		
	wait 3;
	
	//You lied... you tricked her, there was no breach. She sacrificed herself for... for nothing.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_you_lied_you_tric_0" );	
	
	wait 4;
	
	//I ripped her from you. She could toy no more in my affairs. The dose I gave her wouldn't even turn her -- it would simply kill her.
	bonuszmsound::BZM_PlayDeimosVox( "deim_i_ripped_her_from_yo_0" );		
	
	wait 1;
	
	//I won't understand your species. You sacrifice yourselves for so little. Look at her, she gave her life for something that would amount to nothing.
	bonuszmsound::BZM_PlayDeimosVox( "deim_i_won_t_understand_y_0" );		
	
	//You tie yourselves to emotions, forcing you to act impulsive, without considering what could happen...
	bonuszmsound::BZM_PlayDeimosVox( "deim_you_tie_yourselves_t_0" );		
	
	//You give your lives because you believe there's something to gain. As if a heavenly body will fall to its knees and worship you for your good deeds.
	bonuszmsound::BZM_PlayDeimosVox( "deim_you_give_your_lives_0" );		
		
	//As if you were at the center of the universe...
	bonuszmsound::BZM_PlayDeimosVox( "deim_as_if_you_were_at_th_0" );		
	
	wait 2;
	
	//You fight for those around you not to save them, but to justify yourself, save yourself...
	bonuszmsound::BZM_PlayDeimosVox( "deim_you_fight_for_those_0" );		
	
	//Keep moving, you're almost there.
	bonuszmsound::BZM_PlayDeimosVox( "deim_keep_moving_you_re_0" );		
}

function BZM_ZURICHDialogue3() // STAND OFF
{
	//Do you remember this place? What happened here?
	bonuszmsound::BZM_PlayDeimosVox( "deim_do_you_remember_this_0" );
	
	wait 1;
		
	//You found Krueger, the one Salim called to rebuild Corvus.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_you_found_krueger_t_0" );	
	
	wait 1;
	
	//It was time to open the gateway, after I finished with Krueger.
	bonuszmsound::BZM_PlayDeimosVox( "deim_it_was_time_to_open_0" );
	
	//I couldn't let you, I told Hendricks to stand down or I'd take him down myself.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_couldn_t_let_you_0" );	
	
	//You tried to reason with him. You remember what happens next.
	bonuszmsound::BZM_PlayDeimosVox( "deim_you_tried_to_reason_0" );
	
	wait 1;
	
	//We shot each other. I bled out on the floor and died.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_shot_each_other_0" );	
	
	//But now you will shoot first. Change the memory. Don't wait for him to turn on you. Kill him.
	bonuszmsound::BZM_PlayDeimosVox( "deim_but_now_you_will_sho_0" );
	
	wait 3;
	
	//Kill him./Do It./Pull the Trigger./Shoot him./Kill Him./Finish him./Kill Hendricks./Do it now./
	bonuszmsound::BZM_PlayDeimosVox( "deim_kill_him_do_it_pul_0" );
	
	//Change your fate.
	bonuszmsound::BZM_PlayDeimosVox( "deim_change_your_fate_0" );
	
	wait 4;
	
	//Good. Now sacrifice yourself. Open the gateway.
	bonuszmsound::BZM_PlayDeimosVox( "deim_good_now_sacrifice_0" );
	
	wait 2;
	
	//Everything will be alright.
	bonuszmsound::BZM_PlayDolosVox( "dolo_everything_will_be_a_0" );
	
	//Do as he asks. Let him think he's won.
	bonuszmsound::BZM_PlayDolosVox( "dolo_do_as_he_asks_let_h_0" );
		
	//Offer yourself to him...
	bonuszmsound::BZM_PlayDolosVox( "dolo_offer_yourself_to_hi_0" );
}

function BZM_ZURICHDialogue4() // EXT. FROZEN FOREST.
{
	wait 2;
	
	//Wait... what? Where am I? What is this place?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_wait_what_where_0" );	
	
	wait 2;
	
	//Hendricks? What are you doing here?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_hendricks_what_are_0" );	
	
	//You... you look... human.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_you_you_look_h_0" );	
	
	wait 2;
	
	//I can't... I can't hear you. What are you saying? Why... why can't I hear you?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_can_t_i_can_t_h_0" );	
		
	//Humans have no voice in our realm. And as it happens, it is not Hendricks... merely a reflection of your conscious... It's how our realm manifests itself to mortals.
	bonuszmsound::BZM_PlayDolosVox( "dolo_humans_have_no_voice_0" );
	
	//Your realm? Who are you? Where the fuck am I?--
	bonuszmsound::BZM_PlayPlayerVox( "plyz_your_realm_who_are_0" );	
	
	//Be quiet, he's coming. He's found you.
	bonuszmsound::BZM_PlayDolosVox( "dolo_be_quiet_he_s_comin_0" );
	
	wait 3;
	
	//How is this possible? What did you do?? What did you fucking do???
	bonuszmsound::BZM_PlayDeimosVox( "deim_how_is_this_possible_0" );
	
	wait 3;
	
	//What are all of you doing here?
	bonuszmsound::BZM_PlayDeimosVox( "deim_what_are_all_of_you_0" );
	
	wait 1;
	
	//What did you do?
	bonuszmsound::BZM_PlayDeimosVox( "deim_what_did_you_do_0" );
	
	//Deimos?? Where are we??
	bonuszmsound::BZM_PlayPlayerVox( "plyz_deimos_where_are_w_0" );	
		
	//Like you don't know? You have no part in this? It's not obvious to you? I've been tricked. How did you TRICK ME?? You. Krueger. You did this. You MADE THIS HAPPEN!!
	bonuszmsound::BZM_PlayDeimosVox( "deim_like_you_don_t_know_0" );
	
	wait 2;
	
	//ANSWER ME. WHAT DID YOU DO?
	bonuszmsound::BZM_PlayDeimosVox( "deim_answer_me_what_did_0" );
	
	//What are you saying? Why can't you speak? You move your mouth you fucking invalid but you DO NOT SPEAK. I AM DEIMOS. DEMIGOD OF DREAD AND TERROR -- I DEMAND YOU SPEAK!
	bonuszmsound::BZM_PlayDeimosVox( "deim_what_are_you_saying_0" );
	
	wait 1;
	
	//I gave you a simple task, build me my machine so I could open the gateway. I need my army! I must defeat my sister!! (enraged) And yet you still refuse to speak, you have so much to answer for -- all the years I have waited, gone, ruined, but I don't understand, how DARE YOU FUCK THIS UP!
	bonuszmsound::BZM_PlayDeimosVox( "deim_i_gave_you_a_simple_0" );
	
	wait 2;	
	
	//Please... please, why are you torturing me with your silent pantomiming. I don't deserve this, I deserve my justice.  (beat) SPEAK!
	bonuszmsound::BZM_PlayDeimosVox( "deim_please_please_wh_0" );
	
	wait 1;
	
	//He can't speak. Humans have no voice in this realm.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_can_t_speak_huma_0" );	
	
	//Where... where did you hear that? (to Krueger) Krueger, I will have my answers. Come with me.
	bonuszmsound::BZM_PlayDeimosVox( "deim_where_where_did_y_0" );
}

function BZM_ZURICHDialogue5() //  Approach Waterfall Vignette
{
	wait 2;
	
	//Hello?? Who's there?? Where am I??
	bonuszmsound::BZM_PlayPlayerVox( "plyz_hello_who_s_there_0" );	
		
	//This is your new home, my child. (beat) This... is Malum.
	bonuszmsound::BZM_PlayDolosVox( "dolo_this_is_your_new_hom_0" );	
}

function BZM_ZURICHDialogue6() // PLUNGE
{
	wait 3;
	
	//Who are you? I... I recognize your voice. You've spoken to me before...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_who_are_you_i_i_0" );		
	
	//I am the reason you're still alive.
	bonuszmsound::BZM_PlayDolosVox( "dolo_i_am_the_reason_you_0" );	
	
	wait 1;
	
	//Let me do the talking. After all, we're family.
	bonuszmsound::BZM_PlayDolosVox( "dolo_let_me_do_the_talkin_0" );	
}

function BZM_ZURICHDialogue7() // KRUEGER
{
	wait 1;
	
	//Deimos? Where are you?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_deimos_where_are_yo_0" );		
	
	//I don't know what you did, but this wasn't part of the plan.
	bonuszmsound::BZM_PlayDeimosVox( "deim_i_don_t_know_what_yo_0" );
	
	//This poor soul didn't do a damn thing. It was you, wasn't it? A human. A mortal. How did you do it?
	bonuszmsound::BZM_PlayDeimosVox( "deim_this_poor_soul_didn_0" );
	
	//It wasn't her, little brother.
	bonuszmsound::BZM_PlayDolosVox( "dolo_it_wasn_t_her_littl_0" );	
	
	//...No...no, that's impossible. This cannot be! What have you done??
	bonuszmsound::BZM_PlayDeimosVox( "deim_no_no_that_s_i_0" );
	
	wait 2;
	
	//You've had quite enough fun with humanity. You're done playing with your toys. The Time of the Dead is over.
	bonuszmsound::BZM_PlayDolosVox( "dolo_you_ve_had_quite_eno_0" );	
	
	//No...
	bonuszmsound::BZM_PlayDeimosVox( "deim_no_0" );
		
	//I brought you back to Malum, I've sealed the portal. With you no longer on earth, the dead have lost their leader. They'll fall into disarray and humanity shall reclaim earth.
	bonuszmsound::BZM_PlayDolosVox( "dolo_i_brought_you_back_t_0" );	
	
	wait 3;
	
	//Humanity will destroy itself in time, it doesn't need our help to do that, brother.
	bonuszmsound::BZM_PlayDolosVox( "dolo_humanity_will_destro_0" );	
	
	wait 3;
	
	//DOLOS!!!
	bonuszmsound::BZM_PlayDeimosVox( "deim_dolos_0" );
	
	wait 5;
	
	//Taylor? Is that you? What are you doing here -- how are you here?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_taylor_is_that_you_0" );		
	
	wait 3;
	
	//It's not Taylor, it's an illusion I've created for you, a companion I thought might help you fight your way through.
	bonuszmsound::BZM_PlayDolosVox( "dolo_it_s_not_taylor_it_0" );
	
	//Fight my way through? Who are you?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_fight_my_way_through_0" );		
	
	//I am Dolos. Demigoddess of deception and trickery. And oh yes, there's much work to be done.
	bonuszmsound::BZM_PlayDolosVox( "dolo_i_am_dolos_demigodd_0" );	
	
	//You're going to kill Deimos for me. You're going to kill my brother.
	bonuszmsound::BZM_PlayDolosVox( "dolo_you_re_going_to_kill_0" );	
}

function BZM_ZURICHDialogue8() // GATEWAYS
{
	
}

function BZM_ZURICHDialogue9() // ZURICH PATH
{
	wait 2;
	
	//You should NOT BE HERE!
	bonuszmsound::BZM_PlayDeimosVox( "deim_you_should_not_be_he_0" );
	
	//Deimos, come back, we just want to play.
	bonuszmsound::BZM_PlayDolosVox( "dolo_deimos_come_back_w_0" );	
	
	wait 1;
	
	//It's time for your petty project to be finished.
	bonuszmsound::BZM_PlayDolosVox( "dolo_it_s_time_for_your_p_0" );	
	
	//Petty??? You DARE CALL ME PETTY??
	bonuszmsound::BZM_PlayDeimosVox( "deim_petty_you_dare_ca_0" );
}

function BZM_ZURICHDialogue10() // ZURICH TRANSITION - un-implemented
{
	wait 4;
	
	//Deimos... Dolos??
	bonuszmsound::BZM_PlayPlayerVox( "plyz_deimos_dolos_0" );			
	
	wait 1;
	
	//Taylor? Is anyone there?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_taylor_is_anyone_th_0" );			
}

function BZM_ZURICHDialogue11() // ZURICH ROOT
{
	wait 4;
	
	//Dolos, where are we?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_dolos_where_are_we_0" );			
	
	//Malum is a realm beyond conceptual space and time. It manifests as a reflection of the individual. This is your Malum.   (beat) Follow Taylor.
	bonuszmsound::BZM_PlayDolosVox( "dolo_malum_is_a_realm_bey_0" );			
	
	//Where is he taking me?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_where_is_he_taking_m_0" );			
	
	wait 1;
	
	//To one of Deimos' hearts. To destroy him you must first destroy his hearts.
	bonuszmsound::BZM_PlayDolosVox( "dolo_to_one_of_deimos_he_0" );

	wait 2;
	
	//Be wary, his undead minions stand between you and what you seek.
	bonuszmsound::BZM_PlayDolosVox( "dolo_be_wary_his_undead_0" );	
}

function BZM_ZURICHDialogue12() // BIRTH OF THE AI
{
	wait 2;
	
	//I arrived on Earth with my brother. I lay hidden in shadow.
	bonuszmsound::BZM_PlayDolosVox( "dolo_i_arrived_on_earth_w_0" );	
	
	wait 3;
	
	//Dr. Salim and Deimos never knew I came through, but then neither were very bright. Deimos in particular was pretty simple minded.
	bonuszmsound::BZM_PlayDolosVox( "dolo_dr_salim_and_deimos_0" );	
	
	wait 1;
	
	//Revenge, power, violence -- he crashed through your dimension with a singular goal.  (beat) Convert humanity into an undead army at his disposal. So he could kill me once and for all.
	bonuszmsound::BZM_PlayDolosVox( "dolo_revenge_power_viol_0" );	
	
	wait 2;
	
	//And I was comfortable letting him have his victory.
	bonuszmsound::BZM_PlayDolosVox( "dolo_and_i_was_comfortabl_0" );	
	
	wait 1;
	
	//At least the illusion of victory. Let him think he'd won.
	bonuszmsound::BZM_PlayDolosVox( "dolo_at_least_the_illusio_0" );
	
	//So I sat back while he consumed all of Earth.
	bonuszmsound::BZM_PlayDolosVox( "dolo_so_i_sat_back_while_0" );
}

function BZM_ZURICHDialogue13() // CAIRO PATH
{
	wait 4;

	//You must realize the futility of your actions. You cannot stop me -- a human cannot kill a god.	
	bonuszmsound::BZM_PlayDeimosVox( "deim_you_must_realize_the_0" );
	
	//Ah, but brother, she is no ordinary human -- she's been transitioned, she doesn't travel alone. Wherever she goes I've followed, I'm in her head, a part of her being.
	bonuszmsound::BZM_PlayDolosVox( "dolo_ah_but_brother_she_0" );	
	
	wait 1;
	
	//How could you have known what I was planning?
	bonuszmsound::BZM_PlayDeimosVox( "deim_how_could_you_have_k_0" );
	
	wait 3;
	
	//Because it was I who planned it. I watched as she descended the depths of Coalescence. Saved her when she was drowning in the Aquifers. Guided her through battle in Zurich. This entire time you've played into my hand...
	bonuszmsound::BZM_PlayDolosVox( "dolo_because_it_was_i_who_0" );

	//It's a pity she won't live to see me kill you...
	bonuszmsound::BZM_PlayDeimosVox( "deim_it_s_a_pity_she_won_0" );	
}

function BZM_ZURICHDialogue14() // CAIRO TRANSITION
{
	wait 2;
	
	//Do not be deceived into thinking you can defeat me so easy...
	bonuszmsound::BZM_PlayDeimosVox( "deim_do_not_be_deceived_i_0" );
	
	wait 3;
	
	//You now meddle with worlds beyond your own. She cannot protect you from me...
	bonuszmsound::BZM_PlayDeimosVox( "deim_you_now_meddle_with_0" );
	
	wait 4;

	//I will break you, rip you from her grasp...
	bonuszmsound::BZM_PlayDeimosVox( "deim_i_will_break_you_ri_0" );		
}

function BZM_ZURICHDialogue15() // CAIRO ROOT
{
	wait 3;
	
	//You... you were Kane. You were with me the whole time.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_you_you_were_kane_0" );				
	
	wait 2;
	
	//I'm not my brother, I don't turn people into puppets. Not when they're so suggestible and malleable. Why control when they can formulate their own thoughts.
	bonuszmsound::BZM_PlayDolosVox( "dolo_i_m_not_my_brother_0" );
	
	//Go... destroy the heart.
	bonuszmsound::BZM_PlayDolosVox( "dolo_go_destroy_the_he_0" );
}

function BZM_ZURICHDialogue16() // REBIRTH OF THE AI
{
	wait 3;
	
	//Taylor found us easily. All it took was for Dr. Salim to create the disturbance.
	bonuszmsound::BZM_PlayDolosVox( "dolo_taylor_found_us_easi_0" );
	
	wait 3;
	
	//Deimos... Deimos is a primitive creature. He thought Dr. Salim had done it for him.
	bonuszmsound::BZM_PlayDolosVox( "dolo_deimos_deimos_is_0" );
	
	//In truth I was bored. I had my fun watching my brother's feeble attempts to wrangle humanity, but it was time to go home.
	bonuszmsound::BZM_PlayDolosVox( "dolo_in_truth_i_was_bored_0" );
	
	wait 2;
	
	//You let him destroy humanity...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_you_let_him_destroy_0" );				
	
	//It'll turn back, humanity will be just fine. Without Deimos Bishops serum will work. In fact, letting me join with you on this journey, you've helped save humanity.
	bonuszmsound::BZM_PlayDolosVox( "dolo_it_ll_turn_back_hum_0" );
}

function BZM_ZURICHDialogue17() // SINGAPORE PATH
{
	wait 3;
	
	//Sister... I beg you... don't do this. Don't make me end you.
	bonuszmsound::BZM_PlayDeimosVox( "deim_sister_i_beg_you_0" );
	
	//As always, brother. You underestimate how powerful I am... and she is.
	bonuszmsound::BZM_PlayDolosVox( "dolo_as_always_brother_0" );
		
	wait 2;
	
	//What will Father think? He won't stand by idly while you kill his only son.
	bonuszmsound::BZM_PlayDeimosVox( "deim_what_will_father_thi_0" );
	
	//I think our father has said and done quite enough, perhaps after you I shall take care of him.
	bonuszmsound::BZM_PlayDolosVox( "dolo_i_think_our_father_h_0" );	
	
	wait 2;
	
	//And then what, after you murder the King on his Fiery Throne? Do you plan to kill Cronus, Proteus, and Hybris? Charon? The Four Brothers of the Great Sea? The Great Moros? The Mirrors of Persus? Where does it stop? Will you kill all of Malum over that thing? That human?
	bonuszmsound::BZM_PlayDeimosVox( "deim_and_then_what_after_0" );
	
	//Let's just see where the afternoon takes us.
	bonuszmsound::BZM_PlayDolosVox( "dolo_let_s_just_see_where_0" );

	wait 1;

	//You're insane.
	bonuszmsound::BZM_PlayDeimosVox( "deim_you_re_insane_0" );	
	
	//No, humanity is insane. And I love it. (evil chuckle) Run... run while you can, little brother.
	bonuszmsound::BZM_PlayDolosVox( "dolo_no_humanity_is_insa_0" );
}

function BZM_ZURICHDialogue18() // SINGAPORE TRANSITION
{
	wait 2;
	
	//This cold world is damned and consumed by death. It's outstayed its welcome in the known universe. Father won't be pleased... what better time than now, I suppose...
	bonuszmsound::BZM_PlayDolosVox( "dolo_this_cold_world_is_d_0" );
}

function BZM_ZURICHDialogue19() // SINGAPORE ROOT
{
	wait 2;
	
	//You know, if you defeat him you cannot return to Earth. The gateway is sealed, you're trapped here.
	bonuszmsound::BZM_PlayDolosVox( "dolo_you_know_if_you_def_0" );	
	
	//You don't say.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_you_don_t_say_0" );		

	wait 3;

	//You body died on Earth, even if you wished to return for death you couldn't...
	bonuszmsound::BZM_PlayDolosVox( "dolo_you_body_died_on_ear_0" );			
	
	//Five years ago I had the chance to stop Deimos and failed. He brought Armageddon to Earth because of me. (beat) He's right. That does haunt me. But you've given me a second chance to kill the fucker.  (beat) If the price of killing Deimos is damnation in this infernal place... I'll pay it gladly.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_five_years_ago_i_had_0" );		
	
	wait 1;
	
	//Girl after my own heart...
	bonuszmsound::BZM_PlayDolosVox( "dolo_girl_after_my_own_he_0" );			
}

function BZM_ZURICHDialogue20() // MH/CORVUS
{
	wait 2;

	//Deimos did exactly as I had hoped. We've been fighting for eons, I knew given the chance he'd turn all of humanity into his army.
	bonuszmsound::BZM_PlayDolosVox( "dolo_deimos_did_exactly_a_0" );			
	
	wait 3;
	
	//But to enslave humanity he had to reopen the gateway, only then could I take him home.   (beat) Deimos needed a human sacrifice,  just as the test subjects were sacrificed to open the gateway in Coalescence, he'd need a blood offering.
	bonuszmsound::BZM_PlayDolosVox( "dolo_but_to_enslave_human_0" );
	
	wait 2;
	
	//You know he is not wrong. You are strong, stronger than any human I've seen.
	bonuszmsound::BZM_PlayDolosVox( "dolo_you_know_he_is_not_w_0" );
	
	wait 3;	
	
	//You force yourself to carry the weight of the world. You use it, it motivates you. You're driven by the need to do better. To improve on what you once were.
	bonuszmsound::BZM_PlayDolosVox( "dolo_you_force_yourself_t_0" );
	
	wait 1;
	
	//Which is what humanity should be, isn't it? The drive to do better? To be better?  (beat) You seem fated to failure, why not choose to succeed?
	bonuszmsound::BZM_PlayDolosVox( "dolo_which_is_what_humani_0" );
	
	wait 3;
	
	//I won't let you do this! This isn't over!
	bonuszmsound::BZM_PlayDeimosVox( "deim_i_won_t_let_you_do_t_0" );	
	
	wait 1;
	
	//She's burned your hearts, you're already weakening. Once she destroys your soul it will be complete.
	bonuszmsound::BZM_PlayDolosVox( "dolo_she_s_burned_your_he_0" );
	
	//You think I will let you do that??
	bonuszmsound::BZM_PlayDeimosVox( "deim_you_think_i_will_let_0" );	
	
	//What choice do you have, Deimos? This is the world you've made for yourself.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_what_choice_do_you_h_0" );		
	
	wait 3;
	
	//I'll kill you, I cannot be defeated. I won't be undone --I cannot be undone!!
	bonuszmsound::BZM_PlayDeimosVox( "deim_i_ll_kill_you_i_can_0" );	

}

function BZM_ZURICHDialogue21()
{
	
}

function BZM_ZURICHDialogue22() // AI NEST
{
	wait 4;
	
	//Why do you fight?
	bonuszmsound::BZM_PlayDeimosVox( "deim_why_do_you_fight_0" );	
	
	wait 4;
	
	//This is it. The manifestation. This is how you see his soul.
	bonuszmsound::BZM_PlayDolosVox( "dolo_this_is_it_the_mani_0" );
	
	wait 5;
	
	//You fool. That it would be so easy. I shall enjoying tearing you in two...
	bonuszmsound::BZM_PlayDeimosVox( "deim_you_fool_that_it_wo_0" );	
	
	wait 2;
		
	//GET AWAY FROM HER!!
	bonuszmsound::BZM_PlayDolosVox( "dolo_get_away_from_her_0" );	
	
	wait 3;
	
	//I'll hold him! This is your chance! Let's see what your made of! Let's see what a mortal can do!!
	bonuszmsound::BZM_PlayDolosVox( "dolo_i_ll_hold_him_this_0" );	
	
	wait 1;
	
	//DO IT! KILL HIM!
	bonuszmsound::BZM_PlayDolosVox( "dolo_do_it_kill_him_0" );

	//NO! The throne is mine! I am DEIMOS! DEMIGOD OF DREAD AND TERROR!
	bonuszmsound::BZM_PlayDeimosVox( "deim_no_the_throne_is_mi_0" );		
	
	wait 1;
	
	//Oh yeah? How's this for fucking horrifying?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_oh_yeah_how_s_this_0" );			
}

function BZM_ZURICHDialogue23() // INT. SERVER ROOM. COALESCENCE HQ.
{
	wait 2;
	
	//Wait... this is Earth. This is Zurich. You said I couldn't come back...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_wait_this_is_eart_0" );			
	
	//Don't be fooled by what you're seeing, you're still on Malum.
	bonuszmsound::BZM_PlayDolosVox( "dolo_don_t_be_fooled_by_w_0" );
	
	wait 2;
	
	//But... it looks so real.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_but_it_looks_so_r_0" );	

	//We wouldn't be very good demigods if we weren't able to manipulate mortals, would we?
	bonuszmsound::BZM_PlayDolosVox( "dolo_we_wouldn_t_be_very_0" );	
	
	wait 2;
	
	//They're coming for you. And for me.
	bonuszmsound::BZM_PlayDolosVox( "dolo_they_re_coming_for_y_0" );	
	
	//Who is?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_who_is_0" );	
}

function BZM_ZURICHDialogue24() // THE PLAZA
{
	wait 2;
	
	//My brothers. My sisters. Demigods, sirens, titans, seers, deities of all shapes and sizes.  (beat) We just killed Deimos, heir to the throne. We've thrown Malum into anarchy. New allies and adversaries will form, but friend or foe alike everyone will want our, your, head.
	bonuszmsound::BZM_PlayDolosVox( "dolo_my_brothers_my_sist_0" );	
	
	wait 1;
	
	//Let them come.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_let_them_come_0" );	
	
	wait 4;
	
	//Oh yeah? And what are you gonna do about it?
	bonuszmsound::BZM_PlayDolosVox( "plyz_let_them_come_0" );	
	
	wait 1;
	
	//I died once. A demigod told me it was fate, fate brought me to him. Gotta be honest, fate's kinda fucked me over so far. (beat) So right now I'm gonna give fate the finger and outlive the dead.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_died_once_a_demig_0" );	
	
	//I like the enthusiasm. So... what's next?
	bonuszmsound::BZM_PlayDolosVox( "dolo_i_like_the_enthusias_0" );	
	
	wait 4;
	
	//We kill every last one of these motherfuckers.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_kill_every_last_o_0" );	
}