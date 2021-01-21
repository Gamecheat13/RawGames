
if (isCTFGameMode) then
	modeIntroResponse = onModeIntro:Target(TargetAllPlayers):Response(
		{
			Sound = 'multiplayer\audio\announcer\announcer_ctf_ctfstart'
		});
end
__OnFlagPickup = Delegate:new();
onFlagPickup = root:AddCallback(
	__OnFlagPickup,
	function (context, carryingPlayer, pickedUpFromFlagStand, flagDesignator)
		context.TargetPlayer = carryingPlayer;
		context.PickedUpFromFlagStand = pickedUpFromFlagStand;
		context.EventDesignator = flagDesignator;
		context.Designator = flagDesignator;
	end
	);
flagPickupCarrierMusicResponse = onFlagPickup:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_ctf\music_mp_ctf_flagcarrier_loop',
		ImpulseEvent = 'impulse_flag_pickup'
	});
local juggleTimer = 4.0;
pickupSpamPreventionAccumulator = root:CreatePlayerAccumulator(juggleTimer);
pickupsInARow = onFlagPickup:PlayerAccumulator(
	pickupSpamPreventionAccumulator,
	function(context)
		return context.TargetPlayer;
	end
	);
onPlayerDeath:ResetPlayerAccumulator(
	pickupSpamPreventionAccumulator,
	function(context)
		return context.DeadPlayer;
	end
	);
onNonJuggleFlagPickup = pickupsInARow:Filter(
	function(context)
		return pickupSpamPreventionAccumulator:GetValue(context.TargetPlayer) <= 1;
	end
	);
flagPickupCarrierResponse = onNonJuggleFlagPickup:Target(TargetPlayer):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_ctf_carrierflagpickedup'
	});
flagPickupHostileResponseSelect = onNonJuggleFlagPickup:Select();
neutralFlagPickupHostileResponse = flagPickupHostileResponseSelect:Add(
	function(context)
		return context.Engine:IsGameNeutralFlag();
	end
	):Target(HostileToTargetPlayer):Response(
	{	
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_ctf_hostileflagpickedupneutralflag'
	});
flagPickupHostileResponse = flagPickupHostileResponseSelect:Add():Target(PlayersWithDesignator):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_ctf_hostileflagpickedup'
	});
flagPickupFriendlyResponse = onNonJuggleFlagPickup:Target(FriendlyToTargetPlayer):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_ctf_friendlyflagpickedup'
	});
flagPickupFromStand = onFlagPickup:Filter(
	function(context)
		return context.PickedUpFromFlagStand;
	end
	);
flagPickupFromStandCarrierResponse = flagPickupFromStand:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_ctf\music_mp_ctf_flagpickedup_team_pos',
		ImpulseEvent = 'impulse_flag_pickup_from_stand'
	});
flagPickupFromStandHostileResponse = flagPickupFromStand:Target(PlayersWithDesignator):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_ctf\music_mp_ctf_flagpickedup_team_neg'
	});
flagPickupFromStandFriendlyResponse = flagPickupFromStand:Target(FriendlyToTargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_ctf\music_mp_ctf_flagpickedup_team_pos'
	});
function BuildFlagPickupFromStandNeutralResponse(teamName, sourceEvent)
	local globals = _G;
	globals[teamName .. "FlagTakenResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_ctf_' .. teamName .. 'teamflagtaken'
		});
end
flagPickupFromStandNeutralSelect = flagPickupFromStand:Select();
GenerateTeamSpecificNeutralResponses(flagPickupFromStandNeutralSelect, BuildFlagPickupFromStandNeutralResponse)
__OnFlagCarrierSpotted = Delegate:new();
onFlagCarrierSpotted = root:AddCallback(
	__OnFlagCarrierSpotted,
	function (context, carryingPlayer)
		context.TargetPlayer = carryingPlayer;
	end
	);
spottedAccumulator = root:CreatePlayerAccumulator();
carrierFlagCarrierSpottedResponse = onFlagCarrierSpotted:Target(TargetPlayer):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_ctf_carrierspotted'
	});
enemyFlagCarrierSpottedResponse = onFlagCarrierSpotted:Target(HostileToTargetPlayer):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_ctf_hostilecarrierspotted'
	});
