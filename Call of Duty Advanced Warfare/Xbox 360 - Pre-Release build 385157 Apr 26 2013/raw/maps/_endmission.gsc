#include maps\_utility;
#include common_scripts\utility;

emptyMissionDifficultyStr	= "00000000000000000000000000000000000000000000000000";

main()
{
	missionSettings = [];

	missionSettings = createMission( "THE_BEST_OF_THE_BEST" );
	//   						levelName 	    	keepWeapons		achievement				skipsSuccess	veteran_achievement		fade_time
	missionSettings addLevel( 	"fusion", 			false, 			undefined, 				true, 			undefined, 				undefined );
	missionSettings addLevel(	"sanfran",			true,			undefined,				true,			undefined,				undefined );
	missionSettings addLevel(	"sanfran_b",		false,			undefined,				true,			undefined,				undefined );
	missionSettings addLevel(	"dogfight_alps",	false,			undefined,				true,			undefined,				undefined );

	if ( IsDefined( level.endmission_main_func ) )
	{
		[[ level.endmission_main_func ]]();
		
		level.endmission_main_func = undefined;
	}

	level.missionSettings = missionSettings;
	
	/#
	thread ui_debug_clearall();
	thread debug_test_next_mission();
	#/
}

debug_test_next_mission()
{
	wait( 10 );
	while ( GetDvarInt( "test_next_mission" ) < 1 )
	{
		wait( 3 );
	}

	_nextmission();
}

