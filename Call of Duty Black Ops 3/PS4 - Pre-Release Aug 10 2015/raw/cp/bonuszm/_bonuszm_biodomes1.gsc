#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

#using scripts\cp\bonuszm\_bonuszm;
#using scripts\cp\bonuszm\_bonuszm_sound;
#using scripts\cp\_dialog;
#using scripts\cp\_util;

// BIO VOX
#using scripts\cp\voice\voice_z_provocation;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	

function autoexec Init()
{
	if( !( SessionModeIsCampaignZombiesGame() ) )
		return;
	
	mapname = GetDvarString( "mapname" );
	
	if( mapname == "cp_mi_sing_biodomes" ||  mapname == "cp_mi_sing_biodomes2" )
	{
		voice_z_provocation::init_voice();	
		
		level.BZM_BIODialogue1Callback	= &BZM_BIODialogue1; // BONUSZM_BIO_DLG1
		level.BZM_BIODialogue2Callback	= &BZM_BIODialogue2; // BONUSZM_BIO_DLG2
		level.BZM_BIODialogue3Callback	= &BZM_BIODialogue3; // BONUSZM_BIO_DLG3
		level.BZM_BIODialogue4Callback	= &BZM_BIODialogue4; // BONUSZM_BIO_DLG4
		level.BZM_BIODialogue5Callback	= &BZM_BIODialogue5; // BONUSZM_BIO_DLG5
		level.BZM_BIODialogue6Callback	= &BZM_BIODialogue6; // BONUSZM_BIO_DLG6
		level.BZM_BIODialogue7Callback	= &BZM_BIODialogue7; // BONUSZM_BIO_DLG7
	}	
}

// BIO
function BZM_BIODialogue1() // PARTY
{
	waittime = 3;	
	wait waittime; 
	//Getting in was easy. Getting out would be another matter entirely.	
	bonuszmsound::BZM_PlayPlayerVox( "plyz_getting_in_was_easy_0" );
	
	//Hendricks had a contact, Danny Li. He was slimy as they come, but he could get us transport.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_hendricks_had_a_cont_0" );
	
	//At the time the Biodomes were the safest place to be. With the Outbreak of 2060 the Immortals didn't see tragedy, they saw opportunity. They seized the Marina and dug their heels in. The Biodomes were impenetrable. Dead-proof.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_at_the_time_the_biod_0" );
	
	waittime = 2;	
	wait waittime; 
	
	//And they could provide safe passage?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_and_they_could_provi_0" );
	
	//Not only that, they claimed to know where Taylor was heading.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_not_only_that_they_0" );
	
	//They had this information?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_they_had_this_inform_0" );
	
	//They claimed to. Danny was convinced Goh Xiulan had information on her central server.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_they_claimed_to_dan_0" );
	
	waittime = 3;	
	wait waittime; 

	//They were doing us a solid. No denying that.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_they_were_doing_us_a_0" );		
	
	waittime = 2;	
	wait waittime;
	
	//Still, didn't mean they were happy to see us. Our failure to stop Diaz wasn't exactly secret. Danny went so far to accuse us of opening the containment zones ourselves. Hendricks persuaded him otherwise.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_still_didn_t_mean_t_0" );	
	
	waittime = 2;	
	wait waittime;
	
	//But that didn't change how I felt. We were there, we had our chance to stop Diaz in the server room...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_but_that_didn_t_chan_0" );
	
	//You cannot blame yourself for what is out of your control.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_you_cannot_blame_you_0" );
		
	//But it was in our control, don't you see that? We could have brought it to an end before it began.
	//bonuszmsound::BZM_PlayPlayerVox( "plyz_but_it_was_in_our_co_0" ); 	SCRIPT CHANGED
		
	//You don't really believe that, do you?
	//bonuszmsound::BZM_PlayDrSalimVox( "salm_you_don_t_really_bel_0" );	SCRIPT CHANGED
	
	//There were powers in play far greater than your own. Powers with far more control. You were a pawn in their game.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_there_were_powers_in_0" );	
	
	//You mean Deimos...  (beat) Well, if we're the Pawns he's the Chess Master. And as it was, we weren't his only pawns in the room.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_you_mean_deimos_0" );	
	
	//How do you mean?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_how_do_you_mean_0" );		
	
	//Know that saying 'too good to be true'? Something was wrong. There was something malevolent, malicious. I called Danny out.  (beat) You can get us a ride out? Sure. I'll give you that. But claiming to know where Taylor was?... He was stalling. Didn't take long for us to find out why.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_know_that_saying_to_0" );	
	
	waittime = 42;	
	wait waittime;
		
	//The Goh Siblings. Danny set you up?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_the_goh_siblings_da_0" );		

	//No, no, no, this was different. There was a look in their eyes. They almost seemed... it sounds crazy, even now, but..	
	bonuszmsound::BZM_PlayPlayerVox( "plyz_no_no_no_this_was_0" );
	
	//What was it? What did you see?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_was_it_what_di_0" );		
	
	//...when I was young, my Mom collected puppets, vintage or something. Sat behind glass in the study. I never went in there, they terrified me.  (beat) It was their eyes. That dead look. They watched me and they looked right through me. Even when I closed my eyes, I still felt it. (beat) Goh Xiulan, Goh Min, Danny -- they all had that same look. The same look we saw from Diaz.  (beat) It was only later we found out all higher-ups in the Immortals were outfitted with DNI. Like us.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_when_i_was_young_0" );	
	
	waittime = 3;	
	wait waittime;
	
	//Certainly explained their strange behavior... and then they said his name. It was the first time we heard it. Deimos. (beat) The Goh Siblings pledged to sacrifice us in his honor.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_certainly_explained_0" );
	
	waittime = 2;	
	wait waittime;
	
	//Thing about Deadkillers though: there's always a Plan B.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_thing_about_deadkill_0" );
}

