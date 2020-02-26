#include maps\_utility; 
#include common_scripts\utility; 
#include maps\_laststand;

main()
{
	missionSettings = []; 

	// levels and missions are listed in order 
//	missionIndex = 0; // only one missionindex( vignettes in CoD2, no longer exist but I'm going to use this script anyway because it's got good stuff in it. - Nate

	missionSettings = create_mission( ); 
	//add_level( levelName, keepWeapons, achievement, skip_success, veteran_achievement, campaign, coop, skip_armory )

//	missionSettings add_level( "cuba",					false, "", true, "SP_VWIN_FLASHPOINT", 		"SP_WIN_CUBA", false );
//	missionSettings add_level( "so_narrative1_frontend",false, "", true, undefined, 				undefined, false );
//	missionSettings add_level( "vorkuta",				false, "", true, "SP_VWIN_FLASHPOINT", 		"SP_WIN_VORKUTA", false );
//	missionSettings add_level( "pentagon",				false, "", true, undefined, 				"SP_WIN_PENTAGON", false );
//	missionSettings add_level( "flashpoint",			false, "", true, "SP_VWIN_FLASHPOINT", 		"SP_WIN_FLASHPOINT", false );
//	missionSettings add_level( "so_narrative2_frontend",false, "", true, undefined, 				undefined, false );
//	missionSettings add_level( "khe_sanh",				false, "", true, "SP_VWIN_HUE_CITY", 		"SP_WIN_KHE_SANH", false );
//	missionSettings add_level( "hue_city", 				false, "", true, "SP_VWIN_HUE_CITY", 		"SP_WIN_HUE_CITY", false );
//	missionSettings add_level( "kowloon", 				false, "", true, "SP_VWIN_FULLAHEAD",		"SP_WIN_KOWLOON", false );
//	missionSettings add_level( "so_narrative3_frontend",false, "", true, undefined, 				undefined, false );
//	missionSettings add_level( "fullahead", 			false, "", true, "SP_VWIN_FULLAHEAD", 		"SP_WIN_FULLAHEAD", false );
//	missionSettings add_level( "creek_1", 				false, "", true, "SP_VWIN_FULLAHEAD", 		undefined, false );
//	missionSettings add_level( "so_narrative4_frontend",false, "", true, undefined, 				undefined, false );
//	missionSettings add_level( "river", 				false, "", true, "SP_VWIN_RIVER", 			"SP_WIN_RIVER", false );
//	missionSettings add_level( "wmd_sr71", 				false, "", true, "SP_VWIN_RIVER",	 		undefined, false );
//	missionSettings add_level( "wmd", 					false, "", true, "SP_VWIN_RIVER",	 		undefined, false );
//	missionSettings add_level( "pow", 					false, "", true, "SP_VWIN_RIVER",	 		undefined, false );
//	missionSettings add_level( "so_narrative5_frontend",false, "", true, undefined, 				undefined, false );
//	missionSettings add_level( "rebirth", 				false, "", true, "SP_VWIN_UNDERWATERBASE", 	undefined, false );
//	missionSettings add_level( "int_escape",			false, "", true, undefined, 				"SP_WIN_INTERROGATION_ESCAPE", false );
//	missionSettings add_level( "underwaterbase",		false, "", true, "SP_VWIN_UNDERWATERBASE",	undefined, false );
//	missionSettings add_level( "outro",					false, "", true, undefined,					undefined, false );

	//missionSettings add_level( "angola", false, "", true, undefined, undefined, false, false );
	//missionSettings add_level( "myanmar", false, "", true, undefined, undefined, false, false );
	missionSettings add_level( "afghanistan", false, "", true, undefined, undefined, false, false );
	//missionSettings add_level( "nicaragua", false, "", true, undefined, undefined, false, false );
	//missionSettings add_level( "pakistan", false, "", true, undefined, undefined, false, false );
	//missionSettings add_level( "hub", false, "", true, undefined, undefined, false, false );
	missionSettings add_level( "karma", true, "", true, undefined, undefined, false, true );
	missionSettings add_level( "karma_2", false, "", true, undefined, undefined, false, false );
	missionSettings add_level( "panama", true, "", true, undefined, undefined, false, true );
	missionsettings add_level( "panama_2", false, "", true, undefined, undefined, false, false );
	//missionSettings add_level( "hub", false, "", true, undefined, undefined, false, false );
	//missionSettings add_level( "antarctica", false, "", true, undefined, undefined, false, false );
	missionSettings add_level( "yemen", false, "", true, undefined, undefined, false, false );
	//missionSettings add_level( "hub", false, "", true, undefined, undefined, false, false );
	//missionSettings add_level( "command_center", false, "", true, undefined, undefined, false, false );
	missionSettings add_level( "la_1", true, "", true, undefined, undefined, false, true );
	missionSettings add_level( "la_1b", true, "", true, undefined, undefined, false, true );
	missionSettings add_level( "la_2", false, "", true, undefined, undefined, false, false );
	//missionSettings add_level( "bangalore", false, "", true, undefined, undefined, false, false );

	missionSettings add_level( "so_war_mp_dockside_war", false, "", true, undefined, undefined, false, false );

	//if ( !is_german_build() ) 
		//missionSettings add_level( "outro", 	false );
	//missionSettings add_level( "credits", 	false );

	level.missionSettings = missionSettings;
}