onFlagCarrierSpottedIncrement = onFlagCarrierSpotted:PlayerAccumulator(
	spottedAccumulator,
	function(context)
		return context.TargetPlayer;
	end
	);
onPlayerDeath:ResetPlayerAccumulator(
	spottedAccumulator,
	function (context)
		return context.DeadPlayer;
	end
	);
function BuildCarrierSpottedNeutralResponse(teamName, sourceEvent)
	local globals = _G;
	globals[teamName .. "CarrierSpottedNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_ctf_' .. teamName .. 'teamcarrierspotted'
		});
end
carrierSpottedNeutralSelect = onFlagCarrierSpotted:Select();
GenerateTeamSpecificNeutralResponses(carrierSpottedNeutralSelect, BuildCarrierSpottedNeutralResponse)
function FlagDrivers(context)
	return context.FlagDrivers;
end
__OnFlagCapture = Delegate:new();
onFlagCapture = root:AddCallback(
	__OnFlagCapture,
	function (context, capturingPlayer, assistingPlayers, flagDrivers, carrierWasSpotted)
		context.TargetPlayer = capturingPlayer;
		context.MatchingPlayers = assistingPlayers;
		context.FlagDrivers = flagDrivers;
		context.CarrierWasSpotted = carrierWasSpotted;
		context.Designator = capturingPlayer:GetTeamDesignator();
	end
	);
flagCaptureScoreShelfResponse = onFlagCapture:Target(TargetAllPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'score_fanfare_flag_captured',
		TeamDesignator = DesignatorProperty
	});
flagCaptureTypeSelect = onFlagCapture:Select();
stealthFlagCaptureResponse = flagCaptureTypeSelect:Add(
	function(context)
		return not context.CarrierWasSpotted;
	end
	):Target(TargetPlayer):Response(
	{
		Medal = 'flag_stealth_capture'
	});
flagCaptureResponse = flagCaptureTypeSelect:Add():Target(TargetPlayer):Response(
	{
		Medal = 'flag_capture'
	})
flagCapturedFriendlyResponse = onFlagCapture:Target(PlayersWithDesignator):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_ctf_flagcaptured'
	});
if (disableFlagCaptureStinger == nil or disableFlagCaptureStinger == false) then
	flagCapturedFriendlyStingerResponse = onFlagCapture:Target(PlayersWithDesignator):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_ctf\music_mp_ctf_flagcapture_team_pos'
	});
end
onFlagCapture:ResetAccumulator(spottedAccumulator);
function BuildFlagCapturedNeutralResponse(teamName, sourceEvent)
	local globals = _G;
	globals[teamName .. "FlagCapturedNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_ctf_' .. teamName .. 'teamscored'
		});
end
flagCapturedNeutralSelect = onFlagCapture:Select();
GenerateTeamSpecificNeutralResponses(flagCapturedNeutralSelect, BuildFlagCapturedNeutralResponse)
flagCaptureAssistResponse = onFlagCapture:Target(MatchingPlayers):Response(
	{
		Medal = 'flag_capture_assist'
	});
flagDriverResponse = onFlagCapture:Target(FlagDrivers):Response(
	{
		Medal = 'flag_driver'
	});
multipleCapturesAccumulator = root:CreatePlayerAccumulator();
onMultipleCaptures = onFlagCapture:PlayerAccumulator(
	multipleCapturesAccumulator,
	function(context)
		return context.TargetPlayer;
	end
	);
onRoundStart:ResetAccumulator(multipleCapturesAccumulator);
threeFlagCapturesResponse = onFlagCapture:Filter(
	function(context)
		return multipleCapturesAccumulator:GetValue(context.TargetPlayer) == 3
	end
	):Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_ctf_flagcapturedspree3',
		Medal = 'flag_champion'
	});
twoFlagCapturesResponse = onFlagCapture:Filter(
	function(context)
		return multipleCapturesAccumulator:GetValue(context.TargetPlayer) == 2
	end
	):Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_ctf_flagcapturedspree2',
		Medal = 'flag_runner'
	});
flagCapturedHostileResponse = onFlagCapture:Target(PlayersWithoutDesignator):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_ctf_flagcapturedenemy'
	});
