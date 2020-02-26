#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;


isRegisteredEvent( type )
{
	if ( isDefined( level.scoreInfo[type] ) )
		return true;
	else
		return false;
}

registerScoreInfo( type, value, label )
{
	level.scoreInfo[type]["value"] = value;
	level.scoreInfo[type]["label"] = label;
}

getScoreInfoValue( type )
{
	return ( level.scoreInfo[type]["value"] );
}

getScoreInfoLabel( type )
{
	return ( level.scoreInfo[type]["label"] );
}

getRankInfoIdx( rank )
{
	return int(tableLookup( "mp/ranktable.csv", 1, rank, 0 ));
}

getRankInfoMinXP( rank )
{
	return int(tableLookup( "mp/ranktable.csv", 1, rank, 2 ));
}

getRankInfoXPAmt( rank )
{
	return int(tableLookup( "mp/ranktable.csv", 1, rank, 3 ));
}

getRankInfoAbbr( rank )
{
	return tableLookup( "mp/ranktable.csv", 1, rank, 4 );
}

getRankInfoFull( rank )
{
	return tableLookup( "mp/ranktable.csv", 1, rank, 5 );
}

getRankInfoIcon( rank )
{
	return tableLookup( "mp/ranktable.csv", 1, rank, 6 );
}

getRankInfoUnlockWeapon( rank )
{
	return tableLookup( "mp/ranktable.csv", 1, rank, 8 );
}

getRankInfoUnlockPerk( rank )
{
	return tableLookup( "mp/ranktable.csv", 1, rank, 9 );
}

getRankInfoUnlockChallenge( rank )
{
	return tableLookup( "mp/ranktable.csv", 1, rank, 10 );
}

getRankInfoUnlockCamo( rank )
{
	return tableLookup( "mp/ranktable.csv", 1, rank, 11 );
}

getRankInfoUnlockAttachment( rank )
{
	return tableLookup( "mp/ranktable.csv", 1, rank, 12 );
}

init()
{
	level.scoreInfo = [];

	precacheShader("white");
	
	precacheString(&"MP_KILL");
	precacheString(&"MP_HEADSHOT");
	precacheString(&"MP_SUICIDE");
	precacheString(&"MP_TEAMKILL");
	precacheString(&"MP_ASSIST");
	precacheString(&"MP_WIN");
	precacheString(&"MP_LOSS");
	precacheString(&"MP_TIE");
	precacheString(&"MP_CAPTURE");
	precacheString(&"MP_DEFEND");
	precacheString(&"MP_CHALLENGE");

	registerScoreInfo( "kill", 10, &"MP_KILL" );
	registerScoreInfo( "headshot", 10, &"MP_HEADSHOT" );
	registerScoreInfo( "suicide", 0, &"MP_SUICIDE" );
	registerScoreInfo( "teamkill", 0, &"MP_TEAMKILL" );
	registerScoreInfo( "assist", 2, &"MP_ASSIST" );
	
	registerScoreInfo( "win", 65, &"MP_WIN" );
	registerScoreInfo( "loss", 30, &"MP_LOSS" );
	registerScoreInfo( "tie", 40, &"MP_TIE" );
	registerScoreInfo( "capture", 30, &"MP_CAPTURE" );
	registerScoreInfo( "defend", 30, &"MP_DEFEND" );
	
	registerScoreInfo( "challenge", 250, &"MP_CHALLENGE" );

	rankId = 0;
	rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
	assert( isDefined( rankName ) && rankName != "" );
	
	while ( isDefined( rankName ) && rankName != "" )
	{
		precacheShader( tableLookup( "mp/ranktable.csv", 1, rankName, 6 ) );

		rankId++;
		rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
	}

	level thread onPlayerConnect();
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );

		player.pers["rankxp"] = player maps\mp\gametypes\_persistence_util::statGet( "stats", "rankxp" );
		player.pers["rank"] = player getRank();

		player maps\mp\gametypes\_persistence_util::statSet( "stats", "rank", int(tableLookup( "mp/rankTable.csv", 1, player.pers["rank"], 0 )) );
		player maps\mp\gametypes\_persistence_util::statSet( "stats", "minxp", int(tableLookup( "mp/rankTable.csv", 1, player.pers["rank"], 2 )) );
		player maps\mp\gametypes\_persistence_util::statSet( "stats", "maxxp", int(tableLookup( "mp/rankTable.csv", 1, player.pers["rank"], 7 )) );
		player maps\mp\gametypes\_persistence_util::statSet( "stats", "lastxp", player.pers["rankxp"] );
		
		player.rankUpdateTotal = 0;

		player setClientDvar("ui_rank", player.pers["rank"]);

		rank = player getRank();
		player.rankicon = player getRankInfoIcon( rank );
		
		// for keeping track of rank through stat#251 used by menu script
		// attempt to move logic out of menus as much as possible
		player.cur_rankIdx = player getRankInfoIdx( rank );
		assertex( isdefined(player.cur_rankIdx), "rank: "+ rank + " does not have an index, check mp/ranktable.csv" );
		player setstat( 251, player.cur_rankIdx );
		
		// resetting unlockable vars
		player.unlock["weapon"] = "";
		player.unlock["perk"] = "";
		player.unlock["challenge"] = "";
		player.unlock["camo"] = "";
		player.unlock["attachment"] = "";

		// resetting summary vars
		player.summary["xp"] = "";
		player.summary["score"] = "";
		player.summary["challenge"] = "";
		player.summary["match"] = "";

		// set default popup in lobby after a game finishes to game "summary"
		// if player got promoted during the game, we set it to "promotion"
		player setclientdvar( "ui_lobbypopup", "summary" );
		
		/*
		// resetting unlockable dvars
		player setclientdvar( "player_unlockweapon", "none" );
		player setclientdvar( "player_unlockperk", "none" );
		player setclientdvar( "player_unlockchallenge", "none" );
		player setclientdvar( "player_unlockcamo", "none" );
		player setclientdvar( "player_unlockattachment", "none" );
		
		// resetting game summary dvars
		player setclientdvar( "player_summary_xp", "0" );
		player setclientdvar( "player_summary_score", "" );
		player setclientdvar( "player_summary_challenge", "0" );
		player setclientdvar( "player_summary_match", "0" );
		*/
		
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

		if(!isdefined(self.hud_rankscroreupdate))
		{
			self.hud_rankscroreupdate = newClientHudElem(self);
			self.hud_rankscroreupdate.horzAlign = "center";
			self.hud_rankscroreupdate.vertAlign = "middle";
			self.hud_rankscroreupdate.alignX = "center";
			self.hud_rankscroreupdate.alignY = "middle";
	 		self.hud_rankscroreupdate.x = 0;
			self.hud_rankscroreupdate.y = -60;
			self.hud_rankscroreupdate.font = "default";
			self.hud_rankscroreupdate.fontscale = 2;
			self.hud_rankscroreupdate.archived = false;
			self.hud_rankscroreupdate.color = (1,1,0);
			self.hud_rankscroreupdate maps\mp\gametypes\_money::fontPulseInit();
		}
	}
}

