-- object communication_object_base_class

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER
REQUIRES('globals\scripts\global_hstructs.lua');
REQUIRES('globals\scripts\callbacks\GlobalStateCallbacks.lua');
REQUIRES('globals\scripts\callbacks\GlobalObjectCallbacks.lua');
REQUIRES('globals\scripts\callbacks\GlobalCallbacks.lua');

global debugCommObjectPing:boolean = true;
global g_allCommObjects = {};

hstructure communication_object_base_class
	meta : table
	instance : luserdata
	
	debugPrint:boolean			--$$ METADATA { "prettyName": "Debug Print" }
	initiallyUnpowered:boolean	--$$ METADATA { "prettyName": "Initially Unpowered", "tooltip": "Initial powered state, can be changed later via Power Channel" }
	initiallyDisabled:boolean	--$$ METADATA { "prettyName": "Initially Disabled", "tooltip": "Initial enabled state, can be changed later via Control Channel" }
	skipCallbacksOnInit:boolean	--$$ METADATA { "prettyName": "Skip Callbacks on Init", "tooltip": "If enabled, determining the initial state won't trigger any callbacks" }
	noPowerNoPing:boolean       --$$ METADATA { "prettyName": "Turn off Ping when Unpowered", "tooltip": "When the switch is turned off, it can't be pinged."}
	pingMarker:string			--$$ METADATA { "prettyName": "Ping Line Marker", "tooltip": "The marker that ping lines will connect to" }

	powerChannel:string			--$$ METADATA { "prettyName": "Receiving Power Channel Name", "groupName": "Internal Channels", "tooltip": "The name of the comm object, within the same comm kit, to listen to for power updates" }
	controlChannel:string		--$$ METADATA { "prettyName": "Receiving Control Channel Name", "groupName": "Internal Channels", "tooltip": "The name of the comm object, within the same comm kit, to listen to for control updates" }
	ownershipChannel:string		--$$ METADATA { "visible": false, "prettyName": "Receiving Ownership Channel Name", "groupName": "Internal Channels", "tooltip": "The name of the comm object, within the same comm kit, to listen to for ownership updates" }
	pingedChannel:string		--$$ METADATA { "prettyName": "Receiving Ping Channel Name", "groupName": "Internal Channels", "tooltip": "The name of the comm object, within the same comm kit, to listen to for ping events" }
	objectRelayChannel:string	--$$ METADATA { "prettyName": "Receiving Object Relay Channel Name", "groupName": "Internal Channels", "tooltip": "The name of the comm object, within the same comm kit, to listen to for object relay events" }
	
	broadcastExternalPowerChannel:string		--$$ METADATA { "prettyName": "External Broadcast Power Channel", "groupName": "External Channels", "tooltip": "The string to broadcast power changes on" }
	broadcastExternalControlChannel:string		--$$ METADATA { "prettyName": "External Broadcast Control Channel", "groupName": "External Channels", "tooltip": "The string to broadcast control changes on" }
	broadcastExternalOwnershipChannel:string	--$$ METADATA { "visible": false, "prettyName": "External Broadcast Ownership Channel", "groupName": "External Channels", "tooltip": "The string to broadcast ownership changes on" }
	broadcastExternalPingedChannel:string		--$$ METADATA { "prettyName": "External Broadcast Pinged Channel", "groupName": "External Channels", "tooltip": "The string to broadcast ping events on" }
	broadcastExternalObjectRelayChannel:string	--$$ METADATA { "prettyName": "External Broadcast Object Relay Channel", "groupName": "External Channels", "tooltip": "The string to broadcast object relay events on" }

	externalReceivingChannel:string	--$$ METADATA { "prettyName": "External Receiving Channel", "groupName": "External Channels", "tooltip": "The string to listen on for any comm object event" }

	assignedChannels:table -- the channels and their assigned targets, hydrated by comm kit
	pingChildren:table -- non-comm objects manually added by script to be included in pings
	pingEventRegistered:boolean --if the onPinged event is registered
	parcelInstance:table --the instance of the parcel set from the subclass
	parentKit:object
end

function communication_object_base_class:__DebugImgui()
	local parcel = self.parcelInstance;
	local enabled:boolean = parcel:IsEnabled();
	local powered:boolean =  parcel:IsPowered()
	imguiVars.standardTwoItemInfo("Is Enabled:", enabled);
	imguiVars.standardTwoItemInfo("Is Powered", powered);

	--button to enable
	imguiVars.standardButton(enabled and "Disable" or "Enable", parcel.ChangeControlState, parcel, not enabled);
	ImGui_SameLine();
	--button to power
	imguiVars.standardButton(powered and "Turn Off" or "Turn On", parcel.ChangePowerState, parcel, not powered);

	--debug ping lines
	--show ping children
	imguiVars.standardHeader("Debug Ping Lines", self.__DebugPingLines, self);
end

