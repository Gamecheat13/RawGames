#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#using scripts\cp\bonuszm\_bonuszm;
#using scripts\cp\bonuszm\_bonuszm_sound;
#using scripts\cp\_dialog;
#using scripts\cp\_util;

// RAMSES VOX
#using scripts\cp\voice\voice_z_ramses;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	

function autoexec Init()
{
	if( !( SessionModeIsCampaignZombiesGame() ) )
		return;
	
	mapname = GetDvarString( "mapname" );
	
	if( !IsSubstr( mapname, "ramses" ) )
		return;

	// Dialogue setup	
	voice_z_ramses::init_voice();	
		
	level.BZM_RAMSESDialogue1Callback	= &BZM_RAMSESDialogue1; // BONUSZM_RAMSES_DLG1
	level.BZM_RAMSESDialogue2Callback	= &BZM_RAMSESDialogue2; // BONUSZM_RAMSES_DLG2
	level.BZM_RAMSESDialogue3Callback	= &BZM_RAMSESDialogue3; // BONUSZM_RAMSES_DLG3
	level.BZM_RAMSESDialogue4Callback	= &BZM_RAMSESDialogue4; // BONUSZM_RAMSES_DLG4
	level.BZM_RAMSESDialogue5Callback	= &BZM_RAMSESDialogue5; // BONUSZM_RAMSES_DLG5
	level.BZM_RAMSESDialogue6Callback	= &BZM_RAMSESDialogue6; // BONUSZM_RAMSES_DLG6
	level.BZM_RAMSESDialogue7Callback	= &BZM_RAMSESDialogue7; // BONUSZM_RAMSES_DLG7
	level.BZM_RAMSESDialogue8Callback	= &BZM_RAMSESDialogue8; // BONUSZM_RAMSES_DLG8

	// Add ramses specific logic in the following function
	BZM_ramsesSettings();
}

function private BZM_ramsesSettings() 
{
	callback::on_spawned( &BZM_ramsesOnPlayerSpawned );	
}

function BZM_ramsesOnPlayerSpawned()
{
	self AllowDoubleJump( true );
}

