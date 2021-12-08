-- Copyright (c) Microsoft. All rights reserved.

--- Telemetry Management Object
global Telemetry:table = {
									Internal = {},
									Enums = {},
									Mission = {},
									Resources = {
													ValidRadioActivityIndices = {},
												},
									Progression = {
												PlayerObjectInteractionIndices = {},
									},
								};

-- Enumeration to track mission status changed.
-- These aren't in the Enums block, to keep typing length short.
global TraceLevel:table = table.makeAutoEnum
	{
		"message",
		"warning",
		"error",
		"critical",
	};

-- Category enumerations
global TraceCategory:table = table.makeAutoEnum
	{
		"none",
		"players",
		"combat",
		"savegame",
		"match",
		"multiplayerProgression",
		"campaignProgression",
		"playerProgression",
		"parcel",
		"ui",
		"vehicle",
		"sound",
		"test",
		"automation",
	};

--------------------------------------------------------------------
------------------------HELPER METHODS------------------------------
--------------------------------------------------------------------
--## COMMON
Telemetry.Internal.EnabledScriptTraceCategories = {};

-- The trace level at which opted-in categories will render
Telemetry.Internal.ScriptTracePrintLevel = TraceLevel.error;

-- Renders the scripted telemetry that is being transmitted to the cloud.
Telemetry.Internal.ForceScriptedTelemetryPrint = (Telemetry_GetUserName() == "tomm");

function Telemetry.DebugPrintAllScriptedTelemetry(value:boolean)
	Telemetry.Internal.ForceScriptedTelemetryPrint = value;
end

function Telemetry.SetScriptTracePrintLevel(traceLevel:number)
	Telemetry.Internal.ScriptTracePrintLevel = traceLevel;
end

function Telemetry.EnableScriptTraceCategory(category:number)
	if (table.contains(Telemetry.Internal.EnabledScriptTraceCategories, category) == false) then
		table.insert(Telemetry.Internal.EnabledScriptTraceCategories, category);
	end
end

function Telemetry.DisableScriptTraceCategory(category:number)
	if (table.contains(Telemetry.Internal.EnabledScriptTraceCategories, category) == true) then
		table.removeValue(Telemetry.Internal.EnabledScriptTraceCategories, category);
	end
end

function TraceMessage(user:string, category:number, message:string, data:table)
	Telemetry.Trace(user, category, TraceLevel.message, message, data);
end

function TraceWarning(user:string, category:number, message:string, data:table)
	Telemetry.Trace(user, category, TraceLevel.warning, message, data);
end

function TraceError(user:string, category:number, message:string, data:table)
	Telemetry.Trace(user, category, TraceLevel.error, message, data);
end

function TraceCritical(user:string, category:number, message:string, data:table)
	Telemetry.Trace(user, category, TraceLevel.critical, message, data);
end

function Telemetry.Trace(user:string, category:number, traceLevel:number, message:string, data:table)
	local displayed:boolean = (user == Telemetry_GetUserName()) or
	(table.contains(Telemetry.Internal.EnabledScriptTraceCategories, category) == true
		and traceLevel >= Telemetry.Internal.ScriptTracePrintLevel);

	FireTelemetryEvent(
		"LUATrace", 
		{
			WasDisplayed = displayed, 
			Category = category,
			Level = traceLevel,
			Message = message,
			Data = data,
		});

	if (displayed == true) then 
		if (editor_mode() == true) then
			print(message);
		else
			dprint(message);
		end
	end
end

function Telemetry.Assert(criteria:boolean, message:string)
	if (criteria == false) then
		FireTelemetryEvent("LuaAssert", {Message= message, Traceback=debug.traceback():gsub("\\","\\\\")});
		error(message, 3); -- Invoke an assert in the calling function.
	end
end

--## SERVER
-- NOTE: From this point forward, we will likely migrate these events to C++
--       They are stored here for rapid iteration, as we identify what exactly
--       is needed to quantify telemetry from scripted environments.
-------------------------------------------------------------------------------
------------------------   CAMPAIGN PROGRESSION   -----------------------------
-------------------------------------------------------------------------------

