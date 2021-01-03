#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#using scripts\cp\bonuszm\_bonuszm;
#using scripts\cp\bonuszm\_bonuszm_sound;
#using scripts\cp\_dialog;
#using scripts\cp\_util;

// PROLOGUE VOX
#using scripts\cp\voice\voice_z_prologue;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	

function autoexec Init()
{
	if( !( SessionModeIsCampaignZombiesGame() ) )
		return;
	
	mapname = GetDvarString( "mapname" );
	
	if( mapname != "cp_mi_eth_prologue" )
		return;

	// Dialogue setup	
	voice_z_prologue::init_voice();	
		
	level.BZM_PROLOGUEDialogue1Callback	= &BZM_PROLOGUEDialogue1; // BONUSZM_PROLOGUE_DLG1
	level.BZM_PROLOGUEDialogue2Callback	= &BZM_PROLOGUEDialogue2; // BONUSZM_PROLOGUE_DLG2
	level.BZM_PROLOGUEDialogue3Callback	= &BZM_PROLOGUEDialogue3; // BONUSZM_PROLOGUE_DLG3
	level.BZM_PROLOGUEDialogue4Callback	= &BZM_PROLOGUEDialogue4; // BONUSZM_PROLOGUE_DLG4
	level.BZM_PROLOGUEDialogue5Callback	= &BZM_PROLOGUEDialogue5; // BONUSZM_PROLOGUE_DLG5
	level.BZM_PROLOGUEDialogue6Callback	= &BZM_PROLOGUEDialogue6; // BONUSZM_PROLOGUE_DLG6
	level.BZM_PROLOGUEDialogue7Callback	= &BZM_PROLOGUEDialogue7; // BONUSZM_PROLOGUE_DLG7
	level.BZM_PROLOGUEDialogue8Callback	= &BZM_PROLOGUEDialogue8; // BONUSZM_PROLOGUE_DLG8
	
	// Add prologue specific logic in the following function
	BZM_PrologueSettings();
}

function private BZM_PrologueSettings()
{
	callback::on_spawned( &BZM_PrologueOnPlayerSpawned );	
}

function BZM_PrologueOnPlayerSpawned()
{
	//self AllowDoubleJump( false );
}

function BZM_PrologueDialogue1() // IGC: AIR TRAFFIC CONTROLLER
{
	wait 3;
	//With the dead crawling all over, we needed a distraction. Something to keep the flesh-eaters occupied so we could grab Bishop.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_with_the_dead_crawli_0" );
	
	//We weren't Deadkillers yet, so we needed to be a little more creative.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_weren_t_deadkille_0" );
		
	//Lucky for us there were plenty of abandoned birds still in the sky and the NRC's DEAD System still worked - laser cannons built to auto-target any hostile aircraft.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_lucky_for_us_there_w_0" );
	
		
	//So you created the diversion...
	bonuszmsound::BZM_PlayDrSalimVox( "salm_so_you_created_the_d_0" );

	//And Taylor's team prepped extraction. Command set EXFIL for a satellite station off base. We'd grab Bishop.	
	bonuszmsound::BZM_PlayPlayerVox( "plyz_and_taylor_s_team_pr_0" );
			
	//The undead could sense us, smell us... they knew we were there.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_undead_could_sen_0" );
		
	//We reset the DEAD system to target one of the automated planes.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_reset_the_dead_sy_0" );
	
	//This was your distraction?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_this_was_your_distra_0" );
	
	//Turns out the undead have a thing for giant explosions. Like moths drawn to a porch-lamp.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_turns_out_the_undead_0" );
	
	//And all we had to do was turn on the lights.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_and_all_we_had_to_do_0" );
	
	wait 1;
	//Unfortunately we couldn't exactly control the landing.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_unfortunately_we_cou_0" );
}

function BZM_PROLOGUEDialogue2() // NRC KNOCKING
{
	//We had to move. Bishop was being held underground in the security station.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_had_to_move_bish_0" );
}

