#include maps\_utility;
#include animscripts\utility;
#include common_scripts\utility;

	
setSkillThread()
{	
	self endon( "death" );
		
	setSkill();
		
	while(1)
	{
		wait(0.5);
		
		gameskill = getdvarint( "level_gameskill");
		
		
		if( gameskill != level.gameSkill )
		{
			setDifficultyFractionalValues();
			
			level.gameSkill = gameskill;
		}
	}
}
	
 
setSkill( reset )
{
	if( !isdefined( level.script ) )
		level.script = tolower( getdvar( "mapname" ) );
	
	if( !isdefined( reset ) || reset == false )
	{
		if( isdefined( level.gameSkill ) )
			return;
	}
	
	
 

	if ( getdvar( "regentime_low" ) == "" )
		setdvar( "regentime_low",  2 );
	if ( getdvar( "regentime_mid" ) == "" )
		setdvar( "regentime_mid",  2.5 );
	if ( getdvar( "regentime_high" ) == "" )
		setdvar( "regentime_high", 3 );

	if( getdvar( "autodifficulty_playerDeathTimer" ) == "" )
		setdvar( "autodifficulty_playerDeathTimer", 0 );
	
	if( getdvar( "scr_ai_run_accuracy" ) == "" )
		setdvar( "scr_ai_run_accuracy", "0.5" );
	
	if( !isdefined( level.xenon ) )
		level.xenon = ( getdvar( "xenonGame" ) == "true" );
	
	level.gameSkill = getdvarint( "g_gameskill" );
	setdvar( "level_gameskill", level.gameSkill );
	
	 
	setdvar( "autodifficulty_frac", 0 ); 
	
	level.difficultyType[ 0 ] = "easy";
	level.difficultyType[ 1 ] = "normal";
	level.difficultyType[ 2 ] = "hardened";
	level.difficultyType[ 3 ] = "veteran";
	
	level.difficultyString[ "easy" ] = &"GAMESKILL_EASY";
	level.difficultyString[ "normal" ] = &"GAMESKILL_NORMAL";
	level.difficultyString[ "hardened" ] = &"GAMESKILL_HARDENED";
	level.difficultyString[ "veteran" ] = &"GAMESKILL_VETERAN";
	setCurrentDifficulty();
	flag_init( "player_has_red_flashing_overlay" );
	flag_init( "player_is_invulnerable" );
	flag_clear( "player_has_red_flashing_overlay" );
	flag_clear( "player_is_invulnerable" );
	setTakeCoverWarnings();
	thread increment_take_cover_warnings_on_death();
	
	if( !isdefined( level.axis_accuracy ) )
		level.axis_accuracy = 1;
		
	level.mg42badplace_mintime = 8; 
	level.mg42badplace_maxtime = 16; 

	 
	level.difficultySettings[ "playerGrenadeBaseTime" ][ "easy" ] = 40000;
	level.difficultySettings[ "playerGrenadeBaseTime" ][ "normal" ] = 15000;
	level.difficultySettings[ "playerGrenadeBaseTime" ][ "hardened" ] = 10000;
	level.difficultySettings[ "playerGrenadeBaseTime" ][ "veteran" ] = 0;

	 
	level.difficultySettings[ "playerGrenadeRangeTime" ][ "easy" ] = 15000;
	level.difficultySettings[ "playerGrenadeRangeTime" ][ "normal" ] = 10000;
	level.difficultySettings[ "playerGrenadeRangeTime" ][ "hardened" ] = 5000;
	level.difficultySettings[ "playerGrenadeRangeTime" ][ "veteran" ] = 1;

	level.difficultySettings[ "player_deathInvulnerableTime" ][ "easy" ]     = 1500;
	level.difficultySettings[ "player_deathInvulnerableTime" ][ "normal" ]   = 1000;
	level.difficultySettings[ "player_deathInvulnerableTime" ][ "hardened" ] =  500;
	level.difficultySettings[ "player_deathInvulnerableTime" ][ "veteran" ]  =  100;
	
	level.difficultySettings[ "threatbias" ][ "easy" ] = 150; 
	level.difficultySettings[ "threatbias" ][ "normal" ] = 400;
	level.difficultySettings[ "threatbias" ][ "hardened" ] = 500; 
	level.difficultySettings[ "threatbias" ][ "veteran" ] = 600; 

	 
	level.difficultySettings[ "minimumBoltPlayerProtectionTime" ][ "easy" ] = 2400;
	level.difficultySettings[ "minimumBoltPlayerProtectionTime" ][ "normal" ] = 1400;
	level.difficultySettings[ "minimumBoltPlayerProtectionTime" ][ "hardened" ] = 800;
	level.difficultySettings[ "minimumBoltPlayerProtectionTime" ][ "veteran" ] = 800;

	 
	  
	level.difficultySettings[ "longRegenTime" ][ "easy" ]		= 800;
	level.difficultySettings[ "longRegenTime" ][ "normal" ]		= 900;
	level.difficultySettings[ "longRegenTime" ][ "hardened" ]	= 1000;
	level.difficultySettings[ "longRegenTime" ][ "veteran" ]	= 1500;

	 
	level.difficultySettings[ "healthOverlayCutoff" ][ "easy" ] = 0.01;
	level.difficultySettings[ "healthOverlayCutoff" ][ "normal" ] = 0.28;
	level.difficultySettings[ "healthOverlayCutoff" ][ "hardened" ] = 0.35;
	level.difficultySettings[ "healthOverlayCutoff" ][ "veteran" ] = 0.35;

	 
	level.difficultySettings[ "playerDifficultyHealth" ][ "easy" ]		= 300;	
	level.difficultySettings[ "playerDifficultyHealth" ][ "normal" ]	= 250;	
	level.difficultySettings[ "playerDifficultyHealth" ][ "hardened" ]	= 175;	
	level.difficultySettings[ "playerDifficultyHealth" ][ "veteran" ]	= 100;	

	 
	level.difficultySettings[ "difficultyFunc" ][ "easy" ] = ::difficultyEasy;
	level.difficultySettings[ "difficultyFunc" ][ "normal" ] = ::difficultyEasy;
	level.difficultySettings[ "difficultyFunc" ][ "hardened" ] = ::difficultyHard;
	level.difficultySettings[ "difficultyFunc" ][ "veteran" ] = ::difficultyFu;
 
	 
	 
	 
	 
	
	level.difficultySettings[ "missTimeConstant" ][ "easy" ]     = 1.0;
	level.difficultySettings[ "missTimeConstant" ][ "normal" ]   = 0.2;
	level.difficultySettings[ "missTimeConstant" ][ "hardened" ] = 0.04;
	level.difficultySettings[ "missTimeConstant" ][ "veteran" ]  = 0.03;

	level.difficultySettings[ "missTimeDistanceFactor" ][ "easy" ]     = 1.2 / 1000;
	level.difficultySettings[ "missTimeDistanceFactor" ][ "normal" ]   = 0.8 / 1000;
	level.difficultySettings[ "missTimeDistanceFactor" ][ "hardened" ] = 0.2 / 1000;
	level.difficultySettings[ "missTimeDistanceFactor" ][ "veteran" ]  = 0.085 / 1000;
	
	 
	level.difficultySettings[ "accuracyGrowthRate" ][ "easy" ]     = 0.0;
	level.difficultySettings[ "accuracyGrowthRate" ][ "normal" ]   = 0.1;
	level.difficultySettings[ "accuracyGrowthRate" ][ "hardened" ] = 0.3;
	level.difficultySettings[ "accuracyGrowthRate" ][ "veteran" ]  = 0.7;
	
	 
	level.difficultySettings[ "accuracyGrowthMax" ][ "easy" ]     = 1.0;
	level.difficultySettings[ "accuracyGrowthMax" ][ "normal" ]   = 1.75;
	level.difficultySettings[ "accuracyGrowthMax" ][ "hardened" ] = 2.5;
	level.difficultySettings[ "accuracyGrowthMax" ][ "veteran" ]  = 4.0;

	
	level.difficultySettings[ "lowRegenTime" ][ "easy" ]     = getdvarint( "regentime_low" );
	level.difficultySettings[ "lowRegenTime" ][ "normal" ]   = getdvarint( "regentime_low" );
	level.difficultySettings[ "lowRegenTime" ][ "hardened" ] = getdvarint( "regentime_low" );
	level.difficultySettings[ "lowRegenTime" ][ "veteran" ]  = getdvarint( "regentime_low" );
	level.difficultySettings[ "midRegenTime" ][ "easy" ]     = getdvarint( "regentime_mid" );
	level.difficultySettings[ "midRegenTime" ][ "normal" ]   = getdvarint( "regentime_mid" );
	level.difficultySettings[ "midRegenTime" ][ "hardened" ] = getdvarint( "regentime_mid" );
	level.difficultySettings[ "midRegenTime" ][ "veteran" ]  = getdvarint( "regentime_mid" );
	level.difficultySettings[ "highRegenTime" ][ "easy" ]     = getdvarint( "regentime_high" );
	level.difficultySettings[ "highRegenTime" ][ "normal" ]   = getdvarint( "regentime_high" );
	level.difficultySettings[ "highRegenTime" ][ "hardened" ] = getdvarint( "regentime_high" );
	level.difficultySettings[ "highRegenTime" ][ "veteran" ]  = getdvarint( "regentime_high" );

	 
	level.difficultySettings[ "sniperBreathDifficulty" ][ "easy" ]		= 0.5;
	level.difficultySettings[ "sniperBreathDifficulty" ][ "normal" ]	= 0.0;
	level.difficultySettings[ "sniperBreathDifficulty" ][ "hardened" ]	= -0.5;
	level.difficultySettings[ "sniperBreathDifficulty" ][ "veteran" ]	= -1.0;


	if( level.xenon )
	{
		 
		 
		level.difficultySettings[ "invulTime_preShield" ][ "easy" ] = 0.5;
		level.difficultySettings[ "invulTime_preShield" ][ "normal" ] = 0.6;
		level.difficultySettings[ "invulTime_preShield" ][ "hardened" ] = 0.25;
		level.difficultySettings[ "invulTime_preShield" ][ "veteran" ] = 0.2;
		
		 
		level.difficultySettings[ "invulTime_onShield" ][ "easy" ] = 2.0;
		level.difficultySettings[ "invulTime_onShield" ][ "normal" ] = 1.5;
		level.difficultySettings[ "invulTime_onShield" ][ "hardened" ] = 0.8;
		level.difficultySettings[ "invulTime_onShield" ][ "veteran" ] = 0.2;
		
		 
		level.difficultySettings[ "invulTime_postShield" ][ "easy" ] = 1.0;
		level.difficultySettings[ "invulTime_postShield" ][ "normal" ] = 0.8;
		level.difficultySettings[ "invulTime_postShield" ][ "hardened" ] = 0.6;
		level.difficultySettings[ "invulTime_postShield" ][ "veteran" ] = 0.2;
		
		 
		level.difficultySettings[ "playerHealth_RegularRegenDelay" ][ "easy" ] = 250;
		level.difficultySettings[ "playerHealth_RegularRegenDelay" ][ "normal" ] = 250;
		level.difficultySettings[ "playerHealth_RegularRegenDelay" ][ "hardened" ] = 250;
		level.difficultySettings[ "playerHealth_RegularRegenDelay" ][ "veteran" ] = 250;

		 
		level.difficultySettings[ "worthyDamageRatio" ][ "easy" ] = 0.0;
		level.difficultySettings[ "worthyDamageRatio" ][ "normal" ] = 0.18;
		level.difficultySettings[ "worthyDamageRatio" ][ "hardened" ] = 0.0;
		level.difficultySettings[ "worthyDamageRatio" ][ "veteran" ] = 0.0;

		 
		level.difficultySettings[ "explosivePlantTime" ][ "easy" ] = 10;
		level.difficultySettings[ "explosivePlantTime" ][ "normal" ] = 10; 
		level.difficultySettings[ "explosivePlantTime" ][ "hardened" ] = 5; 
		level.difficultySettings[ "explosivePlantTime" ][ "veteran" ] = 5; 

		 
 		level.difficultySettings[ "difficultyBasedAccuracy" ][ "easy" ] = 1;
		level.difficultySettings[ "difficultyBasedAccuracy" ][ "normal" ] = 1;
 		level.difficultySettings[ "difficultyBasedAccuracy" ][ "hardened" ] = 1;
		level.difficultySettings[ "difficultyBasedAccuracy" ][ "veteran" ] = 1.25;
	}
	else
	{
		 
		 
		level.difficultySettings[ "invulTime_preShield" ][ "easy" ] = 0.5;
		level.difficultySettings[ "invulTime_preShield" ][ "normal" ] = 0.6;
		level.difficultySettings[ "invulTime_preShield" ][ "hardened" ] = 0.25;
		level.difficultySettings[ "invulTime_preShield" ][ "veteran" ] = 0.2;
		
		 
		level.difficultySettings[ "invulTime_onShield" ][ "easy" ] = 2.0;
		level.difficultySettings[ "invulTime_onShield" ][ "normal" ] = 1.5;
		level.difficultySettings[ "invulTime_onShield" ][ "hardened" ] = 1.0;
		level.difficultySettings[ "invulTime_onShield" ][ "veteran" ] = 0.2;
		
		 
		level.difficultySettings[ "invulTime_postShield" ][ "easy" ] = 1.0;
		level.difficultySettings[ "invulTime_postShield" ][ "normal" ] = 0.8;
		level.difficultySettings[ "invulTime_postShield" ][ "hardened" ] = 0.6;
		level.difficultySettings[ "invulTime_postShield" ][ "veteran" ] = 0.2;

		level.difficultySettings[ "playerHealth_RegularRegenDelay" ][ "easy" ] = 250; 
		level.difficultySettings[ "playerHealth_RegularRegenDelay" ][ "normal" ] = 250; 
		level.difficultySettings[ "playerHealth_RegularRegenDelay" ][ "hardened" ] = 250; 
		level.difficultySettings[ "playerHealth_RegularRegenDelay" ][ "veteran" ] = 250; 
		
		level.difficultySettings[ "worthyDamageRatio" ][ "easy" ] = 0.0;
		level.difficultySettings[ "worthyDamageRatio" ][ "normal" ] = 0.18;
		level.difficultySettings[ "worthyDamageRatio" ][ "hardened" ] = 0.0;
		level.difficultySettings[ "worthyDamageRatio" ][ "veteran" ] = 0.0;

		level.difficultySettings[ "explosivePlantTime" ][ "easy" ] = 10;
		level.difficultySettings[ "explosivePlantTime" ][ "normal" ] = 5; 
		level.difficultySettings[ "explosivePlantTime" ][ "hardened" ] = 5; 
		level.difficultySettings[ "explosivePlantTime" ][ "veteran" ] = 5; 

 		level.difficultySettings[ "difficultyBasedAccuracy" ][ "easy" ] = 1; 
		level.difficultySettings[ "difficultyBasedAccuracy" ][ "normal" ] = 1; 
 		level.difficultySettings[ "difficultyBasedAccuracy" ][ "hardened" ] = 1;
		level.difficultySettings[ "difficultyBasedAccuracy" ][ "veteran" ] = 1.4;
	}
	
	level.conserveAmmoAgainstInvulPlayer = true;
	
	 
	level.lastPlayerSighted = 0;
	setDifficultyFractionalValues();
	setDifficultyStepValues();
	 
}