function BZM_BIODialogue2() // GUNPLAY
{
	//We'd worried about being set up. We had a robot squad in place, ready if the situation took a turn.  (beat) They cleared the room... except for Goh Xiulan. Hendricks said she was heading to Cloud Mountain. Toward the central server room.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_d_worried_about_b_0" );
	
	waittime = 7;	
	wait waittime;
	
	bonuszmsound::BZM_PlayPlayerVox( "plyz_it_became_quickly_ap_0" );	
}

function BZM_BIODialogue3() // DATA DRIVES (1ST PERSON IGC)
{
	waittime = 2;	
	wait waittime;
		
	//Goh Xiulan was wiping the servers. She succeeded in locking us out before Hendricks stepped in.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_goh_xiulan_was_wipin_0" );

	waittime = 2;	
	wait waittime;
	
	//This was someone who was an ally. What happened? Why the change in her behavior?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_this_was_someone_who_0" );
	
	//It sounded crazy, but I didn't think it was her. Even then. Whatever... whatever was inside her... it wasn't her. (SIGHS) But right then, we needed to secure transport and figure out what Xiulan knew about Taylor. (beat) It was our one chance. If we lost Taylor and his team now, he'd be off the grid. Fade into the ether.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_it_sounded_crazy_bu_0" );
	
	//Hendricks tried to get in the system. It proved more complicated than we anticipated.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_hendricks_tried_to_g_0" );
	
	waittime = 4;	
	wait waittime;
	
	//The Goh Siblings were smart. They'd set up an access system requiring both of their hands for identification. (beat) And her brother was shredded with bullets back in the bar.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_goh_siblings_wer_0" );
	
	//We could hear the horde at the door... we didn't have much time. And we only had one sibling.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_could_hear_the_ho_0" );
	
	//But she did have two hands.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_but_she_did_have_two_0" );
	
	//You cut off her hand?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_you_cut_off_her_hand_0" );	
	
	//I took a gamble. I hoped the system allowed the siblings to use either reader.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_took_a_gamble_i_h_0" );
	
	//You tried to beat the system?
	//bonuszmsound::BZM_PlayDrSalimVox( "salm_you_tried_to_beat_th_0" );	SCRIPT CHANGED

	//Wouldn't be the first time. Or the last.	
	//bonuszmsound::BZM_PlayPlayerVox( "plyz_wouldn_t_be_the_firs_0" );		SCRIPT CHANGED
	
	//If we were getting out of here alive, it had to work.
	//bonuszmsound::BZM_PlayPlayerVox( "plyz_if_we_were_getting_o_0" );		SCRIPT CHANGED
	
	//And it did.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_and_it_did_0" );	
}

function BZM_BIODialogue4() // SERVER ROOM
{
	//Hendricks interfaced with the system.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_hendricks_interfaced_0" );	

	waittime = 5;
	wait waittime;

	//Like I said before, not exactly a fun procedure. Especially with what had happened in Corvus. (beat) He located transport, there was exfil near the zone's wall. Beyond the docks.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_like_i_said_before_0" );	
	
	waittime = 4;
	wait waittime;
	
	//Finding out what Goh Xiulan knew about Taylor... that was going to take some time. (beat) And time was something we didn't have.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_finding_out_what_goh_0" );		
}

function BZM_BIODialogue5() // DESCEND
{
	waittime = 3;
	wait waittime;
	
	//The docks were beyond the Supertrees. And the undead weren't the only thing interested in us.  	OLD LINES, NEEDS TO BE UPDATED
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_docks_were_beyon_0" );	
	
	//Automated Hunters... they were like the Rogue bipedal units, considering humanity a threat. Only on a much larger, more deadly scale.		OLD LINES, NEEDS TO BE UPDATED
	bonuszmsound::BZM_PlayPlayerVox( "plyz_automated_hunters_0" );		
}

function BZM_BIODialogue6() // SLIDE AND SLAM (IGC)
{
	waittime = 6;
	wait waittime;
	
	//But you escaped?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_but_you_escaped_0" );
	
	//Lady Luck was our friend once more. (beat) But malfunctioning Hunters are pretty determined scraps of metal.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_lady_luck_was_our_fr_0" );	
	
	//But technically so were we.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_but_technically_so_w_0" );	
}

function BZM_BIODialogue7() // SLIDE AND SLAM (IGC) 
{
	waittime = 3;
	wait waittime;
	
	//Our exfil was just ahead. We were getting out of Singapore.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_our_exfil_was_just_a_0" );
	
	//What about Taylor? What did Hendricks learn from the server?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_about_taylor_w_0" );
	
	waittime = 2;
	wait waittime;
	
	//Nothing. It had been wiped. The information loss. (defeated) Taylor was in the wind. And the virus... the virus was spreading.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_nothing_it_had_been_0" );	
}