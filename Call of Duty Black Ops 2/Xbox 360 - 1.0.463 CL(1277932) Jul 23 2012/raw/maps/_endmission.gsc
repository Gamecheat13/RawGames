#include maps\_utility; 
#include common_scripts\utility; 
#include maps\_laststand;

#insert raw\maps\level_progression.gsh;
#insert raw\maps\achievements.gsh;
	
#define DIFFICULTY_VETERAN					3

main()
{
	//levels order and details are only available in the levellookukp.csv file
	
	//create a thread to listen for the restart mission event - if we get this then it's the script responsibility to either restart the current level or map into the root level for a mission set
	thread restartmissionlistener();
}


restartmissionlistener()
{
	while(1)
	{
		level waittill("restartmission");
		
		root_level=get_root_level(level.script);
		
		if (root_level==level.script)
		{
			//TODO: clear stats - this work needs to be done
			FastRestart();
		}
		else
		{
			//TODO: clear stats - this work needs to be done
			//launch different map
			//TODO:  restore weapons from the initial set - this work needs to be done
			ChangeLevel( root_level, false, 0 );
		}
	}
}

get_root_level(cur_level)
{
	root_level_index=TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_NAME,cur_level,LEVEL_PROGRESSION_ROOT_LEVEL);
	return TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_INDEX,root_level_index,LEVEL_PROGRESSION_LEVEL_NAME);
}

// This is called when the mission is done
// Handles all of the setup, achievements, and missionsuccess depending on what was setup above.
_nextmission()
{
	level.nextmission = true;
	level notify( "nextmission" );

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

	cur_level = int(TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_NAME,level.script,LEVEL_PROGRESSION_LEVEL_INDEX));
	
	maps\_hud_message::waitTillNotifiesDone();
	
	SetDvar( "skipto", "default" );
	
	if( !IsDefined( cur_level ) )
	{
		maps\_cooplogic::endGame();
		return;
	}
		
	complete_level( cur_level );

	set_next_level( cur_level );

	UpdateGamerProfile(); 
}

complete_level( cur_level )
{
	mission=TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_INDEX,cur_level,LEVEL_PROGRESSION_MISSION); 
	dostat=int(TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_INDEX,cur_level,LEVEL_PROGRESSION_DOSTAT)); 
	
	level_complete_achievement=TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_INDEX,cur_level,LEVEL_PROGRESSION_ACHIEVEMENT);
	
	if( IsDefined(level_complete_achievement) && level_complete_achievement!="")
	{
		players = get_players(); 
		players[0] giveachievement_wrapper(level_complete_achievement); 
	}

	level_veteran_achievement = TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_INDEX,cur_level,LEVEL_PROGRESSION_VET_ACHIEVEMENT);

	if( IsDefined(level_veteran_achievement) && level_veteran_achievement != "" && get_level_completed(mission)==DIFFICULTY_VETERAN && level.missionSettings check_other_hasLevelVeteranAchievement(cur_level) )
	{
		players[0] giveachievement_wrapper( level_veteran_achievement ); 
	}

	//if the next level is the end of a mission chain
	SetDvar( "ui_aarmapname", level.script );
	if( dostat!=0 ) 
	{
		//this dvar prevents quit and save events from overwriting the save game state
		SetDvarInt( "ui_dofrontendsave", 1 );
		
		if( !maps\_cheat::is_cheating() && !flag( "has_cheated" ) && GetDvar( "mis_cheat" ) != "1" )
		{
			DoSPLevelWrapup();
		}
	}
}

check_for_achievements( mission )
{
	player = get_players()[0];
	// Score based
	if( player AreAllMissionsAtScore( SCORE_FOR_ACHIEVEMENT ) )
	{
		player giveachievement_wrapper( SCORE_ACHIEVEMENT );
	}
	
	// Item based
	if( !player IsStartingClassDefault( mission ) )
	{
		player giveachievement_wrapper( CUSTOM_LOADOUT_ACHIEVEMENT );
	}
	if( !player IsStartingClassEraAppropriate() )
	{
		player giveachievement_wrapper( ERA_LOADOUT_ACHIEVEMENT );
	}
	
	// Challenge based
	currChallenges = player GetNumChallengesComplete( mission );
	if( currChallenges > 0 )
	{
		player giveachievement_wrapper( ONE_CHALLENGE_ACHIEVEMENT );
	}
	if( currChallenges == CHALLENGES_PER_LEVEL )
	{
		player giveachievement_wrapper( ALL_CHALLENGES_IN_LEVEL_ACHIEVEMENT );
		if( player HasCompletedAllGameChallenges() )
		{
			player giveachievement_wrapper( ALL_CHALLENGES_IN_GAME_ACHIEVEMENT );
		}
	}
	
	// Intel based
	if( player HasAllIntel() )
	{
		player giveachievement_wrapper( ALL_INTEL_ACHIEVEMENT );
	}
	
	//TODO:  add SF tokens for challenges: 1 token for every five challenges completed
}

