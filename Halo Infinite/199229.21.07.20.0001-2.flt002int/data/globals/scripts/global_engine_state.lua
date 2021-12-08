-- Copyright (C) Microsoft. All rights reserved.
--## SERVER

REQUIRES('globals/scripts/callbacks/GlobalCallbacks.lua')

function startup.RegisterEngineStateHandlerCallbacks():void
	RegisterGlobalEvent(g_eventTypes.roundEndEvent, EngineStateHandler.HandleRoundEnd);
	RegisterGlobalEvent(g_eventTypes.roundStartEvent, EngineStateHandler.HandleRoundStart);
end


global EngineStateHandler:table =
{
	roundEndAckThread = nil,
};

-- Currently we don't have a good system in place for determining when all of Lua has fully processed the RoundEnd event.
-- In the meantime, we are going to sleep for an arbitrary number of frames (not awesome, I know..), and afterwards ack back to the engine.
--
-- The choice of 10 frames is based around the idea that the EventManager class creates threads (and therefore frame delays) every time an event
-- is fired; 10 frames should hopefully be long enough that any parcel/event structure has been able to fully process all cleanup callbacks and events.

function EngineStateHandler.HandleRoundEnd():void
	EngineStateHandler.roundEndAckThread = CreateThread(EngineStateHandler.AcknowledgeRoundEndAfterDelay);
end

function EngineStateHandler.AcknowledgeRoundEndAfterDelay():void
	Sleep(10);

	-- Once we call this function, the Engine will pick up the flag we set and fire the RoundEnd Telemetry event as a result.
	-- If Lua takes too long to do so, eventually the Engine will just fire it anyways when GameFinish() or GameEngineInitializeForNewRound() is called
	Engine_AcknowledgeRoundEndHandled();

	-- Clear the thread handle since the thread is now exiting
	EngineStateHandler.roundEndAckThread = nil;
end

function EngineStateHandler.HandleRoundStart(eventArgs:RoundStartEventStruct):void
	-- If we still somehow have a thread running that is waiting to ack the RoundEnd event back to the engine,
	-- but the engine has already moved on to the next round, we missed our chance (it already fired Telemetry by now)
	
	if (EngineStateHandler.roundEndAckThread ~= nil) then
		KillThread(EngineStateHandler.roundEndAckThread);
		EngineStateHandler.roundEndAckThread = nil;
	end
end