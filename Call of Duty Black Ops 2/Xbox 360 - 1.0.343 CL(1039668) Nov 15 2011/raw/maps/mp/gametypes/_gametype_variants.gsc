#include maps\mp\_utility;
#include common_scripts\utility;

#insert raw\common_scripts\utility.gsh;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
init()
{
	InitializeEvents();
	maps\mp\gametypes\_gv_actions::InitializeActionArray();

	LoadGameRules();

	thread gametypeVariantsThink();

	thread gametypeVariantsOnPlayerConnect();
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
gametypeVariantsThink()
{
	level endon( "game_ended" );

	while( true )
	{
		wait( 1.0 );

		checkTimeReachedEvents();
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
gametypeVariantsOnPlayerConnect()
{
	level endon( "game_ended" );

	for( ;; )
	{
		level waittill( "connecting", player );
		
		player thread gametypeVariantsOnPlayerDisconnect();
	}
}

//------------------------------------------------------------------------------
// self = player
//------------------------------------------------------------------------------
gametypeVariantsOnPlayerDisconnect()
{
	level endon ( "game_ended" );

	self waittill ( "disconnect" );
	
	if( level.numLives )
	{
		self onPlayerEliminated();
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
InitializeEvents()
{
	level.gametypeEvents = [];
	level.gametypeEvents["OnKill"] = [];
	level.gametypeEvents["OnPlayerElimination"] = [];
	level.gametypeEvents["OnTimeReached"] = [];
	level.gametypeEvents["OnRoundBegin"] = [];
	level.gametypeEvents["OnRoundEnd"] = [];
	// GVTODO: implement these events
	level.gametypeEvents["OnPlayerSpawn"] = [];
	level.gametypeEvents["OnPlayerTakeDamage"] = [];
	level.gametypeEvents["OnPlayerTeamChange"] = [];
	level.gametypeEvents["OnPlayerClassChange"] = [];
	level.gametypeEvents["OnPlayerKillstreakEarned"] = [];
	level.gametypeEvents["OnPlayerKillstreakActivated"] = [];
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
LoadGameRules()
{
	if( !SessionModeIsPrivate() || GetDvar( "ui_custommodename" ) == "" )
		return;

	numGameRules = GetNumGVRules();
	for( ruleNum = 0; ruleNum < numGameRules; ruleNum++ )
	{
		ruleDef = GetGVRule( ruleNum );
		rule = CreateEventRuleParamsArray( ruleDef["action"], ruleDef["target"], ruleDef["param"] );
		if( ruleDef["action"] == "SetHeader" || ruleDef["action"] == "SetSubHeader" )
		{
			rule.params[ 1 ] = 3.0;
		}
		if( isDefined( ruleDef["condlhs"] ) )
		{
			AddConditionalToRule( rule, ruleDef["condlhs"], ruleDef["condop"], ruleDef["condrhs"] );
		}
		
		AddGametypeEventRule( ruleDef["event"], rule );
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
AddGametypeEventRule( eventName, newRule )
{
	newRule.target = [];
	newRule.eventName = eventName;
	level.gametypeEvents[eventName][level.gametypeEvents[eventName].size] = newRule;
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
RemoveGametypeEventRule( rule )
{
	level.gametypeEvents[rule.eventName] = array_remove( level.gametypeEvents[rule.eventName], rule );
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
IsPlayerEliminated( player )
{
	return isDefined( player.pers["eliminated"] ) && player.pers["eliminated"];
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
GetPlayersLeft()
{
	playersRemaining = [];
	for( playerIndex = 0 ; playerIndex < level.players.size ; playerIndex++ )
	{
		player = level.players[ playerIndex ];
		if( !isDefined( player ) )
			continue;

		if( !IsPlayerEliminated( player ) )
		{
			playersRemaining[ playersRemaining.size ] = player;
		}
	}
	return playersRemaining;
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
GetPlayersEliminated()
{
	playersEliminated = [];
	for( playerIndex = 0 ; playerIndex < level.players.size ; playerIndex++ )
	{
		player = level.players[ playerIndex ];
		if( !isDefined( player ) )
			continue;

		if( IsPlayerEliminated( player ) )
		{
			playersEliminated[ playersEliminated.size ] = player;
		}
	}
	return playersEliminated;
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
GetGametypeEventRulesForEvent( eventName )
{
	if ( !isdefined( level.gametypeEvents ) || !isdefined( level.gametypeEvents[eventName] ) )
	{
		return undefined;
	}
	return level.gametypeEvents[eventName];
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
CreateEventRuleParamsArray( action, targetName, params )
{
	rule = spawnstruct();
	rule.action = action;
	rule.targetName = targetName;
	rule.params = params;
	rule.conditionals = [];
	rule.conditionalEval = "AND";

	return rule;
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
CreateEventRule( action, targetName, param1, param2, param3 )
{
	params = [];
	if( isDefined( param1 ) )
		params[ params.size ] = param1;
	if( isDefined( param2 ) )
		params[ params.size ] = param2;
	if( isDefined( param3 ) )
		params[ params.size ] = param3;

	return CreateEventRuleParamsArray( action, targetName, params );
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
IsPlaceConditional( conditionLhs )
{
	return conditionLhs == "PlayersPlace"
		|| conditionLhs == "VictimsPlace"
		|| conditionLhs == "AttackersPlace";
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
CreateConditional( condition, operand, param )
{
	if( IsPlaceConditional( condition ) )
	{
		operand = "InPlace";
	}
	conditional = spawnstruct();
	conditional.lhs = condition;
	conditional.operand = operand;
	conditional.rhs = param;
	return conditional;
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
AddConditionalToRule( rule, condition, operand, param )
{
	rule.conditionals[ rule.conditionals.size ] = CreateConditional( condition, operand, param );
}

//------------------------------------------------------------------------------
// ===================== GAMETYPE VARIANT EVENT CALLBACKS ======================
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// self = player
//------------------------------------------------------------------------------
playerKilled( attacker )
{
	rules = GetGametypeEventRulesForEvent( "OnKill" );
	if ( isdefined( rules ) )
	{
		for ( ruleIndex = 0 ; ruleIndex < rules.size ; ruleIndex++ )
		{
			ruleToExecute = rules[ruleIndex];
			ruleToExecute.target["Player"] = self;
			ruleToExecute.target["Attacker"] = attacker;
			ruleToExecute.target["Victim"] = self;
			if( isDefined( self.attackers ) )
			{
				ruleToExecute.target["Assisters"] = self.attackers;
			}
			thread maps\mp\gametypes\_gv_actions::ExecuteGametypeEventRule( ruleToExecute );
		}
	}
	
	self checkForPlayerElimination( attacker );
}

//------------------------------------------------------------------------------
// self = player
//------------------------------------------------------------------------------
onPlayerKillstreakEarned( )
{
	pixbeginevent( "onPlayerKillstreakEarned" );
	rules = GetGametypeEventRulesForEvent( "OnPlayerKillstreakEarned" );
	if ( isdefined( rules ) )
	{
		for ( ruleIndex = 0 ; ruleIndex < rules.size ; ruleIndex++ )
		{
			ruleToExecute = rules[ruleIndex];
			ruleToExecute.target["Player"] = self;
			thread maps\mp\gametypes\_gv_actions::ExecuteGametypeEventRule( ruleToExecute );
		}
	}
	pixendevent(); // "onPlayerKillstreakEarned"
}

//------------------------------------------------------------------------------
// self = player
//------------------------------------------------------------------------------
onPlayerKillstreakActivated( )
{
	rules = GetGametypeEventRulesForEvent( "OnPlayerKillstreakActivated" );
	if ( isdefined( rules ) )
	{
		for ( ruleIndex = 0 ; ruleIndex < rules.size ; ruleIndex++ )
		{
			ruleToExecute = rules[ruleIndex];
			ruleToExecute.target["Player"] = self;
			thread maps\mp\gametypes\_gv_actions::ExecuteGametypeEventRule( ruleToExecute );
		}
	}
}

//------------------------------------------------------------------------------
// self = player
//------------------------------------------------------------------------------
checkForPlayerElimination( attacker )
{
	if( level.numLives == 0 )
		return;

	noLivesLeft = ( self.pers["lives"] == 0 );
	if ( noLivesLeft )
	{
		self.pers["eliminated"] = true;
		self onPlayerEliminated( attacker );
	}
}

//------------------------------------------------------------------------------
// self = player
//------------------------------------------------------------------------------
onPlayerEliminated( attacker )
{
	// Player eliminated, run appropriate gametype event rules
	rules = GetGametypeEventRulesForEvent( "OnPlayerElimination" );
	if ( !isdefined( rules ) )
		return;

	for ( ruleIndex = 0 ; ruleIndex < rules.size ; ruleIndex++ )
	{
		ruleToExecute = rules[ruleIndex];
		ruleToExecute.target["Victim"] = self;
		ruleToExecute.target["Attacker"] = attacker;
		ruleToExecute.target["Player"] = self;
		thread maps\mp\gametypes\_gv_actions::ExecuteGametypeEventRule( ruleToExecute );
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
checkTimeReachedEvents()
{
	eventName = "OnTimeReached";
	rules = GetGametypeEventRulesForEvent( eventName );
	if( !isDefined( rules ) )
		return;

	rulesToRemove = [];
	timeRemaining = maps\mp\gametypes\_globallogic_utils::getTimeRemaining();
	for ( ruleIndex = 0 ; ruleIndex < rules.size ; ruleIndex++ )
	{
		ruleToCheck = rules[ ruleIndex ];
		if( timeRemaining <= ruleToCheck.time * 1000 )
		{
			thread maps\mp\gametypes\_gv_actions::ExecuteGametypeEventRule( ruleToCheck );
			ARRAY_ADD( rulesToRemove, ruleToCheck );
		}
	}

	level.gametypeEvents[ eventName ] = array_exclude( level.gametypeEvents[ eventName ], rulesToRemove );
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
onRoundBegin()
{
	eventName = "OnRoundBegin";
	rules = GetGametypeEventRulesForEvent( eventName );
	if( !isDefined( rules ) )
		return;

	for ( ruleIndex = 0 ; ruleIndex < rules.size ; ruleIndex++ )
	{
		rule = rules[ ruleIndex ];
		thread maps\mp\gametypes\_gv_actions::ExecuteGametypeEventRule( rule );
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
onRoundEnd()
{
	eventName = "OnRoundEnd";
	rules = GetGametypeEventRulesForEvent( eventName );
	if( !isDefined( rules ) )
		return;

	for ( ruleIndex = 0 ; ruleIndex < rules.size ; ruleIndex++ )
	{
		rule = rules[ ruleIndex ];
		thread maps\mp\gametypes\_gv_actions::ExecuteGametypeEventRule( rule );
	}
}

//------------------------------------------------------------------------------
// self = player
//------------------------------------------------------------------------------
onPlayerSpawn()
{
	eventName = "OnPlayerSpawn";
	rules = GetGametypeEventRulesForEvent( eventName );
	if( !isDefined( rules ) )
		return;

	for ( ruleIndex = 0 ; ruleIndex < rules.size ; ruleIndex++ )
	{
		rule = rules[ ruleIndex ];
		rule.target[ "Player" ] = self;
		thread maps\mp\gametypes\_gv_actions::ExecuteGametypeEventRule( rule );
	}
}

//------------------------------------------------------------------------------
// self = player
//------------------------------------------------------------------------------
OnPlayerTeamChange()
{
	eventName = "OnPlayerTeamChange";
	rules = GetGametypeEventRulesForEvent( eventName );
	if( !isDefined( rules ) )
		return;

	for ( ruleIndex = 0 ; ruleIndex < rules.size ; ruleIndex++ )
	{
		rule = rules[ ruleIndex ];
		rule.target[ "Player" ] = self;
		thread maps\mp\gametypes\_gv_actions::ExecuteGametypeEventRule( rule );
	}
}

//------------------------------------------------------------------------------
// self = player
//------------------------------------------------------------------------------
OnPlayerClassChange()
{
	eventName = "OnPlayerClassChange";
	rules = GetGametypeEventRulesForEvent( eventName );
	if( !isDefined( rules ) )
		return;

	for ( ruleIndex = 0 ; ruleIndex < rules.size ; ruleIndex++ )
	{
		rule = rules[ ruleIndex ];
		rule.target[ "Player" ] = self;
		thread maps\mp\gametypes\_gv_actions::ExecuteGametypeEventRule( rule );
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
onPlayerTakeDamage( attacker, inflictor, weapon, damage, meansOfDeath )
{
	eventName = "OnPlayerTakeDamage";
	rules = GetGametypeEventRulesForEvent( eventName );
	if( !isDefined( rules ) )
		return;

	for ( ruleIndex = 0 ; ruleIndex < rules.size ; ruleIndex++ )
	{
		rule = rules[ ruleIndex ];
		rule.target[ "Player" ] = self;
		rule.target[ "Victim" ] = self;
		rule.target[ "Attacker" ] = attacker;
		rule.target[ "Inflictor" ] = inflictor;
		rule.target[ "Weapon" ] = weapon;
		rule.target[ "Damage" ] = damage;
		rule.target[ "MeansOfDeath" ] = meansOfDeath;
		thread maps\mp\gametypes\_gv_actions::ExecuteGametypeEventRule( rule );
	}
}