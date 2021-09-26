#include maps\_anim;
#using_animtree ("generic_human");

main()
{	
	flakPanzer(); 
	Plane_Anims();	
	sound(); 
	level.scr_anim["gunner"]["fire_a"] = %flakpanzer_gunner_fire_a;
	level.scr_anim["gunner"]["fire_b"][0] = %flakpanzer_gunner_fire_b;
	level.scr_anim["gunner"]["dismount"] = %flakpanzer_gunner_dismount;
	level.scr_anim["gunner"]["deathslouch"] = %flakpanzer_gunner_deathslouch;
	level.scr_anim["gunner"]["deathfall"] = %flakpanzer_gunner_deathfall;
	level.scr_anim["gunner"]["deathfallidle"][0] = %flakpanzer_gunner_deathfallidle;


	level.scr_anim["leftloader"]["fire_a"] = %flakpanzer_leftloader_fire_a;
	level.scr_anim["leftloader"]["fire_b"][0] = %flakpanzer_leftloader_fire_b;
	level.scr_anim["leftloader"]["dismount"] = %flakpanzer_leftloader_dismount;
	level.scr_anim["leftloader"]["deathfallidle"][0] = %flakpanzer_gunner_deathfallidle;
	level.scr_anim["leftloader"]["deathfall"] = %flakpanzer_leftloader_death;
	

	level.scr_anim["rightloader"]["fire_a"] = %flakpanzer_rightloader_fire_a;
	level.scr_anim["rightloader"]["fire_b"][0] = %flakpanzer_rightloader_fire_b;
	level.scr_anim["rightloader"]["dismount"] = %flakpanzer_rightloader_dismount;
	level.scr_anim["rightloader"]["deathfallidle"][0] = %flakpanzer_gunner_deathfallidle;
	level.scr_anim["rightloader"]["deathfall"] = %flakpanzer_rightloader_death;

	level.scr_anim["gateopener"]["gateopen"] = %matmata_shakinggate_grabgate;
	level.scr_anim["gateopener"]["shakegate"] = %matmata_shakinggate_idle;
	level.scr_anim["gateopener"]["shakegaterest"] = %matmata_shakinggate_rest;
	level.scr_anim["gateopener"]["blownup"] = %death_explosion_back13; 

	level.scr_anim["driver"]["badfeeling"] = %matmata_driver_badfeeling;
	addNotetrack_dialogue("driver", "dialog", "badfeeling", "matmata_bs2_badfeeling");

	level.scr_anim["driver"]["idle"][0] = %carchase_driver_drive;
	
	level.scr_anim["gateopener"]["idle"][0] = %matmata_jeep_bs4_idle;
	level.scr_anim["gateopener"]["dialog"] = %matmata_jeep_bs4_dialog;
	addNotetrack_dialogue("gateopener", "dialog", "dialog", "matmata_bs4_eyesonroad");
	
//	level.scr_anim["gateopener"]["idle"][0] = %matmata_jeep_bs4_idle;
//	level.scr_anim["gateopener"]["idle"][0] = %matmata_jeep_bs4_idle;
	level.scr_anim["gateopener"]["crash"] =	%matmata_jeep_bs4_crash;
	level.scr_anim["gateopener"]["jumpout"] = %matmata_jeep_bs4_jumpout;
	level.scr_anim["macgregor"]["jumpout"] = %carchase_back_norm_getout;
	level.scr_anim["macgregor"]["crash"] = %matmata_jeep_mcgregor_crash;
	
	level.scr_anim["macgregor"]["idle"][0] = %matmata_jeep_mcgregor_idle;
	//	addNotetrack_dialogue(animname, notetrack, anime, soundalias)
	
	level.scr_anim["macgregor"]["radiotalk"]				= %duhoc_radioman_talk;
	
	//this is the main idle
	level.scr_anim["macgregor"]["radioidle"][0]			= %duhoc_radioman_listen;
//	level.scr_anim["macgregor"]["radioidle"][1]			= %duhoc_radioman_listen;
//	level.scr_anim["macgregor"]["radioidle"][2]			= %duhoc_radioman_listen;


}


