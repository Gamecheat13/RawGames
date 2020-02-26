#include maps\mp\_utility;
#include common_scripts\utility;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
InitializeActionArray()
{
	level.gametypeActions = [];

	// add any new gametype actions to this array along with their functions.
	// functions take one argument, the rule that contains the action
	level.gametypeActions[ "GiveAmmo" ] = ::DoGiveAmmo;
	level.gametypeActions[ "RemoveAmmo" ] = ::DoRemoveAmmo;
	level.gametypeActions[ "PlaySound" ] = ::DoPlaySound;
	level.gametypeActions[ "EnableUAV" ] = ::DoEnableUAV;
	level.gametypeActions[ "GiveScore" ] = ::DoGiveScore;
	level.gametypeActions[ "RemoveScore" ] = ::DoRemoveScore;
	level.gametypeActions[ "SetHeader" ] = ::DoSetHeader;
	level.gametypeActions[ "SetSubHeader" ] = ::DoSetSubHeader;
	level.gametypeActions[ "DisplayMessage" ] = ::DoDisplayMessage;
	level.gametypeActions[ "GiveHealth" ] = ::DoGiveHealth;
	level.gametypeActions[ "RemoveHealth" ] = ::DoRemoveHealth;
	level.gametypeActions[ "SetHealthRegen" ] = ::DoSetHealthRegen;
	level.gametypeActions[ "ChangeClass" ] = ::DoChangeClass;
	level.gametypeActions[ "ChangeTeam" ] = ::DoChangeTeam;
	level.gametypeActions[ "GivePerk" ] = ::DoGivePerk;
	level.gametypeActions[ "RemovePerk" ] = ::DoRemovePerk;
	level.gametypeActions[ "GiveInvuln" ] = ::DoGiveInvuln;
	level.gametypeActions[ "RemoveInvuln" ] = ::DoRemoveInvuln;
	level.gametypeActions[ "SetDamageModifier" ] = ::DoSetDamageModifier;
	level.gametypeActions[ "GiveKillstreak" ] = ::DoGiveKillstreak;
	level.gametypeActions[ "RemoveKillstreak" ] = ::DoRemoveKillstreak;
	level.gametypeActions[ "GiveLives" ] = ::DoGiveLives;
	level.gametypeActions[ "RemoveLives" ] = ::DoRemoveLives;
	level.gametypeActions[ "ScaleMoveSpeed" ] = ::DoScaleMoveSpeed;
	level.gametypeActions[ "ShowOnRadar" ] = ::DoShowOnRadar;

	level.conditionals = [];

	level.conditionals[ "Equals" ] = ::Equals;
	level.conditionals[ "==" ] = ::Equals;
	level.conditionals[ "!=" ] = ::NotEquals;
	level.conditionals[ "<" ] = ::LessThan;
	level.conditionals[ "<=" ] = ::LessThanEquals;
	level.conditionals[ ">" ] = ::GreaterThan;
	level.conditionals[ ">=" ] = ::GreaterThanEquals;
	level.conditionals[ "InPlace" ] = ::InPlace;

	level.conditionalLeftHandSide = [];

	level.conditionalLeftHandSide[ "PlayersLeft" ] = ::PlayersLeft;
	level.conditionalLeftHandSide[ "RoundsPlayed" ] = ::RoundsPlayed;
	level.conditionalLeftHandSide[ "HitBy" ] = ::HitBy;
	level.conditionalLeftHandSide[ "PlayersClass" ] = ::PlayersClass;
	level.conditionalLeftHandSide[ "VictimsClass" ] = ::PlayersClass;
	level.conditionalLeftHandSide[ "AttackersClass" ] = ::AttackersClass;
	level.conditionalLeftHandSide[ "PlayersPlace" ] = ::PlayersPlace;
	level.conditionalLeftHandSide[ "VictimsPlace" ] = ::PlayersPlace;
	level.conditionalLeftHandSide[ "AttackersPlace" ] = ::AttackersPlace;

	level.targets = [];

	level.targets[ "Everyone" ] = ::GetTargetEveryone;
	level.targets[ "PlayersLeft" ] = ::GetTargetPlayersLeft;
	level.targets[ "PlayersEliminated" ] = ::GetTargetPlayersEliminated;
	level.targets[ "PlayersTeam" ] = ::GetTargetPlayersTeam;
	level.targets[ "VictimsTeam" ] = ::GetTargetPlayersTeam;
	level.targets[ "OtherTeam" ] = ::GetTargetOtherTeam;
	level.targets[ "AttackersTeam" ] = ::GetTargetOtherTeam;
	level.targets[ "PlayersLeftOnPlayersTeam" ] = ::GetTargetPlayersLeftOnPlayersTeam;
	level.targets[ "PlayersLeftOnOtherTeam" ] = ::GetTargetPlayersLeftOnOtherTeam;
	level.targets[ "PlayersLeftOnVictimsTeam" ] = ::GetTargetPlayersLeftOnPlayersTeam;
	level.targets[ "PlayersLeftOnAttackersTeam" ] = ::GetTargetPlayersLeftOnOtherTeam;
	level.targets[ "PlayersEliminatedOnPlayersTeam" ] = ::GetTargetPlayersEliminatedOnPlayersTeam;
	level.targets[ "PlayersEliminatedOnOtherTeam" ] = ::GetTargetPlayersEliminatedOnOtherTeam;
	level.targets[ "PlayersEliminatedOnVictimsTeam" ] = ::GetTargetPlayersEliminatedOnPlayersTeam;
	level.targets[ "PlayersEliminatedOnAttackersTeam" ] = ::GetTargetPlayersEliminatedOnOtherTeam;
	level.targets[ "AssistingPlayers" ] = ::GetAssistingPlayers;
}

