#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\hijack_code;
                                                    
main()
{
	generic_human();
	player();
	anim_props();
	vehicle_anims();
	president_moveset();
	zero_g_body();
}

#using_animtree( "generic_human" );
generic_human()
{
	// -- INTROSCREEN --
	// Moscow, this is Command Point, en route to Hamburg, skies are clear.
	level.scr_radio[ "hijack_plt_moscow" ] = "hijack_plt_moscow";	
	// All teams, report in.
	level.scr_radio[ "hijack_cmd_reportin" ] = "hijack_cmd_reportin";
	// Team 1, the President's office is secure.
	level.scr_radio[ "hijack_fso1_presidentoffice" ] = "hijack_fso1_presidentoffice";
	// Team 2, lower deck is clear.
	level.scr_radio[ "hijack_fso2_lowerdeckclear" ] = "hijack_fso2_lowerdeckclear";
	// Team 3, forward cabin is secure.
	level.scr_radio[ "hijack_fso3_fowardcabin" ] = "hijack_fso3_fowardcabin";
	// We land in Hamburg in 2 hours.
	level.scr_radio[ "hijack_cmd_landinhamburg" ] = "hijack_cmd_landinhamburg";
	// Team 1, remain with the President until we touch down.
	level.scr_radio[ "hijack_cmd_remainwithpres" ] = "hijack_cmd_remainwithpres";

		
	// -- INTRO HALLWAY --
	//We are currently at an altitude of 11,500 meters at a cruising speed of 5335 knots.		
	level.scr_radio[ "hijack_plt_message1" ] = "hijack_plt_message1";
	//Skies ahead are clear so our flight will be smooth and without incident. 			
	level.scr_radio[ "hijack_plt_message2" ] = "hijack_plt_message2";
	//At our present speed and heading we should arrive at our destination in just under 2 hours. 			
	level.scr_radio[ "hijack_plt_message3" ] = "hijack_plt_message3";

	
	// -- INTRO (In notetracks) --
	//Vasili’s waiting for you, Father.
	//He’s expecting an answer from me.
	//The President is on the move.  Team 1, escorting.	
	//ALT - Team 1 moving.	
	//I don’t like him.
	//No one does. That’s why he’s good at his job.
	//What will you tell him?
	//The truth.
	//He won’t want to hear it.
	//He has no choice. I’m the President.
	//I’ll see you at dinner.
	
	// -- INTRO HALL NAG LINES --
	//Harkov, stay with the President.
	level.scr_radio[ "hijack_cmd_staywithpres" ] = "hijack_cmd_staywithpres";
	//Harkov, take your position.
	level.scr_radio[ "hijack_cmd_takeposition" ] = "hijack_cmd_takeposition";
	
	// -- CONFERENCE ROOM (In notetracks) --
	//Mr. President.
	//Vasilii.
	//Hello, Mr. President.
	//Sir.
	//Mr. President.
	//Gentlemen, we only have two choices - peace or war. Life or death. And for the sake of our children, we must seek peace with the West.
	//Mr. President, now is not the time to appease our enemies.
	//We destroy our enemies when we make friends with them. If we cannot end our differences, at least we can make the world safe --
	level.scr_sound[ "president" ][ "hijack_prs_worldsafe" ] = "hijack_prs_worldsafe";
	
	// -- CONFERENCE ROOM EXT. --
	level.scr_sound[ "generic" ][ "hijack_fem1_scream" ] = "hijack_fem1_scream";
	level.scr_sound[ "generic" ][ "hijack_fem2_scream" ] = "hijack_fem2_scream";
	level.scr_sound[ "generic" ][ "hijack_fem3_scream" ] = "hijack_fem3_scream";
	level.scr_sound[ "generic" ][ "hijack_fso1_pain" ] = "hijack_fso1_pain";
	level.scr_sound[ "generic" ][ "hijack_fso2_pain" ] = "hijack_fso2_pain";
	//Gun! Gun!
	level.scr_sound[ "generic" ][ "hijack_fso1_gungun" ] = "hijack_fso1_gungun";
	//Look out!
	level.scr_sound[ "generic" ][ "hijack_fso2_lookout" ] = "hijack_fso2_lookout";
	
	// -- HIJACK (In notetracks) --	
	
	//That's gunfire.
	//Hijackers are taking the plane! The cockpit's been compromised.
	//Mr. President, get down. Team 3, status report.
	//Damn it team 3, report!
	//Everyone down!  Fedorov, cover the President.
	//All teams we have a Code Red. I repeat ...
	
	// -- HIJACKERS --
	//This is the door. Place the charge!
	level.scr_sound[ "generic" ][ "hijack_hj1_placecharge" ] = "hijack_hj1_placecharge";
	//Done, stand back.
	level.scr_sound[ "generic" ][ "hijack_hj2_standback" ] = "hijack_hj2_standback";
			
	// -- POST DEBATE SIT REP --
	//Harkov, on me.
	level.scr_sound[ "commander" ][ "hijack_cmd_onme" ] = "hijack_cmd_onme";
	
	//Fedorov, Harkov, we're taking the President to safety.
	level.scr_sound[ "commander" ][ "hijack_cmd_safety" ] = "hijack_cmd_safety";
	//Status report.
	level.scr_sound[ "commander" ][ "hijack_cmd_statreport" ] = "hijack_cmd_statreport";
	//They have the daughter in the cargo bay.
	level.scr_radio[ "hijack_fso3_theyhave" ] = "hijack_fso3_theyhave";
	//...in the cockpit...heavy resistance...BANG!...BANG!
	level.scr_radio[ "hijack_fso2_resistance" ] = "hijack_fso2_resistance";
	//...losing control...
	level.scr_radio[ "hijack_plt_losingcontrol" ] = "hijack_plt_losingcontrol";
	//...engines 2 and 3 have stalled!
	level.scr_radio[ "hijack_plt_stalled" ] = "hijack_plt_stalled";
	//We've stalled out!
	level.scr_radio[ "hijack_plt_inadive" ] = "hijack_plt_inadive";
	//We're losing altitude!
	level.scr_radio[ "hijack_plt_losingaltitude" ] = "hijack_plt_losingaltitude";
	
	// -- BACKGROUND RADIO CHATTER --
	//Shot have been fired. I repeat shots have been fired. Hostiles are onboard and have opened fire - we are in emergency lock down. Seal all compartments and secure your respective areas.
	level.scr_radio[ "hijack_fso1_shotsfired" ] = "hijack_fso1_shotsfired";
	//Hostiles have taken the cockpit. Our course has been altered. Current heading is not known. Additional hostiles are reported in the cargo bay and the forward hold. All teams, maintain radio contact at all times.
	level.scr_radio[ "hijack_fso2_altered" ] = "hijack_fso2_altered";
	//We need back up!
	level.scr_radio[ "hijack_fso1_needbackup" ] = "hijack_fso1_needbackup";
	//Shots fired!
	level.scr_radio[ "hijack_fso2_gunshots" ] = "hijack_fso2_gunshots";
	//Return fire! Return fire!
	level.scr_radio[ "hijack_fso3_weaponsfree" ] = "hijack_fso3_weaponsfree";
	//... need a situation report!
	level.scr_radio[ "hijack_fso1_sitrep" ] = "hijack_fso1_sitrep";
	//... alert the Commander ...
	level.scr_radio[ "hijack_fso2_alert" ] = "hijack_fso2_alert";
	
	// -- POST ZERO-G --
	// Team 2, retake the cockpit.
	level.scr_sound[ "commander" ][ "hijack_cmd_retakecockpit" ] = "hijack_cmd_retakecockpit";
	// Team 3, backup is on the way.
	level.scr_sound[ "commander" ][ "hijack_cmd_backuponway" ] = "hijack_cmd_backuponway";

	// -- LOWER LEVEL AGENT --
	//This way, sir.
	level.scr_sound[ "generic" ][ "hijack_fso1_thiswaysir" ] = "hijack_fso1_thiswaysir";
	//Mr. President, we have to keep moving.
	level.scr_sound[ "generic" ][ "hijack_fso1_keepmoving" ] = "hijack_fso1_keepmoving";
	//We have to stay with the group, sir.
	level.scr_sound[ "generic" ][ "hijack_fso1_staywithgroup" ] = "hijack_fso1_staywithgroup";
// NEW-- Everyone stay tight.
	level.scr_sound[ "generic" ][ "hijack_fso1_staytight" ] = "hijack_fso1_staytight";
// NEW-- Don’t get separated.
	level.scr_sound[ "generic" ][ "hijack_fso1_seperated" ] = "hijack_fso1_seperated";
	//Keep going, Mr. President.
	level.scr_sound[ "generic" ][ "hijack_fso1_keepgoing" ] = "hijack_fso1_keepgoing";

	// -- LOWER LEVEL COMMANDER --
	//Keep pushing forward, Harkov.
	level.scr_sound[ "commander" ][ "hijack_cmd_keeppushing" ] = "hijack_cmd_keeppushing";
	//Mr. President, stay out of the line of fire.
	level.scr_sound[ "commander" ][ "hijack_cmd_stayout" ] = "hijack_cmd_stayout";
	// Mr. President, stay behind cover and keep your head down.
	level.scr_sound[ "commander" ][ "hijack_cmd_headdown" ] = "hijack_cmd_headdown";
	//Fedorov, protect the President.
	level.scr_sound[ "commander" ][ "hijack_cmd_protectpres" ] = "hijack_cmd_protectpres";
	//All teams, there are additional hijackers on the lower deck.
	level.scr_sound[ "commander" ][ "hijack_cmd_additionalhijack" ] = "hijack_cmd_additionalhijack";
	//We have to get to the President to the saferoom.
	level.scr_sound[ "commander" ][ "hijack_cmd_prestosaferoom" ] = "hijack_cmd_prestosaferoom";
	//Room clear!
	level.scr_sound[ "commander" ][ "hijack_cmd_roomclear" ] = "hijack_cmd_roomclear";
	
	// -- LOWER LEVEL --
	//Meeting heavy resistance to the cockpit.
	level.scr_radio[ "hijack_fso2_resistance" ] = "hijack_fso2_resistance";
	//We're being driven back from the cockpit.
	level.scr_radio[ "hijack_fso2_drivenback" ] = "hijack_fso2_drivenback";
	//The door to the cockpit is been jammed shut.
	level.scr_radio[ "hijack_fso2_jammedshut" ] = "hijack_fso2_jammedshut";
	//Preparing to retake the cockpit.
	level.scr_radio[ "hijack_fso2_retake" ] = "hijack_fso2_retake";
	
	// -- LOWER LEVEL RADIO ROOM --
	//RPAC - 1 Heavy, descended rapidly to level 3-5-0. Heading 2 - 1 - 0.
	level.scr_radio[ "hijack_fc1_descended" ] = "hijack_fc1_descended";
	//Notify the KGB and FSO.
	level.scr_radio[ "hijack_fc2_kgbandfso" ] = "hijack_fc2_kgbandfso";
	//RPAC - 1 heavy, is still squawking 4352.
	level.scr_radio[ "hijack_fc1_squawking" ] = "hijack_fc1_squawking";
	//Current heading has changed to 1 - 8 - 0.
	level.scr_radio[ "hijack_fc2_heading" ] = "hijack_fc2_heading";
	//Scrambling search and rescue squadrons.
	level.scr_radio[ "hijack_fc1_scrambling" ] = "hijack_fc1_scrambling";
	//RPAC - 1 Heavy, do you copy? RPAC - 1 Heavy do you copy?
	level.scr_radio[ "hijack_fc2_doyoucopy" ] = "hijack_fc2_doyoucopy";
	//RPAC - 1 Heavy, still not responding.
	level.scr_radio[ "hijack_fc1_notresponding" ] = "hijack_fc1_notresponding";
	//RPAC-1 Heavy is still descending at a rapid rate.
	level.scr_radio[ "hijack_fc2_rapidrate" ] = "hijack_fc2_rapidrate";
	//Respond, RPAC-1 - you have to slow your rate of descent immediately.
	level.scr_radio[ "hijack_fc1_slowdescent" ] = "hijack_fc1_slowdescent";
	
	// -- FIND DAUGHTER (in notetracks) --
	//All clear! Daughter secure!
	//Alena ...
	//Father...
	//Let's move the President to the Safe Room. Harkov, Federov, you're with me.

	//-- CRASH --
	
	//Hold on, Harkov!
	level.scr_radio[ "hijack_cmd_holdonhark" ] = "hijack_cmd_holdonhark";
	
// NEW-- Attempting emergency landing!
	level.scr_radio[ "hijack_plt_emergency" ] = "hijack_plt_emergency";
// NEW-- Brace for impact!
	level.scr_radio[ "hijack_plt_brace" ] = "hijack_plt_brace";
	//"We re gonna hit!"	
	level.scr_sound[ "generic" ][ "hijack_fso2_gonnahit" ] = "hijack_fso2_gonnahit";			
	//"Hold on!"
	level.scr_sound[ "generic" ][ "hijack_fso2_holdon" ]  = "hijack_fso2_holdon";				
	//"(Frightened yell)"
	level.scr_sound[ "generic" ][ "hijack_fso1_yell1" ]  = "hijack_fso1_yell1";				
	//"(Frightened yell)"
	level.scr_sound[ "generic" ][ "hijack_fso1_yell2" ]  = "hijack_fso1_yell2";				
	//"(Frightened yell)"
	level.scr_sound[ "generic" ][ "hijack_fso1_yell3" ]  = "hijack_fso1_yell3";				
	
	//-- POST CRASH (in notetracks) --
	//Come on, Agent Harkov. We have to find the President.

	// -- POST CRASH BACKGROUND RADIO --
	//... are hostiles still in the area?
	level.scr_radio[ "hijack_rt1_stillinarea" ] = "hijack_rt1_stillinarea";	
	//... I repeat Command Point is down and not responding ...
	level.scr_radio[ "hijack_rt2_command" ] = "hijack_rt2_command";	
	//... scrambling Alert 5 choppers to last known coordinates ...
	level.scr_radio[ "hijack_rt3_scrambling" ] = "hijack_rt3_scrambling";
	//... two - seven - nine, clearing air space in sector two - one - one ...
	level.scr_radio[ "hijack_rt1_clearing" ] = "hijack_rt1_clearing";
	//... has the threat been neutralized ...
	level.scr_radio[ "hijack_rt2_neutralized" ] = "hijack_rt2_neutralized";
	//... multiple dead and severely wounded ...
	level.scr_radio[ "hijack_rt3_wounded" ] = "hijack_rt3_wounded";	
	//... attempting to verify location trajectories are set ...
	level.scr_radio[ "hijack_rt1_verifylocation" ] = "hijack_rt1_verifylocation";
	// ...last known position was 240 kilometers outside Hamburg, Germany...
	level.scr_radio[ "hijack_rt2_hamburg" ] = "hijack_rt2_hamburg";
	// ... flight path had us crossing the German border just before the hijackers attacked ...
	level.scr_radio[ "hijack_fso1_flightpath" ] = "hijack_fso1_flightpath";

	// -- TARMAC DAUGHTER SECURE --
	//Form a perimeter and secure the daughter.
	level.scr_sound[ "commander" ][ "hijack_cmd_perimeter" ]  = "hijack_cmd_perimeter";
	//Harkov, you’re with me. We’re got to find the President.
	level.scr_sound[ "commander" ][ "hijack_cmd_findpresident2" ]  = "hijack_cmd_findpresident2";
	//Keep moving, Harkov.
	level.scr_sound[ "commander" ][ "hijack_cmd_keepmoving2" ]  = "hijack_cmd_keepmoving2";
	//Harkov, come on.
	level.scr_sound[ "commander" ][ "hijack_cmd_comeon" ]  = "hijack_cmd_comeon";
	//Let's go.
	level.scr_sound[ "commander" ][ "hijack_cmd_letsgo" ]  = "hijack_cmd_letsgo";
	

	// -- TARMAC CHATTER --
	//Command Point beacons active and online ... two - four responding with multiple signals ... confirming authenticity ...
	level.scr_radio[ "hijack_rt1_beacons" ] = "hijack_rt1_beacons";
	//... situation reports are incoming ... secure channels active ...
	level.scr_radio[ "hijack_rt2_channels" ] = "hijack_rt2_channels";
	//... Search and Rescue en route, you’ve got choppers in ETA 10 minutes ...
	level.scr_radio[ "hijack_rt3_eta10mins" ] = "hijack_rt3_eta10mins";
	level.scr_radio[ "hijack_rt3_eta10mins_b" ] = "hijack_rt3_eta10mins_b";
	
	//We’ve got an injured man!
	level.scr_sound[ "generic" ][ "hijack_fso1_injuredman" ]  = "hijack_fso1_injuredman";
	//Help! Help me!
	level.scr_sound[ "generic" ][ "hijack_fso3_helpme" ]  = "hijack_fso3_helpme";
	//Agent down! There’s an agent down here!
	level.scr_sound[ "generic" ][ "hijack_fso1_agentdown" ]  = "hijack_fso1_agentdown";
	//How did they breach our security?
	level.scr_sound[ "plane_exit_agent1" ][ "hijack_fso1_howdidthey" ]  = "hijack_fso1_howdidthey";
	//It had to be someone on the inside.  They knew to hit the comm room first.
	level.scr_sound[ "plane_exit_agent2" ][ "hijack_fso2_theyknew2" ]  = "hijack_fso2_theyknew2";
	// My arm - ah, my arm!!
	level.scr_sound[ "generic" ][ "hijack_fso1_myarm" ]  = "hijack_fso1_myarm";
	// Where’s a medical kit!?
	level.scr_sound[ "generic" ][ "hijack_fso2_medical" ]  = "hijack_fso2_medical";

	// -- TARMAC REACTIONS --
	// ENGINE BLOWS UP
	level.scr_sound[ "generic" ][ "hijack_fso1_surprise" ]  = "hijack_fso1_surprise";
	level.scr_sound[ "generic" ][ "hijack_fso2_surprise" ]  = "hijack_fso2_surprise";
// NEW-- Misc. yells and screams.	
	level.scr_sound[ "generic" ][ "hijack_fso1_cough" ]  = "hijack_fso1_cough";
	level.scr_sound[ "generic" ][ "hijack_fso1_cough2" ]  = "hijack_fso1_cough2";
	level.scr_sound[ "generic" ][ "hijack_fso1_moan" ]  = "hijack_fso1_moan";
	level.scr_sound[ "generic" ][ "hijack_fso1_moan2" ]  = "hijack_fso1_moan2";
	level.scr_sound[ "generic" ][ "hijack_fso1_yellofpain" ]  = "hijack_fso1_yellofpain";
	level.scr_sound[ "generic" ][ "hijack_fso1_yellofpain2" ]  = "hijack_fso1_yellofpain2";
	level.scr_sound[ "generic" ][ "hijack_fso1_longyell" ]  = "hijack_fso1_longyell";
// NEW-- Misc. yells and screams.		
	level.scr_sound[ "generic" ][ "hijack_fso2_cough" ]  = "hijack_fso2_cough";
	level.scr_sound[ "generic" ][ "hijack_fso2_cough2" ]  = "hijack_fso2_cough2";
	level.scr_sound[ "generic" ][ "hijack_fso2_moan" ]  = "hijack_fso2_moan";
	level.scr_sound[ "generic" ][ "hijack_fso2_moan2" ]  = "hijack_fso2_moan2";
	level.scr_sound[ "generic" ][ "hijack_fso2_yellofpain" ]  = "hijack_fso2_yellofpain";
	level.scr_sound[ "generic" ][ "hijack_fso2_yellofpain2" ]  = "hijack_fso2_yellofpain2";
	level.scr_sound[ "generic" ][ "hijack_fso2_longyell" ]  = "hijack_fso2_longyell";
// NEW-- Misc. yells and screams.		
	level.scr_sound[ "generic" ][ "hijack_fso3_cough" ]  = "hijack_fso3_cough";
	level.scr_sound[ "generic" ][ "hijack_fso3_cough2" ]  = "hijack_fso3_cough2";
	level.scr_sound[ "generic" ][ "hijack_fso3_moan" ]  = "hijack_fso3_moan";
	level.scr_sound[ "generic" ][ "hijack_fso3_moan2" ]  = "hijack_fso3_moan2";
	level.scr_sound[ "generic" ][ "hijack_fso3_yellofpain" ]  = "hijack_fso3_yellofpain";
	level.scr_sound[ "generic" ][ "hijack_fso3_yellofpain2" ]  = "hijack_fso3_yellofpain2";
	level.scr_sound[ "generic" ][ "hijack_fso3_longyell" ]  = "hijack_fso3_longyell";
	
	
	// -- TARMAC BACKGROUND CHATTER --
	//Requesting confirmation of Search and Rescue.
	level.scr_radio[ "hijack_fso1_confirmation" ] = "hijack_fso1_confirmation";
	//Search and Rescue will be on the scene on 10 minutes.
	level.scr_radio[ "hijack_rt1_onsceneinten" ] = "hijack_rt1_onsceneinten";
	//Cordon off the area ...
	level.scr_radio[ "hijack_fso2_cordonoff" ] = "hijack_fso2_cordonoff";
	//We have to move all personnel ASAP - the tanks are leaking jet fuel.
	level.scr_radio[ "hijack_fso3_leakingfuel" ] = "hijack_fso3_leakingfuel";
	//Team 3, locate the black box for telemetry data.
	level.scr_radio[ "hijack_rt1_blackbox" ] = "hijack_rt1_blackbox";
	//Roger that. Searching for black box.
	level.scr_radio[ "hijack_fso3_blackbox" ] = "hijack_fso3_blackbox";
	//We need additional medical personnel - an agent’s gone into shock.
	level.scr_radio[ "hijack_fso2_medical" ] = "hijack_fso2_medical";
	//A satcom link has been established with the FSO. Help is on the way.
	level.scr_radio[ "hijack_fso1_satcom" ] = "hijack_fso1_satcom";
	//The cockpit’s completely destroyed.
	level.scr_radio[ "hijack_fso3_cockpit" ] = "hijack_fso3_cockpit";
	//This is Team 2 - confirming heavy casualties in the tail section.
	level.scr_radio[ "hijack_fso2_tailsection" ] = "hijack_fso2_tailsection";
	
	// -- TARMAC COMMANDER CHATTER
	//All teams, secure your immediate location. Evac is on the way.
	level.scr_sound[ "commander" ][ "hijack_cmd_evacontheway" ]  = "hijack_cmd_evacontheway";
	//Team 4, report.
	level.scr_sound[ "commander" ][ "hijack_cmd_team4report" ]  = "hijack_cmd_team4report";
	//The President is wounded but stable.
	level.scr_radio[ "hijack_fso4_wounded" ] = "hijack_fso4_wounded";
	//Moving to your location now. Secure the area until evac arrives.
 	level.scr_sound[ "commander" ][ "hijack_cmd_securearea" ]  = "hijack_cmd_securearea";
 	
	// Sending up a flare from our location.
	level.scr_radio[ "hijack_fso4_sendingflare" ] = "hijack_fso4_sendingflare";
	// There’s the flare, right side.
	level.scr_sound[ "commander" ][ "hijack_cmd_theflare" ]  = "hijack_cmd_theflare";
	// We’re on our way.
	level.scr_sound[ "commander" ][ "hijack_cmd_onourway" ]  = "hijack_cmd_onourway"; 	
 	
	//Evac choppers are here. Let’s move, Harkov.
	level.scr_sound[ "commander" ][ "hijack_cmd_evacchoppers" ]  = "hijack_cmd_evacchoppers";
	
	// -- TARMAC COMBAT
	//This is Team 4. We’re taking heavy fire and multiple enemy vehicles are inbound.
	level.scr_radio[ "hijack_fso4_heavyfire" ] = "hijack_fso4_heavyfire";
	// The President is not secure; we need backup immediately.
	level.scr_radio[ "hijack_fso4_notsecure" ] = "hijack_fso4_notsecure";
	// Team 2, get Alena out of there. All other agents close in on the president’s location.
	level.scr_sound[ "commander" ][ "hijack_cmd_getalenaout" ]  = "hijack_cmd_getalenaout";
	// -- Harkov, we have to move!	
	level.scr_sound[ "commander" ][ "hijack_cmd_wehavetomove" ]  = "hijack_cmd_wehavetomove";
	//  Additional enemy positions near the hangar and closing!
	level.scr_radio[ "hijack_fso1_nearhangar" ] = "hijack_fso1_nearhangar";
	// - Let’s move it, Harkov!
	level.scr_sound[ "commander" ][ "hijack_cmd_letsmoveit" ]  = "hijack_cmd_letsmoveit";
	//  Keep pushing forward!
	level.scr_sound[ "commander" ][ "hijack_cmd_keeppushing2" ]  = "hijack_cmd_keeppushing2";
	//  3 agents down. Multiple wounded. We’re losing ground. 
	level.scr_radio[ "hijack_fso2_multiplewounded" ] = "hijack_fso2_multiplewounded";
	//  Move up! Move up!
	level.scr_sound[ "commander" ][ "hijack_cmd_moveupmoveup" ]  = "hijack_cmd_moveupmoveup";
	// All agents, our situation is critical. The President’s safety has been compromised!
	level.scr_radio[ "hijack_fso3_critical" ] = "hijack_fso3_critical";
	//Code black! Code black!
	level.scr_radio[ "hijack_fso3_codeblack" ] = "hijack_fso3_codeblack";
	//Take them down!
	level.scr_sound[ "commander" ][ "hijack_cmd_takethemdown" ]  = "hijack_cmd_takethemdown";
	//FSO inbound. How your fire! Hold your fire!
	level.scr_sound[ "commander" ][ "hijack_cmd_holdyourfire" ]  = "hijack_cmd_holdyourfire";
	
	//There’s the President.
	level.scr_sound[ "commander" ][ "hijack_cmd_thepresident" ]  = "hijack_cmd_thepresident";
	
	// -- END SCENE PRESIDENT FOUND (in notetracks?)
	//Mr. President, we have to get you out of here.
	level.scr_sound[ "commander" ][ "hijack_cmd_getyouout" ]  = "hijack_cmd_getyouout";
	// Where's my daughter?
	level.scr_sound[ "president" ][ "hijack_prs_wheresmy" ]  = "hijack_prs_wheresmy";
	//She’s being secured, sir. We need to move you now!
	level.scr_sound[ "commander" ][ "hijack_cmd_moveyounow" ]  = "hijack_cmd_moveyounow";

	// Harkov, open the door!
	level.scr_sound[ "commander" ][ "hijack_cmd_openthedoor2" ]  = "hijack_cmd_openthedoor2";
	
	//"Our rescue is here!"
	//level.scr_sound[ "commander" ][ "hijack_cmd_rescuehere" ] = "hijack_cmd_rescuehere";			
	//"And now that I have your attention, Mr. President - let us discuss how we will finish this war by destroying America."
	level.scr_sound[ "makarov" ][ "hijack_mkv_yourattention" ] = "hijack_mkv_yourattention";
	//All teams, the daughter is secured.  Repeat, the…
	level.scr_radio[ "hijack_fso3_allteams" ] = "hijack_fso3_allteams";
			
	//-- GENERAL ANIMS --
	level.scr_anim[ "generic" ][ "patrol_walk" ]				  			= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_stop" ]				  			= %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]				  			= %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]				 			= %patrol_bored_2_walk_180turn;
	
	level.scr_anim[ "generic" ][ "stand_death_shoulder_spin" ]				= %stand_death_shoulder_spin;
	level.scr_anim[ "commander" ][ "cqb_stand_aim5" ]						= %cqb_stand_aim5;
	
	level.scr_anim[ "human" ][ "cowerstand_react_to_crouch" ]				= %unarmed_cowerstand_react_2_crouch;
	
	level.scr_anim[ "generic" ][ "hallway_dead_pose_agent" ][0]				= %hijack_hallway_dead_pose_agent;
	level.scr_anim[ "generic" ][ "hallway_dead_pose_terrorist" ][0]			= %hijack_hallway_dead_pose_terrorist;
	level.scr_anim[ "generic" ][ "hallway_dead_pose_assistant" ][0]			= %hijack_hallway_dead_pose_assistant;
	level.scr_anim[ "crawl_death_1" ][ "crawl" ]							= %dying_crawl;
	level.scr_anim[ "crawl_death_1" ][ "death" ][0]							= %dying_crawl_death_v3;
	
	//-- INTRO ROOM --
	
	/*level.scr_anim[ "advisor" ][ "cower_idle" ][0]				 			= %unarmed_cowercrouch_idle;
	level.scr_anim[ "advisor" ][ "cower_idle_duck" ][0]				 		= %unarmed_cowercrouch_idle_duck;*/

	level.scr_anim[ "president" ][ "intro_scene" ]				 			= %hijack_intro_cine_president;
		addNotetrack_customFunction( "president", "notify_conf_room", maps\hijack_airplane::intro_conf_room, "intro_scene" );
	level.scr_anim[ "president" ][ "intro_cine_president_wait_loop" ][0]	= %hijack_intro_cine_president_wait_loop;
	level.scr_anim[ "daughter" ][ "intro_scene" ]				 			= %hijack_intro_cine_daughter;
	level.scr_anim[ "hero_agent" ][ "intro_scene" ]				 			= %hijack_intro_cine_hero_agent;
	level.scr_anim[ "hero_agent" ][ "intro_cine_hero_agent_loop" ][0]		= %hijack_intro_cine_hero_agent_loop;
	level.scr_anim[ "assistant" ][ "intro_scene" ]				 			= %hijack_intro_cine_assistant;
		addNotetrack_customFunction( "assistant", "open_door2", maps\hijack_airplane::intro_asst_door, "intro_scene" );
	level.scr_anim[ "advisor" ][ "intro_cine_advisor" ]				 		= %hijack_intro_cine_advisor;
	level.scr_anim[ "advisor" ][ "intro_cine_advisor_wait_loop" ][0]		= %hijack_intro_cine_advisor_wait_loop;
	level.scr_anim[ "commander" ][ "intro_cine_commander" ]				 	= %hijack_intro_cine_commander;
	level.scr_anim[ "commander" ][ "intro_cine_commander_wait_loop" ][0]	= %hijack_intro_cine_commander_wait_loop;	
	// -secondary guys-
	level.scr_anim[ "secretary" ][ "intro_cine_secretary" ]					= %hijack_intro_cine_secretary;
	level.scr_anim[ "secretary" ][ "intro_cine_secretary_wait_loop" ][0]	= %hijack_intro_cine_secretary_wait_loop;	
	level.scr_anim[ "generic" ][ "intro_cine_agent" ]						= %hijack_intro_cine_agent;
		addNotetrack_customFunction( "generic", "open_door3", maps\hijack_airplane::debate_open_first_door_intro, "intro_cine_agent" );
	level.scr_anim[ "generic" ][ "intro_cine_agent_loop" ][0]				= %hijack_intro_cine_agent_loop;
	level.scr_anim[ "generic" ][ "intro_cine_agent_close_door" ]			= %hijack_intro_cine_agent_close_door;
		addNotetrack_customFunction( "generic", "close_door3", maps\hijack_airplane::debate_close_first_door, "intro_cine_agent_close_door" );	
	level.scr_anim[ "generic" ][ "intro_cine_agent_guard" ]					= %hijack_intro_cine_agent_guard;
	level.scr_anim[ "generic" ][ "intro_cine_agent_guard_loop" ][0]			= %hijack_intro_cine_agent_guard_loop;	
	level.scr_anim[ "generic" ][ "intro_cine_agent2" ]						= %hijack_intro_cine_agent2;
	level.scr_anim[ "generic" ][ "intro_cine_agent2_loop" ][0]				= %hijack_intro_cine_agent2_loop;
	level.scr_anim[ "generic" ][ "intro_cine_agent3" ]						= %hijack_intro_cine_agent3;
	level.scr_anim[ "generic" ][ "intro_cine_agent3_loop" ][0]				= %hijack_intro_cine_agent3_loop;
	
	level.scr_anim[ "polit_1" ][ "intro_cine_politician1" ]					= %hijack_intro_cine_politician1;
	level.scr_anim[ "polit_1" ][ "intro_cine_politician1_loop" ][0]			= %hijack_intro_cine_politician1_loop;	
	level.scr_anim[ "polit_2" ][ "intro_cine_politician2" ]					= %hijack_intro_cine_politician2;
	level.scr_anim[ "polit_2" ][ "intro_cine_politician2_loop" ][0]			= %hijack_intro_cine_politician2_loop;	
	// -ambient guys-
	level.scr_anim[ "generic" ][ "intro_worker_checklist" ]					= %hijack_intro_worker_checklist;
	level.scr_anim[ "generic" ][ "intro_worker_checklist_loop" ][0]			= %hijack_intro_worker_checklist_loop;
	level.scr_anim[ "generic" ][ "intro_kitchenette_guy1" ]					= %hijack_intro_kitchenette_guy1;
	level.scr_anim[ "generic" ][ "intro_kitchenette_guy1_loop" ][0]			= %hijack_intro_kitchenette_guy1_loop;
	level.scr_anim[ "generic" ][ "intro_kitchenette_guy2" ]					= %hijack_intro_kitchenette_guy2;
	level.scr_anim[ "generic" ][ "intro_kitchenette_guy2_loop" ][0]			= %hijack_intro_kitchenette_guy2_loop;
	level.scr_anim[ "generic" ][ "intro_storage_guy" ]						= %hijack_intro_storage_guy;
	level.scr_anim[ "generic" ][ "intro_storage_guy_loop" ][0]				= %hijack_intro_storage_guy_loop;
	
	//-- DEBATE & HIJACK --	
	level.scr_anim[ "president" ][ "debate" ]				 				= %hijack_debate_cine_president;
	level.scr_anim[ "president" ][ "debate_cine_president_end_loop" ][0]	= %hijack_debate_cine_president_end_loop;
	
	level.scr_anim[ "advisor" ][ "debate" ]				 					= %hijack_debate_cine_advisor;
	level.scr_anim[ "advisor" ][ "debate_cine_advisor_end_loop" ][0]		= %hijack_debate_cine_advisor_end_loop;
	
	level.scr_anim[ "commander" ][ "debate" ]				 				= %hijack_debate_cine_commander;
	level.scr_anim[ "commander" ][ "debate_cine_commander_end_loop" ][0]	= %hijack_debate_cine_commander_end_loop;
	
	level.scr_anim[ "secretary" ][ "debate" ]								= %hijack_debate_cine_secretary;
	//level.scr_anim[ "secretary" ][ "debate_cine_secretary_wait_loop" ][0]	= %hijack_debate_cine_secretary_wait_loop;
	level.scr_anim[ "secretary" ][ "debate_cine_secretary_death" ]			= %hijack_debate_cine_secretary_death;
	//level.scr_anim[ "secretary" ][ "debate_cine_secretary_survive" ]		= %hijack_debate_cine_secretary_survive;
	
	level.scr_anim[ "generic" ][ "debate_cine_hijacker1_breach" ]			= %hijack_debate_cine_hijacker1_breach;
	level.scr_anim[ "generic" ][ "debate_cine_hijacker2_breach" ]			= %hijack_debate_cine_hijacker2_breach;
	
	level.scr_anim[ "generic" ][ "debate_cine_agent_rescue" ]				= %hijack_debate_cine_agent_rescue;
		addNotetrack_customFunction( "generic", "open_door3", maps\hijack_airplane::debate_open_first_door, "debate_cine_agent_rescue" );
	level.scr_anim[ "generic" ][ "debate_cine_agent_rescue_loop" ][0]		= %hijack_debate_cine_agent_rescue_loop;
	
	level.scr_anim[ "hero_agent" ][ "debate" ]								= %hijack_debate_cine_hero_agent;
	level.scr_anim[ "hero_agent" ][ "debate_cine_hero_agent_end_loop" ][0]	= %hijack_debate_cine_hero_agent_end_loop;
	
	level.scr_anim[ "generic" ][ "debate" ]									= %hijack_debate_cine_agent2;
	level.scr_anim[ "generic" ][ "debate_cine_agent2_end_loop" ][0]			= %hijack_debate_cine_agent2_end_loop;
	
	level.scr_anim[ "polit_1" ][ "debate" ]									= %hijack_debate_cine_politician1;
	level.scr_anim[ "polit_1" ][ "debate_cine_politician1_death_loop" ][0]	= %hijack_debate_cine_politician1_death_loop;
	level.scr_anim[ "polit_2" ][ "debate" ]									= %hijack_debate_cine_politician2;
	level.scr_anim[ "polit_2" ][ "debate_cine_politician2_death_loop" ][0]	= %hijack_debate_cine_politician2_death_loop;

	//-- PRE-ZERO-G MOMENT --	
	level.scr_anim[ "commander" ][ "hero_stumble" ]						= %hijack_pre_zero_g_hero_stumble;
	level.scr_anim[ "generic" ][ "hallway_slump_agent" ]					= %hijack_hallway_slump_agent;
	level.scr_anim[ "generic" ][ "hallway_slump_terrorist" ]				= %hijack_hallway_slump_terrorist;
	level.scr_anim[ "generic" ][ "hallway_slump_assistant" ]				= %hijack_hallway_slump_assistant;
	
	//-- ZERO-G MOMENT --
	level.scr_anim[ "zerog_terrorist1" ][ "zerog_moment" ]					= %hijack_zerog_terrorist_01_alive;
	level.scr_anim[ "zerog_terrorist2" ][ "zerog_moment" ]					= %hijack_zerog_terrorist_02_alive;
	level.scr_anim[ "zerog_terrorist3" ][ "zerog_moment" ]					= %hijack_zerog_terrorist_03_alive;
	level.scr_anim[ "zerog_terrorist4" ][ "zerog_moment" ]					= %hijack_zerog_terrorist_04_alive;
	level.scr_anim[ "zerog_terrorist5" ][ "zerog_moment" ]					= %hijack_zerog_terrorist_05_alive;
	//level.scr_anim[ "zerog_terrorist1" ][ "zerog_moment_dead" ]				= %hijack_zerog_terrorist_01_dead;
	level.scr_anim[ "agent2" ][ "zerog_moment" ]							= %hijack_zerog_agent_01;
	level.scr_anim[ "agent1" ][ "zerog_moment" ]							= %hijack_zerog_agent_02;
	level.scr_anim[ "agent1" ][ "cockpit_door_bash_enter" ]					= %hijack_cockpit_door_bash_enter;
	level.scr_anim[ "agent1" ][ "cockpit_door_bash_loop" ][0]				= %hijack_cockpit_door_bash_loop;
	level.scr_anim[ "commander" ][ "zerog_hero_agent" ]						= %hijack_zerog_hero_agent;
	level.scr_anim[ "commander" ][ "zerog_commander_alt" ]					= %hijack_zerog_commander_alt;
	
	level.scr_animtree["zerog_terror1_track"] = #animtree;
	level.scr_model[ "zerog_terror1_track" ] = "generic_prop_raven";
	level.scr_anim[ "zerog_terror1_track" ][ "zerog_terrorist_01_align" ] = %hijack_zerog_terrorist_01_align;
	
	level.scr_animtree["zerog_terror2_track"] = #animtree;
	level.scr_model[ "zerog_terror2_track" ] = "generic_prop_raven";
	level.scr_anim[ "zerog_terror2_track" ][ "zerog_terrorist_02_align" ] = %hijack_zerog_terrorist_02_align;
	
	level.scr_animtree["zerog_terror3_track"] = #animtree;
	level.scr_model[ "zerog_terror3_track" ] = "generic_prop_raven";
	level.scr_anim[ "zerog_terror3_track" ][ "zerog_terrorist_03_align" ] = %hijack_zerog_terrorist_03_align;
	
	level.scr_animtree["zerog_terror4_track"] = #animtree;
	level.scr_model[ "zerog_terror4_track" ] = "generic_prop_raven";
	level.scr_anim[ "zerog_terror4_track" ][ "zerog_terrorist_04_align" ] = %hijack_zerog_terrorist_04_align;
	
	level.scr_animtree["zerog_terror5_track"] = #animtree;
	level.scr_model[ "zerog_terror5_track" ] = "generic_prop_raven";
	level.scr_anim[ "zerog_terror5_track" ][ "zerog_terrorist_05_align" ] = %hijack_zerog_terrorist_05_align;
	
	
	//-- LOWER LEVEL COMBAT --
	level.scr_anim[ "generic" ][ "hijack_diningroom_bar_terrorist" ]		= %hijack_diningroom_bar_terrorist;
	level.scr_anim[ "generic" ][ "hijack_diningroom_door_terrorist" ]		= %hijack_diningroom_door_terrorist;
	level.scr_anim[ "generic" ][ "hijack_generic_stumble_crouch1" ]			= %hijack_generic_stumble_crouch1;
	level.scr_anim[ "generic" ][ "hijack_generic_stumble_crouch2" ]			= %hijack_generic_stumble_crouch2;
	level.scr_anim[ "generic" ][ "hijack_generic_stumble_stand1" ]			= %hijack_generic_stumble_stand1;
	level.scr_anim[ "generic" ][ "hijack_generic_stumble_stand2" ]			= %hijack_generic_stumble_stand2;
	
	level.scr_anim[ "daughter" ][ "pre_find_daughter" ] 					= %hijack_pre_find_daughter_alena;
	level.scr_anim[ "generic" ][ "pre_find_daughter" ]						= %hijack_pre_find_daughter_enemy;
	level.scr_anim[ "daughter" ][ "pre_find_daughter_short" ] 				= %hijack_pre_find_daughter_alena_short;
	level.scr_anim[ "generic" ][ "pre_find_daughter_short" ]				= %hijack_pre_find_daughter_enemy_short;
	
	//-- FIND DAUGHTER MOMENT -- 
	level.scr_anim[ "generic" ][ "find_daughter_enter" ] 					= %hijack_find_daughter_agent_enter;
	level.scr_anim[ "commander" ][ "find_daughter_enter" ] 					= %hijack_find_daughter_commander_enter;
	level.scr_anim[ "commander" ][ "door1" ]								= %hijack_find_daughter_commander_door1;
	level.scr_anim[ "commander" ][ "find_daughter_commander_loop" ][0]		= %hijack_find_daughter_commander_loop;
	level.scr_anim[ "daughter" ][ "daughter_cry_loop" ][0]					= %hijack_find_daughter_cry_loop;
	level.scr_anim[ "daughter" ][ "find_daughter_enter" ] 					= %hijack_find_daughter_elena_found;
	level.scr_anim[ "daughter" ][ "post_find_loop" ][0]						= %hijack_find_daughter_elena_loop2;
	level.scr_anim[ "president" ][ "find_daughter_enter" ] 					= %hijack_find_daughter_president_enter;
	level.scr_anim[ "president" ][ "post_find_loop" ][0]					= %hijack_find_daughter_president_loop;
	level.scr_anim[ "commander" ][ "corner_standL_alert_twitch04" ][0]		= %corner_standL_alert_twitch04;
	
	
	//-- CRASH SEQUENCE -- 
	level.scr_anim[ "generic" ][ "planecrash_enemy1" ]						= %hijack_plane_crash_enemy1;
	level.scr_anim[ "generic" ][ "planecrash_enemy2" ]						= %hijack_plane_crash_enemy2;
	level.scr_anim[ "generic" ][ "planecrash_enemy3" ]						= %hijack_plane_crash_enemy3;
	level.scr_anim[ "generic" ][ "planecrash_enemy4" ]						= %hijack_plane_crash_enemy4;
	level.scr_anim[ "generic" ][ "planecrash_enemy5" ]						= %hijack_plane_crash_enemy5;
	level.scr_anim[ "generic" ][ "planecrash_enemy6" ]						= %hijack_plane_crash_enemy6;
	
	addNotetrack_customFunction( "generic", "fire", maps\hijack_crash_fx::custom_fire_fx, "planecrash_enemy1" );
	addNotetrack_customFunction( "generic", "fire", maps\hijack_crash_fx::custom_fire_fx, "planecrash_enemy2" );
	addNotetrack_customFunction( "generic", "fire", maps\hijack_crash_fx::custom_fire_fx, "planecrash_enemy3" );
	addNotetrack_customFunction( "generic", "fire", maps\hijack_crash_fx::custom_fire_fx, "planecrash_enemy4" );
	addNotetrack_customFunction( "generic", "fire", maps\hijack_crash_fx::custom_fire_fx, "planecrash_enemy5" );
	addNotetrack_customFunction( "generic", "fire", maps\hijack_crash_fx::custom_fire_fx, "planecrash_enemy6" );
	
	level.scr_anim[ "generic" ][ "planecrash_agent1" ]						= %hijack_plane_crash_agent;
	level.scr_anim[ "commander" ][ "commander_blocks_door_right" ]			= %hijack_find_daughter_commander_door2r;
	level.scr_anim[ "commander" ][ "commander_blocks_door_left" ]			= %hijack_find_daughter_commander_door2l;
	level.scr_anim[ "commander" ][ "commander_planecrash_idle" ][0] 			= %hijack_plane_crash_commander_loop;
	
 	// -- POST-CRASH --
	level.scr_anim[ "commander" ][ "help_player_up" ]						= %hijack_tarmac_agent_helps_agent;
	level.scr_anim[ "commander" ][ "exit_top_idle" ][0]						= %hijack_exit_plane_idle_top_commander;
	level.scr_anim[ "commander" ][ "exit_down_ramp" ]						= %hijack_exit_plane_commander;
	level.scr_anim[ "commander" ][ "exit_bottom_idle" ][0]					= %hijack_exit_plane_idle_commander;

	level.scr_anim[ "commander" ][ "secure_daughter" ]						= %hijack_secure_daughter_commander;
	level.scr_anim[ "plane_exit_agent1" ][ "secure_daughter" ]				= %hijack_secure_daughter_agent1;
	level.scr_anim[ "plane_exit_agent2" ][ "secure_daughter" ]				= %hijack_secure_daughter_agent2;
	level.scr_anim[ "daughter" ][ "secure_daughter" ]						= %hijack_secure_daughter_elena;
	
	level.scr_anim[ "plane_exit_agent1" ][ "secure_daughter_loop" ][0]		= %hijack_secure_daughter_end_loop_agent1;
	level.scr_anim[ "plane_exit_agent2" ][ "secure_daughter_loop" ][0]		= %hijack_secure_daughter_end_loop_agent2;
	level.scr_anim[ "daughter" ][ "secure_daughter_loop" ][0]				= %hijack_secure_daughter_end_loop_elena;

	// -- TARMAC --
	level.scr_anim[ "generic" ][ "injured_hands_on_knees" ][0]						= %hijack_tarmac_injured_hands_on_knees;
	level.scr_anim[ "generic" ][ "injured_on_back" ][0]								= %hijack_tarmac_injured_on_back;
	level.scr_anim[ "generic" ][ "injured_leg_loop" ][0]							= %hijack_tarmac_injured_leg_loop;

	level.scr_anim[ "checkguy" ][ "checkdeadguy_start" ]							= %hijack_tarmac_checkdeadguy_start;
	level.scr_anim[ "checkguy" ][ "checkdeadguy_loop" ][0]							= %hijack_tarmac_checkdeadguy_loop;
	level.scr_anim[ "deadguy" ][ "checkdeadguy_start" ]								= %hijack_tarmac_deadguy_start;
	level.scr_anim[ "deadguy" ][ "checkdeadguy_loop" ][0]							= %hijack_tarmac_deadguy_loop;
	
	level.scr_anim[ "generic" ][ "scout_finds_buried_hijacker" ]					= %hijack_tarmac_scout;
	level.scr_anim[ "generic" ][ "buried_hijacker" ]								= %hijack_tarmac_burried_terrorist;
	
	level.scr_anim[ "generic" ][ "drag_from_engine_agent1" ]						= %hijack_tarmac_drag_from_engine_agent1;
	level.scr_anim[ "generic" ][ "drag_from_engine_agent1_loop" ][0]				= %hijack_tarmac_drag_from_engine_agent1_loop;
	level.scr_anim[ "generic" ][ "drag_from_engine_agent2" ]						= %hijack_tarmac_drag_from_engine_agent2;
	level.scr_anim[ "generic" ][ "drag_from_engine_agent2_loop" ][0]				= %hijack_tarmac_drag_from_engine_agent2_loop;
	level.scr_anim[ "generic" ][ "drag_from_engine_agent3" ]						= %hijack_tarmac_drag_from_engine_agent3;
	level.scr_anim[ "generic" ][ "drag_from_engine_agent3_loop" ][0]				= %hijack_tarmac_drag_from_engine_agent3_loop;

	level.scr_anim[ "generic" ][ "reach_to_explosion_agent1_loop_start" ][0]		= %hijack_tarmac_react_to_explosion_agent1_loop_start;
	level.scr_anim[ "generic" ][ "reach_to_explosion_agent1" ]						= %hijack_tarmac_react_to_explosion_agent1;
	level.scr_anim[ "generic" ][ "reach_to_explosion_agent1_loop_end" ][0]			= %hijack_tarmac_react_to_explosion_agent1_loop_end;
	level.scr_anim[ "generic" ][ "reach_to_explosion_agent2_loop_start" ][0]		= %hijack_tarmac_react_to_explosion_agent2_loop_start;
	level.scr_anim[ "generic" ][ "reach_to_explosion_agent2" ]						= %hijack_tarmac_react_to_explosion_agent2;
	level.scr_anim[ "generic" ][ "reach_to_explosion_agent2_loop_end" ][0]			= %hijack_tarmac_react_to_explosion_agent2_loop_end;
	
	level.scr_anim[ "generic" ][ "samaritan_start" ]								= %hijack_tarmac_samaritan_start;
	level.scr_anim[ "generic" ][ "samaritan_loop" ][0]								= %hijack_tarmac_samaritan_loop;
	level.scr_anim[ "generic" ][ "limping_agent_start" ]							= %hijack_tarmac_limping_agent_start;
	level.scr_anim[ "generic" ][ "limping_agent_loop" ][0]							= %hijack_tarmac_limping_agent_loop;
	level.scr_anim[ "generic" ][ "trapped_agent_start" ]							= %hijack_tarmac_trapped_agent_start;
	level.scr_anim[ "generic" ][ "trapped_agent_loop" ][0]							= %hijack_tarmac_trapped_agent_loop;
	
	level.scr_anim[ "commander" ][ "relaxed_idle" ][0]								= %hijack_tarmac_relaxed_idle_commander;
	level.scr_anim[ "commander" ][ "flare_reaction" ]								= %hijack_tarmac_flare_reaction_commander;
	level.scr_anim[ "commander" ][ "heli_wait" ][0]									= %hijack_tarmac_idle_heli_wait_commander;
	level.scr_anim[ "commander" ][ "heli_wave" ]									= %hijack_tarmac_heli_wave_commander;

	level.scr_anim[ "commander" ][ "engine_stumble" ]								= %hijack_tarmac_react_engine_commander;
	level.scr_anim[ "commander" ][ "injured_run" ]				 				 	= %hijack_tarmac_injured_run_commander;
	
	level.scr_anim[ "generic" ][ "tarmac_enter_combat_agent" ]				 		= %hijack_tarmac_enter_combat_agent;
	level.scr_anim[ "commander" ][ "tarmac_enter_combat_commander" ]				= %hijack_tarmac_enter_combat_commander;
	
	
	// -- END SCENE --
	//part 0: president, agent01, advisor: come out from hiding
	//level.scr_anim[ "president"][ "end_part0" ]				= %hijack_ending_come_out_over_president; 
	//level.scr_anim[ "end_agent"][ "end_part0" ]				= %hijack_ending_come_out_over_agent; 
	//level.scr_anim[ "advisor"][ "end_part0" ]				= %hijack_ending_come_out_over_advisor;	
	
	//part 1: president, agent01, advisor: waiting for player to enter scene
	//level.scr_anim[ "president"][ "end_part1" ][0]				= %hijack_ending_waiting_heli_idle_president;
	//level.scr_anim[ "end_agent"][ "end_part1" ][0]				= %hijack_ending_waiting_heli_idle_agent01;
	//level.scr_anim[ "advisor"]	[ "end_part1" ][0]				= %hijack_ending_waiting_heli_idle_advisor;
	level.scr_anim[ "president"][ "end_part1" ][0]									= %hijack_ending_cover_idle_president;
	level.scr_anim[ "end_agent"][ "end_part1" ][0]									= %hijack_ending_cover_idle_agent01;
	level.scr_anim[ "advisor"]	[ "end_part1" ][0]									= %hijack_ending_cover_idle_advisor;	
	
	//part 2: president, agent01, advisor commander: walk to heli
	level.scr_anim[ "president"][ "end_part2" ]										= %hijack_ending_walk_to_heli_presdient; 
	level.scr_anim[ "end_agent"][ "end_part2" ]										= %hijack_ending_walk_to_heli_agent01; 
	level.scr_anim[ "advisor"][ "end_part2" ]										= %hijack_ending_walk_to_heli_advisor;	
	level.scr_anim[ "commander"][ "end_part2" ]										= %hijack_ending_walk_to_heli_commander;
	
	//part 3: president, agent01, advisor commander: looping waiting for player to open door
	level.scr_anim[ "president"][ "end_part3" ][0]									= %hijack_ending_waiting_open_door_president;
	level.scr_anim[ "end_agent"][ "end_part3" ][0]									= %hijack_ending_waiting_open_door_agent01; 
	level.scr_anim[ "advisor"]  [ "end_part3" ][0]									= %hijack_ending_waiting_open_door_advisor;	
	level.scr_anim[ "commander"][ "end_part3" ][0]									= %hijack_ending_waiting_open_door_commander;
	
	//part 4: president, agent01, advisor, commander, makarov, henchman1, henchman2, player, heli: player opens door, betrayal happens.
	level.scr_anim[ "president"][ "end_part4" ]										= %hijack_ending_reveal_president; 
	level.scr_anim[ "end_agent"][ "end_part4" ]										= %hijack_ending_reveal_agent01; 
	level.scr_anim[ "advisor"]  [ "end_part4" ]										= %hijack_ending_reveal_advisor;	
	level.scr_anim[ "commander"][ "end_part4" ]										= %hijack_ending_reveal_commander;
	level.scr_anim[ "makarov"]  [ "end_part4" ]										= %hijack_ending_reveal_makarov;	
	level.scr_anim[ "henchman1"][ "end_part4" ]										= %hijack_ending_reveal_henchman01;	
	level.scr_anim[ "henchman2"][ "end_part4" ]										= %hijack_ending_reveal_henchman02;				
}


