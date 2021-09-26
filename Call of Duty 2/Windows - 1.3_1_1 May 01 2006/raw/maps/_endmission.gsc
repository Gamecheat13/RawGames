main()
{
	missionSettings = [];

	// levels and missions are listed in order of recommended playthrough
	missionIndex = 0; // (Moscow)
	missionSettings[missionIndex] = createMission( 0, "movie_eastern", "veteran_of_the_winter_war" );
	missionSettings[missionIndex] addLevel( "moscow", false, "completed_training" );
	missionSettings[missionIndex] addLevel( "demolition", false );
	
	missionIndex = 1; // (Not One Step Backwards)
	missionSettings[missionIndex] = createMission( 2, "slideshow_earlygrad", "veteran_not_one_step_backwards" );
	missionSettings[missionIndex] addPreReq( 0 ); // (Moscow)
	missionSettings[missionIndex] addLevel( "tankhunt", true );
	missionSettings[missionIndex] addLevel( "trainyard", false );

	missionIndex = 2; // (Fortress Stalingrad)
	missionSettings[missionIndex] = createMission( 3, "slideshow_lategrad", "veteran_fortress_stalingrad" );
	missionSettings[missionIndex] addPreReq( 1 ); // (Not One Step Backwards)
	missionSettings[missionIndex] addLevel( "downtown_assault", true );
	missionSettings[missionIndex] addLevel( "cityhall", true );
	missionSettings[missionIndex] addLevel( "downtown_sniper", false );

	missionIndex = 3; // (Egypt)
	missionSettings[missionIndex] = createMission( 1, "movie_africa", "veteran_el_alamein", "british_unlocked" );
	missionSettings[missionIndex] addPreReq( 0 ); // (Moscow)
	missionSettings[missionIndex] addLevel( "decoytrenches", true );
	missionSettings[missionIndex] addLevel( "decoytown", false );
	missionSettings[missionIndex] addLevel( "elalamein", false );
	missionSettings[missionIndex] addLevel( "eldaba", false );

	missionIndex = 4; // (Libya)
	missionSettings[missionIndex] = createMission( 4, "slideshow_libya", "veteran_tank_squadrons" );
	missionSettings[missionIndex] addPreReq( 3 ); // (Egypt)
	missionSettings[missionIndex] addPreReq( 1 ); // (Not One Step Backwards)
	missionSettings[missionIndex] addLevel( "libya", false );
	missionSettings[missionIndex] addLevel( "88ridge", false );

	missionIndex = 5; // (Tunisia)
	missionSettings[missionIndex] = createMission( 5, "slideshow_tunisia", "veteran_rommel" );
	missionSettings[missionIndex] addPreReq( 3 ); // (Egypt)
	missionSettings[missionIndex] addLevel( "toujane_ride", true );
	missionSettings[missionIndex] addLevel( "toujane", false );
	missionSettings[missionIndex] addLevel( "matmata", false );

	missionIndex = 6; // (D-Day)
	missionSettings[missionIndex] = createMission( 6, "movie_europe", "veteran_d_day", "american_unlocked" );
	missionSettings[missionIndex] addPreReq( 2 ); // (Fortress Stalingrad)
	missionSettings[missionIndex] addPreReq( 4 ); // (Libya)
	missionSettings[missionIndex] addPreReq( 5 ); // (Tunisia)
	missionSettings[missionIndex] addLevel( "duhoc_assault", true );
	missionSettings[missionIndex] addLevel( "duhoc_defend", false );
	missionSettings[missionIndex] addLevel( "silotown_assault", false );

	missionIndex = 7; // (Caen)
	missionSettings[missionIndex] = createMission( 7, "slideshow_caen", "veteran_caen" );
	missionSettings[missionIndex] addPreReq( 5 ); // (Tunisia)
	missionSettings[missionIndex] addLevel( "beltot", false );
	missionSettings[missionIndex] addLevel( "crossroads", false );
	missionSettings[missionIndex] addLevel( "newvillers", true );
	missionSettings[missionIndex] addLevel( "breakout", false );

	missionIndex = 8; // (Hill 400)
	missionSettings[missionIndex] = createMission( 8, "slideshow_bergstein", "veteran_hill400" );
	missionSettings[missionIndex] addPreReq( 6 ); // (Caen)
	missionSettings[missionIndex] addPreReq( 7 ); // (D-Day)
	missionSettings[missionIndex] addLevel( "bergstein", true );
	missionSettings[missionIndex] addLevel( "hill400_assault", false );
	missionSettings[missionIndex] addLevel( "hill400_defend", false );

	missionIndex = 9; // (Rhine)
	missionSettings[missionIndex] = createMission( 9, "slideshow_rhine", "veteran_crossing_the_rhine" );
	missionSettings[missionIndex] addPreReq( 8 ); // (Hill 400)
	missionSettings[missionIndex] addLevel( "rhine", false );

	level.missionSettings = missionSettings;
}


