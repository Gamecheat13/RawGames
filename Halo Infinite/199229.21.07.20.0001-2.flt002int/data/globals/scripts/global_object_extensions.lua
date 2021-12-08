--## SERVER
-- Copyright (C) Microsoft. All rights reserved.

-----------------------------------------------------------------------
-- Object Extensions
-----------------------------------------------------------------------
-- A system for extending the functionality of object classes (server only currently).
-- Allows adding custom functions to the metatables of all object classes (including kits), with the option
-- of storing data that can be automatically cleaned up when the object is destroyed.
--
-- To add a new custom function:
-- 1. Add a table entry at the bottom of the file in ObjectExtensions.CustomFunctions.
-- 2. Implement that function above the table somewhere (or in another file, but you must REQUIRE it).
-- 3. Add a test case for your function for both kits and objects in ObjectExtensionsTests.lua (levels\test\object_extensions_test).
--
-- To add custom data:
-- 1. Add an entry to ObjectExtensions.SubTables. The name should be all uppercase, prefixed with a '_'. The cleanup function is optional.
-- 2. If needed, implement the cleanup function above the table and reference it in the subTable.cleanupFunction.
-- 3. Ensure that no cleanup function has a sleep (or any blocking call) of any kind.  That will cause a crash.
-----------------------------------------------------------------------

REQUIRES('globals\scripts\callbacks\GlobalCallbacks.lua');
REQUIRES('globals\scripts\global_parcels.lua');

-----------------------------------------------------------------------
-- Sub-table Cleanup Functions
-----------------------------------------------------------------------

global g_ObjectExtensionCreateThreadAssertFunc = function()
	assert(false, "Cannot create threads when object parcel is ending");
end

function _CleanupParcelTable(obj, parcelData:table):void
	for _, parcel in hpairs(parcelData) do
		-- Overwrite create thread as we shouldn't be starting threads when the object has been destroyed and the parcel is ending.
		parcel._InternalCreateThread = function(parcel:table, func:ifunction, ...)
			g_ObjectExtensionCreateThreadAssertFunc();
		end

		-- End the parcel this frame so the lifetime matches that of the owning object
		CallNonYieldingFunction(ParcelEndImmediate, parcel);
	end
end

function _CleanupEventTable(obj, eventData:table):void
	for eventType, onItemTable in hpairs(eventData) do
		for onItem, callbackTable in hpairs(onItemTable) do
			for callback, _ in hpairs(callbackTable) do
				UnregisterEvent(eventType, callback, onItem);
			end
		end
	end
end

function _CleanupChildKitTable(obj, childKitData:table):void
	for childKitHandle, _ in hpairs(childKitData) do
		DeactivateKitHandleAsync(childKitHandle);
	end
end

-----------------------------------------------------------------------
-- ObjectExtensions Table
-----------------------------------------------------------------------

hstructure ObjectExtensionSubTable
	name:string;
	typeFilter:string; -- Which types to add this sub table to. nil means it's added for all object types.
	cleanupFunction:ifunction;
end

global ObjectExtensions =
{
	CONST =
	{
		-- global table defined in code containing internal data for all objects
		InternalObjectDataName = "_INTERNAL_OBJECT_DATA",
	},
	SubTables =
	{
		ParcelTable = hmake ObjectExtensionSubTable
		{
			name = "_PARCELS",
			typeFilter = nil,
			cleanupFunction = _CleanupParcelTable
		},
		EventTable = hmake ObjectExtensionSubTable
		{
			name = "_EVENTS",
			typeFilter = nil,
			cleanupFunction = _CleanupEventTable,
		},
		ChildKitTable = hmake ObjectExtensionSubTable
		{
			name = "_CHILD_KITS",
			typeFilter = "folder",
			cleanupFunction = _CleanupChildKitTable,
		},
	}
};

-----------------------------------------------------------------------
-- Internal Helpers
-----------------------------------------------------------------------

-- Gets or creates an internal data entry for an object.
function GetInternalDataForObject(obj):table
	assert(obj ~= nil);
	local objectType:string = GetEngineType(obj);

	local internalData:table = _G[ObjectExtensions.CONST.InternalObjectDataName];
	if internalData[obj] == nil then
		local objectData:table = {};

		for _, subTable in hpairs(ObjectExtensions.SubTables) do
			assert(subTable.name ~= nil);
			if subTable.typeFilter == nil or objectType == subTable.typeFilter then
				objectData[subTable.name] = {};
			end
		end

		internalData[obj] = objectData;
	end
	return internalData[obj];
end

-- Gets a sub table from the internal data table.
function GetInternalDataSubTableForObject(obj, subtableName:string):table
	assert(obj ~= nil);
	local objectData:table = GetInternalDataForObject(obj);
	assert(objectData[subtableName] ~= nil);
	return objectData[subtableName];
