-- Copyright (c) Microsoft. All rights reserved.

--## SERVER

global waitTimer:number = 1;
global grenadeTypesHeld:number = 0;
global grenadeTipDisplayed:boolean = false;
global exploreTipDisplaySeconds:number = 5;
global exploreObjectDistance:number = 15;
global exploreLookDegrees:number = 45;

global followMessage:string = "training_follow";
global equipmentDeployMessage:string = "training_use_equipment";
global powerEquipmentDeployMessage:string = "training_use_power_equipment";
global grenadeThrowMessage:string = "training_grenade";
global exploreMessage:string = "training_pickups";
global liveFireMessage:string = "training_livefire";
global powerWeaponPickUpMessage:string = "academy_power_weapon_pickup";
global grenadePickUpMessage:string = "academy_grenade_pickup";
global equipmentPickUpMessage:string = "academy_equipment_pickup";
global powerUpPickUpMessage:string = "academy_power_up_pickup";
global weaponRackMessage:string = "academy_weapon_rack_pickup";

-- navpoint values
global exploreNavpoint:string = "callout_item";
global commanderNavpoint:string = "callout_location";
global exploreNavpointText:string = "academy_explore";
global pickupNavpointText:string = "academy_pickup";
global commanderNavpointText:string = "academy_commander";
global powerWeaponNavpointText:string = "academy_power_weapon";
global equipmentNavpointText:string = "academy_equipment";
global grenadeNavpointText:string = "academy_grenade";
global powerUpNavpointText:string = "academy_power_up";
global weaponRackNavpointText:string = "academy_weapon_rack";
global commanderLiveFireNavpoint:navpoint = nil;

-- list of sandbox items

global weaponContainerTable:table = {};
global grenadePadTable:table = {};
global equipmentPadTable:table = {};
global powerWeaponPadTable:table = {};
global powerUpPadTable:table = {};

-- bots for live fire
global enemyBot1:player = nil;
global enemyBot2:player = nil;
global enemyBot3:player = nil;
global enemyBot4:player = nil;
global friendlyBot1:player = nil;
global friendlyBot2:player = nil;
global friendlyBotCommander:player = nil;

-- threads for sandbox item instruction
global grenadeInstruction:thread = nil;

--variable to determine how long we display instruction banners
global instructionBannerDisplayTime:number = 8;

--invisible collision for the commander puppet
global liveFireIdleCollisionObject = nil;

function SetPlayerStartSettings()
	--Add any modifications we want to make to the player's loadout or HUD here
end

function academyLiveFireRun()
	SetPlayerStartSettings();
	CreateThread(Tutorial_CombatExerciseIntroThread);
	InitTables();
end

function Tutorial_CombatExerciseIntroThread()
	RegisterGlobalEvent(g_eventTypes.deathEvent, HandleExplorationDeath);
	RegisterGlobalEvent(g_eventTypes.playerSpawnEvent, HandleExplorationPlayerSpawn);
	CreateThread(CleanUpArmoryThread);
	CreateCommanderSquad();
	NarrativeInterface.SleepUntil.PlayNarrativeSequence("INTERLOCK_INTRO");
	SleepUntil([|cleanupComplete == true], 1);
	CreateInstructionTimer();
	AssignSandboxItemTables();
	currentActivity = FindEquipmentActivity;
	CreateThread(currentActivity.Thread);
	CreateThread(LiveFireMetaStateTracker);
	CreateThread(RepeatActivityInstruction);
end

global cleanupComplete:boolean = false;
-- delete the unneeded weapon lockers and other objects in the armory
function CleanUpArmoryThread()
	repeat
		local armoryObjects:object_list = volume_return_objects(VOLUMES.armory_cleanup_volume);
		local objectsRemaining = #armoryObjects;
		for _, object in hpairs (armoryObjects) do
			Object_Delete(object);
		end
		Sleep(1);
	until objectsRemaining == 0;
	cleanupComplete = true;
end

function HandleExplorationDeath(deathEvent:DeathEventStruct):void
	if deathEvent.deadPlayer == PLAYERS.player0 then
		CreateThread(ApplyExplorationLoadoutThread);
	end
end

function HandleExplorationPlayerSpawn(playerSpawnEvent:PlayerSpawnEventStruct):void
	local spawningPlayer = playerSpawnEvent.player;
	if spawningPlayer == PLAYERS.player0 then
		PlayerControlFadeInAllInputForPlayer(spawningPlayer, 0);
	end
end

function ApplyExplorationLoadoutThread()
	local explorationPrimary = Object_CreateFromTag(WeaponTags.assault_rifle);
	SleepUntil([|Player_GetUnit(PLAYERS.player0) ~= nil], 1);
	local playerUnit = Player_GetUnit(PLAYERS.player0);
	Unit_GiveWeapon(playerUnit, explorationPrimary, WEAPON_ADDITION_METHOD.PrimaryWeapon);
end

global FindEquipmentActivity:table = {};
global PickUpEquipmentActivity:table = {};
global DeployEquipmentActivity:table = {};
global FindWeaponActivity:table = {};
global PickUpWeaponActivity:table = {};
global FindPowerWeaponActivity:table = {};
global PickUpPowerWeaponActivity:table = {};
global FindPowerEquipmentActivity:table = {};
global PickUpPowerEquipmentActivity:table = {};

global currentActivity:table = nil;
global currentActivityThread:thread = nil;

global onMapExplorationComplete:boolean = false;
global instructionTimer:timer = nil;
global instructionDisplayTimeoutSeconds:number = 30;
global lastInstructionTime = 0;

