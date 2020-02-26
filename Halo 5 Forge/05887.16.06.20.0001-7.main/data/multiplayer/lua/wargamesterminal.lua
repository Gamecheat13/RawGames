--
-- WarGamesTerminal the flag Helper functions
--
function TargetPlayer(context)
	return context.TargetPlayer
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

function AllPlayers(context)
	return context:GetAllPlayers();
end


__OnTerminalRocketsIn30Secs = Delegate:new();

onTerminalRocketsIn30Secs = root:AddCallback(
	__OnTerminalRocketsIn30Secs
	);

onTerminalRocketsIn30Secs:Target(AllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_terminal30swarning_rocketlauncher'	
	});

terminalRocketsIn30SecsChatter = onTerminalRocketsIn30Secs:GlobalEvent();

terminalRocketsIn30SecsChatterSelect = terminalRocketsIn30SecsChatter:Select();

terminalRocketsIn30SecsChatterWinning = terminalRocketsIn30SecsChatterSelect:Add(LocalPlayersWinning);

terminalRocketsIn30SecsChatterWinning:Say(
                NearbyFriendlyToLocalPlayer(100),
                'multiplayer\audio\spartanchatter\spartanchatter_slayer_teammate30secclutchordnancewinning'
                );

terminalRocketsIn30SecsChatterLosing = terminalRocketsIn30SecsChatterSelect:Add(LocalPlayersLosing);

terminalRocketsIn30SecsChatterLosing:Say(
                NearbyFriendlyToLocalPlayer(100),
                'multiplayer\audio\spartanchatter\spartanchatter_slayer_teammate30secclutchordnancelosing'
                );

terminalRocketsIn30SecsChatterNeutral = terminalRocketsIn30SecsChatterSelect:Add();
	
__OnTerminalSniperIn30Secs = Delegate:new();

onTerminalSniperIn30Secs = root:AddCallback(
	__OnTerminalSniperIn30Secs
	);

onTerminalSniperIn30Secs:Target(AllPlayers):Response(
	{
		Sound = 'multiplayer\audio\teammate_chatter\teammate_chatter_shared_terminalincoming_sniperrifle'
	});

__OnTerminalSwordIn30Secs = Delegate:new();

onTerminalSwordIn30Secs = root:AddCallback(
	__OnTerminalSwordIn30Secs
	);

onTerminalSwordIn30Secs:Target(AllPlayers):Response(
	{
		Sound = 'multiplayer\audio\teammate_chatter\teammate_chatter_shared_terminalincoming_energysword'	
	});



__OnTerminalRocketsIn10Secs = Delegate:new();

onTerminalRocketsIn10Secs = root:AddCallback(
	__OnTerminalRocketsIn10Secs
	);

onTerminalRocketsIn10Secs:Target(AllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_terminal10swarning_rocketlauncher'
	});

__OnTerminalSniperIn10Secs = Delegate:new();

onTerminalSniperIn10Secs = root:AddCallback(
	__OnTerminalSniperIn10Secs
	);

onTerminalSniperIn10Secs:Target(AllPlayers):Response(
	{
		Sound = 'multiplayer\audio\teammate_chatter\teammate_chatter_shared_terminal10sec_sniperrifle'
	});

__OnTerminalSwordIn10Secs = Delegate:new();

onTerminalSwordIn10Secs = root:AddCallback(
	__OnTerminalSwordIn10Secs
	);

onTerminalSwordIn10Secs:Target(AllPlayers):Response(
	{
		Sound = 'multiplayer\audio\teammate_chatter\teammate_chatter_shared_terminal10sec_energysword'		
	});



__OnTerminalPickupRockets = Delegate:new();

onTerminalPickupRockets = root:AddCallback(
	__OnTerminalPickupRockets,
	function (context, interactingPlayer)
		context.TargetPlayer = interactingPlayer;
	end
	);

terminalEnemyPickupRocketsChatter = onTerminalPickupRockets:ObjectEvent(
	function (context)
		return context.TargetPlayer;
	end);