setDifficultyFractionalValues()
{
	 
	
	 
	frac = getdvarint( "autodifficulty_frac" );
	if( frac > 100 )
		setdvar( "autodifficulty_frac", "100" );
	if( frac < 0 )
		setdvar( "autodifficulty_frac", "0" );
		
	assert( getdvarint( "autodifficulty_frac" ) >= 0 );
	assert( getdvarint( "autodifficulty_frac" ) <= 100 );
	
	min = getdvarint( "level_gameskill" );
	if( min > 2 )
	{
		min = 2;
		 
		setdvar( "autodifficulty_frac", "100" );
	}
	max = min + 1;
	
	level.invulTime_preShield = getRatio( "invulTime_preShield", min, max );
	level.invulTime_onShield = getRatio( "invulTime_onShield", min, max );
	level.invulTime_postShield = getRatio( "invulTime_postShield", min, max );
	level.playerHealth_RegularRegenDelay = getRatio( "playerHealth_RegularRegenDelay", min, max );
	level.worthyDamageRatio = getRatio( "worthyDamageRatio", min, max );
	level.player.threatbias = int( getRatio( "threatbias", min, max ) );
	level.longRegenTime = getRatio( "longRegenTime", min, max );
	level.healthOverlayCutoff = getRatio( "healthOverlayCutoff", min, max );

	
	level.lowRegenPeriod = getRatio( "lowRegenTime", min, max ) / (.33/.01);
	level.midRegenPeriod = getRatio( "midRegenTime", min, max ) / (.33/.01);
	level.highRegenPeriod = getRatio( "highRegenTime", min, max ) / (.34/.01);

 
 
	setsaveddvar( "player_damageMultiplier", 100 / getRatio( "playerDifficultyHealth", min, max ) );
	setsaveddvar( "player_meleeDamageMultiplier", 100 / 250 );
	
	anim.difficultyBasedAccuracy = getRatio( "difficultyBasedAccuracy", min, max );
	anim.playerGrenadeBaseTime = int( getRatio( "playerGrenadeBaseTime", min, max ) );
	anim.playerGrenadeRangeTime = int( getRatio( "playerGrenadeRangeTime", min, max ) );
	anim.minimumBoltPlayerProtectionTime = getRatio( "minimumBoltPlayerProtectionTime", min, max );
	anim.accuracyGrowthRate = getRatio( "accuracyGrowthRate", min, max );
	anim.accuracyGrowthMax = getRatio( "accuracyGrowthMax", min, max );
	
	 
	setsaveddvar( "player_deathInvulnerableTime", int( getRatio( "player_deathInvulnerableTime", min, max ) ) );
}

