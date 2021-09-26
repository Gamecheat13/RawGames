#using_animtree("generic_human");
main()
{
	load_tank_anims();
	load_tankcommander_anims();
	load_dummy_anims();
	dialog();
	level.scr_anim["plantbomb"]["flak"]										= (%brecourt_flak_foleyplantsbomb);	
	
	
}

dialog()
{
	level.scrsound["price"]["alamein_prc_cmonboys"]		= "alamein_prc_cmonboys";
	level.scrsound["price"]["alamein_prc_sixpertank"]		= "alamein_prc_sixpertank";
	level.scrsound["price"]["alamein_prc_staywithtanks"]		= "alamein_prc_staywithtanks";
	level.scrsound["price"]["alamein_prc_thruthistunnel"]		= "alamein_prc_thruthistunnel";
	level.scrsound["price"]["alamein_prc_holdforartillery"]		= "alamein_prc_holdforartillery";
	level.scrsound["price"]["alamein_prc_waitforguns"]		= "alamein_prc_waitforguns";
	level.scrsound["price"]["alamein_prc_usetankscover"]		= "alamein_prc_usetankscover";

	level.scrsound["price"]["alamein_prc_gettotrenchline"]		= "alamein_prc_gettotrenchline";
	level.scr_face["price"]["alamein_prc_gettotrenchline"]		= %elalamein_pri_sc04_03_t2_head;

	level.scrsound["price"]["alamein_prc_welldonelads"]		= "alamein_prc_welldonelads";
	level.scrsound["price"]["alamein_prc_splitintogroups"]		= "alamein_prc_splitintogroups";
	level.scrsound["price"]["alamein_prc_letsgo"]		= "alamein_prc_letsgo";
	level.scrsound["price"]["alamein_prc_aheadoftanks"]		= "alamein_prc_aheadoftanks";
	level.scrsound["price"]["alamein_prc_orderstolead"]		= "alamein_prc_orderstolead";
	level.scrsound["price"]["alamein_prc_plantsomeexplosives"]		= "alamein_prc_plantsomeexplosives";
	level.scrsound["price"]["alamein_prc_intothetunnel"]		= "alamein_prc_intothetunnel";
	level.scrsound["price"]["alamein_prc_holdup"]		= "alamein_prc_holdup";
	level.scrsound["price"]["alamein_prc_acrossthisvalley"]		= "alamein_prc_acrossthisvalley";
	level.scrsound["price"]["alamein_prc_clearoutbarracks"]		= "alamein_prc_clearoutbarracks";
	level.scrsound["price"]["alamein_prc_ontotherallypoint"]		= "alamein_prc_ontotherallypoint";
	level.scrsound["price"]["alamein_prc_ontothevillage"]		= "alamein_prc_ontothevillage";
	level.scrsound["price"]["alamein_prc_getintobunker"]		= "alamein_prc_getintobunker";
	level.scrsound["price"]["alamein_prc_silencegun"]		= "alamein_prc_silencegun";
	level.scrsound["price"]["alamein_prc_takeoutantitank"]		= "alamein_prc_takeoutantitank";
	level.scrsound["price"]["alamein_prc_silenceantitankgun"]		= "alamein_prc_silenceantitankgun";
	level.scrsound["price"]["alamein_prc_eliminateposition"]		= "alamein_prc_eliminateposition";
	level.scrsound["price"]["alamein_prc_machinegun"]		= "alamein_prc_machinegun";
	level.scrsound["price"]["alamein_prc_grenademg"]		= "alamein_prc_grenademg";
	level.scrsound["price"]["alamein_prc_pineapple"]		= "alamein_prc_pineapple";
	level.scrsound["price"]["alamein_prc_mortars"]		= "alamein_prc_mortars";
	level.scrsound["price"]["alamein_prc_move"]		= "alamein_prc_move";
	level.scrsound["price"]["alamein_prc_stopyouredead"]		= "alamein_prc_stopyouredead";
	level.scrsound["price"]["alamein_prc_nostopping"]		= "alamein_prc_nostopping";
	level.scrsound["price"]["alamein_prc_minefields"]		= "alamein_prc_minefields";
	level.scrsound["price"]["alamein_prc_minesupahead"]		= "alamein_prc_minesupahead";
	level.scrsound["price"]["alamein_prc_lookforsigns"]		= "alamein_prc_lookforsigns";
	level.scrsound["price"]["alamein_prc_watchformines"]		= "alamein_prc_watchformines";
	level.scrsound["price"]["alamein_prc_carefulminefields"]		= "alamein_prc_carefulminefields";
	level.scrsound["price"]["alamein_prc_suppresslorry"]		= "alamein_prc_suppresslorry";
	level.scrsound["price"]["alamein_prc_incomingjerries"]		= "alamein_prc_incomingjerries";
	level.scrsound["price"]["alamein_prc_destroylorry"]		= "alamein_prc_destroylorry";
	level.scrsound["price"]["alamein_prc_fireonvehicle"]		= "alamein_prc_fireonvehicle";
	level.scrsound["price"]["alamein_prc_herereplacements"]		= "alamein_prc_herereplacements";
	level.scrsound["price"]["alamein_prc_sentyouguys"]		= "alamein_prc_sentyouguys";
	level.scrsound["price"]["alamein_prc_wellcomeon"]		= "alamein_prc_wellcomeon";
	level.scrsound["price"]["alamein_prc_rallypoint"]		= "alamein_prc_rallypoint";
	level.scrsound["price"]["alamein_prc_clearbuildings"]		= "alamein_prc_clearbuildings";
	level.scrsound["price"]["alamein_prc_securebuildings"]		= "alamein_prc_securebuildings";
	level.scrsound["price"]["alamein_prc_enemypanzers"]		= "alamein_prc_enemypanzers";
	level.scrsound["price"]["alamein_prc_grenadewindow"]		= "alamein_prc_grenadewindow";
	level.scrsound["price"]["alamein_prc_clearhouse"]		= "alamein_prc_clearhouse";
	level.scrsound["price"]["alamein_prc_panzertank"]		= "alamein_prc_panzertank";
	level.scrsound["price"]["alamein_prc_useantitank"]		= "alamein_prc_useantitank";

	level.scrsound["price"]["alamein_prc_wirelessradio"]		= "alamein_prc_wirelessradio";
	level.scr_face["price"]["alamein_prc_wirelessradio"]		= %elalamein_pri_sc17_01_t2_head;

	level.scrsound["price"]["alamein_prc_welldoneboys"]		= "alamein_prc_welldoneboys";
	level.scr_anim["price"]["alamein_prc_welldoneboys"]		= %elalamein_pri_sc17_02_t1_head;


	level.scrsound["soldier1"]["alamein_bs1_machinegunnest"]		= "alamein_bs1_machinegunnest";
	level.scrsound["soldier1"]["alamein_bs1_battalionhelp"]		= "alamein_bs1_battalionhelp";
	level.scrsound["soldier1"]["alamein_bs1_houseisclear"]		= "alamein_bs1_houseisclear";
	level.scrsound["soldier1"]["alamein_bs3_keepmoving"]		= "alamein_bs3_keepmoving";



	level.scrsound["soldier2"]["alamein_bs2_staybehindtanks"]		= "alamein_bs2_staybehindtanks";
	level.scrsound["soldier2"]["alamein_bs2_knockoutmotars"]		= "alamein_bs2_knockoutmotars";
	level.scrsound["soldier2"]["alamein_bs2_jerrywindow"]		= "alamein_bs2_jerrywindow";
	level.scrsound["soldier2"]["alamein_bs2_clear"]		= "alamein_bs2_clear";
	
	level.scrsound["soldier3"]["alamein_bs3_mgonridge"]		= "alamein_bs3_mgonridge";
	level.scrsound["soldier3"]["alamein_bs3_panzertank"]		= "alamein_bs3_panzertank";
	level.scrsound["soldier3"]["alamein_bs3_replacements"]		= "alamein_bs3_replacements";
	level.scrsound["soldier3"]["alamein_bs3_clearhere"]		= "alamein_bs3_clearhere";
	
	level.scrsound["radioguy"]["alamein_hqr_bloodyfinework"]		= "alamein_hqr_bloodyfinework";
}

