#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_loadout;
#using scripts\mp\gametypes\_persistence;
#using scripts\mp\gametypes\_rank;

#using scripts\mp\_util;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\teams\_teams;

#precache( "string", "MP_HEADS_UP" );
#precache( "string", "MP_U2_ONLINE" );
#precache( "string", "MP_BONUS_ACQUIRED" );

#namespace wager;

function autoexec __init__sytem__() {     system::register("wager",&__init__,undefined,undefined);    }

function __init__()
{
	callback::on_start_gametype( &init );
}

function init()
{
	if ( GameModeIsMode( 3 ) )
	{
		level.wagerMatch = 1;

		if( !isdefined( game["wager_pot"] ) )
		{
			game["wager_pot"] = 0;
			game["wager_initial_pot"] = 0;
		}
		
		game["dialog"]["wm_u2_online"] = "boost_gen_02";
		game["dialog"]["wm_in_the_money"] = "boost_gen_06";
		game["dialog"]["wm_oot_money"] = "boost_gen_07";
		
		level.powerupList = [];
		
		callback::on_disconnect( &on_disconnect );
		callback::on_spawned( &init_player );
		level thread help_game_end();
	}
	else
	{
		level.wagerMatch = 0;
	}
	
	level.takeLivesOnDeath = true;
}

function init_player()
{
	self endon( "disconnect" );
		
	if( !isdefined( self.pers["wager"] ) )
	{
		self.pers["wager"] = true;
		self.pers["wager_sideBetWinnings"] = 0;
		self.pers["wager_sideBetLosses"] = 0;
	}
	
	if ( ( isdefined( level.inTheMoneyOnRadar ) && level.inTheMoneyOnRadar ) || ( isdefined( level.firstPlaceOnRadar ) && level.firstPlaceOnRadar ) )
	{
		self.pers["hasRadar"] = true;
		self.hasSpyplane = true;
	}
	else
	{
		self.pers["hasRadar"] = false;
		self.hasSpyplane = false;
	}
	
	self thread deduct_player_ante();
}


function on_disconnect()
{
	level endon ( "game_ended" );
	self endon ( "player_eliminated" );

	level notify( "player_eliminated" );
}


function deduct_player_ante()
{
	if( isdefined( self.pers["hasPaidWagerAnte"] ) )
	{
		return;
	}

	waittillframeend;

	codPoints = self rank::getCodPointsStat();
	wagerBet = GetDvarint( "scr_wagerBet" );
	if( wagerBet > codPoints )
	{
		// This should technically never happen since we boot any player with insufficient
		// funds but it is here to make sure you can never get negative CodPoints.
		wagerBet = codPoints;
	}
	codPoints -= wagerBet;
	self rank::setCodPointsStat( codPoints );
	if ( !self IsLocalToHost() )
	{
		self increment_escrow_for_player( wagerBet );
	}
	game["wager_pot"] += wagerBet;
	game["wager_initial_pot"] += wagerBet;

	self.pers["hasPaidWagerAnte"] = true;

	self AddPlayerStat( "LIFETIME_BUYIN", wagerBet );

	self add_recent_earnings_to_stat( 0 - wagerBet );

	if( isdefined( level.onWagerPlayerAnte ) )
	{
		[[level.onWagerPlayerAnte]]( self, wagerBet );
	}
	
	self thread persistence::upload_stats_soon();
}

function increment_escrow_for_player( amount )
{
	if ( !isdefined( self ) || !IsPlayer( self ) )
	{
		return;
	}
		
	if ( !isdefined( game["escrows"] ) )
	{
		game["escrows"] = [];
	}
		
	playerXUID = self GetXUID();
	if ( !isdefined( playerXUID ) )
	{
		return;
	}
		
	//IncrementEscrow( playerXUID, amount );
	
	escrowStruct = SpawnStruct();
	escrowStruct.xuid = playerXUID;
	escrowStruct.amount = amount;
	game["escrows"][game["escrows"].size] = escrowStruct;
}

function clear_escrows()
{
	if ( !isdefined( game["escrows"] ) )
	{
		return;
	}
		
	escrows = game["escrows"];
	numEscrows = escrows.size;
	for ( i = 0 ; i < numEscrows ; i++ )
	{
		escrowStruct = escrows[i];
		//IncrementEscrow( escrowStruct.xuid, 0 - escrowStruct.amount );
	}
	game["escrows"] = [];
}

function add_recent_earnings_to_stat( recentEarnings )
{
	currEarnings = self persistence::get_recent_stat( true, 0, "score" );
	self persistence::set_recent_stat( true, 0, "score", currEarnings + recentEarnings );
}