// This is called when the mission is done
// Handles all of the setup, achievements, and missionsuccess depending on what was setup above.
_nextmission()
{
	level.nextmission = true;

	// CODER_MOD - JamesS - no more level.player
	//level.player enableinvulnerability(); 	
	players = get_players(); 
	for( i = 0; i < players.size; i++ )
	{
		if(players[i] player_is_in_laststand())	// revive the player if they are in last stand - to avoid mission fail during mission success screen.
		{
			players[i] notify("player_revived");
			setClientSysState("lsm", "0", players[i]);
		}

		players[i] EnableInvulnerability(); 
	}

	level_index = level.missionSettings get_level_index( level.script ); 
	
	if( arcadeMode() )
	{
		level.arcadeMode_success = true;
		//level thread call_overloaded_func( "maps\_arcademode", "arcademode_ends", level_index );
		flag_wait( "arcademode_ending_complete" ); 
	}
	else
	{
		//CODER MOD: TKeegan
		//process challanges in arcade mode are processed int the arcadeMode_ends() method
		// removing coop challenges for now MGORDON		
		//maps\_challenges_coop::doMissionCallback( "levelEnd", level_index );
		maps\_hud_message::waitTillNotifiesDone();
	}
	
	SetSavedDvar( "ui_nextMission", "1" ); 
	SetDvar( "ui_showPopup", "0" ); 
	SetDvar( "ui_popupString", "" ); 
	
	// GavinL (7/29/2011): set skipto dvar to default to avoid problems where levels share skipto names
	// TravisJ (8/18/2011): removed devblocks since skipto dvar is saved and transferred between levels, but we can still use them in shipping builds through rex
	SetDvar( "skipto", "default" );
	
	
	// MikeD( 12/17/2007 ): AA( auto Adjust ) was abandoned by IW.
//	maps\_gameskill::auto_adust_zone_complete( "aa_main_" + level.script ); 
	
	if( !IsDefined( level_index ) )
	{
		maps\_cooplogic::endGame();
		return;
	}
		
	//maps\_utility::level_end_save(); 

	if ( !coopGame() )
	{
		// update mission difficult dvar
		level.missionSettings update_level_completed( level_index ); 

		if( GetLocalProfileInt( "missions_unlocked" ) < level_index + 1 )
		{
			set_mission_profilevar( "missions_unlocked", level_index + 1 ); 
		}

		if( GetLocalProfileInt( "missions_unlocked" ) == GetDvarint( "mis_01_unlock" ) && ( GetDvar( "language" ) != "german" || GetDvar( "allow_zombies_german" ) == "1" ) )
		{
			//SetDvar( "ui_sp_unlock", "1" );
			set_mission_profilevar( "missions_unlocked", (GetDvarint( "mis_01_unlock" ) + 1) );
		}
			
		UpdateGamerProfile(); 

		if( level.missionSettings has_achievement( level_index ) )
		{
			players[0] giveachievement_wrapper( level.missionSettings get_achievement( level_index )); 
		}
			
		if( level.missionSettings has_level_veteran_award( level_index ) && get_level_completed( level_index ) == 4 && level.missionSettings check_other_hasLevelVeteranAchievement( level_index ) )
		{
			players[0] giveachievement_wrapper( level.missionSettings get_level_veteran_award( level_index ) ); 
		}
		
		// Completed Campaign Achievement
		if( level.missionSettings has_campaign( level_index ) && level.missionSettings is_campaign_complete( level_index ) )
		{
			players[0] giveachievement_wrapper( level.missionSettings get_campaign( level_index ) );
		}
	}

	nextlevel_index = level.missionSettings.levels.size; 

	nextlevel_index = level_index + 1;

	// CODER_MOD: GMJ (7/29/08): Have splitscreen also skip non-coop levels.
	if ( coopGame() )
	{
		found = false;
		
		// CODER_MOD: Austin (6/19/08): Check coop flag and find the next level that is coop-enabled
		for ( ; nextlevel_index < level.missionSettings.levels.size; nextlevel_index++ )
		{
			if ( level.missionSettings get_coop( nextlevel_index ) )
			{
				found = true;
				break;
			}
		}

		// CODER_MOD: Austin (8/26/08): return to first coop level if ber3b was finished
		if ( !found )
		{
			nextlevel_index = level.missionSettings get_first_coop_index();
			assert( nextlevel_index >= 0 );
			assert( nextlevel_index < level.missionSettings.levels.size );

			if ( IsSplitScreen() )
			{
				// CODER_MOD: Austin (8/27/08): this will return to the title menu if ber3b is beaten in splitscreen
				// There seems to be no method for returning directly to the splitscreen lobby
				if( !arcadeMode() )
				{
					maps\_cooplogic::endGame();
				}
				else
				{
					exitLevel( false );
				}
				
				SetUINextLevel( level.missionSettings get_level_name( nextlevel_index ) );
				wait 1;
				return;
			}
		}
	}

	// if we are in coop mode and the level is over
	// we want to call the endgame and go back to the lobby
	if ( coopGame() && !IsSplitScreen() )
	{
		// CODER_MOD: TommyK (8/5/08)
		if( !arcadeMode() )
		{
			maps\_cooplogic::endGame();
		}
		else
		{
			exitLevel( false );
		}

		assert( nextlevel_index >= 0 );
		assert( nextlevel_index < level.missionSettings.levels.size );
		
		// change the map in the UI so when they get back to the lobbies
		// the next map is set already
		SetUINextLevel( level.missionSettings get_level_name( nextlevel_index ) );
		return;
	}	
	// CODER_MOD: Austin (8/1/2008): The below code is triggered incorrectly when playing a splitscreen game, since arcade mode scoring is always on (BUG 17800)
	/*if( arcadeMode() )
	{
		SetSavedDvar( "ui_nextMission", "0" ); 
		MissionSuccess( level.script ); 
		return; 
	}*/

	if ( !coopGame() || IsSplitScreen() )
	{
		if( !level.missionSettings skip_armory( level_index ) )
		{
			ChangeLevel( "" );
			SetAfterActionReportState(1);
			
			if( nextlevel_index < level.missionSettings.levels.size )
			{
				next_level_name = level.missionSettings get_level_name( nextlevel_index );
			}
			else
			{
				//setting the next level to the first level when we reach the end.
				next_level_name = level.missionSettings get_level_name( 0 );
			}
			SetUINextLevel( next_level_name );
		}
		else if( level.missionSettings skip_success( level_index ) )
		{
			if ( IsDefined( level.missionSettings.levels[ nextlevel_index ] ) )
			{
				ChangeLevel( level.missionSettings get_level_name( nextlevel_index ), level.missionSettings get_keep_weapons( level_index ) );
			}
			else
			{
				maps\_cooplogic::endGame();
				return;
			}
		}
		else
		{
			if( level.script == "credits" )
			{
				MissionSuccess( "credits", false ); 
			}
			else if ( level.script == "outro" )
			{
				MissionSuccess( "outro", false ); 
			}
			else
			{
				MissionSuccess( level.missionSettings get_level_name( nextlevel_index ), level.missionSettings get_keep_weapons( level_index ) ); 
			}
		}
	}
	//solo only
	if ( !coopGame() && !IsSplitScreen() )
	{
		// CODER MOD: KING - 07/30/08	
		//end of game achieves
		award = true;
		hardcore_award = true;
		for (i=0;i<level.missionSettings.levels.size;i++ )
		{
			if ( level.missionSettings get_level_name( i ) == "credits" )
			{
				continue;
			}
			if ( level.missionSettings get_level_name( i ) == "outro" )
			{
				continue;
			}
			if ( level.missionSettings get_level_name( i ) == "nazi_zombie_prototype" )
			{
				continue;
			}
				
			difficulty = get_level_completed( i );
			if ( difficulty == 0 )
			{
				award = false;
				hardcore_award = false;
				break;
			}
			//0 not played; 1-easy; 2-normal; 3-hardened; 4-FU
			if ( difficulty < 3 )
			{
				hardcore_award = false;
			}
		}
		if ( award )
		{
			// completed the game on any difficulty
			players[0] giveachievement_wrapper( "SP_WIN_UNDERWATERBASE" );
		}
		if ( hardcore_award )
		{
  			// BLACK OPS MASTER: completed the game on hardened or veteran
			players[0] giveachievement_wrapper( "SP_GEN_MASTER" );
		}
	}
}

