REQUIRES('globals/scripts/callbacks/GlobalCallbacks.lua')

--## SERVER

-- -- Mix States -- ===================================================================================================
global AudioMixStates:table = {
	
	trackedConversations = 0,	-- Number of conversations that are actively playing
	trackedMoments = 0,			-- Number of narrative movments that are actively playing
	activePersistenceKeys = {},

	-- -- -- -- -- -- -- --
	showDebugPrint = false,		-- Turn on to see debug prints to output and on screen
	showStackPrint = false,		-- Turn on in addition to above to see callstack, so you know exactly where calls were made from
	-- -- -- -- -- -- -- --
};

function startup.AudioMixStates():void
	AudioMixStates.RegisterMixStates();
end

-- -- DEBUG -----------------------------------------------------------------------------------------------------------
function AudioMixStates.DebugPrint(...):void
	if (AudioMixStates.showDebugPrint) then
		print(...);
		if (AudioMixStates.showStackPrint) then
			print(debug.traceback());
		end
	end
end

function AudioMixStates.SetMixState(stateName:string, stateValue:string):void
	AudioMixStates.DebugPrint("AudioMixStates: Setting WWise state ", stateName, " to ", stateValue);
	SetWwiseState(stateName, stateValue);
end

function AudioMixStates.ConversationStartedMixState(convoName:string):void
	if (AudioMixStates.trackedConversations == 0) then
		AudioMixStates.SetMixState("conversationisactive","active");
	end
	
	AudioMixStates.SetMixState("conversation_" .. convoName, "active");
	AudioMixStates.trackedConversations = AudioMixStates.trackedConversations + 1;
end

function AudioMixStates.ConversationEndedMixState(convoName:string):void
	AudioMixStates.trackedConversations = AudioMixStates.trackedConversations - 1;
	
	if (AudioMixStates.trackedConversations == 0) then
		AudioMixStates.SetMixState("conversationisactive","inactive");
	end
	
	AudioMixStates.SetMixState("conversation_" .. convoName, "inactive");
end

function AudioMixStates.NarrativeMomentStartedMixState(eventArgs:NarrativeMomentActivatedStruct):void
	if (AudioMixStates.trackedMoments == 0) then
		AudioMixStates.SetMixState("nseqisactive","active");
	end
	
	-- EXAMPLE to add wwise state for a specific moment enter
	--if (eventArgs.moment == NARRATIVE_MOMENTS.momentName) then
	--	AudioMixStates.SetMixState("nseq_momentName","active");
	--end

	AudioMixStates.trackedMoments = AudioMixStates.trackedMoments + 1;
end

function AudioMixStates.NarrativeMomentEndedMixState(eventArgs:NarrativeMomentDeactivatedStruct):void
	AudioMixStates.trackedMoments = AudioMixStates.trackedMoments - 1;
	
	if (AudioMixStates.trackedMoments == 0) then
		AudioMixStates.SetMixState("nseqisactive","inactive");
	end
	
	-- EXAMPLE to add wwise state for a specific moment enter
	--if (eventArgs.moment == NARRATIVE_MOMENTS.momentName) then
	--	AudioMixStates.SetMixState("nseq_momentName","inactive");
	--end
end

function AudioMixStates.SetActivePersistenceState(persistentStateKey:persistence_key, stateEnum:number)
	local objectiveState = "completed";
				
	if (stateEnum <= missionStateEnum.unknown) then 
		objectiveState = "none";
	elseif (stateEnum <= missionStateEnum.replay) then
		objectiveState = "started";
	end

	AudioMixStates.DebugPrint("AudioMixStates: POI is active, Setting persistence mixstate ", persistentStateKey, " to ", objectiveState);
	SetWwiseStateFromPersistenceState(persistentStateKey, objectiveState);
end



function AudioMixStates.SetAudioPersistenceState(persistentStateKey:persistence_key, stateEnum:number)
	AudioMixStates.DebugPrint("AudioMixstates: Attempt to set ", persistentStateKey);
	if (AudioMixStates.activePersistenceKeys ~= nil and AudioMixStates.activePersistenceKeys[persistentStateKey] ~= nil) then
		AudioMixStates.SetActivePersistenceState(persistentStateKey, stateEnum);
	end
end

function AudioMixStates.InsertAndSetPersistenceState(persistentStateKey:persistence_key)
	AudioMixStates.DebugPrint("AudioMixstates: Set persistence key ", persistentStateKey, " to active");
	AudioMixStates.activePersistenceKeys[persistentStateKey] = true;
	AudioMixStates.SetActivePersistenceState(persistentStateKey, Persistence_GetByteKey(persistentStateKey));
end

