#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_globallogic_score;
#include maps\mp\gametypes\_hud_util;

init()
{
	if ( GameModeIsMode( level.GAMEMODE_WAGER_MATCH ) && !isPregame() )
	{
		level.wagerMatch = 1;
		PrecacheString( &"MP_HEADS_UP" );
		PrecacheString( &"MP_U2_ONLINE" );
		PrecacheString( &"MP_BONUS_ACQUIRED" );
		if( !isDefined( game["wager_pot"] ) )
		{
			game["wager_pot"] = 0;
			game["wager_initial_pot"] = 0;
		}
		
		game["dialog"]["wm_u2_online"] = "boost_gen_02";
		game["dialog"]["wm_in_the_money"] = "boost_gen_06";
		game["dialog"]["wm_oot_money"] = "boost_gen_07";
		
		level.powerupList = [];
		
		level thread onPlayerConnect();
		level thread helpGameEnd();
	}
	else
	{
		level.wagerMatch = 0;
	}
	
	level.takeLivesOnDeath = true;
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		player thread onDisconnect();
		player thread initWagerPlayer();
	}
}

initWagerPlayer()
{
	self endon( "disconnect" );
	
	self waittill( "spawned_player" );
		
	if( !isDefined( self.pers["wager"] ) )
	{
		self.pers["wager"] = true;
		self.pers["wager_sideBetWinnings"] = 0;
		self.pers["wager_sideBetLosses"] = 0;
	}
	
	if ( ( IsDefined( level.inTheMoneyOnRadar ) && level.inTheMoneyOnRadar ) || ( IsDefined( level.firstPlaceOnRadar ) && level.firstPlaceOnRadar ) )
	{
		self.pers["hasRadar"] = true;
		self.hasSpyplane = true;
	}
	else
	{
		self.pers["hasRadar"] = false;
		self.hasSpyplane = false;
	}
	
	self thread deductPlayerAnte();
}


onDisconnect()
{
	level endon ( "game_ended" );
	self endon ( "player_eliminated" );

	self waittill ( "disconnect" );
	level notify( "player_eliminated" );
}


deductPlayerAnte()
{
	if( isDefined( self.pers["hasPaidWagerAnte"] ) )
		return;

	waittillframeend;

	codPoints = self maps\mp\gametypes\_rank::getCodPointsStat();
	wagerBet = GetDvarint( "scr_wagerBet" );
	if( wagerBet > codPoints )
	{
		// This should technically never happen since we boot any player with insufficient
		// funds but it is here to make sure you can never get negative CodPoints.
		wagerBet = codPoints;
	}
	codPoints -= wagerBet;
	self maps\mp\gametypes\_rank::setCodPointsStat( codPoints );
	if ( !self IsLocalToHost() )
		self incrementEscrowForPlayer( wagerBet );
	game["wager_pot"] += wagerBet;
	game["wager_initial_pot"] += wagerBet;

	self.pers["hasPaidWagerAnte"] = true;

	self AddPlayerStat( "LIFETIME_BUYIN", wagerBet );

	self addRecentEarningsToStat( 0 - wagerBet );

	if( isDefined( level.onWagerPlayerAnte ) )
	{
		[[level.onWagerPlayerAnte]]( self, wagerBet );
	}
	
	self thread maps\mp\gametypes\_persistence::uploadStatsSoon();
}

incrementEscrowForPlayer( amount )
{
	if ( !IsDefined( self ) || !IsPlayer( self ) )
		return;
		
	if ( !IsDefined( game["escrows"] ) )
		game["escrows"] = [];
		
	playerXUID = self GetXUID();
	if ( !IsDefined( playerXUID ) )
		return;
		
	IncrementEscrow( playerXUID, amount );
	
	escrowStruct = SpawnStruct();
	escrowStruct.xuid = playerXUID;
	escrowStruct.amount = amount;
	game["escrows"][game["escrows"].size] = escrowStruct;
}