function communication_object_base_class:__DebugPingLines()
	local parcel = self.parcelInstance;
	--show stored lines
	
	if parcel == nil or parcel.connectionIDTable == nil then
		return;
	end
	ImGui_Spacing();
	
	imguiVars.standardButton("Show Ping Lines", self.sys_ForcePingOnSelf, self);
	ImGui_Columns(3); -- Broadcaster	|	Receiver	|	unique ID	|
		ImGui_Text("Broadcaster");
		ImGui_NextColumn();
		ImGui_Text("Receiver");
		ImGui_NextColumn();
		ImGui_Text("Unique ID");
		ImGui_NextColumn();

		ImGui_Separator();
		for broadcaster, bTable in hpairs(parcel.connectionIDTable) do
			--make this a button to debug
			sys_DebugShowKeyTable(broadcaster);
			ImGui_NextColumn();
			for receiver, uID in hpairs(bTable) do
				sys_DebugShowKeyTable(receiver);
				ImGui_NextColumn();
				imguiVars.multiText(uID);
				ImGui_NextColumn();
			end
		end
		ImGui_Separator();
		ImGui_Spacing();
	ImGui_Columns(1);
end

function communication_object_base_class:sys_ForcePingOnSelf()
	print("force ping on self", self);
	GlobalObjectEventSpartanTrackingPingObjectEvent(self, Player_GetUnit(PLAYERS.player0), SPARTAN_TRACKING_PING_TYPE.CustomActive);
	local parcel = self.parcelInstance;
	if parcel == nil or parcel.connectionIDTable == nil then
		return;
	end
	for broadcaster, bTable in hpairs(parcel.connectionIDTable) do
		--make this a button to debug
		GlobalObjectEventSpartanTrackingPingObjectEvent(broadcaster, Player_GetUnit(PLAYERS.player0), SPARTAN_TRACKING_PING_TYPE.CustomActive);
		for receiver, uID in hpairs(bTable) do
			GlobalObjectEventSpartanTrackingPingObjectEvent(receiver, Player_GetUnit(PLAYERS.player0), SPARTAN_TRACKING_PING_TYPE.CustomActive);
		end
	end
end

function communication_object_base_class:init():void
	if self.initiallyUnpowered == true then
		object_set_function_variable(self, "ispowered", 0, 0);
	else
		object_set_function_variable(self, "ispowered", 1, 0);
	end
	
	--only register on ping if necessary because this event can get very busy
	if not stringIsNullOrEmpty(self.broadcastExternalPingedChannel) then
		self:RegisterPingEvent();
	end
	--make this a weak table?
	--make this a set to get a count
	g_allCommObjects[self] = true;
end

function communication_object_base_class:quit():void
	-- parcelInstance is assigned to this object in CommNodeBaseParcel:New()
	if self.parcelInstance ~= nil then
		ParcelEnd(self.parcelInstance);
		self.parcelInstance = nil;
	end
	g_allCommObjects[self] = nil;
end

function communication_object_base_class:SetReceivingChannel(channel:number, target:any):void
	if self.assignedChannels[channel] == nil then
		self.assignedChannels[channel] = target;
	end
end

function communication_object_base_class:ManuallySetPingParent(target:any):void
	if type(target) == "struct" and target.ManuallyAddPingChild ~= nil then
		target:ManuallyAddPingChild(self);
	else
		self.assignedChannels[commObjectChannelsEnum.pinged] = target;

		if self.parcelInstance ~= nil then
			self.parcelInstance:RegisterReceivingChannel(commObjectChannelsEnum.pinged);
		end
	end
end

function communication_object_base_class:ManuallyAddPingChild(target:object, marker:string_id):void
	if target == nil or object_index_valid(target) == false then
		print("communication_object_base_class:ManuallyAddPingChild.  The Target is nil", self);
		return;
	end
	
	self.pingChildren = self.pingChildren or MapClass:New();
	marker = marker or "NONE";
	if self.pingChildren:Insert(target, marker) == true then
		self:RegisterPingEvent();
		--register a unique deleted event because multiple comm objects can register on the same target
		self:RegisterEventOnceOnSelf(g_eventTypes.objectDeletedEvent, function(self, eventArgs:ObjectDeletedStruct) return self:OnPingChildDeleted(eventArgs) end, target);
	end
end

function communication_object_base_class:OnPingChildDeleted(eventStruct:ObjectDeletedStruct)
	self:RemovePingChild(eventStruct.deletedObject);
end

function communication_object_base_class:ShouldRegisterPingEvents()
	return self.pingEventRegistered;
end

function communication_object_base_class:RegisterPingEvent()
	if self.pingEventRegistered ~= true then
		self.pingEventRegistered = true;
		local parcel = self.parcelInstance;
		if parcel ~= nil then
			parcel:RegisterPingEventOnManagedObject();
		end
	end
end



function communication_object_base_class:RemovePingChild(target:object, marker:string_id):void
	if self.pingChildren == nil then
		return;
	end
	
	if self.pingChildren:Remove(target) == false then
		return;
	end
	--get the unique ID
	local parcel = self.parcelInstance;
	if parcel ~= nil then
		parcel:RemoveConnectionWithTarget(target);
	end
end

function communication_object_base_class:StoreConnectionInfo(parcelID:string_id, uniqueID:number):void
	if self.parcelInstance ~= nil then
		self.parcelInstance:StoreConnectionInfo(parcelID, uniqueID);
	end
end

function communication_object_base_class:RemoveAllConnections():void
	if self.parcelInstance ~= nil then
		self.parcelInstance:RemoveAllConnections();
	end
end

