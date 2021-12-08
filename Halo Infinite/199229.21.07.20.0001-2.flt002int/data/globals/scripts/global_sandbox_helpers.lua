-- Copyright (c) Microsoft. All rights reserved.

-- These disposition functions will be superceded Real Soon Now(TM) by engine calls
-- https://343.visualstudio.com/Guardian/_workitems/edit/138615

-- clamp "value" to the range [low, high]
function Clamp(value:number, low:number, high:number) : number
	return math.max(math.min(high, value), low);
end

-- return angle normalized to the [-180, 180] range
function AngleNormalizeDegrees(angle:number) : number
	angle = math.fmod(angle, 360);
	if angle > 180 then
		return angle - 360;
	elseif angle < -180 then
		return angle + 360;
	end
	return angle;
end

-- return the angle between initial and final going the shortest way around
function DeltaAngleDegrees(initial:number, final:number) : number
	return AngleNormalizeDegrees(final - initial);
end

-- lerp between two vectors
function VectorLerp(startPos:vector, endPos:vector, lerp:number): vector
	return startPos + (endPos - startPos) * lerp;
end

--## SERVER
-- Because object_set_velocity requries an object-relative vector, this function is needed when setting an object's world-relative velocity
function ObjectSetWorldVelocity (thisObject:object, desiredWorldVelocity:vector)
	local objToWorld:matrix = GetObjectTransform(thisObject);
	local worldToObjSpace:matrix = objToWorld.inverse;
	local convertedObjVelocity = worldToObjSpace:rotate(desiredWorldVelocity);

	object_set_velocity(thisObject, convertedObjVelocity.x, convertedObjVelocity.y, convertedObjVelocity.z);
end

global sandboxTypes = table.makeAutoEnum
{
	"shield_emitter",
	"control_terminal",
	"power_generator",
	"power_socket",
	"hacking_terminal",
	"turret_node",
	"comms_jammer",
	"health_station",
	"sentinel_spawner",
	"hardlight_bridge",
	"gravity_lift",
	"teleporter",
	"energy_field_emitter",
	"watch_tower",
	"conductor",
	"regen_emitter",
	"automated_turret_node",
	"base_gate",
	"power_beam_emitter",
	"power_beam_turret",
};

global salvageSize = table.makeAutoEnum
{
	Engine_ResolveStringId("small"),
	Engine_ResolveStringId("medium"),
	Engine_ResolveStringId("large"),
	Engine_ResolveStringId("huge"),
};

global commNodeObjectTypes = table.makeAutoEnum
{
	"shield_emitter",
	"control_terminal",
	"power_generator",
	"power_socket",
	"hacking_terminal",
	"turret_node",
	"bridge",
	"gravity_lift",
	"teleporter",
	"damage_field_emitter",
	"watch_tower",
	"conductor",
	"regen_emitter",
	"automated_turret_node",
	"base_gate",
	"power_beam_emitter",
	"power_beam_turret",
	"door_networked",
};

global commNodeStateTypes = table.makeAutoEnum
{
	"isPowered",
	"isIntact",
	"isScriptLocked",
	"isUnderEMP",
	"ownerTeam",
};

global emitter_variant_mappings:table =
{
	["health_regen"] = Engine_ResolveStringId("health_regen"),
	["shield_regen"] = Engine_ResolveStringId("shield_regen"),
	["full_regen"] = Engine_ResolveStringId("full_regen"),

	["shock"] = Engine_ResolveStringId("shock"),
	["plasma"] = Engine_ResolveStringId("plasma"),
	["hardlight"] = Engine_ResolveStringId("hardlight"),
	["kinetic"] = Engine_ResolveStringId("kinetic"),
};