get_strikeforce_tokens_remaining()
{
	// default value 0 implies the stat is as yet unset, -1 implies all have been used.
	saved_num = level.player GetDStat( "PlayerCareerStats", "unitsAvailable" );
	if ( saved_num == 0 )
	{
		self SetDStat( "PlayerCareerStats", "unitsAvailable", 3 );
		return 3;
	}
	else if ( saved_num < 0 )
	{
		return 0;
	}
	else
	{
		return saved_num;
	}
}

strikeforce_decrement_unit_tokens()
{
	// default value 0 implies the stat is as yet unset, -1 implies all have been used.
	saved_num = get_strikeforce_tokens_remaining();
	saved_num = saved_num - 1;
	if ( saved_num <= 0 )
	{
		saved_num = -1;
	}

	Assert( saved_num != 0 );
	self SetDStat( "PlayerCareerStats", "unitsAvailable", saved_num );
	
	return saved_num;
}

strikeforce_increment_unit_tokens()
{
	// default value 0 implies the stat is as yet unset, -1 implies all have been used.
	saved_num = get_strikeforce_tokens_remaining();
	saved_num = saved_num + 1;
	if ( saved_num <= 0 )
	{
		saved_num = 1;
	}

	level.player SetDStat( "PlayerCareerStats", "unitsAvailable", saved_num );
	
	return saved_num;
}

get_strikeforce_available_level_list( cur_level )
{
	level.m_rts_map_list=[];
	
	// No tokens? No maps.
	tokens_remaining = level.player get_strikeforce_tokens_remaining();
	if ( tokens_remaining <= 0 )
	{
		return level.m_rts_map_list;
	}

	level_index=1;
	max_index=int(TableLookup(LEVEL_PROGRESSION_CSV,0,"map_count",1));
	num_maps_completed = 0;
	
	while (level_index<max_index)
	{
		if (TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_INDEX,level_index,LEVEL_PROGRESSION_MAPTYPE)=="RTS")
		{
			start_index=int(TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_INDEX,level_index,LEVEL_PROGRESSION_RTSSTART));
			end_index=int(TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_INDEX,level_index,LEVEL_PROGRESSION_RTSEND));
			if (cur_level>start_index && cur_level<end_index)
			{
				if (!level.player get_story_stat(TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_INDEX,level_index,LEVEL_PROGRESSION_RTSSTAT)))
				{
					level.m_rts_map_list[level.m_rts_map_list.size]=TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_INDEX,level_index,LEVEL_PROGRESSION_LEVEL_NAME);
				}
			}
			if (!level.player get_story_stat(TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_INDEX,level_index,LEVEL_PROGRESSION_RTSSTAT)))
			{
				num_maps_completed++;
			}
		}
		level_index++;
	}


	// Right after Karma, you can take Chloe back.
	karma_captured = level.player get_story_stat( "KARMA_CAPTURED" );
	if ( karma_captured == 0 )
	{
		ArrayRemoveValue( level.m_rts_map_list, "so_rts_mp_socotra" );
	}
	
	// Right after Yemen, you can kill Zhao in Pakistan, if you have completed enough RTS maps.
	if ( num_maps_completed < 3 )
	{
		ArrayRemoveValue( level.m_rts_map_list, "so_rts_mp_overflow" );
	}
	
	// If we just came back from a map, make that one the first in the list.
	prev_map = TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_INDEX,cur_level,LEVEL_PROGRESSION_LEVEL_NAME);
	if ( prev_map != "" )
	{
		last_map_index = undefined;
		for ( i = 0; i < level.m_rts_map_list.size; i++ )
		{
			if ( level.m_rts_map_list[i] == prev_map )
			{
				last_map_index = i;
				break;
			}
		}
		
		if ( isdefined( last_map_index ) )
		{
			level.m_rts_map_list[i] = level.m_rts_map_list[0];
			level.m_rts_map_list[0] = prev_map;
		}
	}
	
	return level.m_rts_map_list;
}

