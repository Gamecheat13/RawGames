--// =============================================================================================================================
-- ============================================ PARCEL MANAGER SCRIPTS ========================================================
-- =============================================================================================================================
--## SERVER

REQUIRES('globals\scripts\global_hstructs.lua');
REQUIRES('globals\scripts\callbacks\GlobalCallbacks.lua');
--  .______      ___      .______        ______  _______  __         .___  ___.      ___      .__   __.      ___       _______  _______ .______      
--  |   _  \    /   \     |   _  \      /      ||   ____||  |        |   \/   |     /   \     |  \ |  |     /   \     /  _____||   ____||   _  \     
--  |  |_)  |  /  ^  \    |  |_)  |    |  ,----'|  |__   |  |        |  \  /  |    /  ^  \    |   \|  |    /  ^  \   |  |  __  |  |__   |  |_)  |    
--  |   ___/  /  /_\  \   |      /     |  |     |   __|  |  |        |  |\/|  |   /  /_\  \   |  . `  |   /  /_\  \  |  | |_ | |   __|  |      /     
--  |  |     /  _____  \  |  |\  \----.|  `----.|  |____ |  `----.   |  |  |  |  /  _____  \  |  |\   |  /  _____  \ |  |__| | |  |____ |  |\  \----.
--  | _|    /__/     \__\ | _| `._____| \______||_______||_______|   |__|  |__| /__/     \__\ |__| \__| /__/     \__\ \______| |_______|| _| `._____|
--                                                                                                                                                   

global ParcelManager = 
{
	eventManager = nil,
	mainThreadID = nil,
};

function ParcelManagerInit()

	InitializeEventManager();

end

function ParcelManagerMain()
	--register the function as running, so it can be started if necessary by an parcel
	dprint ("starting parcel manager");
	
	repeat
		--start all parcels that are in the ParcelHandlerParcelReference.parcels table
		ParcelManagerStartParcels();
		Sleep(1);
	until false;
end

ParcelManager.Main = ParcelManagerMain;

function ParcelManager.Shutdown()
	if ParcelManager.mainThreadID ~= nil then
		-- Shut down ParcelHandler
		ParcelHandler.Shutdown();
				
		-- Clean up Parcel Manager
		ParcelManager.CleanupEventManager();
		
		-- Clean up running thread
		KillThread(ParcelManager.mainThreadID);
		ParcelManager.mainThreadID = nil;
	end
end



--  .______      ___      .______        ______  _______  __         .___  ___.      ___      .__   __.      ___       _______  _______ .______          _______  __    __  .__   __.   ______ .___________. __    ______   .__   __.      _______.
--  |   _  \    /   \     |   _  \      /      ||   ____||  |        |   \/   |     /   \     |  \ |  |     /   \     /  _____||   ____||   _  \        |   ____||  |  |  | |  \ |  |  /      ||           ||  |  /  __  \  |  \ |  |     /       |
--  |  |_)  |  /  ^  \    |  |_)  |    |  ,----'|  |__   |  |        |  \  /  |    /  ^  \    |   \|  |    /  ^  \   |  |  __  |  |__   |  |_)  |       |  |__   |  |  |  | |   \|  | |  ,----'`---|  |----`|  | |  |  |  | |   \|  |    |   (----`
--  |   ___/  /  /_\  \   |      /     |  |     |   __|  |  |        |  |\/|  |   /  /_\  \   |  . `  |   /  /_\  \  |  | |_ | |   __|  |      /        |   __|  |  |  |  | |  . `  | |  |         |  |     |  | |  |  |  | |  . `  |     \   \    
--  |  |     /  _____  \  |  |\  \----.|  `----.|  |____ |  `----.   |  |  |  |  /  _____  \  |  |\   |  /  _____  \ |  |__| | |  |____ |  |\  \----.   |  |     |  `--'  | |  |\   | |  `----.    |  |     |  | |  `--'  | |  |\   | .----)   |   
--  | _|    /__/     \__\ | _| `._____| \______||_______||_______|   |__|  |__| /__/     \__\ |__| \__| /__/     \__\ \______| |_______|| _| `._____|   |__|      \______/  |__| \__|  \______|    |__|     |__|  \______/  |__| \__| |_______/    
--                                                                                                     
--this function starts the parcels in the ParcelHandlerParcelReference.parcels table
--unless they are lower priority and the priority manager is running and checks for duplicate names
function ParcelManagerStartParcels()
	for parcelArg, parcelName in hpairs(ParcelHandlerParcelReference.parcels) do
		-- check for multiple parcels named the same
		if ParcelHandlerParcelReference.possibleParcels[parcelArg] or ParcelHandlerParcelReference.activeParcels[parcelArg] then
			print ("PARCEL MANAGER: TRYING TO CREATE A PARCEL WITH THE SAME NAME AS AN ALREADY ADDED PARCEL", parcelName);		
		--start the ParcelHandlerRun if the priority manager is false or the priority is less than or equal
		elseif b_priorityManagerOn == false or (b_priorityManagerOn == true and parcelArg.priority ~= nil and parcelArg.priority <= g_globalParcelPriority) then
			parcelArg.threadId = CreateThread(ParcelHandlerRun, parcelArg);
			SetThreadName(parcelArg.threadId, parcelName);

			ParcelHandlerParcelReference.possibleParcels[parcelArg] = parcelName;
			--remove the parcel from the parcels table so it doesn't get added again
			ParcelHandlerParcelReference.parcels[parcelArg] = nil;
		end
	end
end

---------------------
-- Priority system --
---------------------

global parcelPriorityEnum = table.makeEnum
	{
		critical = 0,
		high = 1,
		normal = 2,
		low = 3,
		insignificant = 4,
	}

global g_globalParcelPriority = parcelPriorityEnum.insignificant;
global b_priorityManagerOn = false;
global g_PriorityParcels = nil;

function ParcelManagerStopLowerPriorityParcels(priority:number)
	--for loop through all parcels and if the priority is lower then revoke permissions
	if priority ~= nil then
		for parcel, _ in hpairs (ParcelHandlerParcelReference.possibleParcels) do
			if parcel.priority == nil or priority < parcel.priority then
				ParcelRevokePermission(parcel);
			else
				ParcelRestorePermission(parcel);
			end
		end
		--force stop all other active parcels
		for parcel, _ in hpairs (ParcelHandlerParcelReference.activeParcels) do
			if parcel.priority == nil or priority < parcel.priority then
				ParcelStop(parcel);
			end
		end
	end
end

--??called from onStart event? or maybe just from the ParcelHandlerRun function
function ParcelAddPriority(parcelArg:table, priority:number)
	parcelArg.priority = priority;
	g_PriorityParcels:Insert(parcelArg);
	ParcelStartPrioritizing(priority);
	AddOnParcelEndEvent(parcelArg, ParcelRemoveParcelFromPriorityList);
end

function ParcelStartPrioritizing(priority:number)
	b_priorityManagerOn = true;
	if g_globalParcelPriority > priority then
		ParcelSetGlobalParcelPriority(priority);
		ParcelManagerStopLowerPriorityParcels(priority);
	end
end

--called from onStop event if ParcelAddPriority has been called
function ParcelRemoveParcelFromPriorityList(parcelArg:table, parcelEnded:table)
	if g_PriorityParcels:Remove(parcelEnded) == true then
				
		--if there are no more PriorityParcels, then stop prioritizing
		--this means that a manually started priority will be turned off
		if g_PriorityParcels:Count() == 0 then
			ParcelStopPrioritizing();
		else
			--check other parcels in g_PriorityParcels and change the priority level to that
			local newPriorityLevel:number = parcelPriorityEnum.insignificant;
			for parcel in set_elements(g_PriorityParcels) do
				newPriorityLevel = math.min(parcel.priority, newPriorityLevel);
			end
			--reset global priority and start again with new priority level
			ParcelSetGlobalParcelPriority(parcelPriorityEnum.insignificant);
			ParcelStartPrioritizing(newPriorityLevel);
		end
	end
end

function ParcelStopPrioritizing()
	b_priorityManagerOn = false;
	ParcelSetGlobalParcelPriority(parcelPriorityEnum.insignificant);
	ParcelRestorePermissionAll();
end

function ParcelSetGlobalParcelPriority(priority:number)
	g_globalParcelPriority = priority;
end

---------------------
-- Event Manager --
---------------------

function InitializeEventManager()
	g_PriorityParcels = SetClass:New();
	if(ParcelManager.eventManager == nil) then
	
		ParcelManager.eventManager = EventManager:New("ParcelManagerEvents");
		ParcelManager.eventManager:RegisterEvent("OnParcelStart");
		ParcelManager.eventManager:RegisterEvent("OnParcelStop");
		ParcelManager.eventManager:RegisterEvent("OnParcelEnd");
	end
end

function ParcelManager.CleanupEventManager()
	if ParcelManager.eventManager ~= nil then
		ParcelManager.eventManager = nil;
	end
end

function TriggerParcelManagerEvent(eventName, tab)
	ParcelManager.eventManager:TriggerEvent(eventName, tab);
end

function AddOnParcelStartEvent(callbackOwner, callbackFunc:ifunction):void
	ParcelManager.eventManager:RegisterCallBack("OnParcelStart", callbackFunc, callbackOwner);
