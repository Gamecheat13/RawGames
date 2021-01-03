#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

#using scripts\cp\bonuszm\_bonuszm;
#using scripts\cp\bonuszm\_bonuszm_sound;
#using scripts\cp\_dialog;
#using scripts\cp\_util;

// SGEN VOX
#using scripts\cp\voice\voice_z_hypocenter;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	

function autoexec Init()
{
	if( !( SessionModeIsCampaignZombiesGame() ) )
		return;
	
	mapname = GetDvarString( "mapname" );
	
	if( mapname == "cp_mi_sing_sgen" )
	{
		voice_z_hypocenter::init_voice();	
		
		level.BZM_SGENDialogue1Callback	= &BZM_SGENDialogue1; // BONUSZM_SGEN_DLG1
		level.BZM_SGENDialogue2Callback	= &BZM_SGENDialogue2; // BONUSZM_SGEN_DLG2
		level.BZM_SGENDialogue3Callback	= &BZM_SGENDialogue3; // BONUSZM_SGEN_DLG3
		level.BZM_SGENDialogue4Callback	= &BZM_SGENDialogue4; // BONUSZM_SGEN_DLG4
		level.BZM_SGENDialogue5Callback	= &BZM_SGENDialogue5; // BONUSZM_SGEN_DLG5
		level.BZM_SGENDialogue6Callback	= &BZM_SGENDialogue6; // BONUSZM_SGEN_DLG6
		level.BZM_SGENDialogue7Callback	= &BZM_SGENDialogue7; // BONUSZM_SGEN_DLG7
		level.BZM_SGENDialogue8Callback	= &BZM_SGENDialogue8; // BONUSZM_SGEN_DLG8
		level.BZM_SGENDialogue9Callback	= &BZM_SGENDialogue9; // BONUSZM_SGEN_DLG8
	}	
}

// SGEN
function BZM_SGENDialogue1() // ARRIVE AT COALESCENCE (IGC)
{	
		wait 3;
	//It started at Coalescence Singapore in 2070, ten years after the disaster... ten years after Virus 61-15 began its spread, people began changing... ten years after the dead began to walk the Earth.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_it_started_at_coales_0" ); 
	
		wait 3;
	//We'd lost comms with a fellow U.E.T.: Undead Extermination Team. Deadkillers, we were called. With our cybernetic augmentations, we were impossible to infect. We were trained to terminate the Undead.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_d_lost_comms_with_0" );
	
	//But Taylor had gone silent. With our DNI, your systems are always monitored. At it's most basic level, Observation knew if you were Dead or Alive. For Taylor to be neither... that was unusual.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_but_taylor_had_gone_0" );
	
	//Hendricks was on edge, and why wouldn't he be? We were in a Quarantine Zone, one of many walled-off areas separating humanity from the Undead, keeping them from us... and keeping the Virus from spreading.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_hendricks_was_on_edg_0" );
	
	//The Undead weren't our only concern. The 54 Immortals, a wildly unpredictable local combine, were aware of Taylor's recent activity. They feared another gas leak, after all, this was the epicenter of the epidemic. If it wasn't for the Coalescence Disaster of 2060, we wouldn't live in the cursed world we did today.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_undead_weren_t_o_0" );
	
	//Either way, our troubles were only just beginning...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_either_way_our_trou_0" );
}

function BZM_SGENDialogue2() // DISCOVER DATA
{
	//What was so special about this operation?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_was_so_special_0" );
	
	wait 1;
	
	//Nothing, it was supposed to be by-the-books. Five years after our cybernetic augmentations, Hendricks and I were a well-oiled machine. Quarantine Sweeps were our bread and butter. Recon? Search and Rescue? Data Recovery? It's just what Deadkillers do. (pausing, thinks about it) ...but we'd never been sent after one of our own before. One of Taylor's team, Sebastian Diaz, still had his GPS activated, the signal coming from far below. (beat) As we stood there in the atrium... I felt like Alice. And we were about to jump down the rabbit hole.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_nothing_it_was_supp_0" );
}

function BZM_SGENDialogue3() // CHEM LAB
{
	//When man fled the virus, they left behind thousands of active robots, machinery abandoned with one directive: kill the dead.  (beat) Years later they're still killing, but due to decrepit programming somehow we'd been added to their kill-list, indistinguishable from our brainless counterparts. (beat) The strange behavior was observed in Multiple Quarantine Zones, adding additional threats to any recon work we did. (beat) We moved on.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_when_man_fled_the_vi_0" );	
}

function BZM_SGENDialogue4() // SILO FLOOR BATTLE
{
	//We'd reached the Silo's Floor... but Diaz's signal beckoned us lower, below Coalescence.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_d_reached_the_sil_0" );	
	
	wait 1;
	
	//Did you have any inkling of what waited for you down in the deep?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_did_you_have_any_ink_0" );
	
	wait 1;
	
	//No... in hindsight I'm sure we should've put it together. But the fact of the matter, that day was supposed to be like any other.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_no_in_hindsight_i_0" );		
}

function BZM_SGENDialogue5() // SP/CORVUS ENTRANCE
{
	//What did you find below Coalescence?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_did_you_find_be_0" );
	
	wait 0.5;
	
	//A CIA Black Project. Project Corvus. Unknown to the world... And unknown to even most people “in the know”. Off the Record. A redacted footnote in Langley's History Book. (laughs) Part of me wishes we'd just turned back.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_a_cia_black_project_0" );		
	
	//Why?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_why_0" );
	
	wait 1;
	
	//It... would have been easier. For me. For Hendricks. For the world.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_it_would_have_bee_0" );		
	
	wait 1;
	
	//Is it such a bad thing? To be blissfully ignorant in the face of daunting adversity?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_is_it_such_a_bad_thi_0" );	
	
	wait 1;
	
	//We didn't have a choice.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_didn_t_have_a_cho_0" );		
	
	wait 2;
	
	//Those who find fate thrust upon them rarely do.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_those_who_find_fate_0" );
}