giveRankXP( type, value )
{
	self endon("disconnect");

	if ( !isDefined( value ) )
		value = getScoreInfoValue( type );
	
	self incRankXP( value );

	if ( updateRank() && !level.gameEnded )
	{
		self thread updateRankAnnounceHUD();
		self notify ("update_ranked_hud");
	}

	if ( isDefined( self.enableText ) && self.enableText && !getDvarInt( "ui_hud_hardcore" ) )
	{
//		self maps\mp\gametypes\_hud_message::addMessageText( label, (0.7,0.7,0.7) );
		self thread updateRankScoreHUD( value );
	}
	
	// summary
	if( issubstr( "kill headshot suicide teamkill assist", type ) )
	{
		self.summary["score"] = ( int( self.summary["score"] ) + value );
		self.summary["xp"] = ( int( self.summary["xp"] ) + value );
	}
	else if( issubstr( "win loss tie capture defend", type ) )
	{
		self.summary["match"] = ( int( self.summary["match"] ) + value );
		self.summary["xp"] = ( int( self.summary["xp"] ) + value ) ;
	}
	else if( type == "challenge" )
	{
		self.summary["challenge"] = ( int( self.summary["challenge"] ) + value );
		self.summary["xp"] = ( int( self.summary["xp"] ) + value );
	}
	//assertex( ( self.summary["score"] + self.summary["match"] + self.summary["challenge"] ) == self.summary["xp"], "Xp gained in game does not add up!" );	
}

