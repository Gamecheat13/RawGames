
--## SERVER


global FxContextHierarchyEnum:table = {
	none		= nil,	-- Current context will set none of the hierarchy fields.  Users can either pass 'nil' themselves, or use this as a way to keep the convention consistent during method invocation
	location	= 1,	-- Level, Domain, etc
	poi			= 2,	-- Room, Base, etc
	encounter	= 3,	-- SK attack, Ambush, Sentinel Scan, UNSC Patrol, etc
	specified	= 4,	-- Context requested by user at time of play call
	override	= 5,	-- Temporary override set by system or user at some point, which will attempt to hijack any play calls while it is in effect
	-- -- --
	COUNT		= 5,	-- Number of hierarchical fields
};


global FxInterface:table = {

	-- -- -- -- -- -- -- -- -- -- -- -- --

	loadedTagsManagerThread = nil,
	loadedStreamingParentKits = {},
	
	defaultContext = "global",
	tagContextHierarchy = {	-- Higher numbered indices are higher priority.
		[FxContextHierarchyEnum.location]	= nil,		-- Level, Domain, etc
		[FxContextHierarchyEnum.poi]		= nil,		-- Room, Base, etc
		[FxContextHierarchyEnum.encounter]	= nil,		-- SK attack, Ambush, Sentinel Scan, UNSC Patrol, etc
		[FxContextHierarchyEnum.specified]	= nil,		-- Context requested by user at time of play call
		[FxContextHierarchyEnum.override]	= nil,		-- Temporary override set by system or user at some point, which will attempt to hijack any play calls while it is in effect
	},
	functionContextHierarchy = {},	-- Will ultimately use the same structure as the above table

	PRIVATE = { },

	-- -- -- -- -- -- -- --
	showDebugPrint = false,		-- Turn on to see debug prints to output and on screen
	showStackPrint = false,		-- Turn on in addition to above to see callstack, so you know exactly where calls were made from
	-- -- -- -- -- -- -- --
};

