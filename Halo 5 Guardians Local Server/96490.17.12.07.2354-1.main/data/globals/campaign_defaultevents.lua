--
-- Default Campaign Event Definitions, used for all campaign
--

--
-- Default event definitions
--

root = RootDefinition:new();

DefinitionRuntime:RegisterRoot(root);

--
-- Player activated
--

function ActivatedPlayer(context)
	return context.ActivatedPlayer
end

onPlayerActivated = root:AddCallback(
	__OnPlayerActivated,
	function (context, activatedPlayer)
		context.ActivatedPlayer = activatedPlayer;
	end
	);


--
-- Player Revive
--

onUnitRevivedUnit = root:AddCallback(
	__OnUnitRevivedUnit,
	function (context, reviverPlayer, reviverUnit, targetPlayer, targetUnit)
		context.ReviverPlayer = reviverPlayer;
		context.ReviverUnit = reviverUnit;
		context.TargetPlayer = targetPlayer;
		context.TargetUnit = targetUnit;
	end
	);


onPlayerWasRevived= onUnitRevivedUnit:Filter(
 function (context)
  return (context.ReviverUnit ~= nil) and (context.TargetPlayer ~= nil);
 end
 );

 onPlayerRevivedSomone = onUnitRevivedUnit:Filter(
 function (context)
   return (context.TargetUnit ~= nil) and (context.ReviverPlayer ~= nil);
 end
 );

 function ReviverPlayer(context)
	return context.ReviverPlayer;
end

onPlayerWasRevivedResponse = onPlayerWasRevived:Target(TargetPlayer):Response(
	{
		ImpulseEvent = 'was_revived',
	});

onPlayerRevivedSomoneResponse = onPlayerRevivedSomone:Target(ReviverPlayer):Response(
	{
		Medal = 'revived_someone',
	});

--
-- Player added
--

onPlayerAdded = root:AddCallback(
	__OnPlayerAdded,
	function (context, activatedPlayer, joinInProgress)
		context.TargetPlayer = activatedPlayer;
		context.JoinInProgress = joinInProgress;
	end
	);

onPlayerAddedGeneralResponse = onPlayerAdded:Target(TargetAllPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'player_joined'
	});

--
-- Player Left
--

onPlayerLeft = root:AddCallback(
	__OnPlayerLeft,
	function(context, player)
		context.TargetPlayer = player;
	end
	);

onPlayerLeftResponse = onPlayerLeft:Target(TargetAllPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'player_left'
	});