#using_animtree( "generic_human" );
zero_g_body()
{
	level.scr_animtree[ "test_body" ] = #animtree;
	level.scr_model[ "test_body" ] = "viewhands_player_fso";
	
	level.scr_anim[ "test_body" ][ "zero_g_player" ]						= %hijack_zero_g_player;
	addNotetrack_customFunction( "test_body", "people_lurch_left", maps\hijack_airplane::zerog_firsthit, "zero_g_player" );
	//addNotetrack_customFunction( "test_body", "oxygen_masks_down", maps\hijack_airplane::zerog_airmasks, "zero_g_player" );
	addNotetrack_customFunction( "test_body", "plane_dive_down", maps\hijack_airplane::zerog_planedive, "zero_g_player" );
	addNotetrack_customFunction( "test_body", "people_fly_up", maps\hijack_airplane::zerog_flyup, "zero_g_player" );
	addNotetrack_customFunction( "test_body", "screen_shake_1", maps\hijack_airplane::zerog_secondhit, "zero_g_player" );
	addNotetrack_customFunction( "test_body", "plane_roll_right", maps\hijack_airplane::zerog_planerollright, "zero_g_player" );
	addNotetrack_customFunction( "test_body", "screen_shake_2", maps\hijack_airplane::zerog_bigshake, "zero_g_player" );
	addNotetrack_customFunction( "test_body", "plane_roll_left", maps\hijack_airplane::zerog_planerollleft, "zero_g_player" );
	addNotetrack_customFunction( "test_body", "screen_shake_3", maps\hijack_airplane::zerog_thirdhit, "zero_g_player" );
	addNotetrack_customFunction( "test_body", "plane_level_out", maps\hijack_airplane::zerog_planelevelout, "zero_g_player" );	
}