setDifficultyStepValues()
{
	 
	anim.missTimeConstant = getCurrentDifficultySetting( "missTimeConstant" );
	anim.missTimeDistanceFactor = getCurrentDifficultySetting( "missTimeDistanceFactor" );
	anim.difficultyFunc = getCurrentDifficultySetting( "difficultyFunc" );
	level.explosiveplanttime = getCurrentDifficultySetting( "explosivePlantTime" );
	
	
	breathTime = getCurrentDifficultySetting( "sniperBreathDifficulty" );
	setsaveddvar( "sniperDifficultyTimeAdj", breathTime );
}


getCurrentDifficultySetting( msg )
{
	return level.difficultySettings[ msg ][ getdvar( "currentDifficulty" ) ];
}

getRatio( msg, min, max )
{
	return( level.difficultySettings[ msg ][ level.difficultyType[ min ] ] * ( 100 - getdvarint( "autodifficulty_frac" ) ) + level.difficultySettings[ msg ][ level.difficultyType[ max ] ] * getdvarint( "autodifficulty_frac" ) ) * 0.01;
}

difficultyEasy()
{
	return false;
}

difficultyHard()
{
	if( !difficultyHardPainCheck() )
		return false;

	return( randomint( 100 ) > 25 );
}

difficultyFu()
{
	if( !difficultyHardPainCheck() )
		return false;
		
	return( randomint( 100 ) > 25 );
}