//******************************************************************************
// Conditional funcs
//******************************************************************************
Equals( param1, param2 )
{
	return param1 == param2;
}
NotEquals( param1, param2 )
{
	return param1 != param2;
}
LessThan( param1, param2 )
{
	return param1 < param2;
}
LessThanEquals( param1, param2 )
{
	return param1 <= param2;
}
GreaterThan( param1, param2 )
{
	return param1 > param2;
}
GreaterThanEquals( param1, param2 )
{
	return param1 >= param2;
}
InPlace( param1, param2 )
{
	if( param1 == param2 )
		return true;

	if( param2 == "top3" && param1 == "first" )
		return true;

	return false;
}
//******************************************************************************

//******************************************************************************
// Conditional LHS funcs
//******************************************************************************
PlayersLeft( rule )
{
	playersRemaining = maps\mp\gametypes\_gametype_variants::GetPlayersLeft();
	return playersRemaining.size;
}
RoundsPlayed( rule )
{
	// "roundsplayed" is 0 based so we add 1 and expect it to be 1..n
	return game["roundsplayed"] + 1;
}
HitBy( rule )
{
	meansOfDeath = rule.target[ "MeansOfDeath" ];
	weapon = rule.target[ "Weapon" ];

	if( !isDefined( meansOfDeath ) || !isDefined( weapon ) )
		return undefined;

	switch( weapon )
	{
		case "knife_ballistic_mp":
			return "knife";
	}

	switch( meansOfDeath )
	{
		case "MOD_PISTOL_BULLET":
		case "MOD_RIFLE_BULLET":
			return "bullet";
		case "MOD_MELEE":
		case "MOD_BAYONET":
			return "knife";
		case "MOD_HEAD_SHOT":
			return "headshot";
		case "MOD_GRENADE":
		case "MOD_GRENADE_SPLASH":
		case "MOD_PROJECTILE":
		case "MOD_PROJECTILE_SPLASH":
		case "MOD_EXPLOSIVE":
			return "explosive";
	}

	return undefined;
}
GetPlayersClass( player )
{
	return player.pers["class"];
}
PlayersClass( rule )
{
	player = rule.target[ "Player" ];
	return GetPlayersClass( player );
}
AttackersClass( rule )
{
	player = rule.target[ "Attacker" ];
	return GetPlayersClass( player );
}
GetPlayersPlace( player )
{
	maps\mp\gametypes\_globallogic::updatePlacement();
	if( !isDefined( level.placement["all"] ) )
		return;

	for( place = 0; place < level.placement["all"].size; place++ )
	{
		if( level.placement["all"][place] == player )
			break;
	}
	place++;

	if( place == 1 )
	{
		return "first";
	}
	else if( place <= 3 )
	{
		return "top3";
	}
	else if( place == level.placement["all"].size )
	{
		return "last";
	}

	return "middle";
}
PlayersPlace( rule )
{
	player = rule.target[ "Player" ];
	return GetPlayersPlace( player );
}
AttackersPlace( rule )
{
	player = rule.target[ "Attacker" ];
	return GetPlayersPlace( player );
}
//******************************************************************************

