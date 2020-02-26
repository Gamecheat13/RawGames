#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;


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
	precacheString(&"MP_MINUS");
	precacheString(&"MP_PLUS");
	precacheString(&"MP_NULL");

	if ( level.teamBased )
	{
		registerScoreInfo( "kill", 10, &"MP_KILL" );
		registerScoreInfo( "headshot", 10, &"MP_HEADSHOT" );
		registerScoreInfo( "assist", 2, &"MP_ASSIST" );
		registerScoreInfo( "suicide", 0, &"MP_SUICIDE" );
		registerScoreInfo( "teamkill", 0, &"MP_TEAMKILL" );
	}
	else
	{
		registerScoreInfo( "kill", 5, &"MP_KILL" );
		registerScoreInfo( "headshot", 5, &"MP_HEADSHOT" );
		registerScoreInfo( "assist", 0, &"MP_ASSIST" );
		registerScoreInfo( "suicide", 0, &"MP_SUICIDE" );
		registerScoreInfo( "teamkill", 0, &"MP_TEAMKILL" );
	}
	
	registerScoreInfo( "win", 1, &"MP_WIN" );
	registerScoreInfo( "loss", 0.5, &"MP_LOSS" );
	registerScoreInfo( "tie", 0.75, &"MP_TIE" );
	registerScoreInfo( "capture", 30, &"MP_CAPTURE" );
	registerScoreInfo( "defend", 30, &"MP_DEFEND" );
	
	registerScoreInfo( "challenge", 250, &"MP_CHALLENGE" );

	rankId = 0;
	rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
	assert( isDefined( rankName ) && rankName != "" );
		
	while ( isDefined( rankName ) && rankName != "" )
	{
		precacheShader( tableLookup( "mp/ranktable.csv", 0, rankId, 6 ) );

		rankId++;
		rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
	}

	level.statOffsets = [];
	level.statOffsets["weapon_assault"] = 290;
	level.statOffsets["weapon_lmg"] = 291;
	level.statOffsets["weapon_smg"] = 292;
	level.statOffsets["weapon_shotgun"] = 293;
	level.statOffsets["weapon_sniper"] = 294;
	level.statOffsets["weapon_pistol"] = 295;
	level.statOffsets["perk1"] = 296;
	level.statOffsets["perk2"] = 297;
	level.statOffsets["perk3"] = 298;

	level.numChallengeTiers	= 10;
	
	buildChallegeInfo();
	
	level thread onPlayerConnect();
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

getRankInfoMinXP( rankId )
{
	return int(tableLookup( "mp/ranktable.csv", 0, rankId, 2 ));
}

getRankInfoXPAmt( rankId )
{
	return int(tableLookup( "mp/ranktable.csv", 0, rankId, 3 ));
}

getRankInfoMaxXp( rankId )
{
	return int(tableLookup( "mp/ranktable.csv", 0, rankId, 7 ));
}

getRankInfoAbbr( rankId )
{
	return tableLookup( "mp/ranktable.csv", 0, rankId, 4 );
}

getRankInfoFull( rankId )
{
	return tableLookupIString( "mp/ranktable.csv", 0, rankId, 5 );
}

getRankInfoIcon( rankId )
{
	return tableLookup( "mp/ranktable.csv", 0, rankId, 6 );
}

getRankInfoUnlockWeapon( rankId )
{
	return tableLookup( "mp/ranktable.csv", 0, rankId, 8 );
}

getRankInfoUnlockPerk( rankId )
{
	return tableLookup( "mp/ranktable.csv", 0, rankId, 9 );
}

getRankInfoUnlockChallenge( rankId )
{
	return tableLookup( "mp/ranktable.csv", 0, rankId, 10 );
}

getRankInfoUnlockFeature( rankId )
{
	return tableLookup( "mp/ranktable.csv", 0, rankId, 15 );
}

getRankInfoUnlockCamo( rankId )
{
	return tableLookup( "mp/ranktable.csv", 0, rankId, 11 );
}

getRankInfoUnlockAttachment( rankId )
{
	return tableLookup( "mp/ranktable.csv", 0, rankId, 12 );
}

