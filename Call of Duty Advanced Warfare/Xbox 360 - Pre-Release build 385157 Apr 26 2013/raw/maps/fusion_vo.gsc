#include maps\_utility;
#include common_scripts\utility;
#include maps\ss_util;
#include maps\_anim;
#include maps\_vehicle;
#include soundscripts\_snd;

main()
{	
	setup_vo();
	init_dialogue_flags();
	thread start_dialogue_threads();
}

setup_vo()
{
	
// Prophet Lines
	level.scr_radio[ "fusion_hqr_signaldistortion" ] = "fusion_hqr_signaldistortion";					
	level.scr_radio[ "fusion_hqr_notime" ] = "fusion_hqr_notime";										
	level.scr_radio[ "fusion_hqr_zuludown" ] = "fusion_hqr_zuludown";									
	level.scr_radio[ "fusion_hqr_footmobilesinbound" ] = "fusion_hqr_footmobilesinbound";				
	level.scr_radio[ "fusion_hqr_copythatlauncheranddrone" ] = "fusion_hqr_copythatlauncheranddrone";	
	level.scr_radio[ "fusion_hqr_level7event" ] = "fusion_hqr_level7event";								//Bravo, we have an imminent level 7 event on the INES scale. You are ordered to immediately withdraw from the area.
	level.scr_radio[ "fusion_hqr_onthetracker" ] = "fusion_hqr_onthetracker";							//Affirmative, Bravo-one. We've got them on the tracker.
	level.scr_radio[ "fusion_hqr_readingscritical" ]	= "fusion_hqr_readingscritical";				//Bravo, pressure readings are critical. Get your men out of there now!
	level.scr_radio[ "fusion_hqr_massiveexplosionnorth" ]	= "fusion_hqr_massiveexplosionnorth";		//I'm seeing a massive explosion under the north tower! Bravo, come in!
	level.scr_radio[ "fusion_hqr_getthosemenout" ]	= "fusion_hqr_getthosemenout";						//All units, get rotors on the ground and get those men out of there!
	
// PA recording
	level.scr_radio[ "fusion_pa_codered" ] = "fusion_pa_codered";										//Code red, code red, warning, reactor core compromised. Site area emergency declared. Evacuate immediately.
	level.scr_radio[ "fusion_pa_emergencyexit" ] = "fusion_pa_emergencyexit";							//Please proceed to the nearest emergency exit.  Illuminated placards will guide you to your nearest exit.  
	level.scr_radio[ "fusion_pa_airlockclosing" ] = "fusion_pa_airlockclosing";							//Warning, containment airlock closing. Please stand back.
		
//Chopper pilot 1
	level.scr_radio[ "fusion_plt1_315magnetic" ] = "fusion_plt1_315magnetic";							
	level.scr_radio[ "fusion_plt1_prosecutetargets" ] = "fusion_plt1_prosecutetargets";					
	level.scr_radio[ "fusion_plt1_visualonplant" ] = "fusion_plt1_visualonplant";						
	level.scr_radio[ "fusion_plt1_swarmcountermeasures" ] = "fusion_plt1_swarmcountermeasures";			
	level.scr_radio[ "fusion_plt1_twofourisdown" ] = "fusion_plt1_twofourisdown";
	level.scr_radio[ "fusion_plt1_24providesupport" ] = "fusion_plt1_24providesupport";	
	level.scr_radio[ "fusion_plt1_hostilesinlz" ] = "fusion_plt1_hostilesinlz";							
	level.scr_radio[ "fusion_plt1_goodeffectontarget" ] = "fusion_plt1_goodeffectontarget";				
	level.scr_radio[ "fusion_plt1_lzisclear" ] = "fusion_plt1_lzisclear";								
	
	level.scr_radio[ "fusion_plt1_inposition" ] = "fusion_plt1_inposition";								
	level.scr_radio[ "fusion_plt1_teamoneondeck" ] = "fusion_plt1_teamoneondeck";						
	level.scr_radio[ "fusion_plt1_gunrun" ] = "fusion_plt1_gunrun";										//Bravo, this is Wraith two-three, coming in for a gun-run on enemy foot-mobiles.
	level.scr_radio[ "fusion_plt1_inboundinthirty" ]	= "fusion_plt1_inboundinthirty";				//Copy, Bravo-one. Inbound in thirty.
	level.scr_radio[ "fusion_plt1_southeasttower" ] = "fusion_plt1_southeasttower";						//Bravo, we can't get near those surface explosions. Circling around to the south-east tower.
	level.scr_radio[ "fusion_plt1_doyoucopy" ] = "fusion_plt1_doyoucopy";								//Bravo, do you copy?
	level.scr_radio[ "fusion_plt1_bravotakecover" ]	= "fusion_plt1_bravotakecover";						//Bravo, take cover--!
	level.scr_radio[ "fusion_plt1_wraithtwofourdown" ]	= "fusion_plt1_wraithtwofourdown";				//Wraith two-four is down!
	level.scr_radio[ "fusion_plt1_needcasevaccourtyard" ]	= "fusion_plt1_needcasevaccourtyard";		//Chopper Pilot 1: I need casevac units by the main courtyard.
	
//Chopper pilot 2
	level.scr_radio[ "fusion_plt2_enemypax" ] = "fusion_plt2_enemypax";									

//Chopper pilot 3
	level.scr_radio[ "fusion_plt3_restrictedroe" ] = "fusion_plt3_restrictedroe";						
	level.scr_radio[ "fusion_plt3_disengagingstealth" ] = "fusion_plt3_disengagingstealth";
	level.scr_radio[ "fusion_plt3_tryingtostabilize" ] = "fusion_plt3_tryingtostabilize";				
	
//Chopper pilot 4
	level.scr_radio[ "fusion_plt4_copythat23" ] = "fusion_plt4_copythat23";
	level.scr_radio[ "fusion_plt4_teamtwodeploying" ] = "fusion_plt4_teamtwodeploying";					
	level.scr_radio[ "fusion_plt4_cominginhot" ] = "fusion_plt4_cominginhot";							
		
//Alpha Leader
	level.scr_sound["alpha_leader"]["fusion_aldr_welcometotheparty"] = "fusion_aldr_welcometotheparty";	
	level.scr_radio[ "fusion_aldr_casualtiesandwounded" ]	= "fusion_aldr_casualtiesandwounded";		//I've got ten casualties and another dozen wounded!
	level.scr_radio[ "fusion_aldr_goddamnairsupport" ]	= "fusion_aldr_goddamnairsupport";				//Alpha Leader: Where's our goddamn air support!
	level.scr_radio[ "fusion_aldr_lostcontactbravo" ]	= "fusion_aldr_lostcontactbravo";				//We've lost contact with Bravo!
	
// Burke lines
	level.scr_sound["burke"]["fusion_brk_staticondisplay"] = "fusion_brk_staticondisplay";				
	level.scr_sound["burke"]["fusion_brk_everyoneseeingthis"] = "fusion_brk_everyoneseeingthis";		
	level.scr_sound["burke"]["fusion_brk_meltdownscenario"] = "fusion_brk_meltdownscenario";			
	level.scr_sound["burke"]["fusion_brk_shitendsnoprisoners"] = "fusion_brk_shitendsnoprisoners";
	level.scr_sound["burke"]["fusion_brk_getinposition"] = "fusion_brk_getinposition";					
	level.scr_sound["burke"]["fusion_brk_panama"] = "fusion_brk_panama";								
	level.scr_sound["burke"]["fusion_brk_holdon"] = "fusion_brk_holdon";								
	level.scr_sound["burke"]["fusion_brk_nothingwecando"] = "fusion_brk_nothingwecando";				
	level.scr_sound["burke"]["fusion_brk_deploylines"] = "fusion_brk_deploylines";						
	level.scr_sound["burke"]["fusion_brk_clearoutrooftops"] = "fusion_brk_clearoutrooftops";			
	level.scr_sound["burke"]["fusion_brk_hitthosetangos"] = "fusion_brk_hitthosetangos";				
	level.scr_sound["burke"]["fusion_brk_niceshot"] = "fusion_brk_niceshot";							//Nice shot!
	level.scr_sound["burke"]["fusion_brk_tangodown"] = "fusion_brk_tangodown";							//Tango down!
	level.scr_sound["burke"]["fusion_brk_trytokeepup"] = "fusion_brk_trytokeepup";						
	
	level.scr_sound["burke"]["fusion_brk_zerooneout"] = "fusion_brk_zerooneout";						
	level.scr_sound["burke"]["fusion_brk_mitchelldeploy"] = "fusion_brk_mitchelldeploy";				
	level.scr_sound["burke"]["fusion_brk_firezipline"] = "fusion_brk_firezipline";						//Fire your zipline, Mitchell!
	level.scr_sound["burke"]["fusion_brk_getdownhere"] = "fusion_brk_getdownhere";						//Get the hell down here, Mitchell!
	level.scr_sound["burke"]["fusion_brk_rallyup"] = "fusion_brk_rallyup";								
	level.scr_sound["burke"]["fusion_brk_mitchellonme"] = "fusion_brk_mitchellonme";					//Mitchell, on me!
	level.scr_sound["burke"]["fusion_brk_mitchelloverhere"] = "fusion_brk_mitchelloverhere";			//Mitchell, over here!
	level.scr_sound["burke"]["fusion_brk_alphakneedeep"] = "fusion_brk_alphakneedeep";					
	level.scr_sound["burke"]["fusion_brk_moveout"] = "fusion_brk_moveout";								
	level.scr_sound["burke"]["fusion_brk_copythatprophet"] = "fusion_brk_copythatprophet";				
	level.scr_sound["burke"]["fusion_brk_weaponsfree"] = "fusion_brk_weaponsfree";						
	level.scr_sound["burke"]["fusion_brk_bootsontheground"] = "fusion_brk_bootsontheground";			
	
	level.scr_sound["burke"]["fusion_brk_mcds"] = "fusion_brk_mcds";									
	level.scr_sound["burke"]["fusion_brk_pushingforward"] = "fusion_brk_pushingforward";				
	level.scr_sound["burke"]["fusion_brk_mitchellswitchde"] = "fusion_brk_mitchellswitchde";			//Mitchell, switch over to your DE and take them out!
	level.scr_sound["burke"]["fusion_brk_switchde"] = "fusion_brk_switchde";							//Switch to your DE!
	level.scr_sound["burke"]["fusion_brk_kvarolledtitan"] = "fusion_brk_kvarolledtitan";
	level.scr_sound["burke"]["fusion_brk_launcherorhackdrone"] = "fusion_brk_launcherorhackdrone";
	
	level.scr_sound["burke"]["fusion_brk_assonit"] = "fusion_brk_assonit";								
	level.scr_sound["burke"]["fusion_brk_dosomedamage"] = "fusion_brk_dosomedamage";					
	level.scr_sound["burke"]["fusion_brk_bailout"] = "fusion_brk_bailout";								
		
	level.scr_sound["burke"]["fusion_brk_titansdowngoodjob"] = "fusion_brk_titansdowngoodjob";	
	level.scr_sound["burke"]["fusion_brk_takeoutthetitan"] = "fusion_brk_takeoutthetitan";
	level.scr_sound["burke"]["fusion_brk_hittitanlauncher"] = "fusion_brk_hittitanlauncher";

	level.scr_sound["burke"]["fusion_brk_legitcontrolbuilding"] = "fusion_brk_legitcontrolbuilding";	
	
	level.scr_sound["burke"]["fusion_brk_gocritical"] = "fusion_brk_gocritical";						//Copy that! Bravo, we're about to go critical! Let's go!
	level.scr_sound["burke"]["fusion_brk_keepmoving"] = "fusion_brk_keepmoving";						//So are we! Keep moving!
	level.scr_sound["burke"]["fusion_brk_moveit"] = "fusion_brk_moveit";								//Move it!
	level.scr_sound["burke"]["fusion_brk_contactloadingbay"] = "fusion_brk_contactloadingbay";			//Contact in the loading bay!
	level.scr_sound["burke"]["fusion_brk_switchmmgs"] = "fusion_brk_switchmmgs";						//Mitchell, switch to your MMGs and light em up!
	level.scr_sound["burke"]["fusion_brk_rabbiting"] = "fusion_brk_rabbiting";							//They're rabbiting!

	level.scr_sound["burke"]["fusion_brk_kvanorthtowers"] = "fusion_brk_kvanorthtowers";				//Prophet, we've got KVA extraction choppers by the north towers!
	level.scr_sound["burke"][ "fusion_brk_useyouremps" ]	= "fusion_brk_useyouremps";					//Use your EMPs!
	level.scr_sound["burke"]["fusion_brk_letsgoletsgo"] = "fusion_brk_letsgoletsgo";					//Let's go, let's go!
	level.scr_sound["burke"]["fusion_brk_needimmediateevac"]	= "fusion_brk_needimmediateevac";		//Wraith two-three, we need immediate evac!
	level.scr_sound["burke"]["fusion_brk_pressureexplosions"] = "fusion_brk_pressureexplosions";		//Pressure explosions!  This place is goin' up!
	level.scr_sound["burke"]["fusion_brk_moredronesincoming"]	= "fusion_brk_moredronesincoming";		// Heads up, more drones incoming!
	level.scr_sound["burke"]["fusion_brk_welcomesight"] = "fusion_brk_welcomesight";					//You're a damn welcome sight, two-three!
	level.scr_sound["burke"]["fusion_brk_copythattwothree"] = "fusion_brk_copythattwothree";			//Copy that two-three.
	level.scr_sound["burke"]["fusion_brk_keepmovingkeepmoving"] = "fusion_brk_keepmovingkeepmoving";	//Keep moving! Keep moving!
	level.scr_sound["burke"]["fusion_brk_mitchell"] = "fusion_brk_mitchell";							//Mitchell!
	level.scr_sound["burke"]["fusion_brk_medevac"] = "fusion_brk_medevac";								//Wraith two-three, I need immediate medevac!
	level.scr_sound["burke"]["fusion_brk_holdonman"] = "fusion_brk_holdonman";							//Hold on, mate…
	level.scr_sound["burke"]["fusion_brk_goingtobealright"] = "fusion_brk_goingtobealright";			//You're going to be alright.
	level.scr_sound["burke"]["fusion_brk_gettingyouhome"] = "fusion_brk_gettingyouhome";				//We're getting you home…
	
// Carter lines
	level.scr_sound["carter"]["fusion_ctr_zerothreeout"] = "fusion_ctr_zerothreeout";					
	level.scr_sound["carter"]["fusion_ctr_droneoperatordown"] = "fusion_ctr_droneoperatordown";			
	level.scr_sound["carter"]["fusion_ctr_geigerreading"] = "fusion_ctr_geigerreading";					//Joker, what's your geiger reading?!
	level.scr_sound["carter"]["fusion_ctr_whatthehell"] = "fusion_ctr_whatthehell";						//What the hell was that?
	level.scr_sound["carter"]["fusion_ctr_gogo"] = "fusion_ctr_gogo";									//Go, go!
	
//Joker lines
	level.scr_sound["joker"]["fusion_jkr_gotit"] = "fusion_jkr_gotit";	
	level.scr_sound["joker"]["fusion_jkr_shit"] = "fusion_jkr_shit";									
	level.scr_sound["joker"]["fusion_jkr_theymakeit"] = "fusion_jkr_theymakeit";						
	level.scr_sound["joker"]["fusion_jkr_yessir"] = "fusion_jkr_yessir";								
	level.scr_sound["joker"]["fusion_jkr_coverdrones"] = "fusion_jkr_coverdrones";	
	level.scr_sound["joker"]["fusion_jkr_dosomedamage"] = "fusion_jkr_dosomedamage";	
	level.scr_sound["joker"]["fusion_jkr_tangosdugin"] = "fusion_jkr_tangosdugin";						//Tangos dug in behind those barricades!			
	level.scr_sound["joker"]["fusion_jkr_bastardtrophy"] = "fusion_jkr_bastardtrophy";	
	level.scr_sound["joker"]["fusion_jkr_mtfunctional"] = "fusion_jkr_mtfunctional";					
	level.scr_sound["joker"]["fusion_jkr_gogogo"] = "fusion_jkr_gogogo";								//Go, go, go!
	level.scr_sound["joker"]["fusion_jkr_bailinout"] = "fusion_jkr_bailinout";							//Burke, tangos are bailin out!
	level.scr_sound["joker"][ "fusion_jkr_lotofsmoke" ]	= "fusion_jkr_lotofsmoke";						//Got a lot of smoke down there!
	level.scr_sound["joker"]["fusion_jkr_doorsclosing"] = "fusion_jkr_doorsclosing";					//Door's closing!
	level.scr_sound["joker"]["fusion_jkr_justkeepshooting"] = "fusion_jkr_justkeepshooting";			//We're good, just keep shooting!
	level.scr_sound["joker"][ "fusion_jkr_usingdrones" ]	= "fusion_jkr_usingdrones";					//Joker: They're using drones to cover their retreat!
	level.scr_sound["joker"][ "fusion_jkr_dronesdown" ]	= "fusion_jkr_dronesdown";						//Drones are down!
	level.scr_sound["joker"]["fusion_jkr_heardkeepmoving"]	= "fusion_jkr_heardkeepmoving";				//You heard the man! Keep moving!
	level.scr_sound["joker"]["fusion_jkr_goddamn"] = "fusion_jkr_goddamn";								//Goddamn!
	level.scr_sound["joker"]["fusion_jkr_exfil"] = "fusion_jkr_exfil";									//There's our exfil!
	level.scr_sound["joker"]["fusion_jkr_comeon"] = "fusion_jkr_comeon";								//Come on!
	level.scr_sound["joker"]["fusion_jkr_ohshit"] = "fusion_jkr_ohshit";								//Oh shit---!
	level.scr_radio["fusion_jkr_wherescarter"] = "fusion_jkr_wherescarter";								//Where's Carter?! Where's Carter?!
	level.scr_radio["fusion_jkr_itscomingdown"] = "fusion_jkr_itscomingdown";							//It's coming down!
	level.scr_radio[ "fusion_jkr_cartersdead" ]	= "fusion_jkr_cartersdead";								//He's dead! Carter's dead!
	
	interior_prepare_dialogue();
/*
 //CUT LINES - OBSOLETE
	level.scr_sound["joker"]["fusion_jkr_hackdrone"] = "fusion_jkr_hackdrone";							//I got eyes on a hack drone 50 meters out! It's one of ours!
	level.scr_sound["joker"]["fusion_jkr_zerotwoout"] = "fusion_jkr_zerotwoout";							
	level.scr_sound["joker"]["fusion_jkr_overtime"] = "fusion_jkr_overtime";							
	level.scr_sound["carter"]["fusion_ctr_onepiece"] = "fusion_ctr_onepiece";
	level.scr_sound["carter"]["fusion_ctr_hearthat"] = "fusion_ctr_hearthat";							//I hear that.
	level.scr_sound["burke"]["fusion_brk_mandown"] = "fusion_brk_mandown";								//Man down!
	level.scr_sound["burke"]["fusion_brk_kvadeployingdrones"]	= "fusion_brk_kvadeployingdrones";		//The KVA are deploying drones to cover their retreat.  Take them out!
	level.scr_sound["burke"]["fusion_brk_tankbypassed"] = "fusion_brk_tankbypassed";					//Tank is bypassed! It's ours!				
	level.scr_sound["burke"]["fusion_brk_takeoutthetank"] = "fusion_brk_takeoutthetank";				//Take out the tank with the launcher, Mitchell!
	level.scr_sound["burke"]["fusion_brk_rogerthat"] = "fusion_brk_rogerthat";							//Roger that, Prophet! 
	level.scr_sound["burke"]["fusion_brk_paladinrollingin"] = "fusion_brk_paladinrollingin";			//Squad, we've got a Paladin tank rolling in! Priority red, repeat priority red!					
	level.scr_sound["burke"]["fusion_brk_hackorblow"] = "fusion_brk_hackorblow";						//We can try to hack that thing or blow it to Hell!
	level.scr_radio[ "fusion_plt2_heavyactivity" ] = "fusion_plt2_heavyactivity";						
	level.scr_radio[ "fusion_plt2_copythat" ] = "fusion_plt2_copythat";	
	level.scr_radio[ "fusion_plt2_empinterference" ] = "fusion_plt2_empinterference";	
	level.scr_radio[ "fusion_plt1_insector" ] = "fusion_plt1_insector";									
*/
	
}