set_next_level( cur_level )
{
 	map_type=TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_INDEX,cur_level,LEVEL_PROGRESSION_MAPTYPE);
	if (map_type=="RTS")
		cur_level = level.player GetDStat( "PlayerStatsList", "HIGHESTLEVELCOMPLETED", "statValue" );

	next_level=cur_level+1;
	map_type=TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_INDEX,next_level,LEVEL_PROGRESSION_MAPTYPE);
	if (map_type!="CMP" && map_type!="DEV")
	{
		next_level=cur_level;
	}
	
	next_level_name=TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_INDEX,next_level,LEVEL_PROGRESSION_LEVEL_NAME);
	map_type=TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_INDEX,next_level,LEVEL_PROGRESSION_MAPTYPE);
		
	//if we have completed a mission then we've earned a SF token
	if (map_type=="CMP" && GetDvarInt("ui_singlemission")==0)
	{
		strikeforce_increment_unit_tokens();
	}

	rts_array=get_strikeforce_available_level_list( next_level );
	SetDvarInt("ui_strikeforceavailable",rts_array.size>0);
	
	//for single missions, on the last level reset to the root mission name so we come back to the same mission in the mission select screen
	if (GetDvarInt( "ui_singlemission" ) != 0 && map_type!="DEV")
	{
		root_level=TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_INDEX,cur_level,LEVEL_PROGRESSION_ROOT_LEVEL);
		next_level_name=TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_INDEX,root_level,LEVEL_PROGRESSION_LEVEL_NAME);
	}
		
	SetUINextLevel( next_level_name );


	if (GetDvarInt( "ui_singlemission" ) ==0 && next_level==cur_level)
	{
		//credits time
		SetUINextLevel( "credits" );
		ChangeLevel( "" );
	}
	else if (GetDvarInt( "ui_singlemission" ) ==0 && GetLocalProfileInt( "sp_cinematic_mode" ) == 1)
	{
		if (rts_array.size==0)
			ChangeLevel( next_level_name );
		else
			ChangeLevel( "" );
	}
	else
	{
		if (map_type=="DEV")
			ChangeLevel( next_level_name );
		else
			ChangeLevel( "" );
	}
}

prefetch_next()
{
	next_level_index=int(TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_NAME,level.script,LEVEL_PROGRESSION_LEVEL_INDEX))+1;
	level_name=TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_INDEX,next_level_index,LEVEL_PROGRESSION_LEVEL_NAME);
	prefetchLevel( level_name );
}
 
get_level_completed( mission_name )
{
	players = get_players(); 
	return players[0] GetDStat( "PlayerLevelStats", mission_name, "highestDifficulty" );
}

update_level_completed( mission_name )
{
	
	if( get_level_completed(mission_name) > level.gameskill )
	{
		return; 
	}
	
	players = get_players(); 
	players[0] SetDStat( "PlayerLevelStats", mission_name, "highestDifficulty", level.gameskill );
}

check_other_hasLevelVeteranAchievement( level_index )
{
	//check for other levels that have the same Hardened achievement.  
	//If they have it and other level has been completed at a hardened level check passes.
	
	count = int(TableLookup(LEVEL_PROGRESSION_CSV,0,"map_count",1));

	veteran_achievement = TableLookup(LEVEL_PROGRESSION_CSV, LEVEL_PROGRESSION_LEVEL_INDEX, level_index, LEVEL_PROGRESSION_VET_ACHIEVEMENT);

	for( i=0; i<count; i++ )
	{
		if( i == level_index )
		{
			continue; 
		}

		level_vet_achievement = TableLookup(LEVEL_PROGRESSION_CSV, LEVEL_PROGRESSION_LEVEL_INDEX, i, LEVEL_PROGRESSION_VET_ACHIEVEMENT);
		if( !isDefined(level_vet_achievement) )
		{
			continue; 
		}

		if( veteran_achievement == level_vet_achievement )
		{
			mission_name=TableLookup(LEVEL_PROGRESSION_CSV, LEVEL_PROGRESSION_LEVEL_INDEX, i, LEVEL_PROGRESSION_MISSION);
			if( get_level_completed(mission_name) < DIFFICULTY_VETERAN )
			{
				return false; 
			}
		}
	}
	return true; 
}

force_all_complete()
{
	/#println( "tada!" ); #/
	count=int(TableLookup(LEVEL_PROGRESSION_CSV,0,"map_count",1));
	for (i=0;i<count;i++)
	{
		mission_name=TableLookup(LEVEL_PROGRESSION_CSV, LEVEL_PROGRESSION_LEVEL_INDEX, i, LEVEL_PROGRESSION_MISSION);
		update_level_completed(mission_name);
	}
}

clearall()
{
	players = get_players();
	players[0] SetDStat( "PlayerStatsList", "HIGHESTLEVELCOMPLETED", "statValue", 0 );
}

