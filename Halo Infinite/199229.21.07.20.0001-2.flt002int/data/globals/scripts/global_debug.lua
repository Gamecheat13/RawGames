-- DEBUG - DON'T REMOVE THIS COMMENT
-- Da Rules:
--   1) Script files starting with "-- DEBUG" are allowed to use debug functions and variables.
--   2) Such script files are ignored by the Release game.
--   3) Other files are not allowed to use functions and variables defined in a "-- DEBUG" file.
-- This ensures that debug functionality is not directly or indirectly used by the Release game.

-- global variables to be used for temporary storage by the console (because you can't define global variables on the console)
global g_temp1:any = nil;
global g_temp2:any = nil;
global g_temp3:any = nil;
global g_temp4:any = nil;
global g_temp5:any = nil;




-- If on server, runs code locally.
-- If on client, sends the function to the server to be executed.
function RunScriptOnServer(code:string)
	if (IsServer()) then
		loadstring(code)();
	else
		ServerCmd(code);
	end
end

function ToggleDeathlessPlayerServer()
	cheat_deathless_player = not cheat_deathless_player;
	RunOnServerAndAllClients("print", "deathless player = ", cheat_deathless_player);
end

function DropTagOnServer(tagToDrop:tag)
	RunOnServerAndAllClients("DropToPlayer", Player_GetLocal(0), tagToDrop);
end

function DropTagVariantOnServer(tagToDrop:tag, variant:string)
	RunOnServerAndAllClients("DropVariantToPlayer", Player_GetLocal(0), tagToDrop, variant);
end

function DropTagPermutationOnServer(tagToDrop:tag, permutation:string)
	RunOnServerAndAllClients("DropPermutationToPlayer", Player_GetLocal(0), tagToDrop, permutation);
end

function DropTagConfigurationOnServer(object:tag, configuration:tag)
	RunOnServerAndAllClients("DropObjectConfigurationToPlayer", Player_GetLocal(0), object, configuration);
end

--DO NOT ERASE
--this makes the cheat menu work -- 
--this has to be declared in a non client or server bracket and has to end with a server bracket
--DO NOT ERASE
-- Will run functionName with the given parameter on the server and every client.
function RunOnServerAndAllClients(functionName:string, ...)
	if (IsServer()) then
--## SERVER
		_G.RunClientScript(functionName, ...);
--## COMMON
        -- No local player? Probably dedicated server, so we need to run the function
        -- locally. Here we are trying to not run 'functionName' twice. This isn't
        -- perfect.
        if (Player_GetLocal(0) == nil) then		
	        _G[functionName](...);
        end
	else
--## CLIENT
	RunServerScript("RunOnServerAndAllClients", functionName, ...);
--## COMMON
	end
end

--## SERVER

remoteServer["RunOnServerAndAllClients"] = RunOnServerAndAllClients
remoteServer["print"] = print
remoteServer["data_mine_set_session_tag"] = data_mine_set_session_tag
remoteServer["DropToPlayer"] = DropToPlayer
remoteServer["DropVariantToPlayer"] = DropVariantToPlayer
remoteServer["DropPermutationToPlayer"] = DropPermutationToPlayer
remoteServer["DropObjectConfigurationToPlayer"] = DropObjectConfigurationToPlayer
remoteServer["TestSetPlayerPosition"] = TestSetPlayerPosition
remoteServer["TestSetPlayerPositionFromObserverPosition"] = TestSetPlayerPositionFromObserverPosition
remoteServer["unit_add_weapon"] = unit_add_weapon
remoteServer["PlayerFrameReset"] = PlayerFrameReset
remoteServer["PlayerFrameAttachmentEnable"] = PlayerFrameAttachmentEnable

function LoadOWLevel(path:string):void
	CreateThread(LoadOWLevelHelper, path);
end

function LoadOWLevelHelper(path:string):void
	LoomScenario (path, "Default");
	RunClientScript("LoomOWLevelClient", path , "Default");
	
	sleep_s(4);

	if not editor_mode() then -- this crashes faber
		StartLevel(path);
	end
end




--function to map the names of every function in the game
--this is used in some debug functions to look up function names to print to screen
global g_functionToNameMap = nil;

function GetFunctionName(func:ifunction):string
	if g_functionToNameMap ~= nil then
		return g_functionToNameMap[func];
	end
	return "";
end

--warning: this function takes ~ 3.5 seconds to complete and can cause a "running for too long error" if used with other functions
function BuildFunctionToNameMap()
	g_functionToNameMap = {};
	local timeStamp:number = game_tick_get();
	local count:number = 0;
	local funcCount:number = 0;
	local tableCount:number = 0;
	local tableCountBeforeSleep:number = 50000;
	local itemCountBeforeSleep:number = 20000;
	local itemType = nil;
	print ("Building Function to Name Map");
	print ("warning: this could take a few seconds to complete");
	
	--look through all the items in _G and look for functions
	for globalStringName, globalItem in hpairs (_G) do
		count = count + 1;
		itemType = type(globalItem);
		g_functionToNameMap[globalItem] = globalStringName;
		if itemType == "function" then
			funcCount = funcCount + 1;
			
		--if the item is a table, then look one level deep in the table for functions
		--only looking one level deep to not explode how long this takes
		elseif itemType == "table" then
			for tableStringName, tableItem in hpairs(globalItem) do
				if type(tableItem) == "function" then
					funcCount = funcCount + 1;
					g_functionToNameMap[tableItem] = tostring(globalStringName).."."..tostring(tableStringName);
				else
					g_functionToNameMap[tableItem] = tostring(tableStringName);
				end
				tableCount = tableCount + 1;
							
				if tableCount % tableCountBeforeSleep == 0 then
					Sleep(1);
				end
			end
		end
			
		if count % itemCountBeforeSleep == 0 then
			Sleep(1);
		end
	end
	print("BuildFunctionToNameMap Complete");
	print("function count is", funcCount);
	print("table count is", tableCount);
	print("total seconds is",frames_to_seconds(game_tick_get() - timeStamp));
end

function BuildEventMapper()
	print("Building event mapper")
	g_eventMap = {};
	--loop through g_eventTypes and swap the key/value
	for key, value in hpairs(_G.g_eventTypes) do
		g_eventMap[value] = key;
	end
end


global g_eventMap = nil;
global g_eventMapBuilt = nil;
global g_eventEnum = nil;
global g_eventDebuggerShown = false;

function EventDebug(eventEnum:number)
	g_eventEnum = eventEnum;
	
	if g_eventDebuggerShown == true then
		ImGui_DeactivateCallback("sys_EventDebugImGui");
		g_eventDebuggerShown = false;
	else
		g_eventMapBuilt = false;
		BuildFunctionToNameMap();
		--sleep here to prevent "thread is running for too long" error
		Sleep(1);
		BuildEventMapper();
		g_eventMapBuilt = true;
		ImGui_ActivateCallback("sys_EventDebugImGui");
		g_eventDebuggerShown = true;
	end
end

function sys_EventDebugImGui()
	if g_eventMapBuilt == nil then
		CreateThread(EventDebug);
		return;
	elseif g_eventMapBuilt == false then
		return;
	end
	local title:string = "Event Debug:";

	local function concatenateString(eventTable, engineString):string
		return "("..table.countKeys(eventTable)..") "..GetEngineString(engineString);
	end
	
	--keeping color table info until lua imGui gets color support
	local function showText(titleName:string, prefix:string, colorsTable:table)
		prefix = prefix or "";
		ImGui_Text(prefix..titleName);
	end

	local indentDefault:string = "";
	local indentSingle:string = "  ";

	local function showTitleText(titleName:string)
		showText(titleName, indentDefault, {1.0, 1.0, 1.0, 1.0});
	end

	local function showEventText(titleName:string)
		showText(titleName, indentDefault, {1.0, 1.0, 0.25, 1.0});
	end

	local function showItemText(titleName:string)
		showText(titleName, indentSingle, {1.0, 0.25, 0.25, 1.0});
	end

	local function showFunctionText(titleName:string)
		showText(titleName, indentSingle..indentSingle, {1.0, 1.0, 1.0, 1.0});
	end

	local function recurseFilterArguments(filterTable)
		for arg, moreArgs in hpairs(filterTable) do
			if type(arg) == "function" then
				local functionName:string = g_functionToNameMap[arg];
				if functionName ~= nil then
					showItemText(functionName);
				end
			end
			if arg == eventFilterCallbackString then
				for callbackFunc, hstruct in hpairs(moreArgs) do
					local callbackFuncName:string = g_functionToNameMap[callbackFunc];
					if callbackFuncName ~= nil then
						showFunctionText(callbackFuncName);
					end
				end
			else
				recurseFilterArguments(moreArgs);
			end
		end
	end

	local function displayEventRecursive(itemTable)
		local indentAmount:string = indentDefault;
		for item, childItemTable in hpairs(itemTable) do
			local functionName:string = g_functionToNameMap[item];
			indentAmount = indentAmount..indentSingle;
			--if it has a function name then display it
			if functionName ~= nil then
				showFunctionText(indentAmount..functionName);
				indentAmount = indentDefault;
			--if it's a function, but doesn't have a function map then it's a local function
			--add filepath and line number to the debug
			elseif type(item) == "function" then
				local name:string = debug.getinfo(item).short_src;
				local lineNum:number = debug.getinfo(item).linedefined;
				name = string.sub(name, 27);
				showFunctionText(indentAmount.."local function "..name.." "..lineNum);

				indentAmount = indentDefault;
			else
				local name = item;
				if getmetatable(item) ~= nil then
					name = g_functionToNameMap[getmetatable(item).__index] or item;
				end
				showItemText(indentAmount..concatenateString(childItemTable, name));
				displayEventRecursive(childItemTable);
			end
		end
	end

	local function displayEvents(eventTable:table, eventTableName)
		--create a collapsible block of the event
		if ImGui_CollapsingHeader(concatenateString(eventTable, g_eventMap[eventTableName] or eventTableName)) == true then
			--iterate through the onItems on the event and display them with the count of how many callback functions are attached
			for onItemName, callBackTable in hpairs (eventTable) do
				if onItemName == "filters" then
					--walk the stack of the filters to show function names and callback names
					recurseFilterArguments(callBackTable);
				else
					showItemText(concatenateString(callBackTable, onItemName));
					--iterate through the callback tables and show the callback functions
					displayEventRecursive(callBackTable);
				end
			end
		end
	end
	if ImGui_Begin("Event Debugger") == true then
		if ImGui_Button("  Close Event Debugger  ") == true then
			EventDebug();
		end

		--show the title text
		showTitleText(concatenateString(g_callbackEventTable, title));
				
		--iterate through all the events and display them with the count of how many objects are to the events
		if g_eventEnum == nil then
			for eventTableName, eventTable in hpairs(g_callbackEventTable) do
				displayEvents(eventTable, eventTableName);
			end
		else
			local eventTable:table = g_callbackEventTable[g_eventEnum];
			if eventTable == nil then
				ImGui_Text("There are no events for "..g_eventMap[g_eventEnum]);
			else
				displayEvents(eventTable, g_eventEnum);
			end
		end
	end
	ImGui_End();
end


global g_allObjectsDebuggerShown = false;
global g_resizeAllObjectsWindow = false;
global g_objectsDebuggerInput = nil;
global g_objectsDebuggerTypeInput = nil;
global g_objectsDebuggerTagInput = nil;
global g_objectsDebuggerVariantInput = nil;
global g_objectsDebuggerOneMission = nil;

function DebugAllObjects()
	if g_allObjectsDebuggerShown == true then
		ImGui_DeactivateCallback("sys_allObjectsDebuggerImGui");
		g_allObjectsDebuggerShown = false;
	else
		ImGui_ActivateCallback("sys_allObjectsDebuggerImGui");
		g_allObjectsDebuggerShown = true;
	end
end

function sys_allObjectsDebuggerImGui()
	if g_resizeAllObjectsWindow == true then
		ImGui_SetNextWindowSize(500, 500);
		g_resizeAllObjectsWindow = false;
	end

	if ImGui_Begin("All Objects Debugger") == true then
		--button to resize window
		if ImGui_Button("  Resize Window  ") == true then
			g_resizeAllObjectsWindow = true;
		end

		if ImGui_Button("  Close All Objects Debugger  ") == true then
			DebugAllObjects();
		end
		ImGui_Text("");

		local nameFilter = nil;
		local typeFilter = nil;
		local tagFilter = nil;
		local variantFilter = nil;
		g_objectsDebuggerInput = ImGui_InputText("FILTER BY NAME: ", g_objectsDebuggerInput or "");
		g_objectsDebuggerTypeInput = ImGui_InputText("FILTER BY HSTRUCTURE: ", g_objectsDebuggerTypeInput or "");
		g_objectsDebuggerTagInput = ImGui_InputText("FILTER BY TAG PATH: ", g_objectsDebuggerTagInput or "");
		g_objectsDebuggerVariantInput = ImGui_InputText("FILTER BY VARIANT: ", g_objectsDebuggerVariantInput or "");
		for _, obj in ipairs(OBJECTS.active) do
			ImGui_PushStringID(tostring(obj));
			nameFilter = string.find(GetEngineString(obj), g_objectsDebuggerInput);
			if type(obj) == "struct" then
				typeFilter = string.find(struct.name(obj), g_objectsDebuggerTypeInput);
			else
				typeFilter = string.find(GetEngineString(obj), g_objectsDebuggerTypeInput);
			end
			tagFilter = string.find(GetEngineString(Object_GetDefinition(obj)), g_objectsDebuggerTagInput);
			variantFilter = string.find(GetEngineString(ObjectGetVariant(obj)), g_objectsDebuggerVariantInput);
			if nameFilter ~= nil and typeFilter ~= nil and tagFilter ~= nil and variantFilter ~= nil then
				if g_objectsDebuggerOneMission == nil or g_objectsDebuggerOneMission == obj then

					if ImGui_Checkbox(" ", g_objectsDebuggerOneMission) == true then
						g_objectsDebuggerOneMission = obj;
					else
						g_objectsDebuggerOneMission = nil;
					end
			
					ImGui_SameLine();
					imguiVars.standardHeader(imguiVars.getString("Object:", obj), sys_DebugTable, obj);
				end
			end
			ImGui_PopID();
		end
	end
	ImGui_End();
end


global g_allKitsDebuggerShown = false;
global g_resizeAllKitsWindow = false;
global g_kitsDebuggerInput = nil;
global g_kitsDebuggerTypeInput = nil;
global g_kitsDebuggerOneMission = nil;

function DebugAllKits()
	if g_allKitsDebuggerShown == true then
		ImGui_DeactivateCallback("sys_allKitsDebuggerImGui");
		g_allKitsDebuggerShown = false;
	else
		ImGui_ActivateCallback("sys_allKitsDebuggerImGui");
		g_allKitsDebuggerShown = true;
	end
end

function sys_allKitsDebuggerImGui()
	if g_resizeAllKitsWindow == true then
		ImGui_SetNextWindowSize(500, 500);
		g_resizeAllKitsWindow = false;
	end

	if ImGui_Begin("All Kits Debugger") == true then
		--button to resize window
		if ImGui_Button("  Resize Window  ") == true then
			g_resizeAllKitsWindow = true;
		end

		if ImGui_Button("  Close All Kits Debugger  ") == true then
			DebugAllKits();
		end
		ImGui_Text("");

		g_kitsDebuggerInput = ImGui_InputText("FILTER BY NAME: ", g_kitsDebuggerInput or "");
		g_kitsDebuggerTypeInput = ImGui_InputText("FILTER BY HSTRUCTURE: ", g_kitsDebuggerTypeInput or "");
		local typefilter = nil;
		for _, kit in ipairs(KITS.active) do
			ImGui_PushStringID(tostring(kit));
			
			if type(kit) == "struct" then
				typefilter = string.find(struct.name(kit), g_kitsDebuggerTypeInput);
			end
			if string.find(GetEngineString(kit), g_kitsDebuggerInput) ~= nil and typefilter ~= nil then
				if g_kitsDebuggerOneMission == nil or g_kitsDebuggerOneMission == kit then

					if ImGui_Checkbox(" ", g_kitsDebuggerOneMission) == true then
						g_kitsDebuggerOneMission = kit;
					else
						g_kitsDebuggerOneMission = nil;
					end
			
					ImGui_SameLine();
					imguiVars.standardHeader(imguiVars.getString("Kit:", kit), sys_DebugTable, kit);
				end
			end
			ImGui_PopID();
		end
	end
	ImGui_End();
end

--a global variable for easily debugging objects
global lookedAtObjectDebug = nil;

function DebugLookedAtObject(player:player)
	lookedAtObjectDebug = nil;
	player = player or PLAYERS.player0;
	if Player_GetUnit(player) == nil then
		print("DEBUG look at object: The player is not alive, cannot debug");
		return;
	end
	local startLoc, endLoc = GetPlayerLookAtLocations(player, nil, 10000);
	DebugDrawRayCast(startLoc.vector, endLoc.vector)
	local hitTable = RayCastDynamicObject(startLoc, endLoc);
	if hitTable == nil or hitTable.hitObject == nil then
		print("DEBUG look at object: The player is not looking at an object, cannot debug");
		return;
	end

	if g_tableDebuggerShown == true then
		ImGui_DeactivateCallback("OnDebugTables");
		g_tableDebuggerShown = false;
	end
	lookedAtObjectDebug = hitTable.hitObject;
	DebugObject(hitTable.hitObject);
end
------------------------------------------------
-- Debug Lua Counts --
------------------------------------------------




global g_debugDebugLuaCountsThread = nil;
global g_debugDebugLuaCountsID = nil;

function DebugLuaCounts()
	if g_debugDebugLuaCountsThread == nil then
		g_debugDebugLuaCountsThread = CreateThread(DoDebugLuaCounts);
	else
		KillThread(g_debugDebugLuaCountsThread);
		ScriptUI_Destroy(g_debugDebugLuaCountsID);
		g_debugDebugLuaCountsThread = nil;
	end
end

function DoDebugLuaCounts()
	local IDList:table = {};
	local listMaxSize:number = 2;

	-- Setup script UI for the list.
	g_debugDebugLuaCountsID = ScriptUI_CreateListLayout();
	ScriptUI_SetSize(g_debugDebugLuaCountsID, 1, 1, SUI_SCALE_TYPE.Relative, SUI_SCALE_TYPE.Relative);
	ScriptUI_SetPosition(g_debugDebugLuaCountsID, 0.2, 0.22, SUI_SCALE_TYPE.Relative, SUI_SCALE_TYPE.Relative);
	ScriptUI_SetListLayoutDirection(g_debugDebugLuaCountsID, SUI_LIST_DIR.Vertical);
	ScriptUI_SetHorizontalAlignment(g_debugDebugLuaCountsID, SUI_HORIZ_ALIGN.Left);

	-- Setup script UI for each row.
	for i = 1, listMaxSize do
		IDList[i] = ScriptUI_CreateText();
		ScriptUI_SetParent(IDList[i], g_debugDebugLuaCountsID);
		ScriptUI_SetTextColor(IDList[i], .982, .711, .982, 1.0);
		ScriptUI_SetTextString(IDList[i], "");
	end
	
	repeat
		-- Update debug info of threads.
		ScriptUI_SetTextString(IDList[1], "Threads Running: ".. GetThreadCount());
		
		-- Update debug info of events.
		local eventCount:number = 0;
		for _, eventTable in hpairs(g_callbackEventTable) do
			for _, callBackTable in hpairs (eventTable) do
				for _, _ in hpairs(callBackTable) do
					eventCount = eventCount + 1;
				end
			end
		end
		ScriptUI_SetTextString(IDList[2], "Events Registered: ".. eventCount);

		Sleep(1);
	until false;
end






------------------------------------------------
-- Debug MetaParcels and Region Parcels--
------------------------------------------------

global g_debugMetaParcelsThread = nil;
global g_debugMetaParcelsID = nil;

function DebugMetaParcels(parcelArg:table)
	if g_debugMetaParcelsThread == nil and parcelArg.IsMetaparcel then
		g_debugMetaParcelsThread = CreateThread(DoDebugMetaParcels, parcelArg);
	else
		DebugMetaParcelsKill();
	end
end

function DebugRegionParcel(parcelArg:table)
	if g_debugMetaParcelsThread == nil and ParcelIsOfClass(parcelArg, _G["RegionParcel"]) then
		g_debugMetaParcelsThread = CreateThread(DoDebugRegionParcel, parcelArg);
	else
		DebugMetaParcelsKill();
	end
end


function DebugMetaParcelsKill()
	print ("killing debug metaParcels");
	if g_debugMetaParcelsThread ~= nil then
		KillThread(g_debugMetaParcelsThread);
		ScriptUI_Destroy(g_debugMetaParcelsID);
		g_debugMetaParcelsThread = nil;
	end
end

function DoDebugMetaParcels(metaParcel:table)
	local listID = ScriptUI_CreateListLayout();
	ScriptUI_SetSize(listID, 1, 1, SUI_SCALE_TYPE.Relative, SUI_SCALE_TYPE.Relative);
	ScriptUI_SetPosition(listID, 0.3, 0.22, SUI_SCALE_TYPE.Relative, SUI_SCALE_TYPE.Relative);
	ScriptUI_SetHorizontalAlignment(listID, SUI_HORIZ_ALIGN.Left);
	g_debugMetaParcelsID = listID;

	local title:string = "MetaParcel Debug:";
	local IDList:table = {};
	local IDListnum:number = 0;
	local listMaxSize:number = 30;
	
	ScriptUI_SetListLayoutDirection(listID, SUI_LIST_DIR.Vertical);

	local function createListItem():number
		local ID = ScriptUI_CreateText();
		ScriptUI_SetTextScale(ID, 0.75);
		ScriptUI_SetParent(ID, listID);
		ScriptUI_SetTextString(ID, "");
		return ID;
	end

	for i = 1, listMaxSize do
		IDList[i] = createListItem();
	end

	local function showTitleText(titleName:string)
		if IDListnum < listMaxSize then
			IDListnum = IDListnum + 1;
			ScriptUI_SetTextColor(IDList[IDListnum], 1, 1, 1, 1.0);
			ScriptUI_SetTextString(IDList[IDListnum], titleName);
		end
	end

	local function showParcelName(tableName:string, color:table)
		IDListnum = IDListnum + 1;
			
		tableName = "     "..tableName;
		ScriptUI_SetTextColor(IDList[IDListnum], unpack(color));
		ScriptUI_SetTextString(IDList[IDListnum], tableName);
		ScriptUI_SetTextShadowColor(IDList[IDListnum], 1, 1, 1, 1.0);
	end

	local function displayParcels(metaParcel:table, stringSuffix:string)
		stringSuffix = stringSuffix or "";
		
		if metaParcel.runningParcels ~= nil then
			local numActive:number = metaParcel.runningParcels:Count();
			showTitleText(stringSuffix.."Active Parcels: "..numActive);

			for parcel in set_elements(metaParcel.runningParcels) do
				if IDListnum < listMaxSize then
					local str:string = stringSuffix;
					local textColor:table = {1.0, 1.0, 0.25, 1.0};
					str = str..parcel.parcel.instanceName;

					if parcel.optional == false then
						str = str.."   mandatory";
					else
						str = str.."   optional";
					end

					if ParcelIsValid(parcel.parcel) == false then
						str = str.."   NOT RUN";
						textColor = {0.25, 1.0, 0.25, 1.0};
					elseif ParcelIsActive(parcel.parcel) == false then
						str = str.."   STOPPED";
						textColor = {1.0, 0.25, 0.25, 1.0};
					end

					showParcelName(str, textColor);

					--if this parcel is a metaParcel, then show it's parcels
					if parcel.parcel.IsMetaparcel ~= nil then
						displayParcels(parcel.parcel, "                   ");
					end
				else
					break;
				end
			end
		end
		showTitleText(stringSuffix.."  ");

		if metaParcel.parcelsQueue ~= nil then
			local numQueued:number = metaParcel.parcelsQueue:Count()
			showTitleText(stringSuffix.."Queued Parcels: "..numQueued);
			
			for parcel in queue_elements(metaParcel.parcelsQueue) do
				if IDListnum < listMaxSize then
					local str = parcel.parcel.instanceName;
					local textColor:table = {0, 0, 1.0, 1.0};
					if parcel.optional == false then
						str = str.."   mandatory";
					else
						str = str.."   optional";
					end

					if ParcelIsActive(parcel.parcel) == true then
						textColor = {1.0, 1.0, 0.25, 1.0};
					end
					showParcelName(stringSuffix..str, textColor);
					if parcel.parcel.IsMetaparcel ~= nil then
						displayParcels(parcel.parcel, "                   ");
					end
				else
					break;
				end
			end
		end

		if metaParcel.completedParcels ~= nil then
			local numCompleted:number = metaParcel.completedParcels:Count()
			showTitleText(stringSuffix.."Completed Parcels: "..numCompleted);

			for parcel in set_elements(metaParcel.completedParcels) do
				if IDListnum < listMaxSize then
					showParcelName(stringSuffix..parcel.parcel.instanceName, {.025, 0.25, 0.25, 1.0});
					if parcel.parcel.IsMetaparcel ~= nil then
						displayParcels(parcel.parcel, "                   ");
					end
				else
					break;
				end
			end
		end
	end

	repeat
		showTitleText(title);
		showParcelName(metaParcel.instanceName, {1.0, 1.0, 0.25, 1.0});
		displayParcels(metaParcel);

		--clear extra lines
		for i = IDListnum + 1, listMaxSize do
			ScriptUI_SetTextString(IDList[i], "");
		end
		sleep_s(1);
		IDListnum = 0;
	until ParcelIsValid(metaParcel) == false;
	ScriptUI_Destroy(listID);
end




function DoDebugRegionParcel(regionParcel:table)
	local listID = ScriptUI_CreateListLayout();
	ScriptUI_SetSize(listID, 1, 1, SUI_SCALE_TYPE.Relative, SUI_SCALE_TYPE.Relative);
	ScriptUI_SetPosition(listID, 0.3, 0.22, SUI_SCALE_TYPE.Relative, SUI_SCALE_TYPE.Relative);
	ScriptUI_SetHorizontalAlignment(listID, SUI_HORIZ_ALIGN.Left);
	g_debugMetaParcelsID = listID;

	local title:string = "RegionParcel Debug:";
	local IDList:table = {};
	local IDListnum:number = 0;
	local listMaxSize:number = 30;
	
	ScriptUI_SetListLayoutDirection(listID, SUI_LIST_DIR.Vertical);

	local function createListItem():number
		local ID = ScriptUI_CreateText();
		ScriptUI_SetTextScale(ID, 0.75);
		ScriptUI_SetParent(ID, listID);
		ScriptUI_SetTextString(ID, "");
		return ID;
	end

	for i = 1, listMaxSize do
		IDList[i] = createListItem();
	end

	local function showTitleText(titleName:string)
		if IDListnum < listMaxSize then
			IDListnum = IDListnum + 1;
			ScriptUI_SetTextColor(IDList[IDListnum], 1, 1, 1, 1.0);
			ScriptUI_SetTextString(IDList[IDListnum], titleName);
		end
	end

	local function showParcelName(tableName:string, color:table)
		IDListnum = IDListnum + 1;
			
		tableName = "     "..tableName;
		ScriptUI_SetTextColor(IDList[IDListnum], unpack(color));
		ScriptUI_SetTextString(IDList[IDListnum], tableName);
		ScriptUI_SetTextShadowColor(IDList[IDListnum], 1, 1, 1, 1.0);
	end

	local function displayParcels(metaParcel:table, stringSuffix:string)
		stringSuffix = stringSuffix or "";
		
		if metaParcel.runningParcels ~= nil then
			local numActive:number = metaParcel.runningParcels:Count();
			showTitleText(stringSuffix.."Running Parcels: "..numActive);

			for parcel in set_elements(metaParcel.runningParcels) do
				if IDListnum < listMaxSize then
					local str:string = stringSuffix;
					local textColor:table = {1.0, 1.0, 0.25, 1.0};
					str = str..parcel.parcel.instanceName;

					if parcel.optional == false then
						str = str.."   mandatory";
					else
						str = str.."   optional";
					end

					if ParcelIsValid(parcel.parcel) == false then
						str = str.."   NOT RUN";
						textColor = {0.25, 1.0, 0.25, 1.0};
					elseif ParcelIsActive(parcel.parcel) == false then
						str = str.."   STOPPED";
						textColor = {1.0, 0.25, 0.25, 1.0};
					end

					showParcelName(str, textColor);

					--if this parcel is a metaParcel, then show it's parcels
					if parcel.parcel.IsMetaparcel ~= nil then
						displayParcels(parcel.parcel, "                   ");
					end
				else
					break;
				end
			end
		end
		showTitleText(stringSuffix.."  ");

		if metaParcel.parcelsQueue ~= nil then
			local numQueued:number = metaParcel.parcelsQueue:Count()
			showTitleText(stringSuffix.."Queued Parcels: "..numQueued);
			
			for parcel in queue_elements(metaParcel.parcelsQueue) do
				if IDListnum < listMaxSize then
					local str = parcel.parcel.instanceName;
					local textColor:table = {0, 0, 1.0, 1.0};
					if parcel.optional == false then
						str = str.."   mandatory";
					else
						str = str.."   optional";
					end

					if ParcelIsActive(parcel.parcel) == true then
						textColor = {1.0, 1.0, 0.25, 1.0};
					end
					showParcelName(stringSuffix..str, textColor);
					if parcel.parcel.IsMetaparcel ~= nil then
						displayParcels(parcel.parcel, "                   ");
					end
				else
					break;
				end
			end
		end

		if metaParcel.completedParcels ~= nil then
			local numCompleted:number = metaParcel.completedParcels:Count()
			showTitleText(stringSuffix.."Completed Parcels: "..numCompleted);

			for parcel in set_elements(metaParcel.completedParcels) do
				if IDListnum < listMaxSize then
					showParcelName(stringSuffix..parcel.parcel.instanceName, {.025, 0.25, 0.25, 1.0});
					if parcel.parcel.IsMetaparcel ~= nil then
						displayParcels(parcel.parcel, "                   ");
					end
				else
					break;
				end
			end
		end
	end

	local function displayRegionParcel(regionParcel:table, stringSuffix:string)
		stringSuffix = stringSuffix or "";
		
		if regionParcel.parcelsQueue ~= nil then
			local numQueued:number = regionParcel.parcelsQueue:Count()
			showTitleText(stringSuffix.."Parcels: "..numQueued);
			
			for parcel in queue_elements(regionParcel.parcelsQueue) do
				if IDListnum < listMaxSize then
					local str:string = stringSuffix;
					local textColor:table = {1.0, 1.0, 0.25, 1.0};
					str = str..parcel.parcel.instanceName;

					if parcel.optional == false then
						str = str.."   mandatory";
					else
						str = str.."   optional";
					end

					if ParcelIsValid(parcel.parcel) == false then
						str = str.."   ENDED";
						textColor = {0.25, 1.0, 0.25, 1.0};
					elseif ParcelIsActive(parcel.parcel) == false then
						str = str.."   STOPPED";
						textColor = {1.0, 0.25, 0.25, 1.0};
					end

					showParcelName(str, textColor);

					--if this parcel is a metaParcel, then show it's parcels
					if parcel.parcel.IsMetaparcel ~= nil then
						displayParcels(parcel.parcel, "                   ");
					end
				else
					break;
				end
			end
		end
	end

	repeat
		showTitleText(title);
		showParcelName(regionParcel.instanceName, {1.0, 1.0, 0.25, 1.0});
		displayRegionParcel(regionParcel);

		--clear extra lines
		for i = IDListnum + 1, listMaxSize do
			ScriptUI_SetTextString(IDList[i], "");
		end
		sleep_s(1);
		IDListnum = 0;
	until ParcelIsValid(regionParcel) == false;
	ScriptUI_Destroy(listID);
end

------------------------------------------------
-- Debug approved events
------------------------------------------------

global UserEventFilter = table.makeAutoEnum
{
	"Animator",
	"CharacterDesigner",
	"CharacterEngineer",
	"WorldDesigner",
	"QA",
	"Count",
};

function ApplyUserFilteredChannels(category:string)
	-- Events levels: verbose, status, message, warning, error, critical

	-- Enables events in Faber output.
	events_category_editor(category, EVENT.warning);
	-- Enables events in game window
	events_category_display(category, EVENT.error);
end

function FilterToApprovedUserEvents(userFilter:number)
	if (userFilter < 0 or userFilter >= UserEventFilter.Count) then
		print("Failed: unknown user type passed to FilterToApprovedUserEvents. Use with UserEventFilter enum.");
		return;
	end

	-- Clears events in Faber output.
	events_clear_editor_channel();
	-- Clears events in game window.
	events_clear_output_channel();

	-- Common filters
	if (userFilter ~= UserEventFilter.QA) then
		ApplyUserFilteredChannels("content");
		ApplyUserFilteredChannels("crash");
		ApplyUserFilteredChannels("design");
		ApplyUserFilteredChannels("hs");
		ApplyUserFilteredChannels("lifecycle");
	end

	if (userFilter == UserEventFilter.Animator) then
		ApplyUserFilteredChannels("Animation Content");
	elseif (userFilter == UserEventFilter.CharacterDesigner) then
		ApplyUserFilteredChannels("Character Design Content");
	elseif (userFilter == UserEventFilter.CharacterEngineer) then
		-- Engineers are interested in code and content failures.
		ApplyUserFilteredChannels("Character Design Content");
		ApplyUserFilteredChannels("Character Engineering");
	elseif (userFilter == UserEventFilter.WorldDesigner) then
		ApplyUserFilteredChannels("World Design Content");
	elseif (userFilter == UserEventFilter.QA) then
		-- QA is interested in all failures.
		ApplyUserFilteredChannels("Animation Content");
		ApplyUserFilteredChannels("Character Design Content");
		ApplyUserFilteredChannels("Character Engineering");
		ApplyUserFilteredChannels("World Design Content");
	end
end

------------------------------------------------
-- Debug AI Spawning
------------------------------------------------

function AI_SpawnAtPlayer(ai_tag, calling_player:player, weapon_tag)
	local dropAi:table = SquadBuilder:BuildSimpleSquad(ai_tag, "debug_drop_ai", 1, {cells = {{upgrade="none"}}});
	local dropSquad:ai = SquadBuilder:PlaceSquad(dropAi, ToLocation(GetLookPosition(PLAYERS.player0, 5)), false);
	
	if (calling_player ~= nil) then
		set_ai_squad_campaign_and_mp_team( dropSquad, Player_GetCampaignTeam(calling_player), Player_GetMultiplayerTeam(calling_player));
	end
	if (weapon_tag ~= nil) then
		if (unit_has_weapon(dropSquad, weapon_tag) and unit_has_weapon_readied(dropSquad, weapon_tag) == false) then
			ai_swap_weapons(dropSquad);
		else
			local weapon = Object_CreateFromTag(weapon_tag);
			Unit_GiveWeapon(dropSquad, weapon, WEAPON_ADDITION_METHOD.PrimaryWeapon);
		end
	end
	local dropObject:object = ai_actors(dropSquad)[1];
	RegisterEventOnce(g_eventTypes.objectDamagedEvent, AI_SpawnAtPlayerOnDamage, dropObject, dropObject, ai_tag);
end

function AI_SpawnAtPlayerOnDamage(damageEvent, dropObject, ai_tag):void
	local damageStartTime:time_point = Game_TimeGet();
	RegisterEventOnce(g_eventTypes.deathEvent, AI_SpawnAtPlayerOnDeath, dropObject, damageStartTime, ai_tag);
end

function AI_SpawnAtPlayerOnDeath(deathEvent, damageStartTime, ai_tag):void
	local deathTime:time_point = Game_TimeGet();
	local timeToKill = deathTime:ElapsedTime(damageStartTime)
	local res = string.format("time to kill of %.2f seconds", timeToKill);
	print(ai_tag, res);
end

function AI_SpawnInquisitor(ai_tag)
	local dropAi:table = SquadBuilder:BuildSimpleSquad(ai_tag, "debug_drop_ai", 1, {cells = {{upgrade="none"}}});
	local dropSquad:ai = SquadBuilder:PlaceSquad(dropAi, ToLocation(GetLookPosition(PLAYERS.player0, 5)), false);
	local bossObject = ai_actors(dropSquad)[1];
	bossObject:onChamberFailed();
end

function remoteServer.AI_SpawnAtPlayer(ai_tag, calling_player:player, weapon_tag)
	AI_SpawnAtPlayer(ai_tag, calling_player, weapon_tag);
end

function remoteServer.AI_SpawnInquisitor(ai_tag)
	AI_SpawnInquisitor(ai_tag);
end


--[[
.___________. _______     _______.___________.   .______    __    __  .___________.___________.  ______   .__   __.     ___________    ____  _______ .__   __. .___________.    _______.
|           ||   ____|   /       |           |   |   _  \  |  |  |  | |           |           | /  __  \  |  \ |  |    |   ____\   \  /   / |   ____||  \ |  | |           |   /       |
`---|  |----`|  |__     |   (----`---|  |----`   |  |_)  | |  |  |  | `---|  |----`---|  |----`|  |  |  | |   \|  |    |  |__   \   \/   /  |  |__   |   \|  | `---|  |----`  |   (----`
	|  |     |   __|     \   \       |  |        |   _  <  |  |  |  |     |  |        |  |     |  |  |  | |  . `  |    |   __|   \      /   |   __|  |  . `  |     |  |        \   \    
	|  |     |  |____.----)   |      |  |        |  |_)  | |  `--'  |     |  |        |  |     |  `--'  | |  |\   |    |  |____   \    /    |  |____ |  |\   |     |  |    .----)   |   
	|__|     |_______|_______/       |__|        |______/   \______/      |__|        |__|      \______/  |__| \__|    |_______|   \__/     |_______||__| \__|     |__|    |_______/    
																																														
--]]

