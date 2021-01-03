#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\gameskill_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

                                                                                                                                                                                     	   	                                                                      	  	  	
                                     


#namespace scoreevents;


function processScoreEvent( event, player, victim, weapon )
{
	pixbeginevent("processScoreEvent");
	
	scoreGiven = 0;
	if ( !isplayer(player) )
	{
		AssertMsg("processScoreEvent called on non player entity: " + event );				
		return scoreGiven;
	}

	if( GetDvarInt( "teamOpsEnabled" ) == 1 )
	{
		if ( isdefined( level.teamopsOnProcessPlayerEvent ) )
		{
			level [[level.teamopsOnProcessPlayerEvent]]( event, player );
		}
	}

	if ( isdefined( level.challengesOnEventReceived ) )
	{
		player thread [[level.challengesOnEventReceived]]( event );
	}	
	
	if ( isRegisteredEvent( event ) ) 
	{
		allowPlayerScore = false;
			
		if ( !isdefined( weapon ) || !killstreaks::is_killstreak_weapon( weapon ) ) 
		{	
			allowPlayerScore = true;
		}
		else
		{
			allowPlayerScore = killstreakWeaponsAllowedScore( event );
		}
	
		if ( allowPlayerScore )
		{
			if ( isdefined( level.scoreOnGivePlayerScore ) )
			{
				 scoreGiven = [[level.scoreOnGivePlayerScore]]( event, player, victim, undefined, weapon );
				 isScoreEvent = ( scoreGiven > 0 );

				 if ( isScoreEvent )
				 {
				 	hero_restricted = is_hero_score_event_restricted( event );
				 	
				 	player ability_power::power_gain_event_score( victim, scoreGiven, weapon, hero_restricted );
				 }				
			}			
		}		
	}
		
	if ( shouldAddRankXP( player ) && ( GetDvarInt( "teamOpsEnabled" ) == 0 ) )
	{
		pickedup = false;
		if( isdefined( weapon) )
		{
			pickedup = weapon.isPickedUp;
		}
		
		// In CP, the player earns an XP multiplier by playing on harder difficulties.
		if (SessionModeIsCampaignGame())
		{
			// Determine game difficulty. Player receives an XP multiplier for harder difficulties.
			xp_difficulty_multiplier = player gameskill::get_player_xp_difficulty_multiplier();
		}
		else
		{
			// No multiplier if not in CP.
			xp_difficulty_multiplier = 1;
		}
		
		player AddRankXp( event, weapon, player.class_num, pickedup, isScoreEvent, xp_difficulty_multiplier );
	}
	
	pixendevent();
	return scoreGiven;
}


function shouldAddRankXP( player )
{
	if( ( SessionModeIsCampaignZombiesGame() ) )
	{
		return false;
	}
		
	if ( !isdefined( level.rankCap ) || level.rankCap == 0 )
	{
		return true;
	}
	
	if ( ( player.pers[ "plevel" ] > 0 ) || ( player.pers[ "rank" ] > level.rankCap ) )
	{
		return false;
	}
	
	return true;
}


function uninterruptedObitFeedKills( attacker, weapon )
{
	self endon( "disconnect" );
	wait .1;
	util::WaitTillSlowProcessAllowed();
	wait .1;

	scoreevents::processScoreEvent( "uninterrupted_obit_feed_kills", attacker, self, weapon );
}


function isRegisteredEvent( type )
{
	if ( isdefined( level.scoreInfo[type] ) )
		return true;
	else
		return false;
}


function decrementLastObituaryPlayerCountAfterFade() 
{
	level endon( "reset_obituary_count" );
	wait( 5 );
	level.lastObituaryPlayerCount--;
	assert( level.lastObituaryPlayerCount >= 0 );
}

function getScoreEventTableName()
{
	if ( SessionModeIsCampaignGame() )
	{
		return "gamedata/tables/cp/scoreInfo.csv";
	}
	else if ( SessionModeIsZombiesGame() )
	{
		return "gamedata/tables/zm/scoreInfo.csv";
	}
	else
	{
		return "gamedata/tables/mp/scoreInfo.csv";
	}
}

