#include maps\_utility;
#include common_scripts\utility;

emptyMissionDifficultyStr 	= "00000000000000000000000000000000000000000000000000";

SOTABLE_COL_REF				= 1;
SOTABLE_COL_NAME 			= 2;
SOTABLE_COL_GROUP			= 13;
SOTABLE_COL_UNLOCK			= 5;

main()
{
	missionSettings = [];

	// levels and missions are listed in order 
	missionIndex = 0;// only one missionindex( vignettes in CoD2, no longer exist but I'm going to use this script anyway because it's got good stuff in it. - Nate

	//addLevel( levelName, keepWeapons, achievement, skipsSuccess, veteran_achievement )
	missionSettings = createMission( "WAR_HARDENED" );
	missionSettings addLevel( "trainer", false, "EARN_A_WINGED_DAGGER", true );
	missionSettings addLevel( "roadkill", false, undefined, true );
	missionSettings addLevel( "cliffhanger", false, undefined, true );
	missionSettings addLevel( "airport", false, undefined, true );
	missionSettings addLevel( "favela", false, undefined, true );
	missionSettings addLevel( "invasion", false, undefined, true );
	missionSettings addLevel( "favela_escape", false, undefined, true );
	missionSettings addLevel( "arcadia", false, undefined, true );
	missionSettings addLevel( "oilrig", false, undefined, true );
	missionSettings addLevel( "gulag", false, undefined, true );
	missionSettings addLevel( "dcburning", false, undefined, true );
	missionSettings addLevel( "contingency", false, undefined, true );
	missionSettings addLevel( "dcemp", true, undefined, true );
	missionSettings addLevel( "dc_whitehouse", false, undefined, true );
	missionSettings addLevel( "estate", false, undefined, true );
	missionSettings addLevel( "boneyard", false, undefined, true );
	missionSettings addLevel( "af_caves", true, undefined, true );
	missionSettings addLevel( "af_chase", true, undefined, true );
	missionSettings addLevel( "iw4_credits", false, undefined, true );

// need to add SO maps differently, need to save script vars
//--------
/*
TO DO:
*/

	level.specOpsGroups = [];
	
	setupSoGroup( "so_alpha" );
	setupSoGroup( "so_bravo" );
	setupSoGroup( "so_charlie" );
	setupSoGroup( "so_delta" );
	setupSoGroup( "so_echo" );
    
    if( is_specialop() )
    {
		specOpsSettings = createMission( "SPECIAL_OPS" );
		//addSpecOpLevel( levelName, achievement, veteran_achievement )
		specOpsSettings addSpecOpLevel( "so_showers_gulag"			, false, false ); 	// offset: 0 
		specOpsSettings addSpecOpLevel( "so_killspree_invasion"		, false, false ); 	// offset: 1 
		specOpsSettings addSpecOpLevel( "so_ac130_co_hunted"		, false, false ); 	// offset: 2 
		specOpsSettings addSpecOpLevel( "so_killspree_favela"		, false, false ); 	// offset: 3 
		specOpsSettings addSpecOpLevel( "so_assault_oilrig"			, false, false ); 	// offset: 4 
		specOpsSettings addSpecOpLevel( "so_defense_invasion"		, false, false ); 	// offset: 5 
		specOpsSettings addSpecOpLevel( "so_escape_airport"			, false, false ); 	// offset: 6 
		specOpsSettings addSpecOpLevel( "so_forest_contingency"		, false, false ); 	// offset: 7 
		specOpsSettings addSpecOpLevel( "so_download_arcadia"		, false, false ); 	// offset: 8 
		specOpsSettings addSpecOpLevel( "so_demo_so_bridge"			, false, false ); 	// offset: 9 
		specOpsSettings addSpecOpLevel( "so_crossing_so_bridge"		, false, false ); 	// offset: 10
		specOpsSettings addSpecOpLevel( "so_snowrace1_cliffhanger"	, false, false ); 	// offset: 11
		specOpsSettings addSpecOpLevel( "so_snowrace2_cliffhanger"	, false, false ); 	// offset: 12
		specOpsSettings addSpecOpLevel( "so_rooftop_contingency"	, false, false ); 	// offset: 13
		specOpsSettings addSpecOpLevel( "so_sabotage_cliffhanger"	, false, false ); 	// offset: 14
		specOpsSettings addSpecOpLevel( "so_defuse_favela_escape"	, false, false ); 	// offset: 15
		specOpsSettings addSpecOpLevel( "so_takeover_estate"		, false, false ); 	// offset: 16
		specOpsSettings addSpecOpLevel( "so_takeover_oilrig"		, false, false ); 	// offset: 17
		specOpsSettings addSpecOpLevel( "so_intel_boneyard"			, false, false ); 	// offset: 18
		specOpsSettings addSpecOpLevel( "so_juggernauts_favela"		, false, false ); 	// offset: 19
		specOpsSettings addSpecOpLevel( "so_hidden_so_ghillies"		, false, false ); 	// offset: 20
		specOpsSettings addSpecOpLevel( "so_chopper_invasion"		, false, false ); 	// offset: 21
		specOpsSettings addSpecOpLevel( "so_killspree_trainer"		, false, false ); 	// offset: 22
		
		level.specOpsSettings = specOpsSettings;
	}

//--------

/*
	missionSettings addLevel( "cargoship", false, "MAKE_THE_JUMP", true, "THE_PACKAGE" );
	missionSettings addLevel( "coup", false, undefined, true );
	missionSettings addLevel( "blackout", false, "COMPLETE_BLACKOUT", true, "THE_RESCUE" );
	missionSettings addLevel( "armada", false, undefined, true, "THE_SEARCH" );
	missionSettings addLevel( "bog_a", false, "SAVE_THE_BACON", true, "THE_BOG" );
	missionSettings addLevel( "hunted", false, undefined, true, "THE_ESCAPE" );
	missionSettings addLevel( "ac130", false, "BRING_EM_HOME", true, "THE_ESCAPE" );
	missionSettings addLevel( "bog_b", false, undefined, true, "THE_BOG" );
	missionSettings addLevel( "airlift", false, undefined, true, "THE_FIRST_HORSEMAN" );
	missionSettings addLevel( "aftermath", false, undefined, true );
	missionSettings addLevel( "village_assault", false, "COMPLETE_VILLAGE_ASSAULT", true, "THE_SECOND_HORSEMAN" );
	missionSettings addLevel( "scoutsniper", true, undefined, true, "THE_SHOT" );
	missionSettings addLevel( "sniperescape", false, "PIGGYBACK_RIDE", true, "THE_SHOT" );
	missionSettings addLevel( "village_defend", false, undefined, true, "THE_THIRD_HORSEMAN" );
	missionSettings addLevel( "ambush", false, "DESPERATE_MEASURES", true, "THE_THIRD_HORSEMAN" );
	missionSettings addLevel( "icbm", true, undefined, true, "THE_ULTIMATUM" );
	missionSettings addLevel( "launchfacility_a", true, undefined, true, "THE_ULTIMATUM" );
	missionSettings addLevel( "launchfacility_b", true, undefined, true, "THE_ULTIMATUM" );
	missionSettings addLevel( "jeepride", false, "WIN_THE_WAR", true, "THE_FOURTH_HORSEMAN" );
	missionSettings addLevel( "airplane", false, undefined, undefined, "MILE_HIGH_CLUB" );
*/

	level.missionSettings = missionSettings;
	
	/#
	thread ui_debug_clearall();
	#/
}

