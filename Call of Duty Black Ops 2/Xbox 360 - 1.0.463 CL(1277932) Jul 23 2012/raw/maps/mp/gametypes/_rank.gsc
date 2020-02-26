#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\_scoreevents;
#include maps\mp\gametypes\_hud_util;

#insert raw\maps\mp\_scoreevents.gsh;

init()
{
	level.scoreInfo = [];
	level.xpScale = GetDvarint( "scr_xpscale" );
	level.codPointsXpScale = GetDvarfloat( "scr_codpointsxpscale" );
	level.codPointsMatchScale = GetDvarfloat( "scr_codpointsmatchscale" );
	level.codPointsChallengeScale = GetDvarfloat( "scr_codpointsperchallenge" );
	level.rankXpCap = GetDvarint( "scr_rankXpCap" );
	level.codPointsCap = GetDvarint( "scr_codPointsCap" );	
	level.usingMomentum = true;
	level.usingScoreStreaks = GetDvarInt( "scr_scorestreaks" ) != 0;
	level.scoreStreaksMaxStacking = GetDvarInt( "scr_scorestreaks_maxstacking" );
	level.usingRampage = !IsDefined( level.usingScoreStreaks ) || !level.usingScoreStreaks;
	level.rampageBonusScale = GetDvarFloat( "scr_rampagebonusscale" );

	level.rankTable = [];

	precacheShader("white");

	precacheString( &"RANK_PLAYER_WAS_PROMOTED_N" );
	precacheString( &"RANK_PLAYER_WAS_PROMOTED" );
	precacheString( &"RANK_PROMOTED" );
	precacheString( &"MP_PLUS" );
	precacheString( &"RANK_ROMANI" );
	precacheString( &"RANK_ROMANII" );
	precacheString( &"MP_SCORE_KILL" );
	
	if( !SessionModeIsZombiesGame() )
	{
		initScoreInfo();
	}

	level.maxRank = int(tableLookup( "mp/rankTable.csv", 0, "maxrank", 1 ));
	level.maxPrestige = int(tableLookup( "mp/rankIconTable.csv", 0, "maxprestige", 1 ));
	
	pId = 0;
	rId = 0;
	for ( pId = 0; pId <= level.maxPrestige; pId++ )
	{
		// the rank icons are different
		for ( rId = 0; rId <= level.maxRank; rId++ )
			precacheShader( tableLookup( "mp/rankIconTable.csv", 0, rId, pId+1 ) );
	}

	rankId = 0;
	rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
	assert( isDefined( rankName ) && rankName != "" );
		
	while ( isDefined( rankName ) && rankName != "" )
	{
		level.rankTable[rankId][1] = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
		level.rankTable[rankId][2] = tableLookup( "mp/ranktable.csv", 0, rankId, 2 );
		level.rankTable[rankId][3] = tableLookup( "mp/ranktable.csv", 0, rankId, 3 );
		level.rankTable[rankId][7] = tableLookup( "mp/ranktable.csv", 0, rankId, 7 );
		level.rankTable[rankId][14] = tableLookup( "mp/ranktable.csv", 0, rankId, 14 );

		precacheString( tableLookupIString( "mp/ranktable.csv", 0, rankId, 16 ) );

		rankId++;
		rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );		
	}
	
	level thread onPlayerConnect();
}