#using_animtree("generic_human");
load_tankcommander_anims()
{
}

#using_animtree("panzerIV");
load_tank_anims()
{
}

#using_animtree("animation_rig_largegroup20");

/*
british_infantry_africa.gsc
british_infantry_normandy.gscbritish_mcgregor_africa.gsc
british_mcgregor_africa.gsc
*/
load_dummy_anims()
{
//	level.large_group["test"] = %elalamein_drones_first_valley;
	precachemodel("xmodel/elalamein_drones_joints");

	level.large_group["elalamein_drones_1stvalley_grp01"] = %elalamein_drones_1stvalley_grp01;
	level.large_group["elalamein_drones_1stvalley_grp02"] = %elalamein_drones_1stvalley_grp02;
	level.large_group["elalamein_drones_1stvalley_grp03"] = %elalamein_drones_1stvalley_grp03;
	level.large_group["elalamein_drones_1stvalley_grp04"] = %elalamein_drones_1stvalley_grp04;
	level.large_group["elalamein_drones_1stvalley_grp05"] = %elalamein_drones_1stvalley_grp05;
	level.large_group["elalamein_drones_1stvalley_grp06"] = %elalamein_drones_1stvalley_grp06;
	level.large_group["elalamein_drones_1stvalley_grp07"] = %elalamein_drones_1stvalley_grp07;
	level.large_group["elalamein_drones_1stvalley_grp08"] = %elalamein_drones_1stvalley_grp08;
	level.large_group["elalamein_drones_1stvalley_grp09"] = %elalamein_drones_1stvalley_grp09;
	level.large_group["elalamein_drones_1stvalley_grp10"] = %elalamein_drones_1stvalley_grp10;
	                 
	level.large_group_size["elalamein_drones_1stvalley_grp01"] = 8;
	level.large_group_size["elalamein_drones_1stvalley_grp02"] = 8;
	level.large_group_size["elalamein_drones_1stvalley_grp03"] = 8;
	level.large_group_size["elalamein_drones_1stvalley_grp04"] = 8;
	level.large_group_size["elalamein_drones_1stvalley_grp05"] = 8;
	level.large_group_size["elalamein_drones_1stvalley_grp06"] = 8;
	level.large_group_size["elalamein_drones_1stvalley_grp07"] = 8;
	level.large_group_size["elalamein_drones_1stvalley_grp08"] = 8;
	level.large_group_size["elalamein_drones_1stvalley_grp09"] = 8;
	level.large_group_size["elalamein_drones_1stvalley_grp10"] = 8;

	level.large_group_delay["elalamein_drones_1stvalley_grp01"] = 0;
	level.large_group_delay["elalamein_drones_1stvalley_grp02"] = 0;
	level.large_group_delay["elalamein_drones_1stvalley_grp03"] = 0;
	level.large_group_delay["elalamein_drones_1stvalley_grp04"] = 0;
	level.large_group_delay["elalamein_drones_1stvalley_grp05"] = 0;
	level.large_group_delay["elalamein_drones_1stvalley_grp06"] = 0;
	level.large_group_delay["elalamein_drones_1stvalley_grp07"] = 0;
	level.large_group_delay["elalamein_drones_1stvalley_grp08"] = 0;
	level.large_group_delay["elalamein_drones_1stvalley_grp09"] = 0;
	level.large_group_delay["elalamein_drones_1stvalley_grp10"] = 0;

	level.large_group_extramodel["elalamein_drones_1stvalley_grp01"] = "xmodel/vehicle_crusader2";
	level.large_group_extramodel["elalamein_drones_1stvalley_grp02"] = "xmodel/vehicle_crusader2";
	level.large_group_extramodel["elalamein_drones_1stvalley_grp03"] = "xmodel/vehicle_crusader2";
	level.large_group_extramodel["elalamein_drones_1stvalley_grp04"] = "xmodel/vehicle_crusader2";
	level.large_group_extramodel["elalamein_drones_1stvalley_grp05"] = "xmodel/vehicle_crusader2";
	level.large_group_extramodel["elalamein_drones_1stvalley_grp06"] = "xmodel/vehicle_crusader2";
	level.large_group_extramodel["elalamein_drones_1stvalley_grp07"] = "xmodel/vehicle_crusader2";
	level.large_group_extramodel["elalamein_drones_1stvalley_grp08"] = "xmodel/vehicle_crusader2";
	level.large_group_extramodel["elalamein_drones_1stvalley_grp09"] = "xmodel/vehicle_crusader2";
	level.large_group_extramodel["elalamein_drones_1stvalley_grp10"] = "xmodel/vehicle_crusader2";

	level.large_group_extramodel_tag["elalamein_drones_1stvalley_grp01"] = "tag_tank";
	level.large_group_extramodel_tag["elalamein_drones_1stvalley_grp02"] = "tag_tank";
	level.large_group_extramodel_tag["elalamein_drones_1stvalley_grp03"] = "tag_tank";
	level.large_group_extramodel_tag["elalamein_drones_1stvalley_grp04"] = "tag_tank";
	level.large_group_extramodel_tag["elalamein_drones_1stvalley_grp05"] = "tag_tank";
	level.large_group_extramodel_tag["elalamein_drones_1stvalley_grp06"] = "tag_tank";
	level.large_group_extramodel_tag["elalamein_drones_1stvalley_grp07"] = "tag_tank";
	level.large_group_extramodel_tag["elalamein_drones_1stvalley_grp08"] = "tag_tank";
	level.large_group_extramodel_tag["elalamein_drones_1stvalley_grp09"] = "tag_tank";
	level.large_group_extramodel_tag["elalamein_drones_1stvalley_grp10"] = "tag_tank";

	level.large_group_extramodel_thread["elalamein_drones_1stvalley_grp01"] = maps\elalamein ::dummytanks;
	level.large_group_extramodel_thread["elalamein_drones_1stvalley_grp02"] = maps\elalamein ::dummytanks;
	level.large_group_extramodel_thread["elalamein_drones_1stvalley_grp03"] = maps\elalamein ::dummytanks;
	level.large_group_extramodel_thread["elalamein_drones_1stvalley_grp04"] = maps\elalamein ::dummytanks;
	level.large_group_extramodel_thread["elalamein_drones_1stvalley_grp05"] = maps\elalamein ::dummytanks;
	level.large_group_extramodel_thread["elalamein_drones_1stvalley_grp06"] = maps\elalamein ::dummytanks;
	level.large_group_extramodel_thread["elalamein_drones_1stvalley_grp07"] = maps\elalamein ::dummytanks;
	level.large_group_extramodel_thread["elalamein_drones_1stvalley_grp08"] = maps\elalamein ::dummytanks;
	level.large_group_extramodel_thread["elalamein_drones_1stvalley_grp09"] = maps\elalamein ::dummytanks;
	level.large_group_extramodel_thread["elalamein_drones_1stvalley_grp10"] = maps\elalamein ::dummytanks;

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
//	level.scr_anim["flag drone"]["run"][0] = (%stalingrad_flagrunner_idle);
//	level.scr_anim["flag drone"]["walk"][0] = (%stalingrad_flagrunner_idle);
//	level.scr_anim["flag drone"]["death"][0] = (%flagrun_drone_death);
	
	
	character\british_infantry_africa_low::precache();
	character\british_mcgregor_africa_low::precache();
	level.scr_character["flag drone"][0]		= character\british_infantry_africa_low ::main;

	level.scr_character["drone"][0] 		= character\british_infantry_africa_low ::main;
	level.scr_character["drone"][1] 		= character\british_mcgregor_africa_low ::main;
	level.scr_character["droneallies"][0] 		= character\british_infantry_africa_low ::main;
	level.scr_character["droneallies"][1] 		= character\british_mcgregor_africa_low ::main;
	
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

