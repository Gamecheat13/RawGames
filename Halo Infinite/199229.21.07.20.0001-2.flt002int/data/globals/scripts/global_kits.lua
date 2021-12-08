-- Copyright (c) Microsoft. All rights reserved.
-- ===============================================================================================================================================
-- KITS GLOBALS ================================================================================================================================
-- ===============================================================================================================================================

-- === Kits_GetComponents: gets a table of all the 'real' components of a kit
--		kit			- the kit whose components will be checked
-- === RETURNS: returns a table of the components of a kit
-- === EXAMPLE: local kitComponents:table = Kits_GetComponents(KITS.myKit);
function Kits_GetComponents(kit:folder):table
	return Kits_GetComponentsOfType(kit, nil);
end

-- === Kits_GetComponentsRecursive: gets a table of all the 'real' components of a kit and its nested kits
--		kit			- the kit whose components will be checked
-- === RETURNS: returns a table of the components of a kit
-- === EXAMPLE: local kitComponents:table = Kits_GetComponents(KITS.myKit);
function Kits_GetComponentsRecursive(kit:folder):table
	return Kits_GetComponentsOfTypeRecursive(kit, nil, nil);
end

-- === Kits_GetNestedKits: gets a table of all the nested kits marked as scriptable of a kit (only 1 level deep)
--		kit			- the kit that will be checked
-- === RETURNS: returns a table of the components of a kit
-- === EXAMPLE: local kitComponents:table = Kits_GetNestedKits(KITS.myKit);
-- === NOTES: this will only get children kits not grandchildren, etc.
function Kits_GetNestedKits(kit:folder):table
	return Kits_GetComponentsOfType(kit, "folder");
end

-- === Kits_GetNestedKitsByTypeName: gets a table of all the nested kits of a particular type marked as scriptable of a kit (only 1 level deep)
--		kit			- the kit that will be checked
--		type_name	- the type name to check against for returned kits
-- === RETURNS: returns a table of the nested kits of a kit that match a particular type
-- === EXAMPLE: local kitComponents:table = Kits_GetNestedKitsByTypeName(KITS.myKit, "monster_closet_kit");
-- === NOTES: this will only get children kits not grandchildren, etc.
function Kits_GetNestedKitsByTypeName(kit:folder, type_name:string):table
	local componentListTemporary:table = PlacedKit_GetPlacedComponentReferencesType(kit, "folder") or {};
	local componentList:table = {};

	for _, component in ipairs(componentListTemporary) do
		if type(component) == "struct" and struct.name(component) == type_name then
			table.insert(componentList, component);
		end
	end
	return componentList;
end

-- === Kits_GetComponentsOfType: gets a table of all the 'real' components of a kit of a certain type
--		kit			- the kit whose components will be checked
--		type:string	- the type of components (for example, "flag" will return all the cutscene_flags)
-- === RETURNS: returns a table of the components of a kit of a certain type
-- === EXAMPLE: local kitComponents:table = Kits_GetComponentsOfType(KITS.myKit, "flag");
function Kits_GetComponentsOfType(kit:folder, type:string):table
	local componentList:table = PlacedKit_GetPlacedComponentReferencesType(kit, type) or {};
	return componentList;
end

hstructure Kits_GetComponentsOfTypeRecursive_Struct
	batchSize : number;
	currentCount : number;
end

function Kits_GetComponentsOfTypeRecursive_ThrottleSleep(throttlingContext:Kits_GetComponentsOfTypeRecursive_Struct) : void
	if throttlingContext.batchSize < 0 then
		return;
	end
	throttlingContext.currentCount = throttlingContext.currentCount + 1;
	if(throttlingContext.currentCount >= throttlingContext.batchSize) then
		Sleep(1);
		throttlingContext.currentCount = 0;
	end
end