_nextmission()
{
	
	/#
	if( getdvarint("nextmission_disable") )
	{
		iprintlnbold( "Nextmission Here, but disabled!" );
		return;
	}
	#/

	if ( is_demo() )
	{
		SetSavedDvar( "ui_nextMission", "0" );
		if ( IsDefined( level.nextmission_exit_time ) )
		{
			ChangeLevel( "", false, level.nextmission_exit_time );
		}
		else
		{
			ChangeLevel( "", false );
		}
		return;
	}
	
	level notify( "nextmission" );
	level.nextmission = true;
	level.player EnableInvulnerability();

	levelIndex = undefined;
	
	SetSavedDvar( "ui_nextMission", "1" );
	SetDvar( "ui_showPopup"	 , "0" );
	SetDvar( "ui_popupString", "" );
	SetDvar( "ui_prev_map"	 , level.script );

	game[ "previous_map" ] = level.script;
	
	levelIndex = level.missionSettings getLevelIndex( level.script );
	
	if ( level.script == "sp_intro" && !getdvarint( "prologue_select" ) )	// special case for intro.map as it is used as the basis for two levels
	{
		assert(levelIndex >= 0 && levelIndex < level.missionSettings.levels.size );
		for ( i = levelIndex + 1; i < level.missionSettings.levels.size-1; i++ )
		{
			if ( level.missionSettings.levels[i].name == "sp_intro" )
			{
				levelIndex = i;
				break;
			}
		}
	}
	setdvar( "prologue_select", "0" );

	
	maps\_gameskill::auto_adust_zone_complete( "aa_main_" + level.script );
											
	if ( !isDefined( levelIndex ) )
	{
		// run the same mission again if the nextmission is not defiend.
		MissionSuccess( level.script );
		return;
	}

	if ( level.script != "sp_dubai" )
		maps\_utility::level_end_save();
	

	// update mission difficulty and highest completed profile values
	level.missionSettings setLevelCompleted( levelIndex );
	
	// a congradulations popup when you complete the last mission
	// todo: do we want this?
	if ( ( level.player GetLocalPlayerProfileData( "highestMission" ) ) < levelindex + 1 && ( level.script == "sp_dubai" ) && GetDvarInt( "mis_cheat" ) == 0 )
	{
		// todo: suspect this doesn't do anything anymore
		setdvar( "ui_sp_unlock", "0" );// set reset value to 0
		setdvar( "ui_sp_unlock", "1" );
	}
	
	/#
	PrintLn( ">> SP PERCENT UPDATE - _nextmission()" );
	#/
	completion_percentage = updateSpPercent();
	
	/#	
	if( getdvarint( "ui_debug_setlevel" ) != 0 )	
	{
		_setHighestMissionIfNotCheating( getdvarint( "ui_debug_clearlevel" ) );
		level.missionSettings setLevelCompleted( max( 0, getdvarint( "ui_debug_clearlevel" ) - 1 ) );
		
		setdvar( "ui_debug_setlevel", "" );
	}
	
	// Debug prints
	if ( completion_percentage < level.player GetLocalPlayerProfileData( "percentCompleteSP" ) )
		PrintLn( ">> SP DEBUG: 					[ WARNING! NEW:" + completion_percentage + "% < OLD:" + level.player GetLocalPlayerProfileData( "percentCompleteSP" ) + "% ]\n" );
	
	PrintLn( ">> SP DEBUG: 				[ setlevel:" + getdvarint( "ui_debug_setlevel" ) + " clearall:" + getdvarint( "ui_debug_clearall" ) + " ]" );
	PrintLn( ">> SP PLAYER DIFFICULTY: 		[" + (level.player GetLocalPlayerProfileData( "missionHighestDifficulty" )) + "]" );
	PrintLn( ">> SP PERCENTAGE COMPLETED:		[" + completion_percentage/100 + "%]" );
	PrintLn( ">> SP LEVEL INDEX: 			[" + levelIndex + "]" );
	PrintLn( ">> SP LEVEL NAME: 			[" + level.script + "]" );
	PrintLn( ">> SP LEVELS COMPLETED: 		[" + (level.player GetLocalPlayerProfileData( "highestMission" )) + "]" );
	PrintLn( ">> SP MAX LEVELS: 			[" + level.missionSettings.levels.size + "]" );
	#/
	
	UpdateGamerProfile();
	
	if ( level.missionSettings hasAchievement( levelIndex ) )
		maps\_utility::giveachievement_wrapper( level.missionSettings getAchievement( levelIndex ) );
	
	if ( level.missionSettings hasLevelVeteranAward( levelIndex ) && getLevelCompleted( levelIndex ) == 4
		&& level.missionSettings check_other_hasLevelVeteranAchievement( levelIndex ) )
		maps\_utility::giveachievement_wrapper( level.missionSettings getLevelVeteranAward( levelIndex ) );
	
	if ( level.missionSettings hasMissionHardenedAward() &&
		level.missionSettings getLowestSkill() > 2 )
		giveachievement_wrapper( level.missionSettings getHardenedAward() );
	
	// credits happen in the dubai level, so dubai will call this function before the credits are done
	// and we don't want to cut the credits short, so early out.
	if ( level.script == "sp_dubai" )
		return;
	
	// dubai is the last level, so if we're not dubai this should be valid
	nextLevelIndex = levelIndex + 1;
	
	Assert(nextLevelIndex < level.missionSettings.levels.size);
	
	// todo: do we support this still?		
	if ( arcadeMode() )
	{
		if ( !getdvarint( "arcademode_full" ) )
		{
			SetSavedDvar( "ui_nextMission", "0" );
			missionSuccess( level.script );
			return;
		}
	}

	if ( level.missionSettings skipssuccess( levelIndex ) )
	{
		if ( IsDefined( level.missionsettings getfadetime( levelIndex ) ) )
		{
			ChangeLevel( level.missionSettings getLevelName( nextLevelIndex ), level.missionSettings getKeepWeapons( levelIndex ), level.missionsettings getfadetime( levelIndex ) );
		}
		else
		{
			ChangeLevel( level.missionSettings getLevelName( nextLevelIndex ), level.missionSettings getKeepWeapons( levelIndex ) );
		}
	}
	else
	{
		MissionSuccess( level.missionSettings getLevelName( nextLevelIndex ), level.missionSettings getKeepWeapons( levelIndex ) );
	}
		
	// DEMO BUILD
	// */
}