-- Enumeration to track mission status changed.
Telemetry.Enums.MissionStatus = table.makeEnum
	{
		unknown = 0,
		known = 1,
		active = 2, -- Not used for now, will be mission with the nav marker
		inProgress = 3,
		completed = 4,
	};

-------------------------------------------------------------------------------
--                       Campaign Game Progression
-------------------------------------------------------------------------------
--------------------------Mission Status Changed-------------------------------
-------------------------------------------------------------------------------
-- Use this to track which missions a player aware of or working towards,
-- such as working through a base, or finding N hidden items in the world.

-- This tracks mission progress related to the campaign save-game.
-- Do not use for Gamertag-related progress.

-- This will be changed for all players in this campaign instance.
-- The return value is the ActivityIndex, which can be used to attribute rewards
-------------------------------------------------------------------------------
function Telemetry.Mission.MissionStatusChanged(missionNameId:telemetry_string, triggeringPlayer:player
					, oldMissionStatus:number, newMissionStatus:number, timeInMissionStateInMs:number)
	Telemetry.Assert(oldMissionStatus >= Telemetry.Enums.MissionStatus.unknown 
			and oldMissionStatus <= Telemetry.Enums.MissionStatus.completed, 
			"Telemetry: oldMissionStatus is not a valid value");
	Telemetry.Assert(newMissionStatus >= Telemetry.Enums.MissionStatus.unknown 
			and newMissionStatus <= Telemetry.Enums.MissionStatus.completed, 
			"Telemetry: newMissionStatus is not a valid value");
	
	local activityIndex = Telemetry.Internal.GetNewTelemetryIndex();
	FireTelemetryEvent("MissionStatusChanged", {
		MissionNameId = missionNameId,
		TriggeringPlayerSpawnIndex = Player_GetUnit(triggeringPlayer),
		ActivityIndex = activityIndex,
		OldMissionStatus = oldMissionStatus,
		NewMissionStatus = newMissionStatus,
		TimeInOldMissionStatusInMs = timeInMissionStateInMs,
		PlayerLocations = Telemetry.Internal.GeneratePlayerLocations(),
	});
	
	return activityIndex;
end

-------------------------------------------------------------------------------
--                       Campaign Game Progression
-------------------------------------------------------------------------------
----------------------------- Mission Progressed ------------------------------
-------------------------------------------------------------------------------
-- Use this to track progression over time towards a fixed Campaign goal, 
-- such as working through a base, or finding N hidden items in the world.

-- This tracks mission progress related to the campaign save-game.
-- Use PlayerProgression to track Gamertag-related progress (Feats?)

-- isOptional will be true when something mission-related occurs but doesn't 
--  change the percentage amount. For example, finding a power weapon.
--  Freeing all 3 marines in a base could potentially be two missions: 
--  *    An optional objective for the base, and a non-optional objective, and
--  *    A non-optional objective in the "Free 100 Marines" mission.

-- minimalDurationInMs Optional: is the amount of time taken, from start to finish, 
--        of the completed task, **without** checkpoint->failed wasted time.
--        Essentially, this is the 'speedrun' duration, in milliseconds

-- The return value is the ActivityIndex, which can be used to attribute rewards
-------------------------------------------------------------------------------
function Telemetry.Mission.MissionProgressed(missionNameId:telemetry_string, triggeringPlayer:player, 
											isOptional:boolean, percentComplete:number, 
											completedTaskId:telemetry_string, minimalDurationInMs:number)

	local activityIndex = Telemetry.Internal.GetNewTelemetryIndex();
	FireTelemetryEvent("MissionProgressed", {
		MissionNameId = missionNameId,
		ActivityIndex = activityIndex,
		CompletedTaskNameId = completedTaskId,
		MinimalDurationInMs = minimalDurationInMs,
		TriggeringPlayerSpawnIndex = Player_GetUnit(triggeringPlayer),
		IsOptional = isOptional,
		MissionCompletionPct = percentComplete,
		PlayerLocations = Telemetry.Internal.GeneratePlayerLocations(),
	});

	return activityIndex;
end

