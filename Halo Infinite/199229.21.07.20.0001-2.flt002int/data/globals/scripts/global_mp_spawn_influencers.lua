-- Copyright (C) Microsoft. All rights reserved.
--## SERVER

--------------------------------------------------------------------------------------------------------------------------------------------------
--|   _____ _       _           _   __  __ _____     _____                              _____        __ _                                      |--
--|  / ____| |     | |         | | |  \/  |  __ \   / ____|                            |_   _|      / _| |                                     |--
--| | |  __| | ___ | |__   __ _| | | \  / | |__) | | (___  _ __   __ ___      ___ __     | |  _ __ | |_| |_   _  ___ _ __   ___ ___ _ __ ___   |--
--| | | |_ | |/ _ \| '_ \ / _` | | | |\/| |  ___/   \___ \| '_ \ / _` \ \ /\ / / '_ \    | | | '_ \|  _| | | | |/ _ \ '_ \ / __/ _ \ '__/ __|  |--
--| | |__| | | (_) | |_) | (_| | | | |  | | |       ____) | |_) | (_| |\ V  V /| | | |  _| |_| | | | | | | |_| |  __/ | | | (_|  __/ |  \__ \  |--
--|  \_____|_|\___/|_.__/ \__,_|_| |_|  |_|_|      |_____/| .__/ \__,_| \_/\_/ |_| |_| |_____|_| |_|_| |_|\__,_|\___|_| |_|\___\___|_|  |___/  |--
--|                                                       | |                                                                                  |--
--|                                                       |_|                                                                                  |--
--------------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------
------ Enum and Struct Defines -------
--------------------------------------

global SpawnZoneTeamFilterType:table = table.makeAutoEnum
{
	"ControllingTeam",		-- Applies only to the Controlling Team;  (ControllingTeam == nil) -> N/A for all teams
	"OpposingTeams",		-- Applies to all teams EXCEPT for the Controlling Team;  (ControllingTeam == nil) -> applies to everyone
	"AllTeams", 			-- Applies to all teams
};

global SpawnBoundaryDefinitionType:table = table.makeAutoEnum
{
	"ContentSpecified",		-- Use the exact MP Boundary that is defined on the source object in content
	"Explicit",				-- Boundary geometry params (radius, width, length, height, and shape) will be used to make a new explicit boundary
	"Expansion",			-- Boundary geometry params (radius, width, length, height) will be used to create an expanded version of the source object boundary (see global_boundaries.lua)
};

hstructure SpawnInfluencerParams
	-- Required fields
	locationObjectInstance  :object;		-- first precedence for location object; if nil, then locationObjectName will be used
	locationObjectName		:object_name;	-- the object that the spawn influencer object will be attached to upon creation, and whose boundary will be used for reference
	teamFilterType 			:number;		-- enum value of SpawnZoneTeamFilterType
	boundaryDefinitionType 	:number;		-- enum value of SpawnBoundaryDefinitionType
	weight					:number;		-- defines the spawn influencer weight; unused if denySpawns is true
	denySpawns				:boolean;		-- if true, the spawn influencer will fully deny spawns to applicable teams
	fixedBoundaryOrientation	:boolean;	-- whether or not the spawn influencer geometry will use a "fixed" orientation (i.e. one relative to global axis facing vectors)

	-- Note: the below fields do not apply if (boundaryDefinitionType == SpawnBoundaryDefinitionType.ContentSpecified)
	radius 					:number;		-- Only used for BOUNDARY_TYPE.Cylinder and BOUNDARY_TYPE.Sphere
	height 					:number;		-- Note that this will be halved, and the result passed as the NegativeHeight/PositiveHeight params
	width 					:number;		-- Only used for BOUNDARY_TYPE.Box
	length 					:number;		-- Only used for BOUNDARY_TYPE.Box

	shape 					:boundary_type; -- Only applicable for SpawnBoundaryDefinitionType.Explicit
end

-------------------------------------
------ Spawn Influencer class -------
-------------------------------------

global SpawnInfluencer:table = table.makePermanent
{
	influencerObject = nil,
	controllingTeam = NONE, -- initial value of NONE means that deliberately setting nil will work correctly

	CONST =
	{
		-- Populated by InitializeInternal()
		influencerParams = nil, -- instance of hstruct SpawnInfluencerParams
		influencerTag = nil,
	},
};

--
-- PUBLIC INTERFACE
--

function SpawnInfluencer:CreateNew(influencerTag:tag, influencerParams:SpawnInfluencerParams, initialOwningTeam:mp_team):table
	local newSpawnInfluencer:table = table.makeSubTable(self);

	if (newSpawnInfluencer:InitializeInternal(influencerTag, influencerParams, initialOwningTeam)) then
		return newSpawnInfluencer;
	end

	return nil;
end

function SpawnInfluencer:Dispose():void
	if (self.influencerObject ~= nil) then
		Object_Delete(self.influencerObject);
		self.influencerObject = nil;
	end
end

-- Helper to update the spawn influencer's TeamDesignator using the appropriate logic for the influencer's TeamFilterType
function SpawnInfluencer:SetControllingTeam(controllingTeam:mp_team):void
	-- If we have already disposed then no-op
	if (self.influencerObject == nil) then
		return;
	end

	if (self.CONST.influencerParams.teamFilterType == SpawnZoneTeamFilterType.AllTeams) then
		-- Neutral applies to everyone, so we don't negate the team filter here
		Object_SetRespawnInfluencerAppliesToAllOpposingTeams(self.influencerObject, false);
		Object_SetTeamDesignator(self.influencerObject, MP_TEAM_DESIGNATOR.Neutral);
	else
		-- Set the appropriate TeamDesignator on the object
		if (controllingTeam ~= nil) then
			Object_SetTeamDesignator(self.influencerObject, Team_GetTeamDesignator(controllingTeam));
		else
			Object_SetTeamDesignatorToNone(self.influencerObject);
		end

		-- Set the negation logic for team filtering
		if (self.CONST.influencerParams.teamFilterType == SpawnZoneTeamFilterType.ControllingTeam) then
			Object_SetRespawnInfluencerAppliesToAllOpposingTeams(self.influencerObject, false);
		elseif (self.CONST.influencerParams.teamFilterType == SpawnZoneTeamFilterType.OpposingTeams) then
			Object_SetRespawnInfluencerAppliesToAllOpposingTeams(self.influencerObject, true);
		else
			assert(false, "Encountered an unknown SpawnZoneTeamFilterType (" .. tostring(self.CONST.influencerParams.teamFilterType) .. ")!");
		end
	end
end

function SpawnInfluencer:Enable():void
	if (self.influencerObject ~= nil) then
		Object_SetRespawnInfluencerEnabled(self.influencerObject, true);
	else
		debug_assert(false, "Attempted to call SpawnInfluencer:Enable() on a spawn influencer that had a nil influencerObject!");
	end
end

function SpawnInfluencer:Disable():void
	if (self.influencerObject ~= nil) then
		Object_SetRespawnInfluencerEnabled(self.influencerObject, false);
	else
		debug_assert(false, "Attempted to call SpawnInfluencer:Disable() on a spawn influencer that had a nil influencerObject!");
	end
end

--
-- STATIC HELPERS (no self.* references)
--

function SpawnInfluencer:GenerateScriptedParams(baseParams:SpawnInfluencerParams, locationObject):SpawnInfluencerParams
	assert(locationObject ~= nil, "A nil locationObject was supplied to SpawnInfluencer:GenerateScriptedParams()!");

	local influencerParams:SpawnInfluencerParams = MPInitHelpers:DeepCopyNoMetatable(baseParams);
	self:PopulateParamStructWithLocationObject(influencerParams, locationObject);

	return influencerParams;
end

function SpawnInfluencer:GenerateContentDefinedParams(baseParams:SpawnInfluencerParams, locationObject):SpawnInfluencerParams
	assert(locationObject ~= nil, "A nil locationObject was supplied to SpawnInfluencer:GenerateContentDefinedParams()!");
	local influencerParams:SpawnInfluencerParams = hmake SpawnInfluencerParams
	{
		teamFilterType = baseParams.teamFilterType,
		boundaryDefinitionType = SpawnBoundaryDefinitionType.ContentSpecified,
		weight = baseParams.weight,
		denySpawns = baseParams.denySpawns,
		-- geometry dimension fields not used since we are deferring to content-defined params
	};

	self:PopulateParamStructWithLocationObject(influencerParams, locationObject);

	return influencerParams;
end


--
-- INTERNAL FUNCTIONALITY
--

-- NOTE: locationObject can either be an object instance or an object name (object_name/string)
function SpawnInfluencer:PopulateParamStructWithLocationObject(influencerParams:SpawnInfluencerParams, locationObject):void
	local locationType:string = type(locationObject);

	if (locationType == "string" or locationType == "object_name") then
		influencerParams.locationObjectName = locationObject;
	elseif (locationType == "object" or locationType == "ui64" or locationType == "struct" or locationType == "userdata") then
		influencerParams.locationObjectInstance = locationObject;
	else
		assert(false, "A locationObject with an invalid type (" .. locationType .. ") was supplied to SpawnInfluencer:PopulateParamStructWithLocationObject()!");
	end
end

function SpawnInfluencer:InitializeInternal(influencerTag:tag, influencerParams:SpawnInfluencerParams, initialOwningTeam:mp_team):boolean
	-- Let's assert the whole nine yards
	assert(influencerTag ~= nil, "Received a nil influencerTag in CreateSpawnInfluencer()!");
	assert(influencerParams ~= nil, "Received a nil influencerParams in CreateSpawnInfluencer()!");
	assert(influencerParams.locationObjectName ~= nil or influencerParams.locationObjectInstance ~= nil, "Encountered nil for the fields locationObjectInstance and locationObjectName in CreateSpawnInfluencer(). One of these must be supplied!");

	assert(influencerParams.teamFilterType ~= nil, "Encountered a nil teamFilterType in CreateSpawnInfluencer()");
	assert(table.contains(SpawnZoneTeamFilterType, influencerParams.teamFilterType), "Encountered a an invalid teamFilterType (" .. tostring(influencerParams.teamFilterType) .. ") in CreateSpawnInfluencer()");

	assert(influencerParams.boundaryDefinitionType ~= nil, "Encountered a nil boundaryDefinitionType in CreateSpawnInfluencer()");
	assert(table.contains(SpawnBoundaryDefinitionType, influencerParams.boundaryDefinitionType), "Encountered a an invalid boundaryDefinitionType (" .. tostring(influencerParams.boundaryDefinitionType) .. ") in CreateSpawnInfluencer()");

	assert((influencerParams.denySpawns == true) or (influencerParams.weight ~= nil and influencerParams.weight ~= 0), "Encountered an invalid value for weight (" .. tostring(influencerParams.weight) .. ") in CreateSpawnInfluencer(); a non-nil, non-zero value is required if denySpawns is false/nil!");
	assert(influencerParams.shape ~= BOUNDARY_TYPE.None, "Encountered a shape of BOUNDARY_TYPE.None in CreateSpawnInfluencer()!");

	-- Attempt to resolve the source object, and create a new influencer object at that location
	local locationObject:object = influencerParams.locationObjectInstance or ObjectFromName(influencerParams.locationObjectName);
	if (locationObject ~= nil) then
		local spawnLocation:location = Object_GetPosition(locationObject);
		local influencerObject:object = Engine_CreateObject(influencerTag, spawnLocation);

		if (influencerObject ~= nil) then
			-- Generate boundary geometry
			local influencerBoundary:mp_object_boundary = nil;
			if (influencerParams.boundaryDefinitionType == SpawnBoundaryDefinitionType.ContentSpecified) then
				influencerBoundary = Object_GetBoundary(locationObject);
			elseif (influencerParams.boundaryDefinitionType == SpawnBoundaryDefinitionType.Explicit) then
				influencerBoundary = CreateNewExplicitBoundary(influencerParams.shape, influencerParams.radius, influencerParams.height, influencerParams.width, influencerParams.length);
			elseif (influencerParams.boundaryDefinitionType == SpawnBoundaryDefinitionType.Expansion) then
				influencerBoundary = CreateExpandedBoundaryAllParams(Object_GetBoundary(locationObject), influencerParams.radius, influencerParams.height, influencerParams.width, influencerParams.length);
			else
				assert(false, "Encountered an unknown SpawnBoundaryDefinitionType (" .. tostring(influencerParams.boundaryDefinitionType) .. ")!");
			end

			if (influencerBoundary ~= nil) then
				Object_SetBoundary(influencerObject, influencerBoundary);

				if (influencerParams.denySpawns == true) then
					Object_SetRespawnInfluencerDisableSpawnPoints(influencerObject, true);
				else
					Object_SetRespawnInfluencerDisableSpawnPoints(influencerObject, false);
					Object_SetRespawnWeight(influencerObject, influencerParams.weight);
					Object_SetRespawnInfluencerIgnoresFalloffFunction(influencerObject, true);
				end

				if (influencerParams.fixedBoundaryOrientation == true) then
					Object_SetUseFixedBoundaryOrientation(influencerObject, true);
				end

				Object_SetRespawnInfluencerEnabled(influencerObject, true);

				-- Save off state now that we have successfully initialized the influencer
				self.influencerObject = influencerObject;
				self.CONST.influencerParams = influencerParams;
				self.CONST.influencerTag = influencerTag;

				self:SetControllingTeam(initialOwningTeam);

				return true;
			else
				assert(false, "Failed to construct a non-nil influencerBoundary from the supplied influencerParams!");
			end
		else
			assert(false, "Failed to create an instance of " .. tostring(self.CONST.spawnZoneTag) .. " in SpawnInfluencer:InitializeInternal()!");
		end
	end

	return false;
end





