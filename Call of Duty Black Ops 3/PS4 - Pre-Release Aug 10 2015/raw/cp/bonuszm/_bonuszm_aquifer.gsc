#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#using scripts\cp\bonuszm\_bonuszm;
#using scripts\cp\bonuszm\_bonuszm_sound;
#using scripts\cp\_dialog;
#using scripts\cp\_util;

// AQUIFER VOX
#using scripts\cp\voice\voice_z_aquifer;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	

function autoexec Init()
{
	if( !( SessionModeIsCampaignZombiesGame() ) )
		return;
	
	mapname = GetDvarString( "mapname" );
	
	if( mapname != "cp_mi_cairo_aquifer" )
		return;

	// Dialogue setup	
	voice_z_aquifer::init_voice();	
		
	level.BZM_AQUIFERDialogue1Callback	= &BZM_AQUIFERDialogue1; // BONUSZM_AQUIFER_DLG1
	level.BZM_AQUIFERDialogue2Callback	= &BZM_AQUIFERDialogue2; // BONUSZM_AQUIFER_DLG2
	level.BZM_AQUIFERDialogue3Callback	= &BZM_AQUIFERDialogue3; // BONUSZM_AQUIFER_DLG3
	level.BZM_AQUIFERDialogue4Callback	= &BZM_AQUIFERDialogue4; // BONUSZM_AQUIFER_DLG4
	level.BZM_AQUIFERDialogue5Callback	= &BZM_AQUIFERDialogue5; // BONUSZM_AQUIFER_DLG5
	level.BZM_AQUIFERDialogue6Callback	= &BZM_AQUIFERDialogue6; // BONUSZM_AQUIFER_DLG6
	level.BZM_AQUIFERDialogue7Callback	= &BZM_AQUIFERDialogue7; // BONUSZM_AQUIFER_DLG7
	
	// Add aquifer specific logic in the following function
	BZM_aquiferSettings();
}

function private BZM_aquiferSettings()
{
	callback::on_spawned( &BZM_aquiferOnPlayerSpawned );	
}

function BZM_aquiferOnPlayerSpawned()
{
	//self AllowDoubleJump( false );
}

function BZM_AQUIFERDialogue1() // FLY-IN
{
	wait 7;
	//Even by 2075 Bombing Runs were futile, another failed attempt to defeat the undead. For every ten we killed a hundred took their place.  (beat) Africa had been hit harder than most. Aside from the brainless corpses scouring the landscape, the last thirty years saw the continent's water supply drop to zero. It was war-torn and ravaged even before the undead arrived.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_even_by_2075_bombing_0" );	
	
	//And yet the people stayed?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_and_yet_the_people_s_0" );
	
	//Where would they go? You'd just be trading one hellhole for another.  (beat) These were the last refineries in Cairo's desert and for reasons unknown they bred the undead. This was our last sweep... if it failed we'd make the call to blow it into the next life.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_where_would_they_go_0" );	
		
	//Ahead were more rogue robotics. Installed by the Nile River Coalition during the Water Wars, they were abandoned when 61-15 spread. Aged and rundown, they mindlessly performed pointless pre-programmed task, hopelessly resistent to the evolving world. Much like us.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_ahead_were_more_rogu_0" );	
}