setupSoGroup( so_ref )
{
	level.specOpsGroups[ so_ref ] 				= spawnStruct();
	level.specOpsGroups[ so_ref ].ref		 	= so_ref;
	//level.specOpsGroups[ so_ref ].string_name 	= tablelookup( "sp/specopstable.csv", SOTABLE_COL_REF, so_ref, SOTABLE_COL_NAME );
	level.specOpsGroups[ so_ref ].unlock		= int( tablelookup( "sp/specopstable.csv", SOTABLE_COL_REF, so_ref, SOTABLE_COL_UNLOCK ) );
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


	level notify( "nextmission" );
	level.nextmission = true;
	level.player enableinvulnerability();

	// skip if coop
	if ( string_starts_with( level.script, "co_" ) )
	{
		finalize_player_reward();
		setsaveddvar( "ui_nextMission", "0" );
		//setdvar( "ui_victoryquote", "@VICTORYQUOTE_IW_THANKS_FOR_PLAYING" );
		missionSuccess( "trainer" );// for lack of better things to do..
		coop_eog_summary();
		return;
	}

	if ( string_starts_with( level.script, "pmc_" ) )
	{
		finalize_player_reward();
		setsaveddvar( "ui_nextMission", "0" );
		missionSuccess( level.script );
		coop_eog_summary();
		return;
	}

	if ( arcadeMode() )
	{
		level.arcadeMode_success = true;
		thread maps\_arcadeMode::arcadeMode_ends();
		flag_wait( "arcademode_ending_complete" );
	}

	levelIndex = undefined;

	setsaveddvar( "ui_nextMission", "1" );
	setdvar( "ui_showPopup", "0" );
	setdvar( "ui_popupString", "" );

	maps\_gameskill::auto_adust_zone_complete( "aa_main_" + level.script );

	levelIndex = level.missionSettings getLevelIndex( level.script );

	if ( !isDefined( levelIndex ) )
	{
		// run the same mission again if the nextmission is not defiend.
		MissionSuccess( level.script );
		return;
	}

	if ( level.script != "af_chase" && level.script != "airplane" )
		maps\_utility::level_end_save();

	// update mission difficult dvar
	level.missionSettings setLevelCompleted( levelIndex );

//	if( !( level.missionSettings getLowestSkill() ) && !(level.script == "jeepride") )

	if ( getdvarint( "mis_01" ) < levelindex + 1 && ( level.script == "jeepride" ) && getdvarint( "mis_cheat" ) == 0 )
	{
        setdvar( "ui_sp_unlock", "0" );// set reset value to 0
        setdvar( "ui_sp_unlock", "1" );
    }

	if ( getdvarint( "mis_01" ) < levelindex + 1 )// && !( level.script == "jeepride" ) )
		_setMissionDvar( "mis_01", levelIndex + 1 );

	completion_percentage = 0;
	completion_fraction = 100 * ( ( levelIndex + 1 ) / level.missionSettings.levels.size );

	assert( isdefined( completion_fraction ) );
	
	// round up or down
	if ( int(completion_fraction*100) % 100 >= 0.5 )
		completion_percentage = int( completion_fraction ) + 1;
	else
		completion_percentage = int( completion_fraction );
	
	if( getdvarint( "mis_cheat" ) == 0 )
	{
		assertex( ( completion_percentage >= 0 && completion_percentage <= 100 ), "SP's Completion percentage [ " + completion_percentage + "% ] is outside of 0 to 100 range!" );
		level.player SetLocalPlayerProfileData( "percentCompleteSP", completion_percentage );
	}
	
	/#	
	if( getdvarint( "ui_debug_setlevel" ) != 0 )	
	{
		_setMissionDvar( "mis_01" , getdvarint( "ui_debug_clearlevel" ) );
		level.missionSettings setLevelCompleted( max( 0, getdvarint( "ui_debug_clearlevel" ) - 1 ) );
		
		setdvar( "ui_debug_setlevel", "" );
	}
	
	// Debug prints
	PrintLn( ">> SO DEBUG: 					[ setlevel:" + getdvarint( "ui_debug_setlevel" ) + " clearall:" + getdvarint( "ui_debug_clearall" ) + " ]\n" );
	PrintLn( ">> SP PLAYER DIFFICULTY: 		[" + getdvar( "mis_difficulty" ) + "]\n" );
	PrintLn( ">> SP PERCENTAGE COMPLETED:	[" + completion_percentage + "%]\n" );
	PrintLn( ">> SP LEVEL INDEX: 			[" + levelIndex + "]\n" );
	PrintLn( ">> SP LEVEL NAME: 			[" + level.script + "]\n" );
	PrintLn( ">> SP LEVELS COMPLETED: 		[" + getdvar( "mis_01" ) + "]\n" );
	PrintLn( ">> SP MAX LEVELS: 			[" + level.missionSettings.levels.size + "]\n" );
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

	nextLevelIndex = level.missionSettings.levels.size;
	
	if ( level.script == "airplane" || level.script == "iw4_credits" )
	{
		setsaveddvar( "ui_nextMission", "0" );
		//setdvar( "ui_victoryquote", "@VICTORYQUOTE_IW_THANKS_FOR_PLAYING" );
		missionSuccess( "trainer" );
		return;
	}
	else
	{
		nextLevelIndex = levelIndex + 1;
	}

	if ( arcadeMode() )
	{
		if ( !getdvarint( "arcademode_full" ) )
		{
			setsaveddvar( "ui_nextMission", "0" );
			missionSuccess( level.script );
			return;
		}

		if ( level.script == "cargoship" )
		{
			changelevel( "blackout", level.missionSettings getKeepWeapons( levelIndex ) );
			return;
		}
		else
		if ( level.script == "airlift" )
		{
			changelevel( "village_assault", level.missionSettings getKeepWeapons( levelIndex ) );
			return;
		}
		else
		if ( level.script == "jeepride" )
		{
			changelevel( "airplane", level.missionSettings getKeepWeapons( levelIndex ) );
			return;
		}
	}

	if ( level.script == "jeepride" )
	{
		setdvar( "credits_load", "1" );
		changelevel( "ac130", level.missionSettings getKeepWeapons( levelIndex ) );
		return;
	}

	if ( level.missionSettings skipssuccess( levelIndex ) )
		changelevel( level.missionSettings getLevelName( nextLevelIndex ), level.missionSettings getKeepWeapons( levelIndex ) );
	else
		missionSuccess( level.missionSettings getLevelName( nextLevelIndex ), level.missionSettings getKeepWeapons( levelIndex ) );
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
	return int( getdvar( "mis_difficulty" )[ levelIndex ] );
}

