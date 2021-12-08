-- Copyright (c) Microsoft. All rights reserved.

REQUIRES('globals/scripts/global_ai.lua')

--## SERVER

global g_cellUpgrades =
	{
		normal	= "normal",
		few			= "few",
		many		= "many",
		none		= "none",
		all			= "all",
	};
	

--  .______    __    __   __   __       _______          _______.  ______      __    __       ___       _______  
--  |   _  \  |  |  |  | |  | |  |     |       \        /       | /  __  \    |  |  |  |     /   \     |       \ 
--  |  |_)  | |  |  |  | |  | |  |     |  .--.  |      |   (----`|  |  |  |   |  |  |  |    /  ^  \    |  .--.  |
--  |   _  <  |  |  |  | |  | |  |     |  |  |  |       \   \    |  |  |  |   |  |  |  |   /  /_\  \   |  |  |  |
--  |  |_)  | |  `--'  | |  | |  `----.|  '--'  |   .----)   |   |  `--'  '--.|  `--'  |  /  _____  \  |  '--'  |
--  |______/   \______/  |__| |_______||_______/    |_______/     \_____\_____\\______/  /__/     \__\ |_______/ 
--                                                                                                               


global SquadBuilder = table.makePermanent {};

function SquadBuilder:BuildBanishedSquadDescription(character:tag, squadName:string, count:number, taskKeyword:string_id):table
	taskKeyword = taskKeyword or ObjectiveTaskKeywords.Frontline;
	return self:BuildSimpleSquadDescription(character, squadName, count, TEAM.covenant, MP_TEAM.mp_team_yellow, taskKeyword);
end

function SquadBuilder:BuildUnscSquadDescription(character:tag, squadName:string, count:number, taskKeyword:string_id):table
	taskKeyword = taskKeyword or ObjectiveTaskKeywords.Frontline;
	return self:BuildSimpleSquadDescription(character, squadName, count, TEAM.player, MP_TEAM.mp_team_red, taskKeyword);
end

function SquadBuilder:BuildSentinelSquadDescription(character:tag, squadName:string, count:number, taskKeyword:string_id):table
	taskKeyword = taskKeyword or ObjectiveTaskKeywords.Frontline;
	return self:BuildSimpleSquadDescription(character, squadName, count, TEAM.forerunner, MP_TEAM.mp_team_orange, taskKeyword);
end

function SquadBuilder:BuildWildlifeSquadDescription(character:tag, squadName:string, count:number, taskKeyword:string_id):table
	taskKeyword = taskKeyword or ObjectiveTaskKeywords.Frontline;
	return self:BuildSimpleSquadDescription(character, squadName, count, TEAM.neutral, MP_TEAM.mp_team_green, taskKeyword);
end

function SquadBuilder:BuildSimpleSquadDescription(character:tag, squadName:string, count:number, campaignTeam:team, mpTeam:mp_team, taskKeyword:string_id):table
	local unitSquad = self:BuildSimpleSquad(character, squadName, count);
	unitSquad.team = campaignTeam;
	unitSquad.mpteam = mpTeam;
	unitSquad.taskkeyword = taskKeyword;
	unitSquad.spawnkeyword = ObjectiveSpawnKeywords.Default;	
	return unitSquad;
end

--build a squad using just a handful of commonly used arguments
function SquadBuilder:BuildSimpleSquad(char:tag, name:string, count:number, squadMakeup:table):table
	squadMakeup = squadMakeup or {};
	squadMakeup.name = name;
	squadMakeup.cells = squadMakeup.cells or {};
	squadMakeup.cells[1] = squadMakeup.cells[1] or {};
	squadMakeup.cells[1].character = char;
	squadMakeup.cells[1].count = count;
	
	return self:BuildSquadFromTable(squadMakeup);
end

function SquadBuilder:BuildSquadFromTable(squadMakeup:table):table
	if squadMakeup.cells[1].character == nil and squadMakeup.cells[1].vehicle == nil then
		print ("SquadBuilder: no valid character given in BuildSquadFromTable");
	end
	
	local squad:table = 
	{
		numCells = 1,
		name = squadMakeup.name,
		cells = 
		{
			{
				name = squadMakeup.name or "default",
				count = tonumber(squadMakeup.cells[1].count) or 1,
				upgrade = squadMakeup.cells[1].upgrade or "normal",
				character = squadMakeup.cells[1].character,
				primary = squadMakeup.cells[1].primary,
				secondary = squadMakeup.cells[1].secondary,
				vehicle = squadMakeup.cells[1].vehicle
			},
		},
	};
	squad = setmetatable (squad, {__index = SquadFunctions});
	
	return squad;
end


--  .__   __.   ______    _______   _______     _______  __    __  .__   __.   ______ .___________. __    ______   .__   __.      _______.
--  |  \ |  |  /  __  \  |       \ |   ____|   |   ____||  |  |  | |  \ |  |  /      ||           ||  |  /  __  \  |  \ |  |     /       |
--  |   \|  | |  |  |  | |  .--.  ||  |__      |  |__   |  |  |  | |   \|  | |  ,----'`---|  |----`|  | |  |  |  | |   \|  |    |   (----`
--  |  . `  | |  |  |  | |  |  |  ||   __|     |   __|  |  |  |  | |  . `  | |  |         |  |     |  | |  |  |  | |  . `  |     \   \    
--  |  |\   | |  `--'  | |  '--'  ||  |____    |  |     |  `--'  | |  |\   | |  `----.    |  |     |  | |  `--'  | |  |\   | .----)   |   
--  |__| \__|  \______/  |_______/ |_______|   |__|      \______/  |__| \__|  \______|    |__|     |__|  \______/  |__| \__| |_______/    
--                                                                                                                                        


--places a squad from a squad table
function SquadBuilder:PlaceSquad(squadTable:table, loc, limbo:boolean, intensity:number):ai
	local squadNode = SG.CreateSquadBuilder(squadTable)
	local aiSquad = self:PlaceNode(squadNode, loc, limbo, intensity);
	NG.Destroy( squadNode );
	return aiSquad;
end

function SquadBuilder:PlaceSquadDescFunc(squadDescFunc:ifunction, loc:location, intensity:number, deployInfo:table):ai
	assert(_G["SquadBuilderTable"] ~= nil, "Include SquadBuilderLibrary.lua");
	local squadDescription:SquadDescription = _G["SquadBuilderTable"]:Request(squadDescFunc);
	return SquadBuilder:PlaceSquadDescription(squadDescription, loc, intensity, deployInfo);
end

function SquadBuilder:PlaceSquadDescription(squadDesc:SquadDescription, loc:location, intensity:number, deployInfo:table):ai
	intensity = intensity or SquadIntensity.Default;
	local tableOfSquads:table = GetSquadTableFromDescription(squadDesc, intensity);
	return self:PlaceSquads(tableOfSquads, loc, intensity, deployInfo);
end

--places squads from a table of squads and combines them into one squad
function SquadBuilder:PlaceSquads(tableOfSquads:table, loc:location, intensity:number, deployInfo:table):ai
	local squadGenContainer:table = SquadGenGraphContainer.New("temp");
	local node = SquadBuilder:CombineSquads(squadGenContainer, tableOfSquads);
	local aiSquad = nil;
	if(loc == nil) then
		aiSquad = self:PlaceNode(node, vector(0,0,0), false, intensity, deployInfo);
	else
		aiSquad = self:PlaceNode(node, loc, false, intensity, deployInfo);
	end
	
	squadGenContainer:Destroy();
	return aiSquad;
end

--places squads from a table of squads and parents them to a squad (useful for keeping the squads different for individual tasks)
function SquadBuilder:PlaceIndividualSquads(tableOfSquadsArray):ai
	local squadNode = nil;
	local aiSquad = nil;
	local parentSquad = nil;
	for _, squad in ipairs (tableOfSquadsArray) do
		squadNode = SG.CreateSquadBuilder(squad)
		aiSquad = self:PlaceNode(squadNode);
		if parentSquad == nil then
			parentSquad = aiSquad;
		else
			ai_set_squad_parent (aiSquad, parentSquad);
		end
		NG.Destroy( squadNode );
	end
	
	return parentSquad;
end

--places a squad from a squad node
function SquadBuilder:PlaceNode(squadNode, loc, limbo:boolean, intensity:number, deployInfo:table):ai
	dprint ("SquadBuilder: place Node")
	
	local deploymentInfo = deployInfo;
	if (deploymentInfo == nil) then
		deploymentInfo = AIDeploymentInfo.New();
		deploymentInfo:SetDeploymentDefaultPosition(ToLocation(loc));
		if limbo == true then
			deploymentInfo:SetDeploymentMode(SG.DeploymentMode.Limbo)
		end
	end
	
	assert(loc ~= nil, "SquadBuilder, the squadNode does not have a legitimate DefaultPosition (location)");

	local aiSquad = nil;
	if (GetEngineType(squadNode) == "node_graph_node") then
		aiSquad = sg_build_squads(squadNode, 0, {intensity = intensity or SquadIntensity.Default}, deploymentInfo);
	else
		assert(GetEngineType(squadNode) == "table");
		aiSquad = sg_build_squads(squadNode.NodeID, 0, {intensity = intensity or SquadIntensity.Default}, deploymentInfo);
	end
	
	return aiSquad;
end

--links AI nodes together so that when they spawn they are in one squad
function SquadBuilder:CombineSquads(squadGenContainer:table, tableOfSquads:table):node_graph_node
	local sqCollection = squadGenContainer:CreateCombineSquads();
	local squadNode = nil;
	--link the outs from the squad nodes to the in of the squad collection node
	for _, squad in ipairs (tableOfSquads) do
		squadNode = squadGenContainer:CreateSquadBuilder(squad);
		NG.CreateLink(squadNode.Out, sqCollection.Squads);
	end
	return sqCollection;
end



--       _______. __  .___  ___. .______    __       _______     _______  __    __  .__   __.   ______ .___________. __    ______   .__   __.      _______.
--      /       ||  | |   \/   | |   _  \  |  |     |   ____|   |   ____||  |  |  | |  \ |  |  /      ||           ||  |  /  __  \  |  \ |  |     /       |
--     |   (----`|  | |  \  /  | |  |_)  | |  |     |  |__      |  |__   |  |  |  | |   \|  | |  ,----'`---|  |----`|  | |  |  |  | |   \|  |    |   (----`
--      \   \    |  | |  |\/|  | |   ___/  |  |     |   __|     |   __|  |  |  |  | |  . `  | |  |         |  |     |  | |  |  |  | |  . `  |     \   \    
--  .----)   |   |  | |  |  |  | |  |      |  `----.|  |____    |  |     |  `--'  | |  |\   | |  `----.    |  |     |  | |  `--'  | |  |\   | .----)   |   
--  |_______/    |__| |__|  |__| | _|      |_______||_______|   |__|      \______/  |__| \__|  \______|    |__|     |__|  \______/  |__| \__| |_______/    
--                                                                                                                                                         