function InitTables()

	--initialize FindEquipmentActivity
	FindEquipmentActivity.Navpoint = nil;
	FindEquipmentActivity.Thread = FindEquipmentThread;
	FindEquipmentActivity.PreviousCondition = nil;
	FindEquipmentActivity.Previous = nil;
	FindEquipmentActivity.NextCondition = ShouldRunPickupEquipmentThread;
	FindEquipmentActivity.Next = PickUpEquipmentActivity;

	--initialize PickUpEquipmentActivity
	PickUpEquipmentActivity.Navpoint = nil;
	PickUpEquipmentActivity.Thread = PickUpEquipmentThread;
	PickUpEquipmentActivity.PreviousCondition = ShouldRunFindEquipmentThread;
	PickUpEquipmentActivity.Previous = FindEquipmentActivity;
	PickUpEquipmentActivity.NextCondition = ShouldRunFindWeaponThread;
	PickUpEquipmentActivity.Next = FindWeaponActivity;

	--initialize FindWeaponActivity
	FindWeaponActivity.Navpoint = nil;
	FindWeaponActivity.Thread = FindWeaponThread;
	FindWeaponActivity.PreviousCondition = nil;
	FindWeaponActivity.Previous = nil;
	FindWeaponActivity.NextCondition = ShouldRunPickUpWeaponThread;
	FindWeaponActivity.Next = PickUpWeaponActivity;

	--initialize PickUpWeaponActivity
	PickUpWeaponActivity.Navpoint = nil;
	PickUpWeaponActivity.Thread = PickUpWeaponThread;
	PickUpWeaponActivity.PreviousCondition = ShouldRunFindWeaponThread;
	PickUpWeaponActivity.Previous = FindWeaponActivity;
	PickUpWeaponActivity.NextCondition = ShouldRunFindPowerWeaponThread;
	PickUpWeaponActivity.Next = FindPowerWeaponActivity;

	--initialize FindPowerWeaponActivity
	FindPowerWeaponActivity.Navpoint = nil;
	FindPowerWeaponActivity.Thread = FindPowerWeaponThread;
	FindPowerWeaponActivity.PreviousCondition = nil;
	FindPowerWeaponActivity.Previous = nil;
	FindPowerWeaponActivity.NextCondition = ShouldRunPickUpPowerWeapon;
	FindPowerWeaponActivity.Next = PickUpPowerWeaponActivity;

	--initialize PickUpPowerWeaponActivity
	PickUpPowerWeaponActivity.Navpoint = nil;
	PickUpPowerWeaponActivity.Thread = PickUpPowerWeaponThread;
	PickUpPowerWeaponActivity.PreviousCondition = ShouldRunFindPowerWeaponThread;
	PickUpPowerWeaponActivity.Previous = FindPowerWeaponActivity;
	PickUpPowerWeaponActivity.NextCondition = ShouldRunFindPowerEquipment;
	PickUpPowerWeaponActivity.Next = FindPowerEquipmentActivity;

	--initialize FindPowerEquipmentActivity
	FindPowerEquipmentActivity.Navpoint = nil;
	FindPowerEquipmentActivity.Thread = FindPowerEquipmentThread;
	FindPowerEquipmentActivity.PreviousCondition = nil;
	FindPowerEquipmentActivity.Previous = nil;
	FindPowerEquipmentActivity.NextCondition = ShouldRunPickUpPowerEquipment;
	FindPowerEquipmentActivity.Next = PickUpPowerEquipmentActivity;

	--initialize PickUpPowerEquipmentActivity
	PickUpPowerEquipmentActivity.Navpoint = nil;
	PickUpPowerEquipmentActivity.Thread = PickUpPowerEquipmentThread;
	PickUpPowerEquipmentActivity.PreviousCondition = ShouldRunFindPowerEquipment;
	PickUpPowerEquipmentActivity.Previous = FindPowerEquipmentActivity;
	PickUpPowerEquipmentActivity.NextCondition = nil;
	PickUpPowerEquipmentActivity.Next = nil;

	--register the event that will tell you if we picked something up
	RegisterGlobalEventOnce(g_eventTypes.equipmentPickupEvent, HandlePlayerEquipmentPickup);
end

function LiveFireMetaStateTracker()
    repeat
		if currentActivity.NextCondition ~= nil and currentActivity.NextCondition() then
			KillThread(currentActivity.Thread);
			ShutdownCurrentActivity();
			CreateThread(currentActivity.Next.Thread);
			currentActivity = currentActivity.Next;
		elseif currentActivity.PreviousCondition ~= nil and currentActivity.PreviousCondition() then
			KillThread(currentActivity.Thread);
			ShutdownCurrentActivity();
			CreateThread(currentActivity.Previous.Thread);
			currentActivity = currentActivity.Previous;
		end
	Sleep(1);
	until onMapExplorationComplete == true;
end

function ShutdownCurrentActivity()
	--delete any remaining navpoints
	if currentActivity.Navpoint ~= nil then
		Navpoint_Delete(currentActivity.Navpoint);
	end
	--clear any banners
	DisableObjectiveMessage();
end

function CreateInstructionTimer()
	instructionTimer = Engine_CreateTimer();
	Timer_StartWithRate(instructionTimer, -1.0);
end

function RepeatActivityInstruction()
	
	SleepUntil([| instructionTimer ~= nil], 1);

	repeat
		if Timer_GetSecondsLeft(instructionTimer) >= (lastInstructionTime + instructionDisplayTimeoutSeconds) then
			--clear the current activity so we don't stack navpoints and banners
			ShutdownCurrentActivity();
			CreateThread(currentActivity.Thread);
		end
	SleepSeconds(1);
	until onMapExplorationComplete == true;
end

function ShouldRunFindEquipmentThread()
	
	local closestEquipment = FindClosestItemOfTableType(equipmentPadTable);

    if Object_GetDistanceSquaredToObject(closestEquipment, PLAYERS.player0) >= exploreObjectDistance then
        return true;
	end
    
    return false;
end

function FindEquipmentThread()
	lastInstructionTime = Timer_GetSecondsLeft(instructionTimer);
	TutorialQuickTipHandler(PLAYERS.player0, "academy_tip_scan_title", "academy_tip_scan", instructionBannerDisplayTime);
	CreateAndShowObjectiveMessage(findEquipmentMessage);
	local closestEquipment = FindClosestItemOfTableType(equipmentPadTable);
	FindEquipmentActivity.Navpoint = CreateLiveFireObjectNavpoint(closestEquipment, commanderNavpoint, nil);
	Navpoint_SetPositionOffset(FindEquipmentActivity.Navpoint, vector(0,0,0.5));
	SleepSeconds(instructionBannerDisplayTime);
	DisableObjectiveMessage();
	Navpoint_Delete(FindEquipmentActivity.Navpoint);
end

function ShouldRunPickupEquipmentThread()
	
	local closestEquipment = FindClosestItemOfTableType(equipmentPadTable);

    if Object_GetDistanceSquaredToObject(closestEquipment, PLAYERS.player0) <= exploreObjectDistance and objects_can_see_object(PLAYERS.player0, closestEquipment, 45) == true then
        return true;
	end
    
    return false;
end

global playedEquipmentVO:boolean = false;
function PickUpEquipmentThread()
	lastInstructionTime = Timer_GetSecondsLeft(instructionTimer);
	local closestEquipment = FindClosestItemOfTableType(equipmentPadTable);
	PickUpEquipmentActivity.Navpoint = CreateLiveFireObjectNavpoint(closestEquipment, exploreNavpoint, pickupNavpointText);
	Navpoint_SetPositionOffset(PickUpEquipmentActivity.Navpoint, vector(0,0,0.5));
	if playedEquipmentVO == false then
		playedEquipmentVO = true;
	end
	SleepSeconds(instructionBannerDisplayTime);
	DisableObjectiveMessage();
end

global playerPickedUpEquipment:boolean = false;