clearEscrows()
{
	if ( !IsDefined( game["escrows"] ) )
		return;
		
	escrows = game["escrows"];
	numEscrows = escrows.size;
	for ( i = 0 ; i < numEscrows ; i++ )
	{
		escrowStruct = escrows[i];
		IncrementEscrow( escrowStruct.xuid, 0 - escrowStruct.amount );
	}
	game["escrows"] = [];
}

addRecentEarningsToStat( recentEarnings )
{
	currEarnings = self maps\mp\gametypes\_persistence::getRecentStat( true, 0, "score" );
	self maps\mp\gametypes\_persistence::setRecentStat( true, 0, "score", currEarnings + recentEarnings );
}

prematchPeriod()
{
	if ( !level.wagerMatch )
		return;
}

finalizeWagerRound()
{
	if ( level.wagerMatch == 0 )
		return;

	determineWagerWinnings();
	if( isDefined( level.onWagerFinalizeRound ) )
	{
		[[level.onWagerFinalizeRound]]();
	}
}

determineWagerWinnings()
{
	shouldCalculateWinnings = !isDefined( level.dontCalcWagerWinnings ) || !level.dontCalcWagerWinnings;
	if( !shouldCalculateWinnings )
	{
		return;
	}

	if( !level.teamBased )
	{
		calculateFreeForAllPayouts();
	}
	else
	{
		calculateTeamPayouts();
	}
}

calculateFreeForAllPayouts()
{
	playerRankings = level.placement["all"];
	payoutPercentages = array( 0.5, 0.3, 0.2 );
	if( playerRankings.size == 2 )
	{
		payoutPercentages = array( 0.7, 0.3 );
	}
	else if( playerRankings.size == 1 )
	{
		payoutPercentages = array( 1.0 );
	}

	setWagerWinningsOnPlayers( level.players, 0 );
	
	// If host quit and host migration failed give everyone except the host their money back
	if ( IsDefined( level.hostForcedEnd ) && level.hostForcedEnd )
	{
		wagerBet = GetDvarint( "scr_wagerBet" );
		for ( i = 0 ; i < playerRankings.size ; i++ )
		{
			if ( !playerRankings[i] IsLocalToHost() )
				playerRankings[i].wagerWinnings = wagerBet;
		}
	}
	// If host is the only one left in the game, no one gets anything (other players will get their money back later)
	else if ( level.players.size == 1 )
	{
		game["escrows"] = undefined;
		return;
	}
	else
	{		
		currentPayoutPercentage = 0;
		cumulativePayoutPercentage = payoutPercentages[0];
		playerGroup = [];
		playerGroup[playerGroup.size] = playerRankings[0];
		for ( i = 1 ; i < playerRankings.size ; i++ )
		{
			if ( playerRankings[i].pers["score"] < playerGroup[0].pers["score"] )
			{
				setWagerWinningsOnPlayers( playerGroup, int( game["wager_pot"] * cumulativePayoutPercentage / playerGroup.size ) );
				playerGroup = [];
				cumulativePayoutPercentage = 0;
			}
			playerGroup[playerGroup.size] = playerRankings[i];
			currentPayoutPercentage++;
			if ( IsDefined( payoutPercentages[currentPayoutPercentage] ) )
				cumulativePayoutPercentage += payoutPercentages[currentPayoutPercentage];
		}
		setWagerWinningsOnPlayers( playerGroup, int( game["wager_pot"] * cumulativePayoutPercentage / playerGroup.size ) );
	}
}

calculatePlacesBasedOnScore()
{
	// Put each player in a bucket for 1st, 2nd, and 3rd based on their score.
	// eg. if 3 players are tied for first, they will all go in the 0 index bucket.
	level.playerPlaces = array( [], [], [] );

	playerRankings = level.placement["all"];
	placementScores = array( playerRankings[ 0 ].pers["score"], -1, -1 );
	currentPlace = 0;
	for ( index = 0 ; index < playerRankings.size && currentPlace < placementScores.size ; index++ )
	{
		player = playerRankings[index];

		if( player.pers["score"] < placementScores[ currentPlace ] )
		{
			currentPlace++;
			if( currentPlace >= level.playerPlaces.size )
				break;

			placementScores[ currentPlace ] = player.pers["score"];
		}

		level.playerPlaces[ currentPlace ][ level.playerPlaces[ currentPlace ].size ] = player;
	}
}