-------------------------------------------------------------------------------
--                       Campaign Game Progression
-------------------------------------------------------------------------------
---------------------------- Mission Task Started -----------------------------
-------------------------------------------------------------------------------
-- Use this to track the player recieving an active mission objective.

-------------------------------------------------------------------------------
function Telemetry.Mission.MissionTaskStarted(triggeringPlayer:player, missionName:string, 
											objectiveName:string, objectiveWorldLocation:vector)
	local missionNameId = Telemetry_RegisterHashString(missionName);
	local objectiveNameId = Telemetry_RegisterHashString(objectiveName);
	-- todo: Update TriggeringPlayerSpawnIndex to PlayerSeqId
	FireTelemetryEvent("MissionTaskStarted", {
		TriggeringPlayerSpawnIndex = Player_GetUnit(triggeringPlayer),
		MissionNameId = missionNameId,
		ObjectiveNameId = objectiveNameId,
		objectiveWorldLocation = Telemetry.Internal.VectorToTable(objectiveWorldLocation),
		PlayerLocations = Telemetry.Internal.GeneratePlayerLocations()
	});
end

function Telemetry.Internal.GeneratePlayerLocations(plr:player):table
	local playerLocations:table = {};

	if (plr ~= nil) then
		table.insert(playerLocations, {PlayerSpawnIndex = Player_GetUnit(plr), PlayerLocation = Telemetry.Internal.GetObjectLocation(plr)});
	else
		for _, p in ipairs(PLAYERS.active) do
			table.insert(playerLocations, {PlayerSpawnIndex = Player_GetUnit(p), PlayerLocation = Telemetry.Internal.GetObjectLocation(p)});
		end
	end
	return playerLocations;
end

--------------------------------------------------------------------
------------------------RESOURCE EVENTS-----------------------------
--------------------------------------------------------------------

--Enum to store valid reasons to close the radio for telemetry
Telemetry.Enums.RadioStatusReason = table.makeEnum
	{
		radioActivated = 0,
		supplyPurchasedByUser = 1,
		supplyRequestCancelledByUser = 2,
		radioDeactivatedByScript = 3,
		radioDeactivatedByDamage = 4,
	};

-- Enumeration to track reasons for supply drop (feel free to add more detailed enums)
Telemetry.Enums.SupplyReason = table.makeEnum
	{
		radio = 1,
		scripted = 2,
	};

-------------------------------------------------------------------------------
------------------------Radio Status Changed ----------------------------------
-------------------------------------------------------------------------------
-- Fire when the user brings up the radio UI
-- Fire whenever the radio UI is dismissed.
-- The return value is the ActivityIndex, which can be used to track subsequent
-- telemetry that should be associated (supply delivered, wallet deducted, etc.)
-------------------------------------------------------------------------------
function Telemetry.Resources.RadioStatusChanged(plr:player, statusReason:number)
	Telemetry.Assert(statusReason >= Telemetry.Enums.RadioStatusReason.radioActivated and 
		   statusReason <= Telemetry.Enums.RadioStatusReason.radioDeactivatedByScript, 
		   "Telemetry: Invalid status reason provided");

	local playerSpawnIndex:object = Player_GetUnit(plr);
	local activityIndex = Telemetry.Resources.ValidRadioActivityIndices[playerSpawnIndex];
	local isOpening:boolean = (statusReason == Telemetry.Enums.RadioStatusReason.radioActivated 
						and Telemetry.Resources.ValidRadioActivityIndices[playerSpawnIndex] == nil);
	local isClosing:boolean = (statusReason ~= Telemetry.Enums.RadioStatusReason.radioActivated 
						and Telemetry.Resources.ValidRadioActivityIndices[playerSpawnIndex] ~= nil);

	if (isOpening == true and isClosing == false) then
		--Get index for new radio activity series
		Telemetry.Resources.ValidRadioActivityIndices[playerSpawnIndex] = Telemetry.Internal.GetNewTelemetryIndex();
		activityIndex = Telemetry.Resources.ValidRadioActivityIndices[playerSpawnIndex];
	elseif (isOpening == false and isClosing == true) then
		Telemetry.Resources.ValidRadioActivityIndices[playerSpawnIndex] = nil;
	else
		Telemetry.Assert(false, "Telemetry:RadioStatusChanged: User already has active radio, or no active radio while deactivating");
	end
	
	--Fire the telemetry for a radio activated event
	FireTelemetryEvent("RadioStatusChanged", 
		{	
			ActivityIndex = activityIndex,
			RadioChangeStatusReason = statusReason,
			PlayerSpawnIndex = playerSpawnIndex,
			PlayerLocation = Telemetry.Internal.GetObjectLocation(plr)
		});

	return activityIndex;
