#include maps\_utility;
#using_animtree("generic_human");
main()
{
	load_dummy_anims();
	level.scr_anim["price"]["fh_kickdoor"]		= (%bergstein_doorkick_kicker_kick);

	dialog();
}

dialog()
{
	level.scr_face["macgregor"]["mcg_arty_realtarget"] = %artillery_mcg_sc01_01_t2_head;
	level.scrsound["macgregor"]["mcg_arty_realtarget"]		= "mcg_arty_realtarget";

	level.scr_face["macgregor"]["gimmetarget"] = %artillery_mcg_sc01_01_t2_head;
	//scrsound defined in _artillery

	level.scr_face["macgregor"]["firemission"] = %artillery_mcg_sc01_05a_t1_head;
	//scrsound defined in _artillery
	level.scr_face["macgregor"]["mcg_arty_firemissiontrp"] = %artillery_mcg_sc01_05a_t1_head;
	level.scrsound["macgregor"]["mcg_arty_firemissiontrp"]		= "mcg_arty_firemissiontrp";

	level.scr_face["macgregor"]["pointfuse"] = %artillery_mcg_sc01_05b_t1_head;
	//scrsound defined in _artillery


	level.scr_face["macgregor"]["decoytown_mcg_needartillerysupport"]		= %decoytown_mcg_sc03_06_t3_head;
	level.scrsound["macgregor"]["decoytown_mcg_needartillerysupport"]		= "decoytown_mcg_needartillerysupport";

	level.scr_face["macgregor"]["decoytown_mcg_boutbloodytime"]		= %decoytown_mcg_sc03_08_t1_head;
	level.scrsound["macgregor"]["decoytown_mcg_boutbloodytime"]		= "decoytown_mcg_boutbloodytime";

	level.scr_face["macgregor"]["decoytown_mcg_lastofthehuns"]		= %decoytown_mcg_sc05_04_t8_head;
	level.scrsound["macgregor"]["decoytown_mcg_lastofthehuns"]		= "decoytown_mcg_lastofthehuns";


	level.scr_face["macgregor"]["mcg_arty_daftie"]				= %artillery_mcg_sc01_02_t1_head;
	level.scrsound["macgregor"]["mcg_arty_daftie"]		= "mcg_arty_daftie";

	level.scr_face["macgregor"]["mcg_arty_bampot"]				= %artillery_mcg_sc01_03_t2_head;
	level.scrsound["macgregor"]["mcg_arty_bampot"]		= "mcg_arty_bampot";

	level.scr_face["macgregor"]["mcg_arty_propertarget"]			= %artillery_mcg_sc01_04_t1_head;
	level.scrsound["macgregor"]["mcg_arty_propertarget"]		= "mcg_arty_propertarget";

	level.scr_face["macgregor"]["coord0"] 						= %artillery_mcg_05a_t1_head;	// no zero anim																				
	level.scr_face["macgregor"]["coord1"] 						= %artillery_mcg_01a_t1_head;																					
	level.scr_face["macgregor"]["coord2"] 						= %artillery_mcg_02a_t1_head;																					
	level.scr_face["macgregor"]["coord3"] 						= %artillery_mcg_03a_t1_head;																					
	level.scr_face["macgregor"]["coord4"] 						= %artillery_mcg_04a_t1_head;																					
	level.scr_face["macgregor"]["coord5"] 						= %artillery_mcg_05a_t1_head;																					
	level.scr_face["macgregor"]["coord6"] 						= %artillery_mcg_06a_t1_head;																					
	level.scr_face["macgregor"]["coord7"] 						= %artillery_mcg_07a_t1_head;																					
	level.scr_face["macgregor"]["coord8"] 						= %artillery_mcg_08a_t1_head;																					
	level.scr_face["macgregor"]["coord9"] 						= %artillery_mcg_09a_t1_head;																					
	//scrsound defined in _artillery


	level.scr_face["macgregor"]["requestnew"] 					= undefined;
	level.scr_face["macgregor"]["notvalid"] 					= undefined;
	level.scr_face["macgregor"]["tooclose"] 					= undefined;
	level.scr_face["macgregor"]["nomoreavail"] 					= undefined;
	level.scr_face["macgregor"]["battery"] 						= undefined;
	level.scr_face["macgregor"]["reloading"] 					= undefined;
	level.scr_face["macgregor"]["shot"] 						= undefined;
	
	level.scrsound["macgregor"]["british_arty_tooclose"]		= "british_arty_tooclose";
	
	level.scrsound["macgregor"]["decoytown_mcg_didnthavetime"]		= "decoytown_mcg_didnthavetime";
	level.scrsound["macgregor"]["decoytown_mcg_townsoimportant"]		= "decoytown_mcg_townsoimportant";
	level.scrsound["macgregor"]["decoytown_mcg_fullofgoodnews"]		= "decoytown_mcg_fullofgoodnews";
	level.scrsound["macgregor"]["decoytown_mcg_alreadyonit"]		= "decoytown_mcg_alreadyonit";
	level.scrsound["macgregor"]["decoytown_mcg_queensix"]		= "decoytown_mcg_queensix";
	level.scrsound["macgregor"]["decoytown_mcg_tellrommel"]		= "decoytown_mcg_tellrommel";

	level.scrsound["macgregor"]["decoytown_mcg_rallypointfox"]		= "decoytown_mcg_rallypointfox";
	level.scrsound["macgregor"]["decoytown_mcg_timetoarty"]		= "decoytown_mcg_timetoarty";
	level.scrsound["macgregor"]["decoytown_mcg_letjerriesthru"]		= "decoytown_mcg_letjerriesthru";
	level.scrsound["macgregor"]["decoytown_mcg_wherearty"]		= "decoytown_mcg_wherearty";
	level.scrsound["macgregor"]["decoytown_mcg_nowgood"]		= "decoytown_mcg_nowgood";
	level.scrsound["macgregor"]["decoytown_mcg_canyoureadme"]		= "decoytown_mcg_canyoureadme";
	level.scrsound["macgregor"]["decoytown_mcg_usebinoc"]		= "decoytown_mcg_usebinoc";


	level.scrsound["price"]["decoytown_pri_gettoflak"]		= "decoytown_pri_gettoflak";
	level.scrsound["price"]["decoytown_pri_rooftop"]		= "decoytown_pri_rooftop";
	level.scrsound["price"]["decoytown_pri_chokepoint"]		= "decoytown_pri_chokepoint";
	level.scrsound["price"]["decoytown_pri_takeuppositions"]		= "decoytown_pri_takeuppositions";
	level.scrsound["price"]["decoytown_pri_krautmgsfiring"]		= "decoytown_pri_krautmgsfiring";
	level.scrsound["price"]["decoytown_pri_checkstatusofgun"]		= "decoytown_pri_checkstatusofgun";
	level.scrsound["price"]["decoytown_pri_enemytosouth"]		= "decoytown_pri_enemytosouth";
	level.scrsound["price"]["decoytown_pri_moregermanunits"]		= "decoytown_pri_moregermanunits";
	level.scrsound["price"]["decoytown_pri_jerrytankswest"]		= "decoytown_pri_jerrytankswest";
	level.scrsound["price"]["decoytown_pri_approachingwest"]		= "decoytown_pri_approachingwest";
	level.scrsound["price"]["decoytown_pri_moreenemyarmor"]		= "decoytown_pri_moreenemyarmor";
	level.scrsound["price"]["decoytown_pri_southwestenemy"]		= "decoytown_pri_southwestenemy";
	level.scrsound["price"]["decoytown_pri_enemyreinforcements"]		= "decoytown_pri_enemyreinforcements";
	level.scrsound["price"]["decoytown_pri_morejerries"]		= "decoytown_pri_morejerries";
	level.scrsound["price"]["decoytown_pri_reinforcementseast"]		= "decoytown_pri_reinforcementseast";
	level.scrsound["price"]["decoytown_pri_flakwest"]		= "decoytown_pri_flakwest";
	level.scrsound["price"]["decoytown_pri_tankstowest"]		= "decoytown_pri_tankstowest";
	level.scrsound["price"]["decoytown_pri_usebinoc"]		= "decoytown_pri_usebinoc";

//	level.scrsound["Wellington"]["decoytown_wel_itappears"]		= "decoytown_wel_itappears";
//	level.scrsound["Wellington"]["decoytown_wel_montyspulling"]		= "decoytown_wel_montyspulling";

	level.scrsound["soldier1"]["decoytown_bs1_krautsalreadyhere"]		= "decoytown_bs1_krautsalreadyhere";
	level.scrsound["soldier1"]["decoytown_bs1_gotthebastards"]		= "decoytown_bs1_gotthebastards";

	level.scrsound["soldier2"]["decoytown_bs2_yessir"]		= "decoytown_bs2_yessir";
	level.scrsound["soldier2"]["decoytown_bs2_yessir"]		= "decoytown_bs2_yessir";
	level.scrsound["soldier2"]["decoytown_bs2_breakwestflank"]		= "decoytown_bs2_breakwestflank";
	level.scrsound["soldier2"]["decoytown_bs2_tankstosouthwest"]		= "decoytown_bs2_tankstosouthwest";
	level.scrsound["soldier2"]["decoytown_bs2_onetanknorthwest"]		= "decoytown_bs2_onetanknorthwest";
	level.scrsound["soldier2"]["decoytown_bs2_onetanksouthwest"]		= "decoytown_bs2_onetanksouthwest";

	level.scrsound["soldier3"]["decoytown_bs3_flakgone"]		= "decoytown_bs2_yessir";
	level.scrsound["soldier3"]["decoytown_bs3_onetanksouth"]		= "decoytown_bs3_onetanksouth";
	level.scrsound["soldier3"]["decoytown_bs3_tankstonorthwest"]		= "decoytown_bs3_tankstonorthwest";
	level.scrsound["soldier3"]["decoytown_bs3_defendnorthfoot"]		= "decoytown_bs3_defendnorthfoot";
	level.scrsound["soldier3"]["decoytown_bs3_swdontletthru"]		= "decoytown_bs3_swdontletthru";
	level.scrsound["soldier3"]["decoytown_bs3_northwestcomeon"]		= "decoytown_bs3_northwestcomeon";


	level.scrsound["soldier4"]["decoytown_bs4_southernapproach"]		= "decoytown_bs4_southernapproach";
	level.scrsound["soldier4"]["decoytown_bs4_onetankwest"]		= "decoytown_bs4_onetankwest";
	level.scrsound["soldier4"]["decoytown_bs4_tankstosouth"]		= "decoytown_bs4_tankstosouth";
	level.scrsound["soldier4"]["decoytown_bs4_onetankwest"]		= "decoytown_bs4_onetankwest";
	level.scrsound["soldier4"]["decoytown_bs4_cantcovernorth"]		= "decoytown_bs4_cantcovernorth";
	
	
	thread artillery_tooclose_alternate();

}