function AudioMixStates.RemoveAndSetPersistenceState(persistentStateKey:persistence_key)
	AudioMixStates.activePersistenceKeys[persistentStateKey] = nil;
	AudioMixStates.DebugPrint("AudioMixstates: POI exited, setting ", persistentStateKey, " to none");
	SetWwiseStateFromPersistenceState(persistentStateKey, "none");
end

function AudioMixStates.PoiEntered(evtArgs:PoiEnteredEventStruct):void
	if _G["GetMissionMapData"] == nil then
		AudioMixStates.DebugPrint("AudioMixstates: Error, MissionMapData not loaded and somehow we entered a POI");
		return;
	end

	if _G["CallFunctionOnAllObjectiveKeys"] == nil then
		AudioMixStates.DebugPrint("AudioMixStates: CallFunctionOnAllObjectiveKeys not loaded, maybe we just exited campaign?");
		return;
	end

	AudioMixStates.DebugPrint("AudioMixstates: POI entered with ", evtArgs.poiPersistenceKey, " persistence");
	AudioMixStates.InsertAndSetPersistenceState(evtArgs.poiPersistenceKey);

	local missionTable = _G["GetMissionMapData"](evtArgs.poiPersistenceKey);
	if missionTable ~= nil then
		_G["CallFunctionOnAllObjectiveKeys"](missionTable, AudioMixStates.InsertAndSetPersistenceState);
	end
end

function AudioMixStates.PoiExited(evtArgs:PoiExitedEventStruct):void
	if _G["GetMissionMapData"] == nil then
		AudioMixStates.DebugPrint("AudioMixstates: Error, MissionMapData not loaded and somehow we exited a POI");
		return;
	end

	if _G["CallFunctionOnAllObjectiveKeys"] == nil then
		AudioMixStates.DebugPrint("AudioMixStates: CallFunctionOnAllObjectiveKeys not loaded, maybe we just exited campaign?");
		return;
	end

	AudioMixStates.DebugPrint("AudioMixstates: POI exited with ", evtArgs.poiPersistenceKey, " persistence");
	AudioMixStates.RemoveAndSetPersistenceState(evtArgs.poiPersistenceKey);

	local missionTable = _G["GetMissionMapData"](evtArgs.poiPersistenceKey);
	if missionTable ~= nil then
		_G["CallFunctionOnAllObjectiveKeys"](missionTable, AudioMixStates.RemoveAndSetPersistenceState);
	end
end

function AudioMixStates.RegisterMixStates():void
	RegisterEvent(g_eventTypes.boolStateChanged, AudioMixStates.OnCombatStateChanged, "Combat::PlayerInCombat");
	RegisterEvent(g_eventTypes.shortStateChanged,AudioMixStates.OnRegionStateChanged, "Region::PlayerEntered");

	RegisterEvent(g_eventTypes.boolStateChanged, AudioMixStates.OnVehicleStateChanged,  "Player::InVehicle");
	RegisterEvent(g_eventTypes.boolStateChanged, AudioMixStates.OnScorpionStateChanged, "Player::InScorpion");
	RegisterEvent(g_eventTypes.boolStateChanged, AudioMixStates.OnGhostStateChanged,    "Player::InGhost");
	RegisterEvent(g_eventTypes.boolStateChanged, AudioMixStates.OnWarthogStateChanged,  "Player::InWarthog");
	RegisterEvent(g_eventTypes.boolStateChanged, AudioMixStates.OnWraithStateChanged,   "Player::InWraith");
	RegisterEvent(g_eventTypes.boolStateChanged, AudioMixStates.OnPhantomStateChanged,  "Player::InPhantom");
	RegisterEvent(g_eventTypes.boolStateChanged, AudioMixStates.OnForkStateChanged,     "Player::InFork");
	RegisterEvent(g_eventTypes.boolStateChanged, AudioMixStates.OnSeraphStateChanged,   "Player::InSeraph");
	RegisterEvent(g_eventTypes.boolStateChanged, AudioMixStates.OnPelicanStateChanged,  "Player::InPelican");
	RegisterEvent(g_eventTypes.boolStateChanged, AudioMixStates.OnBansheeStateChanged,  "Player::InBanshee");
	RegisterEvent(g_eventTypes.boolStateChanged, AudioMixStates.OnMongooseStateChanged, "Player::InMongoose");
	RegisterEvent(g_eventTypes.boolStateChanged, AudioMixStates.OnRevenantStateChanged, "Player::InRevenant");
	RegisterEvent(g_eventTypes.boolStateChanged, AudioMixStates.OnTurretStateChanged,   "Player::InTurret");
	RegisterEvent(g_eventTypes.boolStateChanged, AudioMixStates.OnPhaetonStateChanged,  "Player::InPhaeton");

	RegisterGlobalEvent(g_eventTypes.narrativeMomentActivated, AudioMixStates.NarrativeMomentStartedMixState);
	RegisterGlobalEvent(g_eventTypes.narrativeMomentDeactivated, AudioMixStates.NarrativeMomentEndedMixState);
	
	RegisterGlobalEvent(g_eventTypes.poiEntered, AudioMixStates.PoiEntered);
	RegisterGlobalEvent(g_eventTypes.poiExited, AudioMixStates.PoiExited);