global commNodeStates = table.makePermanent
{
	[commNodeStateTypes.isPowered]		= {name = "isPowered",		ShouldTravel = function(direction) return direction == "down" end,
											ValueAsNumber = function(value) if value then return 1 else return 0 end end, changeTime = 0.2 };
	[commNodeStateTypes.isIntact]		= {name = "isIntact",		ShouldTravel = function(direction) return false end,
											ValueAsNumber = function(value) if value then return 1 else return 0 end end, changeTime = 0.2 },
	[commNodeStateTypes.isScriptLocked]	= {name = "isScriptLocked", ShouldTravel = function(direction) return false end,
											ValueAsNumber = function(value) if value then return 1 else return 0 end end, changeTime = 0.2 },
	[commNodeStateTypes.isUnderEMP]		= {name = "isUnderEMP",		ShouldTravel = function(direction) return true end,
											ValueAsNumber = function(value) if value then return 1 else return 0 end end, changeTime = 0.2 },
	[commNodeStateTypes.ownerTeam]		= {name = "ownerTeam",		ShouldTravel = function(direction) return direction == "down" end,
											ValueAsNumber = function(value)
													assert(value ~= nil, "error: cannot set a comm node to nil team. If a hacking terminal was used, ensure that the hackng player is on a team.")
													local designatorNumber:number = mpTeamDesignatorToNumber[value]
													return (designatorNumber/10)
												end, 
											changeTime = 0.2 },
};

global commNodeHelpers:table = {}

global g_deadSpartanConstants = table.makePermanent
{
    shield_1 = "core_shield_capacity_bonus_1";
    shield_2 = "core_shield_capacity_bonus_2";
    shield_3 = "core_shield_capacity_bonus_3";
};

function commNodeHelpers.GetCommNodeParcelFromKit(upstreamCommNodeKit):table
	if upstreamCommNodeKit == nil then
		--print("upstream comm node kit given was nil, forming no connection.")
		return nil
	else
		if upstreamCommNodeKit.GetSingleCommNodeObj then
			local upstreamObject = upstreamCommNodeKit:GetSingleCommNodeObj()
			if upstreamObject then
				return commNodeHelpers.GetCommNodeParcelFromObject(upstreamObject, upstreamCommNodeKit)
			else
				print("Failure: ", upstreamCommNodeKit, "returned nil when GetSingleCommNodeObj was called.")
			end
		else
			print("Failure: ", upstreamCommNodeKit, "can't be connected to anything because it lacks the GetSingleCommNode function.")
		end
	end
	print("Failed to get upstream object parcel.")
	return nil
end

function commNodeHelpers.GetCommNodeParcelFromObject(commNodeObject, commNodeKit):table
	if commNodeObject.governingParcel then
		if commNodeObject.governingParcel.commNodeParcel then
			return commNodeObject.governingParcel.commNodeParcel;
		else
			print("The governing parcel for object", commNodeObject, "did not return a comm node parcel for the kit ", commNodeKit)
		end
	else
		print("The comm node object", commNodeObject, "did not return a governing parcel for the kit ", commNodeKit)
	end
end

function commNodeHelpers.MakeDefaultInitStates(governingParcel):table
	local ownerTeam:mp_team_designator = (governingParcel.ownerTeam);
	--print("assigning owner team: ", ownerTeam, "to", governingParcel.instanceName)

	-- hack fix because for some reason, the above logic often returns nil
	if ownerTeam == nil then
		ownerTeam = MP_TEAM_DESIGNATOR.Third;
		Object_SetTeamDesignator(governingParcel.governedObject, ownerTeam);
	end

	local initStates = {
			[commNodeStateTypes.isPowered]		= true,
			[commNodeStateTypes.isIntact]		= true,
			[commNodeStateTypes.isScriptLocked]	= false,
			[commNodeStateTypes.isUnderEMP]		= false,
			[commNodeStateTypes.ownerTeam]		= ownerTeam, -- must be an MP_TEAM_DESIGNATOR
	}
	return initStates
end

function commNodeHelpers.GetGoverningParcelDefaultName(parcel):string
	local objectName:string = tostring(Object_GetName(parcel.governedObject)) or "InvalidName"
	local commNodeTypeName:string = tostring(table.getEnumValueAsString(commNodeObjectTypes, parcel.CONFIG.commNodeObjectType))
	local fullName:string = objectName .. " " .. commNodeTypeName
	--print("name of ", parcel, "is", fullName)
	return fullName
end


global emitter_constants = table.makePermanent
{
	damageTick = 0.5,
	regenTick = 0.033,
	healthAmount = 0.0083,
	shieldAmount = 0.0083,
	markerNames =
	{
		sphere	= "mkr_sphere",
	},
};

