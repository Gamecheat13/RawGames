
--## SERVER


global AudioContextHierarchyEnum:table = {
	none		= nil,	-- Current context will set none of the hierarchy fields.  Users can either pass 'nil' themselves, or use this as a way to keep the convention consistent during method invocation
	location	= 1,	-- Level, Domain, etc
	encounter	= 2,	-- Dynamic events
	fob 		= 3,	-- FOBs
	rescue		= 4,	-- Marine rescues
	hvt			= 5,	-- High value targets
	outpost		= 6,	-- Outposts
	base		= 7,	-- Bases and FR Towers
	specified	= 8,	-- Context requested by user at time of play call
	override	= 9,	-- Temporary override set by system or user at some point, which will attempt to hijack any play calls while it is in effect
	-- -- --
	COUNT		= 9,	-- Number of hierarchical fields
};


global AudioInterface:table = {
	-- -- -- -- -- -- -- -- -- -- -- -- --

	isContextLoadingEnabled = true,

	loadedTagsManagerThread = nil,
	loadedStreamingParentKits = {},
	
	defaultContext = "global",
	contextHierarchy = {	-- Higher numbered indices are higher priority.
		[AudioContextHierarchyEnum.location]	= nil,		-- Level, Domain, etc
		[AudioContextHierarchyEnum.encounter]	= nil,		-- Dynamic events
		[AudioContextHierarchyEnum.fob]			= nil,		-- FOBs
		[AudioContextHierarchyEnum.rescue]		= nil,		-- Marine rescues
		[AudioContextHierarchyEnum.hvt]			= nil,		-- High value targets
		[AudioContextHierarchyEnum.outpost]		= nil,		-- Outposts
		[AudioContextHierarchyEnum.base]		= nil,		-- Bases and FR Towers
		[AudioContextHierarchyEnum.specified]	= nil,		-- Context requested by user at time of play call
		[AudioContextHierarchyEnum.override]	= nil,		-- Temporary override set by system or user at some point, which will attempt to hijack any play calls while it is in effect
	},

	loadedAudioFunctions = {},

	-- -- -- -- -- -- -- --
	showDebugPrint = false,		-- Turn on to see debug prints to output and on screen
	showStackPrint = false,		-- Turn on in addition to above to see callstack, so you know exactly where calls were made from
	-- -- -- -- -- -- -- --
};