artillery_tooclose_alternate()
{
	dialog = [];
	dialogque = [];
	aliasconnector = [];
	
	denialReason = "no target";
	aliasconnector[denialReason] = "gimmetarget";
	dialog[denialReason] = [];
	dialog[denialReason][dialog[denialReason].size] = "mcg_arty_realtarget";
	dialog[denialReason][dialog[denialReason].size] = "mcg_arty_propertarget";
	dialogque[denialReason] = array_randomize(dialog[denialReason]);

	denialReason = "too close";
	aliasconnector[denialReason] = "tooclose";
	dialog[denialReason] = [];
	dialog[denialReason][dialog[denialReason].size] = "british_arty_tooclose";
	dialog[denialReason][dialog[denialReason].size] = "mcg_arty_bampot";
	dialog[denialReason][dialog[denialReason].size] = "mcg_arty_daftie";
	dialogque[denialReason] = array_randomize(dialog[denialReason]);

	while(1)
	{
		level waittill ("artillery_denial",denialReason);
		if(!isdefined(dialog[denialReason]))
			continue;
		dialogque[denialReason] = artillery_setdialog(dialogque[denialReason],dialog[denialReason],aliasconnector[denialReason]);	
	}
}

artillery_setdialog(dialogque,dialog,aliasconnector)
{
	pick = randomint(dialogque.size);
	level.scrsound["macgregor"][aliasconnector] = dialogque[pick];
	level.scr_face["macgregor"][aliasconnector] = level.scr_face["macgregor"][dialogque[pick]];
	dialogque = array_remove(dialogque,dialogque[pick]);
	if(!dialogque.size)
		dialogque = array_randomize(dialog);
	return dialogque;
}