if (disableFlagCaptureStinger == nil or disableFlagCaptureStinger == false) then
	flagCapturedHostileStingerResponse = onFlagCapture:Target(PlayersWithoutDesignator):Response(
		{
			Sound = 'multiplayer\audio\music\130_mus_mp_ctf\music_mp_ctf_flagcapture_team_neg'
		});
end
onFlagCapture:Target(TargetPlayer):Response(
	{
		ImpulseEvent = 'impulse_flag_captured'
	});
__OnFlagAway = Delegate:new();
onFlagAway = root:AddCallback(
	__OnFlagAway,
	function (context, carryingPlayer)
		context.TargetPlayer = carryingPlayer;
	end
	);
dropSpamPreventionAccumulator = root:CreatePlayerAccumulator(juggleTimer);
dropsInARow = onFlagAway:PlayerAccumulator(
	dropSpamPreventionAccumulator,
	function(context)
		return context.TargetPlayer;
	end
	);
onPlayerDeath:ResetPlayerAccumulator(
	dropSpamPreventionAccumulator,
	function(context)
		return context.DeadPlayer;
	end
	);
onNonJuggleFlagDrop = dropsInARow:Filter(
	function(context)
		return dropSpamPreventionAccumulator:GetValue(context.TargetPlayer) <= 1;
	end
	);
flagAwayCarrierMusicResponse = onFlagAway:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_ctf\music_mp_ctf_flagcarrier_drop',
		ImpulseEvent = 'impulse_flag_dropped'
	});
__OnFlagReturned = Delegate:new();
onFlagReturned = root:AddCallback(
	__OnFlagReturned,
	function (context, players)
		context.MatchingPlayers = players;
	end
	);
onFlagReturned:ResetAccumulator(spottedAccumulator);
flagReturnSelect = onFlagReturned:Select();
flagNearReturn = flagReturnSelect:Add(
	function(context)
		return table.any(context.MatchingPlayers,
			function(player)
				return player:PlayerNearFriendlyFlag() and player:PlayerNearHostileFlagReturn()
			end
			);
	end
	);
flagNearReturnResponse = flagNearReturn:Target(MatchingPlayers):Response(
	{
		Medal = 'flag_goal_line_stand'
	});
flagReturnMedalResponse = flagReturnSelect:Add():Target(MatchingPlayers):Response(
	{
		Medal = 'flag_return'
	});
flagReturnedSelect = onFlagReturned:Select();
neutralFlagReturnedResponse = flagReturnedSelect:Add(
	function(context)
		return context.Engine:IsGameNeutralFlag();
	end
	):Target(TargetAllPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_ctf_flagreturnedneutralflag'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_ctf\music_mp_ctf_flagreturned_team_pos'	
	});
standardFlagReturn = flagReturnedSelect:Add();
flagReturnedReturnerResponse = standardFlagReturn:Target(MatchingPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_ctf_friendlyflagreturned'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_ctf\music_mp_ctf_flagreturned_team_pos'
	});
onOurFlagReturnedResponse = standardFlagReturn:Target(FriendlyToMatchingPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_ctf_friendlyflagreturned'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_ctf\music_mp_ctf_flagreturned_team_pos'
	});
onTheirFlagReturnedResponse = standardFlagReturn:Target(HostileToMatchingPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_ctf_hostileflagreturned'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_ctf\music_mp_ctf_flagreturned_team_neg'
	});
function BuildFlagReturnedNeutralResponse(teamName, sourceEvent)
	local globals = _G;
	globals[teamName .. "FlagReturnedNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_ctf_' .. teamName .. 'teamflagreturned'
		});
end
flagReturnNeutralSelect = standardFlagReturn:Select();
GenerateTeamSpecificNeutralResponses(flagReturnNeutralSelect, BuildFlagReturnedNeutralResponse)
flagNearReturnResponse:Target(MatchingPlayers):Response(
	{
		ImpulseEvent = 'impulse_flag_returned'
	});
flagReturnMedalResponse:Target(MatchingPlayers):Response(
	{
		ImpulseEvent = 'impulse_flag_returned'
	});