AudioInterface.loadedAudioTags = {
	[AudioInterface.defaultContext] = {	-- Everything defaults to 'global' tags as lowest priority.  Always-loaded default tags should go here.
----------------------------------------------------------------------------------------------------------------------------------------
--		<tag alias>			 = TAG('<relative path>'),
--      - OR -
--		<tag alias>			 = {
--								{ tag = TAG('<relative path>'), },
--								{ tag = TAG('<relative path>'), weight = <number (defaults to lowest weight in the list, or 1>, },
--								etc...
--							 },
----------------------------------------------------------------------------------------------------------------------------------------
		-- Fast Travel Music --
		fastTravel			 = TAG('sound\120_music_campaign\global\120_mus_global_fasttravel_stopall.music_control'),
		
		-- Default Death Music --
		stopAll				 = TAG('sound\120_music_campaign\global\120_mus_global_death_stopall.music_control'),
		
		-- Default Combat Music --
		combatStart			 = TAG('sound\120_music_campaign\open_world\Combat\120_mus_ow_combat_start_stateless.music_control'),		
		combatStopOutro		 = TAG('sound\120_music_campaign\open_world\Combat\120_mus_ow_combat_stop_outro.music_control'),
		combatStopPlayout	 = TAG('sound\120_music_campaign\open_world\Combat\120_mus_ow_combat_stop_playout.music_control'),
		combatLow			 = TAG('sound\120_music_campaign\open_world\Combat\120_mus_ow_combat_transition_low.music_control'),
		combatMedium		 = TAG('sound\120_music_campaign\open_world\Combat\120_mus_ow_combat_transition_med.music_control'),
		combatHigh			 = TAG('sound\120_music_campaign\open_world\Combat\120_mus_ow_combat_transition_high.music_control'),
		
		-- Volumes --
		innerVolumeEntered	 = TAG('sound\120_music_campaign\open_world\volumes\120_mus_ow_global_volume_inner_entered.music_control'),
		innerVolumeExited	 = TAG('sound\120_music_campaign\open_world\volumes\120_mus_ow_global_volume_inner_exited.music_control'),
		outerVolumeEntered 	 = TAG('sound\120_music_campaign\open_world\volumes\120_mus_ow_global_volume_outer_entered.music_control'),
		outerVolumeExited	 = TAG('sound\120_music_campaign\open_world\volumes\120_mus_ow_global_volume_outer_exited.music_control'),
		
		-- Default Boss Music --
		bossIntro			 = TAG('sound\120_music_campaign\open_world\combat\120_mus_ow_combat_boss_intro.music_control'),
		bossKilled			 = TAG('sound\120_music_campaign\open_world\combat\120_mus_ow_combat_boss_killed.music_control'),

		-- Fob Bloodgate Lifted
		fobBloodgateLifted	 = TAG('sound\120_music_campaign\open_world\fobs\120_mus_ow_fob_bloodgate_lifted.music_control'),

		
		-- PiP SFX --
		--aiChatOpen			 = TAG('sound\003_levels\003_lvl_moments\003_lvl_moments_ow_hud\003_lvl_moments_ow_hud_pip\003_hud_pip_cortana_in.sound'),
		--aiChatClose			 = TAG('sound\003_levels\003_lvl_moments\003_lvl_moments_ow_hud\003_lvl_moments_ow_hud_pip\003_hud_pip_cortana_out.sound'),
		--commsOpen			 = TAG('sound\003_levels\003_lvl_moments\003_lvl_moments_ow_hud\003_lvl_moments_ow_hud_pip\003_hud_pip_pilot_in.sound'),
		--commsClose			 = TAG('sound\003_levels\003_lvl_moments\003_lvl_moments_ow_hud\003_lvl_moments_ow_hud_pip\003_hud_pip_pilot_out.sound'),
		-- --
	},
};

-- -- DEBUG ---------------------------------------------------------------
function AudioInterface.DebugPrint(...):void
	if (AudioInterface.showDebugPrint) then
		print(...);
		if (AudioInterface.showStackPrint) then
			print(debug.traceback());
		end
	end
end


-- -- STREAMING FUNCTIONS -------------------------------------------------
function AudioInterface.LoadStreamingFunctions(streamContextId:string, functionList:table, parentKit):void
	if (not streamContextId) then
		AudioInterface.DebugPrint("WARNING : AudioInterface.LoadStreamingFunctions: Attempted to load streamed content for nil id!  Doing nothing.");
		return;
	end

	if (not AudioInterface.CanLoadContexts()) then
		AudioInterface.DebugPrint("WARNING : AudioInterface.LoadStreamingFunctions: Attempted to load streamed content for id", streamContextId, "- Loading contexts is currently disabled.  Doing nothing.");
		return;
	end

	if (AudioInterface.loadedAudioFunctions[streamContextId]) then
		if (streamContextId == AudioInterface.defaultContext) then
			AudioInterface.DebugPrint("WARNING : AudioInterface.LoadStreamingFunctions: Attempted to load streamed content for id", streamContextId, "- CANNOT OVERWRITE THE GLOBAL DEFAULT CONTEXT.  Doing nothing instead.");
			return;
		else
			AudioInterface.DebugPrint("WARNING : AudioInterface.LoadStreamingFunctions: Attempted to load streamed content for id", streamContextId, "- Context was already loaded.  STOMPING PREVIOUSLY LOADED CONTENT.");
		end
	end

	if (not AudioInterface.loadedTagsManagerThread) then
		AudioInterface.loadedTagsManagerThread = CreateThread(AudioInterface.LoadedTagsManager);
	end

	AudioInterface.loadedAudioFunctions[streamContextId] = functionList;

	if (parentKit) then
		AudioInterface.loadedStreamingParentKits[parentKit] = streamContextId;
	end
end

function AudioInterface.UnloadStreamingFunctions(streamContextId:string):void
	if (AudioInterface.loadedAudioFunctions[streamContextId]) then
		AudioInterface.loadedAudioFunctions[streamContextId] = nil;
	else
		AudioInterface.DebugPrint("NOTE : AudioInterface.UnloadStreamingFunctions: Attempted to unload streamed functions for id", streamContextId, "- Context was not currently loaded.  Doing nothing instead.");
	end
end


-- -- STREAMING TAGS ------------------------------------------------------
function AudioInterface.LoadStreamingTags(streamContextId:string, tagList:table, setHierarchyContext:number, parentKit):void
	if (not streamContextId) then
		AudioInterface.DebugPrint("WARNING : AudioInterface.LoadStreamingTags: Attempted to load streamed content for nil id!  Doing nothing.");
		return;
	end

	if (not AudioInterface.CanLoadContexts()) then
		AudioInterface.DebugPrint("WARNING : AudioInterface.LoadStreamingTags: Attempted to load streamed content for id", streamContextId, "- Loading contexts is currently disabled.  Doing nothing.");
		return;
	end

	if (AudioInterface.loadedAudioTags[streamContextId]) then
		if (streamContextId == AudioInterface.defaultContext) then
			AudioInterface.DebugPrint("WARNING : AudioInterface.LoadStreamingTags: Attempted to load streamed content for id", streamContextId, "- CANNOT OVERWRITE THE GLOBAL DEFAULT CONTEXT.  Doing nothing instead.");
			return;
		else
			AudioInterface.DebugPrint("WARNING : AudioInterface.LoadStreamingTags: Attempted to load streamed content for id", streamContextId, "- Context was already loaded.  STOMPING PREVIOUSLY LOADED CONTENT.");
		end
	end

	AudioInterface.SetHierarchyContext(setHierarchyContext, streamContextId);

	if (not AudioInterface.loadedTagsManagerThread) then
		AudioInterface.loadedTagsManagerThread = CreateThread(AudioInterface.LoadedTagsManager);
	end

	AudioInterface.loadedAudioTags[streamContextId] = tagList;

	if (parentKit) then
		AudioInterface.loadedStreamingParentKits[parentKit] = streamContextId;
	end
end

function AudioInterface.UnloadStreamingTags(streamContextId:string):void
	if (AudioInterface.loadedAudioTags[streamContextId]) then
		AudioInterface.loadedAudioTags[streamContextId] = nil;

		AudioInterface.UnloadHierarchyContext(streamContextId);
	else
		AudioInterface.DebugPrint("NOTE : AudioInterface.UnloadStreamingTags: Attempted to unload streamed content for id", streamContextId, "- Context was not currently loaded.  Doing nothing instead.");
	end
end


-- -- STREAMING -----------------------------------------------------------
function AudioInterface.LoadStreamingContext(streamContextId:string, tagList:table, functionList:table, setHierarchyContext:number, parentKit):void
	if (tagList) then
		AudioInterface.LoadStreamingTags(streamContextId, tagList, setHierarchyContext, parentKit);
	end

	if (functionList) then
		AudioInterface.LoadStreamingFunctions(streamContextId, functionList, parentKit);
	end
end

function AudioInterface.UnloadStreamingContext(streamContextId:string):void
	AudioInterface.UnloadStreamingFunctions(streamContextId);
	AudioInterface.UnloadStreamingTags(streamContextId);
end

function AudioInterface.LoadedTagsManager():void
	while(true) do
		local deadKits = {};
		for parentKit, streamContextId in pairs(AudioInterface.loadedStreamingParentKits) do
			if (KitIsActive(HandleFromKit(parentKit)) == false) then
				table.insert(deadKits, parentKit);
				AudioInterface.UnloadStreamingTags(streamContextId);
				AudioInterface.UnloadStreamingFunctions(streamContextId);
			end
		end

		for _,parentKit in pairs(deadKits) do
			AudioInterface.loadedStreamingParentKits[parentKit] = nil;
		end
		
		Sleep(10);
	end
end


-- -- UTILITY -------------------------------------------------------------
function AudioInterface.GetLoadedAudioTag(tagId:string, streamContextId:string)
	-- Add the requested context to the appropriate place in the relative context hierarchy
	AudioInterface.contextHierarchy[AudioContextHierarchyEnum.specified] = streamContextId;

	local locatedTag:any = nil;
	local debugSelectedContextId:string = nil;

	-- Check each context in the relative hierarchy
	for i=AudioContextHierarchyEnum.COUNT, 1, -1 do
		local checkContext:string = AudioInterface.contextHierarchy[i];

		if (checkContext and AudioInterface.loadedAudioTags[checkContext]) then
			if (AudioInterface.loadedAudioTags[checkContext][tagId]) then
				-- Tag located
				AudioInterface.DebugPrint("AudioInterface.GetLoadedAudioTag: found tag", tagId ,"in context", checkContext, "- Tag was found in that context.");
				locatedTag = AudioInterface.loadedAudioTags[checkContext][tagId];
				debugSelectedContextId = checkContext;
				break;
			else
				AudioInterface.DebugPrint("AudioInterface.GetLoadedAudioTag: tag miss for tag", tagId ,"in context", checkContext, i, "- Tag was not found in that context.  Trying next fallback context.");
			end
		else
			AudioInterface.DebugPrint("AudioInterface.GetLoadedAudioTag: tag miss for tag", tagId ,"in context", checkContext, i, "- Context was not currently loaded.  Trying next fallback context.");
		end
	end

	-- Hierarchy failed to find tag, check global defaults
	if (not locatedTag) then
		AudioInterface.DebugPrint("AudioInterface.GetLoadedAudioTag: tag miss for tag", tagId ,"in context", streamContextId, "- Tag not found in the hierarchy.  Trying global default context as a last resort.");

		-- Default version of tag located
		locatedTag = AudioInterface.loadedAudioTags[AudioInterface.defaultContext][tagId];
		debugSelectedContextId = AudioInterface.defaultContext;
	end

	local resolvedTag = (type(locatedTag) == "table" and AudioInterface.ResolveRandomTag(locatedTag, tagId, debugSelectedContextId)) or locatedTag;

	if (resolvedTag) then
		return resolvedTag, locatedTag;
	end

	-- No tag located
	AudioInterface.DebugPrint("WARNING : AudioInterface.GetLoadedAudioTag: Attempted to retrieve sound tag", tagId ,"from streamed content with context id", streamContextId, "- No such tag was loaded in the context hierarchy.  Returning nil.");
	return nil;
end

function AudioInterface.ResolveRandomTag(tagTable:table, debugTagId:string, debugContextId:string):tag
	if (not tagTable) then
		return nil;
	end

	local lowestWeight = 0;
	local defaultWeightCount = 0;
	local totalWeight:number = 0;

	-- Calculate our random range
	for i=1, #tagTable do
		-- Error-check for bad input and report
		if (type(tagTable[i]) == "table") then
			totalWeight = totalWeight + (tagTable[i].weight or 0);
			defaultWeightCount = defaultWeightCount + ((tagTable[i].weight and 0) or 1);
			lowestWeight = ((tagTable[i].weight and tagTable[i].weight > lowestWeight) and tagTable[i].weight) or lowestWeight;
		else
			AudioInterface.DebugPrint("WARNING : AudioInterface.ResolveRandomTag: Random tag collection", debugTagId, "in context", debugContextId, "contained invalid data at index", i, "- SKIPPING DATA AT THAT INDEX.");
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

	for i=1, #tagTable do
		-- Error-check for bad input
		if (type(tagTable[i]) == "table") then
			checkValue = checkValue + (tagTable[i].weight or lowestWeight);
			if (checkValue >= randomNumber) then
				return tagTable[i].tag;
			end
		end
	end

	AudioInterface.DebugPrint("WARNING : AudioInterface.ResolveRandomTag: Attempted to resolve a random tag, but for some reason our rolled number didn't match any entries!");
	return nil;
end

function AudioInterface.SetHierarchyContext(hierarchyLevel:number, streamContextId:string):void
	-- Nothing should set the global level, nor imaginary levels
	if (hierarchyLevel and (hierarchyLevel < 1 or hierarchyLevel > AudioContextHierarchyEnum.COUNT)) then
		AudioInterface.DebugPrint("WARNING : AudioInterface.SetHierarchyContext: Attempted to set hierarchy content for id", streamContextId, "to hierarchy level", hierarchyLevel, "- Hierarchy level out of bounds.  Ignoring hierarchy assignment.");
	else
		AudioInterface.contextHierarchy[hierarchyLevel] = streamContextId;
	end
end

function AudioInterface.UnloadHierarchyContext(streamContextId:string):void
	for i=1, AudioContextHierarchyEnum.COUNT do
		if (AudioInterface.contextHierarchy[i] == streamContextId) then
			AudioInterface.contextHierarchy[i] = nil;
		end
	end
end

function AudioInterface.CanLoadContexts():boolean
	return AudioInterface.isContextLoadingEnabled;
end


-- -- SFX -----------------------------------------------------------------
function AudioInterface.PlaySoundImpulse(soundTagId:string, emittingObject:object, scale:number, streamContextId:string):void
	local soundTag:tag, stopTag:any = AudioInterface.GetLoadedAudioTag(soundTagId, streamContextId);

	if (type(stopTag) == "table") then
		stopTag.lastPlayedTag = soundTag;
	end

	if (soundTag) then
		SoundImpulseStartServer(soundTag, emittingObject, (scale or 1));
	end
end

function AudioInterface.PlaySoundImpulseMarker(soundTagId:string, emittingObject:object, emittingMarker:string, scale:number, streamContextId:string):void
	local soundTag:tag, stopTag:any = AudioInterface.GetLoadedAudioTag(soundTagId, streamContextId);

	if (type(stopTag) == "table") then
		stopTag.lastPlayedTag = soundTag;
	end

	if (soundTag) then
		SoundImpulseStartMarkerServer(soundTag, emittingObject, emittingMarker, (scale or 1));
	end
end

function AudioInterface.PlayLoopingSound(soundTagId:string, emittingObject:object, scale:number, streamContextId:string):void
	local soundTag:tag, stopTag:any = AudioInterface.GetLoadedAudioTag(soundTagId, streamContextId);

	if (type(stopTag) == "table") then
		stopTag.lastPlayedTag = soundTag;
	end

	if (soundTag) then
		sound_looping_start(soundTag, emittingObject, (scale or 1));
	end
end

function AudioInterface.StopLoopingSound(soundTagId:string, emittingObject:object, streamContextId:string):void
	local soundTag:tag, stopTag:any = AudioInterface.GetLoadedAudioTag(soundTagId, streamContextId);

	stopTag = (type(stopTag) == "table" and stopTag.lastPlayedTag) or soundTag;

	if (stopTag) then
		sound_looping_stop_object(stopTag, emittingObject);
	end
end

-- Specific Pip Calls
function AudioInterface.OpenCommsPip():void
	AudioInterface.PlaySoundImpulse("commsOpen", nil, 1, nil);
end

function AudioInterface.CloseCommsPip():void
	AudioInterface.PlaySoundImpulse("commsClose", nil, 1, nil);
end

function AudioInterface.OpenLocalPip():void
	AudioInterface.PlaySoundImpulse("aiChatOpen", nil, 1, nil);
end

function AudioInterface.CloseLocalPip():void
	AudioInterface.PlaySoundImpulse("aiChatClose", nil, 1, nil);
end


-- -- MUSIC ---------------------------------------------------------------
function AudioInterface.SendMusicEvent(musicTagId:string, streamContextId:string):void
	local soundTag:tag = AudioInterface.GetLoadedAudioTag(musicTagId, streamContextId);
	if (soundTag) then
		music_event(soundTag);
	end
end


-- -- INTERFACE -----------------------------------------------------------
function AudioInterface.TryAndRunLoadedAudioFunction(streamContextId:string, functionName:string, ...):void
	if (not streamContextId or streamContextId == "") then
		AudioInterface.DebugPrint("WARNING : AudioInterface.TryAndRunLoadedAudioFunction: Attempted to run loaded audio function", functionName ,"from nil or empty streamed content - Doing nothing instead.");
		return;
	end

	if (not functionName or functionName == "") then
		AudioInterface.DebugPrint("WARNING : AudioInterface.TryAndRunLoadedAudioFunction: Attempted to run a nil or empty loaded audio function from streamed content with context id", streamContextId, " - Doing nothing instead.");
		return;
	end

	if (not AudioInterface.loadedAudioFunctions[streamContextId]) then
		AudioInterface.DebugPrint("WARNING : AudioInterface.TryAndRunLoadedAudioFunction: Attempted to run loaded audio function", functionName ,"from streamed content with context id", streamContextId, "- Context was not currently loaded.  Doing nothing instead.");
		return;
	end

	if (not AudioInterface.loadedAudioFunctions[streamContextId][functionName]) then
		AudioInterface.DebugPrint("WARNING : AudioInterface.TryAndRunLoadedAudioFunction: Attempted to run loaded audio function", functionName ,"from streamed content with context id", streamContextId, "- Function was not found in that context.  Doing nothing instead.");
		return;
	end

	AudioInterface.loadedAudioFunctions[streamContextId][functionName](...);
end

function AudioInterface.TryAndRunLoadedAudioKitFunction(streamContextId:string, functionName:string, ...):void
	for parentKit, kitStreamContextId in pairs(AudioInterface.loadedStreamingParentKits) do
		if (kitStreamContextId == streamContextId) then
			AudioInterface.TryAndRunLoadedAudioFunction(streamContextId, functionName, parentKit, unpack(arg));
			return;
		end
	end

	AudioInterface.DebugPrint("WARNING : AudioInterface.TryAndRunLoadedAudioKitFunction: Attempted to run loaded audio function", functionName ,"from streamed content with context id", streamContextId, "- No kit associated with that context was found.  Doing nothing instead.");
end

function AudioInterface.DisableContextLoading()
	AudioInterface.DebugPrint("AudioInterface.DisableContextLoading: Context loading has been disabled.");
	AudioInterface.isContextLoadingEnabled = false;
end

function AudioInterface.EnableContextLoading()
	AudioInterface.DebugPrint("AudioInterface.EnableContextLoading: Context loading has been enabled.");
	AudioInterface.isContextLoadingEnabled = true;
end
