#include maps\_utility; 
#include common_scripts\utility; 

init()
{
	level.musicPackages = [];
	level.activeMusicPackage = "";
	level.activeMusicStage = "";
	level.activeMusicSlot = 0;
}


declareMusicPackage( package, alias, delay, fadeIn, fadeOut )
{
	if ( isdefined( level.musicPackages[package] ) )
	{
		return;
	}

	level.musicPackages[package] = spawnStruct();
	level.musicPackages[package].stages = [];

	level.musicPackages[package].stages["base"] = spawnStruct();
	level.musicPackages[package].stages["base"].musicAlias = alias;
	level.musicPackages[package].stages["base"].musicDelay = delay;
	level.musicPackages[package].stages["base"].musicFadeIn = fadeIn;
	level.musicPackages[package].stages["base"].musicFadeOut = fadeOut;
}


setMusicPackageIntro( package, alias )
{
	if ( !isdefined( level.musicPackages[package] ) )
	{
		assertmsg( "setMusicPackageIntro: must declare music package \"" + package + "\" in level_snd main before it can have its intro set" );
		return;
	}

	level.musicPackages[package].stages["base"].introAlias = alias;
}


setMusicPackageOutro( package, alias )
{
	if ( !isdefined( level.musicPackages[package] ) )
	{
		assertmsg( "setMusicPackageOutro: must declare music package \"" + package + "\" in level_snd main before it can have its outro set" );
		return;
	}

	level.musicPackages[package].stages["base"].outroAlias = alias;
}


setMusicPackageCrossfade( package, alias )
{
	if ( !isdefined( level.musicPackages[package] ) )
	{
		assertmsg( "setMusicPackageCrossfade: must declare music package \"" + package + "\" in level_snd main before it can have its crossfade set" );
		return;
	}

	level.musicPackages[package].stages["base"].crossfadeAlias = alias;
}


setMusicPackageCombatAlias( package, alertNumStart, alertNumEnd, alias, delay, fadeIn, fadeOut )
{
	if ( !isdefined( level.musicPackages[package] ) )
	{
		assertmsg( "setMusicPackageCrossfade: must declare music package \"" + package + "\" in level_snd main before it can have its combat alias set" );
		return;
	}

	level.musicPackages[package].stages["combat"] = spawnStruct();
	level.musicPackages[package].stages["combat"].combatMusicAlertNumStart = alertNumStart;
	level.musicPackages[package].stages["combat"].combatMusicAlertNumEnd = alertNumEnd;
	level.musicPackages[package].stages["combat"].musicAlias = alias;
	level.musicPackages[package].stages["combat"].musicDelay = delay;
	level.musicPackages[package].stages["combat"].musicFadeIn = fadeIn;
	level.musicPackages[package].stages["combat"].musicFadeOut = fadeOut;
}


setMusicPackageCombatIntro( package, alias )
{
	if ( !isdefined( level.musicPackages[package] ) || !isdefined( level.musicPackages[package].stages["combat"] ) )
	{
		assertmsg( "setMusicPackageCombatIntro: must declare music package \"" + package + "\" in level_snd main (as well as a combat alias) before it can have its combat intro set" );
		return;
	}

	level.musicPackages[package].stages["combat"].introAlias = alias;
}


setMusicPackageCombatOutro( package, alias )
{
	if ( !isdefined( level.musicPackages[package] ) || !isdefined( level.musicPackages[package].stages["combat"] ) )
	{
		assertmsg( "setMusicPackageCombatOutro: must declare music package \"" + package + "\" in level_snd main (as well as a combat alias) before it can have its combat outro set" );
		return;
	}

	level.musicPackages[package].stages["combat"].outroAlias = alias;
}


setMusicPackageCombatCrossfade( package, alias )
{
	if ( !isdefined( level.musicPackages[package] ) || !isdefined( level.musicPackages[package].stages["combat"] ) )
	{
		assertmsg( "setMusicPackageCombatCrossfade: must declare music package \"" + package + "\" in level_snd main (as well as a combat alias) before it can have its combat crossfade set" );
		return;
	}

	level.musicPackages[package].stages["combat"].crossfadeAlias = alias;
}