-- === Kits_GetComponentsOfTypeRecursive: gets a table of all the 'real' components of a kit and its nested kits of a certain type
--		kit			- the kit whose components will be checked
--		type:string	- the type of components (for example, "flag" will return all the cutscene_flags)
--		recursiveList - the running list of all components in the kit and nested kits. Top level list shoudl be nil.
-- === RETURNS: returns a table of the components of a kit of a certain type
-- === EXAMPLE: local kitComponents:table = Kits_GetComponentsOfType(KITS.myKit, "flag");
function Kits_GetComponentsOfTypeRecursive(kit:folder, type:string, recursiveList:table):table
	local throttlingContext = hmake Kits_GetComponentsOfTypeRecursive_Struct {
		batchSize = -1,
		currentCount = 0
	};
	return Kits_GetComponentsOfTypeRecursiveThrottled(kit, type, throttlingContext, recursiveList);
end

-- === Kits_GetComponentsOfTypeRecursiveThrottled: gets a table of all the 'real' components of a kit and its nested kits of a certain type
--		kit			- the kit whose components will be checked
--		type:string	- the type of components (for example, "flag" will return all the cutscene_flags)
--		recursiveList - the running list of all components in the kit and nested kits. Top level list shoudl be nil.
--		batchSize - number of children to go through
-- === RETURNS: returns a table of the components of a kit of a certain type
-- === EXAMPLE: local kitComponents:table = Kits_GetComponentsOfType(KITS.myKit, "flag");
function Kits_GetComponentsOfTypeRecursiveThrottled(kit:folder, type:string, throttlingContext:Kits_GetComponentsOfTypeRecursive_Struct, recursiveList:table):table
	local componentList:table = recursiveList or {};
	local nestedKits = Kits_GetNestedKits(kit);
	Kits_GetComponentsOfTypeRecursive_ThrottleSleep(throttlingContext);
	for _,childKit in ipairs(nestedKits) do
		componentList = Kits_GetComponentsOfTypeRecursiveThrottled(childKit, type, throttlingContext, componentList);
	end
	
	local myComponents;
	if type ~= "folder" then
		myComponents = Kits_GetComponentsOfType(kit, type);
		Kits_GetComponentsOfTypeRecursive_ThrottleSleep(throttlingContext);
	else
		-- If we want all nested kits recursively, we don't have to request them again from the engine, we already did when asking for Kits_GetNestedKits.
		myComponents = nestedKits;
	end

	for _,comp in ipairs(myComponents) do
		table.insert(componentList, comp);
	end
	return componentList;
end

-- === kit_pairs: allows iterating over the placed components of a kit.  The type argument limits the iterator to only those types
--		kit			- the kit whose components will be iterated
--		type		- the type of the component to be iterated on (this can be nil or not entered)
-- === RETURNS: returns an iterator function that traverses the values of the placed components of a kit
-- === EXAMPLE: for k, nestedKit in kit_pairs(KITS.myKit, "folder") do
-- ===				print("the nested kit is", nestedKit);
-- ===			end
-- === EXAMPLE: for k, component in kit_pairs(KITS.myKit) do
-- ===				print("the nested kit is", component);
-- ===			end
function kit_pairs(kit:folder, type:string)
	local component:table = Kits_GetComponentsOfType(kit, type);
	return next, component, nil;
end


--## SERVER

-- === Kits_ActivateChildKitAsync: streams in a child kit. This does not sleep
--		parentKit				- the parent kit of the child kit
--		childKitToStream:string	- the name of the child kit to stream
-- === RETURNS: returns the kit handle for the streamed in child kit (use this to deactivate the kit)
-- === EXAMPLE: Kits_ActivateChildKitAsync(KITS.myKit, "name_of_child_kit")
-- === NOTE: if parentKit is nil then it will attempt to stream in a kit from the root layer
function Kits_ActivateChildKitAsync(parentKit:folder, childKitToStream:string):folder_handle
	--if there is no legit childKitToStream string, then return (this could happen if there is nothing in the activator dropdown)
	if childKitToStream == nil then
		print(parentKit," -- Kits_ActivateChildKit: childKitToStream is nil");
		return nil;
	end

	local kitHandle = CreateKitHandle(parentKit, childKitToStream);
		
	--if there is no legit kit handle, then return (this could happen if the childKitToStream is blank or input incorrectly)
	if kitHandle == nil then
		print(parentKit," -- Kits_ActivateChildKit: there is no valid streaming kit named:", childKitToStream);
		return nil;
	end

	-- if child kit is already active just return it
	if KitIsActive(kitHandle) then
		return kitHandle;
	end
	
	--start streaming the kitHandle
	local kitStartedStreaming:boolean = ActivateKitHandleAsync(kitHandle);
	--if the kit didn't start streaming, then return (this could happen if the kit is already loaded)
	if kitStartedStreaming ~= true then
		print(parentKit," -- Kits_ActivateChildKit: kit didn't start streaming (maybe already streamed):", childKitToStream);
		return nil;
	end
	
	return kitHandle;