function HandlePlayerEquipmentPickup()
	playerPickedUpEquipment = true;
	
	CreateThread(PlayerEquipmentPickupScripts);
end

function PlayerEquipmentPickupScripts()
	Tutorial_DismissibleDialogueEvent("MULTIPLAYER_EQUIPMENT_TITLE", "MULTIPLAYER_EQUIPMENT_TEXT");
	NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_training_facility_equipment_1");
	TutorialQuickTipHandler(PLAYERS.player0, "academy_tip_equipment_title", "academy_tip_equipment", exploreTipDisplaySeconds);
end

function ShouldRunFindWeaponThread()
	local closestWeapon = FindClosestItemOfTableType(weaponContainerTable);

	--if we haven't picked up equipment yet, we shouldn't be looking for a weapon
	if playerPickedUpEquipment == false then
		return false;
	end

    if Object_GetDistanceSquaredToObject(closestWeapon, PLAYERS.player0) >= exploreObjectDistance then
        return true;
	end
    
    return false;
end

function FindWeaponThread()
	lastInstructionTime = Timer_GetSecondsLeft(instructionTimer);
	TutorialQuickTipHandler(PLAYERS.player0, "academy_tip_scan_title", "academy_tip_scan", instructionBannerDisplayTime);
	local closestWeapon = FindClosestItemOfTableType(weaponContainerTable);
	FindWeaponActivity.Navpoint = CreateLiveFireObjectNavpoint(closestWeapon, commanderNavpoint, nil);
	Navpoint_SetPositionOffset(FindWeaponActivity.Navpoint, vector(0,0,0.25));
	CreateAndShowObjectiveMessage(findWeaponMessage);
	SleepSeconds(instructionBannerDisplayTime);
	DisableObjectiveMessage();
	Navpoint_Delete(FindWeaponActivity.Navpoint);
end

function ShouldRunPickUpWeaponThread()
	local closestWeapon = FindClosestItemOfTableType(weaponContainerTable);

    if Object_GetDistanceSquaredToObject(closestWeapon, PLAYERS.player0) <= exploreObjectDistance and objects_can_see_object(PLAYERS.player0, closestWeapon, 45) == true then
        return true;
	end
    
    return false;
end

global playedWeaponRackVO:boolean = false;
function PickUpWeaponThread()
	lastInstructionTime = Timer_GetSecondsLeft(instructionTimer);
	local closestWeapon = FindClosestItemOfTableType(weaponContainerTable);
	CreateAndShowObjectiveMessage(weaponRackMessage);
	PickUpWeaponActivity.Navpoint = CreateLiveFireObjectNavpoint(closestWeapon, exploreNavpoint, pickupNavpointText);
	Navpoint_SetPositionOffset(PickUpWeaponActivity.Navpoint, vector(0,0,0.25));
	if playedWeaponRackVO == false then
		playedWeaponRackVO = true;
		RegisterGlobalEventOnce(g_eventTypes.weaponPickupEvent, HandlePlayerWeaponPickup);
	end
	SleepSeconds(instructionBannerDisplayTime);
	DisableObjectiveMessage();
end

global playerPickedUpWeapon:boolean = false;
function HandlePlayerWeaponPickup()
	playerPickedUpWeapon = true;
	
	CreateThread(PlayerWeaponPickupScripts);
end

function PlayerWeaponPickupScripts()
	Tutorial_DismissibleDialogueEvent("MULTIPLAYER_ITEM_SPAWNER_TITLE", "MULTIPLAYER_ITEM_SPAWNER_TEXT");
	NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_training_facility_weapon_container_1");
	TutorialQuickTipHandler(PLAYERS.player0, "academy_tip_weapon_racks_title", "academy_tip_weapon_racks", tutorialTipDisplaySeconds);
end

function ShouldRunFindPowerWeaponThread()

	local closestPowerWeapon = FindClosestItemOfTableType(powerWeaponPadTable);

	--if the player hasn't already picked up a regular weapon, we shouldn't be looking for power weapons yet
	if playerPickedUpWeapon == false then
		return false;
	end

	if Object_GetDistanceSquaredToObject(closestPowerWeapon, PLAYERS.player0) >= exploreObjectDistance then
        return true;
	end
    
    return false;
end

function FindPowerWeaponThread()
	lastInstructionTime = Timer_GetSecondsLeft(instructionTimer);
	TutorialQuickTipHandler(PLAYERS.player0, "academy_tip_scan_title", "academy_tip_scan", instructionBannerDisplayTime);
	local closestPowerWeapon = FindClosestItemOfTableType(powerWeaponPadTable);
	FindPowerWeaponActivity.Navpoint = CreateLiveFireObjectNavpoint(closestPowerWeapon, commanderNavpoint, nil);
	Navpoint_SetPositionOffset(FindPowerWeaponActivity.Navpoint, vector(0,0,0.5));
	CreateAndShowObjectiveMessage(findPowerWeaponMessage);
	SleepSeconds(instructionBannerDisplayTime);
	DisableObjectiveMessage();
	Navpoint_Delete(FindPowerWeaponActivity.Navpoint);
end

function ShouldRunPickUpPowerWeapon()
	local closestPowerWeapon = FindClosestItemOfTableType(powerWeaponPadTable);

    if Object_GetDistanceSquaredToObject(closestPowerWeapon, PLAYERS.player0) <= exploreObjectDistance and objects_can_see_object(PLAYERS.player0, closestPowerWeapon, 45) == true then
        return true;
	end
    
    return false;
end

global playedPowerWeaponVO:boolean = false;
function PickUpPowerWeaponThread()
	lastInstructionTime = Timer_GetSecondsLeft(instructionTimer);
	local closestPowerWeapon = FindClosestItemOfTableType(powerWeaponPadTable);
	CreateAndShowObjectiveMessage(powerWeaponPickUpMessage);
	PickUpPowerWeaponActivity.Navpoint = CreateLiveFireObjectNavpoint(closestPowerWeapon, exploreNavpoint, pickupNavpointText);
	Navpoint_SetPositionOffset(PickUpPowerWeaponActivity.Navpoint, vector(0,0,0.5));
	if playedPowerWeaponVO == false then
		playedPowerWeaponVO = true;
		RegisterGlobalEventOnce(g_eventTypes.weaponPickupEvent, HandlePlayerPickedUpPowerWeapon);
	end
	SleepSeconds(instructionBannerDisplayTime);
	DisableObjectiveMessage();
end

global playerPickedUpPowerWeapon:boolean = false;

function HandlePlayerPickedUpPowerWeapon()
	playerPickedUpPowerWeapon = true;

	CreateThread(PlayerPowerWeaponPickupScripts);
end