#using_animtree( "player" );
player()
{
	level.scr_animtree[ "player_rig" ] = #animtree;
	level.scr_model[ "player_rig" ] = "viewhands_player_fso";
	
	// Conference
	level.scr_anim[ "player_rig" ][ "debate_react_player" ]			= %hijack_debate_react_player;
	
	//crash falling out
	level.scr_anim[ "player_rig" ]["crash_fall_out" ] 				= %hijack_plane_crash_fall_out_player;
	
	//post-crash
	level.scr_anim[ "player_rig" ][ "help_player_up" ]				= %hijack_tarmac_agent_helps_player;	
	
	//end scene
	level.scr_anim[ "player_rig" ][ "end_part4" ]					= %hijack_ending_open_door_player;		
}

#using_animtree("animated_props");
anim_props()
{
	level.scr_animtree["turbines"] = #animtree;
	level.scr_model[ "turbines" ] = "generic_prop_raven";
	level.scr_anim[ "turbines" ][ "engine_turbine_spin" ]				= %hijack_engine_turbine_spin_loop;
	level.scr_anim[ "turbines" ][ "engine_turbine_spin_loop" ][0]		= %hijack_engine_turbine_spin_loop;

	// INTRO PROPS
	level.scr_animtree["binder"] = #animtree;
	level.scr_model[ "binder" ] = "generic_prop_raven";
	level.scr_anim[ "binder" ][ "intro_cine_pres_binder" ]				= %hijack_intro_cine_pres_binder;	
	
	level.scr_animtree["clipboard"] = #animtree;
	level.scr_model[ "clipboard" ] = "generic_prop_raven";
	level.scr_anim[ "clipboard" ][ "intro_worker_clipboard" ]			= %hijack_intro_worker_clipboard;
	level.scr_anim[ "clipboard" ][ "intro_worker_clipboard_loop" ][0]	= %hijack_intro_worker_clipboard_loop;
	
	level.scr_animtree["food_cart"] = #animtree;
	level.scr_model[ "food_cart" ] = "generic_prop_raven";
	level.scr_anim[ "food_cart" ][ "intro_storage_cart" ]				= %hijack_intro_storage_cart;
	level.scr_anim[ "food_cart" ][ "intro_storage_candy" ]				= %hijack_intro_storage_candy_loop;
	level.scr_anim[ "food_cart" ][ "intro_storage_candy_loop" ][0]		= %hijack_intro_storage_candy_loop;
	level.scr_anim[ "food_cart" ][ "intro_storage_candy2" ]				= %hijack_intro_storage_candy2_loop;
	level.scr_anim[ "food_cart" ][ "intro_storage_candy2_loop" ][0]		= %hijack_intro_storage_candy2_loop;
	level.scr_anim[ "food_cart" ][ "intro_storage_peanuts" ]			= %hijack_intro_storage_peanuts_loop;
	level.scr_anim[ "food_cart" ][ "intro_storage_peanuts_loop" ][0]	= %hijack_intro_storage_peanuts_loop;

	// INTRO & DEBATE DOORS
	level.scr_animtree["door"] = #animtree;
	level.scr_model[ "door" ] = "generic_prop_raven";
	level.scr_anim[ "door" ][ "intro_cine_presdoor_open" ]				= %hijack_intro_cine_presdoor_open;
	level.scr_anim[ "door" ][ "intro_door_open" ]						= %hijack_intro_begin_room_door_open;
	level.scr_anim[ "door" ][ "intro_door2_worker_open" ]				= %hijack_intro_cine_door2_worker_open;
	level.scr_anim[ "door" ][ "intro_door2_assistant_open" ]			= %hijack_intro_cine_door2_assistant_open;
	level.scr_anim[ "door" ][ "intro_door3_agent_open" ]				= %hijack_intro_cine_door3_agent_open;
	level.scr_anim[ "door" ][ "intro_door3_agent_close" ]				= %hijack_intro_cine_door3_agent_close;
	level.scr_anim[ "door" ][ "debate_cine_door4_blown_off" ]			= %hijack_debate_cine_door4_blown_off;
	level.scr_anim[ "door" ][ "debate_cine_door3_agent_open" ]			= %hijack_debate_cine_door3_agent_open;
	
	// DEBATE PROPS
	level.scr_animtree["conf_chair"] = #animtree;
	level.scr_anim[ "conf_chair" ][ "intro_chair1" ]				= %hijack_intro_cine_chair1_swivel;
	level.scr_anim[ "conf_chair" ][ "intro_chair2" ]				= %hijack_intro_cine_chair2_swivel;
	level.scr_anim[ "conf_chair" ][ "intro_chair3" ]				= %hijack_intro_cine_chair3_swivel;
	level.scr_anim[ "conf_chair" ][ "intro_chair4" ]				= %hijack_intro_cine_chair4_swivel;
	level.scr_anim[ "conf_chair" ][ "intro_chair5" ]				= %hijack_intro_cine_chair5_swivel;
	level.scr_anim[ "conf_chair" ][ "intro_chair6" ]				= %hijack_intro_cine_chair6_swivel;
	level.scr_anim[ "conf_chair" ][ "debate_chair1" ]				= %hijack_debate_cine_chair1_swivel;
	level.scr_anim[ "conf_chair" ][ "debate_chair2" ]				= %hijack_debate_cine_chair2_swivel;
	level.scr_anim[ "conf_chair" ][ "debate_chair3" ]				= %hijack_debate_cine_chair3_swivel;
	level.scr_anim[ "conf_chair" ][ "debate_chair4" ]				= %hijack_debate_cine_chair4_swivel;
	level.scr_anim[ "conf_chair" ][ "debate_chair5" ]				= %hijack_debate_cine_chair5_swivel;
	level.scr_anim[ "conf_chair" ][ "debate_chair6" ]				= %hijack_debate_cine_chair6_swivel;
	level.scr_anim[ "conf_chair" ][ "debate_chair8" ]				= %hijack_debate_cine_chair8_swivel;
	
	level.scr_animtree["conf_roller"] = #animtree;
	level.scr_model[ "conf_roller" ] = "generic_prop_raven";
	level.scr_anim[ "conf_roller" ][ "debate_cine_lurchcam" ]			= %hijack_debate_cine_lurchcam;

	level.scr_animtree["phone"] = #animtree;
	level.scr_anim[ "phone" ][ "debate_phone" ]							= %hijack_intro_cine_phone_advisor;
	level.scr_anim[ "phone" ][ "debate_phone1_lurch" ]					= %hijack_debate_phone1_lurch;
	level.scr_anim[ "phone" ][ "debate_phone2_lurch" ]					= %hijack_debate_phone2_lurch;
	
	level.scr_animtree["debate_laptop"] = #animtree;
	level.scr_anim[ "debate_laptop" ][ "debate_laptop_lurch" ]			= %hijack_debate_laptop_lurch;
	
	level.scr_animtree["debate_prop"] = #animtree;
	level.scr_model[ "debate_prop" ] = "generic_prop_raven";
	level.scr_anim[ "debate_prop" ][ "debate_props_bck_lurch" ]			= %hijack_debate_props_bck_lurch;
	level.scr_anim[ "debate_prop" ][ "debate_props_frnt_lurch" ]		= %hijack_debate_props_frnt_lurch;
	
	level.scr_animtree["pitcher"] = #animtree;
	level.scr_model[ "pitcher" ] = "generic_prop_raven";
	level.scr_anim[ "pitcher" ][ "intro_cine_pitcher" ]					= %hijack_intro_cine_pitcher;
	level.scr_anim[ "pitcher" ][ "intro_cine_pitcher_loop" ][0]			= %hijack_intro_cine_pitcher_loop;
	
	level.scr_animtree["destroy_chair"] = #animtree;
	level.scr_model[ "destroy_chair" ] = "generic_prop_raven";
	level.scr_anim[ "destroy_chair" ][ "debate_cine_end_chair" ]		= %hijack_debate_cine_end_chair;
	
	// PRE ZERO-G PROPS
	level.scr_animtree["upperhall_roller"] = #animtree;
	level.scr_model[ "upperhall_roller" ] = "generic_prop_raven";
	level.scr_anim[ "upperhall_roller" ][ "hallway_lurchcam" ]			= %hijack_hallway_lurchcam;
	level.scr_anim[ "upperhall_roller" ][ "hallway_lurchcam_loop" ][0]	= %hijack_hallway_lurchcam_loop;
	level.scr_anim[ "upperhall_roller" ][ "hallway_godraycam" ]			= %hijack_hallway_godraycam;
	
	level.scr_animtree["upperhall_cabinet"] = #animtree;
	level.scr_model[ "upperhall_cabinet" ] = "generic_prop_raven";
	level.scr_anim[ "upperhall_cabinet" ][ "hallway_cabinet_open" ]		= %hijack_hallway_cabinet_open;
	level.scr_anim[ "upperhall_cabinet" ][ "hallway_cabinet_loop" ][0]	= %hijack_hallway_cabinet_loop;
	level.scr_anim[ "upperhall_cabinet" ][ "hallway_picture_fall" ]		= %hijack_hallway_picture_fall;
	
	// ZERO-G PROPS
	level.scr_animtree["zerog_prop"] = #animtree;
	level.scr_model[ "zerog_prop" ] = "generic_prop_raven";
	level.scr_anim[ "zerog_prop" ][ "zerog_hero_prop" ]					= %hijack_zerog_hero_prop;
	level.scr_anim[ "zerog_prop" ][ "zerog_suitcase1" ]					= %hijack_zerog_suitcase1;
	level.scr_anim[ "zerog_prop" ][ "zerog_suitcase2" ]					= %hijack_zerog_suitcase2;
	level.scr_anim[ "zerog_prop" ][ "zerog_suitcase3" ]					= %hijack_zerog_suitcase3;
	level.scr_anim[ "zerog_prop" ][ "zerog_suitcase4" ]					= %hijack_zerog_suitcase4;
	level.scr_anim[ "zerog_prop" ][ "zerog_suitcase5" ]					= %hijack_zerog_suitcase5;
	level.scr_anim[ "zerog_prop" ][ "zerog_suitcase6" ]					= %hijack_zerog_suitcase6;
	level.scr_anim[ "zerog_prop" ][ "zerog_suitcase7" ]					= %hijack_zerog_suitcase7;
	level.scr_anim[ "zerog_prop" ][ "zerog_suitcase8" ]					= %hijack_zerog_suitcase8;
	level.scr_anim[ "zerog_prop" ][ "zerog_squarebox" ]					= %hijack_zerog_squarebox;
	level.scr_anim[ "zerog_prop" ][ "zerog_rectanglebox" ]				= %hijack_zerog_rectanglebox;
	level.scr_anim[ "zerog_prop" ][ "zerog_overhead_door_r" ]			= %hijack_zerog_overhead_door_r;
	level.scr_anim[ "zerog_prop" ][ "zerog_overhead_door_l" ]			= %hijack_zerog_overhead_door_l;
	level.scr_anim[ "zerog_prop" ][ "zerog_mealcart" ]					= %hijack_zerog_mealcart;
	level.scr_anim[ "zerog_prop" ][ "fire_extinguisher_enter" ]			= %hijack_zerog_fire_extinguisher_enter;
	level.scr_anim[ "zerog_prop" ][ "fire_extinguisher_loop" ][0]		= %hijack_zerog_fire_extinguisher_loop;
	
	level.scr_animtree["zerog_laptop"] = #animtree;
	level.scr_anim[ "zerog_laptop" ][ "zerog_laptop" ]					= %hijack_zerog_laptop;
	
	level.scr_animtree["zerog_o2_module"] = #animtree;
	level.scr_anim[ "zerog_o2_module" ][ "zerog_o2_module_r" ]			= %hijack_zerog_o2_module_r;
	level.scr_anim[ "zerog_o2_module" ][ "zerog_o2_module_l" ]			= %hijack_zerog_o2_module_l;
	
	// LOWER LEVEL PROPS
	level.scr_animtree["hanging_phone"] = #animtree;
	level.scr_anim[ "hanging_phone" ][ "phone_swaying" ][0]				= %hijack_phone_swaying;
	
	// CARGO ROOM PROPS
	level.scr_animtree["cargo"] = #animtree;
	level.scr_model[ "cargo" ] = "generic_prop_raven";
	level.scr_anim[ "cargo" ][ "prop_bag_shift" ]    				= %hijack_find_daughter_prop_bag_shift;
	level.scr_anim[ "cargo" ][ "prop_bag_loop" ][0]   				= %hijack_find_daughter_prop_bag_loop;
	
	level.scr_anim[ "cargo" ][ "prop_ladder_shift" ]    			= %hijack_find_daughter_prop_ladder_shift;
	level.scr_anim[ "cargo" ][ "prop_ladder_loop" ][0]   			= %hijack_find_daughter_prop_ladder_loop;
	
	level.scr_anim[ "cargo" ][ "prop_box1_shift" ]    				= %hijack_find_daughter_prop_box1_shift;
	level.scr_anim[ "cargo" ][ "prop_box1_loop" ][0]   				= %hijack_find_daughter_prop_box1_loop;
	
	level.scr_anim[ "cargo" ][ "prop_box2_3_shift" ]    			= %hijack_find_daughter_prop_box2_3_shift;
	level.scr_anim[ "cargo" ][ "prop_box2_3_loop" ][0]  			= %hijack_find_daughter_prop_box2_3_loop;
	
	level.scr_anim[ "cargo" ][ "prop_sm_box2_shift" ]    			= %hijack_find_daughter_prop_sm_box2_shift;
	level.scr_anim[ "cargo" ][ "prop_sm_box2_loop" ][0]   			= %hijack_find_daughter_prop_sm_box2_loop;
	
	level.scr_anim[ "cargo" ][ "prop_sm_box1_shift" ]    			= %hijack_find_daughter_prop_sm_box1_shift;
	level.scr_anim[ "cargo" ][ "prop_sm_box1_loop" ][0]   			= %hijack_find_daughter_prop_sm_box1_loop;
	
	level.scr_anim[ "cargo" ][ "prop_propane1_shift" ]    			= %hijack_find_daughter_prop_propane1_shift;
	
	level.scr_anim[ "cargo" ][ "prop_propane2_3_shift" ]    		= %hijack_find_daughter_prop_propane2_3_shift;
	level.scr_anim[ "cargo" ][ "prop_propane2_3_loop" ][0]   		= %hijack_find_daughter_prop_propane2_3_loop;
	
	level.scr_anim[ "cargo" ][ "prop_propane4_shift" ]    			= %hijack_find_daughter_prop_propane4_shift;
	level.scr_anim[ "cargo" ][ "prop_propane4_loop" ][0]   			= %hijack_find_daughter_prop_propane4_loop;
	
	level.scr_anim[ "cargo" ][ "prop_toolbox_shift" ]    			= %hijack_find_daughter_prop_toolbox_shift;
	level.scr_anim[ "cargo" ][ "prop_toolbox_loop" ][0]  			= %hijack_find_daughter_prop_toolbox_loop;
	
	level.scr_anim[ "cargo" ][ "prop_smbox3_lg6_shift" ]    		= %hijack_find_daughter_prop_smbox3_lg6_shift;
	level.scr_anim[ "cargo" ][ "prop_smbox3_lg6_loop" ][0]   		= %hijack_find_daughter_prop_smbox3_lg6_loop;
	
	// PLANE CRASH
	level.scr_anim["generic"]["hijack_plane_crash_anim"]				= %hijack_plane_crash_plane;
		//addNotetrack_customFunction( "generic", "hit_ground", maps\hijack_crash::crash_hit_ground, "hijack_plane_crash_anim"  );
		//addNotetrack_customFunction( "generic", "hit_end", maps\hijack_crash::crash_hit_throw_player, "hijack_plane_crash_anim"  );
	
	// PLANE CRASH DOOR
	level.scr_anim[ "generic" ][ "hijack_pre_plane_crash_door" ]		= %hijack_pre_plane_crash_door;
	level.scr_anim[ "generic" ][ "hijack_pre_plane_crash_door_close" ]	= %hijack_pre_plane_crash_door_close;

	
	
	
	level.scr_anim[ "generic"][ "hijack_pre_plane_crash_compartments"][0] = %hijack_pre_plane_crash_compartments_loop;
	
	//CRASH TREES
	level.scr_animtree["pine_tree_lg"] = #animtree;
	level.scr_model["pine_tree_lg"] = "hjk_tree_pine_lg";
	
		
	level.scr_anim["pine_tree_lg"]["crash_tree_1"] 	= %hijack_plane_crash_tree1;
	level.scr_anim["pine_tree_lg"]["crash_tree_2"] 	= %hijack_plane_crash_tree2;
	
	level.scr_animtree["pine_tree_sm"] = #animtree;
	level.scr_model["pine_tree_sm"] = "hjk_tree_pine_sm";	
	level.scr_anim["pine_tree_sm"]["crash_tree_3"] 	= %hijack_plane_crash_tree3;
	level.scr_anim["pine_tree_sm"]["crash_tree_4"] 	= %hijack_plane_crash_tree4;
	level.scr_anim["pine_tree_lg"]["crash_tree_5"] 	= %hijack_plane_crash_tree5;
	level.scr_anim["pine_tree_sm"]["crash_tree_6"] 	= %hijack_plane_crash_tree6;

	//crash tower
	level.scr_animtree["crash_tower"] = #animtree;
	level.scr_model["crash_tower"] = "hjk_control_tower";	
	level.scr_anim["crash_tower"]["hijack_plane_crash_anim"] = %hijack_plane_crash_tower;
	
	level.scr_animtree["crash_tower_lights"] = #animtree;
	level.scr_model["crash_tower_lights"] = "hjk_control_tower_lit_windows";	
	level.scr_anim["crash_tower_lights"]["hijack_plane_crash_anim"] = %hijack_plane_crash_tower;
	
	
	//crash engine, special model swap
	level.scr_animtree["crash_engine_1"] = #animtree;
	level.scr_model["crash_engine_1"] = "hijack_plane_crash_engine_clean";	
	level.scr_anim["crash_engine_1"]["hijack_plane_crash_anim"] = %hijack_plane_crash_plane;
	
	level.scr_animtree["crash_engine_2"] = #animtree;
	level.scr_model["crash_engine_2"] = "hijack_plane_crash_engine_damaged";	
	level.scr_anim["crash_engine_2"]["hijack_plane_crash_anim"] = %hijack_plane_crash_plane;
	
		
	level.scr_animtree["post_crash_telephone"] = #animtree;
	level.scr_anim[ "post_crash_telephone" ][ "telephone_swing" ]	= %hijack_tarmac_telephone_swing;
	
	//planecrash models for lights on/off
	level.scr_model["plane_crash_lights_on_front"] = "hijack_plane_crash_front_interior";
	level.scr_model["plane_crash_lights_off_front"] = "hijack_plane_crash_front_interior_lightsoff";
	
	level.scr_model["plane_crash_lights_on_rear"] = "hijack_plane_crash_rear_interior";
	level.scr_model["plane_crash_lights_off_rear"] = "hijack_plane_crash_rear_interior_lightsoff";
				
	
	// POST CRASH PROPS
	level.scr_animtree["post_crash_prop"] = #animtree;
	level.scr_model[ "post_crash_prop" ] = "generic_prop_raven";
	level.scr_anim[ "post_crash_prop" ][ "post_crash_locker1" ]		= %hijack_post_crash_locker1;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_locker2" ]		= %hijack_post_crash_locker2;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_locker3" ]		= %hijack_post_crash_locker3;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_locker4" ]		= %hijack_post_crash_locker4;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_locker5" ]		= %hijack_post_crash_locker5;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_locker6" ]		= %hijack_post_crash_locker6;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_locker7" ]		= %hijack_post_crash_locker7;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_locker8" ]		= %hijack_post_crash_locker8;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_locker9" ]		= %hijack_post_crash_locker9;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_locker10" ]	= %hijack_post_crash_locker10;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_locker11" ]	= %hijack_post_crash_locker11;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_locker12" ]	= %hijack_post_crash_locker12;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_locker13" ]	= %hijack_post_crash_locker13;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_locker14" ]	= %hijack_post_crash_locker14;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_locker15" ]	= %hijack_post_crash_locker15;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_locker16" ]	= %hijack_post_crash_locker16;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_locker17" ]	= %hijack_post_crash_locker17;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_locker18" ]	= %hijack_post_crash_locker18;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_locker19" ]	= %hijack_post_crash_locker19;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_locker20" ]	= %hijack_post_crash_locker20;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_locker21" ]	= %hijack_post_crash_locker21;

	level.scr_anim[ "post_crash_prop" ][ "post_crash_drawer1" ]		= %hijack_post_crash_drawer1;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_drawer2" ]		= %hijack_post_crash_drawer2;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_ladder" ]		= %hijack_post_crash_ladder;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_tire" ]		= %hijack_post_crash_tire;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_crate" ]		= %hijack_post_crash_crate;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_pipe_small" ]	= %hijack_post_crash_pipe_small;
	level.scr_anim[ "post_crash_prop" ][ "post_crash_pipe_large" ]	= %hijack_post_crash_pipe_large;
	
	level.scr_animtree["engine"] = #animtree;
	level.scr_anim[ "engine" ][ "engine_spin" ]						= %hijack_tarmac_turbine_spin;
	level.scr_anim[ "engine" ][ "engine_spin_slow" ]				= %hijack_tarmac_turbine_spin_slow;
	
	// Blanket for daughter
	level.scr_animtree["daughter_blanket"] = #animtree;
	level.scr_model[ "daughter_blanket" ] = "hjk_blanket_anim";
	level.scr_anim[ "daughter_blanket" ][ "secure_daughter" ]			= %hijack_secure_daughter_blanket;
	level.scr_anim[ "daughter_blanket" ][ "secure_daughter_loop" ][0]	= %hijack_secure_daughter_blanket_end_loop;
	
	// TAIL
	level.scr_animtree["tail_prop"] = #animtree;
	level.scr_model[ "tail_prop" ] = "generic_prop_raven";
	level.scr_anim[ "tail_prop" ][ "plane_tail_collapse" ]			= %hijack_tarmac_plane_tail_collapse;
	
	// Plane seats crushing a hijacker
	level.scr_animtree["plane_seats"] = #animtree;
	level.scr_model[ "plane_seats" ] = "generic_prop_raven";
	level.scr_anim[ "plane_seats" ][ "buried_prop" ]				= %hijack_tarmac_buried_prop;
	
	// Piece of metal crushing an agent
	level.scr_animtree["metal_beam"] = #animtree;
	level.scr_model[ "metal_beam" ] = "generic_prop_raven";
	level.scr_anim[ "metal_beam" ][ "trapped_prop" ]				= %hijack_tarmac_trapped_prop;
	
	level.scr_animtree[ "makarov_heli_door" ]	= #animtree;
	level.scr_anim[ "makarov_heli_door" ][ "end_part4" ]			= %hijack_ending_reveal_heli;	 	
}