interior_prepare_dialogue()
{
	Burke = "burke";
	Joker = "joker";
	Carter = "carter";
	
	//Joker: <whistles>
	level.scr_sound[Joker][ "fusion_jkr_whistle" ]		= "fusion_jkr_whistle";
	//Burke: Stay sharp. Eyes out for civilians.
	level.scr_sound[Burke][ "fusion_brk_eyesoutforcivs" ]		= "fusion_brk_eyesoutforcivs";
	
	//Prophet: Fastest access to the lower floor is through the elevator shaft.
	level.scr_radio[ "fusion_hqr_fastestaccess" ]		= "fusion_hqr_fastestaccess";
	//Burke: Roger. Let's get these doors open.
	level.scr_sound[Burke][ "fusion_brk_doorsopened" ]		= "fusion_brk_doorsopened";
	
	//Joker: *grunt*
	level.scr_sound[Joker][ "fus_securityroom_3_30e_jkr" ]		= "fus_securityroom_3_30e_jkr";
	
	//Burke: One at a time, let's go.
	level.scr_sound[Burke][ "fusion_brk_rogeroneatatime" ]		= "fusion_brk_rogeroneatatime";
	
	//Joker: After you.
	level.scr_sound[Joker][ "fus_securityroom_3_30b_jkr" ]		= "fus_securityroom_3_30b_jkr";
	//Joker: You're up, Mitchell.
	level.scr_sound[Joker][ "fus_securityroom_3_30c_jkr" ]		= "fus_securityroom_3_30c_jkr";
	//Joker: Let's go, Mitchell.
	level.scr_sound[Joker][ "fus_securityroom_3_30d_jkr" ]		= "fus_securityroom_3_30d_jkr";

	
	//Burke: Clear.
	level.scr_sound[Burke][ "fusion_brk_clear" ]		= "fusion_brk_clear";
	
	//Burke: This way.
	level.scr_sound[Burke][ "fusion_brk_thisway" ]		= "fusion_brk_thisway";
	
	//Prophet: Bravo, reactor core temperature is climbing.
	level.scr_radio[ "fusion_hqr_reactortempclimbing" ]		= "fusion_hqr_reactortempclimbing";
//	//Burke: Roger, can the steam lines still bleed sufficiently?
//	level.scr_sound[Burke][ "fusion_brk_steamlinesbleed" ]		= "fusion_brk_steamlinesbleed";
	//Joker: That's bad news, right?
	level.scr_sound[Joker][ "fus_plantcorridors_3_34a_jkr" ]		= "fus_plantcorridors_3_34a_jkr";
	//Prophet: Indicators are below normal rate, but holding.
	level.scr_radio[ "fusion_hqr_indicatorsholding" ]		= "fusion_hqr_indicatorsholding";
	//Burke: Then we can still make it.
	level.scr_sound[Burke][ "fusion_brk_canstillmakeit" ]		= "fusion_brk_canstillmakeit";
	
//	//Carter: Any live terminals?
//	level.scr_sound[Carter][ "fusion_ctr_anyliveterms" ]		= "fusion_ctr_anyliveterms";
//	//Joker: Negative.
//	level.scr_sound[Joker][ "fusion_jkr_negative" ]		= "fusion_jkr_negative";
//	//Burke: Only the control room matters.
//	level.scr_sound[Burke][ "fusion_brk_onlycontrolroom" ]		= "fusion_brk_onlycontrolroom";
	
	//Joker: Poor bastards didn't stand a chance.
	level.scr_sound[Joker][ "fus_plantcorridors_3_39a_jkr" ]		= "fus_plantcorridors_3_39a_jkr";
	//Joker: Goddamn massacre in here.
	level.scr_sound[Joker][ "fus_plantcorridors_3_39b_jkr" ]		= "fus_plantcorridors_3_39b_jkr";
	//Burke: Keep moving.
	level.scr_sound[Burke][ "fus_plantcorridors_3_39c_brk" ]		= "fus_plantcorridors_3_39c_brk";
	
	//Burke: Junction.
	level.scr_sound[Burke][ "fusion_brk_junction" ]		= "fusion_brk_junction";
	//Prophet: Head right.  There's a shortcut, but you won't like it.
	level.scr_radio[ "fusion_hqr_shortcutyouwontlike" ]		= "fusion_hqr_shortcutyouwontlike";
	//Burke: Stay together.
	level.scr_sound[Burke][ "fusion_brk_staytogether" ]		= "fusion_brk_staytogether";

	//Burke: Carter, get this door open!
	level.scr_sound[Burke][ "fusion_brk_getdooropen" ]		= "fusion_brk_getdooropen";
	//Carter: Copy!
	level.scr_sound[Carter][ "fusion_ctr_copy" ]		= "fusion_ctr_copy";
	
	//Burke: <Exertion>
	level.scr_sound[Burke][ "fus_plantcorridors_3_41d_ctr" ]		= "fus_plantcorridors_3_41d_ctr";
	
	//Burke: Contact!
	level.scr_sound[Burke][ "fusion_brk_contact" ]		= "fusion_brk_contact";
	
	//Burke: Go, go, go!
	level.scr_sound[Burke][ "fusion_brk_gogogo" ]		= "fusion_brk_gogogo";
	
	//Prophet: Bravo, get through the reactor area as quickly as possible.
	level.scr_radio[ "fusion_hqr_getthroughquickly" ]		= "fusion_hqr_getthroughquickly";
	//Joker: We're not exactly stopping for coffee.
	level.scr_sound[Joker][ "fusion_jkr_stoppingforcoffee" ]		= "fusion_jkr_stoppingforcoffee";
	//Burke: Tangos on the balcony! Slot 'em!
	level.scr_sound[Burke][ "fusion_brk_tangosbalcony" ]		= "fusion_brk_tangosbalcony";
	
//	//Carter: I'm not sure we're supposed to be in here.
//	level.scr_sound[Carter][ "fusion_ctr_notsupposedtobeinhere" ]		= "fusion_ctr_notsupposedtobeinhere";
//	//Burke: We're safe as long as there's coolant water.
//	level.scr_sound[Burke][ "fusion_brk_safecoolantwater" ]		= "fusion_brk_safecoolantwater";
//	//Joker: There isn't much left.
//	level.scr_sound[Joker][ "fusion_jkr_isntmuchleft" ]		= "fusion_jkr_isntmuchleft";
//	//Burke: Then push though faster.
//	level.scr_sound[Burke][ "fusion_brk_pushthroughfaster" ]		= "fusion_brk_pushthroughfaster";
	
	//Prophet: You're 300 meters from the control room.
	level.scr_radio[ "fusion_hqr_300meters" ]		= "fusion_hqr_300meters";
	//Burke: Copy that! We've got heavy resistance in the reactor room!
	level.scr_sound[Burke][ "fusion_brk_heavyresistance" ]		= "fusion_brk_heavyresistance";
	//Prophet: Understood.
	level.scr_radio[ "fusion_hqr_understood" ]		= "fusion_hqr_understood";

	//Carter: These doors aren't supposed to be open.
	level.scr_sound[Carter][ "fusion_ctr_thesedoors" ]		= "fusion_ctr_thesedoors";
//	//Burke: This isn't a normal business day.
//	level.scr_sound[Burke][ "fusion_brk_normalbusinessday" ]		= "fusion_brk_normalbusinessday";
	//Joker: This ain't a normal business day.
	level.scr_sound[Joker][ "fus_reactorroom_3_49a_jkr" ]		= "fus_reactorroom_3_49a_jkr";

	
	//Burke: Prophet, we're at the cargo elevator.
	level.scr_sound[Burke][ "fusion_brk_cargoelevator" ]		= "fusion_brk_cargoelevator";
	//Prophet: Up one floor to the main level.
	level.scr_radio[ "fusion_hqr_uponefloor" ]		= "fusion_hqr_uponefloor";
	
	//Burke: Mitchell, hit the switch.
	level.scr_sound[Burke][ "fusion_brk_hittheswitch" ]		= "fusion_brk_hittheswitch";
	//Burke: Hit the button, Mitchell
	level.scr_sound[Burke][ "fusion_brk_hitthebutton" ]		= "fusion_brk_hitthebutton";
	
	//Joker: Is this the scenic route?
	level.scr_sound[Joker][ "fusion_jkr_thescenicroute" ]		= "fusion_jkr_thescenicroute";
	//Prophet: Only available path.
	level.scr_radio[ "fusion_hqr_onlyavailablepath" ]		= "fusion_hqr_onlyavailablepath";
//	//Burke: This is a killbox. Deploy cover at the door.
//	level.scr_sound[Burke][ "fusion_brk_killbox" ]		= "fusion_brk_killbox";
	//Joker: This is a damn killbox.
	level.scr_sound[Joker][ "fus_turbineelevator_3_51c_jkr" ]		= "fus_turbineelevator_3_51c_jkr";
	//Burke: Deploy cover at the door.
	level.scr_sound[Burke][ "fus_turbineelevator_3_51d_brk" ]		= "fus_turbineelevator_3_51d_brk";

	//Joker: Copy that.
	level.scr_sound[Joker][ "fusion_jkr_copythat" ]		= "fusion_jkr_copythat";
	
	//Burke: Exit's on the upper walkway!
	level.scr_sound[Burke][ "fusion_brk_upperwalkway" ]		= "fusion_brk_upperwalkway";
	//Joker: What?
	level.scr_sound[Joker][ "fusion_jkr_loudwhat" ]		= "fusion_jkr_loudwhat";
	//Burke: Upper walkway! Move!
	level.scr_sound[Burke][ "fusion_brk_upperwalkwaymove" ]		= "fusion_brk_upperwalkwaymove";
	//Joker: I can't hear a goddamn thing!
	level.scr_sound[Joker][ "fusion_jkr_canthearathing" ]		= "fusion_jkr_canthearathing";
	
	//Burke: Keep moving!
	level.scr_sound[Burke][ "fusion_brk_keepmovinginterior" ]		= "fusion_brk_keepmovinginterior";
	
	//Prophet: Bravo, output just spiked.
	level.scr_radio[ "fusion_hqr_outputspiked" ]		= "fusion_hqr_outputspiked";
	//Burke: We're almost there.
	level.scr_sound[Burke][ "fusion_brk_almostthere" ]		= "fusion_brk_almostthere";
	
	//Prophet: Control room dead ahead.
	level.scr_radio[ "fusion_hqr_controlroomahead" ]		= "fusion_hqr_controlroomahead";
	
	//Burke: There it is!
	level.scr_sound[Burke][ "fusion_brk_thereitis" ]		= "fusion_brk_thereitis";
	
	//Carter: <pain exertion> 
	level.scr_sound[Carter][ "fus_controlroom_3_58b_ctr" ]		= "fus_controlroom_3_58b_ctr";
	//Joker: The hell just happened?
	level.scr_sound[Joker][ "fusion_jkr_thehelljusthappened" ]		= "fusion_jkr_thehelljusthappened";
//	//Burke: They're covering their tracks.
//	level.scr_sound[Burke][ "fusion_brk_covingtheirtracks" ]		= "fusion_brk_covingtheirtracks";
	//Burke: They rigged the door.
	level.scr_sound[Burke][ "fus_controlroom_3_58a_brk" ]		= "fus_controlroom_3_58a_brk";
	//Carter: I'm good…
	level.scr_sound[Carter][ "fus_controlroom_3_58c_ctr" ]		= "fus_controlroom_3_58c_ctr";

	
//	//Carter: This console is still live.
//	level.scr_sound[Carter][ "fusion_ctr_thisconsolelive" ]		= "fusion_ctr_thisconsolelive";
	//Burke: This console is still live.
	level.scr_sound[Burke][ "fusion_brk_thisconsolelive" ]		= "fusion_brk_thisconsolelive";
	//Prophet: Patch in and run diagnostics.
	level.scr_radio[ "fusion_hqr_rundiagnostics" ]		= "fusion_hqr_rundiagnostics";
	
	//Burke: Mitchell, get on that console and keep an eye on the coolant levels.
	level.scr_sound[Burke][ "fusion_brk_mitchellgetonconsole" ]		= "fusion_brk_mitchellgetonconsole";
	//Burke: Mitchell, get on the console!
	level.scr_sound[Burke][ "fusion_brk_mitchellgetontheconsole" ]		= "fusion_brk_mitchellgetontheconsole";
	//Burke: Check the coolant levels, Mitchell! Now!
	level.scr_sound[Burke][ "fusion_brk_checkthecoolantlevels" ]		= "fusion_brk_checkthecoolantlevels";
	
	//Burke: Prophet, you got this?
	level.scr_sound[Burke][ "fusion_brk_prophetgotthis" ]		= "fusion_brk_prophetgotthis";
	//Prophet: Copy. We're seeing what you're seeing
	level.scr_radio[ "fusion_hqr_seeingwhatyoureseeing" ]		= "fusion_hqr_seeingwhatyoureseeing";
	//Burke: Ok, core temp is maintaining. Need to flood the cooling pools…wait! Levels are dropping!
	level.scr_sound[Burke][ "fusion_brk_levelsaredropping" ]		= "fusion_brk_levelsaredropping";
	//Prophet: The steam release lines have been cut off.
	level.scr_radio[ "fusion_hqr_steamreleasecutoff" ]		= "fusion_hqr_steamreleasecutoff";
	//Joker: Boss...
	level.scr_sound[Joker][ "fusion_jkr_boss" ]		= "fusion_jkr_boss";
	//Burke: Damn, it was stable a second ago! Trying to reroute!
	level.scr_sound[Burke][ "fusion_brk_tryingtoreroute" ]		= "fusion_brk_tryingtoreroute";
	//Prophet: Burke, core temperature is critical. Abort.
	level.scr_radio[ "fusion_hqr_criticalabort" ]		= "fusion_hqr_criticalabort";
	//Burke: I can do this...
	level.scr_sound[Burke][ "fusion_brk_icandothis" ]		= "fusion_brk_icandothis";
	//Joker: Burke!
	level.scr_sound[Joker][ "fusion_jkr_burke" ]		= "fusion_jkr_burke";
	//Burke: Shit!
	level.scr_sound[Burke][ "fusion_brk_shit" ]		= "fusion_brk_shit";
	//Prophet: We have a level 7 event. Withdraw from the area now!
	level.scr_radio[ "fusion_hqr_level7withdraw" ]		= "fusion_hqr_level7withdraw";

	//Burke: Copy that! Bravo, we're about to go critical! Let's go!
	level.scr_sound[Burke][ "fusion_brk_gocritical" ]		= "fusion_brk_gocritical";
	
	thread play_interior_dialogue();
}

