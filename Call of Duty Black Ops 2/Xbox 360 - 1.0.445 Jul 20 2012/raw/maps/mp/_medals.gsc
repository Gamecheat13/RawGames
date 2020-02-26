#include maps\mp\_utility;
#include maps\mp\_scoreevents;
#include common_scripts\utility;

#insert raw\maps\mp\_scoreevents.gsh;

init()
{
	level.medalInfo = [];
	level.medalCallbacks = [];
	level.numKills = 0;
	
	scoreInfoTableID = getScoreEventTableID();
		
	assert( isdefined( scoreInfoTableID ) );
	if ( !IsDefined( scoreInfoTableID ) )
	{
		return;
	}
	
	xpEventColumn = getXPEventColumn( level.gameType );
	assert( xpEventColumn >= 0 );
	if ( xpEventColumn < 0 ) 
	{
		return;
	}

	baseRef = "";
	for( row = 1; row < SCORE_EVENT_MAX_COUNT; row++ )
	{
		type = tableLookupColumnForRow( scoreInfoTableID, row, SCORE_EVENT_SCRIPT_REFERENCE );
		if ( type != "" )
		{
			iString =  tableLookupIString( scoreInfoTableID, 0, type, SCORE_EVENT_MEDAL_REFERENCE );
			if ( !isdefined( iString ) || iString == &"" )
				continue;
			
			level.medalInfo[type] = [];
			level.medalInfo[type]["index"] = row;
			level.medalInfo[type]["xp"] = int ( tableLookupColumnForRow( scoreInfoTableID, row, xpEventColumn ) );
		}
	}
	
	level thread onPlayerConnect();
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		
		player.lastKilledBy = undefined;
		player thread hijackCrate();
		player thread hijackTeamCrate();
	}
}


addMedalToQueue( medalName )
{
	// send straight to LUA it is now handling the queuing
	self LUINotifyEvent( &"medal_received", 1, level.medalInfo[medalName]["index"] );
}


giveMedal( medalName, weapon, demoBookMarkAllowed )
{
	self endon("disconnect");

	if( !level.medalsEnabled )
		return;
		
	if( level.wagerMatch && GetDvar( "g_gametype" ) != "cp" )
		return;

	if ( self is_bot() )
		return;
	
	waittillframeend;

	self recordmedal(medalName);
	
	if ( isdefined ( level.medalInfo[medalName] ) )
	{

		xp = level.medalInfo[medalName]["xp"];
		
		if ( xp == 0 )
		{
			return;
		}

	//	if( level.rankedMatch )
	//	{
	//		self AddPlayerStat( "MEDALS", 1 );
	//	}

		[[level.onMedalAwarded]]( self, medalName, xp );
		

		addMedalToQueue( medalName );

		if ( isDefined( demoBookMarkAllowed ) && demoBookMarkAllowed )
			maps\mp\_demo::bookmark( "medal", gettime(), self );
	}
	else
	{
		/#
		iprintlnbold( "Error: " + medalName + " is not in medalTable.csv" );
		#/
	}
}

isMedal( medalName )
{
	if ( isdefined ( level.medalInfo[medalName] ) )
		return true;
	
	return false;
}

setLastKilledBy( attacker )
{
	self.lastKilledBy = attacker;
}

hijackCrate()
{
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	for (;;)
	{
		self waittill( "hijacked crate" );
	}
}

hijackTeamCrate()
{
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	for (;;)
	{
		self waittill( "team crate hijacked", crateType );
		level.globalSharePackages++;
		if ( isdefined (crateType.shareStat) )
		{
			self processMedal( crateType.shareStat );
			if ( maps\mp\_challenges::canProcessChallenges() )
			{
				self AddPlayerStat( "MEDAL_SHARE_PACKAGE", 1 );
			}
		}
	}
}



bomber()
{
	if ( isdefined( self.team ) && isdefined( level.teams[ self.team ] ) )
	{
		level.globalBombsDestroyedByTeam[ self.team ]++;
	}
}


offense( weapon )
{
	level.globalTeamMedals++;
}

defense( weapon )
{
	level.globalTeamMedals++;
}



revives()
{
	level.globalRevives++;
}


processMedal( medalName, weapon, allowKillstreakWeapon, demoBookMarkAllowed )
{
	if ( canProcessMedal() == false ) 
	{
		return;
	}
	
	self thread giveMedal( medalName, weapon, demoBookMarkAllowed );
	
	if ( setScoreInfoStat( medalName ) ) 
	{
		//iprintlnbold( "medalName: " + medalName );
		self AddPlayerStat( medalName, 1 );
	}
}

canProcessMedal()
{
	if ( level.leagueMatch )
	{
		return false;
	}
	
	return true;
}