--function testInput()
	--RegisterButtonPress(InputEventsEnumTable.up, testInputFunction, "foo");
	--RegisterButtonPress(InputEventsEnumTable.down, testInputFunction, "bar");
	--RegisterButtonPress(InputEventsEnumTable.up, testInputFunctionTwo, "goo");
--end
--
--function testRemoveInput()
	--UnregisterButtonPress(InputEventsEnumTable.up, testInputFunction);
--end
--
--function testInputFunction(struct, str:string)
	--print(str);
	--if struct.state == true then
		--print("the button was pressed");
	--else
		--print("the button was held");
	--end
--end
--
--function testInputFunctionTwo(struct, str:string)
	--print(str);
	--if struct.state == true then
		--print("the button was pressed");
	--else
		--print("the button was held");
	--end
--end



-- Save slot stuff for easier testing.
function PrintCurrentSaveSlot()
	print("Current save slot = " .. Player_ReadSaveSlot());
end

function CycleSaveSlots()
	local currentIndex = Player_ReadSaveSlot();

	if currentIndex > 2 then
		currentIndex = 0;
	else
		currentIndex = currentIndex + 1;
	end
	print("Changing save slot to index " .. currentIndex);
	Player_SetSaveSlot(currentIndex);
end






--## CLIENT

remoteClient["print"] = print
remoteClient["DropToPlayer"] = DropToPlayer
remoteClient["DropVariantToPlayer"] = DropVariantToPlayer
remoteClient["DropPermutationToPlayer"] = DropPermutationToPlayer
remoteClient["DropObjectConfigurationToPlayer"] = DropObjectConfigurationToPlayer

function remoteClient.LoomOWLevelClient(level, zone):void
	LoomScenario(level, zone );
end

