#include common_scripts\utility;
#include maps\mp\_utility;

//========================================================
//				agentFunc 
//========================================================
agentFunc( func_name )
{
	assert( IsAgent( self ) );
	assert( IsDefined(func_name) );
	assert( isDefined(self.agent_type) );
	assert( isDefined(level.agent_funcs[self.agent_type]) );
	assert( isDefined(level.agent_funcs[self.agent_type][func_name]) );
	
	return level.agent_funcs[self.agent_type][func_name];
}

//========================================================
//				set_agent_team 
//========================================================
set_agent_team( team, optional_owner )
{
	// since an agent entity has both a "sentient" and an "agent", we need both
	// these to understand the team the entity is on (much as client entities
	// have a "sentient" and a "client"). The "team" field sets the "sentient"
	// team and the "agentteam" field sets the "agent" team. 
	self.team 			= team;
	self.agentteam 		= team;
	self.pers["team"] 	= team;
	
	self.owner = optional_owner;
}


//=======================================================
//				initAgentScriptVariables
//=======================================================
initAgentScriptVariables()
{
	self.agent_type 			= "player"; // TODO: communicate this to code?
	self.pers 					= [];
	self.hasDied 				= false;
	self.isActive				= false;
	self.isAgent				= true;
	self.wasTI					= false;
	self.isSniper				= false;
	self.spawnTime				= 0;
	self.entity_number 			= self GetEntityNumber();	
	self.agent_teamParticipant 	= false;
	self.agent_gameParticipant 	= false;

	self initPlayerScriptVariables( false );
}


//========================================================
//					initPlayerScriptVariables
//========================================================
initPlayerScriptVariables( asPlayer )
{
	if ( IsDefined( asPlayer ) && !asPlayer )
	{
		// Not as a player
		self.class							= undefined;
		self.lastClass						= undefined;
		self.moveSpeedScaler 				= undefined;
		self.avoidKillstreakOnSpawnTimer 	= undefined;
		self.guid 							= undefined;
		self.name							= undefined;
		self.saved_actionSlotData 			= undefined;		
		self.perks 							= undefined;
		self.weaponList 					= undefined;
		self.omaClassChanged 				= undefined;
		self.objectiveScaler 				= undefined;
		self.touchTriggers 					= undefined;
		self.carryObject 					= undefined;
		self.claimTrigger 					= undefined;
		self.canPickupObject 				= undefined;
		self.killedInUse 					= undefined;
		self.sessionteam					= undefined;
		self.sessionstate					= undefined;
		self.lastSpawnTime 					= undefined;
		self.lastspawnpoint 				= undefined;
	}
	else
	{
		// As a player
		self.class							= "class1";
		self.moveSpeedScaler 				= 1;
		self.avoidKillstreakOnSpawnTimer 	= 5;
		self.guid 							= self getGuid();
		self.name							= self.guid;
		self.sessionteam 					= self.team;
		self.sessionstate					= "playing";
		
		self maps\mp\gametypes\_playerlogic::setupSavedActionSlots();
		self thread maps\mp\perks\_perks::onPlayerSpawned();
		
		if ( IsGameParticipant( self ) )
		{
			self.objectiveScaler = 1;
			self maps\mp\gametypes\_gameobjects::init_player_gameobjects();
		}
	}
}


//===========================================
// 				getFreeAgent
//===========================================
getFreeAgent( agent_type )
{
	freeAgent = undefined;
	
	if( IsDefined( level.agentArray ) )
	{
		foreach( agent in level.agentArray )
		{
			if( !agent.isActive )
			{
				freeAgent = agent;
				
				freeAgent initAgentScriptVariables();
				
				if ( IsDefined( agent_type ) ) 
					freeAgent.agent_type = agent_type; // TODO: communicate this to code?
					
				break;
			}
		}
	}
	
	return freeAgent;
}


//=======================================================
//				deactivateAgent
//=======================================================
deactivateAgent()
{
	self.isActive 	= false;
	self.hasDied 	= false;
	self.owner		= undefined;
	
	self notify( "disconnect" );
}


//===========================================
// 			getNumActiveAgents
//===========================================
getNumActiveAgents( type )
{
	numActiveAgent = 0;
	
	if( !IsDefined(level.agentArray) )
	{
		return numActiveAgent;
	}
	
	foreach( agent in level.agentArray )
	{
		if( agent.isActive )
		{
			if ( !IsDefined(type) || agent.agent_type == type )
				numActiveAgent++;
		}
	}
	
	return numActiveAgent;
}


//===========================================
// 			getNumOwnedActiveAgents
//===========================================
getNumOwnedActiveAgents( player )
{
	numOwnedActiveAgents = 0;
	
	if( !IsDefined(level.agentArray) )
	{
		return numOwnedActiveAgents;
	}
	
	foreach( agent in level.agentArray )
	{
		if( agent.isActive && IsDefined(agent.owner) && (agent.owner == player) )
		{
			numOwnedActiveAgents++;
		}
	}
	
	return numOwnedActiveAgents;
}

//===========================================
// 			getNumOwnedActiveAgentsByType
//===========================================
getNumOwnedActiveAgentsByType( player, type )
{
	numOwnedActiveAgents = 0;

	if( !IsDefined(level.agentArray) )
	{
		return numOwnedActiveAgents;
	}

	foreach( agent in level.agentArray )
	{
		if( agent.isActive && IsDefined(agent.owner) && (agent.owner == player) && agent.agent_type == type )
		{
			numOwnedActiveAgents++;
		}
	}

	return numOwnedActiveAgents;
}

//=======================================================
//				getPathNodeNearPlayer
//=======================================================
getPathNodeNearPlayer() // self = player
{
	assert( isPlayer( self ) );
	
	nodeArray 	= GetNodesInRadius( self.origin, 350, 0, 128, "Path" );
	bestNode 	= undefined;
	
	if( !IsDefined(nodeArray) || (nodeArray.size == 0) )
	{
		return bestNode;
	}
	
	playerDirection = AnglesToForward( self.angles );
	bestDot = -10;
	
	// pick a path node in the player's view
	foreach( pathNode in nodeArray )
	{
		directionToNode = VectorNormalize( pathNode.origin - self.origin );
		dot = VectorDot( playerDirection, directionToNode );
		
		// this node is infront of the player
		if( bestDot < dot )
		{
			// prevent selecting a node directly on top of the player
			if( DistanceSquared( pathNode.origin, self.origin ) < (64 * 64) )
			{
				continue;
			}
			
			playerHeight = maps\mp\gametypes\_spawnlogic::getPlayerTraceHeight( self );
			
			// prevent selecting a node that the player cannot see
			if( !SightTracePassed( self.origin + (0,0,playerHeight), pathNode.origin + (0,0,playerHeight), false, self ) )
			{
				continue;
			}
			
			bestNode = pathNode;
			bestDot  = dot;
		}
	}
	
	return bestNode;
}