calculateTeamPayouts()
{
	winner = "axis";
	if ( getGameScore( "allies" ) == getGameScore( "axis" ) )
		winner = "tie";
	else if ( getGameScore( "allies" ) > getGameScore( "axis" ) )
		winner = "allies";
	if( winner == "tie" )
	{
		calculateFreeForAllPayouts();
		return;
	}

	playersOnWinningTeam = [];
	for ( index = 0 ; index < level.players.size ; index++ )
	{
		player = level.players[index];

		player.wagerWinnings = 0;
		if( player.pers["team"] == winner )
		{
			playersOnWinningTeam[ playersOnWinningTeam.size ] = player;
		}
	}
	if( playersOnWinningTeam.size == 0 )
	{
		// The winning team has all been disconnected so just refund everyones buyin.
		setWagerWinningsOnPlayers( level.players, GetDvarint( "scr_wagerBet" ) );
		return;
	}
	winningsSplit = int( game["wager_pot"] / playersOnWinningTeam.size );
	setWagerWinningsOnPlayers( playersOnWinningTeam, winningsSplit );
}

setWagerWinningsOnPlayers( players, amount )
{
	for ( index = 0 ; index < players.size ; index++ )
	{
		players[index].wagerWinnings = amount;
	}
}

finalizeWagerGame()
{
	level.wagerGameFinalized = true;
	if ( level.wagermatch == 0 )
		return;

	determineWagerWinnings();
	determineTopEarners();

	players = level.players;
	wait 0.5;
	playerRankings = level.wagerTopEarners;

	for ( index = 0 ; index < players.size ; index++ )
	{
		player = players[index];

		if ( IsDefined( player.pers["wager_sideBetWinnings"] ) )
			payOutWagerWinnings( player, player.wagerWinnings + player.pers["wager_sideBetWinnings"] );
		else
			payOutWagerWinnings( player, player.wagerWinnings );
			
		if ( player.wagerWinnings > 0 )
		{
			maps\mp\gametypes\_globallogic_score::updateWinStats( player );
			
			// Check for "5 In The Money Finishes" achievement
			numWagerWins = 0;
			wagerGametypes = GetWagerGametypeList();
			for ( i = 0 ; i < wagerGametypes.size ; i++ )
			{
				wins = player getdstat( "PlayerStatsByGameMode", wagerGametypes[i], "StatValue", "wins" );
				numWagerWins += wins;
			}
			if ( numWagerWins >= 5 )
				player GiveAchievement( "MP_WAGER_MATCH" );
		}
	}
	clearEscrows();
}

payOutWagerWinnings( player, winnings )
{
	if( winnings == 0 )
		return;

	codPoints = player maps\mp\gametypes\_rank::getCodPointsStat();
	player maps\mp\gametypes\_rank::setCodPointsStat( codPoints + winnings );

	player AddPlayerStat( "LIFETIME_EARNINGS", winnings );

	player addRecentEarningsToStat( winnings );
}

determineTopEarners()
{
	topWinnings = array( -1, -1, -1 );
	level.wagerTopEarners = [];
	for ( index = 0 ; index < level.players.size ; index++ )
	{
		player = level.players[ index ];
		if( !isDefined( player.wagerWinnings ) )
		{
			player.wagerWinnings = 0;
		}

		if( player.wagerWinnings > topWinnings[ 0 ] )
		{
			topWinnings[ 2 ] = topWinnings[ 1 ];
			topWinnings[ 1 ] = topWinnings[ 0 ];
			topWinnings[ 0 ] = player.wagerWinnings;

			level.wagerTopEarners[ 2 ] = level.wagerTopEarners[ 1 ];
			level.wagerTopEarners[ 1 ] = level.wagerTopEarners[ 0 ];
			level.wagerTopEarners[ 0 ] = player;
		}
		else if( player.wagerWinnings > topWinnings[ 1 ] )
		{
			topWinnings[ 2 ] = topWinnings[ 1 ];
			topWinnings[ 1 ] = player.wagerWinnings;

			level.wagerTopEarners[ 2 ] = level.wagerTopEarners[ 1 ];
			level.wagerTopEarners[ 1 ] = player;
		}
		else if( player.wagerWinnings > topWinnings[ 2 ] )
		{
			topWinnings[ 2 ] = player.wagerWinnings;

			level.wagerTopEarners[ 2 ] = player;
		}
	}
}