--PARCEL BELOW
global CommNodeBaseParcel:table = Parcel.MakeParcel
	{
		managedObject = nil,
		managedObjectIsAnObject = false,
		receivingChannelCallbacks = nil,
		externalChannels = nil,

		subclassRunFunction = nil, -- the run function set by the subclass
		subclassInitialStateDeterminedFunction = nil, -- function called when the initial state is determined
		subclassPowerUpdateFunction = nil, -- function to call when power state is changed
		subclassControlUpdateFunction = nil, -- function to call when control state is changed
		subclassOwnershipUpdateFunction = nil, -- function to call when ownership state is changed
		subclassActivatedUpdateFunction = nil, -- function to call when object is activated/deactivated
		subclassPingedFunction = nil, -- function to call when object is pinged
		shouldEndFunction = nil, -- the shouldEnd function set by the object type

		powerModifier = nil,
		powerMalleableProperty = get_string_id_from_string("object_communication_node_power_capacity"),

		eventLinkage =
		{
			[commObjectChannelsEnum.power] =
			{
				eventFunction = CommunicationObjectPowerUpdateCallback,
				eventType = g_eventTypes.communicationObjectPowerUpdated,
			},
			[commObjectChannelsEnum.control] =
			{
				eventFunction = CommunicationObjectControlUpdateCallback,
				eventType = g_eventTypes.communicationObjectControlUpdated,
			},
			[commObjectChannelsEnum.ownership] =
			{
				eventFunction = CommunicationObjectOwnershipUpdateCallback,
				eventType = g_eventTypes.communicationObjectOwnershipUpdated,
			},
			[commObjectChannelsEnum.pinged] =
			{
				eventFunction = CommunicationObjectPingedCallback,
				eventType = g_eventTypes.communicationObjectPinged,
			},
			[commObjectChannelsEnum.relayObject] =
			{
				eventFunction = CommunicationObjectRelayObjectCallback,
				eventType = g_eventTypes.communicationObjectRelayObject,
			},
		},

		stateChangeDuration = 
		{
			activated = 0.2,
			power = 0.2,
			enabled = 0.2,
		},

		pingEventIsRegisteredOnManagedObject = nil;
		--ping lines
		connectionIDTable = nil,
		uniqueID = nil,
		connectionInfoTable = nil,
	};


function CommNodeBaseParcel:__DebugImgui()
	local enabled:boolean = self:IsEnabled();
	local powered:boolean =  self:IsPowered()
	imguiVars.standardTwoItemInfo("Is Enabled:", enabled);
	imguiVars.standardTwoItemInfo("Is Powered", powered);

	--button to enable
	imguiVars.standardButton(enabled and "Disable" or "Enable", self.ChangeControlState, self, not enabled);
	--self:ChangeControlState(not self:IsEnabled())
	ImGui_SameLine();
	--button to power
	imguiVars.standardButton(powered and "Turn Off" or "Turn On", self.ChangePowerState, self, not powered);
end
--the subclasses use this method to call functions based on the received state
function CommNodeBaseParcel:SetReceiveFunction(channel:number, func:ifunction):void
	self.receivingChannelCallbacks:Insert(channel, func);
end

function CommNodeBaseParcel:SetRunFunction(func:ifunction):void
	--set the subclasses run function
	self.subclassRunFunction = func;
end

function CommNodeBaseParcel:SetInitialStateDeterminedFunction(func:ifunction):void
	self.subclassInitialStateDeterminedFunction = func;
end

function CommNodeBaseParcel:SetPowerUpdateFunction(func:ifunction):void
	self.subclassPowerUpdateFunction = func;
end

function CommNodeBaseParcel:SetControlUpdateFunction(func:ifunction):void
	self.subclassControlUpdateFunction = func;
end

function CommNodeBaseParcel:SetOwnershipUpdateFunction(func:ifunction):void
	self.subclassOwnershipUpdateFunction = func;
end

function CommNodeBaseParcel:SetActivatedUpdateFunction(func:ifunction):void
	self.subclassActivatedUpdateFunction = func;
end

function CommNodeBaseParcel:SetPingedFunction(func:ifunction):void
	self.subclassPingedFunction = func;
end

--Required Parcel Functions
function CommNodeBaseParcel:New(objectInstance):table
	local parcel = self:CreateParcelInstance();
	parcel.managedObject = objectInstance;
	parcel.receivingChannelCallbacks = MapClass:New();
	parcel.externalChannels = MapClass:New();
	parcel.isComplete = false;
	parcel.standaloneShutdown = false;

	if GetEngineType(parcel.managedObject) == "object" then
		parcel.managedObjectIsAnObject = true;

		-- handle basic power, control, and ownership changes
		parcel:SetBaseReceiveFunctions();
	end
	
	objectInstance.parcelInstance = parcel;

	return parcel;
end

function CommNodeBaseParcel:shouldEnd():boolean
	return self.isComplete;
end

