-- Copyright (c) Microsoft. All rights reserved.
-- WARNING: This file is not compiled with the rest of our Lua, so it is executed as native Lua as opposed to HSLua.
-- 			Any changes to this file must pass two corblds: a binary build with all changes and a content build with just content changes.

-- Lua wrappers must be defined before the refactor table.
-- Example wrappers which strengthen the typing of a parameter from a number to an enum.
--[[

function populateEnumMap()
	if weaponAdditionMethodEnumMap == nil then
		weaponAdditionMethodEnumMap = {
			[WEAPON_ADDITION_METHOD.Normal] = 0,
			[WEAPON_ADDITION_METHOD.Silent] = 1,
			[WEAPON_ADDITION_METHOD.OnlyWeapon] = 2,
			[WEAPON_ADDITION_METHOD.PrimaryWeapon] = 3,
			[WEAPON_ADDITION_METHOD.SwapForPrimaryWeapon] = 4,
			[WEAPON_ADDITION_METHOD.SecondaryWeapon] = 5,
			[WEAPON_ADDITION_METHOD.SwapForSecondaryWeapon] = 6,
			[WEAPON_ADDITION_METHOD.SecondaryWeaponSilently] = 7,
			[WEAPON_ADDITION_METHOD.Backpack] = 8,
		};
	end
end

function unit_add_weapon_lua(obj1, obj2, additionMethod)
	populateEnumMap();
	return unit_add_weapon_temp(obj1, obj2, weaponAdditionMethodEnumMap[additionMethod]);
end

function unit_create_and_add_weapon_configuration_lua(object, tag1, tag2, additionMethod)
	populateEnumMap();
	return unit_create_and_add_weapon_configuration_temp(object, tag1, tag2, weaponAdditionMethodEnumMap[additionMethod]);
end
--]]


-- LuaRefactorVersion_RemovedOldTeamBindings (107)
function Team_GetLivingParticipantUnits_luawrapper(team)
	return mp_players_by_team_TEMP(team);
end

function Team_GetActiveParticipantCount_luawrapper(team)
	return mp_player_count_by_team_TEMP(team);
end

-- LuaRefactorVersion_CreateObjectWithConfigAndLocation (108)
function Object_CreateFromTagWithConfigurationAndLocation_luawrapper(obj, config, loc)
	return Object_CreateFromTagWithConfiguration(obj, config);
end

-- LuaRefactorVersion_ForceRandomlySpawnedItem (109)
function Variant_GetItemIsForcedRandomOverride_luawrapper(category, catId)
	return false;
end

-- LuaRefactorVersion_SeedSeqAndStaticSelectionVariantOpts (110)
function Variant_GetSeedSequenceOverrideNameByIndex_luawrapper(index)
	return "";
end

function Variant_GetSeedSequenceSeedValueOverride_luawrapper(key)
	return "";
end

function Variant_GetSeedSequenceSeedValueOverrideByIndex_luawrapper(index)
	return "";
end

function Variant_GetSeedSequenceRoundResetOverride_luawrapper(key)
	return 255;
end

function Variant_GetSeedSequenceRoundResetOverrideByIndex_luawrapper(index)
	return 255;
end

function Variant_GetSeedSequenceOverrideCount_luawrapper()
	return 0;
end

function Variant_GetItemStaticSelectionOverride_luawrapper(category, catId)
	return 255;
end

function Variant_GetItemSeedSequenceKeyOverride_luawrapper(category, catId)
	return "GeneralPlacementKey";
end

-- LuaRefactorVersion_PersonalAIEffectsArgChange (111)
function PersonalAI_SetEffectTagReferences_luawrapper(looping, spawnOneShot, despawnOneShot)
	PersonalAI_SetEffectTagRefs(looping, spawnOneShot);
end