getSoLevelCompleted( levelIndex )
{
	return int( getdvar( "so_difficulty" )[ levelIndex ] );
}

setSoLevelCompleted( levelIndex )
{
	levelOffset = levelIndex;

	foreach( player in level.players )
	{
		specOpsString = player GetLocalPlayerProfileData( "missionSOHighestDifficulty" );
		
		if ( !isdefined( specOpsString ) )
			continue;
		
		pre_total_stars = 0;
		for ( i = 0; i < specOpsString.size; i++ )
			pre_total_stars += max( 0, int( specOpsString[ i ] ) - 1 );

		if ( specOpsString.size == 0 )
			specOpsString = emptyMissionDifficultyStr;

		// if profile has no zeros for unplayed levels, we need to populate it with zeros
		while( levelOffset >= specOpsString.size )
			specOpsString += "0";
		
		assertex( isdefined( level.specops_reward_gameskill ), "Game skill not setup correctly for coop." );
		gameskill = level.specops_reward_gameskill;
		
		if ( isdefined( player.forcedGameSkill ) )
			gameskill = player.forcedGameSkill;
		
		if ( int( specOpsString[ levelOffset ] ) > gameskill )
			continue;
		
		newString = "";
		for ( index = 0; index < specOpsString.size; index++ )
		{
			if ( index != levelOffset )
				newString += specOpsString[ index ];
			else
				newString += gameskill + 1;
		}
		
		post_total_stars = 0;
		for ( i = 0; i < newString.size; i++ )
			post_total_stars += max( 0, int( newString[ i ] ) - 1 );
			
		delta_total_stars = post_total_stars - pre_total_stars;
		if ( delta_total_stars > 0 )
		{
			player.eog_newstar = true;
			player.eog_newstar_value = delta_total_stars;
			
			foreach ( group in level.specOpsGroups )
			{
				if ( group.unlock == 0 )
					continue;
				
				if ( pre_total_stars < group.unlock && post_total_stars >= group.unlock )
				{
					player.eog_unlock = true;
					player.eog_unlock_value = group.ref;				
				}
			}
		}
			
		player SetLocalPlayerProfileData( "missionSOHighestDifficulty", newString );
	}
}