function CommNodeBaseParcel:Run():void
	local obj = self.managedObject;

	self:DebugPrint("CommNode object", obj, "is starting");

	if (not self.managedObject.skipCallbacksOnInit) then
		--set the receiving channels
		self:RegisterAssignedChannels();

		--set any specified external broadcast channels
		self:SetExternalChannels();
	end

	--register for the ping event if the managed object is an object and not a kit
	if self.managedObjectIsAnObject == true then
		self:RegisterEventOnSelf(g_eventTypes.objectDeletedEvent, self.OnDeleted, obj);
		if obj.ShouldRegisterPingEvents ~= nil and obj:ShouldRegisterPingEvents() == true then
			self:RegisterPingEventOnManagedObject()
		end
	end

	--call the subclasses run function
	self:RunSubclassFunction();

	--determine initial state
	self:DetermineInitialState();

	if (self.managedObject.skipCallbacksOnInit) then
		--set the receiving channels
		self:RegisterAssignedChannels();

		--set any specified external broadcast channels
		self:SetExternalChannels();
	end

	--initial state has been pushed, check if the child object has indicated it can be shutdown if standalone
	if self.standaloneShutdown == true then
		self:ShutdownIfStandalone();
	end
end

function CommNodeBaseParcel:RegisterPingEventOnManagedObject()
	if ParcelIsValid(self) and self.pingEventIsRegisteredOnManagedObject ~= true then
		self.pingEventIsRegisteredOnManagedObject = true;
		self:RegisterEventOnSelf(g_eventTypes.spartanTrackingPingObjectEvent, self.OnObjectPinged, self.managedObject);
	end
end

function CommNodeBaseParcel:SetPower(powerOn:boolean):void
	-- the default is on, so we add a "false" modifier to turn it off, and remove it to restore power
	local wasOn:boolean = self.powerModifier == nil;
	if (powerOn ~= wasOn) then
		if (powerOn) then
			RemoveMalleablePropertyModifier(self.powerModifier);
			self.powerModifier = nil;
		else
			self.powerModifier = AddObjectTimedMalleablePropertyModifierBool(self.powerMalleableProperty, 0, false, self.managedObject);
		end

		if self.noPowerNoPing == true then
			ObjectSetSpartanTrackingEnabled(self.managedObject, powerOn);
			--remove ping line connection here?
		end
		
		Object_ForceUpdateMalleableProperties(self.managedObject);
	end
end

function CommNodeBaseParcel:IsPowered():boolean
	return Object_HasCommunicationNodePowerCapacity(self.managedObject);
end

function CommNodeBaseParcel:RunSubclassFunction():void
	--if the subclasses run function isn't nil then run it here
	if self.subclassRunFunction ~= nil then
		self:subclassRunFunction();
	end
end

function CommNodeBaseParcel:RegisterAssignedChannels():void
	-- if assigned channels is nil then object was placed outside of a comm kit
	if self.managedObject.assignedChannels ~= nil then
		self:RegisterReceivingChannel(commObjectChannelsEnum.power, true);
		self:RegisterReceivingChannel(commObjectChannelsEnum.control, true);
		self:RegisterReceivingChannel(commObjectChannelsEnum.ownership, false);
		self:RegisterReceivingChannel(commObjectChannelsEnum.relayObject, false);
	end

	if self.managedObject.externalReceivingChannel ~= nil and self.managedObject.externalReceivingChannel ~= "" then
		self:RegisterEventOnSelf(g_eventTypes.communicationObjectPowerUpdated, self.BroadcastReceived, self.managedObject.externalReceivingChannel);
		self:RegisterEventOnSelf(g_eventTypes.communicationObjectControlUpdated, self.BroadcastReceived, self.managedObject.externalReceivingChannel);
		self:RegisterEventOnSelf(g_eventTypes.communicationObjectOwnershipUpdated, self.BroadcastReceived, self.managedObject.externalReceivingChannel);
		self:RegisterEventOnSelf(g_eventTypes.communicationObjectPinged, self.BroadcastReceived, self.managedObject.externalReceivingChannel);
		self:RegisterEventOnSelf(g_eventTypes.communicationObjectRelayObject, self.BroadcastReceived, self.managedObject.externalReceivingChannel);
	end
end

function CommNodeBaseParcel:RegisterReceivingChannel(channel:number, isPingable:boolean):void
	local assignedChannels:table = self.managedObject.assignedChannels;

	-- see if a channel to an upstream object was assigned
	local upstream:any = assignedChannels[channel];
	if upstream ~= nil then
		-- we can now match the channel and object, and listen on it
		self:RegisterEventOnSelf(self.eventLinkage[channel].eventType, self.BroadcastReceived, upstream);

		if isPingable == true then
			if type(upstream) == "struct" and upstream.ManuallyAddPingChild ~= nil then
				upstream:ManuallyAddPingChild(self.managedObject);
			end
		end
	end
end

function CommNodeBaseParcel:SetBaseReceiveFunctions():void
	self:SetReceiveFunction(commObjectChannelsEnum.power, self.OnBasePowerUpdate);
	self:SetReceiveFunction(commObjectChannelsEnum.control, self.OnBaseControlUpdate);
	self:SetReceiveFunction(commObjectChannelsEnum.ownership, self.OnBaseOwnershipUpdate);
	self:SetReceiveFunction(commObjectChannelsEnum.pinged, self.OnBasePingUpdate);
end