difficultyHardPainCheck()
{
	if( !isalive( self.enemy ) )
		return false;
		
	if( self.enemy != level.player )
		return false;
		
	if( !isalive( level.painAI ) || level.painAI.a.script != "pain" )
		level.painAI = self;

	 
	if( self == level.painAI )
		return false;

	if( weaponIsBoltAction( self.damageWeapon ) )
		return false;

	return true;
}

 
axisAccuracyControl()
{
	self endon( "long_death" );
	self endon( "death" );
	
	if( getdvar( "scr_dynamicaccuracy" ) == "" )
		setdvar( "scr_dynamicaccuracy", "off" );
	if( getdvar( "scr_dynamicaccuracy" ) != "on" )
	{
 
	}
	else
	{
		for( ;; )
		{
			wait( 0.05 );
			waittillframeend; 
			
			if( isDefined( self.enemy ) && isPlayer( self.enemy ) && self canSee( self.enemy ) )
			{
				self.a.accuracyGrowthMultiplier += 0.05 * anim.accuracyGrowthRate;
				if( self.a.accuracyGrowthMultiplier > anim.accuracyGrowthMax )
					self.a.accuracyGrowthMultiplier = anim.accuracyGrowthMax;
			}
			else
			{
				self.a.accuracyGrowthMultiplier = 1;
			}
			
			self setEnemyAccuracy();
		}
	}
}

alliesAccuracyControl()
{
	self endon( "long_death" );
	self endon( "death" );
	
 
}

set_accuracy_based_on_situation()
{
	if( isalive( self.enemy ) && isdefined( self.enemy.magic_bullet_shield ) )
	{
		assertex( self.enemy.magic_bullet_shield == true, "self.magic_bullet_shield was not true. It should be either true or undefined." );
		self.accuracy = 0;
		return;
	}
	
	if( self.a.script == "move" )
	{
		self.accuracy = getdvarfloat( "scr_ai_run_accuracy" ) * self.baseAccuracy * level.axis_accuracy;
		return;
	}

	self.accuracy = self.baseAccuracy * level.axis_accuracy;
}

  

setEnemyAccuracy()
{
	assert( 0 );
	if( !isalive( self.enemy ) )
	{
		self.accuracy = 1;
		return;
	}
	
	if( !isplayer( self.enemy ) || isdefined( self.script_do_not_intentionally_miss_player ) )
	{
		if( isdefined( self.enemy.magic_bullet_shield ) && self.enemy.magic_bullet_shield )
			self.accuracy = 0;
		else
			self setEnemyAccuracyToHit();
		
		return;
	}
	
	 
	if( self.a.missTime > gettime() )
	{
		self.accuracy = 0;
		self.a.accuracyGrowthMultiplier = 1;
		return;
	}
	
	autoguy = self animscripts\weaponList::usingAutomaticWeapon() || self animscripts\weaponList::usingSemiAutoWeapon();
	if( !autoGuy )
	{
		self setEnemyAccuracyToHit();
		return;
	}
	
	if( flag( "player_is_invulnerable" ) )
		self.accuracy = 0;
	else
		self setEnemyAccuracyToHit();
}

setEnemyAccuracyToHit()
{
	if( isplayer( self.enemy ) )
		self.accuracy = self.baseAccuracy * level.axis_accuracy * anim.difficultyBasedAccuracy * self.a.accuracyGrowthMultiplier;
	else
		self.accuracy = self.baseAccuracy * level.axis_accuracy;
}


shotsAfterPlayerBecomesInvul()
{
	return( 1 + randomfloat( 4 ) );
}

didSomethingOtherThanShooting()
{
	 
	self.a.missTimeDebounce = 0;
}

 
resetAccuracyAndPause()
{
	if( getdvar( "scr_dynamicaccuracy" ) == "" )
		setdvar( "scr_dynamicaccuracy", "off" );
	if( getdvar( "scr_dynamicaccuracy" ) != "on" )
		return;

	self resetMissTime();
	
	self conserveAmmoWhilePlayerIsInvulnerable();
}

conserveAmmoWhilePlayerIsInvulnerable()
{
	 
	while( flag( "player_is_invulnerable" ) )
	{
		if( !isalive( self.enemy ) || !isplayer( self.enemy ) )
			return;
		
		self endon( "enemy" ); 
		
		self setEnemyAccuracy();

		 
		if( self.shouldConserveAmmoTime < level.conserveAmmoAgainstInvulPlayerTime )
		{
			self.shouldConserveAmmo = level.conserveAmmoAgainstInvulPlayer;
			self.shouldConserveAmmoTime = level.conserveAmmoAgainstInvulPlayerTime;
			
			 
			 
			level.conserveAmmoAgainstInvulPlayer = !level.conserveAmmoAgainstInvulPlayer;
		}
		
		if( !self.shouldConserveAmmo && self.bulletsInClip > 5 )
			break;
		
		maxwait = 60; 
		waited = 0;
		while( flag( "player_is_invulnerable" ) && self cansee( self.enemy ) && distanceSquared( self.origin, self.enemy.origin ) < 1200 * 1200 && waited < maxwait )
		{
			resetMissDebounceTime();
			
			waited ++ ;
			wait .05;
		}
		
		 
		wait( .05 * randomint( 3 ) );
		
		self setEnemyAccuracy();
	}
}

waitTimeIfPlayerIsHit()
{
	waittime = 0;
	waittillframeend;
	if( !isalive( self.enemy ) )
		return waittime;
		
	if( self.enemy != level.player )
		return waittime;

	if( flag( "player_is_invulnerable" ) && !self.a.nonstopFire )
		waittime = ( 0.3 + randomfloat( 0.4 ) );
	return waittime;
}

resetMissTime()
{
	if( !self animscripts\weaponList::usingAutomaticWeapon() && !self animscripts\weaponList::usingSemiAutoWeapon() )
	{
		self.missTime = 0;
		return;
	}
	
	self.a.nonstopFire = false;
	
	if( !isalive( self.enemy ) )
		return;
	if( self.enemy != level.player )
	{
		self.accuracy = self.baseAccuracy;
		return;
	}
	
	dist = distance( self.enemy.origin, self.origin );
	self setMissTime( anim.missTimeConstant + dist * anim.missTimeDistanceFactor );
}

resetMissDebounceTime()
{
	self.a.missTimeDebounce = gettime() + 3000;
}

setMissTime( timer )
{
	self.a.missTime = 0;
	if( self.team != "axis" )
		return;
	
	 
	if( self.a.missTimeDebounce > gettime() )
	{
		resetMissDebounceTime();
		return;
	}
	resetMissDebounceTime();
	
	self.accuracy = 0;
	
	timer *= 20; 
	if( timer < 1 )
		timer = 1;
	
	self.a.missTime = gettime() + timer;
	self.a.accuracyGrowthMultiplier = 1;
}


