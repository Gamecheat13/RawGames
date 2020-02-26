#include maps\_utility;
#include animscripts\utility;
#include common_scripts\utility;
// this script handles all major global gameskill considerations
setSkill( reset, skill_override )
{
	if ( !isdefined( level.script ) )
	{
		level.script = tolower( GetDvar( "mapname" ) );
	}
	
	if ( !isdefined( reset ) || reset == false )
	{
		if ( isdefined( level.gameSkill ) )
		{
			return;
		}
	
		// TFLAME - 2/17/11 - useless func pointers for SP, but are set up in zombies.  If they are always set up in zombies we shouldnt need them here... check if we can do without after zombie integrate
		level.global_damage_func_ads = ::empty_kill_func;
		level.global_damage_func = ::empty_kill_func;
		level.global_kill_func = ::empty_kill_func;
	
			// first init stuff
		set_console_status();
		flag_init( "player_has_red_flashing_overlay" );
		flag_init( "player_is_invulnerable" );
		
		// CODER_MOD - Sumeet, track skill changes in game
		level thread update_skill_on_change();

		/#
		thread playerHealthDebug();
		#/
	}

	if(!IsDefined(level.invulTime_onShield_multiplier))
	{
		level.invulTime_onShield_multiplier = 1;						 // TFLAME - 2/17/11 - helps calculate how long you are invulnerable after getting to low health
	}
	
	if(!IsDefined(level.player_attacker_accuracy_multiplier))
	{
		level.player_attacker_accuracy_multiplier = 1;			// TFLAME - 2/17/11 - helps calculate how much to reduce the player attacker's accuracy when player is low health?
	}
	
	level.gameSkill = GetLocalProfileInt( "g_gameskill" );
	if ( isdefined( skill_override ) )
	{
		level.gameSkill = skill_override;
	}
	
	SetDvar( "saved_gameskill", level.gameSkill );

	switch (level.gameSkill)
	{
		case 0:
			SetDvar ("currentDifficulty", "easy");
			level.currentDifficulty = "easy";
			break;
		case 1:
			SetDvar ("currentDifficulty", "normal");
			level.currentDifficulty = "normal";
			break;
		case 2:
			SetDvar ("currentDifficulty", "hardened");
			level.currentDifficulty = "hardened";
			break;
		case 3:
			SetDvar ("currentDifficulty", "veteran");
			level.currentDifficulty = "veteran";
			break;
	}
	
	anim.run_accuracy = 0.5;

	logString( "difficulty: " + level.gameSkill );
	
	level.auto_adjust_threatbias = true;
		
	// TFLAME - 2/17/11 - All of the following are magic numbers, we should describe what these values all do.  We should also ensure these are all actually being used

		// Base time in ms how long to wait before throwing a grenade - total time will be base time plus a random int of range time
	 // anim.playerGrenadeBaseTime
	level.difficultySettings[ "playerGrenadeBaseTime" ][ "easy" ]			= 40 * 1000;
	level.difficultySettings[ "playerGrenadeBaseTime" ][ "normal" ]		= 25 * 1000;
	level.difficultySettings[ "playerGrenadeBaseTime" ][ "hardened" ] = 10 * 1000;
	level.difficultySettings[ "playerGrenadeBaseTime" ][ "veteran" ] 	= 0;


		// Range time in ms how long to wait before throwing a grenade - total time will be base time plus a random int of range time
	 // anim.playerGrenadeRangeTime
	level.difficultySettings[ "playerGrenadeRangeTime" ][ "easy" ]		 = 20 * 1000;
	level.difficultySettings[ "playerGrenadeRangeTime" ][ "normal" ] 	 = 15 * 1000;
	level.difficultySettings[ "playerGrenadeRangeTime" ][ "hardened" ] = 5 * 1000;
	level.difficultySettings[ "playerGrenadeRangeTime" ][ "veteran" ]  = 1;


		// time between instances where 2 grenades land near player at once( hardcoded to never happen in easy )
	level.difficultySettings[ "playerDoubleGrenadeTime" ][ "easy" ]		  = 3600 * 1000;
	level.difficultySettings[ "playerDoubleGrenadeTime" ][ "normal" ]		= 120 * 1000;
	level.difficultySettings[ "playerDoubleGrenadeTime" ][ "hardened" ] = 15 * 1000;
	level.difficultySettings[ "playerDoubleGrenadeTime" ][ "veteran" ]  = 0;

		// determines whether 2 grenades can be thrown at the player at once
	level.difficultySettings[ "double_grenades_allowed" ][ "easy" ]	 	 	= false;
	level.difficultySettings[ "double_grenades_allowed" ][ "normal" ] 	= true;
	level.difficultySettings[ "double_grenades_allowed" ][ "hardened" ] = true;
	level.difficultySettings[ "double_grenades_allowed" ][ "veteran" ]  = true;

		/// TFLAME - 2/22/11 - sets invulnerability after getting hit in code, but code sets hardcoded values on game load 4000,1000,100,100.  TODO - Omar and James to look into code not stomping these values
		// This value is set as a dvar for code to access
	level.difficultySettings[ "player_deathInvulnerableTime" ][ "easy" ]		 = 4 * 1000;
	level.difficultySettings[ "player_deathInvulnerableTime" ][ "normal" ] 	 = 1.7 * 1000;
	level.difficultySettings[ "player_deathInvulnerableTime" ][ "hardened" ] = 0.6 * 1000;
	level.difficultySettings[ "player_deathInvulnerableTime" ][ "veteran" ]  = 0.1 * 1000;
	
			// modifies the threatbias of the player - The higher the value, the more AI will target the player over friendly AI
	level.difficultySettings[ "threatbias" ][ "easy" ] = 100;
	level.difficultySettings[ "threatbias" ][ "normal" ]	 = 150;
	level.difficultySettings[ "threatbias" ][ "hardened" ] = 200;
	level.difficultySettings[ "threatbias" ][ "veteran" ]  = 400;

			// time since getting hurt last that the player will start regenerating health.  Full regeneration is almost instant.
	level.difficultySettings[ "longRegenTime" ][ "easy" ]		  = 5 * 1000;
	level.difficultySettings[ "longRegenTime" ][ "normal" ] 	= 5 * 1000;
	level.difficultySettings[ "longRegenTime" ][ "hardened" ] = 5 * 1000;
	level.difficultySettings[ "longRegenTime" ][ "veteran" ] 	= 5 * 1000;

		// Fraction of max health we need to be at to show the low health overlay
		// level.healthOverlayCutoff
	level.difficultySettings[ "healthOverlayCutoff" ][ "easy" 	]	  = 0.01;
	level.difficultySettings[ "healthOverlayCutoff" ][ "normal" ]	  = 0.2;
	level.difficultySettings[ "healthOverlayCutoff" ][ "hardened" ] = 0.3;
	level.difficultySettings[ "healthOverlayCutoff" ][ "veteran" ]  = 0.5;


		// sets the last AI to attack the player self.attackeraccuracy to this.
		// anim.player_attacker_accuracy
	level.difficultySettings[ "base_enemy_accuracy" ][ "easy" ] 	  = 1;
	level.difficultySettings[ "base_enemy_accuracy" ][ "normal" ]	  = 1;
	level.difficultySettings[ "base_enemy_accuracy" ][ "hardened" ] = 1.3;
	level.difficultySettings[ "base_enemy_accuracy" ][ "veteran" ] 	= 1.3;
	
		// lower numbers = higher accuracy for AI at a distance only when targetting player.  Calculation in code is : evaluated_dist = ai_accuracyDistScale * current_dist
	level.difficultySettings[ "accuracyDistScale" ][ "easy" ]		  = 1.0;
	level.difficultySettings[ "accuracyDistScale" ][ "normal" ]   = 1.0;
	level.difficultySettings[ "accuracyDistScale" ][ "hardened" ] = 1.0;
	level.difficultySettings[ "accuracyDistScale" ][ "veteran" ]  = 0.5;

		//Sets dvar player_damageMultiplier to 100 over this value - not referenced in script.  Kind of an odd runaround of naming convention vs functionality TODO - Need to check code references for this
		// level.playerDifficultyHealth
	level.difficultySettings[ "playerDifficultyHealth" ][ "easy" ]		 = 475;
	level.difficultySettings[ "playerDifficultyHealth" ][ "normal" ] 	 = 310;
	level.difficultySettings[ "playerDifficultyHealth" ][ "hardened" ] = 165;
	level.difficultySettings[ "playerDifficultyHealth" ][ "veteran" ]  = 115;


	// anim.min_sniper_burst_delay_time
	level.difficultySettings[ "min_sniper_burst_delay_time" ][ "easy" ] = 3.0;
	level.difficultySettings[ "min_sniper_burst_delay_time" ][ "normal" ]  = 2.0;
	level.difficultySettings[ "min_sniper_burst_delay_time" ][ "hardened" ] = 1.5;
	level.difficultySettings[ "min_sniper_burst_delay_time" ][ "veteran" ]  = 1.1;


	// anim.max_sniper_burst_delay_time
	level.difficultySettings[ "max_sniper_burst_delay_time" ][ "easy" ] 	  = 4.0;
	level.difficultySettings[ "max_sniper_burst_delay_time" ][ "normal" ]   = 3.0;
	level.difficultySettings[ "max_sniper_burst_delay_time" ][ "hardened" ] = 2.0;
	level.difficultySettings[ "max_sniper_burst_delay_time" ][ "veteran" ]  = 1.5;


	level.difficultySettings[ "dog_health" ][ "easy" ]	   = 0.25;
	level.difficultySettings[ "dog_health" ][ "normal" ]   = 0.75;
	level.difficultySettings[ "dog_health" ][ "hardened" ] = 1.0;
	level.difficultySettings[ "dog_health" ][ "veteran" ]  = 1.0;

		// time in ms player has after button prompt is shown to snap the dogs neck
	level.difficultySettings[ "dog_presstime" ][ "easy" ]			= 415;
	level.difficultySettings[ "dog_presstime" ][ "normal" 	] = 375;
	level.difficultySettings[ "dog_presstime" ][ "hardened" ] = 250;
	level.difficultySettings[ "dog_presstime" ][ "veteran" ]	= 225;
	
	
	level.difficultySettings[ "dog_hits_before_kill" ][ "easy" ] = 2;
	level.difficultySettings[ "dog_hits_before_kill" ][ "normal" ] = 1;
	level.difficultySettings[ "dog_hits_before_kill" ][ "hardened" ] = 0;
	level.difficultySettings[ "dog_hits_before_kill" ][ "veteran" ] = 0;
	

	// TFLAME - 2/22/11 - In Hard/Vet, pain_protection makes some AI not respond to pain if multiple AI are shot by the player in a short interval
	// anim.pain_test
	level.difficultySettings[ "pain_test" ][ "easy" ] = ::always_pain;
	level.difficultySettings[ "pain_test" ][ "normal" ] = ::always_pain;
	level.difficultySettings[ "pain_test" ][ "hardened" ] = ::pain_protection;
	level.difficultySettings[ "pain_test" ][ "veteran" ] = ::pain_protection;
	anim.pain_test = level.difficultySettings[ "pain_test"  ][ level.currentDifficulty ];

	 // missTime is a number based on the distance from the AI to the player + some baseline
	 // it simulates bad aim as the AI starts shooting, and helps give the player a warning before they get hit.
	 // this is used for auto and semi auto.
	 // missTime = missTimeConstant + distance * missTimeDistanceFactor
	
	level.difficultySettings[ "missTimeConstant" ][ "easy" ]     = 1.0; // 0.2;// 0.3;
	level.difficultySettings[ "missTimeConstant" ][ "normal" ]   = 0.05;// 0.1;
	level.difficultySettings[ "missTimeConstant" ][ "hardened" ] = 0;// 0.04;
	level.difficultySettings[ "missTimeConstant" ][ "veteran" ]  = 0;// 0.03;

	
	level.difficultySettings[ "missTimeDistanceFactor" ][ "easy" ]     = 0.8  / 1000; // 0.4
	level.difficultySettings[ "missTimeDistanceFactor" ][ "normal" ]   = 0.1  / 1000;
	level.difficultySettings[ "missTimeDistanceFactor" ][ "hardened" ] = 0.05 / 1000;
	level.difficultySettings[ "missTimeDistanceFactor" ][ "veteran" ]  = 0;


	level.difficultySettings[ "flashbangedInvulFactor" ][ "easy" ]     = 0.25;
	level.difficultySettings[ "flashbangedInvulFactor" ][ "normal" ]   = 0;
	level.difficultySettings[ "flashbangedInvulFactor" ][ "hardened" ] = 0;
	level.difficultySettings[ "flashbangedInvulFactor" ][ "veteran" ]  = 0;

	// level.invulTime_preShield: time player is invulnerable when hit before their health is low enough for a red overlay( should be very short )
	level.difficultySettings[ "invulTime_preShield" ][ "easy" ]		  = 0.6;
	level.difficultySettings[ "invulTime_preShield" ][ "normal" ] 	= 0.35;
	level.difficultySettings[ "invulTime_preShield" ][ "hardened" ] = 0.1;
	level.difficultySettings[ "invulTime_preShield" ][ "veteran" ]  = 0.0;


	// level.invulTime_onShield: time player is invulnerable when hit the first time they get a red health overlay( should be reasonably long )
	level.difficultySettings[ "invulTime_onShield"  ][ "easy" ]		  = 0.8;
	level.difficultySettings[ "invulTime_onShield"  ][ "normal" ]	  = 0.5;
	level.difficultySettings[ "invulTime_onShield"  ][ "hardened" ] = 0.1;
	level.difficultySettings[ "invulTime_onShield"  ][ "veteran" ]  = 0.05;


	// level.invulTime_postShield: time player is invulnerable when hit after the red health overlay is already up( should be short )
	level.difficultySettings[ "invulTime_postShield" ][ "easy" ]		 = 0.5;
	level.difficultySettings[ "invulTime_postShield" ][ "normal" ]   = 0.3;
	level.difficultySettings[ "invulTime_postShield" ][ "hardened" ] = 0.1;
	level.difficultySettings[ "invulTime_postShield" ][ "veteran" ]  = 0.0;

	// level.playerHealth_RegularRegenDelay
	// The delay before you regen health after getting hurt
	// TFLAME - 2/22/11 - Kind of weird how it is longer on easier difficulties?
	level.difficultySettings[ "playerHealth_RegularRegenDelay" ][ "easy" ] 		 = 3 * 1000;
	level.difficultySettings[ "playerHealth_RegularRegenDelay" ][ "normal" ]	 = 2.4 * 1000;
	level.difficultySettings[ "playerHealth_RegularRegenDelay" ][ "hardened" ] = 1.2 * 1000;
	level.difficultySettings[ "playerHealth_RegularRegenDelay" ][ "veteran" ]	 = 1.2 * 1000;


	// level.worthyDamageRatio( player must recieve this much damage as a fraction of maxhealth to get invulTime. )
	level.difficultySettings[ "worthyDamageRatio" ][ "easy" ] = 0.0;
	level.difficultySettings[ "worthyDamageRatio" ][ "normal" ]  = 0.1;
	level.difficultySettings[ "worthyDamageRatio" ][ "hardened" ] = 0.1;
	level.difficultySettings[ "worthyDamageRatio" ][ "veteran" ]  = 0.1;


	// level.explosiveplanttime
	level.difficultySettings[ "explosivePlantTime" ][ "easy" ]     = 10;
	level.difficultySettings[ "explosivePlantTime" ][ "normal" ]   = 10;
	level.difficultySettings[ "explosivePlantTime" ][ "hardened" ] = 5;
	level.difficultySettings[ "explosivePlantTime" ][ "veteran" ]  = 5;
	level.explosiveplanttime = level.difficultySettings[ "explosivePlantTime"  ][ level.currentDifficulty ];


	level.difficultySettings[ "coopPlayer_deathInvulnerableTime" ][ "easy" ][0] 		= 1.0;
	level.difficultySettings[ "coopPlayer_deathInvulnerableTime" ][ "easy" ][1] 		= 0.9;
	level.difficultySettings[ "coopPlayer_deathInvulnerableTime" ][ "easy" ][2] 		= 0.8;
	level.difficultySettings[ "coopPlayer_deathInvulnerableTime" ][ "easy" ][3] 		= 0.7;
	level.difficultySettings[ "coopPlayer_deathInvulnerableTime" ][ "normal" ][0] 		= 1.0; // one player
	level.difficultySettings[ "coopPlayer_deathInvulnerableTime" ][ "normal" ][1] 		= 0.9; // two players
	level.difficultySettings[ "coopPlayer_deathInvulnerableTime" ][ "normal" ][2] 		= 0.8; // three players
	level.difficultySettings[ "coopPlayer_deathInvulnerableTime" ][ "normal" ][3] 		= 0.7; // four players
	level.difficultySettings[ "coopPlayer_deathInvulnerableTime" ][ "hardened" ][0] 	= 1.00;
	level.difficultySettings[ "coopPlayer_deathInvulnerableTime" ][ "hardened" ][1] 	= 0.9;
	level.difficultySettings[ "coopPlayer_deathInvulnerableTime" ][ "hardened" ][2] 	= 0.8;
	level.difficultySettings[ "coopPlayer_deathInvulnerableTime" ][ "hardened" ][3] 	= 0.7;
	level.difficultySettings[ "coopPlayer_deathInvulnerableTime" ][ "veteran" ][0] 		= 1.0;
	level.difficultySettings[ "coopPlayer_deathInvulnerableTime" ][ "veteran" ][1] 		= 0.9;
	level.difficultySettings[ "coopPlayer_deathInvulnerableTime" ][ "veteran" ][2] 		= 0.8;
	level.difficultySettings[ "coopPlayer_deathInvulnerableTime" ][ "veteran" ][3] 		= 0.7;

	level.difficultySettings[ "coopPlayerDifficultyHealth" ][ "easy" ][0] = 1.00;
	level.difficultySettings[ "coopPlayerDifficultyHealth" ][ "easy" ][1] = 0.95;
	level.difficultySettings[ "coopPlayerDifficultyHealth" ][ "easy" ][2] = 0.8;
	level.difficultySettings[ "coopPlayerDifficultyHealth" ][ "easy" ][3] = 0.75;
	level.difficultySettings[ "coopPlayerDifficultyHealth" ][ "normal" ][0] = 1.00; // one player
	level.difficultySettings[ "coopPlayerDifficultyHealth" ][ "normal" ][1] = 0.9; // two players
	level.difficultySettings[ "coopPlayerDifficultyHealth" ][ "normal" ][2] = 0.8; // three players
	level.difficultySettings[ "coopPlayerDifficultyHealth" ][ "normal" ][3] = 0.7; // four players
	level.difficultySettings[ "coopPlayerDifficultyHealth" ][ "hardened" ][0] = 1.00;
	level.difficultySettings[ "coopPlayerDifficultyHealth" ][ "hardened" ][1] = 0.85;
	level.difficultySettings[ "coopPlayerDifficultyHealth" ][ "hardened" ][2] = 0.7;
	level.difficultySettings[ "coopPlayerDifficultyHealth" ][ "hardened" ][3] = 0.65;
	level.difficultySettings[ "coopPlayerDifficultyHealth" ][ "veteran" ][0] = 1.00;
	level.difficultySettings[ "coopPlayerDifficultyHealth" ][ "veteran" ][1] = 0.8;
	level.difficultySettings[ "coopPlayerDifficultyHealth" ][ "veteran" ][2] = 0.6;
	level.difficultySettings[ "coopPlayerDifficultyHealth" ][ "veteran" ][3] = 0.5;

	level.difficultySettings[ "coopEnemyAccuracyScalar" ][ "easy" ][0] = 1;
	level.difficultySettings[ "coopEnemyAccuracyScalar" ][ "easy" ][1] = 1.1;
	level.difficultySettings[ "coopEnemyAccuracyScalar" ][ "easy" ][2] = 1.2;
	level.difficultySettings[ "coopEnemyAccuracyScalar" ][ "easy" ][3] = 1.3;
	level.difficultySettings[ "coopEnemyAccuracyScalar" ][ "normal" ][0] = 1; // one player
	level.difficultySettings[ "coopEnemyAccuracyScalar" ][ "normal" ][1] = 1.1; // two players
	level.difficultySettings[ "coopEnemyAccuracyScalar" ][ "normal" ][2] = 1.3; // three players
	level.difficultySettings[ "coopEnemyAccuracyScalar" ][ "normal" ][3] = 1.5; // four players
	level.difficultySettings[ "coopEnemyAccuracyScalar" ][ "hardened" ][0] = 1.0;
	level.difficultySettings[ "coopEnemyAccuracyScalar" ][ "hardened" ][1] = 1.2;
	level.difficultySettings[ "coopEnemyAccuracyScalar" ][ "hardened" ][2] = 1.4;
	level.difficultySettings[ "coopEnemyAccuracyScalar" ][ "hardened" ][3] = 1.6;
	level.difficultySettings[ "coopEnemyAccuracyScalar" ][ "veteran" ][0] = 1;
	level.difficultySettings[ "coopEnemyAccuracyScalar" ][ "veteran" ][1] = 1.3;
	level.difficultySettings[ "coopEnemyAccuracyScalar" ][ "veteran" ][2] = 1.6;
	level.difficultySettings[ "coopEnemyAccuracyScalar" ][ "veteran" ][3] = 2;

	level.difficultySettings[ "coopFriendlyAccuracyScalar" ][ "easy" ][0] = 1;
	level.difficultySettings[ "coopFriendlyAccuracyScalar" ][ "easy" ][1] = 0.9;
	level.difficultySettings[ "coopFriendlyAccuracyScalar" ][ "easy" ][2] = 0.8;
	level.difficultySettings[ "coopFriendlyAccuracyScalar" ][ "easy" ][3] = 0.7;
	level.difficultySettings[ "coopFriendlyAccuracyScalar" ][ "normal" ][0] = 1; // one player
	level.difficultySettings[ "coopFriendlyAccuracyScalar" ][ "normal" ][1] = 0.8; // two players
	level.difficultySettings[ "coopFriendlyAccuracyScalar" ][ "normal" ][2] = 0.7; // three players
	level.difficultySettings[ "coopFriendlyAccuracyScalar" ][ "normal" ][3] = 0.6; // four players
	level.difficultySettings[ "coopFriendlyAccuracyScalar" ][ "hardened" ][0] = 1;
	level.difficultySettings[ "coopFriendlyAccuracyScalar" ][ "hardened" ][1] = 0.7;
	level.difficultySettings[ "coopFriendlyAccuracyScalar" ][ "hardened" ][2] = 0.5;
	level.difficultySettings[ "coopFriendlyAccuracyScalar" ][ "hardened" ][3] = 0.5;
	level.difficultySettings[ "coopFriendlyAccuracyScalar" ][ "veteran" ][0] = 1;
	level.difficultySettings[ "coopFriendlyAccuracyScalar" ][ "veteran" ][1] = 0.7;
	level.difficultySettings[ "coopFriendlyAccuracyScalar" ][ "veteran" ][2] = 0.5;
	level.difficultySettings[ "coopFriendlyAccuracyScalar" ][ "veteran" ][3] = 0.4;

	level.difficultySettings[ "coopFriendlyThreatBiasScalar" ][ "easy" ][0] = 1;
	level.difficultySettings[ "coopFriendlyThreatBiasScalar" ][ "easy" ][1] = 1.1;
	level.difficultySettings[ "coopFriendlyThreatBiasScalar" ][ "easy" ][2] = 1.2;
	level.difficultySettings[ "coopFriendlyThreatBiasScalar" ][ "easy" ][3] = 1.3;
	level.difficultySettings[ "coopFriendlyThreatBiasScalar" ][ "normal" ][0] = 1; // one player
	level.difficultySettings[ "coopFriendlyThreatBiasScalar" ][ "normal" ][1] = 2; // two players
	level.difficultySettings[ "coopFriendlyThreatBiasScalar" ][ "normal" ][2] = 3; // three players
	level.difficultySettings[ "coopFriendlyThreatBiasScalar" ][ "normal" ][3] = 4; // four players
	level.difficultySettings[ "coopFriendlyThreatBiasScalar" ][ "hardened" ][0] = 1.0;
	level.difficultySettings[ "coopFriendlyThreatBiasScalar" ][ "hardened" ][1] = 3;
	level.difficultySettings[ "coopFriendlyThreatBiasScalar" ][ "hardened" ][2] = 6;
	level.difficultySettings[ "coopFriendlyThreatBiasScalar" ][ "hardened" ][3] = 9;
	level.difficultySettings[ "coopFriendlyThreatBiasScalar" ][ "veteran" ][0] = 1;
	level.difficultySettings[ "coopFriendlyThreatBiasScalar" ][ "veteran" ][1] = 10;
	level.difficultySettings[ "coopFriendlyThreatBiasScalar" ][ "veteran" ][2] = 20;
	level.difficultySettings[ "coopFriendlyThreatBiasScalar" ][ "veteran" ][3] = 30;


	 // lateral accuracy modifier
	level.difficultySettings[ "lateralAccuracyModifier" ][ "easy" ]     = 300;
	level.difficultySettings[ "lateralAccuracyModifier" ][ "normal" ]   = 700;
	level.difficultySettings[ "lateralAccuracyModifier" ][ "hardened" ] = 1000;
	level.difficultySettings[ "lateralAccuracyModifier" ][ "veteran" ]  = 2500;
			
	// set all the difficulty based variables according to the current difficulty
	set_difficulty_from_locked_settings();

	if( GetDvar( "g_gametype" ) != "vs" )
	{
		setsaveddvar( "player_meleeDamageMultiplier", 100 / 250 );
	}

	// TFLAME - 2/18/11 - Moving all coop code I can to only be called if we actually have co-op players
	if ( coopGame() )
	{
		thread coop_player_threat_bias_adjuster(); 		// Makes the coop players get targeted more often
		thread coop_enemy_accuracy_scalar_watcher();
		thread coop_friendly_accuracy_scalar_watcher();
	}
}