postRoundSideBet()
{
	if ( isDefined( level.sidebet ) && level.sidebet )
	{
		level notify( "side_bet_begin" );
		level waittill( "side_bet_end" );
	}
}

SideBetTimer()
{
	level endon ( "side_bet_end" );

	secondsToWait = ( level.sideBetEndTime - GetTime() ) / 1000.0;
	if ( secondsToWait < 0 )
		secondsToWait = 0;
	wait( secondsToWait );
	for ( playerIndex = 0 ; playerIndex < level.players.size ; playerIndex++ )
	{
		if ( isDefined( level.players[playerIndex] ) )
			level.players[playerIndex] closeMenu();
	}
	level notify ( "side_bet_end" );
}

SideBetAllBetsPlaced()
{
	secondsLeft = ( level.sideBetEndTime - GetTime() ) / 1000.0;
	if( secondsLeft <= 3.0 )
		return;

	level.sideBetEndTime = GetTime() + 3000;

	wait 3;
	for ( playerIndex = 0 ; playerIndex < level.players.size ; playerIndex++ )
	{
		if ( isDefined( level.players[playerIndex] ) )
			level.players[playerIndex] closeMenu();
	}
	level notify ( "side_bet_end" );
}


setupBlankRandomPlayer( takeWeapons, chooseRandomBody )
{
	if ( !IsDefined( chooseRandomBody ) || chooseRandomBody )
	{
		if ( !IsDefined( self.pers["wagerBodyAssigned"] ) )
		{
			self assignRandomBody();
			self.pers["wagerBodyAssigned"] = true;
		}

		self maps\mp\teams\_teams::set_player_model( self.team );
	}
	
	self clearPerks();
	self.killstreak = [];
	self.pers["killstreaks"] = [];
	self.pers["killstreak_has_been_used"] = [];
	self.pers["killstreak_unique_id"] = [];
	if ( !IsDefined( takeWeapons ) || takeWeapons )
		self takeAllWeapons();
		
	if ( IsDefined( self.pers["hasRadar"] ) && self.pers["hasRadar"] )
		self.hasSpyplane = true;
	
	if ( IsDefined( self.powerups ) && IsDefined( self.powerups.size ) )
	{
		for ( i = 0 ; i < self.powerups.size ; i++ )
			self applyPowerup( self.powerups[i] );
	}
	
	self setRadarVisibility();
}

assignRandomBody()
{
	self.cac_body_type = random( GetArrayKeys( level.cac_functions[ "set_body_model" ] ) );
	//self.cac_head_type = self maps\mp\gametypes\_armor::get_default_head();
	self.cac_hat_type = "none";
}

queueWagerPopup( message, points, subMessage, announcement )
{
	self endon("disconnect");

	size = self.wagerNotifyQueue.size;
	self.wagerNotifyQueue[size] = spawnstruct();
	self.wagerNotifyQueue[size].message = message;
	self.wagerNotifyQueue[size].points = points;
	self.wagerNotifyQueue[size].subMessage = subMessage;
	self.wagerNotifyQueue[size].announcement = announcement;
	
	self notify( "received award" );
}

