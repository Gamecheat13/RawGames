#using scripts\shared\hud_message_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_cheat;
#using scripts\cp\_util;

        
                   


	
#namespace endmission;

function autoexec __init__sytem__() {     system::register("endmission",&__init__,undefined,undefined);    }


function __init__()
{
	//levels order and details are only available in the levellookukp.csv file
	
	//create a thread to listen for the restart mission event - if we get this then it's the script responsibility to either restart the current level or map into the root level for a mission set
	thread restartmissionlistener();
}

/@
"Name: giveachievement_wrapper( <achievment>, [all_players] )"
"Summary: Gives an Achievement to the specified player"
"Module: Coop"
"MandatoryArg: <achievment>: The code string for the achievement"
"OptionalArg: [all_players]: If true, then give everyone the achievement"
"Example: player giveachievement_wrapper( "MAK_ACHIEVEMENT_RYAN" );"
"SPMP: singleplayer"
@/
function giveachievement_wrapper( achievement, all_players )
{
	if ( achievement == "" )
	{
		return;
	}

	if( !( cheat::is_cheating() ) )
	{
		if( isdefined( all_players ) && all_players )
		{
			players = GetPlayers();
			for( i = 0; i < players.size; i++ )
			{
				players[i] GiveAchievement( achievement );
			}
		}
		else
		{
			if( !IsPlayer( self ) )
			{
				/#println( "^1self needs to be a player for _utility::giveachievement_wrapper()" );#/
				return;
			}

			self GiveAchievement( achievement );
		}
	}
}

/@
"Name: get_story_stat( <stat_name> )"
"Summary: wrapper to increment a challenge stat"
"Module: Code Wrappers"
"CallOn: An player"
"MandatoryArg: <stat_name>: the string corresponding to the story event to grab"
"Example: "
"SPMP: singleplayer"
@/
function get_story_stat( str_stat_name )
{
	if( level.script == "frontend" )
	{
		return self GetDStat( "PlayerCareerStats", "storypoints", str_stat_name );
	}
	else
	{
		return self GetSessStat( "storypoints", str_stat_name );
	}
}

function restartmissionluilistener()
{
	while( true )
	{
		level.player waittill( "menuresponse", menu_action, action_arg );
	
		if( menu_action == "rts_action" && action_arg == "rts_restart_mission" )
		{
			strikeforce_decrement_unit_tokens();
			LUINotifyEvent( &"rts_restart_mission" );
			break;
		}
	}
}

function restartmissionlistener()
{
	while(1)
	{
		level waittill("restartmission");
		
		root_level=get_root_level(level.script);
		
//		InitChallengeStats( level.script ); // T7TODO - challenge support

// T7TODO - support fastrestart and changelevel
//		if (root_level==level.script)
//		{
//			//TODO: clear stats - this work needs to be done
//			FastRestart();
//		}
//		else
//		{
//			//TODO: clear stats - this work needs to be done
//			//launch different map
//			//TODO:  restore weapons from the initial set - this work needs to be done
//			ChangeLevel( root_level, false, 0 );
//		}
	}
}

function get_root_level(cur_level)
{
	root_level_index=TableLookup("gamedata/tables/cp/levelLookup.csv",1,cur_level,11);
	return TableLookup("gamedata/tables/cp/levelLookup.csv",0,root_level_index,1);
}