function PlayerPowerWeaponPickupScripts()
	Tutorial_DismissibleDialogueEvent("MULTIPLAYER_POWER_WEAPON_TITLE", "MULTIPLAYER_POWER_WEAPON_TEXT");
	TutorialQuickTipHandler(PLAYERS.player0, "academy_tip_power_weapon_title", "academy_tip_power_weapon", exploreTipDisplaySeconds);
	NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_training_facility_power_weapons_1");
end

function ShouldRunFindPowerEquipment()

	local closestPowerEquipment = FindClosestItemOfTableType(powerUpPadTable);
	
	--we should not search for power equipment until we've picked up a power weapon
	if playerPickedUpPowerWeapon == false then
		return false;
	end
	
	if Object_GetDistanceSquaredToObject(closestPowerEquipment, PLAYERS.player0) >= exploreObjectDistance then
		return true;
	end
    
    return false;
end

function FindPowerEquipmentThread()
	lastInstructionTime = Timer_GetSecondsLeft(instructionTimer);
	TutorialQuickTipHandler(PLAYERS.player0, "academy_tip_scan_title", "academy_tip_scan", instructionBannerDisplayTime);
	local closestPowerEquipment = FindClosestItemOfTableType(powerUpPadTable);
	FindPowerEquipmentActivity.Navpoint = CreateLiveFireObjectNavpoint(closestPowerEquipment, commanderNavpoint, nil);
	Navpoint_SetPositionOffset(PickUpPowerEquipmentActivity.Navpoint, vector(0,0,0.5));
	CreateAndShowObjectiveMessage(findPowerEquipmentMessage);
	SleepSeconds(instructionBannerDisplayTime);
	DisableObjectiveMessage();
	Navpoint_Delete(FindPowerEquipmentActivity.Navpoint);
end

function ShouldRunPickUpPowerEquipment()
	local closestPowerEquipment = FindClosestItemOfTableType(powerUpPadTable);

    if Object_GetDistanceSquaredToObject(closestPowerEquipment, PLAYERS.player0) <= exploreObjectDistance and objects_can_see_object(PLAYERS.player0, closestPowerEquipment, 45) == true then
        return true;
	end
    
    return false;
end

global playedPowerEquipmentVO:boolean = false;

function PickUpPowerEquipmentThread()
	lastInstructionTime = Timer_GetSecondsLeft(instructionTimer);
	local closestPowerEquipment = FindClosestItemOfTableType(powerUpPadTable);
	CreateAndShowObjectiveMessage(powerUpPickUpMessage);
	PickUpPowerEquipmentActivity.Navpoint = CreateLiveFireObjectNavpoint(closestPowerEquipment, exploreNavpoint, pickupNavpointText);
	Navpoint_SetPositionOffset(PickUpPowerEquipmentActivity.Navpoint, vector(0,0,0.5));
	if playedPowerEquipmentVO == false then
		playedPowerEquipmentVO = true;
		RegisterGlobalEventOnce(g_eventTypes.equipmentPickupEvent, HandlePlayerPickedUpPowerEquipment);		
	end
	SleepSeconds(instructionBannerDisplayTime);
	DisableObjectiveMessage();
end

function HandlePlayerPickedUpPowerEquipment()
	onMapExplorationComplete = true;

	CreateThread(PlayerPowerEquipmentPickupScripts);	
end

function PlayerPowerEquipmentPickupScripts()
	Tutorial_DismissibleDialogueEvent("MULTIPLAYER_POWER_EQUIPMENT_TITLE", "MULTIPLAYER_POWER_EQUIPMENT_TEXT");
	NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_training_facility_powerups_1");
	TutorialQuickTipHandler(PLAYERS.player0, "academy_tip_power_equipment_title", "academy_tip_power_equipment", exploreTipDisplaySeconds);
	CreateThread(SetCommanderPrimaryObjective);
end

function AssignSandboxItemTables()

	local getAllWeaponPlacementsFunc = _G["GetAllWeaponPlacements"];
	local getAllWeaponPlacementsOfTierFunc = _G["GetAllWeaponPlacementsOfTier"];
	local getAllEquipmentPlacementsOfClassFunc = _G["GetAllEquipmentPlacementsOfClass"];
	
	for _, kits in hpairs(KITS.active) do
		-- check and see if the kit you found in kits.active has a component and a container -- if so, we know it's a weapon
		if kits.components ~= nil and kits.components.container ~= nil then
			kits:StartPlacementParcel();
		-- check for a component and a spawner -- if so, we know that it's an item spawner
		elseif kits.components ~= nil and kits.components.spawner ~= nil then
			kits:StartPlacementParcel();
		end
	end

	--Assuming that if GetAllWeaponPlacements is defined, the other functions should be as well
	if (getAllWeaponPlacementsFunc ~= nil) then
		weaponContainerTable = getAllWeaponPlacementsFunc();

		if (getAllWeaponPlacementsOfTierFunc ~= nil) then
			powerWeaponPadTable = getAllWeaponPlacementsOfTierFunc(MP_WEAPON_TIER.Power);

			--remove any power weapons from the weapon list, we'll track these separately
			for i = #weaponContainerTable, 1, -1 do
				if (table.contains(powerWeaponPadTable, weaponContainerTable[i])) then
					table.remove(weaponContainerTable, i);
				end
			end
		end

		grenadePadTable = getAllEquipmentPlacementsOfClassFunc(MP_EQUIPMENT_CLASS.Grenade);
		equipmentPadTable = getAllEquipmentPlacementsOfClassFunc(MP_EQUIPMENT_CLASS.Equipment);
		powerUpPadTable = getAllEquipmentPlacementsOfClassFunc(MP_EQUIPMENT_CLASS.PowerUp);
	end
end

function FindClosestItemOfTableType(placementTable:table)

	local closestObject = nil;
	local bestDistance = math.huge;

	if placementTable ~= nil then

		for _, objectPlacement in ipairs(placementTable) do

			--check to see if the object is valid (not a negative distance from the player) and closer than the value we have stored off as the best distance
			if Object_GetDistanceSquaredToObject(objectPlacement.containerObject, PLAYERS.player0) >= 0 and Object_GetDistanceSquaredToObject(objectPlacement.containerObject, PLAYERS.player0) < bestDistance then

				--if so, this is now the closest object and its distance is the best distance
				closestObject = objectPlacement.containerObject;
				bestDistance = Object_GetDistanceSquaredToObject(objectPlacement.containerObject, PLAYERS.player0);

			end
		end
	end

	return closestObject;
end

global findEquipmentMessage:string = "training_equipment";
global findWeaponMessage:string = "training_weapon_container";
global findPowerWeaponMessage:string = "training_power_weapon";
global findPowerEquipmentMessage:string = "training_power_equipment";
global combatExerciseObjectiveMessage:string = "training_combat_exercise";