sound()
{
	level.scrsound["stuka_gun_loop"][0] = "stuka_gun_loop";
	
	level.scrsound["price"]["matmata_pri_jerriesonnorthwall"] = "matmata_pri_jerriesonnorthwall";
	level.scrsound["price"]["matmata_pri_jerriesonsouthwall"] = "matmata_pri_jerriesonsouthwall";
	level.scrsound["price"]["matmata_pri_jerriestoeast"] = "matmata_pri_jerriestoeast";
	level.scrsound["price"]["matmata_pri_jerriesonwestwall"] = "matmata_pri_jerriesonwestwall";	
	level.scrsound["price"]["matmata_pri_20mm"] = "matmata_pri_20mm";
	level.scrsound["price"]["matmata_pri_ending"] = "matmata_pri_ending";

	level.scrsound["macgregor"]["matmata_mcg_jerryroof"] = "matmata_mcg_jerryroof";
	level.scrsound["macgregor"]["matmata_mcg_jerriesnorth"] = "matmata_mcg_jerriesnorth";
	level.scrsound["macgregor"]["matmata_mcg_tonorth"] = "matmata_mcg_tonorth";
	level.scrsound["macgregor"]["matmata_mcg_tosouth"] = "matmata_mcg_tosouth";
	level.scrsound["macgregor"]["matmata_mcg_jerriessouth"] = "matmata_mcg_jerriessouth";
	level.scrsound["macgregor"]["matmata_mcg_toeast"] = "matmata_mcg_toeast";
	level.scrsound["macgregor"]["matmata_mcg_towest"] = "matmata_mcg_towest";
	level.scrsound["macgregor"]["matmata_mcg_jerrieswest"] = "matmata_mcg_jerrieswest";
	level.scrsound["macgregor"]["matmata_mcg_thereyet"] = "matmata_mcg_thereyet";
	level.scrsound["macgregor"]["matmata_mcg_opengate"] = "matmata_mcg_opengate";
	level.scrsound["macgregor"]["matmata_mcg_gateisopen"] = "matmata_mcg_gateisopen";	
	level.scrsound["macgregor"]["matmata_mcg_radiosummon"] = "matmata_mcg_radiosummon";
	level.scrsound["macgregor"]["matmata_mcg_stayaway"] = "matmata_mcg_stayaway";
	level.scrsound["macgregor"]["matmata_mcg_planecheer"] = "matmata_mcg_planecheer";
	
	level.scrsound["soldier"]["matmata_bs2_badfeeling"] = "matmata_bs2_badfeeling";
	level.scrsound["soldier"]["matmata_bs3_stayaway"] = "matmata_bs3_stayaway";
	level.scrsound["soldier"]["matmata_planewarning"] = "matmata_planewarning";
	
	level.scrsound["gateopener"]["matmata_bs4_stopasking"] = "matmata_bs4_stopasking";
	level.scrsound["gateopener"]["matmata_bs4_eyesonroad"] = "matmata_bs4_eyesonroad";
	level.scrsound["soldier"]["matmata_bs4_pzambush"] = "matmata_bs4_pzambush";	
	level.scrsound["soldier"]["matmata_bs4_retfire"] = "matmata_bs4_retfire";
	level.scrsound["gateopener"]["matmata_bs4_onitmate"] = "matmata_bs4_onitmate";
	level.scrsound["soldier"]["matmata_bs4_arrived"] = "matmata_bs4_arrived";
	level.scrsound["soldier"]["matmata_bs4_stayaway"] = "matmata_bs4_stayaway";
	level.scrsound["soldier"]["matmata_bs4_smokegrenade"] = "matmata_bs4_smokegrenade";	

	level.scrsound["plane"]["matmata_stuka_strafe1"] = "matmata_stuka_strafe1";
	level.scrsound["plane"]["matmata_stuka_strafe2"] = "matmata_stuka_strafe2";
	level.scrsound["plane"]["matmata_stuka_strafe3"] = "matmata_stuka_strafe3";
	level.scrsound["plane"]["stuka_gun_loop"] = "stuka_gun_loop";
	level.scrsound["truck"]["jeep_crash_truck"] = "jeep_crash_truck";
	level.scrsound["gateopener"]["rattle"] = "matmata_gaterattle";




}

#using_animtree("flakpanzer"); 
flakPanzer()
{
	level.scr_animtree["panzerflak"] = #animtree; 
	level.scr_anim["panzerflak"]["fire_a"] = %flakpanzer_flak_fire_a;
	level.scr_anim["panzerflak"]["fire_b"] = %flakpanzer_flak_fire_b;
	level.scr_anim["panzerflak"]["basepose"] = %flakpanzer_flak_basepose;
	level.scr_anim["panzerflak"]["basefire"] = %flakpanzer_flak_basefire;
}

#using_animtree("eldaba_dogfight");
Plane_Anims()
{
	level.scr_animtree["dogfight"]		 				= #animtree;
	level.scr_anim["plane rig"]["axis"][0]				= (%eldaba_germanplane_loopA);
	level.scr_anim["plane rig"]["allies"][0]			= (%eldaba_britishplane_loopA);
	
	level.scr_anim["plane rig"]["axis"][1]				= (%eldaba_germanplane_loopB);
	level.scr_anim["plane rig"]["allies"][1]			= (%eldaba_britishplane_loopB);
	
  level.scr_anim["plane rig"]["axis"][2]				= (%eldaba_germanplane_loopC);
	level.scr_anim["plane rig"]["allies"][2]			= (%eldaba_britishplane_loopC);
	
	level.scr_anim["plane rig"]["axis"][3]				= (%eldaba_germanplane_loopD);
	level.scr_anim["plane rig"]["allies"][3]			= (%eldaba_britishplane_loopD);
	
}

#using_animtree ("vehicles");
jeep()
{
	//level.scr_anim["jeep"]["idle"][0] = %carchase_jeep_drive;
	level.scr_anim["jeep"]["badfeeling"] = %matmata_jeep_badfeeling;	
}