function CommNodeBaseParcel:DetermineInitialState():void
	self.isActivated = nil; -- leaving as nil so initial state doesn't match and will get pushed
	self.noPowerNoPing = self.managedObject.noPowerNoPing or false;

	self:ChangeOwnership(Object_GetTeamDesignator(self.managedObject));

	if self.managedObject.initiallyUnpowered ~= nil then
		self:ChangePowerState(not self.managedObject.initiallyUnpowered)
	else
		self:ChangePowerState(true);
	end
	
	self:UpdatePowerStateObjFunc();

	if self.managedObject.initiallyDisabled ~= nil then
		self:ChangeControlState(not self.managedObject.initiallyDisabled);
	else
		self:ChangeControlState(true);
	end

	self:UpdateControlStateObjFunc();

	if self.subclassInitialStateDeterminedFunction ~= nil then
		self:subclassInitialStateDeterminedFunction();
	end
end

function CommNodeBaseParcel:OnBasePowerUpdate(eventArgs:CommunicationObjectPowerUpdateEventStruct):void
	self:ChangePowerState(eventArgs.isPowered);
end

function CommNodeBaseParcel:ChangePowerState(newState:boolean):void
	if newState ~= nil and newState ~= self:IsPowered() then
		self:SetPower(newState);
		self:DebugPrint("powered = "..tostring(newState));

		if self.subclassPowerUpdateFunction ~= nil then
			self:subclassPowerUpdateFunction();
		end
		
		self:UpdatePowerStateObjFunc();

		self:OnPowerOrControlChange();
	end
end

function CommNodeBaseParcel:UpdatePowerStateObjFunc():void
	-- Adding due to nil _object via AutomationFramework.Tests.Bvt.GameTests.ReusableEngineTests.CampaignSmokeTests(Test).RunCampaignSmokeTestDefaultAsync("TowerEastVisit","TowerSmokeTests.Visit(\"TowerEast\")",AnyPC)
	if self.managedObject ~= nil and object_index_valid(self.managedObject) == true then
		if self:IsPowered() == true then
			object_set_function_variable(self.managedObject, "isPowered", 1, self.stateChangeDuration.power);
		else
			object_set_function_variable(self.managedObject, "isPowered", 0, self.stateChangeDuration.power);
		end
	else
		print("[CommNodeBaseParcel - UpdatePowerStateObjFunc] Validation Error: self.managedObject is nil or invalid.");
	end
end

function CommNodeBaseParcel:OnBaseControlUpdate(eventArgs:CommunicationObjectControlUpdateEventStruct):void
	self:ChangeControlState(eventArgs.isEnabled);
end

function CommNodeBaseParcel:ChangeControlState(newState:boolean):void
	if newState ~= nil and newState ~= self.isEnabled then
		self.isEnabled = newState;
		self:DebugPrint("enabled = "..tostring(self.isEnabled));

		if self.subclassControlUpdateFunction ~= nil then
			self:subclassControlUpdateFunction();
		end

		self:UpdateControlStateObjFunc();

		self:OnPowerOrControlChange();
	end
end

function CommNodeBaseParcel:UpdateControlStateObjFunc():void
	if self.managedObject ~= nil and object_index_valid(self.managedObject) == true then
		if self:IsEnabled() then
			object_set_function_variable(self.managedObject, "isEnabled", 1, self.stateChangeDuration.control);
		else
			object_set_function_variable(self.managedObject, "isEnabled", 0, self.stateChangeDuration.control);
		end
	else
		print("[CommNodeBaseParcel - UpdateControlStateObjFunc] Validation Error: self.managedObject is nil or invalid.");
	end
end

function CommNodeBaseParcel:IsEnabled():boolean
	return self.isEnabled;
end

function CommNodeBaseParcel:OnBaseOwnershipUpdate(eventArgs:CommunicationObjectOwnershipUpdateEventStruct):void
	self:ChangeOwnership(eventArgs.owner);
end

function CommNodeBaseParcel:ChangeOwnership(newOwner:mp_team_designator):void
	if newOwner ~= self.ownerTeam then
		self.ownerTeam = newOwner;
		self:DebugPrint("new owner team = "..tostring(self.ownerTeam));
		
		-- we won't actually change the managed objects team, that could have gameplay ramifications
		-- so we'll let each object parcel handle that

		if self.subclassOwnershipUpdateFunction ~= nil then
			self:subclassOwnershipUpdateFunction();
		end
	end
end

function CommNodeBaseParcel:SetActivated(isActivated:boolean):void
	if (self.isActivated ~= isActivated) then
		self.isActivated = isActivated;
		self:DebugPrint("activated = "..tostring(self.isActivated));
		
		if self.managedObject ~= nil and object_index_valid(self.managedObject) == true then
			object_set_function_variable(self.managedObject, "isActive", self.isActivated and 1 or 0, self.stateChangeDuration.activated);
		else
			print("[CommNodeBaseParcel - SetActivated] Validation Error: self.managedObject is nil or invalid.");
		end

		if (self.subclassActivatedUpdateFunction ~= nil) then
			self:subclassActivatedUpdateFunction();
		end
	end
end

function CommNodeBaseParcel:OnPowerOrControlChange():void
	-- bail out if enabled is nil, as then we're not done initializing
	if (self.isEnabled == nil) then
		return;
	end

	local isPowered:boolean = self:IsPowered();
	self:SetActivated(self.isEnabled == true and isPowered == true);