// This is called when the mission is done
// Handles all of the setup, achievements, and missionsuccess depending on what was setup above.
function nextmission()
{
	level.nextmission = true;
	level notify( "nextmission" );
	
	// CODER_MOD - JamesS - no more level.player
	//level.player enableinvulnerability(); 	
	players = GetPlayers(); 
	for( i = 0; i < players.size; i++ )
	{
		players[i] notify( "check_challenge" );		
		
		// TODO T7 - _laststand.gsc has been removed during cleanup pass
//		if( players[i] laststand::player_is_in_laststand() )	// revive the player if they are in last stand - to avoid mission fail during mission success screen.
//		{
//			players[i] notify("player_revived");
//			_utility::setClientSysState("lsm", "0", players[i]);
//		}

		players[i] EnableInvulnerability(); 
	}

	cur_level = int(TableLookup("gamedata/tables/cp/levelLookup.csv",1,level.script,0));
	
	hud_message::waitTillNotifiesDone();
	
	SetDvar( "skipto", "default" );
	
	if( !isdefined( cur_level ) )
	{
//		_cooplogic::endGame(); // TODO T7 - _cooplogic.gsc has been removed during cleanup pass
		return;
	}
		
	dostat=int(TableLookup("gamedata/tables/cp/levelLookup.csv",0,cur_level,16)); 
	
	complete_level( cur_level, dostat );

	set_next_level( cur_level, dostat );

//	UpdateGamerProfile(); // T7TODO - code support for updatemgamerprofile
}

function complete_level( cur_level, dostat )
{
	mission_name=TableLookup("gamedata/tables/cp/levelLookup.csv",0,cur_level,2); 
	
	level_complete_achievement=TableLookup("gamedata/tables/cp/levelLookup.csv",0,cur_level,10);
	
	update_level_completed( mission_name );
	
	if( isdefined(level_complete_achievement) && level_complete_achievement!="")
	{
		players = GetPlayers(); 
		players[0] giveachievement_wrapper(level_complete_achievement); 
	}

	level_veteran_achievement = TableLookup("gamedata/tables/cp/levelLookup.csv",0,cur_level,12);

	// iprintlnbold("checking veteran achievement " + level_veteran_achievement + " completed " + mission_name + " at " + level.gameskill + "\n" );

	if( isdefined(level_veteran_achievement) && level_veteran_achievement != "" && level.gameskill==3 && check_other_hasLevelVeteranAchievement(cur_level) )
	{
		players = GetPlayers(); 
		players[0] giveachievement_wrapper( level_veteran_achievement );
		if ( check_other_veteranCompletion(cur_level) )
		{
			players[0] giveachievement_wrapper( "SP_RTS_CARRIER" );
		}
	}
	
	//preserve the last aar mapname because if its a tutorial map it needs this to know what to launch
	level.postTutMission=GetDvarString("ui_aarmapname");
	
	//if the next level is the end of a mission chain
	SetDvar( "ui_aarmapname", level.script );
	if( dostat!=0 ) 
	{
		//this dvar prevents quit and save events from overwriting the save game state
		if (GetDvarInt("ui_singlemission")==0)
			SetDvar( "ui_dofrontendsave", 1 ); 
		
		if( !cheat::is_cheating() && GetDvarString( "mis_cheat" ) != "1" )
		{
			check_for_achievements( mission_name );
			//DoSPLevelWrapup(); // T7TODO
		}
	}
}

function check_for_achievements( mission_name )
{
	player = GetPlayers()[0];
	
	cur_level_type = TableLookup("gamedata/tables/cp/levelLookup.csv",2,mission_name,8);
	
	// Item based
	if( !player IsStartingClassDefault( mission_name ) && cur_level_type != "RTS" && cur_level_type != "TUT" )
	{
		player giveachievement_wrapper( "SP_MISC_WEAPONS" );
	}
//	if( !player IsStartingClassEraAppropriate() && cur_level_type != "RTS" && cur_level_type != "TUT" )
//	{
//		player giveachievement_wrapper( ERA_LOADOUT_ACHIEVEMENT );
//	}
}