init_dialogue_flags()
{
	flag_init( "flag_rooftop_combat_dialogue" );
	flag_init( "flag_boots_on_ground_dialogue" );
	flag_init( "flag_burke_rally_street_dialogue" );
	flag_init( "flag_burke_rally_street_dialogue_complete" );
	flag_init( "squad_out_dialogue_complete" );
	flag_init( "flag_bailout_vo" );
	flag_init( "flag_walker_reveal_dialogue_complete" );
	flag_init( "dialogue_playing" );
}

start_dialogue_threads()
{
	switch( level.start_point )
	{
		case "default":
			
		case "fly_in_animated":
			fly_in_dialogue();
			
		case "fly_in_animated_part2":
			fly_in_dialogue_part2();
			fly_in_rooftop_combat_dialogue();
			zip_rooftop_dialogue();
		
		case "courtyard":
			thread burke_rally_street_dialogue();
			thread use_mobile_cover_dialogue();
			thread m_turret_1_dead_dialogue();
			thread street_battle_dialogue();
			thread use_m_turret_dialogue();
			thread drone_guy_down_dialogue();
			thread player_enters_mobile_turret_dialogue();
			thread bail_out_of_turret_dialogue();
			thread enemy_walker_reveal_dialogue();
			
		case "control_room":
//			thread in_the_game_dialogue();
			
		case "cooling_tower":
//			thread restaurant_pre_meeting_dialogue();
				
		break;
		default:
//			AssertMsg("Unhandled start point " + level.start_point);
	}
}