function prematch_period()
{
	if ( !level.wagerMatch )
	{
		return;
	}
}

function finalize_round()
{
	if ( level.wagerMatch == 0 )
	{
		return;
	}

	determine_winnings();
	if( isdefined( level.onWagerFinalizeRound ) )
	{
		[[level.onWagerFinalizeRound]]();
	}
}

function determine_winnings()
{
	shouldCalculateWinnings = !isdefined( level.dontCalcWagerWinnings ) || !level.dontCalcWagerWinnings;
	if( !shouldCalculateWinnings )
	{
		return;
	}

	if( !level.teamBased )
	{
		calculate_free_for_all_payouts();
	}
	else
	{
		calculate_team_payouts();
	}
}

function calculate_free_for_all_payouts()
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

	set_winnings_on_players( level.players, 0 );
	
	// If host quit and host migration failed give everyone except the host their money back
	if ( isdefined( level.hostForcedEnd ) && level.hostForcedEnd )
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
				set_winnings_on_players( playerGroup, int( game["wager_pot"] * cumulativePayoutPercentage / playerGroup.size ) );
				playerGroup = [];
				cumulativePayoutPercentage = 0;
			}
			playerGroup[playerGroup.size] = playerRankings[i];
			currentPayoutPercentage++;
			if ( isdefined( payoutPercentages[currentPayoutPercentage] ) )
			{
				cumulativePayoutPercentage += payoutPercentages[currentPayoutPercentage];
			}
		}
		set_winnings_on_players( playerGroup, int( game["wager_pot"] * cumulativePayoutPercentage / playerGroup.size ) );
	}
}

function calculate_places_based_on_score()
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
			{
				break;
			}

			placementScores[ currentPlace ] = player.pers["score"];
		}

		level.playerPlaces[ currentPlace ][ level.playerPlaces[ currentPlace ].size ] = player;
	}
}

function calculate_team_payouts()
{
	winner = globallogic::determineTeamWinnerByGameStat( "teamScores" );
	if( winner == "tie" )
	{
		calculate_free_for_all_payouts();
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
		set_winnings_on_players( level.players, GetDvarint( "scr_wagerBet" ) );
		return;
	}
	winningsSplit = int( game["wager_pot"] / playersOnWinningTeam.size );
	set_winnings_on_players( playersOnWinningTeam, winningsSplit );
}

function set_winnings_on_players( players, amount )
{
	for ( index = 0 ; index < players.size ; index++ )
	{
		players[index].wagerWinnings = amount;
	}
}

function finalize_game()
{
	level.wagerGameFinalized = true;
	if ( level.wagermatch == 0 )
	{
		return;
	}

	determine_winnings();
	determine_top_earners();

	players = level.players;
	wait 0.5;
	playerRankings = level.wagerTopEarners;

	for ( index = 0 ; index < players.size ; index++ )
	{
		player = players[index];

		if ( isdefined( player.pers["wager_sideBetWinnings"] ) )
			pay_out_winnings( player, player.wagerWinnings + player.pers["wager_sideBetWinnings"] );
		else
			pay_out_winnings( player, player.wagerWinnings );
			
		if ( player.wagerWinnings > 0 )
		{
			globallogic_score::updateWinStats( player );
		}
	}
	clear_escrows();
}

function pay_out_winnings( player, winnings )
{
	if( winnings == 0 )
	{
		return;
	}

	codPoints = player rank::getCodPointsStat();
	player rank::setCodPointsStat( codPoints + winnings );

	player AddPlayerStat( "LIFETIME_EARNINGS", winnings );

	player add_recent_earnings_to_stat( winnings );
}