prefetch_next()
{
	level_index = level.missionSettings get_level_index( level.script ); 
	if ( IsDefined( level_index ) )
	{
		nextlevel_index = level_index + 1;
		if( nextlevel_index < level.missionSettings.levels.size )
		{
			nextlevel_name = level.missionSettings get_level_name( nextlevel_index );
			if( issubstr( nextlevel_name, "so_narrative" ) )
			{
				nextlevel_index++;
				if( nextlevel_index < level.missionSettings.levels.size )
					prefetchLevel( level.missionSettings get_level_name( nextlevel_index ) );
			}
			else
			{
				prefetchLevel( nextlevel_name );
			}
		}
	}
}
 
//allMissionsCompleted( difficulty )
//{
//	difficulty += 10; 
//	for( index = 0; index < level.missionSettings.size; index++ )
//	{
//		missionDvar = get_mission_dvar( index ); 
//		if( GetDvarInt( missionDvar ) < difficulty )
//			return( false ); 
//	}
//	return( true ); 
//}

get_level_completed( level_index )
{
	return GetLocalProfileArrayInt( "missionHighestDifficulty", level_index );
}

update_level_completed( level_index )
{
	if( get_level_completed(level_index) > level.gameskill )
	{
		return; 
	}
	
	SetLocalProfileArrayVar( "missionHighestDifficulty", level_index, level.gameskill + 1 );
}