-- Default FX **_Tags_** here:
FxInterface.loadedFxTags = {
	[FxInterface.defaultContext] = {	-- Everything defaults to 'global' tags as lowest priority.  Always-loaded default tags should go here.
----------------------------------------------------------------------------------------------------------------------------------------
--		<tag alias>			 = TAG('<relative path>'),
--      - OR -
--		<tag alias>			 = {
--								{ TAG('<relative path>'), },
--								{ TAG('<relative path>'), <number (defaults to lowest weight in the list, or 1>, },
--								etc...
--							 },
----------------------------------------------------------------------------------------------------------------------------------------
		-- Default Fx --

		-- --
	},
};

-- Default FX **_Functions_** here:
FxInterface.loadedFxFunctions = {
	[FxInterface.defaultContext] = {	-- Everything defaults to 'global' functions as lowest priority.  Always-loaded default tags should go here.
----------------------------------------------------------------------------------------------------------------------------------------
--		<function alias>	 = <function name>,
--      - OR -
--		<function alias>	 = {
--								{ <function name>, },
--								{ <function name>, weight = <number (defaults to lowest weight in the list, or 1>, },
--								etc...
--							 },
----------------------------------------------------------------------------------------------------------------------------------------
		-- Default Fx Functions --

		-- --
	},
};

-- -- DEBUG ---------------------------------------------------------------
function FxInterface.DebugPrint(...):void
	if (FxInterface.showDebugPrint) then
		print(...);
		if (FxInterface.showStackPrint) then
			print(debug.traceback());
		end
	end
end


-- -- STREAMING FUNCTIONS -------------------------------------------------
function FxInterface.LoadStreamingFunctions(streamContextId:string, functionList:table, setHierarchyContext:number, parentKit):void
	if (FxInterface.loadedFxFunctions[streamContextId]) then
		if (streamContextId == FxInterface.defaultContext) then
			FxInterface.DebugPrint("WARNING : FxInterface.LoadStreamingFunctions: Attempted to load streamed content for id", streamContextId, "- CANNOT OVERWRITE THE GLOBAL DEFAULT CONTEXT.  Doing nothing instead.");
			return;
		else
			FxInterface.DebugPrint("WARNING : FxInterface.LoadStreamingFunctions: Attempted to load streamed content for id", streamContextId, "- Context was already loaded.  STOMPING PREVIOUSLY LOADED CONTENT.");
		end
	end

	FxInterface.SetFunctionHierarchyContext(setHierarchyContext, streamContextId);

	if (not FxInterface.loadedTagsManagerThread) then
		FxInterface.loadedTagsManagerThread = CreateThread(FxInterface.LoadedTagsManager);
	end

	FxInterface.loadedFxFunctions[streamContextId] = functionList;

	if (parentKit) then
		FxInterface.loadedStreamingParentKits[parentKit] = streamContextId;
	end
end

function FxInterface.UnloadStreamingFunctions(streamContextId:string):void
	if (FxInterface.loadedFxFunctions[streamContextId]) then
		FxInterface.loadedFxFunctions[streamContextId] = nil;

		FxInterface.UnloadFunctionHierarchyContext(streamContextId);
	else
		FxInterface.DebugPrint("NOTE : FxInterface.UnloadStreamingFunctions: Attempted to unload streamed functions for id", streamContextId, "- Context was not currently loaded.  Doing nothing instead.");
	end
end


-- -- STREAMING TAGS ------------------------------------------------------
function FxInterface.LoadStreamingTags(streamContextId:string, tagList:table, setHierarchyContext:number, parentKit):void
	if (FxInterface.loadedFxTags[streamContextId]) then
		if (streamContextId == FxInterface.defaultContext) then
			FxInterface.DebugPrint("WARNING : FxInterface.LoadStreamingTags: Attempted to load streamed content for id", streamContextId, "- CANNOT OVERWRITE THE GLOBAL DEFAULT CONTEXT.  Doing nothing instead.");
			return;
		else
			FxInterface.DebugPrint("WARNING : FxInterface.LoadStreamingTags: Attempted to load streamed content for id", streamContextId, "- Context was already loaded.  STOMPING PREVIOUSLY LOADED CONTENT.");
		end
	end

	FxInterface.SetTagHierarchyContext(setHierarchyContext, streamContextId);

	if (not FxInterface.loadedTagsManagerThread) then
		FxInterface.loadedTagsManagerThread = CreateThread(FxInterface.LoadedTagsManager);
	end

	FxInterface.loadedFxTags[streamContextId] = tagList;

	if (parentKit) then
		FxInterface.loadedStreamingParentKits[parentKit] = streamContextId;
	end
end

function FxInterface.UnloadStreamingTags(streamContextId:string):void
	if (FxInterface.loadedFxTags[streamContextId]) then
		FxInterface.loadedFxTags[streamContextId] = nil;

		FxInterface.UnloadTagHierarchyContext(streamContextId);
	else
		FxInterface.DebugPrint("NOTE : FxInterface.UnloadStreamingTags: Attempted to unload streamed content for id", streamContextId, "- Context was not currently loaded.  Doing nothing instead.");
	end
end


-- -- STREAMING -----------------------------------------------------------
function FxInterface.LoadStreamingContext(streamContextId:string, tagList:table, functionList:table, setHierarchyContext:number, parentKit):void
	if (tagList) then
		FxInterface.LoadStreamingTags(streamContextId, tagList, setHierarchyContext, parentKit);
	end

	if (functionList) then
		FxInterface.LoadStreamingFunctions(streamContextId, functionList, parentKit);
	end
end

function FxInterface.UnloadStreamingContext(streamContextId:string):void
	FxInterface.UnloadStreamingFunctions(streamContextId);
	FxInterface.UnloadStreamingTags(streamContextId);
end

function FxInterface.LoadedTagsManager():void
	while(true) do
		local deadKits = {};
		for parentKit, streamContextId in pairs(FxInterface.loadedStreamingParentKits) do
			if (KitIsActive(HandleFromKit(parentKit)) == false) then
				table.insert(deadKits, parentKit);
				FxInterface.UnloadStreamingTags(streamContextId);
				FxInterface.UnloadStreamingFunctions(streamContextId);
			end
		end

		for _,parentKit in pairs(deadKits) do
			FxInterface.loadedStreamingParentKits[parentKit] = nil;
		end
		
		Sleep(10);
	end
end


-- -- UTILITY -------------------------------------------------------------
function FxInterface.PRIVATE.GetLoadedValue(valueAlias:string, contextId:string, contextTable:table)
	-- Add the requested context to the appropriate place in the relative context hierarchy
	contextTable[FxContextHierarchyEnum.specified] = contextId;

	local locatedValue:any = nil;
	local debugSelectedContextId:string = nil;

	-- Check each context in the relative hierarchy
	for i=FxContextHierarchyEnum.COUNT, 1, -1 do
		local checkContext:string = contextTable[i];

		if (checkContext and FxInterface.loadedFxTags[checkContext]) then
			if (FxInterface.loadedFxTags[checkContext][valueAlias]) then
				-- Tag located
				locatedValue = FxInterface.loadedFxTags[checkContext][valueAlias];
				debugSelectedContextId = checkContext;
			else
				FxInterface.DebugPrint("FxInterface.PRIVATE.GetLoadedValue: lookup miss for", valueAlias ,"in context", checkContext, "- Value was not found in that context.  Trying next fallback context.");
			end
		else
			FxInterface.DebugPrint("FxInterface.PRIVATE.GetLoadedValue: lookup miss for", valueAlias ,"in context", checkContext, "- Context was not currently loaded.  Trying next fallback context.");
		end
	end

	-- Hierarchy failed to find tag, check global defaults
	if (not locatedValue) then
		FxInterface.DebugPrint("FxInterface.PRIVATE.GetLoadedValue: lookup miss for", valueAlias ,"in context", contextId, "- Value not found in the hierarchy.  Trying global default context as a last resort.");

		-- Default version of tag located
		locatedValue = FxInterface.loadedFxTags[FxInterface.defaultContext][valueAlias];
		debugSelectedContextId = FxInterface.defaultContext;
	end

	local resolvedValue = (type(locatedValue) == "table" and FxInterface.ResolveRandomValue(locatedValue, valueAlias, debugSelectedContextId)) or locatedValue;
	resolvedValue = (type(resolvedValue) == "string" and EFFECTS[resolvedValue]) or resolvedValue;

	if (resolvedValue) then
		return resolvedValue, locatedValue;
	end

	-- No tag located
	FxInterface.DebugPrint("WARNING : FxInterface.PRIVATE.GetLoadedValue: Attempted to retrieve", valueAlias ,"from streamed content with context id", contextId, "- No such value was loaded in the context hierarchy.  Returning nil.");
	return nil;
end

function FxInterface.GetFunction(functionId:string, streamContextId:string)
	local resolvedTag, locatedTag = FxInterface.PRIVATE.GetLoadedValue(functionId, streamContextId, FxInterface.functionContextHierarchy);
	return resolvedTag, locatedTag;
end

function FxInterface.GetTag(tagId:string, streamContextId:string)
	local resolvedFunction, locatedFunction = FxInterface.PRIVATE.GetLoadedValue(tagId, streamContextId, FxInterface.tagContextHierarchy);
	return resolvedFunction, locatedFunction;
end

function FxInterface.ResolveRandomValue(valueTable:table, debugValueId:string, debugContextId:string):any
	if (not valueTable) then
		return nil;
	end

	local lowestWeight = 0;
	local defaultWeightCount = 0;
	local totalWeight:number = 0;

	-- Calculate our random range
	for i=1, #valueTable do
		-- Error-check for bad input and report
		if (type(valueTable[i]) == "table") then
			totalWeight = totalWeight + (valueTable[i].weight or 0);
			defaultWeightCount = defaultWeightCount + ((valueTable[i].weight and 0) or 1);
			lowestWeight = ((valueTable[i].weight and valueTable[i].weight > lowestWeight) and valueTable[i].weight) or lowestWeight;
		else
			FxInterface.DebugPrint("WARNING : FxInterface.ResolveRandomTag: Random collection", debugValueId, "in context", debugContextId, "contained invalid data at index", i, "- SKIPPING DATA AT THAT INDEX.");
		end
	end

	-- Fix up weighting for cases where weight was unspecified
	if (lowestWeight == 0) then
		lowestWeight = 1;
	end
	totalWeight = totalWeight + (defaultWeightCount * lowestWeight);

	-- Randomize
	local randomNumber = math.random(totalWeight);
	local checkValue = 0;

	for i=1, #valueTable do
		-- Error-check for bad input
		if (type(valueTable[i]) == "table") then
			checkValue = checkValue + (valueTable[i].weight or lowestWeight);
			if (checkValue >= randomNumber) then
				return valueTable[i].tag;
			end
		end
	end

	FxInterface.DebugPrint("WARNING : FxInterface.ResolveRandomTag: Attempted to resolve a random value, but for some reason our rolled number didn't match any entries!");
	return nil;
end

function FxInterface.SetFunctionHierarchyContext(hierarchyLevel:number, streamContextId:string):void
	-- Nothing should set the global level, nor imaginary levels
	if (hierarchyLevel and (hierarchyLevel < 1 or hierarchyLevel > FxContextHierarchyEnum.COUNT)) then
		FxInterface.DebugPrint("WARNING : FxInterface.SetHierarchyContext: Attempted to set function hierarchy content for id", streamContextId, "to hierarchy level", hierarchyLevel, "- Hierarchy level out of bounds.  Ignoring hierarchy assignment.");
	else
		FxInterface.functionContextHierarchy[hierarchyLevel] = streamContextId;
	end
end

function FxInterface.SetTagHierarchyContext(hierarchyLevel:number, streamContextId:string):void
	-- Nothing should set the global level, nor imaginary levels
	if (hierarchyLevel and (hierarchyLevel < 1 or hierarchyLevel > FxContextHierarchyEnum.COUNT)) then
		FxInterface.DebugPrint("WARNING : FxInterface.SetHierarchyContext: Attempted to set tag hierarchy content for id", streamContextId, "to hierarchy level", hierarchyLevel, "- Hierarchy level out of bounds.  Ignoring hierarchy assignment.");
	else
		FxInterface.tagContextHierarchy[hierarchyLevel] = streamContextId;
	end
end

function FxInterface.UnloadFunctionHierarchyContext(streamContextId:string):void
	for i=1, FxContextHierarchyEnum.COUNT do
		if (FxInterface.functionContextHierarchy[i] == streamContextId) then
			FxInterface.functionContextHierarchy[i] = nil;
		end
	end
end

function FxInterface.UnloadTagHierarchyContext(streamContextId:string):void
	for i=1, FxContextHierarchyEnum.COUNT do
		if (FxInterface.tagContextHierarchy[i] == streamContextId) then
			FxInterface.tagContextHierarchy[i] = nil;
		end
	end
end


-- -- INTERFACE -----------------------------------------------------------
-- Returns BOOLEAN, RESULTS
--  BOOLEAN : TRUE if the function was found and run successfully ; FALSE if the function was not found or run
--  RESULTS : Returns any and all values returned by the run fx function
function FxInterface.TryAndRunFunctionInContext(streamContextId:string, functionId:string, ...)
	local returnCode:boolean = false;
	local functionResult:any = nil;
	local resultsCollection:table = {};

	if (not functionId or functionId == "") then
		FxInterface.DebugPrint("WARNING : FxInterface.TryAndRunFunctionInContext: Attempted to run a nil or empty loaded fx function from streamed content with context id", streamContextId, " - Doing nothing instead.");
		return;
	end

	local runFunction:ifunction = FxInterface.GetFunction(functionId, streamContextId);
	
	if (runFunction) then
		resultsCollection = { runFunction(...), };
		returnCode = true;
	end

	table.insert(resultsCollection, 1, returnCode);

	return table.unpack(resultsCollection);
end

function FxInterface.TryAndRunFunction(functionId:string, ...)
	return FxInterface.TryAndRunFunctionInContext(nil, functionId, ...);
end
