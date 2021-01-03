#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\abilities\_ability_power;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

                                                                                                                                                                                    	   	  	
                                     

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
		player AddRankXp( event, weapon, isScoreEvent );
	}
	
	pixendevent();
	return scoreGiven;
}


function shouldAddRankXP( player )
{
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