getRankInfoLevel( rankId )
{
	return int( tableLookup( "mp/ranktable.csv", 0, rankId, 13 ) );
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );

		player.pers["rankxp"] = player maps\mp\gametypes\_persistence::statGet( "rankxp" );
		rankId = player getRank();
		player.pers["rank"] = rankId;
		player.pers["participation"] = 0;

		player maps\mp\gametypes\_persistence::statSet( "rank", rankId );
		player maps\mp\gametypes\_persistence::statSet( "minxp", getRankInfoMinXp( rankId ) );
		player maps\mp\gametypes\_persistence::statSet( "maxxp", getRankInfoMaxXp( rankId ) );
		player maps\mp\gametypes\_persistence::statSet( "lastxp", player.pers["rankxp"] );
		
		player.rankUpdateTotal = 0;

		player setClientDvar("ui_rankid", rankId);

		// for keeping track of rank through stat#251 used by menu script
		// attempt to move logic out of menus as much as possible
		player.cur_rankNum = rankId;
		assertex( isdefined(player.cur_rankNum), "rank: "+ rankId + " does not have an index, check mp/ranktable.csv" );
		player setStat( 251, player.cur_rankNum );
		player.rank = rankId+1; // TEMP +1 should not be necessary after code bug fix
		
		// resetting unlockable vars
		if ( !isDefined( player.pers["unlocks"] ) )
		{
			player.pers["unlocks"] = [];
			player.pers["unlocks"]["weapon"] = 0;
			player.pers["unlocks"]["perk"] = 0;
			player.pers["unlocks"]["challenge"] = 0;
			player.pers["unlocks"]["camo"] = 0;
			player.pers["unlocks"]["attachment"] = 0;
			player.pers["unlocks"]["feature"] = 0;

			// resetting unlockable dvars
			player setClientDvar( "player_unlockweapon0", " -" );
			player setClientDvar( "player_unlockweapon1", " -" );
			player setClientDvar( "player_unlockweapon2", " -" );
			player setClientDvar( "player_unlockweapons", "0" );
			
			player setClientDvar( "player_unlockperk0", " -" );
			player setClientDvar( "player_unlockperk1", " -" );
			player setClientDvar( "player_unlockperk2", " -" );
			player setClientDvar( "player_unlockperks", "0" );
			
			player setClientDvar( "player_unlockchallenge0", " -" );
			player setClientDvar( "player_unlockchallenge1", " -" );
			player setClientDvar( "player_unlockchallenge2", " -" );
			player setClientDvar( "player_unlockchallenges", "0" );
			
			player setClientDvar( "player_unlockcamo0", " -" );
			player setClientDvar( "player_unlockcamo1", " -" );
			player setClientDvar( "player_unlockcamo2", " -" );
			player setClientDvar( "player_unlockcamos", "0" );
			
			player setClientDvar( "player_unlockattachment0", " -" );
			player setClientDvar( "player_unlockattachment1", " -" );
			player setClientDvar( "player_unlockattachment2", " -" );
			player setClientDvar( "player_unlockattachments", "0" );
			
			player setClientDvar( "player_unlockfeature0", " -" );		
			player setClientDvar( "player_unlockfeature1", " -" );	
			player setClientDvar( "player_unlockfeature2", " -" );	
			player setClientDvar( "player_unlockfeatures", "0" );
		}
		
		if ( !isDefined( player.pers["summary"] ) )
		{
			player.pers["summary"] = [];
			player.pers["summary"]["xp"] = 0;
			player.pers["summary"]["score"] = 0;
			player.pers["summary"]["challenge"] = 0;
			player.pers["summary"]["match"] = 0;
			player.pers["summary"]["misc"] = 0;

			// resetting game summary dvars
			player setClientDvar( "player_summary_xp", "0" );
			player setClientDvar( "player_summary_score", "0" );
			player setClientDvar( "player_summary_challenge", "0" );
			player setClientDvar( "player_summary_match", "0" );
		}


		// resetting summary vars
		
		// set default popup in lobby after a game finishes to game "summary"
		// if player got promoted during the game, we set it to "promotion"
		if( level.rankedMatch )
			player setclientdvar( "ui_lobbypopup", "summary" );
		else
			player setclientdvar( "ui_lobbypopup", "" );
		
		player updateChallenges();
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
			self.hud_rankscroreupdate maps\mp\gametypes\_hud::fontPulseInit();
		}
	}
}