function BZM_RAMSESDialogue1() // RISE AND FALL
{
	wait 6;
		//The pieces were coming together. Virus 61-15, Taylor's team, the undead, it all came back to Deimos. All we needed was you.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_pieces_were_comi_0" );
		
	wait 2;
	//Hendricks was unhinged. The idea his friends betrayed mankind to help a demigod... the concept alone was insanity, set aside his friends' involvement.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_hendricks_was_unhing_0" );
	
	wait 3;
	//Kane came with, she was in it to the end. By now Kane was as obsessed with killing Deimos as we were.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_kane_came_with_she_0" );
	
	wait 2;
	//We weren't ready for Cairo, no matter what we thought. This place... if there was ever a place that was hell on earth, this was it.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_weren_t_ready_for_0" );
	
	wait 1;	
	//It wasn't just the city, the entirety of northern Africa had fallen to the undead.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_it_wasn_t_just_the_c_0" );
		
	//Between the Flesh-eaters, rogue robotics and Human Scavengers, it was the last place on Earth you want to be. But you chose to hide there, why?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_between_the_flesh_ea_0" );
	
	//For that very reason. I hoped no one would come for me.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_for_that_very_reason_0" );
	
	//Why? What were you running from?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_why_what_were_you_r_0" );
	
	//From the creature you sought: Deimos.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_from_the_creature_yo_0" );
	
	wait 5;	
	//The walls were covered with memories of the dead, those taken by 61-15, lost to this wasteland, the desert for the undead. This didn't even take into account what the Water Wars had done.  (beat) When the continent ran out of water the Nile River Coalition was formed. They took the war to Egypt and began the battle for the Nile, the final oasis. All the while they fought and slaughtered each other, they barely realized the Nile had dried up.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_walls_were_cover_0" );
	
	wait 5;		
	//Khalil was waiting. He was holding you in an interrogation room.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_khalil_was_waiting_0" );
	
	wait 5;	
	//How was Khalil? Happy to see you?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_how_was_khalil_happ_0" );
	
	wait 2;	
	//It wasn't a warm welcome. As far as he was concerned we owed him one for grabbing you. More than a few men gave their lives to bring you in. He hoped it was worth it.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_it_wasn_t_a_warm_wel_0" );
	
	//He was angry?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_he_was_angry_0" );
	
	wait 1;	
	//He was tired. Tired of fighting a losing battle. Khalil was realist, he'd fight for his country to death, but it didn't change that he knew what was coming.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_was_tired_tired_0" );
	
	//What was coming?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_was_coming_0" );
	
	//Extinction.  (beat) The Undead changed everything. The NRC were hit first and hardest, we saw that in Ethiopia. Everyone spent years fighting over water, but how do you fight an enemy that doesn't need it?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_extinction_beat_0" );
	
	wait 2;		
	//Khalil's rage wasn't misplaced. It wasn't personal... he just was barely holding on.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_khalil_s_rage_wasn_t_0" );
	
	wait 4;
	//What did you hope to learn from speaking to me?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_did_you_hope_to_0" );
	
	wait 1;
	//How to stop Deimos. Everyone has a weakness. For as absurd as this whole thing was with other dimensions, supreme beings, an army of the undead -- not even gods are invulnerable.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_how_to_stop_deimos_0" );
	
	wait 1;
	//Kane asked what was going on, the whole base was on edge, you could feel it in the air.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_kane_asked_what_was_0" );
	
	//What was happening?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_was_happening_0" );
	
	//The dead were moving on Ramses. An assault was imminent. He didn't know how much time we had.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_dead_were_moving_0" );
	
	//That set Hendricks off. He demanded to know why we weren't informed.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_that_set_hendricks_o_0" );
	
	//How did Khalil respond?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_how_did_khalil_respo_0" );
	
	//WA Command was down, how was he meant to get his message through? (beat) Besides, they still had the DEAD system. Before the flesh-eaters roamed the earth they'd been used to knock enemy aircraft out of the sky. Now they were used to eviscerate the undead. If any came close the laser cannons would take them out.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_wa_command_was_down_0" );
	
	wait 5;	
	//Khalil led us to interrogation. He warned us our time was limited, there was no telling when the dead might attack.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_khalil_led_us_to_int_0" );
	
	wait 2;	
	//But if we could get answers out of you... maybe we could find a new way to fight back.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_but_if_we_could_get_0" );
}

function BZM_RAMSESDialogue2() // INTERVIEW DR. SALIM IGC
{
	wait 1;
	
	//You certainly weren't too happy to see us.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_you_certainly_weren_0" );
	
	//You say it like I had a choice in the matter.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_you_say_it_like_i_ha_0" );
		
	//With no time, we needed you to be willing to talk...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_with_no_time_we_nee_0" );
	
	//...the truth serum would make you relax, more willing to divulge. Hendricks told us to take a walk.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_truth_serum_w_0" );
	
	wait 4;
	
	//He asked about Taylor and Deimos, he wanted you to connect the dots.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_asked_about_taylo_0" );
	
	//And I told him, as I'm telling you now, Deimos controlled them. Your friend Bishop was correct, there was a 'Brain' manipulating the undead. It was Deimos. However, Deimos realized by accessing a person's DNI he didn't need to change them. He could possess them. Inhabit them.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_and_i_told_him_as_i_0" );
	
	//Like puppets on strings.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_like_puppets_on_stri_0" );
	
	//The undead are mindless creatures. But Taylor's team, Goh Xiulan, anyone with DNI... they could be hosts. They were his slaves.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_the_undead_are_mindl_0" );
	
	//Hendricks wanted to know why. We both did.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_hendricks_wanted_to_0" );
		
	//For many years I had studied Deimos and his dimension, Malum, a place of unspeakable evil.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_for_many_years_i_had_0" );
	
	//But he had been pulled to Earth, yanked from his existence by an accident. Trapped here, he saw opportunity: to enslave humanity and use them to wage an unholy war against Dolos.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_but_he_had_been_pull_0" );
	
	//The demigoddess. His sister. (realizing) We... we were being used. Humanity's legacy had been boiled down to a chess piece.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_demigoddess_his_0" );
		
	//A pawn in a much larger game in a universe far bigger than you realize. Humanity is anthill. Deimos and Dolos are two children fighting over the magnifying glass. (beat) But Hendricks, was desperate. He wanted to know how to kill Deimos.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_a_pawn_in_a_much_lar_0" );
	
	wait 1;
	
	//You... you told him he couldn't.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_you_you_told_him_0" );
	
	//How does one kill a god? You can't. The only way to defeat him, the only way to sever his control over the undead, the only way for Professor Bishop's serum to work, to reverse the effects of 61-15 and save humanity--
	bonuszmsound::BZM_PlayDrSalimVox( "salm_how_does_one_kill_a_0" );
	
	//Was to send him back to Malum.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_was_to_send_him_back_0" );

	//Exactly. And the only way to send him back...	
	bonuszmsound::BZM_PlayDrSalimVox( "salm_exactly_and_the_onl_0" );
	
	//...is to open the gateway.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_is_to_open_the_ga_0" );

	//As we are doing now, by walking through your memories.	
	bonuszmsound::BZM_PlayDrSalimVox( "salm_as_we_are_doing_now_0" );
		
	//But Hendricks... Hendricks was not happy with this answer.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_but_hendricks_hen_0" );
	
	//And as it was, he was out of time.
	bonuszmsound::BZM_PlayPlayerVox( "hend_and_as_it_was_he_wa_0" );	
}