fly_in_dialogue()
{		
	// Moving to fusion_aud.gsc	
//	wait 3;
//	radio_dialogue_queue_global( "fusion_plt1_315magnetic" ); 						//Two-one, we're bearing three one five magnetic at angels twelve, distance two nautical miles from the target, over.
//	radio_dialogue_queue_global( "fusion_plt2_enemypax" ); 							//Copy two-three, we have a visual on enemy pax in the northern lay down yard. Alpha has engaged multiple targets at GRG grid kilo four niner.
	
	wait 3.5;
	//PCap Sequencing in Audio:  level.burke_intro dialogue_queue_global( "fusion_brk_staticondisplay" ); 		//Prophet, Prophet, I'm getting a lot of static on my display, how copy?
	//PCap Sequencing in Audio:  radio_dialogue_queue_global( "fusion_hqr_signaldistortion" ); 					//We have signal distortion from hostile EMPs. Alpha team is fully engaged and taking heavy fire.
	
	wait 1;
	//PCap Sequencing in Audio:  level.burke_intro dialogue_queue_global( "fusion_brk_everyoneseeingthis" ); 	//Roger that. Everyone seeing this?
	//Now done as PCap Sequencing in Audio:  level.joker_intro dialogue_queue_global( "fusion_jkr_gotit" ); 					//Got it.
	//Now done as PCap Sequencing in Audio:  level.burke_intro dialogue_queue_global( "fusion_brk_meltdownscenario" ); 		//Alright, we're thirty seconds out! We have reliable SIGINT that the KVA have taken the plant's main control room and are breaching the reactor core! We're looking at a possible meltdown scenario! We hit the control room hard and clear them out!
	//Now done as PCap Sequencing in Audio:  level.burke_intro dialogue_queue_global( "fusion_brk_shitendsnoprisoners" ); 	//This shit ends in the control room. No prisoners.
	//Now done as PCap Sequencing in Audio:  level.burke_intro dialogue_queue_global( "fusion_brk_getinposition" ); 			//Get in position!
//	level.joker_intro dialogue_queue_global( "fusion_jkr_overtime" ); 				//Better be getting overtime for this.
//	level.carter_intro dialogue_queue_global( "fusion_ctr_onepiece" ); 				//Just want to get out of this in one piece.
}
	
