#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\gametypes\_globallogic;

#using scripts\mp\_scoreevents;
#using scripts\mp\_util;
#using scripts\mp\_teamops;

    
                                     

#precache( "material", "white" );
#precache( "string", "RANK_PLAYER_WAS_PROMOTED_N" );
#precache( "string", "RANK_PLAYER_WAS_PROMOTED" );
#precache( "string", "RANK_PROMOTED" );
#precache( "string", "MP_PLUS" );
#precache( "string", "RANK_ROMANI" );
#precache( "string", "RANK_ROMANII" );
#precache( "string", "MP_SCORE_KILL" );

#namespace rank;

function autoexec __init__sytem__() {     system::register("rank",&__init__,undefined,undefined);    }
	
function __init__()
{
	callback::on_start_gametype( &init );
}

function init()
{
	level.scoreInfo = [];
	level.xpScale = GetDvarFloat( "scr_xpscale" );
	level.codPointsXpScale = GetDvarfloat( "scr_codpointsxpscale" );
	level.codPointsMatchScale = GetDvarfloat( "scr_codpointsmatchscale" );
	level.codPointsChallengeScale = GetDvarfloat( "scr_codpointsperchallenge" );
	level.rankXpCap = GetDvarint( "scr_rankXpCap" );
	level.codPointsCap = GetDvarint( "scr_codPointsCap" );	
	level.usingMomentum = true;
	level.usingScoreStreaks = GetDvarInt( "scr_scorestreaks" ) != 0;
	level.scoreStreaksMaxStacking = GetDvarInt( "scr_scorestreaks_maxstacking" );
	level.maxInventoryScoreStreaks = GetDvarInt( "scr_maxinventory_scorestreaks", 3 );
	level.usingRampage = !isdefined( level.usingScoreStreaks ) || !level.usingScoreStreaks;
	level.rampageBonusScale = GetDvarFloat( "scr_rampagebonusscale" );

	level.rankTable = [];
	
	initScoreInfo();
	teamops::init();

	level.maxRank = int(tableLookup( "gamedata/tables/mp/mp_ranktable.csv", 0, "maxrank", 1 ));
	level.maxPrestige = int(tableLookup( "gamedata/tables/mp/mp_rankIconTable.csv", 0, "maxprestige", 1 ));
	
	rankId = 0;
	rankName = tableLookup( "gamedata/tables/mp/mp_ranktable.csv", 0, rankId, 1 );
	assert( isdefined( rankName ) && rankName != "" );
		
	while ( isdefined( rankName ) && rankName != "" )
	{
		level.rankTable[rankId][1] = tableLookup( "gamedata/tables/mp/mp_ranktable.csv", 0, rankId, 1 );
		level.rankTable[rankId][2] = tableLookup( "gamedata/tables/mp/mp_ranktable.csv", 0, rankId, 2 );
		level.rankTable[rankId][3] = tableLookup( "gamedata/tables/mp/mp_ranktable.csv", 0, rankId, 3 );
		level.rankTable[rankId][7] = tableLookup( "gamedata/tables/mp/mp_ranktable.csv", 0, rankId, 7 );
		level.rankTable[rankId][14] = tableLookup( "gamedata/tables/mp/mp_ranktable.csv", 0, rankId, 14 );

		rankId++;
		rankName = tableLookup( "gamedata/tables/mp/mp_ranktable.csv", 0, rankId, 1 );		
	}
	
	callback::on_connect( &on_player_connect );
}