apply_difficulty_var_with_func( difficulty_func )
{
	level.invulTime_preShield = [[ difficulty_func ]]( "invulTime_preShield" );
	level.invulTime_onShield = [[ difficulty_func ]]( "invulTime_onShield" ) * level.invulTime_onShield_multiplier;
	level.invulTime_postShield = [[ difficulty_func ]]( "invulTime_postShield" );
	level.playerHealth_RegularRegenDelay = [[ difficulty_func ]]( "playerHealth_RegularRegenDelay" );
	level.worthyDamageRatio = [[ difficulty_func ]]( "worthyDamageRatio" );
		
	if ( level.auto_adjust_threatbias )
	{
		thread apply_threat_bias_to_all_players(difficulty_func);
	}

	level.longRegenTime = [[ difficulty_func ]]( "longRegenTime" );
	level.healthOverlayCutoff = [[ difficulty_func ]]( "healthOverlayCutoff" );
		
	anim.player_attacker_accuracy = [[ difficulty_func ]]( "base_enemy_accuracy" ) * level.player_attacker_accuracy_multiplier;

	anim.missTimeConstant = [[ difficulty_func ]]( "missTimeConstant" );
	anim.missTimeDistanceFactor = [[ difficulty_func ]]( "missTimeDistanceFactor" );
	anim.dog_hits_before_kill = [[ difficulty_func ]]( "dog_hits_before_kill" );
	anim.double_grenades_allowed = [[ difficulty_func ]]( "double_grenades_allowed" );

	anim.playerGrenadeBaseTime = int( [[ difficulty_func ]]( "playerGrenadeBaseTime" ) );
	anim.playerGrenadeRangeTime = int( [[ difficulty_func ]]( "playerGrenadeRangeTime" ) );
	anim.playerDoubleGrenadeTime = int( [[ difficulty_func ]]( "playerDoubleGrenadeTime" ) );

	anim.min_sniper_burst_delay_time = [[ difficulty_func ]]( "min_sniper_burst_delay_time" );
	anim.max_sniper_burst_delay_time = [[ difficulty_func ]]( "max_sniper_burst_delay_time" );
		
	anim.dog_health = [[ difficulty_func ]]( "dog_health" );
	anim.dog_presstime = [[ difficulty_func ]]( "dog_presstime" );
		
	setsaveddvar( "ai_accuracyDistScale", [[ difficulty_func ]]( "accuracyDistScale" ) );
	
	thread coop_damage_and_accuracy_scaling(difficulty_func );
}