--[[
There are currently 4 use cases for this system.

 - Parameter type change : used if you want to change the signature of a binding function.
 - Deprecate function : if you want to mark a function as DEPRECATED.
 - function rename : if you want to rename a binding function.
 - function addition : if you want to add a new native binding

The way the system works is that if the engine/C++ version # is less than the Lua version number, then the C++
function registered with the name "oldName" is instead given the name "tempName" and when Lua code calls the Lua
function with "newName", it will invoke the "luaWrapper" function, which should call the "tempName" function (if
setup properly), which calls the "oldName"'s C++ code.

Confluence: https://halolibrary/display/343Code/Lua+Refactor+System

--]]
-- Table processed by the engine.
global refactorSystem = {
	-- Parameter type change
	-- oldName: original binding name
	-- newName: name of the function after the refactor (if different)
	-- tempName: a unique function name (different from oldName and newName)
	-- luaWrapper: Lua function which connects the refactored Lua calls with the old binaries
	--   The function needs to call the "tempName" function with the "oldName" function's parameter set.
	-- version: stop renaming and using the luaWrapper once the binary version has reached this number
	-- examples:

	-- Argument change example
	--{oldName = "unit_add_weapon", tempName = "unit_add_weapon_temp", luaWrapper = unit_add_weapon_lua, version = 2},
	--{oldName = "unit_create_and_add_weapon_configuration", tempName = "unit_create_and_add_weapon_configuration_temp", luaWrapper = unit_create_and_add_weapon_configuration_lua, version = 2},

	-- Deprecate example
	-- oldName: original binding name
	-- tempName: original name with "_DEPRECATED" attached.
	-- version: should always be 999
	-- The purpose for the deprecated entries is to simply mark something as DEPRECATED.

	-- Function rename example
	-- oldName: original binding name
	-- tempName: new binding name.
	-- version: version in which the C++ code will have the new binding name registered.
	--{oldName = "NavpointCreate", tempName = "Navpoint_Create", version = 2},

	-- Lua function rename example
	-- {oldName = "GetRoundTimerRate", tempName ="RoundTimer_GetRate_temp", newName ="RoundTimer_GetRate", version = 9},
	-- {oldName = "SetRoundTimerRate", tempName ="RoundTimer_SetRate_temp", newName ="RoundTimer_GetRate", version = 9},

	-- LuaRefactorVersion_RemovedOldTeamBindings (107)
	{ oldName = "mp_players_by_team", tempName = "mp_players_by_team_TEMP", newName = "Team_GetLivingParticipantUnits", luaWrapper = Team_GetLivingParticipantUnits_luawrapper, version = 107 },
	{ oldName = "mp_player_count_by_team", tempName = "mp_player_count_by_team_TEMP", newName = "Team_GetActiveParticipantCount", luaWrapper = Team_GetActiveParticipantCount_luawrapper, version = 107 },

	-- LuaRefactorVersion_CreateObjectWithConfigAndLocation (108)
	{ oldName = "Object_CreateFromTagWithConfigurationAndLocation", tempName = "Object_CreateFromTagWithConfigurationAndLocation_SPOOFED", luaWrapper = Object_CreateFromTagWithConfigurationAndLocation_luawrapper, version = 108 },

	-- LuaRefactorVersion_ForceRandomlySpawnedItem (109)
	{ oldName = "Variant_GetItemIsForcedRandomOverride", tempName = "Variant_GetItemIsForcedRandomOverride_SPOOFED", luaWrapper = Variant_GetItemIsForcedRandomOverride_luawrapper, version = 109 },

	-- LuaRefactorVersion_SeedSeqAndStaticSelectionVariantOpts (110)
	{ oldName = "Variant_GetSeedSequenceOverrideNameByIndex", tempName = "Variant_GetSeedSequenceOverrideNameByIndex_SPOOFED", luaWrapper = Variant_GetSeedSequenceOverrideNameByIndex_luawrapper, version = 110 },
	{ oldName = "Variant_GetSeedSequenceSeedValueOverride", tempName = "Variant_GetSeedSequenceSeedValueOverride_SPOOFED", luaWrapper = Variant_GetSeedSequenceSeedValueOverride_luawrapper, version = 110 },
	{ oldName = "Variant_GetSeedSequenceSeedValueOverrideByIndex", tempName = "Variant_GetSeedSequenceSeedValueOverrideByIndex_SPOOFED", luaWrapper = Variant_GetSeedSequenceSeedValueOverrideByIndex_luawrapper, version = 110 },
	{ oldName = "Variant_GetSeedSequenceRoundResetOverride", tempName = "Variant_GetSeedSequenceRoundResetOverride_SPOOFED", luaWrapper = Variant_GetSeedSequenceRoundResetOverride_luawrapper, version = 110 },
	{ oldName = "Variant_GetSeedSequenceRoundResetOverrideByIndex", tempName = "Variant_GetSeedSequenceRoundResetOverrideByIndex_SPOOFED", luaWrapper = Variant_GetSeedSequenceRoundResetOverrideByIndex_luawrapper, version = 110 },
	{ oldName = "Variant_GetSeedSequenceOverrideCount", tempName = "Variant_GetSeedSequenceOverrideCount_SPOOFED", luaWrapper = Variant_GetSeedSequenceOverrideCount_luawrapper, version = 110 },
	{ oldName = "Variant_GetItemStaticSelectionOverride", tempName = "Variant_GetItemStaticSelectionOverride_SPOOFED", luaWrapper = Variant_GetItemStaticSelectionOverride_luawrapper, version = 110 },
	{ oldName = "Variant_GetItemSeedSequenceKeyOverride", tempName = "Variant_GetItemSeedSequenceKeyOverride_SPOOFED", luaWrapper = Variant_GetItemSeedSequenceKeyOverride_luawrapper, version = 110 },

	-- LuaRefactorVersion_PersonalAIEffectsArgChange (111)
	{ oldName = "PersonalAI_SetEffectTagReferences", tempName = "PersonalAI_SetEffectTagReferences_SPOOFED", luaWrapper = PersonalAI_SetEffectTagReferences_luawrapper, version = 111 },
};

-- Called from engine before scripts are compiled
function RegisterRefactorFunctions(engineVersion:number)
	for _, v in pairs(refactorSystem) do
		if engineVersion < v.version then
			assert (v.oldName ~= nil);
			assert (_G[v.oldName] == nil);

			if (v.luaWrapper ~= nil) then
				-- If there is a luawrapper, it better be a function.  If it's not, then it could mean they bound the variable to an invalid function name.
				assert(type(v.luaWrapper) == "function");
				_G[v.newName or v.oldName] = v.luaWrapper;
			end
		end

		-- Set the old binding to a function that asserts. This will be switched
		-- on for automation since they send in Lua commands via telnet.
		if (LuaRefactorAssertOnOldBindings == true) then
			if (v.newName ~= nil and v.newName ~= v.oldName) then
				_G[v.oldName] =
					function (...)
						assert (false, v.oldName .. " is no longer supported, use " .. v.newName .. " instead.")
					end
			end
		end
	end
end
