--## SERVER

-- Global Narrative Callbacks
-- Copyright (C) Microsoft. All rights reserved.

-------------------------------------------------------------------------------------------------
-- Narrative Moment Activated Callback
-- Called by a C++ function when a Narrative Moment is activated
-------------------------------------------------------------------------------------------------

hstructure NarrativeMomentActivatedStruct
	moment: narrative_moment;
end

-- callback from C++
function _NarrativeEventMomentActivatedCallback(momentArg: narrative_moment):void
	local eventArgs = hmake NarrativeMomentActivatedStruct
	{
		moment = momentArg,
	};

	CallEvent(g_eventTypes.narrativeMomentActivated, momentArg, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Narrative Moment Deactivated Callback
-- Called by a C++ function when a Narrative Moment is deactivated
-------------------------------------------------------------------------------------------------

hstructure NarrativeMomentDeactivatedStruct
	moment: narrative_moment;
end

-- callback from C++
function _NarrativeEventMomentDeactivatedCallback(momentArg: narrative_moment):void
	local eventArgs = hmake NarrativeMomentDeactivatedStruct
	{
		moment = momentArg,
	};

	CallEvent(g_eventTypes.narrativeMomentDeactivated, momentArg, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Narrative Moment Beat Activated Callback
-- Called by a C++ function when a Narrative Moment's beat is activated
-------------------------------------------------------------------------------------------------

hstructure NarrativeMomentBeatActivatedStruct
	moment: narrative_moment;
	beatName: string_id;
	player: player;
end

-- callback from C++
function _NarrativeEventMomentBeatActivatedCallback(momentArg: narrative_moment, beatNameArg: string_id, playerArg: player):void
	local eventArgs = hmake NarrativeMomentBeatActivatedStruct
	{
		moment = momentArg,
		beatName = beatNameArg,
		player = playerArg,
	};

	CallEvent(g_eventTypes.narrativeMomentBeatActivated, momentArg, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Narrative Moment Beat Deactivated Callback
-- Called by a C++ function when a Narrative Moment's beat is deactivated
-------------------------------------------------------------------------------------------------

hstructure NarrativeMomentBeatDeactivatedStruct
	moment: narrative_moment;
	beatName: string_id;
	player: player;
end

-- callback from C++
function _NarrativeEventMomentBeatDeactivatedCallback(momentArg: narrative_moment, beatNameArg: string_id, playerArg: player):void
	local eventArgs = hmake NarrativeMomentBeatDeactivatedStruct
	{
		moment = momentArg,
		beatName = beatNameArg,
		player = playerArg,
	};

	CallEvent(g_eventTypes.narrativeMomentBeatDeactivated, momentArg, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Narrative Play Sequence
--   Called when a narrative sequence is requested to play
-------------------------------------------------------------------------------------------------

-- Called by C++, this is not for scripters to call directly.
function _NarrativePlaySequence(sequenceName: string, momentArg: narrative_moment, beatName: string_id, associatedObjects:table): void
	-- print("_NarrativePlaySequence(sequenceName:\""..sequenceName.."\", momentArg:", momentArg, ", beatName:", beatName, ", associatedObjects:", tostring(associatedObjects),")");
	if associatedObjects and #associatedObjects > 0 then
		local transientTable:table =
		{
			participants = associatedObjects,
		};

		NarrativeInterface.PlayNarrativeSequenceFromMoment(sequenceName, momentArg, beatName, transientTable);
	else
		NarrativeInterface.PlayNarrativeSequenceFromMoment(sequenceName, momentArg, beatName);
	end
end

-------------------------------------------------------------------------------------------------
-- Narrative Blink to Location
-- Called by C++ when user selects a blink from the debug menu

function _NarrativeBlinkToLocation(name: string, position: vector, facing: vector): void
	local loc : matrix = matrix();
	loc.pos = position;
	loc.angles = facing;
	CreateThread(NarrativeBlinkToLocation, ToLocation(loc), nil, name);
end

-------------------------------------------------------------------------------------------------
-- Narrative Cleanup On Game-Over
-- Called by C++ when a checkpoint reload is about to be performed

function _NarrativeCleanupOnGameOver():void
	NarrativeInterface.OnGameOver();
end