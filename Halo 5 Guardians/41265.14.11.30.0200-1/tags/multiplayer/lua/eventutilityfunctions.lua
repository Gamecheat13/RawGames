--
-- Event utility functions
--

function TargetPlayer(context)

	return context.TargetPlayer;

end

function TargetAllPlayers(context)

	return context:GetAllPlayers();

end

function MatchingPlayers(context)	
	return context.MatchingPlayers;
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
	return player:IsTied();
end

function LosersFilter(player)
	return not player:IsWinning() and not player:IsTied();
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