end

function  RemoveOnParcelStartEvent(callbackOwner, callbackFunc:ifunction):void
	ParcelManager.eventManager:UnRegisterCallBack("OnParcelStart", callbackFunc, callbackOwner);
end

function AddOnParcelStopEvent(callbackOwner, callbackFunc:ifunction):void
	ParcelManager.eventManager:RegisterCallBack("OnParcelStop", callbackFunc, callbackOwner);
end

function  RemoveOnParcelStopEvent(callbackOwner, callbackFunc:ifunction):void
	ParcelManager.eventManager:UnRegisterCallBack("OnParcelStop", callbackFunc, callbackOwner);
end

function AddOnParcelEndEvent(callbackOwner, callbackFunc:ifunction):void
	ParcelManager.eventManager:RegisterCallBack("OnParcelEnd", callbackFunc, callbackOwner);
end

function  RemoveOnParcelEndEvent(callbackOwner, callbackFunc:ifunction):void
	ParcelManager.eventManager:UnRegisterCallBack("OnParcelEnd", callbackFunc, callbackOwner);
end

--  .______      ___      .______        ______  _______  __          __    __       ___      .__   __.  _______   __       _______ .______      
--  |   _  \    /   \     |   _  \      /      ||   ____||  |        |  |  |  |     /   \     |  \ |  | |       \ |  |     |   ____||   _  \     
--  |  |_)  |  /  ^  \    |  |_)  |    |  ,----'|  |__   |  |        |  |__|  |    /  ^  \    |   \|  | |  .--.  ||  |     |  |__   |  |_)  |    
--  |   ___/  /  /_\  \   |      /     |  |     |   __|  |  |        |   __   |   /  /_\  \   |  . `  | |  |  |  ||  |     |   __|  |      /     
--  |  |     /  _____  \  |  |\  \----.|  `----.|  |____ |  `----.   |  |  |  |  /  _____  \  |  |\   | |  '--'  ||  `----.|  |____ |  |\  \----.
--  | _|    /__/     \__\ | _| `._____| \______||_______||_______|   |__|  |__| /__/     \__\ |__| \__| |_______/ |_______||_______|| _| `._____|
--                                                                                                                                               

--the handler tables
global ParcelHandlerParcelReference =
	{
		parcels = {}, 			--holds the total potential parcels 
		possibleParcels = {},	--holds the parcels that have been initialized and are waiting to be started
		activeParcels = {},		--holds the currently running parcels
	};

global ParcelHandler = {};

function _ShutdownParcel(parcelArg:table, immediate:boolean):void
	--remove director stop
	parcelArg.directorStop = false;
	
	--call the parcels cleanup function if it exists (warning, this is blocking)
	if parcelArg.Shutdown and parcelArg.parcelState == parcelStateEnum.running then
		parcelArg:Shutdown();
	end

	--unregister all the events that have been registered to the parcel
	ParcelUnregisterEvents(parcelArg);

	--stop all child parcels that have been registered to the parcel
	ParcelStopAllChildParcels(parcelArg, immediate);

	--kill all the threads from the parcel, that the parcel knows about
	ParcelHandler.KillParcelThreads(parcelArg);

	--remove parcel from active table
	ParcelHandler.RemoveParcelFromActiveTable(parcelArg);

	--log that the parcel has stopped and fire stopped telemetry and events
	ParcelHandler.LogParcelHasStopped(parcelArg);
end

function _EndShutdownParcel(parcelArg:table, immediate:boolean):void
	dprint ("PARCEL HANDLER: parcel", parcelArg.parcelName, "has ended and is shutting down");
	
	--call an end cleanup function if it exists (warning, this is blocking)
	if parcelArg.EndShutdown then
		parcelArg:EndShutdown();
	end

	--end all child parcels that have been registered to the parcel
	ParcelEndAllChildParcels(parcelArg, immediate);
	
	--remove the parcel from possible tables, log that it has ended and remove the can start
	ParcelHandler.ParcelHasEnded(parcelArg);
	dprint ("PARCEL HANDLER: parcel", parcelArg.parcelName, "has ended, has shut down and will never start again");
end

--sleeps until the Start conditions of the parcel are true, then runs the parcel
-- then sleeps until the Stop conditions are true, then kills the threads called by the parcel
-- if the shouldEnd conditions are not true it repeats the cycle
-- if the shouldEnd conditions are true it removes the parcel from the runningParcels table and stops tracking the Start conditions
function ParcelHandlerRun(parcelArg:table)
	dprint ("PARCEL HANDLER: starting parcel", parcelArg.parcelName);

	if not ParcelHandler.MandatoryFunctionCheck(parcelArg) then
		-- Don't start a parcel that doesn't have the required functions
		ParcelHandler.ParcelHasEnded(parcelArg);
		return;
	end

	--fire telemetry
	parcelArg.parcelState = parcelStateEnum.initialized;
	ParcelFireTelemetry(parcelArg);
	--fire events
	ParcelInitializedCallback(parcelArg);
	--call an initialize function if it exists (warning, this is blocking);
	if parcelArg.InitializeForEditor and editor_mode() then
		parcelArg.initializeForEditorThreadID = ParcelCreateThread(parcelArg, parcelArg.InitializeForEditor, parcelArg);
		SleepUntil([| IsThreadValid(parcelArg.initializeForEditorThreadID) == false or ParcelHandler.HasParcelEnded(parcelArg) == true], 1);
	end

	--call parcel's initialize function
	if parcelArg.Initialize and ParcelHandler.HasParcelEnded(parcelArg) ~= true then
		parcelArg.initializeThreadID = ParcelCreateThread(parcelArg, parcelArg.Initialize, parcelArg);
		SleepUntil([| IsThreadValid(parcelArg.initializeThreadID) == false or ParcelHandler.HasParcelEnded(parcelArg) == true], 1);
	end

	--kill the initialize threads if they exist and the parcel has ended
	if ParcelHandler.HasParcelEnded(parcelArg) == true then
		KillThread(parcelArg.initializeForEditorThreadID);
		KillThread(parcelArg.initializeThreadID);
	end

	while ParcelHandler.HasParcelEnded(parcelArg) ~= true do
		--sleep until the shouldStart function is true or the director force ends or starts it
		SleepUntil ([|ParcelHandler.ParcelHasBeenEndedOrCanStart(parcelArg)], 1);
		
		--if the parcel hasn't been ended by external logic then start it and wait for it to be stopped
		if parcelArg.directorEnd ~= true then
			ParcelHandler.ParcelStart(parcelArg);
			SleepUntil ([|ParcelHandler.ShouldParcelStop(parcelArg)], 1);
		end
			
		_ShutdownParcel(parcelArg);
	end

	_EndShutdownParcel(parcelArg);
end



--  .______      ___      .______        ______  _______  __          __    __       ___      .__   __.  _______   __       _______ .______          _______  __    __  .__   __.   ______ .___________. __    ______   .__   __.      _______.
--  |   _  \    /   \     |   _  \      /      ||   ____||  |        |  |  |  |     /   \     |  \ |  | |       \ |  |     |   ____||   _  \        |   ____||  |  |  | |  \ |  |  /      ||           ||  |  /  __  \  |  \ |  |     /       |
--  |  |_)  |  /  ^  \    |  |_)  |    |  ,----'|  |__   |  |        |  |__|  |    /  ^  \    |   \|  | |  .--.  ||  |     |  |__   |  |_)  |       |  |__   |  |  |  | |   \|  | |  ,----'`---|  |----`|  | |  |  |  | |   \|  |    |   (----`
--  |   ___/  /  /_\  \   |      /     |  |     |   __|  |  |        |   __   |   /  /_\  \   |  . `  | |  |  |  ||  |     |   __|  |      /        |   __|  |  |  |  | |  . `  | |  |         |  |     |  | |  |  |  | |  . `  |     \   \    
--  |  |     /  _____  \  |  |\  \----.|  `----.|  |____ |  `----.   |  |  |  |  /  _____  \  |  |\   | |  '--'  ||  `----.|  |____ |  |\  \----.   |  |     |  `--'  | |  |\   | |  `----.    |  |     |  | |  `--'  | |  |\   | .----)   |   
--  | _|    /__/     \__\ | _| `._____| \______||_______||_______|   |__|  |__| /__/     \__\ |__| \__| |_______/ |_______||_______|| _| `._____|   |__|      \______/  |__| \__|  \______|    |__|     |__|  \______/  |__| \__| |_______/    
--                                                                                                           

--start the ParcelManager if it hasn't already started
function ParcelHandler.StartParcelManager()
	if not ParcelManager.mainThreadID then
		ParcelManagerInit();

		dprint ("PARCEL HANDLER: Starting ParcelManager");
		ParcelManager.mainThreadID = CreateThread (ParcelManager.Main);
	end
end