updateSpPercent()
{
	completion_percentage = int( getTotalpercentCompleteSP()*100 );
	
	if( getdvarint( "mis_cheat" ) == 0 )
	{
		assertex( ( completion_percentage >= 0 && completion_percentage <= 10000 ), "SP's Completion percentage [ " + completion_percentage + "% ] is outside of 0 to 100 range!" );
		level.player SetLocalPlayerProfileData( "percentCompleteSP", completion_percentage );
	}
	
	return completion_percentage;
}
	
getTotalpercentCompleteSP()
{
	/*
	SP STATS:
	
	Game Progression  	60%    	-50
	Hardened Progress  	60%   	-25
	Veteran Progress  	60%    	-10
	Intel Items  		21/45   -15
	--------------------------------
	Total    			x%		-100
	Play Time			##:##:##
	*/
	
	stat_progression = max( getStat_easy(), getStat_regular() ); // easy is always higher than regular anyways...
	stat_progression_ratio = 0.5/1;
	/#
		PrintLn( ">> SP STAT REGULAR: " + stat_progression + "%" + "(" + stat_progression_ratio*100 + "%)" );
	#/
	
	stat_hardened = getStat_hardened();
	stat_hardened_ratio = 0.25/1;
	/#
		PrintLn( ">> SP STAT HARDENED: " + stat_hardened + "%" + "(" + stat_hardened_ratio*100 + "%)" );
	#/
	
	stat_veteran = getStat_veteran();
	stat_veteran_ratio = 0.1/1;
	/#
		PrintLn( ">> SP STAT VETERAN: " + stat_veteran + "%" + "(" + stat_veteran_ratio*100 + "%)" );
	#/
	
	stat_intel = getStat_intel();
	stat_intel_ratio = 0.15/1;
	/#
		PrintLn( ">> SP STAT INTEL: " + stat_intel + "%" + "(" + stat_intel_ratio*100 + "%)" );
	#/

	assertex( ( stat_progression_ratio + stat_hardened_ratio + stat_veteran_ratio + stat_intel_ratio ) <= 1.0, "Total sum of SP progress breakdown contributes to more than 100%!" );

	total_progress = 0.0;
	total_progress += stat_progression_ratio*stat_progression;
	total_progress += stat_hardened_ratio*stat_hardened;
	total_progress += stat_veteran_ratio*stat_veteran;
	total_progress += stat_intel_ratio*stat_intel;

	assertex( total_progress <= 100.0, "Total Percentage calculation is out of bound, larger then 100%" );
	/#
		PrintLn( ">> SP STAT TOTAL: " + total_progress + "%" );
	#/
	
	return total_progress;	
}

// recruit and regular difficulty
getStat_progression( difficulty )
{
	assert( isdefined( level.missionSettings ) );
	assert( isdefined( level.script ) );

	difficulty_string = (level.player GetLocalPlayerProfileData( "missionHighestDifficulty" ));
	
	levels = 0;
	notplayed = [];
	skipped = false;
	// level.missionSettings.levels.size - 1 : the minus one is to remove the credits level
	for ( i = 0; i < level.missionSettings.levels.size-1; i++ )
	{
		if ( int( difficulty_string[ i ] ) >= difficulty )
			levels++;
	}

	completion = ( levels/(level.missionsettings.levels.size-1) )*100;
	return completion; // 0->100
}

getStat_easy()
{
	easy = 1;
	return getStat_progression( easy ); // 0->100	
}

getStat_regular()
{
	regular = 2;
	return getStat_progression( regular ); // 0->100	
}

getStat_hardened()
{
	hardened = 3;
	return getStat_progression( hardened ); // 0->100
}

getStat_veteran()
{
	veteran = 4;
	return getStat_progression( veteran ); // 0->100
}

getStat_intel()
{
	total_intel_items = 45;
	intel_percentage = ( (level.player GetLocalPlayerProfileData( "cheatPoints" ) )/total_intel_items )*100;
	return intel_percentage; // 0->100
}

//allMissionsCompleted( difficulty )
//{
//	difficulty += 10;
//	for ( index = 0; index < level.missionSettings.size; index++ )
//	{
//		missionDvar = getMissionDvarString( index );
//		if ( getdvarInt( missionDvar ) < difficulty )
//			return( false );
//	}
//	return( true );
//}

