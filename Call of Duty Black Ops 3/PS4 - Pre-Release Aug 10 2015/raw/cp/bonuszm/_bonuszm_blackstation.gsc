#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;

#using scripts\cp\bonuszm\_bonuszm;
#using scripts\cp\bonuszm\_bonuszm_sound;
#using scripts\cp\_dialog;
#using scripts\cp\_util;

// BLACKSTATION VOX
#using scripts\cp\voice\voice_z_blackstation;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	

function autoexec Init()
{
	if( !( SessionModeIsCampaignZombiesGame() ) )
		return;
	
	mapname = GetDvarString( "mapname" );
	
	if( !IsSubstr( mapname, "blackstation" ) )
		return;
		
	voice_z_blackstation::init_voice();	
		
	level.BZM_BLACKSTATIONDialogue1Callback	= &BZM_BLACKSTATIONDialogue1; // BONUSZM_BLACKSTATION_DLG1
	level.BZM_BLACKSTATIONDialogue2Callback	= &BZM_BLACKSTATIONDialogue2; // BONUSZM_BLACKSTATION_DLG2
	level.BZM_BLACKSTATIONDialogue3Callback	= &BZM_BLACKSTATIONDialogue3; // BONUSZM_BLACKSTATION_DLG3
	level.BZM_BLACKSTATIONDialogue4Callback	= &BZM_BLACKSTATIONDialogue4; // BONUSZM_BLACKSTATION_DLG4
	level.BZM_BLACKSTATIONDialogue5Callback	= &BZM_BLACKSTATIONDialogue5; // BONUSZM_BLACKSTATION_DLG5
}

function BZM_BLACKSTATIONDialogue1() // INTO THE QUARANTINE ZONE (IGC)
{
	wait 2;

	//The Singapore Quarantine Zone. We never thought we'd be back here.	
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_singapore_quaran_0" );
	
	wait 2;
	
	//Bad memories?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_bad_memories_0" );
		
	//You know damn well it certainly wasn't good ones, doc. The place was a living, breathing reminder of the incident five years ago.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_you_know_damn_well_i_0" );
	
	wait 2;
	
	//We'd be in and out quick. Find out who this Deimos asshole was and get the hell outta dodge. We weren't staying any longer than we had to.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_d_be_in_and_out_q_0" );
}

function BZM_BLACKSTATIONDialogue2() // QUARANTINE-ZONE
{
	wait 1;
	
	//For security purposes the data drive on Deimos was encrypted and separated into two pieces. We needed both to access the drive. Like a lock and key.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_for_security_purpose_0" );
	
	//The lock, I assume was at the Black Station. Where was the key?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_the_lock_i_assume_w_0" );
	
	wait 2;
	
	//The Key... that was down on the docks, which was undead central, heavy hostiles.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_key_that_was_0" );
	
	wait 2;
	
	//WA Command had prepped a drone strike to wipe out most of the dock, but with the high winds from the incoming superstorm... well, we couldn't be sure it would work. We had grabbed our spike anchors in case we needed to be nailed down.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_wa_command_had_prepp_0" );
	
	wait 3;
	
	//After the docks our rendezvous with Kane was set for abandoned police station. (beat) Hendricks took point.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_after_the_docks_our_0" );	
}

function BZM_BLACKSTATIONDialogue3() // WARLORD INTRO (3RD PERSON IGC)
{
	wait 3;
	
	//More Vultures?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_more_vultures_0" );
	
	//Praying on the weak. With the fall of the Immortals, they had inherited all of Singapore, for better or worse. They'd turned the place in to some twisted version of the wild west.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_praying_on_the_weak_0" );	
	
	wait 2;
	
	//After the Safehouse we'd caught their attention -- they weren't exactly thrilled with us on their turf and were taking it out on the locals to find us.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_after_the_safehouse_0" );	
	
	//Why didn't you step in? Try to help them?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_why_didn_t_you_step_0" );

	wait 2;
	
	//Calculated Risks. We needed to stay quiet and lay low.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_calculated_risks_we_0" );

	//But there's always a chance, isn't there?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_but_there_s_always_a_0" );	
	
	//Chance is a billion-sided die. You like the odds of that? We needed to get to the Black Station raising as little alarm as possible. (beat) Turns out the odds were already against us.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_chance_is_a_billion_0" );
}

