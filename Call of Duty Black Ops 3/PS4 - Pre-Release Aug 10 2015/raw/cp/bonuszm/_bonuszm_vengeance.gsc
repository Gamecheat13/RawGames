#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#using scripts\cp\bonuszm\_bonuszm;
#using scripts\cp\bonuszm\_bonuszm_sound;
#using scripts\cp\_dialog;
#using scripts\cp\_util;

// VENGEANCE VOX
#using scripts\cp\voice\voice_z_vengeance;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	

function autoexec Init()
{
	if( !( SessionModeIsCampaignZombiesGame() ) )
		return;
	
	mapname = GetDvarString( "mapname" );
	
	if( mapname != "cp_mi_sing_vengeance" )
		return;

	// Dialogue setup	
	voice_z_vengeance::init_voice();	
		
	level.BZM_VENGEANCEDialogue1Callback	= &BZM_VENGEANCEDialogue1; // BONUSZM_VENGEANCE_DLG1
	level.BZM_VENGEANCEDialogue2Callback	= &BZM_VENGEANCEDialogue2; // BONUSZM_VENGEANCE_DLG2
	level.BZM_VENGEANCEDialogue3Callback	= &BZM_VENGEANCEDialogue3; // BONUSZM_VENGEANCE_DLG3
	level.BZM_VENGEANCEDialogue4Callback	= &BZM_VENGEANCEDialogue4; // BONUSZM_VENGEANCE_DLG4
	level.BZM_VENGEANCEDialogue5Callback	= &BZM_VENGEANCEDialogue5; // BONUSZM_VENGEANCE_DLG5
	level.BZM_VENGEANCEDialogue6Callback	= &BZM_VENGEANCEDialogue6; // BONUSZM_VENGEANCE_DLG6
	level.BZM_VENGEANCEDialogue7Callback	= &BZM_VENGEANCEDialogue7; // BONUSZM_VENGEANCE_DLG7
	level.BZM_VENGEANCEDialogue8Callback	= &BZM_VENGEANCEDialogue8; // BONUSZM_VENGEANCE_DLG8
	level.BZM_VENGEANCEDialogue9Callback	= &BZM_VENGEANCEDialogue9; // BONUSZM_VENGEANCE_DLG9
	
	// Add vengeance specific logic in the following function
	BZM_vengeanceSettings();
}

function private BZM_vengeanceSettings()
{
	callback::on_spawned( &BZM_vengeanceOnPlayerSpawned );	
}

function BZM_vengeanceOnPlayerSpawned()
{
	//self AllowDoubleJump( false );
}

function BZM_VENGEANCEDialogue1() // QUARANTINE ZONE WALL IGC AND CHINATOWN
{
	wait 8;
	
	//Getting to the safehouse wouldn't be easy. Under the influence of Goh Xiulan the undead had spread well beyond the wall -- but they weren't our only threat.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_getting_to_the_safeh_0" );
	
	wait 2;	
	
	//The Vultures, sadistic scavengers ravaged by atrocity and time, driven by fear and insanity. We saw their artwork strung up on display the moment we arrived.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_vultures_sadist_0" );
	
	//When forced against a wall the impurities of man can be revealed.
	bonuszmsound::BZM_PlayDrSalimVox( "salm_when_forced_against_0" );	
	
	wait 2;
	
	//This was more than impurity, this was the dark side of survival. Man had nowhere left to run, the only sense of safety and shelter was six feet under. (SIGHS) When only one percent of the world's population is human, you either died and became the undead, or you survived by preying on the living.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_this_was_more_than_i_0" );
}

function BZM_VENGEANCEDialogue2() // INT. SIDE BUILDING
{
	wait 3;

	//I had a bad feeling about this. Going through the undead was one thing, but Vultures... they were fucking savages.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_had_a_bad_feeling_0" );
	
	wait 5;
	
	//The Vultures of Singapore were heavily armed and well equipped. I suppose that's what you get when you prey on your fellow man.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_vultures_of_sing_0" );
	
	//wait 2;
	// Not saying this line as player can kill them without consequence
	//We'd need to take them out quick and quiet -- no reason to draw the undead's attention.
	//bonuszmsound::BZM_PlayPlayerVox( "plyz_we_d_need_to_take_th_0" );	
}
	
function BZM_VENGEANCEDialogue3() // SIDE STREET
{
	//Hendricks took point down the alley, from the sounds of it the dead knew we were coming. (beat) So much for quick and quiet.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_hendricks_took_point_0" );

	wait 6;
	
	//Overwatch confirmed the Vultures were converging on the safehouse. Civilian spotted on site. We kept our head down and moved on.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_overwatch_confirmed_0" );

}