function initScoreInfo()
{
	scoreInfoTableID = scoreevents::getScoreEventTableID();
		
	assert( isdefined( scoreInfoTableID ) );
	if ( !isdefined( scoreInfoTableID ) )
	{
		return;
	}
		
	scoreColumn = scoreevents::getScoreEventColumn( level.gameType );
	xpColumn = scoreevents::getXPEventColumn( level.gameType );

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
		
		
	for( row = 1; row < 512; row++ )
	{
		type = tableLookupColumnForRow( scoreInfoTableID, row, 0 );
		if ( type != "" )
		{
			labelString = tableLookupColumnForRow( scoreInfoTableID, row, 1 );
			label = undefined;
			if ( labelString != "" ) 
			{
				label = tableLookupIString( scoreInfoTableID, 0, type, 1 );

			}
			scoreValue = int( tableLookupColumnForRow( scoreInfoTableID, row, scoreColumn ) );
			registerScoreInfo( type, scoreValue, label );
			
			if ( !isdefined( game["ScoreInfoInitialized"] ) )
			{
				xpValue = float( tableLookupColumnForRow( scoreInfoTableID, row, xpColumn ) );
					
				setDDLStat = tableLookupColumnForRow( scoreInfoTableID, row, 8 );
				addPlayerStat = false;
				if ( setDDLStat == "TRUE" )
				{
					addPlayerStat = true;
				}
				isMedal = false;
				iString =  tableLookupIString( scoreInfoTableID, 0, type, 2 );
				if ( isdefined( iString ) && iString != &"" )
				{
					isMedal = true;
				}

				demoBookmarkPriority = int( tableLookupColumnForRow( scoreInfoTableID, row, 9 ) );
				if ( !isdefined( demoBookmarkPriority ) )
				{
					demoBookmarkPriority = 0;
				}

				RegisterXP( type, xpValue, addPlayerStat, isMedal, demoBookmarkPriority, row );
			}

			allowKillstreakWeapons = tableLookupColumnForRow( scoreInfoTableID, row, 5 );
			if ( allowKillstreakWeapons == "TRUE" )
			{
				level.scoreInfo[ type ][ "allowKillstreakWeapons" ] = true;
			}
			
			allowHero = tableLookupColumnForRow( scoreInfoTableID, row, 7 );
			if ( allowHero == "TRUE" )
			{
				level.scoreInfo[ type ][ "allow_hero" ] = true;
			}
			
			combatEfficiencyEvent = tableLookupColumnForRow( scoreInfoTableID, row, 6 );
			if( IsDefined( combatEfficiencyEvent ) && combatEfficiencyEvent != "" )
			{
				level.scoreInfo[ type ][ "combat_efficiency_event" ] = combatEfficiencyEvent;
			}
		}
	}
	
	game["ScoreInfoInitialized"] = true;
}


function getRankXPCapped( inRankXp )
{
	if ( ( isdefined( level.rankXpCap ) ) && level.rankXpCap && ( level.rankXpCap <= inRankXp ) )
	{
		return level.rankXpCap;
	}
	
	return inRankXp;
}

function getCodPointsCapped( inCodPoints )
{
	if ( ( isdefined( level.codPointsCap ) ) && level.codPointsCap && ( level.codPointsCap <= inCodPoints ) )
	{
		return level.codPointsCap;
	}
	
	return inCodPoints;
}

function registerScoreInfo( type, value, label )
{
	overrideDvar = "scr_" + level.gameType + "_score_" + type;	
	if ( GetDvarString( overrideDvar ) != "" )
	{
		value = getDvarInt( overrideDvar );
	}

	if( type == "kill" )
	{
		multiplier = GetGametypeSetting( "killEventScoreMultiplier" );
		level.scoreInfo[type]["value"] = int((multiplier+ 1.0) * value);
	}
	else
	{
		level.scoreInfo[type]["value"] = value;
	}
	
	if ( isdefined( label ) )
	{
		level.scoreInfo[type]["label"] = label;
	}
}

function getScoreInfoValue( type )
{
	if ( isdefined( level.scoreInfo[type] ) )
	{
		return ( level.scoreInfo[type]["value"] );
	}
}

function getScoreInfoLabel( type )
{
	return ( level.scoreInfo[type]["label"] );
}

function getCombatEfficiencyEvent( type )
{
	return ( level.scoreInfo[type]["combat_efficiency_event"] );
}