initScoreInfo()
{
	scoreInfoTableID = getScoreEventTableID();
		
	assert( isdefined( scoreInfoTableID ) );
	if ( !IsDefined( scoreInfoTableID ) )
	{
		return;
	}
		
	scoreColumn = getScoreEventColumn( level.gameType );
	xpColumn = getXPEventColumn( level.gameType );

	assert( scoreColumn >= 0 );
	if ( scoreColumn < 0 )
	{
		return;
	}

	assert( xpColumn >= 0 );
	if ( xpColumn < 0 )
	{
		return;
	}
		
		
	for( row = 1; row < SCORE_EVENT_MAX_COUNT; row++ )
	{
		type = tableLookupColumnForRow( scoreInfoTableID, row, SCORE_EVENT_SCRIPT_REFERENCE );
		if ( type != "" )
		{
			labelString = tableLookupColumnForRow( scoreInfoTableID, row, SCORE_EVENT_SCORE_STRING );
			label = undefined;
			if ( labelString != "" ) 
			{
				label = tableLookupIString( scoreInfoTableID, 0, type, SCORE_EVENT_SCORE_STRING );

			}
			scoreValue = int( tableLookupColumnForRow( scoreInfoTableID, row, scoreColumn ) );
			registerScoreInfo( type, scoreValue, label );
			
			if ( maps\mp\_utility::getRoundsPlayed() == 0 )
			{
				xpValue = float( tableLookupColumnForRow( scoreInfoTableID, row, xpColumn ) );
					
				doubleXPString = tableLookupColumnForRow( scoreInfoTableID, row, SCORE_EVENT_DOUBLE_XP );
				if ( doubleXPString == "TRUE" )
				{
					xpValue = xpValue * level.xpScale;
				}
					
				RegisterXP( type, xpValue );
			}

			allowKillstreakWeapons = tableLookupColumnForRow( scoreInfoTableID, row, SCORE_EVENT_ALLOW_KILLSTREAK_WEAPONS );
			if ( allowKillstreakWeapons == "TRUE" )
			{
				level.scoreInfo[ type ][ "allowKillstreakWeapons" ] = true;
			}

			setDDLStat = tableLookupColumnForRow( scoreInfoTableID, row, SCORE_EVENT_SET_STATS );
			if ( setDDLStat == "TRUE" )
			{
				level.scoreInfo[ type ][ "setDDLStat" ] = true;
			}
		}
	}
}


getRankXPCapped( inRankXp )
{
	if ( ( isDefined( level.rankXpCap ) ) && level.rankXpCap && ( level.rankXpCap <= inRankXp ) )
	{
		return level.rankXpCap;
	}
	
	return inRankXp;
}

getCodPointsCapped( inCodPoints )
{
	if ( ( isDefined( level.codPointsCap ) ) && level.codPointsCap && ( level.codPointsCap <= inCodPoints ) )
	{
		return level.codPointsCap;
	}
	
	return inCodPoints;
}

isRegisteredEvent( type )
{
	if ( isDefined( level.scoreInfo[type] ) )
		return true;
	else
		return false;
}

registerScoreInfo( type, value, label )
{
	overrideDvar = "scr_" + level.gameType + "_score_" + type;	
	if ( getDvar( overrideDvar ) != "" )
	{
		value = getDvarInt( overrideDvar );
	}

	level.scoreInfo[type]["value"] = value;
	if ( IsDefined( label ) )
	{
		PrecacheString( label );
		level.scoreInfo[type]["label"] = label;
	}
}

getScoreInfoValue( type )
{
	if ( IsDefined( level.scoreInfo[type] ) )
	{
		return ( level.scoreInfo[type]["value"] );
	}
}

getScoreInfoLabel( type )
{
	return ( level.scoreInfo[type]["label"] );
}

killstreakWeaponsAllowedScore( type )
{
	if ( isDefined( level.scoreInfo[type]["allowKillstreakWeapons"] ) && level.scoreInfo[type]["allowKillstreakWeapons"] == true )
	{
		return true;
	}
	else
	{
		return false;
	}
}

doesScoreInfoCountTowardRampage( type )
{
	return IsDefined( level.scoreInfo[type]["rampage"] ) && level.scoreInfo[type]["rampage"];
}

getRankInfoMinXP( rankId )
{
	return int(level.rankTable[rankId][2]);
}

getRankInfoXPAmt( rankId )
{
	return int(level.rankTable[rankId][3]);
}

getRankInfoMaxXp( rankId )
{
	return int(level.rankTable[rankId][7]);
}

getRankInfoFull( rankId )
{
	return tableLookupIString( "mp/ranktable.csv", 0, rankId, 16 );
}

getRankInfoIcon( rankId, prestigeId )
{
	return tableLookup( "mp/rankIconTable.csv", 0, rankId, prestigeId+1 );
}

getRankInfoLevel( rankId )
{
	return int( tableLookup( "mp/ranktable.csv", 0, rankId, 13 ) );
}

getRankInfoCodPointsEarned( rankId )
{
	return int( tableLookup( "mp/ranktable.csv", 0, rankId, 17 ) );
}