function CopySquad(squadTable):table
	return table.copy(squadTable, true);
end



--       _______.  ______      __    __       ___       _______      _______  __    __  .__   __.   ______ .___________. __    ______   .__   __.      _______.   .__   __.      ___      .___  ___.  _______     _______..______      ___       ______  _______ 
--      /       | /  __  \    |  |  |  |     /   \     |       \    |   ____||  |  |  | |  \ |  |  /      ||           ||  |  /  __  \  |  \ |  |     /       |   |  \ |  |     /   \     |   \/   | |   ____|   /       ||   _  \    /   \     /      ||   ____|
--     |   (----`|  |  |  |   |  |  |  |    /  ^  \    |  .--.  |   |  |__   |  |  |  | |   \|  | |  ,----'`---|  |----`|  | |  |  |  | |   \|  |    |   (----`   |   \|  |    /  ^  \    |  \  /  | |  |__     |   (----`|  |_)  |  /  ^  \   |  ,----'|  |__   
--      \   \    |  |  |  |   |  |  |  |   /  /_\  \   |  |  |  |   |   __|  |  |  |  | |  . `  | |  |         |  |     |  | |  |  |  | |  . `  |     \   \       |  . `  |   /  /_\  \   |  |\/|  | |   __|     \   \    |   ___/  /  /_\  \  |  |     |   __|  
--  .----)   |   |  `--'  '--.|  `--'  |  /  _____  \  |  '--'  |   |  |     |  `--'  | |  |\   | |  `----.    |  |     |  | |  `--'  | |  |\   | .----)   |      |  |\   |  /  _____  \  |  |  |  | |  |____.----)   |   |  |     /  _____  \ |  `----.|  |____ 
--  |_______/     \_____\_____\\______/  /__/     \__\ |_______/    |__|      \______/  |__| \__|  \______|    |__|     |__|  \______/  |__| \__| |_______/       |__| \__| /__/     \__\ |__|  |__| |_______|_______/    | _|    /__/     \__\ \______||_______|
--                                                                        
global SquadFunctions = {};

--these are only to be used in conjunction with BuildSquad
function SquadFunctions:AddCharacter(character:tag):table
	dprint ("SQUADBUILDER: adding character");
	if character == nil or GetEngineString(character) == "invalid tag" then
		assert (false, "SQUADBUILDER: invalid character attempted to be added");
	else
		self.cells[self.numCells].character = character;
	end
	return self;
end


function SquadFunctions:AddPrimaryWeapon(weapon:tag, priority:number):table
	dprint ("SQUADBUILDER: adding primary weapon");
	if weapon == nil or GetEngineString(weapon) == "invalid tag" then
		assert (false, "SQUADBUILDER: invalid primary weapon attempted to be added");
	else
		priority = priority or 1;
		self.cells[self.numCells].primary = self.cells[self.numCells].primary or {};
		self.cells[self.numCells].primary[#self.cells[self.numCells].primary + 1] = {weapon, priority};
	end
	return self;
end

function SquadFunctions:AddSecondaryWeapon(weapon:tag):table
	dprint ("SQUADBUILDER: adding secondary weapon");
	if weapon == nil or GetEngineString(weapon) == "invalid tag" then
		assert (false, "SQUADBUILDER: invalid primary weapon attempted to be added");
	else
		self.cells[self.numCells].secondary = {weapon};
	end
	return self;
end

function SquadFunctions:AddUpgrade(upgrade:string):table
	dprint ("SQUADBUILDER:adding upgrade");
	
	if g_cellUpgrades[upgrade] == nil then
		print ("SQUADBUILDER: no valid upgrades");
		upgrade = g_cellUpgrades.normal;
	end	
	self.cells[self.numCells].upgrade = upgrade;
	return self;
end

function SquadFunctions:AddVehicle(vehicle:tag):table
	dprint ("SQUADBUILDER: adding vehicle");
	if vehicle == nil or GetEngineString(vehicle) == "invalid tag" then
		assert (false, "SQUADBUILDER: invalid vehicle attempted to be added");
	else
		self.cells[self.numCells].vehicle = vehicle;
	end
	return self;
end


--add a new cell to an existing squad.  A squad table can be used here which will make cells of the squad or a formatted cell table can be used
function SquadFunctions:AddCell(cellArray:table):table
	dprint ("SQUADBUILDER: adding new cell");
	cellArray = cellArray or {};
	--figure out if the cellTable is a cell table or a squad table that we need to get the cells
	--error check here
	
	self.numCells = self.numCells + 1;
	if cellArray.cells then --if it is a squad table
		for _, cell in ipairs (cellArray.cells) do
			self.cells[self.numCells] = cell;
		end
	else
		self.cells[self.numCells] = cellArray;
	end
	return self;
end

--commenting this out for now because delivery is on the pod level because it doesn't make sense to put it at the squad level
--adds new variable to the squad table called delivery with the appropriate delivery type
--function SquadFunctions:AddDeliveryType(deliveryType:string):table
--	dprint ("SQUADBUILDER:adding delivery type")
--	
--	if g_deliveryTypes[deliveryType] == nil then
--		print ("SQUADBUILDER: no valid delivery type");
--		deliveryType =  g_deliveryTypes[monsterCloset];
--	end	
--	self.delivery = deliveryType;
--	return self;
--end

--adds new variable to the squad table called objective with the appropriate objective
function SquadFunctions:AddObjective(objective:string):table
	dprint ("SQUADBUILDER:adding objective");
	
	self.objective = objective;
	return self;
end