giveRankXP( type, value )
{
	self endon("disconnect");

	if ( !isDefined( value ) )
		value = getScoreInfoValue( type );
	
	self incRankXP( value );

	if ( updateRank() && level.rankedMatch )
		self thread updateRankAnnounceHUD();

	if ( isDefined( self.enableText ) && self.enableText )
	{
		if ( type == "teamkill" )
			self thread updateRankScoreHUD( 0 - maps\mp\gametypes\_tweakables::getTweakableValue( "team", "teamkillpointloss" ) );
		else
			self thread updateRankScoreHUD( value );
	}
	
	// summary
	if( issubstr( "kill headshot suicide teamkill assist", type ) )
	{
		self.pers["summary"]["score"] = self.pers["summary"]["score"] + value;
		self.pers["summary"]["xp"] = self.pers["summary"]["xp"] + value;
	}
	else if( issubstr( "win loss tie capture defend return pickup", type ) )
	{
		self.pers["summary"]["match"] = self.pers["summary"]["match"] + value;
		self.pers["summary"]["xp"] = self.pers["summary"]["xp"] + value;
	}
	else if( type == "challenge" )
	{
		self.pers["summary"]["challenge"] = self.pers["summary"]["challenge"] + value;
		self.pers["summary"]["xp"] = self.pers["summary"]["xp"] + value;
	}
	else
	{
		self.pers["summary"]["misc"] = self.pers["summary"]["misc"] + value;
		self.pers["summary"]["xp"] = self.pers["summary"]["xp"] + value;			
	}

	self setclientdvar( "player_summary_xp", self.pers["summary"]["xp"] );
	self setclientdvar( "player_summary_score", self.pers["summary"]["score"] );
	self setclientdvar( "player_summary_challenge", self.pers["summary"]["challenge"] );
	self setclientdvar( "player_summary_match", self.pers["summary"]["match"] );	
	self setclientdvar( "player_summary_misc", self.pers["summary"]["misc"] );	
}

updateRank()
{
	newRankId = self getRank();
	if ( newRankId == self.pers["rank"] )
		return false;

	rankId = self.pers["rank"];
	self.pers["rank"] = newRankId;
	
	while ( rankId <= newRankId )
	{	
		self maps\mp\gametypes\_persistence::statSet( "rank", rankId );
		self maps\mp\gametypes\_persistence::statSet( "minxp", int(tableLookup( "mp/rankTable.csv", 0, rankId, 2 )) );
		self maps\mp\gametypes\_persistence::statSet( "maxxp", int(tableLookup( "mp/rankTable.csv", 0, rankId, 7 )) );
	
		// set current new rank index to stat#252
		self setStat( 252, rankId );
	
		// tell lobby to popup promotion window instead
		self setclientdvar( "ui_lobbypopup", "promotion" );
		
		// unlocks weapon =======
		unlockedWeapon = self getRankInfoUnlockWeapon( rankId );	// unlockedweapon is weapon reference string
		if ( isDefined( unlockedWeapon ) && unlockedWeapon != "" )
			unlockWeapon( unlockedWeapon );
	
		// unlock perk ==========
		unlockedPerk = self getRankInfoUnlockPerk( rankId );	// unlockedweapon is weapon reference string
		if ( isDefined( unlockedPerk ) && unlockedPerk != "" )
			unlockPerk( unlockedPerk );
			
		// unlock challenge =====
		unlockedChallenge = self getRankInfoUnlockChallenge( rankId );
		if ( isDefined( unlockedChallenge ) && unlockedChallenge != "" )
			unlockChallenge( unlockedChallenge );

		// unlock attachment ====
		unlockedAttachment = self getRankInfoUnlockAttachment( rankId );	// ex: ak47 gl	
		if ( isDefined( unlockedAttachment ) && unlockedAttachment != "" )
			unlockAttachment( unlockedAttachment );	
		
		unlockedCamo = self getRankInfoUnlockCamo( rankId );	// ex: ak47 camo_brockhaurd
		if ( isDefined( unlockedCamo ) && unlockedCamo != "" )
			unlockCamo( unlockedCamo );

		unlockedFeature = self getRankInfoUnlockFeature( rankId );	// ex: feature_cac
		if ( isDefined( unlockedFeature ) && unlockedFeature != "" )
			unlockFeature( unlockedFeature );
		
		rankId++;
	}
	self.rank = newRankId+1; // TEMP +1 should not be necessary after code bug fix
	return true;
}

