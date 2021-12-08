--## SERVER

-- Global Encounter Callbacks
-- Copyright (C) Microsoft. All rights reserved.

hstructure EncounterEventCallbackStruct
	encounterInstanceHandle:handle;
end

-- Callbacks from C++
function EncounterController_Initialize(encInstIndex:handle)
	local eventArgs = hmake EncounterEventCallbackStruct
	{
		encounterInstanceHandle = encInstIndex
	}
	CallEvent(g_eventTypes.encounterInitialize, encInstIndex, eventArgs);
end

function EncounterController_Start(encInstIndex:handle)
	local eventArgs = hmake EncounterEventCallbackStruct
	{
		encounterInstanceHandle = encInstIndex
	}
	CallEvent(g_eventTypes.encounterStart, encInstIndex, eventArgs);
end

function EncounterController_PreActivate(encInstIndex:handle)
	local eventArgs = hmake EncounterEventCallbackStruct
	{
		encounterInstanceHandle = encInstIndex
	}
	CallEvent(g_eventTypes.encounterPreActivate, encInstIndex, eventArgs);
end

function EncounterController_PostActivate(encInstIndex:handle)
	local eventArgs = hmake EncounterEventCallbackStruct
	{
		encounterInstanceHandle = encInstIndex
	}
	CallEvent(g_eventTypes.encounterPostActivate, encInstIndex, eventArgs);
end

function EncounterController_PreDeactivate(encInstIndex:handle)
	local eventArgs = hmake EncounterEventCallbackStruct
	{
		encounterInstanceHandle = encInstIndex
	}
	CallEvent(g_eventTypes.encounterPreDeactivate, encInstIndex, eventArgs);
end

function EncounterController_PostDeactivate(encInstIndex:handle)
	local eventArgs = hmake EncounterEventCallbackStruct
	{
		encounterInstanceHandle = encInstIndex
	}
	CallEvent(g_eventTypes.encounterPostDeactivate, encInstIndex, eventArgs);
end

function EncounterController_Release(encInstIndex:handle)
	local eventArgs = hmake EncounterEventCallbackStruct
	{
		encounterInstanceHandle = encInstIndex
	}
	CallEvent(g_eventTypes.encounterPreRelease, encInstIndex, eventArgs);
end