end

-- === Kits_WaitUntilChildKitIsActive: This sleeps until the child kit is loaded
--		parentKit				- the parent kit of the child kit
--		childKitToStream:string	- the name of the child kit to stream
--		kitHandle				- the kit to wait on
function Kits_WaitUntilChildKitIsActive(parentKit:folder, childKitToStream:string, kitHandle:folder_handle)
	local maxLoadSeconds:number = 10;
	local kitStreamed:boolean = false;

	if kitHandle ~= nil then
		--sleep until the kit is streamed in, checkin every 10 seconds to print
		--advised by Josh Mattoon
		repeat
			kitStreamed = SleepUntilReturnSeconds([|KitHandleState(kitHandle) == RUNTIME_LAYER_STATE.Active], 0.001, maxLoadSeconds);
			if kitStreamed == false then
				print(parentKit," -- Kits_ActivateChildKit: streaming kit is taking a long time to load", childKitToStream);
			end
		until kitStreamed == true;
	end

	return kitHandle;
end

-- === Kits_ActivateChildKit: streams in a child kit. This sleeps until the child kit is loaded
--		parentKit				- the parent kit of the child kit
--		childKitToStream:string	- the name of the child kit to stream
-- === RETURNS: returns the kit handle for the streamed in child kit (use this to deactivate the kit)
-- === EXAMPLE: Kits_ActivateChildKit(KITS.myKit, "name_of_child_kit")
-- === NOTE: if parentKit is nil then it will attempt to stream in a kit from the root layer
function Kits_ActivateChildKit(parentKit:folder, childKitToStream:string):folder_handle

	local kitHandle = Kits_ActivateChildKitAsync(parentKit, childKitToStream);

	Kits_WaitUntilChildKitIsActive(parentKit, childKitToStream, kitHandle);

	return kitHandle;
end

-- === Kits_ActivateChildKitBlocking: Synchronously streams in a child kit if needed and then activates it. This blocks the engine's mainthread.
--		kitHandle				- kit to stream and activate
function Kits_ActivateChildKitBlocking(kitHandle:folder_handle):boolean
	local result = ActivateKitHandle(kitHandle);

	-- ActivateKitHandle does a blocking activation, however, it's init won't have run yet.
	-- SleepOneFrame so that the script calling this function can assume it has been initialized prior to continuing.
	SleepOneFrame();

	return result;
end

-- === Kits_DeactivateChildKit: Deactivates a kit without unloading it.
--		kitHandle				- kit to deactivate.
function Kits_DeactivateChildKit(kitHandle:folder_handle):boolean
	return DeactivateKitHandle(kitHandle);
end

-- === Kits_UnloadDeactivatedChildKit: Unloads a kit that was previously deactivated.
--		kitHandle				- kit to unload.
function Kits_UnloadDeactivatedChildKit(kitHandle:folder_handle):boolean
	return UnloadDeactivatedLayerAsync(kitHandle);
end

-- === Kits_GetTopLevelKit: finds a top level scriptable kit by name and returns a reference to
--		kitName	- the name of the top level kit
-- === RETURNS: the folder representing the kit or nil if it couldn't be found/created from a handle
function Kits_GetTopLevelKit(kitName:string):folder
	local result:folder = nil;

	local kitHandle:folder_handle = CreateKitHandle(nil, kitName);
	
	if kitHandle ~= nil then
		result = KitFromHandle(kitHandle);
	end

	return result;
end