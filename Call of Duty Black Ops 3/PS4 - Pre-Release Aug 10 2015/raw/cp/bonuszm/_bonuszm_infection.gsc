#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;

#using scripts\cp\bonuszm\_bonuszm;
#using scripts\cp\bonuszm\_bonuszm_sound;
#using scripts\cp\_dialog;
#using scripts\cp\_util;

// INFECTION VOX
#using scripts\cp\voice\voice_z_infection;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	

function autoexec Init()
{
	if( !( SessionModeIsCampaignZombiesGame() ) )
		return;
	
	mapname = GetDvarString( "mapname" );
	
	if( !IsSubstr( mapname, "infection" ) )
		return;
		
	level.riser_type = "snow";
	
	voice_z_infection::init_voice();	
		
	level.BZM_INFECTIONDialogue1Callback	= &BZM_INFECTIONDialogue1; // BONUSZM_INFECTION_DLG1
	level.BZM_INFECTIONDialogue2Callback	= &BZM_INFECTIONDialogue2; // BONUSZM_INFECTION_DLG2
	level.BZM_INFECTIONDialogue3Callback	= &BZM_INFECTIONDialogue3; // BONUSZM_INFECTION_DLG3
	level.BZM_INFECTIONDialogue4Callback	= &BZM_INFECTIONDialogue4; // BONUSZM_INFECTION_DLG4
	level.BZM_INFECTIONDialogue5Callback	= &BZM_INFECTIONDialogue5; // BONUSZM_INFECTION_DLG5
	level.BZM_INFECTIONDialogue6Callback	= &BZM_INFECTIONDialogue6; // BONUSZM_INFECTION_DLG6
	level.BZM_INFECTIONDialogue7Callback	= &BZM_INFECTIONDialogue7; // BONUSZM_INFECTION_DLG7
	level.BZM_INFECTIONDialogue8Callback	= &BZM_INFECTIONDialogue8; // BONUSZM_INFECTION_DLG8
	level.BZM_INFECTIONDialogue9Callback	= &BZM_INFECTIONDialogue9; // BONUSZM_INFECTION_DLG9
	level.BZM_INFECTIONDialogue10Callback	= &BZM_INFECTIONDialogue10; // BONUSZM_INFECTION_DLG10
	level.BZM_INFECTIONDialogue11Callback	= &BZM_INFECTIONDialogue11; // BONUSZM_INFECTION_DLG11
	level.BZM_INFECTIONDialogue12Callback	= &BZM_INFECTIONDialogue12; // BONUSZM_INFECTION_DLG12
	level.BZM_INFECTIONDialogue13Callback	= &BZM_INFECTIONDialogue13; // BONUSZM_INFECTION_DLG13
	level.BZM_INFECTIONDialogue14Callback	= &BZM_INFECTIONDialogue14; // BONUSZM_INFECTION_DLG14
	level.BZM_INFECTIONDialogue15Callback	= &BZM_INFECTIONDialogue15; // BONUSZM_INFECTION_DLG15
	level.BZM_INFECTIONDialogue16Callback	= &BZM_INFECTIONDialogue16; // BONUSZM_INFECTION_DLG16
	level.BZM_INFECTIONDialogue17Callback	= &BZM_INFECTIONDialogue17; // BONUSZM_INFECTION_DLG17
	level.BZM_INFECTIONDialogue18Callback	= &BZM_INFECTIONDialogue18; // BONUSZM_INFECTION_DLG18
	level.BZM_INFECTIONDialogue19Callback	= &BZM_INFECTIONDialogue19; // BONUSZM_INFECTION_DLG19
	level.BZM_INFECTIONDialogue20Callback	= &BZM_INFECTIONDialogue20; // BONUSZM_INFECTION_DLG20
	level.BZM_INFECTIONDialogue21Callback	= &BZM_INFECTIONDialogue21; // BONUSZM_INFECTION_DLG21
	level.BZM_INFECTIONDialogue22Callback	= &BZM_INFECTIONDialogue22; // BONUSZM_INFECTION_DLG22
}

