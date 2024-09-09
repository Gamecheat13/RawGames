#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_damage;
#include maps\mp\gametypes\_gamelogic;
#include maps\mp\agents\_agent_utility;

//=======================================================================
//								main 
// This is functions is called directly from native code on game startup
// The particular gametype's main() is called from native code afterward
//=======================================================================
main()
{
	if( IsDefined( level.createFX_enabled ) && level.createFX_enabled )
		return;

	setup_callbacks();
	maps\mp\bots\_bots::setup_persistent_values();

	// Enable badplaces in destructibles
	level.badplace_cylinder_func 	= ::badplace_cylinder;
	level.badplace_delete_func 		= ::badplace_delete;
	
	level thread init();
	level thread maps\mp\killstreaks\_agent_killstreak::init();
	level thread maps\mp\killstreaks\_dog_killstreak::init();
}


//========================================================
//					setup_callbacks 
//========================================================
setup_callbacks()
{
	if ( !IsDefined( level.agent_funcs ) )
		level.agent_funcs = [];
	
	level.agent_funcs["player"] = [];
	
	level.agent_funcs["player"]["spawn"] 				= ::spawn_agent_player;
	level.agent_funcs["player"]["think"] 				= maps\mp\bots\_bots_gametype_war::bot_war_think;
	level.agent_funcs["player"]["on_killed"]			= ::on_agent_player_killed;
	level.agent_funcs["player"]["on_damaged"]			= ::on_agent_player_damaged;
	level.agent_funcs["player"]["on_damaged_finished"]	= ::agent_damage_finished;
	
	

	if ( IsDefined( level.mp_sniper_anim_init_pointer ) )
	{
		thread [[level.mp_sniper_anim_init_pointer]]();
	}
	if ( IsDefined( level.mp_geenband_killstreak_init_pointer ) )
	{
		thread [[level.mp_geenband_killstreak_init_pointer]]();
	}
	
	
	
//	maps\mp\mp_sniper_anim::setup_callbacks();
	maps\mp\killstreaks\_agent_killstreak::setup_callbacks();
	maps\mp\killstreaks\_dog_killstreak::setup_callbacks();
}


//========================================================
//						init 
//========================================================
init()
{
	initAgentLevelVariables();
	maps\mp\bots\_bots::initLevelVariables();
	
	/#
	level thread monitor_scr_agent_players();
	#/
	
	if( !maps\mp\bots\_bots::shouldSpawnBots() )
	{
		return;
	}

	// add all the agents we're supposed to have in the game with us
    level thread add_agents_to_game();
}


//========================================================
//				initAgentLevelVariables 
//========================================================
initAgentLevelVariables()
{
	level.agentArray 	= [];
	level.numagents 	= 0;
}


//========================================================
//				add_agents_to_game 
//========================================================
add_agents_to_game()
{
	level endon( "game_ended" );
	level waittill("connected", player);

	maxagents = getDvarInt( "sv_maxagents" );
	
	while( level.agentArray.size < maxagents )
	{
		agent = AddAgent();
		
		if( !IsDefined( agent) )
		{
			waitframe();
			continue;
		}
	}
}


/#
//=======================================================
//				monitor_scr_agent_players
//=======================================================
monitor_scr_agent_players()
{
	SetDevDvarIfUninitialized( "scr_agent_players_add", "0" );
	SetDevDvarIfUninitialized( "scr_agent_players_drop", "0" );
	
	classes = [];
	classes[classes.size] = "class1";
	classes[classes.size] = "class2";
	classes[classes.size] = "class3";
	classes[classes.size] = "class5";
	
	for( ;; ) 
	{
		wait(0.1);
		
		add_agent_players = getdvarInt("scr_agent_players_add");
		drop_agent_players = getdvarInt("scr_agent_players_drop");

		if ( add_agent_players != 0 )
			SetDevDvar( "scr_agent_players_add", 0 );
		
		if ( drop_agent_players != 0 )
			SetDevDvar( "scr_agent_players_drop", 0 );

		for ( i = 0; i < add_agent_players; i++ )
			add_player_agent( undefined, random( classes ) );
		
		foreach ( agent in level.agentArray )
		{
			if ( agent.isActive && agent.agent_type == "player" )
			{
				if ( drop_agent_players > 0 )
				{
					agent maps\mp\agents\_agent_utility::deactivateAgent();
					agent Suicide();
					drop_agent_players--;
				}
			}
		}
	}
}
#/

	
//=======================================================
//				add_player_agent
//=======================================================
add_player_agent( team, class )
{
	agent = getFreeAgent( "player" );
	
	if ( IsDefined( agent ) )
	{
		if ( IsDefined( team ) )
			agent set_agent_team( team );
		else
			agent set_agent_team( agent.team );
		
		if ( IsDefined( class ) )
			agent.class = class;
		
		agent.agent_teamParticipant = true;
		agent.agent_gameParticipant = true;
		
		agent thread [[ agent agentFunc("spawn") ]]();
	}
	
	return agent;
}


