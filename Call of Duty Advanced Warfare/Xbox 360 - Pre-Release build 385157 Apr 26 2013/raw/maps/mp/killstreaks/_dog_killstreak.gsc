#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\agents\_agent_utility;
#include maps\mp\gametypes\_damage;

//===========================================
// 				constants
//===========================================
CONST_MAX_ACTIVE_KILLSTREAK_DOGS_PER_GAME		= 5;
CONST_MAX_ACTIVE_KILLSTREAK_DOGS_PER_PLAYER 	= 1;


//===========================================
// 					init
//===========================================
init()
{
	level.killStreakFuncs["guard_dog"] = ::tryUseDog;
}


//===========================================
// 				setup_callbacks
//===========================================
setup_callbacks()
{
	level.agent_funcs["dog"] = level.agent_funcs["player"];
	
	level.agent_funcs["dog"]["spawn"]		= ::spawn_dog;
	level.agent_funcs["dog"]["on_killed"]	= ::on_agent_dog_killed;
	level.agent_funcs["dog"]["on_damaged"]	= maps\mp\agents\_agents::on_agent_generic_damaged;
}


//===========================================
// 				tryUseDog
//===========================================
tryUseDog( lifeId )
{
	if ( self validateUseStreak() )
	{
		return useDog();
	}
	
	return false;
}


//===========================================
// 				useDog
//===========================================
useDog()
{
	// limit the number of active "dog" agents allowed per game
	if( getNumActiveAgents( "dog" ) >= CONST_MAX_ACTIVE_KILLSTREAK_DOGS_PER_GAME )
	{
		self iPrintLnBold( &"KILLSTREAKS_TOO_MANY_DOGS" );
		return false;
	}
	// limit the number of active "dog" agents allowed per player
	if( getNumOwnedActiveAgentsByType( self, "dog" ) >= CONST_MAX_ACTIVE_KILLSTREAK_DOGS_PER_PLAYER )
	{
		self iPrintLnBold( &"KILLSTREAKS_ALREADY_HAVE_DOG" );
		return false;
	}

	// TODO: we should probably do a queue system for these, so the player can call it but it'll go into a queue for when an agent dies to open up a spot
	// limit the number of active agents allowed per player
	maxagents = GetDvarInt( "sv_maxagents" );
	if( getNumActiveAgents() >= maxagents )
	{
		self iPrintLnBold( &"KILLSTREAKS_UNAVAILABLE" );
		return false;
	}
		
	// make sure the player is still alive before the agent trys to spawn on the player
	if( !isReallyAlive( self ) )
	{
		return false;
	}
	
	// try to spawn the agent on a path node near the player
	nearestPathNode = self getPathNodeNearPlayer();
	if( !IsDefined(nearestPathNode) )
	{
		return false;
	}

	// find an available agent
	agent = getFreeAgent( "dog" );	
	if( !IsDefined( agent ) )
	{
		return false;
	}
	
	// set the agent to the player's team
	agent set_agent_team( self.team, self );
	
	spawnOrigin = nearestPathNode.origin;
	spawnAngles = VectorToAngles( self.origin - nearestPathNode.origin );

	agent thread [[ agent agentFunc("spawn") ]]( spawnOrigin, spawnAngles, self );
	
	return true;
}


//=======================================================
//				on_agent_dog_killed
//=======================================================
on_agent_dog_killed( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset, deathAnimDuration )
{
	self.isActive 	= false;
	self.hasDied 	= false;
	self.owner		= undefined;

	self SetAnimState( "death" );
	animEntry = self GetAnimEntry();
	animLength = GetAnimLength( animEntry );
	
	deathAnimDuration = int( animLength * 1000 ); // duration in milliseconds
	
	self.body = self CloneAgent( deathAnimDuration );

	self PlaySound( "anml_dog_shot_death" );

	// ragdoll
	thread delayStartRagdoll( self.body, sHitLoc, vDir, sWeapon, eInflictor, sMeansOfDeath );
		
	// award XP for killing agents
	if( isPlayer( eAttacker ) && (!isDefined(self.owner) || eAttacker != self.owner) )
	{
		eAttacker thread maps\mp\gametypes\_rank::giveRankXP( "kill", 100, sWeapon, sMeansOfDeath );	
		eAttacker thread maps\mp\killstreaks\_killstreaks::giveAdrenaline( "vehicleDestroyed" );		
	}

	self maps\mp\agents\_agents::removeKillCamEntity();
	self maps\mp\agents\_agent_utility::deactivateAgent();

	self notify( "killanimscript" );
}


spawn_dog( optional_spawnOrigin, optional_spawnAngles, optional_owner )
{
	self SetModel( "german_shepherd_dog" );
	self.species = "dog";

	self.OnEnterAnimState = maps\mp\agents\dog\_dog_think::OnEnterAnimState;

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
	}
	
	self maps\mp\agents\_agents::set_agent_health( 100 );
	self.isActive 	= true;
	self.spawnTime 	= GetTime();

	self maps\mp\agents\dog\_dog_think::init();

	// called from code when an agent is done initializing after AddAgent is called
	// this should set up any state specific to this agent and game
	self SpawnAgent( spawnOrigin, spawnAngles );
	
	// must set the team after SpawnAgent to fix a bug with weapon crosshairs and nametags
	if( IsDefined(optional_owner) )
	{
		self set_agent_team( optional_owner.team, optional_owner );
	}

	self TakeAllWeapons();

	self EnableAnimState( true );
	self SetAnimClass( "dog_animclass" );

	self maps\mp\agents\_agents::createKillCamEntity();

	self thread maps\mp\agents\dog\_dog_think::main();
}