function MonitorGrenadePickups(eventArgs:GrenadePickupEventStruct):void
	CreateThread(MonitorGrenadeCompliment, eventArgs.grenadeType);
end

function MonitorGrenadeCompliment(grenadeType):void
	SleepUntil([| Unit_GetGrenadeCount(PLAYERS.player0, grenadeType) > 0], 1);
	local grenadeTypes = {GRENADE_TYPE.FRAG,
						GRENADE_TYPE.LIGHTNING,
						GRENADE_TYPE.PLASMA,
						GRENADE_TYPE.SAPPER,
						GRENADE_TYPE.SPIKE,
						GRENADE_TYPE.STASIS};

	for _, grenade in hpairs(grenadeTypes) do
		if(Unit_GetGrenadeCount(PLAYERS.player0, grenade) > 0) then
			grenadeTypesHeld = grenadeTypesHeld + 1;
		end
	end

	if(grenadeTypesHeld >= 2) and (grenadeTipDisplayed == false) then
		TutorialQuickTipHandler(PLAYERS.player0, "academy_tip_grenade_switch_title", "academy_tip_grenade_switch", exploreTipDisplaySeconds);
		grenadeTipDisplayed = true;
		UnregisterGlobalEvent(g_eventTypes.grenadePickupEvent, MonitorGrenadePickups);
	end
	grenadeTypesHeld = 0;
end

function CreateCommanderSquad()
	liveFireIdleCollisionObject = object_create("commander_livefire_idle_collision");
	Device_SetPrimaryActionStringOverride(OBJECTS.tutorial_combat_start_control, "tutorial_early_start_combat");
	Device_SetPower(OBJECTS.tutorial_combat_start_control, 1);
	Device_SetInteractionHoldTime(OBJECTS.tutorial_combat_start_control, 1);
	RegisterEvent(g_eventTypes.objectInteractEvent, TutorialCombatStartInteract, OBJECTS.tutorial_combat_start_control);
	NarrativeInterface.PlayNarrativeSequence("TUTORIAL_LIVEFIRE_SPARTANS_PREPARE");
end

function TutorialCombatStartInteract()
	--shutdown any remaining exploration threads
	ShutdownCurrentActivity();
	onMapExplorationComplete = true;
	playerReachedLiveFire = true;

	--unregister all exploration events in case the player has gone straight to the Commander without any exploration
	UnregisterGlobalEvent(g_eventTypes.equipmentPickupEvent, HandlePlayerEquipmentPickup);
	UnregisterGlobalEvent(g_eventTypes.weaponPickupEvent, HandlePlayerWeaponPickup);
	UnregisterGlobalEvent(g_eventTypes.weaponPickupEvent, HandlePlayerPickedUpPowerWeapon);
	UnregisterGlobalEvent(g_eventTypes.equipmentPickupEvent, HandlePlayerPickedUpPowerEquipment);

	--stop the device control from being interacted with again
	Unit_EmptyAmmo(PLAYERS.player0);
	Unit_EmptyGrenadeInventory(PLAYERS.player0);
	Device_SetPower(OBJECTS.tutorial_combat_start_control, 0);
	UnregisterEvent(g_eventTypes.objectInteractEvent, TutorialCombatStartInteract, OBJECTS.tutorial_combat_start_control);
	Navpoint_Delete(commanderLiveFireNavpoint);
	DisableObjectiveMessage();
	CreateThread(LiveFireTutorial);
end

global playerReachedLiveFire:boolean = false;
global commanderShowId:number = 0;

function SetCommanderPrimaryObjective()
	--clean any navpoints left over from previous threads we've killed
	Navpoint_DeleteAll();
	commanderShowId = ComposerGetShowId("nar_mp_academy_crowd_spartans_sergeant");
	local commanderObject:object = composer_get_puppet_from_show("storm_masterchief", commanderShowId);
	commanderLiveFireNavpoint = CreateLiveFireObjectNavpoint(commanderObject, commanderNavpoint, commanderNavpointText);
	Navpoint_SetColor(commanderLiveFireNavpoint, color_rgba(0,1,0,1));
	Navpoint_SetPositionOffset(commanderLiveFireNavpoint, vector(0,0,0.1));
	--sleep slightly to keep the VO from playing over the dismissable dialogue prompt from the previous activity
	SleepSeconds(0.5);
	NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_training_facility_commander_pickup_1_alt");
	CreateThread(LiveFireReminderVOThread);
	CreateAndShowObjectiveMessage(liveFireMessage);
	--turn off the messaging to go to the commander once the player has interacted with the device control
	SleepUntil ([| playerReachedLiveFire == true], 1);
	Navpoint_Delete(commanderLiveFireNavpoint);
	DisableObjectiveMessage();
end

function LiveFireReminderVOThread()
	SleepSeconds(tutorialPromptDelaySeconds); -- defined in sgh_interlock_tutorial_facility.lua
	if playerReachedLiveFire == false then
		NarrativeInterface.SleepUntil.PlayNarrativeSequence("mpacademynarrative_academy_training_facility_commander_pickup_1");
	end
end

function CleanUpLiveFireAnimations()
	-- all composer show variables defined in sgh_interlock_tutorial_composition_narrative.lua
	if spartans_prep_group_show ~= nil and composer_show_is_playing(spartans_prep_group_show) then
		composer_stop_show(spartans_prep_group_show);
		DeactivateKitHandleAsync(spartans_prep_group_show_kit);
	end
	if spartans_prep_one_show ~= nil and composer_show_is_playing(spartans_prep_one_show) then
		composer_stop_show(spartans_prep_one_show);
		DeactivateKitHandleAsync(spartans_prep_one_show_kit);
	end
	if live_fire_commander_idle_show ~= nil and composer_show_is_playing(live_fire_commander_idle_show) then
		composer_stop_show(live_fire_commander_idle_show);
		DeactivateKitHandleAsync(live_fire_commander_idle_show_kit);
	end

	--delete the invisible collision object around the commander puppet
	Object_Delete(liveFireIdleCollisionObject);
end