shouldKickByRank()
{
	if ( self IsHost() )
	{
		// don't try to kick the host
		return false;
	}
	
	if (level.rankCap > 0 && self.pers["rank"] > level.rankCap)
	{
		return true;
	}
	
	if ( ( level.rankCap > 0 ) && ( level.minPrestige == 0 ) && ( self.pers["plevel"] > 0 ) )
	{
		return true;
	}
	
	if ( level.minPrestige > self.pers["plevel"] )
	{
		return true;
	}
	
	return false;
}

getCodPointsStat()
{
	codPoints = self GetDStat( "playerstatslist", "CODPOINTS", "StatValue" );
	codPointsCapped = getCodPointsCapped( codPoints );
	
	if ( codPoints > codPointsCapped )
	{
		self setCodPointsStat( codPointsCapped );
	}

	return codPointsCapped;
}

setCodPointsStat( codPoints )
{
	self SetDStat( "PlayerStatsList", "CODPOINTS", "StatValue", getCodPointsCapped( codPoints ) );
}

getRankXpStat()
{
	rankXp = self GetDStat( "playerstatslist", "RANKXP", "StatValue" );
	rankXpCapped = getRankXPCapped( rankXp );
	
	if ( rankXp > rankXpCapped )
	{
		self SetDStat( "playerstatslist", "RANKXP", "StatValue", rankXpCapped );
	}

	return rankXpCapped;
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );

		player.pers["rankxp"] = player getRankXpStat();
		player.pers["codpoints"] = player getCodPointsStat();
		player.pers["currencyspent"] = player GetDStat( "playerstatslist", "currencyspent", "StatValue" );
		rankId = player getRankForXp( player getRankXP() );
		player.pers["rank"] = rankId;
		player.pers["plevel"] = player GetDStat( "playerstatslist", "PLEVEL", "StatValue" );

		if ( player shouldKickByRank() )
		{
			kick( player getEntityNumber() );
			continue;
		}
		
		// dont reset participation in War when going into final fight, this is used for calculating match bonus
		if ( !isDefined( player.pers["participation"] ) || !( (level.gameType == "twar") && (0 < game["roundsplayed"]) && (0 < player.pers["participation"]) ) )
			player.pers["participation"] = 0;

		player.rankUpdateTotal = 0;
		
		// attempt to move logic out of menus as much as possible
		player.cur_rankNum = rankId;
		assert( isdefined(player.cur_rankNum), "rank: "+ rankId + " does not have an index, check mp/ranktable.csv" );
		
		prestige = player GetDStat( "playerstatslist", "plevel", "StatValue" );
		player setRank( rankId, prestige );
		player.pers["prestige"] = prestige;
		
		
		if ( !isDefined( player.pers["summary"] ) )
		{
			player.pers["summary"] = [];
			player.pers["summary"]["xp"] = 0;
			player.pers["summary"]["score"] = 0;
			player.pers["summary"]["challenge"] = 0;
			player.pers["summary"]["match"] = 0;
			player.pers["summary"]["misc"] = 0;
			player.pers["summary"]["codpoints"] = 0;
		}
		// set default popup in lobby after a game finishes to game "summary"
		// if player got promoted during the game, we set it to "promotion"
		if ( level.rankedMatch || level.wagerMatch || level.leagueMatch )
		{
			player setDStat( "AfterActionReportStats", "lobbyPopup", "none" );
		}
		
		if ( level.rankedMatch )
		{
			player SetDStat( "playerstatslist", "rank", "StatValue", rankId );
			player SetDStat( "playerstatslist", "minxp", "StatValue", getRankInfoMinXp( rankId ) );
			player SetDStat( "playerstatslist", "maxxp", "StatValue", getRankInfoMaxXp( rankId ) );
			player SetDStat( "playerstatslist", "lastxp", "StatValue", getRankXPCapped( player.pers["rankxp"] ) );				
		}
		
		player.explosiveKills[0] = 0;
		
		player thread onPlayerSpawned();
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
	}
}


onJoinedTeam()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_team");
		self thread removeRankHUD();
	}
}


onJoinedSpectators()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_spectators");
		self thread removeRankHUD();
	}
}


onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");
		
		/*if ( !IsDefined( self.hud_momentumupdate ) )
		{
			self.hud_momentumupdate = NewScoreHudElem(self);
			self.hud_momentumupdate.horzAlign = "center";
			self.hud_momentumupdate.vertAlign = "middle";
			self.hud_momentumupdate.alignX = "center";
			self.hud_momentumupdate.alignY = "middle";
	 		self.hud_momentumupdate.x = 0;
			if( self IsSplitscreen() )
				self.hud_momentumupdate.y = -72;
			else
				self.hud_momentumupdate.y = -117;
			self.hud_momentumupdate.baseY = self.hud_momentumupdate.y;
			self.hud_momentumupdate.font = "default";
			self.hud_momentumupdate.fontscale = 1.5;
			self.hud_momentumupdate.archived = false;
			self.hud_momentumupdate.color = (1,1,0.5);
			self.hud_momentumupdate.alpha = 0;
			self.hud_momentumupdate.sort = 50;
			self.hud_momentumupdate.overrridewhenindemo = true;
		}*/
		
		if(!isdefined(self.hud_rankscroreupdate))
		{
			self.hud_rankscroreupdate = NewScoreHudElem(self);
			self.hud_rankscroreupdate.horzAlign = "center";
			self.hud_rankscroreupdate.vertAlign = "middle";
			self.hud_rankscroreupdate.alignX = "center";
			self.hud_rankscroreupdate.alignY = "middle";
	 		self.hud_rankscroreupdate.x = 0;
			if( self IsSplitscreen() )
				self.hud_rankscroreupdate.y = -15;
			else
				self.hud_rankscroreupdate.y = -60;
			self.hud_rankscroreupdate.font = "default";
			self.hud_rankscroreupdate.fontscale = 2.0;
			self.hud_rankscroreupdate.archived = false;
			self.hud_rankscroreupdate.color = (1,1,0.5);
			self.hud_rankscroreupdate.alpha = 0;
			self.hud_rankscroreupdate.sort = 50;
			self.hud_rankscroreupdate maps\mp\gametypes\_hud::fontPulseInit();
			self.hud_rankscroreupdate.overrridewhenindemo = true;
		}
		
		/*if(!isdefined(self.hud_momentumreason))
		{
			self.hud_momentumreason = NewScoreHudElem(self);
			self.hud_momentumreason.horzAlign = "center";
			self.hud_momentumreason.vertAlign = "middle";
			self.hud_momentumreason.alignX = "center";
			self.hud_momentumreason.alignY = "middle";
	 		self.hud_momentumreason.x = 0;
			if( self IsSplitscreen() )
				self.hud_momentumreason.y = -32;
			else
				self.hud_momentumreason.y = -77;
			self.hud_momentumreason.font = "default";
			self.hud_momentumreason.fontscale = 1.5;
			self.hud_momentumreason.archived = false;
			self.hud_momentumreason.color = (1,1,1);
			self.hud_momentumreason.alpha = 0;
			self.hud_momentumreason.sort = 50;
			self.hud_momentumreason maps\mp\gametypes\_hud::fontPulseInit();
			self.hud_momentumreason.maxFontScale = 6.3;
			self.hud_momentumreason.outFrames = self.hud_momentumreason.inFrames + self.hud_momentumreason.outFrames;
			self.hud_momentumreason.inFrames = 0;
			self.hud_momentumreason.overrridewhenindemo = true;
		}*/
	}
}

incCodPoints( amount )
{
	if( !isRankEnabled() )
		return;

	if( !level.rankedMatch )
		return;

	newCodPoints = getCodPointsCapped( self.pers["codpoints"] + amount );
	if ( newCodPoints > self.pers["codpoints"] )
	{
		self.pers["summary"]["codpoints"] += ( newCodPoints - self.pers["codpoints"] );
	}
	self.pers["codpoints"] = newCodPoints;
	
	setCodPointsStat( int( newCodPoints ) );
}

atLeastOnePlayerOnEachTeam( )
{
	foreach( team in level.teams )
	{
		if ( !level.playerCount[team] )
			return false;
	}
	return true; 
}

