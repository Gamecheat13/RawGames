-- object primitive_teleporter : communication_object_base_class

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER
REQUIRES('objects\sandbox_objects\communication_base_objects\communication_object_base_class\communication_object_base_class.lua');

hstructure primitive_teleporter : communication_object_base_class
	usePadOrientation:boolean --$$ METADATA { "prettyName": "Use Pad Orientation", "tooltip": "Will orient the teleported object using the pad's orientation" }
	receiveOnly:boolean --$$ METADATA { "prettyName": "Receive Only", "tooltip": "Doesn't send - don't play active FX" }
end

global g_teleporterIgnoreList = table.makePermanent
{
	[TAG('objects\armor\attachments\attachment_abilities\ability_grapple_hook\ability_grapple_hook.projectile')] = true,
	[TAG('objects\armor\attachments\attachment_abilities\ability_grapple_hook\ability_grapple_hook_chief.projectile')] = true,
	[TAG('objects\armor\attachments\attachment_abilities\ability_grapple_hook\ability_grapple_hook_taser.projectile')] = true,
};

global g_teleporterPlayComposition = table.makePermanent
{
	[OBJECT_TYPE._object_type_vehicle] = true,
	[OBJECT_TYPE._object_type_projectile] = false,
	[OBJECT_TYPE._object_type_biped] = true,
	["Other"] = true,
};

global TeleporterParcel = CommNodeBaseParcel:CreateParcelInstance();
TeleporterParcel.CONST = 
{
	compositionTag = TAG('objects\primitives\teleporter\composition\primitive_teleporter.composition'),
	dissolveMarker = "fx_root",
	phaseInID = "phase_in",
	phaseOutID = "phase_out",
	reEnableDelay = 1.0
};

function primitive_teleporter:init():void
	if self.receiveOnly == true then	
		object_set_function_variable(self, "sender", 0, 0);
	else
		object_set_function_variable(self, "sender", 1, 0);
	end
	-- create the parcel
	local parcel:table = TeleporterParcel:New(self);

	-- need to listen for when activation changes, ie power and control are both on, or either is off
	parcel:SetActivatedUpdateFunction(parcel.OnActivatedUpdate);

	-- base object handles power, control, and ownership, but we need to listen for paired teleporter interactions
	parcel:SetReceiveFunction(commObjectChannelsEnum.relayObject, parcel.OnTeleportRequest);

	parcel:SetRunFunction(parcel.OnStart);

	self:ParcelAddAndStartOnSelf(parcel, "Teleporter_"..tostring(self));
end

function TeleporterParcel:OnStart():void
	self.receiveOnly = self.managedObject.receiveOnly or false;
	self.doNotTeleport = SetClass:New();
	self.readyToTeleport = SetClass:New();
	self.currentlyTeleporting = SetClass:New();
	self.composerData = {};

	if self.receiveOnly == false then
		self:RegisterEventOnSelf(g_eventTypes.phantomEnteredEvent, self.OnObjectEntered, self.managedObject);
		self:RegisterEventOnSelf(g_eventTypes.phantomExitedEvent, self.OnObjectExited, self.managedObject);		
	end
end

function TeleporterParcel:OnActivatedUpdate():void
	if self.isActivated == true then
		self:ActivateTeleporter();
	else
		self:DeactivateTeleporter();
	end
end

function TeleporterParcel:ActivateTeleporter():void
	if self.receiveOnly == false then
		-- Need to teleport anything that was on the teleporter when it comes online
		for obj in set_elements(self.readyToTeleport) do
			self:TeleportObject(obj);
		end
		self.readyToTeleport:Clear();
	end
end

function TeleporterParcel:DeactivateTeleporter():void
	if self.receiveOnly == false then
		self.doNotTeleport:Clear();
		self.currentlyTeleporting:Clear();
	end
end

