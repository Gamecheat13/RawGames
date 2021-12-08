-- object team_intro_squad_spawn_group
-- Copyright (c) Microsoft. All rights reserved.

REQUIRES('globals/scripts/global_multiplayer_init.lua');
REQUIRES('globals/scripts/global_hstructs.lua');
REQUIRES('scripts/parcellibrary/GlobalParcels/parcel_game_mode_manager.lua');

hstructure team_intro_squad_spawn_group
	meta:table;				-- required
	instance:luserdata;		-- required (must be first slot after meta to prevent crash)
	components:userdata;	-- required (used to reference game objects that make up a kit, and allows you to do KITS.myKitInstance.components:Object_GetName("myComponent")

	-- Player Data
	team:string;					--$$ METADATA {"prettyName": "Team Designator", "source": ["Defender", "Attacker", "Third Party", "Fourth Party", "Fifth Party", "Sixth Party", "Seventh Party", "Eighth Party", "Neutral"]}
	squad:string;					--$$ METADATA {"prettyName": "Squad", "source": ["Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Gamma", "Hotel"]}
	
	-- Camera Data
	cameraPosition:string;			--$$ METADATA {"prettyName": "Camera Position", "source": ["Front", "Left", "Right"]}
	shouldPanLeftToRight:boolean;	--$$ METADATA {"prettyName": "Pan Left to Right"}

	-- Fade Data
	fade:boolean;					--$$ METADATA {"visible": true}
	fadeTime:number; 				--$$ METADATA {"visible": true}

	-- Internal data
	lightGroups:table;
end

function team_intro_squad_spawn_group:GetCameraPositionName():string
	return self.cameraPosition;
end

-- Fading
function team_intro_squad_spawn_group:LightsOn(groupIndex:number):void
	if (not object_index_valid(self.lightGroups[groupIndex])) then
		return;
	end

	local time:number = 0;
	if (self.fade) then
		time = self.fadeTime;
	end

	object_set_function_variable(self.lightGroups[groupIndex], "master_dimmer", 1, time);
end

function team_intro_squad_spawn_group:LightsOff(groupIndex:number):void
	if (not object_index_valid(self.lightGroups[groupIndex])) then
		return;
	end

	local time:number = 0;
	if (self.fade) then
		time = self.fadeTime;
	end
	
	object_set_function_variable(self.lightGroups[groupIndex], "master_dimmer", 0, time);
end

function team_intro_squad_spawn_group:SetAllLightsImmediate(value:number):void
	for _, group in hpairs(self.lightGroups) do
		if (object_index_valid(group)) then
			object_set_function_variable(group, "master_dimmer", value, 0);
		end
	end
end

function team_intro_squad_spawn_group:GetSortedSquadData(players:table, leftToRight:boolean):table
	local spawnObjects:table = {
		[1] = self.components.spawn_0,
		[2] = self.components.spawn_1,
		[3] = self.components.spawn_2,
		[4] = self.components.spawn_3,
	};

	local result = {
		playerIndices = {},
		lightIndices = {1, 2, 3, 4},
		leftToRight = leftToRight
	};

	-- find the closest spawn to each player
	local const_maxDistanceSq:number = 1;
	local spawnToClosestPlayer:table = {};
	for playerIndex, player in ipairs(players) do
		local closestSpawn = nil;
		local sqDistance:number = math.huge;
		for _, spawn in ipairs(spawnObjects) do
			local tmpSqDistance:number = Object_GetDistanceSquaredToObject(player, spawn);
			if (tmpSqDistance < sqDistance and tmpSqDistance <= const_maxDistanceSq) then
				sqDistance = tmpSqDistance;
				closestSpawn = spawn;
			end
		end

		if (closestSpawn ~= nil) then
			spawnToClosestPlayer[closestSpawn] = playerIndex;
		end
	end

	-- arrange indices in the same order as the spawn points
	local currentIndex:number = 1;
	for _, spawn in ipairs(spawnObjects) do
		if (spawnToClosestPlayer[spawn] ~= nil) then
			result.playerIndices[currentIndex] = spawnToClosestPlayer[spawn];
			currentIndex = currentIndex + 1;
		end
	end

	-- reverse the results if necessary
	if (leftToRight) then -- right to left is the default
		result.playerIndices = table.reverseArray(result.playerIndices);
		result.lightIndices = table.reverseArray(result.lightIndices);
	end

	return result;
end

function team_intro_squad_spawn_group:GetDistanceSquaredToPlayer(player:player):number
	-- Returns sq distance to the player if the squads match; math.huge if they don't
	--	NOTE: If we start changing squads during gameplay we may run into race conditions
	if ((MPSquadNameToValue[self.squad] == Player_GetMultiplayerSquad(player))
		and (MPTeamDesignatorNameToValue[self.team] == Player_GetTeamDesignator(player))) then
		return Object_GetDistanceSquaredToObject(player, self.components.kit_position);
	end
	return math.huge;
end

function team_intro_squad_spawn_group:InitializeKitDefaults():void
	self.cameraPosition = self.cameraPosition or "Front";
	self.shouldPanLeftToRight = self.shouldPanLeftToRight or false;
	self.fade = self.fade or true;
	self.fadeTime = self.fadeTime or 0.8;

	self.lightGroups = {
		[1] = self.components.lights_0,
		[2] = self.components.lights_1,
		[3] = self.components.lights_2,
		[4] = self.components.lights_3,
	};
end

--## CLIENT
function team_intro_squad_spawn_group:initClient():void
	self:InitializeKitDefaults();
	self:SetAllLightsImmediate(0);
end

-- Camera
global teamIntroCameraVariables:table =
{
	CONFIG =
	{
		-- Note for blend times: Blend to Helmet begins at 3.75 seconds
		blendToTeamShot = 1.5,
		blendToTeamShotDolly = 2,
		dollyDistance = -0.5,				-- The distance we dolly once framing our Team Shot (front)
		dollyDistanceSide = -0.2,			-- The distance we dolly once framing our Team Shot (left/right)
		dollyRotation = vector(0, 1.5, 0),	
		pedestalDistance = -0.15,			-- The distance we pedestal once framing our Team Shot (left/right)
		pedestalRotation = vector(0, 2.5, 0),	
		springTimeDolly = 0.1,
		cameraShakeToTeamShotRot = vector(1, 1, 0.5),
		cameraShakeToTeamShotPos = vector(0.05, 0.05, 0.05),
		cameraShakeDolly = vector(0.5, 0.5, 0.25),	
		-- Front Camera Properties
		cameraFrontFOV = 55,
		cameraFrontFocusDistance = 3.5,
		cameraFrontFStop = 2.8,
		-- Side Camera Properties
		cameraSideFOV = 40,
		cameraSideFocusDistance = 4.5,
		cameraSideFStop = 2.8,
	},
}

function team_intro_squad_spawn_group:AddToCameraStack(playerCam, snapToCamera:boolean):void -- Can't add typing to param since CageSystem isn't compiled first
	local blendTime:number = teamIntroCameraVariables.CONFIG.blendToTeamShot
	if (snapToCamera) then
		blendTime = 0;
	end

	local isCameraFront:boolean = (self.cameraPosition == "Front");

	-- Blend 1: Move to Team Shot and blend to new Camera Properties 
	local locMatrix:matrix = ToLocation(self.components.camera_position).matrix;
	local transformProvider:cage_transform_provider = Cage_TransformCreateStaticProvider(locMatrix.pos, locMatrix.rot);
	local propertiesProvider:cage_properties_provider = nil;
	
	-- Set camera properties based on camera position
	if (isCameraFront) then
		propertiesProvider = Cage_PropertiesCreateCameraProvider(teamIntroCameraVariables.CONFIG.cameraFrontFOV, teamIntroCameraVariables.CONFIG.cameraFrontFocusDistance, teamIntroCameraVariables.CONFIG.cameraFrontFStop);
	else
		propertiesProvider = Cage_PropertiesCreateCameraProvider(teamIntroCameraVariables.CONFIG.cameraSideFOV, teamIntroCameraVariables.CONFIG.cameraSideFocusDistance, teamIntroCameraVariables.CONFIG.cameraSideFStop);
	end

	Cage_TransformSetDampingSpringConstant(transformProvider, Cage_CalculateDampingSpringConstant(1, blendTime));
	Cage_TransformSetBlendCurve(transformProvider, curve_wrapper(CURVE_BUILT_IN.EaseOutQuad));
	Cage_TransformOSNSetRotationOffsetScale(transformProvider, teamIntroCameraVariables.CONFIG.cameraShakeToTeamShotRot);
	Cage_TransformOSNSetPositionOffsetScale(transformProvider, teamIntroCameraVariables.CONFIG.cameraShakeToTeamShotPos);

	Cage_StackBlendTo(playerCam.stack, transformProvider, propertiesProvider, blendTime);
	
	-- Sleep until arriving at the Team Shot
	SleepSeconds(teamIntroCameraVariables.CONFIG.blendToTeamShot);

	-- Blend 2: Dolly Backwards
	
	-- Get position that we will either dolly or pedestal to
	local movementDirection:vector = nil;

	if (isCameraFront) then
		local forwardNormal:vector = Vector_Normalize(locMatrix.rot.forward);
		movementDirection = forwardNormal * teamIntroCameraVariables.CONFIG.dollyDistance;
		movementDirection = locMatrix.pos + movementDirection;
		locMatrix.angles = locMatrix.angles - teamIntroCameraVariables.CONFIG.dollyRotation;	-- reduce the pitch after dollying back	
	else
		local forwardNormal:vector = Vector_Normalize(locMatrix.rot.forward);
		local forwardMovementDirection:vector = forwardNormal * teamIntroCameraVariables.CONFIG.dollyDistanceSide;
		local upNormal:vector = Vector_Normalize(locMatrix.rot.up);
		movementDirection = upNormal * teamIntroCameraVariables.CONFIG.pedestalDistance;
		movementDirection = locMatrix.pos + movementDirection + forwardMovementDirection;	
		locMatrix.angles = locMatrix.angles + teamIntroCameraVariables.CONFIG.pedestalRotation;	-- increase the pitch after pedestaling down	
	end

	-- Create transform/properties providers
	local dollyTransformProvider:cage_transform_provider = Cage_TransformCreateStaticProvider(movementDirection, locMatrix.rot);
	local dollyPropertiesProvider:cage_properties_provider = Cage_PropertiesClone(propertiesProvider);

	-- Set blend curve depending on camera position
	if (isCameraFront) then
		Cage_TransformSetBlendCurve(dollyTransformProvider, curve_wrapper(CURVE_BUILT_IN.EaseOutSine));
	else
		Cage_TransformSetBlendCurve(dollyTransformProvider, curve_wrapper(CURVE_BUILT_IN.EaseInOutSine));
	end

	-- Set transform properties for this blend
	Cage_TransformSetDampingSpringConstant(transformProvider, Cage_CalculateDampingSpringConstant(1, teamIntroCameraVariables.CONFIG.blendToTeamShotDolly));	
	Cage_TransformOSNSetRotationOffsetScale(dollyTransformProvider, teamIntroCameraVariables.CONFIG.cameraShakeDolly);
	
	Cage_StackBlendTo(playerCam.stack, dollyTransformProvider, dollyPropertiesProvider, teamIntroCameraVariables.CONFIG.blendToTeamShotDolly);	
end

--## SERVER
function team_intro_squad_spawn_group:init():void
	self:InitializeKitDefaults();
end

function team_intro_squad_spawn_group:quit():void
end

function team_intro_squad_spawn_group:BeginRound():void
	self:InitializeSpawnPoints();
end

function team_intro_squad_spawn_group:InitializeSpawnPoints():void
	local spawnPoints = {
		self.components.spawn_0,
		self.components.spawn_1,
		self.components.spawn_2,
		self.components.spawn_3,
	};

	for _, spawn in hpairs(spawnPoints) do
		local old = Object_GetTeamDesignator(spawn);
		local oldSquad = Object_GetMultiplayerSquad(spawn);
		Object_SetTeamDesignator(spawn, MPTeamDesignatorNameToValue[self.team]);
		Object_SetMultiplayerSquad(spawn, MPSquadNameToValue[self.squad]);
		local new = Object_GetTeamDesignator(spawn);
		local newSquad = Object_GetMultiplayerSquad(spawn);
	end
end