resetAccuracy()
{
	setMissTime( ( 200 + randomfloat( 100 ) ) * 0.01 );
}

playerHurtcheck()
{
	self.hurtAgain = false;
	for( ;; )
	{
		self waittill( "damage", amount, attacker, dir, point );
		self.hurtAgain = true;
		self.damagePoint = point;
		self.damageAttacker = attacker;
	}
}

boltCheck()
{
	 
	self endon( "death" );
	for( ;; )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, cause );
		if( level.gameSkill != 2 )
			continue;
		if( cause != "MOD_RIFLE_BULLET" )
			continue;
		
		ratio = self.health / self.maxHealth;
		if( ratio > level.healthOverlayCutoff )
			self setnormalhealth( level.healthOverlayCutoff - 0.005 );
	}
}


playerHealthRegen()
{
	 
	 
	 
	 
	
	
	
	level._healthregen = true;
	
	
	oldratio = 1;
	player = level.player;
	health_add = 0;
	


	lowhealthratio = .33;
	midhealthratio = .66;
	
	
	regenRate = .009;	
	
	waitTime = 0.05;
	veryHurt = false;
	playerJustGotRedFlashing = false;
	
	level.hurtTime = -10000;
	thread playerBreathingSound( level.player.maxHealth * 0.35 );
	invulTime = 0;
	hurtTime = 0;
	newHealth = 0;
	lastinvulratio = 1;
	player thread playerHurtcheck();
	
	player.boltHit = false;
	player thread boltCheck();
	
	if( getdvar( "scr_playerInvulTimeScale" ) == "" )
		setdvar( "scr_playerInvulTimeScale", 1.0 );

	
	
	
	
	player thread blurViewThread();
	player thread saturateViewThread();
	
	for( ;; )
	{
		
		if( !level._healthregen || (getdvarint( "health_regen_enable") == 0))
	
		{
			wait( 0.1 );
			continue;
		}

		wait( waitTime );
		waittillframeend; 
		resettimeout();

		if( player.health == level.player.maxHealth )
		{
			if( flag( "player_has_red_flashing_overlay" ) )
			{
				flag_clear( "player_has_red_flashing_overlay" );
				level notify( "take_cover_done" );
 
			}
			
			lastinvulratio = 1;
			playerJustGotRedFlashing = false;
			veryHurt = false;
			continue;
		}
		
		if( player.health <= 0 )
		{
	
			return;
		}
		
		wasVeryHurt = veryHurt;
		ratio = player.health / level.player.maxHealth;
		if( ratio <= level.healthOverlayCutoff  )
		{
			veryHurt = true;
			if( !wasVeryHurt )
			{
				hurtTime = gettime();
				level.hurtTime = hurtTime;


			}
		}
		
		if( player.hurtAgain )
		{
			hurtTime = gettime();
			player.hurtAgain = false;
		}
		
		if( player.health / player.maxHealth >= oldratio )
		{
			if (oldratio < lowhealthratio)
				waitTime = level.lowRegenPeriod;
			else if (oldratio < midhealthratio)
				waitTime = level.midRegenPeriod;
			else
				waitTime = level.highRegenPeriod;

			if( gettime() - hurttime < level.playerHealth_RegularRegenDelay )
				continue;

			newHealth = ratio;
			if( gettime() > hurtTime + level.longRegenTime )
			{
				
				if( level.player isincover() )
				{
					newHealth += (1.8 * regenRate);	
				}
				else
				{
					newHealth += regenRate;
				}		
			}							
			if( newHealth > 1.0 )
			{
				newHealth = 1.0;
			}			
			else if( newHealth <= 0 )
			{
				 
				return;
			}
			
			 /#
			
			
			#/
			 
			player setnormalhealth( newHealth );
			oldRatio = player.health / player.maxHealth;
			continue;
		}
		
		
		wait(0.05);

		oldratio = lastinvulRatio;
		invulWorthyHealthDrop = oldratio - ratio > level.worthyDamageRatio;

		if( player.health <= 1 )
		{



			 
			 
			player setnormalhealth( 2 / player.maxHealth );
			invulWorthyHealthDrop = true;
		}

		oldRatio = player.health / player.maxHealth;
		level notify( "hit_again" );
			
		health_add = 0;
		hurtTime = gettime();
		level.hurtTime = hurtTime;
		if( !invulWorthyHealthDrop || getdvarfloat( "scr_playerInvulTimeScale" ) <= 0.0 )
		{
	
			continue;
		}
		if( flag( "player_is_invulnerable" ) )
			continue;
		flag_set( "player_is_invulnerable" );
		level notify( "player_becoming_invulnerable" ); 
		
		level.conserveAmmoAgainstInvulPlayer = false;
		level.conserveAmmoAgainstInvulPlayerTime = gettime();
		
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
		
		invulTime *= getdvarfloat( "scr_playerInvulTimeScale" );
		
	
		lastinvulratio = player.health / player.maxHealth;
		thread invulEnd( invulTime );
	}
}

 /#
logHit( newhealth, invulTime )
{
	  
}

logRegen( newhealth )
{
	  
}

showHitLog()
{
	  
}
#/ 

invulEnd( timer )
{
	wait( timer );
	flag_clear( "player_is_invulnerable" );
}

hideInvul( timer )
{
	wait( timer );
	level.hudinvul.alpha = 0;
}

grenadeAwareness()
{
	

	
	self.grenadeawareness = 1.0;
}

computeBlurVal( healthRel )
{
	if( healthRel >= 1 )
	{
		return 0;
	}
	else
	{
		
		
		blurRel = (1-healthRel);
		blurRel = 0.5*blurRel + 0.5*blurRel*blurRel;
		
		return blurRel*3;	
	}
	
}


























saturateViewThread(bool_stop)
{
	wait(.05);
	VisionSetSecondary(0.0, "pain_death");

	if (!IsDefined(self.bool_stop))
	{
		self.bool_stop = true;
	}

	if ((IsDefined(bool_stop)) && (!bool_stop))
	{
		self notify("stop_saturate");
		wait .05;
		VisionSetSecondary(0);
	}
	else
	{
		self endon("stop_saturate");
		while(1)
		{
			if( (self.health/self.maxHealth) < .1)
			{
				
				cur_sat = 0;
				inc_sat = 1 / 30;
				for(i = 0; i < 30; i++)
				{
					VisionSetSecondary(cur_sat);
					cur_sat += inc_sat;
					wait(0.05);
				}
				while( (self.health/self.maxHealth) < .5)
				{
				
				
				
				
				
				
				
				
				
					wait(0.05);
				}
				cur_sat = 0.8;
				inc_sat = 1 / 24;
				for(i = 0; i < 24; i++)
				{
					VisionSetSecondary(cur_sat);
					cur_sat -= inc_sat;
					wait(0.05);
				}
			}
			else
			{
				
				VisionSetSecondary(0);
			}
			wait(0.05);
		}
	}
}

