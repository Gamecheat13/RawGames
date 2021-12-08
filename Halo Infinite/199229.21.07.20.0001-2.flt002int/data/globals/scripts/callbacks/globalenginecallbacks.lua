--## SERVER

-- Global Object Callbacks
-- Copyright (C) Microsoft. All rights reserved.


-------------------------------------------------------------------------------------------------
-- Team Added Callback
-- Called by the game whenever a new MP Team is added
-------------------------------------------------------------------------------------------------

hstructure TeamAddedEventStruct
	team:mp_team;
end

-- Callback from C++
function TeamAddedCallback(team:mp_team)
	local eventArgs = hmake TeamAddedEventStruct
		{
			team = team
		}

	CallEvent(g_eventTypes.teamAddedEvent, nil, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Script File Unloaded
-- Called when a script tag is unloaded meaning nothing is requiring it any longer.
-------------------------------------------------------------------------------------------------

function GetCurrentFileBeingLoaded()
	-- This is set by the engine when we start loading a file into the VM and cleared once the compilation has finished.
	-- The purpose of this is to be able to associate global data added in the file scope of a lua file with the file that added it.
	-- You can then subcribe to OnScriptFileUnloaded and when the hash matches the one returned by this function you know that file has been unloaded.
	if _G["currentFileBeingLoaded"] ~= nil then
		return _G["currentFileBeingLoaded"];
	end
	return nil;
end

hstructure ScriptFileUnloadedArgs
	scriptNameHash:luserdata;
end

function OnScriptFileUnloaded(scriptNameHash)
	local eventArgs = hmake ScriptFileUnloadedArgs
		{
			scriptNameHash = scriptNameHash
		};

	CallEvent(g_eventTypes.onScriptFileUnloaded, nil, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Vignette Event Callback
-- Called by the game whenever a Vignette Event is triggered
-------------------------------------------------------------------------------------------------

hstructure VignetteEventCallbackStruct
	showId:number;
	eventName:string_id;
end

-- Callback from C++
function VignetteEventCallback(showId:number, eventName)
	local eventArgs = hmake VignetteEventCallbackStruct
		{
			showId = showId,
			eventName = eventName
		}

	CallEvent(g_eventTypes.vignetteEventCallback, nil, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Show Finished Callback
-- Called by the game whenever a Show is finished
-------------------------------------------------------------------------------------------------

hstructure ShowFinishedEventStruct
	showId:number;
end

-- Callback from C++
function ShowFinishedCallback(showId:number)
	local eventArgs = hmake ShowFinishedEventStruct
		{
			showId = showId
		}

	CallEvent(g_eventTypes.showFinishedEvent, showId, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Show Deleted Callback
-- Called by the game whenever a Show is deleted
-------------------------------------------------------------------------------------------------

hstructure ShowDeletedEventStruct
	showId:number;
end

-- Callback from C++
function ShowDeletedCallback(showId:number)
	local eventArgs = hmake ShowDeletedEventStruct
		{
			showId = showId
		}

	CallEvent(g_eventTypes.showDeletedEvent, showId, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Map Intro Finished Callback
-- Called by the game when the map intro is finished
-------------------------------------------------------------------------------------------------

-- Callback from C++
function MapIntroFinishedCallback()
	CallEvent(g_eventTypes.mapIntroFinishedEvent, nil);
end

-------------------------------------------------------------------------------------------------
-- Networked Property Deleted Callback
-- Called by the game whenever a Networked Property is deleted
-------------------------------------------------------------------------------------------------

hstructure NetworkedPropertyDeletedEventStruct
	networkedPropertyDatumIndex		:ui64;
	deletedNetworkedProperty		:networked_property;
end

-- Callback from C++
function NetworkedPropertyDeletedCallback(networkedPropertyDatumIndex:ui64, deletedNetworkedProperty:networked_property)
	local eventArgs = hmake NetworkedPropertyDeletedEventStruct
		{
			networkedPropertyDatumIndex = networkedPropertyDatumIndex,
			deletedNetworkedProperty = deletedNetworkedProperty
		};

	CallEvent(g_eventTypes.networkedPropertyDeletedEvent, deletedNetworkedProperty, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Navpoint Deleted Callback
-- Called by the game whenever a Navpoint is deleted
-------------------------------------------------------------------------------------------------

hstructure NavpointDeletedEventStruct
	navpointDatumIndex 		:ui64;
	deletedNavpoint			:navpoint;
end

-- Callback from C++
function NavpointDeletedCallback(navpointDatumIndex:ui64, deletedNavpoint:navpoint)
	local eventArgs = hmake NavpointDeletedEventStruct
		{
			navpointDatumIndex = navpointDatumIndex,
			deletedNavpoint = deletedNavpoint
		};

	CallEvent(g_eventTypes.navpointDeletedEvent, deletedNavpoint, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Objective Deleted Callback
-- Called by the game whenever an Objective is deleted
-------------------------------------------------------------------------------------------------

hstructure ObjectiveDeletedEventStruct
	objectiveDatumIndex 	:ui64;
	deletedObjective		:objective;
end

-- Callback from C++
function ObjectiveDeletedCallback(objectiveDatumIndex:ui64, deletedObjective:objective)
	local eventArgs = hmake ObjectiveDeletedEventStruct
		{
			objectiveDatumIndex = objectiveDatumIndex,
			deletedObjective = deletedObjective
		}

	CallEvent(g_eventTypes.objectiveDeletedEvent, deletedObjective, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Medal Awarded Callback
-- Called by the game whenever a medal is awarded to a player
-------------------------------------------------------------------------------------------------

hstructure MedalAwardedEventStruct
	player:player;
	medalId:string_id;
	difficulty:number;
	category:number;
end

-- Callback from C++
function MedalAwardedCallback(player:player, medalId, difficulty, category)
	local eventArgs = hmake MedalAwardedEventStruct
		{
			player = player,
			medalId = medalId,
			difficulty = difficulty,
			category = category,
		};

	CallEvent(g_eventTypes.medalAwardedEvent, player, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Highlight Event Callback
-- Called by the game whenever a highlight worthy event has occurred.
-------------------------------------------------------------------------------------------------

hstructure HighlightEventStruct
	player:player;
	highlightValue:number;
end

-- Callback from C++
function HighlightEventCallback(player:player, value:number)
	local eventArgs = hmake HighlightEventStruct
		{
			player = player,
			highlightValue = value
		};
	
	CallEvent(g_eventTypes.highlightEvent, nil, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Round Start Callback
-- Called by the game whenever a Round starts
-------------------------------------------------------------------------------------------------

hstructure RoundStartEventStruct
	roundIndex:number;
	isOvertimeRound:boolean;
end

-- Callback from C++
function RoundPreStartCallback(roundIndex:number, isOvertimeRound:boolean)
	local eventArgs = hmake RoundStartEventStruct
		{
			roundIndex = roundIndex,
			isOvertimeRound = isOvertimeRound
		};

	CallEvent(g_eventTypes.roundPreStartEvent, nil, eventArgs);
end

-- Callback from C++
function RoundStartCallback(roundIndex:number, isOvertimeRound:boolean)
	local eventArgs = hmake RoundStartEventStruct
		{
			roundIndex = roundIndex,
			isOvertimeRound = isOvertimeRound
		};

	CallEvent(g_eventTypes.roundStartEvent, nil, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Round Start Gameplay Callback
-- Called by the game whenever gameplay in a Round starts
--	i.e. when the Match Flow intros end and player control resumes, OR
--	     if screen sequences are completely disabled, then when the first human player spawns
-------------------------------------------------------------------------------------------------

hstructure RoundStartGameplayEventStruct
	roundIndex:number;
end

-- Callback from C++
function RoundStartGameplayCallback(roundIndex:number)
	local eventArgs = hmake RoundStartGameplayEventStruct
		{
			roundIndex = roundIndex;
		};
	CallEvent(g_eventTypes.roundStartGameplayEvent, nil, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Round Pre End Callback
-- Called by the game right as soon as the round end process begins
-------------------------------------------------------------------------------------------------

-- Callback from C++
function RoundPreEndCallback()
	CallEvent(g_eventTypes.roundPreEndEvent, nil);
end

-------------------------------------------------------------------------------------------------
-- Round End Callback
-- Called by the game as it transitions into the post-round state; *** Use this for standard Round End events ***
-- Specifically, when Engine::prepare_for_new_state is called with the new state of _game_engine_state_post_round
-------------------------------------------------------------------------------------------------

-- Callback from C++
function RoundEndCallback()
	CallEvent(g_eventTypes.roundEndEvent, nil);
end

-------------------------------------------------------------------------------------------------
-- Level End Callback
-- Called by the game when the campaign level is about to be unloaded.  Used to do any last-minute saving from scripts.
-- Since this is immediate, and not Async, do not call any Sleep functions in anything that listens to this event.
-------------------------------------------------------------------------------------------------

-- Callback from C++
function CampaignLevelEndedCallbackImmediate()
	CallEvent(g_eventTypes.levelEndEventImmediate, nil);
end

-------------------------------------------------------------------------------------------------
-- Entered Between Round State Callback
-- Called by the game as it transitions into the between round state
-- Specifically, when Engine::prepare_for_new_state is called with the new state of _game_engine_state_between_rounds
-------------------------------------------------------------------------------------------------

-- Callback from C++
function EnteredBetweenRoundStateCallback()
	CallEvent(g_eventTypes.enteredBetweenRoundStateEvent, nil);
end

-------------------------------------------------------------------------------------------------
-- Gameplay Complete Callback
-- Called by the game when the multiplayer match has finished play and has started wrapping up.
-- This is called before the final round's RoundEndCallback
-------------------------------------------------------------------------------------------------

-- Callback from C++
function GameplayCompleteCallback()
	CallEvent(g_eventTypes.gameplayCompleteEvent, nil);
end

-------------------------------------------------------------------------------------------------
-- Game End Callback
-- Called by the game whenever the MP game ends (game meaning a single multiplayer game, consisting of one or more rounds)
-------------------------------------------------------------------------------------------------

-- Callback from C++ right before GameEndCallback()
function GamePreEndCallback()
	CallEvent(g_eventTypes.gamePreEndEvent, nil);
end

-- Callback from C++
function GameEndCallback()
	CallEvent(g_eventTypes.gameEndEvent, nil);
end

-------------------------------------------------------------------------------------------------
-- Notify Server Shutdown Callback
-- Called by the game whenever it has received a mandated Thunderhead shutdown notice
-------------------------------------------------------------------------------------------------

-- Callback from C++
function NotifyServerShutdownCallback()
	CallEvent(g_eventTypes.notifyServerShutdownEvent, nil);
end

-------------------------------------------------------------------------------------------------
-- Timer Expired Callback
-- Called by the game whenever a GameEngineTimer expires
-------------------------------------------------------------------------------------------------

hstructure TimerExpiredEventStruct
	expiredTimer:timer;
end

-- Callback from C++
function TimerExpiredEventCallback(timerIdx:timer)
	local eventArgs = hmake TimerExpiredEventStruct
		{
			expiredTimer = timerIdx
		};

	CallEvent(g_eventTypes.timerExpiredEvent, timerIdx, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- ScriptWorldCenterChanged
-- Called by the game whenever a new BSP is entered by a player and intended for the purpose of
-- re-centering script logic on said BSP.
-------------------------------------------------------------------------------------------------

hstructure ScriptWorldCenterChangedEventStruct
	player:		player;
	newCenter:	vector;
end

-- Callback from C++
function ScriptWorldCenterChangedCallback(player:player, newCenter:vector)
	local eventArgs = hmake ScriptWorldCenterChangedEventStruct
		{
			player = player,
			newCenter = newCenter,
		};

	CallEvent(g_eventTypes.scriptWorldCenterChanged, player, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Streaming Script Activate Callback
-- Called by the engine activates a streaming script.
-------------------------------------------------------------------------------------------------

hstructure StreamingScriptActivateEventStruct
	streamingScript:simulation_control_entity;
end

-- Callback from C++
function StreamingScriptActivateCallback(streamingScript:simulation_control_entity)
	local eventArgs = hmake StreamingScriptActivateEventStruct
		{
			streamingScript = streamingScript
		};

	CallEvent(g_eventTypes.streamingScriptActivate, streamingScript, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Streaming Script Deactivate Callback
-- Called by the engine deactivates a streaming script.
-------------------------------------------------------------------------------------------------

hstructure StreamingScriptDeactivateEventStruct
	streamingScript:simulation_control_entity;
end

-- Callback from C++
function StreamingScriptDeactivateCallback(streamingScript:simulation_control_entity)
	local eventArgs = hmake StreamingScriptDeactivateEventStruct
		{
			streamingScript = streamingScript
		};

	CallEvent(g_eventTypes.streamingScriptDeactivate, streamingScript, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Activation Volume Vicinity Entered Callback
-- Called by the engine when a player enters the vicinity of an activation volume.
-------------------------------------------------------------------------------------------------

hstructure ActivationVolumeVicinityEnteredEventStruct
	activationVolume:activation_volume;
end

-- Callback from C++
function ActivationVolumeVicinityEnteredCallback(activationVolume:activation_volume)
	local eventArgs = hmake ActivationVolumeVicinityEnteredEventStruct
		{
			activationVolume = activationVolume
		};

	CallEvent(g_eventTypes.activationVolumeVicinityEnteredEvent, activationVolume, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Activation Volume Entered Callback
-- Called by the engine when a player enters an activation volume.
-------------------------------------------------------------------------------------------------

hstructure ActivationVolumeEnteredEventStruct
	activationVolume:activation_volume;
end

-- Callback from C++
function ActivationVolumeEnteredCallback(activationVolume:activation_volume)
	local eventArgs = hmake ActivationVolumeEnteredEventStruct
		{
			activationVolume = activationVolume
		};

	CallEvent(g_eventTypes.activationVolumeEnteredEvent, activationVolume, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Activation Volume Exited Callback
-- Called by the engine when all players exit an activation volume.
-------------------------------------------------------------------------------------------------

hstructure ActivationVolumeExitedEventStruct
	activationVolume:activation_volume;
end

-- Callback from C++
function ActivationVolumeExitedCallback(activationVolume:activation_volume)
	local eventArgs = hmake ActivationVolumeExitedEventStruct
		{
			activationVolume = activationVolume
		};

	CallEvent(g_eventTypes.activationVolumeExitedEvent, activationVolume, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Activation Volume Vicinity Exited Callback
-- Called by the engine when all players exit the vicinity of an activation volume.
-------------------------------------------------------------------------------------------------

hstructure ActivationVolumeVicinityExitedEventStruct
	activationVolume:activation_volume;
end

-- Callback from C++
function ActivationVolumeVicinityExitedCallback(activationVolume:activation_volume)
	local eventArgs = hmake ActivationVolumeVicinityExitedEventStruct
		{
			activationVolume = activationVolume
		};

	CallEvent(g_eventTypes.activationVolumeVicinityExitedEvent, activationVolume, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Activation Volume Vicinity PlayerEntered Callback
-- Called by the engine when a player enters the vicinity of an activation volume.
-------------------------------------------------------------------------------------------------

hstructure ActivationVolumeVicinityPlayerEnteredEventStruct
	activationVolume:activation_volume;
	player:player;
end

-- Callback from C++
function ActivationVolumeVicinityPlayerEnteredCallback(activationVolume:activation_volume, player:player)
	local eventArgs = hmake ActivationVolumeVicinityPlayerEnteredEventStruct
		{
			activationVolume = activationVolume,
			player = player,
		};

	CallEvent(g_eventTypes.activationVolumeVicinityPlayerEnteredEvent, activationVolume, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Activation Volume PlayerEntered Callback
-- Called by the engine when a player enters an activation volume.
-------------------------------------------------------------------------------------------------

hstructure ActivationVolumePlayerEnteredEventStruct
	activationVolume:activation_volume;
	player:player;
end

-- Callback from C++
function ActivationVolumePlayerEnteredCallback(activationVolume:activation_volume, player:player)
	local eventArgs = hmake ActivationVolumePlayerEnteredEventStruct
		{
			activationVolume = activationVolume,
			player = player,
		};

	CallEvent(g_eventTypes.activationVolumePlayerEnteredEvent, activationVolume, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Activation Volume PlayerExited Callback
-- Called by the engine when all players exit an activation volume.
-------------------------------------------------------------------------------------------------

hstructure ActivationVolumePlayerExitedEventStruct
	activationVolume:activation_volume;
	player:player;
end

-- Callback from C++
function ActivationVolumePlayerExitedCallback(activationVolume:activation_volume, player:player)
	local eventArgs = hmake ActivationVolumePlayerExitedEventStruct
		{
			activationVolume = activationVolume,
			player = player
		};

	CallEvent(g_eventTypes.activationVolumePlayerExitedEvent, activationVolume, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Activation Volume Vicinity PlayerExited Callback
-- Called by the engine when all players exit an activation volume.
-------------------------------------------------------------------------------------------------

hstructure ActivationVolumeVicinityPlayerExitedEventStruct
	activationVolume:activation_volume;
	player:player;
end

-- Callback from C++
function ActivationVolumeVicinityPlayerExitedCallback(activationVolume:activation_volume, player:player)
	local eventArgs = hmake ActivationVolumeVicinityPlayerExitedEventStruct
		{
			activationVolume = activationVolume,
			player = player
		};

	CallEvent(g_eventTypes.activationVolumeVicinityPlayerExitedEvent, activationVolume, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Activation Volume CameraEntered Callback
-- Called by the engine when a camera enters an activation volume.
-------------------------------------------------------------------------------------------------

hstructure ActivationVolumeCameraEnteredEventStruct
	activationVolume:activation_volume;
end

-- Callback from C++
function ActivationVolumeCameraEnteredCallback(activationVolume:activation_volume)
	local eventArgs = hmake ActivationVolumeCameraEnteredEventStruct
		{
			activationVolume = activationVolume
		};

	CallEvent(g_eventTypes.activationVolumeCameraEnteredEvent, activationVolume, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Activation Volume CameraExited Callback
-- Called by the engine when a camera exits an activation volume.
-------------------------------------------------------------------------------------------------

hstructure ActivationVolumeCameraExitedEventStruct
	activationVolume:activation_volume;
end

-- Callback from C++
function ActivationVolumeCameraExitedCallback(activationVolume:activation_volume)
	local eventArgs = hmake ActivationVolumeCameraExitedEventStruct
		{
			activationVolume = activationVolume
		};

	CallEvent(g_eventTypes.activationVolumeCameraExitedEvent, activationVolume, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Campaign Map Opened Callback
-- Called by the game whenever the campaign map is opened
-------------------------------------------------------------------------------------------------
hstructure CampaignMapOpenedEventStruct
	participant:		player;
end

-- Callback from C++
function CampaignMapOpenedCallback(participant:player)
	local eventArgs = hmake CampaignMapOpenedEventStruct
		{
			participant = participant
		}
	CallEvent(g_eventTypes.campaignMapOpenedEvent, nil, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Campaign Map Closed Callback
-- Called by the game whenever the campaign map is closed
-------------------------------------------------------------------------------------------------
hstructure CampaignMapClosedEventStruct
	participant:		player;
end

function CampaignMapClosedCallback(participant:player)
	local eventArgs = hmake CampaignMapClosedEventStruct
		{
			participant = participant
		}
	CallEvent(g_eventTypes.campaignMapClosedEvent, nil, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Campaign Map Set Waypoint Callback
-- Called by the game whenever a campaign map waypoint is set or removed
-------------------------------------------------------------------------------------------------

hstructure CampaignMapSetWaypointEventStruct
	participant:		player;
	isVisible:			boolean;
	waypointPosition:	vector;
	lockedToPOI:		string_id;
end

-- new Callback from C++
function CampaignMapSetWaypointCallback(participant:player, isVisible:boolean, waypointPosition:vector, lockedToPOI:string_id)
	local eventArgs = hmake CampaignMapSetWaypointEventStruct
		{
			participant = participant,
			isVisible = isVisible,
			waypointPosition = waypointPosition,
			lockedToPOI = lockedToPOI
		}
	CallEvent(g_eventTypes.campaignMapSetWaypointEvent, nil, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Campaign Map Set Fast Travel Callback
-- Called by the game when the fast travel destination has been set.
-------------------------------------------------------------------------------------------------
hstructure CampaignMapFastTravelSetStruct
	poiId:			string_id;
end

-- Callback from C++
function CampaignMapSetFastTravelCallback(poiId:string_id)
	local eventArgs = hmake CampaignMapFastTravelSetStruct
		{
			poiId = poiId
		}
	CallEvent(g_eventTypes.campaignMapSetFastTravelEvent, nil, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Campaign Map Mission Start
-- Called by the game when a mission has been triggered for start or replay.
-------------------------------------------------------------------------------------------------
hstructure CampaignMapStartMissionStruct
	missionId:			string_id;
	difficulty:			difficulty;
	activeSkulls:		table;
end

-- Callback from C++
function CampaignMapStartMissionCallback(missionId:string_id, difficulty:difficulty, ...)
	local activeSkulls = {};

	local count:number = arg.n;
	for i = 1, count -1, 2 do
		local skull = arg[i];	-- skull enum
		local isActive = arg[i + 1];	-- boolean

		activeSkulls[skull] = 
		{
			skull = skull;
			isActive = isActive;
		};
	end

	local eventArgs = hmake CampaignMapStartMissionStruct
		{
			missionId = missionId,
			difficulty = difficulty,
			activeSkulls = activeSkulls
		}
	CallEvent(g_eventTypes.campaignMapStartMissionEvent, nil, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Air Drop Callbacks
-------------------------------------------------------------------------------------------------

hstructure AirDropCargoDeliveredEventStruct
	flight:handle;
	cargo:object;
end

function AirDrop_OnCargoDelivered(flight:handle, cargo:object)
	local eventArgs = hmake AirDropCargoDeliveredEventStruct
	{
		flight = flight,
		cargo = cargo
	};
	CallEvent(g_eventTypes.airDropCargoDelivered, flight, eventArgs);
end

hstructure AirDropFlightCompletedEventStruct
	flight:handle;
end

function AirDrop_OnFlightCompleted(flight:handle)
	local eventArgs = hmake AirDropFlightCompletedEventStruct
	{
		flight = flight,
	};
	CallEvent(g_eventTypes.airDropFlightCompleted, flight, eventArgs);
end

hstructure AirDropFlightInterruptedEventStruct
	flight:handle;
end

function AirDrop_OnFlightInterrupted(flight:handle)
	local eventArgs = hmake AirDropFlightInterruptedEventStruct
	{
		flight = flight,
	};
	CallEvent(g_eventTypes.airDropFlightInterrupted, flight, eventArgs);
end


-------------------------------------------------------------------------------------------------
-- Supply Lines Callbacks
-------------------------------------------------------------------------------------------------
hstructure SupplyLinesRequestEventStruct
	participant:player;
	deliveryLocation:location;
end

function SupplyLines_OnDropStarted(participant:player, deliveryLocation:location)
	local eventArgs = hmake SupplyLinesRequestEventStruct
	{
		participant = participant,
		deliveryLocation = deliveryLocation
	};
	CallEvent(g_eventTypes.supplyLinesDropIncoming, nil, eventArgs);
end

hstructure SupplyLinesVehicleDeliveredEventStruct
	participant:player;
	vehicle:object;
end

function SupplyLines_OnVehicleDelivered(participant:player, vehicle:object)
	local eventArgs = hmake SupplyLinesVehicleDeliveredEventStruct
	{
		participant = participant,
		vehicle = vehicle
	};
	CallEvent(g_eventTypes.supplyLinesVehicleDelivered, nil, eventArgs);
end

function SupplyLines_OnDropCompleted(participant:player)
end

function SupplyLines_OnDropInterrupted(participant:player)
end

hstructure SupplyLinesSendSmallCargoEventStruct
	itemTag:tag;
	configTag:tag;
	location:location;
end

function SupplyLines_SendSmallCargo(itemTag:tag, configTag:tag, location:location)
	local eventArgs = hmake SupplyLinesSendSmallCargoEventStruct
	{
		itemTag = itemTag,
		configTag = configTag,
		location = location
	};
	CallEvent(g_eventTypes.supplyLinesSendSmallCargo, nil, eventArgs);
end

hstructure SupplyLinesRequestFailedEventStruct
	participant: player;
	reason:supply_lines_drop_request_result;
end

function SupplyLines_OnRequestFailed(participant:player, failureReason:supply_lines_drop_request_result)
	local eventArgs = hmake SupplyLinesRequestFailedEventStruct
	{
		participant = participant,
		reason = failureReason, 
	};
	CallEvent(g_eventTypes.supplyLinesDropFailed, nil, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Supply Lines Request Salvage Pickup
-- Called when a supply crate is interacted with
-------------------------------------------------------------------------------------------------

hstructure SupplyLinesSalvageCollectedEventStruct
	obj:object;
	size:number;
	shouldLevelUp:boolean;
	interactPlayer:player;
end

-------------------------------------------------------------------------------------------------
-- Match Flow Callbacks
--	NOTE: These are called via C++ from strings specified in tag data
--	//depot/Shiva/P4Main/tags/ui/olympus_multiplayer.user_interface_globals_definition
-------------------------------------------------------------------------------------------------
function TeamOutroStartCallback():void
	CallEvent(g_eventTypes.teamOutroStartEvent, nil);
end

function TeamOutroEndCallback():void
	CallEvent(g_eventTypes.teamOutroEndEvent, nil);
end

-- Callback from C++
function MatchFlowIntroEndedCallback():void
	CallEvent(g_eventTypes.matchFlowIntroEndedEvent, nil);
end

-- Callback from C++
function MapFlybyIntroStartCallback():void
	CallEvent(g_eventTypes.mapFlybyIntroStartEvent, nil);
end

-------------------------------------------------------------------------------------------------
-- FOB Vehicle Selection Opened Callback
-- Called by engine when the FOB Vehicle Selection screen is opened
-------------------------------------------------------------------------------------------------

hstructure FOBVehicleSelectionEventStruct
	interactee:player
end

function FOBVehicleSelectionOpenedCallback(interactee:player):void
	local eventArgs = hmake FOBVehicleSelectionEventStruct
	{
		interactee = interactee
	};

	CallEvent(g_eventTypes.fobVehicleSelectionOpened, interactee, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- FOB Vehicle Selection Closed Callback
-- Called by engine when the FOB Vehicle Selection screen is closed
-------------------------------------------------------------------------------------------------

function FOBVehicleSelectionClosedCallback(interactee:player):void
	local eventArgs = hmake FOBVehicleSelectionEventStruct
	{
		interactee = interactee
	};

	CallEvent(g_eventTypes.fobVehicleSelectionClosed, interactee, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- FOB Vehicle Selection Commit Callback
-- Called by engine when the player has committed their vehicle choice
-------------------------------------------------------------------------------------------------

function FOBVehicleSelectionCommitCallback(interactee:player):void
	local eventArgs = hmake FOBVehicleSelectionEventStruct
	{
		interactee = interactee
	};

	CallEvent(g_eventTypes.fobVehicleSelectionCommit, interactee, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- FOB Vehicle Selection Cancel Callback
-- Called by engine when the player has cancelled out of vehicle selection
-------------------------------------------------------------------------------------------------

function FOBVehicleSelectionCancelCallback(interactee:player):void
	local eventArgs = hmake FOBVehicleSelectionEventStruct
	{
		interactee = interactee
	};

	CallEvent(g_eventTypes.fobVehicleSelectionCancel, interactee, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- FOB Vehicle Selection Next Callback
-- Called by engine when the player has cycled to the next vehicle
-------------------------------------------------------------------------------------------------

function FOBVehicleSelectionNextCallback(interactee:player):void
	local eventArgs = hmake FOBVehicleSelectionEventStruct
	{
		interactee = interactee
	};

	CallEvent(g_eventTypes.fobVehicleSelectionNext, interactee, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- FOB Vehicle Selection Previous Callback
-- Called by engine when the player has cycled to the previous vehicle
-------------------------------------------------------------------------------------------------

function FOBVehicleSelectionPreviousCallback(interactee:player):void
	local eventArgs = hmake FOBVehicleSelectionEventStruct
	{
		interactee = interactee
	};

	CallEvent(g_eventTypes.fobVehicleSelectionPrevious, interactee, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- FOB Vehicle Selection Previous Callback
-- Called by engine when the player has cycled to the previous vehicle
-------------------------------------------------------------------------------------------------

function FOBVehicleSelectionUpCallback(interactee:player):void
	local eventArgs = hmake FOBVehicleSelectionEventStruct
	{
		interactee = interactee
	};

	CallEvent(g_eventTypes.fobVehicleSelectionUp, interactee, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- FOB Vehicle Selection Previous Callback
-- Called by engine when the player has cycled to the previous vehicle
-------------------------------------------------------------------------------------------------

function FOBVehicleSelectionDownCallback(interactee:player):void
	local eventArgs = hmake FOBVehicleSelectionEventStruct
	{
		interactee = interactee
	};

	CallEvent(g_eventTypes.fobVehicleSelectionDown, interactee, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Campaign Equipment Upgrade Purchased Callback
-- Called by the game whenever the player purchases an equipment upgrade
-------------------------------------------------------------------------------------------------

hstructure EquipmentUpgradePurchasedEventStruct
	targetPlayer:		player;
	equipmentPathIndex:	number;
	equipmentPathID:	string_id;
end

-- Callback from C++
function CampaignEquipmentUpgradePurchasedCallback(targetPlayer:player, equipmentPathIndex:number, equipmentPathID:string_id)
	local eventArgs = hmake EquipmentUpgradePurchasedEventStruct
	{
		targetPlayer = targetPlayer,
		equipmentPathIndex = equipmentPathIndex, 
		equipmentPathID = equipmentPathID, 
	};
	CallEvent(g_eventTypes.equipmentUpgradeEvent, nil, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Campaign Audio Log Play Requested Callback
-- Called by the engine when player asks for playing/stopping an audio log
-------------------------------------------------------------------------------------------------

hstructure AudioLogPlayRequestStruct
	targetPlayer:		player;
	convoId:			any;
	codexListIndex:		any;
	codexEntryIndex:	any;
	isPlayRequest:		any;
end

-- Callback from C++
function CampaignAudioLogPlayRequestedCallback(targetPlayer:player, secondParam:any, thirdParam:any, fourthParam:boolean)
	local convoId_string_as_version = true;

	-- If convoId_string_as_version is true then this script is ahead of the engine.
	if GetEngineType(secondParam) == 'string' and GetEngineType(thirdParam) == 'boolean' and fourthParam == nil then
		convoId_string_as_version = true;
	else
		convoId_string_as_version = false;
	end

	local convoId = secondParam;
	local isPlayRequest = thirdParam;
	local codexListIndex = secondParam;
	local codexEntryIndex = thirdParam;

	if convoId_string_as_version then
		codexListIndex = nil;
		codexEntryIndex = nil;
	else
		convoId = nil;
		isPlayRequest = fourthParam;
	end

	local eventArgs = hmake AudioLogPlayRequestStruct
	{
		targetPlayer = targetPlayer,
		convoId = convoId;
		codexListIndex = codexListIndex,
		codexEntryIndex = codexEntryIndex,
		isPlayRequest = isPlayRequest, 
	};
	CallEvent(g_eventTypes.audioLogPlayRequested, nil, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Campaign Dialog Window Dismissed Callback
-- Called by the engine when a player dismisses a dialog window
-------------------------------------------------------------------------------------------------

hstructure NotificationDialogWindowEventStruct
	interactee:		player;
end

-- Callback from C++
function NotificationDialogWindowDismissedCallback(interactee:player)
	local eventArgs = hmake NotificationDialogWindowEventStruct
	{
		interactee = interactee
	};

	CallEvent(g_eventTypes.dialogWindowDismissed, interactee, eventArgs);
end