updateRankAnnounceHUD()
{
	self endon("disconnect");

	self notify("update_rank");
	self endon("update_rank");
	
	newRankName = self getRankInfoFull( self.pers["rank"] );

	self maps\mp\gametypes\_hud_message::oldNotifyMessage( &"RANK_PROMOTED", newRankName, self getRankInfoIcon( self.pers["rank"] ), undefined, "mp_level_up" );
	
	team = self.pers["team"];
	if ( !isdefined( team ) )
		return;
	
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		playerteam = player.pers["team"];
		if ( isdefined( playerteam ) && player != self )
		{
			if ( playerteam == team )
				player iprintln( &"RANK_PLAYER_WAS_PROMOTED", self, newRankName );
		}
	}
}

// unlocks weapon
unlockWeapon( refString )
{
	assert( isDefined( refString ) && refString != "" );
		
	stat = int( tableLookup( "mp/statstable.csv", 4, refString, 1 ) );
	
	assertEx( stat > 0, "statsTable refstring " + refString + " has invalid stat number: " + stat );
	
	if( self getStat( stat ) > 0 )
		return;

	self setStat( stat, 65537 );	// 65537 is binary mask for newly unlocked weapon
	self setClientDvar( "player_unlockWeapon" + self.pers["unlocks"]["weapon"], tableLookup( "mp/statstable.csv", 4, refString, 3 ) );
	self.pers["unlocks"]["weapon"]++;
	self setClientDvar( "player_unlockWeapons", self.pers["unlocks"]["weapon"] );
}

// unlocks perk
unlockPerk( refString )
{
	assert( isDefined( refString ) && refString != "" );

	stat = int( tableLookup( "mp/statstable.csv", 4, refString, 1 ) );
	
	if( self getStat( stat ) > 0 )
		return;

	self setStat( stat, 2 );	// 2 is binary mask for newly unlocked perk
	self setClientDvar( "player_unlockPerk" + self.pers["unlocks"]["perk"], tableLookup( "mp/statstable.csv", 4, refString, 3 ) );
	self.pers["unlocks"]["perk"]++;
	self setClientDvar( "player_unlockPerks", self.pers["unlocks"]["perk"] );
}

// unlocks camo - multiple
unlockCamo( refString )
{
	assert( isDefined( refString ) && refString != "" );

	// tokenize reference string, accepting multiple camo unlocks in one call
	Ref_Tok = strTok( refString, ";" );
	assertex( Ref_Tok.size > 0, "Camo unlock specified in datatable ["+refString+"] is incomplete or empty" );
	
	for( i=0; i<Ref_Tok.size; i++ )
		unlockCamoSingular( Ref_Tok[i] );
}

// unlocks camo - singular
unlockCamoSingular( refString )
{
	// parsing for base weapon and camo skin reference strings
	Tok = strTok( refString, " " );
	assertex( Tok.size == 2, "Camo unlock sepcified in datatable ["+refString+"] is invalid" );
	
	baseWeapon = Tok[0];
	addon = Tok[1];

	weaponStat = int( tableLookup( "mp/statstable.csv", 4, baseWeapon, 1 ) );
	addonMask = int( tableLookup( "mp/attachmenttable.csv", 4, addon, 10 ) );
	
	if ( self getStat( weaponStat ) & addonMask )
		return;
	
	// ORs the camo/attachment's bitmask with weapon's current bits, thus switching the camo/attachment bit on
	setstatto = ( self getStat( weaponStat ) | addonMask ) | (addonMask<<16) | (1<<16);
	self setStat( weaponStat, setstatto );
	
	fullName = tableLookup( "mp/statstable.csv", 4, baseWeapon, 3 ) + " " + tableLookup( "mp/attachmentTable.csv", 4, addon, 3 );
	self setClientDvar( "player_unlockCamo" + self.pers["unlocks"]["camo"], fullName );
	self.pers["unlocks"]["camo"]++;
	self setClientDvar( "player_unlockCamos", self.pers["unlocks"]["camo"] );
}

unlockAttachment( refString )
{
	assert( isDefined( refString ) && refString != "" );

	// tokenize reference string, accepting multiple camo unlocks in one call
	Ref_Tok = strTok( refString, ";" );
	assertex( Ref_Tok.size > 0, "Attachment unlock specified in datatable ["+refString+"] is incomplete or empty" );
	
	for( i=0; i<Ref_Tok.size; i++ )
		unlockAttachmentSingular( Ref_Tok[i] );
}