blurViewThread()
{	
	self endon( "death" );	

	setblur( 0, 0 );	

	blurValue = 0;
	while(1)
	{
		self waittill("damage");
		if ( GetDVarInt( "cg_showHurtBlur" )  ) 
		{
			
			setblur( 12, 0.10);
			wait(0.10);
			setblur( 0, 0.10 );
			wait(0.10);
			setblur( 0, 0.10 );
		}

		wait(0.05);
	}
}

playerBreathingSound( healthcap )
{
	wait( 2 );
	player = level.player;
	for( ;; )
	{
		wait( 0.2 );
		if( player.health <= 0 )
			return;
			
		 
		ratio = player.health / level.player.maxHealth;
		if( ratio > level.healthOverlayCutoff )
			continue;
			
		level.player play_sound_on_entity( "breathing_hurt" );
		wait( 0.1 + randomfloat( 0.8 ) );
	}
}

healthOverlay()
{
	
}

add_hudelm_position_internal( alignY )
{
	if( level.xenon )
		self.fontScale = 2;
	else
		self.fontScale = 1.6;
		
	self.x = 0; 
	self.y = -40; 
	self.alignX = "center";
	
	  
		self.alignY = "bottom";	
	 
	
	self.horzAlign = "center";
	self.vertAlign = "middle";
	
	if( !isdefined( self.background ) )
		return;
	self.background.x = 0; 
	self.background.y = -40; 
	self.background.alignX = "center";
	self.background.alignY = "middle";
	self.background.horzAlign = "center";
	self.background.vertAlign = "middle";
	if( level.xenon )
		self.background setshader( "popmenu_bg", 650, 52 );
	else
		self.background setshader( "popmenu_bg", 650, 42 );
	self.background.alpha = .5;
}

create_warning_elem( ender )
{
	level.hudelm_unpause_ender = ender;
	level notify( "hud_elem_interupt" );
	hudelem = newHudElem();
	hudelem add_hudelm_position_internal();
	hudelem thread destroy_warning_elem();
	hudelem setText( &"GAME_GET_TO_COVER" );
	hudelem.fontscale = 2;
	hudelem.alpha = 1;
	hudelem.color = ( 1, 0.9, 0.9 );

	return hudelem;
}

playerWasHitAgain()
{
	level endon( "hit_again" );
	level.player waittill( "damage" );
}


destroy_warning_elem()
{	
	playerWasHitAgain();
	self notify( "death" );
	self destroy();
}


fontScaler( scale, timer )
{
	scale *= 2;
	self endon( "death" );
	dif = scale - self.fontscale;
	dif /= timer * 20;
	for( i = 0;i < timer * 20;i ++ )
	{
		self.fontscale += dif;
		wait( 0.05 );
	}
}

fadeFunc( overlay, coverWarning, severity, mult, hud_scaleOnly )
{
	drawWarning = isdefined( coverWarning );
	pulseTime = 0.8;
	scaleMin = 0.5;
	
	fadeInTime = pulseTime * 0.1;
	stayFullTime = pulseTime * ( .1 + severity * .2 );
	fadeOutHalfTime = pulseTime * ( 0.1 + severity * .1 );
	fadeOutFullTime = pulseTime * 0.3;
	remainingTime = pulseTime - fadeInTime - stayFullTime - fadeOutHalfTime - fadeOutFullTime;
	assert( remainingTime >= -.001 );
	if( remainingTime < 0 )
		remainingTime = 0;
	
	halfAlpha = 0.8 + severity * 0.1;
	leastAlpha = 0.5 + severity * 0.3;
	
	overlay fadeOverTime( fadeInTime );
	overlay.alpha = mult * 1.0;
	if( drawWarning )
	{
		if( !hud_scaleOnly )
		{
			coverWarning fadeOverTime( fadeInTime );
			coverWarning.alpha = mult * 1.0;
		}
		coverWarning thread fontScaler( 1.0, fadeInTime );
	}
	wait fadeInTime + stayFullTime;
	
	overlay fadeOverTime( fadeOutHalfTime );
	overlay.alpha = mult * halfAlpha;
	if( drawWarning )
	{
		if( !hud_scaleOnly )
		{
			coverWarning fadeOverTime( fadeOutHalfTime );
			coverWarning.alpha = mult * halfAlpha;
		}
		coverWarning thread fontScaler( 0.95, fadeOutHalfTime );
	}
	wait fadeOutHalfTime;
	
	overlay fadeOverTime( fadeOutFullTime );
	overlay.alpha = mult * leastAlpha;
	if( drawWarning )
	{
		if( !hud_scaleOnly )
		{
			coverWarning fadeOverTime( fadeOutFullTime );
			coverWarning.alpha = mult * leastAlpha;
		}
		coverWarning thread fontScaler( 0.9, fadeOutFullTime );
	}
	wait fadeOutFullTime;

	wait remainingTime;
}


 
redFlashingOverlay( overlay )
{
	level endon( "hit_again" );
	level.player endon( "damage" );

	drawWarning = false;
	coverWarning = undefined;

	takeCoverWarnings = getdvarint( "takeCoverWarnings" );
	if( takeCoverWarnings > 5 && level.gameskill < 3 )
	{
		 
		coverWarning = create_warning_elem( "take_cover_done" );
		drawWarning = true;
	}

	  
	
	 
	 
	
	stopFlashingBadlyTime = gettime() + level.longRegenTime;
	
	fadeFunc( overlay, coverWarning,  1,   1, false );
	while( gettime() < stopFlashingBadlyTime )
		fadeFunc( overlay, coverWarning, .9,   1, false );
	fadeFunc( overlay, coverWarning, .65, 0.8, false );
	
	if( drawWarning )
	{
		coverWarning fadeOverTime( 0.5 );
		coverWarning.alpha = 0;
	}
	fadeFunc( overlay, coverWarning,  0, 0.6, true );
 

	overlay fadeOverTime( 0.5 );
	overlay.alpha = 0;
	
	if( getdvarint( "takeCoverWarnings" ) > 2 )
	{
		if( isalive( level.player ) )
		{
			takeCoverWarnings = getdvarint( "takeCoverWarnings" );
			takeCoverWarnings -- ;
			setdvar( "takeCoverWarnings", takeCoverWarnings );
		}
	}
		
	flag_clear( "player_has_red_flashing_overlay" );
	level.player thread play_sound_on_entity( "breathing_better" );


	wait( 0.5 ); 
	level notify( "take_cover_done" );
	level notify( "hit_again" );
}