function TeleporterParcel:OnObjectEntered(eventArgs:PhantomEnteredEventStruct):void
	if g_teleporterIgnoreList[Object_GetDefinition(eventArgs.enteringObject)] ~= nil then return; end
	if self:IsTeleportingObject(eventArgs.enteringObject) then return; end

	if self.isActivated == true then
		self:TeleportObject(eventArgs.enteringObject);
	else
		self.readyToTeleport:Insert(eventArgs.enteringObject);
	end
end

function TeleporterParcel:OnObjectExited(eventArgs:PhantomExitedEventStruct):void
	if self:IsTeleportingObject(eventArgs.exitingObject) then return; end

	self.readyToTeleport:Remove(eventArgs.exitingObject);

	self:CreateThread(self.ReEnableTeleportThread, eventArgs.exitingObject);
end

function TeleporterParcel:ReEnableTeleportThread(exitingObject:object):void
	SleepSeconds(self.CONST.reEnableDelay);
	self.doNotTeleport:Remove(exitingObject);
end

function TeleporterParcel:TeleportObject(objectToTeleport:object):void
	if self.doNotTeleport:Contains(objectToTeleport) == false then
		self:DebugPrint("Teleporting "..tostring(objectToTeleport));
		self:BroadcastSend(commObjectChannelsEnum.relayObject, objectToTeleport);
	end
end

function TeleporterParcel:OnTeleportRequest(eventArgs:CommunicationObjectRelayObjectEventStruct):void
	local objectToTeleport = eventArgs.target;
	if objectToTeleport ~= nil then
		if self.isActivated == true and not self:IsTeleportingObject(objectToTeleport) then
			self.currentlyTeleporting:Insert(objectToTeleport);
			self.doNotTeleport:Insert(objectToTeleport);
			self:DebugPrint("Receiving "..tostring(objectToTeleport));
			self:CreateThread(self.TeleportThread, objectToTeleport, eventArgs.broadcaster);
		end
	else
		self:DebugPrint(self.parcelName, " received teleport request but target was nil");
	end
end

function TeleporterParcel:TeleportThread(target:object, broadcaster:object):void
	if not self:IsTeleportingObject(target) then return; end

	local destination:location = nil;
	local targetVelocity:vector = ObjectGetVelocity(target);
	local fxMarker:string = self.CONST.dissolveMarker;

	if Object_GetMarkerWorldPosition(target, fxMarker) == vector(0, 0, 0) then
		fxMarker = "root";
	end

	if self.managedObject.usePadOrientation ~= true then
		-- Get the targets current offset from the "sending" teleporter
		local targetCurrentOffset:vector = ToLocation(target).vector - ToLocation(broadcaster).vector;
		destination = ToLocation(ToLocation(self.managedObject).vector + targetCurrentOffset);
	else
		destination = location(self.managedObject, "mkr_teleporter");
		targetVelocity = destination.matrix.rot.forward * targetVelocity.length;
	end

	object_dissolve_from_marker(target, self.CONST.phaseOutID, fxMarker);

	RunClientScript("TeleportFrom", broadcaster, target);

	local playComposition = self:ShouldPlayComposition(target);

	if playComposition then
		self:PlayTeleportCompositionThread(target);
	end

	object_teleport(target, destination);
	SleepOneFrame();

	if not self:IsTeleportingObject(target) then return; end
	object_dissolve_from_marker(target,  self.CONST.phaseInID, fxMarker);
			
	-- If the player is holding back, reduce the exit velocity
	if Object_IsPlayer(target) then
		if unit_action_test_move_relative_back(target) and targetVelocity.length > 0 then
			targetVelocity = targetVelocity / math.sqrt(targetVelocity.length);
			unit_action_test_reset(target);
		end
	else
		MedalManager_TrackTeleportedObject(target);
	end

	RunClientScript("TeleportTo", self.managedObject, target);

	if playComposition then
		self:PlayTeleportCompositionThread(target);
	end

	ObjectSetWorldVelocity(target, targetVelocity);
	self.currentlyTeleporting:Remove(target);		