end

-------------------------------------------------------------------------------
------------------------- Supply Delivered ------------------------------------
-------------------------------------------------------------------------------
-- Fire when a supply is dropped
-------------------------------------------------------------------------------
function Telemetry.Resources.SupplyDelivered(triggeringPlayer:player, supplyName:string, supplyObject:object, supplyReason:number, targetDropPosition:location, originatingActivityIndex:number)
	Telemetry.Assert(supplyReason >= Telemetry.Enums.SupplyReason.radio and 
		   supplyReason <= Telemetry.Enums.SupplyReason.scripted, 
		   "Telemetry:SupplyDelivered: Invalid supply reason provided");
		
		local supplyNameId = Telemetry_RegisterHashString(supplyName);

		FireTelemetryEvent("SupplyDelivered",
			{
				OriginatingActivityIndex = originatingActivityIndex,
				SupplyNameId = supplyNameId, 
				SupplyDescription = Telemetry_GetDescriptors(supplyObject),
				ReasonId = supplyReason,
				PlayerSpawnIndex = Player_GetUnit(triggeringPlayer),
				PlayerPosition = Telemetry.Internal.GetObjectLocation(triggeringPlayer),
				SupplyTargetPosition = Telemetry.Internal.GetObjectLocation(targetDropPosition)
			});
end

--------------------------------------------------------------------
-------------------------PROGRESSION EVENTS-------------------------
--------------------------------------------------------------------


-------------------------------------------------------------------------------
--               Persistent Player Profile Progress
-------------------------------------------------------------------------------
-------------------- Player Task Progressed -----------------------------------
-------------------------------------------------------------------------------
-- Use this to track progression over time towards a player goal (Feats?), 
-- such as ground-pounding N enemies.

-- Use MissionProgressed for campaign save-game progression that applies to all.

-- taskName: "Ground Pound Commendations"
-- completedSubTask: "Ground Pound Gold: 100 Enemies"
-- The return value is the ActivityIndex, which can be used to attribute rewards
-------------------------------------------------------------------------------
function Telemetry.Progression.PlayerTaskProgressed(taskNameId:telemetry_string, triggeringPlayer:player, 
											percentComplete:number, amount:number, 
											completedSubTaskId:telemetry_string)

	local activityIndex = Telemetry.Internal.GetNewTelemetryIndex();
	FireTelemetryEvent("PlayerTaskProgressed", {
		ActivityIndex = activityIndex,
		TaskNameId= taskNameId,
		TaskCompletionPct = percentComplete,
		CompletedSubTaskNameId = completedSubTaskId,
		Amount = amount,
		PlayerSpawnIndex = Player_GetUnit(triggeringPlayer),
		PlayerLocation = Telemetry.Internal.GetObjectLocation(triggeringPlayer),
	});

	return activityIndex;
end


-------------------------------------------------------------------------------
---------------------- Object Interaction -------------------------------------
-------------------------------------------------------------------------------
-- Use this to when an entity interacts with an object. This is the most base-
-- level interaction. AI, Bots, and Human Players can all trigger this.