end

function AudioMixStates.SetVehicleState(vehicle:string, inVehicle:boolean):void
	if (inVehicle) then
		local prefix:string = "";
		if (vehicle == "banshee" 
			or vehicle == "ghost" 
			or vehicle == "phantom" 
			or vehicle == "revenant"
			or vehicle == "seraph" 
			or vehicle == "spirit" 
			or vehicle == "wraith") then
			prefix = "veh_cv_";
		elseif (vehicle == "phaeton") then 
			prefix = "veh_fr";
		elseif (vehicle == "turret") then 
			prefix = "veh_ge_";
		elseif (vehicle == "mongoose" 
			or vehicle == "pelican" 
			or vehicle == "scorpion"
			or vehicle == "warthog") then 
			prefix = "veh_un_";
		else
			AudioMixStates.DebugPrint("AudioMixStates: Unknown vehicle type: ", vehicle );
			return;
		end
		AudioMixStates.SetMixState("player_vehicle_type", prefix .. vehicle);
	else
		AudioMixStates.SetMixState("player_vehicle_type", "none");
	end
end

function AudioMixStates.OnVehicleStateChanged(eventArgs:BoolStateChangedEventStruct):void
	if (eventArgs.newValue == false) then
		AudioMixStates.SetMixState("playerinvehicle", "playeroutofvehicle");
		AudioMixStates.SetMixState("player_vehicle_type", "none");
	else
		AudioMixStates.SetMixState("playerinvehicle", "playerinvehicle");
	end
end

function AudioMixStates.OnRegionStateChanged(eventArgs:ShortStateChangedEventStruct):void
	AudioMixStates.SetMixState("region", "region_" .. eventArgs.newValue);
end

function AudioMixStates.OnCombatStateChanged(eventArgs:BoolStateChangedEventStruct):void
	if (eventArgs.newValue) then
		AudioMixStates.SetMixState("playerincombat", "playerincombat");
	else
		AudioMixStates.SetMixState("playerincombat", "playernotincombat");
	end
end

function AudioMixStates.OnScorpionStateChanged(eventArgs:BoolStateChangedEventStruct):void
	AudioMixStates.SetVehicleState("scorpion", eventArgs.newValue);
end

function AudioMixStates.OnGhostStateChanged(eventArgs:BoolStateChangedEventStruct):void
	AudioMixStates.SetVehicleState("ghost", eventArgs.newValue);
end

function AudioMixStates.OnWarthogStateChanged(eventArgs:BoolStateChangedEventStruct):void
	AudioMixStates.SetVehicleState("warthog", eventArgs.newValue);
end

function AudioMixStates.OnWraithStateChanged(eventArgs:BoolStateChangedEventStruct):void
	AudioMixStates.SetVehicleState("wraith", eventArgs.newValue);
end

function AudioMixStates.OnPhantomStateChanged(eventArgs:BoolStateChangedEventStruct):void
	AudioMixStates.SetVehicleState("phantom", eventArgs.newValue);
end

function AudioMixStates.OnForkStateChanged(eventArgs:BoolStateChangedEventStruct):void
	AudioMixStates.SetVehicleState("spirit", eventArgs.newValue);
end

function AudioMixStates.OnSeraphStateChanged(eventArgs:BoolStateChangedEventStruct):void
	AudioMixStates.SetVehicleState("seraph", eventArgs.newValue);
end

function AudioMixStates.OnPelicanStateChanged(eventArgs:BoolStateChangedEventStruct):void
	AudioMixStates.SetVehicleState("pelican", eventArgs.newValue);
end

function AudioMixStates.OnBansheeStateChanged(eventArgs:BoolStateChangedEventStruct):void
	AudioMixStates.SetVehicleState("banshee", eventArgs.newValue);
end

function AudioMixStates.OnMongooseStateChanged(eventArgs:BoolStateChangedEventStruct):void
	AudioMixStates.SetVehicleState("mongoose", eventArgs.newValue);
end

function AudioMixStates.OnRevenantStateChanged(eventArgs:BoolStateChangedEventStruct):void
	AudioMixStates.SetVehicleState("revenant", eventArgs.newValue);
end

function AudioMixStates.OnTurretStateChanged(eventArgs:BoolStateChangedEventStruct):void
	AudioMixStates.SetVehicleState("turret", eventArgs.newValue);
end

function AudioMixStates.OnPhaetonStateChanged(eventArgs:BoolStateChangedEventStruct):void
	AudioMixStates.SetVehicleState("phaeton", eventArgs.newValue);
end