function check_for_achievements_frontend( levelName )
{
	player = GetPlayers()[0];
	
	mission_name = TableLookup( "gamedata/tables/cp/levelLookup.csv",1, levelName, 2 );
	cur_level_type = TableLookup("gamedata/tables/cp/levelLookup.csv",2,mission_name,8);
	
	if( cur_level_type == "TUT" )
	{
		return;
	}
	
	// Score based
	if( player AreAllMissionsAtScore( 10000 ) )
	{
		player giveachievement_wrapper( "SP_MISC_10K_SCORE_ALL" );
	}
	
	// Challenge based
	currChallenges = player GetNumChallengesComplete( mission_name );
	if( currChallenges > 0 )
	{
		player giveachievement_wrapper( "SP_ONE_CHALLENGE" );
	}
	if( currChallenges == 10 )
	{
		player giveachievement_wrapper( "SP_ALL_CHALLENGES_IN_LEVEL" );
		if( player HasCompletedAllGameChallenges() )
		{
			player giveachievement_wrapper( "SP_ALL_CHALLENGES_IN_GAME" );
		}
	}
	
	// Intel based
//	if( player HasAllIntel() && cur_level_type != "RTS" )
//	{
//		player giveachievement_wrapper( ALL_INTEL_ACHIEVEMENT );
//	}
	
	//TODO:  add SF tokens for challenges: 1 token for every five challenges completed
}

function get_strikeforce_tokens_remaining()
{
	// default value 0 implies the stat is as yet unset, -1 implies all have been used.
	// NOTE: this is an incorrect assumption, unitsAvailable is an uint, and will never go negative
	saved_num = level.player GetDStat( "PlayerCareerStats", "unitsAvailable" );
	return saved_num;
}

function strikeforce_decrement_unit_tokens()
{
	// default value 0 implies the stat is as yet unset, -1 implies all have been used.
	saved_num = get_strikeforce_tokens_remaining();
	saved_num = saved_num - 1;
	
	level.player SetDStat( "PlayerCareerStats", "unitsAvailable", saved_num );
	
	return saved_num;
}

function strikeforce_increment_unit_tokens()
{
	// default value 0 implies the stat is as yet unset, -1 implies all have been used.
	saved_num = get_strikeforce_tokens_remaining();
	saved_num = saved_num + 1;

	level.player SetDStat( "PlayerCareerStats", "unitsAvailable", saved_num );
	
	return saved_num;
}

function is_any_new_strikeforce_maps(cur_level)
{
	m_rts_map_list=[];

	level_index=1;
	max_index=int(TableLookup("gamedata/tables/cp/levelLookup.csv",0,"map_count",1));
	num_territories_claimed = 0;
	
	while (level_index<max_index)
	{
		if (TableLookup("gamedata/tables/cp/levelLookup.csv",0,level_index,8)=="RTS")
		{
			start_index=int(TableLookup("gamedata/tables/cp/levelLookup.csv",0,level_index,13));
			
			if (cur_level==start_index+1)
			{
				if (!level.player get_story_stat(TableLookup("gamedata/tables/cp/levelLookup.csv",0,level_index,15)))
				{
					m_rts_map_list[m_rts_map_list.size]=TableLookup("gamedata/tables/cp/levelLookup.csv",0,level_index,1);
				}
			}
			
			territory = TableLookup("gamedata/tables/cp/levelLookup.csv",0,level_index,18);
			if (territory != "")
			{
				if (level.player get_story_stat(TableLookup("gamedata/tables/cp/levelLookup.csv",0,level_index,15)) != 0)
				{
					num_territories_claimed++;
				}
			}
		}
		level_index++;
	}


	// Right after Karma, you can take Chloe back.
	karma_captured = level.player get_story_stat( "KARMA_CAPTURED" );
	if ( karma_captured == 0 )
	{
		ArrayRemoveValue( m_rts_map_list, "so_rts_mp_socotra" );
	}
	
	// Right after Yemen, you can kill Zhao in Pakistan, if you have completed enough RTS maps.
	if ( num_territories_claimed < 3 )
	{
		ArrayRemoveValue( m_rts_map_list, "so_rts_mp_overflow" );
	}
	
	if (m_rts_map_list.size>0)
		return true;
	
	
	return false;
}

