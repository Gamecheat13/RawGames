#include maps\_anim;
#using_animtree("generic_human");
main()
{
	level.scr_anim["mcgregor"]["grenade_toss_guy"]				= (%grenade_toss_guy);

	precacheModel("xmodel/weapon_mk2fraggrenade");
	level.scr_notetrack["mcgregor"][0]["notetrack"]				= "grenade throw1";
	level.scr_notetrack["mcgregor"][0]["attach model"]			= "xmodel/weapon_mk2fraggrenade";
	level.scr_notetrack["mcgregor"][0]["selftag"]				= "TAG_WEAPON_LEFT";

	level.scr_notetrack["mcgregor"][1]["notetrack"]				= "grenade2 hide";
	level.scr_notetrack["mcgregor"][1]["detach model"]			= "xmodel/weapon_mk2fraggrenade";
	level.scr_notetrack["mcgregor"][1]["selftag"]				= "TAG_WEAPON_LEFT";

	level.scr_anim["price"]["chateau_kickdoor1"]				= (%chateau_kickdoor1);

/* Wounded guys */
	level.scr_anim["wounded"]["wounded_0"][0]				= (%wounded_chestguy_idle);
	level.scr_anim["wounded"]["wounded_0weight"][0]				= 3;
	level.scr_anim["wounded"]["wounded_0"][1]				= (%wounded_chestguy_twitch);
	level.scr_anim["wounded"]["wounded_0weight"][1]				= 1;
	level.scr_anim["wounded"]["wounded_0"][2]				= (%wounded_chestguy_twitch);
	level.scr_anim["wounded"]["wounded_0weight"][2]				= 1;
	level.scr_anim["wounded"]["wounded_0"][3]				= (%wounded_chestguy_twitch);
	level.scr_anim["wounded"]["wounded_0weight"][3]				= 1;

	level.scrsound["wounded"]["wounded_0"][1]				= "beltot_gi1_painedgroan1";
	level.scrsound["wounded"]["wounded_0"][2]				= "beltot_gi1_painedgroan2";
	level.scrsound["wounded"]["wounded_0"][3]				= "beltot_gi1_painedgroan3";

	level.scr_anim["wounded"]["wounded_1"][0]				= (%wounded_groinguy_idle);
	level.scr_anim["wounded"]["wounded_1weight"][0]				= 3;
	level.scr_anim["wounded"]["wounded_1"][1]				= (%wounded_groinguy_twitch);
	level.scr_anim["wounded"]["wounded_1weight"][1]				= 1;
	level.scr_anim["wounded"]["wounded_1"][2]				= (%wounded_groinguy_twitch);
	level.scr_anim["wounded"]["wounded_1weight"][2]				= 1;
	level.scr_anim["wounded"]["wounded_1"][3]				= (%wounded_groinguy_twitch);
	level.scr_anim["wounded"]["wounded_1weight"][3]				= 1;

	level.scrsound["wounded"]["wounded_1"][1]				= "beltot_gi2_painedgroan1";
	level.scrsound["wounded"]["wounded_1"][2]				= "beltot_gi2_painedgroan2";

	level.scr_anim["wounded"]["wounded_2"][0]				= (%wounded_neckguy_idle);
	level.scr_anim["wounded"]["wounded_2weight"][0]				= 3;
	level.scr_anim["wounded"]["wounded_2"][1]				= (%wounded_neckguy_twitch);
	level.scr_anim["wounded"]["wounded_2weight"][1]				= 1;
	level.scr_anim["wounded"]["wounded_2"][2]				= (%wounded_neckguy_twitch);
	level.scr_anim["wounded"]["wounded_2weight"][2]				= 1;
	level.scr_anim["wounded"]["wounded_2"][3]				= (%wounded_neckguy_twitch);
	level.scr_anim["wounded"]["wounded_2weight"][3]				= 1;

	level.scrsound["wounded"]["wounded_2"][1]				= "beltot_gi3_painedgroan1";
	level.scrsound["wounded"]["wounded_2"][2]				= "beltot_gi3_painedgroan2";
	level.scrsound["wounded"]["wounded_2"][3]				= "beltot_gi3_painedgroan3";

	level.scr_anim["wounded"]["wounded_3"][0]				= (%wounded_sideguy_idle);
	level.scr_anim["wounded"]["wounded_3weight"][0]				= 2;
	level.scr_anim["wounded"]["wounded_3"][1]				= (%wounded_sideguy_twitch);
	level.scr_anim["wounded"]["wounded_3weight"][1]				= 1;

	level.scrsound["wounded"]["wounded_3"][1]				= "beltot_gi1_painedgroan1";

	level.scr_anim["wounded"]["wounded_4"][0]				= (%brecourt_woundedman_idle);
	level.scr_anim["wounded"]["wounded_4weight"][0]				= 2;

	level.scr_anim["wounded"]["wounded_4"][1]				= (%brecourt_woundedman_idle);
	level.scr_anim["wounded"]["wounded_4weight"][1]				= 1;

	level.scrsound["wounded"]["wounded_4"][1]				= "beltot_gi2_painedgroan1";

	level.scr_anim["wounded"]["wounded_5"][0]				= (%woundedidle_unarmed);
	level.scr_anim["wounded"]["wounded_5weight"][0]				= 1;

/* Cap Price */
	level.scrsound["price"]["beltot_price_downthisroad"]			= "beltot_price_downthisroad";
//	level.scrsound["price"]["beltot_price_doourpart"]			= "beltot_price_doourpart";

	level.scr_anim["price"]["beltot_british_briefing_dialog"]		= (%beltot_british_briefing_dialog);
//	addNotetrack_dialogue(animname, notetrack, anime, soundalias)
	addNotetrack_dialogue("price", "dialog 02", "beltot_british_briefing_dialog", "beltot_price_doourpart");

	level.scrsound["price"]["beltot_price_mortarinsidebuilding"]		= "beltot_price_mortarinsidebuilding";
/*	level.scr_anim["price"]["beltot_price_mortarinsidebuilding"]		= (%beltot_hide_from_mortar_dialog);
	level.scr_notetrack["price"][1]["notetrack"]				= "dialog_price";
	level.scr_notetrack["price"][1]["dialogue"]				= "beltot_price_mortarinsidebuilding";
*/
	level.scr_anim["price"]["beltot_british_mg42_warning_idle"][0]		= (%beltot_british_mg42_warning_idle);

	level.scr_anim["price"]["beltot_price_mg42onsecondfloor"]		= (%beltot_british_mg42_warning_dialog);
	addNotetrack_dialogue("price", "price_05_dialog", "beltot_price_mg42onsecondfloor", "beltot_price_mg42onsecondfloor");

	level.scrsound["price"]["beltot_price_mg42onsecondfloor_noanim"]	= "beltot_price_mg42onsecondfloor";


	level.scrsound["price"]["beltot_price_macgregorandboys"]		= "beltot_price_macgregorandboys";
	level.scr_face["price"]["beltot_price_macgregorandboys"]		= %beltot_pri_sc05_01_t1_head;
	
	level.scrsound["price"]["beltot_price_machinegunsdown"]			= "beltot_price_machinegunsdown";
	level.scr_face["price"]["beltot_price_machinegunsdown"]			= %beltot_pri_sc05_02_t1_head;

	level.scrsound["price"]["beltot_price_takeoutmortars"]			= "beltot_price_takeoutmortars";
//	level.scr_face["price"]["beltot_price_takeoutmortars"]			= %;

	level.scrsound["price"]["beltot_price_davisclearsecond"]		= "beltot_price_davisclearsecond";
//	level.scr_face["price"]["beltot_price_davisclearsecond"]		= %;

	level.scr_anim["price"]["beltot_price_holdfirelads"]			= (%beltot_stopfiring_dialog);
	addNotetrack_dialogue("price", "dialogue", "beltot_price_holdfirelads", "beltot_price_holdfirelads");

	level.scr_anim["price"]["beltot_price_thatsanorder"]			= (%beltot_stopfiringorder_dialog);
	addNotetrack_dialogue("price", "dialogue", "beltot_price_thatsanorder", "beltot_price_thatsanorder");

	level.scr_anim["price"]["bring_truck"]					= (%beltot_bring_truck_dialog_price);
	addNotetrack_dialogue("price", "dialog_price_01", "bring_truck", "beltot_price_getoverhere");
	addNotetrack_dialogue("price", "dialog_price_02", "bring_truck", "beltot_price_gowithmac");

	level.scr_anim["price"]["alrightchaps"]					= (%beltot_british_load_wounded_dialog);
	level.scrsound["price"]["alrightchaps"]					= "beltot_price_alrightchaps";

 	level.scr_anim["price"]["almostenvyblokes"]				= (%beltot_finaldialogue);
	level.scrsound["price"]["almostenvyblokes"]				= "beltot_price_almostenvyblokes";

/* Pvt. McGregor */
	level.scr_anim["mcgregor"]["briefing_loop"][0]				= (%beltot_british_briefing_loop);

	level.scr_anim["mcgregor"]["bring_truck"]				= (%beltot_bring_truck_dialog_mcgregor);
	level.scr_notetrack["mcgregor"][2]["notetrack"]				= "dialog_mcgregor_01";
	level.scr_notetrack["mcgregor"][2]["dialogue"]				= "beltot_mcg_idosir";
	level.scr_notetrack["mcgregor"][3]["notetrack"]				= "dialog_mcgregor_02";
	level.scr_notetrack["mcgregor"][3]["dialogue"]				= "beltot_mcg_willdosir";
	
	level.scr_anim["mcgregor"]["drive_loop"][0]				= (%germantruck_driver_sitidle_loop);

	level.scr_anim["mcgregor"]["truckscene"]				= (%beltot_truckscene_checktruck_guy);
	addNotetrack_dialogue("mcgregor", "dialogue01", "truckscene", "beltot_mcg_looksingoodshape");
	addNotetrack_dialogue("mcgregor", "dialogue02", "truckscene", "beltot_mcg_jumpinback");

/*	level.scr_notetrack["mcgregor"][4]["notetrack"]				= "dialogue01";
	level.scr_notetrack["mcgregor"][4]["dialogue"]				= "beltot_mcg_looksingoodshape";
	level.scr_notetrack["mcgregor"][5]["notetrack"]				= "dialogue02";
	level.scr_notetrack["mcgregor"][5]["dialogue"]				= "beltot_mcg_jumpinback";
*/

	level.scrsound["mcgregor"]["beltot_mcg_almostgotbugger"]		= "beltot_mcg_almostgotbugger";
	level.scrsound["mcgregor"]["beltot_mcg_bloodyhell"]			= "beltot_mcg_bloodyhell";
	level.scrsound["mcgregor"]["beltot_mcg_davistakeout"]			= "beltot_mcg_davistakeout";
	level.scrsound["mcgregor"]["beltot_mcg_armorstoothick"]			= "beltot_mcg_armorstoothick";
	level.scrsound["mcgregor"]["beltot_mcg_cmonanotherone"]			= "beltot_mcg_cmonanotherone";
	level.scrsound["mcgregor"]["beltot_mcg_damnthislorry"]			= "beltot_mcg_damnthislorry";
	level.scrsound["mcgregor"]["beltot_mcg_notgonnafit"]			= "beltot_mcg_notgonnafit";
	level.scrsound["mcgregor"]["beltot_mcg_wemadeit"]			= "beltot_mcg_wemadeit";

	level.scrsound["mcgregor"]["beltot_mcg_davistakeout"]			= "beltot_mcg_davistakeout";
	level.scrsound["mcgregor"]["beltot_mcg_panzerschreck"]			= "beltot_mcg_panzerschreck";

	level.scrsound["mcgregor"]["beltot_mcg_follow"]				= "beltot_mcg_follow";
	level.scrsound["mcgregor"]["beltot_mcg_counter"]			= "beltot_mcg_counter";


/* British Soldier 1 */
	level.scr_anim["bs1"]["beltot_bs1_mortarcrew"]				= (%beltot_british_mortar_crew_dialog);
	level.scr_notetrack["bs1"][0]["notetrack"]				= "bs1_01_dialog";
	level.scr_notetrack["bs1"][0]["dialogue"]				= "beltot_bs1_mortarcrew";

	level.scrsound["bs1"]["beltot_bs2_launchingcounter"]			= "beltot_bs2_launchingcounter";
	level.scrsound["bs1"]["beltot_bs1_sayweslot"]				= "beltot_bs1_sayweslot";
	level.scr_face["bs1"]["beltot_bs1_sayweslot"]				= %beltot_bs1_sc10_03_t2_head;
	level.scrsound["bs1"]["beltot_bs1_whateveryousay"]			= "beltot_bs1_whateveryousay";
	level.scr_face["bs1"]["beltot_bs1_whateveryousay"]			= %beltot_bs1_sc10_05_t4_head;

/* British Soldier 3 */
	level.scrsound["bs3"]["beltot_bs3_acrosstheseruins"]			= %beltot_bs1_sc10_05_t4_head;

/* German Infantry 1 */
	level.scrsound["gi1"]["beltot_gi1_lookout"]				= "beltot_gi1_lookout";

	level.scrsound["gi1"]["beltot_gi1_painedgroan1"]			= "beltot_gi1_painedgroan1";
	level.scrsound["gi1"]["beltot_gi1_painedgroan2"]			= "beltot_gi1_painedgroan2";
	level.scrsound["gi1"]["beltot_gi1_painedgroan3"]			= "beltot_gi1_painedgroan3";

/* German Infantry 2 */
	// surrender animation
	level.scr_anim["gi2"]["surrender"]					= (%beltot_german_surrendering_dialogue);
	level.scr_notetrack["gi2"][0]["notetrack"]				= "dialogue";
	level.scr_notetrack["gi2"][0]["dialogue"]				= "beltot_gi2_dontshootplease";

	level.scr_anim["gi2"]["surrender_loop"][0]				= (%beltot_german_surrendering_loop);

	level.scrsound["gi2"]["beltot_gi2_painedgroan1"]			= "beltot_gi2_painedgroan1";
	level.scrsound["gi2"]["beltot_gi2_painedgroan2"]			= "beltot_gi2_painedgroan2";

/* German Infantry 3 */
	level.scrsound["gi3"]["beltot_gi3_painedgroan1"]			= "beltot_gi3_painedgroan1";
	level.scrsound["gi3"]["beltot_gi3_painedgroan2"]			= "beltot_gi3_painedgroan2";
	level.scrsound["gi3"]["beltot_gi3_painedgroan3"]			= "beltot_gi3_painedgroan3";


/* Mortar crew */
	// loadguy animations 
	level.scr_anim["loadguy"]["waitidle"]					= (%mortar_loadguy_waitidle);
	level.scr_anim["loadguy"]["waittwitch"]					= (%mortar_loadguy_waittwitch);
	level.scr_anim["loadguy"]["fire"]					= (%mortar_loadguy_fire);
	level.scr_anim["loadguy"]["pickup"]					= (%mortar_loadguy_pickup);
	// aimguy animations 
	level.scr_anim["aimguy"]["waitidle"]					= (%mortar_aimguy_waitidle);
	level.scr_anim["aimguy"]["waittwitch"]					= (%mortar_aimguy_waittwitch);
	level.scr_anim["aimguy"]["fire"]					= (%mortar_aimguy_fire);
	level.scr_anim["aimguy"]["pickup"]					= (%mortar_aimguy_pickup);

	level.scr_notetrack["loadguy"][0]["notetrack"]				= "attach shell = right";
	level.scr_notetrack["loadguy"][0]["attach model"]			= "xmodel/prop_mortar_ammunition";
	level.scr_notetrack["loadguy"][0]["selftag"]				= "TAG_WEAPON_RIGHT";

	level.scr_notetrack["loadguy"][1]["notetrack"]				= "detach shell = right";
	level.scr_notetrack["loadguy"][1]["detach model"]			= "xmodel/prop_mortar_ammunition";
	level.scr_notetrack["loadguy"][1]["selftag"]				= "TAG_WEAPON_RIGHT";

	level.scr_notetrack["loadguy"][2]["notetrack"]				= "fire";
	level.scr_notetrack["loadguy"][2]["sound"] 				= "weap_mortar_fire";


}