global g_sandboxHelpers = table.makePermanent
{
	searchRadius = 4,
	cosSearchAngle = 45,
	healAmount = 1.0,
	ownerPlayerHealPercent = 0.5,
	ownerPlayerHealDelay = 1,
	mpPointMultiplier = 100,
	overshieldDuration = 5,
}

global socketData:table = 
{
	CONST =
	{
		maxPower		= 8,
		timerLength		= 1,
		delayWhenFull	= 2,
	},
	markerNames =
	{
		capacitorWeapon	= "fx_root",
		capacitorCrate	= "fx_root",
		socketMount		= "mkr_battery_attach",
		socketInteract	= "mkr_interact",
	},
	interactToFilterTable	= {},
	playerToCapacitorTable	= {},
};

-- TEAM / DISPOSITION FUNCTIONS

-- Until Campaign teams are fixed, team checks must eveluate player and human teams as allies or else marines will trigger Chief's abilities
-- Note: For now, to unblock campaign first playable, all "you/your" values need to be the potential enemy object or player being evaluated 
function GetCampaignDisposition(myCampaignTeam:team, yourCampaignTeam:team) : disposition
	if (yourCampaignTeam == nil or yourCampaignTeam == TEAM.human or yourCampaignTeam == TEAM.player or yourCampaignTeam == TEAM.neutral) then
		yourCampaignTeam = TEAM.player;
	end

	if (myCampaignTeam == nil or myCampaignTeam == TEAM.human or myCampaignTeam == TEAM.player or myCampaignTeam == TEAM.neutral) then
		myCampaignTeam = TEAM.player;
	end

	if yourCampaignTeam ~= myCampaignTeam then
		return DISPOSITION.Enemy
	else
		return DISPOSITION.Allied;
	end
end

-- SERVER

function GetDisposition(myMPTeam:mp_team, yourMPTeam:mp_team, myCampaignTeam:team, yourCampaignTeam:team) : disposition
	local result:disposition = Engine_GetMPTeamDisposition(myMPTeam, yourMPTeam);
	if (yourCampaignTeam ~= nil and yourCampaignTeam ~= TEAM.human and yourCampaignTeam ~= TEAM.player and yourCampaignTeam ~= TEAM.neutral) then
		result = DISPOSITION.Enemy;
	end

	return result;
end

function GetDispositionPlayerPlayer(me:player, you:player) : disposition
	local myMPTeam:mp_team = Player_GetMultiplayerTeam(me);
	local yourMPTeam:mp_team = Player_GetMultiplayerTeam(you);
	local myCampaignTeam:team = Player_GetCampaignTeam(me);
	local yourCampaignTeam:team = Player_GetCampaignTeam(you);
	return GetDisposition(myMPTeam, yourMPTeam, myCampaignTeam, yourCampaignTeam);
end

function GetDispositionPlayerObject(me:player, you:object) : disposition
	local myMPTeam:mp_team = Player_GetMultiplayerTeam(me);
	local yourMPTeam:mp_team = Object_GetMultiplayerTeam(you);
	local myCampaignTeam:team = Player_GetCampaignTeam(me);
	local yourCampaignTeam:team = Object_GetCampaignTeam(you);
	return GetDisposition(myMPTeam, yourMPTeam, myCampaignTeam, yourCampaignTeam);
end

-- Sandbox Ability Team Checks
-- Comparing two objects
function GetMpDispositionObjectObject(me:object, you:object) : disposition
	local myMPTeam:mp_team = Object_GetMultiplayerTeam(me);
	local yourMPTeam:mp_team = Object_GetMultiplayerTeam(you);
	return GetDisposition(myMPTeam, yourMPTeam);
end

-- Keeping "me" as a required argument so we can properly evaluate two teams in the future without needing to update all the places this function is called
function GetCampaignDispositionObjectObject(me:object, you:object) : disposition
	local myCampaignTeam:team = Object_GetCampaignTeam(me);
	local yourCampaignTeam:team = Object_GetCampaignTeam(you);
	return GetCampaignDisposition(myCampaignTeam, yourCampaignTeam);
end

-- Player and Object
function GetCampaignDispositionPlayerObject(me:player, you:object) : disposition
	local myCampaignTeam:team = Player_GetCampaignTeam(me);
	local yourCampaignTeam:team = Object_GetCampaignTeam(you);
	return GetCampaignDisposition(myCampaignTeam, yourCampaignTeam);
