
function GetScoreVal(score)
	if (enableCampaignScoringInMP) then
		if (globalPvEScoreModifier ~= nil) then
			return score * globalPvEScoreModifier;
		else
			return score;
		end
	else
		return 0;
	end
end
TeamNames = 
{
	"red",
	"blue",
	"yellow",
	"green"
}
function GenerateTeamSpecificNeutralResponses(sourceSelect, responseFunctionTemplate)
	for designatorKey , designatorName in pairs(TeamNames) do
		addEvent = sourceSelect:Add(
			function(context)
				if (context.EventDesignator ~= nil) then
					return context.EventDesignator == designatorKey - 1;
				elseif (context.TargetPlayer ~= nil) then
					return context.TargetPlayer:GetTeamDesignator() == designatorKey - 1;
				elseif (context.MatchingPlayers ~= nil) then
					local firstPlayer = table.first(context.MatchingPlayers, 
						function(player)
							return player ~= nil;
						end
						);
					if (firstPlayer == nil) then
						return false;
					end
					return firstPlayer:GetTeamDesignator() == designatorKey - 1;
				end
			end
			);
		responseFunctionTemplate(designatorName, addEvent);
	end
end
function TargetPlayer(context)
	return context.TargetPlayer;
end
function TargetAllPlayers(context)
	return context:GetAllPlayers();
end
function MatchingPlayers(context)	
	return context.MatchingPlayers;
end
function AllButTargetPlayer(context)
	return table.filter(context:GetAllPlayers(),
		function (player)
			return player ~= context.TargetPlayer;
		end
		);
end
function DesignatorProperty(context)
	return context.Designator;
end
function PlayersWithDesignator(context)
	return table.filter(context:GetAllPlayers(),
		function(player)
			return context.Designator == player:GetTeamDesignator();
		end
		);
end
function PlayersWithoutDesignator(context)
	return table.filter(context:GetAllPlayers(),
		function(player)
			return context.Designator ~= player:GetTeamDesignator();
		end
		);
end
function FriendlyToMatchingPlayers(context)
	return table.filter(context:GetAllPlayers(),
		function(player)
			return table.any(context.MatchingPlayers,
				function(matchingPlayer)
					return player ~= matchingPlayer 
					and player:IsFriendly(matchingPlayer);
				end
				);
		end
		);
end
function HostileToMatchingPlayers(context)
	return table.filter(context:GetAllPlayers(),
		function(player)
			return table.any(context.MatchingPlayers,
				function(matchingPlayer)
					return player:IsHostile(matchingPlayer);
				end
				);
		end
		);
end
function HostileToTargetPlayer(context)
	return table.filter(context:GetAllPlayers(),
		function (player)
			return player:IsHostile(context.TargetPlayer);
		end
		);
end
function FriendlyToTargetPlayer(context)
	return table.filter(context:GetAllPlayers(), 
		function (player)
			return player:IsFriendly(context.TargetPlayer) and player ~= context.TargetPlayer;
		end
		);
end
function HostileToKillingPlayer(context)
	return table.filter(context:GetAllPlayers(),
		function (player)
			return player:IsHostile(context.KillingPlayer);
		end
		);
end
function FriendlyToKillingPlayer(context)
	return table.filter(context:GetAllPlayers(), 
		function (player)
			return player:IsFriendly(context.KillingPlayer) and player ~= context.KillingPlayer;
		end
		);
end
function FriendlyToKillingPlayerAndNotAssisting(context)
	return table.filter(context:GetAllPlayers(), 
		function (player)
			return player:IsFriendly(context.KillingPlayer) and 
				   player ~= context.KillingPlayer and 
				   not table.contains(context.AssistingPlayers, player);
		end
		);
end
function FriendlyToKillingPlayerAssist(context)
	return table.filter(context:GetAllPlayers(), 
		function (player)
			return player:IsFriendly(context.KillingPlayer) and 
				   player ~= context.KillingPlayer and 
				   table.contains(context.AssistingPlayers, player);
		end
		);
end
function FriendlyToKillingPlayerNotInvolved(context)
	return table.filter(context:GetAllPlayers(), 
		function (player)
			return player:IsFriendly(context.KillingPlayer) and player ~= context.KillingPlayer and player ~= context.DeadPlayer;
		end
		);
end
function FriendlyToDeadPlayer(context)
	return table.filter(context:GetAllPlayers(), 
		function (player)
			return player:IsFriendly(context.DeadPlayer) and player ~= context.DeadPlayer;
		end
		);
end
function HostileToKillingAndDeadPlayers(context)
	return table.filter(context:GetAllPlayers(),
		function(player)
			return player:IsHostile(context.KillingPlayer) 
			and player:IsHostile(context.DeadPlayer) 
			and player ~= context.KillingPlayer 
			and player ~= context.DeadPlayer;
		end
		);
end
function PlayerIsAlive(player)
	local playerUnit = player:GetUnit();
	return playerUnit ~= nil and playerUnit:IsAlive();
end
function PlayerIsDead(player)
	local playerUnit = player:GetUnit();
	return playerUnit == nil or playerUnit:IsDead();
end
function FriendlyToTargetAlive(context)
	return table.filter(context:GetAllPlayers(),
		function (player)
			return player:IsFriendly(context.TargetPlayer) and PlayerIsAlive(player);
		end
		);
end
function FriendlyToTargetDead(context)
	return table.filter(context:GetAllPlayers(),
		function (player)
			return player:IsFriendly(context.TargetPlayer) and PlayerIsDead(player);
		end
		);