--checks the parcel to make sure it has all the mandatory functions
function ParcelHandler.MandatoryFunctionCheck(parcelArg:table):boolean
	--these checks should be deprecated when all parcels are declared with Parcels.MakeParcel
	if parcelArg.shouldStart == nil then
		dprint ("PARCEL HANDLER: parcel", parcelArg.parcelName, "does not have shouldStart or shouldStop adding them");
		parcelArg.shouldStart = ParcelDefaultShouldStart;
	end
	
	if parcelArg.shouldStop == nil then
		dprint ("PARCEL HANDLER: parcel", parcelArg.parcelName, "does not have shouldStart or shouldStop adding them");
		parcelArg.hasStopFunction = false;
	else
		parcelArg.hasStopFunction = true;
	end
	
	if parcelArg.Run == nil or parcelArg.shouldEnd == nil then
		print ("PARCEL HANDLER: parcel ", parcelArg.parcelName, "does not have all the required functions");
		return false;
	end

	-- "cached" version of the shouldEnd function to avoid metatable walking for things with multiple levels of inheritance like comm objects
	parcelArg.cachedShouldEnd = parcelArg.shouldEnd;

	return true;
end

function ParcelHandler.Shutdown()
	-- Clear parcels
	for parcelArg, _ in hpairs(ParcelHandlerParcelReference.parcels) do
		ParcelHandlerParcelReference.parcels[parcelArg] = nil;
	end
	
	-- Clear possible parcels
	ParcelKillAll();
	
	-- Clear active parcels
	ParcelEndAll();
	SleepUntil([| ParcelHandler:GetNumActiveParcels() == 0 ], 1);
	
	-- TODO: Clear history?
end

function ParcelDefaultShouldStart():boolean
	return true;
end

--returns whether a Parcel has been ended or is allowed to start and can start
function ParcelHandler.ParcelHasBeenEndedOrCanStart(parcelArg:table):boolean
	--return true if the director says to end
	--	or the directorRevoked is not true and the parcel shouldStart
	return parcelArg.directorEnd or (not parcelArg.directorRevoked and (parcelArg.directorStart or parcelArg:shouldStart()));
end

--starts a parcel (makes it active, etc) and tracks it
function ParcelHandler.ParcelStart(parcelArg:table)
	dprint ("PARCEL HANDLER: Parcel", parcelArg.parcelName, "IS STARTING AND LOGGED AS ACTIVE");

	--remove director start so it doesn't loop on/off
	parcelArg.directorStart = false;

	--add it to active table
	ParcelHandlerParcelReference.activeParcels[parcelArg] = parcelArg.parcelName;

	--need to pass in the parcel because of the possibilies of templates
	-- should this start a table of run threads so other disciplines (audio, narrative, etc) can add to it?
	
	parcelArg.runThreadId = CreateThread(parcelArg.Run, parcelArg);
	SetThreadName(parcelArg.runThreadId, parcelArg.parcelName);

	parcelArg.parcelState = parcelStateEnum.running;
	ParcelFireTelemetry(parcelArg);
	--firing event
	ParcelRunCallback(parcelArg);
	TriggerParcelManagerEvent("OnParcelStart", parcelArg);

	--sleep a tick to make sure thread is going
	Sleep(1);
end

--returns whether a Parcel should stop
function ParcelHandler.ShouldParcelStop(parcelArg:table):boolean
	return parcelArg.directorStop or parcelArg.directorEnd or (parcelArg.hasStopFunction and parcelArg:shouldStop()) or parcelArg:cachedShouldEnd();
end

--called after a parcel has stopped, it logs the function and turns off any manager placed variables
function ParcelHandler.LogParcelHasStopped(parcelArg:table)
	dprint ("PARCEL HANDLER: parcel", parcelArg.parcelName, "is stopping");
	--logging the parcel
	parcelArg.parcelState = parcelStateEnum.stopped;
	ParcelFireTelemetry(parcelArg);
	--firing event
	ParcelStopCallback(parcelArg);
	TriggerParcelManagerEvent("OnParcelStop", parcelArg);
end

--kill threads associated with the Parcels as best we can
function ParcelHandler.KillParcelThreads(parcelArg:table)

	if parcelArg.runThreadId ~= nil and IsThreadValid(parcelArg.runThreadId) then
		KillThread(parcelArg.runThreadId);
		parcelArg.runThreadId = nil;
	end
	
	--kill any threads created with ParcelCreateThread
	if parcelArg.threads then
		for k, threadID in hpairs (parcelArg.threads) do
			if GetEngineType(threadID) == "thread" and IsThreadValid(threadID) then
				dprint ("killing thread ", k, "in parcel", parcelArg.parcelName);
				KillThread(threadID);
			end
		end
		parcelArg.threads = nil;
	end
	
	--kill any threads and functions in the parcel table
	for k, func in hpairs (parcelArg) do
		if GetEngineType(func) == "thread" and IsThreadValid(func) and k ~= "threadId" then
			dprint ("killing thread ", k, "in parcel", parcelArg.parcelName);
			KillThread(func);
		elseif type(func) == "function" and IsThreadValid(func) then
			dprint ("killing function ", k, "in parcel", parcelArg.parcelName);
			KillScript(func);
		end
	end
end

--removes a parcel from the active parcels table
function ParcelHandler.RemoveParcelFromActiveTable(parcelArg:table)
	ParcelHandlerParcelReference.activeParcels[parcelArg] = nil;
end

--checks to see if a parcel has ended
function ParcelHandler.HasParcelEnded(parcelArg:table):boolean
	return parcelArg:shouldEnd() or parcelArg.directorEnd == true;
end

function ParcelHandler.ParcelHasEnded(parcelArg:table)
	ParcelHandlerParcelReference.possibleParcels[parcelArg] = nil;
	
	--fire telemetry
	parcelArg.parcelState = parcelStateEnum.ended;
	ParcelFireTelemetry(parcelArg);
	--fire events
	ParcelEndCallback(parcelArg);
	TriggerParcelManagerEvent("OnParcelEnd", parcelArg);
end

function ParcelHandler:GetNumPossibleParcels():number
	return table.countKeys(ParcelHandlerParcelReference.possibleParcels);
end

function ParcelHandler:GetNumActiveParcels():number
	return table.countKeys(ParcelHandlerParcelReference.activeParcels);
end