giveRankXP( type, value, devAdd )
{
	self endon("disconnect");
	
	// TODO: will enable it after zombies ranking system is working
	if( SessionModeIsZombiesGame() )	
	{
		return;
	}

	if ( level.teamBased && (!atLeastOnePlayerOnEachTeam()) && !isDefined( devAdd ) )
		return;
	else if ( !level.teamBased && ( maps\mp\gametypes\_globallogic::totalPlayerCount() < 2) && !isDefined( devAdd ) )
		return;

	if( !isRankEnabled() )
		return;		

	pixbeginevent("giveRankXP");		

	if ( !isDefined( value ) )
		value = getScoreInfoValue( type );
	
	// Blackbox
	if( level.rankedMatch )
	{
		bbPrint( "mpplayerxp", "gametime %d, player %s, type %s, delta %d", getTime(), self.name, type, value );
	}
		
	// this switch statement should be inverted.  I am pretty sure there are fewer
	// things that we dont want to scale then there are that we do.	
	switch( type )
	{
		case "kill":
		case "headshot":
		case "assist":
		case "assist_25":
		case "assist_50":
		case "assist_75":
		case "helicopterassist":
		case "helicopterassist_25":
		case "helicopterassist_50":
		case "helicopterassist_75":
		case "helicopterkill":
		case "rcbombdestroy":
		case "spyplanekill":
		case "spyplaneassist":
		case "dogkill":
		case "dogassist":
		case "capture":
		case "defend":
		case "return":
		case "pickup":
		case "plant":
		case "defuse":
		case "destroyer":
		case "assault":
		case "assault_assist":
		case "revive":
		case "medal":
			value = int( value * level.xpScale );
			break;
		default:
			if ( level.xpScale == 0 )
				value = 0;
			break;
	}

	xpIncrease = self incRankXP( value );

	if ( level.rankedMatch && updateRank() )
		self thread updateRankAnnounceHUD();

	// Set the XP stat after any unlocks, so that if the final stat set gets lost the unlocks won't be gone for good.
	if ( value != 0 )
	{
		self syncXPStat();
	}

	if ( isDefined( self.enableText ) && self.enableText && !level.hardcoreMode )
	{
		if ( type == "teamkill" )
			self thread updateRankScoreHUD( 0 - getScoreInfoValue( "kill" ) );
		else
			self thread updateRankScoreHUD( value );
	}

	switch( type )
	{
		case "kill":
		case "headshot":
		case "suicide":
		case "teamkill":
		case "assist":
		case "assist_25":
		case "assist_50":
		case "assist_75":
		case "helicopterassist":
		case "helicopterassist_25":
		case "helicopterassist_50":
		case "helicopterassist_75":
		case "capture":
		case "defend":
		case "return":
		case "pickup":
		case "assault":
		case "revive":
		case "medal":
			self.pers["summary"]["score"] += value;
			incCodPoints( round_this_number( value * level.codPointsXPScale ) );
			break;

		case "win":
		case "loss":
		case "tie":
			self.pers["summary"]["match"] += value;
			incCodPoints( round_this_number( value * level.codPointsMatchScale ) );
			break;

		case "challenge":
			self.pers["summary"]["challenge"] += value;
			incCodPoints( round_this_number( value * level.codPointsChallengeScale ) );
			break;
			
		default:
			self.pers["summary"]["misc"] += value;	//keeps track of ungrouped match xp reward
			self.pers["summary"]["match"] += value;
			incCodPoints( round_this_number( value * level.codPointsMatchScale ) );
			break;
	}
	
	self.pers["summary"]["xp"] += xpIncrease;
	
	pixendevent();
}

round_this_number( value )
{
	value = int( value + 0.5 );
	return value;
}

