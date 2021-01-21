


--
-- Snowzone-Specific Warzone Intro
--

__OnWarzoneIntro = Delegate:new();

onWarzoneIntro = root:AddCallback(
	__OnWarzoneIntro
	);
	
__OnWarzoneBaseIntro = Delegate:new();

onWarzoneBaseIntro = root:AddCallback(
	__OnWarzoneBaseIntro
	);

--
-- Snowzone One Base Intro
--

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


--
-- Initial Spawn
--

__OnWarzoneSpawned = Delegate:new();

onWarzoneSpawned = root:AddCallback(
	__OnWarzoneSpawned
	);

warzoneBaseIntroSpawnedResponseAtt = onWarzoneSpawned:Target(PlayersOnAttackingTeam):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebaseszstartatt'
	});


warzoneBaseIntroSpawnedResponseDef = onWarzoneSpawned:Target(PlayersOnDefendingTeam):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebaseszstartdef'
	});

--
-- Snowzone Base Captured Events
--
	
onBaseCapturedSelect = onBaseCaptured:Select();



--
-- Snowzone One-Base Captured Events
--

-- The Fortress

onSnowzoneOneBaseFortressBaseCaptured = onBaseCapturedSelect:Add(BaseIsNamed('snowzone_onebase_fortress'));


onSnowzoneOneBaseFortressBaseCapturedCapturing = onSnowzoneOneBaseFortressBaseCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'snowzone_onebase_fortress_captured_fanfare',
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_fortresscapturedfriendly'
	}):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasenextcapturearmoryatt'
	});

onSnowzoneOneBaseFortressBaseCapturedFriendly = onSnowzoneOneBaseFortressBaseCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'snowzone_onebase_fortress_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_fortresscapturedfriendly'
	}):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasenextcapturearmoryatt'
	});

onSnowzoneOneBaseFortressCapturedHostile = onSnowzoneOneBaseFortressBaseCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'snowzone_onebase_fortress_captured_enemy_fanfare',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasefortresslost'
	}):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasenextcapturearmorydef'
	});

-- The Armory

onSnowzoneOneBaseArmoryCaptured = onBaseCapturedSelect:Add(BaseIsNamed('snowzone_onebase_armory'));

onSnowzoneOneBaseArmoryCapturedCapturing = onSnowzoneOneBaseArmoryCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'snowzone_onebase_armory_captured_fanfare',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_armorycapturedfriendly'
	});

onSnowzoneOneBaseArmoryCapturedFriendly = onSnowzoneOneBaseArmoryCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'snowzone_onebase_armory_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_armorycapturedfriendly'
	});

onSnowzoneOneBaseArmoryCapturedHostile = onSnowzoneOneBaseArmoryCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'snowzone_onebase_armory_captured_enemy_fanfare',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasearmorylost'
	});



--
-- Defend
--

defendResponses =
{	
	-- Blue Home Base
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
	
	-- Red Home Base
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
	