helpGameEnd()
{
	level endon( "game_ended" );
	
	for ( ;; )
	{
		level waittill( "player_eliminated" );
		
		if ( !IsDefined( level.numLives ) || !level.numLives )
			continue;
		
		wait 0.05; // in case multiple players are eliminated simultaneously
	
		players = level.players;
		playersLeft = 0;
		for ( i = 0 ; i < players.size ; i++ )
		{
			if ( IsDefined( players[i].pers["lives"] ) && ( players[i].pers["lives"] > 0 ) )
			{
				playersLeft++;
			}
		}
		
		if ( playersLeft == 2 )
		{
			for ( i = 0 ; i < players.size ; i++ )
			{
				players[i] queueWagerPopup( &"MP_HEADS_UP", 0, &"MP_U2_ONLINE", "wm_u2_online" );
				players[i].pers["hasRadar"] = true;
				players[i].hasSpyplane = true;
				level.activeUAVs[players[i] getEntityNumber()]++;
			}
		}
	}
}

setRadarVisibility()
{
	prevScorePlace = self.prevScorePlace;
	if ( !IsDefined( prevScorePlace ) )
		prevScorePlace = 1;

	if ( IsDefined( level.inTheMoneyOnRadar ) && level.inTheMoneyOnRadar )
	{
		if ( prevScorePlace <= 3 && IsDefined( self.score ) && ( self.score > 0 ) )
			self unsetPerk( "specialty_gpsjammer" );
		else
			self setPerk( "specialty_gpsjammer" );
	}		
	else if ( IsDefined( level.firstPlaceOnRadar ) && level.firstPlaceOnRadar )
	{
		if ( prevScorePlace == 1 && IsDefined( self.score ) && ( self.score > 0 ) )
			self unsetPerk( "specialty_gpsjammer" );
		else
			self setPerk( "specialty_gpsjammer" );
	}
}

playerScored()
{
	self notify( "wager_player_scored" );
	self endon( "wager_player_scored" );
	
	wait( 0.05 ); // Let other simultaneous sounds play first
	
	maps\mp\gametypes\_globallogic::updatePlacement();
	for ( i = 0 ; i < level.placement["all"].size ; i++ )
	{
		prevScorePlace = level.placement["all"][i].prevScorePlace;
		if ( !IsDefined( prevScorePlace ) )
			prevScorePlace = 1;
		currentScorePlace = i + 1;
		for ( j = i - 1 ; j >= 0 ; j-- )
		{
			if ( level.placement["all"][i].score == level.placement["all"][j].score )
				currentScorePlace--;
		}
		wasInTheMoney = ( prevScorePlace <= 3 );
		isInTheMoney = ( currentScorePlace <= 3 );
		
		if ( !wasInTheMoney && isInTheMoney )
		{
			level.placement["all"][i] wagerAnnouncer( "wm_in_the_money" );
		}
		else if ( wasInTheMoney && !isInTheMoney )
		{
			level.placement["all"][i] wagerAnnouncer( "wm_oot_money" );
		}
		level.placement["all"][i].prevScorePlace = currentScorePlace;
		level.placement["all"][i] setRadarVisibility();
	}
}

wagerAnnouncer( dialog, group )
{
	self maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( dialog, group );
}

createPowerup( name, type, displayName, iconMaterial )
{
	powerup = spawnstruct();
	powerup.name = [];
	powerup.name[0] = name;
	powerup.type = type;
	powerup.displayName = displayName;
	powerup.iconMaterial = iconMaterial;
	
	return powerup;
}

addPowerup( name, type, displayName, iconMaterial )
{
	if ( !isDefined( level.powerupList ) )
		level.powerupList = [];
		
	for ( i = 0 ; i < level.powerupList.size ; i++ )
	{
		if ( level.powerupList[i].displayName == displayName )
		{
			level.powerupList[i].name[level.powerupList[i].name.size] = name;
			return;
		}
	}
		
	powerup = createPowerup( name, type, displayName, iconMaterial );
	
	level.powerupList[level.powerupList.size] = powerup;
}

copyPowerup( powerup )
{
	return createPowerup( powerup.name[0], powerup.type, powerup.displayName, powerup.iconMaterial );
}

