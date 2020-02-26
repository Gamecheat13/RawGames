main()
{
	missionSettings = [];

	// levels and missions are listed in order of recommended playthrough
//	missionSettings[missionIndex] = createMission( missionOffset, "sideshow level name", "360 achievement string" );
//	missionSettings[missionIndex] addPreReq( vignette );
//	missionSettings[missionIndex] addLevel( "levelname", keepweapons, "optional achievement string" );

	level.missionSettings = missionSettings;
}


nextmission()
{
	missionIndex = undefined;
	levelIndex = undefined;
	
	setsaveddvar( "ui_nextMission", "1");
	setdvar( "ui_showPopup", "0");
	setdvar( "ui_popupString", "");
	
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
		
	maps\_utility::level_end_save();

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

		setsaveddvar( "ui_nextMission", "0");
		
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
				setsaveddvar( "ui_nextMission", "2");

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
			setdvar( "ui_showPopup", "1" );
			setdvar( "ui_popupString", popupString );
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
		if ( getdvarInt( missionDvar ) < difficulty )
			return ( false );
	}
	return ( true );
}


setLevelCompleted( levelIndex )
{
	levelOffset = (self.offset * 5) + levelIndex;
	
	missionString = getdvar( "mis_difficulty" );
	
	if ( int( missionString[levelOffset] ) > getdvarInt( "g_gameskill" ) )
		return;
		
	newString = "";
	for ( index = 0; index < missionString.size; index++ )
	{
		if ( index != levelOffset )
			newString += missionString[index];
		else
			newString += int( getdvar( "g_gameSkill" ) ) + 1;
	}
	setMissionDvar( "mis_difficulty", newString);	
}


getLevelSkill( levelIndex )
{
	levelOffset = (self.offset * 5) + levelIndex;
	
	missionString = getdvar( "mis_difficulty" );
	return ( int ( missionString[levelOffset] ) );
}


updateMissionDvar( levelIndex )
{
	missionDvar = getMissionDvarString( self.offset );
		
	lowestSkill = self getLowestSkill();

	if ( lowestSkill )
		setMissionDvar( missionDvar, (lowestSkill + 9) );
	else if ( levelIndex + 1 > getdvarInt( missionDvar ) )
		setMissionDvar( missionDvar, levelIndex + 1 );
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
	
	missionString = getdvar( "mis_difficulty" );

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

	if ( getdvarInt( missionDvar ) == 0 )
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