function determine_top_earners()
{
	topWinnings = array( -1, -1, -1 );
	level.wagerTopEarners = [];
	for ( index = 0 ; index < level.players.size ; index++ )
	{
		player = level.players[ index ];
		if( !isdefined( player.wagerWinnings ) )
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

function post_round_side_bet()
{
	if ( isdefined( level.sidebet ) && level.sidebet )
	{
		level notify( "side_bet_begin" );
		level waittill( "side_bet_end" );
	}
}

function side_bet_timer()
{
	level endon ( "side_bet_end" );

	secondsToWait = ( level.sideBetEndTime - GetTime() ) / 1000.0;
	if ( secondsToWait < 0 )
	{
		secondsToWait = 0;
	}
	wait( secondsToWait );
	level notify ( "side_bet_end" );
}

function side_bet_all_bets_placed()
{
	secondsLeft = ( level.sideBetEndTime - GetTime() ) / 1000.0;
	if( secondsLeft <= 3.0 )
	{
		return;
	}

	level.sideBetEndTime = GetTime() + 3000;

	wait 3;
	level notify ( "side_bet_end" );
}


function setup_blank_random_player( takeWeapons, chooseRandomBody, weapon )
{
	if ( !isdefined( chooseRandomBody ) || chooseRandomBody )
	{
		if ( !isdefined( self.pers["wagerBodyAssigned"] ) )
		{
			self assign_random_body();
			self.pers["wagerBodyAssigned"] = true;
		}

		self teams::set_player_model( self.team, weapon );
	}
	
	self clearPerks();
	self.killstreak = [];
	self.pers["killstreaks"] = [];
	self.pers["killstreak_has_been_used"] = [];
	self.pers["killstreak_unique_id"] = [];
	if ( !isdefined( takeWeapons ) || takeWeapons )
	{
		self takeAllWeapons();
	}
		
	if ( isdefined( self.pers["hasRadar"] ) && self.pers["hasRadar"] )
	{
		self.hasSpyplane = true;
	}
	
	if ( isdefined( self.powerups ) && isdefined( self.powerups.size ) )
	{
		for ( i = 0 ; i < self.powerups.size ; i++ )
		{
			self apply_powerup( self.powerups[i] );
		}
	}
	
	self set_radar_visibility();
}

function assign_random_body()
{
	//self.cac_body_type = array::random( GetArrayKeys( level.cac_functions[ "set_body_model" ] ) );
	//self.cac_head_type = self _armor::get_default_head();
	//self.cac_hat_type = "none";
}

function queue_popup( message, points, subMessage, announcement )
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

function help_game_end()
{
	level endon( "game_ended" );
	
	for ( ;; )
	{
		level waittill( "player_eliminated" );
		
		if ( !isdefined( level.numLives ) || !level.numLives )
		{
			continue;
		}
		
		{wait(.05);}; // in case multiple players are eliminated simultaneously
	
		players = level.players;
		playersLeft = 0;
		for ( i = 0 ; i < players.size ; i++ )
		{
			if ( isdefined( players[i].pers["lives"] ) && ( players[i].pers["lives"] > 0 ) )
			{
				playersLeft++;
			}
		}
		
		if ( playersLeft == 2 )
		{
			for ( i = 0 ; i < players.size ; i++ )
			{
				players[i] queue_popup( &"MP_HEADS_UP", 0, &"MP_U2_ONLINE", "wm_u2_online" );
				players[i].pers["hasRadar"] = true;
				players[i].hasSpyplane = true;
				
				if ( level.teambased )
				{
					assert( isdefined( players[i].team ) );
					level.activePlayerUAVs[players[i].team]++;
				}
				else
				{
					level.activePlayerUAVs[players[i] getEntityNumber()]++;
				}
				
				level.activePlayerUAVs[players[i] getEntityNumber()]++;
			}
		}
	}
}

function set_radar_visibility()
{
	prevScorePlace = self.prevScorePlace;
	if ( !isdefined( prevScorePlace ) )
	{
		prevScorePlace = 1;
	}

	if ( isdefined( level.inTheMoneyOnRadar ) && level.inTheMoneyOnRadar )
	{
		if ( prevScorePlace <= 3 && isdefined( self.score ) && ( self.score > 0 ) )
		{
			self unsetPerk( "specialty_gpsjammer" );
		}
		else
		{
			self setPerk( "specialty_gpsjammer" );
		}
	}		
	else if ( isdefined( level.firstPlaceOnRadar ) && level.firstPlaceOnRadar )
	{
		if ( prevScorePlace == 1 && isdefined( self.score ) && ( self.score > 0 ) )
		{
			self unsetPerk( "specialty_gpsjammer" );
		}
		else
		{
			self setPerk( "specialty_gpsjammer" );
		}
	}
}

function player_scored()
{
	self notify( "wager_player_scored" );
	self endon( "wager_player_scored" );
	
	{wait(.05);}; // Let other simultaneous sounds play first
	
	globallogic::updatePlacement();
	for ( i = 0 ; i < level.placement["all"].size ; i++ )
	{
		prevScorePlace = level.placement["all"][i].prevScorePlace;
		if ( !isdefined( prevScorePlace ) )
		{
			prevScorePlace = 1;
		}
		currentScorePlace = i + 1;
		for ( j = i - 1 ; j >= 0 ; j-- )
		{
			if ( level.placement["all"][i].score == level.placement["all"][j].score )
			{
				currentScorePlace--;
			}
		}
		wasInTheMoney = ( prevScorePlace <= 3 );
		isInTheMoney = ( currentScorePlace <= 3 );
		
		if ( !wasInTheMoney && isInTheMoney )
		{
			level.placement["all"][i] announcer( "wm_in_the_money" );
		}
		else if ( wasInTheMoney && !isInTheMoney )
		{
			level.placement["all"][i] announcer( "wm_oot_money" );
		}
		level.placement["all"][i].prevScorePlace = currentScorePlace;
		level.placement["all"][i] set_radar_visibility();
	}
}

function announcer( dialog, group )
{
	self globallogic_audio::leader_dialog_on_player( dialog, group );
}

function create_powerup( name, type, displayName, iconMaterial )
{
	powerup = spawnstruct();
	powerup.name = [];
	powerup.name[0] = name;
	powerup.type = type;
	powerup.displayName = displayName;
	powerup.iconMaterial = iconMaterial;
	
	return powerup;
}

function add_powerup( name, type, displayName, iconMaterial )
{
	if ( !isdefined( level.powerupList ) )
	{
		level.powerupList = [];
	}
		
	for ( i = 0 ; i < level.powerupList.size ; i++ )
	{
		if ( level.powerupList[i].displayName == displayName )
		{
			level.powerupList[i].name[level.powerupList[i].name.size] = name;
			return;
		}
	}
		
	powerup = create_powerup( name, type, displayName, iconMaterial );
	
	level.powerupList[level.powerupList.size] = powerup;
}

function copy_powerup( powerup )
{
	return create_powerup( powerup.name[0], powerup.type, powerup.displayName, powerup.iconMaterial );
}

function apply_powerup( powerup )
{
	weapon = level.weaponNone;
	switch ( powerup.type )
	{
		case "primary":
		case "secondary":
		case "equipment":
		case "primary_grenade":
		case "secondary_grenade":
			weapon = GetWeapon( powerup.name[0] );
			break;
	}

	switch ( powerup.type )
	{
		case "primary":
			self giveWeapon( weapon );
			self switchToWeapon( weapon );
			break;
			
		case "secondary":
			self giveWeapon( weapon );
			break;
			
		case "equipment":
			self GiveWeapon( weapon );
			self loadout::setWeaponAmmoOverall( weapon, 1 );
			self SetActionSlot( 1, "weapon", weapon );
			break;
		
		case "primary_grenade":
			self setOffhandPrimaryClass( weapon );
			self giveWeapon( weapon );
			self setWeaponAmmoClip( weapon, 2 );
			break;
			
		case "secondary_grenade":
			self setOffhandSecondaryClass( weapon );
			self giveWeapon( weapon );
			self setWeaponAmmoClip( weapon, 2 );
			break;
			
		case "perk":
			for ( i = 0 ; i < powerup.name.size ; i++ )
				self setPerk( powerup.name[i] );
			break;
			
		case "killstreak":
			self killstreaks::give( powerup.name[0] );
			break;
			
		case "score_multiplier":
			self.scoreMultiplier = powerup.name[0];
			break;
	}
}

function give_powerup( powerup, doAnimation )
{
	if ( !isdefined( self.powerups ) )
	{
		self.powerups = [];
	}
		
	powerupIndex = self.powerups.size;
	self.powerups[powerupIndex] = copy_powerup( powerup );
	for ( i = 0 ; i < powerup.name.size ; i++ )
	{
		self.powerups[powerupIndex].name[self.powerups[powerupIndex].name.size] = powerup.name[i];
	}
	
	self apply_powerup( self.powerups[powerupIndex] );
	
	self thread show_powerup_message( powerupIndex, doAnimation );
}

function pulse_powerup_icon( powerupIndex )
{	
	if ( !isdefined( self ) || !isdefined( self.powerups ) || !isdefined( self.powerups[powerupIndex] ) || !isdefined( self.powerups[powerupIndex].hud_elem_icon ) )
	{
		return;
	}
		
	self endon( "disconnect" );
	self endon( "delete" );
	self endon( "clearing_powerups" );

	pulsePercent = 1.5;	
	pulseTime = 0.5;
	
	hud_elem = self.powerups[powerupIndex].hud_elem_icon;
	if ( isdefined( hud_elem.animating ) && hud_elem.animating )
	{
		return;
	}
	
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
	
	{wait(.05);};
	
	hud_elem ScaleOverTime( pulseTime, origWidth, origHeight );
	hud_elem MoveOverTime( pulseTime );
	hud_elem.x = origX;
	hud_elem.y = origY;
}

function show_powerup_message( powerupIndex, doAnimation )
{
	self endon( "disconnect" );
	self endon( "delete" );
	self endon( "clearing_powerups" );
	
	if ( !isdefined( doAnimation ) )
	{
		doAnimation = true;
	}
		
	wasInPrematch = level.inPrematchPeriod;
	
	powerupStartY = 320;
	powerupSpacing = 40;
	if ( self IsSplitscreen() )
	{
		powerupStartY = 120;
		powerupSpacing = 35;
	}
	
	// Text elem
	if ( isdefined( self.powerups[powerupIndex].hud_elem ) )
	{
		self.powerups[powerupIndex].hud_elem destroy();
	}
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
	if ( isdefined( self.powerups[powerupIndex].hud_elem_icon ) )
	{
		self.powerups[powerupIndex].hud_elem_icon destroy();
	}
	if ( doAnimation )
	{
		self.powerups[powerupIndex].hud_elem_icon = self hud::createIcon( self.powerups[powerupIndex].iconMaterial, bigIconSize, bigIconSize );
		self.powerups[powerupIndex].hud_elem_icon.animating = true;
	}
	else
	{
		self.powerups[powerupIndex].hud_elem_icon = self hud::createIcon( self.powerups[powerupIndex].iconMaterial, iconSize, iconSize );
	}
	
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
	{
		self thread queue_popup( self.powerups[powerupIndex].displayName, 0, &"MP_BONUS_ACQUIRED" );
	}
	
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
	{
		self thread queue_popup( self.powerups[powerupIndex].displayName, 0, &"MP_BONUS_ACQUIRED" );
	}
	
	wait ( 1.5 );
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

function clear_powerups()
{
	self notify( "clearing_powerups" );
	if ( isdefined( self.powerups ) && isdefined( self.powerups.size ) )
	{
		for ( i = 0 ; i < self.powerups.size ; i++ )
		{
			if ( isdefined( self.powerups[i].hud_elem ) )
			{
				self.powerups[i].hud_elem destroy();
			}
			if ( isdefined( self.powerups[i].hud_elem_icon ) )
			{
				self.powerups[i].hud_elem_icon destroy();
			}
		}
	}
	self.powerups = [];
}

function track_weapon_usage( name, incValue, statName )
{	
	if ( !isdefined( self.wagerWeaponUsage ) )
	{
		self.wagerWeaponUsage = [];
	}
	
	if ( !isdefined( self.wagerWeaponUsage[name] ) )
	{
		self.wagerWeaponUsage[name] = [];
	}
		
	if ( !isdefined( self.wagerWeaponUsage[name][statName] ) )
	{
		self.wagerWeaponUsage[name][statName] = 0;
	}
		
	self.wagerWeaponUsage[name][statName] += incValue;
}

function get_highest_weapon_usage( statName )
{
	if ( !isdefined( self.wagerWeaponUsage ) )
	{
		return undefined;
	}
	
	bestWeapon = undefined;
	highestValue = 0;
	
	wagerWeaponsUsed = GetArrayKeys( self.wagerWeaponUsage );
	for ( i = 0 ; i < wagerWeaponsUsed.size ; i++ )
	{
		weaponStats = self.wagerWeaponUsage[wagerWeaponsUsed[i]];
		if ( !isdefined( weaponStats[statName] ) || !GetBaseWeaponItemIndex( wagerWeaponsUsed[i] ) )
		{
			continue;
		}
		else if ( !isdefined( bestWeapon ) || ( weaponStats[statName] > highestValue ) )
		{
			bestWeapon = wagerWeaponsUsed[i];
			highestValue = weaponStats[statName];
		}
	}
	
	return bestWeapon;
}

function set_after_action_report_stats()
{		
	topWeapon = self get_highest_weapon_usage( "kills" );
	topKills = 0;
	if ( isdefined( topWeapon ) )
	{
		topKills = self.wagerWeaponusage[topWeapon]["kills"];
	}
	else
	{
		topWeapon = self get_highest_weapon_usage( "timeUsed" );
	}
	
	if ( !isdefined( topWeapon ) )
	{
		topWeapon = "";
	}
		
	self persistence::set_after_action_report_stat( "topWeaponItemIndex", GetBaseWeaponItemIndex( topWeapon ) );
	self persistence::set_after_action_report_stat( "topWeaponKills", topKills );
	
	if ( isdefined( level.onWagerAwards ) )
	{
		self [[level.onWagerAwards]]();
	}
	else
	{
		for ( i = 0 ; i < 3 ; i++ )
		{
			self persistence::set_after_action_report_stat( "wagerAwards", 0, i );
		}
	}
}