function BZM_INFECTIONDialogue1() // INTRO IGC
{
	wait 1;
	
	//Deimos' was going to open the gateway. He needed the demons of Malum to enslave Earth for the battle against Dolos. (beat) How he would do it we hadn't a clue. But we had Sarah Hall, her signal tracing to Kebechet.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_deimos_was_going_to_0" );
	
	//It wasn't odd that her signal appeared?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_it_wasn_t_odd_that_h_0" );
		
	//There wasn't time to think about it, but if we could get her we could find Taylor, we could decipher Deimos' plan.  (beat) We had no idea we were being baited for a trap.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_there_wasn_t_time_to_0" );
	
	//Had you known, would you still have gone?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_had_you_known_would_0" );
	
	//It's gotten me this far, hasn't it? But first we had to find Hall. (ironic) Lucky for us, she found us first.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_it_s_gotten_me_this_0" );
	
	level flag::wait_till( "player_exiting_downed_vtol" );
	
	//She was waiting, she knew we were coming...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_she_was_waiting_she_0" );
	
	wait 3;
	
	//Deimos was using Taylor to open the gates of Malum.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_deimos_was_using_tay_0" );	
	
	//If we were gonna find him, we needed to take Hall down and interface with her.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_if_we_were_gonna_fin_0" );
}

function BZM_INFECTIONDialogue2() // IGC - INTERFACE WITH THIEA’S DNI
{
	wait 4;
	//I'd interfaced with people before, I knew how this worked. It's a memory retrieval, an info dump, a lethal procedure...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_d_interfaced_with_0" );
	
	//But this was different, she begged me to do it. People don't beg to die.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_but_this_was_differe_0" );
		
	//There was no time to debate it with Hendricks, we needed to find Taylor.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_there_was_no_time_to_0" );
	
	//We needed to get answers.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_needed_to_get_ans_0" );
}

function BZM_INFECTIONDialogue3() // BIRTH OF THE AI
{
	wait 4;
	
	//What happened when you interfaced with her?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_happened_when_y_2" );
	
	//Interfacing with someone is opening a portal to their mind, a window to their darkest thoughts and desires. But this... this was her deep subconscious. This wasn't what was supposed to happen.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_interfacing_with_som_0" );
	
	//Because the deep subconscious is more than that. It's the gateway, the portal... to Malum.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_because_the_deep_sub_0" );
	
	//But how? How is that possible?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_but_how_how_is_that_0" );
	
	//The Human subconscious hides your fears, your doubts, it's the most primal version of yourself. It hides what you run away from. By running from your subconscious you persevere in life. But to embrace it...  (malevolent) How do you think I opened the gateway?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_the_human_subconscio_0" );
	
	//But... but you said to open the gateway I needed to relive my memories.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_but_but_you_said_0" );
	
	//No. I told you to take me to the start of your journey. The journey into the depths of your fears. You chose to relive your memories.  (beat) So tell me, what do you fear?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_no_i_told_you_to_ta_0" );
	
	while( !level flag::exists( "baby_picked_up" ) )
	{
		wait 1;
	}
	
	level flag::wait_till( "baby_picked_up" );

	//Please. Why are you doing this?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_please_why_are_you_0" );
		
	//Why are you lying to me, scrambling my mind? Don't make me do this.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_why_are_you_lying_to_0" );
	
	//I'm afraid you don't have a choice. You haven't had a choice since you picked up that baby, since you embraced Sarah's fear... and let your own grip hold.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_i_m_afraid_you_don_t_0" );
	
	//Lead me to the depths of fear. What did Sarah want you to see?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_lead_me_to_the_depth_0" );
}

function BZM_INFECTIONDialogue4() // INT. TESTING LAB. SP/CORVUS
{
	//Project Corvus. 2060, the day of the Coalescence disaster.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_project_corvus_2060_0" );
			
	//Sarah... she told me she could feel Deimos coursing through her veins, her mind, the fabrics of her soul.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_sarah_she_told_me_0" );
		
	//He knew everything about her... and she knew everything about him.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_knew_everything_a_0" );
		
	//She learned the Coalescence Disaster wasn't an accident, but that means...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_she_learned_the_coal_0" );
	
	//Well, I did what had to be done. This new cold war was tearing us apart, the Winslow Accord and Common Defense Pact had split the world in two.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_well_i_did_what_had_0" );
	
	//I ssaw humanity destroy itself.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_i_ssaw_humanity_dest_0" );
	
	//But in the lab I saw... I saw truth. I saw peace, the cure for the common man: Malum.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_but_in_the_lab_i_saw_0" );
	
	//I saw a way to unite them against an enemy greater than themselves.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_i_saw_a_way_to_unite_0" );
	
	//I saw Deimos.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_i_saw_deimos_0" );
		
	//You. You did this. You opened the gateway. You brought Deimos here.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_you_you_did_this_y_0" );
	
	//I brought mankind's Savior here.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_i_brought_mankind_s_0" );	
}