updateRank()
{
	newRankId = self getRank();
	if ( newRankId == self.pers["rank"] )
		return false;

	oldRank = self.pers["rank"];
	rankId = self.pers["rank"];
	self.pers["rank"] = newRankId;

	// This function is a bit 'funny' - it decides to handle all of the unlocks for the current rank
	// before handling all of the unlocks for any new ranks - it's probably as a safety to handle the
	// case where unlocks have not happened for the current rank (which should only be the case for rank 0)
	// This will hopefully go away once the new ranking system is in place fully	
	while ( rankId <= newRankId )
	{	
		self SetDStat( "playerstatslist", "rank", "StatValue", rankId );
		self SetDStat( "playerstatslist", "minxp", "StatValue", int(level.rankTable[rankId][2]) );
		self SetDStat( "playerstatslist", "maxxp", "StatValue", int(level.rankTable[rankId][7]) );
	
		// tell lobby to popup promotion window instead
		self.setPromotion = true;
		if ( level.rankedMatch && level.gameEnded && !self IsSplitscreen() )
			self setDStat( "AfterActionReportStats", "lobbyPopup", "promotion" );
		
		// Don't add CoD Points for the old rank - only add when actually ranking up
		if ( rankId != oldRank )
		{
			codPointsEarnedForRank = getRankInfoCodPointsEarned( rankId );
			
			incCodPoints( codPointsEarnedForRank );
			
			
			if ( !IsDefined( self.pers["rankcp"] ) )
			{
				self.pers["rankcp"] = 0;
			}
			
			self.pers["rankcp"] += codPointsEarnedForRank;
		}

		rankId++;
	}
	self logString( "promoted from " + oldRank + " to " + newRankId + " timeplayed: " + self GetDStat( "playerstatslist", "time_played_total", "StatValue" ) );		

	self setRank( newRankId );

	if ( GameModeIsMode( level.GAMEMODE_BASIC_TRAINING ) && newRankId >= 9 )
	{
		self GiveAchievement( "MP_PLAY" );
	}
	
	return true;
}

updateRankAnnounceHud_internal( rank, prestige )
{
	size = self.rankNotifyQueue.size;
	self.rankNotifyQueue[size] = spawnstruct();
	
	display_rank_column = 14;
	self.rankNotifyQueue[size].rank = int( level.rankTable[ rank ][ display_rank_column ] );
	self.rankNotifyQueue[size].prestige = prestige;
	
	self notify( "received award" );
}

updateRankAnnounceHUD()
{
	self endon("disconnect");
	
	updateRankAnnounceHud_internal( self.pers["rank"], self.pers["prestige"] );
}

CodeCallback_RankUp( rank, prestige, unlockTokensAdded )
{
	self LUINotifyEvent( &"rank_up", 3, rank, prestige, unlockTokensAdded );
}

getItemIndex( refString )
{
	itemIndex = int( tableLookup( "mp/statstable.csv", 4, refString, 0 ) );
	assert( itemIndex > 0, "statsTable refstring " + refString + " has invalid index: " + itemIndex );
	
	return itemIndex;
}

endGameUpdate()
{
	player = self;			
}

updateRankScoreHUD( amount )
{
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	
	if ( IsDefined( level.usingMomentum ) && level.usingMomentum )
	{
		return; // Disabled because this is now handled in updateMomentumHUD function
	}

	if ( amount == 0 )
		return;

	self notify( "update_score" );
	self endon( "update_score" );

	self.rankUpdateTotal += amount;

	wait ( 0.05 );

	if( isDefined( self.hud_rankscroreupdate ) )
	{			
		if ( self.rankUpdateTotal < 0 )
		{
			self.hud_rankscroreupdate.label = &"";
			self.hud_rankscroreupdate.color = (0.73,0.19,0.19);
		}
		else
		{
			self.hud_rankscroreupdate.label = &"MP_PLUS";
			self.hud_rankscroreupdate.color = (1,1,0.5);
		}

		self.hud_rankscroreupdate setValue(self.rankUpdateTotal);

		self.hud_rankscroreupdate.alpha = 0.85;
		self.hud_rankscroreupdate thread maps\mp\gametypes\_hud::fontPulse( self );

		wait 1;
		self.hud_rankscroreupdate fadeOverTime( 0.75 );
		self.hud_rankscroreupdate.alpha = 0;
		
		self.rankUpdateTotal = 0;
	}
}