function BZM_BLACKSTATIONDialogue4() // KANE INTRO (IGC)
{
	wait 3;
	
	//We were set to meet Kane somewhere in the police station...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_were_set_to_meet_0" );
	
	wait 4;
	
	//Turns out we weren't the only humans in there.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_turns_out_we_weren_t_0" );
	
	wait 8;
	
	//Kane made quick work of the Warlord Vulture.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_kane_made_quick_work_0" );
	
	//She was well-trained... was she CIA? Winslow Accord?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_she_was_well_trained_0" );
	
	//It didn't matter. She was just someone who was always in the right place at the right time. (beat) Hendricks gave her the key, but before we could move on the Black Station, we had other problems.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_it_didn_t_matter_sh_0" );	
	
	wait 2;
	
	//What had gone wrong?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_had_gone_wrong_0" );
	
	//We hadn't taken the scavengers into account. They knew we were here. Specifically, they knew two Deadkillers were here--  (explaining) Hendricks and I could fetch for a pretty penny if you broke us down to spare parts.  (remorse) In 2070 we were the saviors of mankind. By 2075... well, whether they were Undead or living, everyone wanted a piece of us.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_hadn_t_taken_the_0" );

	//But Kane was resourceful, she had a plan.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_but_kane_was_resourc_0" );
	
	//They had a communication station ahead. Kane told us if we hacked the system, she'd scramble their comms and lead them away from the Black Station. At least long enough for us to get what we needed.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_they_had_a_communica_0" );
	
	wait 2;
	
	//We'd regroup with her outside of Chinatown.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_d_regroup_with_he_0" );
}


function BZM_BLACKSTATIONDialogue5() // END (IGC)
{
	wait 4;
	
	//What did you find in the Black Station?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_did_you_find_in_0" );
	
	wait 2;
	
	//Slaughtered CIA staff. We weren't the only ones looking for the data drives on Deimos.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_slaughtered_cia_staf_0" );
	
	//It was a gruesome scene... Kane quickly assembled the drive.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_it_was_a_gruesome_sc_0" );
	
	//What did you learn? Did you find the information on Deimos?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_did_you_learn_0" );
	
	wait 3;
	
	//We... found a dossier. A diary, really, a living testament of what happened fifteen years ago... and in the years since. The creator of Project Corvus was alive and had been documenting Deimos all these years. (beat) It had details on Project Corvus -- a CIA mind control experiment that got out of hand. They had mixed two ancient Nazi Biochemical Compounds together. Nova 6... and something called Element 115.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_found_a_dossie_0" );
	
	wait 1;
	
	//They fused them together, created a chemical cocktail and injected it through their DNI systems. They wanted to control them.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_they_fused_them_toge_0" );
	
	//Control them?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_control_them_0" );
	
	//Those corpses, below Coalescence in Project Corvus, they weren't patients. Yhey were prisoners, rapists, murderers, the criminally insane. These... these scientists believed they could make them well again. They believed they could make people better. (beat) But instead they opened The Gateway.	
	bonuszmsound::BZM_PlayPlayerVox( "plyz_those_corpses_below_0" );
	
	//The Gateway?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_the_gateway_0" );
			
	//The Gateway to Malum, another dimension. A dimension adjacent to our own filled with absolute evil.  (beat) It sounds crazy, I know, even saying it now, but they opened it, not realizing what they'd done. And the gas came through, Virus 61-15 seeped into our dimension... but it wasn't alone.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_gateway_to_malum_0" );
	
	//Deimos.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_deimos_0" );
	
	//Deimos. Someone did a helluva a lot of research on him. The dossier described Deimos as a malevolent demigod of Malum, he was the living abstraction of pure terror.  (beat) He caused the Coalescence Disaster. He created the undead that roamed the earth.  (beat) And somehow the author of the report had figured out Taylor's team worked for Deimos. They helped him trigger Armageddon
	bonuszmsound::BZM_PlayPlayerVox( "plyz_deimos_someone_did_0" );
	
	wait 1;
	
	//There was also information on his sister.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_there_was_also_infor_0" );
	
	//His sister?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_his_sister_0" );
	
	//Dolos. Demigoddess of trickery and deception. Deimos he... from what we could gather Deimos didn't like her very much.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_dolos_demigoddess_o_0" );
		
	//And the researcher... did he have a name? Do you remember who wrote this document?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_and_the_researcher_0" );
		
	//Yes, it was... wait. (realizing) Holy shit. Dr. Salim.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_yes_it_was_wait_0" );
		
	//It said Dr. Salim. It was you. You wrote the dossier on Deimos. You were the man behind Project Corvus.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_it_said_dr_salim_i_0" );
}