function BZM_AQUIFERDialogue2() // KANE RESCUES PLAYER
{
	wait 2;
	
	//Tell me what happened in the water.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_tell_me_what_happene_1" );
	
	//Our DNI... there was a malfunction...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_our_dni_there_was_0" );	
	
	//What did you see?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_did_you_see_0" );
	
	//...I... I saw...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_i_saw_0" );	
	
	//I was drowning, I thought I heard...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_was_drowning_i_th_0" );	
	
	wait 2;
	
	//This is not your time. Get back up.  (beat) Do not trust him. Everything is not what it seems...
	bonuszmsound::BZM_PlayDolosVox( "dolo_this_is_not_your_tim_0" );
	
	wait 3;
	
	//What did you hear?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_did_you_hear_0" );
	
	//I... nothing. I couldn't make it out.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_nothing_i_coul_0" );	
	
	//Get...UP.
	bonuszmsound::BZM_PlayDolosVox( "dolo_get_up_0" );
	
	//I saw it. The Other Place. A glimpse of the doorway, of... Malum.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_saw_it_the_other_0" );	
	
	wait 3;
	
	//Then I woke up. Someone pulled me out of the water. Someone saved me.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_then_i_woke_up_some_0" );	
	
	//...saved you?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_saved_you_0" );
	
	//A Woman. A Guardian Angel. She brought me back from the brink.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_a_woman_a_guardian_0" );	
	
	//She said my work wasn't done, it wasn't my time. I had to stop Taylor.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_she_said_my_work_was_0" );	
	
	//Did you know her? This woman?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_did_you_know_her_th_0" );
	
	wait 1;
		
	//...no. I'd never seen her before.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_no_i_d_never_see_0" );	
	
	wait 1;
	
	//And yet she knew about Taylor?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_and_yet_she_knew_abo_0" );
	
	wait 5;
		
	//You're sure she was there?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_you_re_sure_she_was_0" );
	
	//Why? Do you think I made her up?
	bonuszmsound::BZM_PlayPlayerVox( "plyz_why_do_you_think_i_0" );	
	
	//You yourself said your DNI systems were malfunctioning...
	bonuszmsound::BZM_PlayDrSalimVox( "salm_you_yourself_said_yo_0" );
	
	//What? You gonna tell me I'm crazy next? I know what I saw.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_what_you_gonna_tell_0" );

	//Could this be another false memory? Your mind trying to deceive you? (beat) You know I've read the report you and Hendricks submitted.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_could_this_be_anothe_0" );	
	
	wait 1;
	
	//Then you should know what I saw.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_then_you_should_know_0" );
	
	//You mention your DNI systems glitching... and that you pulled yourself out of the water. There's no mention of this... 'Guardian Angel', as you say.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_you_mention_your_dni_0" );	
	
	//I did not make her up, I didn't fucking imagine someone.  (beat) I don't remember why I left her off the report, but she. Was. There.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_did_not_make_her_u_0" );
	
	wait 5;
	
	//I still had ground to cover, plenty of undead left to sweep off this mobile shithole.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_still_had_ground_t_0" );
}


function BZM_AQUIFERDialogue3() // EXT. AQUIFER PLATFORM.
{
	wait 5;

	//That's Lieutenant Zeyad Khalil, a friend of ours. Egyptian Army. He'd defended his home through the Water Wars -- and the Undead Wars. He wasn't going down without a fight.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_that_s_lieutenant_ze_0" );
	
	wait 2;
	
	//Go with her. Trust her. Find Taylor.
	bonuszmsound::BZM_PlayDolosVox( "dolo_go_with_her_trust_h_0" );
	
	//What about your supposed 'Guardian Angel'?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_about_your_supp_0" );	
		
	//She... she told us the answers to finding Taylor were on this refinery. It didn't make any sense. And when the time was right, we'd find her again. (beat) Khalil needed to get to the control room. He told us to cover him.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_she_she_told_us_t_0" );
}

function BZM_AQUIFERDialogue4() // TAYLOR/MARETTI VIDEO FEED VIGNETTE
{
	wait 2;
	
	//When Khalil took the control room he found something on the security footage. Something we needed to see.  (beat) He sent us the video feed.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_when_khalil_took_the_0" );
	
	wait 1;
	
	//Taylor.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_taylor_0" );	
	
	//It was like seeing a Ghost. The woman was right. After no luck for years, we just stumbled upon him.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_it_was_like_seeing_a_0" );
		
	//This wasn't a random refinery, this was their hideout. They'd surrounded themselves with the undead. Their Fortress in the Sand.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_this_wasn_t_a_random_0" );
	
	//Command informed us the Kill Order was still active. Hendricks didn't like that, but it wasn't his call.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_command_informed_us_0" );
	
	//How did you feel about the kill order?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_how_did_you_feel_abo_0" );
		
	//Five years... Five years after our fuck-up and here we were. Taylor may have been getting away, but we could still get Maretti. I'd gladly take the shot.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_five_years_five_y_0" );
}