setLevelCompleted( levelIndex )
{
	levelOffset = levelIndex;

	missionString = getdvar( "mis_difficulty" );

	if ( int( missionString[ levelOffset ] ) > level.gameskill )
		return;

	newString = "";
	gameskill = level.gameskill;

	if ( level.script == "trainer" )
		gameskill = 3; // special hack. makes trainer complete on the highest difficulty possible since no difficulty setting is available prior.

	for ( index = 0; index < missionString.size; index++ )
	{
		if ( index != levelOffset )
			newString += missionString[ index ];
		else
			newString += gameskill + 1;
	}
	_setMissionDvar( "mis_difficulty", newString );
}

_setMissionDvar( dvar, string )
{
	if ( maps\_cheat::is_cheating() || flag( "has_cheated" ) )
		return;
	if ( getdvar( "mis_cheat" ) == "1" )
		return;
	setMissionDvar( dvar, string );
}


getLevelSkill( levelIndex )
{
	levelOffset = levelIndex;

	missionString = getdvar( "mis_difficulty" );
	return( int( missionString[ levelOffset ] ) );
}


//updateMissionDvar( levelIndex )
//{
//	missionDvar = getMissionDvarString();
//		
//	lowestSkill = self getLowestSkill();
//
//	if ( lowestSkill )
//		setMissionDvar( missionDvar, ( lowestSkill + 9 ) );
//	else if ( levelIndex + 1 > getdvarInt( missionDvar ) )
//		setMissionDvar( missionDvar, levelIndex + 1 );
//}