terminalEnemyPickupRocketsChatter:Filter(EventSourceIsHostileToAllLocal):Say(
	NearbyFriendlyToLocalPlayer(20),
	'multiplayer\audio\spartanchatter\spartanchatter_slayer_enemygameender'
	);

terminalFriendlyPickupRocketsChatter = onTerminalPickupRockets:ObjectEvent(
	function (context)
		return context.TargetPlayer;
	end);
	
terminalFriendlyPickupRocketsChatter:Filter(EventSourceIsFriendlyToAllLocal):Say(
	NearbyFriendlyToLocalPlayer(20),
	'multiplayer\audio\spartanchatter\spartanchatter_slayer_teammategameender'
	);	
	
__OnTerminalPickupSniper = Delegate:new();

onTerminalPickupSniper = root:AddCallback(
	__OnTerminalPickupSniper,
	function (context, interactingPlayer)
		context.TargetPlayer = interactingPlayer;
	end
	);

onTerminalPickupSniper:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\teammate_chatter\teammate_chatter_shared_terminaltaken_sniperrifle',
		
	});

onTerminalPickupSniper:Target(FriendlyToTargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\teammate_chatter\teammate_chatter_shared_terminaltaken_sniperrifle',
		

	});

__OnTerminalPickupSword = Delegate:new();

onTerminalPickupSword = root:AddCallback(
	__OnTerminalPickupSword,
	function (context, interactingPlayer)
		context.TargetPlayer = interactingPlayer;
	end
	);

onTerminalPickupSword:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\teammate_chatter\teammate_chatter_shared_terminaltaken_energysword',
				
	});

onTerminalPickupSword:Target(FriendlyToTargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\teammate_chatter\teammate_chatter_shared_terminaltaken_energysword'
	});



__TerminalRocketsReady = Delegate:new();

terminalRocketsReady = root:AddCallback(
	__TerminalRocketsReady
	);

terminalRocketsReady:Target(AllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_terminalready_rocketlauncher'
		
	});

terminalRocketsReadyChatter = terminalRocketsReady:GlobalEvent();

terminalRocketsReadyChatterSelect = terminalRocketsReadyChatter:Select();

terminalRocketsReadyChatterWinning = terminalRocketsReadyChatterSelect:Add();

terminalRocketsReadyChatterWinning:Say(
                NearbyFriendlyToLocalPlayer(100),
                'multiplayer\audio\spartanchatter\spartanchatter_slayer_generalordnancespawned'
                );

__TerminalSniperReady = Delegate:new();

terminalSniperReady = root:AddCallback(
	__TerminalSniperReady
	);

terminalSniperReady:Target(AllPlayers):Response(
	{
		Sound = 'multiplayer\audio\teammate_chatter\teammate_chatter_shared_terminalready_sniperrifle'
		
	});

__TerminalSwordReady = Delegate:new();

terminalSwordReady = root:AddCallback(
	__TerminalSwordReady
	);

terminalSwordReady:Target(AllPlayers):Response(
	{
		Sound = 'multiplayer\audio\teammate_chatter\teammate_chatter_shared_terminalready_energysword'
				
	});
	
	-- Final Ordnance
	
__OnFinalOrdnanceIn30Secs = Delegate:new();

onFinalOrdnanceIn30Secs = root:AddCallback(
	__OnFinalOrdnanceIn30Secs
	);

finalOrdnanceIn30Response = onFinalOrdnanceIn30Secs:Target(AllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_slayer_finalordnance30swarning'	
	});
	
__OnFinalOrdnanceIn10Secs = Delegate:new();

onFinalOrdnanceIn10Secs = root:AddCallback(
	__OnFinalOrdnanceIn10Secs
	);

finalOrdnanceIn10Response = onFinalOrdnanceIn10Secs:Target(AllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_slayer_finalordnance10swarning'	
	});
	
__OnFinalOrdnanceReady = Delegate:new();

onFinalOrdnanceReady = root:AddCallback(
	__OnFinalOrdnanceReady
	);

finalOrdnanceReadyResponse = onFinalOrdnanceReady:Target(AllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_terminalreadyordnance'	
	});
	
	
	
	
	
	
	
	