function BZM_AQUIFERDialogue5() // HENDRICKS FIGHT 1
{
	wait 2;
	
	//What happened with Hendricks?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_happened_with_h_0" );
	
	//He was upset, and why wouldn't he be? Command wanted his friends dead. He wanted to bring Maretti in alive.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_he_was_upset_and_wh_0" );
	
	//But that wasn't all, was it?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_but_that_wasn_t_all_0" );
	
	//No, Hendricks... Hendricks had been different since Singapore.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_no_hendricks_hen_0" );
	
	//In what way?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_in_what_way_0" );
	
	wait 1;
	
	//In every way. Aggressive. Angry. He was losing perspective... and there... something was just off. (frustrated) I was such a fucking idiot. I should've known what happened.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_in_every_way_aggres_0" );
	
	//How could you have known? Even if you had, what could you have done?	
	bonuszmsound::BZM_PlayDrSalimVox( "salm_how_could_you_have_k_0" );
	
	//Put a bullet in his head.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_put_a_bullet_in_his_0" );
	
	//You seem certain of his intentions.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_you_seem_certain_of_0" );
	
	wait 1;	
	
	//Listen, Doc... if we're here, in this fucking 'Void Space'... then you know what happened at Lotus Towers. What happened in Zurich. What he did. What's possessed him. (reflective) We all battle inner demons and choices. Hendricks, Taylor... that whole team rose the ranks together. Fought alongside each other. These were his friends. (beat) Little did we know one of his 'friends' was watching us...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_listen_doc_if_we_0" );
}

function BZM_AQUIFERDialogue6() // PLAYER/MARETTI FIGHT
{
	wait 2;
	
	//What happened when you cornered Specialist Maretti?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_happened_when_y_1" );
	
	wait 1;
	
	//At the time I couldn't quite make sense of it. He told me it was too late for him. But I'll never forget when he said his name.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_at_the_time_i_couldn_0" );
	
	//His name?...
	bonuszmsound::BZM_PlayDrSalimVox( "salm_his_name_0" );
	
	//It was the second time I'd heard it. The first was Goh Xiulan in the Biodomes.  (beat) Deimos. Maretti said he'd sworn an oath to him, he would die for him.  (beat) For a moment I saw the light in his eyes. I saw the friend, not the puppet. He told me to find Damien Bishop; a professor, our mutual friend. Bishop could help stop Deimos.  (beat) And then the light faded.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_it_was_the_second_ti_0" );
}

function BZM_AQUIFERDialogue7() // HENDRICKS FIGHT 2/AQUIFER EXPLODING
{
	wait 2;
	
	//I did what we were told to do. Our job. It didn't sit with Hendricks.	
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_did_what_we_were_t_0" );
	
	wait 1;
	
	//Can you blame him for his outburst?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_can_you_blame_him_fo_0" );
	
	
	//Hendricks was pissed because Maretti was our link to finding Taylor, a link I'd just severed and split open on a spike.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_hendricks_was_pissed_0" );
	
	//What I channeled inward... guilt I let consume myself, Hendricks channeled outward. At me. This was our chance to fix our mistake and I fucked that up. Hendricks said I may as well have damned the world myself. I'd had enough.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_what_i_channeled_inw_0" );
	
	wait 4;
	
	//I knocked some sense into him.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_knocked_some_sense_0" );
	
	wait 2;
	
	//Sometimes it was the only way to get through.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_sometimes_it_was_the_0" );
	
	wait 2;
	
	//I told him what Maretti had told me. About finding Bishop, figuring out who Deimos was.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_told_him_what_mare_0" );
	
	//We'd figure this shit out. And we'd do it together.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_d_figure_this_shi_0" );
	
	wait 1;
	
	//But right then we had bigger problems.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_but_right_then_we_ha_0" );
	
	wait 3;
	
	//The Egyptian Army couldn't hold the refineries. They went for Plan B: Plan 'Bomb it to Hell'. (beat) We had to get out of there. Now.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_egyptian_army_co_0" );
	
	//We lost Taylor, but we had a lead. Maretti said Bishop could help us find Deimos. Which meant the Professor was our next stop...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_lost_taylor_but_0" );
}