function BZM_PROLOGUEDialogue3() // SECURITY CAMERA
{
	//Hendricks took out the guards. I hacked into the system to find Bishop.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_hendricks_took_out_t_0" );
	
	//There were still NRC on the base?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_there_were_still_nrc_0" );
	
	wait 3;
	//They kidnapped Bishop's whole team. They would do whatever it took to get their hands on the cure.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_they_kidnapped_bisho_0" );
	
	wait 3;
	//They'd torture these researchers 'til the dead broke down the door and ripped them all to shreds if it meant they could save their people.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_they_d_torture_these_0" );
	
	//It wasn't personal. It was self-preservation.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_it_wasn_t_personal_0" );
	
	//With the secret out about Bishop's discovery, he'd become the most wanted man in the world. The NRC were just the first to grab him. It was every country for itself then.  (beat) Why do you think we were there? The Winslow Accord wanted the same thing the NRC did.	
	bonuszmsound::BZM_PlayPlayerVox( "plyz_with_the_secret_out_0" );
	
	//You can rationalize anything when you're put up against a wall.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_you_can_rationalize_0" );
	
	//Nothing about this was rational. It was instinctual. Animalistic. Survival.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_nothing_about_this_w_0" );
	
	while( !( isdefined( level.minister_located ) && level.minister_located ) )
	{
	  	wait 0.5;
	}
	
	//He had been escorted to an interrogation room.  (beat) We had to hurry: between us and Bishop was an army of undead. And once one got a whiff the others would come running.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_had_been_escorted_0" );	
}

function BZM_PROLOGUEDialogue4() // HOSTAGE 1 OF 2
{	
	wait 13;
	
	//Hendricks told Bishop who we were and that we had to move, but Bishop refused to leave without the others. His researchers. His friends.  (beat) Our instructions were specific. Bishop was our priority. We didn't like it... but Bishop wouldn't leave the others.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_hendricks_told_bisho_0" );	
	
	level flag::wait_till( "khalil_door_breached" );
	
	wait 3;
	
	//Who was inside the cell?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_who_was_inside_the_c_0" );	
	
	//Lt. Zeyad Khalil. Member of the Egyptian Army. Back in '65 he was a Guard assigned to Bishop's research station. This was how we met.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_lt_zeyad_khalil_me_0" );	
	
	wait 5;
	
	//Hendricks cut him down and notified Taylor we were freeing the other hostages.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_hendricks_cut_him_do_0" );	
	
	//Taylor said we didn't have the time. The base was swarming with additional NRC Forces, they weren't letting their prize go that easily.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_taylor_said_we_didn_0" );	
	
	wait 2;
	
	//We needed to get moving, there was a tunnel full of hostile soldiers between us and our exit, but the cargo elevator ahead was the only way to the surface.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_needed_to_get_mov_0" );		
}