fly_in_dialogue_part2()
{
	//snd_message("fly_in_dialogue_part2");

// HANDLING ALL FOLLOWING DIALOG IN fusion_aud.gsc to handle PCap synch.
//	wait 6;	
//	radio_dialogue_queue_global( "fusion_plt3_disengagingstealth" ); 				//Chopper 3: Disengaging stealth.
//	
//	radio_dialogue_queue_global( "fusion_plt3_restrictedroe" ); 					//Chopper 3: Two-three, understand we are still operating under a restricted ROE, over?
//	radio_dialogue_queue_global( "fusion_plt1_prosecutetargets" ); 					//Chopper 1: Negative on that restricted ROE, two-four, we are free to prosecute all targets, over.
//	
//	//Now done as PCap Sequencing in Audio: level.burke_intro dialogue_queue_global( "fusion_brk_panama" ); 				//Burke: Gonna be a good one, Mitchell. Like Panama, just with more radiation.
//	
//	// WAIT UNTIL aud_start_fusion_scene1_like_panama() is done!
//	
//	radio_dialogue_queue_global( "fusion_plt1_visualonplant" ); 					//Chopper 1: Wraith two-one, this is Wraith two-three, we have a visual on the plant, over.
//	radio_dialogue_queue_global( "fusion_plt2_copythat" ); 							//Chopper 2: Copy that two-three.
//	
//	snd_music_message( "mus_fusion_first_contact" );
//	thread radio_dialogue( "fusion_plt1_swarmcountermeasures" ); 					//Chopper 1: Contact, contact! Deploying SWARM countermeasures.
//	wait 1.5;
//	level.burke_intro thread dialogue_queue( "fusion_brk_holdon" ); 				//Burke: Hold on!
//	wait 1;
//	level.joker_intro dialogue_queue_global( "fusion_jkr_shit" ); 					//Joker: Shit!
//
//	wait 3;
//	radio_dialogue_queue_global( "fusion_plt3_tryingtostabilize" ); 				//Chopper 3: Wraith two-three, we're hit, we're hit! Trying to stabilize---!
//	radio_dialogue_queue_global( "fusion_plt1_twofourisdown" );						//Chopper 1: Two-four is down, two-four is down. 
//	
//	wait 1;
//	level.joker_intro dialogue_queue_global( "fusion_jkr_theymakeit" ); 			//Joker: Did they make it?
//	level.burke_intro dialogue_queue_global( "fusion_brk_nothingwecando" );			//Burke: Eyes forward, nothing we can do! Get ready to deploy!
//	radio_dialogue_queue_global( "fusion_plt1_24providesupport" ); 					//Chopper 1: Two-four, break position and provide support for Alpha, over.
//	radio_dialogue_queue_global( "fusion_plt4_copythat23" ); 						//Chopper 4: Copy that two-three.
}