//=======================================================
//				CodeCallback_AgentAdded
//=======================================================
CodeCallback_AgentAdded()
{		
	self initAgentScriptVariables();
	
	agentTeam = "axis";
	
	if( (level.numagents % 2) == 0 )
	{
		agentTeam = "allies";
	}

	level.numagents++;
	self set_agent_team( agentTeam );

	level.agentArray[ level.agentArray.size ] = self;
}


//========================================================
//					spawn_agent_player
//========================================================
spawn_agent_player( optional_spawnOrigin, optional_spawnAngles, optional_owner )
{
	self endon("disconnect");
	
	while( !IsDefined(level.getSpawnPoint) )
	{
		waitframe();
	}
		
	if( self.hasDied )
	{
		wait( RandomIntRange(6, 10) );
	}

	// allow killstreaks to pass in specific spawn locations
	if( IsDefined(optional_spawnOrigin) && IsDefined(optional_spawnAngles) )
	{
		spawnOrigin = optional_spawnOrigin;
		spawnAngles = optional_spawnAngles;
	}
	else
	{
		spawnPoint 	= self [[level.getSpawnPoint]]();
		spawnOrigin = spawnpoint.origin;
		spawnAngles = spawnpoint.angles;
		
		// Player specific variables needed in damage processing
		self.lastSpawnPoint = spawnpoint;
		self.lastSpawnTime = GetTime();		
	}
	
	self set_agent_health( 100 );
	self.isActive 	= true;
	self.spawnTime 	= GetTime();
	
	// called from code when an agent is done initializing after AddAgent is called
	// this should set up any state specific to this agent and game
	self SpawnAgent( spawnOrigin, spawnAngles );
		
	// must set the team after SpawnAgent to fix a bug with weapon crosshairs and nametags
	if( IsDefined(optional_owner) )
		self set_agent_team( optional_owner.team, optional_owner );
	
	self initPlayerScriptVariables();
		
	if( isDefined( self.owner ) )
		self thread destroyOnOwnerDisconnect( self.owner );
	
	self createKillCamEntity();

	self thread maps\mp\_flashgrenades::monitorFlash();
		
	// switch to agent bot mode and wipe all AI info clean	
	self EnableAnimState( false );

	self maps\mp\bots\_bots_personality::bot_assign_personality_functions();
	
	self maps\mp\gametypes\_class::giveLoadout( self.team, self.class, false, true );
	
	self thread maps\mp\bots\_bots::bot_think_watch_enemy();
	self thread maps\mp\bots\_bots_strategy::bot_think_tactical_goals();
	self thread [[ self agentFunc("think") ]]();

	self notify( "spawned_player" );
}


//========================================================
//				destroyOnOwnerDisconnect 
//========================================================
destroyOnOwnerDisconnect( owner )
{
	self endon( "death" );
	
	owner waittill_any( "disconnect", "joined_team" );
	
	// kill the agent
	self Suicide();
}


//========================================================
//				set_agent_health 
//========================================================
set_agent_health( health )
{
	self.agenthealth 	= health;
	self.health 		= health;
	self.maxhealth		= health;
}


//========================================================
//				agent_damage_finished 
//========================================================
agent_damage_finished( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset )
{
 	if( !IsDefined( eInflictor ) && !IsDefined( eAttacker ) )
 		return false;
 
 	if( !IsDefined( eInflictor ) )
 		eInflictor = eAttacker;
 
 	if( eInflictor.classname == "script_vehicle" )
 		return false;
 
 	if( IsDefined( eInflictor.classname ) && eInflictor.classname == "auto_turret" )
 		eAttacker = eInflictor;
 
 	if( IsDefined( eAttacker ) && sMeansOfDeath != "MOD_FALLING" && sMeansOfDeath != "MOD_SUICIDE" )
 	{
		if( level.teamBased )
		{
			if( IsDefined( eAttacker.team ) && eAttacker.team != self.team )
			{
 				self SetAgentAttacker( eAttacker );
			}
		}
		else
		{
	 		self SetAgentAttacker( eAttacker );
		}
 	}
 	
 	

	self FinishAgentDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, 0.0 );
	return true;
}