end

function CommNodeBaseParcel:SetExternalChannels():void
	local obj:object = self.managedObject;
	
	if obj.broadcastExternalPowerChannel ~= nil then
		self.externalChannels:Insert(commObjectChannelsEnum.power, obj.broadcastExternalPowerChannel);
	end

	if obj.broadcastExternalControlChannel ~= nil then
		self.externalChannels:Insert(commObjectChannelsEnum.control, obj.broadcastExternalControlChannel);
	end

	if obj.broadcastExternalOwnershipChannel ~= nil then
		self.externalChannels:Insert(commObjectChannelsEnum.ownership, obj.broadcastExternalOwnershipChannel);
	end

	if obj.broadcastExternalPingedChannel ~= nil then
		self.externalChannels:Insert(commObjectChannelsEnum.pinged, obj.broadcastExternalPingedChannel);
	end

	if obj.broadcastExternalObjectRelayChannel ~= nil then
		self.externalChannels:Insert(commObjectChannelsEnum.relayObject, obj.broadcastExternalObjectRelayChannel);
	end
end

function CommNodeBaseParcel:BroadcastReceived(eventStruct):void -- is a CommunicationObjectBaseEventStruct, but derived classes don't work so well in Profile.
	--if the broadcaster is itself then return
	if eventStruct.broadcaster == self.managedObject then
		return;
	end

	self:DebugPrint("Broadcast received: ", tostring(eventStruct.channel));
	--call the receive function based on the channel sent from the eventStruct
	if self.receivingChannelCallbacks:Contains(eventStruct.channel) == true then
		self:CreateThread(self.receivingChannelCallbacks:Get(eventStruct.channel), eventStruct);
	end
end

function CommNodeBaseParcel:BroadcastSend(channel:any, eventData:any):void
	local linkage:table = self.eventLinkage[channel];

	-- broadcast externally, if needed
	if self.externalChannels:Contains(channel) == true then
		self:DebugPrint("sending external broadcast for channel "..tostring(channel));
		local externalChannel:string = self.externalChannels:Get(channel);
		
		linkage.eventFunction(externalChannel, self.managedObject, eventData);
	end

	-- broadcast to any comm object listeners
	self:DebugPrint("sending comm object broadcast for channel "..tostring(channel));
	linkage.eventFunction(self.managedObject, self.managedObject, eventData);
end

--event callbacks
--gets called if the managed object is an object (this is set automatically in the run function)

--ping events
--this gets called when an object is pinged by a player
function CommNodeBaseParcel:OnObjectPinged(eventStruct:SpartanTrackingPingEventStruct):void
	--print("pinged", eventStruct.pingedObject);
	--if the object was pinged then broadcast out that it was pinged
	self:BroadcastSend(commObjectChannelsEnum.pinged);

	--handle any manually added children
	for child, marker in map_keys(self.managedObject.pingChildren) do
		self:ShowConnections(self.managedObject, child, marker);
	end
end

--this gets called if this object receives a ping event on a ping channel
function CommNodeBaseParcel:OnBasePingUpdate(eventArgs:CommunicationObjectBaseEventStruct):void
	self:DebugPrint("received ping update on", eventArgs.channel);
	self:ShowConnections(eventArgs.broadcaster, self.managedObject, self.managedObject.pingMarker);
end

function CommNodeBaseParcel:ShowConnections(broadcaster:object, receiver:any, marker:string_id):void
	if broadcaster == nil or receiver == nil then
		print("CommNodeBaseParcel: no origin or target specified for ShowConnections", self.managedObject);
		return;
	end
	
	if object_index_valid(broadcaster) == false or object_index_valid(receiver) == false then
		print("CommNodeBaseParcel: OBJECT INDEX INVALID", broadcaster, receiver);
		print("   NOT STORING THE CONNECTION");
		return;
	end

	if marker == "NONE" or marker == "" then marker = nil end
	
	local parcelID:string_id = self:GetParcelID();
	local uniqueID:number, newId = self:GetUniqueId(broadcaster, receiver);

	--check if ping lines were already created
	if newId == true then
		--print("MAKING A NEW CONNECTION");
		if self.managedObject.pingChildren and not self.managedObject.pingChildren:Contains(receiver) then
			self:RegisterEventOnceOnSelf(g_eventTypes.objectDeletedEvent, function(self, eventArgs, parcelID, uniqueID) self:OnBaseCommDestroyed(eventArgs, parcelID, uniqueID) end, receiver, parcelID, uniqueID);
		end
		self:StoreConnectionInfo(parcelID, uniqueID);
	
		if broadcaster ~= self.managedObject then
			RunMethodIfObjectHasMethod(broadcaster, "StoreConnectionInfo", broadcaster, parcelID, uniqueID);
			self:RegisterEventOnceOnSelf(g_eventTypes.objectDeletedEvent, function(self, eventArgs, parcelID, uniqueID) self:OnBaseCommDestroyed(eventArgs, parcelID, uniqueID) end, broadcaster, parcelID, uniqueID);
			
		end
		if receiver ~= self.managedObject then
			RunMethodIfObjectHasMethod(receiver, "StoreConnectionInfo", receiver, parcelID, uniqueID);
		end
	end

	RunClientScript("ShowConnectionEffects", parcelID, self.managedObject, uniqueID, broadcaster, receiver, marker);