function CreateLiveFireBots()
	friendlyBotCommander = Bot_AddWithTeam(Player_GetMultiplayerTeam(PLAYERS.player0));
	CreateThread(ApplyVariantThread, friendlyBotCommander, "drill_sergeant");
	Bot_SetName(friendlyBotCommander, "Spartan Agryna");
	friendlyBot1 = Bot_AddWithTeam(Player_GetMultiplayerTeam(PLAYERS.player0));
	CreateThread(ApplyVariantThread, friendlyBot1, "multi_tutorial_001");
	Bot_SetName(friendlyBot1, "Spartan Ionescu");
	friendlyBot2 = Bot_AddWithTeam(Player_GetMultiplayerTeam(PLAYERS.player0));
	CreateThread(ApplyVariantThread, friendlyBot2, "multi_tutorial_002");
	Bot_SetName(friendlyBot2, "Spartan Page");
	enemyBot1 = Bot_AddWithTeam(MP_TEAM.mp_team_blue);
	CreateThread(ApplyVariantThread, enemyBot1, "multi_tutorial_003");
	Bot_SetName(enemyBot1, "Spartan Leung");
	enemyBot2 = Bot_AddWithTeam(MP_TEAM.mp_team_blue);
	CreateThread(ApplyVariantThread, enemyBot2, "multi_tutorial_004");
	Bot_SetName(enemyBot2, "Spartan O'Brien");
	enemyBot3 = Bot_AddWithTeam(MP_TEAM.mp_team_blue);
	Bot_SetName(enemyBot3, "Spartan Denning");
	enemyBot4 = Bot_AddWithTeam(MP_TEAM.mp_team_blue);
	Bot_SetName(enemyBot4, "Spartan Eusebio");
end

function ApplyVariantThread(bot, variantName)
	SleepUntil([|Player_GetUnit(bot) ~= nil], 1);
	object_set_variant(bot, variantName);
end

function LiveFireTutorial()
	-- we've started the combat exercise, so fire a telemetry event that the mission should progress
	Tutorial_UpdateMissionProgress("Multiplayer_Tutorial_BotMatch"); -- defined in sgh_interlock_facility.lua

	-- close the door to the facility to prevent backtracking
	Device_SetDesiredPosition(OBJECTS.unsc_wall_ext_concrete_doorway_door_h18_w32_d04_a__dm, 0);

	-- Disable player input, lower weapon, and go to 3rd person perspective during Commander dialogue
	PlayerControlFadeOutAllInputForPlayer(PLAYERS.player0);
	PlayersWeaponsDown(0.4, true);
	RunClientScript("GoToThirdPerson", PLAYERS.player0, OBJECTS.tutorial_combat_start_control);	-- TO-DO: This object needs to be the Commander herself and not the device control

	NarrativeInterface.SleepUntil.PlayNarrativeSequence("mpacademynarrative_academy_bots_welcome_1_alt");
	NarrativeInterface.SleepUntil.PlayNarrativeSequence("mpacademynarrative_academy_bots_welcome_2");
	MPLuaCall("__OnBotCombatStart");

	--fade out the player
	Composer_FadeOut(0,0,0,1);
	
	-- remove deathless from the player now that we're in the combat exercise
	object_cannot_die_except_kill_volumes(PLAYERS.player0, false);

	SleepSeconds(1);
	CleanUpLiveFireAnimations();
	RunClientScript("ReturnToFirstPerson", PLAYERS.player0);
	PlayersWeaponsDown(0.1, false);
	
	ai_erase_all();
	KillThread(SuspendTimerThreadIndex);
	CreateLiveFireBots();

	--Force set bots to idle for the round transition
	Bot_SetForceIdleBehavior(true);

	SleepSeconds(1);
	Engine_EndRound();
	SleepUntil ([|Engine_IsRoundTimerRunning() == true, 1]);
	PlayerControlFadeOutAllInputForPlayer(PLAYERS.player0);
	SleepSeconds(1);
	CreateThread(HandleLiveFireRoundStartThread);
end

function DisplayLiveFireObjectiveThread()
	CreateAndShowObjectiveMessage(combatExerciseObjectiveMessage);
	SleepSeconds(5);
	DisableObjectiveMessage();
end

function HandleLiveFireRoundStartThread()
	--begin round intro music 
	CreateThread(PlayCombatEndingMusicThread);

	--start the slayer parcel to handle scoring and display the slayer scoreboard
	TutorialSlayerStart(); 
	RunClientScript("SendUIEvent_Client", "mini_scoreboard_slayer_show");

	RunClientScript("RoundTransitionCamera", PLAYERS.player0);
	--sleep for the regroup intro fade in time, then fade in 
	SleepSeconds(1);
	Composer_FadeIn(0,0,0,1);
	--sleep to allow the round transition camera to complete
	SleepSeconds(2.5);
	RunClientScript("ReturnToFirstPerson", PLAYERS.player0);
	SleepSeconds(0.5);

	-- fix in case a players hurts a friendly composition puppet just before the live fire exercise.
	PlayerControlFadeInAllInputForPlayer(PLAYERS.player0, 0);

	--Camera sequence is complete, bots may go about their business
	Bot_SetForceIdleBehavior(false);

	--create threads for radar instruction
	CreateThread(DisplayLiveFireObjectiveThread);
	CreateThread(RadarInstructionThread);
	CreateThread(LiveFireEndWatcher);
end

global TutorialSlayerParcelInstance = nil;

function TutorialSlayerStart():void
	local slayerArgs:SlayerInitArgs = GlobalModeInitData.Slayer.DefaultArgs;

	local slayerParcel:table = _G["SlayerParcel"];
	if (slayerParcel ~= nil) then
		-- Start the Slayer parcel
		TutorialSlayerParcelInstance = slayerParcel:New(slayerArgs);
		ParcelAddAndStart(TutorialSlayerParcelInstance, slayerArgs.instanceName or "Slayer");
	end
end

function RadarInstructionThread()
	--sleep for VO and instruction timing 
	SleepSeconds(3);
	hud_show_radar(true);

	Tutorial_DismissibleDialogueEvent("MULTIPLAYER_MOTION_TRACKER_TITLE", "MULTIPLAYER_MOTION_TRACKER_TEXT");
	--enable dynamic AI VO as we've played the last narrative scripted line for the AI
	EnablePersonalAIVoices(true);
end

function CalloutInstructionThread()
	TutorialQuickTipHandler(PLAYERS.player0, "academy_tip_callout_title", "academy_tip_callout", exploreTipDisplaySeconds);
end

global PlayerSpawnCount = 0;

function HandlePlayerSpawn(eventArgs:PlayerSpawnEventStruct):void
	if eventArgs.player == PLAYERS.player0 then
		PlayerSpawnCount = PlayerSpawnCount + 1;
		if PlayerSpawnCount == 1 then
			NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_support_4");
		elseif PlayerSpawnCount == 3 then
			NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_support_5");
		end
	elseif eventArgs.player == friendlyBotCommander then
		CreateThread(ApplyVariantThread, friendlyBotCommander, "drill_sergeant");
	elseif eventArgs.player == friendlyBot1 then
		CreateThread(ApplyVariantThread, friendlyBot1, "multi_tutorial_001");
	elseif eventArgs.player == friendlyBot2 then
		CreateThread(ApplyVariantThread, friendlyBot2, "multi_tutorial_002");
	elseif eventArgs.player == enemyBot1 then
		CreateThread(ApplyVariantThread, enemyBot1, "multi_tutorial_003");
	elseif eventArgs.player == enemyBot2 then
		CreateThread(ApplyVariantThread, enemyBot2, "multi_tutorial_004");
	end
