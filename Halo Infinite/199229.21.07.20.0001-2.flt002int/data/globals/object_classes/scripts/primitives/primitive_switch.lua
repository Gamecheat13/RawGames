-- object primitive_switch : communication_object_base_class
-- Copyright (c) Microsoft. All rights reserved.

--## SERVER
REQUIRES('globals\object_classes\scripts\primitives\primitive_switch_object_base_class.lua');

hstructure primitive_switch : communication_object_base_class
	oneTimeUse:boolean;                    --$$ METADATA {"prettyName": "One Time Use", "tooltip": "Do we only want to interact with this switch once?"}           
	interactMarkerOverride:string;         --$$ METADATA {"prettyName": "Interact Marker Override", "tooltip": "An optional override to define the marker where the device control is."}
	actionStringID:string;                 --$$ METADATA {"prettyName": "Action String ID", "tooltip": "An optional override to define the action string for the switch."}
	compositionTag:tag;                    --$$ METADATA {"prettyName": "Composition Tag",  "tooltip": "An optional composition to play when the switch is interacted with.", "allowedExtensions": ["composition"]}
	lastInteracter:object;
end

global g_switchNodeGraphEvents = table.makePermanent
{
	switchInteract = "audio_object_switch_interact"
};

global SwitchParcel = SwitchBaseParcel:CreateParcelInstance();
SwitchParcel.doNotChangeOnInteract = false;
SwitchParcel.CONST = 
{
	 defaultInteractMarker = "interact",
	 maxPower = 1,
	 noPower = 0,
};

function primitive_switch:init():void
	local variantId = ObjectGetVariant(self);
	local parcelName:string = "Switch_"..tostring(self);	
	if variantId ~= nil then
		local parcel:table = SwitchParcel:New(self);
		parcel.variantId = variantId;

		parcel:SetRunFunction(parcel.OnStart);
		parcel:SetInitialStateDeterminedFunction(parcel.OnAfterCommNodeInit);
		parcel:SetPowerUpdateFunction(parcel.OnPowerUpdate);
		parcel:SetInteractFunction(parcel.OnInteract);
		parcel:SetOwnershipUpdateFunction(parcel.OnOwnershipUpdate);

		self:ParcelAddAndStartOnSelf(parcel, "Switch_"..tostring(self));
	else
		self:DebugPrint(parcelName, "did not have variant assigned, aborting initialization");
	end
end

-- getters
function primitive_switch:GetLastInteracter()
	return self.lastInteracter;
end

-- Setters
function primitive_switch:SetSpartanTracking(value:boolean):void
	local enabled:boolean = value and self.parcelInstance.isActivated == true;
	ObjectSetSpartanTrackingEnabled(self, enabled);
end

function SwitchParcel:SetPowerLevel(powerLevel:number):void
	local newPowerLevel:number = math.min(self.CONST.maxPower, math.max(self.CONST.noPower, powerLevel));
	local hasPower:boolean = newPowerLevel > self.CONST.noPower;

	self.currentPowerLevel = newPowerLevel;
	
	-- Check if valid as well because we call this function via SwitchWatcherParcel:Shutdown 
	if self.interactObject ~= nil and self:HaveValidInteractObject() then
		Device_SetPower(self.interactObject, self.currentPowerLevel);
	else
		print("[SwitchParcel - SetPowerLevel] Validation Error: self.interactObject is invalid.");
	end

	self:ChangePowerState(hasPower);
	self:BroadcastSend(commObjectChannelsEnum.power, hasPower);
end

function SwitchParcel:SetTeam(newTeam:mp_team_designator)
	if newTeam ~= nil then
		self:ChangeOwnership(newTeam);
		self:BroadcastSend(commObjectChannelsEnum.ownership, newTeam);
	end
end

function SwitchParcel:SetIsEnabled(isEnabled:boolean)
	self:ChangeControlState(isEnabled);
	self:BroadcastSend(commObjectChannelsEnum.control, isEnabled);
end

function SwitchParcel:SetDoNotChangeOnInteract(doNotChange:boolean)
	object_set_function_variable(self.managedObject, "doNotChangeOnInteract", doNotChange and 1 or 0, 0);
	self.doNotChangeOnInteract = doNotChange;
end

-- Parcel Overrides

function SwitchParcel:OnStart()
	self:InitializeInteractObject();
end

function SwitchParcel:OnAfterCommNodeInit()
	self:InitializeData();
	self:SetPowerLevel(self.currentPowerLevel);

	if self:IsPowered() then
		self:SetIsEnabled(self.isEnabled);
	end

	if self:HaveValidInteractObject() == true then
		self:SubscribeToInteractEvents();
		self:SetActionString(self.managedObject.actionStringID);
	end
end

function SwitchParcel:OnPowerUpdate():void
	if self:HaveValidInteractObject() then	
		if self:IsPowered() then
			self:SetPowerLevel(self.CONST.maxPower);
			self:SubscribeToInteractEvents();
		else
			self:SetPowerLevel(self.CONST.noPower);
			self:UnsubscribeFromInteractEvents();		
		end
	end