function BZM_RAMSESDialogue3() // INT. SIDE ATRIUM - RAMSES STATION
{
	wait 13;
	
	//The assault on Ramses was beginning.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_assault_on_ramse_0" );	
	
	wait 0;
	
	//We didn't have time to finish. The base was about to be overrun -- and we owed Khalil that favor. (beat) Time to take the fight to the dead.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_didn_t_have_time_0" );	
}

function BZM_RAMSESDialogue4() // GET TO THE TRUCK VIGNETTE
{
	wait 4;

	//The dead were moving on the Eastern Checkpoint, Khalil told us to follow him.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_dead_were_moving_1" );	
	
	wait 1;
	
	//He didn't say it, but I could hear it in his voice: Khalil knew this was the last stand. If they lost this battle they'd lose the city. (beat) We followed him.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_didn_t_say_it_bu_0" );	
}

function BZM_RAMSESDialogue5() // INT. TRUCK - CITY STREET
{
	wait 2;
	
	//It was a simple, straight forward plan, except--
	bonuszmsound::BZM_PlayPlayerVox( "plyz_it_was_a_simple_str_0" );	
		
	//Something knocked our VTOL out of the sky and the mobile blockade fell early.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_something_knocked_ou_0" );	
	
	wait 1;
	
	//Turns out it wasn't just the undead gunning for us.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_turns_out_it_wasn_t_0" );	
	
	//Cairo was no man's land, filled with the undead, rogue robotics, and scavengers -- they were all converging on our position. (beat) Khalil was livid--
	bonuszmsound::BZM_PlayPlayerVox( "plyz_cairo_was_no_man_s_l_0" );

	//I put him in his place, if we were gonna pull this off we didn't have time to fuck around.  (beat) I grabbed the Spike Launcher and told Kane at HQ to locate the support columns.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_put_him_in_his_pla_0" );	
}

function BZM_RAMSESDialogue6() // DETONATE
{
	wait 2;
	//Our triggerman got hit. I had to get up there and detonate.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_our_triggerman_got_h_0" );	
	
	level flag::wait_till( "arena_defend_detonator_pickup" );

	wait 5;
	//I told Hendricks I needed a moment--
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_told_hendricks_i_n_0" );	
	
	wait 8;
	//Good thing Hendricks still had our back.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_good_thing_hendricks_0" );	
	
	wait 26;
	
	//Khalil thanked us... he thought they still had a chance...  (pained) They had no idea what was about to happen.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_khalil_thanked_us_0" );
	
	wait 6;
	
	//Egyptian Army command came over the comms, a scavenger had blown a hole through Safiya Square and the Undead were pouring through, headed for Ramses. (beat) I told Khalil we'd take care of the Square.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_egyptian_army_comman_0" );
}