fly_in_rooftop_combat_dialogue()
{
	flag_wait( "flag_rooftop_combat_dialogue" );

	radio_dialogue_queue_global( "fusion_plt1_hostilesinlz" ); 						//We've got hostiles in our LZ, copy.
	level.burke dialogue_queue_global( "fusion_brk_clearoutrooftops" ); 		//Roger! Bravo, clear out those rooftops!
	level.burke dialogue_queue_global( "fusion_brk_hitthosetangos" ); 		//Mitchell, hit those tangos on the roof!
	
	flag_wait( "flag_combat_zip_rooftop_complete" );
	
	if( !flag( "flag_player_cleared_rooftop" ))
	{
		level.burke dialogue_queue_global( "fusion_brk_trytokeepup" ); 		//Next time try to keep up, Mitchell.
	}
	
	if( flag( "flag_player_cleared_rooftop" ))
	{
		radio_dialogue_queue_global( "fusion_plt1_goodeffectontarget" ); 			//Good effect on target.
	}
}

zip_rooftop_dialogue()
{
	flag_wait( "flag_combat_zip_rooftop_complete" );
	
	thread zip_team_two_deployed_dialogue();
	
//	radio_dialogue_queue_global( "fusion_plt4_cominginhot" ); 						//Coming in hot.	
	radio_dialogue_queue_global( "fusion_plt1_lzisclear" ); 						//LZ is clear.
	radio_dialogue_queue_global( "fusion_plt1_inposition" ); 						//We are in position, Bravo.
	
	if( !flag( "flag_player_zip_started" ))
	{
		level.burke dialogue_queue_global( "fusion_brk_deploylines" ); 			//Let's do this! Deploy your lines!
	}
	
	flag_set( "squad_out_dialogue_complete" );
	thread burke_greets_alpha_dialogue();
	
	wait 5;
	
	if( !flag( "flag_player_zip_started" ))
	{
		level.burke dialogue_queue_global( "fusion_brk_mitchelldeploy" ); 	//Mitchell, deploy your zipline!
	}
}

zip_team_two_deployed_dialogue()
{
	flag_wait( "flag_squad_heli_2_unload" );
	radio_dialogue_queue_global( "fusion_plt4_teamtwodeploying" ); 					//Team two is deploying, over.
}

burke_greets_alpha_dialogue()
{
	flag_wait( "flag_boots_on_ground_dialogue" );
//	radio_dialogue_queue_global( "fusion_plt1_teamoneondeck" ); 					//Team one is on deck, over.
	level.burke dialogue_queue_global( "fusion_brk_bootsontheground" ); 			//Alpha, we are boots on the ground, coming in at your three o'clock!
	snd_music_message( "mus_fusion_welcome_to_the_party" );
	level.alpha_leader dialogue_queue_global( "fusion_aldr_welcometotheparty" ); 	//Welcome to the party, Bravo.
}

burke_rally_street_dialogue()
{
	flag_wait( "flag_burke_rally_street_dialogue" );
	level.burke dialogue_queue_global( "fusion_brk_rallyup" ); 						//Rally up!
	
	level.burke dialogue_queue_global( "fusion_brk_alphakneedeep" ); 				//Looks like Alpha is knee deep! We'll push forward with them to the target building!
	level.joker dialogue_queue_global( "fusion_jkr_yessir" ); 						//Yes sir!
	level.burke dialogue_queue_global( "fusion_brk_moveout" ); 						//Move out!
	level.burke dialogue_queue_global( "fusion_brk_weaponsfree" ); 					//Weapons free, boys!
	
	flag_set( "flag_burke_rally_street_dialogue_complete" );
}

use_mobile_cover_dialogue()
{
	level.player endon ( "player_linked_to_cover" );

	flag_wait_all( "flag_street_wall_1_explode", "flag_burke_rally_street_dialogue_complete" );
	
	if(!flag( "flag_mt_move_up_03" ))
	{
		level.burke dialogue_queue_global( "fusion_brk_mcds" ); 						//Mitchell, park it behind those MCDs and return fire!
	}
	wait 4;
	
	if(!flag( "flag_mt_move_up_03" ))
	{	
		level.joker dialogue_queue_global( "fusion_jkr_coverdrones" ); 					//Grab some cover behind those drones!
	}
}

drone_guy_down_dialogue()
{
	flag_wait( "flag_player_enters_mobile_turret" );
	
	flag_wait_or_timeout( "flag_spawn_gaz_01", 10 );
	level.carter dialogue_queue_global( "fusion_ctr_droneoperatordown" ); 			//Our drone operator just took one in the head! He's down, he's down!
}

m_turret_1_dead_dialogue()
{
	flag_wait( "flag_m_turret_dead" );
	wait 2;
	radio_dialogue_queue_global( "fusion_hqr_zuludown" ); 							//MT operator Zulu is down. Repeat, Zulu is down.
}

street_battle_dialogue()
{
	flag_wait( "flag_enemy_reinforcements_big_wave" );
	radio_dialogue_queue_global( "fusion_hqr_footmobilesinbound" ); 				//Twenty-plus foot mobiles inbound from the northwest.
	
	flag_wait_or_timeout( "flag_slow_explosions_1", 20 );
	level.burke dialogue_queue_global( "fusion_brk_pushingforward" ); 				//Keep pushing forward!
}

use_m_turret_dialogue()
{
	flag_wait( "flag_mt_move_up_03" );
	
	level endon ( "flag_player_starts_entering_mobile_turret" );
	
	level.joker dialogue_queue_global( "fusion_jkr_mtfunctional" ); 				//Burke, that MT is still functional!
	level.burke dialogue_queue_global( "fusion_brk_assonit" ); 						//Then someone get their ass on it!
}

player_enters_mobile_turret_dialogue()
{
	flag_wait( "flag_player_enters_mobile_turret" );
	//level.burke dialogue_queue_global( "fusion_brk_dosomedamage" ); 				//You've got 100mm rounds on the main cannon and Jdam missiles as your secondary! Do some damage!
	level.joker dialogue_queue_global( "fusion_jkr_dosomedamage" ); 				//You've got 25mm rounds on the main cannon and Jdam missiles as your secondary! Do some damage!
}

bail_out_of_turret_dialogue()
{
	level endon( "street_cleanup" );
	
	flag_wait( "flag_bailout_vo" );
	level.burke dialogue_queue_global( "fusion_brk_bailout" ); 						//Your MT is down! Bail out, bail out!
}

enemy_walker_reveal_dialogue()
{
	flag_wait( "flag_enemy_walker" );
	
	wait 3;
	
	level.burke dialogue_queue_global( "fusion_brk_kvarolledtitan" ); 				//Prophet, the KVA just rolled a Titan in the middle of the damn courtyard!
	radio_dialogue_queue_global( "fusion_hqr_copythatlauncheranddrone" ); 			//Copy that Bravo, we've got eyes on a launcher near your postion, and a hack drone on top of the parking structure.
	
	flag_set( "flag_walker_reveal_dialogue_complete" );
	
	if ( !player_has_weapon( "smaw_nolock_fusion" ) )
	{
		level.burke dialogue_queue_global( "fusion_brk_launcherorhackdrone" ); 			//Mitchell, grab that launcher or the hack drone and take down that Titan!
	}
	
	thread hit_enemy_walker_nag();
	thread walker_trophy_system_dialogue();
	thread enemy_walker_destroyed_dialogue();
}

walker_trophy_system_dialogue()
{
	flag_wait( "walker_trophy_1" );
	wait 0.5;
	level.joker dialogue_queue_global( "fusion_jkr_bastardtrophy" );
}

hit_enemy_walker_nag()
{
	level endon( "flag_walker_death_anim_start" );
	
	while( 1 )
	{
		wait 10;
		level.burke dialogue_queue_global( "fusion_brk_takeoutthetitan" ); 			//Take out the Titan with the launcher, Mitchell!
		
		wait 10;
		level.burke dialogue_queue_global( "fusion_brk_hittitanlauncher" ); 		//Hit the Titan with the launcher!
	}
}

enemy_walker_destroyed_dialogue()
{
	flag_wait( "flag_walker_destroyed" );
	level.burke dialogue_queue_global( "fusion_brk_titansdowngoodjob" ); 			//Titan's down! Good job, Mitchell!
	
	wait 1;
	radio_dialogue_queue_global( "fusion_hqr_notime" ); 							//Bravo team, be advised. KVA technicians have overridden the security protocol and are attempting to trigger a critical event. We have no time.
	level.burke dialogue_queue_global( "fusion_brk_copythatprophet" ); 				//Copy that, Prophet! We are inbound!
	level.burke dialogue_queue_global( "fusion_brk_legitcontrolbuilding" ); 		//We gotta leg it to the control building! Let's move!
}

//////////////////////////////////
//////////// INTERIOR ////////////
//////////////////////////////////