// Sets the mission dvars accordingly.
set_mission_profilevar( profilevar, string )
{
	if( maps\_cheat::is_cheating() || flag( "has_cheated" ) )
	{
		return; 
	}

	if( GetDvar( "mis_cheat" ) == "1" )
	{
		return; 
	}
	SetLocalProfileVar( profilevar, string );
}

// Creates a struct that will contain all of the information needed to progress to the next levels
create_mission( )
{
	mission = SpawnStruct(); 
	mission.levels = []; 
//	mission.prereqs = []; // MikeD (12/21/2007): Currently not used
// 	mission.slideShow = slideShow; 
	return( mission ); 
}

// Add a level to the mission created above.
add_level( levelName, keepWeapons, achievement, skip_success, veteran_achievement, campaign, coop, skip_armory )
{
	assert( IsDefined( keepweapons ) ); 
	level_index = self.levels.size; 
	self.levels[level_index] = SpawnStruct(); 
	self.levels[level_index].name = levelName; 
	self.levels[level_index].keepWeapons = keepWeapons; 
	self.levels[level_index].achievement = achievement; 
	self.levels[level_index].skip_success = skip_success; 
	self.levels[level_index].veteran_achievement = veteran_achievement;
	self.levels[level_index].campaign = campaign;
	self.levels[level_index].coop = coop;
	self.levels[level_index].skip_armory = skip_armory;
}

// MikeD (12/21/2007): Currently not used
//addPreReq( missionIndex )
//{
//	preReqIndex = self.prereqs.size; 
//	self.prereqs[preReqIndex] = missionIndex; 
//}

get_level_index( levelName )
{
	for( i = 0; i < self.levels.size; i++ )
	{
		if( self.levels[i].name != levelName )
		{
			continue; 
		}
			
		return( i ); 
	}
	return( undefined ); 
}

get_level_name( level_index )
{
	return( self.levels[level_index].name ); 
}