function BZM_INFECTIONDialogue5() // PROMETHEUS INFECTION
{
	wait 5;
	
	//Taylor's team were responding to a disturbance in Coalescence.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_taylor_s_team_were_r_0" );
	
	//After many years, I realized opening the portal was not enough. With Deimos trapped in the server room, Man had not yielded like I'd hoped. I had to incentivize progress.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_after_many_years_i_0" );
	
	//You. You created the disturbance that sent Taylor's team there.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_you_you_created_the_0" );
	
	//Well, his undead servants could only do so much. Humans with DNI... well, they could be used to let Deimos walk the Earth.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_well_his_undead_ser_0" );
}

function BZM_INFECTIONDialogue6() // SARAH - FPC #2
{
	wait 1;
	//Hall told me she had no idea what they were getting into, but they had to follow standard operating procedure, which meant locking down the site...  (realizing) And interfacing with the locations primary systems in the server room below...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_hall_told_me_she_had_0" );
	
	//We... we were built to be invincible. We had our DNI so we could interface with systems in dangerous environments and upload the information.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_we_were_built_0" );
	
	//We created the very opportunity for Deimos to leave the server room.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_created_the_very_0" );
	
	//He was a prisoner, confined to the room with no way to expand humanity's horizon.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_he_was_a_prisoner_c_0" );	
		
	//We were vehicles for his transportation.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_were_vehicles_for_0" );
	
	//That makes it sound so cold, this is for the good of humanity.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_that_makes_it_sound_0" );
}

function BZM_INFECTIONDialogue7() // BASTOGNE
{
	wait 6;
	
	//Tell me... what did Sarah fear?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_tell_me_what_did_0" );
	
	//Failure. When she was at the academy she studied the battles of World War 2 religiously. The bravery of these men, with their primitive weaponry, it frightened her. She feared she could never match their heroism. She didn't have real courage, she ran from it. (beat) She had nightmares of this place, Bastogne. As she entered her subconscious she gave into the fear, let it drive her, pull her away...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_failure_when_she_wa_0" );
		
	//We didn't know how, but we had to save her. We followed.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_didn_t_know_how_0" );	
}

function BZM_INFECTIONDialogue8() // WORLD FALLS AWAY
{
	//The world began to fall apart, we heard his voice. Deimos.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_world_began_to_f_0" );	
	
	//What did he say?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_did_he_say_1" );
	
	wait 4;
	
	//Sarah... listen to the sound of my voice, follow it. I will have my army. I will have my kingdom. All that remains is her sacrifice.
	bonuszmsound::BZM_PlayDeimosVox( "deim_sarah_listen_to_t_0" );	
	
	//He... he was trying to consume her. And he wasn't about to let me stop him.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_he_was_trying_0" );	
	
	//Her mind was fracturing, stretched between our dimension and his. She warned me to turn back... to let Deimos take her.  (beat) I told her I'd stay with her, I'd see it to the end. I asked her what happened after Coalescence.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_her_mind_was_fractur_0" );	
	
	//You were deep within her subconscious, at the threshold of another dimension. You seemed to embrace this journey.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_you_were_deep_within_0" );
	
	//You think I wasn't scared? I was terrified. There was no way to make up for what I had done, but I had to try...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_you_think_i_wasn_t_s_0" );	
}

function BZM_INFECTIONDialogue9() // SARAH - FPC #3
{
	wait 0.5;
	
	//From the moment she was possessed Hall became a passenger in her own body, a witness to Deimos using her for his purposes.  (beat) He wanted them to go to the Black Station. He... he wanted to find you, to meet the man who'd given him his freedom.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_from_the_moment_she_0" );	
}

function BZM_INFECTIONDialogue10() // BLACK STATION
{
	wait 8;
	
	//He slaughtered the staff, ravaged them.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_slaughtered_the_s_0" );	
	
	wait 2;
	
	//Why did he kill them?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_why_did_he_kill_them_0" );	
	
	//The documentation of his existence. It was not time for his big reveal, his final masterpiece.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_the_documentation_of_0" );
	
	//He was angry. The data drives were encrypted -- and part of it was missing. He couldn't purge the information.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_he_was_angry_the_da_0" );
	
	wait 1;
	
	//The piece Hendricks and I recovered from the docks, someone had hidden them from him. Someone knew he would come. (beat) Someone was trying to stop him.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_piece_hendricks_0" );	
	
	wait 2;
	
	//Deimos didn't want Sarah divulging his secrets to us either, he ripped  us from that memory...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_deimos_didn_t_want_s_0" );
}