function BZM_VENGEANCEDialogue4() // IMMORTAL BRUTALITY #1
{	
	wait 4;
	
	//Curious... the Vultures' behavior: willing to kill the living and dead alike without prejudice.  (beat) Survival of the Fittest at its most primal, they act with reckless abandon thinking little of consequence. They had to know, the more they killed other humans the slimmer their chances became...
	bonuszmsound::BZM_PlayDrSalimVox( "salm_curious_the_vultu_0" );	
	
	//Don't think of them as humans: they're animals. Abandoned by any form of governing body they dictated their own society. They were tribal. Nomadic. In their eyes we were as much a threat as the undead.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_don_t_think_of_them_0" );	
}

function BZM_VENGEANCEDialogue5() // EXT. ALLEY
{
	//The safehouse was beyond the Gardens, but the Gardens belonged to the dead. They smelled us lurking above. (beat) The Rogue Hunter in the sky certainly didn't help matters.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_safehouse_was_be_0" );
}

function BZM_VENGEANCEDialogue6() // IMMORTAL BRUTALITY #2
{
	wait 4;
	
	//Vultures ahead had alerted Goh Xiulan of our arrival. They were in the middle of displaying their latest “artwork” when we happened to approach the Checkpoint.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_vultures_ahead_had_a_0" );
	
	wait 1;
	
	//What was the purpose of this? The hanging of corpses?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_what_was_the_purpose_0" );
	
	//Territorial. Vultures fought among themselves -- sociopaths at war with everyone and everything. Undead or fellow human -- either way you were a predator competing over the same resources.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_territorial_vulture_0" );
}

function BZM_VENGEANCEDialogue7() // SAFE HOUSE EXTERIOR EXPLOSION
{
	wait 3;
	
	//The Vultures beat us there, set fire to the facility, we had to be quick--
	bonuszmsound::BZM_PlayPlayerVox( "plyz_the_vultures_beat_us_0" );
	
	wait 1;
	
	//Goh Xiulan announced herself over a PA -- she was inside... and she had a “special guest” waiting for us.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_goh_xiulan_announced_0" );
	
	wait 3;
	
	//Hendricks didn't think it was worth it. The building was moments from collapse.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_hendricks_didn_t_thi_0" );
	
	//But you pushed back?	
	bonuszmsound::BZM_PlayDrSalimVox( "salm_but_you_pushed_back_0" );
	
	wait 1;
	
	//We needed that dossier. At this point, it was our only lead to figure out who Deimos was.  (beat) I told Hendricks to call in exfil, I'd take the safehouse. Bishop said the document was hidden in the panic room within the facility.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_needed_that_dossi_0" );
}

function BZM_VENGEANCEDialogue8() // DEFEAT GOH XIULAN IGC
{
	wait 1;	
	//Who did you find in the panic room?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_who_did_you_find_in_0" );
	
	//...her. Our Guardian Angel.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_her_our_guardian_0" );
	
	//I had no idea what she was doing there. It didn't make any sense. She'd been through the ringer, someone had beaten the hell outta her.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_i_had_no_idea_what_s_0" );
	
	wait 3;
	
	//We didn't have to wait long to find out who.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_we_didn_t_have_to_wa_0" );
	
	//Goh Xiulan. We later found out she was there for the same thing we were... the same thing our friend was.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_goh_xiulan_we_later_0" );
	
	//And somehow she'd really managed to piss Goh Xiulan off.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_and_somehow_she_d_re_0" );
	
	wait 30;
	
	//With Goh Xiulan take care of, we cut down our Angel and got the hell outta there.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_with_goh_xiulan_take_0" );
	
	//And the file on Deimos?
	bonuszmsound::BZM_PlayDrSalimVox( "salm_and_the_file_on_deim_0" );
	
	//Most likely it was reduced to kindle. Gone. Or so we thought.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_most_likely_it_was_r_0" );
}

function BZM_VENGEANCEDialogue9()
{
	
	//Hendricks got our transport, Singapore was another dead end.
	bonuszmsound::BZM_PlayPlayerVox( "plyz_hendricks_got_our_tr_0" );
	
	//But we needed a few answers from our Guardian Angel, starting with who the hell she was -- and what she was doing in an abandoned CIA safehouse. The truth proved more eye-opening than we could've imagined...
	bonuszmsound::BZM_PlayPlayerVox( "plyz_but_we_needed_a_few_0" );
}