function BZM_PROLOGUEDialogue5() // INTRO CYBER SOLDIERS
{	
	level waittill("cin_pro_09_01_intro_1st_cybersoldiers_elevator_enemies_play");
	
	//The remaining NRC forces were waiting for us above. They weren't about to let their prized prisoner go. If it meant getting the cure and saving their families, they were willing to die for it.  (beat) They weren't the only ones.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_remaining_nrc_fo_0" );
	
	level waittill( "cin_pro_09_01_intro_1st_cybersoldiers_taylor_attack_play" );
	
	//Taylor's Team?	
	bonuszmsound::BZM_PlayDrSalimVox( "salm_taylor_s_team_0" );	
	
	wait 2;
	
	//We'd never seen Deadkillers in action before... To us it was a spectacle. To them, it was just another day in the life.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_d_never_seen_dead_0" );
	
	wait 1;
	
	//...wait a minute...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_wait_a_minute_0" );
			
	//Do not be deceived by his lies...		
	bonuszmsound::BZM_PlayDolosVox( "plyz_wait_a_minute_0" );
		
	//...remember your past...
	bonuszmsound::BZM_PlayDolosVox( "dolo_remember_your_pas_0" );
	
	//...remember when you first met John Taylor...
	bonuszmsound::BZM_PlayDolosVox( "dolo_remember_when_you_0" );
	
	//...remember the truth.
	bonuszmsound::BZM_PlayDolosVox( "dolo_remember_the_trut_0" );
		
	//Wait... This is all wrong. (beat) This can't be real... I don't understand. I told you I met Taylor in Zurich during the 2065 Cotardist Uprising, after I became a Deadkiller. But here I am with Taylor... and my limbs haven't been replaced yet. I'm still human.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_wait_this_is_all_0" );
	
	wait 1;
	
	//Why did you tell me the first time I met Taylor was Zurich?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_why_did_you_tell_me_0" );
	
	//I did not tell you... you told me. Which is the truth?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_i_did_not_tell_you_0" );
		
	//I... this one? This is the first time I met Taylor and his team. That... that memory in Zurich... (realizing) That never happened. Am... am I losing my mind?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_this_one_this_0" );
			
	//Focus. You need to complete this memory. What was Taylor's plan?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_focus_you_need_to_c_0" );
		
	//We were still on point for our exfil. But first we had to blow the bridge. We followed Diaz, both undead and NRC Forces were converging on our position.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_were_still_on_poi_0" );
}

function BZM_PROLOGUEDialogue6() // OPEN DOOR
{
	//You were forced into the garage. What happened there?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_you_were_forced_into_0" );
	
	//Hendricks... Hendricks wanted to go back, get the other hostages.	
	bonuszmsound::BZM_PlayPlayerVox( "plyz_hendricks_hendric_0" );
	
	wait 2;
	
	//Taylor said Bishop was priority. After all, he had the cure. The rest were just... collateral.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_taylor_said_bishop_w_0" );
	
	wait 6;
	
	//What did Taylor do?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_did_taylor_do_0" );
	
	//He volunteered to take his team to get the others. Hendricks was to take Bishop and Khalil to exfil.  Pick-up was still on schedule.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_volunteered_to_ta_0" );
	
	wait 4;
	
	//Hendricks told us to get on the APC. Bishop was the most important man in the world right now. We would get him to EXFIL if it killed us.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_hendricks_told_us_to_0" );	
}

function BZM_PROLOGUEDialogue7() // GET TO THE TRUCK
{
	wait 3;
	
	//We missed our EXFIL. We had to get  outta there. We got to the APC.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_missed_our_exfil_0" );
	
	//No, I can't do this. I can't live this again. No, please--
	bonuszmsound::BZM_PlayPlayerVox( "plyz_no_i_can_t_do_this_0" );
	
	//I am sorry, you must.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_i_am_sorry_you_must_0" );
}
	
function BZM_PROLOGUEDialogue8() // PLAYER SQUASHED
{
	//We couldn't get out. There were too many of them.  (panic) I can't watch this.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_couldn_t_get_out_0" );

	//If you wish to defeat Deimos, you must.	
	bonuszmsound::BZM_PlayDrSalimVox( "salm_if_you_wish_to_defea_0" );
	
	//No, no, no, please--
	bonuszmsound::BZM_PlayPlayerVox( "plyz_no_no_no_please_0" );
	
	//If you wish to defeat Deimos, you must. To save the world you must relive this.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_if_you_wish_to_defea_1" );
		
	//I should've died. I felt it calling me... the hereafter...	
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_should_ve_died_i_0" );
	
	level waittill( "cin_pro_20_01_squished_1st_rippedapart_aftermath_pt1_play" );
		
	//Taylor. If it wasn't for him...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_taylor_if_it_wasn_t_0" );
	
	//I guess none of this would've happened. Everything that followed happened because of that day.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_guess_none_of_this_0" );
	
	wait 2;
	
	//That was the day I met John Taylor. That was the day I became a Deadkiller.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_that_was_the_day_i_m_0" );	
}