function getScoreEventTableID()
{
	scoreInfoTableLoaded = false;
	scoreInfoTableID = TableLookupFindCoreAsset( getScoreEventTableName() );
		
	if ( isdefined( scoreInfoTableID ) )
	{
		scoreInfoTableLoaded = true;
	}
	assert( scoreInfoTableLoaded, "Score Event Table is not loaded: " + getScoreEventTableName() );
	return scoreInfoTableID;
}

function getScoreEventColumn( gameType )
{
	columnOffset = getColumnOffsetForGametype( gameType );
	assert( columnOffset >= 0 );
	if ( columnOffset >= 0 )
	{
		columnOffset += 0;
	}
	return columnOffset;	
}

function getXPEventColumn( gameType )
{
	columnOffset = getColumnOffsetForGametype( gameType );
	assert( columnOffset >= 0 );
	if ( columnOffset >= 0 )
	{
		columnOffset += 1;
	}
	return columnOffset;	
}

function getColumnOffsetForGametype( gameType )
{
	foundGameMode = false;
	if ( !isdefined ( level.scoreEventTableID ) ) 
	{
		level.scoreEventTableID = getScoreEventTableID();
	}

	assert( isdefined ( level.scoreEventTableID ) );
	if ( !isdefined ( level.scoreEventTableID ) ) 
	{
		return -1;
	}

	for ( gameModeColumn = 14; ; gameModeColumn += 2 )
	{
		column_header = TableLookupColumnForRow( level.scoreEventTableID, 0, gameModeColumn );
		if ( column_header == "" )
		{
			gameModeColumn = 14;
			break;
		}
		
		if ( column_header == level.gameType + " score" )
		{
			foundGameMode = true;
			break;
		}
	}
	
	assert( foundGameMode, "Could not find gamemode in scoreInfo.csv:" + gameType );
	return gameModeColumn;
}

function killstreakWeaponsAllowedScore( type )
{
	if( GetDvarInt( "teamOpsEnabled" ) == 1 )
		return false;
	
	if( isdefined( level.scoreInfo[type]["allowKillstreakWeapons"] ) && level.scoreInfo[type]["allowKillstreakWeapons"] == true )
	{
		return true;
	}
	else
	{
		return false;
	}
}

function is_hero_score_event_restricted( event )
{
	if( !isdefined( level.scoreInfo[event]["allow_hero"] ) || level.scoreInfo[event]["allow_hero"] != true )
	{
		return true;
	}
	
	return false;
}

function giveCrateCaptureMedal( crate, capturer )
{
	if ( isdefined( crate.owner ) && isplayer( crate.owner ) )
	{
		if ( level.teambased ) 
		{
			if ( capturer.team != crate.owner.team )
			{
				crate.owner playlocalsound( "mpl_crate_enemy_steals" );
				// don't give a medal for capturing a booby trapped crate
				if( !IsDefined( crate.hacker ) )
				{
					scoreevents::processScoreEvent( "capture_enemy_crate", capturer );
				}
			}
			else 
			{
				if ( isdefined ( crate.owner ) && ( capturer != crate.owner ) )
				{
					crate.owner playlocalsound( "mpl_crate_friendly_steals" );
					// don't give a medal for capturing a booby trapped crate
					if( !IsDefined( crate.hacker ) )
					{
						level.globalSharePackages++;
						scoreevents::processScoreEvent( "share_care_package", crate.owner );
					}
				}
			}
		}
		else
		{
			if ( capturer != crate.owner )
			{
				crate.owner playlocalsound( "mpl_crate_enemy_steals" );
				// don't give a medal for capturing a booby trapped crate
				if( !IsDefined( crate.hacker ) )
				{
					scoreevents::processScoreEvent( "capture_enemy_crate", capturer );
				}
			}
		}
	}
}