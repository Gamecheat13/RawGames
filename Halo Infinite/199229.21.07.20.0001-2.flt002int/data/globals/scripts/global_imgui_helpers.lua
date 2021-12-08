-- Copyright (c) Microsoft. All rights reserved.
REQUIRES('globals/scripts/global_ai.lua')
REQUIRES('globals/scripts/global_kits.lua')
REQUIRES('globals/scripts/global_navpoints.lua')

global imguiVars:table = 
	{
		red = color_rgba(1, 0, 0, 1),
		green = color_rgba(0, 1, 0, 1),
		blue = color_rgba(0, 0, 1, 1),
		yellow = color_rgba(1, 1, 0, 1),
		headerBlue = color_rgba(0, 0.25, 0.75, 1),
		headerOrange =  color_rgba(0.82, 0.32, 0.08, 1),
	}

function imguiVars.standardButton(buttonName, func:ifunction, ...)
	if func == nil or type(func) ~= "function" then
		return;
	end

	ImGui_PushStyleColor(IMGUI_STYLE_COLOR.ImGuiCol_Button, imguiVars.blue);
	ImGui_PushStyleColor(IMGUI_STYLE_COLOR.ImGuiCol_ButtonHovered, imguiVars.green);
	ImGui_PushStyleColor(IMGUI_STYLE_COLOR.ImGuiCol_ButtonActive, imguiVars.red);
	if ImGui_Button(imguiVars.GetFormattedString(buttonName)) == true then
		local funcCompleted = pcall(func, ...);
		if funcCompleted == false then
			print("Debug button function asserted", debug.getinfo(func).name);
		end
	end
	ImGui_PopStyleColor();
	ImGui_PopStyleColor();
	ImGui_PopStyleColor();
end

function imguiVars.plainButton(buttonName, func:ifunction, ...)
	if func == nil or type(func) ~= "function" then
		return;
	end

	if ImGui_Button(imguiVars.GetFormattedString(buttonName)) == true then
		local funcCompleted = pcall(func, ...);
		if funcCompleted == false then
			print("Debug button function asserted", debug.getinfo(func).name);
		end
	end
end

function imguiVars.standardHeader(headerName, func:ifunction, ...)
	if func == nil or type(func) ~= "function" then
		return;
	end
	
	ImGui_PushStyleColor(IMGUI_STYLE_COLOR.ImGuiCol_Header, imguiVars.headerBlue);
	ImGui_PushStyleColor(IMGUI_STYLE_COLOR.ImGuiCol_HeaderHovered, imguiVars.green);
	ImGui_PushStyleColor(IMGUI_STYLE_COLOR.ImGuiCol_HeaderActive, imguiVars.red);
	if ImGui_CollapsingHeader(imguiVars.GetFormattedString(headerName)) == true then
		ImGui_Indent();
		local funcCompleted = pcall(func, ...);
		if funcCompleted == false then
			print("Debug header function asserted")
			print("  func name is:",debug.getinfo(func).name);
			print("  func location is:", debug.getinfo(func).short_src, ":",debug.getinfo(func).linedefined);
			error("assert here to not break engine: "..headerName);
		end
		ImGui_Unindent();
	end
	ImGui_PopStyleColor();
	ImGui_PopStyleColor();
	ImGui_PopStyleColor();
end

function imguiVars.standardText(textheaderName, color):void
	textheaderName = imguiVars.GetFormattedString(textheaderName);
	if color and type(color) == "userdata" then
		ImGui_PushStyleColor(IMGUI_STYLE_COLOR.ImGuiCol_Text, color);
		ImGui_Text(textheaderName);
		ImGui_PopStyleColor();
	else
		ImGui_Text(textheaderName);
	end
end

function imguiVars.standardTwoItemInfo(textOne, ...):void
	ImGui_Text(imguiVars.GetFormattedString(textOne));
	ImGui_SameLine();
	ImGui_PushStyleColor(IMGUI_STYLE_COLOR.ImGuiCol_Text, imguiVars.yellow);
	ImGui_Text(imguiVars.getString(unpack(arg)));
	ImGui_PopStyleColor();
