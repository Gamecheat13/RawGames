#include maps\_anim;
#using_animtree("generic_human");
main()
{
	dialog();

	level.scr_anim["runupguy"]["grenadetank"]		= (%tank_attack_guy2_grenadeandjump);
	level.scr_anim["runupguy"]["grenadetank_run"]		= (%tank_attack_guy2_hatchopen_end);

	level.scr_anim["generic"]["nade_throw"]	 		= (%stand_grenade_throw);

	addNotetrack_customFunction("runupguy", "custom = open_hatch", ::tossGrenade, "grenadetank_run");
	addNotetrack_sound("runupguy", "custom = open_hatch", "grenadetank_run", "tank_hatch");

}

tossGrenade(guy)
{
	wait .25; 
	guy playsound("weap_fraggrenade_pin");
	wait 1.2; 
	guy playsound("weap_fraggrenade_fire");
}

dialog()
{
	level.scrsound["randall"]["88takeitout"]		= "rhinecrossing_rnd_88takeitout";
	level.scrsound["randall"]["capture88"]			= "rhinecrossing_rnd_movein";
	level.scrsound["randall"]["useflaks"]			= "rhinecrossing_rnd_mccloskeysright"; //
	level.scrsound["randall"]["goodjob"]			= "rhinecrossing_rnd_thatslastone"; //
	level.scrsound["randall"]["assemble"]			= "rhinecrossing_rnd_assemblerally"; //
	level.scrsound["randall"]["sir"]			= "rhinecrossing_rnd_sir"; //
	level.scrsound["randall"]["soundsjustfine"]		= "rhinecrossing_rnd_soundsfine"; //
	level.scrsound["randall"]["wedidit"]			= "rhinecrossing_rnd_wedidit"; //

	level.scrsound["randall"]["rhine_rnd_suppress"]		= "rhine_rnd_suppress";
	level.scr_text["randall"]["rhine_rnd_suppress"]		= "Corporal Taylorrrr!!!! Suppress the German defenses with the .30 cal!";
	level.scrsound["randall"]["rhine_rnd_doingood"]		= "rhine_rnd_doingood";
	level.scr_text["randall"]["rhine_rnd_doingood"]		= "You're doin' good Corporal! Keep firing!!";
	level.scrsound["randall"]["rhine_rnd_mined"]		= "rhine_rnd_mined";
	level.scr_text["randall"]["rhine_rnd_mined"]		= "The Krauts have mined the riverbank! We can't go any further!";
	level.scrsound["randall"]["rhine_rnd_amtrac"]		= "rhine_rnd_amtrac";
	level.scr_text["randall"]["rhine_rnd_amtrac"]		= "Everyone out of the Amtrac! We're sitting ducks in here!";
	level.scrsound["randall"]["rhine_rnd_getout"]		= "rhine_rnd_getout";
	level.scr_text["randall"]["rhine_rnd_getout"]		= "Corporal Taylor, get out of that vehicle or you're a dead man!!!";
	level.scrsound["randall"]["rhine_rnd_hardway"]		= "rhine_rnd_hardway";
	level.scr_text["randall"]["rhine_rnd_hardway"]		= "O-kaaay looks like the Krauts wanna do this the hard way! Rangers, let's get some smoke out there! We gotta get up to that town and clear out that German artillery! Let's capture this side of the river! Move, move!";
	level.scrsound["randall"]["rhine_rnd_ontheline"]	= "rhine_rnd_ontheline";
	level.scr_text["randall"]["rhine_rnd_ontheline"]	= "Smoke grenaaaades - on. the. line!!!!";
	level.scrsound["randall"]["rhine_rnd_throwsmoke"]	= "rhine_rnd_throwsmoke";
	level.scr_text["randall"]["rhine_rnd_throwsmoke"]	= "Come on, throw your smoke grenades, put up a screen!!";

	level.scrsound["randall"]["rhine_rnd_fallbackcover"]	= "rhine_rnd_fallbackcover";
	level.scr_text["randall"]["rhine_rnd_fallbackcover"]	= "Fall back and take cover!!!";
	level.scrsound["randall"]["rhine_rnd_immobilize"]	= "rhine_rnd_immobilize";
	level.scr_text["randall"]["rhine_rnd_immobilize"]	= "Taylor! Get close and immobilize those tanks! Use your explosives on their tracks!!";
	level.scrsound["randall"]["rhine_rnd_tnt"]		= "rhine_rnd_tnt";
	level.scr_text["randall"]["rhine_rnd_tnt"]		= "Corporal Taylor!! Try to approach the tanks from the side! Use your TNT!!!";
	level.scrsound["randall"]["rhine_rnd_guarddown"]	= "rhine_rnd_guarddown";
	level.scr_text["randall"]["rhine_rnd_guarddown"]	= "There's still Krauts all over the place!!! Watch your back!! Don't let your guard down!! ";
	level.scrsound["randall"]["rhine_rnd_fellas"]		= "rhine_rnd_fellas";
	level.scr_text["randall"]["rhine_rnd_fellas"]		= "Looks like this town's ours fellas!";

	level.scrsound["mccloskey"]["flankem"]			= "rhinecrossing_mcc_gottaflankem";
	level.scrsound["mccloskey"]["bugginout"]		= "rhinecrossing_mcc_bugginout";

	level.scrsound["mccloskey"]["US_0_threat_vehicle_tiger"]	= "US_0_threat_vehicle_tiger";
	level.scr_text["mccloskey"]["US_0_threat_vehicle_tiger"]	= "Tiger tank!!!!!!";

	level.scrsound["coffey"]["moveout"]				= "duhoc_assault_cof_moveoutboat";
	level.scrsound["coffey"]["capture88s"]				= "rhinecrossing_cof_imhit";

// new stuff
	level.scrsound["ranger"]["rhine_gr9_niceplace"]			= "rhine_gr9_niceplace";

// end animation

	level.scr_anim["blake"]["final_scene_idle"][0]			= (%standunarmed_idle_loop);
	level.scr_anim["aide"]["final_scene_idle"][0]			= (%patrolstand_look);
	level.scr_anim["randall"]["final_scene_idle"][0]		= (%patrolstand_idle);

	level.scr_anim["aide"]["final_scene"]				= (%rhine_graveyard_promotion_aide);
	level.scr_anim["blake"]["final_scene"]				= (%rhine_graveyard_promotion_blake);
	level.scr_anim["randall"]["final_scene"]			= (%rhine_graveyard_promotion_randall);

//	addNotetrack_dialogue(animname, notetrack, anime, soundalias)
	addNotetrack_dialogue("blake", "dialog_08a", "final_scene", "rhine_blake_congrats1");
	addNotetrack_dialogue("blake", "dialog_08b", "final_scene", "rhine_blake_congrats2");
	addNotetrack_dialogue("blake", "dialog_08c", "final_scene", "rhine_blake_onemorething");
	addNotetrack_dialogue("blake", "dialog_09", "final_scene", "rhine_blake_officergentleman");
	addNotetrack_dialogue("randall", "dialog_10", "final_scene", "rhine_rnd_honoredsir");
	addNotetrack_dialogue("blake", "dialog_11", "final_scene", "rhine_blake_seetoyourmen");
	



	level.scrsound["blake"]["rhine_blake_congrats1"]	= "rhine_blake_congrats1";
	level.scrsound["blake"]["rhine_blake_congrats2"]	= "rhine_blake_congrats2";
	level.scrsound["blake"]["rhine_blake_onemorething"]	= "rhine_blake_onemorething";
	level.scrsound["blake"]["rhine_blake_officergentleman"]	= "rhine_blake_officergentleman";
	level.scrsound["randall"]["rhine_rnd_honoredsir"]	= "rhine_rnd_honoredsir";
	level.scrsound["blake"]["rhine_blake_seetoyourmen"]	= "rhine_blake_seetoyourmen";
}