end

function SwitchParcel:OnOwnershipUpdate():void
	if self.ownerTeam ~= nil then
		Object_SetTeamDesignator(self.managedObject, self.ownerTeam);
		-- Update the interact object team as well if we have a valid one
		if self:HaveValidInteractObject() then
			Object_SetTeamDesignator(self.interactObject, self.ownerTeam);
		end
	end
end

function SwitchParcel:OnInteract(eventArgs:InteractEventStruct):void
	local interacter = eventArgs.interacter;
	self.managedObject.lastInteracter = interacter;
	
	self:BroadcastSend(commObjectChannelsEnum.relayObject, interacter);
	
	if self.doNotChangeOnInteract == true then
		return;
	end
	self:SetIsEnabled(not self.isEnabled);

	if IsValidTag(self.managedObject.compositionTag) then
		self.composerData.interactID = composer_play_show_tag(self.managedObject.compositionTag, self.composerData);
	end

	if self.oneTimeUse == true then
		ObjectSetSpartanTrackingEnabled(self.managedObject, false);

		self:UnsubscribeFromInteractEvents();
		self:DestroyInteractObject();
		self:SetPowerLevel(self.CONST.noPower);
	end

	RunClientScript("SwitchSendNodeGraphEvent", interacter, self.managedObject, g_switchNodeGraphEvents.switchInteract);
end

function SwitchParcel:DenyInteract(convoOverride, actionStringOverride)
	self:SetPowerLevel(self.CONST.maxPower);
	if actionStringOverride == nil or actionStringOverride == "" then
		actionStringOverride = "action_hacking_terminal_unavailable"
	end

	-- override string, set switch to not change on interact, register event
	self.denyConversationOverride = convoOverride; -- can be nil.
	self:SetActionString(actionStringOverride);
	self:SetDoNotChangeOnInteract(true);

	if self:IsItemRegistered(g_eventTypes.communicationObjectRelayObject, self.Deny, self.managedObject) == false then
		self:RegisterEventOnSelf(g_eventTypes.communicationObjectRelayObject, self.Deny, self.managedObject);
	end

end

function SwitchParcel:Deny(evt: CommunicationObjectRelayObjectEventStruct)
	if self:IsEnabled() == true then
		self:SetIsEnabled(false);
	end -- hmm, might be better to be something else?
	NarrativeInterface.PlayNarrativeSequence("BLOODGATE_FALSE_PROMPT", { conversationOverride = self:GetDenyConversation() });
end

function SwitchParcel:GetDenyConversation()
	if type(self.denyConversationOverride) == "function" then
		return self.denyConversationOverride()
	end
	return self.denyConversationOverride
end

function SwitchParcel:RestoreInteract()
	-- set action string if it is set
	if not stringIsNullOrEmpty(self.managedObject.actionStringID) then
		self:SetActionString(self.managedObject.actionStringID);
	else
		self:RemoveActionString();
	end
	
	--unregisterevent
--	self:UnregisterEventOnSelf(g_eventTypes.communicationObjectRelayObject, self.Deny, self.managedObject);
	if self:IsItemRegistered(g_eventTypes.communicationObjectRelayObject, self.Deny, self.managedObject) then
		self:UnregisterEventOnSelf(g_eventTypes.communicationObjectRelayObject, self.Deny, self.managedObject);
	end

	--tell switch to change on interact
	self:SetDoNotChangeOnInteract(false);
end

function SwitchParcel:RemoveActionString()
	Device_SetPrimaryActionStringOverride(self.interactObject, nil);
end

-- Class Functions

function SwitchParcel:InitializeInteractObject():void
	self.interactMarkerOverride = self.managedObject.interactMarkerOverride or self.CONST.defaultInteractMarker;
	self:SetInteractObjectFromMarker(self.interactMarkerOverride);
end

function SwitchParcel:InitializeData():void	
	self.oneTimeUse = self.managedObject.oneTimeUse or false;
	self.currentPowerLevel = self.managedObject.currentPowerLevel or self.CONST.maxPower;  
	self.composerData = {};
	self.composerData.location = self.managedObject;

	if self.managedObject.initiallyUnpowered ~= nil and self.managedObject.initiallyUnpowered == true then
		self.currentPowerLevel = self.managedObject.initiallyUnpowered and self.CONST.noPower or self.CONST.maxPower;
	end
end

-- Methods

function SwitchParcel:GetLastInteracter()
	return self.managedObject:GetLastInteracter();
end

--## CLIENT

function remoteClient.SwitchSendNodeGraphEvent(interacter:object, who:object, evt:string_id)
	if PlayerIsLocal(interacter) then
		ObjectNodeGraph_NotifyGetGameEventNode(who, evt);
	end
end

-------------------------------------------------------------------------------------------------------------------------