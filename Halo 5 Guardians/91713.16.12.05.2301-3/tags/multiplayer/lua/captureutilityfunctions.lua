
function CapturingPlayer(context)
	return context.CapturingPlayer;
end
function CapturingPlayers(context)
	return context.CapturingPlayers;
end
function AssistingPlayers(context)
	return context.AssistingPlayers;
end
function NonCapturingPlayers(context)
	return table.filter(context:GetAllPlayers(),
		function (player)
			return player ~= context.CapturingPlayer;
		end
		);
end
function TenCapturePlayers(context)
	return context.TenCapturePlayers;
end
function InteractingPlayer(context)
	return context.InteractingPlayer;
end
function NonInteractingPlayers(context)
	return table.filter(context:GetAllPlayers(),
		function(player)
			return player ~= context.InteractingPlayer;
		end
		);
end
function FriendlyToInteractingPlayer(context)
	return table.filter(context:GetAllPlayers(),
		function (player)
			return player ~= context.InteractingPlayer
				and player:IsFriendly(context.InteractingPlayer);
		end
		);
end
function PlayersFriendlyToInteractingTeam(context)
	return table.filter(context:GetAllPlayers(),
		function(player)
			return player:IsFriendly(context.InteractingPlayer);
		end
		);
end
function HostileToInteractingPlayer(context)
	return table.filter(context:GetAllPlayers(),
		function (player)
			return player:IsHostile(context.InteractingPlayer);
		end
		);
end
function FriendlyToCapturingPlayers(context)
	return table.filter(context:GetAllPlayers(),
		function (player)
			return table.all(context.CapturingPlayers,
				function(capturingPlayer)
					return player ~= capturingPlayer
						and player:IsFriendly(capturingPlayer);
				end
				);
		end
		);
end
function PlayersFriendlyToCapturingTeam(context)
	return table.filter(context:GetAllPlayers(),
		function(player)
			return table.any(context.CapturingPlayers,
				function(capturingPlayer)
					return player:IsFriendly(capturingPlayer);
				end
				);
		end
		);
end
function PlayersHostileToCapturingPlayers(context)
	return table.filter(context:GetAllPlayers(),
		function (player)
			return table.any(context.CapturingPlayers,
				function(capturingPlayer)
					return player:IsHostile(capturingPlayer);
				end
				);
		end
		);
end
function DominatingPlayers(context)
	return context.DominatingPlayers;
end
function PlayersHostileToDominatingPlayers(context)
	return table.filter(context:GetAllPlayers(),
		function(player)
			return table.any(context.DominatingPlayers,
				function(dominatingPlayer)
					return player ~= nil and player:IsHostile(dominatingPlayer);
				end
				);
		end
		);
end
function ScoringPlayers(context)
	return context.ScoringPlayers;
end
function PlayersHostileToScoringPlayers(context)
	return table.filter(context:GetAllPlayers(),
		function(player)
			return table.any(context.ScoringPlayers,
				function(scoringPlayer)
					return player ~= nil and player:IsHostile(scoringPlayer);
				end
				);
		end
		);
end
function ScoringTeamDesignator(context)
	return context.ScoringTeamDesignator;
end
function CaptureZoneName(context)
	return context.Zone;
end