applyPowerup( powerup )
{
	switch ( powerup.type )
	{
		case "primary":
			self giveWeapon( powerup.name[0] );
			self switchToWeapon( powerup.name[0] );
			break;
			
		case "secondary":
			self giveWeapon( powerup.name[0] );
			break;
			
		case "equipment":
			self GiveWeapon( powerup.name[0] );
			self maps\mp\gametypes\_class::setWeaponAmmoOverall( powerup.name[0], 1 );
			self SetActionSlot( 1, "weapon", powerup.name[0] );
			break;
		
		case "primary_grenade":
			self setOffhandPrimaryClass( powerup.name[0] );
			self giveWeapon( powerup.name[0] );
			self setWeaponAmmoClip( powerup.name[0], 2 );
			break;
			
		case "secondary_grenade":
			self setOffhandSecondaryClass( powerup.name[0] );
			self giveWeapon( powerup.name[0] );
			self setWeaponAmmoClip( powerup.name[0], 2 );
			break;
			
		case "perk":
			for ( i = 0 ; i < powerup.name.size ; i++ )
				self setPerk( powerup.name[i] );
			break;
			
		case "killstreak":
			self maps\mp\killstreaks\_killstreaks::giveKillstreak( powerup.name[0] );
			break;
			
		case "score_multiplier":
			self.scoreMultiplier = powerup.name[0];
			break;
	}
}

givePowerup( powerup, doAnimation )
{
	if ( !isDefined( self.powerups ) )
		self.powerups = [];
		
	powerupIndex = self.powerups.size;
	self.powerups[powerupIndex] = copyPowerup( powerup );
	for ( i = 0 ; i < powerup.name.size ; i++ )
	{
		self.powerups[powerupIndex].name[self.powerups[powerupIndex].name.size] = powerup.name[i];
	}
	
	self applyPowerup( self.powerups[powerupIndex] );
	
	self thread showPowerupMessage( powerupIndex, doAnimation );
}

pulsePowerupIcon( powerupIndex )
{	
	if ( !IsDefined( self ) || !IsDefined( self.powerups ) || !IsDefined( self.powerups[powerupIndex] ) || !IsDefined( self.powerups[powerupIndex].hud_elem_icon ) )
		return;
		
	self endon( "disconnect" );
	self endon( "delete" );
	self endon( "clearing_powerups" );

	pulsePercent = 1.5;	
	pulseTime = 0.5;
	
	hud_elem = self.powerups[powerupIndex].hud_elem_icon;
	if ( IsDefined( hud_elem.animating ) && hud_elem.animating )
		return;
	origX = hud_elem.x;
	origY = hud_elem.y;
	origWidth = hud_elem.width;
	origHeight = hud_elem.height;
	bigWidth = origWidth * pulsePercent;
	bigHeight = origHeight * pulsePercent;
	xOffset = ( bigWidth - origWidth ) / 2;
	yOffset = ( bigHeight - origHeight ) / 2;
	hud_elem ScaleOverTime( 0.05, int( bigWidth ), int( bigHeight ) );
	hud_elem MoveOverTime( 0.05 );
	hud_elem.x = origX - xOffset;
	hud_elem.y = origY - yOffset;
	wait 0.05;
	hud_elem ScaleOverTime( pulseTime, origWidth, origHeight );
	hud_elem MoveOverTime( pulseTime );
	hud_elem.x = origX;
	hud_elem.y = origY;
}