__OnFlagReset = Delegate:new();
onFlagReset = root:AddCallback(
	__OnFlagReset,
	function(context, playersFriendlyToReturnedFlag)
		context.MatchingPlayers = playersFriendlyToReturnedFlag;
	end
	);
onFlagReset:ResetAccumulator(spottedAccumulator);
flagResetSelect = onFlagReset:Select();
neutralFlagReset = flagResetSelect:Add(
	function(context)
		return context.Engine:IsGameNeutralFlag();
	end
	);
neutralFlagResetResponse = neutralFlagReset:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_ctf_flagresetteamflag'
	});
standardFlagReset = flagResetSelect:Add()
friendlyFlagReset = onFlagReset:Target(MatchingPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_ctf_friendlyflagreturned'
	});
hostileFlagReset = onFlagReset:Target(HostileToMatchingPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_ctf_hostileflagreturned'
	});
function BuildFlagResetNeutralResponse(teamName, sourceEvent)
	local globals = _G;
	globals[teamName .. "FlagResetNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_ctf_' .. teamName .. 'teamflagreset'
		});
end
flagResetNeutralSelect = standardFlagReturn:Filter(
	function(context)
		return not context.Engine:IsGameNeutralFlag();
	end 
	):Select();
GenerateTeamSpecificNeutralResponses(flagResetNeutralSelect, BuildFlagResetNeutralResponse)
flagKillTypeSelect = onEnemyPlayerKill:Select();
onStoppedShort = flagKillTypeSelect:Add(
	function(context)
		return context.DeadPlayer:IsFlagCarrier() and context.DeadPlayer:PlayerNearFriendlyFlagReturn();
	end
	):Target(KillingPlayer):Response(
	{
		Medal = 'flag_stopped_short',
	});
onFlagJoust = flagKillTypeSelect:Add(
	function(context)
		return context.DeadPlayer:IsFlagCarrier() and context.KillingPlayer:IsFlagCarrier()
	end
	):Target(KillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_ctf_flagjoust',
		Medal = 'flag_joust',
		ImpulseEvent = 'impulse_flag_kill'
	});
onFlagCarrierKill = flagKillTypeSelect:Add(
	function(context)
		return context.DeadPlayer:IsFlagCarrier()
	end
	):Target(KillingPlayer):Response(
	{
		Medal = 'flag_carrier_kill',
		Sound = 'multiplayer\audio\announcer\announcer_ctf_flagcarrierkill'
	});
onFlagKill = flagKillTypeSelect:Add(
	function(context)
		return context.KillingPlayer:IsFlagCarrier()
	end
	):Target(KillingPlayer):Response(
	{
		Medal = 'flag_kill',
		ImpulseEvent = 'impulse_flag_kill'
	});
onFlagDefense = flagKillTypeSelect:Add(
	function(context)
		return context.DeadPlayer:PlayerNearHostileFlag() and not context.DeadPlayer:IsFlagCarrier();
	end
	):Target(KillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_ctf_flagdefense',
		Medal = 'flag_defense'
	});
onStoppedShort:Target(KillingPlayer):Response(
	{	
		ImpulseEvent = 'impulse_flag_carrier_kill'
	});
onFlagJoust:Target(KillingPlayer):Response(
	{	
		ImpulseEvent = 'impulse_flag_carrier_kill'
	});
onFlagCarrierKill:Target(KillingPlayer):Response(
	{	
		ImpulseEvent = 'impulse_flag_carrier_kill'
	});
onFlagCarrierDeath = onEnemyPlayerKill:Filter(
	function(context)
		return context.DeadPlayer:IsFlagCarrier()
	end
	);
flagCarrierKilledCarrierResponse = onFlagCarrierDeath:Target(DeadPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_ctf\music_mp_ctf_flagcarrier_death'
	});
flagCarrierKillTeammateResponse = onFlagCarrierDeath:Target(FriendlyToDeadPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_ctf\music_mp_ctf_flagcarrier_death'
	});
flagCarrierKilledKillerResponse = onFlagCarrierDeath:Target(KillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_ctf\music_mp_ctf_flagcarrier_kill'
	});	
flagCarrierProtectedResponse = onFlagCarrierProtected:Target(KillingPlayer):Response(
	{
		Medal = 'flag_carrier_protected'
	});
