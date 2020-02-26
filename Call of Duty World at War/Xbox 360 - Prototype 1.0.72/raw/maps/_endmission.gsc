main()
{
	missionSettings = []; 

	// levels and missions are listed in order of recommended playthrough
//	missionSettings[missionIndex] = createMission( missionOffset, "sideshow level name", "360 achievement string" ); 
//	missionSettings[missionIndex] addPreReq( vignette ); 
//	missionSettings[missionIndex] addLevel( "levelname", keepweapons, "optional achievement string" ); 

	////////// DPG - test 
	missionSettings[0] = createMission( 1, "new mission", "optional achievement string" ); 
	missionSettings[0] addPreReq( 0 ); 
	missionSettings[0] addLevel( "guzzo_test_new", 0, "optional achievement string" ); 
	missionSettings[0] addLevel( "guzzo_playground", 1, "optional achievement string" ); 
	////////////////////////////

	level.missionSettings = missionSettings; 
}


/*
 ============== 
///GSCDocBegin
"Name: nextMission()"
"Summary: Calls up the next mission/level when the current one is completed."
"CallOn: Used as a stand-alone function. Not called on anything."
"ScriptFile: _endmission.gsc"
"MandatoryArg: "
"OptionalArg: "
"Example: maps\_endmission::nextMission(); "
"NoteLine: "
"LEVELVAR: "
"SPCOOP: both"
///GSCDocEnd
 ============== 
*/
nextmission()
{
	missionIndex = undefined; 
	levelIndex = undefined; 
	
	SetSavedDvar( "ui_nextMission", "1" ); 
	SetDvar( "ui_showPopup", "0" ); 
	SetDvar( "ui_popupString", "" ); 
	
	// dpg - find the index of the current level
	for( index = 0; index < level.missionSettings.size; index++ )
	{
		levelIndex = level.missionSettings[index] getLevelIndex( level.script ); 
		
		if( !IsDefined( levelIndex ) )
		{
			continue; 
		}
			
		missionIndex = index; 
		break; 
	}
	
	// level is not part of any mission
	if( !IsDefined( missionIndex ) )
	{
		return; 
	}
		
	maps\_utility::level_end_save(); 

	// update mission difficult dvar
	level.missionSettings[missionIndex] setLevelCompleted( levelIndex ); 
	
	if( level.missionSettings[missionIndex] hasAchievement( levelIndex ) )
	{
		GiveAchievement( level.missionSettings[missionIndex] getAchievement( levelIndex ) ); 
	}
	
	if ( level.missionSettings[missionIndex] hasVeteranAward() && level.missionSettings[missionIndex] getLowestSkill() > 3 )
	{
		giveachievement( level.missionSettings[missionIndex] getVeteranAward() );
	}
	
	GiveAchievement( level.missionSettings[missionIndex] getVeteranAward() ); 

	// last level in mission
	if( ( levelIndex + 1 ) == level.missionSettings[missionIndex].levels.size )
	{
		level.missionSettings[missionIndex] updateMissionDvar( levelIndex ); 

		SetSavedDvar( "ui_nextMission", "0" ); 
		
		popupString = unlockMissions(); 

		switch( missionIndex )
		{
			case 2:
				if( popupString != "" )
				{
					popupString += "_"; 
				}
					
				popupString += "russian_completed"; 
				break; 
			case 4:
			case 7:
				if ( level.missionSettings[4] getLowestSkill() && level.missionSettings[7] getLowestSkill() )
				{
					popupString += "british_completed";
				}
				break;
			case 9:
				SetSavedDvar( "ui_nextMission", "2" ); 

				if( allMissionsCompleted( 0 ) )
				{
					GiveAchievement( "won_the_war" ); 
				}

				if( allMissionsCompleted( 2 ) )
				{
					GiveAchievement( "war_hardened" ); 
				}

				Cinematic( "movie_victory", 2 ); 
				MissionSuccess( "credits", false ); 
				return; 
			default:
				break; 
		}
		
		if( popupString.size )
		{
			SetDvar( "ui_showPopup", "1" ); 
			SetDvar( "ui_popupString", popupString ); 
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

	if( allMissionsCompleted( 0 ) )
	{
		GiveAchievement( "won_the_war" ); 
	}

	if( allMissionsCompleted( 2 ) )
	{
		GiveAchievement( "war_hardened" ); 
	}

	if( !nextLevelIndex )
	{
		game["expectedlevel"] = ""; 
		MissionSuccess( level.missionSettings[nextMissionIndex] getSlideShow(), false ); 
	}
	else
	{
		game["expectedlevel"] = level.missionSettings[nextMissionIndex] getLevelName( nextLevelIndex ); 
		MissionSuccess( level.missionSettings[nextMissionIndex] getLevelName( nextLevelIndex ), level.missionSettings[missionIndex] getKeepWeapons( levelIndex ) ); 
	}
}


allMissionsCompleted( difficulty )
{
	difficulty += 10; 
	for( index = 0; index < level.missionSettings.size; index++ )
	{
		missionDvar = getMissionDvarString( index ); 
		if( GetDvarInt( missionDvar ) < difficulty )
		{
			return( false ); 
		}
	}
	return( true ); 
}


// sets a level as complete by updated the mis_difficulty dvar
setLevelCompleted( levelIndex )
{
	levelOffset = ( self.offset * 5 ) + levelIndex; 
	
	missionString = GetDvar( "mis_difficulty" ); 
	
	if( Int( missionString[levelOffset] ) > GetDvarInt( "g_gameskill" ) )
	{
		return; 
	}
		
	newString = ""; 
	for( index = 0; index < missionString.size; index++ )
	{
		if( index != levelOffset )
		{
			newString += missionString[index]; 
		}
		else
		{
			newString += Int( GetDvar( "g_gameSkill" ) ) + 1; 
		}
	}
	SetMissionDvar( "mis_difficulty", newString ); 	
}


getLevelSkill( levelIndex )
{
	levelOffset = ( self.offset * 5 ) + levelIndex; 
	
	missionString = GetDvar( "mis_difficulty" ); 
	return( Int( missionString[levelOffset] ) ); 
}


updateMissionDvar( levelIndex )
{
	missionDvar = getMissionDvarString( self.offset ); 
		
	lowestSkill = self getLowestSkill(); 

	if( lowestSkill )
	{
		SetMissionDvar( missionDvar, ( lowestSkill + 9 ) ); 
	}
	else if( levelIndex + 1 > GetDvarInt( missionDvar ) )
	{
		SetMissionDvar( missionDvar, levelIndex + 1 ); 
	}
}


getMissionDvarString( missionIndex )
{
	if( missionIndex < 9 )
	{
		return( "mis_0" +( missionIndex + 1 ) ); 
	}
	else
	{
		return( "mis_" +( missionIndex + 1 ) ); 
	}
}


getLowestSkill()
{
	missionOffset = ( self.offset * 5 ); 
	
	missionString = GetDvar( "mis_difficulty" ); 

	lowestSkill = 4; 
		
	for( index = 0; index < self.levels.size; index++ )
	{
		if( Int( missionString[missionOffset+index] ) < lowestSkill )
		{
			lowestSkill = Int( missionString[missionOffset+index] ); 
		}
	}
	
	return( lowestSkill ); 
}

// creates a mission struct and returns it
createMission( missionOffset, slideShow, veteranAward, unlockString )
{
	mission = SpawnStruct(); 
	mission.levels = []; 
	mission.prereqs = []; 
	mission.slideShow = slideShow; 
	mission.offset = missionOffset; 
	mission.veteranAward = veteranAward; 
	mission.unlockString = unlockString; 
	return( mission ); 
}


// adds a level to a mission
addLevel( levelName, keepWeapons, achievement )
{
	levelIndex = self.levels.size; 
	self.levels[levelIndex] = SpawnStruct(); 
	self.levels[levelIndex].name = levelName; 
	self.levels[levelIndex].keepWeapons = keepWeapons; 
	self.levels[levelIndex].achievement = achievement; 
}

addPreReq( missionIndex )
{
	preReqIndex = self.prereqs.size; 
	self.prereqs[preReqIndex] = missionIndex; 
}

// returns the index of a level within the context of a mission
getLevelIndex( levelName )
{
	for( levelIndex = 0; levelIndex < self.levels.size; levelIndex++ )
	{
		if( self.levels[levelIndex].name != levelName )
		{
			continue; 
		}
			
		return( levelIndex ); 
	}
	
	return( undefined ); 
}


getSlideShow()
{
	return( self.slideShow ); 
}


// returns the name of the level within the context of a mission
getLevelName( levelIndex )
{
	return( self.levels[levelIndex].name ); 
}


getKeepWeapons( levelIndex )
{
	return( self.levels[levelIndex].keepWeapons ); 
}


getAchievement( levelIndex )
{
	return( self.levels[levelIndex].achievement ); 
}


hasAchievement( levelIndex )
{
	if( IsDefined( self.levels[levelIndex].achievement ) )
	{
		return( true ); 
	}
	else
	{
		return( false ); 
	}
}


getVeteranAward()
{
	return( self.veteranAward ); 
}


hasVeteranAward()
{
	if( IsDefined( self.veteranAward ) )
	{
		return( true ); 
	}
	else
	{
		return( false ); 
	}
}


isUnlocked()
{
	missionDvar = getMissionDvarString( self.offset ); 

	if( GetDvarInt( missionDvar ) == 0 )
	{
		return( false ); 	
	}
	else
	{
		return( true ); 
	}
}



getNextMissionIndex( missionIndex )
{
	if ( level.missionSettings[missionIndex+1] isUnlocked() && !level.missionSettings[missionIndex+1] getLevelSkill( 0 ) )
	{
		return ( missionIndex + 1 );
	}

	for( index = 0; index < level.missionSettings.size; index++ )
	{
		if( level.missionSettings[index] getLowestSkill() )
		{
			continue; 
		}
		
		return( index ); 
	}
	return( missionIndex + 1 ); 
}

// returns the next level's index from within the context of a mission
getNextLevelIndex()
{
	for( index = 0; index < self.levels.size; index++ )
	{
		if( !self getLevelSkill( index ) )
		{
			return( index ); 
		}
	}
	return( 0 ); 
}


unlockMissions()
{
	unlockString = ""; 
	for( index = 0; index  < level.missionSettings.size; index++ )
	{
		if( level.missionSettings[index] isUnlocked() )
		{
			continue; 
		}
		
		if( level.missionSettings[index] canUnlock() )
		{
			level.missionSettings[index] updateMissionDvar( 0 ); 
			
			if( IsDefined( level.missionSettings[index].unlockString ) )
			{
				unlockString += level.missionSettings[index].unlockString; 
			}
		}
	}
	return( unlockString ); 
}


canUnlock()
{
	for( preReqIndex = 0; preReqIndex < self.prereqs.size; preReqIndex++ )
	{
		if( !level.missionSettings[self.prereqs[preReqIndex]] getLowestSkill() )
		{
			return( false ); 
		}
	}
	return( true ); 
}