end

function CommNodeBaseParcel:GetUniqueId(broadcaster, receiver):number
	if self.connectionIDTable == nil then
		self.connectionIDTable = {};
		self:RegisterEventOnSelf(g_eventTypes.objectDeletedEvent, self.OnBaseCommDestroyed, self.managedObject);
	end		
	
	self.connectionIDTable[broadcaster] = self.connectionIDTable[broadcaster] or {};
	self.uniqueID = self.uniqueID or 0;
	local id = self.connectionIDTable[broadcaster][receiver];
	local newId = false;
	if id == nil then
		newId = true;
		self.uniqueID = self.uniqueID + 1;
		self.connectionIDTable[broadcaster][receiver] = self.uniqueID;
		id = self.connectionIDTable[broadcaster][receiver];

		--can these keys be made weak? no, because we need them to get the unique ID if deleted
	end

	return id, newId;
end

function CommNodeBaseParcel:GetIdFromBroadcasterAndReceiver(broadcaster, receiver)
	return GetTableValue(self.connectionIDTable, broadcaster, receiver);
end

function CommNodeBaseParcel:GetParcelID():number
	self.parcelID = self.parcelID or get_string_id_from_string(GetEngineString(self))
	return self.parcelID;
end

function CommNodeBaseParcel:StoreConnectionInfo(parcelID:string_id, uniqueID:number)
	self.connectionInfoTable = self.connectionInfoTable or {};
	--maybe make this an hstruct
	--can this use the connection ID table?
	self.connectionInfoTable[parcelID] = self.connectionInfoTable[parcelID] or {};
	self.connectionInfoTable[parcelID][uniqueID] = true;
end

--removing ping lines

function CommNodeBaseParcel:RemoveConnectionWithTarget(target):void
	local id = self:GetIdFromBroadcasterAndReceiver(self.managedObject, target);
	if id == nil then
		return;
	end

	--should this remove the connectionIDTable or should the tables be combined?
	local parcelID = self:GetParcelID();
	self:RemoveConnection(parcelID, id);

	local idValue = GetTableValue(self.connectionInfoTable, parcelID, id);
	
	if idValue ~= nil then
		self.connectionInfoTable[parcelID][id] = nil;
	end
	--manually remove self.connectionInfoTable[parcelID][uniqueID] because it might be referenced elsewhere
	self.connectionIDTable[self.managedObject][target] = nil;
end

function CommNodeBaseParcel:RemoveConnection(parcelID:string_id, uniqueID:number):void
	if parcelID == nil or uniqueID == nil then
		return;
	end
	
	RunClientScript("RemoveConnectionEffect",  parcelID, uniqueID);
end

--might need to call this from the mission manager??
function CommNodeBaseParcel:RemoveAllConnections()
	--only send message to client if we've stored a unique ID
	--remove all stored info (like the connection was called on a different object)
	if self.connectionInfoTable ~= nil then
		for parcelID, parcelIDTable in hpairs(self.connectionInfoTable) do
			if parcelID == self:GetParcelID() then
				--if the parcelID is the current parcel then just tell the client with one call to remove the lines
				RunClientScript("RemoveConnectionEffectsFromObject", parcelID);
			else
				for uniqueID, bool in hpairs(parcelIDTable) do
					self:RemoveConnection(parcelID, uniqueID);
				end
			end
		end
	end
end

function CommNodeBaseParcel:OnBaseCommDestroyed(eventArgs, parcelID:string_id, uniqueID:number):void
	-- if the deleted object is the parcel owner then remove all connections associated with the object
	-- note -- this doesn't seem to work if blowing up the object with omnipotent
	if eventArgs.deletedObject == self.managedObject then
		self:RemoveAllConnections();
	else
		self:RemoveConnection(parcelID, uniqueID);
	end
end

--parcel methods

function CommNodeBaseParcel:OnDeleted():void
	self.isComplete = true;
end

function CommNodeBaseParcel:IsChannelValid(channel:string):boolean
	return channel ~= nil and channel ~= "";
end

function CommNodeBaseParcel:CanShutdownIfStandalone():void
	self.standaloneShutdown = true;
end

function CommNodeBaseParcel:ShutdownIfStandalone():void
	-- if every channel is invalid, this object is standalone and its parcel can be shut down
	if self:IsChannelValid(self.managedObject.powerChannel) == false and
	   self:IsChannelValid(self.managedObject.controlChannel) == false and
	   self:IsChannelValid(self.managedObject.ownershipChannel) == false and
	   self:IsChannelValid(self.managedObject.pingedChannel) == false and
	   self:IsChannelValid(self.managedObject.objectRelayChannel) == false and
	   self:IsChannelValid(self.managedObject.broadcastExternalPowerChannel) == false and
	   self:IsChannelValid(self.managedObject.broadcastExternalControlChannel) == false and
	   self:IsChannelValid(self.managedObject.broadcastExternalOwnershipChannel) == false and
	   self:IsChannelValid(self.managedObject.broadcastExternalPingedChannel) == false and
	   self:IsChannelValid(self.managedObject.broadcastExternalObjectRelayChannel) == false and
	   self:IsChannelValid(self.managedObject.externalReceivingChannel) == false then

		self:DebugPrint("shutting down standalone object parcel");
		self.isComplete = true;
	end