end

-- teach callout the first time a player kills an enemy to reinforce that they can call for help
function OnCalloutBotKilled(deathEvent:DeathEventStruct):void
	local killingPlayer:object = deathEvent.killingPlayer;

	if Player_IsHuman(killingPlayer) then
		CreateThread(CalloutInstructionThread);
	end
	UnregisterGlobalEvent(g_eventTypes.deathEvent, OnCalloutBotKilled);
end

global CommanderMeleeVOPlayed = false;
global CommanderAssistVOPlayed = false;
global CommanderHeadshotVOPlayed = false; 

function SupportCommanderVOWatcher(deathEvent:DeathEventStruct):void
	if CommanderHeadshotVOPlayed == false then
		if deathEvent.killingPlayer == Player_GetLocal(0) and deathEvent.damageModifier == DAMAGE_MODIFIER.Headshot then
			CommanderHeadshotVOPlayed = true;
			NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_support_6");
		end
	end
	
	if CommanderMeleeVOPlayed == false then
		local meleeDamageType = get_string_id_from_string("melee");
		if CommanderMeleeVOPlayed == false and deathEvent.damageType == meleeDamageType then
			CommanderMeleeVOPlayed = true; 
			NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_support_7");
		end
	end

	if CommanderAssistVOPlayed == false then

		local assistingPlayers:table = deathEvent.assistingPlayers;
		if CommanderAssistVOPlayed == false then
			for _, player in hpairs(assistingPlayers) do
				if Player_IsHuman(player) then
					CommanderAssistVOPlayed = true;
					NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_support_2");
				end
			end
		end
	end
end

function LiveFireEndWatcher()
	UnregisterGlobalEvent(g_eventTypes.deathEvent, HandleExplorationDeath);
	UnregisterGlobalEvent(g_eventTypes.playerSpawnEvent, HandleExplorationPlayerSpawn);
	RegisterGlobalEvent(g_eventTypes.deathEvent, OnCalloutBotKilled);
	RegisterGlobalEvent(g_eventTypes.deathEvent, SupportCommanderVOWatcher);
	RegisterGlobalEvent(g_eventTypes.playerSpawnEvent, HandlePlayerSpawn);
	SleepUntil ([|RoundTimer_GetSecondsLeft() <= waitTimer], 1);
	LiveFireEndSequence();
end

function PlayCombatEndingMusicThread()
	SleepUntil([| RoundTimer_GetSecondsLeft() < 60], 1);
    MPLuaCall("__OnBotCombatOneMinuteRemaining");
end

function LiveFireEndSequence():void
	Composer_FadeOut(0,0,0,1);
	player_control_fade_out_all_input(0);
	HoldEnding();
	UnregisterGlobalEvent(g_eventTypes.playerSpawnEvent, HandlePlayerSpawn);
	object_cannot_die(PLAYERS.player0, true);
	--sleep to keep the player from seeing a bot die when it is removed
	SleepSeconds(1);
	Bot_RemoveAll();
	SleepSeconds(1);
	game_force_respawn_for_player(PLAYERS.player0);
	player_control_fade_out_all_input(0);
	--sleep to ensure player has spawned again before we teleport them
	MPLuaCall("__OnBotCombatComplete");
	if skipTutorialCinematics == false then
		-- Sleep for timing purposes DE
		SleepSeconds(5);
		Tutorial_PlayOutro();
	end
	RoundTimer_SetSecondsLeft(0);	
	Timer_Start(RoundTimer);

	-- the player has reached the end of the tutorial, so fire a telemetry event to complete the mission
	Tutorial_TutorialTelemetryComplete(); -- defined in sgh_interlock_facility.lua

	game_won();
end

function Tutorial_PlayOutro():void
	NarrativeInterface.SleepUntil.PlayNarrativeSequence("TUTORIAL_OUTRO");
	--prevent players from moving after the narrative sequence is complete to prevent them from turning around and seeing OOE
	player_control_fade_out_all_input(0);
end

global RoundTimer = nil;

function HoldEnding()
	RoundTimer = Engine_GetRoundTimer();
	Timer_Stop(RoundTimer);
end

--Utilities

function CreateLiveFireObjectNavpoint(navpointObject:object, navpointType:string, navpointText:string)
	local newNavpoint = Navpoint_Create(navpointType);
	--wrapper to check that our navpoint didn't fail to create
	if newNavpoint ~= nil then
		Navpoint_SetObjectParent(newNavpoint, navpointObject);
		Navpoint_SetDisplayText(newNavpoint, navpointText);
		Navpoint_VisibilityFilter_SetPlayersAllDefaultFilter(newNavpoint, true);
		Navpoint_SetVisibleWithNoObjectParent(newNavpoint, true);
		Navpoint_SetVisibleOffscreen(newNavpoint, true);
		Navpoint_SetCanBeOccluded(newNavpoint, false);
		Navpoint_SetVisibilityParams(newNavpoint, -1, true);
		local navpointObjectPosition = Object_GetPositionVector(navpointObject);

		--play the correct sound response depending on what type of navpoint we created
		if navpointType == defaultNavpointType then
			MPLuaCall("__OnWaypointNavAppear", navpointObjectPosition);
		elseif navpointType == exploreNavpoint then
			MPLuaCall("__OnObjectNavAppear", navpointObjectPosition);
		elseif navpointType == aiTerminalNavpointType then
			MPLuaCall("__OnPersonalAINavAppear", navpointObjectPosition);
		elseif navpointType == commanderNavpoint then
			MPLuaCall("__OnCommanderNavAppear", navpointObjectPosition);
		end

		return newNavpoint;
	else 
		return nil; 
	end
end

-- Blinks

function BlinkExplorationComplete()
	onMapExplorationComplete = true;
	CreateThread(SetCommanderPrimaryObjective);
end

--## CLIENT