updateRank()
{
	if ( self getRank() == self.pers["rank"] )
		return false;

	rankId = self getRankId( self.pers["rank"] );
	self.pers["rank"] = self getRank();

	newRankId = self getRankId( self.pers["rank"] );
	
	while ( rankId < newRankId )
	{	
		rankName = self getRankName( rankId );
		
		self maps\mp\gametypes\_persistence_util::statSet( "stats", "rank", int(tableLookup( "mp/rankTable.csv", 1, rankName, 0 )) );
		self maps\mp\gametypes\_persistence_util::statSet( "stats", "minxp", int(tableLookup( "mp/rankTable.csv", 1, rankName, 2 )) );
		self maps\mp\gametypes\_persistence_util::statSet( "stats", "maxxp", int(tableLookup( "mp/rankTable.csv", 1, rankName, 7 )) );
		
		// set current new rank index to stat#252
		self setstat( 252, getRankInfoIdx( rankName ) );
		
		// tell lobby to popup promotion window instead
		self setclientdvar( "ui_lobbypopup", "promotion" );
			
		// unlocks:
		unlockedWeapon = self getRankInfoUnlockWeapon( rankName );	// unlockedweapon is weapon reference string
		unlockWeaponPerk( unlockedWeapon, "weapon", "player_unlockweapon", 65537 );
	
		unlockedPerk = self getRankInfoUnlockPerk( rankName );	// unlockedweapon is weapon reference string
		unlockWeaponPerk( unlockedPerk, "perk", "player_unlockperk", 2 );
			
		unlockChallenge();
		
		unlockedCamo = self getRankInfoUnlockCamo( rankName );	// ex: ak47 camo_brockhaurd			
		unlockCamoAttachment( unlockedCamo, "camo", "player_unlockcamo" );
			
		unlockedAttachment = self getRankInfoUnlockAttachment( rankName );	// ex: ak47 gl	
		unlockCamoAttachment( unlockedAttachment, "attachment", "player_unlockattachment" );	
		
		rankId++;
	}
	return true;
}

updateRankAnnounceHUD()
{
	self endon("disconnect");

	self notify("update_rank");
	self endon("update_rank");

	self.rankicon = self getRankInfoIcon( self.pers["rank"]  );

	self maps\mp\gametypes\_hud_message::notifyMessage( &"RANK_PROMOTED", self getRankInfoFull( self getRank() ), self getRankInfoIcon( self.pers["rank"] ), undefined, "mp_level_up" );
}

// unlocks weapon and perks
unlockWeaponPerk( unlocked, unlocked_string, dvar_string, switch_num )
{
	if( isdefined( unlocked ) && unlocked != "" )
	{
		if( self.unlock[unlocked_string] == "" )
			self.unlock[unlocked_string] = tablelookup( "mp/statstable.csv", 4, unlocked, 3 );
		else
			self.unlock[unlocked_string] = self.unlock[unlocked_string] + ", " + tablelookup( "mp/statstable.csv", 4, unlocked, 3 );
		
		self setclientdvar( dvar_string, self.unlock[unlocked_string] );
		
		assertex( isdefined( self.name ), "Player name is missing here, this is for debugging only" );
		println( self.name + " unlocked item " + self.unlock[unlocked_string] );
		
		stat = int( tableLookup( "mp/statstable.csv", 4, unlocked, 1 ) );
		
		//assertex( player getstat( weaponStat ) > 0, "Unlocking " + unlockedweapon + " more than once, might be due to unclean player stat data, reset all stats." );
		if( self getstat( stat ) < 1 )
			self setstat( stat, switch_num );	// 65537 is binary mask for newly unlocked weapon, 2 for perks
	}
}

// unlocks challenges
unlockChallenge()
{
	unlockedChallenge = self getRankInfoUnlockChallenge( self.pers["rank"] );	// unlockedperk is perk reference string
	if( isdefined( unlockedChallenge ) && unlockedChallenge != "" )
	{
		challengeTierName = "Tier "+unlockedChallenge[unlockedChallenge.size-1];
		tableName = "mp/challengetable_"+unlockedChallenge+".csv";
		
		if( self.unlock["challenge"] == "" )
			self.unlock["challenge"] = challengeTierName;
		else
			self.unlock["challenge"] = self.unlock["challenge"] + ", " + challengeTierName;
		
		self setclientdvar( "player_unlockchallenge", self.unlock["challenge"] );
					
		assertex( isdefined( self.name ), "Player name is missing here, this is for debugging only" );
		println( self.name + " unlocked challenge " + self.unlock["challenge"] );
		
		idx = 1;
		// unlocks all the challenges in this tier
		while( isdefined( tableLookup( tableName, 0, idx, 0 ) ) && tableLookup( tableName, 0, idx, 0 ) != "" )
		{
			stat_num = tableLookup( tableName, 0, idx, 2 );
			if( isdefined( stat_num ) && stat_num != "" )
			{
				//assertex( player getstat( challengeStat ) > 0, "Unlocking " + unlockedchallenge + " more than once, might be due to unclean player stat data, reset all stats." );
				if( self getstat( int(stat_num) ) < 1 )
					self setstat( int(stat_num), 21 );	// set to 2 for new status, 1 for not new just unlocked
					
				//println( self.name + " - unlocked challenge: " + tableLookup( tableName, 0, idx, 8 ) + " - " + self getstat( int(stat_num) ) );
			}
			idx++;
		}
		assertex( idx != 0, unlockedChallenge+" is an invalid entry in rankTable.csv" );
	}
}