// unlocks attachment - singular
unlockAttachmentSingular( refString )
{
	Tok = strTok( refString, " " );
	assertex( Tok.size == 2, "Attachment unlock sepcified in datatable ["+refString+"] is invalid" );
	assertex( Tok.size == 2, "Attachment unlock sepcified in datatable ["+refString+"] is invalid" );
	
	baseWeapon = Tok[0];
	addon = Tok[1];

	weaponStat = int( tableLookup( "mp/statstable.csv", 4, baseWeapon, 1 ) );
	addonMask = int( tableLookup( "mp/attachmenttable.csv", 4, addon, 10 ) );
	
	if ( self getStat( weaponStat ) & addonMask )
		return;
	
	// ORs the camo/attachment's bitmask with weapon's current bits, thus switching the camo/attachment bit on
	setstatto = ( self getStat( weaponStat ) | addonMask ) | (addonMask<<16) | (1<<16);
	self setStat( weaponStat, setstatto );

	fullName = tableLookup( "mp/statstable.csv", 4, baseWeapon, 3 ) + " " + tableLookup( "mp/attachmentTable.csv", 4, addon, 3 );
	self setClientDvar( "player_unlockAttachment" + self.pers["unlocks"]["attachment"], fullName );
	self.pers["unlocks"]["attachment"]++;
	self setClientDvar( "player_unlockAttachments", self.pers["unlocks"]["attachment"] );
}

/*
setBaseNewStatus( stat )
{
	weaponIDs = level.tbl_weaponIDs;
	perkData = level.tbl_PerkData;
	statOffsets = level.statOffsets;
	if ( isDefined( weaponIDs[stat] ) )
	{
		if ( isDefined( statOffsets[weaponIDs[stat]["group"]] ) )
			self setStat( statOffsets[weaponIDs[stat]["group"]], 1 );
	}
	
	if ( isDefined( perkData[stat] ) )
	{
		if ( isDefined( statOffsets[perkData[stat]["perk_num"]] ) )
			self setStat( statOffsets[perkData[stat]["perk_num"]], 1 );
	}
}

clearNewStatus( stat, bitMask )
{
	self setStat( stat, self getStat( stat ) & bitMask );
}


updateBaseNewStatus()
{
	self setstat( 290, 0 );
	self setstat( 291, 0 );
	self setstat( 292, 0 );
	self setstat( 293, 0 );
	self setstat( 294, 0 );
	self setstat( 295, 0 );
	self setstat( 296, 0 );
	self setstat( 297, 0 );
	self setstat( 298, 0 );
	
	weaponIDs = level.tbl_weaponIDs;
	// update for weapons and any attachments or camo skins, bit mask 16->32 : 536805376 for new status
	for( i=0; i<149; i++ )
	{	
		if( !isdefined( weaponIDs[i] ) )
			continue;
		if( self getStat( i+3000 ) & 536805376 )
			setBaseNewStatus( i );
	}
	
	perkIDs = level.tbl_PerkData;
	// update for perks
	for( i=150; i<199; i++ )
	{
		if( !isdefined( perkIDs[i] ) )
			continue;
		if( self getStat( i ) > 1 )
			setBaseNewStatus( i );
	}
}
*/

unlockChallenge( refString )
{
	assert( isDefined( refString ) && refString != "" );

	// tokenize reference string, accepting multiple camo unlocks in one call
	Ref_Tok = strTok( refString, ";" );
	assertex( Ref_Tok.size > 0, "Camo unlock specified in datatable ["+refString+"] is incomplete or empty" );
	
	for( i=0; i<Ref_Tok.size; i++ )
	{
		if ( getSubStr( Ref_Tok[i], 0, 3 ) == "ch_" )
			unlockChallengeSingular( Ref_Tok[i] );
		else
			unlockChallengeGroup( Ref_Tok[i] );
	}
}