end

-- for example,		imguiVars.multiText(imguiVars.yellow, "first", "second", "third");
--looks like:  first second third
--don't have to mess with concatenation or worry that something might be nil
function imguiVars.multiText(...)
	--loop through the ...
	local count:number = arg.n;
	if count > 1 then
		for idx = 1, count -1 do
			ImGui_Text(imguiVars.GetFormattedString(arg[idx]));
			ImGui_SameLine();
		end
	end
	ImGui_Text(imguiVars.GetFormattedString(arg[count]));
end

function imguiVars.multiTextWithColor(color, ...):void
	--if color then pushstyle
	if color and type(color) == "userdata" then ImGui_PushStyleColor(IMGUI_STYLE_COLOR.ImGuiCol_Text, color) end;
	--loop through the ...
	imguiVars.multiText(...)

	--if color then popstyle
	if color and type(color) == "userdata" then ImGui_PopStyleColor() end;
end

function imguiVars.getString(...):string
	local newString:string = imguiVars.GetFormattedString(arg[1]);
	--loop through the ...
	local count:number = arg.n;
	for idx = 2, count do
		newString = newString.." "..imguiVars.GetFormattedString(arg[idx]);
	end
	return newString;
end

function imguiVars.GetFormattedString(item):string
	local printError, itemName = pcall(GetEngineString, item);
	if printError == false then
		itemName = GetEngineType(item);
	end
	--not happy with this
	if GetEngineType(item) == "function" then
		itemName = imguiVars.GetDebugStringForFunction(item);
	elseif GetEngineType(itemName) == "object_name" then
		itemName = "null";
	end
	return itemName;
end

function imguiVars.GetDebugStringForFunction(func):string
	local name:string = debug.getinfo(func).name;
	local path:string = debug.getinfo(func).short_src;
	local lineNum:number = debug.getinfo(func).linedefined;
	path = string.sub(path, 27);
	return name.." "..path.." "..lineNum;
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- imguiVars AI functions
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--## SERVER