function doesScoreInfoCountTowardRampage( type )
{
	return isdefined( level.scoreInfo[type]["rampage"] ) && level.scoreInfo[type]["rampage"];
}

function getRankInfoMinXP( rankId )
{
	return int(level.rankTable[rankId][2]);
}

function getRankInfoXPAmt( rankId )
{
	return int(level.rankTable[rankId][3]);
}

function getRankInfoMaxXp( rankId )
{
	return int(level.rankTable[rankId][7]);
}

function getRankInfoFull( rankId )
{
	return tableLookupIString( "gamedata/tables/mp/mp_ranktable.csv", 0, rankId, 16 );
}

function getRankInfoIcon( rankId, prestigeId )
{
	return tableLookup( "gamedata/tables/mp/mp_rankIconTable.csv", 0, rankId, prestigeId+1 );
}

function getRankInfoLevel( rankId )
{
	return int( tableLookup( "gamedata/tables/mp/mp_ranktable.csv", 0, rankId, 13 ) );
}

function getRankInfoCodPointsEarned( rankId )
{
	return int( tableLookup( "gamedata/tables/mp/mp_ranktable.csv", 0, rankId, 17 ) );
}

function shouldKickByRank()
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

function getCodPointsStat()
{
	codPoints = self GetDStat( "playerstatslist", "CODPOINTS", "StatValue" );
	codPointsCapped = getCodPointsCapped( codPoints );
	
	if ( codPoints > codPointsCapped )
	{
		self setCodPointsStat( codPointsCapped );
	}

	return codPointsCapped;
}

function setCodPointsStat( codPoints )
{
	self SetDStat( "PlayerStatsList", "CODPOINTS", "StatValue", getCodPointsCapped( codPoints ) );
}

function getRankXpStat()
{
	rankXp = self GetDStat( "playerstatslist", "RANKXP", "StatValue" );
	rankXpCapped = getRankXPCapped( rankXp );
	
	if ( rankXp > rankXpCapped )
	{
		self SetDStat( "playerstatslist", "RANKXP", "StatValue", rankXpCapped );
	}

	return rankXpCapped;
}

function on_player_connect()
{
	self.pers["rankxp"] = self getRankXpStat();
	self.pers["codpoints"] = self getCodPointsStat();
	self.pers["currencyspent"] = self GetDStat( "playerstatslist", "currencyspent", "StatValue" );
	rankId = self getRankForXp( self getRankXP() );
	self.pers["rank"] = rankId;
	self.pers["plevel"] = self GetDStat( "playerstatslist", "PLEVEL", "StatValue" );

	if ( self shouldKickByRank() )
	{
		kick( self getEntityNumber() );
		return;
	}
	
	// dont reset participation in War when going into final fight, this is used for calculating match bonus
	if ( !isdefined( self.pers["participation"] ) || !( (level.gameType == "twar") && (0 < game["roundsplayed"]) && (0 < self.pers["participation"]) ) )
	{
		self.pers["participation"] = 0;
	}

	self.rankUpdateTotal = 0;
	
	// attempt to move logic out of menus as much as possible
	self.cur_rankNum = rankId;
	assert( isdefined(self.cur_rankNum), "rank: "+ rankId + " does not have an index, check gamedata/tables/mp/mp_ranktable.csv" );
	
	prestige = self GetDStat( "playerstatslist", "plevel", "StatValue" );
	self setRank( rankId, prestige );
	self.pers["prestige"] = prestige;
	
	
	if ( !isdefined( self.pers["summary"] ) )
	{
		self.pers["summary"] = [];
		self.pers["summary"]["xp"] = 0;
		self.pers["summary"]["score"] = 0;
		self.pers["summary"]["challenge"] = 0;
		self.pers["summary"]["match"] = 0;
		self.pers["summary"]["misc"] = 0;
		self.pers["summary"]["codpoints"] = 0;
	}
	// set default popup in lobby after a game finishes to game "summary"
	// if player got promoted during the game, we set it to "promotion"
	if ( level.rankedMatch || level.wagerMatch || level.leagueMatch )
	{
		self setDStat( "AfterActionReportStats", "lobbyPopup", "none" );
	}
	
	if ( level.rankedMatch )
	{
		self SetDStat( "playerstatslist", "rank", "StatValue", rankId );
		self SetDStat( "playerstatslist", "minxp", "StatValue", getRankInfoMinXp( rankId ) );
		self SetDStat( "playerstatslist", "maxxp", "StatValue", getRankInfoMaxXp( rankId ) );
		self SetDStat( "playerstatslist", "lastxp", "StatValue", getRankXPCapped( self.pers["rankxp"] ) );				
	}
	
	self.explosiveKills[0] = 0;
	
	callback::on_spawned( &on_player_spawned );
	callback::on_joined_team( &on_joined_team );
	callback::on_joined_spectate( &on_joined_spectators );
}