// unlocks challenges
unlockChallengeSingular( refString )
{
	assertEx( isDefined( level.challengeInfo[refString] ), "Challenge unlock "+refString+" does not exist." );
	tableName = "mp/challengetable_tier" + level.challengeInfo[refString]["tier"] + ".csv";
	
	if ( self getStat( level.challengeInfo[refString]["stateid"] ) )
		return;

	self setStat( level.challengeInfo[refString]["stateid"], 1 );
	
	// set tier as new
	self setStat( 269 + level.challengeInfo[refString]["tier"], 2 );// 2: new, 1: old
	
	self setClientDvar( "player_unlockchallenge" + self.pers["unlocks"]["challenge"], level.challengeInfo[refString]["name"] );
	self.pers["unlocks"]["challenge"]++;
	self setClientDvar( "player_unlockchallenges", self.pers["unlocks"]["challenge"] );	
}


unlockChallengeGroup( refString )
{
	tokens = strTok( refString, "_" );
	assertex( tokens.size > 0, "Challenge unlock specified in datatable ["+refString+"] is incomplete or empty" );
	
	assert( tokens[0] == "tier" );
	
	tierId = int( tokens[1] );
	assertEx( tierId > 0 && tierId <= level.numChallengeTiers, "invalid tier ID " + tierId );

	groupId = "";
	if ( tokens.size > 2 )
		groupId = tokens[2];

	challengeArray = getArrayKeys( level.challengeInfo );
	
	for ( index = 0; index < challengeArray.size; index++ )
	{
		challenge = level.challengeInfo[challengeArray[index]];
		
		if ( challenge["tier"] != tierId )
			continue;
			
		if ( challenge["group"] != groupId )
			continue;
			
		if ( self getStat( challenge["stateid"] ) )
			return;
	
		self setStat( challenge["stateid"], 1 );
		
		// set tier as new
		self setStat( 269 + challenge["tier"], 2 );// 2: new, 1: old
		
	}
	
	desc = tableLookup( "mp/challengeTable.csv", 0, tierId, 1 );

	self setClientDvar( "player_unlockchallenge" + self.pers["unlocks"]["challenge"], desc );
	self.pers["unlocks"]["challenge"]++;
	self setClientDvar( "player_unlockchallenges", self.pers["unlocks"]["challenge"] );			
}


unlockFeature( refString )
{
	assert( isDefined( refString ) && refString != "" );

	stat = int( tableLookup( "mp/statstable.csv", 4, refString, 1 ) );
	
	if( self getStat( stat ) > 0 )
		return;

	if ( refString == "feature_cac" )
		self setStat( 200, 1 );

	self setStat( stat, 2 ); // 2 is binary mask for newly unlocked
	
	self setClientDvar( "player_unlockfeature"+self.pers["unlocks"]["feature"], tableLookup( "mp/statstable.csv", 4, refString, 3 ) );
	self.pers["unlocks"]["feature"]++;
	self setClientDvar( "player_unlockfeatures", self.pers["unlocks"]["feature"] );
}


// update copy of a challenges to be progressed this game, only at the start of the game
// challenges unlocked during the game will not be progressed on during that game session
updateChallenges()
{
	self.challengeData = [];
	for ( i = 1; i <= level.numChallengeTiers; i++ )
	{
		tableName = "mp/challengetable_tier"+i+".csv";

		idx = 1;
		// unlocks all the challenges in this tier
		for( idx = 1; isdefined( tableLookup( tableName, 0, idx, 0 ) ) && tableLookup( tableName, 0, idx, 0 ) != ""; idx++ )
		{
			stat_num = tableLookup( tableName, 0, idx, 2 );
			if( isdefined( stat_num ) && stat_num != "" )
			{
				statVal = self getStat( int( stat_num ) );
				
				refString = tableLookup( tableName, 0, idx, 7 );
				if ( statVal && statVal != 255 )
					self.challengeData[refString] = statVal;
			}
		}
	}
}


