
function IsWarenaEnabled(engine)
	if isWarenaEnabled == nil then
		isWarenaEnabled = TryAndGetGameVariantBoolProperty(engine, ResolveString('WarenaEnabled'));
		if isWarenaEnabled == nil then
			isWarenaEnabled = false;
		end
	end
	return isWarenaEnabled;
end
__PersonalEnergyPickedUp = Delegate:new();
onPersonalEnergyPickedUp = root:AddCallback(
	__PersonalEnergyPickedUp,
	function (context, player)
		context.TargetPlayer = player;
	end
	);
personalEnergyPickupResponse = onPersonalEnergyPickedUp:Target(TargetPlayer):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_slayer_clutchkill'
	});
__TeamEnergyPickedUp = Delegate:new();
onTeamEnergyPickedUp = root:AddCallback(
	__TeamEnergyPickedUp,
	function (context, player, instant)
		context.TargetPlayer = player;
		context.InstantPickup = instant;
		context.Designator = player:GetTeamDesignator();
	end
	);
onTeamEnergyPickedUpInstant = onTeamEnergyPickedUp:Filter(
	function(context)
		return context.InstantPickup == true;
	end
	);
teamEnergyInstantPlayerResponse = onTeamEnergyPickedUpInstant:Target(TargetPlayer):Response(
	{
		Medal = 'flag_capture'
	});
teamEnergyInstantFriendlyResponse = onTeamEnergyPickedUpInstant:Target(FriendlyToTargetPlayer):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_ctf_flagcaptured'
	});
teamEnergyInstantHostileResponse = onTeamEnergyPickedUpInstant:Target(HostileToTargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_ctf_flagcapturedenemy'
	});
onTeamEnergyPickedUpChargeBegan = onTeamEnergyPickedUp:Filter(
	function(context)
		return context.InstantPickup == false;
	end
	);
teamEnergyChargeBeganTargetResponse = onTeamEnergyPickedUpChargeBegan:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_strongholds_basecaptureinitiated'
	});
teamEnergyChargeBeganFriendlyResponse = onTeamEnergyPickedUpChargeBegan:Target(FriendlyToTargetPlayer):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_slayer_clutchkill'
	});
teamEnergyChargeBeganHostileResponse = onTeamEnergyPickedUpChargeBegan:Target(HostileToTargetPlayer):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_slayer_clutchkill'
	});
__TeamEnergyChargeComplete = Delegate:new();
onTeamEnergyChargeComplete= root:AddCallback(
	__TeamEnergyChargeComplete,
	function (context, player, instant)
		context.TargetPlayer = player;
		context.InstantPickup = instant;
		context.Designator = player:GetTeamDesignator();
	end
	);
teamEnergyPickedPlayerResponse = onTeamEnergyChargeComplete:Target(TargetPlayer):Response(
	{
		Medal = 'flag_capture'
	});
teamEnergyPickedFriendlyResponse = onTeamEnergyChargeComplete:Target(PlayersWithDesignator):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_ctf_flagcaptured'
	});
teamEnergyPickedHostileResponse = onTeamEnergyChargeComplete:Target(HostileToTargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_ctf_flagcapturedenemy'
	});
teamEnergyChargeKillSelect = onEnemyPlayerKill:Select();
onChargingPlayerKilled = teamEnergyChargeKillSelect:Add(
	function(context)
		return IsWarenaEnabled(context.Engine) and context.DeadPlayer:IsChargingTeamEnergy();
	end
	);
chargingPlayerKilledKillingPlayerResponse = onChargingPlayerKilled:Target(KillingPlayer):Response(
	{
		Medal = 'flag_carrier_kill',
		Sound = 'multiplayer\audio\announcer\announcer_ctf_flagcarrierkill'
	});