healthOverlay_remove( overlay )
{
	level.player waittill( "noHealthOverlay" );
	overlay destroy();
}

resetSkill()
{
	setskill( true );
}

setTakeCoverWarnings()
{
	 
	if( getdvarint( "takeCoverWarnings" ) == -1 ) 
	{
 		if( level.script != "moscow" )
			setdvar( "takeCoverWarnings", 5 );
		else
			setdvar( "takeCoverWarnings", 10 );
	}
}

increment_take_cover_warnings_on_death()
{
	level notify( "new_cover_on_death_thread" );	
	level endon( "new_cover_on_death_thread" );	
	level.player waittill( "death" );
	
	 
	if( !flag( "player_has_red_flashing_overlay" ) )
		return;
		
	warnings = getdvarint( "takeCoverWarnings" );
	if( warnings < 10 )
		setdvar( "takeCoverWarnings", warnings + 1 );
}

auto_adjust_difficulty()
{
	thread auto_adjust_difficulty_track_player_shots();
	thread auto_adjust_difficulty_track_player_death();
	thread auto_adjust_difficulty_player_movement_check();
	level.timeBetweenShots = 0;
	level.debugLeft = 15;
	level.debugHeight = 110;
	
	hud = newHudElem();
	  
	currentTime = gettime();
	bounceNum = 20;
		
	for( ;; )
	{
		 
		if( level.timeBetweenShots > 10000 )
		{
			wait( 0.5 );
			auto_adjust_difficulty_debug();
			continue;
		}

		if( !level.player.movedRecently )
		{
			wait( 0.05 );
			auto_adjust_difficulty_debug();
			continue;
		}
		
		 
		if( gettime() - level.lastPlayerSighted > 5000 )
		{
			wait( 0.05 );
			continue;
		}

		level.difficulty_spot = level.player.origin;		
		difFrac = getdvarint( "autodifficulty_playerDeathTimer" );
		difFrac ++ ;
		
		if( difFrac > 90 )
			difFrac = 90;
		else
		if( difFrac < - 90 )
			difFrac = -90;
			
		difficultyMod = 0;
		 
		for( i = bounceNum; i < difFrac; i += bounceNum )
			difficultyMod ++ ;
		for( i = bounceNum * - 1; i > difFrac; i -= bounceNum )
			difficultyMod -- ;
		
		gameDifficultyFrac = getdvarint( "autodifficulty_frac" );
		gameDifficultyFrac += difficultyMod;
		gameSkill = getdvarint( "level_gameskill" );
		
		 
		if( gameSkill >= 2 && gameDifficultyFrac > 50 )
			gameDifficultyFrac = 50;
			
		if( gameDifficultyFrac > 100 )
		{
			if( gameSkill < 2 )
			{
				gameSkill ++ ;
				setdvar( "level_gameskill", gameSkill );
				setCurrentDifficulty();
				gameDifficultyFrac = 0;
			}
			
			setDifficultyStepValues();
		}
		
		if( gameDifficultyFrac < 0 )
		{
			gameSkill -- ;
			if( gameSkill < 0 )
				gameSkill = 0;
			setdvar( "level_gameskill", gameSkill );
			setCurrentDifficulty();
			
			gameDifficultyFrac = 100;
			setDifficultyStepValues();
		}
		
		setdvar( "level_gameskill", gameSkill );

 
		
		setdvar( "autodifficulty_frac", gameDifficultyFrac );
		waittillframeend; 
		setDifficultyFractionalValues();
		 
		
		setdvar( "autodifficulty_playerDeathTimer", difFrac );
		wait( 1 );
	}
}

auto_adjust_difficulty_player_positioner()
{
	org = level.player.origin;
 
	wait( 5 );
	if( autospot_is_close_to_player( org ) )
		level.autoAdjust_playerSpots[ level.autoAdjust_playerSpots.size ] = org;
}

autospot_is_close_to_player( org )
{
	return distance( level.player.origin, org ) < 140;
}


auto_adjust_difficulty_player_movement_check()
{
	level.autoAdjust_playerSpots = [];
	level.player.movedRecently = true;
	wait( 1 ); 
	
	for( ;; )
	{
		thread auto_adjust_difficulty_player_positioner();
		level.player.movedRecently = true;
		newSpots = [];
		start = level.autoAdjust_playerSpots.size - 5;
		if( start < 0 )
			start = 0;
			
		for( i = start; i < level.autoAdjust_playerSpots.size;i ++ )
		{
			if( !autospot_is_close_to_player( level.autoAdjust_playerSpots[ i ] ) )
				continue;
				
			newSpots[ newSpots.size ] = level.autoAdjust_playerSpots[ i ];
			level.player.movedRecently = false;
		 
		}
		
		level.autoAdjust_playerSpots = newSpots;
		
		wait( 1 );
	}
}


auto_adjust_difficulty_track_player_death()
{
	 
	level.player waittill( "death" );
	num = getdvarint( "autodifficulty_playerDeathTimer" );
	num -= 60;
	setdvar( "autodifficulty_playerDeathTimer", num );
 
}


auto_adjust_difficulty_track_player_shots()
{
	 
	lastShotTime = gettime();
	for( ;; )
	{
		if( level.player attackButtonPressed() )
			lastShotTime = gettime();
			
		level.timeBetweenShots = gettime() - lastShotTime;
		wait( 0.05 );
		  
	}
}