-- The return value is the ActivityIndex, which can be used to attribute rewards
-------------------------------------------------------------------------------
function Telemetry.Progression.UnitObjectInteraction( unit:object, targetObject:object )

	--Get the index for the new chain
	local objectInteractionIndex = Telemetry.Internal.GetNewTelemetryIndex();
	local plr:player = Object_GetControllingOrContainingPlayer(unit);
	if (plr ~= nil) then
		Telemetry.Progression.PlayerObjectInteractionIndices[plr] = objectInteractionIndex;
	end

	--Fire the object interaction telemetry event
	FireTelemetryEvent("UnitObjectInteraction", 
		{	
			UnitSpawnIndex = Object_TryAndGetUnit(unit), 
			ActivityIndex = objectInteractionIndex,
			ObjectDescription = Telemetry_GetDescriptors(targetObject),
		});

	return objectInteractionIndex;
end

-------------------------------------------------------------------------------
---------------- Get Last Object Interaction Activity Index -------------------
--
-- The return value is the ActivityIndex, which can be used to attribute rewards
function Telemetry.Progression.GetLastObjectInteraction(plr:player)
	return Telemetry.Progression.PlayerObjectInteractionIndices[plr];
end


-------------------------------------------------------------------------------
------------------------ Object Pinged ----------------------------------------
-------------------------------------------------------------------------------
-- Use this to when a player uses spartan tracking and highlights an object.

-- The return value is the ActivityIndex, which can be used to attribute rewards
-------------------------------------------------------------------------------
function Telemetry.Progression.ObjectPinged( plr:player, targetObject:object )

	--Get the index for the new chain
	local objectInteractionIndex = Telemetry.Internal.GetNewTelemetryIndex();

	--Fire the object interaction telemetry event
	FireTelemetryEvent("ObjectPinged", 
		{	
			ActivityIndex = objectInteractionIndex,
			PlayerSpawnIndex = Player_GetUnit(plr),
			PlayerLocation = Telemetry.Internal.GetObjectLocation(plr),
			ObjectDescription = Telemetry_GetDescriptors(targetObject),
		});

	return objectInteractionIndex;
end

-------------------------------------------------------------------------------
------------------- Object Ownership Changed ----------------------------------
-------------------------------------------------------------------------------
-- Use this to when an object changes teams.

-- The return value is the ActivityIndex, which can be used to attribute rewards
-------------------------------------------------------------------------------
function Telemetry.Progression.ObjectOwnershipChanged( triggeringBiped:object, targetObject:object, oldTeamId:number, newTeamId:number )

	--Get the index for the new chain
	local objectInteractionIndex = Telemetry.Internal.GetNewTelemetryIndex();

	--Fire the object interaction telemetry event
	FireTelemetryEvent("ObjectOwnershipChange", 
		{	
			ActivityIndex = objectInteractionIndex,
			UnitSpawnIndex = Object_TryAndGetUnit(triggeringBiped), 
			OldTeamId = oldTeamId,
			NewTeamId = newTeamId,
			ObjectDescription = Telemetry_GetDescriptors(targetObject),
		});

	return objectInteractionIndex;
end


--## COMMON
--------------------------------------------------------------------
------------------------INTERNAL METHODS------------------------------
--------------------------------------------------------------------

-- function to create player location
function Telemetry.Internal.GetObjectLocation(plr:player):table
	local playerUnit = Player_GetUnit(plr);
	if playerUnit == nil or plr == nil then
		return {}; -- if the players nil/dead, its impossible to get the position.
	end
	return { x = object_get_x(plr), y = object_get_y(plr), z = object_get_z(plr) };
end

-- function to create player location
function Telemetry.Internal.VectorToTable(location:vector):table
	return { x = location.x, y = location.y, z = location.z };
end

--Function to give indexes for event chains, will be deprecated when we can get SequenceId from CELL
function Telemetry.Internal.GetNewTelemetryIndex()
	return Telemetry_GenerateActivityIndex();
end


--------------------------------------------------------------------
-----------------------BASE TELEMETRY EVENT-------------------------
--------------------------------------------------------------------
function FireTelemetryEvent(eventName:string, eventData:table)
	local jsonString:string = table.JSON(eventData);

	if ( eventName ~= "LUATrace" and Telemetry.Internal.ForceScriptedTelemetryPrint == true ) then 
		print(eventName .. "\r\n" .. jsonString );
	end

	FireScriptedTelemetryEvent("ScriptedEvent", eventName, jsonString);

end