showPowerupMessage( powerupIndex, doAnimation )
{
	self endon( "disconnect" );
	self endon( "delete" );
	self endon( "clearing_powerups" );
	
	if ( !IsDefined( doAnimation ) )
		doAnimation = true;
		
	wasInPrematch = level.inPrematchPeriod;
	
	powerupStartY = 280;
	powerupSpacing = 40;
	if ( self IsSplitscreen() )
	{
		powerupStartY = 120;
		powerupSpacing = 35;
	}
	
	// Text elem
	if ( IsDefined( self.powerups[powerupIndex].hud_elem ) )
		self.powerups[powerupIndex].hud_elem destroy();
	self.powerups[powerupIndex].hud_elem = NewClientHudElem( self );
	self.powerups[powerupIndex].hud_elem.fontScale = 1.5;
	
	self.powerups[powerupIndex].hud_elem.x = -125;
	self.powerups[powerupIndex].hud_elem.y = powerupStartY - powerupSpacing * powerupIndex;
	self.powerups[powerupIndex].hud_elem.alignX = "left";
	self.powerups[powerupIndex].hud_elem.alignY = "middle";
	self.powerups[powerupIndex].hud_elem.horzAlign = "user_right";
	self.powerups[powerupIndex].hud_elem.vertAlign = "user_top";
	self.powerups[powerupIndex].hud_elem.color = ( 1, 1, 1 );

	self.powerups[powerupIndex].hud_elem.foreground = true;
	self.powerups[powerupIndex].hud_elem.hidewhendead = false;
	self.powerups[powerupIndex].hud_elem.hidewheninmenu = true;
	self.powerups[powerupIndex].hud_elem.hidewheninkillcam = true;
	self.powerups[powerupIndex].hud_elem.archived = false;
	self.powerups[powerupIndex].hud_elem.alpha = 0.0;
	self.powerups[powerupIndex].hud_elem SetText( self.powerups[powerupIndex].displayName );
	
	// Icon elem
	
	bigIconSize = 40;
	iconSize = 32;
	if ( IsDefined( self.powerups[powerupIndex].hud_elem_icon ) )
		self.powerups[powerupIndex].hud_elem_icon destroy();
	if ( doAnimation )
	{
		self.powerups[powerupIndex].hud_elem_icon = self createIcon( self.powerups[powerupIndex].iconMaterial, bigIconSize, bigIconSize );
		self.powerups[powerupIndex].hud_elem_icon.animating = true;
	}
	else
		self.powerups[powerupIndex].hud_elem_icon = self createIcon( self.powerups[powerupIndex].iconMaterial, iconSize, iconSize );
	
	self.powerups[powerupIndex].hud_elem_icon.x = self.powerups[powerupIndex].hud_elem.x - 5 - iconSize / 2 - bigIconSize / 2;
	self.powerups[powerupIndex].hud_elem_icon.y = powerupStartY - powerupSpacing * powerupIndex - bigIconSize / 2;
	self.powerups[powerupIndex].hud_elem_icon.horzAlign = "user_right";
	self.powerups[powerupIndex].hud_elem_icon.vertAlign = "user_top";
	self.powerups[powerupIndex].hud_elem_icon.color = ( 1, 1, 1 );

	self.powerups[powerupIndex].hud_elem_icon.foreground = true;
	self.powerups[powerupIndex].hud_elem_icon.hidewhendead = false;
	self.powerups[powerupIndex].hud_elem_icon.hidewheninmenu = true;
	self.powerups[powerupIndex].hud_elem_icon.hidewheninkillcam = true;
	self.powerups[powerupIndex].hud_elem_icon.archived = false;
	self.powerups[powerupIndex].hud_elem_icon.alpha = 1.0;
	
	if ( !wasInPrematch && doAnimation )
		self thread queueWagerPopup( self.powerups[powerupIndex].displayName, 0, &"MP_BONUS_ACQUIRED" );
	
	pulseTime = 0.5;
	if ( doAnimation )
	{
		self.powerups[powerupIndex].hud_elem FadeOverTime( pulseTime );
		self.powerups[powerupIndex].hud_elem_icon ScaleOverTime( pulseTime, iconSize, iconSize );
		self.powerups[powerupIndex].hud_elem_icon.width = iconSize;
		self.powerups[powerupIndex].hud_elem_icon.height = iconSize;
		self.powerups[powerupIndex].hud_elem_icon MoveOverTime( pulseTime );
	}
	
	self.powerups[powerupIndex].hud_elem.alpha = 1.0;
	self.powerups[powerupIndex].hud_elem_icon.x = self.powerups[powerupIndex].hud_elem.x - 5 - iconSize;
	self.powerups[powerupIndex].hud_elem_icon.y = powerupStartY - powerupSpacing * powerupIndex - iconSize / 2;
	
	if ( doAnimation )
	{
		wait( pulseTime );
	}
	
	if ( level.inPrematchPeriod )
	{
		level waittill( "prematch_over" );
	}
	else if ( doAnimation )
	{
		wait ( pulseTime );
	}
	
	if ( wasInPrematch && doAnimation )
		self thread queueWagerPopup( self.powerups[powerupIndex].displayName, 0, &"MP_BONUS_ACQUIRED" );
	
	wait ( 5.0 );
	for ( i = 0 ; i <= powerupIndex ; i++ )
	{
		self.powerups[i].hud_elem FadeOverTime( 0.25 );
		self.powerups[i].hud_elem.alpha = 0;
	}
	
	wait ( 0.25 );
	for ( i = 0 ; i <= powerupIndex ; i++ )
	{
		self.powerups[i].hud_elem_icon MoveOverTime( 0.25 );
		self.powerups[i].hud_elem_icon.x = 0 - iconSize;
		self.powerups[i].hud_elem_icon.horzAlign = "user_right";
	}
	
	self.powerups[powerupIndex].hud_elem_icon.animating = false;
}