apply_threat_bias_to_all_players(difficulty_func)
{
	// waittill the flag is defined, then check for it
	while (!isdefined (level.flag) || !isdefined(level.flag[ "all_players_connected" ]))
	{
		wait 0.05;
		continue;
	}
	
	flag_wait( "all_players_connected" );
	
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i].threatbias = int( [[ difficulty_func ]]( "threatbias" ) );
	}
}

coop_damage_and_accuracy_scaling( difficulty_func )
{
	// if it's not set up by now, wait for it
	while (!isdefined (level.flag))
	{
		wait 0.05;
	}
	
	while (!isdefined (level.flag["all_players_spawned"]))
	{
		wait 0.05;
	}
	
	flag_wait( "all_players_spawned" );

	
	players = get_players();

	coop_healthscalar = getCoopValue( "coopPlayerDifficultyHealth", players.size );
	
	if( GetDvar( "g_gametype" ) != "vs" )
	{
		setsaveddvar( "player_damageMultiplier", 100 / ([[ difficulty_func ]]( "playerDifficultyHealth" ) * coop_healthscalar) );
		coop_invuln_remover = getCoopValue( "coopPlayer_deathInvulnerableTime", players.size );
		setsaveddvar( "player_deathInvulnerableTime", int( [[ difficulty_func ]]( "player_deathInvulnerableTime" ) * coop_invuln_remover) );
	}
	
}
	
