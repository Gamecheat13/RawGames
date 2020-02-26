#include maps\_utility;
#include common_scripts\utility;
#include animscripts\shared;
#include animscripts\random_weapon;


//**************************************************************************
//**************************************************************************

main()
{
	// precache all the weapon variants
	precacheItem("ak47_sp");
	precacheItem("ak47_dualclip_sp");
	precacheItem("ak47_acog_sp");
	precacheItem("ak47_elbit_sp");
	precacheItem("ak47_extclip_sp");
	precacheItem("ak47_reflex_sp");
	precacheItem("ak47_ft_sp");
	precacheItem("ak47_gl_sp");
	precacheItem("ak47_ir_sp");
	precacheItem("ak47_mk_sp");

	precacheItem("kiparis_acog_sp");
	precacheItem("kiparis_elbit_sp");
	precacheItem("kiparis_extclip_sp");
	precacheItem("kiparis_reflex_sp");

	precacheItem("rpk_acog_sp");
	precacheItem("rpk_dualclip_sp");
	precacheItem("rpk_elbit_sp");
	precacheItem("rpk_extclip_sp");
	precacheItem("rpk_ir_sp");
	precacheItem("rpk_reflex_sp");

	precacheItem("famas_sp");
	precacheItem("famas_cuba_extclip_gl_sp");
	precacheItem("famas_cuba_extclip_mk_sp");

	// flame death
	level._effect["character_fire_death_torso"] = LoadFX("env/fire/fx_fire_player_torso");

	level.rw_attachments_allowed = true;

	maps\_load::main();

	level.enable_player_vulnerability = true;

	//maps\feature_utility::add_ai_animtype( "default", character\c_rus_military1::main, character\c_rus_military1::precache );
	//maps\feature_utility::add_ai_animtype( "spetsnaz", character\c_rus_spetznaz_1::main, character\c_rus_spetznaz_1::precache );

	maps\feature_utility::feature_start();
			
	SetupChallenge();
	maps\_challenge::startchallenge("Challenge_Bloodbath");

	// turn on flanking
	SetSavedDvar("ai_coverScore_flanking", 13);

	// turn on headshot slowmo
	// SetDvar( "kill_slowmo_time", 0.15 );
	
	// override the dropped weapon chances
	// nevermind, the alt weapon don't work well with AI right now
//	build_weight_arrays_by_ai_class( "VC", true, 40, 25, 25, 10 );
//	build_weight_arrays_by_ai_class( "Spetsnaz", true, 40, 25, 25, 10 );
//	build_weight_arrays_by_ai_class( "RU", true, 40, 25, 25, 10 );
} 

//**************************************************************************
//**************************************************************************

SetupChallenge()
{
	//How many AI per round
	//*************************************
	//*************************************
	level.challenge_Difficulty[1] = 0;	
	//-------------------------------------
	level.challenge_AiToSpawn[1]  = 4;
	level.challenge_AiToSpawn[2]  = 8;
	//*************************************
	//*************************************
	level.challenge_Difficulty[3] = 1;
	//-------------------------------------
	level.challenge_AiToSpawn[3]  = 4;
	level.challenge_AiToSpawn[4]  = 8;
	level.challenge_AiToSpawn[5]  = 12;
	//*************************************
	//*************************************
	level.challenge_Difficulty[6] = 2;
	//-------------------------------------
	level.challenge_AiToSpawn[6]  = 4;
	level.challenge_AiToSpawn[7]  = 6;
	level.challenge_AiToSpawn[8]  = 8;
	level.challenge_AiToSpawn[9]  = 10;
	level.challenge_AiToSpawn[10] = 12;
	//*************************************
	//*************************************
	level.challenge_Difficulty[11]= 3;
	//-------------------------------------
	level.challenge_AiToSpawn[11] = 4;
	level.challenge_AiToSpawn[12] = 6;
	level.challenge_AiToSpawn[13] = 8;
	level.challenge_AiToSpawn[14] = 10;
	level.challenge_AiToSpawn[15] = 12;
	level.challenge_AiToSpawn[16] = 14;
	level.challenge_AiToSpawn[17] = 16;
	level.challenge_AiToSpawn[18] = 18;
	level.challenge_AiToSpawn[19] = 20;
	level.challenge_AiToSpawn[20] = 22;
	//*************************************
	//*************************************
}

//**************************************************************************
//**************************************************************************