end

-- Called from the engine after quit() has been called on an object or kit.
-- DO NOT RENAME THIS WITHOUT UPDATING ObjectExtensions.cpp.
function CleanupInternalDataForObject(obj):void
	assert(obj ~= nil);

	-- If this object doesnt have any internal data we have nothing to do.
	if _G[ObjectExtensions.CONST.InternalObjectDataName][obj] == nil then
		return;
	end

	local objectType:string = GetEngineType(obj);

	-- Run the cleanup on all of our sub-tables.
	local objectData:table = GetInternalDataForObject(obj);
	for _, subTable in hpairs(ObjectExtensions.SubTables) do
		if subTable.typeFilter == nil or objectType == subTable.typeFilter then
			local subTableData:table = objectData[subTable.name];
			if subTable.cleanupFunction ~= nil then
				subTable.cleanupFunction(obj, subTableData);
			end
		end
	end

	-- Clear the internal data entry for this object
	_G[ObjectExtensions.CONST.InternalObjectDataName][obj] = nil;
end

-----------------------------------------------------------------------
-- Helpers
-----------------------------------------------------------------------

function CommonRegisterEventOnObject(obj, once:boolean, eventType, callback:ifunction, onItem:any, ...):void
	assert(obj ~= nil);
	assert(eventType ~= nil);
	assert(callback ~= nil);
	assert(onItem ~= nil);
	local eventData:table = GetInternalDataSubTableForObject(obj, ObjectExtensions.SubTables.EventTable.name);
	eventData[eventType] = eventData[eventType] or {};
	eventData[eventType][onItem] = eventData[eventType][onItem] or {};
	assert(eventData[eventType][onItem][callback] == nil, "Object Event Registration: tried to register a callback function twice");
	eventData[eventType][onItem][callback] = callback;

	if once == true then
		CommonRegisterFunction(obj, AutoUnregisterEventOnObject, eventType, callback, onItem, ...);
	else
		CommonRegisterFunction(obj, nil, eventType, callback, onItem, ...);
	end
end

function AutoUnregisterEventOnObject(eventStruct:EventCallbackArgs)
	UnregisterEventOnObject(eventStruct.firstArgument, eventStruct.eventType, eventStruct.callback, eventStruct.item);
end

-----------------------------------------------------------------------
-- Common Function Implementation
-- See bottom of file for registration
-----------------------------------------------------------------------

function RegisterEventOnObject(obj, eventType, callback:ifunction, onItem:any, ...):void
	CommonRegisterEventOnObject(obj, nil, eventType, callback, onItem, ...);
end

function RegisterEventOnceOnObject(obj, eventType, callback:ifunction, onItem:any, ...):void
	CommonRegisterEventOnObject(obj, true, eventType, callback, onItem, ...);
end

function UnregisterEventOnObject(obj, eventType, callback:ifunction, onItem:any):void
	assert(obj ~= nil);

	local eventData:table = GetInternalDataSubTableForObject(obj, ObjectExtensions.SubTables.EventTable.name);
	if eventData[eventType] ~= nil and eventData[eventType][onItem] ~= nil then
		eventData[eventType][onItem][callback] = nil;
	end

	UnregisterEvent(eventType, callback, onItem);
end

function RegisterGlobalEventOnObject(obj, eventType, callback:ifunction, ...):void
	CommonRegisterEventOnObject(obj, nil, eventType, callback, g_allItems, ...);
end

function RegisterGlobalEventOnceOnObject(obj, eventType, callback:ifunction, ...):void
	CommonRegisterEventOnObject(obj, true, eventType, callback, g_allItems, ...);
end

function UnregisterGlobalEventOnObject(obj, eventType, callback:ifunction):void
	UnregisterEventOnObject(obj, eventType, callback, g_allItems);
end

function ParcelAddAndStartOnObject(obj, parcel:table, parcelName:string):void
	assert(obj ~= nil, "Global Object Extensions: object is nil when attempting to start parcel: "..(parcelName or "unknown parcel name"));
	assert(parcel ~= nil, "Global Object Extensions: attempting to start parcel with a nil parcel: "..(parcelName or "unknown parcel name"));

	-- All parcels started through this function are bound to the lifetime of the object.
	parcel.isObjectParcel = true;
	parcel.owningObject = obj;

	-- Object parcels should always use object/kit threads so their lifetime matches that of the owning object.
	if obj.IsGameModule == true then
		parcel._InternalCreateThread = function(parcel:table, func:ifunction, ...)
			if KitIsActive(HandleFromKit(obj)) then
				return CreateKitThread(obj, func, ...);
			else
				print("Global Object Extensions: attempting to create a thread on an inactive kit:", obj);
				return;
			end
		end
	else
		parcel._InternalCreateThread = function(parcel:table, func:ifunction, ...)
			if Engine_ObjectExists(obj) then
				return CreateObjectThread(obj, func, ...);
			else
				print("Global Object Extensions: attempting to create a thread on invalid object:", obj);
				return;
			end
		end
	end

	local parcelData:table = GetInternalDataSubTableForObject(obj, ObjectExtensions.SubTables.ParcelTable.name);
	table.insert(parcelData, parcel);

	ParcelAddAndStart(parcel, parcelName);
