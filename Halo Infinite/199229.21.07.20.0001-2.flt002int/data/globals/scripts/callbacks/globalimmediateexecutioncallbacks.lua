REQUIRES('globals/scripts/callbacks/GlobalPlayerCallbacks.lua');
REQUIRES('globals/scripts/callbacks/GlobalEngineCallbacks.lua');

--## SERVER

-- Global Immediate Execution Callbacks
-- Copyright (C) Microsoft. All rights reserved.


-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
----IMMEDIATE EXECUTION CALLBACKS; DO NOT ADD ONE OF THESE UNLESS YOU KNOW WHAT YOU'RE DOING!----------
-------------------------------------------------------------------------------------------------------
-- These callbacks are called immediately by the engine as soon as the events occur, instead of      --
-- execution being deferred to the beginning of the next frame as is normally done. These callbacks  --
-- should only be used in scenarios where immediate execution is absolutely necessary, and callbacks --
-- should contain only non-blocking, non-computation-heavy actions.                                  --
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------
-- HSInitializeForNewMap SERVER and CLIENT Callback (Immediate)
-- Called by the game whenever HSInitializeForNewMapInternal() is finished calling, which initializes Lua state
-------------------------------------------------------------------------------------------------

-- Callbacks from C++

function HSInitializeForNewMapServerCallbackImmediate()
	CallEvent(g_eventTypes.hsInitializeForNewMapServer, nil);
end

--## CLIENT
function HSInitializeForNewMapClientCallbackImmediate()
	-- Currently we don't call any events on the client, but leaving this here as the stub is hooked up from C++ and could potentially be useful in the future
	--   Note that g_eventTypes.hsInitializeForNewMapClient isn't actually an entry in that array currently either, in the event you are trying to hook this up
	--CallEvent(g_eventTypes.hsInitializeForNewMapClient, nil);
end
--## SERVER

-------------------------------------------------------------------------------------------------
-- Player Added callback (Immediate)
-- 		Called by the game whenever a player joins the match
-------------------------------------------------------------------------------------------------

-- Note: PlayerAddedEventStruct is defined in GlobalPlayerCallbacks.lua for the standard PlayerAddedEvent

-- Callback from C++
function GlobalObjectEventPlayerJoinedImmediate(player:player, joinInProgress:boolean, rejoin:boolean)
	local eventArgs:PlayerAddedEventStruct = hmake PlayerAddedEventStruct
		{
			player = player,
			joinInProgress = joinInProgress,
			rejoin = rejoin
		};


	CallEvent(g_eventTypes.playerAddedEventImmediate, nil, eventArgs);
end


-------------------------------------------------------------------------------------------------
-- Round Start callback (Immediate)
-- 		Called by the game whenever a Round starts
-------------------------------------------------------------------------------------------------

-- Note: the RoundStartEventStruct is defined in GlobalEngineCallbacks.lua for the standard RoundStartEvent

-- Callback from C++
function RoundStartCallbackImmediate(roundIndex:number, isOvertimeRound:boolean)
	local eventArgs:RoundStartEventStruct = hmake RoundStartEventStruct
		{
			roundIndex = roundIndex,
			isOvertimeRound = isOvertimeRound
		};

	CallEvent(g_eventTypes.roundStartEventImmediate, nil, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Round Outcome Recorded callback (Immediate)
-- 		Called by the game as soon as it determines the RoundOutcome for all parties inside of GameEngineEndRoundInternal()
-------------------------------------------------------------------------------------------------

hstructure RoundOutcomeRecordedEventStruct
	finalizedRoundIndex:number; -- the roundIndex of the round for which we just finished recording outcomes for
end

-- Callback from C++
function RoundOutcomeRecordedCallbackImmediate(finalizedRoundIndex:number)
	local eventArgs:RoundOutcomeRecordedEventStruct = hmake RoundOutcomeRecordedEventStruct
		{
			finalizedRoundIndex = finalizedRoundIndex
		};

	CallEvent(g_eventTypes.roundOutcomeRecordedEventImmediate, nil, eventArgs);
end


-------------------------------------------------------------------------------------------------
-- Round End callback (Immediate)
-- 		Called by the game as it transitions into the post-round state
-- 		Specifically, when HandleGameEngineStateUpdate() is called with the new desiredEngineState of GameEngineState::PostRound
-------------------------------------------------------------------------------------------------

-- Callback from C++
function RoundEndCallbackImmediate()
	CallEvent(g_eventTypes.roundEndEventImmediate, nil);
end


-------------------------------------------------------------------------------------------------
-- Game End callback (Immediate)
-- 		Called by the game whenever the MP game ends (game meaning a single multiplayer game, consisting of one or more rounds)
-------------------------------------------------------------------------------------------------

-- Callback from C++
function GameEndCallbackImmediate()
	CallEvent(g_eventTypes.gameEndEventImmediate, nil);
end