// unlocks camo and attachments
unlockCamoAttachment( unlocked, unlocked_string, dvar_string )
{
	if( isdefined( unlocked ) && unlocked != "" )
	{
		Tok = strtok( unlocked, " " );
		baseWeapon = Tok[0];
		addon = Tok[1];
		
		fullName = tableLookup( "mp/statstable.csv", 4, baseWeapon, 3 ) + " " + tableLookup( "mp/attachmentTable.csv", 4, addon, 3 );
		
		if( self.unlock[unlocked_string] == "" )
			self.unlock[unlocked_string] = fullName;
		else
			self.unlock[unlocked_string] = self.unlock[unlocked_string] + ", " + fullName;
		
		self setclientdvar( dvar_string, self.unlock[unlocked_string] );
					
		assertex( isdefined( self.name ), "Player name is missing here, this is for debugging only" );
		println( self.name + " unlocked item " + self.unlock[unlocked_string] );
		
		weaponStat = int( tableLookup( "mp/statstable.csv", 4, baseWeapon, 1 ) );
		
		// ORs the camo/attachment's bitmask with weapon's current bits, thus switching the camo/attachment bit on
		self setstat( weaponStat, ( self getstat( weaponStat ) | int(tableLookup("mp/attachmenttable.csv",4,addon,10)) ) );
	}
}

// unlocks challenges
updateChallenges()
{
	for ( i = 1; i <= 10; i++ )
	{
		tableName = "mp/challengetable_tier"+i+".csv";

		idx = 1;
		// unlocks all the challenges in this tier
		while( isdefined( tableLookup( tableName, 0, idx, 0 ) ) && tableLookup( tableName, 0, idx, 0 ) != "" )
		{
			stat_num = tableLookup( tableName, 0, idx, 2 );
			if( isdefined( stat_num ) && stat_num != "" )
			{
				statVal = self getStat( int( stat_num ) );
				
				if ( statVal > 20 )
				{
					statVal -= 10;
					self setStat( int( stat_num ), statVal );
				}	
			}
			idx++;
		}
	}
}

updateRankScoreHUD( amount )
{
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );

	if ( amount == 0 )
		return;

	self notify( "update_score" );
	self endon( "update_score" );

	if( isDefined( self.hud_rankscroreupdate ) )
	{
		self.rankUpdateTotal += amount;
			
		self.hud_rankscroreupdate.label = &"MP_PLUS";

		self.hud_rankscroreupdate setValue(self.rankUpdateTotal);
		self.hud_rankscroreupdate.alpha = 1;
		self.hud_rankscroreupdate thread maps\mp\gametypes\_money::fontPulse( self );

		wait 1;
		self.hud_rankscroreupdate fadeOverTime( 0.75 );
		self.hud_rankscroreupdate.alpha = 0;
		
		self.rankUpdateTotal = 0;
	}
}

removeRankHUD()
{
	if(isDefined(self.hud_rankscroreupdate))
		self.hud_rankscroreupdate.alpha = 0;
}

getRank()
{
	rankId = 0;
	rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
	assert( isDefined( rankName ) );
	
	while ( isDefined( rankName ) && rankName != "" )
	{
		if ( self getRankXP() < getRankInfoMinXP( rankName ) + getRankInfoXPAmt( rankName ) )
			return rankName;

		rankId++;
		rankName = tableLookup( "mp/ranktable.csv", 0, ""+rankId, 1 );
	}
	
	rankId--;
	return tableLookup( "mp/ranktable.csv", 0, ""+rankId, 1 );
}

getRankName( rankId )
{
	return tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
}

getRankId( rankName )
{
	return int( tableLookup( "mp/ranktable.csv", 1, rankName, 0 ) );
}

getRankXP()
{
	return self.pers["rankxp"];
}


setRankXP( amount )
{
	self.pers["rankxp"] += amount;
	self maps\mp\gametypes\_persistence_util::statSet( "stats", "rankxp", amount );
}


incRankXP( amount )
{
	xp = self getRankXP();
	self.pers["rankxp"] = (xp + amount);
	self maps\mp\gametypes\_persistence_util::statAdd( "stats", "rankxp", amount );
}