set_difficulty_from_locked_settings()
{
	apply_difficulty_var_with_func( ::get_locked_difficulty_val );
}


getCurrentDifficultySetting( msg )
{
	return level.difficultySettings[ msg ][ level.currentDifficulty ];
}


// Returns scaled value for current number of co-op players.  Basically right now since there is no co-op it will always return 1 (unscaled value)
getCoopValue( msg, numplayers )
{
	if (numplayers <= 0)
	{
		numplayers = 1;
	}
	return( level.difficultySettings[ msg ][ GetDvar( "currentDifficulty" ) ][numplayers - 1]);
}

// returns current level difficulty.  locked refers to as opposed to an old system which used to blend difficulties which is now gone
get_locked_difficulty_val( msg, ignored ) // ignored is there because this is used as a function pointer with another function that does have a second parm
{
	return level.difficultySettings[ msg ][ level.currentDifficulty ];
}

always_pain()
{
		return false;
}

// TFLAME - 2/22/11 - If you shoot multiple AI within a short interval, 75% of the time the second guy won’t play a hit reaction.  This helps stop abuse of players
// spraying a clumped group of AI with bullets as they all pain react on harder difficulties
pain_protection()
{
	if ( !pain_protection_check() )
	{
		return false;
	}
		
	return( randomint( 100 ) > 25 );
}

pain_protection_check()
{
	if ( !isalive( self.enemy ) )
	{
		return false;
	}
		
	if ( !IsPlayer(self.enemy) )
	{
		return false;
	}
		
	if ( !isalive( level.painAI ) || level.painAI.a.script != "pain" )
	{
		level.painAI = self;
	}

	// The pain AI can always take pain, so if the player focuses on one guy he'll see pain animations.
	if ( self == level.painAI )
	{
		return false;
	}

	if ( self.damageWeapon != "none" && weaponIsBoltAction( self.damageWeapon ) )
	{
		return false;
	}

	return true;
}

 /#
playerHealthDebug()
{
	if ( GetDvar( "scr_health_debug" ) == "" )
	{
		SetDvar( "scr_health_debug", "0" );
	}

	waittillframeend; // for init to finish
	
	while ( 1 )
	{
		while ( 1 )
		{
			if ( getdebugdvar( "scr_health_debug" ) != "0" )
			{
				break;
			}
			wait .5;
		}
		thread printHealthDebug();
		while ( 1 )
		{
			if ( getdebugdvar( "scr_health_debug" ) == "0" )
			{
				break;
			}
			wait .5;
		}
		level notify( "stop_printing_grenade_timers" );
		destroyHealthDebug();
	}
}

printHealthDebug()
{
	level notify( "stop_printing_health_bars" );
	level endon( "stop_printing_health_bars" );
	
	const x = 40;
	y = 40;
	
	level.healthBarHudElems = [];
	
	level.healthBarKeys[ 0 ] = "Health";
	level.healthBarKeys[ 1 ] = "No Hit Time";
	level.healthBarKeys[ 2 ] = "No Die Time";
	
	if ( !isDefined( level.playerInvulTimeEnd ) )
	{
		level.playerInvulTimeEnd = 0;
	}

	if ( !isDefined( level.player_deathInvulnerableTimeout ) )
	{
		level.player_deathInvulnerableTimeout = 0;
	}
	
	for ( i = 0; i < level.healthBarKeys.size; i++ )
	{
		key = level.healthBarKeys[ i ];
		
		textelem = newHudElem();
		textelem.x = x;
		textelem.y = y;
		textelem.alignX = "left";
		textelem.alignY = "top";
		textelem.horzAlign = "fullscreen";
		textelem.vertAlign = "fullscreen";
		textelem setText( key );
		
		bgbar = newHudElem();
		bgbar.x = x + 79;
		bgbar.y = y + 1;
		bgbar.alignX = "left";
		bgbar.alignY = "top";
		bgbar.horzAlign = "fullscreen";
		bgbar.vertAlign = "fullscreen";
		bgbar.maxwidth = 3;
		bgbar setshader( "white", bgbar.maxwidth, 10 );
		bgbar.color = ( 0.5, 0.5, 0.5 );

		bar = newHudElem();
		bar.x = x + 80;
		bar.y = y + 2;
		bar.alignX = "left";
		bar.alignY = "top";
		bar.horzAlign = "fullscreen";
		bar.vertAlign = "fullscreen";
		bar setshader( "black", 1, 8 );
		
		textelem.bar = bar;
		textelem.bgbar = bgbar;
		textelem.key = key;
		
		y += 10;
		
		level.healthBarHudElems[ key ] = textelem;
	}

	flag_wait( "all_players_spawned" );
	
	while ( 1 )
	{
		wait .05;
		
		// CODER_MOD - JamesS fix for coop
		players = get_players();
		
		for ( i = 0; i < level.healthBarKeys.size && players.size > 0; i++ )
		{
			key = level.healthBarKeys[ i ];
			
			player = players[0];
			
			width = 0;
			if ( i == 0 )
			{
				width = player.health / player.maxhealth * 300;
			}
			else if ( i == 1 )
			{
				width = ( level.playerInvulTimeEnd - gettime() ) / 1000 * 40;
			}
			else if ( i == 2 )
			{
				width = ( level.player_deathInvulnerableTimeout - gettime() ) / 1000 * 40;
			}

			width = int( max( width, 1 ) );
			width = int( min( width, 300 ) );

			bar = level.healthBarHudElems[ key ].bar;
			bar setShader( "black", width, 8 );

			bgbar = level.healthBarHudElems[ key ].bgbar;
			if( width+2 > bgbar.maxwidth )
			{
				bgbar.maxwidth = width+2;
				bgbar setshader( "white", bgbar.maxwidth, 10 );
				bgbar.color = ( 0.5, 0.5, 0.5 );
			}
		}
	}
}

destroyHealthDebug()
{
	if ( !isdefined( level.healthBarHudElems ) )
	{
		return;
	}
	for ( i = 0; i < level.healthBarKeys.size; i++ )
	{
		level.healthBarHudElems[ level.healthBarKeys[ i ] ].bgbar destroy();
		level.healthBarHudElems[ level.healthBarKeys[ i ] ].bar destroy();
		level.healthBarHudElems[ level.healthBarKeys[ i ] ] destroy();
	
	}
}
#/


// this is run on each enemy AI.
axisAccuracyControl()
{
	self endon( "long_death" );
	self endon( "death" );
		
	self coop_axis_accuracy_scaler();
}


// this is run on each friendly AI.
alliesAccuracyControl()
{
	self endon( "long_death" );
	self endon( "death" );
		
	self coop_allies_accuracy_scaler();
}

// Runs every time an AI fires, controls AI accuracy and thus much of the combat difficulty
set_accuracy_based_on_situation()
{
	if ( self animscripts\combat_utility::isSniper() && isAlive( self.enemy ) )
	{
		self setSniperAccuracy();
		return;
	}
	
	if ( isPlayer( self.enemy ) )
	{
		resetMissDebounceTime();  
		if ( self.a.missTime > gettime() ) 
		{
			self.accuracy = 0;
			return;
		}

		if ( self.a.script == "move"  )
		{
			self.accuracy = anim.run_accuracy * self.baseAccuracy;
			return;
		}
	}
	else
	{
		if ( self.a.script == "move"  )
		{
			self.accuracy = anim.run_accuracy * self.baseAccuracy;
			return;
		}
	}
	
	self.accuracy = self.baseAccuracy;
}