nextmission()
{
	missionIndex = undefined;
	levelIndex = undefined;
	
	setSavedCvar( "ui_nextMission", "1");
	setCvar( "ui_showPopup", "0");
	setCvar( "ui_popupString", "");
	
	for ( index = 0; index < level.missionSettings.size; index++ )
	{
		levelIndex = level.missionSettings[index] getLevelIndex( level.script );
		
		if ( !isDefined( levelIndex ) )
			continue;
			
		missionIndex = index;
		break;
	}
	
	// level is not part of any mission
	if ( !isDefined( missionIndex ) )
		return;
		
	maps\_utility::levelEndSave();

	// update mission difficult dvar
	level.missionSettings[missionIndex] setLevelCompleted( levelIndex );
	
	if ( level.missionSettings[missionIndex] hasAchievement( levelIndex ) )
		giveachievement( level.missionSettings[missionIndex] getAchievement( levelIndex ) );
	
	if ( level.missionSettings[missionIndex] hasVeteranAward() && 
		level.missionSettings[missionIndex] getLowestSkill() > 3 )
		giveachievement( level.missionSettings[missionIndex] getVeteranAward() );

	// last level in mission
	if ( (levelIndex + 1) == level.missionSettings[missionIndex].levels.size )
	{
		level.missionSettings[missionIndex] updateMissionDvar( levelIndex );

		setSavedCvar( "ui_nextMission", "0");
		
		popupString = unlockMissions();

		switch( missionIndex )
		{
			case 2:
				if ( popupString != "" )
					popupString += "_";
					
				popupString += "russian_completed";
				break;
			case 4:
			case 7:
				if ( level.missionSettings[4] getLowestSkill() && 
					level.missionSettings[7] getLowestSkill() )
					popupString += "british_completed";
				break;
			case 9:
				setSavedCvar( "ui_nextMission", "2");

				if ( allMissionsCompleted( 0 ) )
					giveAchievement( "won_the_war" );

				if ( allMissionsCompleted( 2 ) )
					giveAchievement( "war_hardened" );

				cinematic( "movie_victory", 2);
				missionSuccess( "credits", false );
				return;
			default:
				break;
		}
		
		if ( popupString.size )
		{
			setCvar( "ui_showPopup", "1" );
			setCvar( "ui_popupString", popupString );
		}
		
		nextMissionIndex = getNextMissionIndex( missionIndex );
		nextLevelIndex = level.missionSettings[nextMissionIndex] getNextLevelIndex();
	}
	else
	{
		nextMissionIndex = missionIndex;
		nextLevelIndex = levelIndex + 1;

		level.missionSettings[nextMissionIndex] updateMissionDvar( nextLevelIndex );
	}

	if ( allMissionsCompleted( 0 ) )
		giveAchievement( "won_the_war" );

	if ( allMissionsCompleted( 2 ) )
		giveAchievement( "war_hardened" );

	if ( !nextLevelIndex )
	{
		game["expectedlevel"] = "";
		missionSuccess( level.missionSettings[nextMissionIndex] getSlideShow(), false );
	}
	else
	{
		game["expectedlevel"] = level.missionSettings[nextMissionIndex] getLevelName( nextLevelIndex );
		missionSuccess( level.missionSettings[nextMissionIndex] getLevelName( nextLevelIndex ), level.missionSettings[missionIndex] getKeepWeapons( levelIndex ) );
	}
}


allMissionsCompleted( difficulty )
{
	difficulty += 10;
	for ( index = 0; index < level.missionSettings.size; index++ )
	{
		missionDvar = getMissionDvarString( index );
		if ( getCvarInt( missionDvar ) < difficulty )
			return ( false );
	}
	return ( true );
}


setLevelCompleted( levelIndex )
{
	levelOffset = (self.offset * 5) + levelIndex;
	
	missionString = getCvar( "mis_difficulty" );
	
	if ( int( missionString[levelOffset] ) > getCvarInt( "g_gameskill" ) )
		return;
		
	newString = "";
	for ( index = 0; index < missionString.size; index++ )
	{
		if ( index != levelOffset )
			newString += missionString[index];
		else
			newString += int( getCvar( "g_gameSkill" ) ) + 1;
	}
	setMissionCvar( "mis_difficulty", newString);	
}