get_keep_weapons( level_index )
{
	return( self.levels[level_index].keepWeapons ); 
}

get_achievement( level_index )
{
	return( self.levels[level_index].achievement ); 
}

get_level_veteran_award( level_index )
{
	return( self.levels[level_index].veteran_achievement ); 
}

has_level_veteran_award( level_index )
{
	if( IsDefined( self.levels[level_index].veteran_achievement ) )
	{
		return( true ); 
	}
	else
	{
		return( false ); 
	}
}

has_achievement( level_index )
{
	if( IsDefined( self.levels[level_index].achievement ) )
	{
		return( true ); 
	}
	else
	{
		return( false ); 
	}
}

is_campaign_complete( level_index )
{
	// Get all of the levels with the same campaign
	campaign = self.levels[level_index].campaign;
	count = 0;
	complete_count = 0;
	for( i = 0; i < self.levels.size; i++ )
	{
		if( i == level_index )
		{
			continue; 
		}

		if( IsDefined( self.levels[i].campaign ) && IsDefined( campaign ) && self.levels[i].campaign == campaign )
		{
			count++;
			if( self get_level_completed( i ) > 0 )
			{
				complete_count++;
			}
		}
	}

	if( count == complete_count )
	{
		return true;
	}
	else
	{
		return false;
	}
}

get_campaign( level_index )
{
	return( self.levels[level_index].campaign ); 
}

// CODER_MOD: Austin (6/19/08): Return true if this level is coop enabled
get_coop( level_index )
{
	if ( self get_level_name( level_index ) == "credits" )
	{
		return false;
	}

	if ( self get_level_name( level_index ) == "outro" )
	{
		return false;
	}

	return self.levels[level_index].coop;
}

// CODER_MOD: Austin (8/26/08): return to first coop level if ber3b was finished
get_first_coop_index()
{
	for( i = 0; i < level.missionSettings.levels.size; i++ )
	{
		if ( self get_coop( i ) )
		{
			return i;
		}
	}

	return -1;
}

has_campaign( level_index )
{
	if( IsDefined( self.levels[level_index].campaign ) )
	{
		return( true ); 
	}
	else
	{
		return( false ); 
	}
}

check_other_hasLevelVeteranAchievement( level_index )
{
	//check for other levels that have the same Hardened achievement.  
	//If they have it and other level has been completed at a hardened level check passes.
	
	for( i = 0; i < self.levels.size; i++ )
	{
		if( i == level_index )
		{
			continue; 
		}

		if( ! has_level_veteran_award( i ) )
		{
			continue; 
		}

		if( self.levels[i].veteran_achievement == self.levels[level_index].veteran_achievement  )
		{
			if( get_level_completed( i ) < 4 )
			{
				return false; 
			}
		}
	}
	return true; 
}

skip_success( level_index )
{
	if ( !IsDefined( self.levels[level_index] ) || !IsDefined( self.levels[level_index].skip_success ) )
	{
		return false; 
	}
	
	return true; 
}

skip_armory( level_index )
{
	if( IsDefined( self.levels[level_index] ) && IsDefined( self.levels[level_index].skip_armory ) && self.levels[level_index].skip_armory )
	{
		return true;
	}
	
	return false;
}

force_all_complete()
{
	println( "tada!" ); 
	for( index = 0; index < level.missionSettings.levels.size; index++ )
	{
		update_level_completed( index );
	}
}

clearall()
{
	for( index = 0; index < level.missionSettings.levels.size; index++ )
	{
		SetLocalProfileArrayVar( "missionHighestDifficulty", index, "0" );
	}

	SetLocalProfileVar( "missions_unlocked", 1 ); 	
}

credits_end()
{
	/*
	if( GetDvar( "credits_frommenu" ) == "1" || coopGame() || isSplitScreen() || (GetDvar( "language" ) == "german" && GetDvar( "allow_zombies_german" ) == "0") ) 
	{
		if ( GetDvar( "credits_frommenu" ) == "1" || ( !coopGame() && !isSplitScreen() ) )
		{
			SetDvar( "ui_skipMainLockout", 1 );
			SetDvar( "credits_frommenu", 0 );
		}*/
		ChangeLevel( "" );
		/*
	}
	else
	{
	
	
		ChangeLevel( "nazi_zombie_prototype" );
	}*/
}
