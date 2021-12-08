
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- ============================== GLOBAL LUA EVENTS ================================================
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================



--    _______  __        ______   .______        ___       __          ___________    ____  _______ .__   __. .___________.   .___  ___.      ___      .__   __.      ___       _______  _______ .______      
--   /  _____||  |      /  __  \  |   _  \      /   \     |  |        |   ____\   \  /   / |   ____||  \ |  | |           |   |   \/   |     /   \     |  \ |  |     /   \     /  _____||   ____||   _  \     
--  |  |  __  |  |     |  |  |  | |  |_)  |    /  ^  \    |  |        |  |__   \   \/   /  |  |__   |   \|  | `---|  |----`   |  \  /  |    /  ^  \    |   \|  |    /  ^  \   |  |  __  |  |__   |  |_)  |    
--  |  | |_ | |  |     |  |  |  | |   _  <    /  /_\  \   |  |        |   __|   \      /   |   __|  |  . `  |     |  |        |  |\/|  |   /  /_\  \   |  . `  |   /  /_\  \  |  | |_ | |   __|  |      /     
--  |  |__| | |  `----.|  `--'  | |  |_)  |  /  _____  \  |  `----.   |  |____   \    /    |  |____ |  |\   |     |  |        |  |  |  |  /  _____  \  |  |\   |  /  _____  \ |  |__| | |  |____ |  |\  \----.
--   \______| |_______| \______/  |______/  /__/     \__\ |_______|   |_______|   \__/     |_______||__| \__|     |__|        |__|  |__| /__/     \__\ |__| \__| /__/     \__\ \______| |_______|| _| `._____|
--                                                                                                   

global EventManager =
{
	events = {},
	instanceName = "EventManager",
	parentParcel = nil,

	initialized = false,
	eventsDisabled = false,		-- can be set to true from parent parcels in order to block the emission of events
		
	enableDebugPrint = false,
	noOwner = "noOwner",
};

-- === creates a new instance of the event manager so that we can have localized events
--	RETURNS:  a table that has the EventManager table as it's metatable
function EventManager:New(name, parent)
	local newManager = table.addMetatableRecursive(self);
	newManager.instanceName = name or self.instanceName;
	newManager.parentParcel = parent;
	return newManager;
end

--
-- === stores the parcel that owns this event manager
--
--  RETURNS: void
function EventManager:SetParentParcel(parentParcel:table):void
	self.parentParcel = parentParcel;
end

--
-- === toggle disabling the emission of events
--
--  RETURNS: void
function EventManager:SetEventsDisabled(disableEvents:boolean):void
	self.eventsDisabled = (disableEvents == true);
end


--
-- === registers an event with the global event manager
--			event = any
--			
--	RETURNS:  true if successful
function EventManager:RegisterEvent(event):boolean
	assert(self.events[event] == nil, "EventManager: ERROR: cannot register the event because there is already one with the name "..tostring(event));
	self:DebugPrint("Registering an event called", event);
	self.events[event] = {};
	return true;
end


-- === unregisters an event from the global event manager
--			event = any
--			
--	RETURNS:  boolean if successful
function EventManager:UnRegisterEvent(event):boolean
	if not self.events[event] then
		print(self.instanceName .. ": ERROR: cannot unregister the event because there isn't an event with the name", event);
		return false;
	end
	self:DebugPrint("Unregistering an event called", event);
	self.events[event] = nil;
	return true;
end
EventManager.UnregisterEvent = EventManager.UnRegisterEvent;

-- === registers a function with the global event manager
--			event				= any
--			func				= the function you want to call when the event is triggered
--			owner(optional)		= this will be passed in as the first parameter when the function is called
--	RETURNS:  boolean
function EventManager:RegisterCallBack(event, func, owner):boolean
	return self:RegisterCallbackInternal(event, func, owner, function() end);
end
EventManager.RegisterCallback = EventManager.RegisterCallBack;

function EventManager:RegisterCallbackOnce(event, func, owner):boolean
	return self:RegisterCallbackInternal(event, func, owner, EventManager.UnregisterCallback)
end

function EventManager:RegisterCallbackInternal(event, func, owner, unregisterFunc):boolean
	unregisterFunc = unregisterFunc or true
	if self.events[event] == nil then
		print(self.instanceName .. ": ERROR: failed to register a callback for event", event, ". because the event doesn't exist");
		return false;
	end
	self:DebugPrint("Registering a callback for event", event);
	local owner = owner or self.noOwner;
	
	self.events[event] = self.events[event] or {};
	self.events[event][owner] = self.events[event][owner] or {};
	self.events[event][owner][func] = unregisterFunc;
	
	return true;
end


-- === unregisters a function with the global event manager
--			event				= any
--			func				= the function you want to unregister from the event
--			owner(optional)		= the argument that has been stored to be returned with the callback
--	RETURNS:  boolean
function EventManager:UnRegisterCallBack(event, func, owner):boolean
	if self.events[event] == nil then
		print(self.instanceName .. ": ERROR: failed trying to unregister a callback for event", event, ". No such event");
		return false;
	end
	local owner = owner or self.noOwner;
		
	if self.events[event][owner] == nil then
		return false;
	end

	if self.events[event][owner][func] == nil then
		return false;
	end

	self.events[event][owner][func] = nil;

	--garbage collect the tables if those tables are empty
	if owner ~= self.noOwner and table.countKeys(self.events[event][owner]) == 0 then
		self.events[event][owner] = nil;
	end

	return true;
end
EventManager.UnregisterCallback = EventManager.UnRegisterCallBack;


-- === triggers an event in the global event manager; the event functions will be executed in individual threads
--			event = any
--			...		= the parameters that will be passed into the called functions that are registered with the event
--	RETURNS:  void

function EventManager:TriggerEvent(event, ...):void
	self:DebugPrint("TriggerEvent: ", event);
	self:TriggerEventInternal(true, event, unpack(arg));
end

-- === triggers an event in the global event manager; the event functions will be executed serially, in the same thread (i.e. warning, this is BLOCKING)
--			event = any
--			...		= the parameters that will be passed into the called functions that are registered with the event
--	RETURNS:  void

function EventManager:TriggerEventImmediate(event, ...):void
	-- It'd be nice if we could somehow validate that nobody is sleeping during any of these callbacks.. maybe use game_time to check that we're in the same frame as when we started?
	-- This still wouldn't solve basically infinite threads hijacking execution though.
	self:DebugPrint("TriggerEventImmediate: ", event);
	self:TriggerEventInternal(false, event, unpack(arg));
end

function EventManager:TriggerEventInternal(deferredExecution:boolean, event, ...):void
	-- Don't fire events if this parcel is scheduled to end
	if (self.parentParcel ~= nil and (self.parentParcel.directorStop == true or self.parentParcel.directorEnd == true)) then
		return;
	end

	-- Don't fire events if they are currently disabled
	if (self.eventsDisabled == true) then
		return;
	end

	-- We can't fire an event that doesn't exist..
	if self.events[event] == nil then
		print(self.instanceName .. ": ERROR: event", event, "does not exist");
		return;
	end

	-- Fire the event
	local tab = self.events[event];

	for owner, funcTable in hpairs(tab) do
		if owner == self.noOwner then
			for func, unregisterFunc in hpairs(funcTable) do
				unregisterFunc(self, event, func);
				if (deferredExecution == true) then
					CreateThread(func, unpack(arg));
				else
					func(unpack(arg));
				end
			end
		else
			for func, unregisterFunc in hpairs(funcTable) do
				unregisterFunc(self, event, func, owner);
				if (deferredExecution == true) then
					-- Calling ParcelCreateThread here to ensure that threads will be killed properly for hanging callbacks
					-- Note that we have to check the _G table here though because the Parcel interface doesn't exist in Client Lua state
					local parcelCreateThreadFunc:ifunction = _G["ParcelCreateThread"];
					local tableIsParcelFunc:ifunction = _G["TableIsParcel"];
					if (parcelCreateThreadFunc ~= nil and tableIsParcelFunc ~= nil and
						type(owner) == "table" and tableIsParcelFunc(owner)) then
						parcelCreateThreadFunc(owner, func, owner, unpack(arg));
					elseif GetEngineType(owner) == "folder" then
						if PlacedKit_GetComponents(owner) ~= nil and KitIsActive(HandleFromKit(owner)) then
							CreateKitThread(owner, func, owner, unpack(arg));
						end
					elseif GetEngineType(owner) == "object" then
						if object_index_valid(owner) then
							CreateObjectThread(owner, func, owner, unpack(arg));
						else
							print("Parcel Event Manager: can't run callback because object doesn't exist anymore", GetEngineString(owner));
							print("  ", imguiVars.GetDebugStringForFunction(func));
						end
					else
						CreateThread(func, owner, unpack(arg));
					end
				else
					func(owner, unpack(arg));
				end
			end
		end
	end
end

-- === unregisters all callbacks to events from the eventing list (usually called at the EndShutdown() function of a parcel)
function EventManager:UnregisterAllCallbacks():void
	for event, callbackTable in hpairs(self.events) do
		self.events[event] = {};
	end
end


--   _______   _______ .______    __    __    _______         ___      .__   __.  _______     .___________. _______     _______.___________.
--  |       \ |   ____||   _  \  |  |  |  |  /  _____|       /   \     |  \ |  | |       \    |           ||   ____|   /       |           |
--  |  .--.  ||  |__   |  |_)  | |  |  |  | |  |  __        /  ^  \    |   \|  | |  .--.  |   `---|  |----`|  |__     |   (----`---|  |----`
--  |  |  |  ||   __|  |   _  <  |  |  |  | |  | |_ |      /  /_\  \   |  . `  | |  |  |  |       |  |     |   __|     \   \       |  |     
--  |  '--'  ||  |____ |  |_)  | |  `--'  | |  |__| |     /  _____  \  |  |\   | |  '--'  |       |  |     |  |____.----)   |      |  |     
--  |_______/ |_______||______/   \______/   \______|    /__/     \__\ |__| \__| |_______/        |__|     |_______|_______/       |__|     
-- 

function EventManager:DebugPrint(...):void
	if (self.enableDebugPrint) then
		print(self.instanceName .. ":", unpack(arg));
	end	
end

function EventManager:EnableDebugPrint(enable:boolean):void
	self.enableDebugPrint = enable;
end


--DEBUG and TEST functions
--print all global event names
function EventManager:PrintAllEvents()
	print(self.instanceName .. ": printing out all events");
	for name in pairs(self.events) do
		print("   ", name);
	end
	print(self.instanceName .. ": done printing out all events");
end



--check to see if an event is registered
function EventManager:IsEventRegistered(event):boolean
	print(self.instanceName .. ": Checking if event is registered");
	if self.events[event] then
		print(self.instanceName .. ": event", event, "is registered with", #self.events[event], "events");
		return true;
	end
	print(self.instanceName .. ": event is not registered");
	return false;
end

--check to see if a function is registered
function EventManager:IsFunctionRegistered(func):boolean
	print(self.instanceName .. ": Checking if function is registered");
	for event, ownerTable in hpairs(self.events) do
		for owner, funcTable in hpairs(ownerTable) do
			if funcTable[func] ~= nil then
				print(self.instanceName .. ": function is registered to event:", event);
				return true;
			end
		end
	end
	
	print(self.instanceName .. ": function is not registered");
	return false;
end


--make the EventManager table read-only
table.makeTableReadOnlyRecursive(EventManager);

--   __________   ___      ___      .___  ___. .______    __       _______     _______.
--  |   ____\  \ /  /     /   \     |   \/   | |   _  \  |  |     |   ____|   /       |
--  |  |__   \  V  /     /  ^  \    |  \  /  | |  |_)  | |  |     |  |__     |   (----`
--  |   __|   >   <     /  /_\  \   |  |\/|  | |   ___/  |  |     |   __|     \   \    
--  |  |____ /  .  \   /  _____  \  |  |  |  | |  |      |  `----.|  |____.----)   |   
--  |_______/__/ \__\ /__/     \__\ |__|  |__| | _|      |_______||_______|_______/    
--                                                                                     
--examples
----## SERVER
----keeping these commented out so that people have examples of using the globalEventManager, but we aren't adding extra functions for no reason
--function RegisterWaveEndEvent(func, ...)
--	print ("registering a wave end event");
--	globalEventManagerServer:RegisterCallBack("onWaveEnd", func, unpack(arg));
--end
--
--function CallWaveEndEvent()
--	globalEventManagerServer:TriggerEvent("onWaveEnd", "wave1", "round1");
--end
--
--function testwaveend()
--	--globalEventManager(Testfoo, "blah", "blah2");
--	--globalEventManager:RegisterEvent( testEvents.Testfoo);
--	RegisterWaveEndEvent(testEvents.Testfoo, testEvents)
--	Sleep(2);
--	globalEventManagerServer:IsFunctionRegistered( testEvents.Testfoo);
--	globalEventManagerServer:IsEventRegistered("onWaveEnd");
--	CallWaveEndEvent();
--end
------
--global testEvents = {};
--function testEvents:Test()
--	self.eventsa = EventManager:New("test event");
--	self.eventsa:RegisterEvent("onPlayerEnter"); 
--	Sleep(1);
--	self.eventsa:RegisterCallBack("onPlayerEnter", self.Testfoo, self); 
--	Sleep(1);
--	print (self);
--	self.eventsa:TriggerEvent("onPlayerEnter", "player1", "team_red");
--	
--	
--	Sleep(2);
--	self.eventsa:UnRegisterCallBack("onPlayerEnter", self.Testfoo);
--	self.eventsa:TriggerEvent("onPlayerEnter", "player1", "team_red");
--	
--	print (self.eventsa:IsFunctionRegistered(self.Testfoo));
--	Sleep(2);
	
	--table.self:DebugPrint(self.eventsa.events[1], false);
	
	--self.eventsa:UnRegisterEvent("onPlayerEnter");
	--self.eventsa:TriggerEvent("onPlayerEnter", "player1", "team_red");
	
	
	--checking second table event
--	self.eventsb = EventManager:New();
--	self.eventsb:RegisterEvent("onPlayerEnter"); 
--	Sleep(1);
--	self.eventsb:RegisterCallBack("onPlayerEnter", self.Testfoo, self); 
--	Sleep(1);
--	print (self);
--	self.eventsb:TriggerEvent("onPlayerEnter", "player2", "team_blue");
--end
--
--function testEvents:Testfoo(str1:string, str2:string, str3:string)
--	print (self);
--	print (str1);
--	print (str2);
--	print (str3);
--end

--    _______  __        ______   .______        ___       __          ___________    ____  _______ .__   __. .___________.   .___  ___.      ___      .__   __.      ___       _______  _______ .______          _______.
--   /  _____||  |      /  __  \  |   _  \      /   \     |  |        |   ____\   \  /   / |   ____||  \ |  | |           |   |   \/   |     /   \     |  \ |  |     /   \     /  _____||   ____||   _  \        /       |
--  |  |  __  |  |     |  |  |  | |  |_)  |    /  ^  \    |  |        |  |__   \   \/   /  |  |__   |   \|  | `---|  |----`   |  \  /  |    /  ^  \    |   \|  |    /  ^  \   |  |  __  |  |__   |  |_)  |      |   (----`
--  |  | |_ | |  |     |  |  |  | |   _  <    /  /_\  \   |  |        |   __|   \      /   |   __|  |  . `  |     |  |        |  |\/|  |   /  /_\  \   |  . `  |   /  /_\  \  |  | |_ | |   __|  |      /        \   \    
--  |  |__| | |  `----.|  `--'  | |  |_)  |  /  _____  \  |  `----.   |  |____   \    /    |  |____ |  |\   |     |  |        |  |  |  |  /  _____  \  |  |\   |  /  _____  \ |  |__| | |  |____ |  |\  \----.----)   |   
--   \______| |_______| \______/  |______/  /__/     \__\ |_______|   |_______|   \__/     |_______||__| \__|     |__|        |__|  |__| /__/     \__\ |__| \__| /__/     \__\ \______| |_______|| _| `._____|_______/    
--                                                                                                                                                                                                                        


--## SERVER
--creates the global event manager
global globalEventManagerServer = {};
function startup.CreateGlobalEventManager()
	globalEventManagerServer = EventManager:New("global");
end

--print all global server event names in a friendly name
function PrintAllGlobalEvents()
	globalEventManagerServer:PrintAllEvents();
end


--## CLIENT
--creates the global event manager
global globalEventManagerClient = {};
function startupClient.CreateGlobalEventManager()
	globalEventManagerClient = EventManager:New("global");
end

--print all global client event names in a friendly name
function PrintAllGlobalEvents()
	globalEventManagerClient:PrintAllEvents();
end