getLevelSkill( levelIndex )
{
	levelOffset = (self.offset * 5) + levelIndex;
	
	missionString = getCvar( "mis_difficulty" );
	return ( int ( missionString[levelOffset] ) );
}


updateMissionDvar( levelIndex )
{
	missionDvar = getMissionDvarString( self.offset );
		
	lowestSkill = self getLowestSkill();

	if ( lowestSkill )
		setMissionCvar( missionDvar, (lowestSkill + 9) );
	else if ( levelIndex + 1 > getCvarInt( missionDvar ) )
		setMissionCvar( missionDvar, levelIndex + 1 );
}


getMissionDvarString( missionIndex )
{
	if ( missionIndex < 9 )
		return ( "mis_0" + (missionIndex + 1) );
	else
		return ( "mis_" + (missionIndex + 1) );
}


getLowestSkill()
{
	missionOffset = (self.offset * 5);
	
	missionString = getCvar( "mis_difficulty" );

	lowestSkill = 4;
		
	for ( index = 0; index < self.levels.size; index++ )
	{
		if ( int( missionString[missionOffset+index] ) < lowestSkill )
			lowestSkill = int( missionString[missionOffset+index] );
	}
	
	return ( lowestSkill );
}


createMission( missionOffset, slideShow, veteranAward, unlockString )
{
	mission = spawnStruct();
	mission.levels = [];
	mission.prereqs = [];
	mission.slideShow = slideShow;
	mission.offset = missionOffset;
	mission.veteranAward = veteranAward;
	mission.unlockString = unlockString;
	return ( mission );
}


addLevel( levelName, keepWeapons, achievement )
{
	levelIndex = self.levels.size;
	self.levels[levelIndex] = spawnStruct();
	self.levels[levelIndex].name = levelName;
	self.levels[levelIndex].keepWeapons = keepWeapons;
	self.levels[levelIndex].achievement = achievement;
}

addPreReq( missionIndex )
{
	preReqIndex = self.prereqs.size;
	self.prereqs[preReqIndex] = missionIndex;
}

getLevelIndex( levelName )
{
	for ( levelIndex = 0; levelIndex < self.levels.size; levelIndex++ )
	{
		if ( self.levels[levelIndex].name != levelName )
			continue;
			
		return ( levelIndex );
	}
	
	return ( undefined );
}


getSlideShow()
{
	return ( self.slideShow );
}


getLevelName( levelIndex )
{
	return ( self.levels[levelIndex].name );
}


getKeepWeapons( levelIndex )
{
	return ( self.levels[levelIndex].keepWeapons );
}


getAchievement( levelIndex )
{
	return ( self.levels[levelIndex].achievement );
}


hasAchievement( levelIndex )
{
	if ( isDefined( self.levels[levelIndex].achievement ) )
		return ( true );
	else
		return ( false );
}


getVeteranAward()
{
	return ( self.veteranAward );
}


hasVeteranAward()
{
	if ( isDefined( self.veteranAward ) )
		return ( true );
	else
		return ( false );
}


isUnlocked()
{
	missionDvar = getMissionDvarString( self.offset );

	if ( getCvarInt( missionDvar ) == 0 )
		return ( false );	
	else
		return ( true );
}


getNextMissionIndex( missionIndex )
{
	if ( level.missionSettings[missionIndex+1] isUnlocked() && 
		!level.missionSettings[missionIndex+1] getLevelSkill( 0 ) )
	{
		return ( missionIndex + 1 );
	}

	for ( index = 0; index < level.missionSettings.size; index++ )
	{
		if ( level.missionSettings[index] getLowestSkill() )
			continue;
		
		return ( index );
	}
	return ( missionIndex + 1 );
}


getNextLevelIndex()
{
	for ( index = 0; index < self.levels.size; index++ )
	{
		if ( !self getLevelSkill( index ) )
			return ( index );
	}
	return ( 0 );
}


unlockMissions()
{
	unlockString = "";
	for ( index = 0; index  < level.missionSettings.size; index++ )
	{
		if ( level.missionSettings[index] isUnlocked() )
			continue;
		
		if ( level.missionSettings[index] canUnlock() )
		{
			level.missionSettings[index] updateMissionDvar( 0 );
			
			if ( isDefined ( level.missionSettings[index].unlockString ) )
				unlockString += level.missionSettings[index].unlockString;
		}
	}
	return ( unlockString );
}


canUnlock()
{
	for ( preReqIndex = 0; preReqIndex < self.prereqs.size; preReqIndex++ )
	{
		if ( !level.missionSettings[self.prereqs[preReqIndex]] getLowestSkill() )
			return ( false );
	}
	return ( true );
}