//******************************************************************************
// Target funcs
//******************************************************************************
GetTargetEveryone( rule )
{
	return level.players;
}
GetTargetPlayersLeft( rule )
{
	return maps\mp\gametypes\_gametype_variants::GetPlayersLeft();
}
GetTargetPlayersEliminated( rule )
{
	return maps\mp\gametypes\_gametype_variants::GetPlayersEliminated();
}
GetTargetPlayersTeam( rule )
{
	player = rule.target[ "Player" ];
	if( !isDefined( player ) )
		return [];

	return GetPlayersOnTeam( level.players, player.pers["team"] );
}
GetTargetOtherTeam( rule )
{
	player = rule.target[ "Player" ];
	if( !isDefined( player ) )
		return [];

	return GetPlayersOnTeam( level.players, getOtherTeam( player.pers["team"] ) );
}
GetTargetPlayersLeftOnPlayersTeam( rule )
{
	player = rule.target[ "Player" ];
	if( !isDefined( player ) )
		return [];

	return GetPlayersOnTeam( maps\mp\gametypes\_gametype_variants::GetPlayersLeft(), player.pers["team"] );
}
GetTargetPlayersLeftOnOtherTeam( rule )
{
	player = rule.target[ "Player" ];
	if( !isDefined( player ) )
		return [];

	return GetPlayersOnTeam( maps\mp\gametypes\_gametype_variants::GetPlayersLeft(), getOtherTeam( player.pers["team"] ) );
}
GetTargetPlayersEliminatedOnPlayersTeam( rule )
{
	player = rule.target[ "Player" ];
	if( !isDefined( player ) )
		return [];

	return GetPlayersOnTeam( maps\mp\gametypes\_gametype_variants::GetPlayersEliminated(), player.pers["team"] );
}
GetTargetPlayersEliminatedOnOtherTeam( rule )
{
	player = rule.target[ "Player" ];
	if( !isDefined( player ) )
		return [];

	return GetPlayersOnTeam( maps\mp\gametypes\_gametype_variants::GetPlayersEliminated(), getOtherTeam( player.pers["team"] ) );
}
GetAssistingPlayers( rule )
{
	assisters = [];
	attacker = rule.target[ "Attacker" ];

	if( !isDefined( rule.target[ "Assisters" ] ) || !isDefined( attacker ) )
		return assisters;

	for ( j = 0; j < rule.target[ "Assisters" ].size; j++ )
	{
		player = rule.target[ "Assisters" ][j];
	
		if ( !isDefined( player ) )
			continue;
				
		if ( player == attacker )
			continue;
					
		assisters[ assisters.size ] = player;
	}
	return assisters;	
}
//******************************************************************************

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
ExecuteGametypeEventRule( rule )
{
	// Evaluate conditional and, if false, do not execute the rule.
	if( !AreGametypeEventRuleConditionalsMet( rule ) )
	{
		return;
	}

	if( !isDefined( level.gametypeActions[ rule.action ] ) ) 
	{
		error("GAMETYPE VARIANTS - unknown action:  " + rule.action + "!");
		return;
	}

	thread InternalExecuteRule( rule );
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
InternalExecuteRule( rule )
{
	if( isDefined( rule.secondsToDelayExecution ) && rule.secondsToDelayExecution > 0 )
	{
		wait rule.secondsToDelayExecution;
	}

	[[level.gametypeActions[ rule.action ]]]( rule );

	if( isDefined( rule.executeOnce ) && rule.executeOnce )
	{
		maps\mp\gametypes\_gametype_variants::RemoveGametypeEventRule( rule );
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
AreGametypeEventRuleConditionalsMet( rule )
{
	if( !isDefined( rule.conditionals ) || rule.conditionals.size == 0 )
		return true;
	
	combinedResult = true;
	if( rule.conditionalEval == "OR" )
	{
		combinedResult = false;
	}
	for( i = 0; i < rule.conditionals.size; i++ )
	{
		conditionalResult = EvaluateGametypeEventRuleConditional( rule, rule.conditionals[ i ] );

		switch( rule.conditionalEval )
		{
			case "AND":
				combinedResult = combinedResult && conditionalResult;
				break;
			case "OR":
				combinedResult = combinedResult || conditionalResult;
				break;
		}

		// Short circuit our evals
		if( rule.conditionalEval == "AND" && !combinedResult )
			break;
		if( rule.conditionalEval == "OR" && combinedResult )
			break;
	}

	return combinedResult;
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
EvaluateGametypeEventRuleConditional( rule, conditional )
{
	if( !isDefined( conditional.lhs ) || !isDefined( conditional.operand ) || !isDefined( conditional.rhs ) )
		return false;

	if( !isDefined( level.conditionalLeftHandSide[ conditional.lhs ] ) )
		return false;

	lhsValue = [[level.conditionalLeftHandSide[ conditional.lhs ]]]( rule );
	
	if( !isdefined( lhsValue ) || !isDefined( level.conditionals[ conditional.operand ] ) )
		return false;

	return [[level.conditionals[ conditional.operand ]]]( lhsValue, conditional.rhs );
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
GetPlayersOnTeam( players, team )
{
	playersOnTeam = [];
	for( i = 0; i < players.size; i++ )
	{
		player = players[ i ];
		if( player.pers["team"] == team )
		{
			playersOnTeam[ playersOnTeam.size ] = player;
		}
	}
	return playersOnTeam;
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
GetTargetsForGameTypeEventRule( rule )
{
	targets = [];
	if( !isDefined( rule.targetName ) )
		return targets;

	if( isDefined( rule.target[ rule.targetName ] ) )
	{
		targets[ targets.size ] = rule.target[ rule.targetName ];
	}
	else if( isDefined( level.targets[ rule.targetName ] ) )
	{
		targets = [[level.targets[ rule.targetName ]]]( rule );
	}
	return targets;
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoesRuleHaveValidParam( rule )
{
	return isDefined( rule.params ) && isArray( rule.params ) && rule.params.size > 0;
}

//------------------------------------------------------------------------------
// ===================== GAMETYPE VARIANT ACTIONS ==============================
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
SortPlayersByLivesDescending( players )
{
	if( !isDefined( players ) )
	{
		return undefined;
	}
	
	swapped = true;
	n = players.size;
	while ( swapped )
	{
		swapped = false;
		for( i = 0 ; i < n-1 ; i++ )
		{
			if( players[i].pers["lives"] < players[i+1].pers["lives"] )
			{
				temp = players[i];
				players[i] = players[i+1];
				players[i+1] = temp;
				swapped = true;
			}
		}
		n--;
	}
	return players;
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
GiveAmmo( players, amount )
{
	for( i = 0 ; i < players.size ; i++ )
	{
		wait 0.5;
		player = players[ i ];
		currentWeapon = player getCurrentWeapon();
		clipAmmo = player GetWeaponAmmoClip( currentWeapon );
		player SetWeaponAmmoClip( currentWeapon, clipAmmo + amount );
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoGiveAmmo( rule )
{
	if( !DoesRuleHaveValidParam( rule ) )
		return;

	targets = GetTargetsForGameTypeEventRule( rule );
	GiveAmmo( targets, rule.params[ 0 ] );
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoRemoveAmmo( rule )
{
	if( !DoesRuleHaveValidParam( rule ) )
		return;

	targets = GetTargetsForGameTypeEventRule( rule );
	GiveAmmo( targets, 0 - rule.params[ 0 ] );
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoPlaySound( rule )
{
	if( DoesRuleHaveValidParam( rule ) )
	{
		playSoundOnPlayers( rule.params[ 0 ] );
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoEnableUAV( rule )
{
	targets = GetTargetsForGameTypeEventRule( rule );
	for( targetIndex = 0 ; targetIndex < targets.size ; targetIndex++ )
	{
		targets[targetIndex].pers["hasRadar"] = true;
		targets[targetIndex].hasSpyplane = true;
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
GiveScore( players, amount )
{
	for( i = 0 ; i < players.size ; i++ )
	{
		player = players[ i ];
		score = maps\mp\gametypes\_globallogic_score::_getPlayerScore( player );
		maps\mp\gametypes\_globallogic_score::_setPlayerScore( player, score + amount );
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoGiveScore( rule )
{
	if( !DoesRuleHaveValidParam( rule ) )
		return;

	targets = GetTargetsForGameTypeEventRule( rule );
	GiveScore( targets, rule.params[ 0 ] );
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoRemoveScore( rule )
{
	if( !DoesRuleHaveValidParam( rule ) )
		return;

	targets = GetTargetsForGameTypeEventRule( rule );
	GiveScore( targets, 0 - rule.params[ 0 ] );
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoSetHeader( rule )
{
	if( !DoesRuleHaveValidParam( rule ) )
		return;

	targets = GetTargetsForGameTypeEventRule( rule );
	for( targetIndex = 0 ; targetIndex < targets.size ; targetIndex++ )
	{
		target = targets[targetIndex];
		DisplayTextOnHudElem( target, target.customGametypeHeader, rule.params[ 0 ], rule.params[ 1 ], "gv_header", rule.params[ 2 ] );
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoSetSubHeader( rule )
{
	if( !DoesRuleHaveValidParam( rule ) )
		return;

	targets = GetTargetsForGameTypeEventRule( rule );
	for( targetIndex = 0 ; targetIndex < targets.size ; targetIndex++ )
	{
		target = targets[targetIndex];
		DisplayTextOnHudElem( target, target.customGametypeSubHeader, rule.params[ 0 ], rule.params[ 1 ], "gv_subheader", rule.params[ 2 ] );
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DisplayTextOnHudElem( target, textHudElem, text, secondsToDisplay, notifyName, valueParam )
{
	textHudElem.alpha = 1;
	if( isDefined( valueParam ) )
	{
		textHudElem setText( text, valueParam );
	}
	else
	{
		textHudElem setText( text );
	}
	if( !isDefined( secondsToDisplay ) || secondsToDisplay <= 0 )
	{
		target.doingNotify = false;
		target notify( notifyName );
		return;
	}

	target thread FadeCustomGametypeHudElem( textHudElem, secondsToDisplay, notifyName );
}
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
FadeCustomGametypeHudElem( hudElem, seconds, notifyName )
{
	self endon( "disconnect" );

	self notify( notifyName );
	self endon( notifyName );
	
	if( seconds <= 0 )
		return;

	self.doingNotify = true;
	
	wait seconds;
	
	while ( hudElem.alpha > 0 )
	{
		hudElem.alpha -= 0.05;
		if( hudElem.alpha < 0 )
			hudElem.alpha = 0;
		wait 0.05;
	}

	self.doingNotify = false;
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoDisplayMessage( rule )
{
	if( !DoesRuleHaveValidParam( rule ) )
		return;

	targets = GetTargetsForGameTypeEventRule( rule );
	for( targetIndex = 0 ; targetIndex < targets.size ; targetIndex++ )
	{
		thread AnnounceMessage( targets[targetIndex], rule.params[ 0 ], 2.0 );
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
AnnounceMessage( target, messageText, time )
{
	target endon( "disconnect" );

	ClientAnnouncement( target, messageText, int( time * 1000 ) );
	if( time == 0 )
	{
		time = GetDvarfloat( "con_minicontime" );
	}

	target.doingNotify = true;

	wait time;

	target.doingNotify = false;
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
GiveHealth( players, amount )
{
	for( i = 0 ; i < players.size ; i++ )
	{
		player = players[ i ];
		player.health = ( player.health + amount );
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoGiveHealth( rule )
{
	if( !DoesRuleHaveValidParam( rule ) )
		return;

	GiveHealth( GetTargetsForGameTypeEventRule( rule ), rule.params[ 0 ] );
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoRemoveHealth( rule )
{
	if( !DoesRuleHaveValidParam( rule ) )
		return;

	GiveHealth( GetTargetsForGameTypeEventRule( rule ), 0 - rule.params[ 0 ] );
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoSetHealthRegen( rule )
{
	targets = GetTargetsForGameTypeEventRule( rule );
	for( targetIndex = 0 ; targetIndex < targets.size ; targetIndex++ )
	{
		player = targets[ targetIndex ];
		player.regenRate = rule.params[ 0 ];
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoChangeClass( rule )
{
	if( !DoesRuleHaveValidParam( rule ) )
		return;

	if( !maps\mp\gametypes\_customClasses::isUsingCustomGameModeClasses() )
		return;

	class = rule.params[ 0 ];
	if( !isDefined( class ) || class == "" )
		return;

	targets = GetTargetsForGameTypeEventRule( rule );
	for( targetIndex = 0 ; targetIndex < targets.size ; targetIndex++ )
	{
		target = targets[ targetIndex ];
		// don't change to a class you already have
		if( target.pers["class"] == class )
		{
			continue;
		}
		target.pers["class"] = class;
		target.class = class;

		target maps\mp\gametypes\_class::setClass( target.pers["class"] );
		target.tag_stowed_back = undefined;
		target.tag_stowed_hip = undefined;
		target maps\mp\gametypes\_class::giveLoadout( target.pers["team"], target.pers["class"] );
		target maps\mp\killstreaks\_killstreaks::giveOwnedKillstreak();
		target notify( "changed_class" );
		target maps\mp\gametypes\_gametype_variants::OnPlayerClassChange();
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoChangeTeam( rule )
{
	if( !DoesRuleHaveValidParam( rule ) )
		return;

	team = rule.params[ 0 ];

	targets = GetTargetsForGameTypeEventRule( rule );
	for ( targetIndex = 0 ; targetIndex < targets.size ; targetIndex++ )
	{
		target = targets[ targetIndex ];

		if( target.pers["team"] == team )
		{
			continue;
		}

		if( team == "toggle" )
		{
			team = "axis";
			if( target.pers["team"] == "axis" )
			{
				team = "allies";
			}
		}
		target.pers["team"] = team;
		target.team = team;

		if ( level.teamBased )
			target.sessionteam = team;
		else
		{
			target.sessionteam = "none";
		}
		target notify("joined_team");
		level notify( "joined_team" );
		target maps\mp\gametypes\_gametype_variants::OnPlayerTeamChange();
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DisplayPerk( player, imageName )
{
	index = 0;
	if( isDefined( player.perkicon ) )
	{
		index = -1;
		for( i = 0; i < player.perkicon.size; i++ )
		{
			if( player.perkicon[ i ].alpha == 0 )
			{
				index = i;
				break;
			}
		}
		if( index == -1 )
			return;
	}
	player maps\mp\gametypes\_hud_util::showPerk( index, imageName, 10);
	player thread maps\mp\gametypes\_globallogic_ui::hideLoadoutAfterTime( 3.0 );
	player thread maps\mp\gametypes\_globallogic_ui::hideLoadoutOnDeath();
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
SetOrUnsetPerk( players, perks, shouldSet )
{
	if( GetDvarint( "scr_game_perks" ) == 0 )
		return;
	if( perks.size < 2 )
		return;

	hasPerkAlready = false;
	imageName = perks[ perks.size - 1 ];
	for( i = 0 ; i < players.size ; i++ )
	{
		player = players[ i ];
		for( perkIndex = 0; perkIndex < perks.size - 1; perkIndex++ )
		{
			perk = perks[ perkIndex ];
			if( player hasPerk( perk ) )
			{
				hasPerkAlready = true;
			}

			if( shouldSet )
			{
				player setPerk( perk );
			}
			else
			{
				player unsetPerk( perk );
			}
		}
		if( shouldSet && !hasPerkAlready && GetDvarint( "scr_showperksonspawn" ) == 1 )
		{
			DisplayPerk( player, imageName );
		}
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoGivePerk( rule )
{
	if( !DoesRuleHaveValidParam( rule ) )
		return;

	SetOrUnsetPerk( GetTargetsForGameTypeEventRule( rule ), rule.params, true );
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoRemovePerk( rule )
{
	if( !DoesRuleHaveValidParam( rule ) )
		return;

	SetOrUnsetPerk( GetTargetsForGameTypeEventRule( rule ), rule.params, false );
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
GiveOrRemoveKillstreak( rule, shouldGive )
{
	if( !DoesRuleHaveValidParam( rule ) )
		return;

	killstreak = maps\mp\killstreaks\_killstreaks::getKillstreakByMenuName( rule.params[ 0 ] );

	targets = GetTargetsForGameTypeEventRule( rule );
	for ( targetIndex = 0 ; targetIndex < targets.size ; targetIndex++ )
	{
		target = targets[ targetIndex ];
		if( shouldGive )
		{
			targets[ targetIndex ] maps\mp\killstreaks\_killstreaks::giveKillstreak( killstreak );
		}
		else
		{
			weapon = maps\mp\killstreaks\_killstreaks::getKillstreakWeapon( killstreak );
			target TakeWeapon( weapon );

			if( isDefined( target.pers["killstreaks"] ) )
			{
				for( c=0; c < target.pers["killstreaks"].size; c++ )
				{
					if( target.pers["killstreaks"][c] == killstreak )
					{
						target.pers["killstreaks"][c] = undefined;
					}
				}
				array_removeUndefined( target.pers["killstreaks"] );
			}
			//target setActionSlot( 4, "" );
		}
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoGiveKillstreak( rule )
{
	GiveOrRemoveKillstreak( rule, true );
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoRemoveKillstreak( rule )
{
	GiveOrRemoveKillstreak( rule, false );
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
GiveLives( players, amount )
{
	for( i = 0 ; i < players.size ; i++ )
	{
		player = players[ i ];
		player.pers["lives"] += amount;
		if( player.pers["lives"] < 0 )
		{
			player.pers["lives"] = 0;
		}
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoGiveLives( rule )
{
	if( !DoesRuleHaveValidParam( rule ) )
		return;

	GiveLives( GetTargetsForGameTypeEventRule( rule ), rule.params[ 0 ] );
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoRemoveLives( rule )
{
	if( !DoesRuleHaveValidParam( rule ) )
		return;

	GiveLives( GetTargetsForGameTypeEventRule( rule ), 0 - rule.params[ 0 ] );
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
GiveOrRemoveInvuln( players, shouldGiveInvuln )
{
	for( i = 0 ; i < players.size ; i++ )
	{
		player = players[ i ];
		// TODO: enable these when new exe's are made
		//if( shouldGiveInvuln )
		//	player EnableInvulnerability();
		//else
		//	player DisableInvulnerability();
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoGiveInvuln( rule )
{
	GiveOrRemoveInvuln( GetTargetsForGameTypeEventRule( rule ), true );
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoRemoveInvuln( rule )
{
	GiveOrRemoveInvuln( GetTargetsForGameTypeEventRule( rule ), false );
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoSetDamageModifier( rule )
{
	if( !DoesRuleHaveValidParam( rule ) )
		return;

	players = GetTargetsForGameTypeEventRule( rule );
	for( i = 0 ; i < players.size ; i++ )
	{
		player = players[ i ];
		player.damageModifier = rule.params[ 0 ];
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoScaleMoveSpeed( rule )
{
	if( !DoesRuleHaveValidParam( rule ) )
		return;

	moveSpeedScale = rule.params[ 0 ];

	targets = GetTargetsForGameTypeEventRule( rule );
	for ( targetIndex = 0 ; targetIndex < targets.size ; targetIndex++ )
	{
		target = targets[ targetIndex ];
		target.movementSpeedModifier = moveSpeedScale * target getMoveSpeedScale();
		if( target.movementSpeedModifier < 0.1 )
		{
			target.movementSpeedModifier = 0.1;
		}
		else if( target.movementSpeedModifier > 4.0 )
		{
			target.movementSpeedModifier = 4.0;
		}
		target setMoveSpeedScale( target.movementSpeedModifier );
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
DoShowOnRadar( rule )
{
	if( !DoesRuleHaveValidParam( rule ) )
	return;

	targets = GetTargetsForGameTypeEventRule( rule );
	for ( targetIndex = 0 ; targetIndex < targets.size ; targetIndex++ )
	{
		if( rule.params[ 0 ] == "enable" )
		{
			targets[ targetIndex ] setPerk( "specialty_showonradar" );
		}
		else
		{
			targets[ targetIndex ] unsetPerk( "specialty_showonradar" );
		}
	}
}