getMissionDvarString( missionIndex )
{
	if ( missionIndex < 9 )
		return( "mis_0" + ( missionIndex + 1 ) );
	else
		return( "mis_" + ( missionIndex + 1 ) );
}


getLowestSkill()
{
	missionString = getdvar( "mis_difficulty" );
	lowestSkill = 4;


	//hack here.  excluding the last level, airplane. normally wouldn't have the -1 on the size.
	for ( index = 0; index < self.levels.size - 1; index++ )
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

addLevel( levelName, keepWeapons, achievement, skipsSuccess, veteran_achievement )
{
	assert( isdefined( keepweapons ) );
	levelIndex = self.levels.size;
	self.levels[ levelIndex ] = spawnStruct();
	self.levels[ levelIndex ].name = levelName;
	self.levels[ levelIndex ].keepWeapons = keepWeapons;
	self.levels[ levelIndex ].achievement = achievement;
	self.levels[ levelIndex ].skipsSuccess = skipsSuccess;
	self.levels[ levelIndex ].veteran_achievement = veteran_achievement;
}

addSpecOpLevel( levelName, achievement, veteran_achievement )
{
	levelIndex = self.levels.size;
	self.levels[ levelIndex ] = spawnStruct();
	self.levels[ levelIndex ].name = levelName;
	self.levels[ levelIndex ].achievement = achievement;
	self.levels[ levelIndex ].veteran_achievement = veteran_achievement;
	
	level_group = tablelookup( "sp/specopstable.csv", SOTABLE_COL_REF, level.script, SOTABLE_COL_GROUP );
	if ( level_group == "" )
		return;
	
	if( !isdefined( level.specOpsGroups[ level_group ].group_members ) )
		level.specOpsGroups[ level_group ].group_members = [];
	
	member_size = level.specOpsGroups[ level_group ].group_members.size;
	level.specOpsGroups[ level_group ].group_members[ member_size ] = levelName;
}

addPreReq( missionIndex )
{
	preReqIndex = self.prereqs.size;
	self.prereqs[ preReqIndex ] = missionIndex;
}

getLevelIndex( levelName )
{
	for ( levelIndex = 0; levelIndex < self.levels.size; levelIndex++ )
	{
		if ( self.levels[ levelIndex ].name != levelName )
			continue;

		return( levelIndex );
	}
	return( undefined );
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
	missionString = getdvar( "mis_difficulty" );
	newString = "";
	for ( index = 0; index < missionString.size; index++ )
	{
		if ( index < 20 )
			newString += 2;
		else
			newstring += 0;
	}
	setMissionDvar( "mis_difficulty", newString );
	setMissionDvar( "mis_01", 20 );
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
	setMissionDvar( "mis_difficulty", emptyMissionDifficultyStr );
	setMissionDvar( "mis_01", 1 );
}

credits_end()
{

	// hacks to make airplane not unlock untill after credits. not to include the map in the list since there are unknown issues with level.script and ac130 conflicts that I don't want to deal with.
//	levelIndex = level.missionSettings getLevelIndex( "jeepride" );
//	if( getdvarint("mis_01") < levelindex+1  )
//		_setMissionDvar( "mis_01", levelIndex+1 );
	changelevel( "airplane", false );
}

coop_eog_summary()
{
	playerNum = 1;
	accuracy = [];
	difficulty = [];
	diffString[ 0 ] = "@MENU_RECRUIT";
	diffString[ 1 ] = "@MENU_REGULAR";
	diffString[ 2 ] = "@MENU_HARDENED";
	diffString[ 3 ] = "@MENU_VETERAN";

	//----------------------------------------------
	// Set all stat dvars so menu can display stats
	//----------------------------------------------

	foreach ( player in level.players )
	{
		// Names
		setdvar( "player_" + playerNum + "_name", player.playername );

		// Kills
		setdvar( "player_" + playerNum + "_kills", player.stats[ "kills" ] );

		// Difficulty
		difficultyIndex = difficulty.size;
		difficulty[ difficultyIndex ] = player get_player_gameskill();

		assert( isdefined( diffString[ difficulty[ difficultyIndex ] ] ) );
		setdvar( "player_" + playerNum + "_difficulty", diffString[ difficulty[ difficultyIndex ] ] );

		playerNum++ ;
	}

	// Time
	if ( !isdefined( level.challenge_start_time ) )
	{
		// If the mission never started, force it to a time of 0.
		level.challenge_start_time = 0;
		level.challenge_end_time = 0;
	}

	assertex( isdefined( level.challenge_start_time ), "Special Ops missions need to ensure level.challenge_start_time is set before displaying stats." );
	assertex( isdefined( level.challenge_end_time ), "Special Ops missions need to ensure level.challenge_end_time is set before displaying stats." );

	seconds = ( level.challenge_end_time - level.challenge_start_time ) / 1000;
	setdvar( "elapsed_mission_time", convert_to_time_string( seconds, true ) );

	// callback that sets custom data for eog summary
	if( isdefined( level.eog_summary_callback ) )
	{
		[[level.eog_summary_callback]]();
		// This is done afterwards to give the EOG summary the chance to set the flag saying no defaults.
		create_custom_eog_defaults();
	}
		
	if( isdefined( level.custom_eog_summary ) && level.custom_eog_summary )
		setdvar( "ui_eog_custom", 1 );
	else
		setdvar( "ui_eog_custom", 0 );
		
	//----------------------------------------------
	// Open summary menus on all players
	//----------------------------------------------

	// opens up end-of-game summary menu for player gameplay performance
	if ( is_coop() )
	{		
		reset_eog_popup_dvars();
		// setup eog popups that shows stars earned, unlocks, and new best time
		// player 1
		if( isdefined( level.player.eog_newstar ) && level.player.eog_newstar )
			setdvar( "ui_eog_player1_stars", level.player.eog_newstar_value );
			
		if( isdefined( level.player.eog_unlock ) && level.player.eog_unlock )
			setdvar( "ui_eog_player1_unlock", level.player.eog_unlock_value );		
	
		if( isdefined( level.player.eog_besttime ) && level.player.eog_besttime )
			setdvar( "ui_eog_player1_besttime", level.player.eog_besttime_value );	
		
		// player 2
		if( isdefined( level.player2.eog_newstar ) && level.player2.eog_newstar )
			setdvar( "ui_eog_player2_stars", level.player2.eog_newstar_value );
			
		if( isdefined( level.player2.eog_unlock ) && level.player2.eog_unlock )
			setdvar( "ui_eog_player2_unlock", level.player2.eog_unlock_value );		
	
		if( isdefined( level.player2.eog_besttime ) && level.player2.eog_besttime )
			setdvar( "ui_eog_player2_besttime", level.player2.eog_besttime_value );	

		wait 0.05;
		level.player openpopupmenu( "coop_eog_summary" );
		level.player2 openpopupmenu( "coop_eog_summary2" );
	}
	else
	{
		reset_eog_popup_dvars();
		
		// setup eog popups that shows stars earned, unlocks, and new best time
		if( isdefined( level.player.eog_newstar ) && level.player.eog_newstar )
			setdvar( "ui_eog_player1_stars", level.player.eog_newstar_value );
			
		if( isdefined( level.player.eog_unlock ) && level.player.eog_unlock )
			setdvar( "ui_eog_player1_unlock", level.player.eog_unlock_value );		
	
		if( isdefined( level.player.eog_besttime ) && level.player.eog_besttime )
			setdvar( "ui_eog_player1_besttime", level.player.eog_besttime_value );	
		
		wait 0.05;
		level.player openpopupmenu( "sp_eog_summary" );
	}
}

create_custom_eog_defaults()
{
	if ( isdefined( level.custom_eog_no_defaults ) && level.custom_eog_no_defaults )
		return;

	seconds = ( level.challenge_end_time - level.challenge_start_time ) / 1000;
	time_string = convert_to_time_string( seconds, true );
	foreach ( player in level.players )
	{
		eog_line = 1;
		if ( !isdefined( level.custom_eog_no_time ) || !level.custom_eog_no_time )
		{
			player set_custom_eog_summary( eog_line, 1, "@SPECIAL_OPS_UI_TIME" );
			player set_custom_eog_summary( eog_line, 2, time_string );
			eog_line++;
		}

		if ( !isdefined( level.custom_eog_no_skill ) || !level.custom_eog_no_skill )
		{
			player set_custom_eog_summary( eog_line, 1, "@SPECIAL_OPS_UI_DIFFICULTY" );
			switch( player.gameskill )
			{
				case 0:
				case 1:	player set_custom_eog_summary( eog_line, 2, "@MENU_REGULAR" ); break;
				case 2:	player set_custom_eog_summary( eog_line, 2, "@MENU_HARDENED" ); break;
				case 3:	player set_custom_eog_summary( eog_line, 2, "@MENU_VETERAN" ); break;
			}
			eog_line++;
		}

		if ( !isdefined( level.custom_eog_no_kills ) || !level.custom_eog_no_kills )
		{
			player set_custom_eog_summary( eog_line, 1, "@SPECIAL_OPS_UI_KILLS" );
			player set_custom_eog_summary( eog_line, 2, player.stats[ "kills" ] );
			eog_line++;
		}
	}
}

reset_eog_popup_dvars()
{
	setdvar( "ui_eog_player1_stars", "" );
	setdvar( "ui_eog_player1_unlock", "" );		
	setdvar( "ui_eog_player1_besttime", "" );		
	setdvar( "ui_eog_player2_stars", "" );
	setdvar( "ui_eog_player2_unlock", "" );		
	setdvar( "ui_eog_player2_besttime", "" );			
}

get_contract_base_reward()
{
	assert( isdefined( level.script ) );

	stringTable_ref_column 				 = 1;
	stringTable_mapReward_column 		 = 10;
	stringTable_modeReward_column		 = 6;
	stringTable_densityReward_column	 = 6;

	reward_location = int( tablelookup( "sp/contractTable.csv", stringTable_ref_column, level.script, 				stringTable_mapReward_column ) );
	reward_mode 	 = int( tablelookup( "sp/contractTable.csv", stringTable_ref_column, getdvar( "pmc_gametype" ), 	stringTable_modeReward_column ) );
	reward_density 	 = int( tablelookup( "sp/contractTable.csv", stringTable_ref_column, getdvar( "pmc_difficulty" ), stringTable_densityReward_column ) );

	return( reward_location + reward_mode + reward_density );
}

get_combined_accuracy_modifier( accuracy1, accuracy2 )
{
	averageAccuracy = ( accuracy1 + accuracy2 ) / 2;

	if ( averageAccuracy == 100 )
		return 5.0;
	else if ( averageAccuracy >= 80 )
		return 4.0;
	else if ( averageAccuracy >= 70 )
		return 3.5;
	else if ( averageAccuracy >= 60 )
		return 3.0;
	else if ( averageAccuracy >= 50 )
		return 2.5;
	else if ( averageAccuracy >= 40 )
		return 2.0;

	return 1.0;
}

get_combined_difficulty_modifier( diff1, diff2 )
{
	diffMod[ 0 ] = int( tablelookup( "sp/contractTable.csv", 1, "0", 6 ) );
	diffMod[ 1 ] = int( tablelookup( "sp/contractTable.csv", 1, "1", 6 ) );
	diffMod[ 2 ] = int( tablelookup( "sp/contractTable.csv", 1, "2", 6 ) );
	diffMod[ 3 ] = int( tablelookup( "sp/contractTable.csv", 1, "3", 6 ) );

	// If both players play on the same difficuly then they get the full amount
	if ( diff1 == diff2 )
		return diffMod[ diff1 ];

	// If playing on seperate difficulties then take the average
	return( diffMod[ diff1 ] + diffMod[ diff2 ] ) / 2;
}

get_time_modifier( minutes )
{
	if ( minutes < 1 )
		return 4.0;
	else if ( minutes <= 2 )
		return 3.0;
	else if ( minutes <= 4 )
		return 2.0;

	return 1.0;
}

finalize_player_reward()
{
	foreach ( player in level.players )
		player giveMoney( "completion" );
}