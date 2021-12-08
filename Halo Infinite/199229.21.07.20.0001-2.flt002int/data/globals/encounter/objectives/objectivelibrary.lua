-- Copyright (c) Microsoft Corporation.  All rights reserved.
-- Author: v-whdani
--## SERVER


-- Table of standardized keywords for assigning squads to tasks.
global ObjectiveTaskKeywords:table = table.makeEnum
{
	Command = "Command",
	Reserve = "Reserve",
	Flanker = "Flanker",
	Specialist = "Specialist",
	Frontline = "Frontline",
	Midline = "Midline",
}

-- Table of standardized keywords for spawn areas.
global ObjectiveSpawnKeywords:table = table.makePermanent
{
	Default = "Default",
}

global ObjectiveIntent:table = table.makePermanent
{
	Normal = "Normal",
	Aggressive = "Aggressive",
	Defensive = "Defensive",
}

global k_OrderDurationInfinite:number = -1;

--*******************************************************
--* Global Objective Creation and Registration
--*******************************************************

global ObjectiveTable = RegistrationTable.New();

global objectivesRegistered = false;


--**************************************
--* Definition building functions
--**************************************

-- Assault player
-- Def: 3 rows of areas that change with the player pos. Back rows move up as enemies die off.

function CreateObjective_AssaultPlayerSmall():table
	local objective = AssaultPlayerObjective:Create(AssaultPlayerObjectiveParam_GetSmall);
	return objective;
end

function CreateObjective_AssaultPlayerLarge():table
	local objective = AssaultPlayerObjective:Create(AssaultPlayerObjectiveParam_GetLarge);
	return objective;
end

-- Hold Area
-- Def: Static area defined by # in the "Create" field
function CreateObjective_HoldAreaXXSmall():table
	local objective:table = HoldAreaObjective:Create(HoldAreaObjectiveParam_GetXXS);
	return objective;
end

function CreateObjective_HoldAreaLarge():table
	local objective:table = HoldAreaObjective:Create(HoldAreaObjectiveParam_GetLarge);
	return objective;
end

function CreateObjective_HoldAreaLargeDefensive():table
	local objective:table = HoldAreaObjective:Create(HoldAreaObjectiveParam_GetLargeDefensive);
	return objective;
end

function CreateObjective_HoldAreaXXLLarge():table
	local objective:table = HoldAreaObjective:Create(HoldAreaObjectiveParam_GetXXL);
	return objective;
end


-- Point Defense
-- Def: 3 rows of areas that change orientation with the player, anchored on the creation point.

function CreateObjective_PointDefendSmall():table
	local objective = PointDefendObjective:Create(PointDefendObjectiveParam_GetSmall);
	return objective;
end

function CreateObjective_PointDefendLarge():table
	local objective = PointDefendObjective:Create(PointDefendObjectiveParam_GetLarge);
	return objective;
end


-- Fan Out
-- Def: AI spawn at edges. When player approaches, AI move in.
-- USe for baiting players into the area and then ambushing them.

function CreateObjective_FanOutLarge():table
	local objective = FanOutObjective:Create(FanOutObjectiveParam_GetLarge);
	return objective;
end


-- Follow Unit

function CreateObjective_FollowUnit():table
	local objective = FollowUnitObjective:Create(FollowUnitObjectiveParam_GetSmall);
	return objective;
end


-- Long Range

function CreateObjective_LongRangeLarge():table
	local objective = LongRangeObjective:Create(LongRangeObjectiveParam_GetLarge);
	return objective;
end

function CreateObjective_LongRangeLargeDefensive():table
	local objective = LongRangeObjective:Create(LongRangeObjectiveParam_GetLargeDefensive);
	return objective;
end
