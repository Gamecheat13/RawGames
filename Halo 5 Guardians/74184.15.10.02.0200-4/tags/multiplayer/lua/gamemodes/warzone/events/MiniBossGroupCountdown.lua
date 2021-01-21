-- Copyright (c) Microsoft. All rights reserved.

--MiniBoss Group Countdown

__OnMiniBossGroupCountdown = Delegate:new();

OnMiniBossGroupCountdown = root:AddCallback(
	__OnMiniBossGroupCountdown,
	function(context, squadId, secondsRemaining, proximityPlayers)
		context.SquadId = squadId;
		context.SecondsRemaining = secondsRemaining;
		context.ProximityPlayers = proximityPlayers;
	end
	);

function CountdownResponsePredicate(squadId, secondsRemaining)
	return function(context)
		return context.SquadId == ResolveString(squadId) and (secondsRemaining == nil or secondsRemaining == "default" or context.SecondsRemaining == secondsRemaining);
	end;
end
