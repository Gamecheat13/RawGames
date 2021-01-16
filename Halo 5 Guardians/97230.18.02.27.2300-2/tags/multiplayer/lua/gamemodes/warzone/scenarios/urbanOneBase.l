
__OnWarzoneIntro = Delegate:new();
onWarzoneIntro = root:AddCallback(
	__OnWarzoneIntro
	);
__OnWarzoneBaseIntro = Delegate:new();
onWarzoneBaseIntro = root:AddCallback(
	__OnWarzoneBaseIntro
	);
__OnWarzoneOneBaseIntro = Delegate:new();
onWarzoneOneBaseIntro = root:AddCallback(
	__OnWarzoneOneBaseIntro
	);
warzoneOneBaseIntroResponseAtt = onWarzoneOneBaseIntro:Target(PlayersOnAttackingTeam):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasearcintroatt'
	});
warzoneOneBaseIntroResponseDef = onWarzoneOneBaseIntro:Target(PlayersOnDefendingTeam):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasearcintrodef'
	});
__OnWarzoneSpawned = Delegate:new();
onWarzoneSpawned = root:AddCallback(
	__OnWarzoneSpawned
	);
warzoneBaseIntroSpawnedResponseAtt = onWarzoneSpawned:Target(PlayersOnAttackingTeam):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasearcstartatt'
	});
warzoneBaseIntroSpawnedResponseDef = onWarzoneSpawned:Target(PlayersOnDefendingTeam):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasearcstartdef'
	});
onBaseCapturedSelect = onBaseCaptured:Select();
onUrbanOneBaseGarageBaseCaptured = onBaseCapturedSelect:Add(BaseIsNamed('urban_onebase_garage'));
onUrbanOneBaseGarageBaseCapturedCapturing = onUrbanOneBaseGarageBaseCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'urban_onebase_garage_captured_fanfare',
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_arcgaragecapturedfriendly'
	}):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasenextcapturearmoryatt'
	});
onUrbanOneBaseGarageBaseCapturedFriendly = onUrbanOneBaseGarageBaseCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'urban_onebase_garage_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_arcgaragecapturedfriendly'
	}):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasenextcapturearmoryatt'
	});
onUrbanOneBaseGarageBaseCapturedHostile = onUrbanOneBaseGarageBaseCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'urban_onebase_garage_captured_enemy_fanfare',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasegaragelost'
	}):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasenextcapturearmorydef'
	});
onUrbanOneBaseArmoryCaptured = onBaseCapturedSelect:Add(BaseIsNamed('urban_onebase_armory'));
onUrbanOneBaseArmoryCapturedCapturing = onUrbanOneBaseArmoryCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'urban_onebase_armory_captured_fanfare',
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_armorycapturedfriendly'
	});
onUrbanOneBaseArmoryCapturedFriendly = onUrbanOneBaseArmoryCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'urban_onebase_armory_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_armorycapturedfriendly'
	});
onUrbanOneBaseArmoryCapturedHostile = onUrbanOneBaseArmoryCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'urban_onebase_armory_captured_enemy_fanfare',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasearmorylost'
	});
defendResponses =
{	
	{
		name = "attacker_homebase",
		responses = 
		{
			beginResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackhomebase'
			},
			successResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackdefendedhomebase'
			},
		},
	},
	{
		name = "defender_homebase",
		responses = 
		{
			beginResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackhomebase'
			},
			successResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackdefendedhomebase'
			},
		},
	},
}
	