-- __    __   _______  __      .______    _______ .______          _______  __    __  .__   __.   ______ .___________.__    ______   .__   __.      _______.
--|  |  |  | |   ____||  |     |   _  \  |   ____||   _  \        |   ____||  |  |  | |  \ |  |  /      ||           |  |  /  __  \  |  \ |  |     /       |
--|  |__|  | |  |__   |  |     |  |_)  | |  |__   |  |_)  |       |  |__   |  |  |  | |   \|  | |  ,----'`---|  |----|  | |  |  |  | |   \|  |    |   (----`
--|   __   | |   __|  |  |     |   ___/  |   __|  |      /        |   __|  |  |  |  | |  . `  | |  |         |  |    |  | |  |  |  | |  . `  |     \   \    
--|  |  |  | |  |____ |  `----.|  |      |  |____ |  |\  \----.   |  |     |  `--'  | |  |\   | |  `----.    |  |    |  | |  `--'  | |  |\   | .----)   |   
--|__|  |__| |_______||_______|| _|      |_______|| _| `._____|   |__|      \______/  |__| \__|  \______|    |__|    |__|  \______/  |__| \__| |_______/    
--                                                                                                                                                          



--revoke permissions for a possible parcel
function ParcelRevokePermission(parcelArg:table)
	if ParcelHandlerParcelReference.possibleParcels[parcelArg] ~= nil then
		parcelArg.directorRevoked = true;
		dprint ("revoking permission for parcel", parcelArg.parcelName);
	else
		dprint("ParcelRevoke: failed to revoke permissions for parcel", parcelArg.parcelName);
	end
end
				
--revoke permissions for all possible parcels
function ParcelRevokePermissionAll()
	for parcelArg, _ in hpairs (ParcelHandlerParcelReference.possibleParcels) do
		ParcelRevokePermission(parcelArg);
	end
end

--restore permissions for a possible parcel
function ParcelRestorePermission(parcelArg:table)
	if ParcelHandlerParcelReference.possibleParcels[parcelArg] then
		parcelArg.directorRevoked = false;
		dprint ("giving permission for parcel", parcelArg.parcelName);
	else
		dprint("ParcelRestore: failed to restore permissions for parcel", parcelArg.parcelName);
	end
end

--restore permissions for all possible parcels
function ParcelRestorePermissionAll()
	for parcelArg, _ in hpairs (ParcelHandlerParcelReference.possibleParcels) do
		ParcelRestorePermission(parcelArg);
	end
end





--creates objects and modules from an array and returns a list of the created objects
function ParcelCreateObjects(create_list)
	local obj = nil;
	local obj_list = {};
	for _,item in hpairs (create_list) do
		if GetEngineType(item) == "string" then
			obj = object_create_anew (item);
			dprint ("obj is ",obj);
			--commenting out for now because it can cause lots of new items
--			if not obj then
--				obj = object_create_clone (item);
--			end
			obj_list[#obj_list + 1] = obj;
		elseif GetEngineType(item) == "folder" then
			obj = object_create_folder_anew (item);
			table.combine (obj_list, obj);
		end
	end
	return obj_list;
end

--creates a thread and stores the threadID in the table so it can be tracked, killed, etc.
function ParcelCreateThread(parcelArg:table, func:ifunction, ...):thread
	local name = parcelArg.parcelName or "<name_not_set>";

	function MakeThread(parcelArg:table, func:ifunction, ...):thread
		if parcelArg.isObjectParcel then
			assert(parcelArg._InternalCreateThread ~= nil, "Object Parcel " .. name .. " is missing _InternalCreateThread function. Ensure your parcel inherits from BaseParcel.");
			return parcelArg:_InternalCreateThread(func, ...);
		else
			if parcelArg._InternalCreateThread ~= nil then
				return parcelArg:_InternalCreateThread(func, ...);
			else
				dprint("Parcel " .. name .. " does not inherit from BaseParcel. Ensure your parcel is defined with Parcel.MakeParcel");
				return CreateThread(func, ...);
			end
		end
	end

	local threadId:thread = MakeThread(parcelArg, func, ...);
	if threadId == nil then
		dprint("Failed to create thread for parcel: ", name);
		return nil;
	end

	SetThreadName(threadId, name);
	parcelArg.threads = parcelArg.threads or {};
	parcelArg.threads[threadId] = threadId;
	
	return threadId;
end

function ParcelKillThread(parcelArg:table, parcelThread:thread)
	assert(ParcelIsActive(parcelArg) == true, "Parcel in ParcelKillThread is not an active parcel");
	if parcelArg.threads ~= nil and parcelThread ~= nil then
		parcelArg.threads[parcelThread] = nil;
		KillThread(parcelThread);
	end
end

--registers an event and stores the event in a table in the parcel so it can be unregistered at parcel stop
function ParcelRegisterEvent(parcelArg:table, eventType, callback:ifunction, onItem, ...):void
	CommonParcelRegisterEvent(nil, nil, parcelArg, eventType, callback, onItem, ...);
end

--registers an event and stores the event in a table in the parcel so it can be unregistered at parcel stop
--it also unregisters itself upon firing
function ParcelRegisterEventOnce(parcelArg:table, eventType, callback:ifunction, onItem, ...):void
	CommonParcelRegisterEvent(nil, ParcelEventUnregisterFunction, parcelArg, eventType, callback, onItem, ...);
end

--registers a global event and stores the event in a table in the parcel so it can be unregistered at parcel stop
function ParcelRegisterGlobalEvent(parcelArg:table, eventType, callback:ifunction, ...):void
	ParcelRegisterEvent(parcelArg, eventType, callback, g_allItems, ...);
end

--registers a global event and stores the event in a table in the parcel so it can be unregistered at parcel stop
--it also unregisters itself upon firing
function ParcelRegisterGlobalEventOnce(parcelArg:table, eventType, callback:ifunction, ...):void
	ParcelRegisterEventOnce(parcelArg, eventType, callback, g_allItems, ...);
end

function CommonParcelRegisterEvent(classArg, unregisterFunction:ifunction, parcelArg:table, eventType, callback:ifunction, onItem, ...):void
	assert(parcelArg ~= nil, "CommonParcelRegisterEvent: parcel argument is nil!");
	assert(ParcelIsValid(parcelArg) == true, "CommonParcelRegisterEvent: ParcelIsValid returned false for the given parcel!");
	assert(onItem ~= nil, "CommonParcelRegisterEvent: onItem argument is nil!");
	assert(callback ~= nil, "CommonParcelRegisterEvent: callback argument is nil!");

	local itemKey = onItem;

	--store the event to be removed later
	parcelArg.storedEvents = parcelArg.storedEvents or {};
	parcelArg.storedEvents[eventType] = parcelArg.storedEvents[eventType] or {};

	local itemTable:table = parcelArg.storedEvents[eventType];

	local multipleOnItemStruct:MultipleOnItemArgs = nil;
	--if onItem is a MultipleOnItems struct then make a table structure based on it
	if type(itemKey) == "struct" and struct.name(itemKey) == "MultipleOnItemArgs" then
		local itemKeyNew = nil;
		for _, item in ipairs(itemKey.onItems) do
			itemKeyNew = item;
			--chain the items in the table structure
			itemTable[itemKeyNew] = itemTable[itemKeyNew] or {};
			itemTable = itemTable[itemKeyNew];
		end
		
		--add the parcelArg to the end of the onItems array so that it is included when registering the event
		table.insert(itemKey.onItems, parcelArg);
		multipleOnItemStruct = itemKey;
	else
		itemTable[itemKey] = itemTable[itemKey] or {};
		itemTable = itemTable[itemKey];
		multipleOnItemStruct = BuildMultipleOnItemStruct(itemKey, parcelArg);
	end

	-- Throw an error if we're trying to register a callback twice
	if (itemTable[callback] ~= nil) then
		if (GetRegisterCallbackAssertsDisabled()) then
			print("ERROR: ParcelRegisterEvent: tried to register a callback function twice!  itemKey=", itemKey, " eventType= " .. table.getEnumValueAsString(g_eventTypes, eventType) .. "(" .. tostring(eventType) .. ")");
			return;
		else
			assert(false, "ParcelRegisterEvent: tried to register a callback function twice on " .. GetEngineString(itemKey) .. " and " .. table.getEnumValueAsString(g_eventTypes, eventType));
		end
	end
	multipleOnItemStruct.onItems.n = nil;
	itemTable[callback] = multipleOnItemStruct;

	CommonRegisterFunction(classArg, unregisterFunction, eventType, callback, multipleOnItemStruct, ...);
end

function ParcelEventUnregisterFunction(eventStruct:EventCallbackArgs)
	--make a local hstruct so it doesn't change the original hstruct
	local myItems:MultipleOnItemArgs = BuildMultipleOnItemStruct(unpack(eventStruct.item.onItems));
	
	--removing the parcel when unregistering because it wasn't there when registering
	local numOnItems:number = #myItems.onItems;
	myItems.onItems[numOnItems] = nil;

	ParcelUnregisterEvent(eventStruct.firstArgument, eventStruct.eventType, eventStruct.callback, myItems);
end

--unregister an event registered with the parcel
function ParcelUnregisterEvent(parcelArg:table, eventType, callback:ifunction, onItem):void
	assert(parcelArg.storedEvents ~= nil,
		"Trying to unregister an event callback on a parcel but the parcel doesn't have any stored events.");
	assert(parcelArg.storedEvents[eventType] ~= nil,
		"Trying to unregister a callback on eventType " .. tostring(eventType) .. " but no callbacks with that eventType could be found.");

	local itemsTable:table = nil;
	local eventTable:table = parcelArg.storedEvents[eventType];
	local firstOnItem:any = nil;
	
	local itemKey = onItem;

	if type(itemKey) == "struct" and struct.name(itemKey) == "MultipleOnItemArgs" then
		firstOnItem = itemKey.onItems[1];
		itemsTable = itemKey.onItems;
	else
		firstOnItem = itemKey;
		itemsTable = {itemKey};
	end

	ParcelUnregisterMultipleOnItemsHelper(parcelArg, eventType, eventTable, callback, itemsTable)

	if parcelArg.storedEvents[eventType][firstOnItem] == nil or table.IsEmpty(parcelArg.storedEvents[eventType][firstOnItem]) == true then
		parcelArg.storedEvents[eventType][firstOnItem] = nil;
		if table.IsEmpty(parcelArg.storedEvents[eventType]) == true then
			parcelArg.storedEvents[eventType] = nil;
		end
	end
end

function ParcelUnregisterMultipleOnItemsHelper(parcelArg:table, eventType, eventTable:table, callback:ifunction, onItems:table, index:number)
	index = index or 1;
	local numArgs:number = #onItems;
	local onItem = onItems[index];
	local itemKey = onItem;
	local tableIndex:table = eventTable[itemKey];
		
	--assert that tableIndex is not nil
	assert(tableIndex ~= nil,
		"Trying to unregister a callback on an item " .. tostring(itemKey) .. " but the item was not registered.");
	if index == numArgs then 
		--unregister the event
		UnregisterEvent(eventType, callback, tableIndex[callback]);
		tableIndex[callback] = nil;
	else
		ParcelUnregisterMultipleOnItemsHelper(parcelArg, eventType, tableIndex, callback, onItems, index + 1);
	end
	
	--clean up the tables
	if table.IsEmpty(tableIndex) == true then
		eventTable[onItem] = nil;
	end
end

--unregister a global event registered with the parcel
function ParcelUnregisterGlobalEvent(parcelArg:table, eventType, callback:ifunction):void
	ParcelUnregisterEvent(parcelArg, eventType, callback, g_allItems);
end

--unregister all events registered with the parcel
function ParcelUnregisterEvents(parcelArg:table):void
	if parcelArg.storedEvents ~= nil then
		for event, tableOfOnItems in hpairs(parcelArg.storedEvents) do
			--recurse through this table to find the callback
			ParcelUnregisterEventsHelper(parcelArg, event, tableOfOnItems);
		end
		parcelArg.storedEvents = nil;
	end
	
	--NOTE: this is special case code that removes the volumes from the VolumeEvent system
	
	--remove the volumes from the volumeEventTables
	if parcelArg.eventToVolumeMap ~= nil then
		for volume, count in hpairs(parcelArg.eventToVolumeMap) do
			RemoveVolumeFromVolumeEventTables(volume, count);
		end
		parcelArg.eventToVolumeMap = nil;
	end
	--remove the itemMapping table
	parcelArg.itemMapping = nil;
end

function ParcelUnregisterEventsHelper(parcelArg:table, event, onItemTable:table)
	for k, v in hpairs(onItemTable) do
		if type(v) == "struct" and struct.name(v) == "MultipleOnItemArgs" then
			UnregisterEvent(event, k, v);
		else
			ParcelUnregisterEventsHelper(parcelArg, event, v);
		end
	end
end

--trigger volume events
--this function is used by the Parcel system and shouldn't be used, use ParcelRegisterVolumeOn... functions
function ParcelRegisterVolumeEvent(parcelArg:table, eventType:string, volume:volume, func:ifunction, onItem, ...):void
	local multipleOnItemStruct:MultipleOnItemArgs = BuildMultipleOnItemStruct(onItem, volume);
	
	parcelArg.eventToVolumeMap = parcelArg.eventToVolumeMap or {};
	if parcelArg.eventToVolumeMap[volume] == nil then
		parcelArg.eventToVolumeMap[volume] = 1;
	else
		parcelArg.eventToVolumeMap[volume] = parcelArg.eventToVolumeMap[volume] + 1;
	end
	
	ParcelRegisterEvent(parcelArg, eventType, func, multipleOnItemStruct, ...);
	VolumeEventCheckerStart(volume);
end

--register volume events
function ParcelRegisterVolumeOnEnterEvent(parcelArg:table, volume:volume, func:ifunction, onItem, ...):void
	ParcelRegisterVolumeEvent(parcelArg, g_volumeEnteredEvent, volume, func, onItem, ...);
end

function ParcelRegisterVolumeOnExitEvent(parcelArg:table, volume:volume, func:ifunction, onItem, ...):void
	ParcelRegisterVolumeEvent(parcelArg, g_volumeExitedEvent, volume, func, onItem, ...);
end

--unregister volume events
--this function is used by the Parcel system and shouldn't be used, use ParcelUnRegisterVolumeOn... functions
function ParcelUnregisterVolumeEvent(parcelArg:table, eventType:string, callback:ifunction, onItem, volume:volume):void
	--NOTE: this is special case code that removes the volumes from the VolumeEvent system
	local multipleOnItemStruct:MultipleOnItemArgs = BuildMultipleOnItemStruct(onItem, volume);
	ParcelUnregisterEvent(parcelArg, eventType, callback, multipleOnItemStruct);
	parcelArg.eventToVolumeMap[volume] = parcelArg.eventToVolumeMap[volume] - 1;
	RemoveVolumeFromVolumeEventTables(volume, 1);
end

--unregister volume events
function ParcelUnregisterVolumeOnEnterEvent(parcelArg:table, volume:volume, callback:ifunction, onItem):void
	ParcelUnregisterVolumeEvent(parcelArg, g_volumeEnteredEvent, callback, onItem, volume);
end

function ParcelUnregisterVolumeOnExitEvent(parcelArg:table, volume:volume, callback:ifunction, onItem):void
	ParcelUnregisterVolumeEvent(parcelArg, g_volumeExitedEvent, callback, onItem, volume);
end

--register volume once events
--this function is used by the Parcel system and shouldn't be used, use ParcelRegisterVolumeOn...Once.. functions
function ParcelOnRegisterVolumeOnceEvent(onEnteredEvent:VolumeEventStruct, parcelArg:table, func:ifunction, onItem, unRegisterFunc:ifunction, ...)
	--find out if object is already in the volume and unregister if it is
	assert(onItem ~= nil, "ParcelOnRegisterVolumeOnce event attempted to be registered with a nil onItem");
	if onItem == onEnteredEvent.obj or onItem == onEnteredEvent.player or onItem == onEnteredEvent.ai then
		-- Stop us from getting anymore callbacks. And then call the client callback.
		unRegisterFunc(parcelArg, onEnteredEvent.volume, ParcelOnRegisterVolumeOnceEvent, onItem);
		func(onEnteredEvent, ...);
	end
end

--register volume once events
function ParcelRegisterVolumeOnEnterOnceEvent(parcelArg:table, volume:volume, func:ifunction, onItem, ...):void
	ParcelRegisterVolumeOnEnterEvent(parcelArg, volume, ParcelOnRegisterVolumeOnceEvent, onItem, parcelArg, func, onItem, ParcelUnregisterVolumeOnEnterEvent, ...);
end

function ParcelRegisterVolumeOnExitOnceEvent(parcelArg:table, volume:volume, func:ifunction, onItem, ...):void
	ParcelRegisterVolumeOnExitEvent(parcelArg, volume, ParcelOnRegisterVolumeOnceEvent, onItem, parcelArg, func, onItem, ParcelUnregisterVolumeOnExitEvent, ...);
end

--unregister volume once events
function ParcelUnregisterVolumeOnEnterOnceEvent(parcelArg:table, volume:volume, callback:ifunction, onItem):void
	ParcelUnregisterVolumeEvent(parcelArg, g_volumeEnteredEvent, callback, onItem, volume);
end

function ParcelUnregisterVolumeOnExitOnceEvent(parcelArg:table, volume:volume, callback:ifunction, onItem):void
	ParcelUnregisterVolumeEvent(parcelArg, g_volumeExitedEvent, callback, onItem, volume);
end


--is parcel event registered in the parcel?
function ParcelIsItemRegistered(parcelArg:table, eventType, callback:ifunction, onItem):boolean
	if parcelArg.storedEvents == nil then
		return false;
	end

	local itemTable:table = parcelArg.storedEvents[eventType];

	if itemTable == nil then
		return false;
	end

	local itemKey = onItem;

	local multipleOnItemStruct:MultipleOnItemArgs = nil;
	--if onItem is a MultipleOnItems struct then make a table structure based on it
	if type(itemKey) == "struct" and struct.name(itemKey) == "MultipleOnItemArgs" then
		local itemKeyNew = nil;
		for _, item in ipairs(itemKey.onItems) do
			itemKeyNew = item;
			--chain the items in the table structure
			itemTable[itemKeyNew] = itemTable[itemKeyNew] or {};
			itemTable = itemTable[itemKeyNew];
		end
		
		--add the parcelArg so that it is included when registering the event
		table.insert(itemKey.onItems, parcelArg);
		multipleOnItemStruct = itemKey;
	else
		itemTable[itemKey] = itemTable[itemKey] or {};
		itemTable = itemTable[itemKey];
		multipleOnItemStruct = BuildMultipleOnItemStruct(itemKey, parcelArg);
	end

	if itemTable[callback] == nil then
		return false;
	end
	
	return true;
end



--add and starts a parcel, then stores that parcel to be automatically stopped and ended when the parent is stopped and ended
function ParcelStartChildParcel(parentParcel:table, childParcel:table, childParcelName:string):void
	assert(ParcelIsValid(parentParcel) == true, "ParcelStartChildParcel: parentParcel argument is not a parcel");
	assert(childParcelName ~= nil, "ParcelStartChildParcel: childParcelName is nil and it can't be nil");
	
	parentParcel.childParcels = parentParcel.childParcels or SetClass:New();
	
	-- Inherit object parcel state from parent
	childParcel.isObjectParcel = parentParcel.isObjectParcel;
	childParcel.owningObject = parentParcel.owningObject;
	childParcel._InternalCreateThread = parentParcel._InternalCreateThread;

	--keep track of the childParcel
	if parentParcel.childParcels:Contains(childParcel) == false then
		--it is bad if the childParcel is valid and the parent doesn't know about it
		assert(ParcelIsValid(childParcel) == false, "ParcelStartChildParcel: childParcel has already been started");
		parentParcel.childParcels:Insert(childParcel);
	end
	
	--if the childParcel hasn't been started, then start it, else give it permission to start
	if ParcelIsValid(childParcel) == false then 
		ParcelAddAndStart(childParcel, childParcelName);
	else
		ParcelRestorePermission(childParcel);
	end
end

function ParcelStopChildParcel(childParcel:table, immediate:boolean):void
	ParcelRevokePermission(childParcel);

	if immediate then
		_ShutdownParcel(childParcel, immediate);
	else
		ParcelStop(childParcel);
	end
end

function ParcelEndChildParcel(parentParcel:table, childParcel:table, immediate:boolean):void
	--assert(parentParcel ~= nil, "ERROR: ParcelEndChildParcel was called with a nil parentParcel argument");
	assert(childParcel ~= nil, "ERROR: ParcelEndChildParcel was called with a nil childParcel argument");
	
	ParcelRevokePermission(childParcel);
	if immediate then
		ParcelEndImmediate(childParcel);
	else
		ParcelEnd(childParcel);
	end

	if parentParcel ~= nil then
		--more error checking?
		parentParcel.childParcels:Remove(childParcel);
		if parentParcel.childParcels:Count() == 0 then
			parentParcel.childParcels = nil;
		end
	end
end

function ParcelStopAllChildParcels(parentParcel:table, immediate:boolean):void
	if parentParcel.childParcels ~= nil then
		for childParcel in set_elements(parentParcel.childParcels) do
			ParcelStopChildParcel(childParcel, immediate);
		end
	end
end

function ParcelEndAllChildParcels(parentParcel:table, immediate:boolean):void
	if parentParcel.childParcels ~= nil then
		for childParcel in set_elements(parentParcel.childParcels) do
			ParcelEndChildParcel(parentParcel, childParcel, immediate);
		end
	end
end

--adds the parcel to the ParcelHandlerParcelReference.parcels table
--if exclusive then add the exclusive tag to the parcel
function ParcelAdd(parcelArg:table, name:string):void
	--check for a parcel name
	assert(name ~= nil, "ParcelAdd was called without a name, all parcels need a unique name");
	parcelArg.parcelName = name;
	
	for _, parcel in hpairs(ParcelHandlerParcelReference.parcels) do
		if (parcel.parcelName == name) then
			print("Parcel: Warning: There is already a parcel with the name " .. parcelArg.parcelName);
		end
	end
	
	parcelArg.parcelNameId = Telemetry_RegisterHashString(string.len(parcelArg.parcelName) > 0 and RemoveExtraParcelCharactersForTelemetry(parcelArg.parcelName) or "NONE");
	-- ToDo: Once FireTelemetryEvent returns the _CellSequenceId, this becomes that ID.
	parcelArg.parcelTelemetryInstanceId = Telemetry.Internal.GetNewTelemetryIndex();
	
	--only add the parcel to the list of parcels if the PROFILE.core variable isn't set to 0
	--this should handle instances of parcels that have ended but are added during startup when the player re-enters the world.
	if PROFILE.core[parcelArg.parcelName] ~= true then
		if ParcelHandlerParcelReference.parcels[parcelArg] then
			print ("Parcel: There is already a parcel with this index. it is named", parcelArg.parcelName, ".  Not starting it");
		else
			-- Run InitializeImmediate, which should set up things like subscribing to callbacks (i.e. NON-blocking)
			if parcelArg.InitializeImmediate then
				parcelArg:InitializeImmediate();
			end
			
			ParcelHandlerParcelReference.parcels[parcelArg] = parcelArg.parcelName;
		end
	else
		print ("Parcel '", parcelArg.parcelName, "' has been permanently ended, the PROFILE.core variable isn't set to 0, not adding the parcel");
	end
end


--adds a table of parcels to the ParcelHandlerParcelReference.parcels table
--the table keys must be strings of the name of the table and the values must be a parcel
--like this:
			--myTableOfParcels = 
			--	{
			--		"my_awesome_parcel1" = myAwesomeParcel1,
			--		"my_awesome_parcel2" = myAwesomeParcel2,
			--	};
function ParcelAddTable(tabOfParcels:table)
	for ParcName, tab in pairs(tabOfParcels) do
		if not ParcelHandlerParcelReference.possibleParcels[ParcName] then
			ParcelAdd(tab, ParcName);
		end
	end
end

--adds the parcel to the ParcelHandlerParcelReference.parcels table and starts the ParcelManager
function ParcelAddAndStart(parcelArg:table, name:string):void
	if ParcelHandlerParcelReference.activeParcels[parcelArg] or ParcelHandlerParcelReference.possibleParcels[parcelArg] then
		dprint ("Parcel", parcelArg.parcelName, "is already running, not starting");
		return
	end

	dprint ("Adding and Starting Parcel", name);
	parcelArg.directorStop = false;
	parcelArg.directorEnd = false;
	parcelArg.directorRevoked = false;
	ParcelAdd(parcelArg, name);
	ParcelHandler.StartParcelManager();
end


--check to see if a parcel is active
--returns true if active, false if not
function ParcelIsActive(parcelArg:table):boolean
	return ParcelHandlerParcelReference.activeParcels[parcelArg] ~= nil;
end

--check to see if a parcel is valid (active or possible)
--returns true if possible or active, false if not
function ParcelIsValid(parcelArg:table):boolean
	return ParcelIsPossible(parcelArg) or ParcelIsActive(parcelArg);
end

--check to see if the supplied table is either valid (active or possible)
--or is in the ParcelHandlerParcelReference.parcels table (meaning it has had ParcelAdd called but not been started)
function TableIsParcel(potentialParcel:table):boolean
	return ParcelIsValid(potentialParcel) or (ParcelHandlerParcelReference.parcels[potentialParcel] ~= nil);
end

--check to see if a parcel is possible 
--returns true if possible, false if not
function ParcelIsPossible(parcelArg:table):boolean
	return ParcelHandlerParcelReference.possibleParcels[parcelArg] ~= nil;
end

--check to see if a parcel is of a certain class recursive
-- parcelArg	= the parcel that is being checked
-- parcelClass	= the class that the parcel is being compared
--returns true if the parcel is of a certain class(like as a child or a parent)
function ParcelIsOfClass(parcelArg:table, parcelClass:table):boolean
	local parcelParent:table = GetParentParcel(parcelArg);
	if parcelParent == parcelClass then
		return true;
	elseif parcelParent ~= nil then 
		return ParcelIsOfClass(parcelParent, parcelClass);
	end
	return false;
end

--sleeps until a set of parcels is created and then sleeps until it is no longer active and possible
--	parcels = the parcels to check when they are no longer active
--	seconds(optional) = number of seconds before we time out
-- returns true if the parcels are no longer valid (and optionally) false when we time out
function ParcelSleepUntilParcelsEnded(parcels:table, seconds:number):boolean
	local awakeCounter = #parcels; 

	local function sleepUntilAwake(parcelArg:table) 
		SleepUntil ([| ParcelIsActive(parcelArg) ], 1);
		awakeCounter = awakeCounter - 1;
	end

	for _, parcelArg in ipairs(parcels) do
		CreateThread(sleepUntilAwake, parcelArg);
	end

	SleepUntil ([| awakeCounter == 0 ], 1);

	if seconds ~= nil then
		 seconds = seconds_to_frames(seconds);
	end

	local endedCounter = #parcels; 

	-- We want to wait until the parcel system has fully ended this 
	-- parcel and called its callbacks, after the parcel is 
	-- no longer possible it is "ended"
	local function sleepUntilEnded(parcelArg:table) 
		SleepUntil ([| not ParcelIsPossible(parcelArg) ], 1);
		endedCounter = endedCounter - 1;
	end

	for _, parcelArg in ipairs(parcels) do
		CreateThread(sleepUntilEnded, parcelArg);
	end

	return SleepUntilReturn([|endedCounter == 0], 1, seconds); 
end

--sleeps until a set of parcels is active
--	parcels = the parcels to check
--	seconds(optional) = number of seconds before we time out
-- returns true if the parcels are no longer valid or false when we time out
function ParcelSleepUntilParcelsActive(parcels:table, seconds:number):boolean
	local frames:number = nil;
	if seconds ~= nil then
		frames = seconds_to_frames(seconds);
	end

	local isDone:boolean = true;
	repeat
		isDone = true;
		for _, parcelArg in hpairs(parcels) do
			if not ParcelIsActive(parcelArg) then
				isDone = false;
				break;
			end
		end

		if frames ~= nil then
			if frames <= 0 then
				break;
			end
			frames = frames - 1;
		end

		Sleep(1);
	until isDone == true

	return isDone;
end

--sleeps until a parcel is created and then sleeps until it is no longer active and possible
--	parc							= the parcel to check when it is no longer active
--	seconds(optional) = number of seconds before it times out
-- returns true if the parcel is no longer valid (and optionally) false when it times out
--sleeps until a parcel is created and then sleeps until it is no longer active
function ParcelSleepUntilParcelNotActive(parcelArg:table, seconds:number):boolean
	SleepUntil ([| ParcelIsActive(parcelArg) ], 1);
	if seconds ~= nil then
		 seconds = seconds_to_frames(seconds);
	end
	if SleepUntilReturn([|ParcelIsActive(parcelArg) == false], 1, seconds) then
		dprint ("Parcel", parcelArg.parcelName , "is no longer active");
		return true;
	else
		print ("Parcel", parcelArg.parcelName , "has timed out");
		return false;
	end
end

--sleeps until a parcel is created and then sleeps until it is no longer valid and possible
--	parc							= the parcel to check when it is no longer valid
--	seconds(optional) number of seconds before it times out
-- returns true if the parcel is no longer valid (and optionally) false when it times out
function ParcelSleepUntilParcelNotValid(parcelArg:table, seconds:number):boolean
	SleepUntil ([| ParcelIsActive(parcelArg) or ParcelHasEndedPermanently(parcelArg)], 1);
	if seconds ~= nil then
		 seconds = seconds_to_frames(seconds);
	end
	if SleepUntilReturn([|ParcelIsValid(parcelArg) == false], 1, seconds) then
		dprint ("Parcel", parcelArg.parcelName , "is no longer valid");
		return true;
	else
		print ("Parcel", parcelArg.parcelName , "has timed out");
		return false;
	end
end

global ParcelParentMaxIterationCountReached = 70;

--makes a metatable of a table.  This is used to inherit elements of a table
--use this to parent a parcel to a new parcel
--		parent						- the table you want to become a metatable (the parent)
--		child [optional] - the table you want to add the metatable to (the child)
-- this will go through all the nested tables of the parent and apply metatables to the corresponding child table
function ParcelParent(parent:table, child:table)
	child = child or {};
	
	--set the metatable on a table called "parentParcel" so that there is always a clean version of the parent
	child.parentParcel = {};
	table.addCachedBaseClassMetatable(parent, child.parentParcel);
	--loop through the tables in the parent and create them on the child (and make a metatable of them linked to the parent table)
	--so that a table doesn't accidentally get created on the parent when attempting to access a nested table on the child
	local function LoopTables(parent, child, loopCounter)
		child = child or {};
		table.addCachedBaseClassMetatable(parent, child);
		for k,v in pairs (parent) do
			if type(v) == 'table' and k ~= "parentParcel" then
				loopCounter = loopCounter + 1;
				if loopCounter > ParcelParentMaxIterationCountReached then
					print ("Warning - ParcelParent:LoopTables reached iteration count: ", loopCounter, "  Parent: ", parent , "  Child: ", child);
					ParcelParentMaxIterationCountReached = loopCounter;
				end
				child[k] = LoopTables (v, rawget(child,k),loopCounter);
			end
		end
		return child;
	end
	 
	child = LoopTables(parent, child, 0);
  
	return child;
end

--CreateParcelInstance
--returns an instance of a parcel
--use this in a parcel's New() constructor function to properly use metatables and set the permanent flag
--		parcelDeclaration	- the parcel from which an iteration will be created
--returns a parcel instance.  A table which has its metatable as a parcel
function CreateParcelInstance(parcelDeclaration:table, child:table):table
	local parcelInstance:table = ParcelParent(parcelDeclaration, child);
	return parcelInstance;
end

--get a parcels parent (its index metatable)
function GetParentParcel(parcelArg:table):table
	local metaTable:table = getmetatable(parcelArg);
	if metaTable ~= nil then
		return metaTable.__index;
	end
	return nil;
end

--get a parcel's ultimate parent, with support for ignoring the BaseParcel ultimate parent
function GetUltimateParentParcel(parcelArg:table, ignoreBaseParcel:boolean):table
	-- find the ultimate parent parcel just below the BaseParcel in the chain
	local ultimateParentParcel = parcelArg;
	repeat
		local nextParent = GetParentParcel(ultimateParentParcel);
		if (nextParent ~= nil and (not ignoreBaseParcel or nextParent ~= BaseParcel)) then
			ultimateParentParcel = nextParent;
		else
			break;
		end
	until false;

	return ultimateParentParcel;
end

--prevent a parcel from ever being started again
function ParcelEndPermanently(parcelArg:table):void
	PROFILE.core[parcelArg.parcelName] = true;
end

function ParcelHasEndedPermanently(parcelArg:table):boolean
	if parcelArg.parcelName == nil then
		return false;
	else
		return PROFILE.core[parcelArg.parcelName] == true;
	end
end

--calls a function on the parent parcel that is also named in the child
--example: ParcelCallParentFunction(myParcel, myParcel.Run, "foo"); -- this will call the .Run function of the parent of myParcel.
function ParcelCallParentFunction(parcelArg:table, func:ifunction, ...)
	if parcelArg.parentParcel == nil then
		error ("ParcelRunBaseFunction: can't run this function because the called parcel doesn't have a parent")
	end
	
	local parentTable = getmetatable(parcelArg.parentParcel).__index;
	
	for k,v in hpairs (parcelArg) do
		if v == func then
			return parentTable[k](parentTable, ...);
		end
	end
end

function ParcelGetParcelState(parcel):number
	return parcel.parcelState;
end

-------PPAIRS FUNCTIONS

-- returns a table that is a combination of a local table's content and that table's metatable content
function GetCompleteTable (t:table):table
	if (t == nil) then
		return {};
	end
	local retTable = {};
	if (getmetatable(t) ~= nil) then
		retTable = GetCompleteTable (getmetatable(t).__index);
	end
	for k, v in hpairs(t) do
	  if (type(v) == "table" and getmetatable(v) ~= nil) then
			retTable[k] = GetCompleteTable(v);
	  else
			retTable[k] = v;
	  end
	end

	return retTable;
end


--this allows iterating over a table that is either in a table or in that tables metatable
function ppairs(t)
	local tab = GetCompleteTable(t)
	return next, tab, nil;
end


--force start a parcel by name (use with caution, the parcel could easily stop 1 frame into starting)
function ParcelStart(parcelArg:table)
	if ParcelHandlerParcelReference.possibleParcels[parcelArg] then
		dprint ("Force starting parcel", parcelArg.parcelName);
		parcelArg.directorStart = true;
	else
		print ("ParcelStart: unrecognized parcel entered, not starting parcel");
	end
end

--lookup a parcel by name and stop it
function ParcelStop(parcelArg:table)
	if ParcelHandlerParcelReference.activeParcels[parcelArg] then
		dprint ("Force stopping parcel", parcelArg.parcelName);
		parcelArg.directorStop = true;
	else
		dprint ("ParcelStop: unrecognized parcel entered, not stopping parcel");
	end
end

--stop all active parcels
function ParcelStopAll()
	for parcelArg, _ in hpairs (ParcelHandlerParcelReference.activeParcels) do
		ParcelStop(parcelArg);
	end
end

--lookup a parcel by name and end it
function ParcelEnd(parcelArg:table)
	if TableIsParcel(parcelArg) then
		dprint ("Force ending parcel", parcelArg.parcelName);
		parcelArg.directorEnd = true;
	else
		dprint ("ParcelEnd: unrecognized parcel entered, not ending parcel");
	end
end

function ParcelEndImmediate(parcelArg:table)
	if not TableIsParcel(parcelArg) then
		return;
	end

	dprint ("Force ending parcel immediately ", parcelArg.parcelName);

	local k_immediate:boolean = true;

	if ParcelIsValid(parcelArg) then
		-- Only run if the parcel is possible or running
		_ShutdownParcel(parcelArg, k_immediate);

		-- We need to manually kill the ParcelHandlerRun thread as it won't end on its own.
		KillThread(parcelArg.threadId);
	end

	-- if the parcel hasn't started yet we need to remove it from the queued parcels to start.
	ParcelHandlerParcelReference.parcels[parcelArg] = nil;

	-- Always run end to unregister anything register in InitializeImmediate.
	_EndShutdownParcel(parcelArg, k_immediate);
end

--end all active parcels
function ParcelEndAll()
	dprint ("end all active parcels");
	for parcelArg, _ in hpairs (ParcelHandlerParcelReference.activeParcels) do
		ParcelEnd(parcelArg);
	end
end

--kill a possible parcel by name
function ParcelKill(parcelArg:table)
	if ParcelHandlerParcelReference.possibleParcels[parcelArg] ~= nil then
		print ("force killing parcel", parcelArg.parcelName);
		ParcelHandler.KillParcelThreads(parcelArg);
		KillThread(parcelArg.threadId);

		ParcelHandler.ParcelHasEnded(parcelArg);
	else
		print ("ParcelKill: unrecognized parcel entered, no parcel getting killed");
	end
end

function ParcelKillAll()
	for parcName in pairs(ParcelHandlerParcelReference.possibleParcels) do
		ParcelKill(parcName);
	end
end





--============================================
--=================== base parcel class ======
--============================================


global BaseParcel:table = 
	{
		parcelPrintEnabled = false;
		instanceName = "UNNAMED";
	}; --??maybe add in parcel variables from the ParcelManager??

function BaseParcel:ParcelNew(instance)

end

--methods

function BaseParcel:CreateParcelInstance(child:table):table
	if self.IsMPModeParcel then
		VerifyMPModeParcel(self);
	end

	return CreateParcelInstance(self, child);
end

--triggers a control event similar to a comm object, default to true
function BaseParcel:TriggerControlEvent(eventChannel:string, enable:boolean):void
	if enable == nil then
		enable = true;
	end

	CommunicationObjectControlUpdateCallback(eventChannel, self, enable);
end

--triggers a power event similar to a comm object, default to true
function BaseParcel:TriggerPowerEvent(eventChannel:string, enable:boolean):void
	if enable == nil then
		enable = true;
	end

	CommunicationObjectPowerUpdateCallback(eventChannel, self, enable);
end

function BaseParcel:RegisterEventOnSelf(eventType, callback:ifunction, onItem:any, ...):void
	CommonParcelRegisterEvent(self, nil, self, eventType, callback, onItem, ...);
end

function BaseParcel:RegisterGlobalEventOnSelf(eventType, callback:ifunction, ...):void
	self:RegisterEventOnSelf(eventType, callback, g_allItems, ...);
end

function BaseParcel:RegisterEventOnceOnSelf(eventType, callback:ifunction, onItem:any, ...):void
	CommonParcelRegisterEvent(self, ParcelEventUnregisterFunction, self, eventType, callback, onItem, ...);
end

function BaseParcel:RegisterGlobalEventOnceOnSelf(eventType, callback:ifunction, ...):void
	self:RegisterEventOnceOnSelf(eventType, callback, g_allItems, ...);
end

function BaseParcel:UnregisterEventOnSelf(eventType, callback:ifunction, onItem:any):void
	ParcelUnregisterEvent(self, eventType, callback, onItem);
end

function BaseParcel:UnregisterGlobalEventOnSelf(eventType, callback:ifunction):void
	ParcelUnregisterGlobalEvent(self, eventType, callback);
end

function BaseParcel:IsItemRegistered(eventType, callback:ifunction, onItem):boolean
	return ParcelIsItemRegistered(self, eventType, callback, onItem);
end

function BaseParcel:CreateThread(func:ifunction, ...):thread
	return ParcelCreateThread(self, func, self, ...);
end

-- Allows for creating non-lifetime-managed threads using the familiar self:Func calling pattern
function BaseParcel:CreateNonChildThread(func:ifunction, ...):thread
	return CreateThread(func, self, ...);
end

-- INTERNAL USE ONLY - DO NOT CALL DIRECTLY
function BaseParcel:_InternalCreateThread(func:ifunction, ...):thread
	-- Object parcels will have their InternalCreateThread defined by ParcelAddAndStartOnSelf.
	return CreateThread(func, ...);
end

function BaseParcel:KillThread(parcelThread:thread):void
	ParcelKillThread(self, parcelThread);
end

function BaseParcel:StartChildParcel(childParcel:table, childParcelName:string):void
	ParcelStartChildParcel(self, childParcel, childParcelName);
end

function BaseParcel:StopChildParcel(childParcel:table):void
	ParcelStopChildParcel(childParcel);
end

function BaseParcel:EndChildParcel(childParcel:table):void
	ParcelEndChildParcel(self, childParcel);
end

function BaseParcel:RevokePermission():void
	ParcelRevokePermission(self);
end

function BaseParcel:RestorePermission():void
	ParcelRestorePermission(self);
end

function BaseParcel:EndParcelPermanently():void
	ParcelEndPermanently(self);
end


--event manager

function BaseParcel:AddEventManager():void
	--create a new event manager for this parcel and pass self as parent
	self.parcelEventManager = EventManager:New(self.instanceName .. "_EventManager", self);

	--iterate through EVENTS and make events from them
	for k, eventString in hpairs(self.EVENTS) do
		self.parcelEventManager:RegisterEvent(eventString);
	end
end

function BaseParcel:SetParcelEventsDisabled(disableEvents:boolean):void
	self.parcelEventManager:SetEventsDisabled(disableEvents);
end

function BaseParcel:TriggerEvent(event, ...):void
	self.parcelEventManager:TriggerEvent(event, ...);
end

function BaseParcel:TriggerEventImmediate(event, ...):void
	self.parcelEventManager:TriggerEventImmediate(event, ...);
end

function BaseParcel:RegisterCallback(event, callbackFunc, callbackOwner):void
	self.parcelEventManager:RegisterCallback(event, callbackFunc, callbackOwner);
end

function BaseParcel:RegisterCallbackOnce(event, callbackFunc, callbackOwner):void
	self.parcelEventManager:RegisterCallbackOnce(event, callbackFunc, callbackOwner);
end

function BaseParcel:SleepUntilCallback(event)
	local fired: boolean = false;
	local results: table = nil;
	self:RegisterCallbackOnce(event, function(subject, ...) results = arg; fired = true; end);
	SleepUntil([| fired ]);
	return unpack(results);
end

function BaseParcel:UnregisterCallback(event, callbackFunc, callbackOwner):void
	self.parcelEventManager:UnregisterCallback(event, callbackFunc, callbackOwner);
end

function BaseParcel:GetEventManager():table
	return self.parcelEventManager;
end

--Getters

function BaseParcel:GetParcelState():number
	return ParcelGetParcelState(self);
end

--Print

function BaseParcel:ParcelPrint(...):void
	if self.parcelPrintEnabled == true then
		print(...);
	end
end

function BaseParcel:ToggleParcelPrint():boolean
	self.parcelPrintEnabled = not self.parcelPrintEnabled;
	return self.parcelPrintEnabled;
end

global Parcel = {};
function Parcel.MakeParcel(parcelTable:table):table
	assert(parcelTable ~= nil, "can't make a nil parcel");
	--make the base parcel the __index of parcelTable
	parcelTable = ParcelParent(BaseParcel, parcelTable);
	--don't make it an hstruct...yet...

	--make an eventmanager if there is an EVENTS table
	if parcelTable.EVENTS ~= nil then
		parcelTable:AddEventManager();
	end

	return parcelTable;
end

-- Used to make top-level Multiplayer Mode parcels (e.g. parcels found in tags\scripts\GameModes\...)
function Parcel.MakeModeParcel(parcelTable:table):table
	-- Additionally for MP Mode parcels, we want to enforce enum safety for the EVENTS table
	if parcelTable.EVENTS ~= nil then
		table.makeEnum(parcelTable.EVENTS);
	end

	-- Same thing for the STATS table
	if parcelTable.STATS ~= nil then
		table.makeEnum(parcelTable.STATS);
	end

	-- Will cause VerifyMPModeParcel to be called on this parcel when BaseParcel:CreateParcelInstance() is hit
	parcelTable.IsMPModeParcel = true;

	-- Finally return the standard MakeParcel output
	return Parcel.MakeParcel(parcelTable);
end

-- NOTE: The intention of this method is that it doesn't block the creation of the parcel, so we spin off threads
-- that can safely assert without derailing the creation of the parcel instance.
function VerifyMPModeParcel(parcelTable:table):void
	CreateThread(VerifyMPModeStats, parcelTable);
end

function VerifyMPModeStats(parcelTable:table):void
	-- We only verify stats if there's an actual game variant to check against.. Faber doesn't have game variants so no check needed.
	if (not editor_mode()) then
		local ultimateParentParcel:table = GetUltimateParentParcel(parcelTable, true);
		if ultimateParentParcel.STATS ~= nil then
			-- Iterate all of the stat names in the STATS table and build up a list of those that are undefined in the current game variant
			local undefinedStats:table = {};
			for k, statName in hpairs(ultimateParentParcel.STATS) do
				if (not Variant_GetStatDefinitionExists(statName)) then
					table.insert(undefinedStats, statName);
				end
			end

			-- If there were any undefined stats, then build up an assert string and fire a failing assert
			if (#undefinedStats > 0) then
				local assertString:string = "ERROR: The following stats were referenced by the game mode Lua script but were undefined in the current game variant: ";
				for idx, statName in ipairs(undefinedStats) do
					if (idx ~= 1) then
						assertString = assertString .. ", ";
					end
					assertString = assertString .. statName;
				end

				print(assertString);
				-- Commenting this out for now until stats have been in for a few green builds
				-- debug_assert(false, assertString);
			end
		end
	end
end


--  .___________. _______     _______.___________.    _______  __    __  .__   __.   ______ .___________. __    ______   .__   __.      _______.
--  |           ||   ____|   /       |           |   |   ____||  |  |  | |  \ |  |  /      ||           ||  |  /  __  \  |  \ |  |     /       |
--  `---|  |----`|  |__     |   (----`---|  |----`   |  |__   |  |  |  | |   \|  | |  ,----'`---|  |----`|  | |  |  |  | |   \|  |    |   (----`
--      |  |     |   __|     \   \       |  |        |   __|  |  |  |  | |  . `  | |  |         |  |     |  | |  |  |  | |  . `  |     \   \    
--      |  |     |  |____.----)   |      |  |        |  |     |  `--'  | |  |\   | |  `----.    |  |     |  | |  `--'  | |  |\   | .----)   |   
--      |__|     |_______|_______/       |__|        |__|      \______/  |__| \__|  \______|    |__|     |__|  \______/  |__| \__| |_______/    
--                                                                                                                                              

--Use this to test just one parcel
function ParcelTest(parcelArg:table, name:string)
	if ParcelHandlerParcelReference.activeParcels[parcelArg] or ParcelHandlerParcelReference.possibleParcels[parcelArg] then
		dprint (name, "is already running, not starting");
		ParcelEnd(parcelArg);
	end
	print ("testing ", name);
	ParcelHandlerParcelReference.parcels = {};
	Sleep(1);
	ParcelAddAndStart(parcelArg, name);
end

--helper functions
function ParcelPrintActiveParcels()
	print ("PRINTING ACTIVE PARCELS");
	table.dprint (ParcelHandlerParcelReference.activeParcels, false);
end

function ParcelPrintPossibleParcels()
	print ("PRINTING POSSIBLE PARCELS");
	table.dprint (ParcelHandlerParcelReference.possibleParcels, false);
end

--ONLY USE THIS FOR TESTING
function Debug_ParcelEndPermanentlyUndo(parcelName:string):void
	PROFILE.core[parcelName] = nil;
end

global parcelStateEnum = table.makeEnum
	{
		initialized = 0,
		running = 1,
		stopped = 2,
		ended = 3,
	}


--Telemetry

function RemoveExtraParcelCharactersForTelemetry(str:string):string
	local newString:string = str;
	local startNum, totalNum = string.find(str, "_struct");
	if startNum ~= nil then
		newString = string.sub(str, 1, startNum - 1);
		return newString;
	end
	
	startNum, totalNum = string.find(str, "_table");
	if startNum ~= nil then
		newString = string.sub(str, 1, startNum - 1);
		return newString;
	end

	startNum, totalNum = string.find(str, "_object_type");
	if startNum ~= nil then
		startNum, totalNum = string.find(str, " ", totalNum);
		
		if startNum ~= nil then
			newString = string.sub(str, totalNum + 1);
		end
	end
	return newString;
end
function ParcelFireTelemetry(parcelArg:table)
	FireTelemetryEvent("ParcelStateChange", {ParcelNameId = parcelArg.parcelNameId, Parcel = parcelArg.parcelTelemetryInstanceId, NewParcelState = parcelArg.parcelState});
end