end

-----------------------------------------------------------------------
-- Object Specific Functions
-----------------------------------------------------------------------

function CreateThreadOnObject(obj:object, func:ifunction, ...):thread
	return CreateObjectThread(obj, func, obj, ...);
end

-----------------------------------------------------------------------
-- Kit Specific Functions
-----------------------------------------------------------------------

function CreateThreadOnKit(obj:folder, func:ifunction, ...):thread
	return CreateKitThread(obj, func, obj, ...);
end

function GetComponentsOnObject(obj:folder, type:string):table
	return Kits_GetComponentsOfType(obj, type);
end

function GetComponentsRecursiveOnObject(obj:folder, type:string):table
	return Kits_GetComponentsOfTypeRecursive(obj, type);
end

function ActivateChildKitOnObject(obj:folder, kitName:string):handle
	local childKitHandle:folder_handle = Kits_ActivateChildKit(obj, kitName);
	if childKitHandle == nil then
		return nil;
	end
		
	local childKitData:table = GetInternalDataSubTableForObject(obj, ObjectExtensions.SubTables.ChildKitTable.name);
	childKitData[childKitHandle] = kitName;
	return childKitHandle;
end

function ActivateChildKitAsyncOnObject(obj:folder, kitName:string):handle
	local childKitHandle:folder_handle = Kits_ActivateChildKitAsync(obj, kitName);
	if childKitHandle == nil then
		return nil;
	end

	local childKitData:table = GetInternalDataSubTableForObject(obj, ObjectExtensions.SubTables.ChildKitTable.name);
	childKitData[childKitHandle] = kitName;
	return childKitHandle;
end

function DeactivateChildKitOnObject(obj:folder, childKitHandle:folder_handle):void
	local childKitData:table = GetInternalDataSubTableForObject(obj, ObjectExtensions.SubTables.ChildKitTable.name);
	Kits_DeactivateChildKit(childKitHandle);
	childKitData[childKitHandle] = nil;
end

-----------------------------------------------------------------------
-- Custom Function Registration
-----------------------------------------------------------------------

-- These functions will be added to the object and kit metatable and will be available to all objects/kits.
-- New functions must be defined above this table.
-- Do not rename this table without updating ObjectScriptExtensions.cpp.
ObjectExtensions.CustomFunctions =
{
	-- name = function name that appears on the object, func = implementation of that function.
	{ name = "RegisterEventOnSelf", func = RegisterEventOnObject },
	{ name = "RegisterEventOnceOnSelf", func = RegisterEventOnceOnObject },
	{ name = "UnregisterEventOnSelf", func = UnregisterEventOnObject },
	{ name = "RegisterGlobalEventOnSelf", func = RegisterGlobalEventOnObject },
	{ name = "RegisterGlobalEventOnceOnSelf", func = RegisterGlobalEventOnceOnObject },
	{ name = "UnregisterGlobalEventOnSelf", func = UnregisterGlobalEventOnObject },

	{ name = "ParcelAddAndStartOnSelf", func = ParcelAddAndStartOnObject },
};

-- These functions will be added to the object metatable and will be available to all objects.
-- Do not rename this table without updating ObjectScriptExtensions.cpp.
ObjectExtensions.ObjectOnlyFunctions =
{
	{ name = "CreateThread", func = CreateThreadOnObject },
};

-- These functions will be added to the kit metatable and will be available to all kits.
-- Do not rename this table without updating ObjectScriptExtensions.cpp.
ObjectExtensions.KitOnlyFunctions =
{
	-- we'll need to put these back in CustomFunctions until the code is in a green build
	{ name = "CreateThread", func = CreateThreadOnKit },
	{ name = "GetComponents", func = GetComponentsOnObject },
	{ name = "GetComponentsRecursive", func = GetComponentsRecursiveOnObject },
	{ name = "ActivateChildKit", func = ActivateChildKitOnObject },
	{ name = "ActivateChildKitAsync", func = ActivateChildKitAsyncOnObject },
	{ name = "DeactivateChildKit", func = DeactivateChildKitOnObject },
};