#using_animtree("animation_rig_largegroup20");
load_dummy_anims()
{
	thread load_dummy_anims_drones();
}

#using_animtree("drones");
load_dummy_anims_drones()
{

//	level.drone_mortar[0] = loadfx ("fx/impacts/beach_mortar.efx");
//	level.drone_mortar[1] = loadfx ("fx/impacts/dirthit_mortar.efx");

	level.scr_sound ["exaggerated flesh impact"] = "bullet_mega_flesh"; // Commissar shot by sniper (exaggerated cinematic type impact)
    level._effect["ground"]	= loadfx ("fx/impacts/small_gravel.efx");
	level._effect["flesh small"] = loadfx ("fx/impacts/flesh_hit.efx");
	level.scr_dyingguy["effect"][0] = "ground";
	level.scr_dyingguy["effect"][1] = "flesh small";
	level.scr_dyingguy["sound"][0] = level.scr_sound ["exaggerated flesh impact"];
	level.scr_dyingguy["tag"][0] = "J_Hip_LE";
	level.scr_dyingguy["tag"][1] = "J_Shoulder_RI";
	level.scr_dyingguy["tag"][2] = "J_Index_LE_3";
	level.scr_dyingguy["tag"][3] = "J_Thumb_RI_1";
	level.scr_dyingguy["tag"][4] = "J_Knee_LE";
	level.scr_dyingguy["tag"][5] = "J_Clavicle_RI";
	level.scr_anim["flag drone"]["run"][0] = (%precombatrun1);
	level.scr_anim["flag drone"]["walk"][0] = (%precombatrun1);
	level.scr_anim["flag drone"]["death"][0] = (%death_run_forward_crumple);


	character\british_infantry_africa_low::precache();
	character\british_mcgregor_africa_low::precache();
	level.scr_character["flag drone"][0]		= character\british_infantry_africa_low ::main;

	level.scr_character["drone"][0] 		= character\british_infantry_africa_low ::main;
	level.scr_character["drone"][1] 		= character\british_mcgregor_africa_low ::main;

	level.scr_character["droneallies"][0] 		= character\british_infantry_africa_low ::main;
	level.scr_character["droneallies"][1] 		= character\british_mcgregor_africa_low ::main;
	level.scr_character["droneaxis"][0] 		= character\german_afrikakorp ::main;

	level.scr_anim["drone"]["run"][0]		= (%precombatrun1);
//	level.scr_anim["drone"]["run"][1]		= (%precombatrun1);
//	level.scr_anim["drone"]["run"][2]		= (%precombatrun1);

//	level.scr_anim["drone"]["run"][2]		= (%pistol_crouchrun_loop_forward_3);
	//level.scr_anim["drone"]["run"][3]		= (%crouchrun_loop_forward_1);
	//level.scr_anim["drone"]["run"][4]		= (%crouchrun_loop_forward_2);
	//level.scr_anim["drone"]["run"][5]		= (%crouchrun_loop_forward_3);

	level.scr_anim["drone"]["walk"][0]		= (%precombatrun1);
	level.scr_anim["drone"]["walk"][1]		= (%precombatrun1);
	level.scr_anim["drone"]["walk"][2]		= (%precombatrun1);
	level.scr_anim["drone"]["walk"][3]		= (%precombatrun1);
	level.scr_anim["drone"]["walk"][4]		= (%precombatrun1);
	level.scr_anim["drone"]["walk"][5]		= (%precombatrun1);

	level.scr_anim["drone"]["death"][0]		= (%death_run_forward_crumple);
	level.scr_anim["drone"]["death"][1]		= (%crouchrun_death_drop);
	level.scr_anim["drone"]["death"][2]		= (%crouchrun_death_crumple);
	level.scr_anim["drone"]["death"][3]		= (%death_run_onfront);
	level.scr_anim["drone"]["death"][4]		= (%death_run_onleft);

	level.scr_anim["drone"]["explode death up"] = %death_explosion_up10;
	level.scr_anim["drone"]["explode death back"] = %death_explosion_back13;			// Flies back 13 feet.
	level.scr_anim["drone"]["explode death forward"] = %death_explosion_forward13;
	level.scr_anim["drone"]["explode death left"] = %death_explosion_left11;
	level.scr_anim["drone"]["explode death right"] = %death_explosion_right13;
}


