end

function TeleporterParcel:PlayTeleportCompositionThread(objectToTeleport):void
	self.composerData.target = objectToTeleport;
	PlayerControlFadeOutAllInputForPlayer(objectToTeleport, 0);
	local comp = composer_play_show_tag(self.CONST.compositionTag, self.composerData);
	SleepUntil([|composer_show_is_playing(comp) == false], 1, 90);
	PlayerControlFadeInAllInputForPlayer(objectToTeleport, 0.05);

	composer_stop_show(comp);

	self:OnCompositionFinished(objectToTeleport);
end

function TeleporterParcel:OnCompositionFinished(objectToTeleport:object):void
	if Engine_ObjectExists(objectToTeleport) == false then
		self.currentlyTeleporting:Remove(objectToTeleport);
	end
end

-- Helpers
function TeleporterParcel:IsTeleportingObject(someObject:object):boolean
	if someObject == nil then return false;	end
	return self.currentlyTeleporting:Contains(someObject);
end

function TeleporterParcel:ShouldPlayComposition(someObject:object):boolean
	local objectType:object_type = Engine_GetObjectType(someObject);

	if (g_teleporterPlayComposition[objectType] ~= nil) then
		return g_teleporterPlayComposition[objectType];
	end

	if (g_teleporterPlayComposition["Other"] ~= nil) then
		return g_teleporterPlayComposition["Other"];
	end

	return false;
end

--## CLIENT
global g_teleporterNodeGraphEvents = table.makePermanent
{
	[OBJECT_TYPE._object_type_vehicle] =
		{
			startEvent = "audio_object_teleporter_start_vehicle",
			arriveEvent = "audio_object_teleporter_arrive_vehicle",
		},
	[OBJECT_TYPE._object_type_projectile] =
		{
			startEvent = "audio_object_teleporter_start_projectile",
			arriveEvent = "audio_object_teleporter_arrive_projectile",
		},
	["LocalPlayerBiped"] =
		{
			startEvent = "audio_object_teleporter_start_biped_player",
			arriveEvent = "audio_object_teleporter_arrive_biped_player",
		},
	["NonLocalPlayerBiped"] =
		{
			-- "nonplayer" is confusing, but is what Audio is using to mean "biped not controlled by a local player"
			startEvent = "audio_object_teleporter_start_biped_nonplayer",
			arriveEvent = "audio_object_teleporter_arrive_biped_nonplayer",
		},
	["Other"] =
		{
			startEvent = "audio_object_teleporter_start_other",
			arriveEvent = "audio_object_teleporter_arrive_other",
		},
};

function TeleporterParcelGetClientObjectKey(someObject:object):string
	local objectType:object_type = Engine_GetObjectType(someObject);
	local eventKey;

	if (objectType == OBJECT_TYPE._object_type_biped) then
		if (Object_IsPlayer(someObject) and
			Player_IsLocal(Unit_GetPlayer(someObject))) then
			eventKey = "LocalPlayerBiped";
		else
			eventKey = "NonLocalPlayerBiped";
		end
	elseif (g_teleporterNodeGraphEvents[objectType] ~= nil) then
		eventKey = objectType;
	else
		eventKey = "Other";
	end

	return eventKey;
end

function remoteClient.TeleportFrom(from:object, who:object)
	local eventKey = TeleporterParcelGetClientObjectKey(who);
	local startEvent = g_teleporterNodeGraphEvents[eventKey].startEvent;
	if (startEvent ~= nil) then
		ObjectNodeGraph_NotifyGetGameEventNode(from, startEvent);
	end
end

function remoteClient.TeleportTo(to:object, who:object)
	local eventKey = TeleporterParcelGetClientObjectKey(who);
	local arriveEvent = g_teleporterNodeGraphEvents[eventKey].arriveEvent;
	if (arriveEvent ~= nil) then
		ObjectNodeGraph_NotifyGetGameEventNode(to, arriveEvent);
	end
end