function imguiVars.ShowKitAiInfo(spawnerList:table)
	if spawnerList == nil then
		return;
	end
	--show num spawners and living count
	local livingCount, virtualCount = AI_GetActorCountsFromSpawnerTable(spawnerList);
	imguiVars.standardTwoItemInfo("Total Squad Spawners:", #spawnerList);
	imguiVars.standardTwoItemInfo("Total Living Actors:", livingCount);
	imguiVars.standardTwoItemInfo("Total Virtual Actors:", virtualCount);
end

function imguiVars.ShowAllSpawnersInKitsRecursive(kit:folder, nameOfKit:string):void
	if kit == nil then
		return;
	end
	nameOfKit = nameOfKit or kit.NAME or kit.components.NAME;
	imguiVars.standardTwoItemInfo("AI Info for: ", nameOfKit);
	local spawnerList:table = Kits_GetComponentsOfTypeRecursive(kit, "squad_spawner");
	local numSpawners:number = #spawnerList;
	if numSpawners > 0 then
		imguiVars.ShowKitAiInfo(spawnerList);
		--show all spawners in kit
		imguiVars.ShowSpawnerListInformation(spawnerList);

	else
		imguiVars.standardText("No Squad Spawners");
	end
	ImGui_Text("");
end

function imguiVars.ShowSpawnerListInformation(spawnerList:table):void
	if spawnerList == nil then
		return;
	end
	for _, spawner in ipairs(spawnerList) do
		imguiVars.ShowSpawnerInformation(spawner)
	end
end

function imguiVars.ShowSpawnerInformation(spawner:squad_spawner):void
	if spawner == nil then
		return;
	end
	
	local name:string = string.sub(imguiVars.GetFormattedString(spawner), 15);
	
	local additionalText:string = imguiVars.GetFormattedString(Spawner_GetSquadSpec(spawner));
	if additionalText ~= "invalid tag" then
		additionalText = imguiVars.getString(AI_GetActorCountsFromSpawner(spawner), "Living");
	end
	
	if ImGui_CollapsingHeader(imguiVars.getString("Squad Spawner Name:", name, additionalText)) == true then
		ImGui_Indent();
		imguiVars.standardTwoItemInfo("SquadSpec Tag:", Spawner_GetSquadSpec(spawner));
		imguiVars.standardTwoItemInfo("Is Initially Placed:", Spawner_IsInitiallyPlaced(spawner));
		imguiVars.standardTwoItemInfo("Spawn Method:", Spawner_GetSpawnMethod(spawner));
		imguiVars.standardTwoItemInfo("Initial Combat State:", Spawner_GetInitialCombatState(spawner));
		imguiVars.standardTwoItemInfo("Radius:", Spawner_GetRadius(spawner));
		local ez = AI_GetEncounterInstanceFromSquadSpawner(spawner);
		imguiVars.standardTwoItemInfo("Encounter Zone:", ez);
		imguiVars.standardTwoItemInfo("Encounter Zone State:",  AI_GetEncounterPresence(ez));
		imguiVars.standardTwoItemInfo("Location:", ToLocation(spawner).vector);
		ImGui_SameLine();
		imguiVars.standardButton("Navpoint Spawner Location", NavpointShowAtLocation, ToLocation(spawner).vector);
		
		--total spawned
		imguiVars.standardTwoItemInfo("Total Spawned:", AI_GetActorSpawnedCountFromSpawner(spawner));

		--failed to spawn
		imguiVars.standardTwoItemInfo("Total Actors Failed to Spawn:", AI_GetFailedActorSpawnCountFromSpawner(spawner));
		local spawnerFailed = AI_SpawnerFailedToSpawn(spawner);
		local spawnerIsDefeated = AI_SpawnerIsDefeated(spawner);
		imguiVars.standardTwoItemInfo("Failed to Spawn:", spawnerFailed);
		imguiVars.standardTwoItemInfo("Spawner is Defeated:", spawnerIsDefeated);


		
		
		if additionalText ~= "invalid tag" then
			imguiVars.standardButton("Spawn Squad", function() Spawner_SpawnSquad(spawner) end);
		end
		if GetEngineString(ez) == "script handle: -1" then
			imguiVars.standardTwoItemInfo("WARNING:", "no encounter zone");
		else
			local virtualSquadList:table = AI_GetAllSquadInstancesFromSquadSpawner(spawner);
			imguiVars.ShowVirtualSquadListInformation(virtualSquadList);
		end
		
		imguiVars.standardHeader("Show Kit Hierarchy of Spawner", imguiVars.displayKitHierarchyFromItem, spawner);
		ImGui_Unindent();
	end
end

function imguiVars.ShowVirtualSquadListInformation(virtualSquadList:table):void
	if virtualSquadList == nil then
		return;
	end
	if #virtualSquadList == 0 then
		ImGui_Text("No Spawned Squads");
	else
		for _, virtualSquad in ipairs(virtualSquadList) do
			imguiVars.ShowVirtualSquadInformation(virtualSquad);
		end
	end
end

function imguiVars.ShowVirtualSquadInformation(virtualSquad:handle):void
	if virtualSquad == nil then
		return;
	end
	
	imguiVars.multiText("Virtual Squad Information:");
	ImGui_Indent();
	imguiVars.standardTwoItemInfo("Campaign Team:", AI_GetVirtualSquadCampaignTeam(virtualSquad));
	imguiVars.standardTwoItemInfo("Encounter Zone:", AI_GetEncounterInstanceFromSquadInstance(virtualSquad));
	imguiVars.standardTwoItemInfo("Objective Instance:", AI_GetObjectiveInstanceFromSquadInstance(virtualSquad));
	
	local squad = AI_GetAISquadFromSquadInstance(virtualSquad);
	if squad ~= nil then
		 imguiVars.ShowSquadInformation(squad);
	else
		local numVirtualActors:number = #AI_GetVirtualActorsInVirtualSquad(virtualSquad);
		imguiVars.standardTwoItemInfo("Number of Virtual Actors:", numVirtualActors);
		ImGui_Text("");
	end
	ImGui_Unindent();
end

function imguiVars.ShowSquadListInformation(squadList:table):void
	if squadList == nil then
		return;
	end
	for _, squad in ipairs(squadList) do
		imguiVars.ShowSquadInformation(squad);
	end
end

function imguiVars.ShowSquadInformation(squad:ai):void
	if squad == nil then
		return;
	end
	
	ImGui_PushStringID(tostring(squad)..tostring(math.random));
		local spawner = AI_GetSquadSpawnerFromSquadInstance(AI_GetSquadInstanceFromAISquad(squad));
		imguiVars.ShowSpawnerInformation(spawner);
	ImGui_PopID();

	local objList = ai_actors(squad);
	local numLivingActors:number = #objList;
	
	imguiVars.standardTwoItemInfo("Number of Living Actors:",numLivingActors);
	if numLivingActors == 0 then
		ImGui_Text("");
		return;
	end

	imguiVars.multiText("Units are:");
	ImGui_Indent();
	for _, obj in ipairs(objList) do
		--make this a header
		imguiVars.ShowUnitInformation(obj);
		ImGui_Text("");
	end
	ImGui_Unindent();

	--button to kill all
	local killAI = function()
		ai_erase(squad);
	end
	ImGui_PushStringID(tostring(squad));
	imguiVars.standardButton("Kill Spawner Squad", killAI);
	
	--button to navpoint all
	local showNav = function()
		for _, unit in ipairs(objList) do
			NavpointShowObject(unit, "navpoint_wz_kill_ultraboss");
		end
	end
	imguiVars.standardButton("Show Navpoints on Squad", showNav);
	
	ImGui_Text("");
	ImGui_PopID();
end

function imguiVars.ShowUnitInformation(unit:object):void
	local actor = Actor_GetActorFromObject(unit);
	if actor == nil then
		return;
	end
	
	imguiVars.standardTwoItemInfo("Character:", Object_GetDefinition(unit));
	imguiVars.standardTwoItemInfo("Vehicle:", ai_vehicle_get(Unit_GetActor(unit)));
	imguiVars.standardTwoItemInfo("Health:", unit_get_health(unit));
	imguiVars.standardTwoItemInfo("Weapon:",  Object_GetDefinition(unit_get_primary_weapon(unit)));
	ImGui_PushStringID(tostring(unit)..tostring(math.random));
	imguiVars.standardHeader(imguiVars.getString("Debug Unit:", unit), sys_DebugObject, unit);
	ImGui_PopID();
	--AI_GetTargetObject(ai)


	--make braindead?
	--kill actor?
	
	--imguiVars.ShowSquadInformation(squad);
	local squad = ai_get_squad(object_get_ai(unit));
		
	--show the squad
	ImGui_PushStringID(tostring(unit)..tostring(math.random));
		imguiVars.standardHeader("Debug Squad", imguiVars.ShowSquadInformation, squad);
	ImGui_PopID();

end

function imguiVars.displayKitHierarchyFromItem(item)
	local kit, name, rootKit = DEBUG_GetKitHierarchyForItemFromAllKits(item)
	ImGui_PushStringID(tostring(item)..tostring(math.random));
	if kit ~= nil then
		imguiVars.standardText(name, imguiVars.yellow);
		imguiVars.standardHeader(imguiVars.getString("Item Kit:", kit.NAME or kit.components.NAME), sys_DebugTable, kit);
		imguiVars.standardHeader(imguiVars.getString("Root Kit:", rootKit.NAME or rootKit.components.NAME), sys_DebugTable, rootKit);
	else
		imguiVars.standardText("Not in Kit", imguiVars.yellow);
	end
	ImGui_PopID();
end