getAlertCount()
{
	redCount = 0;

	enemies = getaiarray( "axis", "neutral" );
	for ( i = 0; i < enemies.size; i++ )
	{
		if ( enemies[i] GetAlertState() == "alert_red" )
		{
			redCount++;
		}
	}
	
	return redCount;
}


musicPackageCombatListener()
{
	self endon( "killMusicPackageCombatListener" );
	
	for ( ;; )
	{
		for ( ;; )
		{
			wait 0.5;

			if ( self.stages["combat"].combatMusicAlertNumStart > getAlertCount() )
			{
				continue;
			}

			wait 1.5; 

			if ( self.stages["combat"].combatMusicAlertNumStart <= getAlertCount() )
			{
				break;
			}
		}

		startMusicPackage( level.activeMusicPackage, "combat" );

		wait 7;

		for ( ;; )
		{
			wait 3;

			if ( self.stages["combat"].combatMusicAlertNumEnd < getAlertCount() )
			{
				continue;
			}

			wait 2; 

			if ( self.stages["combat"].combatMusicAlertNumEnd >= getAlertCount() )
			{
				break;
			}
		}

		startMusicPackage( level.activeMusicPackage, "base" );

		wait 7;
	}
}


stopMusicPackageInternal( crossfade )
{
	if ( !isdefined( crossfade ) )
	{
		crossfade = false;
	}

	if ( "" == level.activeMusicPackage )
	{
		return;
	}
		
	if ( !crossfade )
	{
		level.musicPackages[level.activeMusicPackage] notify( "killMusicPackageCombatListener" );
	}

	
	currStageInfo = level.musicPackages[level.activeMusicPackage].stages[level.activeMusicStage];
	if (isdefined( currStageInfo.musicFadeOut ))
	{
		musicstop( level.activeMusicSlot, currStageInfo.musicFadeOut );
	}
	else
	{
		musicstop( level.activeMusicSlot, 0.0 );
	}
	
	if ( crossfade && isdefined( currStageInfo.crossfadeAlias ) )
	{
		level.player playsound( currStageInfo.crossfadeAlias );
	}
	else if ( isdefined( currStageInfo.outroAlias ) )
	{
		level.player playsound( currStageInfo.outroAlias );
	}

	level.activeMusicSlot++;
	if ( 2 <= level.activeMusicSlot )
	{
		level.activeMusicSlot = 0;
	}

	level.activeMusicPackage = "";
	level.activeMusicStage = "";
}


startMusicPackage( package, stage )
{
	if ( !isdefined( stage ) )
	{
		stage = "base";
	}

	if ( package == level.activeMusicPackage && stage == level.activeMusicStage )
	{
		return;
	}

	packageChanged = (level.activeMusicPackage != package);
	if ( packageChanged && "" != level.activeMusicPackage)
	{
		level.musicPackages[level.activeMusicPackage] notify( "killMusicPackageCombatListener" );
	}

	stopMusicPackageInternal( true );

	if ( "" == package )
	{
		return;
	}

	level.activeMusicPackage = package;
	level.activeMusicStage = stage;
	currStageInfo = level.musicPackages[level.activeMusicPackage].stages[level.activeMusicStage];
	
	if ( packageChanged && isdefined( level.musicPackages[level.activeMusicPackage].stages["combat"] ) )
	{
		level.musicPackages[level.activeMusicPackage] thread musicPackageCombatListener();
	}

	if ( isdefined( currStageInfo.introAlias ) )
	{
		level.player playsound( currStageInfo.introAlias );
	}

	if ( currStageInfo.musicDelay )
	{
		wait currStageInfo.musicDelay;
	}
	musicplay( currStageInfo.musicAlias, level.activeMusicSlot, currStageInfo.musicFadeIn );
}


stopMusicPackage()
{
	stopMusicPackageInternal( false );
}


runStartMusicPackageListener( notifyname, package )
{
	for ( ;; )
	{
		self waittill( notifyname );
		startMusicPackage( package );
	}
}


runStopMusicPackageListener( notifyname )
{
	for ( ;; )
	{
		self waittill( notifyname );
		stopMusicPackage();
	}
}