end

--Apparently Navpoint_ calls after Navpoint_Create must appear in a certain order. so DO NOT MESS WITH THE NAVPOINT_ ORDER! 
--Furthermore, the prints are just a little safety nets for designers. 
function NavpointBuilder(navMarkerViewer:player, objectToMark:object, navpointMarker:string, navpointName:string, displayLocation:navpoint_bar, displayStyle:navpoint_draw, visibleTo:string ) : navpoint
	local np:navpoint;
	if (navpointName ~= nil) then
		np = Navpoint_Create(navpointName);
		Navpoint_SetObjectParent(np, objectToMark);
		if navpointMarker ~= nil then
			Navpoint_SetObjectMarker(np, navpointMarker);
		end
		Navpoint_SetEnabled(np, true);
		Navpoint_SetBarDrawMode(np, displayLocation, displayStyle);
		Navpoint_SetBarProgress(np, displayLocation, object_get_shield(objectToMark));
		if visibleTo == "all" then
			Navpoint_VisibilityFilter_SetPlayersAllDefaultFilter(np, true);
		else
			Navpoint_VisibilityFilter_SetPlayersAllDefaultFilter(np, false);
			if visibleTo == "oneClient" then
				Navpoint_VisibilityFilter_SetPlayerDefaultFilter(np, navMarkerViewer, true);
			elseif visibleTo == "alliesOnly" then
				for _, player in hpairs(players()) do
					if (GetDispositionPlayerPlayer(player, navMarkerViewer) == DISPOSITION.Allied) then
						Navpoint_VisibilityFilter_SetPlayerDefaultFilter(np, player, true);
					end
				end
			elseif visibleTo == "enemiesOnly" then
				for _, player in hpairs(players()) do
					if (GetDispositionPlayerPlayer(player, navMarkerViewer) == DISPOSITION.Allied) then
						Navpoint_VisibilityFilter_SetPlayerDefaultFilter(np, player, true);
					end
				end
			else
				print("NavpointBuilder: ''visibleTo'' not specified or misspelled; no nav points created.")
				return nil;
			end
		end
		return np;
	end
	return nil;
end

-- COMMON

function ShowGenericBanner(viewer:player, text:string)
	local objective = Engine_CreateObjective("splash_message");
    local filter = Objective_Filter_CreatePlayerMaskFilter(objective);

	Objective_SetFormattedText(objective, text);
	Objective_Filter_SetPlayer(objective, filter, viewer, true);
end

function GameIsNetworked() : boolean
	return (PLAYERS.local0 == nil)
end

function AbilityDeathNavpoint(self)
	local np:navpoint = NavpointBuilder(self.ownerPlayer, self, "root", "ability_destroyed", NAVPOINT_BAR.Top, NAVPOINT_DRAW.Always, "all");
end


------------------------------------------------------------
----------------------- Overshields ------------------------
------------------------------------------------------------
global g_OvershieldThreadMap = {}

function OvershieldRemover(aPlayer:player, malleablePropertyID:number):void
	SleepUntil([| object_get_shield(aPlayer) <= 1], 1);
	RemoveMalleablePropertyModifier(malleablePropertyID);
	if g_OvershieldThreadMap[aPlayer] ~= nil then
		if g_OvershieldThreadMap[aPlayer].timer ~= nil then
			KillThread(g_OvershieldThreadMap[aPlayer].timer);
		end
	end
	g_OvershieldThreadMap[aPlayer] = nil;
end

function OvershieldTimer(aPlayer:player, malleablePropertyID:number, duration:number):void
	local shieldStartTime:time_point = Game_TimeGet();
	local fullShieldsValue:number = 1;

	sleep_s(duration)
	local currentShield:number = object_get_shield(aPlayer);
	if currentShield > fullShieldsValue then
		object_set_shield(aPlayer, fullShieldsValue);
	end
	RemoveMalleablePropertyModifier(malleablePropertyID);
	if g_OvershieldThreadMap[aPlayer] ~= nil then
		if g_OvershieldThreadMap[aPlayer].remover ~= nil then
			KillThread(g_OvershieldThreadMap[aPlayer].remover);
		end
	end
	g_OvershieldThreadMap[aPlayer] = nil;
end