function get_strikeforce_available_level_list( cur_level )
{
	level.m_rts_map_list=[];
	
	/#
		if ( isdefined( level.m_strikeforce_override_list ) )
		{
			level.m_rts_map_list = level.m_strikeforce_override_list;
			return level.m_strikeforce_override_list;
		}
	#/
	
	// No tokens? No maps.
	tokens_remaining = get_strikeforce_tokens_remaining();
	if ( tokens_remaining <= 0 )
	{
		return level.m_rts_map_list;
	}

	level_index=1;
	max_index=int(TableLookup("gamedata/tables/cp/levelLookup.csv",0,"map_count",1));
	num_territories_claimed = 0;
	
	while (level_index<max_index)
	{
		if (TableLookup("gamedata/tables/cp/levelLookup.csv",0,level_index,8)=="RTS")
		{
			start_index=int(TableLookup("gamedata/tables/cp/levelLookup.csv",0,level_index,13));
			end_index=int(TableLookup("gamedata/tables/cp/levelLookup.csv",0,level_index,14));
			
			/#
				if ( ( isdefined( level.m_strikeforce_open_all ) && level.m_strikeforce_open_all ) )
				{
					level.m_rts_map_list[level.m_rts_map_list.size]=TableLookup("gamedata/tables/cp/levelLookup.csv",0,level_index,1);
					level_index++;
					continue;
				}
			#/
				
			if (cur_level>start_index && cur_level<end_index)
			{
				if (!level.player get_story_stat(TableLookup("gamedata/tables/cp/levelLookup.csv",0,level_index,15)))
				{
					level.m_rts_map_list[level.m_rts_map_list.size]=TableLookup("gamedata/tables/cp/levelLookup.csv",0,level_index,1);
				}
			}
			
			territory = TableLookup("gamedata/tables/cp/levelLookup.csv",0,level_index,18);
			if (territory != "")
			{
				if (level.player get_story_stat(TableLookup("gamedata/tables/cp/levelLookup.csv",0,level_index,15)) != 0)
				{
					num_territories_claimed++;
				}
			}
		}
		level_index++;
	}

	/#
		if ( ( isdefined( level.m_strikeforce_open_all ) && level.m_strikeforce_open_all ) )
			return level.m_rts_map_list;
	#/

	// Right after Karma, you can take Chloe back.
	karma_captured = level.player get_story_stat( "KARMA_CAPTURED" );
	if ( karma_captured == 0 )
	{
		ArrayRemoveValue( level.m_rts_map_list, "so_rts_mp_socotra" );
	}
	
	// Right after Yemen, you can kill Zhao in Pakistan, if you have completed enough RTS maps.
	if ( num_territories_claimed < 3 )
	{
		ArrayRemoveValue( level.m_rts_map_list, "so_rts_mp_overflow" );
	}
	
	// If we just came back from a map, make that one the first in the list.
	prev_map = TableLookup("gamedata/tables/cp/levelLookup.csv",0,cur_level,1);
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

function set_next_level( cur_level, dostat )
{
 	curr_map_type=TableLookup("gamedata/tables/cp/levelLookup.csv",0,cur_level,8);
	if (curr_map_type=="RTS")
		cur_level = level.player GetDStat( "PlayerStatsList", "HIGHESTLEVELCOMPLETED", "statValue" );

	next_level=cur_level+1;
	map_type=TableLookup("gamedata/tables/cp/levelLookup.csv",0,next_level,8);
	if (map_type!="CMP" && map_type!="DEV")
	{
		next_level=cur_level;
	}
	
	next_level_name=TableLookup("gamedata/tables/cp/levelLookup.csv",0,next_level,1);
	map_type=TableLookup("gamedata/tables/cp/levelLookup.csv",0,next_level,8);
		
	//if we have completed a campaign mission then we've earned a SF token (RTS mode handles this itself in _so_rts_rules.gsc)
	if (map_type=="CMP" && curr_map_type != "RTS" && curr_map_type != "TUT" && GetDvarInt("ui_singlemission")==0)
	{
		strikeforce_increment_unit_tokens();
	}

	rts_array=get_strikeforce_available_level_list( next_level );
//	SetDvar("ui_strikeforceavailable",is_any_new_strikeforce_maps(next_level));
	
	//for single missions, on the last level reset to the root mission name so we come back to the same mission in the mission select screen
	if (GetDvarInt( "ui_singlemission" ) != 0 && map_type!="DEV")
	{
		root_level=TableLookup("gamedata/tables/cp/levelLookup.csv",0,cur_level,11);
		next_level_name=TableLookup("gamedata/tables/cp/levelLookup.csv",0,root_level,1);
	}
		
// T7TODO - support for changelevel and setuinextlevel
//	SetUINextLevel( next_level_name );
//
//	if (map_type=="TUT")
//	{
//		SetDvar("ui_aarmapname",level.postTutMission );
//		SetUINextLevel( level.postTutMission );
//		ChangeLevel( level.postTutMission , false );
//	}
//	else if (GetDvarInt( "ui_singlemission" )==0 && next_level==cur_level)
//	{
//		//credits time
//		SetUINextLevel( "credits" );
//		ChangeLevel( "" );
//	}
//	else
//	{
//		if (map_type=="DEV")
//			ChangeLevel( next_level_name, !dostat );
//		else
//			ChangeLevel( "", !dostat );
//	}
}

function get_level_completed( mission_name )
{
	players = GetPlayers(); 
	return players[0] GetDStat( "PlayerLevelStats", mission_name, "highestDifficulty" );
}

function update_level_completed( mission_name )
{
	if (issubstr(mission_name,"tutorial"))
		return;
	
	if( get_level_completed(mission_name) > level.gameskill )
	{
		return; 
	}
	
	players = GetPlayers(); 
	players[0] SetSessStat( "PlayerSessionStats", "difficulty", level.gameskill );
}

function check_other_hasLevelVeteranAchievement( level_index )
{
	//check for other levels that have the same Hardened achievement.  
	//If they have it and other level has been completed at a hardened level check passes.
	
	count = int(TableLookup("gamedata/tables/cp/levelLookup.csv",0,"map_count",1));

	veteran_achievement = TableLookup("gamedata/tables/cp/levelLookup.csv", 0, level_index, 12);

	for( i=0; i<count; i++ )
	{
		if( i == level_index )
		{
			continue; 
		}

		level_vet_achievement = TableLookup("gamedata/tables/cp/levelLookup.csv", 0, i, 12);
		if( !isdefined(level_vet_achievement) )
		{
			continue; 
		}

		if( veteran_achievement == level_vet_achievement )
		{
			mission_name=TableLookup("gamedata/tables/cp/levelLookup.csv", 0, i, 2);
			if( !isdefined(mission_name) || mission_name == "" )
			{
				continue;
			}
			if( get_level_completed(mission_name) < 3 )
			{
				// iprintlnbold("no past/future veteran achievement due to " + mission_name + "\n" );
				return false; 
			}
		}
	}
	return true; 
}

function check_other_veteranCompletion( level_index )
{
	//check for or levels that have a Veteran achievement.  
	//If they have it and other level has been completed at a hardened level check passes.
	
	count = int(TableLookup("gamedata/tables/cp/levelLookup.csv",0,"map_count",1));

	for( i=0; i<count; i++ )
	{
		if( i == level_index )
		{
			continue; 
		}

		level_vet_achievement = TableLookup("gamedata/tables/cp/levelLookup.csv", 0, i, 12);
		if( !isdefined(level_vet_achievement) || level_vet_achievement == "" )
		{
			continue; 
		}

		mission_name=TableLookup("gamedata/tables/cp/levelLookup.csv", 0, i, 2);
		if( !isdefined(mission_name) || mission_name == "" )
		{
			continue;
		}

		if( get_level_completed(mission_name) < 3 )
		{
			// iprintlnbold("no full-game veteran achievement due to " + mission_name + "\n" );
			return false; 
		}
	}
	return true; 
}

function force_all_complete()
{
	/#println( "tada!" ); #/
	count=int(TableLookup("gamedata/tables/cp/levelLookup.csv",0,"map_count",1));
	for (i=0;i<count;i++)
	{
		mission_name=TableLookup("gamedata/tables/cp/levelLookup.csv", 0, i, 2);
		update_level_completed(mission_name);
	}
}

function clearall()
{
	players = GetPlayers();
	players[0] SetDStat( "PlayerStatsList", "HIGHESTLEVELCOMPLETED", "statValue", 0 );
}