#using_animtree("vehicles");
vehicle_anims()
{	
	level.scr_animtree[ "makarov_heli" ]	= #animtree;
	level.scr_anim[ "makarov_heli" ][ "end_part4" ]				= %hijack_ending_reveal_heli;	 	
}

#using_animtree("generic_human");
president_moveset()
{
	three_twitch_weights = [];
	three_twitch_weights[0] = 2;
	three_twitch_weights[1] = 1;
	three_twitch_weights[2] = 1;
	three_twitch_weights[3] = 1;
	
	weights = [];
	weights[ 0 ] = 7;
	weights[ 1 ] = 3;
	one_twitch_weights = get_cumulative_weights( weights );
	
	
	level.scr_anim[ "president" ][ "civilian_stand_idle" ][ 0 ]		= %hijack_president_idle_panic;
		
	level.scr_anim[ "president" ][ "run_noncombat" ][ 0 ]		= %hijack_president_run_panic;
	level.scr_anim[ "president" ][ "run_noncombat" ][ 1 ]		= %hijack_president_run_panic;//hijack_president_run_panic_dodge;
	level.scr_anim[ "president" ][ "run_weights" ]				= one_twitch_weights;
	level.scr_anim[ "president" ][ "turn_left_45" ]				= %hijack_president_run_panic_turnl45;
	level.scr_anim[ "president" ][ "turn_right_45" ]			= %hijack_president_run_panic_turnr45;
	level.scr_anim[ "president" ][ "turn_left_90" ]				= %hijack_president_run_panic_turnL90;
	level.scr_anim[ "president" ][ "turn_right_90" ]			= %hijack_president_run_panic_turnR90;
	
	
	level.scr_anim[ "president" ][ "idle_noncombat" ][ 0 ] 	= %hijack_president_idle_panic;
	level.scr_anim[ "president" ][ "idle_combat" ][ 0 ] 	= %hijack_president_idle_panic;
		
	level.scr_anim[ "president" ][ "run_combat" ][ 0 ] 		= %hijack_president_run_panic;
}