setSniperAccuracy()
{
	/*
	// if sniperShotCount isn't defined, a sniper is shooting from some place that's not in normal shoot behavior.
	// that probably means they're doing some sort of blindfire or something that would look stupid for a sniper to do.
	assert( isdefined( self.sniperShotCount ) );
	*/
	if ( !IsDefined( self.sniperShotCount ) )
	{
		// snipers get this error if a dog attacks them
		self.sniperShotCount = 0;
		self.sniperHitCount = 0;
	}
	
	self.sniperShotCount++ ;
	
	// Miss the first shot on a newly acquierd enemy, then become very and increasingly accurate as long as I have the same enemy
	if ( ( !isDefined( self.lastMissedEnemy ) || self.enemy != self.lastMissedEnemy ) && distanceSquared( self.origin, self.enemy.origin ) > 500 * 500 )
	{
		// miss
		self.accuracy = 0;
		if ( level.gameSkill > 0 || self.sniperShotCount > 1 )
			self.lastMissedEnemy = self.enemy;
				
		return;
	}
	
	// guarantee a hit unless baseAccuracy is 0
	self.accuracy = ( 1 + 1 * self.sniperHitCount ) * self.baseAccuracy;
	
	self.sniperHitCount++ ;

	if ( level.gameSkill < 1 && self.sniperHitCount == 1 )
		self.lastMissedEnemy = undefined;// miss again
}

didSomethingOtherThanShooting()
{
	 // make sure the next time resetAccuracyAndPause() is called, we reset our misstime for sure
	self.a.missTimeDebounce = 0;
}

resetMissTime()
{
	if ( self.team != "axis" )
	{
		return;
	}
	
	if ( self.weapon == "none" )
	{
		return;
	}
	
	if ( !self animscripts\weaponList::usingAutomaticWeapon() && !self animscripts\weaponList::usingSemiAutoWeapon() )
	{
		self.missTime = 0;
		return;
	}
	
	self.a.nonstopFire = false;
	
	if ( !isalive( self.enemy ) )
	{
		return;
	}
	
	if ( !IsPlayer(self.enemy) )
	{
		self.accuracy = self.baseAccuracy;
		return;
	}
	
	dist = distance( self.enemy.origin, self.origin );
	
	// TFLAME - 3/7/11 -  anim.misstimeconstant is irrelevant - its max value is 1, and the distance is always going to be in the hundreds - so +1 is inconsequential
	// TFLAME - 3/7/11 - anim.missTimeDistanceFactor is .8,.1,.05,0
	// TFLAME - 3/7/11 - This is really weird, because this will set the miss time to a huge number apparently, if we're using distance as a base then it will be in the hundreds and at the least in the double digit wait time
	self setMissTime( anim.missTimeConstant + dist * anim.missTimeDistanceFactor );
}

resetMissDebounceTime()
{
	self.a.missTimeDebounce = gettime() + 3000;
}

setMissTime( howLong )
{
	assert( self.team == "axis", "Non axis tried to set misstime" );
	
	 // we can only start missing again if it's been a few seconds since we last shot
	if ( self.a.missTimeDebounce > gettime() )
	{
		return;
	}
	
	if ( howLong > 0 )
	{
		self.accuracy = 0;
	}
	
	howLong *= 1000;// convert to milliseconds
	
	self.a.missTime = gettime() + howLong;
	self.a.accuracyGrowthMultiplier = 1;
//	thread print3d_time( self.origin + (0,0,32 ), "Aiming..", (1,1,0), howLong * 0.001 );
	//thread player_aim_debug();
}

playerHurtcheck()
{
	self.hurtAgain = false;
	for ( ;; )
	{
		self waittill( "damage", amount, attacker, dir, point, mod );
		
		if(isdefined(attacker) && isplayer(attacker) && attacker.team == self.team)
		{
			continue;
		}
		
		self.hurtAgain = true;
		self.damagePoint = point;
		self.damageAttacker = attacker;

// MikeD (8/7/2007): New player_burned effect.
		if( IsDefined (mod) && mod == "MOD_BURNED" )
		{
			self setburn( 0.5 );
			self PlaySound( "chr_burn" );
		}
	}
}


// controls player health regeneration and invulerability time
playerHealthRegen()
{
	self endon ("death");
	self endon ("disconnect");

	if( !IsDefined( self.flag ) )
	{
		self.flag = [];
		self.flags_lock = [];
	}
	if( !IsDefined(self.flag["player_has_red_flashing_overlay"]) )
	{
		self player_flag_init("player_has_red_flashing_overlay");
		self player_flag_init("player_is_invulnerable");
	}
	self player_flag_clear("player_has_red_flashing_overlay");
	self player_flag_clear("player_is_invulnerable");

	self thread increment_take_cover_warnings_on_death(); // TFLAME - 2/22/11 - These systems are broken atm
	self setTakeCoverWarnings();

	self thread healthOverlay();
	oldratio = 1;
	health_add = 0;
	
	veryHurt = false;
	playerJustGotRedFlashing = false;
	
	//self thread playerBreathingSound(self.maxhealth * 0.35);
	//self thread playerHeartbeatSound(self.maxhealth * 0.75);
	//self thread endPlayerBreathingSoundOnDeath();
	//self thread playerheartbeatloop(self.maxhealth * .7 );
	
	invulTime = 0;
	hurtTime = 0;
	newHealth = 0;
	lastinvulratio = 1;
	self thread playerHurtcheck();
	if(!IsDefined (self.veryhurt))
	{
		self.veryhurt = 0;
	}
	
	self.boltHit = false;
	
	for( ;; )
	{
		wait( 0.05 );
		waittillframeend; // if we're on hard, we need to wait until the bolt damage check before we decide what to do

		if( self.health == self.maxHealth )
		{
			if( self player_flag( "player_has_red_flashing_overlay" ) )
			{
				player_flag_clear( "player_has_red_flashing_overlay" );
			}

			lastinvulratio = 1;
			playerJustGotRedFlashing = false;
			veryHurt = false;
			continue;
		}

		if( self.health <= 0 )
		{
			return;
		}

		wasVeryHurt = veryHurt;
		health_ratio = self.health / self.maxHealth;

		// Checks difficulty, decides if we're hurt enough to show red hurt overlay/blur.  The harder the difficulty, the sooner this plays.
		if( health_ratio <= level.healthOverlayCutoff )
		{
			veryHurt = true;
			self thread cover_warning_check();
			
			if( !wasVeryHurt )
			{
				hurtTime = gettime();
				self startfadingblur( 3.6, 2 );

				self player_flag_set( "player_has_red_flashing_overlay" );
				playerJustGotRedFlashing = true;
			}
		}

		if( self.hurtAgain )
		{
			hurtTime = gettime();
			self.hurtAgain = false;
		}

		
		if( health_ratio >= oldratio ) // Make sure we haven't taken damage since the last frame
		{
			if( gettime() - hurttime < level.playerHealth_RegularRegenDelay ) // based on difficulty, can we start regenerating yet?  Harder the dif, shorter the delay
			{
				continue;
			}

			if( veryHurt ) // once we're veryhurt, we stay veryhurt until we fully regenerate
			{
				self.veryhurt = 1;
				newHealth = health_ratio;
				if( gettime() > hurtTime + level.longRegenTime ) // has it been 5 seconds since we were hurt? (same for all difficulties)
				{
					const regenRate = 0.1; // 0.017;
					newHealth += regenRate; // always adds 10 health per frame.  At this rate we always regenerate within half a second after the 5 second delay
				}

				if ( newHealth >= 1 )
				{
					reduceTakeCoverWarnings();
				}
			}
			else
			{
				newHealth = 1;
				self.veryhurt = 0;
			}
							
			if( newHealth > 1.0 )
			{
				newHealth = 1.0;
			}
			
			if( newHealth <= 0 ) // Player is dead
			{
				return;
			}
			
			self setnormalhealth( newHealth );

			oldratio = self.health / self.maxHealth;
			continue;
		}
		// if we're here, we have taken damage: health_ratio < oldratio.

		invulWorthyHealthDrop = lastinvulRatio - health_ratio > level.worthyDamageRatio; // true if dmg was over 10, or any dmg on easy

		if( self.health <= 1 )
		{
			 // if player's health is <= 1, code's player_deathInvulnerableTime has kicked in and the player won't lose health for a while.
			 // set the health to 2 so we can at least detect when they're getting hit.
			self setnormalhealth( 2 / self.maxHealth );
			invulWorthyHealthDrop = true;
/#
			if ( !isDefined( level.player_deathInvulnerableTimeout ) )
			{
				level.player_deathInvulnerableTimeout = 0;
			}
			if ( level.player_deathInvulnerableTimeout < gettime() )
			{
				level.player_deathInvulnerableTimeout = gettime() + GetDvarint( "player_deathInvulnerableTime" );
			}
			#/
		}

		oldratio = self.health / self.maxHealth;

		level notify( "hit_again" );

		health_add = 0;
		hurtTime = gettime();
		self startfadingblur( 3, 0.8 ); //We get this mini-blur on every hit
		
		if( !invulWorthyHealthDrop  )
		{
			continue;
		}

		if( self player_flag( "player_is_invulnerable" ) )
			continue;
		self player_flag_set( "player_is_invulnerable" );
		level notify( "player_becoming_invulnerable" ); // because "player_is_invulnerable" notify happens on both set * and * clear

		if( playerJustGotRedFlashing )
		{
			invulTime = level.invulTime_onShield;
			playerJustGotRedFlashing = false;
		}
		else if( veryHurt )
		{
			invulTime = level.invulTime_postShield;
		}
		else
		{
			invulTime = level.invulTime_preShield;
		}

		lastinvulratio = self.health / self.maxHealth;
		self thread playerInvul( invulTime );
	}
}