updateMomentumHUD( amount, reason, reasonValue )
{
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );

	if ( amount == 0 )
		return;

	self notify( "update_score" );
	self endon( "update_score" );
	
	self.rankUpdateTotal += amount;

	if( isDefined( self.hud_rankscroreupdate ) )
	{			
		if ( self.rankUpdateTotal < 0 )
		{
			self.hud_rankscroreupdate.label = &"";
			self.hud_rankscroreupdate.color = (0.73,0.19,0.19);
		}
		else
		{
			self.hud_rankscroreupdate.label = &"MP_PLUS";
			self.hud_rankscroreupdate.color = (1,1,0.5);
		}

		self.hud_rankscroreupdate setValue( self.rankUpdateTotal );

		self.hud_rankscroreupdate.alpha = 0.85;
		self.hud_rankscroreupdate thread maps\mp\gametypes\_hud::fontPulse( self );
		
		/*if ( IsDefined( self.hud_momentumupdate ) && ( amount != self.rankUpdateTotal ) )
		{
			self.hud_momentumupdate.label = &"MP_PLUS";
			self.hud_momentumupdate setValue( amount );
			self.hud_momentumupdate.alpha = 1;
			self.hud_momentumupdate.y = self.hud_momentumupdate.baseY;
			self.hud_momentumupdate FadeOverTime( 0.5 );
			self.hud_momentumupdate MoveOverTime( 0.5 );
			self.hud_momentumupdate.y -= 20;
			self.hud_momentumupdate.alpha = 0;
		}*/
		
		if ( IsDefined( self.hud_momentumreason ) )
		{
			if ( IsDefined( reason ) )
			{
				if ( IsDefined( reasonValue ) )
				{
					self.hud_momentumreason.label = reason;
					self.hud_momentumreason setValue( reasonValue );
				}
				else
				{
					/*self.hud_momentumreason.label = &"";
					self.hud_momentumreason SetText( reason );*/
					self.hud_momentumreason.label = reason;
					self.hud_momentumreason setValue( amount );
				}
				self.hud_momentumreason.alpha = 0.85;
				self.hud_momentumreason thread maps\mp\gametypes\_hud::fontPulse( self );
			}
			else
			{
				self.hud_momentumreason fadeOverTime( 0.01 );
				self.hud_momentumreason.alpha = 0;
			}
		}

		wait 1;
		self.hud_rankscroreupdate fadeOverTime( 0.75 );
		self.hud_rankscroreupdate.alpha = 0;
		
		if ( IsDefined( self.hud_momentumreason ) && IsDefined( reason ) )
		{
			self.hud_momentumreason fadeOverTime( 0.75 );
			self.hud_momentumreason.alpha = 0;	
		}
		
		wait 0.75;
		
		self.rankUpdateTotal = 0;
	}
}

removeRankHUD()
{
	if(isDefined(self.hud_rankscroreupdate))
		self.hud_rankscroreupdate.alpha = 0;
		
	if ( IsDefined( self.hud_momentumreason ) )
	{
		self.hud_momentumreason.alpha = 0;
	}
}

getRank()
{	
	rankXp = getRankXPCapped( self.pers["rankxp"] );
	rankId = self.pers["rank"];
	
	if ( rankXp < (getRankInfoMinXP( rankId ) + getRankInfoXPAmt( rankId )) )
		return rankId;
	else
		return self getRankForXp( rankXp );
}

getRankForXp( xpVal )
{
	rankId = 0;
	rankName = level.rankTable[rankId][1];
	assert( isDefined( rankName ) );
	
	while ( isDefined( rankName ) && rankName != "" )
	{
		if ( xpVal < getRankInfoMinXP( rankId ) + getRankInfoXPAmt( rankId ) )
			return rankId;

		rankId++;
		if ( isDefined( level.rankTable[rankId] ) )
			rankName = level.rankTable[rankId][1];
		else
			rankName = undefined;
	}
	
	rankId--;
	return rankId;
}

getSPM()
{
	rankLevel = self getRank() + 1;
	return (3 + (rankLevel * 0.5))*10;
}

getRankXP()
{
	return getRankXPCapped( self.pers["rankxp"] );
}

incRankXP( amount )
{
	if ( !level.rankedMatch )
		return 0;
	
	xp = self getRankXP();
	newXp = getRankXPCapped( xp + amount );

	if ( self.pers["rank"] == level.maxRank && newXp >= getRankInfoMaxXP( level.maxRank ) )
		newXp = getRankInfoMaxXP( level.maxRank );
		
	xpIncrease = getRankXPCapped( newXp ) - self.pers["rankxp"];
	
	if ( xpIncrease < 0 )
	{
		xpIncrease = 0;
	}

	self.pers["rankxp"] = getRankXPCapped( newXp );
	
	return xpIncrease;
}

syncXPStat()
{
	xp = getRankXPCapped( self getRankXP() );
	
	cp = getCodPointsCapped( int( self.pers["codpoints"] ) );
	
	self SetDStat( "playerstatslist", "rankxp", "StatValue", xp );
	
	self SetDStat( "playerstatslist", "codpoints", "StatValue", cp );
}