getLevelCompleted( levelIndex )
{
	return int( (level.player GetLocalPlayerProfileData( "missionHighestDifficulty" ))[ levelIndex ] );
}

getSoLevelCompleted( levelIndex )
{
	return int( (level.player GetLocalPlayerProfileData( "missionSOHighestDifficulty" ))[ levelIndex ] );
}

setLevelCompleted( levelIndex )
{
	missionString = ( level.player GetLocalPlayerProfileData( "missionHighestDifficulty" ) );
	
	newString = "";
	for ( index = 0; index < missionString.size; index++ )
	{
		if ( index != levelIndex )
		{
			newString += missionString[ index ];
		}
		else
		{
			if ( level.gameskill + 1 > int( missionString[ levelIndex ] ) )
				newString += level.gameskill + 1;
			else
				newString += missionString[ index ];
		}
	}
	
	// levels completed after skipping levels in order will not get its progress recorded, becuase player was hacking or doing devmap
	finalString = "";
	skip = false;
	highest = 0;
	for ( i = 0; i < newString.size; i++ )
	{
		if ( int( newString[ i ] ) == 0 || skip )
		{
			finalString += "0";
			skip = true;
		}
		else
		{
			finalString += newString[ i ];
			highest++;
		}
	}

	_setHighestMissionIfNotCheating( highest );
	_setMissionDiffStringIfNotCheating( finalString );
}


_setHighestMissionIfNotCheating( mission )
{
	//if ( maps\_cheat::is_cheating() || flag( "has_cheated" ) )
	//	return;
	if ( getdvar( "mis_cheat" ) == "1" )
		return;
	
	level.player SetLocalPlayerProfileData( "highestMission", mission );
}


_setMissionDiffStringIfNotCheating( missionsDifficultyString )
{
	if ( getdvar( "mis_cheat" ) == "1" )
		return;
	
	level.player SetLocalPlayerProfileData( "missionHighestDifficulty", missionsDifficultyString );
}


getLevelSkill( levelIndex )
{
	missionString = (level.player GetLocalPlayerProfileData( "missionHighestDifficulty" ));
	return( int( missionString[ levelIndex ] ) );
}


getMissionDvarString( missionIndex )
{
	if ( missionIndex < 9 )
		return( "mis_0" + ( missionIndex + 1 ) );
	else
		return( "mis_" + ( missionIndex + 1 ) );
}


getLowestSkill()
{
	missionString = (level.player GetLocalPlayerProfileData( "missionHighestDifficulty" ));
	lowestSkill = 4;

	for ( index = 0; index < self.levels.size; index++ )
	{
		if ( int( missionString[ index ] ) < lowestSkill )
			lowestSkill = int( missionString[ index ] );
	}
	return( lowestSkill );
}


createMission( HardenedAward )
{
	mission = spawnStruct();
	mission.levels = [];
	mission.prereqs = [];
// 	mission.slideShow = slideShow;
	mission.HardenedAward = HardenedAward;
	return( mission );
}

addLevel( levelName, keepWeapons, achievement, skipsSuccess, veteran_achievement, fade_time, for_kleenex )
{
//	if ( GetDvarInt( "iw_kleenex" ) )
//	{
//		if ( !IsDefined( for_kleenex ) )
//		{
//			for_kleenex = false;
//		}
//
//		if ( !for_kleenex )
//		{
//			return;
//		}
//	}

	assert( isdefined( keepweapons ) );
	levelIndex = self.levels.size;
	self.levels[ levelIndex ] = spawnStruct();
	self.levels[ levelIndex ].name = levelName;
	self.levels[ levelIndex ].keepWeapons = keepWeapons;
	self.levels[ levelIndex ].achievement = achievement;
	self.levels[ levelIndex ].skipsSuccess = skipsSuccess;
	self.levels[ levelIndex ].veteran_achievement = veteran_achievement;

	if ( IsDefined( fade_time ) )
	{
		self.levels[ levelIndex ].fade_time = fade_time;
	}
}