function BZM_SGENDialogue6() // TESTING LAB (3RD PERSON IGC)
{
	wait 4;
	//The Human Testing Lab. What awaited you there?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_the_human_testing_la_0" );
	
	wait 1;
	
	//We found... the truth. The cause of the Disaster.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_found_the_trut_0" );
	
	wait 1;
	
	//We didn't have the full picture. Not yet. But this was the source.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_didn_t_have_the_f_0" );
	
	wait 1;
	
	//When the explosion happened here ten years ago, nearly a million died instantly. The lucky ones.  (beat) When the rest of Singapore inhaled 61-15, they... changed. From the living into the living dead.  (beat) It started here. In this room. Man was doing what Man does, deciding to play God and fucking things up even worse. We created these... things. We changed the world.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_when_the_explosion_h_0" );
	
	wait 1;
	
	//What do you mean, changed the world?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_do_you_mean_ch_0" );
	
	wait 1;

	//The Winslow Accord and the Common Defense Pact. We'd been engaged in a cold war for nearly a decade.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_winslow_accord_a_0" );	
	
	wait 1;
	
	//61-15 changed that. When the living dead walk among us, you set aside your differences. For all your conflicts, you and your enemy had at least two things in common.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_61_15_changed_that_0" );
	
	wait 0.5;
	
	//You're both human. And you both want to survive this Nightmare.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_you_re_both_human_a_0" );
	
	wait 0.5;
	
	//Did you find Taylor and his team there?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_did_you_find_taylor_0" );
	
	//No, but they'd come through.  (beat) Our answers lay further in the depths below.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_no_but_they_d_come_0" );
}

function BZM_SGENDialogue7() // THE DESCENT
{
	wait 2;
	
	//Did you know what you would find down in the depths?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_did_you_know_what_yo_0" );
	
	wait 1;
	
	//We couldn't have known... what we found, was...  (struggles) ...we found Sebastian Diaz. One of Taylor's. Another Deadkiller. Our friend. (struggling) He had... linked himself to the CIA central server, connected directly with Winslow Accord systems.  (beat) He was deactivating defensives for the Undead Quarantine Zones all over the world.  (beat) Up until this point, man had contained the spread, keeping the Undead, and the Virus, within these Quarantine Zones across the globe. (beat) Deactivating the defensives would let the flesheating hordes loose upon the living. It would end humanity. We had to stop him.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_couldn_t_have_kno_0" );	
}

function BZM_SGENDialogue8() // GHOST IN THE SHELL
{
	wait 17;
	//You killed him?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_you_killed_him_0" );
	
	wait 0.5;
	//He left us no choice. Diaz had done the unthinkable. We didn't know yet how fast it was spreading, at that moment we didn't care.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_left_us_no_choice_0" );	
	
	wait 2;
	//Of course, you were angry. You were confused...
	bonuszmsound::BZM_PlayDrSalimVox( "salm_of_course_you_were_0" );
	
	wait 2;
	//There was no rhyme or reason to what he had done. Hendricks knew he had to interface with Diaz.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_there_was_no_rhyme_o_0" );	
	
	wait 1;
	//Knowing it would surely kill whatever was left of him.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_knowing_it_would_sur_0" );
	
	wait 1;
	//Accessing Diaz's thoughts, his memories, it was the only way to find John Taylor. We had to know. Had I known what it would do to Hendricks...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_accessing_diaz_s_tho_0" );	
	
	wait 2;
	//I don't know. I struggle with that. I weigh the pro's and cons of letting him interface. Part of me wishes I had done it.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_don_t_know_i_stru_0" );
	
	wait 2;
	//But then you would not be here.	
	bonuszmsound::BZM_PlayDrSalimVox( "salm_but_then_you_would_n_0" );
	
	wait 1;
	//And would not have the opportunity you have now.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_and_would_not_have_t_0" );
	
	wait 0.5;
	
	//True. If he hadn't, we wouldn't have known what was happening above us...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_true_if_he_hadn_t_0" );	
	
	wait 4;
	//Goh Xiulan. Leader of the 54 Immortals.  (beat) The Immortals and the Winslow Accord had no quarrel. They had no idea we were down there.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_goh_xiulan_leader_o_0" );		
	
	wait 5;
	//The Immortals had worried about another outbreak for years. I guess the disturbance this time was the final straw.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_immortals_had_wo_0" );
	
	wait 3;
	//Can't blame them. They were only human. And just like humans do, they wanted to survive.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_can_t_blame_them_th_0" );
	
	wait 2;
	//Which meant there was only one thing to do...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_which_meant_there_wa_0" );	
}


function BZM_SGENDialogue9() // LOBBY EXIT (IGC)
{
	wait 2;
	
	//...and? And what happened then?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_and_and_what_hap_0" );
	
	wait 1;
	
	//We got through it. We survived.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_got_through_it_w_0" );
	
	wait 1;
	
	//Hendricks learned Taylor and his team were making their way out of Singapore. But we weren't giving up that easy.  (beat) Their motivations, their actions, it... it was still nonsensical. We couldn't make sense of it. At least not yet.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_hendricks_learned_ta_0" );
	
	wait 1;
	
	//But that was the beginning. That was the day everything changed.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_but_that_was_the_beg_0" );	
}
