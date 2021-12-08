--## SERVER

-- Global Object Callbacks
-- Copyright (C) Microsoft. All rights reserved.


-------------------------------------------------------------------------------------------------
-- Musketeer Order Given Callback
-- Called by the game whenever a musketeer order is given (can be due to a Player, Design, or Level scripts)
-------------------------------------------------------------------------------------------------

-- Callback from C++
function GlobalObjectEventMusketeerOrderGiven()
	CallEvent(g_eventTypes.musketeerOrderGivenEvent, nil);
end

-------------------------------------------------------------------------------------------------
-- Slipspace Spawn Squad Group Completed Callback
-- Called by the game when an AI squad has finished spawning in via Slipspace
-------------------------------------------------------------------------------------------------

hstructure SlipSpaceSpawnSquadGroupCompletedEventStruct
	aiSquad:ai;
end

-- Callback from C++
function SlipSpaceSpawnSquadGroupCompletedCallback(aiSquad:ai)
	local eventArgs = hmake SlipSpaceSpawnSquadGroupCompletedEventStruct
		{
			aiSquad = aiSquad
		}

	CallEvent(g_eventTypes.slipSpaceSpawnSquadGroupCompletedEvent, aiSquad, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Actor Deleted Callback
-- Called by the game whenever an Actor is deleted
-------------------------------------------------------------------------------------------------

hstructure ActorDeletedEventStruct
	actor:ai;
end

-- Callback from C++
function ActorDeletedCallback(actor:ai)
	local eventArgs = hmake ActorDeletedEventStruct
		{
			actor = actor
		}

	CallEvent(g_eventTypes.actorDeletedEvent, actor, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Squad Deleted Callback
-- Called by the game whenever a Squad is deleted
-------------------------------------------------------------------------------------------------

hstructure SquadDeletedEventStruct
	squad:ai;
end

-- Callback from C++
function SquadDeletedCallback(squad:ai)
	local eventArgs = hmake SquadDeletedEventStruct
		{
			squad = squad
		}

	CallEvent(g_eventTypes.squadDeletedEvent, squad, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Virtual Actor Deleted Callback
-- Called by the game whenever a virtual actor is deleted
-------------------------------------------------------------------------------------------------

hstructure VirtualActorDeletedEventStruct
	actor:handle;
end

-- Callback from C++
function VirtualActorDeletedCallback(actorInst:handle)
	local eventArgs = hmake VirtualActorDeletedEventStruct
	{
		actor = actorInst
	}

	CallEvent(g_eventTypes.virtualActorDeletedEvent, actorInst, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Virtual Squad Deleted Callback
-- Called by the game whenever a virtual squad is deleted
-------------------------------------------------------------------------------------------------

hstructure VirtualSquadDeletedEventStruct
	squad:handle;
end

-- Callback from C++
function VirtualSquadDeletedCallback(squadInst:handle)
	local eventArgs = hmake VirtualSquadDeletedEventStruct
	{
		squad = squadInst
	}

	CallEvent(g_eventTypes.virtualSquadDeletedEvent, squadInst, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Virtual Squad Hydrated Callback
-- Called by the game whenever a virtual squad is hydrated
-------------------------------------------------------------------------------------------------

hstructure VirtualSquadHydratedEventStruct
	squad:handle;
end

-- Callback from C++
function VirtualSquadHydratedCallback(squadInst:handle)
	local eventArgs = hmake VirtualSquadHydratedEventStruct
	{
		squad = squadInst;
	}

	CallEvent(g_eventTypes.virtualSquadHydratedEvent, squadInst, eventArgs);
	SpawnerSquadHydratedCallback(squadInst);
end

-------------------------------------------------------------------------------------------------
-- Virtual Squad Hydrated From a Spawner Callback
-- Called by the game through VirtualSquadHydratedCallback whenever a virtual squad is hydrated
-------------------------------------------------------------------------------------------------

hstructure SpawnerSquadHydratedEventStruct
	virtualSquad:handle
	squad:ai;
	spawner:squad_spawner;
	firstUnit:object;
end

function SpawnerSquadHydratedCallback(squadInst:handle)
	local eventTable:table = g_callbackEventTable[g_eventTypes.spawnerSpawned]
	--print("spawner squad hydrated callback!");
	if eventTable == nil then
		return;
	end

	local squadSpawner = AI_GetSquadSpawnerFromSquadInstance(squadInst);
	local aiSquad = AI_GetAISquadFromSquadInstance(squadInst);
	local eventArgs = hmake SpawnerSquadHydratedEventStruct
		{
			virtualSquad = squadInst,
			squad = aiSquad,
			spawner = squadSpawner,
			firstUnit = aiSquad and ai_actors(aiSquad)[1] or nil;
		};
	
	CallEvent(g_eventTypes.spawnerSpawned, squadSpawner, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Virtual Squad Dehydrated Callback
-- Called by the game whenever a virtual squad is dehydrated
-------------------------------------------------------------------------------------------------

hstructure VirtualSquadDehydratedEventStruct
	squad:handle;
end

-- Callback from C++
function VirtualSquadDehydratedCallback(squadInst:handle)
	local eventArgs = hmake VirtualSquadDehydratedEventStruct
	{
		squad = squadInst;
	}

	CallEvent(g_eventTypes.virtualSquadDehydratedEvent, squadInst, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Squad Spawner Created Virtual Squad Callback
-- Called by the game whenever a virtual squad is created by a squad spawner
-------------------------------------------------------------------------------------------------

hstructure SquadSpawnerCreatedVirtualSquadEventStruct
	squadSpawner:squad_spawner;
	squad:handle;
end

-- Callback from C++
function SquadSpawnerCreatedVirtualSquadCallback(spawner:squad_spawner, squadInst:handle)
	local eventArgs = hmake SquadSpawnerCreatedVirtualSquadEventStruct
	{
		squadSpawner = spawner;
		squad = squadInst;
	}

	CallEvent(g_eventTypes.squadSpawnerCreatedVirtualSquad, spawner, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Refresh Dialogue State Table Callback
-- Called by the game whenever when the world persistence state changes
-------------------------------------------------------------------------------------------------

-- Callback from C++
function RefreshDialogueStateTableCallback()
	CallEvent(g_eventTypes.dialogueStateTableRefreshEvent, nil);
end