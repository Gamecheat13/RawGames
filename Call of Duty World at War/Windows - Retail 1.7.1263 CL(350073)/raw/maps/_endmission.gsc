#include maps\_utility; 
#include common_scripts\utility; 
#include maps\_laststand;

main()
{
	missionSettings = []; 

	// levels and missions are listed in order 
	missionIndex = 0; // only one missionindex( vignettes in CoD2, no longer exist but I'm going to use this script anyway because it's got good stuff in it. - Nate

	missionSettings = create_mission( undefined ); 
	// CODER_MOD: Austin (6/19/08): Added coop flag
	missionSettings add_level( "mak", 		false, "", 	true,	 	"MAK_VETERAN_ACHIEVEMENT",			"MAKIN_ACHIEVEMENT",		true ); 
	missionSettings add_level( "pel1", 		false, "", 	true, 		"PEL1_VETERAN_ACHIEVEMENT", 		"PELELIU_ACHIEVEMENT",		true ); 
	missionSettings add_level( "pel2", 		false, "", 	true, 		"PEL2_VETERAN_ACHIEVEMENT", 		"PELELIU_ACHIEVEMENT",		true );
	missionSettings add_level( "sniper", 	false, "", 	true, 		"SNIPER_VETERAN_ACHIEVEMENT", 		"BERLIN_ACHIEVEMENT",		false );
	missionSettings add_level( "see1", 		false, "", 	true, 		"SEE1_VETERAN_ACHIEVEMENT", 		"BERLIN_ACHIEVEMENT",		true );
	missionSettings add_level( "pel1a", 	false, "", 	true, 		"PEL1A_VETERAN_ACHIEVEMENT", 		"PELELIU_ACHIEVEMENT",		true ); 
	missionSettings add_level( "pel1b", 	false, "", 	true, 		"PEL1B_VETERAN_ACHIEVEMENT", 		"PELELIU_ACHIEVEMENT",		true ); 
	missionSettings add_level( "see2", 		false, "", 	true, 		"SEE2_VETERAN_ACHIEVEMENT", 		"BERLIN_ACHIEVEMENT",		true );
	missionSettings add_level( "ber1", 		false, "", 	true, 		"BER1_VETERAN_ACHIEVEMENT", 		"BERLIN_ACHIEVEMENT",		true );
	missionSettings add_level( "ber2", 		false, "", 	true, 		"BER2_VETERAN_ACHIEVEMENT", 		"BERLIN_ACHIEVEMENT",		true );
	missionSettings add_level( "pby_fly", 	false, "", 	true, 		"PBY_FLY_VETERAN_ACHIEVEMENT", 		"OKINAWA_ACHIEVEMENT",		false );
	missionSettings add_level( "oki2", 		false, "", 	true, 		"OKI2_VETERAN_ACHIEVEMENT", 		"OKINAWA_ACHIEVEMENT",		true );
	missionSettings add_level( "oki3", 		false, "", 	true, 		"OKI3_VETERAN_ACHIEVEMENT", 		"OKINAWA_ACHIEVEMENT",		true );
	missionSettings add_level( "ber3", 		false, "", 	true, 		"BER3_VETERAN_ACHIEVEMENT", 		"BERLIN_ACHIEVEMENT",		true );
	missionSettings add_level( "ber3b", 	false, "", 	true, 		"BER3B_VETERAN_ACHIEVEMENT", 		"BERLIN_ACHIEVEMENT",		true );
	if ( !is_german_build() ) 
		missionSettings add_level( "outro", 	false );
	missionSettings add_level( "credits", 	false );

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
		level thread maps\_arcadeMode::arcadeMode_ends( level_index ); 
		flag_wait( "arcademode_ending_complete" ); 
	}
	else
	{
		//CODER MOD: TKeegan
		//process challanges in arcade mode are processed int the arcadeMode_ends() method
		maps\_challenges_coop::doMissionCallback( "levelEnd", level_index );
		maps\_hud_message::waitTillNotifiesDone();
	}
	
	SetSavedDvar( "ui_nextMission", "1" ); 
	SetDvar( "ui_showPopup", "0" ); 
	SetDvar( "ui_popupString", "" ); 
	
	// MikeD( 12/17/2007 ): AA( auto Adjust ) was abandoned by IW.