auto_adjust_difficulty_debug()
{
	if( 1 ) return;
	hud_debug_clear();
	hud_debug_add( "DeathTimer: " , getdvarint( "autodifficulty_playerDeathTimer" ) );
	hud_debug_add( "Time between shots: " , level.timeBetweenShots * 0.001 );
	
	hud_debug_add_string( "Gameskill: ", level.difficultyString[ getdvar( "currentDifficulty" ) ] );
	hud_debug_add( "GameDifficultyFrac: ", getdvarint( "autodifficulty_frac" ) );

	hud_debug_add_frac( "Damage multiplier: ", getdvarfloat( "player_DamageMultiplier" ) );
	hud_debug_add( "Resulting health: ", int( 100 / getdvarfloat( "player_DamageMultiplier" ) ) );
 
	
 
 
	hud_debug_add_frac( "invulTime_preShield: " , level.invulTime_preShield );
	hud_debug_add_frac( "invulTime_onShield: " , level.invulTime_onShield );
	hud_debug_add_frac( "invulTime_postShield: " , level.invulTime_postShield );
	hud_debug_add( "playerHealth_RegularRegenDelay: " , level.playerHealth_RegularRegenDelay );
	hud_debug_add_frac( "worthyDamageRatio: " , level.worthyDamageRatio );
	hud_debug_add( "threatbias: " , level.player.threatbias );
	hud_debug_add( "longRegenTime: " , level.longRegenTime );
	hud_debug_add_frac( "healthOverlayCutoff: " , level.healthOverlayCutoff );
	hud_debug_add_frac( "difficultyBasedAccuracy: " , anim.difficultyBasedAccuracy );
	hud_debug_add( "playerGrenadeBaseTime: " , anim.playerGrenadeBaseTime );
	hud_debug_add( "playerGrenadeRangeTime: " , anim.playerGrenadeRangeTime );
	hud_debug_add( "minimumBoltPlayerProtectionTime: " , anim.minimumBoltPlayerProtectionTime );

	hud_debug_add( "player_deathInvulnerableTime: " , getdvarint( "player_deathInvulnerableTime" ) );
	
}

hud_debug_add_frac( msg, num )
{
	hud_debug_add_display( msg, num * 100, true );
}

hud_debug_add( msg, num )
{
	hud_debug_add_display( msg, num, false );
}

hud_debug_clear()
{
	level.hudNum = 0;
	if( isdefined( level.hudDebugNum ) )
	{
		for( i = 0;i < level.hudDebugNum.size;i ++ )
			level.hudDebugNum[ i ] destroy();	
	}
	
	level.hudDebugNum = [];
}

hud_debug_add_message( msg )
{
	if( !isdefined( level.hudMsgShare ) )
		level.hudMsgShare = [];
	if( !isdefined( level.hudMsgShare[ msg ] ) )
	{
		hud = newHudElem();
		hud.x = level.debugLeft;
		hud.y = level.debugHeight + level.hudNum * 15;
		hud.foreground = 1;
		hud.sort = 100;
		hud.alpha = 1.0;
		hud.alignX = "left";
		hud.horzAlign = "left";
		hud.fontScale = 1.0;
		hud setText( msg );
		level.hudMsgShare[ msg ] = true;
	}
}

hud_debug_add_display( msg, num, isfloat )
{
	hud_debug_add_message( msg );
			
	num = int( num );
	negative = false;
	if( num < 0 )
	{
		negative = true;
		num *= -1;
	}

	thousands = 0;
	hundreds = 0;
	tens = 0;
	ones = 0;
	while( num >= 10000 )
		num -= 10000;
	
	while( num >= 1000 )
	{
		num -= 1000;
		thousands ++ ;
	}
	while( num >= 100 )
	{
		num -= 100;
		hundreds ++ ;
	}
	while( num >= 10 )
	{
		num -= 10;
		tens ++ ;
	}
	while( num >= 1 )
	{
		num -= 1;
		ones ++ ;
	}
	
	offset = 0;
	offsetSize = 10;
	if( thousands > 0 )
	{
		hud_debug_add_num( thousands, offset );
		offset += offsetSize;
		hud_debug_add_num( hundreds, offset );
		offset += offsetSize;
		hud_debug_add_num( tens, offset );
		offset += offsetSize;
		hud_debug_add_num( ones, offset );
		offset += offsetSize;
	}
	else
	if( hundreds > 0 || isFloat )
	{
		hud_debug_add_num( hundreds, offset );
		offset += offsetSize;
		hud_debug_add_num( tens, offset );
		offset += offsetSize;
		hud_debug_add_num( ones, offset );
		offset += offsetSize;
	}
	else
	if( tens > 0 )
	{
		hud_debug_add_num( tens, offset );
		offset += offsetSize;
		hud_debug_add_num( ones, offset );
		offset += offsetSize;
	}
	else
	{
		hud_debug_add_num( ones, offset );
		offset += offsetSize;
	}

	if( isFloat )
	{
		decimalHud = newHudElem();
		decimalHud.x = 204.5;
		decimalHud.y = level.debugHeight + level.hudNum * 15;
		decimalHud.foreground = 1;
		decimalHud.sort = 100;
		decimalHud.alpha = 1.0;
		decimalHud.alignX = "left";
		decimalHud.horzAlign = "left";
		decimalHud.fontScale = 1.0;
		decimalHud setText( "." );
		level.hudDebugNum[ level.hudDebugNum.size ] = decimalHud;
	}

	if( negative )
	{
		negativeHud = newHudElem();
		negativeHud.x = 195.5;
		negativeHud.y = level.debugHeight + level.hudNum * 15;
		negativeHud.foreground = 1;
		negativeHud.sort = 100;
		negativeHud.alpha = 1.0;
		negativeHud.alignX = "left";
		negativeHud.horzAlign = "left";
		negativeHud.fontScale = 1.0;
		negativeHud setText( " - " );
		level.hudDebugNum[ level.hudNum ] = negativeHud;
	}
	
 
	level.hudNum ++ ;
}

hud_debug_add_string( msg, msg2 )
{
	hud_debug_add_message( msg );
	hud_debug_add_second_string( msg2, 0 );
	level.hudNum ++ ;
}

hud_debug_add_num( num, offset )
{
	hud = newHudElem();
	hud.x = 200 + offset * 0.65;
	hud.y = level.debugHeight + level.hudNum * 15;
	hud.foreground = 1;
	hud.sort = 100;
	hud.alpha = 1.0;
	hud.alignX = "left";
	hud.horzAlign = "left";
	hud.fontScale = 1.0;
	hud setText( num + "" );
	level.hudDebugNum[ level.hudDebugNum.size ] = hud;
}

hud_debug_add_second_string( num, offset )
{
	hud = newHudElem();
	hud.x = 200 + offset * 0.65;
	hud.y = level.debugHeight + level.hudNum * 15;
	hud.foreground = 1;
	hud.sort = 100;
	hud.alpha = 1.0;
	hud.alignX = "left";
	hud.horzAlign = "left";
	hud.fontScale = 1.0;
	hud setText( num );
	level.hudDebugNum[ level.hudDebugNum.size ] = hud;
}

setCurrentDifficulty()
{
	setdvar( "currentDifficulty", level.difficultyType[ getdvarint( "level_gameskill" ) ] );
 
}