reduceTakeCoverWarnings()
{
	players = get_players();
	
	if ( isdefined( players[0] ) && isAlive( players[0] ) )
	{
		takeCoverWarnings = GetLocalProfileInt( "takeCoverWarnings" );
		if ( takeCoverWarnings > 0 )
		{
			takeCoverWarnings -- ;
			SetLocalProfileVar( "takeCoverWarnings", takeCoverWarnings );
			 /#DebugTakeCoverWarnings();#/
		}
	}
}

 /#
DebugTakeCoverWarnings()
{
	if ( GetDvar( "scr_debugtakecover" ) == "" )
	{
		SetDvar( "scr_debugtakecover", "0" );
	}
	if ( getdebugdvar( "scr_debugtakecover" ) == "1" )
	{
		iprintln( "Warnings remaining: ", GetLocalProfileInt( "takeCoverWarnings" ) - 3 );
	}
}
#/


//Makes attacker accuracy 0 and other bullets not hurt player. But I think grenades, melee, and other explosives will still kill player.
playerInvul( timer )
{
	self endon( "death" );
	self endon( "disconnect" );

	if ( isdefined( self.flashendtime ) && self.flashendtime > gettime() )
	{
		timer = timer * getCurrentDifficultySetting( "flashbangedInvulFactor" );
	}

	if ( timer > 0 )
	{
		self.attackerAccuracy = 0;
		self.ignoreRandomBulletDamage = true;
		/#
		level.playerInvulTimeEnd = gettime() + timer * 1000;
		#/
	
		wait( timer );
	}
	
	self.attackerAccuracy = anim.player_attacker_accuracy;
	self.ignoreRandomBulletDamage = false;

	self player_flag_clear( "player_is_invulnerable" );
}

// sets grenade awareness for all ai.  Appaerntly enemies don't have very good grenade awareness but friendlies all do
grenadeAwareness()
{
	if ( self.team == "allies" )
	{
		self.grenadeawareness  = 0.9;
		return;
	}
		
	if ( self.team == "axis" )
	{
		if ( level.gameSkill >= 2 )
		{
			 // hard and fu
			if ( randomint( 100 ) < 33 )
			{
				self.grenadeawareness = 0.2;
			}
			else
			{
				self.grenadeawareness = 0.5;
			}
		}
		else
		{
			 // normal
			if ( randomint( 100 ) < 33 )
			{
				self.grenadeawareness = 0;
			}
			else
			{
				self.grenadeawareness = 0.2;
			}
		}
	}
}

playerheartbeatloop(healthcap)
{
	self endon( "disconnect" );
 	self endon( "killed_player" );

	wait (2);
	player = self;
	ent = undefined;
	
	for (;;)
	{
		wait .2;
		// Player still has a lot of health so no hearbeat sound and set to default hearbeat wait
		if (player.health >= healthcap)
		{
			if( isdefined( ent ) )
			{
				ent stoploopsound( 1.5 );
				level thread delayed_delete( ent, 1.5 );
			}
			continue;
		}

		ent = spawn( "script_origin", self.origin );
		ent playloopsound( "", .5 );
	}
}

delayed_delete( ent, time )
{
	wait(time);
	ent delete();
	ent = undefined;
}

//C.Ayers - This system has numerous issues and is rarely used beyond simple pain; getting rid of it for the time being
/*
// sound function - plays breathing sound when low on health
playerBreathingSound(healthcap)
{
	self endon("end_healthregen");
	self endon( "disconnect" );
 	self endon( "killed_player" );
 	
 	if(!IsDefined (level.player_pain_vox))
	{
		level.player_pain_vox = 0;
	}

	wait (2);
	player = self;
	for (;;)
	{
		wait (0.2);
		if (player.health <= 0)
		{
			level.player_pain_vox = 0;
			return;
		}
		// Player still has a lot of health so no breathing sound
		if (player.health >= healthcap)
		{
			player notify ("end_heartbeat_loop");
			continue;
		}

		if (level.player_pain_vox == 0)
 		{
 			playsoundatposition  ("chr_breathing_hurt_start", (0,0,0));
 			level.player_pain_vox = 1;
 		}
		else
		{
			player playLocalSound("chr_breathing_hurt");
		}

		wait .545;
		wait (0.1 + randomfloat (0.8));
	}
}

// sound function - plays heartbeat sound when low on health
playerHeartbeatSound(healthcap)
{
	self endon( "disconnect" );
 	self endon( "killed_player" );
 	
 	level thread heartbeat_init();
 	

	self.breathingStopTime = -10000;
	self.hearbeatwait = .46;
	wait (2);
	player = self;
	for (;;)
	{
			wait .2;
			
		// Player still has a lot of health so no hearbeat sound and set to default hearbeat wait
		if (player.health >= healthcap)
		{
			continue;
		}

		level thread event_heart_beat( "stressed" , 1 );
		
		level notify ("player_pain");

		player waittill( "end_heartbeat_loop" );
	  
	  wait (1.5);
		level thread event_heart_beat( "none" , 0 );

		level.player_pain_vox = 0;
		
	}
}

heartbeat_init()
{
	level.current_heart_waittime = 2;
	level.heart_waittime = 2;
	level.current_breathing_waittime = 4;
	level.breathing_waittime = 4;
	level.emotional_state_system = 0;

}


// sound function - plays heart beat and controller vibration given a certain mood of the player.  Used for tension building or other unique manually scripted situations.
event_heart_beat( emotion, loudness )
{
	
	// Emotional State of Player
	// sedated (super slow heartbeat )
	// relaxed ( normal heart beat )
	// stressed (fast heartbeat)
	
//	iprintlnbold (emotion );
	level.current_emotion = emotion;
	if(!IsDefined (level.last_emotion))
	{
		level.last_emotion = "undefined";
	}
	if( level.current_emotion != level.last_emotion)
	{
		if(level.emotional_state_system == 0)
		{
			level.emotional_state_system = 1;
			level thread play_heart_beat();
			level thread play_breathing();
			
		}
		if(!IsDefined (loudness) || (loudness == 0))
		{
			level.loudness = 0;
		}
		else
		{
			level.loudness = loudness;
			
		}
		switch (emotion)
		{
			case "sedated":
				level.heart_waittime = 3;
				level.breathing_waittime = 4;
				level.last_emotion = "sedated";
				break;
				
			case "relaxed":
				level.heart_waittime = 2;
				level.breathing_waittime = 4;
				level.last_emotion = "relaxed";
				break;
				
			case "stressed":
				level.heart_waittime = 0.5;
				level.breathing_waittime = 2;
				level.last_emotion = "stressed";
				break;
				
			case "panicked":
				level.heart_waittime = 0.3;
				level.breathing_waittime = 1.5;
				level.last_emotion = "panicked";
				break;
				
			case "none":
				level.last_emotion = "none";
				level notify ("no_more_heartbeat");
				playsoundatposition ("vox_breath_scared_stop", (0,0,0));
				level.emotional_state_system = 0;
				break;
			
			default: AssertMsg("Not a Valid Emotional State.  Please switch with sedated, relaxed, happy, stressed, or none");
		}
		thread heartbeat_state_transitions();  //(controls the wait between breaths and beats
	}
		
}
heartbeat_state_transitions()
{
	while (level.current_heart_waittime > level.heart_waittime)
	{
		//iprintlnbold ("current: " + level.current_heart_waittime + "goal: "  + level.heart_waittime);
		level.current_heart_waittime = level.current_heart_waittime - .10;
		wait(.30);
		
	}
	while (level.current_heart_waittime < level.heart_waittime)
	{
		//iprintlnbold ("current: " + level.current_heart_waittime + "goal: "  + level.heart_waittime);
		level.current_heart_waittime = level.current_heart_waittime + .05;
		wait(.40);
	}
	level.current_heart_waittime = level.heart_waittime;
}
play_heart_beat ()
{
	player = getplayers()[0];
	level endon ("no_more_heartbeat");
	if(!IsDefined ( level.heart_wait_counter) )
	{
		level.heart_wait_counter = 0;
	}
	while( 1 )
	{
		while( level.heart_wait_counter < level.current_heart_waittime)
		{
			wait(0.1);
			level.heart_wait_counter = level.heart_wait_counter +0.1;
		}
		
		if (level.loudness == 0)
		{
			playsoundatposition ("chr_heart_beat_ingame", (0,0,0));
		}
		else
		{
			playsoundatposition ("chr_heart_beat_ingame", (0,0,0));
		}
		
		level.heart_wait_counter = 0;
		
	}
	
}
play_breathing()
{
	level endon ("no_more_heartbeat");
	
	if(!IsDefined ( level.breathing_wait_counter) )
	{
		level.breathing_wait_counter = 0;
	}
	for(;;)
	{
		while( level.breathing_wait_counter < level.current_breathing_waittime )
		{
			wait(0.1);
			level.breathing_wait_counter = level.breathing_wait_counter +0.1;
		}
		playsoundatposition ("amb_player_breath_cold", (0,0,0));
		level.breathing_wait_counter = 0;
	}
}
//kevin addin special case to stop the heartbeat and breathing when the player has landed after the base jump.
base_jump_heartbeat_stop()
{
	flag_wait( "players_jumped" );
	level thread event_heart_beat( "none" , 0 );
}

endPlayerBreathingSoundOnDeath()
{
	self endon( "disconnect" );

	self waittill_either( "killed_player", "death" );
	setclientsysstate( "levelNotify", "rfo2", self );
}
*/