function on_joined_team()
{
	self endon("disconnect");

	self thread removeRankHUD();
}

function on_joined_spectators()
{
	self endon("disconnect");

	self thread removeRankHUD();
}

function on_player_spawned()
{
	self endon("disconnect");
		
	/*if ( !isdefined( self.hud_momentumupdate ) )
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
		self.hud_rankscroreupdate hud::font_pulse_init();
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
		self.hud_momentumreason hud::font_pulse_init();
		self.hud_momentumreason.maxFontScale = 6.3;
		self.hud_momentumreason.outFrames = self.hud_momentumreason.inFrames + self.hud_momentumreason.outFrames;
		self.hud_momentumreason.inFrames = 0;
	}*/
}

function incCodPoints( amount )
{
	if( !util::isRankEnabled() )
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

function atLeastOnePlayerOnEachTeam( )
{
	foreach( team in level.teams )
	{
		if ( !level.playerCount[team] )
			return false;
	}
	return true; 
}

function giveRankXP( type, value, devAdd )
{
	self endon("disconnect");
	
	// TODO: will enable it after zombies ranking system is working
	if( SessionModeIsZombiesGame() )	
	{
		return;
	}

	if ( level.teamBased && (!atLeastOnePlayerOnEachTeam()) && !isdefined( devAdd ) )
		return;
	else if ( !level.teamBased && ( globallogic::totalPlayerCount() < 2) && !isdefined( devAdd ) )
		return;

	if( !util::isRankEnabled() )
		return;		

	pixbeginevent("giveRankXP");		

	if ( !isdefined( value ) )
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

	if ( level.rankedMatch )
	{
		self updateRank();
	}

	// Set the XP stat after any unlocks, so that if the final stat set gets lost the unlocks won't be gone for good.
	if ( value != 0 )
	{
		self syncXPStat();
	}

	if ( isdefined( self.enableText ) && self.enableText && !level.hardcoreMode )
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

function round_this_number( value )
{
	value = int( value + 0.5 );
	return value;
}

function updateRank()
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
			
			
			if ( !isdefined( self.pers["rankcp"] ) )
			{
				self.pers["rankcp"] = 0;
			}
			
			self.pers["rankcp"] += codPointsEarnedForRank;
		}

		rankId++;
	}
	/#print( "promoted from " + oldRank + " to " + newRankId + " timeplayed: " + self GetDStat( "playerstatslist", "time_played_total", "StatValue" ) );	#/

	self setRank( newRankId );

	return true;
}


function CodeCallback_RankUp( rank, prestige, unlockTokensAdded )
{
	if( rank > 8 )
	{
		self GiveAchievement( "MP_MISC_1" );  // award achievement: "Welcome to the Club" - Reach Sergeant (Level 10) in multiplayer Matchmaking.  
	}
	
	self LUINotifyEvent( &"rank_up", 3, rank, prestige, unlockTokensAdded );
	self LUINotifyEventToSpectators( &"rank_up", 3, rank, prestige, unlockTokensAdded );
}