buildChallegeInfo()
{
	level.challengeInfo = [];
	
	for ( i = 1; i <= level.numChallengeTiers; i++ )
	{
		tableName = "mp/challengetable_tier"+i+".csv";

		baseRef = "";
		// unlocks all the challenges in this tier
		for( idx = 1; isdefined( tableLookup( tableName, 0, idx, 0 ) ) && tableLookup( tableName, 0, idx, 0 ) != ""; idx++ )
		{
			stat_num = tableLookup( tableName, 0, idx, 2 );
			refString = tableLookup( tableName, 0, idx, 7 );

			level.challengeInfo[refString] = [];
			level.challengeInfo[refString]["tier"] = i;
			level.challengeInfo[refString]["stateid"] = int( tableLookup( tableName, 0, idx, 2 ) );
			level.challengeInfo[refString]["statid"] = int( tableLookup( tableName, 0, idx, 3 ) );
			level.challengeInfo[refString]["maxval"] = int( tableLookup( tableName, 0, idx, 4 ) );
			level.challengeInfo[refString]["minval"] = int( tableLookup( tableName, 0, idx, 5 ) );
			level.challengeInfo[refString]["name"] = tableLookup( tableName, 0, idx, 8 );
			level.challengeInfo[refString]["desc"] = tableLookup( tableName, 0, idx, 9 );
			level.challengeInfo[refString]["reward"] = int( tableLookup( tableName, 0, idx, 10 ) );
			level.challengeInfo[refString]["camo"] = tableLookup( tableName, 0, idx, 12 );
			level.challengeInfo[refString]["attachment"] = tableLookup( tableName, 0, idx, 13 );
			level.challengeInfo[refString]["group"] = tableLookup( tableName, 0, idx, 14 );

			if ( !int( level.challengeInfo[refString]["stateid"] ) )
			{
				level.challengeInfo[baseRef]["levels"]++;
				level.challengeInfo[refString]["stateid"] = level.challengeInfo[baseRef]["stateid"];
			}
			else
			{
				level.challengeInfo[refString]["levels"] = 1;
				baseRef = refString;
			}
		}
	}
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

	if ( amount == 0 )
		return;

	self notify( "update_score" );
	self endon( "update_score" );

	if( isDefined( self.hud_rankscroreupdate ) )
	{
		self.rankUpdateTotal += amount;
			
		if ( self.rankUpdateTotal < 0 )
		{
			self.hud_rankscroreupdate.label = &"MP_NULL";
			self.hud_rankscroreupdate.color = (1,0,0);
		}
		else
		{
			self.hud_rankscroreupdate.label = &"MP_PLUS";
			self.hud_rankscroreupdate.color = (1,1,0);
		}

		self.hud_rankscroreupdate setValue(self.rankUpdateTotal);
		self.hud_rankscroreupdate.alpha = 1;
		self.hud_rankscroreupdate thread maps\mp\gametypes\_hud::fontPulse( self );

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
	return getRankForXp( self getRankXP() );
}

getRankForXp( xpVal )
{
	rankId = 0;
	rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
	assert( isDefined( rankName ) );
	
	while ( isDefined( rankName ) && rankName != "" )
	{
		if ( xpVal < getRankInfoMinXP( rankId ) + getRankInfoXPAmt( rankId ) )
			return rankId;

		rankId++;
		rankName = tableLookup( "mp/ranktable.csv", 0, ""+rankId, 1 );
	}
	
	rankId--;
	return rankId;
}


getRankName( rankId )
{
	return tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
}

getSPM()
{
	rankLevel = (self getRank() % 61) + 1;
	return 3 + (rankLevel * 0.5);
}

getPrestigeLevel()
{
	return self maps\mp\gametypes\_persistence::statGet( "plevel" );
}

getRankXP()
{
	return self.pers["rankxp"];
}
/*
// this function does not handle prestige
setRankXP( amount )
{
	if ( !level.rankedMatch )
		return;
		
	self.pers["rankxp"] += amount;
	self maps\mp\gametypes\_persistence::statSet( "rankxp", amount );
}
*/
incRankXP( amount )
{
	if ( !level.rankedMatch )
		return;
	
	xp = self getRankXP();
	newXp = (xp + amount);

	// final levels and prestige
	if ( self.pers["rank"] == 54 && newXp >= getRankInfoMaxXP( 54 ) )
		newXp = (getRankInfoMaxXP( 54 ) - 1);
	if ( self.pers["rank"] == 109 && newXp >= getRankInfoMaxXP( 109 ) )
		newXp = (getRankInfoMaxXP( 109 ) - 1);
	if ( self.pers["rank"] == 164 && newXp >= getRankInfoMaxXP( 164 ) )
		newXp = (getRankInfoMaxXP( 164 ) - 1);
	if ( self.pers["rank"] == 219 && newXp >= getRankInfoMaxXP( 219 ) )
		newXp = (getRankInfoMaxXP( 219 ) - 1);

	self.pers["rankxp"] = newXp;
	self maps\mp\gametypes\_persistence::statSet( "rankxp", newXp );
}