function BZM_INFECTIONDialogue11() // FOY
{
	wait 7;

	//We were in Foy. I saw more than fear in Sarah's eyes, I saw admiration. The longer I stayed, the stronger she became... the more she believed she could escape.	
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_were_in_foy_i_sa_0" );
	
	//She told me to follow her, there was something she wanted me to see.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_she_told_me_to_follo_0" );
}

function BZM_INFECTIONDialogue12() // FOLD
{
	wait 12;
	//There was a chapel ahead of us, Hall told me to follow her there.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_there_was_a_chapel_a_0" );	
}

function BZM_INFECTIONDialogue13() // DRAGGED UNDERWATER
{
	//You're insane.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_you_re_insane_0" );	
	
	//No. I told you before, Humanity is insane. (beat) You asked her to help you find Taylor.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_no_i_told_you_befor_0" );	
	
	//He needed Taylor to open the gateway. I wanted to know how. I wanted to know what was Deimos planning.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_needed_taylor_to_0" );	
	
	//Where did she take you next?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_where_did_she_take_y_0" );		
}

function BZM_INFECTIONDialogue14() // FPC #4 (LEVEL SPLIT)
{
	//The Aquifers. Their Fortress in the Sand. This was their FOB for years.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_aquifers_their_0" );	
	
	wait 2;
	
	//Deimos couldn't access the  intelligence at the Singapore Black Station, he couldn't locate you... so they hid for years, waiting for their moment. They'd scour the continent looking for you...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_deimos_couldn_t_acce_0" );		
}

function BZM_INFECTIONDialogue15() // HIDEOUT
{
	wait 3;
	
	//There's something I don't understand. You made this happen, you've pushed for the annihilation of Earth.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_there_s_something_i_0" );

	//I have pushed for the salvation of Earth.	
	bonuszmsound::BZM_PlayDrSalimVox( "salm_i_have_pushed_for_th_0" );
	
	wait 4;
	
	//But... Deimos wasn't using you. You weren't a puppet of his when you did all this.  (beat) What's in this for you? Why are you doing this? Are you a Cotardist? An Undead Sympathizer?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_but_deimos_wasn_t_0" );
	
	//No, my child, Dr. Salim was not an undead sympathizer. He was so much less than that. He was so much more insiqnificant than that.	
	bonuszmsound::BZM_PlayDrSalimVox( "salm_no_my_child_dr_sa_0" );
	
	//...was? Wait, what do you mean was?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_was_wait_what_d_0" );
}

function BZM_INFECTIONDialogue16()
{
	wait 2;
	
	//I must say, I'm impressed with how delusional you've become, you had completely forgotten this. The mind is a strange thing, no?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_i_must_say_i_m_impr_0" );
	
	//They found you, they tortured you for information. But... You were an ally, you enabled him, freed him...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_they_found_you_they_0" );
	
	//You humans, even when faced with extinction, faced with the truth... you don't fight to live, you fight to live in denial.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_you_humans_even_whe_0" );
	
	//Dr. Salim was no ally, how could a mere mortal be? He was a tool, an instrument I enabled.  (disgusted) He was a blind idealist, believing he could make the world a better place, that I could save humanity, that he could save humanity.  (SCOFFS) He thought I'd found him to thank him. Me. A God. Thank a Mortal? I found him to seize power from him.  (offended) Humans... with your arrogance and ineptitude you'll never fully realize the expansive infinity of their own universe and your insignificant place in it.
	bonuszmsound::BZM_PlayDeimosVox( "deim_dr_salim_was_no_all_0" );	
	
	//No...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_no_1" );
	
	//Even now you still hide from the truth. CORVUS had been destroyed in Singapore, I needed it to open the gateway. That was why I had kept Salim alive. He worked with a colleague, Krueger, and they built me a new CORVUS at Coalescence Headquarters in Zurich. The gateway was the door. All I needed was the right key.
	bonuszmsound::BZM_PlayDeimosVox( "deim_even_now_you_still_h_0" );	
	
	//The new Corvus, in Zurich, you'd use it to open the Gateway. You'd learned that it was nearly complete.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_new_corvus_in_z_0" );
	
	//So I had no further need for the Doctor.
	bonuszmsound::BZM_PlayDeimosVox( "deim_so_i_had_no_further_0" );	
}