end

function CommNodeBaseParcel:DebugPrint(...):void
	if self.managedObject.debugPrint == true then
		print(self.parcelName, ...);
	end
end


--END OF PARCEL

function RemoveAllCommObjectConnections(player:player)
	RunClientScript("RemoveAllConnections", player);
end

--## CLIENT
global pingEffectTable = {};
global pingManagedObjectTable = {};
--set this tables key/value pair to be removed if the key no longer has a reference (this will happen when the object is deleted)
setmetatable(pingManagedObjectTable, { __mode = "k" });

global commObjectEffectTag = TAG('fx\library_olympus\objects\equipment\visor\visor_ping_connection.effect');

function CommObjectCleanupCallback(parcel:string_id)
	--SleepSeconds(1);
	pingEffectTable[parcel] = nil;
end

function remoteClient.ShowConnectionEffects(parcel:string_id, managedObject:object, uniqueID:number, origin:object, target:object, marker:string_id):void
	--error checking is handled on the server
	marker = marker or "fx_root";
	
	--if effect already there then kill effect
	RemoveConnectionEffect(parcel, uniqueID);

	if origin == nil or object_index_valid(origin) == false then
		print("Show Connection Effects: nil or invalid origin for connection effects");
		return;
	end
	--create a new effect
	local pingEffect = connection_effect_new(commObjectEffectTag, origin);
	
	pingEffectTable[parcel] = pingEffectTable[parcel] or {};
	pingEffectTable[parcel][uniqueID] = pingEffect;

	--set a function that will delete the reference in the pingEffectTable when the managed object is deleted
	if pingManagedObjectTable[managedObject] == nil then
		local sentinel = newproxy(true);	   
		-- add a garbage collection callback to our empty object
		getmetatable(sentinel).__gc = function(): void
			-- The cleanup code has to be run in its own thread because the game crashes sometimes otherwise
			CreateThread(CommObjectCleanupCallback, parcel);
		end
	
		pingManagedObjectTable[managedObject] = sentinel;
	end

	Sleep(1);
	--using the reference instead of the local because of multiple show connection events being called on the same frame
	if pingEffectTable[parcel][uniqueID] == pingEffect then
		connection_effect_update(pingEffect, commObjectEffectTag, false, location(target, marker));
	end
end



function remoteClient.RemoveConnectionEffect(parcel:string_id, uniqueID:number)
	RemoveConnectionEffect(parcel, uniqueID);
end

function RemoveConnectionEffect(parcel:string_id, uniqueID:number)
	--error check
	local pingEffect = GetTableValue(pingEffectTable, parcel, uniqueID);
	if pingEffect == nil then
		return;
	end

	HSEffectKillFromEffect(pingEffect);
end

function remoteClient.RemoveConnectionEffectsFromObject(parcel:string_id)
	--iterate through the ping effect table and remove all effects
	local parcelTable = GetTableValue(pingEffectTable, parcel)
	if parcelTable == nil then
		return;
	end

	for id, effect in hpairs(parcelTable) do
		HSEffectKillFromEffect(effect);
	end
end

function remoteClient.RemoveAllConnections(player:player)
	if player ~= nil and not Player_IsLocal(player) then
		return;
	end
	
	for parcel, idTable in hpairs(pingEffectTable) do
		for id, effect in hpairs(idTable) do
			HSEffectKillFromEffect(effect);
		end
	end
end

--DEBUG

--## SERVER
global g_commNodeDebuggerShown = false;
global g_resizeCommNodeWindow = false;

function DebugCommNodeObjects()
	if g_commNodeDebuggerShown == true then
		ImGui_DeactivateCallback("sys_CommNodeDebuggerImGui");
		g_commNodeDebuggerShown = false;
	else
		ImGui_ActivateCallback("sys_CommNodeDebuggerImGui");
		g_commNodeDebuggerShown = true;
	end
end

function sys_CommNodeDebuggerImGui()
	if g_resizeCommNodeWindow == true then
		ImGui_SetNextWindowSize(500, 500);
		g_resizeCommNodeWindow = false;
	end

	if ImGui_Begin("Comm Node Object Debugger") == true then
		--button to resize window
		if ImGui_Button("  Resize Window  ") == true then
			g_resizeCommNodeWindow = true;
		end

		if ImGui_Button("  Close Comm Node Object Debugger  ") == true then
			DebugCommNodeObjects();
		end
		ImGui_Text("");
		
		local commCategories:table = {};

		for obj, bool in hpairs(g_allCommObjects) do
			local name:string = struct.name(obj);
			commCategories[name] = commCategories[name] or {};
			commCategories[name][obj] = true;
		end
		
		--sort by categoryName?
		for categoryName, categoryTable in hpairs(commCategories) do
			--header
			ImGui_PushStringID(categoryName);
			imguiVars.standardHeader(categoryName, function()
				for obj, bool in hpairs(categoryTable) do
					imguiVars.standardHeader(imguiVars.getString("Comm Obj:", obj), sys_DebugTable, obj);
				end
			end);
			ImGui_PopID();
			ImGui_Text("");
		end
	end
	ImGui_End();
end