play_interior_dialogue()
{
	thread vo_interior_security_room();
	thread vo_interior_lab();
	thread vo_interior_reactor();
	thread vo_interior_turbine_elevator();
	thread vo_interior_turbine_room();
	thread vo_interior_control_room_explosion();
	thread vo_interior_control_room();
}

vo_interior_security_room()
{
	flag_wait( "vo_security_room" );
	
	flag_set( "update_obj_pos_control_room_console" );
	
	wait 1;
	
	//Joker: <whistles>
	level.joker dialogue_queue( "fusion_jkr_whistle" );
	
	//Burke: Stay sharp. Eyes out for civilians.
	level.burke dialogue_queue( "fusion_brk_eyesoutforcivs" );
	
	flag_wait( "vo_security_room_elevator_access" );
	
	//Prophet: Fastest access to the lower floor is through the elevator shaft.
	radio_dialogue( "fusion_hqr_fastestaccess" );
	//Burke: Roger. Let's get these doors open.
	level.burke dialogue_queue( "fusion_brk_doorsopened" );
	
	flag_wait( "vo_security_room_elevator_open" );

	wait 0.5;
	//Joker: *grunt*
	level.joker dialogue_queue( "fus_securityroom_3_30e_jkr" );
	
	wait 1;
	//don't play the line if the player jumps early
	if( !flag( "elevator_descent_player" ) )
	{
		//Burke: One at a time, let's go.
		level.burke dialogue_queue( "fusion_brk_rogeroneatatime" );
		
		thread vo_elevator_descent_nag();
	}
}

vo_elevator_descent_nag()
{
	level endon( "elevator_descent_player" );
	while( !flag( "elevator_descent_player" ) )
	{
		wait 10;
		//Joker: After you.
		level.joker dialogue_queue( "fus_securityroom_3_30b_jkr" );

		wait 10;		
		//Joker: You're up, Mitchell.
		level.joker dialogue_queue( "fus_securityroom_3_30c_jkr" );
		
		wait 10;
		//Joker: Let's go, Mitchell.
		level.joker dialogue_queue( "fus_securityroom_3_30d_jkr" );
	}
}

vo_interior_lab()
{
	flag_wait( "vo_lab_elevator_slide_complete" );
	
	//Burke: Clear.
	level.burke dialogue_queue( "fusion_brk_clear" );
	wait 1;
	
	//Burke: This way.
	level.burke dialogue_queue( "fusion_brk_thisway" );
	wait 1;
	
	//Prophet: Bravo, reactor core temperature is climbing.
	radio_dialogue( "fusion_hqr_reactortempclimbing" );
	
	//Joker: That's bad news, right?
	level.joker dialogue_queue( "fus_plantcorridors_3_34a_jkr" );
	
	//Prophet: Indicators are below normal rate, but holding.
	radio_dialogue( "fusion_hqr_indicatorsholding" );
	
	//Burke: Then we can still make it.
	level.burke dialogue_queue( "fusion_brk_canstillmakeit" );
	
	flag_wait( "vo_lab_entered" );
//	//Carter: Any live terminals?
//	level.carter dialogue_queue( "fusion_ctr_anyliveterms" );
//	//Joker: Negative.
//	level.joker dialogue_queue( "fusion_jkr_negative" );
//	//Burke: Only the control room matters.
//	level.burke dialogue_queue( "fusion_brk_onlycontrolroom" );
	
	if( cointoss() )
	{
		//Joker: Poor bastards didn't stand a chance.
		level.joker dialogue_queue( "fus_plantcorridors_3_39a_jkr" );
	}
	else
	{
		//Joker: Goddamn massacre in here.
		level.joker dialogue_queue( "fus_plantcorridors_3_39b_jkr" );
	}
	//Burke: Keep moving.
	level.burke dialogue_queue( "fus_plantcorridors_3_39c_brk" );
	
	flag_wait( "vo_lab_junction" );
	//Burke: Junction.
	level.burke dialogue_queue( "fusion_brk_junction" );
	//Prophet: Head right.  There's a shortcut, but you won't like it.
	radio_dialogue( "fusion_hqr_shortcutyouwontlike" );
	//Burke: Stay together.
	level.burke dialogue_queue( "fusion_brk_staytogether" );
	
}

vo_interior_reactor()
{
	flag_wait( "vo_reactor_open_airlock" );
	//Burke: Carter, get this door open!
	level.burke dialogue_queue( "fusion_brk_getdooropen" );
	//Carter: Copy!
	level.carter dialogue_queue( "fusion_ctr_copy" );
	
	flag_wait( "vo_reactor_entrance" );
	wait 9;
	//Burke: <Exertion>
	level.burke dialogue_queue( "fus_plantcorridors_3_41d_ctr" );
	
	wait 3;
	//Burke: Contact!
	level.burke dialogue_queue( "fusion_brk_contact" );
	
	flag_wait( "vo_reactor_gogogo" );
	//Burke: Go, go, go!
	level.burke dialogue_queue( "fusion_brk_gogogo" );
	
	flag_wait( "vo_reactor_quickly" );
	//Prophet: Bravo, get through the reactor area as quickly as possible.
	radio_dialogue( "fusion_hqr_getthroughquickly" );
	//Joker: We're not exactly stopping for coffee.
	level.joker dialogue_queue( "fusion_jkr_stoppingforcoffee" );
	//Burke: Tangos on the balcony! Slot 'em!
	level.burke dialogue_queue( "fusion_brk_tangosbalcony" );
	
//	flag_wait( "vo_reactor_be_here" );
//	//Carter: I'm not sure we're supposed to be in here.
//	level.carter dialogue_queue( "fusion_ctr_notsupposedtobeinhere" );
//	//Burke: We're safe as long as there's coolant water.
//	level.burke dialogue_queue( "fusion_brk_safecoolantwater" );
//	//Joker: There isn't much left.
//	level.joker dialogue_queue( "fusion_jkr_isntmuchleft" );
//	//Burke: Then push though faster.
//	level.burke dialogue_queue( "fusion_brk_pushthroughfaster" );
	
	flag_wait( "vo_reactor_300m" );
	//Prophet: You're 300 meters from the control room.
	radio_dialogue( "fusion_hqr_300meters" );
	//Burke: Copy that! We've got heavy resistance in the reactor room!
	level.burke dialogue_queue( "fusion_brk_heavyresistance" );
	//Prophet: Understood.
	radio_dialogue( "fusion_hqr_understood" );
	
	flag_wait( "vo_reactor_exit" );
	//Carter: These doors aren't supposed to be open.
	level.carter dialogue_queue( "fusion_ctr_thesedoors" );
//	//Burke: This isn't a normal business day.
//	level.burke dialogue_queue( "fusion_brk_normalbusinessday" );
	//Joker: This ain't a normal business day.
	level.joker dialogue_queue( "fus_reactorroom_3_49a_jkr" );
}

vo_interior_turbine_elevator()
{
	flag_wait( "vo_turbine_elevator_near" );
	
	//Burke: Prophet, we're at the cargo elevator.
	level.burke dialogue_queue( "fusion_brk_cargoelevator" );
	//Prophet: Up one floor to the main level.
	radio_dialogue( "fusion_hqr_uponefloor" );
	//Joker: Is this the scenic route?
//	level.joker dialogue_queue( "fusion_jkr_thescenicroute" );
//	//Prophet: Only available path.
//	radio_dialogue( "fusion_hqr_onlyavailablepath" );
	flag_wait( "vo_turbine_elevator_ready" );
	
	thread vo_interior_turbine_elevator_nag();
	
	flag_wait( "vo_turbine_elevator" );
	//Joker: Is this the scenic route?
//	level.joker dialogue_queue( "fusion_jkr_thescenicroute" );
//	//Prophet: Only available path.
//	radio_dialogue( "fusion_hqr_onlyavailablepath" );
//	//Burke: This is a killbox. Deploy cover at the door.
//	level.burke dialogue_queue( "fusion_brk_killbox" );
	//Joker: This is a damn killbox.
	level.joker dialogue_queue( "fus_turbineelevator_3_51c_jkr" );
	//Burke: Deploy cover at the door.
	level.burke dialogue_queue( "fus_turbineelevator_3_51d_brk" );
	//Joker: Copy that.
	level notify( "joker_place_elevator_cover" );
	
	level.joker dialogue_queue( "fusion_jkr_copythat" );
}