function getItemIndex( refString )
{
	statsTableName = util::getStatsTableName();
	itemIndex = int( tableLookup( statsTableName, 4, refString, 0 ) );
	assert( itemIndex > 0, "statsTable refstring " + refString + " has invalid index: " + itemIndex );
	
	return itemIndex;
}

function endGameUpdate()
{
	player = self;			
}

function updateRankScoreHUD( amount )
{
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	
	if ( isdefined( level.usingMomentum ) && level.usingMomentum )
	{
		return; // Disabled because this is now handled in updateMomentumHUD function
	}

	if ( amount == 0 )
		return;

	self notify( "update_score" );
	self endon( "update_score" );

	self.rankUpdateTotal += amount;

	{wait(.05);};

	if( isdefined( self.hud_rankscroreupdate ) )
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
		self.hud_rankscroreupdate thread hud::font_pulse( self );

		wait 1;
		self.hud_rankscroreupdate fadeOverTime( 0.75 );
		self.hud_rankscroreupdate.alpha = 0;
		
		self.rankUpdateTotal = 0;
	}
}

function updateMomentumHUD( amount, reason, reasonValue )
{
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );

	if ( amount == 0 )
		return;

	self notify( "update_score" );
	self endon( "update_score" );
	
	self.rankUpdateTotal += amount;

	if( isdefined( self.hud_rankscroreupdate ) )
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
		self.hud_rankscroreupdate thread hud::font_pulse( self );
		
		/*if ( isdefined( self.hud_momentumupdate ) && ( amount != self.rankUpdateTotal ) )
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
		
		if ( isdefined( self.hud_momentumreason ) )
		{
			if ( isdefined( reason ) )
			{
				if ( isdefined( reasonValue ) )
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
				self.hud_momentumreason thread hud::font_pulse( self );
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
		
		if ( isdefined( self.hud_momentumreason ) && isdefined( reason ) )
		{
			self.hud_momentumreason fadeOverTime( 0.75 );
			self.hud_momentumreason.alpha = 0;	
		}
		
		wait 0.75;
		
		self.rankUpdateTotal = 0;
	}
}

function removeRankHUD()
{
	if(isdefined(self.hud_rankscroreupdate))
		self.hud_rankscroreupdate.alpha = 0;
		
	if ( isdefined( self.hud_momentumreason ) )
	{
		self.hud_momentumreason.alpha = 0;
	}
}

function getRank()
{	
	rankXp = getRankXPCapped( self.pers["rankxp"] );
	rankId = self.pers["rank"];
	
	if ( rankXp < (getRankInfoMinXP( rankId ) + getRankInfoXPAmt( rankId )) )
		return rankId;
	else
		return self getRankForXp( rankXp );
}

function getRankForXp( xpVal )
{
	rankId = 0;
	rankName = level.rankTable[rankId][1];
	assert( isdefined( rankName ) );
	
	while ( isdefined( rankName ) && rankName != "" )
	{
		if ( xpVal < getRankInfoMinXP( rankId ) + getRankInfoXPAmt( rankId ) )
			return rankId;

		rankId++;
		if ( isdefined( level.rankTable[rankId] ) )
			rankName = level.rankTable[rankId][1];
		else
			rankName = undefined;
	}
	
	rankId--;
	return rankId;
}

function getSPM()
{
	rankLevel = self getRank() + 1;
	return (3 + (rankLevel * 0.5))*10;
}

function getRankXP()
{
	return getRankXPCapped( self.pers["rankxp"] );
}

function incRankXP( amount )
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

function syncXPStat()
{
	xp = getRankXPCapped( self getRankXP() );
	
	cp = getCodPointsCapped( int( self.pers["codpoints"] ) );
	
	self SetDStat( "playerstatslist", "rankxp", "StatValue", xp );
	
	self SetDStat( "playerstatslist", "codpoints", "StatValue", cp );
}