function BZM_RAMSESDialogue7() // VTOL IGC
{
	wait 2;	
	//I heard screams from the downed VTOL ahead, there was someone still alive.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_heard_screams_from_0" );
	
	//I gave Hendricks a hand with opening the hatch.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_gave_hendricks_a_h_0" );

	wait 2;

	//You went in to save this man? The odds of his survival could not have been great. You yourself said death was coming.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_you_went_in_to_save_0" );
	
	//Does that matter?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_does_that_matter_0" );
	
	//There were so few of us left, if there was a chance, any chance...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_there_were_so_few_of_0" );
	
	//I'd take it.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_d_take_it_0" );
	
	wait 2;	
	//He pulled his piece on us, he thought we were undead. I talked him down.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_pulled_his_piece_0" );

	wait 5;
	//Strange... even with all odds stacked against you, you tried to help this man.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_strange_even_with_0" );
	
	wait 4;		
	//He clung to life without hope and still you tried to save him.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_he_clung_to_life_wit_0" );
	
	wait 2;
	//Turns out it didn't matter.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_turns_out_it_didn_t_0" );
	
	wait 20;
	//He didn't survive the fall. It would only be a matter of time before he turned and joined the horde.  (beat) But there was no time to stop and mourn. If I did that I'd end up joining him. And we weren't going down just yet.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_didn_t_survive_th_0" );	
}

function BZM_RAMSESDialogue8() // END IGC - EXT. SAFIYA SQUARE
{
	//We'd cleared the plaza, but something was wrong... I could hear it.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_d_cleared_the_pla_0" );	
	
	wait 2;
	//What did you hear?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_did_you_hear_1" );
	
	//Nothing. And that was the problem. (beat) It took us a moment to realize what had happened.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_nothing_and_that_wa_0" );
	
	wait 1;	
	//Something had taken out the DEAD system. One of the scavengers, maybe a malfunctioning biped.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_something_had_taken_0" );
	
	//We saw reinforcements fly in, but from it was too late. The Undead were taking Ramses.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_saw_reinforcement_0" );
		
	//Khalil tried to reach Egyptian Command, all we heard were screams. The city was falling.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_khalil_tried_to_reac_0" );
	
	wait 5;
	//And there it was. That look of defeat. Anger. Frustration. Hope was gone. You can try to sympathize, you can try to comfort, it doesn't make a difference.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_and_there_it_was_th_0" );
		
	//Kane came over comms, she'd picked up the location of Sarah Hall, another of Taylor's team.  (beat) Her signal popped back up on the grid. We had traced her to Kebechet, the sandy ruins of Cairo's Garden City.  (beat) I told Khalil if there was a sliver of hope, we needed to catch Hall and find Taylor. If we did that, if we found Deimos and found a way to send him back to Malum, we could undo all of this.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_kane_came_over_comms_0" );
	
	//Khalil agreed to come with us.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_khalil_agreed_to_com_0" );
	
	//And Hendricks?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_and_hendricks_0" );
	
	wait 1;
	
	//His mind was melting, breaking. I still had no idea what was sparking his anger, his outrage. He didn't want to go after Hall. I said he didn't have a say in the matter.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_his_mind_was_melting_0" );
	
	//He didn't like that.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_didn_t_like_that_0" );
	
	wait 1;
	
	//He attacked you?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_he_attacked_you_0" );
	
	//I told you, it wasn't him. It was that look in his eyes. Like Goh Xiulan. Like Maretti. Like Diaz.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_told_you_it_wasn_0" );
	
	wait 2;
	
	//But for a moment his eyes cleared. He saw clarity. And I saw him.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_but_for_a_moment_his_0" );
	
	//What did he say?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_did_he_say_0" );
	
	//Salim... lies.
	bonuszmsound::BZM_PlayDolosVox( "dolo_salim_lies_0" );
	
	//He didn't think opening the portal would save us, it would destroy us. The last time it opened evil came through, why would this time be different? (beat) He said Deimos was trying to trick us. He said you were lying to us.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_didn_t_think_open_0" );
	
	//...are you?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_are_you_0" );
}