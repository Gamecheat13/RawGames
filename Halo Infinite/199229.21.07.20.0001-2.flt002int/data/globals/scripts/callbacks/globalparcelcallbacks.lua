--## SERVER

-- Global Parcel Callbacks
-- Copyright (C) Microsoft. All rights reserved.

-------------------------------------------------------------------------------------------------
--PARCEL EVENTS

-------------------------------------------------------------------------------------------------
-- Parcel Initialized Event
-- Called from the Parcel Handler thread when a parcel instance initializes
-------------------------------------------------------------------------------------------------

hstructure ParcelInitializedEventStruct
	parcel:table;
end

-- Callback from Parcel Handler
function ParcelInitializedCallback(parcelInstance:table)
	if g_callbackEventTable[g_eventTypes.parcelInitialized] == nil then
		return;
	end
	local eventArgs = hmake ParcelInitializedEventStruct
		{
			parcel = parcelInstance,
		};

	CreateThread(CallEvent, g_eventTypes.parcelInitialized, parcelInstance, eventArgs);
end


-------------------------------------------------------------------------------------------------
-- Parcel Run Event
-- Called from the Parcel Handler thread when a parcel instance runs
-------------------------------------------------------------------------------------------------

hstructure ParcelRunEventStruct
	parcel:table;
end

-- Callback from Parcel Handler
function ParcelRunCallback(parcelInstance:table)
	if g_callbackEventTable[g_eventTypes.parcelRun] == nil then
		return;
	end

	local eventArgs = hmake ParcelRunEventStruct
		{
			parcel = parcelInstance,
		};

	CreateThread(CallEvent, g_eventTypes.parcelRun, parcelInstance, eventArgs);
end


-------------------------------------------------------------------------------------------------
-- Parcel Stopped Event
-- Called from the Parcel Handler thread when a parcel instance stops
-------------------------------------------------------------------------------------------------

hstructure ParcelStopEventStruct
	parcel:table;
end

-- Callback from Parcel Handler
function ParcelStopCallback(parcelInstance:table)
	if g_callbackEventTable[g_eventTypes.parcelStop] == nil then
		return;
	end

	local eventArgs = hmake ParcelStopEventStruct
		{
			parcel = parcelInstance,
		};

	CreateThread(CallEvent, g_eventTypes.parcelStop, parcelInstance, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Parcel Ended Event
-- Called from the Parcel Handler thread when a parcel instance ends
-------------------------------------------------------------------------------------------------

hstructure ParcelEndEventStruct
	parcel:table;
end

-- Callback from Parcel Handler
function ParcelEndCallback(parcelInstance:table)
	if g_callbackEventTable[g_eventTypes.parcelEnd] == nil then
		return;
	end

	local eventArgs = hmake ParcelEndEventStruct
		{
			parcel = parcelInstance,
		};

	CreateThread(CallEvent, g_eventTypes.parcelEnd, parcelInstance, eventArgs);
end