end
function HostileToTargetAlive(context)
	return table.filter(context:GetAllPlayers(),
		function (player)
			return player:IsHostile(context.TargetPlayer) and PlayerIsAlive(player);
		end
		);
end
function HostileToTargetDead(context)
	return table.filter(context:GetAllPlayers(),
		function (player)
			return player:IsHostile(context.TargetPlayer) and PlayerIsDead(player);
		end
		);
end
function AllAlivePlayers(context)
	return table.filter(context:GetAllPlayers(),
		function (player)
			return PlayerIsAlive(player);
		end
		);
end
function GetPlayerCount(players)
	local indexedPlayerList = table.filtervalues(players,
		function(player)
			return player;
		end
		);
	return #indexedPlayerList;
end
function AllDeadPlayers(context)
	return table.filter(context:GetAllPlayers(),
		function (player)
			return PlayerIsDead(player);
		end
		);
end
function PlayerHasFullBodyAndShieldMaxVitality(player)
	if player == nil then
		return false;
	end
	local playerUnit = player:GetUnit();
	if playerUnit == nil
		or playerUnit:GetMaximumBodyVitality() < 1
		or playerUnit:GetMaximumShieldVitality() < 1 then
		return false;
	end
	return true;
end
function FindWinningPlayers(context)
	local highestScore = 0;
	local winningPlayers = { };
	for _ , player in pairs(context:GetAllPlayers()) do
		if player ~= nil then
			local playerScore = player:GetTeamScore();
			if playerScore > highestScore then
				highestScore = playerScore;
				winningPlayers = { player };
			elseif playerScore == highestScore then
				table.insert(winningPlayers, player);
			end
		end
	end
	local allWinningPlayersOnSameTeam = table.all(winningPlayers, 
		function(winningPlayer)
			return table.first(winningPlayers):IsFriendly(winningPlayer);
		end
		);
	if allWinningPlayersOnSameTeam then
		return winningPlayers;
	else
		return nil;
	end
end
function FindVariant(context)
	local variant = nil;
	context.Engine:VisitVariant(
		function (currentVariant)
			variant = currentVariant
		end
		);
	return variant;
end
function WinningPlayers(context)
	return context.WinningPlayers;
end
function LosingPlayers(context)
	return table.filter(context:GetAllPlayers(),
		function (player)
			return table.any(context.WinningPlayers,
				function (otherPlayer)
					return player:IsHostile(otherPlayer);
				end
				);
		end
		);
end
function ExclusiveWinnerFilter(player)
	return player:IsWinning() and not player:IsTied();
end
function GameTiedFilter(player)
	return player:IsTied() and player:IsWinning();
end
function LosersFilter(player)
	return not player:IsWinning();
end
function LocalPlayersWinning(context)
	return table.all(context:GetAllLocalPlayers(), ExclusiveWinnerFilter);
end
function LocalPlayers(context)
	return context:GetAllLocalPlayers();
end
function LocalPlayersLosing(context)
	return table.all(context:GetAllLocalPlayers(), NotFilter(ExclusiveWinnerFilter));
end
function WinnersTarget(context)
	return table.filter(context:GetAllPlayers(), ExclusiveWinnerFilter);
end
function NotWinnersTarget(context)
	return table.filter(context:GetAllPlayers(), NotFilter(ExclusiveWinnerFilter));
end
function LosersTarget(context)
	return table.filter(context:GetAllPlayers(), LosersFilter);
end
function TiedTarget(context)
	return table.filter(context:GetAllPlayers(), GameTiedFilter);
end
function SmallGap(context)
	return context.Engine:SmallGap();
end
function MediumGap(context)
	return context.Engine:MediumGap();
end
function LargeGap(context)
	return context.Engine:LargeGap();
end
function OneScoreToWin(context)
	return context.ScoreLeftToWin == 1;
end
function ScoreNearingVictory(context)
	if context.Engine:GetScoreToWinRound() < 30 then
		return context.ScoreLeftToWin == 5;
	else
		return context.ScoreLeftToWin == 10;
	end
end
function ScoreHalfwayToVictory(context)
	if (context.TotalScoreToWin % 2 == 0) then
		return context.ScoreLeftToWin == context.TotalScoreToWin / 2;
	else
		return context.ScoreLeftToWin == (context.TotalScoreToWin - 1) / 2;
	end
end
function ScoreAtLeastHalfwayToVictory(context)
	if (context.TotalScoreToWin % 2 == 0) then
		return context.ScoreLeftToWin <= context.TotalScoreToWin / 2;
	else
		return context.ScoreLeftToWin <= (context.TotalScoreToWin - 1) / 2;
	end
end
function AllPlayersFriendlyToScoringPlayer(context)
	local ret = table.filter(context:GetAllPlayers(),
		function (player)
			return player:IsFriendly(context.ScoringPlayer);
		end
		);
	return ret;
end
function AllPlayersHostileToScoringPlayer(context)
	local ret = table.filter(context:GetAllPlayers(),
		function (player)
			return player:IsHostile(context.ScoringPlayer);
		end
		);
	return ret;
end
function GameIsTied(context)
	return context.Engine:GameIsTied();
end
function TryAndGetGameVariantBoolProperty(engine, propertyName)
	if (engine:DoesGameVariantBoolPropertyExist(propertyName)) then
		return engine:GetGameVariantBoolProperty(propertyName);
	else
		return nil;
	end
end