//	maps\_gameskill::auto_adust_zone_complete( "aa_main_" + level.script ); 
	
	if( !IsDefined( level_index ) )
	{
		return; 
	}
		
	maps\_utility::level_end_save(); 

	if ( !coopGame() )
	{
		// update mission difficult dvar
		level.missionSettings set_level_completed( level_index ); 
       
		if( GetDvarInt( "mis_01" ) < level_index + 1 )
		{
			set_mission_dvar( "mis_01", level_index + 1 ); 
		}

		if( GetDvarInt( "mis_01" ) == GetDvarInt( "mis_01_unlock" ) && ( GetDvar( "language" ) != "german" || GetDvar( "allow_zombies_german" ) == "1" ) )
		{
			SetDvar( "ui_sp_unlock", "1" );
			set_mission_dvar( "mis_01", (GetDvarInt( "mis_01_unlock" ) + 1) );
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
		
		// Completed mission on Hardened
		if( level.missionSettings has_mission_hardened_award() && level.missionSettings get_lowest_skill() > 2 )
		{
			players[0] giveachievement_wrapper( level.missionSettings get_hardened_award()); 
		}

		// Completed Campaign Achievement
		if( level.missionSettings has_campaign( level_index ) && level.missionSettings is_campaign_complete( level_index ) )
		{
			players[0] giveachievement_wrapper( level.missionSettings get_campaign( level_index ) );
		}
	}

	// CODER_MOD: Austin (7/30/08): Added co-op campaign achievements
	if ( getdvar( "onlinegame" ) == "1" && !arcadeMode() )
	{
		giveachievement_wrapper( "COOP_ACHIEVEMENT_CAMPAIGN", true );
	}
	if ( getdvar( "onlinegame" ) == "1" && arcadeMode() )
	{
		giveachievement_wrapper( "COOP_ACHIEVEMENT_COMPETITIVE", true );
		
		if ( players.size == 4 )
		{
			highest_score = -99999;
			highest = 0;
			for( i = 0; i < players.size; i++ )
			{
				if ( players[i].score > highest_score )
				{
					highest = i;
					highest_score = players[i].score;
				}
			}
			
			players[highest] giveachievement_wrapper( "COOP_ACHIEVEMENT_HIGHSCORE", false );
		}
	}

	//weapon achievement checks	
	for( i = 0; i < players.size; i++ )
	{
		//Only used the Flamethrower
		
		weaps = [];
		weaps[0] = "m2_flamethrower";
		weaps[1] = "m2_flamethrower_wet";
		if ( players[i] hasusedweapon(weaps, true) )
		{
			players[i] giveachievement_wrapper( "ANY_ACHIEVEMENT_FTONLY", false );
		}
		//didnt fire a shot
		if ( get_level_completed( level_index )>1 )//normal or greater
		{
			if ( !coopGame() && !IsSplitscreen() )
			{
				weaps = [];
				weaps[0] = "none";
				if ( players[i] hasusedweapon(weaps, true) )
				{
					players[i] giveachievement_wrapper( "ANY_ACHIEVEMENT_NOWEAPS", false );
				}
			}
		}
	}
	if ( !coopGame() && !IsSplitscreen() && level.gameSkill >= 2 )
	{
		if ( getnumrestarts() <= 1 )
		{
			players[0] giveachievement_wrapper( "ANY_ACHIEVEMENT_NODEATH", false );
		}
	}	
	
	nextlevel_index = level.missionSettings.levels.size; 

	nextlevel_index = level_index + 1;

	// ***Uncomment the line below if you want to just go back to the main menu for certain builds.
	// ChangeLevel( "" );

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
					maps\_cooplogic::endGame();
				else
					exitLevel( false );
				
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
		if( level.missionSettings skip_success( level_index ) )
		{
			ChangeLevel( level.missionSettings get_level_name( nextlevel_index ), level.missionSettings get_keep_weapons( level_index ) ); 
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
				continue;
			if ( level.missionSettings get_level_name( i ) == "outro" )
				continue;
			if ( level.missionSettings get_level_name( i ) == "nazi_zombie_prototype" )
				continue;
				
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
			players[0] giveachievement_wrapper( "WON_THE_WAR" ); 
		}
		if ( hardcore_award )
		{
			players[0] giveachievement_wrapper( "WON_THE_WAR_HARDCORE" ); 
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
	return Int( GetDvar( "mis_difficulty" )[level_index] ); 
}

set_level_completed( level_index )
{
	levelOffset = level_index;

	missionString = GetDvar( "mis_difficulty" ); 
	
	if( Int( missionString[levelOffset] ) > level.gameskill )
	{
		return; 
	}
		
	newString = ""; 
	gameskill = level.gameskill; 
	

	for( index = 0; index < missionString.size; index++ )
	{
		if( index != levelOffset )
		{
			newString += missionString[index]; 
		}
		else
		{
			newString += gameskill + 1; 
		}
	}
	set_mission_dvar( "mis_difficulty", newString );
}

// Sets the mission dvars accordingly.
set_mission_dvar( dvar, string )
{
	if( maps\_cheat::is_cheating() || flag( "has_cheated" ) )
	{
		return; 
	}

	if( GetDvar( "mis_cheat" ) == "1" )
	{
		return; 
	}
	SetMissionDvar( dvar, string );
}


get_level_skill( level_index )
{
	levelOffset = level_index; 
	
	missionString = GetDvar( "mis_difficulty" ); 
	return( Int( missionString[levelOffset] ) ); 
}


//updateMissionDvar( level_index )
//{
//	missionDvar = get_mission_dvar(); 
//		
//	lowestSkill = self get_lowest_skill(); 
//
//	if( lowestSkill )
//		SetMissionDvar( missionDvar, ( lowestSkill + 9 ) ); 
//	else if( level_index + 1 > GetDvarInt( missionDvar ) )
//		SetMissionDvar( missionDvar, level_index + 1 ); 
//}

get_mission_dvar( missionIndex )
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


get_lowest_skill()
{
	missionString = GetDvar( "mis_difficulty" ); 
	lowestSkill = 4; 
		
	for( index = 0; index < self.levels.size; index++ )
	{
		if( Int( missionString[index] ) < lowestSkill )
		{
			lowestSkill = Int( missionString[index] ); 
		}
	}
	return( lowestSkill ); 
}

// Creates a struct that will contain all of the information needed to progress to the next levels
create_mission( HardenedAward )
{
	mission = SpawnStruct(); 
	mission.levels = []; 
//	mission.prereqs = []; // MikeD (12/21/2007): Currently not used
// 	mission.slideShow = slideShow; 
	mission.HardenedAward = HardenedAward; 
	return( mission ); 
}

// Add a level to the mission created above.
// CODER_MOD: Austin (6/19/08): Add coop flag
add_level( levelName, keepWeapons, achievement, skip_success, veteran_achievement, campaign, coop )
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
		return false;

	if ( self get_level_name( level_index ) == "outro" )
		return false;

	return self.levels[level_index].coop;
}