healthfadeOffWatcher(overlay,timeToFadeOut)
{
	self notify("new_style_health_overlay_done");
	self endon ("new_style_health_overlay_done");
	while(!IS_TRUE(level.disable_damage_overlay) && timeToFadeOut>0)
	{
		wait 0.05;
		timeToFadeOut -= 0.05;
	}
	if (IS_TRUE(level.disable_damage_overlay))
	{
		overlay.alpha = 0;
		overlay fadeOverTime( 0.05 );
	}
}

new_style_health_overlay()
{
	overlay = NewClientHudElem( self );
	overlay.x = 0;
	overlay.y = 0;

	if ( issplitscreen() )
	{
		overlay SetShader( "overlay_low_health_splat", 640, 480 * 2 );

		// offset the blood a little so it looks different for each player
		if ( self == level.players[ 0 ] )
		{
			overlay.y -= 120;
		}
	}
	else
	{
		overlay SetShader( "overlay_low_health_splat", 640, 480 );
	}
	overlay.splatter = true;
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.sort = 1;
	overlay.foreground = 0;
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;

	thread healthOverlay_remove( overlay );

	const updateTime = 0.05;
	const timeToFadeOut = 0.75;
	
	while (1)
	{
		wait updateTime;

		if( IS_TRUE(level.disable_damage_overlay) )
		{
			targetDamageAlpha 	= 0;
			overlay.alpha 		= 0;
		}
		else
		{
			targetDamageAlpha = 1.0 - self.health / self.maxHealth;
		}

		if ( overlay.alpha < targetDamageAlpha ) // took damage since last update
		{
			overlay.alpha = targetDamageAlpha; // pop to alpha.  jarring effect.  nice.
		}
		else if (  overlay.alpha != 0  ) // full health
		{
			level thread healthfadeOffWatcher(overlay,timeToFadeOut);
			overlay FadeOverTime( timeToFadeOut );
			overlay.alpha = 0;
			// play the breathing better sound
			//self playsound ("chr_breathing_better");
		}
	}
}

healthOverlay()
{
	self endon( "disconnect" );
	self endon( "noHealthOverlay" );
	
	new_style_health_overlay();
}

add_hudelm_position_internal( alignY )
{
	if ( level.console )
	{
		self.fontScale = 2;
	}
	else
	{
		self.fontScale = 1.6;
	}
		
	self.x = 0;// 320;
	self.y = -36;// 200;
	self.alignX = "center";
	self.alignY = "bottom";
	self.horzAlign = "center";
	self.vertAlign = "middle";
	
	if ( !isdefined( self.background ) )
	{
		return;
	}
	self.background.x = 0;// 320;
	self.background.y = -40;// 200;
	self.background.alignX = "center";
	self.background.alignY = "middle";
	self.background.horzAlign = "center";
	self.background.vertAlign = "middle";
	if ( level.console )
	{
		self.background setshader( "popmenu_bg", 650, 52 );
	}
	else
	{
		self.background setshader( "popmenu_bg", 650, 42 );
	}
	self.background.alpha = .5;
}

create_warning_elem( player )
{
	level notify( "hud_elem_interupt" );
	hudelem = newHudElem();
	hudelem maps\_gameskill::add_hudelm_position_internal();
	hudelem thread maps\_gameskill::destroy_warning_elem_when_mission_failed( player );
	hudelem setText( &"GAME_GET_TO_COVER" );
	hudelem.fontscale = 1.85;
	hudelem.alpha = 1;
	hudelem.color = ( 1, 0.6, 0 );

	return hudelem;
}

play_hurt_vox()
{
	if(IsDefined (self.veryhurt))
	{
		//Randomly plays a "hurt" sound when shot
		if(self.veryhurt == 0)
		{
			if(randomintrange(0,1) == 1)
			{
				playsoundatposition ("chr_breathing_hurt_start", self.origin);
			}
		}
	}
}

waitTillPlayerIsHitAgain()
{
	level endon( "hit_again" );
	self waittill( "damage" );
}

/* DEAD CODE REMOVAL
destroy_warning_elem_when_hit_again( player )
{
	self endon( "being_destroyed" );
	
	player waitTillPlayerIsHitAgain();
	
	fadeout = ( !isalive( player ) );
	self thread destroy_warning_elem( fadeout );
}
*/

destroy_warning_elem_when_mission_failed( player )
{
	self endon( "being_destroyed" );
	self endon ("death");
	
	flag_wait( "missionfailed" );
	
		// TFLAME - 3/22/11 - This shouldn't be player, should be self.  But this was never called in BO because the cover warning stuff was broken
	self thread destroy_warning_elem( true );
}

destroy_warning_elem( fadeout )
{
	self notify( "being_destroyed" );
	self.beingDestroyed = true;
	
	if ( fadeout )
	{
		self fadeOverTime( 0.5 );
		self.alpha = 0;
		wait 0.5;
	}
	self death_notify_wrapper();
	self destroy();
}

mayChangeCoverWarningAlpha( coverWarning )
{
	if ( !isdefined( coverWarning ) )
	{
		return false;
	}
	if ( isdefined( coverWarning.beingDestroyed ) )
	{
		return false;
	}
	return true;
}


// TFLAME - 2/24/11 - This currently crashes the game, in particular if you use changeFontScaleOverTime. As far as i can tell this is somehow told not to run in zombies, the only time it would get called
fontScaler( scale, timer )
{
	self endon( "death" );
	scale *= 2;
	dif = scale - self.fontscale;
	self changeFontScaleOverTime( timer );
	self.fontscale += dif;
}

// TFLAME - 2/24/11 - Get the cover warnings working again, will see if any bugs pop up since the system wasn't running at all since midway through black ops
// Seperated the old cover warning system which was integrated together with the old hud since we don't use that hud anymore.  That old health hud really needs to be updated
cover_warning_check()
{
	level endon( "missionfailed" );
	
	if ( self shouldShowCoverWarning() )
	{
		coverwarning = create_warning_elem( self );
		level.cover_warning_hud = coverwarning;
		
		coverwarning endon( "death" );

		stopFlashingBadlyTime = gettime() + level.longRegenTime;
		
		yellow_fac = 0.7;
		
		while ( gettime() < stopFlashingBadlyTime && isalive( self ) )
		{
			for (i=0; i< 7; i++)
			{
				yellow_fac +=0.03;
				coverwarning.color = (1,yellow_fac,0);
				wait 0.05;
			}
			
			for (i=0; i< 7; i++)
			{
				yellow_fac -=0.03;
				coverwarning.color = (1,yellow_fac,0);
				wait 0.05;
			}
		}
		
		if ( maps\_gameskill::mayChangeCoverWarningAlpha( coverwarning ) )
		{
			coverwarning fadeOverTime( 0.5 );
			coverwarning.alpha = 0;
		}
		
		wait( 0.5 );// for fade out
		wait 5;
		coverwarning destroy();
	}
}


// TFLAME - 2/24/11 - Get the cover warnings working again, will see if any bugs pop up since the system wasn't running at all since midway through black ops
shouldShowCoverWarning()
{
	return false;	// TODO: remove after GL
	
	// Glocke: need to disable this for the Makin outro so adding in a level var
	if( IsDefined(level.enable_cover_warning) )
	{
		return level.enable_cover_warning;
	}
	
	if ( !isAlive( self ) )
	{
		return false;
	}
	
	if ( level.gameskill > 1 )
	{
		return false;
	}
	
	if ( level.missionfailed )
	{
		return false;
	}
	
	// TFLAME - 2/22/11 - These refer to specific levels which are not reliable, and this may not be desirable anyway
	/*
	if ( !maps\_load_common::map_is_early_in_the_game() )
	{
		return false;
	}
	*/

	if ( isSplitScreen() || coopGame() )
	{
		return false;
	}
	
	// note: takeCoverWarnings is 3 more than the number of warnings left.
	// this lets it stay away for a while unless we die 3 times in a row without taking cover successfully.
	takeCoverWarnings = GetLocalProfileInt( "takeCoverWarnings" );
	if ( takeCoverWarnings <= 3 )
	{
		return false;
	}
	
	if (isdefined(level.cover_warning_hud))
	{
		return false;
	}

	return true;
}

