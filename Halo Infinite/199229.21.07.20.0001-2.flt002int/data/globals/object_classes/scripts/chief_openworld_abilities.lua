-- object chief_openworld_abilities

-- Copyright (c) Microsoft. All rights reserved.

hstructure chief_openworld_abilities
	meta : table
	instance : luserdata
end

global g_chiefEquipmentUpgrades = table.makePermanent
{
	ability_grapple_hook_chief = "ability_grapple_hook_upgrade_1",
	ability_grapple_hook_upgrade_1 = "ability_grapple_hook_upgrade_2",
	ability_grapple_hook_upgrade_2 = "ability_grapple_hook_upgrade_3",
	ability_grapple_hook_upgrade_3 = "ability_grapple_hook_upgrade_4",
	ability_deployable_wall_chief = "ability_deployable_wall_upgrade_1",
	ability_deployable_wall_upgrade_1 = "ability_deployable_wall_upgrade_2",
	ability_deployable_wall_upgrade_2 = "ability_deployable_wall_upgrade_3",
	ability_deployable_wall_upgrade_3 = "ability_deployable_wall_upgrade_4",
	ability_location_sensor_chief = "ability_location_sensor_upgrade_1",
	ability_location_sensor_upgrade_1 = "ability_location_sensor_upgrade_2",
	ability_location_sensor_upgrade_2 = "ability_location_sensor_upgrade_3",
	ability_location_sensor_upgrade_3 = "ability_location_sensor_upgrade_4",
	ability_evade_chief = "ability_evade_upgrade_1",
	ability_evade_upgrade_1 = "ability_evade_upgrade_2",
	ability_evade_upgrade_2 = "ability_evade_upgrade_3",
	ability_evade_upgrade_3 = "ability_evade_upgrade_4",
	core_shield_capacity_bonus_1 = "core_shield_capacity_bonus_2",
	core_shield_capacity_bonus_2 = "core_shield_capacity_bonus_3",
	core_shield_capacity_bonus_3 = "core_shield_capacity_bonus_4",
	core_shield_capacity_bonus_4 = "core_shield_capacity_bonus_5",
}

global g_chiefUpgradePersistenceKeyMap:table =
{
	grapple = 
	{
		defaultEnabled = true,
		name = "ability_grapple_hook_chief",
		enabledKey = nil,
		levelKey = PERSISTENCE_KEY("Grapple_Upgrade_Level")
	},
	wall =
	{
		defaultEnabled = false,
		name = "ability_deployable_wall_chief",
		enabledKey = PERSISTENCE_KEY("spartan_makovich"),
		levelKey = PERSISTENCE_KEY("Wall_Upgrade_Level")
	},
	sensor = 
	{
		defaultEnabled = false,
		name = "ability_location_sensor_chief",
		enabledKey = PERSISTENCE_KEY("spartan_griffin"),
		levelKey = PERSISTENCE_KEY("Sensor_Upgrade_Level")
	},
	evade = 
	{
		defaultEnabled = false,
		name = "ability_evade_chief",
		enabledKey = PERSISTENCE_KEY("spartan_sorel"),
		levelKey = PERSISTENCE_KEY("Evade_Upgrade_Level")
	},
	shield = 
	{
		defaultEnabled = false,
		name = "core_shield_capacity_bonus_1",
		enabledKey = PERSISTENCE_KEY("spartan_stone"),
		levelKey = PERSISTENCE_KEY("Shield_Upgrade_Level")
	},
}

global g_chiefUpgradePersistenceKeyEventsRegistered:boolean = false;

--## SERVER

function chief_openworld_abilities:init() : void
	if g_suppressionVariables.descopeSuppressionEnabled == true then
		RegisterSuppressionSystemEventsForObject(self);
	end

	-- Set each player's equipment to the level of the fireteam leader
	for _, equipment in hpairs(g_chiefUpgradePersistenceKeyMap) do
		local enabled = equipment.defaultEnabled or IsCollectibleCollected(equipment.enabledKey);
		if enabled then
			local level = Persistence_GetByteKey(equipment.levelKey);
			for _, activePlayer in hpairs(PLAYERS.active) do
				SetFrameAttachmentRank(activePlayer, equipment.name, level);
			end
		end
	end

	self:SetupKeyStateListeners();
end

function chief_openworld_abilities:SetupKeyStateListeners():void
	if g_chiefUpgradePersistenceKeyEventsRegistered == false then
		g_chiefUpgradePersistenceKeyEventsRegistered = true;
		for _, equipment in hpairs(g_chiefUpgradePersistenceKeyMap) do
			if equipment.enabledKey ~= nil and Persistence_GetStringIdFromKey(equipment.enabledKey) ~= nil then
				self:RegisterEventOnSelf(g_eventTypes.playerShortStateChanged, self.OnSchematicKeyStateChange, Persistence_GetStringIdFromKey(equipment.enabledKey), equipment);
			end
			if equipment.levelKey ~= nil and Persistence_GetStringIdFromKey(equipment.levelKey) ~= nil then
				self:RegisterEventOnSelf(g_eventTypes.playerShortStateChanged, self.OnEquipmentLevelStateChange, Persistence_GetStringIdFromKey(equipment.levelKey), equipment);
			end
		end
	end
end

function chief_openworld_abilities:OnSchematicKeyStateChange(eventArgs:ShortStateChangedEventStruct, equipment:table):void
	SetFrameAttachmentRank(eventArgs.owningPlayer, equipment.name, Persistence_GetByteKey(equipment.levelKey));
end

function chief_openworld_abilities:OnEquipmentLevelStateChange(eventArgs:ShortStateChangedEventStruct, equipment:table):void
	SetFrameAttachmentRank(eventArgs.owningPlayer, equipment.name, Persistence_GetByteKey(equipment.levelKey));
end

function SetFrameAttachmentRank(aPlayer, equipmentName, rankNum):void
	if (Object_IsPlayer(aPlayer) == false) then
		aPlayer = PLAYERS.player0;
	end

	if (g_chiefEquipmentUpgrades[equipmentName] == nil) then
		print("equipment '" .. equipmentName .. "' not found");
		return;
	end

	local desiredEquipment = equipmentName;

	-- Find matching equipment for desired rank
	while rankNum > 0 do
		desiredEquipment = g_chiefEquipmentUpgrades[desiredEquipment];
		rankNum = rankNum - 1;
	end
	
	local allUpgrades = { };
	local equipmentToClear = equipmentName;
	allUpgrades[1] = get_string_id_from_string(equipmentToClear);
	for rankCount = 1, 4, 1 do
		equipmentToClear = g_chiefEquipmentUpgrades[equipmentToClear];
		allUpgrades[rankCount + 1] = get_string_id_from_string(equipmentToClear);
	end

	PlayerFrameAttachmentEnableExclusive(aPlayer, desiredEquipment, allUpgrades);

	ClientPrint("Upgraded Equipment to: " .. desiredEquipment);

	game_save_no_timeout();	
end