function BZM_INFECTIONDialogue17()
{
	wait 0.5;
	
	//Look at how she struggles even now. She knew what was coming. For that matter so did you.
	bonuszmsound::BZM_PlayDeimosVox( "deim_look_at_how_she_stru_0" );

	//All that remained was her sacrifice, for her to join my ranks and face eternal damnation under my command...  (beat) I am humanity's salvation, a savior giving purpose to a lost species that deserves far less.  (imposing) I. am. Deimos.
	bonuszmsound::BZM_PlayDeimosVox( "deim_all_that_remained_wa_0" );
}

function BZM_INFECTIONDialogue18() // STALINGRAD CREATION
{
	wait 1;
	
	//The tree, I've seen it before... the entrance to Malum.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_tree_i_ve_seen_0" );
	
	//Tell me. What do you fear? You don't fear the undead, you've proven quite able against them. You throw yourself into fights that would kill the average man as if you have a death wish. As if you were trying to escape something. Is it failure? Is it life? (beat) No... you fear your mistakes, your past actions. Your greatest fear is the memories that haunt you.
	bonuszmsound::BZM_PlayDeimosVox( "deim_tell_me_what_do_you_0" );
		
	//But you wouldn't let me have her.
	bonuszmsound::BZM_PlayDeimosVox( "deim_but_you_wouldn_t_let_0" );
	
	//You awaited her sacrifice, she wanted me to stop you. She wanted me to end it. To deny you her offering.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_you_awaited_her_sacr_0" );
	
	//If she offered herself... she'd give you want you wanted. The only way to deny it was for me to kill her.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_if_she_offered_herse_0" );
}

function BZM_INFECTIONDialogue19() // NUKE
{
	//You denied me my prize. It was time for you to return to the world of the living dead.  (beat) You must know how this ends. (beat) This ends... with your sacrifice.	
	bonuszmsound::BZM_PlayDeimosVox( "deim_you_denied_me_my_pri_0" );
}

function BZM_INFECTIONDialogue20() // OUTRO IGC
{
	wait 1;
	
	//But now I had you. I passed from Hall's mind to your own. Slowly... I would work my way through you.	
	bonuszmsound::BZM_PlayDeimosVox( "deim_but_now_i_had_you_i_0" );
	
	wait 4;
	
	//What did Kane tell you?
	bonuszmsound::BZM_PlayDeimosVox( "deim_what_did_kane_tell_y_0" );
	
	//They located Taylor. He was being held at Lotus Towers, run by a man named Hakim, a Cotardist, an Undead-Sympathizer who would get you out of Cairo. (beat) I told Kane we had to hurry. We had to hurry if we were going to stop you. (beat) ...but there was something we needed to know. The data drives, how did Kane know they were split up. Was she the one who separated the drives? Why?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_they_located_taylor_0" );
	
	wait 1;
	
	//She said there was much we didn't know, but we would in time... we had to trust her. We had to get to Lotus Towers.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_she_said_there_was_m_0" );
}

function BZM_INFECTIONDialogue21() // SARAH - FPC #1 (LEVEL SPLIT)
{
	wait 5;
	
	//I had to find Taylor, I had to stop this. Sarah told me to turn back, she didn't want to put me in danger. I couldn't do that.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_had_to_find_taylor_0" );
	
	//She said if I wanted the truth... I had to understand what they'd done. What you'd done.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_she_said_if_i_wanted_0" );
}

function BZM_INFECTIONDialogue22() // INT CHURCH
{
	wait 2;
	//I tried to approach her--
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_tried_to_approach_0" );
	
	wait 2;	
	//Deimos had other ideas.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_deimos_had_other_ide_0" );
	
	wait 1;
	//To get to her, I had to get through whatever Deimos put in my way.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_to_get_to_her_i_had_0" );	
		
	while( !flag::exists( "cathedral_quad_tank_destroyed" ) )
	{
		wait 1;
	}
	
	level flag::wait_till( "cathedral_quad_tank_destroyed" );
	
	wait 8;
	
	//Sarah couldn't understand, she just saw how it ended -- Humans are obsessed with beginnings and endings. The journeys between, the journeys before and after become filler. Life becomes filler.  (beat) She tried to fight it, tried to fight the voice in her head that had given her the ultimate gift.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_sarah_couldn_t_under_0" );	
	
	//The ultimate gift? Deimos was controlling her.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_ultimate_gift_d_0" );	
	
	//Relinquishing control is the ultimate gift. Free of choice, free of pressure, free of consequence. Her actions were dictated for her, for greater purpose. She'd been chosen by fate, the greatest gift of all and here she fighting it. (beat) How dare you fight the voice of a God?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_relinquishing_contro_0" );	
}