addPreReq( missionIndex )
{
	preReqIndex = self.prereqs.size;
	self.prereqs[ preReqIndex ] = missionIndex;
}

getLevelIndex( levelName )
{
	foreach ( levelIndex, so_level in self.levels )
	{
		if ( so_level.name == levelName )
			return levelIndex;
	}
	
	return ( undefined );
}

getLevelName( levelIndex )
{
	return( self.levels[ levelIndex ].name );
}

getKeepWeapons( levelIndex )
{
	return( self.levels[ levelIndex ].keepWeapons );
}

getAchievement( levelIndex )
{
	return( self.levels[ levelIndex ].achievement );
}

getLevelVeteranAward( levelIndex )
{
	return( self.levels[ levelIndex ].veteran_achievement );
}

getfadetime( index )
{
	if ( !IsDefined( self.levels[ index ].fade_time ) )
	{
		return undefined;
	}

	return self.levels[ index ].fade_time;
}

hasLevelVeteranAward( levelIndex )
{
	if ( isDefined( self.levels[ levelIndex ].veteran_achievement ) )
		return( true );
	else
		return( false );
}

hasAchievement( levelIndex )
{
	if ( isDefined( self.levels[ levelIndex ].achievement ) )
		return( true );
	else
		return( false );
}

check_other_hasLevelVeteranAchievement( levelIndex )
{
	//check for other levels that have the same Hardened achievement.  
	//If they have it and other level has been completed at a hardened level check passes.

	for ( i = 0; i < self.levels.size; i++ )
	{
		if ( i == levelIndex )
			continue;
		if ( ! hasLevelVeteranAward( i ) )
			continue;
		if ( self.levels[ i ].veteran_achievement == self.levels[ levelIndex ].veteran_achievement )
			if ( getLevelCompleted( i ) < 4 )
				return false;
	}
	return true;
}

skipsSuccess( levelIndex )
{
	if ( !isDefined( self.levels[ levelIndex ].skipsSuccess ) )
		return false;
	return true;
}


getHardenedAward()
{
	return( self.HardenedAward );
}


hasMissionHardenedAward()
{
	if ( isDefined( self.HardenedAward ) )
		return( true );
	else
		return( false );
}

getNextLevelIndex()
{
	for ( index = 0; index < self.levels.size; index++ )
	{
		if ( !self getLevelSkill( index ) )
			return( index );
	}
	return( 0 );
}

force_all_complete()
{
	println( "tada!" );
	missionString = (level.player GetLocalPlayerProfileData( "missionHighestDifficulty" ));
	newString = "";
	for ( index = 0; index < missionString.size; index++ )
	{
		if ( index < 20 )
			newString += 2;
		else
			newstring += 0;
	}
	level.player SetLocalPlayerProfileData( "missionHighestDifficulty", newString );
	level.player SetLocalPlayerProfileData( "highestMission", 20 );
}
/#
ui_debug_clearall()
{
	for(;;)
	{
		if( getdvarint( "ui_debug_clearall" ) )
		{
			clearall();
			level.player SetLocalPlayerProfileData( "percentCompleteSP", 0 );	
			
			// JC-ToDo: This should probably be moved to _endmission_so
			foreach( player in level.players )
			{
				player SetLocalPlayerProfileData( "missionspecops", 0 );
				player SetLocalPlayerProfileData( "missionsohighestdifficulty", "00000000000000000000000000000000000000000000000000" );
				player SetLocalPlayerProfileData( "percentCompleteSO", 0 );
				
				best_time_name = tablelookup( "sp/specOpsTable.csv", 1, level.script, 9 );
				if ( isdefined( best_time_name ) && best_time_name != "" )
					player SetLocalPlayerProfileData( best_time_name, 0 );
			}
			
			setdvar( "ui_debug_clearall", "" );
		}
		
		wait 0.05;
	}
}
#/
clearall()
{
	level.player SetLocalPlayerProfileData( "missionHighestDifficulty", emptyMissionDifficultyStr );
	level.player SetLocalPlayerProfileData( "highestMission", 1 );
}

credits_end()
{
	ChangeLevel( "airplane", false );
}
	