// TFLAME - 2/22/11 -  only used in zombies, from old_health_overlay.  New_health_overlay is much simpler and contains this equivelent within that func.  Consider simplifying to match that.
// &"GAME_GET_TO_COVER";
redFlashingOverlay( overlay )
{
	self endon( "hit_again" );
	self endon( "damage" );
	self endon ("death");
	self endon ("disconnect");

	coverWarning = undefined;

	if ( self shouldShowCoverWarning() )
	{
		 // get to cover!
		coverWarning = create_warning_elem( self );
		// coverWarning may be destroyed at any time if we fail the mission.
	}
	
	 // if severity isn't very high, the overlay becomes very unnoticeable to the player.
	 // keep it high while they haven't regenerated or they'll feel like their health is nearly full and they're safe to step out.
	
	stopFlashingBadlyTime = gettime() + level.longRegenTime;
	
	fadeFunc( overlay, coverWarning,  1,   1, false );
	while ( gettime() < stopFlashingBadlyTime && isalive( self ) )
	{
		fadeFunc( overlay, coverWarning, .9,   1, false );
	}
	
	if ( isalive( self ) )
	{
		fadeFunc( overlay, coverWarning, .65, 0.8, false );
	}
	
	if ( mayChangeCoverWarningAlpha( coverWarning ) )
	{
		coverWarning fadeOverTime( 1.0 );
		coverWarning.alpha = 0;
	}
	
	fadeFunc( overlay, coverWarning,  0, 0.6, true );

	overlay fadeOverTime( 0.5 );
	overlay.alpha = 0;
	
	self player_flag_clear( "player_has_red_flashing_overlay" );

	//self thread play_sound_on_entity( "breathing_better" );

	// MikeD (8/1/2008): Send to CSC that the 'rfo' "red flashing overlay" is getting better and play the better breathing sound
	//setclientsysstate( "levelNotify", "rfo3", self );

	wait( 0.5 );// for fade out
	self notify( "hit_again" );
}


// TFLAME - 2/24/11 - Also only used in zombies for the old COD 2 legacy hurt hud.  Campaign uses the blood splat.  At some point we should consolidate the design.
fadeFunc( overlay, coverWarning, severity, mult, hud_scaleOnly )
{
	const pulseTime = 0.8;
	
	fadeInTime = pulseTime * 0.1;
	stayFullTime = pulseTime * ( .1 + severity * .2 );
	fadeOutHalfTime = pulseTime * ( 0.1 + severity * .1 );
	fadeOutFullTime = pulseTime * 0.3;
	remainingTime = pulseTime - fadeInTime - stayFullTime - fadeOutHalfTime - fadeOutFullTime;
	assert( remainingTime >= -.001 );
	if ( remainingTime < 0 )
	{
		remainingTime = 0;
	}
	
	halfAlpha = 0.8 + severity * 0.1;
	leastAlpha = 0.5 + severity * 0.3;
	
	overlay fadeOverTime( fadeInTime );
	overlay.alpha = mult * 1.0;
	if ( mayChangeCoverWarningAlpha( coverWarning ) )
	{
		if ( !hud_scaleOnly )
		{
			coverWarning fadeOverTime( fadeInTime );
			coverWarning.alpha = mult * 1.0;
		}
	}
	if ( isDefined( coverWarning ) )
	{
		coverWarning thread fontScaler( 1.0, fadeInTime );
	}
	wait fadeInTime + stayFullTime;
	
	overlay fadeOverTime( fadeOutHalfTime );
	overlay.alpha = mult * halfAlpha;
	if ( mayChangeCoverWarningAlpha( coverWarning ) )
	{
		if ( !hud_scaleOnly )
		{
			coverWarning fadeOverTime( fadeOutHalfTime );
			coverWarning.alpha = mult * halfAlpha;
		}
	}
	
	wait fadeOutHalfTime;
	
	overlay fadeOverTime( fadeOutFullTime );
	overlay.alpha = mult * leastAlpha;
	if ( mayChangeCoverWarningAlpha( coverWarning ) )
	{
		if ( !hud_scaleOnly )
		{
			coverWarning fadeOverTime( fadeOutFullTime );
			coverWarning.alpha = mult * leastAlpha;
		}
	}
	if ( isDefined( coverWarning ) )
	{
		coverWarning thread fontScaler( 0.9, fadeOutFullTime );
	}
	wait fadeOutFullTime;

	wait remainingTime;
}

// TFLAME - 2/24/11 - Fades out the overlay on death, not sure if that is already covered by mission failing, also fades out if a nohealthoverlay notify is sent.  Althoguh it would only fade back in as soon as it would anyway from the other threads
healthOverlay_remove( overlay )
{
	// this hud element will get cleaned up automatically by the code when the player disconnects
	// so we just need to make sure this thread ends
	self endon ("disconnect");

	self waittill_any ("noHealthOverlay", "death");

	// CODER_MOD
	// Austin (4/19/08): fade out the overlay for the 4/21 milestone

	//overlay destroy();
	
	overlay fadeOverTime( 3.5 );
	overlay.alpha = 0;
	
}

// TFLAME - 2/24/11 - Get the cover warnings working again, will see if any bugs pop up since the system wasn't running at all since midway through black ops
setTakeCoverWarnings()
{
	 // generates "Get to Cover" x number of times when you first get hurt
	// dvar defaults to - 1
	
	// TFLAME - 2/22/11 - MW 1 specific ... needs to be updated.
	isPreGameplayLevel = ( level.script == "training" || level.script == "cargoship" || level.script == "coup" );
	
	if ( GetLocalProfileInt( "takeCoverWarnings" ) == -1 || isPreGameplayLevel )
	{
		// takeCoverWarnings is 3 more than the number of warnings we want to occur.
		SetLocalProfileVar( "takeCoverWarnings", 3 + 6 );
	}
	 /#DebugTakeCoverWarnings();#/
}

// TFLAME - 2/24/11 - Get the cover warnings working again, will see if any bugs pop up since the system wasn't running at all since midway through black ops
increment_take_cover_warnings_on_death()
{
	// MikeD (7/30/2007): This function is intended only for players.
	if( !IsPlayer( self ) )
	{
		return;
	}

	level notify( "new_cover_on_death_thread" );
	level endon( "new_cover_on_death_thread" );
	self waittill( "death" );
	
	// dont increment if player died to grenades, explosion, etc
	if( !(self player_flag( "player_has_red_flashing_overlay" ) ) )
	{
		return;
	}
		
	if ( level.gameSkill > 1 )
	{
		return;
	}
	
	warnings = GetLocalProfileInt( "takeCoverWarnings" );
	if ( warnings < 10 )
	{
		SetLocalProfileVar( "takeCoverWarnings", warnings + 1 );
	}
	 /#DebugTakeCoverWarnings();#/
}

empty_kill_func( type, loc, point, attacker, amount )
{
	
}


// CODER_MOD - Sumeet - On COD:BO we are supporting skill change in game
// ALEXP Note - this actually only works if the gameskill value is lowered. If it's increased,
// like it is in challenge_bloodbath, this function will restore the lower value.
update_skill_on_change()
{
	level endon("stop_update_skill_on_change");

	waittillframeend; // for everything to be defined

	for(;;)
	{
		lowest_current_skill = GetDvarint( "saved_gameskill" );
		gameskill 			 = GetLocalProfileInt( "g_gameskill" );
		
		if ( gameskill < lowest_current_skill )
			lowest_current_skill = gameskill;
			
		if( lowest_current_skill < level.gameskill )
		{
			setSkill( true, lowest_current_skill );
		}
		
		wait( 0.1 );
	}
}

// updated the levelvar to lower or increase enemy accuracy
coop_enemy_accuracy_scalar_watcher()
{
	level waittill ("load main complete");
	flag_wait("all_players_connected");
		
	while (get_players().size > 1) // TFLAME - 2/24/11 - Dont need to run this loop if we are down to one player, as there is and shall be no hot join
	{
		players = get_players("allies");
		
		level.coop_enemy_accuracy_scalar = getCoopValue( "coopEnemyAccuracyScalar", players.size  );
		
		wait (0.5);
	}

}

coop_friendly_accuracy_scalar_watcher()
{
	level waittill ("load main complete");
	flag_wait("all_players_connected");
	
	while (get_players().size > 1) // TFLAME - 2/24/11 - Dont need to run this loop if we are down to one player, as there is and shall be no hot join
	{
		// CODER_MOD : DSL - only use friendly players.
		
		players = get_players("allies");
		
		level.coop_friendly_accuracy_scalar = getCoopValue( "coopFriendlyAccuracyScalar", players.size  );
		
		wait (0.5);
	}
}


// this gets called everytime an axis spawns in
coop_axis_accuracy_scaler()
{
	self endon ("death");
	
	// use the GDT value as the starting point
	initialValue = self.baseAccuracy;

	while (get_players().size > 1) // TFLAME - 2/24/11 - Dont need to run this loop if we are down to one player, as there is and shall be no hot join
	{
		if( !IsDefined( level.coop_enemy_accuracy_scalar ) )
		{
			wait 0.5;
			continue;
		}

		self.baseAccuracy = initialValue * level.coop_enemy_accuracy_scalar;
		
		//level waittill ("player_disconnected");
		wait randomfloatrange(3,5);
	}

}


// this gets called everytime an axis spawns in
coop_allies_accuracy_scaler()
{
	self endon ("death");
		
	// use the GDT value as the starting point
	initialValue = self.baseAccuracy;

	while (get_players().size > 1) // TFLAME - 2/24/11 - Dont need to run this loop if we are down to one player, as there is and shall be no hot join
	{
		if( !IsDefined( level.coop_friendly_accuracy_scalar ) )
		{
			wait 0.5;
			continue;
		}

		self.baseAccuracy = initialValue * level.coop_friendly_accuracy_scalar;
				
		//level waittill ("player_disconnected");
		wait randomfloatrange(3,5);
	}
}

// to make the enemies shoot at players more often
coop_player_threat_bias_adjuster()
{
	while (1)
	{
		// we don't need to do this all the time, only if players drop out
		wait 5;
		
		if ( level.auto_adjust_threatbias )
		{
			players = get_players("allies");
				
			// the usual threat bias times some scalar
			for( i = 0; i < players.size; i++ )
			{
				// adjust according to the setup system
				enable_auto_adjust_threatbias(players[i]);
			}
		}
	}
}