clearPowerups()
{
	self notify( "clearing_powerups" );
	if ( IsDefined( self.powerups ) && IsDefined( self.powerups.size ) )
	{
		for ( i = 0 ; i < self.powerups.size ; i++ )
		{
			if ( IsDefined( self.powerups[i].hud_elem ) )
				self.powerups[i].hud_elem destroy();
			if ( IsDefined( self.powerups[i].hud_elem_icon ) )
				self.powerups[i].hud_elem_icon destroy();
		}
	}
	self.powerups = [];
}

trackWagerWeaponUsage( name, incValue, statName )
{	
	if ( !IsDefined( self.wagerWeaponUsage ) )
		self.wagerWeaponUsage = [];
	
	if ( !IsDefined( self.wagerWeaponUsage[name] ) )
		self.wagerWeaponUsage[name] = [];
		
	if ( !IsDefined( self.wagerWeaponUsage[name][statName] ) )
		self.wagerWeaponUsage[name][statName] = 0;
		
	self.wagerWeaponUsage[name][statName] += incValue;
}

getHighestWagerWeaponUsage( statName )
{
	if ( !IsDefined( self.wagerWeaponUsage ) )
		return undefined;
	
	bestWeapon = undefined;
	highestValue = 0;
	
	wagerWeaponsUsed = GetArrayKeys( self.wagerWeaponUsage );
	for ( i = 0 ; i < wagerWeaponsUsed.size ; i++ )
	{
		weaponStats = self.wagerWeaponUsage[wagerWeaponsUsed[i]];
		if ( !IsDefined( weaponStats[statName] ) || !GetBaseWeaponItemIndex( wagerWeaponsUsed[i] ) )
			continue;
		else if ( !IsDefined( bestWeapon ) || ( weaponStats[statName] > highestValue ) )
		{
			bestWeapon = wagerWeaponsUsed[i];
			highestValue = weaponStats[statName];
		}
	}
	
	return bestWeapon;
}

setWagerAfterActionReportStats()
{		
	topWeapon = self getHighestWagerWeaponUsage( "kills" );
	topKills = 0;
	if ( IsDefined( topWeapon ) )
		topKills = self.wagerWeaponusage[topWeapon]["kills"];
	else
		topWeapon = self getHighestWagerWeaponUsage( "timeUsed" );
	
	if ( !IsDefined( topWeapon ) )
		topWeapon = "";
		
	self maps\mp\gametypes\_persistence::setAfterActionReportStat( "topWeaponItemIndex", GetBaseWeaponItemIndex( topWeapon ) );
	self maps\mp\gametypes\_persistence::setAfterActionReportStat( "topWeaponKills", topKills );
	
	if ( IsDefined( level.onWagerAwards ) )
		self [[level.onWagerAwards]]();
	else
	{
		for ( i = 0 ; i < 3 ; i++ )
			self maps\mp\gametypes\_persistence::setAfterActionReportStat( "wagerAwards", 0, i );
	}
}