// CODER_MOD: Austin (8/26/08): return to first coop level if ber3b was finished
get_first_coop_index()
{
	for( i = 0; i < level.missionSettings.levels.size; i++ )
	{
		if ( self get_coop( i ) )
			return i;
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
	if( !IsDefined( self.levels[level_index].skip_success ) )
	{
		return false; 
	}
	return true; 
}


get_hardened_award()
{
	return( self.HardenedAward ); 
}


has_mission_hardened_award()
{
	if( IsDefined( self.HardenedAward ) )
	{
		return( true ); 
	}
	else
	{
		return( false ); 
	}
}

force_all_complete()
{
	println( "tada!" ); 
	missionString = GetDvar( "mis_difficulty" ); 
	newString = ""; 
	for( index = 0; index < missionString.size; index++ )
	{
		if( index < 20 )
		{
			newString += 2; 
		}
		else
		{
			newstring += 0; 
		}
	}
	SetMissionDvar( "mis_difficulty", newString ); 	
	SetMissionDvar( "mis_01", 20 );
}

clearall()
{
	SetMissionDvar( "mis_difficulty", "00000000000000000000000000000000000000000000000000" ); 	
	SetMissionDvar( "mis_01", 1 ); 	
}

credits_end()
{
	if( GetDvar( "credits_frommenu" ) == "1" || coopGame() || isSplitScreen() || (GetDvar( "language" ) == "german" && GetDvar( "allow_zombies_german" ) == "0") ) 
	{
		if ( GetDvar( "credits_frommenu" ) == "1" || ( !coopGame() && !isSplitScreen() ) )
		{
			setDvar( "ui_skipMainLockout", 1 );
			setDvar( "credits_frommenu", 0 );
		}
		ChangeLevel( "" );
	}
	else
	{
		ChangeLevel( "nazi_zombie_prototype" );
	}
}