vo_interior_turbine_elevator_nag()
{
	level endon( "vo_turbine_elevator" );
	
	while( 1 )
	{
		//Burke: Mitchell, hit the switch.
		level.burke dialogue_queue( "fusion_brk_hittheswitch" );
		
		wait randomintrange( 5, 10 );
		
		//Burke: Hit the button, Mitchell
		level.burke dialogue_queue( "fusion_brk_hitthebutton" );
		
		wait randomintrange( 5, 10 );
	}
}

vo_interior_turbine_room()
{
	flag_wait( "vo_turbine_room_entrance" );
	
	//Burke: Exit's on the upper walkway!
	level.burke dialogue_queue( "fusion_brk_upperwalkway" );
	//Joker: What?
	level.joker dialogue_queue( "fusion_jkr_loudwhat" );
	//Burke: Upper walkway! Move!
	level.burke dialogue_queue( "fusion_brk_upperwalkwaymove" );
	//Joker: I can't hear a goddamn thing!
	level.joker dialogue_queue( "fusion_jkr_canthearathing" );
	
	flag_wait( "vo_turbine_keep_moving" );
	
	//Burke: Keep moving!
	level.burke dialogue_queue( "fusion_brk_keepmovinginterior" );
	
	flag_wait( "vo_turbine_explosion" );
	//Prophet: Bravo, output just spiked.
	radio_dialogue( "fusion_hqr_outputspiked" );
	//Burke: We're almost there.
	level.burke dialogue_queue( "fusion_brk_almostthere" );
}

vo_interior_control_room_explosion()
{
		//on door kick stack
	flag_wait( "vo_control_hall_door_stack" );
	autosave_by_name( "control_room_start" );
	
	//Prophet: Control room dead ahead.
	radio_dialogue( "fusion_hqr_controlroomahead" );
	
	//after kick
	flag_wait( "vo_control_hall_door_kicked" );
	//Burke: There it is!
	level.burke dialogue_queue( "fusion_brk_thereitis" );
	
	//on explosion
	flag_wait( "vo_control_room_explosion" );
	
	wait 0.1;
	//Carter: <pain exertion> 
	level.carter dialogue_queue( "fus_controlroom_3_58b_ctr" );
	
	wait 1.2;
	//Joker: The hell just happened?
	level.joker dialogue_queue( "fusion_jkr_thehelljusthappened" );
//	//Burke: They're covering their tracks.
//	level.burke dialogue_queue( "fusion_brk_covingtheirtracks" );
	//Burke: They rigged the door.
	level.burke dialogue_queue( "fus_controlroom_3_58a_brk" );
	//Carter: I'm good…
	level.carter dialogue_queue( "fus_controlroom_3_58c_ctr" );
	
	wait 4;
	//Burke: This console is still live.
	level.burke dialogue_queue( "fusion_brk_thisconsolelive" );
	
	//Prophet: Patch in and run diagnostics.
	radio_dialogue( "fusion_hqr_rundiagnostics" );
	
	flag_set( "update_obj_pos_control_room_console" );
	flag_set( "control_room_console_enable" );
	
	thread vo_interior_control_room_nag();
}

vo_interior_control_room_nag()
{
	level endon( "vo_control_room_scene" );
	
	while( 1 )
	{
		//Burke: Mitchell, get on that console and keep an eye on the coolant levels.
		level.burke dialogue_queue( "fusion_brk_mitchellgetonconsole" );
		
		flag_wait( "control_room_scene_ready" );
		
		wait randomintrange( 5, 10 );
		
		//Burke: Mitchell, get on the console!
		level.burke dialogue_queue( "fusion_brk_mitchellgetontheconsole" );
		
		wait randomintrange( 5, 10 );
		
		//Burke: Check the coolant levels, Mitchell! Now!
		level.burke dialogue_queue( "fusion_brk_checkthecoolantlevels" );
		
		wait randomintrange( 5, 10 );
	}
}

vo_interior_control_room()
{
	//PCAP VO - All dialogue is now called from fusion_aud.gsc, functions aud_start_fusion_controlroom_dialog_burke(param) and aud_start_fusion_controlroom_dialog_joker(param)
	
	flag_wait( "vo_control_room_scene" );
	
	wait 16.5;
	level notify( "control_room_event_1" );
	
	wait 3.4;
	level notify( "control_room_event_2" );
	
	wait 3.4;
	level notify( "control_room_event_3" );
	
	wait 1.7;
	autosave_by_name( "control_room_complete" );
	
	wait 3;

	flag_wait("fusion_controlroom_dialog_done");
	
	flag_set( "shutdown_reactor_failed" );
	
	self notify( "control_room_scene_complete" );
	
}

/*
=============
///ScriptDocBegin
"Name: dialogue_queue_global(line, timeout)"
"Summary: puts dialogue onto a global queue.  Once all lines previously queued by dialogue_queue_global() and radio_dialogue_queue_global() are done, this line will play on the actor"
"CallOn: actor"
"Module: Utility"
"MandatoryArg: <msg>: the dialogue line to play, which must have the corresponding soundalias stored in level.scr_sound[self.animname][line]"
"OptionalArg: <timeout>: optional timeout to forget the dialogue if it's been in the queue for longer than this many seconds"
"Example: level.burke_intro dialogue_queue_global( "fusion_brk_staticondisplay" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
dialogue_queue_global(line, timeout)
{
	Assert(IsSentient(self));
	Assert(IsDefined(line));
	Assert(IsDefined(self.animname));
	Assert(IsDefined(level.scr_sound[self.animname]));
	Assert(IsDefined(level.scr_sound[self.animname][line]));
	Assert(SoundExists(level.scr_sound[self.animname][line]));
	
	if(IsDefined(level.scr_sound[self.animname][line]))
		global_dialogue_internal(line, self, timeout);
}

/*
=============
///ScriptDocBegin
"Name: radio_dialogue_queue_global(line, timeout)"
"Summary: puts radio dialogue onto a global queue.  Once all lines previously queued by dialogue_queue_global() and radio_dialogue_queue_global() are done, this line will play"
"Module: Utility"
"MandatoryArg: <msg>: the radio dialogue line to play, which must have the corresponding soundalias stored in level.scr_radio[line]"
"OptionalArg: <timeout>: optional timeout to forget the radio dialogue if it's been in the queue for longer than this many seconds"
"Example: radio_dialogue_queue_global( "fusion_plt1_315magnetic" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
radio_dialogue_queue_global(line, timeout)
{
	Assert(IsDefined(level.scr_radio[line]));
	Assert(SoundExists(level.scr_radio[line]));
	
	if(IsDefined(level.scr_radio[line]))
		global_dialogue_internal(line, undefined, timeout);
}

global_dialogue_internal(line, actor, timeout)
{
	if(!IsDefined(level.global_dialogue_function_stack))
		level.global_dialogue_function_stack = SpawnStruct();
	
	if(IsDefined(actor))
	{
		if(IsDefined(timeout))
			level.global_dialogue_function_stack function_stack_timeout(timeout, ::global_dialogue_internal_play_dialogue, line, actor);
		else
			level.global_dialogue_function_stack function_stack(::global_dialogue_internal_play_dialogue, line, actor);
	}
	else
	{
		if(IsDefined(timeout))
			level.global_dialogue_function_stack function_stack_timeout(timeout, ::global_dialogue_internal_play_radio, line);
		else
			level.global_dialogue_function_stack function_stack(::global_dialogue_internal_play_radio, line);
	}
}

global_dialogue_internal_play_dialogue(line, actor)
{
	if(IsDefined(actor))
	{
		/# thread dialog_watchdog("dialogue line " + line + " on actor " + actor.animname + " didn't return after 60 seconds", 60); #/
		
		flag_set( "dialogue_playing" );
		
		bcs_scripted_dialogue_start();
		// this has its own per-actor queuing system :-/
		actor anim_single_queue(actor, line);
		
		flag_clear( "dialogue_playing" );
	
		/# level notify("stop_dialogue_watchdog"); #/
	}
	else
	{
		/#
			if(GetDebugDvarInt("developer") != 0)
				IPrintLn("actor died before playing line " + line);
		#/
	}
}

global_dialogue_internal_play_radio(line)
{
	/# thread dialog_watchdog("radio dialogue line " + line + " didn't return after 60 seconds", 60); #/
	
	flag_set( "dialogue_playing" );
	
	// this has its own queuing system, they should not conflict
	radio_dialogue(line);
	
	flag_clear( "dialogue_playing" );
		
	/# level notify("stop_dialogue_watchdog"); #/
}

/#
dialog_watchdog(message, timeout)
{
	level endon("stop_dialogue_watchdog");
	wait timeout;
	AssertEx(false, message);
}
#/
