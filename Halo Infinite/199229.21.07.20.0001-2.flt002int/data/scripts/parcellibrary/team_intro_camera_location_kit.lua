-- object team_intro_camera_location
-- Copyright (c) Microsoft. All rights reserved.

REQUIRES('globals/scripts/global_multiplayer_init.lua');
REQUIRES('globals/scripts/global_hstructs.lua');
REQUIRES('globals/scripts/global_cage.lua');

hstructure team_intro_camera_location
	meta:table;				-- required
	instance:luserdata;		-- required (must be first slot after meta to prevent crash)
	components:userdata;	-- required (used to reference game objects that make up a kit, and allows you to do KITS.myKitInstance.components:Object_GetName("myComponent")

	-- Player Data
	team:string;			--$$ METADATA {"prettyName": "Team Designator", "source": ["Defender", "Attacker", "Third Party", "Fourth Party", "Fifth Party", "Sixth Party", "Seventh Party", "Eighth Party", "Neutral"]}
	squad:string;			--$$ METADATA {"prettyName": "Squad", "source": ["Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Gamma", "Hotel"]}
	playerPanType:string;	--$$ METADATA {"prettyName": "Player Intro Pan", "source": ["Random", "Left to Right", "Right to Left"]}
	cameraPosition:string;	--$$ METADATA {"prettyName": "Camera Position", "source": ["Front", "Left", "Right"]}
end

global teamIntroVariables:table =
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

function team_intro_camera_location:init()
	self:ValidateDefaults();
end

function team_intro_camera_location:ValidateDefaults():void
	self.playerPanType = self.playerPanType or "Right to Left";
	self.cameraPosition = self.cameraPosition or "Front";
	self.squad = self.squad or "Alpha";
end

function team_intro_camera_location:AddToStack(playerCam, snapToCamera:boolean):void -- Can't add typing to param since CageSystem isn't compiled first
	local blendTime:number = teamIntroVariables.CONFIG.blendToTeamShot
	if (snapToCamera) then
		blendTime = 0;
	end

	-- Blend 1: Move to Team Shot and blend to new Camera Properties 
	local locMatrix:matrix = ToLocation(self.components.camera_location).matrix;
	local transformProvider:cage_transform_provider = Cage_TransformCreateStaticProvider(locMatrix.pos, locMatrix.rot);
	local propertiesProvider:cage_properties_provider = nil;
	
	-- Set camera properties based on camera position
	if (self.cameraPosition == "Front") then
		propertiesProvider = Cage_PropertiesCreateCameraProvider(teamIntroVariables.CONFIG.cameraFrontFOV, teamIntroVariables.CONFIG.cameraFrontFocusDistance, teamIntroVariables.CONFIG.cameraFrontFStop);
	else
		propertiesProvider = Cage_PropertiesCreateCameraProvider(teamIntroVariables.CONFIG.cameraSideFOV, teamIntroVariables.CONFIG.cameraSideFocusDistance, teamIntroVariables.CONFIG.cameraSideFStop);
	end

	Cage_TransformSetDampingSpringConstant(transformProvider, Cage_CalculateDampingSpringConstant(1, blendTime));
	Cage_TransformSetBlendCurve(transformProvider, curve_wrapper(CURVE_BUILT_IN.EaseOutQuad));
	Cage_TransformOSNSetRotationOffsetScale(transformProvider, teamIntroVariables.CONFIG.cameraShakeToTeamShotRot);
	Cage_TransformOSNSetPositionOffsetScale(transformProvider, teamIntroVariables.CONFIG.cameraShakeToTeamShotPos);

	Cage_StackBlendTo(playerCam.stack, transformProvider, propertiesProvider, blendTime);
	
	-- Sleep until arriving at the Team Shot
	SleepSeconds(teamIntroVariables.CONFIG.blendToTeamShot);

	-- Blend 2: Dolly Backwards
	
	-- Get position that we will either dolly or pedestal to
	local movementDirection:vector = nil;

	if (self.cameraPosition == "Front") then
		local forwardNormal:vector = Vector_Normalize(locMatrix.rot.forward);
		movementDirection = forwardNormal * teamIntroVariables.CONFIG.dollyDistance;
		movementDirection = locMatrix.pos + movementDirection;
		locMatrix.angles = locMatrix.angles - teamIntroVariables.CONFIG.dollyRotation;	-- reduce the pitch after dollying back	
	else
		local forwardNormal:vector = Vector_Normalize(locMatrix.rot.forward);
		local forwardMovementDirection:vector = forwardNormal * teamIntroVariables.CONFIG.dollyDistanceSide;
		local upNormal:vector = Vector_Normalize(locMatrix.rot.up);
		movementDirection = upNormal * teamIntroVariables.CONFIG.pedestalDistance;
		movementDirection = locMatrix.pos + movementDirection + forwardMovementDirection;	
		locMatrix.angles = locMatrix.angles + teamIntroVariables.CONFIG.pedestalRotation;	-- increase the pitch after pedestaling down	
	end

	-- Create transform/properties providers
	local dollyTransformProvider:cage_transform_provider = Cage_TransformCreateStaticProvider(movementDirection, locMatrix.rot);
	local dollyPropertiesProvider:cage_properties_provider = Cage_PropertiesClone(propertiesProvider);

	-- Set blend curve depending on camera position
	if (self.cameraPosition == "Front") then
		Cage_TransformSetBlendCurve(dollyTransformProvider, curve_wrapper(CURVE_BUILT_IN.EaseOutSine));
	else
		Cage_TransformSetBlendCurve(dollyTransformProvider, curve_wrapper(CURVE_BUILT_IN.EaseInOutSine));
	end

	-- Set transform properties for this blend
	Cage_TransformSetDampingSpringConstant(transformProvider, Cage_CalculateDampingSpringConstant(1, teamIntroVariables.CONFIG.blendToTeamShotDolly));	
	Cage_TransformOSNSetRotationOffsetScale(dollyTransformProvider, teamIntroVariables.CONFIG.cameraShakeDolly);
	
	Cage_StackBlendTo(playerCam.stack, dollyTransformProvider, dollyPropertiesProvider, teamIntroVariables.CONFIG.blendToTeamShotDolly);	
end

function team_intro_camera_location:GetPlayerPanType():string
	return self.playerPanType;
end

function team_intro_camera_location:SetPlayerPanType(value:string):void
	self.playerPanType = value;
end

function team_intro_camera_location:GetCameraPosition():string
	return self.cameraPosition;
end

function team_intro_camera_location:SetCameraPosition(value:string):void
	self.cameraPosition = value;
end

function team_intro_camera_location:SetTeam(team:string):void
	self.team = team;
end

function team_intro_camera_location:SetSquad(squad:string):void
	self.squad = squad;
end

--## CLIENT
function team_intro_camera_location:GetDistanceSquaredToPlayer(player:player):number
	-- Returns sq distance to the player if the squads match; math.huge if they don't
	--	NOTE: If we start changing squads during gameplay we may run into race conditions
	if ((MPSquadNameToValue[self.squad] == Player_GetMultiplayerSquad(player))
		and (MPTeamDesignatorNameToValue[self.team] == Player_GetTeamDesignator(player))) then
		return Object_GetDistanceSquaredToObject(player, self.components.camera_location);
	end
	return math.huge;
end