function remoteClient.GoToThirdPerson(player:player, commanderObject:object)
	local cageTag = CageCameraTags.mpNarrativeCageDefinition;
	local playerCam = CageInterface.GetPlayerCam(player);
	
	local playerObject:object = Player_GetUnit(player);
	
	-- Set the player variant to non-ICS and hide HUD
	object_set_variant(playerObject, "multi_tutorial_player");
	hud_show(false);

	-- Blend 1: Transfer to the Cage camera and cut to a perspective close to the player's helmet
		-- Create transform and camera properties providers
		local cutTransformProvider:cage_transform_provider = Cage_TransformCreateCageProvider();
		local cutPropertiesProvider:cage_properties_provider = Cage_PropertiesCreateCameraProvider();

		-- Set center/move target
		Cage_TransformSetCenterPoint(cutTransformProvider, cage_point_reference(cageTag, "centerpoint_head", playerObject));
		Cage_TransformAddPositionPointCage(cutTransformProvider, cage_point_reference(cageTag, "from_back_helmet", playerObject));

		-- Cut to back of helmet
		Cage_StackCutTo(playerCam.stack, cutTransformProvider, cutPropertiesProvider);

		-- Switch to Cage Camera
		Cage_SwitchToCageCameraPlayer(player, playerCam.stack);

	-- Blend 2: Move to our 3rd person camera and gaze at the Commander
		-- Create transform and camera properties providers
		local transformProvider:cage_transform_provider = Cage_TransformCreateCageProvider();
		local propertiesProvider:cage_properties_provider = Cage_PropertiesCreateCameraProvider();

		-- Set center/move target
		Cage_TransformSetCenterPoint(transformProvider, cage_point_reference(cageTag, "centerpoint_center", playerObject));
		Cage_TransformAddPositionPointCage(transformProvider, cage_point_reference(cageTag, "dialogue_over_shoulder", playerObject));

		-- Set gaze
		Cage_TransformAddGazeCage(transformProvider, cage_point_reference(cageTag, "root", commanderObject));
		Cage_TransformSetGazeVelocity(transformProvider, 50);
		Cage_TransformSetGazeInnerAngle(transformProvider, 1);
		Cage_TransformSetGazeOuterAngle(transformProvider, 360);
		
		-- Set unique properties
		Cage_TransformOSNSetRotationOffsetScale(transformProvider, vector(0.25, 0.25, 0.125));
		Cage_TransformSetDampingSpringPositionConstant(transformProvider, Cage_CalculateDampingSpringConstant(1, 1));
		Cage_TransformSetBlendCurve(transformProvider, curve_wrapper(CURVE_BUILT_IN.EaseOutSine));
		Cage_TransformSetOrientationLimits(transformProvider, vector(-1,-1, 0), vector(-1,-1, 0));	-- lock roll to prevent odd Cage bug

		-- Blend to over the shoulder camera
		Cage_StackBlendTo(playerCam.stack, transformProvider, propertiesProvider, 1);
end

function remoteClient.RoundTransitionCamera(player:player):void
	CageInterface.ResetStack(player, 0);

	local playerCam = CageInterface.GetPlayerCam(player);
	local playerObject:object = Player_GetUnit(player);
	Cage_SwitchToCageCameraPlayer(playerCam.player, playerCam.stack);
	
	-- BLEND 1 - Left shoulder shot
	local middle1TransformProvider:cage_transform_provider = Cage_TransformCreateCageProvider();
	local middle1PropertiesProvider:cage_properties_provider = Cage_PropertiesCreateCameraProvider(70, 1, 1.4);

	Cage_TransformSetCenterPoint(middle1TransformProvider, cage_point_reference(CageCameraTags.mpIntroCageDefinition, "centerpoint_center", playerObject));
	Cage_TransformAddPositionPointCage(middle1TransformProvider, cage_point_reference(CageCameraTags.mpIntroCageDefinition, "regroup_middle1", playerObject));
	Cage_PropertiesSetDOFTracking(middle1PropertiesProvider, cage_point_reference(CageCameraTags.mpIntroCageDefinition, "centerpoint_center", playerObject));
	Cage_StackCutTo(playerCam.stack, middle1TransformProvider, middle1PropertiesProvider);

	SleepSeconds(0.01);

	-- BLEND 2 - Over Right Shoulder
	local endTransformProvider:cage_transform_provider = Cage_TransformCreateCageProvider();
	local endPropertiesProvider:cage_properties_provider = Cage_PropertiesCreateCameraProvider();

	Cage_TransformSetCenterPoint(endTransformProvider, cage_point_reference(CageCameraTags.mpIntroCageDefinition, "centerpoint_center", playerObject));
	Cage_TransformAddPositionPointCage(endTransformProvider, cage_point_reference(CageCameraTags.mpIntroCageDefinition, "third", playerObject));

	-- Set unique properties
	Cage_TransformOSNSetRotationOffsetScale(endTransformProvider, vector(1, 1, 0.5));
	Cage_TransformSetDampingSpringPositionConstant(endTransformProvider, Cage_CalculateDampingSpringConstant(1, 2.5));
	Cage_TransformSetBlendCurve(endTransformProvider, curve_wrapper(CURVE_BUILT_IN.EaseInOutCubic));
	Cage_StackBlendTo(playerCam.stack, endTransformProvider, endPropertiesProvider, 2.5);
end

function remoteClient.ReturnToFirstPerson(player:player)
	local playerCam = CageInterface.GetPlayerCam(player);
	local playerObject:object = Player_GetUnit(player);
	
	if (playerCam ~= nil) then
		-- Create transform and camera properties providers
		local transformProvider:cage_transform_provider = Cage_TransformCreateCageProvider();
		local propertiesProvider:cage_properties_provider = Cage_PropertiesCreateCameraProvider(90, 3, 5.6);

		-- Set center/move target
		Cage_TransformSetCenterPoint(transformProvider, cage_point_reference(CageCameraTags.mpIntroCageDefinition,"centerpoint_head", playerObject));
		Cage_TransformAddPositionPointCage(transformProvider, cage_point_reference(CageCameraTags.mpIntroCageDefinition, "to_back_helmet", playerObject));

		-- Set unique properties
		Cage_TransformOSNSetRotationOffsetScale(transformProvider, vector(1, 1, 0.5));
		Cage_TransformSetDampingSpringPositionConstant(transformProvider, Cage_CalculateDampingSpringConstant(1, 0.5));
		Cage_TransformSetBlendCurve(transformProvider, curve_wrapper(CURVE_BUILT_IN.EaseInSine));

		-- Set to return to gameplay camera on completion of this blend
		Cage_TransformReturnToGameplayCameraPlayer(transformProvider, player);

		-- Blend to prepare us to go to the helmet (complete rotation and begin movement)
		Cage_StackBlendTo(playerCam.stack, transformProvider, propertiesProvider, 0.5);

		-- Play effect for going into helmet
		if (playerObject ~= nil) then
			effect_new_on_object_marker(CageCameraTags.introToHelmetScreenFX, playerObject, "fx_root");
		end
	end

	SleepSeconds(0.5);

	-- Return to gameplay camera and show HUD
	Cage_SwitchToGameplayCamera(playerObject);
	SendBroadcastCuiEvent("hud_transition_on_start");	-- This animates the HUD in
	hud_show(true);
	SendHuiEvent("event_hud_player_spawn_start");	-- This is the HUD scan lines
end