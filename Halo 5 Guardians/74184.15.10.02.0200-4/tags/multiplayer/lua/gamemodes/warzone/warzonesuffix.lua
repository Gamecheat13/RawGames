--
-- Boss Response Helper Functions
--

function IsResponse(response)

	for _, value in pairs(response) do
		if type(value) == "table" then
			return false;
		end
	end

	return true;

end

function ResponseChain(responseRoot, previousResponse, callback)

	if (IsResponse(responseRoot)) then

		return callback(responseRoot, previousResponse);

	else

		for _, value in ipairs(responseRoot) do
			previousResponse = ResponseChain(value, previousResponse, callback);
		end

	end

end

function InsertResponseChain(definitionName, responseName, firstResponse, responseDefinition)

	local responsesTable = {};

	local responseRoot = responseDefinition.responses[responseName];

	ResponseChain(

		responseRoot,

		firstResponse,

		function(response, previousResponse)

			local newResponse = previousResponse:Response(response);
			
			table.insert(responsesTable, newResponse);

			return newResponse;

		end);

	local defaultExtraResponse = minibossDefaultExtraDefinitions[responseName];

	if defaultExtraResponse ~= nil then

		if next(responsesTable) == nil then

			table.insert(responsesTable, responseRoot:Response(defaultExtraResponse));

		else

			table.insert(responsesTable, responsesTable[#responsesTable]:Response(defaultExtraResponse));

		end

	end

	for responseIndex, response in ipairs(responsesTable) do

		if responseIndex == 1 then
			_G[definitionName .. "_" .. responseName] = response;
		else
			_G[definitionName .. "_" .. responseName .. "_" .. tostring(responseIndex)] = response;
		end

	end

end

function ResponseInserter(definition, isNeutralMiniBoss)

	local definitionName = definition.name;

	return function(responseName, firstResponse)

			InsertResponseChain(definitionName, responseName, firstResponse, definition);

	end

end

function ProximityPlayers(context)
	return context.ProximityPlayers;
end

function ProximityPlayersWithDesignator(context)
	return table.filter(context.ProximityPlayers,
		function (player)
			return context.Designator == player:GetTeamDesignator();
		end
		);
end

function ProximityPlayersWithoutDesignator(context)
	return table.filter(context.ProximityPlayers,
		function (player)
			return context.Designator ~= player:GetTeamDesignator();
		end
		);
end

-- Friendly Target Groups
function FriendlyPlayers(context)
	return context.FriendlyPlayers;
end

function FriendlyProximityPlayers(context)
	return table.filter(context.ProximityPlayers, 
		function (player)
			return player:IsFriendly(context.TargetPlayer);
		end
		);
end

function FriendlyProximityPlayersNotTarget(context)
	return table.filter(context.ProximityPlayers, 
		function (player)
			return player:IsFriendly(context.TargetPlayer) and player ~= context.TargetPlayer;
		end
		);
end

function FriendlyProximityPlayersNotAssistingOrTarget(context)
	return table.filter(context.ProximityPlayers, 
		function (player)
			return player:IsFriendly(context.TargetPlayer) and
				   player ~= context.TargetPlayer and
				   (not table.contains(context.AssistingPlayers, player));
		end
		);
end

-- Hostile Target Groups
function PlayersHostileToTargetPlayer(context)
	return table.filter(context:GetAllPlayers(),
		function (player)
			return player:IsHostile(context.TargetPlayer);
		end
		);
end

function ProximityPlayersHostileToTargetPlayer(context)
	return table.filter(context.ProximityPlayers,
		function (player)
			return player:IsHostile(context.TargetPlayer);
		end
		);
end


function InsertResponseChainsForDefinition(definition, isNeutralMiniBoss)

	local inserter = ResponseInserter(definition, isNeutralMiniBoss);


	-- Appeared

	local onAppeared = onMiniBossGroupAppearedSelect:Add(WithSquadId(definition.label));

	inserter("appearedResponse", onAppeared:Target(ProximityPlayers));

	-- Spawn Event

	-- When only one team is within victory when the boss spawns, we need to fire
	-- both a positive (friendly) and a negative (enemy) response

	local onAppearedVictoryAttainableOneTeam = onMiniBossAppearedVictoryAttainableOneTeamSelect:Add(WithSquadId(definition.label));

	inserter("appearedVictoryAttainableOneTeamFriendlyResponse", onAppearedVictoryAttainableOneTeam:Target(ProximityPlayersWithDesignator));

	inserter("appearedVictoryAttainableOneTeamEnemyResponse", onAppearedVictoryAttainableOneTeam:Target(ProximityPlayersWithoutDesignator));

	-- When both teams are within victory, we'll just fire one positive response to everybody

	local onAppearedVictoryAttainableBothTeams = onMiniBossAppearedVictoryAttainableBothTeamsSelect:Add(WithSquadId(definition.label));

	inserter("appearedVictoryAttainableBothTeamsResponse", onAppearedVictoryAttainableBothTeams:Target(ProximityPlayers));

	-- Explored
	
	local onExplored = onMiniBossGroupExploredSelect:Add(WithSquadId(definition.label));

	inserter("exploredPlayerResponse", onExplored:Target(TargetPlayer));

	-- Discovered

	local onDiscovered = onMiniBossGroupDiscoveredSelect:Add(WithSquadId(definition.label));

	inserter("discoveredPlayerResponse", onDiscovered:Target(TargetPlayer));

	inserter("discoveredFriendlyProximityResponse", onDiscovered:Target(FriendlyProximityPlayersNotTarget));

	inserter("discoveredEnemyProximityResponse", onDiscovered:Target(ProximityPlayersHostileToTargetPlayer));

	-- Score Gap Within Victory Boss Alive

	-- When the winning team becomes in range of victory with a miniboss kill,
	-- we want to fire an event to both teams, hence the friendly/enemy perspectives below

	local aliveWithinScoreRangeWinningTeam = onMiniBossAliveWithinScoreRangeWinningTeamSelect:Add(WithSquadId(definition.label));

	inserter("aliveWithinScoreRangeWinningTeamFriendlyResponse", aliveWithinScoreRangeWinningTeam:Target(PlayersWithDesignator));

	inserter("aliveWithinScoreRangeWinningTeamEnemyResponse", aliveWithinScoreRangeWinningTeam:Target(PlayersWithoutDesignator));

	-- When the losing team becomes in range of victory with a miniboss kill,
	-- we only need to fire an event to the friendly (losing) team

	local aliveWithinScoreRangeLosingTeam = onMiniBossAliveWithinScoreRangeLosingTeamSelect:Add(WithSquadId(definition.label));

	inserter("aliveWithinScoreRangeLosingTeamFriendlyResponse", aliveWithinScoreRangeLosingTeam:Target(PlayersWithDesignator));

	-- Complete

	local onKilledSelect = onMiniBossKilledSelect:Add(WithSquadId(definition.label)):Select();	

	local onLastKill = onKilledSelect:Add(LastKill);

	local onProgressKill = onKilledSelect:Add();

	inserter("progressPlayerResponse", onProgressKill:Target(TargetPlayer));

	inserter("progressAssistResponse", onProgressKill:Target(AssistingPlayers));

	inserter("progressFriendlyResponse", onProgressKill:Target(FriendlyPlayers));

	inserter("progressFriendlyProximityResponse", onProgressKill:Target(FriendlyProximityPlayersNotAssistingOrTarget));

	inserter("progressEnemyResponse", onProgressKill:Target(PlayersHostileToTargetPlayer));

	inserter("progressEnemyProximityResponse", onProgressKill:Target(ProximityPlayersHostileToTargetPlayer));

	inserter("completePlayerResponse", onLastKill:Target(TargetPlayer));

	inserter("completeAssistResponse", onLastKill:Target(AssistingPlayers));

	inserter("completeFriendlyResponse", onLastKill:Target(FriendlyPlayers));

	inserter("completeFriendlyProximityResponse", onLastKill:Target(FriendlyProximityPlayersNotAssistingOrTarget));

	inserter("completeEnemyResponse", onLastKill:Target(PlayersHostileToTargetPlayer));

	inserter("completeEnemyProximityResponse", onLastKill:Target(ProximityPlayersHostileToTargetPlayer));

	-- Killed Teammates

	local onKilledTeammates = onMiniBossKilledTeammateSelect:Add(PlayersKilledByMiniBossFilter(definition.label, definition.killedTeammatesCount));

	inserter("killedTeammatesResponse", onKilledTeammates:Target(FriendlyProximityPlayersNotTarget));

end

if minibossDefinitions ~= nil then
	for _, definition in ipairs(minibossDefinitions) do

		InsertResponseChainsForDefinition(definition, false);

	end
end

__OnObjectiveBaseDefendBegin = Delegate:new();

onObjectiveBaseDefendBegin = root:AddCallback(
	__OnObjectiveBaseDefendBegin,
	function (context, baseName, userFacingName, controllingTeamDesignator)
		context.BaseName = baseName;
		context.UserFacingName = userFacingName;
		context.Designator = controllingTeamDesignator;
	end);

onObjectiveBaseDefendBeginSelect = onObjectiveBaseDefendBegin:Select();

__OnObjectiveBaseDefendSuccess = Delegate:new();

onObjectiveBaseDefendSuccess = root:AddCallback(
	__OnObjectiveBaseDefendSuccess,
	function (context, baseName, userFacingName, controllingTeamDesignator)
		context.BaseName = baseName;
		context.UserFacingName = userFacingName;
		context.Designator = controllingTeamDesignator;
	end);
	
onObjectiveBaseDefendSuccessSelect = onObjectiveBaseDefendSuccess:Select();

for _, definition in ipairs(defendResponses) do

	local definitionName = definition.name;

	local defendBegin = onObjectiveBaseDefendBeginSelect:Add(BaseIsNamed(definition.name));

	InsertResponseChain(definitionName, "beginResponse", defendBegin:Target(PlayersWithDesignator), definition);

	local defendSuccess = onObjectiveBaseDefendSuccessSelect:Add(BaseIsNamed(definition.name));

	InsertResponseChain(definitionName, "successResponse", defendSuccess:Target(PlayersWithDesignator), definition);

end