//=======================================================
//				on_agent_generic_damaged
//=======================================================
on_agent_generic_damaged( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset )
{
//	if ( self.health <= 0 )
//		return;
	
	// ignore friendly fire damage for team based modes
	if( level.teambased && IsDefined(eAttacker.team) && (self.team == eAttacker.team) )
		return false;
	
	// ignore damage from owner in non team based modes
	if( !level.teambased && IsDefined( self.owner ) && (self.owner == eAttacker) )
		return false;
		
	// don't let helicopters and other vehicles crush a player, if we want it to then put in a special case here
	if( IsDefined( sMeansOfDeath ) && sMeansOfDeath == "MOD_CRUSH" && IsDefined( eInflictor ) && IsDefined( eInflictor.classname ) && eInflictor.classname == "script_vehicle" )
		return false;

	if ( !IsDefined( self ) || !isReallyAlive( self ) )
		return false;
	
	if ( IsDefined( eAttacker ) && eAttacker.classname == "script_origin" && IsDefined( eAttacker.type ) && eAttacker.type == "soft_landing" )
		return false;

	if ( sWeapon == "killstreak_emp_mp" )
		return false;

	if ( sWeapon == "bouncingbetty_mp" && !maps\mp\gametypes\_weapons::mineDamageHeightPassed( eInflictor, self ) )
		return false;
		
	if ( sWeapon == "xm25_mp" && sMeansOfDeath == "MOD_IMPACT" )
		iDamage = 95;
 
 	if( iDamage <= 0 )
 		return false;
 	
	if ( IsDefined( eAttacker ) && eAttacker != self && iDamage > 0 && ( !IsDefined( sHitLoc ) || sHitLoc != "shield" ) )
	{
		if( iDFlags & level.iDFLAGS_STUN )
			typeHit = "stun";
		else if( !shouldWeaponFeedback( sWeapon ) )
			typeHit = "none";
		else
			typeHit = "standard";
				
		eAttacker thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback( typeHit );
	}

	if( self.agent_type == "dog" )
	{
		self PlaySound( "anml_dog_shot_pain" );
	}

	return self [[ self agentFunc( "on_damaged_finished" ) ]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset );
}


//========================================================
//					on_agent_player_damaged 
//========================================================
on_agent_player_damaged( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset )
{
	Callback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset );
}
	
	
//=======================================================
//					CodeCallback_AgentDamaged
//=======================================================
CodeCallback_AgentDamaged( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset )
{
	self [[ self agentFunc( "on_damaged" ) ]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset );
}


//=======================================================
//					CodeCallback_AgentKilled
//=======================================================
CodeCallback_AgentKilled(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset, deathAnimDuration)
{
	self thread [[ self agentFunc("on_killed") ]](eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset, deathAnimDuration);
}


//=======================================================
//					on_agent_player_killed
//=======================================================
on_agent_player_killed(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset, deathAnimDuration)
{
	// ragdoll
	self.body = self CloneAgent( deathAnimDuration );
	thread delayStartRagdoll( self.body, sHitLoc, vDir, sWeapon, eInflictor, sMeansOfDeath );
		
	// award XP for killing agents
	if( isPlayer( eAttacker ) && (!isDefined(self.owner) || eAttacker != self.owner) )
	{
		eAttacker thread maps\mp\gametypes\_rank::giveRankXP( "kill", 100, sWeapon, sMeansOfDeath );	
		eAttacker thread maps\mp\killstreaks\_killstreaks::giveAdrenaline( "vehicleDestroyed" );		
	}
			
	if ( self.isActive )
	{
		self.hasDied = true;
		self removeKillCamEntity();
		self thread [[ self agentFunc("spawn") ]]();
	}
}


//=======================================================
//				createKillCamEntity
//=======================================================
createKillCamEntity()
{
	killCamOrigin = ( 0, 0, 0 );
	switch( self.agent_type )
	{
	case "dog":
		killCamOrigin = ( self.origin + ( ( AnglesToForward( self.angles ) * -32 ) + ( AnglesToRight( self.angles ) * -18 )  ) ) + ( 0, 0, 34 );
		break;
	default:
		killCamOrigin = ( self.origin + ( ( AnglesToForward( self.angles ) * -32 ) + ( AnglesToRight( self.angles ) * -18 )  ) ) + ( 0, 0, 54 );
		break;
	}
	self.killCamEnt = Spawn( "script_model", killCamOrigin );
	self.killCamEnt LinkTo( self );
	self.killCamEnt SetScriptMoverKillCam( "explosive" );
}


//=======================================================
//				removeKillCamEntity
//=======================================================
removeKillCamEntity()
{
	if( IsDefined( self.killCamEnt ) )
	{
		self.killCamEnt delete();	
	}
}