president_setup_anims()
{
	self.customIdleAnimSet = [];
	self.customIdleAnimSet[ "stand" ] = %hijack_president_idle_panic;
}

president_setup_turn_anims_override( angleDiff )
{
	assert( isdefined( level.scr_anim[ self.animname ][ "turn_left_45" ] ) );
	assert( isdefined( level.scr_anim[ self.animname ][ "turn_right_45" ] ) );
	assert( isdefined( level.scr_anim[ self.animname ][ "turn_left_90" ] ) );
	assert( isdefined( level.scr_anim[ self.animname ][ "turn_right_90" ] ) );
	
	turnAnim = undefined;

	if ( angleDiff < -22.5 && angleDiff >= -70 )
		turnAnim = level.scr_anim[ self.animname ][ "turn_left_45" ];
		
	if ( angleDiff < -70 && angleDiff > -120 )
		turnAnim = level.scr_anim[ self.animname ][ "turn_left_90" ];
	
	if ( angleDiff > 22.5 && angleDiff <= 70 )
		turnAnim = level.scr_anim[ self.animname ][ "turn_right_45" ];
		
	if ( angleDiff > 70 && angleDiff < 120 )
		turnAnim = level.scr_anim[ self.animname ][ "turn_right_90" ];


	if ( isdefined( turnAnim ) && animscripts\move::pathChange_canDoTurnAnim( turnAnim ) )
		return turnAnim;
	else
		return undefined;
}

commander_post_crash_animset()
{
	self.customIdleAnimSet = [];
	self.customIdleAnimSet[ "stand" ] = %hijack_tarmac_relaxed_idle_commander;
}
